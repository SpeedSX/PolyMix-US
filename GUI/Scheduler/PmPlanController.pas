unit PmPlanController;

interface

uses Classes, Forms, DB, SysUtils, //ADODB,
   JvAppStorage, JvJCLUtils, Variants, Controls, TLoggerUnit, JvSpeedBar, Math,
   ExtCtrls,

   PmEntity, PmPlan, PmEntityController, DicObj, PmProviders, PmProcessCfg, fPlanFrame,
   BaseRpt, PmScriptManager, PmJobParams, StrUtils, fBaseFrame,
   PmScheduleAdapter, PmShiftEmployees, fScheduleToolbar, CalcUtils,
   PmCachedScheduleAdapter;

type
  TPlanController = class(TEntityController)
  private
    //dePrinter, deStates: TDictionary;
    EquipCount: integer;
    fnStartDate, fnFinishDate, fnFinishOrderDate: string;
    //fnPlanStartDate, fnPlanFinishDate, fnFactStartDate, fnFactFinishDate: string;
    FWorkloads: TList;
    FAdapters: TList;
    FNeedRefresh: boolean;
    //FAdapter: TScheduleAdapter;
    FShiftEmployees: TShiftEmployees;
    FShiftAssistants: TShiftAssistants;
    FToolbarFrame: TScheduleToolbar;
    {procedure AddPlanJob(w: TWorkload; ItemId: integer; StartTime, FinishTime: TDateTime;
        FactStartTime: variant; EquipCode: integer; Executor, JobComment: variant;
        JobAlert: boolean);}
    FEditLockTimer: TTimer;
    procedure HandleAddSpecialJob(JobCode: integer);
    function GetPlan: TPlan;
    procedure ScriptError(_Process: TPolyProcessCfg; _ScriptFieldName: string;
       _ErrPos: integer; _Msg: string);
    // передается ключ записи на которую перетащили работу
    function AddToPlan(WorkloadRowKey: integer): Boolean;
    procedure RemoveFromPlan(Sender: TObject);
    procedure MoveJobUp(Sender: TObject);

    procedure MoveJobDown(Sender: TObject);
    procedure MoveJobFirst(Sender: TObject);
    procedure MoveJobLast(Sender: TObject);
    procedure MouseMoveJob(SourceJobID, TargetJobID: integer);
    //function FindStartTime(cdDay: TDataSet; var StartTime: TDateTime): boolean;

    procedure CreateWorkloads;
    function EditPlanJob: boolean;
    procedure SetExecutor(w: TWorkload; Job: TJobParams);
    function GetPlanFrame: TPlanFrame;
    procedure LaunchReport(Sender: TObject);
    procedure DoOpenOrder(Sender: TObject);
    procedure DoLocateOrder(OrderNum: integer);
    procedure PauseJob(Sender: TObject);

    // Проверяет, есть ли пересечения в плане с текущей работой,
    // если есть, предлагает исправить и сдвигает текущую работу либо работу в плане.
    // Если CurItemID = 0, то нельзя разбивать
    function CheckMovingJob(CurItemID: integer; Job: TJobParams): boolean;
    function SplitJobAroundUnmovable(w: TWorkload; Job: TJobParams; UnmovableJob: TJobParams): boolean;
    procedure PlaceJobs(w: TWorkload; Jobs: TJobList);
    // В режиме непрерывного отображения делит работы, попадающие на границы смен,
    // и объединяет работы, которые были раньше разбиты границей смены, а теперь нет.
    // Возвращает true, если были изменения и план перезагружен
    function CheckShifts: boolean;
    procedure UpdateOverlaps(w: TWorkload);
    function CheckShiftOverlap(w: TWorkload; Job: TJobParams): boolean;
    // Определяет есть ли пересечения со сменами, и возвращает дату начала смены
    function IntersectShift(w: TWorkload; Job: TJobParams; var ShiftStart: TDateTime): boolean;
    procedure DivideJob(Sender: TObject);
    // Возвращает время, где есть свободное место без учета длительности работы.
    // В режиме просмотра дня или смены может вернуть false, если работу разместить не удалось.
    function FindAvailableStart(w: TWorkload; var StartTime: TDateTime; FromCurrent: boolean): boolean;
    function EditSpecialJob: boolean;
    function GetPrevFinishTime(w: TWorkload; Job: TJobParams): TDateTime;
    function HandleAddToPlan(WorkloadRowKey: integer): boolean;
    procedure HandleChangeEquip(NewEquipCode: integer);
    function HandleEditJob(Sender: TObject): boolean;
    procedure HandleUndo(Sender: TObject);
    function GetUndoEnabled(Sender: TObject): boolean;
    procedure HandleLock(Sender: TObject);
    procedure HandleUnlock(Sender: TObject);
    procedure HandleEditJobComment(Sender: TObject);
    procedure HandleEditOrderState(Sender: TObject);
    procedure HandleEditFiles(Sender: TObject);
    procedure HandleTimeLock(Sender: TObject);
    // Сдвинуть работы вверх. IncludeJob означает, что сдвиг включает указанную работу.
    procedure MoveJobsUp(w: TWorkload; StartTime: TDateTime; JobID: integer; IncludeJob: boolean);
    function SameDay(DayStart, Date1, Date2: TDateTime): Boolean;
    //procedure RemoveJob(w: TWorkload);
    procedure HandleUpdateCriteria(Sender: TObject);
    procedure HandleUpdateWorkloadCriteria(Sender: TObject);
    procedure HandleAssignShiftEmployee(EmployeeCode: variant);
    procedure HandleAssignShiftAssistant(EmployeeCode: variant);
    procedure HandleAssignEquipmentEmployee(EmployeeCode: variant);
    procedure HandleAssignEquipmentAssistant(EmployeeCode: variant);
    // становится на последнюю работу в плане
    function LocateLastPlannedJob(w: TWorkload): boolean;
    function GetCurrentWorkload: TWorkload;
    // проверяет работы на предмет просроченности отметок
    procedure CheckOverdueJobs(w: TWorkload);
    // возвращает ключи всех интервалов работы, кроме первого
    function SplitJobByMultiplier(w: TWorkload; Job: TJobParams; AutoSplit: boolean): TIntArray;
    //function SplitJobByMultiplier(w: TWorkload; AutoSplit: boolean): TIntArray; overload;
    // возвращает ключ второго интервала работы
    function SplitJobBySides(w: TWorkload; Job: TJobParams; AutoSplit: boolean): integer;
    //function SplitJobBySides(w: TWorkload; AutoSplit: boolean): integer; overload;
    // возвращает ключ второго интервала работы
    function SplitJobByQuantity(w: TWorkload; Job: TJobParams; AutoSplit: boolean): integer;
    // возвращает ключ второго интервала работы
    function SplitJobByQuantityEx(w: TWorkload; Job: TJobParams; AutoSplit: boolean;
      NewStartTime1, NewFinishTime1, NewStartTime2, NewFinishTime2: TDateTime): integer;
    procedure RenumberItemJobs(w: TWorkload; Job: TJobParams; SplitModeNum: integer);
    function RemoveItemJobsFromPlan(w: TWorkload; Job: TJobParams): boolean;
    procedure ProcessFactProductOutChange(w: TWorkload; Job: TJobParams);
    function CheckSetFactOrder(Job: TJobParams): boolean;
    function CheckRemoveFactOrder(Job: TJobParams): boolean;
    function GetRemovedJobDesc(Job: TJobParams): string;
    procedure TimeLineBlockSelected(Sender: TObject);
    procedure MoveFromJobDown(w: TWorkload; Job: TJobParams; StartTime: TDateTime);
    function GetNextShiftStart(w: TWorkload; DT: TDateTime): TDateTime;
    function EditJobComment(Job: TJobParams): boolean;
    function EditAdvanced(Job: TJobParams): boolean;
    procedure HandleViewNotPlannedJob(Sender: TObject);
    procedure HandleEditNotPlannedJobComment(Sender: TObject);
    function CreateNotPlannedJob: TJobParams;
    procedure CreateJobRelatedProcesses(tempdm: TDataModule;
      var PrecedingDataSource, FollowingDataSource: TDataSource);
    procedure LockWorkload(w: TWorkload);
    procedure UnlockWorkload(w: TWorkload);
    function CheckCurrentLocked: boolean;
    // true, если план заблокирован другим пользователем и выдает сообщение,
    // иначе блокирует.
    function CheckLocked(w: TWorkload): boolean;
    // true, если план заблокирован другим пользователем
    function IsLocked(w: TWorkload): boolean;
    procedure UnlockAll;
    // проверяет, был ли изменен план с момента последней проверки
    function CheckModified(w: TWorkload): boolean;
  protected
    FEnableUndo: boolean;
    // обновляет текущий план. остальные закрывает
    //procedure RefreshWorkloads;
    // Проверяет, можно ли сдвинуть работу
    function CheckCanMove(Job: TJobParams; ShowMessage: boolean): boolean;
    // Проверяет по всем последующим сменам, есть ли там работа, которые можно сдвинуть вверх.
    // Начиная с JobID. IncludeJob означает, что сдвиг включает указанную работу.
    function CheckCanMoveNext(w: TWorkload; JobID: integer; IncludeJob: boolean): boolean;
    function LocateMovableJob(w: TWorkload; var LastUnmovableJob: TJobParams; MovedJobID: integer; JobDuration: extended): boolean;
    procedure EditOrderState(Job: TJobParams);
    procedure EditFiles(Job: TJobParams);
    function GetNextItemID: integer;
    procedure UpdateWorkloadCriteria(w: TWorkload);
    function GetAdapter(w: TWorkload): TScheduleAdapter;
    procedure BeginUpdates(w: TWorkload);
    procedure CommitUpdates(w: TWorkload);
    procedure RollbackUpdates(w: TWorkload);
    procedure UpdateActionState;
    procedure UndoLastEdit;
    procedure DoEditLockTimer(Sender: TObject);
    function Validate(w: TWorkload): boolean;
  public
    constructor Create(_Entity: TEntity); override;
    destructor Destroy; override;
    function Visible: boolean; override;
    //procedure EditCurrent; override;
    //procedure DeleteCurrent(Confirm: boolean); override;
    function CreateFrame(Owner: TComponent): TBaseFrame; override;
    //procedure CancelCurrent; override;
    procedure RefreshData; override;
    procedure Activate; override;
    procedure Deactivate(var AllowLeave: boolean); override;
    procedure PrintReport(ReportKey: integer; AllowInside: boolean); override;

    //procedure LoadSettings(AppStorage: TjvCustomAppStorage); override;
    //procedure SaveSettings(AppStorage: TjvCustomAppStorage); override;
    function ContinuousMode(w: TWorkload): boolean;
    function GetToolbar: TjvSpeedbar; override;

    property Plan: TPlan read GetPlan;
    property PlanFrame: TPlanFrame read GetPlanFrame;
    property CurrentWorkload: TWorkload read GetCurrentWorkload;
  end;

const
  MIN_JOB = 5; // минимальная работа в минутах

implementation

uses Dialogs, DateUtils,

  RDialogs, MainData, RDBUtils, ExHandler,
  PmAccessManager, CalcSettings, fAddToPlan, PlanUtils, PmProcessEntity,
  JvInterpreter_CustomQuery, StdDic, ServMod, fEditText, fEditJobComment,
  fJobSplit, PmDatabase, fEditOrderState, fJobList, fOrderFiles,
  PmEntSettings, PmAppController, PmConfigManager, PmActions, PmOrder,
  MainFilter, fJobSplitShift,
  fJobOverlap, PmAdvancedEdit, PmLockManager;

constructor TPlanController.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  FCaption := 'План: ' + TConfigManager.Instance.StandardDics.deEquipGroup.ItemName[TPlan(_Entity).EquipGroupCode];
  Plan.OnScriptError := ScriptError;
  FEnableUndo := true;
  CreateWorkloads;
  FNeedRefresh := true;

  // таймер подтверждения блокировкм
  FEditLockTimer := TTimer.Create(nil);
  FEditLockTimer.Enabled := false;
  FEditLockTimer.Interval := EntSettings.EditLockConfirmInterval * 1000;
  FEditLockTimer.OnTimer := DoEditLockTimer;
end;

destructor TPlanController.Destroy;
var
  i: integer;
begin
  if FWorkloads <> nil then
  begin
    for i := 0 to FWorkloads.Count - 1 do
      TWorkload(FWorkloads.Items[i]).Free;
    FWorkloads.Free;
  end;

  (FFrame as TPlanFrame).Workloads := nil;

  if FAdapters <> nil then
  begin
    for i := 0 to FAdapters.Count - 1 do
      TScheduleAdapter(FAdapters.Items[i]).Free;
    FAdapters.Free;
  end;

  FShiftEmployees.Free;

  FreeAndNil(FEditLockTimer);

  inherited Destroy;
end;

function TPlanController.Visible: boolean;
begin
  Result := AccessManager.CurUser.PermitPlanView;
end;

function TPlanController.GetPlan: TPlan;
begin
  Result := FEntity as TPlan;
end;

function TPlanController.CreateFrame(Owner: TComponent): TBaseFrame;
begin
  FFrame := TPlanFrame.Create2(Owner, Plan, FWorkloads);  // Create FWorkloads and pass Owner!
  TPlanFrame(FFrame).OnScriptError := ScriptError;
  FFrame.AfterCreate;
  TPlanFrame(FFrame).OnAddToPlan := HandleAddToPlan;
  TPlanFrame(FFrame).OnRemoveFromPlan := RemoveFromPlan;
  TPlanFrame(FFrame).OnMoveJobDown := MoveJobDown;
  TPlanFrame(FFrame).OnMoveJobUp := MoveJobUp;
  TPlanFrame(FFrame).OnMoveJobFirst := MoveJobFirst;
  TPlanFrame(FFrame).OnMoveJobLast := MoveJobLast;
  TPlanFrame(FFrame).OnMouseMoveJob := MouseMoveJob;
  TPlanFrame(FFrame).OnOpenOrder := DoOpenOrder;
  TPlanFrame(FFrame).OnLocateOrder := DoLocateOrder;
  TPlanFrame(FFrame).OnLaunchReport := LaunchReport;
  TPlanFrame(FFrame).OnEditJob := HandleEditJob;
  TPlanFrame(FFrame).OnUndo := HandleUndo;
  TPlanFrame(FFrame).OnGetUndoEnabled := GetUndoEnabled;
  TPlanFrame(FFrame).OnLock := HandleLock;
  TPlanFrame(FFrame).OnUnlock := HandleUnlock;
  TPlanFrame(FFrame).OnPauseJob := PauseJob;
  TPlanFrame(FFrame).OnDivideJob := DivideJob;
  TPlanFrame(FFrame).OnAddSpecialJob := HandleAddSpecialJob;
  TPlanFrame(FFrame).OnAssignShiftForeman := HandleAssignShiftEmployee;
  TPlanFrame(FFrame).OnAssignOperator := HandleAssignEquipmentEmployee;
  TPlanFrame(FFrame).OnAssignAssistant := HandleAssignEquipmentAssistant;
  TPlanFrame(FFrame).OnEditJobComment := HandleEditJobComment;
  TPlanFrame(FFrame).OnEditFiles := HandleEditFiles;
  TPlanFrame(FFrame).OnEditOrderState := HandleEditOrderState;
  TPlanFrame(FFrame).OnChangeEquip := HandleChangeEquip;
  TPlanFrame(FFrame).OnTimeLock := HandleTimeLock;
  TPlanFrame(FFrame).OnUpdateCriteria := HandleUpdateCriteria;
  TPlanFrame(FFrame).OnUpdateWorkloadCriteria := HandleUpdateWorkloadCriteria;
  TPlanFrame(FFrame).OnTimeLineBlockSelected := TimeLineBlockSelected;
  TPlanFrame(FFrame).OnViewNotPlannedJob := HandleViewNotPlannedJob;
  TPlanFrame(FFrame).OnEditNotPlannedJobComment := HandleEditNotPlannedJobComment;
  Result := FFrame;
end;

procedure TPlanController.HandleEditNotPlannedJobComment(Sender: TObject);
var
  Job, JobCopy: TJobParams;
begin
  Job := CreateNotPlannedJob;
  JobCopy := Job.Copy;
  JobCopy.ClearChanges;
  try
    if EditJobComment(JobCopy) and (JobCopy.JobCommentSet or JobCopy.JobAlertSet) then
    begin
      Job.JobComment := JobCopy.JobComment;
      Job.JobAlert := JobCopy.JobAlert;
      {BeginUpdates(w);
      GetAdapter(w).UpdatePlan(Job);
      CommitUpdates(w);}
    end;
  finally
    JobCopy.Free;
    Job.Free;
  end;
end;

procedure TPlanController.CreateJobRelatedProcesses(tempdm: TDataModule;
  var PrecedingDataSource, FollowingDataSource: TDataSource);
var
  CurProcess: TPolyProcessCfg;
begin
  // создаем данные о процессах, предшествующих и последующих текущему
  CurProcess := TConfigManager.Instance.ServiceByID(Plan.ProcessID);
  PrecedingDataSource := GetAdapter(CurrentWorkload).CreateRelatedProcesses(tempDm, false, CurProcess.SequenceOrder,
    Plan.Part, Plan.OrderID, Plan.ItemID, Plan.JobID, null, null);
  FollowingDataSource := GetAdapter(CurrentWorkload).CreateRelatedProcesses(tempDm, true, CurProcess.SequenceOrder,
    Plan.Part, Plan.OrderID, Plan.ItemID, Plan.JobID, null, null);
end;

function TPlanController.CreateNotPlannedJob: TJobParams;
begin
  Result := TJobParams.Create;
  Result.JobID := Plan.JobID;
  Result.ItemID := Plan.ItemID;
  Result.JobComment := null;  // пустое примечание
  Result.JobAlert := false;
  Result.Executor := null;  // лучше чем unassigned не выбивает KeyValue комбобокса
  Result.Part := Plan.Part;
  Result.PartName := Plan.PartName;
  Result.Multiplier := Plan.Multiplier;
  Result.SideCount := Plan.SideCount;
  Result.OrderID := Plan.OrderID;
  Result.OrderNumber := Plan.OrderNumber;
  Result.OrderState := Plan.OrderState;
  Result.Comment := Plan.Comment;
end;

// передается ключ записи на которую перетащили работу
function TPlanController.AddToPlan(WorkloadRowKey: integer): Boolean;
var
  StartTime, FinishTime: TDateTime;
  FactStartTime, FactFinishTime, FactProductOut: variant;
  PrevFinishTime: TDateTime;
  StartFound, AddOk: boolean;
  Estimated, NextItemID, CurJobID: integer;
  FollowingDataSource, PrecedingDataSource: TDataSource;
  Job: TJobParams;
  w: TWorkload;
  tempdm: TDataModule;
  KPRec: TKindProcPerm;
