unit PmSelectInvoiceForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GridsEh, DBGridEh, MyDBGridEh,

  PmInvoice, DBGridEhGrouping;

type
  TSelectInvoiceForm = class(TForm)
    dgInvoices: TMyDBGridEh;
    btOk: TButton;
    btCancel: TButton;
  private
    FInvoices: TInvoices;
    procedure SetInvoices(Value: TInvoices);
  public
    property Invoices: TInvoices read FInvoices write SetInvoices;
  end;

function ExecSelectInvoiceForm(Invoices: TInvoices): boolean;

implementation

{$R *.dfm}

function ExecSelectInvoiceForm(Invoices: TInvoices): boolean;
var
  SelectInvoiceForm: TSelectInvoiceForm;
begin
  Application.CreateForm(TSelectInvoiceForm, SelectInvoiceForm);
  try
    SelectInvoiceForm.Invoices := Invoices;
    Result := SelectInvoiceForm.ShowModal = mrOk;
  finally
    FreeAndNil(SelectInvoiceForm);
  end;
end;

procedure TSelectInvoiceForm.SetInvoices(Value: TInvoices);
begin
  FInvoices := Value;
  dgInvoices.DataSource := FInvoices.DataSource;
end;

end.
