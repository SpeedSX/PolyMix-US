unit PmCachedScheduleAdapter;

interface

uses Classes,

  PmJobParams, PmPlan, CalcUtils, PmScheduleAdapter, PmSQLScheduleAdapter,
  PmScheduleDataChangeDetect;

type
  THistoryRecord = record
    JobList: TJobList;  // состояние перед операцией
    RemovedJobList: TJobList; // удаленные
    UnplannedJobList: TJobList;  // снятые
    procedure Free;
  end;

  THistoryArray = array of THistoryRecord;

  TCachedScheduleAdapter = class(TScheduleAdapter)
  protected
    FWorkload: TWorkload;
    FUnPlannedJobList: TJobList;
    FRemovedJobList: TJobList;
    FHistory: THistoryArray;
    FEnableUndo: boolean;
    FUndoRemoved: boolean;
    FUndoRestored: boolean;
    FChangeDetector: TScheduleDataChangeDetect;
    FUpdatesPending: boolean;
    function DoAddSplitJob(SourceJob: TJobParams; StartTime, FinishTime: TDateTime;
      SplitModeNum: variant): integer; override;
    //function GetMaxJobID: integer;
    procedure SaveForUndo;
    procedure SetWorkload(Value: TWorkload);
  public
    constructor Create;
    destructor Destroy; override;

    procedure UpdatePlan(JobID: integer; StartTime, FinishTime: TDateTime); overload; override;
    procedure UpdateFact(JobID: integer; FactStartTime, FactFinishTime: TDateTime); override;
    // перенумеровывает части разбивки
    //procedure RenumberSplitPartsJob(JobID: integer; SplitPartNum: integer); override;
    procedure RenumberSplitPartsItem(ItemID: integer;
      SplitPart1, SplitPart2: variant; SplitPartNum: integer); override;
    // обновляет разбивку, возвращает тип разбивки
    //function UpdateJobSplitMode(Job: TJobParams;
    //   StartTime, FinishTime: TDateTime; SplitMode: TSplitMode; _AutoSplit: boolean): integer;
    // Обновляет только те параметры, которые были установлены
    procedure UpdatePlan(JobParams: TJobParams); overload; override;
    //procedure PauseJob(w: TWorkload); override;
    function AddSpecialJob(Job: TJobParams): Integer; override;
    procedure UpdateJobComment(JobID: integer; NewComment: variant; JobAlert: boolean); override;
    // Заменяет удаленную работу на специальную с указанным кодом.
    // Не удаляет исходную!
    function ReplaceJobWithSpecial(JobID: integer; JobCode: integer; ReasonText: string): integer; override;
    // Снять работу из плана - для всех работ.
    // Удаляет специальные работы и части разбитых и делает незапланированными остальные.
    procedure RemoveJob(Job: TJobParams); override;
    // Снять работу - сделать работу незапланированной
    procedure UnPlanJob(Job: TJobParams); override;
    // Снять все работы этого процесса (для работ, разбитых на части)
    procedure UnPlanItem(Job: TJobParams); override;
    // получить ключи работ для данного процесса
    function GetItemJobIDs(ItemID: integer): TIntArray; override;
    // получить ключи работ с плановыми датами для данного процесса
    function GetJobsWithFactInfo(ItemID: integer): TIntArray; override;
    // true если работа разбита
    //function MultipleJobs(ItemID: integer): Boolean; override;
    // возвращает последнюю по дате часть разбитой работы, принадлежую к той же работе,
    // с учетом разбивки по полю с номером SplitModeNum.
    function GetLastSplitJob(Job: TJobParams; SplitModeNum: integer): integer; override;
    // возвращает общую длительность по всему процессу
    //procedure GetItemTotals(ItemID: integer; var TotalSec: integer); override;
    // возвращает общую длительность частей для работы, разбитой по тиражу
    //function GetJobTotalSec(Job: TJobParams): integer; override;
    function GetJobTotalSecExcept(Job: TJobParams; ExceptIDs: array of integer): integer; override;
    // удаляет части нулевой длины для работы, разбитой по тиражу
    procedure RemoveZeroTimeJobs(Job: TJobParams); override;
    // начать операцию по изменению
    procedure BeginUpdates;
    // внести изменения
    procedure CommitUpdates;
    // отменить начатое изменение
    procedure RollbackUpdates;
    // отменяет последнее изменение
    function UndoLastEdit: boolean;
    procedure ClearLists;
    procedure ClearHistory;
    function CanUndo: boolean;
    function ScheduleChanged: boolean;
    // Проверяет план на корректность
    function Validate: TStringList;
    //procedure MoveChangesToData;

    property Workload: TWorkload read FWorkload write SetWorkload;
    property UnPlannedJobList: TJobList read FUnPlannedJobList;
    property RemovedJobList: TJobList read FRemovedJobList;
    property EnableUndo: boolean read FEnableUndo write FEnableUndo;
    // При откате были сняты работы, кроме спецработ
    property UndoRemoved: boolean read FUndoRemoved;
    // При откате были восстановлены снятые работы, кроме спецработ
    property UndoRestored: boolean read FUndoRestored;
    // Начаты ли изменения
    property UpdatesPending: boolean read FUpdatesPending;
  end;

  {TRenumberInfo = class
  public
    ItemID: integer;
    SplitPart1, SplitPart2: variant;
    SplitPartNum: integer;
    constructor Create(_ItemID: integer; _SplitPart1, _SplitPart2: variant; _SplitPartNum: integer);
  end;}

