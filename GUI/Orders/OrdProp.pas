unit OrdProp;

interface

{$I Calc.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Mask, ExtCtrls, Buttons, JvCombobox,
  anycolor, JvGIF, JvToolEdit, DBClient,
  JvExMask, JvExControls, JvComponent, JvDBLookup, JvSpin, jvTypes,
  JvExStdCtrls,

  PmAccessManager, PmProviders, PmEntSettings, PmEntity, PmOrder, ComCtrls,
  JvEdit, JvValidateEdit, GridsEh, DBGridEh, MyDBGridEh, CalcUtils, fOrderNotesFrame,
  DBGridEhGrouping;

type
  TOrderProp = class(TForm)
    lbKind: TLabel;
    lbChar: TLabel;
    lbColor: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    edComment: TEdit;
    lkKind: TDBLookupComboBox;
    lkChar: TDBLookupComboBox;
    lkColor: TDBLookupComboBox;
    btNewCust: TSpeedButton;
    acColorBox: TAnyColorCombo;
    lkCustomer: TJvDBLookupCombo;
    lbColorBox: TLabel;
    lbFinish: TLabel;
    lbOrderState: TLabel;
    lkOrderState: TJvDBLookupCombo;
    lkPayState: TJvDBLookupCombo;
    lbPayState: TLabel;
    tmFinish: TMaskEdit;
    deFinish: TJvDateEdit;
    lbOrderKind: TLabel;
    cbOrderKind: TJvComboBox;
    lbManualPayState: TLabel;
    lkManualPayState: TJvDBLookupCombo;
    Bevel2: TBevel;
    pcOrderProp: TPageControl;
    tsCommon: TTabSheet;
    tsFinance: TTabSheet;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    tsAdvanced: TTabSheet;
    lbCreationDate: TLabel;
    deCreationDate: TJvDateEdit;
    edCreationTime: TMaskEdit;
    btChangeCreationDate: TBitBtn;
    lbNum: TLabel;
    btChangeNumber: TBitBtn;
    edNum: TEdit;
    dsTSKind: TDataSource;
    dsTSColors: TDataSource;
    dsTSChar: TDataSource;
    gbPayConditions: TGroupBox;
    Label1: TLabel;
    lbPrePay: TLabel;
    edPreShip: TJvValidateEdit;
    edPayDelay: TJvValidateEdit;
    Label3: TLabel;
    edPrePay: TJvValidateEdit;
    tsAttached: TTabSheet;
    Label4: TLabel;
    btAddFile: TBitBtn;
    btRemoveFile: TBitBtn;
    btOpenFile: TBitBtn;
    dgAttached: TMyDBGridEh;
    Label5: TLabel;
    memoFileDesc: TDBMemo;
    tsNotes: TTabSheet;
    Label7: TLabel;
    edComment2: TEdit;
    lkCreator: TDBLookupComboBox;
    lbCreator: TLabel;
    btSelectTemplate: TBitBtn;
    cbComposite: TCheckBox;
    dsCust: TDataSource;
    lbStartDate: TLabel;
    deStartDate: TJvDateEdit;
    edStartTime: TMaskEdit;
    btChangeStartDate: TBitBtn;
    btSetStartDateToCreationDate: TBitBtn;
    cbIsPayDelayInBankDays: TCheckBox;
    edExternalId: TEdit;
    lbExternalId: TLabel;
    procedure btOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btNewCustClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lkOrderStateGetImage(Sender: TObject; IsEmpty: Boolean;
      var Graphic: TGraphic; var TextMargin: Integer);
    procedure lkOrderStateCloseUp(Sender: TObject);
    procedure lkPayStateGetImage(Sender: TObject; IsEmpty: Boolean;
      var Graphic: TGraphic; var TextMargin: Integer);
    procedure FormCreate(Sender: TObject);
    procedure lkKindCloseUp(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbOrderKindChange(Sender: TObject);
    procedure deFinishChange(Sender: TObject);
    procedure lkPayStateChange(Sender: TObject);
    procedure lkManualPayStateGetImage(Sender: TObject; IsEmpty: Boolean;
      var Graphic: TGraphic; var TextMargin: Integer);
    procedure btChangeNumberClick(Sender: TObject);
    procedure btChangeCreationDateClick(Sender: TObject);
    procedure lkCustomerGetImage(Sender: TObject; IsEmpty: Boolean;
      var Graphic: TGraphic; var TextMargin: Integer);
    procedure lkCustomerChange(Sender: TObject);
    procedure btAddFileClick(Sender: TObject);
    procedure btRemoveFileClick(Sender: TObject);
    procedure btOpenFileClick(Sender: TObject);
    procedure btSelectTemplateClick(Sender: TObject);
    procedure btChangeStartDateClick(Sender: TObject);
    procedure btSetStartDateToCreationDateClick(Sender: TObject);
  private
    //OldIDKindChange: TFieldNotifyEvent;
    dsOrderState, dsPayState, dsManualPayState: TDataSource;
    //cdCurCust: TClientDataSet;
    //dsCurCust: TDataSource;
    FDataSet: TDataSet;
    FCreateKinds: TStringList;
    KindPerm: TCurKindPerm;
    FInsideOrder: boolean;
    FOrder: TOrder;
    FActivated: boolean;
    FReadOnly: Boolean;
    cdAutoPayState, cdManualPayState: TDataSet;
    LastCustomerID: variant;
    FOnAddAttachedFile: TNotifyEvent;
    FOnRemoveAttachedFile: TNotifyEvent;
    FOnOpenAttachedFile: TNotifyEvent;
    FOnGetCostVisible: TBooleanEvent;
    FOnAddNote: TNotifyEvent;
    FOnEditNote: TIntNotifyEvent;
    FOnDeleteNote: TIntNotifyEvent;
    FOnSelectTemplate: TNotifyEvent;
    //procedure SetDataSource(ds: TDataSource);
    procedure ControlsToDataSet;
    procedure DataSetToControls;
    function IsNewOrder: boolean;
    function FindKindIndex(k: integer): integer;
    procedure UpdateKindPerm;
    function InDraft: boolean;
    procedure SetOrder(_Order: TOrder);
    procedure GetStateImage(DataSource: TDataSource; States: TStringList;
      IsEmpty: Boolean; var Graphic: TGraphic; var TextMargin: Integer);
    property OrderDataSet: TDataSet read FDataSet;
    procedure SetOrderIDMode(IsBrief: boolean);
    procedure DoOnAddNote(Sender: TObject);
    procedure DoOnEditNote(OrderNoteID: integer);
    procedure DoOnDeleteNote(OrderNoteID: integer);

  public
    constructor Create(_Order: TOrder);
    procedure DisableDBControls;
    procedure EnableDBControls;

    property Order: TOrder read FOrder write SetOrder;
    property InsideOrder: boolean read FInsideOrder write FInsideOrder;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;

    property OnGetCostVisible: TBooleanEvent read FOnGetCostVisible write FOnGetCostVisible;
    property OnAddAttachedFile: TNotifyEvent read FOnAddAttachedFile write FOnAddAttachedFile;
    property OnRemoveAttachedFile: TNotifyEvent read FOnRemoveAttachedFile write FOnRemoveAttachedFile;
    property OnOpenAttachedFile: TNotifyEvent read FOnOpenAttachedFile write FOnOpenAttachedFile;
    property OnAddNote: TNotifyEvent read FOnAddNote write FOnAddNote;
    property OnEditNote: TIntNotifyEvent read FOnEditNote write FOnEditNote;
    property OnDeleteNote: TIntNotifyEvent read FOnDeleteNote write FOnDeleteNote;
    property OnSelectTemplate: TNotifyEvent read FOnSelectTemplate write FOnSelectTemplate;
  end;

  TOrderFormParamsProvider = class(TInterfacedObject, IOrderParamsProvider)
  private
    FOnAddAttachedFile: TNotifyEvent;
    FOnRemoveAttachedFile: TNotifyEvent;
    FOnOpenAttachedFile: TNotifyEvent;
    FOnGetCostVisible: TBooleanEvent;
    FOnAddNote: TNotifyEvent;
    FOnEditNote: TIntNotifyEvent;
    FOnDeleteNote: TIntNotifyEvent;
    FOnSelectTemplate: TNotifyEvent;
    procedure SetOnAddAttachedFile(Value: TNotifyEvent);
    procedure SetOnRemoveAttachedFile(Value: TNotifyEvent);
    procedure SetOnOpenAttachedFile(Value: TNotifyEvent);
    procedure SetOnGetCostVisible(Value: TBooleanEvent);
    procedure SetOnAddNote(Value: TNotifyEvent);
    procedure SetOnEditNote(Value: TIntNotifyEvent);
    procedure SetOnDeleteNote(Value: TIntNotifyEvent);
    procedure SetOnSelectTemplate(Value: TNotifyEvent);
    function GetOnAddAttachedFile: TNotifyEvent;
    function GetOnRemoveAttachedFile: TNotifyEvent;
    function GetOnOpenAttachedFile: TNotifyEvent;
    function GetOnGetCostVisible: TBooleanEvent;
    function GetOnAddNote: TNotifyEvent;
    function GetOnEditNote: TIntNotifyEvent;
    function GetOnDeleteNote: TIntNotifyEvent;
    function GetOnSelectTemplate: TNotifyEvent;
  public
    function ExecOrderProps(Order: TOrder; InsideOrder, ReadOnly: boolean): integer;
    property OnGetCostVisible: TBooleanEvent read GetOnGetCostVisible write SetOnGetCostVisible;
    property OnAddAttachedFile: TNotifyEvent read GetOnAddAttachedFile write SetOnAddAttachedFile;
    property OnRemoveAttachedFile: TNotifyEvent read GetOnRemoveAttachedFile write SetOnRemoveAttachedFile;
    property OnOpenAttachedFile: TNotifyEvent read GetOnOpenAttachedFile write SetOnOpenAttachedFile;
    property OnAddNote: TNotifyEvent read GetOnAddNote write SetOnAddNote;
    property OnEditNote: TIntNotifyEvent read GetOnEditNote write SetOnEditNote;
    property OnDeleteNote: TIntNotifyEvent read GetOnDeleteNote write SetOnDeleteNote;
    property OnSelectTemplate: TNotifyEvent read GetOnSelectTemplate write SetOnSelectTemplate;
  end;

var
  OrderProp: TOrderProp;
//  OrderFormParamsProvider: IOrderParamsProvider;

implementation

uses DateUtils, RDialogs, Dialogs, Variants, 

  MainData, PmContragentListForm, ADOError, PmStates, CalcSettings, StdDic,
  RDBUtils, PmContragent, PmContragentPainter, PmConfigManager, DicObj;

{$R *.DFM}

const
  sCompOrd = '<Составной заказ>';
  //sEmpCust = '<Замовник>';
  sEmpCust = '<Не указан>';

function TOrderFormParamsProvider.ExecOrderProps(Order: TOrder;
  InsideOrder, ReadOnly: boolean): integer;
begin
  OrderProp := TOrderProp.Create(Order);
  //MainXPMenu.InitComponent(OrderProp); так можно, но не понравилось на вид
  try
    OrderProp.InsideOrder := InsideOrder;
    OrderProp.ReadOnly := ReadOnly;
    OrderProp.OnAddAttachedFile := FOnAddAttachedFile;
    OrderProp.OnRemoveAttachedFile := FOnRemoveAttachedFile;
    OrderProp.OnOpenAttachedFile := FOnOpenAttachedFile;
    OrderProp.OnGetCostVisible := FOnGetCostVisible;
    OrderProp.OnAddNote := FOnAddNote;
    OrderProp.OnEditNote := FOnEditNote;
    OrderProp.OnDeleteNote := FOnDeleteNote;
    OrderProp.OnSelectTemplate := FOnSelectTemplate;
    Result := OrderProp.ShowModal;
  finally
    OrderProp.Free;
  end;
end;

procedure TOrderFormParamsProvider.SetOnAddAttachedFile(Value: TNotifyEvent);
begin
  FOnAddAttachedFile := Value;
end;

procedure TOrderFormParamsProvider.SetOnRemoveAttachedFile(Value: TNotifyEvent);
begin
  FOnRemoveAttachedFile := Value;
end;

procedure TOrderFormParamsProvider.SetOnOpenAttachedFile(Value: TNotifyEvent);
begin
  FOnOpenAttachedFile := Value;
end;

procedure TOrderFormParamsProvider.SetOnGetCostVisible(Value: TBooleanEvent);
begin
  FOnGetCostVisible := Value;
end;

procedure TOrderFormParamsProvider.SetOnAddNote(Value: TNotifyEvent);
begin
  FOnAddNote := Value;
end;

procedure TOrderFormParamsProvider.SetOnEditNote(Value: TIntNotifyEvent);
begin
  FOnEditNote := Value;
end;

procedure TOrderFormParamsProvider.SetOnDeleteNote(Value: TIntNotifyEvent);
begin
  FOnDeleteNote := Value;
end;

procedure TOrderFormParamsProvider.SetOnSelectTemplate(Value: TNotifyEvent);
begin
  FOnSelectTemplate := Value;
end;

function TOrderFormParamsProvider.GetOnAddAttachedFile: TNotifyEvent;
begin
  Result := FOnAddAttachedFile;
end;

function TOrderFormParamsProvider.GetOnRemoveAttachedFile: TNotifyEvent;
begin
  Result := FOnRemoveAttachedFile;
end;

function TOrderFormParamsProvider.GetOnOpenAttachedFile: TNotifyEvent;
begin
  Result := FOnOpenAttachedFile;
end;

function TOrderFormParamsProvider.GetOnGetCostVisible: TBooleanEvent;
begin
  Result := FOnGetCostVisible;
end;

function TOrderFormParamsProvider.GetOnAddNote: TNotifyEvent;
begin
  Result := FOnAddNote;
end;

function TOrderFormParamsProvider.GetOnEditNote: TIntNotifyEvent;
begin
  Result := FOnEditNote;
end;

function TOrderFormParamsProvider.GetOnDeleteNote: TIntNotifyEvent;
begin
  Result := FOnDeleteNote;
end;

function TOrderFormParamsProvider.GetOnSelectTemplate: TNotifyEvent;
begin
  Result := FOnSelectTemplate;
end;

constructor TOrderProp.Create(_Order: TOrder);
begin
  Order := _Order;
  inherited Create(nil);
  dsCust.DataSet := Customers.DataSet;
  TSettingsManager.Instance.XPInitComponent(btNewCust);
  TSettingsManager.Instance.XPInitComponent(btOk);
  TSettingsManager.Instance.XPInitComponent(btCancel);
  TSettingsManager.Instance.XPInitComponent(btSelectTemplate);
end;

procedure TOrderProp.SetOrder(_Order: TOrder);
begin
  FOrder := _Order;
  FDataSet := FOrder.DataSet;
end;

procedure TOrderProp.btOkClick(Sender: TObject);
begin
  pcOrderProp.ActivePage := tsCommon;
  ActiveControl := btOk;
  // Если не выйти из редактирования даты, то в случае ручного ввода она будет потеряна.
  ModalResult := mrNone;
  if ((not VarIsNull(lkKind.KeyValue)
          and not VarIsNull(lkChar.KeyValue)
          and not VarIsNull(lkColor.KeyValue)) or EntSettings.BriefOrderID) then
  begin
    if (cbOrderKind.ItemIndex >= 0) or not IsNewOrder then
    begin
      if EntSettings.RequireCustomer
        and ((lkCustomer.KeyValue = TContragents.NoNameKey) or VarIsNull(lkCustomer.KeyValue)) then
      begin
        pcOrderProp.ActivePage := tsCommon;
        ActiveControl := lkCustomer;
        RusMessageDlg('Не указан заказчик', mtError, [mbOk], 0);
      end
      else
      // Если есть права на изменение условий оплаты, то проверяем их корректность
      if KindPerm.UpdatePayConditions and (edPrePay.Value + edPreShip.Value > 100) then
      begin
        pcOrderProp.ActivePage := tsFinance;
        ActiveControl := edPrePay;
        RusMessageDlg('Некорректные условия оплаты', mtError, [mbOk], 0);
      end
      else
      begin
        ControlsToDataSet;
        ModalResult := mrOk;
      end;
    end
    else
    begin
      pcOrderProp.ActivePage := tsCommon;
      ActiveControl := cbOrderKind;
      RusMessageDlg('Не указан вид заказа', mtError, [mbOk], 0);
    end;
  end
  else
    RusMessageDlg('Не указаны некоторые параметры заказа', mtError, [mbOk], 0);
end;

procedure TOrderProp.btOpenFileClick(Sender: TObject);
begin
  FOnOpenAttachedFile(nil);
end;

procedure TOrderProp.btRemoveFileClick(Sender: TObject);
begin
  FOnRemoveAttachedFile(nil);
end;

function TOrderProp.FindKindIndex(k: integer): integer;
var i: integer;
begin
  Result := -1;
  if (FCreateKinds <> nil) and (FCreateKinds.Count > 0) then
    for i := 0 to Pred(FCreateKinds.Count) do
      if integer(FCreateKinds.Objects[i]) = k then
      begin
        Result := i;
        Exit;
      end;
end;

procedure TOrderProp.DataSetToControls;
var
  dt: TDateTime;
  StartVisible: boolean;
begin
  {if IsNewOrder then
  begin
    cbOrderKind.ItemIndex := FindKindIndex(AccessManager.CurUser.DefaultKindID);
    // Если при создании - вид менять можно только если включена глобальная настройка
    //cbOrderKind.ReadOnly := EntSettings.PermitKindChange;  11.03.2006
  end
  else
  begin}
    cbOrderKind.ItemIndex := FindKindIndex(Order.KindID);
    // Редактирование: возможность изменения вида зависит от глобальной настройки
    cbOrderKind.ReadOnly := FReadOnly or FInsideOrder or not EntSettings.PermitKindChange;
  //end;
  cbOrderKind.Enabled := not cbOrderKind.ReadOnly;
  //cbOrderKindChange(nil);
  UpdateKindPerm;

  if Order is TWorkOrder then
  begin
    if (Order as TWorkOrder).FinishDate = 0 then
    begin
      deFinish.Date := NullDate;
      tmFinish.Text := NullTime;
    end
    else
    begin
      dt := (Order as TWorkOrder).FinishDate;
      deFinish.Date := dt;
      tmFinish.Text := SysUtils.FormatDateTime('t', dt);
    end;
  end;
  acColorBox.ColorValue := NvlInteger(Order.RowColor);
  if not EntSettings.BriefOrderID then
  begin
    lkColor.KeyValue := NvlInteger(OrderDataSet['ID_Color']);
    lkKind.KeyValue := NvlInteger(OrderDataSet['ID_Kind']);
    lkChar.KeyValue := NvlInteger(OrderDataSet['ID_Char']);
    lkKindCloseUp(nil);
  end;
  if not InDraft then
  begin
    lkOrderState.KeyValue := (Order as TWorkOrder).OrderState;
    if EntSettings.AutoPayState then
    begin
      lkPayState.KeyValue := (Order as TWorkOrder).AutoPayState;
      lkManualPayState.KeyValue := NvlInteger((Order as TWorkOrder).PayState);
    end
    else
      lkPayState.KeyValue := NvlInteger((Order as TWorkOrder).PayState);
    edExternalId.Visible := EntSettings.ShowExternalId;
    lbExternalId.Visible := EntSettings.ShowExternalId;
    if EntSettings.ShowExternalId then
      edExternalId.Text := NvlString((Order as TWorkOrder).ExternalId);
  end
  else
  begin
    edExternalId.Visible := false;
    lbExternalId.Visible := false;
  end;  

  edComment.Text := Order.Comment;

  edPrePay.Value := Order.PrePayPercent;
  edPreShip.Value := Order.PreShipPercent;
  edPayDelay.Value := Order.PayDelay;
  cbIsPayDelayInBankDays.Checked := Order.IsPayDelayInBankDays;

  if FOnGetCostVisible then
    edComment2.Text := NvlString(Order.Comment2);

  cbComposite.Checked := Order.IsComposite;

  if not IsNewOrder then
  begin
    edNum.Text := IntToStr(NvlInteger(Order.OrderNumber));
    deCreationDate.Date := Order.CreationDate;
    edCreationTime.Text := SysUtils.FormatDateTime('t', Order.CreationDate);
    if Order is TWorkOrder then
    begin
      if not VarIsNull((Order as TWorkOrder).StartDate) then
      begin
        deStartDate.Date := (Order as TWorkOrder).StartDate;
        edStartTime.Text := SysUtils.FormatDateTime('t', (Order as TWorkOrder).StartDate);
      end;
      StartVisible := true;
    end
    else
      StartVisible := false;
    deStartDate.Visible := StartVisible;
    edStartTime.Visible := StartVisible;
    lbStartDate.Visible := StartVisible;
    btChangeStartDate.Visible := StartVisible;
    btSetStartDateToCreationDate.Visible := StartVisible;
  end
  else
  begin
    edNum.Text := '';
    //edPreShip.Value := 100;
  end;

  //Customers.Reload;
  {$IFDEF Manager}
  cdCurCust.Locate(CustNameField, MngCustName, [loCaseInsensitive]);
  lkCustomer.KeyValue := cdCurCust[CustKeyField];
  {$ELSE}
  LastCustomerID := Order.CustomerID;
  lkCustomer.KeyValue := Order.CustomerID;
  {$ENDIF}
  // запрещаем кнопку если не разрешено сохранение изменений
  btOk.Enabled := not FReadOnly;

  // прикрепленные файлы
  tsAttached.TabVisible := not IsNewOrder and not InDraft;
  dgAttached.DataSource := Order.AttachedFiles.DataSource;
  memoFileDesc.DataSource := dgAttached.DataSource;
  memoFileDesc.ReadOnly := not KindPerm.Update;
  btAddFile.Enabled := KindPerm.Update;
  btRemoveFile.Enabled := KindPerm.Update;
end;

procedure TOrderProp.ControlsToDataSet;

  procedure SetFieldValue(FieldName: string; FieldValue: variant);
  begin
    if OrderDataSet[FieldName] <> FieldValue then
    begin
      if not (OrderDataSet.State in [dsInsert, dsEdit]) then OrderDataSet.Edit;
      OrderDataSet[FieldName] := FieldValue;
    end;
  end;

var
  s: string;
  PermitParamUpdate: boolean;
begin
  // проверка прав
  if KindPerm.PlanFinishDate then
    if Order is TWorkOrder then
      if deFinish.Date <> NullDate then
      begin
        s := deFinish.Text;
        if tmFinish.EditText <> NullTime then s := s + ' ' + tmFinish.EditText;
        SetFieldValue('FinishDate', StrToDateTime(s));
      end;

  if not InDraft then
  begin
    // Изменение состояний разрешаются независимо от права на модификацию
    SetFieldValue(TOrder.F_OrderState, lkOrderState.KeyValue);
    if EntSettings.AutoPayState then
      SetFieldValue(TOrder.F_PayState, lkManualPayState.KeyValue)
    else
      SetFieldValue(TOrder.F_PayState, lkPayState.KeyValue);
    SetFieldValue(TWorkOrder.F_ExternalId, edExternalId.Text);
  end;

  if KindPerm.Update or IsNewOrder then
  begin
    // (Только в новом заказе можно поменять вид) - проверка пока отключена.
    // if IsNewOrder then
    SetFieldValue('KindID', integer(FCreateKinds.Objects[cbOrderKind.ItemIndex]));
    if not EntSettings.BriefOrderID then
    begin
      SetFieldValue('ID_Color', NvlInteger(lkColor.KeyValue));
      SetFieldValue('ID_Kind', NvlInteger(lkKind.KeyValue));
      SetFieldValue('ID_Char', NvlInteger(lkChar.KeyValue));
    end;
    if Order.IsComposite <> cbComposite.Checked then
      Order.IsComposite := cbComposite.Checked;

    // смена владельца
    if not IsNewOrder and AccessManager.CurKindPerm.ChangeOrderOwner
      and not VarIsNull(lkCreator.KeyValue)
      and (lkCreator.KeyValue <> AccessManager.GetUserID(OrderDataSet['CreatorName'])) then
      SetFieldValue('CreatorName', AccessManager.GetUserLogin(lkCreator.KeyValue));
  end;
  // нет отдельной настройки для прав на изменение цвета, заказчика, комментария
  // поэтому ставим по праву создания или модификации, см. также fOrdersFrame и метод UpdateKindPerm
  PermitParamUpdate := KindPerm.CreateNew or KindPerm.Update;
  if PermitParamUpdate then
  begin
    SetFieldValue('RowColor', NvlInteger(acColorBox.ColorValue));
    if VarIsNull(lkCustomer.KeyValue) then
      SetFieldValue('Customer', TContragents.NoNameKey)
    else
      SetFieldValue('Customer', lkCustomer.KeyValue);
    SetFieldValue(TOrder.F_Comment, edComment.Text);
  end;

  if FOnGetCostVisible and (NvlString(Order.Comment2) <> Trim(edComment2.Text)) then
  begin
    if Trim(edComment2.Text) = '' then
      Order.Comment2 := null
    else
      Order.Comment2 := Trim(edComment2.Text);
  end;

  // изменение условий оплаты
  if KindPerm.UpdatePayConditions then
  begin
    if Order.PrePayPercent <> edPrePay.Value then
      Order.PrePayPercent := edPrePay.Value;
    if Order.PreShipPercent <> edPreShip.Value then
      Order.PreShipPercent := edPreShip.Value;
    if Order.PayDelay <> edPayDelay.Value then
      Order.PayDelay := edPayDelay.Value;
    if Order.IsPayDelayInBankDays <> cbIsPayDelayInBankDays.Checked then
      Order.IsPayDelayInBankDays := cbIsPayDelayInBankDays.Checked;
  end;
  if KindPerm.Update or KindPerm.PlanFinishDate then  // 13.04.2009 странная какая то сентенция...
    if OrderDataSet.State in [dsEdit, dsInsert] then OrderDataSet.Post;
end;

procedure TOrderProp.SetOrderIDMode(IsBrief: boolean);
begin                 // Сокращенный шифр - отображается только номер
  lkColor.Visible := not IsBrief;
  lkKind.Visible := not IsBrief;
  lkChar.Visible := not IsBrief;
  lbColor.Visible := not IsBrief;
  lbKind.Visible := not IsBrief;
  lbChar.Visible := not IsBrief;
  if IsBrief then
  begin
    dsTSColors.DataSet := nil;
    dsTSKind.DataSet := nil;
    dsTSChar.DataSet := nil;
  end
  else
  begin
    dsTSColors.DataSet := TConfigManager.Instance.StandardDics.deTSColors.DicItems;
    dsTSKind.DataSet := TConfigManager.Instance.StandardDics.deTSKind.DicItems;
    dsTSChar.DataSet := TConfigManager.Instance.StandardDics.deTSChar.DicItems;
  end;
end;

procedure TOrderProp.FormActivate(Sender: TObject);
begin
  if not FActivated then
  begin
    EnableDBControls;
    //if not cdCurCust.Active then  // Открыть заказчиков
    //  RemoteControl.OpenDataSet(cdCurCust);
    // обновляет, если надо
    Customers.Reload;
    SetOrderIDMode(EntSettings.BriefOrderID);
    cbOrderKind.Items.Assign(FCreateKinds); // перед DataSetToControls
    if not InDraft and (TConfigManager.Instance.StandardDics.deOrderState <> nil) then
    begin
      dsOrderState := TDataSource.Create(Self);
      dsOrderState.DataSet := TConfigManager.Instance.StandardDics.deOrderState.DicItems;
      lkOrderState.LookupSource := dsOrderState;
    end;
    if not InDraft and (TConfigManager.Instance.StandardDics.dePayState <> nil) then
    begin
      dsPayState := TDataSource.Create(Self);
      if EntSettings.AutoPayState then
      begin
        // Режим автоматического определения состояния оплаты
        //if cdAutoPayState <> nil then cdAutoPayState.Free;
        cdAutoPayState := TConfigManager.Instance.StandardDics.CreateAutoPayStateData(Self);
        // автоматическое состояние
        dsPayState.DataSet := cdAutoPayState;
        lkPayState.LookupSource := dsPayState;
        lkPayState.ReadOnly := true;
        // Ручное под-состояние
        //if cdManualPayState <> nil then cdManualPayState.Free;
        cdManualPayState := TConfigManager.Instance.StandardDics.CreateManualPayStateData(Self);
        cdManualPayState.Filtered := true;
        lbManualPayState.Visible := true;
        lkManualPayState.Visible := true;
        dsManualPayState := TDataSource.Create(Self);
        dsManualPayState.DataSet := cdManualPayState;
        lkManualPayState.LookupSource := dsManualPayState;
        // Вызываем обновление фильтра под-состояний, т.к. под-состояние может
        // уже не подходить для текущего состояния, т.е. не быть его дочерним.
        lkPayStateChange(nil);
      end
      else
      begin
        // Режим ручной установки состояния оплаты
        dsPayState.DataSet := TConfigManager.Instance.StandardDics.dePayState.DicItems;
        lkPayState.LookupSource := dsPayState;
//        lkPayState.ReadOnly := false;
        lkPayState.ReadOnly :=  AccessManager.CurUser.SetPaymentStatus ;
        lbManualPayState.Visible := false;
        lkManualPayState.Visible := false;
      end;
      if not AccessManager.CurUser.ViewPayments or not AccessManager.CurUser.ViewInvoices then
      begin
        lbPayState.Visible := false;
        lkPayState.Visible := false;
        lbManualPayState.Visible := false;
        lkManualPayState.Visible := false;
      end;
    end;
    DataSetToControls;
    {$IFDEF Manager}
    lbColorBox.Visible := false;
    acColorBox.Visible := false;
    btNewCust.Visible := false;
    cbOrderState.Visible := false;
    cbOrderState.LookupSource := nil;
    lbOrderState.Visible := false;
    cbPayState.Visible := false;
    cbPayState.LookupSource := nil;
    lbPayState.Visible := false;
    lkCustomer.Enabled := false;
    {$ENDIF}

    pcOrderProp.ActivePage := tsCommon;
    if btOk.Enabled then
      ActiveControl := btOk
    else
      ActiveControl := btCancel;

    FActivated := true;
  end;
end;

procedure TOrderProp.btAddFileClick(Sender: TObject);
begin
  FOnAddAttachedFile(nil);
end;

procedure TOrderProp.btChangeCreationDateClick(Sender: TObject);
var
  s: string;
  dt: TDateTime;
begin
  if deCreationDate.Date <> NullDate then
  begin
    s := deCreationDate.Text;
    if edCreationTime.EditText <> NullTime then
      s := s + ' ' + edCreationTime.EditText;
    dt := StrToDateTime(s);
    Order.ChangeCreationDate(dt);
  end;
end;

procedure TOrderProp.btChangeNumberClick(Sender: TObject);
begin
  Order.ChangeNumber(StrToInt(edNum.Text));
end;

procedure TOrderProp.btChangeStartDateClick(Sender: TObject);
var
  s: string;
  dt: TDateTime;
begin
  if deStartDate.Date <> NullDate then
  begin
    s := deStartDate.Text;
    if edStartTime.EditText <> NullTime then
      s := s + ' ' + edStartTime.EditText;
    dt := StrToDateTime(s);
    (Order as TWorkOrder).ChangeStartDate(dt);
  end
  else
    (Order as TWorkOrder).ChangeStartDate(null);
end;

procedure TOrderProp.btSetStartDateToCreationDateClick(Sender: TObject);
begin
  deStartDate.Text := deCreationDate.Text;
  edStartTime.Text := edCreationTime.Text;
end;

procedure TOrderProp.btSelectTemplateClick(Sender: TObject);
begin
  FOnSelectTemplate(nil);
end;

procedure TOrderProp.btNewCustClick(Sender: TObject);
var
  i: integer;
begin
  i := NvlInteger(lkCustomer.KeyValue);
  if i = 0 then i := TContragents.NoNameKey;
  i := ExecContragentSelect(Customers, {CurCustomer=} i, {SelectMode} true);
  if i = custNoName then i := TContragents.NoNameKey;
  if (i <> custError) and (i <> custCancel) then
    lkCustomer.KeyValue := i;
end;

procedure TOrderProp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DisableDBControls;
  FreeAndNil(cdAutoPayState);
  FreeAndNil(cdManualPayState);
end;

procedure TOrderProp.EnableDBControls;
begin
  //lkCustomer.LookupSource := dm.dsCust;
  if IsNewOrder then
  begin
    lkCreator.Visible := false;  // создателя (владельца) не показывает в режиме создания нового
    lbCreator.Visible := false;
  end
  else
  begin
    lkCreator.Visible := true;
    lkCreator.ListSource := AccessManager.AccessUserSource;
    lkCreator.ReadOnly := not AccessManager.CurKindPerm.ChangeOrderOwner; // право на изменение владельца
    lkCreator.Visible := AccessManager.CurKindPerm.ChangeOrderOwner;
    lbCreator.Visible := AccessManager.CurKindPerm.ChangeOrderOwner;
    lkCreator.KeyValue := AccessManager.GetUserID(OrderDataSet['CreatorName']);
  end;
  // 20.08.2004
  //edNum.Visible := true;    // номер видно
  //lbNum.Visible := true;
  //imPic.Visible := false;     // не рисуется картинка
  if InDraft then
  begin
    lkCustomer.Enabled := true;
    lkCustomer.DisplayEmpty := sEmpCust;
    btNewCust.Enabled := true;
    deFinish.Visible := false;
    tmFinish.Visible := false;
    lbFinish.Visible := false;
    lbOrderState.Visible := false;
    lkOrderState.LookupSource := nil;
    lkOrderState.Visible := false;
    lbPayState.Visible := false;
    lkPayState.LookupSource := nil;
    lkPayState.Visible := false;
    lbManualPayState.Visible := false;
    lkManualPayState.LookupSource := nil;
    lkManualPayState.Visible := false;
  end
  else
  begin
    // Нельзя менять заказчика в составных заказах
    {try
      if dm.WorkOrderData['IsComposite'] then begin
        lkCustomer.Enabled := false;
        lkCustomer.DisplayEmpty := sCompOrd;
        btNewCust.Enabled := false;
      end else begin
        lkCustomer.Enabled := true;
        lkCustomer.DisplayEmpty := sEmpCust;
        btNewCust.Enabled := true;
      end;
    except end;}
    deFinish.Visible := true;
    tmFinish.Visible := true;
    lbFinish.Visible := true;
    lbOrderState.Visible := true;
    lkOrderState.Visible := true;
    lbPayState.Visible := true;
    lkPayState.Visible := true;
  end;

end;

procedure TOrderProp.DisableDBControls;
begin
  lkCustomer.LookupSource := nil;
end;

procedure TOrderProp.lkOrderStateGetImage(Sender: TObject;
  IsEmpty: Boolean; var Graphic: TGraphic; var TextMargin: Integer);
{var
  os, gi: integer;
begin
  TextMargin := 18;
  if not IsEmpty and (dsOrderState <> nil) and not VarIsNull(dsOrderState.DataSet['Code']) then
  try
    os := dsOrderState.DataSet['Code'];
    gi := OrderStates.IndexOf(IntToStr(os));
    if gi <> -1 then
      Graphic := (OrderStates.Objects[gi] as TOrderState).Graphic;
  except end;
end;}
begin
  GetStateImage(dsOrderState, TConfigManager.Instance.StandardDics.OrderStates, IsEmpty, Graphic, TextMargin);
end;

procedure TOrderProp.lkOrderStateCloseUp(Sender: TObject);
var i, rc: integer;
begin
  // Если установлена опция изменения цвета в зависимости от состояния заказа
  if not InDraft and Options.OrdStateRowColor
      and not VarIsNull(OrderDataSet[TOrder.F_OrderState]) then
  begin
    if VarIsNull(dsOrderState.DataSet['A1']) then Exit;
    rc := dsOrderState.DataSet['A1'];  // код цвета
    if rc <=0 then Exit;
    i := acColorBox.Items.IndexOf(IntToStr(rc));
    if (i <> -1) then acColorBox.ColorValue := TColor(acColorBox.Items.Objects[i]);
  end;
end;

procedure TOrderProp.lkPayStateGetImage(Sender: TObject; IsEmpty: Boolean;
  var Graphic: TGraphic; var TextMargin: Integer);
{var
  os, gi: integer;
begin
  TextMargin := 18;
  if not IsEmpty and (dsPayState <> nil) and not VarIsNull(dsPayState.DataSet['Code']) then
  try
    os := dsPayState.DataSet['Code'];
    gi := PayStates.IndexOf(IntToStr(os));
    if gi <> -1 then
      Graphic := (PayStates.Objects[gi] as TOrderState).Graphic;
  except end;
end;}
begin
  GetStateImage(dsPayState, TConfigManager.Instance.StandardDics.PayStates, IsEmpty, Graphic, TextMargin);
end;

procedure TOrderProp.lkManualPayStateGetImage(Sender: TObject; IsEmpty: Boolean;
  var Graphic: TGraphic; var TextMargin: Integer);
begin
  GetStateImage(dsManualPayState, TConfigManager.Instance.StandardDics.PayStates, IsEmpty, Graphic, TextMargin);
end;

procedure TOrderProp.GetStateImage(DataSource: TDataSource; States: TStringList;
  IsEmpty: Boolean; var Graphic: TGraphic; var TextMargin: Integer);
var
  os, gi: integer;
begin
  TextMargin := 18;
  if not IsEmpty and (DataSource <> nil) and not VarIsNull(DataSource.DataSet[F_DicItemCode]) then
  try
    os := DataSource.DataSet[F_DicItemCode];
    gi := States.IndexOf(IntToStr(os));
    if gi <> -1 then
      Graphic := (States.Objects[gi] as TOrderState).Graphic;
  except end;
end;

function TOrderProp.InDraft: boolean;
begin
  Result := (OrderDataSet.FindField(TOrder.F_OrderState) = nil);
end;

procedure TOrderProp.FormCreate(Sender: TObject);
var
  FNotesFrame: TOrderNotesFrame;
begin
  FCreateKinds := nil;
  if IsNewOrder then
  begin
    // Получить список видов, которые можно создавать
    if not InDraft then
      AccessManager.GetPermittedKindsList(FCreateKinds, AccessManager.CurUser.ID, 'WorkCreate')
    else
      AccessManager.GetPermittedKindsList(FCreateKinds, AccessManager.CurUser.ID, 'DraftCreate');
  end else begin
    // В режиме изменения показывает все видимые виды
    if not InDraft then
      AccessManager.GetPermittedKindsList(FCreateKinds, AccessManager.CurUser.ID, 'WorkVisible')
    else
      AccessManager.GetPermittedKindsList(FCreateKinds, AccessManager.CurUser.ID, 'DraftVisible');
    // Определяем права на текущий вид
    //adm.ReadCurKindPerm(IsCalcOrder(cdOrd), cdOrd['KindID']);
  end;

  FNotesFrame := TOrderNotesFrame.Create(Self);
  FNotesFrame.Parent := tsNotes;
  FNotesFrame.OnAddNote := DoOnAddNote;
  FNotesFrame.OnEditNote := DoOnEditNote;
  FNotesFrame.OnDeleteNote := DoOnDeleteNote;
  FNotesFrame.Order := Order;

  if IsNewOrder then
  begin
    btChangeCreationDate.Enabled := false;
    btChangeNumber.Enabled := false;
    btSelectTemplate.Visible := true;
    btChangeStartDate.Enabled := false;
    btSetStartDateToCreationDate.Enabled := false;
  end
  else
  begin
    // Отдельного права на эти административные функции нет, поэтому
    // используется право на редактирование процессов, т.к. для него
    // все равно нужны права админа.
    btChangeCreationDate.Enabled := AccessManager.CurUser.EditProcCfg;
    btChangeNumber.Enabled := AccessManager.CurUser.EditProcCfg;
    btChangeStartDate.Enabled := AccessManager.CurUser.EditProcCfg;
    btSetStartDateToCreationDate.Enabled := AccessManager.CurUser.EditProcCfg;
    btSelectTemplate.Visible := false;
  end;
end;

function TOrderProp.IsNewOrder: boolean;
begin
  Result := VarIsNull(OrderDataSet[TOrder.F_OrderKey]);
end;

procedure TOrderProp.lkCustomerChange(Sender: TObject);
var
  CustInfo: TContragentInfo;
begin
  if not VarIsNull(lkCustomer.KeyValue) then
  begin
    if (lkCustomer.KeyValue <> TContragents.NoNameKey) and (lkCustomer.KeyValue <> LastCustomerID) then
    begin
      CustInfo := Customers.GetInfo;
      if IsNewOrder or (((CustInfo.PrePayPercent <> edPrePay.Value)
        or (CustInfo.PreShipPercent <> edPreShip.Value)
        or (CustInfo.PayDelay <> edPayDelay.Value)
        or (CustInfo.IsPayDelayInBankDays <> cbIsPayDelayInBankDays.Checked))
        and (RusMessageDlg('Условия оплаты для заказа не совпадают с условиями оплаты для заказчика.'#13
           + 'Принять условия, установленные для заказчика?', mtConfirmation, mbYesNo, 0) = mrYes)) then
      begin
        edPrePay.Value := CustInfo.PrePayPercent;
        edPreShip.Value := CustInfo.PreShipPercent;
        edPayDelay.Value := CustInfo.PayDelay;
        cbIsPayDelayInBankDays.Checked := CustInfo.IsPayDelayInBankDays;
      end;
    end;
  end;
  LastCustomerID := lkCustomer.KeyValue;
end;

procedure TOrderProp.lkCustomerGetImage(Sender: TObject; IsEmpty: Boolean;
  var Graphic: TGraphic; var TextMargin: Integer);
begin
  CustomerPainter.JvDbLookupComboGetImage(lkCustomer, IsEmpty, Graphic, TextMargin);
end;

procedure TOrderProp.lkKindCloseUp(Sender: TObject);
var
  //ds: TDataSource;
  k: integer;
begin
  k := NvlInteger(lkKind.KeyValue);
  TConfigManager.Instance.StandardDics.deTSChar.DicItems.Filter := 'Visible and A1=' + IntToStr(k);
  TConfigManager.Instance.StandardDics.deTSChar.DicItems.Filtered := true;
  {ds := lkChar.ListSource;
  lkChar.ListSource := nil;
  lkChar.ListSource := ds;}
end;

procedure TOrderProp.FormDestroy(Sender: TObject);
begin
  if FCreateKinds <> nil then FCreateKinds.Free;
end;

procedure TOrderProp.UpdateKindPerm;
var
  prot: boolean;
  id: integer;
  nw, PermitParamUpdate: boolean;
begin
  if IsNewOrder then
    id := AccessManager.CurUser.ID
  else
    id := AccessManager.GetUserID(FOrder.CreatorName);

  AccessManager.ReadCurKindPermTo(KindPerm, InDraft,
    integer(FCreateKinds.Objects[cbOrderKind.ItemIndex]), id);

  // Можно разрешить изменение дат, не разрешая изменение пар-ров
  deFinish.ReadOnly := not KindPerm.PlanFinishDate;
  deFinish.Enabled := KindPerm.PlanFinishDate;

  tmFinish.ReadOnly := not KindPerm.PlanFinishDate;
  tmFinish.Enabled := KindPerm.PlanFinishDate;

  // состояние защиты
  prot := FOrder.CostProtected or FOrder.ContentProtected;

  // нет отдельной настройки для прав на изменение цвета, заказчика, комментария
  // поэтому ставим по праву создания или модификации. см также fOrdersFramу и метод ControlsToDataSet
  PermitParamUpdate := KindPerm.CreateNew or KindPerm.Update;
  lkCustomer.ReadOnly := not PermitParamUpdate;// or prot;
  lkCustomer.Enabled := PermitParamUpdate;
  btNewCust.Enabled := PermitParamUpdate;

  edComment.ReadOnly := not PermitParamUpdate;// or prot;
  edComment.Enabled := PermitParamUpdate;

  edComment2.Visible := FOnGetCostVisible;

  lkKind.ReadOnly := not KindPerm.Update;
  lkKind.Enabled := KindPerm.Update;

  lkChar.ReadOnly := not KindPerm.Update;
  lkChar.Enabled := KindPerm.Update;

  acColorBox.Enabled := PermitParamUpdate;

  nw := not IsNewOrder;
  lkPayState.ReadOnly := not KindPerm.Update or EntSettings.AutoPayState or not AccessManager.CurUser.SetPaymentStatus;
  lkPayState.Enabled := KindPerm.Update and nw;
  lbPayState.Enabled := nw;

  // 26.03.2009  Эксперимент - разрешаем изменение состояний
  // даже при запрещенном изменении состава заказа
  //lkManualPayState.ReadOnly := not KindPerm.Update;
  lkManualPayState.Enabled := {KindPerm.Update and }nw and AccessManager.CurUser.SetPaymentStatus;
  lbManualPayState.Enabled := nw;

  //lkOrderState.ReadOnly := not KindPerm.Update;
  //lkOrderState.Enabled := KindPerm.Update;

  //lkColor.ReadOnly := not KindPerm.Update;
  //lkColor.Enabled := KindPerm.Update;

  cbOrderKind.ReadOnly := not KindPerm.Update;
  cbOrderKind.Enabled := KindPerm.Update;

  edPrePay.ReadOnly := not KindPerm.UpdatePayConditions;
  edPreShip.ReadOnly := edPrePay.ReadOnly;
  edPayDelay.ReadOnly := edPrePay.ReadOnly;
  cbIsPayDelayInBankDays.Enabled := not edPrePay.ReadOnly;
end;

procedure TOrderProp.cbOrderKindChange(Sender: TObject);
begin
  UpdateKindPerm;
end;

procedure TOrderProp.deFinishChange(Sender: TObject);
begin
  if (CompareDate(deFinish.Date, Today) = 0) and (tmFinish.Text = NullTime) then
    tmFinish.Text := SysUtils.FormatDateTime('t', Now);
end;

procedure TOrderProp.lkPayStateChange(Sender: TObject);
begin
  if EntSettings.AutoPayState then
  begin
    cdManualPayState.Filter := StdDic.GetPayStateFilter(lkPayState.KeyValue);
    if not cdManualPayState.Locate(F_DicItemCode, lkManualPayState.KeyValue, []) then
      lkManualPayState.KeyValue := null;
  end;
end;

procedure TOrderProp.DoOnAddNote(Sender: TObject);
begin
  FOnAddNote(nil);
end;

procedure TOrderProp.DoOnEditNote(OrderNoteID: integer);
begin
  FOnEditNote(OrderNoteID);
end;

procedure TOrderProp.DoOnDeleteNote(OrderNoteID: integer);
begin
  FOnDeleteNote(OrderNoteID);
end;

end.
