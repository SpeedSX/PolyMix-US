unit PlanUtils;

interface

uses DB, PmJobParams;

const
  // Состояния выполнения процесса
  esWait = 1;
  esInProgress = 2;
  esFactFinished = 3;
  esPlanFinished = 4;   // завершение с опозданием либо нет отметки о завершении
  esPlanInProgress = 5; // начало работ с опозданием либо нет отметки о начале работ
  esNotPlanned = 6;
  esPaused = 7;         // приостановлен
  esNotDefined = 8;     // состояние неопределено из-за разбивки задания на части

function CalcExecState(DataSet: TDataSet): integer;
//procedure CalcDuration(DataSet: TDataSet);

// Похожи только в немного разном виде выдают, дни переводят в часы
// function GetDurationText(Value: Variant): string;
// время в минутах форматирует как hh:mm
function FormatTimeValue(Value: integer): string;
function RoundMinutesBetween(Date1, Date2: TDateTime): integer;
// Проверяет равны ли даты с точностью до секунды. Лучше не злоупотреблять
function EqualDates(Date1, Date2: variant): boolean;

function CanPause(ExecState: integer): boolean;

function GetPartName(Part: integer; SplitMode1, SplitMode2, SplitMode3,
                     SplitPart1, SplitPart2, SplitPart3: variant;
                     LineBreak: boolean): string; overload;

function GetPartName(Job: TJobParams; LineBreak: boolean): string; overload;

implementation

uses SysUtils, Variants, RDBUtils, DateUtils, StdDic, PmConfigManager;

{function GetDurationText(Value: Variant): string;
var
  s: string;
begin
  if not VarIsNull(Value) then
  begin
    if Value = 0 then
      Result := ''
    else
    begin
      if Value > 1 then  // длительность - это количество часов
        s := IntToStr(Trunc(Value)) + ' ч '
      else
        s := '';
      Result := s + IntToStr(Trunc(Frac(Value) * 60)) + ' мин';
    end;
  end
  else
    Result := '';
end;}

function FormatTimeValue(Value: integer): string;
begin
  Result := Format('%d:%2.2d', [Value div 60, Value mod 60]);
end;

{procedure CalcDuration(DataSet: TDataSet);
begin
  try
    if not VarIsNull(DataSet['PlanStartDate']) and not VarIsNull(DataSet['PlanFinishDate']) then
    begin
      if DataSet['PlanFinishDate'] > DataSet['PlanStartDate'] then
        DataSet['PlanDuration'] := HourSpan(DataSet['PlanStartDate'], DataSet['PlanFinishDate'])
      else
        DataSet['PlanDuration'] := 0;
    end
    else
      DataSet['PlanDuration'] := 0;
  except
    DataSet['PlanDuration'] := 0;
  end;
  try
    if not VarIsNull(DataSet['FactStartDate']) and not VarIsNull(DataSet['FactFinishDate']) then
    begin
      if DataSet['FactFinishDate'] > DataSet['FactStartDate'] then
        DataSet['FactDuration'] := HourSpan(DataSet['FactStartDate'], DataSet['FactFinishDate'])
      else
        DataSet['FactDuration'] := 0;
    end
    else
      DataSet['FactDuration'] := 0;
  except
    DataSet['FactDuration'] := 0;
  end;
end;}

function DateIsNull(dt: variant): boolean;
begin
  Result := VarIsNull(dt) or (dt = 0);
end;

function DoCalcExecState(IsPlanningProcess: boolean; IsPaused: boolean;
  FactStart, FactFinish, PlanStart, PlanFinish: variant): integer;
var
  Present: TDateTime;
begin
  Present := Now;
  if IsPaused then begin Result := esPaused; Exit; end;

  // Если процесс НЕ ПЛАНИРУЕМЫЙ
  if not IsPlanningProcess then
  begin
    if not DateIsNull(FactFinish) then
    begin
      if Present >= FactFinish then
        // фактическое окончание отмечено, начало не имеет значения
        Result := esFactFinished
      else
      if not DateIsNull(FactStart) then
      begin
        // Состояние паузы не меняется
//        if IsPaused then
//          Result := esPaused
//        else
          if Present > FactStart then Result := esInProgress  // выполняется
          else Result := esWait; // на всякий случай
      end
      else
        Result := esWait;  // начало не отмечено
    end
    else
    if not DateIsNull(FactStart) then
    begin // окончание не отмечено, начало отмечено
      // Состояние паузы не меняется
//      if IsPaused then
//        Result := esPaused
//      else
        if Present > FactStart then Result := esInProgress  // выполняется
        else Result := esWait; // на всякий случай
    end
    else // ничего не отмечено
      Result := esWait;
    Exit;
  end;  // дальше не идем!

  // ПРОЦЕСС ПЛАНИРУЕМЫЙ
  if not DateIsNull(FactFinish) then
  begin
    // фактическое окончание отмечено, план и начало не имеют значения
    if (Present >= FactFinish) then  // момент окончания уже наступил
      Result := esFactFinished
    else
      Result := esInProgress;
  end
  else
    // Состояние паузы не меняется
