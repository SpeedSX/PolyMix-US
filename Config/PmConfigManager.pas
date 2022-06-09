unit PmConfigManager;

interface

uses Classes, Singleton, DB, DBClient,

  NotifyEvent, PmConfigTree, PmConfigObjects, PmProcessCfg, PmDictionaryList,
  PmProcessCfgData, StdDic;

type
  TProcessList = TStringList;

  TCfgForEachProc = procedure(Serv: TPolyProcessCfg) of object;
  TCfgForEachParamProc = procedure(Serv: TPolyProcessCfg; Param: pointer) of object;
  TCfgForEachFunc = function(Serv: TPolyProcessCfg): boolean of object;
  TCfgForEachParamFunc = function(Serv: TPolyProcessCfg; Param: pointer): boolean of object;
  TCfgForEachFuncNonObj = function(Serv: TPolyProcessCfg): boolean;

  TConfigManager = class(TSingleton)
  private
    FTree: TMVCTree;
    FProcessCfgChanged: TNotifier;
    FBeforeProcessCfgChange: TNotifier;
    FActiveProcessList: TStringList;
    FAllProcessList: TStringList;
    FDictionaryList: TDictionaryList;
    FDictionaryFolders: TDictionaryFolders;
    FProcessCfgData: TProcessCfgData;
    FProcessFieldData: TProcessFieldData;
    FProcessGridCfgData: TProcessGridCfgData;
    FProcessGridColData: TProcessGridColData;
    FStandardDics: TStandardDics;
    FProcessPageData: TProcessPageData;
    function GetTree: TMVCTree;
    procedure InitTree;
    procedure NotifyBeforeProcessCfgChange;
    procedure NotifyProcessCfgChanged;
    function EachUpdateScripts(Srv: TPolyProcessCfg): boolean;
    procedure FreeProcessList;
    function EachSetupSrv(Srv: TPolyProcessCfg): boolean;
    // Добавляет в список только планируемые процессы с указаннным кодом группы оборудования.
    // Если с любой группой, то надо код < 0.
    function EachCreatePlanList(Process: TPolyProcessCfg; Param: pointer): Boolean;
    procedure UpdateProcessCfg;
    procedure CreateGridsFromDataSet(Prc: TPolyProcessCfg);
    function EachSaveSettings(Prc: TPolyProcessCfg): boolean;
    function EachLoadSettings(Prc: TPolyProcessCfg): boolean;
    procedure CreateProcessNode(Serv: TPolyProcessCfg; Param: pointer);
    function ApplyProcessStructCreate(StructData: TClientDataSet;
      FNewProcessID: integer; FNewProcessName: string): boolean;
  public
    NeedRefreshServices: boolean;

    procedure RefreshProcessCfg;
    procedure DestroySingleton; override;
    procedure InitSingleton; override;

    // -- Процессы --

    // Возвращает список только планируемых процессов с указаннным кодом группы оборудования.
    // Если с любой группой, то надо код < 0.
    function GetPlanProcessList(EquipGroupCode: integer): TProcessList;
    // Возвращает список всех активных процессов
    function GetActiveProcessList: TProcessList;
    function GetAllProcessList: TProcessList;
    // выполняет действие для всех процессов
    procedure ForAllProcesses(ForEachProc: TCfgForEachProc); overload;
    procedure ForAllProcesses(ForEachProc: TCfgForEachParamProc; Param: pointer); overload;
    // выполняет действие для всех активных процессов
    procedure ForEachProcess(ForEachProc: TCfgForEachProc); overload;
    // выполняет действие для всех активных процессов, пока функция не вернет false
    function ForEachProcess(ForEachFunc: TCfgForEachFunc): boolean; overload;
    function ForEachProcess(ForEachParamFunc: TCfgForEachParamFunc; Param: pointer): boolean; overload;
    // ищет во всех процессах
    function ServiceByID(_SrvID: integer): TPolyProcessCfg;
    // ищет во всех процессах
    function ServiceByTabName(const TabName: string): TPolyProcessCfg;
    // ищет во всех процессах
    function GridByID(_GridID: integer): TProcessGridCfg;
    // Устанавливает содержимое полей со скриптами в соответствие базе данных
    procedure UpdateScripts;
    procedure InitProcessCfg;
    procedure LoadProcessSettings;
    procedure SaveProcessSettings;
    procedure ApplyProcessCfg;
    procedure ApplySrvGroupsPages(DoOpen: boolean);
    // Создает набор данных, описывающий структуру процесса
    function CreateSrvStructData(var StructData: TClientDataSet; SrvCfg: TPolyProcessCfg;
       UseOld, NewMode: boolean): boolean;
    // Модифицирует параметры и обновляет компоненты процесса
    procedure ModifySrvTable(SrvCfg: TPolyProcessCfg; StructData: TClientDataSet);
    // создает триггеры изменения полей для таблицы указанного процесса
    procedure CreateProcessTriggers(ProcessID: integer);
    function CreateProcessTable(StructData: TClientDataSet): integer;
    function CheckSrvName(const SrvName: string): boolean;
    function GetProcessScriptDesc(const FieldName: string): string;
    procedure GetDefaultPayStates(var StateNone, StatePartial, StateFull: integer);

    property ProcessCfgData: TProcessCfgData read FProcessCfgData;
    property ProcessFieldData: TProcessFieldData read FProcessFieldData;
    property ProcessGridCfgData: TProcessGridCfgData read FProcessGridCfgData;
    property ProcessGridColData: TProcessGridColData read FProcessGridColData;
    property ProcessPageData: TProcessPageData read FProcessPageData;

    // -- Справочники --

    procedure InitDictionaries;
    procedure SaveDicConfig;
    property DictionaryList: TDictionaryList read FDictionaryList;
    property StandardDics: TStandardDics read FStandardDics;
    property DictionaryFolders: TDictionaryFolders read FDictionaryFolders;

    procedure ReloadTree;

    property ProcessCfgChanged: TNotifier read FProcessCfgChanged;
    property BeforeProcessCfgChange: TNotifier read FBeforeProcessCfgChange;
    property Tree: TMVCTree read GetTree;
    class function Instance: TConfigManager;
  end;