implementation

uses Variants, DateUtils, ExHandler, SysUtils, RDBUtils;

{constructor TRenumberInfo.Create(_ItemID: integer; _SplitPart1, _SplitPart2: variant; _SplitPartNum: integer);
begin
  inherited Create;
  ItemID := _ItemID;
  SplitPart1 := _SplitPart1;
  SplitPart2 := _SplitPart2;
  SplitPartNum := _SplitPartNum;
end;}

procedure THistoryRecord.Free;
begin
  JobList.FreeJobs;
  FreeAndNil(JobList);
  if RemovedJobList <> nil then
  begin
    RemovedJobList.FreeJobs;
    FreeAndNil(RemovedJobList);
  end;
  if UnplannedJobList <> nil then
  begin
    UnplannedJobList.FreeJobs;
    FreeAndNil(UnplannedJobList);
  end;
end;

constructor TCachedScheduleAdapter.Create;
begin
  inherited;
  FUnPlannedJobList := TJobList.Create;
  FRemovedJobList := TJobList.Create;
  SetLength(FHistory, 0);
  FChangeDetector := TScheduleDataChangeDetect.Create;
  //FRenumberList := TList.Create;
end;

destructor TCachedScheduleAdapter.Destroy;
begin
  ClearLists;
  ClearHistory;
  FUnPlannedJobList.Free;
  FRemovedJobList.Free;
  FreeAndNil(FChangeDetector);
  inherited;
end;

procedure TCachedScheduleAdapter.ClearHistory;
var
  I: Integer;
begin
  for I := Low(FHistory) to High(FHistory) do
    FHistory[i].Free;
  SetLength(FHistory, 0);
end;

function TCachedScheduleAdapter.CanUndo: boolean;
begin
  Result := Length(FHistory) > 0;
end;

procedure TCachedScheduleAdapter.ClearLists;
begin
  if FUnPlannedJobList <> nil then
  begin
    FUnPlannedJobList.FreeJobs;
    //FreeAndNil(FUnPlannedJobList);
  end;
  if FRemovedJobList <> nil then
  begin
    FRemovedJobList.FreeJobs;
    //FreeAndNil(FRemovedJobList);
  end;
  {for I := 0 to FRenumberList.Count - 1 do
    TObject(FRenumberList[I]).Free;
  FRenumberList.Clear;}
end;

{function TCachedScheduleAdapter.GetMaxJobID: integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FWorkload.JobList.Count - 1 do
    if FWorkload.JobList[I].JobID > Result then
    begin
      Result := FWorkload.JobList[I].JobID;
      //Exit;
    end;
end;}

function TCachedScheduleAdapter.DoAddSplitJob(SourceJob: TJobParams; StartTime, FinishTime: TDateTime;
  SplitModeNum: variant): integer;
var
  NewJob: TJobParams;
