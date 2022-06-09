unit fInvoiceFilterFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseFilter, ImgList, JvImageList, JvExControls, JvxCheckListBox,
  StdCtrls, JvDBLookup, Mask, JvExMask, JvToolEdit, JvExStdCtrls, JvEdit,
  JvValidateEdit, JvgGroupBox, Buttons, ExtCtrls, DBCtrlsEh, DB;

type
  TInvoicesFilterFrame = class(TBaseFilterFrame)
    gbPayType: TJvgGroupBox;
    cbPayType: TComboBox;
    gbInvoiceNum: TJvgGroupBox;
    edInvoiceNum: TEdit;
    gbPayer: TJvgGroupBox;
    btPayerSel: TSpeedButton;
    lcPayer: TJvDBLookupCombo;
    procedure cbPayTypeChange(Sender: TObject);
    procedure btPayerSelClick(Sender: TObject);
    procedure gbPayerClick(Sender: TObject);
    procedure cbInvoiceNumClick(Sender: TObject);
  protected
    FPayTypes: TStringList;
    procedure DoRestoreControls; override;
    procedure DoSaveControls; override;
    procedure EnableDBControls; override;
    procedure DisableDBControls; override;
    procedure FillPayTypes;
    procedure DoOnCfgChanged(Sender: TObject); override;
    function SupportsOrderState: boolean; override;
    function SupportsPayState: boolean; override;
    function GetDateList: TStringList; override;
    procedure DisableFilter; override;
    function GetCustomerKey: Integer; override;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure Activate; override;
  end;

implementation

uses RDBUtils, MainFilter, StdDic, DicObj, PmConfigManager,
  PmContragent, PmContragentListForm, MainData, PmEntSettings, PmInvoice;

{$R *.dfm}

var
  InvoicesDateList: TStringList;

procedure TInvoicesFilterFrame.btPayerSelClick(Sender: TObject);
var
  i, c: integer;
begin
  i := custError;
  if VarIsNull(lcPayer.KeyValue) then
    c := TContragents.NoNameKey
  else
    c := lcPayer.KeyValue;
  try
    i := ExecContragentSelect(Customers, {CurCustomer} c, {SelectMode=} true);
  except end;
  // custNoName надо обрабатывать иначе ?
  if (i <> custError) and (i <> custNoName) and (i <> custCancel) then
    lcPayer.KeyValue := i;
end;

procedure TInvoicesFilterFrame.cbPayTypeChange(Sender: TObject);
begin
  // проверяем, изменилось ли что-нибудь
  if {((FilterObj as TInvoicesFilterObj).PayTypeChecked <> not gbPayType.Collapsed)
     or }(cbPayType.ItemIndex >= 0) then
      ApplyFilter
  else
    SaveControls;
end;

constructor TInvoicesFilterFrame.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  FillPayTypes;
  gbPayState.Visible := not EntSettings.NewInvoicePayState;
end;

destructor TInvoicesFilterFrame.Destroy;
begin
  FreeAndNil(FPayTypes);
  inherited;
end;

procedure TInvoicesFilterFrame.DoOnCfgChanged(Sender: TObject);
begin
  inherited;
  FillPayTypes;
end;

function TInvoicesFilterFrame.SupportsOrderState: boolean;
begin
  Result := true;
end;

function TInvoicesFilterFrame.SupportsPayState: boolean;
begin
  Result := true;
end;

function TInvoicesFilterFrame.GetCustomerKey: Integer;
begin
  Result := (FEntity as TInvoices).CustomerID;
end;

function TInvoicesFilterFrame.GetDateList: TStringList;
begin
  Result := InvoicesDateList;
end;

procedure TInvoicesFilterFrame.Activate;
begin
  inherited;
  gbProcessState.Visible := false;
  gbProcess.Visible := false;
  //gbPayState.Visible := false;
  gbOrdState.Visible := false;
  gbComment.Visible := false;
  gbNum.Visible := false;
  gbOrderKind.Visible := false;
  gbPayer.Visible := EntSettings.ShowInvoicePayerFilter;
  gbCust.Visible := EntSettings.ShowInvoiceCustomerFilter;
end;

