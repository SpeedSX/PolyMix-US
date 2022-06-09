unit PmOrderInvoiceItems;

interface

uses DB, SysUtils,

  CalcUtils, PmEntity, PmInvoiceItems, PmInvoice;

type
  // используется при поиске по номеру заказа или счета и для выборки
  TOrderInvoiceItemsCriteria = record
    const
      Mode_Normal = 0;
      Mode_Empty = 1;
      Mode_TempTable = 2;
    var
      CustomerID: integer;
      //Year: integer;
      DateFilter: string;
      OrderID: variant;
      Mode: integer;
      InvoiceID: variant;
      InvoiceNumber: variant;
      PayType: variant;
      ForSale: boolean;  // только нереализованные
      SaleInvoiceItemID: integer; // текущая позиция реализации для добавления к выборке
    class function Default: TOrderInvoiceItemsCriteria; static;
  end;

  TOrderInvoiceItems = class(TInvoiceItems)
  protected
    //FOrderID: variant;
    FCriteria: TOrderInvoiceItemsCriteria;
    procedure CreateFields; override;
    function GetSQL: string; override;
    procedure DoOnCalcFields; override;
    class function FindItems(FindExpr: string;
      OrderCriteria: TOrderInvoiceItemsCriteria;
      var OrderCustomerID: integer; var OrderIDs: TIntArray;
      var InvoiceIDs: TIntArray): TIntArray;
    function GetContragentID: integer;
    function GetPayType: integer;
    function GetPayTypeName: string;
    function GetInvoiceID: variant;
    function GetInvoiceNumber: string;
    function GetInvoiceDate: TDateTime;
    //procedure DoOnCalcFields; override;
  public
    const
      F_OrderDate = 'wo.CreationDate';
      F_PayType = 'PayType';
      F_PayTypeName = 'PayTypeName';
      F_PayState = 'PayState';
      F_SyncState = 'SyncState';
      //F_InvoiceDate = 'InvoiceDate';
      //F_InvoiceNum = 'InvoiceNum';
      F_ContragentName = 'ContragentName';
      F_ContragentFullName = 'ContragentFullName';

    // возвращает массив ключей
    class function FindByOrderNumber(OrderNumber: integer;
      OrderCriteria: TOrderInvoiceItemsCriteria;
      var OrderCustomerID: integer; var OrderIDs: TIntArray;
      var InvoiceIDs: TIntArray): TIntArray;
    // возвращает массив ключей
    class function FindByInvoiceNumber(InvoiceNumber: string;
      OrderCriteria: TOrderInvoiceItemsCriteria;
      var OrderCustomerID: integer; var OrderIDs: TIntArray;
      var InvoiceIDs: TIntArray): TIntArray;
    // возвращает массив ключей
    class function FindByInvoiceID({InvoiceNumber: string;}
      OrderCriteria: TOrderInvoiceItemsCriteria;
      var OrderCustomerID: integer; var OrderIDs: TIntArray;
      var InvoiceIDs: TIntArray): TIntArray;
    // возвращает true если найдено
    class function FindByID(InvoiceItemID: integer;
      var OrderID, _CustomerID, _InvoiceID: integer): boolean;

    //property OrderID: variant read FOrderID write FOrderID;
    property Criteria: TOrderInvoiceItemsCriteria read FCriteria write FCriteria;
    property ContragentID: integer read GetContragentID;
    property PayType: integer read GetPayType;
    property PayTypeName: string read GetPayTypeName;
    property InvoiceID: variant read GetInvoiceID;
    property InvoiceNumber: string read GetInvoiceNumber;
    property InvoiceDate: TDateTime read GetInvoiceDate;
  end;

implementation

uses Forms, Variants,

  RDBUtils, PmDatabase, StdDic, DicObj,
  PmContragent, PmConfigManager, PmOrder;

class function TOrderInvoiceItemsCriteria.Default: TOrderInvoiceItemsCriteria;
var
  Cr: TOrderInvoiceItemsCriteria;
