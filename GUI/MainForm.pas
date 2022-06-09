unit MainForm;

{$I Calc.inc}

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, Mask, Db,
  DBCtrls, Menus, Spin, JvSpeedbar, Dialogs, ImgList,
  JvPicclip, JvFormPlacement, DBClient, ADODb,
  ActnList, Variants, JvLabel, JvExDBGrids,
  JvImageList, JvComponentBase,
  JvInterpreter, JvNetscapeSplitter, JvJCLUtils,

  PmActions, fCommonToolbar, DBGridEh, XPMenu,
  CalcSettings, DicObj, CalcUtils, NotifyEvent, PmProviders,
  fEntSettings, PmCfgUpdater, PmEntityController, PmEntity,
  GridsEh, MyDBGridEh,
  PmDatabase, PmOrder, XPMan, PmOrderController, PmDraftController, PmWorkController,
  PmReportData, PmReportController
  // -- все перечисленные ниже - для документов использующих ReportBuilder Designer!
{  , ppEndUsr,
  ppDB, ppDBPipe, ppBands, ppCache, ppClass, ppComm, ppRelatv,
  ppProd, ppReport }
  // -- для сообщений
{$IFNDEF NoNet}
//  , Psock, NMMSG
{$ENDIF}
{$IFDEF Test}
  , GUITestRunner
{$ENDIF}
  ;

const
  ProgramVersion = 020752;    // Текущая версия программы. Не используется

{const
  forNew  = 0;
  forEdit = 1;}

var
  // К сожалению, из нижеперечисленных переменных используется только CourseNotifIgnore.
  // В сети с несколькими пользователями они могут сильно уменьшить
  // количество лишних обновлений.
//  ContrNotifIgnore, CalcNotifIgnore, WorkNotifIgnore, PricesNotifIgnore,
  CourseNotifIgnore: boolean;

type
  TReportProc = procedure;

  TMForm = class(TForm)
    Timer: TTimer;
    pmDicMenu: TPopupMenu;
    MainMenu: TMainMenu;
    miMain: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N10: TMenuItem;
    miCustomers: TMenuItem;
    N12: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    miTables: TMenuItem;
    miReports: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N29: TMenuItem;
    N31: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    alMain: TActionList;
    acNewOrder: TAction;
    acEditOrder: TAction;
    acDelOrder: TAction;
    acCopyOrder: TAction;
    acOrderProps: TAction;
    acShowDep: TAction;
    acUpdateDep: TAction;
    acCheckOrder: TAction;
    acRefresh: TAction;
    acShowAll: TAction;
    acSetPrices: TAction;
    acMakeWork: TAction;
    acMakeCalc: TAction;
    acExportOrder: TAction;
    acImportOrder: TAction;
    acExit: TAction;
    acCustomers: TAction;
    acPrint: TAction;
    acExpenses: TAction;
    acUsers: TAction;
    acInterface: TAction;
    acGScripts: TAction;
    acToolbar: TAction;
    C1: TMenuItem;
    N36: TMenuItem;
    acSaveOrder: TAction;
    acCancelOrder: TAction;
    N45: TMenuItem;
    N46: TMenuItem;
    N47: TMenuItem;
    N48: TMenuItem;
    N22: TMenuItem;
    N50: TMenuItem;
    acUE: TAction;
    pmReports: TPopupMenu;
    MainFormStorage: TJvFormStorage;
    imNormal: TJvImageList;
    imDisabled: TJvImageList;
    imHot: TJvImageList;
    imMisc: TJvImageList;
    acHistory: TAction;
    miService: TMenuItem;
    N30: TMenuItem;
    miHistory: TMenuItem;
    acContractors: TAction;
    acSuppliers: TAction;
    miContractors: TMenuItem;
    miSuppliers: TMenuItem;
    N37: TMenuItem;
    acShowFilter: TAction;
    miShowFilter: TMenuItem;
    acDisplayInfo: TAction;
    N43: TMenuItem;
    acCustomReports: TAction;
    N49: TMenuItem;
    acTest: TAction;
    est1: TMenuItem;
    acImportBatch: TAction;
    acEntSettings: TAction;
    N51: TMenuItem;
    acUpdateCfg: TAction;
    acWideList: TAction;
    N53: TMenuItem;
    N55: TMenuItem;
    N58: TMenuItem;
    miPlan: TMenuItem;
    miProduction: TMenuItem;
    miInWork: TMenuItem;
    miRecycleBin: TMenuItem;
    acOrderRecycleBin: TAction;
    acGlobalHistory: TAction;
    miGlobalHistory: TMenuItem;
    acContragentRecycleBin: TAction;
    acContragentRecycleBin1: TMenuItem;
    N20: TMenuItem;
    N38: TMenuItem;
    acCustomerPayments: TAction;
    N40: TMenuItem;
    acEditConfig: TAction;
    N60: TMenuItem;
    XPManifest1: TXPManifest;
    acIncomingInvoices: TAction;
    miIncomeInvoice: TMenuItem;
    N41: TMenuItem;
    acInvoices: TAction;
    acMakeInvoice: TAction;
    N61: TMenuItem;
    MessageTimer: TTimer;
    paToolbar: TPanel;
    panLeft: TPanel;
    pcCalcOrder: TPageControl;
    paProTool: TPanel;
    Panel2: TPanel;
    lbRecCount: TLabel;
    paCurrentToolbar: TPanel;
    paCommonToolbar: TPanel;
    acEditOrderInvoice: TAction;
    acNewInvoice: TAction;
    acEditInvoice: TAction;
    acDeleteInvoice: TAction;
    acPrintInvoiceForm: TAction;
    acNewIncome: TAction;
    acEditIncome: TAction;
    acDeleteIncome: TAction;
    acPrintOrders: TAction;
    acPrintProduction: TAction;
    acPrintSchedule: TAction;
    acAddJob: TAction;
    acRemoveJob: TAction;
    acEditJob: TAction;
    acSplitJob: TAction;
    acOpenOrderJob: TAction;
    acEditCommentJob: TAction;
    acPrintIncomes: TAction;
    acRestore: TAction;
    acPurge: TAction;
    acPurgeAll: TAction;
    acExportToExcel: TAction;
    acCloseView: TAction;
    acPayInvoice: TAction;
    acPrintInvoiceReport: TAction;
    miShipment: TMenuItem;
    N14: TMenuItem;
    acShowShipment: TAction;
    acNewShipment: TAction;
    acEditShipment: TAction;
    acDeleteShipment: TAction;
    acShipmentReport: TAction;
    acShipmentForm: TAction;
    acOpenShipmentOrder: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    N13: TMenuItem;
    N3: TMenuItem;
    acEditPaymentInvoice: TAction;
    miMaterialRequests: TMenuItem;
    acMaterialRequests: TAction;
    acOpenMatRequestOrder: TAction;
    miSaleDocs: TMenuItem;
    acShowSaleDocs: TAction;
    acNewSaleDoc: TAction;
    acEditSaleDoc: TAction;
    acDeleteSaleDoc: TAction;
    acPrintSaleDocForm: TAction;
    acSaveConfig: TAction;
    miMaterials: TMenuItem;
    acAllMaterials: TAction;
    miAllMaterials: TMenuItem;
    acStockMove: TAction;
    miStockMove: TMenuItem;
    acStockIncome: TAction;
    acStockWaste: TAction;
    N4: TMenuItem;
    N21: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    acNewStock: TAction;
    acEditStock: TAction;
    acDeleteStock: TAction;
    acPrintStockReport: TAction;
    acPrintStockForm: TAction;
    acPrintStockMoveReport: TAction;
    acNewStockIncome: TAction;
    acEditStockIncome: TAction;
    acDeleteStockIncome: TAction;
    acPrintStockIncomeForm: TAction;
    acPrintStockIncomeReport: TAction;
    acPrintSaleReport: TAction;
    acEditMatRequest: TAction;
    acDeleteMatRequest: TAction;
    acUndo: TAction;
    acLockSchedule: TAction;
    acUnlockSchedule: TAction;
    acSaveMatRequests: TAction;
    acCancelMatRequests: TAction;
    acPrintMatRequestsReport: TAction;
    acNewStockWaste: TAction;
    acEditStockWaste: TAction;
    acDeleteStockWaste: TAction;
    acPrintStockWasteForm: TAction;
    acPrintStockWasteReport: TAction;
    procedure FormCreate(Sender: TObject);

    procedure acExitExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    {procedure btPanRightClick(Sender: TObject);
    procedure btPanLeftClick(Sender: TObject);
    procedure acNewOrderExecute(Sender: TObject);
    procedure acDeleteOrderExecute(Sender: TObject);}
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure acPrintExecute(Sender: TObject);
    //procedure acOrderPropsExecute(Sender: TObject);
    procedure acCustomersExecute(Sender: TObject);
    //procedure acSetPricesExecute(Sender: TObject);
    procedure acReloadExecute(Sender: TObject);
    //procedure acCopyOrderExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure acInterfaceExecute(Sender: TObject);
    procedure miNotifClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure NotifServMSG(Sender: TComponent; const sFrom, sMsg: String);
    procedure pcCalcOrderChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acMakeOrderExecute(Sender: TObject);
    procedure acMakeDraftExecute(Sender: TObject);
    procedure acShowAllExecute(Sender: TObject);
    procedure btDecomposeClick(Sender: TObject);
    procedure acShowDependsExecute(Sender: TObject);
    procedure acUpdateDependsExecute(Sender: TObject);
    procedure acExpenseExecute(Sender: TObject);
    procedure panLeftResize(Sender: TObject);
    procedure pmPayAccClick(Sender: TObject);
    procedure acDicsExecute(Sender: TObject);
    procedure acToolbarCustExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acCheckRepExecute(Sender: TObject);
    //procedure CalcTimerTimer(Sender: TObject);
    procedure pcCalcOrderChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure acGScriptsExecute(Sender: TObject);
    procedure miOrderReportClick(Sender: TObject);
    procedure miCustomReportClick(Sender: TObject);
    procedure acUEExecute(Sender: TObject);
    procedure MainFormStorageSavePlacement(Sender: TObject);
    procedure acContractorsExecute(Sender: TObject);
    procedure acSuppliersExecute(Sender: TObject);
    procedure acShowFilterExecute(Sender: TObject);
    procedure acDisplayInfoExecute(Sender: TObject);
    procedure acCustomReportsExecute(Sender: TObject);
    procedure acTestExecute(Sender: TObject);
    procedure acEntSettingsExecute(Sender: TObject);
    procedure acUpdateCfgExecute(Sender: TObject);
    procedure acWideListExecute(Sender: TObject);
    procedure miProcessPlanClick(Sender: TObject);
    procedure miProcessProductionClick(Sender: TObject);
    procedure acOrderRecycleBinExecute(Sender: TObject);
    procedure acGlobalHistoryExecute(Sender: TObject);
    procedure acContragentRecycleBinExecute(Sender: TObject);
    //procedure tsCalcResize(Sender: TObject);
    //procedure tsWorkResize(Sender: TObject);
    procedure acCustomerPaymentsExecute(Sender: TObject);
    procedure acEditConfigExecute(Sender: TObject);
    procedure acIncomingInvoicesExecute(Sender: TObject);
    procedure acInvoicesExecute(Sender: TObject);
    //procedure acMakeInvoiceExecute(Sender: TObject);
    procedure MessageTimerTimer(Sender: TObject);
    //procedure EditOrderInvoice(Sender: TObject);
    procedure acCloseViewExecute(Sender: TObject);
    procedure acPayInvoiceExecute(Sender: TObject);

    procedure acEditPayInvoiceExecute(Sender: TObject);
    procedure acShowShipmentExecute(Sender: TObject);
    procedure acShowSaleDocsExecute(Sender: TObject);
    procedure acMaterialRequestsExecute(Sender: TObject);
    procedure acAllMaterialsExecute(Sender: TObject);
    procedure acStockMoveExecute(Sender: TObject);
    procedure acStockIncomeExecute(Sender: TObject);
    procedure acStockWasteExecute(Sender: TObject);
  private
    XPMenuPainter: TXPMenu;
    FirstActive: boolean;
    FCurrentController: TEntityController;
    SettingsChangedHandlerID: TNotifyHandlerID;
    miCustomReportsMainMenu, miCustomReportsToolbar: TMenuItem;
    FViews: TList;
    FToolbar: TjvSpeedBar;
    FCommonToolbar: TjvSpeedBar;
    //procedure FilterChange;
    //procedure DisableFilter;
    //function GetAppStorage: TJvCustomAppStorage;
    procedure ReloadView(ev: TEntityController);
    procedure ReloadCurrent;
    //function GetInDocs: boolean;
    //function GetPageControl(GrpID: integer): TPageControl;
    procedure UpdateRepMenuEnabled;
    procedure UpdateReportsMenu;
    procedure UpdateCustomReportsMenu;
    procedure UpdatePlanMenu;
    procedure DependsAction(Show: boolean);
    //procedure DisableOrderItems;
    //procedure SetupOrderItems;
    //procedure UpdateExecStateInDataSets;  // 31.12.2004
    procedure CreateXPMenu;
    procedure ReloadViews;
    procedure FreshOrderViews;
    procedure SetCurrentView(const Value: TEntityController);
    //procedure WideOrderListChanged;
    //function GetGridOwner(Grid: TOrderGridClass): TOrder;
    function GetLastCourse: extended;  // Получение курса с сервера
    function GetCurrentData: TDataSet;
    //procedure OrderAfterOpen(Sender: TObject);
    function CreateController(E: TEntity): TEntityController;
    procedure OpenRecycleBin(ObjectType: integer);
    procedure View_AfterRefresh(Sender: TObject);
    procedure OpenCustomerPayments;
    procedure OpenIncomingInvoices;
    function OpenInvoices: boolean;
    function InsideOrder: boolean;
    procedure DoOnRightToLeft(Sender: TObject);
    function GetCurrentCustomer: integer;
    function OpenEntityView(Entity: TEntity): boolean;
    procedure ViewCloseError(E: Exception);

    //procedure SetupToolbar;
  public
    //State: TOrderEditMode;
    //ViewMode: TOrderViewMode;
    OldTotalGrn: extended;
    //Prikid: boolean;
    {$IFNDEF NoNet}
    NotifServ: TNMMSGServ;
    {$ENDIF}
    procedure HideFilter(Sender: TObject);
    procedure SetupServices;
    procedure SetCourse(NewCourse: extended);
    //procedure NotifyModification;
    //procedure NotifyCreation;
    procedure LoadToolbarPic;
    //procedure NewOrder(ParamsProvider: IOrderParamsProvider);
    //procedure EditOrderProps(ParamsProvider: IOrderParamsProvider);
    procedure OnSettingsChanged(Sender: TObject);
    //procedure DeleteAllOrders;
    //procedure EditCurrent;
    //procedure CancelCurrent;
    //function SaveCurrent: boolean;
    //procedure DeleteCurrent(Confirm: boolean);
    //procedure OrderBeforeScroll(Sender: TObject); overload;
    //procedure OrderBeforeScroll; overload;
    procedure SetCurrentData(dq: TDataSet);
    procedure UpdateRecordCount;
    procedure UpdateCaption;
    procedure InvoicesAfterScroll(Sender: TObject);
    procedure ShowFilterChanged;
    procedure CreateViews(Entities: TList);
    //procedure FreeViews;
    procedure SaveViewSettings;
    procedure LoadViewSettings;
    procedure ShowWorkOrderView;  // делает активной страницу с заказами
    // открывает автоматически закрывающийся редактор заказа
    function OpenWorkOrderView: TWorkController;
    function OpenOrderView(Order: TOrder): TOrderController;
    // возвращает активный элемент со списком заказов или список заказов,
    // если оба неактивные или ноль если списка заказов нету
    function CurrentOrderView: TOrderController;
    function FindController(ViewClass: TEntityControllerClass): TEntityController;
    procedure MakeDraftOrder(DraftParamsProvider: IMakeDraftParamsProvider); overload;
    procedure MakeDraftOrder(FWorkView: TWorkController; FDraftView: TDraftController;
      DraftParamsProvider: IMakeDraftParamsProvider); overload;
    procedure MakeWorkOrder(FDraftView: TDraftController; FWorkView: TWorkController;
      WorkParamsProvider: IMakeOrderParamsProvider); overload;
    procedure MakeWorkOrder(WorkParamsProvider: IMakeOrderParamsProvider); overload;
    procedure OpenCustomReportView(ReportData: TReportData; ReportID: integer; SourceView: TEntityController);
    procedure CloseCurrentView;
    function OpenShipment: boolean;
    // расходные накладные
    function OpenSaleDocs: boolean;
    function OpenMaterialRequests: boolean;
    function OpenStock: boolean;
    function OpenStockMove: boolean;
    function OpenStockIncome: boolean;
    function OpenStockWaste: boolean;

    constructor Create(Owner: TComponent); override;

    property CurrentData: TDataSet read GetCurrentData;
    property CurrentController: TEntityController read FCurrentController write SetCurrentView;
    //property InDocs: boolean read GetInDocs;
  end;

  TPageControlClass = TPageControl;

