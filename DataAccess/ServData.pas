unit ServData;

{$I Calc.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, ADODB, DBClient, Provider, Variants,

  NotifyEvent, CalcUtils, PmProcess, PmProcessCfg, DicObj, CalcSettings, PmDatabase;

const
  SrvTablePrefix = 'Service_';
  // При добавлении нового свойства поля процесса надо его регистрировать здесь
  // и в методе ApplySrvStructChange!
  SrvStructPropFields = 'FieldType,DisplayFormat,EditFormat,FieldStatus,[Length],'
    + '[Precision],NotForCopy,CustomGetText,CalcTotal,LookupDicID,LookupKeyField';

  OrderKindDescField = 'KindDesc';

type
  Tsdm = class(TDataModule, IRCDataModule)
    dsServices: TDataSource;
    dsSrvGrps: TDataSource;
    pvServices: TDataSetProvider;
    pvSrvGrps: TDataSetProvider;
    pvParams: TDataSetProvider;
    pvSrvFieldInfo: TDataSetProvider;
    cdServices: TClientDataSet;
    cdSrvGrps: TClientDataSet;
    cdParams: TClientDataSet;
    cdSrvFieldInfo: TClientDataSet;
    aqServices: TADOQuery;
    cdServicesSrvID: TAutoIncField;
    cdServicesSrvName: TStringField;
    cdServicesSrvDesc: TStringField;
    cdServicesSrvActive: TBooleanField;
    cdServicesOnChange: TMemoField;
    cdServicesOnNewRecord: TMemoField;
    cdServicesOnCalcFields: TMemoField;
    cdServicesOnParamChange: TMemoField;
    cdServicesOnSetPrices: TMemoField;
    cdServicesOnCheck: TMemoField;
    aqSrvGrps: TADOQuery;
    cdSrvGrpsGrpID: TAutoIncField;
    cdSrvGrpsGrpNumber: TIntegerField;
    cdSrvGrpsGrpDesc: TStringField;
    aspNewSrv: TADOStoredProc;
    aqParams: TADOQuery;
    cdParamsParamID: TAutoIncField;
    cdParamsParName: TStringField;
    cdParamsParDesc: TStringField;
    aqSrvFieldInfo: TADOQuery;
    aqSrvGridCols: TADOQuery;
    pvSrvGridCols: TDataSetProvider;
    cdSrvGridCols: TClientDataSet;
    cdOldSrvStruct: TClientDataSet;
    cdSrvStruct: TClientDataSet;
    cdSrvStructFieldName: TStringField;
    cdSrvStructFieldDesc: TStringField;
    cdSrvStructFieldType: TIntegerField;
    cdSrvStructLength: TIntegerField;
    cdSrvStructPrecision: TIntegerField;
    cdSrvStructDisplayFormat: TStringField;
    cdSrvStructEditFormat: TStringField;
    cdOldSrvStructFieldName: TStringField;
    cdOldSrvStructFieldDesc: TStringField;
    cdOldSrvStructFieldType: TIntegerField;
    cdOldSrvStructLength: TIntegerField;
    cdOldSrvStructPrecision: TIntegerField;
    cdOldSrvStructDisplayFormat: TStringField;
    cdOldSrvStructEditFormat: TStringField;
    cdSrvGridColsColID: TAutoIncField;
    cdSrvGridColsSrvID: TIntegerField;
    cdSrvGridColsColNumber: TIntegerField;
    cdSrvGridColsAlignment: TIntegerField;
    cdSrvGridColsColor: TIntegerField;
    cdSrvGridColsFieldName: TStringField;
    cdSrvGridColsReadOnly: TBooleanField;
    cdSrvGridColsCaption: TStringField;
    cdSrvGridColsCaptionAlignment: TIntegerField;
    cdSrvGridColsCaptionColor: TIntegerField;
    cdSrvGridColsFontColor: TIntegerField;
    cdSrvGridColsCaptionFontColor: TIntegerField;
    cdSrvFieldInfoSrvFieldID: TAutoIncField;
    cdSrvFieldInfoSrvID: TIntegerField;
    cdSrvFieldInfoFieldName: TStringField;
    cdSrvFieldInfoFieldDesc: TStringField;
    cdSrvFieldInfoFieldType: TIntegerField;
    cdSrvFieldInfoLength: TIntegerField;
    cdSrvFieldInfoPrecision: TIntegerField;
    cdSrvFieldInfoDisplayFormat: TStringField;
    cdSrvFieldInfoEditFormat: TStringField;
    cdSrvFieldInfoFieldStatus: TIntegerField;
    aqServicesSrvID: TAutoIncField;
    aqServicesSrvName: TStringField;
    aqServicesSrvDesc: TStringField;
    aqServicesSrvActive: TBooleanField;
    aqServicesOnChange: TMemoField;
    aqServicesOnNewRecord: TMemoField;
    aqServicesOnCalcFields: TMemoField;
    aqServicesOnParamChange: TMemoField;
    aqServicesOnSetPrices: TMemoField;
    aqServicesOnCheck: TMemoField;
    cdSrvStructPredefined: TBooleanField;
    cdOldSrvStructPredefined: TBooleanField;
    cdSrvStructID: TIntegerField;
    cdOldSrvStructID: TIntegerField;
    cdSrvStructFieldStatus: TIntegerField;
    cdOldSrvStructFieldStatus: TIntegerField;
    dsParams: TDataSource;
    aqServicesAssignCalcFields: TBooleanField;
    aqServicesAssignDataChange: TBooleanField;
    aqServicesAssignNewRecord: TBooleanField;
    aqServicesServiceKind: TIntegerField;
    aqServicesStoreSettings: TBooleanField;
    aqServicesOnlyWorkOrder: TBooleanField;
    aqServicesShowInReport: TBooleanField;
    cdServicesAssignCalcFields: TBooleanField;
    cdServicesAssignDataChange: TBooleanField;
    cdServicesAssignNewRecord: TBooleanField;
    cdServicesServiceKind: TIntegerField;
    cdServicesStoreSettings: TBooleanField;
    cdServicesOnlyWorkOrder: TBooleanField;
    cdServicesShowInReport: TBooleanField;
    aqSrvGrpsGrpID: TAutoIncField;
    aqSrvGrpsGrpNumber: TIntegerField;
    aqSrvGrpsGrpDesc: TStringField;
    aqParamsParamID: TAutoIncField;
    aqParamsParName: TStringField;
    aqParamsParDesc: TStringField;
    aqSrvGridColsColID: TAutoIncField;
    aqSrvGridColsSrvID: TIntegerField;
    aqSrvGridColsColNumber: TIntegerField;
    aqSrvGridColsAlignment: TIntegerField;
    aqSrvGridColsColor: TIntegerField;
    aqSrvGridColsFieldName: TStringField;
    aqSrvGridColsReadOnly: TBooleanField;
    aqSrvGridColsCaption: TStringField;
    aqSrvGridColsCaptionAlignment: TIntegerField;
    aqSrvGridColsCaptionColor: TIntegerField;
    aqSrvGridColsFontColor: TIntegerField;
    aqSrvGridColsCaptionFontColor: TIntegerField;
    dsSrvGridCols: TDataSource;
    dsSrvFieldInfo: TDataSource;
    aqSrvGridColsFontBold: TBooleanField;
    aqSrvGridColsFontItalic: TBooleanField;
    aqSrvGridColsCaptionFontBold: TBooleanField;
    aqSrvGridColsCaptionFontItalic: TBooleanField;
    cdSrvGridColsFontBold: TBooleanField;
    cdSrvGridColsFontItalic: TBooleanField;
    cdSrvGridColsCaptionFontBold: TBooleanField;
    cdSrvGridColsCaptionFontItalic: TBooleanField;
    aspDelSrv: TADOStoredProc;
    aqPageGrids: TADOQuery;
    pvPageGrids: TDataSetProvider;
    dsPageGrids: TDataSource;
    cdPageGrids: TClientDataSet;
    aqSrvFieldInfoSrvFieldID: TIntegerField;
    aqSrvFieldInfoSrvID: TIntegerField;
    aqSrvFieldInfoFieldType: TIntegerField;
    aqSrvFieldInfoLength: TIntegerField;
    aqSrvFieldInfoPrecision: TIntegerField;
    aqSrvFieldInfoFieldStatus: TIntegerField;
    aqSrvFieldInfoMinValue: TIntegerField;
    aqSrvFieldInfoMaxValue: TIntegerField;
    aqSrvFieldInfoFieldName: TStringField;
    aqSrvFieldInfoFieldDesc: TStringField;
    aqSrvFieldInfoEditFormat: TStringField;
    aqSrvFieldInfoDisplayFormat: TStringField;
    cdPageGridsSrvID: TAutoIncField;
    cdPageGridsSrvDesc: TStringField;
    cdPageGridsGrpOrderNum: TIntegerField;
    aqSrvGridColsVisible: TBooleanField;
    cdSrvGridColsVisible: TBooleanField;
    aqSrvGridColsProtected: TBooleanField;
    cdSrvGridColsProtected: TBooleanField;
    aqServicesNotForCopy: TBooleanField;
    cdServicesNotForCopy: TBooleanField;
    aqSrvFieldInfoNotForCopy: TBooleanField;
    cdSrvFieldInfoNotForCopy: TBooleanField;
    cdSrvStructNotForCopy: TBooleanField;
    cdOldSrvStructNotForCopy: TBooleanField;
    aqServicesOnGetText: TMemoField;
    cdServicesOnGetText: TMemoField;
    aqSrvFieldInfoCustomGetText: TBooleanField;
    cdSrvFieldInfoCustomGetText: TBooleanField;
    cdSrvStructCustomGetText: TBooleanField;
    cdOldSrvStructCustomGetText: TBooleanField;
    aqServicesBeforeInsert: TMemoField;
    aqServicesAssignBeforeInsert: TBooleanField;
    cdServicesBeforeInsert: TMemoField;
    cdServicesAssignBeforeInsert: TBooleanField;
    dsSrvPages: TDataSource;
    cdSrvPages: TClientDataSet;
    aqSrvPages: TADOQuery;
    pvSrvPages: TDataSetProvider;
    aqSrvPagesSrvPageID: TAutoIncField;
    aqSrvPagesPageCaption: TStringField;
    aqSrvPagesGrpID: TIntegerField;
    aqSrvPagesGrpOrderNum: TIntegerField;
    aqSrvPagesPageBuiltIn: TBooleanField;
    aqSrvPagesCreateFrameOnShow: TBooleanField;
    cdSrvPagesSrvPageID: TAutoIncField;
    cdSrvPagesPageCaption: TStringField;
    cdSrvPagesGrpID: TIntegerField;
    cdSrvPagesGrpOrderNum: TIntegerField;
    cdSrvPagesPageBuiltIn: TBooleanField;
    cdSrvPagesCreateFrameOnShow: TBooleanField;
    aqSrvPagesGrpNumber: TIntegerField;
    cdSrvPagesGrpNumber: TIntegerField;
    cdSrvPagesOnCreateFrame: TMemoField;
    cdSrvPagesEnableOnCreateFrame: TBooleanField;
    aqSrvPagesOnCreateFrame: TMemoField;
    aqSrvPagesEnableOnCreateFrame: TBooleanField;
    aspNewSrvGrp: TADOStoredProc;
    aspDelSrvGrp: TADOStoredProc;
    cdPageGridsSrvPageID: TIntegerField;
    aqPageGridsSrvID: TAutoIncField;
    aqPageGridsSrvDesc: TStringField;
    aqPageGridsPageOrderNum: TIntegerField;
    aqPageGridsSrvPageID: TIntegerField;
    aqServicesBaseSrvID: TIntegerField;
    cdServicesBaseSrvID: TIntegerField;
    aqServicesAfterOpen: TMemoField;
    aqServicesEnableAfterOpen: TBooleanField;
    cdServicesAfterOpen: TMemoField;
    cdServicesEnableAfterOpen: TBooleanField;
    aqSrvPagesEmptyFrame: TBooleanField;
    cdSrvPagesEmptyFrame: TBooleanField;
    aqServicesEnablePlanning: TBooleanField;
    cdServicesEnablePlanning: TBooleanField;
    aqServicesEnableTracking: TBooleanField;
    cdServicesEnableTracking: TBooleanField;
    aqSrvGridColsShowEditButton: TBooleanField;
    cdSrvGridColsShowEditButton: TBooleanField;
    dsProcessGrids: TDataSource;
    cdProcessGrids: TClientDataSet;
    aqProcessGrids: TADOQuery;
    pvProcessGrids: TDataSetProvider;
    aqProcessGridsGridID: TAutoIncField;
    aqProcessGridsProcessID: TIntegerField;
    aqProcessGridsProcessPageID: TIntegerField;
    aqProcessGridsPageOrderNum: TIntegerField;
    aqProcessGridsGridName: TStringField;
    aqProcessGridsGridCaption: TStringField;
    aqProcessGridsShowControlPanel: TBooleanField;
    aqProcessGridsAssignDrawCell: TBooleanField;
    aqProcessGridsEditableGrid: TBooleanField;
    aqProcessGridsOnContextPopup: TMemoField;
    aqProcessGridsOnSelectPopup: TMemoField;
    aqProcessGridsOnDrawCell: TMemoField;
    aqProcessGridsGridColor: TIntegerField;
    cdProcessGridsGridID: TAutoIncField;
    cdProcessGridsProcessID: TIntegerField;
    cdProcessGridsProcessPageID: TIntegerField;
    cdProcessGridsPageOrderNum: TIntegerField;
    cdProcessGridsGridName: TStringField;
    cdProcessGridsGridCaption: TStringField;
    cdProcessGridsShowControlPanel: TBooleanField;
    cdProcessGridsAssignDrawCell: TBooleanField;
    cdProcessGridsEditableGrid: TBooleanField;
    cdProcessGridsOnContextPopup: TMemoField;
    cdProcessGridsOnSelectPopup: TMemoField;
    cdProcessGridsOnDrawCell: TMemoField;
    cdProcessGridsGridColor: TIntegerField;
    cdProcessGridsAssignGridEnter: TBooleanField;
    aqProcessGridsAssignGridEnter: TBooleanField;
    cdSrvFieldInfoCalcTotal: TBooleanField;
    aqSrvFieldInfoCalcTotal: TBooleanField;
    aqProcessGridsTotalFieldName: TStringField;
    cdProcessGridsTotalFieldName: TStringField;
    aqProcessGridsOnGridEnter: TMemoField;
    cdProcessGridsOnGridEnter: TMemoField;
    cdSrvStructCalcTotal: TBooleanField;
    cdOldSrvStructCalcTotal: TBooleanField;
    cdProcessGridsBaseGridID: TIntegerField;
    aqProcessGridsBaseGridID: TIntegerField;
    aqProcessGridsEnableCalcTotalCost: TBooleanField;
    aqProcessGridsOnCalcTotal: TMemoField;
    cdProcessGridsOnCalcTotal: TMemoField;
    cdProcessGridsEnableCalcTotalCost: TBooleanField;
    aqPageGridsGridCaption: TStringField;
    cdPageGridsGridCaption: TStringField;
    aqOrderKind: TADOQuery;
    aqKindProcess: TADOQuery;
    aqKindProcessKindProcessID: TAutoIncField;
    aqKindProcessKindID: TIntegerField;
    aqKindProcessAutoAddDraft: TBooleanField;
    aqKindProcessAutoAddWork: TBooleanField;
    cdKindProcess: TClientDataSet;
    cdOrderKind: TClientDataSet;
    dsOrderKind: TDataSource;
    pvOrderKind: TDataSetProvider;
    cdOrderKindKindID: TAutoIncField;
    cdOrderKindKindDesc: TStringField;
    cdKindProcessKindProcessID: TAutoIncField;
    cdKindProcessKindID: TIntegerField;
    cdKindProcessAutoAddDraft: TBooleanField;
    cdKindProcessAutoAddWork: TBooleanField;
    dsKindProcess: TDataSource;
    cdKindProcessProcessName: TStringField;
    aqOrderKindKindID: TAutoIncField;
    aqOrderKindKindDesc: TStringField;
    aqKindProcessProcessID: TIntegerField;
    cdKindProcessProcessID: TIntegerField;
    pvKindProcess: TDataSetProvider;
    aqServicesShowInProfit: TBooleanField;
    aqServicesUseInTotal: TBooleanField;
    cdServicesUseInTotal: TBooleanField;
    cdServicesShowInProfit: TBooleanField;
    aqServicesOnItemParams: TMemoField;
    cdServicesOnItemParams: TMemoField;
    aqServicesHideItem: TBooleanField;
    cdServicesHideItem: TBooleanField;
    aqKindPages: TADOQuery;
    dsKindPages: TDataSource;
    cdKindPages: TClientDataSet;
    pvKindPages: TDataSetProvider;
    aqServicesUseInProfitMode: TIntegerField;
    cdServicesUseInProfitMode: TIntegerField;
    aqSrvGridColsCostColumn: TBooleanField;
    cdSrvGridColsCostColumn: TBooleanField;
    aqKindProcessProcessName1: TStringField;
    cdKindProcessProcessName1: TStringField;
    aqProcessGridsTotalWorkFieldName: TStringField;
    aqProcessGridsTotalMatFieldName: TStringField;
    cdProcessGridsTotalWorkFieldName: TStringField;
    cdProcessGridsTotalMatFieldName: TStringField;
    aqServicesEnableBeforeScroll: TBooleanField;
    aqServicesEnableAfterScroll: TBooleanField;
    cdServicesEnableBeforeScroll: TBooleanField;
    cdServicesEnableAfterScroll: TBooleanField;
    cdServicesBeforeScroll: TMemoField;
    cdServicesAfterScroll: TMemoField;
    aqServicesBeforeScroll: TMemoField;
    aqServicesAfterScroll: TMemoField;
    aqServicesEnableAfterOrderOpen: TBooleanField;
    aqServicesAfterOrderOpen: TMemoField;
    cdServicesAfterOrderOpen: TMemoField;
    cdServicesEnableAfterOrderOpen: TBooleanField;
    aqSrvFieldInfoLookupDicID: TIntegerField;
    cdSrvFieldInfoLookupDicID: TIntegerField;
    cdSrvStructLookupDicID: TIntegerField;
    cdOldSrvStructLookupDicID: TIntegerField;
    aqSrvFieldInfoLookupKeyField: TStringField;
    cdSrvFieldInfoLookupKeyField: TStringField;
    cdSrvStructLookupKeyField: TStringField;
    cdOldSrvStructLookupKeyField: TStringField;
    cdServicesIsContent: TBooleanField;
    aqServicesIsContent: TBooleanField;
    aqServicesOnCreateNotPlanned: TMemoField;
    aqServicesOnCreateDayPlan: TMemoField;
    aqServicesOnNotPlannedCalcFields: TMemoField;
    aqServicesDefaultEquipGroupCode: TIntegerField;
    cdServicesDefaultEquipGroupCode: TIntegerField;
    cdServicesOnCreateNotPlanned: TMemoField;
    cdServicesOnCreateDayPlan: TMemoField;
    cdServicesOnNotPlannedCalcFields: TMemoField;
    aqServicesOnDayPlanCalcFields: TMemoField;
    aqServicesOnGetDayPlanSQL: TMemoField;
    aqServicesOnGetNotPlannedSQL: TMemoField;
    cdServicesOnGetNotPlannedSQL: TMemoField;
    cdServicesOnGetDayPlanSQL: TMemoField;
    cdServicesOnCreateNotPlannedColumns: TMemoField;
    cdServicesOnCreateDayPlanColumns: TMemoField;
    aqServicesOnCreateNotPlannedColumns: TMemoField;
    aqServicesOnCreateDayPlanColumns: TMemoField;
    cdServicesOnDayPlanCalcFields: TMemoField;
    cdOrderKindMainProcessID: TIntegerField;
    aqOrderKindMainProcessID: TIntegerField;
    cdServicesOnCreateProduction: TMemoField;
    cdServicesOnGetProductionSQL: TMemoField;
    cdServicesOnCreateProductionColumns: TMemoField;
    aqServicesOnCreateProduction: TMemoField;
    aqServicesOnGetProductionSQL: TMemoField;
    aqServicesOnCreateProductionColumns: TMemoField;
    cdServicesOnProductionCalcFields: TMemoField;
    aqServicesOnProductionCalcFields: TMemoField;
    cdServicesOnEstimateDuration: TMemoField;
    aqServicesOnEstimateDuration: TMemoField;
    cdServicesLinkedProcessID: TIntegerField;
    aqServicesLinkedProcessID: TIntegerField;
    cdSrvFieldInfoIsCost: TBooleanField;
    aqSrvFieldInfoIsCost: TBooleanField;
    cdSrvStructIsCost: TBooleanField;
    cdOldSrvStructIsCost: TBooleanField;
    cdServicesSequenceOrder: TIntegerField;
    aqServicesSequenceOrder: TIntegerField;
    aqServicesEnableBeforeDelete: TBooleanField;
    aqServicesBeforeDelete: TMemoField;
    cdServicesEnableBeforeDelete: TBooleanField;
    cdServicesBeforeDelete: TMemoField;
    dsPlan: TDataSource;
    pvPlan: TDataSetProvider;
    cdPlan: TClientDataSet;
    aqPlan: TADOQuery;
    cdServicesEnableLinking: TBooleanField;
    aqServicesEnableLinking: TBooleanField;
    aqServicesDefaultContractorProcess: TBooleanField;
    cdServicesDefaultContractorProcess: TBooleanField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure StructNewRecord(DataSet: TDataSet);
    procedure SrvFieldTypeChange(Sender: TField);
    //procedure SrvStructBeforeInsert(DataSet: TDataSet);
    procedure SrvStructBeforeDelete(DataSet: TDataSet);
    function CalcSrvFieldName(DataSet: TDataSet): string;
    procedure pvSrvStructBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
      var Applied: Boolean);
    procedure cdSrvGrpsNewRecord(DataSet: TDataSet);
    procedure cdSrvGrpsBeforeInsert(DataSet: TDataSet);
    procedure pvSrvGrpsBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
      UpdateKind: TUpdateKind; var Applied: Boolean);
    procedure pvOrderKindBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
      UpdateKind: TUpdateKind; var Applied: Boolean);
    procedure cdKindProcessNewRecord(DataSet: TDataSet);
    procedure pvKindProcessBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
      UpdateKind: TUpdateKind; var Applied: Boolean);
  private
    //FCurSrvName: string; // используется временно для работы со структурой таблиц
    //FCurSrvID: integer;  // используется временно для работы со структурой таблиц
    //FCurBaseSrvID: integer;  // убрать !!!!!!!!!!!
    //FStructFName: string; // используется временно для работы со структурой таблиц
    FScriptInfo: TStringList;
    FNewGrpNumber: integer; // временно используется при добавлении новой группы
    ProcessCfgChangedID: TNotifyHandlerID;
    function GetScriptInfo: TStringList;
    procedure OpenSrvFieldInfo;
    procedure RefreshProcessCfg(Sender: TObject);
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure InitProcesses;
    procedure DoneProcesses;
    function OpenServices: boolean;
    procedure CloseServices;
    procedure RefreshServices;
    procedure RefreshSrvGridCols;
    procedure CloseSrvGridCols;
    function RefreshParams: boolean;
    procedure CloseParams;
    function RefreshSrvGroups: boolean;
    procedure CloseSrvGroups;
    procedure ClosePageGrids;
    procedure RefreshPageGrids;
    procedure CloseSrvPages;
    procedure RefreshSrvPages;
    procedure ReadScriptInfo;
    procedure ClearScriptInfo;
    procedure RefreshProcessGrids;
    procedure CloseProcessGrids;
    function RefreshOrderKind: boolean;
    procedure CloseOrderKind;
    function RefreshKindProcess: boolean;
    procedure CloseKindProcess;
    function CheckSrvName(const SrvName: string): boolean;
    function CreateSrvStructData(var StructData: TClientDataSet; SrvCfg: TPolyProcessCfg;
      UseOld, NewMode: boolean): boolean;
      // - этот параметр не должен передаваться АППСЕРВЕРУ клиентом,
    //function CreateProcessTable(StructData: TClientDataSet): integer;
    function ApplyProcessCfg: boolean;
    procedure CancelProcessCfg;
    function GetScriptDesc(const FieldName: string): string;
    //function ApplyProcessStructCreate(StructData: TClientDataSet): boolean;
    function PrepareOpenServiceData(Srv: TPolyProcess;
      NewData, Calc: boolean; OrderID: integer): boolean;
    procedure ModifySrvTable(SrvCfg: TPolyProcessCfg; StructData: TClientDataSet);
    function ApplySrvStructChange(StructData: TClientDataSet; SrvCfg: TPolyProcessCfg): boolean;
    procedure SetCurPage(SrvPageID: integer);
    procedure SetCurGrp(GrpID: integer);
    procedure SetCurKind(KindID: integer);
    procedure SetCurProcess(ProcessID: integer);
    procedure OpenKindPageInfo(KindID: integer; IsDraft: boolean);
    procedure CloseKindPageInfo;
    function GetKindProcessArray(KindID: integer): TIntArray;
    property ScriptInfo: TStringList read GetScriptInfo;
    procedure OpenDataSet(DataSet: TDataSet);
    // создает триггеры изменения полей для таблицы указанного процесса
    procedure CreateProcessTriggers(ProcessID: integer);
  end;

