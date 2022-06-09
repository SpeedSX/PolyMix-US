unit fPaymentsFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseFilter, ImgList, JvImageList, JvExControls, JvxCheckListBox,
  StdCtrls, JvDBLookup, Mask, JvExMask, JvToolEdit, JvExStdCtrls, JvEdit,
  JvValidateEdit, JvgGroupBox, Buttons, ExtCtrls, DBCtrlsEh;

type
  TPaymentsFilterFrame = class(TBaseFilterFrame)
    gbPayType: TJvgGroupBox;
    cbPayType: TComboBox;
    procedure cbPayTypeChange(Sender: TObject);
  private
    { Private declarations }
  protected
    FPayTypes: TStringList;
    procedure DoRestoreControls; override;
    procedure DoSaveControls; override;
    function SupportsOrderState: boolean; override;
    function SupportsPayState: boolean; override;
    function GetDateList: TStringList; override;
    procedure FillPayTypes;
    procedure DoOnCfgChanged(Sender: TObject); override;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure Activate; override;
    procedure DisableFilter; override;
  end;

implementation

uses MainFilter, PmConfigManager;

{$R *.dfm}

var
  PaymentsDateList: TStringList;

constructor TPaymentsFilterFrame.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  FillPayTypes;
end;

destructor TPaymentsFilterFrame.Destroy;
begin
  FreeAndNil(FPayTypes);
  inherited;
end;

procedure TPaymentsFilterFrame.cbPayTypeChange(Sender: TObject);
begin
  // проверяем, изменилось ли что-нибудь
  if {((FilterObj as TInvoicesFilterObj).PayTypeChecked <> not gbPayType.Collapsed)
     or }(cbPayType.ItemIndex >= 0) then
      ApplyFilter
  else
    SaveControls;
end;

procedure TPaymentsFilterFrame.DoOnCfgChanged(Sender: TObject);
begin
  inherited;
  FillPayTypes;
end;

function TPaymentsFilterFrame.SupportsOrderState: boolean;
begin
  Result := true;
end;

function TPaymentsFilterFrame.SupportsPayState: boolean;
begin
  Result := true;
end;

{function TPaymentsFilterFrame.GetCustomerKey: Integer;
begin
  Result := (FEntity as TCustomersWithIncome).CustomerID;
end;}

function TPaymentsFilterFrame.GetDateList: TStringList;
begin
  Result := PaymentsDateList;
end;

procedure TPaymentsFilterFrame.Activate;
begin
  inherited;
  gbProcessState.Visible := false;
  gbCust.Visible := false;
  gbProcess.Visible := false;
  gbPayState.Visible := false;
end;

procedure TPaymentsFilterFrame.DoRestoreControls;
var
  i, c: integer;
  Found: boolean;
begin
  inherited;
  // вид оплаты
  gbPayType.Collapsed := not (FilterObj as TPaymentsFilterObj).PayTypeChecked;
  c := (FilterObj as TPaymentsFilterObj).PayTypeCode;
  Found := false;
  for i := 0 to Pred(FPayTypes.Count) do
    if integer(FPayTypes.Objects[i]) = c then
    begin
      Found := true;
      break;
    end;
  if Found and (i < cbPayType.Items.Count) then
    cbPayType.ItemIndex := i;
end;

procedure TPaymentsFilterFrame.DoSaveControls;
begin
  inherited;
  // вид оплаты
  (FilterObj as TPaymentsFilterObj).PayTypeChecked := not gbPayType.Collapsed;
  if cbPayType.ItemIndex >= 0 then
    (FilterObj as TPaymentsFilterObj).PayTypeCode := integer(FPayTypes.Objects[cbPayType.ItemIndex])
  else
    (FilterObj as TPaymentsFilterObj).PayTypeCode := 0;
end;

procedure TPaymentsFilterFrame.DisableFilter;
begin
  inherited;
  gbPayType.Collapsed := true;
end;

procedure TPaymentsFilterFrame.FillPayTypes;
begin
  // Заполняем список видов оплат
  if FPayTypes <> nil then
    FreeAndNil(FPayTypes);
  FPayTypes := TConfigManager.Instance.StandardDics.dePayKind.CreateList;
  cbPayType.Items.Assign(FPayTypes);
end;

initialization

PaymentsDateList := TStringList.Create;
PaymentsDateList.Add('Поступления оплаты');
//PaymentsDateList.Add('Изменения заказа');
//PaymentsDateList.Add('Фактического завершения');
//PaymentsDateList.Add('Закрытия заказа');
//PaymentsDateList.Add('Последней оплаты заказа');

finalization

PaymentsDateList.Free;

end.
