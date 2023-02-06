unit PmProduction;

interface

uses Classes, DB, DBClient, PmEntity, PmProcess, PmProcessCfg, DicObj, PmExecCode,
  NotifyEvent, PmProcessEntity, PmQueryPager, MainFilter, PmJobParams,
  PmOrderProcessItems;

type
  TProduction = class(TSplittableProcessEntity)
  private
    //FBeforeCfgChangeID: TNotifyHandlerID;
    //FCfgChangeID: TNotifyHandlerID;
    //FProductionSQL: string;
    FDataSetCreated: boolean;
    FHasWhere: boolean;
    FCalcFieldsScriptOK: boolean;
    FCriteria: TProductionFilterObj;
    procedure CreateDataSet;
    function GetItemID: Integer;
    function GetEstimatedDuration: Integer;
    function Production_GetProductionSQL(var HasWhere: boolean): TQueryObject;
    procedure GetDurationText(Sender: TField; var Text: String; DisplayText: Boolean);
    function GetIsPaused: boolean;
    function GetKindID: variant;
    function GetCreatorName: string;
    //function GetOrderID: Integer;
  protected
    procedure DoOnCalcFields; override;
    procedure DoBeforeOpen; override;
    procedure DoAfterOpen; override;
    procedure DefaultCalcFields;
    procedure DefaultCreateProductionData;
    //function GetProductionSQL(var HasWhere: boolean): TQueryObject;
    function CombineSQL(DefaultSQL, CustomSQL: TCustomSQL; var HasWhere: boolean): TQueryObject; override;
  public
    constructor Create(_EquipGroupCode: integer);
    destructor Destroy; override;
    //procedure SetViewRange(MakeActive: boolean); override;

    property EstimatedDuration: Integer read GetEstimatedDuration;
    property ItemID: Integer read GetItemID;
    property IsPaused: boolean read GetIsPaused;
    property KindID: variant read GetKindID;
    property CreatorName: string read GetCreatorName;
    //property OrderID: integer read GetOrderID;

    property Criteria: TProductionFilterObj read FCriteria write FCriteria;
  end;

implementation

uses Forms, SysUtils, Variants, Provider,
  RDBUtils, JvInterpreter, JvInterpreter_CustomQuery, PmOrder,
  ExHandler, CalcUtils, ProdData, PmDatabase,
  PlanUtils, StdDic, PmAccessManager, JvInterpreter_Schedule,
  PmContragent, PmConfigManager;

{$REGION 'TProduction - работы по группе оборудования'}

constructor TProduction.Create(_EquipGroupCode: integer);
var
  _DataSource: TDataSource;
  _DataSet: TDataSet;
  _Provider: TDataSetProvider;
begin
  if ProductionDM = nil then
    Application.CreateForm(TProductionDM, ProductionDM);

  _DataSource := CreateQueryExDM(ProductionDM, ProductionDM, 'Production_' + IntToStr(_EquipGroupCode),
    [{poAllowMultiRecordUpdates, poDisableInserts, poDisableDeletes, poDisableEdits}],
    upWhereKeyOnly, true {ResolveToDataSet}, Database.Connection, _Provider);
  _DataSet := _DataSource.DataSet;

  inherited Create('Production_' + IntToStr(_EquipGroupCode),
    F_JobID, _DataSet, _EquipGroupCode, {RequireEquipDic=} false);

  //FDataSource.Free;  // меняем на свой
  FDataSource := _DataSource;
  DataSetProvider := _Provider;

  RefreshAfterApply := true;
  FCalcFieldsScriptOK := true;  // иначе не будет работать calcfields

  SetLength(FDateFields, 5);
  FDateFields[0] := TOrderProcessItems.F_PlanStart;
  FDateFields[1] := TOrderProcessItems.F_FactStart;
  FDateFields[2] := TOrderProcessItems.F_PlanFinish;
  FDateFields[3] := TOrderProcessItems.F_FactFinish;
  FDateFields[4] := 'FinishDate';

  FNumberField := TOrder.F_OrderNumber;
