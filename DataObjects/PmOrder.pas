unit PmOrder;

interface

uses Classes, SysUtils, ADODB, DB, DBClient, Provider,

  TLoggerUnit,

  PmDatabase, PmEntity, PmContragent, PmQueryPager, PmOrderParts, MainFilter,
  ServMod, PmOrderProcessItems, PmOrderAttachedFiles, PmOrderNotes,
  pmProductToStorage;

type
  TOrder = class(TEntity)
  private
    FParts: TOrderParts;
    FDataSource: TDataSource;
    FCriteria: TOrderFilterObj;
    FNewOrderKey: integer;
    FRetrieveAllReportFields: boolean;
    FAttachedFiles: TOrderAttachedFiles;
    FNotes: TOrderNotes;
    FProductStorage: TProductStorageController;
    FOnTirazzChanged: TNotifyEvent;
    function GetCostProtected: boolean;
    function GetContentProtected: boolean;
    function GetOrderNumber: variant;
    function GetKindID: integer;
    function GetRowColor: integer;
    function GetCreationDate: variant;
    function GetModifyDate: variant;
    function GetComment: string;
    function GetComment2: variant;
    function GetCustomerID: integer;
    function GetCustomerName: string;
    function GetTirazz: integer;
    procedure SetComment2(Value: variant);
    procedure TirazzChanged(Sender: TField);
    procedure CostFieldGetText(Sender: TField; var Text: String; DisplayText: Boolean);
  protected
    FNamePlural: string;
    FNameSingular: string;
    FNumberField: string;
    FDisableCalcFields: boolean;
    FProcesses: Tsm;
    FOrderItems: TOrderProcessItems;
    FDM: TDataModule;
    function GetDeletePermOwn: string; virtual; abstract;
    function GetDeletePermOther: string; virtual; abstract;
    procedure DoOnNewRecord; override;
    procedure DoAfterScroll; override;
    procedure DoBeforeOpen; override;
    procedure OnCheckActualState(CheckQuery: TADOQuery); virtual;
    procedure ProviderBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
      var Applied: Boolean); override;
    procedure DoSetSaveProcParams(sp: TADOStoredProc; NewOrder: boolean; DeltaDS: TDataSet); virtual;
    function GetSQL: TQueryObject; virtual; abstract;
    function GetOrderIDSQL: string;
    function GetSortExpr: string;
    procedure FieldChanged(Sender: TField);
    procedure CreateDataSet(DataOwner: TComponent); virtual;
    procedure IDDateValidate(Sender: TField);
    procedure OrderUserNameGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure CreateProcessData;
    function GetUSDCourse: extended; virtual; abstract;
    procedure SetUSDCourse(Value: extended); virtual; abstract;
    function GetTotalExpenseCost: Currency;
    procedure SetTotalExpenseCost(Value: Currency);
    function GetReportFieldsExpr: string;
    function GetPrePayPercent: extended;
    procedure SetPrePayPercent(Value: extended);
    function GetPreShipPercent: extended;
    procedure SetPreShipPercent(Value: extended);
    function GetPayDelay: integer;
    procedure SetPayDelay(Value: integer);
    function GetIsPayDelayInBankDays: boolean;
    procedure SetIsPayDelayInBankDays(Value: boolean);
    function GetIsLockedByUser: boolean;
    //procedure SetIsLockedByUser(Value: boolean);
    function GetCallCustomer: boolean;
    function GetCallCustomerPhone: string;
    function GetHaveLayout: boolean;
    function GetHavePattern: boolean;
    function GetSignManager: boolean;
    function GetSignProof: boolean;
    function GetHaveProof: boolean;
    function GetProductFormat: string;
    function GetProductPages: integer;
    function GetIncludeCover: boolean;
    procedure SetIsComposite(Value: boolean);
    function GetIsComposite: boolean;
    function GetHasNotes: boolean;
    function GetCreatorName: string;
    function GetIsLockedByUserExpr: string;
    function GetHasNotesExpr: string;
    procedure GetEmptyText(Sender: TField; var Text: String; DisplayText: Boolean);
    function GetFiles: TOrderAttachedFiles;
    function GetNotes: TOrderNotes;
    procedure OpenAttachedFiles;
    procedure OpenNotes;
    function GetCourseExpr: string; virtual; abstract;
  public
    const
      F_OrderKey = 'N';
      F_OrderNumber = 'ID_Number';
      F_OrderNumberText = 'ID';
      F_FinalCostGrn = 'FinalCostGrn';
      F_OrderState = 'OrderState';
      F_PayState = 'PayState';
      F_ShipmentState = 'ShipmentState';
      F_TotalExpenseCost = 'TotalExpenseCost';
      //F_TotalExpenseGrn = 'TotalExpenseGrn';
      F_TotalOrderProfitCost = 'TotalOrderProfitCost';
      F_Comment = 'Comment';
      F_Comment2 = 'Comment2';
      F_IsLockedByUser = 'IsLockedByUser';
      F_CreatorName = 'CreatorName';
      F_ClientTotal = 'ClientTotal';
      F_TotalCost = 'TotalCost';
      F_KindID = 'KindID';
      F_Course = 'Course';
      F_RowColor = 'RowColor';
      F_KindName = 'KindName';
      F_ContentProtected = 'ContentProtected';
      F_CostProtected = 'CostProtected';
      
      CommentSize = 500;
      Comment2Size = 500;
      CreatorNameSize = 128;

      NProductParamName = 'NProduct';

    constructor Create(_InternalName, _NameSingular, _NamePlural, _KeyField: string;
      _ADODataSet: TADOQuery = nil);
    destructor Destroy; override;
    procedure AfterConstruction; override;
    // Открывает содержимое заказа
    procedure OpenProcessItems(PreviewMode: boolean);
    //procedure SetViewRange(MakeActive: boolean); override;
    procedure SetSortOrder(_SortField: string; MakeActive: boolean); override;
    function ClientTotal: extended;
    function CostOf1: extended;
    function FinalCostGrn: extended;
    // Возвращает true если заказ был успешно удален
    function DeleteOrder(StartTran, FinishTran: boolean): boolean;
    function Modified: boolean; override;
    procedure ProtectCost;
    procedure ProtectContent;
    procedure UnprotectCost;
    procedure UnprotectContent;
    procedure ReadKindPermissions(NewEntity: boolean); virtual; abstract;
    class function IsLockedByAnother(var UserName: string; OrderID: integer): boolean;
    class function LockForEdit(OrderID: integer): boolean;
    class procedure UnLock(OrderID: integer);
    // Проверяет, изменился ли заказ, если да то обновляет.
    procedure CheckActualState; virtual;
    function GetCustomerInfo: TContragentInfo;
    function GetOrderPrefix: string; virtual;
    procedure ChangeCreationDate(dt: TDateTime);
    procedure ChangeNumber(Num: integer);
    // Загрузить все записи даже в режиме постраничной загрузки со всеми отчетными полями
    procedure FetchAllReportData;
    // поместить событие в историю заказа
    procedure WriteEvent(EventText: string; EventType: integer);

    property NumberField: string read FNumberField;
    property NamePlural: string read FNamePlural write FNamePlural;
    property NameSingular: string read FNameSingular write FNameSingular;

    property DataSource: TDataSource read FDataSource;

    property DisableCalcFields: boolean read FDisableCalcFields write FDisableCalcFields;
    // определяет, надо ли загружать спец. данные для отчетов
    property RetrieveAllReportFields: boolean read FRetrieveAllReportFields write FRetrieveAllReportFields;

    property CostProtected: boolean read GetCostProtected;
    property ContentProtected: boolean read GetContentProtected;
    // возвращает null для нового заказа
    property OrderNumber: variant read GetOrderNumber;
    property CreationDate: variant read GetCreationDate;
    property ModifyDate: variant read GetModifyDate;
    property KindID: integer read GetKindID;
    property RowColor: integer read GetRowColor;
    property Comment: string read GetComment;
    property Comment2: variant read GetComment2 write SetComment2;
    property CustomerID: integer read GetCustomerID;
    property CustomerName: string read GetCustomerName;
    property Parts: TOrderParts read FParts;
    property Tirazz: integer read GetTirazz;
    property USDCourse: extended read GetUSDCourse write SetUSDCourse;
    property PrePayPercent: extended read GetPrePayPercent write SetPrePayPercent;
    property PreShipPercent: extended read GetPreShipPercent write SetPreShipPercent;
    property PayDelay: integer read GetPayDelay write SetPayDelay;
    property IsPayDelayInBankDays: boolean read GetIsPayDelayInBankDays write SetIsPayDelayInBankDays;
    property IsLockedByUser: boolean read GetIsLockedByUser;// write SetIsLockedByUser;
    property IsComposite: boolean read GetIsComposite write SetIsComposite;
    property CreatorName: string read GetCreatorName;
    // Сумма затрат (с учетом реальных, если есть отметки) в нац. валюте
    property TotalExpenseCost: Currency read GetTotalExpenseCost write SetTotalExpenseCost;
    // Дополнительные примечания
    property CallCustomer: boolean read GetCallCustomer;
    property CallCustomerPhone: string read GetCallCustomerPhone;
    property HaveLayout: boolean read GetHaveLayout;
    property HavePattern: boolean read GetHavePattern;
    property ProductFormat: string read GetProductFormat;
    property ProductPages: integer read GetProductPages;
    property SignManager: boolean read GetSignManager;
    property SignProof: boolean read GetSignProof;
    property IncludeCover: boolean read GetIncludeCover;
    property HasNotes: boolean read GetHasNotes;
    property HaveProof: boolean read GetHaveProof;

    property Criteria: TOrderFilterObj read FCriteria write FCriteria;

    // модуль с процессами заказа
    property Processes: Tsm read FProcesses;
    property OrderItems: TOrderProcessItems read FOrderItems;
    property NewOrderKey: integer read FNewOrderKey write FNewOrderKey;
    property AttachedFiles: TOrderAttachedFiles read GetFiles;
    property Notes: TOrderNotes read GetNotes;
    property ProductStorage : TProductStorageController read FProductStorage;

    property OnTirazzChanged: TNotifyEvent read FOnTirazzChanged write FOnTirazzChanged;
  end;

  TDraftOrder = class(TOrder)
  protected
    function GetDeletePermOwn: string; override;
    function GetDeletePermOther: string; override;
    procedure OnCheckActualState(CheckQuery: TADOQuery); override;
    procedure DoSetSaveProcParams(sp: TADOStoredProc; NewOrder: boolean;
      DeltaDS: TDataSet); override;
    function GetSQL: TQueryObject; override;
    procedure DoOnCalcFields; override;
    procedure CreateDataSet(DataOwner: TComponent); override;
    function GetUSDCourse: extended; override;
    procedure SetUSDCourse(Value: extended); override;
    function GetCourseExpr: string; override;
  public
    constructor Create(_ADODataSet: TADOQuery = nil);
    procedure ReadKindPermissions(NewEntity: boolean); override;
    class procedure FillDateFields(var _DateFields: TDateArray; OrderPrefix: string);
  end;

  TWorkOrder = class(TOrder)
  private
    function GetSelectPayStateSQL: string;
    function GetFinishDate: TDateTime;
    function GetFactFinishDate: variant;
    function GetStartDate: variant;
    function GetPayState: variant;
    function GetAutoPayState: integer;
    function GetOrderState: integer;
    function GetShipmentApproved: boolean;
    function GetOrderMaterialsApproved: boolean;
    function GetMatRequestModified: boolean;
    function GetExternalId: variant;
    procedure SetExternalId(Value: variant);
  protected
    function GetDeletePermOwn: string; override;
    function GetDeletePermOther: string; override;
    procedure DoOnNewRecord; override;
    procedure OnCheckActualState(CheckQuery: TADOQuery); override;
    function GetPayStateFunc: string;
    function GetTotalInvoiceCostExpr: string;
    function GetTotalPayCostExpr: string;
    procedure DoSetSaveProcParams(sp: TADOStoredProc; NewOrder: boolean;
      DeltaDS: TDataSet); override;
    function GetSQL: TQueryObject; override;
    // возвращает состояние неоплаты для вида оплаты "по умолчанию"
    function GetDefaultNoPayState: integer;
    procedure DoOnCalcFields; override;
    function GetHasInvoiceExpr: string;
    procedure CreateDataSet(DataOwner: TComponent); override;
    function GetUSDCourse: extended; override;
    procedure SetUSDCourse(Value: extended); override;
    function GetOrderShipmentStateExpr: string;
    function GetMatRequestModifiedExpr: string;
    procedure DoGetFinishDateText(Sender: TField; var Text: String; DisplayText: Boolean);
    function GetCourseExpr: string; override;

  public
    const
      F_TotalInvoiceCost = 'TotalInvoiceCost';
      F_TotalPayCost = 'TotalPayCost';
      F_LastStateChange = 'StateChangeDate';
      F_AutoPayState = 'AutoPayState';
      F_DebtCost = 'DebtCost';
      F_AllDebtCost = 'AllDebtCost';
      F_StartDate = 'StartDate';
      F_OrderMaterialsApproved = 'OrderMaterialsApproved';
      F_ExternalId = 'ExternalId';

      ExternalIdSize = 50;

    constructor Create(_ADODataSet: TADOQuery = nil);
    procedure ToggleApproveShipment;
    procedure ToggleApproveOrderMaterials;
    function GetPayStateExpr(Values: string): string;
    class function GetShipmentStateExpr: string;
    class procedure FillDateFields(var _DateFields: TDateArray; OrderPrefix: string);
    // переводит дату в строку, если время <> 0:00, то добавляет время
    class function GetFinishDateText(DateValue: variant): string;
    procedure ReadKindPermissions(NewEntity: boolean); override;
    procedure ChangeStartDate(dt: variant);
    function FinishDateIndex: integer; // индекс поля с датой сдачи

    property FinishDate: TDateTime read GetFinishDate;  // плановая дата сдачи
    property FactFinishDate: variant read GetFactFinishDate;  // фактическая дата сдачи
    property AutoPayState: integer read GetAutoPayState;
    property PayState: variant read GetPayState;
    property OrderState: integer read GetOrderState;
    // отгрузка заказа разрешена
    property ShipmentApproved: boolean read GetShipmentApproved;
    // закупка материалов разрешена
    property OrderMaterialsApproved: boolean read GetOrderMaterialsApproved;
    // запрос на метериал был изменен после установки фактических данных
    // (т.е. после заказа или получения)
    property MatRequestModified: boolean read GetMatRequestModified;
    //procedure SetViewRange(MakeActive: boolean); override;
    property StartDate: variant read GetStartDate;
    property ExternalId: variant read GetExternalId write SetExternalId;
  end;

  TContract = class(TOrder)
  public
    constructor Create;
  end;

