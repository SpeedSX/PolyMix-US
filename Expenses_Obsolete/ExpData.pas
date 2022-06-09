unit ExpData;

interface

uses
  SysUtils, Classes, ADODB, DBClient, Provider, DB, Variants,

  PmDatabase;

type
  TExpQueryIndex = (qiComExp, qiOwnExp);

  TExpDM = class(TDataModule, IRCDataModule)
    dsComExp: TDataSource;
    dsOwnExp: TDataSource;
    aqComExp: TADOQuery;
    aqComExpN: TAutoIncField;
    aqComExpExpDate: TDateTimeField;
    aqComExpExpKind: TIntegerField;
    aqComExpExpOther: TStringField;
    aqComExpExpAddOther: TStringField;
    aqComExpCostUSD: TBCDField;
    aqComExpCostGrn: TBCDField;
    aqComExpOwnExp: TBooleanField;
    aqOwnExp: TADOQuery;
    aqOwnExpN: TAutoIncField;
    aqOwnExpExpDate: TDateTimeField;
    aqOwnExpExpKind: TIntegerField;
    aqOwnExpExpOther: TStringField;
    aqOwnExpExpAddOther: TStringField;
    aqOwnExpCostUSD: TBCDField;
    aqOwnExpCostGrn: TBCDField;
    aqOwnExpOwnExp: TBooleanField;
    pvOwnExp: TDataSetProvider;
    pvComExp: TDataSetProvider;
    cdOwnExp: TClientDataSet;
    cdOwnExpN: TAutoIncField;
    cdOwnExpExpDate: TDateTimeField;
    cdOwnExpExpKind: TIntegerField;
    cdOwnExpExpOther: TStringField;
    cdOwnExpExpAddOther: TStringField;
    cdOwnExpCostUSD: TBCDField;
    cdOwnExpCostGrn: TBCDField;
    cdOwnExpOwnExp: TBooleanField;
    cdComExp: TClientDataSet;
    cdComExpN: TAutoIncField;
    cdComExpExpDate: TDateTimeField;
    cdComExpExpKind: TIntegerField;
    cdComExpExpOther: TStringField;
    cdComExpExpAddOther: TStringField;
    cdComExpCostUSD: TBCDField;
    cdComExpCostGrn: TBCDField;
    cdComExpOwnExp: TBooleanField;
    aspComExpToUSD: TADOStoredProc;
    cdComExpExpKindLookup: TStringField;
    cdOwnExpExpKindLookup: TStringField;
    procedure cdComExpExpOtherChange(Sender: TField);
    procedure cdOwnExpNewRecord(DataSet: TDataSet);
    procedure cdComExpCostUSDChange(Sender: TField);
    procedure cdComExpCostGrnChange(Sender: TField);
    procedure cdOwnExpExpKindLookupGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
  private
    Con: TAdoConnection;
    DisableChange: boolean;
    procedure SetConnection(_Con: TADOConnection);
  public
    cdComExpKind, cdOwnExpKind: TClientDataSet;
    procedure SetupExpenses(_cdComExpKind, _cdOwnExpKind: TClientDataSet);
    function Connected: boolean;
    function InTransaction: boolean;
    procedure BeginTrans;
    procedure CommitTrans;
    procedure RollbackTrans;
    function FindRangeLines: boolean;
    property Connection: TADOConnection read Con write SetConnection;
    procedure ExpRefresh(qi: TExpQueryIndex; MakeActive: boolean);
    procedure SetExpKind(Index: TExpQueryIndex; Code: integer;
      MakeActive, DisableEmpty: boolean);
    procedure OpenDataSet(DataSet: TDataSet);
  end;

var
  ExpDM: TExpDM;

procedure InitExpenses(Con: TADOConnection);

implementation

uses Forms, ExpnsFrm, RDBUtils, DataHlp, ADOError;

const
  ExpRangeMacro = '@@@RANGE';

var
  ExpRangeLines: array[TExpQueryIndex] of integer;
  ExpRangeFields: array[TExpQueryIndex] of string;

{$R *.dfm}

procedure InitExpenses(Con: TADOConnection);
begin
  Application.CreateForm(TExpDM, ExpDM);
  ExpDM.Connection := Con;
end;

procedure TExpDM.SetConnection(_Con: TADOConnection);
begin
  Con := _Con;
  aqOwnExp.Connection := Con;
  aqComExp.Connection := Con;
  aspComExpToUSD.Connection := Con;
end;

procedure TExpDM.SetupExpenses(_cdComExpKind, _cdOwnExpKind: TClientDataSet);
begin
  cdComExpKind := _cdComExpKind;
  cdOwnExpKind := _cdOwnExpKind;
  cdComExp.FieldByName('ExpKindLookup').LookupDataSet := cdComExpKind;
  cdOwnExp.FieldByName('ExpKindLookup').LookupDataSet := cdOwnExpKind;
end;

function TExpDM.Connected: boolean;
begin
  if Con <> nil then Result := Con.Connected else Result := false;
end;

function TExpDM.InTransaction: boolean;
begin
  if Con <> nil then Result := Con.InTransaction else Result := false;
end;

procedure TExpDM.BeginTrans;
begin
  if Con <> nil then Con.BeginTrans;
end;

procedure TExpDM.CommitTrans;
begin
  if Con <> nil then Con.CommitTrans;
