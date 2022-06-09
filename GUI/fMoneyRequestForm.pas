unit fMoneyRequestForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseEditForm, StdCtrls, JvExStdCtrls, JvEdit, JvValidateEdit,
  JvComponentBase, JvFormPlacement;

type
  TMoneyRequestForm = class(TBaseEditForm)
    Label1: TLabel;
    edMoney: TJvValidateEdit;
    cbPercent: TCheckBox;
    procedure cbPercentClick(Sender: TObject);
  private
    FValue: extended;
    procedure SetValue(_Value: extended);
    function GetValue: extended;
  public
    property Value: extended read GetValue write SetValue;
  end;

function ExecMoneyRequestDialog(Header, Prompt: string; MinValue, MaxValue: extended;
  var Value: extended): boolean;

implementation

{$R *.dfm}

function ExecMoneyRequestDialog(Header, Prompt: string; MinValue, MaxValue: extended;
  var Value: extended): boolean;
var
  MoneyRequestForm: TMoneyRequestForm;
begin
  Application.CreateForm(TMoneyRequestForm, MoneyRequestForm);
  try
    MoneyRequestForm.Value := Value;
    MoneyRequestForm.Label1.Caption := Prompt;
    MoneyRequestForm.Caption := Header;
    MoneyRequestForm.edMoney.MaxValue := MaxValue;
    MoneyRequestForm.edMoney.MinValue := MinValue;
    Result := MoneyRequestForm.ShowModal = mrOk;
    if Result then Value := MoneyRequestForm.Value;
  finally
    FreeAndNil(MoneyRequestForm);
  end;
end;

procedure TMoneyRequestForm.SetValue(_Value: extended);
begin
  FValue := _Value;
  edMoney.Value := _Value;
end;

function TMoneyRequestForm.GetValue: extended;
begin
  Result := edMoney.Value;
  if cbPercent.Checked then
    Result := Result * FValue / 100.0;
end;

procedure TMoneyRequestForm.cbPercentClick(Sender: TObject);
begin
  if cbPercent.Checked then
  begin
    if FValue <> 0 then
      edMoney.Value := edMoney.Value / FValue * 100.0
    else
      edMoney.Value := 100.0;
  end
  else
    edMoney.Value := edMoney.Value / 100.0 * FValue;
end;

end.