const
  MaxGrids = 2;   // максимальное количество таблиц на одной странице

var
  MForm: TMForm;
  //cdOrd: TDataSet;

implementation

uses Maindata, OrdProp, PmContragentListForm,
  JvJVCLUtils, OptInt,
  RDialogs, MkOrder, {NtfConst, }{DecOrder, }RDBUtils,
  {ADOReClc, }PmOrderExchange, PmInit, PmEntSettings,
  MkCalc, ExHandler, DicFrm, RepsFrm, UEFrm, PmScriptManager, RepData, ColorLst,
  RAI2_CalcSrv, PmAccessManager, StdDic, PmContragent,
  DispInfo, PmCustomReport, fDisplayInfo, fCustomReports, PmAppController,
  PmPlan, PmPlanController, PmRecycleBin, PmBaseRecycleBinView, PmCustomerPaymentsView,
  PmConfigView, PmConfigTreeEntity, PmIncomingInvoiceView,
  PmInvoiceController, PmCustomReportBuilder, {PmMessenger,} PmMessageDialog,
  PmOrderInvoiceItems, PmOrderPayments, PmShipment, PmShipmentController, PmMaterialRequestController,
  PmConfigManager
{$IFNDEF NoProduction}
  , PmProductionController, PmProduction
{$ENDIF}
{$IFDEF NoFinance}
  {, QStrings}
{$ENDIF}
{$IFNDEF NoExpenses}
  , ExpnsFrm
{$ENDIF}
{$IFNDEF NoDocs}
  ,fDoc, DocDM, NDocFrm, EDocOrd, OrdSel
{$ENDIF}
{$IFNDEF NoNet}
  , OptCalc, NtfQueue      
{$ENDIF}
{$IFNDEF NoTriada}
{$IFDEF RepBuild}
  , TechCard
{$ENDIF}
{$ENDIF}
{$IFDEF RepBuild}
  , fOrdRep, UpcoForm, PrintFrm
{$ENDIF}
;
{$R *.DFM}
{$R BACKGRND.R32}
{$R SORTBMP.R32}
{$R CALCRES.RES}
{$R ORDSTATES.RES}
{$R PAYSTATES.RES}

constructor TMForm.Create;
begin
  inherited Create(Owner);
  MainFormStorage.AppStorage := TSettingsManager.Instance.Storage;
  TSettingsManager.Instance.MainFormStorage := MainFormStorage;
end;

procedure TMForm.LoadToolbarPic;
var
  fnBack: string;
begin
  {if Options.BackEn then
  begin
    if Trim(Options.fnBack) <> '' then
    try
      fnBack := Options.fnBack;
      if ExtractFileDir(fnBack) = '' then fnBack := ExtractFileDir(ParamStr(0)) + '\' + fnBack;
      FToolbar.Wallpaper.Bitmap.FreeImage;
      FToolbar.Wallpaper.Bitmap.ReleaseHandle;
      FToolbar.Wallpaper.Bitmap.LoadFromFile(fnBack);
    except
      RusMessageDlg('Не могу открыть файл изображения для панели инструментов', mtError, [mbOk], 0)
    end
    else
      FToolbar.Wallpaper.Bitmap.Handle := LoadBitmap(hInstance, 'BACKGROUND');
  end
  else
  begin
    FToolbar.Wallpaper.Bitmap.FreeImage;
    FToolbar.Wallpaper.Bitmap.ReleaseHandle;
  end;}
  FToolbar.Repaint;
end;

procedure TMForm.CreateViews(Entities: TList);
var
  i: integer;
  E: TEntity;
begin
  //FreeViews;
  // !!!!!!!!!!!!!!!!!!!!!!!!!
  // TODO: Здесь надо настраивать интерфейс - создавать страницы, фреймы и т.д.
  FViews := TList.Create;
  for i := 0 to Entities.Count - 1 do
  begin
    E := Entities[i];
    CreateController(E);
  end;
  if FViews.Count > 0 then
    FCurrentController := FViews[0];
end;

// Создает вид для сущности, возвращает nil если нет прав на просмотр
function TMForm.CreateController(E: TEntity): TEntityController;
var
  View: TEntityController;
  ts: TTabSheet;
  Frame: TFrame;
begin
  View := AppController.CreateEntityView(E);
  //View.MainStorage := MainFormStorage;
  // Добавляем только видимые
  if View.Visible then
  begin
    FViews.Add(View);
    View.AfterRefresh := View_AfterRefresh;
    View.OnCloseMe := acCloseViewExecute;
    if E is TOrder then
    begin
      (View as TOrderController).OnRightToLeft := DoOnRightToLeft;
      //(View as TOrderView).OnEnterOrder := DoOnEnterOrder;
    end;
    // Создаем страничку для этого view
    ts := TTabSheet.Create(Self);
    ts.PageControl := pcCalcOrder;
    ts.Caption := View.Caption;
    ts.Font.Style := [];
    Frame := View.CreateFrame(Self);
    Frame.Parent := ts;
  end
  else
  begin
    View.Free;
    View := nil;
  end;
  Result := View;
end;

procedure TMForm.DoOnRightToLeft(Sender: TObject);
var
  AnotherView: TEntityController;
  I: Integer;
begin
  if Sender is TDraftController then
    AnotherView := FindController(TWorkController)
  else if Sender is TWorkController then
    AnotherView := FindController(TDraftController)
  else
    ExceptionHandler.Raise_('DoOnRightToLeft');
    
  if AnotherView <> nil then
    for I := 0 to pcCalcOrder.PageCount - 1 do
    begin
      if AnotherView.Frame = pcCalcOrder.Pages[i].Controls[0] then
      begin
        pcCalcOrder.Pages[i].TabVisible := true;
      end;
    end;
end;

// Called after setting changed
procedure TMForm.ReloadViews;
var
  i: integer;
  EView: TEntityController;
  //c: boolean;
begin
  //OrderBeforeScroll;
  {MForm.AllNotifIgnore := true;
  c := CalcTimer.Enabled;
  CalcTimer.Enabled := false;
  try}
    for i := 0 to FViews.Count - 1 do begin
      EView := FViews[i];
      if EView.Visible then EView.Entity.Reload;
    end;
  {finally
    MForm.AllNotifIgnore := false;
    CalcTimer.Enabled := c;
  end;}
end;

// Called after setting changed ????????
// updates calculated fields
procedure TMForm.FreshOrderViews;
var
  i: integer;
  EView: TEntityController;