implementation

uses Graphics, Variants, Dialogs, Forms, DateUtils,

  RDialogs, ADOUtils,

  PmEntSettings, RDBUtils, PmAccessManager, CalcSettings, MainData,
  ExHandler, ServData, StdDic, DicObj, CalcUtils, PmConfigManager,
  PmLockManager;


{$REGION '------------- TOrder ----------------' }

constructor TOrder.Create(_InternalName, _NameSingular, _NamePlural, _KeyField: string;
  _ADODataSet: TADOQuery = nil);
var
  _Provider: TDataSetProvider;
begin
  inherited Create;
  FKeyField := _KeyField;

  FInternalName := _InternalName;
  FDM := TDataModule.Create(nil);
  _Provider := TDataSetProvider.Create(FDM);
  _Provider.Name := 'pv' + _InternalName;
  _Provider.DataSet := _ADODataSet;
  DataSetProvider := _Provider;
  CreateDataSet(FDM);
  ADODataSet := _ADODataSet;
  FNumberField := F_OrderNumber;
  FSortField := F_OrderNumberText;
  FNameSingular := _NameSingular;
  FNamePlural := _NamePlural;
  RefreshAfterApply := false;
  DefaultLastRecord := true;

  if DataSet <> nil then
  begin
    FDataSource := TDataSource.Create(FDM);
    FDataSource.DataSet := DataSet;
  end;

  FOrderItems := TOrderProcessItems.Create(DataSet.Owner);
  FAttachedFiles := TOrderAttachedFiles.Create(DataSet.Owner);
  FAttachedFiles.ParentOrder := Self;
  FNotes := TOrderNotes.Create(DataSet.Owner);
  FNotes.ParentOrder := Self;
  //DetailData[0] := FAttachedFiles;
end;

destructor TOrder.Destroy;
begin
  //FreeAndNil(FOrderItems);
  //FreeAndNil(FProcesses);
  //FreeAndNil(FDataSource);
  //DataSet.Free;
  FDM.Free;
  inherited;
end;

procedure TOrder.AfterConstruction;
begin
  // хотел сделать отложенное создание Tsm, но пока не получилось
  // создаем сразу
  CreateProcessData;
end;

procedure TOrder.CreateProcessData;
begin
  FProcesses := Tsm.Create(Self);
  FOrderItems.Processes := FProcesses;
  FProcesses.USDCourse := TSettingsManager.Instance.AppCourse;
end;

{$REGION 'TOrder.CreateDataSet'}

procedure TOrder.CreateDataSet(DataOwner: TComponent);
var
  _DataSet: TClientDataSet;
  f: TField;
begin
  _DataSet := TClientDataSet.Create(DataOwner);
  _DataSet.Name := GetComponentName(DataOwner, 'cd' + InternalName);
  SetDataSet(_DataSet);
  _DataSet.ProviderName := DataSetProvider.Name;
  _DataSet.FetchOnDemand := False;

  f := TIntegerField.Create(_DataSet.Owner);
  f.FieldName := F_OrderKey;
  f.DataSet := _DataSet;

  f := TStringField.Create(_DataSet.Owner);
  f.FieldName := F_OrderNumberText;
  f.Origin := 'Year(wo.CreationDate), wo.ID_Number';
  f.ProviderFlags := [];
  f.Visible := False;
  f.Size := 13;
  f.DataSet := _DataSet;

  f := TIntegerField.Create(_DataSet.Owner);
  f.FieldName := 'ID_Year';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TSmallintField.Create(_DataSet.Owner);
  f.FieldName := 'ID_date';
  f.ProviderFlags := [pfInUpdate];
  f.OnValidate := IDDateValidate;
  (f as TNumericField).DisplayFormat := '000';
  (f as TNumericField).EditFormat := '000';
  f.DataSet := _DataSet;

  f := TSmallintField.Create(_DataSet.Owner);
  f.FieldName := 'ID_kind';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TSmallintField.Create(_DataSet.Owner);
  f.FieldName := 'ID_char';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TSmallintField.Create(_DataSet.Owner);
  f.FieldName := 'ID_color';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TIntegerField.Create(_DataSet.Owner);
  f.FieldName := F_OrderNumber;
  f.ProviderFlags := [pfInUpdate];
  (f as TNumericField).DisplayFormat := CalcUtils.OrderNumDisplayFmt;
  f.DataSet := _DataSet;

  f := TIntegerField.Create(_DataSet.Owner);
  f.FieldName := 'Tirazz';
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := TirazzChanged;
  f.DataSet := _DataSet;

  f := TDateTimeField.Create(_DataSet.Owner);
  f.FieldName := 'CreationDate';
  f.Origin := 'wo.CreationDate, wo.ID_Number';
  f.ProviderFlags := [pfInUpdate];
  (f as TDateTimeField).DisplayFormat := 'dd/mm/yyyy';
  f.DataSet := _DataSet;

  f := TDateTimeField.Create(_DataSet.Owner);
  f.FieldName := 'CreationTime';
  f.Origin := 'wo.CreationDate, wo.ID_Number';
  f.ProviderFlags := [];
  (f as TDateTimeField).DisplayFormat := 'h:mm';
  f.DataSet := _DataSet;

  f := TDateTimeField.Create(_DataSet.Owner);
  f.FieldName := 'ModifyDate';
  f.Origin := 'wo.ModifyDate, wo.ID_Number';
  f.ProviderFlags := [pfInUpdate];
  (f as TDateTimeField).DisplayFormat := 'dd/mm/yyyy';
  f.DataSet := _DataSet;

  f := TDateTimeField.Create(_DataSet.Owner);
  f.FieldName := 'ModifyTime';
  f.Origin := 'wo.ModifyDate, wo.ID_Number';
  f.ProviderFlags := [];
  (f as TDateTimeField).DisplayFormat := 'h:mm';
  f.DataSet := _DataSet;

  f := TDateTimeField.Create(_DataSet.Owner);
  f.FieldName := 'CloseDate';
  f.Origin := 'wo.CloseDate, wo.ID_Number';
  f.ProviderFlags := [pfInUpdate];
  (f as TDateTimeField).DisplayFormat := 'dd/mm/yyyy';
  f.DataSet := _DataSet;

  f := TDateTimeField.Create(_DataSet.Owner);
  f.FieldName := 'CloseTime';
  f.Origin := 'wo.CloseDate, wo.ID_Number';
  f.ProviderFlags := [];
  (f as TDateTimeField).DisplayFormat := 'h:mm';
  f.DataSet := _DataSet;

  f := TStringField.Create(_DataSet.Owner);
  f.FieldName := F_Comment;
  f.Origin := 'wo.Comment, YEAR(wo.CreationDate), wo.ID_Number';
  f.ProviderFlags := [pfInUpdate];
  //f.OnChange := CommentChanged;
  f.Size := CommentSize;
  f.DataSet := _DataSet;

  f := TStringField.Create(_DataSet.Owner);
  f.FieldName := F_Comment2;
  f.ProviderFlags := [pfInUpdate];
  f.Size := Comment2Size;
  f.DataSet := _DataSet;

  f := TStringField.Create(_DataSet.Owner);
  f.FieldName := F_CreatorName;
  f.Origin := 'wo.CreatorName, YEAR(wo.CreationDate), wo.ID_Number';
  f.ProviderFlags := [pfInUpdate];
  f.OnGetText := OrderUserNameGetText;
  f.Size := CreatorNameSize;
  f.DataSet := _DataSet;

  f := TStringField.Create(_DataSet.Owner);
  f.FieldName := 'ModifierName';
  f.Origin := 'wo.ModifierName, YEAR(wo.CreationDate), wo.ID_Number';
  f.ProviderFlags := [pfInUpdate];
  f.OnGetText := OrderUserNameGetText;
  f.Size := 30;
  f.DataSet := _DataSet;

  f := TIntegerField.Create(_DataSet.Owner);
  f.FieldName := 'RowColor';
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := FieldChanged;
  f.DataSet := _DataSet;

  f := TIntegerField.Create(_DataSet.Owner);
  f.FieldName := 'Customer';
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := FieldChanged;
  f.DataSet := _DataSet;

  f := TStringField.Create(_DataSet.Owner);
  f.FieldName := 'CustomerName';
  f.Origin := 'wc.Name, YEAR(wo.CreationDate), wo.ID_Number';
  f.ProviderFlags := [pfInUpdate];
  f.Size := TContragents.CustNameSize;
  f.DataSet := _DataSet;

  f := TStringField.Create(_DataSet.Owner);
  f.FieldName := 'CustomerFax';
  f.Origin := 'wc.Fax, YEAR(wo.CreationDate), wo.ID_Number';
  f.ProviderFlags := [pfInUpdate];
  f.Size := 50;
  f.DataSet := _DataSet;

  f := TStringField.Create(_DataSet.Owner);
  f.FieldName := 'CustomerPhone';
  f.Origin := 'wc.Name, YEAR(wo.CreationDate), wo.ID_Number';
  f.ProviderFlags := [pfInUpdate];
  f.Size := 50;
  f.DataSet := _DataSet;

  f := TIntegerField.Create(_DataSet.Owner);
  f.FieldName := F_KindID;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := FieldChanged;
  f.DataSet := _DataSet;

  f := TBCDField.Create(_DataSet.Owner);
  f.FieldName := 'TotalGrn';
  f.ProviderFlags := [];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).currency := True;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := _DataSet;
  f.OnGetText := CostFieldGetText;

  f := TBCDField.Create(_DataSet.Owner);
  f.FieldName := 'CostOf1';
  f.ProviderFlags := [pfInUpdate];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).currency := True;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := _DataSet;
  f.OnGetText := CostFieldGetText;

  f := TBCDField.Create(_DataSet.Owner);
  f.FieldName := 'TotalCost';
  f.ProviderFlags := [pfInUpdate];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).currency := True;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := _DataSet;
  f.OnGetText := CostFieldGetText;

  f := TBCDField.Create(_DataSet.Owner);
  f.FieldName := 'ClientTotal';
  f.ProviderFlags := [pfInUpdate];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).Currency := True;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := _DataSet;
  f.OnGetText := CostFieldGetText;

  f := TBooleanField.Create(_DataSet.Owner);
  f.FieldName := 'IsProcessCostStored';
  f.ProviderFlags := [];
  f.DataSet := _DataSet;

  f := TBCDField.Create(_DataSet.Owner);
  f.FieldKind := fkCalculated;
  f.FieldName := 'ClientTotalGrn';
  f.Origin := 'wo.ClientTotal';
  f.ProviderFlags := [];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).currency := True;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.Calculated := True;
  f.DataSet := _DataSet;
  f.OnGetText := CostFieldGetText;

  f := TBCDField.Create(_DataSet.Owner);
  f.FieldKind := fkCalculated;
  f.FieldName := 'CostOf1Grn';
  f.ProviderFlags := [];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).currency := True;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.Calculated := True;
  f.DataSet := _DataSet;
  f.OnGetText := CostFieldGetText;

  f := TBooleanField.Create(_DataSet.Owner);
  f.FieldName := 'CostProtected';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TBooleanField.Create(_DataSet.Owner);
  f.FieldName := 'ContentProtected';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TFloatField.Create(_DataSet.Owner);
  f.FieldName := 'PrePayPercent';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TFloatField.Create(_DataSet.Owner);
  f.FieldName := 'PreShipPercent';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TIntegerField.Create(_DataSet.Owner);
  f.FieldName := 'PayDelay';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TBooleanField.Create(_DataSet.Owner);
  f.FieldName := 'IsPayDelayInBankDays';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TBCDField.Create(_DataSet.Owner);
  f.FieldName := 'FinalCostGrn';
  f.ProviderFlags := [];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).currency := True;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := _DataSet;
  f.OnGetText := CostFieldGetText;

  f := TBooleanField.Create(_DataSet.Owner);
  f.FieldName := 'ProfitByGrn';
  f.ProviderFlags := [];
  f.DataSet := _DataSet;

  f := TFloatField.Create(_DataSet.Owner);
  f.FieldName := 'ProfitPercent';
  f.ProviderFlags := [];
  f.DataSet := _DataSet;

  f := TBCDField.Create(_DataSet.Owner);
  f.FieldName := F_TotalExpenseCost;
  f.ProviderFlags := [];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).currency := True;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := _DataSet;

  {f := TBCDField.Create(_DataSet.Owner);
  f.FieldName := F_TotalExpenseGrn;
  f.FieldKind := fkCalculated;
  f.ProviderFlags := [];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).currency := True;
  f.Size := 2;
  f.DataSet := _DataSet;}

  f := TBooleanField.Create(_DataSet.Owner);
  f.FieldName := 'CostView';
  f.ProviderFlags := [];
  f.DataSet := _DataSet;

  f := TBCDField.Create(_DataSet.Owner);
  f.FieldName := F_TotalOrderProfitCost;
  f.FieldKind := fkInternalCalc;
  f.ProviderFlags := [];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).currency := True;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := _DataSet;

  f := TBooleanField.Create(_DataSet.Owner);
  f.FieldName := F_IsLockedByUser;
  f.ProviderFlags := [];
  f.OnGetText := GetEmptyText;
  f.DataSet := _DataSet;

  f := TBooleanField.Create(_DataSet.Owner);
  f.FieldName := 'CallCustomer';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TStringField.Create(_DataSet.Owner);
  f.FieldName := 'CallCustomerPhone';
  f.ProviderFlags := [pfInUpdate];
  f.Size := 40;
  f.DataSet := _DataSet;

  f := TBooleanField.Create(_DataSet.Owner);
  f.FieldName := 'HaveLayout';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TBooleanField.Create(_DataSet.Owner);
  f.FieldName := 'HavePattern';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TBooleanField.Create(_DataSet.Owner);
  f.FieldName := 'SignManager';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TBooleanField.Create(_DataSet.Owner);
  f.FieldName := 'SignProof';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TBooleanField.Create(_DataSet.Owner);
  f.FieldName := 'HaveProof';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TStringField.Create(_DataSet.Owner);
  f.FieldName := 'ProductFormat';
  f.ProviderFlags := [pfInUpdate];
  f.Size := 40;
  f.DataSet := _DataSet;

  f := TIntegerField.Create(_DataSet.Owner);
  f.FieldName := 'ProductPages';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TBooleanField.Create(_DataSet.Owner);
  f.FieldName := 'IncludeCover';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := _DataSet;

  f := TBooleanField.Create(DataOwner);
  f.FieldName := 'IsComposite';
  f.ProviderFlags := [pfInUpdate];
  f.OnGetText := GetEmptyText;
  f.DataSet := DataSet;

  f := TBooleanField.Create(_DataSet.Owner);
  f.FieldName := 'HasNotes';
  f.ProviderFlags := [];
  f.DataSet := _DataSet;

