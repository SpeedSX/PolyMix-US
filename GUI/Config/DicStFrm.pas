unit DicStFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DB, PmProcess, DbClient,
  DataHlp, DBCtrls, Variants, MyDBGridEh, DBGridEh, GridsEh, Mask,
  DBGridEhGrouping;

type
  TStructType = (stDic, stService);
  TCloseMode = (cmClose, cmOkCancel);

  TStructForm = class(TForm)
    dgStruct: TMyDBGridEh;
    Label1: TLabel;
    btOk: TButton;
    btAdd: TButton;
    btDelete: TButton;
    lbFieldStatus: TLabel;
    btCancelOrClose: TButton;
    cbFieldType: TComboBox;
    lbFieldType: TLabel;
    cbFieldStatus: TComboBox;
    lbDisplayFormat: TLabel;
    lbEditFormat: TLabel;
    edDisplayFormat: TDBEdit;
    edEditFormat: TDBEdit;
    cbNotForCopy: TDBCheckBox;
    cbGetText: TDBCheckBox;
    cbCalcTotal: TDBCheckBox;
    cmbLookupDic: TDBLookupComboBox;
    lbLookupDic: TLabel;
    lbLookupKey: TLabel;
    cmbLookupKey: TDBLookupComboBox;
    dsDics: TDataSource;
    procedure btAddClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure dgStructGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbFieldTypeChange(Sender: TObject);
    procedure cbFieldStatusChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FSrc, FClonedSrc: TDataSource;
    FClonedStructData: TClientDataSet;
    FirstActive: boolean;
    procedure EnableLookup(Enable: boolean);
    procedure FieldTypeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure LengthGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure PrecisionGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure StructAfterScroll(DataSet: TDataSet);
    procedure SetType(ft: integer);
    procedure SetStatus(fs: integer);
//    procedure SetVirtualStatus;
    procedure SetDataSrc(Src: TDataSource);
    procedure UpdateLookup;
  public
    StructData: TClientDataSet;
    StructType: TStructType;
//    PredefFieldsStr: string;
    CloseMode: TCloseMode;
    //DicDataSource: TDataSource;
    function SetupStructData: boolean;
    procedure ResetStructData;
  end;

var
  StructForm: TStructForm;

const
  Headers: array[TStructType] of string = ('Структура данных справочника',
    'Структура данных процесса');

function ExecStructForm(StructData: TClientDataSet; StType: TStructType;
  CloseMode: TCloseMode): integer;

implementation

{$R *.DFM}

uses RDialogs, RDBUtils, DicObj, PmConfigManager;

const
  cbftInteger = 0;
  cbftBCD = 1;
  cbftString = 2;
  cbftBoolean = 3;
  cbftFloat = 4;
  cbftSmallInt = 5;
  cbftDateTime = 6;
  cbftGraphic = 7;
  cbftMemo = 8;
  cbftDictionary = 9;
  cbftProcess = 10;
  cbftProcessGrid = 11; // not implemented yet
  cbftUnknown = 12;

  cbfsData = 0;
  cbfsVirtual = 1;
  cbfsCalculated = 2;
  cbfsIndependent = 3;
  cbfsUnknown = -1;

function ExecStructForm(StructData: TClientDataSet; StType: TStructType;
  CloseMode: TCloseMode): integer;
begin
  Application.CreateForm(TStructForm, StructForm);
  try
    StructData.First;
    StructForm.StructData := StructData;
    StructForm.StructType := StType;
    StructForm.CloseMode := CloseMode;
    //StructForm.DicDataSource := DicDataSource;
    Result := StructForm.ShowModal;
  finally
    StructForm.Free;
  end;
end;

procedure TStructForm.ResetStructData;
begin
  with StructData do try
    AfterScroll := nil;
    FieldByName('FieldType').OnGetText := nil;
    FieldByName('Length').OnGetText := nil;
    FieldByName('Precision').OnGetText := nil;
  except end;
end;