begin
  w := CurrentWorkload;

  AccessManager.ReadUserKindProcPermTo(KPRec, Plan.KindID, AccessManager.CurUser.ID, Plan.ProcessID);
  // Если план заблокирован или нет прав на планирование и фактич. отметки, то выходим
  if not KPRec.PlanDate and not KPRec.FactDate or IsLocked(W) then Exit;

  if CheckLocked(w) then  // Если заблокирован, выходим
    Exit;

  if WorkloadRowKey <> 0 then
  begin
    w.Locate(WorkloadRowKey);
    //StartTime := PlanFrame.CurrentWorkload.AnyStartDateTime;
    StartFound := FindAvailableStart(w, StartTime, true);
  end
  else
    StartFound := FindAvailableStart(w, StartTime, false);

  AddOk := false;
  if StartFound then
  begin
    if Plan.EquipCode <> w.EquipCode then
    begin
      // Присвоить незапланированному процессу код оборудования
      Plan.DataSet.Edit;
      Plan.EquipCode := w.EquipCode;
      Plan.DataSet.Post;
    end;

    // Присвоить FinishTime с учетом оценочной длительности операций
    Estimated := Plan.CalcEstimatedDuration(w.EquipCode);
    if Estimated = 0 then
    begin
      if Plan.EstimatedDuration = 0 then
        FinishTime := IncMinute(StartTime, 1)
      else
        FinishTime := IncMinute(StartTime, Plan.EstimatedDuration);
    end
    else
      FinishTime := IncMinute(StartTime, Estimated);

    PrevFinishTime := StartTime;  // дата завершения предыдущего процесса

    CurJobID := Plan.JobID;  // запоминаем ключик

    tempDm := TDataModule.Create(nil);
    try
      Job := CreateNotPlannedJob;

      Job.PlanStart := StartTime;
      Job.PlanFinish := FinishTime;
      Job.EquipCode := w.EquipCode;
      Job.EstimatedDuration := Estimated;
      SetExecutor(w, Job);  // берем исполнителя из информации о смене, если надо

      // Проверяем, надо ли показывать окно добавления в план
      if EntSettings.ShowAddPlanDialog then
        CreateJobRelatedProcesses(tempdm, PrecedingDataSource, FollowingDataSource);
      //try
        // Проверяем, надо ли показывать окно добавления в план
        if EntSettings.ShowAddPlanDialog then
          AddOk := ExecAddToPlanForm(Job, PrevFinishTime, PrecedingDataSource, FollowingDataSource, 
                        not ContinuousMode(w), EditJobComment)
        else
          AddOk := true;
        if AddOk then
        begin
          BeginUpdates(w);
          w.JobList.Add(Job);
          AddOk := CheckMovingJob(Plan.ItemID, Job);
          if AddOk then
          begin
            //PlanFrame.CurrentWorkload.ReloadLocate(CurJobID);  // 19.05.2008
            //w.SortJobs;
            CheckShifts;
            CommitUpdates(w);
            PlanFrame.UpdateJobControls; // чтобы кнопочки обновились
            // В очереди работ берем номер следующей работы, чтобы вернуться к ней,
            // а не переходить в начало таблицы
            NextItemID := GetNextItemID;
            Plan.ReloadLocate(NextItemID);
          end
          else
            RollbackUpdates(w);
        end;
        {else
          RollbackUpdates(w);}
    finally
      tempdm.Free;
    end;
  end
  else
    RusMessageDlg('Все смены заполнены', mtWarning, [mbOk], 0);

  if not AddOk then
    Plan.CancelUpdates;

  Result := AddOk;
end;

function TPlanController.GetNextItemID: integer;
var
  CurItemID: integer;
begin
  CurItemID := Plan.ItemID;
  if Plan.DataSet.RecordCount >= 1 then
  begin
    Plan.DataSet.Next;
    if Plan.DataSet.eof then
    begin
      Plan.DataSet.Prior;
      Plan.DataSet.Prior;
    end;
  end;
  Result := Plan.ItemID;
  Plan.Locate(CurItemID);
end;

function GetUnScheduleReason(var ReasonText: string): boolean;
begin
  Result := ExecEditText('Причина снятия работы', ReasonText, true);
end;

function TPlanController.GetRemovedJobDesc(Job: TJobParams): string;
begin
  Result := 'Работа снята: ' + Job.OrderNumber + ', ' + Job.PartName;
end;

procedure TPlanController.RemoveFromPlan(Sender: TObject);
var
  w: TWorkload;
  Res, NextID, sn: integer;
  CurStart: TDateTime;
  ReasonText: string;
  Job: TJobParams;
  ReloadNotPlanned, FactStarted, TransStarted: boolean;
  JobIDs: TIntArray;