procedure TInvoicesFilterFrame.FillPayTypes;
begin
  // Заполняем список видов оплат
  if FPayTypes <> nil then
    FreeAndNil(FPayTypes);
  FPayTypes := TConfigManager.Instance.StandardDics.dePayKind.CreateList;
  cbPayType.Items.Assign(FPayTypes);
end;

procedure TInvoicesFilterFrame.cbInvoiceNumClick(Sender: TObject);
begin
  ApplyFilter;
end;

procedure TInvoicesFilterFrame.gbPayerClick(Sender: TObject);
begin
  UpdateCustomerControls(gbPayer, lcPayer, btPayerSel);
end;

procedure TInvoicesFilterFrame.DisableFilter;
begin
  inherited;
  gbPayType.Collapsed := true;
  gbPayer.Collapsed := true;
end;

procedure TInvoicesFilterFrame.DoRestoreControls;
var
  i, c: integer;
  Found: boolean;
  InvoiceNum: variant;
begin
  inherited;
  // плательщик
  gbPayer.Collapsed := not (FilterObj as TInvoicesFilterObj).PayerChecked;
  gbPayerClick(nil);
  if (FilterObj as TInvoicesFilterObj).PayerKeyValue > 0 then
    lcPayer.KeyValue := (FilterObj as TInvoicesFilterObj).PayerKeyValue;
  // вид оплаты
  gbPayType.Collapsed := not (FilterObj as TInvoicesFilterObj).PayTypeChecked;
  c := (FilterObj as TInvoicesFilterObj).PayTypeCode;
  Found := false;
  for i := 0 to Pred(FPayTypes.Count) do
    if integer(FPayTypes.Objects[i]) = c then
    begin
      Found := true;
      break;
    end;
  if Found and (i < cbPayType.Items.Count) then
    cbPayType.ItemIndex := i;
  // номер счета
  InvoiceNum := (FilterObj as TInvoicesFilterObj).InvoiceNum;
  gbInvoiceNum.Collapsed := NvlString(InvoiceNum) = '';
  if not gbInvoiceNum.Collapsed then
    edInvoiceNum.Text := InvoiceNum;
end;

procedure TInvoicesFilterFrame.DoSaveControls;
begin
  inherited;
  // плательщик
  (FilterObj as TInvoicesFilterObj).PayerChecked := not gbPayer.Collapsed;
  if VarIsNull(lcPayer.KeyValue) then
    (FilterObj as TInvoicesFilterObj).PayerKeyValue := TContragents.NoNameKey
  else
    (FilterObj as TInvoicesFilterObj).PayerKeyValue := lcPayer.KeyValue;
  // вид оплаты
  (FilterObj as TInvoicesFilterObj).PayTypeChecked := not gbPayType.Collapsed;
  if cbPayType.ItemIndex >= 0 then
    (FilterObj as TInvoicesFilterObj).PayTypeCode := integer(FPayTypes.Objects[cbPayType.ItemIndex])
  else
    (FilterObj as TInvoicesFilterObj).PayTypeCode := 0;
  // номер счета
  if gbInvoiceNum.Collapsed then
    (FilterObj as TInvoicesFilterObj).InvoiceNum := null
  else
    (FilterObj as TInvoicesFilterObj).InvoiceNum := Trim(edInvoiceNum.Text);
end;

procedure TInvoicesFilterFrame.EnableDBControls;
begin
  {if dm <> nil then
  begin
    if lcPayer.LookupSource <> dm.dsCust then
      lcPayer.LookupSource := dm.dsCust;
  end;}
  inherited;
end;

procedure TInvoicesFilterFrame.DisableDBControls;
begin
  lcPayer.LookupSource := nil;
  inherited;
end;

initialization

InvoicesDateList := TStringList.Create;
InvoicesDateList.Add('Создания счета');
InvoicesDateList.Add('Создания заказа');
//InvoicesDateList.Add('Изменения счета');
//InvoicesDateList.Add('Фактического завершения');
//InvoicesDateList.Add('Закрытия заказа');
//InvoicesDateList.Add('Последней оплаты заказа');

finalization

InvoicesDateList.Free;

end.
