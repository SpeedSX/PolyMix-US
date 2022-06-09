unit ServMod;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  PmProcess, DB, JvDBControls, ADODB, Provider,
  ComCtrls, JvAppStorage, ProgressObj, CalcUtils, RDialogs, DBClient, Variants,
  PmDatabase, NotifyEvent, PmConfigManager, PmProcessCfg;

{$I Calc.inc}

type
  TForEachFunc = function(Serv: TPolyProcess): boolean of object;
  TForEachParamFunc = function(Serv: TPolyProcess; Param: pointer): boolean of object;
  TForEachFuncNonObj = function(Serv: TPolyProcess): boolean;

  TOrderContext = record
    NewData, IsDraft, Active: boolean;
    OrderID: integer;
    ProgressObj: TProgressObj;
  end;

  TSrvGroup = class(TCollectionItem)
  public
    Desc: string;
    ID, Number: integer;
  end;

  TGetIDEvent = function(id: integer): integer of object;

  Tsm = class(TDataModule, IRCDataModule)
    procedure DataModuleDestroy(Sender: TObject);
  private
    FIniFS: TJvCustomAppStorage;   // Временно используется при загрузке-сохранении параметров
    //FField: TField; // Временно используется // убрано 28.05.2008
    //TmpNewTirazz: integer; // Временно исп.
    //TmpPage: TPageClass;
    //TmpSrv: TPolyProcess;  28.05.2008
    //TmpPageCost: extended;
    //TmpItemCount: integer;
    FUSDCourse: extended;
    //FSrvGrps: TCollection;
    FSrvOpen: boolean;
    FPrevGrandTotal: extended;
    FClientTotal, FClientTotalGrn, FGrandTotal, FGrandTotalGrn: extended;
    FCostModified: Boolean;
    FTotalExpenseCost: extended;
    FTotalOwnCost, FTotalContractorCost, FTotalMatCost,
    FTotalOwnProfitCost, FTotalContractorProfitCost, FTotalMatProfitCost: extended;
    FTotalOwnCostForProfit, FTotalContractorCostForProfit, FTotalMatCostForProfit: extended;
    FMatProfit, FMatPercent, FContractorProfit, FContractorPercent, FOwnProfit, FOwnPercent: extended;
    //FTotals: TStringList;
    FOrderKind: integer;
    FCurKindProcList: TStringList;
    FOrderContext: TOrderContext;
    ForProfitChanged: boolean;
    OldTotalContractorCost: Extended;
    OldTotalMatCost: Extended;
    OldTotalOwnCost: Extended;
    FInDraft: boolean;
    FContentProtected, FCostProtected: boolean;
    FOnUpdateModified: TNotifyEvent;
    FOnGrandTotalChanged: TNotifyEvent;
    FOnGrnGrandTotalChanged: TNotifyEvent;
    FOnClientCostChanged: TNotifyEvent;
    FOnGridTotalUpdate: TNotifyProcessGridEvent;
    BeforeProcessCfgChangeID, AfterProcessCfgChangeID: TNotifyHandlerID;
    FParentOrder: TObject;
    FOnGetRealProcessItemID: TGetIDEvent;
    FOnUpdateContractorPercent, FOnUpdateOwnPercent, FOnUpdateMatPercent: TNotifyEvent;
    FOnAllProcessParamsToProcessData: TNotifyEvent;
    function EachLoadSettings(Srv: TPolyProcess): boolean;
    function EachSaveSettings(Srv: TPolyProcess): boolean;
    function EachCancelUpdates(Srv: TPolyProcess): boolean;
    function EachClose(Srv: TPolyProcess): boolean;
    function EachFreeDataSets(Srv: TPolyProcess): boolean;
    function EachApplyUpdates(Srv: TPolyProcess): boolean;
    function EachPrepare(Srv: TPolyProcess): boolean;
    //function FindAndCalc(Srv: TPolyProcess): boolean;
    function EachParamChanged(Srv: TPolyProcess): boolean;
    //function EachCalcCost(Srv: TPolyProcess): boolean;
    // Устанавливаем все цены во всех строках данного процесса по прайсу
    // (вызывает скрипт onSetPrices)
    function EachUpdatePrices(Srv: TPolyProcess): boolean;
    function EachCheckSrv(Srv: TPolyProcess): boolean;
    function EachPrepareDBDataSet(Srv: TPolyProcess): boolean;
    procedure SetUSDCourse(Value: extended);
    function EachReadFields(Srv: TPolyProcess): boolean;
    function EachSetupSrv(Srv: TPolyProcess): boolean;
    //function EachUpdateScripts(Srv: TPolyProcess): boolean;
    function EachAfterOpen(Srv: TPolyProcess): boolean;
    procedure SetClientTotal(c: extended);
    procedure SetClientTotalGrn(c: extended);
    function EachScriptedItemParams(Srv: TPolyProcess): boolean;
    function EachAfterOrderOpen(Process: TPolyProcess): boolean;
    //function EachCreateList(Process:TPolyProcess; Param: pointer): Boolean;
    procedure SetOrderKind(_KindID: integer);
    procedure ReadCurKindProcList;
    procedure SetPartField(BaseProcess: TPolyProcess; DepProcess: TPolyProcess);
    procedure SetTotalContractorCost(Value: extended);
    procedure SetTotalMatCost(Value: extended);
    procedure SetTotalOwnCost(Value: extended);
    function EachSetProtection(Process: TPolyProcess): boolean;
    function CreateSrvData(Srv: TPolyProcess): boolean;
    procedure pvSrvBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
      var Applied: Boolean);
    procedure GridTotalUpdate(ProcessGrid: TProcessGrid);
  protected
    DBDataSetsPrepared: boolean;
    FProcessesModified: boolean;
    function PrepareDBDataSets: boolean;
    procedure SetGrandTotal(Value: extended);
    procedure SetTotalOwnCostForProfit(Value: extended);
    procedure SetTotalContractorCostForProfit(Value: extended);
    procedure SetTotalMatCostForProfit(Value: extended);
    procedure HandleProcessModify(Srv: TPolyProcess);
    procedure SetCommonContractorPercent(Percent: extended);
    procedure SetCommonOwnPercent(Percent: extended);
    procedure SetCommonMatPercent(Percent: extended);

    procedure SetContractorProfit(Profit: extended);
    procedure SetOwnProfit(Profit: extended);
    procedure SetMatProfit(Profit: extended);
    procedure BeforeChangeProcessCfg(Sender: TObject);
    procedure AfterChangeProcessCfg(Sender: TObject);
    procedure InitProcesses;
    procedure DoneProcesses;
    function EachCreateServiceComponent(SrvCfg: TPolyProcessCfg): boolean;
  public
    Tirazz: integer;
    DisableFieldChange: boolean;
    DisableGrandTotal: boolean;
    DisableTotalCost: boolean;

    constructor Create(_ParentOrder: TObject);
    destructor Destroy; override;

    // ссылка на родительский объект заказа
    property ParentOrder: TObject read FParentOrder write FParentOrder;
    property InDraft: boolean read FInDraft write FInDraft;
    // Стоимость заказа для клиента в грн
    property ClientTotal: extended read FClientTotal write SetClientTotal;
    // Стоимость заказа для клиента в у.е.
    property ClientTotalGrn: extended read FClientTotalGrn write SetClientTotalGrn;
    // Расчетная стоимость заказа в у.е.
    property GrandTotal: extended read FGrandTotal write SetGrandTotal;
    // Расчетная стоимость заказа в грн.
    property GrandTotalGrn: extended read FGrandTotalGrn;
    // Общая стоимость затрат в грн
    property TotalExpenseCost: extended read FTotalExpenseCost write FTotalExpenseCost;
    // Без наценок:
    // Общая стоимость своих процессов (производства) в уе.
    property TotalOwnCost: extended read FTotalOwnCost write SetTotalOwnCost;
    // Общая стоимость процессов подрядчиков в уе.
    property TotalContractorCost: extended read FTotalContractorCost write SetTotalContractorCost;
    // Общая стоимость материалов в уе.
    property TotalMatCost: extended read FTotalMatCost write SetTotalMatCost;
    // С наценкой: Общая стоимость материалов в уе.
    property TotalMatProfitCost: extended read FTotalMatProfitCost write FTotalMatProfitCost;
    // С наценкой: Общая стоимость производства в уе.
    property TotalOwnProfitCost: extended read FTotalOwnProfitCost write FTotalOwnProfitCost;
    // С наценкой: Общая стоимость субподряда в уе.
    property TotalContractorProfitCost: extended read FTotalContractorProfitCost write FTotalContractorProfitCost;
    // Для вычисление наценки: стоимость материалов в уе. участвующая в наценке
    property TotalMatCostForProfit: extended read FTotalMatCostForProfit write SetTotalMatCostForProfit;
    // Для вычисления наценки: стоимость производства в уе. участвующая в наценке
    property TotalOwnCostForProfit: extended read FTotalOwnCostForProfit write SetTotalOwnCostForProfit;
    // Для вычисления наценки: стоимость субподряда в уе. участвующая в наценке
    property TotalContractorCostForProfit: extended read FTotalContractorCostForProfit write SetTotalContractorCostForProfit;

    property CurOrderKind: integer read FOrderKind write SetOrderKind;

    property ContractorPercent: extended read FContractorPercent write SetCommonContractorPercent;
    property OwnPercent: extended read FOwnPercent write SetCommonOwnPercent;
    property MatPercent: extended read FMatPercent write SetCommonMatPercent;
    property ContractorProfit: extended read FContractorProfit write SetContractorProfit;
    property OwnProfit: extended read FOwnProfit write SetOwnProfit;
    property MatProfit: extended read FMatProfit write SetMatProfit;

    property USDCourse: extended read FUSDCourse write SetUSDCourse;
    property ServicesActive: boolean read FSrvOpen;
    property ProcessesModified: boolean read FProcessesModified write FProcessesModified;
    // срабатывает при изменении состояния модификации процеесов
    property OnUpdateModified: TNotifyEvent read FOnUpdateModified write FOnUpdateModified;
    property OnGrandTotalChanged: TNotifyEvent read FOnGrandTotalChanged write FOnGrandTotalChanged;
    property OnGrnGrandTotalChanged: TNotifyEvent read FOnGrnGrandTotalChanged write FOnGrnGrandTotalChanged;
    property OnClientCostChanged: TNotifyEvent read FOnClientCostChanged write FOnClientCostChanged;
    property OnGridTotalUpdate: TNotifyProcessGridEvent read FOnGridTotalUpdate write FOnGridTotalUpdate;
    property OnGetRealProcessItemID: TGetIDEvent read FOnGetRealProcessItemID write FOnGetRealProcessItemID;
    property OnUpdateContractorPercent: TNotifyEvent read FOnUpdateContractorPercent write FOnUpdateContractorPercent;
    property OnUpdateOwnPercent: TNotifyEvent read FOnUpdateOwnPercent write FOnUpdateOwnPercent;
    property OnUpdateMatPercent: TNotifyEvent read FOnUpdateMatPercent write FOnUpdateMatPercent;
    property OnAllProcessParamsToProcessData: TNotifyEvent read FOnAllProcessParamsToProcessData write FOnAllProcessParamsToProcessData;
    procedure SaveSettings(IniFS: TJvCustomAppStorage);
    procedure LoadSettings(IniFS: TJvCustomAppStorage);
    // Итераторы
    function ForEachProcess(ForEachFunc: TForEachFunc): boolean; overload;
    function ForEachProcess(ForEachParamFunc: TForEachParamFunc; Param: pointer): boolean; overload;
    function ForEachServiceNonObj(ForEachFunc: TForEachFuncNonObj): boolean;
    function ForEachKindProcess(ForEachFunc: TForEachFunc): boolean; overload;
    function ForEachKindProcess(ForEachFunc: TForEachParamFunc; Param: pointer): boolean; overload;
    function ForEachKindProcessNonObj(ForEachFunc: TForEachFuncNonObj): boolean;
    function ForEachItem(cdItem: TDataSet; ForEachFunc: TForEachFunc): boolean;
    // Поиск процесса
    function ServiceByName(const SrvName: string; AutoOpen: boolean): TPolyProcess;
    function ServiceByTabName(const TabName: string; AutoOpen: boolean): TPolyProcess;
    function ServiceByTag(Tag: integer; AutoOpen: boolean): TPolyProcess;
    function ServiceByID(_SrvID: integer; AutoOpen: boolean): TPolyProcess;
    function ServiceByDataSet(_DataSet: TDataSet; AutoOpen: boolean): TPolyProcess;
    function ServiceByDBDataSet(_DBDataSet: TDataSet): TPolyProcess;
    // Поиск таблицы
    function GridByID(_GridID: integer; AutoOpen: boolean): TProcessGrid;
    function GridByName(_GridName: string; AutoOpen: boolean): TProcessGrid;
    procedure CancelUpdates;
    procedure CloseServices;
    procedure FreeDataSets;
    function ApplyAllProcessData: boolean;
    function OpenAllProcessData(NewData, Calc: boolean; OrderID: integer;
      pbProgress: TProgressObj; cdItem: TDataSet): boolean;
    procedure Prepare;
    //procedure ServiceFieldChanged(AField: TField; DoCalcTotal: boolean);
    procedure OrderParamChanged(ParName: string; NewValue: variant);
    //procedure CalcAllCost;
   // Устанавливаем все цены во всех процессах по прайсу
    procedure UpdateAllPrices;
    procedure CheckServices(Msgs: TCollection);
    function AppendChildProcess(ParentPrc: TPolyProcess; ChildProcessName: string):
        TPolyProcess;
    procedure FreeServices;
    procedure ReadServicesFields;
    procedure SetupServices;
    procedure BeforeImportServices;
    procedure AfterImportServices;
    procedure CalcGrnGrandTotal;
    procedure SetScriptedItemParams;
    procedure AfterOrderOpen;
    procedure CreateServiceComponents;

    function LocateChildProcess(ParentPrc: TPolyProcess; ChildProcessName: string):
        TPolyProcess;

    // Открывает процесс с текущими установками (параметрами заказа) FOrderContext
    function OpenProcess(p: TPolyProcess): boolean;

    procedure OpenDataSet(DataSet: TDataSet);
    procedure ProcessDependentPart(BaseProcess: TPolyProcess; DepSrvName: string);
    procedure RemoveChildProcess(ParentPrc: TPolyProcess; ChildProcessName: string);

    // Устанавливает уровень защиты заказа
    procedure SetProtection(_CostProtected, _ContentProtected: boolean);
  end;