end;

destructor TProduction.Destroy;
begin
  inherited Destroy;
end;

procedure TProduction.CreateDataSet;
begin
  // создаем стандартные
  DefaultCreateProductionData;
  //if not ExecCode(PlanScr_OnCreateProduction) then
  // и добавляем описанные сценарием
  ExecCode(PlanScr_OnCreateProduction);
  FDataSetCreated := true;
end;

procedure TProduction.DoBeforeOpen;
var
  wl, S: string;
  Q: TQueryObject;
begin
  if not FDataSetCreated then CreateDataSet;

  QueryObject := Production_GetProductionSQL(FHasWhere);
  if Criteria.FilterEnabled then
  begin
    if QueryObject.Where <> '' then
      wl := 'and '
    else
      wl := '';
    s := Criteria.GetFilterExpr(Self);
    if s <> '' then
    begin
      Q := QueryObject;
      Q.Where := Q.Where + #13#10 + wl + '(' + s + ')';
      QueryObject := Q;
    end;
  end;

  //QueryObject := GetProductionSQL(FHasWhere);
  SetQuerySQL(FDataSource, QueryObject.GetSQL);
end;

function TProduction.CombineSQL(DefaultSQL, CustomSQL: TCustomSQL;
  var HasWhere: boolean): TQueryObject;
begin
  Result := inherited CombineSQL(DefaultSQL, CustomSQL, HasWhere);
  Result.TableName := 'Job';
  Result.TableAlias := 'opi';
  Result.KeyFieldName := 'JobID';
  Result.IndexedView := 'EnabledMix';
end;

{function TProduction.GetProductionSQL(var HasWhere: boolean): TQueryObject;
var
  wl, S: string;
begin
  Result := Production_GetProductionSQL(FHasWhere);
  if Criteria.FilterEnabled then
  begin
    if Result.Where <> '' then
      wl := 'and '
    else
      wl := '';
    s := Criteria.GetFilterExpr(Self);
    if s <> '' then
      Result.Where := Result.Where + #13#10 + wl + '(' + s + ')';
  end;
end;}

procedure TProduction.DoAfterOpen;
begin
  // Поля, по которым можно сортировать
  TClientDataSet(DataSet).AddIndex('iOrderState', TOrder.F_OrderState, []);
  TClientDataSet(DataSet).AddIndex('i' + TOrder.F_OrderNumber, TOrder.F_OrderNumber, []);
  TClientDataSet(DataSet).AddIndex('iCustomerName', 'CustomerName', [ixCaseInsensitive]);
  TClientDataSet(DataSet).AddIndex('iPartName', F_PartName, [ixCaseInsensitive]);
  if DataSet.FindField('EquipName') <> nil then
    TClientDataSet(DataSet).AddIndex('iEquipName', 'EquipName', [ixCaseInsensitive]);
  if DataSet.FindField(TOrderProcessItems.F_ProductOut) <> nil then
    TClientDataSet(DataSet).AddIndex('iProductOut', TOrderProcessItems.F_ProductOut, [ixCaseInsensitive]);
  TClientDataSet(DataSet).AddIndex('iFinishDate', 'FinishDate', [ixCaseInsensitive]);
  TClientDataSet(DataSet).IndexDefs.Update;
  TClientDataSet(DataSet).IndexFieldNames := TOrder.F_OrderNumber;
end;

procedure TProduction.DoOnCalcFields;
var
  DataSetCode: TPlanCalcFieldsCode;
  FProcess: TPolyProcessCfg;
