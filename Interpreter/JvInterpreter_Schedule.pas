unit JvInterpreter_Schedule;

interface

uses JvInterpreter, PmPlan, PmProcessEntity;

type
  TScheduleCodeContext = record
    JobEntity: TSplittableProcessEntity;
  end;

var
  ScheduleCodeContext: TScheduleCodeContext;

procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);

implementation

uses PmJobParams;

procedure GetSplitPart(var Value: Variant; Args: TJvInterpreterArgs);
var
  i: integer;
begin
  i := Args.Values[0]; // тип разбивки
  Value := ScheduleCodeContext.JobEntity.GetSplitPart(TSplitMode(i));
end;

procedure HasSplitMode(var Value: Variant; Args: TJvInterpreterArgs);
var
  i: integer;
begin
  i := Args.Values[0]; // тип разбивки
  Value := ScheduleCodeContext.JobEntity.HasSplitMode(TSplitMode(i));
end;

{procedure GetSplitCountExpr(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScheduleCodeContext.JobEntity.GetSplitCountExpr(string(Args.Values[0]),
    string(Args.Values[1]), string(Args.Values[2]));
end;}

procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);
begin
  with JvInterpreterAdapter do
  begin
    AddFunction('PmSchedule', 'GetSplitPart', GetSplitPart, 1, [varEmpty], varEmpty);
    AddFunction('PmSchedule', 'HasSplitMode', HasSplitMode, 1, [varEmpty], varEmpty);
    //AddFunction('PmSchedule', 'GetSplitCountExpr', GetSplitCountExpr, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddConst('PmSchedule', 'smQuantity', Ord(smQuantity));
    AddConst('PmSchedule', 'smMultiplier', Ord(smMultiplier));
    AddConst('PmSchedule', 'smSide', Ord(smSide));
  end;
end;

end.
