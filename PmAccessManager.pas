unit PmAccessManager;

interface

{$I Calc.inc}

uses Classes, CalcUtils, DB, DBClient, SysUtils;

type
  TUserPermissionInfo = record
    ID: integer;
    Login: string;
    Name: string;
    ShortName: string;
    EditUsers: boolean;    // Управление пользователями
    ContragentGroup: variant;  // ограничение на просмотр заказчиков
    EditDics: boolean;     // Пользователь имеет право на просмотр/редактирование справочников
    EditProcCfg: boolean;  // право редактирования свойств процессов (но структура - только админ)
    EditModules: boolean;  // Редактирование сценариев
    UploadFiles: boolean;  // Загрузка файлов на сервер
    SetCourse: boolean;    // Пользователь имеет право на установку курса доллара
    DraftViewOwnOnly: boolean;  // Доступ только к своим расчетам
    WorkViewOwnOnly: boolean;  // Доступ только к своим заказам
    AddCustomer: boolean;  // Создание нового заказчика
    DeleteOwnCustomer, EditOtherCustomer: boolean; // Редактирование и удаление своих и чужих заказчиков
    ViewOtherCustomer: boolean; // Просмотр данных чужого заказчика
    ChangeCustomerOwner: boolean; // Изменение пользователя-владельца заказчика
    DefaultKindID: integer;    // Вид заказа по умолчанию
    WorkVisible: boolean;
    DraftVisible: boolean;
    ContractVisible: boolean;
    PermitPlanView: boolean;  // разрешить просмотр планов по оборудованию
    DataPaging: boolean;      // Постраничная выборка
    ViewReports: boolean;     // Просмотр отчетов
    EditCustomReports: boolean;   // Создание-редактирование пользовательских отчетов
    DeleteCustomReports: boolean; // Удаление пользовательских отчетов
    ViewPayments: boolean;     // Просмотр расчетов с заказчиками
    EditPayments: boolean;     // Управление(изменение, удаление) поступлениями
    AddPayments: boolean;      // Добавление новых поступлений
    ViewInvoices: boolean;      // Просмотр счетов
    AddInvoices: boolean;       // Создание и модификация счета
    DeleteInvoices: boolean;    // Удаление счета
    ViewShipment: boolean;      // Просмотр отгрузок
    AddShipment: boolean;       // Создание и модификация отгрузок
    DeleteShipment: boolean;    // Удаление отгрузок
    ApproveShipment: boolean;    // Разрешение отгрузок
    ApproveOrderMaterials: boolean;    // Разрешение закупки материалов
    ViewMatRequests: boolean;   // Просмотр закупок
    UpdateMatPayDate: boolean;  // Изменение даты оплаты

    WorkVisibleKinds: TIntArray;
    DraftVisibleKinds: TIntArray;
    HasProtectedKinds: boolean;
    DescribeUnScheduleJob: boolean; // Должен объяснять почему снимается работа. Она при этом заменяется на специальную с пояснением.
    ViewNotPlanned: boolean; // просмотр очереди незапланированных работ
    ViewProduction: boolean; // просмотр загрузки оборудования с выборкой
    ShowDelayedOrders: boolean; // всегда показывать просроченные заказы этого пользователя
    SetPaymentStatus: boolean; // Изменять состояние оплаты

    // Всегда TRUE
    CheckPlanFinishDate: boolean;  // Запретить указание даты сдачи "на вчера"

    // Перенесено в глобальные настройки
    //NeedPlanFinishDate: boolean;   // Ввод даты плановой сдачи заказа обязателен
    //NeedCustInfoSource: boolean;   // Ввод источника информации для заказчика обязателен
  end;

  TKindPerm = record
    AccessKindID, KindID, UserID: integer;
    WorkVisible, DraftVisible: boolean;     // право видимости в таблице
    WorkCreate, DraftCreate: boolean;
    WorkUpdateOwn, DraftUpdateOwn: boolean;
    WorkUpdateOther, DraftUpdateOther: boolean;
    WorkDeleteOwn, DraftDeleteOwn: boolean;
    WorkDeleteOther, DraftDeleteOther: boolean;
    WorkBrowse, DraftBrowse: boolean;
    WorkPriceView, DraftPriceView: boolean;
    WorkCostView, DraftCostView: boolean;
    CheckOnSave, MakeWork, MakeDraft: boolean;
    PlanStartDate, FactStartDate: boolean;
    PlanFinishDate: boolean; // УСТАРЕВШЕЕ
    FactFinishDate: boolean; // УСТАРЕВШЕЕ
    ShowProfitPreview: boolean;
    ShowProfitInside: boolean;
    ModifyProfit: boolean;
    ViewOnlyProtected: boolean;
    CostProtection: boolean;
    ContentProtection: boolean;
    ChangeOrderOwner: boolean;
    UpdatePayConditions: boolean;
    CancelMaterialRequest: boolean;  // удаление изменной заявки на материал
    EditMaterialRequest: boolean; // Изменение заявок на материалы
    FactCostView: boolean; // Просмотр фактических затрат
  end;

  TCurKindPerm = record
    CreateNew, Update, Delete, Browse, PriceView, CostView,
    CheckOnSave, PlanFinishDate, PlanStartDate, FactFinishDate, FactStartDate: boolean;
    ShowProfitPreview: boolean;
    ShowProfitInside: boolean;
    ModifyProfit: boolean;
    CostProtection: boolean;
    ContentProtection: boolean;
    ViewOnlyProtected: boolean;
    ChangeOrderOwner: boolean;
    UpdatePayConditions: boolean;
    CancelMaterialRequest, EditMaterialRequest: boolean;
    FactCostView: boolean;
  end;

  TKindProcPerm = record
    AccessKindProcessID, KindID, UserID, ProcessID: integer;
    WorkView, DraftView: boolean;
    WorkInsert, DraftInsert: boolean;
    WorkUpdate, DraftUpdate: boolean;
    WorkDelete, DraftDelete: boolean;
    PlanDate, FactDate: boolean;
  end;

  TUserInfo = class(TObject)
    ID: integer;
    Name, Login, ShortName: string;
    DefaultKindID: integer;
  end;

  TAccessManager = class(TObject)
  private
    FId: string;
    FCurUserPass: string;  // password is stored here in base64 encoding.
    function InternalReadUserPermTo(var Rec: TUserPermissionInfo): boolean;
    function InternalWriteUserPermFrom(const Rec: TUserPermissionInfo): boolean;
    function CheckPermissionAllKinds(UserID: integer; FieldName: string): boolean;
    procedure UsersNullException;
    procedure Connected(Sender: TObject);
    procedure DoAfterOpenUsers(Sender: TObject);
    procedure DoDataModuleDestroy(Sender: TObject);
    procedure UpdateUserList;
    procedure DoneUserList;
    function GetUserInfo(i: integer): TUserInfo; overload;
    function GetCurUserPass: string;
    procedure SetCurUserPass(Value: string);
  public
    const
      MaxUserName = 50;
    var
      Users: TStringList;
      CurUser: TUserPermissionInfo;
      // it is used for connection cloning for async operations (e.g. clear recycle bin)
      CurKindPerm: TCurKindPerm;
      {$IFDEF Manager}
      MngProfitCode: integer;
      MngProfitPercent: Integer;
      MngCustName: string;
      {$ENDIF}
    constructor Create;
    destructor Destroy; override;
    function AccessUserSource: TDataSource;
    procedure AddUser;
    procedure ApplyUsers(DoOpen: boolean);
    function ReadUserPermTo(var Rec: TUserPermissionInfo; Login: string): boolean; overload;
    function ReadUserIDPermTo(var Rec: TUserPermissionInfo; UserID: integer): boolean; overload;
    function WriteUserPermFrom(const Rec: TUserPermissionInfo; Login: string): boolean; overload;
    function WriteUserPermFrom(const Rec: TUserPermissionInfo{; UserID: integer}): boolean; overload;
    function ReadKindPermTo(var Rec: TKindPerm; KindID: integer): boolean;
    function ReadUserKindPermTo(var Rec: TKindPerm; KindID, UserID: integer): boolean;
    function WriteUserKindPermFrom(const Rec: TKindPerm{; KindID, UserID: integer}): boolean;
    function ReadUserKindProcPermTo(var Rec: TKindProcPerm; KindID, UserID, ProcID: integer): boolean;
    function WriteUserKindProcPermFrom(const Rec: TKindProcPerm{; KindID, UserID, ProcID: integer}): boolean;
    function GetPermittedKinds(UserID: integer; FieldName: string): TIntArray; overload;
    function GetPermittedKinds(FieldName: string): TIntArray; overload;
    procedure GetPermittedKindsList(var KindList: TStringList; UserID: integer; FieldName: string);
    function GetPermittedKindsProcess(UserID: integer; ProcessID: integer; FieldName: string): TIntArray;
    function AllUsersData: TClientDataSet;
    function ReadCurKindPerm(IsDraft: boolean; KindID, CreatorUserID: integer):
        boolean;
    function ReadCurKindPermTo(var Rec: TCurKindPerm; IsDraft: boolean; KindID,
        CreatorUserID: integer): boolean;
    function ReadUserCurKindPermTo(var Rec: TCurKindPerm; IsDraft: boolean; KindID,
        UserID, CreatorUserID: integer): boolean;
    function UserInfo(UserName: string): TUserInfo; overload;
    function GetUserID(Login: string): integer;
    function GetUserLogin(UserID: integer): string;
    function GetUserName(UserID: integer): string;
    procedure SetUserRights;
    function UserData: TClientDataSet;
    procedure RefreshUsers;
    // Создает копию списка пользователей с полным именем и логином
    function GetUserNames: TStringList;
    // Создает полную копию списка пользователей
    function GetUsersCopy: TStringList;
    // Пароль текущего пользователя
    property CurUserPass: string read GetCurUserPass write SetCurUserPass;
    // для отображения в виде "имя (логин)" или "логин"
    function FormatUserName(UserCode: integer): string; overload;
    function FormatUserName(UserLogin: string): string; overload;
    function FormatUserName(info: TUserInfo): string; overload;
  end;