var
  sdm: Tsdm;
  NewGrpID: integer;

implementation

uses MainData, ServMod, RDialogs, DataHlp, DicData, ExHandler,
  RDBUtils, JvJCLUtils, ADOUtils, PmAccessManager, PmConfigManager,
  PmOrderProcessItems, TLoggerUnit;

{$R *.DFM}

constructor Tsdm.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  ProcessCfgChangedID := TConfigManager.Instance.BeforeProcessCfgChange.RegisterHandler(RefreshProcessCfg);
end;

destructor Tsdm.Destroy;
begin
  // TODO: убрал, т.к. синглетон уже не существет
  //TConfigManager.Instance.ProcessCfgChanged.UnRegisterHandler(ProcessCfgChangedID);
  inherited;
end;

function Tsdm.OpenServices: boolean;
begin
  Result := false;
  try
    OpenDataSet(cdServices);
    OpenDataSet(cdSrvFieldInfo);
    Result := true;
  except
    on E: Exception do begin
      ExceptionHandler.Raise_(E, 'Не могу открыть таблицу процессов', 'OpenServices');
    end;
  end;
end;

procedure Tsdm.CloseServices;
begin
  if cdSrvFieldInfo.Active then cdSrvFieldInfo.Close;
  if cdServices.Active then cdServices.Close;