implementation

uses ExHandler, PmInit, ServData, JvJVCLUtils, ADOUtils, RDBUtils, JvInterpreter_Reports,
  DataHlp, CalcSettings, PmMaterials, MainData, PmScriptManager, PmOrder;

{$R *.DFM}

constructor Tsm.Create(_ParentOrder: TObject);
begin
  inherited Create(nil);
  FParentOrder := _ParentOrder;
  InitProcesses;
  BeforeProcessCfgChangeID := TConfigManager.Instance.BeforeProcessCfgChange.RegisterHandler(BeforeChangeProcessCfg);
  AfterProcessCfgChangeID := TConfigManager.Instance.ProcessCfgChanged.RegisterHandler(AfterChangeProcessCfg);
  // Подготовка сервисов
  //NotifyProcessCfgRefresh;
  Prepare;
end;

destructor Tsm.Destroy;
begin
  TConfigManager.Instance.BeforeProcessCfgChange.UnRegisterHandler(BeforeProcessCfgChangeID);
  TConfigManager.Instance.ProcessCfgChanged.UnRegisterHandler(AfterProcessCfgChangeID);
  inherited;
end;

procedure Tsm.BeforeChangeProcessCfg(Sender: TObject);
begin
  DoneProcesses;
end;

procedure Tsm.AfterChangeProcessCfg(Sender: TObject);
begin
  InitProcesses;
  Prepare;
