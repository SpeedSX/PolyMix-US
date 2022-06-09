unit PmSQLScheduleAdapter;

interface

uses Classes, DB,

  PmJobParams, PmPlan, CalcUtils, PmScheduleAdapter;

type
  TSQLScheduleAdapter = class(TScheduleAdapter)
  private
    // получить ключи работ для данного процесса с условием
    function GetItemJobIDsWhere(ItemID: integer; Where: string): TIntArray;
  protected
    // true если работа разбита
    function MultipleJobs(ItemID: integer): Boolean;
  public
    {function DoAddSplitJob(ItemId: Integer; StartTime, FinishTime: TDateTime;
      FactStartTime: Variant; EquipCode: Integer; Executor, SplitPart1, SplitPart2: Variant;
      SplitModeNum: Variant; JobAlert: Boolean): integer; override;}
    function DoAddSplitJob(SourceJob: TJobParams; StartTime, FinishTime:
       TDateTime; SplitModeNum: variant): integer; override;
    procedure UpdatePlan(JobID: integer; StartTime, FinishTime: TDateTime); overload; override;
    procedure UpdateFact(JobID: integer; FactStartTime, FactFinishTime: TDateTime); override;
    // перенумеровывает части разбивки
    //procedure RenumberSplitPartsJob(JobID: integer; SplitPartNum: integer); override;
    procedure RenumberSplitPartsItem(ItemID: integer;
      SplitPart1, SplitPart2: variant; SplitPartNum: integer); override;
    // Обновляет только те параметры, которые были установлены
    procedure UpdatePlan(JobParams: TJobParams); overload; override;
    // возвращает максимальный номер части для разбитых работ
    function GetMaxSplitPart(w: TWorkload; SplitPartNum: integer): integer;
    //procedure PauseJob(w: TWorkload); override;
    function AddSpecialJob(Job: TJobParams): Integer; override;
    procedure UpdateJobComment(JobID: integer; NewComment: variant; JobAlert: boolean); override;
    // Заменяет удаленную работу на специальную с указанным кодом.
    // Не удаляет исходную!
    function ReplaceJobWithSpecial(JobID: integer; JobCode: integer; ReasonText: string): integer; override;
    // Снять работу из плана - для всех работ.
    // Удаляет специальные работы и части разбитых и делает незапланированными остальные.
    procedure RemoveJob(Job: TJobParams); override;
    procedure RemoveJobID(JobID: integer);
    // Снять работу - сделать работу незапланированной
    procedure UnPlanJob(Job: TJobParams); override;
    // Снять все работы этого процесса (для работ, разбитых на части)
    //procedure UnPlanItem(Job: TJobParams); override;
    // получить ключи работ для данного процесса
    function GetItemJobIDs(ItemID: integer): TIntArray; override;
    // получить ключи работ с плановыми датами для данного процесса
    function GetJobsWithFactInfo(ItemID: integer): TIntArray; override;
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
  end;

implementation

uses ADODB, Variants, SysUtils,

  ExHandler, RDBUtils, JvInterpreter_CustomQuery, PlanUtils, MainData, PmProcess,
  PmDatabase, DicObj, PmOrderProcessItems;

function IntToStrNull(i: variant): string;
var
  vType: TVarType;
begin
  if not VarIsNull(i) and not VarIsEmpty(i) then
  begin
    vType := VarType(i);
    if (vType = varInteger) or (vType = varByte) or (vType = varLongWord)
        or (vType = varWord) or (vType = varSmallInt)  then
      Result := IntToStr(i)
    else
      Result := 'null';
  end
  else
    Result := 'null';
end;

// Используется в основном для строк т.к. добавляет кавычки
function StrVarToStrNull(i: variant): string;
begin
  if not VarIsNull(i) then
    Result := '''' + VarToStr(i) + ''''
  else
    Result := 'null';
end;