begin
  // могут быть еще не инициализированы (при первом вызове при загрузке настроек)
  if FViews <> nil then begin
    {MForm.AllNotifIgnore := true;
    try}
      for i := 0 to FViews.Count - 1 do begin
        EView := FViews[i];
        if EView.Visible and (EView is TOrderController) then
          FreshQuery(EView.Entity.DataSet);
      end;
    {finally
      MForm.AllNotifIgnore := false;
    end;}
  end;
end;

{procedure TMForm.OrderAfterOpen(Sender: TObject);
begin
  UpdateRecordCount;
end;}

{procedure TMForm.SetupToolbar;
begin
  if Options.GrayBtn and not (sbGrayedBtns in FToolbar.Options) then
    FToolbar.Options := FToolbar.Options + [sbGrayedBtns]
  else if not Options.GrayBtn and (sbGrayedBtns in FToolbar.Options) then
    FToolbar.Options := FToolbar.Options - [sbGrayedBtns];

  if Options.FlatBtn and not (sbFlatBtns in MForm.Toolbar.Options) then
    FToolbar.Options := FToolbar.Options + [sbFlatBtns]
  else if not Options.FlatBtn and (sbFlatBtns in MForm.Toolbar.Options) then
    FToolbar.Options := FToolbar.Options - [sbFlatBtns];

  LoadToolbarPic; // картинки
end;}

procedure TMForm.OnSettingsChanged(Sender: TObject);
begin
  XPMenuPainter.Active := TSettingsManager.Instance.XPPainterEnabled;
  ShowFilterChanged;
  acShowFilter.Checked := Options.ShowFilterPanel;
  //if TSettingsManager.Instance.NeedReload then ReloadViews else FreshViews;
end;

procedure TMForm.CreateXPMenu;
begin
  XPMenuPainter := TSettingsManager.Instance.CreateXPPainter(Self);
end;

procedure TMForm.FormCreate(Sender: TObject);
var
  FCommonToolbarFrame: TCommonToolbarFrame;
begin
  SettingsChangedHandlerID := TSettingsManager.Instance.SettingsChanged.RegisterHandler(OnSettingsChanged);

  TSettingsManager.Instance.MainImageList := imNormal;

  CreateXPMenu;
  //ViewMode := vmLeft;
  //State := stNone;
  FirstActive := true;

  TMainActions.Actions := alMain;

  FCommonToolbarFrame := TCommonToolbarFrame.Create(Self);
  FCommonToolbar := FCommonToolbarFrame.Toolbar;
  paCommonToolbar.Width := FCommonToolbar.Width;
  FCommonToolbar.Parent := paCommonToolbar;
  FCommonToolbarFrame.siReports.DropDownMenu := pmReports;

  CreateColorItems;

  TOrderController.UpdateKindLists;

  // Прячем пункт меню с поставщиками, если они объединены с подрядчиками
  if EntSettings.AllContractors then
  begin
    miContractors.Caption := 'Поставщики и подрядчики...';
    acSuppliers.Visible := false;
  end;

  TMainActions.Actions := alMain;  // интересно, зачем второй раз?

  OnSettingsChanged(Self);

{$IFDEF NoFinance}
  dtClientPrice.Visible := false;
  lbClientPrice.Visible := false;
  tsFinance.TabVisible := false;
  siExpense.Visible := false;
  acProfitEdit.Visible := false;
{$ENDIF}
{$IFNDEF NoNet}
  NotifServ := TNMMSGServ.Create(MForm);
{$ENDIF}
{$IFDEF NoTriada}
{$IFDEF RepBuild}
  miRepBreak.Visible := false;
  acTechCard.Visible := false;
  acEditTech.Visible := false;
{$ENDIF}
{$ENDIF}
{$IFDEF Manager}
  dtClientPrice.Visible := false;
  lbClientPrice.Visible := false;
{$ENDIF}
{$IFNDEF Test}
  acTest.Visible := false;
{$ENDIF}
{$IFDEF NoExpenses}
  acExpenses.Visible := false;
{$ENDIF}
end;

procedure TMForm.SetupServices;
begin
  ScriptPopupMenu := pmDicMenu;
  ScriptMainForm := MForm;
end;

procedure TMForm.acExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TMForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin
  SaveViewSettings;
  if FViews <> nil then
  begin
    for I := 0 to FViews.Count - 1 do
      TEntityController(FViews[I]).Free;
    FreeAndNil(FViews);
  end;
  DoneApplication;
end;

(*procedure TMForm.acNewOrderExecute(Sender: TObject);   // Новый расчет
begin
  OrderBeforeScroll;  // Для режима автоматического открытия
  {$IFNDEF NoDocs}
  if InDocs and (DocFrame <> nil) then DocFrame.NewDoc
  else
  {$ENDIF}
  if CurrentView is TOrderView then
    NewOrder(TOrderFormParamsProvider.Create)
  else if CurrentView is TInvoiceView then
    (CurrentView as TInvoiceView).NewInvoice(0);
end;*)

procedure TMForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  I: Integer;
  CView: TEntityController;
begin
  if Options.ConfirmQuit then
    CanClose := RusMessageDlg('Вы действительно хотите выйти из программы?', mtConfirmation, mbYesNo, 0) = mrYes
  else
    CanClose := true;

  if (FViews <> nil) and CanClose then
  begin
    // Закрываем все страницы
    for I := 0 to FViews.Count - 1 do
    begin
      //pcCalcOrder.ActivePageIndex := I;
      CView := TEntityController(FViews[I]);
      try
        if not CView.CanClose then
        begin
          pcCalcOrder.ActivePageIndex := I;
          CanClose := false;
          break;
        end;
      except on E: Exception do
        begin
          ViewCloseError(E);
          CanClose := true;
        end;
      end;
    end;
  end;

  if CanClose then
  begin
    // Вырубаем все таймеры...
    Timer.Enabled := false;
    MessageTimer.Enabled := false; // таймер сообщений
  end;

end;

procedure TMForm.acPrintExecute(Sender: TObject);
begin
  (*if InDocs then begin
    {$IFNDEF NoDocs}
    if ActiveControl = dgAdd then
      ExecPrintDoc(dmd.cdAdd)
    else
      ExecPrintDoc(dmd.cdContract);
    {$ENDIF}
  end else *)
  if TSettingsManager.Instance.DefaultReportID <> -1 then
    miOrderReportClick(nil);
end;

procedure TMForm.acCustomerPaymentsExecute(Sender: TObject);
begin
  OpenCustomerPayments;
end;

function TMForm.GetCurrentCustomer: integer;
begin
  Result := 0;
  if CurrentController is TOrderController then
  begin
    if not (CurrentController as TOrderController).Order.IsEmpty then
      Result := (CurrentController as TOrderController).Order.CustomerID;
  end
  else if CurrentController is TInvoiceController then
  begin
    if not (CurrentController as TInvoiceController).Invoices.IsEmpty then
      Result := (CurrentController as TInvoiceController).Invoices.CustomerID;
  end;
    //ExceptionHandler.Raise_('Неправильный контекст вызова GetCurrentCustomer: ' + CurrentView.ClassName);
end;

procedure TMForm.OpenCustomerPayments;
var
  k: integer;
  ts: TTabSheet;
  E: TEntity;
  View: TCustomerPaymentsController;
  CustomerID: integer;
begin
  // ищем не открыта ли уже эта закладка
  if FViews <> nil then
  begin
    for k := 0 to FViews.Count - 1 do
      if (TObject(FViews[k]) is TCustomerPaymentsController) then
      begin
        CustomerID := GetCurrentCustomer;
        View := TCustomerPaymentsController(FViews[k]);
        ts := View.Frame.Parent as TTabSheet;
        pcCalcOrder.ActivePage := ts;
        //for i := 0 to pcCalcOrder.Pages.Count - 1 do
        // Вызываем событие изменения текущей страницы
        pcCalcOrderChange(pcCalcOrder);
        // переключаем на текущего заказчика
        if CustomerID > 0 then
        begin
          View.CustomerID := CustomerID;
          View.CustomerChecked := true;
        end;
        Exit;
      end;
    // Если не открыта, открываем
    E := AppController.CustomersWithIncome;
    View := CreateController(E) as TCustomerPaymentsController;
    if View <> nil then  // может не быть прав(?)
    begin

      View.AfterRefresh := View_AfterRefresh;
      View.LoadSettings;

      CustomerID := GetCurrentCustomer;
      if CustomerID > 0 then
      begin
        View.CustomerID := CustomerID;
        View.CustomerChecked := true;
      end;

      ts := View.Frame.Parent as TTabSheet;
      pcCalcOrder.ActivePage := ts;
    end;
    // Вызываем событие изменения текущей страницы
    pcCalcOrderChange(pcCalcOrder);
  end;
end;

procedure TMForm.acCustomersExecute(Sender: TObject);
var
  CurCustomer: integer;
begin
  if FCurrentController <> nil then
  begin
    if (FCurrentController.Entity <> nil) and not FCurrentController.Entity.IsEmpty then
    begin
      try
        if FCurrentController is TOrderController then
          CurCustomer := (FCurrentController as TOrderController).Order.CustomerID
        else if FCurrentController is TCustomerPaymentsController then
          CurCustomer := FCurrentController.Entity.KeyValue
        else if FCurrentController is TInvoiceController then
          CurCustomer := (FCurrentController as TInvoiceController).Invoices.CustomerID
        else if FCurrentController is TMaterialRequestController then
          CurCustomer := (FCurrentController as TMaterialRequestController).MatRequests.CustomerID
        else
          CurCustomer := TContragents.NoNameKey;
      except
        CurCustomer := TContragents.NoNameKey;
      end;
    end;
  end
  else
    CurCustomer := TContragents.NoNameKey;
  ExecContragentSelect(Customers, CurCustomer, {SelectMode=} false);
end;

procedure TMForm.ReloadCurrent;
begin
  ReloadView(CurrentController);
end;

procedure TMForm.acReloadExecute(Sender: TObject);  // Обновляет текущую таблицу
begin
  ReloadCurrent;
end;

procedure TMForm.ReloadView(ev: TEntityController);
{var
  c: boolean;}
begin
  {AllNotifIgnore := true;
  c := CalcTimer.Enabled;            // Сохраняем состояние таймера
  CalcTimer.Enabled := false;
  try}
    ev.RefreshData;
  {finally
    AllNotifIgnore := false;
    CalcTimer.Enabled := Options.AutoOpen and c;
  end;}
end;

// Создание копии заказа
(*procedure TMForm.acCopyOrderExecute(Sender: TObject);
begin
  OrderBeforeScroll;  // Для режима автоматического открытия
  AllNotifIgnore := true;
  try
   {$IFNDEF NoDocs}
    if InDocs and dmd.cdContract.Active and not dmd.cdContract.IsEmpty then begin
      if CopyDoc(true) then
       {$IFNDEF NoNet}
        if SendContr then SendNotif(ContractNotif)
       {$ENDIF}
        ;
    end
    else begin
    {$ENDIF}
      if (CurrentView as TOrderView).CopyOrder(TCopyOrderFormParamsProvider.Create) then
        NotifyModification;
    {$IFNDEF NoDocs}
    end;
    {$ENDIF}
  finally
    AllNotifIgnore := false;
  end;
end;*)

{function TMForm.GetGridOwner(Grid: TOrderGridClass): TOrder;
var
  i: integer;
  View: TEntityView;
begin
  for i := 0 to FViews.Count - 1 do
  begin
    View := FViews[i];
    if (View is TOrderView) and ((View as TOrderView).MasterGrid = Grid) then
    begin
      Result := (View as TOrderView).Order;
      break;
    end;
  end;
  if Result = nil then raise EAssertionFailed.Create('Grid owner not found');
end;}