end;

procedure Tsm.InitProcesses;
begin
  CreateServiceComponents;
  SetupServices;
end;

procedure Tsm.DoneProcesses;
begin
  FreeServices;
end;

function Tsm.ForEachProcess(ForEachFunc: TForEachFunc): boolean;
var i: integer;
begin
  Result := true;
  if (ComponentCount = 0) then Exit;
  for i := 0 to Pred(ComponentCount) do
    if Components[i] is TPolyProcess then
      if not ForEachFunc(Components[i] as TPolyProcess) then
      begin
        Result := false;
        Exit;
      end;
end;

function Tsm.ForEachProcess(ForEachParamFunc: TForEachParamFunc; Param: pointer): boolean;
var i: integer;
begin
  Result := true;
  if (ComponentCount = 0) then Exit;
  for i := 0 to Pred(ComponentCount) do
    if Components[i] is TPolyProcess then
      if not ForEachParamFunc(Components[i] as TPolyProcess, Param) then
      begin
        Result := false;
        Exit;
      end;
end;

function Tsm.ForEachServiceNonObj(ForEachFunc: TForEachFuncNonObj): boolean;
var i: integer;
begin
  Result := true;
  if (ComponentCount = 0) then Exit;
  for i := 0 to Pred(ComponentCount) do
    if Components[i] is TPolyProcess then
      if not ForEachFunc(Components[i] as TPolyProcess) then begin
        Result := false;
        Exit;
      end;
end;

function Tsm.ForEachKindProcess(ForEachFunc: TForEachFunc): boolean;
var
  i: integer;
  p: TObject;
begin
  Result := true;
  if FCurKindProcList = nil then Exit;
  if FCurKindProcList.Count > 0 then
    for i := 0 to Pred(FCurKindProcList.Count) do begin
      p := FCurKindProcList.Objects[i];
      if p is TPolyProcess then
        if not ForEachFunc(p as TPolyProcess) then begin
          Result := false;
          Exit;
        end;
    end;
end;

function Tsm.ForEachKindProcess(ForEachFunc: TForEachParamFunc; Param: pointer): boolean;
var
  i: integer;
  p: TObject;
begin
  Result := true;
  if FCurKindProcList = nil then Exit;
  if FCurKindProcList.Count > 0 then
    for i := 0 to Pred(FCurKindProcList.Count) do begin
      p := FCurKindProcList.Objects[i];
      if p is TPolyProcess then
        if not ForEachFunc(p as TPolyProcess, Param) then begin
          Result := false;
          Exit;
        end;
    end;
end;

function Tsm.ForEachKindProcessNonObj(ForEachFunc: TForEachFuncNonObj): boolean;
var
  i: integer;
  p: TObject;
begin
  Result := true;
  if FCurKindProcList.Count > 0 then
    for i := 0 to Pred(FCurKindProcList.Count) do begin
      p := FCurKindProcList.Objects[i];
      if p is TPolyProcess then
        if not ForEachFunc(p as TPolyProcess) then begin
          Result := false;
          Exit;
        end;
    end;
end;

function Tsm.ServiceByName(const SrvName: string; AutoOpen: boolean): TPolyProcess;
var i: integer;
begin
  Result := nil;
  if (ComponentCount = 0) then Exit;
  for i := 0 to Pred(ComponentCount) do
    if (Components[i] is TPolyProcess) and
       (AnsiCompareText((Components[i] as TPolyProcess).ServiceName, SrvName) = 0) then begin
      Result := Components[i] as TPolyProcess;
      if AutoOpen then OpenProcess(Result);
      Exit;
    end;
end;