end;

procedure Tsdm.RefreshServices;
begin
  CloseServices;
  OpenServices;
end;

procedure Tsdm.OpenSrvFieldInfo;
begin
  OpenDataSet(cdSrvFieldInfo);
end;

procedure Tsdm.RefreshSrvGridCols;
begin
  CloseSrvGridCols;
  OpenDataSet(cdSrvGridCols);
end;

procedure Tsdm.CloseSrvGridCols;
begin
  cdSrvGridCols.Close;
end;

procedure Tsdm.ClosePageGrids;
begin
  cdPageGrids.Close;
end;

procedure Tsdm.RefreshPageGrids;
begin
  ClosePageGrids;
  OpenDataSet(cdPageGrids);
end;

procedure Tsdm.CloseSrvPages;
begin
  cdSrvPages.Close;
end;

procedure Tsdm.RefreshSrvPages;
begin
  CloseSrvPages;
  OpenDataSet(cdSrvPages);
end;

procedure Tsdm.CloseProcessGrids;
begin
  cdProcessGrids.Close;
end;

procedure Tsdm.RefreshProcessGrids;
begin
  CloseProcessGrids;
  OpenDataSet(cdProcessGrids);
end;

procedure Tsdm.CloseOrderKind;
begin
  cdOrderKind.Close;
