unit PmContragent;

interface

uses Classes, DB, DBClient, ADODB, Provider,

  PmEntSettings, NotifyEvent, PmEntity,
  PmDataChangeDetect;

type
  // for import-export
  TContragentInfo = record
    Name, FullName, Fax, Phone, Phone2, Address, Bank, IndCode,
    NDSCode, Email, LegalAddress, ExternalName: string;
    SourceCode: integer;
    SourceOther: string;
    FirmType: string;
    PersonType: integer;
    FirmBirthday, CreationDate: TDateTime;
    PrePayPercent, PreShipPercent: extended;
    PayDelay: integer;
    IsPayDelayInBankDays: boolean;
    CheckPayConditions: boolean;
    StatusCode, ActivityCode: integer;
    BriefNote: string;
    Alert: boolean;
    ParentID: integer;
    Valid: boolean;
    { TODO UserCode? }
  end;

  TPersonInfo = record
    Name, Email, Phone, PhoneCell, PersonNote: string;
    PersonType: integer;
    Birthday: TDateTime;
  end;

  TPersons = class;
  TRelated = class;
  TAddresses = class;

  TContragents = class(TEntity)
  private
    //function GetDataSet: TClientDataSet;
    function GetName: string;
    function GetFullName: string;
    function GetFirmBirthday: variant;
    function GetExternalName: string;
    function GetPersons: TPersons;
    function GetRelated: TRelated;
    function GetAddresses: TAddresses;
    function GetPersonType: Integer;
    function GetSyncState: integer;
    function GetStatusCode: variant;
    function GetUserCode: integer;
    function GetActivityCode: variant;
    function GetFirstPersonName: variant;
    function GetBriefNote: variant;
    function GetContragentTypeValue: integer;
    function GetActivityCodes: string;
    function GetIsDead: boolean;
    procedure SetContragentType(id: integer);
    procedure SetName(_Name: string);
    procedure SetFullName(_FullName: string);
    procedure SetFirmBirthday(_Birthday: variant);
    procedure SetContragentTypeValue(_Value: integer);
    procedure SetStatusCode(_Value: variant);
    procedure SetActivityCodes(_Value: string);
  protected
    FContragentType: integer;
    FRequireInfoSource: boolean;
    FRequireFirmType: boolean;
    FWorkSeparation: boolean;
    FPersons: TPersons;
    FRelated: TRelated;
    FAddresses: TAddresses;
    FChangeDetector: TDataChangeDetect;
    FNamePlural, FNameSingular: string;
    procedure CreateDataSet; virtual;
    procedure DoAfterScroll; override;
    procedure DoOnNewRecord; override;
    procedure DoOnCalcFields; override;
    procedure DoBeforeOpen; override;
    //function GetCustomSQL: string; virtual;
    function GetSQL: string;
    procedure GetTableName(Sender: TObject; DataSet: TDataSet;
      var TableName: WideString);
    function GetTypeFilter: string; virtual;
  public
    const
      F_CustKey = 'N';
      F_CustName = 'Name';
      F_FullName = 'FullName';
      F_ExternalName = 'ExternalName';
      F_CustPhone = 'Phone';
      F_CustPhone2 = 'Phone2';
      F_CustParentID = 'ParentID';
      F_CustNotes = 'Notes';
      CustNameSize = 50;
      F_StatusCode = 'StatusCode';
      F_StatusName = 'StatusName';
      F_UserCode = 'UserCode';
      F_ActivityCode = 'ActivityCode';
      F_ActivityName = 'ActivityName';
      F_SyncState = 'SyncState';
      F_CreationDate = 'CreationDate';
      F_FirstPersonName = 'FirstPersonName';
      F_BriefNote = 'BriefNote';
      F_ContragentType = 'ContragentType';
      F_Alert = 'Alert';
      F_IsDead = 'IsDead';
      F_ActivityCodes = 'ActivityCodes';
      BriefNoteSize = 128;
      ActivityCodesSize = 300;
      ActivityDelimiter = '|';
    class var
      NoNameKey: integer;

    constructor Create(_ContragentType: integer);
    constructor Copy(Source: TContragents);
    destructor Destroy; override;
    function FindName(Name: string): boolean;
    function Validate(var Msg: string): boolean; virtual;
    function AddNew(Info: TContragentInfo): integer;
    function GetInfo: TContragentInfo; overload;
    // меняет текущую запись!
    function GetInfo(KeyVal: integer): TContragentInfo; overload;
    procedure SetInfo(KeyVal: integer; Info: TContragentInfo);
    function NeedReload: boolean; override;
    function FindActivity(_ActivityID: integer): boolean;
    procedure AddActivity(_ActivityID: integer);
    procedure DeleteActivity(_ActivityID: integer);

    class procedure CreateContragentFields(FDataSet: TDataSet);

    property NamePlural: string read FNamePlural;
    property NameSingular: string read FNameSingular;

    // свойства для полей данных
    property Name: string read GetName write SetName;
    property FullName: string read GetFullName write SetFullName;
    property RequireInfoSource: boolean read FRequireInfoSource;
    property RequireFirmType: boolean read FRequireFirmType;
    property Persons: TPersons read GetPersons;
    property Related: TRelated read GetRelated;
    property Addresses: TAddresses read GetAddresses;
    property PersonType: Integer read GetPersonType;
    property FirmBirthday: variant read GetFirmBirthday write SetFirmBirthday;
    property WorkSeparation: boolean read FWorkSeparation;
    // Значение типа контрагента для класса, может не соотв. текущему, если типы объединяются
    property ContragentType: integer read FContragentType write SetContragentType;
    // Значение типа текущего контрагента
    property ContragentTypeValue: integer read GetContragentTypeValue write SetContragentTypeValue;
    property SyncState: integer read GetSyncState;
    property StatusCode: variant read GetStatusCode write SetStatusCode;
    property UserCode: integer read GetUserCode;
    property ActivityCode: variant read GetActivityCode;
    property FirstPersonName: variant read GetFirstPersonName;
    property BriefNote: variant read GetBriefNote;
    // имя во внешней системе
    property ExternalName: string read GetExternalName;
    property ActivityCodes: string read GetActivityCodes write SetActivityCodes;
    property IsDead: boolean read GetIsDead;
  end;

  TCustomers = class(TContragents)
  private
    constructor Create;
  end;

  TContractors = class(TContragents)
    constructor Create;
  protected
    function GetTypeFilter: string; override;
  end;

  TSuppliers = class(TContragents)
    constructor Create;
  protected
    function GetTypeFilter: string; override;
  end;

  TContragentDetails = class(TEntity)
  protected
    FContragentType: integer;
    FParentEntity: TContragents;
    procedure CreateFields; virtual; abstract;
    procedure CreateDataSet(_ParentEntity: TContragents); virtual;
    procedure SetContragentType(TypeId: integer);
    property ContragentType: integer read FContragentType write SetContragentType;
    function GetParentFilter(Alias: string): string;
    function GetSQL: string; virtual; abstract;
    procedure DoBeforeOpen; override;
  public
    property ParentEntity: TContragents read FParentEntity;
    constructor Create(_ParentEntity: TContragents;
      _KeyField, _ForeignKeyField: string);
    constructor Copy(Source: TContragentDetails);
    destructor Destroy; override;
  end;

  TPersons = class(TContragentDetails)
  private
    function GetBirthday: variant;
    procedure SetBirthday(const Value: variant);
  protected
    function GetSQL: string; override;
    procedure CreateFields; override;
    procedure DoOnNewRecord; override;
    procedure DoBeforeOpen; override;
  public
    const
      NameFieldSize = 100;
      
    constructor Create(_ParentEntity: TContragents);
    function GetInfo: TPersonInfo;
    procedure SetInfo(KeyVal: variant; Info: TPersonInfo);
    //procedure SetInfo(Info: TPersonInfo); overload;
    function AddNew(Info: TPersonInfo): integer;
    function LocateByName(_Name: string; LocateOptions: TLocateOptions): boolean;
    function Validate(var Msg: string): boolean;

    property Birthday: variant read GetBirthday write SetBirthday;
  end;

  TRelated = class(TContragentDetails)
  private
    const
      F_RelatedContragentID = 'RelatedContragentID';
      F_Name = 'Name';
      NameSize = 200;
      F_ContactName = 'ContactName';
      ContactNameSize = 200;
      F_Code = 'Code';
      CodeSize = 50;
      F_Phone1 = 'Phone1';
      F_Phone2 = 'Phone2';
      PhoneSize = 100;
    function GetContragentName: string;
    procedure SetContragentName(const Value: string);
    {function GetContragentFullName: string;
    procedure SetContragentFullName(const Value: string);
    function GetContragentPhone: string;
    procedure SetContragentPhone(const Value: string); }
  protected
    function GetSQL: string; override;
    procedure CreateFields; override;
    //procedure ProviderBeforeUpdateRecord(Sender: TObject; SourceDS: TDataSet;
    //  DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind; var Applied: Boolean); override;
  public
    constructor Create(_ParentEntity: TContragents);
    property ContragentName: string read GetContragentName write SetContragentName;
    {property ContragentFullName: string read GetContragentFullName write SetContragentFullName;
    property ContragentPhone: string read GetContragentPhone write SetContragentPhone;}
  end;

  TAddresses = class(TContragentDetails)
  private
    function GetAddress: string;
    procedure SetAddress(const Value: string);
    function GetNote: variant;
    procedure SetNote(const Value: variant);
  protected
    procedure CreateFields; override;
    function GetSQL: string; override;
  public
    const
      F_AddressName = 'Name';
      AddressNameFieldSize = 150;

    constructor Create(_ParentEntity: TContragents);

    property Address: string read GetAddress write SetAddress;
    property Note: variant read GetNote write SetNote;
  end;