end;

{$ENDREGION}

procedure TOrder.TirazzChanged(Sender: TField);
begin
  TLogger.getInstance.Info('Изменение тиража');
  if Sender.IsNull then Sender.Value := 0;
  if FProcesses.ServicesActive then
  begin
    // Привязка к тиражу - вызов обработки изменения глобального параметра
    FProcesses.OrderParamChanged(NProductParamName, Sender.Value);
    // Обновляем, т.к. поменялись количества, а в это время может быть видимой страница состава заказа
    FProcesses.SetScriptedItemParams;
  end;
  if Assigned(FOnTirazzChanged) then
    FOnTirazzChanged(Self);
end;

procedure TOrder.FieldChanged(Sender: TField);
begin
  if Assigned(FProcesses.OnUpdateModified) then
    FProcesses.OnUpdateModified(nil);
end;

// APPSERVER!!!!!!!!!!!!!!!!!!!
function TOrder.GetOrderIDSQL: string;
const
  FullOrderIDSQL = 'CAST(REPLICATE(''0'', 3-DATALENGTH(CAST(wo.ID_Date as varchar(3)))) + CAST(wo.ID_Date as varchar(3)) + ''-'' + ' + 'CAST(wo.ID_kind as varchar(1)) + CAST(wo.ID_char as varchar(1)) + CAST(wo.ID_color as varchar(1)) + ''-'' + REPLICATE(''0'', 5 - DATALENGTH(CAST(wo.ID_Number as varchar(5)))) + CAST(wo.ID_Number as varchar(5)) as varchar(13)) as ID,';
  BriefOrderIDSQL = 'CAST(REPLICATE(''0'', 5 - DATALENGTH(CAST(wo.ID_Number as varchar(5)))) + CAST(wo.ID_Number as varchar(5)) as varchar(5)) as ID,';
