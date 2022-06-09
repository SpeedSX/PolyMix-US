unit PmSaleDocs;

interface

uses DB, SysUtils, Variants,

  CalcUtils, PmEntity, MainFilter, PmSaleItems, PmDocument;

type
  TSaleDocs = class(TDocument)
  protected
    function GetTableName: string; override;
    function GetDateField: string; override;
    function GetDocNumField: string; override;
    function GetContragentField: string; override;
    function GetTableAlias: string; override;
    function GetItemClass: TDocumentItemsClass; override;
    function GetSaleItems: TSaleItems;
    procedure CreateFields; override;
    function GetSelectSQL: string; override;
    function GetSaleCost: extended;
    function GetCustomerName: string;
    function GetWhoIn: string;
    function GetWhoOut: string;
    function GetTrustSerie: variant;
    function GetTrustNum: variant;
    function GetTrustDate: variant;
    function GetHasManyItems: boolean;
  public
    const
      F_SaleDocKey = 'SaleDocID';
      F_SaleDocDate = 'SaleDate';
      F_WhoOut = 'WhoOut';
      F_WhoIn = 'WhoIn';
      F_SaleDocNum = 'SaleDocNum';

    constructor Create; override;
    //property DataSource: TDataSource read FDataSource;
    property SaleItems: TSaleItems read GetSaleItems;
    //property Criteria: TShipmentFilterObj{TShipmentInvoiceDocFilterCriteria} read FCriteria write FCriteria;
    property SaleCost: extended read GetSaleCost;
    //property CustomerID: integer read GetCustomerID write SetCustomerID;
    property HasManyItems: boolean read GetHasManyItems;
    property CustomerName: string read GetCustomerName;
    property WhoIn: string read GetWhoIn;
    property WhoOut: string read GetWhoOut;
    property TrustSerie: variant read GetTrustSerie;
    property TrustNum: variant read GetTrustNum;
    property TrustDate: variant read GetTrustDate;
  end;

implementation

uses Forms, Provider, Graphics,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmOrder,
  PmContragent, DicObj, StdDic, PmInvoiceItems, PmInvoice;

constructor TSaleDocs.Create;
begin
  inherited CreateWithKey(F_SaleDocKey, TSaleItems.F_SaleItemKey);
end;

procedure TSaleDocs.CreateFields;
var
  f: TField;
begin
  inherited CreateFields;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_SaleDocNum;
  f.Size := TInvoices.InvoiceNumSize;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'ContragentID';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_WhoOut;
  f.Size := 40;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_WhoIn;
  f.Size := 40;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'CustomerName';
  f.ReadOnly := true;
  f.Size := TContragents.CustNameSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  //f.OnGetText := StoreOutCommentGetText;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'CustomerFullName';
  f.ReadOnly := true;
  f.Size := 300;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'TrustSerie';
  f.Size := 19;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'TrustNum';
  f.Size := 31;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'TrustDate';
  f.ProviderFlags := [pfInUpdate];
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
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TInvoiceItems.F_ItemText;
  f.Size := TInvoiceItems.ItemTextSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'SaleQuantity';
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

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'SaleCost';
  f.ProviderFlags := [];
  (f as TBCDField).DisplayFormat := CalcUtils.NumDisplayFmt;
  (f as TBCDField).Precision := 18;
  (f as TBCDField).Size := 2;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  NewRecordProc := 'up_NewSaleDoc';
  DeleteRecordProc := 'up_DeleteSaleDoc';
end;

function TSaleDocs.GetDateField: string;
begin
  Result := F_SaleDocDate;
end;

function TSaleDocs.GetDocNumField: string;
begin
  Result := F_SaleDocNum;
end;

function TSaleDocs.GetItemClass: TDocumentItemsClass;
begin
  Result := TSaleItems;
end;

function TSaleDocs.GetTableAlias: string;
begin
  Result := 'shd';
end;

function TSaleDocs.GetSelectSQL: string;
begin
  Result := 'select SaleDocID, SaleDate, PayType,'#13#10
    + ' shd.ContragentID, c.Name as CustomerName, c.FullName as CustomerFullName,'#13#10
    + ' WhoOut, WhoIn, TrustSerie, TrustNum, TrustDate, SaleDocNum,'#13#10
    + ' UserLogin, au.Name as UserName, shd.SyncState,'#13#10
    + ' (select top 1 SaleQuantity from SaleItems si where si.SaleDocID = shd.SaleDocID) as SaleQuantity,'#13#10
    + ' (select top 1 ItemText from SaleItems si inner join InvoiceItems ii on ii.InvoiceItemID = si.InvoiceItemID where si.SaleDocID = shd.SaleDocID) as ItemText,'#13#10
    + ' (select top 1 ID_Number from WorkOrder wo inner join InvoiceItems ii on ii.OrderID = wo.N inner join SaleItems si on ii.InvoiceItemID = si.InvoiceItemID where si.SaleDocID = shd.SaleDocID) as OrderNumber,'#13#10
    + ' cast((case (select count(*) from SaleItems si2 where si2.SaleDocID = shd.SaleDocID) when 0 then 0 when 1 then 0 else 1 end) as bit) as HasManyItems,'#13#10
    + ' cast((select ISNULL(sum(ii.ItemCost * (si.SaleQuantity * 1.0 / ii.Quantity)), 0)'#13#10
    + '   from SaleItems si inner join InvoiceItems ii on ii.InvoiceItemID = si.InvoiceItemID where si.SaleDocID = shd.SaleDocID) as decimal(18, 2)) as SaleCost'#13#10
    + 'from SaleDocs shd left join Customer c on shd.ContragentID = c.N'#13#10
    + ' left join AccessUser au on au.Login = shd.UserLogin'#13#10;
end;

function TSaleDocs.GetSaleCost: extended;
begin
  Result := NvlFloat(DataSet['SaleCost']);
end;

function TSaleDocs.GetCustomerName: string;
begin
  Result := NvlString(DataSet['CustomerName']);
end;

function TSaleDocs.GetContragentField: string;
begin
  Result := 'ContragentID';
end;

function TSaleDocs.GetWhoIn: string;
begin
  Result := NvlString(DataSet[F_WhoIn]);
end;

function TSaleDocs.GetWhoOut: string;
begin
  Result := NvlString(DataSet[F_WhoOut]);
end;

function TSaleDocs.GetTrustSerie: variant;
begin
  Result := DataSet['TrustSerie'];
end;

function TSaleDocs.GetTrustNum: variant;
begin
  Result := DataSet['TrustNum'];
end;

function TSaleDocs.GetTrustDate: variant;
begin
  Result := DataSet['TrustDate'];
end;

function TSaleDocs.GetHasManyItems: boolean;
begin
  Result := NvlBoolean(DataSet['HasManyItems']);
end;

function TSaleDocs.GetTableName: string;
begin
  Result := 'SaleDocs';
end;

function TSaleDocs.GetSaleItems: TSaleItems;
begin
  Result := GetItems as TSaleItems;
end;


end.