implementation

uses Variants, SysUtils,

  PmDatabase, ExHandler, ServData, CalcSettings, DicObj, RDBUtils,
  PmAccessManager, DicData;


procedure TConfigManager.CreateProcessNode(Serv: TPolyProcessCfg; Param: pointer);
var
  CfgProcessNode: TCfgProcess;
  CfgGridNode: TCfgProcessGrid;
  Grid: TProcessGridCfg;
begin
  CfgProcessNode := TMVCNode(Param).CreateChild(TCfgProcess) as TCfgProcess;
  CfgProcessNode.Caption := Serv.ServiceName;
  CfgProcessNode.SubCaption := Serv.TableName;
  CfgProcessNode.ProcessID := Serv.SrvID;
  CfgProcessNode.IsActive := Serv.IsActive;

  // Таблицы для отображения процесса
  FProcessGridCfgData.SetProcessFilter(Serv.SrvID);
  try
    while not FProcessGridCfgData.DataSet.eof do
    begin
      Grid := GridByID(FProcessGridCfgData.KeyValue);

      CfgGridNode := CfgProcessNode.CreateChild(TCfgProcessGrid) as TCfgProcessGrid;
      CfgGridNode.Caption := Grid.GridCaption;
      CfgGridNode.SubCaption := Grid.GridName;
      CfgGridNode.GridID := Grid.GridID;

      FProcessGridCfgData.DataSet.Next;
    end;
  finally
    FProcessGridCfgData.ResetFilter;
  end;
end;

