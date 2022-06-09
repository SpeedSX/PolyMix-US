unit PmEntSettings;

interface

uses PmEntity;

const
  AutoPayState_OrderTotal = 0;
  AutoPayState_InvoicePosition = 1;
  AutoPayState_InvoiceTotal = 2;
  AutoPayState_OldInvoices = 3;

type
  TRoundType = (rndBy1, rndByDig, rndNo);

  TEntSettings = class(TEntity)
    procedure DoAfterConnect; override;
  private
    function GetAutoPayState: Boolean;
    function GetPayStateMode: integer;
    function GetBriefOrderID: Boolean;
    function GetGetCourseOnStart: Boolean;
    function GetEditLock: Boolean;
    function GetExecNewRecordAfterInsert: Boolean;
    function GetNativeCurrency: Boolean;
    function GetPermitFilterOff: Boolean;
    function GetPermitKindChange: Boolean;
    function GetRequireActivity: Boolean;
    function GetRequireBranch: Boolean;
    function GetRequireCustomer: Boolean;
    function GetRequireFinishDate: Boolean;
    function GetRequireFirmType: Boolean;
    function GetRequireFullName: Boolean;
    function GetRequireInfoSource: Boolean;
    function GetRequireProductType: Boolean;
    function GetRoundPrecision: Integer;
    function GetRoundTotalMode: TRoundType;
    function GetRoundUSD: Boolean;
    function GetShowAddPlanDialog: Boolean;
    function GetNewPlanInterface: Boolean;
    function GetCheckOverdueJobs: Boolean;
    function GetShowSyncInfo: Boolean;
    function GetLockSyncData: Boolean;
    function GetFactDateStrictOrder: Boolean;
    function GetRequireFactProductOut: Boolean;
    function GetJobColorByExecState: Boolean;
    function GetPlanShowExecState: Boolean;
    function GetPlanShowOrderState: Boolean;
    function GetShowExpenseCost: Boolean;
    function GetShipmentApprovement: Boolean;
    function GetOrderMaterialsApprovement: Boolean;
    function GetAllowCostProtect: Boolean;
    function GetRedScheduleSpace: Boolean;
    function GetFileStoragePath: string;
    function GetSplitJobs: boolean;
    function GetInvoiceAllPayments: boolean;
    function GetShowPartialInvoice: boolean;
    function GetShowContragentFullName: boolean;
    function GetAllContractors: boolean;
    function GetSyncProducts: boolean;
    function GetNewInvoicePayState: boolean;
    function GetShowInvoicePayerFilter: boolean;
    function GetShowInvoiceCustomerFilter: boolean;
    function GetShowExternalId: boolean;

    procedure SetPayStateMode(const Value: integer);
    procedure SetRequireActivity(const Value: Boolean);
    procedure SetRequireBranch(const Value: Boolean);
    procedure SetRequireCustomer(const Value: Boolean);
    procedure SetRequireFinishDate(const Value: Boolean);
    procedure SetRequireFirmType(const Value: Boolean);
    procedure SetRequireFullName(const Value: Boolean);
    procedure SetRequireInfoSource(const Value: Boolean);
    procedure SetRequireProductType(const Value: Boolean);
    procedure SetRoundPrecision(const Value: Integer);
    procedure SetRoundTotalMode(const Value: TRoundType);
    procedure SetRoundUSD(const Value: Boolean);
    procedure SetShowAddPlanDialog(const Value: Boolean);
    procedure SetNewPlanInterface(const Value: Boolean);
    procedure SetCheckOverdueJobs(const Value: Boolean);
    procedure SetShowSyncInfo(const Value: Boolean);
    procedure SetLockSyncData(const Value: Boolean);
    procedure SetFactDateStrictOrder(const Value: Boolean);
    procedure SetRequireFactProductOut(const Value: Boolean);
    procedure SetJobColorByExecState(const Value: Boolean);
    procedure SetPlanShowExecState(const Value: Boolean);
    procedure SetPlanShowOrderState(const Value: Boolean);
    procedure SetShipmentApprovement(const Value: Boolean);
    procedure SetOrderMaterialsApprovement(const Value: Boolean);
    procedure SetShowExpenseCost(const Value: Boolean);
    procedure SetAllowCostProtect(const Value: Boolean);
    procedure SetRedScheduleSpace(const Value: Boolean);
    procedure SetFileStoragePath(const Value: string);
    procedure SetSplitJobs(const Value: boolean);
    procedure SetInvoiceAllPayments(const Value: boolean);
    procedure SetShowPartialInvoice(const Value: boolean);
    procedure SetShowContragentFullName(const Value: boolean);
    procedure SetAllContractors(const Value: boolean);
    procedure SetSyncProducts(const Value: boolean);
    procedure SetNewInvoicePayState(const Value: boolean);
    procedure SetShowInvoicePayerFilter(const Value: boolean);
    procedure SetShowInvoiceCustomerFilter(const Value: boolean);
    procedure SetShowExternalId(const Value: boolean);
    function GetVATPercent: double;
    procedure SetVATPercent(val: double);
  public
    procedure Open; override;
    constructor Create; override;

    property AutoPayState: Boolean read GetAutoPayState;
    property PayStateMode: integer read GetPayStateMode write SetPayStateMode;
    property BriefOrderID: Boolean read GetBriefOrderID;
    property EditLock: boolean read GetEditLock;
    property ExecNewRecordAfterInsert: Boolean read GetExecNewRecordAfterInsert;
    property GetCourseOnStart: Boolean read GetGetCourseOnStart;
    property NativeCurrency: Boolean read GetNativeCurrency;
    property PermitFilterOff: Boolean read GetPermitFilterOff;
    property PermitKindChange: Boolean read GetPermitKindChange;
    property RequireActivity: Boolean read GetRequireActivity write SetRequireActivity;
    property RequireBranch: Boolean read GetRequireBranch write SetRequireBranch;
    property RequireCustomer: Boolean read GetRequireCustomer write SetRequireCustomer;
    property RequireFinishDate: Boolean read GetRequireFinishDate write SetRequireFinishDate;
    property RequireFirmType: Boolean read GetRequireFirmType write SetRequireFirmType;
    property RequireFullName: Boolean read GetRequireFullName write SetRequireFullName;
    property RequireInfoSource: Boolean read GetRequireInfoSource write SetRequireInfoSource;
    property RequireProductType: Boolean read GetRequireProductType write SetRequireProductType;
    property RoundPrecision: Integer read GetRoundPrecision write SetRoundPrecision;
    property RoundTotalMode: TRoundType read GetRoundTotalMode write SetRoundTotalMode;
    property RoundUSD: Boolean read GetRoundUSD write SetRoundUSD;
    property ShowAddPlanDialog: Boolean read GetShowAddPlanDialog write SetShowAddPlanDialog;
    property NewPlanInterface: Boolean read GetNewPlanInterface write SetNewPlanInterface;
    property VATPercent: double read GetVATPercent write SetVATPercent;
    property CheckOverdueJobs: boolean read GetCheckOverdueJobs write SetCheckOverdueJobs;
    property ShowSyncInfo: boolean read GetShowSyncInfo write SetShowSyncInfo;
    property LockSyncData: boolean read GetLockSyncData write SetLockSyncData;
    property FactDateStrictOrder: boolean read GetFactDateStrictOrder write SetFactDateStrictOrder;
    property RequireFactProductOut: boolean read GetRequireFactProductOut write SetRequireFactProductOut;
    property JobColorByExecState: boolean read GetJobColorByExecState write SetJobColorByExecState;
    property PlanShowExecState: boolean read GetPlanShowExecState write SetPlanShowExecState;
    property PlanShowOrderState: boolean read GetPlanShowOrderState write SetPlanShowOrderState;
    property ShipmentApprovement: boolean read GetShipmentApprovement write SetShipmentApprovement;
    property OrderMaterialsApprovement: boolean read GetOrderMaterialsApprovement write SetOrderMaterialsApprovement;
    property FileStoragePath: string read GetFileStoragePath write SetFileStoragePath;
    property ShowExpenseCost: boolean read GetShowExpenseCost write SetShowExpenseCost;
    property AllowCostProtect: boolean read GetAllowCostProtect write SetAllowCostProtect;
    property RedScheduleSpace: boolean read GetRedScheduleSpace write SetRedScheduleSpace;
    property SplitJobs: boolean read GetSplitJobs write SetSplitJobs;
    property InvoiceAllPayments: boolean read GetInvoiceAllPayments write SetInvoiceAllPayments;
    property ShowPartialInvoice: boolean read GetShowPartialInvoice write SetShowPartialInvoice;
    property ShowContragentFullName: boolean read GetShowContragentFullName write SetShowContragentFullName;
    property AllContractors: boolean read GetAllContractors write SetAllContractors;
    property SyncProducts: boolean read GetSyncProducts write SetSyncProducts;
    property NewInvoicePayState: boolean read GetNewInvoicePayState write SetNewInvoicePayState;
    property ShowInvoicePayerFilter: boolean read GetShowInvoicePayerFilter write SetShowInvoicePayerFilter;
    property ShowInvoiceCustomerFilter: boolean read GetShowInvoiceCustomerFilter write SetShowInvoiceCustomerFilter;
    property ShowExternalId: boolean read GetShowExternalId write SetShowExternalId;
