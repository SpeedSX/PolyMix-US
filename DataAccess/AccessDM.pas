unit AccessDM;

interface

uses
  SysUtils, Classes, ADODB, DB, Provider, DBClient, Variants,
  CalcSettings, PmDatabase;

type
  Tadm = class(TDataModule, IRCDataModule)
    cdAccessUser: TClientDataSet;
    pvAccessUser: TDataSetProvider;
    cdAccessKind: TClientDataSet;
    pvAccessKind: TDataSetProvider;
    dsAccessKind: TDataSource;
    cdAccessProc: TClientDataSet;
    pvAccessProc: TDataSetProvider;
    dsAccessProc: TDataSource;
    aqAccessUser: TADOQuery;
    aqAccessKind: TADOQuery;
    dsAccessUser: TDataSource;
    aqAccessProc: TADOQuery;
    cdAccessUserAccessUserID: TAutoIncField;
    cdAccessUserLogin: TStringField;
    cdAccessUserName: TStringField;
    cdAccessUserShortName: TStringField;
    cdAccessUserEditUsers: TBooleanField;
    cdAccessUserEditDics: TBooleanField;
    cdAccessUserEditProcesses: TBooleanField;
    cdAccessUserEditModules: TBooleanField;
    cdAccessUserUploadFiles: TBooleanField;
    cdAccessUserSetCourse: TBooleanField;
    cdAccessUserDefaultKindID: TIntegerField;
    cdAccessKindAccessKindID: TAutoIncField;
    cdAccessKindKindID: TIntegerField;
    cdAccessKindUserID: TIntegerField;
    cdAccessKindWorkCreate: TBooleanField;
    cdAccessKindDraftCreate: TBooleanField;
    cdAccessKindWorkUpdate: TBooleanField;
    cdAccessKindDraftUpdate: TBooleanField;
    cdAccessKindWorkDelete: TBooleanField;
    cdAccessKindDraftDelete: TBooleanField;
    cdAccessKindWorkBrowse: TBooleanField;
    cdAccessKindDraftBrowse: TBooleanField;
    cdAccessKindCheckOnSave: TBooleanField;
    cdAccessKindWorkPriceView: TBooleanField;
    cdAccessKindDraftPriceView: TBooleanField;
    cdAccessKindWorkCostView: TBooleanField;
    cdAccessKindDraftCostView: TBooleanField;
    cdAccessKindMakeWork: TBooleanField;
    cdAccessKindMakeDraft: TBooleanField;
    cdAccessKindPlanFinishDate: TBooleanField;
    cdAccessKindPlanStartDate: TBooleanField;
    cdAccessKindFactFinishDate: TBooleanField;
    cdAccessKindFactStartDate: TBooleanField;
    cdAccessKindWorkVisible: TBooleanField;
    cdAccessKindDraftVisible: TBooleanField;
    cdAccessProcAccessKindProcessID: TAutoIncField;
    cdAccessProcKindID: TIntegerField;
    cdAccessProcProcessID: TIntegerField;
    cdAccessProcUserID: TIntegerField;
    cdAccessProcDraftInsert: TBooleanField;
    cdAccessProcDraftUpdate: TBooleanField;
    cdAccessProcDraftDelete: TBooleanField;
    cdAccessProcWorkInsert: TBooleanField;
    cdAccessProcWorkUpdate: TBooleanField;
    cdAccessProcWorkDelete: TBooleanField;
    cdAccessProcPlanDate: TBooleanField;
    cdAccessProcFactDate: TBooleanField;
    cdAccessProcWorkView: TBooleanField;
    cdAccessProcDraftView: TBooleanField;
    cdAccessProcProcessName: TStringField;
    cdAccessUserViewOwnOnly: TBooleanField;
    cdAccessKindShowProfitInside: TBooleanField;
    cdAccessKindShowProfitPreview: TBooleanField;
    cdAccessKindModifyProfit: TBooleanField;
    spCopyUser: TADOStoredProc;
    cdAccessUserRoleID: TIntegerField;
    cdAccessUserIsRole: TBooleanField;
    cdAccessKindWorkUpdateOther: TBooleanField;
    cdAccessKindWorkDeleteOther: TBooleanField;
    cdAccessKindDraftUpdateOther: TBooleanField;
    cdAccessKindDraftDeleteOther: TBooleanField;
    cdAccessKindViewOnlyProtected: TBooleanField;
    cdAccessKindCostProtection: TBooleanField;
    cdAccessKindContentProtection: TBooleanField;
    cdAccessUserPermitPlanView: TBooleanField;
    cdAccessUserEditOwnCustomer: TBooleanField;
    cdAccessUserEditOtherCustomer: TBooleanField;
    cdAccessUserViewOtherCustomer: TBooleanField;
    cdAccessUserChangeCustomerOwner: TBooleanField;
    cdAccessKindChangeOrderOwner: TBooleanField;
    cdAccessUserDataPaging: TBooleanField;
    cdAccessUserViewReports: TBooleanField;
    cdAccessUserEditCustomReports: TBooleanField;
    cdAccessUserDeleteCustomReports: TBooleanField;
    cdAccessUserViewPayments: TBooleanField;
