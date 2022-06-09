unit fOrderItems;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, JvDBControls, StdCtrls, DB, DBClient, GridsEh,
  JvPicclip, Menus, JvMenus, Buttons, Variants, 
  JvExControls, JvComponent, JvDBLookup, ComCtrls, JvAppStorage, ImgList,
  DBGridEh, MyDBGridEh, JvFormPlacement, DBSumLst, DateUtils,

  {PmProcess, }Mask, JvExMask,
  JvToolEdit, JvExComCtrls, JvDateTimePicker, JvDBDateTimePicker, DBCtrls,
  NotifyEvent, fProgress, TLoggerUnit, fOrderInvPay, PmOrderInvoiceItems,
  PmOrderPayments, PmOrderProcessItems, PmShipment, PmOrder, DBGridEhGrouping,
  pmProductToStorage;

type
  TfOrderItems = class(TFrame)
    paOrderState: TPanel;
    paHdr: TPanel;
    lbHdr: TLabel;
    imExecState: TImageList;
    pcOrderItems: TPageControl;
    tsExecState: TTabSheet;
    dgExecState: TMyDBGridEh;
    tsMat: TTabSheet;
    tsCost: TTabSheet;
    paCostBottom: TPanel;
    BitBtn1: TBitBtn;
    imEmpty: TImage;
    dgCost: TMyDBGridEh;
    dgMat: TMyDBGridEh;
    tsContr: TTabSheet;
    dgContr: TMyDBGridEh;
    PopupMenu1: TPopupMenu;
    btMakeContractor: TBitBtn;
    paContrBottom: TPanel;
    btMakeOwn: TBitBtn;
    paMatTop: TPanel;
    btCancelRequest: TBitBtn;
    btShowRequest: TBitBtn;
    btMakeOwnCost: TBitBtn;
    paWorkMat: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    paContrWorkMat: TPanel;
    Panel1: TPanel;
    dtWorkCost: TDBText;
    Panel2: TPanel;
    dtMatCost: TDBText;
    Label3: TLabel;
    Panel3: TPanel;
    dtContrWorkCost: TDBText;
    Label4: TLabel;
    Panel4: TPanel;
    dtContrMatCost: TDBText;
    cbShowChanges: TCheckBox;
    tsFinance: TTabSheet;
    btExternalMat: TBitBtn;
    tsShipment: TTabSheet;
    Panel5: TPanel;
    btEditShipment: TBitBtn;
    btDeleteShipment: TBitBtn;
    btAddShipment: TBitBtn;
    dgShipment: TMyDBGridEh;
    btApproveShipment: TBitBtn;
    btApproveOrderMaterials: TBitBtn;
    tsStoreSipment: TTabSheet;
    dgProductToStore: TMyDBGridEh;
    Panel6: TPanel;
    btnDeleteFromStorage: TBitBtn;
    btnAddToStorage: TBitBtn;
    btnEditToStorage: TBitBtn;
    procedure dgExecStateGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dgEnabledDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure dgExecStateColumnsExecStateGetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure dgExecStateColumnsFactGetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure dgExecStateColumnsPlanGetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    function GetRangeText(Sender: TField; const FinishFieldName: string;
      DisplayText: Boolean): string;
    procedure dgCostProfitColumnsGetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure dgCostColumns4GetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure dgContrColumnsContractorGetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure dgContrColumnsContractorEditButtonDown(Sender: TObject;
      TopButton: Boolean; var AutoRepeat, Handled: Boolean);
    procedure dgContrColumnsFinalProfitCostGetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure btMakeContractorClick(Sender: TObject);
    procedure btMakeOwnClick(Sender: TObject);
    procedure btMakeOwnCostClick(Sender: TObject);
    procedure dgContrColumnsFactContractorCostGetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure dgContrColumnsPayDateUpdateData(Sender: TObject; var Text: String;
      var Value: Variant; var UseText, Handled: Boolean);
    procedure dgContrColumnsPlanStartDateUpdateData(Sender: TObject;
      var Text: string; var Value: Variant; var UseText, Handled: Boolean);
    procedure dgContrColumnsFactStartDateUpdateData(Sender: TObject; var Text: string;
      var Value: Variant; var UseText, Handled: Boolean);
    procedure dgContrColumnsPlanFinishDateUpdateData(Sender: TObject; var Text: string;
      var Value: Variant; var UseText, Handled: Boolean);
    procedure dgContrColumnsFactFinishDateUpdateData(Sender: TObject; var Text: string;
      var Value: Variant; var UseText, Handled: Boolean);
    procedure dgMatColumnsPlanReceiveDateUpdateData(Sender: TObject; var Text: string;
      var Value: Variant; var UseText, Handled: Boolean);
    procedure dgMatColumnsFactReceiveDateUpdateData(Sender: TObject; var Text: string;
      var Value: Variant; var UseText, Handled: Boolean);
    procedure btEditMatRequestClick(Sender: TObject);
    procedure dgMatDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure btAddShipmentClick(Sender: TObject);
    procedure btEditShipmentClick(Sender: TObject);
    procedure btDeleteShipmentClick(Sender: TObject);
    procedure btApproveShipmentClick(Sender: TObject);
    procedure dgMatGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure btCancelRequestClick(Sender: TObject);
    procedure dgExecStateGetFooterParams(Sender: TObject; DataCol, Row: Integer;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      var Alignment: TAlignment; State: TGridDrawState; var Text: string);
    procedure dgExecStateEstimatedDurationGetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure dgContrContractorCostNativeGetCellParams(Sender: TObject; EditMode: Boolean;
      Params: TColCellParamsEh);
    procedure dgMatPayDateUpdateData(Sender: TObject; var Text: string;
      var Value: Variant; var UseText, Handled: Boolean);
    procedure btApproveOrderMaterialsClick(Sender: TObject);
    procedure btnAddToStorageClick(Sender: TObject);
    procedure btnDeleteFromStorageClick(Sender: TObject);
    procedure btnEditToStorageClick(Sender: TObject);
  private
    cdExecState, cdCost, {cdMat,} cdContr: TClientDataSet;
    dsExecState, dsCost, {dsMat,} dsContr: TDataSource;
    FIsWorkView: boolean;
    //FIniStorage: TJvFormPlacement;
    EmptyIndex: integer;
    FContentProtected: Boolean;
    FCostProtected: Boolean;
    FProcessPage: TTabSheet;
    FProcPageCreated: boolean;
    //FSrvStatesRef: TStringList;
    FCostVisible: boolean;
    FPreviewMode: boolean;
    WasFinanceActive: boolean;
    FProfitPreviewVisible, FProfitInsideVisible, FModifyProfit: boolean;
    FEnabledChanging: boolean;
    HandlerID, ContractorHandlerID, SupplierHandlerID: TNotifyHandlerID;
    FLockPost: boolean;
    OwnBmp, ContrBmp, OwnDisBmp, ContrDisBmp: TBitmap;
    FProgressFrame: TProgressFrame;
    FOrderInvPayFrame: TOrderInvPayFrame;
    FOnEditInvoice: TNotifyEvent;
    FOnMakeInvoice: TNotifyEvent;
    FOnPayInvoice: TNotifyEvent;
    FOnExternalMat: TNotifyEvent;
    FOrderInvoiceItems: TOrderInvoiceItems;
    FOrderPayments: TOrderPayments;
    FProcessItems: TOrderProcessItems;
    FOrderShipment: TShipment;
    FOnAddShipment: TNotifyEvent;
    FOnEditShipment: TNotifyEvent;
    FOnDeleteShipment: TNotifyEvent;
    FOnApproveShipment: TNotifyEvent;
    FOnApproveOrderMaterials: TNotifyEvent;
    TProductStorage: TProductStorageController;
    FOnAddToStorage: TNotifyEvent;
    FOnDeleteFromStorage: TNotifyEvent;
    FProductStorage : TProductStorageController;

    //FMaterialAfterScrollID: TNotifyHandlerID;
    FOnCancelMaterialRequest, FOnEditMatRequest: TNotifyEvent;
    FOrder: TOrder;
    //procedure SrvStateClick(Sender: TObject);
    procedure FillProcessStateImages;
    procedure FillContractors;
    procedure FillSuppliers;
    //procedure AbortNewRecord(Sender: TDataSet); // 31.12.2004
    procedure cdCostAfterScroll(Sender: TDataSet);
    procedure cdContrAfterScroll(Sender: TDataSet);
    {procedure DateGetText(Sender: TField; var Text: String; DisplayText: Boolean);  // 31.12.2004
    procedure TimeGetText(Sender: TField; var Text: String; DisplayText: Boolean);}
    // устанавливает storage для гридов
    procedure SetIniStorage(Value: TJvFormPlacement);
    function GetIniStorage: TJvFormPlacement;
    procedure SetOrder(_Order: TOrder);
    //procedure SetShipmentApproved(_Approved: boolean);
    procedure FillStates;
    //procedure SetSrvStatesRef(Value: TStringList);
    procedure SetCostVisible(c: boolean);
    procedure SetProfitPreviewVisible(c: boolean);
    procedure SetProfitInsideVisible(c: boolean);
    procedure SetModifyProfit(c: boolean);
    procedure cdExecStatePlanStartTimeChange(Sender: TField);
    procedure cdExecStateFactStartTimeChange(Sender: TField);
    procedure cdExecStatePlanFinishTimeChange(Sender: TField);
    procedure cdExecStateFactFinishTimeChange(Sender: TField);
    procedure ConvertDateTime(_DateField: TField; _Time: variant);
    procedure cdExecStateAnyChange(Sender: TField);
    procedure UpdateDTControls(DataSet: TDataSet);
    procedure PlanDateGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure FactDateGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    //procedure GetDurationText(Sender: TField; var Text: String; DisplayText: Boolean);
    //procedure DurationGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure ExecStateDataChange(Sender: TObject; Field: TField);
    //procedure cdCostMatEnabledChange(Sender: TField);
    procedure UpdateColumnsVisible;
    procedure cdCostIsItemInProfitChange(Sender: TField);
    procedure GenericCostGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure FinalCostGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure cdCost_CostGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure ContractorCostGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    //procedure cdMatMatAmountGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure DicNotifyHandler(o: TObject);
    procedure ContractorNotifyHandler(o: TObject);
    procedure SupplierNotifyHandler(o: TObject);
    procedure BeforeDestroy;
    procedure AfterCreate;
    {procedure CreateExecStateData;  // 31.12.2004
    procedure CreateCostData;
    procedure FillExecTable;
    procedure FillCostTable;
    procedure FillServiceItemTable(cd: TClientDataSet; Services: TStringList;
        OnFillData: TOnFillDataProc);
    procedure FillExecSpecificData(cd: TDataSet; ItemObj: TServiceItemObj);
    procedure FillCostSpecificData(cd: TDataSet; ItemObj: TServiceItemObj);}
    //procedure CostServiceGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure ContractorChange(Sender: TField);
    procedure ContractorProcessChange(Sender: TField);
    procedure ContractorPercentChange(Sender: TField);
    procedure ContractorPayDateChange(Sender: TField);
    procedure FactContractorCostChange(Sender: TField);
    procedure UpdateContractorControls;
    procedure UpdateCostControls;
    procedure MakeOwn(ds: TDataSet; Own: boolean);
    procedure SetContentProtected(const Value: Boolean);
    procedure SetControlsVisible(comp: TWinControl; Vis: boolean);
    procedure SetCostProtected(const Value: Boolean);
    procedure UpdateProtection;
    procedure FreeOrderInvPayFrame;
    procedure DoOnMakeInvoice(Sender: TObject);
    procedure DoOnEditInvoice(Sender: TObject);
    procedure DoOnPayInvoice(Sender: TObject);
    //procedure MaterialAfterScroll(Sender: TObject);
    function IsNewOrder: boolean;
    function GetContractorCostText(FieldName: string): string;
  public
    constructor Create(Owner: TComponent; _OrderProcessItems: TOrderProcessItems{;
      _OrderInvoiceItems: TOrderInvoiceItems; _OrderPayments: TOrderPayments;
      _OrderShipment: TShipment});
    destructor Destroy; override;
    procedure RefreshData;
    procedure DisableControls;
    procedure EnableControls;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure SettingsChanged;
    procedure LeftToRight;
    procedure RightToLeft;
    procedure ShowInvPayFrame;
    procedure HideInvPayFrame;
    //property IniStorage: TJvFormPlacement read FIniStorage write SetIniStorage;
    property Order: TOrder write SetOrder;
    //property IsWorkView: boolean read FIsWorkView write SetIsWorkView;
    //property ShipmentApproved: boolean read FShipmentApproved write SetShipmentApproved;
    property ProcessPage: TTabSheet read FProcessPage;
    procedure BeforeCloseData;
    procedure CreateOrderInvPayFrame;
    procedure Activate;

    property ContentProtected: Boolean read FContentProtected write SetContentProtected;
    property CostProtected: Boolean read FCostProtected write SetCostProtected;
    property CostVisible: boolean read FCostVisible write SetCostVisible;
    property ProfitPreviewVisible: boolean read FProfitPreviewVisible write SetProfitPreviewVisible;
    property ProfitInsideVisible: boolean read FProfitInsideVisible write SetProfitInsideVisible;
    property ModifyProfit: boolean read FModifyProfit write SetModifyProfit;
    property OnEditInvoice: TNotifyEvent read FOnEditInvoice write FOnEditInvoice;
    property OnMakeInvoice: TNotifyEvent read FOnMakeInvoice write FOnMakeInvoice;
    property OnPayInvoice: TNotifyEvent read FOnPayInvoice write FOnPayInvoice;
    property OnAddShipment: TNotifyEvent read FOnAddShipment write FOnAddShipment;
    property OnEditShipment: TNotifyEvent read FOnEditShipment write FOnEditShipment;
    property OnDeleteShipment: TNotifyEvent read FOnDeleteShipment write FOnDeleteShipment;
    property OnApproveShipment: TNotifyEvent read FOnApproveShipment write FOnApproveShipment;
    property OnApproveOrderMaterials: TNotifyEvent read FOnApproveOrderMaterials write FOnApproveOrderMaterials;
    property OnAddToStorage : TNotifyEvent read FOnAddToStorage write FOnAddToStorage;
    property OnDeleteFromStorage : TNotifyEvent read FOnDeleteFromStorage write FOnDeleteFromStorage;
     property OnSelectExternalMaterial: TNotifyEvent read FOnExternalMat write FOnExternalMat;
    property OnCancelMaterialRequest: TNotifyEvent read FOnCancelMaterialRequest write FOnCancelMaterialRequest;
    property OnEditMaterialRequest: TNotifyEvent read FOnEditMatRequest write FOnEditMatRequest;

    property OrderInvPayFrame: TOrderInvPayFrame read FOrderInvPayFrame;
    property OrderInvoiceItems: TOrderInvoiceItems read FOrderInvoiceItems write FOrderInvoiceItems;
    property OrderPayments: TOrderPayments read FOrderPayments write FOrderPayments;
    property OrderShipment: TShipment read FOrderShipment write FOrderShipment;

  end;

