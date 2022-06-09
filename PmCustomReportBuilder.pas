unit PmCustomReportBuilder;

interface

uses SysUtils, Classes, DB, Provider, ComObj, JvJCLUtils, DBClient,
  DicObj, ADODB, Controls, JvInterpreter,

  ExHandler, PmDictionaryList, PmContragent, PmEntity, PmOrder,
  PmOrderInvoiceItems, PmCustomReportCommon, PmOrderPayments, PmProcessCfg,
  PmReportData, PmShipment, MainFilter;

type
  TLookupInfo = class
    ProcessID: integer;
    FieldName, KeyFieldName: string;
    Dic: TDictionary;
  public
    constructor Create(_ProcessID: integer; _FieldName, _KeyFieldName: string; DicID: integer);
    function GetResultValue(KeyValue: variant): variant;
  end;

  TFilterContext = record
    FieldName: string;
    FieldValue: variant;
    ProcessID: integer;
    ProcessData: TDataSet;
  end;

  TCustomReportBuilder = class
  private
    AllOrderIDs: string;
    CurRow: integer;
    FDetailedProcesses: Boolean;
    FIncludeEmptyDetails: Boolean;
    FRepeatOrderFields: Boolean;
    MaxProcessRow: integer;
    ProcessQueryCount: integer;
    ProcessQuery: array[1..100] of TDataSource;
    ProcessQueryID: array[1..100] of integer;
    MaterialQuery: array[1..100] of TDataSource;
    cdReport: TClientDataSet;
    CurrentOrderID: Integer;
    LastRowID: integer;
    Hdr: string;
    ProcessCount: integer;
    FGroupIndexName: string;
    FOrderIndexName: string;
    FDefaultIndexName: string;
    FGroupIndexFieldsCount: integer;
    FGroupAggList, FOrderAggList, FTotalAggList: TList;
    FGroupIndexFields: string;
    Lookups: TList;
    LastRow: Boolean;
    FFilterContext: TFilterContext;
    FOrder: TOrder;
    FReportFieldList: TList;
    FInvoiceItems: TOrderInvoiceItems;
    FOrderPayments: TOrderPayments;
    FOrderShipment: TShipment;
    FOrderShipmentCriteria: TShipmentFilterObj;
    procedure PrepareInvoiceItems;
    procedure PrepareOrderPayments;
    procedure PrepareOrderShipment;
    procedure CreateReportData;
    function CheckFilter(Filter: variant): boolean;
    procedure CloseCustomSQL;
    procedure DoBuild(Sender: TObject);
    procedure DoneLookups;
    function GetFieldName(BaseName, FieldName: string; Col: integer): string;
    function GetLookup(FieldName: string; ProcessID: integer): TLookupInfo;
    procedure GetOrderIDs;
    function IsItemParam(FieldName: string): boolean;
    function OpenCustomSQL(ProcessID, OrderID: integer; var MatData: TClientDataSet): TClientDataSet;
    function PrepareCustomSQL(ProcessID: integer): TClientDataSet;
    procedure ProcessOrderFields(RowCount: integer);
    function ProcessDetails: boolean;
    function GetFieldValue(PrcData: TDataSet; ProcessID: integer; FName: string): variant;
    procedure ReportBeforeInsert(DataSet: TDataSet);
    procedure ReportNewRecord(DataSet: TDataSet);
    procedure LocateRowForEdit(Row: integer);
    procedure SetCell(Row, Col: integer; Value: variant);
    function GetTotal(ProcessID: integer; AggName: string): variant;
    procedure InitLookups;
    function LocateRow(RowID: integer): Boolean;
    procedure ProcessOrderAggregates;
    procedure ProcessGroupAggregates;
    procedure ProcessTotalAggregates;
    procedure ProcessSortFields;
    procedure ExprGetValue(Sender: TObject; Identifier: String;
      var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
    procedure InitFieldSequenceList;
    function ContainsSpecialOrderFields: boolean;
    function ReportContainsField(FieldName: string): boolean;
  public
    destructor Destroy; override;
    function Build(_Order: TOrder): TReportData;
    function ExecCustomReport(_Order: TOrder; ReportID: integer): TReportData;
    property IncludeEmptyDetails: Boolean read FIncludeEmptyDetails write
        FIncludeEmptyDetails;
    property DetailedProcesses: Boolean read FDetailedProcesses write
        FDetailedProcesses;
    property RepeatOrderFields: Boolean read FRepeatOrderFields write
        FRepeatOrderFields;
  end;

var
  CustomReportBuilder: TCustomReportBuilder;

implementation

uses Variants, Forms, Dialogs, TLoggerUnit,

  PmCustomReport, JvInterpreter_CustomQuery, fCanRep,
  ServData, RDBUtils, PmProcess, MainData, RDialogs,
  StdDic, PmDatabase, PmConfigManager,
  PmOrderProcessItems, PmMaterials;

const
  CurrentFieldIdentifier = 'Value';

function TCustomReportBuilder.ExecCustomReport(_Order: TOrder; ReportID: integer): TReportData;
var
  Msg: string;
begin
  CustomReports.Open;
  if CustomReports.Locate(ReportID) then
  begin
    Msg := 'Запуск польз. отчета ' + CustomReports.ReportCaption;
    TLogger.getInstance.Info(Msg);
    dm.AddEventToHistory(GlobalHistory_Info, Msg, ReportID);

    IncludeEmptyDetails := CustomReports.IncludeEmptyDetails;
    DetailedProcesses := CustomReports.ProcessDetails;
    RepeatOrderFields := CustomReports.RepeatOrderFields;
    Result := Build(_Order);
  end
  else
    raise Exception.Create('Не найден отчет с номером ' + IntToStr(ReportID));
end;

destructor TCustomReportBuilder.Destroy;
begin
  FInvoiceItems.Free;
  FOrderPayments.Free;
  FOrderShipment.Free;
  FOrderShipmentCriteria.Free;
  inherited;
end;

function TCustomReportBuilder.Build(_Order: TOrder): TReportData;
begin
//ProfilerStart;
  FOrder := _Order;
  try
    InitCustomSQL;
    InitLookups;
    ProcessQueryCount := 0;
    try
      OpenReportProgressForm(DoBuild, nil);
    finally
      //CloseReportProgressForm;  сама закроется
      if FOrder.DataSet.ControlsDisabled then FOrder.DataSet.EnableControls;
      //FreeCustomSQL; nothing to free
      DoneCustomSQL;
      DoneLookups;
    end;

    if not cdReport.Active then
    begin
      Result := nil;
      Exit;  // если построить не удалось
    end;

    ProcessOrderAggregates;
    ProcessGroupAggregates;
    ProcessTotalAggregates;

    cdReport.First;
    Result := TReportData.Create(cdReport, FReportFieldList);
  finally
    if FGroupAggList <> nil then FreeAndNil(FGroupAggList);
    if FOrderAggList <> nil then FreeAndNil(FOrderAggList);
    if FTotalAggList <> nil then FreeAndNil(FTotalAggList);
  end;

//ProfilerStop;
end;

function TCustomReportBuilder.ReportContainsField(FieldName: string): boolean;
begin
  Result := CustomReports.Details.DataSet.Locate('FieldName', FieldName, []);
end;

function TCustomReportBuilder.ContainsSpecialOrderFields: boolean;
begin
  Result := ReportContainsField(TOrder.F_TotalExpenseCost)
    or ReportContainsField(TOrder.F_TotalOrderProfitCost);
end;

procedure TCustomReportBuilder.DoBuild(Sender: TObject);
var
  i: integer;
  IDCount: integer;
  SaveAfterScroll: TDataSetNotifyEvent;
begin
  // Отключаем обработку события, чтобы детализация не обновлялась - она не нужна.
  SaveAfterScroll := FOrder.DataSet.AfterScroll;
  FOrder.DataSet.AfterScroll := nil;
  FOrder.DataSet.DisableControls;
  try
    if ContainsSpecialOrderFields then
    begin
      FOrder.FetchAllReportData;
    end
    else
      if FOrder.UsePager then
        FOrder.FetchAllRecords; // загружаем все данные в режиме постраничной выборки

    if CustomReports.ProcessDetails and not CustomReports.Details.IsEmpty then
      GetOrderIDs;   // сохраняем ключи всех записей текущей выборки во временной таблице
    CreateReportData;
    CancelRepForm.MaxProgress := FOrder.DataSet.RecordCount;

    CurRow := 1;
    IDCount := WordCount(AllOrderIDs, [',']);
    if IDCount > 0 then
    begin
      for i := 1 to IDCount do
      begin
        Application.ProcessMessages;
        if XLCancelled then break;

        CurrentOrderID := StrToInt(ExtractWord(i, AllOrderIDs, [',']));

        if FOrder.Locate(CurrentOrderID) then
        begin
          if ProcessCount > 0 then
          begin
            if ProcessDetails then
            begin
              ProcessOrderFields(MaxProcessRow - CurRow + 1);
              CurRow := MaxProcessRow + 1;
            end;
          end
          else
          begin
            ProcessOrderFields(1);
            Inc(CurRow);
          end;
        end;
        CancelRepForm.Progress := i;
      end;
    end;
  finally
    FOrder.DataSet.AfterScroll := SaveAfterScroll;
    FOrder.DataSet.EnableControls;
  end;
end;

function TCustomReportBuilder.CheckFilter(Filter: variant): boolean;
var
  FilterExpr: string;
  Expr: TJvInterpreterExpression;
begin
  Result := true;
  FilterExpr := Trim(NvlString(Filter));
  if FilterExpr <> '' then
  begin
    Expr := TJvInterpreterExpression.Create(nil);
    Expr.OnGetValue := ExprGetValue;
    try
    try
      Expr.Source := FilterExpr;
      Expr.Run;
      if VarType(Expr.VResult) <> varBoolean then
      begin
        Result := RusMessageDlg('Выражение фильтра ''' + FilterExpr + ''' должно возвращать логический результат'
          + #13'Продолжить формирование отчета?', mtError, [mbYes, mbNo], 0) = mrYes;
        if not Result then ExceptionHandler.RaiseMessage('Формирование отчета прервано');
      end else
        Result := Expr.VResult;
    except on e: Exception do
      begin
        Result := RusMessageDlg('Некорректное выражение в фильтре: ''' + FilterExpr + '''.'
          + #13 + e.Message + #13
          + #13'Продолжить формирование отчета?', mtError, [mbYes, mbNo], 0) = mrYes;
        if not Result then ExceptionHandler.RaiseMessage('Формирование отчета прервано');
      end;
    end;
    finally
      Expr.Free;
    end;
  end;
end;

procedure TCustomReportBuilder.ExprGetValue(Sender: TObject; Identifier: String;
  var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
begin
  Done := true;
  if AnsiCompareText(Identifier, CurrentFieldIdentifier) = 0 then
    Value := FFilterContext.FieldValue//GetFieldValue(FFilterContext.ProcessData, FFilterContext.FieldName)
  else
    Value := GetFieldValue(FFilterContext.ProcessData, FFilterContext.ProcessID, Identifier);
end;

procedure TCustomReportBuilder.CloseCustomSQL;
var
  I: Integer;
begin
  if ProcessQueryCount > 0 then
    for I := 1 to ProcessQueryCount do
    begin
      if ProcessQuery[i].DataSet.Active then
        ProcessQuery[i].DataSet.Close;
      if MaterialQuery[i].DataSet.Active then
        MaterialQuery[i].DataSet.Close;
    end;
end;

procedure TCustomReportBuilder.DoneLookups;
var i: integer;
begin
  if Lookups.Count > 0 then
    for i := 0 to Lookups.Count - 1 do
      TLookupInfo(Lookups[i]).Free;
  Lookups.Free;
end;

function TCustomReportBuilder.GetTotal(ProcessID: integer; AggName: string): variant;
var
  PrcData, MatData: TClientDataSet;
begin
  PrcData := OpenCustomSQL(ProcessID, CurrentOrderID, MatData);
  PrcData.AggregatesActive := true;
  try
    Result := PrcData[AggName];
  except
    Result := 'ОШИБКА';
  end;
end;

function TCustomReportBuilder.IsItemParam(FieldName: string): boolean;
begin
  Result := false;
  //Result := IsWordPresent(AnsiUpperCase(FieldName), AnsiUpperCase(ProcessPredefVirtualFieldsStr), [','])
  //  or (FieldName = F_ContractorName) or (FieldName = F_ItemDesc);
end;

function TCustomReportBuilder.OpenCustomSQL(ProcessID, OrderID: integer; var MatData: TClientDataSet): TClientDataSet;
var
  I: Integer;
  FilterExpr: string;
  ICriteria: TOrderInvoiceItemsCriteria;
  PCriteria: TOrderPaymentsCriteria;
begin
  ICriteria := TOrderInvoiceItemsCriteria.Default;
  Result := nil;
  if ProcessID = OrderDetails_InvoiceItems then
  begin
    if not FInvoiceItems.Active then
    begin
      ICriteria.Mode := TOrderInvoiceItemsCriteria.Mode_TempTable;
      FInvoiceItems.Criteria := ICriteria;
      FInvoiceItems.Reload;
    end;
    Result := FInvoiceItems.DataSet as TClientDataSet;
    FilterExpr := 'OrderID = ' + IntToStr(OrderID);
    if FilterExpr <> Result.Filter then Result.Filter := FilterExpr;
    Result.Filtered := true;
  end
  else if ProcessID = OrderDetails_Payments then
  begin
    if not FOrderPayments.Active then
    begin
      PCriteria.Mode := TOrderPaymentsCriteria.Mode_TempTable;
      FOrderPayments.Criteria := PCriteria;
      FOrderPayments.Reload;
    end;
    Result := FOrderPayments.DataSet as TClientDataSet;
    FilterExpr := 'OrderID = ' + IntToStr(OrderID);
    if FilterExpr <> Result.Filter then Result.Filter := FilterExpr;
    Result.Filtered := true;
  end
  else if ProcessID = OrderDetails_Shipment then
  begin
    if not FOrderShipment.Active then
    begin
      FOrderShipmentCriteria.Mode := TShipmentFilterObj.Mode_TempTable;
      FOrderShipment.Reload;
    end;
    Result := FOrderShipment.DataSet as TClientDataSet;
    FilterExpr := 'OrderID = ' + IntToStr(OrderID);
    if FilterExpr <> Result.Filter then Result.Filter := FilterExpr;
    Result.Filtered := true;
  end
  else
  begin
    if ProcessQueryCount > 0 then
    for I := 1 to ProcessQueryCount do
      if ProcessID = ProcessQueryID[i] then
      begin
        Result := ProcessQuery[i].DataSet as TClientDataSet;
        MatData := MaterialQuery[i].DataSet as TClientDataSet;
        if not Result.Active then
        begin
          // Открываем сразу для всех заказов в текущей выборке, номера которых мы
          // сохранили во временной таблице а потом фильтруем
          SetQuerySQL(ProcessQuery[i], 'select * from Service_'
            + TConfigManager.Instance.ServiceByID(ProcessID).TableName + ' srv inner join OrderProcessItemJobs opi '
            + 'inner join #OrderIDs ids on opi.OrderID = ids.OrderID on srv.ItemID = opi.ItemID where Enabled = 1');
            // and opi.OrderID in (' + AllOrderIDs + ')');
          Database.OpenDataSet(Result);
          SetQuerySQL(MaterialQuery[i], 'select opi.OrderID, MatTypeName, SupplierID, sp.Name as SupplierName, FactMatAmount, FactMatCost, PlanReceiveDate, FactReceiveDate'
            + ' from OrderProcessItemMaterial mat inner join OrderProcessItem opi on opi.ItemID = mat.ItemID'
            + ' inner join #OrderIDs ids on opi.OrderID = ids.OrderID'
            + ' left join Customer sp on sp.N = mat.SupplierID'
            + ' where Enabled = 1 and opi.ProcessID = ' + VarToStr(ProcessID));
          Database.OpenDataSet(MatData);
        end;
        FilterExpr := 'OrderID = ' + IntToStr(OrderID);

        if FilterExpr <> Result.Filter then
          Result.Filter := FilterExpr;
        Result.Filtered := true;

        if FilterExpr <> MatData.Filter then
          MatData.Filter := FilterExpr;
        MatData.Filtered := true;
      end;
    if Result = nil then
      raise Exception.Create('Процесс ' + TConfigManager.Instance.ServiceByID(ProcessID).ServiceName
        + ' не найден в таблице запросов');
  end;
end;

function TCustomReportBuilder.PrepareCustomSQL(ProcessID: integer): TClientDataSet;
var
  I: Integer;
begin
  // если для этого процесса уже создан запрос то его возвращаем
  if ProcessQueryCount > 0 then
    for I := 1 to ProcessQueryCount do
    begin
      if ProcessID = ProcessQueryID[i] then
      begin
        Result := ProcessQuery[i].DataSet as TClientDataSet;
        Exit;
      end;
    end;
  Inc(ProcessQueryCount);
  ProcessQuery[ProcessQueryCount] := CreateQueryEx(TConfigManager.Instance.ServiceByID(ProcessID).TableName,
    [poDisableInserts, poDisableDeletes], upWhereKeyOnly, true);
  MaterialQuery[ProcessQueryCount] := CreateQueryEx(TConfigManager.Instance.ServiceByID(ProcessID).TableName + 'Materials',
    [poDisableInserts, poDisableDeletes], upWhereKeyOnly, true);
  ProcessQueryID[ProcessQueryCount] := ProcessID;
  Result := ProcessQuery[ProcessQueryCount].DataSet as TClientDataSet;
end;

procedure TCustomReportBuilder.PrepareInvoiceItems;
begin
  if FInvoiceItems = nil then
    FInvoiceItems := TOrderInvoiceItems.Create
  else if FInvoiceItems.Active then
    FInvoiceItems.Close;   
end;

procedure TCustomReportBuilder.PrepareOrderPayments;
begin
  if FOrderPayments = nil then
    FOrderPayments := TOrderPayments.Create
  else if FOrderPayments.Active then
    FOrderPayments.Close;
end;

procedure TCustomReportBuilder.PrepareOrderShipment;
begin
  if FOrderShipment = nil then
  begin
    FOrderShipment := TShipment.Create;
    FOrderShipmentCriteria := TShipmentFilterObj.Create;
    FOrderShipmentCriteria.Mode := TShipmentFilterObj.Mode_TempTable;
    FOrderShipment.Criteria := FOrderShipmentCriteria;
  end
  else if FOrderShipment.Active then
    FOrderShipment.Close;
end;


procedure TCustomReportBuilder.LocateRowForEdit(Row: integer);
begin
  // Этот метод критичен для скорости выполнения!
  if cdReport.IsEmpty or (cdReport[TReportData.F_RowID] <> Row) then
  begin
    // Если стоим на последней, а нужна с бОльшим номером, тоже ничего не ищем
    if cdReport.IsEmpty or (LastRow and (Row > cdReport[TReportData.F_RowID]))
       or not LocateRow(Row) then begin
      // Если строка с этим номером не найдена, добавляем одну строку
      cdReport.Last;
      if (cdReport.IsEmpty and (Row = 1)) or (cdReport[TReportData.F_RowID] = Row - 1) then
      begin
        cdReport.Append;
        LastRow := true;
        // записываем ключ текущего заказа
        if VarIsNull(cdReport[TOrderProcessItems.F_OrderID]) then
          cdReport[TOrderProcessItems.F_OrderID] := CurrentOrderID;
      end else
        raise Exception.Create('Строка ' + IntToStr(Row) + ' не найдена');
    end else
      cdReport.Edit;
  end else
    cdReport.Edit;
end;

function TCustomReportBuilder.LocateRow(RowID: integer): Boolean;
begin
  // Этот метод критичен для скорости выполнения!
  // Locate - Очень дорогая операция!
  cdReport.MoveBy(RowID - cdReport[TReportData.F_RowID]);
  if cdReport.Eof or (RowID <> cdReport[TReportData.F_RowID]) then
    Result := cdReport.Locate(TReportData.F_RowID, RowID, [])
  else
    Result := true;
  LastRow := false;
end;

procedure TCustomReportBuilder.ProcessOrderFields(RowCount: integer);
var
  I, CurCol: Integer;
  cdDetails: TDataSet;
  FName: string;
  FValue: variant;
begin
  cdDetails := CustomReports.Details.DataSet;
  CurCol := 1;
  cdDetails.First;
  while not cdDetails.eof do
  begin
    FName := cdDetails['FieldName'];
    if cdDetails['FieldSourceType'] = fstOrder then
    begin

      if FName = 'ClientTotalGrn' then
        FValue := FOrder.FinalCostGrn //FOrder.ClientTotal * FOrder.USDCourse
      else if FName = TOrder.F_KindName then
        FValue := sdm.cdOrderKind.Lookup(TOrder.F_KindID, FOrder.KindID, OrderKindDescField)
      else if FName = 'CostOf1Grn' then
        FValue := FOrder.CostOf1 * FOrder.USDCourse
      else if (FName = TOrder.F_OrderState) and (FOrder.DataSet.FindField(FName) <> nil) then
        FValue := TConfigManager.Instance.StandardDics.deOrderState.ItemName[FOrder.DataSet[FName]]
      else if (FName = TOrder.F_PayState) and (FOrder.DataSet.FindField(FName) <> nil) then
        FValue := TConfigManager.Instance.StandardDics.dePayState.ItemName[FOrder.DataSet[FName]]
      else if FOrder.DataSet.FindField(FName) = nil then
        // Если такого поля нет, то пустая строка. Его может не быть, например, в расчете.
        FValue := ''
      else
        FValue := FOrder.DataSet[FName];

      if FRepeatOrderFields then
      begin
        for i := 0 to RowCount - 1 do
          SetCell(CurRow + i, CurCol, FValue)
      end
      else
        SetCell(CurRow, CurCol, FValue);
    end;
    Inc(CurCol);
    cdDetails.Next;
  end;
  cdReport.CheckBrowseMode;  // 21.01.2009
end;

function TCustomReportBuilder.GetFieldValue(PrcData: TDataSet; ProcessID: integer;
  FName: string): variant;
var
  LookupInfo: TLookupInfo;
  FValue: variant;
begin
  // Обрабатывем вычисляемые по справочникам поля
  LookupInfo := GetLookup(FName, ProcessID);
  if LookupInfo <> nil then
    FValue := LookupInfo.GetResultValue(PrcData[LookupInfo.KeyFieldName])
  else
  // Во всех этих стоимостях учитываются ВСЕ наценки
  if FName = TOrderProcessItems.F_EnabledWorkCost then
    {FValue := NvlFloat(PrcData[F_ContractorCost]) * (1 + NvlFloat(PrcData[F_ContractorPercent]) / 100.0)
      + NvlFloat(PrcData[F_OwnCost]) * (1 + NvlFloat(PrcData[F_OwnPercent]) / 100.0)}
    FValue := NvlFloat(PrcData[TOrderProcessItems.F_Cost]) + NvlFloat(PrcData[TOrderProcessItems.F_ItemProfit])
      - NvlFloat(PrcData[TOrderProcessItems.F_MatCost]) * (1 + NvlFloat(PrcData[TOrderProcessItems.F_MatPercent]) / 100.0)
  else if FName = TOrderProcessItems.F_Cost then
    FValue := NvlFloat(PrcData[TOrderProcessItems.F_Cost]) + NvlFloat(PrcData[TOrderProcessItems.F_ItemProfit])
  else if FName = TOrderProcessItems.F_ContractorCost then
  begin
    //FValue := NvlFloat(PrcData[F_ContractorCost]) * (1 + NvlFloat(PrcData[F_ContractorPercent]) / 100.0)
    if NvlBoolean(PrcData[TOrderProcessItems.F_ContractorProcess]) then
      FValue := NvlFloat(PrcData[TOrderProcessItems.F_Cost]) + NvlFloat(PrcData[TOrderProcessItems.F_ItemProfit])
        - NvlFloat(PrcData[TOrderProcessItems.F_MatCost]) * (1 + NvlFloat(PrcData[TOrderProcessItems.F_MatPercent]) / 100.0)
    else
      FValue := 0;
  end
  else if FName = TOrderProcessItems.F_FactContractorCost then
  begin
    if NvlBoolean(PrcData[TOrderProcessItems.F_ContractorProcess]) then
    begin
      // Если есть фактическая, то берем ее, иначе расчетную
      if not VarIsNull(PrcData[TOrderProcessItems.F_FactContractorCost]) then
        FValue := PrcData[TOrderProcessItems.F_FactContractorCost]
      else
        //FValue := NvlFloat(PrcData[F_ContractorCost]) * (1 + NvlFloat(PrcData[F_ContractorPercent]) / 100.0);
        FValue := NvlFloat(PrcData[TOrderProcessItems.F_Cost]) + NvlFloat(PrcData[TOrderProcessItems.F_ItemProfit])
          - NvlFloat(PrcData[TOrderProcessItems.F_MatCost]) * (1 + NvlFloat(PrcData[TOrderProcessItems.F_MatPercent]) / 100.0);
    end
    else
      FValue := 0;
  end
  else if FName = TOrderProcessItems.F_MatCost then  // в нац. валюте
    FValue := NvlFloat(PrcData[TOrderProcessItems.F_MatCost]) * FOrder.USDCourse
       * (1 + NvlFloat(PrcData[TOrderProcessItems.F_MatPercent]) / 100.0)
    {FValue := NvlFloat(PrcData[F_MatCost]) * (1 + NvlFloat(PrcData[TOrderProcessItems.F_ItemProfit]) /
    //PrcData[F_Cost])
    (NvlFloat(PrcData[F_ContractorCost]) + NvlFloat(PrcData[F_OwnCost])
      + NvlFloat(PrcData[F_MatCost]) + NvlFloat(PrcData[TOrderProcessItems.F_ItemProfit])))}
  else if FName = TOrderProcessItems.F_OwnCost then
  begin
    //FValue := NvlFloat(PrcData[F_OwnCost]) * (1 + NvlFloat(PrcData[F_OwnPercent]) / 100.0)
    if NvlBoolean(PrcData[TOrderProcessItems.F_ContractorProcess]) then
      FValue := 0
    else
      FValue := NvlFloat(PrcData[TOrderProcessItems.F_Cost]) + NvlFloat(PrcData[TOrderProcessItems.F_ItemProfit])
      - NvlFloat(PrcData[TOrderProcessItems.F_MatCost]) * (1 + NvlFloat(PrcData[TOrderProcessItems.F_MatPercent]) / 100.0);
  end
  else if FName = F_ContractorName then
    FValue := Contractors.GetInfo(NvlInteger(PrcData[TOrderProcessItems.F_Contractor])).Name
  else if FName = TOrderProcessItems.F_ItemProfit then  // Прибыль по процессу в нац. валюте
  begin
    //FValue := NvlFloat(PrcData[TOrderProcessItems.F_ItemProfit]) * FOrder.USDCourse;
    // берем стоимость F_EnabledWorkCost
    FValue := (NvlFloat(PrcData[TOrderProcessItems.F_Cost]) + NvlFloat(PrcData[TOrderProcessItems.F_ItemProfit])
      - NvlFloat(PrcData[TOrderProcessItems.F_MatCost]) * (1 + NvlFloat(PrcData[TOrderProcessItems.F_MatPercent]) / 100.0))
       * FOrder.USDCourse;
    // фактические затраты на субподряд, если указана фактическая стоимость
    if not VarIsNull(NvlFloat(PrcData[TOrderProcessItems.F_FactContractorCost])) then
      FValue := FValue + NvlFloat(PrcData[TOrderProcessItems.F_ContractorCost]) * FOrder.USDCourse
        - NvlFloat(PrcData[TOrderProcessItems.F_FactContractorCost]);
    // Если есть фактическая стоимость материалов, то ее учитываем - НЕ ТАК ПРОСТО!
    {if not VarIsNull(PrcData[F_FactMatCost]) then
      FValue := FValue + NvlFloat(PrcData[F_MatCost]) * (1 + NvlFloat(PrcData[F_MatPercent]) / 100.0)
        - NvlFloat(PrcData[F_FactMatCost])
    else
      FValue := FValue + NvlFloat(PrcData[F_MatCost]) * (NvlFloat(PrcData[F_MatPercent]) / 100.0);}
  end
  else if FName = TOrderProcessItems.F_EquipName then
    FValue := TOrderProcessItems.GetEquipName(PrcData)
  else if FName = F_PartName then
    FValue := TOrderProcessItems.GetPartName(PrcData)
  else
    FValue := PrcData[FName];
  Result := FValue;
end;

function IsMaterialField(FieldName: string): boolean;
begin
  Result := (FieldName = TMaterials.F_SupplierName) or (FieldName = TMaterials.F_FactMatAmount)
    or (FieldName = TMaterials.F_FactMatCost) or (FieldName = TMaterials.F_PlanReceiveDate)
    or (FieldName = TMaterials.F_FactReceiveDate);
end;

function TCustomReportBuilder.ProcessDetails: boolean;
var
  cdDetails, SourceData: TDataSet;
  MatData: TClientDataSet;
  FName: string;
  FValue: variant;
  ProcessID: integer;
  PrcData: TDataSet;
  ProcessRow, CurCol: integer;
  ProcessPresent: boolean;
  FilterPassed, FilterResult: Boolean;
begin
  cdDetails := CustomReports.Details.DataSet;
  CurCol := 1;
  ProcessPresent := false;
  MaxProcessRow := CurRow;
  cdDetails.First;
  FilterPassed := true;
  // Идем по столбцам до тех пор пока не встретится фильтр, отсеивающий запись
  while not cdDetails.eof and FilterPassed do
  begin
    FName := cdDetails['FieldName'];
    if cdDetails['FieldSourceType'] = fstProcess then
    begin
      ProcessID := cdDetails['ProcessID'];
      if DetailedProcesses then begin      // построчный вывод позиций процессов
        {if false (*IsItemParam(FName)*) then begin
          // параметр процесса
          OldFilter := dm.cdProcessItems.Filter;
          OldFiltered := dm.cdProcessItems.Filtered;
          dm.cdProcessItems.DisableControls;
          dm.cdProcessItems.Filter := 'ProcessID=' + IntToStr(ProcessID) + ' and Enabled';
          dm.cdProcessItems.Filtered := true;
          try
            ProcessRow := CurRow;
            while not dm.cdProcessItems.Eof do
            begin
              ProcessPresent := true;
              FValue := dm.cdProcessItems[FName];
              SetCell(ProcessRow, CurCol, FValue);
              Inc(ProcessRow);
              dm.cdProcessItems.Next;
            end;
            if MaxProcessRow < ProcessRow - 1 then
              MaxProcessRow := ProcessRow - 1;
          finally
            dm.cdProcessItems.Filter := OldFilter;
            dm.cdProcessItems.Filtered := OldFiltered;
            dm.cdProcessItems.EnableControls;
          end;
        end else begin}

        PrcData := OpenCustomSQL(ProcessID, CurrentOrderID, MatData);

        if IsMaterialField(FName) then  // материалы
          SourceData := MatData
        else
          SourceData := PrcData;
        // Поле процесса - заполняем данными текущую строку. Если больше одной записи
        // в процессе, то переходим на следующую и т.д.
        SourceData.First;
        ProcessRow := CurRow;
        while not SourceData.eof do
        begin
          ProcessPresent := true;
          FValue := GetFieldValue(SourceData, ProcessID, FName);
          // проверяем условие фильтрации
          FFilterContext.FieldName := FName;
          FFilterContext.ProcessData := SourceData;
          FFilterContext.ProcessID := ProcessID;
          FFilterContext.FieldValue := FValue;
          FilterResult := CheckFilter(cdDetails['Filter']);
          if not FilterResult and (cdDetails['FilterType'] = FilterType_CellValue) then
            Inc(ProcessRow) // значение ячейки отсеяно
          else
          begin
            FilterPassed := FilterResult or (cdDetails['FilterType'] <> FilterType_CellValue);
            if FilterPassed then
            begin
              SetCell(ProcessRow, CurCol, FValue);
              Inc(ProcessRow);
            end
            else
            begin
              // Выбрасываем всю строку
              MaxProcessRow := CurRow;
              break;
            end;
          end;
          SourceData.Next;
        end;
        if MaxProcessRow < ProcessRow - 1 then
          MaxProcessRow := ProcessRow - 1;
      end else begin // только итоговые значения
        FValue := NvlFloat(GetTotal(ProcessID, 'Total' + FName));
        SetCell(CurRow, CurCol, FValue);
        ProcessPresent := ProcessPresent or (FValue > 0);
      end;

    end;

    Inc(CurCol);
    cdDetails.Next;
  end;

  //CloseCustomSQL;

  Result := FilterPassed and (ProcessPresent or IncludeEmptyDetails or not DetailedProcesses);
end;

function TCustomReportBuilder.GetFieldName(BaseName, FieldName: string;
  Col: integer): string;
begin
  Result := BaseName + '_' + FieldName + IntToStr(Col);
  if Length(Result) > 31 then Result := Copy(Result, 1, 25) + '_' + IntToStr(Col);
end;

function TCustomReportBuilder.GetLookup(FieldName: string; ProcessID: integer): TLookupInfo;
var
  i: integer;
  li: TLookupInfo;
begin
  if Lookups.Count > 0 then
    for i := 0 to Lookups.Count - 1 do
    begin
      li := TLookupInfo(Lookups[i]);
      if (li.FieldName = FieldName) and (li.ProcessID = ProcessID) then
      begin
        Result := TLookupInfo(Lookups[i]);
        Exit;
      end;
    end;
  Result := nil;
end;

// номера всех заказов в текущей выборке сохраняем во временной таблице
procedure TCustomReportBuilder.GetOrderIDs;
var
  Cmd: TADOCommand;
  SaveCursor: TCursor;
  CurStr: string;
begin
  Cmd := TADOCommand.Create(nil);
  SaveCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;    { Show hourglass cursor }
  try
    Cmd.Connection := Database.Connection;
    Cmd.CommandText := 'DROP TABLE #OrderIds';
    try Cmd.Execute; except end;  // ignore. possibly does not exist
    Cmd.CommandText := 'CREATE TABLE #OrderIds (OrderID INT PRIMARY KEY)';
    Cmd.Execute;
    AllOrderIDs := '';
    FOrder.DataSet.First;
    while not FOrder.DataSet.eof do
    begin
      CurStr := IntToStr(FOrder.KeyValue);
      if AllOrderIDs = '' then AllOrderIDs := AllOrderIDs + CurStr
      else AllOrderIDs := AllOrderIDs + ',' + CurStr;
      Cmd.CommandText := 'INSERT INTO #OrderIds VALUES (' + CurStr + ')';
      Cmd.Execute;
      FOrder.DataSet.Next;
    end;
  finally
    Screen.Cursor := SaveCursor;  { Always restore to normal }
    Cmd.Free;
  end;
end;

procedure TCustomReportBuilder.InitLookups;
begin
  Lookups := TList.Create;
end;

procedure TCustomReportBuilder.InitFieldSequenceList;
begin
  FReportFieldList := TList.Create;
end;

procedure TCustomReportBuilder.CreateReportData;
var
  cdDetails: TDataSet;
  PrcData, FieldData: TDataSet;
  MatData: TClientDataSet;
  Prc: TPolyProcessCfg;
  FName, Expr: string;
  CurCol: integer;
  ICriteria: TOrderInvoiceItemsCriteria;
  PCriteria: TOrderPaymentsCriteria;

  // Служебные поля не регистрируются в этом списке
  procedure SaveFieldSequence(NewField: TField);
  begin
    FReportFieldList.Add(NewField);
  end;

  function AddReportField(Field: TField; BaseName: string): TField;
  var
    NewField: TField;
  begin
    if Field is TStringField then
    begin
      NewField := TStringField.Create(nil);
      (NewField as TStringField).Size := (Field as TStringField).Size;
    end
    else
    if Field is TBooleanField then
      NewField := TBooleanField.Create(nil)
    else
    if Field is TBCDField then
    begin
      NewField := TBCDField.Create(nil);
      (NewField as TBCDField).Size := (Field as TBCDField).Size;
      (NewField as TBCDField).Precision := (Field as TBCDField).Precision;
      (NewField as TBCDField).DisplayFormat := (Field as TBCDField).DisplayFormat;
    end
    else
    if Field is TFloatField then
    begin
      NewField := TFloatField.Create(nil);
      (NewField as TFloatField).DisplayFormat := (Field as TFloatField).DisplayFormat;
    end
    else if Field is TIntegerField then
    begin
      NewField := TIntegerField.Create(nil);
      (NewField as TIntegerField).DisplayFormat := (Field as TIntegerField).DisplayFormat;
    end
    else
    if Field is TDateTimeField then
    begin
      NewField := TDateTimeField.Create(nil);
      (NewField as TDateTimeField).DisplayFormat := (Field as TDateTimeField).DisplayFormat;
    end
    else
    if Field is TSmallIntField then
    begin
      NewField := TSmallIntField.Create(nil);
      (NewField as TSmallIntField).DisplayFormat := (Field as TSmallIntField).DisplayFormat;
    end
    else
    begin
      RusMessageDlg('Тип поля ' + FName + ' (' + Field.ClassName + ') не поддерживается', mtWarning, [mbOk], 0);
      Exit;
    end;
    NewField.FieldName := GetFieldName(BaseName, FName, CurCol);
    NewField.DataSet := cdReport;
    NewField.ProviderFlags := [];
    NewField.DisplayLabel := cdDetails['Caption'];
    SaveFieldSequence(NewField);
    Result := NewField;
  end;

  procedure AddReportLookupField(ProcessID: integer; FieldName, BaseName: string;
    KeyField: TField; DicID: integer);
  var
    NewField: TField;
  begin
    NewField := TStringField.Create(nil);
    (NewField as TStringField).Size := 100;
    NewField.FieldName := GetFieldName(BaseName, FieldName, CurCol);
    NewField.DataSet := cdReport;
    NewField.ProviderFlags := [];
    NewField.DisplayLabel := cdDetails['Caption'];
    Lookups.Add(TLookupInfo.Create(ProcessID, FieldName, KeyField.FieldName, DicID));
    SaveFieldSequence(NewField);
  end;

  function CreateSumAggregate(TableName, IndexName: string; IndexFieldsCount: integer): TAggregateField;
  var
    Agg: TAggregateField;
    FieldIndex: integer;
    FieldName: string;
  begin
    FieldName := GetFieldName(TableName, FName, CurCol);
    FieldIndex := cdReport.Fields.IndexOf(cdReport.FieldByName(FieldName));
    if FieldIndex = -1 then
      raise Exception.Create('Поле не найдено ' + FieldName);
    Agg := CreateAggField(cdReport, nil, 'Sum_' + FieldName, 'Sum(' + FieldName + ')');
    Agg.GroupingLevel := IndexFieldsCount;
    Agg.IndexName := IndexName;
    Agg.Active := true;
    Agg.Tag := FieldIndex;  // индекс исходного поля
    //SaveFieldSequence(Agg); // не надо добавлять
    Result := Agg;
  end;

  function CreateTotalSumAggregate(TableName, FieldName: string): TAggregateField;
  var
    Agg: TAggregateField;
    FieldIndex: integer;
  begin
    FieldName := GetFieldName(TableName, FieldName, CurCol);
    Agg := CreateAggField(cdReport, nil, 'Sum_' + FieldName, 'Sum(' + FieldName + ')');
    FieldIndex := cdReport.Fields.IndexOf(cdReport.FieldByName(FieldName));
    Agg.Active := true;
    Agg.Tag := FieldIndex;  // индекс исходного поля
    Result := Agg;
  end;

  function CreateProcessSumAggregate(Expression: string): TAggregateField;
  var
    Agg: TAggregateField;
  begin
    Agg := CreateAggField(PrcData, nil, 'Total' + FName, Expression);
    Agg.Active := true;
    SaveFieldSequence(Agg);
    Result := Agg;
  end;

begin
  InitFieldSequenceList;

  cdReport := TClientDataSet.Create(nil);
  with TIntegerField.Create(nil) do
  begin
    FieldName := TReportData.F_RowID;
    DataSet := cdReport;
  end;
  with TIntegerField.Create(nil) do
  begin
    FieldName := 'OrderID';
    DataSet := cdReport;
  end;

  cdReport.BeforeInsert := ReportBeforeInsert;
  cdReport.OnNewRecord := ReportNewRecord;

  FGroupAggList := TList.Create;
  FOrderAggList := TList.Create;
  FTotalAggList := TList.Create;

  ProcessSortFields;

  cdDetails := CustomReports.Details.DataSet;
  CurCol := 1;
  ProcessCount := 0;
  cdDetails.First;
  while not cdDetails.eof do
  begin
    FName := cdDetails['FieldName'];
    if cdDetails['FieldSourceType'] = fstProcess then
    begin
      Inc(ProcessCount);
      Prc := TConfigManager.Instance.ServiceByID(cdDetails['ProcessID']);

      // детализация
      if DetailedProcesses then
      begin

        if IsItemParam(FName) then
        begin
          // параметр процесса
          AddReportField(FOrder.OrderItems.DataSet.FieldByName(FName), Prc.TableName);
        end
        else // эти поля могут быть и в наборе данных процесса, поэтому
             // сразу проверяем их. потом при заполнении данными они обрабатываются отдельно
        if (FName = F_ContractorName) or (FName = TOrderProcessItems.F_ItemDesc) or (FName = TOrderProcessItems.F_EquipName)
          or (FName = F_PartName) then
          AddReportField(FOrder.OrderItems.DataSet.FieldByName(FName), Prc.TableName)
        else if IsMaterialField(FName) then  // Параметры материалов
          AddReportField(FOrder.OrderItems.Materials.DataSet.FieldByName(FName), Prc.TableName)
        else if cdDetails['ProcessID'] = OrderDetails_InvoiceItems then
        begin
          // данные счет-фактуры
          if FInvoiceItems = nil then
          begin
            PrepareInvoiceItems;
            ICriteria := TOrderInvoiceItemsCriteria.Default;
            // открываем с нулевым ключом заказа, интересуют только типы полей
            ICriteria.Mode := TOrderInvoiceItemsCriteria.Mode_Empty;
            FInvoiceItems.Criteria := ICriteria;
            FInvoiceItems.Open;
          end;
          AddReportField(FInvoiceItems.DataSet.FieldByName(FName), 'InvoiceItems');
        end
        else if cdDetails['ProcessID'] = OrderDetails_Payments then
        begin
          // данные об оплатах
          if FOrderPayments = nil then
          begin
            PrepareOrderPayments;
            // открываем с нулевым ключом заказа, интересуют только типы полей
            PCriteria.Mode := TOrderPaymentsCriteria.Mode_Empty;
            FOrderPayments.Criteria := PCriteria;
            FOrderPayments.Open;
          end;
          AddReportField(FOrderPayments.DataSet.FieldByName(FName), 'Payments');
        end
        else if cdDetails['ProcessID'] = OrderDetails_Shipment then
        begin
          // данные об отгрузках
          if FOrderShipment = nil then
          begin
            PrepareOrderShipment;
            // открываем с нулевым ключом заказа, интересуют только типы полей
            FOrderShipment.Criteria.Mode := TShipmentFilterObj.Mode_Empty;
            FOrderShipment.Open;
          end;
          AddReportField(FOrderShipment.DataSet.FieldByName(FName), 'Shipment');
        end
        else
        begin
          // поле процесса
          PrepareCustomSQL(cdDetails['ProcessID']);
          // интересует только тип поля поэтому ключ заказа 0
          PrcData := OpenCustomSQL(cdDetails['ProcessID'], 0, MatData);
          FieldData := Prc.GetFieldInfo(FName);
          if FieldData <> nil then
          begin
              //raise Exception.Create('Поле ' + FName + ' не найдено');
            if FieldData['FieldStatus'] = ftCalculated then
            begin
              if not VarIsNull(FieldData['LookupDicID']) and not VarIsNull(FieldData['LookupKeyField']) then
                AddReportLookupField(Prc.SrvID, FName, Prc.TableName,
                  PrcData.FieldByName(FieldData['LookupKeyField']), FieldData['LookupDicID']);
            end
            else if (FName = TOrderProcessItems.F_EnabledWorkCost) or (FName = TOrderProcessItems.F_FactContractorCost) then
              AddReportField(FOrder.OrderItems.DataSet.FieldByName(F_EnabledCost), Prc.TableName)
            else
              AddReportField(PrcData.FieldByName(FName), Prc.TableName);
          end
          else
            AddReportField(PrcData.FieldByName(FName), Prc.TableName);
        end;

        // создаем агрегатное поле для текущего
        if cdDetails['SumTotal'] then
        begin
          if cdDetails['SumByGroup'] and (FGroupIndexName <> '') then
          begin
            if cdDetails['ProcessID'] = OrderDetails_Payments then
              FGroupAggList.Add(CreateSumAggregate('Payments', FGroupIndexName, FGroupIndexFieldsCount))
            else if cdDetails['ProcessID'] = OrderDetails_InvoiceItems then
              FGroupAggList.Add(CreateSumAggregate('InvoiceItems', FGroupIndexName, FGroupIndexFieldsCount))
            else
              FGroupAggList.Add(CreateSumAggregate(Prc.TableName, FGroupIndexName, FGroupIndexFieldsCount));
            // и добавляем в общий список агрегатных полей для группировки
          end
          else
          begin
            if cdDetails['ProcessID'] = OrderDetails_Payments then
              //FOrderAggList.Add(CreateSumAggregate('Payments', FOrderIndexName, 1))
              FTotalAggList.Add(CreateTotalSumAggregate('Payments', FName))
            else if cdDetails['ProcessID'] = OrderDetails_InvoiceItems then
              //FOrderAggList.Add(CreateSumAggregate('InvoiceItems', FOrderIndexName, 1))
              FTotalAggList.Add(CreateTotalSumAggregate('InvoiceItems', FName))
            else
              //FOrderAggList.Add(CreateSumAggregate(Prc.TableName, FOrderIndexName, 1));
              FTotalAggList.Add(CreateTotalSumAggregate(Prc.TableName, FName));
            // и добавляем в общий список агрегатных полей для заказа
          end;
        end;

      end
      else
      begin
        // поле процесса
        PrcData := PrepareCustomSQL(cdDetails['ProcessID']);
        // без детализации - итоговые значения
        if (FName = TOrderProcessItems.F_Cost) or (FName = TOrderProcessItems.F_EnabledWorkCost)
          or (FName = TOrderProcessItems.F_ContractorCost) or (FName = TOrderProcessItems.F_MatCost)
          or (FName = TOrderProcessItems.F_OwnCost) or (FName = TOrderProcessItems.F_FactContractorCost)
          or (FName = TOrderProcessItems.F_ItemProfit) then
        begin
          // создаем поле данных
          AddReportField(FOrder.OrderItems.DataSet.FieldByName(FName), Prc.TableName);
          // и агрегатное поле, в котором рассчитается сумма по процессу и заказу
          if FName = TOrderProcessItems.F_Cost then
            Expr := 'Sum(Cost) + Sum(ItemProfit)'
          else if FName = TOrderProcessItems.F_EnabledWorkCost then
            Expr := 'Sum(Cost) + Sum(ItemProfit) - Sum(MatCost * (1 + MatPercent / 100))'//'Sum(ContractorCost * (1 + ContractorPercent / 100)) + Sum(OwnCost * (1 + OwnPercent / 100))'
          else if FName = TOrderProcessItems.F_OwnCost then
            Expr := 'Sum(OwnCost + ItemProfit)'//'Sum(OwnCost * (1 + OwnPercent / 100))'
          else if FName = TOrderProcessItems.F_ContractorCost then
            Expr := 'Sum(ContractorCost + ItemProfit)'//'Sum(ContractorCost * (1 + ContractorPercent / 100))'
          else if FName = TOrderProcessItems.F_MatCost then
            Expr := 'Sum(MatCost * (1 + MatPercent / 100))'
          else if FName = TOrderProcessItems.F_FactContractorCost then
            Expr := 'Sum(' + TOrderProcessItems.F_FactContractorCost + ')'
          else if FName = TOrderProcessItems.F_ItemProfit then
            Expr := 'Sum(' + TOrderProcessItems.F_ItemProfit
              + ') + Sum(ContractorCost) - Sum(' + TOrderProcessItems.F_FactContractorCost + ')';
          CreateProcessSumAggregate(Expr);
          {if FName = F_EnabledWorkCost then begin
            // получается суммой двух полей
            FName := F_ContractorCost;
            FOrderAggList.Add(CreateSumAggregate(FOrderIndexName, 1));
            FName := F_OwnCost;
            FOrderAggList.Add(CreateSumAggregate(FOrderIndexName, 1));
          end else}
          //FOrderAggList.Add(CreateSumAggregate(FOrderIndexName, 1));
        end
        else
          RusMessageDlg('Неизвестное итоговое поле ' + FName, mtError, [mbOk], 0);
      end;

    end
    else
    begin
      // добавляем поле параметра заказа
      if FName = 'ClientTotalGrn' then
        AddReportField(FOrder.DataSet.FieldByName('ClientTotal'), 'Order')
      else if FName = TOrder.F_KindName then
        AddReportField(FOrder.DataSet.FieldByName('Comment'), 'Order')
      else if FName = 'CostOf1Grn' then
        AddReportField(FOrder.DataSet.FieldByName('CostOf1'), 'Order')
      else if FName = TOrder.F_OrderState then
        AddReportField(TConfigManager.Instance.StandardDics.deOrderState.DicItems.FieldByName('Name'), 'Order')
      else if FName = TOrder.F_PayState then
        AddReportField(TConfigManager.Instance.StandardDics.dePayState.DicItems.FieldByName('Name'), 'Order')
      else if (FOrder.DataSet.FindField(FName) <> nil) {or (dm.WorkOrderData.FindField(FName) <> nil)} then
        AddReportField(FOrder.DataSet.FieldByName(FName), 'Order')
      else
        raise Exception.Create('Поле не может быть включено в отчет: ' + FName);
      // создаем агрегатное поле для текущего
      if cdDetails['SumTotal'] then
      begin
        FTotalAggList.Add(CreateTotalSumAggregate('Order', FName));
        // и добавляем в общий список агрегатных полей для заказа
      end;
    end;

    Inc(CurCol);

    cdDetails.Next;
  end;

  CloseCustomSQL;

  if FInvoiceItems <> nil then
    FInvoiceItems.Close;
  if FOrderPayments <> nil then
    FOrderPayments.Close;
  if FOrderShipment <> nil then
    FOrderShipment.Close;

  cdReport.CreateDataSet;
  LastRowID := 1;
end;

procedure TCustomReportBuilder.ProcessOrderAggregates;
var
  i: integer;
  Field: TField;
  PrevOrderID: integer;
  AggValue: variant;
begin
  if not cdReport.IsEmpty and (FOrderAggList.Count > 0) then
  begin
    cdReport.IndexName := '';
    cdReport.AggregatesActive := true;
    cdReport.IndexName := FOrderIndexName;
    cdReport.First;
    PrevOrderID := -1;
    while not cdReport.eof do
    begin
      CurrentOrderID := cdReport['OrderID'];
      cdReport.Edit;
      for i := 0 to FOrderAggList.Count - 1 do
      begin
        if PrevOrderID <> CurrentOrderID then
        begin
          Field := TAggregateField(FOrderAggList[i]);
          // Запоминаем значение агрегата, т.к. оно изменится после первого же присвоения
          AggValue := Field.Value;
          PrevOrderID := CurrentOrderID;
        end
        else
          if not FRepeatOrderFields then begin
            cdReport.Fields[Field.Tag].Value := null; // только в первой строке
            continue;
          end;
        cdReport.Fields[Field.Tag].Value := AggValue;
      end;
      cdReport.Next;
    end;
  end;
end;

procedure TCustomReportBuilder.ProcessGroupAggregates;
var
  RowID, GroupNum: integer;
  GroupValues: array of variant;
  GroupEnds: array of integer;
  i: integer;

  procedure InitGroupFields;
  begin
    SetLength(GroupValues, FGroupIndexFieldsCount);
  end;

  procedure SetGroupValues;
  var
    FName: string;
    i: integer;
  begin
    for i := 1 to FGroupIndexFieldsCount do
    begin
      FName := ExtractWord(i, FGroupIndexFields, [';']);
      GroupValues[i - 1] := cdReport[FName];
    end;
  end;

  function CompareGroupValues: boolean;
  var
    FName: string;
    i: integer;
  begin
    Result := true;
    for i := 1 to FGroupIndexFieldsCount do
    begin
      FName := ExtractWord(i, FGroupIndexFields, [';']);
      if GroupValues[i - 1] <> cdReport[FName] then
      begin
        Result := false;
        Exit;
      end;
    end;
  end;

  procedure SaveAggValues;
  var
    i: integer;
    Field: TAggregateField;
  begin
    if Length(GroupValues) < FGroupAggList.Count then
      SetLength(GroupValues, FGroupAggList.Count);
    for i := 0 to FGroupAggList.Count - 1 do
    begin
      Field := TAggregateField(FGroupAggList[i]);
      GroupValues[i] := Field.Value;
    end;
  end;

  procedure RestoreAggValues;
  var
    i: integer;
    Field: TAggregateField;
  begin
    for i := 0 to FGroupAggList.Count - 1 do begin
      Field := TAggregateField(FGroupAggList[i]);
      cdReport.Fields[Field.Tag].Value := GroupValues[i];
    end;
  end;

begin
  if (FGroupIndexFieldsCount > 0) and not cdReport.IsEmpty then
  begin
    cdReport.IndexName := FGroupIndexName;
    // Есть группировка
    if (FGroupAggList.Count > 0) then
    begin
      InitGroupFields;
      // Запоминаем концы групп
      // Перенумеровываем строки в новом порядке
      cdReport.First;
      cdReport.Edit;
      cdReport[TReportData.F_RowID] := 1;
      GroupNum := 0;
      SetGroupValues;
      cdReport.Next;
      RowID := 2;
      while not cdReport.eof do
      begin
        if not CompareGroupValues then
        begin
           // началась следующая группа
           SetGroupValues;
           // расширяем список если не помещается
           if GroupNum >= Length(GroupEnds) then SetLength(GroupEnds, Length(GroupEnds) + 100);
           GroupEnds[GroupNum] := RowID - 1;
           Inc(GroupNum);
           Inc(RowID, 2);
        end;
        cdReport.Edit;
        cdReport[TReportData.F_RowID] := RowID;
        Inc(RowID);
        cdReport.Next;
      end;
      // последняя группа
      if RowID > 2 then begin
        // расширяем список если не помещается
        if GroupNum >= Length(GroupEnds) then SetLength(GroupEnds, Length(GroupEnds) + 2);
        GroupEnds[GroupNum] := RowID - 1;
        Inc(GroupNum);
      end;

      cdReport.IndexName := '';
      cdReport.AggregatesActive := true;
      cdReport.IndexName := FGroupIndexName;  // обновляем индекс иначе не считает агрегаты

      // идем по все группам
      for i := 0 to GroupNum - 1 do
      begin
        if not cdReport.Locate(TReportData.F_RowID, GroupEnds[i], []) then
          raise Exception.Create('Не найден конец группы: ' + IntToStr(GroupEnds[i]));
        SaveAggValues;
        // строка с итоговыми значениями
        cdReport.Append;
        cdReport[TReportData.F_RowID] := GroupEnds[i] + 1;
        RestoreAggValues;
        // пустая строка, если не отключена
        if CustomReports.AddRowAfterGroup then
        begin
          cdReport.Append;
          cdReport[TReportData.F_RowID] := GroupEnds[i] + 2;
        end;
      end;
      // Переключаемся на обычный индекс чтобы увидеть новое упорядочение
      cdReport.IndexName := FDefaultIndexName;
    end;
  end;
end;

procedure TCustomReportBuilder.ProcessTotalAggregates;
var
  AggValue: variant;
  Field: TField;
  i: integer;
begin
  if (cdReport.RecordCount > 0) and (FTotalAggList.Count > 0) then
  begin
    cdReport.AggregatesActive := true;
    cdReport.Append;
    for i := 0 to FTotalAggList.Count - 1 do
    begin
      Field := TAggregateField(FTotalAggList[i]);
      AggValue := Field.Value;
      cdReport.Fields[Field.Tag].Value := AggValue;
    end;
  end;
end;

procedure TCustomReportBuilder.ProcessSortFields;
var
  cdDetails: TDataSet;
  FName, ReportFieldName: string;
  CurCol, OrderNum: integer;
  Prc: TPolyProcessCfg;
  IndexOptions: TIndexOptions;

  procedure ProcessSortField(SortOrderNum: variant);
  begin
    if not VarIsNull(SortOrderNum) then
    begin
      cdDetails := CustomReports.Details.DataSet;
      CurCol := 1;
      cdDetails.First;
      while not cdDetails.eof do
      begin
        OrderNum := cdDetails['OrderNum'];
        if OrderNum = SortOrderNum then
        begin

          FName := cdDetails['FieldName'];

          if cdDetails['FieldSourceType'] = fstProcess then
          begin
            Prc := TConfigManager.Instance.ServiceByID(cdDetails['ProcessID']);
            ReportFieldName := GetFieldName(Prc.TableName, FName, CurCol);
          end else
            ReportFieldName := GetFieldName('Order', FName, CurCol);

          if FGroupIndexFields = '' then
            FGroupIndexFields := ReportFieldName
          else
            FGroupIndexFields := FGroupIndexFields + ';' + ReportFieldName;
          Inc(FGroupIndexFieldsCount);
        end;

        Inc(CurCol);
        cdDetails.Next;
      end;
    end;
  end;

begin
  FGroupIndexName := '';
  FGroupIndexFields := '';
  FGroupIndexFieldsCount := 0;
  ProcessSortField(CustomReports.Sort1);
  ProcessSortField(CustomReports.Sort2);
  ProcessSortField(CustomReports.Sort3);
  ProcessSortField(CustomReports.Sort4);

  // default index
  FDefaultIndexName := 'cdReportRowIDIndex';
  cdReport.IndexDefs.Add(FDefaultIndexName, TReportData.F_RowID, []);

  // custom group index
  if FGroupIndexFieldsCount > 0 then begin
    FGroupIndexName := 'cdReportGroupIndex';
    if CustomReports.SortAscending then
      IndexOptions := []
    else
      IndexOptions := [ixDescending];
    cdReport.IndexDefs.Add(FGroupIndexName, FGroupIndexFields, IndexOptions);
  end;

  // order id index
  FOrderIndexName := 'cdReportOrderIDIndex';
  cdReport.IndexDefs.Add(FOrderIndexName, TOrderProcessItems.F_OrderID, []);

  // set index to default
  cdReport.IndexName := FDefaultIndexName;
end;

procedure TCustomReportBuilder.ReportBeforeInsert(DataSet: TDataSet);
begin
  // TODO -cMM: TCustomReportBuilder.ReportBeforeInsert default body inserted
end;

procedure TCustomReportBuilder.ReportNewRecord(DataSet: TDataSet);
begin
  DataSet[TReportData.F_RowID] := LastRowID;
  Inc(LastRowID);
end;

procedure TCustomReportBuilder.SetCell(Row, Col: integer; Value: variant);
begin
  LocateRowForEdit(Row);
  // Первые два поля служебные
  cdReport.Fields[Col + 1].Value := Value;
  //cdReport.Post;
end;

constructor TLookupInfo.Create(_ProcessID: integer; _FieldName, _KeyFieldName: string; DicID: integer);
begin
  inherited Create;
  ProcessID := _ProcessID;
  FieldName := _FieldName;
  KeyFieldName := _KeyFieldName;
  Dic := TConfigManager.Instance.DictionaryList.FindID(DicID);
  if Dic = nil then
    raise Exception.Create('Не найден справочник для поля ' + FieldName);
end;

function TLookupInfo.GetResultValue(KeyValue: variant): variant;
begin
  if VarIsNull(KeyValue) then Result := ''
  else Result := Dic.ItemName[KeyValue];
end;

initialization

CustomReportBuilder := TCustomReportBuilder.Create;

finalization

CustomReportBuilder.Free;

end.
