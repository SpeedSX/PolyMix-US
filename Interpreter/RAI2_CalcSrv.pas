unit RAI2_CalcSrv;

interface

uses SysUtils, JvInterpreter, DB, Forms, Menus, Graphics, Classes,
  Variants, Types, COntrols, GridsEh, jvTypes, ADODb, DBClient,
  Provider, CalcUtils, jvFormPlacement, jvAppStorage, JvMenus, DBGridEh,
  DicObj, DBCtrls, PmDictionaryList, PmOrder, PmProcess, PmProcessCfg,
  PmConfigManager, fOrderProductStorageFrom;

{$I Calc.inc}
// ------------ JvInterpreter: Процедуры и переменные для расчетных скриптов  -------------

type
  EJvScriptError  = class(Exception)
  private
    FExceptionPos: Boolean;
    FErrPos: integer;
    FErrUnitName: string;
    FErrLine: Integer;
  public
    constructor Create(const AErrPos: integer; const Msg: string);
    procedure Assign(E: Exception);
    procedure Clear;
    property ErrPos: integer read FErrPos;
    property ErrUnitName: string read FErrUnitName;
    property ErrLine: Integer read FErrLine;
  end;

procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);

(*type
  TServiceItemsTarget = (sitProcessExecState, sitOperExecState {not used},  // 31.12.2004
                         sitCost, sitProcessList);*)