end;

procedure TExpDM.RollbackTrans;
begin
  if Con <> nil then Con.RollbackTrans;
end;

procedure TExpDM.cdComExpExpOtherChange(Sender: TField);
begin
  try
    Sender.DataSet['ExpKind'] := 0;
  except end;
end;

procedure TExpDM.cdOwnExpNewRecord(DataSet: TDataSet);
begin
  DataSet['OwnExp'] := DataSet = cdOwnExp;
  DataSet['ExpKind'] := 1;
end;

procedure TExpDM.cdComExpCostUSDChange(Sender: TField);
begin
  if DisableChange then Exit;
  DisableChange := true;
  try
    if Sender.IsNull then Exit;
    Sender.DataSet.Edit;
    Sender.DataSet['CostGrn'] := null;
  finally
    DisableChange := false;
  end;
  if Assigned(ExpenseForm) then ExpenseForm.UpdateItogos;
end;

procedure TExpDM.cdComExpCostGrnChange(Sender: TField);
begin
  if DisableChange then Exit;
  DisableChange := true;
  try
    if Sender.IsNull then Exit;
    Sender.DataSet.Edit;
    Sender.DataSet['CostUSD'] := null;
  finally
    DisableChange := false;
  end;
  if Assigned(ExpenseForm) then ExpenseForm.UpdateItogos;
end;

function TExpDM.FindRangeLines: boolean;

  function DoFind(Lines: TStrings; Index: TExpQueryIndex): boolean;
    // Syntax: @@@RANGE DateField
    // ƒл€ просчетов и заказов Datefield не используетс€ -
    // там запрос с ограничением диапазона строитс€ сложнее
  begin
    Result := FindSQLMacroField(Lines, ExpRangeMacro, ExpRangeLines[Index],
      ExpRangeFields[Index]);
  end;

begin
  Result := DoFind(aqComExp.SQL, qiComExp) and DoFind(aqOwnExp.SQL, qiOwnExp);
end;

procedure TExpDM.ExpRefresh(qi: TExpQueryIndex; MakeActive: boolean);
var
  N: integer;
  cd: TDataSet;
  aq: TADOQuery;
begin
  if qi = qiComExp then begin
    cd := ExpDM.cdComExp;
    aq := ExpDM.aqComExp;
  end else begin
    cd := ExpDM.cdOwnExp;
    aq := ExpDM.aqOwnExp;
  end;
  if cd.Active then
    try N := cd['N'] except N := -1; end
  else
    N := -1;
  cd.DisableControls;
  try
    SetViewRangeFields(false, false, aq, cd, 'N', ExpRangeLines[qi], ExpRangeFields[qi]);
    if MakeActive then OpenDataSet(cd);
    if (N <> -1) and cd.Active then cd.Locate('N', N, []);
  finally
    cd.EnableControls;
  end;
end;

procedure TExpDM.SetExpKind(Index: TExpQueryIndex; Code: integer;
  MakeActive, DisableEmpty: boolean);
var
  i: integer;
  wl: string;
  Key: string;
  dq: TADOQuery;
  cd: TDataSet;
begin
  if Index = qiComExp then begin
    dq := ExpDM.aqComExp;
    cd := ExpDM.cdComExp;
  end else begin
    dq := ExpDM.aqOwnExp;
    cd := ExpDM.cdOwnExp;
  end;
  with cd do begin
    if not Active or isEmpty then i := 0
    else
      try
        Key := 'N';
        i := FieldByName(Key).asInteger;
      except i := 0; end;
    try
      DisableControls;
      Active := false;
      // ≈сли в предыдущих строках уже есть WHERE, то условие добавл€етс€ с помощью AND
      // ќдна дл€ выбора категории расходов - личные или нет, друга€ - дл€ диапазона дат
      try
        if (Pos('where', dq.SQL[ExpRangeLines[Index] - 1]) <> 0) or
           (Pos('WHERE', dq.SQL[ExpRangeLines[Index] - 1]) <> 0) or
           (Pos('where', dq.SQL[ExpRangeLines[Index]]) <> 0) or
           (Pos('WHERE', dq.SQL[ExpRangeLines[Index]]) <> 0) then wl := 'and '
        else wl := 'where ';
      except wl := 'where '; end;
      if Code <> -1 then begin      // -1 означает отключение фильтрации по типу расхода
        dq.SQL[ExpRangeLines[Index] + 1] := wl + 'ExpKind = ' + IntToStr(Code);
      end else
        dq.SQL[ExpRangeLines[Index] + 1] := '';

      if MakeActive then
        begin
          OpenDataSet(cd);
          if (i = 0) or not Locate(Key, i, []) then First;
        end;
    finally
      EnableControls;
      if Active and DisableEmpty then
        if IsEmpty then DisableControls else ReEnableControls(dq);
    end;
  end;
end;

procedure TExpDM.cdOwnExpExpKindLookupGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
var
  dq: TDataSet;
begin
  try
    dq := Sender.DataSet;
    if VarIsNull(dq['ExpOther']) then Text := Sender.AsString
    else Text := Sender.AsString + dq['ExpOther'];
  except end;
end;

procedure TExpDM.OpenDataSet(DataSet: TDataSet);
begin
  RemoteControl.OpenDataSet(DataSet);
end;

end.
