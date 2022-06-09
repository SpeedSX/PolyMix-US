unit PmDelayedOrdersForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, GridsEh, DBGridEh, MyDBGridEh,

  PmOrder, DBGridEhGrouping;

type
  TDelayedOrdersForm = class(TForm)
    dgOrders: TMyDBGridEh;
    btClose: TBitBtn;
    btGotoOrder: TBitBtn;
    btOrderProps: TBitBtn;
    procedure btOrderPropsClick(Sender: TObject);
    procedure dgOrdersDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
  private
    FOrders: TOrder;
    FOnOrderProps: TNotifyEvent;
    procedure SetOrders(Value: TOrder);
  public
    property Orders: TOrder read FOrders write SetOrders;
    property OnOrderProps: TNotifyEvent read FOnOrderProps write FOnOrderProps;
  end;

function ExecDelayedOrdersForm(_DelayedOrders: TOrder; EditOrderPropsHandler: TNotifyEvent): boolean;

implementation

uses CalcUtils;

{$R *.dfm}

function ExecDelayedOrdersForm(_DelayedOrders: TOrder; EditOrderPropsHandler: TNotifyEvent): boolean;
var
  DelayedOrdersForm: TDelayedOrdersForm;
begin
  DelayedOrdersForm := TDelayedOrdersForm.Create(nil);
  try
    DelayedOrdersForm.Orders := _DelayedOrders;
    DelayedOrdersForm.OnOrderProps := EditOrderPropsHandler;
    Result := DelayedOrdersForm.ShowModal = mrOk;
  finally
    DelayedOrdersForm.Free;
  end;
end;

procedure TDelayedOrdersForm.btOrderPropsClick(Sender: TObject);
begin
  FOnOrderProps(Self);
  if FOrders.IsEmpty then
    Close;
end;

procedure TDelayedOrdersForm.dgOrdersDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  // состояние заказа
  if (CompareText(Column.FieldName, TOrder.F_OrderState) = 0) and (Column.Field <> nil) then
  begin
    DrawOrderState(Sender as TOrderGridClass, Column, Rect);
  end
  else  // Состояние оплаты
  if (CompareText(Column.FieldName, TOrder.F_PayState) = 0) and (Column.Field <> nil) then
  begin
    DrawPayState(Sender as TOrderGridClass, Column, Rect);
  end;
end;

procedure TDelayedOrdersForm.SetOrders(Value: TOrder);
begin
  FOrders := Value;
  dgOrders.DataSource := FOrders.DataSource;
end;

end.
