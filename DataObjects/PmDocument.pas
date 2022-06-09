unit PmDocument;

interface

uses DB, SysUtils, Variants, DBClient,

  CalcUtils, PmEntity, MainFilter;

type
  TDocumentItemsCriteria = record
    DocID: integer;
  end;

  TDocumentItems = class(TEntity)
  private
    FCriteria: TDocumentItemsCriteria;
    function GetDocID: variant;
    procedure SetDocID(Value: variant);
  protected
    FDataSource: TDataSource;
    procedure CreateFields; virtual;
    function GetSelectSQL: string; virtual; abstract;
    function GetSQL: string;
    procedure DoBeforeOpen; override;
    procedure GetTableName(Sender: TObject; DataSet: TDataSet;
      var TableName: WideString); virtual; abstract;
    function GetTableAlias: string; virtual; abstract;
  public
    constructor CreateWithKey(KeyFieldName, DocKeyFieldName: string); virtual;

    property DocID: variant read GetDocID write SetDocID;
    property Criteria: TDocumentItemsCriteria read FCriteria write FCriteria;
    property DataSource: TDataSource read FDataSource;
  end;

  TDocumentItemsClass = class of TDocumentItems;

  TDocument = class(TEntity)
  private
    procedure DoGetTableName(Sender: TObject; DataSet: TDataSet;
      var TableName: WideString);
  protected
    FDataSource: TDataSource;
    FCriteria: TFilterObj;
    function GetItems: TDocumentItems;
    procedure CreateFields; virtual;
    procedure DoBeforeOpen; override;
    function GetSelectSQL: string; virtual; abstract;
    function GetSQL: string;
    function GetItemsNoOpen: TDocumentItems;
    function GetItemClass: TDocumentItemsClass; virtual; abstract;
    function GetDateField: string; virtual; abstract;
    function GetTableAlias: string; virtual; abstract;
    function GetDocNumField: string; virtual; abstract;
    function GetContragentField: string; virtual; abstract;
    function GetTableName: string; virtual; abstract;
    function GetDocDate: TDateTime;
    procedure SetDocDate(Value: TDateTime);
    function GetDocNum: string;
    procedure SetDocNum(Value: string);
    function GetPayType: integer;
    procedure SetPayType(Value: integer);
    function GetContragentID: integer;
    procedure SetContragentID(Value: integer);
  public
    const
      F_UserLogin = 'UserLogin';
      F_UserName = 'UserName';
      F_PayType = 'PayType';
      F_SyncState = 'SyncState';
      
    constructor CreateWithKey(KeyFieldName, ItemKeyFieldName: string); virtual;
    destructor Destroy; override;
    // Возвращает ключи счетов с номером _DocNum, годом _DocYear,
    // с указанным видом (или null), кроме ExcludeDocKey
    function FindByDocNum(_DocNum: string; _DocYear: integer;
      ExcludeDocKey: variant; _PayType: variant): TIntArray;
    property ContragentID: integer read GetContragentID write SetContragentID;
    property DataSource: TDataSource read FDataSource;
    property Criteria: TFilterObj read FCriteria write FCriteria;
    property DocNum: string read GetDocNum write SetDocNum;
    property DocDate: TDateTime read GetDocDate write SetDocDate;
    property PayType: integer read GetPayType write SetPayType;
    property Items: TDocumentItems read GetItems;
  end;

implementation

uses Forms, Provider, Graphics,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmOrder, PmConfigManager;

constructor TDocumentItems.CreateWithKey(KeyFieldName, DocKeyFieldName: string);
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
  FKeyField := KeyFieldName;

  UseWaitCursor := false;   // отключаем ждущий курсор
  FForeignKeyField := DocKeyFieldName;
  FInternalName := ClassName;
  SetDataSet(_DataSet);
  _Provider.OnGetTableName := GetTableName;
  _Provider.UpdateMode := upWhereKeyOnly;
  DataSetProvider := _Provider;
  FDataSource := _DataSource;

  CreateFields;
end;

procedure TDocumentItems.CreateFields;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := FKeyField;
  f.ProviderFlags := [pfInKey, pfInWhere];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := FForeignKeyField;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
end;

function TDocumentItems.GetSQL: string;
begin
  Result := GetSelectSQL + #13#10 + 'where ';
  if GetTableAlias <> '' then
    Result := Result + GetTableAlias + '.';

  Result := Result + FForeignKeyField + ' = ' + IntToStr(FCriteria.DocID) + #13#10
    + 'order by ' + KeyField;
end;

procedure TDocumentItems.DoBeforeOpen;
begin
  inherited DoBeforeOpen;
  SetQuerySQL(DataSource, GetSQL);
end;

function TDocumentItems.GetDocID: variant;
begin
  Result := DataSet[FForeignKeyField];
