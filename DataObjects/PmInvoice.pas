unit PmInvoice;

interface

uses DB, SysUtils, Variants,

  CalcUtils, PmEntity, PmInvoiceItems, MainFilter, PmQueryPager;

type
  TInvoices = class(TEntity)
  private
    FCriteria: TInvoicesFilterObj;
    StateNone, StatePartial, StateFull: integer;
    function GetItems: TInvoiceItems;
    procedure GetTableName(Sender: TObject; DataSet: TDataSet;
      var TableName: WideString);
  protected
    FDataSource: TDataSource;
    procedure CreateFields;
    procedure DoBeforeOpen; override;
    procedure DoOnNewRecord; override;
    procedure DoOnCalcFields; override;
    function GetSQL: TQueryObject;
    function GetCustomerID: variant;
    procedure SetCustomerID(Value: variant);
    function GetInvoiceDate: TDateTime;
    procedure SetInvoiceDate(Value: TDateTime);
    function GetInvoiceNum: variant;
    procedure SetInvoiceNum(Value: variant);
    function GetPayType: integer;
    procedure SetPayType(Value: integer);
    function GetPayTypeName: string;
    function GetNotes: variant;
    procedure SetNotes(Value: variant);
    function GetCustomerName: string;
    function GetCustomerFullName: string;
    function GetInvoiceCost: extended;
    function GetInvoiceOrderPaid: extended;
    function GetInvoiceTotalPaid: extended;
    function GetInvoiceOtherOrderPaid: extended;
    function GetInvoiceOtherInvoicePaid: extended;
    function GetInvoiceDebt: extended;
    function GetInvoiceCredit: extended;
    function GetHasManyItems: boolean;
  public
    const
      F_InvoiceKey = 'InvoiceID';
      F_InvoiceDate = 'InvoiceDate';
      F_InvoiceNum = 'InvoiceNum';
      F_PayState = 'PayState';
      F_PayType = 'PayType';
      F_ContragentID = 'ContragentID';
      F_SyncState = 'SyncState';
      F_Notes = 'Notes';
      InvoiceNumSize = 50;
      DefaultSort = 'YEAR(InvoiceDate), MONTH(InvoiceDate), DAY(InvoiceDate), InvoiceNum';
    constructor Create; override;
    // Возвращает ключи счетов, в которых встречается заказ с ключом OrderID
    class function FindByOrderID(OrderID: integer): TIntArray;
    // Возвращает ключи счетов с номером InvoiceNum, годом InvoiceYear,
    // с указанным видом (или null), кроме ExcludeInvoiceKey
    class function FindByInvoiceNum(_InvoiceNum: string; _InvoiceYear: integer;
      ExcludeInvoiceKey: variant; _PayType: variant): TIntArray;
    function GetItemsNoOpen: TInvoiceItems;
    procedure OpenInvoiceItems;
    property DataSource: TDataSource read FDataSource;
    property Items: TInvoiceItems read GetItems;
    property CustomerID: variant read GetCustomerID write SetCustomerID;
    property InvoiceDate: TDateTime read GetInvoiceDate write SetInvoiceDate;
    property InvoiceNum: variant read GetInvoiceNum write SetInvoiceNum;
    property PayType: integer read GetPayType write SetPayType;
    property PayTypeName: string read GetPayTypeName;
    property Notes: variant read GetNotes write SetNotes;
    property CustomerName: string read GetCustomerName;
    property CustomerFullName: string read GetCustomerFullName;
    property InvoiceCost: extended read GetInvoiceCost;
    property InvoiceTotalPaid: extended read GetInvoiceTotalPaid;
    property InvoiceOrderPaid: extended read GetInvoiceOrderPaid;
    property InvoiceDebt: extended read GetInvoiceDebt;
    property InvoiceCredit: extended read GetInvoiceCredit;
    property HasManyItems: boolean read GetHasManyItems;
    destructor Destroy; override;
    property Criteria: TInvoicesFilterObj read FCriteria write FCriteria;
  end;

implementation

uses Forms, Provider,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData,
  PmContragent, DicObj, StdDic, PmEntSettings, PmAccessManager,
  PmConfigManager;

constructor TInvoices.Create;
var
  _DataSource: TDataSource;
  _DataSet: TDataSet;
  _Provider: TDataSetProvider;
