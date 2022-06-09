unit PmInvoiceItemForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseEditForm, JvComponentBase, JvFormPlacement, StdCtrls, DBGridEh,
  Mask, DBCtrlsEh, DBLookupEh, DBCtrls,

  PmInvoiceItems, PmCustomerOrders, Buttons, DB;

type
  TInvoiceItemForm = class(TBaseEditForm)
    Label1: TLabel;
    comboOrder: TDBLookupComboboxEh;
    edQuantity: TDBEdit;
    edItemCost: TDBEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    dtPrice: TDBText;
    cbNotPaidOnly: TCheckBox;
    cbAllCustomers: TCheckBox;
    GroupBox1: TGroupBox;
    edItemText: TDBEdit;
    rbItemText: TRadioButton;
    rbItemCode: TRadioButton;
    comboProducts: TDBLookupComboboxEh;
    dsProducts: TDataSource;
    cbNotInvoicedOnly: TCheckBox;
    procedure comboOrderChange(Sender: TObject);
    procedure cbNotPaidOnlyClick(Sender: TObject);
    procedure cbNotInvoicedOnlyClick(Sender: TObject);
    procedure cbAllCustomersClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure rbItemCodeClick(Sender: TObject);
    procedure comboProductsChange(Sender: TObject);
    //procedure btSelectProductClick(Sender: TObject);
  private
    FInvoiceItems: TInvoiceItems;
    FCustomerOrders: TCustomerInvoiceOrders;
    FSettingsControls: boolean;
    FCustomerID: integer;
    FSelectExternalProduct: boolean;
    procedure SetInvoiceItems(Value: TInvoiceItems);
    procedure SetCustomerOrders(Value: TCustomerInvoiceOrders);
    procedure UpdateControlsState;
  protected
    function ValidateForm: boolean; override;
    procedure UpdateItemText;
  public
    property InvoiceItems: TInvoiceItems read FInvoiceItems write SetInvoiceItems;
    property CustomerOrders: TCustomerInvoiceOrders read FCustomerOrders write SetCustomerOrders;
    property SelectExternalProduct: boolean read FSelectExternalProduct write FSelectExternalProduct;
  end;

function ExecAddInvoiceItemForm(InvoiceItems: TInvoiceItems;
  Orders: TCustomerInvoiceOrders; SelectExternalProduct: boolean): boolean;
function ExecEditInvoiceItemForm(InvoiceItems: TInvoiceItems;
  Orders: TCustomerInvoiceOrders; SelectExternalProduct: boolean): boolean;

implementation

uses RDBUtils, CalcUtils, StdDic, PmSelectExtMatForm, PmConfigManager, PmEntSettings;

{$R *.dfm}

function ExecEditInvoiceItemForm(InvoiceItems: TInvoiceItems; Orders: TCustomerInvoiceOrders;
  SelectExternalProduct: boolean): boolean;
begin
  Result := ExecAddInvoiceItemForm(InvoiceItems, Orders, SelectExternalProduct);
end;

function ExecAddInvoiceItemForm(InvoiceItems: TInvoiceItems; Orders: TCustomerInvoiceOrders;
  SelectExternalProduct: boolean): boolean;
var
  InvoiceItemForm: TInvoiceItemForm;
begin
  Application.CreateForm(TInvoiceItemForm, InvoiceItemForm);
  try
    InvoiceItemForm.InvoiceItems := InvoiceItems;
    InvoiceItemForm.CustomerOrders := Orders;
    InvoiceItemForm.SelectExternalProduct := SelectExternalProduct;
    Result := InvoiceItemForm.ShowModal = mrOk;
  finally
    FreeAndNil(InvoiceItemForm);
  end;
end;

function TInvoiceItemForm.ValidateForm: boolean;
begin
  ActiveControl := btOk;
  Result := NvlInteger(comboOrder.KeyValue) > 0;
  if not Result then
  begin
    ActiveControl := comboOrder;
    raise Exception.Create('ѕожалуйста, укажите заказ');
  end
  else
  begin
    Result := NvlInteger(FInvoiceItems.Quantity) > 0;
    if not Result then
    begin
      ActiveControl := edQuantity;
      raise Exception.Create('ѕожалуйста, укажите количество');
    end
    else
    begin
      Result := NvlFloat(FInvoiceItems.ItemCost) > 0;
      if not Result then
      begin
        ActiveControl := edItemCost;
        raise Exception.Create('ѕожалуйста, укажите стоимость');
      end
      else
      begin
        // ≈сли требуетс€ выбор номенклатуры, то провер€ем, выбрана ли
        if SelectExternalProduct then
        begin
          Result := not VarIsNull(FInvoiceItems.ExternalProductID);
          if not Result then
          begin
            rbItemCode.Checked := true;
            ActiveControl := comboProducts;
            raise Exception.Create('ѕожалуйста, укажите номенклатуру позиции');
          end;
        end
        else
        begin
          Result := Trim(NvlString(FInvoiceItems.ItemText)) <> '';
          if not Result then
          begin
            rbItemText.Checked := true;
            ActiveControl := edItemText;
            raise Exception.Create('ѕожалуйста, укажите номенклатуру позиции');
          end;
        end;
      end;
    end;
  end;
end;

procedure TInvoiceItemForm.SetInvoiceItems(Value: TInvoiceItems);
begin
  FInvoiceItems := Value;
  edItemText.DataSource := FInvoiceItems.DataSource;
  edQuantity.DataSource := FInvoiceItems.DataSource;
  edItemCost.DataSource := FInvoiceItems.DataSource;
  comboOrder.DataSource := FInvoiceItems.DataSource;
  dtPrice.DataSource := FInvoiceItems.DataSource;
  comboProducts.DataSource := FInvoiceItems.DataSource;
  UpdateItemText;
