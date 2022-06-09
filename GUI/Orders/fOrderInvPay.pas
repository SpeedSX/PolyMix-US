unit fOrderInvPay;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, JvExExtCtrls, JvNetscapeSplitter, GridsEh,
  DBGridEh, MyDBGridEh, JvFormPlacement, StdCtrls, Buttons,

  NotifyEvent, PmOrderInvoiceItems, PmOrderPayments, Menus, DBGridEhGrouping;

type
  TOrderInvPayFrame = class(TFrame)
    paPayments: TPanel;
    paInvoices: TPanel;
    spJobDay: TJvNetscapeSplitter;
    dgOrderInvoiceItems: TMyDBGridEh;
    dgOrderPayments: TMyDBGridEh;
    paEditPayments: TPanel;
    btDelItem: TBitBtn;
    btEditItem: TBitBtn;
    paHdrOrder: TPanel;
    Panel2: TPanel;
    Label2: TLabel;
    pmInvoices: TPopupMenu;
    miOrderEditInvoice: TMenuItem;
    miOrderMakeInvoice: TMenuItem;
    miFind1C: TMenuItem;
    btMakeInvoice: TBitBtn;
    btLocateInvoice: TBitBtn;
    Panel3: TPanel;
    Label3: TLabel;
    btPayInvoice: TBitBtn;
    miOrderPayInvoice: TMenuItem;
    procedure btNewItemClick(Sender: TObject);
    procedure btDelItemClick(Sender: TObject);
    procedure btEditItemClick(Sender: TObject);
    procedure dgOrderEditInvoiceClick(Sender: TObject);
    procedure dgInvoicesColumns4GetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure dgOrderInvoiceItemsDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure miOrderMakeInvoiceClick(Sender: TObject);
    procedure btPayInvoiceClick(Sender: TObject);
    procedure dgOrderInvoiceItemsColumnsInvoiceNumGetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure FrameResize(Sender: TObject);
  private
    FOrderInvoiceItems: TOrderInvoiceItems;
    FOrderPayments: TOrderPayments;
    FUpdatingControls: boolean;
    FOnAddInvoice: TNotifyEvent;
    FOnPayInvoice: TNotifyEvent;
    FOnAddItem: TNotifyEvent;
    FOnEditItem: TNotifyEvent;
    FOnEditInvoice: TNotifyEvent;
    FOnRemoveItem: TNotifyEvent;
    FPreviewMode: boolean;
    //FInvoiceAfterScrollID: TNotifyHandlerID;
    //FInvoiceItemsOpenID: TNotifyHandlerID;
    procedure SetPreviewMode(Value: boolean);
  protected
    procedure UpdateControlsEnabled;
  public
    constructor Create(Owner: TComponent;
      _OrderInvoiceItems: TOrderInvoiceItems; _OrderPayments: TOrderPayments);
    procedure SaveSettings;
    procedure LoadSettings;
    procedure SettingsChanged;

    property OnEditInvoice: TNotifyEvent read FOnEditInvoice write FOnEditInvoice;
    property OnAddInvoice: TNotifyEvent read FOnAddInvoice write FOnAddInvoice;
    property OnPayInvoice: TNotifyEvent read FOnPayInvoice write FOnPayInvoice;
    property OnAddItem: TNotifyEvent read FOnAddItem write FOnAddItem;
    property OnEditItem: TNotifyEvent read FOnEditItem write FOnEditItem;
    property OnRemoveItem: TNotifyEvent read FOnRemoveItem write FOnRemoveItem;

    property OrderInvoiceItems: TOrderInvoiceItems read FOrderInvoiceItems;
    property OrderPayments: TOrderPayments read FOrderPayments;
    property PreviewMode: boolean read FPreviewMode write SetPreviewMode;
  end;

implementation

uses JvJVCLUtils,

  PmUtils, CalcSettings, CalcUtils, PmEntSettings, PmAccessManager, PmInvoice;

{$R *.dfm}

constructor TOrderInvPayFrame.Create(Owner: TComponent;
  _OrderInvoiceItems: TOrderInvoiceItems; _OrderPayments: TOrderPayments);