// Обновляет только те параметры, которые были установлены
procedure TSQLScheduleAdapter.UpdatePlan(JobParams: TJobParams);
var
  aq: TADOQuery;
  IsFirst: boolean;
  FactProd: string;

  procedure AddSQL(S: string);
  begin
    if IsFirst then
      aq.SQL.Add(s)
    else
      aq.SQL.Add(', ' + s);
    IsFirst := false;
  end;

  procedure UpdateSplitMode(SplitModeSet: boolean; SplitMode: variant;
    SplitModeNum: integer);
  begin
    if SplitModeSet then
    begin
      aq.SQL.Text := 'update OrderProcessItem set SplitMode' + IntToStr(SplitModeNum)
        + ' = ' + IntToStrNull(SplitMode) + #13#10
        + ' from OrderProcessItem opi inner join Job j on opi.ItemID = j.ItemID' + #13#10
        + ' where j.JobID = ' + IntToStr(JobParams.JobID);
      aq.ExecSQL;
    end;
  end;

  procedure UpdateAutoSplit(AutoSplit: boolean);
  begin
    aq.SQL.Text := 'update OrderProcessItem set AutoSplit = ' + IntToStr(Ord(AutoSplit)) + #13#10
      + ' from OrderProcessItem opi inner join Job j on opi.ItemID = j.ItemID' + #13#10
      + ' where j.JobID = ' + IntToStr(JobParams.JobID);
    aq.ExecSQL;
  end;

begin
  aq := TADOQuery.Create(dm);
  try
    aq.Connection := Database.Connection;
    aq.SQL.Add('update Job set');
    IsFirst := true;

    // обновляем только при пустой фактической - ПРОВЕРКА ПОКА ОТКЛЮЧЕНА.
    // (ПРОБЛЕМЫ ПРИ ВВОДЕ НОВОЙ РАБОТЫ).
    // if VarIsEmpty(JobParams.FactStart) or VarIsNull(JobParams.FactStart) then
      if JobParams.PlanStartSet then
        AddSQL('PlanStartDate = ' + ConvertDT(JobParams.PlanStart));

    // обновляем только при пустой фактической
    //if VarIsEmpty(JobParams.FactFinish) or VarIsNull(JobParams.FactFinish) then
      if JobParams.PlanFinishSet then
        AddSQL('PlanFinishDate = ' + ConvertDT(JobParams.PlanFinish));

    // Если есть отметка окончания, ставим отметку начала в плановую
    if (VarIsEmpty(JobParams.FactStart) or VarIsNull(JobParams.FactStart))
      and not VarIsEmpty(JobParams.FactFinish) and not VarIsNull(JobParams.FactFinish)
      and not VarIsEmpty(JobParams.PlanStart) and not VarIsNull(JobParams.PlanStart) then
      JobParams.FactStart := JobParams.PlanStart;

    if JobParams.FactStartSet then
      AddSQL('FactStartDate = ' + ConvertDT(JobParams.FactStart));
    if JobParams.FactFinishSet then
      AddSQL('FactFinishDate = ' + ConvertDT(JobParams.FactFinish));

    if JobParams.JobCommentSet then
      AddSQL('JobComment = ' + StrVarToStrNull(JobParams.JobComment));
    if JobParams.JobAlertSet then
      AddSQL('JobAlert = ' + IntToStr(Ord(JobParams.JobAlert)));
    if JobParams.ExecutorSet then
      AddSQL('Executor = ' + IntToStrNull(JobParams.Executor));

    // Сбросить фактическое кол-во в null, если нет фактической даты завершения
    if (VarIsNull(JobParams.FactFinish) or VarIsEmpty(JobParams.FactFinish))
       and JobParams.FactStartSet then
      FactProd := 'null'
    else if JobParams.FactProductOutSet then
      FactProd := IntToStrNull(JobParams.FactProductOut)
    else
      FactProd := '';
    if FactProd <> '' then
      AddSQL(TOrderProcessItems.F_FactProductOut + ' = ' + FactProd);

    if JobParams.EquipCodeSet then
      AddSQL('EquipCode = ' + IntToStr(JobParams.EquipCode));
    if JobParams.SplitPart1Set then
      AddSQL('SplitPart1 = ' + IntToStrNull(JobParams.SplitPart1));
    if JobParams.SplitPart2Set then
      AddSQL('SplitPart2 = ' + IntToStrNull(JobParams.SplitPart2));
    if JobParams.SplitPart3Set then
      AddSQL('SplitPart3 = ' + IntToStrNull(JobParams.SplitPart3));
    if JobParams.TimeLockedSet then
      AddSQL('TimeLocked = ' + IntToStr(Ord(JobParams.TimeLocked)));
    if JobParams.IsPausedSet then
      AddSQL('IsPaused = ' + IntToStr(Ord(JobParams.IsPaused)));
    if JobParams.JobColorSet then
      AddSQL('JobColor = ' + IntToStrNull(JobParams.JobColor));

    // если хоть что-то есть для обновления...
    if not IsFirst then
    begin
      aq.SQL.Add('where JobID = ' + IntToStr(JobParams.JobID));
      aq.ExecSQL;
    end;
    // Здесь заносится длительность всего процесса без учета разбивки
    if JobParams.EstimatedDurationSet then
    begin
      aq.SQL.Text := 'update OrderProcessItem set EstimatedDuration = ' + IntToStr(JobParams.EstimatedDuration)
        + ' from OrderProcessItem opi inner join Job j on opi.ItemID = j.ItemID'
        + ' where j.JobID = ' + IntToStr(JobParams.JobID);
      aq.ExecSQL;
    end;
    // Здесь заносится вид разбивки
    UpdateSplitMode(JobParams.SplitMode1Set, JobParams.SplitMode1, 1);
    UpdateSplitMode(JobParams.SplitMode2Set, JobParams.SplitMode2, 2);
    UpdateSplitMode(JobParams.SplitMode3Set, JobParams.SplitMode3, 3);
    // Признак автоматической разбивки
    if JobParams.AutoSplitSet then
      UpdateAutoSplit(JobParams.AutoSplit);
  finally
    aq.Free;
  end;
