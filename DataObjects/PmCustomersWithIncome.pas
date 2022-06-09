unit PmCustomersWithIncome;

interface

uses DB, SysUtils,

  MainFilter, CalcUtils, PmEntity, PmContragent;

type
  TCustomersWithIncome = class(TEntity)
  private
    //function GetRestIncome: extended;
    function GetToPayGrn: extended;
    function GetInvoiceTotal: extended;
  protected
    FDataSource: TDataSource;
    FNumberField: string;
    FCriteria: TPaymentsFilterObj;
    procedure CreateSpecificFields;
    procedure DoBeforeOpen; override;
    procedure DoOnCalcFields; override;
    function GetSQL: string;
  public
    constructor Create; override;
    function GetOrderPrefix: string;

    property DataSource: TDataSource read FDataSource;

    property NumberField: string read FNumberField;
    //property RestIncome: extended read GetRestIncome;
    property ToPayGrn: extended read GetToPayGrn;
    property InvoiceTotal: extended read GetInvoiceTotal;

    property Criteria: TPaymentsFilterObj read FCriteria write FCriteria;
  end;

implementation

uses Forms,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmAccessManager;

constructor TCustomersWithIncome.Create;
var
  _DataSource: TDataSource;
  _DataSet: TDataSet;
begin
  if PlanDM = nil then
    Application.CreateForm(TPlanDM, PlanDM);

  _DataSource := CreateQueryExDM(PlanDM, PlanDM, ClassName,
    [{poAllowMultiRecordUpdates, poDisableInserts, poDisableDeletes, poDisableEdits}],
    upWhereKeyOnly, true {ResolveToDataSet}, Database.Connection);
  _DataSet := _DataSource.DataSet;

  inherited Create;
  FKeyField := Customers.KeyField;

  FInternalName := ClassName;

  SetDataSet(_DataSet);

  //FDataSource.Free;  // меняем на свой
  FDataSource := _DataSource;

  TContragents.CreateContragentFields(DataSet);
  CreateSpecificFields;

  FNumberField := 'wo.ID_Number';
  SetLength(FDateFields, 5);
  FDateFields[0] := 'wo.CreationDate';
  FDateFields[1] := 'wo.ModifyDate';
  FDateFields[2] := 'wo.FinishDate';
  FDateFields[3] := 'wo.FactFinishDate';
  FDateFields[4] := 'wo.CloseDate';
end;

procedure TCustomersWithIncome.CreateSpecificFields;
var
  f: TField;
begin
  {f := TBCDField.Create(nil);
  f.FieldName := 'IncomeGrn';
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;}

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'PaidGrn';
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'TotalGrn';
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceTotal';
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  //Calculated fields

  {f := TBCDField.Create(nil);
  f.FieldName := 'RestIncome';
  f.FieldKind := fkCalculated;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;}

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'ToPayGrn';
  f.FieldKind := fkCalculated;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
end;

function TCustomersWithIncome.GetSQL: string;
var
  expr{, IncomeFilter}: string;