//    cdAccessUserAddPayments: TBooleanField;
    cdAccessUserEditPayments: TBooleanField;
    cdAccessUserAddCustomer: TBooleanField;
    cdAccessUserViewInvoices: TBooleanField;
    cdAccessUserAddInvoices: TBooleanField;
    cdAccessUserDeleteInvoices: TBooleanField;
    cdAccessUserDescribeUbScheduleJob: TBooleanField;
    cdAccessUserViewNotPlanned: TBooleanField;
    cdAccessUserViewProduction: TBooleanField;
    cdAccessUserContragentGroup: TIntegerField;
    cdAccessUserShowDelayedOrders: TBooleanField;
    cdAccessUserViewShipment: TBooleanField;
    cdAccessUserAddShipment: TBooleanField;
    cdAccessUserDeleteShipment: TBooleanField;
    cdAccessUserShipmentApprovement: TBooleanField;
    cdAccessKindUpdatePayConditions: TBooleanField;
    cdAccessKindCancelMaterialRequest: TBooleanField;
    cdAccessKindEditMaterialRequest: TBooleanField;
    cdAccessKindFactCostView: TBooleanField;
    cdAccessUserViewMatRequests: TBooleanField;
    cdAccessUserUpdateMatPayDate: TBooleanField;
    cdAccessUserOrderMaterialsApprovement: TBooleanField;
    cdAccessUserWorkViewOwnOnly: TBooleanField;
    cdAccessUserAddPayments: TBooleanField;
    cdAccessUserSetPaymentStatus: TBooleanField;

    procedure pvAccessUserBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
      UpdateKind: TUpdateKind; var Applied: Boolean);
    procedure pvAccessKindBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
      UpdateKind: TUpdateKind; var Applied: Boolean);
    procedure pvAccessProcBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
      UpdateKind: TUpdateKind; var Applied: Boolean);
    procedure cdAccessUserAfterOpen(DataSet: TDataSet);
    procedure cdAccessUserNewRecord(DataSet: TDataSet);
    procedure pvAccessUserUpdateError(Sender: TObject;
      DataSet: TCustomClientDataSet; E: EUpdateError;
      UpdateKind: TUpdateKind; var Response: TResolverResponse);
  private
    FAfterOpenUsers: TNotifyEvent;
  public
    const
      DefaultUserLogin = 'new_user';

    function AllUsersData: TClientDataSet;
    procedure ApplyUsers(DoOpen: boolean);
    procedure SetUserRights;
    procedure OpenUsers;
    procedure RefreshUsers;
    procedure CloseUsers;
    procedure CancelUsers;
    procedure SetCurUserKind(UserID, KindID: integer);
    function CopyUser(UserID: integer): integer;
    function KindData: TDataSet;
    procedure OpenDataSet(DataSet: TDataSet);
    function ProcessData: TDataSet;
    property AfterOpenUsers: TNotifyEvent read FAfterOpenUsers write
        FAfterOpenUsers;
  end;

