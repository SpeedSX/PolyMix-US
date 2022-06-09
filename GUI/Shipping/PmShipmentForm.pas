unit PmShipmentForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseEditForm, JvComponentBase, JvFormPlacement, StdCtrls, DBCtrls,
  Buttons, JvExControls, JvDBLookup, JvExMask, JvToolEdit, JvMaskEdit,
  JvCheckedMaskEdit, JvDatePickerEdit, JvDBDatePickerEdit, Mask,
  DB, GridsEh, DBGridEh, MyDBGridEh, ExtCtrls, DBCtrlsEh, DBLookupEh,

  PmShipment, PmCustomerOrders;

type
  TShipmentForm = class(TBaseEditForm)
    lbTirazz: TLabel;
    edTirazz: TDBEdit;
    GroupBox1: TGroupBox;
    edBatchNum: TDBEdit;
    Label6: TLabel;
    edNOut: TDBEdit;
    Label5: TLabel;
    Label11: TLabel;
    edItemText: TDBEdit;
    comboOrder: TDBLookupComboboxEh;
    lbOrder: TLabel;
    cbNotShippedOnly: TCheckBox;
    cbAllCustomers: TCheckBox;
    procedure comboOrderChange(Sender: TObject);
    procedure cbNotShippedOnlyClick(Sender: TObject);
    procedure cbAllCustomersClick(Sender: TObject);
  private
    FShipment: TShipment;
    FTotalShipped, FTirazz: integer;
    FCustomerOrders: TCustomerInvoiceOrders;
    FCustomerID: integer;
    FSettingsControls: boolean;
    procedure SetShipment(Value: TShipment);
    procedure SetCustomerOrders(Value: TCustomerInvoiceOrders);
  protected
    function ValidateForm: boolean; override;
  public
    property Shipment: TShipment read FShipment write SetShipment;
    property CustomerOrders: TCustomerInvoiceOrders read FCustomerOrders write SetCustomerOrders;
    property TotalShipped: integer read FTotalShipped write FTotalShipped;
    property Tirazz: integer read FTirazz write FTirazz;
  end;

// Отображает форму создания отгрузки.
function ExecNewShipmentForm(Shipment: TShipment;
  CustomerOrders: TCustomerInvoiceOrders; TotalShipped, Tirazz: integer): boolean;

// Отображает форму редактирования отгрузки.
function ExecEditShipmentForm(Shipment: TShipment;
  CustomerOrders: TCustomerInvoiceOrders; TotalShipped, Tirazz: integer): boolean;

implementation

{$R *.dfm}

uses RDBUtils, RDialogs;

function ExecNewShipmentForm(Shipment: TShipment;
  CustomerOrders: TCustomerInvoiceOrders; TotalShipped, Tirazz: integer): boolean;
begin
  Result := ExecEditShipmentForm(Shipment, CustomerOrders, TotalShipped, Tirazz);
end;

function ExecEditShipmentForm(Shipment: TShipment;
  CustomerOrders: TCustomerInvoiceOrders; TotalShipped, Tirazz: integer): boolean;
var
  ShipmentForm: TShipmentForm;
begin
  Application.CreateForm(TShipmentForm, ShipmentForm);
  try
    ShipmentForm.Shipment := Shipment;
    ShipmentForm.CustomerOrders := CustomerOrders;
    ShipmentForm.TotalShipped := TotalShipped;
    ShipmentForm.Tirazz := Tirazz;
    Result := ShipmentForm.ShowModal = mrOk;
  finally
    FreeAndNil(ShipmentForm);
  end;
end;

procedure TShipmentForm.cbAllCustomersClick(Sender: TObject);
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

procedure TShipmentForm.cbNotShippedOnlyClick(Sender: TObject);
var
  Criteria: TCustomerInvoiceOrdersCriteria;
begin
  if not FSettingsControls then
  begin
    Criteria := FCustomerOrders.Criteria;
    Criteria.NotShippedOnly := cbNotShippedOnly.Checked;
    FCustomerOrders.Criteria := Criteria;
    FCustomerOrders.Reload;
  end;
end;

procedure TShipmentForm.comboOrderChange(Sender: TObject);
begin
  // устанавливаем параметры только если это другой заказ.
  // для того чтобы не испортить значения при редактировании существующего
  if FShipment.OrderID <> FCustomerOrders.KeyValue then
  begin
    FShipment.ItemText := FCustomerOrders.Comment;
    FShipment.OrderNumber := FCustomerOrders.OrderNumber;
    FShipment.ProductNumber := FCustomerOrders.Quantity;
  end;
end;

procedure TShipmentForm.SetCustomerOrders(Value: TCustomerInvoiceOrders);
begin
  FCustomerOrders := Value;
  if FCustomerOrders <> nil then
  begin
    comboOrder.ListSource := FCustomerOrders.DataSource;
    edTirazz.DataSource := FCustomerOrders.DataSource;
    FSettingsControls := true;
    cbNotShippedOnly.Checked := FCustomerOrders.Criteria.NotShippedOnly;
    FCustomerID := FCustomerOrders.Criteria.CustomerID;
    cbAllCustomers.Checked := FCustomerID <= 0;
    FSettingsControls := false;
  end
  else
  begin
    comboOrder.Visible := false;
    lbOrder.Visible := false;
    edTirazz.DataSource := FShipment.DataSource;
  end;
end;

procedure TShipmentForm.SetShipment(Value: TShipment);
begin
  FShipment := Value;
  if FCustomerOrders = nil then
    edTirazz.DataSource := FShipment.DataSource;
  edNOut.DataSource := FShipment.DataSource;
  edBatchNum.DataSource := FShipment.DataSource;
  edItemText.DataSource := FShipment.DataSource;
  comboOrder.DataSource := FShipment.DataSource;
end;

function TShipmentForm.ValidateForm: boolean;
begin
  ActiveControl := btOk;
  {Result := Tirazz >= TotalShipped + FShipment.NumberToShip;
  if not Result then
  begin
    ActiveControl := edNOut;
    RusMessageDlg('Отгруженный тираж превышает общий', mtWarning, [mbOk], 0);
  end;}  // убрано это пока что, т.к. не всегда правильно, например при добавлении заказа в накладную

  Result := true;  // Разрешаем закрыть в любом случае
end;

end.
