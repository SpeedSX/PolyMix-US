unit PmInvoiceItems;

interface

uses DB, SysUtils,

  CalcUtils, PmEntity;

type
  TInvoiceItemsCriteria = record
    InvoiceID: integer;
    OrderFilter: string;  // доп. условие, например для отбора заказа, если пусто, то не учитывается
  end;

  TInvoiceItems = class(TEntity)
  private
    FCriteria: TInvoiceItemsCriteria;
    function GetQuantity: variant;
    procedure SetQuantity(Value: variant);
    function GetItemCost: variant;
    procedure SetItemCost(Value: variant);
    function GetItemText: variant;
    procedure SetItemText(Value: variant);
    function GetProductID: variant;
    procedure SetProductID(Value: variant);
    function GetOrderID: variant;
    function GetOrderNumber: integer;
    function GetCreationDate: TDateTime;
    function GetOrderCustomerID: integer;
    procedure SetOrderID(Value: variant);
    procedure QuantityOrCostChanged(_Field: TField);
    function GetItemDebt: extended;
    function GetItemCredit: extended;
    procedure GetTableName(Sender: TObject; DataSet: TDataSet;
      var TableName: WideString);
    procedure SetOrderNumber(Value: integer);
    procedure ItemTextGetText(Sender: TField; var Text: String; DisplayText: Boolean);
  protected
    FDataSource: TDataSource;
    //FInvoiceID: variant;
    procedure CreateFields; virtual;
    function GetSQL: string; virtual;
    procedure DoBeforeOpen; override;
    procedure DoOnNewRecord; override;
    procedure DoOnCalcFields; override;
    function GetOrderPayCostExpr: string;
    function GetInvoicePayCostExpr: string;
    //function GetOrderCostExpr: string;
  public
    const
      F_ItemCost = 'ItemCost';
      F_Quantity = 'Quantity';
      F_Price = 'Price';
      F_ItemText = 'ItemText';
      F_PayCost = 'PayCost';
      F_InvoicePayCost = 'InvoicePayCost';
      F_ItemDebt = 'ItemDebt';
      F_ItemCredit = 'ItemCredit';
      F_InvoiceItemKey = 'InvoiceItemID';
      F_ExternalProductID = 'ExternalProductID';
      F_OrderNumber = 'OrderNum';
      //F_InvoiceItemParentKey = 'InvoiceID';
      ItemTextSize = 300;

    constructor Create; override;
    destructor Destroy; override;

    property Criteria: TInvoiceItemsCriteria read FCriteria write FCriteria;
    //property InvoiceID: variant read FInvoiceID write FInvoiceID;
    property OrderID: variant read GetOrderID write SetOrderID;
    property DataSource: TDataSource read FDataSource;
    // свойства для доступа к данным
    property Quantity: variant read GetQuantity write SetQuantity;
    property ItemCost: variant read GetItemCost write SetItemCost;
    property ItemText: variant read GetItemText write SetItemText;
    property OrderNumber: integer read GetOrderNumber write SetOrderNumber;
    property CreationDate: TDateTime read GetCreationDate;
    property OrderCustomerID: integer read GetOrderCustomerID;
    property ItemDebt: extended read GetItemDebt;
    property ItemCredit: extended read GetItemCredit;
    property ExternalProductID: variant read GetProductID write SetProductID;
  end;

implementation

uses Forms, Provider, Variants,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmInvoice, PmConfigManager;

constructor TInvoiceItems.Create;
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
  FKeyField := F_InvoiceItemKey;

  UseWaitCursor := false;   // отключаем ждущий курсор
  FForeignKeyField := TInvoices.F_InvoiceKey;//ItemParentKey;
  FInternalName := ClassName;
  SetDataSet(_DataSet);
  _Provider.OnGetTableName := GetTableName;
  _Provider.UpdateMode := upWhereKeyOnly;
  DataSetProvider := _Provider;
  FDataSource := _DataSource;

  CreateFields;
end;

destructor TInvoiceItems.Destroy;
begin
  inherited;
end;

procedure TInvoiceItems.CreateFields;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_InvoiceItemKey;
  f.ProviderFlags := [pfInKey, pfInWhere];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := FForeignKeyField;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'OrderID';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_ItemCost;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  (f as TNumericField).EditFormat := CalcUtils.NumEditFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.OnChange := QuantityOrCostChanged;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_Quantity;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.OnChange := QuantityOrCostChanged;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_OrderNumber;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'OrderCustomerID';
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_Price;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt4;
  f.Size := 4;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := 'ManualFix';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_ItemText;
  f.Size := ItemTextSize;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.OnGetText := ItemTextGetText;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_PayCost;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  (f as TNumericField).EditFormat := CalcUtils.NumEditFmt;
  f.Size := 2;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_InvoicePayCost;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  (f as TNumericField).EditFormat := CalcUtils.NumEditFmt;
  f.Size := 2;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'CreationDate';
  (f as TDateTimeField).DisplayFormat := CalcUtils.StdDateFmt;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_ExternalProductID;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  {f := TBCDField.Create(nil);
  f.FieldName := 'OrderCost';
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;}

  // вычисляемые

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_ItemDebt;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.FieldKind := fkCalculated;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_ItemCredit;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.FieldKind := fkCalculated;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'OrderNumText';
  f.ProviderFlags := [];
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
end;

function TInvoiceItems.GetOrderPayCostExpr: string;
begin
  Result := 'cast(ISNULL((select sum(PayCost) from Payments p where p.InvoiceItemID = ii.InvoiceItemID), 0) as decimal(18,2))';
