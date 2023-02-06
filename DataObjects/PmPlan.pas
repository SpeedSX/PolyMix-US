unit PmPlan;

interface

uses Classes, DB, ADODB, DBClient,

  TLoggerUnit,

  PmEntity, PmProcess, PmProcessCfg, DicObj, PmExecCode, PmQueryPager, PmOrder,
  NotifyEvent, PmProcessEntity, PmJobParams, PmShiftEmployees;

const
  // Вид просмотра загрузки оборудования
  PlanRange_Day = 0;            // день
  PlanRange_Continuous = 1;     // непрерывный
  PlanRange_Week = 2;           // неделя вперед
  PlanRange_Gantt = 3;          // диаграмма Гантта
  PlanRange_FirstShift = 4;     // первая смена, если больше, то номер смены + 1

  JobType_ShiftMarker = -1;
  JobType_Work = 0;
  JobType_Special = 1;  // тип специальной работы, проверяем на >=

  CONTINUOUS_RANGE = 14;  // 'захват' дней назад-вперед в непрерывном режиме
  WEEK_RANGE_FORWARD = 7; // 'захват' дней вперед в режиме недели
  WEEK_RANGE_BACKWARD = 1;    // 'захват' дней назад в режиме недели
  
type
  TPlan = class(TProcessEntity)
  private
    //FNoPlanSQL: string;
    FHasWhere: boolean;
    FDataSetCreated: boolean;
    //FSavedProcessID: integer;
    FCalcFieldsScriptOK: boolean;
    procedure CreateDataSet;
    //function GetOrderID: Integer;
    function GetEquipCode: Variant;
    procedure SetEquipCode(_EquipCode: Variant);
    function GetKindID: Variant;
    function GetCreatorName: string;
    function GetNotPlannedSQL(var HasWhere: boolean): TQueryObject;
    function GetHasComment: boolean;
    function GetHasTechNotes: boolean;
    function GetJobComment: variant;
  protected
    procedure DoOnCalcFields; override;
    procedure DoBeforeApplyUpdates; override;
    procedure DoBeforeOpen; override;
    procedure DoAfterOpen; override;
    procedure DefaultPlanCalcFields;
    procedure DefaultCreateDataSet;
    function DefaultGetNotPlannedSQL: TCustomSQL;
    procedure GetFinishDateText(Sender: TField; var Text: String; DisplayText: Boolean);
  public
    const
      F_HasComment = 'HasComment';
      F_HasTechNotes = 'HasTechNotes';
      F_JobAlert = 'JobAlert';
      F_Executor = 'Executor';
      JobCommentSize = 500;

    constructor Create(_EquipGroupCode: integer);
    destructor Destroy; override;
    function CalcEstimatedDuration(EquipCode: integer): Integer;
    //property OrderID: Integer read GetOrderID;
    property EquipCode: variant read GetEquipCode write SetEquipCode;
    property KindID: variant read GetKindID;
    property CreatorName: string read GetCreatorName;
    // Признак есть ли комментарий к работе (JobComment)
    property HasComment: boolean read GetHasComment;
    // Признак есть ли технологические примечания к заказу
    property HasTechNotes: boolean read GetHasTechNotes;
    property JobComment: variant read GetJobComment;
  end;

  TWorkloadCriteria = record
    Date: TDateTime;
    RangeType: integer;
  end;

  TJobList = class(TList)
  private
    FMaxJobID: integer;
    function GetIndex(Index: integer): TJobParams;
  public
    procedure FreeJobs;
    property Jobs[Index: integer]: TJobParams read GetIndex; default;
    property MaxJobID: integer read FMaxJobID;
    function GetJob(JobID: integer): TJobParams;
    function GetJobIndex(JobID: integer): integer;
    procedure Add(Job: TJobParams);
    function GetMaxJobID: integer;
  end;

  TShiftInfo = class
    Start, Finish: TDateTime;
    Number: integer;
    ID: integer;
    ShiftEmployeeID: integer;  // исполнитель для смены
    EquipEmployeeID: integer;  // исполнитель для оборудования
    EquipAssistantID: integer;  // Помошник исполнителя для оборудования
    JobList: TJobList;
    Cost: extended;
    constructor Create(_Start, _Finish: TDateTime; _Number, _ID: integer);
    destructor Destroy; override;
  end;

  TShiftList = class(TList)
  private
    function GetShift(Index: integer): TShiftInfo;
  public
    property Shifts[Index: integer]: TShiftInfo read GetShift; default;
  end;

  TWorkload = class(TSplittableProcessEntity)
  private
    FEquipCode: integer;
    //FOnScriptError: TScriptError;
    //FDataSource: TDataSource;
    FSQL: TQueryObject;
    FHasWhere: boolean;
    FDataSetCreated: boolean;
    FCalcFieldsScriptOK: boolean;
    FCriteria: TWorkloadCriteria;
    FShiftList: TShiftList;
    FShiftEmployees: TShiftEmployees;
    FShiftAssistants: TShiftAssistants;
    FEquipEmployees: TEquipEmployees;
    FEquipAssistants: TEquipAssistants;
    FJobList: TJobList;
    FLocked: boolean;
    procedure CreateDataSet;
    function GetWorkloadSQL(var HasWhere: boolean): TQueryObject;
    function GetEquipName: string;
    function GetPlanFinishDateTime: Variant;
    function GetPlanStartDateTime: Variant;
    procedure SetPlanFinishDateTime(_Value: variant);
    procedure SetPlanStartDateTime(_Value: variant);
    function GetAnyFinishDateTime: TDateTime;
    function GetAnyStartDateTime: TDateTime;
    function GetCustomerName: string;
    function GetCreatorName: string;
    function GetDayStart: TDateTime;
    procedure GetDayStartTime;
    function GetIsPaused: boolean;
    function GetExecutor: variant;
    function GetPlanDuration: string;
    function GetFactProductOut: variant;
    procedure MyTimeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure MyDateGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    //procedure WorkloadCommentGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    function GetFactFinishDateTime: Variant;
    function GetFactStartDateTime: Variant;
    function GetJobComment: variant;
    function GetJobAlert: boolean;
    function GetHasComment: boolean;
    function GetHasTechNotes: boolean;
    function GetJobType: Integer;
    function GetNextDayStart: TDateTime;
    //function GetOrderID: Variant;
    procedure SetJobColor(_Value: variant);
    function GetJobColor: variant;
    function GetKindID: variant;

    // Возвращает начало указанной смены для текущей группы оборудования в справочнике
    function GetShiftStartTime(ShiftNum: integer): TDateTime;
    // Возвращает окончание указанной смены для текущей группы оборудования в справочнике
    function GetShiftFinishTime(ShiftNum: integer): TDateTime;
    // Ищет начало первой смены для текущей группы оборудования в справочнике
    function GetFirstShiftStartTime: TDateTime;
    // Возвращает указанное поле для смены для текущей группы оборудования в справочнике,
    // количество смен и ключ записи
    function GetShiftFieldValue(ShiftNum, FieldNum: integer; var ShiftCount, ID: integer): TDateTime;
    // Возвращает количество смен для данной группы оборудования
    function GetShiftCount: integer;
    // Возвращает ключ смены для текущей группы оборудования в справочнике смен
    function GetShiftID(ShiftNum: integer): integer;
    function GetTimeLocked: boolean;
    function GetProductOut: integer;
    function GetItemProductOut: integer;
    function GetItemDuration: integer;
    function GetAutoSplit: boolean;
    function GetShiftEmployeeName: variant;
    //procedure SetShiftEmployeeName(val: variant);
    function GetEquipmentEmployeeName: variant;
    function GetEquipmentAssistantName: variant;
    //procedure SetEquipmentEmployeeName(val: variant);
    function GetShiftEmployee: variant;
    function GetShiftAssistant: variant;
    function GetEquipmentEmployee: variant;
    function GetEquipmentAssistant: variant;
    procedure SetShiftEmployee(val: variant);
    procedure SetShiftAssistant(val: variant);
    procedure SetEquipmentEmployee(val: variant);
    procedure SetEquipmentAssistant(val: variant);
    procedure FreeShiftList;
    procedure CreateShiftList;
    // Используется для фильтрации при построении списка работ для каждой смены
    //procedure ShiftFilter(DataSet: TDataSet; var Accept: Boolean);
    function CreateShiftJobs(CurShiftStart, NextShiftStart: TDateTime): TJobList;
    // Строит список работ для каждой смены
    procedure BuildShiftJobLists;
    procedure CalcShiftCost;
  protected
    FDayStartTime: TDateTime;
    //FSaveJobs: boolean;
    procedure DoOnCalcFields; override;
    procedure DoBeforeApplyUpdates; override;
    procedure DoBeforeOpen; override;
    procedure DoAfterOpen; override;
    procedure DefaultCalcFields;
    procedure DefaultCreateDataSet;
    function DefaultGetWorkloadSQL: TCustomSQL;
    // Для режима непрерывного отображения: вставляет в план маркеры смен
    procedure InsertShiftMarkers;
    procedure SetFactStartDateTime(_Value: variant);
    procedure SetFactFinishDateTime(_Value: variant);
    procedure SetShiftMarker;
    procedure SetJobType(_Value: integer);
    procedure SetJobComment(_Value: variant);
    procedure SetJobAlert(_Value: boolean);
    function CreateJobParams: TJobParams;
  public
    const
      F_AnyStart = 'AnyStartDate';
      F_AnyFinish = 'AnyFinishDate';
      F_AnyDuration = 'AnyDuration';
      F_ItemProductOut = 'ItemProductOut';
      F_ItemDuration = 'ItemDuration';
      F_ItemCost = 'ItemCost';
      F_JobCost = 'JobCost';
      F_Executor = 'Executor';
      {F_PlanDuration = 'PlanDuration';
      F_FactDuration = 'FactDuration';}

    constructor Create(_EquipCode: integer);
    destructor Destroy; override;
    //function GetShiftInfo(_JobID: integer): TShiftInfo;
    function PlanChanged: boolean;
    //procedure OpenWorkload(WorkDate: TDateTime; _Range: integer; NeedRefresh:
    //    boolean);
    procedure ChangeOrderState(Job: TJobParams; NewOrderState: integer);
    function GetSQL: TQueryObject;

    // Является ли строка маркером смены
    function IsShiftMarker: boolean;
    // Возвращает список смен TShiftInfo
    function ShiftList: TShiftList;
    // становится на маркер смены для работы с заданным началом
    //function LocateShift(JobStart: TDateTime): boolean;
    // становится на маркер смены для текущей работы
    function LocateShift: boolean;
    procedure SortJobs;
    function CurrentJob: TJobParams;
    function CurrentShift: TShiftInfo;
    // Смена по ид. работы
    function GetJobShift(JobID: integer): TShiftInfo;
    // Смена по ид. смены
    function GetShiftByID(ShiftID: integer): TShiftInfo;
    // Смена по дате
    function GetShiftByDate(DT: TDateTime): TShiftInfo;
    // перенести в набор данных в текущую запись параметры работы Job
    //procedure SetJobParams(Job: TJobParams);
    // Строит общий список работ
    function BuildJobList: TJobList;

    //property OnScriptError: TScriptError read FOnScriptError write FOnScriptError;
    property DataSource: TDataSource read FDataSource;
    // Конец диапазона просмотра = начало первой смены следующего дня
    // (недели, или следующей смены)
    property RangeEnd: TDateTime read GetNextDayStart;
    property EquipCode: integer read FEquipCode;
    property EquipName: string read GetEquipName;
    property PlanStartDateTime: Variant read GetPlanStartDateTime;
    property PlanFinishDateTime: Variant read GetPlanFinishDateTime;
    property AnyStartDateTime: TDateTime read GetAnyStartDateTime;
    property AnyFinishDateTime: TDateTime read GetAnyFinishDateTime;
    property PlanDuration: string read GetPlanDuration;
    property CustomerName: string read GetCustomerName;
    property IsPaused: boolean read GetIsPaused;
    property FactProductOut: variant read GetFactProductOut;
    property Executor: variant read GetExecutor;
    property FactFinishDateTime: Variant read GetFactFinishDateTime;
    property FactStartDateTime: Variant read GetFactStartDateTime;
    property JobType: Integer read GetJobType;
    property KindID: Variant read GetKindID;
    property CreatorName: string read GetCreatorName;
    //property OrderID: Variant read GetOrderID;
    // Начало диапазона просмотра (начало первой смены или указанной смены)
    property RangeStart: TDateTime read GetDayStart;
    property JobComment: variant read GetJobComment write SetJobComment;
    property JobAlert: boolean read GetJobAlert write SetJobAlert;
    // Признак есть ли комментарий к работе (JobComment)
    property HasComment: boolean read GetHasComment;
    // Признак есть ли технологические примечания к заказу
    property HasTechNotes: boolean read GetHasTechNotes;
    // Признак того, что работа была разбита автоматически при разнесении по сменам (CheckShifts)
    property AutoSplit: boolean read GetAutoSplit;
    // Признак фиксации
    property TimeLocked: boolean read GetTimeLocked;
    // Плановая выработка с учетом разбивки
    property ProductOut: integer read GetProductOut;
    // Плановая выработка по всей работе
    property ItemProductOut: integer read GetItemProductOut;
    // Цвет строки в режиме ручной раскраски
    property JobColor: variant read GetJobColor write SetJobColor;
    // Длительность всех интервалов работы
    property ItemDuration: integer read GetItemDuration;

    property Criteria: TWorkloadCriteria read FCriteria write FCriteria;
    //property SaveJobs: boolean read FSaveJobs write FSaveJobs;

    property ShiftEmployees: TShiftEmployees read FShiftEmployees write FShiftEmployees;
    property ShiftAssistants: TShiftAssistants read FShiftAssistants write FShiftAssistants;
    //property EquipEmployees: TEquipEmployees read FEquipEmployees;
    property ShiftForemanName: variant read GetShiftEmployeeName;// write SetShiftEmployeeName;
    property ShiftEmployee: variant read GetShiftEmployee write SetShiftEmployee;
    property ShiftAssistant: variant read GetShiftAssistant write SetShiftAssistant;
    property OperatorName: variant read GetEquipmentEmployeeName;// write SetEquipmentEmployeeName;
    // Возможно нужно сделать отдельную процедуру для помошника
    property AssistantName: variant read GetEquipmentAssistantName;// write SetEquipmentAssistantName;
    property EquipmentEmployee: variant read GetEquipmentEmployee write SetEquipmentEmployee;
    property EquipmentAssistant: variant read GetEquipmentAssistant write SetEquipmentAssistant;
    property JobList: TJobList read FJobList;
    // Заблокировано для редактирования
    property Locked: boolean read FLocked write FLocked;
  end;

