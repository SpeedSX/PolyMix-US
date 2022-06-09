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
    // ���������� ���� ������ �� ������� ���������� ������
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

    // ���������, ���� �� ����������� � ����� � ������� �������,
    // ���� ����, ���������� ��������� � �������� ������� ������ ���� ������ � �����.
    // ���� CurItemID = 0, �� ������ ���������
    function CheckMovingJob(CurItemID: integer; Job: TJobParams): boolean;
    function SplitJobAroundUnmovable(w: TWorkload; Job: TJobParams; UnmovableJob: TJobParams): boolean;
    procedure PlaceJobs(w: TWorkload; Jobs: TJobList);
    // � ������ ������������ ����������� ����� ������, ���������� �� ������� ����,
    // � ���������� ������, ������� ���� ������ ������� �������� �����, � ������ ���.
    // ���������� true, ���� ���� ��������� � ���� ������������
    function CheckShifts: boolean;
    procedure UpdateOverlaps(w: TWorkload);
    function CheckShiftOverlap(w: TWorkload; Job: TJobParams): boolean;
    // ���������� ���� �� ����������� �� �������, � ���������� ���� ������ �����
    function IntersectShift(w: TWorkload; Job: TJobParams; var ShiftStart: TDateTime): boolean;
    procedure DivideJob(Sender: TObject);
    // ���������� �����, ��� ���� ��������� ����� ��� ����� ������������ ������.
    // � ������ ��������� ��� ��� ����� ����� ������� false, ���� ������ ���������� �� �������.
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
    // �������� ������ �����. IncludeJob ��������, ��� ����� �������� ��������� ������.
    procedure MoveJobsUp(w: TWorkload; StartTime: TDateTime; JobID: integer; IncludeJob: boolean);
    function SameDay(DayStart, Date1, Date2: TDateTime): Boolean;
    //procedure RemoveJob(w: TWorkload);
    procedure HandleUpdateCriteria(Sender: TObject);
    procedure HandleUpdateWorkloadCriteria(Sender: TObject);
    procedure HandleAssignShiftEmployee(EmployeeCode: variant);
    procedure HandleAssignShiftAssistant(EmployeeCode: variant);
    procedure HandleAssignEquipmentEmployee(EmployeeCode: variant);
    procedure HandleAssignEquipmentAssistant(EmployeeCode: variant);
    // ���������� �� ��������� ������ � �����
    function LocateLastPlannedJob(w: TWorkload): boolean;
    function GetCurrentWorkload: TWorkload;
    // ��������� ������ �� ������� �������������� �������
    procedure CheckOverdueJobs(w: TWorkload);
    // ���������� ����� ���� ���������� ������, ����� �������
    function SplitJobByMultiplier(w: TWorkload; Job: TJobParams; AutoSplit: boolean): TIntArray;
    //function SplitJobByMultiplier(w: TWorkload; AutoSplit: boolean): TIntArray; overload;
    // ���������� ���� ������� ��������� ������
    function SplitJobBySides(w: TWorkload; Job: TJobParams; AutoSplit: boolean): integer;
    //function SplitJobBySides(w: TWorkload; AutoSplit: boolean): integer; overload;
    // ���������� ���� ������� ��������� ������
    function SplitJobByQuantity(w: TWorkload; Job: TJobParams; AutoSplit: boolean): integer;
    // ���������� ���� ������� ��������� ������
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
    // true, ���� ���� ������������ ������ ������������� � ������ ���������,
    // ����� ���������.
    function CheckLocked(w: TWorkload): boolean;
    // true, ���� ���� ������������ ������ �������������
    function IsLocked(w: TWorkload): boolean;
    procedure UnlockAll;
    // ���������, ��� �� ������� ���� � ������� ��������� ��������
    function CheckModified(w: TWorkload): boolean;
  protected
    FEnableUndo: boolean;
    // ��������� ������� ����. ��������� ���������
    //procedure RefreshWorkloads;
    // ���������, ����� �� �������� ������
    function CheckCanMove(Job: TJobParams; ShowMessage: boolean): boolean;
    // ��������� �� ���� ����������� ������, ���� �� ��� ������, ������� ����� �������� �����.
    // ������� � JobID. IncludeJob ��������, ��� ����� �������� ��������� ������.
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
  MIN_JOB = 5; // ����������� ������ � �������

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
  FCaption := '����: ' + TConfigManager.Instance.StandardDics.deEquipGroup.ItemName[TPlan(_Entity).EquipGroupCode];
  Plan.OnScriptError := ScriptError;
  FEnableUndo := true;
  CreateWorkloads;
  FNeedRefresh := true;

  // ������ ������������� ����������
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
  // ������� ������ � ���������, �������������� � ����������� ��������
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
  Result.JobComment := null;  // ������ ����������
  Result.JobAlert := false;
  Result.Executor := null;  // ����� ��� unassigned �� �������� KeyValue ����������
  Result.Part := Plan.Part;
  Result.PartName := Plan.PartName;
  Result.Multiplier := Plan.Multiplier;
  Result.SideCount := Plan.SideCount;
  Result.OrderID := Plan.OrderID;
  Result.OrderNumber := Plan.OrderNumber;
  Result.OrderState := Plan.OrderState;
  Result.Comment := Plan.Comment;
end;

// ���������� ���� ������ �� ������� ���������� ������
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
  // ���� ���� ������������ ��� ��� ���� �� ������������ � ������. �������, �� �������
  if not KPRec.PlanDate and not KPRec.FactDate or IsLocked(W) then Exit;

  if CheckLocked(w) then  // ���� ������������, �������
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
      // ��������� ������������������ �������� ��� ������������
      Plan.DataSet.Edit;
      Plan.EquipCode := w.EquipCode;
      Plan.DataSet.Post;
    end;

    // ��������� FinishTime � ������ ��������� ������������ ��������
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

    PrevFinishTime := StartTime;  // ���� ���������� ����������� ��������

    CurJobID := Plan.JobID;  // ���������� ������

    tempDm := TDataModule.Create(nil);
    try
      Job := CreateNotPlannedJob;

      Job.PlanStart := StartTime;
      Job.PlanFinish := FinishTime;
      Job.EquipCode := w.EquipCode;
      Job.EstimatedDuration := Estimated;
      SetExecutor(w, Job);  // ����� ����������� �� ���������� � �����, ���� ����

      // ���������, ���� �� ���������� ���� ���������� � ����
      if EntSettings.ShowAddPlanDialog then
        CreateJobRelatedProcesses(tempdm, PrecedingDataSource, FollowingDataSource);
      //try
        // ���������, ���� �� ���������� ���� ���������� � ����
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
            PlanFrame.UpdateJobControls; // ����� �������� ����������
            // � ������� ����� ����� ����� ��������� ������, ����� ��������� � ���,
            // � �� ���������� � ������ �������
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
    RusMessageDlg('��� ����� ���������', mtWarning, [mbOk], 0);

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
  Result := ExecEditText('������� ������ ������', ReasonText, true);
end;