function TStructForm.SetupStructData: boolean;
begin
  Result := false;
  try
    with StructData do
    begin
      AfterScroll := StructAfterScroll;
      FieldByName('FieldType').OnGetText := FieldTypeGetText;
      FieldByName('Length').OnGetText := LengthGetText;
      FieldByName('Precision').OnGetText := PrecisionGetText;
      Result := true;
    end;
  except
    RusMessageDlg('Ошибка при открытии таблицы для конструктора', mtError, [mbOk], 0);
  end;
end;

function GetItemIndexForType(ft: integer): integer;
begin
  if ft = Ord(ftInteger) then Result := cbftInteger
  else if ft = Ord(ftSmallInt) then Result := cbftSmallInt
  else if ft = Ord(ftBCD) then Result := cbftBCD
  else if (ft = Ord(ftFloat)) or (ft = Ord(ftCurrency)) then Result := cbftFloat
  else if ft = Ord(ftString) then Result := cbftString
  else if ft = Ord(ftBoolean) then Result := cbftBoolean
  else if ft = Ord(ftDateTime) then Result := cbftDateTime
  else if ft = Ord(ftBlob) then Result := cbftGraphic
  else if ft = Ord(ftMemo) then Result := cbftMemo
  else if ft = Ord(ftDictionary) then Result := cbftDictionary
  else if ft = Ord(ftProcess) then Result := cbftProcess
  else if ft = Ord(ftProcessGrid) then Result := cbftProcessGrid
  else Result := cbftUnknown;
end;

function GetItemIndexForStatus(fs: integer): integer;
begin
  if fs = ftData then Result := cbfsData
  else if fs = ftVirtual then Result := cbfsVirtual
  else if fs = ftIndependent then Result := cbfsIndependent
  else if fs = ftCalculated then Result := cbfsCalculated
  else Result := cbfsUnknown;
end;

procedure TStructForm.FieldTypeGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  try
    Text := cbFieldType.Items[GetItemIndexForType(Sender.AsInteger)];
  except
    Text := cbFieldType.Items[cbftUnknown];
  end;
end;

procedure TStructForm.PrecisionGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  try
    if Sender.DataSet['FieldType'] = ftBCD then
      Text := IntToStr(Sender.AsInteger)
    else
     Text := '--';
  except
    Text := '--'
  end;
end;

procedure TStructForm.LengthGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  try
    if (Sender.DataSet['FieldType'] = ftBCD) or (Sender.DataSet['FieldType'] = ftString) then
      Text := IntToStr(Sender.AsInteger)
    else
      Text := '--';
  except
    Text := '--';
  end;
end;

procedure TStructForm.StructAfterScroll(DataSet: TDataSet);
var
  ft: integer;
  pf: boolean;
begin
  try
    if not VarIsNull(DataSet['FieldType']) then begin
      ft := DataSet.FieldByName('FieldType').AsInteger;
      cbFieldType.ItemIndex := GetItemIndexForType(ft);
    end;
  except
    cbFieldType.ItemIndex := cbftUnknown;
  end;
  if not VarIsNull(DataSet['FieldName']) then begin
    pf := NvlBoolean(DataSet['Predefined']);
    btDelete.Enabled := not pf;
    cbFieldStatus.Enabled := not pf;
    cbFieldType.Enabled := not pf;
    cbNotForCopy.Enabled := not pf;
    cbGetText.Enabled := not pf;
  end;
  try
    if (StructType = stService) and not VarIsNull(DataSet['FieldStatus']) then begin
      ft := DataSet['FieldStatus'];
      cbFieldStatus.ItemIndex := GetItemIndexForStatus(ft);
    end;
  except
    cbFieldStatus.ItemIndex := cbfsUnknown;
  end;
  UpdateLookup;
end;

procedure TStructForm.btAddClick(Sender: TObject);
begin
  StructData.Append;
end;

procedure TStructForm.btDeleteClick(Sender: TObject);
begin
  if not StructData.IsEmpty then StructData.Delete;
end;

procedure TStructForm.dgStructGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  try
    if (Column.Field <> nil) and (not (gdSelected in State) or not dgStruct.Focused) then
    begin
      if Column.Field.DataSet['Predefined'] then
        Background := clInfoBk;
      if Column.Field.DataSet.FindField('FieldStatus') <> nil then
      begin
        if (Column.Field.DataSet['FieldStatus'] = ftVirtual) then
          AFont.Color := clGreen
        else if (Column.Field.DataSet['FieldStatus'] = ftCalculated) then
        begin
          if VarIsNull(Column.Field.DataSet['LookupDicID']) or VarIsNull(Column.Field.DataSet['LookupKeyField']) then
            AFont.Color := clRed
          else
            AFont.Color := clNavy;
        end;
      end;
    end;
  except end;