var
  AccessManager: TAccessManager;

implementation

uses Forms, RDBUtils, Variants, ExHandler, JvStrings, 

  CalcSettings, AccessDM, PmConnect, ServData;

constructor TAccessManager.Create;
begin
  inherited;
  FID := ConnectNotifier.RegisterHandler(Connected);
end;

destructor TAccessManager.Destroy;
begin
  ConnectNotifier.UnregisterHandler(FID);
  inherited;
end;

procedure TAccessManager.Connected(Sender: TObject);
begin
  // Здесь сразу надо определить уровень пользователя, т.к. от этого может зависеть
  // видимость элементов управления, полей и т.п.
  Application.CreateForm(Tadm, adm);  // модуль прав пользователя
  adm.AfterOpenUsers := DoAfterOpenUsers;
  adm.OnDestroy := DoDataModuleDestroy;
  ReadUserPermTo(CurUser, TSettingsManager.Instance.CurUserLogin);
end;

function TAccessManager.AccessUserSource: TDataSource;
begin
  Result := adm.dsAccessUser;
end;

procedure TAccessManager.AddUser;
begin
  adm.cdAccessUser.Append;
  adm.cdAccessUser.Post;
end;

function TAccessManager.ReadKindPermTo(var Rec: TKindPerm; KindID: integer): boolean;
begin
  Result := ReadUserKindPermTo(Rec, KindID, CurUser.ID);