end;

function TInvoiceItems.GetInvoicePayCostExpr: string;
begin
  Result := 'cast(ISNULL((select sum(IncomeGrn) from CustomerIncome ci where ci.IncomeInvoiceID = ii.InvoiceID), 0) as decimal(18,2))';
end;

{function TInvoiceItems.GetOrderCostExpr: string;
begin
  Result := 'ISNULL((select top 1 FinalCostGrn from Service_ClientPrice sp inner join OrderProcessItem opi on sp.ItemID = opi.ItemID where opi.OrderID = ii.OrderID), 0)';
end;}

function TInvoiceItems.GetSQL: string;
{var
  expr, IncomeFilter: string;}
begin
  {expr := CustomerPaymentsFilter.GetFilterExpr(Self);
  if expr <> '' then expr := ' and (' + expr + ')';

  IncomeFilter := '';
  CustomerPaymentsFilter.AppendDateFilterExpr(IncomeFilter, 'IncomeDate', false);
  if IncomeFilter <> '' then IncomeFilter := ' and (' + IncomeFilter + ')';}

  Result := 'select InvoiceItemID, InvoiceID, Quantity, Price, ItemCost, ItemText,'#13#10
    + ' ManualFix, OrderID, wo.ID_Number as OrderNum, wo.CreationDate, ExternalProductID,'#13#10
    + GetOrderPayCostExpr + ' as ' + F_PayCost + ','#13#10
    + GetInvoicePayCostExpr + ' as ' + F_InvoicePayCost + ','#13#10
    //+ GetOrderCostExpr + ' as OrderCost,' + #13#10
    + ' wo.Customer as OrderCustomerID'#13#10
    + 'from InvoiceItems ii inner join WorkOrder wo on ii.OrderID = wo.N'#13#10
    + 'where InvoiceID = ' + IntToStr(FCriteria.InvoiceID) + #13#10;

  if NvlString(FCriteria.OrderFilter) <> '' then
    Result := Result + ' and (' + FCriteria.OrderFilter + ')';

  Result := Result + 'order by InvoiceItemID';
end;

procedure TInvoiceItems.DoBeforeOpen;
begin
  inherited DoBeforeOpen;
  SetQuerySQL(DataSource, GetSQL);
end;

function TInvoiceItems.GetQuantity: variant;
begin
  Result := DataSet['Quantity'];
end;

procedure TInvoiceItems.SetQuantity(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['Quantity'] := Value;
end;

function TInvoiceItems.GetItemCost: variant;
begin
  Result := DataSet['ItemCost'];
end;

procedure TInvoiceItems.SetItemCost(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['ItemCost'] := Value;
end;

function TInvoiceItems.GetItemText: variant;
begin
  Result := DataSet['ItemText'];
end;

procedure TInvoiceItems.SetItemText(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['ItemText'] := Value;
end;

function TInvoiceItems.GetProductID: variant;
begin
  Result := DataSet['ExternalProductID'];
end;

procedure TInvoiceItems.SetProductID(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['ExternalProductID'] := Value;
end;

function TInvoiceItems.GetOrderID: variant;
begin
  Result := DataSet['OrderID'];
end;

procedure TInvoiceItems.SetOrderID(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['OrderID'] := Value;
end;

procedure TInvoiceItems.SetOrderNumber(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['OrderNumText'] := Value;
end;

function TInvoiceItems.GetOrderNumber: integer;
begin
  Result := NvlInteger(DataSet['OrderNum']);
end;

function TInvoiceItems.GetCreationDate: TDateTime;
begin
  Result := NvlDateTime(DataSet['CreationDate']);
end;

function TInvoiceItems.GetOrderCustomerID: integer;
begin
  Result := NvlInteger(DataSet['OrderCustomerID']);
end;

function TInvoiceItems.GetItemDebt: extended;
begin
  Result := NvlFloat(DataSet['ItemDebt']);
end;

function TInvoiceItems.GetItemCredit: extended;
begin
  Result := NvlFloat(DataSet['ItemCredit']);
end;

procedure TInvoiceItems.DoOnNewRecord;
begin
  inherited;
  DataSet['ManualFix'] := false;
end;

procedure TInvoiceItems.DoOnCalcFields;
var
  id: extended;
begin
  id := NvlFloat(DataSet['ItemCost']) - NvlFloat(DataSet['PayCost']);
  if id > 0 then
  begin
    DataSet[F_ItemDebt] := id;
    DataSet[F_ItemCredit] := 0;
  end
  else
  begin
    DataSet[F_ItemDebt] := 0;
    DataSet[F_ItemCredit] := -id;
  end;
  if VarIsNull(DataSet['OrderNumText']) or VarIsEmpty(DataSet['OrderNumText'])
    and (DataSet.State = dsInternalCalc) then
    DataSet['OrderNumText'] := DataSet['OrderNum'];
end;

procedure TInvoiceItems.QuantityOrCostChanged(_Field: TField);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  if Quantity <> 0 then
    DataSet['Price'] := NvlFloat(ItemCost) / NvlFloat(Quantity)
  else
    DataSet['Price'] := 0;
end;

procedure TInvoiceItems.GetTableName(Sender: TObject; DataSet: TDataSet;
    var TableName: WideString);
begin
  TableName := 'InvoiceItems';
end;

procedure TInvoiceItems.ItemTextGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if NvlInteger(ExternalProductID) > 0 then
    Text := TConfigManager.Instance.StandardDics.deExternalProducts.ItemName[ExternalProductID]
  else
    Text := NvlString(ItemText);
end;

end.