begin
  {$IFNDEF Demo}
  if not EntSettings.BriefOrderID then begin
    Result := FullOrderIDSQL;
  end else begin
    Result := BriefOrderIDSQL;
  end;
  {$ELSE}
  if not EntSettings.BriefOrderID then begin  // демо-режим (ACCESS)
    Result := '''205-111-'' + CStr(ID_Number) as ID,';
  end else begin
    Result := 'CStr(ID_Number) as ID,';
  end;
  {$ENDIF}
end;

  {function GetCurYear: integer;
  var
    Present: TDateTime;
    Year, Month, Day: Word;
  begin
    Present := Now;
    DecodeDate(Present, Year, Month, Day);
    Result := Year;
  end;

  function GetCurYearLastDigit: integer;
  begin
    Result := GetCurYear mod 10;
  end;

  function GetCurMonth: integer;
  var
    Present: TDateTime;
    Year, Month, Day: Word;
  begin
    Present := Now;
    DecodeDate(Present, Year, Month, Day);
    Result := Month;
  end;}

// TODO: разделить на APPSERVER и client
(*procedure TOrder.SetViewRange(MakeActive: boolean);
var
  s, wl: string;
  sSQL: string;
  i, k: integer;
  DQ: TADOQuery;
  cd: TDataSet;
begin
  dq := ADODataSet as TADOQuery;
  cd := DataSet;
  if cd.Active then k := NvlInteger(KeyValue) else k := 0;
  if MFFilter.FilterEnabled or AccessManager.CurUser.ViewOwnOnly then
  begin
    cd.DisableControls;
    try
      if Options.ServFilter then
      begin
        // Проверяет строку, предшествующую строке с макросом RANGE
        if (Pos('where', dq.SQL[FRangeLine - 1]) <> 0) or
           (Pos('WHERE', dq.SQL[FRangeLine - 1]) <> 0) then wl := 'and '
        else wl := 'where ';
        s := MFFilter.GetFilterExpr(Self);
        if s <> '' then s := wl + s;
        // проверяем, было ли изменение
        if dq.SQL[FRangeLine] <> s then
        begin
          cd.Close;
          dq.SQL[FRangeLine] := s;
        end;
      end
      else
      begin
        if dq.SQL[FRangeLine] <> '' then dq.SQL[FRangeLine] := '';
        cd.Filtered := true;
      end;
    finally
      cd.EnableControls;
    end;
  end
  else // Отключение фильтрации
    dq.SQL[FRangeLine] := '';

  if MakeActive then
  begin
    //Open;
    ReloadLocate(k);
  end;
  // SE version - дополнительная отфильтровка заказчиков (см. описание Whatsnew 1.54SE)
  {if SecretFilter and (SecretNames <> nil) and (dq = aqCalcOrder) then begin
    sSQL := dq.SQL[FRangeLine];
    if sSQL <> '' then sSQL := sSQL + ' and (' else sSQL := 'where (';
    for i := 0 to Pred(SecretNames.Count) do begin
      sSQL := sSQL + 'Customer.Name = ''' + SecretNames.Strings[i] + '''';
      if i < Pred(SecretNames.Count) then sSQL := sSQL + ' or ';
    end;
    dq.SQL[FRangeLine] := sSQL + ')';
  end;}
  // end SE
end;*)

procedure TOrder.OpenProcessItems(PreviewMode: boolean);
begin
  // хотел сделать отложенное создание Tsm, но пока не получилось
  if not PreviewMode and (FProcesses = nil) then
    CreateProcessData;
  FOrderItems.OpenProcessItems(NvlInteger(KeyValue), PreviewMode);
end;

// Возвращает true если заказ был успешно удален
function TOrder.DeleteOrder(StartTran, FinishTran: boolean): boolean;
var
  i: integer;
  LockerName: string;
  LockerInfo: TUserInfo;
begin
  Result := false;
  // Проверяем наличие блокировки
  {dm.aspIsOrderRowLocked.Parameters.ParamByName('@N').Value := KeyValue;
  dm.aspIsOrderRowLocked.Parameters.ParamByName('@Lock').Value := 0;
  dm.aspIsOrderRowLocked.ExecProc;
  if dm.aspIsOrderRowLocked.Parameters[0].Value > 0 then}
  if TLockManager.IsLockedByAnotherUser(LockerName, TLockManager.Order, KeyValue) then
  begin
    LockerInfo := AccessManager.UserInfo(LockerName);
    if LockerInfo <> nil then
      LockerName := LockerInfo.Name;
    RusMessageDlg(NameSingular + ' ' + DataSet[F_OrderNumberText] + ' редактируется пользователем ' + QuotedStr(LockerName), mtInformation, [mbok], 0);
    Result := true;
    exit;
  end;

  if StartTran then
    if not Database.InTransaction then Database.BeginTrans;

  try
    dm.aspDelOrder.Parameters.ParamByName('@ID').Value := DataSet.FieldByName(F_OrderKey).AsInteger;
    dm.aspDelOrder.Parameters.ParamByName('@Lock').Value := 1;    // блокировка
    dm.aspDelOrder.ExecProc;
    //    i := dm.aspDelOrder.ParamByName('@OK').AsInteger;
    i := dm.aspDelOrder.Parameters[0].Value;
    if i = 0 then begin
      if FinishTran then Database.CommitTrans
    end else begin
      Database.RollbackTrans;
      dm.ShowProcErrorMessage(i);
      RusMessageDlg(NameSingular + ' не удален', mtError, [mbOK], 0);
      Exit;
    end;
    Result := true;
  except
    on E: EDatabaseError do begin
      Database.RollbackTrans;
      ExceptionHandler.Raise_(E);
    end;
  end;
end;

procedure TOrder.DoOnNewRecord;
var
  Present: TDateTime;
begin
  inherited;
  Present := Now;
  DataSet['Tirazz'] := 0;
  DataSet['ID_date'] := GetIDDate(Present);
  DataSet['RowColor'] := Ord(clWhite);
  DataSet[F_Comment] := '';
  DataSet[F_CostProtected] := false;
  DataSet[F_ContentProtected] := false;
  DataSet[F_KindID] := AccessManager.CurUser.DefaultKindID;
  DataSet['PrePayPercent'] := 0;
  DataSet['PreShipPercent'] := 100;
  DataSet['PayDelay'] := 0;
  DataSet['IsPayDelayInBankDays'] := false;
  DataSet['CallCustomer'] := false;
  DataSet['HaveLayout'] := false;
  DataSet['HavePattern'] := false;
  DataSet['SignManager'] := false;
  DataSet['SignProof'] := false;
  DataSet['IncludeCover'] := false;
  DataSet['IsComposite'] := false;
  DataSet['HaveProof'] := false;
end;

procedure TOrder.DoAfterScroll;
begin
  FAttachedFiles.Close;
  FNotes.Close;
  inherited;
end;

// Lookup поле вида заказа создается в рантайме перед открытием
procedure TOrder.DoBeforeOpen;
var f: TField;
begin
  inherited DoBeforeOpen;

  QueryObject := GetSQL;
  ADODataSet.SQL.Text := QueryObject.GetSQL;

  if DataSet.FindField(F_KindName) = nil then
  begin
    f := CreateLookupField(DataSet, FDM, F_KindName, TStringField, 40,
      sdm.cdOrderKind, F_KindID, F_KindID, 'KindDesc');
    f.Origin := 'wo.' + F_KindID;
    f.LookupCache := true;
  end;

  FAttachedFiles.Close;
  FNotes.Close;
end;

procedure TOrder.ProtectCost;
begin
  // Проверяем были ли изменения в базе
  CheckActualState;
  DataSet.Edit;
  DataSet[F_CostProtected] := true;
  ApplyUpdates;
end;

procedure TOrder.ProtectContent;
begin
  // Проверяем были ли изменения в базе
  CheckActualState;
  DataSet.Edit;
  DataSet[F_ContentProtected] := true;
  ApplyUpdates;
end;

procedure TOrder.UnprotectCost;
begin
  // Проверяем были ли изменения в базе
  CheckActualState;
  DataSet.Edit;
  DataSet[F_CostProtected] := false;
  ApplyUpdates;
end;

procedure TOrder.UnprotectContent;
begin
  // Проверяем были ли изменения в базе
  CheckActualState;
  DataSet.Edit;
  DataSet[F_ContentProtected] := false;
  ApplyUpdates;
end;

function TOrder.Modified: boolean;
begin
  Result := inherited Modified or FOrderItems.ProcessItemsModified;
end;

class function TOrder.IsLockedByAnother(var UserName: string; OrderID: integer): boolean;
begin
  try
    {dm.aspIsOrderRowLocked.Parameters.ParamByName('@N').Value := OrderID;
    dm.aspIsOrderRowLocked.Parameters.ParamByName('@Lock').Value := 0;
    dm.aspIsOrderRowLocked.Parameters.ParamByName('@LockInterval').Value := EntSettings.EditLockTimeoutInterval;
    dm.aspIsOrderRowLocked.ExecProc;
    Result := dm.aspIsOrderRowLocked.Parameters[0].Value > 0;}
    Result := TLockManager.IsLockedByAnotherUser(UserName, TLockManager.Order, OrderID);
    //if Result then
      //UserName := NvlString(dm.aspIsOrderRowLocked.Parameters.ParamByName('@UserName').Value);
  except
    // При переполнении считаем, что блокировки нет.
    // Вообще-то могут быть и другие проблемы, но можно их игнорировать 
    Result := false;
  end;
end;

class function TOrder.LockForEdit(OrderID: integer): boolean;
begin
  //dm.aspSetOrderLock.Parameters.ParamByName('@N').Value := OrderID;
  {if not Database.InTransaction then Database.BeginTrans;
  try
    Database.ExecuteNonQuery('declare @OK int; exec up_SetOrderLock ' + IntToStr(OrderID) + ', @OK');
    //dm.aspSetOrderLock.ExecProc;
    Database.CommitTrans;
  except on E: Exception do
    begin
      Database.RollbackTrans;
      //UnLock;
      ExceptionHandler.Raise_(E);
    end;
  end;}
  Result := TLockManager.Lock(TLockManager.Order, OrderID);
end;

// APPSERVER!!!!!!!!!!!!
class procedure TOrder.UnLock(OrderID: integer);
begin
  {$IFNDEF NoNet}
  {if not Database.InTransaction then Database.BeginTrans;
  try
    //dm.aspDelOrderLock.ExecProc;
    Database.ExecuteNonQuery('exec up_DelOrderLock');
    Database.CommitTrans;
  except
    on E: Exception do begin
      Database.RollbackTrans;
      TLogger.getInstance.Error('Ошибка снятия блокировки заказа');
    end;
  end;}
  {$ENDIF}
  TLockManager.UnLock(TLockManager.Order, OrderID);
end;

// Проверяет, изменился ли заказ, если да то обновляет.
procedure TOrder.CheckActualState;
var
  aq: TADOQuery;
  k: Integer;
begin
  aq := TADOQuery.Create(dm);
  SavePagePosition := true;
  try
    aq.Connection := Database.Connection;
    TLogger.GetInstance.Info('CheckActualState: aq.Connection.Connected = ' + VarToStr(aq.Connection.Connected));
    TLogger.GetInstance.Info('CheckActualState: aq.Connection.ConnectionString = ' + VarToStr(aq.Connection.ConnectionString));
    aq.SQL.Add('select ModifyDate, IsDeleted from WorkOrder where ' + KeyField + ' = ' + VarToStr(KeyValue));
    OnCheckActualState(aq);
    Database.OpenDataSet(aq);
    if aq.IsEmpty then
      raise Exception.Create(NameSingular + ' не найден. Вероятно, он был удален.')
    else if aq['IsDeleted'] then
      raise Exception.Create(NameSingular + ' находится в корзине.')
    else if aq['ModifyDate'] <> DataSet['ModifyDate'] then
    begin
      k := KeyValue;
      Reload;
      if KeyValue <> k then
        raise Exception.Create(NameSingular + ' не найден.'
          + #13'Возможно, он не попадает в текущую выбору или был перемещен в корзину.')
    end;
  finally
    aq.Free;
    SavePagePosition := false;
  end;
end;

procedure TOrder.OnCheckActualState(CheckQuery: TADOQuery);
begin
end;

{$REGION 'GET-SET Field Methods'}

function TOrder.ClientTotal: extended;
begin
  Result := NvlFloat(DataSet['ClientTotal']);
end;

function TOrder.CostOf1: extended;
begin
  Result := NvlFloat(DataSet['CostOf1']);
end;

function TOrder.FinalCostGrn: extended;
begin
  if VarIsNull(DataSet[F_FinalCostGrn]) then
    Result := NvlFloat(DataSet['ClientTotal']) * USDCourse
  else
    Result := NvlFloat(DataSet[F_FinalCostGrn]);
end;

function TOrder.GetTotalExpenseCost: Currency;
begin
  Result := NvlCurrency(DataSet[F_TotalExpenseCost]);
end;

procedure TOrder.SetTotalExpenseCost(Value: Currency);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_TotalExpenseCost] := Value;
end;

function TOrder.GetCostProtected: boolean;
begin
  Result := NvlBoolean(DataSet['CostProtected']);
end;

function TOrder.GetContentProtected: boolean;
begin
  Result := NvlBoolean(DataSet['ContentProtected']);
end;

function TOrder.GetOrderNumber: variant;
begin
  Result := DataSet[NumberField];
end;

function TOrder.GetKindID: integer;
begin
  Result := NvlInteger(DataSet[F_KindID]);
end;

function TOrder.GetRowColor: integer;
begin
  Result := NvlInteger(DataSet['RowColor']);
end;

function TOrder.GetCreationDate: variant;
begin
  Result := DataSet['CreationDate'];
end;

function TOrder.GetModifyDate: variant;
begin
  Result := DataSet['ModifyDate'];
end;

function TOrder.GetComment: string;
begin
  Result := NvlString(DataSet['Comment']);
end;

function TOrder.GetComment2: variant;
begin
  Result := DataSet['Comment2'];
end;

procedure TOrder.SetComment2(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['Comment2'] := Value;
end;

function TOrder.GetCustomerID: integer;
begin
  Result := NvlInteger(DataSet['Customer']);
end;

function TOrder.GetCustomerName: string;
begin
  Result := NvlString(DataSet['CustomerName']);
end;

function TOrder.GetTirazz: integer;
begin
  Result := NvlInteger(DataSet['Tirazz']);
end;

function TOrder.GetCustomerInfo: TContragentInfo;
begin
  if Customers.Locate(CustomerID) then
    Result := Customers.GetInfo
  else
    raise Exception.Create('Не найден заказчик для заказа');
end;

function TOrder.GetPrePayPercent: extended;
begin
  Result := NvlFloat(DataSet['PrePayPercent']);
end;

procedure TOrder.SetPrePayPercent(Value: extended);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['PrePayPercent'] := Value;
end;

function TOrder.GetPreShipPercent: extended;
begin
  Result := NvlFloat(DataSet['PreShipPercent']);
end;

procedure TOrder.SetPreShipPercent(Value: extended);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['PreShipPercent'] := Value;
end;

function TOrder.GetPayDelay: integer;
begin
  Result := NvlInteger(DataSet['PayDelay']);
end;

procedure TOrder.SetPayDelay(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['PayDelay'] := Value;
end;

function TOrder.GetIsPayDelayInBankDays: boolean;
begin
  Result := NvlBoolean(DataSet['IsPayDelayInBankDays']);
end;

procedure TOrder.SetIsPayDelayInBankDays(Value: boolean);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['IsPayDelayInBankDays'] := Value;
end;

procedure TOrder.SetIsComposite(Value: boolean);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['IsComposite'] := Value;
end;

function TOrder.GetIsLockedByUser: boolean;
begin
  Result := NvlBoolean(DataSet[F_IsLockedByUser]);
end;

{procedure TOrder.SetIsLockedByUser(Value: boolean);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_IsLockedByUser] := Value;
end;}

function TOrder.GetCallCustomer: boolean;
begin
  Result := NvlBoolean(DataSet['CallCustomer']);
end;

function TOrder.GetCallCustomerPhone: string;
begin
  Result := NvlString(DataSet['CallCustomerPhone']);
end;

function TOrder.GetHaveLayout: boolean;
begin
  Result := NvlBoolean(DataSet['HaveLayout']);
end;

function TOrder.GetHavePattern: boolean;
begin
  Result := NvlBoolean(DataSet['HavePattern']);
end;

function TOrder.GetSignManager: boolean;
begin
  Result := NvlBoolean(DataSet['SignManager']);
end;

function TOrder.GetSignProof: boolean;
begin
  Result := NvlBoolean(DataSet['SignProof']);
end;

function TOrder.GetHaveProof: boolean;
begin
  Result := NvlBoolean(DataSet['HaveProof']);
end;

function TOrder.GetProductFormat: string;
begin
  Result := NvlString(DataSet['ProductFormat']);
end;

function TOrder.GetProductPages: integer;
begin
  Result := NvlInteger(DataSet['ProductPages']);
end;

function TOrder.GetIncludeCover: boolean;
begin
  Result := NvlBoolean(DataSet['IncludeCover']);
end;

function TOrder.GetIsComposite: boolean;
begin
  Result := NvlBoolean(DataSet['IsComposite']);
end;

function TOrder.GetHasNotes: boolean;
begin
  Result := NvlBoolean(DataSet['HasNotes']);
end;

function TOrder.GetCreatorName: string;
begin
  Result := NvlString(DataSet[F_CreatorName]);
end;

{$ENDREGION}

procedure TOrder.ProviderBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
  var Applied: Boolean);
var
  RetCode: integer;
begin
  inherited;
  Applied := false;
  if UpdateKind = ukModify then
  begin
    dm.aspUpdateOrder.Parameters.ParamByName('@ID').Value := DeltaDS.FieldByName(KeyField).OldValue;

    DoSetSaveProcParams(dm.aspUpdateOrder, false, DeltaDS);

    if DeltaDS.FindField(F_OrderState) <> nil then
      dm.aspUpdateOrder.Parameters.ParamByName('@OldOrderState').Value := DeltaDS.FieldByName(F_OrderState).OldValue;
    if DeltaDS.FindField(F_PayState) <> nil then
      dm.aspUpdateOrder.Parameters.ParamByName('@OldPayState').Value := DeltaDS.FieldByName(F_PayState).OldValue;
    dm.aspUpdateOrder.Parameters.ParamByName('@OldRowColor').Value := DeltaDS.FieldByName('RowColor').OldValue;
    dm.aspUpdateOrder.Parameters.ParamByName('@OldComment').Value := DeltaDS.FieldByName('Comment').OldValue;
    dm.aspUpdateOrder.Parameters.ParamByName('@OldComment2').Value := DeltaDS.FieldByName('Comment2').OldValue;
    dm.aspUpdateOrder.Parameters.ParamByName('@OldCustomer').Value := DeltaDS.FieldByName('Customer').OldValue;

    // TODO: вобщето только в режиме редактирования контента должно быть true,
    // но уже можно не обращать внимания, т.к. это устаревшее поле
    dm.aspUpdateOrder.Parameters.ParamByName('@IsProcessCostStored').Value := true;
    //dm.aspUpdateOrder.Parameters.ParamByName('@ModifierName').value := Usr;

    dm.aspUpdateOrder.ExecProc; // обновление параметров заказа

    RetCode := dm.aspUpdateOrder.Parameters[0].Value;
    if RetCode < 0 then
      raise Exception.Create(dm.GetProcErrorMessage(RetCode));

    // Изменение владельца заказчика
    //if DeltaDS.FieldByName('CreatorName').NewValue <> DeltaDS.FieldByName('CreatorName').OldValue then
    if not VarIsEmpty(DeltaDS.FieldByName(F_CreatorName).NewValue) then
    begin
      dm.aspSetOrderOwner.Parameters.ParamByName('@OwnerName').Value := DeltaDS.FieldByName(F_CreatorName).NewValue;
      dm.aspSetOrderOwner.Parameters.ParamByName('@OrderID').Value := DeltaDS.FieldByName(KeyField).OldValue;
      dm.aspSetOrderOwner.ExecProc;
    end;
    Applied := true;
  end
  else if UpdateKind = ukInsert then
  begin
    DoSetSaveProcParams(dm.aspNewOrder, true, DeltaDS);

    dm.aspNewOrder.ExecProc;       { Вставка в таблицу и получаем значение ключа }

    FNewOrderKey := dm.aspNewOrder.Parameters.ParamByName('@ID').Value;

    if FNewOrderKey > 0 then
      Applied := true
    else
      raise Exception.Create(dm.GetProcErrorMessage(FNewOrderKey));
  end
    //raise Exception.Create('Ненормальное поведение программы: попытка добавления заказа')
  else if UpdateKind = ukDelete then
    raise Exception.Create('Ненормальное поведение программы: попытка удаления заказа');
    //Applied := true;
end;

procedure TOrder.DoSetSaveProcParams(sp: TADOStoredProc; NewOrder: boolean; DeltaDS: TDataSet);
begin
  AssignProcParam(sp, DeltaDS, 'Tirazz');
  AssignProcParam(sp, DeltaDS, 'Comment');
  AssignProcParam(sp, DeltaDS, 'Comment2');
  AssignProcParam(sp, DeltaDS, 'ID_date');
  AssignProcParam(sp, DeltaDS, 'ID_kind');
  AssignProcParam(sp, DeltaDS, 'ID_char');
  AssignProcParam(sp, DeltaDS, 'ID_color');
  AssignProcParam(sp, DeltaDS, 'TotalCost');
  AssignProcParam(sp, DeltaDS, 'ClientTotal');
  //sp.Parameters.ParamByName('@TotalCost').Value := sm.GrandTotal;
  //sp.Parameters.ParamByName('@ClientTotal').Value := sm.ClientTotal;
  //if NewOrder then
    AssignProcParam(sp, DeltaDS, F_KindID);
  AssignProcParam(sp, DeltaDS, 'Customer');
  AssignProcParam(sp, DeltaDS, 'RowColor');
  AssignProcParam(sp, DeltaDS, F_CostProtected);
  AssignProcParam(sp, DeltaDS, F_ContentProtected);
  AssignProcParam(sp, DeltaDS, 'PrePayPercent');
  AssignProcParam(sp, DeltaDS, 'PreShipPercent');
  AssignProcParam(sp, DeltaDS, 'PayDelay');
  AssignProcParam(sp, DeltaDS, 'IsPayDelayInBankDays');
  AssignProcParam(sp, DeltaDS, 'CallCustomer');
  AssignProcParam(sp, DeltaDS, 'CallCustomerPhone');
  AssignProcParam(sp, DeltaDS, 'HaveLayout');
  AssignProcParam(sp, DeltaDS, 'HavePattern');
  AssignProcParam(sp, DeltaDS, 'ProductFormat');
  AssignProcParam(sp, DeltaDS, 'ProductPages');
  AssignProcParam(sp, DeltaDS, 'SignManager');
  AssignProcParam(sp, DeltaDS, 'SignProof');
  AssignProcParam(sp, DeltaDS, 'IncludeCover');
  AssignProcParam(sp, DeltaDS, 'IsComposite');
  AssignProcParam(sp, DeltaDS, 'HaveProof');
end;

procedure TOrder.SetSortOrder(_SortField: string; MakeActive: boolean);
begin
  // 11.03.2007, 20.05.2008 Защита от некорректных значения выражения сортировки,
  // которые могли остаться после предыдущей версии.
  if (CompareText(_SortField, 'YEAR(CreationDate), ID_Number') = 0)
      or (Pos(', ID_Number', _SortField) <> 0) then
    _SortField := F_OrderNumberText
  else if Pos('ID_Year', _SortField) > 0 then
    _SortField := F_OrderNumberText
  else if Pos('CustomerName', _SortField) > 0 then
    _SortField := 'wc.Name, ' + GetOrderPrefix + 'CreationDate, ' + GetOrderPrefix + 'ID_Number';

  FSortField := _SortField;

  if MakeActive then Reload;
end;

function TOrder.GetSortExpr: string;
begin
  // Сортировка по шифру, но без типа заказа = YMM-NUMBER, а не YMM-XXX-NUMBER
  if (CompareText(FSortField, F_OrderNumberText) = 0) then
  begin
    Result := 'YEAR(' + GetOrderPrefix + 'CreationDate), ' + GetOrderPrefix + 'ID_Number';
    if not Options.NewAtEnd then Result := Result + ' DESC';
  end else
    if not Options.NewAtEnd then Result := FSortField + ' DESC' else Result := FSortField;
end;

function TOrder.GetOrderPrefix: string;
begin
  Result := 'wo.';
end;

procedure TOrder.ChangeCreationDate(dt: TDateTime);
begin
  Database.ExecuteNonQuery('update WorkOrder set CreationDate = ' + FormatSQLDateTime(dt)
    + ' where ' + F_OrderKey + ' = ' + IntToStr(KeyValue));
end;

procedure TOrder.ChangeNumber(Num: integer);
begin
  Database.ExecuteNonQuery('update WorkOrder set ID_Number = ' + IntToStr(Num)
    + ' where ' + F_OrderKey + ' = ' + IntToStr(KeyValue));
end;

procedure TOrder.IDDateValidate(Sender: TField);
begin
  if not (Sender.AsInteger mod 100) in [1..12] then
    raise Exception.Create('Значение месяца должно быть в пределах от 1 до 12');
end;

procedure TOrder.OrderUserNameGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if (AccessManager.Users <> nil) and not Sender.IsNull then
  begin
    Text := AccessManager.FormatUserName(NvlString(Sender.Value));
  end;
end;

function TOrder.GetReportFieldsExpr: string;
begin
  if FRetrieveAllReportFields or EntSettings.ShowExpenseCost then
    Result := '((select ISNULL(sum(ISNULL(mat.FactMatCost, 0)), 0)'#13#10
    + ' + ISNULL(sum(case when mat.FactMatCost is null then mat.MatCost * ' + GetCourseExpr + ' else 0 end), 0)'#13#10
    + ' from OrderProcessItem opi inner join OrderProcessItemMaterial mat on mat.ItemID = opi.ItemID'#13#10
    + ' inner join WorkOrder wo1 on wo1.N = opi.OrderID'#13#10
    + ' where opi.OrderID = wo.N and opi.Enabled = 1 and mat.RequestModified = 0)'#13#10
    + ' + (select ISNULL(sum(ISNULL(FactContractorCost, 0)), 0)'#13#10
    + ' + ISNULL(sum(case when FactContractorCost is null then ContractorCost * ' + GetCourseExpr + ' else 0 end), 0)'#13#10
    + ' from OrderProcessItem opi inner join WorkOrder wo1 on wo1.N = opi.OrderID'#13#10
    + ' where opi.OrderID = wo.N and opi.Enabled = 1 and opi.ContractorProcess = 1)) as ' + F_TotalExpenseCost
//      + '() as TotalOrderProfitCost';
  else
    Result := 'cast(0 as decimal(18, 2)) as ' + F_TotalExpenseCost;
end;

procedure TOrder.CostFieldGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull or not NvlBoolean(DataSet['CostView'])  then
    Text := ''
  else
    Text := FormatFloat((Sender as TNumericField).DisplayFormat, Sender.AsFloat);
end;

function TOrder.GetHasNotesExpr: string;
begin
  Result := 'cast((case when exists(select * from OrderNotes where OrderID = wo.N) then 1 else 0 end) as bit) as HasNotes';
end;

function TOrder.GetIsLockedByUserExpr: string;
begin
  Result := TLockManager.GetSelectLockExpr(TLockManager.Order, 'wo.N') + ' as IsLockedByUser';
end;

procedure TOrder.GetEmptyText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := '';
end;

function TOrder.GetFiles: TOrderAttachedFiles;
begin
  if not FAttachedFiles.Active then
    OpenAttachedFiles;
  Result := FAttachedFiles;
end;

procedure TOrder.OpenAttachedFiles;
var
  id: integer;
  cr: TOrderAttachedFilesCriteria;
begin
  if (DataSet.RecordCount > 0) then
    id := NvlInteger(KeyValue)
  else
    id := 0;
  cr.OrderID := id;
  cr.Mode := TOrderAttachedFilesCriteria.Mode_Normal;
  FAttachedFiles.Criteria := cr;
  FAttachedFiles.Reload;
end;

function TOrder.GetNotes: TOrderNotes;
begin
  if not FNotes.Active then
    OpenNotes;
  Result := FNotes;
end;

procedure TOrder.OpenNotes;
var
  id: integer;
  cr: TOrderNotesCriteria;
begin
  if (DataSet.RecordCount > 0) then
    id := NvlInteger(KeyValue)
  else
    id := 0;
  cr.OrderID := id;
  cr.Mode := TOrderNotesCriteria.Mode_Normal;
  FNotes.Criteria := cr;
  FNotes.Reload;
end;

procedure TOrder.FetchAllReportData;
begin
  RetrieveAllReportFields := true;
  try
    if UsePager then
      FetchAllRecords // загружаем все данные в режиме постраничной выборки
    else   // проверяем есть ли поля, которые грузятся не всегда
      Reload;
  finally
    RetrieveAllReportFields := false;
  end;
end;

// поместить событие в историю заказа
procedure TOrder.WriteEvent(EventText: string; EventType: integer);
begin
  Database.ExecuteNonQuery('exec up_HistoryAdd ' + IntToStr(EventType) + ', '
    + QuotedStr(EventText) + ', ' + IntToStr(KeyValue));
end;

{$ENDREGION}

{$REGION 'TDraftOrder - Расчет-черновик'}

constructor TDraftOrder.Create(_ADODataSet: TADOQuery = nil);
begin
  inherited Create('Calc', 'Расчет', 'Расчеты', F_OrderKey, _ADODataSet);
  FillDateFields(FDateFields, GetOrderPrefix);
end;

class procedure TDraftOrder.FillDateFields(var _DateFields: TDateArray; OrderPrefix: string);
begin
  SetLength(_DateFields, 9);
  _DateFields[0] := OrderPrefix + 'CreationDate';
  _DateFields[1] := OrderPrefix + 'ModifyDate';
  _DateFields[2] := OrderPrefix + 'CreationDate';
  _DateFields[3] := OrderPrefix + 'CreationDate';
  _DateFields[4] := OrderPrefix + 'CreationDate';
  _DateFields[5] := OrderPrefix + 'CreationDate';
  _DateFields[6] := OrderPrefix + 'CloseDate';
  _DateFields[7] := OrderPrefix + 'CloseDate';
  _DateFields[8] := OrderPrefix + 'CloseDate';
end;

procedure TDraftOrder.CreateDataSet(DataOwner: TComponent);
var
  f: TField;
begin
  inherited CreateDataSet(DataOwner);

  f := DataSet.FieldByName('TotalGrn');
  f.FieldKind := fkCalculated;
  f.Calculated := True;
end;

function TDraftOrder.GetUSDCourse: extended;
begin
  Result := FProcesses.USDCourse;
end;

procedure TDraftOrder.SetUSDCourse(Value: extended);
begin
  FProcesses.USDCourse := Value;
end;

function TDraftOrder.GetDeletePermOwn: string;
begin
  Result := 'DraftDeleteOwn';
end;

function TDraftOrder.GetDeletePermOther: string;
begin
  Result := 'DraftDeleteOther';
end;

procedure TDraftOrder.ReadKindPermissions(NewEntity: boolean);
begin
  if not DataSet.IsEmpty then
  begin
    // для нового или если создатель не указан (для старых заказов)
    if NewEntity or VarIsNull(DataSet[F_CreatorName]) then
      AccessManager.ReadCurKindPerm(true, KindID, AccessManager.CurUser.ID)
    else
      AccessManager.ReadCurKindPerm(true, KindID, AccessManager.GetUserID(DataSet[F_CreatorName]));
  end;
end;

procedure TDraftOrder.OnCheckActualState(CheckQuery: TADOQuery);
begin
  CheckQuery.SQL.Add('and IsDraft = 1');
end;

procedure TDraftOrder.DoSetSaveProcParams(sp: TADOStoredProc; NewOrder: boolean;
  DeltaDS: TDataSet);
begin
  inherited;
  sp.Parameters.ParamByName('@OrderState').Value := 0;
  sp.Parameters.ParamByName('@IncludeAdv').Value := false;
  //sp.Parameters.ParamByName('@CourseNBU').Value := null;
  sp.Parameters.ParamByName('@PayState').Value := 0;
  if NewOrder then
  begin
    sp.Parameters.ParamByName('@IsDraft').Value := true;
    // ОПЦИЯ РЕЖИМА ВОССТАНОВЛЕНИЯ НЕ РЕАЛИЗОВАНА НАЧИНАЯ С 2.3.7
    // это для режима восстановления:
    // В этом режиме необходимо указывать номер и дату создания при вводе нового заказа
    if Options.EmergencyMode then begin
      AssignProcParam(sp, DeltaDS, '@' + F_OrderNumber);
      AssignProcParam(sp, DeltaDS, 'CreationDate');
    end;
  end;
end;

function TDraftOrder.GetSQL: TQueryObject;
var
  expr: string;
begin
  Result.Select := 'wo.N, wo.ID_date, wo.ID_kind, wo.ID_char, wo.ID_color, wo.ID_Date / 100 as ID_Year, '#13#10
    + GetOrderIDSQL + #13#10
    + 'wo.ID_number, wo.Tirazz, wo.TotalCost, wo.IsComposite,'#13#10
    + 'case when wo.Tirazz is not null and wo.Tirazz <> 0 then ROUND(wo.TotalCost / wo.Tirazz, 2) else 0 end as CostOf1, '#13#10
  // TODO: Здесь можно проверить настройку ShowNativeGrn
  //if SortField <> 'FinalCostGrn' then
  //  Result.Select := Result.Select
  //    + '(select top 1 FinalCostGrn from Service_ClientPrice scp inner join OrderProcessItem opi on opi.ItemID = scp.ItemID where opi.OrderID = wo.N) as FinalCostGrn, ' + #13#10
  //else
  //  Result.Select := Result.Select + 'scp.FinalCostGrn,' + #13#10;
    //+ '(case when scp.FinalCostGrn is not null and scp.ProfitByGrn = 1 then scp.FinalCostGrn else wo.ClientTotal * ' + VarToStr(USDCourse) + ' end) as FinalCostGrn,'
    + 'scp.FinalCostGrn, scp.ProfitByGrn as ProfitByGrn, scp.ProfitPercent,'#13#10
    + 'ak.DraftCostView as CostView,'#13#10
    + 'wo.CreationDate, wo.CreationDate as CreationTime,'#13#10
    + 'wo.ModifyDate, wo.ModifyDate as ModifyTime,'#13#10
    + 'wo.CloseDate, wo.CloseDate as CloseTime,'#13#10
    + 'wo.Comment, wo.Comment2, wo.PrePayPercent, wo.PreShipPercent, wo.PayDelay, wo.IsPayDelayInBankDays,'#13#10
    + 'wo.Customer, wo.CreatorName, wo.ModifierName, wo.RowColor,'#13#10
    + 'wo.ClientTotal, wo.KindID, wo.IsProcessCostStored, wo.CostProtected, wo.ContentProtected,'#13#10
    + 'wo.CallCustomer, wo.CallCustomerPhone, wo.HaveLayout, wo.HavePattern, wo.ProductFormat,'#13#10
    + 'wo.ProductPages, wo.IncludeCover, wo.SignManager, wo.SignProof, wo.HaveProof,'#13#10
    + 'case when wc.Name <> ''NONAME'' then wc.Name else '''' end as CustomerName,'#13#10
    + 'wc.Fax as CustomerFax, wc.Phone as CustomerPhone,'#13#10
    + GetReportFieldsExpr + ','#13#10
    + GetHasNotesExpr + ','#13#10
    + GetIsLockedByUserExpr + #13#10;
  
  Result.From := 'LEFT JOIN Customer as wc ON wo.Customer = wc.N'#13#10
  //if SortField = 'FinalCostGrn' then
  //   Result.From := Result.From +
     + 'LEFT JOIN Service_ClientPrice scp inner join OrderProcessItem opi on opi.ItemID = scp.ItemID on opi.OrderID = wo.N'#13#10
     + 'LEFT JOIN AccessKind ak on wo.KindID = ak.KindID and ak.UserID = ' + IntToStr(AccessManager.CurUser.ID);
  Result.Where := 'wo.IsDraft = 1 and wo.IsDeleted = 0';
  expr := FCriteria.GetFilterExpr(Self);
  if expr <> '' then
    Result.Where := Result.Where + ' and (' + expr + ')';
  Result.Sort := GetSortExpr;
  Result.TableName := 'WorkOrder';
  Result.TableAlias := 'wo';
  Result.KeyFieldName := F_OrderKey;
