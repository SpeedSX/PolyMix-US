unit PmInvoiceDocController;

interface

uses Classes,

  PmInvoice, PmCustomerOrders;

type
  TInvoiceDocController = class
  private
    FInvoices: TInvoices;
    procedure AddInvoiceItem(Sender: TObject);
    procedure EditInvoiceItem(Sender: TObject);
    procedure RemoveInvoiceItem(Sender: TObject);
    procedure PayInvoice(Sender: TObject);
    function GetSyncProducts: boolean;
    class function CheckInvoiceNumber(Invoices: TInvoices): boolean;
    class function GetCustomerOrders(CustomerID, OrderID: integer;
      SingleOrder: boolean): TCustomerInvoiceOrders;
  public
    property Invoices: TInvoices read FInvoices write FInvoices;
    class procedure SetDefaultPayType(Invoices: TInvoices);
    class function EditInvoiceForm(Invoices: TInvoices): boolean;
    class function MakeInvoice(CurCustomer, OrderID: integer): boolean; overload; // счет из заказа
    class function MakeInvoice(Invoices: TInvoices; CurCustomer, OrderID: integer): boolean; overload; // счет из заказа
    class function EditInvoice(InvoiceID: integer): boolean; overload; // редактирование счета
  end;

implementation

uses SysUtils, DateUtils, Controls, Dialogs, Variants,

  RDialogs, CalcUtils, MainFilter, PmActions, PmInvoiceForm, PmInvoiceItemForm,
  PmInvoiceItems, DicObj, StdDic, RDBUtils, PmConfigManager, PmEntSettings,
  CalcSettings;

// Надо ли синхронизировать номенклатуры для счетов по текущему виду оплаты
function TInvoiceDocController.GetSyncProducts: boolean;
begin
  Result := EntSettings.SyncProducts and NvlBoolean(TConfigManager.Instance.StandardDics.dePayKind.ItemValue[Invoices.PayType, 3]);
end;

procedure TInvoiceDocController.AddInvoiceItem(Sender: TObject);
var
  Orders: TCustomerInvoiceOrders;
begin
  if VarIsNull(Invoices.PayType) then
    RusMessageDlg('Укажите, пожалуйста, вид оплаты', mtError, [mbOk], 0)
  else
  if NvlInteger(Invoices.CustomerID) = 0 then
    RusMessageDlg('Выберите, пожалуйста, плательщика', mtError, [mbOk], 0)
  else
  begin
    Invoices.Items.DataSet.Append;
    Orders := GetCustomerOrders(NvlInteger(Invoices.CustomerID), 0, false);
    if ExecAddInvoiceItemForm(Invoices.Items, Orders, GetSyncProducts) then
    begin
      Invoices.Items.DataSet.CheckBrowseMode;
      Options.InvoiceNotPaidOnly := Orders.Criteria.NotPaidOnly;
      Options.InvoiceNotExistOnly := Orders.Criteria.NotInvoicedOnly;
    end else
      Invoices.Items.DataSet.Cancel;
    FreeAndNil(Orders);
  end;
end;

procedure TInvoiceDocController.EditInvoiceItem(Sender: TObject);
var
  Orders: TCustomerInvoiceOrders;
begin
  if VarIsNull(Invoices.PayType) then
    RusMessageDlg('Укажите, пожалуйста, вид оплаты', mtError, [mbOk], 0)
  else
  begin
    // Передаем OrderID, чтобы добавить текущий заказ к выборке заказов
    Orders := GetCustomerOrders(Invoices.CustomerID, Invoices.Items.OrderID, false);
    try
      // Передаем флажок, надо ли синхронизировать номенклатуры для счетов
      if ExecEditInvoiceItemForm(Invoices.Items, Orders, GetSyncProducts) then
      begin
        Invoices.Items.DataSet.CheckBrowseMode;
        Options.InvoiceNotPaidOnly := Orders.Criteria.NotPaidOnly;
        Options.InvoiceNotExistOnly := Orders.Criteria.NotInvoicedOnly;
      end
      else
        Invoices.Items.DataSet.Cancel;
    finally
      FreeAndNil(Orders);
    end;
  end;
end;

procedure TInvoiceDocController.RemoveInvoiceItem(Sender: TObject);
begin
  if not Invoices.IsEmpty and not Invoices.Items.IsEmpty
    and (RusMessageDlg('Удалить позицию счета?', mtConfirmation, mbYesNoCancel, 0) = mrYes) then
  begin
    Invoices.Items.Delete;
  end;
end;

procedure TInvoiceDocController.PayInvoice(Sender: TObject);
begin
  TMainActions.GetAction(TInvoiceActions.PayInvoice).Execute;
end;

class function TInvoiceDocController.EditInvoiceForm(Invoices: TInvoices): boolean;
var
  InvoiceNumIsOk, Cancelled, AddToExisting: boolean;
  Cnt: TInvoiceDocController;
begin
  InvoiceNumIsOk := true;
  Cnt := TInvoiceDocController.Create;
  try
    Cnt.Invoices := Invoices;
    repeat
      Cancelled := not ExecNewInvoiceForm(Invoices, Cnt.AddInvoiceItem, Cnt.EditInvoiceItem,
        Cnt.RemoveInvoiceItem, Cnt.PayInvoice);
      if not Cancelled then
      begin
        InvoiceNumIsOk := CheckInvoiceNumber(Invoices);
        //CheckInvoiceNumber(Cancelled, AddToExisting);
        //InvoiceNumIsOk := not AddToExisting;
      end;
    until InvoiceNumIsOk or Cancelled;
  finally
    Cnt.Free;
  end;
  Result := not Cancelled;
end;

class function TInvoiceDocController.CheckInvoiceNumber(Invoices: TInvoices): boolean;
var
  InvoiceIDs: TIntArray;
