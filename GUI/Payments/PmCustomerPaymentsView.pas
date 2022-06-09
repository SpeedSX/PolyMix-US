unit PmCustomerPaymentsView;

interface

uses Classes, Forms, Controls, Dialogs, SysUtils, JvAppStorage, DB, Variants,
  DBClient, ExtCtrls, JvSpeedBar,

  CalcUtils, PmEntity, PmEntityController, PmProviders, fCustomerPayments, PmCustomerPayments,
  PmContragent, PmCustomersWithIncome, CalcSettings, NotifyEvent, fBaseFrame,
  PmOrderInvoiceItems, fPaymentsToolbar;

type
  TFillIncomeFunc = function(IncomeData: TCustomerIncomes; Params: pointer): boolean;
  TGetIntFunc = function: integer of object;

  TCustomerPaymentsController = class(TEntityController)
  private
    FIncomes: TCustomerIncomes;
    //FPayments: TCustomerPayments;
    FOrders: TCustomerOrders;
    FOrderInvoiceItems: TOrderInvoiceItems;
    OrderTimer: TTimer;
    //AfterScrollID: TNotifyHandlerID;
    FOrdersAfterScrollID, FOrdersOpenID: TNotifyHandlerID;
    FToolbarFrame: TPaymentsToolbar;
    function GetFrame: TCustomerPaymentsFrame;
    function GetCustomersWithIncome: TCustomersWithIncome;
    class function GetOrderCriteria(Year: integer): TOrderInvoiceItemsCriteria;
    class function GetInvoiceCriteria(Year: integer): TOrderInvoiceItemsCriteria;
    procedure UpdateDetails(Sender: TObject);
    procedure AddFullPayment(Sender: TObject);
    procedure AddPartialPayment(Sender: TObject);
    procedure AddIncome(Sender: TObject);
    procedure DeleteIncome(Sender: TObject);
    procedure EditIncome(Sender: TObject);
    procedure EditPayments(Sender: TObject);
    procedure PrintOrders(Sender: TObject);
    procedure PrintIncomes(Sender: TObject);
    function FindInvoiceID(InvoiceNum: string; PayType: integer): integer;
    {procedure AddPayment(IncomesData: TCustomerIncomes; InvoiceItemID: integer;
      AmountToPay: extended; FullPayment, NeedRefresh: boolean);}
    class procedure AddPayment2(IncomeData: TCustomerIncomes;
      InvoiceItemID: integer; AmountToPay: extended; FullPayment, NeedRefresh: boolean);
    {procedure DoAddFullPaymentMultiple(IncomesData: TCustomerIncomes;
      InvoiceItemIds: TIntArray; NeedRefresh: boolean);}
    class procedure DoAddFullPaymentMultiple2(IncomeData: TCustomerIncomes;
      InvoiceItemIds: TIntArray; NeedRefresh: boolean);
    {procedure DoAddFullPayment(IncomesData: TCustomerIncomes;
      InvoiceItemId: integer; NeedRefresh: boolean);}
    class procedure DoAddFullPayment2(IncomesData: TCustomerIncomes;
      InvoiceItemId: integer; NeedRefresh: boolean);
    procedure SetCustomerID(Value: variant);
    function GetCustomerID: variant;
    procedure FilterChange;
    procedure DisableFilter;
    procedure GoToOrder(Sender: TObject);
    function GetCustomerChecked: boolean;
    procedure SetCustomerChecked(val : boolean);
    function GetCustomer: integer;
    procedure UpdateInvoices(Sender: TObject);
    procedure EditInvoice(Sender: TObject);
    procedure OrderTimerTimer(Sender: TObject);
    procedure InstantUpdateInvoices;
    // false ���� ������������ �������, ���������� � NewItemID ��������� ���� ������ �����������
    class function DoAddIncome(FillIncomeFunc: TFillIncomeFunc; GetCustomerFunc: TGetIntFunc;
       Params: pointer; var NewItemID: variant): boolean;
    // false ���� ������������ �������, ���������� � NewItemID ��������� ���� ������ �����������
    class function DoAddIncome2(Incomes: TCustomerIncomes;
      FillIncomeProc: TFillIncomeFunc; GetCustomerFunc: TGetIntFunc; Params: pointer;
      var NewItemID: variant): boolean;
    procedure DoEditIncome(IncomesData: TCustomerIncomes);
  public
    constructor Create(
      _Entity: TEntity;
      _Orders: TCustomerOrders;
      //_Payments: TCustomerPayments;
      _Incomes: TCustomerIncomes;
      _OrderInvoiceItems: TOrderInvoiceItems);
    destructor Destroy; override;
    function Visible: boolean; override;
    //procedure EditCurrent; override;
    //procedure DeleteCurrent(Confirm: boolean); override;
    function CreateFrame(Owner: TComponent): TBaseFrame; override;
    //procedure CancelCurrent; override;
    procedure Activate; override;
    //procedure LoadSettings(AppStorage: TjvCustomAppStorage); override;
    //procedure SaveSettings(AppStorage: TjvCustomAppStorage); override;
    procedure RefreshData; override;
    function GetToolbar: TjvSpeedbar; override;
    procedure PrintReport(ReportKey: integer; AllowInside: boolean); override;
    class procedure PayInvoiceItem(_InvoiceItemID, _CustomerID: integer);
    class procedure PayInvoice(_InvoiceID: integer);

    //property Payments: TCustomerPayments read FPayments;
    property Incomes: TCustomerIncomes read FIncomes;
    property Frame: TCustomerPaymentsFrame read GetFrame;
    property CustomersWithIncome: TCustomersWithIncome read GetCustomersWithIncome;
    property OrderInvoiceItems: TOrderInvoiceItems read FOrderInvoiceItems;
    property CustomerID: variant read GetCustomerID write SetCustomerID;

    property CustomerChecked: boolean read GetCustomerChecked write SetCustomerChecked;
  end;

implementation

uses ExHandler, DateUtils, JvJCLUtils, RDialogs, DBGridEh, fCustomerIncome, fAddIncomesForm,
  PmAppController, fMoneyRequestForm, RDBUtils, PmDatabase, MainFilter, PmInvoice,
  fOrderPayments, PmAccessManager, PmActions, PmScriptManager, PmSelectInvoiceForm,
  PmInvoiceDocController;

constructor TCustomerPaymentsController.Create(
  _Entity: TEntity;
  _Orders: TCustomerOrders;
  //_Payments: TCustomerPayments;
  _Incomes: TCustomerIncomes;
  _OrderInvoiceItems: TOrderInvoiceItems);
begin
  inherited Create(_Entity);
  FCaption := '�������������';
  //AfterScrollID := CustomersWithIncome.AfterScrollNotifier.RegisterHandler(UpdateDetails);
  FOrders := _Orders;
  //FPayments := _Payments;
  FIncomes := _Incomes;
  FOrderInvoiceItems := _OrderInvoiceItems;

  FFilter := TPaymentsFilterObj.Create;
  FFilter.RestoreFilter(TSettingsManager.Instance.Storage, iniFilter + FEntity.InternalName);
  CustomersWithIncome.Criteria := FFilter as TPaymentsFilterObj;
  FOrders.Criteria := FFilter as TPaymentsFilterObj;
  FIncomes.Criteria := FFilter as TPaymentsFilterObj;

  FOrdersAfterScrollID := FOrders.AfterScrollNotifier.RegisterHandler(UpdateInvoices);
  FOrdersOpenID := FOrders.OpenNotifier.RegisterHandler(UpdateInvoices);

  TMainActions.GetAction(TPaymentActions.New).OnExecute := AddIncome;
  TMainActions.GetAction(TPaymentActions.Edit).OnExecute := EditIncome;
  TMainActions.GetAction(TPaymentActions.Delete).OnExecute := DeleteIncome;
  TMainActions.GetAction(TPaymentActions.PrintOrders).OnExecute := PrintOrders;
  TMainActions.GetAction(TPaymentActions.PrintIncomes).OnExecute := PrintIncomes;
  TMainActions.GetAction(TPaymentActions.EditInvoice).OnExecute := EditInvoice;
