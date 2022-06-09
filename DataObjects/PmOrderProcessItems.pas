unit PmOrderProcessItems;

interface

uses Classes, DB, Variants, DBClient,

  MainData, PmEntity, ServMod, PmMaterials, PmOperations;

type
  TOrderProcessItems = class(TEntity)
  private
    FProcesses: Tsm;
    ContractorChanging: boolean;
    LockManualContractorCost: boolean;
    FCalculatingProfit: boolean;
    FDisableProcessItemsNewRecord: boolean;
    FNoModifyTracking: boolean;
    FProcessItemsModified: boolean;
    FPartDeleting: boolean;
    FSettingTime: boolean;
    FPrevProcItemsMode: boolean; // true если был режим preview
    TotalCost, TotalProfitCost, TotalMatCost, TotalOwnCost, TotalContractorCost,
    TotalMatProfitCost, TotalOwnProfitCost, TotalContractorProfitCost,
    TotalOwnCostForProfit, TotalContractorCostForProfit, TotalMatCostForProfit: TAggregateField;
    TotalExpenseCost: TAggregateField;
    FMaterials: TMaterials;
    FOperations: TOperations;
    FOnUpdateModified: TNotifyEvent;
    procedure AnyChange(Sender: TField);
    procedure EnabledChanged(Sender: TField);
    // Вызывается для того чтобы принудительно пересчитать InternalCalc поля,
    // т.к. оказалось, что в D2007 событие пересчета вызывается реже.
    procedure DoProcessItemsCalcFields;
    procedure DoCalcExpenseCost;
    procedure ContractorChange(Sender: TField);
    procedure ContractorProcessChange(Sender: TField);
    procedure ContractorPercentChange(Sender: TField);
    procedure ContractorCostChange(Sender: TField);
    procedure FactContractorCostChange(Sender: TField);
    procedure DateGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure TimeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure DescGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure ProcessParamToProcessData(Sender: TField);
    procedure ProcessParamToProcessDataOverride(Sender: TField;
      OverrideItemID: integer; OverrideFieldValue: variant; OverrideProcessID: integer);
    procedure UpdateLinkedItemID(ItemID: integer; LinkedItemID: integer);
    procedure AddPartRecords;
    //procedure CompareCosts;
    procedure DeletePartRecords;
    procedure SetProcessItemsModified(c: boolean);
    procedure UpdateModified;
    function GetMatCost: extended;
    function GetFactMatCost: extended;
    function GetEnabledCost: extended;
    procedure SetMatCost(Value: extended);
    procedure SetFactMatCost(Value: extended);
    procedure SetProcesses(_Processes: Tsm);
    function GetHideItem: boolean;
    procedure SetHideItem(Value: boolean);
    function GetTrackingEnabled: boolean;
    procedure SetTrackingEnabled(Value: boolean);
    function GetPlanningEnabled: boolean;
    procedure SetPlanningEnabled(Value: boolean);
    function GetIsPartName: boolean;
    procedure SetIsPartName(Value: boolean);
    function GetSequenceOrder: integer;
    procedure SetSequenceOrder(Value: integer);
    function GetContractorProcess: boolean;
    procedure SetContractorProcess(Value: boolean);
    function HandleGetCourse: extended;
    //procedure MatAmountGetText(Sender: TField; var Text: String; DisplayText: Boolean);
  protected
    procedure AllProcessParamsToProcessData(Sender: TObject);
    procedure DoAfterDelete; override;
    procedure DoBeforeDelete; override;
    procedure DoAfterOpen; override;
    procedure DoAfterPost; override;
    procedure DoOnCalcFields; override;
    procedure DoOnNewRecord; override;
    procedure DoAfterApplyUpdates; override;
    procedure ProviderBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
      UpdateKind: TUpdateKind; var Applied: Boolean); override;
    procedure CreateDataSet(DataOwner: TComponent);
    procedure UpdateContractorPercent(Sender: TObject);
    procedure UpdateOwnPercent(Sender: TObject);
    procedure UpdateMatPercent(Sender: TObject);
    function GetRealProcessItemID(id: integer): integer;
    procedure UpdateFactMatCost;
  public
    const
      F_ProcessID = 'ProcessID';
      F_EnabledContractorCost = 'EnabledContractorCost';
      F_EnabledOwnCost = 'EnabledOwnCost';
      F_FactContractorCost = 'FactContractorCost';
      F_ManualContractorCost = 'ManualContractorCost';
      F_IsPartName = 'IsPartName';
      F_OrderID = 'OrderID';
      F_ItemProfit = 'ItemProfit';
      F_EstimatedDuration = 'EstimatedDuration';
      F_FactDuration = 'FactDuration';
      F_PlanDuration = 'PlanDuration';
      F_ContractorID = 'Contractor';
      F_ContractorPayDate = 'ContractorPayDate';
      F_FinalProfitCost = 'FinalProfitCost';
      F_EquipName = 'EquipName';
      F_EquipCount = 'EquipCount';
      F_HideItem = 'HideItem';
      F_TrackingEnabled = 'EnableTracking';
      F_PlanningEnabled = 'EnablePlanning';
      F_SequenceOrder = 'SequenceOrder';
      F_ContractorCostNative = 'ContractorCostNative';
      F_FactMatCost = 'FactMatCost';
      F_ExpenseCost = 'ExpenseCost';
      F_ProductOut = 'ProductOut';
      F_FactProductOut = 'FactProductOut';
      F_FactProductIn = 'FactProductIn';
      F_IsItemInProfit = 'IsItemInProfit';
      F_OwnCostForProfit = 'OwnCostForProfit';
      F_ContractorCostForProfit = 'ContractorCostForProfit';
      F_MatCostForProfit = 'MatCostForProfit';
      F_ContractorPercent = 'ContractorPercent';
      F_Contractor = 'Contractor';
      F_ContractorCost = 'ContractorCost';
      F_Enabled = 'Enabled';
      F_OldCost = 'OldCost';
      F_Cost = 'Cost';
      F_PlanFinish = 'PlanFinishDate';
      F_PlanStart = 'PlanStartDate';
      F_FactFinish = 'FactFinishDate';
      F_FactStart = 'FactStartDate';
      F_ExecState = 'ExecState';
      F_MatCost = 'MatCost';
      F_MatCostNative = 'MatCostNative';
      F_MatPercent = 'MatPercent';
      F_EnabledWorkCost = 'EnabledWorkCost';
      F_EnabledMatCost = 'EnabledMatCost';
      F_ItemDesc = 'ItemDesc';
      F_OwnCost = 'OwnCost';
      F_OwnPercent = 'OwnPercent';
      F_LinkedItemID = 'LinkedItemID';
      F_EquipCode = 'EquipCode';
      F_ContractorProcess = 'ContractorProcess';

    constructor Create(DataOwner: TComponent);
    destructor Destroy; override;
    procedure DumpProcessItems;
    procedure OpenProcessItems(OrderKey: integer; PreviewMode: boolean);
    procedure SetProtection(_CostProtected, _ContentProtected: boolean);
    procedure UpdateGrandTotal;
    procedure RefreshPartRecords;
    procedure DisableGrandTotal;
    procedure EnableGrandTotal;
    procedure CalculateProfits;

    // Добавить информацию о материале для записи процесса с указанным ключом
    procedure SetMaterial(ItemKey: integer; MatTypeName: string; MatDesc: string;
      MatAmount: extended; MatUnitName: string; MatCost: extended;
      ReplaceAnyType: boolean; Resolver: TMatResolveEvent);
    // Добавить информацию о материале для записи процесса с указанным ключом
    procedure SetMaterialEx(ItemKey: integer; MatTypeName: string;
      MatDesc: string; MatParam1, MatParam2, MatParam3: variant;
      MatAmount: extended; MatUnitName: string; MatCost: extended;
      ReplaceAnyType: boolean; Resolver: TMatResolveEvent);
    // Заменить информацию о материале для записи процесса с указанным ключом
    procedure ReplaceMaterial(ItemKey: integer; MatTypeName: string; MatDesc: string;
      MatAmount: extended; MatUnitName: string; MatCost: extended;
      Resolver: TMatResolveEvent);
    // Заменить информацию о материале для записи процесса с указанным ключом
    procedure ReplaceMaterialEx(ItemKey: integer; MatTypeName: string; MatDesc: string;
      MatParam1, MatParam2, MatParam3: variant;
      MatAmount: extended; MatUnitName: string; MatCost: extended;
      Resolver: TMatResolveEvent);
    // Удалить материалы для записи процесса с указанным ключом
    procedure ClearMaterial(ItemKey: integer; MatTypeName: string;
      Resolver: TMatResolveEvent);
    // Установить фактические параметры материала
    procedure SetFactMaterial(ItemKey: integer; MatTypeName: string;
      _FactAmount, _FactCost: variant);

    class function GetEquipName(DataSet: TDataSet): string;
    class function GetPartName(DataSet: TDataSet): string;
    class procedure CalcCosts(DataSet: TDataSet);

    property OnUpdateModified: TNotifyEvent read FOnUpdateModified write FOnUpdateModified;

    property SettingTime: boolean read FSettingTime;
    property NoModifyTracking: boolean read FNoModifyTracking;
    property ProcessItemsModified: boolean read FProcessItemsModified write SetProcessItemsModified;
    property Materials: TMaterials read FMaterials;
    property Operations: TOperations read FOperations;
    property Processes: Tsm read FProcesses write SetProcesses;
    // Data properties
    property MatCost: extended read GetMatCost write SetMatCost;
    property FactMatCost: extended read GetFactMatCost write SetFactMatCost;
    property EnabledCost: extended read GetEnabledCost;
    property HideItem: boolean read GetHideItem write SetHideItem;
    property TrackingEnabled: boolean read GetTrackingEnabled write SetTrackingEnabled;
    property PlanningEnabled: boolean read GetPlanningEnabled write SetPlanningEnabled;
    property IsPartName: boolean read GetIsPartName write SetIsPartName;
    property SequenceOrder: integer read GetSequenceOrder write SetSequenceOrder;
    property ContractorProcess: boolean read GetContractorProcess write SetContractorProcess;
  end;

implementation

uses Dialogs, SysUtils, Provider,

  ADOUtils, PmDatabase, PmProcess, RDBUtils, RDialogs, ExHandler, StdDic,
  CalcUtils, PmContragent, TLoggerUnit, PlanUtils, PmOrder, PmConfigManager;