procedure BuildDicsFolder(FolderNode: TMVCNode; FolderID: integer);
var
  FDicNode: TMVCNode;
  DicList: TStringList;
  Dic: TDictionary;
  I: Integer;
begin
  DicList := TConfigManager.Instance.DictionaryList.GetAllDictionaries;
  for I := 0 to DicList.Count - 1 do
  begin
    Dic := DicList.Objects[I] as TDictionary;
    if (Dic.ParentID = FolderID) and not Dic.IsDimension then
    begin
      FDicNode := FolderNode.CreateChild(TCfgDictionary);
      FDicNode.Caption := Dic.Desc;
      FDicNode.SubCaption := Dic.Name;
      (FDicNode as TCfgDictionary).DicID := Dic.DicID;
    end;
  end;
end;

procedure BuildDicSubTree(DicFolders: TDictionaryFolders; ParentNode: TMVCNode; ParentID: integer);
var
  FFolderNode: TCfgDictionaryFolder;
  I: Integer;
begin
  DicFolders.SetParentIDFilter(ParentID);
  try
    while not DicFolders.DataSet.Eof do
    begin
      FFolderNode := ParentNode.CreateChild(TCfgDictionaryFolder) as TCfgDictionaryFolder;
      FFolderNode.Caption := DicFolders.FolderName;
      FFolderNode.SubCaption := '';
      FFolderNode.FolderID := DicFolders.KeyValue;

      DicFolders.DataSet.Next;
    end;
  finally
    DicFolders.ResetFilter;
  end;

  for I := 0 to ParentNode.ChildCount - 1 do
  begin
    FFolderNode := ParentNode.Child[I] as TCfgDictionaryFolder;
    BuildDicSubTree(DicFolders, FFolderNode, FFolderNode.FolderID);
  end;

  BuildDicsFolder(ParentNode, ParentID);

end;

procedure TConfigManager.InitTree;
var
  FProcessRoot, FDicRoot: TMVCNode;
  DicFolders: TDictionaryFolders;
begin
  FTree := TMVCTree.Create;

  // Виды заказов
  with FTree.Root.CreateChild(TCfgOrderKindRoot) do
  begin
    with CreateChild(TCfgOrderKind) do
    begin
    end;
  end;

  // Процессы
  FProcessRoot := FTree.Root.CreateChild(TCfgProcessRoot);
  ForAllProcesses(CreateProcessNode, FProcessRoot);

  // Справочники
  FDicRoot := FTree.Root.CreateChild(TCfgDictionaryRoot);
  DicFolders := TDictionaryFolders.Create;
  DicFolders.Open;
  try
    BuildDicSubTree(DicFolders, FDicRoot, 0);
  finally
    FreeAndNil(DicFolders);
  end;

  // Группы страниц
  with FTree.Root.CreateChild(TCfgOrderInterfaceRoot) do
  begin
    with CreateChild(TCfgOrderPageGroup) do
    begin
    end;
  end;

  // Пользователи
  with FTree.Root.CreateChild(TCfgAccessRoot) do
  begin
    with CreateChild(TCfgUser) do
    begin
    end;
  end;

  // Модули
  with FTree.Root.CreateChild(TCfgModuleRoot) do
  begin
    with CreateChild(TCfgModule) do
    begin
    end;
  end;

  // События
  with FTree.Root.CreateChild(TCfgEventRoot) do
  begin
    with CreateChild(TCfgEvent) do
    begin
    end;
  end;

  // Формы
  with FTree.Root.CreateChild(TCfgFormRoot) do
  begin
    with CreateChild(TCfgForm) do
    begin
    end;
  end;
end;

procedure TConfigManager.ReloadTree;
begin
  if Assigned(FTree) then
    FreeAndNil(FTree);

  InitTree;
end;

function TConfigManager.GetTree: TMVCTree;
begin
  if FTree = nil then InitTree;
  Result := FTree;
end;

class function TConfigManager.Instance: TConfigManager;
begin
  Result := TConfigManager.NewInstance as TConfigManager;