end;

function TAccessManager.ReadUserKindPermTo(var Rec: TKindPerm; KindID, UserID: integer): boolean;
var
  cdAccessKind: TDataSet;
begin
  Result := false;
  cdAccessKind := adm.KindData;
  {cdAccessKind.Filtered := true;
  cdAccessKind.Filter := 'UserID = ' + IntToStr(CurUser.ID) +
                         ' and KindID = ' + IntToStr(KindID);}
  if ((cdAccessKind['UserID'] = UserID) and (cdAccessKind['KindID'] = KindID))
    or cdAccessKind.Locate('UserID;KindID', VarArrayOf([UserID, KindID]), []) then
  begin
    Rec.AccessKindID := cdAccessKind['AccessKindID'];
    Rec.KindID := cdAccessKind['KindID'];
    Rec.UserID := cdAccessKind['UserID'];
    Rec.WorkVisible := cdAccessKind['WorkVisible'];
    Rec.DraftVisible := cdAccessKind['DraftVisible'];
    Rec.WorkCreate := cdAccessKind['WorkCreate'];
    Rec.DraftCreate := cdAccessKind['DraftCreate'];

    Rec.WorkUpdateOwn := cdAccessKind['WorkUpdateOwn'];
    Rec.DraftUpdateOwn := cdAccessKind['DraftUpdateOwn'];
    Rec.WorkDeleteOwn := cdAccessKind['WorkDeleteOwn'];
    Rec.DraftDeleteOwn := cdAccessKind['DraftDeleteOwn'];

    Rec.WorkUpdateOther := cdAccessKind['WorkUpdateOther'];
    Rec.DraftUpdateOther := cdAccessKind['DraftUpdateOther'];
    Rec.WorkDeleteOther := cdAccessKind['WorkDeleteOther'];
    Rec.DraftDeleteOther := cdAccessKind['DraftDeleteOther'];

    Rec.WorkBrowse := cdAccessKind['WorkBrowse'];
    Rec.DraftBrowse := cdAccessKind['DraftBrowse'];
    Rec.WorkPriceView := cdAccessKind['WorkPriceView'];
    Rec.DraftPriceView := cdAccessKind['DraftPriceView'];
    Rec.WorkCostView := cdAccessKind['WorkCostView'];
    Rec.DraftCostView := cdAccessKind['DraftCostView'];
    Rec.CheckOnSave := cdAccessKind['CheckOnSave'];
    Rec.MakeWork := cdAccessKind['MakeWork'];
    Rec.MakeDraft := cdAccessKind['MakeDraft'];
    Rec.PlanFinishDate := cdAccessKind['PlanFinishDate'];
    Rec.PlanStartDate := cdAccessKind['PlanStartDate'];
    Rec.FactFinishDate := cdAccessKind['FactFinishDate'];
    Rec.FactStartDate := cdAccessKind['FactStartDate'];
    Rec.ShowProfitInside := cdAccessKind['ShowProfitInside'];
    Rec.ShowProfitPreview := cdAccessKind['ShowProfitPreview'];
    Rec.ModifyProfit := cdAccessKind['ModifyProfit'];
    Rec.ViewOnlyProtected := cdAccessKind['ViewOnlyProtected'];
    Rec.CostProtection := cdAccessKind['CostProtection'];
    Rec.ContentProtection := cdAccessKind['ContentProtection'];
    Rec.ChangeOrderOwner := cdAccessKind['ChangeOrderOwner'];
    Rec.UpdatePayConditions := cdAccessKind['UpdatePayConditions'];
    Rec.CancelMaterialRequest := cdAccessKind['CancelMaterialRequest'];
    Rec.EditMaterialRequest := cdAccessKind['EditMaterialRequest'];
    Rec.FactCostView := cdAccessKind['FactCostView'];
    Result := true;
  end;
end;

function TAccessManager.WriteUserKindPermFrom(const Rec: TKindPerm{; KindID, UserID: integer}): boolean;
var
  cdAccessKind: TDataSet;

  procedure SetAccessKind(FieldName: string; Value: variant);
  begin
    if VarIsNull(cdAccessKind[FieldName]) or (cdAccessKind[FieldName] <> Value) then
      cdAccessKind[FieldName] := Value;
  end;