var
  adm: Tadm;

implementation

uses RDBUtils, ADOUtils, RDialogs, Dialogs, ExHandler, Forms;

{$R *.dfm}

procedure Tadm.pvAccessUserBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
  UpdateKind: TUpdateKind; var Applied: Boolean);
begin
  DeltaDS.FieldByName('AccessUserID').ProviderFlags := [pfInKey, pfInWhere];
end;

procedure Tadm.pvAccessKindBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
  UpdateKind: TUpdateKind; var Applied: Boolean);
begin
  DeltaDS.FieldByName('AccessKindID').ProviderFlags := [pfInKey, pfInWhere];
end;

procedure Tadm.pvAccessProcBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
  UpdateKind: TUpdateKind; var Applied: Boolean);
begin
  DeltaDS.FieldByName('AccessKindProcessID').ProviderFlags := [pfInKey, pfInWhere];
end;

function Tadm.AllUsersData: TClientDataSet;
begin
  if not cdAccessUser.Active then OpenDataSet(cdAccessUser);
  // сбрасываем фильтр только если он был, чтобы не изменить текущую позицию
  if cdAccessUser.Filtered then cdAccessUser.Filtered := false;
  Result := cdAccessUser;
end;

procedure Tadm.ApplyUsers(DoOpen: boolean);
var
  k1, k2, k3: integer;
  NeedRefreshUsers: boolean;
begin
  if adm.cdAccessUser.State in [dsEdit, dsInsert] then adm.cdAccessUser.Post;
  if adm.cdAccessKind.State in [dsEdit, dsInsert] then adm.cdAccessKind.Post;
  if adm.cdAccessProc.State in [dsEdit, dsInsert] then adm.cdAccessProc.Post;
  k1 := NvlInteger(adm.cdAccessUser['AccessUserID']);
  k2 := NvlInteger(adm.cdAccessKind['AccessKindID']);
  k3 := NvlInteger(adm.cdAccessProc['AccessKindProcessID']);
  NeedRefreshUsers := (adm.cdAccessUser.ChangeCount > 0)
    or (adm.cdAccessKind.ChangeCount > 0) or (adm.cdAccessProc.ChangeCount > 0);
  Database.ApplyDataSet(cdAccessUser);
  Database.ApplyDataSet(cdAccessKind);
  Database.ApplyDataSet(cdAccessProc);
  adm.CloseUsers;
  if DoOpen then
  begin
    adm.OpenUsers;
    if NeedRefreshUsers then SetUserRights;
    adm.cdAccessUser.Locate('AccessUserID', k1, []);
    adm.cdAccessKind.Locate('AccessKindID', k2, []);
    adm.cdAccessProc.Locate('AccessKindProcessID', k3, []);
  end;
end;

procedure Tadm.OpenUsers;
begin
  OpenDataSet(cdAccessUser);
  OpenDataSet(cdAccessKind);
  OpenDataSet(cdAccessProc);
  cdAccessProc.Filtered := false;
end;

procedure Tadm.CloseUsers;
begin
  cdAccessUser.Close;
  cdAccessKind.Close;
  cdAccessProc.Close;
end;

procedure Tadm.CancelUsers;
begin
  cdAccessUser.CancelUpdates;
  cdAccessKind.CancelUpdates;
  cdAccessProc.CancelUpdates;
end;

procedure Tadm.RefreshUsers;
begin
  CloseUsers;
  OpenUsers;
end;

// Вызов процедуры, восстанавливающей права пользователей после модификации
// структуры таблиц. Не может запускаться в транзакции!
procedure Tadm.SetUserRights;
var dq: TADOCommand;
begin
  dq := TADOCommand.Create(Self);
  try
    dq.Connection := aqAccessUser.Connection;
    dq.CommandText := 'exec up_SetupUserRoles';
    try
      dq.Execute;
    except on E: Exception do
      ExceptionHandler.Raise_(E, 'Ошибка при установке прав пользователей');
    end;
  finally
    dq.Free;
  end;