function Tsm.ServiceByID(_SrvID: integer; AutoOpen: boolean): TPolyProcess;
var i: integer;
begin
  Result := nil;
  if (ComponentCount = 0) then Exit;
  for i := 0 to Pred(ComponentCount) do
    if (Components[i] is TPolyProcess)
        and ((Components[i] as TPolyProcess).SrvID = _SrvID) then begin
      Result := Components[i] as TPolyProcess;
      if AutoOpen then OpenProcess(Result);
      Exit;
    end;
end;

function Tsm.GridByID(_GridID: integer; AutoOpen: boolean): TProcessGrid;
var
  i, j: integer;
  Srv: TGridPolyProcess;
  go: TProcessGrid;
begin
  Result := nil;
  if (ComponentCount = 0) then Exit;
  for i := 0 to Pred(ComponentCount) do
    if (Components[i] is TGridPolyProcess) then begin
      Srv := Components[i] as TGridPolyProcess;
      if Srv.Grids.Count > 0 then
        for j := 0 to Pred(Srv.Grids.Count) do begin
          go := Srv.Grids.Items[j] as TProcessGrid;
          if go.GridID = _GridID then begin
            if AutoOpen then OpenProcess(Srv);
            Result := go;
            Exit;
          end;
        end;
    end;
end;

function Tsm.GridByName(_GridName: string; AutoOpen: boolean): TProcessGrid;
var
  i, j: integer;
  Srv: TGridPolyProcess;
  go: TProcessGrid;
begin
  Result := nil;
  if (ComponentCount = 0) then Exit;
  for i := 0 to Pred(ComponentCount) do
    if (Components[i] is TGridPolyProcess) then begin
      Srv := Components[i] as TGridPolyProcess;
      if Srv.Grids.Count > 0 then
        for j := 0 to Pred(Srv.Grids.Count) do begin
          go := Srv.Grids.Items[j] as TProcessGrid;
          if CompareText(go.GridCfg.GridName, _GridName) = 0 then begin
            if AutoOpen then OpenProcess(Srv);
            Result := go;
            Exit;
          end;
        end;
    end;
end;

function Tsm.ServiceByTabName(const TabName: string; AutoOpen: boolean): TPolyProcess;
var i: integer;
begin
  Result := nil;
  if (ComponentCount = 0) then Exit;
  for i := 0 to Pred(ComponentCount) do
    if (Components[i] is TPolyProcess)
        and (AnsiCompareText((Components[i] as TPolyProcess).TableName, TabName) = 0) then begin
      Result := Components[i] as TPolyProcess;
      if AutoOpen then OpenProcess(Result);
      Exit;
    end;
end;

function Tsm.ServiceByTag(Tag: integer; AutoOpen: boolean): TPolyProcess;
var i: integer;
begin
  Result := nil;
  if (ComponentCount = 0) then Exit;
  for i := 0 to Pred(ComponentCount) do
    if (Components[i] is TPolyProcess) and (Components[i].Tag = Tag) then begin
      Result := Components[i] as TPolyProcess;
      if AutoOpen then OpenProcess(Result);
      Exit;
    end;
end;

function Tsm.ServiceByDataSet(_DataSet: TDataSet; AutoOpen: boolean): TPolyProcess;
var i: integer;
begin
  Result := nil;
  if (ComponentCount = 0) then Exit;
  for i := 0 to Pred(ComponentCount) do
    if (Components[i] is TPolyProcess)
       and ((Components[i] as TPolyProcess).DataSet = _DataSet) then begin
      Result := Components[i] as TPolyProcess;
      if AutoOpen then OpenProcess(Result);
      Exit;
    end;
end;

function Tsm.ServiceByDBDataSet(_DBDataSet: TDataSet): TPolyProcess;
var i: integer;
begin
  Result := nil;
  if (ComponentCount = 0) then Exit;
  for i := 0 to Pred(ComponentCount) do
    if (Components[i] is TPolyProcess)
        and ((Components[i] as TPolyProcess).DBDataSet = _DBDataSet) then begin
      Result := Components[i] as TPolyProcess;
      Exit;
    end;
end;

function Tsm.EachLoadSettings(Srv: TPolyProcess): boolean;
begin
  Srv.LoadSettings(FIniFS);
  Result := true;
end;

procedure Tsm.LoadSettings(IniFS: TJvCustomAppStorage);
begin
  FIniFS := IniFS;
  ForEachProcess(EachLoadSettings);
end;

function Tsm.EachSaveSettings(Srv: TPolyProcess): boolean;
begin
  Srv.SaveSettings(FIniFS);
  Result := true;
end;

procedure Tsm.SaveSettings(IniFS: TJvCustomAppStorage);
begin
  FIniFS := IniFS;
  ForEachProcess(EachSaveSettings);
end;

procedure Tsm.CancelUpdates;
begin
  ForEachKindProcess(EachCancelUpdates);
end;

function Tsm.EachCancelUpdates(Srv: TPolyProcess): boolean;
begin
  if not Srv.ProcessCfg.OnlyWorkOrder or (not FInDraft) then begin
    Srv.DisableTotals;
    Srv.CancelUpdates;
  end;
  Result := true;
end;

function Tsm.EachFreeDataSets(Srv: TPolyProcess): boolean;
begin
  Srv.FreeDataSets;
  Result := true;
end;

procedure Tsm.FreeDataSets;
var
  i: integer;
  ProcList: TList;
begin
  //ForEachProcess(EachFreeDataSets);
  if (ComponentCount = 0) then Exit;
  ProcList := TList.Create;
  try
    for i := 0 to Pred(ComponentCount) do
      if Components[i] is TPolyProcess then
        ProcList.Add(Components[i]);
    for I := 0 to Pred(ProcList.Count) - 1 do
      TPolyProcess(ProcList[i]).FreeDataSets;
  finally
    ProcList.Free;
  end;

end;

procedure Tsm.FreeServices;
begin
  while ComponentCount > 0 do
    Components[0].Free;
end;

function Tsm.EachClose(Srv: TPolyProcess): boolean;
begin
  if not Srv.ProcessCfg.OnlyWorkOrder or (not InDraft) then
    Srv.Close;
  Result := true;
end;

procedure Tsm.CloseServices;
begin
  if ForEachProcess(EachClose) then FSrvOpen := false;
  FProcessesModified := false;
  FOrderContext.Active := false;
end;

function Tsm.EachApplyUpdates(Srv: TPolyProcess): boolean;
begin
  if not Srv.ProcessCfg.OnlyWorkOrder or (not InDraft) then
    Result := Srv.ApplyUpdates
  else
    Result := true;
end;

function Tsm.ApplyAllProcessData: boolean;
begin
  DisableGrandTotal := true;
  try
    Result := ForEachKindProcess(EachApplyUpdates);
  finally
    DisableGrandTotal := false;
  end;
