unit PmCustomReport;

interface

uses DB, DBClient, Provider, PmEntity;

type
  TCustomReportColumns = class;

  TCustomReports = class(TEntity)
  private
    //FProcessDetails: Boolean;
    function GetIncludeEmptyDetails: Boolean;
    function GetProcessDetails: Boolean;
    function GetRepeatOrderFields: Boolean;
    function GetSort1: Variant;
    function GetSort2: Variant;
    function GetSort3: Variant;
    function GetSort4: Variant;
    function GetSortAscending: Boolean;
    function GetAddRowAfterGroup: Boolean;
    function GetDetails: TCustomReportColumns;
  protected
    CustomReportColumns: TCustomReportColumns;
    procedure DoAfterConnect; override;
    procedure DoOnNewRecord; override;
    procedure ProviderUpdateError(Sender: TObject;
      DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind;
      var Response: TResolverResponse); override;
  public
    // field function
    function ReportCaption: string;
    function AddFilter: boolean;

    procedure Open; override;
    constructor Create; override;
    destructor Destroy; override;
    property IncludeEmptyDetails: Boolean read GetIncludeEmptyDetails;
    property ProcessDetails: Boolean read GetProcessDetails;
    property RepeatOrderFields: Boolean read GetRepeatOrderFields;
    property Sort1: Variant read GetSort1;
    property Sort2: Variant read GetSort2;
    property Sort3: Variant read GetSort3;
    property Sort4: Variant read GetSort4;
    property SortAscending: Boolean read GetSortAscending;
    property AddRowAfterGroup: boolean read GetAddRowAfterGroup;
    property Details: TCustomReportColumns read GetDetails;
  end;

  TCustomReportColumns = class(TEntity)
  private
    NextOrderNum: integer;
    function GetSourceName: string;
    procedure SetSourceName(const Value: string);
    function GetOrderNum: integer;
    procedure SetOrderNum(const Value: integer);
  protected
    procedure DoBeforeInsert; override;
    procedure DoAfterConnect; override;
    procedure DoOnCalcFields; override;
    procedure DoOnNewRecord; override;
  public
    procedure Open; override;
    constructor Create; override;
    property SourceName: string read GetSourceName write SetSourceName;
    property OrderNum: integer read GetOrderNum write SetOrderNum;
  end;

var
  CustomReports: TCustomReports;
  
const
  fstOrder = 0;
  fstProcess = 1;

implementation

uses SysUtils, RepData, RDBUtils;

const
  F_Key = 'ReportID';
  F_ColKey = 'ReportItemID';

{$REGION 'CustomReports' }

constructor TCustomReports.Create;
begin
  inherited Create;
  FKeyField := F_Key;
  CustomReportColumns := TCustomReportColumns.Create;
  DetailData[0] := CustomReportColumns;
end;

destructor TCustomReports.Destroy;
begin
  FreeAndNil(CustomReportColumns);
  inherited;
end;

procedure TCustomReports.DoAfterConnect;
begin
end;

// Здесь нельзя применить обработку AfterConnect т.к. в этот момент rdm еще не создан
// не очень удобно, т.к. можно забыть вызвать Open и не устанавливаются timeouts.
procedure TCustomReports.Open;
begin
  if DataSet = nil then
  begin
    SetDataSet(rdm.cdCustomReports);
    DataSetProvider := rdm.pvCustomReports;
    //ADODataSet := rdm.aqCustomReports;
  end;
  inherited Open;
end;

procedure TCustomReports.DoOnNewRecord;
begin
  DataSet['AddFilter'] := true;
  DataSet['ProcessDetails'] := true;
  DataSet['ProcessLine'] := false;
  DataSet['IncludeEmptyDetails'] := false;
  DataSet['RepeatOrderFields'] := true;
  DataSet['AddRowAfterGroup'] := true;
end;

function TCustomReports.ReportCaption: string;
begin
  Result := DataSet['ReportName'];
end;

function TCustomReports.AddFilter: boolean;
begin
  Result := DataSet['AddFilter'];
end;

