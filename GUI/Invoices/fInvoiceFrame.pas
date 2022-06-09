unit fInvoiceFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseFrame, ExtCtrls, JvExExtCtrls, JvNetscapeSplitter, GridsEh,
  DBGridEh, MyDBGridEh, JvFormPlacement, StdCtrls, Buttons,

  NotifyEvent, PmEntity, PmInvoice, fBaseFilter, DBGridEhGrouping;

type
  TInvoicesFrame = class(TBaseFrame)
    Panel1: TPanel;
    paInvoiceItems: TPanel;
    paInvoices: TPanel;
    spJobDay: TJvNetscapeSplitter;
    dgInvoices: TMyDBGridEh;
    dgInvoiceItems: TMyDBGridEh;
    Panel9: TPanel;
    btNewItem: TBitBtn;
    btDelItem: TBitBtn;
    btEditItem: TBitBtn;
    InvoiceTimer: TTimer;
    procedure btNewItemClick(Sender: TObject);
    procedure btDelItemClick(Sender: TObject);
    procedure btEditItemClick(Sender: TObject);
    procedure dgInvoicesDblClick(Sender: TObject);
    procedure dgInvoicesColumns4GetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure dgInvoiceItemsColumns6GetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure dgInvoicesDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure dgInvoicesColumns0GetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure dgInvoicesTitleBtnClick(Sender: TObject; ACol: Integer;
      Column: TColumnEh);
  private
    //FInvoices: TInvoices;
    FUpdatingControls: boolean;
    {FOnAddItem: TNotifyEvent;
    FOnEditItem: TNotifyEvent;}
    FOnEditInvoice: TNotifyEvent;
    //FOnRemoveItem: TNotifyEvent;
    FInvoiceItemsOpenID: TNotifyHandlerID;
    function IsCurrentForSync: boolean;
  protected
    procedure UpdateInvoiceItemsControls(Sender: TObject);
    function Invoices: TInvoices;
    procedure SetDefaultSortMarkers;
  public
    constructor Create(Owner: TComponent; _Invoices: TEntity); override;
    destructor Destroy; override;
    procedure SaveSettings; override;
    procedure LoadSettings; override;
    procedure SettingsChanged; override;
    function CreateFilterFrame: TBaseFilterFrame; override;

    property OnEditInvoice: TNotifyEvent read FOnEditInvoice write FOnEditInvoice;
    {property OnAddItem: TNotifyEvent read FOnAddItem write FOnAddItem;
    property OnEditItem: TNotifyEvent read FOnEditItem write FOnEditItem;
    property OnRemoveItem: TNotifyEvent read FOnRemoveItem write FOnRemoveItem;}
  end;

implementation

uses JvJVCLUtils,

  PmUtils, MainFilter, fInvoiceFilterFrame, CalcSettings, CalcUtils, PmEntSettings,
  PmInvoiceItems, RDbUtils, PmConfigManager;

{$R *.dfm}

constructor TInvoicesFrame.Create(Owner: TComponent; _Invoices: TEntity);
var
  I: Integer;
begin
  inherited Create(Owner, _Invoices{'Invoices'});
  //FInvoices := _Invoices;

  FilterObject := Invoices.Criteria;
  FilterFrame.Entity := Invoices;

  dgInvoices.DataSource := Invoices.DataSource;
  dgInvoiceItems.DataSource := Invoices.Items.DataSource;

  //FInvoicesOpenID := FInvoices.OpenNotifier.RegisterHandler(UpdateInvoiceControls);
  //FInvoicesAfterScrollID := FInvoices.AfterScrollNotifier.RegisterHandler(UpdateInvoiceControls);
  FInvoiceItemsOpenID := Invoices.Items.OpenNotifier.RegisterHandler(UpdateInvoiceItemsControls);
  //FInvoiceItemsCloseID := FInvoiceItems.CloseNotifier.RegisterHandler(UpdateInvoiceControls);
  dgInvoices.FieldColumns[TInvoices.F_SyncState].Visible := EntSettings.ShowSyncInfo;
  SetDefaultSortMarkers;

  // Если нет постраничной загрузки, то локальная сортировка позволит использовать любые столбцы
  // Пока отключено, т.к. при сортировке по дате или номеру надо использовать хитрый индекс. см. запрос.
  {if Options.ShowTotalInvoices then
  begin
    for I := 0 to dgInvoices.Columns.Count - 1 do
      dgInvoices.Columns[I].Title.TitleButton := true;
    dgInvoices.SortLocal := true;
    dgInvoices.OptionsEh := dgInvoices.OptionsEh + [dghMultiSortMarking];
  end;}
end;

destructor TInvoicesFrame.Destroy;
begin
  Invoices.GetItemsNoOpen.OpenNotifier.UnregisterHandler(FInvoiceItemsOpenID);
  inherited;
end;

procedure TInvoicesFrame.btDelItemClick(Sender: TObject);
begin
  //FOnRemoveItem(Self);
end;

procedure TInvoicesFrame.btEditItemClick(Sender: TObject);
begin
  //FOnEditItem(Self);
end;

procedure TInvoicesFrame.btNewItemClick(Sender: TObject);
begin
  //FOnAddItem(Self);
end;

function TInvoicesFrame.CreateFilterFrame: TBaseFilterFrame;
begin
  Result := TInvoicesFilterFrame.Create(Self);
end;