begin
  NewJob := TJobParams.Create;
  NewJob.IsNew := true;
  NewJob.ItemID := SourceJob.ItemID;
  NewJob.JobType := 0;
  NewJob.PlanStart := StartTime;
  NewJob.PlanFinish := FinishTime;
  NewJob.FactStart := null;
  NewJob.EquipCode := SourceJob.EquipCode;
  NewJob.Executor := SourceJob.Executor;
  NewJob.JobAlert := SourceJob.JobAlert;
  NewJob.JobComment := SourceJob.JobComment;
  NewJob.OrderID := SourceJob.OrderID;
  NewJob.OrderNumber := SourceJob.OrderNumber;
  NewJob.OrderState := SourceJob.OrderState;
  NewJob.Comment := SourceJob.Comment;
  NewJob.IsPaused := SourceJob.IsPaused;
  NewJob.JobColor := SourceJob.JobColor;
  NewJob.ItemDesc := SourceJob.ItemDesc;
  NewJob.CustomerName := SourceJob.CustomerName;
  NewJob.ProductOut := SourceJob.ProductOut;
  NewJob.Part := SourceJob.Part;
  NewJob.PartName := SourceJob.PartName;
  NewJob.ItemProductOut := SourceJob.ItemProductOut;
  NewJob.ExecState := SourceJob.ExecState;
  if SplitModeNum = 1 then
  begin
    NewJob.SplitMode1 := SourceJob.SplitMode1;
  end
  else
  if SplitModeNum = 2 then
  begin
    NewJob.SplitPart1 := SourceJob.SplitPart1;
    NewJob.SplitMode1 := SourceJob.SplitMode1;
    NewJob.SplitMode2 := SourceJob.SplitMode2;
  end
  else
  if SplitModeNum = 3 then
  begin
    NewJob.SplitPart1 := SourceJob.SplitPart1;
    NewJob.SplitPart2 := SourceJob.SplitPart2;
    NewJob.SplitMode1 := SourceJob.SplitMode1;
    NewJob.SplitMode2 := SourceJob.SplitMode2;
    NewJob.SplitMode3 := SourceJob.SplitMode3;
  end;

  {if SourceJob.HasSplitMode(smMultiplier) then  убрал, т.к. это вроде бы не некорректно
    NewJob.Multiplier := 1
  else}
    NewJob.Multiplier := SourceJob.Multiplier;

  if SourceJob.HasSplitMode(smSide) then
    NewJob.SideCount := 1
  else
    NewJob.SideCount := SourceJob.SideCount;

  NewJob.JobID := FWorkload.JobList.MaxJobID + 1;
  FWorkload.JobList.Add(NewJob);
  FWorkload.SortJobs;
  Result := NewJob.JobID;
end;

procedure TCachedScheduleAdapter.UpdatePlan(JobID: integer; StartTime, FinishTime: TDateTime);
var
  Job: TJobParams;
begin
  Job := FWorkload.JobList.GetJob(JobID);
  Job.PlanStart := StartTime;
  Job.PlanFinish := FinishTime;
end;

procedure TCachedScheduleAdapter.UpdateFact(JobID: integer; FactStartTime, FactFinishTime: TDateTime);
var
  Job: TJobParams;
begin
  Job := FWorkload.JobList.GetJob(JobID);
  Job.FactStart := FactStartTime;
  Job.FactFinish := FactFinishTime;
end;

// Добавляет в список для последующей перенумерации
procedure TCachedScheduleAdapter.RenumberSplitPartsItem(ItemID: integer;
      SplitPart1, SplitPart2: variant; SplitPartNum: integer);
var
  Jobs, ItemJobs: TJobList;
  I: Integer;
  Job: TJobParams;
  Found: boolean;
begin
  // Если осталась только одна работа (или вообще нету почему-то), то стираем (:=null) номер разбивки
  Jobs := TJobList.Create;
  ItemJobs := TJobList.Create;
  try
    for I := 0 to FWorkload.JobList.Count - 1 do
    begin
      Job := FWorkload.JobList[I];
      if (ItemID = Job.ItemID) then
      begin
        ItemJobs.Add(Job);
        if ((SplitPartNum = 1) and not VarIsNull(Job.SplitMode1))
          or ((SplitPartNum = 2) and not VarIsNull(Job.SplitMode2) and (Job.SplitPart1 = SplitPart1))
          or ((SplitPartNum = 3) and not VarIsNull(Job.SplitMode3) and (Job.SplitPart1 = SplitPart1) and (Job.SplitPart2 = SplitPart2)) then
         Jobs.Add(Job);
      end;
    end;
    if Jobs.Count = 1 then
    begin
      if SplitPartNum = 1 then
        Jobs[0].SplitPart1 := null
      else if SplitPartNum = 2 then
        Jobs[0].SplitPart2 := null
      else if SplitPartNum = 3 then
        Jobs[0].SplitPart3 := null;

      // Если ни одной разбитой работы нету, то убираем признак разбивки из процесса
      Found := false;
      for I := 0 to ItemJobs.Count - 1 do
      begin
        Job := ItemJobs[I];
        if not VarIsNull(Job.SplitPart3) then
        begin
          Found := true;
          break;
        end;
      end;
      if not Found then
        for I := 0 to ItemJobs.Count - 1 do
          ItemJobs[I].SplitMode3 := null;

      Found := false;
      for I := 0 to ItemJobs.Count - 1 do
      begin
        Job := ItemJobs[I];
        if not VarIsNull(Job.SplitPart2) then
        begin
          Found := true;
          break;
        end;
      end;
      if not Found then
        for I := 0 to ItemJobs.Count - 1 do
          ItemJobs[I].SplitMode2 := null;

      Found := false;
      for I := 0 to ItemJobs.Count - 1 do
      begin
        Job := ItemJobs[I];
        if not VarIsNull(Job.SplitPart1) then
        begin
          Found := true;
          break;
        end;
      end;
      if not Found then
        for I := 0 to ItemJobs.Count - 1 do
          ItemJobs[I].SplitMode1 := null;
    end
    else
    if Jobs.Count >= 1 then
    begin
     // Если не одна, то перенумеровываем
      //SplitPart := 1;
      for I := 0 to Jobs.Count - 1 do
      begin
        if SplitPartNum = 1 then
          Jobs[I].SplitPart1 := I + 1
        else if SplitPartNum = 2 then
          Jobs[I].SplitPart2 := I + 1
        else if SplitPartNum = 3 then
          Jobs[I].SplitPart3 := I + 1;
      end;
    end;
  finally
    Jobs.Free;
    ItemJobs.Free;
  end;
