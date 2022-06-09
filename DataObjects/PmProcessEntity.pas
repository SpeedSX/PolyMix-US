unit PmProcessEntity;

interface

uses Classes, SysUtils, DB, dbclient, JvInterpreter,
  NotifyEvent, PmEntity, PmProcess, PmProcessCfg, PmExecCode, DicObj, RDBUtils,
  ServMod, PmQueryPager, PmJobParams, PmConfigManager;

type
  TCustomSQL = record
    Select, From, Where: string;
  end;

  TProcessEntity = class(TEntity)
  private
    FRequireEquipGroup: Boolean;
    function GetExecState: Integer;
    function GetItemDesc: string;
    function GetItemID: Integer;
    function GetJobID: Integer;
    function GetPart: Integer;
    function GetProcessID: Integer;
    function GetMultiplier: Extended;
    function GetSideCount: variant;
    function GetComment: variant;
    function GetOrderNumber: string;
    function GetOrderState: integer;
    function GetEstimatedDuration: Integer;
    function GetOrderID: Variant;
    function GetPartName: string;
  protected
    //FProcess: TPolyProcess;
    FOnScriptError: TScriptError;
    FEquipGroupCode: integer;
    FCfgChangeID, FBeforeCfgChangeID: TNotifyHandlerID;
    FProcessList: TProcessList;
    FDataSource: TDataSource;
    FNumberField: string;
    //FSavedProcessID: integer;

    procedure BeforeProcessCfgChange_Handler(Sender: TObject);
    procedure ProcessCfgChanged_Handler(Sender: TObject);
    procedure SetEquipGroup(_EquipGroupCode: integer);
    function ExecGetSQLCode(ScriptFieldName: string; EquipCode: integer): TCustomSQL;
    function ExecCode(ScriptFieldName: string): boolean;
    property RequireEquipGroup: Boolean read FRequireEquipGroup write FRequireEquipGroup;
    procedure FreeProcessList;
    function CombineSQL(DefaultSQL, CustomSQL: TCustomSQL; var HasWhere: boolean): TQueryObject; virtual;
    procedure SetComment(_Value: variant);
  public
    const
      F_JobID = 'JobID';
      F_EquipName = 'EquipName';

    constructor Create(_InternalName, _KeyField:
        string; _DataSet: TDataSet; _EquipGroupCode: integer;
        {_Process: TPolyProcess; }_RequireEquipGroup: boolean);
    destructor Destroy; override;
    function FindScript(var Process: TPolyProcessCfg; ScriptFieldName: string): Boolean;
    procedure SetSortOrder(_SortField: string; MakeActive: boolean); override;

    property DataSource: TDataSource read FDataSource;

    property NumberField: string read FNumberField;
    property EquipGroupCode: Integer read FEquipGroupCode;
    property ExecState: Integer read GetExecState;
    property ItemDesc: string read GetItemDesc;
    property Comment: variant read GetComment;
    property OrderNumber: string read GetOrderNumber;
    property OrderState: integer read GetOrderState;
    // Для спец работ = 0
    property ItemID: Integer read GetItemID;
    property JobID: Integer read GetJobID;
    //property Process: TPolyProcess read FProcess;
    property OnScriptError: TScriptError read FOnScriptError write FOnScriptError;
    property Part: Integer read GetPart;
    property ProcessID: Integer read GetProcessID;
    // количество листов
    property Multiplier: Extended read GetMultiplier;
    // количество сторон
    property SideCount: variant read GetSideCount;
    property EstimatedDuration: Integer read GetEstimatedDuration;
    property OrderID: Variant read GetOrderID;
    property PartName: string read GetPartName;
  end;

  TSplittableProcessEntity = class(TProcessEntity)
  private
    function GetSplitMode1: Variant;
    function GetSplitMode2: Variant;
    function GetSplitMode3: Variant;
    function GetSplitPart1: variant;
    function GetSplitPart2: variant;
    function GetSplitPart3: variant;
  public
    // возвращает true, если есть указанный режим разбивки
    function HasSplitMode(SplitMode: TSplitMode): boolean;
    // возвращает часть разбивки, соотв. типу разбивки
    function GetSplitPart(SplitMode: TSplitMode): integer;
    // возвращает SQL-выражение для выборки количества с учетом разбивки
    function GetSplitCountExpr(SelectExpr, FieldAlias, FactExpr, JobAlias: string;
      FactPriority: boolean): string;
    // Режим разбивки
    property SplitMode1: Variant read GetSplitMode1;
    property SplitMode2: Variant read GetSplitMode2;
    property SplitMode3: Variant read GetSplitMode3;
    // Номер части для разбитых работ
    property SplitPart1: variant read GetSplitPart1;
    property SplitPart2: variant read GetSplitPart2;
    property SplitPart3: variant read GetSplitPart3;
  end;

  TPlanCalcFieldsCode = class(TDataSetCode)
  protected
    procedure DoPrgGetValue(Sender: TObject; Identifer: String;
      var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean); override;
    //procedure DoPrgSetValue(Sender: TObject; Identifer: String;
    //  const Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean); override;
  public
    NoPlanMode, DayMode: boolean;
    DataSet: TDataSet;
  end;

const
  EmptySQL: TCustomSQL = (Select: ''; From: ''; Where: '');

implementation

