unit PmScheduleAdapter;

interface

uses Classes, DB,

  PmJobParams, PmPlan, CalcUtils;

type
  TScheduleAdapter = class
  private
    procedure RelatedCalcFields(DataSet: TDataSet);
    procedure PartNameGetText(Sender: TField; var Text: String; DisplayText: Boolean);
  protected
    function ConvertDT(dt: variant): string;
    {function DoAddSplitJob(ItemId: Integer; StartTime, FinishTime: TDateTime;
      FactStartTime: Variant; EquipCode: Integer; Executor, SplitPart1, SplitPart2: Variant;
      SplitModeNum: Variant; JobAlert: Boolean): integer; virtual; abstract;}
    function DoAddSplitJob(SourceJob: TJobParams; StartTime, FinishTime:
      TDateTime; SplitModeNum: variant): integer; virtual; abstract;
  public
    procedure UpdatePlan(JobID: integer; StartTime, FinishTime: TDateTime); overload; virtual; abstract;
    procedure UpdateFact(JobID: integer; FactStartTime, FactFinishTime: TDateTime); virtual; abstract;
    // перенумеровывает части разбивки
    //procedure RenumberSplitPartsJob(JobID: integer; SplitPartNum: integer); virtual; abstract;
    procedure RenumberSplitPartsItem(ItemID: integer;
      SplitPart1, SplitPart2: variant; SplitPartNum: integer); virtual; abstract;
    // обновляет разбивку, возвращает тип разбивки
    function UpdateJobSplitMode(Job: TJobParams;
       StartTime, FinishTime: TDateTime; SplitMode: TSplitMode; _AutoSplit: boolean): integer;
    procedure UpdateSplitPart(Job: TJobParams; SplitPart: integer; SplitPartNum: integer);
    // Обновляет только те параметры, которые были установлены
    procedure UpdatePlan(JobParams: TJobParams); overload; virtual; abstract;
    // возвращает максимальный номер части для разбитых работ
    //function GetMaxSplitPart(w: TWorkload; SplitPartNum: integer): integer; virtual; abstract;
    //procedure PauseJob(w: TWorkload); virtual; abstract;
    // возвращает ключ добавленной работы
    function AddSplitJob(SourceJob: TJobParams; StartTime, FinishTime: TDateTime;
      SplitModeNum: variant): integer;
    function AddSpecialJob(Job: TJobParams): Integer; virtual; abstract;
    procedure UpdateJobComment(JobID: integer; NewComment: variant; JobAlert: boolean); virtual; abstract;
    // Заменяет удаленную работу на специальную с указанным кодом.
    // Не удаляет исходную!
    function ReplaceJobWithSpecial(JobID: integer; JobCode: integer; ReasonText: string): integer; virtual; abstract;
    // Снять работу из плана - для всех работ.
    // Удаляет специальные работы и части разбитых и делает незапланированными остальные.
    procedure RemoveJob(Job: TJobParams); virtual; abstract;
    // Снять работу - сделать работу незапланированной
    procedure UnPlanJob(Job: TJobParams); virtual; abstract;
    // Снять все работы этого процесса (для работ, разбитых на части)
    procedure UnPlanItem(Job: TJobParams); virtual; abstract;
    // получить ключи работ для данного процесса
    function GetItemJobIDs(ItemID: integer): TIntArray; virtual; abstract;
    // получить ключи работ с плановыми датами для данного процесса
    function GetJobsWithFactInfo(ItemID: integer): TIntArray; virtual; abstract;
    // true если работа разбита
    //function MultipleJobs(ItemID: integer): Boolean; virtual; abstract;
    // возвращает последнюю по дате часть разбитой работы, принадлежую к той же работе,
    // с учетом разбивки по полю с номером SplitModeNum.
    function GetLastSplitJob(Job: TJobParams; SplitModeNum: integer): integer; virtual; abstract;
    // возвращает общую длительность по всему процессу
    //procedure GetItemTotals(ItemID: integer; var TotalSec: integer); virtual; abstract;
    // возвращает общую длительность частей для работы, разбитой по тиражу
    //function GetJobTotalSec(Job: TJobParams): integer; virtual; abstract;
    function GetJobTotalSecExcept(Job: TJobParams; ExceptIDs: array of integer): integer; virtual; abstract;
    // удаляет части нулевой длины для работы, разбитой по тиражу
    procedure RemoveZeroTimeJobs(Job: TJobParams); virtual; abstract;

    function CreateRelatedProcesses(tempDm: TDataModule; IsFollowing: boolean;
        SequenceOrder, Part, OrderID, ItemID, JobID: integer; StartTime,
        FinishTime: variant): TDataSource;

    // Возвращет набор данных с работами, относящимися к данной группе оборудования
    // для указанного номера заказа в текущем году.
    function CreateLocatedProcesses(EquipGroupCode: integer;
      OrderNum: integer; tempDM: TDataModule; Year: integer): TDataSource;
  end;