begin
  if PlanDM = nil then
    Application.CreateForm(TPlanDM, PlanDM);

  _DataSource := CreateQueryExDM(PlanDM, PlanDM, ClassName,
    [{poAllowMultiRecordUpdates, poDisableInserts, poDisableDeletes, poDisableEdits}],
    upWhereKeyOnly, false {ResolveToDataSet}, Database.Connection, _Provider);
  _DataSet := _DataSource.DataSet;

  inherited Create;
  FKeyField := F_InvoiceKey;

  FInternalName := ClassName;
  DefaultLastRecord := true;

  SetDataSet(_DataSet);
  _Provider.UpdateMode := upWhereKeyOnly;
  _Provider.OnGetTableName := GetTableName;
  DataSetProvider := _Provider;

  //FDataSource.Free;  // меняем на свой
  FDataSource := _DataSource;

  CreateFields;

  FDisableChildDataFilter := true;
  DetailData[0] := TInvoiceItems.Create;

  SetLength(FDateFields, 2);
  FDateFields[0] := F_InvoiceDate;
  FDateFields[1] := 'wo.CreationDate';
  {FDateFields[2] := 'wo.FinishDate';
  FDateFields[3] := 'wo.FactFinishDate';
  FDateFields[4] := 'wo.CloseDate';}

  FSortField := DefaultSort;
end;

destructor TInvoices.Destroy;
begin
  GetDetailDataNoOpen(0).Free;
  inherited;
end;

procedure TInvoices.CreateFields;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_InvoiceKey;
  f.ProviderFlags := [pfInKey, pfInWhere];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_InvoiceNum;
  f.Size := InvoiceNumSize;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := F_InvoiceDate;
  (f as TDateTimeField).DisplayFormat := ShortDateFormat2;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_ContragentID;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_SyncState;
  f.ProviderFlags := [];
  f.Origin := 'i.' + F_SyncState;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_PayType;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_Notes;
  f.Size := 300;
  f.ProviderFlags := [pfInUpdate];
  f.Origin := 'i.' + F_Notes;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'UserLogin';
  f.Size := 50;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'UserName';
  f.ReadOnly := true;
  f.Size := 50;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Origin := 'au.Name';
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceCost';
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceOrderPaid';
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.ReadOnly := true;
  f.Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceOrdersCost';
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.ReadOnly := true;
  f.Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceOnlyTotalPaid';
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.ReadOnly := true;
  f.Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceOtherOrderPaid';
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.ReadOnly := true;
  f.Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceOtherInvoicePaid';
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.ReadOnly := true;
  f.Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'CustomerName';
  f.ReadOnly := true;
  f.Size := TContragents.CustNameSize;
  f.ProviderFlags := [];
  f.Origin := 'c.Name';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'CustomerFullName';
  f.ReadOnly := true;
  f.Size := 300;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TInvoiceItems.F_ItemText;
  f.Size := TInvoiceItems.ItemTextSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'OrderNumber';
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := 'HasManyItems';
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  // Вычисляемые

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceDebt';
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.FieldKind := fkCalculated;
  f.Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceCredit';
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.FieldKind := fkCalculated;
  f.Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceTotalPaid';
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.FieldKind := fkCalculated;
  f.Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'PayTypeName';
  f.FieldKind := fkCalculated;
  f.Size := 50;
  f.ProviderFlags := [];
  f.Origin := 'i.PayType';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_PayState;
  f.Calculated := EntSettings.NewInvoicePayState;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  NewRecordProc := 'up_NewInvoice';
  DeleteRecordProc := 'up_DeleteInvoice';
end;

// сумма разнесенных оплат
function GetOrderPayCostExpr: string;
begin
  Result := 'cast(ISNULL((select sum(PayCost) from Payments pay inner join InvoiceItems ii on pay.InvoiceItemID = ii.InvoiceItemID where ii.InvoiceID = i.InvoiceID), 0) as decimal(18,2))';
end;

// сумма стоимости заказов, участвующих в счете
function GetOrderCostExpr: string;
begin
  Result := 'cast(ISNULL((select sum(case when FinalCostGrn > ii.ItemCost then ii.ItemCost else FinalCostGrn end) from OrderProcessItem opi inner join WorkOrder wo on wo.N = opi.OrderID'#13#10
    + ' inner join Service_ClientPrice scp on scp.ItemID = opi.ItemID inner join InvoiceItems ii on wo.N = ii.OrderID'#13#10
    + ' where ii.InvoiceID = i.InvoiceID), 0) as decimal(18,2))';