end;

destructor TCustomerPaymentsController.Destroy;
begin
  //CustomersWithIncome.AfterScrollNotifier.UnRegisterHandler(AfterScrollID);
  FOrders.AfterScrollNotifier.UnRegisterHandler(FOrdersAfterScrollID);
  FOrders.OpenNotifier.UnRegisterHandler(FOrdersOpenID);
  inherited Destroy;
end;

function TCustomerPaymentsController.Visible: boolean;
begin
  Result := true;
end;

function TCustomerPaymentsController.CreateFrame(Owner: TComponent): TBaseFrame;
begin
  FFrame := TCustomerPaymentsFrame.Create(Owner, CustomersWithIncome,
    FOrders, FIncomes, FOrderInvoiceItems);

  FFrame.OnFilterChange := FilterChange;
  FFrame.OnDisableFilter := DisableFilter;
  FFrame.OnHideFilter := AppController.HideFilter;

  TCustomerPaymentsFrame(FFrame).OnAddFullPayment := AddFullPayment;
  TCustomerPaymentsFrame(FFrame).OnAddPartialPayment := AddPartialPayment;
  TCustomerPaymentsFrame(FFrame).OnAddIncome := AddIncome;
  TCustomerPaymentsFrame(FFrame).OnDeleteIncome := DeleteIncome;
  TCustomerPaymentsFrame(FFrame).OnEditIncome := EditIncome;
  TCustomerPaymentsFrame(FFrame).OnEditPayments := EditPayments;
  TCustomerPaymentsFrame(FFrame).CustomerChanged := UpdateDetails;
  TCustomerPaymentsFrame(FFrame).OnGoToOrder := GoToOrder;
  OrderTimer := TCustomerPaymentsFrame(FFrame).OrderTimer;
  OrderTimer.OnTimer := OrderTimerTimer;

  Result := FFrame;
end;

procedure TCustomerPaymentsController.UpdateInvoices(Sender: TObject);
begin
  if OrderTimer <> nil then
  begin
    // reset timer for detailed view
    if OrderTimer.Enabled then
      OrderTimer.Enabled := false;
    if FOrders.IsEmpty then
      FOrderInvoiceItems.Close
    else
      OrderTimer.Enabled := true;
  end;
end;

procedure TCustomerPaymentsController.EditInvoice(Sender: TObject);
begin
  if not FOrderInvoiceItems.IsEmpty then
    if TInvoiceDocController.EditInvoice(FOrderInvoiceItems.InvoiceID) then
      FOrderInvoiceItems.Reload;
end;

procedure TCustomerPaymentsController.OrderTimerTimer(Sender: TObject);
begin
  if FOrders.Active and Database.Connected then
  begin
    OrderTimer.Enabled := false;
    InstantUpdateInvoices;
  end;
end;

procedure TCustomerPaymentsController.InstantUpdateInvoices;
var
  cr: TOrderInvoiceItemsCriteria;
begin
  cr := TOrderInvoiceItemsCriteria.Default;
  cr.OrderID := NvlInteger(FOrders.KeyValue);
  cr.Mode := TOrderInvoiceItemsCriteria.Mode_Normal;
  //FOrderInvoiceItems.OrderID := NvlInteger(FOrders.KeyValue);
  FOrderInvoiceItems.Criteria := cr;
  FOrderInvoiceItems.Reload;
end;

// ��������� ������ (���� ���� ����� �����) �� ���������� �����������
// � ��������� �����, ���������� ����� � ������������, �.�. ����
// ����������� �������� ����� �����.
procedure TCustomerPaymentsController.AddPartialPayment(Sender: TObject);
var
  PayAmount: extended;
begin
  if (FOrderInvoiceItems.ItemDebt > 0) and (FIncomes.RestIncome > 0)
    and not FIncomes.DataSet.IsEmpty then
  begin
    PayAmount := FIncomes.RestIncome;
    if PayAmount > FOrderInvoiceItems.ItemDebt then
      PayAmount := FOrderInvoiceItems.ItemDebt;
    if ExecMoneyRequestDialog('������ ������', '������� �������� ��� ������:',
      0, PayAmount, PayAmount) then
    AddPayment2(FIncomes, FOrderInvoiceItems.KeyValue, PayAmount, false, true);
    RefreshData;
  end;
end;

// ��������� ������ (���� ���� ����� �����) �� ���������� �����������
// � ��������� �����
procedure TCustomerPaymentsController.AddFullPayment(Sender: TObject);
begin
  DoAddFullPayment2(FIncomes, FOrderInvoiceItems.KeyValue, true);
  RefreshData;
end;                                  

{procedure TCustomerPaymentsView.DoAddFullPayment(IncomesData: TCustomerIncomes;
  InvoiceItemId: integer; NeedRefresh: boolean);
var
  InvoiceItemIds: TIntArray;
begin
  SetLength(InvoiceItemIds, 1);
  InvoiceItemIds[Low(InvoiceItemIds)] := InvoiceItemId;
  DoAddFullPaymentMultiple(IncomesData, InvoiceItemIds, true);  // � �����������
end;}

class procedure TCustomerPaymentsController.DoAddFullPayment2(IncomesData: TCustomerIncomes;
  InvoiceItemId: integer; NeedRefresh: boolean);
var
  InvoiceItemIds: TIntArray;
begin
  SetLength(InvoiceItemIds, 1);
  InvoiceItemIds[Low(InvoiceItemIds)] := InvoiceItemId;
  DoAddFullPaymentMultiple2(IncomesData, InvoiceItemIds, true);  // � �����������
end;

// ----------------------------------

{procedure TCustomerPaymentsView.DoAddFullPaymentMultiple(IncomesData: TCustomerIncomes;
  InvoiceItemIds: TIntArray; NeedRefresh: boolean);
var
  Id: Integer;
begin
  if (IncomesData.RestIncome > 0) and not IncomesData.DataSet.IsEmpty then
  begin
    // ���� ���������������� ������� ������, �� ����� ������ ���,
    // ����� ��������� ���������.
    for Id := Low(InvoiceItemIDs) to High(InvoiceItemIDs) do
    begin
      AddPayment(IncomesData, InvoiceItemIDs[id], 0, true, NeedRefresh);
    end;
  end;
end; }

class procedure TCustomerPaymentsController.DoAddFullPaymentMultiple2(IncomeData: TCustomerIncomes;
  InvoiceItemIds: TIntArray; NeedRefresh: boolean);
var
  Id: Integer;
begin
  if (IncomeData.RestIncome > 0) and not IncomeData.DataSet.IsEmpty then
  begin
    // ���� ���������������� ������� ������, �� ����� ������ ���,
    // ����� ��������� ���������.
    for Id := Low(InvoiceItemIDs) to High(InvoiceItemIDs) do
    begin
      AddPayment2(IncomeData, InvoiceItemIDs[id], 0, true, NeedRefresh);
    end;
  end;
end;

// --------------------------------

{procedure TCustomerPaymentsView.AddPayment(IncomesData: TCustomerIncomes;
  InvoiceItemID: integer; AmountToPay: extended; FullPayment, NeedRefresh: boolean);
begin
  if (FIncomes.RestIncome > 0) and not FIncomes.DataSet.IsEmpty then
  begin
    Payments.DataSet.Append;
    Payments.PayType := FIncomes.PayType;
    if FullPayment then
      Payments.FullPayment := true
    else
    begin
      Payments.PaidGrn := AmountToPay;
      Payments.FullPayment := false;
    end;
    Payments.PayDate := IncomesData.IncomeDate;
    Payments.InvoiceItemID := InvoiceItemID;
    Payments.IncomeID := FIncomes.KeyValue;
    Payments.ApplyUpdates;

    if NeedRefresh then RefreshData;
  end;
end;}

