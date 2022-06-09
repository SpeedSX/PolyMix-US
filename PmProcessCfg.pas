unit PmProcessCfg;

interface

uses Classes, DB, SysUtils, Graphics, Variants, DBGridEh,
  Provider, DBClient, ADODB,

  PmAccessManager, JvAppStorage;

const
  // Process properties fields
  ProcessKeyField = 'ProcessID';
  F_SrvID = 'SrvID';
  F_BaseSrvID = 'BaseSrvID';
  F_DefaultContractorProcess = 'DefaultContractorProcess';
  F_DefaultEquipGroupCode = 'DefaultEquipGroupCode';
  F_EnablePlanning = 'EnablePlanning';
  F_EnableTracking = 'EnableTracking';
  F_SequenceOrder = 'SequenceOrder';
  F_EnableLinking = 'EnableLinking';
  F_LinkedProcessID = 'LinkedProcessID';

  F_BaseGridID = 'BaseGridID';
  F_GridID = 'GridID';
  F_GridName = 'GridName';

  upmFullCost = 0;  // режимы участия процесса в распределении наценки
  upmNoCost = 1;
  upmScriptedCost = 2;

type
  TProcessViewKind = (cskSimple, cskTable, cskForm);

  TScript = class(TObject)
    Script: TStringList;
    constructor Create;
    destructor Destroy; override;
  end;

  TScriptContainer = class(TObject)
  private
    FScripts: TStringList;
    //FScriptNames: TStringList;
    procedure FreeScripts;
  public
    // property ScriptNames: TStringList read FScriptNames write FScriptNames; 14.10.2004
    constructor Create;
    destructor Destroy; override;
    function GetScriptsFromDataSet(dq: TDataSet): TStringList;
    procedure ReadScriptsFromDataSet(dq: TDataSet);
    function ScriptByName(const ScrField: string): TStringList;
    property Scripts: TStringList read FScripts;
  end;

  TPolyProcessCfg = class
  private
    FSrvID: integer;
    FIsActive: boolean;
    FAssignBeforeInsert: boolean;
    FAssignCalcFields, FAssignDataChange: boolean;
    FAssignNewRecord: boolean;
    FBaseSrv: TPolyProcessCfg;
    FBaseSrvID: integer;
    FEnableAfterOpen: boolean;
    FEnableAfterOrderOpen: boolean;
    FEnableBeforeScroll, FEnableAfterScroll: boolean;
    FEnableBeforeDelete: boolean;
    FHideItem, FUseInTotal: boolean;
    FIsContent: boolean;
    FOnlyWorkOrder: boolean;
    FScriptContainer: TScriptContainer;
    FShowInReport: boolean;
    FSrvName: string;
    FTabName: string;
    FUseInProfitMode: integer;
    FDefaultEquipGroupCode: integer;
    FPlanningEnabled: boolean;
    FTrackingEnabled: boolean;
    FSequenceOrder: integer;
    FLinkedProcessID: integer;
    FDefaultContractorProcess: boolean; // Процесс субподрядчика (по умолчанию)
    FCalcFieldsScriptInvalid: boolean;
    FEnableLinking: boolean;
    FGrids: TCollection;
    function GetSrvIDForFields: integer;
    function GetScripts: TStringList;
    //function GetDefaultEquipGroupCode: integer;

  public
    FieldInfoData: TDataSet;  // Ссылка на набор данных со свойствами полей
                              // полей данных во время пересчета.
    constructor Create(_SrvID: integer);
    destructor Destroy; override;

    procedure SetPropsFromDataSet(sds: TDataSet);
    procedure ReadScriptsFromDataSet(dq: TDataSet); virtual;
    function GetScriptsCopyFromDataSet(dq: TDataSet): TStringList;
    procedure BeginReadFieldInfo;
    function GetScript(const ScrField: string): TStringList;
    function GetFieldInfo(FieldName: string): TDataSet;
    procedure ReadGridPropsFromDataSet(dqGrid, dqCols: TDataSet);
    procedure ReadGridScriptsFromDataSet(dq: TDataSet);
    procedure SaveSettings(AppStorage: TjvCustomAppStorage);
    procedure LoadSettings(AppStorage: TjvCustomAppStorage);

    property SrvID: integer read FSrvID;
    property IsActive: boolean read FIsActive;
    property ServiceName: string read FSrvName;// write FSrvName;
    property ShowInReport: boolean read FShowInReport;// write FShowInReport;
    property TableName: string read FTabName;// write FTabName;
    // Означает что процесс входит в состав заказа
    property IsContent: boolean read FIsContent;
    property BaseSrv: TPolyProcessCfg read FBaseSrv write FBaseSrv;
    property BaseSrvID: integer read FBaseSrvID;
    property HideItem: boolean read FHideItem;
    property PlanningEnabled: boolean read FPlanningEnabled;
    property TrackingEnabled: boolean read FTrackingEnabled;
    property SequenceOrder: integer read FSequenceOrder;
    property LinkedProcessID: integer read FLinkedProcessID;
    property UseInProfitMode: integer read FUseInProfitMode;
    property UseInTotal: boolean read FUseInTotal;
    property OnlyWorkOrder: boolean read FOnlyWorkOrder;// write FOnlyWorkOrder;
    property DefaultEquipGroupCode: integer read FDefaultEquipGroupCode;
    property DefaultContractorProcess: boolean read FDefaultContractorProcess;

    property AssignBeforeInsert: boolean read FAssignBeforeInsert write FAssignBeforeInsert;
    property AssignCalcFields: boolean read FAssignCalcFields write FAssignCalcFields;
    property AssignDataChange: boolean read FAssignDataChange write FAssignDataChange;
    property AssignNewRecord: boolean read FAssignNewRecord write FAssignNewRecord;
    property EnableAfterOpen: boolean read FEnableAfterOpen write FEnableAfterOpen;
    property EnableAfterOrderOpen: boolean read FEnableAfterOrderOpen write FEnableAfterOrderOpen;
    property EnableAfterScroll: boolean read FEnableAfterScroll write FEnableAfterScroll;
    property EnableBeforeScroll: boolean read FEnableBeforeScroll write FEnableBeforeScroll;
    property EnableBeforeDelete: boolean read FEnableBeforeDelete write FEnableBeforeDelete;
    // SrvIDForFields используется модулем sdm для отфильтровывания полей
    // при формировании SQL для этого сервиса. Если нет базового сервиса, то
    // это свойство = SrvID. ЭТО НЕ ОЧЕНЬ ХОРОШЕЕ РЕШЕНИЕ, ЛУЧШЕ СДЕЛАТЬ,
    { TODO: ЧТОБЫ ПРОЦЕСС САМ ФОРМИРОВАЛ СПИСОК ПОЛЕЙ, ТАК ЖЕ, КАК ЭТО ДЕЛАЕТСЯ СО СКРИПТАМИ. }
    property SrvIDForFields: integer read GetSrvIDForFields;  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    property CalcFieldsScriptInvalid: boolean read FCalcFieldsScriptInvalid write FCalcFieldsScriptInvalid;

    property Scripts: TStringList read GetScripts;
    property Grids: TCollection read FGrids;
  end;

  TGridCol = class(TCollectionItem)
  public
    Alignment: TAlignment;
    Caption: string;
    CaptionAlignment: TAlignment;
    CaptionColor: TColor;
    CaptionFontColor: TColor;
    CaptionFontStyle: TFontStyles;
    Color: TColor;
    FieldName: string;
    FontColor: TColor;
    FontStyle: TFontStyles;
    IsPrice, IsCost: boolean;
    ReadOnly: boolean;
    ShowEditButton: boolean;
    Visible: boolean;
    Width: integer;
    procedure Assign(Source: TPersistent); override;
    procedure AssignToColumn(Col: TColumnEh);
  end;

  TProcessGridCfg = class(TCollectionItem)
  private
    FGridID: integer;
    FProcessCfg: TPolyProcessCfg;
    FSrvID: integer;
    FAssignGridEnter, FAssignDrawCell: boolean;
    FBaseGrid: TProcessGridCfg;
    FBaseGridID: integer;
    FEditableGrid: boolean;
    FEnableCalcTotalCost: boolean;
    FGridCaption: string;
    FGridColor: TColor;
    FGridCols: TCollection;
    FGridName: string;
    FGrp: integer;
    FGrpOrder: integer;
    FPageID: integer;
    FPageOrderNum: integer;
    FScriptContainer: TScriptContainer;
    FShowPanel: boolean;
    FTotalFieldName, FTotalWorkFieldName, FTotalMatFieldName: string;
    procedure SetShowPanel(Val: boolean);
    function GetGridIDForCols: integer;
    procedure SetTotalWorkFieldName(_TotalField: string);
    procedure SetTotalFieldName(_TotalField: string);
    procedure SetTotalMatFieldName(_TotalField: string);
    function GetScripts: TStringList;
    function InternalGetShowPanel: boolean;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    procedure SetGridPropsFromDataSet(dqGrid: TDataSet; ProcessCfg: TPolyProcessCfg);
    procedure ReadGridFromDataSet(dqGrid: TDataSet);
    procedure ReadScriptsFromDataSet(dq: TDataSet);
    function GetScriptsCopyFromDataSet(dq: TDataSet): TStringList;
    function GetScript(const ScrField: string): TStringList;
    // TODO: нигде не вызывается!
    procedure SaveSettings(IniF: TJvCustomAppStorage);
    // TODO: нигде не вызывается!
    procedure LoadSettings(IniF: TJvCustomAppStorage);

    property GridID: integer read FGridID write FGridID;
    // GridIDForCols используется модулем sdm для отфильтровывания полей
    // при формировании SQL для этого сервиса. Если нет базового grida, то
    // это свойство = GridID. ЭТО НЕ ОЧЕНЬ ХОРОШЕЕ РЕШЕНИЕ, ЛУЧШЕ СДЕЛАТЬ,
    { TODO: ЧТОБЫ grid САМ ФОРМИРОВАЛ СПИСОК ПОЛЕЙ, ТАК ЖЕ, КАК ЭТО ДЕЛАЕТСЯ СО СКРИПТАМИ. }
    property GridIDForCols: integer read GetGridIDForCols;  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // Означает, что таблицу нельзя редактировать
    property EditableGrid: boolean read FEditableGrid;// write FEditableGrid;
    property EnableCalcTotalCost: boolean read FEnableCalcTotalCost;// write FEnableCalcTotalCost;
    property GridCaption: string read FGridCaption;
    property GridCols: TCollection read FGridCols;
    property GridName: string read FGridName;
    property Grp: integer read FGrp write FGrp;
    property GrpOrder: integer read FGrpOrder write FGrpOrder;
    property PageID: integer read FPageID;
    property PageOrderNum: integer read FPageOrderNum;// write FPageOrderNum;
    property Scripts: TStringList read GetScripts;
    property ShowControlPanel: boolean read InternalGetShowPanel write SetShowPanel;
    property AssignDrawCell: boolean read FAssignDrawCell write FAssignDrawCell;
    // Означает, что присваивается свой обработчик входа в таблицу
    property AssignGridEnter: boolean read FAssignGridEnter write FAssignGridEnter;
    property BaseGrid: TProcessGridCfg read FBaseGrid write FBaseGrid;
    property BaseGridID: integer read FBaseGridID write FBaseGridID;
    property TotalFieldName: string read FTotalFieldName write SetTotalFieldName;
    property TotalMatFieldName: string read FTotalMatFieldName write SetTotalMatFieldName;
    property TotalWorkFieldName: string read FTotalWorkFieldName write SetTotalWorkFieldName;
  end;

  function IsEmptyScript(s: TStringList): boolean;

  function NewScriptObj: TScript;