implementation

uses JvJVCLUtils, ColorLst, PmStates, RDBUtils, PmContragent,
  CalcSettings, CalcUtils, StdDIc, PlanUtils,
  PmMaterials, PmAccessManager, PmEntSettings,
  PmConfigManager, PmShipmentDoc, ExHandler,
  fOrdersFrame;

{$R *.DFM}

function ConvertDateTime(_Date, _Time: variant): TDateTime;
var
  dt: TDateTime;
begin
  if not VarIsNull(_Date) then
  begin
    dt := _Date;
    // время 12:00:33:333 означает, что поле пустое (при непустой дате)
    if VarIsNull(_Time) then _Time := EncodeTime(0, 0, 33, 333);
    ReplaceTime(dt, _Time);
    Result := dt;
  end
  else
    Result := 0;  // Но если дата пустая, то время просто = 0
end;

constructor TfOrderItems.Create(Owner: TComponent; _OrderProcessItems: TOrderProcessItems{;
  _OrderInvoiceItems: TOrderInvoiceItems; _OrderPayments: TOrderPayments;
  _OrderShipment: TShipment});
begin
  inherited Create(Owner);
  FProcessItems := _OrderProcessItems;
  AfterCreate;
end;

destructor TfOrderItems.Destroy;
begin
  BeforeDestroy;
  FreeOrderInvPayFrame;
  inherited Destroy;
end;

procedure TfOrderItems.CreateOrderInvPayFrame;
begin
  if FOrderInvPayFrame = nil then
  begin
    FOrderInvPayFrame := TOrderInvPayFrame.Create(nil, FOrderInvoiceItems, FOrderPayments);
    FOrderInvPayFrame.OnAddInvoice := DoOnMakeInvoice;
    FOrderInvPayFrame.OnEditInvoice := DoOnEditInvoice;
    FOrderInvPayFrame.OnPayInvoice := DoOnPayInvoice;
    FOrderInvPayFrame.Parent := tsFinance;
  end;
end;

// Используется, когда панель уже отображена
procedure TfOrderItems.FreeOrderInvPayFrame;
begin
  if FOrderInvPayFrame <> nil then
    FreeAndNil(FOrderInvPayFrame);
end;

procedure TfOrderItems.DoOnMakeInvoice(Sender: TObject);
begin
  if Assigned(FOnMakeInvoice) then
    FOnMakeInvoice(Sender);
end;

procedure TfOrderItems.DoOnEditInvoice(Sender: TObject);
begin
  if Assigned(FOnEditInvoice) then
    FOnEditInvoice(Sender);
end;

procedure TfOrderItems.DoOnPayInvoice(Sender: TObject);
begin
  if Assigned(FOnPayInvoice) then
    FOnPayInvoice(Sender);
end;

procedure TfOrderItems.FillProcessStateImages;
var
  i: integer;
  Bmp: TBitmap;
  States: TStringList;
begin
  imExecState.Clear;
  States := TConfigManager.Instance.StandardDics.ProcessExecStates;
  if (States <> nil) and (States.Count > 0) then
  begin
    for i := 0 to Pred(States.Count) do
    begin
      Bmp := TBitmap.Create;
      try
        Bmp.Assign((States.Objects[i] as TOrderState).Graphic);
        if Bmp.Height > 0 then
        begin
          imExecState.AddMasked(Bmp, clOlive);
        end
        else
          Bmp.Free;
      except
        Bmp.Free;
      end;
    end;
    EmptyIndex := imExecState.AddMasked(imEmpty.Picture.Bitmap, clOlive);
  end;
end;

procedure TfOrderItems.FillStates;
var StateCol: TColumnEh;
begin
  FillProcessStateImages;
  StateCol := dgExecState.FieldColumns['ExecState'];
  StateCol.KeyList.Assign(TConfigManager.Instance.StandardDics.ProcessExecStates);
  StateCol.NotInKeyListIndex := EmptyIndex;
end;

procedure TfOrderItems.DicNotifyHandler(o: TObject);
begin
  FillStates;
end;

procedure TfOrderItems.FillContractors;
var
  ContrList, ContrKeyList: TStringList;
  ds: TDataSet;
begin
  ContrKeyList := TStringList.Create;
  ContrList := TStringList.Create;
  ds := Contractors.DataSet;
  ds.First;
  while not ds.eof do
  begin
    ContrKeyList.Add(Contractors.KeyValue);
    ContrList.Add(Contractors.Name);
    ds.Next;
  end;
  dgContr.FieldColumns[TOrderProcessItems.F_ContractorID].KeyList := ContrKeyList;
  dgContr.FieldColumns[TOrderProcessItems.F_ContractorID].PickList := ContrList;
end;

procedure TfOrderItems.FillSuppliers;
var
  SupList, SupKeyList: TStringList;
  ds: TDataSet;
begin
  SupKeyList := TStringList.Create;
  SupList := TStringList.Create;
  ds := Suppliers.DataSet;
  ds.First;
  while not ds.eof do
  begin
    SupKeyList.Add(Suppliers.KeyValue);
    SupList.Add(Suppliers.Name);
    ds.Next;
  end;
  dgMat.FieldColumns[TMaterials.F_SupplierID].KeyList := SupKeyList;
  dgMat.FieldColumns[TMaterials.F_SupplierID].PickList := SupList;
end;

procedure TfOrderItems.ContractorNotifyHandler(o: TObject);
begin
  FillContractors;
end;

procedure TfOrderItems.SupplierNotifyHandler(o: TObject);
begin
  FillSuppliers;
end;

procedure TfOrderItems.cdCostAfterScroll(Sender: TDataSet);
begin
//  btJumpEdit.Enabled := -SrvTabKeyField- > 0;
  UpdateCostControls;
end;