uses ExHandler, Variants, PmOrder, PmOrderProcessItems;

type
  TGetSQLCode = class(TCode)
  protected
    procedure DoPrgGetValue(Sender: TObject; Identifer: String;
      var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean); override;
    procedure DoPrgSetValue(Sender: TObject; Identifer: String;
      const Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean); override;
  public
    //SQL: string;
    // Части запроса, добавляемые к стандартному запросу
    CustomSQL: TCustomSQL;
    EquipCode: integer;
  end;

procedure TPlanCalcFieldsCode.DoPrgGetValue(Sender: TObject; Identifer: String;
  var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
begin
  inherited DoPrgGetValue(Sender, Identifer, Value, Args, Done);
  if Done then Exit;

  if CompareText(Identifer, 'DataSet') = 0 then
  begin
    Value := O2V(DataSet);
    Done := true;
  end
  else if CompareText(Identifer, 'NoPlanMode') = 0 then
  begin
    Value := NoPlanMode;
    Done := true;
  end
  else if CompareText(Identifer, 'DayMode') = 0 then
  begin
    Value := DayMode;
    Done := true;
  end
  else if CompareText(Identifer, 'CurProcess') = 0 then
  begin
    Value := O2V(FProcess);
    Done := true;
  end
  {else if CompareText(Identifer, 'HasSplitMode') = 0 then
  begin
    if Args.Count <> 1 then
      ExceptionHandler.Raise_(Exception.Create('Неправильный вызов HasSplitMode. Должен передаваться параметр - режим разбивки'));
    Value := (DataSet['SplitMode1'] = Args.Values[0])
      or (DataSet['SplitMode2'] = Args.Values[0])
      or (DataSet['SplitMode3'] = Args.Values[0]);
    Done := true;
  end;}
end;

procedure TGetSQLCode.DoPrgGetValue(Sender: TObject; Identifer: String;
  var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
begin
  {if CompareText(Identifer, 'SQL') = 0 then
  begin
    Value := SQL;
    Done := true;
  end
  else if CompareText(Identifer, 'HasWhere') = 0 then
  begin
    Value := HasWhere;
    Done := true;
  end
  else }
  if CompareText(Identifer, 'EquipCode') = 0 then
  begin
    Value := EquipCode;
    Done := true;
  end;
  if CompareText(Identifer, 'Where') = 0 then
  begin
    Value := CustomSQL.Where;
    Done := true;
  end else
  if CompareText(Identifer, 'Select') = 0 then
  begin
    Value := CustomSQL.Select;
    Done := true;
  end;
  if CompareText(Identifer, 'From') = 0 then
  begin
    Value := CustomSQL.From;
    Done := true;
  end;
end;

procedure TGetSQLCode.DoPrgSetValue(Sender: TObject; Identifer: String;
  const Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
begin
  {if CompareText(Identifer, 'SQL') = 0 then
  begin
    SQL := Value;
    Done := true;
  end else if CompareText(Identifer, 'HasWhere') = 0 then
  begin
    HasWhere := Value;
    Done := true;
  end;}
  if CompareText(Identifer, 'Where') = 0 then
  begin
    CustomSQL.Where := Value;
    Done := true;
  end else
  if CompareText(Identifer, 'Select') = 0 then
  begin
    CustomSQL.Select := Value;
    Done := true;
  end;
  if CompareText(Identifer, 'From') = 0 then
  begin
    CustomSQL.From := Value;
    Done := true;
  end;
end;

{$REGION 'TProcessEntity'}

constructor TProcessEntity.Create(_InternalName, _KeyField: string;
   _DataSet: TDataSet; _EquipGroupCode: integer;
   {_Process: TPolyProcess; }_RequireEquipGroup: boolean);
begin
  inherited Create;
  FKeyField := _KeyField;
  FInternalName := _InternalName;
  SetDataSet(_DataSet);
  //FProcess := _Process;
  SetEquipGroup(_EquipGroupCode);

  FBeforeCfgChangeID := TConfigManager.Instance.BeforeProcessCfgChange.RegisterHandler(BeforeProcessCfgChange_Handler);
  FCfgChangeID := TConfigManager.Instance.ProcessCfgChanged.RegisterHandler(ProcessCfgChanged_Handler);
end;

destructor TProcessEntity.Destroy;
begin
  TConfigManager.Instance.BeforeProcessCfgChange.UnRegisterHandler(FBeforeCfgChangeID);
  TConfigManager.Instance.ProcessCfgChanged.UnRegisterHandler(FCfgChangeID);
  FreeProcessList;
  inherited Destroy;
end;

procedure TProcessEntity.SetSortOrder(_SortField: string; MakeActive: boolean);
var
  cd: TClientDataSet;
  i, k: integer;
begin
  cd := TClientDataSet(DataSet);
  if cd = nil then Exit;
  try
    for i := 0 to cd.IndexDefs.Count - 1 do
    begin
      if CompareText(cd.IndexDefs[i].Fields, _SortField) = 0 then
      begin
        FSortField := _SortField;
        if not cd.Active or cd.isEmpty then
          k := -1
        else
          k := NvlInteger(KeyValue);
        cd.IndexName := cd.IndexDefs[i].Name;
        if cd.Active then Locate(k);
        break;
      end;
    end;
  finally
    cd.EnableControls;
  end;
end;

procedure TProcessEntity.BeforeProcessCfgChange_Handler(Sender: TObject);
begin
  //FSavedProcessID := Process.SrvID;
end;

procedure TProcessEntity.ProcessCfgChanged_Handler(Sender: TObject);
begin
  // обновляем ссылку на процесс, если он пересоздан
  //FProcess := sm.ServiceByID(FSavedProcessID, false);
  SetEquipGroup(FEquipGroupCode);
end;

procedure TProcessEntity.FreeProcessList;
begin
  if FProcessList <> nil then FreeAndNil(FProcessList);
end;

procedure TProcessEntity.SetEquipGroup(_EquipGroupCode: integer);
begin
  if (_EquipGroupCode <= 0) and FRequireEquipGroup then
    raise Exception.Create('Не указана группа оборудования');
  FEquipGroupCode := _EquipGroupCode;
  FreeProcessList;
  FProcessList := TConfigManager.Instance.GetPlanProcessList(FEquipGroupCode);
end;

function TProcessEntity.FindScript(var Process: TPolyProcessCfg; ScriptFieldName: string): Boolean;
var
  I: Integer;
  FProcess: TPolyProcessCfg;
  S: string;
  Script: TStringList;
begin
  Result := false;
  for I := 0 to FProcessList.Count - 1 do
  begin
    FProcess := FProcessList.Objects[i] as TPolyProcessCfg;
    Script := FProcess.GetScript(ScriptFieldName);
    if Script <> nil then
    begin
      s := Script.Text;
      if Trim(s) <> '' then
      begin
        Process := FProcess;
        Result := true;
        Exit;
      end;
    end;
  end;
end;

function TProcessEntity.ExecCode(ScriptFieldName: string): boolean;
var
  DataSetCode: TDataSetCode;
  FProcess: TPolyProcessCfg;
begin
  // Ищем у кого есть сценарий, если есть выполняем
  Result := FindScript(FProcess, ScriptFieldName);
  if Result then
  begin
    DataSetCode := TDataSetCode.Create(DataSet, FProcess, ScriptFieldName);
    try
      DataSetCode.OnScriptError := FOnScriptError;
      DataSetCode.ExposeDataSet := true;
      Result := DataSetCode.ExecCode;
    finally
      DataSetCode.Free;
    end;
  end;
end;

// Возвращает пустую строку если нету скрипта
function TProcessEntity.ExecGetSQLCode(ScriptFieldName: string; EquipCode: integer): TCustomSQL;
var
  GetSQLCode: TGetSQLCode;
  Found: Boolean;
  FProcess: TPolyProcessCfg;
begin
  // Ищем у кого есть сценарий, если есть выполняем
  Found := FindScript(FProcess, ScriptFieldName);
  if Found then
  begin
    GetSQLCode := TGetSQLCode.Create(FProcess, ScriptFieldName);
    try
      GetSQLCode.OnScriptError := FOnScriptError;
      GetSQLCode.EquipCode := EquipCode;
      GetSQLCode.ExecCode;
      Result := GetSQLCode.CustomSQL;
    finally
      GetSQLCode.Free;
    end;
  end
  else
    Result := EmptySQL;
end;

function TProcessEntity.CombineSQL(DefaultSQL, CustomSQL: TCustomSQL;
  var HasWhere: boolean): TQueryObject;
begin
  Result.Select := DefaultSQL.Select;
  if CustomSQL.Select <> '' then
    Result.Select := Result.Select + ',' + #13#10 + CustomSQL.Select;

  Result.From := DefaultSQL.From;
  if CustomSQL.From <> '' then
    Result.From := Result.From + #13#10 + CustomSQL.From;

  Result.Where := DefaultSQL.Where;
  if CustomSQL.Where <> '' then
    Result.Where := Result.Where + ' and (' + #13#10 + CustomSQL.Where + ')';

  HasWhere := (DefaultSQL.Where <> '') or (CustomSQL.Where <> '');

  Result.TableName := 'OrderProcessItem';
  Result.TableAlias := 'opi';
  Result.KeyFieldName := 'ItemID';
end;

function TProcessEntity.GetExecState: Integer;
begin
  Result := NvlInteger(DataSet[TOrderProcessItems.F_ExecState]);
end;

function TProcessEntity.GetItemDesc: string;
begin
  Result := NvlString(DataSet['ItemDesc']);
end;

function TProcessEntity.GetItemID: Integer;
begin
  Result := NvlInteger(DataSet[F_ItemID]);
end;

function TProcessEntity.GetJobID: Integer;
begin
  Result := NvlInteger(DataSet[F_JobID]);
end;

function TProcessEntity.GetPart: Integer;
begin
  Result := NvlInteger(DataSet[F_Part]);
end;

function TProcessEntity.GetProcessID: Integer;
begin
  Result := DataSet['ProcessID'];
end;

function TProcessEntity.GetMultiplier: Extended;
begin
  Result := NvlFloat(DataSet['Multiplier']);
end;

function TProcessEntity.GetSideCount: variant;
begin
  Result := DataSet['SideCount'];
end;

function TProcessEntity.GetComment: variant;
begin
  Result := DataSet['Comment'];
end;

procedure TProcessEntity.SetComment(_Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;

  DataSet['Comment'] := _Value;
end;

function TProcessEntity.GetOrderNumber: string;
begin
  Result := VarToStr(DataSet[TOrder.F_OrderNumber]);
end;

function TProcessEntity.GetOrderState: integer;
begin
  Result := NvlInteger(DataSet[TOrder.F_OrderState]);
end;

function TProcessEntity.GetEstimatedDuration: Integer;
begin
  Result := NvlInteger(DataSet['EstimatedDuration']);
end;

function TProcessEntity.GetOrderID: Variant;
begin
  Result := DataSet['OrderID'];
end;

function TProcessEntity.GetPartName: string;
begin
  Result := DataSet[F_PartName];
end;

{$ENDREGION}

{$REGION 'TSplittableProcessEntity'}

function TSplittableProcessEntity.HasSplitMode(SplitMode: TSplitMode): boolean;
begin
  Result := ((SplitMode1 = SplitMode) and not VarIsNull(SplitPart1))
     or ((SplitMode2 = SplitMode) and not VarIsNull(SplitPart2))
     or ((SplitMode3 = SplitMode) and not VarIsNull(SplitPart3));
end;

function TSplittableProcessEntity.GetSplitPart(SplitMode: TSplitMode): integer;
begin
  if SplitMode1 = SplitMode then
    Result := NvlInteger(SplitPart1)
  else if SplitMode2 = SplitMode then
    Result := NvlInteger(SplitPart2)
  else if SplitMode3 = SplitMode then
    Result := NvlInteger(SplitPart3)
  else
    raise Exception.Create('Неправильный код разбивки ' + IntToStr(Ord(SplitMode)));
end;

function TSplittableProcessEntity.GetSplitMode1: Variant;
begin
  {if not VarIsNull(DataSet['SplitMode']) then
    Result := TSplitMode(DataSet['SplitMode'])
  else}
    Result := DataSet['SplitMode1'];
end;

function TSplittableProcessEntity.GetSplitMode2: Variant;
begin
  {if not VarIsNull(DataSet['SplitMode']) then
    Result := TSplitMode(DataSet['SplitMode'])
  else}
    Result := DataSet['SplitMode2'];
end;

function TSplittableProcessEntity.GetSplitMode3: Variant;
begin
  {if not VarIsNull(DataSet['SplitMode']) then
    Result := TSplitMode(DataSet['SplitMode'])
  else}
    Result := DataSet['SplitMode3'];
end;

function TSplittableProcessEntity.GetSplitPart1: variant;
begin
  Result := DataSet['SplitPart1'];
end;

function TSplittableProcessEntity.GetSplitPart2: variant;
begin
  Result := DataSet['SplitPart2'];
end;

function TSplittableProcessEntity.GetSplitPart3: variant;
begin
  Result := DataSet['SplitPart3'];
end;

// При разбивке работы по количеству пересчитываем количество пропорционально длительности этой работы по отношению
// к суммарной длительности всех составляющих работ. Если работа не разбита или установлена фактическая выработка, то берется ProductOut
function TSplittableProcessEntity.GetSplitCountExpr(SelectExpr, FieldAlias, FactExpr, JobAlias: string;
  FactPriority: boolean): string;
var
  J: string;
begin
  {Result :=
    ' (case when j.FactFinishDate is null or j.FactProductOut is null then' + #13#10 +
    // проверяем есть ли разбивка по тиражу, тогда вызываем функцию
    ' (case when opi.SplitMode1 = 0 or opi.SplitMode2 = 0 or opi.SplitMode3 = 0 then dbo.SplitCount(opi.SplitMode1, opi.SplitMode2, opi.SplitMode3, ' + #13#10 +
       SelectExpr + ' - (select ISNULL(sum(ISNULL(' + FactExpr + ', 0)), 0) from Job j4 where j4.ItemID = j.ItemID), COALESCE(j.FactStartDate, j.PlanStartDate), COALESCE(j.FactFinishDate, j.PlanFinishDate),' + #13#10 +
    ' (select sum(datediff(second, COALESCE(j2.FactStartDate, j2.PlanStartDate), COALESCE(j2.FactFinishDate, j2.PlanFinishDate))) from Job j2 where j2.ItemID = j.ItemID)' + #13#10 +
    '  - (select ISNULL(sum(datediff(second, j5.FactStartDate, j5.FactFinishDate)), 0) from Job j5 where j5.ItemID = j.ItemID and j5.FactStartDate is not null and j5.FactFinishDate is not null)) else ' + #13#10 +
       SelectExpr + ' end) else ' + FactExpr + ' end) as ' + FieldAlias;}
  // Рассматриваем каждый случай разбивки отдельно.
  // TODO! Учесть разбивку по сторонам!
  {Result :=
   '(case when j.FactFinishDate is null or j.FactProductOut is null then'#13#10 +
      '(case'#13#10 +
      // "по множителю" или "по множителю и стороне"
      'when opi.SplitMode1 = 1 and (j.SplitPart2 is null or (opi.SplitMode2 = 2 and j.SplitPart2 is not null and j.SplitPart3 is null)) then'#13#10 +
        'cast(' + SelectExpr + ' / opi.Multiplier as int)'#13#10 +
        //SelectExpr + #13#10 +
      // "по множителю", потом "по тиражу"
      'when opi.SplitMode1 = 1 and opi.SplitMode2 = 0 and j.SplitPart2 is not null and j.SplitPart3 is null then' + #13#10 +
         'dbo.SplitCount(' + SelectExpr + ' / opi.Multiplier - (select ISNULL(sum(ISNULL(' + FactExpr + ', 0)), 0) from Job j4 where j4.ItemID = j.ItemID and j4.SplitPart1 = j.SplitPart1),' + #13#10 +
           'COALESCE(j.FactStartDate, j.PlanStartDate),'#13#10 +
           'COALESCE(j.FactFinishDate, j.PlanFinishDate),'#13#10 +
           '(select sum(datediff(second, COALESCE(j2.FactStartDate, j2.PlanStartDate), COALESCE(j2.FactFinishDate, j2.PlanFinishDate))) from Job j2 where j2.ItemID = j.ItemID and j2.SplitPart1 = j.SplitPart1)'#13#10 +
           '- (select ISNULL(sum(datediff(second, j5.FactStartDate, j5.FactFinishDate)), 0) from Job j5 where j5.ItemID = j.ItemID and j5.SplitPart1 = j.SplitPart1'#13#10 +
           ' and j5.FactStartDate is not null and j5.FactFinishDate is not null and j5.FactProductOut is not null))'#13#10 +
      // "по множителю", потом "по тиражу" , потом "по стороне"
      'when opi.SplitMode1 = 1 and opi.SplitMode2 = 0 and j.SplitPart2 is not null and opi.SplitMode3 = 2 and j.SplitPart3 is not null then' + #13#10 +
         'dbo.SplitCount(' + SelectExpr + ' / opi.Multiplier - (select ISNULL(sum(ISNULL(' + FactExpr + ', 0)), 0) from Job j4 where j4.ItemID = j.ItemID and j4.SplitPart1 = j.SplitPart1 and j4.SplitPart2 = j.SplitPart2),' + #13#10 +
           'COALESCE(j.FactStartDate, j.PlanStartDate),'#13#10 +
           'COALESCE(j.FactFinishDate, j.PlanFinishDate),'#13#10 +
           '(select sum(datediff(second, COALESCE(j2.FactStartDate, j2.PlanStartDate), COALESCE(j2.FactFinishDate, j2.PlanFinishDate))) from Job j2 where j2.ItemID = j.ItemID and j2.SplitPart1 = j.SplitPart1 and j2.SplitPart2 = j.SplitPart2)'#13#10 +
           '- (select ISNULL(sum(datediff(second, j5.FactStartDate, j5.FactFinishDate)), 0) from Job j5 where j5.ItemID = j.ItemID and j5.SplitPart1 = j.SplitPart1 and j5.SplitPart2 = j.SplitPart2'#13#10 +
           ' and j5.FactStartDate is not null and j5.FactFinishDate is not null and j5.FactProductOut is not null))'#13#10 +
      // "по тиражу"
      'when opi.SplitMode1 = 0 and j.SplitPart2 is null then'#13#10 +
         'dbo.SplitCount(' + SelectExpr + ' - (select ISNULL(sum(ISNULL(' + FactExpr + ', 0)), 0) from Job j4 where j4.ItemID = j.ItemID),'#13#10 +
           'COALESCE(j.FactStartDate, j.PlanStartDate),'#13#10 +
           'COALESCE(j.FactFinishDate, j.PlanFinishDate),'#13#10 +
           '(select sum(datediff(second, COALESCE(j2.FactStartDate, j2.PlanStartDate), COALESCE(j2.FactFinishDate, j2.PlanFinishDate))) from Job j2 where j2.ItemID = j.ItemID)'#13#10 +
           '- (select ISNULL(sum(datediff(second, j5.FactStartDate, j5.FactFinishDate)), 0) from Job j5 where j5.ItemID = j.ItemID and j5.FactStartDate is not null and j5.FactFinishDate is not null and j5.FactProductOut is not null))'#13#10 +
      // "по тиражу", потом "по множителю"
      'when opi.SplitMode1 = 0 and opi.SplitMode2 = 1 and j.SplitPart2 is not null and j.SplitPart3 is null then'#13#10 +
         'dbo.SplitCount(' + SelectExpr + ' - (select ISNULL(sum(ISNULL(' + FactExpr + ', 0)), 0) from Job j4 where j4.ItemID = j.ItemID and j4.SplitPart1 = j.SplitPart1),'#13#10 +
           'COALESCE(j.FactStartDate, j.PlanStartDate),'#13#10 +
           'COALESCE(j.FactFinishDate, j.PlanFinishDate),'#13#10 +
           '(select sum(datediff(second, COALESCE(j2.FactStartDate, j2.PlanStartDate), COALESCE(j2.FactFinishDate, j2.PlanFinishDate))) from Job j2 where j2.ItemID = j.ItemID)'#13#10 +
           '- (select ISNULL(sum(datediff(second, j5.FactStartDate, j5.FactFinishDate)), 0) from Job j5 where j5.ItemID = j.ItemID and j5.SplitPart1 = j.SplitPart1'#13#10 +
           ' and j5.FactStartDate is not null and j5.FactFinishDate is not null and j5.FactProductOut is not null))'#13#10 +
      // "по множителю", потом "по стороне", потом "по тиражу"
      'when opi.SplitMode1 = 1 and j.SplitPart1 is not null and opi.SplitMode2 = 2 and j.SplitPart2 is not null and opi.SplitMode3 = 0 and j.SplitPart3 is not null then'#13#10 +
         'dbo.SplitCount(' + SelectExpr + ' / opi.Multiplier - (select ISNULL(sum(ISNULL(' + FactExpr + ', 0)), 0) from Job j6 where j6.ItemID = j.ItemID and j6.SplitPart1 = j.SplitPart1 and j6.SplitPart2 = j.SplitPart2),'#13#10 +
           'COALESCE(j.FactStartDate, j.PlanStartDate),'#13#10 +
           'COALESCE(j.FactFinishDate, j.PlanFinishDate),'#13#10 +
           '(select sum(datediff(second, COALESCE(j7.FactStartDate, j7.PlanStartDate), COALESCE(j7.FactFinishDate, j7.PlanFinishDate))) from Job j7 where j7.ItemID = j.ItemID and j7.SplitPart1 = j.SplitPart1 and j7.SplitPart2 = j.SplitPart2)'#13#10 +
           '- (select ISNULL(sum(datediff(second, j8.FactStartDate, j8.FactFinishDate)), 0) from Job j8 where j8.ItemID = j.ItemID and j8.SplitPart1 = j.SplitPart1 and j8.SplitPart2 = j.SplitPart2'#13#10 +
           ' and j8.FactStartDate is not null and j8.FactFinishDate is not null and j8.FactProductOut is not null))'#13#10 +
      // "по стороне", потом "по тиражу"
      'when opi.SplitMode1 = 2 and j.SplitPart1 is not null and opi.SplitMode2 = 0 and j.SplitPart2 is not null and j.SplitPart3 is null then'#13#10 +
         'dbo.SplitCount(' + SelectExpr + ' - (select ISNULL(sum(ISNULL(' + FactExpr + ', 0)), 0) from Job j9 where j9.ItemID = j.ItemID and j9.SplitPart1 = j.SplitPart1),'#13#10 +
           'COALESCE(j.FactStartDate, j.PlanStartDate),'#13#10 +
           'COALESCE(j.FactFinishDate, j.PlanFinishDate),'#13#10 +
           '(select sum(datediff(second, COALESCE(j10.FactStartDate, j10.PlanStartDate), COALESCE(j10.FactFinishDate, j10.PlanFinishDate))) from Job j10 where j10.ItemID = j.ItemID and j10.SplitPart1 = j.SplitPart1)'#13#10 +
           '- (select ISNULL(sum(datediff(second, j11.FactStartDate, j11.FactFinishDate)), 0) from Job j11 where j11.ItemID = j.ItemID and j11.SplitPart1 = j.SplitPart1'#13#10 +
           ' and j11.FactStartDate is not null and j11.FactFinishDate is not null and j11.FactProductOut is not null))'#13#10 +
      'else'#13#10 +
        SelectExpr + #13#10 +
      'end)'#13#10 +
   'else ' + FactExpr + #13#10 +
   'end) as ' + FieldAlias + #13#10;
  }
  J := JobAlias + '.';
  if (FactExpr <> '') and FactPriority then
    Result := '(case when ' + J + 'FactFinishDate is null or ' + J + FactExpr + ' is null then'#13#10
  else
    Result := '';
  Result := Result +
      '(case'#13#10 +
      // "по множителю" или "по множителю и стороне"
      'when opi.SplitMode1 = 1 and (' + J + 'SplitPart2 is null or (opi.SplitMode2 = 2 and ' + J + 'SplitPart2 is not null and ' + J + 'SplitPart3 is null)) then'#13#10 +
        'cast(' + SelectExpr + ' / opi.Multiplier as int)'#13#10 +
        //SelectExpr + #13#10 +
      // "по множителю", потом "по тиражу"
      'when opi.SplitMode1 = 1 and opi.SplitMode2 = 0 and ' + J + 'SplitPart2 is not null and ' + J + 'SplitPart3 is null then' + #13#10 +
         'dbo.SplitCount(' + SelectExpr + ' / opi.Multiplier';
           if (FactExpr <> '') then
             Result := Result + ' - (select ISNULL(sum(ISNULL(' + FactExpr + ', 0)), 0) from Job j4 where j4.ItemID = opi.ItemID and j4.SplitPart1 = ' + J + 'SplitPart1 and j4.FactStartDate is not null and j4.FactFinishDate is not null)';
           Result := Result + ','#13#10 +
           'COALESCE(' + J + 'FactStartDate, ' + J + 'PlanStartDate),'#13#10 +
           'COALESCE(' + J + 'FactFinishDate, ' + J + 'PlanFinishDate),'#13#10 +
           '(select sum(datediff(second, COALESCE(j2.FactStartDate, j2.PlanStartDate), COALESCE(j2.FactFinishDate, j2.PlanFinishDate))) from Job j2 where j2.ItemID = opi.ItemID and j2.SplitPart1 = ' + J + 'SplitPart1)'#13#10;
           if FactExpr <> '' then
             Result := Result + '- (select ISNULL(sum(datediff(second, j5.FactStartDate, j5.FactFinishDate)), 0) from Job j5 where j5.ItemID = opi.ItemID and j5.SplitPart1 = ' + J + 'SplitPart1'#13#10 +
                ' and j5.FactStartDate is not null and j5.FactFinishDate is not null and j5.FactProductOut is not null)';
          Result := Result + ')'#13#10;
      Result := Result +
      // "по множителю", потом "по тиражу" , потом "по стороне"
      'when opi.SplitMode1 = 1 and opi.SplitMode2 = 0 and ' + J + 'SplitPart2 is not null and opi.SplitMode3 = 2 and ' + J + 'SplitPart3 is not null then'#13#10 +
         'dbo.SplitCount(' + SelectExpr + ' / opi.Multiplier';
           if FactExpr <> '' then
             Result := Result + ' - (select ISNULL(sum(ISNULL(' + FactExpr + ', 0)), 0) from Job j4 where j4.ItemID = opi.ItemID and j4.SplitPart1 = ' + J + 'SplitPart1 and j4.SplitPart2 = ' + J + 'SplitPart2 and j4.FactStartDate is not null and j4.FactFinishDate is not null)';
           Result := Result + ','#13#10 +
           'COALESCE(' + J + 'FactStartDate, ' + J + 'PlanStartDate),'#13#10 +
           'COALESCE(' + J + 'FactFinishDate, ' + J + 'PlanFinishDate),'#13#10 +
           '(select sum(datediff(second, COALESCE(j2.FactStartDate, j2.PlanStartDate), COALESCE(j2.FactFinishDate, j2.PlanFinishDate))) from Job j2 where j2.ItemID = opi.ItemID and j2.SplitPart1 = ' + J + 'SplitPart1 and j2.SplitPart2 = ' + J + 'SplitPart2)'#13#10;
          if FactExpr <> '' then
            Result := Result + ' - (select ISNULL(sum(datediff(second, j5.FactStartDate, j5.FactFinishDate)), 0) from Job j5 where j5.ItemID = opi.ItemID and j5.SplitPart1 = ' + J + 'SplitPart1 and j5.SplitPart2 = ' + J + 'SplitPart2'#13#10 +
             ' and j5.FactStartDate is not null and j5.FactFinishDate is not null and j5.FactProductOut is not null)';
          Result := Result + ')'#13#10;
      Result := Result +
      // "по тиражу"
      'when opi.SplitMode1 = 0 and ' + J + 'SplitPart2 is null then'#13#10 +
         'dbo.SplitCount(' + SelectExpr;
          if FactExpr <> '' then
             Result := Result + ' - (select ISNULL(sum(ISNULL(' + FactExpr + ', 0)), 0) from Job j4 where j4.ItemID = opi.ItemID and j4.FactStartDate is not null and j4.FactFinishDate is not null)';
          Result := Result + ','#13#10 +
           'COALESCE(' + J + 'FactStartDate, ' + J + 'PlanStartDate),'#13#10 +
           'COALESCE(' + J + 'FactFinishDate, ' + J + 'PlanFinishDate),'#13#10 +
           '(select sum(datediff(second, COALESCE(j2.FactStartDate, j2.PlanStartDate), COALESCE(j2.FactFinishDate, j2.PlanFinishDate))) from Job j2 where j2.ItemID = opi.ItemID)'#13#10;
          if FactExpr <> '' then
            Result := Result + ' - (select ISNULL(sum(datediff(second, j5.FactStartDate, j5.FactFinishDate)), 0) from Job j5 where j5.ItemID = opi.ItemID and j5.FactStartDate is not null and j5.FactFinishDate is not null and j5.FactProductOut is not null)';
          Result := Result + ')'#13#10;
      Result := Result +
      // "по тиражу", потом "по множителю"
      'when opi.SplitMode1 = 0 and opi.SplitMode2 = 1 and ' + J + 'SplitPart2 is not null and ' + J + 'SplitPart3 is null then'#13#10 +
         'dbo.SplitCount(' + SelectExpr;
           if FactExpr <> '' then
             Result := Result + ' - (select ISNULL(sum(ISNULL(' + FactExpr + ', 0)), 0) from Job j4 where j4.ItemID = opi.ItemID and j4.SplitPart1 = ' + J + 'SplitPart1 and j4.FactStartDate is not null and j4.FactFinishDate is not null)';
           Result := Result + ','#13#10 +
           'COALESCE(' + J + 'FactStartDate, ' + J + 'PlanStartDate),'#13#10 +
           'COALESCE(' + J + 'FactFinishDate, ' + J + 'PlanFinishDate),'#13#10 +
           '(select sum(datediff(second, COALESCE(j2.FactStartDate, j2.PlanStartDate), COALESCE(j2.FactFinishDate, j2.PlanFinishDate))) from Job j2 where j2.ItemID = opi.ItemID)'#13#10;
           if FactExpr <> '' then
             Result := Result + ' - (select ISNULL(sum(datediff(second, j5.FactStartDate, j5.FactFinishDate)), 0) from Job j5 where j5.ItemID = opi.ItemID and j5.SplitPart1 = ' + J + 'SplitPart1'#13#10 +
                ' and j5.FactStartDate is not null and j5.FactFinishDate is not null and j5.FactProductOut is not null)';
          Result := Result + ')'#13#10;
      Result := Result +
      // "по тиражу", потом "по стороне"
      'when opi.SplitMode1 = 0 and opi.SplitMode2 = 2 and ' + J + 'SplitPart2 is not null and ' + J + 'SplitPart3 is null then'#13#10 +
         'dbo.SplitCount(' + SelectExpr;
          if FactExpr <> '' then
             Result := Result + ' - (select ISNULL(sum(ISNULL(' + FactExpr + ', 0)), 0) from Job j4 where j4.ItemID = opi.ItemID and j4.FactStartDate is not null and j4.FactFinishDate is not null)';
          Result := Result + ','#13#10 +
           'COALESCE(' + J + 'FactStartDate, ' + J + 'PlanStartDate),'#13#10 +
           'COALESCE(' + J + 'FactFinishDate, ' + J + 'PlanFinishDate),'#13#10 +
           '(select sum(datediff(second, COALESCE(j2.FactStartDate, j2.PlanStartDate), COALESCE(j2.FactFinishDate, j2.PlanFinishDate))) from Job j2 where j2.ItemID = opi.ItemID)'#13#10;
          if FactExpr <> '' then
            Result := Result + ' - (select ISNULL(sum(datediff(second, j5.FactStartDate, j5.FactFinishDate)), 0) from Job j5 where j5.ItemID = opi.ItemID and j5.FactStartDate is not null and j5.FactFinishDate is not null and j5.FactProductOut is not null)';
          Result := Result + ')'#13#10;
      Result := Result +
      // "по множителю", потом "по стороне", потом "по тиражу"
      'when opi.SplitMode1 = 1 and ' + J + 'SplitPart1 is not null and opi.SplitMode2 = 2 and ' + J + 'SplitPart2 is not null and opi.SplitMode3 = 0 and ' + J + 'SplitPart3 is not null then'#13#10 +
         'dbo.SplitCount(' + SelectExpr + ' / opi.Multiplier';
           if FactExpr <> '' then
             Result := Result + ' - (select ISNULL(sum(ISNULL(' + FactExpr + ', 0)), 0) from Job j6 where j6.ItemID = opi.ItemID and j6.SplitPart1 = ' + J + 'SplitPart1 and j6.SplitPart2 = ' + J + 'SplitPart2 and j6.FactStartDate is not null and j6.FactFinishDate is not null)';
           Result := Result + ','#13#10 +
           'COALESCE(' + J + 'FactStartDate, ' + J + 'PlanStartDate),'#13#10 +
           'COALESCE(' + J + 'FactFinishDate, ' + J + 'PlanFinishDate),'#13#10 +
           '(select sum(datediff(second, COALESCE(j7.FactStartDate, j7.PlanStartDate), COALESCE(j7.FactFinishDate, j7.PlanFinishDate))) from Job j7 where j7.ItemID = opi.ItemID and j7.SplitPart1 = ' + J + 'SplitPart1 and j7.SplitPart2 = ' + J + 'SplitPart2)'#13#10;
           if FactExpr <> '' then
             Result := Result + '- (select ISNULL(sum(datediff(second, j8.FactStartDate, j8.FactFinishDate)), 0) from Job j8 where j8.ItemID = opi.ItemID and j8.SplitPart1 = ' + J + 'SplitPart1 and j8.SplitPart2 = ' + J + 'SplitPart2'#13#10 +
               ' and j8.FactStartDate is not null and j8.FactFinishDate is not null and j8.FactProductOut is not null)';
          Result := Result + ')'#13#10;
      Result := Result +
      // "по стороне", потом "по тиражу"
      'when opi.SplitMode1 = 2 and ' + J + 'SplitPart1 is not null and opi.SplitMode2 = 0 and ' + J + 'SplitPart2 is not null and ' + J + 'SplitPart3 is null then'#13#10 +
         'dbo.SplitCount(' + SelectExpr;
         if FactExpr <> '' then
             Result := Result + ' - (select ISNULL(sum(ISNULL(' + FactExpr + ', 0)), 0) from Job j9 where j9.ItemID = opi.ItemID and j9.SplitPart1 = ' + J + 'SplitPart1 and j9.FactStartDate is not null and j9.FactFinishDate is not null)';
           Result := Result + ','#13#10 +
           'COALESCE(' + J + 'FactStartDate, ' + J + 'PlanStartDate),'#13#10 +
           'COALESCE(' + J + 'FactFinishDate, ' + J + 'PlanFinishDate),'#13#10 +
           '(select sum(datediff(second, COALESCE(j10.FactStartDate, j10.PlanStartDate), COALESCE(j10.FactFinishDate, j10.PlanFinishDate))) from Job j10 where j10.ItemID = opi.ItemID and j10.SplitPart1 = ' + J + 'SplitPart1)'#13#10;
           if FactExpr <> '' then
             Result := Result + '- (select ISNULL(sum(datediff(second, j11.FactStartDate, j11.FactFinishDate)), 0) from Job j11 where j11.ItemID = opi.ItemID and j11.SplitPart1 = ' + J + 'SplitPart1'#13#10 +
                ' and j11.FactStartDate is not null and j11.FactFinishDate is not null and j11.FactProductOut is not null)';
          Result := Result + ')'#13#10;
      Result := Result +
      'else'#13#10 +
        SelectExpr + #13#10 +
      'end)'#13#10;
  if (FactExpr <> '') and FactPriority then
    Result := Result + 'else ' + FactExpr + #13#10 + 'end)';
  Result := Result + ' as ' + FieldAlias + #13#10;
end;

{$ENDREGION}

end.