end;

function Tsdm.RefreshOrderKind: boolean;
begin
  Result := false;
  CloseOrderKind;
  try
    OpenDataSet(cdOrderKind);
    Result := true;
  except
    on E: Exception do begin
      ExceptionHandler.Raise_(E, 'Не могу открыть таблицу видов процессов', 'OpenOrderKind');
    end;
  end;
end;

procedure Tsdm.CloseKindProcess;
begin
  cdKindProcess.Close;
end;

function Tsdm.RefreshKindProcess: boolean;
begin
  Result := false;
  CloseKindProcess;
  try
    OpenDataSet(cdKindProcess);
    Result := true;
  except
    on E: Exception do begin
      ExceptionHandler.Raise_(E, 'Не могу открыть таблицу видов процессов', 'OpenKindProcess');
    end;
  end;
end;

procedure Tsdm.InitProcesses;
begin
  RefreshServices;
  RefreshSrvGridCols;
  RefreshProcessGrids;
  RefreshParams;
  RefreshOrderKind;
  ReadScriptInfo;

  RefreshSrvGroups;  // добавлено из refrehprocesscfg 28.10.2008 в рамках глобального рефакторинга
  RefreshSrvPages;
end;

procedure Tsdm.DoneProcesses;
begin
  CloseOrderKind;
  CloseServices;
  CloseParams;
  ClearScriptInfo;
end;

function Tsdm.RefreshParams: boolean;
begin
  Result := false;
  try
    OpenDataSet(cdParams);
    Result := true;
  except
    on E: Exception do begin
      ExceptionHandler.Raise_(E, 'Не могу открыть список параметров заказа', 'OpenParams');
    end;
  end;
end;

procedure Tsdm.CloseParams;
begin
  if cdParams.Active then cdParams.Close;
end;

function Tsdm.RefreshSrvGroups: boolean;
begin
  CloseSrvGroups;
  try
    OpenDataSet(cdSrvGrps);
    Result := true;
  except
    Result := false;
  end;
end;

procedure Tsdm.CloseSrvGroups;
begin
  sdm.cdSrvGrps.Close;
end;

procedure Tsdm.ClearScriptInfo;
var
  i: integer;
begin
  if Assigned(FScriptInfo) then begin
    if FScriptInfo.Count > 0 then
      for i := 0 to Pred(FScriptInfo.Count) do
        (FScriptInfo.Objects[i] as TObject).Free;
    FScriptInfo.Clear;
  end;
end;

// APPSERVER !!!!!!!!!!!!!!!!!!!!!!!!
procedure Tsdm.ReadScriptInfo;
var
  aq: TADOQuery;
begin
  aq := TADOQuery.Create(nil);
  try
    aq.Connection := aqServices.Connection;
    aq.SQL.Add('select SSI_ID, FieldName, FieldDesc, HiddenScript from SrvScriptInfo where HiddenScript = 0');
    try
      aq.Open;
      ClearScriptInfo;
      while not aq.eof do begin
        FScriptInfo.AddObject(NvlString(aq['FieldName']),
          TFieldDesc.Create(NvlString(aq['FieldDesc']), 0));
        aq.Next;
      end;
      aq.Close;
    except
      on E: Exception do
        ExceptionHandler.Raise_(E, 'Не могу открыть таблицу информации о сценариях');
    end;
  finally
    aq.Free;
  end;
end;

function Tsdm.GetScriptDesc(const FieldName: string): string;
var i: integer;
begin
  i := FScriptInfo.IndexOf(FieldName);
  if i <> -1 then
    Result := (FScriptInfo.Objects[i] as TFieldDesc).FieldDesc
  else
    Result := '';
end;

function Tsdm.GetScriptInfo: TStringList;
begin
  Result := FScriptInfo;
end;

procedure Tsdm.DataModuleCreate(Sender: TObject);
begin
  FScriptInfo := TStringList.Create;
  //sm.Prepare;
  //dm.NotifyProcessCfgRefresh;
end;

procedure Tsdm.DataModuleDestroy(Sender: TObject);
begin
  DoneProcesses;
  FreeAndNil(FScriptInfo);
end;

procedure Tsdm.StructNewRecord(DataSet: TDataSet);
begin
  DataSet['FieldType'] := Ord(ftInteger);
  DataSet['FieldDesc'] := '';
  DataSet['DisplayFormat'] := '';
  DataSet['EditFormat'] := '';
  DataSet['Predefined'] := false;
  DataSet['FieldStatus'] := ftData;
  DataSet['NotForCopy'] := false;
  DataSet['CustomGetText'] := false;
  DataSet['CalcTotal'] := false;
  DataSet['IsCost'] := false;
  //DataSet['AddToGrandTotal'] := false;  // 31.12.2004
  //DataSet['AddToProfit'] := false;
  DataSet[StructKeyField] := DataSet.Tag;  // IDENTITY
  DataSet.Tag := DataSet.Tag + 1;  // Наращиваем Identity
end;

procedure Tsdm.SrvFieldTypeChange(Sender: TField);
begin
  FieldTypeChanged(Sender);
end;

// APPSERVER!!!!!!!!!!!!!!!
function Tsdm.CheckSrvName(const SrvName: string): boolean;
var
  aq: TADOQuery;