var
  FCustomers, FContractors, FSuppliers: TContragents;

const
  caCustomer = 1;
  caContractor = 2;
  caSupplier = 3;

  PersonType_Juri = 0;
  PersonType_Phys = 1;

function Customers: TContragents;
function Contractors: TContragents;
function Suppliers: TContragents;

implementation

uses SysUtils, Variants, PmAccessManager, PmDatabase, RDBUtils, PmChangeObjectIds,
  CalcUtils, DicObj, StdDic, PmConfigManager;

const
  F_PersonKey: string = 'PersonID';
  F_PersonName: string = 'Name';
  F_CustomerID = 'CustomerID';

  F_AddressID: string = 'AddressID';

var
  CustDM: TDataModule;

function Customers: TContragents;
begin
  Result := FCustomers;
end;

function Contractors: TContragents;
begin
  Result := FContractors;
end;

function Suppliers: TContragents;
begin
  if EntSettings.AllContractors then
    Result := FContractors
  else
    Result := FSuppliers;
end;

{$REGION '----------------- TContragents ------------------' }

constructor TContragents.Create(_ContragentType: integer);
begin
  inherited Create;
  FKeyField := F_CustKey;
  CreateDataSet;
  NewRecordProc := 'up_NewContragent';
  DeleteRecordProc := 'up_DeleteContragent';
  // перед созданием дочерних
  ContragentType := _ContragentType;
  FPersons := TPersons.Create(Self);
  DetailData[0] := FPersons;
  FRelated := TRelated.Create(Self);
  DetailData[1] := FRelated;
  FAddresses := TAddresses.Create(Self);
  DetailData[2] := FAddresses;
  // Контрагенты будут обновляться только если были изменения в таблице
  FChangeDetector := TADODataChangeDetect.Create(TChangeObjectID.Contragent);
end;

constructor TContragents.Copy(Source: TContragents);
begin
  inherited Create;
  FKeyField := Source.KeyField;
  SetDataSet(Source.CopyData(true));
  ContragentType := Source.ContragentType;
end;

destructor TContragents.Destroy;
begin
  FreeAndNil(FPersons);
  FreeAndNil(FRelated);
  FreeAndNil(FAddresses);
  FreeAndNil(FChangeDetector);
  inherited Destroy;
end;

function TContragents.NeedReload: boolean;
begin
  FChangeDetector.CheckNow;
  Result := FChangeDetector.Changed;
  FChangeDetector.Reset;
end;

function TContragents.GetTypeFilter: string;
begin
  Result := F_ContragentType + ' = ' + IntToStr(FContragentType);
end;

procedure TContragents.CreateDataSet;
var
  FDataSet: TClientDataSet;
begin
  // Должен быть в том же модуле, пока на одном уровне работают, т.к. нет connection
  FDataSet := TClientDataSet.Create(CustDM);
  SetDataSet(FDataSet);
  DataSetProvider := TDataSetProvider.Create(CustDM);
  DataSetProvider.Name := ClassName + 'DataSetProvider';
  ADODataSet := TADOQuery.Create(CustDM);

  DataSetProvider.DataSet := ADODataSet;
  DataSetProvider.Options := [poAllowMultiRecordUpdates, poPropogateChanges];
  DataSetProvider.UpdateMode := upWhereKeyOnly;
  DataSetProvider.OnGetTableName := GetTableName;

  FDataSet.FilterOptions := [foCaseInsensitive];
  CreateContragentFields(FDataSet);
  //FDataSet.SetProvider(FDataSetProvider);
  FDataSet.ProviderName := DataSetProvider.Name;