end;

procedure TDraftOrder.DoOnCalcFields;
var
  n: integer;
  tc: extended;
begin
  inherited;
  if DisableCalcFields then Exit;

  n := Tirazz;
  try Dataset['TotalGrn'] := RoundByMode(NvlFloat(Dataset['TotalCost']), USDCourse, n);
  except Dataset['TotalGrn'] := 0; end;
  // стоимость для клиента может быть уже зафиксирована
  if VarIsNull(DataSet[F_FinalCostGrn]) or not NvlBoolean(DataSet['ProfitByGrn']) then
  begin
    try tc := RoundByMode(NvlFloat(Dataset['ClientTotal']), USDCourse, n);
    except tc := 0; end;
  end
  else
    tc := DataSet[F_FinalCostGrn];
  DataSet['ClientTotalGrn'] := tc;
  if n > 0 then
    DataSet['CostOf1Grn'] := Round2(tc / n)//NvlFloat(Dataset['CostOf1']) * sm.USDCourse;
  else
    DataSet['CostOf1Grn'] := 0;
end;

function TDraftOrder.GetCourseExpr: string;
var
  OldDS: char;
begin
  OldDS := DecimalSeparator;
  try
    DecimalSeparator := '.';
    Result := FloatToStr(FProcesses.USDCourse);
  finally
    DecimalSeparator := OldDS;
  end;