begin
  aq := TADOQuery.Create(nil);
  try
    aq.Connection := aqServices.Connection;
    aq.SQL.Add('select SrvID from Services where SrvName = ''' + SrvName + '''');
    aq.Open;
    Result := aq.IsEmpty;
    if not Result then
      RusMessageDlg('Процесс с именем "' + SrvName + '" уже существует', mtError, [mbOk], 0);
    aq.Close;
  finally
    aq.Free;
  end;
end;

{procedure Tsdm.SrvStructBeforeInsert(DataSet: TDataSet);
begin
  FStructFName := CalcSrvFieldName(DataSet as TDataSet);
end;}

procedure Tsdm.SrvStructBeforeDelete(DataSet: TDataSet);
begin
  if not VarIsNull(DataSet['FieldName']) and (DataSet['Predefined']) then Abort;
end;

// Вычисляет имя следующего поля при добавлении поля в структуру справочника
function TSDM.CalcSrvFieldName(DataSet: TDataSet): string;
begin
  Result := CalcNewFieldName(DataSet, SrvValueField);
end;

// Создает набор данных, описывающий структуру процесса
function Tsdm.CreateSrvStructData(var StructData: TClientDataSet; SrvCfg: TPolyProcessCfg;
  UseOld, NewMode: boolean): boolean;

  function Predefined(fname: string): boolean;
  begin
    Result := IsWordPresent(AnsiUpperCase(fname),
                            AnsiUpperCase(ProcessPredefFieldsStr + ',' + ProcessPredefVirtualFieldsStr),
                            [',']);
  end;

var
  i: integer;
begin
  Result := false;
  try
    if UseOld then StructData := cdOldSrvStruct else StructData := cdSrvStruct;
    if StructData.Active then StructData.Close;
    with StructData do begin
      CreateDataSet;
      Append;
      FieldByName('ID').Value := 1;
      FieldByName('FieldName').Value := F_ProcessKey;
      FieldByName('FieldDesc').Value := 'Ид. записи';
      FieldByName('FieldType').Value := Ord(ftInteger);
      FieldByName('Predefined').Value := true;
      FieldByName('NotForCopy').Value := true;
      FieldByName('FieldStatus').Value := ftIndependent;
      FieldByName('CalcTotal').Value := false;
      Append;
      FieldByName('ID').Value := 2;
      FieldByName('FieldName').Value := F_ItemID;
      FieldByName('FieldDesc').Value := 'Ид. записи элемента';
      FieldByName('FieldType').Value := Ord(ftInteger);
      FieldByName('Predefined').Value := true;
      FieldByName('NotForCopy').Value := true;
      FieldByName('FieldStatus').Value := ftIndependent;
      FieldByName('CalcTotal').Value := false;
      Append;
      FieldByName('ID').Value := 3;
      FieldByName('FieldName').Value := TOrderProcessItems.F_Cost;
      FieldByName('FieldDesc').Value := 'Стоимость строки';
      FieldByName('FieldType').Value := Ord(ftBCD);
      FieldByName('Predefined').Value := true;
      FieldByName('FieldStatus').Value := ftVirtual;
      FieldByName('DisplayFormat').Value := CalcUtils.NumDisplayFmt;
      FieldByName('NotForCopy').Value := true;
      FieldByName('CalcTotal').Value := false;
      FieldByName('IsCost').Value := true;
      Append;
      FieldByName('ID').Value := 4;
      FieldByName('FieldName').Value := TOrderProcessItems.F_PlanStart;
      FieldByName('FieldDesc').Value := 'План. начало процесса';
      FieldByName('FieldType').Value := Ord(ftDateTime);
      FieldByName('Predefined').Value := true;
      FieldByName('DisplayFormat').Value := CalcUtils.StdDateFmt;
      FieldByName('NotForCopy').Value := true;
      FieldByName('CalcTotal').Value := false;
      FieldByName('FieldStatus').Value := ftVirtual;
      Append;
      FieldByName('ID').Value := 5;
      FieldByName('FieldName').Value := TOrderProcessItems.F_PlanFinish;
      FieldByName('FieldDesc').Value := 'План. завершение процесса';
      FieldByName('FieldType').Value := Ord(ftDateTime);
      FieldByName('Predefined').Value := true;
      FieldByName('DisplayFormat').Value := CalcUtils.StdDateFmt;
      FieldByName('NotForCopy').Value := true;
      FieldByName('CalcTotal').Value := false;
      FieldByName('FieldStatus').Value := ftVirtual;
      Append;
      FieldByName('ID').Value := 6;
      FieldByName('FieldName').Value := TOrderProcessItems.F_FactStart;
      FieldByName('FieldDesc').Value := 'Факт. начало процесса';
      FieldByName('FieldType').Value := Ord(ftDateTime);
      FieldByName('Predefined').Value := true;
      FieldByName('DisplayFormat').Value := StdDateFmt;
      FieldByName('NotForCopy').Value := true;
      FieldByName('CalcTotal').Value := false;
      FieldByName('FieldStatus').Value := ftVirtual;
      Append;
      FieldByName('ID').Value := 7;
      FieldByName('FieldName').Value := TOrderProcessItems.F_FactFinish;
      FieldByName('FieldDesc').Value := 'Факт. завершение процесса';
      FieldByName('FieldType').Value := Ord(ftDateTime);
      FieldByName('Predefined').Value := true;
      FieldByName('DisplayFormat').Value := StdDateFmt;
      FieldByName('NotForCopy').Value := true;
      FieldByName('CalcTotal').Value := false;
      FieldByName('FieldStatus').Value := ftVirtual;
      Append;
      FieldByName('ID').Value := 8;
      FieldByName('FieldName').Value := TOrderProcessItems.F_Enabled;
      FieldByName('FieldDesc').Value := 'Включено';
      FieldByName('FieldType').Value := Ord(ftBoolean);
      FieldByName('Predefined').Value := true;
      FieldByName('NotForCopy').Value := false;
      FieldByName('CalcTotal').Value := false;
      FieldByName('FieldStatus').Value := ftVirtual;
      Append;
      FieldByName('ID').Value := 9;
      FieldByName('FieldName').Value := F_EnabledCost;
      FieldByName('FieldDesc').Value := 'Стоимость вкл.';
      FieldByName('FieldType').Value := Ord(ftBCD);
      FieldByName('Predefined').Value := true;
      FieldByName('DisplayFormat').Value := CalcUtils.NumDisplayFmt;
      FieldByName('NotForCopy').Value := true;
      FieldByName('FieldStatus').Value := ftVirtual;
      FieldByName('CalcTotal').Value := true;
      Append;
      FieldByName('ID').Value := 10;
      FieldByName('FieldName').Value := F_EnabledInt;
      FieldByName('FieldDesc').Value := 'Счетчик вкл.';
      FieldByName('FieldType').Value := Ord(ftInteger);
      FieldByName('Predefined').Value := true;
      FieldByName('NotForCopy').Value := true;
      FieldByName('FieldStatus').Value := ftVirtual;
      FieldByName('CalcTotal').Value := true;
      Append;                                          // 17.01.2005
      FieldByName('ID').Value := 11;
      FieldByName('FieldName').Value := F_Part;
      FieldByName('FieldDesc').Value := 'Часть';
      FieldByName('FieldType').Value := Ord(ftInteger);
      FieldByName('Predefined').Value := true;
      FieldByName('NotForCopy').Value := true;
      FieldByName('FieldStatus').Value := ftVirtual;
      FieldByName('CalcTotal').Value := false;
      Append;                                          // 17.01.2005
      FieldByName('ID').Value := 12;
      FieldByName('FieldName').Value := TOrderProcessItems.F_EquipCode;
      FieldByName('FieldDesc').Value := 'Код оборудования';
      FieldByName('FieldType').Value := Ord(ftInteger);
      FieldByName('Predefined').Value := true;
      FieldByName('NotForCopy').Value := true;
      FieldByName('FieldStatus').Value := ftVirtual;
      FieldByName('CalcTotal').Value := false;
      Append;                                          // 19.06.2005
      FieldByName('ID').Value := 13;
      FieldByName('FieldName').Value := TOrderProcessItems.F_OwnCost;
      FieldByName('FieldDesc').Value := 'Себестоимость строки';
      FieldByName('FieldType').Value := Ord(ftBCD);
      FieldByName('Predefined').Value := true;
      FieldByName('FieldStatus').Value := ftVirtual;
      FieldByName('DisplayFormat').Value := CalcUtils.NumDisplayFmt;
      FieldByName('NotForCopy').Value := true;
      FieldByName('CalcTotal').Value := false;
      FieldByName('IsCost').Value := true;
      Append;                                          // 24.07.2005
      FieldByName('ID').Value := 14;
      FieldByName('FieldName').Value := TOrderProcessItems.F_OwnPercent;
      FieldByName('FieldDesc').Value := 'Процент наценки на себестоимость';
      FieldByName('FieldType').Value := Ord(ftBCD);
      FieldByName('Predefined').Value := true;
      FieldByName('FieldStatus').Value := ftVirtual;
      //FieldByName('DisplayFormat').Value := '#,###,##0.00';
      FieldByName('NotForCopy').Value := true;
      FieldByName('CalcTotal').Value := false;
      FieldByName('IsCost').Value := true;
      Append;                                          // 19.06.2005
      FieldByName('ID').Value := 15;
      FieldByName('FieldName').Value := TOrderProcessItems.F_ContractorPercent;
      FieldByName('FieldDesc').Value := 'Процент наценки на субподряд';
      FieldByName('FieldType').Value := Ord(ftBCD);
      FieldByName('Predefined').Value := true;
      FieldByName('FieldStatus').Value := ftVirtual;
      //FieldByName('DisplayFormat').Value := '#,###,##0.00';
      FieldByName('NotForCopy').Value := true;
      FieldByName('CalcTotal').Value := false;
      FieldByName('IsCost').Value := true;
      Append;                                          // 19.06.2005
      FieldByName('ID').Value := 16;
      FieldByName('FieldName').Value := TOrderProcessItems.F_ContractorProcess;
      FieldByName('FieldDesc').Value := 'Процесс субподрядчика';
      FieldByName('FieldType').Value := Ord(ftBoolean);
      FieldByName('Predefined').Value := true;
      FieldByName('NotForCopy').Value := false;
      FieldByName('CalcTotal').Value := false;
      FieldByName('FieldStatus').Value := ftVirtual;
      Append;                                          // 24.06.2005
      FieldByName('ID').Value := 17;
      FieldByName('FieldName').Value := TOrderProcessItems.F_ContractorCost;
      FieldByName('FieldDesc').Value := 'Стоимость субподряда';
      FieldByName('FieldType').Value := Ord(ftBCD);
      FieldByName('Predefined').Value := true;
      FieldByName('FieldStatus').Value := ftVirtual;
      FieldByName('DisplayFormat').Value := CalcUtils.NumDisplayFmt;
      FieldByName('NotForCopy').Value := true;
      FieldByName('CalcTotal').Value := false;
      FieldByName('IsCost').Value := true;
      Append;                                          // 24.06.2005
      FieldByName('ID').Value := 18;
      FieldByName('FieldName').Value := TOrderProcessItems.F_MatCost;
      FieldByName('FieldDesc').Value := 'Стоимость материалов';
      FieldByName('FieldType').Value := Ord(ftBCD);
      FieldByName('Predefined').Value := true;
      FieldByName('FieldStatus').Value := ftVirtual;
      FieldByName('DisplayFormat').Value := CalcUtils.NumDisplayFmt;
      FieldByName('NotForCopy').Value := true;
      FieldByName('CalcTotal').Value := false;
      FieldByName('IsCost').Value := true;
      Append;                                          // 24.06.2005
      FieldByName('ID').Value := 19;
      FieldByName('FieldName').Value := TOrderProcessItems.F_MatPercent;
      FieldByName('FieldDesc').Value := 'Процент наценки на материалы';
      FieldByName('FieldType').Value := Ord(ftBCD);
      FieldByName('Predefined').Value := true;
      FieldByName('FieldStatus').Value := ftVirtual;
      //FieldByName('DisplayFormat').Value := '#,###,##0.00';
      FieldByName('NotForCopy').Value := true;
      FieldByName('CalcTotal').Value := false;
      FieldByName('IsCost').Value := true;
      Append;                                          // 18.09.2005
      FieldByName('ID').Value := 20;
      FieldByName('FieldName').Value := TOrderProcessItems.F_EnabledMatCost;
      FieldByName('FieldDesc').Value := 'Стоимость материалов активных';
      FieldByName('FieldType').Value := Ord(ftBCD);
      FieldByName('Predefined').Value := true;
      FieldByName('FieldStatus').Value := ftVirtual;
      FieldByName('DisplayFormat').Value := CalcUtils.NumDisplayFmt;
      FieldByName('NotForCopy').Value := true;
      FieldByName('CalcTotal').Value := true;
      FieldByName('IsCost').Value := true;
      Append;                                          // 18.09.2005
      FieldByName('ID').Value := 21;
      FieldByName('FieldName').Value := TOrderProcessItems.F_EnabledWorkCost;
      FieldByName('FieldDesc').Value := 'Стоимость работ активных';
      FieldByName('FieldType').Value := Ord(ftBCD);
      FieldByName('Predefined').Value := true;
      FieldByName('FieldStatus').Value := ftVirtual;
      FieldByName('DisplayFormat').Value := CalcUtils.NumDisplayFmt;
      FieldByName('NotForCopy').Value := true;
      FieldByName('CalcTotal').Value := true;
      FieldByName('IsCost').Value := true;
      Append;                                          // 18.09.2005
      FieldByName('ID').Value := 22;
      FieldByName('FieldName').Value := TOrderProcessItems.F_LinkedItemID;
      FieldByName('FieldDesc').Value := 'Родительский процесс';
      FieldByName('FieldType').Value := Ord(ftInteger);
      FieldByName('Predefined').Value := true;
      FieldByName('FieldStatus').Value := ftVirtual;
      FieldByName('NotForCopy').Value := true;
      FieldByName('CalcTotal').Value := false;
      FieldByName('IsCost').Value := false;
      if not NewMode then begin  // В режиме редактирования добавляем те поля, которые есть
        SrvCfg.BeginReadFieldInfo;
        i := 0;
        while not cdSrvFieldInfo.eof do
        try
          if Predefined(cdSrvFieldInfo['FieldName']) then continue;
          Append;
          FieldByName(StructKeyField).Value := i + 23;
          Inc(i);
          FieldByName('FieldName').Value := cdSrvFieldInfo['FieldName'];
          FieldByName('FieldDesc').Value := cdSrvFieldInfo['FieldDesc'];
          FieldByName('FieldType').Value := cdSrvFieldInfo['FieldType'];
          try FieldByName('Length').Value := cdSrvFieldInfo['Length']; except end;
          try FieldByName('Precision').Value := cdSrvFieldInfo['Precision']; except end;
          try FieldByName('DisplayFormat').Value := cdSrvFieldInfo['DisplayFormat']; except end;
          try FieldByName('EditFormat').Value := cdSrvFieldInfo['EditFormat']; except end;
          FieldByName('FieldStatus').Value := cdSrvFieldInfo['FieldStatus'];
          FieldByName('NotForCopy').Value := cdSrvFieldInfo['NotForCopy'];
          FieldByName('CustomGetText').Value := cdSrvFieldInfo['CustomGetText'];
          FieldByName('CalcTotal').Value := cdSrvFieldInfo['CalcTotal'];
          FieldByName('LookupDicID').Value := cdSrvFieldInfo['LookupDicID'];
          FieldByName('LookupKeyField').Value := cdSrvFieldInfo['LookupKeyField'];
          FieldByName('IsCost').Value := cdSrvFieldInfo['IsCost'];
        finally
          cdSrvFieldInfo.Next;
        end;
      end;
      CheckBrowseMode;
      StructData.Tag := FieldByName(StructKeyField).Value + 1;
      // Tag выполняет роль IDENTITY для этой таблицы - номер следующего ID.
      Result := true;
    end;
  except on E: Exception do begin
      ExceptionHandler.Raise_(E, 'Не могу создать временную таблицу для конструктора процесса',
        'CreateSrvStructData');
    end;
  end;
end;
{
function Tsdm.ApplyProcessStructCreate(StructData: TClientDataSet): boolean;
begin
  Result := DicDm.CommonApplyStructCreate(SrvTablePrefix + FCurSrvName, SrvFieldsTableName,
    F_SrvID, SrvStructPropFields, FCurSrvID, StructData,
    true); // предопределенные поля тоже пишутся в таблицу описания полей!
end;
}
procedure Tsdm.RefreshProcessCfg(Sender: TObject);
begin
  InitProcesses;
end;

procedure Tsdm.CreateProcessTriggers(ProcessID: integer);
var
  aq, df: TDataSet;
  s, SrvName: string;
  IsFirst: boolean;
begin
  //Database.ExecuteNonQuery('exec up_CreateProcessTriggers ' + IntToStr(ProcessID))
  aq := Database.ExecuteQuery('select SrvID, SrvName from Services where SrvID = ' + IntToStr(ProcessID));
  try
    SrvName := aq['SrvName'];

    // Триггер на UPDATE
    Database.ExecuteNonQuery('IF EXISTS (SELECT name FROM sysobjects WHERE  name = N''TR_Service_' + SrvName + '_Update'' AND type = ''TR'')'#13#10
      + 'DROP TRIGGER TR_Service_' + SrvName + '_Update');
    s := 'CREATE TRIGGER TR_Service_' + SrvName + '_Update ON Service_' + SrvName + ' FOR UPDATE AS BEGIN'#13#10
       + 'declare @N int,@s varchar(4000),@r int,@NV varchar(300),@OV varchar(300)'#13#10
       + 'set @r = @@ROWCOUNT'#13#10
       + 'if SYSTEM_USER <> ''sa'' begin'#13#10
       +   'if @r > 0 begin'#13#10
       +     'select top 1 @n = opi.OrderID from inserted inner join OrderProcessItem opi on opi.ItemID=inserted.ItemID'#13#10
       +     'select @s = SrvDesc from Services where SrvName = ' + QuotedStr(SrvName) + #13#10
       +     'if @r > 1 begin'#13#10
       +       'set @s = @s + ' + QuotedStr(' (') + ' + cast(@r as varchar(5)) + ' + QuotedStr(')') + #13#10
       +       'exec up_HistoryAdd 1, @s, @n'#13#10
       +     'end'#13#10;
    df := Database.ExecuteQuery('select distinct sf.FieldName, ISNULL(ISNULL(NULLIF(FieldDesc, ''''), sgc.Caption), '''') as FieldDesc, FieldType from SrvFields sf'#13#10
      + 'left join ProcessGrids pg on sf.SrvID = pg.ProcessID'#13#10
      + 'left join SrvGridColumns sgc on sf.FieldName = sgc.FieldName and sgc.GridID = pg.GridID'#13#10
      + 'where SrvID = ' + IntToStr(ProcessID) + ' and FieldStatus <> 1 and FieldStatus <> 5 and FieldType <> 15 and sf.FieldName <> ''N'' and sf.FieldName <> ''ItemID''');
    try
      if df.RecordCount > 0 then
      begin
        IsFirst := true;
        while not df.Eof do
        begin
          // на поля без описания не надо генерить триггер
          if Trim(df['FieldDesc']) <> '' then
          begin
            if IsFirst then
            begin
              s := s + 'else begin'#13#10;
              IsFirst := false;
            end;

            if df['FieldType'] = ftMemo then
              s := s + 'if update(' + df['FieldName'] + ') begin'#13#10
               + '  exec up_HistoryAdd 1, ''' + df['FieldDesc'] + ''', @n'#13#10
               + 'end'#13#10
            else
              s := s + 'if update(' + df['FieldName'] + ') begin'#13#10
               + '  select @OV = cast(' + df['FieldName'] + ' as varchar(300)) from deleted'#13#10
               + '  select @NV = cast(' + df['FieldName'] + ' as varchar(300)) from inserted'#13#10
               + '  if @OV <> @NV'#13#10
               + '    exec up_HistAddField 1, @OV, @NV, @s, @n, ''' + df['FieldDesc'] + ''''#13#10
               + 'end'#13#10;
          end;
          df.Next;
        end;
        if not IsFirst then
          s := s + 'end'#13#10;  // не было ни одного поля
      end;
    finally
      df.Free;
    end;
    s := s + 'end end END';
    Database.ExecuteNonQuery(s);

    // Триггер на INSERT
    Database.ExecuteNonQuery('IF EXISTS (SELECT name FROM sysobjects WHERE  name = N''TR_Service_' + SrvName + '_Insert'' AND type = ''TR'')'#13#10
      + 'DROP TRIGGER TR_Service_' + SrvName + '_Insert');
    s := 'CREATE TRIGGER TR_Service_' + SrvName + '_Insert ON Service_' + SrvName + #13#10
      + 'FOR INSERT AS BEGIN'#13#10
      + 'declare @N int, @s varchar(300), @r int'#13#10
      + 'set @r = @@ROWCOUNT'#13#10
      + 'if SYSTEM_USER <> ''sa'' begin'#13#10
      + '  if @r > 0 begin'#13#10
      + '    select top 1 @n = opi.OrderID from inserted inner join OrderProcessItem opi on opi.ItemID = inserted.ItemID'#13#10
      + '    select @s = SrvDesc from Services where SrvName = ''' + SrvName + ''''#13#10
      + '    set @s = @s + '' ('' + cast(@r as varchar(5)) + '')'''#13#10
      + '    exec up_HistoryAdd 2, @s, @n'#13#10
      + '  end'#13#10
      + 'end'#13#10
      + 'END';
    Database.ExecuteNonQuery(s);

  finally
    aq.Free;
  end;