end;

procedure TCachedScheduleAdapter.UpdatePlan(JobParams: TJobParams);
var
  I: Integer;
  CurJob: TJobParams;
begin
  if JobParams.JobID = 0 then
  begin
    JobParams.JobID := FWorkload.JobList.MaxJobID + 1;
    FWorkload.JobList.GetMaxJobID;
  end;
  // Если менялись какие-нибудь параметры, относящиеся ко всему процессу,
  // присвоить их всем работам этого процесса.
  // TODO: не все параметры присваиваются! нужны еще какие-то?
  if JobParams.SplitMode1Set or JobParams.SplitMode2Set or JobParams.SplitMode3Set then
    for I := 0 to FWorkload.JobList.Count - 1 do
    begin
      CurJob := FWorkload.JobList[I];
      if (CurJob <> JobParams) and (CurJob.ItemID = JobParams.ItemID) then
      begin
        if JobParams.SplitMode1Set and (CurJob.SplitMode1 <> JobParams.SplitMode1) then
          CurJob.SplitMode1 := JobParams.SplitMode1;
        if JobParams.SplitMode2Set and (CurJob.SplitMode2 <> JobParams.SplitMode2) then
          CurJob.SplitMode2 := JobParams.SplitMode2;
        if JobParams.SplitMode3Set and (CurJob.SplitMode3 <> JobParams.SplitMode3) then
          CurJob.SplitMode3 := JobParams.SplitMode3;
        if JobParams.AutoSplitSet and (CurJob.AutoSplit <> JobParams.AutoSplit) then
          CurJob.AutoSplit := JobParams.AutoSplit;
      end;
    end;
end;

function TCachedScheduleAdapter.AddSpecialJob(Job: TJobParams): Integer;
begin
  Job.JobID := FWorkload.JobList.MaxJobID + 1;
  FWorkload.JobList.Add(Job);
  Result := Job.JobID;
  FWorkload.SortJobs;
end;

procedure TCachedScheduleAdapter.UpdateJobComment(JobID: integer; NewComment: variant; JobAlert: boolean);
var
  Job: TJobParams;
begin
  Job := FWorkload.JobList.GetJob(JobID);
  Job.JobComment := NewComment;
  Job.JobAlert := JobAlert;
end;

function TCachedScheduleAdapter.ReplaceJobWithSpecial(JobID: integer; JobCode: integer; ReasonText: string): integer;
var
  Job, NewJob: TJobParams;
begin
  Job := FWorkload.JobList.GetJob(JobID);
  NewJob := TJobParams.Create;
  NewJob.IsNew := true;
  NewJob.JobType := JobCode;
  NewJob.PlanStart := Job.PlanStart;
  NewJob.PlanFinish := Job.PlanFinish;
  NewJob.FactStart := Job.FactStart;
  NewJob.FactFinish := Job.FactFinish;
  NewJob.EquipCode := Job.EquipCode;
  NewJob.Executor := Job.Executor;
  NewJob.JobComment := ReasonText;
  NewJob.TimeLocked := false;
  Result := AddSpecialJob(NewJob);
end;

procedure TCachedScheduleAdapter.RemoveJob(Job: TJobParams);
begin
  FRemovedJobList.Add(Job);
  FWorkload.JobList.Remove(Job);
  FWorkload.SortJobs;
end;