end;

// Открывает процесс с текущими установками (параметрами заказа)
function Tsm.OpenProcess(p: TPolyProcess): boolean;
begin
  if FOrderContext.Active and not p.DataSet.Active then
  begin
    Result := p.Open(FOrderContext.NewData, FOrderContext.IsDraft,
                     FOrderContext.OrderID);
    if Result then
      FOrderContext.ProgressObj.Position := FOrderContext.ProgressObj.Position  + 1;
  end
  else
    Result := true;
end;

function Tsm.EachAfterOpen(Srv: TPolyProcess): boolean;
begin
  Result := true;
  Srv.DataSet.Filtered := false;  // 24.06.2005 - Чтобы снимался фильтр, который забыли снять при ошибке в отчете.
  Srv.ExecAfterOpen;
end;

procedure Tsm.ReadCurKindProcList;
var
  Arr: TIntArray;
  i: integer;
begin
  Arr := sdm.GetKindProcessArray(FOrderKind);
  if Assigned(FCurKindProcList) then FCurKindProcList.Clear
  else FCurKindProcList := TStringList.Create;
  if Length(Arr) > 0 then
    for i := Low(Arr) to High(Arr) do
      FCurKindProcList.AddObject('', ServiceByID(Arr[i], false));
end;

procedure Tsm.SetOrderKind(_KindID: integer);
begin
  FOrderKind := _KindID;
  ReadCurKindProcList;
end;

function Tsm.ForEachItem(cdItem: TDataSet; ForEachFunc: TForEachFunc): boolean;
var p: TPolyProcess;
begin
  Result := true;
  if not cdItem.IsEmpty then begin
    cdItem.First;
    while not cdItem.eof do begin
      p := ServiceByID(cdItem['ProcessID'], false);
      if p <> nil then
        if not ForEachFunc(p as TPolyProcess) then
        begin
          Result := false;
          Exit;
        end;
      cdItem.Next;
    end;
  end;
end;

function Tsm.OpenAllProcessData(NewData, Calc: boolean; OrderID: integer;
  pbProgress: TProgressObj; cdItem: TDataSet): boolean;
begin
  FOrderContext.NewData := NewData;
  FOrderContext.IsDraft := Calc;
  FOrderContext.OrderID := OrderID;
  FOrderContext.ProgressObj := pbProgress;
  FOrderContext.Active := true;
  if cdItem <> nil then
    pbProgress.Max := cdItem.RecordCount
  else
    pbProgress.Max := FCurKindProcList.Count;
  pbProgress.Min := 0;
  pbProgress.Position := 0;
  pbProgress.Visible := true;
  DisableFieldChange := true;
  DisableGrandTotal := true;
  FPrevGrandTotal := -1;
  if cdItem <> nil then
    Result := ForEachItem(cdItem, OpenProcess)
  else
    Result := ForEachKindProcess(OpenProcess);
  FProcessesModified := false;
  if Result then
  begin
    FOnAllProcessParamsToProcessData(nil);
    DisableFieldChange := false;
    ForEachKindProcess(EachAfterOpen);
    DisableGrandTotal := false;
    FSrvOpen := true;
  end else
    FOrderContext.Active := false;
end;

procedure Tsm.BeforeImportServices;
begin
  DisableFieldChange := true;
  DisableGrandTotal := true;
end;

procedure Tsm.AfterImportServices;
begin
  DisableFieldChange := false;
  ForEachKindProcess(EachAfterOpen);
  DisableGrandTotal := false;
end;

function Tsm.EachPrepare(Srv: TPolyProcess): boolean;
begin
  Result := true;
  Srv.Prepare;
  //Srv.OnFieldChange := ServiceFieldChanged;  // 28.05.2008
  Srv.OnProcessModify := HandleProcessModify;
end;

procedure Tsm.HandleProcessModify(Srv: TPolyProcess);
begin
  if not FProcessesModified then
  begin
    // в режиме защиты состава считаем измененным только если изменился процесс НЕ из состава
    FProcessesModified := {FProcessesModified or }(not Srv.ProcessCfg.IsContent and FContentProtected)
      or not FContentProtected;
    if Assigned(FOnUpdateModified) then
      FOnUpdateModified(Self);
    //MForm.UpdateModified;
  end;
end;

function Tsm.EachReadFields(Srv: TPolyProcess): boolean;
begin
  Result := true;
  Srv.ReadFieldsFromInfo;
end;

// Читает поля всех процессов
procedure Tsm.ReadServicesFields;
begin
  ForEachProcess(EachReadFields);
end;

procedure Tsm.Prepare;
var cs: boolean;
begin
  cs := not sdm.cdSrvGridCols.Active;
  sdm.RefreshSrvGridCols;
  // CreateTotals;  // 31.12.2004
  ReadServicesFields;
  ForEachProcess(EachPrepare);
  if cs then sdm.CloseSrvGridCols;
end;

function Tsm.EachPrepareDBDataSet(Srv: TPolyProcess): boolean;
begin
//  Result := Srv.PrepareDBDataSet;
end;

function Tsm.PrepareDBDataSets: boolean;
begin
  Result := ForEachProcess(EachPrepareDBDataSet);
end;

{function Tsm.FindAndCalc(Srv: TPolyProcess): boolean;
begin
  Result := FField.DataSet = Srv.DataSet;  // 19.09.2004
  if Result then begin
    Srv.CalcOnFieldChange(FField);
    //FServicesModified := true;  // !!!!!!!!!!!! Это наверное неправильно
    TmpSrv := Srv;
  end;
  Result := not Result;      // 19.09.2004
end;}  // 28.05.2008