end;

// Создает таблицу в БД для нового сервиса. Вызывает функцию создания компонента,
// функцию создания набора данных и перечитывает таблицу сервисов.
{function Tsdm.CreateProcessTable(StructData: TClientDataSet): integer;

  procedure Alert(E: Exception);
  begin
    if Database.InTransaction then Database.RollbackTrans;
    ExceptionHandler.Raise_(E, 'Ошибка при создании процесса', 'CreateSrvTable');
  end;

begin
  Result := -1;
  if not Database.InTransaction then Database.BeginTrans;
  try
    if cdServices.ApplyUpdates(0) = 0 then
    begin
      if ApplyProcessStructCreate(StructData) then
      begin
        Database.CommitTrans;
        Result := FCurSrvID;
        // сразу присваиваем права на эту таблицу
        if not Database.InTransaction then
        begin
          AccessManager.SetUserRights;
          CreateProcessTriggers(FCurSrvID);
        end;
      end;
    end;
  except on E: Exception do
    Alert(E);
  end;
end;}

function Tsdm.ApplyProcessCfg: boolean;
begin
  //Database.ApplyDataSet(cdServices);
  //Database.ApplyDataSet(cdProcessGrids);
  //Database.ApplyDataSet(cdSrvGridCols);
  Database.ApplyDataSet(cdSrvGrps);
  Database.ApplyDataSet(cdSrvPages);
  Database.ApplyDataSet(cdPageGrids);
  Database.ApplyDataSet(cdParams);
  Database.ApplyDataSet(cdOrderKind);
  Database.ApplyDataSet(cdKindProcess);