end;

// сумма всех оплат
function GetTotalPayCostExpr: string;
begin
  Result := 'cast(ISNULL((select sum(IncomeGrn) from CustomerIncome ci where ci.IncomeInvoiceID = i.InvoiceID), 0) as decimal(18,2))';
end;

function GetItemCostExpr: string;
begin
  Result := 'cast(ISNULL((select sum(ItemCost) from InvoiceItems id where id.InvoiceID = i.InvoiceID), 0) as decimal(18,2))';
end;

function GetOtherOrderPayCostExpr: string;
begin
  if EntSettings.InvoiceAllPayments then
    // Оплаты счета, разнесенные на заказы, не входящие в счет
    Result := 'cast(ISNULL((select sum(PayCost) from Payments pay inner join CustomerIncome ci on pay.IncomeID = ci.IncomeID'#13#10
      + 'inner join InvoiceItems ii on ii.InvoiceItemID = pay.InvoiceItemID'#13#10
      + 'where ci.IncomeInvoiceID = i.InvoiceID and ii.InvoiceID <> i.InvoiceID), 0) as decimal(18,2))'
  else
    Result := 'CAST(0 as decimal(18, 2))';
end;

function GetOtherInvoicePayCostExpr: string;
begin
  if EntSettings.InvoiceAllPayments then
    // оплаты заказов этого счета, пришедшие с поступлений по другим счетам
    Result := 'cast(ISNULL((select sum(PayCost) from Payments pay inner join CustomerIncome ci on pay.IncomeID = ci.IncomeID'#13#10
      + 'inner join InvoiceItems ii on ii.InvoiceItemID = pay.InvoiceItemID'#13#10
      + 'where ci.IncomeInvoiceID <> i.InvoiceID and ii.InvoiceID = i.InvoiceID), 0) as decimal(18,2))'
  else
    Result := 'CAST(0 as decimal(18, 2))';
end;

procedure add(var s: string; adds: string);
begin
  if s <> '' then
    s := '(' + s + ') and (' + adds + ')'
  else
    s := adds;
end;

function TInvoices.GetSQL: TQueryObject;
var
  expr: string;
  InvFilter, OrdFilter, UName: string;
  i: integer;
