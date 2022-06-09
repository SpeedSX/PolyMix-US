unit fOrderNum;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, JvExMask, JvToolEdit, JvBaseEdits;

type
  TOrderNumForm = class(TForm)
    Label1: TLabel;
    JvCalcEdit1: TJvCalcEdit;
    btOk: TButton;
    btCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OrderNumForm: TOrderNumForm;

// Показывает диалог ввода номера заказа. Возращает 0 если отмена.
function ExecOrderNumberForm: integer;

implementation

{$R *.dfm}

var
  LastOrderNum: integer = 0;

function ExecOrderNumberForm: integer;
begin
  Application.CreateForm(TOrderNumForm, OrderNumForm);
  try
    OrderNumForm.JvCalcEdit1.Value := LastOrderNum;
    if OrderNumForm.ShowModal = mrOk then
    begin
      Result := Trunc(OrderNumForm.JvCalcEdit1.Value);
      LastOrderNum := Result;
    end else
      Result := 0;
  finally
    OrderNumForm.Free;
  end;
end;

end.
