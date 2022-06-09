unit fCustomerPayments;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, MyDBGridEh, ExtCtrls, ComCtrls, Buttons, Mask, 
  StdCtrls, DBCtrls,

  JvFormPlacement, JvSpeedbar,
  JvExExtCtrls, JvExtComponent, DBCtrlsEh, DBLookupEh, JvNetscapeSplitter,

  NotifyEvent, PmCustomerPayments, PmCustomersWithIncome, fBaseFrame,
  fBaseFilter, PmOrderInvoiceItems, DBGridEhGrouping;

type
  TCustomerPaymentsFrame = class(TBaseFrame)
    paCustomerFilter: TPanel;
    comboCustomer: TDBLookupComboboxEh;
    paInvoiceTotal: TPanel;
    paRestIncomeText: TPanel;
    Label3: TLabel;
    dtInvoiceTotal: TDBText;
    dtToPayGrn: TDBText;
    Label4: TLabel;
    Label5: TLabel;
    cbCustomer: TCheckBox;
    Bevel1: TBevel;
    MyDBGridEh1: TMyDBGridEh;
    Panel1: TPanel;
    Panel2: TPanel;
    spOrders: TJvNetscapeSplitter;
    paOrders: TPanel;
    splitterInvoiceItems: TJvNetscapeSplitter;
    dgOrders: TMyDBGridEh;
    paHdrOrder: TPanel;
    Label1: TLabel;
    Label6: TLabel;
    btPayAll: TBitBtn;
    btPayPart: TBitBtn;
    btGoToOrder: TBitBtn;
    edInvoice: TEdit;
    paInvoiceItems: TPanel;
    Panel4: TPanel;
    dgIncomes: TMyDBGridEh;
    Panel5: TPanel;
    Label2: TLabel;
    btAdd: TBitBtn;
    btDelete: TBitBtn;
    btEdit: TBitBtn;
    dgOrderInvoiceItems: TMyDBGridEh;
    OrderTimer: TTimer;
    dtRestIncome: TDBText;
    procedure btPayAllClick(Sender: TObject);
    procedure siAddIncomeClick(Sender: TObject);
    procedure siDeleteIncomeClick(Sender: TObject);
    procedure siEditIncomeClick(Sender: TObject);
    procedure comboCustomerCloseUp(Sender: TObject; Accept: Boolean);
    procedure dgOrdersColumnsOrdersToPayGetCellParams(Sender: TObject; EditMode: Boolean;
      Params: TColCellParamsEh);
    procedure btPayPartClick(Sender: TObject);
    procedure btGoToOrderClick(Sender: TObject);
    procedure dgIncomesRestIncomeGetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure comboCustomerKeyValueChanged(Sender: TObject);
    procedure cbCustomerClick(Sender: TObject);
    procedure edInvoiceChange(Sender: TObject);
    procedure dgOrderInvoiceItemsColumns5GetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure dgIncomesDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure dgOrdersDblClick(Sender: TObject);
    procedure dgIncomesColumns0GetCellParams(Sender: TObject; EditMode: Boolean;
      Params: TColCellParamsEh);
  private
    //FCustomersWithIncome: TCustomersWithIncome;
    FOrders: TCustomerOrders;
    //FPayments: TCustomerPayments;
    FIncomes: TCustomerIncomes;
    FOrderInvoiceItems: TOrderInvoiceItems;
    FOnAddIncome: TNotifyEvent;
    FOnAddFullPayment: TNotifyEvent;
    FOnAddPartialPayment: TNotifyEvent;
    FOnDeleteIncome: TNotifyEvent;
    FOnEditIncome: TNotifyEvent;
    FOnEditPayments: TNotifyEvent; 
    FCustomerChanged: TNotifyEvent;
    FOnGoToOrder: TNotifyEvent;
    {FCustomersOpenID, FOrdersOpenID,} FIncomesOpenID1, FIncomesOpenID2,
    {FCustomersAfterScrollID, }FIncomesAfterScrollID: TNotifyHandlerID;
    FOrdersAfterScrollID: TNotifyHandlerID;
    FOrderInvoiceItemsAfterScrollID: TNotifyHandlerID;
    FOrderInvoiceItemsOpenID: TNotifyHandlerID;
    FKeyValueChanged: boolean;
    //procedure UpdateCustomerControls(Sender: TObject);
    FUpdatingControls: boolean;
    procedure UpdateOrderControls(Sender: TObject);
    procedure UpdateIncomeControls(Sender: TObject);
    procedure SetCustomerID(Value: variant);
    function GetCustomerID: variant;
    function GetCustomerChecked: boolean;
    procedure SetCustomerChecked(Val: boolean);
  protected
    function CustomersWithIncome: TCustomersWithIncome;
  public
    constructor Create(Owner: TComponent;
      _CustomersWithIncome: TCustomersWithIncome;
      _CustomerOrders: TCustomerOrders;
      //_CustomerPayments: TCustomerPayments;
      _CustomerIncomes: TCustomerIncomes;
      _OrderInvoiceItems: TOrderInvoiceItems);
    destructor Destroy; override;

    procedure SaveSettings; override;
    procedure LoadSettings; override;
    function CreateFilterFrame: TBaseFilterFrame; override;

    // События
    property OnAddFullPayment: TNotifyEvent read FOnAddFullPayment write FOnAddFullPayment;
    property OnAddPartialPayment: TNotifyEvent read FOnAddPartialPayment write FOnAddPartialPayment;
    property OnAddIncome: TNotifyEvent read FOnAddIncome write FOnAddIncome;
    property OnDeleteIncome: TNotifyEvent read FOnDeleteIncome write FOnDeleteIncome;
    property OnEditIncome: TNotifyEvent read FOnEditIncome write FOnEditIncome;
    property OnEditPayments: TNotifyEvent read FOnEditPayments write FOnEditPayments;
    property CustomerChanged: TNotifyEvent read FCustomerChanged write FCustomerChanged;
    property OnGoToOrder: TNotifyEvent read FOnGoToOrder write FOnGoToOrder;

    property CustomerID: variant read GetCustomerID write SetCustomerID;
    property CustomerChecked: boolean read GetCustomerChecked write SetCustomerChecked;
  end;