end;

procedure Tsdm.CancelProcessCfg;
begin
  //cdServices.CancelUpdates;
  //cdProcessGrids.CancelUpdates;
  //cdSrvGridCols.CancelUpdates;
  if cdSrvGrps.Active then cdSrvGrps.CancelUpdates;
  //if cdSrvPages.Active then cdSrvPages.CancelUpdates;
  if cdPageGrids.Active then cdPageGrids.CancelUpdates;
  if cdOrderKind.Active then cdOrderKind.CancelUpdates;
  if cdKindProcess.Active then cdKindProcess.CancelUpdates;
end;

// APPSERVER
function Tsdm.PrepareOpenServiceData(Srv: TPolyProcess;
  NewData, Calc: boolean; OrderID: integer): boolean;
var
  dq: TADOQuery;
  pv: TDataSetProvider;
const
  { TODO: Если разберусь с проблемой индексов и ключей, то убрать здесь 'order by p.N' }
  SQLServiceEdit = ' from &tabname p inner join OrderProcessItem opi on p.ItemID = opi.ItemID where opi.OrderID = :NN order by p.N';
  SQLServiceNew = ' from &tabname p inner join OrderProcessItem opi on p.ItemID = opi.ItemID where 1=2';

  // формируется полный список всех полей, кроме вычисляемых
  procedure GenServiceSQL;
  var
    i, fs: integer;
    s: string;
  begin
    s := 'select ';
    cdSrvFieldInfo.Filter := F_SrvID + ' = ' + IntToStr(Srv.ProcessCfg.SrvIDForFields);
    cdSrvFieldInfo.Filtered := true;
    cdSrvFieldInfo.First;
    i := 0;
    while not cdSrvFieldInfo.eof do
    try
      // TODO -cCleanup: Эксперимент с ProviderFlags, убрать коммент если ОК
      if (cdSrvFieldInfo['FieldStatus'] <> ftCalculated) and (cdSrvFieldInfo['FieldStatus'] <> ftVirtual) then begin
        if i > 0 then s := s + ',';
        fs := cdSrvFieldInfo['FieldStatus'];
        if fs = ftVirtual then begin                         // фиктивное поле
          (*ts := GetFieldTypeName(cdSrvFieldInfo['FieldType'], 0, 0);
          ts := ExtractWord(1, ts, ['(', ' ', ',']);
          {$IFNDEF Demo}
          s := s + 'V' + ts + ' as "' + cdSrvFieldInfo['FieldName'] + '"';
          {$ELSE}
          s := s + 'V' + ts + ' as ' + cdSrvFieldInfo['FieldName'];
          {$ENDIF}*)
        end else                                               // обычное поле
          if CompareText(F_ItemID, cdSrvFieldInfo['FieldName']) = 0 then
            s := s + 'p.' + F_ItemID
          else
            s := s + '"' + cdSrvFieldInfo['FieldName'] + '"';
      end;
    finally
      cdSrvFieldInfo.Next;
      Inc(i);
    end;
    if NewData then s := s + SQLServiceNew
    else s := s + SQLServiceEdit;
    dq.SQL.Clear;
    dq.SQL.Add(ReplaceStr(s, '&tabname', SrvTablePrefix + Srv.TableName));
  end;