constructor TOrderProcessItems.Create(DataOwner: TComponent);
begin
  inherited Create;
  FKeyField := F_ItemID;
  FInternalName := 'OrderProcessItems';
  CreateDataSet(DataOwner);
  {DataSet.FieldByName(F_Part).OnChange := AnyChange;
  DataSet.FieldByName(F_ItemDesc).OnChange := AnyChange;
  DataSet.FieldByName('ItemDesc').OnGetText := DescGetText;
  DataSet.FieldByName(F_Cost).OnChange := AnyChange;
  DataSet.FieldByName('PlanStartDate').OnChange := AnyChange;
  DataSet.FieldByName('PlanFinishDate').OnChange := AnyChange;
  DataSet.FieldByName('FactStartDate').OnChange := AnyChange;
  DataSet.FieldByName('FactFinishDate').OnChange := AnyChange;
  DataSet.FieldByName('ProductIn').OnChange := AnyChange;
  DataSet.FieldByName('ProductOut').OnChange := AnyChange;
  DataSet.FieldByName('Multiplier').OnChange := AnyChange;
  DataSet.FieldByName('SideCount').OnChange := AnyChange;
  DataSet.FieldByName('FactProductIn').OnChange := AnyChange;
  DataSet.FieldByName('FactProductOut').OnChange := AnyChange;
  DataSet.FieldByName(F_OwnCost).OnChange := AnyChange;
  DataSet.FieldByName('ContractorPayDate').OnChange := AnyChange;
  DataSet.FieldByName('Contractor').OnChange := ContractorChange;
  DataSet.FieldByName('ContractorProcess').OnChange := ContractorProcessChange;
  DataSet.FieldByName('ContractorPercent').OnChange := ContractorPercentChange;
  DataSet.FieldByName('ContractorCost').OnChange := ContractorCostChange;
  DataSet.FieldByName('FactContractorCost').OnChange := FactContractorCostChange;
  DataSet.FieldByName(F_Enabled).OnChange := ProcessParamToProcessData;
  DataSet.FieldByName(F_EquipCode).OnChange := ProcessParamToProcessData;
  DataSet.FieldByName(F_MatCost).OnChange := ProcessParamToProcessData;
  DataSet.FieldByName('PlanStartDate').OnGetText := DateGetText;
  DataSet.FieldByName('PlanFinishDate').OnGetText := DateGetText;
  DataSet.FieldByName('FactFinishDate').OnGetText := DateGetText;
  DataSet.FieldByName('FactStartDate').OnGetText := DateGetText;
  DataSet.FieldByName('PlanStartTime_ICalc').OnGetText := TimeGetText;
  DataSet.FieldByName('PlanFinishTime_ICalc').OnGetText := TimeGetText;
  DataSet.FieldByName('FactFinishTime_ICalc').OnGetText := TimeGetText;
  DataSet.FieldByName('FactStartTime_ICalc').OnGetText := TimeGetText;}

  DataSet.FieldByName(F_ContractorName).LookupDataSet := Contractors.DataSet;

  FDisableChildDataFilter := true;  // не фильтровать материалы, т.к. они нужны целиком

  FMaterials := TMaterials.Create(DataSet.Owner);
  FMaterials.OnGetCourse := HandleGetCourse;
  FMaterials.FieldChanged := AnyChange;
  DetailData[0] := FMaterials;
  FOperations := TOperations.Create(DataSet.Owner);
  DetailData[1] := FOperations;
end;

destructor TOrderProcessItems.Destroy;
begin
  inherited;
end;

procedure TOrderProcessItems.SetProcesses(_Processes: Tsm);
begin
  FProcesses := _Processes;
  FProcesses.OnGetRealProcessItemID := GetRealProcessItemID;
  FProcesses.OnUpdateOwnPercent := UpdateOwnPercent;
  FProcesses.OnUpdateContractorPercent := UpdateContractorPercent;
  FProcesses.OnUpdateMatPercent := UpdateMatPercent;
  FProcesses.OnAllProcessParamsToProcessData := AllProcessParamsToProcessData;
end;

{$REGION 'CreateDataSet'}

procedure TOrderProcessItems.CreateDataSet(DataOwner: TComponent);
var
  _DataSet: TClientDataSet;
  f: TField;
  FDataProvider: TDataSetProvider;
