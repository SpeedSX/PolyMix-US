unit MainFilter;

{$I Calc.inc}

interface

uses SysUtils, DateUtils, JvAppStorage, JvTypes, DB,

  CalcUtils, CalcSettings, PmEntity, NotifyEvent;

type
  TFilterEvent = procedure of object;

  //TIntArray = array of integer;

  TFilterObj = class(TObject)
    FOnDisableFilter: TFilterEvent;
    FOnRestoreFilter: TFilterEvent;
  private
    FCfgChangedID: TNotifyHandlerID;
    procedure CalcDate;
    function GetCustName: string;
    procedure RestoreCheckValues(Ini: TJvCustomAppStorage; IniKey: string;
      var StateValues: TIntArray; const AllStateValues: TIntArray);
    procedure SaveCheckValues(Ini: TJvCustomAppStorage; IniKey: string;
      const StateValues: TIntArray);
    procedure ProcessCfgChanged_Handler(Sender: TObject); virtual;
  protected
    procedure Add(var s: string; x: string);
    procedure AddOr(var s: string; x: string);
    function GetOrderPrefix(e: TEntity): string;
    function GetNumberField(e: TEntity): string;
  public
    AllDraftOrderKindValues: TIntArray;
    // Здесь сохраняются ключи видов заказов, доступных для просмотра
    AllWorkOrderKindValues: TIntArray;
    cbDateTypeIndex: integer;
    cbNumChecked, cbMonthYearChecked, rbDateRangeChecked, cbCustChecked,
    rbYearChecked, rbCurMonthChecked, rbCurYearChecked, cbMonthChecked,
    cbCreatorChecked, cbEventChecked,
    rbNumEQChecked, rbNumBoundsChecked, cbRangeEndChecked,
    cbCommentChecked, cbOrdStateChecked, cbPayStateChecked, cbProcessStateChecked,
    rbOneDayChecked, cbOrderKindChecked, cbInvertProcessChecked,
    ExternalIdChecked: boolean;
    ExternalId: string;
    CurrentYear, CurrentMonth, CurrentDay: word;
    DraftOrderKindValues: TIntArray;
    edCommentText: string;
    CreatorName: string;
    EventUserName: string;
    EventText: string;
    ShowDelayed: boolean;  // показывать только просроченные заказы текущего пользователя
    FilterProcessID: integer;
    // Здесь сохраняются коды состояний выполнения процесса, выбранных для фильтрации и всех
    ProcessStateValues: TIntArray;
    // Здесь сохраняются коды состояний выполнения заказа, выбранных для фильтрации и всех
    OrdStateValues: TIntArray;
    //AllOrdStateValues: TIntArray;
    // Здесь сохраняются коды состояний оплаты, выбранных для фильтрации и всех
    PayStateValues: TIntArray;
    SingleOrderID: integer;
    RangeStartDate, RangeEndDate, DateValue: TDateTime;
    EventStartDate, EventEndDate: TDateTime;
    udNumEQPosition, udNumLTPosition, udNumGTPosition, YearValue, MonthValue,
    lcCustKeyValue: integer;
    WasCreated: boolean;
    //AllPayStateValues: TIntArray;
    // Здесь сохраняются ключи видов заказов, выбранные для фильтрации
    WorkOrderKindValues: TIntArray;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure DisableFilter; virtual;
    function GetFilterPhrase(e: TEntity): string; virtual;
    //function OrderApplyFilter(Dataset: TDataSet): boolean;
    function GetFilterExpr(e: TEntity): string; virtual;
    procedure AppendDateFilterExpr(var s: string; DateField: string;
      AtLeastByYear: boolean);
    function FilterEnabled: boolean; virtual;
    function SingleOrderFilterSet: boolean;
    procedure SetOrderCurMonthMode(MonthN, YearN: integer);
    // установливает режим единственного заказа
    procedure SetSingleOrderFilter(_OrderID: integer);
    procedure ResetPrintFilter;
    procedure RestoreFilter(Ini: TJvCustomAppStorage; IniSec: string); virtual;
    procedure StoreFilter(Ini: TJvCustomAppStorage; IniSec: string); virtual;
    function GetDateFieldDesc(DateIndex: integer): string; virtual;
    function GetCheckedOrderKindValues(e: TEntity): TIntArray;
    procedure SetCheckedOrderKindValues(e: TEntity; Values: TIntArray);
    function GetAllOrderKindValues(e: TEntity): TIntArray;

    property CustName: string read GetCustName;
    property OnDisableFilter: TFilterEvent read FOnDisableFilter write FOnDisableFilter;
    property OnRestoreFilter: TFilterEvent read FOnRestoreFilter write FOnRestoreFilter;
  end;

  TFilterClass = class of TFilterObj;

  TOrderFilterObj = class(TFilterObj)
  public
    cbCustomerCreatorChecked: boolean;
    CustomerCreatorName: string;
    function GetDateFieldDesc(DateIndex: integer): string; override;
    function FilterEnabled: boolean; override;
    procedure DisableFilter; override;
    function GetFilterExpr(e: TEntity): string; override;
    //function GetFilterPhrase(e: TEntity): string; override;
    //function GetFilterExpr(e: TEntity): string; override;
  end;