begin
  //if not FCalcFieldsScriptOK then
  DefaultCalcFields;
  // не выполнять больше если там ошибка
  if FCalcFieldsScriptOK then
  begin
    // Ищем процесс у которого есть сценарий вычисления полей
    if FindScript(FProcess, PlanScr_OnNotPlannedCalcFields) then
    begin
      DataSetCode := TPlanCalcFieldsCode.Create(DataSet, FProcess, PlanScr_OnNotPlannedCalcFields);
      try
        DataSetCode.OnScriptError := FOnScriptError;
        DataSetCode.DayMode := true;
        DataSetCode.NoPlanMode := false;
        DataSetCode.DataSet := DataSet;
        ScheduleCodeContext.JobEntity := Self;
        FCalcFieldsScriptOK := DataSetCode.ExecCode;
      finally
        DataSetCode.Free;
      end;
    end;
  end;
end;

procedure TProduction.DefaultCalcFields;
begin
  // вычисляемые поля, по которым можно сортировать
  if DataSet.State = dsCalcFields then
  begin
    if DataSet.FindField('EquipName') <> nil then
    begin
      if VarIsNull(DataSet['EquipCode']) then DataSet['EquipName'] := ''
      else DataSet['EquipName'] := TConfigManager.Instance.StandardDics.deEquip.ItemName[DataSet['EquipCode']];
    end;

    if VarIsNull(DataSet[F_Part]) then
      DataSet[F_PartName] := ''
    else
      //DataSet[F_PartName] := TConfigManager.Instance.StandardDics.deParts.ItemName[DataSet[F_Part]];
      DataSet[F_PartName] := PlanUtils.GetPartName(Part, SplitMode1, SplitMode2, SplitMode3,
        SplitPart1, SplitPart2, SplitPart3, true);

    // Состояние выполнения
    DataSet['ExecState'] := CalcExecState(DataSet);
    //CalcDuration(DataSet);

    if VarIsNull(DataSet['DateTimeDecomposed']) then
    begin
      //DataSet['PlanStartDate_ICalc'] := DataSet['PlanStartDate'];
      DataSet['PlanStartTime_ICalc'] := DataSet['PlanStartDate'];
      //DataSet['PlanFinishDate_ICalc'] := DataSet['PlanFinishDate'];
      DataSet['PlanFinishTime_ICalc'] := DataSet['PlanFinishDate'];

      //DataSet['FactStartDate_ICalc'] := DataSet['FactStartDate'];
      DataSet['FactStartTime_ICalc'] := DataSet['FactStartDate'];
      //DataSet['FactFinishDate_ICalc'] := DataSet['FactFinishDate'];
      DataSet['FactFinishTime_ICalc'] := DataSet['FactFinishDate'];

      DataSet['DateTimeDecomposed'] := true;
    end;
  end;
end;