begin
  Result := false;
  cdAccessKind := adm.KindData;
  {cdAccessKind.Filtered := true;
  cdAccessKind.Filter := 'UserID = ' + IntToStr(CurUser.ID) +
                         ' and KindID = ' + IntToStr(KindID);}
  if ((cdAccessKind['UserID'] = Rec.UserID) and (cdAccessKind['KindID'] = Rec.KindID))
    or cdAccessKind.Locate('UserID;KindID', VarArrayOf([Rec.UserID, Rec.KindID]), []) then
  begin
    cdAccessKind.Edit;
    SetAccessKind('WorkVisible', Rec.WorkVisible);
    SetAccessKind('DraftVisible', Rec.DraftVisible);
    SetAccessKind('WorkCreate', Rec.WorkCreate);
    SetAccessKind('DraftCreate', Rec.DraftCreate);

    SetAccessKind('WorkUpdateOwn', Rec.WorkUpdateOwn);
    SetAccessKind('DraftUpdateOwn', Rec.DraftUpdateOwn);
    SetAccessKind('WorkDeleteOwn', Rec.WorkDeleteOwn);
    SetAccessKind('DraftDeleteOwn', Rec.DraftDeleteOwn);

    SetAccessKind('WorkUpdateOther', Rec.WorkUpdateOther);
    SetAccessKind('DraftUpdateOther', Rec.DraftUpdateOther);
    SetAccessKind('WorkDeleteOther', Rec.WorkDeleteOther);
    SetAccessKind('DraftDeleteOther', Rec.DraftDeleteOther);

    SetAccessKind('WorkBrowse', Rec.WorkBrowse);
    SetAccessKind('DraftBrowse', Rec.DraftBrowse);
    SetAccessKind('WorkPriceView', Rec.WorkPriceView);
    SetAccessKind('DraftPriceView', Rec.DraftPriceView);
    SetAccessKind('WorkCostView', Rec.WorkCostView);
    SetAccessKind('DraftCostView', Rec.DraftCostView);
    SetAccessKind('CheckOnSave', Rec.CheckOnSave);
    SetAccessKind('MakeWork', Rec.MakeWork);
    SetAccessKind('MakeDraft', Rec.MakeDraft);
    SetAccessKind('PlanFinishDate', Rec.PlanFinishDate);
    SetAccessKind('PlanStartDate', Rec.PlanStartDate);
    SetAccessKind('FactFinishDate', Rec.FactFinishDate);
    SetAccessKind('FactStartDate', Rec.FactStartDate);
    SetAccessKind('ShowProfitInside', Rec.ShowProfitInside);
    SetAccessKind('ShowProfitPreview', Rec.ShowProfitPreview);
    SetAccessKind('ModifyProfit', Rec.ModifyProfit);
    SetAccessKind('ViewOnlyProtected', Rec.ViewOnlyProtected);
    SetAccessKind('CostProtection', Rec.CostProtection);
    SetAccessKind('ContentProtection', Rec.ContentProtection);
    SetAccessKind('ChangeOrderOwner', Rec.ChangeOrderOwner);
    SetAccessKind('UpdatePayConditions', Rec.UpdatePayConditions);
    SetAccessKind('CancelMaterialRequest', Rec.CancelMaterialRequest);
    SetAccessKind('EditMaterialRequest', Rec.EditMaterialRequest);
    SetAccessKind('FactCostView', Rec.FactCostView);
    cdAccessKind.Post;
    Result := true;
  end;
end;

function TAccessManager.ReadUserKindProcPermTo(var Rec: TKindProcPerm; KindID, UserID, ProcID: integer): boolean;
var
  cdAccessProc: TDataSet;
begin
  Result := false;
  cdAccessProc := adm.ProcessData;
  {cdAccessKind.Filtered := true;
  cdAccessKind.Filter := 'UserID = ' + IntToStr(CurUser.ID) +
                         ' and KindID = ' + IntToStr(KindID);}
  if ((cdAccessProc['UserID'] = UserID) and (cdAccessProc['KindID'] = KindID) and (cdAccessProc['ProcessID'] = ProcID))
     or cdAccessProc.Locate('UserID;KindID;ProcessID', VarArrayOf([UserID, KindID, ProcID]), []) then
  begin
    Rec.AccessKindProcessID := cdAccessProc['AccessKindProcessID'];
    Rec.KindID := cdAccessProc['KindID'];
    Rec.UserID := cdAccessProc['UserID'];
    Rec.ProcessID := cdAccessProc['ProcessID'];
    Rec.WorkView := cdAccessProc['WorkView'];
    Rec.DraftView := cdAccessProc['DraftView'];
    Rec.WorkInsert := cdAccessProc['WorkInsert'];
    Rec.DraftInsert := cdAccessProc['DraftInsert'];
    Rec.WorkUpdate := cdAccessProc['WorkUpdate'];
    Rec.DraftUpdate := cdAccessProc['DraftUpdate'];
    Rec.WorkDelete := cdAccessProc['WorkDelete'];
    Rec.DraftDelete := cdAccessProc['DraftDelete'];
    Rec.PlanDate := cdAccessProc['PlanDate'];
    Rec.FactDate := cdAccessProc['FactDate'];
    Result := true;
  end;
end;

function TAccessManager.WriteUserKindProcPermFrom(const Rec: TKindProcPerm): boolean;
var
  cdAccessProc: TDataSet;

  procedure SetAccessProc(FieldName: string; Value: variant);
  begin
    if VarIsNull(cdAccessProc[FieldName]) or (cdAccessProc[FieldName] <> Value) then
      cdAccessProc[FieldName] := Value;
  end;

begin
  Result := false;
  cdAccessProc := adm.ProcessData;
  if ((cdAccessProc['UserID'] = Rec.UserID) and (cdAccessProc['KindID'] = Rec.KindID)
        and (cdAccessProc['ProcessID'] = Rec.ProcessID))
     or cdAccessProc.Locate('UserID;KindID;ProcessID', VarArrayOf([Rec.UserID, Rec.KindID, Rec.ProcessID]), []) then
  begin
    cdAccessProc.Edit;
    SetAccessProc('WorkView', Rec.WorkView);
    SetAccessProc('DraftView', Rec.DraftView);
    SetAccessProc('WorkInsert', Rec.WorkInsert);
    SetAccessProc('DraftInsert', Rec.DraftInsert);
    SetAccessProc('WorkUpdate', Rec.WorkUpdate);
    SetAccessProc('DraftUpdate', Rec.DraftUpdate);
    SetAccessProc('WorkDelete', Rec.WorkDelete);
    SetAccessProc('DraftDelete', Rec.DraftDelete);
    SetAccessProc('PlanDate', Rec.PlanDate);
    SetAccessProc('FactDate', Rec.FactDate);
    cdAccessProc.CheckBrowseMode;
    Result := true;
  end;
end;