begin
  _DataSet := TClientDataSet.Create(DataOwner);
  _DataSet.Name := GetComponentName(DataOwner, 'cd' + InternalName);
  SetDataSet(_DataSet);
  FDataProvider := TDataSetProvider.Create(DataOwner);
  FDataProvider.Name := 'pv' + InternalName;
  FDataProvider.UpdateMode := upWhereKeyOnly;
  DataSetProvider := FDataProvider;
  FDataProvider.DataSet := dm.aqProcessItemsLeft;
  //DataSetProvider := dm.pvProcessItemsLeft;
  //_DataSet.SetProvider(FDataProvider);
  _DataSet.ProviderName := FDataProvider.Name;
  _DataSet.DisableStringTrim := True;

  f := TAutoIncField.Create(DataSet.Owner);
  f.AutoGenerateValue := arAutoInc;
  f.FieldName := F_ItemID;
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_Part;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := AnyChange;
  f.DataSet := DataSet;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'ItemDesc';
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := AnyChange;
  f.OnGetText := DescGetText;
  f.Size := 150;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_Cost;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := AnyChange;
  (f as TNumericField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).Currency := True;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := F_Enabled;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := EnabledChanged;//ProcessParamToProcessData;
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'ProcessID';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := F_PlanStart;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := AnyChange;
  f.OnGetText := DateGetText;
  (f as TDateTimeField).DisplayFormat := 'dd/mm/yyyy';
  f.DataSet := DataSet;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := F_PlanFinish;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := AnyChange;
  f.OnGetText := DateGetText;
  (f as TDateTimeField).DisplayFormat := 'dd/mm/yyyy';
  f.DataSet := DataSet;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := F_FactFinish;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := AnyChange;
  f.OnGetText := DateGetText;
  (f as TDateTimeField).DisplayFormat := 'dd/mm/yyyy';
  f.DataSet := DataSet;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName :=  F_FactStart;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := AnyChange;
  f.OnGetText := DateGetText;
  (f as TDateTimeField).DisplayFormat := 'dd/mm/yyyy';
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldKind := fkInternalCalc;
  f.FieldName := F_ExecState;
  f.ProviderFlags := [];
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName :=  'ItemProfit';
  f.ProviderFlags := [pfInUpdate];
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := F_IsItemInProfit;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldKind := fkInternalCalc;
  f.FieldName :=  'FinalProfitCost';
  f.ProviderFlags := [];
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName :=  'EquipCode';
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := ProcessParamToProcessData;
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName :=  'ProductIn';
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := AnyChange;
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_ProductOut;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := AnyChange;
  f.DataSet := DataSet;

  f := TFloatField.Create(DataSet.Owner);
  f.FieldName := 'Multiplier';
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := AnyChange;
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_FactProductIn;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := AnyChange;
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_FactProductOut;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := AnyChange;
  f.DataSet := DataSet;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := F_TrackingEnabled;
  f.ProviderFlags := [];
  f.DataSet := DataSet;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := F_PlanningEnabled;
  f.ProviderFlags := [];
  f.DataSet := DataSet;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := 'PermitPlan';
  f.ProviderFlags := [];
  f.DataSet := DataSet;

    f := TBooleanField.Create(DataSet.Owner);
      f.FieldName :=  'PermitFact';
      f.ProviderFlags := [];
  f.DataSet := DataSet;

    f := TBooleanField.Create(DataSet.Owner);
      f.FieldName :=  F_IsPartName;
      f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;

    f := TBooleanField.Create(DataSet.Owner);
      f.FieldName :=  F_HideItem;
      f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;

    f := TIntegerField.Create(DataSet.Owner);
      f.FieldName :=  'UseInProfitMode';
      f.ProviderFlags := [];
  f.DataSet := DataSet;

    f := TBooleanField.Create(DataSet.Owner);
      f.FieldName :=  'UseInTotal';
      f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;

    f := TBCDField.Create(DataSet.Owner);
      f.FieldKind := fkInternalCalc;
      f.FieldName :=  'EnabledCost';
      f.ProviderFlags := [];
      (f as TBCDField).Precision := 18;
      f.Size := 2;
  f.DataSet := DataSet;

    f := TIntegerField.Create(DataSet.Owner);
      f.FieldKind := fkInternalCalc;
      f.FieldName :=  'ItemNumber';
      f.ProviderFlags := [];
  f.DataSet := DataSet;

    f := TBCDField.Create(DataSet.Owner);
      f.FieldKind := fkInternalCalc;
      f.FieldName :=  'ProfitCost';
      f.ProviderFlags := [];
      (f as TBCDField).Precision := 18;
      f.Size := 2;
  f.DataSet := DataSet;

    f := TBCDField.Create(DataSet.Owner);
      f.FieldName :=  'OwnPercent';
      f.ProviderFlags := [pfInUpdate];
      (f as TBCDField).Currency := true;
      (f as TBCDField).Precision := 18;
      f.Size := 2;
  f.DataSet := DataSet;

    f := TBCDField.Create(DataSet.Owner);
      f.FieldName :=  'OwnCost';
      f.ProviderFlags := [pfInUpdate];
      f.OnChange := AnyChange;
      (f as TNumericField).DisplayFormat := NumDisplayFmt;
      (f as TBCDField).Currency := true;
      (f as TBCDField).Precision := 18;
      f.Size := 2;
  f.DataSet := DataSet;

    f := TDateTimeField.Create(DataSet.Owner);
      f.FieldKind := fkInternalCalc;
      f.FieldName :=  'PlanStartTime_ICalc';
      f.ProviderFlags := [];
      f.OnGetText := TimeGetText;
      (f as TDateTimeField).DisplayFormat := 'hh:nn';
  f.DataSet := DataSet;

    f := TDateTimeField.Create(DataSet.Owner);
      f.FieldKind := fkInternalCalc;
      f.FieldName :=  'PlanFinishTime_ICalc';
  f.ProviderFlags := [];
      f.ProviderFlags := [];
      f.OnGetText := TimeGetText;
      (f as TDateTimeField).DisplayFormat := 'hh:nn';
  f.DataSet := DataSet;

    f := TDateTimeField.Create(DataSet.Owner);
      f.FieldKind := fkInternalCalc;
      f.FieldName :=  'FactStartTime_ICalc';
  f.ProviderFlags := [];
      f.OnGetText := TimeGetText;
      (f as TDateTimeField).DisplayFormat := 'hh:nn';
  f.DataSet := DataSet;

    f := TDateTimeField.Create(DataSet.Owner);
      f.FieldKind := fkInternalCalc;
      f.FieldName :=  'FactFinishTime_ICalc';
      f.OnGetText := TimeGetText;
      (f as TDateTimeField).DisplayFormat := 'hh:nn';
  f.DataSet := DataSet;

    f := TBCDField.Create(DataSet.Owner);
      f.FieldKind := fkInternalCalc;
      f.FieldName := 'ScriptedProfitCost';
      f.ProviderFlags := [];
      (f as TBCDField).Precision := 18;
      f.Size := 2;
  f.DataSet := DataSet;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName :=  'PermitInsert';
  f.ProviderFlags := [];
  f.DataSet := DataSet;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName :=  'PermitUpdate';
  f.ProviderFlags := [];
  f.DataSet := DataSet;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName :=  'PermitDelete';
  f.ProviderFlags := [];
  f.DataSet := DataSet;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldKind := fkInternalCalc;
  f.FieldName :=  'DateTimeDecomposed';
  f.ProviderFlags := [];
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataSet.Owner);
  //f.FieldKind := fkInternalCalc;
  f.FieldName :=  F_PlanDuration; // время в минутах
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataSet.Owner);
  //f.FieldKind := fkInternalCalc;
  f.FieldName := F_FactDuration;  // время в минутах
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName :=  F_Contractor;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := ContractorChange;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName :=  'ContractorPercent';
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := ContractorPercentChange;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName :=  F_ContractorCost;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := ContractorCostChange;
  (f as TNumericField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).Currency := true;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldKind := fkInternalCalc;
  f.FieldName := F_ContractorCostNative;
  f.ProviderFlags := [];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).EditFormat := NumEditFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName :=  F_ContractorProcess;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := ContractorProcessChange;
  f.DataSet := DataSet;

  f := TStringField.Create(DataSet.Owner);
  f.FieldKind := fkLookup;
  f.FieldName :=  'ContractorName';
  f.LookupKeyFields := TContragents.F_CustKey;
  f.LookupResultField := 'Name';
  f.KeyFields := 'Contractor';
  f.ProviderFlags := [pfInUpdate];
  f.Size := TContragents.CustNameSize;
  f.Lookup := True;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName :=  F_MatCost;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := ProcessParamToProcessData;
  (f as TNumericField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).Currency := true;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_FactMatCost;
  f.FieldKind := fkInternalCalc;
  f.ProviderFlags := [pfInUpdate];
  (f as TNumericField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).Currency := true;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName :=  'MatPercent';
  f.ProviderFlags := [pfInUpdate];
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldKind := fkInternalCalc;
  f.FieldName := 'EnabledContractorCost';
  f.ProviderFlags := [];
  (f as TNumericField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldKind := fkInternalCalc;
  f.FieldName :=  'EnabledOwnCost';
  f.ProviderFlags := [];
  (f as TNumericField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldKind := fkInternalCalc;
  f.FieldName :=  'EnabledWorkCost';
  f.ProviderFlags := [];
  (f as TNumericField).DisplayFormat := NumDisplayFmt;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldKind := fkInternalCalc;
  f.FieldName :=  'EnabledMatCost';
  f.ProviderFlags := [];
  (f as TNumericField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldKind := fkInternalCalc;
  f.FieldName :=  'MatProfitCost';
  f.ProviderFlags := [];
  (f as TNumericField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldKind := fkInternalCalc;
  f.FieldName := 'ContractorProfitCost';
  f.ProviderFlags := [];
  (f as TNumericField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldKind := fkInternalCalc;
  f.FieldName := 'OwnProfitCost';
  f.ProviderFlags := [];
  (f as TNumericField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldKind := fkInternalCalc;
  f.FieldName := 'ProfitPercent';
  f.ProviderFlags := [];
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldKind := fkInternalCalc;
  f.FieldName := 'OwnCostForProfit';
  f.ProviderFlags := [];
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldKind := fkInternalCalc;
  f.FieldName := 'ContractorCostForProfit';
  f.ProviderFlags := [];
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

    f := TBCDField.Create(DataSet.Owner);
    f.FieldKind := fkInternalCalc;
    f.FieldName := 'MatCostForProfit';
    f.ProviderFlags := [];
    (f as TBCDField).Precision := 18;
    f.Size := 2;
    f.DataSet := DataSet;

    f := TBCDField.Create(DataSet.Owner);
    f.FieldName :=  F_FactContractorCost;
    (f as TNumericField).DisplayFormat := NumDisplayFmt;
    (f as TNumericField).EditFormat := NumEditFmt;
    f.ProviderFlags := [pfInUpdate];
    f.OnChange := FactContractorCostChange;
    (f as TBCDField).Precision := 18;
    f.Size := 2;
    f.DataSet := DataSet;

    f := TBooleanField.Create(DataSet.Owner);
    f.FieldName :=  'ManualContractorCost';
    f.ProviderFlags := [pfInUpdate];
    f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldKind := fkInternalCalc;
  f.FieldName := F_ExpenseCost;
  f.ProviderFlags := [];
  (f as TNumericField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

    f := TBCDField.Create(DataSet.Owner);
    f.FieldName := 'OldCost';
    f.ProviderFlags := [];
    (f as TBCDField).Precision := 18;
    f.Size := 2;
    f.DataSet := DataSet;

    f := TIntegerField.Create(DataSet.Owner);
    f.FieldName := 'EstimatedDuration';
    f.ProviderFlags := [pfInUpdate];
    f.DataSet := DataSet;

    f := TIntegerField.Create(DataSet.Owner);
    f.FieldName := 'LinkedItemID';
    f.ProviderFlags := [pfInUpdate];
    f.DataSet := DataSet;

    f := TIntegerField.Create(DataSet.Owner);
    f.FieldName := F_SequenceOrder;
    f.ProviderFlags := [pfInUpdate];
    f.DataSet := DataSet;

    f := TIntegerField.Create(DataSet.Owner);
    f.FieldName := 'EquipCount';
    f.ProviderFlags := [];
    f.DataSet := DataSet;

    f := TIntegerField.Create(DataSet.Owner);
    f.FieldName := 'IsPausedCount';
    f.ProviderFlags := [];
    f.DataSet := DataSet;

    f := TBooleanField.Create(DataSet.Owner);
    f.FieldName := 'IsPaused';
    f.ProviderFlags := [];
    f.DataSet := DataSet;

    f := TDateTimeField.Create(DataSet.Owner);
    f.FieldName := 'ContractorPayDate';
    f.ProviderFlags := [];
    f.OnChange := AnyChange;
    (f as TDateTimeField).DisplayFormat := 'dd/mm/yyyy';
    f.DataSet := DataSet;

    f := TStringField.Create(DataSet.Owner);
    f.FieldKind := fkInternalCalc;
    f.FieldName := F_EquipName;
    f.ProviderFlags := [];
    f.Size := 50;
    f.DataSet := DataSet;

    f := TStringField.Create(DataSet.Owner);
    f.FieldKind := fkInternalCalc;
    f.FieldName := F_PartName;
    f.ProviderFlags := [];
    f.Size := 50;
    f.DataSet := DataSet;

    f := TIntegerField.Create(DataSet.Owner);
    f.FieldName := 'SideCount';
    f.ProviderFlags := [pfInUpdate];
    f.DataSet := DataSet;

    TotalCost := TAggregateField.Create(DataSet.Owner);
    TotalCost.DefaultExpression := '0';
    TotalCost.FieldName := 'TotalCost';
    TotalCost.Active := True;
    TotalCost.Expression := 'sum(EnabledCost)';
    TotalCost.DataSet := DataSet;

    TotalProfitCost := TAggregateField.Create(DataSet.Owner);
    TotalProfitCost.DefaultExpression := '0';
    TotalProfitCost.FieldName := 'TotalProfitCost';
    TotalProfitCost.Active := True;
    TotalProfitCost.Expression := 'sum(FinalProfitCost)';
    TotalProfitCost.DataSet := DataSet;

    TotalMatCost := TAggregateField.Create(DataSet.Owner);
    TotalMatCost.DefaultExpression := '0';
    TotalMatCost.FieldName := 'TotalMatCost';
    TotalMatCost.Active := True;
    TotalMatCost.Expression := 'sum(EnabledMatCost)';
    TotalMatCost.DataSet := DataSet;

    TotalOwnCost := TAggregateField.Create(DataSet.Owner);
    TotalOwnCost.DefaultExpression := '0';
    TotalOwnCost.FieldName := 'TotalOwnCost';
    TotalOwnCost.Active := True;
    TotalOwnCost.Expression := 'sum(EnabledOwnCost)';
    TotalOwnCost.DataSet := DataSet;

    TotalContractorCost := TAggregateField.Create(DataSet.Owner);
    TotalContractorCost.DefaultExpression := '0';
    TotalContractorCost.FieldName := 'TotalContractorCost';
    TotalContractorCost.Active := True;
    TotalContractorCost.Expression := 'sum(EnabledContractorCost)';
    TotalContractorCost.DataSet := DataSet;

    TotalMatProfitCost := TAggregateField.Create(DataSet.Owner);
    TotalMatProfitCost.DefaultExpression := '0';
    TotalMatProfitCost.FieldName := 'TotalMatProfitCost';
    TotalMatProfitCost.Active := True;
    TotalMatProfitCost.Expression := 'sum(MatProfitCost)';
    TotalMatProfitCost.DataSet := DataSet;

    TotalOwnProfitCost := TAggregateField.Create(DataSet.Owner);
    TotalOwnProfitCost.DefaultExpression := '0';
    TotalOwnProfitCost.FieldName := 'TotalOwnProfitCost';
    TotalOwnProfitCost.Active := True;
    TotalOwnProfitCost.Expression := 'sum(OwnProfitCost)';
    TotalOwnProfitCost.DataSet := DataSet;

    TotalContractorProfitCost := TAggregateField.Create(DataSet.Owner);
    TotalContractorProfitCost.DefaultExpression := '0';
    TotalContractorProfitCost.FieldName := 'TotalContractorProfitCost';
    TotalContractorProfitCost.Active := True;
    TotalContractorProfitCost.Expression := 'sum(ContractorProfitCost)';
    TotalContractorProfitCost.DataSet := DataSet;

    TotalOwnCostForProfit := TAggregateField.Create(DataSet.Owner);
    TotalOwnCostForProfit.DefaultExpression := '0';
    TotalOwnCostForProfit.FieldName := 'TotalOwnCostForProfit';
    TotalOwnCostForProfit.Active := True;
    TotalOwnCostForProfit.Expression := 'sum(OwnCostForProfit)';
    TotalOwnCostForProfit.DataSet := DataSet;

    TotalContractorCostForProfit := TAggregateField.Create(DataSet.Owner);
    TotalContractorCostForProfit.DefaultExpression := '0';
    TotalContractorCostForProfit.FieldName := 'TotalContractorCostForProfit';
    TotalContractorCostForProfit.Active := True;
    TotalContractorCostForProfit.Expression := 'sum(ContractorCostForProfit)';
    TotalContractorCostForProfit.DataSet := DataSet;

    TotalMatCostForProfit := TAggregateField.Create(DataSet.Owner);
    TotalMatCostForProfit.DefaultExpression := '0';
    TotalMatCostForProfit.FieldName := 'TotalMatCostForProfit';
    TotalMatCostForProfit.Active := True;
    TotalMatCostForProfit.Expression := 'sum(MatCostForProfit)';
    TotalMatCostForProfit.DataSet := DataSet;

    TotalExpenseCost := TAggregateField.Create(DataSet.Owner);
    TotalExpenseCost.DefaultExpression := '0';
    TotalExpenseCost.FieldName := 'TotalExpenseCost';
    TotalExpenseCost.Active := True;
    TotalExpenseCost.Expression := 'sum(ExpenseCost)';
    TotalExpenseCost.DataSet := DataSet;

  //_DataSet.IndexDefs.Add;
  {_DataSet.AddIndex('cdProcessItemsItemNumber', 'ItemNumber', []);
  _DataSet.AddIndex('cdProcessItemsPart', F_Part, []);
  //_DataSet.AddIndex('cdProcessItems', '', []);
  _DataSet.AddIndex('cdProcessItemsSequenceOrder', 'Part;SequenceOrder', []);}
  _DataSet.IndexDefs.Add('cdProcessItemsItemNumber', 'ItemNumber', []);
  _DataSet.IndexDefs.Add('cdProcessItemsPart', F_Part, []);
  _DataSet.IndexDefs.Add('cdProcessItemsSequenceOrder', 'Part;SequenceOrder', []);
  FPrevProcItemsMode := true;
end;

{$ENDREGION}

procedure TOrderProcessItems.AllProcessParamsToProcessData(Sender: TObject);
var
  Srv: TPolyProcess;
  CurItemID: integer;

  procedure SetOneParam(FieldName: string);
  var
    f, fs: TField;
  begin
    ProcessChangeLock.Lock(FieldName);
    try
      f := Srv.DataSet.FieldByName(FieldName);
      fs := DataSet.FieldByName(FieldName);
      if {VarIsNull(f.Value) or }(f.Value <> fs.Value) then // commented out 01.10.2005
      begin
        if not (Srv.DataSet.State in [dsInsert, dsEdit]) then Srv.DataSet.Edit;
        f.Value := fs.Value;
      end;
    finally
      ProcessChangeLock.Unlock;
    end;
  end;

begin
  //if (MForm.ViewMode <> vmRight) then Exit;
  DataSet.First;
  while not DataSet.Eof do
  begin
    // не открывать автоматически
    Srv := FProcesses.ServiceByID(DataSet['ProcessID'], false);
    if (Srv <> nil) and Srv.DataSet.Active then
    begin
      CurItemID := NvlInteger(Srv.DataSet[F_ItemID]);
      Srv.DataSet.DisableControls;
      try
        if Srv.DataSet.Locate(F_ItemID, KeyValue, []) then
        begin
          SetOneParam(F_Enabled);
          //SetOneParam(SrvExecStateField);
          SetOneParam(F_EquipCode);
          SetOneParam(F_Part);
          SetOneParam(F_ContractorProcess);
          SetOneParam(F_ContractorPercent);
          SetOneParam(F_MatCost);
          SetOneParam(F_LinkedItemID);
          Srv.DataSet.Post;
          Srv.DataSet.Locate(F_ItemID, CurItemID, []);
        end;
      finally
        Srv.DataSet.EnableControls;
      end;
    end
    else
      RusMessageDlg('В текущем виде заказа процесс "' +
        VarToStr(DataSet[F_ItemDesc]) + '" не найден.' + #13'Данные по этому процессу будут недоступны.',
        mtWarning, [mbOk], 0);
    DataSet.Next;
  end;
end;

{function TOrderProcessItems.ApplyProcessItems: boolean;     // НЕ НАДО ЕСЛИ ПРОПИСАТЬ КАК Details
begin
  Result := ApplyUpdates;
  if Result then Result := Materials.ApplyUpdates;
  if Result then Result := Operations.ApplyUpdates;
end;}

procedure TOrderProcessItems.CalculateProfits;
var
  NewVal: extended;
  CurItemID: integer;
  ProfitCost: extended;
  ct, gt, gtp: extended;
begin
  if not FCalculatingProfit then
  begin
    DataSet.DisableControls;
    FCalculatingProfit := true;
    // обновляем итоговые суммы
    UpdateGrandTotal;  // 01.10.2005
    try
      CurItemID := NvlInteger(DataSet[F_ItemID]);
      DataSet.First;
      while not DataSet.eof do
      begin
        if not IsPartName and NvlBoolean(DataSet[F_Enabled])
          and NvlBoolean(DataSet[F_IsItemInProfit]) then
        begin
          // общая сумма процесса, на которую начисляется общая скидка-наценка
          //ProfitCost := NvlFloat(cdProcessItems['MatProfitCost']) + NvlFloat(cdProcessItems['ContractorProfitCost'])
          //  + NvlFloat(cdProcessItems['OwnProfitCost']);
          ProfitCost := NvlFloat(DataSet[F_MatCostForProfit]) * (1 + NvlFloat(DataSet[F_MatPercent]) / 100.0)
            + NvlFloat(DataSet[F_ContractorCostForProfit]) * (1 + NvlFloat(DataSet[F_ContractorPercent]) / 100.0)
            + NvlFloat(DataSet[F_OwnCostForProfit]) * (1 + NvlFloat(DataSet[F_OwnPercent]) / 100.0);
          if FProcesses.GrandTotal = 0 then NewVal := 0
          else
          begin
            ct := FProcesses.ClientTotal;
            gt := FProcesses.GrandTotal;
            gtp := FProcesses.OwnProfit + FProcesses.TotalOwnCostForProfit
              + FProcesses.ContractorProfit + FProcesses.TotalContractorCostForProfit
              + FProcesses.MatProfit + FProcesses.TotalMatCostForProfit;
            //gtp := sm.TotalOwnProfitCost + sm.TotalContractorProfitCost + sm.TotalMatProfitCost;
            NewVal := ProfitCost * (ct - gt ) / gtp;
          end;
          NewVal := NewVal + NvlFloat(DataSet['MatProfitCost']) - NvlFloat(DataSet['MatCost'])
            + NvlFloat(DataSet['OwnProfitCost']) - NvlFloat(DataSet['OwnCost'])
            + NvlFloat(DataSet['ContractorProfitCost']) - NvlFloat(DataSet['ContractorCost']);
          if Abs(NewVal - DataSet[F_ItemProfit]) > 1e-4 then
          begin
            DataSet.Edit;
            DataSet[F_ItemProfit] := NewVal;
            DoProcessItemsCalcFields;
          end;
        end
        else
        if DataSet[F_ItemProfit] <> 0 then
        begin
          DataSet.Edit;
          DataSet[F_ItemProfit] := 0;
          DoProcessItemsCalcFields;
        end;
        DataSet.Next;
      end;
      if DataSet.State = dsEdit then DataSet.Post;
      if CurItemID <> 0 then
        Locate(CurItemID);
    finally
      try
        UpdateGrandTotal;
      finally
        DataSet.EnableControls;
      end;
      FCalculatingProfit := false;  // 01.10.2005 Было перед try
    end;
  end;
end;

procedure TOrderProcessItems.DoAfterDelete;
begin
  if not FPartDeleting then
  begin
    if not FNoModifyTracking then ProcessItemsModified := true;
    UpdateGrandTotal;
  end;
end;

procedure TOrderProcessItems.DoAfterOpen;
begin
  DataSet.Tag := 0;
end;

procedure TOrderProcessItems.DoAfterPost;
var
  OldGrandTotal, OldClientTotal, OldClientTotalGrn, OldTotalOwnCost,
  OldTotalContractorCost, OldTotalMatCost: extended;
begin
  if not FCalculatingProfit then
  begin
    OldGrandTotal := FProcesses.GrandTotal;
    OldClientTotal := FProcesses.ClientTotal;
    OldClientTotalGrn := FProcesses.ClientTotalGrn;
    OldTotalOwnCost := FProcesses.TotalOwnCost;
    OldTotalContractorCost := FProcesses.TotalContractorCost;
    OldTotalMatCost := FProcesses.TotalMatCost;
    UpdateGrandTotal;
    if (DataSet as TClientDataSet).AggregatesActive
      and ((OldGrandTotal <> FProcesses.GrandTotal{DataSet['TotalCost']})
      or (OldClientTotal <> FProcesses.ClientTotal)
      or (OldClientTotalGrn <> FProcesses.ClientTotalGrn)
      or (OldTotalOwnCost <> FProcesses.TotalOwnCost)
      or (OldTotalContractorCost <> FProcesses.TotalContractorCost)
      or (OldTotalMatCost <> FProcesses.TotalMatCost)) then
      CalculateProfits;
  end;
end;

procedure TOrderProcessItems.EnabledChanged(Sender: TField);
begin
  if not NvlBoolean(DataSet[F_IsPartName]) then
  begin
    // удаляем все соотв. материалы
    if not NvlBoolean(DataSet[F_Enabled]) then
      FMaterials.ClearMaterial(KeyValue, '', nil);
    ProcessParamToProcessData(Sender);
  end;
end;

procedure TOrderProcessItems.AnyChange(Sender: TField);
begin
  if not FNoModifyTracking then
    ProcessItemsModified := true;
end;

procedure TOrderProcessItems.DoBeforeDelete;
var
  CurID: integer;
begin
  CurID := KeyValue;
  if not IsPartName then
    FMaterials.ClearMaterial(KeyValue, '', nil);  // не резолвим здесь, т.к. придется бросать ексепшен, а это м.б. рискованно
  if not Locate(CurID) then // не помню зачем это
    ExceptionHandler.Raise_('Не найдена запись для удаления в TOrderProcessItems.BeforeDelete');
end;

class procedure TOrderProcessItems.CalcCosts(DataSet: TDataSet);
var
  ProfitCost: extended;
begin
    if NvlBoolean(DataSet[F_IsPartName]) then
    begin
      DataSet[F_EnabledCost] := 0;
      DataSet['ProfitCost'] := 0;
      DataSet[F_FinalProfitCost] := 0;
      DataSet[F_EnabledMatCost] := 0;
      DataSet['MatProfitCost'] := 0;
      DataSet[F_ExpenseCost] := 0;
      DataSet['EnabledContractorCost'] := 0;
      DataSet['ContractorProfitCost'] := 0;
      DataSet['EnabledOwnCost'] := 0;
      DataSet[F_EnabledWorkCost] := 0;
      DataSet['OwnProfitCost'] := 0;
      DataSet[F_OwnCostForProfit] := 0;
      DataSet[F_ContractorCostForProfit] := 0;
      DataSet[F_MatCostForProfit] := 0;
    end
    else
    if not VarIsNull(DataSet[F_Enabled]) and not VarIsNull(DataSet['UseInTotal']) then
    begin
      if DataSet[F_Enabled] and DataSet['UseInTotal'] then
      begin
        // процессы без наценки
        DataSet['EnabledCost'] := DataSet[F_Cost];
        // материалы без наценки
        DataSet[F_EnabledMatCost] := DataSet[F_MatCost];
        // Распределение наценки
        if NvlBoolean(DataSet[F_IsItemInProfit]) then
        begin
          DataSet[F_OwnCostForProfit] := NvlFloat(DataSet[F_OwnCost]);
          DataSet[F_ContractorCostForProfit] := NvlFloat(DataSet[F_ContractorCost]);
          // с наценкой
          DataSet['ContractorProfitCost'] := NvlFloat(DataSet[F_ContractorCost]) * (1 + NvlFloat(DataSet[F_ContractorPercent] / 100.0));
          // с наценкой
          DataSet['OwnProfitCost'] := NvlFloat(DataSet[F_OwnCost]) * (1 + NvlFloat(DataSet[F_OwnPercent] / 100.0));
        end
        else
        begin
          DataSet[F_OwnCostForProfit] := 0;
          DataSet[F_ContractorCostForProfit] := 0;
          DataSet['ContractorProfitCost'] := NvlFloat(DataSet[F_ContractorCost]);
          DataSet['OwnProfitCost'] := NvlFloat(DataSet[F_OwnCost]);
        end;
        // TODO: По материалам пока не распределяем
        DataSet[F_MatCostForProfit] := NvlFloat(DataSet[F_MatCost]);
        // материалы с наценкой
        DataSet['MatProfitCost'] := NvlFloat(DataSet[F_MatCost]) * (1 + NvlFloat(DataSet[F_MatPercent] / 100.0));
        // процессы субподряда без наценки
        DataSet['EnabledContractorCost'] := DataSet[F_ContractorCost];
        // производство без наценки
        DataSet['EnabledOwnCost'] := DataSet[F_OwnCost];
        // работа с наценкой
        DataSet[F_EnabledWorkCost] := DataSet['ContractorProfitCost'] + DataSet['OwnProfitCost'];
        // общая наценка-скидка
        ProfitCost := NvlFloat(DataSet['ContractorCost'])
          + NvlFloat(DataSet['OwnCost']) + NvlFloat(DataSet[F_MatCost]);
        DataSet[F_FinalProfitCost] := ProfitCost  + NvlFloat(DataSet[F_ItemProfit]);
        //MessageDlg(VarToStr(DataSet[F_FinalProfitCost]), mtInformation, [mbOk], 0);
      end
      else
      begin
        DataSet[F_EnabledCost] := 0;
        DataSet['ProfitCost'] := 0;
        DataSet[F_FinalProfitCost] := 0;
        DataSet[F_EnabledMatCost] := 0;
        DataSet['MatProfitCost'] := 0;
        DataSet['EnabledContractorCost'] := 0;
        DataSet['ContractorProfitCost'] := 0;
        DataSet['EnabledOwnCost'] := 0;
        DataSet[F_EnabledWorkCost] := 0;
        DataSet['OwnProfitCost'] := 0;
        DataSet[F_OwnCostForProfit] := 0;
        DataSet[F_ContractorCostForProfit] := 0;
        DataSet[F_MatCostForProfit] := 0;
        DataSet[F_ExpenseCost] := 0;
      end;
    end;
end;

procedure TOrderProcessItems.DoOnCalcFields;
begin
  if (DataSet.State = dsInternalCalc)
    or (DataSet.State = dsEdit) // добавлено 08.02.2008 для того, чтобы
    // вычисляемые поля пересчитывались не только при изменении наценки
    // (например, при изменении Enabled)
  {or (DataSet.State = dsCalcFields)} then
  begin
    {if DataSet.State = dsInternalCalc then
      MessageDlg('dsInternalCalc', mtInformation, [mbOk], 0)
    else
      MessageDlg('dsCalcFields', mtInformation, [mbOk], 0);}
    DoProcessItemsCalcFields;
  end;
  // Теперь обычные вычисляемые поля
  // (их скорее всего не будет, т.к. пользователь
  // видит только клоны этого набора данных, а туда эти поля не переносятся).
end;

procedure TOrderProcessItems.DoCalcExpenseCost;
var
  fc: extended;
begin
  if NvlBoolean(DataSet[F_Enabled]) then
  begin
    // затраты
    if NvlBoolean(DataSet[F_ContractorProcess]) then
    begin
      if not VarIsNull(DataSet[F_FactContractorCost]) then
        fc := DataSet[F_FactContractorCost]
      else
        fc := DataSet['ContractorProfitCost'] * Processes.USDCourse;
    end
    else
      fc := 0;
    DataSet[F_ExpenseCost] := NvlFloat(DataSet[F_FactMatCost]) + fc;
  end
  else
    DataSet[F_ExpenseCost] := 0;
end;

// Вызывается для того чтобы принудительно пересчитать InternalCalc поля,
// т.к. оказалось, что в D2007 событие пересчета вызывается реже.
procedure TOrderProcessItems.DoProcessItemsCalcFields;
begin
  {if DataSet.State <> dsInternalCalc then  // пытался оптимизировать, так нельзя
    Exit;}
  if not IsPartName then
  begin
    if VarIsNull(DataSet['DateTimeDecomposed']) then
    begin
      FSettingTime := true;
      DataSet['PlanStartTime_ICalc'] := DataSet[F_PlanStart];
      DataSet['FactStartTime_ICalc'] := DataSet[F_FactStart];
      DataSet['PlanFinishTime_ICalc'] := DataSet[F_PlanFinish];
      DataSet['FactFinishTime_ICalc'] := DataSet[F_FactFinish];
      DataSet['DateTimeDecomposed'] := true;
      FSettingTime := false;
    end;
    CalcCosts(DataSet);

    // Стоимость работы субподрядчика в грн.
    if NvlBoolean(DataSet[F_ContractorProcess]) then
      DataSet[F_ContractorCostNative] := NvlFloat(DataSet[F_FinalProfitCost]) * Processes.USDCourse
    else
      DataSet[F_ContractorCostNative] := 0;

    DoCalcExpenseCost;

    DataSet['ExecState'] := PlanUtils.CalcExecState(DataSet);
    //PlanUtils.CalcDuration(DataSet);
    // название оборудования
    DataSet[F_EquipName] := GetEquipName(DataSet);
    // название части
    DataSet[F_PartName] := GetPartName(DataSet);
  end;
end;

class function TOrderProcessItems.GetPartName(DataSet: TDataSet): string;
begin
  if NvlInteger(DataSet[F_Part]) = 0 then
    Result := ''
  else
    Result := TConfigManager.Instance.StandardDics.deParts.ItemName[DataSet[F_Part]];
end;

class function TOrderProcessItems.GetEquipName(DataSet: TDataSet): string;
var
  EquipCount: integer;
begin
  if VarIsNull(DataSet[F_EquipCode]) then
    Result := ''
  else
  begin
    //
    EquipCount := NvlInteger(DataSet[F_EquipCount]);
    if EquipCount > 1 then
      Result := '<неск.>'
    else if EquipCount = 1 then
      Result := TConfigManager.Instance.StandardDics.deEquip.ItemName[DataSet[F_EquipCode]]
    else
      Result := ''; // если 0 - не уверен, что может быть такое, на всякий случай
  end;
end;

procedure TOrderProcessItems.ContractorChange(Sender: TField);
begin
  if not ContractorChanging then
  begin
    ContractorChanging := true;
    try
      if not (Sender.DataSet.State in [dsInsert, dsEdit]) then Sender.DataSet.Edit;
      Sender.DataSet[F_ContractorProcess] := not Sender.IsNull;
    finally
      ContractorChanging := false;
    end;
  end;
end;

procedure TOrderProcessItems.ContractorPercentChange(Sender: TField);
begin
  // непонятно зачем это было  13.10.2009
  {if not ContractorChanging then
  begin
    ContractorChanging := true;
    try
      if not (Sender.DataSet.State in [dsInsert, dsEdit]) then Sender.DataSet.Edit;
      Sender.DataSet[F_ContractorProcess] := not Sender.IsNull and (Sender.AsFloat > 0);
    finally
      ContractorChanging := false;
    end;
  end;}
  if (Sender.DataSet.State <> dsInsert) then Sender.DataSet.CheckBrowseMode;
  ProcessParamToProcessData(Sender);
end;

procedure TOrderProcessItems.ContractorProcessChange(Sender: TField);
var
  ItemID, ProcessID: integer;
//  PercentValue: extended;
begin
  ProcessID := 0;
  if not ContractorChanging and (Sender.DataSet.State <> dsInsert) then
  begin
    ContractorChanging := true;
    try
      if not (Sender.DataSet.State in [dsInsert, dsEdit]) then Sender.DataSet.Edit;
      // Запоминаем к какой записи относится изменение признака "Подрядчик"
      ItemID := Sender.DataSet[F_ItemID];
      ProcessID := Sender.DataSet[F_ProcessID];
      if not NvlBoolean(Sender.Value) then
      begin
        Sender.DataSet[F_Contractor] := null;
        Sender.DataSet[F_ContractorPercent] := 0;
        //PercentValue := 0;
      end else
      begin
        // Стал подрядчиком - устанавливаем стандартный процент
        Sender.DataSet[F_ContractorPercent] := FProcesses.ContractorPercent;
        //PercentValue := sm.ContractorPercent;
      end;
    finally
      ContractorChanging := false;
    end;
  end;
  if Sender.DataSet.State = dsEdit then Sender.DataSet.Post;
  // Передаем параметры записи, т.к. функция работает с ProcessItems,
  // а этот обработчик может вызываться для ContractorItems.
//  ProcessParamToProcessDataOverride(Sender, ItemID, PercentValue, ProcessID);
  if ProcessID <> 0 then
    ProcessParamToProcessDataOverride(Sender, ItemID, NvlBoolean(Sender.Value), ProcessID);
end;


procedure TOrderProcessItems.DateGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then Text := ''
  else begin
    if NvlBoolean(Sender.DataSet[F_TrackingEnabled]) then
      Text := DateToStr(Sender.AsDateTime)
    else
      Text := '';
  end;
end;

procedure TOrderProcessItems.TimeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then Text := ''
  else begin
    if NvlBoolean(Sender.DataSet[F_TrackingEnabled]) then
      Text := ExtractTimeStr(Sender.Value)
    else
      Text := '';
  end;
end;

procedure TOrderProcessItems.DescGetText(Sender: TField; var Text: String; DisplayText: Boolean);
var
  f: TField;
begin
  if DisplayText then
  begin
    f := Sender.DataSet.FieldByName(F_IsPartName);
    if f.IsNull or not f.AsBoolean then Text := '   ' + VarToStr(Sender.Value)
    else Text := VarToStr(Sender.Value);
  end else
    Text := VarToStr(Sender.Value);
end;

procedure TOrderProcessItems.DoOnNewRecord;
begin
  if not FDisableProcessItemsNewRecord then
  begin
    DataSet.Tag := DataSet.Tag + 1;
    DataSet['ItemNumber'] := DataSet.Tag;
    DataSet[F_IsPartName] := false;
    DataSet[F_ItemProfit] := 0;
    //SettingItemParam := true;
    // 7 штук заблокировали
    ItemChangeLock.Lock([F_ItemDesc, F_Cost, F_Enabled, F_Part,
      F_ContractorProcess, F_ContractorPercent, F_MatCost]);
    try
      DataSet[F_ItemDesc] := '';
      DataSet[F_Cost] := 0;
      DataSet[F_Enabled] := true;
      DataSet[F_Part] := partNoBinding;
      DataSet[F_ContractorProcess] := false;
      DataSet[F_ContractorPercent] := 0;
      DataSet[F_MatCost] := 0;
      {if not InCalc then begin
        // Состояние выполнения по умолчанию    // 05.02.2004
        if DefProcessExecState > 0 then DataSet[SrvExecStateField] := DefProcessExecState;
      end;}
    finally
      // 7 штук разблокировали
      ItemChangeLock.Unlock(7);
      //SettingItemParam := false;
    end;
    DataSet['IsPaused'] := false;
  end;
  if not FNoModifyTracking then ProcessItemsModified := true;
end;

{procedure TOrderProcessItems.MatAmountGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  try
    if Sender.IsNull or Sender.DataSet['IsPartName'] then Text := ''
    else Text := FormatFloat((Sender as TFloatField).DisplayFormat, Sender.Value);
  except
    Text := '';
  end;
end;}

procedure TOrderProcessItems.ProcessParamToProcessData(Sender: TField);
begin
  if not FNoModifyTracking then ProcessItemsModified := true;
  ProcessParamToProcessDataOverride(Sender, -1, 0, -1);
end;

// Синхронизация: переносит значение поля из общей таблицы процессов (ProcessItems) в таблицу процесса
// Если указаны значения OverrideItemID, OverrideFieldValue, OverrideProcessID, то берутся
// они, а не текущие значения поля.
procedure TOrderProcessItems.ProcessParamToProcessDataOverride(Sender: TField;
  OverrideItemID: integer; OverrideFieldValue: variant; OverrideProcessID: integer);
var
  dq: TDataSet;
  Srv: TPolyProcess;
  CurItemID: integer;
  f: TField;
begin
  if ItemChangeLock.Find(Sender.FieldName) {or (MForm.ViewMode <> vmRight)} then Exit;
  dq := Sender.DataSet;
  if not NvlBoolean(dq[F_IsPartName]) or (OverrideItemID > 0) then
  begin
    if OverrideProcessID <= 0 then OverrideProcessID := dq['ProcessID'];
    Srv := FProcesses.ServiceByID(OverrideProcessID, true);  // автооткрытие
    if not Srv.DataSet.Active then Exit;
    CurItemID := NvlInteger(Srv.DataSet[F_ItemID]);
    Srv.DataSet.DisableControls;
    try
      if OverrideItemID <= 0 then  // в этом случае переданные значения не учитываем
      begin
        OverrideItemID := dq[F_ItemID];
        OverrideFieldValue := Sender.Value;
      end;
      if Srv.DataSet.Locate(F_ItemID, OverrideItemID, []) then
      begin
        f := Srv.DataSet.FieldByName(Sender.FieldName);
        if VarIsNull(f.Value) or (f.Value <> OverrideFieldValue) then
        begin
          if not (Srv.DataSet.State in [dsInsert, dsEdit]) then Srv.DataSet.Edit;
          ProcessChangeLock.Lock(Sender.FieldName);
          try
            f.Value := OverrideFieldValue;
            Srv.DataSet.Post;
          finally
            ProcessChangeLock.Unlock;
          end;
        end;
        Srv.DataSet.Locate(F_ItemID, CurItemID, []);
      end;
    finally
      Srv.DataSet.EnableControls;
    end;
  end;
  AnyChange(Sender);
end;

procedure TOrderProcessItems.ContractorCostChange(Sender: TField);
begin
  if not IsPartName and NvlBoolean(DataSet[F_ManualContractorCost]) then
  begin
    if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
    DataSet[F_FactContractorCost] := DataSet[F_ContractorCost];
  end;
  AnyChange(Sender);
end;

procedure TOrderProcessItems.FactContractorCostChange(Sender: TField);
var
  cd: TDataSet;
begin
  if LockManualContractorCost then Exit;
  cd := Sender.DataSet;
  // Если указана реальная стоимость субподряда, то установить флажок ручной установки
  if not NvlBoolean(cd[F_ManualContractorCost]) and
    not VarIsNull(cd[F_FactContractorCost]) then
  begin
    if not (cd.State in [dsInsert, dsEdit]) then cd.Edit;
    cd[F_ManualContractorCost] := true;
    cd.Post;
  end
  // Иначе если уже ручная и поле очистили то сбросить флажок
  else
  if NvlBoolean(cd[F_ManualContractorCost]) then
  begin
    if not (cd.State in [dsInsert, dsEdit]) then cd.Edit;
    LockManualContractorCost := true;
    try
      cd[F_ManualContractorCost] := false;
      cd[F_FactContractorCost] := null;//cd[F_ContractorCost];
      cd.Post;
    finally
      LockManualContractorCost := false;
    end;
  end;
  AnyChange(Sender);
end;

procedure TOrderProcessItems.DoAfterApplyUpdates;
var
  NewID, NewItemID: integer;
begin
  // Заменяем LinkedItemID связанные со вставленными записями на реальные
  DataSet.DisableControls;
  try
    DataSet.First;
    while not DataSet.Eof do
    begin
      if not IsPartName and (NvlInteger(DataSet[F_LinkedItemID]) > 0) then
      begin
        // Если есть в списке вставленных, то берем реальный
        NewID := ItemIDs.GetRealItemID(DataSet[F_LinkedItemID], false);
        NewItemID := ItemIDs.GetRealItemID(DataSet[F_ItemID], false);
        if NewID > 0 then
          UpdateLinkedItemID(NewItemID, NewID);
      end;
      DataSet.Next;
    end;
  finally
    DataSet.EnableControls;
  end;
end;

procedure TOrderProcessItems.UpdateLinkedItemID(ItemID: integer; LinkedItemID: integer);
begin
  Database.ExecuteNonQuery('update OrderProcessItem set LinkedItemID = ' + IntToStr(LinkedItemID)
    + ' where ItemID = ' + IntToStr(ItemID));
end;

type
  TStringArray = array of string;

function MakeArray(a: array of string): TStringArray;
var
  I: Integer;
  ACopy: TStringArray;
begin
  SetLength(ACopy, Length(a));
  for I := 0 to High(a) do    // Iterate
  begin
    ACopy[i] := a[i];
  end;    // for
  Result := ACopy;
end;

procedure TOrderProcessItems.ProviderBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
  UpdateKind: TUpdateKind; var Applied: Boolean);
var
  TmpID: integer;
  //Srv: TPolyProcess;
  NewItemID: integer;
  StdItemParams: TStringArray;
begin
  StdItemParams := MakeArray([F_Part, F_ItemDesc, F_Cost,
        F_Enabled, F_ProcessID, F_ItemProfit, 'IsItemInProfit', F_EquipCode,
        'ProductIn', TOrderProcessItems.F_ProductOut, 'Multiplier', 'SideCount',
        F_Contractor, F_ContractorPercent, F_ContractorProcess,
        F_OwnCost, F_OwnPercent, F_MatCost, F_MatPercent, F_ContractorCost,
        F_FactContractorCost, F_EstimatedDuration, F_LinkedItemID,
        F_PlanStart, F_PlanFinish,
        { Плановые даты будут учтены только для субподрядных или непланируемых процессов }
        F_FactStart, F_FactFinish, F_ContractorPayDate]);
  if UpdateKind = ukInsert then
  begin
    if not DeltaDS[F_IsPartName] then
    begin
      //Srv := sm.ServiceByID(DeltaDS['ProcessID'], false);
      TmpID := DeltaDS[F_ItemID];
      dm.aspNewOrderProcessItem.Parameters.ParamByName('@OrderID').Value := (FProcesses.ParentOrder as TOrder).NewOrderKey;
      // При добавлении новой записи в OrderProcessItem у нас будет ровно
      // одна соотв. запись в Jobs, поэтому передаем еще эти параметры
      AssignProcParams(dm.aspNewOrderProcessItem, DeltaDS,
        [TOrderProcessItems.F_FactProductIn, TOrderProcessItems.F_FactProductOut]);
      AssignProcParams(dm.aspNewOrderProcessItem, DeltaDS, StdItemParams);
      dm.aspNewOrderProcessItem.ExecProc;
      NewItemID := dm.aspNewOrderProcessItem.Parameters[0].Value;
      FItemIDs.AddRealItemID(TmpID, NewItemID);
      Applied := true;
      {if Srv.DataSet.Locate(SrvItemKeyField, TmpID, []) then begin
          Srv.DataSet.Edit;
          Srv.DataSet[SrvItemKeyField] := NewItemID;
          Srv.DataSet.Post;
      end else raise EDatabaseError.Create('Не найдена запись при обновлении. Процесс ' + Srv.ServiceName);}
    end
    else
      Applied := true;   // добавленные названия частей не сохраняем, конечно
  end
  else
  if UpdateKind = ukModify then
  begin
    //AssignProcParams(aspUpdateOrderProcessItem, DeltaDS, [F_OverwriteEquipCode]);
    AssignProcParams(dm.aspUpdateOrderProcessItem, DeltaDS, StdItemParams);
    AssignProcParamsOldValue(dm.aspUpdateOrderProcessItem, DeltaDS,
      [F_PlanStart, F_PlanFinish, F_FactStart, F_FactFinish]);
    // pass old value of key to proc
    dm.aspUpdateOrderProcessItem.Parameters.ParamByName('@' + F_ItemID).Value := DeltaDS.FieldByName(F_ItemID).OldValue;
    dm.aspUpdateOrderProcessItem.ExecProc;
    Applied := true;
  end
  else
  if UpdateKind = ukDelete then
  begin
    Database.ExecuteNonQuery('exec up_DeleteOrderProcessItem ' + VarToStr(DeltaDS.FieldByName(F_ItemID).OldValue));
    Applied := true;
  end;
end;

procedure TOrderProcessItems.DisableGrandTotal;
begin
  if DataSet.Active then
    (DataSet as TClientDataSet).AggregatesActive := false;
end;

procedure TOrderProcessItems.EnableGrandTotal;
begin
  if DataSet.Active then
    (DataSet as TClientDataSet).AggregatesActive := true;
end;

procedure TOrderProcessItems.AddPartRecords;

  function IsEmptyTime(_Time: TDateTime): boolean;
  var
    Hour, Min, Sec, MSec: Word;
  begin
    DecodeTime(_Time, Hour, Min, Sec, MSec);
    // время 12:00:33 означает, что поле пустое
    Result := (Sec = 33);
  end;

  procedure SetTimeValue(cd: TDataSet; const DateFieldName, TimeFieldName: string);
  begin
    if varIsNull(cd[DateFieldName]) or IsEmptyTime(cd[DateFieldName]) then
      cd[TimeFieldName] := null
    else
      cd[TimeFieldName] := cd[DateFieldName];
  end;

var
  ItemNumber, Part, CurPart {PrevItemNumber, ItemCount}: integer;
  //dePart: TDicElement;
  HasPart: boolean;
begin
  if DataSet.RecordCount > 0 then
  begin
    DataSet.DisableControls;
    // упорядочиваем по части т.к. могли добавиться новые строки
    (DataSet as TClientDataSet).IndexName := 'cdProcessItemsPart';
    FNoModifyTracking := true;
    FDisableProcessItemsNewRecord := true;
    try
      HasPart := false;
      // проверяем, есть ли вообще части
      DataSet.First;
      while not DataSet.eof do begin
        if not VarIsNull(DataSet[F_Part]) and (DataSet[F_Part] > 0) then begin
          HasPart := true;
          break;
        end;
        DataSet.Next;
      end;
      CurPart := 0;
      ItemNumber := 1;
      //PrevItemNumber := 0;
      //ItemCount := 0;
      DataSet.First;
      // HasPart означает, что в заказе есть части.
      // вставляем названия частей между строчками
      while not DataSet.eof do
      begin
        if VarIsNull(DataSet[F_Part]) then break;
        DataSet.Edit;
        DataSet[F_IsPartName] := false;
        DataSet['ItemNumber'] := ItemNumber;
        SetTimeValue(DataSet, F_PlanStart, 'PlanStartTime_ICalc');
        SetTimeValue(DataSet, F_PlanFinish, 'PlanFinishTime_ICalc');
        SetTimeValue(DataSet, F_FactStart, 'FactStartTime_ICalc');
        SetTimeValue(DataSet, F_FactFinish, 'FactFinishTime_ICalc');
        // считаем кол-во процессов субподрядчика
        {if ContractorProcess then
          Inc(ItemCount);}
        if HasPart then
        begin
          Part := DataSet[F_Part];
          if (Part <> CurPart) and (Part <> 0) and not DataSet[F_HideItem] then
          begin
            // Другая часть - значит надо добавить запись с названием части
            DataSet['ItemNumber'] := ItemNumber + 1;  // текущая запись будет идти после названия части
            {// Отмечаем в предыдущей части количество процессов СУБПОДРЯДЧИКА,
            // чтобы можно было отфильтровать записи без процессов.
            if PrevItemNumber <> 0 then
              if DataSet.Locate('ItemNumber', PrevItemNumber, []) then
              begin
                DataSet.Edit;
                DataSet['ProductIn'] := ItemCount;  // используется для счетчика
              end else
                raise EAssertionFailed.Create('Не найдена часть с номером записи ' + IntToStr(PrevItemNumber));}
            // сброс счетчика записей в части
            //ItemCount := 0;
            // добавляем запись для части
            DataSet.Append;
            if Part <> 0 then
              DataSet[F_ItemDesc] := TConfigManager.Instance.StandardDics.deParts.ItemName[Part]
            else
              DataSet[F_ItemDesc] := 'другое';
            DataSet[F_IsPartName] := true;
            DataSet[F_HideItem] := false;
            DataSet['ItemNumber'] := ItemNumber;  // номер записи
            // Закомментировал другое использование этого поля выше, т.к. оно не работает,
            // и сейчас использую для сохранения номера части. В поле Part писать нельзя, т.к.
            // индекс по нему построен.
            DataSet['ProductIn'] := Part;
            //PrevItemNumber := ItemNumber;
            DataSet[F_Enabled] := true;
            CurPart := Part;
            // Запись добавилась в конец, поэтому возвращаемся обратно
            DataSet.Locate('ItemNumber', ItemNumber + 1, []);
            Inc(ItemNumber);
          end;
        end;
        Inc(ItemNumber);
        DataSet.Next;
      end;
      {// ставим кол-во процессов в последней части
      if PrevItemNumber <> 0 then
        if DataSet.Locate('ItemNumber', PrevItemNumber, []) then
        begin
          DataSet.Edit;
          DataSet['ProductIn'] := ItemCount;  // используется для счетчика
        end else
          raise EAssertionFailed.Create('Не найдена часть с номером записи ' + IntToStr(PrevItemNumber));}
      // Здесь сохраняем кол-во записей. Зачем не помню !!!! ??????????
      DataSet.Tag := ItemNumber;

      // Присваиваем частям их номера, чтобы они встали на нужные места после упорядочения 
      (DataSet as TClientDataSet).IndexName := '';
      DataSet.First;
      while not DataSet.eof do
      begin
        //RusMessageDlg(VarToStr(DataSet['ItemDesc']) + ', ' + VarToStr(DataSet[F_Part]) + ', ' + VarToStr(DataSet['SequenceOrder']), mtInformation, [mbOk], 0);
        if DataSet[F_IsPartName] then
        begin
          DataSet.Edit;
          DataSet[F_Part] := DataSet['ProductIn'];
          DataSet[F_SequenceOrder] := 0;
        end;
        DataSet.Next;
      end;
      DataSet.CheckBrowseMode;
    finally
      //DataSet.IndexName := 'cdProcessItemsItemNumber';
      //DataSet.IndexFieldNames := 'ItemNumber';
      (DataSet as TClientDataSet).IndexName := 'cdProcessItemsSequenceOrder';
      DataSet.EnableControls;
      FDisableProcessItemsNewRecord := false;
      FNoModifyTracking := false;
    end;
  end;
end;

procedure TOrderProcessItems.DeletePartRecords;
begin
  if DataSet.RecordCount > 0 then
  begin
    DataSet.DisableControls;
    FNoModifyTracking := true;
    try
      DataSet.First;
      while not DataSet.eof do
      begin
        if IsPartName then
        begin
          FPartDeleting := true;
          try
            DataSet.Delete;
          finally
            FPartDeleting := false;
          end;
        end
        else
          DataSet.Next;
      end;
    finally
      DataSet.EnableControls;
      FNoModifyTracking := false;
    end;
  end;
end;

procedure TOrderProcessItems.RefreshPartRecords;
begin
  DeletePartRecords;
  AddPartRecords;
end;

procedure TOrderProcessItems.UpdateGrandTotal;
begin
  { TODO: надо было наверное этот флажок назвать FAddingParts }
  if not FDisableProcessItemsNewRecord then
  begin
    // предотвращаем обновление общей стоимости во время открытия
    if (DataSet as TClientDataSet).AggregatesActive and TotalCost.Active then
    begin
      FProcesses.TotalOwnCost := NvlFloat(TotalOwnCost.Value);
      FProcesses.TotalContractorCost := NvlFloat(TotalContractorCost.Value);
      FProcesses.TotalMatCost := NvlFloat(TotalMatCost.Value);
      FProcesses.TotalOwnProfitCost := NvlFloat(TotalOwnProfitCost.Value);
      FProcesses.TotalContractorProfitCost := NvlFloat(TotalContractorProfitCost.Value);
      FProcesses.TotalMatProfitCost := NvlFloat(TotalMatProfitCost.Value);
      FProcesses.TotalOwnCostForProfit := NvlFloat(TotalOwnCostForProfit.Value);
      FProcesses.TotalContractorCostForProfit := NvlFloat(TotalContractorCostForProfit.Value);
      FProcesses.TotalMatCostForProfit := NvlFloat(TotalMatCostForProfit.Value);
      FProcesses.TotalExpenseCost := NvlFloat(TotalExpenseCost.Value);

      FProcesses.GrandTotal := FProcesses.TotalOwnProfitCost + FProcesses.TotalContractorProfitCost + FProcesses.TotalMatProfitCost;
    end
    else
    begin
      FProcesses.TotalOwnCost := 0;
      FProcesses.TotalContractorCost := 0;
      FProcesses.TotalMatCost := 0;
      FProcesses.TotalOwnProfitCost := 0;
      FProcesses.TotalContractorProfitCost := 0;
      FProcesses.TotalMatProfitCost := 0;
      FProcesses.GrandTotal := 0;
      FProcesses.TotalExpenseCost := 0;
    end;
  end;
end;

// Сравнивает сохраненные стоимости и пересчитанные и выдает сообщение если отличаются
{procedure TOrderProcessItems.CompareCosts;
var Changed: string;
begin
  DataSet.DisableControls;
  Changed := '';
  try
    DataSet.First;
    while not DataSet.eof do
    begin
      if not IsPartName and NvlBoolean(DataSet[F_Enabled]) and (DataSet[F_EnabledCost] <> DataSet[F_OldCost]) then
        Changed := Changed + ' ' + DataSet[PmProcess.F_ItemDesc] + ' ' + VarToStr(DataSet[F_OldCost]) + ' -> ' + VarToStr(DataSet[F_EnabledCost]) + #13;
      DataSet.Next;
    end;
  finally
    DataSet.EnableControls;
  end;
  if Changed <> '' then
    RusMessageDlg(Changed, mtInformation, [mbOk], 0);
end;}

procedure TOrderProcessItems.DumpProcessItems;
var
  I, R: Integer;
  CurID: integer;
  S: string;
begin
  CurId := DataSet[F_ItemID];
  TLogger.getInstance.Info('---------------------------------------------------------------');
  TLogger.getInstance.Info('Current item id = ' + VarToStr(CurId));
  DataSet.First;
  R := 1;
  while not DataSet.Eof do
  begin
    s := '';
    for I := 0 to DataSet.Fields.Count - 1 do    // Iterate
    begin
      if s <> '' then
        s := s + ', ';
      s := s + DataSet.Fields[i].FieldName + ': ' + VarToStr(DataSet.Fields[i].Value)
    end;    // for
    TLogger.getInstance.Info('Record #' + IntToStr(R) + ' ' + s);
    Inc(R);
    DataSet.Next;
  end;    // while
  DataSet.Locate(F_ItemID, CurID, []);
end;

procedure TOrderProcessItems.SetProcessItemsModified(c: boolean);
begin
  FProcessItemsModified := c;
  UpdateModified;
end;

procedure TOrderProcessItems.UpdateModified;
begin
  if Assigned(FOnUpdateModified) then
    FOnUpdateModified(Self);
end;

procedure TOrderProcessItems.OpenProcessItems(OrderKey: integer; PreviewMode: boolean);
begin
  DisableGrandTotal;
  DataSet.Close;
  // Если OrderDataSet пуст, то здесь просто откроется состав заказа с нулевым ключом
  // TODO: Можно предусмотреть специальную обработку, например, отображать
  // совершенно пустую панель или писать "заказ не выбран".
  if PreviewMode then
  begin
    dm.aqProcessItemsLeft.Parameters[0].Value := OrderKey;
    dm.aqProcessItemsLeft.Parameters[1].Value := OrderKey;
  end
  else
    dm.aqProcessItems.Parameters[0].Value := OrderKey;
  if FPrevProcItemsMode <> PreviewMode then
  begin
    (DataSet as TClientDataSet).IndexName := '';
    if PreviewMode then
    //  (DataSet as TClientDataSet).SetProvider(dm.pvProcessItemsLeft)
      DataSetProvider.DataSet := dm.aqProcessItemsLeft
    else
    //  (DataSet as TClientDataSet).SetProvider(dm.pvProcessItems);
      DataSetProvider.DataSet := dm.aqProcessItems;
  end;

  Materials.Close;
  Operations.Close;
  Materials.OrderID := OrderKey;
  //Materials.OrderID := OrderKey;
  Operations.OrderID := OrderKey;

  Open;
  if not PreviewMode then
    UpdateFactMatCost;

  FPrevProcItemsMode := PreviewMode;
  if not FPrevProcItemsMode then
    ProcessItemsModified := false;

  //Materials.Open;
  //Operations.Open;
end;

procedure TOrderProcessItems.UpdateFactMatCost;
var
  ds: TDataSet;
  CurKey: integer;
begin
  ds := DataSet;
  if not ds.IsEmpty then
  begin
    CurKey := KeyValue;
    ds.First;
    while not ds.eof do
    begin
      if not IsPartName then
      begin
        DataSet.Edit;
        DataSet[F_FactMatCost] := Materials.GetFactMaterialCost(KeyValue);
      end;
      ds.Next;
    end;
    if ds.State = dsEdit then ds.Post;
    if CurKey <> 0 then Locate(CurKey);
  end;
end;

procedure TOrderProcessItems.UpdateContractorPercent(Sender: TObject);
var
  ds: TDataSet;
  CurKey: integer;
begin
  ds := DataSet;
  if not ds.IsEmpty then
  begin
    CurKey := KeyValue;
    ds.First;
    while not ds.eof do
    begin
      if not IsPartName and ContractorProcess then
      begin
        if ds['ContractorPercent'] <> FProcesses.ContractorPercent then
        begin
          ds.Edit;
          ds['ContractorPercent'] := FProcesses.ContractorPercent;
        end;
      end;
      ds.Next;
    end;
    if ds.State = dsEdit then ds.Post;
    if CurKey <> 0 then Locate(CurKey);
  end;
end;

procedure TOrderProcessItems.UpdateOwnPercent(Sender: TObject);
var
  ds: TDataSet;
  CurKey: integer;
begin
  ds := DataSet;
  if not ds.IsEmpty then
  begin
    CurKey := KeyValue;
    ds.First;
    while not ds.eof do
    begin
      if not IsPartName and not ContractorProcess then
      begin
        if ds[F_OwnPercent] <> FProcesses.OwnPercent then
        begin
          ds.Edit;
          ds[F_OwnPercent] := FProcesses.OwnPercent;
        end;
      end;
      ds.Next;
    end;
    if ds.State = dsEdit then
      ds.Post;
    if CurKey <> 0 then
      Locate(CurKey);
  end;
end;

procedure TOrderProcessItems.UpdateMatPercent(Sender: TObject);
var
  ds: TDataSet;
  CurKey: integer;
begin
  ds := DataSet;
  if not ds.IsEmpty then
  begin
    CurKey := KeyValue;
    ds.First;
    while not ds.eof do
    begin
      if not IsPartName and (ds[F_MatPercent] <> FProcesses.MatPercent) then
      begin
        ds.Edit;
        ds[F_MatPercent] := FProcesses.MatPercent;
      end;
      ds.Next;
    end;
    if ds.State = dsEdit then ds.Post;
    if CurKey <> 0 then
      Locate(CurKey);
  end;
end;

procedure TOrderProcessItems.SetProtection(_CostProtected, _ContentProtected: boolean);
begin
  Materials.ReadOnly := _ContentProtected;
  Materials.CostReadOnly := _CostProtected;
end;

function TOrderProcessItems.GetRealProcessItemID(id: integer): integer;
begin
  Result := ItemIDs.GetRealItemID(id, true);
end;

{$REGION 'Data properties'}

function TOrderProcessItems.GetMatCost: extended;
begin
  Result := NvlFloat(DataSet[F_MatCost]);
end;

procedure TOrderProcessItems.SetMatCost(Value: extended);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_MatCost] := Value;
end;

function TOrderProcessItems.GetFactMatCost: extended;
begin
  Result := NvlFloat(DataSet[F_FactMatCost]);
end;

procedure TOrderProcessItems.SetFactMatCost(Value: extended);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_FactMatCost] := Value;
  // Обновляем сумму затрат
  {if DataSet.State in [dsInsert, dsEdit] then
    DataSet.Post;}
  DoCalcExpenseCost;
  if DataSet.State in [dsInsert, dsEdit] then
    DataSet.Post;
  UpdateGrandTotal;
end;

function TOrderProcessItems.GetEnabledCost: extended;
begin
  Result := NvlFloat(DataSet[F_EnabledCost]);
end;

function TOrderProcessItems.GetHideItem: boolean;
begin
  Result := NvlBoolean(DataSet[F_HideItem]);
end;

procedure TOrderProcessItems.SetHideItem(Value: boolean);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_HideItem] := Value;
end;

function TOrderProcessItems.GetTrackingEnabled: boolean;
begin
  Result := NvlBoolean(DataSet[F_TrackingEnabled]);
end;

procedure TOrderProcessItems.SetTrackingEnabled(Value: boolean);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_TrackingEnabled] := Value;
end;

function TOrderProcessItems.GetPlanningEnabled: boolean;
begin
  Result := NvlBoolean(DataSet[F_PlanningEnabled]);
end;

procedure TOrderProcessItems.SetPlanningEnabled(Value: boolean);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_PlanningEnabled] := Value;
end;

function TOrderProcessItems.GetIsPartName: boolean;
begin
  Result := NvlBoolean(DataSet[F_IsPartName]);
end;

procedure TOrderProcessItems.SetIsPartName(Value: boolean);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_IsPartName] := Value;
end;