(*procedure Tsm.ServiceFieldChanged(Prc: TPolyProcess; AField: TField; DoCalcTotal: boolean);
var OldFField: TField;
begin
  if AField <> nil then
  begin
    OldFField := FField;
    try
      FField := AField;                 // временная переменная
      ForEachKindProcess(FindAndCalc);
      {if not DisableTotalCost then     // пересчитываем итого по процессу
        ForEachService(FindAndCalcTotalCost); // TmpSrv используется   6.11.2004 }
    finally
      FField := OldFField;
    end;
  end;
  //if DoCalcTotal then CalcGrandTotal;  // если DoCalcTotal, пересчитываем общий итог
end;*) // 28.05.2008

procedure Tsm.CalcGrnGrandTotal;
begin
  FGrandTotalGrn := RoundByMode(FGrandTotal, USDCourse, Tirazz);
  if Assigned(FOnGrnGrandTotalChanged) then
    FOnGrnGrandTotalChanged(Self);
end;

procedure Tsm.SetGrandTotal(Value: extended);
begin
  FGrandTotal := Value;

  if not FOrderContext.Active then Exit;
  
  if DisableGrandTotal then Exit;

  RoundByMode(FGrandTotal, -1, Tirazz); // округление суммы в у.е. поэтому -1

  if Assigned(FOnGrandTotalChanged) then
    FOnGrandTotalChanged(Self);
  CalcGrnGrandTotal;

  if (FPrevGrandTotal <> FGrandTotal) or FCostModified then
  begin
    FPrevGrandTotal := FGrandTotal;
    FClientTotal := FGrandTotal;
    // Запускаем скрипт, в котором рассчитывается ClientTotal
    ScriptManager.ExecOrderEvent(ParentOrder as TOrder, TScriptManager.OrderTotalChangedEvent);
  end
  else
  if ForProfitChanged then
  begin
    ForProfitChanged := false;
    // Запускаем скрипт, в котором рассчитывается ClientTotal
    ScriptManager.ExecOrderEvent(ParentOrder as TOrder, TScriptManager.OrderTotalChangedEvent);
  end;
  FCostModified := false;
end;

procedure Tsm.SetTotalOwnCostForProfit(Value: extended);
begin
  if FTotalOwnCostForProfit <> Value then
    ForProfitChanged := true;
  FTotalOwnCostForProfit := Value;
end;

procedure Tsm.SetTotalContractorCostForProfit(Value: extended);
begin
  if FTotalContractorCostForProfit <> Value then
    ForProfitChanged := true;
  FTotalContractorCostForProfit := Value;
end;

procedure Tsm.SetTotalMatCostForProfit(Value: extended);
begin
  if FTotalMatCostForProfit <> Value then
    ForProfitChanged := true;
  FTotalMatCostForProfit := Value;
end;

procedure Tsm.SetCommonContractorPercent(Percent: extended);
begin
  FContractorPercent := Percent;
  FContractorProfit := FContractorPercent * TotalContractorCostForProfit / 100.0;
  FOnUpdateContractorPercent(nil);
end;

procedure Tsm.SetContractorProfit(Profit: extended);
begin
  FContractorProfit := Profit;
  if TotalContractorCostForProfit > 0 then
    FContractorPercent := FContractorProfit / TotalContractorCostForProfit * 100.0
  else
    FContractorPercent := 0;
  FOnUpdateContractorPercent(nil);
end;

procedure Tsm.SetCommonOwnPercent(Percent: extended);
begin
  FOwnPercent := Percent;
  FOwnProfit := FOwnPercent * TotalOwnCostForProfit / 100.0;
  FOnUpdateOwnPercent(nil);
end;

procedure Tsm.SetOwnProfit(Profit: extended);
begin
  FOwnProfit := Profit;
  if TotalOwnCostForProfit > 0 then
    FOwnPercent := FOwnProfit / TotalOwnCostForProfit * 100.0
  else
    FOwnPercent := 0;
  FOnUpdateOwnPercent(nil);
end;

procedure Tsm.SetCommonMatPercent(Percent: extended);
begin
  FMatPercent := Percent;
  FMatProfit := FMatPercent * TotalMatCostForProfit / 100.0;
  FOnUpdateMatPercent(nil);
end;

procedure Tsm.SetMatProfit(Profit: extended);
begin
  FMatProfit := Profit;
  if TotalMatCostForProfit > 0 then
    FMatPercent := FMatProfit / TotalMatCostForProfit * 100.0
  else
    FMatPercent := 0;
  FOnUpdateMatPercent(nil);
end;

procedure Tsm.SetClientTotal(c: extended);
begin
  FClientTotal := c;
  FClientTotal := Round2(FClientTotal);
  if Assigned(FOnClientCostChanged) then
    FOnClientCostChanged(Self);
end;

procedure Tsm.SetClientTotalGrn(c: extended);
begin
  FClientTotalGrn := c;
  FClientTotalGrn := Round2(FClientTotalGrn);
  if Assigned(FOnClientCostChanged) then
    FOnClientCostChanged(Self);
end;

procedure Tsm.SetUSDCourse(Value: extended);
begin
  FUSDCourse := Value;
  if FOrderContext.Active then
  begin
    FPrevGrandTotal := FGrandTotal;
    FClientTotal := FGrandTotal;
    // Запускаем скрипт, в котором рассчитывается ClientTotal
    ScriptManager.ExecOrderEvent(ParentOrder as TOrder, TScriptManager.OrderTotalChangedEvent);
  end;
end;

function Tsm.EachParamChanged(Srv: TPolyProcess): boolean;
begin
  Result := true;
  Srv.OrderParamChanged(TmpParName, TmpNewParValue);
end;

procedure Tsm.OrderParamChanged(ParName: string; NewValue: variant);
begin
  TmpNewParValue := NewValue;
  TmpParName := ParName;
  ForEachKindProcess(EachParamChanged);
  // Если изменившийся параметр заказа - это тираж, то обновить переменную тиража.
  if CompareText(ParName, TOrder.NProductParamName) = 0 then
  begin
    Tirazz := NewValue;
    //CalcAllTotals;  26.11.2004
  end;
end;

// Пересчитываем все строки процесса.
{function Tsm.EachCalcCost(Srv: TPolyProcess): boolean;
begin
  Result := true;
  if Srv.DataSet <> nil then
    Srv.ExecAfterOpen;
end;}

// Пересчитываем все строки всех процессов. Используется при изменении формул.
{procedure Tsm.CalcAllCost;
begin
  ForEachKindProcess(EachCalcCost);
end;}

// Устанавливаем все цены во всех строках данного процесса по прайсу
function Tsm.EachUpdatePrices(Srv: TPolyProcess): boolean;
begin
  Result := true;
  Srv.UpdatePrices;
end;

// Устанавливаем все цены во всех процессах по прайсу
procedure Tsm.UpdateAllPrices;
begin
  ForEachKindProcess(EachUpdatePrices);
end;

function Tsm.EachCheckSrv(Srv: TPolyProcess): boolean;
begin
  Result := true;
  Srv.CheckService;
end;

procedure Tsm.CheckServices(Msgs: TCollection);
begin
  TmpMsgs := Msgs;
  ForEachKindProcess(EachCheckSrv);
end;

function Tsm.EachSetupSrv(Srv: TPolyProcess): boolean;
var
  BSrv: TPolyProcess;
  {I: integer;
  GridObj: TProcessGrid;
  BGrid: TProcessGrid;
  FGrids: TCollection;}
begin
  Result := true;
  if Srv.ProcessCfg.BaseSrvID > 0 then begin
    BSrv := ServiceByID(Srv.ProcessCfg.BaseSrvID, false);
    if BSrv <> nil then
      Srv.BaseSrv := BSrv;
  end;
  {if Srv is TGridPolyProcess then
  begin
    FGrids := (Srv as TGridPolyProcess).Grids;
    for i := 0 to FGrids.Count - 1 do
    begin
      GridObj := FGrids.Items[i] as TProcessGrid;
      if GridObj.GridCfg.BaseGridID > 0 then
      begin
        BGrid := GridByID(GridObj.GridCfg.BaseGridID, false);
        if BGrid <> nil then
          GridObj.BaseGrid := BGrid;
      end;
    end;
  end;}
end;

procedure Tsm.SetupServices;
begin
  ForEachProcess(EachSetupSrv);
end;

procedure Tsm.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(FCurKindProcList) then FreeAndNil(FCurKindProcList);
  //FreeTotals;  //31.12.2004
end;

function Tsm.EachScriptedItemParams(Srv: TPolyProcess): boolean;
begin
  Result := true;
  Srv.Post;
  Srv.SetAllItemParams;
end;

procedure Tsm.SetScriptedItemParams;
begin
  ForEachKindProcess(EachScriptedItemParams);
end;

procedure Tsm.OpenDataSet(DataSet: TDataSet);
begin
  Database.OpenDataSet(DataSet);
end;

procedure Tsm.SetPartField(BaseProcess: TPolyProcess; DepProcess: TPolyProcess);
var
  scd: TDataSet;
  Part: variant;
  CurItemID: variant;
begin
  Part := BaseProcess.DataSet[F_Part];
  if not VarIsNull(Part) then
  begin
    scd := DepProcess.DataSet;
    scd.DisableControls;
    CurItemID := DepProcess.DataSet[F_ItemID];
    try
      scd.First;
      while not scd.eof do
      begin
        if NvlInteger(scd[F_Part]) = NvlInteger(Part) then
          DepProcess.SetField(F_Part, Part);
        scd.Next;
      end;
    finally
      // невосстановление позиции приводит к глюкам при пересчете - в строку попадает стоимоть из другой строки
      scd.Locate(F_ItemID, CurItemID, []);
      scd.EnableControls;
    end;
  end;
end;

procedure Tsm.ProcessDependentPart(BaseProcess: TPolyProcess; DepSrvName: string);
var
  Dep: TPolyProcess;
  Part: variant;
begin
  if BaseProcess.DataSet.RecordCount = 1 then
  begin
    Dep := ServiceByTabName(DepSrvName, false);  // отключить автооткрытие
    if (Dep <> nil) and Dep.DataSet.Active then
    begin
      if Dep.DataSet.RecordCount = 1 then
      begin
        Part := BaseProcess.DataSet[F_Part];
        if (VarIsNull(Dep.DataSet[F_Part]) and VarIsNull(Part))
           or (Dep.DataSet[F_Part] = Part) then
        begin
          Dep.SetField(F_Part, Part);
        end;
      end
      else
        SetPartField(BaseProcess, Dep);
    end
  end
  else
  begin
    Dep := ServiceByTabName(DepSrvName, false);
    if (Dep <> nil) and Dep.DataSet.Active then
      SetPartField(BaseProcess, Dep);
  end;
end;

procedure Tsm.AfterOrderOpen;
begin
  ForEachProcess(EachAfterOrderOpen);
end;

function Tsm.EachAfterOrderOpen(Process: TPolyProcess): boolean;
var
  ParentPrc: TPolyProcess;
begin
  // заполняем список процессов, связанных с данным процессом декларативно
  if Process.ProcessCfg.LinkedProcessID <> 0 then
  begin
    ParentPrc := ServiceByID(Process.ProcessCfg.LinkedProcessID, false);
    if ParentPrc = nil then
      raise Exception.Create('Связанный процесс для ' + Process.Name + ' не найден');
    // добавляет себя в список связанных процессов родительского процесса
    ParentPrc.AddLinkedProcess(Process);
  end;

  Process.ExecAfterOrderOpen;
  Result := true;
end;

// Собираем в список процессы (имя-объект)
{function Tsm.EachCreateList(Process: TPolyProcess; Param: pointer): Boolean;
begin
  TStringList(Param).AddObject(Process.ServiceName, Process);
  Result := true;
end;}

procedure Tsm.SetTotalContractorCost(Value: extended);
begin
  OldTotalContractorCost := FTotalContractorCost;
  FTotalContractorCost := Value;
  if FTotalContractorCost <> OldTotalContractorCost then
    FCostModified := true;
end;

procedure Tsm.SetTotalMatCost(Value: extended);
begin
  OldTotalMatCost := FTotalMatCost;
  FTotalMatCost := Value;
  if FTotalMatCost <> OldTotalMatCost then
    FCostModified := true;
end;

procedure Tsm.SetTotalOwnCost(Value: extended);
begin
  OldTotalOwnCost := FTotalOwnCost;
  FTotalOwnCost := Value;
  if FTotalOwnCost <> OldTotalOwnCost then
    FCostModified := true;
end;

function Tsm.EachSetProtection(Process: TPolyProcess): boolean;
begin
  Process.CostProtected := FCostProtected;
  Process.ContentProtected := FContentProtected;
  Result := true;
end;

// Подчиненные записи добавленные этим методом, не будут удалены автоматически!
function Tsm.AppendChildProcess(ParentPrc: TPolyProcess; ChildProcessName: string): TPolyProcess;
var
  ChildPrc: TPolyProcess;
begin
  ChildPrc := ServiceByTabName(ChildProcessName, true);
  Result := ChildPrc;
  if ChildPrc <> nil then
    ParentPrc.AppendChildProcess(ChildPrc);
end;

// Возвращает подчиненный процесс
function Tsm.LocateChildProcess(ParentPrc: TPolyProcess; ChildProcessName: string): TPolyProcess;
var
  ChildPrc: TPolyProcess;
begin
  ChildPrc := ServiceByTabName(ChildProcessName, true);
  if ChildPrc <> nil then
  begin
    if ParentPrc.LocateChildProcess(ChildPrc) then
      Result := ChildPrc
    else
      Result := nil;
  end else
    Result := nil;
end;

procedure Tsm.RemoveChildProcess(ParentPrc: TPolyProcess; ChildProcessName: string);
var
  ChildPrc: TPolyProcess;
begin
  ChildPrc := ServiceByTabName(ChildProcessName, true);
  if ChildPrc <> nil then
    ParentPrc.RemoveChildProcess(ChildPrc);
end;

// Устанавливает уровень защиты заказа
procedure Tsm.SetProtection(_CostProtected, _ContentProtected: boolean);
begin
  FCostProtected := _CostProtected;
  FContentProtected := _ContentProtected;
  ForEachProcess(EachSetProtection);
end;

// APPSERVER !!!!!!!!!!!!
procedure Tsm.pvSrvBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
  var Applied: Boolean);