end;

procedure TStructForm.SetDataSrc(Src: TDataSource);
begin
  dgStruct.DataSource := Src;
  if StructType = stService then begin
    edDisplayFormat.DataSource := Src;
    edEditFormat.DataSource := Src;
    cbNotForCopy.Visible := true;
    cbNotForCopy.DataSource := Src;
    cbGetText.Visible := true;
    cbGetText.DataSource := Src;
    cbCalcTotal.Visible := true;
    cbCalcTotal.DataSource := Src;

    cmbLookupDic.DataSource := Src;
    //cmbLookupDic.ListSource := DicDataSource;
    cmbLookupKey.DataSource := Src;
    cmbLookupKey.ListSource := FClonedSrc;
    cmbLookupDic.Visible := true;
    cmbLookupKey.Visible := true;
    lbLookupDic.Visible := true;
    lbLookupKey.Visible := true;
  end else begin
    cbNotForCopy.Visible := false;
    cbNotForCopy.DataSource := nil;
    cbGetText.Visible := false;
    cbGetText.DataSource := nil;
    cbCalcTotal.Visible := false;
    cbCalcTotal.DataSource := nil;

    cmbLookupDic.DataField := 'ReferenceID';
    cmbLookupDic.DataSource := Src;
    //cmbLookupDic.ListSource := DicDataSource;
    cmbLookupKey.DataSource := nil;
    cmbLookupDic.Visible := false;
    cmbLookupKey.Visible := false;
    lbLookupDic.Visible := false;
    lbLookupKey.Visible := false;
  end;
end;

procedure TStructForm.FormActivate(Sender: TObject);
var
  ss: boolean;
begin
  if FirstActive then begin
    Caption := Headers[StructType];
    ss := StructType = stService;
    lbFieldStatus.Visible := ss;
    cbFieldStatus.Visible := ss;
    lbDisplayFormat.Visible := ss;
    edDisplayFormat.Visible := ss;
    lbEditFormat.Visible := ss;
    edEditFormat.Visible := ss;
    if CloseMode = cmClose then begin
      btOk.Visible := false;
      btCancelOrClose.Caption := 'Закрыть';
      //btCancelOrClose.Default := true; не надо, а то срабатывает на выборе из комбобокса
      btCancelOrClose.ModalResult := mrOk;
    end else begin
      btOk.Visible := true;
      btCancelOrClose.Default := false;
      //btOk.Default := true;  не надо, а то срабатывает на выборе из комбобокса
      btOk.ModalResult := mrOk;
      btCancelOrClose.ModalResult := mrCancel;
      btCancelOrClose.Caption := 'Отмена';
    end;
    cbFieldType.ItemIndex := cbftUnknown;
    cbFieldStatus.ItemIndex := cbfsUnknown;
    SetupStructData;
    FSrc := TDataSource.Create(nil);
    FSrc.DataSet := StructData;
    if StructType = stService then begin
      FClonedStructData := TClientDataSet.Create(nil);
      FClonedStructData.CloneCursor(StructData, true);
      FClonedStructData.Filter := '((FieldType=' + IntToStr(Ord(ftInteger)) + ') or '
        + '(FieldType=' + IntToStr(Ord(ftSmallInt)) + ')) and (FieldStatus <> '
        + IntToStr(ftCalculated) + ')';
      FClonedStructData.Filtered := true;
      FClonedSrc := TDataSource.Create(nil);
      FClonedSrc.DataSet := FClonedStructData;
    end;
    SetDataSrc(FSrc);
    dgStruct.Columns[1].Visible := ss;
    StructAfterScroll(StructData);  // начальная установка элементов управления
    FirstActive := false;
  end;
end;

procedure TStructForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ResetStructData;
  if Assigned(FSrc) then FSrc.Free;
  if Assigned(FClonedSrc) then FClonedSrc.Free;
  if Assigned(FClonedStructData) then FClonedStructData.Free;
