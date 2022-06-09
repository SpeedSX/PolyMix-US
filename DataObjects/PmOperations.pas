unit PmOperations;

interface

uses Classes, DB, DBClient,

  PmOrderItemDetails;

type
  TOperations = class(TOrderItemDetails)
  protected
    procedure SetOrderID(const Value: Integer); override;
    procedure CreateDataSet(DataOwner: TComponent);
  public
    constructor Create(DataOwner: TComponent);
    destructor Destroy; override;

    procedure ClearOperation(ItemKey: integer; OperTypeName: string);
    procedure SetOperation(ItemKey: integer; OperTypeName, OperSubTypeName, OperDesc: string);

    // Временно перекрыты
    procedure Close; override;
    procedure Open; override;
    function ApplyUpdates: boolean; override;
  end;

implementation

uses SysUtils, MainData;

const
  F_Key = 'OperID';

// TODO: Выключено пока не реализованы операции!
procedure TOperations.Close;
begin
end;

// TODO: Выключено пока не реализованы операции!
procedure TOperations.Open;
begin
end;

// TODO: Выключено пока не реализованы операции!
function TOperations.ApplyUpdates: boolean;
begin
  Result := true;
end;

constructor TOperations.Create(DataOwner: TComponent);
begin
  inherited Create;
  FKeyField := F_Key;
  RefreshAfterApply := false;
  CreateDataSet(DataOwner);
end;

destructor TOperations.Destroy;
begin
  DataSet.Free;
  inherited;
end;

procedure TOperations.CreateDataSet(DataOwner: TComponent);
var
  _DataSet: TClientDataSet;
begin
  _DataSet := TClientDataSet.Create(DataOwner);
  SetDataSet(_DataSet);
  //DataSetProvider := dm.pvItemOperation;
end;

// TODO: Выключено пока не реализованы операции!
procedure TOperations.SetOrderID(const Value: Integer);
begin
end;

procedure TOperations.ClearOperation(ItemKey: integer; OperTypeName: string);
begin
  DataSet.Filter := 'ItemID = ' + IntToStr(ItemKey) + ' and OperTypeName = ''' + OperTypeName + '''';
  DataSet.Filtered := true;
  try
    while DataSet.RecordCount > 0 do
      DataSet.Delete;
  finally
    DataSet.Filtered := false;
  end;
end;

procedure TOperations.SetOperation(ItemKey: integer; OperTypeName, OperSubTypeName, OperDesc: string);
begin
end;

end.