const
  fnPlanStartDate = 'j.PlanStartDate';//Plan_GetProcessPlanStartDateFieldName;
  fnPlanFinishDate = 'j.PlanFinishDate';//Plan_GetProcessPlanFinishDateFieldName;
  fnFactStartDate = 'j.FactStartDate';//Plan_GetProcessFactStartDateFieldName;
  fnFactFinishDate = 'j.FactFinishDate';//Plan_GetProcessFactFinishDateFieldName;
  fnFinishOrderDate = 'wo.FinishDate'; // Plan_GetFinishOrderDateFieldName;

implementation

uses Forms, SysUtils, Variants, DateUtils,
  StdDic, Provider, JvJCLUtils,

  RDBUtils, PlanData, JvInterpreter, JvInterpreter_CustomQuery,
  ExHandler, CalcUtils, PlanUtils,
  PmDatabase, PmAccessManager, JvInterpreter_Schedule, PmConfigManager,
  PmContragent, PmOrderProcessItems, PmEntSettings;

const
  SHIFTMARKER_EXCEPTION = 'Маркер смены не найден';

{$REGION 'TEstimateDurationCode' }
type
  TEstimateDurationCode = class(TDataSetCode)
  protected
    procedure DoPrgGetValue(Sender: TObject; Identifer: String;
      var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean); override;
    procedure DoPrgSetValue(Sender: TObject; Identifer: String;
      const Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean); override;
  public
    Duration: integer;
    EquipCode: integer;
    constructor Create(_DataSet: TDataSet; _Process: TPolyProcessCfg; _ScriptFieldName: string);
  end;

