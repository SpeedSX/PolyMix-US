unit PmOrderPayments;

interface

uses DB, Forms, Classes, Variants, SysUtils, Provider,

  CalcUtils, JvInterpreter_CustomQuery, PlanData, RDBUtils,
  PmDatabase, CalcSettings, PmEntity, PmCustomerPayments;

type
  TOrderPaymentsCriteria = record
    const
      Mode_Normal = 0;
      Mode_Empty = 1;
      Mode_TempTable = 2;
    var
      OrderID: variant;
      Mode: integer;
  end;

  TOrderPayments = class(TEntity)
  private
    FDataSource: TDataSource;
    FCriteria: TOrderPaymentsCriteria;
    function GetPaidGrn: extended;
   // procedure SetPaidGrn(Value: extended);
    function GetPayType: integer;
   // procedure SetPayType(Value: integer);
    function GetPayDate: TDateTime;
    //procedure SetPayDate(Value: TDateTime);
    {function GetOrderID: integer;
    procedure SetOrderID(Value: integer);
    function GetIncomeID: variant;
    procedure SetIncomeID(Value: variant);
    function GetInvoiceItemID: integer;
    procedure SetInvoiceItemID(Value: integer);}
  protected
    procedure DoBeforeOpen; override;
    procedure CreateDataSet;
    function GetSQL: string;
    procedure DoOnCalcFields; override;
  public
    const
      F_PaymentID = 'PaymentID';
      F_PayCost = 'PayCost';
      F_PayType = 'PayType';
      F_PayDate = 'PayDate';
      F_GetterName = 'GetterName';
      F_PayTypeName = 'PayTypeName';
      F_InvoiceNum = 'InvoiceNum';
      F_ContragentName = 'ContragentName';

    constructor Create; override;
    property Criteria: TOrderPaymentsCriteria read FCriteria write FCriteria;
    property DataSource: TDataSource read FDataSource;
    property PaidGrn: extended read GetPaidGrn;// write SetPaidGrn;
    property PayType: integer read GetPayType;// write SetPayType;
    property PayDate: TDateTime read GetPayDate;// write SetPayDate;
    {property OrderID: integer read GetOrderID write SetOrderID;
    property IncomeID: variant read GetIncomeID write SetIncomeID;}
  end;

implementation

uses StdDic, DicObj, PmContragent, PmConfigManager;

constructor TOrderPayments.Create;
var
  _Provider: TDataSetProvider;
  //_DataSource: TDataSource;
  //_DataSet: TDataSet;
begin
  inherited Create;
  FKeyField := F_PaymentID;

  FInternalName := 'OrderPayments';
  UseWaitCursor := false;

  if PlanDM = nil then
    Application.CreateForm(TPlanDM, PlanDM);

  FDataSource := CreateQueryExDM(PlanDM, PlanDM, FInternalName,
    [{poAllowMultiRecordUpdates, poDisableInserts, poDisableDeletes, poDisableEdits}],
    upWhereKeyOnly, false {ResolveToDataSet}, Database.Connection, _Provider);
  SetDataSet(FDataSource.DataSet);
  DataSetProvider := _Provider;

  CreateDataSet;
end;

procedure TOrderPayments.DoBeforeOpen;
begin
  SetQuerySQL(FDataSource, GetSQL);
end;

procedure TOrderPayments.CreateDataSet;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_PaymentID;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInKey];

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_PayCost;
  f.Size := 2;
  f.DataSet := DataSet;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_PayType;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := F_PayDate;
  f.DataSet := DataSet;
  (f as TDateTimeField).DisplayFormat := ShortDateFormat;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_GetterName;
  f.Size := 40;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'IncomeID';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceItemID';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_InvoiceNum;
  f.Size := 40;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'ContragentID';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'OrderID';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_ContragentName;
  f.ReadOnly := true;
  f.Size := TContragents.CustNameSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'ItemText';
  f.Size := 300;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  // Вычисляемые поля
  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_PayTypeName;
  f.DataSet := DataSet;
  f.FieldKind := fkCalculated;
  f.Name := DataSet.Name + f.FieldName;

end;

function TOrderPayments.GetSQL: string;
begin
  Result := 'select PaymentID, PayDate, PayCost, sp.IncomeID, ii.OrderID,'
    + ' ci.PayType, au.Name as GetterName, inv.InvoiceNum, ci.CustomerID as ContragentID,' + #13#10
    + ' cust.Name as ContragentName, ii.InvoiceItemID, ii.ItemText' + #13#10
    + ' from Payments sp inner join InvoiceItems ii on ii.InvoiceItemID = sp.InvoiceItemID' + #13#10
    + ' inner join Invoices inv on inv.InvoiceID = ii.InvoiceID' + #13#10
    + ' inner join CustomerIncome ci on ci.IncomeID = sp.IncomeID' + #13#10
    + ' left join Customer cust on cust.N = ci.CustomerID' + #13#10
//    + ' inner join WorkOrder wo on wo.N = ii.OrderID' + #13#10
    + ' left join AccessUser au on au.Login = ci.GetterLogin' + #13#10;
  if FCriteria.Mode = TOrderPaymentsCriteria.Mode_Normal then
  begin
    if not VarIsNull(FCriteria.OrderID) then
      Result := Result + 'where ii.OrderID = ' + VarToStr(FCriteria.OrderID) + #13#10;
  end
  else if FCriteria.Mode = TOrderPaymentsCriteria.Mode_Empty then
    Result := Result + 'where 1 = 0' + #13#10
  else if FCriteria.Mode = TOrderPaymentsCriteria.Mode_TempTable then
    Result := Result + 'inner join #OrderIDs ids on ii.OrderID = ids.OrderID' + #13#10;

  Result := Result + 'order by ci.PayType, InvoiceNum, PayDate';
end;

procedure TOrderPayments.DoOnCalcFields;
begin
  if VarIsNull(DataSet[F_PayType]) then
    DataSet[F_PayTypeName] := '?'
  else
    DataSet[F_PayTypeName] := TConfigManager.Instance.StandardDics.dePayKind.ItemName[DataSet[F_PayType]];
end;

function TOrderPayments.GetPaidGrn: extended;
begin
  Result := NvlFloat(DataSet[F_PayCost]);
end;

function TOrderPayments.GetPayType: integer;
begin
  Result := NvlInteger(DataSet[F_PayType]);
end;

function TOrderPayments.GetPayDate: TDateTime;
begin
  Result := NvlDateTime(DataSet[F_PayDate]);
end;

end.
