unit PmStock;

interface

uses DB, SysUtils, Variants, DBClient,

  CalcUtils, PmEntity, StdDic;

type
  TStockFilterCriteria = record
    MatGroupCode: variant;
    WareCode: variant;
  end;

  TStock = class(TEntity)
  private
  protected
    FDataSource: TDataSource;
    FCriteria: TStockFilterCriteria;
    procedure CreateFields;
    procedure DoBeforeOpen; override;
    function GetSQL: string;
  public
    const
      F_RemainsQuantity = 'RemainsQuantity';
      F_RemainsCost = 'RemainsCost';
    constructor Create; override;
    property DataSource: TDataSource read FDataSource;
    property Criteria: TStockFilterCriteria read FCriteria write FCriteria;
  end;

implementation

uses Forms, Provider, Graphics,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmOrder,
  PmContragent, DicObj;

constructor TStock.Create;
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
  FKeyField := F_DicItemID;

  FInternalName := ClassName;
  DefaultLastRecord := true;

  SetDataSet(_DataSet);
  DataSetProvider := _Provider;

  FDataSource := _DataSource;

  CreateFields;
end;

procedure TStock.CreateFields;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_DicItemID;
  f.ProviderFlags := [pfInKey, pfInWhere];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_DicItemCode;
  f.ProviderFlags := [pfInKey, pfInWhere];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_DicItemParentCode;
  f.ProviderFlags := [pfInKey, pfInWhere];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_DicItemSyncState;
  f.ProviderFlags := [pfInKey, pfInWhere];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TFloatField.Create(DataSet.Owner);
  f.FieldName := F_RemainsQuantity;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_RemainsCost;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  (f as TBCDField).Precision := 18;
  (f as TBCDField).Size := 2;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_DicItemName;
  f.ReadOnly := true;
  f.Size := DicItemNameSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

end;

function TStock.GetSQL: string;
begin
  Result := 'select DicItemID, Code, Name, ParentCode, SyncState,'#13#10
    + ' (select sum(ISNULL(IncomeQuantity, 0) - ISNULL(WasteQuantity,  0)) from StockMove where MatCode = dm.Code) as RemainsQuantity,'#13#10
    + ' (select sum(ItemCost) from StockMove where MatCode = dm.Code) as RemainsCost'#13#10
    + 'from Dic_ExternalMaterials dm order by Code'#13#10;
end;

procedure TStock.DoBeforeOpen;
begin
  inherited DoBeforeOpen;
  SetQuerySQL(DataSource, GetSQL);
end;

end.
