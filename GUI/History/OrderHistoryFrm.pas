unit OrderHistoryFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGridEh, MyDBGridEh, JvComponent, JvFormPlacement,
  StdCtrls, ExtCtrls, JvAppStorage, JvComponentBase, GridsEh, Buttons, DB,

  PmEntity, HistFrm, PmHistory, PmOrder;

type
  TOrderHistoryForm = class(THistoryForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FHistory: TOrderHistoryView;
  protected
    procedure DoFormActivate; override;
    procedure DoRefreshHistory; override;
  public
    Order: TOrder;
  end;

var
  OrderHistoryForm: TOrderHistoryForm;

procedure ExecOrderHistoryForm(Order: TOrder; MainStorage: TJvCustomAppStorage);

implementation

{$R *.dfm}

procedure ExecOrderHistoryForm(Order: TOrder; MainStorage: TJvCustomAppStorage);
begin
  try
    Application.CreateForm(TOrderHistoryForm, OrderHistoryForm);
    OrderHistoryForm.Order := Order;
    OrderHistoryForm.MainStorage := MainStorage;
    OrderHistoryForm.ShowModal;
  finally
    FreeAndNil(OrderHistoryForm);
  end;
end;

procedure TOrderHistoryForm.DoFormActivate;
begin
  FHistory := TOrderHistoryView.Create(Order.KeyValue);
  dsHistory.DataSet := FHistory.DataSet;
  FHistory.Reload;
end;

procedure TOrderHistoryForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FHistory.Free;
end;

procedure TOrderHistoryForm.DoRefreshHistory;
begin
  FHistory.Reload;
end;

end.
