unit PmDocEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseEditForm, JvComponentBase, StdCtrls, DBCtrls, JvFormPlacement,
  Buttons, JvExControls, JvDBLookup, JvExMask, JvToolEdit, JvMaskEdit,
  JvCheckedMaskEdit, JvDatePickerEdit, JvDBDatePickerEdit, Mask,
  DB, GridsEh, DBGridEh, MyDBGridEh,

  NotifyEvent, PmDocument, PmContragent, DBGridEhGrouping;

type
  TDocEditForm = class(TBaseEditForm)
    Label1: TLabel;
    edDocNum: TDBEdit;
    deDate: TJvDBDatePickerEdit;
    Label2: TLabel;
    lbContragent: TLabel;
    lkContragent: TJvDBLookupCombo;
    btNewContragent: TSpeedButton;
    Label4: TLabel;
    memoNotes: TDBMemo;
    dgItems: TMyDBGridEh;
    btNewItem: TBitBtn;
    btEditItem: TBitBtn;
    btDelItem: TBitBtn;
    Label6: TLabel;
    edUserName: TDBEdit;
    Label7: TLabel;
    dsContragent: TDataSource;
    Label5: TLabel;
    lkPayType: TJvDBLookupCombo;
    dsPayType: TDataSource;
    procedure btNewContragentClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btNewItemClick(Sender: TObject);
    procedure btEditItemClick(Sender: TObject);
    procedure btDelItemClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FDoc: TDocument;
    FOnAddItem: TNotifyEvent;
    FOnEditItem: TNotifyEvent;
    FOnRemoveItem: TNotifyEvent;
    FItemsAfterScrollID: TNotifyHandlerID;
  protected
    function ValidateForm: boolean; override;
    procedure ItemsAfterScroll(Sender: TObject);
    function GetContragents: TContragents; virtual; abstract;
    procedure SetDoc(Value: TDocument); virtual;
  public
    property Document: TDocument read FDoc write SetDoc;
    property OnAddItem: TNotifyEvent read FOnAddItem write FOnAddItem;
    property OnEditItem: TNotifyEvent read FOnEditItem write FOnEditItem;
    property OnRemoveItem: TNotifyEvent read FOnRemoveItem write FOnRemoveItem;
  end;

  TDocEditFormClass = class of TDocEditForm;

implementation

{$R *.dfm}

uses RDBUtils, MainData, PmContragentListForm, StdDic,
  PmConfigManager, PmEntity;

procedure TDocEditForm.btDelItemClick(Sender: TObject);
begin
  FOnRemoveItem(Self);
end;

procedure TDocEditForm.btEditItemClick(Sender: TObject);
begin
  FOnEditItem(Self);
end;

procedure TDocEditForm.btNewContragentClick(Sender: TObject);
var
  i: integer;
begin
  i := NvlInteger(lkContragent.KeyValue);
  if i = 0 then i := TContragents.NoNameKey;
  i := ExecContragentSelect(GetContragents, {CurCustomer=} i, {SelectMode} true);
  if i = custNoName then i := TContragents.NoNameKey;
  if (i <> custError) and (i <> custCancel) then
    lkContragent.KeyValue := i;
end;

procedure TDocEditForm.btNewItemClick(Sender: TObject);
begin
  FOnAddItem(Self);
end;

procedure TDocEditForm.FormCreate(Sender: TObject);
var
  Contr: TEntity;
begin
  Contr := GetContragents;
  if Contr <> nil then
  begin
    // обновляет, если надо
    GetContragents.Reload;
    dsContragent.DataSet := GetContragents.DataSet;
  end
  else
  begin
    lkContragent.Visible := false;
    lbContragent.Visible := false;
    btNewContragent.Visible := false;
  end;
  dsPayType.DataSet := TConfigManager.Instance.StandardDics.dePayKind.DicItems;
end;

procedure TDocEditForm.FormDestroy(Sender: TObject);
begin
  if FItemsAfterScrollID <> TNotifier.EmptyID then
  begin
    FDoc.Items.AfterScrollNotifier.UnregisterHandler(FItemsAfterScrollID);
    FItemsAfterScrollID := '';
  end;
end;

procedure TDocEditForm.SetDoc(Value: TDocument);
begin
  FDoc := Value;
  edDocNum.DataSource := FDoc.DataSource;
  deDate.DataSource := FDoc.DataSource;
  if FDoc.DataSet.FindField(lkContragent.DataField) <> nil then
    lkContragent.DataSource := FDoc.DataSource;
  //memoNotes.DataSource := FSaleDocs.DataSource;
  lkPayType.DataSource := FDoc.DataSource;
  edUserName.DataSource := FDoc.DataSource;
  dgItems.DataSource := FDoc.Items.DataSource;
  //edTrustSerie.DataSource := FDoc.DataSource;
  //edTrustNum.DataSource := FDoc.DataSource;
  //deTrustDate.DataSource := FDoc.DataSource;
  if FItemsAfterScrollID <> TNotifier.EmptyID then
  begin
    FDoc.Items.AfterScrollNotifier.UnregisterHandler(FItemsAfterScrollID);
    FItemsAfterScrollID := '';
  end;
  FItemsAfterScrollID := FDoc.Items.AfterScrollNotifier.RegisterHandler(ItemsAfterScroll);
end;

function TDocEditForm.ValidateForm: boolean;
begin
  ActiveControl := btOk;
  Result := Trim(FDoc.DocNum) <> '';
  if not Result then
  begin
    ActiveControl := edDocNum;
    raise Exception.Create('Пожалуйста, укажите номер документа');
  end
  else
  begin
    Result := NvlDateTime(FDoc.DocDate) <> 0;
    if not Result then
    begin
      ActiveControl := deDate;
      raise Exception.Create('Пожалуйста, укажите дату документа');
    end
    else
    begin
      Result := not lkContragent.Visible or not VarIsNull(lkContragent.KeyValue);
      if not Result then
      begin
        ActiveControl := lkContragent;
        raise Exception.Create('Пожалуйста, укажите контрагента');
      end;
    end;
  end;
end;

procedure TDocEditForm.ItemsAfterScroll(Sender: TObject);
begin
  btEditItem.Enabled := not FDoc.Items.IsEmpty;
  btDelItem.Enabled := btEditItem.Enabled;
end;

end.
