unit PmAppController;

interface

{$I calc.inc}

uses Classes, SysUtils, DB, ADODB, JvAppStorage, ActnList,

  PmProcess, PmEntity, PmEntityController, PmPlan, PmPlanController,
  PmRecycleBin, PmBaseRecycleBinView, PmContragentRecycleBinView, PmOrderRecycleBinView,
  PmContragent, PmOrder, PmCustomersWithIncome, PmCustomerPayments,
  PmCustomerPaymentsView, PmConfigTreeEntity, PmInvoice, PmIncomingInvoice,
  PmOrderPayments, PmOrderInvoiceItems, PmReportData, PmReportController, PmShipment,
  PmShipmentController, PmMatRequest, PmSaleDocs, PmStock, PmStockMove, PmStockIncome,
  PmStockWaste
{$IFNDEF NoProduction}
  , PmProduction, PmProductionController
{$ENDIF}
  ;

type
  TEntityClass = class of TEntity;

  TEntityList = class(TList)
    function GetEntity(Index: integer): TEntity;
  public
    property Items[Index: integer]: TEntity read GetEntity;
  end;

  TAppController = class(TObject)
  private
    FDraftOrder: TDraftOrder;
    FWorkOrder: TWorkOrder;
    FContract: TContract;
    FEntities: TEntityList;
    FMainActions: TActionList;
    procedure LoadSettings(IniFS: TJvCustomAppStorage);
    function GetInvoices: TInvoices;
    function GetIncomingInvoices: TIncomingInvoices;
    function CreateInvoices: TInvoices;  // создает объект счетов
    function GetCustomerOrders: TCustomerOrders;
    function GetCustomerIncomes: TCustomerIncomes;
    //function GetCustomerPayments: TCustomerPayments;
    function GetShipment: TShipment;
    function GetSaleDocs: TSaleDocs;
    function GetMatRequest: TMaterialRequests;
    function CreateMatRequest: TMaterialRequests;
    function CreateEntity(EntityType: TEntityClass): TEntity;
    function GetStock: TStock;
    function GetStockMove: TStockMove;
    function GetStockIncome: TStockIncome;
    function GetStockWaste: TStockWaste;
    function GetEntity(EntityType: TEntityClass): TEntity;
    //function GetOrderInvoiceItems: TOrderInvoiceItems;
    //function CreateOrderInvoiceItems: TOrderInvoiceItems;  // создает объект счетов заказа
    //function GetOrderPayments: TOrderPayments;
    //function CreateOrderPayments: TOrderPayments;  // создает объект оплат заказа
    function GetCustomersWithIncome: TCustomersWithIncome;
    function CreateCustomersWithIncome: TCustomersWithIncome;  // создает объект оплат заказчиков
    function FindEntityType(EntityType: TEntityClass): TEntity;
  public
    constructor Create;
    destructor Destroy; override;
    procedure InitEntities;
    // Сущности, созданные контроллером, должны уничтожаться этим методом
    procedure FreeEntity(_Entity: TEntity);
    procedure SaveSettings(IniFS: TJvCustomAppStorage);
    procedure UpdateSortOrder(MakeActive: boolean); overload;
    //procedure UpdateOrderFilter;
    procedure RequestUSDCourse;
    function CreateEntityView(_Entity: TEntity): TEntityController;
    //function CreateEntityViewByClass(_Entity: TEntity; _EntityControllerClass: TEntityControllerClass): TEntityController;
    function GetEntityViewClass(_Entity: TEntity): TEntityControllerClass;
    function CreatePlan(EquipGroupCode: integer): TPlan;
{$IFNDEF NoProduction}
    function CreateProduction(EquipGroupCode: integer): TProduction;
{$ENDIF}
    procedure HideFilter(Sender: TObject);
    function CreateRecycleBin(ObjectType: integer): TBaseRecycleBin;
    procedure ViewContragentHistory(Contragents: TContragents);
    procedure MergeContragent(Contragents: TContragents);
    procedure ViewOrderHistory(_Order: TOrder);
    procedure ViewGlobalHistory;
    procedure ShowWorkOrderView; // делает активной страницу с заказами
    procedure EditWorkOrder(OrderID: integer); // делает активной страницу с заказами и открывает выбранный заказ
    function CreateConfigTree: TConfigTreeEntity;
    function CreateDraftOrder: TDraftOrder;
    function CreateWorkOrder: TWorkOrder;
    procedure SetPaging(Entity: TEntity; EnablePaging: boolean);

    property WorkOrder: TWorkOrder read FWorkOrder;
    property DraftOrder: TDraftOrder read FDraftOrder;
    property Entities: TEntityList read FEntities;
    property Invoices: TInvoices read GetInvoices;
    property IncomingInvoices: TIncomingInvoices read GetIncomingInvoices;
    property CustomerOrders: TCustomerOrders read GetCustomerOrders;
    property CustomerIncomes: TCustomerIncomes read GetCustomerIncomes;
    property CustomersWithIncome: TCustomersWithIncome read GetCustomersWithIncome;
    //property CustomerPayments: TCustomerPayments read GetCustomerPayments;
    property Shipment: TShipment read GetShipment;
    property SaleDocs: TSaleDocs read GetSaleDocs;
    property MaterialRequests: TMaterialRequests read GetMatRequest;
    property Stock: TStock read GetStock;
    property StockMove: TStockMove read GetStockMove;
    property StockIncome: TStockIncome read GetStockIncome;
    property StockWaste: TStockWaste read GetStockWaste;
    //property OrderInvoiceItems: TOrderInvoiceItems read GetOrderInvoiceItems;

    property MainActions: TActionList read FMainActions write FMainActions;
    //property OrderPayments: TOrderPayments read GetOrderPayments;
  end;

