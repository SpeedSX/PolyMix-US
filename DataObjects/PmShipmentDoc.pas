unit PmShipmentDoc;

interface

uses DB, SysUtils, Variants, DBClient,

  CalcUtils, PmEntity;

type
  TShipmentDocFilterCriteria = record
    DocID: integer;
    //DocNum: variant;
  end;

  TShipmentDoc = class(TEntity)
  private
    //FCriteria: TShipmentFilterObj;
  protected
    FDataSource: TDataSource;
    FCriteria: TShipmentDocFilterCriteria;
    procedure CreateFields;
    procedure DoBeforeOpen; override;
    function GetSQL: string;
    function GetShipmentDate: TDateTime;
    procedure SetShipmentDate(Value: TDateTime);
    function GetShipmentDocNum: integer;
    procedure SetShipmentDocNum(Value: integer);
    function GetCustomerName: string;
    function GetCustomerID: integer;
    procedure SetCustomerID(Value: integer);
    function GetWhoIn: string;
    function GetWhoOut: string;
    procedure SetWhoOut(Value: string);
    function GetWhoOutUserId: integer;
    procedure SetWhoOutUserId(Value: integer);
    function GetTrustSerie: variant;
    function GetTrustNum: variant;
    function GetTrustDate: variant;
  public
    const
      F_ShipmentDocKey = 'ShipmentDocID';
      F_ShipmentDate = 'ShipmentDate';
      F_WhoOut = 'WhoOut';
      F_WhoOutUserId = 'WhoOutUserId';
      F_WhoIn = 'WhoIn';

    constructor Create; override;
    property DataSource: TDataSource read FDataSource;
    property Criteria: TShipmentDocFilterCriteria read FCriteria write FCriteria;
    property ShipmentDocNum: integer read GetShipmentDocNum write SetShipmentDocNum;
    property ShipmentDate: TDateTime read GetShipmentDate write SetShipmentDate;
    property CustomerID: integer read GetCustomerID write SetCustomerID;
    property CustomerName: string read GetCustomerName;
    property WhoIn: string read GetWhoIn;
    property WhoOut: string read GetWhoOut write SetWhoOut;
    property WhoOutUserId: integer read GetWhoOutUserId write SetWhoOutUserId;
    property TrustSerie: variant read GetTrustSerie;
    property TrustNum: variant read GetTrustNum;
    property TrustDate: variant read GetTrustDate;
  end;

implementation

uses Forms, Provider, Graphics,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmOrder,
  PmContragent, DicObj, StdDic;

constructor TShipmentDoc.Create;
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
  FKeyField := F_ShipmentDocKey;

  FInternalName := ClassName;
  DefaultLastRecord := true;

  SetDataSet(_DataSet);
  {_Provider.UpdateMode := upWhereKeyOnly;
  _Provider.OnGetTableName := GetTableName;}
  DataSetProvider := _Provider;

  //FDataSource.Free;  // меняем на свой
  FDataSource := _DataSource;

  CreateFields;

  {SetLength(FDateFields, 5);
  FDateFields[0] := 'wo.CreationDate';
  FDateFields[1] := 'wo.ModifyDate';
  FDateFields[2] := 'wo.FinishDate';
  FDateFields[3] := 'wo.FactFinishDate';
  FDateFields[4] := 'wo.CloseDate';}
end;

procedure TShipmentDoc.CreateFields;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_ShipmentDocKey;
  f.ProviderFlags := [pfInKey, pfInWhere];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'ShipmentDocNum';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := F_ShipmentDate;
  (f as TDateTimeField).DisplayFormat := ShortDateFormat2;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'CustomerID';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_WhoOut;
  f.Size := 40;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_WhoOutUserId;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_WhoIn;
  f.Size := 40;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'CustomerName';
  f.ReadOnly := true;
  f.Size := TContragents.CustNameSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  //f.OnGetText := StoreOutCommentGetText;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'CustomerFullName';
  f.ReadOnly := true;
  f.Size := 300;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'TrustSerie';
  f.Size := 19;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'TrustNum';
  f.Size := 31;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'TrustDate';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  NewRecordProc := 'up_NewShipmentDoc';
  DeleteRecordProc := 'up_DeleteShipmentDoc';
end;

function TShipmentDoc.GetSQL: string;
var
  //expr: string;
  ShipmentFilter: string;
begin
  {if NvlString(FCriteria.DocNum) <> '' then
    ShipmentFilter := 'sh.ShipmentDocNum = ' + QuotedStr(FCriteria.DocNum)
  else }if FCriteria.DocID <> 0 then
    ShipmentFilter := 'ShipmentDocID = ' + VarToStr(FCriteria.DocID)
  else
    ShipmentFilter := '1=0';

  Result := 'select ShipmentDocID, ShipmentDate,'#13#10
    + ' shd.CustomerID, c.Name as CustomerName, c.FullName as CustomerFullName,'#13#10
    + ' WhoOut, WhoIn, TrustSerie, TrustNum, TrustDate, ShipmentDocNum, WhoOutUserId'#13#10
    + 'from ShipmentDoc shd left join Customer c on shd.CustomerID = c.N'#13#10;

  if ShipmentFilter <> '' then
    Result := Result + 'where ' + ShipmentFilter;

  Result := Result + #13#10'order by ' + F_ShipmentDate;
end;

procedure TShipmentDoc.DoBeforeOpen;
begin
  inherited DoBeforeOpen;
  SetQuerySQL(DataSource, GetSQL);
  (DataSet as TClientDataSet).IndexFieldNames := '';
end;

function TShipmentDoc.GetShipmentDate: TDateTime;
begin
  Result := NvlDateTime(DataSet[F_ShipmentDate]);
end;

procedure TShipmentDoc.SetShipmentDate(Value: TDateTime);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_ShipmentDate] := Value;
end;

function TShipmentDoc.GetShipmentDocNum: integer;
begin
  Result := NvlInteger(DataSet['ShipmentDocNum']);
end;

procedure TShipmentDoc.SetShipmentDocNum(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['ShipmentDocNum'] := Value;
end;

function TShipmentDoc.GetCustomerName: string;
begin
  Result := NvlString(DataSet['CustomerName']);
end;

function TShipmentDoc.GetCustomerID: integer;
begin
  Result := NvlInteger(DataSet['CustomerID']);
end;

procedure TShipmentDoc.SetCustomerID(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['CustomerID'] := Value;
end;

function TShipmentDoc.GetWhoIn: string;
begin
  Result := NvlString(DataSet[F_WhoIn]);
end;

function TShipmentDoc.GetWhoOut: string;
begin
  Result := NvlString(DataSet[F_WhoOut]);
end;

procedure TShipmentDoc.SetWhoOut(Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_WhoOut] := Value;
end;

function TShipmentDoc.GetWhoOutUserId: integer;
begin
  Result := NvlInteger(DataSet[F_WhoOutUserId]);
end;

procedure TShipmentDoc.SetWhoOutUserId(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_WhoOutUserId] := Value;
end;

function TShipmentDoc.GetTrustSerie: variant;
begin
  Result := DataSet['TrustSerie'];
end;

function TShipmentDoc.GetTrustNum: variant;
begin
  Result := DataSet['TrustNum'];
end;

function TShipmentDoc.GetTrustDate: variant;
begin
  Result := DataSet['TrustDate'];
end;

end.