begin
  // Проверяем, есть ли уже такой номер счета
  InvoiceIDs := Invoices.FindByInvoiceNum(Invoices.InvoiceNum,
    YearOf(Invoices.InvoiceDate), Invoices.KeyValue, Invoices.PayType);
  Result := Length(InvoiceIDS) = 0;
  if not Result then
    RusMessageDlg('Счет с номером ' + Invoices.InvoiceNum + ' уже существует',
      mtError, [mbOk], 0)
end;

class function TInvoiceDocController.GetCustomerOrders(CustomerID, OrderID: integer;
  SingleOrder: boolean): TCustomerInvoiceOrders;
var
  Criteria: TCustomerInvoiceOrdersCriteria;
  FCustomerOrders: TCustomerInvoiceOrders;
begin
  {if FCustomerOrders <> nil then
    FreeAndNil(FCustomerOrders);}

  //if FCustomerOrders = nil then
  //begin
    FCustomerOrders := TCustomerInvoiceOrders.Create;
    Criteria.OrderID := OrderID;
    Criteria.SingleOrder := SingleOrder;
    Criteria.CustomerID := CustomerID;
    Criteria.NotPaidOnly := Options.InvoiceNotPaidOnly;
    Criteria.NotInvoicedOnly := Options.InvoiceNotExistOnly;
    Criteria.NotShippedOnly := false;
    Criteria.ForShipment := false;
    // Отображаем заказы не старше 1 года
    Criteria.StartDate := IncYear(Now, -1);
    Criteria.EndDate := Now;
    FCustomerOrders.Criteria := Criteria;
    FCustomerOrders.Open;
  //end;
  Result := FCustomerOrders;
end;

class function TInvoiceDocController.MakeInvoice(CurCustomer, OrderID: integer): boolean;
var
  InvCriteria: TInvoicesFilterObj;
  Invoices: TInvoices;
begin
  Invoices := TInvoices.Create;
  try
    InvCriteria := TInvoicesFilterObj.Create;
    try
      Invoices.Criteria := InvCriteria;
      InvCriteria.InvoiceID := 0; // новый счет
      Invoices.Open;
      Result := MakeInvoice(Invoices, CurCustomer, OrderID);
    finally
      InvCriteria.Free;
    end;
  finally
    Invoices.Free;
  end;
end;

// счет из заказа
class function TInvoiceDocController.MakeInvoice(Invoices: TInvoices; CurCustomer, OrderID: integer): boolean;
var
  Orders: TCustomerInvoiceOrders;
  Cancelled: boolean;
  CurInvoiceKey: variant;
  InvoiceIDs: TIntArray;
  InvItems: TInvoiceItems;
begin
  Result := false;

  {InvoiceIDs := Invoices.FindByOrderID(OrderID);
  Cancelled := false;
  if Length(InvoiceIDs) > 0 then
  begin
    Cancelled := RusMessageDlg('Для этого заказа уже выставлен счет. Выставить еще один?', mtConfirmation,
      mbYesNoCancel, 0) <> mrYes;
    // TODO: Предложить использовать остаток суммы
  end;}

  //if not Cancelled then
  //begin
    CurInvoiceKey := Invoices.KeyValue;
    Invoices.Append;
    SetDefaultPayType(Invoices);
    Invoices.CustomerID := CurCustomer;
    Invoices.InvoiceDate := Now;
    Invoices.OpenInvoiceItems;
    Cancelled := false;
    Orders := TInvoiceDocController.GetCustomerOrders(Invoices.CustomerID, OrderID, true);
    try
      if Orders.Locate(OrderID) then
      begin
        Invoices.InvoiceNum := IntToStr(Orders.OrderNumber);

        InvItems := Invoices.Items;
        InvItems.Append;
        InvItems.OrderID := OrderID;
        InvItems.OrderNumber := Orders.OrderNumber;
        InvItems.Quantity := Orders.Quantity;
        InvItems.ItemCost := Orders.Cost;
        InvItems.ItemText := Orders.Comment;
        InvItems.DataSet.CheckBrowseMode;

        Cancelled := not TInvoiceDocController.EditInvoiceForm(Invoices);
        if not Cancelled then
        begin
          try
            Invoices.ApplyUpdates;
            Invoices.Reload;
          except
            Invoices.CancelUpdates;
            raise;
          end;
        end
        else
        begin
          Invoices.CancelUpdates;
          if not VarIsNull(CurInvoiceKey) then
            Invoices.Locate(CurInvoiceKey);
        end;
        Result := not Cancelled;
      end
      else
      begin
        RusMessageDlg('Заказ не найден', mtError, [mbOk], 0);
      end;
    finally
      FreeAndNil(Orders);
    end;
//  end;
end;

class procedure TInvoiceDocController.SetDefaultPayType(Invoices: TInvoices);
var
  PayType: integer;
begin
  PayType := TConfigManager.Instance.StandardDics.GetDefaultPayType;
  if PayType <> 0 then
    Invoices.PayType := PayType;
end;

class function TInvoiceDocController.EditInvoice(InvoiceID: integer): boolean;
var
  InvCriteria: TInvoicesFilterObj;
  Invoices: TInvoices;
begin
  Invoices := TInvoices.Create;
  try
    InvCriteria := TInvoicesFilterObj.Create;
    try
      Invoices.Criteria := InvCriteria;
      InvCriteria.InvoiceID := InvoiceID;
      Invoices.Open;
      Invoices.OpenInvoiceItems;
      Result := EditInvoiceForm(Invoices);
      if Result then
        Result := Invoices.ApplyUpdates;
    finally
      InvCriteria.Free;
    end;
  finally
    Invoices.Free;
  end;
end;

end.
