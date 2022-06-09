unit PmStockDocumentItems;

interface

uses DB, SysUtils, DBClient, //ADODB,

  CalcUtils, PmEntity, PmDocument;

type
  TStockDocumentItems = class(TDocumentItems)
  private
    FPriceChanging, FCostChanging: boolean;
    procedure QuantityChanged(_Field: TField);
    function GetQuantity: variant;
    procedure SetQuantity(Value: variant);
    function GetItemCost: variant;
    procedure SetItemCost(Value: variant);
    function GetMatCode: variant;
    procedure SetMatCode(Value: variant);
    {function GetMatUnitCode: variant;
    procedure SetMatUnitCode(Value: variant);}
    procedure ItemCostChanged(Sender: TField);
    procedure ItemPriceChanged(Sender: TField);
    procedure ManualFixChanged(Sender: TField);
    procedure UpdatePrice;
    procedure UpdateCost;
  protected
    //FUpdateProc: TADOStoredProc;
    procedure CreateFields; override;
    //function GetSelectSQL: string; override;
    procedure DoOnNewRecord; override;
    procedure DoOnCalcFields; override;
    //procedure GetTableName(Sender: TObject; DataSet: TDataSet;
    //  var TableName: WideString); override;
    procedure ProviderBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
      UpdateKind: TUpdateKind; var Applied: Boolean); override;
    function GetQuantityField: string; virtual; abstract;
  public
    const
      F_ItemCost = 'ItemCost';
      F_Price = 'ItemPrice';
      F_MatUnitName = 'MatUnitName';
      F_MatName = 'MatName';
      F_MatCode = 'MatCode';
      F_MatUnitCode = 'MatUnitCode';
      F_ManualFix = 'ManualFix';

    constructor CreateWithKey(_KeyField, _DocKeyField: string); override;
    destructor Destroy; override;

    // свойства для доступа к данным
    property Quantity: variant read GetQuantity;// write SetQuantity;
    //property QuantityEditable: variant read GetQuantityEditable write SetQuantityEditable;
    property ItemCost: variant read GetItemCost write SetItemCost;
    property MatCode: variant read GetMatCode write SetMatCode;
    //property MatUnitCode: variant read GetMatUnitCode write SetMatUnitCode;
  end;

implementation

uses Forms, Provider, Variants,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmStockDocument,
  PmConfigManager, DicObj, PmStockMove, StdDic;

constructor TStockDocumentItems.CreateWithKey(_KeyField, _DocKeyField: string);
begin
  inherited CreateWithKey(_KeyField, _DocKeyField);
  //DataSet.FieldByName(F_ItemCost).OnChange := ItemCostChanged;
  //DataSet.FieldByName(F_Price).OnChange := ItemPriceChanged;
  //DataSet.FieldByName(F_ManualFix).OnChange := ManualFixChanged;
end;

destructor TStockDocumentItems.Destroy;
begin
  inherited;
end;

procedure TStockDocumentItems.CreateFields;
var
  f: TField;
begin
  inherited CreateFields;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_ItemCost;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt;
  (f as TNumericField).EditFormat := CalcUtils.NumEditFmt;
  f.Size := 2;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.OnChange := ItemCostChanged;

  f := TFloatField.Create(DataSet.Owner);
  f.FieldName := GetQuantityField;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.OnChange := QuantityChanged;

  f := TFloatField.Create(DataSet.Owner);
  f.FieldName := F_Price;
  (f as TNumericField).DisplayFormat := CalcUtils.NumDisplayFmt4;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.OnChange := ItemPriceChanged;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := F_ManualFix;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.OnChange := ManualFixChanged;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TStockMove.F_StockMoveID;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_MatCode;
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

  {f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_MatUnitName;
  f.ReadOnly := true;
  f.Size := DicItemNameSize;
  f.FieldKind := fkCalculated;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;}

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_MatUnitCode;
  f.FieldKind := fkInternalCalc;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
end;

{function TStockDocumentItems.GetQuantityEditable: variant;
begin
  Result := DataSet[F_QuantityEditable];
end;

procedure TStockDocumentItems.SetQuantityEditable(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_QuantityEditable] := Value;
end;}