//    if IsPaused then
//      Result := esPaused
//    else
    if not DateIsNull(FactStart) then
    begin   // отмечено начало
      if not DateIsNull(PlanFinish) then
      begin  // ...и запланировано окончание
        if (Present >= FactStart) and (Present < PlanFinish) then
          Result := esInProgress
        else
        if Present < FactStart then   // некорректная ситуация
          Result := esWait
        else
          Result := esPlanFinished;
      end
      else
      begin
        if Present >= FactStart then
          // окончание не запланировано, но начало отмечено - в процессе
          Result := esInProgress
        else
          // такого наверное не будет...
          Result := esWait;
      end;
    end
    else
    begin  // факт. начало не отмечено
      if not DateIsNull(PlanStart) then
      begin
        if Present < PlanStart then Result := esWait  // ... а до планового начала еще не дошли - ожидание
        else
        begin  // момент планового начала уже прошел
          if not DateIsNull(PlanFinish) then
          begin
            if Present < PlanFinish then   // плановое окончание еще не наступило
              Result := esPlanInProgress
            else
              Result := esPlanFinished;
          end
          else
            Result := esNotPlanned; // если плановый конец не отмечен то считаем незапланированным
        end;
      end
      else
        Result := esNotPlanned;  // не отмечено ни факт. начало, ни плановое
    end;
end;

function CalcExecState(DataSet: TDataSet): integer;
var
  IsPlanningProcess: boolean;
  FactStart, FactFinish, PlanStart, PlanFinish: variant;
  IsPaused: boolean;
begin
  // Если процесс разбит на части то одна может быть на паузе а другая нет,
  // поэтому будет неопределенное состояние в этому случае
  if (DataSet.FindField('IsPausedCount') <> nil) and (NvlInteger(DataSet['IsPausedCount']) > 1) then
    Result := esNotDefined
  else
  begin
    FactStart := DataSet['FactStartDate'];
    FactFinish := DataSet['FactFinishDate'];
    IsPlanningProcess := (DataSet.FindField('EnablePlanning') = nil)
      or NvlBoolean(DataSet['EnablePlanning']);
    IsPaused := NvlBoolean(DataSet['IsPaused']);
    PlanStart := DataSet['PlanStartDate'];
    PlanFinish := DataSet['PlanFinishDate'];
    Result := DoCalcExecState(IsPlanningProcess, IsPaused, FactStart, FactFinish, PlanStart, PlanFinish);
  end;
end;

function CanPause(ExecState: integer): boolean;
begin
  Result := (ExecState <> esFactFinished) and (ExecState <> esNotPlanned)
    and (ExecState <> esWait) and (ExecState <> esPlanInProgress)
    {and (ExecState <> esPaused)};  // Не исключаем, т.к. можно продолжить
end;

function RoundMinutesBetween(Date1, Date2: TDateTime): integer;
begin
  Result := SecondsBetween(Date1, Date2);
  Result := Round(Result / 60.0);
end;

function EqualDates(Date1, Date2: variant): boolean;
begin
  Result := SecondsBetween(NvlFloat(Date1), NvlFloat(Date2)) = 0;
end;

function GetSplitPartName(SplitPart: variant; SplitMode: TSplitMode): string;
begin
  if SplitMode = smSide then
  begin
    if SplitPart = 1 then
      Result := 'A'
    else
      Result := 'B';
  end
  else
    Result := VarToStr(SplitPart);
end;

function GetPartName(Part: integer; SplitMode1, SplitMode2, SplitMode3,
                     SplitPart1, SplitPart2, SplitPart3: variant;
                     LineBreak: boolean): string;
var
  pn: string;
begin
  if Part = 0 then
    Result := ''
  else
  begin
    Result := TConfigManager.Instance.StandardDics.deParts.ItemName[Part];
    // Разбивка по множителю (если это печать, то означает по листам)
    //if HasSplitMode(smMultiplier) or HasSplitMode(smQuantity) or HasSplitMode(smSide) then
    if not VarIsNull(SplitMode1) or not VarIsNull(SplitMode2) or not VarIsNull(SplitMode3) then
    begin
      pn := '';
      if not VarIsNull(SplitPart1) then
        pn := pn + GetSplitPartName(SplitPart1, TSplitMode(NvlInteger(SplitMode1)));
      if not VarIsNull(SplitPart2) then
      begin
        if pn <> '' then
          pn := pn + '/';
        pn := pn + GetSplitPartName(SplitPart2, TSplitMode(NvlInteger(SplitMode2)));
      end;
      if not VarIsNull(SplitPart3) then
      begin
        if pn <> '' then
          pn := pn + '/';
        pn := pn + GetSplitPartName(SplitPart3, TSplitMode(NvlInteger(SplitMode3)));
      end;
      if LineBreak then
        Result := '#' + pn + #13 + Result
      else
        Result := '#' + pn + ' ' + Result;
    end;
  end;
end;

function GetPartName(Job: TJobParams; LineBreak: boolean): string;
begin
  Result := GetPartName(Job.Part, Job.SplitMode1, Job.SplitMode2, Job.SplitMode3,
    Job.SplitPart1, Job.SplitPart2, Job.SplitPart3, LineBreak);
end;

end.