begin
  Result := false;
  pv := Srv.DBProvider;
  if pv = nil then Exit;
  dq := pv.DataSet as TADOQuery;
  GenServiceSQL;
  if not NewData then begin
    if dq.Parameters.FindParam('NN') = nil then
      dq.Parameters.CreateParameter('NN', ftInteger, pdInput, 0, OrderID)
    else
      dq.Parameters.ParamByName('NN').Value := OrderID;
  end;
  Result := true;
end;

// APPSERVER !!!!!!!!!!!!
procedure Tsdm.pvSrvStructBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
  var Applied: Boolean);
begin
  Applied := true;
end;

function Tsdm.ApplySrvStructChange(StructData: TClientDataSet; SrvCfg: TPolyProcessCfg): boolean;
var
  OldStructData: TClientDataSet;
begin
  // Сохраняем старую структуру
  Result := CreateSrvStructData(OldStructData, SrvCfg, true, false);
  if Result then
  try
    Result := DicDm.CommonApplyStructChange(SrvTablePrefix + SrvCfg.TableName, F_ProcessKey,
      SrvFieldsTableName, F_SrvID,
      ProcessPredefFieldsSQL, ProcessPredefFieldsStr,
      SrvStructPropFields,
      SrvCfg.SrvID,
      OldStructData as TClientDataSet, StructData as TClientDataSet,
      true);  // применять set identity_insert
  finally
    if OldStructData <> nil then OldStructData.Close;
  end;
end;

// Модифицирует параметры и обновляет компоненты процесса
procedure Tsdm.ModifySrvTable(SrvCfg: TPolyProcessCfg; StructData: TClientDataSet);

  procedure Alert(E: Exception);
  begin
    if Database.InTransaction then
      Database.RollbackTrans;
    ExceptionHandler.Raise_(E, 'Ошибка при модификации структуры процесса', 'ModifySrvTable');
  end;

begin
  //Result := -1;
  if not Database.InTransaction then Database.BeginTrans;
  try
    if ApplySrvStructChange(StructData, SrvCfg) then
    begin
      Database.CommitTrans;
      //Result := SrvCfg.SrvID;  // не знаю, зачем
      if not Database.InTransaction then
      begin
        AccessManager.SetUserRights;
        CreateProcessTriggers(SrvCfg.SrvID);
      end;
    end;
    cdServices.ApplyUpdates(0);  // а теперь меняем параметры сервиса,
                                 // т.к. имя таблицы могло поменяться
  except
    on E: Exception do
      Alert(E);
  end;

end;

procedure Tsdm.cdSrvGrpsNewRecord(DataSet: TDataSet);
begin
  DataSet['GrpDesc'] := '';
  DataSet['GrpNumber'] := FNewGrpNumber;
end;

procedure Tsdm.cdSrvGrpsBeforeInsert(DataSet: TDataSet);
begin
  FNewGrpNumber := CalcNewFieldValue(DataSet, 'GrpNumber', 1);
end;

{procedure Tsdm.pvServicesBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
  var Applied: Boolean);
var
  i: integer;
begin
  try
    if UpdateKind = ukDelete then
    begin
      aspDelSrv.Parameters.ParamByName('@SrvID').Value := DeltaDS[F_SrvID];
      aspDelSrv.ExecProc;
      Applied := true;
    end
    else
    if UpdateKind = ukInsert then
    begin
      FCurSrvName := DeltaDS['SrvName'];
      for i := 0 to Pred(SourceDS.Fields.Count) do
        if not (SourceDS.Fields[i] is TBlobField) and (SourceDS.Fields[i].FieldName <> F_SrvID) then
          aspNewSrv.Parameters.ParamByName('@' + SourceDS.Fields[i].FieldName).Value :=
            DeltaDS[SourceDS.Fields[i].FieldName];
      aspNewSrv.ExecProc;
      FCurSrvID := aspNewSrv.Parameters[0].Value;
      Applied := true;
    end
    else
      DeltaDS.FieldByName(F_SrvID).ProviderFlags := [pfInKey, pfInWhere];
  except on E: EDatabaseError do begin
      if Database.InTransaction then Database.RollbackTrans;
      ExceptionHandler.Raise_(E);
    end;
  end;
end;}

procedure Tsdm.SetCurPage(SrvPageID: integer);
begin
  cdPageGrids.Filter := 'ProcessPageID=' + IntToStr(SrvPageID);
  cdPageGrids.Filtered := true;
end;

procedure Tsdm.SetCurGrp(GrpID: integer);
begin
  cdSrvPages.Filter := 'GrpID=' + IntToStr(GrpID);
  cdSrvPages.Filtered := true;
end;

procedure Tsdm.SetCurKind(KindID: integer);
begin
  cdKindProcess.Filter := 'KindID=' + IntToStr(KindID);
  cdKindProcess.Filtered := true;
end;

procedure Tsdm.SetCurProcess(ProcessID: integer);
begin
  sdm.cdProcessGrids.Filter := 'ProcessID=' + IntToStr(ProcessID);
  sdm.cdProcessGrids.Filtered := true;
end;

procedure Tsdm.pvSrvGrpsBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
  UpdateKind: TUpdateKind; var Applied: Boolean);
begin
  if UpdateKind = ukDelete then begin
    aspDelSrvGrp.Parameters.ParamByName('@GrpID').Value := DeltaDS['GrpID'];
    aspDelSrvGrp.ExecProc;
    Applied := true;
  end else
  if UpdateKind = ukInsert then begin
    NewGrpID := 0;
    aspNewSrvGrp.Parameters.ParamByName('@GrpNumber').Value := DeltaDS['GrpNumber'];
    aspNewSrvGrp.Parameters.ParamByName('@GrpDesc').Value := DeltaDS['GrpDesc'];
    aspNewSrvGrp.ExecProc;
    NewGrpID := aspNewSrvGrp.Parameters[0].Value;
    Applied := true;
  end else
    DeltaDS.FieldByName('GrpID').ProviderFlags := [pfInKey, pfInWhere];
end;

{function Tsdm.GetSrvPageList: TList;
var
  sp: TSrvPage;
begin
  Result := TList.Create;
  if not cdSrvPages.Active then OpenSrvPages;
  cdSrvPages.First;
  while not cdSrvPages.eof do
  try
    sp := TSrvPage.Create;
    sp.ReadFromDataSet(cdSrvPages);
    Result.Add(sp);
  except
    cdSrvPages.Next;
  end;
end;}

procedure Tsdm.pvOrderKindBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
  UpdateKind: TUpdateKind; var Applied: Boolean);
begin
  DeltaDS.FieldByName('KindID').ProviderFlags := [pfInKey, pfInWhere];
end;

procedure Tsdm.cdKindProcessNewRecord(DataSet: TDataSet);
begin
  DataSet['AutoAddWork'] := false;
  DataSet['AutoAddDraft'] := false;
end;

procedure Tsdm.pvKindProcessBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
  UpdateKind: TUpdateKind; var Applied: Boolean);
begin
  DeltaDS.FieldByName('KindProcessID').ProviderFlags := [pfInKey, pfInWhere];
end;

procedure Tsdm.OpenKindPageInfo(KindID: integer; IsDraft: boolean);
begin
  if cdKindPages.Active then cdKindPages.Close;
  aqKindPages.Parameters.ParamByName('UserID').Value := AccessManager.CurUser.ID;
  aqKindPages.Parameters.ParamByName('KindID').Value := KindID;
  OpenDataSet(cdKindPages);
  if IsDraft then
    cdKindPages.Filter := 'DraftView and not OnlyWorkOrder'
  else
    cdKindPages.Filter := 'WorkView';
  cdKindPages.Filtered := true;
end;

procedure Tsdm.CloseKindPageInfo;
begin
  cdKindPages.Close;
end;

function Tsdm.GetKindProcessArray(KindID: integer): TIntArray;
var
  Arr: TIntArray;
  i: integer;
begin
  if not cdKindProcess.Active then OpenDataSet(cdKindProcess);
  SetCurKind(KindID);
  SetLength(Arr, cdKindProcess.RecordCount);
  if cdKindProcess.RecordCount > 0 then
  begin
    cdKindProcess.First;
    i := 0;
    while not cdKindProcess.eof do
    begin
      Arr[i] := cdKindProcess['ProcessID'];
      Inc(i);
      cdKindProcess.Next;
    end;
  end;
  Result := Arr;
end;

procedure TsDM.OpenDataSet(DataSet: TDataSet);
begin
  Database.OpenDataSet(DataSet);
end;

end.
