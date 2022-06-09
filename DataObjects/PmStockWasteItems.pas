unit PmStockWasteItems;

interface

uses DB, SysUtils, DBClient, //ADODB,

  CalcUtils, PmEntity, PmDocument, PmStockDocumentItems;

type

  TStockWasteItems = class(TStockDocumentItems)
  private
  protected
    procedure CreateFields; override;
    function GetSelectSQL: string; override;
    function GetTableAlias: string; override;
    procedure GetTableName(Sender: TObject; DataSet: TDataSet;
      var TableName: WideString); override;
    function GetOrderNumber: integer;
    function GetQuantityField: string; override;

  public
    const
      F_StockWasteItemID = 'StockWasteItemID';
      F_WasteQuantity = 'WasteQuantity';

    constructor Create; override;
    destructor Destroy; override;

    property OrderNumber: integer read GetOrderNumber;
  end;

implementation

uses Forms, Provider, Variants,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmStockWaste,
  PmConfigManager, DicObj, PmStockMove, StdDic, PmMaterials, PmOrder, PmUtils;

constructor TStockWasteItems.Create;
begin
  inherited CreateWithKey(F_StockWasteItemID, TStockWaste.F_StockWasteDocID);
end;

destructor TStockWasteItems.Destroy;
begin
  inherited;
end;

procedure TStockWasteItems.CreateFields;
var
  f: TField;
begin
  inherited CreateFields;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TMaterials.F_Key;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_OrderNumber;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  DataSet.FieldByName(F_ItemCost).ProviderFlags := [];
  DataSet.FieldByName(F_Price).ProviderFlags := [];
  DataSet.FieldByName(F_ManualFix).ProviderFlags := [];

  NewRecordProc := 'up_NewStockWasteItem';
  UpdateRecordProc := 'up_UpdateStockWasteItem';
  DeleteRecordProc := 'up_DeleteStockWasteItem';
end;

function TStockWasteItems.GetSelectSQL: string;
begin
  Result := 'select ii.StockWasteItemID, ii.StockWasteDocID, sm.WasteQuantity, sm.ItemPrice,'#13#10
    + '  sm.ItemCost, sm.ManualFix, ii.StockMoveID, sm.MatCode, smp.MatID,'#13#10
    + '  wo.ID_Number'#13#10
    + 'from StockWasteItem ii inner join StockMove sm on ii.StockMoveID = sm.StockMoveID'
    + '    inner join StockMoveProcess smp on sm.StockMoveID = smp.StockMoveID'#13#10
    + '    inner join OrderProcessItemMaterial opim on opim.MatID = smp.MatID'#13#10
    + '    inner join OrderProcessItem opi on opi.ItemID = opim.ItemID'#13#10
    + '    inner join WorkOrder wo on wo.N = opi.OrderID'#13#10;
end;

procedure TStockWasteItems.GetTableName(Sender: TObject; DataSet: TDataSet;
    var TableName: WideString);
begin
  TableName := 'StockWasteItem';    // наверное и не надо, все обновлени€ через хранимки
end;

function TStockWasteItems.GetTableAlias: string;
begin
  Result := 'ii';
end;

function TStockWasteItems.GetOrderNumber: integer;
begin
  Result := DataSet[TOrder.F_OrderNumber];
end;

function TStockWasteItems.GetQuantityField: string;
begin
  Result := F_WasteQuantity;
end;

end.
