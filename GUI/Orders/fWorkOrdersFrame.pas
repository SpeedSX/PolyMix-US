unit fWorkOrdersFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fOrdersFrame, Menus, StdCtrls, Mask, DBCtrls, Buttons, GridsEh,
  DBGridEh, MyDBGridEh, ExtCtrls, JvExExtCtrls, JvNetscapeSplitter, JvFormPlacement,
  JvImageList,

  PmOrderInvoiceItems, PmOrderPayments, PmShipment, PmOrder, PmEntity,
  DBGridEhGrouping;

type
  TWorkOrdersFrame = class(TOrdersFrame)
    procedure dgCalcOrderGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState); override;
  private
    FOnEditInvoice: TNotifyEvent;
    FOnMakeInvoice: TNotifyEvent;
    FOnPayInvoice: TNotifyEvent;
    FOnAddShipment, FOnEditShipment, FOnDeleteShipment, FOnApproveShipment, FOnAddToStorage, FOnDeleteFromStorage: TNotifyEvent;
    FOnApproveOrderMaterials, FOnExternalMat, FOnCancelMaterialRequest, FOnEditMaterialRequest: TNotifyEvent;
    FOrderInvoiceItems: TOrderInvoiceItems;
    FOrderPayments: TOrderPayments;
    FOrderShipment: TShipment;
    procedure SetOrderInvoiceItems(Value: TOrderInvoiceItems);
    procedure SetOrderPayments(Value: TOrderPayments);
    procedure SetOrderShipment(Value: TShipment);
  protected
    procedure CreateGridColumns; override;
    procedure DoMakeInvoice(Sender: TObject);
    procedure DoEditInvoice(Sender: TObject);
    procedure DoPayInvoice(Sender: TObject);
    procedure DoAddShipment(Sender: TObject);
    procedure DoEditShipment(Sender: TObject);
    procedure DoDeleteShipment(Sender: TObject);
    procedure DoApproveShipment(Sender: TObject);
    procedure DoApproveOrderMaterials(Sender: TObject);
    procedure DoSelectExternalMaterial(Sender: TObject);
    procedure DoCancelMaterialRequest(Sender: TObject);
    procedure DoEditMaterialRequest(Sender: TObject);
    procedure DoAddToStorage(Sender: TObject);
    procedure DoDeleteFromStorage(Sender: TObject);

  public
    constructor Create(Owner: TComponent; {_Name: string; }_Order: TEntity); override;
    procedure AfterConstruction; override;

    property OnEditInvoice: TNotifyEvent read FOnEditInvoice write FOnEditInvoice;
    property OnMakeInvoice: TNotifyEvent read FOnMakeInvoice write FOnMakeInvoice;
    property OnPayInvoice: TNotifyEvent read FOnPayInvoice write FOnPayInvoice;
    property OnAddShipment: TNotifyEvent read FOnAddShipment write FOnAddShipment;
    property OnEditShipment: TNotifyEvent read FOnEditShipment write FOnEditShipment;
    property OnDeleteShipment: TNotifyEvent read FOnDeleteShipment write FOnDeleteShipment;
    property OnApproveShipment: TNotifyEvent read FOnApproveShipment write FOnApproveShipment;
    property OnApproveOrderMaterials: TNotifyEvent read FOnApproveOrderMaterials write FOnApproveOrderMaterials;
    property OnSelectExternalMaterial: TNotifyEvent read FOnExternalMat write FOnExternalMat;
    property OnCancelMaterialRequest: TNotifyEvent read FOnCancelMaterialRequest write FOnCancelMaterialRequest;
    property OnEditMaterialRequest: TNotifyEvent read FOnEditMaterialRequest write FOnEditMaterialRequest;

    property OnAddToStorage: TNotifyEvent read FOnAddToStorage write FOnAddToStorage;
    property OnDeleteFromStorage: TNotifyEvent read FOnDeleteFromStorage write FOnDeleteFromStorage;

    property OrderInvoiceItems: TOrderInvoiceItems read FOrderInvoiceItems write SetOrderInvoiceItems;
    property OrderPayments: TOrderPayments read FOrderPayments write SetOrderPayments;
    property OrderShipment: TShipment read FOrderShipment write SetOrderShipment;
  end;

