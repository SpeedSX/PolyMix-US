unit fEditOrderState;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, JvExControls, JvDBLookup;

type
  TEditOrderStateForm = class(TForm)
    Label10: TLabel;
    cbOrderState: TJvDBLookupCombo;
    Label1: TLabel;
    cbNewOrderState: TJvDBLookupCombo;
    btOk: TButton;
    btCancel: TButton;
    lbOrderNumPrompt: TLabel;
    lbOrderNum: TLabel;
    procedure cbOrderStateGetImage(Sender: TObject;
       IsEmpty: Boolean; var Graphic: TGraphic; var TextMargin: Integer);
    procedure FormCreate(Sender: TObject);
    procedure cbOrderStateChange(Sender: TObject);
  private
    dsOrderState: TDataSource;
    procedure SetOrderNumber(Value: string);
    procedure SetCurrentOrderState(Value: integer);
    procedure SetNewOrderState(Value: integer);
    function GetCurrentOrderState: integer;
    function GetNewOrderState: integer;
    procedure UpdateControls;
  public
    property OrderNumber: string write SetOrderNumber;
    property CurrentOrderState: integer read GetCurrentOrderState write SetCurrentOrderState;
    property NewOrderState: integer read GetNewOrderState write SetNewOrderState;
  end;

var
  EditOrderStateForm: TEditOrderStateForm;

// Отображает диалог изменения состояния
// Возвращает старое состояние, если пользователь отменил операцию
function ExecEditOrderStateForm(OrderState: integer; OrderNumber: string): integer;

implementation

uses PmStates, PmConfigManager, DicObj;

{$R *.dfm}

function ExecEditOrderStateForm(OrderState: integer; OrderNumber: string): integer;
begin
  EditOrderStateForm := TEditOrderStateForm.Create(nil);
  try
    EditOrderStateForm.CurrentOrderState := OrderState;
    EditOrderStateForm.NewOrderState := OrderState;
    EditOrderStateForm.OrderNumber := OrderNumber;
    if EditOrderStateForm.ShowModal = mrOk then
      Result := EditOrderStateForm.NewOrderState
    else
      Result := EditOrderStateForm.CurrentOrderState;
  finally
    EditOrderStateForm.Free;
  end;
end;

procedure TEditOrderStateForm.cbOrderStateChange(Sender: TObject);
begin
  UpdateControls;
end;

procedure TEditOrderStateForm.cbOrderStateGetImage(Sender: TObject;
  IsEmpty: Boolean; var Graphic: TGraphic; var TextMargin: Integer);
var
  os, gi: integer;
begin
  TextMargin := 18;
  if not IsEmpty and (dsOrderState <> nil) and not VarIsNull(dsOrderState.DataSet[F_DicItemCode]) then
  try
    os := dsOrderState.DataSet[F_DicItemCode];
    gi := TConfigManager.Instance.StandardDics.OrderStates.IndexOf(IntToStr(os));
    if gi <> -1 then
      Graphic := (TConfigManager.Instance.StandardDics.OrderStates.Objects[gi] as TOrderState).Graphic;
  except end;
end;

procedure TEditOrderStateForm.FormCreate(Sender: TObject);
begin
  if dsOrderState = nil then
  begin
    dsOrderState := TDataSource.Create(Self);
    dsOrderState.DataSet := TConfigManager.Instance.StandardDics.deOrderState.DicItems;
  end;
  cbOrderState.LookupSource := dsOrderState;
  cbNewOrderState.LookupSource := dsOrderState;
end;

procedure TEditOrderStateForm.SetOrderNumber(Value: string);
begin
  lbOrderNum.Caption := Value;
end;

procedure TEditOrderStateForm.SetCurrentOrderState(Value: integer);
begin
  cbOrderState.KeyValue := Value;
  UpdateControls;
end;

procedure TEditOrderStateForm.SetNewOrderState(Value: integer);
begin
  cbNewOrderState.KeyValue := Value;
  UpdateControls;
end;

function TEditOrderStateForm.GetCurrentOrderState: integer;
begin
  Result := cbOrderState.KeyValue;
end;

function TEditOrderStateForm.GetNewOrderState: integer;
begin
  Result := cbNewOrderState.KeyValue;
end;

procedure TEditOrderStateForm.UpdateControls;
begin
  btOk.Enabled := cbNewOrderState.KeyValue <> cbOrderState.KeyValue;
  btOk.Default := btOk.Enabled;
  btCancel.Default := not btOk.Default;
end;

end.
