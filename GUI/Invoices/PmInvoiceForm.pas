unit PmInvoiceForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseEditForm, JvComponentBase, JvFormPlacement, StdCtrls, DBCtrls,
  Buttons, JvExControls, JvDBLookup, JvExMask, JvToolEdit, JvMaskEdit,
  JvCheckedMaskEdit, JvDatePickerEdit, JvDBDatePickerEdit, Mask,

  NotifyEvent, PmInvoice, DB, GridsEh, DBGridEh, MyDBGridEh, DBGridEhGrouping;

type
  TInvoiceForm = class(TBaseEditForm)
    Label1: TLabel;
    edInvoiceNum: TDBEdit;
    deInvoiceDate: TJvDBDatePickerEdit;
    Label2: TLabel;
    Label3: TLabel;
    lkCustomer: TJvDBLookupCombo;
    btNewCust: TSpeedButton;
    Label4: TLabel;
    memoNotes: TDBMemo;
    lkPayType: TJvDBLookupCombo;
    Label5: TLabel;
    dsPayType: TDataSource;
    dgInvoiceItems: TMyDBGridEh;
    btNewItem: TBitBtn;
    btEditItem: TBitBtn;
    btDelItem: TBitBtn;
    Label6: TLabel;
    edUserName: TDBEdit;
    Label7: TLabel;
    btPayItem: TBitBtn;
    dsCust: TDataSource;
    procedure btNewCustClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btNewItemClick(Sender: TObject);
    procedure btEditItemClick(Sender: TObject);
    procedure btDelItemClick(Sender: TObject);
    procedure btPayItemClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FInvoices: TInvoices;
    FOnAddItem: TNotifyEvent;
    FOnEditItem: TNotifyEvent;
    FOnRemoveItem: TNotifyEvent;
    //FOnPayItem: TNotifyEvent;
    FItemsAfterScrollID: TNotifyHandlerID;
    FInvoiceItemIDToPay: variant;
    procedure SetInvoices(Value: TInvoices);
  protected
    function ValidateForm: boolean; override;
    procedure ItemsAfterScroll(Sender: TObject);
  public
    property Invoices: TInvoices read FInvoices write SetInvoices;
    property OnAddItem: TNotifyEvent read FOnAddItem write FOnAddItem;
    property OnEditItem: TNotifyEvent read FOnEditItem write FOnEditItem;
    property OnRemoveItem: TNotifyEvent read FOnRemoveItem write FOnRemoveItem;
    // property OnPayItem: TNotifyEvent read FOnPayItem write FOnPayItem;
    // НЕ используется
    // property InvoiceItemIDToPay: variant read FInvoiceItemIDToPay;
  end;

// Отображает форму создания счета.
function ExecNewInvoiceForm(Invoices: TInvoices; _OnAddItem,
  _OnEditItem, _OnRemoveItem, _OnPayItem: TNotifyEvent): boolean;

// Отображает форму редактирования счета.
function ExecEditInvoiceForm(Invoices: TInvoices; _OnAddItem,
  _OnEditItem, _OnRemoveItem, _OnPayItem: TNotifyEvent): boolean;

implementation

{$R *.dfm}

uses RDBUtils, PmContragent, MainData, PmContragentListForm, StdDic,
  PmConfigManager;

function ExecNewInvoiceForm(Invoices: TInvoices; _OnAddItem,
  _OnEditItem, _OnRemoveItem, _OnPayItem: TNotifyEvent): boolean;
begin
  Result := ExecEditInvoiceForm(Invoices, _OnAddItem, _OnEditItem, _OnRemoveItem, _OnPayItem);
end;

function ExecEditInvoiceForm(Invoices: TInvoices; _OnAddItem,
  _OnEditItem, _OnRemoveItem, _OnPayItem: TNotifyEvent): boolean;
var
  InvoiceForm: TInvoiceForm;
begin
  Application.CreateForm(TInvoiceForm, InvoiceForm);
  try
    InvoiceForm.Invoices := Invoices;
    InvoiceForm.OnAddItem := _OnAddItem;
    InvoiceForm.OnEditItem := _OnEditItem;
    InvoiceForm.OnRemoveItem := _OnRemoveItem;
    Result := InvoiceForm.ShowModal = mrOk;
    {if Result and not VarIsNull(InvoiceForm.InvoiceItemIDToPay) then
      _OnPayItem(nil);}
  finally
    FreeAndNil(InvoiceForm);
  end;