function TPlanController.GetRemovedJobDesc(Job: TJobParams): string;
begin
  Result := '������ �����: ' + Job.OrderNumber + ', ' + Job.PartName;
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

  if CheckLocked(W) then  // ���� ������������, �������
    Exit;

  if not w.DataSet.IsEmpty then
  begin
    Job := w.CurrentJob;
    if Job = nil then Exit;

    // ���� ���������, ���� ������ ��� �������� ��� �����������, �� �� �������
    // ��� �������� �� ��������� ����� ���� ��������� ��� ���������.
    FactStarted := not VarIsNull(Job.FactStart) or not VarIsNull(Job.FactFinish);
    if FactStarted then
    begin
      RusMessageDlg('������ �������� ������� � ����������� ����������, ������� �� ����� ���� �����.', mtError, [mbOk], 0);
      Exit;
    end;

    CurStart := Job.PlanStart;  // ������ ������, ������� ����� �����
    w.DataSet.Next;   // ���������� ���� ��������� ������
    if not w.DataSet.eof then
    begin
      NextID := w.JobID;
      w.DataSet.Prior;  // ���������� �����
    end
    else
      NextID := 0;

    TransStarted := false;

    if Job.JobType >= JobType_Special then
    begin
      // ��� ���� �����
      ReloadNotPlanned := false;
      BeginUpdates(w);
      GetAdapter(w).RemoveJob(Job);
    end
    else
    begin
      // ��� ������� �����
      ReloadNotPlanned := true;

      if Job.HasSplitMode(smQuantity) or Job.HasSplitMode(smMultiplier) or Job.HasSplitMode(smSide) then
      begin
        if Job.HasSplitMode(smQuantity) and not Job.HasSplitMode(smMultiplier) and not Job.HasSplitMode(smSide) then
        begin
          Res := RusMessageDlg('������ ������� �� ��������� ����������. ����� ��� ������?', mtConfirmation, mbYesNoCancel, 0);
          if Res = mrYes then
          begin
            if not RemoveItemJobsFromPlan(w, Job) then  // ��� �������� beginupdates
              Exit;
          end
          else if Res = mrNo then  // ����� ������ ���� ��������
          begin
            ReloadNotPlanned := false;   // ������� ����� �� �������� 
            // �������� ������ �� ������
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
            // ����������, �� ������ ���� ����������� ��������
            if Job.SplitMode1 = smQuantity then
              sn := 1
            else if Job.SplitMode2 = smQuantity then
              sn := 2
            else if Job.SplitMode3 = smQuantity then
              sn := 3;
            GetAdapter(w).RenumberSplitPartsItem(Job.ItemID, Job.SplitPart1, Job.SplitPart2, sn);
            if AccessManager.CurUser.DescribeUnScheduleJob then  // �������� �� ���� ������ � ���������
              NextID := GetAdapter(w).ReplaceJobWithSpecial(Job.JobID, TStandardDics.SpecialJob_Unscheduled,
                GetRemovedJobDesc(Job) + #13#10 + ReasonText);
          end
          else
            Exit; // Cancel
        end
        else
        begin
          // �������� �� ������ �� ������, ��� ��� �������� ������� ��� ������ �����
          // ���������, ���� �� ������ � ������. ���������
          JobIDs := GetAdapter(w).GetJobsWithFactInfo(Job.ItemID);
          if Length(JobIDs) > 0 then
          begin
            // ���� ������ � ������. ���������, ������� ������� ������
            RusMessageDlg('������ ������� �� ��������� ����������, � ���� �� ���' + #13
              + '�������� ������� � ����������� ����������, ������� �� ����� ���� ����.', mtError, [mbOk], 0);
            Exit;
          end
          else
          begin
            if RusMessageDlg('������ ������� �� ��������� ����������. ����� ����� ��� ������.' + #13
                + '����������?', mtConfirmation, mbYesNoCancel, 0) = mrYes then
            begin
              if not RemoveItemJobsFromPlan(w, Job) then   // ��� �������� beginUpdates
                Exit;
            end
            else
              Exit;
          end;
        end;
      end
      else
      begin
        // ������ �� �������, ������ �������
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
    // ������ ����� ������, ���������� �� ������� ���� // 08.09.2008 - �� ����� �����, ������� �����������
    //CheckShifts;
    if ReloadNotPlanned then
      Plan.Reload;

    if NextID <> 0 then // ���������� �������
      w.Locate(NextID);

    // ���� ���� ������ �� ���������, �� ����� �������� ��
    if not AccessManager.CurUser.DescribeUnScheduleJob and (NextID > 0) then
    begin
      if CheckCanMoveNext(w, NextID, true) and (RusMessageDlg('�������� ��������� ������ �� ����� ���������?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      begin
        BeginUpdates(w);
        MoveJobsUp(w, CurStart, NextID, true);
        // ������ ����� ������, ���������� �� ������� ����
        CheckShifts;
        CommitUpdates(w);
        PlanFrame.UpdateJobControls; // ����� �������� ����������
      end;
    end;
  end;
end;

// ��������� �� ���� ����������� ������, ���� �� ��� ������, ������� ����� �������� �����.
// ������� � JobID.
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

// ���������, ����� �� �������� ������
function TPlanController.CheckCanMove(Job: TJobParams; ShowMessage: boolean): boolean;
begin
  if not VarIsNull(Job.FactStart) then
  begin
    if ShowMessage then
      RusMessageDlg('������ "' + Job.Comment + ' (' + Job.PartName + ')" ��� ��������. �� ����������� ������', mtWarning, [mbOk], 0);
    Result := false;
  end
  else
  if not VarIsNull(Job.FactFinish) then
  begin
    if ShowMessage then
      RusMessageDlg('������ "' + Job.Comment + ' (' + Job.PartName + ')" ��� �����������. �� ����������� ������', mtWarning, [mbOk], 0);
    Result := false;
  end
  else if Job.TimeLocked then
  begin
    if ShowMessage then
      RusMessageDlg('������ "' + Job.Comment + '" �������������. �� ����������� ������', mtWarning, [mbOk], 0);
    Result := false;
  end
  else
    Result := true;
end;

// ���� ������, ������� ����� ��������, ������� � ������� (LastUnmovableJob).
// ���������� ��������� ������������ ������.
// MovedJobID - ������, ������� ����������
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
      // ������� ����� ��������
      if CheckCanMove(CurJob, false) then
      begin
        Result := true;
        Exit
      end
      else
      // ���� ���� ����� ����� ���������� ���������� ������ � ������� �������
      //if (CurJob.AnyStart - LastUnmovableFinish >= JobDuration) then
      if MinutesBetween(CurJob.AnyStart, LastUnmovableFinish) > MIN_JOB then
      begin
        Result := true;
        Exit;
      end
      else  // ������� ���������� ��������� ������������
      begin
        LastUnmovableFinish := CurJob.AnyFinish;
        LastUnmovableJob := CurJob;
      end;
    end
    else
    begin
      // ��������� �� ������, ������� ��� � ���� ��������.
      // ������, ��� ��������� �� ����� ����� ��� ���������� � ��������� ������������
      Result := true;
      Exit;
    end;
  end;
  // �� �����, ������ ����� ��������� ������������
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
      // ���� ����. ������ - ������ �����, ���������� ���
      if w.IsShiftMarker then
      begin
        WasShiftMarker := true;
        ShiftStart := w.AnyStartDateTime;
        w.DataSet.Next;
        if not w.DataSet.Eof then
        begin
          // ���� ����� ������ �����, ������������ �� ���������� ������ � ������ ����
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
            // ������ ����� ����������� �������. ���������
            CheckShifts;

            Exit;  // ���
          end;
        end;
      end;
      if CheckCanMove(w.CurrentJob, false) then   // ��� ���������
      begin
        // �������� ������ ������
        if WasShiftMarker then
        begin
          // ���� ������ ����� �� � ������ �����, �� ��������� ����� ���
          if MinuteSpan(ShiftStart, w.AnyStartDateTime) > MIN_JOB then
            CurJob.PlanStart := ShiftStart
          else // ����� ������ ����� ������ ������
            CurJob.PlanStart := w.AnyFinishDateTime;
          CurJob.PlanFinish := CurJob.PlanStart + CurFinish - CurStart;
          if CheckMovingJob(CurItemID, CurJob) then
            w.Reload;
        end
        else
        begin
          // ������ ������� ����������� � �������
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
        // ������ �������� ������, ������, ���� ��������� ���� ������ ����� ���.
        // ���� ����� ��, ������� ����� ��������
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
          CheckCanMove(w.CurrentJob, true); // ���������� ��������� �� ������
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
      // ���� ������. ������ - ������ �����, ���������� ���
      if w.IsShiftMarker then
      begin
        PriorStart := w.AnyStartDateTime;
        w.DataSet.Prior;
        if not w.DataSet.Bof then
        begin
          // ���� ����� ������ �����, ��� ����� ���� 2 ��������:
          // 1. ������������ �� ���������� ����� � ������ ����� ���
          // 2. ������ � ������ �����
          if w.IsShiftMarker then
          begin
            { ������� 1:
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
            // ������� 2:
            Database.BeginTrans;
            try
              GetAdapter(w).UpdatePlan(CurID, w.AnyStartDateTime, w.AnyStartDateTime + CurFinish - CurStart);
              Database.CommitTrans;
            except
              Database.RollbackTrans;
              raise;
            end;

            w.Reload;
            // ������ ����� ����������� �������. ���������
            CheckShifts;

            Moved := true;  // ���
          end
          else
          begin
            // ���� �� ����� �� ������, ����������� � ���������� �����,
            // �� ���� ���������, ���� �� ��� ����� � ���� �����
            if MinuteSpan(PriorStart, w.AnyFinishDateTime) > MIN_JOB then
            begin
              // ������ ����
              GetAdapter(w).UpdatePlan(CurID, w.AnyFinishDateTime, w.AnyFinishDateTime + CurFinish - CurStart);
              // ������ ����� ����������� �������. ���������
              w.Reload;
              CheckShifts;

              Moved := true;
            end;
            // ����� ����� ���� - ���� ������ � ������ ������� � ������� � �����
          end;
        end;
      end;

      if not Moved then
      begin
        // ��������� ���� �� ����� ����� ��������
        if CurStart - w.AnyFinishDateTime > 0 then
        begin
          GetAdapter(w).UpdatePlan(CurID, w.AnyFinishDateTime, w.AnyFinishDateTime + CurFinish - CurStart);
          Moved := true;
          // ������ ����� ����������� ������� ��� �����������. ���������
          w.Reload;
          CheckShifts;
        end
        else
        if CheckCanMove(w.CurrentJob, true) then
        begin
          // �������� ������ ����� - ������ ������� ���������� � �������
          PriorStart := w.AnyStartDateTime;
          PriorFinish := w.AnyFinishDateTime;
          PriorID := w.JobID;
          // ����� ������ ���������� ������
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
          // ������ ����� ����������� ������� ��� �����������. ���������
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
      // � ����������� ������ ������� ������ �����
      if ContinuousMode(w) then
      begin
        if not w.LocateShift then Exit;  // ��������� �����
      end else
        w.DataSet.First;

      if w.IsShiftMarker then
      begin
        // ����� �� ������ �����
        w.DataSet.Next;
        if w.JobID = CurID then // ���� ���� ������ ����� ������ �� ������ �� ������
          Exit;
      end;
      FirstJobID := w.JobID;

      if CurID <> w.JobID then  // ���� ��� �� ������ ������
      begin
        // �������� �� ���� ������� � ��������� ��� �� �����, ������� ������ ��������
        CanMove := true;
        // ���� �� ������ �� �����
        while not w.DataSet.Eof and (CurID <> w.JobID) and CanMove do
        begin
          CanMove := CheckCanMove(w.CurrentJob, true);
          w.DataSet.Next;
        end;
        if CanMove then  // ���� ��� ���������, �� ��������
        begin
          w.Locate(FirstJobID);
          Database.BeginTrans;
          try
            NextStart := w.AnyStartDateTime; // ����� ������ ���������� ������
            GetAdapter(w).UpdatePlan(CurID, NextStart, NextStart + CurFinish - CurStart);
            while not w.DataSet.eof do
            begin
              NextID := w.JobID;
              if NextID <> CurID then  // ����� ��� ������� ������ � ������
              begin
                NextStart := w.AnyStartDateTime; // ������ � ����� �����, ��������� ����� ������
                NextFinish := w.AnyFinishDateTime;
                NewStart := NextStart + CurFinish - CurStart; // ����� ������ ��������� ������
                GetAdapter(w).UpdatePlan(NextID, NewStart, NewStart + NextFinish - NextStart);
              end
              else
                break;  // ���� ����� �� ������, ������� ������� � ������, �� ������ �� ����
              w.DataSet.Next;
            end;
            Database.CommitTrans;
          except
            Database.RollbackTrans;
            raise;
          end;
          w.Reload;
          // ��������� ����������� ������ ����
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
      // TODO: ���� ��������� �� ������ ������, ��� ����� �������� ��� ������
      w.DataSet.Next;  // ��������� �� ��������� ������ � � ��� ������ �������� �����
      if CheckCanMove(w.CurrentJob, true) then
      begin
        if not w.DataSet.Eof then  // ���� ��� ��� �� ��������� ������
        begin
          Database.BeginTrans;
          try
            while not w.DataSet.eof do
            begin
              // � ����������� ������ ������������ �� ����� �����
              if ContinuousMode(w) and w.IsShiftMarker then
                break;
              NextID := w.JobID;
              NextStart := w.AnyStartDateTime; // ������ � ����� �����, ����� ����������� ����� �����
              NextFinish := w.AnyFinishDateTime;
              NewStart := NextStart - CurFinish + CurStart; // ����� ������ ��������� ������
              NewFinish := NewStart + NextFinish - NextStart;
              GetAdapter(w).UpdatePlan(NextID, NewStart, NewFinish);
              w.DataSet.Next;
            end;
            NextStart := NewFinish; // ����� ������ ���������� ������
            GetAdapter(w).UpdatePlan(CurID, NextStart, NextStart + CurFinish - CurStart);
            Database.CommitTrans;
          except
            Database.RollbackTrans;
            raise;
          end;
          // �� ������ ������ ��������� ����������� � ��������� ����
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

  if CheckLocked(W) then  // ���� ������������, �������
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
            // ������ ������ ����� ���������
            if TargetJobID < 0 then
              TargetFinish := w.GetShiftByID(TargetJobID).Start  // ���� ������� �� ������ �����
            else
            begin
              TargetJob := w.JobList.GetJob(TargetJobID);
              TargetFinish := TargetJob.AnyFinish;  // ���� ������� �� ������ ������
            end;
            //TargetShift := w.GetShift(TargetJobID);
            CurStart := Job.PlanStart;
            BeginUpdates(w);
            Job.PlanStart := TargetFinish;
            Job.PlanFinish := Job.PlanStart + (Job.PlanFinish - CurStart);
            //w.JobList.Remove(Job);  // �������� �������, ����� �� ��������
            //SourceShift.JobList.Remove(Job);
            //TargetShift.JobList.Insert(TargetShift.JobList.IndexOf(TargetJob) + 1, Job);
            if CheckMovingJob(Job.ItemID, Job) then
            begin
              //w.JobList.Add(Job);  // ��������� �������
              //w.SortJobs;          // ������ �� ������ �����
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
  _ReadOnly := IsLocked(W);  // ���� ������������, ������ ��� ������

  Job := w.CurrentJob;
  if Job = nil then Exit;

  CurID := Job.JobID;

  Estimated := NvlInteger(TConfigManager.Instance.StandardDics.deSpecialJob.ItemValue[Job.JobType, 1]);
  if Estimated = 0 then Estimated := 1; // ������� ������������ �� ��������

  PrevFinishTime := GetPrevFinishTime(w, Job);
  SetExecutor(w, Job);  // ����� ����������� �� ���������� � �����, ���� ����
  Job.EstimatedDuration := Estimated;
  Job.ClearChanges;  // ������� ������ ��������� �����

  if not _ReadOnly and not w.Locked then
  begin
    _ReadOnly := CheckLocked(w);  // ���������
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
    PlanFrame.UpdateJobControls; // ����� �������� ����������
  end
  else
    // ���� ��� ������������ ������ ��� � ��������, �� ������� ����������
    if _JustLocked then
      UnlockWorkload(w);
end;

procedure TPlanController.SetExecutor(w: TWorkload; Job: TJobParams);
var
  CurJobID: integer;
  NewExecutor: variant;
  Shift: TShiftInfo;
begin
  // ���� �������� ������ �� ��������, �� ������ ����������� �� �����
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

// ���� ������ ������� �� ������, �� ���� ���������� ����������� �������� � ��������-��������� ��������� �������.
// ���� �� ������� �� ������, � ����������� ��������� ������ ��������, �� ��������� ����� ������.
// w - �� ��������������, Job - �����.
procedure TPlanController.ProcessFactProductOutChange(w: TWorkload; Job: TJobParams);

  function ConfirmUser: boolean;
  begin
    Result := RusMessageDlg('����������� ��������� ������ ��������. �������� �������������� ������?',
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

  // ����������� ��������
  FactSpeed := Round(NewFactProd / (Job.AnyFinish - Job.AnyStart));

  if (NewFactProd < Job.ProductOut) and not Job.HasSplitMode(smQuantity)
    and (FactSpeed > 0) then
  begin
    // ��� �������� �� ������, ���������
    RestDuration := (Job.ProductOut - NewFactProd) / FactSpeed;
    if (MinuteSpan(RestDuration, 0) > MIN_JOB) and ConfirmUser then
    begin
      // ��������� ����� ������� ������, ������ ��� ����� ������� ������
      sn := GetAdapter(w).UpdateJobSplitMode(Job, Job.AnyStart, Job.AnyFinish, smQuantity,
        false);  // auto split � ���� ������, ����� ���������, ���� ����� �������� ����. ����
      // ��� ������� ����� ��������
      NewJobID := GetAdapter(w).AddSplitJob(Job, Job.AnyFinish, Job.AnyFinish + RestDuration, sn);
      // ����� �������� ���������, ����� ��� ���� ����� ������ ��������
      GetAdapter(w).UpdatePlan(Job);
      // ������ ����� ����� ��������������
      RenumberItemJobs(w, Job, sn);
      // ������ �� ���������� �����
      NewJob := w.JobList.GetJob(NewJobID);//w.CurrentJob;
      CheckMovingJob(Job.ItemID, NewJob);
    end;
  end
  else if Job.HasSplitMode(smQuantity) and (FactSpeed > 0) then
  begin
    // ��������-��������� ��������� �������.
    // ���� ��������� �������
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
        // ��������� ����� ����� ��� ���������� �������...
        // ����� ���� ������������� ��������
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
          // �������� ��������� ������
          LastJob.PlanFinish := LastJob.PlanStart + RestDuration;
          // ������ ����� ������� �� ���������, ������� ��������
          CheckMovingJob(LastJob.ItemID, LastJob);
          // ����� ��������� ���������� ����� ���������� ������� "��������". �� ����� �������.
          GetAdapter(w).RemoveZeroTimeJobs(LastJob);
        end;
      end
      else
      begin
        // ���� ��� ��������� �������, �� ����������, ���� �� �������� ��� ����
        RestDuration := (Job.ProductOut - NewFactProd) / FactSpeed;
        if (MinuteSpan(RestDuration, 0) > MIN_JOB) and ConfirmUser then
        begin
          NewJobID := GetAdapter(w).AddSplitJob(Job, Job.AnyFinish, Job.AnyFinish + RestDuration, sn);
          // ����� �������� ���������, ����� ��� ���� ����� ������ ��������
          GetAdapter(w).UpdatePlan(Job);
          // ������ ����� ����� ��������������
          RenumberItemJobs(w, Job, sn);
          // ������ �� ���������� �����
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
  // ���� ���� ������������ ��� ��� ���� �� ������������ � ������. �������, �� ������� ������ ��� ������
  _ReadOnly := not KPRec.PlanDate and not KPRec.FactDate or IsLocked(W);

  if not _ReadOnly and not w.Locked then
  begin
    _ReadOnly := CheckLocked(w);  // ���������
    _JustLocked := true;
  end
  else
    _JustLocked := false;

  Job := w.CurrentJob;

  SetExecutor(w, Job);  // ����� ����������� �� ���������� � �����, ���� ����

  JobCopy := Job.Copy;  // ����� ��� ���������
  try
    PrevFinishTime := GetPrevFinishTime(w, Job);
    CurID := Job.JobID;

    // ������� ������ � ���������, �������������� � ����������� ��������
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
        // ���� �� ����������� ����������� �������?
        FactSet := (NvlDateTime(Job.FactStart) > 0) and (NvlDateTime(JobCopy.FactStart) = 0)
            or (NvlDateTime(Job.FactFinish) > 0) and (NvlDateTime(JobCopy.FactFinish) = 0);
        if FactSet then
        begin
          // ���� ������ ������ ����������� �� �������,
          // �� ���������, ������� �� ��� �������������� � ���� �����.
          if EntSettings.FactDateStrictOrder then
            AllowChangeFact := CheckSetFactOrder(Job)
          else
            AllowChangeFact := true;

          if not AllowChangeFact then
          begin
            RusMessageDlg('����������� ������� ������ ��������� � ������� ����������� �������. ��������� �� �������.',
              mtError, [mbOk], 0);
            Result := false;
            Exit;
          end;
        end;

        // ������ ��������� ���� ����� ����� �� ����������� �������?
        FactRemoved := (NvlDateTime(Job.FactStart) = 0) and (NvlDateTime(JobCopy.FactStart) > 0)
            or (NvlDateTime(Job.FactFinish) = 0) and (NvlDateTime(JobCopy.FactFinish) > 0);
        if FactRemoved then
        begin
          // ���� ������ ������ ����������� �� �������,
          // �� ���������, ����� �� ������� �� ���� ����������� � ���� �����.
          if EntSettings.FactDateStrictOrder then
            AllowChangeFact := CheckRemoveFactOrder(Job)
          else
            AllowChangeFact := true;

          if not AllowChangeFact then
          begin
            RusMessageDlg('������� ����� ����� ����������� ������� �� ���� ����������� �������. ��������� �� �������.',
              mtError, [mbOk], 0);
            Result := false;
            Exit;
          end;
        end;

        BeginUpdates(w);

        // TODO: ����� ���� ���������, ���� �� ���������
        if CheckMovingJob(Job.ItemID, Job) then
        begin
          // ���� ��������� ������� ������� � ����,
          // ���������, �������� �� ����������� ���������
          FactProductOutChanged := NvlInteger(Job.FactProductOut) <> NvlInteger(JobCopy.FactProductOut);
          if FactSet or FactProductOutChanged then
          begin
            // ���� ���������� ������. ���������, �� ���� ���������� ��������
            if NvlInteger(Job.FactProductOut) <> NvlInteger(JobCopy.FactProductOut) then
            begin
              ProcessFactProductOutChange(w, Job);
            end;
            // ���������� �������� ��������� ������
            EditOrderState(JobCopy);
          end
          else
        end;
        Result := true;
        CheckShifts;

        CommitUpdates(w);
        if w.Locate(CurID) then  // ������ ����� ��������� � ������ � �� ��� ���
        begin
          Job := w.CurrentJob;

          PlanFrame.UpdateJobControls;
          // ���������, ����������� �� ������ � ���������� ��������
          if ((w.KeyValue = CurID) or w.Locate(CurID)) and (JobCopy.AnyFinish > Job.AnyFinish)
            and (MinutesBetween(JobCopy.AnyFinish, Job.AnyFinish) > 1) then
          begin
            if CheckCanMoveNext(w, Job.JobID, false) and (RusMessageDlg('�������� ����������� ������ �� �������������� �����?',
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
        // ���� ��� ������������ ������ ��� � ��������, �� ������� ����������
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

// �������� ������ �����. IncludeJob ��������, ��� ����� �������� ��������� ������.
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
    // ���� ���������� �� �������� ������, �� ����������
    //if CurJob.JobID <> Job.JobID then
    //begin
    TLogger.GetInstance.Debug('����� ������: Start: ' + DateTimeToStr(CurJob.AnyStart)
       + ', Finish: ' + DateTimeToStr(CurJob.AnyFinish));
    CanMove := CheckCanMove(CurJob, false);
    if CanMove then    // ������������ �� �������
    begin
      NewFinish := NewStart + (CurJob.AnyFinish - CurJob.AnyStart);
      //GetAdapter(w).UpdatePlan(CurJob.JobID, NewStart, NewFinish);
      CurJob.PlanStart := NewStart;
      CurJob.PlanFinish := NewFinish;
      NewStart := NewFinish;
    end
    else
      break;     // ����������� ����� �� ������ �� ���������������
  end;
end;

procedure DumpWorkload(w: TWorkload; FromWhere: string);
var
  I: Integer;
  Job: TJobParams;
begin
  // ������� � ��� ���� ���� � ������ ���������� �����������
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
  NewStart := StartTime;     // ��� ������ ����� ������ ����� ����� ����� ��������
  Finished := false;
  CurJobIndex := w.JobList.IndexOf(Job);

  SetLength(TailIDs, w.JobList.Count - CurJobIndex);
  for JobIndex := CurJobIndex to w.JobList.Count - 1 do
  begin
    CurJob := w.JobList[JobIndex];
    // ��������� � ������ ��� ������������ ������
    TailIDs[JobIndex - CurJobIndex] := CurJob.JobID;
  end;

  TailJobs := TJobList.Create;
  try
    for I := Low(TailIDs) to High(TailIDs) do
    begin
      CurJob := w.JobList.GetJob(TailIDs[I]);
      TLogger.GetInstance.Debug('����� ������: Start: ' + DateTimeToStr(CurJob.AnyStart)
         + ', Finish: ' + DateTimeToStr(CurJob.AnyFinish));
      //if CurJob.AnyStart > NewStart then  // ���� ������ ������� ���������� ������, ����������� �����
      //  break;
      CanMove := CheckCanMove(CurJob, false);
      if CanMove then    // ������������ �� �������
      begin
        // ��������� �� ��������� ������ ��� ������������ ������ � ������� �� �� ������ �����
        TailJobs.Add(CurJob);
        w.JobList.Remove(CurJob);

        // ���� ������ ������� ���������� ������, �� �� �� ��������, �� ������� � ������.
        if CurJob.AnyStart < NewStart then
        begin
          // ������ �� ��������� �����
          NewFinish := NewStart + (CurJob.PlanFinish - CurJob.PlanStart);
          CurJob.PlanStart := NewStart;
          CurJob.PlanFinish := NewFinish;

          // ���� ���� ������������ ������, ������� ���������� ������ ������ �����
          // � ������������� ����� ������ CurJob, �� CurJob ���� ��������� ����� ������������.
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
    // ������ ������ ��� ������ �� �����
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

// ���������, ���� �� ����������� � ����� �� �������� �������� � ������� �������,
// ���� ����, ���������� ��������� � �������� ������� ������ ���� ������ � �����.
// ���� CurItemID = 0, �� ������ ���������
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

  AnyStart := Job.AnyStart;    // ������ �������� ������
  AnyFinish := Job.AnyFinish;  // ��������� �������� ������

  // �������� ������� ������ �� ������ ������, ����� �� ������
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
          // ������� ������, ������������ ������ � ��������������� ����� ������ ����� ������.
          // ������ ���� ������ ����� ���������.
          { ======= CurJob =======>
                  =========== Job ==========> }
          if (CurJob.AnyStart < AnyStart) and (CurJob.AnyFinish > AnyStart)
            and (SecondsBetween(CurJob.AnyFinish, AnyStart) > 1) then
          begin
            //CanMove := true;
            AfterUnmovable := true;
          end
          // ������� ������, ������������ ����� ������ � ������ ��������� ����� ������.
          // ��� ������ ���������������.
          {             ======= CurJob =======>
             =========== Job ==========> }
          else
          if (CurJob.AnyStart >= AnyStart) and (CurJob.AnyStart < AnyFinish)
            and (SecondsBetween(CurJob.AnyStart, AnyFinish) > 1) then
          begin
            // ���������, ����� �� �������� ������...
            TLogger.GetInstance.Debug('���������, ����� �� �������� ������...');
            // ���� ����������� �������, �� �������� ������ (�� ������ ������ ��������)
            CanMove := CheckCanMove(CurJob, false); // ��� ���������
            if CanMove then
            begin
              // ���������� ������� �������
              CurJobKey := CurJob.JobID;
              // ����� ������ �� ����� �������� ������
              GetAdapter(w).UpdatePlan(Job);
              Applied := true;
              // �������� ��� ������ � ��� ��� �� ���
              MoveFromJobDown(w, CurJob, AnyFinish);
              DumpWorkload(w, 'CheckMovingJob, after MoveFromJobDown');
              Result := true;
              Exit;
            end;
          end;

          if not CanMove then
          begin
            // �������� ��������������� ������ ������, ������� �������� ����� �����, ���� ����� ��������� ��� ������
            UnmovableJobID := CurJob.JobID;
            // ���� ������ ����� ����� ������, �� ������ ����� ��������������...
            if (MinuteSpan(AnyStart, CurJob.AnyStart) < MIN_JOB)
               or (CurJob.AnyStart < AnyStart) and (CurJob.AnyFinish > AnyStart) then
              AfterUnmovable := true
            else
            begin
              // ... ����� ���� ��� �������� - ��������� ����� ��� �������
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
            // CurJob - ������, ����� ������� ����� ���������
            Job.PlanStart := CurJob.AnyFinish;
            Job.PlanFinish := CurJob.AnyFinish + AnyFinish - AnyStart;
            AnyStart := Job.AnyStart;    // ������ �������� ������
            AnyFinish := Job.AnyFinish;  // ��������� �������� ������
            // ��������� �������� �������, ������ ��� ����� CurJob ����� ���� ���������� ������
            RepeatCheck := true;
            continue;
          end;
        end;
      end;
      // ������ ��� ������, ����� ��������
      //RepeatCheck := false;
    //end
    until not RepeatCheck;
    // ������ ������ �� ����� ������ � ������� ��� � ��������
    if not Applied then
      GetAdapter(w).UpdatePlan(Job);
    Result := true;
  finally
    // ���� ������� ������ �� ������, ���������� �������
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

// ����������, ��� ��������� ������
function GetSplitModeEx(Job: TJobParams; var SplitMode: TSplitMode;
   SelectFunc: TSelectSplitFunc; Params: pointer; AlwaysAsk: boolean): boolean;
var
  AllowSplitMult, AllowSplitSide: boolean;
begin
  AllowSplitMult := Job.Multiplier > 1;
  AllowSplitSide := Job.SideCount > 1;
  Result := true;

  if VarIsNull(Job.SplitMode1) then  // ��� �� �������
    Result := SelectFunc(SplitMode, true, AllowSplitMult, AllowSplitSide, Params)
  else
  if (TSplitMode(NvlInteger(Job.SplitMode1)) = smQuantity) and not VarIsNull(Job.SplitPart1) then
  begin
    if VarIsNull(Job.SplitMode2) then  // ������ �������� ��� ��� ������
      Result := SelectFunc(SplitMode, true, AllowSplitMult, AllowSplitSide, Params)
    else
    if Job.SplitMode2 = smMultiplier then
    begin
      if NvlInteger(Job.SplitPart2) = 0 then
      begin
        // ������ �������� ������ ��� ������ �� ������, ������ ����� ���� ������ �� ������
        SplitMode := smMultiplier;
        if AlwaysAsk then
          Result := SelectFunc(SplitMode, false, true, false, Params);
      end
      else
      begin
        // ����� �������� - �������� ������ �� ��������
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
        // ������ �������� ������ ��� ������ �� ��������, ������ ����� ���� ������ �� ��������
        SplitMode := smSide;
        if AlwaysAsk then
          Result := SelectFunc(SplitMode, false, false, true, Params);
      end
      else
      begin
        // ����� �������� - �������� ������ �� ������
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
    if VarIsNull(Job.SplitMode2) then  // ������ �������� ��� ��� ������
      Result := SelectFunc(SplitMode, true, false, AllowSplitSide, Params)
    else
    if Job.SplitMode2 = smQuantity then
    begin
      if NvlInteger(Job.SplitPart2) = 0 then
      begin
        // ������ ���� ��� ������ �� ������, ������ ����� ���� ������ �� ������
        SplitMode := smQuantity;
        if AlwaysAsk then
          Result := SelectFunc(SplitMode, true, false, false, Params);
      end
      else
      begin
        // ����� �������� - �������� ������ �� ��������
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
        // ������ ���� ��� ������ �� ��������, ������ ����� ���� ������ �� ��������
        SplitMode := smSide;
        if AlwaysAsk then
          Result := SelectFunc(SplitMode, false, false, true, Params);
      end
      else
      begin
        // ����� �������� - �������� ������ �� ������
        SplitMode := smQuantity;
        if AlwaysAsk then
          Result := SelectFunc(SplitMode, true, false, false, Params);
      end;
    end;
  end
  else
  if (TSplitMode(NvlInteger(Job.SplitMode1)) = smSide) and not VarIsNull(Job.SplitPart1) then
  begin
    if VarIsNull(Job.SplitMode2) then  // ������ �������� ��� ��� ������
      Result := SelectFunc(SplitMode, true, false, AllowSplitSide, Params)
    else
    if Job.SplitMode2 = smQuantity then
    begin
      if NvlInteger(Job.SplitPart2) = 0 then
      begin
        // ������ ���� ��� ������ �� ������, ������ ����� ���� ������ �� ������
        SplitMode := smQuantity;
        if AlwaysAsk then
          Result := SelectFunc(SplitMode, true, false, false, Params);
      end
      else
      begin
        // ����� �������� - �������� ������ �� ��������
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
        // ������ ���� ��� ������ �� ��������, ������ ����� ���� ������ �� ��������
        SplitMode := smSide;
        if AlwaysAsk then
          Result := SelectFunc(SplitMode, false, false, true, Params);
      end
      else
      begin
        // ����� �������� - �������� ������ �� ������
        SplitMode := smQuantity;
        if AlwaysAsk then
          Result := SelectFunc(SplitMode, true, false, false, Params);
      end;
    end;
  end;
end;

// ������ � Jobs �� ������ ���� � ������ �����!
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
    // TODO: ����� �� ���������� ��������� �� ������ �����. ���������!
    if CheckMovingJob(NewJob.ItemID, NewJob) then
      //w.Reload;
      ;
    DumpWorkload(w, 'PlaceJobs, after CheckMovingJob 1');
    // ���� ������ ������������� ������, �� ���� �������� ��� ���������, ������� ���� ����� ���
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

// ����������, ��� ��������� ������, ��� ������ ����������� ������������
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
    TLogger.GetInstance.Debug('CheckMovingJob: ��������� �� ��������� �� ' + VarToStr(Job.Multiplier) + ' ����������');
    SplitJobIDs := SplitJobByMultiplier(w, Job, true);  // auto
    SplitJobs := TJobList.Create;
    try
      // ������� ������������ ��������� �� ����� � ��������� �� �� ������, ����� ��� ������������
      for I := Low(SplitJobIDs) to High(SplitJobIDs) do
      begin
        NewJob := w.JobList.GetJob(SplitJobIDs[I]);
        w.JobList.Remove(NewJob);
        SplitJobs.Add(NewJob);
      end;

      // ������ ��������� � ����������� ���������, ���� ��� ������������� � ���-����
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
    // ������������ ������ ��������
    Half2Duration := Job.AnyFinish - Job.AnyStart - (UnmovableJob.AnyStart - Job.AnyStart);
    // ���� ����������, ������� �� ������ �������� ����� ������������ ������
    UnmovableJob1 := UnmovableJob;
    LocateMovableJob(w, UnmovableJob1, Job.JobID, Half2Duration);
    // ��������� ������ �� ������, ������ �������� ������ ����� ������������ ������
    Half2JobID := SplitJobByQuantityEx(w, Job, true, Job.AnyStart, UnmovableJob.AnyStart, UnmovableJob1.AnyFinish,
    UnmovableJob1.AnyFinish + Half2Duration);
    NewJob := w.JobList.GetJob(Half2JobID);
    DumpWorkload(w, 'SplitJobAroundUnmovable, before CheckMovingJob');
    // TODO: ����� �� ���������� ��������� ������ �� ������ �����. ���������!
    if CheckMovingJob(NewJob.ItemID, NewJob) then
      //w.Reload;
      ;
    DumpWorkload(w, 'SplitJobAroundUnmovable, after CheckMovingJob');
    CheckShifts;
  end;

  procedure BySides;
  begin
    // ���� ����������, ������� �� ���� ������� ����� ������������ ������.
    // ���������� ������������ ������ ������� � �������.
    m := Trunc(MinuteSpan(Job.AnyFinish, Job.AnyStart) / 2);
    // ���������� ������������ ������� �����.
    Half2Duration := Job.AnyFinish - IncMinute(Job.AnyStart, m);
    UnmovableJob1 := UnmovableJob;
    if LocateMovableJob(w, UnmovableJob1, Job.JobID, Half2Duration) then
    begin
      TLogger.GetInstance.Debug('CheckMovingJob: ��������� �� ������� �� 2 ���������');
      Half2JobID := SplitJobBySides(w, Job, true);  // auto
      NewJob := w.JobList.GetJob(Half2JobID);
      // TODO: ����� �� ���������� ��������� ������ �� ������ �����. ���������!
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
    (*// ���� ��������� �������� - �� ������, �� �� ������ � ����
    // ������� ��������� �� ������, ���� ��� ����
    if not Job.HasSplitMode(smMultiplier) and (Job.Multiplier > 1) then
    begin
      // ����� ����, �� �������� ��������� ���
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
    // ����� �� ��������, ���� ��� ����
    if not Job.HasSplitMode(smSide) and (NvlInteger(Job.SideCount) > 1) then
    begin
      // �������� �� ������ ��� ����
      if (Job.SplitMode2 = smQuantity) and (NvlInteger(Job.SplitPart2) = 0) then
        // ������ ���� ��� ������ �� ������, ���� ���� �� ������
        SplitMode := smQuantity
      else if (Job.SplitMode2 = smMultiplier) and (Job.Multiplier > 1) and (NvlInteger(Job.SplitPart2) = 0) then
        // ������ ����� ������ ��� ������� �� ������, ���� ��� ����� �� ������
        SplitMode := smMultiplier
      else if (Job.SplitMode2 = smSide) and (NvlInteger(Job.SplitPart2) = 0) then
        // ������ ���� ��� ������ �� ��������, ���� ���� �� �� ��������
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
    else   // �� ������
    begin
      ByQuantity;
      Result := true;
    end;

    if not Result then
    begin
      RusMessageDlg('�� ������� ��������� �����', mtError, [mbOk], 0);
      Result := false;
    end;*)
    if not GetSplitMode(Job, SplitMode) then
    begin
      RusMessageDlg('������ ������� �� �������', mtError, [mbOk], 0);
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

// ���������� ���� �� ����������� �� �������, � ���������� ���� ������ �����
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
  // ������, �������� �� ����� ��� �������, ���� ����� �����, ���� ��� ����������� � ������ ���������,
  // ������� �� ��������� �� �����
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
  if IntersectShift(w, Job, ShiftStart) then     // �����������
  begin
    //WasSplit := false;
    TLogger.GetInstance.Debug('CheckShifts: ������� ����������� � �������� ����� � ������ AnyStart = ' + DateTimeToStr(Job.AnyStart)
      + ', AnyFinish = ' + DateTimeToStr(Job.AnyFinish)
      + ' ShiftStart = ' + DateTimeToStr(ShiftStart));
    CurJobID := Job.JobID;

    SplitParams.AtShiftStart := false;
    SplitParams.ShiftStart := ShiftStart;
    SplitParams.Job := Job;
    // ������ ���������� ���� ������, �.�. ��� ���� ��� ����������� ��������� �� ������ �����,
    // ������� AlwaysAsk = true.
    if GetSplitModeEx(Job, SplitMode, DoExecJobSplitShiftForm, @SplitParams, true) then
    begin
      if not SplitParams.AtShiftStart then
      begin
        if SplitMode = smQuantity then
        begin
          TLogger.GetInstance.Debug('CheckShifts: ��������� �� ������ �� 2 ���������');
          FinishTime := Job.AnyFinish;
          SplitJobID := SplitJobByQuantityEx(w, Job, true, Job.AnyStart, ShiftStart,
            ShiftStart, FinishTime);
          // ��� ������� ���� ������� ���������, ������ ������. �������, ���� ������ �������� ��� �����������
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
          TLogger.GetInstance.Debug('CheckShifts: ��������� �� �������� �� 2 ���������');
          SplitJobBySides(w, Job, true);  // auto
          //WasSplit := true;
          RepeatCheck := true;
        end
        else if SplitMode = smMultiplier then
        begin
          TLogger.GetInstance.Debug('CheckShifts: ��������� �� ��������� �� ' + VarToStr(Job.Multiplier) + ' ����������');
          SplitJobByMultiplier(w, Job, true);  // auto
          //WasSplit := true;
          RepeatCheck := true;
        end;
      end
      else // ������ � ������ ��������� �����
      begin
        FinishTime := ShiftStart + (Job.PlanFinish - Job.PlanStart);
        Job.PlanStart := ShiftStart;
        Job.PlanFinish := FinishTime;
        CheckMovingJob(Job.ItemID, Job);
        RepeatCheck := true;
      end;
    end
    else ;// TODO: �� ����, ������� �� ����?
  end;
  Result := RepeatCheck;
end;

// ��������� ������� � ������� � ���, ������������� �� ��� �� �������
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

// � ������ ������������ ����������� ����� ������, ���������� �� ������� ����,
// � ���������� ������, ������� ���� ������ ������� �������� �����, � ������ ���.
// ���������� true, ���� ���� ��������� � ���� ������������
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
    // ���������� ������� � ����
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
    while RepeatCheck do    // ����� ����������� ����� ���� ��������
    begin
      //RepeatCheck := false;
      for JobIndex := 0 to w.JobList.Count - 1 do
      begin
        Job := w.JobList[JobIndex];
        RepeatCheck := CheckShiftOverlap(w, Job);
      end;
    end;
  end;

  // ������ ���� ���������, ����� �� ������� ��������� ������, ������� ���� ������� �����
  SaveShiftID := 0;
  for ShiftIndex := 0 to w.ShiftList.Count - 1 do
  begin
    CurJob := nil;
    Shift := w.ShiftList[ShiftIndex];
    JobIndex := 0;
    while JobIndex < Shift.JobList.Count do
    begin
      Job := Shift.JobList[JobIndex];
      // ���� ��� ����. �������, �� ����� ������ ���������, ����� �� � ���� ������ ��������� ������
      if (CurJob = nil) and CanMerge(Job) then
      begin
        SaveJob;
      end
      // ���� �������� ��� �� ������ � ��� ����. ������� � ������� �������������
      else if (CurJob <> nil) and (CurJob.ItemID = Job.ItemID) and (CurJob.ItemID <> 0) and CanMerge(Job) then
      begin
        sm1 := Job.SplitMode1;
        sm2 := Job.SplitMode2;
        sm3 := Job.SplitMode3;
        sn := 0;
        // �� ������ ���� ��������
        AllowMerge := (sm1 = smSide) and (NvlInteger(Job.SplitPart2) = 0) and (SplitPartQuantity = 0) and (SplitPartMult = 0)
            or (sm1 = smQuantity) and (NvlInteger(Job.SplitPart2) = 0) and (SplitPartSide = 0) and (SplitPartMult = 0);
        if AllowMerge then
          sn := GetSplitModeNum(Job, sm1)  // ����������, �� ������ ���� ����������� ��������
        else
        begin
          // �� �������, ����� �� ������ - ��������� ����� �������
          AllowMerge := ((sm1 = smSide) and (sm2 = smQuantity) and (NvlInteger(Job.SplitPart3) = 0) and (SplitPartMult = 0) and (SplitPartSide = Job.SplitPart1))
            or ((sm2 = smSide) and (sm3 = smQuantity) and (SplitPartMult = Job.SplitPart1) and (SplitPartSide = Job.SplitPart2));
          if AllowMerge then
            sn := GetSplitModeNum(Job, smQuantity)
          else
          begin
            // �� �������, ����� �� ������
            {AllowMerge := ((sm1 = smSide) and (sm2 = smMultiplier) and (NvlInteger(Job.SplitPart3) = 0) and (SplitPartSide = Job.SplitPart1))
              or ((sm2 = smSide) and (sm3 = smMultiplier) and (SplitPartQuantity = Job.SplitPart1) and (SplitPartSide = Job.SplitPart2));
            if AllowMerge then
              sn := GetSplitModeNum(smMultiplier)
            else
            begin}
              // �� ������, ����� �� ������ - ��������� ������ �����
              AllowMerge := ((sm1 = smMultiplier) and (sm2 = smQuantity) and (NvlInteger(Job.SplitPart3) = 0) and (SplitPartSide = 0) and (SplitPartMult = Job.SplitPart1))
                or ((sm2 = smMultiplier) and (sm3 = smQuantity) and (SplitPartSide = Job.SplitPart1) and (SplitPartMult = Job.SplitPart2));
              if AllowMerge then
                sn := GetSplitModeNum(Job, smQuantity)
              else
              begin
                // �� ������, ����� �� �������
                AllowMerge := ((sm1 = smMultiplier) and (sm2 = smSide) and (NvlInteger(Job.SplitPart3) = 0) and (SplitPartQuantity = 0) and (SplitPartMult = Job.SplitPart1))
                  or ((sm2 = smMultiplier) and (sm3 = smSide) and (SplitPartQuantity = Job.SplitPart1) and (SplitPartMult = Job.SplitPart2));
                if AllowMerge then
                  sn := GetSplitModeNum(Job, smSide)
                else
                begin
                  // �� ������, ����� �� ������
                  {AllowMerge := ((sm1 = smQuantity) and (sm2 = smMultiplier) and (NvlInteger(w.SplitPart3) = 0) and (SplitPartQuantity = w.SplitPart1))
                    or ((sm2 = smQuantity) and (sm3 = smMultiplier) and (SplitPartSide = w.SplitPart1) and (SplitPartQuantity = w.SplitPart2));
                  if AllowMerge then
                    sn := GetSplitModeNum(smMultiplier)
                  else
                  begin}
                    // �� ������, ����� �� �������
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
          // ... �� ��������� (������� �������, ������ ������������� ����� ��������� �������)
          FinishTime := Job.PlanFinish;
          GetAdapter(w).RemoveJob(Job);
          Dec(JobIndex); // ������������ �� ����������, �.�. �������
          // ��������� ������������
          GetAdapter(w).UpdatePlan(CurJob.JobID, CurJob.PlanStart, FinishTime);
          // ���������������� ��������� ��������
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
      // ����� ����������� �����
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
    // TODO! DepartmentID ������� ������ ����������
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
    raise Exception.Create('�� ������ ���������� ������������');
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
    Rpt.WinCaption1 := 'Excel -::- PolyMix'; // ��������� ��������� ����
    Rpt.WinCaption2 := RptCaption; //Plan_GetReportCaption;
    Rpt.FontApplied := false;
    DataSet := w.DataSet;

    ColCount := CountOfChar(';', ReportFields) + 1;
    CurDate := PlanFrame.WorkDate;
    if (ColCount > 0) and (DataSet.RecordCount > 0) then
    begin
      // ������ ������� ����� �� ������������
      SpecialRowCount := 0;
      SetLength(SpecialRows, DataSet.RecordCount);
      CommentRowCount := 0;
      SetLength(CommentRows, DataSet.RecordCount);
      if _ContinuousMode then
      begin
        // ������ ������� ����� � ���������� ����
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
            SkipFields := true;  // �������� ����� - ���������� ��� ����
          end;
        end
        else
          // ���� ������ ����, �� ��������� ��� ����, � �� ���������� ����� ������� ����
          if not SameDay(w.RangeStart, CurDate, DataSet['PlanStartDate']) then
          begin
            V[r, 1] := DateToStr(DataSet['PlanStartDate']);
            CurDate := DataSet['PlanStartDate'];
            r := r + 1;
          end;

        // ���� ���� �������� ����� - ���������� ��� ����
        if not SkipFields then
        begin
          if w.JobType >= JobType_Special then
          begin
            // ���� ������ - ������ ��������
            V[r, 1] := w.AnyStartDateTime;
            V[r, 2] := w.AnyFinishDateTime;
            V[r, 3] := w.PlanDuration;
            V[r, 4] := w.Comment;
            SpecialRows[SpecialRowCount] := r;
            Inc(SpecialRowCount);
          end
          else
          begin
            // ������� ������
            for c := 1 to ColCount do
            begin
              FName := SubStrBySeparator(ReportFields, c - 1, ';');
              F := DataSet.FieldByName(FName);
              // ������ ������� Wingdings �� ������� �����
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
                // ������ ��������� ���� �������� ���������
                if VarIsNull(F.Value) then
                  V[r, c] := '���'
                else if YearOf(F.Value) = 1900 then
                  V[r, c] := '��������'
                else
                  V[r, c] := '��������' + #10 + FormatDateTime('dd.mm', F.Value);
              end
              else  // ���� �� ������� �������� ���������, � ���� �������, �� �������� �����
              if not Options.ScheduleShowCost and (CompareText(FName, TWorkload.F_JobCost) = 0) then
                V[r, c] := ''
              else
              if CompareText(FName, TWorkload.F_Executor) = 0 then
                V[r, c] := NvlString(TConfigManager.Instance.StandardDics.deEmployees.ItemName[NvlInteger(F.Value)])
              else
                V[r, c] := F.Value;
              //TLogger.GetInstance.Info('Workload report: ' + FName + ' = ' + VarToStr(DataSet[FName]));
            end;
            // ���� ���� �����������, �� ��������� ��� ��� ��������� ������
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

      RptCaption := '���� ��� ' + TConfigManager.Instance.StandardDics.deEquip.ItemName[w.EquipCode];
      if not _ContinuousMode then
        RptCaption := RptCaption + '  (' + DateToStr(PlanFrame.WorkDate) + ')';
      Rpt.Cells[1, 1] := RptCaption + ' -- ' + FormatDateTime('dd/mm/yyyy hh:mm', Now);

      // ������ �������� ����
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

      // ������ ���� ������
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

      // ������ ����������
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
        // ���������� ������ � �������� � ������� ������
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

  if CheckLocked(w) then  // ���� ������������, �������
    Exit;

  StartFound := FindAvailableStart(w, StartTime, false);
  if StartFound then
  begin
    Editable := NvlBoolean(TConfigManager.Instance.StandardDics.deSpecialJob.ItemValue[JobCode, 6]);
    if Editable then
    begin
      JobComment := '';
      if ExecEditText('�������� ������', JobComment, true) then
        JobComment := Trim(JobComment)
      else
        Exit;
    end;

    Job := TJobParams.Create;
    Job.IsNew := true;
    Job.PlanStart := StartTime;
    Job.Executor := null; // ����� ��� unassigned �� �������� KeyValue ����������
    Job.EstimatedDuration := NvlInteger(TConfigManager.Instance.StandardDics.deSpecialJob.ItemValue[JobCode, 1]);
    if Job.EstimatedDuration = 0 then Job.EstimatedDuration := 1; // ������� ������������ �� ��������
    Job.PlanFinish := IncMinute(Job.PlanStart, Job.EstimatedDuration);
    Job.JobAlert := false;
    Job.JobType := JobCode;
    Job.TimeLocked := NvlBoolean(TConfigManager.Instance.StandardDics.deSpecialJob.ItemValue[JobCode, 7]); // ��������������� ��� ���
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
      PlanFrame.UpdateJobControls; // ����� �������� ����������
    end;
  end
  else
    RusMessageDlg('����� ���������', mtWarning, [mbOk], 0);

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

  if CheckLocked(W) then  // ���� ������������, �������
    Exit;

  Job := w.CurrentJob;
  if Job = nil then Exit;

  // ���� ���� ����������� � �������� �����, �� ���� �� ��� �������
  if IntersectShift(w, Job, ShiftStart) then
  begin
    BeginUpdates(w);
    CheckShiftOverlap(w, Job);
    CommitUpdates(w);
  end
  else
  begin
    if not GetSplitMode(Job, SplitMode) then
      RusMessageDlg('������ ������� ������', mtError, [mbOk], 0)
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

// ���� � ����� ����� � ��������� �������
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
    // ���� � ������� ����
    LocData := GetAdapter(w).CreateLocatedProcesses(Plan.EquipGroupCode, OrderNum, tempDm, YearOf(Now));
    if LocData.DataSet.RecordCount = 0 then
    begin
      FreeAndNil(tempDm);
      tempDm := TDataModule.Create(nil);
      // ���� �� ���� �����
      LocData := GetAdapter(w).CreateLocatedProcesses(Plan.EquipGroupCode, OrderNum, tempDm, 0);
      if LocData.DataSet.RecordCount = 0 then
        RusMessageDlg('������ ��� ������ � ' + IntToStr(OrderNum) + ' �� ������� � ������� ������ ������������',
          mtWarning, [mbOk], 0)
      else
        Found := true;
    end
    else
      Found := true;

    if Found then
    begin
      // ���� ��������� ��������� ����� (������ ���������), �� ���������� ������������ �����
      if LocData.DataSet.RecordCount > 1 then
        if not ExecJobListForm(LocData) then Exit;
      JobID := LocData.DataSet['JobID'];
      if JobID > 0 then
      begin
        if CurrentWorkload.EquipCode <> NvlInteger(LocData.DataSet['EquipCode']) then
        begin
          if not PlanFrame.ActivateWorkload(LocData.DataSet['EquipCode']) then
          begin
            RusMessageDlg('������������ ��� ��������� ������ �� �������.', mtError, [mbOk], 0);
            Exit;
          end;
        end;

        // ������� ������
        if not CurrentWorkload.Locate(JobID) then
        begin
          if not VarIsNull(LocData.DataSet['AnyStartDate']) then
            StartDate := LocData.DataSet['AnyStartDate']
          else
          begin
            RusMessageDlg('��������� ������ �� ������������� � �� ���������. ����� ����� ����� ���� �� ����������', mtError, [mbOk], 0);
            Exit;
          end;

          ReplaceTime(StartDate, 0);
          PlanFrame.WorkDate := StartDate;

          // TODO: ������ ����� ���� � ������ �����!

          if not PlanFrame.CurrentWorkload.Locate(JobID) then
            RusMessageDlg('�� ������� ����� �������� ������', mtError, [mbOk], 0);
        end;
      end;
    end;
  finally
    tempDm.Free;
  end;
end;

// ���� ������ ��������� �����, ���� ��� �����
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

// ���������� �����, ��� ���� ��������� ����� ��� ����� ������������ ������.
// � ������ ��������� ��� ��� ����� ����� ������� false, ���� ������ ���������� �� �������.
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
      // ���� ������� �� ������� ���
      if StartTime > w.RangeEnd then
        StartFound := false;
    end;
  end
  else
  if w.IsEmpty then
    StartTime := Now
  else // ����������� ������. �������� � �������� �����.
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
      // ���� ���� �� ��������� ����� �� ���������� ����������, �� ������ ����� ���
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

// ����������� ������ �� ������ ������������
procedure TPlanController.HandleChangeEquip(NewEquipCode: integer);
var
  I{, SavedJobID}: Integer;
  WSource, WTarget: TWorkload;
  CurJob, SavedJobParams: TJobParams;
begin
  // ������, �������� �� ���������, ���� ���������� �� ���������
  WSource := PlanFrame.CurrentWorkload;
  CurJob := WSource.CurrentJob;
  SavedJobParams := CurJob.Copy;
  //SavedJobID := SavedJobParams.JobID;
  try
    if not CurJob.HasSplitMode(smQuantity) and not CurJob.HasSplitMode(smMultiplier)
      and not CurJob.HasSplitMode(smSide) then
    begin
      // ������� ���� ��� ������ ������������
      for I := 0 to FWorkloads.Count - 1 do    // Iterate
      begin
        if TWorkload(FWorkloads[i]).EquipCode = NewEquipCode then
        begin
          WTarget := TWorkload(FWorkloads[i]);
          break;
        end;
      end;
      if WTarget = nil then
        raise Exception.Create('���� ������������ �� ������');

      // ��������� ���������� ������ �� ������
      if CheckLocked(WSource) or CheckLocked(WTarget) then
        Exit;

      BeginUpdates(WSource);
      // �������� ������ ������� � �����������������...
      GetAdapter(WSource).UnPlanJob(CurJob);
      CommitUpdates(WSource);

      Plan.Reload;
      if not Plan.DataSet.Locate('JobID', SavedJobParams.JobID, []) then
        raise Exception.Create('������ �� �������');
      // ����������� �� ����� ���� � ��������� � ����
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
      RusMessageDlg('���� �� ���������� ������� ������ ��������� �� ������ ������������. Sorry...',
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
      // ��������� �����, ����� ������� ����������� � �������
      FFilter := TOrderFilterObj.Create;
      try
        CurOrder.Criteria := FFilter as TOrderFilterObj;
        CurOrder.UsePager := false;
        CurOrder.UseWaitCursor := true;
        FFilter.SetSingleOrderFilter(Job.OrderID);
        CurOrder.Reload;
        Result := ExecEditJobComment(CurOrder, '����������', TempComment, TempAlert);
      finally
        FFilter.Free;
      end;
    finally
      AppController.FreeEntity(CurOrder);
    end;
  end;

  function DoEditSpecialJobComment: boolean;
  begin
    Result := ExecEditJobComment(nil, '����������', TempComment, TempAlert);
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
    RusMessageDlg('���� ������������� ������������� ' + QuotedStr(LockerName), mtInformation, [mbok], 0);
  end
  else
  begin
    // ������� ���������, ���� �� ��������� � ������� ���������� ����������
    if CheckModified(w) then
      w.Reload;
    // ���������
    TLockManager.Lock(TLockManager.Workload, w.EquipCode);
    // �������� ������ ������������� ����������
    FEditLockTimer.Enabled := true;
    // ��������� ��������� ������
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
    // ��������� ������
    FEditLockTimer.Enabled := false;
    // ������������
    TLockManager.Unlock(TLockManager.Workload, w.EquipCode);
    // ������� ������� ���������
    a := GetAdapter(w) as TCachedScheduleAdapter;
    a.ClearHistory;
    // ��������� ��������� ������
    w.Locked := false;
    PlanFrame.UpdateLockState;

    // �������� ������, ���� ���� ���� ���� ������������
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
    // ��������� �����, ����� ������� ����������� � �������
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

// �������� ������ ������� � JobID �� ����� NewStart
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
        // �� ���������� ��������� � ��� ��� �������� ������
        if CheckCanMove(w, false) then
        begin
          NewFinish := NewStart + (w.PlanFinishDateTime - w.PlanStartDateTime);
          FAdapter.UpdatePlan(w.JobID, NewStart, NewFinish);
          WasMoved := true;
          NewStart := NewFinish;
        end
        else
          break; // ���� ���� ������ ��������, �� � ��������� ����
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
  ReplaceTime(Date1, DayStart);  // ����-����� ������ �������� ���
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
      Plan.Reload; // ����� �������� � ����� ���� �������� ������
    // �� ���� �������, ����� ���������, ��������� ������ �������� ������ �� ������ ������������.
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

  // �������������, ���� ���� ��������� � ��� ����������
  if FNeedRefresh or not w.Active or (CheckModified(w) and not w.Locked) then
    w.Reload;

  if (w.KeyValue <> CurID) then
    LocateLastPlannedJob(w);

  CheckOverdueJobs(w);
  if ContinuousMode(w) then
    UpdateOverlaps(w);
end;

// ��������� ������ �� ������� �������������� �������
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
        (FFrame as TPlanFrame).ShowWarning(w.EquipCode, '����������� ������� �� ���������� ��������� �����');
      if OverdueStart then
        (FFrame as TPlanFrame).ShowWarning(w.EquipCode, '����������� ������� �� ������ ��������� �����');
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

// ���������, ������� �� ��� �������������� � ���� �����.
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
  // ���������� �� ������ ������ �����
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
    if Job.JobID = CurJob.JobID then break;  // ����� �� �������
    if VarIsNull(CurJob.FactStart) or VarIsNull(CurJob.FactFinish) then
    begin
      Result := false;
      break;
    end;
  end;
end;

// ���������, ������� �� ��� ����������� � ���� �����.
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
        // �������� �� ���� ������ � ���������
        GetAdapter(w).ReplaceJobWithSpecial(JobIDs[I], TStandardDics.SpecialJob_Unscheduled,
          GetRemovedJobDesc(Job) + #13#10 + ReasonText);
    end;
    GetAdapter(w).UnPlanItem(Job);
  end;
  Result := not Cancelled;
end;

// ���������� ���� ������ ��������� ������
function TPlanController.SplitJobByQuantity(w: TWorkload; Job: TJobParams; AutoSplit: boolean): integer;
var
  StartTime, FinishTime: TDateTime;
  Half1, m: extended;
  NewJob: TJobParams;
  sn: Integer;
begin
  StartTime := Job.AnyStart;
  FinishTime := Job.PlanFinish;
  // ����� ������� - �������� �� ������
  m := MinuteSpan(FinishTime, StartTime);
  if m >= 2 then
  begin
    Half1 := IncMinute(StartTime, Trunc(m / 2));
    // ������ ��������, ���������� ������ ����� �������� ����� ��������
    // ���������� ����� ��������
    sn := GetAdapter(w).UpdateJobSplitMode(Job, StartTime, Half1, smQuantity, AutoSplit);
    // ������ ��������
    Result := GetAdapter(w).AddSplitJob(Job, Half1, FinishTime, sn);
    // ����� �������� ���������, ����� ��� ���� ����� ������ ��������
    GetAdapter(w).UpdatePlan(Job);
    // ������ ����� ����� ��������������
    RenumberItemJobs(w, Job, sn);
  end
  else
    ExceptionHandler.Raise_('������ ������ ������ ���� �����');
end;

// ���������� ���� ������ ��������� ������
function TPlanController.SplitJobByQuantityEx(w: TWorkload; Job: TJobParams; AutoSplit: boolean;
  NewStartTime1, NewFinishTime1, NewStartTime2, NewFinishTime2: TDateTime): integer;
var
  sn: Integer;
begin
  // ������ ��������, ���������� ������ ����� �������� ����� ��������
  // (���������� ����� ��������)
  sn := GetAdapter(w).UpdateJobSplitMode(Job, NewStartTime1, NewFinishTime1, smQuantity, AutoSplit);
  // ������ ��������
  {Result := GetAdapter(w).AddSplitJob(Job.ItemID, NewStartTime2, NewFinishTime2, null,
    w.EquipCode, Job.Executor, Job.JobComment, Job.SplitPart1, Job.SplitPart2, sn,
    Job.JobAlert);}
  Result := GetAdapter(w).AddSplitJob(Job, NewStartTime2, NewFinishTime2, sn);
  // ����� �������� ���������, ����� ��� ���� ����� ������ ��������
  GetAdapter(w).UpdatePlan(Job);
  // ������ ����� ����� ��������������
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
      // ����� ������� - �������� �� ������
      m := MinuteSpan(FinishTime, StartTime);
      if m >= 2 then
      begin
        //Half1 := (FinishTime - StartTime) / 2;
        Half1 := IncMinute(StartTime, Trunc(m / 2));
        // ������ ��������
        {Job := w.GetJobParams;
        try}
          // ���������� ����� ��������
          sn := GetAdapter(w).UpdateJobSplitMode(Job, StartTime, Half1, smSide, AutoSplit);
          // ������ ��������
          Result := GetAdapter(w).AddSplitJob(Job, Half1, FinishTime, sn);
          // ����� �������� ���������, ����� ��� ���� ����� ������ ��������
          GetAdapter(w).UpdatePlan(Job);
          // ������ ����� ����� ��������������
          RenumberItemJobs(w, Job, sn);
        {finally
          Job.Free;
        end;}
      end
      else
        ExceptionHandler.Raise_('������ ������ ������ ���� �����');
    end
    else
      ExceptionHandler.Raise_('������� ��� ���������� ������ ������ ���� �� �����������. �������� ������������.');
  end
  else
    ExceptionHandler.Raise_('�� ������� ���������� ������ � ������');
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

// ���������� ����� ���� ���������� ������, ����� �������
function TPlanController.SplitJobByMultiplier(w: TWorkload; Job: TJobParams; AutoSplit: boolean): TIntArray;
var
  StartTime, FinishTime: TDateTime;
  I, IMult, sn: Integer;
  EndHalf1, Half1: Extended;
  m: Int64;
begin
  StartTime := Job.AnyStart;
  FinishTime := Job.PlanFinish;
  // ����� �� ��������� ������ - �������� �� ������
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
        // ���������� ����� ��������
        sn := GetAdapter(w).UpdateJobSplitMode(Job, StartTime, Half1, smMultiplier, AutoSplit);
        // ������ �������
        Result[0] := Job.JobID;
        for I := 1 to IMult - 2 do
        // �� ������� ��������� �� ��������������
        begin
          EndHalf1 := IncMinute(Half1, Trunc(m / IMult));
          Result[I] := GetAdapter(w).AddSplitJob(Job, Half1, EndHalf1, sn);
          Half1 := EndHalf1;
        end;
        // ��������� �������
        Result[IMult - 1] := GetAdapter(w).AddSplitJob(Job, Half1, FinishTime, sn);
        // ����� �������� ���������, ����� ��� ���� ����� ������ ��������
        GetAdapter(w).UpdatePlan(Job);
        // ������ ����� ����� ��������������
        RenumberItemJobs(w, Job, sn);
      {finally
        Job.Free;
      end;}
    end
    else
      ExceptionHandler.Raise_('������ ������ ������ ' + IntToStr(IMult) + ' �����');
  end
  else
    ExceptionHandler.Raise_('������ �� �������. �� �� ��� ���������...');
end;

procedure TPlanController.RenumberItemJobs(w: TWorkload; Job: TJobParams; SplitModeNum: integer);
var
  WasAdded: boolean;
begin
  // �������� ������ ������ �� �����, ���� �� ��� � ������, ����� ������������� ������ ���������
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
    RusMessageDlg('���������� ������������ ������. ��������� �� ����� ���� ���������:'
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

  // ���� ������� ������ �� �������� ����� ����������, �� ���� ������ �� ����� ���� ������
  if w.Active and ContinuousMode(w) then
  begin
    CurID := w.KeyValue;
    if not VarIsNull(CurID) then
    begin
      CurJob := w.JobList.GetJob(CurID);
      if CurJob = nil then
      begin
        // ������ ����� ���� ������� ���� �����
        CurJob := a.UnPlannedJobList.GetJob(CurID);
        if CurJob = nil then
          CurJob := a.RemovedJobList.GetJob(CurID);
      end;
      if CurJob <> nil then
        CurJobDate := CurJob.AnyStart  // ���������� ����� ������ ������� ������
      else
        CurID := null;
    end;
  end;

  if not Validate(w) then
    Exit;

  a.CommitUpdates;

  //w.SaveJobs := EnableUndo;  // ����� ����������� ����� ��� ������
  //try
    w.Reload;
  //finally
  //  w.SaveJobs := false;
  //end;

  if w.Active and ContinuousMode(w) and not VarIsNull(CurID) and (w.KeyValue <> CurID) then
  begin
    // ���� ����� �� ������ ������, ������
    // ������� ������ �� ������� ����� ����������, ���������� �� ������� �����.
    CurShift := w.GetShiftByDate(CurJobDate);
    if CurShift = nil then
      CurShift := w.GetShiftByDate(Now);
    if CurShift <> nil then
      w.Locate(-CurShift.Number);
  end;

  CheckOverdueJobs(w);
  if ContinuousMode(w) then
    UpdateOverlaps(w);

  PlanFrame.UpdateLockState;  // �������� ��������� ������
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
    a.EnableUndo := false;  // ����� beginupdates �� ������
    try
      CommitUpdates(w);
    finally
      a.EnableUndo := true;
    end;
    if a.UndoRestored or a.UndoRemoved then
      Plan.Reload; // ��� �����, ������ ���� ��������� ��� ����������� ������
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
    Res := RusMessageDlg('��������� ������������?', mtConfirmation,
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
