unit PmStockDocument;

interface

uses DB, SysUtils, Variants, DBClient,

  CalcUtils, PmEntity, DicObj, PmStock, PmStockMove, PmContragent,
  MainFilter, PmDocument;

type
  TStockDocument = class(TDocument)
  protected
    procedure CreateFields; override;
    function GetDocNumField: string; override;
    procedure DoOnNewRecord; override;
    function GetWareCode: variant;
    procedure SetWareCode(Value: variant);
    //function GetItemsNoOpen: TStockIncomeItems;
    function GetHasManyItems: boolean;
    function GetQuantityField: string; virtual; abstract;
  public
    const
      F_DocNum = 'DocNum';
      F_TotalItemCost = 'TotalItemCost';
      F_MatUnitName = 'MatUnitName';
      F_MatName = 'MatName';
      F_MatCode = 'MatCode';
      F_MatUnitCode = 'MatUnitCode';
      F_UserLogin = 'UserLogin';
      F_UserName = 'UserName';
      F_WareCode = 'WareCode';
      F_WareName = 'WareName';
      F_HasManyItems = 'HasManyItems';
    property WareCode: variant read GetWareCode write SetWareCode;
    property HasManyItems: boolean read GetHasManyItems;
  end;

implementation

uses Forms, Provider, Graphics,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmOrder, PmConfigManager;

function TStockDocument.GetDocNumField: string;
begin
  Result := F_DocNum;
end;

procedure TStockDocument.CreateFields;
var
  f: TField;
begin
  inherited CreateFields;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_DocNum;
  //f.ReadOnly := true;
  f.Size := 50;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TFloatField.Create(DataSet.Owner);
  f.FieldName := GetQuantityField;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_TotalItemCost;
  (f as TBCDField).Precision := 18;
  (f as TBCDField).Size := 2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_MatCode;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_MatUnitCode;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_WareCode;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_MatName;
  f.ReadOnly := true;
  f.Size := DicItemNameSize;
  f.FieldKind := fkLookup;
  f.LookupDataSet := TConfigManager.Instance.StandardDics.deExternalMaterials.DicItems;
  f.LookupKeyFields := F_DicItemCode;
  f.LookupResultField := F_DicItemName;
  f.KeyFields := F_MatCode;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_MatUnitName;
  f.ReadOnly := true;
  f.Size := DicItemNameSize;
  f.FieldKind := fkLookup;
  f.LookupDataSet := TConfigManager.Instance.StandardDics.deMatUnits.DicItems;
  f.LookupKeyFields := F_DicItemCode;
  f.LookupResultField := F_DicItemName;
  f.KeyFields := F_MatUnitCode;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_UserLogin;
  f.ReadOnly := true;
  f.Size := 50;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_UserName;
  f.ReadOnly := true;
  f.Size := 50;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_WareName;
  f.ReadOnly := true;
  f.Size := DicItemNameSize;
  f.FieldKind := fkLookup;
  f.LookupDataSet := TConfigManager.Instance.StandardDics.deWarehouse.DicItems;
  f.LookupKeyFields := F_DicItemCode;
  f.LookupResultField := F_DicItemName;
  f.KeyFields := F_WareCode;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := F_HasManyItems;
  f.ReadOnly := true;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
end;

procedure TStockDocument.DoOnNewRecord;
var
  de: TDictionary;
begin
  inherited;
  // устанавливаем первый попавшийся склад
  de := TConfigManager.Instance.StandardDics.deWarehouse;
  if not de.DicItems.IsEmpty then
  begin
    de.DicItems.First;
    WareCode := de.CurrentCode;
  end;
end;

function TStockDocument.GetWareCode: variant;
begin
  Result := DataSet[F_WareCode];
end;

procedure TStockDocument.SetWareCode(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_WareCode] := Value;
end;

function TStockDocument.GetHasManyItems: boolean;
begin
  Result := NvlBoolean(DataSet[F_HasManyItems]);
end;

end.