end;

procedure TConfigManager.RefreshProcessCfg;
begin
  SaveProcessSettings;
  NotifyBeforeProcessCfgChange;
  InitProcessCfg;
  NotifyProcessCfgChanged;  // ЭТО ОБЯЗАТЕЛЬНО! Сообщаем об изменении конфигурации
  LoadProcessSettings;
end;

procedure TConfigManager.NotifyProcessCfgChanged;
begin
  ProcessCfgChanged.Notify(Self);
end;

procedure TConfigManager.NotifyBeforeProcessCfgChange;
begin
  BeforeProcessCfgChange.Notify(Self);
end;

procedure TConfigManager.InitSingleton;
begin
  AfterConstruction;
  FBeforeProcessCfgChange := TNotifier.Create;
  FProcessCfgChanged := TNotifier.Create;
end;

procedure TConfigManager.DestroySingleton;
begin
  FBeforeProcessCfgChange.Free;
  FProcessCfgChanged.Free;
  FreeAndNil(FStandardDics);
  FreeAndNil(FDictionaryList);
  FreeAndNil(FDictionaryFolders);
  FreeAndNil(FProcessCfgData);
  FreeAndNil(FProcessFieldData);
  FreeAndNil(FProcessGridCfgData);
  FreeAndNil(FProcessGridColData);
  FreeAndNil(FProcessPageData);
end;

type
  PPlanProcessRec = ^TPlanProcessRec;
  TPlanProcessRec = record
    List: TStringList;
    EquipGroupCode: integer;
  end;

function TConfigManager.GetPlanProcessList(EquipGroupCode: integer): TProcessList;
var
  PlanProcessList: TProcessList;
  PlanRec: TPlanProcessRec;
begin
  PlanProcessList := TProcessList.Create;
  PlanRec.List := PlanProcessList;
  PlanRec.EquipGroupCode := EquipGroupCode;
  ForEachProcess(EachCreatePlanList, @PlanRec);
  Result := PlanProcessList;
end;

// Добавляет в список только планируемые процессы с указаннным кодом группы оборудования.
// Если с любой группой, то надо код < 0.
function TConfigManager.EachCreatePlanList(Process: TPolyProcessCfg; Param: pointer): Boolean;
var
  Code: integer;
begin
  Code := PPlanProcessRec(Param)^.EquipGroupCode;
  if Process.PlanningEnabled and ((Code <= 0) or (Code = Process.DefaultEquipGroupCode)) then
    PPlanProcessRec(Param)^.List.AddObject(Process.ServiceName, Process);
  Result := true;
end;

function TConfigManager.GetActiveProcessList: TProcessList;
begin
  Result := FActiveProcessList;
end;

function TConfigManager.GetAllProcessList: TProcessList;
begin
  Result := FAllProcessList;
end;

procedure TConfigManager.ForEachProcess(ForEachProc: TCfgForEachProc);
var
  i: integer;
begin
  for i := 0 to Pred(FActiveProcessList.Count) do
    ForEachProc(TPolyProcessCfg(FActiveProcessList.Objects[i]));
end;

procedure TConfigManager.ForAllProcesses(ForEachProc: TCfgForEachProc);
var
  i: integer;
begin
  for i := 0 to Pred(FAllProcessList.Count) do
    ForEachProc(TPolyProcessCfg(FAllProcessList.Objects[i]));
end;

procedure TConfigManager.ForAllProcesses(ForEachProc: TCfgForEachParamProc; Param: pointer);
var
  i: integer;
begin
  for i := 0 to Pred(FAllProcessList.Count) do
    ForEachProc(TPolyProcessCfg(FAllProcessList.Objects[i]), Param);
end;

function TConfigManager.ForEachProcess(ForEachFunc: TCfgForEachFunc): boolean;
var
  i: integer;