procedure TMForm.FormActivate(Sender: TObject);
begin
  if FirstActive then
  begin
    FirstActive := false;

    UpdateReportsMenu;
    UpdatePlanMenu;
    if (FViews <> nil) and (FViews.Count > 0) then
    begin
      FCurrentController := FViews[0];
      //FilterFrame.Entity := FCurrentView.Entity as TOrder;
      //FilterFrame.Activate;  // активизируем панель фильтра
    end;
    acUsers.Enabled := AccessManager.CurUser.EditUsers;
    acEditConfig.Enabled := AccessManager.CurUser.EditDics;
    acGScripts.Enabled := AccessManager.CurUser.EditModules;
    acCustomReports.Enabled := AccessManager.CurUser.EditCustomReports;
    acCustomerPayments.Enabled := AccessManager.CurUser.ViewPayments;
    acDisplayInfo.Enabled := AccessManager.CurUser.EditModules;
    // Пока сервисные функции по тем же правам что и настройки справочников
    miService.Enabled := AccessManager.CurUser.EditDics;
    // Пока инфопанель, настройки предприятия
    // по тем же правам что и сценарии.
    acEntSettings.Enabled := AccessManager.CurUser.EditModules;
    acUpdateCfg.Enabled := AccessManager.CurUser.EditModules;
    acShowAll.Enabled := EntSettings.PermitFilterOff;
    // взаиморасчеты
    acCustomerPayments.Enabled := AccessManager.CurUser.ViewPayments;
    acPayInvoice.Enabled := AccessManager.CurUser.AddPayments;
    // счета
    acInvoices.Enabled := AccessManager.CurUser.ViewInvoices;
    acNewInvoice.Enabled := AccessManager.CurUser.AddInvoices;
    acEditInvoice.Enabled := acNewInvoice.Enabled;
    acDeleteInvoice.Enabled := AccessManager.CurUser.DeleteInvoices;
    acMakeInvoice.Enabled := acNewInvoice.Enabled;
    acEditOrderInvoice.Enabled := acInvoices.Enabled;
    // отгрузка
    acShowShipment.Enabled := AccessManager.CurUser.ViewShipment;
    acShipmentReport.Enabled := acShowShipment.Enabled;
    acNewShipment.Enabled := AccessManager.CurUser.AddShipment;
    acEditShipment.Enabled := acNewShipment.Enabled;
    acDeleteShipment.Enabled := AccessManager.CurUser.DeleteShipment;
    // закупки
    acMaterialRequests.Enabled := AccessManager.CurUser.ViewMatRequests;
    {$IFDEF Manager}
    acCust.Enabled := false;
    acExpenses.Enabled := false;
    acProfitEdit.Enabled := false;
    acEditUsers.Enabled := false;
    acOrdRep.Enabled := false;
    acGScripts.Enabled := false;
    acNotif.Enabled := false;
    acUsers.Enabled := false;
    acEditConfig.Enabled := false;
    acEntSettings.Enabled := false;
    acCustomReports.Enabled := false;
    acDisplayInfo.Enabled := false;
    acUpdateCfg.Enabled := false;
    {$ENDIF}
    {$IFNDEF NoDocs}
    if DocFrame <> nil then DocFrame.EnableTimer;
    {$ENDIF}
  end;
end;

procedure TMForm.acIncomingInvoicesExecute(Sender: TObject);
begin
  OpenIncomingInvoices;
end;

procedure TMForm.OpenIncomingInvoices;
var
  k: integer;
  ts: TTabSheet;
  E: TEntity;
  View: TIncomingInvoiceView;
begin
  // ищем не открыта ли уже эта закладка
  if FViews <> nil then
  begin
    for k := 0 to FViews.Count - 1 do
      if (TObject(FViews[k]) is TIncomingInvoiceView) then
      begin
        ts := TIncomingInvoiceView(FViews[k]).Frame.Parent as TTabSheet;
        pcCalcOrder.ActivePage := ts;
        //for i := 0 to pcCalcOrder.Pages.Count - 1 do
        // Вызываем событие изменения текущей страницы
        pcCalcOrderChange(pcCalcOrder);
        Exit;
      end;
    // Если не открыта, открываем
    E := AppController.IncomingInvoices;
    View := CreateController(E) as TIncomingInvoiceView;
    if View <> nil then  // может не быть прав(?)
    begin

      View.AfterRefresh := View_AfterRefresh;
      View.LoadSettings;

      ts := View.Frame.Parent as TTabSheet;
      pcCalcOrder.ActivePage := ts;
    end;
    // Вызываем событие изменения текущей страницы
    pcCalcOrderChange(pcCalcOrder);
  end;
end;

procedure TMForm.acInvoicesExecute(Sender: TObject);
begin
  OpenInvoices;
end;

function TMForm.OpenInvoices: boolean;
var
  k: integer;
  ts: TTabSheet;
  E: TEntity;
  View: TInvoiceController;
begin
  // ищем не открыта ли уже эта закладка
  if FViews <> nil then
  begin
    Result := true;
    // если редактируется заказ то закрываем его
    {if (CurrentView is TOrderView)
      and ((FCurrentView as TOrderView).ViewMode <> vmLeft) then
    begin
      if MainModified then
        Result := AskForSave
      else
        CancelCurrent;
    end;}
    // Если заказ был закрыт успешно
    if Result then
    begin
      for k := 0 to FViews.Count - 1 do
        if (TObject(FViews[k]) is TInvoiceController) then
        begin
          ts := TInvoiceController(FViews[k]).Frame.Parent as TTabSheet;
          pcCalcOrder.ActivePage := ts;
          //for i := 0 to pcCalcOrder.Pages.Count - 1 do
          // Вызываем событие изменения текущей страницы
          pcCalcOrderChange(pcCalcOrder);
          Exit;
        end;
      // Если не открыта, открываем
      E := AppController.Invoices;
      View := CreateController(E) as TInvoiceController;
      if View <> nil then  // может не быть прав(?)
      begin

        View.AfterRefresh := View_AfterRefresh;
        View.LoadSettings;
        // TODO: это должно быть перенесено в TInvoicesFrame
        View.AfterScrollID2 := View.Entity.AfterScrollNotifier.RegisterHandler(InvoicesAfterScroll);
        View.OpenID := View.Entity.OpenNotifier.RegisterHandler(InvoicesAfterScroll);

        ts := View.Frame.Parent as TTabSheet;
        pcCalcOrder.ActivePage := ts;
      end;
      // Вызываем событие изменения текущей страницы
      pcCalcOrderChange(pcCalcOrder);
    end;
  end;
end;

procedure TMForm.acInterfaceExecute(Sender: TObject);
begin
  //OrderBeforeScroll;
  {CalcTimer.Enabled := false;
  try}
    if ExecOptIntForm = mrOk then
    begin
      {dgCalcOrder.Invalidate;
      if AccessManager.CurUser.WorkVisible then
        dgWorkOrder.Invalidate;}
    end;
  {finally
    CalcTimer.Enabled := Options.AutoOpen;
  end;}
end;

procedure TMForm.miNotifClick(Sender: TObject);
begin
{$IFNDEF NoNet}
  ExecOptNotifForm;
{$ENDIF}
end;

procedure ServerShutdownWarning;
begin
  RusMessageDlg('Через 5 минут произойдет перезагрузка сервера! Сохраните данные и закройте программу!',
     mtWarning, [mbOk], 0);
end;

procedure TMForm.TimerTimer(Sender: TObject);    // Просмотр/обработка очереди сообщений
begin
  {$IFNDEF NoNet}
  if NotifLock or (NotifQue = nil) or (NotifQue.Count = 0) then Exit;
  // Обработка выключения сервера производится в любом случае
  try
    // блокируем очередь
    NotifLock := true;
    if NotifQue.IndexOf(ServerShutdownNotif) <> -1 then
    begin
      ServerShutdownWarning;
      NotifQue.Delete(NotifQue.IndexOf(ServerShutdownNotif));
      Exit;
    end;
  finally
    NotifLock := false;  // разблокируем очередь
  end;
  if AllNotifIgnore then Exit;
  NotifLock := true;
  Timer.Enabled := false;         // Отключаемся, чтобы не вызвали еще раз
  try
    if not CalcNotifIgnore and (NotifQue.IndexOf(CalcNotif) <> -1) then begin
      ReloadQuery(qiCalc);               // Перечитывание калькуляций
      NotifQue.Delete(NotifQue.IndexOf(CalcNotif));
    end else
    if not CourseNotifIgnore and (NotifQue.IndexOf(CourseNotif) <> -1) then begin
      SetCourse(GetLastCourse);   // Перечитывание курса доллара
      NotifQue.Delete(NotifQue.IndexOf(CourseNotif));
    end else
    if not WorkNotifIgnore and (NotifQue.IndexOf(WorkOrderNotif) <> -1) then begin
      if PermitWork then
        ReloadQuery(qiWork);   // Перечитывание заказов
      NotifQue.Delete(NotifQue.IndexOf(WorkOrderNotif));
    end else
    if not PricesNotifIgnore and (NotifQue.IndexOf(PricesNotif) <> -1) then begin
{      DestroyPrices;   // Перечитывание цен - НЕ РАБОТАЕТ !!!!!!!!!!!!!!!!!!!!!!!!
      LoadDBPrices;}
      //if State = vmRight then sm.CalcAllCost;
      NotifQue.Delete(NotifQue.IndexOf(PricesNotif));
    end else
    if not ContrNotifIgnore and (NotifQue.IndexOf(ContractNotif) <> -1) then begin
      if AllowContract then
        ReloadQuery(qiContract);   // Перечитывание документов
      NotifQue.Delete(NotifQue.IndexOf(ContractNotif));
    end;
  finally
    NotifLock := false;           // Включаемся
    Timer.Enabled := true;
  end;
  {$ENDIF}
end;

// Обработчик приема сообщения
procedure TMForm.NotifServMSG(Sender: TComponent; const sFrom, sMsg: String);
begin
  {$IFNDEF NoNet}
  if CompareText(CurUser.Login, sFrom) = 0 then Exit;  // Сообщение от себя самого
  if (sMsg = CalcNotif) and ResCalc then AddNotif(sMsg)   // Ставим его в очередь
  else if (sMsg = CourseNotif) and ResCourse then AddNotif(sMsg)
  else if (sMsg = PricesNotif) and ResPrices then AddNotif(sMsg)
  else if (sMsg = WorkOrderNotif) and ResOrd then AddNotif(sMsg)
  else if (sMsg = ContractNotif) and ResContr then AddNotif(sMsg);
  {$ENDIF}
end;

function TMForm.InsideOrder: boolean;
begin
  Result := (FCurrentController is TOrderController) and ((FCurrentController as TOrderController).InsideOrder);
end;

procedure TMForm.SetCourse(NewCourse: extended);
var
  I: Integer;
  CView: TEntityController;
begin
  if FCurrentController = nil then
    TSettingsManager.Instance.AppCourse := NewCourse
  else
  begin
    // TODO: БРЕД какой-то, но иначе пока не получилось
    {if (FCurrentView is TOrderView) then
    begin
      if FCurrentView is TWorkView then
        (FCurrentView as TOrderView).Order.USDCourse := NewCourse;
      (FCurrentView as TOrderView).UpdateUSDCourse;
    end;
    if not InsideOrder or (FCurrentView.Entity is TDraftOrder) then
      TSettingsManager.Instance.AppCourse := NewCourse;
    if (FCurrentView.Entity is TOrder) then
      (FCurrentView.Entity as TOrder).Processes.CalcGrnGrandTotal;
    FreshOrderViews;}
    if not InsideOrder or (FCurrentController.Entity is TDraftOrder) then
      TSettingsManager.Instance.AppCourse := NewCourse;

    if (FCurrentController is TWorkController) and InsideOrder then
    begin
      (FCurrentController as TOrderController).Order.USDCourse := NewCourse;
      (FCurrentController as TOrderController).UpdateUSDCourse;
      (FCurrentController.Entity as TOrder).Processes.CalcGrnGrandTotal;
    end;

    for I := 0 to FViews.Count - 1 do
    begin
      CView := TEntityController(FViews[I]);
      if (CView is TDraftController) then
      begin
        (CView as TOrderController).UpdateUSDCourse;
        (CView.Entity as TOrder).Processes.CalcGrnGrandTotal;
      end;
    end;
    FreshOrderViews;
  end;