end;

{$ENDREGION}

{$REGION 'TWorkOrder - Расчет-заказ'}

procedure TWorkOrder.CreateDataSet(DataOwner: TComponent);
var
  f: TField;
begin
  inherited CreateDataSet(DataOwner);

  f := TBCDField.Create(DataOwner);
  f.FieldName := F_Course;
  f.ProviderFlags := [pfInUpdate];
  (f as TBCDField).Currency := True;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  {f := TBCDField.Create(DataOwner);
  f.FieldName := 'CourseNBU';
  f.ProviderFlags := [pfInUpdate];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).EditFormat := NumEditFmt;
  (f as TBCDField).currency := True;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;}

  f := TBooleanField.Create(DataOwner);
  f.FieldName := 'IncludeAdv';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataOwner);
  f.FieldName := 'SourceCalcID';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;

  f := TDateTimeField.Create(DataOwner);
  f.FieldName := F_StartDate;
  (f as TDateTimeField).DisplayFormat := 'dd/mm/yyyy';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;

  f := TDateTimeField.Create(DataOwner);
  f.FieldName := 'FinishDate';
  f.Origin := 'wo.FinishDate';
  f.ProviderFlags := [pfInUpdate];
  //(f as TDateTimeField).DisplayFormat := 'dd/mm/yyyy h:mm'; // для отчетов
  f.OnGetText := DoGetFinishDateText;
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataOwner);
  f.FieldName := F_OrderState;
  f.Origin := 'wo.OrderState, wo.CreationDate';
  f.ProviderFlags := [pfInUpdate];
  f.OnGetText := GetEmptyText;
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataOwner);
  f.FieldName := F_PayState;
  f.ProviderFlags := [pfInUpdate];
  f.OnGetText := GetEmptyText;
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataOwner);
  f.FieldName := F_ShipmentState;
  f.ProviderFlags := [];
  f.OnGetText := GetEmptyText;
  f.DataSet := DataSet;

  f := TDateTimeField.Create(DataOwner);
  f.FieldName := 'FactFinishDate';
  f.ProviderFlags := [];
  (f as TDateTimeField).DisplayFormat := 'dd/mm/yyyy h:mm';
  f.DataSet := DataSet;

  f := TDateTimeField.Create(DataOwner);
  f.FieldName := 'FactFinishTime';
  f.ProviderFlags := [];
  (f as TDateTimeField).DisplayFormat := 'h:mm';
  f.DataSet := DataSet;

  f := TDateTimeField.Create(DataOwner);
  f.FieldKind := fkCalculated;
  f.FieldName := 'PlanFinishTime';
  f.ProviderFlags := [];
  (f as TDateTimeField).DisplayFormat := 'h:mm';
  f.Calculated := True;
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataOwner);
  f.FieldName := 'AutoPayState';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;

  f := TDateTimeField.Create(DataOwner);
  f.FieldName := 'StateChangeDate';
  f.ProviderFlags := [];
  (f as TDateTimeField).DisplayFormat := 'dd/mm/yyyy h:mm';
  f.DataSet := DataSet;

  f := TBooleanField.Create(DataOwner);
  f.FieldName := 'HasInvoice';
  f.ProviderFlags := [];
  f.DataSet := DataSet;

  f := TBooleanField.Create(DataOwner);
  f.FieldName := 'ShipmentApproved';
  f.ProviderFlags := [];
  f.DataSet := DataSet;

  f := TBooleanField.Create(DataOwner);
  f.FieldName := 'OrderMaterialsApproved';
  f.ProviderFlags := [];
  f.DataSet := DataSet;

  f := TBooleanField.Create(DataOwner);
  f.FieldName := 'MatRequestModified';
  f.ProviderFlags := [];
  f.DataSet := DataSet;

  f := TBCDField.Create(DataOwner);
  f.FieldName := 'TotalInvoiceCost';
  f.ProviderFlags := [];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataOwner);
  f.FieldName := 'TotalPayCost';
  f.ProviderFlags := [];
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataOwner);
  f.FieldName := F_DebtCost;
  f.FieldKind := fkCalculated;
  f.ProviderFlags := [];
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataOwner);
  f.FieldName := F_AllDebtCost;
  f.FieldKind := fkCalculated;
  f.ProviderFlags := [];
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TStringField.Create(DataOwner);
  f.FieldName := F_ExternalId;
  f.ProviderFlags := [pfInUpdate];
  f.Size := ExternalIdSize;
  f.DataSet := DataSet;