begin
  // Здесь считываем для CalcFields
  TConfigManager.Instance.GetDefaultPayStates(StateNone, StatePartial, StateFull);

  //expr := InvoicesFilter.GetFilterExpr(Self);
  //if expr <> '' then expr := ' and (' + expr + ')';
  InvFilter := '';
  if not VarIsNull(FCriteria.InvoiceID) and not VarIsEmpty(FCriteria.InvoiceID) then
    InvFilter := 'i.InvoiceID = ' + VarToStr(FCriteria.InvoiceID)
  else
  if FCriteria.cbMonthYearChecked then
  begin
    if FCriteria.cbDateTypeIndex = 0 then
      FCriteria.AppendDateFilterExpr(InvFilter, F_InvoiceDate, false)
    else
    if FCriteria.cbDateTypeIndex = 1 then
    begin
      FCriteria.AppendDateFilterExpr(OrdFilter, 'wo.CreationDate', false);
      if OrdFilter <> '' then
        InvFilter := 'exists(select * from InvoiceItems iiw inner join WorkOrder wo'
          + ' on iiw.OrderID = wo.N where iiw.InvoiceID = i.InvoiceID and (' + OrdFilter + '))';
    end;
  end;

  //if InvFilter <> '' then InvFilter := ' and (' + InvFilter + ')';

  Result.Select := 'InvoiceID, InvoiceNum, InvoiceDate, i.Notes, i.PayType,'#13#10
    + ' ' + GetItemCostExpr + ' as InvoiceCost,'#13#10
    + ' ' + GetOrderCostExpr + ' as InvoiceOrdersCost,'#13#10
    + ' ' + GetOrderPayCostExpr + ' as InvoiceOrderPaid,'#13#10
    + ' ' + GetTotalPayCostExpr + ' as InvoiceOnlyTotalPaid,'#13#10
    + ' ' + GetOtherOrderPayCostExpr + ' as InvoiceOtherOrderPaid,'#13#10
    + ' ' + GetOtherInvoicePayCostExpr + ' as InvoiceOtherInvoicePaid,'#13#10;

  if not EntSettings.NewInvoicePayState then
   // в функцию GetPayState передаются коды состояний "не оплачено", "частично оплачено", "оплачено"
     Result.Select := Result.Select + ' dbo.GetPayState(' + GetTotalPayCostExpr + ', ' + GetItemCostExpr + ', dc.A4, dc.A5, dc.A6) as PayState,'#13#10;

  Result.Select := Result.Select
    + ' ContragentID, c.Name as CustomerName, c.FullName as CustomerFullName,'#13#10
    + ' UserLogin, au.Name as UserName, i.SyncState,'#13#10
    + ' (select top 1 ItemText from InvoiceItems ii where ii.InvoiceID = i.InvoiceID) as ItemText,'#13#10
    + ' (select top 1 ID_Number from WorkOrder wo inner join InvoiceItems ii on ii.OrderID = wo.N where ii.InvoiceID = i.InvoiceID) as OrderNumber,'#13#10
    + ' cast((case (select count(*) from InvoiceItems ii2 where ii2.InvoiceID = i.InvoiceID) when 1 then 0 when 0 then 0 else 1 end) as bit) as HasManyItems';
  Result.From := 'inner join Customer c on i.ContragentID = c.N'#13#10
    + ' inner join Dic_Cash dc on dc.Code = i.PayType'#13#10
    + ' left join AccessUser au on au.Login = i.UserLogin'#13#10;

  if FCriteria.PayerChecked and (FCriteria.PayerKeyValue > 0) then
  begin
    expr := 'i.ContragentID = ' + IntToStr(FCriteria.PayerKeyValue);
    add(InvFilter, expr);
  end;
  if FCriteria.cbCustChecked and (FCriteria.lcCustKeyValue > 0) then
  begin
    expr := 'exists(select * from WorkOrder wo inner join InvoiceItems ii on ii.OrderID = wo.N'#13#10
      + ' where ii.InvoiceID = i.InvoiceID and wo.Customer = ' + IntToStr(FCriteria.lcCustKeyValue) + ')';
    add(InvFilter, expr);
  end;
  if (FCriteria.cbCreatorChecked and (FCriteria.CreatorName <> '')) or AccessManager.CurUser.WorkViewOwnOnly then
  begin
    if AccessManager.CurUser.WorkViewOwnOnly then
      UName := AccessManager.CurUser.Login
    else
      UName := FCriteria.CreatorName;
    expr := 'exists(select * from WorkOrder wo inner join InvoiceItems ii on ii.OrderID = wo.N'#13#10
      + ' where ii.InvoiceID = i.InvoiceID and wo.CreatorName = ''' + UName + ''')';
    add(InvFilter, expr);
  end;
  if NvlString(FCriteria.InvoiceNum) <> '' then
  begin
    expr := F_InvoiceNum + ' = ''' + FCriteria.InvoiceNum + '''';
    add(InvFilter, expr);
  end;
  if FCriteria.PayTypeChecked and (FCriteria.PayTypeCode > 0) then
  begin
    expr := 'PayType = ' + IntToStr(FCriteria.PayTypeCode);
    add(InvFilter, expr);
  end;

  if not EntSettings.NewInvoicePayState then
  begin
    // поле состояния не вычисляемое в этом случаеб и можно сделать фильтр
    if FCriteria.cbPayStateChecked then
    begin
      if FCriteria.PayStateValues <> nil then
      begin
        expr := '';
        for i := 0 to High(FCriteria.PayStateValues) do
        begin
          expr := expr + IntToStr(FCriteria.PayStateValues[i]);
          if i <> High(FCriteria.PayStateValues) then expr := expr + ',';
        end;
        add(InvFilter, 'dbo.GetPayState(' + GetTotalPayCostExpr + ', ' + GetItemCostExpr
          + ', dc.A4, dc.A5, dc.A6) in (' + expr + ')');
      end
      else
        add(InvFilter, '0=1');
    end;
  end;

  if InvFilter <> '' then
    Result.Where := InvFilter;

  if (FSortField = F_InvoiceDate) or (FSortField = F_InvoiceNum) then
    Result.Sort := DefaultSort
  else
    Result.Sort := FSortField;
  Result.TableName := 'Invoices';
  Result.TableAlias := 'i';
  Result.KeyFieldName := KeyField;
end;

procedure TInvoices.DoBeforeOpen;
begin
  inherited DoBeforeOpen;
  QueryObject := GetSQL;
  SetQuerySQL(DataSource, QueryObject.GetSQL);
end;

procedure TInvoices.DoOnCalcFields;
var
  c, InvOnly, InvOther, InvCost: extended;
begin
  // сумма оплат
  {c := NvlFloat(DataSet['InvoiceOnlyTotalPaid']);
  if EntSettings.InvoiceAllPayments then
    c := c + NvlFloat(DataSet['InvoiceOtherInvoicePaid']);
  DataSet['InvoiceTotalPaid'] := c;}
  InvOnly := NvlFloat(DataSet['InvoiceOnlyTotalPaid']);
  InvCost := NvlFloat(DataSet['InvoiceCost']);
  if EntSettings.InvoiceAllPayments then
  begin
    //DataSet['InvoiceTotalPaid'] := NvlFloat(DataSet['InvoiceOrderPaid'])
    InvOther := NvlFloat(DataSet['InvoiceOtherInvoicePaid']);
    if InvOnly + InvOther > InvCost then
      DataSet['InvoiceTotalPaid'] := InvCost
    else
      DataSet['InvoiceTotalPaid'] := InvOnly + InvOther;
  end
  else
    DataSet['InvoiceTotalPaid'] := InvOnly;

  // Долг
  c := InvCost - NvlFloat(DataSet['InvoiceTotalPaid']);
  if c > 0 then
  begin
    if c > 0 then
      DataSet['InvoiceDebt'] := c
    else
      DataSet['InvoiceDebt'] := 0;
  end
  else
    DataSet['InvoiceDebt'] := 0;

  if EntSettings.NewInvoicePayState then
  begin
    if DataSet['InvoiceDebt'] <= 0.01 then
      DataSet[F_PayState] := StateFull
    else if DataSet['InvoiceTotalPaid'] > 0 then
      DataSet[F_PayState] := StatePartial
    else
      DataSet[F_PayState] := StateNone;
  end;

  // переплата по заказам
  c := InvOnly - NvlFloat(DataSet['InvoiceOrdersCost']);
  if c > 0 then
  begin
    if EntSettings.InvoiceAllPayments then
      c := c - NvlFloat(DataSet['InvoiceOtherOrderPaid']);
    if c > 0 then
      DataSet['InvoiceCredit'] := c
    else
      DataSet['InvoiceCredit'] := 0;
  end
  else
    DataSet['InvoiceCredit'] := 0;

  if VarIsNull(PayType) then
    DataSet['PayTypeName'] := ''
  else
    DataSet['PayTypeName'] := TConfigManager.Instance.StandardDics.dePayKind.ItemName[PayType];
end;

function TInvoices.GetItems: TInvoiceItems;
var
  Cr: TInvoiceItemsCriteria;
  //k: integer;
begin
  Result := GetItemsNoOpen;
  //if (NvlInteger(KeyValue) > 0) then
  //begin
  {k := NvlInteger(KeyValue);
  if k < 0 then
    k := 0;}
  if (Result.Criteria.InvoiceID <> NvlInteger(KeyValue)) then
  begin
    Cr := Result.Criteria;
    Cr.InvoiceID := NvlInteger(KeyValue);
    Result.Criteria := Cr;
    Result.Reload;
  end
  else
  if not Result.Active then
    Result.Open;
  //end;
end;

function TInvoices.GetItemsNoOpen: TInvoiceItems;
begin
  Result := GetDetailDataNoOpen(0) as TInvoiceItems;
end;

function TInvoices.GetCustomerID: variant;
begin
  Result := DataSet['ContragentID'];
end;

procedure TInvoices.SetCustomerID(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['ContragentID'] := Value;
end;

function TInvoices.GetInvoiceDate: TDateTime;
begin
  Result := NvlDateTime(DataSet[F_InvoiceDate]);
end;

procedure TInvoices.SetInvoiceDate(Value: TDateTime);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_InvoiceDate] := Value;
end;

function TInvoices.GetInvoiceNum: variant;
begin
  Result := DataSet[F_InvoiceNum];
end;

procedure TInvoices.SetInvoiceNum(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_InvoiceNum] := Value;
end;

function TInvoices.GetPayType: integer;
begin
  Result := NvlInteger(DataSet['PayType']);
end;

procedure TInvoices.SetPayType(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['PayType'] := Value;
end;

function TInvoices.GetPayTypeName: string;
begin
  Result := DataSet['PayTypeName'];
end;

function TInvoices.GetNotes: variant;
begin
  Result := DataSet[F_Notes];
end;

procedure TInvoices.SetNotes(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_Notes] := Value;
end;

function TInvoices.GetCustomerName: string;
begin
  Result := DataSet['CustomerName'];
end;

function TInvoices.GetCustomerFullName: string;
begin
  Result := DataSet['CustomerFullName'];
end;

function TInvoices.GetInvoiceCost: extended;
begin
  Result := DataSet['InvoiceCost'];
end;

function TInvoices.GetInvoiceOrderPaid: extended;
begin
  Result := DataSet['InvoiceOrderPaid'];
end;

function TInvoices.GetInvoiceTotalPaid: extended;
begin
  Result := DataSet['InvoiceTotalPaid'];
end;

function TInvoices.GetInvoiceOtherOrderPaid: extended;
begin
  Result := DataSet['InvoiceOtherOrderPaid'];
end;

function TInvoices.GetInvoiceOtherInvoicePaid: extended;
begin
  Result := DataSet['InvoiceOtherInvoicePaid'];
end;

function TInvoices.GetInvoiceDebt: extended;
begin
  Result := NvlFloat(DataSet['InvoiceDebt']);
end;

function TInvoices.GetInvoiceCredit: extended;
begin
  Result := DataSet['InvoiceCredit'];
end;

function TInvoices.GetHasManyItems: boolean;
begin
  Result := NvlBoolean(DataSet['HasManyItems']);
end;

// Возвращает ключи счетов, в которых встречается заказ с ключом OrderID
class function TInvoices.FindByOrderID(OrderID: integer): TIntArray;
var
  KeyData: TDataSet;
  s: string;
  i: integer;
begin
  s := 'select distinct ' + F_InvoiceKey + ' from InvoiceItems ii'
     + ' where ii.OrderID = ' + IntToStr(OrderID);
  KeyData := Database.ExecuteQuery(s);
  try
    KeyData.First;
    SetLength(Result, KeyData.RecordCount);
    i := 0;
    while not KeyData.Eof do
    begin
      Result[i] := KeyData[F_InvoiceKey];
      KeyData.Next;
    end;
  finally
    KeyData.Free;
  end;
end;

// Возвращает ключи счетов с номером InvoiceNum и годом InvoiceYear,
// у которых ключ не равен ExcludeInvoiceKey
class function TInvoices.FindByInvoiceNum(_InvoiceNum: string; _InvoiceYear: integer;
  ExcludeInvoiceKey: variant; _PayType: variant): TIntArray;
var
  KeyData: TDataSet;
  s: string;
  i: integer;
begin
  s := 'select ' + F_InvoiceKey + ' from Invoices'
     + ' where ' + F_InvoiceNum + ' = ''' + _InvoiceNum
     + ''' and YEAR(' + F_InvoiceDate + ') = ' + IntToStr(_InvoiceYear)
     + ' and ' + F_InvoiceKey + ' <> ' + IntToStr(NvlInteger(ExcludeInvoiceKey));
  if not VarIsNull(_PayType) then
    s := s + ' and PayType = ' + IntToStr(NvlInteger(_PayType));
  KeyData := Database.ExecuteQuery(s);
  try
    KeyData.First;
    SetLength(Result, KeyData.RecordCount);
    i := 0;
    while not KeyData.Eof do
    begin
      Result[i] := KeyData[TInvoices.F_InvoiceKey];
      KeyData.Next;
    end;
  finally
    KeyData.Free;
  end;
end;

procedure TInvoices.GetTableName(Sender: TObject; DataSet: TDataSet;
    var TableName: WideString);
begin
  TableName := 'Invoices';
end;

procedure TInvoices.DoOnNewRecord;
begin
  inherited;
end;

procedure TInvoices.OpenInvoiceItems;
var
  id: integer;
  cr: TInvoiceItemsCriteria;
begin
  if (DataSet.RecordCount > 0) then
    id := KeyValue
  else
    id := 0;
  cr.InvoiceID := id;
  if FCriteria.cbDateTypeIndex = 1 then
  begin
    cr.OrderFilter := '';
    FCriteria.AppendDateFilterExpr(cr.OrderFilter, 'wo.CreationDate', false);
  end;
  (GetDetailDataNoOpen(0) as TInvoiceItems).Criteria := cr;
  GetDetailDataNoOpen(0).Reload;
end;

end.