implementation

uses ADODB, Variants, SysUtils,

  ExHandler, RDBUtils, JvInterpreter_CustomQuery, PlanUtils, PmProcess,
  PmDatabase, DicObj, PmOrderProcessItems;

function TScheduleAdapter.UpdateJobSplitMode(Job: TJobParams;
  StartTime, FinishTime: TDateTime; SplitMode: TSplitMode; _AutoSplit: boolean): integer;
var
  sn: integer;
begin
  if VarIsNull(Job.FactStart) or VarIsEmpty(Job.FactStart) then
    Job.PlanStart := StartTime
  else
    Job.FactStart := StartTime;
  if VarIsNull(Job.FactFinish) or VarIsEmpty(Job.FactFinish) then
    Job.PlanFinish := FinishTime
  else
    Job.FactFinish := FinishTime;

  if (Job.SplitMode1 <> SplitMode) and (Job.SplitMode2 <> SplitMode)
      and (Job.SplitMode3 <> SplitMode) then
  begin
    // ищем свободное поле для отметки разбивки
    if VarIsNull(Job.SplitMode1) or VarIsEmpty(Job.SplitMode1) then
    begin
      Job.SplitMode1 := SplitMode;
      sn := 1;
    end else if VarIsNull(Job.SplitMode2) or VarIsEmpty(Job.SplitMode2) then
    begin
      Job.SplitMode2 := SplitMode;
      sn := 2;
    end else if VarIsNull(Job.SplitMode3) or VarIsEmpty(Job.SplitMode3) then
    begin
      Job.SplitMode3 := SplitMode;
      sn := 3;
    end else
      ExceptionHandler.Raise_(Exception.Create('Не удается присвоить режим разбивки'));
  end
  else
  begin
    // определяем, по какому полю обновляется разбивка
    if Job.SplitMode1 = SplitMode then
      sn := 1
    else if Job.SplitMode2 = SplitMode then
      sn := 2
    else if Job.SplitMode3 = SplitMode then
      sn := 3;
  end;
  Job.AutoSplit := _AutoSplit;
  UpdatePlan(Job);
  // RenumberSplitPartsJob(Job.JobID, sn); // 12.05.2009 НЕ НАДО, Т.К. ЕЩЕ НЕТ ВСЕХ ИНТЕРВАЛОВ
  Result := sn;
end;

procedure TScheduleAdapter.UpdateSplitPart(Job: TJobParams;
  SplitPart: integer; SplitPartNum: integer);
begin
  if SplitPartNum = 1 then
    Job.SplitPart1 := SplitPart
  else if SplitPartNum = 2 then
    Job.SplitPart2 := SplitPart
  else if SplitPartNum = 3 then
    Job.SplitPart2 := SplitPart;
  UpdatePlan(Job);
end;
{
function TScheduleAdapter.AddSplitJob(ItemId: integer; StartTime, FinishTime:
    TDateTime; FactStartTime: variant; EquipCode: integer; Executor, JobComment: variant;
    SplitPart1, SplitPart2: variant; SplitModeNum: variant; JobAlert: boolean): integer;
var
  NewJobID: integer;
begin
  NewJobID := DoAddSplitJob(ItemId, StartTime, FinishTime, FactStartTime, EquipCode, Executor,
    SplitPart1, SplitPart2, SplitModeNum, JobAlert);
  Result := NewJobID;
end;
}
function TScheduleAdapter.AddSplitJob(SourceJob: TJobParams; StartTime, FinishTime: TDateTime;
  SplitModeNum: variant): integer;