procedure TCachedScheduleAdapter.UnPlanJob(Job: TJobParams);
var
  I: Integer;
  Found: boolean;
begin
  // Если уже есть одна работа с тем же ItemID, то помещаем в RemoveJobList
  Found := false;
  for I := 0 to FUnplannedJobList.Count - 1 do
    if FUnplannedJobList[I].ItemID = Job.ItemID then
    begin
      Found := true;
      break;
    end;
  if Found then
  begin
    FRemovedJobList.Add(Job);
  end
  else
  begin
    FUnplannedJobList.Add(Job);
  end;
  FWorkload.JobList.Remove(Job);
  FWorkload.SortJobs;
end;

procedure TCachedScheduleAdapter.UnPlanItem(Job: TJobParams);
var
  I: integer;
  TmpList: TIntArray;
begin
  TmpList := GetItemJobIDs(Job.ItemID);
  for I := Low(TmpList) to High(TmpList) do
    UnPlanJob(FWorkload.JobList.GetJob(TmpList[I]));
end;

function TCachedScheduleAdapter.GetItemJobIDs(ItemID: integer): TIntArray;
var
  I: Integer;
  CurJob: TJobParams;
begin
  SetLength(Result, 0);
  for I := 0 to FWorkload.JobList.Count - 1 do
  begin
    CurJob := FWorkload.JobList[I];
    if CurJob.ItemID = ItemID then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := CurJob.JobID;
    end;
  end;
end;

function TCachedScheduleAdapter.GetJobsWithFactInfo(ItemID: integer): TIntArray;
var
  I: Integer;
  CurJob: TJobParams;
begin
  SetLength(Result, 0);
  for I := 0 to FWorkload.JobList.Count - 1 do
  begin
    CurJob := FWorkload.JobList[I];
    if (CurJob.ItemID = ItemID) and (not VarIsNull(CurJob.FactStart) or not VarIsNull(CurJob.FactFinish)) then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := CurJob.JobID;
    end;
  end;
end;

function TCachedScheduleAdapter.GetLastSplitJob(Job: TJobParams; SplitModeNum: integer): integer;
var
  I: Integer;
  CurJob: TJobParams;
  Accept: boolean;
begin
  Result := 0;
  for I := FWorkload.JobList.Count - 1 downto 0 do
  begin
    CurJob := FWorkload.JobList[I];
    Accept := CurJob.ItemID = Job.ItemID;
    if Accept then
    begin
      if (SplitModeNum >= 2) then
        Accept := (Job.SplitPart1 = CurJob.SplitPart1);
      if SplitModeNum = 3 then
        Accept := Accept and (Job.SplitPart2 = CurJob.SplitPart2);
    end;
    if Accept then
    begin
      Result := CurJob.JobID;
      break;
    end;
  end;
end;

function TCachedScheduleAdapter.GetJobTotalSecExcept(Job: TJobParams; ExceptIDs: array of integer): integer;
var
  CurJob: TJobParams;
  I, J: Integer;
  Accept: boolean;
begin
  Result := 0;
  for I := 0 to FWorkload.JobList.Count - 1 do
  begin
    CurJob := FWorkload.JobList[I];
    Accept := CurJob.ItemID = Job.ItemID;
    if Accept then
    begin
      if not VarIsNull(Job.SplitMode1) and (Job.SplitMode1 <> 0) and not VarIsNull(Job.SplitPart1) then
        Accept := CurJob.SplitPart1 = Job.SplitPart1;
      if not VarIsNull(Job.SplitMode2) and (Job.SplitMode2 <> 0) and not VarIsNull(Job.SplitPart2) then
        Accept := Accept and (CurJob.SplitPart2 = Job.SplitPart2);
      if Accept then
        for J := Low(ExceptIDs) to High(ExceptIDs) do
        begin
          Accept := CurJob.JobID <> ExceptIDs[J];
          if not Accept then
            break;
        end;
    end;
    if Accept then
      Result := Result + SecondsBetween(Job.AnyStart, Job.AnyFinish);
  end;
end;

procedure TCachedScheduleAdapter.RemoveZeroTimeJobs(Job: TJobParams);
var
  CurJob: TJobParams;
  I: Integer;
  Accept: boolean;
  TmpList: TIntArray;
