unit PmInvoiceExistForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TInvoiceExistForm = class(TForm)
    Label1: TLabel;
    btCreateNew: TButton;
    btAddToExist: TButton;
    btCancel: TButton;
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InvoiceExistForm: TInvoiceExistForm;

function ShowInvoiceExistForm(InvoiceNum: string; AddToExisting: boolean): boolean;

implementation

{$R *.dfm}

function ShowInvoiceExistForm(InvoiceNum: string; AddToExisting: boolean): boolean;
var
  Res: TModalResult;
begin
  Application.CreateForm(TInvoiceExistForm, InvoiceExistForm);
  try
    InvoiceExistForm.Label1.Caption := '—чет с номером ' + InvoiceNum + ' уже существует.';
    Res := InvoiceExistForm.ShowModal;
    Result := Res <> mrCancel;
    AddToExisting := Res = mrYes;
  finally
    FreeAndNil(InvoiceExistForm);
  end;
end;

end.