var
  ScriptDataSet: TDataSet;
  ScriptService: TPolyProcess;
  ScriptOrder: TOrder;
  ScriptGrid: TProcessGrid;
  ScriptMainForm: TForm;
  //ScriptDicElements: TDicElemList;
  ScriptChangedField: TField;
  ScriptCurField: string;
  ScriptPopupMenu: TPopupMenu;
  ScriptPopupSelected: integer;
  ScriptRecNo: integer;
  ScriptPopupMenuFilled: boolean;
  ScriptTotalCost: extended;
  // DrawCell
  ScriptBackground: TColor;
  ScriptFont: TFont;
  ScriptHighlight: boolean;
  // GetText
  ScriptDisplayText: boolean;
  ScriptFieldText: string;

  //TechCardLabels: TStringList;   // 31.12.2004

  // Списки стоимости и выполнения позиций заказа заполняются тем же скриптом, что и тех. карта,
  // но они должен сохраняться, пока заказ открыт, т.к. там будут ссылки на поле
  // и строку сервиса (в режиме редактирования).
  {OrdStateLabels: TStringList;
  CostLabels: TStringList;
  ServiceItemsTarget: TServiceItemsTarget;  // показывает, какой из списков формируется}   // 31.12.2004

  // формируют список состояния заказа в TechCardLabels и теми же скриптами
  {procedure GetOrderStateLabels; // 31.12.2004
  procedure DoneOrderStateLabels;
  procedure GetCostLabels;
  procedure DoneCostLabels;}

implementation

uses Dialogs, RDialogs, ComCtrls, ExtCtrls,
  JvPickDate, JvDBControls, JvInterpreter_Windows, JvJCLUtils,
  TLoggerUnit,

  MainForm, DicUtils, MainData,
  ServMod, DataHlp, RDBUtils,
  CalcSettings, fOrderItems, EnPaint, PlanUtils,
  PmMaterials, PmOperations, PmOrderController, PmOrderProcessItems
{$IFNDEF NoTriada}
{$IFDEF Repbuild}
  , TechCard
{$ENDIF}
{$ENDIF}
;

var
  GlobalVars: TStringList;

const
  GlobalVarID = 'GlobalVar';

{ TGlobalVar }

type
  TGlobalVar = class(TObject)
    Value: variant;
  end;

// ----- EJvScriptError  -----

constructor EJvScriptError.Create(const AErrPos: integer; const Msg: string);
begin
  inherited Create('');
  FErrPos := AErrPos;
  Message := Msg;
end;

procedure EJvScriptError.Assign(E: Exception);
begin
  Message := E.Message;
  if E is EJvScriptError  then
    FErrPos := (E as EJvScriptError).FErrPos;
end;

procedure EJvScriptError.Clear;
begin
  FExceptionPos := False;
  FErrPos := -1;
  FErrLine := -1;
  FErrUnitName := '';
end;

procedure DicNotFound(DicName: string);
begin
  raise EJvScriptError.Create(-1, 'Справочник ''' + DicName + ''' не найден');
end;

procedure SrvNotFound(DicName: string);
begin
  raise EJvScriptError.Create(-1, 'Процесс ''' + DicName + ''' не найден');
end;

procedure GridNotFound(DicName: string);
begin
  raise EJvScriptError.Create(-1, 'Таблица ''' + DicName + ''' не найдена');
end;

procedure RAI2_DefCalcFields(var Value: Variant; Args: TJvInterpreterArgs);
begin
  //...
end;

procedure RAI2_AutoTech(var Value: Variant; Args: TJvInterpreterArgs);
begin
  raise EJvScriptError.Create(-1, 'Вызов AutoTech в этой вресии не поддерживается.');
end;

procedure RAI2_GetDictionary(var Value: Variant; Args: TJvInterpreterArgs);
var de: TDictionary;
begin
  de := TConfigManager.Instance.DictionaryList[string(Args.Values[0])];
  Value := O2V(de);
  { TODO: Пока убрал exception при НЕнахождении справочника }
  //if de = nil then DicNotFound(string(Args.Values[0]));
end;

procedure JvInterpreter_FindDictionaryByID(var Value: Variant; Args: TJvInterpreterArgs);
var de: TDictionary;
begin
  de := TConfigManager.Instance.DictionaryList.FindID(Args.Values[0]);
  Value := O2V(de);
end;

procedure JvInterpreter_GetDictionaryList(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TConfigManager.Instance.DictionaryList.GetAllDictionaries);
end;

procedure RAI2_GetNProductValue(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := GetNProductValue(integer(Args.Values[0]),
    V2O(Args.Values[1]) as TDictionary);
end;

procedure RAI2_AssignMultiDimDicFields(var Value: Variant; Args: TJvInterpreterArgs);
begin
//  ScriptService.AssignMultiDimDicFields; можно убрать
end;

{procedure RAI2_DefaultNewRecord(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptService.DefaultNewRecord;
end;}

procedure RAI2_GetParamValue(var Value: Variant; Args: TJvInterpreterArgs);
var
  cdOrd: TDataSet;
begin
  cdOrd := ScriptOrder.DataSet;
  if CompareText(string(Args.Values[0]), TOrder.NProductParamName) = 0 then
    Value := cdOrd['Tirazz']
  else
    Value := 0;
end;

procedure RAI2_GetOldParamValue(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if CompareText(string(Args.Values[0]), TOrder.NProductParamName) = 0 then
    Value := ScriptOrder.Processes.Tirazz
  else
    Value := 0;
end;

procedure RAI2_GetParamChanged(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TmpParName;
end;

procedure RAI2_FieldChanged(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if ScriptChangedField <> nil then
    Value := ScriptChangedField.FieldName
  else
    Value := '';
end;

procedure RAI2_OldFieldValue(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptService.ScriptOldFieldValue;
end;

procedure RAI2_CurField(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptCurField;
end;

procedure RAI2_SetCurField(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptCurField := string(Args.Values[0]);
end;

procedure RAI2_MakeMenu(var Value: Variant; Args: TJvInterpreterArgs);
var
  de: TDictionary;
begin
  // параметр - имя справочника, из которого делать меню
  de := TConfigManager.Instance.DictionaryList[string(Args.Values[0])];
  if de <> nil then
  begin
    if ScriptService is TGridPolyProcess then
      FillPopupMenuFromDicEv(ScriptPopupMenu, de, -1, -1, ScriptGrid.PopupSelected);
    //else
    //  FillPopupMenuFromDic(ScriptPopupMenu, de, -1, -1);
    ScriptPopupMenuFilled := true;
//    ScriptPopupMenu := de.PopupMenu;
  end
  else
    DicNotFound(string(Args.Values[0]));
end;

procedure RAI2_MakeMenuRange(var Value: Variant; Args: TJvInterpreterArgs);
var
  de: TDictionary;
begin
  // параметр 0 - имя справочника, из которого делать меню,
  // 1 и 2 - начало и конец диапазона кодов.
  de := TConfigManager.Instance.DictionaryList[string(Args.Values[0])];
  if de <> nil then
  begin
    if ScriptService is TGridPolyProcess then
      FillPopupMenuFromDicEv(ScriptPopupMenu,
        de, integer(Args.Values[1]), integer(Args.Values[2]), ScriptGrid.PopupSelected);
    //else
    //  FillPopupMenuFromDic(ScriptPopupMenu, de, integer(Args.Values[1]), integer(Args.Values[2]));
    ScriptPopupMenuFilled := true;
//    ScriptPopupMenu := de.PopupMenu;
  end
  else
    DicNotFound(string(Args.Values[0]));
end;

procedure RAI2_MakeMenuFromDataSet(var Value: Variant; Args: TJvInterpreterArgs);
var
  ds: TDataSet;
begin
  // параметр 0 - набор данных
  // параметр 1 - ключевое поле
  // параметр 2 - поле для отображения в меню
  ds := V2O(Args.Values[0]) as TDataSet;
  if ScriptService is TGridPolyProcess then
    FillPopupMenuFromDataSetEv(ScriptPopupMenu, ds, -1, -1,
      string(Args.Values[1]), string(Args.Values[2]), '', ScriptGrid.PopupSelected);
  {else
    FillPopupMenuFromDataSetEv(ScriptPopupMenu, ds, -1, -1,
      string(Args.Values[1]), string(Args.Values[2]), '');}
  ScriptPopupMenuFilled := true;
end;

procedure RAI2_FillPopupMenu(var Value: Variant; Args: TJvInterpreterArgs);
var
  de: TDictionary;
begin
  // параметр 0 - меню,
  // параметр 1 - имя справочника, из которого делать меню,
  // 2 и 3 - начало и конец диапазона кодов.
  de := TConfigManager.Instance.DictionaryList[string(Args.Values[1])];
  if de <> nil then
  begin
    if (ScriptService is TGridPolyProcess) then
      FillPopupMenuFromDicEv(V2O(Args.Values[0]) as TPopupMenu, de,
        integer(Args.Values[2]), integer(Args.Values[3]), ScriptGrid.PopupSelected)
  end
  else
    DicNotFound(string(Args.Values[0]));
end;

procedure RAI2_FillPopupMenuStd(var Value: Variant; Args: TJvInterpreterArgs);
var
  de: TDictionary;
begin
  // параметр 0 - меню,
  // параметр 1 - имя справочника, из которого делать меню,
  // 2 и 3 - начало и конец диапазона кодов.
  de := TConfigManager.Instance.DictionaryList[string(Args.Values[1])];
  if (de <> nil) and (ScriptService is TGridPolyProcess) then
  begin
    FillPopupMenuFromDicEv(V2O(Args.Values[0]) as TPopupMenu, de,
       integer(Args.Values[2]), integer(Args.Values[3]),
       ScriptGrid.PopupSelected);
  end
  else
    DicNotFound(string(Args.Values[0]));
end;

procedure RAI2_USDCourse(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.USDCourse;
end;

procedure RAI2_ItemData(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(ScriptOrder.OrderItems.DataSet);
end;

procedure RAI2_MaterialData(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(ScriptOrder.OrderItems.Materials.DataSet);
end;

procedure RAI2_CalcExecState(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := CalcExecState(V2O(Args.Values[0]) as TDataSet);
end;

procedure RAI2_SetMaterial(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.OrderItems.SetMaterial(ScriptService.ItemKey, Args.Values[0], Args.Values[1],
    NvlFloat(Args.Values[2]), NvlString(Args.Values[3]), NvlFloat(Args.Values[4]), false,
    ResolveMaterial);
end;

procedure RAI2_SetMaterialEx(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.OrderItems.SetMaterialEx(ScriptService.ItemKey, Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3], Args.Values[4],
    NvlFloat(Args.Values[5]), NvlString(Args.Values[6]), NvlFloat(Args.Values[7]), false,
    ResolveMaterial);
end;

procedure RAI2_SetFactMaterial(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.OrderItems.SetFactMaterial(ScriptService.ItemKey, Args.Values[0],
     Args.Values[1], Args.Values[2]);
end;

procedure RAI2_ReplaceMaterial(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.OrderItems.ReplaceMaterial(ScriptService.ItemKey, Args.Values[0], Args.Values[1],
    NvlFloat(Args.Values[2]), NvlString(Args.Values[3]), NvlFloat(Args.Values[4]),
    ResolveMaterial);
end;

procedure RAI2_ReplaceMaterialEx(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.OrderItems.ReplaceMaterialEx(ScriptService.ItemKey, Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3], Args.Values[4],
    NvlFloat(Args.Values[5]), NvlString(Args.Values[6]), NvlFloat(Args.Values[7]),
    ResolveMaterial);
end;

procedure RAI2_SetOperation(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.OrderItems.Operations.SetOperation(ScriptService.ItemKey, Args.Values[0], Args.Values[1], Args.Values[2]);
end;

procedure RAI2_ClearMaterial(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.OrderItems.ClearMaterial(ScriptService.ItemKey, Args.Values[0],
    ResolveMaterial);
end;

procedure RAI2_ClearAllMaterials(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.OrderItems.ClearMaterial(ScriptService.ItemKey, '',
    ResolveMaterial);
end;

procedure RAI2_ClearOperation(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.OrderItems.Operations.ClearOperation(ScriptService.ItemKey, Args.Values[0]);
end;

procedure RAI2_ItemSelected(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptPopupSelected;
end;

procedure RAI2_CallSrvScript(var Value: Variant; Args: TJvInterpreterArgs);
var
  Scr: string;
begin
  Scr := string(Args.Values[0]);
  if CompareText(Scr, FScript_OnSetPrices) = 0 then
    ScriptService.SetPrices
  else RusMessageDlg('Вызов ' + Scr + ' не реализован', mtError, [mbOk], 0);
{  else if CompareText(Scr, ScrParamChangeField) = 0 then
    ParamChanged;
  else if CompareText(Scr, ScrChangeField) = 0 then
    CalcOnFieldChange()}
end;

procedure RAI2_CallOrdScript(var Value: Variant; Args: TJvInterpreterArgs);
begin
end;

procedure RAI2_CallGlobScript(var Value: Variant; Args: TJvInterpreterArgs);
begin
end;

procedure RAI2_Field(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptService.DataSet[string(Args.Values[0])];
  {Value := ScriptDataSet[string(Args.Values[0])];}
end;

procedure RAI2_SetField(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptService.SetField(string(Args.Values[0]), Args.Values[1]);
{  if not (ScriptDataSet.State in [dsInsert, dsEdit, dsCalcFields, dsInternalCalc]) then
  begin
    if ScriptDataSet.IsEmpty then ScriptDataSet.Append;
    ScriptDataSet.Edit;
  end;
  ScriptDataSet[string(Args.Values[0])] := Args.Values[1];}
end;

procedure RAI2_MainForm(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(ScriptMainForm);
end;

procedure TDicElement_Get_Value(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if VarIsNull(Args.Values[0]) then
    Value := 0
  else
    Value := TDictionary(Args.Obj).ItemValue[
      integer(Args.Values[0]),
      integer(Args.Values[1])
    ];
end;

procedure TDicElement_Get_CurrentValue(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if VarIsNull(Args.Values[0]) then
    Value := 0
  else
    Value := TDictionary(Args.Obj).CurrentValue[integer(Args.Values[0])];
end;

procedure TDicElement_Get_Value2D(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if VarIsNull(Args.Values[0]) or VarIsNull(Args.Values[1]) then
    Value := 0
  else Value := TDictionary(Args.Obj).MultiValue[
      DimValueField + '1;' + DimValueField + '2',
      VarArrayOf([integer(Args.Values[0]),
                  integer(Args.Values[1])]),
      F_DicItemValue + IntToStr(integer(Args.Values[2]))
    ];
end;

procedure TDicElement_Get_Value3D(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if VarIsNull(Args.Values[0]) or VarIsNull(Args.Values[1]) or VarIsNull(Args.Values[2]) then
    Value := 0
  else Value := TDictionary(Args.Obj).MultiValue[
      DimValueField + '1;' + DimValueField + '2;' + DimValueField + '3',
      VarArrayOf([integer(Args.Values[0]),
                  integer(Args.Values[1]),
                  integer(Args.Values[2])
                 ]),
      F_DicItemValue + IntToStr(integer(Args.Values[3]))
    ];
end;

procedure TDicElement_Get_Value4D(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if VarIsNull(Args.Values[0]) or VarIsNull(Args.Values[1]) or VarIsNull(Args.Values[2]) or VarIsNull(Args.Values[3]) then
    Value := 0
  else Value := TDictionary(Args.Obj).MultiValue[
      DimValueField + '1;' +
      DimValueField + '2;' +
      DimValueField + '3;' +
      DimValueField + '4',
      VarArrayOf([integer(Args.Values[0]),
                  integer(Args.Values[1]),
                  integer(Args.Values[2]),
                  integer(Args.Values[3])
                 ]),
      F_DicItemValue + IntToStr(integer(Args.Values[4]))
    ];
end;

procedure TDicElement_Get_Value5D(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if VarIsNull(Args.Values[0]) or VarIsNull(Args.Values[1]) or VarIsNull(Args.Values[2]) or VarIsNull(Args.Values[3]) or VarIsNull(Args.Values[4]) then
    Value := 0
  else
  Value := TDictionary(Args.Obj).MultiValue[
    DimValueField + '1;' +
    DimValueField + '2;' +
    DimValueField + '3;' +
    DimValueField + '4;' +
    DimValueField + '5',
    VarArrayOf([integer(Args.Values[0]),
                integer(Args.Values[1]),
                integer(Args.Values[2]),
                integer(Args.Values[3]),
                integer(Args.Values[4])
               ]),
    F_DicItemValue + IntToStr(integer(Args.Values[5]))
  ];
end;

procedure TDicElement_Get_Code(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TDictionary(Args.Obj).ItemCode[string(Args.Values[0])];
end;

procedure TDicElement_Get_CurrentCode(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TDictionary(Args.Obj).CurrentCode;
end;

procedure TDicElement_Get_CurrentParentCode(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TDictionary(Args.Obj).CurrentParentCode;
end;

procedure TDicElement_Get_Name(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TDictionary(Args.Obj).ItemName[integer(Args.Values[0])];
end;

procedure TDicElement_Get_Enabled(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TDictionary(Args.Obj).ItemEnabled[integer(Args.Values[0])];
end;

procedure TDicElement_Get_CurrentName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TDictionary(Args.Obj).CurrentName;
end;

procedure TDicElement_Get_CurrentEnabled(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TDictionary(Args.Obj).CurrentEnabled;
end;

procedure TDicElement_Get_CurrentIsNull(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TDictionary(Args.Obj).CurrentIsNull[integer(Args.Values[0])];
end;

procedure TDicElement_Get_DataSet(var Value: Variant; Args: TJvInterpreterArgs);
begin
   Value := O2V(TDictionary(Args.Obj).DicItems);
end;

procedure TDicElement_Get_MultiDim(var Value: Variant; Args: TJvInterpreterArgs);
begin
   Value := TDictionary(Args.Obj).MultiDim;
end;

procedure TDicElement_Get_Description(var Value: Variant; Args: TJvInterpreterArgs);
begin
   Value := TDictionary(Args.Obj).Desc;
end;

procedure TDicElement_Get_MultiDataSet(var Value: Variant; Args: TJvInterpreterArgs);
begin
   Value := O2V(TDictionary(Args.Obj).MultiItems);
end;

procedure TDicElement_GetFieldDesc(var Value: Variant; Args: TJvInterpreterArgs);
begin
   Value := TFieldDesc(TDictionary(Args.Obj).DicFields.Objects[integer(Args.Values[0])]).FieldDesc;
end;

procedure RAI2_ServiceByDesc(var Value: Variant; Args: TJvInterpreterArgs);
var Srv: TPolyProcess;
begin
  Srv := ScriptOrder.Processes.ServiceByName(string(Args.Values[0]), true);  // автооткрытие
  Value := O2V(Srv);
  if Srv = nil then SrvNotFound(string(Args.Values[0]));
end;

procedure RAI2_ServiceByName(var Value: Variant; Args: TJvInterpreterArgs);
var Srv: TPolyProcess;
begin
  Srv := ScriptOrder.Processes.ServiceByTabName(string(Args.Values[0]), true);  // автооткрытие
  Value := O2V(Srv);
  if Srv = nil then SrvNotFound(string(Args.Values[0]));
end;

procedure RAI2_ServiceByNameNoOpen(var Value: Variant; Args: TJvInterpreterArgs);
var Srv: TPolyProcess;
begin
  Srv := ScriptOrder.Processes.ServiceByTabName(string(Args.Values[0]), false);  // без автооткрытия
  Value := O2V(Srv);
  if Srv = nil then SrvNotFound(string(Args.Values[0]));
end;

// То же самое, но не выдает ошибку
procedure RAI2_FindService(var Value: Variant; Args: TJvInterpreterArgs);
var Srv: TPolyProcess;
begin
  Srv := ScriptOrder.Processes.ServiceByTabName(string(Args.Values[0]), true);  // автооткрытие
  Value := O2V(Srv);
end;

// То же самое, но не выдает ошибку
procedure RAI2_FindServiceNoOpen(var Value: Variant; Args: TJvInterpreterArgs);
var Srv: TPolyProcess;
begin
  Srv := ScriptOrder.Processes.ServiceByTabName(string(Args.Values[0]), false);  // без автооткрытия
  Value := O2V(Srv);
end;

procedure RAI2_FindServiceByID(var Value: Variant; Args: TJvInterpreterArgs);
var Srv: TPolyProcess;
begin
  Srv := ScriptOrder.Processes.ServiceByID(Args.Values[0], true);  // автооткрытие
  Value := O2V(Srv);
end;

procedure RAI2_GridByName(var Value: Variant; Args: TJvInterpreterArgs);
var go: TProcessGrid;
begin
  go := ScriptOrder.Processes.GridByName(string(Args.Values[0]), true);  // автооткрытие
  Value := O2V(go);
  if go = nil then GridNotFound(string(Args.Values[0]));
end;

// То же самое, но не выдает ошибку
procedure RAI2_FindGrid(var Value: Variant; Args: TJvInterpreterArgs);
var go: TProcessGrid;
begin
  go := ScriptOrder.Processes.GridByName(string(Args.Values[0]), true);  // автооткрытие
  Value := O2V(go);
end;

// То же самое, но не выдает ошибку
procedure RAI2_FindGridNoOpen(var Value: Variant; Args: TJvInterpreterArgs);
var go: TProcessGrid;
begin
  go := ScriptOrder.Processes.GridByName(string(Args.Values[0]), false);  // без автооткрытия
  Value := O2V(go);
end;

procedure RAI2_CurSrv(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(ScriptService);
end;

procedure RAI2_RecNo(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptRecNo;
end;

procedure RAI2_CurGrid(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(ScriptGrid);
end;

procedure RAI2_GrandTotal(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.GrandTotal;
end;

procedure RAI2_GrandTotalGrn(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.GrandTotalGrn;
end;

procedure RAI2_ClientTotal(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.ClientTotal;
end;

procedure RAI2_SetClientTotal(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.Processes.ClientTotal := Args.Values[0];
end;

procedure RAI2_SetClientTotalGrn(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.Processes.ClientTotalGrn := Args.Values[0];
end;

procedure RAI2_GetTotalOwnCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.TotalOwnCost;
end;

procedure RAI2_GetTotalContractorCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.TotalContractorCost;
end;

procedure RAI2_GetTotalMatCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.TotalMatCost;
end;

procedure RAI2_GetTotalOwnProfitCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.TotalOwnProfitCost;
end;

procedure RAI2_GetTotalContractorProfitCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.TotalContractorProfitCost;
end;

procedure RAI2_GetTotalMatProfitCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.TotalMatProfitCost;
end;

procedure RAI2_GetTotalOwnCostForProfit(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.TotalOwnCostForProfit;
end;

procedure RAI2_GetTotalContractorCostForProfit(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.TotalContractorCostForProfit;
end;

procedure RAI2_GetTotalMatCostForProfit(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.TotalMatCostForProfit;
end;

procedure RAI2_UpdateContractorPercent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.Processes.ContractorPercent := Args.Values[0];
end;

procedure RAI2_UpdateOwnPercent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.Processes.OwnPercent := Args.Values[0];
end;

procedure RAI2_UpdateMatPercent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.Processes.MatPercent := Args.Values[0];
end;

procedure RAI2_UpdateContractorProfit(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.Processes.ContractorProfit := Args.Values[0];
end;

procedure RAI2_UpdateOwnProfit(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.Processes.OwnProfit := Args.Values[0];
end;

procedure RAI2_UpdateMatProfit(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.Processes.MatProfit := Args.Values[0];
end;

procedure RAI2_GetContractorProfit(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.ContractorProfit;
end;

procedure RAI2_GetMatProfit(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.MatProfit;
end;

procedure RAI2_GetOwnProfit(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.OwnProfit;
end;

procedure RAI2_GetContractorPercent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.ContractorPercent;
end;

procedure RAI2_GetMatPercent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.MatPercent;
end;

procedure RAI2_GetOwnPercent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptOrder.Processes.OwnPercent;
end;

procedure RAI2_SetItemParam(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptService.SetItemParam(string(Args.Values[0]), Args.Values[1]);
end;

procedure RAI2_ProcessDependentPart(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.Processes.ProcessDependentPart(ScriptService, string(Args.Values[0]));
end;

procedure RAI2_AddChildProcess(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(ScriptOrder.Processes.AppendChildProcess(ScriptService, string(Args.Values[0])));
end;

procedure RAI2_RemoveChildProcess(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptOrder.Processes.RemoveChildProcess(ScriptService, string(Args.Values[0]));
end;

procedure RAI2_LocateChildProcess(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(ScriptOrder.Processes.LocateChildProcess(ScriptService, string(Args.Values[0])));
end;

procedure RAI2_SetLinkedItemID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptService.SetItemParam(TOrderProcessItems.F_LinkedItemID, Args.Values[0]);
end;

procedure RAI2_FormatTotal(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := FormatTotal(extended(Args.Values[0]), V2O(Args.Values[1]) as TPanel);
end;

procedure RAI2_SetBackground(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptBackground := TColor(Args.Values[0]);
end;

procedure RAI2_GetBackground(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptBackground;
end;

procedure RAI2_Highlight(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptHighlight;
end;

procedure RAI2_Font(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(ScriptFont);
end;

procedure RAI2_DisplayText(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptDisplayText;
end;

procedure RAI2_SetText(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try ScriptFieldText := string(Args.Values[0]);
  except ScriptFieldText := '' end;
end;

procedure RAI2_DefaultDrawEnabledColumn(var Value: Variant; Args: TJvInterpreterArgs);
begin
  try
    EnablePainter.DrawCheckBox(V2O(Args.Values[0]), TRect(V2P(Args.Values[1])^),
      Args.Values[2], V2O(Args.Values[3]) as TColumnEh, TGridDrawState(Byte(V2S(Args.Values[4]))));
  except end;
end;

procedure RAI2_SelectDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := SelectDate(V2O(Args.Values[0]) as TWinControl,
    TDateTime(TVarData(Args.Values[1]).vDate),
    TCaption(Args.Values[2]), TDayOfWeekName(Args.Values[3]),
    TDaysOfWeek(Byte(V2S(Args.Values[4]))), TColor(Args.Values[5]),
    V2O(Args.Values[6]) as TStrings);
end;

procedure RAI2_CutTime(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := CutTime(TDateTime(Args.Values[0]));
end;

procedure TPolyProcess_Get_FullName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPolyProcess(Args.Obj).ServiceName;
end;

procedure TPolyProcess_Get_Name(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPolyProcess(Args.Obj).TableName;
end;

procedure TPolyProcess_Locate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPolyProcess(Args.Obj).DataSet.Locate(string(Args.Values[0]), Args.Values[1], [loCaseInsensitive]);
end;

procedure TPolyProcess_Append(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TPolyProcess(Args.Obj).AppendRecord;
end;

procedure TPolyProcess_Delete(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPolyProcess(Args.Obj).DeleteRecord;
end;

procedure TPolyProcess_ShowMsg(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TPolyProcess(Args.Obj).AddCheckMsg(string(Args.Values[0]), TMsgDlgType(Args.Values[1]),
     ScriptRecNo);
end;

procedure TPolyProcess_DebugMsg(var Value: Variant; Args: TJvInterpreterArgs);
begin
  RusMessageDlg('DEBUG in ' + TPolyProcess(Args.Obj).ServiceName + ': ' + string(Args.Values[0]),
    TMsgDlgType(Args.Values[1]), [mbOk], 0);
end;

procedure TPolyProcess_Field(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPolyProcess(Args.Obj).DataSet[string(Args.Values[0])];
end;

procedure TPolyProcess_SetField(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TPolyProcess(Args.Obj).SetField(string(Args.Values[0]), Args.Values[1]);
end;

procedure TPolyProcess_IsEmpty(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPolyProcess(Args.Obj).DataSet.IsEmpty;
end;

procedure TPolyProcess_CallSrvScript(var Value: Variant; Args: TJvInterpreterArgs);
var
  Scr: string;
begin
  Scr := string(Args.Values[0]);
  if CompareText(Scr, FScript_OnSetPrices) = 0 then
    TPolyProcess(Args.Obj).SetPrices
  else if CompareText(Scr, FScript_OnChange) = 0 then begin
    TPolyProcess(Args.Obj).CalcOnFieldChange(TPolyProcess(Args.Obj).DataSet.FieldByName(string(Args.Values[1])));
  end;
end;

procedure TPolyProcess_GetTotalCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPolyProcess(Args.Obj).TotalCost;
end;

procedure TPolyProcess_CalcTotalCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  RusMessageDlg('ВНИМАНИЕ! Вызов TService.CalcTotalCost не поддерживается в версии 2.0!'#13'Обратитесь к разработчику!', mtError, [mbOk], 0);
end;

procedure TPolyProcess_PermitUpdate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPolyProcess(Args.Obj).PermitUpdate;
end;

procedure TPolyProcess_PermitInsert(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPolyProcess(Args.Obj).PermitInsert;
end;

procedure TPolyProcess_PermitDelete(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPolyProcess(Args.Obj).PermitDelete;
end;

procedure TPolyProcess_PermitPlan(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPolyProcess(Args.Obj).PermitFact;
end;

procedure TPolyProcess_PermitFact(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPolyProcess(Args.Obj).PermitFact;
end;

procedure TPolyProcess_DataSet(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TPolyProcess(Args.Obj).DataSet);
end;

procedure TPolyProcess_DataSource(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TPolyProcess(Args.Obj).DataSource);
end;

procedure TPolyProcess_GetUseInProfitMode(var Value: Variant; Args: TJvInterpreterArgs);
begin
  RusMessageDlg('ВНИМАНИЕ! Вызов TService.UseInProfitMode не поддерживается в версии 2.0!'#13'Обратитесь к разработчику!', mtError, [mbOk], 0);
  Value := TPolyProcess(Args.Obj).ProcessCfg.UseInProfitMode;
end;

procedure TPolyProcess_DefaultEquipGroupCode(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPolyProcess(Args.Obj).ProcessCfg.DefaultEquipGroupCode;
end;

procedure TPolyProcess_SequenceOrder(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPolyProcess(Args.Obj).ProcessCfg.SequenceOrder;
end;

{procedure TPolyProcess_EditDateField(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if TPolyProcess(Args.Obj) is TGridProcess then
    EditDateField(TGridProcess(Args.Obj).DBGrid);
end;}

procedure TProcessGrid_Page(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TProcessGrid(Args.Obj).Page);
end;

procedure TProcessGrid_PageFrame(var Value: Variant; Args: TJvInterpreterArgs);
var
  ts: TPageClass;
begin
  ts := TProcessGrid(Args.Obj).Page;
  if (ts <> nil) and (ts.ControlCount > 0) and (ts.Controls[0] is TFrame) then begin
    Value := O2V(ts.Controls[0]);
  end else
    Value := O2V(nil);
end;

procedure TProcessGrid_GetTotalPanel(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TProcessGrid(Args.Obj).TotalPanel);
end;

procedure TProcessGrid_SetTotalPanel(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TProcessGrid(Args.Obj).TotalPanel := V2O(Value) as TPanel;
end;

procedure TProcessGrid_GetGridControl(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TProcessGrid(Args.Obj).DBGrid);
end;

procedure TProcessGrid_GetTotalCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TProcessGrid(Args.Obj).TotalCost;
end;

procedure TProcessGrid_GetTotal(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TProcessGrid(Args.Obj).GetTotalValue(Args.Values[0]);
end;

procedure TPolyProcess_ShowInReport(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPolyProcess(Args.Obj).ProcessCfg.ShowInReport;
end;

procedure TPolyProcess_OnlyWorkOrder(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPolyProcess(Args.Obj).ProcessCfg.OnlyWorkOrder;
end;

procedure TPolyProcess_GetGrid(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if Args.Obj is TGridPolyProcess then
    Value := O2V(TGridPolyProcess(Args.Obj).Grids)
  else
    Value := P2V(nil);
end;

procedure TPolyProcess_ProcessID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPolyProcess(Args.Obj).SrvID;
end;

procedure TPolyProcess_GetMaterialData(var Value: Variant; Args: TJvInterpreterArgs);
var
  cd: TDataSet;
  key: integer;
begin
  cd := TPolyProcess(Args.Obj).DataSet;
  if cd.IsEmpty then key := 0 else key := NvlInteger(cd[F_ItemID]);
  Value := O2V(ScriptOrder.OrderItems.Materials.GetMaterialData(key, string(Args.Values[0])));
end;

// ---------------- TServiceList -------------------------

{procedure TServiceList_Read_Service(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TServiceList(Args.Obj).GetService(Args.Values[i]));
end;

procedure TServiceList_Read_Count(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TServiceList(Args.Obj).Count;
end;}

{procedure TJvDBGrid_Create(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TJvDBGrid.Create(V2O(Args.Values[0]) as TComponent));
end;

procedure TJvDBGrid_Read_ShowGlyphs(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TJvDBGrid(Args.Obj).ShowGlyphs;
end;

procedure TJvDBGrid_Write_ShowGlyphs(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TJvDBGrid(Args.Obj).ShowGlyphs := Value;
end;

procedure TJvDBGrid_Read_TitleButtons(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TJvDBGrid(Args.Obj).TitleButtons;
end;

procedure TJvDBGrid_Write_TitleButtons(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TJvDBGrid(Args.Obj).TitleButtons := Value;
end;

procedure TJvDBGrid_Read_AutoAppend(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TJvDBGrid(Args.Obj).AutoAppend;
end;

procedure TJvDBGrid_Write_AutoAppend(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TJvDBGrid(Args.Obj).AutoAppend := Value;
end;

procedure TJvDBGrid_Read_AutoSizeColumns(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TJvDBGrid(Args.Obj).AutoSizeColumns;
end;

procedure TJvDBGrid_Write_AutoSizeColumns(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TJvDBGrid(Args.Obj).AutoSizeColumns := Value;
end;

procedure TJvDBGrid_Read_AutoSizeColumnIndex(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TJvDBGrid(Args.Obj).AutoSizeColumnIndex;
end;

procedure TJvDBGrid_Write_AutoSizeColumnIndex(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TJvDBGrid(Args.Obj).AutoSizeColumnIndex := Value;
end;

procedure TJvDBGrid_Read_SortMarker(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TJvDBGrid(Args.Obj).SortMarker;
end;

procedure TJvDBGrid_Write_SortMarker(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TJvDBGrid(Args.Obj).SortMarker := Value;
end;

procedure TJvDBGrid_Read_SortedField(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TJvDBGrid(Args.Obj).SortedField;
end;

procedure TJvDBGrid_Write_SortedField(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TJvDBGrid(Args.Obj).SortedField := Value;
end;

procedure TJvDBGrid_Read_AlternateRowColor(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TJvDBGrid(Args.Obj).AlternateRowColor;
end;

procedure TJvDBGrid_Write_AlternateRowColor(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TJvDBGrid(Args.Obj).AlternateRowColor := Value;
end;

procedure TJvDBGrid_Read_IniStorage(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TJvDBGrid(Args.Obj).IniStorage);
end;

procedure TJvDBGrid_Write_IniStorage(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TJvDBGrid(Args.Obj).IniStorage := V2O(Value) as TJvFormPlacement;
end;
}
{ TImageDBGrid }

{procedure TImageDBGrid_Create(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TImageDBGrid.Create(V2O(Args.Values[0]) as TComponent));
end;

procedure TImageDBGrid_Read_DrawBooleans(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TImageDBGrid(Args.Obj).DrawBooleans;
end;

procedure TImageDBGrid_Write_DrawBooleans(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TImageDBGrid(Args.Obj).DrawBooleans := Value;
end;

procedure TImageDBGrid_Read_DateTimePicker(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TImageDBGrid(Args.Obj).DateTimePicker);
end;

procedure TImageDBGrid_Write_DateTimePicker(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TImageDBGrid(Args.Obj).DateTimePicker := V2O(Value) as TjvDBDateEdit;
end;

procedure TImageDBGrid_Read_ImageFields(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TImageDBGrid(Args.Obj).ImageFields);
end;

procedure TImageDBGrid_AddImageField(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TImageDBGrid(Args.Obj).AddImageField(string(Args.Values[0]), string(Args.Values[1]),
    string(Args.Values[2]), Args.Values[3], Args.Values[4]);
end;

procedure TImageDBGrid_Read_DateFields(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TImageDBGrid(Args.Obj).DateFields;
end;

procedure TImageDBGrid_Write_DateFields(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TImageDBGrid(Args.Obj).DateFields := Value;
end;}

{procedure TDBGrid_Read_EditorMode(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TDBGrid(Args.Obj).EditorMode;
end;

procedure TDBGrid_Write_EditorMode(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TDBGrid(Args.Obj).EditorMode := Value;
end;}

procedure TFont_SetStyle(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TFont(Args.Obj).Style := TFontStyles(byte(V2S(Args.Values[0])));
end;

{ TFormStorage }

procedure TFormStorage_Read_AppStorage(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TjvFormStorage(Args.Obj).AppStorage);
end;

procedure TFormStorage_Write_AppStorage(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TjvFormStorage(Args.Obj).AppStorage := V2O(Value) as TjvCustomAppStorage;
end;

procedure TFormStorage_Read_AppStoragePath(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TjvFormStorage(Args.Obj).AppStoragePath;
end;

procedure TFormStorage_Write_AppStoragePath(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TjvFormStorage(Args.Obj).AppStoragePath := Value;
end;

procedure TFormStorage_RestoreFormPlacement(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TjvFormStorage(Args.Obj).RestoreFormPlacement;
end;

procedure TFormStorage_SaveFormPlacement(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TjvFormStorage(Args.Obj).SaveFormPlacement;
end;

procedure RAI2_MainAppStorage(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TSettingsManager.Instance.Storage);
end;

procedure RAI2_MainFormStorage(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(MForm.MainFormStorage);
end;

procedure RAI2_ExtractTimeStr(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ExtractTimeStr(Args.Values[0]);
end;

procedure RAI2_ReplaceTime(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ReplaceTime(TVarData(Args.Values[0]).vDate, Args.Values[1]);
end;

procedure RAI2_VarToStrQ(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if VarIsNull(Args.Values[0]) then
    Value := '?'
  else if (VarType(Args.Values[0]) = varString) and (string(Args.Values[0]) = '') then
    Value := '?'
  else
    Value := VarToStr(Args.Values[0]);
end;

procedure TMenuItem_Clear(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TMenuItem(Args.Obj).Clear;
end;

procedure TDBLookupComboBox_Read_KeyValue(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TDBLookupComboBox(Args.Obj).KeyValue;
end;

procedure TDBLookupComboBox_Write_KeyValue(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TDBLookupComboBox(Args.Obj).KeyValue := Value;
end;

function FindNextControl(ParentControl, CurControl: TWinControl;
  GoForward, CheckTabStop, CheckParent: Boolean): TWinControl;
var
  I, StartIndex: Integer;
  List: TList;
begin
  Result := nil;
  List := TList.Create;
  try
    ParentControl.GetTabOrderList(List);
    if List.Count > 0 then
    begin
      StartIndex := List.IndexOf(CurControl);
      if StartIndex = -1 then
        if GoForward then StartIndex := List.Count - 1 else StartIndex := 0;
      I := StartIndex;
      repeat
        if GoForward then
        begin
          Inc(I);
          if I = List.Count then I := 0;
        end else
        begin
          if I = 0 then I := List.Count;
          Dec(I);
        end;
        CurControl := List[I];
        if CurControl.CanFocus and
          (not CheckTabStop or CurControl.TabStop) and
          (not CheckParent or (CurControl.Parent = ParentControl)) then
          Result := CurControl;
      until (Result <> nil) or (I = StartIndex);
    end;
  finally
    List.Free;
  end;
end;

procedure TWinControl_FindNextControl(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(FindNextControl(Args.Obj as TWinControl, V2O(Args.Values[0]) as TWinControl,
     Args.Values[1], Args.Values[2], Args.Values[3]));
end;

{ Utility functions }

procedure RAI2_NvlInteger(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := NvlInteger(Args.Values[0]);
end;

procedure RAI2_NvlBoolean(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := NvlBoolean(Args.Values[0]);
end;

procedure RAI2_NvlFloat(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := NvlFloat(Args.Values[0]);
end;

procedure RAI2_NvlString(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := NvlString(Args.Values[0]);
end;

procedure Read_GlobalVar(var Value: Variant; Args: TJvInterpreterArgs);
var
  i: integer;
begin
  i := GlobalVars.IndexOf(string(Args.Values[0]));
  if i >= 0 then
    Value := (GlobalVars.Objects[i] as TGlobalVar).Value
  else
    Value := null;
end;

procedure Write_GlobalVar(var Value: Variant; Args: TJvInterpreterArgs);
var
  i: integer;
  gv: TGlobalVar;
begin
  i := GlobalVars.IndexOf(string(Args.Values[0]));
  if i >= 0 then
  begin
    if VarIsNull(Args.Values[1]) then
    begin
      if Options.VerboseLog then
        TLogger.GetInstance.Debug('Сброс ' + Args.Values[0]);
      GlobalVars.Objects[i].Free;
      GlobalVars.Delete(i);
    end
    else
      (GlobalVars.Objects[i] as TGlobalVar).Value := Args.Values[1];
  end
  else
  begin  // Если такой переменной не было, создаем новую
    if Options.VerboseLog then
      TLogger.GetInstance.Debug('Установка ' + Args.Values[0]);
    gv := TGlobalVar.Create;
    gv.Value := Args.Values[1];
    GlobalVars.AddObject(string(Args.Values[0]), gv);
  end;
end;

procedure JvInterpreter_GetServerDateTime(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := dm.GetCurrentServerDate;
end;

// -------------------------------------------------------------------------------

{type
  TJvInterpreterDbGridEvent = class(TJvInterpreterEvent)
  private
    procedure DrawColumnCellEvent(Sender: TObject; const ARect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridClickEvent(Column: TColumn);
    procedure MovedEvent(Sender: TObject; FromIndex, ToIndex: Longint);
    procedure GetCellParamsEvent(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure GetBtnParamsEvent(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; var ASortMarker: TSortMarker;
      IsDown: Boolean);
  end;

procedure TJvInterpreterDbGridEvent.DrawColumnCellEvent(Sender: TObject; const ARect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  CallFunction(nil, [O2V(Sender), Rect2Var(ARect), DataCol, O2V(Column), S2V(Byte(State))]);
end;

procedure TJvInterpreterDbGridEvent.DBGridClickEvent(Column: TColumn);
begin
  CallFunction(nil, [O2V(Column)]);
end;

procedure TJvInterpreterDbGridEvent.MovedEvent(Sender: TObject; FromIndex, ToIndex: Longint);
begin
  CallFunction(nil, [O2V(Sender), FromIndex, ToIndex]);
end;

procedure TJvInterpreterDbGridEvent.GetCellParamsEvent(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
  CallFunction(nil, [O2V(Sender), O2V(Field), O2V(AFont), Background, Highlight]);
  Background := Args.Values[3];
end;

procedure TJvInterpreterDbGridEvent.GetBtnParamsEvent(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; var ASortMarker: TSortMarker;
      IsDown: Boolean);
begin
  CallFunction(nil, [O2V(Sender), O2V(Field), O2V(AFont), Background, ASortMarker, IsDown]);
  Background := Args.Values[3];
  ASortMarker := Args.Values[4];
end;
}
type
  TJvMenuEvent = class(TJvInterpreterEvent)
  private
    procedure ItemParamsEvent(Sender: TMenu; Item: TMenuItem;
      State: TMenuOwnerDrawState; AFont: TFont; var Color: TColor;
      var Graphic: TGraphic; var NumGlyphs: Integer);
  end;

procedure TJvMenuEvent.ItemParamsEvent(Sender: TMenu; Item: TMenuItem;
      State: TMenuOwnerDrawState; AFont: TFont; var Color: TColor;
      var Graphic: TGraphic; var NumGlyphs: Integer);
begin
  CallFunction(nil, [O2V(Sender), O2V(Item), S2V(byte(State)), O2V(AFont), Color, O2V(Graphic), NumGlyphs]);
  Color := Args.Values[4];
  Graphic := V2O(Args.Values[5]) as TGraphic;
  NumGlyphs := Args.Values[6];
end;

procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);
begin
  with JvInterpreterAdapter do
  begin
    AddFunction('CalcSrv', 'DefaultCalcFields', RAI2_DefCalcFields, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'StandardCalcFields', RAI2_DefCalcFields, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'AutoTech', RAI2_AutoTech, 0, [0], varEmpty);

    // список справочников
    AddFunction('OrdRep', 'GetDictionaryList', JvInterpreter_GetDictionaryList, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'GetDictionary', RAI2_GetDictionary, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'FindDictionaryByID', JvInterpreter_FindDictionaryByID, 1, [varEmpty], varEmpty);
    AddConstEx('CalcSrv', 'DimValueField', DimValueField, nil);
    AddConstEx('CalcSrv', 'DicItemValueField', F_DicItemValue, nil);

    AddFunction('CalcSrv', 'GetNProductValue', RAI2_GetNProductValue, 2, [varEmpty, varEmpty], varEmpty);
    //AddFunction('CalcSrv', 'DefaultNewRecord', RAI2_DefaultNewRecord, 0, [varEmpty], varEmpty);
    // Получить значение параметра заказа по имени
    AddFunction('CalcSrv', 'GetParamValue', RAI2_GetParamValue, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'GetOldParamValue', RAI2_GetOldParamValue, 1, [varEmpty], varEmpty);
    // Получить имя изменившегося параметра
    AddFunction('CalcSrv', 'ParamChanged', RAI2_GetParamChanged, 0, [varEmpty], varEmpty);

    // Получить имя изменившегося поля
    AddFunction('CalcSrv', 'FieldChanged', RAI2_FieldChanged, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'OldFieldValue', RAI2_OldFieldValue, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'CurrentField', RAI2_CurField, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'SetCurrentField', RAI2_SetCurField, 1, [varEmpty], varEmpty);
    // Отображение меню из по справочнику
    AddFunction('CalcSrv', 'MakeMenu', RAI2_MakeMenu, 1, [varEmpty], varEmpty);
    // Отображение меню из по справочнику с указанием диапазона
    AddFunction('CalcSrv', 'MakeMenuRange', RAI2_MakeMenuRange, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    // Отображение меню из любого набора данных
    AddFunction('CalcSrv', 'MakeMenuFromDataSet', RAI2_MakeMenuFromDataSet, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    // Заполнение меню из по справочнику
    AddFunction('CalcSrv', 'FillPopupMenuStd', RAI2_FillPopupMenuStd, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    // Заполнение меню из по справочнику с указанием диапазона
    AddFunction('CalcSrv', 'FillPopupMenu', RAI2_FillPopupMenu, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    // Ключ пункта меню, выбранного ползователем
    AddFunction('CalcSrv', 'ItemSelected', RAI2_ItemSelected, 0, [0], varEmpty);
    //AddFunction('CalcSrv', 'USDCourse', RAI2_USDCourse, 0, [0], varEmpty);
    // Вызов сценария процесса
    AddFunction('CalcSrv', 'CallServiceScript', RAI2_CallSrvScript, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'CallOrderScript', RAI2_CallOrdScript, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'CallGlobalScript', RAI2_CallGlobScript, 1, [varEmpty], varEmpty);
    // Получение значения поля данных процесса
    AddFunction('CalcSrv', 'Field', RAI2_Field, 1, [varEmpty], varEmpty);
    // Изменение значения поля данных процесса
    AddFunction('CalcSrv', 'SetField', RAI2_SetField, 2, [varEmpty, varEmpty], varEmpty);

    AddFunction('CalcSrv', 'GetService', RAI2_ServiceByDesc, 1, [varEmpty], varEmpty);  // obsolete
    AddFunction('CalcSrv', 'ServiceByDesc', RAI2_ServiceByDesc, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'FindService', RAI2_FindService, 1, [varEmpty], varEmpty);
//    AddFunction('CalcSrv', 'ShowMessage', RAI2_ShowMsg, 2, [varEmpty, varEmpty], varEmpty);
    AddFunction('CalcSrv', 'CurService', RAI2_CurSrv, 0, [0], varEmpty);
    //AddFunction('CalcSrv', 'CurProcess', RAI2_CurSrv, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'ServiceByName', RAI2_ServiceByName, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'ServiceByNameNoOpen', RAI2_ServiceByNameNoOpen, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'FindServiceNoOpen', RAI2_FindServiceNoOpen, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'FindServiceByID', RAI2_FindServiceByID, 1, [varEmpty], varEmpty);

    AddFunction('CalcSrv', 'CurGrid', RAI2_CurGrid, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'GridByName', RAI2_GridByName, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'FindGrid', RAI2_FindGrid, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'FindGridNoOpen', RAI2_FindGridNoOpen, 1, [varEmpty], varEmpty);

    AddFunction('CalcSrv', 'RecNo', RAI2_RecNo, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'MainForm', RAI2_MainForm, 0, [0], varEmpty);
    // OnDrawCell - ДОРАБОТАТЬ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    AddFunction('CalcSrv', 'Font', RAI2_Font, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'Highlight', RAI2_Highlight, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'Background', RAI2_GetBackground, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'SetBackground', RAI2_GetBackground, 1, [varEmpty], varEmpty);
    // OnGetText
    AddFunction('CalcSrv', 'DisplayText', RAI2_DisplayText, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'SetText', RAI2_SetText, 1, [varEmpty], varEmpty);
    // SQL
    AddFunction('CalcSrv', 'DefaultDrawEnabledColumn', RAI2_DefaultDrawEnabledColumn, 5, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddFunction('CalcSrv', 'SelectDate', RAI2_SelectDate, 7, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddFunction('CalcSrv', 'CutTime', RAI2_CutTime, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'FormatTotal', RAI2_FormatTotal, 2, [varEmpty, varEmpty], varEmpty);
    AddFunction('CalcSrv', 'GrandTotal', RAI2_GrandTotal, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'GrandTotalGrn', RAI2_GrandTotalGrn, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'ClientTotal', RAI2_ClientTotal, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'SetClientTotal', RAI2_SetClientTotal, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'SetClientTotalGrn', RAI2_SetClientTotalGrn, 1, [varEmpty], varEmpty);

    AddFunction('CalcSrv', 'TotalOwnCost', RAI2_GetTotalOwnCost, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'TotalContractorCost', RAI2_GetTotalContractorCost, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'TotalMatCost', RAI2_GetTotalMatCost, 0, [0], varEmpty);

    AddFunction('CalcSrv', 'TotalOwnProfitCost', RAI2_GetTotalOwnProfitCost, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'TotalContractorProfitCost', RAI2_GetTotalContractorProfitCost, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'TotalMatProfitCost', RAI2_GetTotalMatProfitCost, 0, [0], varEmpty);

    AddFunction('CalcSrv', 'TotalOwnCostForProfit', RAI2_GetTotalOwnCostForProfit, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'TotalContractorCostForProfit', RAI2_GetTotalContractorCostForProfit, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'TotalMatCostForProfit', RAI2_GetTotalMatCostForProfit, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'UpdateContractorPercent', RAI2_UpdateContractorPercent, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'UpdateOwnPercent', RAI2_UpdateOwnPercent, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'UpdateMatPercent', RAI2_UpdateMatPercent, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'UpdateContractorProfit', RAI2_UpdateContractorProfit, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'UpdateOwnProfit', RAI2_UpdateOwnProfit, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'UpdateMatProfit', RAI2_UpdateMatProfit, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'GetContractorPercent', RAI2_GetContractorPercent, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'GetOwnPercent', RAI2_GetOwnPercent, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'GetMatPercent', RAI2_GetMatPercent, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'GetContractorProfit', RAI2_GetContractorProfit, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'GetOwnProfit', RAI2_GetOwnProfit, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'GetMatProfit', RAI2_GetMatProfit, 0, [0], varEmpty);

    AddFunction('CalcSrv', 'USDCourse', RAI2_USDCourse, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'SetItemParam', RAI2_SetItemParam, 2, [varEmpty, varEmpty], varEmpty);
    AddFunction('CalcSrv', 'ItemData', RAI2_ItemData, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'MaterialData', RAI2_MaterialData, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'CalcExecState', RAI2_CalcExecState, 1, [varEmpty], varEmpty);
    // Материалы
    AddFunction('CalcSrv', 'SetMaterial', RAI2_SetMaterial, 5, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddFunction('CalcSrv', 'SetMaterialEx', RAI2_SetMaterialEx, 8, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddFunction('CalcSrv', 'SetFactMaterial', RAI2_SetFactMaterial, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFunction('CalcSrv', 'SetOperation', RAI2_SetOperation, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFunction('CalcSrv', 'ClearMaterial', RAI2_ClearMaterial, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'ReplaceMaterial', RAI2_ReplaceMaterial, 5, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddFunction('CalcSrv', 'ReplaceMaterialEx', RAI2_ReplaceMaterialEx, 8, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddFunction('CalcSrv', 'ClearAllMaterials', RAI2_ClearAllMaterials, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'ClearOperation', RAI2_ClearOperation, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'ProcessDependentPart', RAI2_ProcessDependentPart, 1, [varEmpty], varEmpty);
    // Связанные процессы
    AddFunction('CalcSrv', 'AddChildProcess', RAI2_AddChildProcess, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'RemoveChildProcess', RAI2_RemoveChildProcess, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'LocateChildProcess', RAI2_LocateChildProcess, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'SetParentID', RAI2_SetLinkedItemID, 1, [varEmpty], varEmpty);

    AddConst('CalcSrv', 'clScrollBar', clScrollBar);
    AddConst('CalcSrv', 'clBackground',  clBackground);
    AddConst('CalcSrv', 'clActiveCaption', clActiveCaption);
    AddConst('CalcSrv', 'clInactiveCaption', clInactiveCaption);
    AddConst('CalcSrv', 'clMenu', clMenu);
    AddConst('CalcSrv', 'clWindow', clWindow);
    AddConst('CalcSrv', 'clWindowFrame', clWindowFrame);
    AddConst('CalcSrv', 'clMenuText', clMenuText);
    AddConst('CalcSrv', 'clWindowText', clWindowText);
    AddConst('CalcSrv', 'clCaptionText', clCaptionText);
    AddConst('CalcSrv', 'clActiveBorder', clActiveBorder);
    AddConst('CalcSrv', 'clInactiveBorder', clInactiveBorder);
    AddConst('CalcSrv', 'clAppWorkSpace', clAppWorkSpace);
    AddConst('CalcSrv', 'clHighlight', clHighlight);
    AddConst('CalcSrv', 'clHighlightText', clHighlightText);
    AddConst('CalcSrv', 'clBtnFace', clBtnFace);
    AddConst('CalcSrv', 'clBtnShadow', clBtnShadow);
    AddConst('CalcSrv', 'clGrayText', clGrayText);
    AddConst('CalcSrv', 'clBtnText', clBtnText);
    AddConst('CalcSrv', 'clInactiveCaptionText', clInactiveCaptionText);
    AddConst('CalcSrv', 'clBtnHighlight', clBtnHighlight);
    AddConst('CalcSrv', 'cl3DDkShadow', cl3DDkShadow);
    AddConst('CalcSrv', 'cl3DLight', cl3DLight);
    AddConst('CalcSrv', 'clInfoText', clInfoText);
    AddConst('CalcSrv', 'clInfoBk', clInfoBk);
    AddConst('CalcSrv', 'clBlack',  clBlack);
    AddConst('CalcSrv', 'clMaroon', clMaroon);
    AddConst('CalcSrv', 'clGreen', clGreen);
    AddConst('CalcSrv', 'clOlive', clOlive);
    AddConst('CalcSrv', 'clNavy', clNavy);
    AddConst('CalcSrv', 'clPurple', clPurple);
    AddConst('CalcSrv', 'clTeal', clTeal);
    AddConst('CalcSrv', 'clGray', clGray);
    AddConst('CalcSrv', 'clSilver', clSilver);
    AddConst('CalcSrv', 'clRed', clRed);
    AddConst('CalcSrv', 'clLime', clLime);
    AddConst('CalcSrv', 'clYellow', clYellow);
    AddConst('CalcSrv', 'clBlue', clBlue);
    AddConst('CalcSrv', 'clFuchsia', clFuchsia);
    AddConst('CalcSrv', 'clAqua', clAqua);
    AddConst('CalcSrv', 'clLtGray', clLtGray);
    AddConst('CalcSrv', 'clDkGray', clDkGray);
    AddConst('CalcSrv', 'clWhite', clWhite);
    AddConst('CalcSrv', 'clNone', clNone);
    AddConst('CalcSrv', 'clDefault', clDefault);
    // Это надо? В excel-отчетах определяются эти константы
    AddConst('CalcSrv', 'mtWarning', Ord(mtWarning));
    AddConst('CalcSrv', 'mtError', Ord(mtError));
    AddConst('CalcSrv', 'mtInformation', Ord(mtInformation));
    AddConst('CalcSrv', 'mtConfirmation', Ord(mtConfirmation));
    AddConst('CalcSrv', 'mtCustom', Ord(mtCustom));

    AddClass('CalcSrv', TDictionary, 'TDictionary');
    AddGet(TDictionary, 'Value', TDicElement_Get_Value, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(TDictionary, 'CurrentValue', TDicElement_Get_CurrentValue, 1, [varEmpty], varEmpty);
    AddGet(TDictionary, 'CurrentCode', TDicElement_Get_CurrentCode, 0, [0], varEmpty);
    AddGet(TDictionary, 'CurrentParentCode', TDicElement_Get_CurrentParentCode, 0, [0], varEmpty);
    AddGet(TDictionary, 'CurrentEnabled', TDicElement_Get_CurrentEnabled, 0, [0], varEmpty);
    AddGet(TDictionary, 'CurrentIsNull', TDicElement_Get_CurrentIsNull, 1, [varEmpty], varEmpty);
    AddGet(TDictionary, 'CurrentName', TDicElement_Get_CurrentName, 0, [0], varEmpty);
    AddGet(TDictionary, 'Value2D', TDicElement_Get_Value2D, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TDictionary, 'Value3D', TDicElement_Get_Value3D, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TDictionary, 'Value4D', TDicElement_Get_Value4D, 5, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TDictionary, 'Value5D', TDicElement_Get_Value5D, 6, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TDictionary, 'Code', TDicElement_Get_Code, 1, [varEmpty], varEmpty);
    AddGet(TDictionary, 'Name', TDicElement_Get_Name, 1, [varEmpty], varEmpty);
    AddGet(TDictionary, 'Enabled', TDicElement_Get_Enabled, 1, [varEmpty], varEmpty);
    AddGet(TDictionary, 'DataSet', TDicElement_Get_DataSet, 0, [0], varEmpty);
    AddGet(TDictionary, 'MultiDim', TDicElement_Get_MultiDim, 0, [0], varEmpty);
    AddGet(TDictionary, 'MultiDataSet', TDicElement_Get_MultiDataSet, 0, [0], varEmpty);
    AddGet(TDictionary, 'Description', TDicElement_Get_Description, 0, [0], varEmpty);
    AddGet(TDictionary, 'GetFieldDesc', TDicElement_GetFieldDesc, 1, [varEmpty], varEmpty);

    AddClass('CalcSrv', TPolyProcess, 'TService');
    AddGet(TPolyProcess, 'FullName', TPolyProcess_Get_FullName, 0, [0], varEmpty);
    AddGet(TPolyProcess, 'Name', TPolyProcess_Get_Name, 0, [0], varEmpty);
    AddGet(TPolyProcess, 'Locate', TPolyProcess_Locate, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(TPolyProcess, 'ShowMessage', TPolyProcess_ShowMsg, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(TPolyProcess, 'DebugMsg', TPolyProcess_DebugMsg, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(TPolyProcess, 'Field', TPolyProcess_Field, 1, [varEmpty], varEmpty);
    AddGet(TPolyProcess, 'SetField', TPolyProcess_SetField, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(TPolyProcess, 'Append', TPolyProcess_Append, 0, [0], varEmpty);
    AddGet(TPolyProcess, 'Delete', TPolyProcess_Delete, 0, [0], varEmpty);
    AddGet(TPolyProcess, 'IsEmpty', TPolyProcess_IsEmpty, 0, [0], varEmpty);
    AddGet(TPolyProcess, 'CallServiceScript', TPolyProcess_CallSrvScript, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(TPolyProcess, 'OnlyWorkOrder', TPolyProcess_OnlyWorkOrder, 0, [0], varEmpty);
    AddGet(TPolyProcess, 'ProcessID', TPolyProcess_ProcessID, 0, [0], varEmpty);
    AddGet(TPolyProcess, 'GetMaterialData', TPolyProcess_GetMaterialData, 1, [varEmpty], varEmpty);

    AddGet(TPolyProcess, 'TotalCost', TPolyProcess_GetTotalCost, 0, [0], varEmpty);
    // больше не поддерживается, пока оставлены для отлова их вызовов.
    AddGet(TPolyProcess, 'CalcTotalCost', TPolyProcess_CalcTotalCost, 0, [0], varEmpty);

    AddGet(TPolyProcess, 'Grids', TPolyProcess_GetGrid, 0, [0], varEmpty);
    AddGet(TPolyProcess, 'DataSet', TPolyProcess_DataSet, 0, [0], varEmpty);
    AddGet(TPolyProcess, 'DataSource', TPolyProcess_DataSource, 0, [0], varEmpty);
    //AddGet(TPolyProcess, 'EditDateField', TPolyProcess_EditDateField, 0, [0], varEmpty);
    AddGet(TPolyProcess, 'UseInProfitMode', TPolyProcess_GetUseInProfitMode, 0, [0], varEmpty);
    AddGet(TPolyProcess, 'DefaultEquipGroupCode', TPolyProcess_DefaultEquipGroupCode, 0, [0], varEmpty);
    AddGet(TPolyProcess, 'SequenceOrder', TPolyProcess_SequenceOrder, 0, [0], varEmpty);

    AddGet(TPolyProcess, 'PermitUpdate', TPolyProcess_PermitUpdate, 0, [0], varEmpty);
    AddGet(TPolyProcess, 'PermitInsert', TPolyProcess_PermitInsert, 0, [0], varEmpty);
    AddGet(TPolyProcess, 'PermitDelete', TPolyProcess_PermitDelete, 0, [0], varEmpty);
    AddGet(TPolyProcess, 'PermitPlan', TPolyProcess_PermitPlan, 0, [0], varEmpty);
    AddGet(TPolyProcess, 'PermitFact', TPolyProcess_PermitFact, 0, [0], varEmpty);

    { TProcessGrid }
    AddClass('CalcSrv', TProcessGrid, 'TProcessGrid');
    AddGet(TProcessGrid, 'Page', TProcessGrid_Page, 0, [0], varEmpty);
    AddGet(TProcessGrid, 'PageFrame', TProcessGrid_PageFrame, 0, [0], varEmpty);
    AddGet(TProcessGrid, 'GridControl', TProcessGrid_GetGridControl, 0, [0], varEmpty);
    AddGet(TProcessGrid, 'TotalPanel', TProcessGrid_GetTotalPanel, 0, [0], varEmpty);
    AddSet(TProcessGrid, 'TotalPanel', TProcessGrid_SetTotalPanel, 0, [0]);
    AddGet(TProcessGrid, 'TotalCost', TProcessGrid_GetTotalCost, 0, [0], varEmpty);
    AddGet(TProcessGrid, 'Total', TProcessGrid_GetTotal, 1, [varEmpty], varEmpty);

   { TJvDBGrid }
{    AddClass('JvDbGrid', TJvDBGrid, 'TJvDBGrid');
    AddGet(TJvDBGrid, 'Create', TJvDBGrid_Create, 1, [varEmpty], varEmpty);
    AddGet(TJvDBGrid, 'ShowGlyphs', TJvDBGrid_Read_ShowGlyphs, 0, [0], varEmpty);
    AddSet(TJvDBGrid, 'ShowGlyphs', TJvDBGrid_Write_ShowGlyphs, 0, [0]);
    AddGet(TJvDBGrid, 'TitleButtons', TJvDBGrid_Read_TitleButtons, 0, [0], varEmpty);
    AddSet(TJvDBGrid, 'TitleButtons', TJvDBGrid_Write_TitleButtons, 0, [0]);
    AddConst('JvDBGrid', 'smNone', smNone);
    AddConst('JvDBGrid', 'smUp', smUp);
    AddConst('JvDBGrid', 'smDown', smDown);
    AddGet(TJvDBGrid, 'SortMarker', TJvDBGrid_Read_SortMarker, 0, [0], varEmpty);
    AddSet(TJvDBGrid, 'SortMarker', TJvDBGrid_Write_SortMarker, 0, [0]);
    AddGet(TJvDBGrid, 'SortedField', TJvDBGrid_Read_SortedField, 0, [0], varEmpty);
    AddSet(TJvDBGrid, 'SortedField', TJvDBGrid_Write_SortedField, 0, [0]);
    AddGet(TJvDBGrid, 'AlternateRowColor', TJvDBGrid_Read_AlternateRowColor, 0, [0], varEmpty);
    AddSet(TJvDBGrid, 'AlternateRowColor', TJvDBGrid_Write_AlternateRowColor, 0, [0]);
    AddGet(TJvDBGrid, 'AutoAppend', TJvDBGrid_Read_AutoAppend, 0, [0], varEmpty);
    AddSet(TJvDBGrid, 'AutoAppend', TJvDBGrid_Write_AutoAppend, 0, [0]);
    AddGet(TJvDBGrid, 'AutoSizeColumnIndex', TJvDBGrid_Read_AutoSizeColumnIndex, 0, [0], varEmpty);
    AddSet(TJvDBGrid, 'AutoSizeColumnIndex', TJvDBGrid_Write_AutoSizeColumnIndex, 0, [0]);
    AddGet(TJvDBGrid, 'AutoSizeColumns', TJvDBGrid_Read_AutoSizeColumns, 0, [0], varEmpty);
    AddSet(TJvDBGrid, 'AutoSizeColumns', TJvDBGrid_Write_AutoSizeColumns, 0, [0]);
    AddGet(TJvDBGrid, 'IniStorage', TJvDBGrid_Read_IniStorage, 0, [0], varEmpty);
    AddSet(TJvDBGrid, 'IniStorage', TJvDBGrid_Write_IniStorage, 0, [0]);}
    {AddGet(TJvDBGrid, 'EditorMode', TJvDBGrid_Read_EditorMode, 0, [0], varEmpty);
    AddSet(TJvDBGrid, 'EditorMode', TJvDBGrid_Write_EditorMode, 0, [0]);}
{    AddGet(TDBGrid, 'EditorMode', TDBGrid_Read_EditorMode, 0, [0], varEmpty);
    AddSet(TDBGrid, 'EditorMode', TDBGrid_Write_EditorMode, 0, [0]);}
{    AddHandler('DbGrids', 'TDrawColumnCellEvent', TjvInterpreterDBGridEvent, @TJvInterpreterDbGridEvent.DrawColumnCellEvent);
    AddHandler('DbGrids', 'TDBGridClickEvent', TjvInterpreterDBGridEvent, @TJvInterpreterDbGridEvent.DBGridClickEvent);
    AddHandler('DbGrids', 'TMovedEvent', TjvInterpreterDBGridEvent, @TJvInterpreterDbGridEvent.MovedEvent);
    AddHandler('DbGrids', 'TGetCellParamsEvent', TjvInterpreterDBGridEvent, @TJvInterpreterDbGridEvent.GetCellParamsEvent);
    AddHandler('DbGrids', 'TGetBtnParamsEvent', TjvInterpreterDBGridEvent, @TJvInterpreterDbGridEvent.GetBtnParamsEvent);}

    { Дополнительные состояния к TDataSetState }
    AddConst('Db', 'dsBlockRead', dsBlockRead);
    AddConst('Db', 'dsInternalCalc', dsInternalCalc);
    AddConst('Db', 'dsOpening', dsOpening);

    { Обход глюка с исползованием множеств }
    AddGet(TFont, 'SetStyle', TFont_SetStyle, 1, [varEmpty], varEmpty);

     { TImageDBGrid }
{    AddClass('ImageDbGrid', TImageDBGrid, 'TImageDBGrid');
    AddGet(TImageDBGrid, 'Create', TImageDBGrid_Create, 1, [varEmpty], varEmpty);
    AddGet(TImageDBGrid, 'AddImageField', TImageDBGrid_AddImageField, 5, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TImageDBGrid, 'ImageFields', TImageDBGrid_Read_ImageFields, 0, [0], varEmpty);
    AddGet(TImageDBGrid, 'DrawBooleans', TImageDBGrid_Read_DrawBooleans, 0, [0], varEmpty);
    AddSet(TImageDBGrid, 'DrawBooleans', TImageDBGrid_Write_DrawBooleans, 0, [0]);
    AddGet(TImageDBGrid, 'DateTimePicker', TImageDBGrid_Read_DateTimePicker, 0, [0], varEmpty);
    AddSet(TImageDBGrid, 'DateTimePicker', TImageDBGrid_Write_DateTimePicker, 0, [0]);
    AddGet(TImageDBGrid, 'DateFields', TImageDBGrid_Read_DateFields, 0, [0], varEmpty);
    AddSet(TImageDBGrid, 'DateFields', TImageDBGrid_Write_DateFields, 0, [0]);}
    { TODO -cInterpreter: добавить описание TImageField }

//    RegisterClasses([TJvDBGrid, TImageDBGrid]);

    AddConst('JvTypes', 'Sun', 0);
    AddConst('JvTypes', 'Mon', 1);
    AddConst('JvTypes', 'Tue', 2);
    AddConst('JvTypes', 'Wed', 3);
    AddConst('JvTypes', 'Thu', 4);
    AddConst('JvTypes', 'Fri', 5);
    AddConst('JvTypes', 'Sat', 6);

    { TFormStorage }
    AddClass('FormStorage', TjvFormStorage, 'TjvFormStorage');
    AddGet(TjvFormStorage, 'AppStorage', TFormStorage_Read_AppStorage, 0, [0], varEmpty);
    AddSet(TjvFormStorage, 'AppStorage', TFormStorage_Write_AppStorage, 0, [0]);
    AddGet(TjvFormStorage, 'AppStoragePath', TFormStorage_Read_AppStoragePath, 0, [0], varEmpty);
    AddSet(TjvFormStorage, 'AppStoragePath', TFormStorage_Write_AppStoragePath, 0, [0]);
    AddGet(TjvFormStorage, 'RestoreFormPlacement', TFormStorage_RestoreFormPlacement, 0, [0], varEmpty);
    AddGet(TjvFormStorage, 'SaveFormPlacement', TFormStorage_SaveFormPlacement, 0, [0], varEmpty);
    RegisterClasses([TJvFormStorage]);

    { TjvPopupMenu }
    AddClass('JvPopupMenu', TjvPopupMenu, 'TjvPopupMenu');
    AddHandler('JvPopupMenu', 'TItemParamsEvent', TjvMenuEvent, @TjvMenuEvent.ItemParamsEvent);
    RegisterClasses([TJvPopupMenu]);

    AddGet(TMenuItem, 'Clear', TMenuItem_Clear, 0, [0], varEmpty); { TODO -cJEDI Bug: Это надо бы внести в JvInterpreter_Menus }
    AddGet(TDBLookupComboBox, 'KeyValue', TDBLookupComboBox_Read_KeyValue, 0, [0], varEmpty); { TODO -cJEDI Bug: Это надо бы внести в JvInterpreter_DBControls }
    AddSet(TDBLookupComboBox, 'KeyValue', TDBLookupComboBox_Write_KeyValue, 0, [0]); { TODO -cJEDI Bug: Это надо бы внести в JvInterpreter_DBControls }
    AddGet(TWinControl, 'FindNextControl', TWinControl_FindNextControl, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty); { TODO -cJEDI Bug: Это надо бы внести в JvInterpreter_Controls }

    AddFunction('CalcSrv', 'MainAppStorage', RAI2_MainAppStorage, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'MainFormStorage', RAI2_MainFormStorage, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'ExtractTimeStr', RAI2_ExtractTimeStr, 1, [varEmpty], varEmpty);

    { TODO -cJEDI Bug: Это надо бы внести в JvInterpreter_SysUtils }
    AddFunction('SysUtils', 'ReplaceTime', RAI2_ReplaceTime, 2, [varByRef, varEmpty], varEmpty);
    AddFunction('SysUtils', 'VarToStrQ', RAI2_VarToStrQ, 1, [varEmpty], varEmpty);

    RegisterClasses([TImageList]);  { TODO -cJEDI Bug: Это надо бы внести в JvInterpreter_Controls }

    AddFunction('SysUtils', 'NvlInteger', RAI2_NvlInteger, 1, [varEmpty], varEmpty);
    AddFunction('SysUtils', 'NvlBoolean', RAI2_NvlBoolean, 1, [varEmpty], varEmpty);
    AddFunction('SysUtils', 'NvlFloat', RAI2_NvlFloat, 1, [varEmpty], varEmpty);
    AddFunction('SysUtils', 'NvlString', RAI2_NvlString, 1, [varEmpty], varEmpty);

    AddFunction('CalcSrv', 'GetGlobalVar', Read_GlobalVar, 1, [varEmpty], varEmpty);
    AddFunction('CalcSrv', 'SetGlobalVar', Write_GlobalVar, 2, [varEmpty, varEmpty], varEmpty);

    AddFunction('CalcSrv', 'GetServerDateTime', JvInterpreter_GetServerDateTime, 0, [0], varEmpty);

    {AddClass('CalcSrv', TServiceList, 'TServiceList');
    AddIGet(TServiceList, 'Service', TServiceList_Read_Service, 1, [0], varEmpty);
    AddIDGet(TServiceList, TDataSet_Read_Service, 1, [0], varEmpty);
    AddGet(TServiceList, 'Count', TServiceList_Read_Count, 0, [0], varEmpty);
    AddFunction('CalcSrv', 'Services', RAI2_Services, 0, [0], varEmpty);}

    { Utility Functions from JVCL}
    {AddFunction('Utils', 'CountOfChar', RAI2_CountOfChar, 2, [varEmpty, varEmpty], varEmpty);
    AddFunction('Utils', 'SubStr', RAI2_SubStr, 3, [varEmpty, varEmpty, varEmpty], varEmpty);}

 end; { with }
end; { RegisterRAI2Adapter }

procedure InitGlobalVars;
begin
  GlobalVars := TStringList.Create;
end;

procedure DoneGlobalVars;
var i: integer;
begin
  if Assigned(GlobalVars) then begin
    for i := 0 to Pred(GlobalVars.Count) do
      if GlobalVars.Objects[i] <> nil then
        GlobalVars.Objects[i].Free;
    FreeAndNil(GlobalVars);
  end;
end;

initialization
  InitGlobalVars

finalization
  DoneGlobalVars;

end.