end;

procedure TInvoiceForm.btDelItemClick(Sender: TObject);
begin
  FOnRemoveItem(Self);
end;

procedure TInvoiceForm.btEditItemClick(Sender: TObject);
begin
  FOnEditItem(Self);
end;

procedure TInvoiceForm.btNewCustClick(Sender: TObject);
var
  i: integer;
begin
  i := NvlInteger(lkCustomer.KeyValue);
  if i = 0 then i := TContragents.NoNameKey;
  i := ExecContragentSelect(Customers, {CurCustomer=} i, {SelectMode} true);
  if i = custNoName then i := TContragents.NoNameKey;
  if (i <> custError) and (i <> custCancel) then
    lkCustomer.KeyValue := i;
end;

procedure TInvoiceForm.btNewItemClick(Sender: TObject);
begin
  FOnAddItem(Self);
end;

procedure TInvoiceForm.btPayItemClick(Sender: TObject);
begin
  FInvoiceItemIDToPay := FInvoices.Items.KeyValue;
  //FOnPayItem(Self);
end;

procedure TInvoiceForm.FormCreate(Sender: TObject);
begin
  // обновляет, если надо
  Customers.Reload;
  //lkCustomer.LookupSource := dm.dsCust;
  dsCust.DataSet := Customers.DataSet;
  dsPayType.DataSet := TConfigManager.Instance.StandardDics.dePayKind.DicItems;
  FInvoiceItemIDToPay := null;
end;

procedure TInvoiceForm.FormDestroy(Sender: TObject);
begin
  if FItemsAfterScrollID <> TNotifier.EmptyID then
  begin
    FInvoices.Items.AfterScrollNotifier.UnregisterHandler(FItemsAfterScrollID);
    FItemsAfterScrollID := '';
  end;
end;

procedure TInvoiceForm.SetInvoices(Value: TInvoices);
begin
  FInvoices := Value;
  edInvoiceNum.DataSource := FInvoices.DataSource;
  deInvoiceDate.DataSource := FInvoices.DataSource;
  lkCustomer.DataSource := FInvoices.DataSource;
  memoNotes.DataSource := FInvoices.DataSource;
  lkPayType.DataSource := FInvoices.DataSource;
  edUserName.DataSource := FInvoices.DataSource;
  dgInvoiceItems.DataSource := FInvoices.Items.DataSource;
  if FItemsAfterScrollID <> TNotifier.EmptyID then
  begin
    FInvoices.Items.AfterScrollNotifier.UnregisterHandler(FItemsAfterScrollID);
    FItemsAfterScrollID := '';
  end;
  FItemsAfterScrollID := FInvoices.Items.AfterScrollNotifier.RegisterHandler(ItemsAfterScroll);
  //lkPayType.ReadOnly := NvlInteger(FInvoices.KeyValue) > 0;
end;

function TInvoiceForm.ValidateForm: boolean;
begin
  ActiveControl := btOk;
  Result := Trim(NvlString(FInvoices.InvoiceNum)) <> '';
  if not Result then
  begin
    ActiveControl := edInvoiceNum;
    raise Exception.Create('Пожалуйста, укажите номер счета');
  end
  else
  begin
    Result := NvlDateTime(FInvoices.InvoiceDate) <> 0;
    if not Result then
    begin
      ActiveControl := deInvoiceDate;
      raise Exception.Create('Пожалуйста, укажите дату счета');
    end
    else
    begin
      Result := not VarIsNull(lkCustomer.KeyValue);
      if not Result then
      begin
        ActiveControl := lkCustomer;
        raise Exception.Create('Пожалуйста, укажите заказчика');
      end
      else
        begin
        Result := not VarIsNull(lkPayType.KeyValue);
        if not Result then
        begin
          ActiveControl := lkPayType;
          raise Exception.Create('Пожалуйста, укажите вид оплаты');
        end;
      end;
    end;
  end;
end;

procedure TInvoiceForm.ItemsAfterScroll(Sender: TObject);
begin
  btEditItem.Enabled := not FInvoices.Items.IsEmpty;
  btDelItem.Enabled := btEditItem.Enabled;
  // Разрешает оплачивать только сохраненные
  btPayItem.Enabled := btEditItem.Enabled and (NvlInteger(FInvoices.Items.KeyValue) > 0);
end;

end.
