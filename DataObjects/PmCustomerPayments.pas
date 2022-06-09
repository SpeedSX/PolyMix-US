unit PmCustomerPayments;

interface

uses DB, Forms, Classes, Variants, SysUtils, Provider,

  CalcUtils, JvInterpreter_CustomQuery, PlanData, RDBUtils,
  CalcSettings, PmEntity, MainFilter;

type
  TCustomerPayDetails = class(TEntity)
  private
    FDataSource: TDataSource;
  protected
    FCustomerID: integer;
    FNumberField: string;
    procedure SetCustomerID(Value: integer);
    procedure DoBeforeOpen; override;
    procedure CreateDataSet; virtual; abstract;
    function GetSQL: string; virtual; abstract;
  public
    property CustomerID: integer read FCustomerID write SetCustomerID;
    property DataSource: TDataSource read FDataSource;
    property NumberField: string read FNumberField;

    procedure Init(DataSetName, KeyFieldName: string);
    constructor Copy(Source: TCustomerPayDetails);
    destructor Destroy; override;
    function GetOrderPrefix: string;
  end;

  TCustomerOrders = class(TCustomerPayDetails)
  private
    FCriteria: TPaymentsFilterObj;
    function GetToPayGrn: extended;
    function GetInvoiceNum: variant;
    function GetOrderNumber: variant;
    function GetCreationDate: TDateTime;
    function GetComment: variant;
    function GetPayTotal: extended;
    function GetInvoiceTotal: extended;
    function GetFinalCost: extended;
    //function GetIDsByFilter(_Filter: string): TIntArray;
    function GetFieldCustomerID: integer;
    function GetCustomerName: string;
  protected
    procedure CreateDataSet; override;
    function GetSQL: string; override;
    procedure DoOnCalcFields; override;
  public
    const
      F_CustomerName = 'CustomerName';
      
    constructor Create; override;
    destructor Destroy; override;
    function FindByOrderNumber(_OrderNumber: integer): TIntArray;
    function FindByInvoiceNumber(_InvoiceNumber: string): TIntArray;
    function LocateInvoice(_InvoiceNum: string): boolean;
    property PayDebtGrn: extended read GetToPayGrn;
    property InvoiceNumber: variant read GetInvoiceNum;
    property OrderNumber: variant read GetOrderNumber;
    property CreationDate: TDateTime read GetCreationDate;
    property Comment: variant read GetComment;
    property PayTotal: extended read GetPayTotal;
    property FinalCost: extended read GetFinalCost;
    property InvoiceTotal: extended read GetInvoiceTotal;
    property FieldCustomerID: integer read GetFieldCustomerID;
    property CustomerName: string read GetCustomerName;
    property Criteria: TPaymentsFilterObj read FCriteria write FCriteria;
  end;

  TCustomerPaymentsCriteria = record
    IncomeID: variant;
    OrderID: variant;
  end;

  TCustomerPayments = class(TCustomerPayDetails)
  private
    FCriteria: TCustomerPaymentsCriteria;
    function GetPaidGrn: extended;
    procedure SetPaidGrn(Value: extended);
    function GetPayType: integer;
    procedure SetPayType(Value: integer);
    function GetPayDate: TDateTime;
    procedure SetPayDate(Value: TDateTime);
    function GetOrderID: integer;
    procedure SetOrderID(Value: integer);
    function GetIncomeID: variant;
    procedure SetIncomeID(Value: variant);
    function GetFullPayment: boolean;
    procedure SetFullPayment(Value: boolean);
    function GetInvoiceItemID: integer;
    procedure SetInvoiceItemID(Value: integer);
  protected
    procedure CreateDataSet; override;
    function GetSQL: string; override;
    procedure DoOnCalcFields; override;
    procedure GetTableName(Sender: TObject; DataSet: TDataSet;
      var TableName: WideString);
  public
    const
      F_PaymentID = 'PaymentID';
    constructor Create; override;
    property PaidGrn: extended read GetPaidGrn write SetPaidGrn;
    property PayType: integer read GetPayType write SetPayType;
    property PayDate: TDateTime read GetPayDate write SetPayDate;
    property OrderID: integer read GetOrderID write SetOrderID;
    property IncomeID: variant read GetIncomeID write SetIncomeID;
    // Не устанавливается запросом, используется при внесении оплат
    property FullPayment: boolean read GetFullPayment write SetFullPayment;
    // Не устанавливается запросом, используется при внесении оплат
    property InvoiceItemID: integer read GetInvoiceItemID write SetInvoiceItemID;
    // Критерий выборки
    property Criteria: TCustomerPaymentsCriteria read FCriteria write FCriteria;
  end;

  TCustomerIncomes = class(TCustomerPayDetails)
  private
    FOrderNumbers: TIntArray;
    FOrderNumberTmpKeys: TIntArray;
    FInvoiceNumbers: array of string;
    FInvoiceNumberTmpKeys: TIntArray;
    FInvItemIDs: TIntArray;
    FInvItemTmpKeys: TIntArray;
    FCriteria: TPaymentsFilterObj;
    function GetIncomeGrn: extended;
    procedure SetIncomeGrn(Value: extended);
    function GetReturnCost: extended;
    procedure SetReturnCost(Value: extended);
    function GetPayType: integer;
    procedure SetPayType(Value: integer);
    function GetPayTypeName: string;
    function GetIncomeDate: TDateTime;
    procedure SetIncomeDate(Value: TDateTime);
    function GetRestIncome: extended;
    function GetGetterComment: string;
    procedure SetGetterComment(Value: string);
    procedure GetTableName(Sender: TObject; DataSet: TDataSet;
      var TableName: WideString);
    function GetOrderNumber: variant;
    function GetInvoiceNum: variant;
    function GetIncomeInvoiceNum: variant;
    procedure SetOrderNumber(Value: variant);
    procedure SetInvoiceNumber(Value: variant);
    procedure SetFieldCustomerID(Value: integer);
    function GetFieldCustomerID: integer;
    function GetCustomerName: string;
    function GetInvoiceID: variant;
    procedure SetInvoiceID(Value: variant);
    function GetInvoiceItemID: variant;
    procedure SetInvoiceItemID(Value: variant);
  protected
    procedure CreateDataSet; override;
    function GetSQL: string; override;
    procedure DoOnNewRecord; override;
    procedure DoOnCalcFields; override;
    procedure DoBeforeApplyUpdates; override;
    procedure DoAfterOpen; override;
  public
    constructor Create; override;

    class function GetPrepareContragentTempTable(CustomerID: integer): string;

    property PayType: integer read GetPayType write SetPayType;
    property PayTypeName: string read GetPayTypeName;
    property IncomeGrn: extended read GetIncomeGrn write SetIncomeGrn;
    property IncomeDate: TDateTime read GetIncomeDate write SetIncomeDate;
    property ReturnCost: extended read GetReturnCost write SetReturnCost;  // коррекция
    property GetterComment: string read GetGetterComment write SetGetterComment;
    property RestIncome: extended read GetRestIncome;
    property OrderNumber: variant read GetOrderNumber write SetOrderNumber;
    // вводится при внесении поступлений
    property InvoiceNumber: variant read GetInvoiceNum write SetInvoiceNumber;
    // читается из базы в соответствие с InvoiceID, не получилось объединить с полем InvoiceNum,
    // так как была ошибка при обновлении.
    property IncomeInvoiceNumber: variant read GetIncomeInvoiceNum;
    property FieldCustomerID: integer read GetFieldCustomerID write SetFieldCustomerID;
    property CustomerName: string read GetCustomerName;
    property InvoiceID: variant read GetInvoiceID write SetInvoiceID;
    property Criteria: TPaymentsFilterObj read FCriteria write FCriteria;
    // временное поле, используется только при внесении оплат
    property InvoiceItemID: variant read GetInvoiceItemID write SetInvoiceItemID;
  end;