//    property ShowFinalNative: boolean read GetShowFinalNative write SetShowFinalNative;
    const
      EditLockConfirmInterval = 15;   // интервал (СЕКУНД) подтверждения блокировки при редактировании заказа
      EditLockTimeoutInterval = 60;   // интервал (СЕКУНД), после которого блокировка считается недействительной
  end;

var
  EntSettings: TEntSettings;

implementation

uses SysUtils, MainData, RDBUtils;

const
  F_Key = 'SettingID';

constructor TEntSettings.Create;
begin
  inherited Create;
  FKeyField := F_Key;
end;

procedure TEntSettings.DoAfterConnect;
begin
  SetDataSet(dm.cdEntSettings);
  DataSetProvider := dm.pvEntSettings;
  //ADODataSet := dm.aqEntSettings;
end;

function TEntSettings.GetAutoPayState: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['AutoPayState'];
end;

function TEntSettings.GetPayStateMode: integer;
begin
  if not DataSet.Active then Open;
  Result := DataSet['PayStateMode'];
end;

function TEntSettings.GetBriefOrderID: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['BriefOrderID'];
end;

function TEntSettings.GetEditLock: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['EditLock'];
end;

function TEntSettings.GetExecNewRecordAfterInsert: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['ExecNewRecordAfterInsert'];
end;