implementation

{$R *.dfm}

uses JvJVCLUtils, CalcUtils, CalcSettings, MainFilter, PmUtils, fPaymentsFilter,
  PmAccessManager;

procedure TCustomerPaymentsFrame.cbCustomerClick(Sender: TObject);
begin
  comboCustomer.Enabled := cbCustomer.Checked;
  btAdd.Enabled := cbCustomer.Checked;
  dgOrders.FieldColumns[TCustomerOrders.F_CustomerName].Visible := not cbCustomer.Checked;
  if not FUpdatingControls then
    FCustomerChanged(Self);
end;

procedure TCustomerPaymentsFrame.comboCustomerCloseUp(Sender: TObject;
  Accept: Boolean);
begin
  comboCustomer.KeyValue := CustomersWithIncome.KeyValue;
  //UpdateCustomerControls(nil);  т.к. на afterscroll реагирует
  FCustomerChanged(Self);
end;

procedure TCustomerPaymentsFrame.comboCustomerKeyValueChanged(Sender: TObject);
begin
  if not FKeyValueChanged then
  begin
    FKeyValueChanged := true;
    try
      FCustomerChanged(Self);
    finally
      FKeyValueChanged := false;
    end;
  end;
end;

constructor TCustomerPaymentsFrame.Create(Owner: TComponent;
  _CustomersWithIncome: TCustomersWithIncome;
  _CustomerOrders: TCustomerOrders;
  //_CustomerPayments: TCustomerPayments;
  _CustomerIncomes: TCustomerIncomes;
  _OrderInvoiceItems: TOrderInvoiceItems);