implementation

uses DBClient, JvJCLUtils, PmAccessManager, PmDatabase, StdDic, DicObj, PmInvoice,
  PmContragent, PmConfigManager, PmOrder;

{$REGION 'TCustomerPayDetails' }

procedure TCustomerPayDetails.Init(DataSetName, KeyFieldName: string);
var
  _Provider: TDataSetProvider;
begin
  FKeyField := KeyFieldName;

  FInternalName := DataSetName;

  if PlanDM = nil then
    Application.CreateForm(TPlanDM, PlanDM);

  FDataSource := CreateQueryExDM(PlanDM, PlanDM, DataSetName,
    [{poAllowMultiRecordUpdates, poDisableInserts, poDisableDeletes, poDisableEdits}],
    upWhereKeyOnly, false {ResolveToDataSet}, Database.Connection, _Provider);
  SetDataSet(FDataSource.DataSet);
  DataSetProvider := _Provider;

  CreateDataSet;

  FNumberField := 'wo.ID_Number';
  SetLength(FDateFields, 5);
  FDateFields[0] := 'wo.CreationDate';
  FDateFields[1] := 'wo.ModifyDate';
  FDateFields[2] := 'wo.FinishDate';
  FDateFields[3] := 'wo.FactFinishDate';
  FDateFields[4] := 'wo.CloseDate';

  //FDataSource.Free;
  //FDataSource := _DataSource;

  RefreshAfterApply := false; // для Income важно, чтобы обновлялось не больше одного раза после применения изменений,
  // т.к. там восстанавливаются значения InternalCalc полей
end;

constructor TCustomerPayDetails.Copy(Source: TCustomerPayDetails);
begin
  inherited Create;
  FKeyField := Source.KeyField;
  SetDataSet(Source.CopyData(false));
  FDataSource := TDataSource.Create(nil);  // TODO: както это все не очень... и деструктор пришлось прикрутить
  FDataSource.DataSet := DataSet;
  FMasterData := Source.FMasterData;
  FMaxKeyValue := Source.FMaxKeyValue;

  FCustomerID := Source.CustomerID;
end;

destructor TCustomerPayDetails.Destroy;
begin
  inherited;
  //if (FDataSource <> nil) and (FDataSource.Owner = nil) then
  //  FDataSource.Free;
end;

procedure TCustomerPayDetails.DoBeforeOpen;
begin
  SetQuerySQL(FDataSource, GetSQL);
end;

procedure TCustomerPayDetails.SetCustomerID(Value: integer);
begin
  FCustomerID := Value;
  Reload;
