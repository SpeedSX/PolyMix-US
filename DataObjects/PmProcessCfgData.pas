unit PmProcessCfgData;

interface

{$I calc.inc}

uses Classes, SysUtils, DB, DBClient, Variants, ADODB, Provider,

  PmEntity, CalcSettings, NotifyEvent, PmProcessCfg;

type
  TProcessCfgData = class(TEntity)
  private
    function GetIsActive: boolean;
    function GetProcessName: string;
    function GetProcessDesc: string;
    function GetProcessKind: TProcessViewKind;
  protected
    procedure DoOnNewRecord; override;
  public
    constructor Create; virtual;
    property IsActive: boolean read GetIsActive;
    property ProcessName: string read GetProcessName;
    property ProcessDescription: string read GetProcessDesc;
    property ProcessKind: TProcessViewKind read GetProcessKind;
  end;

  TProcessGridCfgData = class(TEntity)
  private
    function GetGridName: string;
    function GetProcessID: integer;
    procedure SetProcessID(Value: integer);
    function GetProcessPageID: integer;
    procedure SetProcessPageID(Value: integer);
  protected
    procedure DoOnNewRecord; override;
  public
    constructor Create; virtual;
    procedure SetProcessFilter(ProcessID: integer);
    procedure ResetFilter;
    property GridName: string read GetGridName;
    property ProcessID: integer read GetProcessID write SetProcessID;
    property ProcessPageID: integer read GetProcessPageID write SetProcessPageID;
  end;

  TProcessFieldData = class(TEntity)
  public
    constructor Create; virtual;
  end;

  TProcessGridColData = class(TEntity)
  protected
    procedure DoOnNewRecord; override;
  public
    constructor Create; virtual;
  end;

  TProcessPageData = class(TEntity)
  private
    FNewPageNumber: integer; // временно используется при добавлении новой страницы
    function GetProcessPageID: integer;
    procedure SetProcessPageID(Value: integer);
  protected
    procedure DoOnNewRecord; override;
    procedure DoBeforeInsert; override;
    procedure GetTableName(Sender: TObject; DataSet: TDataSet; var TableName: WideString);
  public
    constructor Create; virtual;
    property ProcessPageID: integer read GetProcessPageID write SetProcessPageID;
  end;

const
  F_ProcessPageID = 'ProcessPageID';

implementation

uses Graphics,

  ServData, RDBUtils, DataHlp;

const
  F_ProcessFieldID = 'SrvFieldID';
  F_ProcessGridColID = 'ColID';

{$REGION 'TProcessCfgData'}

constructor TProcessCfgData.Create;
begin
  inherited Create;
  FKeyField := F_SrvID;
  SetDataSet(sdm.cdServices);
  DataSetProvider := sdm.pvServices;
  DeleteRecordProc := 'up_DeleteService';
  NewRecordProc := 'up_NewService';
end;

function TProcessCfgData.GetIsActive: boolean;
begin
  Result := NvlBoolean(DataSet['SrvActive']);
end;

function TProcessCfgData.GetProcessName: string;
begin
  Result := NvlString(DataSet['SrvName']);
end;

function TProcessCfgData.GetProcessDesc: string;
begin
  Result := NvlString(DataSet['SrvDesc']);
end;

function TProcessCfgData.GetProcessKind: TProcessViewKind;
begin
  Result := TProcessViewKind(NvlInteger(DataSet['ServiceKind']));
end;

procedure TProcessCfgData.DoOnNewRecord;
begin
  inherited;
  DataSet['ServiceKind'] := cskTable;
  DataSet['SrvName'] := 'NewProcess';
  DataSet['SrvDesc'] := 'Новый процесс';
  DataSet['SrvActive'] := true;
  DataSet['AssignCalcFields'] := true;
  DataSet['AssignDataChange'] := true;
  DataSet['AssignNewRecord'] := true;
  DataSet['AssignBeforeInsert'] := false;
  DataSet['EnableBeforeScroll'] := false;
  DataSet['EnableAfterScroll'] := false;
  DataSet['EnableAfterOrderOpen'] := false;
  DataSet['StoreSettings'] := true;
  DataSet['OnlyWorkOrder'] := false;
  DataSet['ShowInReport'] := true;
  DataSet['NotForCopy'] := false;
  DataSet['EnableAfterOpen'] := true;
  DataSet['EnablePlanning'] := false;
  DataSet['EnableTracking'] := true;
  DataSet['UseInTotal'] := true;
  DataSet['UseInProfitMode'] := upmNoCost;
  DataSet['ShowInProfit'] := true;
  DataSet['HideItem'] := false;
  DataSet['IsContent'] := true;
  DataSet['SequenceOrder'] := 1;
  DataSet['EnableBeforeDelete'] := false;
  DataSet[F_EnableLinking] := true;
  DataSet[F_DefaultContractorProcess] := false;