end;

class procedure TContragents.CreateContragentFields(FDataSet: TDataSet);
begin
  with TAutoIncField.Create(FDataSet.Owner) do begin
    FieldName := F_CustKey;
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := F_CustName;
    ProviderFlags := [pfInUpdate];
    Size := CustNameSize;
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := 'Fax';
    ProviderFlags := [pfInUpdate];
    Size := 30;
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := F_CustPhone;
    ProviderFlags := [pfInUpdate];
    Size := 40;
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := 'Address';
    ProviderFlags := [pfInUpdate];
    Size := 150;
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := 'Email';
    ProviderFlags := [pfInUpdate];
    Size := 70;
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := 'Bank';
    ProviderFlags := [pfInUpdate];
    Size := 80;
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := 'IndCode';
    ProviderFlags := [pfInUpdate];
    Size := 12;
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := 'NDSCode';
    ProviderFlags := [pfInUpdate];
    Size := 12;
    DataSet := FDataSet;
  end;
  {with TStringField.Create(nil) do begin
    FieldName := 'Director';
    ProviderFlags := [pfInUpdate];
    Size := 60;
    DataSet := FDataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := 'Gertva';
    ProviderFlags := [pfInUpdate];
    Size := 50;
    DataSet := FDataSet;
  end;}
  with TBooleanField.Create(FDataSet.Owner) do begin
    FieldName := 'IsWork';
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TIntegerField.Create(FDataSet.Owner) do begin
    FieldName := 'SourceCode';
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TIntegerField.Create(FDataSet.Owner) do begin
    FieldName := F_UserCode;
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TIntegerField.Create(FDataSet.Owner) do begin
    FieldName := F_ContragentType;
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := 'SourceOther';
    ProviderFlags := [pfInUpdate];
    Size := 50;
    DataSet := FDataSet;
  end;
  with TDateTimeField.Create(FDataSet.Owner) do begin
    FieldName := 'FirmBirthday';
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  {with TDateTimeField.Create(nil) do begin
    FieldName := 'DirectorBirthday';
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TDateTimeField.Create(nil) do begin
    FieldName := 'GertvaBirthday';
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;}
  with TDateTimeField.Create(FDataSet.Owner) do begin
    FieldName := 'CreationDate';
    ProviderFlags := [];
    DisplayFormat := 'dd.mm.yyyy';
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := 'FirmType';
    ProviderFlags := [pfInUpdate];
    Size := 30;
    DataSet := FDataSet;
  end;
  with TIntegerField.Create(FDataSet.Owner) do begin
    FieldName := 'PersonType';
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TIntegerField.Create(FDataSet.Owner) do begin
    FieldName := 'ContragentGroup';
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TIntegerField.Create(FDataSet.Owner) do begin
    FieldName := F_CustParentID;
    ProviderFlags := [];   // Не обновляется!
    DataSet := FDataSet;
  end;
  with TMemoField.Create(FDataSet.Owner) do begin
    FieldName := F_CustNotes;
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := F_FullName;
    ProviderFlags := [pfInUpdate];
    Size := 300;
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := 'OKPOCode';
    ProviderFlags := [pfInUpdate];
    Size := 10;
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := F_CustPhone2;
    ProviderFlags := [pfInUpdate];
    Size := 40;
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := 'LegalAddress';
    ProviderFlags := [pfInUpdate];
    Size := 200;
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := F_ExternalName;
    ProviderFlags := [pfInUpdate];
    Size := 50;
    DataSet := FDataSet;
  end;
  with TIntegerField.Create(FDataSet.Owner) do begin
    FieldName := F_SyncState;
    ProviderFlags := [];   // Не обновляется!
    DataSet := FDataSet;
  end;
  with TFloatField.Create(FDataSet.Owner) do begin
    FieldName := 'PrePayPercent';
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TFloatField.Create(FDataSet.Owner) do begin
    FieldName := 'PreShipPercent';
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TIntegerField.Create(FDataSet.Owner) do begin
    FieldName := 'PayDelay';
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TBooleanField.Create(FDataSet.Owner) do begin
    FieldName := 'IsPayDelayInBankDays';
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TIntegerField.Create(FDataSet.Owner) do begin
    FieldName := F_StatusCode;
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := F_StatusName;
    ProviderFlags := [];
    FieldKind := fkLookup;
    LookupResultField := F_DicItemName;
    LookupCache := true;
    LookupKeyFields := F_DicItemCode;
    KeyFields := F_StatusCode;
    Size := DicItemNameSize;
    DataSet := FDataSet;
  end;
  with TBooleanField.Create(FDataSet.Owner) do begin
    FieldName := 'CheckPayConditions';
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TIntegerField.Create(FDataSet.Owner) do begin
    FieldName := 'ActivityCode';
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := F_ActivityName;
    ProviderFlags := [];
    FieldKind := fkLookup;
    LookupResultField := F_DicItemName;
    LookupCache := true;
    LookupKeyFields := F_DicItemCode;
    KeyFields := 'ActivityCode';
    Size := DicItemNameSize;
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := 'FirstPersonName';
    ProviderFlags := [];
    Size := TPersons.NameFieldSize;
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := 'BriefNote';
    ProviderFlags := [pfInUpdate];
    Size := BriefNoteSize;
    DataSet := FDataSet;
  end;
  with TBooleanField.Create(FDataSet.Owner) do begin
    FieldName := 'SyncWeb';
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TBooleanField.Create(FDataSet.Owner) do begin
    FieldName := F_Alert;
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TBooleanField.Create(FDataSet.Owner) do begin
    FieldName := F_IsDead;
    ProviderFlags := [pfInUpdate];
    DataSet := FDataSet;
  end;
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := F_ActivityCodes;
    ProviderFlags := [pfInUpdate];
    Size := ActivityCodesSize;
    DataSet := FDataSet;
  end;
  // вычисляемые
  with TStringField.Create(FDataSet.Owner) do begin
    FieldName := 'CreatorName';
    ProviderFlags := [];
    Calculated := true;
    Size := AccessManager.MaxUserName;
    DataSet := FDataSet;
  end;
end;