end;

function TCustomerPayDetails.GetOrderPrefix: string;
begin
  Result := 'wo.';
end;

{$ENDREGION}

{$REGION 'TCustomerOrders' }

constructor TCustomerOrders.Create;
begin
  inherited Create;
  Init('CustomerOrders', TContragents.F_CustKey);
end;

destructor TCustomerOrders.Destroy;
begin
  inherited;
end;

procedure TCustomerOrders.CreateDataSet;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TContragents.F_CustKey;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_OrderNumber;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := TContragents.F_CreationDate;
  f.DataSet := DataSet;
  (f as TDateTimeField).DisplayFormat := ShortDateFormat2;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'Comment';
  f.Size := 128;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'TotalPaidGrn';
  f.Size := 2;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'ClientTotal';
  f.Size := 2;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_Course;
  f.Size := 2;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'FinalCostGrn';
  f.Size := 2;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceTotal';
  f.Size := 2;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceTotalPaid';
  f.Size := 2;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'OtherOrdersPaid';
  f.Size := 2;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceNum';
  f.Size := 40;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'CustomerID';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_CustomerName;
  f.Size := TContragents.CustNameSize;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  // Calculated

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'ToPayGrn';
  f.Size := 2;
  f.FieldKind := fkCalculated;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'ClientTotalGrn';
  f.Size := 2;
  f.FieldKind := fkCalculated;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

end;

function TCustomerOrders.GetSQL: string;
var
  expr, andexpr: string;