begin                                        
  Result := true;
  for i := 0 to Pred(FActiveProcessList.Count) do
    if not ForEachFunc(TPolyProcessCfg(FActiveProcessList.Objects[i])) then
    begin
      Result := false;
      Exit;
    end;
end;

function TConfigManager.ForEachProcess(ForEachParamFunc: TCfgForEachParamFunc; Param: pointer): boolean;
var i: integer;
begin
  Result := true;
  for i := 0 to Pred(FActiveProcessList.Count) do
    if not ForEachParamFunc(FActiveProcessList.Objects[i] as TPolyProcessCfg, Param) then
    begin
      Result := false;
      Exit;
    end;
end;

function TConfigManager.ServiceByID(_SrvID: integer): TPolyProcessCfg;
var i: integer;
begin
  Result := nil;
  for i := 0 to Pred(FAllProcessList.Count) do
    if (FAllProcessList.Objects[i] as TPolyProcessCfg).SrvID = _SrvID then
    begin
      Result := FAllProcessList.Objects[i] as TPolyProcessCfg;
      Exit;
    end;
end;

// Устанавливает содержимое полей со скриптами в соответствие базе данных
procedure TConfigManager.UpdateScripts;
begin
  sdm.cdProcessGrids.Filtered := true;
  ForEachProcess(EachUpdateScripts);
  sdm.cdProcessGrids.Filtered := false;
end;

// Устанавливает содержимое полей со скриптами в соответствие базе данных
function TConfigManager.EachUpdateScripts(Srv: TPolyProcessCfg): boolean;
begin
  Result := true;
  if not sdm.cdServices.Locate(F_SrvID, Srv.SrvID, []) then Exit;
  Srv.ReadScriptsFromDataSet(sdm.cdServices);
  sdm.cdProcessGrids.Filter := ProcessKeyField + ' = ' + IntToStr(Srv.SrvID);
  Srv.ReadGridScriptsFromDataSet(sdm.cdProcessGrids);
end;

function TConfigManager.ServiceByTabName(const TabName: string): TPolyProcessCfg;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Pred(FAllProcessList.Count) do
    if (AnsiCompareText((FAllProcessList.Objects[i] as TPolyProcessCfg).TableName, TabName) = 0) then
    begin
      Result := FAllProcessList.Objects[i] as TPolyProcessCfg;
      Exit;
    end;
end;

function TConfigManager.GridByID(_GridID: integer): TProcessGridCfg;
var
  i, j: integer;
  Srv: TPolyProcessCfg;
  go: TProcessGridCfg;
begin
  Result := nil;
  for i := 0 to Pred(FAllProcessList.Count) do
  begin
    Srv := FAllProcessList.Objects[i] as TPolyProcessCfg;
    if (Srv.Grids <> nil) and (Srv.Grids.Count > 0) then
      for j := 0 to Pred(Srv.Grids.Count) do
      begin
        go := TProcessGridCfg(Srv.Grids.Items[j]);
        if go.GridID = _GridID then
        begin
          Result := go;
          Exit;
        end;
      end;
  end;
end;

function TConfigManager.EachSetupSrv(Srv: TPolyProcessCfg): boolean;
var
  BSrv: TPolyProcessCfg;
begin
  Result := true;
  if Srv.BaseSrvID > 0 then begin
    BSrv := ServiceByID(Srv.BaseSrvID);
    if BSrv <> nil then
      Srv.BaseSrv := BSrv;
  end;
  Srv.ReadGridPropsFromDataSet(sdm.cdProcessGrids, sdm.cdSrvGridCols);
  EachUpdateScripts(Srv);
end;

procedure TConfigManager.UpdateProcessCfg;
begin
  ForEachProcess(EachSetupSrv);
end;

procedure TConfigManager.InitProcessCfg;
var
  srv: TPolyProcessCfg;
