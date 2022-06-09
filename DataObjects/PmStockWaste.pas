unit PmStockWaste;

interface

uses DB, SysUtils, Variants, DBClient,

  CalcUtils, PmEntity, StdDic, DicObj, PmStock, PmStockMove, PmContragent,
  MainFilter, PmDocument, PmStockDocument;

type
  TStockWaste = class(TStockDocument)
  private
  protected
    procedure CreateFields; override;
    function GetSelectSQL: string; override;
    function GetDateField: string; override;
    function GetTableAlias: string; override;
    function GetTableName: string; override;
    function GetItemClass: TDocumentItemsClass; override;
    procedure DoOnNewRecord; override;
    function GetQuantityField: string; override;
  public
    const
      F_StockWasteDocID = 'StockWasteDocID';
      F_WasteDate = 'WasteDate';
      F_WasteQuantity = 'WasteQuantity';
    constructor Create; override;
  end;

implementation

uses Forms, Provider, Graphics,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmOrder,
  PmStockWasteItems;

constructor TStockWaste.Create;
begin
  inherited CreateWithKey(F_StockWasteDocID, TStockWasteItems.F_StockWasteItemID);
end;

function TStockWaste.GetDateField: string;
begin
  Result := F_WasteDate;
end;

function TStockWaste.GetTableAlias: string;
begin
  Result := 'sid';
end;

function TStockWaste.GetTableName: string;
begin
  Result := 'StockWasteDoc';
end;

procedure TStockWaste.CreateFields;
begin
  inherited CreateFields;

  NewRecordProc := 'up_NewStockWasteDoc';
  DeleteRecordProc := 'up_DeleteStockWasteDoc';
end;

function TStockWaste.GetSelectSQL: string;
begin
  Result := 'select sid.StockWasteDocID, sid.WasteDate, sid.WareCode,'
    + '  sid.DocNum, sid.UserLogin, au.Name as UserName, sid.PayType, sid.SyncState,'#13#10

    + '  (select top 1 sm.MatCode from StockWasteItem sii'#13#10
    + '    inner join StockMove sm on sii.StockMoveID = sm.StockMoveID'#13#10
    + '    where sid.StockWasteDocID = sii.StockWasteDocID order by sm.StockMoveID) as MatCode,'#13#10

    + '  (select top 1 de.A1 from StockWasteItem sii'#13#10
    + '    inner join StockMove sm on sii.StockMoveID = sm.StockMoveID'#13#10
    + '    inner join Dic_ExternalMaterials de on de.Code = sm.MatCode'#13#10
    + '    where sid.StockWasteDocID = sii.StockWasteDocID order by sm.StockMoveID) as MatUnitCode,'#13#10

    + '  (select top 1 sm.WasteQuantity from StockWasteItem sii'#13#10
    + '    inner join StockMove sm on sii.StockMoveID = sm.StockMoveID'#13#10
    + '    where sid.StockWasteDocID = sii.StockWasteDocID order by sm.StockMoveID) as WasteQuantity,'#13#10

    + '  cast((select sum(ItemCost) from StockWasteItem sii'#13#10
    + '    inner join StockMove sm on sii.StockMoveID = sm.StockMoveID'#13#10
    + '    where sid.StockWasteDocID = sii.StockWasteDocID) as decimal(18,2)) as TotalItemCost,'#13#10

    + '  (select top 1 wo.ID_Number from StockWasteItem sii'#13#10
    + '    inner join StockMoveProcess sm on sii.StockMoveID = sm.StockMoveID'#13#10
    + '    inner join OrderProcessItemMaterial opim on opim.MatID = sm.MatID'#13#10
    + '    inner join OrderProcessItem opi on opi.ItemID = opim.ItemID'#13#10
    + '    inner join WorkOrder wo on wo.N = opi.OrderID'#13#10
    + '    where sid.StockWasteDocID = sii.StockWasteDocID order by sm.StockMoveID) as ID_Number,'#13#10

    + '  cast((case (select count(*) from StockWasteItem sii where sii.StockWasteDocID = sid.StockWasteDocID) when 1 then 0 when 0 then 0 else 1 end) as bit) as HasManyItems'#13#10
    + 'from StockWasteDoc sid '#13#10
    //+ '  inner join Dic_MaterialUnit du on du.Code = dm.A1'#13#10
    + '  left join AccessUser au on au.Login = sid.UserLogin'#13#10;
end;

function TStockWaste.GetItemClass: TDocumentItemsClass;
begin
  Result := TStockWasteItems;
end;

procedure TStockWaste.DoOnNewRecord;
begin
  inherited;
end;

function TStockWaste.GetQuantityField: string;
begin
  Result := F_WasteQuantity;
end;

end.