procedure TProduction.DefaultCreateProductionData;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_OrderState;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  //f.Origin := 'opi.ExecState';  // Это надо для корректной выборки

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'ExecState';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  //f.Origin := 'opi.ExecState';  // Это надо для корректной выборки
  f.FieldKind := fkInternalCalc;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'OrderID';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_ItemID;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_JobID;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'KindID';
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
  f.ReadOnly := true;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'ItemDesc';
  f.DataSet := DataSet;
  f.Size := 150;
  f.Name := DataSet.Name + f.FieldName;
  f.ReadOnly := true;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_ProductOut;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ReadOnly := true;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'EquipCode';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ReadOnly := true;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_Part;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ReadOnly := true;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'FinishDate';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm';

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_PlanFinish;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm hh:nn';

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_PlanStart;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm hh:nn';

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_FactStart;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm hh:nn';

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_FactFinish;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm hh:nn';

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'EstimatedDuration';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := 'IsPaused';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'Executor';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_FactProductOut;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'FactOrderFinishDate';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm';
  //f.Origin := 'wo.FactFinishDate';  // Это надо для корректной выборки

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'Customer';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TFloatField.Create(DataSet.Owner);
  f.FieldName := 'Multiplier';
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
  f.FieldName := 'ProcessID';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  TBCDField(f).Precision := 18;
  TBCDField(f).Size := 2;
  f.FieldName := 'Cost';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_CreatorName;
  f.Size := TOrder.CreatorNameSize;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  // Теперь вычисляемые поля

  {f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'PrinterName';
  f.FieldKind := fkInternalCalc;
  f.Size := 50;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;}

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_PartName;
  f.FieldKind := fkInternalCalc;
  f.Size := 50;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  // Plan
{  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'PlanStartDate_ICalc';
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm.yyyy';
  //f.OnGetText := MyDateGetText;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'PlanFinishDate_ICalc';
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm.yyyy';}
  //f.OnGetText := MyDateGetText;

  f := TDateTimeField.Create(DataSet.Owner);
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

  // Fact
  {f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'FactStartDate_ICalc';
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm.yyyy';
  //f.OnGetText := MyDateGetText;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'FactFinishDate_ICalc';
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'dd.mm.yyyy';}
  //f.OnGetText := MyDateGetText;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'FactStartTime_ICalc';
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'hh:nn';
  //f.OnGetText := MyTimeGetText;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'FactFinishTime_ICalc';
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  TDateTimeField(f).DisplayFormat := 'hh:nn';
  //f.OnGetText := MyTimeGetText;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := 'DateTimeDecomposed';
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_PlanDuration;
  //f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.OnGetText := GetDurationText;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrderProcessItems.F_FactDuration;
  //f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.OnGetText := GetDurationText;
end;

procedure TProduction.GetDurationText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  //Text := PlanUtils.GetDurationText(Sender.Value);
  if VarIsNull(Sender.Value) then
    Text := ''
  else
    Text := FormatTimeValue(Sender.Value);
end;

function TProduction.Production_GetProductionSQL(var HasWhere: boolean): TQueryObject;
var
  CustomSQL, DefaultSQL: TCustomSQL;
begin
  CustomSQL := ExecGetSQLCode(PmProcess.PlanScr_OnGetProductionSQL, 0);
  {DefaultSQL.Select := 'opi.OrderID, cc.Name as CustomerName, j.JobID, ' +
    ' opi.Part, j.EquipCode, wo.Comment, wo.ID_Number, opi.ItemDesc, ' +
    ' opi.SplitMode1, opi.SplitMode2, opi.SplitMode3, j.SplitPart1, j.SplitPart2, j.SplitPart3, ' +
    #13#10 +
    GetSplitCountExpr('opi.ProductOut', 'ProductOut', 'FactProductOut') + ',' +
    #13#10 +
    ' wo.FinishDate, wo.FactFinishDate as FactOrderFinishDate, wo.Customer, wo.KindID,' +
    ' j.PlanStartDate, j.PlanFinishDate, j.FactStartDate, j.FactFinishDate,' +
    ' opi.ProcessID, opi.ItemID, wo.OrderState, opi.EstimatedDuration, j.IsPaused, j.Executor, j.FactProductOut,' +
    #13#10 +
    //' dbo.SplitCost(opi.SplitMode1, opi.SplitMode3, opi.SplitMode3, opi.OwnCost + opi.ItemProfit, j.PlanStartDate, j.PlanFinishDate, ' +
    //    ' (select sum(datediff(second, j3.PlanStartDate, j3.PlanFinishDate)) from Job j3 where j3.ItemID = j.ItemID)) as Cost';
    ' opi.OwnCost + opi.ItemProfit as Cost';
  DefaultSQL.From := 'inner join OrderProcessItem opi on j.ItemID = opi.ItemID' +
    ' inner join WorkOrder wo on wo.N = opi.OrderID' +
    ' inner join Customer cc on cc.N = wo.Customer' +
    ' inner join Services ss on ss.SrvID = opi.ProcessID';}
  DefaultSQL.Select := 'opi.OrderID, opi.CustomerName, opi.JobID,'#13#10 +
    ' opi.Part, opi.EquipCode, opi.Comment, opi.ID_Number, opi.ItemDesc, opi.Multiplier,'#13#10 +
    ' opi.SplitMode1, opi.SplitMode2, opi.SplitMode3, opi.SplitPart1, opi.SplitPart2, opi.SplitPart3,'#13#10 +
    ' DATEDIFF(minute, FactStartDate, FactFinishDate) as FactDuration,'#13#10 +
    ' DATEDIFF(minute, PlanStartDate, PlanFinishDate) as PlanDuration,'#13#10 +
    GetSplitCountExpr('opi.ProductOut', 'ProductOut', TOrderProcessItems.F_FactProductOut, 'opi', true) + ','#13#10 +
    ' opi.FinishDate, opi.FactFinishDate as FactOrderFinishDate, opi.Customer,'#13#10 +
    ' opi.PlanStartDate, opi.PlanFinishDate, opi.FactStartDate, opi.FactFinishDate,'#13#10 +
    ' opi.ProcessID, opi.ItemID, opi.OrderState, opi.EstimatedDuration, opi.IsPaused, opi.Executor, opi.FactProductOut, opi.KindID, opi.CreatorName,'#13#10 +
    //' dbo.SplitCost(opi.SplitMode1, opi.SplitMode3, opi.SplitMode3, opi.OwnCost + opi.ItemProfit, opi.PlanStartDate, opi.PlanFinishDate, ' +
    //    ' (select sum(datediff(second, j3.PlanStartDate, j3.PlanFinishDate)) from Job j3 where j3.ItemID = opi.ItemID)) as Cost';
    ' opi.OwnCost + opi.ItemProfit as Cost';
  {DefaultSQL.Where := '(((ss.DefaultEquipGroupCode = ' + IntToStr(EquipGroupCode) + ' and (opi.EquipCode is null or opi.EquipCode = 0))' + #13#10 +
    '  or (opi.EquipCode is not null and opi.EquipCode in (select Code from Dic_Equip where A1 = ' + IntToStr(EquipGroupCode) + ')))' + #13#10 +
    '  and wo.IsDeleted = 0 and opi.Enabled = 1 and wo.IsDraft = 0)';}
  DefaultSQL.Where := '((opi.DefaultEquipGroupCode = ' + IntToStr(EquipGroupCode) + ' and (opi.EquipCode is null or opi.EquipCode = 0))'#13#10 +
    '  or (opi.EquipCode is not null and opi.EquipCode in (select Code from Dic_Equip where A1 = ' + IntToStr(EquipGroupCode) + ')))'#13#10;
  Result := CombineSQL(DefaultSQL, CustomSQL, FHasWhere);
end;

function TProduction.GetEstimatedDuration: Integer;
begin
  Result := NvlInteger(DataSet['EstimatedDuration']);
end;

function TProduction.GetIsPaused: boolean;
begin
  Result := DataSet['IsPaused'];
end;

{function TProduction.GetOrderID: Integer;
begin
  Result := DataSet['OrderID'];
end;}

function TProduction.GetItemID: Integer;
begin
  Result := KeyValue;
end;

function TProduction.GetKindID: variant;
begin
  Result := DataSet['KindID'];
end;

function TProduction.GetCreatorName: string;
begin
  Result := VarToStr(DataSet[TOrder.F_CreatorName]);
end;

{procedure TProduction.SetViewRange(MakeActive: boolean);
var
  wl, S, OldSQL: string;
begin
  OldSQL := FProductionSQL;

  FProductionSQL := Production_GetProductionSQL(FHasWhere);
  if ProductionFilter.FilterEnabled then
  begin
        if FHasWhere then wl := 'and '
        else wl := 'where ';
        s := ProductionFilter.GetFilterExpr(Self);
        if s <> '' then FProductionSQL := FProductionSQL + #13#10 + wl + '(' + s + ')';
  end;

  s := ProductionFilter.LocalFilter;
  if s <> '' then
  begin
    DataSet.Filter := s;
    DataSet.Filtered := true;
  end
  else
    DataSet.Filtered := false;

  if MakeActive then
    if OldSQL <> FProductionSQL then  // мог поменяться только локальный фильтр
      Reload;
end;}

{$ENDREGION}

end.