function TEntSettings.GetGetCourseOnStart: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['GetCourseOnStart'];
end;

function TEntSettings.GetNativeCurrency: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['NativeCurrency'];
end;

function TEntSettings.GetPermitFilterOff: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['PermitFilterOff'];
end;

function TEntSettings.GetPermitKindChange: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['PermitKindChange'];
end;

function TEntSettings.GetRequireActivity: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['RequireActivity'];
end;

function TEntSettings.GetRequireBranch: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['RequireBranch'];
end;

function TEntSettings.GetRequireCustomer: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['RequireCustomer'];
end;

function TEntSettings.GetRequireFinishDate: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['RequireFinishDate'];
end;

function TEntSettings.GetRequireFirmType: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['RequireFirmType'];
end;

function TEntSettings.GetRequireFullName: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['RequireFullName'];
end;

function TEntSettings.GetRequireInfoSource: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['RequireInfoSource'];
end;

function TEntSettings.GetRequireProductType: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['RequireProductType'];
end;

function TEntSettings.GetRoundPrecision: Integer;
begin
  if not DataSet.Active then Open;
  Result := DataSet['RoundPrecision'];
end;

function TEntSettings.GetRoundTotalMode: TRoundType;
begin
  if not DataSet.Active then Open;
  Result := TRoundType(DataSet['RoundTotalMode']);
end;

function TEntSettings.GetRoundUSD: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['RoundUSD'];
end;

function TEntSettings.GetShowAddPlanDialog: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['ShowAddPlanDialog'];
end;

function TEntSettings.GetNewPlanInterface: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['NewPlanInterface'];
end;

function TEntSettings.GetCheckOverdueJobs: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['CheckOverdueJobs'];
end;

function TEntSettings.GetShowSyncInfo: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['ShowSyncInfo'];
end;

function TEntSettings.GetVATPercent: double;
begin
  if not DataSet.Active then Open;
  Result := NvlFloat(DataSet['VATPercent']);
