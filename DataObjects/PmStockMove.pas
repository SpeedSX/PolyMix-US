unit PmStockMove;

interface

uses DB, SysUtils, Variants, DBClient,

  CalcUtils, PmEntity, StdDic, DicObj, MainFilter;

type
  {TStockMoveFilterCriteria = record
    MatGroupCode: variant;
    WareCode: variant;
  end;}

  TStockMove = class(TEntity)
  private
  protected
    FDataSource: TDataSource;
    FCriteria: TStockFilterObj;
    procedure CreateFields;
    procedure DoBeforeOpen; override;
    function GetSQL: string;
  public
    const
      F_StockMoveID = 'StockMoveID';
      F_ItemCost = 'ItemCost';
      F_IncomeQuantity = 'IncomeQuantity';
      F_IncomeCost = 'IncomeCost';
      F_WasteQuantity = 'WasteQuantity';
      F_WasteCost = 'WasteCost';
      F_MoveDate = 'MoveDate';
      F_MatUnitName = 'MatUnitName';
    constructor Create; override;
    property DataSource: TDataSource read FDataSource;
    property Criteria: TStockFilterObj read FCriteria write FCriteria;
  end;

implementation

uses Forms, Provider, Graphics,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmOrder,
  PmContragent;

constructor TStockMove.Create;
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
  FKeyField := F_StockMoveID;

  FInternalName := ClassName;
  DefaultLastRecord := true;

  SetDataSet(_DataSet);
  DataSetProvider := _Provider;

  FDataSource := _DataSource;

  CreateFields;

  SetLength(FDateFields, 1);
  FDateFields[0] := 'sm.MoveDate';
end;

procedure TStockMove.CreateFields;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_StockMoveID;
  f.ProviderFlags := [pfInKey, pfInWhere];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := F_MoveDate;
  (f as TDateTimeField).DisplayFormat := ShortDateFormat2;  
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TFloatField.Create(DataSet.Owner);
  f.FieldName := F_IncomeQuantity;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_IncomeCost;
  (f as TBCDField).Precision := 18;
  (f as TBCDField).Size := 2;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TFloatField.Create(DataSet.Owner);
  f.FieldName := F_WasteQuantity;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_WasteCost;
  (f as TBCDField).Precision := 18;
  (f as TBCDField).Size := 2;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_DicItemName;
  f.ReadOnly := true;
  f.Size := DicItemNameSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_MatUnitName;
  f.ReadOnly := true;
  f.Size := DicItemNameSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
end;

function TStockMove.GetSQL: string;
var
  expr: string;
begin
  Result := 'select sm.StockMoveID, sm.MoveDate, dm.Name, du.Name as MatUnitName,'#13#10
    + ' sm.IncomeQuantity,'#13#10
    + ' sm.WasteQuantity,'#13#10
    + ' (case when ISNULL(sm.IncomeQuantity, 0) > 0 then sm.ItemCost else null end) as IncomeCost,'#13#10
    + ' (case when ISNULL(sm.WasteQuantity, 0) > 0 then sm.ItemCost else null end) as WasteCost'#13#10
    + 'from StockMove sm inner join Dic_ExternalMaterials dm on sm.MatCode = dm.Code'#13#10
    + '  inner join Dic_MaterialUnit du on du.Code = dm.A1'#13#10;

  expr := FCriteria.GetFilterExpr(Self);
  if expr <> '' then
    Result := Result + 'where ' + expr;
  Result := Result + #13#10'order by sm.MoveDate';
end;

procedure TStockMove.DoBeforeOpen;
begin
  inherited DoBeforeOpen;
  SetQuerySQL(DataSource, GetSQL);
end;

end.