procedure TfOrderItems.UpdateCostControls;
var f: boolean;
begin
  f := (cdCost.RecordCount > 0) and not NvlBoolean(cdCost[TOrderProcessItems.F_IsPartName])
    and NvlBoolean(cdCost[TOrderProcessItems.F_Enabled]);
  btMakeContractor.Enabled := f and not NvlBoolean(cdCost[TOrderProcessItems.F_ContractorProcess]) and not FContentProtected;
  btMakeOwnCost.Enabled := f and NvlBoolean(cdCost[TOrderProcessItems.F_ContractorProcess]) and not FContentProtected;
  SetControlsVisible(paWorkMat, f);
end;

procedure TfOrderItems.cdContrAfterScroll(Sender: TDataSet);
begin
  UpdateContractorControls;
end;

procedure TfOrderItems.UpdateContractorControls;
begin
  btMakeOwn.Enabled := (cdContr.RecordCount > 0) and not NvlBoolean(cdContr[TOrderProcessItems.F_IsPartName])
    and NvlBoolean(cdCost[TOrderProcessItems.F_Enabled]) and not FContentProtected;
end;

procedure TfOrderItems.DisableControls;
begin
  if (cdExecState <> nil) and cdExecState.Active then cdExecState.DisableControls;
  if (cdCost <> nil) and cdCost.Active then cdCost.DisableControls;
  //if (cdMat <> nil) and cdMat.Active then cdMat.DisableControls;
  if (cdContr <> nil) and cdContr.Active then cdContr.DisableControls;
end;

procedure TfOrderItems.EnableControls;
begin
  if (cdExecState <> nil) and cdExecState.Active then cdExecState.EnableControls;
  if (cdCost <> nil) and cdCost.Active then cdCost.EnableControls;
  //if (cdMat <> nil) and cdMat.Active then cdMat.EnableControls;
  if (cdContr <> nil) and cdContr.Active then cdContr.EnableControls;
end;

function TfOrderItems.IsNewOrder: boolean;
begin
  Result := NvlInteger((FProcessItems.Processes.ParentOrder as TOrder).KeyValue) = 0;
end;

procedure TfOrderItems.SetOrder(_Order: TOrder);
var
  ShowInvoices: boolean;
  //ShowExecState: boolean;
  vs, sa, sar, isStorage: boolean;
begin
  FOrder := _Order;
  FIsWorkView := _Order is TWorkOrder;

  {ShowExecState := FIsWorkView and AccessManager.CurUser.ViewProduction;
  if (pcOrderItems.ActivePage = tsExecState) and not ShowExecState then
    pcOrderItems.ActivePageIndex := 0;
  tsExecState.TabVisible := ShowExecState;}

  ShowInvoices := FIsWorkView and AccessManager.CurUser.ViewPayments
    and AccessManager.CurUser.ViewInvoices;
  {if ((pcOrderItems.ActivePage = tsFinance) or (pcOrderItems.ActivePage = tsExecState))
      and not ShowInvoices then
    pcOrderItems.ActivePageIndex := 0;}
  // Если текущая закладка последняя, и мы скрываем одну закладку, то будет ошибка
  if (pcOrderItems.ActivePageIndex = pcOrderItems.PageCount - 1) and not ShowInvoices
    and tsFinance.TabVisible then
    pcOrderItems.ActivePageIndex := 0;
  tsFinance.TabVisible := ShowInvoices;

  vs := FIsWorkView and not IsNewOrder and AccessManager.CurUser.ViewShipment;
  isStorage :=  (FIsWorkView and ((FOrder as TWorkOrder).DataSource.DataSet.FieldByName('Customer').AsInteger = 8844));

  // Если текущая закладка последняя, и мы скрываем одну закладку, то будет ошибка
  if (pcOrderItems.ActivePageIndex = pcOrderItems.PageCount - 1) and not vs and tsShipment.TabVisible then
    pcOrderItems.ActivePageIndex := 0;
  tsShipment.TabVisible := vs and not isStorage;

    // 20.01.2020 Таблица "Отгрузка на склад". Временно делаем проверку по одному ИД получателя = 8844 - "Товар на склад"
  tsStoreSipment.TabVisible := vs and isStorage;

  if isStorage then
  begin
    if TProductStorage = nil then
      FProductStorage := TProductStorageController.Create(NvlInteger((FOrder.KeyValue)));
    with dgProductToStore do
    begin
       DataSource := FProductStorage.DSourceStorage;

    end;
  end;


  if vs then
  begin
    sa := (_Order as TWorkOrder).ShipmentApproved;   // разрешена ли отгрузка
    sar := EntSettings.ShipmentApprovement;  // is approvement required?
    btApproveShipment.Visible := not sa and sar and AccessManager.CurUser.ApproveShipment;
    btAddShipment.Visible := sa or not sar;
    btEditShipment.Visible := sa or not sar;
    btDeleteShipment.Visible := sa or not sar;
    btAddShipment.Enabled := AccessManager.CurUser.AddShipment;
    btEditShipment.Enabled := AccessManager.CurUser.AddShipment;
    btDeleteShipment.Enabled := AccessManager.CurUser.DeleteShipment;

    btnAddToStorage.Enabled := AccessManager.CurUser.AddShipment;
    btnEditToStorage.Enabled := AccessManager.CurUser.AddShipment;
    btnDeleteFromStorage.Enabled := AccessManager.CurUser.AddShipment;
  end;

  // Разрешение закупки материалов
  if FIsWorkView and not IsNewOrder then
  begin
    sa := (_Order as TWorkOrder).OrderMaterialsApproved;  // разрешена ли закупка
    sar := EntSettings.OrderMaterialsApprovement;  // is approvement required?
    btApproveOrderMaterials.Visible := not sa and sar and AccessManager.CurUser.ApproveOrderMaterials;
  end
  else
    btApproveOrderMaterials.Visible := false;

  paMatTop.Visible := FIsWorkView;  // редактирование заявок на материалы только в заказах
  UpdateColumnsVisible;
end;

function TfOrderItems.GetIniStorage: TJvFormPlacement;
begin
  Result := TSettingsManager.Instance.MainFormStorage;
end;

procedure TfOrderItems.LoadSettings;
var
  i: integer;
begin
  dgExecState.Load;
  dgCost.Load;
  dgMat.Load;
  dgContr.Load;
  i := GetIniStorage.ReadInteger(FOrder.InternalName + 'Items_ActivePageIndex', 0);
  {if (i = tsExecState.PageIndex) and not FIsWorkView then
    pcOrderItems.ActivePageIndex := 0
  else
    pcOrderItems.ActivePageIndex := i;}
  cbShowChanges.Checked := GetIniStorage.ReadString(FOrder.InternalName + 'Items_ShowChanges', '0') = '1';
  
  if FOrderInvPayFrame <> nil then
    FOrderInvPayFrame.LoadSettings;
end;

procedure TfOrderItems.SaveSettings;
begin
  dgExecState.Save;
  dgCost.Save;
  dgMat.Save;
  dgContr.Save;
  GetIniStorage.WriteInteger(FOrder.InternalName + 'Items_ActivePageIndex', pcOrderItems.ActivePageIndex);
  GetIniStorage.WriteInteger(FOrder.InternalName + 'Items_ShowChanges', Ord(cbShowChanges.Checked));
  if FOrderInvPayFrame <> nil then
    FOrderInvPayFrame.SaveSettings;
end;

procedure TfOrderItems.SettingsChanged;
begin
  paHdr.Color := Options.GetColor(sNBack);
  lbHdr.Font.Color := Options.GetColor(sNText);
  if FOrderInvPayFrame <> nil then
    FOrderInvPayFrame.SettingsChanged;
end;

procedure TfOrderItems.dgExecStateGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
var
  i: integer;
  cd: TDataSet;
  States: TStringList;
begin
  if (Column.Field = nil) or Column.Field.DataSet.IsEmpty then Exit;
  if Column.Field.DataSet.FieldByName(TOrderProcessItems.F_IsPartName).IsNull
    or Column.Field.DataSet[TOrderProcessItems.F_IsPartName] then
  begin
    //Background := clSilver;
    if (gdSelected in State) and (gdFocused in State) then
      AFont.Color := clHighlightText
    else
      AFont.Color := clWindowText;
    AFont.Style := [fsBold];
    AFont.Color := Options.GetColor(sPartText);
    if not (gdFocused in State) then Background := Options.GetColor(sPartBk);
  end
  else
  begin
    cd := Column.Field.DataSet;
    if not NvlBoolean(cd[TOrderProcessItems.F_Enabled])then
    begin
      AFont.Color := Options.GetColor(sDisabledProcessText);
      AFont.Style := [fsStrikeOut];
      Background := Options.GetColor(sDisabledProcessBk);
    end
    else
    begin
      // определяем цвет строки
      if not (gdSelected in State) and (cd = cdExecState) then
        if NvlInteger(cd[TOrderProcessItems.F_ExecState]) <> 0 then
        begin
          States := TConfigManager.Instance.StandardDics.ProcessExecStates;
          i := States.IndexOf(IntToStr(cd[TOrderProcessItems.F_ExecState]));
          if (i <> -1) and (States.Objects[i] <> nil) then
          begin
            i := (States.Objects[i] as TOrderState).RowColorCode;
            i := ColorItems.IndexOf(IntToStr(i));
            if (i <> -1) then
              Background := TColor(ColorItems.Objects[i]);
          end;
        end;
      //if (Column.FieldName = ServiceCostField) and (cd[ServiceCostField] > 0) then
      //  AFont.Style := [fsBold];
    end;
  end;
end;

procedure TfOrderItems.dgExecStateGetFooterParams(Sender: TObject; DataCol,
  Row: Integer; Column: TColumnEh; AFont: TFont; var Background: TColor;
  var Alignment: TAlignment; State: TGridDrawState; var Text: string);
begin
  if Column.FieldName = TOrderProcessItems.F_EstimatedDuration then
    Text := PlanUtils.FormatTimeValue(Round(dgExecState.SumList.SumCollection.GetSumByOpAndFName(goSum,
      TOrderProcessItems.F_EstimatedDuration).SumValue));
end;

procedure TfOrderItems.SetIniStorage(Value: TJvFormPlacement);
begin
  //FIniStorage := Value;
  dgExecState.IniStorage := Value;
  dgCost.IniStorage := Value;
  dgMat.IniStorage := Value;
  dgContr.IniStorage := Value;
end;