procedure TContragents.DoOnNewRecord;
begin
  DataSet['IsWork'] := false;
  DataSet[F_UserCode] := AccessManager.CurUser.ID;
  DataSet[F_ContragentType] := FContragentType;
  DataSet['PersonType'] := 0;
  // Если пользователь работает с определенной группой контрагентов,
  // то создаем его в этой группе.
  if not VarIsNull(AccessManager.CurUser.ContragentGroup) then
    DataSet['ContragentGroup'] := AccessManager.CurUser.ContragentGroup;
  DataSet['PrePayPercent'] := 0;
  DataSet['PreShipPercent'] := 100;
  DataSet['PayDelay'] := 0;
  DataSet['IsPayDelayInBankDays'] := false;
  DataSet['CheckPayConditions'] := false;
  DataSet[F_Alert] := false;
  DataSet['SyncWeb'] := false;
  DataSet[F_IsDead] := false;
end;

function TContragents.FindName(Name: string): boolean;
begin
  if not DataSet.Active then Database.OpenDataSet(DataSet);
  Result := DataSet.Locate(F_CustName, Name, []);
end;

function TContragents.GetName: string;
begin
  Result := DataSet[F_CustName];
end;

function TContragents.GetFullName: string;
begin
  Result := DataSet[F_FullName];
end;

function TContragents.GetFirmBirthday: variant;
begin
  Result := DataSet['FirmBirthday'];
end;

function TContragents.GetExternalName: string;
begin
  Result := DataSet[F_ExternalName];
end;

function TContragents.GetActivityCodes: string;
begin
  Result := NvlString(DataSet[F_ActivityCodes]);
end;

function TContragents.GetContragentTypeValue: integer;
begin
  Result := NvlInteger(DataSet[F_ContragentType]);
end;

function TContragents.GetIsDead: boolean;
begin
  Result := NvlBoolean(DataSet[F_IsDead]);
end;

procedure TContragents.SetContragentType(id: integer);
var
  I: Integer;
  dt: TEntity;
begin
  FContragentType := id;
  {if FPersons <> nil then
  begin
    if FPersons.ContragentType <> FContragentType then
      FPersons.ContragentType := FContragentType;
  end;}
  for I := Low(FDetailData) to High(FDetailData) do
  begin
    dt := DetailData[I];
    if dt is TContragentDetails then
      if (dt as TContragentDetails).ContragentType <> FContragentType then
        (dt as TContragentDetails).ContragentType := FContragentType;
  end;
end;

function TContragents.GetSQL: string;
var
  OwnFilter: string;
begin
  if AccessManager.CurUser.ViewOtherCustomer then
  begin
    // Ограничение просмотра - группа заказчиков
    if not VarIsNull(AccessManager.CurUser.ContragentGroup) then
      OwnFilter := 'and (ContragentGroup = ' + IntToStr(AccessManager.CurUser.ContragentGroup)
        + ' or ContragentGroup is null)'
    else
      OwnFilter := ''
  end
  else
    // Ограничение просмотра - только свои заказчики
    OwnFilter := ' and UserCode = ' + IntToStr(AccessManager.CurUser.ID);

  Result := 'select [N], [Name], [FullName], [Fax], [Phone], [Phone2], [Address], [Email], [Bank], [IndCode], '
       + ' [NDSCode], [OKPOCode], [SourceCode], [UserCode], [SourceOther], '
       + ' [FirmBirthday], [PersonType], [FirmType], ContragentGroup, [ParentID], [Notes], '
       + ' [ContragentType], [CreationDate], [SyncState], [LegalAddress],' + #13#10
       + ' [ExternalName], PrePayPercent, PreShipPercent, PayDelay, IsPayDelayInBankDays, StatusCode,' + #13#10
       + ' ActivityCode, CheckPayConditions, BriefNote, Alert, SyncWeb, IsDead, ActivityCodes,' + #13#10
       + ' (select top 1 Name from Persons p where p.CustomerID = c.N) as FirstPersonName,' + #13#10
       + ' (case when exists(select * from AliveWorkOrders with (noexpand) where Customer = c.N /*and IsDeleted = 0 and IsDraft = 0*/) then cast(1 as bit) else cast(0 as bit) end) as IsWork' + #13#10
       + 'from Customer c' + #13#10
       + 'where [Name] <> '#39'NONAME'#39' and ' + GetTypeFilter + ' and IsDeleted = 0'
       + OwnFilter + #13#10
       + ' order by [Name]';
end;

procedure TContragents.DoBeforeOpen;
var
  lds: TDataSet;
begin
  inherited;
  if EntSettings.AllContractors and (ContragentType <> caCustomer) then
    lds := TConfigManager.Instance.StandardDics.deContragentType.DicItems
  else
    lds := TConfigManager.Instance.StandardDics.deContragentStatus.DicItems;
  DataSet.FieldByName(F_StatusName).LookupDataSet := lds;
  DataSet.FieldByName(F_ActivityName).LookupDataSet := TConfigManager.Instance.StandardDics.deContragentActivity.DicItems;
  with ADODataSet do
  begin
    SQL.Clear;
    SQL.Add(GetSQL);
  end;
end;

{function TContragents.GetCustomSQL: string;
begin
  Result := '';
end;}

