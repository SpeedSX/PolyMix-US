unit PmOrderNotes;

interface

uses DB, Forms, Classes, Variants, SysUtils, Provider, DBClient,

  CalcUtils, JvInterpreter_CustomQuery, RDBUtils,
  PmDatabase, CalcSettings, PmEntity;

type
  TOrderNotesCriteria = record
    const
      Mode_Normal = 0;
      Mode_Empty = 1;
      //Mode_TempTable = 2;
    var
      OrderID: variant;
      Mode: integer;
  end;

  TOrderNotes = class(TEntity)
  private
    FDataSource: TDataSource;
    FCriteria: TOrderNotesCriteria;
    FParentOrder: TEntity;
  protected
    procedure DoBeforeOpen; override;
    procedure CreateDataSet;
    function GetSQL: string;
    function GetUserName: string;
    procedure SetUserName(Value: string);
    function GetOrderID: integer;
    procedure SetOrderID(Value: integer);
    function GetUseTech: boolean;
    procedure SetUseTech(Value: boolean);
    function GetNoteText: string;
    procedure SetNoteText(Value: string);
    procedure UserNameGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure ProviderBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
      UpdateKind: TUpdateKind; var Applied: Boolean); override;
    procedure DoOnNewRecord; override;
  public
    const
      F_NoteID = 'OrderNoteID';
      F_OrderID = 'OrderID';
      F_UserName = 'UserName';
      F_Note = 'Note';
      F_NoteDate = 'NoteDate';
      F_UseTech = 'UseTech';
    constructor Create(DataOwner: TComponent);
    property Criteria: TOrderNotesCriteria read FCriteria write FCriteria;
    property DataSource: TDataSource read FDataSource;
    property UserName: string read GetUserName write SetUserName;
    property OrderID: integer read GetOrderID write SetOrderID;
    property UseTech: boolean read GetUseTech write SetUseTech;
    property NoteText: string read GetNoteText write SetNoteText;
    property ParentOrder: TEntity read FParentOrder write FParentOrder;
  end;

implementation

uses PmAccessManager, PmOrder;

constructor TOrderNotes.Create(DataOwner: TComponent);
var
  _Provider: TDataSetProvider;
begin
  inherited Create;
  FKeyField := F_NoteID;

  FInternalName := 'OrderNotes';
  UseWaitCursor := false;

  {if PlanDM = nil then
    Application.CreateForm(TPlanDM, PlanDM);}

  FDataSource := CreateQueryExDM(DataOwner, DataOwner, FInternalName,
    [{poAllowMultiRecordUpdates, poDisableInserts, poDisableDeletes, poDisableEdits}],
    upWhereKeyOnly, false {ResolveToDataSet}, Database.Connection, _Provider);
  SetDataSet(FDataSource.DataSet);
  //_Provider.BeforeUpdateRecord := ProviderBeforeUpdateRecord;
  DataSetProvider := _Provider;

  FAssignKeyValue := true;

  CreateDataSet;
end;

procedure TOrderNotes.DoBeforeOpen;
begin
  SetQuerySQL(FDataSource, GetSQL);
end;

procedure TOrderNotes.CreateDataSet;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_NoteID;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInKey, pfInWhere];

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_OrderID;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_UserName;
  f.OnGetText := UserNameGetText;
  f.Size := 40;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_Note;
  f.DataSet := DataSet;
  f.Size := 4000;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := F_NoteDate;
  (f as TDateTimeField).DisplayFormat := 'dd/mm/yy hh:nn';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [];

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := F_UseTech;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.ProviderFlags := [pfInUpdate];
end;

function TOrderNotes.GetSQL: string;
begin
  Result := 'select OrderNoteID, UserName, Note, OrderID, NoteDate, UseTech from OrderNotes'#13#10;
  if FCriteria.Mode = TOrderNotesCriteria.Mode_Normal then
  begin
    if not VarIsNull(FCriteria.OrderID) then
      Result := Result + 'where OrderID = ' + VarToStr(FCriteria.OrderID) + #13#10;
  end
  else if FCriteria.Mode = TOrderNotesCriteria.Mode_Empty then
    Result := Result + 'where 1 = 0' + #13#10;

  Result := Result + 'order by NoteDate';
end;

function TOrderNotes.GetUserName: string;
begin
  Result := NvlString(DataSet[F_UserName]);
end;

procedure TOrderNotes.SetUserName(Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_UserName] := Value;
end;

function TOrderNotes.GetOrderID: integer;
begin
  Result := NvlInteger(DataSet[F_OrderID]);
end;

procedure TOrderNotes.SetOrderID(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_OrderID] := Value;
end;

function TOrderNotes.GetUseTech: boolean;
begin
  Result := NvlBoolean(DataSet[F_UseTech]);
end;

procedure TOrderNotes.SetUseTech(Value: boolean);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_UseTech] := Value;
end;

procedure TOrderNotes.SetNoteText(Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_Note] := Value;
end;

function TOrderNotes.GetNoteText: string;
begin
  Result := NvlString(DataSet[F_Note]);//ReadStringFromBlob(DataSet.FieldByName(F_Note) as TBlobField);
end;

procedure TOrderNotes.UserNameGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if (AccessManager.Users <> nil) and not Sender.IsNull then
  begin
    Text := AccessManager.FormatUserName(NvlString(Sender.Value));
  end;
end;

procedure TOrderNotes.ProviderBeforeUpdateRecord(Sender: TObject;
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

procedure TOrderNotes.DoOnNewRecord;
begin
  inherited DoOnNewRecord;
  UseTech := false;
  OrderID := (FParentOrder as TOrder).NewOrderKey;
end;

end.