end;

{procedure TInvoiceItemForm.btSelectProductClick(Sender: TObject);
var
  ExtProductID: variant;
begin
  ExtProductID := FInvoiceItems.ExternalProductID;
  if ExecSelectExternalDictionaryForm(ExtProductID, TConfigManager.Instance.StandardDics.deExternalProducts, '') then
  begin
    FInvoiceItems.ExternalProductID := ExtProductID;
    if not VarIsNull(FInvoiceItems.ExternalProductID) then
      FInvoiceItems.ItemText := TConfigManager.Instance.StandardDics.deExternalProducts.CurrentName;
    UpdateItemText;
  end;
end;}

procedure TInvoiceItemForm.UpdateItemText;
begin
  rbItemText.Checked := VarIsNull(FInvoiceItems.ExternalProductID);
  edItemText.Enabled := rbItemText.Checked;
  comboProducts.Enabled := not rbItemText.Checked;
  //edItemText.Enabled := VarIsNull(FInvoiceItems.ExternalProductID);
end;

procedure TInvoiceItemForm.cbAllCustomersClick(Sender: TObject);
var
  Criteria: TCustomerInvoiceOrdersCriteria;
begin
  if not FSettingsControls then
  begin
    Criteria := FCustomerOrders.Criteria;
    if cbAllCustomers.Checked then
      Criteria.CustomerID := 0
    else
      Criteria.CustomerID := FCustomerID;
    FCustomerOrders.Criteria := Criteria;
    FCustomerOrders.Reload;
  end;
end;

procedure TInvoiceItemForm.cbNotPaidOnlyClick(Sender: TObject);
var
  Criteria: TCustomerInvoiceOrdersCriteria;
begin
  if not FSettingsControls then
  begin
    Criteria := FCustomerOrders.Criteria;
    Criteria.NotPaidOnly := cbNotPaidOnly.Checked;
    FCustomerOrders.Criteria := Criteria;
    FCustomerOrders.Reload;
  end;
end;

procedure TInvoiceItemForm.cbNotInvoicedOnlyClick(Sender: TObject);
var
  Criteria: TCustomerInvoiceOrdersCriteria;
begin
  if not FSettingsControls then
  begin
    Criteria := FCustomerOrders.Criteria;
    Criteria.NotInvoicedOnly := cbNotInvoicedOnly.Checked;
    FCustomerOrders.Criteria := Criteria;
    FCustomerOrders.Reload;
  end;
end;

procedure TInvoiceItemForm.comboOrderChange(Sender: TObject);
begin
  if (FInvoiceItems <> nil) and (FCustomerOrders <> nil) then
  begin
    // устанавливаем параметры только если это другой заказ.
    // дл€ того чтобы не испортить значени€ при редактировании существующего
    if FInvoiceItems.OrderID <> FCustomerOrders.KeyValue then
    begin
      FInvoiceItems.Quantity := FCustomerOrders.Quantity;
      FInvoiceItems.ItemCost := FCustomerOrders.Cost;
      FInvoiceItems.OrderNumber := FCustomerOrders.OrderNumber;
      FInvoiceItems.ItemText := FCustomerOrders.Comment;
    end;
  end;
end;

procedure TInvoiceItemForm.comboProductsChange(Sender: TObject);
begin
  if (InvoiceItems <> nil) and not VarIsNull(comboProducts.KeyValue) then
      // Ќе примен€ем изменени€, а берем из контрола,
      // чтобы при отмене редактировани€ все вернулось назад.
      InvoiceItems.ItemText := TConfigManager.Instance.StandardDics.deExternalProducts
        .ItemName[comboProducts.KeyValue];
end;

procedure TInvoiceItemForm.FormActivate(Sender: TObject);
begin
  inherited;
  // ƒл€ новых позиций сразу выбираем номенклатуру, если режим активирован
  if SelectExternalProduct and (NvlInteger(InvoiceItems.KeyValue) <= 0) then
    rbItemCode.Checked := true
  else if VarIsNull(InvoiceItems.ExternalProductID) then
    rbItemText.Checked := true
  else 
    rbItemCode.Checked := true;
end;

procedure TInvoiceItemForm.FormCreate(Sender: TObject);
begin
  inherited;
  //btSelectProduct.Glyph := GetSyncStateImage(SyncState_Syncronized);
  dsProducts.DataSet := TConfigManager.Instance.StandardDics.deExternalProducts.DicItems;
end;

procedure TInvoiceItemForm.rbItemCodeClick(Sender: TObject);
begin
  UpdateControlsState;
end;

procedure TInvoiceItemForm.SetCustomerOrders(Value: TCustomerInvoiceOrders);
begin
  FCustomerOrders := Value;
  comboOrder.ListSource := FCustomerOrders.DataSource;
  FSettingsControls := true;
  cbNotPaidOnly.Checked := FCustomerOrders.Criteria.NotPaidOnly;
  cbNotInvoicedOnly.Checked := FCustomerOrders.Criteria.NotInvoicedOnly;
  FCustomerID := FCustomerOrders.Criteria.CustomerID;
  cbAllCustomers.Checked := FCustomerID <= 0;
  FSettingsControls := false;
end;

procedure TInvoiceItemForm.UpdateControlsState;
begin
  edItemText.Enabled := rbItemText.Checked;
  comboProducts.Enabled := rbItemCode.Checked;
  if rbItemText.Checked and not VarIsNull(InvoiceItems.ExternalProductID) then
  begin
    InvoiceItems.ExternalProductID := null;
    edItemText.Update;
  end;
end;

end.