procedure TfOrderItems.LeftToRight;
begin
  FPreviewMode := false;
  UpdateColumnsVisible;
  EnableControls;
  paHdr.Visible := false;
  // TODO: Пока что редактирование запрещено вне заказа
  paCostBottom.Visible := true;
  paContrBottom.Visible := true;
  UpdateProtection;
  dgMat.Options := dgMat.Options - [dgRowSelect] + [dgEditing];
end;

procedure TfOrderItems.RightToLeft;
begin
  FPreviewMode := true;
  UpdateColumnsVisible;
  //paHdr.Visible := true;
  // TODO: Пока что редактирование запрещено вне заказа
  paCostBottom.Visible := false;
  paContrBottom.Visible := false;
  dgMat.Options := dgMat.Options + [dgRowSelect] - [dgEditing];
end;

procedure TfOrderItems.HideInvPayFrame;
begin
  WasFinanceActive := pcOrderItems.ActivePageIndex = tsFinance.PageIndex;
  if WasFinanceActive then
    pcOrderItems.ActivePageIndex := tsCost.PageIndex;
  //paFinance.RemoveControl(FOrderInvPayFrame);
end;

procedure TfOrderItems.ShowInvPayFrame;
{var
  SavedHeight: integer;}
begin
  if WasFinanceActive then
    pcOrderItems.ActivePageIndex := tsFinance.PageIndex;
  //SavedHeight := Height;
  //paFinance.InsertControl(FOrderInvPayFrame);
  //Height := SavedHeight;
end;

procedure TfOrderItems.cdExecStatePlanStartTimeChange(Sender: TField);
begin
  ConvertDateTime(Sender.DataSet.FieldByName(TOrderProcessItems.F_PlanStart), Sender.Value);
end;

procedure TfOrderItems.cdExecStatePlanFinishTimeChange(Sender: TField);
begin
  ConvertDateTime(Sender.DataSet.FieldByName(TOrderProcessItems.F_PlanFinish), Sender.Value);
end;

procedure TfOrderItems.cdExecStateFactStartTimeChange(Sender: TField);
begin
  ConvertDateTime(Sender.DataSet.FieldByName(TOrderProcessItems.F_FactStart), Sender.Value);
end;

procedure TfOrderItems.cdExecStateFactFinishTimeChange(Sender: TField);
begin
  ConvertDateTime(Sender.DataSet.FieldByName(TOrderProcessItems.F_FactFinish), Sender.Value);
end;

procedure TfOrderItems.ConvertDateTime(_DateField: TField; _Time: variant);
var
  dt: TDateTime;
begin
  if FProcessItems.SettingTime then Exit;
  if VarIsNull(_DateField.Value) then
    dt := Now
  else
    dt := _DateField.Value;
    // время 12:00:33:333 означает, что поле пустое (при непустой дате)
  if VarIsNull(_Time) then _Time := EncodeTime(0, 0, 33, 333);
  ReplaceTime(dt, _Time);
  if VarIsNull(_DateField.Value) or (dt <> _DateField.Value) then begin
    if not (_DateField.DataSet.State in [dsInsert, dsEdit]) then _DateField.DataSet.Edit;
    _DateField.Value := dt;
  end;
end;

procedure TfOrderItems.cdExecStateAnyChange(Sender: TField);
begin
  if not FProcessItems.NoModifyTracking then
    FProcessItems.ProcessItemsModified := true;
  // Здесь если не делать Post, то состояние не меняется сразу, а если делать,
  // то почему-то происходит рекурсия при стирании даты, поэтому блокируем повторный вход.
  if not FLockPost then
  try
    FLockPost := true;
    { TODO: А здесь не надо проверять на dsInsert? }
    if (Sender is TDateTimeField) then Sender.DataSet.Post;
  finally
    FLockPost := false;
  end;
end;

function GetDateTimeFormat(dt: TDateTime): string;
begin
  if YearOf(Now) = YearOf(dt) then
    Result := 'dd.mmm'
  else
    Result := 'dd.mm.yyyy';
  Result := Result + '  hh:nn';
end;

function TfOrderItems.GetRangeText(Sender: TField; const FinishFieldName: string;
  DisplayText: Boolean): string;
var
  f, f1: variant;
  s: string;
begin
  if not NvlBoolean(Sender.DataSet[TOrderProcessItems.F_IsPartName]) then
  begin
    f1 := Sender.Value;    // start
    if VarIsNull(f1) then
      s := '...'
    else
      s := FormatDateTime(GetDateTimeFormat(f1), f1);
    f := Sender.DataSet[FinishFieldName];    // finish
    if VarIsNull(f) then
      Result := s + '- ...'
    else
    begin
      if not VarIsNull(f1) then
      begin
        if FormatDateTime('dd.mm.yyyy', f) = FormatDateTime('dd.mm.yyyy', f1) then
          Result := s + ' - ' + FormatDateTime('hh:nn', f)
        else
          Result := s + ' - ' + FormatDateTime(GetDateTimeFormat(f), f);
      end
      else
        Result := s + ' - ' + FormatDateTime(GetDateTimeFormat(f), f);
    end;
  end
  else
    Result := '';
end;

procedure TfOrderItems.PlanDateGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if FPreviewMode then
  begin
    Text := GetRangeText(Sender, TOrderProcessItems.F_PlanFinish, DisplayText);
    if Text <> '' then
      Text := Text + #13#10 + GetRangeText(Sender, TOrderProcessItems.F_FactFinish, DisplayText);
  end
  else
    Text := GetRangeText(Sender, TOrderProcessItems.F_PlanFinish, DisplayText);
end;

procedure TfOrderItems.FactDateGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := GetRangeText(Sender, TOrderProcessItems.F_FactFinish, DisplayText);
end;

{procedure TfOrderItems.GetDurationText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := PlanUtils.GetDurationText(Sender.Value);
end;}

procedure TfOrderItems.ExecStateDataChange(Sender: TObject; Field: TField);
begin
  if not cdExecState.ControlsDisabled and FProgressFrame.Visible then
    FProgressFrame.ReDraw;
end;

{procedure TfOrderItems.DurationGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  GetDurationText(Sender, Text, DisplayText);
end;}

// Столкнулся с непонятной проблемой при изменении этого поля, поэтому пока
// изменение запрещено. НЕ ИСПОЛЬЗУЕТСЯ
{procedure TfOrderItems.cdCostMatEnabledChange(Sender: TField);
begin
  if FEnabledChanging then Exit;
  FEnabledChanging := true;
  dm.ProcessParamToProcessData(Sender);
  //Sender.DataSet.CheckBrowseMode;
  //if Sender.DataSet.State in [dsInsert, dsEdit] then Sender.DataSet.Post;
  FEnabledChanging := false;
end;}

procedure TfOrderItems.cdCostIsItemInProfitChange(Sender: TField);
begin
  if not FProcessItems.NoModifyTracking then
    FProcessItems.ProcessItemsModified := true;
  // следующие строки лучше не трогать и ни в коем случае не менять местами!
  if Sender.DataSet.State <> dsInsert then
  begin
    TOrderProcessItems.CalcCosts(Sender.DataSet);
    cdCost.CheckBrowseMode;
  end;
  FProcessItems.CalculateProfits;
end;

function NonZero(Sender: TField): string;
begin
    if Sender.IsNull or (Sender.Value = 0) then
      Result := ''
    else
      Result := FormatFloat((Sender as TNumericField).DisplayFormat, Sender.Value);
end;

procedure TfOrderItems.GenericCostGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  if NvlBoolean(Sender.DataSet[TOrderProcessItems.F_IsPartName]) then
    Text := ''
  else
  if DisplayText then
    Text := NonZero(Sender)
  else
    Text := FormatFloat((Sender as TNumericField).EditFormat, NvlFloat(Sender.Value));
end;

procedure TfOrderItems.FinalCostGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if FCostVisible and FProfitInsideVisible then
    GenericCostGetText(Sender, Text, DisplayText)
  else
    Text := '';
end;

procedure TfOrderItems.cdCost_CostGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  if NvlBoolean(Sender.DataSet[TOrderProcessItems.F_IsPartName]) then
    Text := ''
  else
  if DisplayText then
  begin
    if cbShowChanges.Checked and (Sender.DataSet[TOrderProcessItems.F_OldCost] <> Sender.DataSet[TOrderProcessItems.F_Cost])
      and not VarIsNull(Sender.DataSet[TOrderProcessItems.F_OldCost]) then
      // Режим показа стоимости, изменившейся при пересчете
      Text := NonZero(Sender) + '  (' + NonZero(Sender.DataSet.FieldByName(TOrderProcessItems.F_OldCost)) + ')'
    else
      Text := NonZero(Sender);
  end
  else
    Text := FormatFloat((Sender as TNumericField).EditFormat, NvlFloat(Sender.Value));
end;

{procedure TfOrderItems.cdMatMatAmountGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  if NvlBoolean(Sender.DataSet['IsPartName']) then
    Text := ''
  else
    Text := IntToStr(NvlInteger(Sender.Value));
end;}

procedure TfOrderItems.ContractorCostGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  if NvlBoolean(Sender.DataSet[TOrderProcessItems.F_ContractorProcess]) then
    GenericCostGetText(Sender, Text, DisplayText)
  else
    Text := '';
end;

procedure TfOrderItems.RefreshData;

  procedure SetExecStateDS(DS: TDataSource);
  begin
    dgExecState.DataSource := DS;
    if FProgressFrame <> nil then FProgressFrame.DataSource := DS;
  end;