end;

// Переключение табчиков
procedure TMForm.pcCalcOrderChange(Sender: TObject);
var
  SaveParent: TWinControl;
  IsOrderOrInvoice{, IsOrder}: boolean;
begin
  // Если нет видимых элементов, то выходим сразу
  if (FViews = nil) or (FViews.Count = 0) then Exit;

  try
    FCurrentController := FViews[pcCalcOrder.ActivePage.TabIndex];

    if (FToolbar <> nil) then
      paCurrentToolbar.RemoveControl(FToolbar);
    FToolbar := CurrentController.GetToolbar;
    paCurrentToolbar.InsertControl(FToolbar);
    FToolbar.Parent := paCurrentToolbar;

    {$IFNDEF NoDocs}
    DocFrame.Visible := false;
    {$ENDIF}

    FCurrentController.Activate;

    UpdateRecordCount;
  except on E: Exception do
    ExceptionHandler.ProcessMessage(e.Message, '', '');
  end;
end;

procedure TMForm.FormShow(Sender: TObject);
begin
  pcCalcOrderChange(Sender);
end;

function TMForm.FindController(ViewClass: TEntityControllerClass): TEntityController;
var
  I: Integer;
begin
  Result := nil;
  if FViews <> nil then
  begin
    for I := 0 to FViews.Count - 1 do
      if TEntityController(FViews[I]).ClassType = ViewClass then
      begin
        Result := TEntityController(FViews[I]);
        break;
      end;
  end;
end;

procedure TMForm.acMakeOrderExecute(Sender: TObject);
begin
  if CurrentController is TDraftController then
    MakeWorkOrder(TMakeOrderFormParamsProvider.Create((CurrentController as TDraftController).Order));
end;

procedure TMForm.acMaterialRequestsExecute(Sender: TObject);
begin
  OpenMaterialRequests;
end;

procedure TMForm.acStockIncomeExecute(Sender: TObject);
begin
  OpenStockIncome;
end;

procedure TMForm.acStockWasteExecute(Sender: TObject);
begin
  OpenStockWaste;
end;

procedure TMForm.MakeWorkOrder(WorkParamsProvider: IMakeOrderParamsProvider);
var
  FWorkView: TWorkController;
begin
  if FCurrentController is TDraftController then
  begin
    if FCurrentController.Entity.IsEmpty then Exit;
    FWorkView := FindController(TWorkController) as TWorkController;
    if FWorkView <> nil then
      MakeWorkOrder(FCurrentController as TDraftController, FWorkView, WorkParamsProvider);
  end;
end;

// Преобразование расчета в заказ
procedure TMForm.MakeWorkOrder(FDraftView: TDraftController; FWorkView: TWorkController;
  WorkParamsProvider: IMakeOrderParamsProvider);
var
  KP: TKindPerm;
  NewId: integer;
begin
  AccessManager.ReadKindPermTo(KP, FDraftView.Order.KindID);
  if not KP.MakeWork then Exit;
  if FDraftView.MakeOrder(WorkParamsProvider, NewId) then
  begin
    // обновляем заказы
    FWorkView.Entity.ReloadLocate(NewId);

    // отменяем изменения, возможно, сделанные в параметрах расчета
    FDraftView.Entity.CancelUpdates;
    //ReloadMain(qiWork);  перечитывать не надо, это уже сделано
    if not WorkParamsProvider.CopyToWork then
    begin
      FDraftView.Entity.Reload;
      //NotifyModification;
    end;
    pcCalcOrder.ActivePageIndex := FViews.IndexOf(FWorkView);     // Переключаем на заказы
    pcCalcOrderChange(nil);
  end
  else
    // отменяем изменения, возможно, сделанные в параметрах расчета
    FDraftView.Entity.CancelUpdates;
end;

procedure TMForm.acMakeDraftExecute(Sender: TObject);
begin
  MakeDraftOrder(TMakeDraftFormParamsProvider.Create((CurrentController as TWorkController).Order));
end;

procedure TMForm.MakeDraftOrder(DraftParamsProvider: IMakeDraftParamsProvider);
var
  FDraftView: TDraftController;
begin
  if FCurrentController is TWorkController then
  begin
    if FCurrentController.Entity.IsEmpty then Exit;
    FDraftView := FindController(TDraftController) as TDraftController;
    if FDraftView <> nil then
      MakeDraftOrder(FCurrentController as TWorkController, FDraftView, DraftParamsProvider);
  end;
end;

// Преобразование заказа в расчет
procedure TMForm.MakeDraftOrder(FWorkView: TWorkController; FDraftView: TDraftController;
  DraftParamsProvider: IMakeDraftParamsProvider);
var
  KP: TKindPerm;
  NewId: integer;
begin
  if FWorkView.MakeDraft(DraftParamsProvider, NewId) then
  begin
    // обновляем расчеты
    FDraftView.Entity.ReloadLocate(NewId);

    // отменяем изменения, возможно, сделанные в параметрах заказа
    FWorkView.Entity.CancelUpdates;

    if not DraftParamsProvider.CopyToDraft then
    begin    // Если изменение статуса без копирования
      FWorkView.Entity.Reload;
      //NotifyModification;
    end;
    pcCalcOrder.ActivePageIndex := FViews.IndexOf(FDraftView);;     // Переключаем на расчеты
    pcCalcOrderChange(nil);
  end
  else
    // отменяем изменения, возможно, сделанные в параметрах расчета
    FWorkView.Entity.CancelUpdates;
end;

{procedure TMForm.EditOrderInvoice(Sender: TObject);
var
  InvoiceID, InvoiceItemID: integer;
begin
  if (FCurrentView is TWorkView) and not FCurrentView.Entity.IsEmpty then
  begin
    if not VarIsNull((FCurrentView as TWorkView).InvoiceID)
      and not VarIsNull((FCurrentView as TWorkView).InvoiceItemID) then
    begin
      InvoiceID := (FCurrentView as TWorkView).InvoiceID;
      InvoiceItemID := (FCurrentView as TWorkView).InvoiceItemID;
      if OpenInvoices then
      begin
        if FCurrentView is TInvoiceView then
          (FCurrentView as TInvoiceView).EditInvoice(InvoiceID, InvoiceItemID);
      end;
    end;
  end
  else
  if (FCurrentView is TCustomerPaymentsView) then
  begin
    InvoiceItemID := NvlInteger((FCurrentView as TCustomerPaymentsView).OrderInvoiceItems.KeyValue);
    InvoiceID := NvlInteger((FCurrentView as TCustomerPaymentsView).OrderInvoiceItems.InvoiceID);
    if (InvoiceItemID <> 0) then
    begin
      if OpenInvoices then
      begin
        if FCurrentView is TInvoiceView then
          (FCurrentView as TInvoiceView).EditInvoice(InvoiceID, InvoiceItemID);
      end;
    end;
  end;

end;}

procedure TMForm.acShowAllExecute(Sender: TObject);
begin
  //if MFFilter.FilterEnabled then DisableFilter;
end;

procedure TMForm.btDecomposeClick(Sender: TObject);
begin
{  if dm.WorkOrderData.Active and not dm.WorkOrderData.IsEmpty then begin
    AllNotifIgnore := true;
    try
      DecomposeOrder;
    finally
      AllNotifIgnore := false;
    end;
  end;}
end;

procedure TMForm.DependsAction(Show: boolean);
{var
  ReOrderID: integer;
  ReOrderCode: string;
  ReKind: TChangeKind;
  cdOrd: TDataSet;}
begin
{  cdOrd := FCurrentView.Entity.DataSet;
  if AccessManager.CurUser.WorkVisible and (FCurrentView.Entity is TWorkOrder)
    and cdOrd.Active and not cdOrd.IsEmpty then
  ReOrderID := FCurrentView.Entity.KeyValue;
  ReOrderCode := cdOrd['ID'];
  if Show then
    ReKind := chInfo
  else
    ReKind := chSumChanged;
  CheckDependsAndShowForm(ReOrderID, ReOrderCode, ReKind, Database.Connection);}
end;

procedure TMForm.acShowDependsExecute(Sender: TObject);
begin
  DependsAction(true);
end;

procedure TMForm.acUpdateDependsExecute(Sender: TObject);
begin
  DependsAction(false);
end;

procedure TMForm.acExpenseExecute(Sender: TObject);
begin
{$IFNDEF NoExpenses}
  ExecExpenseForm;
{$ENDIF}
end;

procedure TMForm.panLeftResize(Sender: TObject);
begin
{  if ViewMode = vmLeft then begin
    if (panLeft.Width < OrdersWidthNormal) and btPanLeft.Visible then begin
      btPanLeft.Visible := false;
      btPanRight.Visible := true;
    end;
    if (panLeft.Width > OrdersWidthWide) and btPanRight.Visible then begin
      btPanLeft.Visible := true;
      btPanRight.Visible := false;
    end;
    if (panLeft.Width > (DefOrdersWidthNormal + DefOrdersWidthWide) div 2) or
       (OrdersWidthWide <= panLeft.Width) then
       OrdersWidthWide := panLeft.Width
    else
      OrdersWidthNormal := panLeft.Width;
  end;}
end;

procedure TMForm.pmPayAccClick(Sender: TObject);
{var
  s: string;
  acc: integer;}
begin
{  s := deAccounts.ItemName[(Sender as TMenuItem).Tag];
  try
    if Pos('Нал', s) <> 0 then begin
      dm.cdOrderPayDet.Edit;
      dm.cdOrderPayDet['PayKind'] := 1;
      dm.cdOrderPayDet.Edit;
      dm.cdOrderPayDet['PayAccount'] := null;
    end else begin
      dm.cdOrderPayDet.Edit;
      dm.cdOrderPayDet['PayKind'] := 2;
      acc := round(deAccounts.ItemFloat[(Sender as TMenuItem).Tag, 1]);
      dm.cdOrderPayDet.Edit;
      if acc = 0 then dm.cdOrderPayDet['PayAccount'] := null
      else dm.cdOrderPayDet['PayAccount'] := acc;
    end;
  except end;}
end;

procedure TMForm.acDicsExecute(Sender: TObject);
{$IFDEF NoFinance}
var ps: string;
{$ENDIF}
begin
  //OrderBeforeScroll;
  //AllNotifIgnore := true;
  //CalcTimer.Enabled := false;
  //try
    {$IFDEF NoFinance}
    try
      ps := InputBox('Идентификация пользователя', 'Пароль', '');
      if (Length(ps) = 0) or (Q_StrToCodes(ps) <> DicPsw) then Exit;
    except Exit; end;
    {$ENDIF}
      // true если все успешно (ок и отмена не играют роли)
      if ExecDicEditForm(InsideOrder, TSettingsManager.Instance.Storage) then
      begin
        if not InsideOrder then
        begin
          //BeforeDeleteServices;    // создаются заново странички
          SetupServices;
        end;
       {$IFNDEF NoNet}
        if SendPrices then SendNotif(PricesNotif); // Посылаем всем сообщение, что надо перечитать цены
       {$ENDIF}
      end;
  //finally
  //  AllNotifIgnore := false;
  //  CalcTimer.Enabled := Options.AutoOpen;
  //end;
end;

procedure TMForm.acToolbarCustExecute(Sender: TObject);
begin
  //Toolbar.Customize(0);
end;

procedure TMForm.FormDestroy(Sender: TObject);
begin
  //FreeOrderInvPayFrame;
  DoneColorItems;
  // могла уже сработать финализация поэтому проверяем
  if TSettingsManager.Instance.SettingsChanged <> nil then
    TSettingsManager.Instance.SettingsChanged.UnregisterHandler(SettingsChangedHandlerID);