end;

{$ENDREGION}

{$REGION 'TProcessCfgData'}

constructor TProcessGridCfgData.Create;
begin
  inherited Create;
  FKeyField := F_GridID;
  SetDataSet(sdm.cdProcessGrids);
  DataSetProvider := sdm.pvProcessGrids;
end;

function TProcessGridCfgData.GetGridName: string;
begin
  Result := NvlString(DataSet[F_GridName]);
end;

function TProcessGridCfgData.GetProcessID: integer;
begin
  Result := NvlInteger(DataSet[ProcessKeyField]);
end;

function TProcessGridCfgData.GetProcessPageID: integer;
begin
  Result := NvlInteger(DataSet[F_ProcessPageID]);
end;

procedure TProcessGridCfgData.SetProcessPageID(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_ProcessPageID] := Value;
end;

procedure TProcessGridCfgData.SetProcessID(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[ProcessKeyField] := Value;
end;

procedure TProcessGridCfgData.SetProcessFilter(ProcessID: integer);
begin
  DataSet.Filter := ProcessKeyField + '=' + IntToStr(ProcessID);
  DataSet.Filtered := true;
end;

procedure TProcessGridCfgData.ResetFilter;
begin
  DataSet.Filtered := false;
end;

procedure TProcessGridCfgData.DoOnNewRecord;
begin
  inherited;
  DataSet['GridName'] := 'NewGrid';
  DataSet['GridCaption'] := 'Новая таблица';
  DataSet['PageOrderNum'] := 0;
  DataSet['ShowControlPanel'] := true;
  DataSet['AssignDrawCell'] := false;
  DataSet['AssignGridEnter'] := true;
  DataSet['EditableGrid'] := true;
  DataSet['GridColor'] := clWindow;
  DataSet['EnableCalcTotalCost'] := false;
end;

{$ENDREGION}

{$REGION 'TProcessFieldData'}

constructor TProcessFieldData.Create;
begin
  inherited Create;
  FKeyField := F_ProcessFieldID;
  SetDataSet(sdm.cdSrvFieldInfo);
  DataSetProvider := sdm.pvSrvFieldInfo;
end;

{$ENDREGION}

{$REGION 'TProcessGridColData'}

constructor TProcessGridColData.Create;
begin
  inherited Create;
  FKeyField := F_ProcessGridColID;
  SetDataSet(sdm.cdSrvGridCols);
  DataSetProvider := sdm.pvSrvGridCols;
end;

procedure TProcessGridColData.DoOnNewRecord;
begin
  inherited;
  DataSet['Color'] := clWindow;
  DataSet['CaptionColor'] := clBtnFace;
  DataSet['FontColor'] := clWindowText;
  DataSet['FontBold'] := false;
  DataSet['FontItalic'] := false;
  DataSet['CaptionFontColor'] := clWindowText;
  DataSet['CaptionFontBold'] := true;
  DataSet['CaptionFontItalic'] := false;
  DataSet['Alignment'] := taCenter;
  DataSet['CaptionAlignment'] := taCenter;
  DataSet['Visible'] := true;
  DataSet['ReadOnly'] := false;
  DataSet['PriceColumn'] := false;
  DataSet['CostColumn'] := false;
  DataSet['ShowEditButton'] := false;
end;

{$ENDREGION}

{$REGION 'TProcessPageData'}

constructor TProcessPageData.Create;
begin
  inherited Create;
  FKeyField := F_ProcessPageID;
  SetDataSet(sdm.cdSrvPages);
  DataSetProvider := sdm.pvSrvPages;
  DataSetProvider.OnGetTableName := GetTableName;
end;

procedure TProcessPageData.DoOnNewRecord;
begin
  inherited;
  DataSet['GrpOrderNum'] := FNewPageNumber;
  DataSet['PageBuiltIn'] := false;
  DataSet['PageCaption'] := '';
  DataSet['CreateFrameOnShow'] := true;
  DataSet['EnableOnCreateFrame'] := false;
  DataSet['EmptyFrame'] := false;
end;

procedure TProcessPageData.DoBeforeInsert;
begin
  inherited;
  FNewPageNumber := CalcNewFieldValue(DataSet, 'GrpOrderNum', 1);
end;

procedure TProcessPageData.GetTableName(Sender: TObject; DataSet: TDataSet;
  var TableName: WideString);
begin
  TableName := 'SrvPages';
end;

function TProcessPageData.GetProcessPageID: integer;
begin
  Result := NvlInteger(DataSet[F_ProcessPageID]);
end;

procedure TProcessPageData.SetProcessPageID(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_ProcessPageID] := Value;
end;

{$ENDREGION}

end.