end;

procedure TDocumentItems.SetDocID(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[FForeignKeyField] := Value;
end;

constructor TDocument.CreateWithKey(KeyFieldName, ItemKeyFieldName: string);
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
  FKeyField := KeyFieldName;

  FInternalName := ClassName;
  DefaultLastRecord := true;

  SetDataSet(_DataSet);
  _Provider.UpdateMode := upWhereKeyOnly;
  _Provider.OnGetTableName := DoGetTableName;
  DataSetProvider := _Provider;

  FDataSource := _DataSource;

  CreateFields;

  FDisableChildDataFilter := true;
  DetailData[0] := GetItemClass.CreateWithKey(ItemKeyFieldName, KeyFieldName);

  SetLength(FDateFields, 1);
  FDateFields[0] := GetDateField;
end;

procedure TDocument.CreateFields;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := KeyField;
  f.ProviderFlags := [pfInKey, pfInWhere];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := GetDateField;
  (f as TDateTimeField).DisplayFormat := ShortDateFormat2;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_PayType;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_SyncState;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
end;

function TDocument.GetSQL: string;
var
  expr: string;
begin
  Result := GetSelectSQL + #13#10;

  expr := FCriteria.GetFilterExpr(Self);
  if expr <> '' then
    Result := Result + 'where ' + expr;

  Result := Result + #13#10 + 'order by YEAR(' + GetDateField
    + '), MONTH(' + GetTableAlias + '.' + GetDateField + '), DAY(' + GetTableAlias + '.' + GetDateField + '), '
    + GetTableAlias + '.' + GetDocNumField;
end;

procedure TDocument.DoBeforeOpen;
begin
  inherited DoBeforeOpen;
  SetQuerySQL(DataSource, GetSQL);
end;

function TDocument.GetItems: TDocumentItems;
var
  Cr: TDocumentItemsCriteria;
  k: integer;
begin
  Result := GetItemsNoOpen;
  if (Result.Criteria.DocID <> NvlInteger(KeyValue)) then
  begin
    Cr := Result.Criteria;
    Cr.DocID := NvlInteger(KeyValue);
    Result.Criteria := Cr;
    Result.Reload;
  end
  else
  if not Result.Active then
    Result.Open;
  //end;
end;

function TDocument.GetItemsNoOpen: TDocumentItems;
begin
  Result := GetDetailDataNoOpen(0) as TDocumentItems;
end;

destructor TDocument.Destroy;
begin
  GetDetailDataNoOpen(0).Free;
  inherited;
end;

function TDocument.GetDocDate: TDateTime;
begin
  Result := NvlDateTime(DataSet[GetDateField]);
end;

procedure TDocument.SetDocDate(Value: TDateTime);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[GetDateField] := Value;
end;

function TDocument.GetDocNum: string;
begin
  Result := NvlString(DataSet[GetDocNumField]);
end;

procedure TDocument.SetDocNum(Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[GetDocNumField] := Value;
end;

function TDocument.GetPayType: integer;
begin
  Result := NvlInteger(DataSet[F_PayType]);
end;

procedure TDocument.SetPayType(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_PayType] := Value;
end;

// Возвращает ключи счетов с номером _DocNum, годом _DocYear,
// с указанным видом (или null), кроме ExcludeDocKey
function TDocument.FindByDocNum(_DocNum: string; _DocYear: integer;
  ExcludeDocKey: variant; _PayType: variant): TIntArray;
var
  KeyData: TDataSet;
  s: string;
  i: integer;
begin
  s := 'select ' + KeyField + ' from ' + GetTableName
     + ' where ' + GetDocNumField + ' = ' + QuotedStr(_DocNum)
     + ' and YEAR(' + GetDateField + ') = ' + IntToStr(_DocYear)
     + ' and ' + KeyField + ' <> ' + IntToStr(NvlInteger(ExcludeDocKey));
  if not VarIsNull(_PayType) then
    s := s + ' and PayType = ' + IntToStr(NvlInteger(_PayType));
  KeyData := Database.ExecuteQuery(s);
  try
    KeyData.First;
    SetLength(Result, KeyData.RecordCount);
    i := 0;
    while not KeyData.Eof do
    begin
      Result[i] := KeyData[KeyField];
      KeyData.Next;
    end;
  finally
    KeyData.Free;
  end;
end;

procedure TDocument.DoGetTableName(Sender: TObject; DataSet: TDataSet;
    var TableName: WideString);
begin
  TableName := GetTableName;
end;

function TDocument.GetContragentID: integer;
begin
  Result := NvlInteger(DataSet[GetContragentField]);
end;

procedure TDocument.SetContragentID(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[GetContragentField] := Value;
end;

end.