end;

procedure TMForm.acCheckRepExecute(Sender: TObject);
begin
  if FCurrentController is TOrderController then
    (FCurrentController as TOrderController).CheckOrder(false);
end;

procedure TMForm.SetCurrentData(dq: TDataSet);
var
  View: TEntityController;
  I: Integer;
begin
  for I := 0 to FViews.Count - 1 do
    if dq = TEntityController(FViews[I]).Entity.DataSet then
    begin
      pcCalcOrder.ActivePageIndex := I;
      pcCalcOrderChange(nil);
      break;
    end;

  {if dq = dm.CalcOrderData then
  begin
    View := FindView(TDraftView);
    if View <> nil then
      pcCalcOrder.ActivePageIndex := FViews.IndexOf(View);
  end
  else
  begin
    View := FindView(TWorkView);
    if View <> nil then
      pcCalcOrder.ActivePageIndex := FViews.IndexOf(View);
  end;
  pcCalcOrderChange(nil);}
end;

procedure TMForm.miOrderReportClick(Sender: TObject);
var
  ReportKey: integer;
begin
  //AllNotifIgnore := true;
  if (Sender = nil) then
  begin
    if (CurrentController is TOrderController) then
      (CurrentController as TOrderController).PrintDefaultOrderReport;
  end
  else
  begin
    ReportKey := (Sender as TMenuItem).Tag;
    // Пункты меню отчетов, запрещенных к запуску внутри заказа,
    // остаются активными в режиме автооткрытия заказов, поэтому проверочка
    if ReportKey > InsideTag then
      CurrentController.PrintReport(ReportKey - InsideTag, true) // Значит, разрешено запускать в режиме редактирования
    else
      CurrentController.PrintReport(ReportKey, false);
  end;
end;

procedure TMForm.OpenCustomReportView(ReportData: TReportData; ReportID: integer; SourceView: TEntityController);
var
  //_Process: TPolyProcess;
  k: integer;
  ts: TTabSheet;
  View: TReportController;
  EquipGroupCode: integer;
begin
  // ищем, не открыт ли уже этот отчет и закрываем его
  if FViews <> nil then
  begin
    for k := 0 to FViews.Count - 1 do
      if (TObject(FViews[k]) is TReportController) and (TReportController(FViews[k]).ReportID = ReportID) then
      begin
        ts := TReportController(FViews[k]).Frame.Parent as TTabSheet;
        pcCalcOrder.ActivePage := ts;
        // Вызываем событие изменения текущей страницы
        pcCalcOrderChange(pcCalcOrder);
        CloseCurrentView;
      end;
    // Открываем новую
    View := CreateController(ReportData) as TReportController;
    if View <> nil then  // может не быть прав(?)
    begin
      View.ReportID := ReportID;
      View.SourceFilterPhrase := SourceView.GetFilterPhrase;
      View.LoadSettings;
      ts := View.Frame.Parent as TTabSheet;
      pcCalcOrder.ActivePage := ts;
    end;
    // Вызываем событие изменения текущей страницы
    pcCalcOrderChange(pcCalcOrder);
  end;
end;

procedure TMForm.acAllMaterialsExecute(Sender: TObject);
begin
  OpenStock;
end;

procedure TMForm.miCustomReportClick(Sender: TObject);
var
  t: integer;
  ReportData: TReportData;
begin
  if CurrentController is TOrderController then
  begin
    t := - (Sender as TMenuItem).Tag; // там отрицательные значения тэгов
    ReportData := (CurrentController as TOrderController).BuildCustomReport(t);
    if ReportData <> nil then
      OpenCustomReportView(ReportData, t, CurrentController);
  end;
end;

// Расставляет Enabled для пунктов меню, в зав-сти от того, раб. ли он при откр. заказе
procedure TMForm.UpdateRepMenuEnabled;

  procedure DoUpdate(miItems: TMenuItem);
  var
    i: integer;
    mi: TMenuItem;
  begin
    for i := 0 to Pred(miItems.Count) do
    begin
      mi := miItems.Items[i];
      if mi.Tag > 0 then
      begin
        if mi.Tag > InsideTag then
          // означает, что скрипт может работать при открытом заказе
          mi.Enabled := true
        else
          mi.Enabled := Options.AutoOpen or not InsideOrder;
      end
      else // Custom report
        mi.Enabled := Options.AutoOpen or not InsideOrder;
    end;
  end;

begin
  miReports.Enabled := AccessManager.CurUser.ViewReports;
  if miReports.Enabled then
  begin
    DoUpdate(miReports);
    DoUpdate(pmReports.Items);
    acPrint.Enabled := (TSettingsManager.Instance.DefaultReportID <> -1) and
      (TSettingsManager.Instance.DefaultAllowInside and InsideOrder) or  // TODO: кажись бред
       not InsideOrder;
  end;
end;

// Заполнение меню отчетов отчетами
procedure TMForm.UpdateReportsMenu;

  function CreateMenuItem: TMenuItem;
  var
    mi: TMenuItem;
  begin
    mi := TMenuItem.Create(Self);
    mi.Caption := NvlString(rdm.cdReports['ScriptDesc']);
    mi.Tag := rdm.cdReports['ScriptID'];
    if not VarIsNull(rdm.cdReports['ShortCut']) then
      mi.ShortCut := rdm.cdReports['ShortCut'];
    if rdm.cdReports['WorkInsideOrder'] then mi.Tag := mi.Tag + InsideTag;
    mi.OnClick := miOrderReportClick;
    mi.ImageIndex := 5;
    Result := mi;
  end;

var
  mi: TMenuItem;
begin
  // Сначала удаляем то, что было...
  // ПОКА УБРАЛ : сохраняем подменю пользовательских отчетов, временно удаляя его
  //if miCustomReportsMainMenu <> nil then
  //  pmReports.Items.Remove(pmReports.Items.IndexOf(miCustomReportsMainMenu));
  //if miCustomReportsToolbar <> nil then
  //  miReports.Remove(miReports.IndexOf(miCustomReportsToolbar));
  miCustomReportsToolbar := nil;
  miCustomReportsMainMenu := nil;
  miReports.Clear;
  pmReports.Items.Clear;
  // Вставляем отчеты, описанные сценариями
  rdm.OpenReports;
  rdm.cdReports.First;
  TSettingsManager.Instance.DefaultReportID := -1;
  while not rdm.cdReports.eof do
  try
    // пропускаем модули.
    if not VarIsNull(rdm.cdReports['IsUnit']) and not rdm.cdReports['IsUnit'] then
    begin
      mi := CreateMenuItem;
      if XPMenuPainter.Active then XPMenuPainter.ActivateMenuItem(mi, true);
      miReports.Add(mi);
      mi := CreateMenuItem;
      if XPMenuPainter.Active then XPMenuPainter.ActivateMenuItem(mi, true);
      pmReports.Items.Add(mi);
      if not rdm.cdReports.FieldByName('IsDefault').IsNull then
        if rdm.cdReports['IsDefault'] then
        begin
          TSettingsManager.Instance.DefaultReportID := rdm.cdReports['ScriptID'];
          TSettingsManager.Instance.DefaultAllowInside := not VarIsNull(rdm.cdReports['WorkInsideOrder']) and rdm.cdReports['WorkInsideOrder'];
        end;
    end;
  finally
    rdm.cdReports.Next;
  end;
  UpdateRepMenuEnabled;
  // Вставляем подменю пользовательских отчетов
  UpdateCustomReportsMenu;
end;

procedure TMForm.UpdateCustomReportsMenu;

  function CreateMenuItem: TMenuItem;
  var
    mi: TMenuItem;
  begin
    mi := TMenuItem.Create(Self);
    mi.Caption := CustomReports.DataSet['ReportName'];
    // отрицательные значения тэгов!
    mi.Tag := - CustomReports.DataSet['ReportID'];
    mi.OnClick := miCustomReportClick;
    mi.ImageIndex := 5;
    Result := mi;
  end;

var
  mi: TMenuItem;
begin
  if miCustomReportsMainMenu = nil then
  begin
    miCustomReportsMainMenu := TMenuItem.Create(Self);
    miCustomReportsMainMenu.Caption := 'Другие отчеты';
    miReports.Add(miCustomReportsMainMenu);
    if XPMenuPainter.Active then XPMenuPainter.ActivateMenuItem(miCustomReportsMainMenu, true);
  end else
    miCustomReportsMainMenu.Clear;

  if miCustomReportsToolbar = nil then
  begin
    miCustomReportsToolbar := TMenuItem.Create(Self);
    miCustomReportsToolbar.Caption := 'Другие отчеты';
    pmReports.Items.Add(miCustomReportsToolbar);
    if XPMenuPainter.Active then XPMenuPainter.ActivateMenuItem(miCustomReportsToolbar, true);
  end else
    miCustomReportsToolbar.Clear;

  CustomReports.Open;
  CustomReports.DataSet.First;
  while not CustomReports.DataSet.Eof do
  begin
    mi := CreateMenuItem;
    if XPMenuPainter.Active then XPMenuPainter.ActivateMenuItem(mi, true);
    miCustomReportsMainMenu.Add(mi);

    mi := CreateMenuItem;
    if XPMenuPainter.Active then XPMenuPainter.ActivateMenuItem(mi, true);
    miCustomReportsToolbar.Add(mi);

    CustomReports.DataSet.Next;
  end;
end;

procedure TMForm.UpdatePlanMenu;
var
  mi: TMenuItem;
  ds: TDataSet;
  de: TDictionary;
begin
  miPlan.Clear;
  // Проверяем права доступа
  if AccessManager.CurUser.PermitPlanView or AccessManager.CurUser.ViewProduction then
  begin
    // Выбираем группы оборудования
    de := TConfigManager.Instance.StandardDics.deEquipGroup;
    ds := de.DicItems;
    ds.First;
    while not ds.eof do
    begin
      if AccessManager.CurUser.PermitPlanView then
      begin
        // План
        mi := TMenuItem.Create(Self);
        mi.Caption := de.CurrentName;
        mi.Tag := de.CurrentCode;
        mi.OnClick := miProcessPlanClick;
        if XPMenuPainter.Active then XPMenuPainter.ActivateMenuItem(mi, true);
        miPlan.Add(mi);
      end;

      if AccessManager.CurUser.ViewProduction then
      begin
        // В работе
        mi := TMenuItem.Create(Self);
        mi.Caption := de.CurrentName;
        mi.Tag := de.CurrentCode;
        mi.OnClick := miProcessProductionClick;
        if XPMenuPainter.Active then XPMenuPainter.ActivateMenuItem(mi, true);
        miInWork.Add(mi);
      end;

      ds.Next;
    end;
  end;
end;

procedure TMForm.miProcessPlanClick(Sender: TObject);
var
  //_Process: TPolyProcess;
  k: integer;
  ts: TTabSheet;
  E: TPlan;
  View: TPlanController;
  EquipGroupCode: integer;
  Found: boolean;
begin
  //_Process := sm.ServiceByID((Sender as TMenuItem).Tag, false);
  EquipGroupCode := (Sender as TMenuItem).Tag;
  // ищем не открыт ли уже этот план
  if FViews <> nil then
  begin
    Found := false;
    for k := 0 to FViews.Count - 1 do
      if (TObject(FViews[k]) is TPlanController) and ((TPlanController(FViews[k]).Entity as TPlan).EquipGroupCode = EquipGroupCode) then
      begin
        ts := TPlanController(FViews[k]).PlanFrame.Parent as TTabSheet;
        pcCalcOrder.ActivePage := ts;
        Found := true;
      end;
    if not Found then
    begin
      // Если не открыт, открываем
      E := AppController.CreatePlan(EquipGroupCode);
      View := CreateController(E) as TPlanController;
      if View <> nil then  // может не быть прав(?)
      begin
        View.LoadSettings;
        ts := View.PlanFrame.Parent as TTabSheet;
        pcCalcOrder.ActivePage := ts;
      end;
    end;
    // Вызываем событие изменения текущей страницы
    pcCalcOrderChange(pcCalcOrder);
  end;