end;

constructor TWorkOrder.Create(_ADODataSet: TADOQuery = nil);
begin
  inherited Create('Work', 'Заказ', 'Заказы', F_OrderKey, _ADODataSet);
  FillDateFields(FDateFields, GetOrderPrefix);
  DataSet.FieldByName('FinishDate').OnChange := FieldChanged;
  DataSet.FieldByName(F_OrderState).OnChange := FieldChanged;
  DataSet.FieldByName(F_PayState).OnChange := FieldChanged;
end;

class procedure TWorkOrder.FillDateFields(var _DateFields: TDateArray; OrderPrefix: string);
begin
  SetLength(_DateFields, 9);
  _DateFields[0] := OrderPrefix + 'CreationDate';
  _DateFields[1] := OrderPrefix + 'ModifyDate';
  _DateFields[2] := OrderPrefix + 'FinishDate';
  _DateFields[3] := OrderPrefix + 'FactFinishDate';
  _DateFields[4] := OrderPrefix + F_StartDate;
  _DateFields[5] := OrderPrefix + F_StartDate;
  _DateFields[6] := OrderPrefix + 'CloseDate';
  _DateFields[7] := '(select max(PayDate) from Payments pp inner join InvoiceItems ii'
    + ' on pp.InvoiceItemID = ii.InvoiceItemID where ii.OrderID = wo.N)';
  _DateFields[8] := 'ANY(select PayDate from Payments pp inner join InvoiceItems ii'
    + ' on pp.InvoiceItemID = ii.InvoiceItemID where ii.OrderID = wo.N)';
  //FDateFields[8] := '(select max(EventDate) from OrderHistory oh where oh.OrderID = wo.N'
  //  + ' and EventText like ''Состояние выполнения%'')';
end;

function TWorkOrder.FinishDateIndex: integer;
begin
  Result := 2;
end;

function TWorkOrder.GetDeletePermOwn: string;
begin
  Result := 'WorkDeleteOwn';
end;

function TWorkOrder.GetDeletePermOther: string;
begin
  Result := 'WorkDeleteOther';
end;

function TWorkOrder.GetUSDCourse: extended;
begin
  Result := NvlFloat(DataSet[F_Course]);
end;

procedure TWorkOrder.SetUSDCourse(Value: extended);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_Course] := Value;
end;

procedure TWorkOrder.ReadKindPermissions(NewEntity: boolean);
begin
  if not DataSet.IsEmpty then
  begin
    if NewEntity then
      AccessManager.ReadCurKindPerm(false, KindID, AccessManager.CurUser.ID)
    else
      AccessManager.ReadCurKindPerm(false, KindID, AccessManager.GetUserID(DataSet[F_CreatorName]));
  end;
end;

procedure TWorkOrder.DoOnNewRecord;
begin
  inherited;
  //try
    DataSet[F_OrderState] := 0;
    DataSet['IncludeAdv'] := false;
    //DataSet['CourseNBU'] := FProcesses.USDCourse;
    if NvlInteger(Options.DefOrderPayState) > 0 then
      DataSet[F_PayState] := Options.DefOrderPayState;
    if NvlInteger(Options.DefOrderExecState) > 0 then
      DataSet[F_OrderState] := Options.DefOrderExecState;
  //except end;
end;

// возвращает состояние неоплаты для вида оплаты "по умолчанию"
function TWorkOrder.GetDefaultNoPayState: integer;
var
  de: TDictionary;
begin
  de := TConfigManager.Instance.StandardDics.dePayKind;
  if de.LocateFilter('A1') then
    Result := de.CurrentValue[4]
  else
    ExceptionHandler.Raise_(Exception.Create('Не найден вид оплаты по умолчанию в справочнике "Вид оплаты"'));
end;

function TWorkOrder.GetTotalInvoiceCostExpr: string;
begin
  if (FRetrieveAllReportFields or EntSettings.ShowPartialInvoice) and AccessManager.CurUser.ViewInvoices then
    Result := 'COALESCE((select sum(ItemCost) from InvoiceItems where OrderID = wo.N), 0)'
  else
    Result := 'cast(0 as decimal(18, 2))';
end;

function TWorkOrder.GetTotalPayCostExpr: string;
begin
  if (EntSettings.PayStateMode <> AutoPayState_OldInvoices)
      and AccessManager.CurUser.ViewInvoices
      and AccessManager.CurUser.ViewPayments then
    Result := 'ISNULL((select sum(PayCost) from Payments pay '#13#10
          + ' inner join InvoiceItems ii on pay.InvoiceItemID = ii.InvoiceItemID'#13#10
          + ' where ii.OrderID = wo.N), 0)'
  else
    Result := 'cast(0 as decimal(18, 2))';
end;

function TWorkOrder.GetPayStateFunc: string;
var
  StateNone, StatePartial, StateFull: integer;
begin
  if not AccessManager.CurUser.ViewInvoices or not AccessManager.CurUser.ViewPayments then
  begin
    Result := '1';
    Exit;
  end;

  //if Options.NewInvoices then
  //begin
  // режим "по каждой позиции"
  if EntSettings.PayStateMode = AutoPayState_InvoicePosition then
  begin
    // в функцию GetPayState передаются коды состояний "не оплачено", "частично оплачено", "оплачено"
    // для каждого вида оплаты
    Result := 'ISNULL((select max(dbo.GetPayState(ISNULL(ip.ItemPayCost, 0), ISNULL(ii.ItemCost, 0), dc.A4, dc.A5, dc.A6))'#13#10
      + 'from InvoiceItems ii inner join Invoices inv on inv.InvoiceID = ii.InvoiceID'#13#10
      + ' left join Dic_Cash dc on inv.PayType = dc.Code'#13#10
      + ' left join InvoiceItemPayments ip on ii.InvoiceItemID = ip.InvoiceItemID'#13#10
      + 'where ii.OrderID = wo.N), ' + IntToStr(GetDefaultNoPayState) + ')'#13#10
  end
  else
  // режим "по сумме заказа"
  if EntSettings.PayStateMode = AutoPayState_OrderTotal then
  begin
    Result := 'dbo.GetPayState(' + GetTotalPayCostExpr + ','#13#10;
    TConfigManager.Instance.GetDefaultPayStates(StateNone, StatePartial, StateFull);
    // Если счет один, то легко определить коды состояний исходя из вида оплаты, иначе берем вид по умолчанию.
    Result := 'case when (select count(*) from InvoiceItems ii1 where ii1.OrderID = wo.N) <> 1 then'#13#10
      + Result + #13#10
      + ' COALESCE((select top 1 FinalCostGrn from Service_ClientPrice scp'
      + ' inner join OrderProcessItem opi on opi.ItemID = scp.ItemID where opi.OrderID = wo.N),'
      + ' wo.ClientTotal * wo.Course, 0), ' + IntToStr(StateNone) + ', ' + IntToStr(StatePartial) + ', ' + IntToStr(StateFull) + ')'#13#10
      + 'else'#13#10'dbo.GetPayState(' + GetTotalPayCostExpr + ','#13#10
      + ' COALESCE((select top 1 FinalCostGrn from Service_ClientPrice scp inner join OrderProcessItem opi on opi.ItemID = scp.ItemID where opi.OrderID = wo.N), wo.ClientTotal * wo.Course, 0),'#13#10
      + ' (select A4 from Dic_Cash where Code = (select top 1 PayType from InvoiceItems ii1 inner join Invoices inv1 on inv1.InvoiceID = ii1.InvoiceID where ii1.OrderID = wo.N)),'#13#10
      + ' (select A5 from Dic_Cash where Code = (select top 1 PayType from InvoiceItems ii1 inner join Invoices inv1 on inv1.InvoiceID = ii1.InvoiceID where ii1.OrderID = wo.N)),'#13#10
      + ' (select A6 from Dic_Cash where Code = (select top 1 PayType from InvoiceItems ii1 inner join Invoices inv1 on inv1.InvoiceID = ii1.InvoiceID where ii1.OrderID = wo.N))) end';
  end
  // режим "по сумме счетов" - не используется, запрещен в настройках
  {else if EntSettings.PayStateMode = AutoPayState_InvoiceTotal then
    Result := Result + ' ' + GetTotalInvoiceCostExpr}
  else if EntSettings.PayStateMode = AutoPayState_OldInvoices then
  begin
    TConfigManager.Instance.GetDefaultPayStates(StateNone, StatePartial, StateFull);
    Result :=
     'dbo.GetPayState((select ISNULL((select sum(ISNULL(PaidGrn, 0))'
     + '      + sum(ISNULL(PaidUSD, 0)) * wo.Course'#13#10
     + '  from Service_AccountPaid sp inner join OrderProcessItem opi on sp.ItemID = opi.ItemID'#13#10
     + '  where opi.OrderID = wo.N and opi.Enabled = 1), 0)),'#13#10
     + '  COALESCE(scp.FinalCostGrn, wo.ClientTotal * wo.Course, 0),  '#13#10
     + IntToStr(StateNone) + ', ' + IntToStr(StatePartial) + ', ' + IntToStr(StateFull) + ')';
     //+ '  COALESCE((select top 1 FinalCostGrn from Service_ClientPrice scp'
     //+ ' inner join OrderProcessItem opi on opi.ItemID = scp.ItemID where opi.OrderID = wo.N), wo.ClientTotal, 0))';
  end;
end;

function TWorkOrder.GetPayStateExpr(Values: string): string;
begin
  if EntSettings.AutoPayState then
    Result := '(PayState is null and ' + GetPayStateFunc + ' in (' + Values + ')'
          + ' or ' + GetOrderPrefix + 'PayState in (' + Values + '))'
  else
    Result := GetOrderPrefix + 'PayState in (' + Values + ')';
end;

function TWorkOrder.GetHasInvoiceExpr: string;
begin
  if AccessManager.CurUser.ViewInvoices then
  begin
    if EntSettings.PayStateMode = AutoPayState_OldInvoices then
      Result := 'cast((case when exists(select * from Service_AccountInfo sp'#13#10
        + ' inner join OrderProcessItem opi on opi.ItemID = sp.ItemID where opi.OrderID = wo.N) then 1 else 0 end) as bit) as HasInvoice'
    else
      Result := 'cast((case when exists(select * from InvoiceItems ii where ii.OrderID = wo.N) then 1 else 0 end) as bit) as HasInvoice'
  end
  else
    Result := 'cast(1 as bit) as HasInvoice';
end;

function TWorkOrder.GetOrderShipmentStateExpr: string;
begin
  if Options.ShowShipmentState then
    Result := GetShipmentStateExpr
  else
    Result := 'cast(0 as int) as ShipmentState';
end;

class function TWorkOrder.GetShipmentStateExpr: string;
begin
  if AccessManager.CurUser.ViewShipment then
    Result := 'dbo.GetShipmentState(wo.Tirazz, ISNULL((select ISNULL(sum(Quantity), 0) from Shipment sh'
      + ' where sh.OrderID = wo.N), 0)) as ShipmentState'
  else
    Result := 'cast(0 as int) as ShipmentState';
end;

function TWorkOrder.GetMatRequestModifiedExpr: string;
begin
  Result := 'cast((case when exists(select * from OrderProcessItemMaterial opim inner join OrderProcessItem opi on opim.ItemID = opi.ItemID' + #13#10
    + ' where opi.OrderID = wo.N and opi.Enabled = 1 and RequestModified = 1) then 1 else 0 end) as bit) as MatRequestModified';
end;

procedure TWorkOrder.OnCheckActualState(CheckQuery: TADOQuery);
begin
  CheckQuery.SQL.Add('and IsDraft = 0');
end;

