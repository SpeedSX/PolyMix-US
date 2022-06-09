unit PmProcess;

{$I Calc.inc}

interface

uses SysUtils, Classes, ExtCtrls, Contnrs, menus,
  TypInfo, Controls, StdCtrls, Windows, JvDBControls, JvJVCLUtils, JvInterpreter, JvInterpreterFm,
  Forms, Graphics, ComCtrls, Dialogs, DB, DBClient, Provider, GridsEh, Variants, 
  JvTypes, JvAppStorage, TLoggerUnit,

  CalcUtils, DbGridEh, DicObj, PmChangeLock, PmDatabase, PmSettings, PmUtils,
  PmEntSettings, PmProcessCfg;

const
  ProcessPredefFieldsSQL = 'N int identity (1,1) not null, ItemID int not null';
  // без пробела!
  ProcessPredefFieldsStr = 'N,ItemID';

  // без пробела!
  ProcessPredefVirtualFieldsStr = 'ExecState,Enabled,Cost,PlanStartDate,PlanFinishDate,'
    + 'FactStartDate,FactFinishDate,EnabledCost,EnabledInt,Part,EquipCode,'
    + 'ContractorProcess,Contractor,ContractorPercent,OwnCost,ContractorCost,'
    + 'OwnPercent,MatCost,MatPercent,EnabledWorkCost,EnabledMatCost,LinkedItemID';

  // process item fields
  F_ProcessKey = 'N';
  F_ItemID = 'ItemID';
  SrvValueField = 'Field';
  F_EnabledCost = 'EnabledCost';
  F_EnabledInt = 'EnabledInt';
  F_Part = 'Part';
  F_PartName = 'PartName';
  F_ContractorName = 'ContractorName';
  //F_OverwriteEquipCode = 'OverwriteEquipCode';

  // Process scripts
  FScript_OnChange = 'OnChange';
  FScript_OnNewRecord = 'OnNewRecord';
  FScript_OnCalcFields = 'OnCalcFields';
  FScript_OnParamChange = 'OnParamChange';
  FScript_OnSetPrices = 'OnSetPrices';
  FScript_OnCheck = 'OnCheck';
  FScript_OnGetText = 'OnGetText';
  FScript_BeforeInsert = 'BeforeInsert';
  FScript_AfterOpen = 'AfterOpen';
  FScript_OnItemParams = 'OnItemParams';
  FScript_AfterScroll = 'AfterScroll'; 
  FScript_BeforeScroll = 'BeforeScroll';
  FScript_AfterOrderOpen = 'AfterOrderOpen';
  FScript_BeforeDelete = 'BeforeDelete';

  // Grid scripts
  FScript_OnDrawCell = 'OnDrawCell';
  FScript_OnGridEnter = 'OnGridEnter';
  FScript_OnContextPopup = 'OnContextPopup';
  FScript_OnSelectPopup = 'OnSelectPopup';
  FScript_OnCalcTotal = 'OnCalcTotal';

  // Plan scripts
  PlanScr_OnEstimateDuration = 'OnEstimateDuration';

  PlanScr_OnNotPlannedCalcFields = 'OnNotPlannedCalcFields';
  PlanScr_OnGetNotPlannedSQL = 'OnGetNotPlannedSQL';
  PlanScr_OnCreateNotPlanned = 'OnCreateNotPlanned';
  PlanScr_OnCreateNotPlannedColumns = 'OnCreateNotPlannedColumns';

  PlanScr_OnDayPlanCalcFields = 'OnDayPlanCalcFields';
  PlanScr_OnCreateDayPlan = 'OnCreateDayPlan';
  PlanScr_OnGetDayPlanSQL = 'OnGetDayPlanSQL';
  PlanScr_OnCreateDayPlanColumns = 'OnCreateDayPlanColumns';

  PlanScr_OnProductionCalcFields = 'OnProductionCalcFields';
  PlanScr_OnGetProductionSQL = 'OnGetProductionSQL';
  PlanScr_OnCreateProduction = 'OnCreateProduction';
  PlanScr_OnCreateProductionColumns = 'OnCreateProductionColumns';

  AggPrefix = 'Agg_';

  SrvNamePrefix = 'cs';

  // Эти значения присваиваются Tag'у соотв. поля для удобства работы
  // в таблице описания полей сохраняется в поле FieldStatus
  ftData = 0;         // нормальное поле - нужен обработчик изменения
  ftVirtual = 1;
  ftIndependent = 4;  // нормальное поле - НЕ нужен обработчик изменения
  ftCalculated = 5;   // вычисляемое поле - в таге самого поля не обязательно должно быть,
                      // но используется в таблице свойств полей.

type
  TPolyProcess = class;

  TOnSettings = function (Sender: TPolyProcess; IniF: TJvCustomAppStorage): boolean of object;
  TNotifyServiceEvent = procedure (Sender: TPolyProcess) of object;
  TProcessGrid = class;
  TNotifyProcessGridEvent = procedure (Sender: TProcessGrid) of object;

  TFieldChangeEvent = procedure (Prc: TPolyProcess; AField: TField; DoCalcTotal: boolean) of object;
  TCalcEvent = function (Srv: TPolyProcess): extended of object;

  //  TForEachGridFunc = function(dg: TDBGrid): boolean;

  TPolyProcess = class(TComponent)
  private
    FProcessCfg: TPolyProcessCfg;
    FCostAggField: TAggregateField;
    FDataSrc: TDataSource;
    FDBDataSet: TDataSet;
    FDBProvider: TDataSetProvider;
    FIniKey: string;
    FNoModifyTracking: boolean;
    FOnCalcCost: TCalcEvent;
    FOnCalcFieldChange: TFieldNotifyEvent;
//    FCurDicElem: TDicElement;   см. FDicElements
    //FOnFieldChange: TFieldChangeEvent; // 28.05.2008
    FOnGetDimensionValue: TGetDimValueEvent;
    FOnProcessModify: TNotifyServiceEvent;
    FOnSaveSettings, FOnLoadSettings: TOnSettings;
    FPermitInsert, FPermitUpdate, FPermitDelete, FPermitPlan, FPermitFact: boolean;
    FProcessModified: boolean;
    FSettingsLoaded: boolean; // Означает, что загружались локальные настройки:
     // например, ширина колонок таблицы и их можно сохранять при выходе.
     // Если процедура загрузки не была вызвана (например, сбой произошел где-то раньше),
     // то сохранения не произойдет.