implementation

uses CalcSettings, PmAccessManager, PmEntSettings;

{$R *.dfm}

constructor TWorkOrdersFrame.Create(Owner: TComponent; _Order: TEntity);
begin
  inherited Create(Owner, _Order);

  OrderItemsFrame.OnEditInvoice := DoEditInvoice;
  OrderItemsFrame.OnMakeInvoice := DoMakeInvoice;
  OrderItemsFrame.OnPayInvoice := DoPayInvoice;
  OrderItemsFrame.OnAddShipment := DoAddShipment;
  OrderItemsFrame.OnEditShipment := DoEditShipment;
  OrderItemsFrame.OnDeleteShipment := DoDeleteShipment;
  OrderItemsFrame.OnApproveShipment := DoApproveShipment;
  OrderItemsFrame.OnApproveOrderMaterials := DoApproveOrderMaterials;
  OrderItemsFrame.OnSelectExternalMaterial := DoSelectExternalMaterial;
  OrderItemsFrame.OnCancelMaterialRequest := DoCancelMaterialRequest;
  OrderItemsFrame.OnEditMaterialRequest := DoEditMaterialRequest;
  OrderItemsFrame.OnAddToStorage := DoAddToStorage;
  OrderItemsFrame.OnDeleteFromStorage := DoDeleteFromStorage;


end;

procedure TWorkOrdersFrame.SetOrderInvoiceItems(Value: TOrderInvoiceItems);
begin
  FOrderInvoiceItems := Value;
  OrderItemsFrame.OrderInvoiceItems := FOrderInvoiceItems;
end;

procedure TWorkOrdersFrame.SetOrderPayments(Value: TOrderPayments);
begin
  FOrderPayments := Value;
  OrderItemsFrame.OrderPayments := FOrderPayments;
end;

procedure TWorkOrdersFrame.SetOrderShipment(Value: TShipment);
begin
  FOrderShipment := Value;
  OrderItemsFrame.OrderShipment := FOrderShipment;
end;

procedure TWorkOrdersFrame.AfterConstruction;
begin
  inherited;
  MkOrderItem.Visible := false;
end;

procedure TWorkOrdersFrame.CreateGridColumns;
var
  Col: TColumnEh;