begin
  if not FProcessItems.Active then Exit;

  // Таблица "Производство"
  SetExecStateDS(nil);
  if cdExecState <> nil then FreeAndNil(cdExecState);
  //if FIsWorkView then // 17.01.2010 Отображаем закладку Выполнение в расчетах, но без дат
  //begin
    cdExecState := TClientDataSet.Create(Self);
    cdExecState.CloneCursor(FProcessItems.DataSet as TClientDataSet, false);
    //(cdExecState.FieldByName('PlanDuration') as TIntegerField).OnGetText := DurationGetText;
    //(cdExecState.FieldByName('FactDuration') as TIntegerField).OnGetText := DurationGetText;

    (cdExecState.FieldByName('PlanStartTime_ICalc') as TDateTimeField).DisplayFormat := ShortTimeFormat;
    //(cdExecState.FieldByName('PlanStartTime_ICalc') as TDateTimeField).OnChange := cdExecStatePlanStartTimeChange;
    (cdExecState.FieldByName('PlanFinishTime_ICalc') as TDateTimeField).DisplayFormat := ShortTimeFormat;
    //(cdExecState.FieldByName('PlanFinishTime') as TDateTimeField).OnChange := cdExecStatePlanFinishTimeChange;
    (cdExecState.FieldByName('FactStartTime_ICalc') as TDateTimeField).DisplayFormat := ShortTimeFormat;
    (cdExecState.FieldByName('FactStartTime_ICalc') as TDateTimeField).OnChange := cdExecStateFactStartTimeChange;
    (cdExecState.FieldByName('FactFinishTime_ICalc') as TDateTimeField).DisplayFormat := ShortTimeFormat;
    (cdExecState.FieldByName('FactFinishTime_ICalc') as TDateTimeField).OnChange := cdExecStateFactFinishTimeChange;

    //(cdExecState.FieldByName('PlanStartDate') as TDateTimeField).OnGetText := PlanDateGetText;
    //(cdExecState.FieldByName('PlanStartDate') as TDateTimeField).OnChange := cdExecStateAnyChange;
    //(cdExecState.FieldByName('PlanFinishDate') as TDateTimeField).OnChange := cdExecStateAnyChange;
    (cdExecState.FieldByName(TOrderProcessItems.F_PlanStart) as TDateTimeField).DisplayFormat := ShortDateFormat;
    (cdExecState.FieldByName(TOrderProcessItems.F_PlanFinish) as TDateTimeField).DisplayFormat := ShortDateFormat;
    (cdExecState.FieldByName(TOrderProcessItems.F_FactStart) as TDateTimeField).OnChange := cdExecStateAnyChange;
    //(cdExecState.FieldByName('FactStartDate') as TDateTimeField).OnGetText := FactDateGetText;
    (cdExecState.FieldByName(TOrderProcessItems.F_FactFinish) as TDateTimeField).OnChange := cdExecStateAnyChange;
    if FIsWorkView then
      cdExecState.AfterScroll := UpdateDTControls;
    if dsExecState = nil then dsExecState := TDataSource.Create(Self);
    dsExecState.OnDataChange := ExecStateDataChange;
    dsExecState.DataSet := cdExecState;
    SetExecStateDS(dsExecState);
    // устанавливаем можно ли редактировать, но потом фрейм будет сам проверять,
    // есть ли у пользователя на это право.
    FProgressFrame.AllowEdit := not FPreviewMode and FIsWorkView;
    FProgressFrame.Visible := FIsWorkView;
    cdExecState.Filter := 'EnableTracking and not HideItem and Enabled or IsPartName';
    if not FIsWorkView then
      cdExecState.Filter := '(EstimatedDuration is not null) and ' + cdExecState.Filter;
    cdExecState.Filtered := true;
  //end;

  // Таблица "Описание"
  dgCost.DataSource := nil;
  dtWorkCost.DataSource := nil;
  dtMatCost.DataSource := nil;
  if cdCost <> nil then FreeAndNil(cdCost);
  cdCost := TClientDataSet.Create(Self);
  cdCost.CloneCursor(FProcessItems.DataSet as TClientDataSet, false);
  cdCost.AfterScroll := cdCostAfterScroll;
  cdCost.Filter := 'not HideItem';
  // Показывать только включенные в режиме предв. просмотра
  if FPreviewMode then
    cdCost.Filter := cdCost.Filter + ' and Enabled or IsPartName'
  else
    // Не показывать записи, которые выключенные и связанные одновременно
    cdCost.Filter := cdCost.Filter + ' and (Enabled or LinkedItemID = 0 or LinkedItemID is null)';
  cdCost.Filtered := true;
  (cdCost.FieldByName(TOrderProcessItems.F_Cost) as TNumericField).DisplayFormat := NumDisplayFmt;
  cdCost.FieldByName(TOrderProcessItems.F_Cost).OnGetText := cdCost_CostGetText;
  (cdCost.FieldByName(TOrderProcessItems.F_OwnCost) as TNumericField).DisplayFormat := NumDisplayFmt;
  cdCost.FieldByName(TOrderProcessItems.F_OwnCost).OnGetText := GenericCostGetText;
  (cdCost.FieldByName('ItemProfit') as TNumericField).DisplayFormat := NumDisplayFmt;
  (cdCost.FieldByName('ItemProfit') as TNumericField).EditFormat := NumEditFmt;
  cdCost.FieldByName('ItemProfit').OnGetText := GenericCostGetText;
  cdCost.FieldByName('IsItemInProfit').OnChange := cdCostIsItemInProfitChange;
  (cdCost.FieldByName(TOrderProcessItems.F_FinalProfitCost) as TNumericField).DisplayFormat := NumDisplayFmt;
  cdCost.FieldByName(TOrderProcessItems.F_FinalProfitCost).OnGetText := FinalCostGetText;//GenericCostGetText;
  cdCost.FieldByName(TOrderProcessItems.F_ContractorProcess).OnChange := ContractorProcessChange;
  (cdCost.FieldByName(TOrderProcessItems.F_EnabledMatCost) as TNumericField).DisplayFormat := NumDisplayFmt;
  (cdCost.FieldByName(TOrderProcessItems.F_EnabledWorkCost) as TNumericField).DisplayFormat := NumDisplayFmt;
  // Столкнулся с непонятной проблемой при изменении этого поля, поэтому пока
  // изменение запрещено.
  //cdCost.FieldByName(SrvEnabledField).OnChange := cdCostMatEnabledChange;
  if dsCost = nil then dsCost := TDataSource.Create(Self);
  dsCost.DataSet := cdCost;
  dgCost.DataSource := dsCost;
  dgCost.Repaint;
  if not FPreviewMode and FCostVisible then
  begin
    dtWorkCost.DataSource := dsCost;
    dtMatCost.DataSource := dsCost;
    paWorkMat.Visible := true;
  end
  else
  begin
    paWorkMat.Visible := false;
  end;

  // Таблица "Субподряд"
  dgContr.DataSource := nil;
  dtContrWorkCost.DataSource := nil;
  dtContrMatCost.DataSource := nil;
  if cdContr <> nil then FreeAndNil(cdContr);
  cdContr := TClientDataSet.Create(Self);
  cdContr.CloneCursor(FProcessItems.DataSet as TClientDataSet, false);
  cdContr.AfterScroll := cdContrAfterScroll;
  //cdContr.Filter := '(not HideItem and ContractorProcess) or (IsPartName and (ProductIn > 0))';c
  cdContr.Filter := '(not HideItem and ContractorProcess) or IsPartName';
  // Показывать только включенные в режиме предв. просмотра
  if FPreviewMode then cdContr.Filter := cdContr.Filter + ' and Enabled or IsPartName';
  cdContr.Filtered := true;
  (cdContr.FieldByName(TOrderProcessItems.F_ContractorCost) as TNumericField).DisplayFormat := NumDisplayFmt;
  (cdContr.FieldByName(TOrderProcessItems.F_ContractorCost) as TNumericField).EditFormat := NumEditFmt;
  cdContr.FieldByName(TOrderProcessItems.F_ContractorCost).OnGetText := ContractorCostGetText;

  (cdContr.FieldByName(TOrderProcessItems.F_ContractorPercent) as TNumericField).DisplayFormat := '##0.##%';
  (cdContr.FieldByName(TOrderProcessItems.F_ContractorPercent) as TNumericField).EditFormat := '##0.##';
  cdContr.FieldByName(TOrderProcessItems.F_ContractorPercent).OnGetText := GenericCostGetText;
  cdContr.FieldByName(TOrderProcessItems.F_ContractorPercent).OnChange := ContractorPercentChange;

  (cdContr.FieldByName(TOrderProcessItems.F_FinalProfitCost) as TNumericField).DisplayFormat := NumDisplayFmt;
  (cdContr.FieldByName(TOrderProcessItems.F_FinalProfitCost) as TNumericField).EditFormat := NumEditFmt;

  (cdContr.FieldByName(TOrderProcessItems.F_FactContractorCost) as TNumericField).DisplayFormat := NumDisplayFmt;
  (cdContr.FieldByName(TOrderProcessItems.F_FactContractorCost) as TNumericField).EditFormat := NumEditFmt;
  cdContr.FieldByName(TOrderProcessItems.F_FactContractorCost).OnGetText := ContractorCostGetText;
  cdContr.FieldByName(TOrderProcessItems.F_FactContractorCost).OnChange := FactContractorCostChange;

  cdContr.FieldByName(TOrderProcessItems.F_Contractor).OnChange := ContractorChange;
  cdContr.FieldByName(TOrderProcessItems.F_ContractorProcess).OnChange := ContractorProcessChange;
  cdContr.FieldByName(TOrderProcessItems.F_ContractorPayDate).OnChange := ContractorPayDateChange;
  cdContr.FieldByName(TOrderProcessItems.F_FactFinish).OnChange := ContractorPayDateChange;
  cdContr.FieldByName(TOrderProcessItems.F_PlanFinish).OnChange := ContractorPayDateChange;
  cdContr.FieldByName(TOrderProcessItems.F_FactStart).OnChange := ContractorPayDateChange;
  cdContr.FieldByName(TOrderProcessItems.F_PlanStart).OnChange := ContractorPayDateChange;
  //(cdContr.FieldByName('FinalProfitCost') as TNumericField).DisplayFormat := '###,###,##0.00';
  //cdContr.FieldByName('FinalProfitCost').OnGetText := GenericCostGetText;
  (cdContr.FieldByName(TOrderProcessItems.F_EnabledMatCost) as TNumericField).DisplayFormat := NumDisplayFmt;
  (cdContr.FieldByName(TOrderProcessItems.F_EnabledWorkCost) as TNumericField).DisplayFormat := NumDisplayFmt;

  if dsContr = nil then dsContr := TDataSource.Create(Self);
  dsContr.DataSet := cdContr;
  dgContr.DataSource := dsContr;
  dgContr.Repaint;
  if not FPreviewMode and FCostVisible then
  begin
    dtContrWorkCost.DataSource := dsContr;
    dtContrMatCost.DataSource := dsContr;
    paContrWorkMat.Visible := true;
  end
  else
  begin
    paContrWorkMat.Visible := false;
  end;

  // Таблица "Материалы"
  {dgMat.DataSource := nil;
  if cdMat <> nil then FreeAndNil(cdMat);
  cdMat := TClientDataSet.Create(Self);
  cdMat.CloneCursor(dm.cdProcessItems, false);}
  // Столкнулся с непонятной проблемой при изменении этого поля, поэтому пока
  // изменение запрещено.
  //cdMat.FieldByName(SrvEnabledField).OnChange := cdCostMatEnabledChange;
  {cdMat.FieldByName('MatAmount').OnGetText := cdMatMatAmountGetText;
  cdMat.Filter := 'not HideItem and (MatAmount > 0) and Enabled';
  cdMat.Filtered := true;
  if dsMat = nil then dsMat := TDataSource.Create(Self);
  dsMat.DataSet := cdMat;
  dgMat.DataSource := dsMat;
  dgMat.Repaint;}
  dgMat.DataSource := FProcessItems.Materials.DataSource;
  btCancelRequest.Enabled := AccessManager.CurKindPerm.CancelMaterialRequest;
  {FMaterialAfterScrollID := FProcessItems.Materials.AfterScrollNotifier.RegisterHandler(MaterialAfterScroll);
  if FProcessItems.Materials.Active then
    MaterialAfterScroll(nil);}

  if (FOrderShipment <> nil) and (dgShipment.DataSource <> FOrderShipment.DataSource) then
    dgShipment.DataSource := FOrderShipment.DataSource;


