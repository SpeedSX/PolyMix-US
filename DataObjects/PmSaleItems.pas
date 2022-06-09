unit PmSaleItems;

interface

uses DB, SysUtils, Variants,

  CalcUtils, PmEntity, PmShipment, MainFilter, PmDocument;

type
  TSaleItems = class(TDocumentItems)
  private
    procedure ShipmentStateGetText(Sender: TField; var Text: String; DisplayText: Boolean);
  protected
    procedure CreateFields; override;
    procedure DoOnNewRecord; override;
    procedure DoOnCalcFields; override;
    function GetSelectSQL: string; override;
    function GetTableAlias: string; override;
    procedure GetTableName(Sender: TObject; DataSet: TDataSet; var TableName: WideString); override;

    function GetOrderNumber: integer;
    procedure SetOrderNumber(Value: integer);

    function GetItemText: string;
    procedure SetItemText(Value: string);

    function GetSaleQuantity: integer;
    procedure SetSaleQuantity(Value: integer);
    function GetInvoiceItemID: integer;
    procedure SetInvoiceItemID(Value: integer);
    function GetItemCost: extended;
    procedure SetItemCost(Value: extended);
    function GetSaleCost: extended;
  public
    const
      F_SaleItemKey = 'SaleItemID';

    constructor Create; override;
    property OrderNumber: integer read GetOrderNumber write SetOrderNumber;
    property ItemText: string read GetItemText write SetItemText;
    property SaleQuantity: integer read GetSaleQuantity write SetSaleQuantity;
    property InvoiceItemID: integer read GetInvoiceItemID write SetInvoiceItemID;
    property ItemCost: extended read GetItemCost write SetItemCost;
    property SaleCost: extended read GetSaleCost;
    destructor Destroy; override;
  end;

implementation

uses Forms, Provider, Graphics,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmOrder,
  PmContragent, DicObj, StdDic, PmSaleDocs;

const
  clFirst = clWindow;
  clSecond = clInfoBk;

constructor TSaleItems.Create;
begin
  inherited CreateWithKey(F_SaleItemKey, TSaleDocs.F_SaleDocKey);
end;

destructor TSaleItems.Destroy;
begin
  inherited;
end;

procedure TSaleItems.CreateFields;
var
  f: TField;
begin
  inherited CreateFields;
  
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceItemID';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'SaleQuantity';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'Quantity';
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'ItemText';
  f.Size := TOrder.CommentSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'ItemCost';
  f.ProviderFlags := [];
  (f as TBCDField).DisplayFormat := CalcUtils.NumDisplayFmt;
  (f as TBCDField).Precision := 18;
  (f as TBCDField).Size := 2;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'OrderNum';
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'OrderNumText';
  f.ProviderFlags := [];
  f.FieldKind := fkInternalCalc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  // Calculated

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'SaleCost';
  f.FieldKind := fkCalculated;
  f.ProviderFlags := [];
  (f as TBCDField).DisplayFormat := CalcUtils.NumDisplayFmt;
  (f as TBCDField).Precision := 18;
  (f as TBCDField).Size := 2;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  NewRecordProc := 'up_NewSaleItem';
  DeleteRecordProc := 'up_DeleteSaleItem';
end;

procedure TSaleItems.ShipmentStateGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := '';
end;

function TSaleItems.GetSelectSQL: string;
begin
  Result := 'select sh.SaleItemID, sh.SaleDocID, sh.SaleQuantity, ii.Quantity,'#13#10
    + ' sh.InvoiceItemID, ii.ItemText, ii.ItemCost, wo.ID_Number as OrderNum'#13#10
    + 'from SaleItems sh inner join SaleDocs shd on shd.SaleDocID = sh.SaleDocID'#13#10
    + ' inner join InvoiceItems ii on sh.InvoiceItemID = ii.InvoiceItemID'#13#10
    + ' inner join WorkOrder wo on wo.N = ii.OrderID';
    //+ 'where sh.SaleDocID = ' + IntToStr(FCriteria.SaleDocID) + #13#10
    //+ 'order by ' + TSaleDocs.F_SaleDocDate;
end;

function TSaleItems.GetTableAlias: string;
begin
  Result := 'sh';
end;

procedure TSaleItems.SetOrderNumber(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['OrderNumText'] := Value;
end;

function TSaleItems.GetOrderNumber: integer;
begin
  Result := NvlInteger(DataSet['OrderNum']);
end;

function TSaleItems.GetItemText: string;
begin
  Result := NvlString(DataSet['ItemText']);
end;

procedure TSaleItems.SetItemText(Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['ItemText'] := Value;
end;

function TSaleItems.GetSaleQuantity: integer;
begin
  Result := NvlInteger(DataSet['SaleQuantity']);
end;

procedure TSaleItems.SetSaleQuantity(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['SaleQuantity'] := Value;
end;

function TSaleItems.GetInvoiceItemID: integer;
begin
  Result := NvlInteger(DataSet['InvoiceItemID']);
end;

procedure TSaleItems.SetInvoiceItemID(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['InvoiceItemID'] := Value;
end;

function TSaleItems.GetItemCost: extended;
begin
  Result := NvlFloat(DataSet['ItemCost']);
end;

procedure TSaleItems.SetItemCost(Value: extended);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['ItemCost'] := Value;
end;

function TSaleItems.GetSaleCost: extended;
begin
  Result := NvlFloat(DataSet['SaleCost']);
end;

procedure TSaleItems.GetTableName(Sender: TObject; DataSet: TDataSet;
    var TableName: WideString);
begin
  TableName := 'SaleItems';
end;

procedure TSaleItems.DoOnNewRecord;
begin
  inherited;
end;

procedure TSaleItems.DoOnCalcFields;
var
  ns: string;
begin
  if DataSet.State = dsInternalCalc then
  begin
    if VarIsNull(DataSet['OrderNumText']) or VarIsEmpty(DataSet['OrderNumText']) then
    begin
      ns := Format('%5.5d', [NvlInteger(DataSet['OrderNum'])]);
      DataSet['OrderNumText'] := ns;
    end;
  end;
  if NvlInteger(DataSet['Quantity']) = 0 then
    DataSet['SaleCost'] := 0
  else
    DataSet['SaleCost'] := ItemCost * (SaleQuantity * 1.0 / DataSet['Quantity']);
end;

end.
