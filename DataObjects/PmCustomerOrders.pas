unit PmCustomerOrders;

interface

uses DB, SysUtils, Variants,

  CalcUtils, PmEntity;

type
  TCustomerInvoiceOrdersCriteria = record
    OrderID: integer;
    SingleOrder: boolean;
    CustomerID: integer;
    NotPaidOnly: boolean;
    NotInvoicedOnly: boolean;
    NotShippedOnly: boolean;
    ForShipment: boolean;
    StartDate: TDateTime;
    EndDate: TDateTime;
  end;

  TCustomerInvoiceOrders = class(TEntity)
  private
    function GetQuantity: integer;
    function GetOrderNumber: integer;
    function GetCost: extended;
    function GetComment: string;
  protected
    FDataSource: TDataSource;
    FCriteria: TCustomerInvoiceOrdersCriteria;
    procedure CreateFields;
    procedure DoBeforeOpen; override;
    function GetSQL: string;
    procedure DoOnCalcFields; override;
    function GetOrderPayCostExpr: string;
  public
    constructor Create; override;
    property DataSource: TDataSource read FDataSource;
    property Criteria: TCustomerInvoiceOrdersCriteria read FCriteria write FCriteria;
    property OrderNumber: integer read GetOrderNumber;
    property Quantity: integer read GetQuantity;
    property Cost: extended read GetCost;
    property Comment: string read GetComment;
  end;

implementation

uses Forms,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmOrder;

constructor TCustomerInvoiceOrders.Create;
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
  FKeyField := TOrder.F_OrderKey;

  FInternalName := ClassName;

  SetDataSet(_DataSet);

  //FDataSource.Free;  // меняем на свой
  FDataSource := _DataSource;

  CreateFields;

  {SetLength(FDateFields, 5);
  FDateFields[0] := 'wo.CreationDate';
  FDateFields[1] := 'wo.ModifyDate';
  FDateFields[2] := 'wo.FinishDate';
  FDateFields[3] := 'wo.FactFinishDate';
  FDateFields[4] := 'wo.CloseDate';}
end;

procedure TCustomerInvoiceOrders.CreateFields;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_OrderKey;
  f.ProviderFlags := [pfInKey, pfInWhere];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'CreationDate';
  (f as TDateTimeField).DisplayFormat := ShortDateFormat2;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'FinalCostGrn';
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.Size := 2;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_OrderNumber;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'Tirazz';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'CreatorName';
  f.ReadOnly := true;
  f.Size := 50;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'Comment';
  f.ReadOnly := true;
  f.Size := 128;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  // Вычисляемые поля

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'Description';
  f.FieldKind := fkInternalCalc;
  f.Size := 500;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.Size := 10;
  f.FieldKind := fkInternalCalc;
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
var SelectStmt: string;
begin
  SelectStmt := 'select wo.N, wo.ID_Number, wo.CreationDate, wo.Comment, wo.CreatorName, wo.Tirazz,'#13#10
    + ' cast((case when sp.FinalCostGrn is null then wo.ClientTotal * wo.Course else sp.FinalCostGrn end) as decimal(18, 2)) as FinalCostGrn'#13#10
    + 'from WorkOrder wo left join OrderProcessItem opi '
    + ' inner join Service_ClientPrice sp on sp.ItemID = opi.ItemID'#13#10
    + ' on opi.OrderID = wo.N'#13#10;
    
  Result := SelectStmt
    + 'where wo.IsDeleted = 0 and wo.IsDraft = 0';

  if (FCriteria.OrderID > 0) and FCriteria.SingleOrder then
    Result := Result + #13#10' and wo.N = ' + IntToStr(FCriteria.OrderID)
  else
  begin
    if FCriteria.NotShippedOnly and FCriteria.ForShipment then
      // выбираем все неотгруженные заказы
      Result := Result + #13#10' and wo.Tirazz > ISNULL((select ISNULL(sum(Quantity), 0) from Shipment sh'
        + ' where sh.OrderID = wo.N), 0)'#13#10;

    if FCriteria.NotPaidOnly and not FCriteria.ForShipment and not FCriteria.NotInvoicedOnly then
      // выбираем все неоплаченные заказы
      Result := Result + #13#10' and ' + GetOrderPayCostExpr + ' < (case when sp.FinalCostGrn is null then wo.ClientTotal * wo.Course else sp.FinalCostGrn end)'#13#10;

    if FCriteria.NotInvoicedOnly and not FCriteria.ForShipment then
      // выбираем заказы, на которые не выставлен счет
      Result := Result + #13#10' and not exists(select * from InvoiceItems ii where ii.OrderID = wo.N)';

    // Заказы за определенный диапазон дат
    if FCriteria.StartDate <> 0 then
      Result := Result + #13#10' and wo.CreationDate >= ' + FormatSQLDateTime(FCriteria.StartDate);
    if FCriteria.EndDate <> 0 then
      Result := Result + #13#10' and wo.CreationDate <= ' + FormatSQLDateTime(FCriteria.EndDate);

    if (FCriteria.CustomerID > 0) then
    begin
      if FCriteria.ForShipment then
        Result := Result + #13#10' and wo.Customer = ' + IntToStr(FCriteria.CustomerID) + #13#10
      else
        // Выбираем заказы текущего плательщика и всех заказчиков, за кого он хоть раз платил.
        // Разбиваем на 2 запроса и объединяем.
        Result := Result + #13#10' and (exists(select * from AliveWorkOrders wo1 with (noexpand) inner join InvoiceItems ii on wo1.N = ii.OrderID'
          + ' inner join Invoices inv on inv.InvoiceID = ii.InvoiceID where inv.ContragentID = ' + IntToStr(FCriteria.CustomerID) + #13#10
          + ' and /*wo1.IsDraft = 0 and wo1.IsDeleted = 0 and */wo1.Customer = wo.Customer))'#13#10
          + 'union'#13#10
          + Result + #13#10' and wo.Customer = ' + IntToStr(FCriteria.CustomerID) + #13#10;
    end;

    if FCriteria.OrderID > 0 then
      Result := Result + #13#10'union'#13#10 + SelectStmt 
        + #13#10'where wo.N = ' + IntToStr(FCriteria.OrderID);
  end;

  Result := Result + 'order by wo.CreationDate';
end;

procedure TCustomerInvoiceOrders.DoBeforeOpen;
begin
  inherited DoBeforeOpen;
  SetQuerySQL(DataSource, GetSQL);
end;

procedure TCustomerInvoiceOrders.DoOnCalcFields;
var
  ns: string;
begin
  if DataSet.State = dsInternalCalc then
  begin
    ns := Format('%5.5d', [NvlInteger(DataSet[TOrder.F_OrderNumber])]);
    DataSet['Description'] := VarToStr(DataSet[TOrder.F_OrderNumber]) + ' ' + NvlString(DataSet['Comment']);
    DataSet['OrderNumber'] := ns;
  end;
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