class procedure TCustomerPaymentsController.AddPayment2(IncomeData: TCustomerIncomes;
  InvoiceItemID: integer; AmountToPay: extended; FullPayment, NeedRefresh: boolean);
var
  Payments: TCustomerPayments;
  PCriteria: TCustomerPaymentsCriteria;
begin
  if (IncomeData.RestIncome > 0) and not IncomeData.DataSet.IsEmpty then
  begin
    Payments := TCustomerPayments.Create;
    try
      PCriteria.IncomeID := 0;
      PCriteria.OrderID := null;
      Payments.Criteria := PCriteria;
      Payments.Open;

      Payments.DataSet.Append;
      Payments.PayType := IncomeData.PayType;
      if FullPayment then
        Payments.FullPayment := true
      else
      begin
        Payments.PaidGrn := AmountToPay;
        Payments.FullPayment := false;
      end;
      Payments.PayDate := IncomeData.IncomeDate;
      Payments.InvoiceItemID := InvoiceItemID;
      Payments.IncomeID := IncomeData.KeyValue;
      Payments.ApplyUpdates;
    finally
      Payments.Free;
    end;
    //if NeedRefresh then RefreshData;  TODO!
  end;
end;

function TCustomerPaymentsController.GetCustomerChecked: boolean;
begin
  Result := (NvlInteger(CustomerID) > 0) and TCustomerPaymentsFrame(FFrame).CustomerChecked;
end;

class function TCustomerPaymentsController.GetOrderCriteria(Year: integer): TOrderInvoiceItemsCriteria;
begin
  Result := TOrderInvoiceItemsCriteria.Default;
  Result.DateFilter := 'year(' + TOrderInvoiceItems.F_OrderDate + ') = ' + IntToStr(Year);
end;

procedure TCustomerPaymentsController.AddIncome(Sender: TObject);
var
  NewItemID: variant;
begin
  if DoAddIncome(ExecAddIncomesDialog, GetCustomer, nil, NewItemID) then
  begin
    RefreshData;
    if not VarIsNull(NewItemID) then
      Incomes.Locate(NewItemID);
  end;
end;

function TCustomerPaymentsController.GetCustomer: integer;
begin
  if GetCustomerChecked then
    Result := TCustomerPaymentsFrame(FFrame).CustomerID
  else
    Result := 0;
end;

class function TCustomerPaymentsController.GetInvoiceCriteria(Year: integer): TOrderInvoiceItemsCriteria;
begin
  Result := TOrderInvoiceItemsCriteria.Default;
  Result.DateFilter := 'year(' + TInvoices.F_InvoiceDate + ') = ' + IntToStr(Year);
end;

