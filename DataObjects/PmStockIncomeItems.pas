unit PmStockIncomeItems;

interface

uses DB, SysUtils, DBClient, //ADODB,

  CalcUtils, PmEntity, PmDocument, PmStockDocumentItems;

type

  TStockIncomeItems = class(TStockDocumentItems)
  private
  protected
    procedure CreateFields; override;
    function GetSelectSQL: string; override;
    function GetTableAlias: string; override;
    procedure GetTableName(Sender: TObject; DataSet: TDataSet;
      var TableName: WideString); override;
    function GetQuantityField: string; override;
  public
    const
      F_StockIncomeItemID = 'StockIncomeItemID';
      F_IncomeQuantity = 'IncomeQuantity';

    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

uses Forms, Provider, Variants,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmStockIncome,
  PmConfigManager, DicObj, PmStockMove, StdDic;

constructor TStockIncomeItems.Create;
begin
  inherited CreateWithKey(F_StockIncomeItemID, TStockIncome.F_StockIncomeDocID);
end;

destructor TStockIncomeItems.Destroy;
begin
  inherited;
end;

procedure TStockIncomeItems.CreateFields;
begin
  inherited CreateFields;

  NewRecordProc := 'up_NewStockIncomeItem';
  UpdateRecordProc := 'up_UpdateStockIncomeItem';
  DeleteRecordProc := 'up_DeleteStockIncomeItem';
end;

function TStockIncomeItems.GetSelectSQL: string;
begin
  Result := 'select ii.StockIncomeItemID, ii.StockIncomeDocID, sm.IncomeQuantity, sm.ItemPrice,'#13#10
    + '  sm.ItemCost, sm.ManualFix, ii.StockMoveID, sm.MatCode'#13#10
    + 'from StockIncomeItem ii inner join StockMove sm on ii.StockMoveID = sm.StockMoveID';
end;

procedure TStockIncomeItems.GetTableName(Sender: TObject; DataSet: TDataSet;
    var TableName: WideString);
begin
  TableName := 'StockIncomeItem';    // наверное и не надо, все обновлени€ через хранимки
end;

function TStockIncomeItems.GetTableAlias: string;
begin
  Result := 'ii';
end;

function TStockIncomeItems.GetQuantityField: string;
begin
  Result := F_IncomeQuantity;
end;

end.