begin
  Cr.CustomerID := 0;
  Cr.DateFilter := '';
  Cr.OrderID := null;
  Cr.Mode := Mode_Normal;
  Cr.InvoiceID := null;
  Cr.InvoiceNumber := null;
  Cr.PayType := null;
  Cr.ForSale := false;
  Cr.SaleInvoiceItemID := 0;
  Result := Cr;
end;

procedure TOrderInvoiceItems.CreateFields;
var
  f: TField;
begin
  inherited;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'ContragentID';
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_ContragentName;
  f.Size := TContragents.CustNameSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_ContragentFullName;
  f.Size := 300;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TInvoices.F_InvoiceNum;
  f.Size := TInvoices.InvoiceNumSize;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := TInvoices.F_InvoiceDate;
  (f as TDateTimeField).DisplayFormat := ShortDateFormat2;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_SyncState;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_PayType;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_PayState;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  {f := TBCDField.Create(nil);
  f.FieldName := 'InvoicePayCost';
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  f.Size := 2;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;}

  // Вычисляемые поля
  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_PayTypeName;
  f.DataSet := DataSet;
  f.FieldKind := fkCalculated;
  f.Name := DataSet.Name + f.FieldName;
end;

function TOrderInvoiceItems.GetSQL: string;
var
  {expr, IncomeFilter: string;}
  Where: string;

  procedure AddWhere(Cond: string);
  begin
    if Length(Where) > 0 then
      Where := Where + ' and ';
    Where := Where + Cond;
  end;