begin
  SetLength(TmpList, 0);
  for I := 0 to FWorkload.JobList.Count - 1 do
  begin
    CurJob := FWorkload.JobList[I];
    Accept := CurJob.ItemID = Job.ItemID;
    if Accept then
    begin
      if MinutesBetween(CurJob.AnyStart, CurJob.AnyFinish) = 0 then
      begin
        if not VarIsNull(Job.SplitMode1) and (Job.SplitMode1 <> 0) and not VarIsNull(Job.SplitPart1) then
          Accept := CurJob.SplitPart1 = Job.SplitPart1;
        if not VarIsNull(Job.SplitMode2) and (Job.SplitMode2 <> 0) and not VarIsNull(Job.SplitPart2) then
          Accept := Accept and (CurJob.SplitPart2 = Job.SplitPart2);
        if Accept then
        begin
          SetLength(TmpList, Length(TmpList) + 1);
          TmpList[Length(TmpList) - 1] := CurJob.JobID;
        end;
      end;
    end;
  end;
  for I := Low(TmpList) to High(TmpList) do
    RemoveJob(FWorkload.JobList.GetJob(TmpList[I]));
end;

function TCachedScheduleAdapter.ScheduleChanged: boolean;
begin
  FChangeDetector.CheckNow;
  Result := FChangeDetector.Changed;
  FChangeDetector.Reset;
end;

procedure TCachedScheduleAdapter.CommitUpdates;
var
  Job: TJobParams;
  SQLAdapter: TSQLScheduleAdapter;
  I: integer;
  //Info: TRenumberInfo;
  SplitModeNum: integer;
begin
  if EnableUndo then
    SaveForUndo;

  if not FUpdatesPending and EnableUndo then
    ExceptionHandler.Raise_('Вызов CommitUpdates без BeginUpdates. Сообщите, пожалуйста, разработчику.');

  SQLAdapter := TSQLScheduleAdapter.Create;
  try
    for I := 0 to FWorkload.JobList.Count - 1 do
    begin
      Job := FWorkload.JobList[I];
      if not Job.IsNew then
      begin
        if Job.Changed then
        begin
          SQLAdapter.UpdatePlan(Job);
        end;
      end
      else
      if Job.JobType >= JobType_Special then
        // Добавление спец. работы
        SQLAdapter.AddSpecialJob(Job)
      else
      begin
        if not VarIsNull(Job.SplitPart2) then
          SplitModeNum := 3
        else if not VarIsNull(Job.SplitPart1) then
          SplitModeNum := 2
        else
          SplitModeNum := 1;
        // Добавление обычной работы (разбивка)
        SQLAdapter.DoAddSplitJob(Job, Job.PlanStart, Job.PlanFinish, SplitModeNum);
      end;
    end;
    // Удаленные интервалы или работы
    for I := 0 to FRemovedJobList.Count - 1 do
    begin
      Job := FRemovedJobList[I];
      SQLAdapter.RemoveJob(Job);
    end;
    // Снятые работы
    for I := 0 to FUnPlannedJobList.Count - 1 do
    begin
      Job := FUnplannedJobList[I];
      SQLAdapter.UpdatePlan(Job);
      //SQLAdapter.UnPlanJob(Job);
    end;
    {for I := 0 to FRenumberList.Count - 1 do
    begin
      Info := FRenumberList[I];
      SQLAdapter.RenumberSplitPartsItem(Info.ItemID, Info.SplitPart1, Info.SplitPart2, Info.SplitPartNum);
    end;}
    ClearLists;
  finally
    SQLAdapter.Free;
  end;
  // снимаем флаг изменения
  ScheduleChanged;
  // снимаем флаг внесения изменений
  FUpdatesPending := false;
end;

{procedure TCachedScheduleAdapter.MoveChangesToData;
var
  I: integer;
  CurJob: TJobParams;
begin
  FWorkload.DataSet.DisableControls;
  try
    for I := 0 to FWorkload.JobList.Count - 1 do
    begin
      CurJob := FWorkload.JobList[i];
      if CurJob.Changed and FWorkload.Locate(CurJob.JobID) then
        FWorkload.SetJobParams(CurJob);
    end;
  finally
    FWorkload.DataSet.EnableControls;
  end;
end;}

procedure ClearJob(Job: TJobParams);
begin
  Job.PlanStart := null;
  Job.PlanFinish := null;
  Job.FactStart := null;
  Job.FactFinish := null;
  Job.FactProductOut := null;
  Job.SplitPart1 := null;
  Job.SplitPart2 := null;
  Job.SplitPart3 := null;
end;

procedure ModifyJob(Job: TJobParams);
begin
  Job.PlanStart := Job.PlanStart;
  Job.PlanFinish := Job.PlanFinish;
  Job.FactStart := Job.FactStart;
  Job.FactFinish := Job.FactFinish;
  Job.FactProductOut := Job.FactProductOut;
  Job.SplitPart1 := Job.SplitPart1;
  Job.SplitPart2 := Job.SplitPart2;
  Job.SplitPart3 := Job.SplitPart3;
  Job.SplitMode1 := Job.SplitMode1;
  Job.SplitMode2 := Job.SplitMode2;
  Job.SplitMode3 := Job.SplitMode3;
