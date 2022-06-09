unit PlanUtils;

interface

uses DB, PmJobParams;

const
  // ��������� ���������� ��������
  esWait = 1;
  esInProgress = 2;
  esFactFinished = 3;
  esPlanFinished = 4;   // ���������� � ���������� ���� ��� ������� � ����������
  esPlanInProgress = 5; // ������ ����� � ���������� ���� ��� ������� � ������ �����
  esNotPlanned = 6;
  esPaused = 7;         // �������������
  esNotDefined = 8;     // ��������� ������������ ��-�� �������� ������� �� �����

function CalcExecState(DataSet: TDataSet): integer;
//procedure CalcDuration(DataSet: TDataSet);

// ������ ������ � ������� ������ ���� ������, ��� ��������� � ����
// function GetDurationText(Value: Variant): string;
// ����� � ������� ����������� ��� hh:mm
function FormatTimeValue(Value: integer): string;
function RoundMinutesBetween(Date1, Date2: TDateTime): integer;
// ��������� ����� �� ���� � ��������� �� �������. ����� �� ��������������
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
      if Value > 1 then  // ������������ - ��� ���������� �����
        s := IntToStr(Trunc(Value)) + ' � '
      else
        s := '';
      Result := s + IntToStr(Trunc(Frac(Value) * 60)) + ' ���';
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

  // ���� ������� �� �����������
  if not IsPlanningProcess then
  begin
    if not DateIsNull(FactFinish) then
    begin
      if Present >= FactFinish then
        // ����������� ��������� ��������, ������ �� ����� ��������
        Result := esFactFinished
      else
      if not DateIsNull(FactStart) then
      begin
        // ��������� ����� �� ��������
//        if IsPaused then
//          Result := esPaused
//        else
          if Present > FactStart then Result := esInProgress  // �����������
          else Result := esWait; // �� ������ ������
      end
      else
        Result := esWait;  // ������ �� ��������
    end
    else
    if not DateIsNull(FactStart) then
    begin // ��������� �� ��������, ������ ��������
      // ��������� ����� �� ��������
//      if IsPaused then
//        Result := esPaused
//      else
        if Present > FactStart then Result := esInProgress  // �����������
        else Result := esWait; // �� ������ ������
    end
    else // ������ �� ��������
      Result := esWait;
    Exit;
  end;  // ������ �� ����!

  // ������� �����������
  if not DateIsNull(FactFinish) then
  begin
    // ����������� ��������� ��������, ���� � ������ �� ����� ��������
    if (Present >= FactFinish) then  // ������ ��������� ��� ��������
      Result := esFactFinished
    else
      Result := esInProgress;
  end
  else
    // ��������� ����� �� ��������
//    if IsPaused then
//      Result := esPaused
//    else
    if not DateIsNull(FactStart) then
    begin   // �������� ������
      if not DateIsNull(PlanFinish) then
      begin  // ...� ������������� ���������
        if (Present >= FactStart) and (Present < PlanFinish) then
          Result := esInProgress
        else
        if Present < FactStart then   // ������������ ��������
          Result := esWait
        else
          Result := esPlanFinished;
      end
      else
      begin
        if Present >= FactStart then
          // ��������� �� �������������, �� ������ �������� - � ��������
          Result := esInProgress
        else
          // ������ �������� �� �����...
          Result := esWait;
      end;
    end
    else
    begin  // ����. ������ �� ��������
      if not DateIsNull(PlanStart) then
      begin
        if Present < PlanStart then Result := esWait  // ... � �� ��������� ������ ��� �� ����� - ��������
        else
        begin  // ������ ��������� ������ ��� ������
          if not DateIsNull(PlanFinish) then
          begin
            if Present < PlanFinish then   // �������� ��������� ��� �� ���������
              Result := esPlanInProgress
            else
              Result := esPlanFinished;
          end
          else
            Result := esNotPlanned; // ���� �������� ����� �� ������� �� ������� �����������������
        end;
      end
      else
        Result := esNotPlanned;  // �� �������� �� ����. ������, �� ��������
    end;
end;

function CalcExecState(DataSet: TDataSet): integer;
var
  IsPlanningProcess: boolean;
  FactStart, FactFinish, PlanStart, PlanFinish: variant;
  IsPaused: boolean;
begin
  // ���� ������� ������ �� ����� �� ���� ����� ���� �� ����� � ������ ���,
  // ������� ����� �������������� ��������� � ����� ������
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
    {and (ExecState <> esPaused)};  // �� ���������, �.�. ����� ����������
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
    // �������� �� ��������� (���� ��� ������, �� �������� �� ������)
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