begin
  inherited Create(Owner, _CustomersWithIncome{'CustomerPayments'});
  //FCustomersWithIncome := _CustomersWithIncome;
  FOrders := _CustomerOrders;
  //FPayments := _CustomerPayments;
  FIncomes := _CustomerIncomes;
  FOrderInvoiceItems := _OrderInvoiceItems;

  FilterObject := CustomersWithIncome.Criteria;
  FilterFrame.Entity := CustomersWithIncome;

  comboCustomer.ListSource := CustomersWithIncome.DataSource;
  dgIncomes.DataSource := FIncomes.DataSource;
  dgOrders.DataSource := FOrders.DataSource;
  dtInvoiceTotal.DataSource := CustomersWithIncome.DataSource;
  dtToPayGrn.DataSource := CustomersWithIncome.DataSource;
  dtRestIncome.DataSource := FIncomes.DataSource;//FCustomersWithIncome.DataSource;
  dgOrderInvoiceItems.DataSource := FOrderInvoiceItems.DataSource;

  // обработчики событий
  //FCustomersOpenID := FCustomersWithIncome.OpenNotifier.RegisterHandler(UpdateCustomerControls);
  //FCustomersAfterScrollID := FCustomersWithIncome.AfterScrollNotifier.RegisterHandler(UpdateCustomerControls);
  //FOrdersOpenID := FOrders.OpenNotifier.RegisterHandler(UpdateOrderControls);
  FOrdersAfterScrollID := FOrders.AfterScrollNotifier.RegisterHandler(UpdateOrderControls);
  // два обработчика
  FIncomesOpenID1 := FIncomes.OpenNotifier.RegisterHandler(UpdateIncomeControls);
  FIncomesOpenID2 := FIncomes.OpenNotifier.RegisterHandler(UpdateOrderControls);
  FIncomesAfterScrollID := FIncomes.AfterScrollNotifier.RegisterHandler(UpdateOrderControls);
  FOrderInvoiceItemsAfterScrollID := FOrderInvoiceItems.AfterScrollNotifier.RegisterHandler(UpdateOrderControls);
  FOrderInvoiceItemsOpenID := FOrderInvoiceItems.OpenNotifier.RegisterHandler(UpdateOrderControls);

  TSettingsManager.Instance.XPInitComponent(edInvoice);
  TSettingsManager.Instance.XPInitComponent(btPayAll);
  TSettingsManager.Instance.XPInitComponent(btPayPart);
  TSettingsManager.Instance.XPInitComponent(btAdd);
  TSettingsManager.Instance.XPInitComponent(btDelete);
  TSettingsManager.Instance.XPInitComponent(btEdit);
  TSettingsManager.Instance.XPInitComponent(btGoToOrder);
end;

destructor TCustomerPaymentsFrame.Destroy;
begin
  //FCustomersWithIncome.OpenNotifier.UnRegisterHandler(FCustomersOpenID);
  //FCustomersWithIncome.AfterScrollNotifier.UnRegisterHandler(FCustomersAfterScrollID);
  //FOrders.OpenNotifier.UnRegisterHandler(FOrdersOpenID);
  FOrders.AfterScrollNotifier.UnRegisterHandler(FOrdersAfterScrollID);
  FIncomes.OpenNotifier.UnRegisterHandler(FIncomesOpenID1);
  FIncomes.OpenNotifier.UnRegisterHandler(FIncomesOpenID2);
  FIncomes.AfterScrollNotifier.UnRegisterHandler(FIncomesAfterScrollID);
  FOrderInvoiceItems.OpenNotifier.UnRegisterHandler(FOrderInvoiceItemsOpenID);
  FOrderInvoiceItems.AfterScrollNotifier.UnRegisterHandler(FOrderInvoiceItemsAfterScrollID);
  inherited Destroy;
end;

procedure TCustomerPaymentsFrame.dgIncomesColumns0GetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  Params.Text := '';
end;

