unit fPlanFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Mask, JvExMask, JvToolEdit,
  ComCtrls, GridsEh, DBGridEh, DB, JvAppStorage, JvFormPlacement,
  ImgList, Menus, VistaHint,
  JvComponent, JvThread, JvBalloonHint, JvComponentBase,
  JvExExtCtrls, JvNetscapeSplitter, JvExControls, JvLinkLabel,
  TLoggerUnit, DBCtrlsEh,

  PmTimeLine, NotifyEvent, PmScheduleGrid, ServMod, PmExecCode, PmPlan,
  PmProcess, PmEntity, fProdBase, MyDBGridEh, PmGantt, CalcUtils, PmUtils,
  DBGridEhGrouping;

type
  TPlanFrame = class(TProductionBaseFrame)
    paJobDay: TPanel;
    pcJobEquip: TPageControl;
    paDayControls: TPanel;
    sbJobLeft: TSpeedButton;
    sbJobRight: TSpeedButton;
    lbJobStart: TLabel;
    lbJobStartVal: TLabel;
    lbMove: TLabel;
    sbMoveDown: TSpeedButton;
    sbMoveFirst: TSpeedButton;
    sbMoveUp: TSpeedButton;
    sbMoveLast: TSpeedButton;
    btAdd: TBitBtn;
    btRemove: TBitBtn;
    paLowToolbar: TPanel;
    Label5: TLabel;
    Panel8: TPanel;
    btApplyDay: TBitBtn;
    btCancelDay: TBitBtn;
    btExportExcel: TBitBtn;
    sbLocateOrder: TSpeedButton;
    btEditJob: TBitBtn;
    cbDateType: TComboBox;
    btPause: TBitBtn;
    btDivide: TBitBtn;
    btAddSpecial: TBitBtn;
    pmSpecJob: TPopupMenu;
    pmWorkload: TPopupMenu;
    miEditComment: TMenuItem;
    miChangeEquip: TMenuItem;
    JvBalloonHint1: TJvBalloonHint;
    miEditOrderState: TMenuItem;
    miLocateOrder: TMenuItem;
    miWorkloadOpenOrder: TMenuItem;
    miEditJob: TMenuItem;
    N2: TMenuItem;
    paNotPlanned: TPanel;
    paNoPlanHeader: TPanel;
    dgNoPlan: TMyDBGridEh;
    spJobDay: TJvNetscapeSplitter;
    lbToggleNotPlanned: TJvLinkLabel;
    miTimeLocked: TMenuItem;
    miPauseJob: TMenuItem;
    miDivideJob: TMenuItem;
    miAddSpecialJob: TMenuItem;
    miExportExcel: TMenuItem;
    N1: TMenuItem;
    N3: TMenuItem;
    pmForeman: TPopupMenu;
    paErrorMessage: TPanel;
    pmNotPlanned: TPopupMenu;
    miNotPlannedOpenOrder: TMenuItem;
    miNotPlannedEditComment: TMenuItem;
    miViewNotPlannedJob: TMenuItem;
    deJobDate: TDBDateTimeEditEh;
    pmOperators: TPopupMenu;
    pmAssistant: TPopupMenu;
    miEditFiles: TMenuItem;
    procedure pcJobEquipChanging(Sender: TObject; var AllowChange: Boolean);
    procedure pcJobEquipChange(Sender: TObject);
    procedure btCancelDayClick(Sender: TObject);
    procedure btApplyDayClick(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure btUndoClick(Sender: TObject);
    procedure btLockClick(Sender: TObject);
    procedure btUnlockClick(Sender: TObject);
    procedure btRemoveClick(Sender: TObject);
    procedure btExportExcelClick(Sender: TObject);
    procedure deJobDateChange(Sender: TObject);
    procedure sbJobLeftClick(Sender: TObject);
    procedure sbJobRightClick(Sender: TObject);
    procedure btMoveDownClick(Sender: TObject);
    procedure btMoveUpClick(Sender: TObject);
    procedure sbMoveLastClick(Sender: TObject);
    procedure sbMoveFirstClick(Sender: TObject);
    procedure dgNoPlanDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure dgNoPlanDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure dgWorkloadDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure dgWorkloadDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure sbLocateOrderClick(Sender: TObject);
    procedure dgWorkloadEditJob(Sender: TObject);
    procedure dgWorkloadDblClick(Sender: TObject);
    procedure dgWorkloadMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure dgWorkloadGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      State: TGridDrawState);
    procedure dgWorkloadDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumnEh;
      State: TGridDrawState);
    procedure btPauseClick(Sender: TObject);
    procedure btDivideClick(Sender: TObject);
    procedure btAddSpecialClick(Sender: TObject);
    procedure miEditCommentClick(Sender: TObject);
    procedure pmWorkloadPopup(Sender: TObject);
    procedure miEditOrderStateClick(Sender: TObject);
    procedure miWorkloadOpenOrderClick(Sender: TObject);
    procedure miEditJobClick(Sender: TObject);
    procedure btToggleNotPlannedClick(Sender: TObject);
    procedure lbToggleNotPlannedLinkClick(Sender: TObject; LinkNumber: Integer;
      LinkText, LinkParam: string);
    procedure spJobDayMaximize(Sender: TObject);
    procedure dgNoPlanDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure miTimeLockedClick(Sender: TObject);
    procedure cbDateEnabledClick(Sender: TObject);
    procedure paDayControlsResize(Sender: TObject);
    procedure dgNoPlanDblClick(Sender: TObject);
    procedure miNotPlannedEditCommentClick(Sender: TObject);
    procedure miViewNotPlannedJobClick(Sender: TObject);
    procedure dgWorkloadExit(Sender: TObject);
    procedure pmOperatorsPopup(Sender: TObject);
    procedure pmAssistantPopup(Sender: TObject);
    procedure pmForemanPopup(Sender: TObject);
    procedure miEditFilesClick(Sender: TObject);
  private
    //FPlan: TPlan;
    FWorkloads: TList;
    FWorkloadGrids: TList;
    FSettingsLoaded: boolean; // TODO: надо утсановить в true когда закончится загрузка контролов
    dgDayFrom: TMyDBGridEh;
    FOnRemoveFromPlan, FOnMoveJobDown, FOnMoveJobUp,
    FOnMoveJobLast, FOnMoveJobFirst, FOnLaunchReport, FOnOpenOrder, FOnUndo, FOnLock, FOnUnlock: TNotifyEvent;
    FOnEditJob: TBooleanNotifyEvent;
    FOnPauseJob: TNotifyEvent;
    FOnAddToPlan: TBooleanIntNotifyEvent;
    FAfterScrollList, FAfterOpenList: TStringList;
    FOnAddSpecialJob: TIntNotifyEvent;
    FOnMouseMoveJob: TInt2NotifyEvent;
    FOnAssignOperator, FOnAssignShiftForeman, FOnAssignAssistant: TVariantNotifyEvent;
    FOnLocateOrder: TIntNotifyEvent;
    FOnDivideJob: TNotifyEvent;
    FCfgChangedID: TNotifyHandlerID;
    FPlanAfterOpenID: TNotifyHandlerID;
    FOnChangeEquip: TIntNotifyEvent;
    FOnEditJobComment: TNotifyEvent;
    FOnEditFiles: TNotifyEvent;
    FOnEditOrderState: TNotifyEvent;
    FOnTimeLock: TNotifyEvent;
    FTimeLine: TSingleTimeLine;
    FSavedPageIndex: integer;
    FSaveCursor: TCursor;
    FOnUpdateCriteria: TNotifyEvent;
    FOnUpdateWorkloadCriteria: TNotifyEvent;
    FSavedCursor: integer;
    FOverEmployee: boolean;
    FWasActivate: boolean;
    FInAfterScroll: boolean;
    FLastTimeLineWorkload: TWorkload;
    FLastTimeLineShift: TDateTime;
    FGanttFrame: TGanttFrame;
    FErrorMessages: array of string;
    FSavedDayControlsHeight: integer;
    FBeforeOpenDataRunning: boolean;
    FOnTimeLineBlockSelected: TNotifyEvent;
    FMovedJobID: integer;  // перетаскиваемая работа
    FOnViewNotPlannedJob: TNotifyEvent;
    FOnEditNotPlannedJobComment: TNotifyEvent;
    FHint: TMyHintWindow;
    FOnGetUndoEnabled: TBooleanNotifyEvent;
    //FReuseHintWindow: boolean;
    //HintAsync: IAsyncCall;

    procedure CreateDayPages;
    procedure Plan_DayCreateGridColumns(dg: TMyDBGridEh);
    procedure Plan_NotPlannedCreateGridColumns(dg: TMyDBGridEh);
    procedure CheckDataSources;

    //procedure CheckDayApply;  // для плана смены
    //procedure ApplyDayPlan;
    procedure BuildChangeEquipMenu;
    procedure BuildSpecialJobMenu;
    procedure FillSpecialJobMenu(RootItem: TMenuItem);
    procedure BuildForemanMenu;
    procedure FillForemanMenu(RootItem: TMenuItem; ClickEvent: TNotifyEvent;
        EquipCode: integer);
    procedure FillOperatorsMenu(RootItem: TMenuItem; ClickEvent: TNotifyEvent; EquipCode: integer);
    procedure FillAssistantMenu(RootItem: TMenuItem; ClickEvent: TNotifyEvent; EquipCode: integer);
    procedure BuildOperatorsMenu;
    procedure BuildAssistantMenu;
    //procedure FillEquipmentEmployeeMenu(RootItem: TMenuItem);
    //procedure CancelDayPlan;
    procedure ChangeEquipClick(Sender: TObject);
    procedure CreateTimeLine;
    procedure ShowTimeLine;
    procedure HideTimeLine;
    function GetStoragePath: string;
    procedure WorkloadAfterScroll(DataObj: TObject);
    procedure WorkloadAfterOpen(DataObj: TObject);
    procedure PlanAfterOpen(DataObj: TObject);
    procedure PlanDate_GetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure Default_DayCreateGridColumns(dg: TDBGridEh);
    procedure CreateCostColumn(dg: TDBGridEh);
    procedure Default_NotPlannedCreateGridColumns(dg: TDBGridEh);
    procedure dgWorkloadCellClick(Column: TColumnEh);
    function GetCurrentWorkload: TWorkload;
    function GetCurrentWorkloadIndex: integer;
    procedure HandleProcessCfgChanged(Sender: TObject);
    procedure SetCurrentWorkload(const Value: TWorkload);
    procedure SpecialJobClick(Sender: TObject);
    procedure ForemanClick(Sender: TObject);
    procedure OperatorClick(Sender: TObject);
    procedure AssistantClick(Sender: TObject);
    function GetCurrentShift: TShiftInfo;
    // Обновляет диаграмму работ. FullRebuild означает, что не надо проверять,
    // была ли она уже построена для текущего оборудования и смены.
    procedure UpdateTimeLine(FullRebuild: boolean); overload;
    procedure UpdateTimeLine; overload;
    procedure UpdateRangeTimeLine(_TimeLine: TSingleTimeLine; w: TWorkload; FullRebuild: boolean);
    procedure UpdateShiftTimeLine(_TimeLine: TSingleTimeLine; w: TWorkload; FullRebuild: boolean);
    // Строит элементы интерфейса в соответствии с текущей конфигурацией
    procedure ProcessConfiguration;
    procedure BuildRangeTypeBox;
    function GetCurrentWorkloadGrid: TScheduleGrid;
    function GetWorkDate: TDateTime;
    procedure SetWorkDate(_WorkDate: TDateTime);
    procedure SetDateCriteriaType(_Type: integer);
    function GetDateCriteriaType: integer;
    procedure RollOutNotPlanned;  // развернуть очередь заказов
    procedure RollUpNotPlanned;   // свернуть очередь заказов
    procedure HideNotPlanned;     // спрятать очередь заказов совсем
    procedure SettingsChanged; override;
    procedure UpdateFontSize;
    //procedure UpdateCriteriaAndReload(w: TWorkload);
    //procedure UpdateCriteria(w: TWorkload; _Reload: boolean);
    // обработка добавления работы (при перетаскивании передается ключ записи, на которую упало)
    procedure AddJobClicked(WorkloadRowKey: integer);
    function IsShiftMarker(Grid: TScheduleGrid; CellY: integer): boolean;
    function OverShiftForeman(Grid: TScheduleGrid; Cell: TGridCoord; X: integer): boolean; overload;
    function OverShiftForeman(Grid: TScheduleGrid; X: integer): boolean; overload;
    function OverOperator(Grid: TScheduleGrid; Cell: TGridCoord; X: integer): boolean; overload;
    function OverOperator(Grid: TScheduleGrid; X: integer): boolean; overload;
    function OverAssistant(Grid: TScheduleGrid; Cell: TGridCoord; X: integer): boolean; overload;
    function OverAssistant(Grid: TScheduleGrid; X: integer): boolean; overload;
    procedure SetShiftNameFont(ACanvas: TCanvas);
    procedure SetShiftForemanFont(ACanvas: TCanvas);
    procedure SetOperatorFont(ACanvas: TCanvas);
    procedure SetAssistantFont(ACanvas: TCanvas);
    function GetShiftForeman: string;
    function GetOperator: string;
    function GetAssistOperator: string;
    procedure ShowGantt;
    procedure HideGantt;
    procedure UpdateGanttTimeLines;
    procedure UpdateErrorMessages;
    procedure TimeLineBlockSelected(Sender: TObject);
    function GetTimeLineSelectedBlock: TTimeBlock;
    procedure MouseMoveJob(SourceJobID, TargetJobID: integer);
    procedure ShowHint(HintRect: TRect; HintText: string);
    procedure CloseHintWindow;
    function PlanQueue: TPlan;
  public
    property CurrentWorkload: TWorkload read GetCurrentWorkload write SetCurrentWorkload;
    property CurrentWorkloadIndex: integer read GetCurrentWorkloadIndex;
    property CurrentWorkloadGrid: TScheduleGrid read GetCurrentWorkloadGrid;
    property WorkDate: TDateTime read GetWorkDate write SetWorkDate;
    property DateCriteriaType: integer read GetDateCriteriaType write SetDateCriteriaType;

    // обработчики манипуляций с планом смены
    property OnAddToPlan: TBooleanIntNotifyEvent read FOnAddToPlan write FOnAddToPlan;
    property OnDivideJob: TNotifyEvent read FOnDivideJob write FOnDivideJob;
    property OnRemoveFromPlan: TNotifyEvent read FOnRemoveFromPlan write FOnRemoveFromPlan;
    property OnMoveJobDown: TNotifyEvent read FOnMoveJobDown write FOnMoveJobDown;
    property OnMoveJobUp: TNotifyEvent read FOnMoveJobUp write FOnMoveJobUp;
    property OnMoveJobLast: TNotifyEvent read FOnMoveJobLast write FOnMoveJobLast;
    property OnMoveJobFirst: TNotifyEvent read FOnMoveJobFirst write FOnMoveJobFirst;
    property OnMouseMoveJob: TInt2NotifyEvent read FOnMouseMoveJob write FOnMouseMoveJob;
    property OnLaunchReport: TNotifyEvent read FOnLaunchReport write FOnLaunchReport;
    property OnOpenOrder: TNotifyEvent read FOnOpenOrder write FOnOpenOrder;
    property OnLocateOrder: TIntNotifyEvent read FOnLocateOrder write FOnLocateOrder;
    property OnPauseJob: TNotifyEvent read FOnPauseJob write FOnPauseJob;
    property OnEditJob: TBooleanNotifyEvent read FOnEditJob write FOnEditJob;
    property OnUndo: TNotifyEvent read FOnUndo write FOnUndo;
    property OnLock: TNotifyEvent read FOnLock write FOnLock;
    property OnUnlock: TNotifyEvent read FOnUnlock write FOnUnlock;
    property OnAddSpecialJob: TIntNotifyEvent read FOnAddSpecialJob write FOnAddSpecialJob;
    property OnAssignShiftForeman: TVariantNotifyEvent read FOnAssignShiftForeman write FOnAssignShiftForeman;
    property OnAssignOperator: TVariantNotifyEvent read FOnAssignOperator write FOnAssignOperator;
    property OnAssignAssistant: TVariantNotifyEvent read FOnAssignAssistant write FOnAssignAssistant;
    property OnChangeEquip: TIntNotifyEvent read FOnChangeEquip write FOnChangeEquip;
    property OnEditJobComment: TNotifyEvent read FOnEditJobComment write FOnEditJobComment;
    property OnEditFiles: TNotifyEvent read FOnEditFiles write FOnEditFiles;
    property OnEditOrderState: TNotifyEvent read FOnEditOrderState write FOnEditOrderState;
    property OnTimeLock: TNotifyEvent read FOnTimeLock write FOnTimeLock;
    property OnUpdateCriteria: TNotifyEvent read FOnUpdateCriteria write FOnUpdateCriteria;
    property OnUpdateWorkloadCriteria: TNotifyEvent read FOnUpdateWorkloadCriteria write FOnUpdateWorkloadCriteria;
    property OnTimeLineBlockSelected: TNotifyEvent read FOnTimeLineBlockSelected write FOnTimeLineBlockSelected;
    property OnViewNotPlannedJob: TNotifyEvent read FOnViewNotPlannedJob write FOnViewNotPlannedJob;
    property OnEditNotPlannedJobComment: TNotifyEvent read FOnEditNotPlannedJobComment write FOnEditNotPlannedJobComment;
    property OnGetUndoEnabled: TBooleanNotifyEvent read FOnGetUndoEnabled write FOnGetUndoEnabled;

    constructor Create2(Owner: TComponent; _PlanQueue: TPlan; _Workloads: TList);
    destructor Destroy; override;
    procedure AfterCreate; override;
    procedure OpenData; override;
    procedure SaveSettings; override;
    procedure LoadSettings; override;
    function GetWorkloadColumnFields: string;
    procedure Activate;
    // возвращает false, если не найдена закладка для этого оборудования
    function ActivateWorkload(_EquipCode: integer): boolean;
    procedure EditJob;  // открыть диалог редактирования параметров текущей работы
    procedure BeforeOpenData;
    procedure AfterOpenData;
    procedure ShowWarning(_EquipCode: integer; MessageText: string);
    procedure HideWarnings(_EquipCode: integer);
    procedure UpdateJobControls;
    property Workloads: TList read FWorkloads write FWorkloads;
    property TimeLineSelectedBlock: TTimeBlock read GetTimeLineSelectedBlock;
    procedure UpdateLockState;
    function GetColumnTag(Grid: TGridClass; FieldName: string): integer;
  end;