//  Таблица "Продукция на склад"

  //if FIsWorkView and (



end;

procedure TfOrderItems.dgEnabledDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  cd: TDataSet;
  Bmp: TBitmap;
begin
  if Column.Field = nil then Exit;
  // Здесь рисуется признак работа своя или субподряд
  if (Column.FieldName = TOrderProcessItems.F_Enabled) then
  begin
    Column.Grid.Canvas.FillRect(Rect);
    cd := Column.Field.DataSet;
    if not cd.IsEmpty and not NvlBoolean(cd[TOrderProcessItems.F_IsPartName]) then
    begin
      if NvlBoolean(cd[TOrderProcessItems.F_Enabled]) then
      begin
        if NvlBoolean(cd[TOrderProcessItems.F_ContractorProcess]) then Bmp := ContrBmp else Bmp := OwnBmp;
      end
      else
      begin
        if NvlBoolean(cd[TOrderProcessItems.F_ContractorProcess]) then Bmp := ContrDisBmp else Bmp := OwnDisBmp;
      end;
      if Bmp <> nil then
         DrawBitmapTransparent((Sender as TMyDBGridEh).Canvas, (Rect.Right + Rect.Left - Bmp.Width) div 2 + 1,
                            (Rect.Top + Rect.Bottom - Bmp.Height) div 2, Bmp, clFuchsia);
    end;
  end
  else if ((Column.FieldName = TOrderProcessItems.F_IsItemInProfit)
    or (Column.FieldName = TOrderProcessItems.F_ContractorProcess))
    and (VarIsNull(Column.Field.DataSet[TOrderProcessItems.F_IsPartName])
      or Column.Field.DataSet[TOrderProcessItems.F_IsPartName]) then
    Column.Grid.Canvas.FillRect(Rect);
end;

procedure TfOrderItems.BeforeCloseData;
begin
  if cdCost <> nil then FreeAndNil(cdCost);
  if cdContr <> nil then FreeAndNil(cdContr);
  //if cdMat <> nil then FreeAndNil(cdMat);
  if cdExecState <> nil then FreeAndNil(cdExecState);
  //if FProcessItems <> nil then
  //begin
    //FProcessItems.Materials.AfterScrollNotifier.UnregisterHandler(FMaterialAfterScrollID);
  //end;

  // Затычка непонятного глюка. Для воспроизведения надо выбрать один заказ по номеру,
  // в котором 3 отгрузки и встать на последнюю, потом открыть его. Слетает после открытия и закрытия
  // в глубине DBGridEh, что-то с подсчетом кол-ва строк.
  dgShipment.DataSource := nil;
end;

procedure TfOrderItems.dgExecStateEstimatedDurationGetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
var
  DurValue: variant;
begin
  DurValue := cdExecState[TOrderProcessItems.F_EstimatedDuration];
  if not VarIsNull(DurValue) then
  begin
    Params.Text := FormatTimeValue(DurValue);
  end
  else
    Params.Text := '';
end;

procedure TfOrderItems.dgExecStateColumnsExecStateGetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  if NvlBoolean(cdExecState[TOrderProcessItems.F_IsPartName]) then begin
    Params.ImageIndex := EmptyIndex;
    Params.ReadOnly := true;
  end else
    Params.ReadOnly := not NvlBoolean(cdExecState['PermitFact'])
end;

procedure TfOrderItems.dgExecStateColumnsFactGetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
var
  Text: string;
begin
{  Params.ReadOnly := true;
  if not NvlBoolean(cdExecState['IsPartName']) and not NvlBoolean(cdExecState['EnablePlanning']) then
    Params.ReadOnly := not NvlBoolean(cdExecState['PermitFact']);}
  FactDateGetText((Sender as TColumnEh).Field, Text, true);
  Params.Text := Text;
end;

procedure TfOrderItems.dgExecStateColumnsPlanGetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
var
  Text: string;
begin
{  Params.ReadOnly := not NvlBoolean(cdExecState['PermitPlan'])
                     or NvlBoolean(cdExecState['IsPartName'])
                     or NvlBoolean(cdExecState['EnablePlanning']);
  if not NvlBoolean(cdExecState['IsPartName']) then begin
    v := (Sender as TColumnEh).Field.Value;
    if VarIsNull(v) then Params.Text := ''
    else Params.Text := FormatDateTime(((Sender as TColumnEh).Field as TDateTimeField).DisplayFormat, v);
  end;}
  PlanDateGetText((Sender as TColumnEh).Field, Text, true);
  Params.Text := Text;
end;

procedure TfOrderItems.dgMatColumnsPlanReceiveDateUpdateData(Sender: TObject;
  var Text: string; var Value: Variant; var UseText, Handled: Boolean);
begin
  if Text = '' then
    FProcessItems.Materials.PlanReceiveDate := null
  else
    FProcessItems.Materials.PlanReceiveDate := Value;
  Handled := true;
end;

procedure TfOrderItems.dgMatDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
var
  Bmp: TBitmap;
begin
  if (Column.Field <> nil) and (Column.Field.FieldName = TMaterials.F_ExternalMatID) then
  begin
    if not Column.Field.IsNull then
    begin
      Bmp := GetSyncStateImage(SyncState_Syncronized);
      DrawBitmapTransparent(dgMat.Canvas,
        (Rect.Right + Rect.Left - bmp.Width) div 2 + 1,
        (Rect.Top + Rect.Bottom - bmp.Height) div 2, bmp, clFuchsia)
    end
    else
      dgMat.Canvas.FillRect(Rect);
  end
  else
    dgMat.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TfOrderItems.dgMatGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  if FProcessItems.Materials.RequestModified then
  begin
    Background := clRed;
    AFont.Color := clWhite;
  end;
end;

procedure TfOrderItems.dgMatPayDateUpdateData(Sender: TObject;
  var Text: string; var Value: Variant; var UseText, Handled: Boolean);
begin
  if Text = '' then
    FProcessItems.Materials.PayDate := null
  else
    FProcessItems.Materials.PayDate := Value;
  Handled := true;
end;

procedure TfOrderItems.dgMatColumnsFactReceiveDateUpdateData(Sender: TObject;
  var Text: string; var Value: Variant; var UseText, Handled: Boolean);
begin
  if Text = '' then
    FProcessItems.Materials.FactReceiveDate := null
  else
    FProcessItems.Materials.FactReceiveDate := Value;
  Handled := true;
end;

procedure TfOrderItems.SetCostVisible(c: boolean);
begin
  FCostVisible := c;
  UpdateColumnsVisible;
end;

procedure TfOrderItems.SetProfitPreviewVisible(c: boolean);
begin
  FProfitPreviewVisible := c;
  UpdateColumnsVisible;
end;

procedure TfOrderItems.SetProfitInsideVisible(c: boolean);
begin
  FProfitInsideVisible := c;
  UpdateColumnsVisible;
end;

{procedure SetColumnVisible(Col: TColumnEh; Visible: boolean);
begin
  if Col.Visible = Visible then
    Col.Visible := not Visible;
  Col.Visible := Visible;
end;}

procedure TfOrderItems.UpdateColumnsVisible;
var
  ViewFact, EditReq, EditPayDate, ShowExecState: boolean;