// !!!!!!!!!!!!!!!!!!!! APPSERVER
function TAccessManager.GetPermittedKinds(UserID: integer; FieldName: string): TIntArray;
var
  R: TIntArray;
  i: integer;
  cdAccessKind: TDataSet;
begin
  SetLength(R, 0);
  cdAccessKind := adm.KindData;
  try
    cdAccessKind.Filtered := true;
    cdAccessKind.Filter := 'UserID = ' + IntToStr(UserID) + ' and ' + FieldName;
    if not cdAccessKind.IsEmpty then
    begin
      SetLength(R, cdAccessKind.RecordCount);
      cdAccessKind.First;
      i := 0;
      while not cdAccessKind.eof do
        try
          R[i] := cdAccessKind['KindID'];
        finally
          cdAccessKind.Next;
          Inc(i);
        end;
    end;
  finally
    cdAccessKind.Filtered := false;
  end;
  Result := R;
end;

function TAccessManager.GetPermittedKinds(FieldName: string): TIntArray;
begin
  Result := GetPermittedKinds(CurUser.ID, FieldName);
end;

procedure TAccessManager.GetPermittedKindsList(var KindList: TStringList; UserID: integer; FieldName: string);
var
  cdAccessKind: TDataSet;
begin
  KindList := TStringList.Create;
  cdAccessKind := adm.KindData;
  cdAccessKind.Filtered := true;
  cdAccessKind.Filter := 'UserID = ' + IntToStr(UserID) + ' and ' + FieldName;
  try
    if not cdAccessKind.IsEmpty then
    begin
      cdAccessKind.First;
      while not cdAccessKind.eof do
        try
          if sdm.cdOrderKind.Locate('KindID', cdAccessKind['KindID'], []) then
            KindList.AddObject(sdm.cdOrderKind['KindDesc'], pointer(cdAccessKind.FieldByName('KindID').AsInteger));
        finally
          cdAccessKind.Next;
        end;
    end;
  finally
    cdAccessKind.Filtered := false;
  end;
end;

// !!!!!!!!!!!!!!!!!!!! APPSERVER
function TAccessManager.CheckPermissionAllKinds(UserID: integer; FieldName: string): boolean;
var
  cdAccessKind: TDataSet;
begin
  cdAccessKind := adm.KindData;
  try
    cdAccessKind.Filtered := true;
    cdAccessKind.Filter := 'UserID = ' + IntToStr(UserID) + ' and ' + FieldName;
    Result := not cdAccessKind.IsEmpty;
  finally
    cdAccessKind.Filtered := false;
  end;
end;

function TAccessManager.GetPermittedKindsProcess(UserID: integer; ProcessID: integer; FieldName: string): TIntArray;
var
  R: TIntArray;
  i: integer;
  cdAccessProc: TDataSet;
begin
  SetLength(R, 0);
  cdAccessProc := adm.ProcessData;
  try
    cdAccessProc.Filtered := true;
    cdAccessProc.Filter := 'UserID = ' + IntToStr(UserID) + ' and ' + FieldName
      + ' and ProcessID = ' + IntToStr(ProcessID);
    if not cdAccessProc.IsEmpty then
    begin
      SetLength(R, cdAccessProc.RecordCount);
      cdAccessProc.First;
      i := 0;
      while not cdAccessProc.eof do
        try
          R[i] := cdAccessProc['KindID'];
        finally
          cdAccessProc.Next;
          Inc(i);
        end;
    end;
  finally
    cdAccessProc.Filtered := false;
  end;
  Result := R;
end;

function TAccessManager.InternalReadUserPermTo(var Rec: TUserPermissionInfo): boolean;
var
  cdAccessUser: TDataSet;