// Специальные тэги для столбцов с нестандартной отрисовкой
const
  CellTag_Customer = 1;
  CellTag_BigBool = 2;
  CellTag_Contractor = 3;
  CellTag_DateTimeIcon = 4;
  CellTag_HasHintText = 5;
  CellTag_Alert = 6;

implementation

uses ExHandler, JvInterpreter, JvJVCLUtils, JvJCLUtils,
  DicObj, DateUtils, StdDic, RDBUtils, EnPaint, CalcSettings, PlanUtils,
  fOrderNum, PmEntSettings, PmJobParams, PmAccessManager, PmOrder,
  PmActions, PmConfigManager, PmContragentPainter, PmOrderProcessItems;

{$R *.dfm}

const
  SINGLE_TL_HEIGHT = 28;
  SHIFT_MARKER_COLOR = $d2f8ff;
  EMPLOYEE_NOT_SET = -1;

type
  THackGrid = class(TScheduleGrid)
  private
    function GetDBGridEhState: TDBGridEhState;
    function GetGridState: TGridState;
  public
    property DBGridEhState: TDBGridEhState read GetDBGridEhState;
    property GridState: TGridState read GetGridState;
  end;

var
  JobColors: TList;

constructor TPlanFrame.Create2(Owner: TComponent; _PlanQueue: TPlan; _Workloads: TList);
{var
  _Name: string;}
begin
  //_Name := 'Plan_' + IntToStr(_Plan.EquipGroupCode);
  inherited Create(Owner, _PlanQueue{_Name});
  //FPlan := _Plan;
  FWorkloads := _Workloads;
  CreateStateLists;
  FCfgChangedID := TConfigManager.Instance.ProcessCfgChanged.RegisterHandler(HandleProcessCfgChanged);
  dgNoPlan.DataSource := PlanQueue.DataSource;
  FPlanAfterOpenID := PlanQueue.OpenNotifier.RegisterHandler(PlanAfterOpen);
  ProcessConfiguration;
  SettingsChanged;

  TSettingsManager.Instance.XPInitComponent(pmWorkload);
  TSettingsManager.Instance.XPInitComponent(pmSpecJob);
  TSettingsManager.Instance.XPInitComponent(pmForeman);
  TSettingsManager.Instance.XPInitComponent(pmOperators);
  TSettingsManager.Instance.XPInitComponent(pmAssistant);

  TSettingsManager.Instance.XPInitComponent(btAdd);
  TSettingsManager.Instance.XPInitComponent(btRemove);
  TSettingsManager.Instance.XPInitComponent(sbMoveUp);
  TSettingsManager.Instance.XPInitComponent(sbMoveDown);
  TSettingsManager.Instance.XPInitComponent(sbMoveFirst);
  TSettingsManager.Instance.XPInitComponent(sbMoveLast);

  FSavedCursor := crNone;
end;

destructor TPlanFrame.Destroy;
var
  I: Integer;
begin
  CloseHintWindow;
  TConfigManager.Instance.ProcessCfgChanged.UnregisterHandler(FCfgChangedID);
  PlanQueue.OpenNotifier.UnregisterHandler(FPlanAfterOpenID);
  FStateTextList.Free;
  FStateCodeList.Free;
  FOrderStateTextList.Free;
  FOrderStateCodeList.Free;
  // отписываемся от событий
  if (FAfterScrollList <> nil) and (FWorkloads <> nil) then
  begin
    for I := 0 to FAfterScrollList.Count - 1 do
    begin
      TWorkload(FWorkloads[i]).AfterScrollNotifier.UnregisterHandler(FAfterScrollList[i]);
      TWorkload(FWorkloads[i]).OpenNotifier.UnregisterHandler(FAfterOpenList[i]);
    end;
  end;
  FreeAndNil(FAfterScrollList);
  FreeAndNil(FAfterOpenList);
  if FGanttFrame <> nil then
  begin
    paJobDay.RemoveControl(FGanttFrame);
    FGanttFrame.Free;
  end;
  inherited Destroy;
end;

procedure TPlanFrame.AfterCreate;
begin
  CreateDayPages;
  CreateTimeLine;
  Plan_NotPlannedCreateGridColumns(dgNoPlan);
end;

// Странички плана смены.
procedure TPlanFrame.CreateDayPages;
var
  ts: TTabSheet;
  pa: TPanel;
  dg: TScheduleGrid;
  i: integer;
  //HasWhere: boolean;
  CurWorkload: TWorkload;
begin
  FWorkloadGrids := TList.Create;
  for i := 0 to FWorkloads.Count - 1 do
  begin
    CurWorkload := FWorkloads[i];
    ts := TTabSheet.Create(Self);
    ts.PageControl := pcJobEquip;
    ts.Name := 'tsJobEquip' + IntToStr(i);
    ts.Caption := CurWorkload.EquipName; //dePrinter.ItemName[CurWorkload.EquipCode];
    pa := TPanel.Create(Self);
    pa.Name := 'paDay' + IntToStr(i);
    pa.Parent := ts;
    pa.Align := alClient;
    pa.Caption := ' ';
    pa.BevelOuter := bvNone;
    pa.BorderWidth := 0;
    dg := TScheduleGrid.Create(Self);
    dg.Name := 'dgDay' + IntToStr(i);
    dg.Parent := pa;
    dg.Align := alClient;
    //dg.ColumnDefValues.Layout := tlCenter;

    dg.PopupMenu := pmWorkload;

    Plan_DayCreateGridColumns(dg);
    dg.Workload := CurWorkload;
    //dg.IniStorage := FMainStorage;
    dg.Options := dg.Options + [dgTabs, dgRowSelect] - [dgColLines];// - [dgIndicator];
    dg.OptionsEh := [dghAutoSortMarking, //dghHighlightFocus,
      dghDblClickOptimizeColWidth, dghIncSearch, dghFixed3d, dghResizeWholeRightPart,
      dghColumnResize, dghColumnMove{, dghRowHighlight}];
    dg.AllowedOperations := [{alopUpdateEh}];
    //dg.DataSource := CurWorkload.DataSource;
    dg.Flat := true;
    dg.RowHeight := 16;
    dg.VTitleMargin := 5;
    dg.TitleLines := 1;   // иначе драгдроп будет мешать изменению ширины столбцов (см. mousemove)
    dg.RowSizingAllowed := true;
    dg.SumList.Active := false;//true;
    dg.AutoFitColWidths := true; // т.к. сейчас есть проблемы с отрисовкой при гориз. скролле
    dg.OnDragOver := dgWorkloadDragOver;
    dg.OnDragDrop := dgWorkloadDragDrop;
    dg.OnDblClick := dgWorkloadDblClick;
    dg.OnMouseMove := dgWorkloadMouseMove;
    dg.OnGetCellParams := dgWorkloadGetCellParams;
    dg.OnDrawColumnCell := dgWorkloadDrawColumnCell;
    dg.OnCellClick := dgWorkloadCellClick;
    dg.OnExit := dgWorkloadExit;

    FWorkloadGrids.Add(dg);
  end;

  UpdateFontSize;
end;

procedure TPlanFrame.Plan_DayCreateGridColumns(dg: TMyDBGridEh);
var
  col: TColumnEh;
begin
  // Сначала создаем все стандартные столбцы, потом запускаем скрипт
  Default_DayCreateGridColumns(dg);
  ExecGridCode(PmProcess.PlanScr_OnCreateDayPlanColumns, dg, PlanQueue);
  if Options.ScheduleShowCost then
    CreateCostColumn(dg); // отдельно, чтобы была последней
  // Назначаем обработчики на некоторые столбцы
  col := dg.FieldColumns['AnyStartDate'];
  col.OnGetCellParams := PlanDate_GetCellParams;
  col := dg.FieldColumns['AnyFinishDate'];
  col.OnGetCellParams := PlanDate_GetCellParams;
end;

procedure TPlanFrame.PlanDate_GetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
var
  f: TDateTimeField;
  WorkYear, WorkMonth, WorkDay, FieldYear, FieldMonth, FieldDay: word;
const
  FmtOnlyTime = 'hh:nn';
  FmtDateTime = 'dd.mm hh:nn';
begin
  F := (Sender as TColumnEh).Field as TDateTimeField;
  if f.IsNull then
    Params.Text := ''
  else
  begin
    if (CurrentWorkload.Criteria.RangeType = PlanRange_Continuous)
      or (CurrentWorkload.Criteria.RangeType = PlanRange_Week) then
      // в этом режиме уже написаны даты на строках со сменами
      Params.Text := FormatDateTime(FmtOnlyTime, f.Value)
    else
    begin
      // Если текущая смена то только время иначе дата + время
      DecodeDate(WorkDate, WorkYear, WorkMonth, WorkDay);
      DecodeDate(f.Value, FieldYear, FieldMonth, FieldDay);
      if (WorkYear = FieldYear) and (WorkMonth = FieldMonth) and (WorkDay = FieldDay) then
        Params.Text := FormatDateTime(FmtOnlyTime, f.Value)
      else
        Params.Text := FormatDateTime(FmtDateTime, f.Value);
    end;
  end;
end;

procedure TPlanFrame.Plan_NotPlannedCreateGridColumns(dg: TMyDBGridEh);
begin
  // Сначала создаем все стандартные столбцы, потом запускаем скрипт
  Default_NotPlannedCreateGridColumns(dg);
  ExecGridCode(PmProcess.PlanScr_OnCreateNotPlannedColumns, dg, PlanQueue);
end;

procedure TPlanFrame.sbJobRightClick(Sender: TObject);
begin
  deJobDate.Value := IncDay(deJobDate.Value, 1);
end;

procedure TPlanFrame.sbJobLeftClick(Sender: TObject);
begin
  deJobDate.Value := IncDay(deJobDate.Value, -1);
end;

procedure TPlanFrame.deJobDateChange(Sender: TObject);
var
  NeedOpen: boolean;
begin
  if FSettingsLoaded then
  begin
    //CheckDayApply;
    FSavedPageIndex := pcJobEquip.ActivePageIndex; // запоминаем текущую страницу
    NeedOpen := true;
    // Проверяем переключение в другой режим просмотра
    if (cbDateType.ItemIndex = PlanRange_Gantt) and (FGanttFrame = nil) then
    begin
      OpenData;
      ShowGantt;
      NeedOpen := false;
    end
    else if (cbDateType.ItemIndex <> PlanRange_Gantt) and (FGanttFrame <> nil) then
      HideGantt;

    if NeedOpen then
      OpenData;
  end;
end;

procedure TPlanFrame.ShowGantt;
begin
  pcJobEquip.Visible := false;
  HideTimeLine;
  FGanttFrame := TGanttFrame.Create(nil, FWorkloads);
  FGanttFrame.Parent := paJobDay;
  UpdateGanttTimeLines;
    //UpdateShiftTimeLine(TSingleTimeLine(FGanttFrame.TimeLines[I]), TWorkload(FWorkloads[I]), true);
end;

procedure TPlanFrame.UpdateGanttTimeLines;
var
  I: Integer;
begin
  if FGanttFrame <> nil then
    for I := 0 to FWorkloads.Count - 1 do
      UpdateRangeTimeLine(TSingleTimeLine(FGanttFrame.TimeLines[I]), TWorkload(FWorkloads[I]), true);