end;

procedure TCachedScheduleAdapter.SaveForUndo;
var
  I: Integer;
  RemovedJob, UnPlannedJob, OldJob: TJobParams;
  Hist: THistoryRecord;
begin
  // Берем последнюю запись в истории
  Hist := FHistory[Length(FHistory) - 1];
  // сохраняем списки удаленных и снятых
  Hist.RemovedJobList := TJobList.Create;
  for I := 0 to FRemovedJobList.Count - 1 do
  begin
    RemovedJob := FRemovedJobList[i];
    OldJob := Hist.JobList.GetJob(RemovedJob.JobID);
    if OldJob <> nil then
    begin
      Hist.RemovedJobList.Add(OldJob);
      Hist.JobList.Remove(OldJob);
    end
    else
      ExceptionHandler.Raise_('Не найдена работа: ' + IntToStr(RemovedJob.JobID));
    ClearJob(RemovedJob);
  end;

  Hist.UnplannedJobList := TJobList.Create;
  for I := 0 to FUnplannedJobList.Count - 1 do
  begin
    UnPlannedJob := FUnPlannedJobList[i];
    OldJob := Hist.JobList.GetJob(UnPlannedJob.JobID);
    if OldJob <> nil then
    begin
      Hist.UnPlannedJobList.Add(OldJob);
      Hist.JobList.Remove(OldJob);
    end
    else
      ExceptionHandler.Raise_('Не найдена работа: ' + IntToStr(UnPlannedJob.JobID));
    ClearJob(UnplannedJob);
  end;

  FHistory[Length(FHistory) - 1] := Hist;
end;

procedure TCachedScheduleAdapter.BeginUpdates;
var
  Hist: THistoryRecord;
begin
  // Делаем копию списка работ и помещаем в новую запись в истории изменений
  Hist.JobList := FWorkload.BuildJobList;
  Hist.UnplannedJobList := nil;
  Hist.RemovedJobList := nil;
  SetLength(FHistory, Length(FHistory) + 1);
  FHistory[Length(FHistory) - 1] := Hist;
  // устанавливаем флаг внесения изменений
  FUpdatesPending := true;
end;

function TCachedScheduleAdapter.UndoLastEdit: boolean;
var
  I: Integer;
  Job, OldJob: TJobParams;
  Ids: TIntArray;
  Hist: THistoryRecord;
