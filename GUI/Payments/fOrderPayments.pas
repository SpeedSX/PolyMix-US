unit fOrderPayments;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseEditForm, GridsEh, DBGridEh, MyDBGridEh, JvComponentBase,
  JvFormPlacement, StdCtrls,

  PmCustomerPayments, DBGridEhGrouping;

type
  TOrderPaymentsForm = class(TBaseEditForm)
    dgPayments: TMyDBGridEh;
    btDelete: TButton;
    btLocateIncome: TButton;
    procedure btDeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btLocateIncomeClick(Sender: TObject);
  private
    FPaymentsData: TCustomerPayments;
    FLocateIncomeID: variant;
    procedure SetPaymentsData(_PaymentsData: TCustomerPayments);
  public
    property PaymentsData: TCustomerPayments read FPaymentsData write SetPaymentsData;
    property LocateIncomeID: variant read FLocateIncomeID write FLocateIncomeID;
  end;

function ExecOrderPaymentsDialog(Payments: TCustomerPayments; var LocateIncomeID: variant): boolean;

implementation

{$R *.dfm}

uses PmAccessManager;

function ExecOrderPaymentsDialog(Payments: TCustomerPayments; var LocateIncomeID: variant): boolean;
var
  OrderPaymentsForm: TOrderPaymentsForm;
begin
  Application.CreateForm(TOrderPaymentsForm, OrderPaymentsForm);
  try
    OrderPaymentsForm.PaymentsData := Payments;
    Result := OrderPaymentsForm.ShowModal = mrOk;
    if Result then
      LocateIncomeID := OrderPaymentsForm.LocateIncomeID;
  finally
    FreeAndNil(OrderPaymentsForm);
  end;
end;

procedure TOrderPaymentsForm.btDeleteClick(Sender: TObject);
begin
  if not FPaymentsData.DataSet.IsEmpty then
    FPaymentsData.DataSet.Delete;
end;

procedure TOrderPaymentsForm.btLocateIncomeClick(Sender: TObject);
begin
  if FPaymentsData.IsEmpty then
    ModalResult := mrNone
  else
    FLocateIncomeID := FPaymentsData.IncomeID;
end;

procedure TOrderPaymentsForm.FormCreate(Sender: TObject);
begin
  btDelete.Enabled := AccessManager.CurUser.AddPayments;
// 07.03.2021   btDelete.Enabled := AccessManager.CurUser.EditPayments;
end;

procedure TOrderPaymentsForm.SetPaymentsData(_PaymentsData: TCustomerPayments);
begin
  FPaymentsData := _PaymentsData;
  dgPayments.DataSource := FPaymentsData.DataSource;
  //dgPayments.AutoFitColWidths := true;
end;

end.