end;

procedure TSQLScheduleAdapter.UpdatePlan(JobID: integer;
  StartTime, FinishTime: TDateTime);
var
  Job: TJobParams;
begin
  Job := TJobParams.Create;
  try
    Job.JobID := JobID;
    Job.PlanStart := StartTime;
    Job.PlanFinish := FinishTime;
    UpdatePlan(Job);
  finally
    Job.Free;
  end;
end;

procedure TSQLScheduleAdapter.UpdateFact(JobID: integer;
  FactStartTime, FactFinishTime: TDateTime);
var
  Job: TJobParams;
begin
  Job := TJobParams.Create;
  try
    Job.JobID := JobID;
    Job.FactStart := FactStartTime;
    Job.FactFinish := FactFinishTime;
    UpdatePlan(Job);
  finally
    Job.Free;
  end;
end;

{procedure TSQLScheduleAdapter.RenumberSplitPartsJob(JobID: integer; SplitPartNum: integer);
var
  aq: TADOCommand;
begin
  aq := TADOCommand.Create(dm);
  try
    aq.Connection := Database.Connection;
    aq.CommandText := 'exec up_RenumberSplitPartsJob ' + IntToStr(JobID)
      + ', ' + IntToStr(SplitPartNum);
    aq.Execute;
  finally
    aq.Free;
  end;
end;}

procedure TSQLScheduleAdapter.RenumberSplitPartsItem(ItemID: integer;
  SplitPart1, SplitPart2: variant; SplitPartNum: integer);
var
  aq: TADOCommand;
begin
  aq := TADOCommand.Create(dm);
  try
    aq.Connection := Database.Connection;
    aq.CommandText := 'exec up_RenumberSplitPartsItem ' + IntToStr(ItemID)
      + ', ' + IntToStrNull(SplitPart1) + ', ' + IntToStrNull(SplitPart2)
      + ', ' + IntToStr(SplitPartNum);
    aq.Execute;
  finally
    aq.Free;
  end;
end;