begin
  inherited Create(Owner);
  //dgInvoices.DataSource := FInvoices.DataSource;
  //dgInvoiceItems.DataSource := FInvoices.Items.DataSource;

  //FInvoiceItemsOpenID := FInvoices.Items.OpenNotifier.RegisterHandler(UpdateControlsEnabled);
  FOrderInvoiceItems := _OrderInvoiceItems;
  FOrderPayments := _OrderPayments;
  dgOrderPayments.DataSource := FOrderPayments.DataSource;
  dgOrderInvoiceItems.DataSource := FOrderInvoiceItems.DataSource;
  dgOrderInvoiceItems.FieldColumns['SyncState'].Visible := EntSettings.ShowSyncInfo;

  UpdateControlsEnabled;

  {FInvoiceAfterScrollID := FOrderInvoiceItems.AfterScrollNotifier.RegisterHandler(InvoiceAfterScroll);
  if FOrderInvoiceItems.Active then
    InvoiceAfterScroll(nil);}

  // установка стиля
  TSettingsManager.Instance.XPInitComponent(pmInvoices);
  TSettingsManager.Instance.XPActivateMenuItem(pmInvoices.Items, true);
  {TSettingsManager.Instance.XPActivateMenuItem(miOrderEditInvoice, true);
  TSettingsManager.Instance.XPActivateMenuItem(miOrderMakeInvoice, true);
  TSettingsManager.Instance.XPActivateMenuItem(miOrderPayInvoice, true);
  TSettingsManager.Instance.XPActivateMenuItem(miFind1C, true);}
end;

procedure TOrderInvPayFrame.UpdateControlsEnabled;
var
  ap, vi, mi: boolean;
begin
  // разрешаем контролы в зависимости от прав пользователей
  ap := AccessManager.CurUser.AddPayments;
  vi := AccessManager.CurUser.ViewInvoices;
  mi := AccessManager.CurUser.AddInvoices;
  btMakeInvoice.Enabled := vi and mi;
  miOrderMakeInvoice.Enabled := btMakeInvoice.Enabled;
  btLocateInvoice.Enabled := vi;
  miOrderEditInvoice.Enabled := btLocateInvoice.Enabled;
  btPayInvoice.Enabled := ap and vi;
  miOrderPayInvoice.Enabled := btPayInvoice.Enabled;
  paEditPayments.Visible:= AccessManager.CurUser.EditPayments;
end;

procedure TOrderInvPayFrame.btDelItemClick(Sender: TObject);
begin
  if dgOrderPayments.DataSource.DataSet.RecordCount>0 then

  if MessageDlg('Удалить оплату?', mtWarning, mbYesNo, 0, mbNo) = mrYes then
  begin
     if Assigned(OrderPayments) then     
        OrderPayments.DeleteAndApply;
     OrderInvoiceItems.Reload;
  end;
//  if Assigned(FOnRemoveItem) then
//    FOnRemoveItem(Self);
end;

procedure TOrderInvPayFrame.btEditItemClick(Sender: TObject);
begin
  if Assigned(FOnEditItem) then
    FOnEditItem(Self);
end;

procedure TOrderInvPayFrame.btNewItemClick(Sender: TObject);
begin
  if Assigned(FOnAddItem) then
    FOnAddItem(Self);
end;

procedure TOrderInvPayFrame.dgInvoicesColumns4GetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  if FOrderInvoiceItems.ItemDebt > 0 then
    Params.Font.Color := clRed
  else
    Params.Font.Color := clWindowText;
end;

procedure TOrderInvPayFrame.dgOrderEditInvoiceClick(Sender: TObject);
begin
  if Assigned(FOnEditInvoice) then
    FOnEditInvoice(Self);
end;

procedure TOrderInvPayFrame.dgOrderInvoiceItemsColumnsInvoiceNumGetCellParams(
  Sender: TObject; EditMode: Boolean; Params: TColCellParamsEh);
begin
  if FPreviewMode then
  begin
    if FOrderInvoiceItems.InvoiceNumber <> '' then
      Params.Text := FOrderInvoiceItems.InvoiceNumber + #13#10
        + FormatDateTime(StdDateFmt, FOrderInvoiceItems.InvoiceDate)
    else
      Params.Text := '';
  end
  else
    Params.Text := FOrderInvoiceItems.InvoiceNumber;