// ������ �����������
(*procedure TCustomerPaymentsView.DoAddIncome(FillIncomeProc: TFillIncomeProc; Params: pointer);
var
  IncomesCopy: TCustomerIncomes;
  OK: boolean;
  OldKeys, InvoiceItemIDs: TIntArray;
  i, OrderCustomerID: integer;
  CurIncomeID: variant;
  OrderIDs, InvoiceIDs: TIntArray;
  Msg: string;

  procedure MessageMissingInvoice;
  begin
    RusMessageDlg('�� ������� ���������� ����� ����� ��� ���������� �����������'
      + #13 + '�� ������ ������� ��� � ���������� �����������', mtWarning, [mbOk], 0);
  end;

  procedure MessageAmbiguousInvoice;
  begin
    RusMessageDlg('�� ������� ���������� ���������� ���� �� ������ ��� ���������� �����������'
      + #13 + '����������, ������� ��� � ���������� �����������', mtWarning, [mbOk], 0);
  end;

  procedure TryPayByInvoiceNumber(OrderCriteriaStr: string);

    procedure GetInvoiceByID;
    var
      InvoiceCriteria: TOrderInvoiceItemsCriteria;
    begin
      InvoiceCriteria := TOrderInvoiceItemsCriteria.Default;
      InvoiceCriteria.InvoiceID := Incomes.InvoiceID;
      InvoiceItemIDs := OrderInvoiceItems.FindByInvoiceID({Incomes.InvoiceID,}
        InvoiceCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
    end;

    procedure FindInvoice;
    var
      InvoiceCriteria: TOrderInvoiceItemsCriteria;
    begin
      // ���� ���� � ������� ����
      InvoiceCriteria := GetInvoiceCriteria(YearOf(Now));
      InvoiceCriteria.PayType := Incomes.PayType;
      InvoiceItemIDs := OrderInvoiceItems.FindByInvoiceNumber(Incomes.InvoiceNumber,
        InvoiceCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
      if Length(InvoiceIDs) = 0 then  // ���� � ������� ���� �� ������, �� ���� � ����������
      begin
        InvoiceCriteria := GetInvoiceCriteria(YearOf(Now));
        InvoiceItemIDs := OrderInvoiceItems.FindByInvoiceNumber(Incomes.InvoiceNumber,
          InvoiceCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
        if Length(InvoiceIDs) = 0 then    // ���� ����� �� ������, �� ���� �� ����
        begin
          InvoiceCriteria.DateFilter := OrderCriteriaStr;
          InvoiceItemIDs := OrderInvoiceItems.FindByInvoiceNumber(Incomes.InvoiceNumber,
            InvoiceCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
        end;
      end;
    end;

  begin
    if NvlInteger(Incomes.InvoiceID) = 0 then
    begin
      FindInvoice;
      // ������ ���� �����, ���� ��� ������
      if Length(InvoiceIDs) = 1 then
        Incomes.InvoiceID := InvoiceIDs[0]
      else if Length(InvoiceIDs) = 0 then
        MessageMissingInvoice;
    end
    else
      GetInvoiceByID;

    if Length(InvoiceIDs) > 1 then
      MessageAmbiguousInvoice
    else
    if Length(InvoiceItemIDs) > 1 then
    begin
      if RusMessageDlg('������� ����� ����� ������� � ����� � � ' + VarToStr(Incomes.InvoiceNumber)
        + #13 + '�������� ��� �������?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        Exit;
      DoAddFullPaymentMultiple(Incomes, InvoiceItemIDs, false); // ��� ����������
    end
    else
    if Length(OrderIDs) = 1 then
    begin
      DoAddFullPaymentMultiple(Incomes, InvoiceItemIDs, false);  // ��� ����������
    end
    else
    begin
      Msg := '���� � ' + VarToStr(Incomes.InvoiceNumber) + ' �� ������';
      if GetCustomerChecked then
        Msg := Msg + ' ��� ������� ���������';
      RusMessageDlg(Msg, mtError, [mbOk], 0);
      // ��������� ����������� �������������
    end;
  end;

  procedure TryPayByOrderNumber;
  var
    OrderCriteria: TOrderInvoiceItemsCriteria;
  begin
     // ���� ����� � ������� ����
    OrderCriteria := GetOrderCriteria(FFilter.CurrentYear);
    OrderCriteria.PayType := Incomes.PayType;
    InvoiceItemIDs := OrderInvoiceItems.FindByOrderNumber(Incomes.OrderNumber,
      OrderCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
    if Length(OrderIDs) = 0 then  // ���� � ������� ���� �� ������, �� ���� � ����������
    begin
      OrderCriteria := GetOrderCriteria(FFilter.CurrentYear - 1);
      InvoiceItemIDs := OrderInvoiceItems.FindByOrderNumber(Incomes.OrderNumber,
        OrderCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
      if Length(OrderIDs) = 0 then  // ���� ����� �� ������, �� ���� �� ����
      begin
        OrderCriteria.DateFilter := '';
        InvoiceItemIDs := OrderInvoiceItems.FindByOrderNumber(Incomes.OrderNumber,
          OrderCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
      end;
    end;

    if Length(InvoiceItemIDs) > 1 then
    begin
      if not VarIsNull(Incomes.InvoiceNumber) then
      begin
        OrderCriteria.InvoiceNumber := Incomes.InvoiceNumber;
        InvoiceItemIDs := OrderInvoiceItems.FindByOrderNumber(Incomes.OrderNumber,
          OrderCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
      end;
      if Length(InvoiceItemIDs) = 1 then
      begin
        Incomes.InvoiceID := InvoiceIDs[0];
        DoAddFullPaymentMultiple(Incomes, InvoiceItemIDs, false);  // ��� ����������
      end
      else
      if Length(InvoiceItemIDs) > 1 then
        RusMessageDlg('������� ����� ����� ������� � ������ ��� ������ � � '
          + VarToStr(Incomes.OrderNumber), mtInformation, [mbOk], 0)
      else
        MessageMissingInvoice;
    end
    else if Length(OrderIDs) = 1 then
    begin
      // ������ ���� �����, ���� ��� ������
      if Length(InvoiceIDs) = 1 then
        Incomes.InvoiceID := InvoiceIDs[0]
      else
        MessageMissingInvoice;

      DoAddFullPaymentMultiple(Incomes, InvoiceItemIDs, false);  // ��� ����������
    end
    else if Length(OrderIDs) > 1 then  // ���� ������� ��������� ������� � ����� �������
    begin
      if not VarIsNull(Incomes.InvoiceNumber) then  // �������� ����� �� ������ �����
        TryPayByInvoiceNumber('wo.ID_Number = ' + VarToStr(Incomes.OrderNumber))
      else
        RusMessageDlg('������� ��������� ������� � ������� ' + Incomes.OrderNumber, mtError, [mbOk], 0);
        // ��������� ����������� �������������
    end
    else
    begin
      Msg := '����� � ' + VarToStr(Incomes.OrderNumber) + ' �� ������';
      if GetCustomerChecked then
        Msg := Msg + ' ��� ������� ���������';
      RusMessageDlg(Msg, mtError, [mbOk], 0);
      // ��������� ����������� �������������
    end;
  end;

begin
  IncomesCopy := TCustomerIncomes.Copy(Incomes);
  try
    IncomesCopy.DataSet.Filter := 'IncomeID is null';
    IncomesCopy.DataSet.Filtered := true;
    IncomesCopy.DataSet.Append;
    repeat
      if FillIncomeProc(IncomesCopy, Params) then
      begin
        if IncomesCopy.DataSet.State in [dsInsert, dsEdit] then IncomesCopy.DataSet.Post;
        OK := true;
        IncomesCopy.DataSet.First;
        while not IncomesCopy.DataSet.eof do
        begin
          // ��������� �������� ������� ������� ��� ������ � ������ ����������� ���� ����������,
          // �.�. ����� ������ ���������� ��������� ��� �������� �����������.
          if not GetCustomerChecked then
          begin
            if (NvlInteger(IncomesCopy.OrderNumber) = 0)
              and (Trim(NvlString(IncomesCopy.InvoiceNumber)) = '') then
            begin
              OK := false;
              RusMessageDlg('����������, ������� � ������ ��� �����, ���� �������� ���������', mtError, [mbOk], 0);
              break;
            end
            else
            // ���� ���-�� �������, �� ���� ���������� ���������.
            if NvlInteger(IncomesCopy.OrderNumber) > 0 then
            begin
              InvoiceItemIDs := FOrderInvoiceItems.FindByOrderNumber(IncomesCopy.OrderNumber,
                GetOrderCriteria(FFilter.CurrentYear), OrderCustomerID, OrderIDs, InvoiceIDs);
              OK := false;
              // TODO: ��� ���� �������� ��������.
              if Length(InvoiceItemIDs) = 0 then
                RusMessageDlg('����� � ' + VarToStr(IncomesCopy.OrderNumber) + ' �� ������ ��� ��� ���� �� ��� ��������� ����', mtError, [mbOk], 0)
              else if Length(OrderIDs) > 1 then
                RusMessageDlg('������� ����� ������ ������ � � ' + VarToStr(IncomesCopy.OrderNumber)
                  + '����������, �������� ��� ��� ���������', mtError, [mbOk], 0)
                  // TODO:
              else if (Length(OrderIDs) = 1) and (Length(InvoiceItemIDs) > 1) then
              begin
                RusMessageDlg('������� ����� ����� ������� � ������ ��� ������ � � ' + VarToStr(IncomesCopy.OrderNumber),
                  //+ '�������� ����������� �� ���� ��������?',
                  mtInformation, [mbOk], 0);
                IncomesCopy.FieldCustomerID := OrderCustomerID;
                OK := true;
              end
              else
              begin
                // ������� ��������� ����� �����
                if Length(InvoiceIDs) = 1 then
                  IncomesCopy.InvoiceID := InvoiceIDs[0]
                else if Length(InvoiceIDs) = 0 then
                  MessageMissingInvoice
                else if Length(InvoiceIDs) > 1 then
                  MessageAmbiguousInvoice;
                IncomesCopy.FieldCustomerID := OrderCustomerID;
                OK := true;
              end;
              // ����� ����� ���� ���� �� ������������� ���� ����� if OK?
            end
            else
            if Trim(NvlString(IncomesCopy.InvoiceNumber)) <> '' then
            begin
              InvoiceItemIDs := FOrderInvoiceItems.FindByInvoiceNumber(Trim(IncomesCopy.InvoiceNumber),
                GetOrderCriteria(FFilter.CurrentYear), OrderCustomerID, OrderIDs, InvoiceIDs);
              OK := false;
              if Length(InvoiceItemIDs) = 0 then
                RusMessageDlg('���� � ' + VarToStr(IncomesCopy.InvoiceNumber) + ' �� ������', mtError, [mbOk], 0)
              else if Length(OrderIDs) > 1 then
              begin
                RusMessageDlg('������� ����� ������ ������ ��� ����� � � ' + VarToStr(IncomesCopy.InvoiceNumber),
                  mtInformation, [mbOk], 0);
                IncomesCopy.FieldCustomerID := OrderCustomerID;
                OK := true;
              end
              else
              begin
                IncomesCopy.FieldCustomerID := OrderCustomerID;
                OK := true;
              end;
              // ������� ��������� ����� �����
              if OK then
              begin
                if Length(InvoiceIDs) = 1 then
                  IncomesCopy.InvoiceID := InvoiceIDs[0]
                else if Length(InvoiceIDs) = 0 then
                  MessageMissingInvoice
                else if Length(InvoiceIDs) > 1 then
                  MessageAmbiguousInvoice;
              end;
            end;
          end;

          if IncomesCopy.IncomeGrn = 0 then
          begin
            OK := false;
            RusMessageDlg('�������, ����������, ����� �����������', mtError, [mbOk], 0);
            break;
          end;
          if IncomesCopy.PayType = 0 then
          begin
            OK := false;
            RusMessageDlg('�������, ����������, ��� ������', mtError, [mbOk], 0);
            break;
          end;
          if IncomesCopy.IncomeDate = 0 then
          begin
            OK := false;
            RusMessageDlg('�������, ����������, ���� �����������', mtError, [mbOk], 0);
            break;
          end;
          IncomesCopy.DataSet.Next;
        end;
      end
      else
        Exit;
    until OK;

    // ���������� ������� ����� �����������
    SetLength(OldKeys, Incomes.DataSet.RecordCount);
    Incomes.SaveLocation;
    Incomes.DataSet.DisableControls;
    try
      Incomes.DataSet.First;
      i := 0;
      while not Incomes.DataSet.eof do
      begin
        OldKeys[i] := Incomes.KeyValue;
        Incomes.DataSet.Next;
        Inc(i);
      end;
    finally
      Incomes.DataSet.EnableControls;
      Incomes.RestoreLocation;
    end;

    // ������� �����������, �.�. ��� ����� �� �������� �����
    Incomes.MergeData(IncomesCopy.DataSet as TClientDataSet);
    Incomes.ApplyUpdates;
    Incomes.Reload;

  finally
    IncomesCopy.Free;
  end;

  // ������������� �������� ����������� �� �������� �����, ���� ������ ����� ������,
  // ��� ����� ����������� ������ ��� ���� �������
  CurIncomeID := Incomes.KeyValue;
  Incomes.DataSet.DisableControls;
  try
    Incomes.DataSet.First;
    while not Incomes.DataSet.eof do
    begin
      if not IntInArray(Incomes.KeyValue, OldKeys) then
      begin
        if NvlInteger(Incomes.InvoiceItemID) > 0 then
        begin
          DoAddFullPayment(Incomes, Incomes.InvoiceItemID, false);  // ��� ����������
        end
        else
        if not VarIsNull(Incomes.OrderNumber) then
          TryPayByOrderNumber
        else  // �������� �������� �� ����� �����
          if not VarIsNull(Incomes.InvoiceNumber) then
            TryPayByInvoiceNumber('')
      end;
      Incomes.DataSet.Next;
    end;
  finally
    Incomes.DataSet.EnableControls;
    Incomes.Locate(CurIncomeID);
  end;

  Incomes.ApplyUpdates;  // ����� ���������� ������ ������

  RefreshData;

end;*)

// ������ �����������
class function TCustomerPaymentsController.DoAddIncome2(Incomes: TCustomerIncomes;
  FillIncomeProc: TFillIncomeFunc; GetCustomerFunc: TGetIntFunc; Params: pointer;
  var NewItemID: variant): boolean;
var
  OK: boolean;
  NewKeys, InvoiceItemIDs: TIntArray;
  i, OrderCustomerID: integer;
  CurIncomeID: variant;
  OrderIDs, InvoiceIDs: TIntArray;
  Msg: string;
  //PFilter: TPaymentsFilterObj;

  procedure MessageMissingInvoice;
  begin
    RusMessageDlg('�� ������� ���������� ����� ����� ��� ���������� �����������'
      + #13 + '�� ������ ������� ��� � ���������� �����������', mtWarning, [mbOk], 0);
  end;

  procedure MessageAmbiguousInvoice;
  begin
    RusMessageDlg('�� ������� ���������� ���������� ���� �� ������ ��� ���������� �����������'
      + #13 + '����������, ������� ��� � ���������� �����������', mtWarning, [mbOk], 0);
  end;

  // ��������� ���������, ������ �� ������ ����, ���� ������ ���� �� �������
  procedure MessageInvoiceNotFound(InvNum: string);
  begin
    RusMessageDlg('���� � ' + InvNum + ' �� ������', mtError, [mbOk], 0);
  end;

  function GetCustomerChecked: boolean;
  begin
    if Assigned(GetCustomerFunc) then
      Result := GetCustomerFunc > 0
    else
      Result := false;
  end;

  procedure TryPayByInvoiceNumber(OrderCriteriaStr: string);

    procedure GetInvoiceByID;
    var
      InvoiceCriteria: TOrderInvoiceItemsCriteria;
    begin
      InvoiceCriteria := TOrderInvoiceItemsCriteria.Default;
      InvoiceCriteria.InvoiceID := Incomes.InvoiceID;
      InvoiceItemIDs := TOrderInvoiceItems.FindByInvoiceID(
        InvoiceCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
    end;

    procedure FindInvoice;
    var
      InvoiceCriteria: TOrderInvoiceItemsCriteria;
    begin
      // ���� ���� � ������� ����
      InvoiceCriteria := GetInvoiceCriteria(YearOf(Now));
      InvoiceCriteria.PayType := Incomes.PayType;
      InvoiceItemIDs := TOrderInvoiceItems.FindByInvoiceNumber(Incomes.InvoiceNumber,
        InvoiceCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
      if Length(InvoiceIDs) = 0 then  // ���� � ������� ���� �� ������, �� ���� � ����������
      begin
        InvoiceCriteria := GetInvoiceCriteria(YearOf(Now) - 1);
        InvoiceItemIDs := TOrderInvoiceItems.FindByInvoiceNumber(Incomes.InvoiceNumber,
          InvoiceCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
        if Length(InvoiceIDs) = 0 then    // ���� ����� �� ������, �� ���� �� ����
        begin
          InvoiceCriteria.DateFilter := OrderCriteriaStr;
          InvoiceItemIDs := TOrderInvoiceItems.FindByInvoiceNumber(Incomes.InvoiceNumber,
            InvoiceCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
        end;
      end;
    end;

  begin
    if NvlInteger(Incomes.InvoiceID) = 0 then
    begin
      FindInvoice;
      // ������ ���� �����, ���� ��� ������
      if Length(InvoiceIDs) = 1 then
        Incomes.InvoiceID := InvoiceIDs[0]
      else if Length(InvoiceIDs) = 0 then
        MessageMissingInvoice;
    end
    else
      GetInvoiceByID;

    if Length(InvoiceIDs) > 1 then
      MessageAmbiguousInvoice
    else
    if Length(InvoiceItemIDs) > 1 then
    begin
      if RusMessageDlg('������� ����� ����� ������� � ����� � � ' + VarToStr(Incomes.InvoiceNumber)
        + #13 + '�������� ��� �������?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        Exit;
      DoAddFullPaymentMultiple2(Incomes, InvoiceItemIDs, false); // ��� ����������
    end
    else
    if Length(OrderIDs) = 1 then
    begin
      DoAddFullPaymentMultiple2(Incomes, InvoiceItemIDs, false);  // ��� ����������
    end
    else
    begin
      Msg := '���� � ' + VarToStr(Incomes.InvoiceNumber) + ' �� ������';
      {if GetCustomerChecked then
        Msg := Msg + ' ��� ������� ���������';}  // ����� !
      RusMessageDlg(Msg, mtError, [mbOk], 0);
      // ��������� ����������� �������������
    end;
  end;

  procedure TryPayByOrderNumber;
  var
    OrderCriteria: TOrderInvoiceItemsCriteria;
  begin
    // ���� ����� � ������� ����
    OrderCriteria := GetOrderCriteria(YearOf(Now));
    OrderCriteria.PayType := Incomes.PayType;
    InvoiceItemIDs := TOrderInvoiceItems.FindByOrderNumber(Incomes.OrderNumber,
      OrderCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
    if Length(OrderIDs) = 0 then  // ���� � ������� ���� �� ������, �� ���� � ����������
    begin
      OrderCriteria := GetOrderCriteria(YearOf(Now) - 1);
      InvoiceItemIDs := TOrderInvoiceItems.FindByOrderNumber(Incomes.OrderNumber,
        OrderCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
      if Length(OrderIDs) = 0 then  // ���� ����� �� ������, �� ���� �� ����
      begin
        OrderCriteria.DateFilter := '';
        InvoiceItemIDs := TOrderInvoiceItems.FindByOrderNumber(Incomes.OrderNumber,
          OrderCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
      end;
    end;

    if Length(InvoiceItemIDs) > 1 then
    begin
      if not VarIsNull(Incomes.InvoiceNumber) then
      begin
        OrderCriteria.InvoiceNumber := Incomes.InvoiceNumber;
        InvoiceItemIDs := TOrderInvoiceItems.FindByOrderNumber(Incomes.OrderNumber,
          OrderCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
      end;
      if Length(InvoiceItemIDs) = 1 then
      begin
        Incomes.InvoiceID := InvoiceIDs[0];
        DoAddFullPaymentMultiple2(Incomes, InvoiceItemIDs, false);  // ��� ����������
      end
      else
      if Length(InvoiceItemIDs) > 1 then
        RusMessageDlg('������� ����� ����� ������� � ������ ��� ������ � � '
          + VarToStr(Incomes.OrderNumber), mtInformation, [mbOk], 0)
      else
        MessageMissingInvoice;
    end
    else if Length(OrderIDs) = 1 then
    begin
      // ������ ���� �����, ���� ��� ������
      if Length(InvoiceIDs) = 1 then
        Incomes.InvoiceID := InvoiceIDs[0]
      else
        MessageMissingInvoice;

      DoAddFullPaymentMultiple2(Incomes, InvoiceItemIDs, false);  // ��� ����������
    end
    else if Length(OrderIDs) > 1 then  // ���� ������� ��������� ������� � ����� �������
    begin
      if not VarIsNull(Incomes.InvoiceNumber) then  // �������� ����� �� ������ �����
        TryPayByInvoiceNumber('wo.ID_Number = ' + VarToStr(Incomes.OrderNumber))
      else
        RusMessageDlg('������� ��������� ������� � ������� ' + Incomes.OrderNumber, mtError, [mbOk], 0);
        // ��������� ����������� �������������
    end
    else
    begin
      Msg := '����� � ' + VarToStr(Incomes.OrderNumber) + ' �� ������';
      if GetCustomerChecked then
        Msg := Msg + ' ��� ������� ���������';
      RusMessageDlg(Msg, mtError, [mbOk], 0);
      // ��������� ����������� �������������
    end;
  end;

begin
  Result := false;
//  07.03.2021 if AccessManager.CurUser.EditPayments then
  if AccessManager.CurUser.AddPayments then
  begin
    Incomes.DataSet.Append;
    repeat
      Result := FillIncomeProc(Incomes, Params);
      if Result then
      begin
        if Incomes.DataSet.State in [dsInsert, dsEdit] then Incomes.DataSet.Post;
        OK := true;
        Incomes.DataSet.First;
        while not Incomes.DataSet.eof do
        begin
          // ��������� �������� ������� ������� ��� ������ � ������ ����������� ���� ����������,
          // �.�. ����� ������ ���������� ��������� ��� �������� �����������.
          if not GetCustomerChecked then
          begin
            if (NvlInteger(Incomes.OrderNumber) = 0)
              and (Trim(NvlString(Incomes.InvoiceNumber)) = '') then
            begin
              OK := false;
              RusMessageDlg('����������, ������� � ������ ��� �����, ���� �������� ���������', mtError, [mbOk], 0);
              break;
            end
            else
            // ���� ���-�� �������, �� ���� ���������� ���������.
            if NvlInteger(Incomes.OrderNumber) > 0 then
            begin
              InvoiceItemIDs := TOrderInvoiceItems.FindByOrderNumber(Incomes.OrderNumber,
                GetOrderCriteria(YearOf(Now)), OrderCustomerID, OrderIDs, InvoiceIDs);
              OK := false;
              // TODO: ��� ���� �������� ��������.
              if Length(InvoiceItemIDs) = 0 then
                RusMessageDlg('����� � ' + VarToStr(Incomes.OrderNumber) + ' �� ������ ��� ��� ���� �� ��� ��������� ����', mtError, [mbOk], 0)
              else if Length(OrderIDs) > 1 then
                RusMessageDlg('������� ����� ������ ������ � � ' + VarToStr(Incomes.OrderNumber)
                  + '����������, �������� ��� ��� ���������', mtError, [mbOk], 0)
                  // TODO:
              else if (Length(OrderIDs) = 1) and (Length(InvoiceItemIDs) > 1) then
              begin
                RusMessageDlg('������� ����� ����� ������� � ������ ��� ������ � � ' + VarToStr(Incomes.OrderNumber),
                  //+ '�������� ����������� �� ���� ��������?',
                  mtInformation, [mbOk], 0);
                Incomes.FieldCustomerID := OrderCustomerID;
                OK := true;
              end
              else
              begin
                // ������� ��������� ����� �����
                if Length(InvoiceIDs) = 1 then
                  Incomes.InvoiceID := InvoiceIDs[0]
                else if Length(InvoiceIDs) = 0 then
                  MessageMissingInvoice
                else if Length(InvoiceIDs) > 1 then
                  MessageAmbiguousInvoice;
                Incomes.FieldCustomerID := OrderCustomerID;
                OK := true;
              end;
              // ����� ����� ���� ���� �� ������������� ���� ����� if OK?
            end
            else
            if Trim(NvlString(Incomes.InvoiceNumber)) <> '' then
            begin
              // ���� � ������� ����
              InvoiceItemIDs := TOrderInvoiceItems.FindByInvoiceNumber(Trim(Incomes.InvoiceNumber),
                GetInvoiceCriteria(YearOf(Now)), OrderCustomerID, OrderIDs, InvoiceIDs);
              OK := false;

              if Length(InvoiceItemIDs) = 0 then
              begin
                // ���� � ���������� ����
                InvoiceItemIDs := TOrderInvoiceItems.FindByInvoiceNumber(Trim(Incomes.InvoiceNumber),
                  GetInvoiceCriteria(YearOf(Now) - 1), OrderCustomerID, OrderIDs, InvoiceIDs);
                if Length(InvoiceItemIDs) = 0 then
                begin
                  // ���� �� ���� �����
                  InvoiceItemIDs := TOrderInvoiceItems.FindByInvoiceNumber(Trim(Incomes.InvoiceNumber),
                    TOrderInvoiceItemsCriteria.Default, OrderCustomerID, OrderIDs, InvoiceIDs);
                end
              end;

              if Length(InvoiceItemIDs) >= 1 then
              begin
                if Length(OrderIDs) > 1 then
                begin
                  // �� ������
                  RusMessageDlg('������� ����� ������ ������ ��� ����� � � ' + VarToStr(Incomes.InvoiceNumber),
                    mtInformation, [mbOk], 0);
                end;
                Incomes.FieldCustomerID := OrderCustomerID;
                OK := true;
              end
              else
                MessageInvoiceNotFound(VarToStr(Incomes.InvoiceNumber));

              // ������� ��������� ����� �����
              if OK then
              begin
                if Length(InvoiceIDs) = 1 then
                  Incomes.InvoiceID := InvoiceIDs[0]
                else if Length(InvoiceIDs) = 0 then
                  MessageMissingInvoice
                else if Length(InvoiceIDs) > 1 then
                  MessageAmbiguousInvoice;
              end;
            end;
          end
          else
            Incomes.FieldCustomerID := GetCustomerFunc;

          if Incomes.IncomeGrn = 0 then
          begin
            OK := false;
            RusMessageDlg('�������, ����������, ����� �����������', mtError, [mbOk], 0);
            break;
          end;
          if Incomes.PayType = 0 then
          begin
            OK := false;
            RusMessageDlg('�������, ����������, ��� ������', mtError, [mbOk], 0);
            break;
          end;
          if Incomes.IncomeDate = 0 then
          begin
            OK := false;
            RusMessageDlg('�������, ����������, ���� �����������', mtError, [mbOk], 0);
            break;
          end;
          Incomes.DataSet.Next;
        end;
      end
      else
        Exit;
    until OK;

    Incomes.ApplyUpdates;
    // ���������� ����� ����� �����������
    SetLength(NewKeys, Incomes.ItemIds.Count);
    for I := 0 to Incomes.ItemIds.Count - 1 do
      NewKeys[i] := Incomes.ItemIds[i].NewID;

    if Length(NewKeys) > 0 then
      NewItemID := NewKeys[Length(NewKeys) - 1]; // ����� ���������

    Incomes.Criteria.IncomeIDs := NewKeys;
    Incomes.Reload;

    // ������������� �������� ����������� �� �������� �����, ���� ������ ����� ������,
    // ��� ����� ����������� ������ ��� ���� �������
    CurIncomeID := Incomes.KeyValue;
    Incomes.DataSet.DisableControls;
    try
      Incomes.DataSet.First;
      while not Incomes.DataSet.eof do
      begin
        if NvlInteger(Incomes.InvoiceItemID) > 0 then
        begin
          DoAddFullPayment2(Incomes, Incomes.InvoiceItemID, false);  // ��� ����������
        end
        else
        if not VarIsNull(Incomes.OrderNumber) then
          TryPayByOrderNumber
        else  // �������� �������� �� ����� �����
          if not VarIsNull(Incomes.InvoiceNumber) then
            TryPayByInvoiceNumber('');
        Incomes.DataSet.Next;
      end;
    finally
      Incomes.DataSet.EnableControls;
      Incomes.Locate(CurIncomeID);
    end;

    Incomes.ApplyUpdates;  // ����� ���������� ������ ������

  end else
    ExceptionHandler.Raise_('����������� ����� �� ���������� ��������');
end;

procedure TCustomerPaymentsController.DeleteIncome(Sender: TObject);
var
  Msg: string;
begin
//   if AccessManager.CurUser.EditPayments then
  if AccessManager.CurUser.AddPayments then
  begin
    if Incomes.RestIncome = Incomes.IncomeGrn then
      Msg := '����������� ����� �������. �� �������?'  // �� ���������
    else
      Msg := '����������� � ��� ��������������� ������ ����� �������. �� �������?';
    if RusMessageDlg(Msg, mtConfirmation, mbYesNoCancel, 0) = mrYes then
    begin
      Incomes.DataSet.Delete;
      Incomes.ApplyUpdates;
      RefreshData;
    end;
  end else
    ExceptionHandler.Raise_('����������� ����� �� ���������� ��������');
end;

function TCustomerPaymentsController.FindInvoiceID(InvoiceNum: string; PayType: integer): integer;
var
  Keys: TIntArray;
  Inv: TInvoices;
  InvFilterObj: TInvoicesFilterObj;
begin
  Keys := TInvoices.FindByInvoiceNum(InvoiceNum, YearOf(Now), null, PayType);
  if Length(Keys) = 0 then
  begin
    // ���� �� ������ � ������� ����, �� ����������� �� ���� ��� ����� � ����� �������
    // � ����� ������, � ������������ ������ �������
    InvFilterObj := TInvoicesFilterObj.Create;
    try
      Inv := TInvoices.Create;
      try
        Inv.Criteria := InvFilterObj;
        InvFilterObj.InvoiceNum := InvoiceNum;
        InvFilterObj.PayTypeCode := PayType;
        Inv.Reload;
        Result := 0;
        if Inv.RecordCount > 0 then
        begin
          if ExecSelectInvoiceForm(Inv) then
            Result := Inv.KeyValue
        end;
      finally
        Inv.Free;
      end;
    finally
      InvFilterObj.Free;
    end;
  end else
    Result := Keys[0];

  if Result <= 0 then
    RusMessageDlg('���� � ' + InvoiceNum + ' �� ������ ��� ���������� ���� ������.',
      mtError, [mbOk], 0);
end;

function OneItemArray(i: integer): TIntArray;
begin
  SetLength(Result, 1);
  Result[0] := i;
end;

procedure TCustomerPaymentsController.EditPayments(Sender: TObject);
var
  OrderPayments: TCustomerPayments;
  NewIncomes: TCustomerIncomes;
  cr: TCustomerPaymentsCriteria;
  LocateIncomeID: variant;
  FilterObj: TPaymentsFilterObj;
begin
  if not FOrders.IsEmpty then
  begin
    OrderPayments := TCustomerPayments.Create; // ���������� ������ ��� ������� ������
    cr.OrderID := FOrders.KeyValue;
    OrderPayments.Criteria := cr;
    OrderPayments.Open;
    try
      LocateIncomeID := null;
      if ExecOrderPaymentsDialog(OrderPayments, LocateIncomeID)
        and AccessManager.CurUser.AddPayments
// 07.03.2021        and AccessManager.CurUser.EditPayments
        then
      begin
        if OrderPayments.HasChanges then
        begin
          OrderPayments.ApplyUpdates;  // ����� �� ������ ����� ���� �������
          FOrders.Reload;
          FIncomes.Reload;
        end;
        // ���� ������� �������� � ����������� 
        if NvlInteger(LocateIncomeID) > 0 then
        begin
          if FIncomes.Locate(LocateIncomeID) then
            DoEditIncome(Incomes)
          else
          begin
            // ������� ����� ������ �����, ���� � ������� �� �����
            NewIncomes := TCustomerIncomes.Create;
            try
              FilterObj := TPaymentsFilterObj.Create;
              try
                // ���� ���������� �����������
                FilterObj.IncomeIDs := OneItemArray(LocateIncomeID);
                NewIncomes.Criteria := FilterObj;
                NewIncomes.Reload;
                DoEditIncome(NewIncomes);
              finally
                FilterObj.Free;
              end;
            finally
              NewIncomes.Free;
            end;
          end;
        end;
      end;
    finally
      OrderPayments.Free;
    end;
  end;
end;

procedure TCustomerPaymentsController.EditIncome(Sender: TObject);
begin
  DoEditIncome(Incomes);
end;

procedure TCustomerPaymentsController.DoEditIncome(IncomesData: TCustomerIncomes);
var
  IncomePayments: TCustomerPayments;
  cr: TCustomerPaymentsCriteria;
  OK: boolean;
  InvoiceID: variant;
begin
// 07.03.2021  if AccessManager.CurUser.EditPayments then
  if AccessManager.CurUser.AddPayments then
  begin
    if not IncomesData.IsEmpty then
    begin
      IncomePayments := TCustomerPayments.Create; // ���������� ������ ��� ������� �����������
      cr.IncomeID := IncomesData.KeyValue;
      IncomePayments.Criteria := cr;
      try
        IncomePayments.CustomerID := 0;
        IncomesData.InvoiceNumber := IncomesData.IncomeInvoiceNumber;
        OK := ExecCustomerIncomeDialog(IncomesData, IncomePayments);
        if OK then
        begin
          if not VarIsNull(IncomesData.InvoiceNumber) then
          begin
            if Trim(IncomesData.InvoiceNumber) = '' then
            begin
              InvoiceID := null;
              OK := true;
            end
            else
            begin
              InvoiceID := FindInvoiceID(IncomesData.InvoiceNumber, IncomesData.PayType);
              OK := InvoiceID > 0;
            end;
            if OK then
              IncomesData.InvoiceID := InvoiceID;
          end;
        end;
        if OK then
        begin
          IncomePayments.ApplyUpdates;
          IncomesData.ApplyUpdates;
          RefreshData;
        end
        else
        begin
          IncomePayments.CancelUpdates;
          IncomesData.CancelUpdates;
        end;
      finally
        IncomePayments.Free;
      end;
    end;
  end else
    ExceptionHandler.Raise_('����������� ����� �� ���������� ��������');
end;

procedure TCustomerPaymentsController.Activate;
var
  Save_Cursor: TCursor;
begin
  // �� ��������� ���� ��� ������
  if not FEntity.DataSet.Active then
  begin
    Save_Cursor := Screen.Cursor;
    Screen.Cursor := crSQLWait;
    try
      FEntity.Reload;
    finally
      Screen.Cursor := Save_Cursor;  { Always restore to normal }
    end;
  end;
end;

{procedure TCustomerPaymentsView.LoadSettings(AppStorage: TjvCustomAppStorage);
begin
  inherited LoadSettings(AppStorage);
  if FFrame <> nil then // �� ������ ���������
    TCustomerPaymentsFrame(FFrame).LoadSettings;
end;

procedure TCustomerPaymentsView.SaveSettings(AppStorage: TjvCustomAppStorage);
begin
  inherited SaveSettings(AppStorage);
  if FFrame <> nil then // �� ������ ���������
    TCustomerPaymentsFrame(FFrame).SaveSettings;
end;}

function TCustomerPaymentsController.GetFrame: TCustomerPaymentsFrame;
begin
  Result := TCustomerPaymentsFrame(FFrame);
end;

{procedure TCustomerPaymentsView.DoRefresh(Sender: TObject);
begin
  RefreshCustomerPayments;
end;}

procedure TCustomerPaymentsController.UpdateDetails(Sender: TObject);
var
  id: integer;
begin
  if TCustomerPaymentsFrame(FFrame).CustomerChecked
     and (CustomersWithIncome.DataSet.RecordCount > 0) then
    id := CustomersWithIncome.KeyValue
  else
    id := 0;
  FOrders.CustomerID := id;
  FIncomes.CustomerID := id;
  //FPayments.CustomerID := id;
end;

function TCustomerPaymentsController.GetCustomersWithIncome: TCustomersWithIncome;
begin
  Result := Entity as TCustomersWithIncome;
end;

procedure TCustomerPaymentsController.RefreshData;
begin
  inherited;
  UpdateDetails(Self);
end;

procedure TCustomerPaymentsController.SetCustomerID(Value: variant);
begin
  if CustomersWithIncome.KeyValue <> Value then
  begin
    CustomersWithIncome.Locate(Value);
    Frame.CustomerID := Value;
    //UpdateDetails(Self);
  end;
end;

function TCustomerPaymentsController.GetCustomerID: variant;
begin
  Result := Frame.CustomerID;
end;

procedure TCustomerPaymentsController.FilterChange;
begin
  //CustomersWithIncome.SetViewRange(false);
  //Incomes.SetViewRange(false);
  //FOrders.SetViewRange(false);
  RefreshData;
end;

procedure TCustomerPaymentsController.DisableFilter;
begin

end;

// ������� �� ��������� �����
procedure TCustomerPaymentsController.GoToOrder(Sender: TObject);
begin
  if not FOrders.IsEmpty then
  begin
    AppController.EditWorkOrder(FOrders.KeyValue);
  end;
end;

procedure TCustomerPaymentsController.SetCustomerChecked(val : boolean);
begin
  TCustomerPaymentsFrame(FFrame).CustomerChecked := val;
end;

function TCustomerPaymentsController.GetToolbar: TjvSpeedbar;
begin
  if FToolbarFrame = nil then
    FToolbarFrame := TPaymentsToolbar.Create(nil);
  Result := FToolbarFrame.Toolbar;
end;

procedure TCustomerPaymentsController.PrintOrders(Sender: TObject);
begin
  ScriptManager.ExecOrderEvent(nil, TScriptManager.PrintPaymentOrders);
end;

procedure TCustomerPaymentsController.PrintIncomes(Sender: TObject);
begin
  ScriptManager.ExecOrderEvent(nil, TScriptManager.PrintPaymentIncomes);
end;

procedure TCustomerPaymentsController.PrintReport(ReportKey: integer; AllowInside: boolean);
begin
  ScriptManager.ExecExcelReport(ReportKey);
end;

type
  TIncomeParams = record
    PayType: integer;
    IncomeGrn: extended;
    InvoiceItemID, InvoiceID: integer;
    PayDate: TDateTime;
    InvoiceNumber: string;
  end;

function FillIncomeData(_IncomeData: TCustomerIncomes; Params: pointer): boolean;
begin
  _IncomeData.PayType := TIncomeParams(Params^).PayType;
  _IncomeData.IncomeGrn := TIncomeParams(Params^).IncomeGrn;
  _IncomeData.InvoiceItemID := TIncomeParams(Params^).InvoiceItemID;
  _IncomeData.IncomeDate := TIncomeParams(Params^).PayDate;
  _IncomeData.InvoiceID := TIncomeParams(Params^).InvoiceID;
  _IncomeData.InvoiceNumber := TIncomeParams(Params^).InvoiceNumber;
  Result := ExecAddIncomesDialog(_IncomeData, Params);
  //Result := true;
end;

class function TCustomerPaymentsController.DoAddIncome(FillIncomeFunc: TFillIncomeFunc;
  GetCustomerFunc: TGetIntFunc; Params: pointer; var NewItemID: variant): boolean;
var
  TempIncomes: TCustomerIncomes;
  PCriteria: TPaymentsFilterObj;
begin
  // Create Empty CustomerIncomes
  TempIncomes := TCustomerIncomes.Create;
  PCriteria := TPaymentsFilterObj.Create;
  PCriteria.IncomeIDs := OneItemArray(0);
  TempIncomes.Criteria := PCriteria;
  try
    TempIncomes.Open;
    Result := DoAddIncome2(TempIncomes, FillIncomeFunc, GetCustomerFunc, Params, NewItemID);
  finally
    FreeAndNil(TempIncomes);
    FreeAndNil(PCriteria);
  end;
end;

class procedure TCustomerPaymentsController.PayInvoice(_InvoiceID: integer);
var
  _PayerID, _CustomerID: integer;
  ParamsRec: TIncomeParams;
  InvoiceData: TInvoices;
  InvoiceCriteria: TInvoicesFilterObj;
  NewItemID: variant;
begin
  InvoiceData := TInvoices.Create;
  InvoiceCriteria := TInvoicesFilterObj.Create;
  InvoiceData.Criteria := InvoiceCriteria;
  InvoiceCriteria.InvoiceID := _InvoiceID;
  try
    InvoiceData.Open;
    if not InvoiceData.IsEmpty then
    begin
      {_CustomerID := InvoiceData.CustomerID;
      // ������ �� ���������, �� �������� ��������� ����
      if not CustomerChecked or (CustomerID <> _CustomerID) then
      begin
        CustomerID := _CustomerID;
        CustomerChecked := true;
        UpdateDetails(Self);
      end;
      InstantUpdateInvoices;}
      if InvoiceData.InvoiceDebt > 0 then
      begin
        ParamsRec.PayType := InvoiceData.PayType;
        ParamsRec.IncomeGrn := InvoiceData.InvoiceDebt;
        ParamsRec.PayDate := Now;
        ParamsRec.InvoiceID := _InvoiceID;
        ParamsRec.InvoiceNumber := InvoiceData.InvoiceNum;
        ParamsRec.InvoiceItemID := 0;
        DoAddIncome(FillIncomeData, nil, @ParamsRec, NewItemID);
      end
      else
        ExceptionHandler.Raise_('����� ������ �������');
    end
    else
      ExceptionHandler.Raise_('���� �� ������');
  finally
    InvoiceData.Free;
    InvoiceCriteria.Free;
  end;
end;

class procedure TCustomerPaymentsController.PayInvoiceItem(_InvoiceItemID, _CustomerID: integer);
var
  _OrderID, _PayerID, _InvoiceID, _PayType: integer;
  ParamsRec: TIncomeParams;
  cr: TOrderInvoiceItemsCriteria;
  TempOrderInvoiceItems: TOrderInvoiceItems;
  NewItemID: variant;
begin
  if TOrderInvoiceItems.FindByID(_InvoiceItemID, _OrderID, _PayerID, _InvoiceID) then
  begin
    // ������ �� ���������, �� �������� �������� �����
    {if not CustomerChecked or (CustomerID <> _CustomerID) then
    begin
      CustomerID := _CustomerID;
      CustomerChecked := true;
      UpdateDetails(Self);
    end;}
    //if FOrders.Locate(_OrderID) then
    //begin
      TempOrderInvoiceItems := TOrderInvoiceItems.Create;
      try
        cr := TOrderInvoiceItemsCriteria.Default;
        cr.OrderID := NvlInteger(_OrderID);
        cr.Mode := TOrderInvoiceItemsCriteria.Mode_Normal;
        TempOrderInvoiceItems.Criteria := cr;
        TempOrderInvoiceItems.Reload;

        //InstantUpdateInvoices;
        if TempOrderInvoiceItems.Locate(_InvoiceItemID) then
        begin
          if TempOrderInvoiceItems.ItemDebt > 0 then
          begin
            ParamsRec.PayType := TempOrderInvoiceItems.PayType;
            ParamsRec.IncomeGrn := TempOrderInvoiceItems.ItemDebt;
            ParamsRec.InvoiceItemID := _InvoiceItemID;
            ParamsRec.PayDate := Now;
            ParamsRec.InvoiceID := _InvoiceID;
            ParamsRec.InvoiceNumber := TempOrderInvoiceItems.InvoiceNumber;
            DoAddIncome(FillIncomeData, nil, @ParamsRec, NewItemID);
          end
          else
            ExceptionHandler.Raise_('����� ������ �������');
        end
        else
          ExceptionHandler.Raise_('���� �� ������');
      finally
        FreeAndNil(TempOrderInvoiceItems);
      end;
    //end
    //else
    //  ExceptionHandler.Raise_('����� �� ������');
  end;
end;

end.