// возвращает максимальный номер части для разбитых работ
function TSQLScheduleAdapter.GetMaxSplitPart(w: TWorkload; SplitPartNum: integer): integer;
var
  aq: TADOQuery;
begin
  aq := TADOQuery.Create(dm);
  try
    aq.Connection := Database.Connection;
    aq.SQL.Add('select max(SplitPart' + IntToStr(SplitPartNum)
      + ') from Job where ItemID = ' + IntToStr(w.ItemID));
    aq.Open;
    Result := aq.Fields[0].Value;
  finally
    aq.Free;
  end;
end;

{procedure TSQLScheduleAdapter.PauseJob(w: TWorkload);
var
  aq: TADOQuery;
begin
  aq := TADOQuery.Create(dm);
  try
    aq.Connection := Database.Connection;
    aq.SQL.Add('update Job set IsPaused = ' + IntToStr(Ord(not w.IsPaused))
      + ' where JobID = ' + IntToStr(w.JobID));
    aq.ExecSQL;
  finally
    aq.Free;
  end;
  w.Reload;
end;}

function TSQLScheduleAdapter.AddSpecialJob(Job: TJobParams): Integer;
var
  StartedTrans: boolean;
begin
  if not Database.InTransaction then
  begin
    Database.BeginTrans;
    StartedTrans := true;
  end
  else
    StartedTrans := false;
  try
    if Job.JobType = 0 then
      raise Exception.Create('Недопустимый код специальный работы');
    dm.aspNewSpecialJob.Parameters.ParamByName('@JobType').Value := Job.JobType;
    dm.aspNewSpecialJob.Parameters.ParamByName('@PlanStartDate').Value := Job.PlanStart;
    dm.aspNewSpecialJob.Parameters.ParamByName('@PlanFinishDate').Value := Job.PlanFinish;
    dm.aspNewSpecialJob.Parameters.ParamByName('@FactStartDate').Value := Job.FactStart;
    dm.aspNewSpecialJob.Parameters.ParamByName('@FactFinishDate').Value := Job.FactFinish;
    dm.aspNewSpecialJob.Parameters.ParamByName('@EquipCode').Value := Job.EquipCode;
    dm.aspNewSpecialJob.Parameters.ParamByName('@Executor').Value := Job.Executor;
    dm.aspNewSpecialJob.Parameters.ParamByName('@TimeLocked').Value := Job.TimeLocked;
    dm.aspNewSpecialJob.ExecProc;
    Result := dm.aspNewSpecialJob.Parameters.ParamByName('@JobID').Value;
    UpdateJobComment(Result, Job.JobComment, false);
    if StartedTrans then
      Database.CommitTrans;
  except
    if StartedTrans then
      Database.RollbackTrans;
    raise;
  end;
end;

procedure TSQLScheduleAdapter.UpdateJobComment(JobID: integer; NewComment: variant;
  JobAlert: boolean);
var
  aq: TADOQuery;
begin
  aq := TADOQuery.Create(dm);
  try
    aq.Connection := Database.Connection;
    aq.SQL.Add('update Job set JobComment = ' + StrVarToStrNull(NewComment)
      + ', JobAlert = ' + IntToStr(Ord(JobAlert))
      + ' where JobID = ' + IntToStr(JobID));
    aq.ExecSQL;
  finally
    aq.Free;
  end;
