unit fCopyOrder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, StdCtrls, JvExMask, JvToolEdit, ExtCtrls, Buttons,
  
  PmProviders, PmOrder, JvExStdCtrls, JvHtControls;

type
  TCopyOrderForm = class(TForm)
    btOk: TBitBtn;
    btCancel: TBitBtn;
    Label9: TLabel;
    deFinishDate: TJvDateEdit;
    tmFinish: TMaskEdit;
    Panel1: TPanel;
    lbWarning: TJvHTLabel;
    procedure deFinishDateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CopyOrderForm: TCopyOrderForm;

type
  TCopyOrderFormParamsProvider = class(TInterfacedObject, ICopyParamsProvider)
  private
    FOrder: TOrder;
  public
    function FinishDate: variant;
    procedure CreateForm(Order: TOrder);
    function Execute: integer;
    destructor Destroy; override;
  end;

const
  CopyWarningText = '<b>Внимание!</b><br><br>При создании копии заказа Вы становитесь его создателем<br>'
     + 'и несете ответственность за его содержание,<br>включая дополнительные примечания.<br><br>'
     + '<b>Пожалуйста, внимательно проверяйте<br>скопированные заказы!</b>';

implementation

uses DateUtils;

{$R *.dfm}

function TCopyOrderFormParamsProvider.FinishDate: variant;
var
  FinDate: variant;

  function FixDate(dt: TDateTime): TDateTime;
  var
    S: string;
  begin
    s := CopyOrderForm.deFinishDate.Text;
    if CopyOrderForm.tmFinish.EditText <> NullTime then
      s := s + ' ' + CopyOrderForm.tmFinish.EditText;
    Result := StrToDateTime(s);
  end;

begin
  // Для расчетов не надо ничего
  if FOrder is TWorkOrder then
  begin
    if CopyOrderForm.deFinishDate.Date = 0 then FinDate := null
    else FinDate := FixDate(CopyOrderForm.deFinishDate.Date);
    Result := FinDate;
  end
  else
    Result := null;
end;

function TCopyOrderFormParamsProvider.Execute: integer;
begin
  if FOrder is TWorkOrder then
    Result := CopyOrderForm.ShowModal
  else
    Result := mrOk; // Для расчетов не надо ничего
end;

procedure TCopyOrderFormParamsProvider.CreateForm(Order: TOrder);
begin
  FOrder := Order;
  if Order is TWorkOrder then    // Для расчетов не надо ничего
    Application.CreateForm(TCopyOrderForm, CopyOrderForm);
end;

destructor TCopyOrderFormParamsProvider.Destroy;
begin
  FreeAndNil(CopyOrderForm);
  inherited Destroy;
end;

procedure TCopyOrderForm.deFinishDateChange(Sender: TObject);
begin
  if (CompareDate(deFinishDate.Date, Today) = 0) and (tmFinish.Text = NullTime) then
    tmFinish.Text := SysUtils.FormatDateTime('t', Now);
end;

procedure TCopyOrderForm.FormCreate(Sender: TObject);
begin
  lbWarning.Caption := CopyWarningText;
end;

end.