end;

procedure TMForm.miProcessProductionClick(Sender: TObject);
{$IFNDEF NoProduction}
var
  EquipGroupCode: integer;
  k: integer;
  ts: TTabSheet;
  E: TEntity;
  View: TProductionController;
  Found: boolean;
begin
  EquipGroupCode := (Sender as TMenuItem).Tag;
  // ищем не открыт ли уже этот вид
  if FViews <> nil then
  begin
    Found := false;
    for k := 0 to FViews.Count - 1 do
      if (TObject(FViews[k]) is TProductionController)
        and ((TProductionController(FViews[k]).Entity as TProduction).EquipGroupCode = EquipGroupCode) then
      begin
        ts := TProductionController(FViews[k]).ProdFrame.Parent as TTabSheet;
        pcCalcOrder.ActivePage := ts;
        Found := true;
      end;
    if not Found then
    begin
      // Если не открыт, открываем
      E := AppController.CreateProduction(EquipGroupCode);
      View := CreateController(E) as TProductionController;
      if View <> nil then  // может не быть прав(?)
      begin
        View.LoadSettings;
        ts := View.ProdFrame.Parent as TTabSheet;
        pcCalcOrder.ActivePage := ts;
      end;
    end;
    // Вызываем событие изменения текущей страницы
    pcCalcOrderChange(pcCalcOrder);
  end;
end;
{$ELSE}
begin
end;
{$ENDIF}

procedure TMForm.acStockMoveExecute(Sender: TObject);
begin
  OpenStockMove;
end;

procedure TMForm.acEditConfigExecute(Sender: TObject);
var
  E: TConfigTreeEntity;
  k: integer;
  ts: TTabSheet;
  View: TEntityController;
  Found: boolean;
begin
  // ищем не открыт ли уже этот вид
  if FViews <> nil then
  begin
    Found := false;
    for k := 0 to FViews.Count - 1 do
      if (TObject(FViews[k]) is TConfigView) then
      begin
        ts := TConfigView(FViews[k]).Frame.Parent as TTabSheet;
        pcCalcOrder.ActivePage := ts;
        Found := true;
      end;
    if not Found then
    begin
      // Если не открыт, открываем
      E := AppController.CreateConfigTree;
      View := CreateController(E);
      if View <> nil then  // может не быть прав(?)
      begin
        View.LoadSettings;
        ts := View.Frame.Parent as TTabSheet;
        pcCalcOrder.ActivePage := ts;
      end;
    end;
    // Вызываем событие изменения текущей страницы
    pcCalcOrderChange(pcCalcOrder);
  end;
end;

(*procedure TMForm.CalcTimerTimer(Sender: TObject);  // Таймер для открытия расчета-заказа
begin                                             // с задержкой
  if not Options.AutoOpen then
  begin
    CalcTimer.Enabled := false;
    Exit;
  end;
  {$IFNDEF NoDocs}
  if InDocs then Exit;
  {$ENDIF}
  if not FCurrentView.Entity.DataSet.Active or not Database.Connected
    or InsideOrder then Exit;
  Inc(OrdWaitRefresh);
  if OrdWaitRefresh >= 30 then
  begin
    CalcTimer.Enabled := false;
    OrdWaitRefresh := 0;
    EditCurrent;
    CalcTimer.Enabled := true;
  end;
end;*)

procedure TMForm.pcCalcOrderChanging(Sender: TObject; var AllowChange: Boolean);
begin
  if (FViews <> nil) and (FViews.Count > 0) then
  begin
    CurrentController.Deactivate(AllowChange);
  end;
end;

procedure TMForm.acGScriptsExecute(Sender: TObject);
begin
  if ExecReportsForm = mrOk then UpdateReportsMenu;
end;

procedure TMForm.acUEExecute(Sender: TObject);
var
  SrvCourse, OrdCourse: extended;
  r: integer;
begin
  SrvCourse := GetLastCourse;
  if InsideOrder then
    OrdCourse := (FCurrentController as TOrderController).Order.Processes.USDCourse
  else
    OrdCourse := -1;
  r := ExecUEForm(SrvCourse, TSettingsManager.Instance.AppCourse, OrdCourse,
    AccessManager.CurUser.SetCourse);
  if r = mrOk then SetCourse(TSettingsManager.Instance.AppCourse);
  if (r = mrOk) and InsideOrder then
    SetCourse(OrdCourse);
  if (r = mrYes) and (RusMessageDlg('Курс на сервере будет установлен в ' +
    FloatToStrF(TSettingsManager.Instance.AppCourse, ffFixed, 5, 2) + ' грн. Вы уверены?', mtConfirmation, [mbYes, mbNo], 0) = mrYes)
    and dm.SetSrvCourse(TSettingsManager.Instance.AppCourse) then begin
      SetCourse(GetLastCourse);
     {$IFNDEF NoNet}
      if SendCourse then SendNotif(CourseNotif);
     {$ENDIF}
    end;
end;

procedure TMForm.UpdateRecordCount;
var n: integer;
begin
  n := FCurrentController.Entity.TotalRecordCount;
  if n <= 0 then lbRecCount.Caption := 'Нет записей'
  else lbRecCount.Caption := 'Записей: ' + IntToStr(n);
end;

procedure TMForm.UpdateCaption;
begin
  pcCalcOrder.ActivePage.Caption := FCurrentController.Caption;
end;

{procedure TMForm.FilterChange;
begin
  //OrderBeforeScroll;
  AppController.UpdateOrderFilter;
end;}

(*procedure TMForm.DisableFilter;
begin
  //AllNotifIgnore := true;
  //try
    MFFilter.DisableFilter;
    if FDraftView <> nil then FDraftView.Order.Reload;
    if FWorkView <> nil then FWorkView.Order.Reload;
    FilterFrame.UpdateFilterControls;
  {finally
    AllNotifIgnore := false;
  end;}
end;*)

{function TMForm.GetAppStorage: TJvCustomAppStorage;
begin
  Result := TSettingsManager.Instance.Storage;
end;}

procedure TMForm.MainFormStorageSavePlacement(Sender: TObject);
begin
  //FreeProcessPageList;
end;

procedure TMForm.InvoicesAfterScroll(Sender: TObject);
var
  En: boolean;
begin
  if FCurrentController is TInvoiceController then
  begin
    En := not FCurrentController.Entity.IsEmpty;
    acDelOrder.Enabled := En;
    acPrint.Enabled := En;
  end;
end;

procedure TMForm.MessageTimerTimer(Sender: TObject);
var
  Msgs: TStringList;
  I: integer;
begin
  {MessageTimer.Enabled := false;
  try
    Msgs := Messenger.GetMessages;
    if (Msgs <> nil) and (Msgs.Count > 0) then
    begin
      //TLogger.getInstance.Debug('Timer Check ' + IntToStr(Msgs.Count));
      for I := 0 to Msgs.Count - 1 do
        TMessageDialog.ShowMessage(Msgs[I]);
    end else
      //TLogger.getInstance.Debug('Timer Check null');
    Msgs.Free;
  finally
    MessageTimer.Enabled := true;
  end;}
end;

procedure TMForm.acCloseViewExecute(Sender: TObject);
begin
  CloseCurrentView;
end;

procedure TMForm.acContractorsExecute(Sender: TObject);
begin
  ExecContragentSelect(Contractors, 0, {SelectMode=} false);
end;

procedure TMForm.acSuppliersExecute(Sender: TObject);
var
  CurCustomer: integer;
begin
  if FCurrentController <> nil then
  begin
    if (FCurrentController.Entity <> nil) and not FCurrentController.Entity.IsEmpty then
    begin
      try
        if FCurrentController is TMaterialRequestController then
          CurCustomer := (FCurrentController as TMaterialRequestController).MatRequests.SupplierID
        else
          CurCustomer := TContragents.NoNameKey;
      except
        CurCustomer := TContragents.NoNameKey;
      end;
    end;
  end
  else
    CurCustomer := TContragents.NoNameKey;
  ExecContragentSelect(Suppliers, CurCustomer, {SelectMode=} false);
end;

procedure TMForm.acShowFilterExecute(Sender: TObject);
begin
  //if (CurrentView is TOrderView) then
    Options.ShowFilterPanel := not Options.ShowFilterPanel;

  ShowFilterChanged;
end;

procedure TMForm.ShowFilterChanged;
begin
  // TODO: перенсти в TOrderViewFrame
  //if (CurrentView is TOrderView) then
  //begin
    //if not InsideOrder then
    //  paQuery.Visible := Options.ShowFilterPanel;
  //end
  //else
  //  CurrentView.ShowFilterPanel := not CurrentView.Frame.ShowFilterPanel;
end;

procedure TMForm.acDisplayInfoExecute(Sender: TObject);
begin
  if ExecCommonInfoEditor(DisplayInfo) then
    DisplayInfo.ApplyUpdates;
end;

procedure TMForm.acCustomReportsExecute(Sender: TObject);
begin
  // обновить перед редактированием
  CustomReports.Close;
  CustomReports.Open;
  if ExecCustomReportEditor(CustomReports, CurrentOrderView.Order) then
    CustomReports.ApplyUpdates
  else
    CustomReports.CancelUpdates;
  UpdateCustomReportsMenu;
end;

procedure TMForm.acTestExecute(Sender: TObject);
begin
{$IFDEF Test}
  GUITestRunner.RunRegisteredTests;
{$ENDIF}
end;

procedure TMForm.acEntSettingsExecute(Sender: TObject);
begin
  if EditEnterpriseSettings then
    EntSettings.ApplyUpdates;
end;

procedure TMForm.HideFilter(Sender: TObject);
begin
  acShowFilter.Checked := false;
  acShowFilterExecute(Sender);
end;

procedure TMForm.acUpdateCfgExecute(Sender: TObject);
begin
  CfgUpdater.Execute;
end;

procedure TMForm.acWideListExecute(Sender: TObject);
begin
  Options.WideOrderList := not Options.WideOrderList;
  //WideOrderListChanged;
end;

procedure TMForm.SetCurrentView(const Value: TEntityController);
var
  View: TEntityController;
  I: Integer;
begin
  for I := 0 to FViews.Count - 1 do
    if Value = FViews[I] then
    begin
      pcCalcOrder.ActivePageIndex := I;
      pcCalcOrderChange(nil);
      break;
    end;
end;

(*procedure TMForm.WideOrderListChanged;
begin
  if not InsideOrder then
  begin
    if Options.WideOrderList then
    begin
      panRight.Align := alBottom;
      //panLeft.Align := alClient;
    end
    else
    begin
      //panLeft.Align := alClient;
      panRight.Align := alRight;
    end;
  end;
end;*)

function TMForm.GetLastCourse: extended;  // Получение курса с сервера
begin
  CourseNotifIgnore := true;
  try
    Result := dm.GetLastCourse;
  except
    on E: Exception do
    begin
      ExceptionHandler.Raise_(E, 'Не могу получить с сервера значение курса расчетной единицы',
        'GetLastCourse');
      Result := 0;
    end;
  end;
  CourseNotifIgnore := false;
end;

function TMForm.GetCurrentData: TDataSet;
begin
  if FCurrentController = nil then
    Result := nil
  else
    Result := FCurrentController.Entity.DataSet;
end;

procedure TMForm.SaveViewSettings;
var i: integer;
begin
  for i := 0 to FViews.Count - 1 do
    TEntityController(FViews[i]).SaveSettings;
end;

procedure TMForm.LoadViewSettings;
var i: integer;
begin
  for i := 0 to FViews.Count - 1 do
    TEntityController(FViews[i]).LoadSettings;
end;

procedure TMForm.acOrderRecycleBinExecute(Sender: TObject);
begin
  OpenRecycleBin(BinObjectType_Orders);