function TCustomReports.GetIncludeEmptyDetails: Boolean;
begin
  Result := DataSet['IncludeEmptyDetails'];
end;

function TCustomReports.GetProcessDetails: Boolean;
begin
  Result := DataSet['ProcessDetails'];
end;

function TCustomReports.GetRepeatOrderFields: Boolean;
begin
  Result := DataSet['RepeatOrderFields'];
end;

function TCustomReports.GetSort1: Variant;
begin
  Result := DataSet['Sort1'];
end;

function TCustomReports.GetSort2: Variant;
begin
  Result := DataSet['Sort2'];
end;

function TCustomReports.GetSort3: Variant;
begin
  Result := DataSet['Sort3'];
end;

function TCustomReports.GetSort4: Variant;
begin
  Result := DataSet['Sort4'];
end;

function TCustomReports.GetSortAscending: Boolean;
begin
  Result := NvlBoolean(DataSet['SortAscending']);
end;

function TCustomReports.GetAddRowAfterGroup: Boolean;
begin
  Result := NvlBoolean(DataSet['AddRowAfterGroup']);
end;

function TCustomReports.GetDetails: TCustomReportColumns;
begin
  Result := DetailData[0] as TCustomReportColumns;
end;

procedure TCustomReports.ProviderUpdateError(Sender: TObject;
  DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind;
  var Response: TResolverResponse);
begin
  // Попытка обмануть MIDAS. При обновлении записи на сервере срабатывают триггеры,
  // поэтому возвращается неправильное количество обновленных строк.
  if E.ErrorCode = 1 then
    Response := rrIgnore
  else
    inherited ProviderUpdateError(Sender, DataSet, E, UpdateKind, Response);
end;

{$ENDREGION}

{$REGION 'CustomReportColumns' }

constructor TCustomReportColumns.Create;
begin
  inherited Create;
  FKeyField := F_ColKey;
  FForeignKeyField := F_Key;
  FAssignKeyValue := true;
end;

procedure TCustomReportColumns.DoAfterConnect;
begin
end;

// Здесь нельзя применить обработку AfterConnect т.к. в этот момент rdm еще не создан
// не очень удобно, т.к. можно забыть вызвать Open и не устанавливаются timeouts.
procedure TCustomReportColumns.Open;
begin
  if DataSet = nil then
  begin
    SetDataSet(rdm.cdCustomReportCols);
    DataSetProvider := rdm.pvCustomReportCols;
    //ADODataSet := rdm.aqCustomReportCols;
  end;
  inherited Open;
end;

procedure TCustomReportColumns.DoBeforeInsert;
begin
  DataSet.First;
  NextOrderNum := 0;
  while not DataSet.eof do
  begin
    if DataSet['OrderNum'] > NextOrderNum then
      NextOrderNum := DataSet['OrderNum'];
    DataSet.Next;
  end;
  Inc(NextOrderNum);
end;

procedure TCustomReportColumns.DoOnNewRecord;
begin
  DataSet['OrderNum'] := NextOrderNum;
  DataSet['SumTotal'] := false;
  DataSet['SumByGroup'] := false;
end;

function TCustomReportColumns.GetSourceName: string;
begin
  Result := NvlString(DataSet['SourceName']);
end;

procedure TCustomReportColumns.SetSourceName(const Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['SourceName'] := Value;
end;

procedure TCustomReportColumns.DoOnCalcFields;
begin
  DataSet['FilterEnabled'] := NvlString(DataSet['Filter']) <> '';
// TODO: Убрать, когда не нужна будет совместимость с предыдущей версией
// и сделать их полями типа fkData.
  DataSet['AutoFitColumn'] := true;
  DataSet['ColumnWidth'] := 100;
end;

function TCustomReportColumns.GetOrderNum: integer;
begin
  Result := NvlInteger(DataSet['OrderNum']);
end;

procedure TCustomReportColumns.SetOrderNum(const Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet['OrderNum'] := Value;
end;

{$ENDREGION}

initialization

CustomReports := TCustomReports.Create;

finalization

FreeAndNil(CustomReports);

end.