procedure TEstimateDurationCode.DoPrgGetValue(Sender: TObject; Identifer: String;
  var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
begin
  inherited DoPrgGetValue(Sender, Identifer, Value, Args, Done);
  if not Done then
  begin
    if CompareText(Identifer, 'EquipCode') = 0 then
    begin
      Value := EquipCode;
      Done := true;
    end;
  end;
end;

procedure TEstimateDurationCode.DoPrgSetValue(Sender: TObject; Identifer: String;
  const Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
begin
  // Нам не надо менять набор данных поэтому не вызываем предка
  if CompareText(Identifer, 'Duration') = 0 then
  begin
    Duration := Value;
    Done := true;
  end;
end;

constructor TEstimateDurationCode.Create(_DataSet: TDataSet; _Process: TPolyProcessCfg;
  _ScriptFieldName: string);
begin
  inherited Create(_DataSet, _Process, _ScriptFieldName);
  ExposeDataSet := true;
end;

{$ENDREGION}

{$REGION 'TShiftInfo'}

constructor TShiftInfo.Create(_Start, _Finish: TDateTime; _Number, _ID: integer);
begin
  inherited Create;
  Start := _Start;
  Finish := _Finish;
  Number := _Number;
  ID := _ID;
  JobList := nil;
end;

destructor TShiftInfo.Destroy;
begin
  FreeAndNil(JobList);
  inherited;
end;

{$ENDREGION}

{$REGION 'TJobList'}

function TJobList.GetIndex(Index: integer): TJobParams;
begin
  Result := TJobParams(Items[Index]);
end;

function TJobList.GetJob(JobID: integer): TJobParams;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    if TJobParams(Items[I]).JobID = JobID then
    begin
      Result := Items[I];
      break;
    end;
end;

function TJobList.GetJobIndex(JobID: integer): integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
    if TJobParams(Items[I]).JobID = JobID then
    begin
      Result := I;
      break;
    end;
end;

procedure TJobList.FreeJobs;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    TObject(Items[i]).Free;
  Clear;
end;

procedure TJobList.Add(Job: TJobParams);
begin
  inherited Add(Job);
  if FMaxJobID < Job.JobID then
    FMaxJobID := Job.JobID;
end;

function TJobList.GetMaxJobID: integer;
var
  I: Integer;
  MaxID: integer;
begin
  MaxID := 0;
  for I := 0 to Count - 1 do
    if TJobParams(Items[i]).JobID > MaxID then
    begin
      MaxID := TJobParams(Items[i]).JobID;
      //Exit;
    end;
  if MaxID > FMaxJobID then
    FMaxJobID := MaxID;
  Result := FMaxJobID;
end;

{$ENDREGION}

{$REGION 'TShiftList'}

function TShiftList.GetShift(Index: integer): TShiftInfo;
begin
  Result := TShiftInfo(Items[Index]);
end;

{$ENDREGION}

{$REGION 'Common functions'}

function GetHasTechNotesExpr(OrderID: string): string;
begin
  Result := 'cast((case when exists (select * from OrderNotes orn where orn.OrderID = '
   + OrderID + ' and orn.UseTech = 1) then 1 else 0 end) as bit) as HasTechNotes';
end;

{$ENDREGION}

{$REGION 'TPlan - работы, которые надо планировать'}

constructor TPlan.Create(_EquipGroupCode: integer);
var
  _DataSource: TDataSource;
  _DataSet: TDataSet;
  _Provider: TDataSetProvider;
begin
  if PlanDM = nil then
    Application.CreateForm(TPlanDM, PlanDM);

  _DataSource := CreateQueryExDM(PlanDM, PlanDM, 'NoPlan_' + IntToStr(_EquipGroupCode),
    [{poAllowMultiRecordUpdates, poDisableInserts, poDisableDeletes, poDisableEdits}],
    upWhereKeyOnly, true {ResolveToDataSet}, Database.Connection, _Provider);
  _DataSet := _DataSource.DataSet;

  inherited Create('NoPlan_' + IntToStr(_EquipGroupCode){_Process.TableName}, 
    F_ItemID, _DataSet, _EquipGroupCode, {RequireEquipDic=} true);

  //FDataSource.Free;  // меняем на свой
  FDataSource := _DataSource;
  DataSetProvider := _Provider;
  DefaultLastRecord := true;

  RefreshAfterApply := true;
  FCalcFieldsScriptOK := true;  // иначе не будет работать calcfields
end;

destructor TPlan.Destroy;
begin
  inherited Destroy;
end;

procedure TPlan.CreateDataSet;
begin
  DefaultCreateDataSet;
  ExecCode(PlanScr_OnCreateNotPlanned);
  FDataSetCreated := true;
end;

procedure TPlan.DefaultCreateDataSet;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_OrderState;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  //f.Origin := 'opi.ExecState';  // Это надо для корректной выборки
  //f.FieldKind := fkInternalCalc;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'OrderID';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  //f.Origin := 'opi.OrderID';  // Это надо для корректной выборки

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_ItemID;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_JobID;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_OrderNumber;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ReadOnly := true;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'CustomerName';
  f.Size := TContragents.CustNameSize;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ReadOnly := true;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'Comment';
  f.DataSet := DataSet;
  f.Size := 128;
  f.Name := DataSet.Name + f.FieldName;
  //f.ReadOnly := true;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'EquipCode';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_Part;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'ItemDesc';
  f.DataSet := DataSet;
  f.Size := 150;
  f.Name := DataSet.Name + f.FieldName;
  f.ReadOnly := true;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'FinishDate';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm.yyyy';
  f.OnGetText := GetFinishDateText;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_PlanFinish;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm.yyyy';

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_PlanStart;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm.yyyy';

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_FactStart;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm.yyyy';

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_FactFinish;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm.yyyy';

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'EstimatedDuration';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'ProcessID';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_ProductOut;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_Cost;
  TBCDField(f).Size := 2;
  TBCDField(f).Precision := 18;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TFloatField.Create(DataSet.Owner);
  f.FieldName := 'Multiplier';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'SideCount';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := 'HasTechNotes';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'JobComment';
  f.Size := JobCommentSize;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := F_JobAlert;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_KindID;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_CreatorName;
  f.Size := TOrder.CreatorNameSize;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  // Теперь вычисляемые поля

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := F_HasComment;
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_EquipName;
  f.FieldKind := fkInternalCalc;
  f.Size := 50;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_PartName;
  f.FieldKind := fkInternalCalc;
  f.Size := 50;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
end;

procedure TPlan.DoBeforeOpen;
begin
  if not FDataSetCreated then CreateDataSet;

  QueryObject := GetNotPlannedSQL(FHasWhere);
  SetQuerySQL(FDataSource, QueryObject.GetSQL);
end;

procedure TPlan.DoAfterOpen;
begin
  // Поля, по которым можно сортировать
  TClientDataSet(DataSet).AddIndex('iOrderState', TOrder.F_OrderState, []);
  TClientDataSet(DataSet).AddIndex('i' + TOrder.F_OrderNumber, TOrder.F_OrderNumber, []);
  TClientDataSet(DataSet).AddIndex('iCustomerName', 'CustomerName', [ixCaseInsensitive]);
  TClientDataSet(DataSet).AddIndex('iPartName', F_PartName, [ixCaseInsensitive]);
  TClientDataSet(DataSet).AddIndex('iEquipName', F_EquipName, [ixCaseInsensitive]);
  TClientDataSet(DataSet).AddIndex('iFinishDate', 'FinishDate', [ixCaseInsensitive]);
  TClientDataSet(DataSet).AddIndex('iProductOut', TOrderProcessItems.F_ProductOut, [ixCaseInsensitive]);
  TClientDataSet(DataSet).IndexDefs.Update;
  TClientDataSet(DataSet).IndexFieldNames := TOrder.F_OrderNumber;
end;

procedure TPlan.DoOnCalcFields;
var
  DataSetCode: TPlanCalcFieldsCode;
  FProcess: TPolyProcessCfg;
begin
  if DataSet.State = dsInternalCalc then
  begin
  DefaultPlanCalcFields;
    if FCalcFieldsScriptOK then
    begin
      //ExecCode(PlanScr_OnNotPlannedCalcFields);
      // Ищем процесс у которого есть сценарий вычисления полей
      if FindScript(FProcess, PlanScr_OnNotPlannedCalcFields) then
      begin
        DataSetCode := TPlanCalcFieldsCode.Create(DataSet, FProcess, PlanScr_OnNotPlannedCalcFields);
        try
          DataSetCode.OnScriptError := FOnScriptError;
          DataSetCode.DataSet := DataSet;
          DataSetCode.DayMode := false;
          DataSetCode.NoPlanMode := true;
          //DataSetCode.ExposeDataSet := true;
          FCalcFieldsScriptOK := DataSetCode.ExecCode;
        finally
          DataSetCode.Free;
        end;
      end
      else
        FCalcFieldsScriptOK := false; // не нашли сценарий
    end;
  end;
end;

procedure TPlan.GetFinishDateText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := TWorkOrder.GetFinishDateText(Sender.Value);
end;

procedure TPlan.DefaultPlanCalcFields;
begin
  // вычисляемые поля, по которым можно сортировать
  //if DataSet.State = dsCalcFields then
  //begin
    if VarIsNull(DataSet[F_Part]) then DataSet[F_PartName] := ''
    else DataSet[F_PartName] := TConfigManager.Instance.StandardDics.deParts.ItemName[DataSet[F_Part]];
    if VarIsNull(DataSet['EquipCode']) then DataSet[F_EquipName] := ''
    else DataSet[F_EquipName] := TConfigManager.Instance.StandardDics.deEquip.ItemName[DataSet['EquipCode']];

    DataSet[F_HasComment] := (NvlString(DataSet['JobComment']) <> ''){ or HasTechNotes};
    //end;
end;

function TPlan.GetNotPlannedSQL(var HasWhere: boolean): TQueryObject;
var
  CustomSQL, DefaultSQL: TCustomSQL;
begin
  CustomSQL := ExecGetSQLCode(PmProcess.PlanScr_OnGetNotPlannedSQL, 0);
  DefaultSQL := DefaultGetNotPlannedSQL;
  Result := CombineSQL(DefaultSQL, CustomSQL, HasWhere);
  Result.IndexedView := 'EnabledMix';
end;

function TPlan.DefaultGetNotPlannedSQL: TCustomSQL;
var
  DefaultSQL: TCustomSQL;
begin
{ Не должны попадать
  - запланированные заказы
  - заказы в завершающем состоянии,
  - заказы у которых есть отметка о фактич. завершении }

  DefaultSQL.Select := 'opi.OrderID, opi.CustomerName, opi.JobID,'#13#10 +
    ' opi.Part, opi.EquipCode, opi.Comment, opi.ID_Number, opi.ItemDesc, opi.ProductOut,'#13#10 +
    ' opi.FinishDate, opi.PlanStartDate, opi.PlanFinishDate, opi.FactStartDate, opi.FactFinishDate,'#13#10 +
    ' opi.ItemID, opi.OrderState, opi.EstimatedDuration, opi.ProcessID, opi.OwnCost + opi.ItemProfit as Cost,'#13#10 +
    ' opi.SideCount, opi.Multiplier, opi.JobComment, opi.JobAlert, opi.KindID, opi.CreatorName,'#13#10 +
    ' ' + GetHasTechNotesExpr('opi.OrderID') + #13#10;
  {DefaultSQL.Select := 'opi.OrderID, cc.Name as CustomerName, j.JobID,'#13#10 +
    ' opi.Part, j.EquipCode, wo.Comment, wo.ID_Number, opi.ItemDesc, opi.ProductOut,'#13#10 +
    ' wo.FinishDate, j.PlanStartDate, j.PlanFinishDate, j.FactStartDate, j.FactFinishDate,'#13#10 +
    ' opi.ItemID, wo.OrderState, opi.EstimatedDuration, opi.ProcessID, opi.OwnCost + opi.ItemProfit as Cost,'#13#10 +
    ' opi.SideCount, opi.Multiplier, j.JobComment, j.JobAlert,'#13#10 +
    ' ' + GetHasTechNotesExpr + #13#10;
  DefaultSQL.From :=
    ' inner join WorkOrder wo on wo.N = opi.OrderID'#13#10 +
    ' inner join Job j on j.ItemID = opi.ItemID'#13#10 +
    ' inner join Customer cc on cc.N = wo.Customer'#13#10 +
    ' inner join Services ss on ss.SrvID = opi.ProcessID'#13#10 +
    ' left join Dic_OrderState dos on wo.OrderState = dos.Code'#13#10 +
    ' left join Dic_Equip deq on deq.Code = j.EquipCode';}
  DefaultSQL.From :=
    ' left join Dic_OrderState dos on opi.OrderState = dos.Code'#13#10 +
    ' left join Dic_Equip deq on deq.Code = opi.EquipCode';
  DefaultSQL.Where :=
    {' (((ss.DefaultEquipGroupCode = ' + IntToStr(EquipGroupCode) + ' and (j.EquipCode is null or j.EquipCode = 0))' +
    #13#10 +
    '  or (j.EquipCode is not null and j.EquipCode in (select Code from Dic_Equip where A1 = ' + IntToStr(EquipGroupCode) + ')))' +
    #13#10 +
    '  and j.PlanFinishDate is null and j.FactFinishDate is null' +
    #13#10 +
    '  and opi.Enabled = 1 and wo.IsDraft = 0 and wo.IsDeleted = 0 and dos.A7 <> 1 and (deq.A2 <> 1 or deq.A2 is null))';}
    ' (((opi.DefaultEquipGroupCode = ' + IntToStr(EquipGroupCode) + ' and (opi.EquipCode is null or opi.EquipCode = 0))' +
    #13#10 +
    '  or (opi.EquipCode is not null and opi.EquipCode in (select Code from Dic_Equip where A1 = ' + IntToStr(EquipGroupCode) + ')))' +
    #13#10 +
    '  and opi.PlanFinishDate is null and opi.FactFinishDate is null' +
    #13#10 +
    '  and dos.A7 <> 1 and (deq.A2 <> 1 or deq.A2 is null))';
    // deq.A2 <> 1 проверяет исключение из плана для этого оборудования
  Result := DefaultSQL;
end;

procedure ConvertDateTime(DateField: TField; _Date, _Time: variant);
var
  dt: TDateTime;
begin
  if not VarIsNull(_Date) then
  begin
    dt := _Date;
    // время 12:00:33:333 означает, что поле пустое (при непустой дате)
    if VarIsNull(_Time) then _Time := EncodeTime(0, 0, 33, 333);
    ReplaceTime(dt, _Time);
    DateField.DataSet.Edit;
    DateField.Value := dt;
  end
  else
  if not DateField.IsNull then begin
    DateField.DataSet.Edit;
    DateField.Value := null;
  end;
end;

procedure TPlan.DoBeforeApplyUpdates;
begin
{    DataSet.DisableControls;
    DataSet.First;
    while not DataSet.eof do
    begin
      if IsRecordChanged(DataSet) then
      begin
        ConvertDateTime(DataSet.FieldByName('PlanStartDate'), DataSet['PlanStartDate_ICalc'], DataSet['PlanStartTime_ICalc']);
        ConvertDateTime(DataSet.FieldByName('PlanFinishDate'), DataSet['PlanFinishDate_ICalc'], DataSet['PlanFinishTime_ICalc']);
      end;
      DataSet.Next;
    end;
    DataSet.CheckBrowseMode;
    DataSet.EnableControls;}
end;

function TPlan.CalcEstimatedDuration(EquipCode: Integer): Integer;
var
  DurCode: TEstimateDurationCode;
  FProcess: TPolyProcessCfg;
begin
  //Result := NvlInteger(DataSet['EstimatedDuration']);
  FProcess := TConfigManager.Instance.ServiceByID(ProcessID);
  DurCode := TEstimateDurationCode.Create(DataSet, FProcess, PlanScr_OnEstimateDuration);
  try
    DurCode.OnScriptError := FOnScriptError;
    DurCode.EquipCode := EquipCode;
    DurCode.ExecCode;
    Result := DurCode.Duration;
  finally
    DurCode.Free;
  end;
end;

{function TPlan.GetOrderID: Integer;
begin
  Result := DataSet['OrderID'];
end;}

function TPlan.GetEquipCode: variant;
begin
  Result := DataSet['EquipCode'];
end;

procedure TPlan.SetEquipCode(_EquipCode: Variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['EquipCode'] := _EquipCode;
end;

function TPlan.GetKindID: variant;
begin
  Result := DataSet['KindID'];
end;

function TPlan.GetCreatorName: string;
begin
  Result := VarToStr(DataSet[TOrder.F_CreatorName]);
end;

function TPlan.GetHasTechNotes: boolean;
begin
  Result := NvlBoolean(DataSet[F_HasTechNotes]);
end;

function TPlan.GetHasComment: boolean;
begin
  Result := NvlBoolean(DataSet[F_HasComment]);
end;

function TPlan.GetJobComment: variant;
begin
  Result := DataSet['JobComment'];
end;

{$ENDREGION}

{$REGION 'TWorkload - загрузка машины'}

constructor TWorkload.Create(_EquipCode: integer);
var
  _DataSource: TDataSource;
  _DataSet: TDataSet;
  _EquipGroupCode: integer;
  _Provider: TDataSetProvider;
begin
  if PlanDM = nil then
    Application.CreateForm(TPlanDM, PlanDM);

  _DataSource := CreateQueryExDM(PlanDM, PlanDM, 'Plan_' + IntToStr(_EquipCode),//_Process.TableName,
    [{poAllowMultiRecordUpdates, poDisableInserts, poDisableDeletes, poDisableEdits}],
    upWhereKeyOnly, true {ResolveToDataSet}, Database.Connection, _Provider);
  _DataSet := _DataSource.DataSet;

  // Вычисляем группу оборудования по коду оборудования
  _EquipGroupCode := TConfigManager.Instance.StandardDics.deEquip.ItemValue[_EquipCode, 1];

  inherited Create('DayPlan_' + IntToStr(_EquipCode){_Process.TableName},
    'JobID', _DataSet, _EquipGroupCode, {RequireEquipDic=} true);

  //FDataSource.Free;  // меняем на свой
  FDataSource := _DataSource;
  DataSetProvider := _Provider;

  FEquipCode := _EquipCode;
  RefreshAfterApply := true;
  FCalcFieldsScriptOK := true;  // иначе не будет работать calcfields

  // создаем списки сотрудников для оборудования
  FEquipEmployees := TEquipEmployees.Create(_EquipCode);
  // создаем списки помошников для оборудования
  FEquipAssistants := TEquipAssistants.Create(_EquipCode);


  GetDayStartTime;
end;

destructor TWorkload.Destroy;
begin
  //FShiftEmployees.Free; не удаляем, т.к. это общее для нескольких машин
  FEquipEmployees.Free;
  FEquipAssistants.Free;
  inherited Destroy;
end;

procedure TWorkload.MyDateGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then Text := ''
  else Text := DateToStr(Sender.AsDateTime);
end;

procedure TWorkload.MyTimeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then Text := ''
  else Text := ExtractTimeStr(Sender.AsDateTime);
end;

procedure TWorkload.CreateDataSet;
var
  i: integer;
  f: TField;
begin
  if FDataSetCreated then Exit;

  FSQL := GetWorkloadSQL(FHasWhere);

  //SetDataSet(FDataSource.DataSet);
  DefaultCreateDataSet;
  ExecCode(PlanScr_OnCreateDayPlan);
  FDataSetCreated := true;

  for i := 0 to DataSet.FieldCount - 1 do
  begin
    f := DataSet.Fields[i];
    if (f.DataType = ftDateTime) and (f.FieldKind = fkInternalCalc) and
       (TDateTimeField(f).DisplayFormat <> '') then
    begin
      if (TDateTimeField(f).DisplayFormat[1] = 'd') then
        f.OnGetText := MyDateGetText
      else
      if (TDateTimeField(f).DisplayFormat[1] = 'h') then
        f.OnGetText := MyTimeGetText;
    end;
  end;

  DataSet.AutoCalcFields := false;
end;

procedure TWorkload.DefaultCreateDataSet;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'OrderID';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  //f.Origin := 'sp.N';  // Это надо для корректной выборки

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_ItemID;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'JobID';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_OrderNumber;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ReadOnly := true;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_OrderState;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ReadOnly := true;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'CustomerName';
  f.Size := TContragents.CustNameSize;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ReadOnly := true;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'Comment';
  f.DataSet := DataSet;
  f.Size := 128;
  f.Name := DataSet.Name + f.FieldName;
  //f.ReadOnly := true;
  //f.OnGetText := WorkloadCommentGetText;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'ItemDesc';
  f.DataSet := DataSet;
  f.Size := 150;
  f.Name := DataSet.Name + f.FieldName;
  f.ReadOnly := true;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'EquipCode';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_Part;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_PlanStart;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm';//'dd.mm.yyyy';

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_PlanFinish;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm';//'dd.mm.yyyy';

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_FactStart;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm';

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_FactFinish;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm';

  // дата желаемой сдачи заказа
  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'FinishDate';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm';//'dd.mm.yyyy';

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'EstimatedDuration';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := 'IsPaused';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_Executor;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_FactProductOut;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'ProcessID';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_ProductOut;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'ProductIn';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_ItemProductOut;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_ItemDuration;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_ItemCost;
  TBCDField(f).Size := 2;
  TBCDField(f).Precision := 18;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'JobType';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'JobComment';
  f.Size := TPlan.JobCommentSize;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := TPlan.F_JobAlert;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'SplitPart1';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'SplitPart2';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'SplitPart3';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'SplitMode1';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'SplitMode2';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'SplitMode3';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TFloatField.Create(DataSet.Owner);
  f.FieldName := 'Multiplier';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'SideCount';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := 'TimeLocked';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := 'AutoSplit';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := 'HasTechNotes';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'JobColor';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_KindID;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_CreatorName;
  f.Size := TOrder.CreatorNameSize;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  {f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'SplitCount1';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'SplitCount2';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'SplitCount3';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;}

  // Теперь вычисляемые поля

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := F_AnyStart;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm';
  f.FieldKind := fkInternalCalc;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := F_AnyFinish;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm';
  f.FieldKind := fkInternalCalc;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'ExecState';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.FieldKind := fkInternalCalc;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_PartName;
  f.FieldKind := fkInternalCalc;
  f.Size := 50;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_PlanDuration;
  f.FieldKind := fkInternalCalc;
  f.Size := 10;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_FactDuration;
  f.FieldKind := fkInternalCalc;
  f.Size := 10;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_AnyDuration;
  f.FieldKind := fkInternalCalc;
  f.Size := 10;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := TPlan.F_HasComment;
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_JobCost;
  f.FieldKind := fkInternalCalc;
  TBCDField(f).Size := 2;
  TBCDField(f).Precision := 18;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  {f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'PlanStartDate_ICalc';
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.DisplayFormat := 'dd.mm.yyyy';
  //f.OnGetText := MyDateGetText;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'PlanFinishDate_ICalc';
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.DisplayFormat := 'dd.mm.yyyy';
  //f.OnGetText := MyDateGetText;}

  {f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'PlanStartTime_ICalc';
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'hh:nn';
  //f.OnGetText := MyTimeGetText;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'PlanFinishTime_ICalc';
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'hh:nn';
  //f.OnGetText := MyTimeGetText;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := 'DateTimeDecomposed';
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;}
end;

{procedure TWorkload.WorkloadCommentGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
end;}

function TWorkload.GetWorkloadSQL(var HasWhere: boolean): TQueryObject;
var
  CustomSQL, DefaultSQL: TCustomSQL;
begin
  ScheduleCodeContext.JobEntity := Self;
  CustomSQL := ExecGetSQLCode(PmProcess.PlanScr_OnGetDayPlanSQL, FEquipCode);
  DefaultSQL := DefaultGetWorkloadSQL;
  Result := CombineSQL(DefaultSQL, CustomSQL, HasWhere);
end;

function TWorkload.DefaultGetWorkloadSQL: TCustomSQL;
begin
  Result.Select := 'opi.OrderID, cc.Name as CustomerName, opi.Part, j.JobType, opi.Multiplier, opi.SideCount,'#13#10 +
    '(case when JobType = 0 then opi.ItemDesc else (case when j.JobComment is null then dsj.Name else j.JobComment end) end) as ItemDesc,'#13#10 +
    '(case when JobType = 0 then wo.Comment else (case when j.JobComment is null then dsj.Name else j.JobComment end) end) as Comment,'#13#10 +
    //' (case when JobType = 0 then opi.ItemDesc else (select Name from Dic_SpecialJob where Code = JobType) end) as ItemDesc,' +
    //' (case when JobType = 0 then wo.Comment else (select Name from Dic_SpecialJob where Code = JobType) end) as Comment,' +
    'opi.ProductOut as ItemProductOut,'#13#10 +
    '(select sum(DATEDIFF(minute, ISNULL(jsum.FactStartDate, jsum.PlanStartDate), ISNULL(jsum.FactFinishDate, jsum.PlanFinishDate))) from Job jsum where jsum.ItemID = opi.ItemID) as ItemDuration,'#13#10 +
    GetSplitCountExpr('opi.ProductOut', TOrderProcessItems.F_ProductOut, TOrderProcessItems.F_FactProductOut, 'j', true) + ','#13#10 +
    GetSplitCountExpr('opi.ProductIn', 'ProductIn', '', 'j', false) + ','#13#10 +
    //' (case when SplitMode is null or SplitMode <> 0 then j.ProductOut ' +
    //' else cast(round(j.ProductOut * (datediff(second, j.PlanStartDate, j.PlanFinishDate) * 1.0 / (select sum(datediff(second, j2.PlanStartDate, j2.PlanFinishDate)) from Job j2 where j2.ItemID = j.ItemID)), 0) as int) end) as ProductOut, ' +
    #13#10 +
    ' j.EquipCode, j.PlanStartDate, j.PlanFinishDate, j.FactStartDate, j.FactFinishDate, j.TimeLocked,'#13#10 +
    ' wo.OrderState, wo.ID_Number, opi.ItemID, wo.FinishDate, opi.EstimatedDuration, j.IsPaused,'#13#10 +
    ' j.Executor, j.FactProductOut, opi.ProcessID, j.JobID, j.JobComment, j.JobAlert, opi.AutoSplit,'#13#10 +
    ' j.SplitPart1, j.SplitPart2, j.SplitPart3, opi.SplitMode1, opi.SplitMode2, opi.SplitMode3,'#13#10 +
    ' j.JobColor, wo.KindID, wo.CreatorName,'#13#10 +
    ' ' + GetHasTechNotesExpr('wo.N') + ','#13#10;
  //Result.Select := Result.Select + 'cast(0 as decimal(18, 2)) as Cost'#13#10;
  if EntSettings.NativeCurrency then
    Result.Select := Result.Select + 'opi.OwnCost + opi.ItemProfit as ItemCost'#13#10
  else
    Result.Select := Result.Select + 'cast((opi.OwnCost + opi.ItemProfit) * wo.Course as decimal(18,2)) as ItemCost'#13#10;
    //' dbo.SplitCost(opi.SplitMode1, opi.SplitMode2, opi.SplitMode3, opi.OwnCost + opi.ItemProfit, COALESCE(j.FactStartDate, j.PlanStartDate), COALESCE(j.FactFinishDate, j.PlanFinishDate),' +
    //    ' (select sum(datediff(second, COALESCE(j3.FactStartDate, j3.PlanStartDate), COALESCE(j3.FactFinishDate, j3.PlanFinishDate))) from Job j3 where j3.ItemID = j.ItemID)) as Cost';
  {Result.Select := Result.Select
    + ',(select count(*) from Job jcount where jcount.ItemID = j.ItemID and SplitMode1 is not null) as SplitCount1'
    + ',(select count(*) from Job jcount where jcount.ItemID = j.ItemID and SplitMode2 is not null and SplitPart1 = j.SplitPart1) as SplitCount2'
    + ',(select count(*) from Job jcount where jcount.ItemID = j.ItemID and SplitMode3 is not null and SplitPart1 = j.SplitPart1 and SplitPart2 = j.SplitPart2) as SplitCount3';}
  Result.From :=
    ' inner join WorkOrder wo on wo.N = opi.OrderID'#13#10 +
    ' inner join Customer cc on cc.N = wo.Customer'#13#10 +
    ' right join Job j on j.ItemID = opi.ItemID'#13#10 +
    ' left join Dic_SpecialJob dsj on dsj.Code = JobType';
    //' inner join Services ss on ss.SrvID = opi.ProcessID' +
  Result.Where :=
    ' j.EquipCode = ' + IntToStr(EquipCode) +
    #13#10 +
    ' and ((opi.Enabled = 1 and wo.IsDraft = 0 and wo.IsDeleted = 0) or JobType <> 0)';
end;

procedure TWorkload.DoOnCalcFields;
var
  DataSetCode: TPlanCalcFieldsCode;
  FProcess: TPolyProcessCfg;
begin
  if DataSet.State = dsInternalCalc then
  begin
    DefaultCalcFields;
    if FCalcFieldsScriptOK then
    begin
      //ExecCode(PlanScr_OnNotPlannedCalcFields);
      // Ищем процесс у которого есть сценарий вычисляения полей
      if FindScript(FProcess, PlanScr_OnNotPlannedCalcFields) then
      begin
        ScheduleCodeContext.JobEntity := Self;
        DataSetCode := TPlanCalcFieldsCode.Create(DataSet, FProcess, PlanScr_OnNotPlannedCalcFields);
        try
          DataSetCode.OnScriptError := FOnScriptError;
          DataSetCode.DataSet := DataSet;
          DataSetCode.DayMode := true;
          DataSetCode.NoPlanMode := false;
          //DataSetCode.ExposeDataSet := true;
          FCalcFieldsScriptOK := DataSetCode.ExecCode;
        finally
          DataSetCode.Free;
        end;
      end
      else
        FCalcFieldsScriptOK := false;
    end;
  end;
end;

procedure TWorkload.DefaultCalcFields;
var
  //PartName: string;
  AnyDur: string;
  po: integer;
begin
  //if DataSet.State = dsInternalCalc then
  //begin
    DataSet[F_PartName] := PlanUtils.GetPartName(Part, SplitMode1, SplitMode2, SplitMode3,
      SplitPart1, SplitPart2, SplitPart3, true);

    if not IsShiftMarker then
    begin
      // Состояние выполнения
      DataSet[TOrderProcessItems.F_ExecState] := PlanUtils.CalcExecState(DataSet);

      //TLogger.GetInstance.Info('PlanStart = ' + DateTimeToStr(DataSet[F_PlanStart]));
      //TLogger.GetInstance.Info('PlanFinish = ' + DateTimeToStr(DataSet[F_PlanFinish]));
      //TLogger.GetInstance.Info('PlanDuration = ' + IntToStr(SecondsBetween(DataSet[F_PlanStart], DataSet[F_PlanFinish])));
      if not VarIsNull(DataSet[TOrderProcessItems.F_PlanStart]) and not VarIsNull(DataSet[TOrderProcessItems.F_PlanFinish]) then
      begin
        AnyDur := PlanUtils.FormatTimeValue(PlanUtils.RoundMinutesBetween(DataSet[TOrderProcessItems.F_PlanStart], DataSet[TOrderProcessItems.F_PlanFinish]));
      end else
        AnyDur := ''; // вообще-то не должно быть тут таких записей, но мало ли...
      DataSet[TOrderProcessItems.F_PlanDuration] := AnyDur;

      if not VarIsNull(DataSet[TOrderProcessItems.F_FactStart]) and not VarIsNull(DataSet[TOrderProcessItems.F_FactFinish]) then
      begin
        try
          AnyDur := PlanUtils.FormatTimeValue(PlanUtils.RoundMinutesBetween(DataSet[TOrderProcessItems.F_FactStart], DataSet[TOrderProcessItems.F_FactFinish]));
        except on E: ERangeError do
          AnyDur := '0:00';
        end;
        DataSet[TOrderProcessItems.F_FactDuration] := AnyDur;
      end
      else
      begin
        DataSet[TOrderProcessItems.F_FactDuration] := '';
      end;

      DataSet[F_AnyDuration] := AnyDur;

      DataSet[F_AnyStart] := AnyStartDateTime;
      DataSet[F_AnyFinish] := AnyFinishDateTime;

      // Стоимость с поправкой на количество
      {if ItemProductOut > 0 then
      begin
        if not VarIsNull(FactProductOut) then
          po := FactProductOut
        else
          po := ProductOut;
        if po > ItemProductOut then
          po := ItemProductOut;
        DataSet[F_JobCost] := DataSet[F_ItemCost] * (po * 1.0 / ItemProductOut);
      end
      else
        DataSet[F_JobCost] := 0;}
      if ItemDuration > 0 then
      begin
        po := MinutesBetween(DataSet[F_AnyStart], DataSet[F_AnyFinish]);
        if po > ItemDuration then
          po := ItemDuration;
        DataSet[F_JobCost] := DataSet[F_ItemCost] * (po * 1.0 / ItemDuration);
      end
      else
        DataSet[F_JobCost] := 0;
    end
    else
    begin
      // Для смены берем по плановой, т.к. она сдвинута на 1 сек назад для
      // правильного упорядочения. 
      DataSet[F_AnyStart] := DataSet[TOrderProcessItems.F_PlanStart];
      DataSet[F_AnyFinish] := DataSet[TOrderProcessItems.F_PlanFinish];
    end;

  //end;
  DataSet[TPlan.F_HasComment] := (NvlString(DataSet['JobComment']) <> ''){ or HasTechNotes};
end;

function TWorkload.PlanChanged: boolean;
begin
{  if not FDataSetCreated then CreateDataSet;

  if DataSet.Active then
  begin
    DataSet.CheckBrowseMode;
    Result := DataChanged;
    if not Result then
    begin
      DataSet.DisableControls;
      try
        DataSet.First;
        while not DataSet.eof and not Result do
        begin
          Result := IsRecordChanged(DataSet);
          DataSet.Next;
        end;
      finally
        DataSet.EnableControls;
      end;
    end;
  end
  else}
    Result := false;
end;

function TWorkload.GetSQL: TQueryObject;

//procedure TWorkload.OpenWorkload(WorkDate: TDateTime; _Range: integer;
    //NeedRefresh: boolean);
var
  //hw: boolean;
  FilterExpr: string;
  //ds: TDataSource;
  //SF: TField;
  //StateField: string;
  //_Year, Month, Day: word;
  //CheckedCount, k, CheckedCode: integer;
  _DayStart, _NextDayStart: TDateTime;

  // Выбираем по плановой дате если фактическая не установлена, или по фактической
  function GetDateFilter(fPlan, fFact: string): string;
  begin
    Result := '(' + fPlan + ' between ' + FormatSQLDateTime(_DayStart) + ' and ' + FormatSQLDateTime(_NextDayStart) + ')'
      + ' and ' + fFact + ' is null ' + ' or '
      + '(' + fFact + ' between ' + FormatSQLDateTime(_DayStart) + ' and ' + FormatSQLDateTime(_NextDayStart) + ')';
  end;

begin
  //hw := FHasWhere;

  _DayStart := RangeStart;
  _NextDayStart := IncMinute(RangeEnd, -1);

  TLogger.getInstance.Debug('Open workload for ' + IntToStr(Self.FEquipCode)
     + ', DayStart = ' + DateTimeToStr(_DayStart) + ' NextDayStart = ' + DateTimeToStr(_NextDayStart));

  //DecodeDate(WorkDate, _Year, Month, Day);
  // Проверка на попадание даты начала или конца в диапазон или покрытие диапазона
  // Если есть фактическая дата, то учитывается вместо плановой
  FilterExpr := '(' + GetDateFilter(fnPlanStartDate, fnFactStartDate)
    + ' or ' + GetDateFilter(fnPlanFinishDate, fnFactFinishDate)
    + ' or ((' + fnPlanStartDate + ' < ' + FormatSQLDateTime(_DayStart)
         + ' and ' + fnFactStartDate  + ' is null or ' + fnFactStartDate + ' < ' + FormatSQLDateTime(_DayStart) + ')'
      + ' and (' + fnPlanFinishDate + ' > ' + FormatSQLDateTime(_NextDayStart)
         + ' and ' + fnFactFinishDate  + ' is null or ' + fnFactFinishDate + ' > ' + FormatSQLDateTime(_NextDayStart) + ')'
    + '))';
  Result := FSQL;
  if Result.Where <> '' then FilterExpr := 'and ' + FilterExpr;
  Result.Where := Result.Where + ' ' + FilterExpr;
end;

procedure TWorkload.DoBeforeApplyUpdates;
begin
{    DataSet.DisableControls;
    DataSet.First;
    while not DataSet.eof do
    begin
      if IsRecordChanged(DataSet) then
      begin
        ConvertDateTime(DataSet.FieldByName('PlanStartDate'), DataSet['PlanStartDate'], DataSet['PlanStartTime_ICalc']);
        ConvertDateTime(DataSet.FieldByName('PlanFinishDate'), DataSet['PlanFinishDate'], DataSet['PlanFinishTime_ICalc']);
      end;
      DataSet.Next;
    end;
    DataSet.CheckBrowseMode;
    DataSet.EnableControls;}
end;

procedure TWorkload.DoBeforeOpen;
begin
  if not FDataSetCreated then
    CreateDataSet;
  QueryObject := GetSQL;
  SetQuerySQL(DataSource, QueryObject.GetSQL);
end;

procedure TWorkload.InsertShiftMarkers;
var
  CurDate, ShiftStart, CurShiftStart, {LastShiftStart, }ShiftEnd, CurShiftEnd: TDateTime;
  ShiftCount: integer;
  I, ShiftNum, ShiftID: Integer;
  si: TShiftInfo;
  k: variant;
begin
  //LastShiftStart := 0;
  FreeShiftList;
  CreateShiftList;
  // уже отсортировано по времени
  DataSet.DisableControls;
  FCalcFieldsScriptOK := false;
  k := KeyValue;
  try
    ShiftCount := GetShiftCount;   // кол-во смен в сутках
    CurDate := RangeStart;
    ShiftNum := 1;
    while CurDate < RangeEnd do
    begin
      for I := 1 to ShiftCount do
      begin
        ShiftStart := GetShiftStartTime(I);
        ShiftID := GetShiftID(I);
        CurShiftStart := CurDate;
        ReplaceTime(CurShiftStart, ShiftStart);
        DataSet.Append;
        SetShiftMarker;
        DataSet[KeyField] := -ShiftNum;
        // сдвигаем на секунду назад чтобы упорядочение было правильным
        SetPlanStartDateTime(IncSecond(CurShiftStart, -1));
        SetPlanFinishDateTime(CurShiftStart);
        SetFactStartDateTime(CurShiftStart);
        SetFactFinishDateTime(CurShiftStart);
        SetComment(DateToStr(CurShiftStart) + '  ' + IntToStr(I) + ' cмена');
        // определяем конец смены
        if I < ShiftCount then
        begin
          ShiftEnd := GetShiftStartTime(I + 1);
          CurShiftEnd := CurDate;
        end
        else
        begin
          ShiftEnd := GetShiftStartTime(1);
          CurShiftEnd := IncDay(CurDate, 1);
        end;
        ReplaceTime(CurShiftEnd, ShiftEnd);
        // регистрируем смену в списке смен
        si := TShiftInfo.Create(CurShiftStart, CurShiftEnd, ShiftNum, ShiftID);
        si.ShiftEmployeeID := NvlInteger(FShiftEmployees.GetEmployee(CurShiftStart));
        si.EquipAssistantID := NvlInteger(FEquipAssistants.GetEmployee(CurShiftStart));

        Inc(ShiftNum);
        FShiftList.Add(si);
      end;
      CurDate := IncDay(CurDate, 1);
    end;
    DataSet.CheckBrowseMode;
  finally
    FCalcFieldsScriptOK := true;
    Locate(k);
    DataSet.EnableControls;
  end;
end;

procedure TWorkload.CreateShiftList;
begin
  FShiftList := TShiftList.Create;
end;

procedure TWorkload.FreeShiftList;
var
  I: integer;
begin
  if FShiftList <> nil then
  begin
    for I := 0 to FShiftList.Count - 1 do
    begin
      TObject(FShiftList[I]).Free;
    end;
    FreeAndNil(FShiftList);
  end;
end;

procedure TWorkload.DoAfterOpen;
var
  ds: TClientDataSet;
  NewCriteria: TShiftEmployeeCriteria;
begin
  // Поля, по которым можно сортировать - ПЕРЕДЕЛАНО. ТОЛЬКО ПО ВРЕМЕНИ СОРТИРОВКА.
  ds := TClientDataSet(DataSet);
  //ds.AddIndex('iExecState', 'ExecState', []);
  //ds.AddIndex('iID_Number', 'ID_Number', []);
  //ds.AddIndex('iCustomerName', 'CustomerName', [ixCaseInsensitive]);
  ds.AddIndex('iStartDate', F_AnyStart, []);
  ds.AddIndex('iFinishDate', F_AnyFinish, []);
  //ds.AddIndex('iComment', 'Comment', [ixCaseInsensitive]);
  //ds.AddIndex('iPartName', F_PartName, [ixCaseInsensitive]);
  ds.IndexDefs.Update;
  ds.IndexFieldNames := F_AnyStart;

  // строим список объектов
  if FJobList <> nil then
  begin
    FJobList.FreeJobs;
    FJobList.Free;
  end;
  FJobList := BuildJobList;

  if (Criteria.RangeType = PlanRange_Continuous)
    or (Criteria.RangeType = PlanRange_Week) then
  begin
    // открываем списки сотрудников для смен
    NewCriteria.StartTime := RangeStart;
    NewCriteria.FinishTime := RangeEnd;
    FShiftEmployees.Criteria := NewCriteria;
    FShiftEmployees.Reload;
    FShiftAssistants.Criteria := NewCriteria;
    FShiftAssistants.Reload;
    FEquipEmployees.Criteria := NewCriteria;
    FEquipEmployees.Reload;
    FEquipAssistants.Criteria := NewCriteria;
    FEquipAssistants.Reload;

    // добавляем строки с информацией о сменах
    InsertShiftMarkers;
    // Строим список работ по сменам
    BuildShiftJobLists;
    CalcShiftCost;
    //ds.IndexName := '';
    //ds.IndexName := 'iStartDate';
  end;
end;

function TWorkload.GetEquipName: string;
begin
  Result := TConfigManager.Instance.StandardDics.deEquip.ItemName[FEquipCode];
end;

function TWorkload.GetPlanFinishDateTime: Variant;
begin
  Result := DataSet[TOrderProcessItems.F_PlanFinish];
  //ReplaceTime(Result, DataSet['PlanFinishTime_ICalc']);
end;

procedure TWorkload.SetPlanFinishDateTime(_Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;

  DataSet[TOrderProcessItems.F_PlanFinish] := _Value;
end;

function TWorkload.GetPlanStartDateTime: Variant;
begin
  Result := DataSet[TOrderProcessItems.F_PlanStart];
  //ReplaceTime(Result, DataSet['PlanStartTime_ICalc']);
end;

procedure TWorkload.SetPlanStartDateTime(_Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;

  DataSet[TOrderProcessItems.F_PlanStart] := _Value;
end;

function TWorkload.GetAnyFinishDateTime: TDateTime;
begin
  if VarIsNull(FactFinishDateTime) then
    Result := PlanFinishDateTime
  else
    Result := FactFinishDateTime;
end;

function TWorkload.GetAnyStartDateTime: TDateTime;
begin
  if VarIsNull(FactStartDateTime) then
    Result := PlanStartDateTime
  else
    Result := FactStartDateTime;
end;

procedure TWorkload.SetJobComment(_Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;

  DataSet['JobComment'] := _Value;
end;

procedure TWorkload.SetJobAlert(_Value: boolean);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;

  DataSet[TPlan.F_JobAlert] := _Value;
end;

procedure TWorkload.SetJobType(_Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;

  DataSet['JobType'] := _Value;
end;

function TWorkload.GetCustomerName: string;
begin
  Result := VarToStr(DataSet['CustomerName']);
end;

function TWorkload.GetCreatorName: string;
begin
  Result := VarToStr(DataSet[TOrder.F_CreatorName]);
end;

function TWorkload.GetDayStart: TDateTime;
var
  ShiftStart: TDateTime;
begin
  Result := FCriteria.Date;
  if FCriteria.RangeType >= PlanRange_FirstShift then
    ReplaceTime(Result, GetShiftStartTime(FCriteria.RangeType - PlanRange_FirstShift + 1))
  else
  if FCriteria.RangeType = PlanRange_Continuous then
  begin
    // ищем начало смены, которая была ContinuousRange дней назад
    Result := IncDay(Result, -CONTINUOUS_RANGE);
    ShiftStart := GetShiftStartTime(1);  // 1-я смена
    ReplaceTime(Result, ShiftStart);
  end
  else if Criteria.RangeType = PlanRange_Week then
  begin
    // ищем начало смены, которая была WEEK_RANGE день назад
    Result := IncDay(Result, -WEEK_RANGE_BACKWARD);
    ShiftStart := GetShiftStartTime(1);  // 1-я смена
    ReplaceTime(Result, ShiftStart);
  end
  else
    ReplaceTime(Result, FDayStartTime);
end;

procedure TWorkload.GetDayStartTime;
begin
  if FCriteria.RangeType >= PlanRange_FirstShift then
    FDayStartTime := GetShiftStartTime(FCriteria.RangeType - PlanRange_FirstShift + 1)
  else
    FDayStartTime := GetFirstShiftStartTime;
end;

function GetStartDic(de: TDictionary): TDateTime;
var
  MinCode: integer;
  ds: TDataSet;
begin
  ds := de.DicItems;
  // находим мин. код - это первая смена
  MinCode := 0;
  while not ds.eof do
  begin
    if (MinCode = 0) or (de.CurrentCode < MinCode) then
      MinCode := de.CurrentCode;
    ds.Next;
  end;
  if MinCode > 0 then
    try
      Result := StrToTime(de.ItemValue[MinCode, 2]);
    except
      Result := EncodeTime(0, 0, 0, 0);
    end
  else
    Result := EncodeTime(0, 0, 0, 0);
end;

// Ищет начало первой смены для текущей группы оборудования в справочнике
function TWorkload.GetFirstShiftStartTime: TDateTime;
var
  ds: TDataSet;
  de: TDictionary;
begin
  de := TConfigManager.Instance.StandardDics.deEquipTime;
  ds := de.DicItems;
  // Фильтруем справочник по коду оборудования
  ds.Filter := 'A1 = ' + IntToStr(EquipCode);
  ds.Filtered := true;
  try
    if ds.RecordCount > 0 then  // Если есть данные, то берем мз этого справочника
      Result := GetStartDic(de)
    else                       // иначе ищем в справочнике смен для групп
    begin
      de := TConfigManager.Instance.StandardDics.deEquipGroupTime;
      ds := de.DicItems;
      // Фильтруем справочник по коду группы
      ds.Filter := 'A1 = ' + IntToStr(EquipGroupCode);
      ds.Filtered := true;
      try
        if ds.RecordCount > 0 then
          Result := GetStartDic(de);
      finally
        ds.Filtered := false;
      end;
    end;
  finally
    ds.Filtered := false;
  end;
end;

// Возвращает начало указанной смены для текущей группы оборудования в справочнике
function TWorkload.GetShiftStartTime(ShiftNum: integer): TDateTime;
var
  ShiftCount, ID: integer;
begin
  Result := GetShiftFieldValue(ShiftNum, 2, ShiftCount, ID);
end;

// Возвращает окончание указанной смены для текущей группы оборудования в справочнике
function TWorkload.GetShiftFinishTime(ShiftNum: integer): TDateTime;
var
  ShiftCount, ID: integer;
begin
  Result := GetShiftFieldValue(ShiftNum, 3, ShiftCount, ID);
end;

// Возвращает ключ смены для текущей группы оборудования в справочнике смен
function TWorkload.GetShiftID(ShiftNum: integer): integer;
var
  Count: integer;
begin
  GetShiftFieldValue(-1, 2, Count, Result);
end;

// вспомогательная
function GetShiftFieldValueDic(de: TDictionary; ShiftNum, FieldNum: integer; var ID: integer): TDateTime;
var
  ds: TDataSet;
  RecNum: integer;
begin
  ds := de.DicItems;
  // номер записи соотв. номеру смены, пропускаем нужное кол-во записей
  RecNum := 1;
  while not ds.eof and (RecNum < ShiftNum) do
  begin
    Inc(RecNum);
    ds.Next;
  end;
  try
    Result := StrToTime(de.CurrentValue[FieldNum]);
    ID := de.CurrentID;
  except
    Result := EncodeTime(0, 0, 0, 0);
  end;
end;

// Возвращает указанное поле для смены для текущей группы оборудования в справочнике
function TWorkload.GetShiftFieldValue(ShiftNum, FieldNum: integer; var ShiftCount, ID: integer): TDateTime;
var
  ds: TDataSet;
  de: TDictionary;
begin
  de := TConfigManager.Instance.StandardDics.deEquipTime;
  ds := de.DicItems;
  // Фильтруем справочник по коду оборудования
  ds.Filter := 'A1 = ' + IntToStr(EquipCode);
  ds.Filtered := true;
  try
    ShiftCount := ds.RecordCount;
    if ShiftCount > 0 then  // Еси что-то есть, то
      Result := GetShiftFieldValueDic(de, ShiftNum, FieldNum, ID)
    else
    begin
      de := TConfigManager.Instance.StandardDics.deEquipGroupTime;
      ds := de.DicItems;
      // Фильтруем справочник по коду группы
      ds.Filter := 'A1 = ' + IntToStr(EquipGroupCode);
      ds.Filtered := true;
      try
        ShiftCount := ds.RecordCount;
        if ShiftCount <> 0 then
          Result := GetShiftFieldValueDic(de, ShiftNum, FieldNum, ID)
        else
          ExceptionHandler.Raise_('Отсутствует расписание смен для оборудования '
            + TConfigManager.Instance.StandardDics.deEquip.ItemName[EquipCode]);
      finally
        ds.Filtered := false;
      end;
    end;
  finally
    ds.Filtered := false;
  end;
end;

// Возвращает количество смен для данной группы оборудования
function TWorkload.GetShiftCount: integer;
var
  ID: integer;
begin
  GetShiftFieldValue(-1, 2, Result, ID);
end;

function TWorkload.GetIsPaused: boolean;
begin
  Result := DataSet['IsPaused'];
end;

function TWorkload.GetExecutor: variant;
begin
  Result := DataSet[F_Executor];
end;

function TWorkload.GetPlanDuration: string;
begin
  Result := DataSet['PlanDuration'];
end;

function TWorkload.GetFactFinishDateTime: Variant;
begin
  Result := DataSet[TOrderProcessItems.F_FactFinish];
end;

procedure TWorkload.SetFactStartDateTime(_Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;

  DataSet[TOrderProcessItems.F_FactStart] := _Value;
end;

procedure TWorkload.SetFactFinishDateTime(_Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;

  DataSet[TOrderProcessItems.F_FactFinish] := _Value;
end;

function TWorkload.GetFactProductOut: variant;
begin
  Result := DataSet[TOrderProcessItems.F_FactProductOut];
end;

function TWorkload.GetFactStartDateTime: Variant;
begin
  Result := DataSet[TOrderProcessItems.F_FactStart];
end;

function TWorkload.GetJobComment: variant;
begin
  Result := DataSet['JobComment'];
end;

function TWorkload.GetJobAlert: boolean;
begin
  Result := NvlBoolean(DataSet[TPlan.F_JobAlert]);
end;

function TWorkload.GetHasTechNotes: boolean;
begin
  Result := NvlBoolean(DataSet[TPlan.F_HasTechNotes]);
end;

function TWorkload.GetHasComment: boolean;
begin
  Result := NvlBoolean(DataSet[TPlan.F_HasComment]);
end;

function TWorkload.GetKindID: variant;
begin
  Result := DataSet['KindID'];
end;

function TWorkload.CreateJobParams: TJobParams;
begin
  Result := TJobParams.Create;
  Result.JobID := KeyValue;
  Result.ItemID := ItemID;
  Result.EquipCode := EquipCode;
  Result.Executor := Executor;
  Result.FactFinish := FactFinishDateTime;
  Result.FactStart := FactStartDateTime;
  Result.JobComment := JobComment;
  Result.JobAlert := JobAlert;
  Result.PlanFinish := PlanFinishDateTime;
  Result.PlanStart := PlanStartDateTime;
  Result.EstimatedDuration := EstimatedDuration;
  Result.TimeLocked := TimeLocked;
  Result.JobType := JobType;
  Result.Comment := Comment;
  Result.OrderNumber := OrderNumber;
  Result.OrderState := OrderState;
  Result.CustomerName := CustomerName;
  Result.ItemDesc := ItemDesc;
  Result.SplitMode1 := SplitMode1;
  Result.SplitMode2 := SplitMode2;
  Result.SplitMode3 := SplitMode3;
  Result.SplitPart1 := SplitPart1;
  Result.SplitPart2 := SplitPart2;
  Result.SplitPart3 := SplitPart3;
  Result.AutoSplit := AutoSplit;
  Result.IsPaused := IsPaused;
  Result.ProductOut := ProductOut;
  Result.Multiplier := Multiplier;
  Result.SideCount := SideCount;
  Result.Part := Part;
  Result.PartName := PartName;
  Result.ItemProductOut := ItemProductOut;
  Result.ExecState := DataSet['ExecState'];
  Result.OrderID := OrderID;
  Result.JobColor := DataSet['JobColor'];
  Result.JobCost := DataSet[F_JobCost];
  // Только для нормальных работ
  if JobType = JobType_Work then
    Result.FactProductOut := FactProductOut;
  Result.ClearChanges;
end;

{procedure TWorkload.SetJobParams(Job: TJobParams);
begin
  //Result.JobID := KeyValue;
  //Result.ItemID := ItemID;
  //Result.EquipCode := EquipCode;
  //Result.EstimatedDuration := EstimatedDuration;
  //JobType := Job.JobType;
  //Job.OrderNumber := OrderNumber;
  //Job.OrderState := OrderState;
  //Job.CustomerName := CustomerName;
  //Job.ItemDesc := ItemDesc;
  //Job.ProductOut := ProductOut;
  //Job.Part := Part;
  //Job.PartName := PartName;
  //Job.ItemProductOut := ItemProductOut;
  //Job.ExecState := DataSet['ExecState'];
  //Job.OrderID := OrderID;
  //JobColor := Job.JobColor;
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
    
  DataSet['Executor'] := Job.Executor;
  DataSet[F_FactFinish] := Job.FactFinish;
  DataSet[F_FactStart] := Job.FactStart;
  DataSet['JobComment'] := Job.JobComment;
  DataSet['JobAlert'] := Job.JobAlert;
  DataSet[F_PlanFinish] := Job.PlanFinish;
  DataSet[F_PlanStart] := Job.PlanStart;
  DataSet['TimeLocked'] := Job.TimeLocked;
  DataSet['Comment'] := Job.Comment;
  DataSet['SplitMode1'] := Job.SplitMode1;
  DataSet['SplitMode2'] := Job.SplitMode2;
  DataSet['SplitMode3'] := Job.SplitMode3;
  DataSet['SplitPart1'] := Job.SplitPart1;
  DataSet['SplitPart2'] := Job.SplitPart2;
  DataSet['SplitPart3'] := Job.SplitPart3;
  DataSet['AutoSplit'] := Job.AutoSplit;
  DataSet['IsPaused'] := Job.IsPaused;
  DataSet['Multiplier'] := Job.Multiplier;
  DataSet['SideCount'] := Job.SideCount;
  // Только для нормальных работ
  if JobType = JobType_Work then
    DataSet[TOrderProcessItems.F_FactProductOut] := Job.FactProductOut;
end;}

function TWorkload.GetJobType: Integer;
begin
  Result := NvlInteger(DataSet['JobType']);
end;

function TWorkload.GetNextDayStart: TDateTime;
var
  ShiftStart: TDateTime;
  ShiftFinish: TDateTime;
begin
  if (FCriteria.RangeType = PlanRange_Day) or (FCriteria.RangeType = PlanRange_Gantt) then
    Result := IncDay(RangeStart, 1)
  else
  if FCriteria.RangeType = PlanRange_Continuous then
  begin
    // находим начало смены, которая будет через CONTINUOUS_RANGE дней
    Result := IncDay(Criteria.Date, CONTINUOUS_RANGE);
    ShiftStart := GetShiftStartTime(1);  // 1-я смена
    ReplaceTime(Result, ShiftStart);
  end
  else
  if FCriteria.RangeType = PlanRange_Week then
  begin
    // находим начало смены, которая будет через WEEK_RANGE дней
    Result := IncDay(Criteria.Date, WEEK_RANGE_FORWARD);
    ShiftStart := GetShiftStartTime(1);  // 1-я смена
    ReplaceTime(Result, ShiftStart);
  end
  else
  begin
    // Вычисляет окончание текущей смены
    ShiftStart := GetShiftStartTime(FCriteria.RangeType - PlanRange_FirstShift + 1);
    ShiftFinish := GetShiftFinishTime(FCriteria.RangeType - PlanRange_FirstShift + 1);
    Result := RangeStart;
    if ShiftStart < ShiftFinish then
      ReplaceTime(Result, ShiftFinish)
    else
    begin
      Result := IncDay(RangeStart, 1);
      // если время окончания меньше или = то это означает следующие сутки
      ReplaceTime(Result, ShiftFinish);
    end;
  end;
end;

{function TWorkload.GetOrderID: Variant;
begin
  Result := DataSet['OrderID'];
end;}

function TWorkload.GetTimeLocked: boolean;
begin
  Result := NvlBoolean(DataSet['TimeLocked']);
end;

function TWorkload.GetProductOut: integer;
begin
  Result := NvlInteger(DataSet[TOrderProcessItems.F_ProductOut]);
end;

function TWorkload.GetItemProductOut: integer;
begin
  Result := NvlInteger(DataSet[F_ItemProductOut]);
end;

function TWorkload.GetItemDuration: integer;
begin
  Result := NvlInteger(DataSet[F_ItemDuration]);
end;

function TWorkload.GetAutoSplit: boolean;
begin
  Result := NvlBoolean(DataSet['AutoSplit']);
end;

function TWorkload.IsShiftMarker: boolean;
begin
  Result := (DataSet.RecordCount > 0) and (JobType = JobType_ShiftMarker);
end;

procedure TWorkload.SetShiftMarker;
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;

  DataSet['JobType'] := JobType_ShiftMarker;
end;

procedure TWorkload.SetJobColor(_Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;

  DataSet['JobColor'] := _Value;
end;

function TWorkload.GetJobColor: variant;
begin
  Result := DataSet['JobColor'];
end;

procedure TWorkload.ChangeOrderState(Job: TJobParams; NewOrderState: integer);
begin
  Database.ExecuteNonQuery('exec up_ChangeOrderState ' + IntToStr(Job.OrderID)
    + ', ' + IntToStr(NewOrderState))
end;

const
  EMP_SEPARATOR = '|';

function TWorkload.GetShiftEmployeeName: variant;
var
  e: variant;
begin
  e := ShiftEmployee;
  if VarIsNull(e) then
    Result := null
  else
    Result := TConfigManager.Instance.StandardDics.deEmployees.ItemName[e];
end;

{procedure TWorkload.SetShiftEmployeeName(val: variant);
begin
  JobComment := NvlString(val) + EMP_SEPARATOR + NvlString(EquipmentEmployeeName);
end;}

function TWorkload.GetEquipmentEmployeeName: variant;
var
  e: variant;
begin
  e := EquipmentEmployee;
  if VarIsNull(e) then
    Result := null
  else
    Result := TConfigManager.Instance.StandardDics.deEmployees.ItemName[e];
end;

function TWorkload.GetEquipmentAssistantName: variant;
var
  e: variant;
begin
  e := EquipmentAssistant;
  if VarIsNull(e) then
    Result := null
  else
    Result := TConfigManager.Instance.StandardDics.deEmployees.ItemName[e];
end;


{procedure TWorkload.SetEquipmentEmployeeName(val: variant);
begin
  JobComment := NvlString(ShiftEmployeeName) + EMP_SEPARATOR + NvlString(val);
end;}

// возвращает список смен TShiftInfo
function TWorkload.ShiftList: TShiftList;
begin
  Result := FShiftList;
end;

function TWorkload.GetShiftEmployee: variant;
begin
  if IsShiftMarker then
    Result := FShiftEmployees.GetEmployee(AnyStartDateTime)
  else
    raise Exception.Create(SHIFTMARKER_EXCEPTION);
end;

function TWorkload.GetShiftAssistant: variant;
begin
  if IsShiftMarker then
    Result := FShiftAssistants.GetEmployee(AnyStartDateTime)
  else
    raise Exception.Create(SHIFTMARKER_EXCEPTION);
end;

function TWorkload.GetEquipmentEmployee: variant;
begin
  if IsShiftMarker then
    Result := FEquipEmployees.GetEmployee(AnyStartDateTime)
  else
    raise Exception.Create(SHIFTMARKER_EXCEPTION);
end;

function TWorkload.GetEquipmentAssistant: variant;
begin
  if IsShiftMarker then
    Result := FEquipAssistants.GetAssistant(AnyStartDateTime)
  else
    raise Exception.Create(SHIFTMARKER_EXCEPTION);
end;


procedure TWorkload.SetShiftEmployee(val: variant);
begin
  if IsShiftMarker then
    FShiftEmployees.SetEmployee(AnyStartDateTime, val)
  else
    raise Exception.Create(SHIFTMARKER_EXCEPTION);
end;

procedure TWorkload.SetShiftAssistant(val: variant);
begin
  if IsShiftMarker then
    FShiftAssistants.SetAssistant(AnyStartDateTime, val)
  else
    raise Exception.Create(SHIFTMARKER_EXCEPTION);
end;

procedure TWorkload.SetEquipmentEmployee(val: variant);
begin
  if IsShiftMarker then
    FEquipEmployees.SetEmployee(AnyStartDateTime, val)
  else
    raise Exception.Create(SHIFTMARKER_EXCEPTION);
end;

procedure TWorkload.SetEquipmentAssistant(val: variant);
begin
  if IsShiftMarker then
    FEquipAssistants.SetAssistant(AnyStartDateTime, val)
  else
    raise Exception.Create(SHIFTMARKER_EXCEPTION);
end;


function TWorkload.LocateShift: boolean;
var
  ds: TDataSet;
begin
  ds := DataSet;
  while not ds.Bof do
  begin
    if IsShiftMarker then
    begin
      Result := true;
      Exit;
    end;
    ds.Prior;
  end;
  Result := false;
end;

// Используется для фильтрации при построении списка работ для каждой смены
{procedure TWorkload.ShiftFilter(DataSet: TDataSet; var Accept: Boolean);
var
  AnyStartDate: TDateTime;
begin
  if (DataSet['JobType'] <> JobType_ShiftMarker) then
  begin
    if not VarIsNull(DataSet[F_FactStart]) then
      AnyStartDate := DataSet[F_FactStart]
    else
      AnyStartDate := NvlDateTime(DataSet[F_PlanStart]);
    Accept := (AnyStartDate >= FCurShiftStart);
    if Accept and (FNextShiftStart > 0) then
      Accept := Accept and (AnyStartDate < FNextShiftStart);
  end
  else
    Accept := false;
end;}

// Строит список работ для каждой смены
{procedure TWorkload.BuildJobLists;
var
  I: Integer;
  si, NextSI: TShiftInfo;
  ShiftJobList: TList;
  Job: TJobParams;
  s: string;
  k: variant;
begin
  DataSet.DisableControls;
  k := KeyValue;
  try
    FJobList.FreeJobs;
    for I := 0 to FShiftList.Count - 1 do
    begin
      SI := TShiftInfo(FShiftList[i]);
      if i < FShiftList.Count - 1 then
        NextSI := TShiftInfo(FShiftList[i + 1])
      else
        NextSI := nil;
      FCurShiftStart := SI.Start;
      if NextSI <> nil then
        FNextShiftStart := NextSI.Start
      else
        FNextShiftStart := 0;
      DataSet.OnFilterRecord := ShiftFilter;
      DataSet.Filtered := false;
      DataSet.Filtered := true;
      ShiftJobList := TJobList.Create;
      while not DataSet.eof do
      begin
        Job := CreateJobParams;
        ShiftJobList.Add(Job);  // Добавляем в список работ для смены
        FJobList.Add(Job);  // Добавляем в общий список работ
        DataSet.Next;
      end;
      FreeAndNil(SI.JobList);
      SI.JobList := ShiftJobList;
    end;
  finally
    DataSet.Filtered := false;
    DataSet.OnFilterRecord := nil;
    Locate(k);
    DataSet.EnableControls;
  end;
end;}

function TWorkload.BuildJobList: TJobList;
var
  Job: TJobParams;
  k: variant;
begin
  Result := TJobList.Create;

  DataSet.DisableControls;
  k := KeyValue;
  try
    DataSet.First;
    while not DataSet.eof do
    begin
      if not IsShiftMarker then
      begin
        Job := CreateJobParams;
        Result.Add(Job);  // Добавляем в общий список работ
      end;
      DataSet.Next;
    end;
  finally
    Locate(k);
    DataSet.EnableControls;
  end;
end;

function TWorkload.CreateShiftJobs(CurShiftStart, NextShiftStart: TDateTime): TJobList;
var
  Job: TJobParams;
  I: Integer;
  AnyStartDate: TDateTime;
  Accept: boolean;
begin
  Result := TJobList.Create;
  for I := 0 to FJobList.Count - 1 do
  begin
    Job := FJobList[I];
    if not VarIsNull(Job.FactStart) then
      AnyStartDate := Job.FactStart
    else
      AnyStartDate := NvlDateTime(Job.PlanStart);
    Accept := (AnyStartDate >= CurShiftStart);
    if Accept and (NextShiftStart > 0) then
      Accept := Accept and (AnyStartDate < NextShiftStart);
    if Accept then
      Result.Add(Job);
  end;
end;

// Строит список работ для каждой смены
procedure TWorkload.BuildShiftJobLists;
var
  I: Integer;
  si, NextSI: TShiftInfo;
  ShiftJobList: TJobList;
  CurShiftStart, NextShiftStart: TDateTime;
begin
  for I := 0 to FShiftList.Count - 1 do
  begin
    SI := TShiftInfo(FShiftList[i]);
    if i < FShiftList.Count - 1 then
      NextSI := TShiftInfo(FShiftList[i + 1])
    else
      NextSI := nil;
    CurShiftStart := SI.Start;
    if NextSI <> nil then
      NextShiftStart := NextSI.Start
    else
      NextShiftStart := 0;
    ShiftJobList := CreateShiftJobs(CurShiftStart, NextShiftStart);
    FreeAndNil(SI.JobList);
    SI.JobList := ShiftJobList;
  end;
end;

procedure TWorkload.CalcShiftCost;
var
  I, j: integer;
  si: TShiftInfo;
begin
  for I := 0 to FShiftList.Count - 1 do
  begin
    SI := TShiftInfo(FShiftList[i]);
    SI.Cost := 0;
    for J := 0 to SI.JobList.Count - 1 do
    begin
      SI.Cost := SI.Cost + SI.JobList[J].JobCost;
    end;
  end;
end;

function CompareJobs(Item1, Item2: Pointer): Integer;
begin
  if TJobParams(Item1).AnyStart < TJobParams(Item2).AnyStart then
    Result := -1
  else if TJobParams(Item1).AnyStart > TJobParams(Item2).AnyStart then
    Result := 1
  else
    Result := 0;
end;

procedure TWorkload.SortJobs;
begin
  FJobList.Sort(@CompareJobs);
  FJobList.GetMaxJobID; // обновляем значени
  if (Criteria.RangeType = PlanRange_Continuous) or (Criteria.RangeType = PlanRange_Week) then
    BuildShiftJobLists;
end;

function TWorkload.CurrentJob: TJobParams;
begin
  if IsEmpty then
    Result := nil
  else
    Result := JobList.GetJob(KeyValue);
end;

function TWorkload.CurrentShift: TShiftInfo;
begin
  if IsEmpty then
    Result := nil
  else
    Result := GetJobShift(KeyValue);
end;

function TWorkload.GetJobShift(JobID: integer): TShiftInfo;
var
  ShiftIndex: Integer;
  JobIndex: Integer;
  Shift: TShiftInfo;
begin
  Result := nil;
  for ShiftIndex := 0 to FShiftList.Count - 1 do
  begin
    Shift := FShiftList[ShiftIndex];
    for JobIndex := 0 to Shift.JobList.Count - 1 do
      if Shift.JobList[JobIndex].JobID = JobID then
      begin
        Result := Shift;
        Exit;
      end;
  end;
end;

function TWorkload.GetShiftByID(ShiftID: integer): TShiftInfo;
var
  ShiftIndex: Integer;
  Shift: TShiftInfo;
begin
  Result := nil;
  for ShiftIndex := 0 to FShiftList.Count - 1 do
  begin
    Shift := FShiftList[ShiftIndex];
    if Shift.Number = -ShiftID then
    begin
      Result := Shift;
      Exit;
    end;
  end;
end;

function TWorkload.GetShiftByDate(DT: TDateTime): TShiftInfo;
var
  ShiftIndex: Integer;
  Shift, PrevShift: TShiftInfo;
begin
  Result := nil;
  if FShiftList.Count = 0 then Exit;

  PrevShift := FShiftList[0];
  for ShiftIndex := 1 to FShiftList.Count - 1 do
  begin
    Shift := FShiftList[ShiftIndex];
    if Shift.Start > DT then
    begin
      Result := PrevShift;
      Exit;
    end
    else
      PrevShift := Shift;
  end;
end;

{$ENDREGION}

end.