begin
  expr := FCriteria.GetFilterExpr(Self);
  andexpr := ' and ' + expr;

  Result := 'select wo.N, wo.ID_Number, wo.CreationDate, wo.Comment, cc.Name as CustomerName,' + #13#10
    + ' cast(ISNULL((select sum(sp.PayCost)' + #13#10
      // сумма оплат по заказу
      + ' from Payments sp inner join InvoiceItems ii on sp.InvoiceItemID = ii.InvoiceItemID' + #13#10
      + ' where ii.OrderID = wo.N' + andexpr + '), 0) as decimal(18,2)) as TotalPaidGrn,' + #13#10
      // сумма счетов, связанных с заказом
    + ' cast(ISNULL((select sum(ii.ItemCost)' + #13#10
      + ' from InvoiceItems ii' + #13#10
      + ' where ii.OrderID = wo.N' + andexpr + '), 0) as decimal(18,2)) as InvoiceTotal,' + #13#10
      // один номер счета
    + ' ISNULL((select top 1 InvoiceNum' + #13#10
      + ' from Invoices sp inner join InvoiceItems ii on sp.InvoiceID = ii.InvoiceID' + #13#10
      + ' where ii.OrderID = wo.N' + andexpr + '), '''') as InvoiceNum,' + #13#10
      // сумма всех оплат по всем счетам
    + ' cast(ISNULL((select sum(ci.IncomeGrn) from CustomerIncome ci inner join Invoices i on i.InvoiceID = ci.IncomeInvoiceID' + #13#10
      + ' where exists(select * from InvoiceItems ii where ii.InvoiceID = i.InvoiceID and ii.OrderID = wo.N)), 0) as decimal(18,2)) as InvoiceTotalPaid,' + #13#10
      // сумма всех оплат по всем счетам, разнесенных на другие заказы
    + ' cast(ISNULL((select sum(pp.PayCost) from Payments pp inner join InvoiceItems ii on pp.InvoiceItemID = ii.InvoiceItemID where ii.OrderID <> wo.N' + #13#10
      + ' and exists(select * from InvoiceItems ii1 inner join Invoices i1 on i1.InvoiceID = ii1.InvoiceID where i1.InvoiceID = ii.InvoiceID and ii1.OrderID = wo.N)), 0) as decimal(18,2)) as OtherOrdersPaid,' + #13#10
    + ' FinalCostGrn, wo.Customer as CustomerID,' + #13#10
    + ' ClientTotal, Course' + #13#10
    + 'from AliveWorkOrders wo with (noexpand) left join OrderProcessItem opi'
    + ' inner join Service_ClientPrice sp on opi.ItemID = sp.ItemID' + #13#10
    + '   on opi.OrderID = wo.N' + #13#10
    + ' left join Customer cc on cc.N = wo.Customer' + #13#10;
  if FCustomerID > 0 then
  begin
    if expr <> '' then
      expr := expr + ' and (Customer = ' + IntToStr(FCustomerID) + ')'
    else
      expr := 'Customer = ' + IntToStr(FCustomerID);
  end;
  if expr <> '' then
    Result := Result + 'where ';
  Result := Result //+ 'wo.IsDeleted = 0 and IsDraft = 0' + #13#10
    + expr + #13#10
    + 'order by wo.CreationDate';
end;

procedure TCustomerOrders.DoOnCalcFields;
var
  ClientTotal: extended;
begin
  if VarIsNull(DataSet['FinalCostGrn']) then
    ClientTotal := NvlFloat(DataSet['ClientTotal']) * DataSet[TOrder.F_Course]
  else
    ClientTotal := DataSet['FinalCostGrn'];
  DataSet['ClientTotalGrn'] := ClientTotal;
  DataSet['ToPayGrn'] := ClientTotal - NvlFloat(DataSet['TotalPaidGrn']);
end;

function TCustomerOrders.GetToPayGrn: extended;
begin
  Result := NvlFloat(DataSet['ToPayGrn']);
end;

function TCustomerOrders.GetInvoiceNum: variant;
begin
  Result := DataSet['InvoiceNum'];
end;

function TCustomerOrders.GetOrderNumber: variant;
begin
  Result := DataSet[TOrder.F_OrderNumber];
end;

function TCustomerOrders.GetCreationDate: TDateTime;
begin
  Result := DataSet['CreationDate'];
end;

function TCustomerOrders.GetComment: variant;
begin
  Result := DataSet['Comment'];
end;

function TCustomerOrders.GetPayTotal: extended;
begin
  Result := DataSet['TotalPaidGrn'];
end;

function TCustomerOrders.GetInvoiceTotal: extended;
begin
  Result := DataSet['InvoiceTotal'];
end;

function TCustomerOrders.GetFinalCost: extended;
begin
  Result := DataSet['ClientTotalGrn'];
end;

function TCustomerOrders.FindByOrderNumber(_OrderNumber: integer): TIntArray;
begin
  //Result := GetIDsByFilter('ID_Number = ' + IntToStr(_OrderNumber));
end;

function TCustomerOrders.FindByInvoiceNumber(_InvoiceNumber: string): TIntArray;
begin
  //Result := GetIDsByFilter('InvoiceNum = ''' + _InvoiceNumber + '''');
end;

{function TCustomerOrders.GetIDsByFilter(_Filter: string): TIntArray;
var
  OldFiltered: boolean;
  OldFilter: string;
begin
  SetLength(Result, 0);
  DataSet.DisableControls;
  OldFiltered := DataSet.Filtered;
  OldFilter := DataSet.Filter;
  try
    DataSet.Filter := _Filter;
    DataSet.Filtered := true;
    while not DataSet.eof do
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := KeyValue;
      DataSet.Next;
    end;
  finally
    DataSet.EnableControls;
    DataSet.Filtered := OldFiltered;
    DataSet.Filter := OldFilter;
  end;
end;}

function TCustomerOrders.LocateInvoice(_InvoiceNum: string): boolean;
begin
  Result := DataSet.Locate('InvoiceNum', _InvoiceNum, [loCaseInsensitive, loPartialKey]);
end;

function TCustomerOrders.GetFieldCustomerID: integer;
begin
  Result := DataSet['CustomerID'];
end;

function TCustomerOrders.GetCustomerName: string;
begin
  Result := DataSet['CustomerName'];
end;

{$ENDREGION}

{$REGION 'TCustomerPayments' }

constructor TCustomerPayments.Create;
begin
  inherited Create;
  Init('CustomerPayments', 'PaymentID');
  DataSetProvider.UpdateMode := upWhereKeyOnly;
  DataSetProvider.OnGetTableName := GetTableName;
end;

procedure TCustomerPayments.GetTableName(Sender: TObject; DataSet: TDataSet;
  var TableName: WideString);
begin
  TableName := 'Payments';
end;

procedure TCustomerPayments.CreateDataSet;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_PaymentID;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInKey];

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'OrderID';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_OrderNumber;
  (f as TNumericField).DisplayFormat := CalcUtils.OrderNumDisplayFmt;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'CreationDate';
  f.DataSet := DataSet;
  (f as TDateTimeField).DisplayFormat := ShortDateFormat;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'Comment';
  f.Size := 128;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'PayCost';
  f.Size := 2;
  f.DataSet := DataSet;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'PayType';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'PayDate';
  f.DataSet := DataSet;
  (f as TDateTimeField).DisplayFormat := ShortDateFormat;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_Course;
  f.Size := 2;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'GetterName';
  f.Size := 40;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'IncomeID';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TInvoices.F_InvoiceNum;
  f.Size := TInvoices.InvoiceNumSize;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'ContragentName';
  f.Size := TContragents.CustNameSize;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];

  // Служебные поля

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := 'FullPayment';
  f.DataSet := DataSet;
  //f.FieldKind := fkInternalCalc;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceItemID';
  f.DataSet := DataSet;
  //f.FieldKind := fkInternalCalc;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  // Вычисляемые поля

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'PaidTotalGrn';
  f.Size := 2;
  f.DataSet := DataSet;
  f.FieldKind := fkCalculated;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'PayTypeName';
  f.DataSet := DataSet;
  f.FieldKind := fkLookup;
  f.KeyFields := 'PayType';
  f.LookupDataSet := TConfigManager.Instance.StandardDics.dePayKind.DicItems;
  f.LookupKeyFields := DicObj.F_DicItemCode;
  f.LookupResultField := DicObj.F_DicItemName;
  f.Name := DataSet.Name + f.FieldName;

  NewRecordProc := 'up_AddPayment';
end;

function TCustomerPayments.GetSQL: string;
var
  AddFilter: string;

  procedure AddF(s: string);
  begin
    if AddFilter <> '' then
      AddFilter := AddFilter + ' and ' + s
    else
      AddFilter := s;
  end;

begin
  Result := 'select PaymentID, ii.OrderID, wo.ID_Number, wo.CreationDate,'
    + ' wo.Comment, wo.Course, PayDate, PayCost, ci.GetterLogin, sp.IncomeID,'
//    + ' ISNULL(PaidGrn, 0) + ISNULL(PaidUSD, 0) * wo.Course as PaidTotalGrn,'
    // TODO: может не работать на SQL2005, но если InternalCalc, надо переделывать присваивание параметров хранимке
    + ' ci.PayType, au.Name as GetterName, cast(0 as bit) as FullPayment,' + #13#10
    + ' cast(0 as int) as InvoiceItemID,' + #13#10
    + ' i.InvoiceNum, c.Name as ContragentName' + #13#10
    + ' from Payments sp inner join InvoiceItems ii on ii.InvoiceItemID = sp.InvoiceItemID' + #13#10
    + ' inner join Invoices i on ii.InvoiceID = i.InvoiceID' + #13#10
    + ' inner join Customer c on i.ContragentID = c.N' + #13#10
    + ' inner join CustomerIncome ci on ci.IncomeID = sp.IncomeID' + #13#10
    + ' inner join AliveWorkOrders wo with (noexpand) on wo.N = ii.OrderID' + #13#10
    + ' left join AccessUser au on au.Login = ci.GetterLogin' + #13#10;
  AddFilter := '';
  if NvlInteger(FCustomerID) > 0 then
    AddF('Customer = ' + IntToStr(FCustomerID));
  if not VarIsNull(FCriteria.IncomeID) and not VarIsEmpty(FCriteria.IncomeID) then
    AddF('ci.IncomeID = ' + IntToStr(FCriteria.IncomeID));
  if NvlInteger(FCriteria.OrderID) > 0 then
    AddF('wo.N = ' + IntToStr(FCriteria.OrderID));
  if AddFilter <> '' then
    AddFilter := 'where ' + AddFilter;
  Result := Result + AddFilter + #13#10 {'wo.IsDraft = 0 and wo.IsDeleted = 0' +}
    + ' order by PayDate, wo.CreationDate';
end;

procedure TCustomerPayments.DoOnCalcFields;
begin
  DataSet['PaidTotalGrn'] := NvlFloat(DataSet['PayCost']);
end;

function TCustomerPayments.GetPaidGrn: extended;
begin
  Result := DataSet['PayCost'];
end;

procedure TCustomerPayments.SetPaidGrn(Value: extended);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['PayCost'] := Value;
end;

function TCustomerPayments.GetPayType: integer;
begin
  Result := DataSet['PayType'];
end;

procedure TCustomerPayments.SetPayType(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['PayType'] := Value;
end;

function TCustomerPayments.GetPayDate: TDateTime;
begin
  Result := DataSet['PayDate'];
end;

procedure TCustomerPayments.SetPayDate(Value: TDateTime);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['PayDate'] := Value;
end;

function TCustomerPayments.GetOrderID: integer;
begin
  Result := DataSet['OrderID'];
end;

procedure TCustomerPayments.SetOrderID(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['OrderID'] := Value;
end;

function TCustomerPayments.GetIncomeID: variant;
begin
  Result := DataSet['IncomeID'];
end;

procedure TCustomerPayments.SetIncomeID(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['IncomeID'] := Value;
end;

function TCustomerPayments.GetFullPayment: boolean;
begin
  Result := NvlBoolean(DataSet['FullPayment']);
end;

procedure TCustomerPayments.SetFullPayment(Value: boolean);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['FullPayment'] := Value;
end;

function TCustomerPayments.GetInvoiceItemID: integer;
begin
  Result := NvlInteger(DataSet['InvoiceItemID']);
end;

procedure TCustomerPayments.SetInvoiceItemID(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['InvoiceItemID'] := Value;
end;

{$ENDREGION}

{$REGION 'TCustomerIncomes' }

const
  F_IncomesKey = 'IncomeID';

constructor TCustomerIncomes.Create;
begin
  inherited Create;
  Init('CustomerIncomes', F_IncomesKey);
  DataSetProvider.UpdateMode := upWhereKeyOnly;
  DataSetProvider.OnGetTableName := GetTableName;
  (DataSet as TClientDataSet).AggregatesActive := true;
  FAssignKeyValue := true;
end;

procedure TCustomerIncomes.GetTableName(Sender: TObject; DataSet: TDataSet;
  var TableName: WideString);
begin
  TableName := 'CustomerIncome';
end;

procedure TCustomerIncomes.CreateDataSet;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_IncomesKey;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInKey];

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'PayType';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'CustomerID';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'IncomeDate';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  (f as TDateTimeField).DisplayFormat := 'dd.mm.yyyy hh:nn'; 
  f.ProviderFlags := [pfInUpdate];

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'IncomeGrn';
  f.Size := 2;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  (f as TNumericField).EditFormat := CalcUtils.NumEditFmt;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'ReturnCost';
  f.Size := 2;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  (f as TNumericField).EditFormat := CalcUtils.NumEditFmt;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'PaidGrn';
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.Size := 2;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'GetterLogin';
  f.Size := 50;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [{pfInUpdate}];

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'GetterName';
  f.Size := 40;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'GetterComment';
  f.Size := 150;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'CustomerName';
  f.Size := TContragents.CustNameSize;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'SyncState';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'IncomeInvoiceID';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'IncomeInvoiceNum';
  f.Size := TInvoices.InvoiceNumSize;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];

  // InternalCalc

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_OrderNumber;
  f.FieldKind := fkInternalCalc;
  (f as TNumericField).DisplayFormat := CalcUtils.OrderNumDisplayFmt;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceNum';
  f.Size := TInvoices.InvoiceNumSize;
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'IncomeInvoiceItemID';
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];

  // Lookup

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'PayTypeName';
  f.DataSet := DataSet;
  f.FieldKind := fkLookup;
  f.KeyFields := 'PayType';
  f.LookupDataSet := TConfigManager.Instance.StandardDics.dePayKind.DicItems;
  f.LookupKeyFields := DicObj.F_DicItemCode;
  f.LookupResultField := DicObj.F_DicItemName;
  f.Name := DataSet.Name + f.FieldName;

  // Calculated

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'RestIncome';
  f.FieldKind := fkInternalCalc;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  // Aggregate

  f := TAggregateField.Create(DataSet.Owner);
  f.FieldName := 'Sum_RestIncome';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  (f as TAggregateField).Expression := 'sum(RestIncome)';
  (f as TAggregateField).DisplayFormat := CalcUtils.NumDisplayFmt;
  (f as TAggregateField).Active := true;

  NewRecordProc := 'up_NewCustomerIncome';
  DeleteRecordProc := 'up_DeleteCustomerIncome';
end;

class function TCustomerIncomes.GetPrepareContragentTempTable(CustomerID: integer): string;
begin
  Result := 'create table #TempIds (ContrID int not null)' + #13#10
    + 'insert into #TempIds' + #13#10
    + 'select distinct inv1.ContragentID from AliveWorkOrders wo with (noexpand) inner join InvoiceItems ii on wo.N = ii.OrderID' + #13#10
    + 'inner join Invoices inv1 on inv1.InvoiceID = ii.InvoiceID' + #13#10
    + 'where /*wo.IsDraft = 0 and wo.IsDeleted = 0 and */wo.Customer = ' + IntToStr(CustomerID) + #13#10

    + 'if not exists(select * from #TempIDs where ContrID = ' + IntToStr(CustomerID) + ')' + #13#10
    + '  insert into #TempIds (ContrID) values (' + IntToStr(CustomerID) + ')' + #13#10;
end;

function TCustomerIncomes.GetSQL: string;
var
  expr, IncomeFilter, AddFilter: string;
  //UserCode: integer;
  I: Integer;
begin
  expr := FCriteria.GetFilterExpr(Self);
  if expr <> '' then expr := ' and (' + expr + ')';

  IncomeFilter := '';
  if not VarIsNull(FCriteria.InvoiceID) and not VarIsEmpty(FCriteria.InvoiceID) then  // поиск конкретного счета
    IncomeFilter := 'InvoiceID = ' + IntToStr(FCriteria.InvoiceID)
  //else if not VarIsNull(FCriteria.IncomeID) and not VarIsEmpty(FCriteria.IncomeID) then  // поиск конкретного поступления
  //  IncomeFilter := 'IncomeID = ' + IntToStr(FCriteria.IncomeID)
  else if Length(FCriteria.IncomeIDs) > 0 then  // выборка конкретных поступлений
  begin
    IncomeFilter := 'IncomeID in (';
    for I := 0 to Length(FCriteria.IncomeIDs) - 1 do
    begin
      if I > 0 then
        IncomeFilter := IncomeFilter + ', ';
      IncomeFilter := IncomeFilter + IntToStr(FCriteria.IncomeIDs[i]);
    end;
    IncomeFilter := IncomeFilter + ')';
  end else
    FCriteria.AppendDateFilterExpr(IncomeFilter, 'IncomeDate', false);

  if FCustomerID > 0 then
    Result := GetPrepareContragentTempTable(FCustomerID)
  else
    Result := '';

  Result := Result + 'select ci.IncomeID, ci.IncomeDate, ci.PayType, ci.IncomeGrn, GetterLogin, ci.SyncState, ci.IncomeInvoiceID,' + #13#10
    + ' inv.InvoiceNum as IncomeInvoiceNum, GetterComment, au.Name as GetterName, ci.CustomerID, ci.ReturnCost, c.Name as CustomerName,' + #13#10
    + ' CAST(ISNULL((select sum(sp.PayCost)' + #13#10
    + '            from Payments sp inner join InvoiceItems ii' + #13#10
    + ' on ii.InvoiceItemID = sp.InvoiceItemID inner join AliveWorkOrders wo with (noexpand) on wo.N = ii.OrderID' + #13#10
    + 'where /*wo.IsDraft = 0 and wo.IsDeleted = 0 and */IncomeID = ci.IncomeID' + {expr + }'), 0) as decimal(18,2)) as PaidGrn' + #13#10
    + 'from CustomerIncome ci' + #13#10
    + '  inner join Customer c on c.N = ci.CustomerID' + #13#10;
  if FCustomerID > 0 then
    Result := Result + '  inner join #TempIds on ContrID = ci.CustomerID' + #13#10;
  Result := Result
    + '  left join AccessUser au on au.Login = ci.GetterLogin' + #13#10
    + '  left join Invoices inv on inv.InvoiceID = IncomeInvoiceID' + #13#10;
  {if FCustomerID > 0 then
  begin
    AddFilter := '(exists(select * from WorkOrder wo inner join InvoiceItems ii on wo.N = ii.OrderID'
      + ' inner join Invoices inv on inv.InvoiceID = ii.InvoiceID where inv.ContragentID = CustomerID'
      + ' and wo.IsDraft = 0 and wo.IsDeleted = 0 and wo.Customer = ' + IntToStr(FCustomerID) + ')' + #13#10
      + ' or ci.CustomerID = ' + IntToStr(FCustomerID) + ')';
  end
  else}
    AddFilter := '';
  if FCriteria.cbCreatorChecked and (FCriteria.CreatorName <> '') then
  begin
    if AddFilter <> '' then
      AddFilter := AddFilter + ' and ';
    {UserCode := AccessManager.UserInfo(FCriteria.CreatorName).ID;
    AddFilter := AddFilter + 'c.UserCode = ' + IntToStr(UserCode) + #13#10;}
    // Выбираем оплаты, разнесенные на заказы, принадлежащие пользователю
    AddFilter := AddFilter + ' exists(select * from WorkOrder wo inner join InvoiceItems ii on ii.OrderID = wo.N'
      + '   inner join Payments p on ii.InvoiceItemID = p.InvoiceItemID'
      + '   where p.IncomeID = ci.IncomeID and wo.CreatorName = ''' + FCriteria.CreatorName + ''')';
  end;
  // по виду оплаты
  if FCriteria.PayTypeChecked and (FCriteria.PayTypeCode > 0) then
  begin
    if AddFilter <> '' then
      AddFilter := AddFilter + ' and ';
    AddFilter := 'ci.PayType = ' + IntToStr(FCriteria.PayTypeCode);
  end;

  if (IncomeFilter <> '') and (AddFilter <> '') then
    IncomeFilter := AddFilter + ' and (' + IncomeFilter + ')'
  else if AddFilter <> '' then
    IncomeFilter := AddFilter;
  if IncomeFilter <> '' then
    Result := Result + 'where ';

  Result := Result + IncomeFilter + #13#10
    + 'order by IncomeDate';

  if FCustomerID > 0 then
    Result := Result + #13#10 + 'drop table #TempIds';
end;

procedure TCustomerIncomes.DoOnNewRecord;
begin
  inherited;
  DataSet['CustomerID'] := FCustomerID;
  DataSet['GetterLogin'] := AccessManager.CurUser.Login;
  DataSet['IncomeDate'] := CutTime(Now);
end;

function TCustomerIncomes.GetIncomeGrn: extended;
begin
  Result := NvlFloat(DataSet['IncomeGrn']);
end;

procedure TCustomerIncomes.SetIncomeGrn(Value: extended);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['IncomeGrn'] := Value;
end;

function TCustomerIncomes.GetReturnCost: extended;
begin
  Result := NvlFloat(DataSet['ReturnCost']);
end;

procedure TCustomerIncomes.SetReturnCost(Value: extended);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['ReturnCost'] := Value;
end;

function TCustomerIncomes.GetPayType: integer;
begin
  Result := NvlInteger(DataSet['PayType']);
end;

procedure TCustomerIncomes.SetPayType(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['PayType'] := Value;
end;

function TCustomerIncomes.GetPayTypeName: string;
begin
  Result := DataSet['PayTypeName'];
end;

function TCustomerIncomes.GetIncomeDate: TDateTime;
begin
  Result := NvlFloat(DataSet['IncomeDate']);
end;

procedure TCustomerIncomes.SetIncomeDate(Value: TDateTime);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['IncomeDate'] := Value;
end;

procedure TCustomerIncomes.DoOnCalcFields;
begin
  DataSet['RestIncome'] := NvlFloat(DataSet['IncomeGrn'])
    - NvlFloat(DataSet['PaidGrn']) - NvlFloat(DataSet['ReturnCost']);
end;

function TCustomerIncomes.GetRestIncome: extended;
begin
  Result := NvlFloat(DataSet['RestIncome']);
end;

function TCustomerIncomes.GetGetterComment: string;
begin
  Result := NvlString(DataSet['GetterComment']);
end;

procedure TCustomerIncomes.SetGetterComment(Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['GetterComment'] := Value;
end;

function TCustomerIncomes.GetOrderNumber: variant;
begin
  Result := DataSet[TOrder.F_OrderNumber];
end;

procedure TCustomerIncomes.SetOrderNumber(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet[TOrder.F_OrderNumber] := Value;
end;

function TCustomerIncomes.GetInvoiceNum: variant;
begin
  Result := DataSet['InvoiceNum'];
end;

procedure TCustomerIncomes.SetInvoiceNumber(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['InvoiceNum'] := Value;
end;

function TCustomerIncomes.GetIncomeInvoiceNum: variant;
begin
  Result := DataSet['IncomeInvoiceNum'];
end;

procedure TCustomerIncomes.SetFieldCustomerID(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['CustomerID'] := Value;
end;

function TCustomerIncomes.GetFieldCustomerID: integer;
begin
  Result := DataSet['CustomerID'];
end;

function TCustomerIncomes.GetCustomerName: string;
begin
  Result := DataSet['CustomerName'];
end;

function TCustomerIncomes.GetInvoiceID: variant;
begin
  Result := DataSet['IncomeInvoiceID'];
end;

procedure TCustomerIncomes.SetInvoiceID(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['IncomeInvoiceID'] := Value;
end;

function TCustomerIncomes.GetInvoiceItemID: variant;
begin
  Result := DataSet['IncomeInvoiceItemID'];
end;

procedure TCustomerIncomes.SetInvoiceItemID(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['IncomeInvoiceItemID'] := Value;
end;

procedure TCustomerIncomes.DoBeforeApplyUpdates;
var
  i: integer;
begin
  // Сохраняем значение поля ID_Number, т.к. оно InternalCalc,
  // и пропадет после обновления.
  // TODO: можно реализовать этот механизм для всех InternalCalc полей
  SetLength(FOrderNumbers, 0);
  SetLength(FOrderNumberTmpKeys, 0);
  DataSet.DisableControls;
  i := 0;
  try
    DataSet.First;
    while not DataSet.eof do
    begin
      if NvlInteger(OrderNumber) > 0 then
      begin
        SetLength(FOrderNumbers, i + 1);
        SetLength(FOrderNumberTmpKeys, i + 1);
        FOrderNumbers[i] := OrderNumber;
        FOrderNumberTmpKeys[i] := KeyValue;
        Inc(i);
      end;
      DataSet.Next;
    end;
  finally
    DataSet.EnableControls;
  end;

  SetLength(FInvoiceNumbers, 0);
  SetLength(FInvoiceNumberTmpKeys, 0);
  DataSet.DisableControls;
  i := 0;
  try
    DataSet.First;
    while not DataSet.eof do
    begin
      if Trim(NvlString(InvoiceNumber)) <> '' then
      begin
        SetLength(FInvoiceNumbers, i + 1);
        SetLength(FInvoiceNumberTmpKeys, i + 1);
        FInvoiceNumbers[i] := InvoiceNumber;
        FInvoiceNumberTmpKeys[i] := KeyValue;
        Inc(i);
      end;
      DataSet.Next;
    end;
  finally
    DataSet.EnableControls;
  end;

  SetLength(FInvItemIDs, 0);
  SetLength(FInvItemTmpKeys, 0);
  DataSet.DisableControls;
  i := 0;
  try
    DataSet.First;
    while not DataSet.eof do
    begin
      if not VarIsNull(InvoiceItemID) then
      begin
        SetLength(FInvItemIDs, i + 1);
        SetLength(FInvItemTmpKeys, i + 1);
        FInvItemIDs[i] := InvoiceItemID;
        FInvItemTmpKeys[i] := KeyValue;
        Inc(i);
      end;
      DataSet.Next;
    end;
  finally
    DataSet.EnableControls;
  end;

  inherited;
end;

procedure TCustomerIncomes.DoAfterOpen;
var
  I, NewID: Integer;
begin
  inherited;

  // Восстанавливаем значение поля ID_Number, т.к. оно InternalCalc,
  // и пропало после обновления.
  if Length(FOrderNumbers) > 0 then
  begin
    DataSet.DisableControls;
    try
      for I := Low(FOrderNumbers) to High(FOrderNumbers) do
      begin
        NewID := FItemIds.GetRealItemID(FOrderNumberTmpKeys[i], false);
        if (NewID > 0) and Locate(NewID) then
        begin
          OrderNumber := FOrderNumbers[i];
        end;
      end;
    finally
      DataSet.EnableControls;
    end;
    SetLength(FOrderNumbers, 0);
    SetLength(FOrderNumberTmpKeys, 0);
  end;

  // Восстанавливаем значение поля ID_Number, т.к. оно InternalCalc,
  // и пропало после обновления.
  if Length(FInvoiceNumbers) > 0 then
  begin
    DataSet.DisableControls;
    try
      for I := Low(FInvoiceNumbers) to High(FInvoiceNumbers) do
      begin
        NewID := FItemIds.GetRealItemID(FInvoiceNumberTmpKeys[i], false);
        if (NewID > 0) and Locate(NewID) then
        begin
          InvoiceNumber := FInvoiceNumbers[i];
        end;
      end;
    finally
      DataSet.EnableControls;
    end;
    SetLength(FInvoiceNumbers, 0);
    SetLength(FInvoiceNumberTmpKeys, 0);
  end;

  // Восстанавливаем значение поля InvoiceItemID, т.к. оно InternalCalc,
  // и пропало после обновления.
  if Length(FInvItemIDs) > 0 then
  begin
    DataSet.DisableControls;
    try
      for I := Low(FInvItemIDs) to High(FInvItemIDs) do
      begin
        NewID := FItemIds.GetRealItemID(FInvItemTmpKeys[i], false);
        if (NewID > 0) and Locate(NewID) then
        begin
          InvoiceItemID := FInvItemIDs[i];
        end;
      end;
    finally
      DataSet.EnableControls;
    end;
    SetLength(FInvItemIDs, 0);
    SetLength(FInvItemTmpKeys, 0);
  end;
end;

{$ENDREGION}

end.