procedure TContragents.SetName(_Name: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet[F_CustName] := _Name;
end;

procedure TContragents.SetFullName(_FullName: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet[F_FullName] := _FullName;
end;

procedure TContragents.SetFirmBirthday(_Birthday: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['FirmBirthday'] := _Birthday;
end;

procedure TContragents.SetContragentTypeValue(_Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet[F_ContragentType] := _Value;
end;

procedure TContragents.SetStatusCode(_Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet[F_StatusCode] := _Value;
end;

procedure TContragents.SetActivityCodes(_Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet[F_ActivityCodes] := _Value;
end;

procedure TContragents.AddActivity(_ActivityID: integer);
begin
  if not FindActivity(_ActivityID) then
  begin
    if ActivityCodes = '' then
      ActivityCodes := ActivityDelimiter;

    ActivityCodes := ActivityCodes + IntToStr(_ActivityID) + ActivityDelimiter;
  end;
end;

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter := Delimiter;
   ListOfStrings.StrictDelimiter := True;
   ListOfStrings.DelimitedText := Str;
end;

function Join(Delimiter: Char; ListOfStrings: TStrings): string;
var
  S: string;
  I: integer;
begin
  if ListOfStrings.Count = 0 then
    S := ''
  else
  begin
    S := ListOfStrings[0];
    if ListOfStrings.Count > 0 then
      for I := 1 to ListOfStrings.Count - 1 do
        S := S + '|' + ListOfStrings[I];
  end;
  Result := S;
end;

procedure TContragents.DeleteActivity(_ActivityID: integer);
var
  Codes: TStringList;
  i: integer;
begin
  if FindActivity(_ActivityID) then
  begin
    Codes := TStringList.Create;
    try
      Split(ActivityDelimiter, ActivityCodes, Codes);
      i := Codes.IndexOf(IntToStr(_ActivityID));
      Codes.Delete(i);
      ActivityCodes := Join(ActivityDelimiter, Codes);
      if ActivityCodes = ActivityDelimiter then
        ActivityCodes := '';
      // StringReplace(ActivityCodes, ActivityDelimiter + IntToStr(_ActivityID) + ActivityDelimiter, '', []);
    finally
      Codes.Free;
    end;
  end;
end;

function TContragents.FindActivity(_ActivityID: integer): boolean;
begin
  Result := Pos(ActivityDelimiter + IntToStr(_ActivityID) + ActivityDelimiter, ActivityCodes) > 0
end;

function TContragents.Validate(var Msg: string): boolean;
begin
  Result := not (VarIsNull(DataSet[F_CustName]) or
    VarIsEmpty(DataSet[F_CustName]) or
    (Trim(DataSet[F_CustName]) = ''));
  if not Result then
    Msg := 'Не указано наименование'
  else
  begin
    Result := not (EntSettings.RequireInfoSource and FRequireInfoSource
        and (VarIsNull(DataSet['SourceCode'])
          or VarIsEmpty(DataSet['SourceCode'])));
    if not Result then
      Msg := 'Не указан источник информации'
    else
    begin
      // Форма собственности больше не нужна, т.к. есть полное наименование, поэтому
      // настройка используется для указания категории клиента
      Result := not EntSettings.RequireFirmType or (NvlInteger(StatusCode) <> 0);
      if not Result then
        Msg := 'Не указана категория заказчика'
      {// указание формы собственности может требоваться только для
      // юридических лиц
      Result := not (EntSettings.RequireFirmType and FRequireFirmType
          and (VarIsNull(DataSet['FirmType']) or VarIsEmpty(DataSet['FirmType']))
          and (PersonType = PersonType_Juri));
      if not Result then
        Msg := 'Не указана форма собственности'}
      else
      begin
        Result := not (EntSettings.RequireFullName
          and (Trim(NvlString(DataSet['FullName'])) = '')
          and (PersonType = PersonType_Juri));
        if not Result then
          Msg := 'Не указано полное наименование'
        else
        begin
          Result := (DataSet['PrePayPercent'] >= 0) and (DataSet['PrePayPercent'] <= 100)
            and (DataSet['PreShipPercent'] >= 0) and (DataSet['PreShipPercent'] <= 100)
            and (DataSet['PrePayPercent'] + DataSet['PreShipPercent'] <= 100)
            and (DataSet['PayDelay'] >= 0);
          if not Result then
            Msg := 'Некорректные условия оплаты'
          else
          begin
            Result := not EntSettings.RequireActivity or (NvlString(ActivityCodes) <> '');
            if not Result then
              Msg := 'Не указан вид деятельности контрагента'
            else
            begin
              Result := not (EntSettings.AllContractors and (ContragentType <> caCustomer))
                or (NvlInteger(StatusCode) <> 0);
              if not Result then
                Msg := 'Не указан вид контрагента'
              else
                Msg := ''
            end
          end;
        end;
      end;
    end;
  end;
end;

function TContragents.AddNew(Info: TContragentInfo): integer;
begin
  DataSet.Append;
  SetInfo(0, Info);
  DataSet.Post;
  Result := 0;
end;

function TContragents.GetInfo: TContragentInfo;
var
  Info: TContragentInfo;
begin
  Info.Name := DataSet[F_CustName];
  Info.FullName := NvlString(DataSet[F_FullName]);
  Info.Fax := NvlString(DataSet['Fax']);
  Info.Phone := NvlString(DataSet[F_CustPhone]);
  Info.Phone2 := NvlString(DataSet[F_CustPhone2]);
  Info.Address := NvlString(DataSet['Address']);
  Info.Email := NvlString(DataSet['Email']);
  //Info.Gertva := NvlString(DataSet['Gertva']);
  Info.SourceOther := NvlString(DataSet['SourceOther']);
  Info.SourceCode := NvlInteger(DataSet['SourceCode']);
  Info.FirmType := NvlString(DataSet['FirmType']);
  Info.PersonType := NvlInteger(DataSet['PersonType']);

  //Info.Director := NvlString(DataSet['Director']);
  Info.IndCode := NvlString(DataSet['IndCode']);
  Info.NDSCode := NvlString(DataSet['NDSCode']);
  Info.Bank := NvlString(DataSet['Bank']);
  Info.LegalAddress := NvlString(DataSet['LegalAddress']);
  Info.ExternalName := NvlString(DataSet['ExternalName']);
  Info.PrePayPercent := NvlFloat(DataSet['PrePayPercent']);
  Info.PreShipPercent := NvlFloat(DataSet['PreShipPercent']);
  Info.PayDelay := NvlInteger(DataSet['PayDelay']);
  Info.IsPayDelayInBankDays := NvlBoolean(DataSet['IsPayDelayInBankDays']);
  Info.CheckPayConditions := NvlBoolean(DataSet['CheckPayConditions']);
  Info.StatusCode := NvlInteger(StatusCode);
  Info.ActivityCode := NvlInteger(ActivityCode);
  Info.BriefNote := NvlString(BriefNote);
  Info.Alert := NvlBoolean(DataSet[F_Alert]);

  //Info.DirectorBirthday := NvlFloat(DataSet['DirectorBirthday']);
  Info.FirmBirthday := NvlFloat(DataSet['FirmBirthday']);
  //Info.GertvaBirthday := NvlFloat(DataSet['GertvaBirthday']);
  Info.CreationDate := NvlFloat(DataSet['CreationDate']);

  Info.ParentID := NvlInteger(DataSet[F_CustParentID]);

  Info.Valid := true;

  Result := Info;
end;

procedure TContragents.SetInfo(KeyVal: integer; Info: TContragentInfo);
begin
  if (NvlInteger(KeyVal) = 0) or Locate(KeyVal) then
  begin
    if not (DataSet.State in [dsInsert, dsEdit]) then
      DataSet.Edit;
      
    DataSet[F_CustName] := Info.Name;
    DataSet[F_FullName] := Info.FullName;
    DataSet['Fax'] := Info.Fax;
    DataSet['Phone'] := Info.Phone;
    DataSet['Phone2'] := Info.Phone2;
    DataSet['Address'] := Info.Address;
    DataSet['Email'] := Info.Email;
    //DataSet['Gertva'] := Info.Gertva;
    DataSet['SourceOther'] := Info.SourceOther;
    DataSet['SourceCode'] := Info.SourceCode;
    DataSet['PersonType'] := Info.PersonType;
    DataSet['FirmType'] := Info.FirmType;

    //DataSet['Director'] := Info.Director;
    DataSet['IndCode'] := Info.IndCode;
    DataSet['NDSCode'] := Info.NDSCode;
    DataSet['Bank'] := Info.Bank;
    DataSet['LegalAddress'] := Info.LegalAddress;
    DataSet[F_ExternalName] := Info.ExternalName;
    DataSet['PrePayPercent'] := Info.PrePayPercent;
    DataSet['PreShipPercent'] := Info.PreShipPercent;
    DataSet['PayDelay'] := Info.PayDelay;
    DataSet['IsPayDelayInBankDays'] := Info.IsPayDelayInBankDays;
    DataSet['CheckPayConditions'] := Info.CheckPayConditions;
    DataSet[F_StatusCode] := Info.StatusCode;
    DataSet[F_ActivityCode] := Info.ActivityCode;
    DataSet[F_BriefNote] := Info.BriefNote;
    DataSet[F_Alert] := Info.Alert;

    //DataSet['DirectorBirthday'] := Info.DirectorBirthday;
    DataSet['FirmBirthday'] := Info.FirmBirthday;
    //DataSet['GertvaBirthday'] := Info.GertvaBirthday;

    DataSet['ParentID'] := Info.ParentID;
  end;
end;

procedure TContragents.DoAfterScroll;
begin
  inherited DoAfterScroll;
  UpdateChildDataFilter;
end;

function TContragents.GetInfo(KeyVal: integer): TContragentInfo;
var
  Info: TContragentInfo;
begin
  if not DataSet.Active then
    Database.OpenDataSet(DataSet);
  if DataSet.Locate(FKeyField, KeyVal, []) then
    Result := GetInfo
  else begin
    Info.Valid := false;
    Result := Info;
  end;
end;

function TContragents.GetPersons: TPersons;
begin
  Result := DetailData[0] as TPersons;
end;

function TContragents.GetRelated: TRelated;
begin
  Result := DetailData[1] as TRelated;
end;

function TContragents.GetAddresses: TAddresses;
begin
  Result := DetailData[2] as TAddresses;
end;

function TContragents.GetPersonType: Integer;
begin
  Result := DataSet['PersonType'];
end;

procedure TContragents.DoOnCalcFields;
begin
  DataSet['CreatorName'] := AccessManager.FormatUserName(NvlInteger(DataSet['UserCode']));
end;

function TContragents.GetSyncState: integer;
begin
  Result := NvlInteger(DataSet['SyncState']);
end;

function TContragents.GetStatusCode: variant;
begin
  Result := DataSet[F_StatusCode];
end;

function TContragents.GetUserCode: integer;
begin
  Result := NvlInteger(DataSet[F_UserCode]);
end;

function TContragents.GetActivityCode: variant;
begin
  Result := DataSet[F_ActivityCode];
end;

function TContragents.GetFirstPersonName: variant;
begin
  Result := DataSet[F_FirstPersonName];
end;

function TContragents.GetBriefNote: variant;
begin
  Result := DataSet[F_BriefNote];
end;

procedure TContragents.GetTableName(Sender: TObject; DataSet: TDataSet;
      var TableName: WideString);
begin
  TableName := 'Customer';
end;

{$ENDREGION}

{$REGION 'Классы-наследники TContragents' }

constructor TCustomers.Create;
begin
  inherited Create(caCustomer);
  FNameSingular := 'заказчик';//LoadStr(S_CustomersTitle);
  FNamePlural := 'Заказчики';//LoadStr(S_CustomersTitle);
  FWorkSeparation := true;
  FRequireInfoSource := true;
  FRequireFirmType := true;
end;

constructor TContractors.Create;
begin
  inherited Create(caContractor);
  FNameSingular := 'Подрядчик';//LoadStr(S_ContractorsTitle);
  FNamePlural := 'Подрядчики';//LoadStr(S_ContractorsTitle);
  FRequireFirmType := true;
end;

{function GetContractorFilter: string;
begin
  Result := TContragents.F_ContragentType + ' = ' + IntToStr(caContractor);
  if EntSettings.AllContractors then
    Result := Result + ' or ' + TContragents.F_ContragentType + ' = ' + IntToStr(caSupplier);
end;}

function TContractors.GetTypeFilter: string;
begin
  if EntSettings.AllContractors then
    Result := TContragents.F_ContragentType + ' <> ' + IntToStr(caCustomer)
  else
    Result := TContragents.F_ContragentType + ' = ' + IntToStr(FContragentType);
  //Result := GetContractorFilter;
end;

constructor TSuppliers.Create;
begin
  inherited Create(caSupplier);
  FNameSingular := 'поставщик';//LoadStr(S_SuppliersTitle);
  FNamePlural := 'Поставщики';//LoadStr(S_SuppliersTitle);
  FRequireFirmType := true;
end;

function TSuppliers.GetTypeFilter: string;
begin
  if EntSettings.AllContractors then
    Result := TContragents.F_ContragentType + ' <> ' + IntToStr(caCustomer)
  else
    Result := TContragents.F_ContragentType + ' = ' + IntToStr(FContragentType);
  //Result := GetContractorFilter;
end;

{$ENDREGION}

{$REGION '--------------- TContragentDetails ------------------' }

constructor TContragentDetails.Create(_ParentEntity: TContragents;
  _KeyField, _ForeignKeyField: string);
begin
  inherited Create;
  FKeyField := _KeyField;
  CreateDataSet(_ParentEntity);
  ADOConnection := _ParentEntity.ADOConnection;
  ContragentType := _ParentEntity.ContragentType;
  FForeignKeyField := _ForeignKeyField;
  FAssignKeyValue := true;
end;

constructor TContragentDetails.Copy(Source: TContragentDetails);
begin
  inherited Create;
  FKeyField := Source.KeyField;
  SetDataSet(Source.CopyData(false));
  //ContragentType := Source.ContragentType;
  FForeignKeyField := Source.FForeignKeyField; // надо? есть же в конструкторе
  FAssignKeyValue := true;                     // надо? есть же в конструкторе
  FMasterData := Source.FMasterData;
  FMaxKeyValue := Source.FMaxKeyValue;
end;

destructor TContragentDetails.Destroy;
begin
  DataSet.Free;
  DataSetProvider.Free;
  ADODataSet.Free;
  inherited Destroy;
end;

procedure TContragentDetails.CreateDataSet(_ParentEntity: TContragents);
var
  FDataSet: TClientDataSet;
begin
  FParentEntity := _ParentEntity;

  FDataSet := TClientDataSet.Create(CustDM);
  FDataSet.Name := GetComponentName(CustDM, FParentEntity.ClassName + ClassName + 'DataSet');
  SetDataSet(FDataSet);
  DataSetProvider := TDataSetProvider.Create(CustDM);
  //DataSetProvider.Name := FParentEntity.ClassName + ClassName + 'DataSetProvider';
  DataSetProvider.Name := GetComponentName(CustDM, FParentEntity.ClassName + ClassName + 'DataSetProvider');
  ADODataSet := TADOQuery.Create(CustDM);
  //ADODataSet.Name := FParentEntity.ClassName + ClassName + 'ADOQuery';
  ADODataSet.Name := GetComponentName(CustDM, FParentEntity.ClassName + ClassName + 'ADOQuery');

  DataSetProvider.DataSet := ADODataSet;
  DataSetProvider.Options := [poAllowMultiRecordUpdates, poPropogateChanges];
  DataSetProvider.UpdateMode := upWhereKeyOnly;

  FDataSet.FilterOptions := [foCaseInsensitive];
  with TAutoIncField.Create(nil) do begin
    FieldName := KeyField;
    DataSet := FDataSet;
  end;

  CreateFields;

  FDataSet.ProviderName := DataSetProvider.Name;
end;

procedure TContragentDetails.SetContragentType(TypeId: integer);
begin
  if FContragentType <> TypeId then
  begin
    Close;
    FContragentType := TypeId;
    {with ADODataSet do
    begin
       SQL.Add(GetSQL);
    end;}
  end;
end;

function TContragentDetails.GetParentFilter(Alias: string): string;
var
  FieldName: string;
begin
  if Alias = '' then
    FieldName := TContragents.F_ContragentType
  else
    FieldName := Alias + '.' + TContragents.F_ContragentType;
  if FContragentType = caCustomer then
    Result := FieldName + ' = ' + IntToStr(caCustomer)
  else if EntSettings.AllContractors then
    Result := FieldName  + ' <> ' + IntToStr(caCustomer)
      //'(' + FieldName + ' = ' + IntToStr(caContractor) + ')'
      //+ ' or (' + FieldName + ' = ' + IntToStr(caSupplier) + ')'
  else
    Result := FieldName + ' = ' + IntToStr(FContragentType);
end;

procedure TContragentDetails.DoBeforeOpen;
begin
  inherited;
  with ADODataSet do
  begin
    SQL.Clear;
    SQL.Add(GetSQL);
  end;
end;

{$ENDREGION}

{$REGION '--------------- TPersons ------------------' }

constructor TPersons.Create(_ParentEntity: TContragents);
begin
  inherited Create(_ParentEntity, F_PersonKey, F_CustomerID);
end;

procedure TPersons.DoOnNewRecord;
begin
  inherited;
end;

function TPersons.GetBirthday: variant;
begin
  Result := DataSet['Birthday'];
end;

procedure TPersons.SetBirthday(const Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['Birthday'] := Value;
end;

procedure TPersons.CreateFields;
begin
  with TIntegerField.Create(nil) do begin
    FieldName := F_CustomerID;
    ProviderFlags := [pfInUpdate];
    DataSet := Self.DataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := F_PersonName;
    ProviderFlags := [pfInUpdate];
    Size := NameFieldSize;
    DataSet := Self.DataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := 'Email';
    ProviderFlags := [pfInUpdate];
    Size := 70;
    DataSet := Self.DataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := 'Phone';
    ProviderFlags := [pfInUpdate];
    Size := 40;
    DataSet := Self.DataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := 'PhoneCell';
    ProviderFlags := [pfInUpdate];
    Size := 40;
    DataSet := Self.DataSet;
  end;
  with TDateTimeField.Create(nil) do begin
    FieldName := 'Birthday';
    ProviderFlags := [pfInUpdate];
    DataSet := Self.DataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := 'PersonNote';
    ProviderFlags := [pfInUpdate];
    Size := 100;
    DataSet := Self.DataSet;
  end;
  with TIntegerField.Create(nil) do begin
    FieldName := 'PersonType';
    ProviderFlags := [pfInUpdate];
    DataSet := Self.DataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := 'PersonTypeName';
    FieldKind := fkLookup;
    LookupResultField := F_DicItemName;
    LookupCache := true;
    LookupKeyFields := F_DicItemCode;
    KeyFields := 'PersonType';
    Size := DicItemNameSize;
    ProviderFlags := [];
    DataSet := Self.DataSet;
  end;
end;

function TPersons.GetInfo: TPersonInfo;
var
  Info: TPersonInfo;
begin
  Info.Name := NvlString(DataSet[F_PersonName]);
  Info.Email := NvlString(DataSet['Email']);
  Info.Phone := NvlString(DataSet['Phone']);
  Info.PhoneCell := NvlString(DataSet['PhoneCell']);
  Info.Birthday := NvlFloat(DataSet['Birthday']);
  Info.PersonNote := NvlString(DataSet['PersonNote']);
  Info.PersonType := NvlInteger(DataSet['PersonType']);
  Result := Info;
end;

{procedure TPersons.SetInfo(Info: TPersonInfo);
begin
  SetInfo(null, Info);
end;}

procedure TPersons.SetInfo(KeyVal: variant; Info: TPersonInfo);
begin
  if (NvlInteger(KeyVal) = 0) or Locate(KeyVal) then
  begin
    if not (DataSet.State in [dsInsert, dsEdit]) then
      DataSet.Edit;

    DataSet[F_PersonName] := Info.Name;
    DataSet['Email'] := Info.Email;
    DataSet['Phone'] := Info.Phone;
    DataSet['PhoneCell'] := Info.PhoneCell;
    DataSet['Birthday'] := Info.Birthday;
    if Info.PersonType = 0 then
      DataSet['PersonType'] := null
    else
      DataSet['PersonType'] := Info.PersonType;
    DataSet['PersonNote'] := Info.PersonNote;
  end;
end;

function TPersons.AddNew(Info: TPersonInfo): integer;
begin
  DataSet.Append;
  SetInfo(null, Info);
  DataSet.Post;
  Result := 0;
end;

function TPersons.GetSQL: string;
begin
  Result := 'select PersonID, p.[Name], p.Email, p.Phone, p.PhoneCell, p.[PersonNote], p.Birthday, p.CustomerID, p.PersonType'#13#10
             + ' from Persons p inner join Customer c on p.CustomerID = c.N'#13#10
             + ' where ' + GetParentFilter('c') + ' and c.IsDeleted = 0'#13#10
             + ' order by p.[Name]';
end;

function TPersons.LocateByName(_Name: string; LocateOptions: TLocateOptions): boolean;
begin
  Result := DataSet.Locate(F_PersonName, _Name, LocateOptions);
end;

procedure TPersons.DoBeforeOpen;
begin
  inherited;
  DataSet.FieldByName('PersonTypeName').LookupDataSet := TConfigManager.Instance.StandardDics.dePersonType.DicItems;
end;

function TPersons.Validate(var Msg: string): boolean;
begin
  Result := false;
  Msg := '';
  if Trim(NvlString(DataSet['Name'])) = '' then
    Msg := 'Пожалуйста, укажите имя контактного лица'
  else if VarIsNull(DataSet['PersonType']) then
    Msg := 'Пожалуйста, укажите имя вид контакта'
  else
    Result := true;
end;

{$ENDREGION}

{$REGION '--------------- TRelated ------------------' }

constructor TRelated.Create(_ParentEntity: TContragents);
begin
  inherited Create(_ParentEntity, F_RelatedContragentID, F_CustomerID);
end;

procedure TRelated.CreateFields;
begin
  with TIntegerField.Create(nil) do begin
    FieldName := F_CustomerID;
    ProviderFlags := [pfInUpdate];
    DataSet := Self.DataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := F_Name;
    ProviderFlags := [];
    Size := NameSize;
    DataSet := Self.DataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := F_ContactName;
    ProviderFlags := [];
    Size := ContactNameSize;
    DataSet := Self.DataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := F_Code;
    ProviderFlags := [];
    Size := CodeSize;
    DataSet := Self.DataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := F_Phone1;
    ProviderFlags := [];
    Size := PhoneSize;
    DataSet := Self.DataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := F_Phone2;
    ProviderFlags := [];
    Size := PhoneSize;
    DataSet := Self.DataSet;
  end;
end;

function TRelated.GetContragentName: string;
begin
  Result := DataSet[F_Name];
end;

procedure TRelated.SetContragentName(const Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_Name] := Value;
end;
{
function TRelated.GetContragentFullName: string;
begin
  Result := DataSet[TContragents.F_FullName];
end;

procedure TRelated.SetContragentFullName(const Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[TContragents.F_FullName] := Value;
end;

function TRelated.GetContragentPhone: string;
begin
  Result := DataSet[TContragents.F_CustPhone];
end;

procedure TRelated.SetContragentPhone(const Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[TContragents.F_CustPhone] := Value;
end;

procedure TRelated.ProviderBeforeUpdateRecord(Sender: TObject; SourceDS: TDataSet;
  DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind; var Applied: Boolean);
var
  PID: string;
  NewID: integer;
  CurParentID: variant;
begin
  if (UpdateKind = ukDelete) or (UpdateKind = ukInsert) then
  begin
    if UpdateKind = ukDelete then
      PID := 'null'
    else
    begin
      CurParentID := DeltaDS[TContragents.F_CustParentID];
      NewID := FMasterData.ItemIds.GetRealItemID(CurParentID, false);
      if (NewID <> 0) and (NewID <> CurParentID) then
        PID := IntToStr(NewID)
      else
        PID := IntToStr(CurParentID);
    end;
      //PID := IntToStr(DeltaDS.FieldByName(F_CustParentID).NewValue);
    Database.ExecuteNonQuery('update Customer set ParentID = ' + PID
      + ' where N = ' + IntToStr(DeltaDS[KeyField]));
    Applied := true;
  end
  else
    Applied := true;
end;
 }
function TRelated.GetSQL: string;
begin
  Result := 'select p.RelatedContragentID, p.[Name], p.ContactName, p.Code, p.Phone1, p.Phone2, p.CustomerID' + #13#10
             + ' from RelatedContragents p inner join Customer c on p.CustomerID = c.N' + #13#10
             + ' where ' + GetParentFilter('c')
             + ' and c.IsDeleted = 0' + #13#10
             + ' order by p.[Name]'
end;

{$ENDREGION}

{$REGION '--------------- TAddresses ------------------' }

constructor TAddresses.Create(_ParentEntity: TContragents);
begin
  inherited Create(_ParentEntity, F_AddressID, F_CustomerID);
end;

procedure TAddresses.CreateFields;
begin
  with TIntegerField.Create(nil) do begin
    FieldName := F_CustomerID;
    ProviderFlags := [pfInUpdate];
    DataSet := Self.DataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := 'Address';
    ProviderFlags := [pfInUpdate];
    Size := 200;
    DataSet := Self.DataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := 'Note';
    ProviderFlags := [pfInUpdate];
    Size := 200;
    DataSet := Self.DataSet;
  end;
  with TIntegerField.Create(nil) do begin
    FieldName := 'PersonType';
    ProviderFlags := [pfInUpdate];
    DataSet := Self.DataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := 'PersonTypeName';
    FieldKind := fkLookup;
    LookupResultField := F_DicItemName;
    LookupCache := true;
    LookupKeyFields := F_DicItemCode;
    KeyFields := 'PersonType';
    Size := DicItemNameSize;
    ProviderFlags := [];
    DataSet := Self.DataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := F_AddressName;
    ProviderFlags := [pfInUpdate];
    Size := AddressNameFieldSize;
    DataSet := Self.DataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := 'Phone1';
    ProviderFlags := [pfInUpdate];
    Size := 40;
    DataSet := Self.DataSet;
  end;
  with TStringField.Create(nil) do begin
    FieldName := 'Phone2';
    ProviderFlags := [pfInUpdate];
    Size := 40;
    DataSet := Self.DataSet;
  end;
end;

function TAddresses.GetSQL: string;
begin
  Result := 'select a.AddressID, a.Address, a.Note, a.CustomerID, a.PersonType, a.Name, a.Phone1, a.Phone2' + #13#10
             + ' from Addresses a inner join Customer c on a.CustomerID = c.N' + #13#10
             + ' where ' + GetParentFilter('c')
             + ' and c.IsDeleted = 0' + #13#10
             + ' order by a.[Address]';
end;

function TAddresses.GetAddress: string;
begin
  Result := NvlString(DataSet['Address']);
end;

procedure TAddresses.SetAddress(const Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['Address'] := Value;
end;

function TAddresses.GetNote: variant;
begin
  Result := DataSet['Note'];
end;

procedure TAddresses.SetNote(const Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['Note'] := Value;
end;

{$ENDREGION}

initialization

  // Модуль для серверных данных
  CustDM := TDataModule.Create(nil);

  FCustomers := TCustomers.Create;
  FContractors := TContractors.Create;
  FSuppliers := TSuppliers.Create;

finalization

  FreeAndNil(FCustomers);
  FreeAndNil(FContractors);
  FreeAndNil(FSuppliers);

  FreeAndNil(CustDM);

end.