end;

procedure TPlanFrame.HideGantt;
begin
  ShowTimeLine;
  paJobDay.RemoveControl(FGanttFrame);
  //RemoveComponent(FGanttFrame);
  FreeAndNil(FGanttFrame);
  pcJobEquip.Visible := true;
end;

procedure TPlanFrame.cbDateEnabledClick(Sender: TObject);
begin
  UpdateJobControls;
  OpenData;
end;

(*procedure TPlanFrame.CheckDayApply;  // для плана смены
var
  i: integer;
  IsChanged: boolean;
begin
  IsChanged := false;
{  for i := 0 to FWorkloads.Count - 1 do
  begin
    IsChanged := TWorkload(FWorkloads[i]).PlanChanged;
    if IsChanged then break;
  end;
  if IsChanged then begin
    if RusMessageDlg('Применить изменения плана смены?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      ApplyDayPlan
    else
      CancelDayPlan;
  end;}
end;*)

{procedure TPlanFrame.UpdateCriteriaAndReload(w: TWorkload);
begin
  UpdateCriteria(w, true);
end;}

{procedure TPlanFrame.UpdateCriteria(w: TWorkload; _Reload: boolean);
var
  Criteria: TWorkloadCriteria;
begin
  Criteria.Date := deJobDate.Date;
  Criteria.RangeType := cbDateType.ItemIndex;
  w.Criteria := Criteria;
  w.Reload;
end;}

{procedure TPlanFrame.CancelDayPlan;
var
  i: integer;
  CurWorkload: TWorkload;
begin
  for i := 0 to FWorkloads.Count - 1 do
  begin
    CurWorkload := TWorkload(FWorkloads[i]);
    CurWorkload.CancelUpdates;
    UpdateCriteriaAndReload(CurWorkload);
  end;
end;}

procedure TPlanFrame.BeforeOpenData;
begin
  // Если не установлена, ставим в текущую дату
  if NvlDateTime(deJobDate.Value) = 0 then
  begin
    FSettingsLoaded := false;
    try
      deJobDate.Value := Now;
    finally
      FSettingsLoaded := true;
    end;
  end;
  if FSaveCursor <> crSQLWait then
  begin
    FSaveCursor := Screen.Cursor;
    Screen.Cursor := crSQLWait;
  end;
  CheckDataSources;
  if (FSavedPageIndex < FWorkloads.Count) and (FSavedPageIndex <> -1) then
  begin
    FBeforeOpenDataRunning := true; // чтобы не обновляло TimeLine
    try
      CurrentWorkload := FWorkloads[FSavedPageIndex];
      FSavedPageIndex := -1;
    finally
      FBeforeOpenDataRunning := false;
    end;
  end;
end;

procedure TPlanFrame.AfterOpenData;
begin
  UpdateTimeLine;
  UpdateJobControls;
  Screen.Cursor := FSaveCursor;  { Always restore to normal }
end;

{procedure TPlanFrame.ApplyDayPlan;
var
  i: integer;
  CurWorkload: TWorkload;
begin
  for i := 0 to FWorkloads.Count - 1 do
  begin
    CurWorkload := TWorkload(FWorkloads[i]);
    if CurWorkload.PlanChanged then
      CurWorkload.ApplyUpdates;
    UpdateCriteriaAndReload(CurWorkload);
  end;
end;}

procedure TPlanFrame.btExportExcelClick(Sender: TObject);
begin
  FOnLaunchReport(CurrentWorkload);
end;

procedure TPlanFrame.btUndoClick(Sender: TObject);
begin
  FOnUndo(CurrentWorkload);
end;

procedure TPlanFrame.btLockClick(Sender: TObject);
begin
  FOnLock(CurrentWorkload);
  //UpdateLockState;
end;

procedure TPlanFrame.btUnlockClick(Sender: TObject);
begin
  FOnUnlock(CurrentWorkload);
  //UpdateLockState;
end;

procedure TPlanFrame.btAddClick(Sender: TObject);
begin
  AddJobClicked(NvlInteger(CurrentWorkload.KeyValue));
end;

// обработка добавления работы (при перетаскивании передается ключ записи, на которую упало)
procedure TPlanFrame.AddJobClicked(WorkloadRowKey: integer);
begin
  if FOnAddToPlan(WorkloadRowKey) and EntSettings.NewPlanInterface then
  begin
    RollUpNotPlanned;
  end;
  UpdateTimeLine;
end;

procedure TPlanFrame.RollOutNotPlanned;
begin
  //btToggleNotPlanned.Caption := '<< Скрыть';
  lbToggleNotPlanned.Caption := 'Очередь работ | <link=hide>Скрыть</link>';
  spJobDay.Maximized := false;
end;

procedure TPlanFrame.RollUpNotPlanned;
begin
  //btToggleNotPlanned.Caption := 'Показать >>';
  lbToggleNotPlanned.Caption := 'Очередь работ | <link=show>Показать</link>';
  spJobDay.Maximized := true;
end;

procedure TPlanFrame.HideNotPlanned;     // спрятать очередь заказов совсем
begin
  paNotPlanned.Visible := false;
  spJobDay.Visible := false;
end;

procedure TPlanFrame.lbToggleNotPlannedLinkClick(Sender: TObject;
  LinkNumber: Integer; LinkText, LinkParam: string);
begin
  if LinkParam = 'hide' then
    RollUpNotPlanned
  else
    RollOutNotPlanned;
end;

procedure TPlanFrame.btRemoveClick(Sender: TObject);
begin
  FOnRemoveFromPlan(CurrentWorkload);
  UpdateTimeLine;
end;

procedure TPlanFrame.btToggleNotPlannedClick(Sender: TObject);
begin
  if spJobDay.Maximized then
    RollOutNotPlanned
  else
    RollUpNotPlanned;
end;

procedure TPlanFrame.btMoveDownClick(Sender: TObject);
begin
  FOnMoveJobDown(CurrentWorkload);
  UpdateTimeLine;
end;

procedure TPlanFrame.btMoveUpClick(Sender: TObject);
begin
  FOnMoveJobUp(CurrentWorkload);
  UpdateTimeLine;
end;

procedure TPlanFrame.sbMoveLastClick(Sender: TObject);
begin
  FOnMoveJobLast(CurrentWorkload);
  UpdateTimeLine;
end;

procedure TPlanFrame.sbMoveFirstClick(Sender: TObject);
begin
  FOnMoveJobFirst(CurrentWorkload);
  UpdateTimeLine;
end;

procedure TPlanFrame.btApplyDayClick(Sender: TObject);
begin
  //ApplyDayPlan;
end;

procedure TPlanFrame.btCancelDayClick(Sender: TObject);
begin
  //CancelDayPlan;
end;

procedure TPlanFrame.paDayControlsResize(Sender: TObject);
begin
  paErrorMessage.Height := 20;
  paErrorMessage.Width := Width - 10 - paErrorMessage.Left;
end;

procedure TPlanFrame.pcJobEquipChange(Sender: TObject);
var
  dgTo: TMyDBGridEh;
  i: integer;
  w: TWorkload;
begin
  w := FWorkloads[pcJobEquip.ActivePageIndex];
  if {not w.Active and }not FBeforeOpenDataRunning then
    FOnUpdateWorkloadCriteria(Self);//(w, true);

  // При переключении табчиков присваиваем ширину столбцов и высоту строк
  dgTo := CurrentWorkloadGrid;
  if (dgDayFrom <> nil) and (dgDayFrom <> dgTo) then
  begin
    dgTo.AutoFitColWidths := false;
    for i := 0 to dgDayFrom.Columns.Count - 1 do
      dgTo.Columns[i].Width := dgDayFrom.Columns[i].Width;
    dgTo.RowHeight := dgDayFrom.RowHeight;
    //dgTo.IniStorage := FormStorage;
    dgTo.AutoFitColWidths := true;
  end;
  dgDayFrom := dgTo;

  UpdateLockState;

  if not FBeforeOpenDataRunning then
  begin
    UpdateErrorMessages;
    UpdateTimeLine;
    UpdateJobControls;
  end;
end;

procedure TPlanFrame.pcJobEquipChanging(Sender: TObject; var AllowChange: Boolean);
begin
  dgDayFrom := TMyDBGridEh(FWorkloadGrids[pcJobEquip.ActivePageIndex]);
  //dgDayFrom.IniStorage := nil;
end;

procedure TPlanFrame.UpdateLockState;
begin
  TMainActions.GetAction(TScheduleActions.Lock).Enabled := not CurrentWorkload.Locked;
  TMainActions.GetAction(TScheduleActions.Unlock).Enabled := CurrentWorkload.Locked;
  TMainActions.GetAction(TScheduleActions.Undo).Enabled := FOnGetUndoEnabled(CurrentWorkload);
end;

procedure TPlanFrame.SaveSettings;
begin
  inherited SaveSettings;
  with TSettingsManager.Instance do
  begin
    Storage.WriteInteger(GetStoragePath + 'NotPlannedRowHeight', dgNoPlan.RowHeight);
    Storage.WriteInteger(GetStoragePath + 'DayPageIndex', pcJobEquip.ActivePageIndex);
    Storage.WriteInteger(GetStoragePath + 'DateType', cbDateType.ItemIndex);
    Storage.WriteInteger(GetStoragePath + 'SplitterPos', paJobDay.Height);
    if PlanQueue.Active then
      SaveGridLayout(dgNoPlan, GetStoragePath + 'NoPlan_' + IntToStr(PlanQueue.EquipGroupCode));
    if dgDayFrom <> nil then
    begin
      SaveGridLayout(dgDayFrom, GetStoragePath + 'DayPlan_' + IntToStr(PlanQueue.EquipGroupCode));
      Storage.WriteInteger(GetStoragePath + 'DayPlanRowHeight', dgDayFrom.RowHeight);
    end;
  end;
end;

function TPlanFrame.GetStoragePath: string;
begin
  Result := 'Plan_' + IntToStr(PlanQueue.EquipGroupCode) + '\';
end;

procedure TPlanFrame.LoadSettings;
var
  index: integer;
//  CurWorkload: TWorkload;
begin
  inherited LoadSettings;

  index := TSettingsManager.Instance.Storage.ReadInteger(GetStoragePath + 'DateType', 0);
  if index < cbDateType.Items.Count then
    cbDateType.ItemIndex := index;

  index := TSettingsManager.Instance.Storage.ReadInteger(GetStoragePath + 'SplitterPos', paJobDay.Height);
  paJobDay.Height := index;

  //for i := 0 to FWorkloads.Count - 1 do
//  begin
//    CurWorkload := FWorkloads[i];
//    dgDayFrom := nil;
    index := TSettingsManager.Instance.Storage.ReadInteger(GetStoragePath + 'DayPageIndex', 0);
    if (index >= 0) and (index < pcJobEquip.PageCount) then
      // настройки ширины помнит только текущая таблица
      FSavedPageIndex := index  // будет использовано позже
      //pcJobEquip.ActivePageIndex := index
    else
      pcJobEquip.ActivePageIndex := 0;
//  end;

  if AccessManager.CurUser.ViewNotPlanned then
    TSettingsManager.Instance.LoadGridLayout(dgNoPlan, GetStoragePath + 'NoPlan_' + IntToStr(PlanQueue.EquipGroupCode));
  dgNoPlan.RowHeight := TSettingsManager.Instance.Storage.ReadInteger(GetStoragePath + 'NotPlannedRowHeight', dgNoPlan.RowHeight);
end;

procedure TPlanFrame.OpenData;
begin
  FOnUpdateCriteria(nil);
end;

procedure TPlanFrame.CheckDataSources;
var
  i: integer;
  CurWorkload: TWorkload;
begin
  // Присваиваем источники данных из объектов гридам.
  for i := 0 to FWorkloads.Count - 1 do
  begin
    Application.ProcessMessages;
    CurWorkload := FWorkloads[i];
    // Если хоть один уже присвоен правильно, то значит уже присваивали
    if TDBGridEh(FWorkloadGrids[i]).DataSource = CurWorkload.DataSource then
      Exit;      // уходим

    TDBGridEh(FWorkloadGrids[i]).DataSource := CurWorkload.DataSource;

    if FAfterScrollList = nil then FAfterScrollList := TStringList.Create;
    if FAfterOpenList = nil then FAfterOpenList := TStringList.Create;
    // добавляем обработчики в список чтобы потом освободить
    FAfterScrollList.Add(CurWorkload.AfterScrollNotifier.RegisterHandler(WorkloadAfterScroll));
    FAfterOpenList.Add(CurWorkload.OpenNotifier.RegisterHandler(WorkloadAfterOpen));

  end;
  // загрузка настроек таблицы работает только если есть datasource поэтому здесь
  dgDayFrom := TMyDBGridEh(FWorkloadGrids[pcJobEquip.ActivePageIndex]);
  TSettingsManager.Instance.LoadGridLayout(dgDayFrom,
    GetStoragePath + 'DayPlan_' + IntToStr(PlanQueue.EquipGroupCode));
  dgDayFrom.RowHeight := TSettingsManager.Instance.Storage.ReadInteger(
    GetStoragePath + 'DayPlanRowHeight', dgDayFrom.RowHeight);

  if (dgNoPlan.DataSource <> PlanQueue.DataSource) then
    dgNoPlan.DataSource := PlanQueue.DataSource;
end;

procedure TPlanFrame.dgNoPlanDblClick(Sender: TObject);
var
  Cell: TGridCoord;
  ClientMouse: TPoint;
begin
  ClientMouse := dgNoPlan.ScreenToClient(Mouse.CursorPos);
  Cell := dgNoPlan.MouseCoord(ClientMouse.X, ClientMouse.Y);
  if Cell.X = dgNoPlan.FieldColumns[TPlan.F_HasComment].Index + 1 then
    miNotPlannedEditCommentClick(Sender)
  else
    FOnViewNotPlannedJob(Self);
end;

procedure TPlanFrame.dgNoPlanDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  btRemoveClick(CurrentWorkload);
end;

procedure TPlanFrame.dgNoPlanDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source = FWorkloadGrids[pcJobEquip.ActivePageIndex]);
end;