var
  Srv: TPolyProcess;
begin
  if UpdateKind = ukInsert then
  begin
    if not (DeltaDS.State in [dsEdit, dsInsert]) then DeltaDS.Edit;
    // Заменяем в новых записях ид. записи процесса на реальный, полученный после вставки.
    DeltaDS[F_ItemID] := FOnGetRealProcessItemID(DeltaDS[F_ItemID]);
  end;
  // Определяем ключевое поле по имени и сообщаем провайдеру, что оно является таковым.
  // Ранее мы ему в этом не признавались, чтобы он не ругался на Key violation
  // при добавлении двух и более записей.
  DeltaDS.FieldByName(F_ProcessKey).ProviderFlags := [pfInKey, pfInWhere];

  if UpdateKind = ukModify then
  begin
    // Проверяем защиту состава
    Srv := ServiceByDBDataSet(SourceDS);
    if Srv.ContentProtected and Srv.ProcessCfg.IsContent then
      Applied := true;
  end;
  //Srv := sm.ServiceByDBDataSet(SourceDS);
  {if Srv <> nil then begin
    cdSrvFieldInfo.Filter := SrvKeyField + ' = ' + IntToStr(Srv.SrvIDForFields);
    cdSrvFieldInfo.Filtered := true;}
    {for i := 0 to DeltaDS.Fields.Count - 1 do begin
      f := DeltaDS.Fields[i];
      if f.FieldName = SrvTabKeyField then
        f.ProviderFlags := [pfInKey, pfInWhere]}
      {else begin
        if cdSrvFieldInfo.Locate('FieldName', f.FieldName, [loCaseInsensitive]) then begin
          fs := cdSrvFieldInfo['FieldStatus'];
          if (fs = ftData) or (fs = ftIndependent) then
            f.ProviderFlags := [pfInUpdate]
          else
            f.ProviderFlags := [];
        end;
      end};
   // end;
  //end;
  { TODO -cCleanup: ResolveDataSet = false, поэтому надо это убрать }
  {if UpdateKind = ukDelete then begin
    aq := TADOCommand.Create(Self);
    try
      aq.Connection := aqServices.Connection;
      aq.CommandText := 'delete ' + SrvTablePrefix + Srv.TableName +
        ' where ' + SrvTabKeyField + ' = ' + IntToStr(DeltaDS[SrvTabKeyField]);
      aq.Execute;
      Applied := true;
    finally
      aq.Free;
    end;
  end;}