end;

function TEntSettings.GetLockSyncData: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['LockSyncData'];
end;

function TEntSettings.GetFactDateStrictOrder: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['FactDateStrictOrder'];
end;

function TEntSettings.GetShipmentApprovement: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['ShipmentApprovement'];
end;

function TEntSettings.GetOrderMaterialsApprovement: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['OrderMaterialsApprovement'];
end;

function TEntSettings.GetShowExpenseCost: Boolean;
begin
  if not DataSet.Active then Open;
  Result := NvlBoolean(DataSet['ShowExpenseCost']);
end;

function TEntSettings.GetAllowCostProtect: Boolean;
begin
  if not DataSet.Active then Open;
  Result := NvlBoolean(DataSet['AllowCostProtect']);
end;

function TEntSettings.GetRedScheduleSpace: Boolean;
begin
  if not DataSet.Active then Open;
  Result := NvlBoolean(DataSet['RedScheduleSpace']);
end;

function TEntSettings.GetSplitJobs: boolean;
begin
  if not DataSet.Active then Open;
  Result := NvlBoolean(DataSet['SplitJobs']);
end;

function TEntSettings.GetInvoiceAllPayments: boolean;
begin
  if not DataSet.Active then Open;
  Result := NvlBoolean(DataSet['InvoiceAllPayments']);
end;

function TEntSettings.GetShowPartialInvoice: boolean;
begin
  if not DataSet.Active then Open;
  Result := NvlBoolean(DataSet['ShowPartialInvoice']);
end;

function TEntSettings.GetShowContragentFullName: boolean;
begin
  if not DataSet.Active then Open;
  Result := NvlBoolean(DataSet['ShowContragentFullName']);
end;

function TEntSettings.GetFileStoragePath: string;
begin
  if not DataSet.Active then Open;
  Result := NvlString(DataSet['FileStoragePath']);
end;

function TEntSettings.GetRequireFactProductOut: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['RequireFactProductOut'];
end;

function TEntSettings.GetJobColorByExecState: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['JobColorByExecState'];
end;

function TEntSettings.GetPlanShowExecState: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['PlanShowExecState'];
end;

function TEntSettings.GetPlanShowOrderState: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['PlanShowOrderState'];
end;

function TEntSettings.GetAllContractors: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['AllContractors'];
end;

function TEntSettings.GetSyncProducts: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['SyncProducts'];
end;

function TEntSettings.GetNewInvoicePayState: Boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['NewInvoicePayState'];
end;

function TEntSettings.GetShowInvoicePayerFilter: boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['ShowInvoicePayerFilter'];
end;

function TEntSettings.GetShowInvoiceCustomerFilter: boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['ShowInvoiceCustomerFilter'];
end;

function TEntSettings.GetShowExternalId: boolean;
begin
  if not DataSet.Active then Open;
  Result := DataSet['ShowExternalId'];
end;

procedure TEntSettings.Open;
begin
  inherited Open;
end;

