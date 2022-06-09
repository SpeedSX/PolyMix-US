unit fProdBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEh, MyDBGridEh, DB, DBTables, ImgList,

  DicObj, PmProcess, PmProcessCfg, PmExecCode, PmProcessEntity, fBaseFrame, ExtCtrls;

type
  TProductionBaseFrame = class(TBaseFrame)
    imSrvState: TImageList;
    imOrderState: TImageList;
  private
    { Private declarations }
  protected
    FStateCodeList, FStateTextList: TStringList;
    FOrderStateCodeList, FOrderStateTextList: TStringList;
    FOnScriptError: TScriptError;
    procedure CreateStateLists;
    // true если код выполнился успешно
    function ExecGridCode(ScriptFieldName: string; dg: TMyDBGridEh;
      _ProcessEntity: TProcessEntity): boolean;
    // Собирает поля столбцов для экспорта
    function GetColumnsFieldList(dg: TDBGridEh): string;
    function GetProcessStateColor(ExecState: integer{cd: TDataSet}): TColor;
  public
    property OnScriptError: TScriptError read FOnScriptError write FOnScriptError;
  end;

  TStateImages = class
  public
    class procedure CreateProcessStateLists(imSrvState: TImageList;
      var FStateCodeList, FStateTextList: TStringList);
    class procedure CreateOrderStateLists(imOrderState: TImageList;
     var FOrderStateCodeList, FOrderStateTextList: TStringList);
  end;

implementation

uses JvInterpreter, StdDic, RDBUtils, DateUtils, PmStates, ColorLst,
  PmConfigManager;

{$R *.dfm}

type
  TGetColumnsCode = class(TCode)
  protected
    procedure DoPrgGetValue(Sender: TObject; Identifer: String;
      var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean); override;
    procedure DoPrgSetValue(Sender: TObject; Identifer: String;
      const Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean); override;
  public
    Grid: TDBGridEh;
    StateCodeList, StateTextList: TStringList;
    StateImageList: TImageList;
    OrderStateCodeList, OrderStateTextList: TStringList;
    OrderStateImageList: TImageList;
    Process: TPolyProcessCfg;
  public
    constructor Create(_Grid: TDBGridEh; _Process: TPolyProcessCfg; _ScriptFieldName: string);
  end;

constructor TGetColumnsCode.Create(_Grid: TDBGridEh; _Process: TPolyProcessCfg;
  _ScriptFieldName: string);
begin
  inherited Create(_Process, _ScriptFieldName);
  Grid := _Grid;
end;