begin
  cdAccessUser := adm.AllUsersData;
  Rec.ID := cdAccessUser['AccessUserID'];
  Rec.Name := cdAccessUser['Name'];
  Rec.Login := cdAccessUser['Login'];
  Rec.ShortName := cdAccessUser['ShortName'];
  Rec.ContragentGroup := cdAccessUser['ContragentGroup'];
  Rec.EditUsers := cdAccessUser['EditUsers'];
  Rec.EditDics := cdAccessUser['EditDics'];
  Rec.EditProcCfg := cdAccessUser['EditProcesses'];
  Rec.EditModules := cdAccessUser['EditModules'];
  Rec.SetCourse := cdAccessUser['SetCourse'];
  Rec.UploadFiles := cdAccessUser['UploadFiles'];
  Rec.CheckPlanFinishDate := true; //cdAccessUser['CheckPlanFinishDate'];
  Rec.AddCustomer := cdAccessUser['AddCustomer'];
  Rec.DeleteOwnCustomer := cdAccessUser['EditOwnCustomer'];
  Rec.EditOtherCustomer := cdAccessUser['EditOtherCustomer'];
  Rec.DraftViewOwnOnly := cdAccessUser['ViewOwnOnly'];
  Rec.WorkViewOwnOnly := cdAccessUser['WorkViewOwnOnly'];
  Rec.DefaultKindID := NvlInteger(cdAccessUser['DefaultKindID']);
  Rec.PermitPlanView := NvlBoolean(cdAccessUser['PermitPlanView']);
  Rec.ViewOtherCustomer := NvlBoolean(cdAccessUser['ViewOtherCustomer']);
  Rec.ChangeCustomerOwner := NvlBoolean(cdAccessUser['ChangeCustomerOwner']);
  Rec.DataPaging := NvlBoolean(cdAccessUser['DataPaging']);
  Rec.ViewReports := NvlBoolean(cdAccessUser['ViewReports']);
  Rec.EditCustomReports := NvlBoolean(cdAccessUser['EditCustomReports']);
  Rec.DeleteCustomReports := NvlBoolean(cdAccessUser['DeleteCustomReports']);
  Rec.ViewPayments := NvlBoolean(cdAccessUser['ViewPayments']);
  Rec.EditPayments := NvlBoolean(cdAccessUser['EditPayments']);
  Rec.AddPayments := NvlBoolean(cdAccessUser['AddPayments']);
  Rec.ViewInvoices := NvlBoolean(cdAccessUser['ViewInvoices']);
  Rec.AddInvoices := NvlBoolean(cdAccessUser['AddInvoices']);
  Rec.DeleteInvoices := NvlBoolean(cdAccessUser['DeleteInvoices']);
  Rec.ViewShipment := NvlBoolean(cdAccessUser['ViewShipment']);
  Rec.AddShipment := NvlBoolean(cdAccessUser['AddShipment']);
  Rec.DeleteShipment := NvlBoolean(cdAccessUser['DeleteShipment']);
  Rec.ApproveShipment := NvlBoolean(cdAccessUser['ShipmentApprovement']);
  Rec.ApproveOrderMaterials := NvlBoolean(cdAccessUser['OrderMaterialsApprovement']);
  Rec.ViewMatRequests := NvlBoolean(cdAccessUser['ViewMatRequests']);
  Rec.UpdateMatPayDate := NvlBoolean(cdAccessUser['UpdateMatPayDate']);
  Rec.DescribeUnScheduleJob := NvlBoolean(cdAccessUser['DescribeUnScheduleJob']);
  Rec.ViewNotPlanned := NvlBoolean(cdAccessUser['ViewNotPlanned']);
  Rec.ViewProduction := NvlBoolean(cdAccessUser['ViewProduction']);
  Rec.ShowDelayedOrders := NvlBoolean(cdAccessUser['ShowDelayedOrders']);
  Rec.WorkVisibleKinds := GetPermittedKinds(Rec.ID, 'WorkVisible');
  Rec.DraftVisibleKinds := GetPermittedKinds(Rec.ID, 'DraftVisible');
  {Rec.WorkBrowseKinds := GetPermittedKinds(Rec.ID, 'WorkBrowse');
  Rec.DraftBrowseKinds := GetPermittedKinds(Rec.ID, 'DraftBrowse');}
  Rec.DraftVisible := Length(Rec.DraftVisibleKinds) > 0;
  Rec.WorkVisible := Length(Rec.WorkVisibleKinds) > 0;
  Rec.HasProtectedKinds := CheckPermissionAllKinds(Rec.ID, 'ViewOnlyProtected');
  Rec.SetPaymentStatus := NvlBoolean(cdAccessUser['SetPaymentStatus']);
  Rec.ContractVisible := false;
  Result := true;
end;

// !!!!!!!!!!!!!!!!!!!! APPSERVER
function TAccessManager.ReadUserPermTo(var Rec: TUserPermissionInfo; Login: string): boolean;
var
  cdAccessUser: TDataSet;
begin
  cdAccessUser := adm.AllUsersData;
  Result := false;
  if (AnsiCompareText(cdAccessUser['Login'], Login) = 0) or
     cdAccessUser.Locate('Login', Login, [loCaseInsensitive]) then
    Result := InternalReadUserPermTo(Rec);
end;

function TAccessManager.ReadUserIDPermTo(var Rec: TUserPermissionInfo; UserID: integer): boolean;
var
  cdAccessUser: TDataSet;
begin
  cdAccessUser := adm.AllUsersData;
  Result := false;
  if (cdAccessUser['AccessUserID'] = UserID) or
     cdAccessUser.Locate('AccessUserID', UserID, []) then
    Result := InternalReadUserPermTo(Rec);
end;

function TAccessManager.InternalWriteUserPermFrom(const Rec: TUserPermissionInfo): boolean;
var
  cdAccessUser: TDataSet;

  procedure SetAccessUser(FieldName: string; Value: variant);
  begin
    if VarIsNull(cdAccessUser[FieldName]) or (cdAccessUser[FieldName] <> Value) then
      cdAccessUser[FieldName] := Value;
  end;

begin
  cdAccessUser := adm.AllUsersData;
  cdAccessUser.Edit;
  // Только права
  SetAccessUser('EditUsers', Rec.EditUsers);
  SetAccessUser('EditDics', Rec.EditDics);
  SetAccessUser('EditProcesses', Rec.EditProcCfg);
  SetAccessUser('EditModules', Rec.EditModules);
  SetAccessUser('SetCourse', Rec.SetCourse);
  SetAccessUser('UploadFiles', Rec.UploadFiles);
  //SetAccessUser('CheckPlanFinishDate', Rec.CheckPlanFinishDate);
  SetAccessUser('AddCustomer', Rec.AddCustomer);
  SetAccessUser('EditOwnCustomer', Rec.DeleteOwnCustomer);
  SetAccessUser('EditOtherCustomer', Rec.EditOtherCustomer);
  SetAccessUser('ViewOwnOnly', Rec.DraftViewOwnOnly);
  SetAccessUser('WorkViewOwnOnly', Rec.WorkViewOwnOnly);
  SetAccessUser('PermitPlanView', Rec.PermitPlanView);
  SetAccessUser('ViewOtherCustomer', Rec.ViewOtherCustomer);
  SetAccessUser('ChangeCustomerOwner', Rec.ChangeCustomerOwner);
  SetAccessUser('DataPaging', Rec.DataPaging);
  SetAccessUser('ViewReports', Rec.ViewReports);
  SetAccessUser('EditCustomReports', Rec.EditCustomReports);
  SetAccessUser('DeleteCustomReports', Rec.DeleteCustomReports);
  SetAccessUser('ViewPayments', Rec.ViewPayments);
  SetAccessUser('EditPayments', Rec.EditPayments);
  SetAccessUser('AddPayments', Rec.AddPayments);
  SetAccessUser('ViewInvoices', Rec.ViewInvoices);
  SetAccessUser('AddInvoices', Rec.AddInvoices);
  SetAccessUser('DeleteInvoices', Rec.DeleteInvoices);
  SetAccessUser('ViewShipment', Rec.ViewShipment);
  SetAccessUser('AddShipment', Rec.AddShipment);
  SetAccessUser('DeleteShipment', Rec.DeleteShipment);
  SetAccessUser('ShipmentApprovement', Rec.ApproveShipment);
  SetAccessUser('OrderMaterialsApprovement', Rec.ApproveOrderMaterials);
  SetAccessUser('ViewMatRequests', Rec.ViewMatRequests);
  SetAccessUser('UpdateMatPayDate', Rec.UpdateMatPayDate);
  SetAccessUser('DescribeUnScheduleJob', Rec.DescribeUnScheduleJob);
  SetAccessUser('ViewNotPlanned', Rec.ViewNotPlanned);
  SetAccessUser('ViewProduction', Rec.ViewProduction);
  SetAccessUser('ShowDelayedOrders', Rec.ShowDelayedOrders);
  SetAccessUser('SetPaymentStatus', Rec.SetPaymentStatus);
  cdAccessUser.Post;
  Result := true;
