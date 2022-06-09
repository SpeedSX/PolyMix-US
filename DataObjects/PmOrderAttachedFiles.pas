unit PmOrderAttachedFiles;

interface

uses DB, Forms, Classes, Variants, SysUtils, Provider, DBClient,

  CalcUtils, JvInterpreter_CustomQuery, PlanData, RDBUtils,
  PmDatabase, CalcSettings, PmEntity;

type
  TOrderAttachedFilesCriteria = record
    const
      Mode_Normal = 0;
      Mode_Empty = 1;
      //Mode_TempTable = 2;
    var
      OrderID: variant;
      Mode: integer;
  end;

  TOrderAttachedFiles = class(TEntity)
  private
    FDataSource: TDataSource;
    FCriteria: TOrderAttachedFilesCriteria;
    FParentOrder: TEntity;
  protected
    procedure DoBeforeOpen; override;
    procedure CreateDataSet;
    function GetSQL: string;
    function GetFileName: string;
    procedure SetFileName(Value: string);
    function GetOrderID: integer;
    procedure SetOrderID(Value: integer);
    procedure ProviderBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
      UpdateKind: TUpdateKind; var Applied: Boolean); override;
    procedure DoOnNewRecord; override;
  public
    const
      F_OrderAttachedFileID = 'OrderAttachedFileID';
      F_OrderID = 'OrderID';
      F_FileName = 'FileName';
      F_FileDesc = 'FileDesc';
      FileNameSize = 255;
    constructor Create(DataOwner: TComponent);
    property Criteria: TOrderAttachedFilesCriteria read FCriteria write FCriteria;
    property DataSource: TDataSource read FDataSource;
    property FileName: string read GetFileName write SetFileName;
    property OrderID: integer read GetOrderID write SetOrderID;
    property ParentOrder: TEntity read FParentOrder write FParentOrder;
  end;

implementation

uses StdDic, DicObj, PmOrder;

constructor TOrderAttachedFiles.Create(DataOwner: TComponent);
var
  _Provider: TDataSetProvider;
begin
  inherited Create;
  FKeyField := F_OrderAttachedFileID;

  FInternalName := 'OrderAttachedFiles';
  UseWaitCursor := false;

  {if PlanDM = nil then
    Application.CreateForm(TPlanDM, PlanDM);}

  FDataSource := CreateQueryExDM(DataOwner, DataOwner, FInternalName,
    [{poAllowMultiRecordUpdates, poDisableInserts, poDisableDeletes, poDisableEdits}],
    upWhereKeyOnly, false {ResolveToDataSet}, Database.Connection, _Provider);
  SetDataSet(FDataSource.DataSet);
  DataSetProvider := _Provider;

  CreateDataSet;
end;

procedure TOrderAttachedFiles.DoBeforeOpen;
begin
  SetQuerySQL(FDataSource, GetSQL);
end;

procedure TOrderAttachedFiles.CreateDataSet;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_OrderAttachedFileID;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInKey, pfInWhere];

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_OrderID;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  {f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := F_FileDate;
  f.DataSet := DataSet;
  (f as TDateTimeField).DisplayFormat := ShortDateFormat;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];}

  {f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_UserName;
  f.Size := 40;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];}

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_FileName;
  f.Size := FileNameSize;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TMemoField.Create(DataSet.Owner);
  f.FieldName := F_FileDesc;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  NewRecordProc := 'up_NewOrderAttachedFile';

end;

function TOrderAttachedFiles.GetSQL: string;
begin
  Result := 'select OrderAttachedFileID, FileName, FileDesc, OrderID from OrderAttachedFiles'#13#10;
  if FCriteria.Mode = TOrderAttachedFilesCriteria.Mode_Normal then
  begin
    if not VarIsNull(FCriteria.OrderID) then
      Result := Result + 'where OrderID = ' + VarToStr(FCriteria.OrderID) + #13#10;
  end
  else if FCriteria.Mode = TOrderAttachedFilesCriteria.Mode_Empty then
    Result := Result + 'where 1 = 0' + #13#10;
  {else if FCriteria.Mode = TOrderAttachedFilesCriteria.Mode_TempTable then
    Result := Result + 'inner join #OrderIDs ids on ii.OrderID = ids.OrderID' + #13#10;}

  Result := Result + 'order by FileName';
end;

function TOrderAttachedFiles.GetFileName: string;
begin
  Result := NvlString(DataSet[F_FileName]);
end;

procedure TOrderAttachedFiles.SetFileName(Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_FileName] := Value;
end;

function TOrderAttachedFiles.GetOrderID: integer;
begin
  Result := NvlInteger(DataSet[F_OrderID]);
end;

procedure TOrderAttachedFiles.SetOrderID(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_OrderID] := Value;
end;

procedure TOrderAttachedFiles.ProviderBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
  UpdateKind: TUpdateKind; var Applied: Boolean);
begin
  if UpdateKind = ukInsert then
  begin
    if NvlInteger((FParentOrder as TOrder).KeyValue) = 0 then
      DeltaDS.FieldByName(F_OrderID).NewValue := (FParentOrder as TOrder).NewOrderKey
    else
      DeltaDS.FieldByName(F_OrderID).NewValue := (FParentOrder as TOrder).KeyValue;
  end;
  inherited ProviderBeforeUpdateRecord(Sender, SourceDS, DeltaDS, UpdateKind, Applied);
end;

procedure TOrderAttachedFiles.DoOnNewRecord;
begin
  inherited DoOnNewRecord;
  OrderID := (FParentOrder as TOrder).NewOrderKey;
end;

end.