procedure TGetColumnsCode.DoPrgGetValue(Sender: TObject; Identifer: String;
  var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
begin
  if CompareText(Identifer, 'Grid') = 0 then
  begin
    Value := O2V(Grid);
    Done := true;
  end
  else if CompareText(Identifer, 'Process') = 0 then
  begin
    Value := O2V(Process);
    Done := true;
  end
  else if CompareText(Identifer, 'StateCodeList') = 0 then
  begin
    Value := O2V(StateCodeList);
    Done := true;
  end
  else if CompareText(Identifer, 'StateImageList') = 0 then
  begin
    Value := O2V(StateImageList);
    Done := true;
  end
  else if CompareText(Identifer, 'StateTextList') = 0 then
  begin
    Value := O2V(StateTextList);
    Done := true;
  end
  else if CompareText(Identifer, 'OrderStateCodeList') = 0 then
  begin
    Value := O2V(OrderStateCodeList);
    Done := true;
  end
  else if CompareText(Identifer, 'OrderStateImageList') = 0 then
  begin
    Value := O2V(OrderStateImageList);
    Done := true;
  end
  else if CompareText(Identifer, 'OrderStateTextList') = 0 then
  begin
    Value := O2V(OrderStateTextList);
    Done := true;
  end;
end;

procedure TGetColumnsCode.DoPrgSetValue(Sender: TObject; Identifer: String;
  const Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
begin
  if CompareText(Identifer, 'Grid') = 0 then
  begin
    raise Exception.Create('Нельзя присвоить значение переменной Grid');
    Done := true;
  end else if CompareText(Identifer, 'Process') = 0 then
  begin
    raise Exception.Create('Нельзя присвоить значение переменной Process');
    Done := true;
  end;
end;

{ TStateImages }

class procedure TStateImages.CreateProcessStateLists(imSrvState: TImageList;
  var FStateCodeList, FStateTextList: TStringList);
var
  StData: TDataSet;
  Bmp: TBitmap;
  de: TDictionary;
begin
  de := TConfigManager.Instance.StandardDics.deProcessExecState;
  if de <> nil then
  begin
    StData := de.DicItems;
    StData.First;
    imSrvState.Clear;
    if FStateCodeList = nil then FStateCodeList := TStringList.Create
    else FStateCodeList.Clear;
    if FStateTextList = nil then FStateTextList := TStringList.Create
    else FStateTextList.Clear;
    while not StData.eof do
    begin
      if not VarIsNull(de.CurrentValue[2]) then
      begin
        Bmp := TBitmap.Create;
        Bmp.Assign(StData.FieldByName('A2'));
        imSrvState.AddMasked(Bmp, clOlive);
      end;
      FStateCodeList.Add(IntToStr(de.CurrentCode));
      FStateTextList.Add(de.CurrentName);
      StData.Next;
    end;
  end;
end;

class procedure TStateImages.CreateOrderStateLists(imOrderState: TImageList;
  var FOrderStateCodeList, FOrderStateTextList: TStringList);
var
  StData: TDataSet;
  Bmp: TBitmap;
  de: TDictionary;
begin
  de := TConfigManager.Instance.StandardDics.deOrderState;
  if de <> nil then
  begin
    StData := de.DicItems;
    StData.First;
    imOrderState.Clear;
    if FOrderStateCodeList = nil then FOrderStateCodeList := TStringList.Create
    else FOrderStateCodeList.Clear;
    if FOrderStateTextList = nil then FOrderStateTextList := TStringList.Create
    else FOrderStateTextList.Clear;
    while not StData.eof do
    begin
      if not VarIsNull(de.CurrentValue[2]) then
      begin
        Bmp := TBitmap.Create;
        Bmp.Assign(StData.FieldByName('A2'));
        imOrderState.AddMasked(Bmp, clOlive);
      end;
      FOrderStateCodeList.Add(IntToStr(de.CurrentCode));
      FOrderStateTextList.Add(de.CurrentName);
      StData.Next;
    end;
  end;
end;

// TProductionBaseFrame

function TProductionBaseFrame.ExecGridCode(ScriptFieldName: string;
  dg: TMyDBGridEh; _ProcessEntity: TProcessEntity): boolean;
var
  GetColumnsCode: TGetColumnsCode;
  _Process: TPolyProcessCfg;
begin
  Result := false;
  if _ProcessEntity.FindScript(_Process, ScriptFieldName) then
  begin
    GetColumnsCode := TGetColumnsCode.Create(dg, _Process, ScriptFieldName);
    try
      GetColumnsCode.OnScriptError := FOnScriptError;
      GetColumnsCode.StateCodeList := FStateCodeList;
      GetColumnsCode.StateTextList := FStateTextList;
      GetColumnsCode.StateImageList := imSrvState;
      GetColumnsCode.OrderStateCodeList := FOrderStateCodeList;
      GetColumnsCode.OrderStateTextList := FOrderStateTextList;
      GetColumnsCode.OrderStateImageList := imOrderState;
      Result := GetColumnsCode.ExecCode;
    finally
      GetColumnsCode.Free;
    end;
  end;
end;

procedure TProductionBaseFrame.CreateStateLists;
begin
  TStateImages.CreateProcessStateLists(imSrvState, FStateCodeList, FStateTextList);
  TStateImages.CreateOrderStateLists(imOrderState, FOrderStateCodeList, FOrderStateTextList);
end;

// Собирает поля столбцов для экспорта
function TProductionBaseFrame.GetColumnsFieldList(dg: TDBGridEh): string;
var
  I: Integer;
  s: string;
  f: TField;
begin
  s := '';
  for I := 0 to dg.Columns.Count - 1 do
  begin
    //RusMessageDlg(dg.Columns[i].FieldName, mtInformation, [mbOk], 0);
    f := dg.Columns[i].Field;
    if (CompareStr(f.FieldName, 'HasComment') <> 0) {not (f is TBooleanField)}
      and not (f is TBlobField)
      and (dg.Columns[i].ImageList = nil) and dg.Columns[i].Visible then
    begin
      if s <> '' then s := s + ';';
      s := s + dg.Columns[i].FieldName;
    end;
  end;
  Result := s;
end;

function TProductionBaseFrame.GetProcessStateColor(ExecState: integer): TColor;
var
  i: Integer;
  States: TStringList;
begin
  Result := clWindow;
  //if NvlInteger(cd[F_ExecState]) <> 0 then
  //begin
    States := TConfigManager.Instance.StandardDics.ProcessExecStates;
    i := States.IndexOf(IntToStr(ExecState));
    if (i <> -1) and (States.Objects[i] <> nil) then
    begin
      i := (States.Objects[i] as TOrderState).RowColorCode;
      i := ColorItems.IndexOf(IntToStr(i));
      if (i <> -1) then
        Result := TColor(ColorItems.Objects[i]);
    end;
  //end;
end;

end.