begin
  //FOrder.ReadKindPermissions(IsNewOrder);
  ViewFact := AccessManager.CurKindPerm.FactCostView;
  EditReq := AccessManager.CurKindPerm.EditMaterialRequest;
  EditPayDate := AccessManager.CurUser.UpdateMatPayDate;
  ShowExecState := FIsWorkView and AccessManager.CurUser.ViewProduction;

  if FPreviewMode then
  begin
    // Cost
    dgCost.FieldColumns[TOrderProcessItems.F_Cost].Visible := false;
    // Cost + Profit
    //dgCost.FieldColumns[TOrderProcessItems.F_FinalProfitCost].Visible := FCostVisible and FProfitInsideVisible;
    dgCost.FieldColumns[TOrderProcessItems.F_FinalProfitCost].Title.Caption := 'Стоимость';
    // Profit
    dgCost.FieldColumns[TOrderProcessItems.F_ItemProfit].Visible := false;
    dgCost.FieldColumns[TOrderProcessItems.F_IsItemInProfit].Visible := false;//FProfitPreviewVisible and FModifyProfit;

    // Субподряд
    dgContr.FieldColumns[TOrderProcessItems.F_ContractorPercent].Visible := false;  // наценка
    dgContr.FieldColumns[TOrderProcessItems.F_ContractorCost].Visible := false;  // без наценки
    dgContr.FieldColumns[TOrderProcessItems.F_ContractorCostNative].Visible := false;
    //dgContr.FieldColumns[F_FinalProfitCost].Title.Caption := 'Стоимость';
    dgContr.FieldColumns[TOrderProcessItems.F_FinalProfitCost].Visible := false; // 24.02.2008 изменен вид таблицы
    dgContr.FieldColumns[TOrderProcessItems.F_Contractor].Visible := false; // 24.02.2008 изменен вид таблицы
    dgContr.FieldColumns[TOrderProcessItems.F_FactContractorCost].Visible := false;  // фактическая
    dgContr.FieldColumns[TOrderProcessItems.F_ContractorPayDate].Visible := false;  // дата оплаты за субподряд

    // Материалы
    // В заказах стоимость отображается, только если установлена настройка
    dgMat.FieldColumns[TMaterials.F_MatCost].Visible :=
      FCostVisible and not Options.ShowFinalNative and (not FIsWorkView or not Options.ShowMatDateInWorkOrderPreview);
    dgMat.FieldColumns[TMaterials.F_MatCostNative].Visible :=
      FCostVisible and Options.ShowFinalNative and (not FIsWorkView or not Options.ShowMatDateInWorkOrderPreview);
    dgMat.FieldColumns[TMaterials.F_FactMatCost].Visible := false;

    // Выполнение
    if tsExecState.TabVisible then
    begin
      dgExecState.FieldColumns[TOrderProcessItems.F_PlanStart].Title.Caption := 'Плановое время|Факт. время';
      dgExecState.FieldColumns[TOrderProcessItems.F_FactStart].Visible := false;
      dgExecState.RowLines := 1;
      dgExecState.FieldColumns[TOrderProcessItems.F_PlanStart].Visible := ShowExecState;
    end;
  end
  else
  begin
    dgCost.Columns.BeginUpdate;
    // Cost
    dgCost.FieldColumns[TOrderProcessItems.F_Cost].Visible := FCostVisible;
    // Cost + Profit
    //dgCost.FieldColumns[TOrderProcessItems.F_FinalProfitCost].Visible := FCostVisible and FProfitInsideVisible;
    dgCost.FieldColumns[TOrderProcessItems.F_FinalProfitCost].Title.Caption := 'Для заказчика';
    // Profit
    dgCost.FieldColumns[TOrderProcessItems.F_ItemProfit].Visible := FCostVisible and FProfitInsideVisible;
    dgCost.FieldColumns[TOrderProcessItems.F_IsItemInProfit].Visible := FCostVisible and FProfitInsideVisible and FModifyProfit;

    {if dgCost.FieldColumns[TOrderProcessItems.F_FinalProfitCost].Visible then
      dgCost.FieldColumns[TOrderProcessItems.F_FinalProfitCost].Width := dgCost.FieldColumns[TOrderProcessItems.F_Cost].Width;}
    // Субподряд
    dgContr.FieldColumns[TOrderProcessItems.F_ContractorPercent].Visible := FCostVisible and FProfitInsideVisible;  // наценка
    dgContr.FieldColumns[TOrderProcessItems.F_ContractorCost].Visible := FCostVisible and FProfitInsideVisible and not Options.ShowFinalNative;  // без наценки
    dgContr.FieldColumns[TOrderProcessItems.F_FinalProfitCost].Title.Caption := 'Стоимость|Для заказчика';
    dgContr.FieldColumns[TOrderProcessItems.F_FinalProfitCost].Visible := FCostVisible and not Options.ShowFinalNative;  // с наценкой в уе
    dgContr.FieldColumns[TOrderProcessItems.F_ContractorCostNative].Visible := FCostVisible and Options.ShowFinalNative;  // с наценкой в грн
    dgContr.FieldColumns[TOrderProcessItems.F_FactContractorCost].Visible := FCostVisible;  // фактическая
    //dgContr.FieldColumns[F_FactContractorCost].ReadOnly := FContentProtected;  // запрещено изменение если защита состава
    dgContr.FieldColumns[TOrderProcessItems.F_ContractorPayDate].Visible := FCostVisible;  // дата оплаты за субподряд
    //dgContr.FieldColumns[F_ContractorPayDate].ReadOnly := FContentProtected;  // запрещено изменение если защита состава
    dgContr.FieldColumns[TOrderProcessItems.F_Contractor].Visible := true;

    // Материалы
    dgMat.FieldColumns[TMaterials.F_MatCost].Visible := FCostVisible and not Options.ShowFinalNative;
    dgMat.FieldColumns[TMaterials.F_MatCostNative].Visible := FCostVisible and Options.ShowFinalNative;
    dgMat.FieldColumns[TMaterials.F_FactMatCost].Visible := FCostVisible and FIsWorkView and ViewFact;

    // Выполнение
    if tsExecState.TabVisible then
    begin
      dgExecState.FieldColumns[TOrderProcessItems.F_PlanStart].Title.Caption := 'Плановое время';
      //dgExecState.FieldColumns[TOrderProcessItems.F_FactStart].Visible := true;
      dgExecState.RowLines := 0;
      dgExecState.FieldColumns[TOrderProcessItems.F_PlanStart].Visible := ShowExecState;
      dgExecState.FieldColumns[TOrderProcessItems.F_FactStart].Visible := ShowExecState;
    end;
  end;

  dgContr.FieldColumns[TOrderProcessItems.F_ContractorPercent].Visible := false;
  dgContr.FieldColumns[TOrderProcessItems.F_ContractorCost].Visible := false;
  dgContr.FieldColumns[TOrderProcessItems.F_PlanStart].Visible := not FPreviewMode;  // дата отправки
  dgContr.FieldColumns[TOrderProcessItems.F_FactStart].Visible := true;  // фактич. дата отправки
  dgContr.FieldColumns[TOrderProcessItems.F_PlanFinish].Visible := not FPreviewMode;  // дата получения
  dgContr.FieldColumns[TOrderProcessItems.F_FactFinish].Visible := true;  // фактич. дата получения
  dgContr.ReadOnly := FPreviewMode;

  // Материалы
  if ViewFact then
  begin
    dgMat.FieldColumns[TMaterials.F_SupplierID].ReadOnly := not EditReq;
    dgMat.FieldColumns[TMaterials.F_SupplierID].AlwaysShowEditButton := EditReq;
    dgMat.FieldColumns[TMaterials.F_FactReceiveDate].ReadOnly := not EditReq;
    dgMat.FieldColumns[TMaterials.F_FactReceiveDate].AlwaysShowEditButton := EditReq;
    dgMat.FieldColumns[TMaterials.F_PlanReceiveDate].ReadOnly := not EditReq;
    dgMat.FieldColumns[TMaterials.F_PlanReceiveDate].AlwaysShowEditButton := EditReq;
  end;

  dgMat.FieldColumns[TMaterials.F_SupplierID].Visible := not FPreviewMode and ViewFact;
  dgMat.FieldColumns[TMaterials.F_FactMatAmount].Visible := not FPreviewMode and FIsWorkView and ViewFact;
  dgMat.FieldColumns[TMaterials.F_PlanReceiveDate].Visible := FIsWorkView and Options.ShowMatDateInWorkOrderPreview;
  dgMat.FieldColumns[TMaterials.F_FactReceiveDate].Visible := FIsWorkView and Options.ShowMatDateInWorkOrderPreview;
  dgMat.FieldColumns[TMaterials.F_PayDate].Visible := not FPreviewMode and FIsWorkView and ViewFact and Options.ShowMatDateInWorkOrderPreview;
  if FIsWorkView then
  begin
    dgMat.FieldColumns[TMaterials.F_PlanReceiveDate].AlwaysShowEditButton := not FPreviewMode;
    dgMat.FieldColumns[TMaterials.F_FactReceiveDate].AlwaysShowEditButton := not FPreviewMode;
    if ViewFact then
    begin
      dgMat.FieldColumns[TMaterials.F_PayDate].ReadOnly := not EditPayDate;
      dgMat.FieldColumns[TMaterials.F_PayDate].AlwaysShowEditButton := EditPayDate;
    end;
  end;
  dgMat.FieldColumns[TMaterials.F_MatUnitName].Visible := not FPreviewMode;
  dgMat.ReadOnly := FPreviewMode;

  //dgMat.FieldColumns[F_PlanReceiveDate].ReadOnly := FPreviewMode;
  //dgMat.FieldColumns[F_FactReceiveDate].ReadOnly := FPreviewMode;

  // Отгрузка
  if tsShipment.TabVisible then
  begin
    dgShipment.FieldColumns[TShipmentDoc.F_WhoOut].Visible := not FPreviewMode;
    dgShipment.FieldColumns[TShipmentDoc.F_WhoIn].Visible := not FPreviewMode;
  end;

  if FOrderInvPayFrame <> nil then
    FOrderInvPayFrame.PreviewMode := FPreviewMode;
end;

procedure TfOrderItems.SetModifyProfit(c: boolean);
begin
  FModifyProfit := c;
  UpdateColumnsVisible;
end;

procedure TfOrderItems.UpdateDTControls(DataSet: TDataSet);
begin
  if not DataSet.ControlsDisabled then
    FProgressFrame.UpdateControls;
end;

procedure TfOrderItems.dgCostProfitColumnsGetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  Params.ReadOnly := not FModifyProfit or NvlBoolean(cdCost[TOrderProcessItems.F_IsPartName]);
end;

procedure TfOrderItems.AfterCreate;
var
  picClip: TjvPicClip;
begin
  TSettingsManager.Instance.XPInitComponent(btMakeOwnCost);
  TSettingsManager.Instance.XPInitComponent(btMakeContractor);

  SetIniStorage(TSettingsManager.Instance.MainFormStorage);

  HandlerID := TConfigManager.Instance.StandardDics.StdDicsChanged.RegisterHandler(DicNotifyHandler);
  ContractorHandlerID := Contractors.OpenNotifier.RegisterHandler(ContractorNotifyHandler);
  if not Contractors.DataSet.Active then Contractors.Open;
  SupplierHandlerID := Suppliers.OpenNotifier.RegisterHandler(SupplierNotifyHandler);
  if not Suppliers.DataSet.Active then Suppliers.Open;

  // Берем картинки с кнопок
  picClip := TjvPicClip.Create(nil);
  try
    picClip.Picture.Bitmap := btMakeOwn.Glyph;
    picClip.Cols := 2;
    OwnBmp := TBitmap.Create;
    OwnBmp.Assign(picClip.GraphicCell[0]);
    OwnDisBmp := TBitmap.Create;
    OwnDisBmp.Assign(picClip.GraphicCell[1]);
    picClip.Picture.Bitmap := btMakeContractor.Glyph;
    picClip.Cols := 2;
    ContrBmp := TBitmap.Create;
    ContrBmp.Assign(picClip.GraphicCell[0]);
    ContrDisBmp := TBitmap.Create;
    ContrDisBmp.Assign(picClip.GraphicCell[1]);
  finally
    picClip.Free;
  end;

  FProgressFrame := TProgressFrame.Create(Self);
  FProgressFrame.Parent := tsExecState;

  RightToLeft;

  FillStates;
  FillContractors;
  FillSuppliers;
end;