begin
  expr := FCriteria.GetFilterExpr(Self);
  if expr <> '' then expr := ' and (' + expr + ')';

  {IncomeFilter := '';
  FCriteria.AppendDateFilterExpr(IncomeFilter, 'IncomeDate', false);
  if IncomeFilter <> '' then IncomeFilter := ' and (' + IncomeFilter + ')';}

  {if FCustomerID > 0 then
    Result := GetPrepareContragentTempTable(FCustomerID)
  else
    Result := '';}

  Result := 'select [N], c.[Name], [Fax], [Phone], [Address], [Email], [Bank], [IndCode],' + #13#10
     + '[NDSCode], OKPOCode, IsWork, SourceCode, UserCode, SourceOther, ParentID, FullName,'#13#10
     + 'FirmBirthday, PersonType, FirmType, ContragentGroup, ContragentType, CreationDate, SyncState,'#13#10
     + 'Phone2, LegalAddress, Notes, ExternalName, PrePayPercent, PreShipPercent, PayDelay, IsPayDelayInBankDays, StatusCode,'#13#10
     // Здесь FirstPersonName не нужно, поэтому просто пустая строка
     + 'CheckPayConditions, ActivityCode, CAST('''' as varchar(' + IntToStr(TPersons.NameFieldSize) + ')) as FirstPersonName,'#13#10
     + 'BriefNote, SyncWeb,'#13#10
     // сумма остатков с учетом коррекции
     {+ 'ISNULL((select ISNULL(sum(IncomeGrn - ISNULL(ReturnCost, 0)), 0) from CustomerIncome ci'#13#10
             + 'where CustomerID = c.N' + IncomeFilter
             + #13#10'), 0) as IncomeGrn,'#13#10}
     + 'CAST(ISNULL((select sum(PayCost)'#13#10
             + 'from Payments sp inner join InvoiceItems ii on ii.InvoiceItemID = sp.InvoiceItemID'#13#10
             + ' inner join AliveWorkOrders wo with (noexpand) on wo.N = ii.OrderID'#13#10
             + ' inner join CustomerIncome ci1 on ci1.IncomeID = sp.IncomeID'#13#10
             + 'where /*wo.IsDraft = 0 and wo.IsDeleted = 0 and */wo.Customer = c.N'
             + expr
             //+ IncomeFilter
             + '), 0) as decimal(18,2)) as PaidGrn,'#13#10
     + 'CAST(ISNULL((select sum(COALESCE(FinalCostGrn, wo.ClientTotal * wo.Course, 0))'#13#10
             + 'from AliveWorkOrders wo with (noexpand) left join OrderProcessItem opi inner join Service_ClientPrice sp on opi.ItemID = sp.ItemID on wo.N = opi.OrderID'#13#10
             + 'where /*wo.IsDraft = 0 and wo.IsDeleted = 0 and */wo.Customer = c.N' + expr + '), 0) as decimal(18,2)) as TotalGrn,'#13#10
     + 'CAST(ISNULL((select sum(ii.ItemCost) from AliveWorkOrders wo with (noexpand) left join InvoiceItems ii on ii.OrderID = wo.N'#13#10
             + 'where /*wo.IsDraft = 0 and wo.IsDeleted = 0 and */wo.Customer = c.N' + expr + '), 0) as decimal(18, 2)) as InvoiceTotal'#13#10

     + 'from Customer c'#13#10
     + 'where c.[Name] <> '#39'NONAME'#39' and ContragentType = ' + IntToStr(Customers.ContragentType) + #13#10
     + ' and IsDeleted = 0 and (exists(select * from AliveWorkOrders wo with (noexpand) where Customer = c.N/* and IsDraft = 0 and IsDeleted = 0*/)'#13#10
     + '  or exists(select * from Invoices where ContragentID = c.N))'#13#10
     + ' order by c.[Name]';
end;

function TCustomersWithIncome.GetOrderPrefix: string;
begin
  Result := 'wo.';
end;

procedure TCustomersWithIncome.DoBeforeOpen;
begin
  inherited DoBeforeOpen;
  SetQuerySQL(DataSource, GetSQL);
end;

{function TCustomersWithIncome.GetRestIncome: extended;
begin
  Result := DataSet['RestIncome'];
end;}

function TCustomersWithIncome.GetToPayGrn: extended;
begin
  Result := DataSet['ToPayGrn'];
end;

function TCustomersWithIncome.GetInvoiceTotal: extended;
begin
  Result := DataSet['InvoiceTotal'];
end;

procedure TCustomersWithIncome.DoOnCalcFields;
begin
  inherited;

  //DataSet['RestIncome'] := DataSet['IncomeGrn'] - DataSet['PaidGrn'];
  DataSet['ToPayGrn'] := DataSet['TotalGrn'] - DataSet['PaidGrn'];

  DataSet['CreatorName'] := AccessManager.FormatUserName(NvlInteger(DataSet['UserCode']));
end;

end.