function TStockDocumentItems.GetQuantity: variant;
begin
  Result := DataSet[GetQuantityField];
end;

procedure TStockDocumentItems.SetQuantity(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[GetQuantityField] := Value;
end;

function TStockDocumentItems.GetItemCost: variant;
begin
  Result := DataSet[F_ItemCost];
end;

procedure TStockDocumentItems.SetItemCost(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_ItemCost] := Value;
end;

function TStockDocumentItems.GetMatCode: variant;
begin
  Result := DataSet[F_MatCode];
end;

procedure TStockDocumentItems.SetMatCode(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_MatCode] := Value;
end;

{function TStockDocumentItems.GetMatUnitCode: variant;
begin
  Result := DataSet[F_MatUnitCode];
end;

procedure TStockDocumentItems.SetMatUnitCode(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_MatUnitCode] := Value;
end;}

procedure TStockDocumentItems.DoOnNewRecord;
begin
  inherited;
  DataSet[F_ManualFix] := false;
end;

procedure TStockDocumentItems.DoOnCalcFields;
var
  mu: integer;
begin
  inherited;
  if NvlInteger(MatCode) > 0 then
  begin
    mu := NvlInteger(TConfigManager.Instance.StandardDics.deExternalMaterials.ItemValue[MatCode, TStandardDics.FN_MatUnitCode]);
    DataSet[F_MatUnitCode] := mu;
    //DataSet[F_MatUnitName] := TConfigManager.Instance.StandardDics.deMatUnits.ItemName[mu];
  end
  else
  begin
    DataSet[F_MatUnitCode] := null;
    //DataSet[F_MatUnitName] := '';
  end;
  // Копируем оригинальное кол-во в редактируемое поле.
  // TODO: Проверить, не делается ли это лишний раз.
  {if (DataSet.State = dsInternalCalc) and VarIsNull(QuantityEditable)
    and not VarIsNull(Quantity) then
  begin
    DataSet[F_QuantityEditable] := Quantity;
  end;
  }
end;

procedure TStockDocumentItems.QuantityChanged(_Field: TField);
begin
  UpdatePrice;
end;

procedure TStockDocumentItems.ProviderBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
  UpdateKind: TUpdateKind; var Applied: Boolean);
begin
  inherited ProviderBeforeUpdateRecord(Sender, SourceDS, DeltaDS, UpdateKind, Applied);
end;

procedure TStockDocumentItems.UpdatePrice;
begin
  FPriceChanging := true;
  try
    if NvlFloat(Quantity) = 0 then
      DataSet[F_Price] := 0
    else
      DataSet[F_Price] := NvlFloat(ItemCost) / Quantity;
  finally
    FPriceChanging := false;
  end;
end;

procedure TStockDocumentItems.UpdateCost;
begin
  FCostChanging := true;
  try
    ItemCost := NvlFloat(DataSet[F_Price]) * NvlFloat(Quantity);
  finally
    FCostChanging := false;
  end;
end;

procedure TStockDocumentItems.ItemCostChanged(Sender: TField);
begin
  if not FCostChanging then
  begin
    FCostChanging := true;
    try
      if not NvlBoolean(DataSet[F_ManualFix]) then
        DataSet[F_ManualFix] := true;
    finally
      FCostChanging := false;
    end;
    UpdatePrice;
  end;
end;

procedure TStockDocumentItems.ItemPriceChanged(Sender: TField);
begin
  if not FPriceChanging then
  begin
    FPriceChanging := true;
    try
      if NvlBoolean(DataSet[F_ManualFix]) then
        DataSet[F_ManualFix] := false;
    finally
      FPriceChanging := false;
    end;
    UpdateCost;
  end;
end;

procedure TStockDocumentItems.ManualFixChanged(Sender: TField);
begin
  if not FPriceChanging and not FCostChanging then
  begin
    if NvlBoolean(DataSet[F_ManualFix]) then
      UpdatePrice
    else
      UpdateCost;
  end;
end;


end.