procedure TfOrderItems.BeforeDestroy;
begin
  // проверяется на nil т.к. могла уже сработать их финализация
  if TConfigManager.Instance.StandardDics <> nil then
    TConfigManager.Instance.StandardDics.StdDicsChanged.UnregisterHandler(HandlerID);
  if Contractors <> nil then Contractors.OpenNotifier.UnregisterHandler(ContractorHandlerID);
  if Suppliers <> nil then Suppliers.OpenNotifier.UnregisterHandler(ContractorHandlerID);
  if ContrBmp <> nil then FreeAndNil(ContrBmp);
  if OwnBmp <> nil then FreeAndNil(OwnBmp);
  if ContrDisBmp <> nil then FreeAndNil(ContrDisBmp);
  if OwnDisBmp <> nil then FreeAndNil(OwnDisBmp);
end;

procedure TfOrderItems.btnEditToStorageClick(Sender: TObject);
begin
  FProductStorage.EditRecord;
end;

procedure TfOrderItems.dgCostColumns4GetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
var
  f: TNumericField;
  v: extended;
begin
  if NvlBoolean(cdCost[TOrderProcessItems.F_IsPartName]) then
    Params.Text := ''
  else
  begin
    f := TNumericField(cdCost.FieldByName(TOrderProcessItems.F_Cost));
    v := NvlFloat(f.Value) + NvlFloat(cdCost['ItemProfit']);
    Params.Text := FormatFloat(f.DisplayFormat, v);
    if v > 0 then Params.Font.Style := [fsBold];
  end;
end;

procedure TfOrderItems.dgContrColumnsContractorGetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  Params.ReadOnly := NvlBoolean(cdContr[TOrderProcessItems.F_IsPartName]);
  Params.Alignment := taLeftJustify;
end;

procedure TfOrderItems.ContractorChange(Sender: TField);
begin
  FProcessItems.DataSet.FieldByName(TOrderProcessItems.F_Contractor).OnChange(Sender);
end;

procedure TfOrderItems.ContractorProcessChange(Sender: TField);
begin
  FProcessItems.DataSet.FieldByName(TOrderProcessItems.F_ContractorProcess).OnChange(Sender);
end;

procedure TfOrderItems.ContractorPercentChange(Sender: TField);
begin
  FProcessItems.DataSet.FieldByName(TOrderProcessItems.F_ContractorPercent).OnChange(Sender);
end;

procedure TfOrderItems.ContractorPayDateChange(Sender: TField);
begin
  //if cdContr.State in [dsInsert, dsEdit] then cdContr.Post;
  //dm.cdProcessItems.FieldByName(F_ContractorPayDate).OnChange(Sender);
  FProcessItems.DataSet.FieldByName(Sender.FieldName).OnChange(Sender);
end;

procedure TfOrderItems.FactContractorCostChange(Sender: TField);
begin
  FProcessItems.DataSet.FieldByName(TOrderProcessItems.F_FactContractorCost).OnChange(Sender);
end;

procedure TfOrderItems.dgContrContractorCostNativeGetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  Params.Text := GetContractorCostText(TOrderProcessItems.F_ContractorCostNative);
end;

procedure TfOrderItems.dgContrColumnsContractorEditButtonDown(Sender: TObject;
  TopButton: Boolean; var AutoRepeat, Handled: Boolean);
begin
  Handled := NvlBoolean(cdContr[TOrderProcessItems.F_IsPartName]);
end;

procedure TfOrderItems.dgContrColumnsFinalProfitCostGetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  Params.Text := GetContractorCostText(TOrderProcessItems.F_FinalProfitCost);
end;

function TfOrderItems.GetContractorCostText(FieldName: string): string;
var
  f: TNumericField;
  v: extended;
begin
  if NvlBoolean(cdContr[TOrderProcessItems.F_IsPartName]) then
    Result := ''
  else
  begin
    if NvlBoolean(cdContr[TOrderProcessItems.F_ContractorProcess]) then
    begin
      f := TNumericField(cdContr.FieldByName(FieldName));
      v := NvlFloat(f.Value);
      if v > 0 then
      begin
        Result := FormatFloat(f.DisplayFormat, v);
        //Params.Font.Style := [fsBold];
      end
      else
        Result := '';
    end
    else
      Result := '';
  end;
end;

procedure TfOrderItems.btnAddToStorageClick(Sender: TObject);
begin
//  FOnAddToStorage(nil);
  FProductStorage.AppendRecord;
end;

procedure TfOrderItems.btnDeleteFromStorageClick(Sender: TObject);
begin
//  FOnDeleteFromStorage(nil);
  FProductStorage.DeleteRecord;
end;

procedure TfOrderItems.btAddShipmentClick(Sender: TObject);
begin
  FOnAddShipment(nil);
end;

procedure TfOrderItems.btApproveOrderMaterialsClick(Sender: TObject);
begin
  FOnApproveOrderMaterials(nil);
end;

procedure TfOrderItems.btApproveShipmentClick(Sender: TObject);
begin
  FOnApproveShipment(nil);
end;

procedure TfOrderItems.btCancelRequestClick(Sender: TObject);
begin
  FOnCancelMaterialRequest(nil);
end;

procedure TfOrderItems.btDeleteShipmentClick(Sender: TObject);
begin
  FOnDeleteShipment(nil);
end;

procedure TfOrderItems.btEditShipmentClick(Sender: TObject);
begin
  FOnEditShipment(nil);
end;

procedure TfOrderItems.btEditMatRequestClick(Sender: TObject);
begin
  if Assigned(FOnEditMatRequest) then // в расчетах не инициализируется
    FOnEditMatRequest(nil);
  //FOnExternalMat(nil);
end;

procedure TfOrderItems.btMakeContractorClick(Sender: TObject);
begin
  MakeOwn(cdCost, false);
end;

procedure TfOrderItems.btMakeOwnClick(Sender: TObject);
begin
  MakeOwn(cdContr, true);
end;

procedure TfOrderItems.btMakeOwnCostClick(Sender: TObject);
begin
  MakeOwn(cdCost, true);
end;

procedure TfOrderItems.MakeOwn(ds: TDataSet; Own: boolean);
begin
  if not (ds.State in [dsInsert, dsEdit]) then ds.Edit;
  ds[TOrderProcessItems.F_ContractorProcess] := not Own;
  if ds.State in [dsInsert, dsEdit] then ds.Post;
  UpdateCostControls;
  UpdateContractorControls;
end;

procedure TfOrderItems.SetControlsVisible(comp: TWinControl; Vis: boolean);
var
  I: Integer;
begin
  for I := 0 to comp.ControlCount - 1 do
    comp.Controls[i].Visible := Vis;
end;

procedure TfOrderItems.dgContrColumnsFactContractorCostGetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
var
  f: TNumericField;
  v: extended;
begin
  if NvlBoolean(cdContr[TOrderProcessItems.F_IsPartName]) then
    Params.Text := ''
  else
  begin
    if NvlBoolean(cdContr[TOrderProcessItems.F_ContractorProcess])
      and NvlBoolean(cdContr[TOrderProcessItems.F_ManualContractorCost]) then
    begin
      f := TNumericField(cdContr.FieldByName('FactContractorCost'));
      v := NvlFloat(f.Value);
      //if v > 0 then
      //begin
        Params.Text := FormatFloat(f.DisplayFormat, v);
        Params.Font.Style := [fsBold];
      //end
      //else
      //  Params.Text := '';
    end
    else
      Params.Text := '';
  end;
end;

procedure TfOrderItems.SetContentProtected(const Value: Boolean);
begin
  FContentProtected := Value;
  UpdateProtection;
end;

procedure TfOrderItems.SetCostProtected(const Value: Boolean);
begin
  FCostProtected := Value;
  UpdateProtection;
end;

procedure TfOrderItems.UpdateProtection;
begin
  cbShowChanges.Visible := not FContentProtected;
end;

// Пришлось сделать такой обработчик, иначе не получается одновременно вводить
// дату вручную и выбирать из календаря.
procedure TfOrderItems.dgContrColumnsPayDateUpdateData(Sender: TObject;
  var Text: String; var Value: Variant; var UseText, Handled: Boolean);
begin
  cdContr.Edit;
  if Text = '' then
    cdContr[TOrderProcessItems.F_ContractorPayDate] := null
  else
    cdContr[TOrderProcessItems.F_ContractorPayDate] := Value;
  cdContr.Post;
  Handled := true;
end;

procedure TfOrderItems.dgContrColumnsFactFinishDateUpdateData(Sender: TObject;
  var Text: string; var Value: Variant; var UseText, Handled: Boolean);
begin
  cdContr.Edit;
  if Text = '' then
    cdContr[TOrderProcessItems.F_FactFinish] := null
  else
    cdContr[TOrderProcessItems.F_FactFinish] := Value;
  cdContr.Post;
  Handled := true;
end;

procedure TfOrderItems.dgContrColumnsPlanFinishDateUpdateData(Sender: TObject;
  var Text: string; var Value: Variant; var UseText, Handled: Boolean);
begin
  cdContr.Edit;
  if Text = '' then
    cdContr[TOrderProcessItems.F_PlanFinish] := null
  else
    cdContr[TOrderProcessItems.F_PlanFinish] := Value;
  cdContr.Post;
  Handled := true;
end;

procedure TfOrderItems.dgContrColumnsPlanStartDateUpdateData(Sender: TObject;
  var Text: string; var Value: Variant; var UseText, Handled: Boolean);
begin
  cdContr.Edit;
  if Text = '' then
    cdContr[TOrderProcessItems.F_PlanStart] := null
  else
    cdContr[TOrderProcessItems.F_PlanStart] := Value;
  cdContr.Post;
  Handled := true;
end;

procedure TfOrderItems.dgContrColumnsFactStartDateUpdateData(Sender: TObject;
  var Text: string; var Value: Variant; var UseText, Handled: Boolean);
begin
  cdContr.Edit;
  if Text = '' then
    cdContr[TOrderProcessItems.F_FactStart] := null
  else
    cdContr[TOrderProcessItems.F_FactStart] := Value;
  cdContr.Post;
  Handled := true;
end;

{procedure TfOrderItems.MaterialAfterScroll(Sender: TObject);
begin
  if FIsWorkView then
  begin
    FOrder.ReadKindPermissions(IsNewOrder);
    btCancelRequest.Enabled := AccessManager.CurKindPerm.CancelMaterialRequest
      and not FProcessItems.Materials.IsEmpty and FProcessItems.Materials.RequestModified;
  end
  else
    btCancelRequest.Enabled := false;
end;}

procedure TfOrderItems.Activate;
begin
  dgExecState.SumList.RecalcAll;
end;

end.