implementation

uses JvJCLUtils, RDBUtils, ExHandler, CalcSettings;

function IsEmptyScript(s: TStringList): boolean;
begin
  Result := (s = nil) or IsEmptyStr(s.Text, [' ', #13, #10, #9]);
end;

function NewScriptObj: TScript;
begin
  Result := TScript.Create;
end;

{ TScript }

constructor TScript.Create;
begin
  inherited Create;
  Script := TStringList.Create;
end;

destructor TScript.Destroy;
begin
  FreeAndNil(Script);
  inherited Destroy;
end;

{ TScriptContainer }

constructor TScriptContainer.Create;
begin
  inherited;
  FScripts := nil;
end;

destructor TScriptContainer.Destroy;
begin
  if Assigned(FScripts) then FreeAndNil(FScripts);
  inherited Destroy;
end;

procedure TScriptContainer.FreeScripts;
var i: integer;
begin
  if Assigned(FScripts) then begin
    if FScripts.Count > 0 then
      for i := 0 to FScripts.Count - 1 do
        FScripts.Objects[i].Free;
    FreeAndNil(FScripts);
  end;
end;

// Читает скрипты из базы и возвращает, НО НЕ МЕНЯЕТ СВОИ СКРИПТЫ
// используется CodeEditForm и ReadScriptsFromDataSet
function TScriptContainer.GetScriptsFromDataSet(dq: TDataSet): TStringList;
var
  i: integer;
  f: TField;
  NewS: TScript;
  _Scripts: TStringList;
begin
  _Scripts := TStringList.Create;
  // 28.09.2004 Новый способ: идем по всем мемополям и включаем их в список.
  // sdm не используется, но если понадобится, можно будет проверять наличие скрипта в ScriptInfo.
  if dq.Fields.Count > 0 then
    for i := 0 to Pred(dq.Fields.Count) do begin
      f := dq.Fields[i];
      if (f is TMemoField) {and not f.IsNull} then begin
        NewS := NewScriptObj;
        ReadStringListFromBlob(NewS.Script, f as TBlobField);   // только непустые
        _Scripts.AddObject(f.FieldName, NewS);
      end;
    end;
  Result := _Scripts;
end;

procedure TScriptContainer.ReadScriptsFromDataSet(dq: TDataSet);
begin
  FreeScripts; // уничтожаем, если что-то было
  FScripts := GetScriptsFromDataSet(dq);
end;

function TScriptContainer.ScriptByName(const ScrField: string): TStringList;
var
  i: integer;
begin
  if FScripts <> nil then
  begin
    i := FScripts.IndexOf(ScrField);
    if i <> -1 then
      Result := (FScripts.Objects[i] as TScript).Script
    else
      Result := nil;
  end else
    Result := nil;
end;

constructor TPolyProcessCfg.Create(_SrvID: integer);
begin
  inherited Create;
  FGrids := TCollection.Create(TProcessGridCfg);
  FSrvID := _SrvID;
  FAssignCalcFields := true;   // По умолчанию назначаются все обработчики
  FAssignNewRecord := true;
  FAssignDataChange := true;
  FScriptContainer := TScriptContainer.Create;
end;

destructor TPolyProcessCfg.Destroy;
begin
  FreeAndNil(FScriptContainer);
  FreeAndNil(FGrids);
  inherited;
end;

function TPolyProcessCfg.GetScriptsCopyFromDataSet(dq: TDataSet): TStringList;
var
  ScriptsCopy: TStringList;
  ScriptContainerCopy: TScriptContainer;
begin
  if FBaseSrv <> nil then Result := BaseSrv.GetScriptsCopyFromDataSet(dq)
  else begin
    ScriptContainerCopy := TScriptContainer.Create;
    ScriptContainerCopy.ReadScriptsFromDataSet(dq);
    ScriptsCopy := TStringList.Create;
    ScriptsCopy.Assign(ScriptContainerCopy.Scripts);
    ScriptContainerCopy.Free;
    Result := ScriptsCopy;
  end;
end;

// см. комментарий в interface
function TPolyProcessCfg.GetSrvIDForFields: integer;
begin
  if FBaseSrv = nil then Result := FSrvID
  else Result := FBaseSrv.SrvIDForFields;
end;

// Если есть базовый сервис, берем оттуда все скрипты.
function TPolyProcessCfg.GetScripts: TStringList;
begin
  if FBaseSrv <> nil then Result := BaseSrv.Scripts
  else Result := FScriptContainer.Scripts;
end;

function TPolyProcessCfg.GetScript(const ScrField: string): TStringList;
begin
  if FBaseSrv <> nil then Result := FBaseSrv.FScriptContainer.ScriptByName(ScrField)
  else Result := FScriptContainer.ScriptByName(ScrField);
end;

procedure TPolyProcessCfg.BeginReadFieldInfo;
begin
  FieldInfoData.Filtered := true;
  FieldInfoData.Filter := F_SrvID + ' = ' + IntToStr(SrvIDForFields);
  FieldInfoData.First;
end;

function TPolyProcessCfg.GetFieldInfo(FieldName: string): TDataSet;
begin
  BeginReadFieldInfo;
  if FieldInfoData.Locate('FieldName', FieldName, [loCaseInsensitive]) then
    Result := FieldInfoData
  else
    Result := nil;
end;

procedure TPolyProcessCfg.ReadScriptsFromDataSet(dq: TDataSet);
begin
  // Если есть базовый процесс, то все скрипты берутся оттуда!
  if FBaseSrvID <= 0 then
  begin
    // Модуль sdm к этому моменту уже должен быть создан!
    // Пытался избавиться от ссылок на sdm в этом модуле, но пока не вышло
    // FScriptContainer.ScriptNames := sdm.ScriptInfo;  14.10.2004
    FScriptContainer.ReadScriptsFromDataSet(dq);
  end;
  // Сбрасываем признак ивалидности
  FCalcFieldsScriptInvalid := false;
end;

procedure TPolyProcessCfg.SetPropsFromDataSet(sds: TDataSet);
begin
  //Name := SrvNamePrefix + sds['SrvName'];
  FTabName := sds['SrvName'];
  FSrvName := sds['SrvDesc'];
  FIsActive := sds['SrvActive'];
  FAssignCalcFields := sds['AssignCalcFields'];
  FAssignDataChange := sds['AssignDataChange'];
  FAssignNewRecord := sds['AssignNewRecord'];
  FAssignBeforeInsert := sds['AssignBeforeInsert'];
  FEnableBeforeScroll := sds['EnableBeforeScroll'];
  FEnableAfterScroll := sds['EnableAfterScroll'];
  FEnableAfterOpen := sds['EnableAfterOpen'];
  FEnableAfterOrderOpen := sds['EnableAfterOrderOpen'];
  FEnableBeforeDelete := sds['EnableBeforeDelete'];
  FOnlyWorkOrder := sds['OnlyWorkOrder'];
  FShowInReport := sds['ShowInReport'];
  FUseInProfitMode := sds['UseInProfitMode'];
  FHideItem := sds['HideItem'];
  FUseInTotal := sds['UseInTotal'];
  FIsContent := sds['IsContent'];
  FSrvID := sds[F_SrvID];
  FBaseSrvID := NvlInteger(sds[F_BaseSrvID]);
  FBaseSrv := nil;
  FDefaultEquipGroupCode := NvlInteger(sds[F_DefaultEquipGroupCode]);
  FPlanningEnabled := NvlBoolean(sds[F_EnablePlanning]);
  FTrackingEnabled := NvlBoolean(sds[F_EnableTracking]);
  FSequenceOrder := sds[F_SequenceOrder];
  FLinkedProcessID := NvlInteger(sds[F_LinkedProcessID]);
  FEnableLinking := sds[F_EnableLinking];
  FDefaultContractorProcess := sds[F_DefaultContractorProcess];
end;

{function TPolyProcessCfg.GetDefaultEquipGroupCode: integer;
begin
  Result := FDefaultEquipGroupCode;
end;}

procedure TPolyProcessCfg.ReadGridPropsFromDataSet(dqGrid, dqCols: TDataSet);
var
  i: integer;
  GridObj: TProcessGridCfg;
begin
  if FGrids <> nil then
    if FGrids.Count > 0 then
    begin
      for i := 0 to FGrids.Count - 1 do
      begin
        GridObj := FGrids.Items[i] as TProcessGridCfg;
        dqGrid.Filtered := false;
        if dqGrid.Locate(F_GridID, GridObj.GridID, []) then
        begin
          GridObj.SetGridPropsFromDataSet(dqGrid, Self);
          GridObj.ReadGridFromDataSet(dqCols);  // теперь и столбцы можно прочитать
        end else
          ExceptionHandler.Raise_('Не найдены параметры таблицы.');
      end;
    end;
end;

procedure TPolyProcessCfg.ReadGridScriptsFromDataSet(dq: TDataSet);
var
  i: integer;
  GridObj: TProcessGridCfg;
begin
  if FGrids <> nil then
    if FGrids.Count > 0 then begin
      for i := 0 to FGrids.Count - 1 do begin
        GridObj := FGrids.Items[i] as TProcessGridCfg;
        if dq.Locate(F_GridID, GridObj.GridIDForCols, []) then
          GridObj.ReadScriptsFromDataSet(dq);
      end;
    end;
end;

procedure TPolyProcessCfg.SaveSettings(AppStorage: TjvCustomAppStorage);
var i: integer;
begin
  if FGrids <> nil then
    if FGrids.Count > 0 then
      for i := 0 to FGrids.Count - 1 do
        (FGrids.Items[i] as TProcessGridCfg).SaveSettings(AppStorage);
end;

procedure TPolyProcessCfg.LoadSettings(AppStorage: TjvCustomAppStorage);
var i: integer;
begin
  if FGrids <> nil then
    if FGrids.Count > 0 then
      for i := 0 to FGrids.Count - 1 do
        (FGrids.Items[i] as TProcessGridCfg).LoadSettings(AppStorage);
end;

{$REGION 'TGridCol' }

procedure TGridCol.Assign(Source: TPersistent);
begin

end;

procedure TGridCol.AssignToColumn(Col: TColumnEh);
begin
  col.Alignment := Alignment;
  col.Color := Color;
  col.FieldName := FieldName;
  col.ReadOnly := ReadOnly;
  col.Font.Style := FontStyle;
  col.Font.Color := FontColor;
  col.Title.Caption := Caption;
  col.Title.Alignment := CaptionAlignment;
  col.Title.Color := CaptionColor;
  col.Title.Font.Color := CaptionFontColor;
  col.Title.Font.Style := CaptionFontStyle;
  col.Visible := Visible and
     (not IsPrice or AccessManager.CurKindPerm.PriceView)
     and (not IsCost or AccessManager.CurKindPerm.CostView);
  col.Width := Width;
  col.AlwaysShowEditButton := ShowEditButton;
end;

{$ENDREGION}

{$REGION 'TProcessGridCfg'}

constructor TProcessGridCfg.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FScriptContainer := TScriptContainer.Create;
end;

destructor TProcessGridCfg.Destroy;
begin
  FreeAndNil(FGridCols);
  FreeAndNil(FScriptContainer);
  inherited;
end;

procedure SaveGridCols(IniF: TJvCustomAppStorage; gc: TCollection; const KeyName: string);
var i: integer;
begin
  if (gc <> nil) and (gc.Count > 0) then
    for i := 0 to Pred(gc.Count) do
        IniF.WriteInteger(KeyName + 'ColWidth\Col' + IntToStr(i), (gc.Items[i] as TGridCol).Width);
end;

procedure LoadGridCols(IniF: TJvCustomAppStorage; gc: TCollection; const KeyName: string);
var
  i: integer;
  s: string;
begin
  if (gc <> nil) and (gc.Count > 0) then
    for i := 0 to Pred(gc.Count) do
      try
        s := 'ColWidth\Col' + IntToStr(i);
        //if IniF.ValueExists(SecName, s) then
          (gc.Items[i] as TGridCol).Width :=
            StrToInt(IniF.ReadString(KeyName + s, IntToStr((gc.Items[i] as TGridCol).Width)));
      except end;
end;

procedure TProcessGridCfg.SaveSettings(IniF: TJvCustomAppStorage);
begin
  if FGridName <> '' then
  begin
    if (FGridCols <> nil) then
      SaveGridCols(IniF, FGridCols, IniInterface + '\' + FGridName);
  end;
end;

procedure TProcessGridCfg.LoadSettings(IniF: TJvCustomAppStorage);
begin
  if FGridName <> '' then
  begin
    if (FGridCols <> nil) then
      LoadGridCols(IniF, FGridCols, IniInterface + '\' + FGridName);
  end;
end;

procedure TProcessGridCfg.SetShowPanel(Val: boolean);
begin
  if BaseGrid = nil then FShowPanel := Val;
end;

procedure TProcessGridCfg.SetGridPropsFromDataSet(dqGrid: TDataSet; ProcessCfg: TPolyProcessCfg);
begin
  FProcessCfg := ProcessCfg;
  FSrvID := ProcessCfg.SrvID;
  FGridCaption := dqGrid['GridCaption'];
  FGridName := dqGrid[F_GridName];
  FShowPanel := dqGrid['ShowControlPanel'];
  FAssignGridEnter := dqGrid['AssignGridEnter'];
  FAssignDrawCell := dqGrid['AssignDrawCell'];
  FEditableGrid := dqGrid['EditableGrid'];
  FPageOrderNum := dqGrid['PageOrderNum'];
  FPageID := dqGrid['ProcessPageID'];
  try FGridColor := dqGrid['GridColor']; except FGridColor := clBtnFace; end;
  FTotalFieldName := NvlString(dqGrid['TotalFieldName']);
  FTotalWorkFieldName := NvlString(dqGrid['TotalWorkFieldName']);
  FTotalMatFieldName := NvlString(dqGrid['TotalMatFieldName']);
  if VarIsNull(dqGrid[F_BaseGridID]) then FBaseGridID := 0
  else FBaseGridID := dqGrid[F_BaseGridID];
  FBaseGrid := nil;
  FEnableCalcTotalCost := dqGrid['EnableCalcTotalCost'];
end;

// см. комментарий в interface
function TProcessGridCfg.GetGridIDForCols: integer;
begin
  if FBaseGrid = nil then Result := FGridID
  else Result := FBaseGrid.GridIDForCols;
end;

// Установка ShowControlPanel берется из базового грида, если он есть
function TProcessGridCfg.InternalGetShowPanel: boolean;
begin
  if BaseGrid <> nil then Result := BaseGrid.InternalGetShowPanel
  else Result := FShowPanel;
end;

function TProcessGridCfg.GetScript(const ScrField: string): TStringList;
begin
  if FBaseGrid <> nil then Result := FBaseGrid.FScriptContainer.ScriptByName(ScrField)
  else Result := FScriptContainer.ScriptByName(ScrField);
end;

// Если есть базовый сервис, берем оттуда все скрипты.
function TProcessGridCfg.GetScripts: TStringList;
begin
  if FBaseGrid <> nil then Result := FBaseGrid.Scripts
  else Result := FScriptContainer.Scripts;
end;

function TProcessGridCfg.GetScriptsCopyFromDataSet(dq: TDataSet): TStringList;
var
  ScriptsCopy: TStringList;
  ScriptContainerCopy: TScriptContainer;
begin
  if FBaseGrid <> nil then Result := BaseGrid.GetScriptsCopyFromDataSet(dq)
  else begin
    ScriptContainerCopy := TScriptContainer.Create;
    ScriptContainerCopy.ReadScriptsFromDataSet(dq);
    ScriptsCopy := TStringList.Create;
    ScriptsCopy.Assign(ScriptContainerCopy.Scripts);
    ScriptContainerCopy.Free;
    Result := ScriptsCopy;
  end;
end;

procedure TProcessGridCfg.ReadGridFromDataSet(dqGrid: TDataSet);
var
  col: TGridCol;
  i: integer;
begin
  if FEditableGrid then
  begin
    dqGrid.Filtered := true;
    dqGrid.Filter := 'GridID = ' + IntToStr(GridIDForCols);
    dqGrid.First;
    if FGridCols <> nil then FreeAndNil(FGridCols);
    FGridCols := TCollection.Create(TGridCol);
    if dqGrid.RecordCount > 0 then
      for i := 0 to Pred(dqGrid.recordCount) do
      begin
        col := FGridCols.Add as TGridCol;
        if dqGrid.Locate('ColNumber', i, []) then begin
          try col.Alignment := dqGrid['Alignment']; except col.Alignment := taLeftJustify end;
          col.Color := NvlInteger(dqGrid['Color']);
          col.FieldName := NvlString(dqGrid['FieldName']);
          try col.ReadOnly := dqGrid['ReadOnly']; except col.ReadOnly := false; end;
          col.Caption := NvlString(dqGrid['Caption']);
          try col.CaptionAlignment := dqGrid['CaptionAlignment']; except col.CaptionAlignment := taLeftJustify end;
          col.CaptionColor := NvlInteger(dqGrid['CaptionColor']);
          col.FontColor := NvlInteger(dqGrid['FontColor']);
          try if dqGrid['FontBold'] then col.FontStyle := [fsBold]; except end;
          try if dqGrid['FontItalic'] then col.FontStyle := col.FontStyle + [fsItalic]; except end;
          col.CaptionFontColor := NvlInteger(dqGrid['CaptionFontColor']);
          try if dqGrid['CaptionFontBold'] then col.CaptionFontStyle := [fsBold]; except end;
          try if dqGrid['CaptionFontItalic'] then col.CaptionFontStyle := col.CaptionFontStyle + [fsItalic]; except end;
          try col.Visible := dqGrid['Visible']; except end;
          try col.IsPrice := dqGrid['PriceColumn']; except end;
          try col.IsCost := dqGrid['CostColumn']; except end;
          try col.ShowEditButton := dqGrid['ShowEditButton']; except end;
          if CompareText(col.FieldName, 'Enabled') = 0 then
            col.Width := 17
          else
            col.Width := 100;
        end;
      end;
  end;
end;

procedure TProcessGridCfg.ReadScriptsFromDataSet(dq: TDataSet);
begin
  // Если есть базовый процесс, то все скрипты берутся оттуда!
  if FBaseGridID <= 0 then begin
    // Модуль sdm к этому моменту уже должен быть создан!
    // Пытался избавиться от ссылок на sdm в этом модуле, но пока не вышло
    // FScriptContainer.ScriptNames := sdm.ScriptInfo;  14.10.2004
    FScriptContainer.ReadScriptsFromDataSet(dq);
  end;
end;

procedure TProcessGridCfg.SetTotalFieldName(_TotalField: string);
begin
  FTotalFieldName := _TotalField;
  //UpdateTotalControls;
end;

procedure TProcessGridCfg.SetTotalMatFieldName(_TotalField: string);
begin
  FTotalMatFieldName := _TotalField;
  //UpdateTotalControls;
end;

procedure TProcessGridCfg.SetTotalWorkFieldName(_TotalField: string);
begin
  FTotalWorkFieldName := _TotalField;
  //UpdateTotalControls;
end;

{$ENDREGION}

end.