end;

procedure TMForm.acContragentRecycleBinExecute(Sender: TObject);
begin
  OpenRecycleBin(BinObjectType_Contragents);
end;

procedure TMForm.OpenRecycleBin(ObjectType: integer);
var
  k: integer;
  ts: TTabSheet;
  E: TEntity;
  View: TBaseRecycleBinView;
  Found: boolean;
begin
  // ищем не открыта ли уже корзина
  if FViews <> nil then
  begin
    Found := false;
    for k := 0 to FViews.Count - 1 do
      if (TObject(FViews[k]) is TBaseRecycleBinView) and (TBaseRecycleBinView(TObject(FViews[k])).RecycleBin.ObjectType = ObjectType) then
      begin
        ts := TBaseRecycleBinView(FViews[k]).Frame.Parent as TTabSheet;
        pcCalcOrder.ActivePage := ts;
        // Вызываем событие изменения текущей страницы
        pcCalcOrderChange(pcCalcOrder);
        Found := true;
      end;
    if not Found then
    begin
      // Если не открыта, открываем
      E := AppController.CreateRecycleBin(ObjectType);
      View := CreateController(E) as TBaseRecycleBinView;
      if View <> nil then  // может не быть прав(?)
      begin
        View.AfterRefresh := View_AfterRefresh;
        View.LoadSettings;
        ts := View.Frame.Parent as TTabSheet;
        pcCalcOrder.ActivePage := ts;
      end;
    end;
    // Вызываем событие изменения текущей страницы
    pcCalcOrderChange(pcCalcOrder);
  end;
end;

// создает автоматически закрывающийся редактор заказа
function TMForm.OpenWorkOrderView: TWorkController;
var
  Order: TWorkOrder;
begin
  Order := AppController.CreateWorkOrder;
  Result := OpenOrderView(Order) as TWorkController;
  Result.AutoClose := true;
  // Вызываем событие изменения текущей страницы
  pcCalcOrderChange(pcCalcOrder);
end;

function TMForm.OpenOrderView(Order: TOrder): TOrderController;
var
  ts: TTabSheet;
  View: TOrderController;
begin
  // Если не открыта, открываем
  View := CreateController(Order) as TOrderController;
  if View <> nil then  // может не быть прав(?)
  begin
    View.AfterRefresh := View_AfterRefresh;
    View.LoadSettings;
    ts := View.Frame.Parent as TTabSheet;
    pcCalcOrder.ActivePage := ts;
  end;
  Result := View;
end;

procedure TMForm.ShowWorkOrderView;
var
  k: integer;
  ts: TTabSheet;
  E: TEntity;
  View: TWorkController;
  Found: boolean;
begin
  // ищем закладку
  if FViews <> nil then
  begin
    Found := false;
    for k := 0 to FViews.Count - 1 do
      if (TObject(FViews[k]) is TWorkController) then
      begin
        ts := TWorkController(FViews[k]).Frame.Parent as TTabSheet;
        pcCalcOrder.ActivePage := ts;
        // Вызываем событие изменения текущей страницы
        pcCalcOrderChange(pcCalcOrder);
        Found := true;
      end;
    if not Found then
    begin
      OpenWorkOrderView;
    end;
  end;
end;

procedure TMForm.acGlobalHistoryExecute(Sender: TObject);
begin
  AppController.ViewGlobalHistory;
end;

procedure TMForm.View_AfterRefresh(Sender: TObject);
begin
  UpdateRecordCount;
  UpdateCaption;
end;

(*
// ЭТО ХАК! Исправляет необъяснимое поведение контролов после переключения на корзину
// и обратно, и изменение размеров окна. Не проверял в Delphi 2007
procedure TMForm.tsCalcResize(Sender: TObject);
begin
    if (dgCalcOrder <> nil) and (pcCalcOrder.Width > tsCalc.Width + 8) then
      tsCalc.Width := pcCalcOrder.Width - 8;
end;

// ЭТО ХАК! Исправляет необъяснимое поведение контролов после переключения на корзину
// и обратно, и изменение размеров окна. Не проверял в Delphi 2007
procedure TMForm.tsWorkResize(Sender: TObject);
begin
    if (dgWorkOrder <> nil) and (pcCalcOrder.Width > tsWork.Width + 8) then
      tsWork.Width := pcCalcOrder.Width - 8;
end;
*)

function TMForm.CurrentOrderView: TOrderController;
begin
  if CurrentController is TOrderController then
    Result := CurrentController as TOrderController
  else
    Result := FindController(TWorkController) as TOrderController
end;

(*procedure TMForm.acMakeInvoiceExecute(Sender: TObject);
var
  CustomerID, OrderID: integer;
begin
  if (CurrentView is TWorkView) and not CurrentView.Entity.IsEmpty then
  begin
    (CurrentView as TWorkView).MakeInvoice(nil);
    {CustomerID := (FCurrentView as TOrderView).Order.CustomerID;
    OrderID := (FCurrentView as TOrderView).Order.KeyValue;
    if OpenInvoices then
    begin
      if FCurrentView is TInvoiceView then
        (FCurrentView as TInvoiceView).MakeInvoice(CustomerID, OrderID);
    end;}
  end;
end;*)

// Оплачиваем текущую счет-фактуру
procedure TMForm.acPayInvoiceExecute(Sender: TObject);
var
  InvoiceItemID, InvoiceID: variant;
  //PView: TCustomerPaymentsView;
  CurrentCustomerID: integer;
  WView: TWorkController;
  InvView: TInvoiceController;
begin
  if (CurrentController is TWorkController) then
  begin
    // Оплачивается ЗАКАЗ
    WView := CurrentController as TWorkController;
    InvoiceItemID := WView.InvoiceItemID;
    if NvlInteger(InvoiceItemID) <> 0 then
    begin
      CurrentCustomerID := WView.Order.CustomerID;
      // открываем страничку оплат
      //OpenCustomerPayments;
      //PView := CurrentView as TCustomerPaymentsView;
      // нужен именно заказчик, а не плательщик, иначе не найдет заказ
      TCustomerPaymentsController.PayInvoiceItem(InvoiceItemID, CurrentCustomerID);
      WView.OrderInvoiceItems.Reload;
      WView.OrderPayments.Reload;
    end;
  end
  else if (CurrentController is TInvoiceController) then
  begin
    // Оплачивается СЧЕТ
    InvView := CurrentController as TInvoiceController;
    InvoiceID := InvView.Invoices.KeyValue;
    if NvlInteger(InvoiceID) <> 0 then
    begin
      //CurrentCustomerID := (CurrentView as TInvoiceView).OrderCustomerID;
      // открываем страничку оплат
      //OpenCustomerPayments;
      //PView := CurrentView as TCustomerPaymentsView;
      // нужен именно заказчик, а не плательщик, иначе не найдет заказ
      TCustomerPaymentsController.PayInvoice(InvoiceID);
      InvView.Invoices.Reload;
    end;
  end;
end;

// Меняем строчку оплаты текущей счет-фактуры
procedure TMForm.acEditPayInvoiceExecute(Sender: TObject);
var
  PayItemID: variant;
  //PView: TCustomerPaymentsView;
    WView: TWorkController;
  InvView: TInvoiceController;
begin
{
  if (CurrentController is TWorkController) then
  begin
    // Оплачивается ЗАКАЗ
    WView := CurrentController as TWorkController;
    InvoiceItemID := WView.InvoiceItemID;
    if NvlInteger(InvoiceItemID) <> 0 then
    begin
      CurrentCustomerID := WView.Order.CustomerID;
      // открываем страничку оплат
      //OpenCustomerPayments;
      //PView := CurrentView as TCustomerPaymentsView;
      // нужен именно заказчик, а не плательщик, иначе не найдет заказ
      TCustomerPaymentsController.PayInvoiceItem(InvoiceItemID, CurrentCustomerID);
      WView.OrderInvoiceItems.Reload;
      WView.OrderPayments.Reload;
    end;
  end
  else if (CurrentController is TInvoiceController) then
  begin
    // Оплачивается СЧЕТ
    InvView := CurrentController as TInvoiceController;
    InvoiceID := InvView.Invoices.KeyValue;
    if NvlInteger(InvoiceID) <> 0 then
    begin
      //CurrentCustomerID := (CurrentView as TInvoiceView).OrderCustomerID;
      // открываем страничку оплат
      //OpenCustomerPayments;
      //PView := CurrentView as TCustomerPaymentsView;
      // нужен именно заказчик, а не плательщик, иначе не найдет заказ
      TCustomerPaymentsController.PayInvoice(InvoiceID);
      InvView.Invoices.Reload;
    end;
  end;
  }
end;


procedure TMForm.CloseCurrentView;
var
  CView: TEntityController;
  i: integer;
  CanClose: boolean;
begin
  if (CurrentController <> nil) then
  begin
    CanClose := true;
    try
      CanClose := CurrentController.CanClose;
    except on E: Exception do
      ViewCloseError(E);
    end;
    if CanClose then
    begin
      CView := CurrentController;
      CView.SaveSettings;
      i := FViews.IndexOf(CView);
      FViews.Remove(CView);
      CView.Free;
      pcCalcOrder.Pages[i].Free;
      pcCalcOrderChange(pcCalcOrder);
    end;
  end;
end;

procedure TMForm.ViewCloseError(E: Exception);
begin
  RusMessageDlg('Ошибка при закрытии вкладки. Возможно, изменения не сохранены. ' + E.Message, mtError, [mbOk], 0);
end;

procedure TMForm.acShowShipmentExecute(Sender: TObject);
begin
  OpenShipment;
end;

function TMForm.OpenEntityView(Entity: TEntity): boolean;
var
  k: integer;
  ts: TTabSheet;
  View: TEntityController;
  VC: TEntityControllerClass;
  _Frame: TFrame;
begin
  // ищем не открыта ли уже эта закладка
  if FViews <> nil then
  begin
    Result := true;
    VC := AppController.GetEntityViewClass(Entity);
    for k := 0 to FViews.Count - 1 do
      if (TObject(FViews[k]) is VC) then
      begin
        _Frame := TEntityController(FViews[k]).Frame;
        if _Frame <> nil then  // аварийная ситуация м.б.
        begin
          ts := _Frame.Parent as TTabSheet;
          pcCalcOrder.ActivePage := ts;
          // Вызываем событие изменения текущей страницы
          pcCalcOrderChange(pcCalcOrder);
        end;
        Exit;
      end;
    // Если не открыта, открываем
    View := CreateController(Entity);
    if View <> nil then  // может не быть прав(?)
    begin
      View.AfterRefresh := View_AfterRefresh;
      View.LoadSettings;
      ts := View.Frame.Parent as TTabSheet;
      pcCalcOrder.ActivePage := ts;
    end;
    // Вызываем событие изменения текущей страницы
    pcCalcOrderChange(pcCalcOrder);
  end
  else
    Result := false;
end;

function TMForm.OpenShipment: boolean;
begin
  Result := OpenEntityView(AppController.Shipment);
end;

procedure TMForm.acShowSaleDocsExecute(Sender: TObject);
begin
  OpenSaleDocs;
end;

function TMForm.OpenSaleDocs: boolean;
begin
  Result := OpenEntityView(AppController.SaleDocs);
end;

function TMForm.OpenMaterialRequests: boolean;
begin
  Result := OpenEntityView(AppController.MaterialRequests);
end;

function TMForm.OpenStock: boolean;
begin
  Result := OpenEntityView(AppController.Stock);
end;

function TMForm.OpenStockMove: boolean;
begin
  Result := OpenEntityView(AppController.StockMove);
end;

function TMForm.OpenStockIncome: boolean;
begin
  Result := OpenEntityView(AppController.StockIncome);
end;

function TMForm.OpenStockWaste: boolean;
begin
  Result := OpenEntityView(AppController.StockWaste);
end;

end.