end;

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// ЭТУ И СЛЕДУЮЩУЮ ПРОЦЕДУРЫ НАДО РАЗДЕЛИТЬ НА ДВЕ ЧАСТИ - ОДНА СРАБОТАЕТ НА СЕРЕРЕ И
// СОЗДАСТ *ADOQUERY* И *DATASETPROVIDER*, А ДРУГАЯ - НА КЛИЕНТЕ СОЗДАСТ *CLIENTDATASET*.
function Tsm.CreateSrvData(Srv: TPolyProcess): boolean;
var
  aq: TADOQuery;
  pv: TDataSetProvider;
  cd: TClientDataSet;
  ds: TDataSource;
begin
  Result := false;
  aq := nil; cd := nil; pv := nil; ds := nil;
  try
    aq := TADOQuery.Create(Self);
    aq.Name := GetComponentName(Self, AQNamePrfx + Srv.Name);
    cd := TClientDataSet.Create(Self);
    cd.Name := GetComponentName(Self, CDNamePrfx + Srv.Name);
    pv := TDataSetProvider.Create(Self);
    pv.Name := GetComponentName(Self, PVNamePrfx + Srv.Name);
    pv.UpdateMode := upWhereKeyOnly;
    pv.Options := pv.Options + [poAllowMultiRecordUpdates];
    //pv.Constraints := false;  // не знаю, надо это или нет
    aq.Connection := sdm.aqServices.Connection;
    aq.LockType := ltOptimistic;
    aq.CursorType := ctStatic;
    aq.Prepared := false;
    pv.DataSet := aq;
    cd.ProviderName := pv.Name;
    pv.BeforeUpdateRecord := pvSrvBeforeUpdateRecord;
    ds := TDataSource.Create(sdm);
    ds.DataSet := cd;
  except on E: Exception do begin
    if cd <> nil then FreeAndNil(cd);
    if pv <> nil then FreeAndNil(pv);
    if aq <> nil then FreeAndNil(aq);
    if ds <> nil then FreeAndNil(ds);
    ExceptionHandler.Raise_(E, 'Не могу создать набор данных для процесса "' + Srv.Name + '"',
      'CreateSrvData');
    end;
  end;
  Srv.DataSource := ds;
  Srv.DBDataSet := aq;
  Srv.DBProvider := pv;
end;

procedure Tsm.CreateServiceComponents;
begin
  // СОЗДАЮТСЯ ОБЪЕКТЫ ПРОЦЕССОВ
  TConfigManager.Instance.ForEachProcess(EachCreateServiceComponent);
end;

function Tsm.EachCreateServiceComponent(SrvCfg: TPolyProcessCfg): boolean;
var
  srv: TPolyProcess;
begin
    {if sdm.cdServices['ServiceKind'] = cskSimple then
      Srv := TPolyProcess.Create(Self)
    else if sdm.cdServices['ServiceKind'] = cskTable then}
      Srv := TGridPolyProcess.Create(Self, SrvCfg);
    {else begin
      ExceptionHandler.Raise_('Тип процесса "' + sdm.cdServices['SrvDesc'] +
        '" (' + VarToStr(sdm.cdServices['ServiceKind']) +
        ') не поддерживается в данной версии');
      continue;
    end;}
    Srv.ParentOrder := ParentOrder;
    // Создание объектов таблиц для табличных процессах
    if Srv is TGridPolyProcess then
      (Srv as TGridPolyProcess).CreateGrids(GridTotalUpdate);  // 31.12.2004
    // Создаются наборы данных для процессов, которые являются их владельцами
    CreateSrvData(Srv);
    Result := true;
end;

procedure Tsm.GridTotalUpdate(ProcessGrid: TProcessGrid);
begin
  if Assigned(FOnGridTotalUpdate) then
    FOnGridTotalUpdate(ProcessGrid);
end;

end.