begin
  if not Assigned(FProcessCfgData) then
    FProcessCfgData := TProcessCfgData.Create;
  FProcessCfgData.Reload;
  if not Assigned(FProcessFieldData) then
    FProcessFieldData := TProcessFieldData.Create;
  FProcessFieldData.Reload;

  if not Assigned(FProcessGridCfgData) then
    FProcessGridCfgData := TProcessGridCfgData.Create;
  FProcessGridCfgData.Reload;
  if not Assigned(FProcessGridColData) then
    FProcessGridColData := TProcessGridColData.Create;
  FProcessGridColData.Reload;

  if not Assigned(FProcessPageData) then
    FProcessPageData := TProcessPageData.Create;
  FProcessPageData.Reload;

  FreeProcessList;
  FActiveProcessList := TProcessList.Create;
  FAllProcessList := TProcessList.Create;
  // СОЗДАЮТСЯ ОБЪЕКТЫ ПРОЦЕССОВ
  FProcessCfgData.DataSet.First;
  while not FProcessCfgData.DataSet.eof do
  try
    if FProcessCfgData.ProcessKind = cskSimple then
      Srv := TPolyProcessCfg.Create(FProcessCfgData.KeyValue)
    else if FProcessCfgData.ProcessKind = cskTable then
      Srv := TPolyProcessCfg.Create(FProcessCfgData.KeyValue)
    else begin
      ExceptionHandler.Raise_('Тип процесса "' + FProcessCfgData.KeyValue.ProcessDescription +
        '" (' + VarToStr(FProcessCfgData.ProcessKind) +
        ') не поддерживается в данной версии');
      continue;
    end;
    // Установка свойств конфигураций процессов
    Srv.SetPropsFromDataSet(FProcessCfgData.DataSet);
    // Создание конфигураций визуальных таблиц для процессов
    CreateGridsFromDataSet(Srv);
    // Создаются наборы данных для процессов, которые являются их владельцами
    Srv.FieldInfoData := FProcessFieldData.DataSet;
    if FProcessCfgData.IsActive then
    begin
      // Заносим в список активных процессов
      FActiveProcessList.AddObject(Srv.ServiceName, Srv);
    end;
    FAllProcessList.AddObject(Srv.ServiceName, Srv);
  finally
    FProcessCfgData.DataSet.Next;
  end;
  UpdateProcessCfg;
end;

procedure TConfigManager.FreeProcessList;
var
  I: Integer;
begin
  if FAllProcessList <> nil then
  begin
    for I := 0 to FAllProcessList.Count - 1 do
      TObject(FAllProcessList.Objects[I]).Free;
    FreeAndNil(FAllProcessList);
    FreeAndNil(FActiveProcessList);
  end;
end;

procedure TConfigManager.CreateGridsFromDataSet(Prc: TPolyProcessCfg);
var
  Cfg: TProcessGridCfg;
  dqGrid: TDataSet;
begin
  dqGrid := FProcessGridCfgData.DataSet;
  dqGrid.Filter := ProcessKeyField + ' = ' + IntToStr(Prc.SrvID);
  dqGrid.Filtered := true;
  dqGrid.First;
  while not dqGrid.eof do
  try
    Cfg := Prc.Grids.Add as TProcessGridCfg;
    Cfg.GridID := dqGrid[F_GridID];
  finally
    dqGrid.Next;
  end;
end;

function TConfigManager.EachSaveSettings(Prc: TPolyProcessCfg): boolean;
begin
  Result := true;
  Prc.SaveSettings(TSettingsManager.Instance.Storage);
end;

function TConfigManager.EachLoadSettings(Prc: TPolyProcessCfg): boolean;
begin
  Result := true;
  Prc.LoadSettings(TSettingsManager.Instance.Storage);
end;

procedure TConfigManager.LoadProcessSettings;
begin
  ForEachProcess(EachLoadSettings);
end;

procedure TConfigManager.SaveProcessSettings;
begin
  if Assigned(FActiveProcessList) then
    ForEachProcess(EachSaveSettings);
end;