begin
  if Length(FHistory) > 0 then
  begin
    // берем последнюю запись в истории изменений
    Hist := FHistory[Length(FHistory) - 1];

    // Проверяем, какие работы были добавлены и удаляем их
    FUndoRemoved := false;
    SetLength(Ids, 0);
    for I := 0 to FWorkload.JobList.Count - 1 do
    begin
      Job := FWorkload.JobList[I];
      if Hist.JobList.GetJob(Job.JobID) = nil then
      begin
        SetLength(Ids, Length(Ids) + 1);
        Ids[Length(Ids) - 1] := Job.JobID;
      end;
    end;
    if Length(Ids) > 0 then
    begin
      for I := Low(Ids) to High(Ids) do
      begin
        Job := FWorkload.JobList.GetJob(Ids[I]);
        RemoveJob(Job);
        if Job.JobType = 0 then  // спец. работы не считаются
          FUndoRemoved := true;
      end;
    end;
    // Проверяем, какие работы были изменены
    SetLength(Ids, 0);
    for I := 0 to FWorkload.JobList.Count - 1 do
    begin
      Job := FWorkload.JobList[I];
      OldJob := Hist.JobList.GetJob(Job.JobID);
      if (OldJob <> nil) and not Job.Equals(OldJob) then
      begin
        SetLength(Ids, Length(Ids) + 1);
        Ids[Length(Ids) - 1] := Job.JobID;
      end;
    end;
    if Length(Ids) > 0 then
    begin
      for I := Low(Ids) to High(Ids) do
      begin
        Job := FWorkload.JobList.GetJob(Ids[I]);
        OldJob := Hist.JobList.GetJob(Ids[I]);
        Job.AssignChanges(OldJob);
      end;
      FWorkload.SortJobs;
    end;
    // Проверяем, какие работы были сняты и восстанавливаем их
    FUndoRestored := false;
    SetLength(Ids, Hist.UnplannedJobList.Count);
    for I := 0 to Hist.UnplannedJobList.Count - 1 do
    begin
      Job := Hist.UnplannedJobList[I];
      Ids[I] := Job.JobID;
    end;
    if Length(Ids) > 0 then
    begin
      for I := Low(Ids) to High(Ids) do
      begin
        //Job := Hist.UnplannedJobList[I];
        OldJob := Hist.UnplannedJobList.GetJob(Ids[I]);
        if OldJob.JobType > 0 then
          OldJob.IsNew := true;
        FWorkload.JobList.Add(OldJob);
        ModifyJob(OldJob);
        Hist.UnplannedJobList.Remove(OldJob);
        Hist.JobList.Remove(OldJob);
        if OldJob.JobType = 0 then  // спец. работы не считаются
          FUndoRestored := true;
      end;
      FWorkload.SortJobs;
    end;
    // Проверяем, какие работы были удалены и восстанавливаем их
    SetLength(Ids, Hist.RemovedJobList.Count);
    for I := 0 to Hist.RemovedJobList.Count - 1 do
    begin
      Job := Hist.RemovedJobList[I];
      Ids[I] := Job.JobID;
    end;
    if Length(Ids) > 0 then
    begin
      for I := Low(Ids) to High(Ids) do
      begin
        //Job := Hist.RemovedJobList[I];
        OldJob := Hist.RemovedJobList.GetJob(Ids[I]);
        //if OldJob.JobType > 0 then
          OldJob.IsNew := true;
        FWorkload.JobList.Add(OldJob);
        //ModifyJob(OldJob);
        Hist.RemovedJobList.Remove(OldJob);
        Hist.JobList.Remove(OldJob);
        if OldJob.JobType = 0 then  // спец. работы не считаются
          FUndoRestored := true;
        //Job.AssignChanges(OldJob);
      end;
      FWorkload.SortJobs;
    end;

    // Убираем последнюю запись в истории
    Hist.Free;
    SetLength(FHistory, Length(FHistory) - 1);

    Result := true;
  end
  else
    Result := false;
end;

procedure TCachedScheduleAdapter.RollbackUpdates;
var
  Hist: THistoryRecord;
begin
  if not FUpdatesPending then
    ExceptionHandler.Raise_('Вызов RollbackUpdates без BeginUpdates. Сообщите, пожалуйста, разработчику.');

  if EnableUndo and (Length(FHistory) > 0) then
  begin
    // берем последнюю запись в истории изменений
    Hist := FHistory[Length(FHistory) - 1];
    // Убираем последнюю запись в истории
    Hist.Free;
    SetLength(FHistory, Length(FHistory) - 1);
  end;

  ClearLists;

  // снимаем флаг внесения изменений
  FUpdatesPending := false;
end;

function IsValidDate(DateValue: variant): boolean;
begin
  Result := NvlDateTime(DateValue) <> 0;
end;

function IsNullDate(DateValue: variant): boolean;
begin
  Result := not VarIsNull(DateValue) and (NvlDateTime(DateValue) = 0);
end;

procedure AddValidationMessage(List: TStringList; Text: string; Job: TJobParams);
begin
  List.Add('Некорректная ' + Text + ' работы ' + Job.Comment + ' (' + Job.PartName + ')');
end;

function TCachedScheduleAdapter.Validate: TStringList;
var
  I: integer;
  Job: TJobParams;
begin
  Result := TStringList.Create;
  for I := 0 to FWorkload.JobList.Count - 1 do
  begin
    Job := FWorkload.JobList[I];
    if IsNullDate(Job.PlanStart) then
      AddValidationMessage(Result, 'плановая дата начала', Job);
    if IsNullDate(Job.PlanFinish) then
      AddValidationMessage(Result, 'плановая дата окончания', Job);
    if IsNullDate(Job.FactStart) then
      AddValidationMessage(Result, 'фактическая дата начала', Job);
    if IsNullDate(Job.FactFinish) then
      AddValidationMessage(Result, 'фактическая дата окончания', Job);
    if not IsValidDate(Job.PlanStart) and not IsValidDate(Job.FactStart) then
      AddValidationMessage(Result, 'дата начала', Job);
    if not IsValidDate(Job.PlanFinish) and not IsValidDate(Job.FactFinish) then
      AddValidationMessage(Result, 'дата окончания', Job);
  end;
end;

procedure TCachedScheduleAdapter.SetWorkload(Value: TWorkload);
begin
  FWorkload := Value;
  if Value <> nil then
    FChangeDetector.EquipCode := Value.EquipCode;
end;

end.