end;

procedure TStructForm.SetType(ft: integer);
begin
  if not (StructData.State in [dsInsert, dsEdit]) then StructData.Edit;
  StructData['FieldType'] := ft;
end;

procedure TStructForm.SetStatus(fs: integer);
begin
  if not (StructData.State in [dsInsert, dsEdit]) then StructData.Edit;
  StructData['FieldStatus'] := fs;
  if (fs = cbfsCalculated) or (fs = cbfsVirtual) then StructData['NotForCopy'] := true;
end;

procedure TStructForm.cbFieldTypeChange(Sender: TObject);
begin
  if cbFieldType.ItemIndex = cbftInteger then SetType(ord(ftInteger))
  else if cbFieldType.ItemIndex = cbftSmallInt then SetType(ord(ftSmallInt))
  else if cbFieldType.ItemIndex = cbftBCD then SetType(ord(ftBCD))
  else if cbFieldType.ItemIndex = cbftFloat then SetType(ord(ftFloat))
  else if cbFieldType.ItemIndex = cbftString then SetType(ord(ftString))
  else if cbFieldType.ItemIndex = cbftBoolean then SetType(ord(ftBoolean))
  else if cbFieldType.ItemIndex = cbftDateTime then SetType(ord(ftDateTime))
  else if cbFieldType.ItemIndex = cbftGraphic then SetType(ord(ftBlob))
  else if cbFieldType.ItemIndex = cbftMemo then SetType(ord(ftMemo))
  else if cbFieldType.ItemIndex = cbftDictionary then SetType(ord(ftDictionary))
  else if cbFieldType.ItemIndex = cbftProcess then SetType(ord(ftProcess))
  else if cbFieldType.ItemIndex = cbftProcessGrid then SetType(ord(ftProcessGrid))
  else if cbFieldType.ItemIndex = cbftUnknown then begin
    RusMessageDlg('Необходимо указать тип поля', mtError, [mbOk], 0);
    try
      cbFieldType.ItemIndex := GetItemIndexForType(StructData['FieldType']);
    except
      cbFieldType.ItemIndex := cbftInteger;
    end;
  end;
  StructAfterScroll(StructData);
end;

procedure TStructForm.cbFieldStatusChange(Sender: TObject);
begin
  if cbFieldStatus.ItemIndex = cbfsData then SetStatus(ftData)
  else if cbFieldStatus.ItemIndex = cbfsVirtual then SetStatus(ftVirtual)
  else if cbFieldStatus.ItemIndex = cbfsCalculated then SetStatus(ftCalculated)
  else if cbFieldStatus.ItemIndex = cbfsIndependent then SetStatus(ftIndependent)
  else if cbFieldStatus.ItemIndex = cbfsUnknown then begin
    RusMessageDlg('Необходимо указать поведение поля', mtError, [mbOk], 0);
    try
      cbFieldStatus.ItemIndex := GetItemIndexForStatus(StructData['FieldStatus']);
    except
      cbFieldStatus.ItemIndex := cbfsData;
    end;
  end;
  UpdateLookup;
end;

procedure TStructForm.EnableLookup(Enable: boolean);
begin
  cmbLookupDic.Enabled := Enable;
  cmbLookupKey.Enabled := Enable;
  lbLookupKey.Enabled := Enable;
  lbLookupDic.Enabled := Enable;
  if StructType = stDic then
  begin
    cmbLookupDic.Visible := Enable;
    lbLookupDic.Visible := Enable;
  end;
end;

procedure TStructForm.FormCreate(Sender: TObject);
begin
  FirstActive := true;
  dsDics.DataSet := TConfigManager.Instance.DictionaryList.DataSet;
end;

procedure TStructForm.UpdateLookup;
var ft: integer;
begin
  try
    if (StructType = stService) and not VarIsNull(StructData['FieldStatus']) then begin
      ft := StructData['FieldStatus'];
      EnableLookup(ft = ftCalculated);
    end;
  except
    EnableLookup(false);
  end;
  if (StructType = stDic) then
    EnableLookup(NvlInteger(StructData['FieldType']) = ftDictionary);
end;

end.