procedure DrawBooleanCell(Grid: TGridClass; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
begin
  if Column.Tag = CellTag_Customer then   // картинка заказчика
  begin
    Grid.Canvas.FillRect(Rect);
    if NvlBoolean(Column.Field.Value) then
      DrawGridCellBitmap(Grid.Canvas, Rect, CustomerPainter.GetWorkCustomerBitmap,
        clFuchsia, taCenter);
  end
  else
  if Column.Tag = CellTag_BigBool then    // яркая галочка или крестик
  begin
    Grid.Canvas.FillRect(Rect);
    if NvlBoolean(Column.Field.Value) then
      DrawGridCellBitmap(Grid.Canvas, Rect, bmpTick16, clFuchsia, taCenter)
    else if Rect.Bottom - Rect.Top > 32 then
      DrawGridCellBitmap(Grid.Canvas, Rect, bmpError32, clFuchsia, taCenter)
    else
      DrawGridCellBitmap(Grid.Canvas, Rect, bmpError16, clFuchsia, taCenter);
  end
  else
  if Column.Tag = CellTag_Alert then    // крестик если false или ничего
  begin
    Grid.Canvas.FillRect(Rect);
    if not VarIsNull(Column.Field.Value) and Column.Field.Value then
      DrawGridCellBitmap(Grid.Canvas, Rect, bmpError16, clFuchsia, taCenter);
  end
  else if Column.Tag = CellTag_Contractor then    // субподряд
  begin
    Grid.Canvas.FillRect(Rect);
    if NvlBoolean(Column.Field.Value) then
      DrawGridCellBitmap(Grid.Canvas, Rect, bmpContractor, clFuchsia, taCenter);
  end
  else   // обычная галочка
    EnablePainter.DrawRedCheck(Grid, Rect, DataCol, Column, State)
end;

procedure DrawHasComment(Grid: TGridClass; Rect: TRect; Column: TColumnEh);
begin
  Grid.Canvas.FillRect(Rect);
  if NvlBoolean(Column.Field.DataSet[TPlan.F_JobAlert]) then
    DrawGridCellBitmap(Grid.Canvas, Rect, bmpHasAlert, clFuchsia, taCenter)
  else
    if NvlBoolean(Column.Field.Value) then
      DrawGridCellBitmap(Grid.Canvas, Rect, bmpHasJobNotes, clOlive, taCenter)
    else
      if NvlBoolean(Column.Field.DataSet[TPlan.F_HasTechNotes]) then
        DrawGridCellBitmap(Grid.Canvas, Rect, bmpHasNotes, clOlive, taCenter)
end;

// Для даты поставки: яркая галочка без текста если 0,
// минусик если пусто или бледная галочка с текстом, если не пусто.
procedure DrawDateTimeCell(Grid: TGridClass; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
var
  H: integer;
  s: string;
  bmp: TBitmap;
  IsZero, isComplete: boolean;
begin
  Grid.Canvas.FillRect(Rect);

  if VarIsNull(Column.Field.Value) then
    DrawGridCellBitmap(Grid.Canvas, Rect, bmpError16, clFuchsia, Column.Alignment)
  else
  {if NvlFloat(Column.Field.Value) = 0 then
    DrawGridCellBitmap((Sender as TGridClass).Canvas, Rect, bmpTick16, clFuchsia)
  else}
  begin

//  if (Column.Field is TDateTimeField) then
//    ShowMessage(Column.Field.Name);

// 25.02.2021 IsZero := (Column.Field.Name is TDateTimeField) and (YearOf(Column.Field.Value) = 1900);

//    ShowMessage(Column.Field.DataSet.FieldList.Text);

    isComplete := Grid.DataSource.DataSet.FieldByName('PaperReadyComplete').Value = 1;

    IsZero := (Column.Field is TDateTimeField) and Column.Field.Value = null; // and (Column.Grid.DataSource.DataSet.FieldByName('PaperReadyComplite').Value = 1); // and (YearOf(Column.Field.Value) = 1900);
    if isComplete then
      bmp := bmpTick16
    else
      bmp := bmpYellowTick16;
    DrawBitmapTransparent(Grid.Canvas, Rect.Left, (Rect.Top + Rect.Bottom - bmp.Height) div 2,
      bmp, clFuchsia);

    if not IsZero then
    begin
      H := Grid.Canvas.TextHeight('0');
      if (Column.Field is TDateTimeField) and ((Column.Field as TDateTimeField).DisplayFormat <> '') then
        s := FormatDateTime((Column.Field as TDateTimeField).DisplayFormat, Column.Field.Value)
      else
        s := Column.Field.AsString;
      Grid.Canvas.TextOut(Rect.Left + bmp.Width + 3, (Rect.Top + Rect.Bottom - H) div 2, s);
    end;
  end;
end;

procedure DrawOverlapCell(Grid: TGridClass; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
var
  //H: integer;
  //s: string;
  bmp: TBitmap;
begin
  bmp := bmpArrowDown;
  DrawBitmapTransparent(Grid.Canvas, Rect.Left, (Rect.Top + Rect.Bottom - bmp.Height) div 2,
    bmp, clFuchsia);
  {H := Grid.Canvas.TextHeight('0');
  s := Column.Field.AsString;
  Grid.Canvas.TextOut(Rect.Left + bmp.Width + 3, (Rect.Top + Rect.Bottom - H) div 2, s);}
end;

procedure TPlanFrame.dgNoPlanDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
begin
  if (Column.Field <> nil) and not Column.Field.DataSet.IsEmpty then
  begin
    if Column.Field.FieldName = TPlan.F_HasComment then
      DrawHasComment(Sender as TGridClass, Rect, Column)
    else
    if Column.Tag = CellTag_DateTimeIcon then
      DrawDateTimeCell(Sender as TGridClass, Rect, DataCol, Column, State)
    else
    if Column.Field is TBooleanField then
      DrawBooleanCell(Sender as TGridClass, Rect, DataCol, Column, State)
    else
      dgNoPlan.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end
  else
    dgNoPlan.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  //EnablePainter.DrawRedCheck(Sender, Rect, DataCol, Column, State);
end;

procedure TPlanFrame.dgWorkloadExit(Sender: TObject);
begin
  CloseHintWindow;
end;

procedure TPlanFrame.dgWorkloadDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source = dgNoPlan) or (Source is TScheduleGrid);
  {if not Accept then
  begin
     if (Source is TScheduleGrid) then
     begin
       Accept := true;
     end;
  end;}
end;

procedure TPlanFrame.dgWorkloadDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  Cell: TGridCoord;
  FActiveRecord: integer;
  KeyVal: integer;
begin
  Cell := (Sender as TScheduleGrid).MouseCoord(X, Y);
  FActiveRecord := THackGrid(CurrentWorkloadGrid).DataLink.ActiveRecord;
  if Cell.Y >= 1 then
  begin
    THackGrid(CurrentWorkloadGrid).DataLink.ActiveRecord := Cell.Y - 1;
    KeyVal := NvlInteger(CurrentWorkload.KeyValue);
    if FActiveRecord >= 0 then
      THackGrid(CurrentWorkloadGrid).DataLink.ActiveRecord := FActiveRecord;
  end else
    KeyVal := 0;

  if Source = dgNoPlan then
    AddJobClicked(KeyVal)
  else
  begin
    MouseMoveJob(FMovedJobID, KeyVal);
    FMovedJobID := 0;
  end;
end;

procedure TPlanFrame.MouseMoveJob(SourceJobID, TargetJobID: integer);
begin
  if (SourceJobID <> 0) and (TargetJobID <> 0) and (TargetJobID <> SourceJobID) then
  begin
    FOnMouseMoveJob(SourceJobID, TargetJobID);
    UpdateTimeLine;
  end;
end;

procedure TPlanFrame.dgWorkloadEditJob(Sender: TObject);
begin
  EditJob;
end;

procedure TPlanFrame.dgWorkloadDblClick(Sender: TObject);
var
  Cell: TGridCoord;
  ClientMouse: TPoint;
begin
  CloseHintWindow;
  if not CurrentWorkload.IsShiftMarker then
  begin
    ClientMouse := CurrentWorkloadGrid.ScreenToClient(Mouse.CursorPos);
    Cell := CurrentWorkloadGrid.MouseCoord(ClientMouse.X, ClientMouse.Y);
    if Cell.X = CurrentWorkloadGrid.FieldColumns[TPlan.F_HasComment].Index + 1 then
      miEditCommentClick(Sender)
    else
      EditJob;
  end;
end;

procedure TPlanFrame.EditJob;
begin
  if FOnEditJob(CurrentWorkload) then
    UpdateTimeLine;
end;

function TPlanFrame.GetWorkDate: TDateTime;
begin
  Result := NvlDateTime(deJobDate.Value);
end;

procedure TPlanFrame.SetWorkDate(_WorkDate: TDateTime);
begin
  deJobDate.Value := _WorkDate;
end;

function TPlanFrame.GetDateCriteriaType: integer;
begin
  Result := cbDateType.ItemIndex;
end;

procedure TPlanFrame.SetDateCriteriaType(_Type: integer);
begin
  cbDateType.ItemIndex := _Type;
end;

// Кнопка должна быть SpeedButton чтобы не менялся ActiveControl
procedure TPlanFrame.sbLocateOrderClick(Sender: TObject);
var
  OrderNum: integer;
begin
  OrderNum := ExecOrderNumberForm;
  if OrderNum > 0 then
    FOnLocateOrder(OrderNum);
end;

procedure TPlanFrame.UpdateJobControls;
var
  e, Started, planWorkload, plan: boolean;
  KPRec: TKindProcPerm;
begin
  e := CurrentWorkload <> nil;
  if e then
    e := CurrentWorkload.DataSet.Active and not CurrentWorkload.IsEmpty;

  // Проверяем право пользователя на изменение плановых дат процесса этого вида в плане
  if e and (CurrentWorkload <> nil) and not VarIsNull(CurrentWorkload.KindID) then
  begin
    AccessManager.ReadUserKindProcPermTo(KPRec, CurrentWorkload.KindID, AccessManager.CurUser.ID, CurrentWorkload.ProcessID);
    // Если план заблокирован или нет прав на планирование и фактич. отметки, то выходим
    planWorkload := KPRec.PlanDate and KPRec.FactDate;
  end else
    planWorkload := true;

  // Проверяем право пользователя на изменение плановых дат процесса этого вида в незапланированных
  if e and (CurrentWorkload <> nil) and PlanQueue.Active and not VarIsNull(PlanQueue.KindID) then
  begin
    AccessManager.ReadUserKindProcPermTo(KPRec, PlanQueue.KindID, AccessManager.CurUser.ID, PlanQueue.ProcessID);
    // Если план заблокирован или нет прав на планирование и фактич. отметки, то выходим
    plan := KPRec.PlanDate and KPRec.FactDate;
  end else
    plan := true;

  btEditJob.Enabled := e;
  btExportExcel.Enabled := e;

  btPause.Enabled := e and planWorkload and PlanUtils.CanPause(CurrentWorkload.ExecState);
  if e then
  begin
    if CurrentWorkload.ExecState = esPaused then
      btPause.Caption := 'Продолжить'
    else
      btPause.Caption := 'Приостановить';
  end;

  if AccessManager.CurUser.ViewNotPlanned then
  begin
    lbMove.Visible := e;
    btRemove.Visible := e and planWorkload;
    if (CurrentWorkload <> nil) and e then
      // Если процесс уже начался или закончился, то не снимать его и не двигать
      Started := not VarIsNull(CurrentWorkload.FactStartDateTime) or not VarIsNull(CurrentWorkload.FactFinishDateTime)
    else
      Started := false;
    btAdd.Enabled := not PlanQueue.DataSet.IsEmpty and plan;
    btRemove.Enabled := not Started and planWorkload;
    btDivide.Enabled := e and VarIsNull(CurrentWorkload.FactFinishDateTime)
      and (CurrentWorkload.JobType = JobType_Work) and planWorkload;

    sbMoveLast.Enabled := false;//e and not Started; // 13.05.2009 - Временно запрещено, т.к. перемещение мышью часто работает корректнее
    sbMoveFirst.Enabled := false;//e and not Started;
    sbMoveDown.Enabled := false;//e and not Started;
    sbMoveUp.Enabled := false;//e and not Started;
    lbMove.Enabled := false;//e and not Started;
  end
  else  // для режима "без очереди заказов"
  begin
    lbMove.Visible := false;
    btRemove.Visible := false;
    btAdd.Enabled := false;
    btRemove.Enabled := false;
    btDivide.Enabled := false;

    sbMoveLast.Enabled := false;
    sbMoveFirst.Enabled := false;
    sbMoveDown.Enabled := false;
    sbMoveUp.Enabled := false;
    lbMove.Enabled := false;
  end;
end;

procedure TPlanFrame.WorkloadAfterScroll(DataObj: TObject);
begin
  if ((DataObj as TEntity).DataSet.State <> dsInsert)
    and not (DataObj as TEntity).DataSet.ControlsDisabled then
  begin
    if not FInAfterScroll and (CurrentWorkload = DataObj)
       and ((CurrentWorkload.Criteria.RangeType = PlanRange_Continuous)
            or (CurrentWorkload.Criteria.RangeType = PlanRange_Week)) then
    begin
      FInAfterScroll := true;
      try
        UpdateShiftTimeLine(FTimeLine, CurrentWorkload, false);
      finally
        FInAfterScroll := false;
      end;
    end;
    UpdateJobControls;
  end;
end;

procedure TPlanFrame.WorkloadAfterOpen(DataObj: TObject);
begin
  UpdateJobControls;
end;

procedure TPlanFrame.PlanAfterOpen(DataObj: TObject);
begin
  UpdateJobControls;
end;

function TPlanFrame.IsShiftMarker(Grid: TScheduleGrid; CellY: integer): boolean;
var
  FOldActiveRecord: integer;
begin
  if THackGrid(Grid).DataLink.Active and (THackGrid(Grid).DataLink.RecordCount > 0) then
  begin
    FOldActiveRecord := THackGrid(Grid).DataLink.ActiveRecord;
    if (FOldActiveRecord >= 0) and (CellY > 0) then
    begin
      THackGrid(Grid).DataLink.ActiveRecord := CellY - 1;
      Result := CurrentWorkload.IsShiftMarker;
      THackGrid(Grid).DataLink.ActiveRecord := FOldActiveRecord;
    end
    else
      Result := false;
  end
  else
    Result := false;
end;

procedure TPlanFrame.dgWorkloadMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  th, CurID: integer;
  Cell: TGridCoord;
  Grid: TScheduleGrid;
begin
  if (ssLeft in Shift) then
  begin
    if not TControl(Sender).Dragging
      and not (THackGrid(Sender).GridState in [gsColMoving, gsRowSizing, gsColSizing])
      and (THackGrid(Sender).DBGridEhState <> dgsColSizing) then
    begin
      th := TDBGridEh(Sender).TitleHeight;
      if th = 0 then
      begin
        if (TDBGridEh(Sender).RowHeight = 0) or (TDBGridEh(Sender).TitleLines = 0) then
          raise Exception.Create('Внутренняя ошибка: Должна быть установлена высота строки и кол-во строк заголовка.');
        th := TDBGridEh(Sender).RowHeight * TDBGridEh(Sender).TitleLines + TDBGridEh(Sender).VTitleMargin * 2;
      end;
      if (Y > th) then
      begin
        if Sender = dgNoPlan then
          TControl(Sender).BeginDrag(false)
        else
        begin
          CurID := NvlInteger(CurrentWorkload.KeyValue);
          if CurID > 0 then
          begin
            FMovedJobID := CurID;
            TControl(Sender).BeginDrag(false);
          end;
        end;
      end;
    end;
  end
  else if (Sender <> nil) and (Sender is TScheduleGrid) then
  begin
    Grid := Sender as TScheduleGrid;
    Cell := Grid.MouseCoord(X, Y);
    //TLoggerUnit.TLogger.GetInstance.Info(VarToStr(X));
    //TLoggerUnit.TLogger.GetInstance.Info(VarToStr(IsShiftMarker(Grid, Cell.Y)));
    //TLoggerUnit.TLogger.GetInstance.Info(VarToStr(OverShiftEmployee(Grid, Cell, X)));
    if not FOverEmployee then
    begin
      if (Cell.Y > 0) and IsShiftMarker(Grid, Cell.Y)
        and (OverShiftForeman(Grid, Cell, X) or OverOperator(Grid, Cell, X) or OverAssistant(Grid, Cell, X)) then
      begin
        FSavedCursor := Screen.Cursor;
        Screen.Cursor := crHandPoint;
        FOverEmployee := true;
      end
    end
      else if (Screen.Cursor = crHandPoint)  {and (FSavedCursor <> crNone)}
       and (((Cell.Y > 0) and (IsShiftMarker(Grid, Cell.Y)
           and not OverShiftForeman(Grid, Cell, X) and not OverOperator(Grid, Cell, X) and not OverAssistant(Grid, Cell, X))
           or not IsShiftMarker(Grid, Cell.Y))
       or (Cell.Y <= 0)) then
      begin
        Screen.Cursor := FSavedCursor;
        FOverEmployee := false;
        //FSavedCursor := crNone;
      end;
  end;
end;

// Собирает поля столбцов для экспорта
function TPlanFrame.GetWorkloadColumnFields: string;
var
  dgTemp: TMyDBGridEh;
begin
  // воссоздаем оригинальные стобцы на случай если они были перемещены
  dgTemp := TMyDBGridEh.Create(nil);
  try
    Plan_DayCreateGridColumns(dgTemp);
    dgTemp.DataSource := CurrentWorkload.DataSource;
    Result := GetColumnsFieldList(dgTemp);
  finally
    dgTemp.Free;
  end;
end;

function GetSpecialJobColorN(JobType, N: integer): TColor;
var
  ColorStr: string;
  bk: TColor;
begin
  ColorStr := Trim(NvlString(TConfigManager.Instance.StandardDics.deSpecialJob.ItemValue[JobType, N]));
  if MyHexToColor(ColorStr, bk) then
    Result := bk
  else
    Result := clWhite;
end;

function GetSpecialJobBkColor(JobType: integer): TColor;
begin
  Result := GetSpecialJobColorN(JobType, 2);
end;

function GetSpecialJobColor(JobType: integer): TColor;
begin
  Result := GetSpecialJobColorN(JobType, 3);
end;

procedure TPlanFrame.dgWorkloadGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
var
  //ds: TDataSet;
  w: TWorkload;
begin
  w := CurrentWorkload;
  if w <> nil then
  begin
    //ds := w.DataSet;
    if w.Active and not w.IsEmpty then
    begin
      if w.JobType = JobType_Work then
      begin
        if EntSettings.JobColorByExecState then
          Background := GetProcessStateColor(w.ExecState)
        else if VarIsNull(w.JobColor) then
          Background := clWindow
        else
          Background := w.JobColor;
      end
      else
      if w.JobType >= JobType_Special then
      begin
        // Специальные работы раскрашиваем согласно справочнику
        Background := GetSpecialJobBkColor(w.JobType);
        AFont.Color := GetSpecialJobColor(w.JobType);
      end;
      // подсвечиваем красным номер заказа, в котором есть отметка о проблемах
      if (Column.FieldName = TOrder.F_OrderNumber) and w.JobAlert then
      begin
        AFont.Color := clRed;
        AFont.Style := [fsBold];
      end;
    end
    else
      Background := clWindow;
  end;
end;

const
  SHIFT_NAME_OFFSET = 40;
  MaxText: string = 'wwwwwwwwwwwwwwwwwwwwwwwwwwwwww';

procedure TPlanFrame.dgWorkloadDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  ARect: TRect;
  s: integer;
  ACanvas: TCanvas;
  I: Integer;
  TextValue: string;
  Grid: TGridClass;
  //SavePen: TPen;
  IsWork: boolean;
  Job: TJobParams;
  SI: TShiftInfo;
begin
  if CurrentWorkload = nil then Exit;

  Grid := Sender as TGridClass;
  if (DataCol = Grid.LeftCol - 1) and CurrentWorkload.IsShiftMarker then
  begin
    // рисует одну широкую ячейку в строке с заголовком смены
    ARect := Rect;
    S := 0;
    for I := DataCol to Grid.Columns.Count - 1 do
    begin
      S := S + Grid.Columns[I].Width;
      if S > Grid.Width then
      begin
        S := Grid.Width;
        break;
      end;
    end;

    ARect.Right := S + ARect.Left + 1;
    ACanvas := Grid.Canvas;
    //if not (gdFocused in State) then
      ACanvas.Brush.Color := SHIFT_MARKER_COLOR;
    ACanvas.FillRect(ARect);
    ACanvas.Font.Style := [fsBold];
    {if gdFocused in State then
      ACanvas.Font.Color := clHighlightText;}
    // название смены
    TextValue := NvlString(CurrentWorkload.Comment);
    ARect.Left := SHIFT_NAME_OFFSET;
    ACanvas.TextRect(ARect, TextValue, [tfLeft, tfVerticalCenter, tfSingleLine]);
    // мастер смены
    I := ACanvas.TextWidth(TextValue);  // ширина названия смены
    ARect.Left := ARect.Left + I + SHIFT_NAME_OFFSET;
    TextValue := GetShiftForeman;
    ACanvas.Font.Style := [fsUnderline];
    {if gdFocused in State then
      ACanvas.Font.Color := clHighlightText
    else}
      ACanvas.Font.Color := clDkGray;
    ACanvas.TextRect(ARect, TextValue, [tfLeft, tfVerticalCenter, tfSingleLine]);

    // исполнитель
    I := ACanvas.TextWidth(MaxText);  // ширина текста о мастере смены
    ARect.Left := ARect.Left + I + SHIFT_NAME_OFFSET;
    TextValue := GetOperator;
    ACanvas.Font.Style := [fsUnderline];
    {if gdFocused in State then
      ACanvas.Font.Color := clHighlightText
    else}
      ACanvas.Font.Color := clBlue;
    ACanvas.TextRect(ARect, TextValue, [tfLeft, tfVerticalCenter, tfSingleLine]);

    // Помошник
    I := ACanvas.TextWidth(MaxText);  // ширина текста о помошнике
    ARect.Left := ARect.Left + I + SHIFT_NAME_OFFSET;
    TextValue := GetAssistOperator;
    ACanvas.Font.Style := [fsUnderline];
    {if gdFocused in State then
      ACanvas.Font.Color := clHighlightText
    else}
      ACanvas.Font.Color := clGreen;
    ACanvas.TextRect(ARect, TextValue, [tfLeft, tfVerticalCenter, tfSingleLine]);


    // Стоимость работ на смене
    if Options.ScheduleShowCost then
    begin
      SI := CurrentWorkload.GetShiftByID(CurrentWorkload.JobID);
      // на пустых сменах не пишем
      if (SI <> nil) and (SI.JobList.Count > 0) then
      begin
        I := ACanvas.TextWidth(MaxText);  // ширина текста об исполнителе
        ARect.Left := ARect.Left + I + SHIFT_NAME_OFFSET;
        TextValue := 'Стоимость работ: ' + FormatFloat('#,##0.00', SI.Cost) + ' грн.';
        ACanvas.Font.Style := [];
        ACanvas.Font.Color := clWindowText;
        ACanvas.TextRect(ARect, TextValue, [tfLeft, tfVerticalCenter, tfSingleLine]);
      end;
    end;
  end
  else
  if (Column.Field <> nil) and not Column.Field.DataSet.IsEmpty then
  begin
    if Column.Field.FieldName = TPlan.F_HasComment then
      DrawHasComment(Grid, Rect, Column)
    else
    if (Column.Tag = CellTag_DateTimeIcon) // только для обычных работ
       and (NvlInteger(Column.Field.DataSet['JobType']) = JobType_Work) then
      DrawDateTimeCell(Sender as TGridClass, Rect, DataCol, Column, State)
    else
    if Column.Field is TBooleanField then
    begin
      IsWork := not Column.Field.DataSet.IsEmpty      // только для обычных работ
        and (NvlInteger(Column.Field.DataSet['JobType']) = JobType_Work);
      if IsWork then
        DrawBooleanCell(Grid, Rect, DataCol, Column, State)
      else
        Grid.Canvas.FillRect(Rect);
    end
    else
    if not EntSettings.SplitJobs and (Column.Field.FieldName = TWorkload.F_AnyDuration)
      and (NvlInteger(Column.Field.DataSet['JobType']) = JobType_Work) then
    begin
      Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
      Job := CurrentWorkload.CurrentJob;
      if (Job <> nil) and Job.OverlapShift then
      begin
        DrawOverlapCell(Sender as TGridClass, Rect, DataCol, Column, State);
      end;
    end;
  end;
end;

function TPlanFrame.GetShiftForeman: string;
var
  ShiftEmp: variant;
begin                                    
  Result := 'Мастер смены';
  ShiftEmp := CurrentWorkload.ShiftForemanName;
  if not VarIsNull(ShiftEmp) then
    Result := Result + ': ' + ShiftEmp;
end;

function TPlanFrame.GetOperator: string;
var
  EqEmp: variant;
begin
  Result := 'Печатник';
  EqEmp := CurrentWorkload.OperatorName;
  if not VarIsNull(EqEmp) then
    Result := Result + ': ' + EqEmp;
end;

function TPlanFrame.GetAssistOperator: string;
var
  EqEmp: variant;
begin
  Result := 'Помошник';
  EqEmp := CurrentWorkload.AssistantName;
  if not VarIsNull(EqEmp) then
    Result := Result + ': ' + EqEmp;
end;

procedure TPlanFrame.SetShiftForemanFont(ACanvas: TCanvas);
begin
  ACanvas.Font.Size := 8;
  ACanvas.Font.Style := [fsUnderline];
end;

procedure TPlanFrame.SetShiftNameFont(ACanvas: TCanvas);
begin
  ACanvas.Font.Size := 9;
  ACanvas.Font.Style := [fsBold];
end;

procedure TPlanFrame.SetOperatorFont(ACanvas: TCanvas);
begin
  ACanvas.Font.Size := 9;
  ACanvas.Font.Style := [fsUnderline];
end;

procedure TPlanFrame.SetAssistantFont(ACanvas: TCanvas);
begin
  ACanvas.Font.Size := 9;
  ACanvas.Font.Style := [fsUnderline];
end;

function TPlanFrame.OverShiftForeman(Grid: TScheduleGrid; X: integer): boolean;
var
  EmployeeWidth, ShiftWidth: integer;
  ACanvas: TCanvas;
begin
  ACanvas := THackGrid(Grid).Canvas;
  SetShiftNameFont(ACanvas);
  ShiftWidth := ACanvas.TextWidth(NvlString(CurrentWorkload.Comment));
  SetShiftForemanFont(ACanvas);
  EmployeeWidth := ACanvas.TextWidth(GetShiftForeman());
  Dec(X, SHIFT_NAME_OFFSET * 2 + ShiftWidth - IndicatorWidth);
  Result := (X >= 0) and (X <= EmployeeWidth);
end;

function TPlanFrame.OverShiftForeman(Grid: TScheduleGrid; Cell: TGridCoord;
  X: integer): boolean;
var
  FOldActiveRecord: integer;
begin
  if THackGrid(Grid).DataLink.Active and (THackGrid(Grid).DataLink.RecordCount > 0) then
  begin
    FOldActiveRecord := THackGrid(Grid).DataLink.ActiveRecord;
    if (FOldActiveRecord >= 0) and (Cell.Y > 0) then
    begin
      THackGrid(Grid).DataLink.ActiveRecord := Cell.Y - 1;
      Result := OverShiftForeman(Grid, X);
      THackGrid(Grid).DataLink.ActiveRecord := FOldActiveRecord;
    end
    else
      Result := false;
  end
  else
    Result := false;
end;

function TPlanFrame.OverOperator(Grid: TScheduleGrid; X: integer): boolean;
var
  EmployeeWidth, SEmployeeWidth, ShiftWidth: integer;
  ACanvas: TCanvas;
begin
  ACanvas := THackGrid(Grid).Canvas;
  SetShiftNameFont(ACanvas);
  ShiftWidth := ACanvas.TextWidth(NvlString(CurrentWorkload.Comment));
  SetShiftForemanFont(ACanvas);
  SEmployeeWidth := ACanvas.TextWidth(MaxText);//GetShiftForeman());
  Dec(X, SHIFT_NAME_OFFSET * 3 + ShiftWidth + SEmployeeWidth - IndicatorWidth);
  SetOperatorFont(ACanvas);
  EmployeeWidth := ACanvas.TextWidth(GetOperator);
  Result := (X >= 0) and (X <= EmployeeWidth);
end;

function TPlanFrame.OverOperator(Grid: TScheduleGrid; Cell: TGridCoord;
  X: integer): boolean;
var
  FOldActiveRecord: integer;
begin
  if THackGrid(Grid).DataLink.Active and (THackGrid(Grid).DataLink.RecordCount > 0) then
  begin
    FOldActiveRecord := THackGrid(Grid).DataLink.ActiveRecord;
    if (FOldActiveRecord >= 0) and (Cell.Y > 0) then
    begin
      THackGrid(Grid).DataLink.ActiveRecord := Cell.Y - 1;
      Result := OverOperator(Grid, X);
      THackGrid(Grid).DataLink.ActiveRecord := FOldActiveRecord;
    end
    else
      Result := false;
  end
  else
    Result := false;
end;

function TPlanFrame.OverAssistant(Grid: TScheduleGrid; X: integer): boolean;
var
  AssistantWidth, SAssistantWidth, ShiftWidth: integer;
  ACanvas: TCanvas;
begin
  ACanvas := THackGrid(Grid).Canvas;
  SetShiftNameFont(ACanvas);
  ShiftWidth := ACanvas.TextWidth(NvlString(CurrentWorkload.Comment));
  SetShiftForemanFont(ACanvas);
  SAssistantWidth := ACanvas.TextWidth(MaxText);//GetShiftForeman());
  Dec(X, SHIFT_NAME_OFFSET * 4 + ShiftWidth + SAssistantWidth + SAssistantWidth - IndicatorWidth);
  SetAssistantFont(ACanvas);
  AssistantWidth := ACanvas.TextWidth(GetAssistOperator);
  Result := (X >= 0) and (X <= AssistantWidth);
end;

function TPlanFrame.OverAssistant(Grid: TScheduleGrid; Cell: TGridCoord;
  X: integer): boolean;
var
  FOldActiveRecord: integer;
begin
  if THackGrid(Grid).DataLink.Active and (THackGrid(Grid).DataLink.RecordCount > 0) then
  begin
    FOldActiveRecord := THackGrid(Grid).DataLink.ActiveRecord;
    if (FOldActiveRecord >= 0) and (Cell.Y > 0) then
    begin
      THackGrid(Grid).DataLink.ActiveRecord := Cell.Y - 1;
      Result := OverAssistant(Grid, X);
      THackGrid(Grid).DataLink.ActiveRecord := FOldActiveRecord;
    end
    else
      Result := false;
  end
  else
    Result := false;
end;

procedure TPlanFrame.btPauseClick(Sender: TObject);
begin
  FOnPauseJob(CurrentWorkload);
end;

procedure TPlanFrame.Default_DayCreateGridColumns(dg: TDBGridEh);
var
  c: TColumnEh;
begin
  dg.UseMultiTitle := true;

  if EntSettings.PlanShowExecState then
  begin
    c := dg.Columns.Add;
    c.FieldName := 'ExecState';
    c.Alignment := taCenter;
    c.Width := 16;
    c.MinWidth := 16;
    c.MaxWidth := 16;
    c.Title.Caption := ' ';
    c.ReadOnly := true;
    c.ImageList := imSrvState;
    c.NotInKeyListIndex := 0;
    c.DblClickNextval := false;
    c.KeyList.Assign(FStateCodeList);
    c.PickList.Assign(FStateTextList);
  end;

  if EntSettings.PlanShowOrderState then
  begin
    c := dg.Columns.Add;
    c.FieldName := TOrder.F_OrderState;
    c.Alignment := taCenter;
    c.Width := 16;
    c.MinWidth := 16;
    c.MaxWidth := 16;
    c.Title.Caption := ' ';
    c.ReadOnly := true;
    c.Title.TitleButton := true;
    c.ImageList := imOrderState;
    c.NotInKeyListIndex := -1;
    c.DblClickNextval := false;
    c.KeyList.Assign(FOrderStateCodeList);
    c.PickList.Assign(FOrderStateTextList);
  end;

  c := dg.Columns.Add;
  c.FieldName := TPlan.F_HasComment;
  c.Alignment := taCenter;
  c.Width := 18;
  c.MinWidth := 18;
  c.MaxWidth := 18;
  c.Title.Caption := 'i';
  c.ReadOnly := true;

  c := dg.Columns.Add;
  c.FieldName := TWorkload.F_AnyStart;
  c.Alignment := taCenter;
  c.Width := 70;
  c.Title.Caption := 'Начало';
  c.ButtonStyle := cbsNone;
  c.Font.Size := 10;

  c := dg.Columns.Add;
  c.FieldName := TWorkload.F_AnyFinish;
  c.Alignment := taCenter;
  c.Width := 70;
  c.Title.Caption := 'Заверш.';
  c.ButtonStyle := cbsNone;
  c.Font.Size := 10;

  c := dg.Columns.Add;
  c.FieldName := TWorkload.F_AnyDuration;
  c.Alignment := taRightJustify;//taCenter;
  c.Width := 60;
  c.Title.Caption := 'Длит.';
  c.Font.Size := 10;

  c := dg.Columns.Add;
  c.FieldName := TOrder.F_OrderNumber;
  c.Alignment := taRightJustify;
  c.Width := 53;
  c.Title.Caption := '№ заказа';
  c.Font.Style := [fsBold];
  {if Options.ScheduleShowCost then
  begin
    c.Footer.ValueType := fvtStaticText;
    c.Footer.Value := 'Всего:';
  end;}

  c := dg.Columns.Add;
  c.FieldName := 'CustomerName';
  c.Alignment := taLeftJustify;
  c.Width := 210;
  c.Title.Caption := 'Заказчик';
  //c.Title.TitleButton := true;

  c := dg.Columns.Add;
  c.FieldName := 'Comment';
  c.Alignment := taLeftJustify;
  c.Width := 200;
  c.Title.Caption := 'Наименование заказа';
  c.ReadOnly := true;
  //c.Title.TitleButton := true;

  c := dg.Columns.Add;
  c.FieldName := 'ItemDesc';
  c.Alignment := taLeftJustify;
  c.Width := 200;
  c.Title.Caption := 'Описание';
  c.ReadOnly := true;

  c := dg.Columns.Add;
  c.FieldName := TOrderProcessItems.F_ProductOut;
  c.Alignment := taRightJustify;
  c.Width := 53;
  c.Title.Caption := 'Кол-во';

  c := dg.Columns.Add;
  c.FieldName := F_PartName;
  c.Alignment := taLeftJustify;
  c.Width := 50;
  c.Title.Caption := 'Часть';
  c.ReadOnly := true;
  //c.Title.TitleButton := true;

  c := dg.Columns.Add;
  c.FieldName := 'FinishDate';
  c.Alignment := taLeftJustify;
  c.Width := 50;
  c.Title.Caption := 'Сдача заказа';
  c.ButtonStyle := cbsNone;
end;

procedure TPlanFrame.CreateCostColumn(dg: TDBGridEh);
var
  c: TColumnEh;
begin
  c := dg.Columns.Add;
  c.FieldName := TWorkload.F_JobCost;
  c.Alignment := taRightJustify;
  c.Width := 50;
  c.Title.Caption := 'Стоимость';
  c.ButtonStyle := cbsNone;
  //c.Footer.ValueType := fvtSum;
  //c.Footer.DisplayFormat := NumDisplayFmt;

  //dg.FooterRowCount := 1;
end;

procedure TPlanFrame.Default_NotPlannedCreateGridColumns(dg: TDBGridEh);
var
  c: TColumnEh;
begin
  dg.UseMultiTitle := true;

  c := dg.Columns.Add;
  c.FieldName := TOrder.F_OrderState;
  c.Alignment := taCenter;
  c.Width := 16;
  c.MinWidth := 16;
  c.MaxWidth := 16;
  c.Title.Caption := ' ';
  //c.PopupMenu := StatePopupMenu;
  c.ReadOnly := true;
  c.Title.TitleButton := true;
  c.ImageList := imOrderState;
  c.NotInKeyListIndex := -1;
  c.DblClickNextval := false;
  c.KeyList.Assign(FOrderStateCodeList);
  c.PickList.Assign(FOrderStateTextList);

  c := dg.Columns.Add;
  c.FieldName := TPlan.F_HasComment;
  c.Alignment := taCenter;
  c.Width := 18;
  c.MinWidth := 18;
  c.MaxWidth := 18;
  c.Title.Caption := 'i';
  c.ReadOnly := true;

  c := dg.Columns.Add;
  c.FieldName := TOrder.F_OrderNumber;
  c.Alignment := taRightJustify;
  c.Width := 53;
  c.Title.Caption := '№ заказа';
  //c.PopupMenu := StatePopupMenu;
  c.Title.TitleButton := true;
  c.Title.SortMarker := smDownEh;

  c := dg.Columns.Add;
  c.FieldName := 'CustomerName';
  c.Alignment := taLeftJustify;
  c.Width := 150;
  c.Title.Caption := 'Заказчик';
  c.Title.TitleButton := true;

  c := dg.Columns.Add;
  c.FieldName := 'Comment';
  c.Alignment := taLeftJustify;
  c.Width := 150;
  c.Title.Caption := 'Наименование заказа';
  c.ReadOnly := true;
  c.Title.TitleButton := true;
  //c.WordWrap := true;

  c := dg.Columns.Add;
  c.FieldName := 'ItemDesc';
  c.Alignment := taLeftJustify;
  c.Width := 150;
  c.Title.Caption := 'Описание';
  c.ReadOnly := true;
  c.Title.TitleButton := true;

  c := dg.Columns.Add;
  c.FieldName := F_PartName;
  c.Alignment := taLeftJustify;
  c.Width := 50;
  c.Title.Caption := 'Часть';
  c.ReadOnly := true;
  c.Title.TitleButton := true;

  c := dg.Columns.Add;
  c.FieldName := 'EquipName';
  c.Alignment := taLeftJustify;
  c.Width := 50;
  c.Title.Caption := 'Оборуд.';
  c.Title.TitleButton := true;

  c := dg.Columns.Add;
  c.FieldName := 'FinishDate';
  c.Alignment := taLeftJustify;
  c.Width := 50;
  c.Title.Caption := 'Плановая сдача';
  c.Title.TitleButton := true;

  {if Options.ScheduleShowCost then
  begin
    c := dg.Columns.Add;
    c.FieldName := 'Cost';
    c.Alignment := taRightJustify;
    c.Width := 50;
    c.Title.Caption := 'Стоимость';
    c.ButtonStyle := cbsNone;
  end;}
end;

procedure TPlanFrame.btDivideClick(Sender: TObject);
begin
  FOnDivideJob(CurrentWorkload);
end;

procedure TPlanFrame.btAddSpecialClick(Sender: TObject);
begin
  pmSpecJob.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

// заполняет комбобокс с типами диапазона
procedure TPlanFrame.BuildRangeTypeBox;
var
  ds: TDataSet;
  OldSelected: integer;
begin
  // сохраняем текущий выделенный тип
  OldSelected := cbDateType.ItemIndex;
  cbDateType.Items.Clear;
  cbDateType.Items.Add('День');
  cbDateType.Items.Add('Непрерывный');
  cbDateType.Items.Add('Неделя');
  cbDateType.Items.Add('Диаграмма');
  // Дальше добавляем смены.
  // Если для оборудования заданы смены, то для группы должно быть задано столько же смен,
  // возможно, с другим временем начала-окончания.
  ds := TConfigManager.Instance.StandardDics.deEquipGroupTime.DicItems;
  // Фильтруем справочник по коду группы
  ds.Filter := 'A1 = ' + IntToStr(PlanQueue.EquipGroupCode);
  ds.Filtered := true;
  try
    while not ds.eof do
    begin
      cbDateType.Items.Add(ds[F_DicItemName]);
      ds.Next;
    end;
    // восстанавливаем выделенный тип
    if OldSelected < cbDateType.Items.Count then
      cbDateType.ItemIndex := OldSelected;
    if cbDateType.ItemIndex = -1 then
      cbDateType.ItemIndex := 0;
  finally
    ds.Filtered := false;
  end;
end;

procedure TPlanFrame.BuildChangeEquipMenu;
var
  de: TDictionary;
  mi: TMenuItem;
begin
  miChangeEquip.Clear;
  // не нужно тем, кто не планирует
  if AccessManager.CurUser.ViewNotPlanned then
  begin
    de := TConfigManager.Instance.StandardDics.deEquip;
    de.DicItems.First;
    while not de.DicItems.Eof do
    begin
      if NvlBoolean(de.CurrentEnabled) and (de.CurrentValue[1] = PlanQueue.EquipGroupCode) then
      begin
        mi := TMenuItem.Create(Self);
        mi.Caption := de.CurrentName;
        mi.Tag := de.CurrentCode;
        mi.OnClick := ChangeEquipClick;
        miChangeEquip.Add(mi);
      end;
      de.DicItems.Next;
    end;
  end;
end;

procedure TPlanFrame.FillSpecialJobMenu(RootItem: TMenuItem);
var
  mi: TMenuItem;
  ds: TDataSet;
  de: TDictionary;
begin
  RootItem.Clear;
  de := TConfigManager.Instance.StandardDics.deSpecialJob;
  ds := de.DicItems;
  ds.First;
  while not ds.Eof do
  begin
    mi := TMenuItem.Create(Self);
    mi.Caption := de.CurrentName;
    mi.Tag := de.CurrentCode;
    mi.OnClick := SpecialJobClick;
    RootItem.Add(mi);
    TSettingsManager.Instance.XPActivateMenuItem(mi, true);
    ds.Next;
  end;
end;

procedure TPlanFrame.BuildSpecialJobMenu;
begin
  FillSpecialJobMenu(pmSpecJob.Items);
  FillSpecialJobMenu(miAddSpecialJob);
end;

procedure TPlanFrame.FillForemanMenu(RootItem: TMenuItem; ClickEvent: TNotifyEvent;
  EquipCode: integer);
var
  mi: TMenuItem;
  ds: TDataSet;
  OldFiltered: boolean;
  OldFilter: string;
  ShopCode, ProfCode: integer;
  de: TDictionary;
begin
  // определяем подразделение
  ShopCode := TConfigManager.Instance.StandardDics.deEquip.ItemValue[EquipCode, 4];
  RootItem.Clear;
  // берем всех сотрудников этого подразделения
  de := TConfigManager.Instance.StandardDics.deEmployees;
  ds := de.DicItems;
  OldFilter := ds.Filter;
  OldFiltered := ds.Filtered;
  ds.Filter := 'A5=' + IntToStr(ShopCode) + ' and Visible';
  ds.Filtered := true;
  try
    ds.First;
    while not ds.Eof do
    begin
      // проверяем, является ли сотрудник мастером цеха
      ProfCode := de.CurrentValue[4];
      if NvlBoolean(TConfigManager.Instance.StandardDics.deProfessions.ItemValue[ProfCode, 2]) then
      begin
        mi := TMenuItem.Create(Self);
        mi.Caption := de.CurrentName;
        mi.Tag := de.CurrentCode;
        mi.OnClick := ClickEvent;
        RootItem.Add(mi);
        TSettingsManager.Instance.XPActivateMenuItem(mi, true);
      end;
      ds.Next;
    end;
  finally
    ds.Filtered := OldFiltered;
    ds.Filter := OldFilter;
  end;

  mi := TMenuItem.Create(Self);
  mi.Caption := '<не указан>';
  mi.Tag := EMPLOYEE_NOT_SET;
  mi.OnClick := ClickEvent;
  RootItem.Add(mi);
  TSettingsManager.Instance.XPActivateMenuItem(mi, true);

end;

// В столбце А2 признак того что специальность является ответственным смены
procedure TPlanFrame.BuildForemanMenu;
begin
  if CurrentWorkload.Active then
    FillForemanMenu(pmForeman.Items, ForemanClick, CurrentWorkload.EquipCode);
end;

procedure TPlanFrame.FillOperatorsMenu(RootItem: TMenuItem; ClickEvent: TNotifyEvent;
  EquipCode: integer);
var
  mi: TMenuItem;
  ds: TDataSet;
  OldFiltered: boolean;
  OldFilter: string;
  de, deEmp: TDictionary;
  EmpCode: integer;
begin
  RootItem.Clear;

  de := TConfigManager.Instance.StandardDics.deOperators;
  deEmp := TConfigManager.Instance.StandardDics.deEmployees;
  ds := de.DicItems;
  OldFilter := ds.Filter;
  OldFiltered := ds.Filtered;
  ds.Filter := 'A2=' + IntToStr(EquipCode) + ' and Visible';
  ds.Filtered := true;
  try
    ds.First;
    while not ds.Eof do
    begin
      EmpCode := de.CurrentValue[1];
      // берем данные о сотруднике в таблице сотрудников
      if deEmp.ItemEnabled[EmpCode] then
      begin
        mi := TMenuItem.Create(Self);
        mi.Caption := deEmp.ItemName[EmpCode];
        mi.Tag := EmpCode;
        mi.OnClick := ClickEvent;
        RootItem.Add(mi);
        TSettingsManager.Instance.XPActivateMenuItem(mi, true);
      end;
      ds.Next;
    end;
  finally
    ds.Filtered := OldFiltered;
    ds.Filter := OldFilter;
  end;

  mi := TMenuItem.Create(Self);
  mi.Caption := '<не указан>';
  mi.Tag := EMPLOYEE_NOT_SET;
  mi.OnClick := ClickEvent;
  RootItem.Add(mi);
  TSettingsManager.Instance.XPActivateMenuItem(mi, true);
end;

procedure TPlanFrame.FillAssistantMenu(RootItem: TMenuItem; ClickEvent: TNotifyEvent;
  EquipCode: integer);
var
  mi: TMenuItem;
  ds: TDataSet;
  OldFiltered: boolean;
  OldFilter: string;
  de, deEmp: TDictionary;
  EmpCode: integer;
begin
  RootItem.Clear;

  de := TConfigManager.Instance.StandardDics.deOperators;
  deEmp := TConfigManager.Instance.StandardDics.deEmployees;
  ds := de.DicItems;
  OldFilter := ds.Filter;
  OldFiltered := ds.Filtered;
  ds.Filter := 'A2=' + IntToStr(EquipCode) + ' and Visible';
  ds.Filtered := true;
  try
    ds.First;
    while not ds.Eof do
    begin
      EmpCode := de.CurrentValue[1];
      // берем данные о сотруднике в таблице сотрудников
      if deEmp.ItemEnabled[EmpCode] then
      begin
        mi := TMenuItem.Create(Self);
        mi.Caption := deEmp.ItemName[EmpCode];
        mi.Tag := EmpCode;
        mi.OnClick := ClickEvent;
        RootItem.Add(mi);
        TSettingsManager.Instance.XPActivateMenuItem(mi, true);
      end;
      ds.Next;
    end;
  finally
    ds.Filtered := OldFiltered;
    ds.Filter := OldFilter;
  end;

  mi := TMenuItem.Create(Self);
  mi.Caption := '<не указан>';
  mi.Tag := EMPLOYEE_NOT_SET;
  mi.OnClick := ClickEvent;
  RootItem.Add(mi);
  TSettingsManager.Instance.XPActivateMenuItem(mi, true);
end;

procedure TPlanFrame.BuildOperatorsMenu;
begin
  if CurrentWorkload.Active then
    FillOperatorsMenu(pmOperators.Items, OperatorClick, CurrentWorkload.EquipCode);
end;

procedure TPlanFrame.BuildAssistantMenu;
begin
  if CurrentWorkload.Active then
    FillAssistantMenu(pmAssistant.Items, AssistantClick, CurrentWorkload.EquipCode);
end;


procedure TPlanFrame.ChangeEquipClick(Sender: TObject);
begin
  FOnChangeEquip((Sender as TMenuItem).Tag);
end;

procedure TPlanFrame.TimeLineBlockSelected(Sender: TObject);
begin
  if Assigned(FOnTimeLineBlockSelected) then
    FOnTimeLineBlockSelected(Self);
end;

function TPlanFrame.GetTimeLineSelectedBlock: TTimeBlock;
begin
  Result := FTimeLine.SelectedBlock;
end;

procedure TPlanFrame.CreateTimeLine;
begin
  ShowTimeLine;
  FTimeLine := TSingleTimeLine.Create(Self);
  FTimeLine.Parent := paDayControls;
  FTimeLine.Left := cbDateType.Left;
  FTimeLine.Top := cbDateType.Top + cbDateType.Height + 6;
  FTimeLine.Height := paDayControls.Height - FTimeLine.Top - 2;
  FTimeLine.Width := paDayControls.Width - FTimeLine.Left * 2;
  FTimeLine.Anchors := [akLeft, akTop, akRight];
  FTimeLine.BalloonHint := JvBalloonHint1;
  FTimeLine.OnBlockSelected := TimeLineBlockSelected;
end;

procedure TPlanFrame.ShowTimeLine;
begin
  FSavedDayControlsHeight := paDayControls.Height;
  paDayControls.Height := paDayControls.Height + SINGLE_TL_HEIGHT;
end;

procedure TPlanFrame.HideTimeLine;
begin
  if FSavedDayControlsHeight > 0 then
    paDayControls.Height := FSavedDayControlsHeight;
end;

{procedure PauseHintWindow(_Frame: TObject);
begin
  Sleep(2000);
  EnterMainThread;
  try
    TPlanFrame(_Frame).CloseHintWindow;
  finally
    LeaveMainThread;
  end;
end;}

procedure TPlanFrame.CloseHintWindow;
begin
  //if not FReuseHintWindow then
  //begin
    FreeAndNil(FHint);
    //FReuseHintWindow := false;
  //end;
end;

procedure TPlanFrame.ShowHint(HintRect: TRect; HintText: string);
begin
  if FHint <> nil then
  begin
    CloseHintWindow;
    //FReuseHintWindow := true;
  end;
  FHint := TMyHintWindow.Create(nil);
  FHint.HintStyle := hsVista;
  FHint.ActivateHint(HintRect, HintText);
  {HintAsync := AsyncCall(@PauseHintWindow, Self);
  HintAsync.ForceDifferentThread;}
end;

procedure TPlanFrame.dgWorkloadCellClick(Column: TColumnEh);
var
  CellRect, GridRect: TRect;
  Grid: TScheduleGrid;
  //Cell: TGridCoord;
  cx, cy: integer;
  ClientMouse: TPoint;
  HintText: string;
begin
  CloseHintWindow;
  Grid := CurrentWorkloadGrid;
  if CurrentWorkload.IsShiftMarker then
  begin
    cx := Mouse.CursorPos.X;
    cy := Mouse.CursorPos.Y;
    //Cell := Grid.MouseCoord(cx, cy);
    ClientMouse := Grid.ScreenToClient(Mouse.CursorPos);
    if OverShiftForeman(Grid, ClientMouse.X) then
      pmForeman.Popup(cx, cy)
    else if OverOperator(Grid, ClientMouse.X) then
      pmOperators.Popup(cx, cy)
    else if OverAssistant(Grid, ClientMouse.X) then
      pmAssistant.Popup(cx, cy);
  end
  else
  if (Column.Field <> nil) and (Column.Field.FieldName = TPlan.F_HasComment) then
  begin
    if CurrentWorkload.HasComment then
    begin
      // показать примечание
      // как то хитро определяется позиция хинта, это не надо убирать
      GridRect := CurrentWorkloadGrid.CellRect(CurrentWorkloadGrid.Col, CurrentWorkloadGrid.Row);
      CellRect.Left := Mouse.CursorPos.X;
      CellRect.Top := Mouse.CursorPos.Y;
      CellRect.Right := CellRect.Left + (GridRect.Right - GridRect.Left) div 2;
      CellRect.Bottom := CellRect.Top + (GridRect.Bottom - GridRect.Top) div 2;
      ShowHint(CellRect, NvlString(CurrentWorkload.JobComment));
      // как то хитро определяется позиция хинта, это не надо убирать
      {GridRect := CurrentWorkloadGrid.CellRect(CurrentWorkloadGrid.Col, CurrentWorkloadGrid.Row);
      CellRect.Left := Mouse.CursorPos.X;
      CellRect.Top := Mouse.CursorPos.Y;
      CellRect.Right := CellRect.Left + (GridRect.Right - GridRect.Left) div 2;
      CellRect.Bottom := CellRect.Top + (GridRect.Bottom - GridRect.Top) div 2;
      JvBalloonHint1.ActivateHintRect(CellRect,
        NvlString(CurrentWorkload.JobComment), '', 2000);}
    end
    else
      pmWorkload.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
  end
  else
  if (Column.Tag = CellTag_HasHintText) then
  begin
    // хинт находится в поле с добавочкой Text
    HintText := NvlString(Column.Field.DataSet[Column.Field.FieldName + 'Text']);
    if HintText <> '' then
    begin
      // показать примечание
      // как то хитро определяется позиция хинта, это не надо убирать
      GridRect := CurrentWorkloadGrid.CellRect(CurrentWorkloadGrid.Col, CurrentWorkloadGrid.Row);
      CellRect.Left := Mouse.CursorPos.X;
      CellRect.Top := Mouse.CursorPos.Y;
      CellRect.Right := CellRect.Left + (GridRect.Right - GridRect.Left) div 2;
      CellRect.Bottom := CellRect.Top + (GridRect.Bottom - GridRect.Top) div 2;
      ShowHint(CellRect, HintText);
    end;
  end;
end;

function TPlanFrame.GetCurrentWorkload: TWorkload;
begin
  if (FWorkloads <> nil) and (pcJobEquip.ActivePageIndex <> -1) then
    Result := FWorkloads[pcJobEquip.ActivePageIndex]
  else
    Result := nil;
end;

function TPlanFrame.GetCurrentWorkloadIndex: integer;
begin
  Result := pcJobEquip.ActivePageIndex;
end;

function TPlanFrame.GetCurrentWorkloadGrid: TScheduleGrid;
begin
  Result := TScheduleGrid(FWorkloadGrids[pcJobEquip.ActivePageIndex]);
end;

procedure TPlanFrame.HandleProcessCfgChanged(Sender: TObject);
begin
  ProcessConfiguration;
end;

// Строит элементы интерфейса в соответствии с текущей конфигурацией
procedure TPlanFrame.ProcessConfiguration;
begin
  BuildSpecialJobMenu;
  //BuildForemanMenu;
  //BuildEquipmentEmployeeMenu;
  BuildChangeEquipMenu;

  TSettingsManager.Instance.XPActivateMenuItem(pmSpecJob.Items, true);
  TSettingsManager.Instance.XPActivateMenuItem(pmWorkload.Items, true);

  BuildRangeTypeBox;
  
  paLowToolbar.Visible := false;//not EntSettings.NewPlanInterface;
end;

procedure TPlanFrame.SpecialJobClick(Sender: TObject);
begin
  // передаем код спец работы
  FOnAddSpecialJob((Sender as TMenuItem).Tag);
  UpdateTimeLine;
end;

procedure TPlanFrame.ForemanClick(Sender: TObject);
var
  t: variant;
begin
  t := (Sender as TMenuItem).Tag;
  if t = EMPLOYEE_NOT_SET then
    t := null;
  // передаем код сотрудника для смены (мастера)
  FOnAssignShiftForeman(t);
  CurrentWorkloadGrid.Refresh;
end;

procedure TPlanFrame.OperatorClick(Sender: TObject);
var
  t: variant;
begin
  t := (Sender as TMenuItem).Tag;
  if t = EMPLOYEE_NOT_SET then
    t := null;
  // передаем код сотрудника для оборудования (оператора)
  FOnAssignOperator(t);
  CurrentWorkloadGrid.Refresh;
end;

procedure TPlanFrame.AssistantClick(Sender: TObject);
var
  t: variant;
begin
  t := (Sender as TMenuItem).Tag;
  if t = EMPLOYEE_NOT_SET then
    t := null;
  // передаем код помошника для оборудования (оператора)
  FOnAssignAssistant(t);
  CurrentWorkloadGrid.Refresh;
end;

procedure TPlanFrame.spJobDayMaximize(Sender: TObject);
begin
  //UpdateNotPlannedControls;
end;

procedure TPlanFrame.miEditCommentClick(Sender: TObject);
begin
  FOnEditJobComment(CurrentWorkload);
end;

procedure TPlanFrame.miEditFilesClick(Sender: TObject);
begin
  FOnEditFiles(CurrentWorkload);
end;

procedure TPlanFrame.miEditJobClick(Sender: TObject);
begin
  EditJob;
end;

procedure TPlanFrame.miEditOrderStateClick(Sender: TObject);
begin
  FOnEditOrderState(CurrentWorkload);
end;

procedure TPlanFrame.miNotPlannedEditCommentClick(Sender: TObject);
begin
  FOnEditNotPlannedJobComment(Self);
end;

procedure TPlanFrame.miWorkloadOpenOrderClick(Sender: TObject);
begin
  if TForm(Owner).ActiveControl = dgNoPlan then
    FOnOpenOrder(PlanQueue)
  else
    FOnOpenOrder(CurrentWorkload);
end;

procedure TPlanFrame.miTimeLockedClick(Sender: TObject);
begin
  FOnTimeLock(CurrentWorkload);
end;

procedure TPlanFrame.miViewNotPlannedJobClick(Sender: TObject);
begin
  FOnViewNotPlannedJob(Self);
end;

procedure TPlanFrame.UpdateTimeLine;
begin
  if not FBeforeOpenDataRunning then
    UpdateTimeLine(true);
end;

function TPlanFrame.GetCurrentShift: TShiftInfo;
var
  I: Integer;
  Shifts: TList;
  w: TWorkload;
  CurStart: TDateTime;
  si, NextSI: TShiftInfo;
begin
  w := CurrentWorkload;
  Shifts := w.ShiftList;
  CurStart := w.AnyStartDateTime;
  Result := nil;
  if Shifts <> nil then
    for I := 0 to Shifts.Count - 1 do
    begin
      SI := TShiftInfo(Shifts[i]);
      if i < Shifts.Count - 1 then
        NextSI := TShiftInfo(Shifts[i + 1])
      else
        NextSI := nil;
      if (CurStart >= SI.Start) and ((NextSI = nil) or (CurStart < NextSI.Start)) then
      begin
        Result := SI;
        break;
      end;
    end;
end;

// описание работы для хинта во временной линейке.
function GetJobHint(Job: TJobParams): string;
begin
  if Job.JobType = 0 then
    Result := Job.ItemDesc + #13'Заказ: ' + Job.OrderNumber
        + ' (' + VarToStr(Job.Comment) + ')' + #13'Заказчик: ''' + Job.CustomerName + ''''
  else
  begin
    Result := Result + Job.Comment;
    if NvlString(Job.JobComment) <> '' then
      Result := Result + #13 + Job.JobComment;
  end;
end;

procedure FillTimeBlocks(TimeBlocks: TList; JobList: TJobList);
var
  b: TTimeBlock;
  Job: TJobParams;
  Clr: TColor;
  SJobColors: array of TColor;
  SJobOrders: array of TJobParams;
  JobOrdersCount: integer;
  i: Integer;                       

  function GetJobColor(Job: TJobParams; var Clr: TColor): boolean;
  var
    J: integer;
  begin
    Result := false;
    for J := Low(SJobOrders) to High(SJobOrders) do
      if SJobOrders[J].ItemID = Job.ItemID then
      begin
        Clr := SJobColors[J];
        Result := true;
        break;
      end;
  end;

begin
  // Раскрашиваем разные работы в разные цвета
  SetLength(SJobOrders, 0);
  JobOrdersCount := 0;
  SetLength(SJobColors, 0);
  for i := 0 to JobList.Count - 1 do
  begin
    Job := TJobParams(JobList[I]);
    if not GetJobColor(Job, Clr) then
    begin
      Inc(JobOrdersCount);
      SetLength(SJobOrders, JobOrdersCount);
      SetLength(SJobColors, JobOrdersCount);
      SJobOrders[JobOrdersCount - 1] := Job;
      SJobColors[JobOrdersCount - 1] := TColor(JobColors.Items[JobOrdersCount mod JobColors.Count]);
    end;
  end;

  for i := 0 to JobList.Count - 1 do
  begin
    Job := TJobParams(JobList[I]);
    b := TTimeBlock.Create;
    b.JobID := Job.JobID;
    b.Start := Job.AnyStart;
    b.Finish := Job.AnyFinish;
    b.Comment := GetJobHint(Job);
    b.ShowAlert := Job.JobAlert;
    if Job.JobType >= JobType_Special then
      // Специальные работы раскрашиваем согласно справочнику
      b.Color := GetSpecialJobBkColor(Job.JobType)
    else
    begin
      if GetJobColor(Job, Clr) then
        b.Color := Clr//TColor(JobColors.Items[i mod JobColors.Count]);
      else
        ExceptionHandler.Raise_('UpdateShiftTimeLine: Внутренняя ошибка');
    end;
    {if Job.JobID = CurJobID then  // отмечаем текущую выбранную работу
      b.Selected := true;}
    TimeBlocks.Add(b);
  end;
end;

// Обновляем диаграмму работ для смены
procedure TPlanFrame.UpdateShiftTimeLine(_TimeLine: TSingleTimeLine; w: TWorkload; FullRebuild: boolean);
var
  TimeBlocks: TList;
  CurShift: TShiftInfo;
begin
  if _TimeLine = nil then Exit;

  TimeBlocks := TList.Create;

  w.Open;

  if not w.IsEmpty then
  begin
    // Находим, к какой смене относится текущая работа
    CurShift := GetCurrentShift;
    if CurShift = nil then
    begin
      TimeBlocks.Free;
      Exit;
    end;

    if not FullRebuild then
    begin
      // Проверяем, если уже строили по этой смене то не надо
      if (FLastTimeLineWorkload = w) and (FLastTimeLineShift = CurShift.Start) then
      begin
        TimeBlocks.Free;
        Exit;
      end;
    end;
    FLastTimeLineWorkload := w;
    FLastTimeLineShift := CurShift.Start;

    if CurShift.JobList <> nil then  // такое может быть при сбоях в скриптах например
    begin
      FillTimeBlocks(TimeBlocks, CurShift.JobList);
      if EntSettings.RedScheduleSpace and (TimeBlocks.Count > 0) then
        FTimeLine.EmptyColor := clRed
      else
        FTimeLine.EmptyColor := clWhite;
    end;
  end;

  if not w.IsEmpty then
  begin
    _TimeLine.StartTime := CurShift.Start;
    _TimeLine.FinishTime := CurShift.Finish;
  end
  else
  begin
    _TimeLine.StartTime := w.RangeStart;
    _TimeLine.FinishTime := w.RangeEnd;
  end;
  _TimeLine.TimeBlocks := TimeBlocks;
  _TimeLine.Refresh;
end;

// Обновляем диаграмму работ
procedure TPlanFrame.UpdateTimeLine(FullRebuild: boolean);
begin
  if (DateCriteriaType = PlanRange_Continuous) or (DateCriteriaType = PlanRange_Week) then
    UpdateShiftTimeLine(FTimeLine, CurrentWorkload, FullRebuild)
  else if DateCriteriaType = PlanRange_Gantt then
    UpdateGanttTimeLines
  else
    UpdateRangeTimeLine(FTimeLine, CurrentWorkload, FullRebuild);
end;

procedure TPlanFrame.UpdateRangeTimeLine(_TimeLine: TSingleTimeLine; w: TWorkload;
  FullRebuild: boolean);
var
  TimeBlocks: TList;
  //k: variant;
  //b: TTimeBlock;
  //i: Integer;
  //CurShift: TDateTime;
  //Job: TJobParams;
begin
  if _TimeLine = nil then Exit;

  TimeBlocks := TList.Create;
  FillTimeBlocks(TimeBlocks, w.JobList);
  {for i := 0 to w.JobList.Count - 1 do
  begin
    Job := w.JobList[I];
    b := TTimeBlock.Create;
    b.JobID := Job.JobID;
    b.Start := Job.AnyStart;
    b.Finish := Job.AnyFinish;
    b.Comment := GetJobHint(Job);
    b.ShowAlert := Job.JobAlert;
    if Job.JobType > 0 then
      b.Color := clSkyBlue
    else
      b.Color := TColor(JobColors.Items[i mod JobColors.Count]);
    TimeBlocks.Add(b);
  end;}
  _TimeLine.StartTime := w.RangeStart;
  _TimeLine.FinishTime := w.RangeEnd;
  _TimeLine.TimeBlocks := TimeBlocks;
  _TimeLine.Refresh;
end;

procedure TPlanFrame.pmForemanPopup(Sender: TObject);
begin
  BuildForemanMenu;
end;

procedure TPlanFrame.pmOperatorsPopup(Sender: TObject);
begin
  BuildOperatorsMenu;
end;

procedure TPlanFrame.pmAssistantPopup(Sender: TObject);
begin
  BuildAssistantMenu;
end;


procedure TPlanFrame.pmWorkloadPopup(Sender: TObject);
var
  I: Integer;
  w: TWorkload;
  mi: TMenuItem;
  Started, IsShiftMarker, IsWork, plan: boolean;
  KPRec: TKindProcPerm;
begin
  w := CurrentWorkload;
  if not w.DataSet.IsEmpty then
  begin
    IsShiftMarker := w.IsShiftMarker;
    miEditComment.Enabled := not IsShiftMarker;
    miEditFiles.Enabled := not IsShiftMarker;
    IsWork := not IsShiftMarker and (w.CurrentJob.JobType = JobType_Work);
    miEditOrderState.Enabled := IsWork;
    miWorkloadOpenOrder.Enabled := IsWork;
    Started := not VarIsNull(w.FactStartDateTime) or not VarIsNull(w.FactFinishDateTime);

    if IsWork then
    begin
      AccessManager.ReadUserKindProcPermTo(KPRec, CurrentWorkload.KindID, AccessManager.CurUser.ID, CurrentWorkload.ProcessID);
      // Если план заблокирован или нет прав на планирование и фактич. отметки, то выходим
      plan := KPRec.PlanDate and KPRec.FactDate;
    end else
      plan := true;

    // если специальная работа или есть фактические отметки,
    // убираем из меню замену вида оборудования
    if not IsWork or Started then
      miChangeEquip.Visible := false
    else
    begin
      miChangeEquip.Visible := true;
      miChangeEquip.Enabled := AccessManager.CurUser.ViewNotPlanned and plan;
      // прячем пункт меню соотв. текущему оборудованию
      for I := 0 to miChangeEquip.Count - 1 do
      begin
        mi := miChangeEquip.Items[i] as TMenuItem;
        mi.Visible := mi.Tag <> w.EquipCode;
      end;
    end;
    miTimeLocked.Enabled := not IsShiftMarker and plan;
    miTimeLocked.Checked := w.TimeLocked;

    miDivideJob.Enabled := AccessManager.CurUser.ViewNotPlanned
      and IsWork and btDivide.Enabled and plan;
    miPauseJob.Caption := btPause.Caption;
    miPauseJob.Enabled := not IsShiftMarker and btPause.Enabled and plan;
    miExportExcel.Enabled := btExportExcel.Enabled;
    miEditJob.Enabled := not IsShiftMarker and btEditJob.Enabled and plan;
  end
  else
  begin
    miChangeEquip.Visible := false;
    miEditComment.Enabled := false;
    miEditFiles.Enabled := false;
    miEditOrderState.Enabled := false;
    miTimeLocked.Enabled := false;
    miDivideJob.Enabled := false;
    miPauseJob.Enabled := false;
    miExportExcel.Enabled := false;
    miEditJob.Enabled := false;
  end;
end;

procedure TPlanFrame.SetCurrentWorkload(const Value: TWorkload);
begin
  ActivateWorkload(Value.EquipCode);
end;

function TPlanFrame.ActivateWorkload(_EquipCode: integer): boolean;
var
  I: Integer;
  AllowChange: boolean;
  w: TWorkload;
begin
  Result := false;
  for I := 0 to FWorkloads.Count - 1 do
  begin
    w := TWorkload(FWorkloads[i]);
    if w.EquipCode = _EquipCode then
    begin
      pcJobEquipChanging(nil, AllowChange);
      pcJobEquip.ActivePageIndex := i;
      pcJobEquipChange(nil);
      if DateCriteriaType <> PlanRange_Gantt then
        CurrentWorkloadGrid.SetFocus;
      Result := true;
      break;
    end;
  end;
end;

procedure TPlanFrame.Activate;
begin
  TMainActions.GetAction(TScheduleActions.Add).OnExecute := btAddClick;
  TMainActions.GetAction(TScheduleActions.Remove).OnExecute := btRemoveClick;
  TMainActions.GetAction(TScheduleActions.Print).OnExecute := btExportExcelClick;
  TMainActions.GetAction(TScheduleActions.Split).OnExecute := btDivideClick;
  TMainActions.GetAction(TScheduleActions.OpenOrder).OnExecute := miWorkloadOpenOrderClick;
  TMainActions.GetAction(TScheduleActions.EditComment).OnExecute := miEditCommentClick;
  TMainActions.GetAction(TScheduleActions.Undo).OnExecute := btUndoClick;
  TMainActions.GetAction(TScheduleActions.Lock).OnExecute := btLockClick;
  TMainActions.GetAction(TScheduleActions.Unlock).OnExecute := btUnlockClick;

  if not FWasActivate then
  begin
    if not AccessManager.CurUser.ViewNotPlanned then
      HideNotPlanned
    else
      if EntSettings.NewPlanInterface then
        RollUpNotPlanned   // свернуть очередь заказов
      else
        RollOutNotPlanned;  // развернуть очередь заказов

    OpenData;

    if DateCriteriaType = PlanRange_Gantt then
      ShowGantt;

    UpdateLockState;

    FWasActivate := true;
  end;
end;

procedure TPlanFrame.SettingsChanged;
begin
  UpdateFontSize;
end;

procedure SetGridFontSize(g: TGridClass);
var
  J: integer;
  c: TColumnEh;
begin
  g.Font.Size := Options.ScheduleFontSize;
  g.Font.Name := Options.ScheduleFontName;
  for J := 0 to g.Columns.Count - 1 do
  begin
    c := g.Columns[J];
    if (c.Font.Size <> Options.ScheduleFontSize) or (c.Font.Name <> Options.ScheduleFontName) then
    begin
      c.Font.Size := Options.ScheduleFontSize + (c.Font.Size - g.Font.Size);
      g.Font.Name := Options.ScheduleFontName;
    end;
    if c.Footer.ValueType <> fvtNon then
      if (c.Footer.Font.Size <> Options.ScheduleFontSize) or (c.Footer.Font.Name <> Options.ScheduleFontName) then
      begin
        c.Footer.Font.Size := Options.ScheduleFontSize;
        c.Footer.Font.Name := Options.ScheduleFontName;
      end;
  end;
  g.FooterFont.Size := Options.ScheduleFontSize;
  g.FooterFont.Name := Options.ScheduleFontName;
end;

procedure TPlanFrame.UpdateFontSize;
var
  I: Integer;
  g: TGridClass;
begin
  SetGridFontSize(dgNoPlan);

  if FWorkloadGrids <> nil then
    for I := 0 to FWorkloadGrids.Count - 1 do
    begin
      g := TGridClass(FWorkloadGrids[i]);
      SetGridFontSize(g);
    end;
end;

procedure TPlanFrame.ShowWarning(_EquipCode: integer; MessageText: string);
var
  I: Integer;
begin
  if Length(FErrorMessages) < pcJobEquip.PageCount then
    SetLength(FErrorMessages, pcJobEquip.PageCount);
  for I := 0 to FWorkloads.Count - 1 do
  begin
    if TWorkload(FWorkloads[I]).EquipCode = _EquipCode then
    begin
      FErrorMessages[I] := MessageText;
      UpdateErrorMessages;
      break;
    end;
  end;
end;

procedure TPlanFrame.UpdateErrorMessages;
begin
  if Length(FErrorMessages) > pcJobEquip.ActivePageIndex then
  begin
    if FErrorMessages[pcJobEquip.ActivePageIndex] <> '' then
    begin
      paErrorMessage.Caption := FErrorMessages[pcJobEquip.ActivePageIndex];
      paErrorMessage.Visible := true;
    end
    else
      paErrorMessage.Visible := false;
  end
  else
    paErrorMessage.Visible := false;
end;

procedure TPlanFrame.HideWarnings(_EquipCode: integer);
begin
  ShowWarning(_EquipCode, '');
end;

function TPlanFrame.PlanQueue: TPlan;
begin
  Result := Entity as TPlan;
end;

function TPlanFrame.GetColumnTag(Grid: TGridClass; FieldName: string): integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Grid.Columns.Count - 1 do
    if Grid.Columns[I].FieldName = FieldName then
    begin
      Result := Grid.Columns[I].Tag;
      break;
    end;
end;

{$REGION 'THackGrid'}

function THackGrid.GetDBGridEhState: TDBGridEhState;
begin
  Result := FDBGridEhState;
end;

function THackGrid.GetGridState: TGridState;
begin
  Result := FGridState;
end;

{$ENDREGION}

initialization

JobColors := TList.Create;
JobColors.Add(TObject(RGB(210, 210, 210)));
JobColors.Add(TObject(RGB(255, 187, 187)));
JobColors.Add(TObject(RGB(255, 255, 195)));
JobColors.Add(TObject(RGB(187, 255, 187)));
JobColors.Add(TObject(RGB(185, 255, 255)));
JobColors.Add(TObject(RGB(187, 221, 255)));
JobColors.Add(TObject(RGB(203, 203, 228)));
JobColors.Add(TObject(RGB(255, 196, 225)));
JobColors.Add(TObject(RGB(255, 204, 255)));
JobColors.Add(TObject(RGB(255, 191, 191)));
JobColors.Add(TObject(RGB(255, 219, 183)));
JobColors.Add(TObject(RGB(226, 197, 192)));
JobColors.Add(TObject(RGB(198, 255, 239)));
JobColors.Add(TObject(RGB(255, 0, 0)));

finalization

JobColors.Free;

end.