end;
{
function TSQLScheduleAdapter.DoAddSplitJob(ItemId: Integer; StartTime, FinishTime: TDateTime;
  FactStartTime: Variant; EquipCode: Integer; Executor, SplitPart1, SplitPart2: Variant;
  SplitModeNum: Variant; JobAlert: Boolean): integer;
var
  aq: TADOQuery;
  s: string;
begin
  aq := TADOQuery.Create(dm);
  try
    aq.Connection := Database.Connection;
    s := 'insert into Job (ItemID, JobType, PlanStartDate, PlanFinishDate, FactStartDate, EquipCode, Executor, IsPaused, JobAlert';
    if SplitModeNum = 2 then
      s := s + ', SplitPart1'
    else if SplitModeNum = 3 then
      s := s + ', SplitPart1, SplitPart2';
    s := s + ')' + ''#13''#10'';
    s := s + 'values (' + IntToStr(ItemID) + ', 0, ' + ConvertDT(StartTime) + ', ' + ConvertDT(FinishTime) + ', ' + ConvertDT(FactStartTime) + ', ' + IntToStr(EquipCode) + ', ' + IntToStrNull(Executor) + ', 0, ' + IntToStr(Ord(JobAlert));
    if SplitModeNum = 2 then
      s := s + ', ' + VarToStr(SplitPart1)
    else if SplitModeNum = 3 then
      s := s + ', ' + VarToStr(SplitPart1) + ', ' + VarToStr(SplitPart2);
    s := s + ')';
    aq.SQL.Add(s);
    aq.ExecSQL;
    aq.SQL.Clear;
    aq.SQL.Add('select SCOPE_IDENTITY()');
    aq.Open;
    Result := aq.Fields[0].Value;
  finally
    aq.Free;
  end;
end;
}
function TSQLScheduleAdapter.DoAddSplitJob(SourceJob: TJobParams; StartTime, FinishTime: TDateTime;
  SplitModeNum: variant): integer;
var
  aq: TADOQuery;
  s: string;
begin
  aq := TADOQuery.Create(dm);
  try
    aq.Connection := Database.Connection;
    s := 'insert into Job (ItemID, JobType, PlanStartDate, PlanFinishDate, FactStartDate, EquipCode, Executor, IsPaused, JobAlert';
    if SplitModeNum = 2 then
    begin
      s := s + ', SplitPart1';
      if not VarIsNull(SourceJob.SplitPart2) then  // необязательно, может быть перенумеровано позже
        s := s + ', SplitPart2';
    end
    else
    if SplitModeNum = 3 then
    begin
      s := s + ', SplitPart1, SplitPart2';
      if not VarIsNull(SourceJob.SplitPart3) then  // необязательно, может быть перенумеровано позже
        s := s + ', SplitPart3';
    end;
    s := s + ')' + ''#13''#10'';
    s := s + 'values (' + IntToStr(SourceJob.ItemID) + ', 0, ' + ConvertDT(StartTime)
      + ', ' + ConvertDT(FinishTime) + ', ' + 'null' + ', ' + IntToStr(SourceJob.EquipCode)
      + ', ' + IntToStrNull(SourceJob.Executor) + ', 0, ' + IntToStr(Ord(SourceJob.JobAlert));
    if SplitModeNum = 2 then
    begin
      s := s + ', ' + VarToStr(SourceJob.SplitPart1);
      if not VarIsNull(SourceJob.SplitPart2) then  // необязательно, может быть перенумеровано позже
        s := s + ', ' + VarToStr(SourceJob.SplitPart2);
    end
    else if SplitModeNum = 3 then
    begin
      s := s + ', ' + VarToStr(SourceJob.SplitPart1) + ', ' + VarToStr(SourceJob.SplitPart2);
      if not VarIsNull(SourceJob.SplitPart3) then  // необязательно, может быть перенумеровано позже
        s := s + ', ' + VarToStr(SourceJob.SplitPart3);
    end;
    s := s + ')';
    aq.SQL.Add(s);
    aq.ExecSQL;
    aq.SQL.Clear;
    aq.SQL.Add('select SCOPE_IDENTITY()');
    aq.Open;
    Result := aq.Fields[0].Value;
  finally
    aq.Free;
  end;
end;

function TSQLScheduleAdapter.ReplaceJobWithSpecial(JobID: integer; JobCode: integer; ReasonText: string): integer;
var
  aq: TADOQuery;
  NewJob: TJobParams;