end;

procedure Tadm.cdAccessUserAfterOpen(DataSet: TDataSet);
begin
  if Assigned(FAfterOpenUsers) then FAfterOpenUsers(Self);
end;

procedure Tadm.SetCurUserKind(UserID, KindID: integer);
begin
  cdAccessProc.Filter := 'UserID=' + IntToStr(UserID) +
                         ' and KindID=' + IntToStr(KindID);
  cdAccessProc.Filtered := true;
end;

procedure Tadm.cdAccessUserNewRecord(DataSet: TDataSet);
begin
  DataSet['Login'] := DefaultUserLogin;
  DataSet['Name'] := 'Новенький';
  DataSet['ShortName'] := 'N';
  DataSet['EditUsers'] := true;
  DataSet['EditDics'] := true;
  DataSet['EditProcesses'] := true;
  DataSet['EditModules'] := true;
  DataSet['UploadFiles'] := true;
  DataSet['SetCourse'] := true;
  DataSet['EditOwnCustomer'] := true;
  DataSet['EditOtherCustomer'] := true;
  DataSet['ViewOwnOnly'] := false;
  DataSet['WorkViewOwnOnly'] := false;
  DataSet['PermitPlanView'] := true;
  DataSet['ViewOtherCustomer'] := true;
  DataSet['ChangeCustomerOwner'] := false;
  DataSet['DataPaging'] := false;
  DataSet['ViewReports'] := true;
  DataSet['EditCustomReports'] := true;
  DataSet['DeleteCustomReports'] := true;
  DataSet['ViewPayments'] := false;

// Почему то 2 раза встречается    DataSet['EditPayments'] := false;
  DataSet['DefaultKindID'] := true;
  DataSet['DeleteInvoices'] := true;
  DataSet['ViewInvoices'] := true;
  DataSet['AddInvoices'] := true;
  DataSet['AddPayments'] := false;
  DataSet['EditPayments'] := false;
  DataSet['DescribeUnScheduleJob'] := false;
  DataSet['ViewNotPlanned'] := true;
  DataSet['ViewProduction'] := true;
  DataSet['ShowDelayedOrders'] := false;
  DataSet['ViewShipment'] := true;
  DataSet['AddShipment'] := true;
  DataSet['DeleteShipment'] := true;
  DataSet['ShipmentApprovement'] := true;
  DataSet['SetPaymentStatus'] := false;


  DataSet['IsRole'] := false;
end;

function Tadm.CopyUser(UserID: integer): integer;
begin
  Result := -1;
  spCopyUser.Parameters.ParamByName('@UserID').Value := UserID;
  try
    spCopyUser.ExecProc;
    Result := spCopyUser.Parameters.ParamByName('@NewUserID').Value;
  except on E: EDatabaseError do
    ExceptionHandler.Raise_(E, 'Ошибка при копировании пользователя', 'spCopyUser.ExecProc');
  end;
end;

function Tadm.KindData: TDataSet;
begin
  if not cdAccessKind.Active then OpenDataSet(cdAccessKind);
  Result := cdAccessKind;
end;

procedure Tadm.OpenDataSet(DataSet: TDataSet);
begin
  Database.OpenDataSet(DataSet);
end;

function Tadm.ProcessData: TDataSet;
begin
  if not cdAccessProc.Active then OpenDataSet(cdAccessProc);
  Result := cdAccessProc;
end;

procedure Tadm.pvAccessUserUpdateError(Sender: TObject;
  DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind;
  var Response: TResolverResponse);
begin
  // Попытка обмануть MIDAS. При обновлении записи на сервере срабатывают триггеры,
  // поэтому возвращается неправильное количество обновленных строк.
  if E.ErrorCode = 1 then Response := rrIgnore;
end;

end.