begin
  {expr := CustomerPaymentsFilter.GetFilterExpr(Self);
  if expr <> '' then expr := ' and (' + expr + ')';

  IncomeFilter := '';
  CustomerPaymentsFilter.AppendDateFilterExpr(IncomeFilter, 'IncomeDate', false);
  if IncomeFilter <> '' then IncomeFilter := ' and (' + IncomeFilter + ')';}

  Result := 'select ii.InvoiceItemID, ii.InvoiceID, Quantity, Price, ItemCost, ItemText,' + #13#10
    + ' ManualFix, ii.OrderID, wo.ID_Number as OrderNum, InvoiceNum, InvoiceDate, inv.ContragentID,' + #13#10
    + ' cc.Name as ContragentName, inv.PayType, ExternalProductID,' + #13#10
    + ' wo.Customer as OrderCustomerID, wo.CreationDate,'
    + ' (case when cc.FullName is null or cc.FullName = '''' then cc.Name else cc.FullName end) as ContragentFullName,' + #13#10
    // сумма оплат по счету
    + GetInvoicePayCostExpr + ' as InvoicePayCost,' + #13#10
    // сумма оплат по заказу
    + GetOrderPayCostExpr + ' as PayCost,' + #13#10
    //+ GetOrderCostExpr + ' as OrderCost,' + #13#10
    // для состояния - сумма оплат по заказу
    //+ ' dbo.GetPayState((' + GetOrderPayCostExpr + '), ItemCost, dc.A4, dc.A5, dc.A6) as PayState,' + #13#10
    + ' dc.A4 as PayState, -- заглушка' + #13#10
    + ' inv.SyncState' + #13#10
    + 'from InvoiceItems ii inner join WorkOrder wo on ii.OrderID = wo.N' + #13#10
    + ' inner join Invoices inv on inv.InvoiceID = ii.InvoiceID' + #13#10
    + ' inner join Customer cc on cc.N = inv.ContragentID' + #13#10
    + ' left join Dic_Cash dc on inv.PayType = dc.Code' + #13#10;
  if FCriteria.Mode = TOrderInvoiceItemsCriteria.Mode_Normal then
  begin
    Where := '';
    if not VarIsNull(FCriteria.InvoiceID) and not VarIsEmpty(FCriteria.InvoiceID) then
      AddWhere('InvoiceID = ' + VarToStr(FCriteria.InvoiceID));
    if not VarIsNull(FCriteria.OrderID) and not VarIsEmpty(FCriteria.OrderID) then
      AddWhere('OrderID = ' + VarToStr(FCriteria.OrderID));
    if not VarIsNull(FCriteria.InvoiceNumber) and not VarIsEmpty(FCriteria.InvoiceNumber) then
      AddWhere('InvoiceNum = ' + QuotedStr(FCriteria.InvoiceNumber));
    if NvlInteger(FCriteria.PayType) <> 0 then
      AddWhere('inv.PayType = ' + IntToStr(FCriteria.PayType));
    if FCriteria.CustomerID > 0 then
      AddWhere('inv.ContragentID = ' + IntToStr(FCriteria.CustomerID));
    if FCriteria.ForSale then
    begin
      AddWhere('(ii.InvoiceItemID = ' + IntToStr(FCriteria.SaleInvoiceItemID)
        + ' or ii.Quantity > ISNULL((select sum(si.SaleQuantity) from SaleItems si where si.InvoiceItemID = ii.InvoiceItemID), 0))');
    end;
    if Length(Where) > 0 then
      Result := Result + 'where ' + Where + #13#10;
  end
  else
  if FCriteria.Mode = TOrderInvoiceItemsCriteria.Mode_Empty then
    Result := Result + 'where 1 = 0' + #13#10
  else
  if FCriteria.Mode = TOrderInvoiceItemsCriteria.Mode_TempTable then
    Result := Result + 'inner join #OrderIDs ids on ii.OrderID = ids.OrderID' + #13#10;

  Result := Result + 'order by InvoiceItemID';
end;

{procedure TOrderInvoiceItems.DoOnCalcFields;
begin
  DataSet['ToPayGrn'] := DataSet['ItemCost'] - DataSet['PaidGrn'];
end;}

class function TOrderInvoiceItems.FindByOrderNumber(OrderNumber: integer;
  OrderCriteria: TOrderInvoiceItemsCriteria;
  var OrderCustomerID: integer; var OrderIDs: TIntArray;
  var InvoiceIDs: TIntArray): TIntArray;
begin
  Result := FindItems('wo.ID_Number = ' + IntToStr(OrderNumber),
    OrderCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
end;

class function TOrderInvoiceItems.FindByInvoiceNumber(InvoiceNumber: string;
  OrderCriteria: TOrderInvoiceItemsCriteria;
  var OrderCustomerID: integer; var OrderIDs: TIntArray;
  var InvoiceIDs: TIntArray): TIntArray;
begin
  Result := FindItems('inv.InvoiceNum = ''' + InvoiceNumber + '''',
    OrderCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
end;

class function TOrderInvoiceItems.FindByInvoiceID({InvoiceNumber: string;}
  OrderCriteria: TOrderInvoiceItemsCriteria;
  var OrderCustomerID: integer; var OrderIDs: TIntArray;
  var InvoiceIDs: TIntArray): TIntArray;
begin
  Result := FindItems('inv.InvoiceID = ' + VarToStr(OrderCriteria.InvoiceID),
    OrderCriteria, OrderCustomerID, OrderIDs, InvoiceIDs);
end;

class function TOrderInvoiceItems.FindByID(InvoiceItemID: integer;
  var OrderID, _CustomerID, _InvoiceID: integer): boolean;
var
  TmpIDs: TIntArray;
  OrderCriteria: TOrderInvoiceItemsCriteria;
  OrderIDs, InvoiceIDs: TIntArray;
begin
  OrderCriteria.CustomerID := 0;
  OrderCriteria.DateFilter := '';
  TmpIDs := FindItems('ii.InvoiceItemID = ' + IntToStr(InvoiceItemID),
    OrderCriteria, _CustomerID, OrderIDs, InvoiceIDs);
  Result := Length(TmpIDs) > 0;
  if Result then
  begin
    OrderID := OrderIDs[0];
    _InvoiceID := InvoiceIDs[0];
  end;
end;

class function TOrderInvoiceItems.FindItems(FindExpr: string;
  OrderCriteria: TOrderInvoiceItemsCriteria;
  var OrderCustomerID: integer; var OrderIDs: TIntArray;
  var InvoiceIDs: TIntArray): TIntArray;
var
  KeyData: TDataSet;
  s: string;
  i, CurOrderID, CurInvoiceID: integer;
begin
  //InvoiceID := 0;
  s := 'select InvoiceItemID, wo.N, ii.InvoiceID';
  //if OrderCriteria.CustomerID <> 0 then
    s := s + ', inv.ContragentID';
  s := s  + ' from InvoiceItems ii inner join AliveWorkOrders wo with (noexpand) on wo.N = ii.OrderID' + #13#10;
  //if OrderCriteria.CustomerID <> 0 then
    s := s + '  inner join Invoices inv on ii.InvoiceID = inv.InvoiceID';
  s := s + ' where /*wo.IsDeleted = 0 and */' + FindExpr;
  if OrderCriteria.CustomerID <> 0 then
    s := s + ' and inv.ContragentID = ' + IntToStr(OrderCriteria.CustomerID);
  if OrderCriteria.DateFilter <> '' then
    s := s + ' and (' + OrderCriteria.DateFilter + ')';
  if not VarIsEmpty(OrderCriteria.PayType) and not VarIsNull(OrderCriteria.PayType) then
    s := s + ' and inv.PayType = ' + IntToStr(OrderCriteria.PayType);
  KeyData := Database.ExecuteQuery(s);
  try
    KeyData.First;
    SetLength(Result, KeyData.RecordCount);
    SetLength(OrderIDs, 0);
    SetLength(InvoiceIDs, 0);
    i := 0;
    while not KeyData.Eof do
    begin
      Result[i] := KeyData['InvoiceItemID'];

      // Заполняем массив ключей заказов
      CurOrderID := KeyData[TOrder.F_OrderKey];
      if not IntInArray(CurOrderID, OrderIDs) then
      begin
        SetLength(OrderIDs, Length(OrderIDs) + 1);
        OrderIDs[Length(OrderIDs) - 1] := CurOrderID;
      end;

      // Заполняем массив ключей счетов
      CurInvoiceID := KeyData['InvoiceID'];
      if not IntInArray(CurInvoiceID, InvoiceIDs) then
      begin
        SetLength(InvoiceIDs, Length(InvoiceIDs) + 1);
        InvoiceIDs[Length(InvoiceIDs) - 1] := CurInvoiceID;
      end;

      Inc(i);
      KeyData.Next;
    end;
    OrderCustomerID := NvlInteger(KeyData['ContragentID']);
    //InvoiceID := NvlInteger(KeyData['InvoiceID']);
  finally
    KeyData.Free;
  end;
end;

function TOrderInvoiceItems.GetContragentID: integer;
begin
  Result := NvlInteger(DataSet['ContragentID']);
end;

function TOrderInvoiceItems.GetPayType: integer;
begin
  Result := NvlInteger(DataSet['PayType']);
end;

function TOrderInvoiceItems.GetPayTypeName: string;
begin
  Result := NvlString(DataSet['PayTypeName']);
end;

procedure TOrderInvoiceItems.DoOnCalcFields;
begin
  inherited;
  if VarIsNull(DataSet['PayType']) then
    DataSet['PayTypeName'] := '?'
  else
    DataSet['PayTypeName'] := TConfigManager.Instance.StandardDics.dePayKind.ItemName[DataSet['PayType']];
end;

function TOrderInvoiceItems.GetInvoiceID: variant;
begin
  Result := DataSet[TInvoices.F_InvoiceKey];
end;

function TOrderInvoiceItems.GetInvoiceNumber: string;
begin
  Result := NvlString(DataSet[TInvoices.F_InvoiceNum]);
end;

function TOrderInvoiceItems.GetInvoiceDate: TDateTime;
begin
  Result := NvlDateTime(DataSet[TInvoices.F_InvoiceDate]);
end;

end.