begin
  aq := TADOQuery.Create(dm);
  try
    aq.Connection := Database.Connection;
    aq.SQL.Add('select PlanStartDate, PlanFinishDate, FactStartDate, FactFinishDate, Executor, EquipCode from Job'
      + ' where JobID = ' + IntToStr(JobID));
    aq.Open;
    NewJob := TJobParams.Create;
    try
      NewJob.JobType := JobCode;
      NewJob.PlanStart := aq['PlanStartDate'];
      NewJob.PlanFinish := aq['PlanFinishDate'];
      NewJob.FactStart := aq['FactStartDate'];
      NewJob.FactFinish := aq['FactFinishDate'];
      NewJob.EquipCode := aq['EquipCode'];
      NewJob.Executor := aq['Executor'];
      NewJob.JobComment := ReasonText;
      NewJob.TimeLocked := false;
      Result := AddSpecialJob(NewJob);
    finally
      NewJob.Free;
    end;
  finally
    aq.Free;
  end;
end;

function TSQLScheduleAdapter.GetJobsWithFactInfo(ItemID: integer): TIntArray;
begin
  Result := GetItemJobIDsWhere(ItemID, 'FactStartDate is not null or FactFinishDate is not null');
end;

function TSQLScheduleAdapter.GetItemJobIDs(ItemID: integer): TIntArray;
begin
  Result := GetItemJobIDsWhere(ItemID, '');
end;

function TSQLScheduleAdapter.GetItemJobIDsWhere(ItemID: integer; Where: string): TIntArray;
var
  aq: TADOQuery;
  I: integer;
begin
  aq := TADOQuery.Create(dm);
  try
    aq.Connection := Database.Connection;
    aq.SQL.Add('select JobID from Job where ');
    if Where <> '' then
      aq.SQL.Add('(' + Where + ') and ');
    aq.SQL.Add('ItemID = ' + IntToStr(ItemID));
    aq.Open;
    SetLength(Result, aq.RecordCount);
    I := 0;
    while not aq.eof do
    begin
      Result[I] := aq['JobID'];
      Inc(I);
      aq.Next;
    end;
  finally
    aq.Free;
  end;
end;

procedure TSQLScheduleAdapter.RemoveJob(Job: TJobParams);
begin
  RemoveJobID(Job.JobID);
end;

procedure TSQLScheduleAdapter.RemoveJobID(JobID: integer);
begin
  Database.ExecuteNonQuery('exec up_DeleteJob ' + IntToStr(JobID));
end;

procedure TSQLScheduleAdapter.UnPlanJob(Job: TJobParams);
begin
  Database.ExecuteNonQuery('exec up_UnPlanJob ' + IntToStr(Job.JobID));
end;

{procedure TSQLScheduleAdapter.UnPlanItem(Job: TJobParams);
begin
  Database.ExecuteNonQuery('exec up_UnPlanItem ' + IntToStr(Job.ItemID));
end;}

function TSQLScheduleAdapter.MultipleJobs(ItemID: integer): Boolean;
var
  aq: TADOQuery;
begin
  aq := TADOQuery.Create(nil);
  try
    aq.Connection := Database.Connection;
    aq.SQL.Add('select count(*) as JobCount from Job where ItemID = ' + IntToStr(ItemID));
    Database.OpenDataSet(aq);
    Result := aq['JobCount'] > 1;
  finally
    aq.Free;
  end;
end;

function TSQLScheduleAdapter.GetLastSplitJob(Job: TJobParams; SplitModeNum: integer): integer;
var
  aq: TDataSet;
  Cond: string;
begin
  if SplitModeNum = 1 then
    Cond := '';
  if SplitModeNum >= 2 then
    Cond := ' and SplitPart1 = ' + VarToStr(Job.SplitPart1);
  if SplitModeNum = 3 then
    Cond := Cond + ' and SplitPart2 = ' + VarToStr(Job.SplitPart2);

  aq := Database.ExecuteQuery(
    'select top 1 JobID from Job where ItemID = (select ItemID from Job j2 where j2.JobID = ' + IntToStr(Job.JobID) + ')'
    + Cond
    + ' order by PlanStartDate desc');
  try
    Result := NvlInteger(aq.Fields[0].Value);
  finally
    aq.Free;
  end;
end;