{$IFNDEF NoProduction}
  TProductionFilterObj = class(TFilterObj)
  private
    //FLocalFilter: string;
    function GetLocalFilter: string;
  public
    function GetFilterPhrase(e: TEntity): string; override;
    function GetFilterExpr(e: TEntity): string; override;
    function GetDateFieldDesc(DateIndex: integer): string; override;

    property LocalFilter: string read GetLocalFilter;
  end;
{$ENDIF}

  TPaymentsFilterObj = class(TFilterObj)
  private
    //FLocalFilter: string;
    FInvoiceID: variant;
    FIncomeIDs: TIntArray;
    //FKeyValues: TIntArray;
    FPayTypeChecked: boolean;
    FPayTypeCode: integer;
    function GetLocalFilter: string;
  public
    function GetFilterPhrase(e: TEntity): string; override;
    function GetFilterExpr(e: TEntity): string; override;
    function GetDateFieldDesc(DateIndex: integer): string; override;

    property LocalFilter: string read GetLocalFilter;
    // not null если выборка по ид. счета
    property InvoiceID: variant read FInvoiceID write FInvoiceID;
    // not null если выборка по ид. поступления
    //property IncomeID: variant read FIncomeID write FIncomeID;
    // непусто, если нужна выборка конкретных поступлений
    //property KeyValues: TIntArray read FKeyValues write FKeyValues;
    property IncomeIDs: TIntArray read FIncomeIDs write FIncomeIDs;
    // выборка по виду оплаты
    property PayTypeChecked: boolean read FPayTypeChecked write FPayTypeChecked;
    // вид оплаты
    property PayTypeCode: integer read FPayTypeCode write FPayTypeCode;
  end;

  TInvoicesFilterObj = class(TFilterObj)
  private
    //FLocalFilter: string;
    FInvoiceID: variant;
    FInvoiceNum: variant;
    FPayTypeChecked: boolean;
    FPayTypeCode: integer;
    FPayerKeyValue: integer;
    FPayerChecked: boolean;
    function GetLocalFilter: string;
  public
    function GetDateFieldDesc(DateIndex: integer): string; override;

    property LocalFilter: string read GetLocalFilter;
    // not null если выборка по ид. счета
    property InvoiceID: variant read FInvoiceID write FInvoiceID;
    // not null если выборка по номеру счета
    property InvoiceNum: variant read FInvoiceNum write FInvoiceNum;
    // выборка по виду оплаты
    property PayTypeChecked: boolean read FPayTypeChecked write FPayTypeChecked;
    // вид оплаты
    property PayTypeCode: integer read FPayTypeCode write FPayTypeCode;
    // плательщик
    property PayerKeyValue: integer read FPayerKeyValue write FPayerKeyValue;
    property PayerChecked: boolean read FPayerChecked write FPayerChecked;
  end;

  TShipmentFilterObj = class(TFilterObj)
  private
    //FLocalFilter: string;
    FShipmentID: variant;
    FOrderID: variant;
    FShipmentDocID: variant;
    FMode: integer;
    function GetLocalFilter: string;
  public
    const
      Mode_Normal = 0;
      Mode_Empty = 1;
      Mode_TempTable = 2;
    function GetDateFieldDesc(DateIndex: integer): string; override;
    property LocalFilter: string read GetLocalFilter;
    // not null если выборка по ключу
    property ShipmentID: variant read FShipmentID write FShipmentID;
    // not null если выборка по ключу заказа
    property OrderID: variant read FOrderID write FOrderID;
    // not null если выборка но накладной
    property ShipmentDocID: variant read FShipmentDocID write FShipmentDocID;
    property Mode: integer read FMode write FMode;
  end;

  TMaterialFilterObj = class(TFilterObj)
  private
    FSupplierKeyValue: integer;
    FSupplierChecked: boolean;
    FSupplierInvert: boolean;
    FMatCatCode: integer;
    FMatCatChecked: boolean;
    FMatGroupChecked: boolean;
  protected
    // Коды групп материалов, выбранные для просмотра
    FMatGroupCodes: TIntArray;
    // Все коды групп материалов
    FAllMatGroupCodes: TIntArray;
    procedure ProcessCfgChanged_Handler(Sender: TObject); override;
  public
    function GetDateFieldDesc(DateIndex: integer): string; override;
    function GetFilterExpr(e: TEntity): string; override;
    property SupplierChecked: boolean read FSupplierChecked write FSupplierChecked;
    property SupplierKeyValue: integer read FSupplierKeyValue write FSupplierKeyValue;
    property SupplierInvert: boolean read FSupplierInvert write FSupplierInvert;
    property MatCatChecked: boolean read FMatCatChecked write FMatCatChecked;
    property MatCatCode: integer read FMatCatCode write FMatCatCode;
    property MatGroupChecked: boolean read FMatGroupChecked write FMatGroupChecked;
    property MatGroupCodes: TIntArray read FMatGroupCodes write FMatGroupCodes;
  end;

  TStockFilterObj = class(TMaterialFilterObj)
  public
    function GetDateFieldDesc(DateIndex: integer): string; override;
  end;

  TStockIncomeFilterObj = class(TMaterialFilterObj)
  public
    function GetDateFieldDesc(DateIndex: integer): string; override;
  end;

  TStockWasteFilterObj = class(TMaterialFilterObj)
  public
    function GetDateFieldDesc(DateIndex: integer): string; override;
  end;

implementation

uses Variants, Classes,

  RDBUtils, PmStates, MMYYList, PmContragent, PmOrder, PmCustomersWithIncome,
  PmCustomerPayments, PmAccessManager, StdDic, PmConfigManager,
  PmMatRequest
{$IFNDEF NoProduction}
  , PmProduction
{$ENDIF}
  ;

const
  DISABLE_SINGLE_ORDER = -1;

function DateToStrFmt(ADate: TDateTime; Sep: char): string;
var
  Y, D, M: word;
begin
  DecodeDate(ADate, Y, M, D);
  Result := IntToStr(M) + Sep + IntToStr(D) + Sep + IntToStr(Y);
end;

{$REGION 'TFilterObj'}

procedure TFilterObj.AfterConstruction;
begin
  SingleOrderID := DISABLE_SINGLE_ORDER;
  FCfgChangedID := TConfigManager.Instance.ProcessCfgChanged.RegisterHandler(ProcessCfgChanged_Handler);
  ProcessCfgChanged_Handler(nil);
end;

procedure TFilterObj.BeforeDestruction;
begin
  TConfigManager.Instance.ProcessCfgChanged.UnregisterHandler(FCfgChangedID);
end;

procedure TFilterObj.CalcDate;
var
  Present: TDateTime;
begin
  Present:= Now;
  DecodeDate(Present, CurrentYear, CurrentMonth, CurrentDay);
end;

procedure TFilterObj.ProcessCfgChanged_Handler(Sender: TObject);
begin
  AllWorkOrderKindValues := AccessManager.GetPermittedKinds('WorkVisible');
  AllDraftOrderKindValues := AccessManager.GetPermittedKinds('DraftVisible');
end;

procedure TFilterObj.DisableFilter;
begin
  if Assigned(FOnDisableFilter) then
    FOnDisableFilter
  else
  begin
    cbNumChecked := false;
    cbCustChecked := false;
    cbMonthYearChecked := false;
    cbCreatorChecked := false;
    cbEventChecked := false;
    cbCommentChecked := false;
    cbOrdStateChecked := false;
    cbPayStateChecked := false;
    cbProcessStateChecked := false;
    cbOrderKindChecked := false;
    ExternalIdChecked := false;
  end;
end;

function TFilterObj.GetCustName: string;
begin
  try
    if Customers.DataSet.Active
      and Customers.Locate(lcCustKeyValue) then begin
        Result := AnsiUpperCase(Customers.Name);
    end else
      Result := '';
  except
    Result := '';
  end;
end;

function TFilterObj.GetFilterPhrase(e: TEntity): string;
var
  s: string;