var
  AppController: TAppController;

implementation

uses CalcSettings, MainData, PmEntSettings, PmAccessManager, MainForm, RDBUtils,
  OrderHistoryFrm, GlobalHistoryFrm, ContragentHistoryFrm, MainFilter,
  PmContragentMergeForm, PmContragentMerge, PmConfigView, PmInvoiceController,
  PmIncomingInvoiceView, PmDraftController, PmWorkController, PmMaterialRequestController,
  PmSaleView, PmStockView, PmStockMoveView, PmStockIncomeView, PmStockWasteView
{$IFNDEF NoDocs}
, DocDM
{$ENDIF}
;

function TEntityList.GetEntity(Index: integer): TEntity;
begin
  Result := TEntity(inherited Items[Index]);
end;

constructor TAppController.Create;
begin
  inherited;
  FEntities := TEntityList.Create;
end;

destructor TAppController.Destroy;
var
  I: Integer;
begin
  for I := 0 to FEntities.Count - 1 do
    TEntity(FEntities[I]).Free;
  FreeAndNil(FEntities);
  inherited;
end;

{function TAppController.CreateEntityViewByClass(_Entity: TEntity; _EntityControllerClass: TEntityControllerClass): TEntityController;
begin
  if _EntityControllerClass = TCustomerPaymentsController then
    Result := TCustomerPaymentsController.Create(_Entity, GetCustomerOrders,
      //GetCustomerPayments,
      GetCustomerIncomes, TOrderInvoiceItems.Create)
  else
    Result := _EntityControllerClass.Create(_Entity);
end;}

function TAppController.CreateEntityView(_Entity: TEntity): TEntityController;
begin
  if _Entity is TDraftOrder then
    Result := TDraftController.Create(_Entity)
  else if _Entity is TWorkOrder then
    Result := TWorkController.Create(_Entity)
  else if _Entity is TPlan then
    Result := TPlanController.Create(_Entity)
{$IFNDEF NoProduction}
  else if _Entity is TProduction then
    Result := TProductionController.Create(_Entity)
{$ENDIF}
  else if _Entity is TContragentRecycleBin then
    Result := TContragentRecycleBinView.Create(_Entity)
  else if _Entity is TOrderRecycleBin then
    Result := TOrderRecycleBinView.Create(_Entity)
  else if _Entity is TCustomersWithIncome then
  begin
    Result := TCustomerPaymentsController.Create(_Entity, GetCustomerOrders,
      //GetCustomerPayments,
      GetCustomerIncomes, TOrderInvoiceItems.Create);
  end
  else if _Entity is TConfigTreeEntity then
    Result := TConfigView.Create(_Entity)
  else if _Entity is TInvoices then
    Result := TInvoiceController.Create(_Entity)
  else if _Entity is TIncomingInvoices then
    Result := TIncomingInvoiceView.Create(_Entity)
  else if _Entity is TReportData then
    Result := TReportController.Create(_Entity)
  else if _Entity is TShipment then
    Result := TShipmentController.Create(_Entity)
  else if _Entity is TSaleDocs then
    Result := TSaleView.Create(_Entity)
  else if _Entity is TMaterialRequests then
    Result := TMaterialRequestController.Create(_Entity)
  else if _Entity is TStock then
    Result := TStockView.Create(_Entity)
  else if _Entity is TStockMove then
    Result := TStockMoveView.Create(_Entity)
  else if _Entity is TStockIncome then
    Result := TStockIncomeView.Create(_Entity)
  else if _Entity is TStockWaste then
    Result := TStockWasteView.Create(_Entity)
  else
    raise EAssertionFailed.Create('CreateEntityView: неизвестный тип ' + _Entity.ClassName);