procedure TConfigManager.ApplyProcessCfg;
begin
  FProcessCfgData.ApplyUpdates;
  FProcessGridCfgData.ApplyUpdates;
  FProcessPageData.ApplyUpdates;
  FProcessGridColData.ApplyUpdates;
  sdm.ApplyProcessCfg;
end;

// Внимание! Вызывает обновление компонент процессов
// и страниц только при DoOpen=true! (false сейчас не используется) 02.05.2004
procedure TConfigManager.ApplySrvGroupsPages(DoOpen: boolean);
var
  {k1, }k2, {k3, k4, }k5, k6: integer;
begin
  //try
    if sdm.cdSrvGrps.State in [dsEdit, dsInsert] then sdm.cdSrvGrps.Post;
    //if sdm.cdSrvPages.State in [dsEdit, dsInsert] then sdm.cdSrvPages.Post;
    //k1 := NvlInteger(sdm.cdServices[F_SrvID]);
    //k4 := NvlInteger(sdm.cdProcessGrids[GridKeyField]);
    k2 := NvlInteger(sdm.cdSrvGrps['GrpID']);
    //k3 := NvlInteger(sdm.cdSrvPages['SrvPageID']);
    k5 := NvlInteger(sdm.cdOrderKind['KindID']);
    k6 := NvlInteger(sdm.cdKindProcess['KindProcessID']);
    //if FProcessCfgData.DataSet.State in [dsEdit, dsInsert] then FProcessCfgData.DataSetPost;
    //if FProcessCfgGridData.DataSet.State in [dsEdit, dsInsert] then FProcessCfgGridData.Post;
    if sdm.cdOrderKind.State in [dsEdit, dsInsert] then sdm.cdOrderKind.Post;
    if sdm.cdKindProcess.State in [dsEdit, dsInsert] then sdm.cdKindProcess.Post;
    if sdm.cdPageGrids.Active and (sdm.cdPageGrids.State in [dsEdit, dsInsert]) then
      sdm.cdPageGrids.Post;
    NeedRefreshServices := NeedRefreshServices or (FProcessCfgData.Modified)
      or (sdm.cdSrvGrps.ChangeCount > 0) or (FProcessPageData.Modified)
      or (sdm.cdPageGrids.ChangeCount > 0) or (FProcessGridCfgData.Modified)
      or (sdm.cdOrderKind.ChangeCount > 0) or (sdm.cdKindProcess.ChangeCount > 0);
    ApplyProcessCfg;
    sdm.CloseSrvGroups;
    //sdm.CloseSrvPages;
    sdm.ClosePageGrids;
    //sdm.CloseProcessGrids;
    sdm.CloseOrderKind;
    sdm.CloseKindProcess;
    if DoOpen then begin
      sdm.RefreshSrvGroups;
      //sdm.RefreshSrvPages;
      sdm.RefreshPageGrids;
      //sdm.RefreshProcessGrids;
      //FProcessGridCfgData.Reload;
      sdm.RefreshOrderKind;
      sdm.RefreshKindProcess;
      if NeedRefreshServices then
      begin
        TConfigManager.Instance.RefreshProcessCfg;
        //RefreshUsers;
      end;
      NeedRefreshServices := false;
      //sdm.cdServices.Locate(F_SrvID, k1, []);
      //sdm.cdProcessGrids.Locate(GridKeyField, k4, []);
      sdm.cdSrvGrps.Locate('GrpID', k2, []);
      //sdm.cdSrvPages.Locate('SrvPageID', k3, []);
      sdm.cdOrderKind.Locate('KindID', k5, []);
      sdm.cdKindProcess.Locate('KindProcessID', k6, []);
    end;
  //except on E: Exception do
  //end;
end;

// Создает набор данных, описывающий структуру процесса
function TConfigManager.CreateSrvStructData(var StructData: TClientDataSet; SrvCfg: TPolyProcessCfg;
   UseOld, NewMode: boolean): boolean;