end;

procedure TOrderInvPayFrame.dgOrderInvoiceItemsDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
//var
//  Bmp: TBitmap;
begin
  try
    if (CompareText(Column.FieldName, 'SyncState') = 0) and (Column.Field <> nil) then
      DrawSyncState(Sender as TGridClass, Column, Rect)
    else if (CompareText(Column.FieldName, TOrderInvoiceItems.F_PayState) = 0) and (Column.Field <> nil) then
      DrawPayState(Sender as TGridClass, Column, Rect);
  except
  end;
end;

procedure TOrderInvPayFrame.FrameResize(Sender: TObject);
begin
  if paInvoices.Visible and paPayments.Visible then
    paPayments.Height := Height div 2;
end;

procedure TOrderInvPayFrame.SaveSettings;
begin
  TSettingsManager.Instance.SaveGridLayout(dgOrderInvoiceItems, 'OrderInvPay_Items');
  TSettingsManager.Instance.SaveGridLayout(dgOrderPayments, 'OrderInvPay_Payments');
  TSettingsManager.Instance.Storage.WriteInteger(iniInterface + '\OrderInvPay_paPaymentsHeight',
    paPayments.Height);
  //TSettingsManager.Instance.Storage.WriteInteger(iniInterface + '\CustomerPayments_ByCustomer',
  //  Ord(cbCustomer.Checked));
end;

procedure TOrderInvPayFrame.LoadSettings;
begin
  FUpdatingControls := true;
  try
    //dgPayments.LoadFromAppStore(MainAppStorage, 'CustomerPayments_Payments');
    TSettingsManager.Instance.LoadGridLayout(dgOrderInvoiceItems, 'OrderInvPay_Items');
    TSettingsManager.Instance.LoadGridLayout(dgOrderPayments, 'OrderInvPay_Payments');
    paPayments.Height := TSettingsManager.Instance.Storage.ReadInteger(iniInterface + '\OrderInvPay_paPaymentsHeight',
      paPayments.Height);
    //cbCustomer.Checked := TSettingsManager.Instance.Storage.ReadString(iniInterface + '\CustomerPayments_ByCustomer',
    //  '1') = '1';
  finally
    FUpdatingControls := false;
  end;
end;

procedure TOrderInvPayFrame.miOrderMakeInvoiceClick(Sender: TObject);
begin
  if Assigned(FOnAddInvoice) then
    FOnAddInvoice(Self);
end;

procedure TOrderInvPayFrame.btPayInvoiceClick(Sender: TObject);
begin
  if Assigned(FOnPayInvoice) then
    FOnPayInvoice(Self);
end;

procedure TOrderInvPayFrame.SettingsChanged;
begin

end;

procedure TOrderInvPayFrame.SetPreviewMode(Value: boolean);
begin
  FPreviewMode := Value;
  //dgOrderInvoiceItems.FieldColumns[TOrderInvoiceItems.F_PayTypeName].Visible := not FPreviewMode;
  dgOrderInvoiceItems.FieldColumns[TOrderInvoiceItems.F_ItemText].Visible := not FPreviewMode;
  //dgOrderInvoiceItems.FieldColumns[TOrderInvoiceItems.F_ContragentName].Visible := not FPreviewMode;
  dgOrderInvoiceItems.FieldColumns[TOrderInvoiceItems.F_SyncState].Visible := not FPreviewMode;
  dgOrderInvoiceItems.FieldColumns[TOrderInvoiceItems.F_Quantity].Visible := not FPreviewMode;
  dgOrderInvoiceItems.FieldColumns[TInvoices.F_InvoiceDate].Visible := not FPreviewMode;
  if FPreviewMode then
  begin
    dgOrderInvoiceItems.RowLines := 1;
  end
  else
  begin
    dgOrderInvoiceItems.RowLines := 0;
  end;
  dgOrderPayments.FieldColumns[TOrderInvoiceItems.F_ItemText].Visible := not FPreviewMode;
  dgOrderPayments.FieldColumns[TOrderPayments.F_ContragentName].Visible := not FPreviewMode;
end;

end.