function TOrderProcessItems.GetSequenceOrder: integer;
begin
  Result := NvlInteger(DataSet[F_SequenceOrder]);
end;

procedure TOrderProcessItems.SetSequenceOrder(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_SequenceOrder] := Value;
end;

function TOrderProcessItems.GetContractorProcess: boolean;
begin
  Result := NvlBoolean(DataSet[F_ContractorProcess]);
end;

procedure TOrderProcessItems.SetContractorProcess(Value: boolean);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_ContractorProcess] := Value;
end;

// Добавить информацию о материале для записи процесса с указанным ключом
procedure TOrderProcessItems.SetMaterial(ItemKey: integer; MatTypeName: string; MatDesc: string;
  MatAmount: extended; MatUnitName: string; MatCost: extended;
  ReplaceAnyType: boolean; Resolver: TMatResolveEvent);
begin
  if Locate(ItemKey) then
  begin
    if NvlBoolean(DataSet[F_Enabled]) then
      FMaterials.SetMaterial(ItemKey, MatTypeName, MatDesc, MatAmount, MatUnitName,
        MatCost, ReplaceAnyType, Resolver);
  end;
end;

procedure TOrderProcessItems.SetMaterialEx(ItemKey: integer; MatTypeName: string;
  MatDesc: string; MatParam1, MatParam2, MatParam3: variant;
  MatAmount: extended; MatUnitName: string; MatCost: extended;
  ReplaceAnyType: boolean; Resolver: TMatResolveEvent);