procedure TCustomerPaymentsFrame.dgIncomesDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  Bmp: TBitmap;
begin
  try
    if (CompareText(Column.FieldName, 'SyncState') = 0) and (Column.Field <> nil) then
    begin
      if VarIsNull(FIncomes.IncomeInvoiceNumber) then
      begin
         // отсутствует счет для поступления
        (Sender as TGridClass).Canvas.FillRect(Rect);
        if not Column.Field.IsNull then
        begin
          Bmp := bmpNoInvoiceForIncome;
          if Bmp <> nil then
            DrawBitmapTransparent((Sender as TGridClass).Canvas,
              (Rect.Right + Rect.Left - bmp.Width) div 2 + 1,
              (Rect.Top + Rect.Bottom - bmp.Height) div 2, bmp, clFuchsia);
        end;
      end
      else
        // рисуем состояние синхронизации
        DrawSyncState(Sender as TGridClass, Column, Rect);
    end;
  except
  end;
end;

procedure TCustomerPaymentsFrame.dgIncomesRestIncomeGetCellParams(
  Sender: TObject; EditMode: Boolean; Params: TColCellParamsEh);
begin
  if FIncomes.RestIncome > 0 then
    Params.Font.Color := clRed
  else
    Params.Font.Color := clWindowText;
end;

procedure TCustomerPaymentsFrame.dgOrderInvoiceItemsColumns5GetCellParams(
  Sender: TObject; EditMode: Boolean; Params: TColCellParamsEh);
begin
  if FOrderInvoiceItems.ItemDebt > 0 then
    Params.Font.Color := clRed
  else
    Params.Font.Color := clWindowText;
end;

procedure TCustomerPaymentsFrame.dgOrdersColumnsOrdersToPayGetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  if FOrders.PayDebtGrn > 0 then
    Params.Font.Color := clRed
  else
    Params.Font.Color := clWindowText;
end;

procedure TCustomerPaymentsFrame.dgOrdersDblClick(Sender: TObject);
begin
  if Assigned(FOnEditPayments) then
    FOnEditPayments(Self);
end;

procedure TCustomerPaymentsFrame.edInvoiceChange(Sender: TObject);
begin
  inherited;
  if edInvoice.Text <> '' then
    FOrders.LocateInvoice(edInvoice.Text);
end;

procedure TCustomerPaymentsFrame.btGoToOrderClick(Sender: TObject);
begin
  FOnGotoOrder(Self);
end;

procedure TCustomerPaymentsFrame.btPayAllClick(Sender: TObject);
begin
  FOnAddFullPayment(Self);
end;

procedure TCustomerPaymentsFrame.btPayPartClick(Sender: TObject);
begin
  FOnAddPartialPayment(Self);
end;

procedure TCustomerPaymentsFrame.siAddIncomeClick(Sender: TObject);
begin
  FOnAddIncome(Self);
end;

procedure TCustomerPaymentsFrame.siDeleteIncomeClick(Sender: TObject);
begin
  FOnDeleteIncome(Self);
end;

procedure TCustomerPaymentsFrame.siEditIncomeClick(Sender: TObject);
begin
  FOnEditIncome(Self);
end;

procedure TCustomerPaymentsFrame.SaveSettings;
begin
  inherited;
  //dgPayments.SaveToAppStore(MainAppStorage, 'CustomerPayments_Payments');
  TSettingsManager.Instance.SaveGridLayout(dgOrders, 'CustomerPayments_Orders');
  TSettingsManager.Instance.SaveGridLayout(dgIncomes, 'CustomerPayments_Incomes');
  TSettingsManager.Instance.SaveGridLayout(dgOrderInvoiceItems, 'CustomerPayments_InvoiceItems');
  TSettingsManager.Instance.Storage.WriteInteger(iniInterface + '\CustomerPayments_paOrdersWidth',
    paOrders.Width);
  TSettingsManager.Instance.Storage.WriteInteger(iniInterface + '\CustomerPayments_paInvoiceItemsHeight',
    paInvoiceItems.Height);
  TSettingsManager.Instance.Storage.WriteInteger(iniInterface + '\CustomerPayments_ByCustomer',
    Ord(cbCustomer.Checked));
end;