begin
  Result := sdm.CreateSrvStructData(StructData, SrvCfg, UseOld, NewMode);
end;

procedure TConfigManager.InitDictionaries;
begin
  if FDictionaryList = nil then
    FDictionaryList := TDictionaryList.Create;
  if FDictionaryFolders = nil then
    FDictionaryFolders := TDictionaryFolders.Create;
  if FStandardDics = nil then
    FStandardDics := TStandardDics.Create;

  FDictionaryList.Reload;
  FDictionaryList.CreateDictionaries;
  FDictionaryFolders.Reload;
end;

procedure TConfigManager.SaveDicConfig;
begin
  DictionaryFolders.ApplyUpdates;
  DictionaryList.ApplyUpdates;
  DictionaryList.ApplyAll;
end;

// Модифицирует параметры и обновляет компоненты процесса
procedure TConfigManager.ModifySrvTable(SrvCfg: TPolyProcessCfg; StructData: TClientDataSet);
begin
  sdm.ModifySrvTable(SrvCfg, StructData);
end;

// создает триггеры изменения полей для таблицы указанного процесса
procedure TConfigManager.CreateProcessTriggers(ProcessID: integer);
begin
  sdm.CreateProcessTriggers(ProcessID);
end;

{function TConfigManager.CreateProcessTable(StructData: TClientDataSet): integer;
begin
  Result := sdm.CreateProcessTable(StructData);
end;}

function TConfigManager.ApplyProcessStructCreate(StructData: TClientDataSet;
  FNewProcessID: integer; FNewProcessName: string): boolean;
begin
  Result := DicDm.CommonApplyStructCreate(SrvTablePrefix + FNewProcessName, SrvFieldsTableName,
    F_SrvID, SrvStructPropFields, FNewProcessID, StructData,
    true); // предопределенные поля тоже пишутся в таблицу описания полей!
end;

function TConfigManager.CreateProcessTable(StructData: TClientDataSet): integer;

  procedure Alert(E: Exception);
  begin
    if Database.InTransaction then Database.RollbackTrans;
    ExceptionHandler.Raise_(E, 'Ошибка при создании процесса', 'CreateProcessTable');
  end;

var
  FNewProcessID: integer;
begin
  Result := -1;
  if not Database.InTransaction then Database.BeginTrans;
  try
    if FProcessCfgData.ApplyUpdates then
    begin
      FNewProcessID := FProcessCfgData.NewItemID;
      if not FProcessCfgData.Locate(FNewProcessID) then
        raise Exception.Create('Не найден последний добавленный процесс');
      if ApplyProcessStructCreate(StructData, FNewProcessID, FProcessCfgData.ProcessName) then
      begin
        Database.CommitTrans;
        Result := FNewProcessID;
        // сразу присваиваем права на эту таблицу
        if not Database.InTransaction then
        begin
          AccessManager.SetUserRights;
          CreateProcessTriggers(FNewProcessID);
        end;
      end;
    end;
  except on E: Exception do
    Alert(E);
  end;
end;

function TConfigManager.CheckSrvName(const SrvName: string): boolean;
begin
  Result := sdm.CheckSrvName(SrvName);
end;

function TConfigManager.GetProcessScriptDesc(const FieldName: string): string;
begin
  Result := sdm.GetScriptDesc(FieldName);
end;

procedure TConfigManager.GetDefaultPayStates(var StateNone, StatePartial, StateFull: integer);
var
  de: TDictionary;
begin
  // коды состояний берем из вида "по умолчанию" в видах оплаты
  de := StandardDics.dePayKind;
  de.DicItems.Filter := 'Visible and A1';
  de.DicItems.Filtered := true;
  try
    StateNone := de.CurrentValue[4];
    StatePartial := de.CurrentValue[5];
    StateFull := de.CurrentValue[6];
  finally
    de.DicItems.Filtered := false;
  end;
end;

end.