begin
  w := PlanFrame.CurrentWorkload;

  if CheckLocked(W) then  // Если заблокирован, выходим
    Exit;

  if not w.DataSet.IsEmpty then
  begin
    Job := w.CurrentJob;
    if Job = nil then Exit;

    // Надо проверить, если работа уже началась или закончилась, то не снимать
    // Для разбитых на интервалы работ надо проверить все интервалы.
    FactStarted := not VarIsNull(Job.FactStart) or not VarIsNull(Job.FactFinish);
    if FactStarted then
    begin
      RusMessageDlg('Работа содержит отметки о фактическом выполнении, поэтому не может быть снята.', mtError, [mbOk], 0);
      Exit;
    end;

    CurStart := Job.PlanStart;  // начало работы, которая будет снята
    w.DataSet.Next;   // запоминаем ключ следующей работы
    if not w.DataSet.eof then
    begin
      NextID := w.JobID;
      w.DataSet.Prior;  // возвращаем назад
    end
    else
      NextID := 0;

    TransStarted := false;

    if Job.JobType >= JobType_Special then
    begin
      // Для спец работ
      ReloadNotPlanned := false;
      BeginUpdates(w);
      GetAdapter(w).RemoveJob(Job);
    end
    else
    begin
      // Для обычных работ
      ReloadNotPlanned := true;

      if Job.HasSplitMode(smQuantity) or Job.HasSplitMode(smMultiplier) or Job.HasSplitMode(smSide) then
      begin
        if Job.HasSplitMode(smQuantity) and not Job.HasSplitMode(smMultiplier) and not Job.HasSplitMode(smSide) then
        begin
          Res := RusMessageDlg('Работа разбита на несколько интервалов. Снять всю работу?', mtConfirmation, mbYesNoCancel, 0);
          if Res = mrYes then
          begin
            if not RemoveItemJobsFromPlan(w, Job) then  // там делается beginupdates
              Exit;
          end
          else if Res = mrNo then  // Снять только один интервал
          begin
            ReloadNotPlanned := false;   // очередь работ не меняется 
            // разбивка только по тиражу
            if AccessManager.CurUser.DescribeUnScheduleJob then
            begin
              if not GetUnScheduleReason(ReasonText) then
                Exit;
              {if not Database.InTransaction then   // 19.05.2009
              begin
                TransStarted := true;
                Database.BeginTrans;
              end;}
            end;
            BeginUpdates(w);
            GetAdapter(w).RemoveJob(Job);
            // определяем, по какому полю обновляется разбивка
            if Job.SplitMode1 = smQuantity then
              sn := 1
            else if Job.SplitMode2 = smQuantity then
              sn := 2
            else if Job.SplitMode3 = smQuantity then
              sn := 3;
            GetAdapter(w).RenumberSplitPartsItem(Job.ItemID, Job.SplitPart1, Job.SplitPart2, sn);
            if AccessManager.CurUser.DescribeUnScheduleJob then  // заменяем на спец работу с описанием
              NextID := GetAdapter(w).ReplaceJobWithSpecial(Job.JobID, TStandardDics.SpecialJob_Unscheduled,
                GetRemovedJobDesc(Job) + #13#10 + ReasonText);
          end
          else
            Exit; // Cancel
        end
        else
        begin
          // разбивка не только по тиражу, так что придется снимать все работы сразу
          // проверяем, есть ли работы с фактич. отметками
          JobIDs := GetAdapter(w).GetJobsWithFactInfo(Job.ItemID);
          if Length(JobIDs) > 0 then
          begin
            // есть работы с фактич. отметками, поэтому снимать нельзя
            RusMessageDlg('Работа разбита на несколько интервалов, и один из них' + #13
              + 'содержит отметки о фактическом выполнении, поэтому не может быть снят.', mtError, [mbOk], 0);
            Exit;
          end
          else
          begin
            if RusMessageDlg('Работа разбита на несколько интервалов. Будет снята вся работа.' + #13
                + 'Продолжить?', mtConfirmation, mbYesNoCancel, 0) = mrYes then
            begin
              if not RemoveItemJobsFromPlan(w, Job) then   // там делается beginUpdates
                Exit;
            end
            else
              Exit;
          end;
        end;
      end
      else
      begin
        // работа не разбита, просто снимаем
        if AccessManager.CurUser.DescribeUnScheduleJob then
        begin
          if not GetUnScheduleReason(ReasonText) then
            Exit;
          NextID := GetAdapter(w).ReplaceJobWithSpecial(Job.JobID, TStandardDics.SpecialJob_Unscheduled,
            GetRemovedJobDesc(Job) + #13#10 + ReasonText);
        end;
        BeginUpdates(w);
        GetAdapter(w).UnPlanItem(Job);
      end;
    end;

    CommitUpdates(CurrentWorkload);
    //w.Reload;
    // Теперь делим работы, попадающие на границы смен // 08.09.2008 - не понял зачем, поэтому закомментил
    //CheckShifts;
    if ReloadNotPlanned then
      Plan.Reload;

    if NextID <> 0 then // возвращаем обратно
      w.Locate(NextID);

    // если были работы за удаленной, то можно сдвинуть их
    if not AccessManager.CurUser.DescribeUnScheduleJob and (NextID > 0) then
    begin
      if CheckCanMoveNext(w, NextID, true) and (RusMessageDlg('Сдвинуть следующие работы на место удаленной?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      begin
        BeginUpdates(w);
        MoveJobsUp(w, CurStart, NextID, true);
        // Теперь делим работы, попадающие на границы смен
        CheckShifts;
        CommitUpdates(w);
        PlanFrame.UpdateJobControls; // чтобы кнопочки обновились
      end;
    end;
  end;
end;

// Проверяет по всем последующим сменам, есть ли там работа, которую можно сдвинуть вверх.
// Начиная с JobID.
function TPlanController.CheckCanMoveNext(w: TWorkload; JobID: integer; IncludeJob: boolean): boolean;
var
  JobIndex: integer;
  I: Integer;
begin
  Result := false;
  JobIndex := w.JobList.GetJobIndex(JobID);

  if (JobIndex = -1) or (JobIndex = w.JobList.Count - 1) then Exit;

  if not IncludeJob then
    Inc(JobIndex);
    
  for I := JobIndex to w.JobList.Count - 1 do
    if CheckCanMove(w.JobList[I], false) then
    begin
      Result := true;
      break;
    end;
end;

// Проверяет, можно ли сдвинуть работу
function TPlanController.CheckCanMove(Job: TJobParams; ShowMessage: boolean): boolean;
begin
  if not VarIsNull(Job.FactStart) then
  begin
    if ShowMessage then
      RusMessageDlg('Работа "' + Job.Comment + ' (' + Job.PartName + ')" уже началась. Ее переместить нельзя', mtWarning, [mbOk], 0);
    Result := false;
  end
  else
  if not VarIsNull(Job.FactFinish) then
  begin
    if ShowMessage then
      RusMessageDlg('Работа "' + Job.Comment + ' (' + Job.PartName + ')" уже завершилась. Ее переместить нельзя', mtWarning, [mbOk], 0);
    Result := false;
  end
  else if Job.TimeLocked then
  begin
    if ShowMessage then
      RusMessageDlg('Работа "' + Job.Comment + '" зафиксирована. Ее переместить нельзя', mtWarning, [mbOk], 0);
    Result := false;
  end
  else
    Result := true;
end;

// Ищет работу, которую можно сдвинуть, начиная с текущей (LastUnmovableJob).
// Возвращает последнюю несдвигаемую работу.
// MovedJobID - работа, которая сдвигается
function TPlanController.LocateMovableJob(w: TWorkload; var LastUnmovableJob: TJobParams; MovedJobID: integer; JobDuration: extended): boolean;
var
  CurJob: TJobParams;
  LastUnmovableFinish: TDateTime;
  //Finished: boolean;
  I, JobIndex: Integer;
begin
  LastUnmovableFinish := LastUnmovableJob.AnyFinish;
  //Finished := false;
  JobIndex := w.JobList.IndexOf(LastUnmovableJob);
  for I := JobIndex to w.JobList.Count - 1 do
  begin
    CurJob := w.JobList[I];
    if CurJob.JobID <> MovedJobID then
    begin
      // Текущую можно сдвинуть
      if CheckCanMove(CurJob, false) then
      begin
        Result := true;
        Exit
      end
      else
      // Если есть место между окончанием предыдущей работы и началом текущей
      //if (CurJob.AnyStart - LastUnmovableFinish >= JobDuration) then
      if MinutesBetween(CurJob.AnyStart, LastUnmovableFinish) > MIN_JOB then
      begin
        Result := true;
        Exit;
      end
      else  // текущая становится последней несдвигаемой
      begin
        LastUnmovableFinish := CurJob.AnyFinish;
        LastUnmovableJob := CurJob;
      end;
    end
    else
    begin
      // добрались до работы, которую нам и надо сдвинуть.
      // значит, она останется на своем месте или подтянется к последней несдвигаемой
      Result := true;
      Exit;
    end;
  end;
  // Не нашли, ставим после последней несдвигаемой
  Result := true;
end;

procedure TPlanController.MoveJobDown(Sender: TObject);
var
  CurID, CurItemID, NextID: variant;
  UnMovableJobID: integer;
  UnMovableJob: TJobParams;
  CurJob: TJobParams;
  w: TWorkload;
  CurStart, CurFinish, NextFinish, NextStart, NewStart, ShiftStart: TDateTime;
  WasShiftMarker: boolean;
begin
  // TODO!
  w := PlanFrame.CurrentWorkload;
  CurID := w.JobID;
  CurItemID := w.ItemID;
  CurStart := w.PlanStartDateTime;
  CurFinish := w.PlanFinishDateTime;
  CurJob := w.CurrentJob;
  w.DataSet.DisableControls;
  try
    w.DataSet.Next;
    if not w.DataSet.eof then
    begin
      WasShiftMarker := false;
      // Если след. запись - маркер смены, пропускаем его
      if w.IsShiftMarker then
      begin
        WasShiftMarker := true;
        ShiftStart := w.AnyStartDateTime;
        w.DataSet.Next;
        if not w.DataSet.Eof then
        begin
          // Если опять маркер смены, возвращаемся на предыдущую запись и ставим туда
          if w.IsShiftMarker then
          begin
            w.DataSet.Prior;
            NewStart := w.FactStartDateTime;
            Database.BeginTrans;
            try
              GetAdapter(w).UpdatePlan(CurID, NewStart, NewStart + CurFinish - CurStart);
              Database.CommitTrans;
            except
              Database.RollbackTrans;
              raise;
            end;

            w.Reload;
            // работа может разбиваться сменами. проверяем
            CheckShifts;

            Exit;  // все
          end;
        end;
      end;
      if CheckCanMove(w.CurrentJob, false) then   // без сообщения
      begin
        // сдвигаем работу дальше
        if WasShiftMarker then
        begin
          // если работа стоит не в начале смены, то впихиваем перед ней
          if MinuteSpan(ShiftStart, w.AnyStartDateTime) > MIN_JOB then
            CurJob.PlanStart := ShiftStart
          else // иначе ставим после первой работы
            CurJob.PlanStart := w.AnyFinishDateTime;
          CurJob.PlanFinish := CurJob.PlanStart + CurFinish - CurStart;
          if CheckMovingJob(CurItemID, CurJob) then
            w.Reload;
        end
        else
        begin
          // меняем местами последующую и текущую
          NextStart := w.AnyStartDateTime;
          NextFinish := w.AnyFinishDateTime;
          NextID := w.JobID;
          NewStart := CurStart + NextFinish - NextStart;
          Database.BeginTrans;
          try
            GetAdapter(w).UpdatePlan(NextID, CurStart, NewStart);
            GetAdapter(w).UpdatePlan(CurID, NewStart, NewStart + CurFinish - CurStart);
            Database.CommitTrans;
          except
            Database.RollbackTrans;
            raise;
          end;
          w.Reload;
        end;
      end
      else
      begin
        // Работу сдвинуть нельзя, значит, надо поместить нашу работу после нее.
        // Надо найти ту, которую можно сдвинуть
        UnMovableJobID := w.JobID;
        UnmovableJob := w.JobList.GetJob(UnmovableJobID);
        if LocateMovableJob(w, UnMovableJob, CurID, CurFinish - CurStart{, MovableJobStart}) then
        begin
          CurJob.PlanStart := UnMovableJob.AnyFinish;
          CurJob.PlanFinish := CurJob.PlanStart + CurFinish - CurStart;
          if CheckMovingJob(CurItemID, CurJob) then
            w.Reload;
        end
        else
        begin
          w.Locate(UnMovableJobID);
          CheckCanMove(w.CurrentJob, true); // показываем сообщение об ошибке
        end;
      end;
    end;
  finally
    //CurJob.Free;
    w.Locate(CurID);
    w.DataSet.EnableControls;
    PlanFrame.UpdateJobControls;
  end;
end;

procedure TPlanController.MoveJobUp(Sender: TObject);
var
  CurID, PriorID: variant;
  w: TWorkload;
  CurStart, CurFinish, PriorFinish, PriorStart, NewStart, NewFinish: TDateTime;
  Moved: boolean;
begin
  // TODO!
  w := PlanFrame.CurrentWorkload;
  CurID := w.JobID;
  CurStart := w.PlanStartDateTime;
  CurFinish := w.PlanFinishDateTime;
  w.DataSet.DisableControls;
  try
    Moved := false;
    PriorStart := w.AnyStartDateTime;
    w.DataSet.Prior;
    if not w.DataSet.Bof then
    begin
      // Если предыд. запись - маркер смены, пропускаем его
      if w.IsShiftMarker then
      begin
        PriorStart := w.AnyStartDateTime;
        w.DataSet.Prior;
        if not w.DataSet.Bof then
        begin
          // Если опять маркер смены, тут может быть 2 варианта:
          // 1. возвращаемся на предыдущую смену и ставим перед ней
          // 2. ставим в начало смены
          if w.IsShiftMarker then
          begin
            { Вариант 1:
            w.DataSet.Next;
            NewFinish := w.FactFinishDateTime;
            Database.BeginTrans;
            try
              FAdapter.UpdatePlan(CurID, NewFinish - CurFinish + CurStart, NewFinish);
              Database.CommitTrans;
            except
              Database.RollbackTrans;
              raise;
            end;}
            // Вариант 2:
            Database.BeginTrans;
            try
              GetAdapter(w).UpdatePlan(CurID, w.AnyStartDateTime, w.AnyStartDateTime + CurFinish - CurStart);
              Database.CommitTrans;
            except
              Database.RollbackTrans;
              raise;
            end;

            w.Reload;
            // работа может разбиваться сменами. проверяем
            CheckShifts;

            Moved := true;  // все
          end
          else
          begin
            // Если мы стоим на работе, находящейся в предыдущей смене,
            // то надо проверить, есть ли еще место в этой смене
            if MinuteSpan(PriorStart, w.AnyFinishDateTime) > MIN_JOB then
            begin
              // ставим сюда
              GetAdapter(w).UpdatePlan(CurID, w.AnyFinishDateTime, w.AnyFinishDateTime + CurFinish - CurStart);
              // работа может разбиваться сменами. проверяем
              w.Reload;
              CheckShifts;

              Moved := true;
            end;
            // иначе места нету - идем дальше и меняем местами с работой в смене
          end;
        end;
      end;

      if not Moved then
      begin
        // Проверяем есть ли место между работами
        if CurStart - w.AnyFinishDateTime > 0 then
        begin
          GetAdapter(w).UpdatePlan(CurID, w.AnyFinishDateTime, w.AnyFinishDateTime + CurFinish - CurStart);
          Moved := true;
          // работа может разбиваться сменами или склеиваться. проверяем
          w.Reload;
          CheckShifts;
        end
        else
        if CheckCanMove(w.CurrentJob, true) then
        begin
          // сдвигаем работу назад - меняем местами предыдущую и текущую
          PriorStart := w.AnyStartDateTime;
          PriorFinish := w.AnyFinishDateTime;
          PriorID := w.JobID;
          // новое начало предыдущей работы
          NewStart := PriorStart + CurFinish - CurStart;
          Database.BeginTrans;
          try
            GetAdapter(w).UpdatePlan(PriorID, NewStart, NewStart + PriorFinish - PriorStart);
            GetAdapter(w).UpdatePlan(CurID, PriorStart, NewStart);
            Database.CommitTrans;
            Moved := true;
          except
            Database.RollbackTrans;
            raise;
          end;
          // работа может разбиваться сменами или склеиваться. проверяем
          w.Reload;
          CheckShifts;
        end;
      end;

    end;
    w.Locate(CurID);
  finally
    w.DataSet.EnableControls;
    PlanFrame.UpdateJobControls;
  end;
end;

procedure TPlanController.MoveJobFirst(Sender: TObject);
var
  w: TWorkload;
  CurStart, CurFinish, NewStart, NextStart, NextFinish: TDateTime;
  CurID, NextID: variant;
  CanMove: boolean;
  FirstJobID: integer;
begin
  // TODO!
  w := PlanFrame.CurrentWorkload;
  if w.DataSet.RecordCount > 1 then
  begin
    CurID := w.JobID;
    CurStart := w.PlanStartDateTime;
    CurFinish := w.PlanFinishDateTime;
    w.DataSet.DisableControls;
    try
      // в непрерывном режиме находим начало смены
      if ContinuousMode(w) then
      begin
        if not w.LocateShift then Exit;  // аварийный выход
      end else
        w.DataSet.First;

      if w.IsShiftMarker then
      begin
        // стоим на начале смены
        w.DataSet.Next;
        if w.JobID = CurID then // если наша работа стоит первой то ничего не делаем
          Exit;
      end;
      FirstJobID := w.JobID;

      if CurID <> w.JobID then  // если это не первая работа
      begin
        // Проходим по всем работам и проверяем нет ли такой, которую нельзя сдвинуть
        CanMove := true;
        // пока не дойдем до нашей
        while not w.DataSet.Eof and (CurID <> w.JobID) and CanMove do
        begin
          CanMove := CheckCanMove(w.CurrentJob, true);
          w.DataSet.Next;
        end;
        if CanMove then  // Если все нормально, то сдвигаем
        begin
          w.Locate(FirstJobID);
          Database.BeginTrans;
          try
            NextStart := w.AnyStartDateTime; // новое начало сдвигаемой работы
            GetAdapter(w).UpdatePlan(CurID, NextStart, NextStart + CurFinish - CurStart);
            while not w.DataSet.eof do
            begin
              NextID := w.JobID;
              if NextID <> CurID then  // кроме той которая встала в начало
              begin
                NextStart := w.AnyStartDateTime; // начало и конец работ, следующих после первой
                NextFinish := w.AnyFinishDateTime;
                NewStart := NextStart + CurFinish - CurStart; // новое начало следующей работы
                GetAdapter(w).UpdatePlan(NextID, NewStart, NewStart + NextFinish - NextStart);
              end
              else
                break;  // если дошли до работы, которая перешла в начало, то дальше не идем
              w.DataSet.Next;
            end;
            Database.CommitTrans;
          except
            Database.RollbackTrans;
            raise;
          end;
          w.Reload;
          // проверяем пересечение границ смен
          CheckShifts;
        end;
      end;
      w.Locate(CurID);
    finally
      w.DataSet.EnableControls;
      PlanFrame.UpdateJobControls;
    end;
  end;
end;

procedure TPlanController.MoveJobLast(Sender: TObject);
var
  w: TWorkload;
  CurStart, CurFinish, NewStart, NextStart, NextFinish, NewFinish: TDateTime;
  CurID, NextID: variant;
begin
  // TODO!
  w := PlanFrame.CurrentWorkload;
  if w.DataSet.RecordCount > 1 then
  begin
    CurID := w.JobID;
    CurStart := w.PlanStartDateTime;
    CurFinish := w.PlanFinishDateTime;
    w.DataSet.DisableControls;
    try
      // TODO: надо проверить на всякий случай, что можно сдвинуть все работы
      w.DataSet.Next;  // переходим на следующую работу и с нее начнем сдвигать назад
      if CheckCanMove(w.CurrentJob, true) then
      begin
        if not w.DataSet.Eof then  // если это еще не последняя работа
        begin
          Database.BeginTrans;
          try
            while not w.DataSet.eof do
            begin
              // В непрерывном режиме обрабатываем до конца смены
              if ContinuousMode(w) and w.IsShiftMarker then
                break;
              NextID := w.JobID;
              NextStart := w.AnyStartDateTime; // начало и конец работ, ранее следовавших после нашей
              NextFinish := w.AnyFinishDateTime;
              NewStart := NextStart - CurFinish + CurStart; // новое начало следующей работы
              NewFinish := NewStart + NextFinish - NextStart;
              GetAdapter(w).UpdatePlan(NextID, NewStart, NewFinish);
              w.DataSet.Next;
            end;
            NextStart := NewFinish; // новое начало сдвигаемой работы
            GetAdapter(w).UpdatePlan(CurID, NextStart, NextStart + CurFinish - CurStart);
            Database.CommitTrans;
          except
            Database.RollbackTrans;
            raise;
          end;
          // на всякий случай проверяем пересечения с маркерами смен
          w.Reload;
          CheckShifts;
        end;
      end;
      w.Locate(CurID);
    finally
      w.DataSet.EnableControls;
      PlanFrame.UpdateJobControls;
    end;
  end;
end;

procedure TPlanController.MouseMoveJob(SourceJobID, TargetJobID: integer);
var
  w: TWorkload;
  //CurID: integer;
  Job, TargetJob: TJobParams;
  CurStart, TargetFinish: TDateTime;
  SourceShift, TargetShift: TShiftInfo;
begin
  w := CurrentWorkload;

  if CheckLocked(W) then  // Если заблокирован, выходим
    Exit;

  w.DataSet.DisableControls;
  try
    if w.Locate(SourceJobID) then
    begin
      Job := w.CurrentJob;
      if ContinuousMode(w) then
        SourceShift := w.CurrentShift;
      if CheckCanMove(Job, false) then
      begin
        //CurID := w.KeyValue;
        //try
          //if w.Locate(TargetJobID) then
          //begin
            // ставим работу ПОСЛЕ выбранной
            if TargetJobID < 0 then
              TargetFinish := w.GetShiftByID(TargetJobID).Start  // Если бросаем на начало смены
            else
            begin
              TargetJob := w.JobList.GetJob(TargetJobID);
              TargetFinish := TargetJob.AnyFinish;  // Если бросаем на другую работу
            end;
            //TargetShift := w.GetShift(TargetJobID);
            CurStart := Job.PlanStart;
            BeginUpdates(w);
            Job.PlanStart := TargetFinish;
            Job.PlanFinish := Job.PlanStart + (Job.PlanFinish - CurStart);
            //w.JobList.Remove(Job);  // временно убираем, чтобы не путалась
            //SourceShift.JobList.Remove(Job);
            //TargetShift.JobList.Insert(TargetShift.JobList.IndexOf(TargetJob) + 1, Job);
            if CheckMovingJob(Job.ItemID, Job) then
            begin
              //w.JobList.Add(Job);  // добавляем обратно
              //w.SortJobs;          // ставим на нужное место
              //w.ReloadLocate(CurID);
              CheckShifts;
              CommitUpdates(w);
              PlanFrame.UpdateJobControls;
            end else
              RollbackUpdates(w);
          //end;
        {finally
          Job.Free;
        end;}
        w.Locate(SourceJobID);
      end;
    end;
  finally
    w.DataSet.EnableControls;
  end;
end;

function TPlanController.HandleEditJob(Sender: TObject): boolean;
begin
  if CurrentWorkload.JobType = JobType_Work then
    Result := EditPlanJob
  else if CurrentWorkload.JobType >= JobType_Special then
    Result := EditSpecialJob
  else
    Result := false;
end;

function TPlanController.EditSpecialJob: boolean;
var
  PrevFinishTime: TDateTime;
  CurID, Estimated: integer;
  w: TWorkload;
  FollowingDataSource, PrecedingDataSource: TDataSource;
  tempDM: TDataModule;
  CurProcess: TPolyProcessCfg;
  Job: TJobParams;
  _ReadOnly, _JustLocked: boolean;
begin
  w := PlanFrame.CurrentWorkload;
  _ReadOnly := IsLocked(W);  // Если заблокирован, только для чтения

  Job := w.CurrentJob;
  if Job = nil then Exit;

  CurID := Job.JobID;

  Estimated := NvlInteger(TConfigManager.Instance.StandardDics.deSpecialJob.ItemValue[Job.JobType, 1]);
  if Estimated = 0 then Estimated := 1; // нулевая длительность не прокатит

  PrevFinishTime := GetPrevFinishTime(w, Job);
  SetExecutor(w, Job);  // берем исполнителя из информации о смене, если надо
  Job.EstimatedDuration := Estimated;
  Job.ClearChanges;  // очищаем флажки изменения полей

  if not _ReadOnly and not w.Locked then
  begin
    _ReadOnly := CheckLocked(w);  // блокируем
    _JustLocked := true;
  end
  else
    _JustLocked := false;

  if ExecEditSpecialJobForm(Job, PrevFinishTime, _ReadOnly, EditJobComment)
     and not _ReadOnly then
  begin
    if Job.DatesChanged then
    begin
      CheckMovingJob(0, Job);
      Result := true;
    end
    else
    if Job.Changed then
    begin
      GetAdapter(w).UpdatePlan(Job);
      Result := true;
    end else
      Result := false;
  end else
    Result := false;

  if Result then
  begin
    BeginUpdates(w);
    CheckShifts;
    CommitUpdates(w);
    w.Locate(CurID);
    PlanFrame.UpdateJobControls; // чтобы кнопочки обновились
  end
  else
    // Если был заблокирован только что и отменили, то снимаем блокировку
    if _JustLocked then
      UnlockWorkload(w);
end;

procedure TPlanController.SetExecutor(w: TWorkload; Job: TJobParams);
var
  CurJobID: integer;
  NewExecutor: variant;
  Shift: TShiftInfo;
begin
  // Если плановое начало не отмечено, то ставим исполнителя из смены
  if ContinuousMode(w) and VarIsNull(Job.FactStart) then
  begin
    CurJobID := Job.JobID;
    Shift := w.GetJobShift(Job.JobID);
    if Shift <> nil then
    begin
      NewExecutor := Shift.EquipEmployeeID;
      if (NewExecutor <> Job.Executor) then
        Job.Executor := NewExecutor;
    end;
  end;
end;

// Если работа разбита по тиражу, то надо рассчитать фактическую скорость и удлинить-укоротить следующие кусочки.
// Если не разбита по тиражу, и фактическая выработка меньше плановой, то создается новая работа.
// w - до редактирования, Job - после.
procedure TPlanController.ProcessFactProductOutChange(w: TWorkload; Job: TJobParams);

  function ConfirmUser: boolean;
  begin
    Result := RusMessageDlg('Фактическая выработка меньше плановой. Добавить дополнительную работу?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes;
  end;

var
  FactSpeed: integer; // product per time unit
  sn, NewJobID, LastJobID, TotalSec, p, TotalSecExcept, NewFactProd: integer;
  RestDuration: extended;
  NewJob, LastJob: TJobParams;
begin
  if Job.AnyFinish = Job.AnyStart then Exit;

  NewFactProd := NvlInteger(Job.FactProductOut);

  // фактическая скорость
  FactSpeed := Round(NewFactProd / (Job.AnyFinish - Job.AnyStart));

  if (NewFactProd < Job.ProductOut) and not Job.HasSplitMode(smQuantity)
    and (FactSpeed > 0) then
  begin
    // нет разбивки по тиражу, добавляем
    RestDuration := (Job.ProductOut - NewFactProd) / FactSpeed;
    if (MinuteSpan(RestDuration, 0) > MIN_JOB) and ConfirmUser then
    begin
      // создается новый кусочек работы, ставим его после текущей работы
      sn := GetAdapter(w).UpdateJobSplitMode(Job, Job.AnyStart, Job.AnyFinish, smQuantity,
        false);  // auto split в этом случае, чтобы склеилось, если вдруг снимется факт. дата
      // нам вернули номер разбивки
      NewJobID := GetAdapter(w).AddSplitJob(Job, Job.AnyFinish, Job.AnyFinish + RestDuration, sn);
      // Чтобы обновить параметра, общие для всех работ одного процесса
      GetAdapter(w).UpdatePlan(Job);
      // Только после этого перенумеровать
      RenumberItemJobs(w, Job, sn);
      // ставим на правильное место
      NewJob := w.JobList.GetJob(NewJobID);//w.CurrentJob;
      CheckMovingJob(Job.ItemID, NewJob);
    end;
  end
  else if Job.HasSplitMode(smQuantity) and (FactSpeed > 0) then
  begin
    // удлинить-укоротить следующие кусочки.
    // ищем последний кусочек
    if Job.SplitMode1 = smQuantity then
      sn := 1
    else if Job.SplitMode2 = smQuantity then
      sn := 2
    else if Job.SplitMode3 = smQuantity then
      sn := 3;
    LastJobID := GetAdapter(w).GetLastSplitJob(Job, sn);
    if (LastJobID > 0) then
    begin
      if (LastJobID <> Job.JobID) then
      begin
        LastJob := w.JobList.GetJob(LastJobID);
        // вычисляем новое время для последнего кусочка...
        // время всех промежуточных кусочков
        TotalSecExcept := GetAdapter(w).GetJobTotalSecExcept(Job, [Job.JobID, LastJob.JobID]);
        p := Job.ItemProductOut;
        if Job.HasSplitMode(smMultiplier) then
          p := Ceil(p / Job.Multiplier);
        if NewFactProd <> 0 then
        begin
          RestDuration := (p - NewFactProd) * 1.0 / NewFactProd * (Job.AnyFinish - Job.AnyStart);
          //RestDuration := p * 1.0 / FactSpeed + (LastJob.AnyFinish - LastJob.AnyStart);
          RestDuration := IncSecond(RestDuration, -TotalSecExcept);
          if RestDuration < 0 then
            RestDuration := 0;
          // сдвигаем остальные работы
          LastJob.PlanFinish := LastJob.PlanStart + RestDuration;
          // работа может залезть на следующую, поэтому сдвигаем
          CheckMovingJob(LastJob.ItemID, LastJob);
          // после пересчета количества могли получиться нулевые "хвостики". их можно удалить.
          GetAdapter(w).RemoveZeroTimeJobs(LastJob);
        end;
      end
      else
      begin
        // Если это последний кусочек, то спрашиваем, надо ли добавить еще один
        RestDuration := (Job.ProductOut - NewFactProd) / FactSpeed;
        if (MinuteSpan(RestDuration, 0) > MIN_JOB) and ConfirmUser then
        begin
          NewJobID := GetAdapter(w).AddSplitJob(Job, Job.AnyFinish, Job.AnyFinish + RestDuration, sn);
          // Чтобы обновить параметра, общие для всех работ одного процесса
          GetAdapter(w).UpdatePlan(Job);
          // Только после этого перенумеровать
          RenumberItemJobs(w, Job, sn);
          // ставим на правильное место
          NewJob := w.JobList.GetJob(NewJobID);//w.CurrentJob;
          CheckMovingJob(Job.ItemID, NewJob);
        end;
      end;
    end;
  end;
end;

procedure TPlanController.HandleViewNotPlannedJob(Sender: TObject);
var
  Job: TJobParams;
  tempdm: TDataModule;
  FollowingDataSource, PrecedingDataSource: TDataSource;
begin
  tempDm := TDataModule.Create(nil);
  try
    Job := CreateNotPlannedJob;
    CreateJobRelatedProcesses(tempdm, PrecedingDataSource, FollowingDataSource);

    ExecViewNotPlannedForm(Job, PrecedingDataSource, FollowingDataSource,
          EditJobComment);
  finally
    tempdm.Free;
  end;
end;

function TPlanController.EditPlanJob: boolean;
var
  PrevFinishTime: TDateTime;
  CurID: integer;
  w: TWorkload;
  FollowingDataSource, PrecedingDataSource: TDataSource;
  tempDM: TDataModule;
  CurProcess: TPolyProcessCfg;
  Job, JobCopy: TJobParams;
  FactSet, FactRemoved, AllowChangeFact, FactProductOutChanged, _ReadOnly,
  _JustLocked: boolean;
  KPRec: TKindProcPerm;
begin
  w := PlanFrame.CurrentWorkload;

  if w.CurrentJob = nil then Exit;

  AccessManager.ReadUserKindProcPermTo(KPRec, w.KindID, AccessManager.CurUser.ID, w.ProcessID);
  // Если план заблокирован или нет прав на планирование и фактич. отметки, то открыть только для чтения
  _ReadOnly := not KPRec.PlanDate and not KPRec.FactDate or IsLocked(W);

  if not _ReadOnly and not w.Locked then
  begin
    _ReadOnly := CheckLocked(w);  // блокируем
    _JustLocked := true;
  end
  else
    _JustLocked := false;

  Job := w.CurrentJob;

  SetExecutor(w, Job);  // берем исполнителя из информации о смене, если надо

  JobCopy := Job.Copy;  // копия для сравнения
  try
    PrevFinishTime := GetPrevFinishTime(w, Job);
    CurID := Job.JobID;

    // создаем данные о процессах, предшествующих и последующих текущему
    CurProcess := TConfigManager.Instance.ServiceByID(w.ProcessID);
    tempDm := TDataModule.Create(nil);
    PrecedingDataSource := GetAdapter(w).CreateRelatedProcesses(tempDm, false, CurProcess.SequenceOrder,
      w.Part, w.OrderID, w.ItemID, w.JobID, w.AnyStartDateTime, w.AnyFinishDateTime);
    FollowingDataSource := GetAdapter(w).CreateRelatedProcesses(tempDm, true, CurProcess.SequenceOrder,
      w.Part, w.OrderID, w.ItemID, w.JobID, w.AnyStartDateTime, w.AnyFinishDateTime);
    try
      if ExecEditPlanJobForm(Job, PrevFinishTime, PrecedingDataSource, FollowingDataSource,
           not ContinuousMode(w), _ReadOnly, EditJobComment, EditAdvanced)
         and not _ReadOnly then
      begin
        // были ли проставлены фактические отметки?
        FactSet := (NvlDateTime(Job.FactStart) > 0) and (NvlDateTime(JobCopy.FactStart) = 0)
            or (NvlDateTime(Job.FactFinish) > 0) and (NvlDateTime(JobCopy.FactFinish) = 0);
        if FactSet then
        begin
          // Если заказы должны закрываться по порядку,
          // то проверяем, закрыты ли все предшествующие в этой смене.
          if EntSettings.FactDateStrictOrder then
            AllowChangeFact := CheckSetFactOrder(Job)
          else
            AllowChangeFact := true;

          if not AllowChangeFact then
          begin
            RusMessageDlg('Фактические отметки должны ставиться в порядке очередности заказов. Изменения не внесены.',
              mtError, [mbOk], 0);
            Result := false;
            Exit;
          end;
        end;

        // теперь проверяем были сняты какие то фактические отметки?
        FactRemoved := (NvlDateTime(Job.FactStart) = 0) and (NvlDateTime(JobCopy.FactStart) > 0)
            or (NvlDateTime(Job.FactFinish) = 0) and (NvlDateTime(JobCopy.FactFinish) > 0);
        if FactRemoved then
        begin
          // Если заказы должны закрываться по порядку,
          // то проверяем, сняты ли отметки со всех последующих в этой смене.
          if EntSettings.FactDateStrictOrder then
            AllowChangeFact := CheckRemoveFactOrder(Job)
          else
            AllowChangeFact := true;

          if not AllowChangeFact then
          begin
            RusMessageDlg('Сначала нужно снять фактические отметки со всех последующих заказов. Изменения не внесены.',
              mtError, [mbOk], 0);
            Result := false;
            Exit;
          end;
        end;

        BeginUpdates(w);

        // TODO: Здесь надо проверить, были ли изменения
        if CheckMovingJob(Job.ItemID, Job) then
        begin
          // если изменения успешно внесены в план,
          // проверяем, менялись ли фактические параметры
          FactProductOutChanged := NvlInteger(Job.FactProductOut) <> NvlInteger(JobCopy.FactProductOut);
          if FactSet or FactProductOutChanged then
          begin
            // Если изменилась фактич. выработка, то надо обработать хвостики
            if NvlInteger(Job.FactProductOut) <> NvlInteger(JobCopy.FactProductOut) then
            begin
              ProcessFactProductOutChange(w, Job);
            end;
            // предлагаем изменить состояние заказа
            EditOrderState(JobCopy);
          end
          else
        end;
        Result := true;
        CheckShifts;

        CommitUpdates(w);
        if w.Locate(CurID) then  // работа могла склеиться с другой и ее уже нет
        begin
          Job := w.CurrentJob;

          PlanFrame.UpdateJobControls;
          // Проверяем, укоротилась ли работа и предлагаем сдвинуть
          if ((w.KeyValue = CurID) or w.Locate(CurID)) and (JobCopy.AnyFinish > Job.AnyFinish)
            and (MinutesBetween(JobCopy.AnyFinish, Job.AnyFinish) > 1) then
          begin
            if CheckCanMoveNext(w, Job.JobID, false) and (RusMessageDlg('Сдвинуть последующие работы на освободившееся место?',
              mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
            begin
              BeginUpdates(w);
              MoveJobsUp(w, Job.AnyFinish, Job.JobID, false);
              CheckShifts;
              CommitUpdates(w);
              w.Locate(CurID);
              PlanFrame.UpdateJobControls;
            end;
          end;
        end;

      end
      else
      begin
        Result := false;
        // Если был заблокирован только что и отменили, то снимаем блокировку
        if _JustLocked then
          UnlockWorkload(w);
      end;
    finally
      tempDm.Free;
    end;
  finally
    JobCopy.Free;
  end;
end;

// Сдвинуть работы вверх. IncludeJob означает, что сдвиг включает указанную работу.
procedure TPlanController.MoveJobsUp(w: TWorkload; StartTime: TDateTime; JobID: integer; IncludeJob: boolean);
var
  NewStart, NewFinish: TDateTime;
  CanMove, Finished: boolean;
  CurJob: TJobParams;
  CurJobIndex, JobIndex: integer;
begin
  NewStart := StartTime;     
  Finished := false;
  CurJobIndex := w.JobList.GetJobIndex(JobID);

  if CurJobIndex = w.JobList.Count - 1 then Exit;

  if not IncludeJob then
    Inc(CurJobIndex);

  for JobIndex := CurJobIndex to w.JobList.Count - 1 do
  begin
    CurJob := w.JobList[JobIndex];
    // если наткнулись на исходную работу, то пропускаем
    //if CurJob.JobID <> Job.JobID then
    //begin
    TLogger.GetInstance.Debug('Сдвиг работы: Start: ' + DateTimeToStr(CurJob.AnyStart)
       + ', Finish: ' + DateTimeToStr(CurJob.AnyFinish));
    CanMove := CheckCanMove(CurJob, false);
    if CanMove then    // несдвигаемые не трогаем
    begin
      NewFinish := NewStart + (CurJob.AnyFinish - CurJob.AnyStart);
      //GetAdapter(w).UpdatePlan(CurJob.JobID, NewStart, NewFinish);
      CurJob.PlanStart := NewStart;
      CurJob.PlanFinish := NewFinish;
      NewStart := NewFinish;
    end
    else
      break;     // заканчиваем сдвиг на первой же зафиксированной
  end;
end;

procedure DumpWorkload(w: TWorkload; FromWhere: string);
var
  I: Integer;
  Job: TJobParams;
begin
  // Выводит в лог весь план в режиме подробного логирования
  if Options.VerboseLog then
  begin
    TLogger.GetInstance.Debug('------- Workload at ' + FromWhere + ' ---------------');
    for I := 0 to w.JobList.Count - 1 do
    begin
      Job := w.JobList[i];
      TLogger.GetInstance.Debug('Start: ' + DateTimeToStr(Job.AnyStart)
        + ', Finish: ' + DateTimeToStr(Job.AnyFinish)
        + ', Part: ' + GetPartName(Job, false));
    end;
    TLogger.GetInstance.Debug('-------------------------------------------------------------');
  end;
end;

procedure TPlanController.MoveFromJobDown(w: TWorkload; Job: TJobParams; StartTime: TDateTime);
var
  NewStart, NewFinish: TDateTime;
  CanMove, Finished: boolean;
  CurJob, JobInPlan: TJobParams;
  CurJobIndex, JobIndex, I, J: integer;
  TailIDs: TIntArray;
  TailJobs: TJobList;
begin
  NewStart := StartTime;     // эта работа будет стоять сразу после нашей основной
  Finished := false;
  CurJobIndex := w.JobList.IndexOf(Job);

  SetLength(TailIDs, w.JobList.Count - CurJobIndex);
  for JobIndex := CurJobIndex to w.JobList.Count - 1 do
  begin
    CurJob := w.JobList[JobIndex];
    // Добавляем в список для последующего сдвига
    TailIDs[JobIndex - CurJobIndex] := CurJob.JobID;
  end;

  TailJobs := TJobList.Create;
  try
    for I := Low(TailIDs) to High(TailIDs) do
    begin
      CurJob := w.JobList.GetJob(TailIDs[I]);
      TLogger.GetInstance.Debug('Сдвиг работы: Start: ' + DateTimeToStr(CurJob.AnyStart)
         + ', Finish: ' + DateTimeToStr(CurJob.AnyFinish));
      //if CurJob.AnyStart > NewStart then  // если работа отстоит достаточно далеко, заканчиваем сдвиг
      //  break;
      CanMove := CheckCanMove(CurJob, false);
      if CanMove then    // несдвигаемые не трогаем
      begin
        // Добавляем во временный список для последующего сдвига и убираем их из списка работ
        TailJobs.Add(CurJob);
        w.JobList.Remove(CurJob);

        // Если работа отстоит достаточно далеко, то ее не сдвигаем, но убираем в список.
        if CurJob.AnyStart < NewStart then
        begin
          // Ставим на следующее место
          NewFinish := NewStart + (CurJob.PlanFinish - CurJob.PlanStart);
          CurJob.PlanStart := NewStart;
          CurJob.PlanFinish := NewFinish;

          // Если есть несдвигаемая работа, которая начинается раньше начала нашей
          // и заканчивается позже начала CurJob, то CurJob надо поставить после несдвигаемой.
          for J := I + 1 to High(TailIDs) do
          begin
            JobInPlan := w.JobList.GetJob(TailIDs[J]);

            if JobInPlan.AnyStart > CurJob.AnyFinish then
              break;

            if not CheckCanMove(JobInPlan, false) and (JobInPlan.AnyStart <= CurJob.AnyStart)
              and (JobInPlan.AnyFinish > CurJob.AnyStart) then
            begin
              NewFinish := JobInPlan.AnyFinish + (CurJob.PlanFinish - CurJob.PlanStart);
              CurJob.PlanStart := CurJob.PlanFinish;
              CurJob.PlanFinish := NewFinish;
            end;
          end;

          NewStart := NewFinish;

        end;
      end;
    end;
    DumpWorkload(w, 'MoveFromJobDown, before PlaceJobs');
    // Теперь ставим все работы на место
    PlaceJobs(w, TailJobs);
    DumpWorkload(w, 'MoveFromJobDown, after PlaceJobs');
  finally
    TailJobs.Free;
  end;
end;

function GetJobName(Job: TJobParams): string;
var
  s: string;
begin
  Result := Job.Comment;
  s := PlanUtils.GetPartName(Job, false);
  if s <> '' then
    Result := Result + ' (' + s + ')';
end;

// Проверяет, есть ли пересечения в плане по текущему процессу с текущей работой,
// если есть, предлагает исправить и сдвигает текущую работу либо работу в плане.
// Если CurItemID = 0, то нельзя разбивать
function TPlanController.CheckMovingJob(CurItemID: integer; Job: TJobParams): boolean;
var
  AnyStart, AnyFinish: TDateTime;
  CanMove, AfterUnmovable, Applied, RepeatCheck: boolean;
  w: TWorkload;
  ps: TDateTime;
  s1, s2: string;
  UnmovableJobID, CurJobKey, Res: integer;
  NextJob, CurJob: TJobParams;
  JobIndex: Integer;
  WasRemoved: boolean;
begin
  Result := false;
  w := PlanFrame.CurrentWorkload;
  Applied := false;

  AnyStart := Job.AnyStart;    // начало заданной работы
  AnyFinish := Job.AnyFinish;  // окончание заданной работы

  // временно удаляем работу из общего списка, чтобы не мешала
  if w.JobList.IndexOf(Job) <> -1 then
  begin
    w.JobList.Remove(Job);
    w.SortJobs;
    WasRemoved := true;
  end
  else
    WasRemoved := false;

  try
    //while RepeatCheck do
    repeat
      RepeatCheck := false;
    //begin
      for JobIndex := 0 to w.JobList.Count - 1 do
      begin
        CurJob := w.JobList[JobIndex];
        if Job.JobID <> CurJob.JobID then
        begin
          AfterUnmovable := false;
          CanMove := true;
          // Находим работы, начинающиеся раньше и заканчивающиеся позже начала нашей работы.
          // Ставим нашу работу после найденной.
          { ======= CurJob =======>
                  =========== Job ==========> }
          if (CurJob.AnyStart < AnyStart) and (CurJob.AnyFinish > AnyStart)
            and (SecondsBetween(CurJob.AnyFinish, AnyStart) > 1) then
          begin
            //CanMove := true;
            AfterUnmovable := true;
          end
          // Находим работы, начинающиеся позже начала и раньше окончания нашей работы.
          // Или начала работысовпадают.
          {             ======= CurJob =======>
             =========== Job ==========> }
          else
          if (CurJob.AnyStart >= AnyStart) and (CurJob.AnyStart < AnyFinish)
            and (SecondsBetween(CurJob.AnyStart, AnyFinish) > 1) then
          begin
            // Проверяем, можно ли сдвинуть работы...
            TLogger.GetInstance.Debug('Проверяем, можно ли сдвинуть работы...');
            // Если фактические отметки, то сдвигать нельзя (на всякий случай проверка)
            CanMove := CheckCanMove(CurJob, false); // без сообщения
            if CanMove then
            begin
              // Запоминаем текущую позицию
              CurJobKey := CurJob.JobID;
              // Сразу ставим на место исходную работу
              GetAdapter(w).UpdatePlan(Job);
              Applied := true;
              // Сдвигаем эту работу и все что за ней
              MoveFromJobDown(w, CurJob, AnyFinish);
              DumpWorkload(w, 'CheckMovingJob, after MoveFromJobDown');
              Result := true;
              Exit;
            end;
          end;

          if not CanMove then
          begin
            // сдвинуть перекрывающуюся работу нельзя, поэтому пытаемся найти место, куда можно поставить эту работу
            UnmovableJobID := CurJob.JobID;
            // Если начала работ очень близки, то ставим после неперемещаемой...
            if (MinuteSpan(AnyStart, CurJob.AnyStart) < MIN_JOB)
               or (CurJob.AnyStart < AnyStart) and (CurJob.AnyFinish > AnyStart) then
              AfterUnmovable := true
            else
            begin
              // ... иначе есть два варианта - поместить после или разбить
              AfterUnmovable := not ExecJobOverlapForm(GetJobName(Job), AnyStart, AnyFinish,
                  GetJobName(CurJob), CurJob.AnyStart, CurJob.AnyFinish);
              if not AfterUnmovable then
              begin
                Result := SplitJobAroundUnmovable(w, Job, CurJob);
                Exit;
              end;
            end;
          end;

          if AfterUnmovable then
          begin
            LocateMovableJob(w, CurJob, Job.JobID, AnyFinish - AnyStart);
            // CurJob - работа, после которой можно поставить
            Job.PlanStart := CurJob.AnyFinish;
            Job.PlanFinish := CurJob.AnyFinish + AnyFinish - AnyStart;
            AnyStart := Job.AnyStart;    // начало заданной работы
            AnyFinish := Job.AnyFinish;  // окончание заданной работы
            // Повторяем проверку сначала, потому что после CurJob может быть сдвигаемая работа
            RepeatCheck := true;
            continue;
          end;
        end;
      end;
      // Прошли все работы, можно выходить
      //RepeatCheck := false;
    //end
    until not RepeatCheck;
    // Теперь ставим на место работу с которой все и началось
    if not Applied then
      GetAdapter(w).UpdatePlan(Job);
    Result := true;
  finally
    // Если удаляли работу из списка, возврашаем обратно
    if WasRemoved then
    begin
      w.JobList.Add(Job);
      w.SortJobs;
    end;
  end;
end;

function DoExecJobSplitForm(var SplitMode: TSplitMode;
  AllowSplitQuantity, AllowSplitMult, AllowSplitSide: boolean;
  Params: pointer): boolean;
begin
  Result := ExecJobSplitForm(SplitMode, AllowSplitQuantity, AllowSplitMult, AllowSplitSide);
end;

type
  TSelectSplitFunc = function(var SplitMode: TSplitMode;
    AllowSplitQuantity, AllowSplitMult, AllowSplitSide: boolean;
    Params: pointer): boolean;

// определяет, как разбивать работу
function GetSplitModeEx(Job: TJobParams; var SplitMode: TSplitMode;
   SelectFunc: TSelectSplitFunc; Params: pointer; AlwaysAsk: boolean): boolean;
var
  AllowSplitMult, AllowSplitSide: boolean;
begin
  AllowSplitMult := Job.Multiplier > 1;
  AllowSplitSide := Job.SideCount > 1;
  Result := true;

  if VarIsNull(Job.SplitMode1) then  // еще не разбита
    Result := SelectFunc(SplitMode, true, AllowSplitMult, AllowSplitSide, Params)
  else
  if (TSplitMode(NvlInteger(Job.SplitMode1)) = smQuantity) and not VarIsNull(Job.SplitPart1) then
  begin
    if VarIsNull(Job.SplitMode2) then  // второй разбивки еще нет вообще
      Result := SelectFunc(SplitMode, true, AllowSplitMult, AllowSplitSide, Params)
    else
    if Job.SplitMode2 = smMultiplier then
    begin
      if NvlInteger(Job.SplitPart2) = 0 then
      begin
        // другой интервал тиража уже разбит по листам, значит можно бить только по листам
        SplitMode := smMultiplier;
        if AlwaysAsk then
          Result := SelectFunc(SplitMode, false, true, false, Params);
      end
      else
      begin
        // новая разбивка - осталось только по сторонам
        Result := AllowSplitSide;
        SplitMode := smSide;
        if AlwaysAsk and Result then
          Result := SelectFunc(SplitMode, false, false, true, Params);
      end;
    end
    else
    if Job.SplitMode2 = smSide then
    begin
      if NvlInteger(Job.SplitPart2) = 0 then
      begin
        // другой интервал тиража уже разбит по сторонам, значит можно бить только по сторонам
        SplitMode := smSide;
        if AlwaysAsk then
          Result := SelectFunc(SplitMode, false, false, true, Params);
      end
      else
      begin
        // новая разбивка - осталось только по листам
        Result := AllowSplitMult;
        SplitMode := smMultiplier;
        if AlwaysAsk and Result then
          Result := SelectFunc(SplitMode, false, true, false, Params);
      end;
    end;
  end
  else
  if (TSplitMode(NvlInteger(Job.SplitMode1)) = smMultiplier) and not VarIsNull(Job.SplitPart1) then
  begin
    if VarIsNull(Job.SplitMode2) then  // второй разбивки еще нет вообще
      Result := SelectFunc(SplitMode, true, false, AllowSplitSide, Params)
    else
    if Job.SplitMode2 = smQuantity then
    begin
      if NvlInteger(Job.SplitPart2) = 0 then
      begin
        // другой лист уже разбит по тиражу, значит можно бить только по тиражу
        SplitMode := smQuantity;
        if AlwaysAsk then
          Result := SelectFunc(SplitMode, true, false, false, Params);
      end
      else
      begin
        // новая разбивка - осталось только по сторонам
        Result := AllowSplitSide;
        SplitMode := smSide;
        if AlwaysAsk and Result then
          Result := SelectFunc(SplitMode, false, false, true, Params);
      end;
    end
    else
    if Job.SplitMode2 = smSide then
    begin
      if NvlInteger(Job.SplitPart2) = 0 then
      begin
        // другой лист уже разбит по сторонам, значит можно бить только по сторонам
        SplitMode := smSide;
        if AlwaysAsk then
          Result := SelectFunc(SplitMode, false, false, true, Params);
      end
      else
      begin
        // новая разбивка - осталось только по тиражу
        SplitMode := smQuantity;
        if AlwaysAsk then
          Result := SelectFunc(SplitMode, true, false, false, Params);
      end;
    end;
  end
  else
  if (TSplitMode(NvlInteger(Job.SplitMode1)) = smSide) and not VarIsNull(Job.SplitPart1) then
  begin
    if VarIsNull(Job.SplitMode2) then  // второй разбивки еще нет вообще
      Result := SelectFunc(SplitMode, true, false, AllowSplitSide, Params)
    else
    if Job.SplitMode2 = smQuantity then
    begin
      if NvlInteger(Job.SplitPart2) = 0 then
      begin
        // другой лист уже разбит по тиражу, значит можно бить только по тиражу
        SplitMode := smQuantity;
        if AlwaysAsk then
          Result := SelectFunc(SplitMode, true, false, false, Params);
      end
      else
      begin
        // новая разбивка - осталось только по сторонам
        Result := AllowSplitSide;
        SplitMode := smSide;
        if AlwaysAsk and Result then
          Result := SelectFunc(SplitMode, false, false, true, Params);
      end;
    end
    else
    if Job.SplitMode2 = smSide then
    begin
      if NvlInteger(Job.SplitPart2) = 0 then
      begin
        // другой лист уже разбит по сторонам, значит можно бить только по сторонам
        SplitMode := smSide;
        if AlwaysAsk then
          Result := SelectFunc(SplitMode, false, false, true, Params);
      end
      else
      begin
        // новая разбивка - осталось только по тиражу
        SplitMode := smQuantity;
        if AlwaysAsk then
          Result := SelectFunc(SplitMode, true, false, false, Params);
      end;
    end;
  end;
end;

// Работы в Jobs не должны быть в списке работ!
procedure TPlanController.PlaceJobs(w: TWorkload; Jobs: TJobList);
var
  CurPlanFinish: TDateTime;
  NewJob, NextJob: TJobParams;
  I, J: integer;
begin
  for I := 0 to Jobs.Count - 1 do
  begin
    NewJob := Jobs[I];
    w.JobList.Add(NewJob);
    w.SortJobs;
    CurPlanFinish := NewJob.PlanFinish;
    DumpWorkload(w, 'PlaceJobs, before CheckMovingJob');
    // TODO: может не получиться установка на нужное место. ПРОВЕРИТЬ!
    if CheckMovingJob(NewJob.ItemID, NewJob) then
      //w.Reload;
      ;
    DumpWorkload(w, 'PlaceJobs, after CheckMovingJob 1');
    // Если работа передвинулась вперед, то надо сдвинуть все остальные, которые идут после нее
    if (NewJob.PlanFinish > CurPlanFinish) and (I < Jobs.Count - 1) then
    begin
      for J := I + 1 to Jobs.Count - 1 do
      begin
        NextJob := Jobs[J];
        NextJob.PlanStart := NextJob.PlanStart + (NewJob.PlanFinish - CurPlanFinish);
        NextJob.PlanFinish := NextJob.PlanFinish + (NewJob.PlanFinish - CurPlanFinish);
      end;
    end;
    DumpWorkload(w, 'PlaceJobs, after CheckMovingJob 2');
  end;
end;

// определяет, как разбивать работу, при выборе запрашивает пользователя
function GetSplitMode(Job: TJobParams; var SplitMode: TSplitMode): boolean;
begin
  Result := GetSplitModeEx(Job, SplitMode, DoExecJobSplitForm, nil, false);
end;

function TPlanController.SplitJobAroundUnmovable(w: TWorkload; Job: TJobParams; UnmovableJob: TJobParams): boolean;
var
  NewJob, UnmovableJob1: TJobParams;
  Half2Duration: extended;
  WasAdded: boolean;
  SplitMode: TSplitMode;
  Half2JobID, m: integer;

  procedure ByMultiplier;
  var
    I: integer;
    SplitJobIDs: TIntArray;
    SplitJobs: TJobList;
  begin
    TLogger.GetInstance.Debug('CheckMovingJob: разбиваем по множителю на ' + VarToStr(Job.Multiplier) + ' интервалов');
    SplitJobIDs := SplitJobByMultiplier(w, Job, true);  // auto
    SplitJobs := TJobList.Create;
    try
      // изымаем получившиеся интервалы из плана и добавляем их по одному, иначе они перепутаются
      for I := Low(SplitJobIDs) to High(SplitJobIDs) do
      begin
        NewJob := w.JobList.GetJob(SplitJobIDs[I]);
        w.JobList.Remove(NewJob);
        SplitJobs.Add(NewJob);
      end;

      // теперь проверяем и передвигаем интервалы, если они перекрываются с чем-либо
      PlaceJobs(w, SplitJobs);
    finally
      SplitJobs.Free;
    end;
    CheckShifts;
  end;

  procedure ByQuantity;
  var
    UnmovableJob1: TJobParams;
  begin
    // Длительность второй половины
    Half2Duration := Job.AnyFinish - Job.AnyStart - (UnmovableJob.AnyStart - Job.AnyStart);
    // надо определить, встанет ли вторая половина после несдвигаемой работы
    UnmovableJob1 := UnmovableJob;
    LocateMovableJob(w, UnmovableJob1, Job.JobID, Half2Duration);
    // разбиваем работу по тиражу, вторую половину ставим после несдвигаемой работы
    Half2JobID := SplitJobByQuantityEx(w, Job, true, Job.AnyStart, UnmovableJob.AnyStart, UnmovableJob1.AnyFinish,
    UnmovableJob1.AnyFinish + Half2Duration);
    NewJob := w.JobList.GetJob(Half2JobID);
    DumpWorkload(w, 'SplitJobAroundUnmovable, before CheckMovingJob');
    // TODO: может не получиться установка хвоста на нужное место. ПРОВЕРИТЬ!
    if CheckMovingJob(NewJob.ItemID, NewJob) then
      //w.Reload;
      ;
    DumpWorkload(w, 'SplitJobAroundUnmovable, after CheckMovingJob');
    CheckShifts;
  end;

  procedure BySides;
  begin
    // Надо определить, встанет ли одна сторона после несдвигаемой работы.
    // Определяем длительность первой стороны в минутах.
    m := Trunc(MinuteSpan(Job.AnyFinish, Job.AnyStart) / 2);
    // Определяем длительность второго листа.
    Half2Duration := Job.AnyFinish - IncMinute(Job.AnyStart, m);
    UnmovableJob1 := UnmovableJob;
    if LocateMovableJob(w, UnmovableJob1, Job.JobID, Half2Duration) then
    begin
      TLogger.GetInstance.Debug('CheckMovingJob: разбиваем по стороне на 2 интервала');
      Half2JobID := SplitJobBySides(w, Job, true);  // auto
      NewJob := w.JobList.GetJob(Half2JobID);
      // TODO: может не получиться установка хвоста на нужное место. ПРОВЕРИТЬ!
      if CheckMovingJob(NewJob.ItemID, NewJob) then
        //w.Reload;
        ;
      CheckShifts;
    end;
  end;

begin
  if w.JobList.IndexOf(Job) = -1 then
  begin
    w.JobList.Add(Job);
    w.SortJobs;
    WasAdded := true;
  end
  else
    WasAdded := false;

  try
    (*// Если последняя разбивка - по тиражу, то по тиражу и бьем
    // сначала разбиваем по листам, если они есть
    if not Job.HasSplitMode(smMultiplier) and (Job.Multiplier > 1) then
    begin
      // листы есть, но разбивки интервала нет
      if (Job.SplitMode2 = smMultiplier) and (NvlInteger(Job.SplitPart2) = 0) then
        SplitMode := smMultiplier;
      //elsedfg ge ghef
      SplitMode := smMultiplier;
      if not Job.HasSplitMode(smSide) and (NvlInteger(Job.SideCount) > 1) then
        ExecJobSplitForm(SplitMode, true, true)
      else
        ExecJobSplitForm(SplitMode, true, false);
      if SplitMode = smMultiplier then
      begin
        ByMultiplier;
        Result := true;
      end
      else
      begin
        BySides;
        Result := true;
      end;
    end
    else
    // потом по сторонам, если они есть
    if not Job.HasSplitMode(smSide) and (NvlInteger(Job.SideCount) > 1) then
    begin
      // разбивка по листам уже есть
      if (Job.SplitMode2 = smQuantity) and (NvlInteger(Job.SplitPart2) = 0) then
        // другой лист уже разбит по тиражу, бьем этот по тиражу
        SplitMode := smQuantity
      else if (Job.SplitMode2 = smMultiplier) and (Job.Multiplier > 1) and (NvlInteger(Job.SplitPart2) = 0) then
        // другая часть тиража уже разбита по листам, бьем эту часть по листам
        SplitMode := smMultiplier
      else if (Job.SplitMode2 = smSide) and (NvlInteger(Job.SplitPart2) = 0) then
        // другой лист уже разбит по сторонам, бьем этот по по сторонам
        SplitMode := smSide
      else
      begin
        SplitMode := smSide;
        ExecJobSplitForm(SplitMode, false, true);
      end;

      if SplitMode = smSide then
        BySides
      else if SplitMode = smQuantity then
        ByQuantity
      else
        ByMultiplier;

      Result := true;
    end
    else   // по тиражу
    begin
      ByQuantity;
      Result := true;
    end;

    if not Result then
    begin
      RusMessageDlg('Не найдено свободное место', mtError, [mbOk], 0);
      Result := false;
    end;*)
    if not GetSplitMode(Job, SplitMode) then
    begin
      RusMessageDlg('Работу разбить не удалось', mtError, [mbOk], 0);
      Result := false;
    end
    else
    begin
      if SplitMode = smSide then
        BySides
      else if SplitMode = smQuantity then
        ByQuantity
      else
        ByMultiplier;
      Result := true;
    end;

  finally
    if WasAdded then
    begin
      w.JobList.Remove(Job);
      w.SortJobs;
    end;
  end;
end;

// Определяет есть ли пересечения со сменами, и возвращает дату начала смены
function TPlanController.IntersectShift(w: TWorkload; Job: TJobParams; var ShiftStart: TDateTime): boolean;
var
  I: Integer;
begin
  for I := 0 to w.ShiftList.Count - 1 do
  begin
    ShiftStart := w.ShiftList[I].Start;
    if (ShiftStart > Job.AnyStart) and (ShiftStart < Job.AnyFinish)
      and (SecondsBetween(ShiftStart, Job.AnyStart) > 1)
      and (SecondsBetween(ShiftStart, Job.AnyFinish) > 1) then
    begin
      Result := true;
      Exit;
    end;
  end;
  Result := false;
end;

function CanMerge(Job: TJobParams): boolean;
begin
  Result := VarIsNull(Job.FactStart) and VarIsNull(Job.FactStart) and (Job.JobType = 0)
        and Job.AutoSplit and (Job.HasSplitMode(smQuantity) or Job.HasSplitMode(smSide));
  // работы, разбитые на листы или стороны, тоже можно слить, если они принадлежат к одному интервалу,
  // поэтому не отсеиваем их сразу
end;

type
  TSplitParams = record
    AtShiftStart: boolean;
    ShiftStart: TDateTime;
    Job: TJobParams;
  end;

function DoExecJobSplitShiftForm(var SplitMode: TSplitMode;
  AllowSplitQuantity, AllowSplitMult, AllowSplitSide: boolean;
  Params: pointer): boolean;
begin
  Result := ExecJobSplitShiftForm(SplitMode, TSplitParams(Params^).AtShiftStart,
    AllowSplitQuantity, AllowSplitMult, AllowSplitSide, TSplitParams(Params^).Job, TSplitParams(Params^).ShiftStart);
end;

function TPlanController.CheckShiftOverlap(w: TWorkload; Job: TJobParams): boolean;
var
  //WasSplit: boolean;
  RepeatCheck: boolean;
  ShiftStart: TDateTime;
  SplitJobID, CurJobID: integer;
  SplitParams: TSplitParams;
  SplitMode: TSplitMode;
  FinishTime: TDateTime;
  SplitJob: TJobParams;
begin
  RepeatCheck := false;
  if IntersectShift(w, Job, ShiftStart) then     // пересечение
  begin
    //WasSplit := false;
    TLogger.GetInstance.Debug('CheckShifts: найдено пересечение с границей смены у работы AnyStart = ' + DateTimeToStr(Job.AnyStart)
      + ', AnyFinish = ' + DateTimeToStr(Job.AnyFinish)
      + ' ShiftStart = ' + DateTimeToStr(ShiftStart));
    CurJobID := Job.JobID;

    SplitParams.AtShiftStart := false;
    SplitParams.ShiftStart := ShiftStart;
    SplitParams.Job := Job;
    // Всегда показывать окно выбора, т.к. там есть еще возможность поставить на начало смены,
    // поэтому AlwaysAsk = true.
    if GetSplitModeEx(Job, SplitMode, DoExecJobSplitShiftForm, @SplitParams, true) then
    begin
      if not SplitParams.AtShiftStart then
      begin
        if SplitMode = smQuantity then
        begin
          TLogger.GetInstance.Debug('CheckShifts: разбиваем по тиражу на 2 интервала');
          FinishTime := Job.AnyFinish;
          SplitJobID := SplitJobByQuantityEx(w, Job, true, Job.AnyStart, ShiftStart,
            ShiftStart, FinishTime);
          // нам вернули ключ второго интервала, ставим фактич. отметки, если работа отмечена как завершенная
          if not VarIsNull(Job.FactFinish) then
            GetAdapter(w).UpdateFact(SplitJobID, ShiftStart, FinishTime);
          SplitJob := w.JobList.GetJob(SplitJobID);
          if CheckMovingJob(SplitJob.ItemID, SplitJob) then
            //w.ReloadLocate(CurJobID);
            ;
          //WasSplit := true;
          RepeatCheck := false;
        end
        else if SplitMode = smSide then
        begin
          TLogger.GetInstance.Debug('CheckShifts: разбиваем по сторонам на 2 интервала');
          SplitJobBySides(w, Job, true);  // auto
          //WasSplit := true;
          RepeatCheck := true;
        end
        else if SplitMode = smMultiplier then
        begin
          TLogger.GetInstance.Debug('CheckShifts: разбиваем по множителю на ' + VarToStr(Job.Multiplier) + ' интервалов');
          SplitJobByMultiplier(w, Job, true);  // auto
          //WasSplit := true;
          RepeatCheck := true;
        end;
      end
      else // Ставим в начало следующей смены
      begin
        FinishTime := ShiftStart + (Job.PlanFinish - Job.PlanStart);
        Job.PlanStart := ShiftStart;
        Job.PlanFinish := FinishTime;
        CheckMovingJob(Job.ItemID, Job);
        RepeatCheck := true;
      end;
    end
    else ;// TODO: не знаю, попадет ли сюда?
  end;
  Result := RepeatCheck;
end;

// Обновляет отметки в работах о том, перекрываются ли они со сменами
procedure TPlanController.UpdateOverlaps(w: TWorkload);
var
  JobIndex: integer;
  Job: TJobParams;
  ShiftStart: TDateTime;
begin
  for JobIndex := 0 to w.JobList.Count - 1 do
  begin
    Job := w.JobList[JobIndex];
    Job.OverlapShift := IntersectShift(w, Job, ShiftStart);
  end;
end;

// В режиме непрерывного отображения делит работы, попадающие на границы смен,
// и объединяет работы, которые были раньше разбиты границей смены, а теперь нет.
// Возвращает true, если были изменения и план перезагружен
function TPlanController.CheckShifts: boolean;
var
  //ds: TDataSet;
  SaveJobID, CurItemID, SaveShiftID, sn,
  SplitPartSide, SplitPartMult, SplitPartQuantity: integer;
  w: TWorkload;
  RepeatCheck, AllowMerge{, AtShiftStart}: boolean;
  CurJob, Job: TJobParams;
  sm1, sm2, sm3: variant;
  ShiftIndex, JobIndex: Integer;
  Shift: TShiftInfo;
  FinishTime: TDateTime;

  procedure SaveJob;
  begin
    CurJob := Job;
    //CurItemID := w.ItemID;
    // Запоминаем сторону и лист
    if Job.HasSplitMode(smMultiplier) then
      SplitPartMult := Job.GetSplitPart(smMultiplier)
    else
      SplitPartMult := 0;
    if Job.HasSplitMode(smSide) then
      SplitPartSide := Job.GetSplitPart(smSide)
    else
      SplitPartSide := 0;
    if Job.HasSplitMode(smQuantity) then
      SplitPartQuantity := Job.GetSplitPart(smQuantity)
    else
      SplitPartQuantity := 0;
  end;

  function GetSplitModeNum(Job: TJobParams; SplitMode: TSplitMode): integer;
  begin
    if Job.SplitMode1 = SplitMode then
      Result := 1
    else if Job.SplitMode2 = SplitMode then
      Result := 2
    else if Job.SplitMode3 = SplitMode then
      Result := 3
    else
      Result := 0;
  end;

begin
  Result := false;
  w := PlanFrame.CurrentWorkload;

  if not ContinuousMode(w) then Exit;

  if not EntSettings.SplitJobs then
  begin
    UpdateOverlaps(w);
  end
  else
  begin
    SplitPartMult := 0;
    SplitPartSide := 0;
    SplitPartQuantity := 0;
    SaveJobID := w.KeyValue;
    RepeatCheck := true;
    while RepeatCheck do    // поиск пересечений может быть повторен
    begin
      //RepeatCheck := false;
      for JobIndex := 0 to w.JobList.Count - 1 do
      begin
        Job := w.JobList[JobIndex];
        RepeatCheck := CheckShiftOverlap(w, Job);
      end;
    end;
  end;

  // Теперь надо проверить, можно ли склеить некоторые работы, которые были разбиты ранее
  SaveShiftID := 0;
  for ShiftIndex := 0 to w.ShiftList.Count - 1 do
  begin
    CurJob := nil;
    Shift := w.ShiftList[ShiftIndex];
    JobIndex := 0;
    while JobIndex < Shift.JobList.Count do
    begin
      Job := Shift.JobList[JobIndex];
      // если нет факт. отметок, то будем дальше проверять, можно ли к этой работе приклеить другую
      if (CurJob = nil) and CanMerge(Job) then
      begin
        SaveJob;
      end
      // если интервал той же работы и нет факт. отметок и разбита автоматически
      else if (CurJob <> nil) and (CurJob.ItemID = Job.ItemID) and (CurJob.ItemID <> 0) and CanMerge(Job) then
      begin
        sm1 := Job.SplitMode1;
        sm2 := Job.SplitMode2;
        sm3 := Job.SplitMode3;
        sn := 0;
        // по одному виду разбивки
        AllowMerge := (sm1 = smSide) and (NvlInteger(Job.SplitPart2) = 0) and (SplitPartQuantity = 0) and (SplitPartMult = 0)
            or (sm1 = smQuantity) and (NvlInteger(Job.SplitPart2) = 0) and (SplitPartSide = 0) and (SplitPartMult = 0);
        if AllowMerge then
          sn := GetSplitModeNum(Job, sm1)  // определяем, по какому полю обновляется разбивка
        else
        begin
          // по стороне, потом по тиражу - интервалы одной стороны
          AllowMerge := ((sm1 = smSide) and (sm2 = smQuantity) and (NvlInteger(Job.SplitPart3) = 0) and (SplitPartMult = 0) and (SplitPartSide = Job.SplitPart1))
            or ((sm2 = smSide) and (sm3 = smQuantity) and (SplitPartMult = Job.SplitPart1) and (SplitPartSide = Job.SplitPart2));
          if AllowMerge then
            sn := GetSplitModeNum(Job, smQuantity)
          else
          begin
            // по стороне, потом по листам
            {AllowMerge := ((sm1 = smSide) and (sm2 = smMultiplier) and (NvlInteger(Job.SplitPart3) = 0) and (SplitPartSide = Job.SplitPart1))
              or ((sm2 = smSide) and (sm3 = smMultiplier) and (SplitPartQuantity = Job.SplitPart1) and (SplitPartSide = Job.SplitPart2));
            if AllowMerge then
              sn := GetSplitModeNum(smMultiplier)
            else
            begin}
              // по листам, потом по тиражу - интервалы одного листа
              AllowMerge := ((sm1 = smMultiplier) and (sm2 = smQuantity) and (NvlInteger(Job.SplitPart3) = 0) and (SplitPartSide = 0) and (SplitPartMult = Job.SplitPart1))
                or ((sm2 = smMultiplier) and (sm3 = smQuantity) and (SplitPartSide = Job.SplitPart1) and (SplitPartMult = Job.SplitPart2));
              if AllowMerge then
                sn := GetSplitModeNum(Job, smQuantity)
              else
              begin
                // по листам, потом по стороне
                AllowMerge := ((sm1 = smMultiplier) and (sm2 = smSide) and (NvlInteger(Job.SplitPart3) = 0) and (SplitPartQuantity = 0) and (SplitPartMult = Job.SplitPart1))
                  or ((sm2 = smMultiplier) and (sm3 = smSide) and (SplitPartQuantity = Job.SplitPart1) and (SplitPartMult = Job.SplitPart2));
                if AllowMerge then
                  sn := GetSplitModeNum(Job, smSide)
                else
                begin
                  // по тиражу, потом по листам
                  {AllowMerge := ((sm1 = smQuantity) and (sm2 = smMultiplier) and (NvlInteger(w.SplitPart3) = 0) and (SplitPartQuantity = w.SplitPart1))
                    or ((sm2 = smQuantity) and (sm3 = smMultiplier) and (SplitPartSide = w.SplitPart1) and (SplitPartQuantity = w.SplitPart2));
                  if AllowMerge then
                    sn := GetSplitModeNum(smMultiplier)
                  else
                  begin}
                    // по тиражу, потом по стороне
                    AllowMerge := ((sm1 = smQuantity) and (sm2 = smSide) and (NvlInteger(Job.SplitPart3) = 0) and (SplitPartMult = 0) and (SplitPartQuantity = Job.SplitPart1))
                      or ((sm2 = smQuantity) and (sm3 = smSide) and (SplitPartMult = Job.SplitPart1) and (SplitPartQuantity = Job.SplitPart2));
                    if AllowMerge then
                      sn := GetSplitModeNum(Job, smSide);
                  //end;
                end;
              end;
            //end;
          end;
        end;

        if sn > 0 then
        begin
          // ... то склеиваем (удаляем текущую, первой устанавливаем время окончания текущей)
          FinishTime := Job.PlanFinish;
          GetAdapter(w).RemoveJob(Job);
          Dec(JobIndex); // возвращаемся на предыдущую, т.к. удалили
          // обновляем длительность
          GetAdapter(w).UpdatePlan(CurJob.JobID, CurJob.PlanStart, FinishTime);
          // перенумеровываем интервалы разбивки
          RenumberItemJobs(w, CurJob, sn);
          //CurJob.PlanFinish := FinishTime;
        end
        else
        begin
          SaveJob;
        end;
      end
      else
      begin
        SaveJob;
      end;
      Inc(JobIndex);
    end;
  end;
end;

function TPlanController.LocateLastPlannedJob(w: TWorkload): boolean;
var
  CurID, I: integer;
  Shift: TShiftInfo;
begin
  if ContinuousMode(w) then
  begin
    CurID := NvlInteger(w.KeyValue);
    Result := false;
    for I := w.JobList.Count - 1 downto 0 do
      if not VarIsNull(w.JobList[I].PlanStart) then
      begin
        w.Locate(w.JobList[I].JobID);
        Result := true;
        break;
      end;

    if not Result then
    begin
      // Найти сегодняшнюю смену
      Shift := w.GetShiftByDate(Now);
      if Shift <> nil then
        w.Locate(-Shift.Number)
      else
        w.Locate(CurID);
    end;
  end
  else
  begin
    w.DataSet.Last;
    Result := not w.IsEmpty;
  end;
end;

procedure TPlanController.ScriptError(_Process: TPolyProcessCfg; _ScriptFieldName: string;
   _ErrPos: integer; _Msg: string);
begin
  ScriptManager.ShowScriptError(_Process, _ScriptFieldName, _ErrPos, _Msg, TSettingsManager.Instance.Storage);
end;

procedure TPlanController.RefreshData;
begin                                   
  Plan.Close;
  HandleUpdateCriteria(nil);
end;

{function TPlanView.FindStartTime(cdDay: TDataSet; var StartTime: TDateTime): boolean;
begin
end;}

procedure TPlanController.CreateWorkloads;
var
  de: TDictionary;
  w: TWorkload;
  Adapter: TScheduleAdapter;
begin
  de := TConfigManager.Instance.StandardDics.deEquip;
  if de <> nil then
  begin
    FWorkloads := TList.Create;
    FAdapters := TList.Create;
    // TODO! DepartmentID берется первый попавшийся
    FShiftEmployees := TShiftEmployees.Create(TConfigManager.Instance.StandardDics.deDepartments.CurrentID);
    FShiftAssistants := TShiftAssistants.Create(TConfigManager.Instance.StandardDics.deDepartments.CurrentID);

    de.DicItems.First;
    while not de.DicItems.Eof do
    begin
      if NvlBoolean(de.CurrentEnabled) and (de.CurrentValue[1] = Plan.EquipGroupCode) then
      begin
        w := TWorkload.Create(de.CurrentCode);
        w.ShiftEmployees := FShiftEmployees;
        w.ShiftAssistants := FShiftAssistants;
        w.OnScriptError := ScriptError;
        FWorkloads.Add(w);
        Adapter := TCachedScheduleAdapter.Create;
        (Adapter as TCachedScheduleAdapter).Workload := w;
        (Adapter as TCachedScheduleAdapter).EnableUndo := FEnableUndo;
        FAdapters.Add(Adapter);
      end;
      de.DicItems.Next;
    end;
  end
  else
    raise Exception.Create('Не найден справочник оборудования');
end;


procedure TPlanController.UpdateActionState;
begin
  TMainActions.GetAction(TMainActions.Reload).Enabled := true;
end;

procedure TPlanController.Activate;
begin
  TMainActions.SetActionsEnabled(TOrderActions.All, false);
  FNeedRefresh := false;
  try
    TPlanFrame(FFrame).Activate;
    UpdateActionState;
  finally
    FNeedRefresh := true;
  end;
end;

function TPlanController.GetPlanFrame: TPlanFrame;
begin
  Result := TPlanFrame(FFrame);
end;

procedure TPlanController.LaunchReport(Sender: TObject);
var
  Rpt: TBaseReport;
  StartRow, StartCol, ColCount: integer;
  FileName, RptCaption, ReportFields: string;
  DataSet: TDataSet;
  V: Variant;
  r, c, ShiftRowCount, SpecialRowCount, CommentRowCount: integer;
  FName: string;
  CurDate: TDateTime;
  w: TWorkload;
  F: TField;
  _ContinuousMode: boolean;
  SkipFields: boolean;
  I, CurRow: Integer;
  ShiftRows, SpecialRows, CommentRows: TIntArray;
begin
  FileName := NvlString(TConfigManager.Instance.StandardDics.deEquipGroup.ItemValue[Plan.EquipGroupCode, 1]);
  if FileName = '' then
    FileName := 'EquipWorkload.xls';
  RptCaption := FCaption;
  ReportFields := NvlString(TConfigManager.Instance.StandardDics.deEquipGroup.ItemValue[Plan.EquipGroupCode, 2]);
  if ReportFields = '' then
    ReportFields := PlanFrame.GetWorkloadColumnFields;
  StartRow := 4;//Plan_GetReportStartRow;
  StartCol := 1;//Plan_GetReportStartCol;
  w := CurrentWorkload;
  _ContinuousMode := ContinuousMode(w);

  Rpt := ScriptManager.OpenReport(ExtractFileDir(ParamStr(0)) + '\' + FileName);
  if Rpt <> nil then
  begin
    Rpt.WinCaption1 := 'Excel -::- PolyMix'; // Изменение заголовка окна
    Rpt.WinCaption2 := RptCaption; //Plan_GetReportCaption;
    Rpt.FontApplied := false;
    DataSet := w.DataSet;

    ColCount := CountOfChar(';', ReportFields) + 1;
    CurDate := PlanFrame.WorkDate;
    if (ColCount > 0) and (DataSet.RecordCount > 0) then
    begin
      // список номеров строк со спецработами
      SpecialRowCount := 0;
      SetLength(SpecialRows, DataSet.RecordCount);
      CommentRowCount := 0;
      SetLength(CommentRows, DataSet.RecordCount);
      if _ContinuousMode then
      begin
        // список номеров строк с названиями смен
        ShiftRowCount := 0;
        SetLength(ShiftRows, DataSet.RecordCount);
      end;

      V := VarArrayCreate([1, DataSet.RecordCount * 2, 1, ColCount], varVariant);
      DataSet.First;
      r := 1;
      while not DataSet.eof do
      begin
        SkipFields := false;
        if _ContinuousMode then
        begin
          if w.IsShiftMarker then
          begin
            V[r, 2] := ' ' + w.Comment + '  ' + NvlString(w.OperatorName);
            ShiftRows[ShiftRowCount] := r;
            Inc(ShiftRowCount);
            //TLogger.GetInstance.Info('Workload report shift marker: r = ' + VarToStr(r) + ', ' + VarToStr(w.JobComment));
            V[r, 1] := w.AnyStartDateTime;
            //V[r, 2] := w.AnyFinishDateTime;
            SkipFields := true;  // название смены - пропускаем все поля
          end;
        end
        else
          // Если другой день, то вставляем его дату, и он становится новым текущим днем
          if not SameDay(w.RangeStart, CurDate, DataSet['PlanStartDate']) then
          begin
            V[r, 1] := DateToStr(DataSet['PlanStartDate']);
            CurDate := DataSet['PlanStartDate'];
            r := r + 1;
          end;

        // Если было название смены - пропускаем все поля
        if not SkipFields then
        begin
          if w.JobType >= JobType_Special then
          begin
            // Спец работа - только название
            V[r, 1] := w.AnyStartDateTime;
            V[r, 2] := w.AnyFinishDateTime;
            V[r, 3] := w.PlanDuration;
            V[r, 4] := w.Comment;
            SpecialRows[SpecialRowCount] := r;
            Inc(SpecialRowCount);
          end
          else
          begin
            // обычная работа
            for c := 1 to ColCount do
            begin
              FName := SubStrBySeparator(ReportFields, c - 1, ';');
              F := DataSet.FieldByName(FName);
              // ставим галочку Wingdings на булевых полях
              if F is TBooleanField then
              begin
                if NvlBoolean(F.Value) then
                  V[r, c] := #$FC;
              end
              else
              if F is TStringField then
                V[r, c] := ReplaceStr(ReplaceStr(NvlString(F.Value), #9, ' '), #13, #10)
              else
              if TPlanFrame(FFrame).GetColumnTag(TPlanFrame(FFrame).CurrentWorkloadGrid, F.FieldName) = CellTag_DateTimeIcon then
              begin
                // хитрая обработка даты ожидания материала
                if VarIsNull(F.Value) then
                  V[r, c] := 'нет'
                else if YearOf(F.Value) = 1900 then
                  V[r, c] := 'получена'
                else
                  V[r, c] := 'ожидание' + #10 + FormatDateTime('dd.mm', F.Value);
              end
              else  // Если не включен просмотр стоимости, а поле указано, то пустышку пишем
              if not Options.ScheduleShowCost and (CompareText(FName, TWorkload.F_JobCost) = 0) then
                V[r, c] := ''
              else
              if CompareText(FName, TWorkload.F_Executor) = 0 then
                V[r, c] := NvlString(TConfigManager.Instance.StandardDics.deEmployees.ItemName[NvlInteger(F.Value)])
              else
                V[r, c] := F.Value;
              //TLogger.GetInstance.Info('Workload report: ' + FName + ' = ' + VarToStr(DataSet[FName]));
            end;
            // Если есть комментарий, то добавляем его как отдельную строку
            if Trim(NvlString(w.JobComment)) <> '' then
            begin
              r := r + 1;
              V[r, 5] := ReplaceStr(NvlString(w.JobComment), #13, #10);
              CommentRows[CommentRowCount] := r;
              Inc(CommentRowCount);
            end;
          end;
        end;

        r := r + 1;
        DataSet.Next;
      end;
      Rpt.CreateTable(V, StartRow, StartCol, false, false);
      Rpt.DrawAllFrames(StartRow, StartCol,
        StartRow + r - 1, StartCol + ColCount - 1);
      Rpt.AutoFitRows(StartRow, r);

      RptCaption := 'План для ' + TConfigManager.Instance.StandardDics.deEquip.ItemName[w.EquipCode];
      if not _ContinuousMode then
        RptCaption := RptCaption + '  (' + DateToStr(PlanFrame.WorkDate) + ')';
      Rpt.Cells[1, 1] := RptCaption + ' -- ' + FormatDateTime('dd/mm/yyyy hh:mm', Now);

      // рисуем названия смен
      if _ContinuousMode then
        for I := 0 to ShiftRowCount - 1 do
        begin
          CurRow := StartRow + ShiftRows[I] - 1;
          Rpt.MergeRowCells(CurRow, 2, CurRow, StartCol + ColCount - 1);
          Rpt.FontBold := true;
          Rpt.FontSize := 12;
          //Rpt.InteriorColorIndex := xlColor20;
          Rpt.HorizontalAlignment := xlHAlignLeft;
          Rpt.FormatRange(CurRow, 1, CurRow, 2, //frInteriorColorIndex  or
            frFontSize or frFontBold or frHorizontalAlignment);
          Rpt.SetRowHeight(CurRow, 27);
        end;

      // рисуем спец работы
      for I := 0 to SpecialRowCount - 1 do
      begin
        CurRow := StartRow + SpecialRows[I] - 1;
        Rpt.MergeRowCells(CurRow, 4, CurRow, StartCol + ColCount - 1);
        Rpt.FontBold := true;
        Rpt.FontSize := 12;
        Rpt.InteriorColorIndex := xlColor6;
        Rpt.HorizontalAlignment := xlHAlignCenter;
        Rpt.FormatRange(CurRow, 4, CurRow, 4, frInteriorColorIndex
          or frFontSize or frFontBold or frHorizontalAlignment);
        Rpt.SetRowHeight(CurRow, 27);
      end;

      // рисуем примечания
      for I := 0 to CommentRowCount - 1 do
      begin
        CurRow := StartRow + CommentRows[I] - 1;
        Rpt.MergeRowCells(CurRow, 5, CurRow, StartCol + ColCount - 1);
        Rpt.FontBold := true;
        //Rpt.FontSize := 10;
        Rpt.FontColorIndex := xlColor3;
        Rpt.FormatRange(CurRow, 5, CurRow, 5, frFontBold or frFontColorIndex);
        Rpt.AutoFitRows(CurRow, 1);
        if Rpt.GetRowHeight(CurRow) < 15 then
          Rpt.SetRowHeight(CurRow, 15);
        // объединяем ячейки с временем и номером заказа
        Rpt.MergeAllCells(CurRow - 1, 1, CurRow, 1);
        Rpt.MergeAllCells(CurRow - 1, 2, CurRow, 2);
        Rpt.MergeAllCells(CurRow - 1, 3, CurRow, 3);
        Rpt.MergeAllCells(CurRow - 1, 4, CurRow, 4);
      end;

      Rpt.Visible := true;
    end;
  end;
end;

procedure TPlanController.HandleAddSpecialJob(JobCode: integer);
var
  Estimated: integer;
  w: TWorkload;
  StartFound: boolean;
  StartTime: TDateTime;
  AddOk: Boolean;
  Job: TJobParams;
  Editable: boolean;
  JobComment: string;
begin
  AddOk := false;
  w := CurrentWorkload;

  if CheckLocked(w) then  // Если заблокирован, выходим
    Exit;

  StartFound := FindAvailableStart(w, StartTime, false);
  if StartFound then
  begin
    Editable := NvlBoolean(TConfigManager.Instance.StandardDics.deSpecialJob.ItemValue[JobCode, 6]);
    if Editable then
    begin
      JobComment := '';
      if ExecEditText('Описание работы', JobComment, true) then
        JobComment := Trim(JobComment)
      else
        Exit;
    end;

    Job := TJobParams.Create;
    Job.IsNew := true;
    Job.PlanStart := StartTime;
    Job.Executor := null; // лучше чем unassigned не выбивает KeyValue комбобокса
    Job.EstimatedDuration := NvlInteger(TConfigManager.Instance.StandardDics.deSpecialJob.ItemValue[JobCode, 1]);
    if Job.EstimatedDuration = 0 then Job.EstimatedDuration := 1; // нулевая длительность не прокатит
    Job.PlanFinish := IncMinute(Job.PlanStart, Job.EstimatedDuration);
    Job.JobAlert := false;
    Job.JobType := JobCode;
    Job.TimeLocked := NvlBoolean(TConfigManager.Instance.StandardDics.deSpecialJob.ItemValue[JobCode, 7]); // зафиксированная или нет
    Job.EquipCode := w.EquipCode;

    Editable := NvlBoolean(TConfigManager.Instance.StandardDics.deSpecialJob.ItemValue[JobCode, 6]);
    if Editable then
      Job.JobComment := JobComment
    else
      Job.JobComment := null;

    //TLogger.GetInstance.Info('MilliSeconds = '
    //  + VarToStr(MillisecondsBetween(Job.PlanStart, Job.PlanFinish)));

    if ExecAddSpecialToPlanForm(Job, Job.PlanStart, EditJobComment) then
    begin
      w := PlanFrame.CurrentWorkload;
      BeginUpdates(w);
      GetAdapter(w).AddSpecialJob(Job);
      AddOk := CheckMovingJob(0, Job);
      CheckShifts;
      CommitUpdates(w);
      PlanFrame.UpdateJobControls; // чтобы кнопочки обновились
    end;
  end
  else
    RusMessageDlg('Смена заполнена', mtWarning, [mbOk], 0);

  if not AddOk then
    Plan.CancelUpdates;
end;

procedure TPlanController.DivideJob(Sender: TObject);
var
  w: TWorkload;
  SplitMode: TSplitMode;
  SplitPartMult, SplitPartSide: variant;
  Job: TJobParams;
  ShiftStart: TDateTime;
begin
  w := PlanFrame.CurrentWorkload;

  if CheckLocked(W) then  // Если заблокирован, выходим
    Exit;

  Job := w.CurrentJob;
  if Job = nil then Exit;

  // Если есть пересечение с границей смены, то бьем по ней сначала
  if IntersectShift(w, Job, ShiftStart) then
  begin
    BeginUpdates(w);
    CheckShiftOverlap(w, Job);
    CommitUpdates(w);
  end
  else
  begin
    if not GetSplitMode(Job, SplitMode) then
      RusMessageDlg('Работу разбить нельзя', mtError, [mbOk], 0)
    else
    begin
      BeginUpdates(w);

      if SplitMode = smQuantity then
        SplitJobByQuantity(w, Job, false)    // manual
      else
      if SplitMode = smMultiplier then
        SplitJobByMultiplier(w, Job, false)  // manual
      else
      if SplitMode = smSide then
        SplitJobBySides(w, Job, false);     // manual

      CommitUpdates(w);
    end;
  end;
end;

procedure TPlanController.DoOpenOrder(Sender: TObject);
var
  OrderID: variant;
begin
  if Sender = Plan then
    OrderID := Plan.OrderID
  else
    OrderID := PlanFrame.CurrentWorkload.OrderID;

  if not VarIsNull(OrderID) then
  begin
    AppController.EditWorkOrder(OrderID);
  end;

end;

// Ищет в плане заказ с указанным номером
procedure TPlanController.DoLocateOrder(OrderNum: integer);
var
  LocData: TDataSource;
  JobID: integer;
  StartDate: TDateTime;
  tempDm: TDataModule;
  Found: boolean;
  w: TWorkload;
begin
  w := CurrentWorkload;
  tempDm := TDataModule.Create(nil);
  try
    Found := false;
    // ищем в текущем году
    LocData := GetAdapter(w).CreateLocatedProcesses(Plan.EquipGroupCode, OrderNum, tempDm, YearOf(Now));
    if LocData.DataSet.RecordCount = 0 then
    begin
      FreeAndNil(tempDm);
      tempDm := TDataModule.Create(nil);
      // ищем во всех годах
      LocData := GetAdapter(w).CreateLocatedProcesses(Plan.EquipGroupCode, OrderNum, tempDm, 0);
      if LocData.DataSet.RecordCount = 0 then
        RusMessageDlg('Работы для заказа № ' + IntToStr(OrderNum) + ' не найдены в текущей группе оборудования',
          mtWarning, [mbOk], 0)
      else
        Found := true;
    end
    else
      Found := true;

    if Found then
    begin
      // если возращено несколько работ (разные интервалы), то предлагаем пользователю выбор
      if LocData.DataSet.RecordCount > 1 then
        if not ExecJobListForm(LocData) then Exit;
      JobID := LocData.DataSet['JobID'];
      if JobID > 0 then
      begin
        if CurrentWorkload.EquipCode <> NvlInteger(LocData.DataSet['EquipCode']) then
        begin
          if not PlanFrame.ActivateWorkload(LocData.DataSet['EquipCode']) then
          begin
            RusMessageDlg('Оборудование для выбранной работы не найдено.', mtError, [mbOk], 0);
            Exit;
          end;
        end;

        // находим работу
        if not CurrentWorkload.Locate(JobID) then
        begin
          if not VarIsNull(LocData.DataSet['AnyStartDate']) then
            StartDate := LocData.DataSet['AnyStartDate']
          else
          begin
            RusMessageDlg('Выбранная работа не запланирована и не выполнена. Поиск таких работ пока не реализован', mtError, [mbOk], 0);
            Exit;
          end;

          ReplaceTime(StartDate, 0);
          PlanFrame.WorkDate := StartDate;

          // TODO: работа может быть в другой смене!

          if not PlanFrame.CurrentWorkload.Locate(JobID) then
            RusMessageDlg('Не удалось найти заданную работу', mtError, [mbOk], 0);
        end;
      end;
    end;
  finally
    tempDm.Free;
  end;
end;

// Ищет начало следующей смены, если все пусто
function TPlanController.GetNextShiftStart(w: TWorkload; DT: TDateTime): TDateTime;
var
  I: Integer;
  CurShift: TShiftInfo;
begin
  Result := DT;
  if w.ShiftList.Count > 0 then
  begin
    for I := 0 to w.ShiftList.Count - 1 do
    begin
      CurShift := w.ShiftList[I];
      if CurShift.Start > DT then
      begin
        Result := CurShift.Start;
        break;
      end;
    end;
  end;
end;

// Возвращает время, где есть свободное место без учета длительности работы.
// В режиме просмотра дня или смены может вернуть false, если работу разместить не удалось.
function TPlanController.FindAvailableStart(w: TWorkload; var StartTime: TDateTime; FromCurrent: boolean): boolean;
var
  StartFound: Boolean;
  LastFinishTime: TDateTime;
  Job: TJobParams;
  I, CurJobIndex: integer;
begin
  StartFound := true;
  if not ContinuousMode(w) then
  begin
    if w.IsEmpty then
      StartTime := w.RangeStart
    else
    begin
      w.DataSet.Last;
      StartTime := w.AnyFinishDateTime;
      // Если выходит за пределы дня
      if StartTime > w.RangeEnd then
        StartFound := false;
    end;
  end
  else
  if w.IsEmpty then
    StartTime := Now
  else // непрерывный график. Начинаем с текущего места.
  begin
    Job := w.CurrentJob;
    if Job = nil then
    begin
      if w.IsShiftMarker then
        StartTime := w.AnyStartDateTime;
        //StartTime := GetNextShiftStart(w, Now)
    end
    else
    begin
      LastFinishTime := Job.AnyFinish;
      // Если одна из следующих работ не начиналась фактически, то ставим перед ней
      CurJobIndex := w.JobList.IndexOf(Job);
      for I := CurJobIndex + 1 to w.JobList.Count - 1 do
      begin
        Job := w.JobList[I];
        if VarIsNull(Job.FactStart) then
          break;
        //if MinutesBetween(Job.AnyStart, LastFinishTime) > 1 then
        //  break;
        LastFinishTime := Job.AnyFinish;
        //w.DataSet.Next;
      end;
      StartTime := LastFinishTime;
    end;
  end;
  Result := StartFound;
end;

function TPlanController.GetPrevFinishTime(w: TWorkload; Job: TJobParams): TDateTime;
var
  JobIndex: integer;
  //CurStartTime: TDateTime;
  Shift: TShiftInfo;
begin
  if ContinuousMode(w) then
  begin
    Shift := w.GetJobShift(Job.JobID);
    JobIndex := Shift.JobList.IndexOf(Job);
    if JobIndex = 0 then
      Result := Job.AnyStart
    else
      Result := Shift.JobList[JobIndex - 1].AnyFinish;
  end
  else
    Result := Job.AnyStart
end;

function TPlanController.HandleAddToPlan(WorkloadRowKey: integer): boolean;
begin
  Result := AddToPlan(WorkloadRowKey);
end;

// перемещение работы на другое оборудование
procedure TPlanController.HandleChangeEquip(NewEquipCode: integer);
var
  I{, SavedJobID}: Integer;
  WSource, WTarget: TWorkload;
  CurJob, SavedJobParams: TJobParams;
begin
  // Работы, разбитые на интервалы, пока переносить не разрешаем
  WSource := PlanFrame.CurrentWorkload;
  CurJob := WSource.CurrentJob;
  SavedJobParams := CurJob.Copy;
  //SavedJobID := SavedJobParams.JobID;
  try
    if not CurJob.HasSplitMode(smQuantity) and not CurJob.HasSplitMode(smMultiplier)
      and not CurJob.HasSplitMode(smSide) then
    begin
      // находим план для нового оборудования
      for I := 0 to FWorkloads.Count - 1 do    // Iterate
      begin
        if TWorkload(FWorkloads[i]).EquipCode = NewEquipCode then
        begin
          WTarget := TWorkload(FWorkloads[i]);
          break;
        end;
      end;
      if WTarget = nil then
        raise Exception.Create('План оборудования не найден');

      // проверяем блокировку одного из планов
      if CheckLocked(WSource) or CheckLocked(WTarget) then
        Exit;

      BeginUpdates(WSource);
      // помещаем работу сначала в незапланированные...
      GetAdapter(WSource).UnPlanJob(CurJob);
      CommitUpdates(WSource);

      Plan.Reload;
      if not Plan.DataSet.Locate('JobID', SavedJobParams.JobID, []) then
        raise Exception.Create('Работа на найдена');
      // переключаем на новый план и добавляем в него
      PlanFrame.CurrentWorkload := WTarget;
      if AddToPlan(0) then
      begin
        BeginUpdates(WTarget);
        if NvlInteger(SavedJobParams.SplitPart1) <> 0 then
          GetAdapter(WTarget).UpdateSplitPart(SavedJobParams, SavedJobParams.SplitPart1, 1);
        if NvlInteger(SavedJobParams.SplitPart2) <> 0 then
          GetAdapter(WTarget).UpdateSplitPart(SavedJobParams, SavedJobParams.SplitPart2, 2);
        if NvlInteger(SavedJobParams.SplitPart3) <> 0 then
          GetAdapter(WTarget).UpdateSplitPart(SavedJobParams, SavedJobParams.SplitPart3, 3);
        CommitUpdates(WTarget);
        WTarget.Locate(SavedJobParams.JobID);
      end
      else
      begin
        PlanFrame.CurrentWorkload := WSource;
      end;
    end
    else
      RusMessageDlg('Пока не реализован перенос одного интервала на другое оборудование. Sorry...',
        mtError, [mbOk], 0);
  finally
    SavedJobParams.Free;
  end;
end;

function TPlanController.EditJobComment(Job: TJobParams): boolean;
var
  TempComment: string;
  TempAlert: boolean;
  FJobComment: variant;
  FJobAlert: boolean;

  function DoEditJobComment: boolean;
  var
    CurOrder: TWorkOrder;
    FFilter: TOrderFilterObj;
  begin
    CurOrder := AppController.CreateWorkOrder;
    try
      // Открываем заказ, чтобы увидеть комментарии и пометки
      FFilter := TOrderFilterObj.Create;
      try
        CurOrder.Criteria := FFilter as TOrderFilterObj;
        CurOrder.UsePager := false;
        CurOrder.UseWaitCursor := true;
        FFilter.SetSingleOrderFilter(Job.OrderID);
        CurOrder.Reload;
        Result := ExecEditJobComment(CurOrder, 'Примечания', TempComment, TempAlert);
      finally
        FFilter.Free;
      end;
    finally
      AppController.FreeEntity(CurOrder);
    end;
  end;

  function DoEditSpecialJobComment: boolean;
  begin
    Result := ExecEditJobComment(nil, 'Примечания', TempComment, TempAlert);
  end;

begin
  TempComment := NvlString(Job.JobComment);
  TempAlert := Job.JobAlert;
  if Job.JobType >= JobType_Special then
    Result := DoEditSpecialJobComment
  else
    Result := DoEditJobComment;
  if Result then
  begin
    TempComment := Trim(TempComment);
    if TempComment <> '' then
    begin
      FJobComment := TempComment;
      FJobAlert := TempAlert;
    end
    else
    begin
      FJobComment := null;
      FJobAlert := false;
    end;
    if NvlString(Job.JobComment) <> NvlString(FJobComment) then
      Job.JobComment := FJobComment;
    if NvlBoolean(Job.JobAlert) <> NvlBoolean(FJobAlert) then
      Job.JobAlert := FJobAlert;
  end;
end;

function TPlanController.EditAdvanced(Job: TJobParams): boolean;
begin
  ExecAdvancedEditForm(Job);
end;

procedure TPlanController.HandleEditJobComment(Sender: TObject);
var
  w: TWorkload;
  Job, JobCopy: TJobParams;
begin
  w := PlanFrame.CurrentWorkload;
  Job := w.CurrentJob;
  if Job = nil then Exit;

  JobCopy := Job.Copy;
  JobCopy.ClearChanges;
  try
    if EditJobComment(JobCopy) and (JobCopy.JobCommentSet or JobCopy.JobAlertSet) then
    begin
      Job.JobComment := JobCopy.JobComment;
      Job.JobAlert := JobCopy.JobAlert;
      BeginUpdates(w);
      GetAdapter(w).UpdatePlan(Job);
      CommitUpdates(w);
    end;
  finally
    JobCopy.Free;
  end;
end;

procedure TPlanController.HandleUndo(Sender: TObject);
begin
  UndoLastEdit;
end;

function TPlanController.GetUndoEnabled(Sender: TObject): boolean;
var
  a: TCachedScheduleAdapter;
begin
  a := GetAdapter(Sender as TWorkload) as TCachedScheduleAdapter;
  Result := a.CanUndo;
end;

procedure TPlanController.HandleLock(Sender: TObject);
begin
  LockWorkload(Sender as TWorkload);
end;

procedure TPlanController.HandleUnlock(Sender: TObject);
begin
  UnlockWorkload(Sender as TWorkload);
end;

procedure TPlanController.HandleEditOrderState(Sender: TObject);
begin
  EditOrderState((Sender as TWorkload).CurrentJob);
end;

procedure TPlanController.HandleEditFiles(Sender: TObject);
begin
  EditFiles((Sender as TWorkload).CurrentJob);
end;

function TPlanController.CheckCurrentLocked: boolean;
begin
  Result := CheckLocked(CurrentWorkload);
end;

function TPlanController.IsLocked(w: TWorkload): boolean;
var
  LockerName: string;
begin
  Result := EntSettings.EditLock
    and TLockManager.IsLockedByAnotherUser(LockerName, TLockManager.Workload, w.EquipCode);
end;

function TPlanController.CheckLocked(w: TWorkload): boolean;
var
  LockerName: string;
  LockerInfo: TUserInfo;
begin
  Result := EntSettings.EditLock and TLockManager.IsLockedByAnotherUser(LockerName, TLockManager.Workload, w.EquipCode);
  if Result then
  begin
    LockerInfo := AccessManager.UserInfo(LockerName);
    if LockerInfo <> nil then
      LockerName := LockerInfo.Name;
    RusMessageDlg('План редактируется пользователем ' + QuotedStr(LockerName), mtInformation, [mbok], 0);
  end
  else
  begin
    // Сначала проверяем, были ли изменения с момента последнего обновления
    if CheckModified(w) then
      w.Reload;
    // блокируем
    TLockManager.Lock(TLockManager.Workload, w.EquipCode);
    // включаем таймер подтверждения блокировки
    FEditLockTimer.Enabled := true;
    // обновляем состояние кнопок
    w.Locked := true;
    PlanFrame.UpdateLockState;
  end;
end;

procedure TPlanController.LockWorkload(w: TWorkload);
begin
  if EntSettings.EditLock then
    CheckLocked(w);
end;

procedure TPlanController.UnlockWorkload(w: TWorkload);
var
  I: Integer;
  LockFound: boolean;
  a: TCachedScheduleAdapter;
begin
  if EntSettings.EditLock then
  begin
    // Отключаем таймер
    FEditLockTimer.Enabled := false;
    // разблокируем
    TLockManager.Unlock(TLockManager.Workload, w.EquipCode);
    // очищаем историю изменений
    a := GetAdapter(w) as TCachedScheduleAdapter;
    a.ClearHistory;
    // обновляем состояние кнопок
    w.Locked := false;
    PlanFrame.UpdateLockState;

    // Включаем таймер, если хоть один план заблокирован
    LockFound := false;
    for I := 0 to FWorkloads.Count - 1 do
    begin
      w := FWorkloads[I];
      if w.Locked then
      begin
        LockFound := true;
        break;
      end;
    end;

    if LockFound then
      FEditLockTimer.Enabled := true;
  end;
end;

procedure TPlanController.UnlockAll;
var
  I: Integer;
begin
  for I := 0 to FWorkloads.Count - 1 do
    UnlockWorkload(FWorkloads[I]);
end;

function TPlanController.CheckModified(w: TWorkload): boolean;
begin
  Result := (GetAdapter(w) as TCachedScheduleAdapter).ScheduleChanged;
end;

procedure TPlanController.EditOrderState(Job: TJobParams);
var
  NewOrderState: integer;
begin
  NewOrderState := ExecEditOrderStateForm(Job.OrderState, Job.OrderNumber);
  if NewOrderState <> Job.OrderState then
    CurrentWorkload.ChangeOrderState(Job, NewOrderState);
end;

procedure TPlanController.EditFiles(Job: TJobParams);
var
  CurOrder: TWorkOrder;
  FFilter: TOrderFilterObj;
begin
  CurOrder := AppController.CreateWorkOrder;
  try
    // Открываем заказ, чтобы увидеть комментарии и пометки
    FFilter := TOrderFilterObj.Create;
    try
      CurOrder.Criteria := FFilter as TOrderFilterObj;
      CurOrder.UsePager := false;
      CurOrder.UseWaitCursor := true;
      FFilter.SetSingleOrderFilter(Job.OrderID);
      CurOrder.Reload;
      ExecOrderFilesForm(CurOrder);
    finally
      FFilter.Free;
    end;
  finally
    AppController.FreeEntity(CurOrder);
  end;
end;

procedure TPlanController.HandleTimeLock(Sender: TObject);
var
  JobParams: TJobParams;
begin
  JobParams := (Sender as TWorkload).CurrentJob;
  if JobParams = nil then Exit;

  JobParams.TimeLocked := not JobParams.TimeLocked;
  BeginUpdates(Sender as TWorkload);
  GetAdapter(Sender as TWorkload).UpdatePlan(JobParams);
  CommitUpdates(Sender as TWorkload);
end;

// Сдвигает работы начиная с JobID на место NewStart
{procedure TPlanView.MoveJobs(NewStart: TDateTime; JobID: integer);
var
  w: TWorkload;
  NewFinish: TDateTime;
  WasMoved: boolean;
begin
  w := PlanFrame.CurrentWorkload;
  w.DataSet.DisableControls;
  WasMoved := false;
  try
    if w.Locate(JobID) then
    begin
      while not w.DataSet.eof do
      begin
        // не показывать сообщение о том что сдвинуть нельзя
        if CheckCanMove(w, false) then
        begin
          NewFinish := NewStart + (w.PlanFinishDateTime - w.PlanStartDateTime);
          FAdapter.UpdatePlan(w.JobID, NewStart, NewFinish);
          WasMoved := true;
          NewStart := NewFinish;
        end
        else
          break; // если одну нельзя сдвинуть, то и остальные тоже
        w.DataSet.Next;
      end;
      w.Locate(JobID);
    end;
    if WasMoved then
      w.ReloadLocate(JobID);
  finally
    w.DataSet.EnableControls;
  end;
end; }

function TPlanController.SameDay(DayStart, Date1, Date2: TDateTime): Boolean;
var
  NextDay: TDateTime;
begin
  ReplaceTime(Date1, DayStart);  // дата-время начала текущего дня
  NextDay := IncDay(Date1, 1);
  Result := (Date2 < NextDay) and (Date2 >= Date1);
end;

procedure TPlanController.HandleUpdateCriteria(Sender: TObject);
var
  i: integer;
  w: TWorkload;
  Criteria: TWorkloadCriteria;
begin
  PlanFrame.BeforeOpenData;
  try
    if AccessManager.CurUser.ViewNotPlanned and not Plan.DataSet.Active then
      Plan.Reload; // чтобы прыгнуло в конец надо вызывать релоад
    // Во всех режимах, кроме диаграммы, обновляем только загрузку только по одному оборудованию.
    for i := 0 to FWorkloads.Count - 1 do
    begin
      w := TWorkload(FWorkloads[i]);
      if (PlanFrame.DateCriteriaType = PlanRange_Gantt) or (w = CurrentWorkload) then
      begin
        UpdateWorkloadCriteria(w);
      end
      else
        w.Close;
    end;
  finally
    PlanFrame.AfterOpenData;
  end;
end;

procedure TPlanController.HandleUpdateWorkloadCriteria(Sender: TObject);
begin
  UpdateWorkloadCriteria(CurrentWorkload);
end;

procedure TPlanController.UpdateWorkloadCriteria(w: TWorkload);
var
  Criteria: TWorkloadCriteria;
  CurID: integer;
begin
  Criteria.Date := PlanFrame.WorkDate;
  Criteria.RangeType := PlanFrame.DateCriteriaType;
  w.Criteria := Criteria;

  if w.Active then
    CurID := NvlInteger(w.KeyValue)
  else
    CurID := 0;

  // перезагружаем, если были изменения и нет блокировки
  if FNeedRefresh or not w.Active or (CheckModified(w) and not w.Locked) then
    w.Reload;

  if (w.KeyValue <> CurID) then
    LocateLastPlannedJob(w);

  CheckOverdueJobs(w);
  if ContinuousMode(w) then
    UpdateOverlaps(w);
end;

// проверяет работы на предмет просроченности отметок
procedure TPlanController.CheckOverdueJobs(w: TWorkload);
var
  //JobID: integer;
  OverdueFinish, OverdueStart: boolean;
  I: integer;
  Job: TJobParams;
begin
  if not EntSettings.CheckOverdueJobs then Exit;

  //w.DataSet.DisableControls;
  //try
    if not w.IsEmpty then
    begin
      //JobID := w.KeyValue;
      //w.DataSet.First;
      OverdueFinish := false;
      OverdueStart := false;
      i := 0;
      while (i < w.JobList.Count) and not OverdueStart and not OverdueFinish do
      begin
        Job := w.JobList[i];
        //if not w.IsShiftMarker then
        //begin
          if Job.ExecState = esPlanFinished then
            OverdueFinish := true
          else if Job.ExecState = esPlanInProgress then
            OverdueStart := true;
        //end;
        //w.DataSet.Next;
        Inc(i);
      end;
      if OverdueFinish then
        (FFrame as TPlanFrame).ShowWarning(w.EquipCode, 'Отсутствуют отметки об завершении некоторых работ');
      if OverdueStart then
        (FFrame as TPlanFrame).ShowWarning(w.EquipCode, 'Отсутствуют отметки об начале некоторых работ');
      if not OverdueStart and not OverdueFinish then
        (FFrame as TPlanFrame).HideWarnings(w.EquipCode);
      //w.Locate(JobID);
    end
    else
      (FFrame as TPlanFrame).HideWarnings(w.EquipCode);
  //finally
  //  w.DataSet.EnableControls;
  //end;
end;

procedure TPlanController.HandleAssignShiftEmployee(EmployeeCode: variant);
begin
  CurrentWorkload.ShiftEmployee := EmployeeCode;
end;

procedure TPlanController.HandleAssignShiftAssistant(EmployeeCode: variant);
begin
  CurrentWorkload.ShiftAssistant := EmployeeCode;
end;

procedure TPlanController.HandleAssignEquipmentEmployee(EmployeeCode: variant);
begin
  CurrentWorkload.EquipmentEmployee := EmployeeCode;
end;

procedure TPlanController.HandleAssignEquipmentAssistant(EmployeeCode: variant);
begin
  CurrentWorkload.EquipmentAssistant := EmployeeCode;
end;

function TPlanController.ContinuousMode(w: TWorkload): boolean;
begin
  Result := (w.Criteria.RangeType = PlanRange_Continuous)
    or (w.Criteria.RangeType = PlanRange_Week);
end;

// проверяет, закрыты ли все предшествующие в этой смене.
function TPlanController.CheckSetFactOrder(Job: TJobParams): boolean;
var
  Shift: TShiftInfo;
  JList: TJobList;
  w: TWorkload;
  I: integer;
  CurJob: TJobParams;
begin
  Result := true;
  w := CurrentWorkload;
  // становимся на первую работу смены
  if ContinuousMode(w) then
  begin
    Shift := w.GetJobShift(Job.JobID);
    JList := Shift.JobList;
  end
  else
    JList := w.JobList;
  for I := 0 to JList.Count - 1 do
  begin
    CurJob := JList[I];
    if Job.JobID = CurJob.JobID then break;  // дошли до текущей
    if VarIsNull(CurJob.FactStart) or VarIsNull(CurJob.FactFinish) then
    begin
      Result := false;
      break;
    end;
  end;
end;

// проверяет, открыты ли все последующие в этой смене.
function TPlanController.CheckRemoveFactOrder(Job: TJobParams): boolean;
var
  Shift: TShiftInfo;
  JList: TJobList;
  w: TWorkload;
  JobIndex, I: integer;
  CurJob: TJobParams;
begin
  Result := true;
  w := CurrentWorkload;
  if ContinuousMode(w) then
  begin
    Shift := w.GetJobShift(Job.JobID);
    JList := Shift.JobList;
  end
  else
    JList := w.JobList;
  JobIndex := JList.IndexOf(Job);
  for I := JobIndex + 1 to JList.Count - 1 do
  begin
    CurJob := JList[I];
    if not VarIsNull(CurJob.FactStart) or not VarIsNull(CurJob.FactFinish) then
    begin
      Result := false;
      break;
    end;
  end;
end;

function TPlanController.RemoveItemJobsFromPlan(w: TWorkload; Job: TJobParams): boolean;
var
  Cancelled: Boolean;
  I: Integer;
  JobIDs: TIntArray;
  ReasonText: string;
  TransStarted: Boolean;
begin
  Cancelled := false;
  if AccessManager.CurUser.DescribeUnScheduleJob then
    Cancelled := not GetUnScheduleReason(ReasonText);
    
  if not Cancelled then
  begin
    BeginUpdates(w);
    JobIDs := GetAdapter(w).GetItemJobIDs(Job.ItemID);
    for I := Low(JobIDs) to High(JobIDs) do
    begin
      if AccessManager.CurUser.DescribeUnScheduleJob then
        // заменяем на спец работу с описанием
        GetAdapter(w).ReplaceJobWithSpecial(JobIDs[I], TStandardDics.SpecialJob_Unscheduled,
          GetRemovedJobDesc(Job) + #13#10 + ReasonText);
    end;
    GetAdapter(w).UnPlanItem(Job);
  end;
  Result := not Cancelled;
end;

// возвращает ключ второй половинки работы
function TPlanController.SplitJobByQuantity(w: TWorkload; Job: TJobParams; AutoSplit: boolean): integer;
var
  StartTime, FinishTime: TDateTime;
  Half1, m: extended;
  NewJob: TJobParams;
  sn: Integer;
begin
  StartTime := Job.AnyStart;
  FinishTime := Job.PlanFinish;
  // Делим пополам - округляя до минуты
  m := MinuteSpan(FinishTime, StartTime);
  if m >= 2 then
  begin
    Half1 := IncMinute(StartTime, Trunc(m / 2));
    // Первая половина, достаточно только здесь обновить режим разбивки
    // возвращает номер разбивки
    sn := GetAdapter(w).UpdateJobSplitMode(Job, StartTime, Half1, smQuantity, AutoSplit);
    // Вторая половина
    Result := GetAdapter(w).AddSplitJob(Job, Half1, FinishTime, sn);
    // Чтобы обновить параметра, общие для всех работ одного процесса
    GetAdapter(w).UpdatePlan(Job);
    // Только после этого перенумеровать
    RenumberItemJobs(w, Job, sn);
  end
  else
    ExceptionHandler.Raise_('Работа длится меньше двух минут');
end;

// возвращает ключ второй половинки работы
function TPlanController.SplitJobByQuantityEx(w: TWorkload; Job: TJobParams; AutoSplit: boolean;
  NewStartTime1, NewFinishTime1, NewStartTime2, NewFinishTime2: TDateTime): integer;
var
  sn: Integer;
begin
  // Первая половина, достаточно только здесь обновить режим разбивки
  // (возвращает номер разбивки)
  sn := GetAdapter(w).UpdateJobSplitMode(Job, NewStartTime1, NewFinishTime1, smQuantity, AutoSplit);
  // Вторая половина
  {Result := GetAdapter(w).AddSplitJob(Job.ItemID, NewStartTime2, NewFinishTime2, null,
    w.EquipCode, Job.Executor, Job.JobComment, Job.SplitPart1, Job.SplitPart2, sn,
    Job.JobAlert);}
  Result := GetAdapter(w).AddSplitJob(Job, NewStartTime2, NewFinishTime2, sn);
  // Чтобы обновить параметра, общие для всех работ одного процесса
  GetAdapter(w).UpdatePlan(Job);
  // Только после этого перенумеровать
  RenumberItemJobs(w, Job, sn);
end;

{function TPlanView.SplitJobBySides(w: TWorkload; AutoSplit: boolean): integer;
var
  Job: TJobParams;
begin
  Job := w.GetJobParams;
  try
    Result := SplitJobBySides(Job, AutoSplit);
  finally
    Job.Free;
  end;
end;}

function TPlanController.SplitJobBySides(w: TWorkload; Job: TJobParams; AutoSplit: boolean): integer;
var
  StartTime, FinishTime: TDateTime;
  Half1, m: extended;
  sn: Integer;
begin
  StartTime := Job.AnyStart;
  FinishTime := Job.PlanFinish;
  if NvlInteger(Job.SideCount) > 0 then
  begin
    if Job.SideCount = 2 then
    begin
      // Делим пополам - округляя до минуты
      m := MinuteSpan(FinishTime, StartTime);
      if m >= 2 then
      begin
        //Half1 := (FinishTime - StartTime) / 2;
        Half1 := IncMinute(StartTime, Trunc(m / 2));
        // Первая половина
        {Job := w.GetJobParams;
        try}
          // возвращает номер разбивки
          sn := GetAdapter(w).UpdateJobSplitMode(Job, StartTime, Half1, smSide, AutoSplit);
          // Вторая половина
          Result := GetAdapter(w).AddSplitJob(Job, Half1, FinishTime, sn);
          // Чтобы обновить параметра, общие для всех работ одного процесса
          GetAdapter(w).UpdatePlan(Job);
          // Только после этого перенумеровать
          RenumberItemJobs(w, Job, sn);
        {finally
          Job.Free;
        end;}
      end
      else
        ExceptionHandler.Raise_('Работа длится меньше двух минут');
    end
    else
      ExceptionHandler.Raise_('Рабивка при количестве сторон больше двух не реализована. Сообщите разработчику.');
  end
  else
    ExceptionHandler.Raise_('Не указано количество сторон в работе');
end;

{function TPlanView.SplitJobByMultiplier(w: TWorkload; AutoSplit: boolean): TIntArray;
var
  Job: TJobParams;
begin
  Job := w.GetJobParams;
  try
    Result := SplitJobByMultiplier(Job, AutoSplit);
  finally
    Job.Free;
  end;
end;}

// возвращает ключи всех интервалов работы, кроме первого
function TPlanController.SplitJobByMultiplier(w: TWorkload; Job: TJobParams; AutoSplit: boolean): TIntArray;
var
  StartTime, FinishTime: TDateTime;
  I, IMult, sn: Integer;
  EndHalf1, Half1: Extended;
  m: Int64;
begin
  StartTime := Job.AnyStart;
  FinishTime := Job.PlanFinish;
  // Делим по множителю работы - округляя до минуты
  IMult := Round(Job.Multiplier);
  SetLength(Result, IMult);
  if IMult > 1 then
  begin
    m := Round(MinuteSpan(FinishTime, StartTime));
    if m >= IMult then
    begin
      Half1 := IncMinute(StartTime, Trunc(m / IMult));
      //Half1 := (FinishTime - StartTime) / IMult;
      {Job := w.GetJobParams;
      try}
        // возвращает номер разбивки
        sn := GetAdapter(w).UpdateJobSplitMode(Job, StartTime, Half1, smMultiplier, AutoSplit);
        // первый кусочек
        Result[0] := Job.JobID;
        for I := 1 to IMult - 2 do
        // со второго интервала до предпоследнего
        begin
          EndHalf1 := IncMinute(Half1, Trunc(m / IMult));
          Result[I] := GetAdapter(w).AddSplitJob(Job, Half1, EndHalf1, sn);
          Half1 := EndHalf1;
        end;
        // последний кусочек
        Result[IMult - 1] := GetAdapter(w).AddSplitJob(Job, Half1, FinishTime, sn);
        // Чтобы обновить параметра, общие для всех работ одного процесса
        GetAdapter(w).UpdatePlan(Job);
        // Только после этого перенумеровать
        RenumberItemJobs(w, Job, sn);
      {finally
        Job.Free;
      end;}
    end
    else
      ExceptionHandler.Raise_('Работа длится меньше ' + IntToStr(IMult) + ' минут');
  end
  else
    ExceptionHandler.Raise_('Работа не разбита. Не на что разбивать...');
end;

procedure TPlanController.RenumberItemJobs(w: TWorkload; Job: TJobParams; SplitModeNum: integer);
var
  WasAdded: boolean;
begin
  // Временно ставим работу на место, если ее нет в списке, чтобы перенумерация прошла правильно
  if w.JobList.IndexOf(Job) = -1 then
  begin
    w.JobList.Add(Job);
    w.SortJobs;
    WasAdded := true;
  end
  else
    WasAdded := false;
  try
    if SplitModeNum = 1 then
      GetAdapter(w).RenumberSplitPartsItem(Job.ItemID, null, null, 1)
    else if SplitModeNum = 2 then
    begin
      GetAdapter(w).RenumberSplitPartsItem(Job.ItemID, Job.SplitPart1, null, 2);
    end else if SplitModeNum = 3 then
    begin
      GetAdapter(w).RenumberSplitPartsItem(Job.ItemID, Job.SplitPart1, Job.SplitPart2, 3);
    end;
  finally
    if WasAdded then
    begin
      w.JobList.Remove(Job);
      w.SortJobs;
    end;
  end;
end;

function TPlanController.GetCurrentWorkload: TWorkload;
begin
  Result := PlanFrame.CurrentWorkload;
end;

procedure TPlanController.PauseJob(Sender: TObject);
var
  CurJob: TJobParams;
begin
  CurJob := CurrentWorkload.CurrentJob;
  if CurJob = nil then Exit;
  
  CurJob.IsPaused := not CurJob.IsPaused;
  BeginUpdates(CurrentWorkload);
  GetAdapter(CurrentWorkload).UpdatePlan(CurJob);
  CommitUpdates(CurrentWorkload);
end;

function TPlanController.GetToolbar: TjvSpeedbar;
begin
  if FToolbarFrame = nil then
  begin
    FToolbarFrame := TScheduleToolbar.Create(nil);
    FToolbarFrame.SpecialJobMenu := PlanFrame.pmSpecJob;
  end;
  Result := FToolbarFrame.Toolbar;
end;

procedure TPlanController.TimeLineBlockSelected(Sender: TObject);
begin
  CurrentWorkload.Locate(TPlanFrame(FFrame).TimeLineSelectedBlock.JobID);
end;

function TPlanController.GetAdapter(w: TWorkload): TScheduleAdapter;
begin
  Result := TScheduleAdapter(FAdapters[FWorkloads.IndexOf(w)]);
end;

procedure TPlanController.BeginUpdates(w: TWorkload);
var
  a: TCachedScheduleAdapter;
begin
  if FEnableUndo then
  begin
    a := GetAdapter(w) as TCachedScheduleAdapter;
    a.BeginUpdates;
  end;
end;

function TPlanController.Validate(w: TWorkload): boolean;
var
  errors: TStringList;
  a: TCachedScheduleAdapter;
  I: Integer;
  s: string;
begin
  a := GetAdapter(w) as TCachedScheduleAdapter;

  errors := a.Validate;
  Result := errors.Count = 0;
  if not Result then
  begin
    for I := 0 to errors.Count - 1 do
    begin
      s := s + #13 + errors[i];
    end;
    RusMessageDlg('Обнаружены некорректные данные. Изменения не могут быть сохранены:'
      + s, mtError, [mbOk], 0);
  end;
end;

procedure TPlanController.CommitUpdates(w: TWorkload);
var
  a: TCachedScheduleAdapter;
  CurID: variant;
  CurJobDate: TDateTime;
  CurJob: TJobParams;
  CurShift: TShiftInfo;
begin
  a := GetAdapter(w) as TCachedScheduleAdapter;

  // если текущая работа не найдется после обновления, то надо встать на смену этой работы
  if w.Active and ContinuousMode(w) then
  begin
    CurID := w.KeyValue;
    if not VarIsNull(CurID) then
    begin
      CurJob := w.JobList.GetJob(CurID);
      if CurJob = nil then
      begin
        // работа могла быть удалена либо снята
        CurJob := a.UnPlannedJobList.GetJob(CurID);
        if CurJob = nil then
          CurJob := a.RemovedJobList.GetJob(CurID);
      end;
      if CurJob <> nil then
        CurJobDate := CurJob.AnyStart  // запоминаем время начала текущей работы
      else
        CurID := null;
    end;
  end;

  if not Validate(w) then
    Exit;

  a.CommitUpdates;

  //w.SaveJobs := EnableUndo;  // чтобы сохранялась копия для отката
  //try
    w.Reload;
  //finally
  //  w.SaveJobs := false;
  //end;

  if w.Active and ContinuousMode(w) and not VarIsNull(CurID) and (w.KeyValue <> CurID) then
  begin
    // Если стоим на другой работе, значит
    // текущая работа не нашлась после обновления, становимся на текущую смену.
    CurShift := w.GetShiftByDate(CurJobDate);
    if CurShift = nil then
      CurShift := w.GetShiftByDate(Now);
    if CurShift <> nil then
      w.Locate(-CurShift.Number);
  end;

  CheckOverdueJobs(w);
  if ContinuousMode(w) then
    UpdateOverlaps(w);

  PlanFrame.UpdateLockState;  // обновить состояние отмены
end;

procedure TPlanController.RollbackUpdates(w: TWorkload);
begin
  (GetAdapter(w) as TCachedScheduleAdapter).RollbackUpdates;//ClearLists;
  w.Reload;
end;

procedure TPlanController.UndoLastEdit;
var
  a: TCachedScheduleAdapter;
  w: TWorkload;
begin
  w := CurrentWorkload;
  a := GetAdapter(w) as TCachedScheduleAdapter;
  if a.UndoLastEdit then
  begin
    a.EnableUndo := false;  // можно beginupdates не делать
    try
      CommitUpdates(w);
    finally
      a.EnableUndo := true;
    end;
    if a.UndoRestored or a.UndoRemoved then
      Plan.Reload; // это нужно, только если снимается или добавляется работа
  end;
  PlanFrame.UpdateLockState;
end;

procedure TPlanController.DoEditLockTimer(Sender: TObject);
var
  I: Integer;
  w: TWorkload;
begin
  for I := 0 to FWorkloads.Count - 1 do
  begin
    w := FWorkloads[I];
    if w.Locked then
      TLockManager.Lock(TLockManager.Workload, w.EquipCode);
  end;
end;

procedure TPlanController.Deactivate(var AllowLeave: boolean);
var
  Res: integer;
  LockedFound: boolean;
  I: Integer;
begin
  LockedFound := false;
  for I := 0 to FWorkloads.Count - 1 do
  begin
    if TWorkload(FWorkloads[I]).Locked then
    begin
      LockedFound := true;
      break;
    end;
  end;
  AllowLeave := not LockedFound;
  if not AllowLeave then
  begin
    Res := RusMessageDlg('Завершить планирование?', mtConfirmation,
      mbYesNoCancel, 0);
    if Res = mrYes then
    begin
      UnlockAll;
      AllowLeave := true;
    end
    else if Res = mrCancel then
      AllowLeave := false;
  end;
end;

procedure TPlanController.PrintReport(ReportKey: integer; AllowInside: boolean);
begin
  ScriptManager.ExecExcelReport(ReportKey);
end;

end.