procedure TCustomerPaymentsFrame.LoadSettings;
begin
  FUpdatingControls := true;
  try
    inherited;
    //dgPayments.LoadFromAppStore(MainAppStorage, 'CustomerPayments_Payments');
    TSettingsManager.Instance.LoadGridLayout(dgOrders, 'CustomerPayments_Orders');
    TSettingsManager.Instance.LoadGridLayout(dgIncomes, 'CustomerPayments_Incomes');
    TSettingsManager.Instance.LoadGridLayout(dgOrderInvoiceItems, 'CustomerPayments_InvoiceItems');
    paOrders.Width := TSettingsManager.Instance.Storage.ReadInteger(iniInterface + '\CustomerPayments_paOrdersWidth',
      dgOrders.Width);
    paInvoiceItems.Height := TSettingsManager.Instance.Storage.ReadInteger(iniInterface + '\CustomerPayments_paInvoiceItemsHeight',
      paInvoiceItems.Height);
    cbCustomer.Checked := TSettingsManager.Instance.Storage.ReadString(iniInterface + '\CustomerPayments_ByCustomer',
      '1') = '1';
  finally
    FUpdatingControls := false;
  end;
end;

{procedure TCustomerPaymentsFrame.UpdateCustomerControls(Sender: TObject);
begin
  paInvoiceTotal.Caption := 'Выставлено счетов на: ' + FormatFloat(CalcUtils.NumDisplayFmt, FCustomersWithIncome.InvoiceTotal);
  paRestIncomeText.Caption := 'Остаток: ' + FormatFloat(CalcUtils.NumDisplayFmt, FCustomersWithIncome.RestIncome);
  paToPayText.Caption := 'Долг: ' + FormatFloat(CalcUtils.NumDisplayFmt, FCustomersWithIncome.ToPayGrn);
end;}

procedure TCustomerPaymentsFrame.UpdateOrderControls(Sender: TObject);
begin
  if not FIncomes.DataSet.ControlsDisabled then
  begin
    btPayAll.Enabled := not FOrderInvoiceItems.IsEmpty and not FIncomes.IsEmpty
      and FOrderInvoiceItems.Active and (FOrderInvoiceItems.ItemDebt > 0)
      and FIncomes.Active and (FIncomes.RestIncome > 0)
      and (FOrderInvoiceItems.ContragentID = FIncomes.FieldCustomerID)
      and AccessManager.CurUser.AddPayments;
// 07.03.2021      and AccessManager.CurUser.EditPayments;
      //and (FIncomes.PayType = FOrderInvoiceItems.PayType);
    btPayPart.Enabled := btPayAll.Enabled
      and AccessManager.CurUser.AddPayments;
// 07.03.2021      and AccessManager.CurUser.EditPayments;
    btGoToOrder.Enabled := FOrders.Active and not FOrders.IsEmpty;
  end;
end;

procedure TCustomerPaymentsFrame.UpdateIncomeControls(Sender: TObject);
begin
  btAdd.Enabled := FIncomes.Active and AccessManager.CurUser.AddPayments;;   // AccessManager.CurUser.EditPayments;;
  btDelete.Enabled := FIncomes.Active and not FIncomes.IsEmpty and AccessManager.CurUser.AddPayments;; //  and AccessManager.CurUser.EditPayments;
  btEdit.Enabled := btDelete.Enabled;
end;

procedure TCustomerPaymentsFrame.SetCustomerID(Value: variant);
begin
  comboCustomer.KeyValue := Value;
end;

function TCustomerPaymentsFrame.GetCustomerID: variant;
begin
  Result := comboCustomer.KeyValue;
end;

function TCustomerPaymentsFrame.CreateFilterFrame: TBaseFilterFrame;
begin
  Result := TPaymentsFilterFrame.Create(Self);
end;

function TCustomerPaymentsFrame.GetCustomerChecked: boolean;
begin
  Result := cbCustomer.Checked;
end;

procedure TCustomerPaymentsFrame.SetCustomerChecked(Val: boolean);
begin
  cbCustomer.Checked := Val;
end;

function TCustomerPaymentsFrame.CustomersWithIncome: TCustomersWithIncome;
begin
  Result := Entity as TCustomersWithIncome;
end;

end.
