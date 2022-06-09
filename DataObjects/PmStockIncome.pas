unit PmStockIncome;

interface

uses DB, SysUtils, Variants, DBClient,

  CalcUtils, PmEntity, DicObj, PmStock, PmStockMove, PmContragent,
  MainFilter, PmStockIncomeItems, PmStockDocument, PmDocument;

type
  TStockIncome = class(TStockDocument)
  protected
    procedure CreateFields; override;
    function GetSelectSQL: string; override;
    function GetDateField: string; override;
    function GetTableAlias: string; override;
    function GetTableName: string; override;
    function GetItemClass: TDocumentItemsClass; override;
    //function GetItemsNoOpen: TStockIncomeItems;
    function GetQuantityField: string; override;
  public
    const
      F_StockIncomeDocID = 'StockIncomeDocID';
      F_IncomeDate = 'IncomeDate';
      F_SupplierID = 'SupplierID';
      F_SupplierName = 'SupplierName';
      F_IncomeQuantity = 'IncomeQuantity';
    constructor Create; override;
  end;

implementation

uses Forms, Provider, Graphics,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmOrder, PmConfigManager;

constructor TStockIncome.Create;
begin
  inherited CreateWithKey(F_StockIncomeDocID, TStockIncomeItems.F_StockIncomeItemID);
end;

function TStockIncome.GetDateField: string;
begin
  Result := F_IncomeDate;
end;

function TStockIncome.GetTableAlias: string;
begin
  Result := 'sid';
end;

procedure TStockIncome.CreateFields;
var
  f: TField;
begin
  inherited CreateFields;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_SupplierID;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_SupplierName;
  f.ReadOnly := true;
  f.Size := TContragents.CustNameSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  NewRecordProc := 'up_NewStockIncomeDoc';
  DeleteRecordProc := 'up_DeleteStockIncomeDoc';
end;

function TStockIncome.GetSelectSQL: string;
begin
  Result := 'select sid.StockIncomeDocID, sid.IncomeDate, cc.Name as SupplierName, sid.WareCode,'
    + '  sid.SupplierID, sid.DocNum, sid.UserLogin, au.Name as UserName, sid.PayType, sid.SyncState,'#13#10

    + '  (select top 1 sm.MatCode from StockIncomeItem sii'#13#10
    + '    inner join StockMove sm on sii.StockMoveID = sm.StockMoveID'#13#10
    + '    where sid.StockIncomeDocID = sii.StockIncomeDocID order by sm.StockMoveID) as MatCode,'#13#10

    + '  (select top 1 de.A1 from StockIncomeItem sii'#13#10
    + '    inner join StockMove sm on sii.StockMoveID = sm.StockMoveID'#13#10
    + '    inner join Dic_ExternalMaterials de on de.Code = sm.MatCode'#13#10
    + '    where sid.StockIncomeDocID = sii.StockIncomeDocID order by sm.StockMoveID) as MatUnitCode,'#13#10

    + '  (select top 1 sm.IncomeQuantity from StockIncomeItem sii'#13#10
    + '    inner join StockMove sm on sii.StockMoveID = sm.StockMoveID'#13#10
    + '    where sid.StockIncomeDocID = sii.StockIncomeDocID order by sm.StockMoveID) as IncomeQuantity,'#13#10

    + '  cast((select sum(ItemCost) from StockIncomeItem sii'#13#10
    + '    inner join StockMove sm on sii.StockMoveID = sm.StockMoveID'#13#10
    + '    where sid.StockIncomeDocID = sii.StockIncomeDocID) as decimal(18,2)) as TotalItemCost,'#13#10

    + '  cast((case (select count(*) from StockIncomeItem sii where sii.StockIncomeDocID = sid.StockIncomeDocID) when 1 then 0 when 0 then 0 else 1 end) as bit) as HasManyItems'#13#10
    + 'from StockIncomeDoc sid '#13#10
    //+ '  inner join Dic_MaterialUnit du on du.Code = dm.A1'#13#10
    + '  inner join Customer cc on cc.N = SupplierID'#13#10
    + '  left join AccessUser au on au.Login = sid.UserLogin'#13#10;
end;

function TStockIncome.GetTableName: string;
begin
  Result := 'StockIncomeDoc';
end;

{function TStockIncome.GetItems: TStockIncomeItems;
begin
  Result := GetItems as TStockIncomeItems;
end;

function TStockIncome.GetItemsNoOpen: TStockIncomeItems;
begin
  Result := GetDetailDataNoOpen(0) as TStockIncomeItems;
end;}

function TStockIncome.GetItemClass: TDocumentItemsClass;
begin
  Result := TStockIncomeItems;
end;

function TStockIncome.GetQuantityField: string;
begin
  Result := F_IncomeQuantity;
end;

end.