procedure TEntSettings.SetRequireActivity(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['RequireActivity'] := Value;
end;

procedure TEntSettings.SetRequireBranch(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['RequireBranch'] := Value;
end;

procedure TEntSettings.SetRequireCustomer(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['RequireCustomer'] := Value;
end;

procedure TEntSettings.SetRequireFinishDate(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['RequireFinishDate'] := Value;
end;

procedure TEntSettings.SetRequireFirmType(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['RequireFirmType'] := Value;
end;

procedure TEntSettings.SetRequireFullName(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['RequireFullName'] := Value;
end;

procedure TEntSettings.SetRequireInfoSource(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['RequireInfoSource'] := Value;
end;

procedure TEntSettings.SetRequireProductType(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['RequireProductType'] := Value;
end;

procedure TEntSettings.SetRoundPrecision(const Value: Integer);
begin
  DataSet.Edit;
  DataSet['RoundPrecision'] := Value;
end;

procedure TEntSettings.SetRoundTotalMode(const Value: TRoundType);
begin
  DataSet.Edit;
  DataSet['RoundTotalMode'] := Ord(Value);
end;

procedure TEntSettings.SetRoundUSD(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['RoundUSD'] := Value;
end;

procedure TEntSettings.SetShowAddPlanDialog(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['ShowAddPlanDialog'] := Value;
end;

procedure TEntSettings.SetNewPlanInterface(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['NewPlanInterface'] := Value;
end;

procedure TEntSettings.SetCheckOverdueJobs(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['CheckOverdueJobs'] := Value;
end;

procedure TEntSettings.SetVATPercent(val : double);
begin
  DataSet.Edit;
  DataSet['VATPercent'] := Val;
end;

procedure TEntSettings.SetShowSyncInfo(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['ShowSyncInfo'] := Value;
end;

procedure TEntSettings.SetPayStateMode(const Value: integer);
begin
  DataSet.Edit;
  DataSet['PayStateMode'] := Value;
end;

procedure TEntSettings.SetLockSyncData(const Value: boolean);
begin
  DataSet.Edit;
  DataSet['LockSyncData'] := Value;
end;

procedure TEntSettings.SetFactDateStrictOrder(const Value: boolean);
begin
  DataSet.Edit;
  DataSet['FactDateStrictOrder'] := Value;
end;

procedure TEntSettings.SetRequireFactProductOut(const Value: boolean);
begin
  DataSet.Edit;
  DataSet['RequireFactProductOut'] := Value;
end;

procedure TEntSettings.SetJobColorByExecState(const Value: boolean);
begin
  DataSet.Edit;
  DataSet['JobColorByExecState'] := Value;
end;

procedure TEntSettings.SetPlanShowExecState(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['PlanShowExecState'] := Value;
end;

procedure TEntSettings.SetPlanShowOrderState(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['PlanShowOrderState'] := Value;
end;

procedure TEntSettings.SetShipmentApprovement(const Value: boolean);
begin
  DataSet.Edit;
  DataSet['ShipmentApprovement'] := Value;
end;

procedure TEntSettings.SetOrderMaterialsApprovement(const Value: boolean);
begin
  DataSet.Edit;
  DataSet['OrderMaterialsApprovement'] := Value;
end;

procedure TEntSettings.SetShowExpenseCost(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['ShowExpenseCost'] := Value;
end;

procedure TEntSettings.SetAllowCostProtect(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['AllowCostProtect'] := Value;
end;

procedure TEntSettings.SetRedScheduleSpace(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['RedScheduleSpace'] := Value;
end;

procedure TEntSettings.SetSplitJobs(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['SplitJobs'] := Value;
end;

procedure TEntSettings.SetInvoiceAllPayments(const Value: Boolean);
begin
  DataSet.Edit;
  DataSet['InvoiceAllPayments'] := Value;
end;

procedure TEntSettings.SetShowPartialInvoice(const Value: boolean);
begin
  DataSet.Edit;
  DataSet['ShowPartialInvoice'] := Value;
end;

procedure TEntSettings.SetShowContragentFullName(const Value: boolean);
begin
  DataSet.Edit;
  DataSet['ShowContragentFullName'] := Value;
end;

procedure TEntSettings.SetFileStoragePath(const Value: string);
begin
  DataSet.Edit;
  DataSet['FileStoragePath'] := Value;
end;

procedure TEntSettings.SetAllContractors(const Value: boolean);
begin
  DataSet.Edit;
  DataSet['AllContractors'] := Value;
end;

procedure TEntSettings.SetSyncProducts(const Value: boolean);
begin
  DataSet.Edit;
  DataSet['SyncProducts'] := Value;
end;

procedure TEntSettings.SetNewInvoicePayState(const Value: boolean);
begin
  DataSet.Edit;
  DataSet['NewInvoicePayState'] := Value;
end;

procedure TEntSettings.SetShowInvoicePayerFilter(const Value: boolean);
begin
  DataSet.Edit;
  DataSet['ShowInvoicePayerFilter'] := Value;
end;

procedure TEntSettings.SetShowInvoiceCustomerFilter(const Value: boolean);
begin
  DataSet.Edit;
  DataSet['ShowInvoiceCustomerFilter'] := Value;
end;

procedure TEntSettings.SetShowExternalId(const Value: boolean);
begin
  DataSet.Edit;
  DataSet['ShowExternalId'] := Value;
end;

initialization

EntSettings := TEntSettings.Create;

finalization

FreeAndNil(EntSettings);

end.