//    FDicElements: TDicElemList;  все места, где используется, закомментированы.
//                                 понадобится, если будет вызов меню без скриптов.
    FSQLPrepared{, FPageOwner}: boolean;
    FSrvID: integer;
    FLinkedProcesses: TList; // Список связанных процессов
    FScriptCost: extended;
    FContentProtected, FCostProtected: boolean;
    FBaseSrv: TPolyProcess;
    FScriptOldFieldValue: variant;
    procedure DataSetAfterScroll(DataSet: TDataSet);
    procedure DataSetBeforeInsert(DataSet: TDataSet);
    procedure DataSetBeforeScroll(DataSet: TDataSet);
    procedure DataSetCalcFields(DataSet: TDataSet);
    procedure DataSetNewRecord(DataSet: TDataSet);
    procedure ExecNewRecCode;
    function GetContentProtected: boolean;
    function GetDataSet: TClientDataSet;
    function GetFilterEn: boolean;
    procedure SetDataSource(Val: TDataSource);
    procedure SetFilterEn(Val: boolean);
    function GetSrvName: string;
    function GetTabName: string;
  protected
    FParentOrder: TObject;
    procedure AddProcessItem;
    procedure CalcFinalCost;
    procedure ContractorPercentChanged(Sender: TField);
    procedure CostFieldChanged(Sender: TField);
    procedure DataSetAfterDelete(DataSet: TDataSet);

    procedure DataSetAfterCancel(DataSet: TDataSet);
    procedure DataSetBeforeCancel(DataSet: TDataSet);

    procedure DataSetAfterInsert(DataSet: TDataSet);
    procedure DataSetAfterPost(DataSet: TDataSet);
    procedure DataSetBeforeDelete(DataSet: TDataSet);
    procedure ExecCode(ScriptFieldName: string);
    procedure ExecItemParams(DataSet: TDataSet);
    procedure ExecScriptForEachRecord(Proc: TDataSetNotifyEvent; EnabledOnly: boolean);
    procedure FieldChanged(Sender: TField);
    function GetCodeAfterOpen: TStringList;
    function GetCodeAfterOrderOpen: TStringList;
    function GetCodeAfterScroll: TStringList;
    function GetCodeBeforeInsert: TStringList;
    function GetCodeBeforeDelete: TStringList;
    function GetCodeBeforeScroll: TStringList;
    function GetCodeOnChange: TStringList;
    //function GetCodeOnCalcTotal: TStringList;
    function GetCodeOnCheck: TStringList;
    //function GetCodeOnBriefDesc: TStringList;  // 31.12.2004
    function GetCodeOnGetText: TStringList;
    function GetCodeOnNewRec: TStringList;
    function GetCodeOnParamChange: TStringList;
    function GetCodeOnSetPrices: TStringList;
    function GetEnabledCount: integer;
    function GetTotalCost: extended;
    procedure ItemParamFieldChanged(Sender: TField);
    procedure PartFieldChanged(Sender: TField);
    procedure PrepareFields;
    procedure PrgGetValue(Sender: TObject; Identifer: String;
      var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
    procedure PrgSetValue(Sender: TObject; Identifer: String;
      const Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
    procedure DoSetValue(Identifer: String;
      const Value: Variant; var Done: Boolean);
    procedure SetContentProtected(Value: boolean); virtual;
    procedure SetProcessModified(c: boolean);
    // Вычисляет вычисляемые поля
    procedure CalcFields;
    procedure DefaultNewRecord;
    procedure PrepareDataSets;
    procedure WriteFieldsToDataSet(dqFields: TDataSet);

    property CodeAfterOpen: TStringList read GetCodeAfterOpen;
    property CodeAfterOrderOpen: TStringList read GetCodeAfterOrderOpen;
    property CodeAfterScroll: TStringList read GetCodeAfterScroll;
    property CodeBeforeInsert: TStringList read GetCodeBeforeInsert;
    property CodeBeforeDelete: TStringList read GetCodeBeforeDelete;
    property CodeBeforeScroll: TStringList read GetCodeBeforeScroll;
    property CodeOnChange: TStringList read GetCodeOnChange;
    //property CodeOnCalcTotal: TStringList read GetCodeOnCalcTotal;
    property CodeOnCheck: TStringList read GetCodeOnCheck;
    //property CodeOnBriefDesc: TStringList read GetCodeOnBriefDesc; // 31.12.2004
    property CodeOnGetText: TStringList read GetCodeOnGetText;
    property CodeOnNewRec: TStringList read GetCodeOnNewRec;
    property CodeOnParamChange: TStringList read GetCodeOnParamChange;
    property CodeOnSetPrices: TStringList read GetCodeOnSetPrices;
  public
//    SrvFields: TStringList;
    OnCalcFieldsRunning: boolean;  // флажок, запрещающий считывание
    OnChangeRunning: boolean;  // флажок, запрещающий изменение
                                  // вычисляемых полей во время их расчета.
    OnNewRecRunning: boolean;
    OnParamChangeRunning: boolean;
    OnSetPricesRunning: boolean;  // Работает скрипт установки цен,
                                  // который меняет поля данных
    //SettingItemParam, SettingProcessParam: boolean;
    constructor Create(AOwner: TComponent; _ProcessCfg: TPolyProcessCfg);
    destructor Destroy; override;
    function Open(NewData, Calc: boolean; OrderID: integer): boolean;
    function AppendRecord: boolean;
    function ApplyUpdates: boolean;
    procedure CancelUpdates;
    procedure CheckService;
    procedure DisableTotals;
    procedure EnableTotals;
    function Clear: boolean;
    procedure Close;
    function DeleteRecord: boolean;
    function CanDeleteRecord: boolean;
    procedure Post;
    procedure Prepare; virtual;
    procedure FieldGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure FreeDataSets;
    procedure ReadFieldsFromInfo;

    procedure ExecAfterOpen;
    procedure ExecAfterOrderOpen;
    procedure UpdatePrices;
    procedure SetPrices;
    // Вызывает пересчет при изменении заданного поля
    function CalcOnFieldChange(Sender: TField): boolean;
    // добавляет сообщение при проверке процесса
    procedure AddCheckMsg(_Msg: string; _MsgType: TMsgDlgType; RecNo: integer);
    procedure OrderParamChanged(ParName: string; NewParValue: variant);

    //procedure CalcTotalCost; virtual;
    function GetTotal(FieldName: string): variant;
    // return key of corresponding order item or 0 if no item exists (new unposted record)
    function ItemKey: integer;
    procedure LoadSettings(IniF: TJvCustomAppStorage); virtual;
    procedure SaveSettings(IniF: TjvCustomAppStorage); virtual;
    procedure SetAllItemParams;
    procedure SetField(FieldName: string; FieldValue: variant);
    procedure SetItemParam(const ParamName: string; ParamValue: variant);
    procedure SetPermissions(_PermitInsert, _PermitUpdate, _PermitDelete,
      _PermitPlan, _PermitFact: boolean); virtual;
    procedure TotalsChanged; virtual;
    procedure AddLinkedProcess(LinkedProcess: TPolyProcess);
    procedure AppendChildProcess(ChildPrc: TPolyProcess);
    function LocateChildProcess(ChildPrc: TPolyProcess): Boolean;
    // Удаляет дочерний процесс. Он уже может быть удален пользователем к этому моменту.
    procedure RemoveChildProcess(ChildPrc: TPolyProcess);
    // Проверяет, можно ли удалить дочерние процессы.
    function CanRemoveChildProcesses: boolean;

    property DataSet: TClientDataSet read GetDataSet;
    property DBDataSet: TDataSet read FDBDataSet write FDBDataSet;
    property DBProvider: TDataSetProvider read FDBProvider write FDBProvider;
    property EnabledCount: integer read GetEnabledCount;
    property FilterEnabled: boolean read GetFilterEn write SetFilterEn;
    property PermitDelete: boolean read FPermitDelete;
    property PermitFact: boolean read FPermitFact;
    property PermitInsert: boolean read FPermitInsert;
    property PermitPlan: boolean read FPermitPlan;
    property PermitUpdate: boolean read FPermitUpdate;
    property ProcessModified: boolean read FProcessModified write SetProcessModified;
    property SQLPrepared: boolean read FSQLPrepared write FSQLPrepared;
    property SrvID: integer read FSrvID;
    property BaseSrv: TPolyProcess read FBaseSrv write FBaseSrv;
    //CalcTotalCostRunning: boolean; // см. CalcTotalCost
    property TotalCost: extended read GetTotalCost;
    // Ссылка на родительский объект заказа. Для сценариев.
    property ParentOrder: TObject read FParentOrder write FParentOrder;

    property ContentProtected: boolean read GetContentProtected write SetContentProtected;
    property CostProtected: boolean read FCostProtected write FCostProtected;
    property DataSource: TDataSource read FDataSrc write SetDataSource;

    property OnCalcCost: TCalcEvent read FOnCalcCost write FOnCalcCost;
    property OnCalcFieldChange: TFieldNotifyEvent read FOnCalcFieldChange write FOnCalcFieldChange;
    //property OnFieldChange: TFieldChangeEvent read FOnFieldChange write FOnFieldChange;  // 28.05.2008
    property OnGetDimensionValue: TGetDimValueEvent read FOnGetDimensionValue write FOnGetDimensionValue;
    property OnLoadSettings: TOnSettings read FOnLoadSettings write FOnLoadSettings;
    property OnProcessModify: TNotifyServiceEvent read FOnProcessModify write FOnProcessModify;
    property OnSaveSettings: TOnSettings read FOnSaveSettings write FOnSaveSettings;

    property ServiceName: string read GetSrvName;
    //property ShowInReport: boolean read GetShowInReport;
    property TableName: string read GetTabName;
    property IniKey: string read FIniKey write FIniKey;
    property ProcessCfg: TPolyProcessCfg read FProcessCfg;

    // предыдущее значение последнего измененного поля
    property ScriptOldFieldValue: variant read FScriptOldFieldValue write FScriptOldFieldValue;
  end;

  TProcessGrid = class(TCollectionItem)
  private
    FGrid: TGridClass;
    FGridID: integer;
    FOnGridTotalUpdate: TNotifyProcessGridEvent;
    FPage: TPageClass;
    FSrv: TPolyProcess;
    //FSrvID: integer;
    FTotalPanel, FTotalWorkPanel, FTotalMatPanel: TPanel;
    FGridCfg: TProcessGridCfg;
    procedure ColumnEditButtonDown(Sender: TObject;
      TopButton: Boolean; var AutoRepeat, Handled: Boolean);
    procedure ExecCode(ScriptFieldName: string);
    function GetCodeOnContextPopup: TStringList;
    function GetCodeOnDrawCell: TStringList;
    function GetCodeOnGridEnter: TStringList;
    function GetCodeOnSelectPopup: TStringList;
    function GetDataSource: TDataSource;
    //procedure ExecBriefDesc(DataSet: TDataSet);  // 31.12.2004
    function GetShowPanel: boolean;
    function GetTotalCost: extended;
    function GetTotalMatCost: extended;
    function GetTotalWorkCost: extended;
    procedure GridCellClick(Column: TColumnEh);
    procedure GridContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure GridEnter(Sender: TObject);
    procedure GridExit(Sender: TObject);
    procedure GridGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure PanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PrepareGrid;
    procedure PrepareTotalPanel;
    procedure SetDBGrid(Val: TGridClass);
    //procedure GridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SetEnterAsTab(Grid: TGridClass{; Entering: boolean});
    //procedure SetShowPanel(Val: boolean);
    procedure SetTotalMatPanel(Val: TPanel);
    procedure SetTotalPanel(Val: TPanel);
    procedure SetTotalWorkPanel(Val: TPanel);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure AppendRecord;
    procedure Clear;
    procedure ClearDBGrid;
    procedure DeleteRecord;
    function GetItemCount: integer;
    function GetTotalValue(_FieldName: string): extended;
    procedure PopupSelected(Sender: TObject);
    procedure RestoreGridCols;
    // Сохраняет ширину столбцов таблицы в конфигурационном объекте
    procedure SaveGridColsWidth;
    // Восстанавливает ширину столбцов таблицы из конфигурационного объекта
    procedure LoadGridColsWidth;
    procedure TotalsChanged;
    procedure UpdateTotalControls;
    property CodeOnContextPopup: TStringList read GetCodeOnContextPopup;
    property CodeOnDrawCell: TStringList read GetCodeOnDrawCell;
    property CodeOnGridEnter: TStringList read GetCodeOnGridEnter;
    property CodeOnSelectPopup: TStringList read GetCodeOnSelectPopup;
    property DataSource: TDataSource read GetDataSource;
    property DBGrid: TGridClass read FGrid write SetDBGrid;
    property GridID: integer read FGridID write FGridID;
    //property BaseGrid: TProcessGrid read FBaseGrid write FBaseGrid;
    property OnGridTotalUpdate: TNotifyProcessGridEvent read FOnGridTotalUpdate write FOnGridTotalUpdate;
    property Page: TPageClass read FPage write FPage;
    property Srv: TPolyProcess read FSrv write FSrv;
    property TotalCost: extended read GetTotalCost;
    property TotalMatCost: extended read GetTotalMatCost;
    property TotalMatPanel: TPanel read FTotalMatPanel write SetTotalMatPanel;
    property TotalPanel: TPanel read FTotalPanel write SetTotalPanel;
    property TotalWorkCost: extended read GetTotalWorkCost;
    property TotalWorkPanel: TPanel read FTotalWorkPanel write SetTotalWorkPanel;
    property GridCfg: TProcessGridCfg read FGridCfg write FGridCfg;
    property ShowControlPanel: boolean read GetShowPanel;
  end;

  TGridPolyProcess = class(TPolyProcess)
  private
    FGrids: TCollection;
    procedure PrepareGrids;
    procedure PrepareTotals;
  protected
    procedure SetContentProtected(Value: boolean); override;
  public
    constructor Create(AOwner: TComponent; _ProcessCfg: TPolyProcessCfg);
    procedure CreateGrids(TotalUpdateEvent: TNotifyProcessGridEvent);
    //destructor Destroy; override;
    procedure Prepare; override;
    procedure TotalsChanged; override;
    //procedure CalcTotalCost; override;
    procedure UpdateGridTotals;
    property Grids: TCollection read FGrids;
  end;

  //function FieldIsExcluded(f: TField): boolean; // True - Поле не участвует в обновлении БД.  // 31.12.2004

  procedure GridOptions(dgCommon: TGridClass);

var
  TmpNewParValue: variant;
  TmpParName: string;
  TmpMsgs: TCollection;

  ProcessChangeLock, ItemChangeLock: TChangeLocker;

function ResolveMaterial(MatName: string; UpdateKind: TUpdateKind): boolean;

implementation

uses ADOUtils, RDBUtils, RDialogs, DBCtrls, JvJCLUtils, ADODB,
  ServData, ChkOrd, DataHlp, RepData, JvPickDate, RAI2_CalcSrv, CalcSettings, PmOrder,
  PmAccessManager, JvInterpreter_CustomQuery, ExHandler, ToolCtrlsEh,
  PmOrderProcessItems, PmMaterials, DateUtils, PmScriptManager,
  PmConfigManager
{$IFNDEF NoTriada}
{$IFDEF Repbuild}
  , TechCard
{$ENDIF}
{$ENDIF}
  ;

type
  // Поля, клонируемые из TOrderProcessItems в каждом процессе
  TSharedFields = class
    const
      F_Enabled = TOrderProcessItems.F_Enabled;
      F_ContractorCost = TOrderProcessItems.F_ContractorCost;
      F_ContractorProcess = TOrderProcessItems.F_ContractorProcess;
      F_ContractorPercent = TOrderProcessItems.F_ContractorPercent;
      F_MatCost = TOrderProcessItems.F_MatCost;
      F_EnabledMatCost = TOrderProcessItems.F_EnabledMatCost;
      F_Cost = TOrderProcessItems.F_Cost;
      F_EnabledWorkCost = TOrderProcessItems.F_EnabledWorkCost;
      F_OwnCost = TOrderProcessItems.F_OwnCost;
      F_EquipCode = TOrderProcessItems.F_EquipCode;
      F_OwnPercent = TOrderProcessItems.F_OwnPercent;
      F_MatPercent = TOrderProcessItems.F_MatPercent;
      F_LinkedItemID = TOrderProcessItems.F_LinkedItemID;
  end;

const
  FACT_MATERIAL_ERROR = 'Для данного процесса или связанных с ним существует заявка на материалы,'#13
        + 'которая содержит фактические отметки, поэтому процесс нельзя удалить.';

function ResolveMaterial(MatName: string; UpdateKind: TUpdateKind): boolean;
begin
  {if UpdateKind = ukDelete then
    Result := RusMessageDlg('Информация о материалах содержит фактические отметки.'#13
      + 'При данном изменении они будут удалены. Продолжить?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes
  else if UpdateKind = ukModify then
    Result := RusMessageDlg('Информация о материале ' + QuotedStr(MatName) + ' содержит фактические отметки.'#13
      + 'Его параметры будут изменены. Продолжить?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes}
    Result := true;
end;

procedure ServiceExecCode(ScriptedObj: TObject; ScriptFieldName: string);
var
  Msg: string;
  FPrg: TJvInterpreterFm;
  OldScriptService: TPolyProcess;
  OldScriptDataSet: TDataSet;
  OldScriptChangedField: TField;
  OldScriptGrid: TProcessGrid;
  OldScriptOrder: TOrder;
  OldScriptOldFieldValue: variant;
  Script: TStringList;
  CfgObj: TObject;
begin
  // сохраняем контекст сценария для вложенных вызовов
  OldScriptDataSet := ScriptDataSet;
  OldScriptService := ScriptService;
  OldScriptGrid := ScriptGrid;
  OldScriptChangedField := ScriptChangedField;
  OldScriptOrder := ScriptOrder;
  if ScriptService <> nil then
    OldScriptOldFieldValue := ScriptService.ScriptOldFieldValue;
  FPrg := nil;
  try
    if ScriptedObj is TPolyProcess then
    begin
      Script := (ScriptedObj as TPolyProcess).ProcessCfg.GetScript(ScriptFieldName);
      ScriptService := ScriptedObj as TPolyProcess;
      ScriptOrder := (ScriptedObj as TPolyProcess).ParentOrder as TOrder;
    end
    else
    if ScriptedObj is TProcessGrid then
    begin
      Script := (ScriptedObj as TProcessGrid).GridCfg.GetScript(ScriptFieldName);
      ScriptService := (ScriptedObj as TProcessGrid).Srv;
      ScriptGrid := ScriptedObj as TProcessGrid;
      ScriptOrder := (ScriptedObj as TProcessGrid).Srv.ParentOrder as TOrder;
    end
    else
      ExceptionHandler.Raise_('Неизвестный класс в ServiceExecCode: ' + ScriptedObj.ClassName);
    if not Assigned(Script) or IsEmptyScript(Script) then Exit;
    Msg := '';
    FPrg := TJvInterpreterFm.Create(nil);
    try
      if ScriptedObj is TPolyProcess then
        CfgObj := (ScriptedObj as TPolyProcess).ProcessCfg
      else if ScriptedObj is TProcessGrid then
        CfgObj := (ScriptedObj as TProcessGrid).GridCfg;
      // Установка глобальных переменных для скрипта
      ScriptDataSet := ScriptService.DataSet;
      //ScriptDicElements := DicElemList;
      FPrg.OnGetValue := ScriptService.PrgGetValue;
      FPrg.OnSetValue := ScriptService.PrgSetValue;
      FPrg.OnCreateDfmStream := rdm.CreateDfmStream;
      FPrg.OnFreeDfmStream := rdm.FreeDfmStream;
      FPrg.OnGetUnitSource := rdm.GetUnitSource;
      FPrg.Source := Script.Text;
      // Запуск...
      FPrg.Run;
    except
      on E : EJvInterpreterError  do
      begin
        // Игнорируем ошибку, выскакивающую при пустом скрипте
        if (E.ErrCode = ieExpected) and
           (CompareText(E.ErrName1, LoadStr(irExpression)) = 0) then Exit;
        Msg := IntToStr(E.ErrCode) + ': ' + StringReplace(E.Message, #10, ' ', [rfReplaceAll]);
      	ExceptionHandler.Log_(Msg);
        ScriptManager.ShowScriptError(CfgObj, ScriptFieldName, E.ErrPos, Msg, TSettingsManager.Instance.Storage);
      end;
      on E : EJvScriptError do begin
        Msg := StringReplace(E.Message, #10, ' ', [rfReplaceAll]);
      	ExceptionHandler.Log_(Msg);
        ScriptManager.ShowScriptError(CfgObj, ScriptFieldName, E.ErrPos, Msg, TSettingsManager.Instance.Storage);
      end;
      on E : Exception do
      begin
        Msg := IntToStr(FPrg.LastError.ErrCode) + ': ' +
          StringReplace(FPrg.LastError.Message, #10, ' ', [rfReplaceAll]);
      	ExceptionHandler.Log_(Msg);
        ScriptManager.ShowScriptError(CfgObj, ScriptFieldName, FPrg.LastError.ErrPos, Msg, TSettingsManager.Instance.Storage);
      end
      else begin
        Msg := 'Ошибка при выполнении сценария';                                                    
      	ExceptionHandler.Log_(Msg);
        RusMessageDlg(Msg, mtError, [mbOk], 0);
      end;
    end;
  finally
    if Assigned(FPrg) then FreeAndNil(FPrg);
    ScriptService := OldScriptService;
    ScriptGrid := OldScriptGrid;
    ScriptDataSet := OldScriptDataSet;
    ScriptChangedField := OldScriptChangedField;
    ScriptOrder := OldScriptOrder;
    if ScriptService <> nil then
      ScriptService.ScriptOldFieldValue := OldScriptOldFieldValue;
    DoneCustomSQL;
  end;
end;

{$REGION 'TPolyProcess'}

constructor TPolyProcess.Create(AOwner: TComponent; _ProcessCfg: TPolyProcessCfg);
begin
  inherited Create(AOwner);
  Name := SrvNamePrefix + _ProcessCfg.TableName;
  FIniKey := _ProcessCfg.TableName;
  FProcessCfg := _ProcessCfg;
  FSrvID := FProcessCfg.SrvID;
  FLinkedProcesses := TList.Create;
end;

destructor TPolyProcess.Destroy;
begin
  FreeAndNil(FLinkedProcesses);
  inherited Destroy;
end;

procedure TPolyProcess.AddCheckMsg(_Msg: string; _MsgType: TMsgDlgType; RecNo: integer);
begin
  with TmpMsgs.Add as TCheckMsg do begin
    SrvName := ServiceName;
    Msg := _Msg;
    MsgType := _MsgType;
    RecNo := ScriptRecNo;
  end;
end;

procedure TPolyProcess.AddProcessItem;
var
  //Prc: TPolyProcess;
  FProcessItems: TOrderProcessItems;
begin
  // НЕКРАСИВО !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  FProcessItems := (ParentOrder as TOrder).OrderItems;
  FProcessItems.Append;
  FProcessItems.DataSet[TOrderProcessItems.F_ProcessID] := SrvID;
  //Prc := (ParentOrder as TOrder).Processes.ServiceByID(SrvID, true);
  FProcessItems.DataSet[TOrderProcessItems.F_ItemDesc] := ServiceName;//Prc.ServiceName;
  FProcessItems.DataSet['PermitPlan'] := FPermitPlan;
  FProcessItems.DataSet['PermitFact'] := FPermitFact;
  FProcessItems.DataSet['PermitInsert'] := FPermitInsert;
  FProcessItems.DataSet['PermitUpdate'] := FPermitUpdate;
  FProcessItems.DataSet['PermitDelete'] := FPermitDelete;
  FProcessItems.DataSet['UseInTotal'] := ProcessCfg.UseInTotal;
  FProcessItems.DataSet[TOrderProcessItems.F_IsItemInProfit] := ProcessCfg.UseInTotal;
  FProcessItems.DataSet['UseInProfitMode'] := ProcessCfg.UseInProfitMode;
  FProcessItems.HideItem := ProcessCfg.HideItem;
  FProcessItems.TrackingEnabled := ProcessCfg.TrackingEnabled;
  FProcessItems.PlanningEnabled := ProcessCfg.PlanningEnabled;
  FProcessItems.IsPartName := false;
  FProcessItems.SequenceOrder := ProcessCfg.SequenceOrder;//Prc.SequenceOrder;
  FProcessItems.ContractorProcess := ProcessCfg.DefaultContractorProcess;
  FProcessItems.DataSet.Post;
  DataSet[F_ItemID] := FProcessItems.KeyValue;
end;

function TPolyProcess.AppendRecord: boolean;
var
  dq: TClientDataSet;
  //OldAggs: boolean;
begin
  Result := true;
  dq := DataSet;
  if (dq <> nil) and dq.Active then
  begin
    //OldAggs := dq.AggregatesActive; не помогло
    dq.Append;
    if dq.State in [dsInsert, dsEdit] then dq.Post;
    //dq.AggregatesActive := OldAggs;
  end;
end;

function TPolyProcess.ApplyUpdates: boolean;
var dq: TClientDataSet;
begin
  Result := true;
  dq := FDataSrc.DataSet as TClientDataSet;
  if dq.State in [dsEdit, dsInsert] then dq.Post;
  if (dq = nil) or (dq.ChangeCount = 0) then Exit;
  Result := false;
  //try
    Result := dq.ApplyUpdates(0) = 0;
  {except
    on E: Exception do ProcessError(E);
  end;}
end;

procedure TPolyProcess.CalcFields;
var
  f: TField;
begin
  if OnCalcFieldsRunning or not DataSet.Active then Exit;
  // Сразу определяем название части
  f := DataSet.FindField(F_PartName);
  if f <> nil then
  begin
    if not VarIsNull(DataSet[F_Part]) then
    begin
      if TConfigManager.Instance.StandardDics.deParts.LocateCode(DataSet[F_Part]) then
        f.Value := TConfigManager.Instance.StandardDics.deParts.CurrentName
      else
        f.Value := '';
    end
    else
      f.Value := '';
  end;
  if DataSet.State = dsCalcFields then
  begin
    if NvlBoolean(DataSet[TSharedFields.F_Enabled]) then
    begin
      DataSet[TSharedFields.F_EnabledMatCost] := DataSet[TSharedFields.F_MatCost];
      DataSet[TSharedFields.F_EnabledWorkCost] := DataSet[TSharedFields.F_ContractorCost] + DataSet[TSharedFields.F_OwnCost];
    end else begin
      DataSet[TSharedFields.F_EnabledMatCost] := 0;
      DataSet[TSharedFields.F_EnabledWorkCost] := 0;
    end;
  end;
  // Проверяем не было ли проблем при предыдущих запусках
  if not ProcessCfg.CalcFieldsScriptInvalid then
  begin
    OnCalcFieldsRunning := true;
    try
      try
        ExecCode(FScript_OnCalcFields);
      except
        ProcessCfg.CalcFieldsScriptInvalid := true;
        raise;
      end;
    finally
      OnCalcFieldsRunning := false;
    end;
  end;
end;

procedure TPolyProcess.CalcFinalCost;
var
  ds: TDataSet;
begin
  ds := DataSet;
  if not (ds.State in [dsInsert, dsEdit]) then ds.Edit;
  if NvlBoolean(ds[TSharedFields.F_ContractorProcess]) then
  begin
    ds[TSharedFields.F_Cost] := NvlFloat(ds[TSharedFields.F_ContractorCost]) + NvlFloat(ds[TSharedFields.F_MatCost]);
    ds[TSharedFields.F_OwnCost] := 0;
  end
  else
  begin
    ds[TSharedFields.F_Cost] := NvlFloat(ds[TSharedFields.F_OwnCost]) + NvlFloat(ds[TSharedFields.F_MatCost]);
    ds[TSharedFields.F_ContractorCost] := 0;
  end;
end;

// Пересчет виртуальных и независимых полей
function TPolyProcess.CalcOnFieldChange(Sender: TField): boolean;
var
  OldState: TDataSetState;
  ds: TDataSet;
  OldScriptChangedField: TField;
  OldScriptOldFieldValue: variant;
begin
  Result := false;
  if OnSetPricesRunning or OnChangeRunning then Exit;     // повторно не входить
  if not Assigned(Sender) then Exit;
  ds := Sender.DataSet;
  ds.DisableControls;
  try
    OldState := ds.State;
    if Assigned(FOnCalcFieldChange) then
      FOnCalcFieldChange(Sender)
    else
    begin
      // Если есть скрипт, то запускаем его
      if not Assigned(CodeOnChange) or (CodeOnChange.Count = 0) then Exit;
      // Выносим стоимость в отдельную переменную для ускорения.
      // В случае процесса субподрядчика это себестоимость.
      if NvlBoolean(ds[TSharedFields.F_ContractorProcess]) then
        FScriptCost := NvlFloat(ds[TSharedFields.F_ContractorCost])
      else
        FScriptCost := NvlFloat(ds[TSharedFields.F_OwnCost]);
      OnChangeRunning := true;
      try
        OldScriptChangedField := ScriptChangedField;
        OldScriptOldFieldValue := ScriptOldFieldValue;
        ScriptChangedField := Sender;
        ExecCode(FScript_OnChange);
        ScriptChangedField := OldScriptChangedField;
        ScriptOldFieldValue := OldScriptOldFieldValue;
        {$IFDEF Manager}
        if UseInProfitMode = upmFullCost then
          ScriptCost := ScriptCost * (MngProfitPercent / 100.0 + 1);
        {$ENDIF}
        // Только если нет защиты или это процесс не из состава заказа
        if (PermitUpdate and not FCostProtected and not FContentProtected) or not ProcessCfg.IsContent then
        begin
          // Устанавливаем рассчитанную стоимость
          if not (ds.State in [dsInsert, dsEdit, dsCalcFields]) then ds.Edit;
          if NvlBoolean(ds[TSharedFields.F_ContractorProcess]) then
            // Стоимость работ у подрядчика
            ds[TSharedFields.F_ContractorCost] := FScriptCost
          else
            // Свой процесс
            ds[TSharedFields.F_OwnCost] := FScriptCost;

          CalcFinalCost;
        end;
        if (ds.State in [dsInsert, dsEdit])
            and not (FParentOrder as TOrder).Processes.DisableTotalCost
            and not OnNewRecRunning then
          ds.Post;
        // если здесь не учесть NewRecRunning, то при вводе
        // в пустую таблицу первый символ пропадет.
      finally
        OnChangeRunning := false;
      end;
      // установка рассчитанной стоимости раньше была здесь,
      // но получалось неправильное суммарное значение.
    end;
    // Возращает набор данных в состояние просмотра
    if (OldState = dsBrowse) and (ds.State in [dsInsert, dsEdit]) then ds.Post
    else if (OldState in [dsInsert, dsEdit]) and not (ds.State in [dsInsert, dsEdit]) then
      ds.Edit;
    Result := true;
  finally
    ds.EnableControls;
  end;
end;

procedure TPolyProcess.CancelUpdates;
var dq: TClientDataSet;
begin
    dq := FDataSrc.DataSet as TClientDataSet;
    if (dq = nil) or not dq.Active then Exit;
    //dq.CheckBrowseMode;
    dq.CancelUpdates;
    dq.Active := false;
end;

procedure TPolyProcess.CheckService;
var
  bm: TBookmark;
begin
  if (DataSet <> nil) and DataSet.Active then
  begin
    bm := DataSet.GetBookmark;
    DataSet.DisableControls;
    try
      DataSet.First;
      ScriptRecNo := 1;
      while not DataSet.eof do
      begin
        if NvlBoolean(DataSet[TSharedFields.F_Enabled]) then
          ExecCode(FScript_OnCheck);
        DataSet.Next;
        Inc(ScriptRecNo);
      end;
    finally
      DataSet.GotoBookmark(bm);
      DataSet.FreeBookmark(bm);
      DataSet.EnableControls;
    end;
  end;
end;

function TPolyProcess.Clear: boolean;
var dq: TDataSet;
begin
  Result := true;
  dq := DataSet;
  if (dq <> nil) and dq.Active and not dq.IsEmpty then begin
    dq.DisableControls;
    try
      DataSet.EmptyDataSet;// VeryEmptyTable(dq);
      //CalcTotalCost;  // 6.11.2004   v2.00
      //if Assigned(FAfterDeleteRecord) then FAfterDeleteRecord(Self);
    finally
      DataSet.EnableControls;
    end;
  end;
end;

procedure TPolyProcess.Close;
var
  dq: TClientDataSet;
begin
  (FParentOrder as TOrder).Processes.DisableGrandTotal := true;
  try
    dq := FDataSrc.DataSet as TClientDataSet;
    if dq = nil then Exit;
    if dq.Active then
    begin
      dq.AggregatesActive := false;
      dq.Close;
    end;
  finally
    (FParentOrder as TOrder).Processes.DisableGrandTotal := false;
  end;
end;

procedure TPolyProcess.ContractorPercentChanged(Sender: TField);
begin
  //if SettingItemParam then Exit;
  // Обновляем соотв. поле в общей таблице
  {if DataSet.State <> dsInsert then }
  //if not OnChangeRunning then begin
  //  CalcFinalCost;
  //end;
  SetItemParam(Sender.FieldName, Sender.Value);
end;

procedure TPolyProcess.CostFieldChanged(Sender: TField);
begin
  // Обновляются поля, участвующие в расчете агрегатов.
  if (DataSet.FindField(F_EnabledCost) <> nil) then begin
    if (DataSet.FindField(TSharedFields.F_Enabled) <> nil) then begin
      if NvlBoolean(DataSet[TSharedFields.F_Enabled]) then begin
        DataSet[F_EnabledInt] := 1;   // поле для счетчика кол-ва записей
        if VarIsNull(DataSet[TSharedFields.F_Cost]) then
          DataSet[F_EnabledCost] := 0
        else
          if DataSet[F_EnabledCost] <> DataSet[TSharedFields.F_Cost] then
            DataSet[F_EnabledCost] := DataSet[TSharedFields.F_Cost];
      end else begin
        DataSet[F_EnabledCost] := 0;
        DataSet[F_EnabledInt] := 0;
      end;
    end;
  end;
  // Обновляем соотв. поле в общей таблице
  {if DataSet.State <> dsInsert then }
  // убрал это условие, т.к. не обновлялась общая стоимость при добавлении новой записи
  SetItemParam(Sender.FieldName, Sender.Value);
end;

procedure TPolyProcess.DataSetAfterDelete(DataSet: TDataSet);
begin
  (ParentOrder as TOrder).OrderItems.RefreshPartRecords;
  DataSetAfterPost(DataSet);
end;

procedure TPolyProcess.DataSetAfterInsert(DataSet: TDataSet);
var
  i: integer;
begin
  if DataSet.State = dsInsert then
  begin
    AddProcessItem;
    // Здесь нельзя делать Post, т.к. пропадет первый введенный символ,
    // если таблица была пустая
    //DataSet.Post;
    if not EntSettings.ExecNewRecordAfterInsert then
    begin
      SetItemParam(TSharedFields.F_Enabled, NvlBoolean(DataSet[TSharedFields.F_Enabled]));
      SetItemParam(TSharedFields.F_Cost, NvlFloat(DataSet[TSharedFields.F_Cost]));
      SetItemParam(TSharedFields.F_EquipCode, NvlInteger(DataSet[TSharedFields.F_EquipCode]));
      SetItemParam(TSharedFields.F_ContractorProcess, NvlFloat(DataSet[TSharedFields.F_ContractorProcess]));
      SetItemParam(TSharedFields.F_ContractorPercent, NvlFloat(DataSet[TSharedFields.F_ContractorPercent]));
      SetItemParam(TSharedFields.F_OwnCost, NvlFloat(DataSet[TSharedFields.F_OwnCost]));
      SetItemParam(TSharedFields.F_ContractorCost, NvlFloat(DataSet[TSharedFields.F_ContractorCost]));
      SetItemParam(TSharedFields.F_OwnPercent, NvlFloat(DataSet[TSharedFields.F_OwnPercent]));
      //SetItemParam(F_MatCost, NvlFloat(DataSet[F_MatCost]));
      SetItemParam(TSharedFields.F_MatPercent, NvlFloat(DataSet[TSharedFields.F_MatPercent]));
      SetItemParam(TSharedFields.F_LinkedItemID, NvlFloat(DataSet[TSharedFields.F_LinkedItemID]));
      //SetItemParam(SrvPartField, NvlInteger(DataSet[SrvPartField]));  // 19.07.2005
    end;
    OnNewRecRunning := true;
    try
      if EntSettings.ExecNewRecordAfterInsert then
        ExecNewRecCode;
      PartFieldChanged(DataSet.FieldByName(F_Part));   // 19.07.2005
    finally
      OnNewRecRunning := false;
    end;
    // Добавляем запись во все дочерние процессы
    for i := 0 to FLinkedProcesses.Count - 1 do
    begin
      AppendChildProcess(TPolyProcess(FLinkedProcesses.Items[i]));
    end;
  end;
end;

procedure TPolyProcess.DataSetAfterPost(DataSet: TDataSet);
begin
  TotalsChanged;
end;

procedure TPolyProcess.DataSetAfterScroll(DataSet: TDataSet);
begin
  if Assigned(CodeAfterScroll) and (CodeAfterScroll.Count > 0) then
    ExecCode(FScript_AfterScroll);
end;

procedure TPolyProcess.DataSetAfterCancel(DataSet: TDataSet);
begin
  DataSetAfterDelete(DataSet);
end;

procedure TPolyProcess.DataSetBeforeCancel(DataSet: TDataSet);
{var
  I: Integer;}
begin
  if DataSet.State = dsInsert then
    DataSetBeforeDelete(DataSet);
{  // Удаляем записи из связанных процессов
  for I := 0 to FLinkedProcesses.Count - 1 do    // Iterate
  begin
    RemoveChildProcess(TPolyProcess(FLinkedProcesses[i]));
  end;    // for

  if dm.cdProcessItems.Locate(F_ItemID, DataSet[F_ItemID], []) then
    dm.cdProcessItems.Delete
  else
    raise EDatabaseError.Create('Строка для удаления не найдена в cdProcessItems. Процесс ' + ServiceName);}
end;

procedure TPolyProcess.DataSetBeforeDelete(DataSet: TDataSet);
var
  I: Integer;
  CurID: integer;
  FProcessItems: TOrderProcessItems;
  v: boolean;
begin
  CurID := DataSet[F_ItemID];
  FProcessItems := (ParentOrder as TOrder).OrderItems;
  // Если это убрать, то строка в ProcessItems не удаляется. Читай ниже
  if FProcessItems.KeyValue <> CurID then
    v := FProcessItems.Locate(CurID)
  else
    v := true;
  if v then
  begin
    // Проверяем, можно ли удалить записи из связанных процессов
    // Их нельзя удалять, если есть фактическая информация по материалам, например.
    if not CanRemoveChildProcesses then
      ExceptionHandler.Raise_(FACT_MATERIAL_ERROR);

    if Assigned(CodeBeforeDelete) and (CodeBeforeDelete.Count > 0) then
      ExecCode(FScript_BeforeDelete);

    // Здесь обязательна эта проверка. Иначе если добавить строку нажатием кнопки вниз
    // на таблице, а потом нажать удалить, то строка не удаляется, хотя она уже удалена из
    // ProcessItems. Наверное это потому что состояние меняется на dsBrowse, хотя оно было
    // dsInsert при входе в этот обработчик.
    // см. также еще одну такую проверку ниже
    // Вообщето скриптовый обработчик BeforeDelete может поменять это состояние
    // и тогда тоже могут быть проблемы.
    if DataSet[F_ItemID] <> CurID then
      if not DataSet.Locate(F_ItemID, CurID, []) then
        raise Exception.Create('Строка для удаления не найдена. Процесс ' + ServiceName);

    // Удаляем записи из связанных процессов
    for I := 0 to FLinkedProcesses.Count - 1 do
    begin
      RemoveChildProcess(TPolyProcess(FLinkedProcesses[i]));
    end;
    //dm.DumpProcessItems;
    if FProcessItems.Locate(CurID) then
      FProcessItems.Delete
    else
      raise Exception.Create('Строка для удаления не найдена в cdProcessItems. Процесс ' + ServiceName);
    //dm.DumpProcessItems;
    if DataSet[F_ItemID] <> CurID then
      if not DataSet.Locate(F_ItemID, CurID, []) then
        raise Exception.Create('Строка для удаления не найдена. Процесс ' + ServiceName);
  end;
end;

procedure TPolyProcess.DataSetBeforeInsert(DataSet: TDataSet);
begin
  if Assigned(CodeBeforeInsert) and (CodeBeforeInsert.Count > 0) then
    ExecCode(FScript_BeforeInsert);
end;

procedure TPolyProcess.DataSetBeforeScroll(DataSet: TDataSet);
begin
  if Assigned(CodeBeforeScroll) and (CodeBeforeScroll.Count > 0) then
    ExecCode(FScript_BeforeScroll);
end;

procedure TPolyProcess.DataSetCalcFields(DataSet: TDataSet);
begin
  if OnCalcFieldsRunning then Exit;
  CalcFields;
end;

procedure TPolyProcess.DataSetNewRecord(DataSet: TDataSet);
//var
  //SaveDisableTotalCost: boolean;
  //k: string;
begin
  TLogger.GetInstance.Debug('Добавление записи в процесс ' + TableName);
  if not OnNewRecRunning then
  try
    OnNewRecRunning := true;
    //SaveDisableTotalCost := DisableTotalCost;
    //DisableTotalCost := true;  // 04.02.2004
    // try    04.02.2004
      // Временное значение ключа. Оно нужно, чтобы найти потом
      // эту строку (например, при модификации состояния).
      // Эти строки пока убраны, т.к. все равно не приводят к нужному результату:
      { TODO: ПОЧЕМУ-ТО ВСЕГДА НОВЫМ СТРОКАМ ПРИСВАИВАЮТСЯ ЗНАЧЕНИЯ КЛЮЧА НАЧИНАЯ С 1! }
      // (наверное, они могут перекрываться и с существующими). БРЕД КАКОЙ-ТО!
      {DataSet.Tag := DataSet.Tag + 1;   // 23.08.2004
      DataSet[SrvTabKeyField] := DataSet.Tag;}
      //AddProcessItem;  04.02.2004
      {dm.cdProcessItems.First;
      while not dm.cdProcessItems.eof do begin
        k := '1';
        k := VarToStr(dm.cdProcessItems[SrvEnabledCostField]);
        dm.cdProcessItems.Next;
      end;}
    {finally
      DisableTotalCost := SaveDisableTotalCost;   // 04.02.2004
    end;}
    if not EntSettings.ExecNewRecordAfterInsert then
      ExecNewRecCode;
  finally
    OnNewRecRunning := false;
  end;
end;

procedure TPolyProcess.DefaultNewRecord;
begin
end;

function TPolyProcess.CanDeleteRecord: boolean;
var
  Mat: TMaterials;
begin
  Mat := (FParentOrder as TOrder).OrderItems.Materials;
  Result := not Mat.HasFactInfo(DataSet[F_ItemID]) and CanRemoveChildProcesses;
end;

function TPolyProcess.DeleteRecord: boolean;
var
  dq: TDataSet;
begin
  Result := true;
  dq := DataSet;
  if (dq <> nil) and dq.Active and not dq.IsEmpty then
  begin
    // TODO: Вообще-то это лучше перенести в BeforeDelete, но надо протестить

    if CanDeleteRecord then
      dq.Delete
    else
    begin
      RusMessageDlg(FACT_MATERIAL_ERROR, mtError, [mbOk], 0);
      if NvlBoolean(dq[TSharedFields.F_Enabled]) then
      begin
        if not (dq.State in [dsInsert, dsEdit]) then
          dq.Edit;
        dq[TSharedFields.F_Enabled] := false;
        dq.CheckBrowseMode;
        Result := false;
      end;
    end;

//    if dq.State = dsInsert then
//    begin
//      DataSetBeforeDelete(dq);   // потому что этот обработчик не сработает автоматически
//      dq.Cancel;  // можно и просто Delete - это ничего не меняет
//      DataSetAfterDelete(dq);  // потому что этот обработчик не сработает автоматически
//    end else
//      dq.Delete;
    //CalcTotalCost;  6.11.2004
    //if Assigned(FAfterDeleteRecord) then FAfterDeleteRecord(Self);
  end
  else
    Result := false;
end;

procedure TPolyProcess.DisableTotals;
begin
  (DataSet as TClientDataSet).AggregatesActive := false;
end;

procedure TPolyProcess.EnableTotals;
begin
  (DataSet as TClientDataSet).AggregatesActive := true;
  TotalsChanged;
end;

procedure TPolyProcess.ExecAfterOpen;
var
  MaxKey: integer;
  KeyVal: variant;
  OldDisableFieldChange: boolean;
begin
  if not Assigned(DataSet) or not DataSet.Active then Exit;
  //DataSet.AggregatesActive := false;
  DisableTotals;
  if not DataSet.IsEmpty then
  begin
    DataSet.DisableControls;
    try
      DataSet.First;
      ScriptRecNo := 1;
      MaxKey := 0;
      while not DataSet.eof do
      begin
        if not PermitUpdate or FCostProtected or FContentProtected then
        begin
          if (ParentOrder as TOrder).OrderItems.Locate(DataSet[F_ItemID]) then
          begin
            OldDisableFieldChange := (FParentOrder as TOrder).Processes.DisableFieldChange;
            (FParentOrder as TOrder).Processes.DisableFieldChange := true;
            try
            // Устанавливаем стоимости, т.к. они не будут рассчитаны
            // Стоимость работ у подрядчика
            ProcessChangeLock.Lock(TSharedFields.F_ContractorCost);
            try
              if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
              DataSet[TSharedFields.F_ContractorCost] := (ParentOrder as TOrder).OrderItems.DataSet[TSharedFields.F_ContractorCost];
            finally
              ProcessChangeLock.Unlock;
            end;
            // Свой процесс
            ProcessChangeLock.Lock(TSharedFields.F_OwnCost);
            try
              if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
              DataSet[TSharedFields.F_OwnCost] := (ParentOrder as TOrder).OrderItems.DataSet[TSharedFields.F_OwnCost];
            finally
              ProcessChangeLock.Unlock;
            end;
            // Материалы
            ProcessChangeLock.Lock(TSharedFields.F_MatCost);
            try
              if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
              DataSet[TSharedFields.F_MatCost] := (ParentOrder as TOrder).OrderItems.DataSet[TSharedFields.F_MatCost];
            finally
              ProcessChangeLock.Unlock;
            end;
            // Общая стоимость
            ProcessChangeLock.Lock(TSharedFields.F_ContractorCost);
            ProcessChangeLock.Lock(TSharedFields.F_OwnCost);
            try
              CalcFinalCost;
            finally
              ProcessChangeLock.Unlock(2);
            end;
            finally
              (FParentOrder as TOrder).Processes.DisableFieldChange := OldDisableFieldChange;
            end;
          end
          else
            raise Exception.Create('ExecAfterOpen: Не найдена запись с ключом ' + VarToStr(DataSet[F_ItemID]));
        end;
        KeyVal := DataSet[F_ProcessKey];
        if ProcessCfg.EnableAfterOpen then
          ExecCode(FScript_AfterOpen);
        if KeyVal <> DataSet[F_ProcessKey] then   // восстанавливаем текущую строку, она могла поменяться, хотя это ОЧЕНЬ ПЛОХО, но зато не зависнет
          DataSet.Locate(F_ProcessKey, KeyVal, []);
        //KeyVal := DataSet[F_ProcessKey];
        if not VarIsNull(KeyVal) and (KeyVal > MaxKey) then
          MaxKey := KeyVal;
        DataSet.Next;
        Inc(ScriptRecNo);
      end;
      DataSet.First;
      DataSet.Tag := MaxKey;
      // В TAG'е DataSet'a хранится макс. значение ключа!
      // Это нужно при добавлении новой записи, т.к. записи упорядочены по ключу.
    finally
      DataSet.EnableControls;
    end;
    //FreshQuery(DataSet);
  end;
  EnableTotals;
  //if not DataSet.IsEmpty then DataSet.CheckBrowseMode;
end;

procedure TPolyProcess.ExecAfterOrderOpen;
begin
  if ProcessCfg.EnableAfterOrderOpen then
    ExecCode(FScript_AfterOrderOpen);
end;

procedure TPolyProcess.ExecCode(ScriptFieldName: string);
begin
  ServiceExecCode(Self, ScriptFieldName);
end;

procedure TPolyProcess.ExecItemParams(DataSet: TDataSet);
begin
  ExecCode(FScript_OnItemParams);
end;

procedure TPolyProcess.ExecScriptForEachRecord(Proc: TDataSetNotifyEvent; EnabledOnly: boolean);
var
  ds: TDataSet;
  OldState: TDataSetState;
  f: TField;
begin
  ds := DataSet;
  if not Assigned(ds) or not ds.Active then Exit;
  OldState := ds.State;
  ds.CheckBrowseMode;
  if ds.IsEmpty then Exit;
  ds.DisableControls;
  try
    DS.First;
    while not ds.eof do
    begin
      if EnabledOnly then
      begin
        f := ds.FindField(TSharedFields.F_Enabled);
        if f <> nil then begin
          if not f.IsNull then
          begin
            if f.Value then Proc(ds);
          end;
        end else
          Proc(ds);
      end
      else
        Proc(ds);
      ds.Next;
    end;
  finally
    if OldState = dsBrowse then ds.CheckBrowseMode
    else if OldState in [dsInsert, dsEdit] then ds.Edit;
    ds.EnableControls;
  end;
end;

// Обработчик модификации поля
procedure TPolyProcess.FieldChanged(Sender: TField);
var
  StartTime: TDateTime;
begin
  if Options.VerboseLog then
  begin
    TLogger.getInstance.Debug('Старт: изменение поля ' + Sender.FieldName + ' в процессе ' + TableName);
    StartTime := Now;
  end;

  if not FNoModifyTracking and (Sender.FieldKind = fkData) then ProcessModified := true;
  if {Assigned(OnFieldChange) and }not (FParentOrder as TOrder).Processes.DisableFieldChange then
    CalcOnFieldChange(Sender);
    //FOnFieldChange(Self, Sender, not DisableGrandTotal);
  if Options.VerboseLog then
    TLogger.getInstance.Debug('Финиш: изменение поля ' + Sender.FieldName + ' в процессе ' + TableName
       + ' ' + IntToStr(MillisecondsBetween(Now, StartTime)));
end;

procedure TPolyProcess.FieldGetText(Sender: TField; var Text: String; DisplayText: Boolean);
var
  OldScriptCurField: string;
begin
  if Assigned(Sender) and Assigned(CodeOnGetText) and (CodeOnGetText.Count > 0) then begin
    OldScriptCurField := ScriptCurField;
    try
      ScriptCurField := Sender.FieldName;
      ScriptDisplayText := DisplayText;
      ScriptFieldText := Text;
      ExecCode(FScript_OnGetText);
      Text := ScriptFieldText;
    finally
      ScriptCurField := OldScriptCurField;
    end;
  end;
end;

{// True - Поле не участвует в обновлении БД.  // 31.12.2004 - и не использовалось ?
function FieldIsExcluded(f: TField): boolean;
begin
  Result := (f.FieldKind = fkCalculated) or (CompareText(f.FieldName, SrvTabKeyField) = 0)
    or (f.Tag = ftVirtual)
    // Сохранять новую дату исполнения сервиса и состояние только
    // при включенном редактировании состояния
    or ((FullOrdStateMode <> fsEdit) and
      ((CompareText(f.FieldName, SrvFinishField) = 0) or
       (CompareText(f.FieldName, SrvStartField) = 0) or
       (CompareText(f.FieldName, SrvOrdStateField) = 0)));
end;

function TCalcService.GetExFields: string;
var
  i: integer;
  f: TField;
begin
  Result := '';
  if (DataSet <> nil) then
    for i := 0 to Pred(DataSet.Fields.Count) do begin
      f := DataSet.Fields[i];
      if FieldIsExcluded(f) then begin
        if Result <> '' then
          Result := Result + ';' + f.FieldName
        else
          Result := f.FieldName;
      end;
    end;
end; }

procedure TPolyProcess.FreeDataSets;
begin
  if (FDBDataSet <> nil) then
    FreeAndNil(FDbDataSet);
  if FDBProvider <> nil then FreeAndNil(FDbProvider);
  if FDataSrc <> nil then begin
    if FDataSrc.DataSet <> nil then FDataSrc.DataSet.Free;
    FreeAndNil(FDataSrc);
  end;
end;

function TPolyProcess.GetCodeAfterOpen: TStringList;
begin
  Result := FProcessCfg.GetScript(FScript_AfterOpen);
end;

function TPolyProcess.GetCodeAfterOrderOpen: TStringList;
begin
  Result := FProcessCfg.GetScript(FScript_AfterOrderOpen);
end;

function TPolyProcess.GetCodeAfterScroll: TStringList;
begin
  Result := FProcessCfg.GetScript(FScript_AfterScroll);
end;

function TPolyProcess.GetCodeBeforeInsert: TStringList;
begin
  Result := FProcessCfg.GetScript(FScript_BeforeInsert);
end;

function TPolyProcess.GetCodeBeforeDelete: TStringList;
begin
  Result := FProcessCfg.GetScript(FScript_BeforeDelete);
end;

function TPolyProcess.GetCodeBeforeScroll: TStringList;
begin
  Result := FProcessCfg.GetScript(FScript_BeforeScroll);
end;

function TPolyProcess.GetCodeOnChange: TStringList;
begin
  Result := FProcessCfg.GetScript(FScript_OnChange);
end;

function TPolyProcess.GetCodeOnCheck: TStringList;
begin
  Result := FProcessCfg.GetScript(FScript_OnCheck);
end;

function TPolyProcess.GetCodeOnGetText: TStringList;
begin
  Result := FProcessCfg.GetScript(FScript_OnGetText);
end;

function TPolyProcess.GetCodeOnNewRec: TStringList;
begin
  Result := FProcessCfg.GetScript(FScript_OnNewRecord);
end;

function TPolyProcess.GetCodeOnParamChange: TStringList;
begin
  Result := FProcessCfg.GetScript(FScript_OnParamChange);
end;

function TPolyProcess.GetCodeOnSetPrices: TStringList;
begin
  Result := FProcessCfg.GetScript(FScript_OnSetPrices);
end;

function TPolyProcess.GetContentProtected: boolean;
begin
  Result := FContentProtected and ProcessCfg.IsContent;
end;

function TPolyProcess.GetDataSet: TClientDataSet;
begin
  if FDataSrc <> nil then
    Result := FDataSrc.DataSet as TClientDataSet
  else Result := nil;
end;

function TPolyProcess.GetEnabledCount: integer;
begin
  Result := NvlInteger(GetTotal(F_EnabledInt));
end;

function TPolyProcess.GetFilterEn: boolean;
begin
  if FDataSrc <> nil then
    Result := FDataSrc.DataSet.Filtered
  else Result := false;
end;

function TPolyProcess.GetTotal(FieldName: string): variant;
{var
  Agg: TAggregate;}  // 31.12.2004
var
  Agg: TField;
begin
{  Agg := (DataSet as TClientDataSet).Aggregates.Find(FTabName + '_' + FieldName);} // 31.12.2004
  Agg := DataSet.FindField(AggPrefix + FieldName);
  if Agg <> nil then
    Result := Agg.Value
  else
    Result := 0.0;
end;

function TPolyProcess.GetTotalCost: extended;
begin
  Result := NvlFloat(FCostAggField.Value);
end;

function TPolyProcess.ItemKey: integer;
begin
  Result := NvlInteger(DataSet[F_ItemID]);
end;

procedure TPolyProcess.ItemParamFieldChanged(Sender: TField);
begin
  //if SettingItemParam then Exit;
  // Обновляем соотв. поле в общей таблице
  {if DataSet.State <> dsInsert then }
  SetItemParam(Sender.FieldName, Sender.Value);
  FieldChanged(Sender);
end;

procedure TPolyProcess.LoadSettings(IniF: TJvCustomAppStorage);
begin
  if Assigned(FOnLoadSettings) then FOnLoadSettings(Self, IniF);
  FSettingsLoaded := true;
end;

function TPolyProcess.Open(NewData, Calc: boolean; OrderID: integer): boolean;
begin
  // проверяем, надо ли вообще открывать набор данных
  if Calc and FProcessCfg.OnlyWorkOrder then
  begin
    Result := true;
    Exit;
  end;
  // готовим запрос на открытие
  Result := sdm.PrepareOpenServiceData(Self, NewData, Calc, OrderID);
  if Result then
  //try
    {if NewData then begin DataSet.ProviderName := ''; DataSet.CreateDataSet end else }
    Database.OpenDataSet(DataSet);
    EnableTotals;
    // Создается индекс по ключевому полю, чтобы зафиксировать порядок,
    // иначе он может нарушаться после фильтрации.
    // Какая-то фигня получается, поэтому закомментировано
    // 05.03.2005 - попробовал раскомментировать, новые строки в процессах добавляются в начало. 
    {DataSet.AddIndex('i_' + SrvTabKeyField, SrvTabKeyField, []);  // 23.08.2004
    DataSet.IndexDefs.Update;
    DataSet.IndexFieldNames := SrvTabKeyField;}
    Result := true;
  //except on E: Exception do ProcessError(E); end;
  FProcessModified := false;
end;

procedure TPolyProcess.OrderParamChanged(ParName: string; NewParValue: variant);
var
  dbx: TDataSet;
begin
  // Эта штука вызывается и при создании нового расчета, поэтому проверим DataSet.Active
  if (CodeOnParamChange <> nil) and (CodeOnParamChange.Count > 0) and (DataSet.Active) then
  begin
    OnParamChangeRunning := true;
    try
      dbx := DataSet;
      if Assigned(dbx) and dbx.Active and not dbx.IsEmpty then begin
        dbx.DisableControls;
        dbx.First;
        ScriptRecNo := 1;
        while not dbx.EOF do begin
          ExecCode(FScript_OnParamChange);
          dbx.next;
          Inc(ScriptRecNo);
        end;
      end;
    finally
      dbx.EnableControls;
      OnParamChangeRunning := false;
    end;
  end;
end;

procedure TPolyProcess.PartFieldChanged(Sender: TField);
begin
  //if SettingItemParam then Exit;
  // Обновляем соотв. поле в общей таблице
  {if DataSet.State <> dsInsert then }
  if not VarIsNull(DataSet[F_ItemID]) then
  begin // 19.07.2005
    SetItemParam(Sender.FieldName, Sender.Value);
    FieldChanged(Sender);
    if not ProcessChangeLock.Find(Sender.FieldName){SettingProcessParam} then
      (ParentOrder as TOrder).OrderItems.RefreshPartRecords;
  end;
end;

procedure TPolyProcess.Post;
var dq: TClientDataSet;
begin
  dq := FDataSrc.DataSet as TClientDataSet;
  if dq = nil then Exit;
  try if dq.State in [dsEdit, dsInsert] then dq.Post; except end;
end;

procedure TPolyProcess.Prepare;
begin
  PrepareDataSets;
end;

procedure TPolyProcess.PrepareDataSets;
begin
  if Assigned(FDataSrc) then
  begin
    // Заранее устанавливаем фильтр для отфильтровывания отключенных строк в отчетах
    if ProcessCfg.ShowInReport and (FDataSrc.DataSet.FindField(TSharedFields.F_Enabled) <> nil) then
      FDataSrc.DataSet.Filter := TSharedFields.F_Enabled;
    if ProcessCfg.AssignCalcFields then
      FDataSrc.DataSet.OnCalcFields := DataSetCalcFields;
    if ProcessCfg.AssignNewRecord then
      FDataSrc.DataSet.OnNewRecord := DataSetNewRecord;
    if ProcessCfg.AssignBeforeInsert then
      FDataSrc.DataSet.BeforeInsert := DataSetBeforeInsert;
    if ProcessCfg.EnableBeforeScroll then
      FDataSrc.DataSet.BeforeScroll := DataSetBeforeScroll;
    if ProcessCfg.EnableAfterScroll then
      FDataSrc.DataSet.AfterScroll := DataSetAfterScroll;
    FDataSrc.DataSet.AfterInsert := DataSetAfterInsert;
    FDataSrc.DataSet.AfterPost := DataSetAfterPost;
    FDataSrc.DataSet.AfterDelete := DataSetAfterDelete;
    FDataSrc.DataSet.BeforeDelete := DataSetBeforeDelete;
    FDataSrc.DataSet.AfterCancel := DataSetAfterCancel;
    FDataSrc.DataSet.BeforeCancel := DataSetBeforeCancel;
  end;
  PrepareFields;
end;

procedure TPolyProcess.PrepareFields;
var
  dqf: TFields;
  i: integer;
  f: TField;
begin
    dqf := DataSet.Fields;
      // Обработчики изменения полей
      for i := 0 to Pred(dqf.Count) do
      begin
        f := dqf.Fields[i];
        // На ключевое поле не назначаем обработчик изменения - 24.08.2004
        // Правда, пока от этого ничего не меняется
        if Assigned(f) then
        begin
          if not Assigned(f.OnChange) and (f.Tag = ftData) and (f.FieldKind = fkData)
             and (f.FieldName <> F_ProcessKey) and (f.FieldName <> F_ItemID) then
            f.OnChange := FieldChanged
          else if CompareText(f.FieldName, TSharedFields.F_Cost) = 0 then
            f.OnChange := CostFieldChanged
          else if CompareText(f.FieldName, TSharedFields.F_Enabled) = 0 then
            f.OnChange := ItemParamFieldChanged
          else if CompareText(f.FieldName, TSharedFields.F_EquipCode) = 0 then
            f.OnChange := ItemParamFieldChanged
          else if CompareText(f.FieldName, F_Part) = 0 then
            f.OnChange := PartFieldChanged
          else if CompareText(f.FieldName, TSharedFields.F_ContractorProcess) = 0 then
            f.OnChange := ItemParamFieldChanged
          else if CompareText(f.FieldName, TSharedFields.F_ContractorPercent) = 0 then
            f.OnChange := ContractorPercentChanged
          else if CompareText(f.FieldName, TSharedFields.F_OwnCost) = 0 then
            f.OnChange := ItemParamFieldChanged
          else if CompareText(f.FieldName, TSharedFields.F_ContractorCost) = 0 then
            f.OnChange := ItemParamFieldChanged
          else if CompareText(f.FieldName, TSharedFields.F_OwnPercent) = 0 then
            f.OnChange := ContractorPercentChanged
          else if CompareText(f.FieldName, TSharedFields.F_MatPercent) = 0 then
            f.OnChange := ItemParamFieldChanged
          else if CompareText(f.FieldName, TSharedFields.F_LinkedItemID) = 0 then
            f.OnChange := ItemParamFieldChanged;
        end;
      end;
end;

procedure TPolyProcess.PrgGetValue(Sender: TObject; Identifer: String;
  var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
var
  f: TField;
begin
  if CompareStr(Identifer, TSharedFields.F_Cost) = 0 then
  begin
    Value := FScriptCost;
    Done := true;
  end
  else
  begin
    //f := ScriptDataSet.FindField(Identifer);  19/12/2006
    f := DataSet.FindField(Identifer);
    // Запрещаем считывание вычисляемых полей
    if f <> nil then
    begin
      if not OnCalcFieldsRunning or (f.FieldKind <> fkCalculated) then
      begin
        if (f is TStringField) and f.IsNull then Value := ''
        else Value := f.Value;
      end;
      Done := true;
    end;
  end;
end;

procedure TPolyProcess.PrgSetValue(Sender: TObject; Identifer: String;
  const Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
begin
  DoSetValue(Identifer, Value, Done);
end;

procedure TPolyProcess.DoSetValue(Identifer: String;
  const Value: Variant; var Done: Boolean);
var
  f: TField;
  OldState: TDataSetState;
begin
  if CompareStr(Identifer, TSharedFields.F_Cost) = 0 then
  begin
    if VarIsNull(Value) then FScriptCost := 0 else FScriptCost := Value;
    Done := true;
  end
  else
  begin
    //f := ScriptDataSet.FindField(Identifer);    19.12.2006
    f := DataSet.FindField(Identifer);
    if f <> nil then begin
      // разрешаем изменение вычисляемых полей при их пересчете (OnCalcFields),
      // фиктивных и независимых - при пересчете фиктивных (OnChange).
      if (OnCalcFieldsRunning and (f.FieldKind = fkCalculated))
         or (not OnCalcFieldsRunning and (f.FieldKind <> fkCalculated)) then
      begin
        // Следующие строки закомментированы, т.к. они привели к жутким глюкам
        // при расчете вычисляемых полей. Они предотвращали появление EBitsError,
        // связанной с обновлением агрегатных значений. Если опять будут проблемы,
        // надо попробовать создавать не TAggregate, а TAggregateField.
        {if ScriptDataSet is TClientDataSet then begin
          OldAggs := (ScriptDataSet as TClientDataSet).AggregatesActive;
          (ScriptDataSet as TClientDataSet).AggregatesActive := false;
        end;}
        if FieldValueChanged(f, Value) then
        begin
          //OldState := ScriptDataSet.State;    19.12.2006
          OldState := DataSet.State;
          if not (OldState in [dsInsert, dsEdit, dsCalcFields, dsInternalCalc]) then
          begin
            //if ScriptDataSet.IsEmpty then ScriptDataSet.Append;      19.12.2006
            //ScriptDataSet.Edit;
            if DataSet.IsEmpty then DataSet.Append;
            DataSet.Edit;
          end;
          f.Value := Value;
        end
        else if Assigned(f.OnChange) then begin
          FNoModifyTracking := true;
          f.OnChange(f);
          FNoModifyTracking := false;
        end;
        {if ScriptDataSet is TClientDataSet then
          (ScriptDataSet as TClientDataSet).AggregatesActive := OldAggs;}
        {if (ScriptDataSet.State in [dsInsert, dsEdit]) and not DisableTotalCost then
          ScriptDataSet.Post;}
      end
      else
      begin  // Иначе выдаем ошибку
        if OnCalcFieldsRunning then
          raise Exception.Create('Попытка модификации невычисляемого поля')
        else
          raise Exception.Create('Попытка модификации вычисляемого поля');
      end;
      Done := true;
    end;
  end;
end;

// Читает из таблицы описания полей некоторые параметры существующих полей,
// создает вычисляемые. Вызывается ДО ОТКРЫТИЯ НАБОРОВ ДАННЫХ.
// !!!!!!!!!!!!!!!!!!!!!! APPSERVER частично
procedure TPolyProcess.ReadFieldsFromInfo;
var
  FieldInfoData: TDataSet;

  function CreateFieldInDataSet(dq: TDataSet): TField;
  begin
    Result := CreateField(dq, Self, FieldInfoData['FieldName'],
      GetFieldClass(TFieldType(FieldInfoData['FieldType'])), NvlInteger(FieldInfoData['Length']),
      (FieldInfoData['FieldStatus'] = ftCalculated));
    if (Result is TNumericField) then begin
      if not VarIsNull(FieldInfoData['DisplayFormat']) then
        (Result as TNumericField).DisplayFormat := FieldInfoData['DisplayFormat'];
      if not VarIsNull(FieldInfoData['EditFormat']) then
        (Result as TNumericField).EditFormat := FieldInfoData['EditFormat'];
    end;
    if (Result is TDateTimeField) then begin
      if not VarIsNull(FieldInfoData['DisplayFormat']) then
        (Result as TDateTimeField).DisplayFormat := FieldInfoData['DisplayFormat'];
    end;
    if Result is TBCDField then begin
      (Result as TBCDField).Size := NvlInteger(FieldInfoData['Precision']);
      (Result as TBCDField).Precision := NvlInteger(FieldInfoData['Length']);
    end;

    // Статус отмечаем обязательно
    Result.Tag := FieldInfoData['FieldStatus'];

    if FieldInfoData['CustomGetText'] then Result.OnGetText := FieldGetText;

    Result.DisplayLabel := NvlString(FieldInfoData['FieldDesc']);

    { не признаемся, что это ключ  - см. sdm.pvSrvBeforeUpdateRecord }
    if Result.FieldName = F_ProcessKey then
      Result.ProviderFlags := [pfInWhere]
    else if (Result.Tag = ftData) or (Result.Tag = ftIndependent) then
      Result.ProviderFlags := [pfInUpdate]
    else begin
      Result.ProviderFlags := [];
      if Result.Tag = ftVirtual then Result.FieldKind := fkInternalCalc;
    end;
  end;

  procedure CreateSumAggregate(dq: TClientDataSet{; AddToGrandTotal, AddToProfit: boolean}); // 31.12.2004
  var
    Agg: TAggregateField;
  begin
    Agg := CreateAggField(dq, Self, AggPrefix + FieldInfoData['FieldName'], 'sum(' + FieldInfoData['FieldName'] + ')');  // 31.12.2004
    Agg.Active := true;
    if CompareText(FieldInfoData['FieldName'], F_EnabledCost) = 0 then
      FCostAggField := Agg;
  end;

begin
  if ProcessCfg.SrvIDForFields > 0 then begin
    DataSet.Fields.Clear;
    //DBDataSet.Fields.Clear;   // 13.07.2004
    ProcessCfg.BeginReadFieldInfo;
    FieldInfoData := ProcessCfg.FieldInfoData;
    while not FieldInfoData.eof do
    try
      // Создаем и в серверном наборе данных поля.
      // Т.к., например, при связи с Access строковые поля по умолчанию - WideString.
      // А если создать явно такое же поле, но String, то все катит нормально.
      // Для SQL Server этого можно и не делать (конечно, только для DBDataSet).
      {if (FieldInfoData['FieldStatus'] <> ftVirtual) and (FieldInfoData['FieldStatus'] <> ftCalculated) then
        CreateFieldInDataSet(DBDataSet);  // вычисляемые поля на сервере не создаем  // 13.07.2004 }
      CreateFieldInDataSet(DataSet);
      if not VarIsNull(FieldInfoData['CalcTotal']) {and not VarIsNull(FieldInfoData['AddToGrandTotal'])
         and not VarIsNull(FieldInfoData['AddToProfit'])} // 31.12.2004
         and FieldInfoData['CalcTotal'] then
        CreateSumAggregate(DataSet as TClientDataSet
          {FieldInfoData['AddToGrandTotal'], FieldInfoData['AddToProfit']} // 31.12.2004
          );
    finally
      FieldInfoData.Next;
    end;
    PrepareFields;  // восстановить обработчики полей
  end;
end;

procedure TPolyProcess.SaveSettings(IniF: TJvCustomAppStorage);
begin
  if Assigned(FOnSaveSettings) and FSettingsLoaded then FOnSaveSettings(Self, IniF);
end;

procedure TPolyProcess.SetAllItemParams;
begin
  ExecScriptForEachRecord(ExecItemParams, false);  // all records
end;

procedure TPolyProcess.SetContentProtected(Value: boolean);
begin
  FContentProtected := Value and ProcessCfg.IsContent;
end;

procedure TPolyProcess.SetDataSource(Val: TDataSource);
begin
  FDataSrc := Val;
end;

procedure TPolyProcess.SetField(FieldName: string; FieldValue: variant);
//var dq: TDataSet;
var Done: boolean;
begin
  DoSetValue(FieldName, FieldValue, Done);
  {dq := DataSet;
  if (dq <> nil) and dq.Active then
  begin                     
    if not (dq.State in [dsInsert, dsEdit, dsCalcFields]) then dq.Edit;
    dq[FieldName] := FieldValue;
  end;}
end;

procedure TPolyProcess.SetFilterEn(Val: boolean);
begin
  if FDataSrc <> nil then FDataSrc.DataSet.Filtered := Val;
end;

procedure TPolyProcess.SetItemParam(const ParamName: string; ParamValue: variant);
var
  FProcessItems: TOrderProcessItems;
begin
  FProcessItems := (ParentOrder as TOrder).OrderItems;
  if ProcessChangeLock.Find(ParamName) {SettingProcessParam} then Exit;
  if FProcessItems.Locate(DataSet[F_ItemID]) then
  begin
    // только если значение изменилось
    if FProcessItems.DataSet[ParamName] <> ParamValue then
    begin
      if not (FProcessItems.DataSet.State in [dsInsert, dsEdit]) then
        FProcessItems.DataSet.Edit;
      //SettingItemParam := true;
      ItemChangeLock.Lock(ParamName);
      try
        FProcessItems.DataSet[ParamName] := ParamValue;
        // Здесь обязательно проверка, т.к. состояние может измениться в OnChange.
        if FProcessItems.DataSet.State in [dsInsert, dsEdit] then
          FProcessItems.DataSet.Post;
      finally
        //SettingItemParam := false;
        ItemChangeLock.Unlock;
      end;
    end;
  end
  else
  if DataSet.State <> dsInsert then
    raise EjvScriptError.Create(-2, 'Локальное нарушение целостности данных.'#13 +
      'Возможна потеря данных. Сообщите разработчику.');
    // В режиме вставки запись действительно будет отсутствовать. Такая ситуация
    // возникает при вычислении ScriptedProfitCost в обработчике OnChange.
end;

procedure TPolyProcess.SetPermissions(_PermitInsert, _PermitUpdate, _PermitDelete,
   _PermitPlan, _PermitFact: boolean);
begin
  FPermitInsert := _PermitInsert;
  FPermitUpdate := _PermitUpdate;
  FPermitDelete := _PermitDelete;
  FPermitPlan := _PermitPlan;
  FPermitFact := _PermitFact;
end;

procedure TPolyProcess.SetPrices;
var
  OldState: TDataSetState;
  ds: TDataSet;
begin
  if Assigned(CodeOnSetPrices) and (CodeOnSetPrices.Count > 0) then
  begin
    ds := DataSet;
    if not Assigned(ds) or not ds.Active or ds.IsEmpty then Exit;
    OnSetPricesRunning := true;
    OldState := ds.State;
    ds.DisableControls;
    try
      ExecCode(FScript_OnSetPrices);
    finally
      OnSetPricesRunning := false;
      if OldState = dsBrowse then ds.CheckBrowseMode
      else if OldState in [dsEdit, dsInsert] then ds.Edit;
      ds.EnableControls;
    end;
  end;
end;

procedure TPolyProcess.SetProcessModified(c: boolean);
begin
  FProcessModified := c;
  // сообщаем об изменении
  if c and Assigned(FOnProcessModify) then
    FOnProcessModify(Self);
end;

procedure TPolyProcess.TotalsChanged;
begin

end;

procedure TPolyProcess.UpdatePrices;

  procedure UpdatePr;
  var
    bm: TBookmark;
  begin
    if (DataSet <> nil) and DataSet.Active and not DataSet.IsEmpty then begin
      bm := DataSet.GetBookmark;
      DataSet.DisableControls;
      try
        DataSet.First;
        ScriptRecNo := 1;
        while not DataSet.eof do begin
          SetPrices;
          DataSet.Next;
          Inc(ScriptRecNo);
        end;
        ExecAfterOpen;
      finally
        Dataset.GotoBookmark(bm);
        DataSet.FreeBookmark(bm);
        DataSet.EnableControls;
      end;
    end
  end;

begin
  if FPermitUpdate and not ContentProtected then UpdatePr;
end;

procedure TPolyProcess.WriteFieldsToDataSet(dqFields: TDataSet);
var
  gc: TFields;
  f: TField;
  i, l, p: integer;
begin
  if (FDataSrc <> nil) and (SrvID > 0) then begin
    GC := FDataSrc.DataSet.Fields;
    for i := 0 to Pred(gc.Count) do begin
      f := gc[i];
      dqFields.Append;
      dqFields[F_SrvID] := SrvID;
      dqFields['FieldName'] := f.FieldName;
      if f.FieldName = TSharedFields.F_Enabled then
        dqFields['FieldDesc'] := 'Запись включена'
      else if f.FieldName = F_ProcessKey then
        dqFields['FieldDesc'] := 'Ид. записи'
      else if f.FieldName = 'Kolvo' then
        dqFields['FieldDesc'] := 'Количество'
      else if (f.FieldName = 'NProduct') or (f.FieldName = 'Tirazz') then
        dqFields['FieldDesc'] := 'Тираж';
      dqFields['FieldType'] := f.DataType;
      p := 0;
      if f.DataType = ftString then l := f.Size
      else if f.DataType = ftInteger then l := 4
      else if f.DataType = ftFloat then begin l := 8; p := 2; end
      else if f.DataType = ftSmallint then l := 2
      else if f.DataType = ftBoolean then l := 1
      else if f.DataType = ftBlob then l := 16
      else if f.DataType = ftMemo then l := 16;
      dqFields['Length'] := l;
      dqFields['Precision'] := p;
      if f is TNumericField then begin
        dqFields['DisplayFormat'] := (f as TNumericField).DisplayFormat;
        dqFields['EditFormat'] := (f as TNumericField).EditFormat;
      end;
      if f.FieldKind = fkCalculated then f.Tag := ftCalculated;
      dqFields['FieldStatus'] := f.Tag;
    end;
  end;
end;

procedure TPolyProcess.AddLinkedProcess(LinkedProcess: TPolyProcess);
begin
  FLinkedProcesses.Add(LinkedProcess);
end;

procedure TPolyProcess.AppendChildProcess(ChildPrc: TPolyProcess);
var
  DS: TDataSet;
  FProcessItems: TOrderProcessItems;
begin
  //AddLinkedProcess(ChildPrc); не добавляем т.к. потом будут добавляться записи автоматически
  DS := ChildPrc.DataSet;
  if DS.State in [dsInsert, dsEdit] then
    DS.Post;
  DS.Append;
  if DS.State in [dsInsert, dsEdit] then
    DS.Post;
  FProcessItems := (ParentOrder as TOrder).OrderItems;
  if FProcessItems.Locate(DS[F_ItemID]) then
  begin
    FProcessItems.DataSet.Edit;
    FProcessItems.DataSet[TSharedFields.F_LinkedItemID] := DataSet[F_ItemID];
    FProcessItems.DataSet.Post;
  end
  else
    raise Exception.Create('Не найдена запись дочернего процесса в AppendChildProcess');
end;

// Выполнение сценария инициализации новой записи
procedure TPolyProcess.ExecNewRecCode;
begin
  if Assigned(CodeOnNewRec) and (CodeOnNewRec.Count > 0) then
    ExecCode(FScript_OnNewRecord);
end;

function TPolyProcess.LocateChildProcess(ChildPrc: TPolyProcess): Boolean;
var
  FProcessItems: TOrderProcessItems;
begin
  FProcessItems := (ParentOrder as TOrder).OrderItems;
  Result := FProcessItems.DataSet.Locate(TSharedFields.F_LinkedItemID + ';' + TOrderProcessItems.F_ProcessID,
    VarArrayOf([DataSet.FieldByName(F_ItemID).AsInteger, ChildPrc.SrvID]), []);
  if Result then
    Result := ChildPrc.DataSet.Locate(F_ItemID, FProcessItems.KeyValue, []);
end;

// Проверяет, можно ли удалить дочерние процессы.
function TPolyProcess.CanRemoveChildProcesses: boolean;
var
  FProcessItems: TOrderProcessItems;
  Mat: TMaterials;
begin
  Result := true;
  FProcessItems := (ParentOrder as TOrder).OrderItems;
  FProcessItems.DataSet.DisableControls;
  try
    FProcessItems.DataSet.Filter := TSharedFields.F_LinkedItemID + ' = ' + VarToStr(DataSet[F_ItemID]);
    FProcessItems.DataSet.Filtered := true;
    while not FProcessItems.DataSet.eof do
    begin
      if FProcessItems.Materials.HasFactInfo(FProcessItems.KeyValue) then
      begin
        Result := false;
        break;
      end;
      FProcessItems.DataSet.Next;
    end;
  finally
    FProcessItems.DataSet.Filtered := false;
    FProcessItems.DataSet.EnableControls;
  end;
end;

// Удаляет дочерний процесс. Он уже может быть удален пользователем к этому моменту.
procedure TPolyProcess.RemoveChildProcess(ChildPrc: TPolyProcess);
var
  DS: TDataSet;
begin
  DS := ChildPrc.DataSet;
  //if not DS.Active then sm.OpenProcess(TPolyProcess(FLinkedProcesses[i]));
  while DS.Active and LocateChildProcess(ChildPrc) do
    DS.Delete;
end;

function TPolyProcess.GetSrvName: string;
begin
  Result := FProcessCfg.ServiceName;
end;

function TPolyProcess.GetTabName: string;
begin
  Result := FProcessCfg.TableName;
end;

{$ENDREGION}

{ Utility }

procedure GridOptions(dgCommon: TGridClass);
begin
  {if ProcessEnterAsTab then dgCommon.OptionsEh := dgCommon.OptionsEh + [dghEnterAsTab]
  else dgCommon.OptionsEh := dgCommon.OptionsEh - [dghEnterAsTab];}
  // Здесь закомментировал, так как сейчас обработка производится при входе в таблицу
  if not Options.ProcessAutoAppend then dgCommon.AllowedOperations := [alopDeleteEh, alopUpdateEh];
end;

function FindColumn(DBGrid: TGridClass; FieldName: string): TColumnEh;
var
  i: integer;
begin
  Result := nil;
  if DBGrid.Columns.Count > 0 then
    for i := 0 to Pred(DBGrid.Columns.Count) do
      if AnsiCompareText(DBGrid.Columns[i].FieldName, FieldName) = 0 then begin
        Result := DBGrid.Columns[i];
        Exit;
      end;
end;

{$REGION 'TGridPolyProcess'}

constructor TGridPolyProcess.Create(AOwner: TComponent; _ProcessCfg: TPolyProcessCfg);
begin
  inherited Create(AOwner, _ProcessCfg);
  FGrids := TCollection.Create(TProcessGrid);
end;

procedure TGridPolyProcess.CreateGrids(TotalUpdateEvent: TNotifyProcessGridEvent);
var
  GridObj: TProcessGrid;
  I: Integer;
  Cfg: TProcessGridCfg;
begin
  for I := 0 to ProcessCfg.Grids.Count - 1 do
  begin
    Cfg := ProcessCfg.Grids.Items[i] as TProcessGridCfg;
    GridObj := Grids.Add as TProcessGrid;
    GridObj.GridID := Cfg.GridID;
    GridObj.GridCfg := Cfg;
    GridObj.OnGridTotalUpdate := TotalUpdateEvent;
    GridObj.Srv := Self;
  end;
end;

procedure TGridPolyProcess.Prepare;
begin
  inherited Prepare;
  PrepareGrids;
  PrepareTotals;
end;

procedure TGridPolyProcess.PrepareGrids;
var i: integer;
begin
  if FGrids <> nil then
    if FGrids.Count > 0 then
      for i := 0 to FGrids.Count - 1 do
        (FGrids.Items[i] as TProcessGrid).PrepareGrid;
end;

procedure TGridPolyProcess.PrepareTotals;
var i: integer;
begin
  if FGrids <> nil then
    if FGrids.Count > 0 then
      for i := 0 to FGrids.Count - 1 do
        (FGrids.Items[i] as TProcessGrid).PrepareTotalPanel;
end;

procedure TGridPolyProcess.SetContentProtected(Value: boolean);
begin
  inherited SetContentProtected(Value);
  PrepareGrids;
end;

procedure TGridPolyProcess.TotalsChanged;
var i: integer;
begin
  inherited TotalsChanged;
  if FGrids <> nil then
    if FGrids.Count > 0 then begin
      for i := 0 to FGrids.Count - 1 do
        (FGrids.Items[i] as TProcessGrid).TotalsChanged;
    end;
end;

procedure TGridPolyProcess.UpdateGridTotals;
var i: integer;
begin
  if FGrids <> nil then
    if FGrids.Count > 0 then
      for i := 0 to FGrids.Count - 1 do
        (FGrids.Items[i] as TProcessGrid).UpdateTotalControls;
end;

{$ENDREGION}

{$REGION 'TProcessGrid' }

constructor TProcessGrid.Create(Collection: TCollection);
begin
  inherited Create(Collection);
end;

{procedure TGridObj.GridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var Row, Column: integer;
begin
  FGrid.MouseToCell(X, Y, Column, Row);
  if (Column <> -1) and (FGrid.Row = Row) and (FGrid.Columns[Column - 1].FieldName = ServiceCostField) and
    not VarIsNull(DataSet[ServiceCostField]) then begin
    FGrid.ShowHint := true;
    FGrid.Hint := FormatFloat(NumDisplayFmt, DataSet[ServiceCostField] * sm.USDCourse) + ' грн.';
  end else
    FGrid.ShowHint := false;
end;}

destructor TProcessGrid.Destroy;
begin
  inherited Destroy;
end;

procedure TProcessGrid.AppendRecord;
begin
  if (FSrv <> nil) and FSrv.PermitInsert and not FSrv.ContentProtected then
    FSrv.AppendRecord;
end;

procedure TProcessGrid.Clear;
begin
  if (FSrv <> nil) and FSrv.PermitDelete and not FSrv.ContentProtected then
  begin
    if not Options.ConfirmDelete
       or (RusMessageDlg('Очистить таблицу "' + FSrv.ServiceName + '"?', mtConfirmation, mbYesNoCancel, 0) = mrYes) then
      FSrv.Clear;
  end;
end;

procedure TProcessGrid.ClearDBGrid;
begin
  FGrid := nil;
end;

procedure TProcessGrid.ColumnEditButtonDown(Sender: TObject;
  TopButton: Boolean; var AutoRepeat, Handled: Boolean);
var
  p: TPoint;
begin
  p.x := Mouse.CursorPos.X;
  p.y := Mouse.CursorPos.Y;
  GridContextPopup(TComponent(TComponent(Sender).Owner).Owner{MForm.ActiveControl}, p, Handled); // Sender = TEditButtonControlEh
end;

procedure TProcessGrid.DeleteRecord;
begin
  if (FSrv <> nil) and FSrv.PermitDelete and not FSrv.ContentProtected then
  begin
    if not Options.ConfirmDelete or (RusMessageDlg('Удалить строку?', mtConfirmation, mbYesNoCancel, 0) = mrYes) then
      FSrv.DeleteRecord;
  end;
end;

procedure TProcessGrid.ExecCode(ScriptFieldName: string);
begin
  ServiceExecCode(Self, ScriptFieldName);
end;

function TProcessGrid.GetCodeOnContextPopup: TStringList;
begin
  Result := GridCfg.GetScript(FScript_OnContextPopup);
end;

function TProcessGrid.GetCodeOnDrawCell: TStringList;
begin
  Result := GridCfg.GetScript(FScript_OnDrawCell);
end;

function TProcessGrid.GetCodeOnGridEnter: TStringList;
begin
  Result := GridCfg.GetScript(FScript_OnGridEnter);
end;

function TProcessGrid.GetCodeOnSelectPopup: TStringList;
begin
  Result := GridCfg.GetScript(FScript_OnSelectPopup);
end;

function TProcessGrid.GetDataSource: TDataSource;
begin
  if FSrv <> nil then
    Result := FSrv.DataSource
  else
    Result := nil;
end;

function TProcessGrid.GetItemCount: integer;
begin
  Result := FSrv.DataSet.RecordCount;
end;

function TProcessGrid.GetShowPanel: boolean;
begin
  Result := FGridCfg.ShowControlPanel;
  if FSrv <> nil then
    Result := Result and (FSrv.PermitInsert or FSrv.PermitDelete);
end;

function TProcessGrid.GetTotalCost: extended;
begin
  Result := GetTotalValue(GridCfg.TotalFieldName);
end;

function TProcessGrid.GetTotalMatCost: extended;
begin
  Result := GetTotalValue(GridCfg.TotalMatFieldName);
end;

function TProcessGrid.GetTotalValue(_FieldName: string): extended;
begin
  Result := NvlFloat(FSrv.GetTotal(_FieldName));
end;

function TProcessGrid.GetTotalWorkCost: extended;
begin
  Result := GetTotalValue(GridCfg.TotalWorkFieldName);
end;

procedure TProcessGrid.GridCellClick(Column: TColumnEh);
begin
  GridEnter(Column.Grid);
  if Column.Field is TBooleanField and Srv.PermitUpdate and not Srv.ContentProtected then
  try
    if (Column.Field = nil) then Exit;
    Column.Field.Dataset.Edit;
    if Column.Field.IsNull then Column.Field.Value := true
    else Column.Field.Value := not Column.Field.Value;
    Column.Field.Dataset.Post;
    Column.Grid.refresh;
  except
  end;
end;

// Обработка нажатия правой кнопки мыши
procedure TProcessGrid.GridContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  GridEnter(Sender);
  //try
    {try          // 18.11.2007 - в GridEnter уже это есть
      if (Sender as TGridClass).SelectedField <> nil then
        ScriptCurField := (Sender as TGridClass).SelectedField.FieldName
      else
        ScriptCurField := '';
    except
      ScriptCurField := '';
    end;}
    //ScriptDicElements := DicElemList;
    ScriptPopupMenuFilled := false;
    ExecCode(FScript_OnContextPopup);
    if (ScriptPopupMenu <> nil) and ScriptPopupMenuFilled then
      ScriptPopupMenu.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
    Handled := true;
  //except end;
end;

procedure TProcessGrid.GridEnter(Sender: TObject);
begin
  try
    if (Sender as TGridClass).SelectedField <> nil then
      ScriptCurField := (Sender as TGridClass).SelectedField.FieldName
    else
      ScriptCurField := '';
  except
    ScriptCurField := '';
  end;
  //ScriptDicElements := DicElemList;
  if Options.ProcessEnterAsTab then
    SetEnterAsTab(Sender as TGridClass)
  else
    (Sender as TGridClass).OptionsEh := (Sender as TGridClass).OptionsEh - [dghEnterAsTab];
  //ToggleEditing(Sender as TGridClass, false);
  { TODO: Здесь убрал ToggleEditing для процессов. Попробуем без него }
  if GridCfg.AssignGridEnter then
    ExecCode(FScript_OnGridEnter);
end;

procedure TProcessGrid.GridExit(Sender: TObject);
begin
  { TODO: Здесь убрал ToggleEditing для процессов. Попробуем без него }
  //ToggleEditing(Sender as TGridClass, true);
end;

procedure TProcessGrid.GridGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
var
  f: TField;
  OldScriptCurField: string;
begin
  if (Column = nil) or (Column.Field = nil) or Column.Field.DataSet.IsEmpty then
    Exit;
  f := Column.Field.DataSet.FindField(TSharedFields.F_Enabled);
  if (f <> nil) and not f.AsBoolean then
  begin   // Если запись не enabled, красим ее сами
    if gdSelected in State then begin
      AFont.Color := Options.GetColor(sDisabledProcessText);
    end else
      AFont.Color := Options.GetColor(sDisabledProcessSelText);
  end
  else if GridCfg.AssignDrawCell then
  begin  // иначе вызываем скрипт, если он разрешен
    OldScriptCurField := ScriptCurField;
    try
      ScriptCurField := Column.Field.FieldName;
      ScriptFont := AFont;
      ScriptBackground := Background;
      ScriptHighlight := gdSelected in State;
      try
        ExecCode(FScript_OnDrawCell);
        AFont := ScriptFont;
        Background := ScriptBackground;
      except end;
    finally
      ScriptCurField := OldScriptCurField;
    end;
  end;
end;

procedure TProcessGrid.PanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  t: extended;
  tp: TPanel;
begin
  try
    tp := Sender as TPanel;
    tp.ShowHint := true;
    t := StrToFloat(DelChars(tp.Caption, ThousandSeparator));
    tp.Hint := FormatFloat(CalcUtils.NumDisplayFmt, t * (FSrv.ParentOrder as TOrder).Processes.USDCourse) + ' грн.';
  except
    tp.ShowHint := false;
  end;
end;

// Обработка выбора пункта меню - значения справочника
procedure TProcessGrid.PopupSelected(Sender: TObject);
var
  dq: TDataSet;
begin
  if FSrv.PermitUpdate and not FSrv.ContentProtected then
  begin
    dq := FSrv.DataSet;
    ScriptPopupSelected := (Sender as TMenuItem).Tag;
    ExecCode(FScript_OnSelectPopup);
    if dq.State in [dsEdit, dsInsert] then dq.Post;
  end;
end;

procedure TProcessGrid.PrepareGrid;
var
  AllowedOperations: TDBGridEhAllowedOperations;
begin
  if Assigned(FGrid) then
  begin
    // Вход в табличку или колонку и выход. 18.11.2007 - обработчики назначаются всегда
    //if FAssignGridEnter then
    //begin
      FGrid.OnEnter := GridEnter;
      FGrid.OnColEnter := GridEnter;
      FGrid.OnColExit := GridExit;
      FGrid.OnCellClick := GridCellClick;
      FGrid.OnContextPopup := GridContextPopup;
    //end;
    FGrid.OnGetCellParams := GridGetCellParams;
    AllowedOperations := [];
    FGrid.ReadOnly := not (FSrv.PermitUpdate or FSrv.PermitInsert or FSrv.PermitDelete)
      or FSrv.ContentProtected;
    if not FSrv.ContentProtected then
    begin
      if FSrv.PermitUpdate then AllowedOperations := [alopUpdateEh];
      if FSrv.PermitInsert then AllowedOperations := AllowedOperations + [alopInsertEh, alopAppendEh];
      if FSrv.PermitDelete then AllowedOperations := AllowedOperations + [alopDeleteEh];
    end;
    FGrid.AllowedOperations := AllowedOperations;
  end;
end;

procedure TProcessGrid.PrepareTotalPanel;
begin
  if Assigned(FTotalPanel) then FTotalPanel.OnMouseMove := PanelMouseMove;
end;

// Создает в таблице заданные в описании столбцы
procedure TProcessGrid.RestoreGridCols;
var
  i: integer;
  col: TColumnEh;
  FGridCols: TCollection;
begin
  FGridCols := GridCfg.GridCols;
  if (FGridCols <> nil) then
  begin
    FGrid.Columns.Clear;
    if (FGridCols.Count > 0) then
      for i := 0 to Pred(FGridCols.Count) do
      begin
        col := FGrid.Columns.Add;
        (FGridCols.Items[i] as TGridCol).AssignToColumn(col);
        if Col.AlwaysShowEditButton then
        begin
          if not (col.Field is TDateTimeField) then
          begin
            Col.OnEditButtonDown := ColumnEditButtonDown;
            Col.ButtonStyle := cbsDropDown;
          end;
        end{ else
          col.CheckBoxes := false};
      end;
  end;
end;

// Сохраняет ширину столбцов таблицы в конфигурационном объекте
procedure TProcessGrid.SaveGridColsWidth;
var
  i: integer;
begin
  if (GridCfg.GridCols <> nil) and (GridCfg.GridCols.Count > 0) and (FGrid <> nil) then
    for i := 0 to Pred(GridCfg.GridCols.Count) do
      if i < FGrid.Columns.Count then  // на всякий случай
        (GridCfg.GridCols.Items[i] as TGridCol).Width := FGrid.Columns[i].Width;
end;

// Восстанавливает ширину столбцов таблицы из конфигурационного объекта
procedure TProcessGrid.LoadGridColsWidth;
var
  i: integer;
begin
  if (GridCfg.GridCols <> nil) and (GridCfg.GridCols.Count > 0) and (FGrid <> nil) then
    for i := 0 to Pred(GridCfg.GridCols.Count) do
      if i < FGrid.Columns.Count then  // на всякий случай
        FGrid.Columns[i].Width := (GridCfg.GridCols.Items[i] as TGridCol).Width;
end;

procedure TProcessGrid.SetDBGrid(Val: TGridClass);
begin
  FGrid := Val;
  if FGrid <> nil then
    FGrid.DataSource := FSrv.DataSource;
  PrepareGrid;
  RestoreGridCols;
end;

procedure TProcessGrid.SetEnterAsTab(Grid: TGridClass{; Entering: boolean});
var
  Cols: TDBGridColumnsEh;
  Sel, i: integer;
  HasModif: boolean;
begin
  // При входе проверяем: если это НЕ последний НЕ-ReadOnly столбец, то ставим EnterAsTab
  Cols := Grid.Columns;
  Sel := Grid.SelectedIndex;
  if (Sel < Pred(Cols.Count)) or (Cols.Count <= 1) then
  begin
    HasModif := false;
    i := Sel + 1;
    while (i <= Pred(Cols.Count)) and not HasModif do begin
      HasModif := not Cols[i].ReadOnly and (Cols[i].Field <> nil) and not Cols[i].Field.ReadOnly;
      Inc(i);
    end;
    if HasModif then
      Grid.OptionsEh := Grid.OptionsEh + [dghEnterAsTab]
    else
      Grid.OptionsEh := Grid.OptionsEh - [dghEnterAsTab];
  end
  else // последний
    Grid.OptionsEh := Grid.OptionsEh - [dghEnterAsTab];
end;

procedure TProcessGrid.SetTotalMatPanel(Val: TPanel);
begin
  FTotalMatPanel := Val;
  if FTotalMatPanel <> nil then
  begin
    PrepareTotalPanel;
    UpdateTotalControls;
  end;
end;

procedure TProcessGrid.SetTotalPanel(Val: TPanel);
begin
  FTotalPanel := Val;
  if FTotalPanel <> nil then
  begin
    PrepareTotalPanel;
    UpdateTotalControls;
  end;
end;

procedure TProcessGrid.SetTotalWorkPanel(Val: TPanel);
begin
  FTotalWorkPanel := Val;
  if FTotalWorkPanel <> nil then
  begin
    PrepareTotalPanel;
    UpdateTotalControls;
  end;
end;

procedure TProcessGrid.TotalsChanged;
begin
  UpdateTotalControls;
  ExecCode(FScript_OnCalcTotal);
  if Assigned(FOnGridTotalUpdate) then FOnGridTotalUpdate(Self);
end;

procedure TProcessGrid.UpdateTotalControls;
begin
  // TODO: В итогах может быть не только ценовая информация (отгрузка), поэтому проверка убрана.
  // Лучше всего было бы проверять, по какому полю считается итог, и если оно
  // ценовое, то тогда скрывать, но управление видимостью панели находится в другом месте,
  // так что одна проверка здесь бесполезна. Пока что панель можно показать скриптом.
  //if AccessManager.CurKindPerm.CostView then
  //begin
    if Assigned(FTotalPanel) then FormatTotal(GetTotalCost, FTotalPanel);
    if Assigned(FTotalWorkPanel) then FormatTotal(GetTotalWorkCost, FTotalWorkPanel);
    if Assigned(FTotalMatPanel) then FormatTotal(GetTotalMatCost, FTotalMatPanel);
  //end;
end;

{$ENDREGION}

{TServiceList = class(TObject)
  function GetCount: integer;
public
  property Count: integer read GetCount;
  property Service
end;

function TServiceList.GetCount: integer;
begin
end;}

initialization

  ProcessChangeLock := TChangeLocker.Create;
  ItemChangeLock := TChangeLocker.Create;

finalization

  FreeAndNil(ProcessChangeLock);
  FreeAndNil(ItemChangeLock);

end.