end;

function TAppController.GetEntityViewClass(_Entity: TEntity): TEntityControllerClass;
begin
  if _Entity is TDraftOrder then
    Result := TDraftController
  else if _Entity is TWorkOrder then
    Result := TWorkController
  else if _Entity is TPlan then
    Result := TPlanController
{$IFNDEF NoProduction}
  else if _Entity is TProduction then
    Result := TProductionController
{$ENDIF}
  else if _Entity is TContragentRecycleBin then
    Result := TContragentRecycleBinView
  else if _Entity is TOrderRecycleBin then
    Result := TOrderRecycleBinView
  else if _Entity is TCustomersWithIncome then
    Result := TCustomerPaymentsController
  else if _Entity is TConfigTreeEntity then
    Result := TConfigView
  else if _Entity is TInvoices then
    Result := TInvoiceController
  else if _Entity is TIncomingInvoices then
    Result := TIncomingInvoiceView
  else if _Entity is TReportData then
    Result := TReportController
  else if _Entity is TShipment then
    Result := TShipmentController
  else if _Entity is TSaleDocs then
    Result := TSaleView
  else if _Entity is TMaterialRequests then
    Result := TMaterialRequestController
  else if _Entity is TStock then
    Result := TStockView
  else if _Entity is TStockMove then
    Result := TStockMoveView
  else if _Entity is TStockIncome then
    Result := TStockIncomeView
  else if _Entity is TStockWaste then
    Result := TStockWasteView
  else
    raise EAssertionFailed.Create('GetEntityViewClass: неизвестный тип ' + _Entity.ClassName);
end;

procedure TAppController.InitEntities;
begin
  // создаем таблицы заказов, которые открываются сразу, с учетом прав доступа
  if AccessManager.CurUser.DraftVisible then
    FDraftOrder := CreateDraftOrder;
  if AccessManager.CurUser.WorkVisible then
    FWorkOrder := CreateWorkOrder;

{$IFNDEF NoDocs}
  FContracts := TContracts.Create(dmd.cdContracts);  // НЕ РЕАЛИЗОВАНО
  FEntities.Add(FContracts);
{$ENDIF}
  LoadSettings(TSettingsManager.Instance.Storage);
  {$IFNDEF NoExpenses}
    ExpDM.FindRangeLines
  {$ENDIF}
  {$IFNDEF NoDocs}
  if not dmd.FindOrdersWhere then begin Alert('Не найден макрос aqOrders::@@@WHERE'); Exit; end;
  {$ENDIF}

    {if AccessManager.CurUser.DraftVisible then
    begin
      FDraftOrder.SetOrderIDSQL;
      FDraftOrder.SetViewRange(false);  // Формирование SQL списка расчетов
    end;
    if AccessManager.CurUser.WorkVisible then
    begin
      FWorkOrder.SetOrderIDSQL;
      FWorkOrder.SetViewRange(false);  // Формирование SQL списка заказов
    end;}
    if AccessManager.CurUser.ContractVisible and AccessManager.CurUser.WorkVisible then
    begin
      // Формирование SQL списка договоров
      //FContract.SetViewRangeEx(false, false);  // отключено 09/02/2008
      // Это надо делать здесь! Т.к. используется OrdWhereLine
    {$IFNDEF NoDocs}
      SetupDocDialogs;
      // Формирование SQL списка заказов для договоров
      // СЛЕДУЮЩИЕ СТРОКИ ВЫКЛЮЧЕНЫ ПРИ ВВОДЕ TEntity. Их надо восстановить
      // если реализовывать ДОКУМЕНТЫ.
      {dm.SetOrderIDSQL(qiContrOrder);
      dm.SetOrderIDSQL(qiOrders);
      SelectOrderSetViewRange(false);
      SetSortOrder(qiOrders, false);}
    {$ENDIF}
    end;
    // Установка порядка сортировки и открытие таблиц
    //if AccessManager.CurUser.DraftVisible then AppController.UpdateSortOrder(FDraftOrder, true);
    //if AccessManager.CurUser.WorkVisible then AppController.UpdateSortOrder(FWorkOrder, true);
    {$IFNDEF NoDocs}
    //if AccessManager.CurUser.ContractVisible and AccessManager.CurUser.WorkVisible then
    //  SetSortOrder(FContracts, true);
    {$ENDIF}