{procedure TSQLScheduleAdapter.GetItemTotals(ItemID: integer; var TotalSec: integer);
var
  aq: TDataSet;
begin
  aq := Database.ExecuteQuery('select sum(datediff(second, ISNULL(FactStartDate, PlanStartDate), ISNULL(FactFinishDate, PlanFinishDate)))'
    + ' from Job where ItemID = ' + IntToStr(ItemID));
  try
    TotalSec := NvlInteger(aq.Fields[0].Value);
  finally
    aq.Free;
  end;
end;}

{function TSQLScheduleAdapter.GetJobTotalSec(Job: TJobParams): integer;
var
  aq: TDataSet;
  s: string;
begin
  s := 'select sum(datediff(second, ISNULL(FactStartDate, PlanStartDate), ISNULL(FactFinishDate, PlanFinishDate)))'
    + ' from Job where ItemID = (select ItemID from Job where JobID = ' + IntToStr(Job.JobID) + ')';
  if not VarIsNull(Job.SplitMode1) and (Job.SplitMode1 <> 0) and not VarIsNull(Job.SplitPart1) then
    s := s + ' and SplitPart1 = ' + IntToStr(Job.SplitPart1);
  if not VarIsNull(Job.SplitMode2) and (Job.SplitMode2 <> 0) and not VarIsNull(Job.SplitPart2) then
    s := s + ' and SplitPart2 = ' + IntToStr(Job.SplitPart2);
  aq := Database.ExecuteQuery(s);
  try
    Result := NvlInteger(aq.Fields[0].Value);
  finally
    aq.Free;
  end;
end; }

function TSQLScheduleAdapter.GetJobTotalSecExcept(Job: TJobParams; ExceptIDs: array of integer): integer;
var
  aq: TDataSet;
  s: string;
  I: Integer;
begin
  s := 'select sum(datediff(second, ISNULL(FactStartDate, PlanStartDate), ISNULL(FactFinishDate, PlanFinishDate)))'
    + ' from Job where ItemID = (select ItemID from Job where JobID = ' + IntToStr(Job.JobID) + ')';
  if not VarIsNull(Job.SplitMode1) and (Job.SplitMode1 <> 0) and not VarIsNull(Job.SplitPart1) then
    s := s + ' and SplitPart1 = ' + IntToStr(Job.SplitPart1);
  if not VarIsNull(Job.SplitMode2) and (Job.SplitMode2 <> 0) and not VarIsNull(Job.SplitPart2) then
    s := s + ' and SplitPart2 = ' + IntToStr(Job.SplitPart2);
  for I := Low(ExceptIDs) to High(ExceptIDs) do
    s := s + ' and JobID <> ' + IntToStr(ExceptIDs[I]);
  aq := Database.ExecuteQuery(s);
  try
    Result := NvlInteger(aq.Fields[0].Value);
  finally
    aq.Free;
  end;
end;

procedure TSQLScheduleAdapter.RemoveZeroTimeJobs(Job: TJobParams);
var
  s: string;
  aq: TDataSet;
begin
  s := 'select JobID, datediff(second, ISNULL(FactStartDate, PlanStartDate), ISNULL(FactFinishDate, PlanFinishDate))'
     + ' from Job where ItemID = (select ItemID from Job where JobID = ' + IntToStr(Job.JobID) + ')';
  if not VarIsNull(Job.SplitMode1) and (Job.SplitMode1 <> 0) and not VarIsNull(Job.SplitPart1) then
    s := s + ' and SplitPart1 = ' + IntToStr(Job.SplitPart1);
  if not VarIsNull(Job.SplitMode2) and (Job.SplitMode2 <> 0) and not VarIsNull(Job.SplitPart2) then
    s := s + ' and SplitPart2 = ' + IntToStr(Job.SplitPart2);
  aq := Database.ExecuteQuery(s);
  try
    while not aq.eof do
    begin
      if NvlInteger(aq.Fields[1].Value) = 0 then
        RemoveJobID(aq.Fields[0].Value);
      aq.Next;
    end;
  finally
    aq.Free;
  end;
end;

end.