procedure TInvoicesFrame.dgInvoiceItemsColumns6GetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  if Invoices.Items.ItemDebt > 0 then
    Params.Font.Color := clRed
  else
    Params.Font.Color := clWindowText;
end;

procedure TInvoicesFrame.dgInvoicesColumns0GetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  Params.Text := ''
end;

procedure TInvoicesFrame.dgInvoicesColumns4GetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  if Invoices.InvoiceDebt > 0 then
    Params.Font.Color := clRed
  else
    Params.Font.Color := clWindowText;
end;

procedure TInvoicesFrame.dgInvoicesDblClick(Sender: TObject);
begin
  FOnEditInvoice(Self);
end;

function TInvoicesFrame.IsCurrentForSync: boolean;
begin
  if not Invoices.IsEmpty then
    Result := NvlBoolean(TConfigManager.Instance.StandardDics.dePayKind.ItemValue[Invoices.PayType, 3])
  else
    Result := false;
end;

procedure TInvoicesFrame.dgInvoicesDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  RectCopy: TRect;
begin
  if (Column.Field <> nil) then
  try
    if (CompareText(Column.FieldName, TInvoices.F_SyncState) = 0) then
    begin
      if IsCurrentForSync then
        DrawSyncState(Sender as TGridClass, Column, Rect);
    end
    else if (CompareText(Column.FieldName, TInvoices.F_PayState) = 0) then
      DrawPayState(Sender as TGridClass, Column, Rect)
    else if (CompareText(Column.FieldName, TInvoiceItems.F_ItemText) = 0) then
    begin
      if Invoices.HasManyItems then
      begin
        RectCopy := Rect;
        DrawManyItemsIcon(Sender as TGridClass, Column, RectCopy);
        dgInvoices.DefaultDrawColumnCell(RectCopy, DataCol, Column, State);
      end else
        dgInvoices.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
  except end;
end;

procedure TInvoicesFrame.SetDefaultSortMarkers;
begin
  // На самом деле отображается только второй маркер, если не включить мультисорт
  dgInvoices.FieldColumns[TInvoices.F_InvoiceNum].Title.SortMarker := smDownEh;
  dgInvoices.FieldColumns[TInvoices.F_InvoiceDate].Title.SortMarker := smDownEh;
end;

procedure TInvoicesFrame.dgInvoicesTitleBtnClick(Sender: TObject; ACol: Integer;
  Column: TColumnEh);
begin
  // Есди не включена постраничная загрузка, то используется локальная сортировка
  //if not Options.ShowTotalInvoices then
    if Column.Field <> nil then
    begin
      if Column.Field.Origin <> '' then
        Invoices.SetSortOrder(Column.Field.Origin, true)
      else
        Invoices.SetSortOrder(Column.Field.FieldName, true);
      dgInvoices.SortMarkedColumns.Clear; // Если включить мультисорт, то это не работает!
      if (Column.Field.FieldName = TInvoices.F_InvoiceDate) or (Column.Field.FieldName = TInvoices.F_InvoiceNum) then
        SetDefaultSortMarkers
      else
        Column.Title.SortMarker := smDownEh;
    end;
end;

procedure TInvoicesFrame.SaveSettings;
begin
  inherited;
  TSettingsManager.Instance.SaveGridLayout(dgInvoices, 'Invoices_Invoices');
  TSettingsManager.Instance.SaveGridLayout(dgInvoiceItems, 'Invoices_InvoiceItems');
  TSettingsManager.Instance.Storage.WriteInteger(iniInterface + '\Invoices_paInvoiceItemsHeight',
    paInvoiceItems.Height);
  //TSettingsManager.Instance.Storage.WriteInteger(iniInterface + '\CustomerPayments_ByCustomer',
  //  Ord(cbCustomer.Checked));
end;

procedure TInvoicesFrame.LoadSettings;
begin
  FUpdatingControls := true;
  try
    inherited;
    //dgPayments.LoadFromAppStore(MainAppStorage, 'CustomerPayments_Payments');
    TSettingsManager.Instance.LoadGridLayout(dgInvoices, 'Invoices_Invoices');
    TSettingsManager.Instance.LoadGridLayout(dgInvoiceItems, 'Invoices_InvoiceItems');
    paInvoiceItems.Height := TSettingsManager.Instance.Storage.ReadInteger(iniInterface + '\Invoices_paInvoiceItemsHeight',
      paInvoiceItems.Height);
    //cbCustomer.Checked := TSettingsManager.Instance.Storage.ReadString(iniInterface + '\CustomerPayments_ByCustomer',
    //  '1') = '1';
    SettingsChanged;
  finally
    FUpdatingControls := false;
  end;
end;

procedure TInvoicesFrame.SettingsChanged;
begin
  dgInvoices.SumList.Active := Options.ShowTotalInvoices;
  if Options.ShowTotalInvoices then
    dgInvoices.FooterRowCount := 1
  else
    dgInvoices.FooterRowCount := 0;
end;

procedure TInvoicesFrame.UpdateInvoiceItemsControls(Sender: TObject);
var
  inv: boolean;
begin
  inv := Invoices.Active and not Invoices.IsEmpty and Invoices.Items.Active;
  btNewItem.Enabled := inv;
  btEditItem.Enabled := inv and not Invoices.Items.IsEmpty;
  btDelItem.Enabled := btEditItem.Enabled;
end;

function TInvoicesFrame.Invoices: TInvoices;
begin
  Result := Entity as TInvoices;
end;

end.