begin
  s := '';
  if cbCustChecked then s := s + 'Заказчик ''' + CustName + ''' ';
  {if cbFinishChecked and (qi = qiWork) then begin
    s := s + 'запланированные на ';
    if deFinishFromDate = deFinishToDate then s := s + DateToStr(deFinishFromDate)
    else s := s + DateToStr(deFinishFromDate) + ' - ' + DateToStr(deFinishToDate);
  end else begin}
  if cbMonthYearChecked and (cbDateTypeIndex <> -1) then
  begin
    s := s + GetDateFieldDesc(cbDateTypeIndex) + ' ';
    if rbCurMonthChecked then
      s := s + GetMonthList.Strings[CurrentMonth - 1] + ' ' + IntToStr(CurrentYear) + ' год ';
    if rbCurYearChecked then
      s := s + IntToStr(CurrentYear) + ' год ';
    if rbOneDayChecked then
      s := s + FormatDateTime(CalcUtils.StdDateFmt, DateValue);
    if rbYearChecked then begin
      s := s + IntToStr(YearValue) + ' год ';
      if cbMonthChecked then s := s + GetMonthList.Strings[MonthValue - 1] + ' ';
    end;
    if rbDateRangeChecked then
    begin
      if cbRangeEndChecked then
      begin
        if (RangeStartDate = RangeEndDate) then s := s + DateToStr(RangeStartDate)
        else s := s + DateToStr(RangeStartDate) + ' - ' + DateToStr(RangeEndDate);
      end
      else
        s := s + 'с ' + DateToStr(RangeStartDate) + ' ...';
    end;
  end;
  if cbCreatorChecked and (CreatorName <> '') and (AccessManager.Users <> nil) then
    try
      s := s + 'созданные пользователем "' + AccessManager.UserInfo(CreatorName).Name + '" ';
    except end;
  if cbEventChecked then
  begin
    if (EventUserName <> '') and (AccessManager.Users <> nil) then
    begin
      try
        s := s + 'по событию для пользователя "' + AccessManager.UserInfo(EventUserName).Name + '" ';
      except end;
    end;
    if EventText <> '' then
    begin
      s := s + 'по событию содержащему "' + EventText + '" ';
    end;
    if (EventStartDate = EventEndDate) then s := s + DateToStr(EventStartDate)
    else s := s + DateToStr(EventStartDate) + ' - ' + DateToStr(EventEndDate);
  end;
  if FilterProcessID > 0 then
  begin
    s := s + 'содержащие процесс "' + TConfigManager.Instance.ServiceByID(FilterProcessID).ServiceName + '"';
    if cbInvertProcessChecked then
      s := 'не ' + s;
  end;
  Result := s;
end;

(*
// AppSERVER!!!!!!!!!!!!!!!!! Локальная фильтрация
function TFilterObj.OrderApplyFilter(Dataset: TDataSet): boolean;
var
  DF, {IDF,} NumF: string;
  qi: TQueryIndex;
  //UI: boolean;

  function GetMonthEq: boolean;
  begin
    try Result := GetMonth(DataSet[DF]) = MonthValue;
    except result := false; end;
  end;

begin
  result := true;

  if PrintID > 0 then try Result := DataSet['N'] = PrintID; Exit except end;

  // Ведь в ходе работы может измениться и месяц, и год :-)
  CalcDate;

  if DataSet = dm.aqCalcOrder then qi := qiCalc
  else if DataSet = dm.aqWorkOrder then qi := qiWork
  {$IFNDEF NoDocs} else if DataSet = dmd.aqContract then qi := qiContract{$ENDIF};

  NumF := NumberFields[qi];
  //IDF := 'ID_Date';
  if cbDateTypeIndex <> -1 then DF := DateFields[qi, cbDateTypeIndex];
  //UI := MainDataSets[qi].FindField(IDF) <> nil;

  if cbNumChecked then begin
    if rbNumEQChecked then
      try
        if Dataset[NumF] <> udNumEQPosition then result := false;
      except result := false; end;
    if not result then exit;

    if rbNumBoundsChecked then begin
      try
        if Dataset[NumF] < udNumLTPosition then result := false;
      except result := false; end;
      try
        if Dataset[NumF] > udNumGTPosition then result := false;
      except result := false; end;
    end;
    if not result then exit;
  end;

  if cbCustChecked then
    try Result := Result and (Dataset['Customer'] = lcCustKeyValue);
    except result := false; end;
  if not result then exit;

  if cbMonthYearChecked then begin
    if rbCurMonthChecked then begin
      try Result := Result and (GetMonth(DataSet[DF]) = CurrentMonth)
        and (GetYear(Dataset[DF]) = CurrentYear);
      except result := false; end;
    end;
    if not result then exit;

    if rbCurYearChecked then begin
      try Result := Result and (GetYear(Dataset[DF]) = CurrentYear);
      except result := false; end;
    end;
    if not result then exit;

    if rbYearChecked then begin
      try
        Result := Result and (GetYear(Dataset[DF]) = YearValue);
        if cbMonthChecked then Result := Result and GetMonthEq;
      except result := false; end;
    end;
    if not result then exit;

    if rbDateRangeChecked then begin
      try
        Result := Result and (Dataset[DF] >= RangeStartDate);
        if not result then exit;
        if cbRangeEndChecked then Result := Result and (Dataset[DF] <= RangeEndDate);
      except result := false; end
    end;
    if not result then exit;

    if rbNullDateChecked then begin
      try Result := Result and (VarIsNull(Dataset[DF]) or (Dataset[DF] = 0));
      except result := false; end;
    end;
    if not result then exit;

  end;

  if cbOrdStateChecked and (DataSet.FindField('OrderState') <> nil) then begin
    try Result := Result and IsStateChecked(DataSet['OrderState'], OrdStateValues);
    except end;
    if not result then exit;
  end;

  if cbPayStateChecked and (DataSet.FindField('PayState') <> nil) then begin
    try Result := Result and IsStateChecked(DataSet['PayState'], PayStateValues);
    except end;
    if not result then exit;
  end;

  if cbOrderKindChecked and (DataSet.FindField('KindID') <> nil) then begin
    try Result := Result and IsStateChecked(DataSet['KindID'], OrderKindValues);
    except end;
    if not result then exit;
  end;

  {$IFDEF Manager}
  Result := Result and CompareText(DataSet['CreatorName'], Usr) = 0; // Видит только свои
  {{$ELSE
  Result := Result and ((UserLevel = lvlAdmin) or (DataSet['Creator'] >= UserLevel));}
  {$ENDIF}
end;
*)

procedure TFilterObj.Add(var s: string; x: string);
begin
  if s = '' then s := x else s := s + ' and ' + x;
end;

procedure TFilterObj.AddOr(var s: string; x: string);
begin
  if s = '' then s := x else s := s + ' or ' + x;
end;

function TFilterObj.GetOrderPrefix(e: TEntity): string;
begin
  if e is TOrder then
    Result := (e as TOrder).GetOrderPrefix
  else if e is TCustomersWithIncome then
    Result := (e as TCustomersWithIncome).GetOrderPrefix
  else if e is TCustomerPayDetails then
    Result := (e as TCustomerPayDetails).GetOrderPrefix
  else if e is TProduction then
  begin
    // TODO: вот это правильно...
    Result := e.QueryObject.TableAlias;
    if Result <> '' then Result := Result + '.';
  end
  else
    Result := '';
end;

function TFilterObj.GetNumberField(e: TEntity): string;
begin
  if e is TOrder then
    Result := (e as TOrder).NumberField
  else if e is TCustomersWithIncome then
    Result := (e as TCustomersWithIncome).NumberField
  else if e is TCustomerPayDetails then
    Result := (e as TCustomerPayDetails).NumberField
  else if e is TProduction then
    Result := (e as TProduction).NumberField
  else if e is TMaterialRequests then
    Result := (e as TMaterialRequests).NumberField
  else
    Result := '';
end;

function TFilterObj.GetFilterExpr(e: TEntity): string;

  function FilterByOrderKind(const OrderKindValues: TIntArray): string;
  var
    ts: string;
    i: integer;
  begin
    if OrderKindValues <> nil then
    begin
      ts := '';
      for i := 0 to High(OrderKindValues) do
      begin
        ts := ts + IntToStr(OrderKindValues[i]);
        if i <> High(OrderKindValues) then ts := ts + ',';
      end;
      Result := GetOrderPrefix(e) + 'KindID in (' + ts + ')';
    end
    else
      Result := '0=1';
  end;

var
  ts, s, NumF, DF, ProcessFilter: string;
  i: integer;
  AtLeastByYear: boolean;
  StateList: TStringList;
  StateObj: TOrderState;
begin
  // Фильтрация при печати нового заказа - в выборке только один заказ
  if SingleOrderID <> DISABLE_SINGLE_ORDER then
  try
    s := GetOrderPrefix(e);
    Result := ' ' + s + e.KeyField + ' = ' + IntToStr(SingleOrderID);
    Exit;
  except end;

  // Ведь в ходе работы может измениться и месяц, и год :-)
  CalcDate;
  NumF := GetOrderPrefix(e) + GetNumberField(e);
  if cbDateTypeIndex <> -1 then DF := e.DateFields[cbDateTypeIndex];

  s := '';
  if cbNumChecked then
  begin
    if rbNumEQChecked then
    begin
      if udNumEQPosition > 0 then
        add(s, NumF + ' = ' + IntToStr(udNumEQPosition));
    end
    else
    if rbNumBoundsChecked then
    begin
      if udNumGTPosition > 0 then
        add(s, NumF + '>= ' + IntToStr(udNumGTPosition));
      if udNumLTPosition > 0 then
        add(s, NumF + '<= ' + IntToStr(udNumLTPosition));
    end;
  end;

  if ShowDelayed then
  begin
    // показать заказы, у которых дата завершения больше текущей, а состояние не завершающее
    StateList := TConfigManager.Instance.StandardDics.OrderStates;
    ts := '';
    for I := 0 to Pred(StateList.Count) do
    begin
      StateObj := StateList.Objects[I] as TOrderState;
      if StateObj.IsFinal then
      begin
        if ts <> '' then
          ts := ts + ', ';
        ts := ts + IntToStr(StateObj.Code);
      end;
    end;
    add(s, 'GETDATE() > ' + DF + ' and ' + GetOrderPrefix(e) + 'CreatorName = ''' + AccessManager.CurUser.Login + ''''
      + ' and not exists(select * from OrderProcessItem opi inner join Job j on opi.ItemID = j.ItemID where opi.OrderID = '
      + GetOrderPrefix(e) + e.KeyField + ' and opi.Enabled = 1 and j.PlanStartDate is not null)');
    if ts <> '' then
      add(s, 'not ' + GetOrderPrefix(e) + 'OrderState in (' + ts + ')');
  end
  else
  begin
    AtLeastByYear := false; // разрешается отключить фильтр по дате
    AppendDateFilterExpr(s, DF, AtLeastByYear);
  end;

  if cbCustChecked then
  begin
    if (lcCustKeyValue > 0) then
      add(s, GetOrderPrefix(e) + 'Customer = ' + inttostr(lcCustKeyValue))
  end;

  if {(e.DataSet.FindField('Comment') <> nil) and}
      cbCommentChecked and (edCommentText <> '') then
    add(s, GetOrderPrefix(e) + 'Comment like ''%' + edCommentText + '%''');

  if ExternalIdChecked and (ExternalId <> '') then
    add(s, getOrderPrefix(e) + 'ExternalId like ''%' + ExternalId + '%''');

  if cbOrdStateChecked and ((e is TWorkOrder) {$IFNDEF NoProduction} or (e is TProduction){$ENDIF}
    or (e is TCustomersWithIncome) or (e is TCustomerIncomes) or (e is TCustomerOrders)
    or (e is TMaterialRequests)) then
  begin
    if OrdStateValues <> nil then
    begin
      ts := '';
      for i := 0 to High(OrdStateValues) do
      begin
        ts := ts + IntToStr(OrdStateValues[i]);
        if i <> High(OrdStateValues) then ts := ts + ',';
      end;
      add(s, GetOrderPrefix(e) + 'OrderState in (' + ts + ')');
    end
    else
      add(s, '0=1');
  end;

  if cbPayStateChecked and ((e is TWorkOrder) (*{$IFNDEF NoProduction}or (e is TProduction){$ENDIF}
    or (e is TCustomersWithIncome) or (e is TCustomerIncomes) or (e is TCustomerOrders)*)) then
  begin
    if PayStateValues <> nil then
    begin
      ts := '';
      for i := 0 to High(PayStateValues) do
      begin
        ts := ts + IntToStr(PayStateValues[i]);
        if i <> High(PayStateValues) then ts := ts + ',';
      end;
      add(s, (e as TWorkOrder).GetPayStateExpr(ts));
    end
    else
      add(s, '0=1');
  end;

  if cbOrderKindChecked then
  begin
    if e is TDraftOrder then
      add(s, FilterByOrderKind(DraftOrderKindValues))
    else if (e is TWorkOrder) {$IFNDEF NoProduction} or (e is TProduction) {$ENDIF}
       or (e is TCustomersWithIncome) or (e is TCustomerIncomes)
       or (e is TCustomerOrders) or (e is TMaterialRequests) then
      add(s, FilterByOrderKind(WorkOrderKindValues));
  end
  else
  begin
    // иначе то же самое по списку всех доступных для просмотра
    if e is TDraftOrder then
      add(s, FilterByOrderKind(AllDraftOrderKindValues))
    else if (e is TWorkOrder) {$IFNDEF NoProduction} or (e is TProduction) {$ENDIF}
       or (e is TCustomersWithIncome) or (e is TCustomerIncomes)
       or (e is TCustomerOrders) or (e is TMaterialRequests) then
      add(s, FilterByOrderKind(AllWorkOrderKindValues));
  end;

  if cbEventChecked then
  begin
    if (EventUserName <> '') or (EventText <> '') then
    begin
      ts := 'exists(select * from OrderHistory where OrderID = ' + GetOrderPrefix(e) + 'N';
      if EventUserName <> '' then
        ts := ts + ' and EventUser = ''' + EventUserName + '''';
      if EventText <> '' then
        ts := ts + ' and EventText like ''%' + EventText + '%''';
      if EventStartDate <> NullDate then
      begin
        add(ts, 'convert(datetime, ''' + DateToStrFmt(EventStartDate, '/') + ''', 101) <= EventDate');
      end;
      if EventEndDate <> NullDate then
      begin
        add(ts, 'convert(datetime, ''' + DateToStrFmt(IncDay(EventEndDate, 1), '/') + ''', 101) > EventDate');
      end;
      ts := ts + ')';
      add(s, ts);
    end;
  end;

  {$IFDEF Manager}
  add(s, GetOrderPrefix(e) + 'CreatorName = ''' + Usr + '''');
  {$ELSE}
  // Каждый может посмотреть заказы любого, если он имеет право на просмотр
  // заказов этого вида и право на просмотр чужих заказов.
  if (e is TDraftOrder and AccessManager.CurUser.DraftViewOwnOnly)
      or (e is TWorkOrder and AccessManager.CurUser.WorkViewOwnOnly) then
    add(s, GetOrderPrefix(e) + 'CreatorName = ''' + AccessManager.CurUser.Login + '''')
  else
    if cbCreatorChecked then
    begin
      if (CreatorName <> '') then
        try add(s, GetOrderPrefix(e) + 'CreatorName = ''' + CreatorName + '''') except end;
    end;
  {$ENDIF}

  if AccessManager.CurUser.HasProtectedKinds then
    add(s, '(' + GetOrderPrefix(e) + 'CostProtected = 1 or ' + GetOrderPrefix(e) + 'ContentProtected = 1'
       + ' or not exists(select * from AccessKind ak'
       + ' where ak.KindID = ' + GetOrderPrefix(e) + 'KindID'
       + ' and ak.UserID = ' + IntToStr(AccessManager.CurUser.ID) + ' and ViewOnlyProtected = 1))');

  if (FilterProcessID > 0) and (e is TOrder) then
  begin
    ProcessFilter := 'exists(select * from OrderProcessItem where ProcessID = ' + IntToStr(FilterProcessID)
       + ' and Enabled = 1 and OrderID = ' + GetOrderPrefix(e) + e.KeyField + ')';
    if cbInvertProcessChecked then  // НЕ содержащие процесс
      ProcessFilter := 'not ' + ProcessFilter;
    add(s, ProcessFilter);
  end;
    
  result := s;
end;

procedure TFilterObj.AppendDateFilterExpr(var s: string; DateField: string;
  AtLeastByYear: boolean);
begin
  if cbDateTypeIndex <> -1 then
  begin
    if cbMonthYearChecked then
    begin
      if rbCurMonthChecked then
      begin
        add(s, 'month(' + DateField + ') = ' + inttostr(CurrentMonth));
        add(s, 'year(' + DateField + ') = ' + inttostr(CurrentYear));
      end
      else
      if rbCurYearChecked then
        add(s, 'year(' + DateField + ') = ' + inttostr(CurrentYear))
      else
      if rbYearChecked then
      begin
        add(s, 'year(' + DateField + ') = ' + inttostr(YearValue));
        if cbMonthChecked then
          add(s, 'month(' + DateField + ') = ' + inttostr(MonthValue));
      end
      else
      if rbDateRangeChecked then
      begin
        if RangeStartDate <> NullDate then
        begin
          add(s, 'convert(datetime, ''' + DateToStrFmt(RangeStartDate, '/') + ''', 101) <= ' + DateField);
        end;
        if cbRangeEndChecked and (RangeEndDate <> NullDate) then
        begin
          add(s, 'convert(datetime, ''' + DateToStrFmt(IncDay(RangeEndDate, 1), '/') + ''', 101) > ' + DateField);
        end;
      end else
      if rbOneDayChecked and (DateValue <> NullDate) then
        add(s, 'year(' + DateField + ') = ' + IntToStr(YearOf(DateValue))
          + ' and month(' + DateField + ') = ' + IntToStr(MonthOf(DateValue))
          + ' and day(' + DateField + ') = ' + IntToStr(DayOf(DateValue)));
      //if rbNullDateChecked then
      //  add(s, DateField + ' is null');
    end
    else if AtLeastByYear then // Если ничего не выбрано, тогда текущий год
      add(s, 'year(' + DateField + ') = ' + inttostr(CurrentYear));
  end;
end;

function TFilterObj.FilterEnabled: boolean;
begin
  Result := cbNumChecked or cbCustChecked or cbMonthYearChecked
    or cbCreatorChecked or cbEventChecked or cbCommentChecked or ExternalIdChecked
    or cbOrdStateChecked or cbPayStateChecked or cbOrderKindChecked or cbProcessStateChecked
    or (FilterProcessID <> 0);
end;

function TFilterObj.SingleOrderFilterSet: boolean;
begin
  Result := SingleOrderID <> DISABLE_SINGLE_ORDER;
end;

procedure TFilterObj.RestoreFilter(Ini: TJvCustomAppStorage; IniSec: string);
var
  m: integer;
  s: string;
begin
  CalcDate;
  MonthValue := CurrentMonth;
  YearValue := CurrentYear;

  try cbDateTypeIndex := Ini.ReadInteger(IniSec + '\DateTypeIndex', 0);
  except cbDateTypeIndex := 0; end;
  try cbMonthYearChecked := Ini.ReadString(IniSec + '\MonthYearFilter', '0') = '1';
  except cbMonthYearChecked := false; end;
  try m := StrToInt(Ini.ReadString(IniSec + '\MonthYearValue', '0'));
  except m := 0; end;
  rbCurMonthChecked := m = 0;
  rbCurYearChecked := m = 1;
  rbYearChecked := m = 2;
  rbDateRangeChecked := m = 3;
  rbOneDayChecked := m = 4;
  try YearValue := StrToInt(Ini.ReadString(IniSec + '\YearValue', IntToStr(CurrentYear)))
  except YearValue := CurrentYear; end;
  try cbMonthChecked := Ini.ReadString(IniSec + '\MonthChecked', '0') = '1';
  except cbMonthChecked := false; end;
  if cbMonthChecked then
  try MonthValue := StrToInt(Ini.ReadString(IniSec + '\MonthValue', IntToStr(CurrentMonth)))
  except MonthValue := CurrentMonth; end;
  try
    s := Ini.ReadString(IniSec + '\RangeStart', DateToStrMyFmt(Trunc(Now)));
    RangeStartDate := StrToDateMyFmt(s);
  except RangeStartDate := Trunc(Now); end;
  try
    s := Ini.ReadString(IniSec + '\RangeEnd', DateToStrMyFmt(Trunc(Now)));
    RangeEndDate := StrToDateMyFmt(s);
  except RangeEndDate := Trunc(Now); end;
  try cbRangeEndChecked := Ini.ReadString(IniSec + '\RangeEndChecked', '0') = '1';
  except cbRangeEndChecked := false; end;
  // один день
  try
    s := Ini.ReadString(IniSec + '\DateValue', DateToStrMyFmt(Trunc(Now)));
    DateValue := StrToDateMyFmt(s);
  except DateValue := Trunc(Now); end;

  try cbNumChecked := Ini.ReadString(IniSec + '\NumberFilter', '0') = '1';
  except cbNumChecked := false; end;
  try m := StrToInt(Ini.ReadString(IniSec + '\NumberMode', '0'));
  except m := 0; end;
  rbNumEqChecked := m = 0;
  rbNumBoundsChecked := m = 1;
  if rbNumEqChecked then
    try udNumEqPosition := StrToInt(Ini.ReadString(IniSec + '\NumberVal1', '1'))
    except udNumEqPosition := 1; end
  else begin
    try
      udNumLTPosition := StrToInt(Ini.ReadString(IniSec + '\NumberVal1', '1'));
    except udNumLTPosition := 1; end;
    try
      udNumGTPosition := StrToInt(Ini.ReadString(IniSec + '\NumberVal2', '1'));
    except udNumGTPosition := 1; end;
  end;

  try cbCommentChecked := Ini.ReadString(IniSec + '\CommentFilter', '0') = '1';
  except cbCommentChecked := false; end;
  edCommentText := Ini.ReadString(IniSec + '\CommentText', '');

  try ExternalIdChecked := Ini.ReadString(IniSec + '\ExternalIdFilter', '0') = '1';
  except ExternalIdChecked := false; end;
  ExternalId := Ini.ReadString(IniSec + '\ExternalId', '');

  try cbCreatorChecked := Ini.ReadString(IniSec + '\CreatorFilter', '0') = '1';
  except cbCreatorChecked := false; end;
  try CreatorName := Ini.ReadString(IniSec + '\CreatorName', '');
  except CreatorName := ''; end;

  //try cbEventChecked := Ini.ReadString(IniSec + '\EventFilter', '0') = '1';
  //except cbEventChecked := false; end;
  //try EventUserName := Ini.ReadString(IniSec + '\EventUserName', '');
  //except EventUserName := ''; end;

  // Состояния
  try cbProcessStateChecked := Ini.ReadInteger(IniSec + '\ProcessStateFilter\Enabled', 0) = 1;
  except cbProcessStateChecked := false; end;
  RestoreCheckValues(Ini, IniSec + '\ProcessStateFilter', ProcessStateValues,
    DicCodesToArray(TConfigManager.Instance.StandardDics.deProcessExecState));
  try cbOrdStateChecked := Ini.ReadInteger(IniSec + '\OrdStateFilter\Enabled', 0) = 1;
  except cbOrdStateChecked := false; end;
  RestoreCheckValues(Ini, IniSec + '\OrdStateFilter', OrdStateValues,
    DicCodesToArray(TConfigManager.Instance.StandardDics.deOrderState));
  try cbPayStateChecked := Ini.ReadInteger(IniSec + '\PayStateFilter\Enabled', 0) = 1;
  except cbPayStateChecked := false; end;
  RestoreCheckValues(Ini, IniSec + '\PayStateFilter', PayStateValues,
    DicCodesToArray(TConfigManager.Instance.StandardDics.dePayState));

  // Виды заказа
  try cbOrderKindChecked := Ini.ReadInteger(IniSec + '\OrderKindFilter\Enabled', 0) = 1;
  except cbOrderKindChecked := false; end;
  RestoreCheckValues(Ini, IniSec + '\WorkOrderKindFilter', WorkOrderKindValues, AllWorkOrderKindValues);
  RestoreCheckValues(Ini, IniSec + '\DraftOrderKindFilter', DraftOrderKindValues, AllDraftOrderKindValues);

  if Assigned(FOnRestoreFilter) then FOnRestoreFilter;
end;

{function FindInArray(Value: integer; IntArray: TIntArray): boolean;
var i: integer;
begin
  Result := false;
  if Length(
  for i := Low(IntArray) to High(IntArray) do
    if IntArray[i] = Value then begin
      Result := true;
      Exit;
    end;
end;}

procedure TFilterObj.RestoreCheckValues(Ini: TJvCustomAppStorage; IniKey: string;
  var StateValues: TIntArray; const AllStateValues: TIntArray);
var
  i, ii, cc, c: integer;
begin
  {SetLength(StateValueChecked, Length(AllStateValues));
  for i := Low(AllStateValues) to High(AllStateValues) do
    StateValueChecked[i] := Ini.ReadInteger(IniKey + '\Checked' +
       IntToStr(AllStateValues[i]), 0) = 1;}
  cc := Ini.ReadInteger(IniKey + '\Count', 0);
  SetLength(StateValues, cc);
  if cc > 0 then
  begin
    ii := 0;
    for i := 0 to Pred(cc) do
    begin
      c := Ini.ReadInteger(IniKey + '\Checked' + IntToStr(i), 1);
      if (c > 0) and IntInArray(c, AllStateValues) then begin  // проверяем, есть ли такой код
        StateValues[ii] := c;
        Inc(ii);
      end;
    end;
    SetLength(StateValues, ii);
  end;
end;

procedure TFilterObj.SaveCheckValues(Ini: TJvCustomAppStorage; IniKey: string;
  const StateValues: TIntArray);
var
  i: integer;
begin
  Ini.WriteInteger(IniKey + '\Count', Length(StateValues));
  for i := Low(StateValues) to High(StateValues) do
    Ini.WriteInteger(IniKey + '\Checked' + IntToStr(i), StateValues[i]);
{  for i := Low(AllStateValues) to High(AllStateValues) do
    Ini.WriteInteger(IniKey + '\Checked' + IntToStr(AllStateValues[i]),
      Ord(StateValueChecked[i]));}
end;

function TFilterObj.GetCheckedOrderKindValues(e: TEntity): TIntArray;
begin
  if e is TDraftOrder then Result := DraftOrderKindValues
  else Result := WorkOrderKindValues;
end;

procedure TFilterObj.SetCheckedOrderKindValues(e: TEntity; Values: TIntArray);
begin
  if e is TDraftOrder then DraftOrderKindValues := Values
  else WorkOrderKindValues := Values;
end;

function TFilterObj.GetAllOrderKindValues(e: TEntity): TIntArray;
begin
  if e is TDraftOrder then Result := AllDraftOrderKindValues
  else Result := AllWorkOrderKindValues;
end;

procedure TFilterObj.SetOrderCurMonthMode(MonthN, YearN: integer);
begin
  DisableFilter;
  cbMonthYearChecked := true;
  rbYearChecked := true;
  cbMonthChecked := true;
  MonthValue := MonthN;
  YearValue := YearN;
end;

procedure TFilterObj.ResetPrintFilter;
begin
  SetSingleOrderFilter(DISABLE_SINGLE_ORDER);
end;

procedure TFilterObj.SetSingleOrderFilter(_OrderID: integer);
begin
  SingleOrderID := _OrderID;
end;

procedure TFilterObj.StoreFilter(Ini: TJvCustomAppStorage; IniSec: string);
var m: integer;
begin
  Ini.WriteInteger(IniSec + '\DateTypeIndex', cbDateTypeIndex);
  Ini.WriteInteger(IniSec + '\MonthYearFilter', Ord(cbMonthYearChecked));
  if rbCurYearChecked then m := 1
  else if rbYearChecked then m := 2
  else if rbDateRangeChecked then m := 3
  else if rbOneDayChecked then m := 4
  else m := 0;
  Ini.WriteInteger(IniSec + '\MonthYearValue', m);
  Ini.WriteInteger(IniSec + '\YearValue', YearValue);
  Ini.WriteInteger(IniSec + '\MonthChecked', Ord(cbMonthChecked));
  Ini.WriteInteger(IniSec + '\MonthValue', MonthValue);
  Ini.WriteString(IniSec + '\RangeStart', DateToStrMyFmt(RangeStartDate));
  Ini.WriteInteger(IniSec + '\RangeEndChecked', Ord(cbRangeEndChecked));
  Ini.WriteString(IniSec + '\RangeEnd', DateToStrMyFmt(RangeEndDate));
  Ini.WriteString(IniSec + '\DateValue', DateToStrMyFmt(DateValue));

  Ini.WriteInteger(IniSec + '\NumberFilter', Ord(cbNumChecked));
  if rbNumEqChecked then m := 0
  else m := 1;
  Ini.WriteInteger(IniSec + '\NumberMode', m);
  if m = 0 then
    Ini.WriteInteger(IniSec + '\NumberVal1', udNumEqPosition)
  else if m = 1 then begin
    Ini.WriteInteger(IniSec + '\NumberVal1', udNumLTPosition);
    Ini.WriteInteger(IniSec + '\NumberVal2', udNumGTPosition);
  end;

  Ini.WriteInteger(IniSec + '\CommentFilter', Ord(cbCommentChecked));
  Ini.WriteString(IniSec + '\CommentText', edCommentText);

  Ini.WriteInteger(IniSec + '\ExternalIdFilter', Ord(ExternalIdChecked));
  Ini.WriteString(IniSec + '\ExternalId', ExternalId);

  // Выборка по имени
  Ini.WriteInteger(IniSec + '\CreatorFilter', Ord(cbCreatorChecked));
  Ini.WriteString(IniSec + '\CreatorName', CreatorName);

  //Ini.WriteInteger(IniSec + '\EventFilter', Ord(cbEventChecked));
  //Ini.WriteString(IniSec + '\EventUserName', EventUserName);

  // Состояния
  Ini.WriteInteger(IniSec + '\ProcessStateFilter\Enabled', Ord(cbProcessStateChecked));
  SaveCheckValues(Ini, IniSec + '\ProcessStateFilter', ProcessStateValues);
  Ini.WriteInteger(IniSec + '\OrdStateFilter\Enabled', Ord(cbOrdStateChecked));
  SaveCheckValues(Ini, IniSec + '\OrdStateFilter', OrdStateValues);
  Ini.WriteInteger(IniSec + '\PayStateFilter\Enabled', Ord(cbPayStateChecked));
  SaveCheckValues(Ini, IniSec + '\PayStateFilter', PayStateValues);

  // Виды заказа
  Ini.WriteInteger(IniSec + '\OrderKindFilter\Enabled', Ord(cbOrderKindChecked));
  SaveCheckValues(Ini, IniSec + '\WorkOrderKindFilter', WorkOrderKindValues);
  SaveCheckValues(Ini, IniSec + '\DraftOrderKindFilter', DraftOrderKindValues);
end;

{function GetYear(d: TDateTime): word;
var
  DYear, DMonth, DDay: Word;
begin
  DecodeDate(d, DYear, DMonth, DDay);
  Result := DYear;
end;

function GetMonth(d: TDateTime): word;
var
  DYear, DMonth, DDay: Word;
begin
  DecodeDate(d, DYear, DMonth, DDay);
  Result := DMonth;
end;}

function TFilterObj.GetDateFieldDesc(DateIndex: integer): string;
begin
  raise Exception.Create('TFilterObj.GetDateFieldDesc is not implemented');
end;

{$ENDREGION}

{$REGION 'TOrderFilterObj'}

function TOrderFilterObj.GetDateFieldDesc(DateIndex: integer): string;
const
  DateFieldDesc: array[0..8] of string = ('созданные', 'измененные', 'плановое завершение', 'фактическое завершение',
    'плановое начало работ', 'фактическое начало работ', 'закрытые', 'последняя оплата', 'оплата');
    //, 'изменение состояния');
begin
  Result := DateFieldDesc[DateIndex];
end;

function TOrderFilterObj.FilterEnabled: boolean;
begin
  Result := inherited FilterEnabled or cbCustomerCreatorChecked;
end;

procedure TOrderFilterObj.DisableFilter;
begin
  inherited;
  cbCustomerCreatorChecked := false;
end;

function TOrderFilterObj.GetFilterExpr(e: TEntity): string;
var
  s: string;
  UserCode: integer;
begin
  s := inherited GetFilterExpr(e);
  if not (e is TDraftOrder and AccessManager.CurUser.DraftViewOwnOnly)
    and not (e is TWorkOrder and AccessManager.CurUser.WorkViewOwnOnly)
    and cbCustomerCreatorChecked then
  begin
    if (CustomerCreatorName <> '') then
    begin
      UserCode := AccessManager.GetUserID(CustomerCreatorName);
      if UserCode > 0 then
        add(s, 'wc.UserCode = ' + IntToStr(UserCode));
    end;
  end;
  Result := s;
end;

{$ENDREGION}

{$REGION 'TProductionFilterObj'}

{$IFNDEF NoProduction}

function TProductionFilterObj.GetFilterPhrase(e: TEntity): string;
begin
  Result := inherited GetFilterPhrase(e);
end;

function TProductionFilterObj.GetFilterExpr(e: TEntity): string;
var
  ts: string;
  i: integer;
begin
  Result := inherited GetFilterExpr(e);

  if cbProcessStateChecked then
  begin
    if ProcessStateValues <> nil then
    begin
      ts := '';
      for i := 0 to High(ProcessStateValues) do
      begin
        AddOr(ts, '(dbo.GetProcessExecState(ss.EnablePlanning, j.IsPaused, j.FactStartDate, j.FactFinishDate, j.PlanStartDate, j.PlanFinishDate, GETDATE()) = ' + IntToStr(ProcessStateValues[i]) + ')');
        {if ProcessStateValues[i] = esFactFinished then
          AddOr(ts, '(j.FactFinishDate is not null and (GETDATE() >= j.FactFinishDate))')
        else if ProcessStateValues[i] = esInProgress then
          AddOr(ts, '(j.FactFinishDate is not null and (GETDATE() < j.FactFinishDate))'
              + ' or (j.FactFinishDate is null and j.FactStartDate is not null and (PlanFinishDate is not null and (GETDATE() >= FactStartDate) and (GETDATE() < PlanFinishDate))'
              + ' or (PlanFinishDate is null and GETDATE() >= FactStartDate))')
        else if ProcessStateValues[i] = esPlanFinished then
          AddOr(ts, '((j.FactFinishDate is null and FactStartDate is not null and PlanFinishDate is not null and (GETDATE() < FactStartDate or GETDATE() >= PlanFinishDate)'
                    + ' and GETDATE() >= FactStartDate)'
             + ' or (FactStartDate is null and PlanStartDate is not null and GETDATE() >= PlanStartDate and PlanFinishDate is not null and GETDATE() >= PlanFinishDate))')
        else if ProcessStateValues[i] = esWait then
          AddOr(ts, '((not ss.EnablePlanning = 1 and j.FactFinishDate is null and j.FactStartDate is null) or (ss.EnablePlanning = 1 and GETDATE() < PlanStartDate and PlanStartDate is not null))')
        else if ProcessStateValues[i] = esNotPlanned then
          AddOr(ts, '(ss.EnablePlanning = 1 and j.PlanFinishDate is null and j.PlanStartDate is null)')
        else if ProcessStateValues[i] = esPaused then
          AddOr(ts, 'j.IsPaused = 1');}
        //ts := ts + IntToStr(ProcessStateValues[i]);
        //if i <> High(ProcessStateValues) then ts := ts + ',';
      end;
      Add(Result, '(' + ts + ')');
      //add(s, 'ExecState in (' + ts + ')');  // Здесь отличается
    end
    else
      add(Result, '0=1');
  end;
end;

function TProductionFilterObj.GetLocalFilter: string;
//var
//  i: Integer;
begin
  {if cbProcessStateChecked then
  begin
    //FUseLocalFilter := true;
    if ProcessStateValues <> nil then
    begin
      FLocalFilter := '';
      for i := 0 to High(ProcessStateValues) do
      begin
        FLocalFilter := FLocalFilter + '(ExecState = ' + IntToStr(ProcessStateValues[i]) + ')';
        if i <> High(ProcessStateValues) then FLocalFilter := FLocalFilter + ' or ';
      end;
    end
    else
      FLocalFilter := '1=0';
  end
  else
    FLocalFilter := '';
  Result := FLocalFilter;}
  Result := '';
end;

function TProductionFilterObj.GetDateFieldDesc(DateIndex: integer): string;
const
  DateFieldDesc: array[0..4] of string = ('плановое начало', 'фактическое начало',
    'плановое завершение', 'фактическое завершение', 'сдача заказа');
begin
  Result := DateFieldDesc[DateIndex];
end;
{$ENDIF}

{$ENDREGION}

{$REGION 'TPaymentsFilterObj '}

function TPaymentsFilterObj.GetFilterPhrase(e: TEntity): string;
begin
  Result := inherited GetFilterPhrase(e);
end;

function TPaymentsFilterObj.GetFilterExpr(e: TEntity): string;
begin
  Result := inherited GetFilterExpr(e);
end;

function TPaymentsFilterObj.GetLocalFilter: string;
//var
//  i: Integer;
begin
  {if cbProcessStateChecked then
  begin
    //FUseLocalFilter := true;
    if ProcessStateValues <> nil then
    begin
      FLocalFilter := '';
      for i := 0 to High(ProcessStateValues) do
      begin
        FLocalFilter := FLocalFilter + '(ExecState = ' + IntToStr(ProcessStateValues[i]) + ')';
        if i <> High(ProcessStateValues) then FLocalFilter := FLocalFilter + ' or ';
      end;
    end
    else
      FLocalFilter := '1=0';
  end
  else
    FLocalFilter := '';
  Result := FLocalFilter;}
  Result := '';
end;

function TPaymentsFilterObj.GetDateFieldDesc(DateIndex: integer): string;
const
  DateFieldDesc: array[0..4] of string = ('созданные', 'измененные',
    'плановое завершение', 'фактическое завершение', 'закрытые');
begin
  Result := DateFieldDesc[DateIndex];
end;

{$ENDREGION}

{$REGION 'TInvoicesFilterObj'}

function TInvoicesFilterObj.GetLocalFilter: string;
begin
  Result := '';
end;

function TInvoicesFilterObj.GetDateFieldDesc(DateIndex: integer): string;
const
  DateFieldDesc: array[0..4] of string = ('созданные', 'измененные',
    'плановое завершение', 'фактическое завершение', 'закрытые');
begin
  Result := DateFieldDesc[DateIndex];
end;

{$ENDREGION}

{$REGION 'TShipmentFilterObj'}

function TShipmentFilterObj.GetLocalFilter: string;
begin
  Result := '';
end;

function TShipmentFilterObj.GetDateFieldDesc(DateIndex: integer): string;
const
  DateFieldDesc: array[0..5] of string = ('созданные', 'измененные',
    'плановое завершение', 'фактическое завершение', 'закрытые', 'отгрузка');
begin
  Result := DateFieldDesc[DateIndex];
end;

{$ENDREGION}

{$REGION 'TMaterialFilterObj'}

{RestoreFilter
begin
  // Виды заказа
  try cbOrderKindChecked := Ini.ReadInteger(IniSec + '\OrderKindFilter\Enabled', 0) = 1;
  except cbOrderKindChecked := false; end;
  RestoreCheckValues(Ini, IniSec + '\WorkOrderKindFilter', WorkOrderKindValues, AllWorkOrderKindValues);
  RestoreCheckValues(Ini, IniSec + '\DraftOrderKindFilter', DraftOrderKindValues, AllDraftOrderKindValues);
end;}

function TMaterialFilterObj.GetFilterExpr(e: TEntity): string;
var
  mt, ts: string;
  i: integer;
begin
  Result := inherited GetFilterExpr(e);
  if SupplierChecked then
  begin
    if (SupplierKeyValue > 0) then
    begin
      if SupplierInvert then
        Add(Result, '(SupplierID <> ' + IntToStr(SupplierKeyValue) + ' or SupplierID is null)')
      else
        Add(Result, 'SupplierID = ' + IntToStr(SupplierKeyValue));
    end
    else
      Add(Result, 'SupplierID is null');  // не указан поставщик
  end;
  if (FilterProcessID > 0) then
  begin
    if cbInvertProcessChecked then  // НЕ содержащие процесс
      Add(Result, 'ProcessID <> ' + IntToStr(FilterProcessID))
    else
      Add(Result, 'ProcessID = ' + IntToStr(FilterProcessID));
  end;
  // фильтр по категории материала
  if MatCatChecked and (MatCatCode > 0) then
  begin
    mt := NvlString(TConfigManager.Instance.StandardDics.deMatCats.ItemName[MatCatCode]);
    if mt <> '' then
      Add(Result, 'MatTypeName = ' + QuotedStr(mt));
  end;
  if MatGroupChecked then
  begin
    if MatGroupCodes <> nil then
    begin
      ts := '';
      for i := 0 to High(MatGroupCodes) do
      begin
        ts := ts + IntToStr(MatGroupCodes[i]);
        if i <> High(MatGroupCodes) then ts := ts + ',';
      end;
      add(Result, 'MatTypeName in (select Name from Dic_MaterialCat dmc where dmc.A3 in (' + ts + '))');
    end
    else
      add(Result, '0=1');
  end;
end;

procedure TMaterialFilterObj.ProcessCfgChanged_Handler(Sender: TObject);
begin
  inherited;
  FAllMatGroupCodes := DicCodesToArray(TConfigManager.Instance.StandardDics.deMatGroups);
end;

function TMaterialFilterObj.GetDateFieldDesc(DateIndex: integer): string;
const
  DateFieldDesc: array[0..3] of string = ('создание заказа', 'плановая дата поставки', 'фактическая дата поставки', 'оплата');
begin
  Result := DateFieldDesc[DateIndex];
end;

{$ENDREGION}

{$REGION 'TStockFilterObj'}

function TStockFilterObj.GetDateFieldDesc(DateIndex: integer): string;
const
  DateFieldDesc: array[0..0] of string = ('движения');
begin
  Result := DateFieldDesc[DateIndex];
end;

{$ENDREGION}

{$REGION 'TStockIncomeFilterObj'}

function TStockIncomeFilterObj.GetDateFieldDesc(DateIndex: integer): string;
const
  DateFieldDesc: array[0..0] of string = ('получения');
begin
  Result := DateFieldDesc[DateIndex];
end;

{$ENDREGION}

{$REGION 'TStockIncomeFilterObj'}

function TStockWasteFilterObj.GetDateFieldDesc(DateIndex: integer): string;
const
  DateFieldDesc: array[0..0] of string = ('расхода');
begin
  Result := DateFieldDesc[DateIndex];
end;

{$ENDREGION}

(*initialization

MFFilter := TOrderFilterObj.Create;
{$IFNDEF NoProduction}
ProductionFilter := TProductionFilterObj.Create;
{$ENDIF}
CustomerPaymentsFilter := TPaymentsFilterObj.Create;
InvoicesFilter := TInvoicesFilterObj.Create;

finalization

FreeAndNil(MFFilter);
{$IFNDEF NoProduction}
FreeAndNil(ProductionFilter);
{$ENDIF}
FreeAndNil(CustomerPaymentsFilter);
FreeAndNil(InvoicesFilter);
*)
end.