begin
  Result := DoAddSplitJob(SourceJob, StartTime, FinishTime, SplitModeNum);
end;

function TScheduleAdapter.ConvertDT(dt: variant): string;
begin
  if VarIsNull(dt) or (dt = 0) then
    Result := 'null'
  else
    Result := 'convert(datetime, ''' + DateToStrODBC(dt) + ''', 121)'
end;

// можно не указывать StartTime & FinishTime
function TScheduleAdapter.CreateRelatedProcesses(tempDm: TDataModule; IsFollowing:
    boolean; SequenceOrder, Part, OrderID, ItemID, JobID: integer;
    StartTime, FinishTime: variant): TDataSource;
var
  Sql, CompareSign, CompareDate: string;
begin
  if IsFollowing then CompareSign := '>=' else CompareSign := '<';

  // Если есть плановые даты завершения и начала, то будем показывать процесс
  // с учетом разбивки.
  if not VarIsNull(StartTime) and not VarIsNull(FinishTime) then
  begin
    if IsFollowing then
      CompareDate := 'PlanStartDate >= ' + ConvertDT(FinishTime)
    else
      CompareDate := 'PlanFinishDate <= ' + ConvertDT(StartTime);
  end
  else
    CompareDate := '';

  Sql := 'select ItemDesc, opi.ProductIn, opi.ProductOut, opi.ContractorProcess,'#13#10 +
    ' COALESCE(FactStartDate, PlanStartDate) as AnyStartDate, COALESCE(FactFinishDate, PlanFinishDate) as AnyFinishDate,'#13#10 +
    ' FactStartDate, PlanStartDate, FactFinishDate, PlanFinishDate,'#13#10 +
    ' j.FactProductOut, EnablePlanning, IsPaused, opi.Part, pn.Name as PartName ' + #13#10 +
    'from OrderProcessItem opi inner join Services ss on opi.ProcessID = ss.SrvID ' + #13#10 +
    ' inner join Job j on j.ItemID = opi.ItemID ' + #13#10 +
    ' inner join Dic_Parts pn on pn.Code = opi.Part' + #13#10 +
    'where (ss.EnableTracking = 1 or ss.EnablePlanning = 1) and opi.Enabled = 1' +
    ' and ((ss.SequenceOrder ' + CompareSign + ' ' + IntToStr(SequenceOrder) +
           ' and opi.ItemID <> ' + IntToStr(ItemID) + ')';

  {if CompareDate <> '' then
    Sql := Sql + ' or (opi.ItemID = ' + IntToStr(ItemID) + ' and ' + CompareDate + ')';} // 13.05.2009

  Sql := Sql + ') and (opi.Part = ' + IntToStr(Part) + ' or opi.Part >= 1000)' +
    // т.к. нет частей нормальных, то приходится использовать ключ заказа
    { TODO: переделать когда будут части! }
    ' and opi.OrderID = ' + IntToStr(OrderID) +
//    ' and j.JobID <> ' + IntToStr(JobID);  // исключаем текущую работу
    ' and opi.ItemID <> ' + IntToStr(ItemID);  // исключаем текущую работу

  Result := CreateQueryDM(tempDm, tempDm, 'Related' + IntToStr(Ord(IsFollowing)), Database.Connection);

  // Здесь надо вычисляемое поле добавить так что пришлось и все остальные тоже
  CreateCalcField(Result.DataSet, tempDm, TOrderProcessItems.F_ExecState, TIntegerField, 0);
  CreateField(Result.DataSet, tempDm, TOrderProcessItems.F_ItemDesc, TStringField, 150, false);
  CreateField(Result.DataSet, tempDm, 'ProductIn', TIntegerField, 0, false);
  CreateField(Result.DataSet, tempDm, TOrderProcessItems.F_ProductOut, TIntegerField, 0, false);
  CreateField(Result.DataSet, tempDm, TOrderProcessItems.F_ContractorProcess, TBooleanField, 0, false);
  CreateField(Result.DataSet, tempDm, 'AnyStartDate', TDateTimeField, 0, false);
  CreateField(Result.DataSet, tempDm, 'AnyFinishDate', TDateTimeField, 0, false);
  CreateField(Result.DataSet, tempDm, TOrderProcessItems.F_PlanStart, TDateTimeField, 0, false);
  CreateField(Result.DataSet, tempDm, TOrderProcessItems.F_PlanFinish, TDateTimeField, 0, false);
  CreateField(Result.DataSet, tempDm, TOrderProcessItems.F_FactStart, TDateTimeField, 0, false);
  CreateField(Result.DataSet, tempDm, TOrderProcessItems.F_FactFinish, TDateTimeField, 0, false);
  CreateField(Result.DataSet, tempDm, TOrderProcessItems.F_FactProductOut, TIntegerField, 0, false);
  CreateField(Result.DataSet, tempDm, 'EnablePlanning', TBooleanField, 0, false);
  CreateField(Result.DataSet, tempDm, 'IsPaused', TBooleanField, 0, false);
  CreateField(Result.DataSet, tempDm, F_Part, TIntegerField, 0, false);
  CreateField(Result.DataSet, tempDm, F_PartName, TStringField, DicObj.DicItemNameSize, false);
  Result.DataSet.OnCalcFields := RelatedCalcFields;

  SetQuerySQL(Result, Sql);
  Database.OpenDataSet(Result.DataSet);
end;

function TScheduleAdapter.CreateLocatedProcesses(EquipGroupCode: integer;
  OrderNum: integer; tempDM: TDataModule; Year: integer): TDataSource;
var
  Sql: string;
begin
  Sql := 'select j.JobID, COALESCE(j.FactStartDate, j.PlanStartDate) as AnyStartDate, COALESCE(j.FactFinishDate, j.PlanFinishDate) as AnyFinishDate,'#13#10
       + ' opi.ProductOut, j.EquipCode, opi.ItemDesc, opi.ContractorProcess,'#13#10
       + ' opi.Part, wo.CreationDate, wo.Comment, cc.Name as CustomerName, dp.Name as PartName,'#13#10
       + ' opi.SplitMode1, opi.SplitMode2, opi.SplitMode3, j.SplitPart1, j.SplitPart2, j.SplitPart3'#13#10
       + 'from Job j inner join OrderProcessItem opi on j.ItemID = opi.ItemID'#13#10
       + 'inner join WorkOrder wo on opi.OrderID = wo.N'#13#10
       + 'inner join Services ss on opi.ProcessID = ss.SrvID'#13#10
       + 'inner join Dic_Parts dp on opi.Part = dp.Code'#13#10
       + 'inner join Customer cc on wo.Customer = cc.N'#13#10
       + 'where wo.IsDraft = 0 and wo.ID_Number = ' + IntToStr(OrderNum)
       + ' and (ss.DefaultEquipGroupCode = ' + IntToStr(EquipGroupCode) + #13#10
       + ' or (ss.DefaultEquipGroupCode is null and j.EquipCode in (select Code from Dic_Equip where A1 = ' + IntToStr(EquipGroupCode) + ')))';
  if Year > 0 then
    Sql := Sql + #13#10' and YEAR(wo.CreationDate) = ' + IntToStr(Year);
  Result := CreateQueryDM(tempDm, tempDm, 'Located', Database.Connection);
  SetQuerySQL(Result, Sql);
  Database.OpenDataSet(Result.DataSet);
  (Result.DataSet.FieldByName('CreationDate') as TDateTimeField).DisplayFormat := CalcUtils.ShortDateFormat2;
  Result.DataSet.FieldByName(F_PartName).OnGetText := PartNameGetText;
end;

procedure TScheduleAdapter.PartNameGetText(Sender: TField; var Text: String; DisplayText: Boolean);
var
  ds: TDataSet;
begin
  ds := Sender.DataSet;
  Text := PlanUtils.GetPartName(NvlInteger(ds[F_Part]), ds['SplitMode1'], ds['SplitMode2'], ds['SplitMode3'],
                    ds['SplitPart1'], ds['SplitPart2'], ds['SplitPart3'], false);
end;

// Вычисление полей для предшествующих и последующих процессов
procedure TScheduleAdapter.RelatedCalcFields(DataSet: TDataSet);
begin
  DataSet['ExecState'] := PlanUtils.CalcExecState(DataSet);
end;

end.