end;

function TAccessManager.WriteUserPermFrom(const Rec: TUserPermissionInfo; Login: string): boolean;
var
  cdAccessUser: TDataSet;
begin
  Result := false;
  cdAccessUser := adm.AllUsersData;
  if (AnsiCompareText(cdAccessUser['Login'], Login) = 0) or
     cdAccessUser.Locate('Login', Login, [loCaseInsensitive]) then
    Result := InternalWriteUserPermFrom(Rec);
end;

function TAccessManager.WriteUserPermFrom(const Rec: TUserPermissionInfo): boolean;
var
  cdAccessUser: TDataSet;
begin
  Result := false;
  cdAccessUser := adm.AllUsersData;
  if (cdAccessUser['AccessUserID'] = Rec.ID) or
     cdAccessUser.Locate('AccessUserID', Rec.ID, []) then
    Result := InternalWriteUserPermFrom(Rec);
end;

// с учетом черновик или нет
function TAccessManager.ReadCurKindPerm(IsDraft: boolean; KindID, CreatorUserID: integer): boolean;
begin
  Result := ReadCurKindPermTo(CurKindPerm, IsDraft, KindID, CreatorUserID);
end;

// Права текущего пользователя на указанный вид заказа
function TAccessManager.ReadCurKindPermTo(var Rec: TCurKindPerm; IsDraft: boolean; KindID, CreatorUserID: integer): boolean;
begin
  Result := ReadUserCurKindPermTo(Rec, IsDraft, KindID, CurUser.ID, CreatorUserID);
end;

function TAccessManager.ReadUserCurKindPermTo(var Rec: TCurKindPerm; IsDraft: boolean;
  KindID, UserID, CreatorUserID: integer): boolean;
var
  w: string;
  cdAccessKind: TDataSet;
begin
  Result := false;
  cdAccessKind := adm.KindData;
  if cdAccessKind.Locate('UserID;KindID', VarArrayOf([UserID, KindID]), []) then
  begin
    if IsDraft then w := 'Draft' else w := 'Work';
    Rec.CreateNew := cdAccessKind[w + 'Create'];
    if CreatorUserID = UserID then
    begin
      Rec.Update := cdAccessKind[w + 'UpdateOwn'];  // свой заказ
      Rec.Delete := cdAccessKind[w + 'DeleteOwn'];
    end
    else
    begin
      Rec.Update := cdAccessKind[w + 'UpdateOther'];  // чужой заказ
      Rec.Delete := cdAccessKind[w + 'DeleteOther'];
    end;
    Rec.Browse := cdAccessKind[w + 'Browse'];
    Rec.PriceView := cdAccessKind[w + 'PriceView'];
    Rec.CostView := cdAccessKind[w + 'CostView'];
    Rec.CheckOnSave := cdAccessKind['CheckOnSave'];
    Rec.PlanFinishDate := cdAccessKind['PlanFinishDate'];
    Rec.PlanStartDate := cdAccessKind['PlanStartDate'];
    Rec.FactFinishDate := cdAccessKind['FactFinishDate'];
    Rec.FactStartDate := cdAccessKind['FactStartDate'];
    Rec.ShowProfitInside := cdAccessKind['ShowProfitInside'];
    Rec.ShowProfitPreview := cdAccessKind['ShowProfitPreview'];
    Rec.ModifyProfit := cdAccessKind['ModifyProfit'];
    Rec.CostProtection := cdAccessKind['CostProtection'];
    Rec.ContentProtection := cdAccessKind['ContentProtection'];
    Rec.ViewOnlyProtected := cdAccessKind['ViewOnlyProtected'];
    Rec.ChangeOrderOwner := cdAccessKind['ChangeOrderOwner'];
    Rec.UpdatePayConditions := cdAccessKind['UpdatePayConditions'];
    Rec.CancelMaterialRequest := cdAccessKind['CancelMaterialRequest'];
    Rec.EditMaterialRequest := cdAccessKind['EditMaterialRequest'];
    Rec.FactCostView := cdAccessKind['FactCostView'];
    Result := true;
  end;
end;

// Создается и заполняется список пользователей
procedure TAccessManager.UpdateUserList;
var
  ui: TUserInfo;
  dq: TDataSet;