end;
(*
procedure SetupDocDialogs;
begin
{$IFNDEF NoDocs}
  SelectOrderDataSource := dmd.dsOrders;
  SelectOrderDBDataSet := dmd.aqOrders;
  SelectOrderOrdWhereLine := OrdWhereLine;
  SelectOrderOrdRangeLine := RangeLines[qiOrders];
  SelectOrderKeyFieldName := KeyFields[qiOrders];
  SelectOrderRangeFieldName := RangeFields[qiOrders];
{$ENDIF}
end;*)

procedure TAppController.FreeEntity(_Entity: TEntity);
begin
  FEntities.Remove(_Entity);
  _Entity.Free;
end;

procedure TAppController.UpdateSortOrder(MakeActive: boolean);
var
  Entity: TEntity;
  i: integer;
begin
  for i := 0 to FEntities.Count - 1 do
  begin
    Entity := FEntities[i];
    Entity.SetSortOrder(Entity.SortField, MakeActive);
  end;
end;

procedure TAppController.HideFilter(Sender: TObject);
begin
  MForm.HideFilter(Sender);
end;

procedure TAppController.LoadSettings(IniFS: TJvCustomAppStorage);
var
  e: TEntity;
  i: integer;
  sort: string;
begin
  for i := 0 to FEntities.Count - 1 do
  begin
    e := FEntities[i];
    try sort := IniFS.ReadString(iniInterface + '\' + e.InternalName + 'Sort', e.SortField);
    except end;
    if sort <> '' then e.SetSortOrder(sort, false);
  end;
end;

procedure TAppController.SaveSettings(IniFS: TJvCustomAppStorage);
var
  e: TEntity;
  i: integer;
begin
  for i := 0 to FEntities.Count - 1 do
  begin
    e := FEntities[i];
    IniFS.WriteString(iniInterface + '\' + e.InternalName + 'Sort', e.SortField);
  end;
  {$IFNDEF NoDocs}
  IniFS.WriteString(iniInterface + '\ContractSort', SortFields[qiContract]);
  IniFS.WriteString(iniInterface + '\OrdersSort', SortFields[qiOrders]);
  {$ENDIF}
  {$IFNDEF NoFinance}
   // Пока не сохраняет и вообще это в ExpData
   {IniFS.WriteString(iniInterface + '\ComExpSort', SortFields[qiComExp]);
   IniFS.WriteString(iniInterface + '\OwnExpSort', SortFields[qiOwnExp]);}
  {$ENDIF}
end;

procedure TAppController.RequestUSDCourse;
begin
  MForm.SetCourse(dm.GetLastCourse);
end;

function TAppController.CreatePlan(EquipGroupCode: integer): TPlan;
var e: TEntity;
begin
  e := TPlan.Create(EquipGroupCode);
  SetPaging(e, true);
  FEntities.Add(e);
  Result := e as TPlan;
end;

{$IFNDEF NoProduction}
function TAppController.CreateProduction(EquipGroupCode: integer): TProduction;
var e: TEntity;
begin
  e := TProduction.Create(EquipGroupCode);
  SetPaging(e, true);
  FEntities.Add(e);
  Result := e as TProduction;
end;
{$ENDIF}

function TAppController.CreateRecycleBin(ObjectType: integer): TBaseRecycleBin;
var e: TEntity;
begin
  if ObjectType = BinObjectType_Orders then
    e := TOrderRecycleBin.Create(dm.cdOrderRecycleBin)
  else if ObjectType = BinObjectType_Contragents then
    e := TContragentRecycleBin.Create(dm.cdContragentRecycleBin)
  else
    raise EAssertionFailed.Create('CreateRecycleBin: Неизвестный тип ' + IntToStr(ObjectType));
  FEntities.Add(e);
  Result := e as TBaseRecycleBin;
end;

// создает объект оплат заказчиков
function TAppController.CreateCustomersWithIncome: TCustomersWithIncome;
var
  e: TCustomersWithIncome;
begin
  e := TCustomersWithIncome.Create;
  FEntities.Add(e);
  Result := e;
end;

{// создает объект оплат заказа
function TAppController.CreateOrderPayments: TOrderPayments;
var
  e: TOrderPayments;
begin
  e := TOrderPayments.Create;
  //FEntities.Add(e);
  Result := e;
end;

// создает объект счетов заказа
function TAppController.CreateOrderInvoiceItems: TOrderInvoiceItems;
var
  e: TOrderInvoiceItems;
begin
  e := TOrderInvoiceItems.Create;
  //FEntities.Add(e);
  Result := e;
end;}

procedure TAppController.SetPaging(Entity: TEntity; EnablePaging: boolean);
begin
  Entity.DefaultLastRecord := true;  // иначе не работает пейджер, но устанавливаем в любом случае
  if AccessManager.CurUser.DataPaging and EnablePaging then
  begin
    Entity.PagerMode := pmStructuredQuery;
    Entity.UsePager := true;
    Entity.QueryPager.RowsOnPage := 500;
  end
  else
    Entity.UsePager := false;
end;

function TAppController.CreateWorkOrder: TWorkOrder;
begin
  if NoClient then
    Result := TWorkOrder.Create({dm.WorkOrderData})
  else
  begin
    Result := TWorkOrder.Create({dm.WorkOrderData, }dm.aqWorkOrder);
    SetPaging(Result, true);
  end;
  FEntities.Add(Result);
end;

function TAppController.CreateDraftOrder: TDraftOrder;
begin
  if NoClient then
    Result := TDraftOrder.Create({dm.CalcOrderData})
  else
  begin
    Result := TDraftOrder.Create({dm.CalcOrderData, }dm.aqCalcOrder);
    SetPaging(Result, true);
  end;
  FEntities.Add(Result);
end;

// создает объект входящих счетов
function TAppController.CreateInvoices: TInvoices;
var
  e: TInvoices;
begin
  e := TInvoices.Create;
  // Для таблицы счетов активизируем постраничный режим
  SetPaging(e, not Options.ShowTotalInvoices);
  FEntities.Add(e);
  Result := e;
end;

function TAppController.CreateMatRequest: TMaterialRequests;
var
  e: TMaterialRequests;
begin
  e := TMaterialRequests.Create;
  // Для таблицы закупок активизируем постраничный режим
  SetPaging(e, not Options.ShowTotalMatRequests);
  FEntities.Add(e);
  Result := e;
end;

function TAppController.CreateEntity(EntityType: TEntityClass): TEntity;
begin
  Result := EntityType.Create;
  //SetPaging(Result); // это надо по какому-то условию
  FEntities.Add(Result);
end;

function TAppController.GetCustomersWithIncome: TCustomersWithIncome;
begin
  Result := GetEntity(TCustomersWithIncome) as TCustomersWithIncome;
end;

//function TAppController.GetCustomerPayments: TCustomerPayments;
//begin
//  Result := GetEntity(TCustomerPayments) as TCustomerPayments;
//end;

function TAppController.GetShipment: TShipment;
begin
  Result := GetEntity(TShipment) as TShipment;
end;

function TAppController.GetSaleDocs: TSaleDocs;
begin
  Result := GetEntity(TSaleDocs) as TSaleDocs;
end;

function TAppController.GetMatRequest: TMaterialRequests;
begin
  Result := FindEntityType(TMaterialRequests) as TMaterialRequests;
  if Result = nil then
    Result := CreateMatRequest;
end;

function TAppController.GetEntity(EntityType: TEntityClass): TEntity;
begin
  Result := FindEntityType(EntityType);
  if Result = nil then
    Result := CreateEntity(EntityType);
end;

function TAppController.GetStock: TStock;
begin
  Result := GetEntity(TStock) as TStock;
end;

function TAppController.GetStockMove: TStockMove;
begin
  Result := GetEntity(TStockMove) as TStockMove;
end;

function TAppController.GetStockIncome: TStockIncome;
begin
  Result := GetEntity(TStockIncome) as TStockIncome;
end;

function TAppController.GetStockWaste: TStockWaste;
begin
  Result := GetEntity(TStockWaste) as TStockWaste;
end;

{function TAppController.GetOrderInvoiceItems: TOrderInvoiceItems;
begin
  Result := FindEntityType(TOrderInvoiceItems) as TOrderInvoiceItems;
  if Result = nil then
    Result := CreateOrderInvoiceItems;
end;

function TAppController.GetOrderPayments: TOrderPayments;
begin
  Result := FindEntityType(TOrderPayments) as TOrderPayments;
  if Result = nil then
    Result := CreateOrderPayments;
end;}

function TAppController.GetInvoices: TInvoices;
begin
  Result := FindEntityType(TInvoices) as TInvoices;
  if Result = nil then
    Result := CreateInvoices;
end;

function TAppController.GetIncomingInvoices: TIncomingInvoices;
begin
  Result := GetEntity(TIncomingInvoices) as TIncomingInvoices;
end;

function TAppController.GetCustomerOrders: TCustomerOrders;
begin
  Result := GetEntity(TCustomerOrders) as TCustomerOrders;
end;

function TAppController.GetCustomerIncomes: TCustomerIncomes;
begin
  Result := GetEntity(TCustomerIncomes) as TCustomerIncomes;
end;

function TAppController.FindEntityType(EntityType: TEntityClass): TEntity;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FEntities.Count - 1 do
  begin
    if TEntity(FEntities[I]) is EntityType then
    begin
      Result := FEntities[I];
      break;
    end;
  end;
end;

procedure TAppController.ViewContragentHistory(Contragents: TContragents);
begin
  ExecContragentHistoryForm(Contragents, TSettingsManager.Instance.Storage);
end;

// делает активной страницу с заказами
procedure TAppController.ShowWorkOrderView;
begin
  MForm.ShowWorkOrderView;
end;

// делает активной страницу с заказами и открывает выбранный заказ
procedure TAppController.EditWorkOrder(OrderID: integer);
var
  WorkView: TWorkController;
begin
  {ShowWorkOrderView;
  WorkView := MForm.FindView(TWorkView) as TWorkView;}
  WorkView := MForm.OpenWorkOrderView;
  if WorkView <> nil then
  begin
    WorkView.SetSingleOrderFilter(OrderID);
    WorkView.EditCurrent;
  end;
end;

procedure TAppController.MergeContragent(Contragents: TContragents);
var
  Merge: TContragentMerge;
  SourceID: integer;
  DestID: integer;
  MergeFields, MergePersons: boolean;
begin
  SourceID := Contragents.KeyValue;
  DestID := ExecContragentMergeForm(Contragents, SourceID, MergeFields, MergePersons);
  if DestID > 0 then
  begin
    Merge := TContragentMerge.Create;
    try
      Merge.Execute(Contragents, SourceID, DestID, MergeFields, MergePersons);
      Contragents.ReloadLocate(DestID);
    finally
      Merge.Free;
    end;
  end;
end;

procedure TAppController.ViewOrderHistory(_Order: TOrder);
begin
  if not _Order.IsEmpty then
    ExecOrderHistoryForm(_Order, TSettingsManager.Instance.Storage);
end;

procedure TAppController.ViewGlobalHistory;
begin
  ExecGlobalHistoryForm(TSettingsManager.Instance.Storage);
end;

function TAppController.CreateConfigTree;
begin
  Result := TConfigTreeEntity.Create;
end;

initialization

AppController := TAppController.Create;

finalization

FreeAndNil(AppController);

end.