procedure TWorkOrder.DoSetSaveProcParams(sp: TADOStoredProc; NewOrder: boolean;
  DeltaDS: TDataSet);
begin
  inherited;
  AssignProcParam(sp, DeltaDS, 'TotalGrn');
  //sp.Parameters.ParamByName('@TotalGrn').Value := sm.GrandTotalGrn;
  // Фиксируем курс
  AssignProcParam(sp, DeltaDS, F_Course);
  //sp.Parameters.ParamByName('@Course').Value := sm.USDCourse;
  AssignProcParam(sp, DeltaDS, F_OrderState);
  AssignProcParam(sp, DeltaDS, 'IncludeAdv');
  //AssignProcParam(sp, DeltaDS, 'CourseNBU');
  AssignProcParam(sp, DeltaDS, 'FinishDate');
  AssignProcParam(sp, DeltaDS, F_StartDate);
  AssignProcParam(sp, DeltaDS, F_PayState);
  if NewOrder then
  begin
    sp.Parameters.ParamByName('@IsDraft').Value := false;
    // ОПЦИЯ РЕЖИМА ВОССТАНОВЛЕНИЯ НЕ РЕАЛИЗОВАНА НАЧИНАЯ С 2.3.7
    // это для режима восстановления:
    // В этом режиме необходимо указывать номер и дату создания при вводе нового заказа
    if Options.EmergencyMode then
    begin
      AssignProcParam(sp, DeltaDS, F_OrderNumber);
      AssignProcParam(sp, DeltaDS, 'CreationDate');
    end;
  end;
  AssignProcParam(sp, DeltaDS, F_ExternalId);
end;

function TWorkOrder.GetSQL: TQueryObject;
var
  expr: string;
begin
  Result.Select := 'wo.N, wo.ID_date, wo.ID_kind, wo.ID_char, wo.ID_color, wo.ID_Date / 100 as ID_Year,'#13#10
    + GetOrderIDSQL + #13#10
    + 'wo.ID_number, wo.Tirazz, wo.TotalCost, wo.Course, wo.TotalGrn, wo.IncludeAdv,'#13#10
  {if SortField <> 'FinalCostGrn' then
    Result.Select := Result.Select
      + '(select top 1 FinalCostGrn from Service_ClientPrice scp inner join OrderProcessItem opi on opi.ItemID = scp.ItemID where opi.OrderID = wo.N) as FinalCostGrn, ' + #13#10
  else
    Result.Select := Result.Select + 'scp.FinalCostGrn,' + #13#10;}
    + 'scp.FinalCostGrn, scp.ProfitByGrn, scp.ProfitPercent,'#13#10
    + 'ak.WorkCostView as CostView,'#13#10
    + 'case when wo.Tirazz is not null and wo.Tirazz <> 0 then ROUND(wo.TotalCost / wo.Tirazz, 2) else 0 end as CostOf1,'#13#10
    + 'wo.CreationDate, wo.CreationDate as CreationTime,'#13#10
    + 'wo.ModifyDate, wo.ModifyDate as ModifyTime,'#13#10
    + 'wo.CloseDate, wo.CloseDate as CloseTime,'#13#10
    + 'wo.StartDate, wo.FinishDate, wo.FactFinishDate, wo.FactFinishDate as FactFinishTime,'#13#10
    + 'wo.Comment, wo.Comment2, wo.ShipmentApproved, wo.OrderMaterialsApproved, '
    + 'wo.IsComposite, wo.OrderState, wo.Customer,'#13#10
    + 'wo.RowColor, wo.SourceCalcID, wo.CreatorName, wo.ModifierName,'#13#10
    + 'wo.ClientTotal, wo.PrePayPercent, wo.PreShipPercent, wo.PayDelay, wo.IsPayDelayInBankDays,'#13#10
    + 'wo.PayState, wo.KindID, wo.IsProcessCostStored,'#13#10
    + 'wo.CostProtected, wo.ContentProtected, wo.ExternalId,'#13#10
    + 'wo.CallCustomer, wo.CallCustomerPhone, wo.HaveLayout, wo.HavePattern, wo.ProductFormat,'#13#10
    + 'wo.ProductPages, wo.IncludeCover, wo.SignManager, wo.SignProof, wo.HaveProof,'#13#10
    + GetHasNotesExpr + ','#13#10
    + 'case when wc.Name <> ''NONAME'' then wc.Name else '''' end as CustomerName,'#13#10
    + 'wc.Fax as CustomerFax, wc.Phone as CustomerPhone,'#13#10
    + GetSelectPayStateSQL + ','#13#10
    // TODO: Если вычисление следующих двух полей окажется слишком дорогим,
    // то можно будет их не считывать, если они не отображаются (за исключением режима отчета).
    // Точно так же можно и с состоянием заказа поступить. Если нет прав доступа, тоже можно
    // не отображать, тогда и в отчетах тоже.
    + GetTotalInvoiceCostExpr + ' as ' + F_TotalInvoiceCost + ','#13#10
    + GetTotalPayCostExpr + ' as ' + F_TotalPayCost + ','#13#10
    + GetHasInvoiceExpr + ', lch.StateChangeDate, ' + GetReportFieldsExpr + ','#13#10
    + GetOrderShipmentStateExpr + ','#13#10
    + GetIsLockedByUserExpr + ','#13#10
    + GetMatRequestModifiedExpr + #13#10;

  //if FSortField = F_LastStateChange then
  //  Result.Select := Result.Select + ', lch.StateChangeDate';
  //else
  //  Result.Select := Result.Select + ', cast(null as datetime) as StateChangeDate';

  //Result.From := 'LEFT JOIN Customer as wc ON wo.Customer = wc.N'#13#10
  Result.From := 'INNER JOIN AliveWorkOrders woal with (noexpand) on wo.N = woal.N'#13#10
    + 'LEFT JOIN Customer as wc ON wo.Customer = wc.N'#13#10
  //if SortField <> 'FinalCostGrn' then
  //  Result.From := Result.From +
    + 'LEFT JOIN Service_ClientPrice scp inner join OrderProcessItem opi on opi.ItemID = scp.ItemID on opi.OrderID = wo.N'#13#10
    + 'LEFT JOIN AccessKind ak on wo.KindID = ak.KindID and ak.UserID = ' + IntToStr(AccessManager.CurUser.ID);
  //  + 'LEFT JOIN InvoiceItems ii on ii.OrderID = wo.N';
  //if FSortField = F_LastStateChange then
    Result.From := Result.From + #13#10 + 'LEFT JOIN LastStateChangeDate lch on lch.N = wo.N';

  //Result.Where := 'IsDraft = 0 and wo.IsDeleted = 0';
  //expr := FCriteria.GetFilterExpr(Self);
  //if expr <> '' then
  //  Result.Where := Result.Where + ' and (' + expr + ')';
  Result.Where := FCriteria.GetFilterExpr(Self);

  Result.Sort := GetSortExpr;
  Result.TableName := 'WorkOrder';
  Result.TableAlias := 'wo';
  Result.KeyFieldName := F_OrderKey;
end;

function TWorkOrder.GetSelectPayStateSQL: string;
begin
  if EntSettings.AutoPayState then
  begin
    if not AccessManager.CurUser.ViewPayments then  // если нет прав доступа, то не выбираем состояние вообще
      Result := '1 as AutoPayState'
    else
     Result := GetPayStateFunc + ' as AutoPayState';
  end
  else
    Result := 'cast(null as int) as AutoPayState';
end;

function TWorkOrder.GetFinishDate: TDateTime;
begin
  Result := NvlDateTime(DataSet['FinishDate']);
end;

function TWorkOrder.GetFactFinishDate: variant;
begin
  Result := DataSet['FactFinishDate'];
end;

function TWorkOrder.GetStartDate: variant;
begin
  Result := DataSet[F_StartDate];
end;

function TWorkOrder.GetPayState: variant;
begin
  Result := DataSet[F_PayState];
end;

function TWorkOrder.GetAutoPayState: integer;
begin
  Result := NvlInteger(DataSet[F_AutoPayState]);
end;

function TWorkOrder.GetOrderState: integer;
begin
  Result := NvlInteger(DataSet[F_OrderState]);
end;

function TWorkOrder.GetShipmentApproved: boolean;
begin
  Result := NvlBoolean(DataSet['ShipmentApproved']);
end;

function TWorkOrder.GetOrderMaterialsApproved: boolean;
begin
  Result := NvlBoolean(DataSet[F_OrderMaterialsApproved]);
end;

function TWorkOrder.GetMatRequestModified: boolean;
begin
  Result := NvlBoolean(DataSet['MatRequestModified']);
end;

function TWorkOrder.GetExternalId: variant;
begin
  Result := DataSet[F_ExternalId];
end;

procedure TWorkOrder.SetExternalId(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_ExternalId] := Value;
end;

procedure TWorkOrder.DoOnCalcFields;
var
  n: integer;
  tc: extended;
begin
  inherited;
  if DisableCalcFields then Exit;

  n := Tirazz;
  DataSet['PlanFinishTime'] := DataSet['FinishDate'];
  // стоимость для клиента может быть уже зафиксирована
  if VarIsNull(DataSet[F_FinalCostGrn]) then  // НЕПОНЯТНО! Почему-то в TDraftOrder иначе!
  begin
    try tc := RoundByMode(NvlFloat(Dataset['ClientTotal']), NvlFloat(DataSet[F_Course]), n);
    except tc := 0; end;
  end
  else
    tc := DataSet[F_FinalCostGrn];
  DataSet['ClientTotalGrn'] := tc;
  if n > 0 then
    DataSet['CostOf1Grn'] := Round2(tc / n)//NvlFloat(Dataset['CostOf1']) * sm.USDCourse;
  else
    DataSet['CostOf1Grn'] := 0;

  // Затраты в грн
  //DataSet[F_TotalExpenseGrn] := DataSet[F_TotalExpenseCost] * NvlFloat(DataSet['Course']);

  // сумма долга по заказу
  tc := FinalCostGrn - NvlFloat(DataSet[F_TotalPayCost]);
  DataSet[F_AllDebtCost] := tc;
  if tc < 0 then
    tc := 0;
  // сумма долга по заказу (без переплат)
  DataSet[F_DebtCost] := tc;
  // прибыль по заказу
  if not VarIsNull(DataSet[F_Course]) then
    DataSet[F_TotalOrderProfitCost] := FinalCostGrn - NvlFloat(DataSet[F_TotalExpenseCost])
  else
    DataSet[F_TotalOrderProfitCost] := 0;
end;

procedure TWorkOrder.ToggleApproveShipment;
begin
  Database.ExecuteNonQuery('exec up_UpdateOrderShipmentApproved ' + IntToStr(KeyValue)
    + ', ' + IntToStr(Ord(not ShipmentApproved)));
end;

procedure TWorkOrder.ToggleApproveOrderMaterials;
begin
  Database.ExecuteNonQuery('exec up_UpdateOrderMaterialsApproved ' + IntToStr(KeyValue)
    + ', ' + IntToStr(Ord(not OrderMaterialsApproved)));
end;

class function TWorkOrder.GetFinishDateText(DateValue: variant): string;
begin
  if VarIsNull(DateValue) then
    Result := ''
  else
  begin
    Result := ' ' + FormatDateTime(StdDateFmt, DateValue);
    if (HourOf(DateValue) <> 0) or (MinuteOf(DateValue) <> 0) then
      Result := Result + ' ' + FormatDateTime('t', DateValue);
  end;
end;

procedure TWorkOrder.DoGetFinishDateText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := GetFinishDateText(Sender.Value);
end;

function TWorkOrder.GetCourseExpr: string;
begin
  Result := 'wo1.Course';
end;

procedure TWorkOrder.ChangeStartDate(dt: variant);
var
  s: string;
begin
  if VarIsNull(dt) then s := 'null' else s := FormatSQLDateTime(dt);
  Database.ExecuteNonQuery('update WorkOrder set StartDate = ' + s
    + ' where ' + F_OrderKey + ' = ' + IntToStr(KeyValue));
end;

{$ENDREGION}

{$REGION 'TContract - Не реализовано'}

constructor TContract.Create;
begin
  inherited Create('Doc', 'Документ', 'Документы', F_OrderNumberText);
  FNumberField := 'NDoc';
end;

{$ENDREGION}

end.