begin
  // Удаляем, если был
  if (Users <> nil) and (Users.Count > 0) then DoneUserList;
  // Создаем, если не было или удалили
  if Users = nil then
    Users := TStringList.Create;
  dq := AllUsersData;
  dq.First;
  while not dq.eof do
  try
    ui := TUserInfo.Create;
    ui.ID := dq['AccessUserID'];
    ui.Name := dq['Name'];
    ui.Login := dq['Login'];
    ui.ShortName := dq['ShortName'];
    ui.DefaultKindID := dq['DefaultKindID'];
    Users.AddObject(ui.Login, ui);
  finally
    dq.Next;
  end;
end;

procedure TAccessManager.DoneUserList;
var
  I: Integer;
begin
  if Users <> nil then
  begin
    for I := 0 to Users.Count - 1 do
       (Users.Objects[i] as TUserInfo).Free;
    FreeAndNil(Users);
  end;
end;

procedure TAccessManager.DoDataModuleDestroy(Sender: TObject);
begin
  DoneUserList;
end;

procedure TAccessManager.DoAfterOpenUsers(Sender: TObject);
begin
  UpdateUserList;  // обновляем список пользователей
end;

procedure TAccessManager.RefreshUsers;
begin
  adm.CloseUsers;
  adm.OpenUsers;
end;

function TAccessManager.GetUserID(Login: string): integer;
begin
  if adm.cdAccessUser.Locate('Login', Login, [loCaseInsensitive]) then
    Result := adm.cdAccessUser['AccessUserID']
  else
    Result := 0; // пользователь не найден
end;

function TAccessManager.GetUserLogin(UserID: integer): string;
begin
  if adm.cdAccessUser.Locate('AccessUserID', UserID, []) then
    Result := adm.cdAccessUser['Login']
  else
    Result := ''; // пользователь не найден
end;

function TAccessManager.GetUserName(UserID: integer): string;
begin
  if adm.cdAccessUser.Locate('AccessUserID', UserID, []) then
    Result := adm.cdAccessUser['Name']
  else
    Result := ''; // пользователь не найден
end;

procedure TAccessManager.SetUserRights;
begin
  adm.SetUserRights;
end;

function TAccessManager.UserData: TClientDataSet;
begin
  Result := adm.AllUsersData;
end;

function TAccessManager.GetUserInfo(i: integer): TUserInfo;
begin
  if Users = nil then
    UsersNullException;
  Result := Users.Objects[i] as TUserInfo;
end;

function TAccessManager.UserInfo(UserName: string): TUserInfo;
var
  i: integer;
begin
  if Users = nil then
    UsersNullException;

  i := Users.IndexOf(UserName);
  if i <> -1 then
    Result := GetUserInfo(i)
  else
    Result := nil;
end;

procedure TAccessManager.UsersNullException;
begin
  raise Exception.Create('Не создан список пользователей');
end;

procedure TAccessManager.ApplyUsers(DoOpen: boolean);
begin
  adm.ApplyUsers(DoOpen);
end;

function TAccessManager.AllUsersData: TClientDataSet;
begin
  Result := adm.AllUsersData;
end;

// Создает копию списка пользователей с полным именем и логином
function TAccessManager.GetUserNames: TStringList;
var
  UsersCopy: TStringList;
  i: Integer;
  S: string;
begin
  UsersCopy := nil;
  if Users <> nil then
  begin
    UsersCopy := TStringList.Create;
    for i := 0 to Pred(Users.Count) do
    begin
      s := FormatUserName(GetUserInfo(i));
      UsersCopy.Add(s);
    end;
  end;
  UsersCopy.Sort;
  Result := UsersCopy;
end;

// Создает полную копию списка пользователей
function TAccessManager.GetUsersCopy: TStringList;
var
  UsersCopy: TStringList;
  i: Integer;
  S: string;
  NewUser, ui: TUserInfo;
begin
  UsersCopy := nil;
  if Users <> nil then               
  begin
    UsersCopy := TStringList.Create;
    for i := 0 to Pred(Users.Count) do
    begin
      ui := GetUserInfo(i);

      NewUser := TUserInfo.Create;
      NewUser.ID := ui.ID;
      NewUser.Name := ui.Name;
      NewUser.Login := ui.Login;
      NewUser.ShortName := ui.ShortName;
      NewUser.DefaultKindID := ui.DefaultKindID;

      s := FormatUserName(ui);
      UsersCopy.AddObject(s, NewUser);
    end;
  end;
  UsersCopy.Sort;
  Result := UsersCopy;
end;

// Возвращает пароль текущего пользователя
function TAccessManager.GetCurUserPass: string;
begin
  if FCurUserPass = '' then
    Result := ''
  else
    Result := B64Decode(FCurUserPass);
end;

procedure TAccessManager.SetCurUserPass(Value: string);
begin
  FCurUserPass := B64Encode(Value);
end;

function TAccessManager.FormatUserName(UserCode: integer): string;
begin
  Result := FormatUserName(GetUserLogin(UserCode));
end;

function TAccessManager.FormatUserName(UserLogin: string): string;
var
  info: TUserInfo;
begin
  info := UserInfo(UserLogin);
  if info <> nil then
    Result := FormatUserName(info)
  else
    Result := UserLogin;
end;

function TAccessManager.FormatUserName(info: TUserInfo): string;
begin
  if Options.ShowUserLogin then
  begin
    if info.Name <> info.Login then
      // если полное имя и логин совпадают, то отобр. только один
      Result := info.Name + ' (' + info.Login + ')'
    else
      Result := info.Name;
  end
  else
    Result := info.Name;
end;

initialization

AccessManager := TAccessManager.Create;

finalization

AccessManager.Free;

end.
