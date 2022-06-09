unit PmOrderItemDetails;

interface

uses PmEntity, DB, DBClient;

type
  TOrderItemDetails = class(TEntity)
  protected
    FReadOnly, FCostReadOnly: boolean;
    function GetOrderID: Integer;
    procedure SetOrderID(const Value: Integer); virtual;
  protected
    procedure ProviderBeforeUpdateRecord(Sender: TObject; SourceDS: TDataSet;
      DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind; var Applied: Boolean); override;
  public
    property OrderID: Integer read GetOrderID write SetOrderID;
    property ReadOnly: boolean read FReadOnly write FReadOnly;
    property CostReadOnly: boolean read FCostReadOnly write FCostReadOnly;
  end;

implementation

uses PmProcess;

procedure TOrderItemDetails.ProviderBeforeUpdateRecord(Sender: TObject; SourceDS: TDataSet;
  DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind; var Applied: Boolean);
begin
  // Заменяем в новых записях ид. записи процесса на реальный, полученный после вставки.
  if UpdateKind = ukInsert then
  begin
    if not (DeltaDS.State in [dsEdit, dsInsert]) then DeltaDS.Edit;
    DeltaDS[F_ItemID] := FMasterData.ItemIDs.GetRealItemID(DeltaDS[F_ItemID], false);
  end;
//  else
//    if (UpdateKind = ukDelete) and NvlBoolean(DeltaDS['ItemDeleted']) then
//      Applied := true  // триггер позаботится о том чтобы были удалены соотв. материалы
  DeltaDS.FieldByName(KeyField).ProviderFlags := [pfInKey, pfInWhere];
  //DoBeforeUpdateRecord(Sender, SourceDS, DeltaDS, UpdateKind, Applied);
end;

function TOrderItemDetails.GetOrderID: Integer;
begin
  Result := ADODataSet.Parameters[0].Value;
end;

procedure TOrderItemDetails.SetOrderID(const Value: Integer);
begin
  ADODataSet.Parameters[0].Value := Value;
end;

end.