begin
  Col := dgOrders.Columns.Add;
  Col.FieldName := TOrder.F_OrderState;
  Col.Title.Caption := ' ';
  Col.Width := 18;
  Col.MinWidth := 18;
  Col.MaxWidth := 18;

  Col := dgOrders.Columns.Add;
  Col.FieldName := TOrder.F_PayState;
  Col.Title.Caption := ' ';
  Col.Title.TitleButton := false;
  Col.Width := 18;
  Col.MinWidth := 18;
  Col.MaxWidth := 18;
  Col.Visible := Options.ShowPayState and AccessManager.CurUser.ViewPayments
    and AccessManager.CurUser.ViewInvoices;

  Col := dgOrders.Columns.Add;
  Col.FieldName := TOrder.F_ShipmentState;
  Col.Title.Caption := ' ';
  Col.Width := 18;
  Col.MinWidth := 18;
  Col.MaxWidth := 18;
  Col.Visible := Options.ShowShipmentState and AccessManager.CurUser.ViewShipment;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'IsLockedByUser';
  Col.Title.Caption := ' ';
  Col.Width := 19;
  Col.MinWidth := 19;
  Col.MaxWidth := 19;
  Col.Visible := Options.ShowLockState;
  Col.Checkboxes := false;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'ID';
  Col.Title.Caption := '№';
  Col.Title.Alignment := taLeftJustify;
  Col.Width := 53;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'CustomerName';
  Col.Title.Caption := 'Заказчик';
  Col.Title.Alignment := taLeftJustify;
  Col.Width := 95;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'Comment';
  Col.Title.Caption := 'Наименование';
  Col.Title.Alignment := taLeftJustify;
  Col.Width := 200;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'FinalCostGrn';
  Col.Title.Caption := 'Стоимость, грн';
  Col.Title.Alignment := taLeftJustify;
  Col.Width := 80;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'ClientTotal';
  Col.Title.Caption := 'Стоимость, у.е.';
  Col.Title.Alignment := taLeftJustify;
  Col.Visible := not EntSettings.NativeCurrency;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'ExternalId';
  Col.Title.Caption := 'Внешний №';
  Col.Title.Alignment := taLeftJustify;
  Col.Visible := EntSettings.ShowExternalId;
  Col.Width := 70;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'FinishDate';
  Col.Title.Caption := 'План. завершение';
  Col.Title.Alignment := taLeftJustify;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'StateChangeDate';
  Col.Title.Caption := 'Изменение состояние';
  Col.Title.Alignment := taLeftJustify;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'Tirazz';
  Col.Title.Caption := 'Тираж';
  Col.Title.Alignment := taLeftJustify;
  Col.OnGetCellParams := TirazzGetCellParams;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'Comment2';
  Col.Title.Caption := 'Комментарий';
  Col.Width := 200;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'CustomerPhone';
  Col.Title.Caption := 'Тел.1';
  Col.Width := 150;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'CustomerFax';
  Col.Title.Caption := 'Тел.2';
  Col.Width := 150;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'CreationDate';
  Col.Title.Caption := 'Дата созд.';
  Col.Width := 80;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'CreationTime';
  Col.Title.Caption := 'Время созд.';
  Col.Width := 60;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'ModifyDate';
  Col.Title.Caption := 'Дата изм.';
  Col.Width := 80;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'ModifyTime';
  Col.Title.Caption := 'Время изм.';
  Col.Width := 60;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'CreatorName';
  Col.Title.Caption := 'Создатель';
  Col.Width := 120;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'StartDate';
  Col.Title.Caption := 'Дата начала работ';
  Col.Title.Alignment := taLeftJustify;
  Col.Width := 80;

  Col := dgOrders.Columns.Add;
  Col.FieldName := 'KindName';
  Col.Title.Caption := 'Вид';
  Col.Width := 120;
  Col.Title.TitleButton := false;
end;

procedure TWorkOrdersFrame.dgCalcOrderGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if (Order as TWorkOrder).MatRequestModified then
  begin
    Background := clRed;
    AFont.Color := clWhite;
  end;
end;

procedure TWorkOrdersFrame.DoMakeInvoice(Sender: TObject);
begin
  FOnMakeInvoice(Self);
end;

procedure TWorkOrdersFrame.DoEditInvoice(Sender: TObject);
begin
  FOnEditInvoice(Self);
end;

procedure TWorkOrdersFrame.DoPayInvoice(Sender: TObject);
begin
  FOnPayInvoice(Self);
end;

procedure TWorkOrdersFrame.DoAddShipment(Sender: TObject);
begin
  FOnAddShipment(Self);
end;

procedure TWorkOrdersFrame.DoEditShipment(Sender: TObject);
begin
  FOnEditShipment(Self);
end;

procedure TWorkOrdersFrame.DoDeleteShipment(Sender: TObject);
begin
  FOnDeleteShipment(Self);
end;

procedure TWorkOrdersFrame.DoApproveShipment(Sender: TObject);
begin
  FOnApproveShipment(Self);
end;

procedure TWorkOrdersFrame.DoApproveOrderMaterials(Sender: TObject);
begin
  FOnApproveOrderMaterials(Self);
end;

procedure TWorkOrdersFrame.DoSelectExternalMaterial(Sender: TObject);
begin
  FOnExternalMat(Self);
end;

procedure TWorkOrdersFrame.DoCancelMaterialRequest(Sender: TObject);
begin
  FOnCancelMaterialRequest(Self);
end;

procedure TWorkOrdersFrame.DoEditMaterialRequest(Sender: TObject);
begin
  FOnEditMaterialRequest(Self);
end;

procedure TWorkOrdersFrame.DoAddToStorage(Sender: TObject);
begin
  FOnAddToStorage(Self);
end;

procedure TWorkOrdersFrame.DoDeleteFromStorage(Sender: TObject);
begin
  FOnDeleteFromStorage(Self);
end;


end.