begin
  if Locate(ItemKey) then
  begin
    if NvlBoolean(DataSet[F_Enabled]) then
      FMaterials.SetMaterialEx(ItemKey, MatTypeName, MatDesc, MatParam1, MatParam2, MatParam3,
        MatAmount, MatUnitName, MatCost, ReplaceAnyType, Resolver);
  end;
end;

// Заменить информацию о материале для записи процесса с указанным ключом
procedure TOrderProcessItems.ReplaceMaterial(ItemKey: integer; MatTypeName: string; MatDesc: string;
  MatAmount: extended; MatUnitName: string; MatCost: extended;
  Resolver: TMatResolveEvent);
begin
  if Locate(ItemKey) then
  begin
    if NvlBoolean(DataSet[F_Enabled]) then
      FMaterials.ReplaceMaterial(ItemKey, MatTypeName, MatDesc, MatAmount, MatUnitName,
        MatCost, Resolver);
  end;
end;

// Заменить информацию о материале для записи процесса с указанным ключом
procedure TOrderProcessItems.ReplaceMaterialEx(ItemKey: integer; MatTypeName: string; MatDesc: string;
  MatParam1, MatParam2, MatParam3: variant;
  MatAmount: extended; MatUnitName: string; MatCost: extended;
  Resolver: TMatResolveEvent);
begin
  if Locate(ItemKey) then
  begin
    if NvlBoolean(DataSet[F_Enabled]) then
      FMaterials.ReplaceMaterialEx(ItemKey, MatTypeName, MatDesc,
        MatParam1, MatParam2, MatParam3, MatAmount, MatUnitName, MatCost, Resolver);
  end;
end;

// Удалить материалы для записи процесса с указанным ключом
procedure TOrderProcessItems.ClearMaterial(ItemKey: integer; MatTypeName: string;
  Resolver: TMatResolveEvent);
begin
  FMaterials.ClearMaterial(ItemKey, MatTypeName, Resolver);
end;

// Установить фактические параметры материала
procedure TOrderProcessItems.SetFactMaterial(ItemKey: integer; MatTypeName: string;
  _FactAmount, _FactCost: variant);
begin
  if Locate(ItemKey) then
  begin
    if NvlBoolean(DataSet[F_Enabled]) then
      FMaterials.SetFactMaterial(ItemKey, MatTypeName, _FactAmount, _FactCost);
  end;
end;

function TOrderProcessItems.HandleGetCourse: extended;
begin
  Result := FProcesses.USDCourse;
end;

{$ENDREGION}

end.
