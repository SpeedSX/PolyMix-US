unit PmCustomerShipmentOrders;

interface

uses DB, SysUtils,

  CalcUtils, PmEntity;

type
  TCustomerShipmentOrdersCriteria = record
    CustomerID: integer;
    NotShippedOnly: boolean;
  end;

  TCustomerShipmentOrders = class(TEntity)
  private
    function GetQuantity: integer;
    function GetOrderNumber: integer;
    function GetCost: extended;
    function GetComment: string;
  protected
    FDataSource: TDataSource;
    FCriteria: TCustomerShipmentOrdersCriteria;
    procedure CreateFields;
    procedure DoBeforeOpen; override;
    function GetSQL: string;
    procedure DoOnCalcFields; override;
    function GetOrderPayCostExpr: string;
  public
    constructor Create;
    property DataSource: TDataSource read FDataSource;
    property Criteria: TCustomerShipmentOrdersCriteria read FCriteria write FCriteria;
    property OrderNumber: integer read GetOrderNumber;
    property Quantity: integer read GetQuantity;
    property Cost: extended read GetCost;
    property Comment: string read GetComment;
  end;

implementation

uses Forms,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmOrder;

constructor TCustomerShipmentOrders.Create;
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

  inherited Create(TOrder.F_OrderKey);

  FInternalName := ClassName;

  SetDataSet(_DataSet);

  //FDataSource.Free;  // мен€ем на свой
  FDataSource := _DataSource;

  CreateFields;

  {SetLength(FDateFields, 5);
  FDateFields[0] := 'wo.CreationDate';
  FDateFields[1] := 'wo.ModifyDate';
  FDateFields[2] := 'wo.FinishDate';
  FDateFields[3] := 'wo.FactFinishDate';
  FDateFields[4] := 'wo.CloseDate';}
end;

procedure TCustomerShipmentOrders.CreateFields;
var
  f: TField;
begin
  f := TIntegerField.Create(nil);
  f.FieldName := TOrder.F_OrderKey;
  f.ProviderFlags := [pfInKey, pfInWhere];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(nil);
  f.FieldName := 'CreationDate';
  (f as TDateTimeField).DisplayFormat := ShortDateFormat2;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(nil);
  f.FieldName := TOrder.F_OrderNumber;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(nil);
  f.FieldName := 'Tirazz';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(nil);
  f.FieldName := 'CreatorName';
  f.ReadOnly := true;
  f.Size := 50;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(nil);
  f.FieldName := 'Comment';
  f.ReadOnly := true;
  f.Size := 128;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  // ¬ычисл€емые пол€

  f := TStringField.Create(nil);
  f.FieldName := 'Description';
  f.FieldKind := fkCalculated;
  f.Size := 500;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(nil);
  f.Size := 10;
  f.FieldKind := fkCalculated;
  f.FieldName := 'OrderNumber';
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
end;

function TCustomerInvoiceOrders.GetOrderPayCostExpr: string;
begin
  Result := 'ISNULL((select sum(PayCost) from Payments p inner join InvoiceItems ii on p.InvoiceItemID = ii.InvoiceItemID where ii.OrderID = wo.N), 0)';
end;

function TCustomerInvoiceOrders.GetSQL: string;
begin
  Result := 'select wo.N, wo.ID_Number, wo.CreationDate, wo.Comment, wo.CreatorName, wo.Tirazz,'#13#10
    + ' cast((case when sp.FinalCostGrn is null then wo.ClientTotal * wo.Course else sp.FinalCostGrn end) as decimal(18, 2)) as FinalCostGrn'#13#10
    + 'from WorkOrder wo left join OrderProcessItem opi '
    + ' inner join Service_ClientPrice sp on sp.ItemID = opi.ItemID'#13#10
    + ' on opi.OrderID = wo.N'#13#10
    + 'where wo.IsDeleted = 0 and wo.IsDraft = 0';
  if FCriteria.NotPaidOnly then
    // выбираем все неоплаченные заказы
    Result := Result + #13#10' and ' + GetOrderPayCostExpr + ' < (case when sp.FinalCostGrn is null then wo.ClientTotal * wo.Course else sp.FinalCostGrn end)' + #13#10;
  if FCriteria.CustomerID >= 0 then
    // выбираем заказы текущего плательщика и всех заказчиков, за кого он хоть раз платил
    Result := Result + #13#10' and (exists(select * from WorkOrder wo1 inner join InvoiceItems ii on wo1.N = ii.OrderID'
      + ' inner join Invoices inv on inv.InvoiceID = ii.InvoiceID where inv.ContragentID = ' + IntToStr(FCriteria.CustomerID) + #13#10
      + ' and wo1.IsDraft = 0 and wo1.IsDeleted = 0 and wo1.Customer = wo.Customer)'
      + ' or wo.Customer = ' + IntToStr(FCriteria.CustomerID) + ')'#13#10;

  Result := Result + 'order by wo.CreationDate';
end;

procedure TCustomerInvoiceOrders.DoBeforeOpen;
begin
  inherited DoBeforeOpen;
  SetQuerySQL(DataSource, GetSQL);
end;

procedure TCustomerInvoiceOrders.DoOnCalcFields;
begin
  DataSet['Description'] := Format('%5.5d', [NvlInteger(DataSet[TOrder.F_OrderNumber])]) + ' ' + NvlString(DataSet['Comment']);
  DataSet['OrderNumber'] := Format('%5.5d', [NvlInteger(DataSet[TOrder.F_OrderNumber])]);
end;

function TCustomerInvoiceOrders.GetQuantity: integer;
begin
  Result := NvlInteger(DataSet['Tirazz']);
end;

function TCustomerInvoiceOrders.GetOrderNumber: integer;
begin
  Result := NvlInteger(DataSet[TOrder.F_OrderNumber]);
end;

function TCustomerInvoiceOrders.GetCost: extended;
begin
  Result := NvlFloat(DataSet['FinalCostGrn']);
end;

function TCustomerInvoiceOrders.GetComment: string;
begin
  Result := NvlString(DataSet['Comment']);
end;

end.
