unit PmConfigEditors;

interface

uses Classes,

  PmConfigTree, PmConfigObjects, PmBaseConfigEditorFrame, PmProcessCfg;

type
  TBaseConfigEditor = class
  private
    FNode: TMVCNode;
    FFrame: TBaseConfigEditorFrame;
    FOnReloadTree: TNotifyEvent;
    procedure SetNode(aNode: TMVCNode); virtual;
  protected
    procedure ReloadTree;
  public
    constructor Create(ANode: TMVCNode);
    property Node: TMVCNode read FNode write SetNode;
    property Frame: TBaseConfigEditorFrame read FFrame write FFrame;
    property OnReloadTree: TNotifyEvent read FOnReloadTree write FOnReloadTree;
  end;

  TDictionaryEditor = class(TBaseConfigEditor)
  private
    procedure SetNode(aNode: TMVCNode); override;
  public
    procedure EditProperties(Sender: TObject);
    procedure DeleteDictionary(Sender: TObject);
  end;

  TDictionaryFolderEditor = class(TBaseConfigEditor)
  private
    procedure SetNode(aNode: TMVCNode); override;
  public
    procedure EditProperties(Sender: TObject);
    procedure NewDictionary(Sender: TObject);
    procedure DeleteFolder(Sender: TObject);
    procedure NewFolder(Sender: TObject);
  end;

  TScriptedObjectEditor = class(TBaseConfigEditor)
  public
    function CodeEditGetCaption(Sender: TObject): string; virtual; abstract;
    function CodeEditGetScripts(Sender: TObject): TStringList; virtual; abstract;
    function CodeEditGetScriptDesc(Sender: TObject; ScriptName: string): string; virtual; abstract;
    procedure CodeEditWriteScripts(Sender: TObject; Scripts: TStringList); virtual; abstract;
  end;

  TProcessEditor = class(TScriptedObjectEditor)
  private
    procedure SetNode(aNode: TMVCNode); override;
    constructor Create(ANode: TMVCNode);
    function GetProcessCfg: TPolyProcessCfg; // используется при редактированиии скриптов
  public
    function CodeEditGetScriptDesc(Sender: TObject; ScriptName: string): string; override;
    function CodeEditGetCaption(Sender: TObject): string; override;
    function CodeEditGetScripts(Sender: TObject): TStringList; override;
    procedure CodeEditWriteScripts(Sender: TObject; Scripts: TStringList); override;

    procedure DeleteProcess(Sender: TObject);
    procedure ExportProcess(Sender: TObject);
    procedure ModifyStructure(Sender: TObject);
    procedure EditCode(Sender: TObject);
    procedure EditProperties(Sender: TObject);
    procedure CreateTriggers(Sender: TObject);
    procedure AddGrid(Sender: TObject);
  end;

  TProcessRootEditor = class(TBaseConfigEditor)
  private
    procedure CreateProcessTrigger(Prc: TPolyProcessCfg);
  public
    procedure AddProcess(Sender: TObject);
    procedure ExportScripts(Sender: TObject);
    procedure ImportScripts(Sender: TObject);
    procedure CreateAllTriggers(Sender: TObject);
  end;

  TProcessGridEditor = class(TScriptedObjectEditor)
  private
    function GetGridCfg: TProcessGridCfg; // используется при редактированиии скриптов
  public
    function CodeEditGetScriptDesc(Sender: TObject; ScriptName: string): string; override;
    function CodeEditGetCaption(Sender: TObject): string; override;
    function CodeEditGetScripts(Sender: TObject): TStringList; override;
    procedure CodeEditWriteScripts(Sender: TObject; Scripts: TStringList); override;

    procedure DeleteGrid(Sender: TObject);
    procedure EditGridProperties(Sender: TObject);
    procedure EditGridCode(Sender: TObject);
    procedure EditGridCols(Sender: TObject);
  end;

  TUserEditor = class(TBaseConfigEditor)

  end;

implementation

uses DB, DBClient, Dialogs, Controls, SysUtils, Variants,

  PmConfigManager, PmAccessManager, NSrvFrm, DicStFrm,
  DataHlp, PmDictionaryList, CodeEdit, CalcSettings, RDBUtils, RDialogs,
  GridProp, DicObj, ExHandler, NDicFrm, PmScriptExchange, EGridFrm,
  PmProcessCfgData;

function AskFolderName(folderName: string): string;
begin
  folderName := InputBox('Имя папки', 'Введите имя папки', folderName);
  Result := folderName;
end;

{$REGION 'TBaseConfigEditor'}

constructor TBaseConfigEditor.Create(ANode: TMVCNode);
begin
  Node := ANode;
end;

procedure TBaseConfigEditor.SetNode(aNode: TMVCNode);
begin
  FNode := aNode;
end;

procedure TBaseConfigEditor.ReloadTree;
begin
  FOnReloadTree(Self);
end;

{$ENDREGION}

{$REGION 'TDictionaryEditor'}

procedure TDictionaryEditor.SetNode(aNode: TMVCNode);
begin
  inherited SetNode(aNode);
  if (aNode <> nil) then
  begin
    //EmptyTabDic.Visible := false;
    {DictionaryTree.DataSet.Locate('DicID;DicName', VarArrayOf([RecordId,dicName]), []);
    if (isFound) then
      DictionaryList.Locate(RecordId);}
  end;
end;

procedure TDictionaryEditor.EditProperties(Sender: TObject);
var
  Ok: boolean;
  NewDicName, NewDicDesc: string;
  ID{, isFolder}: integer;
  StructData: TClientDataSet;
  MultiDim: boolean;
  de: TDictionary;
  DicList: TDictionaryList;
  //nodeData: PNodeData;
begin
  TConfigManager.Instance.SaveDicConfig;

  DicList := TConfigManager.Instance.DictionaryList;
  de := DicList.FindID((Node as TCfgDictionary).DicID);
  //DicList.ApplyDic(de);
  Ok := false;
  StructData := nil;
  NewDicName := de.Name;
  NewDicDesc := de.Desc;
  MultiDim := de.MultiDim;
  if MultiDim then
    ExceptionHandler.Raise_('Пока нельзя редактировать многомерные справочники...');
  try
    repeat
      Ok := ExecNewDic(NewDicName, NewDicDesc, MultiDim, StructData, de);
      if Ok then
      begin
        ID := de.DicID;
        Ok := DicList.CheckDicName(NewDicName, id);
        if Ok then
        begin
          DicList.ApplyUpdates;
          DicList.ModifyDicTable(ID, NewDicName, NewDicDesc, MultiDim, StructData, de);
          ReloadTree;
          Ok := true;
        end;
      end
      else
        Ok := true;
    until Ok;
  finally
    if StructData <> nil then StructData.Close;
  end;
end;

procedure TDictionaryEditor.DeleteDictionary(Sender: TObject);
var
  Dic: TDictionary;
begin
  TConfigManager.Instance.SaveDicConfig;

  Dic := TConfigManager.Instance.DictionaryList.FindID((Node as TCfgDictionary).DicID);
  if Dic.BuiltIn or Dic.ReadOnly then
    ExceptionHandler.Raise_('Справочник встроен или только для чтения. Удаление невозможно.');

  if RusMessageDlg('Вы действительно желаете удалить справочник "' +
     Node.Caption + '"?', mtConfirmation, mbYesNoCancel, 0) = mrYes then
  begin
    TConfigManager.Instance.DictionaryList.DeleteDictionary((Node as TCfgDictionary).DicID);
    //DictionaryList.ApplyUpdates;
    TConfigManager.Instance.DictionaryList.Reload;
    //DicDm.RefreshDics;
    ReloadTree;
  end;
end;

{$ENDREGION}

{$REGION 'TDictionaryFolderEditor'}

procedure TDictionaryFolderEditor.SetNode(aNode: TMVCNode);
begin
  inherited SetNode(aNode);
  if (aNode <> nil) then
  begin
  end;
end;

procedure TDictionaryFolderEditor.EditProperties(Sender: TObject);
var
  folderName, defFolderName: string;
  FDictionaryFolders: TDictionaryFolders;
begin
  TConfigManager.Instance.SaveDicConfig;

  folderName := Node.Caption;
  defFolderName := folderName;

  folderName := AskFolderName(folderName);

  if defFolderName <> folderName then
  begin
    {FDictionaryFolders := TDictionaryFolders.Create;
    try
      FDictionaryFolders.Open;}
      FDictionaryFolders := TConfigManager.Instance.DictionaryFolders;
      if FDictionaryFolders.Locate((Node as TCfgDictionaryFolder).FolderId) then
      begin
        FDictionaryFolders.FolderName := FolderName;
        FDictionaryFolders.ApplyUpdates;
        //FDictionaryFolders.Reload;
        if folderName <> '' then
          Node.Caption := folderName;
      end;
    //finally
    //  FDictionaryFolders.Free;
    //end;
  end;
end;

procedure TDictionaryFolderEditor.NewDictionary(Sender: TObject);
var
  Ok, createdSuccessful: boolean;
  NewDicName, NewDicDesc: string;
  R, ParentID{, ID, isFolder}: integer;
  StructData: TClientDataSet;
  MultiDim: boolean;
  NewDic: TDictionary;
  DictionaryList: TDictionaryList;
  //node, expandedNode: PVirtualNode;
  //nodeData: PNodeData;
begin
  TConfigManager.Instance.SaveDicConfig;

  Ok := false;
  NewDicName := '';
  NewDicDesc := '';
  MultiDim := false;
  StructData := nil;

  createdSuccessful := false;
  DictionaryList := TConfigManager.Instance.DictionaryList;
  //expandedNode := nil;

  try
    repeat
      Ok := ExecNewDic(NewDicName, NewDicDesc, MultiDim, StructData, nil);
      if Ok then
      begin
        if MultiDim then
          ExceptionHandler.Raise_('Пока нельзя создавать многомерные справочники...');

        if DictionaryList.CheckDicName(NewDicName, -1) then
        begin
          DictionaryList.ApplyUpdates;

          //parentID := 0;
          //node := DicElemsTreeView.FocusedNode;
          //if Node <> nil then
          //begin
            //isFolder := Folder(node);
            //if (isFolder <> -1) and (isFolder = 1) then
            //begin
              //nodeData := DicElemsTreeView.GetNodeData(node);
              //parentID := nodeData.RecordId;
            //  expandedNode := node;
            //end;
          //end;
          if Node is TCfgDictionaryRoot then
            ParentID := 0
          else
            ParentID := (Node as TCfgDictionaryFolder).FolderID;

          NewDic := DictionaryList.CreateNewDictionary(NewDicName, NewDicDesc, MultiDim,
            ParentID, StructData);

          Ok := NewDic.DicID > 0;
          if Ok then
          begin
            //DictionaryList.Locate(ID);
            createdSuccessful := true;
          end;
        end;
      end
      else
        Ok := true;
    until Ok;

    if createdSuccessful then
    begin
      //SetExpandedNode(Node, true);      // TODO !!!!!!!!!!!!!
      //DicDm.RefreshDics;
      ReloadTree;
      //SetFocusedNode(Id, NewDicName);   // TODO !!!!!!!!!!!!!!
    end;
  finally
    if StructData <> nil then StructData.Close;
  end;
end;

procedure TDictionaryFolderEditor.NewFolder(Sender: TObject);
var
  //folderId: integer;
  //nodeData: PNodeData;
  //node, expandedNode: PVirtualNode;
  {dicName, }folderName: string;
  parentId: integer;
  DictionaryFolders: TDictionaryFolders;
begin
  TConfigManager.Instance.SaveDicConfig;

  parentId := 0;
  //expandedNode := nil;
  if Node <> nil then
  begin
    if Node is TCfgDictionaryRoot then
      parentId := 0
    else
      parentId := (Node as TCfgDictionaryFolder).FolderId;
  end;

  folderName := 'Новая папка';
  folderName := AskFolderName(folderName);
  folderName := Trim(folderName);

  if folderName <> '' then
  begin
    //DictionaryFolders := TDictionaryFolders.Create;
    DictionaryFolders := TConfigManager.Instance.DictionaryFolders;
    //try
      //DictionaryFolders.Open;
      DictionaryFolders.DataSet.Insert;
      DictionaryFolders.FolderName := folderName;
      DictionaryFolders.ParentID := parentId;
      DictionaryFolders.DataSet.Post;
      DictionaryFolders.ApplyUpdates;
    {finally
      FreeAndNil(DictionaryFolders);
    end;}

    {if expandedNode <> nil then
       DicElemsTreeView.Expanded[expandedNode] := true;

    SetFocusedNode(folderId, '');}
    //DicDm.RefreshDics;
    ReloadTree;
  end
  else
    ExceptionHandler.Raise_('Не указано наименование папки.');
end;

procedure TDictionaryFolderEditor.DeleteFolder(Sender: TObject);
var
  DicID, NewParentID: integer;
  //childrenNode: PVirtualNode;
  //nodeData: PNodeData;
  //dicName: string;
  DictionaryFolders: TDictionaryFolders;
  ChildNode: TMVCNode;
  I: Integer;
begin
  if Node <> nil then
  begin
    TConfigManager.Instance.SaveDicConfig;

    DicID := (Node as TCfgDictionaryFolder).FolderID;
    DictionaryFolders := TConfigManager.Instance.DictionaryFolders;
    //DictionaryFolders := TDictionaryFolders.Create;
    //try
      //DictionaryFolders.Open;
      if (Node.ChildCount = 0)
       or (RusMessageDlg('Вы действительно желаете удалить папку "' + Node.Caption + '"?' + #13
           + 'Ее содержимое будет перенесено в папку верхнего уровня.',
           mtConfirmation, mbYesNoCancel, 0) = mrYes) then
      begin
        for I := 0 to Node.ChildCount - 1 do
        begin
          ChildNode := Node.Child[I];
          //Node.MoveChild(ChildNode, Node.Parent);  TODO: Не перемещаем пока
          if Node.Parent is TCfgDictionaryFolder then
            NewParentID := (Node.Parent as TCfgDictionaryFolder).FolderID
          else
            NewParentID := 0;

          if ChildNode is TCfgDictionary then
          begin
            TConfigManager.Instance.DictionaryList.UpdateParentID((ChildNode as TCfgDictionary).DicID, NewParentID);
          end
          else if Node is TCfgDictionaryFolder then
          begin
            TConfigManager.Instance.DictionaryFolders.Locate((ChildNode as TCfgDictionaryFolder).FolderID);
            DictionaryFolders.ParentID := NewParentID;
          end
          else
            ExceptionHandler.Raise_('DeleteFolder: Внутренняя ошибка. Неизвестный тип узла дерева');
        end;
      end;
      if DictionaryFolders.Locate(DicID) then
        DictionaryFolders.DataSet.Delete
      else
        ExceptionHandler.Raise_('DeleteFolder: Внутренняя ошибка: Не найдена папка');
      TConfigManager.Instance.DictionaryList.ApplyUpdates;
      DictionaryFolders.ApplyUpdates;
    //finally
    //  FreeAndNil(DictionaryFolders);
    //end;
    //DicDm.RefreshDics;
    ReloadTree;
  end;
end;

{$ENDREGION}

{$REGION 'TProcessEditor'}

constructor TProcessEditor.Create(ANode: TMVCNode);
begin
  inherited Create(ANode);
end;

procedure TProcessEditor.SetNode(aNode: TMVCNode);
begin
  inherited SetNode(aNode);
  //sdm.cdServices.Locate(F_SrvID, (aNode as TCfgProcess).ProcessID, []);
  //sdm.SetCurProcess(NvlInteger(sdm.cdServices[F_SrvID]));
end;

procedure TProcessEditor.ModifyStructure(Sender: TObject);
var
  StructData: TClientDataSet;
  Srv: TPolyProcessCfg;
  SrvID: integer;
  //dsDics: TDataSource;
begin
  TConfigManager.Instance.SaveDicConfig;

  //if not sdm.cdServices.Active or sdm.cdServices.IsEmpty then Exit;
  //TConfigManager.Instance.ApplySrvGroupsPages(true);  // раньше было ApplySrv
  StructData := nil;
  SrvID := (Node as TCfgProcess).ProcessID;
  Srv := TConfigManager.Instance.ServiceByID(SrvID);//sdm.cdServices[F_SrvID]);
  if (Srv = nil) then Exit;
  //SrvID := Srv.SrvID;
  if TConfigManager.Instance.CreateSrvStructData(StructData, Srv, false, false) then
  begin
    //sdm.cdServices.DisableControls;
    //dsDics := TDataSource.Create(nil);
    //dsDics.DataSet := DictionaryList.DataSet;
    try
      if ExecStructForm(StructData, stService, cmOkCancel) = mrOk then
      begin
        TConfigManager.Instance.ModifySrvTable(Srv, StructData);
        TConfigManager.Instance.NeedRefreshServices := true;
        //sdm.cdServices.Locate(F_SrvID, SrvID, []);

        TConfigManager.Instance.ApplySrvGroupsPages(true);  // раньше было ApplySrv
      end;
    finally
      //sdm.cdServices.EnableControls;
      if StructData <> nil then StructData.Close;
      //dsDics.Free;
    end;
  end;
end;

procedure TProcessEditor.EditProperties(Sender: TObject);
var
  StructData: TClientDataSet;
  SrvID: integer;
  Srv: TPolyProcessCfg;
  CfgData: TProcessCfgData;
  //dsDics: TDataSource;
begin
  TConfigManager.Instance.SaveDicConfig;

  //TConfigManager.Instance.ApplySrvGroupsPages(true);  // раньше было ApplySrv
  StructData := nil;
  SrvID := (Node as TCfgProcess).ProcessID;//sdm.cdServices[F_SrvID];
  Srv := TConfigManager.Instance.ServiceByID(SrvID);
  CfgData := TConfigManager.Instance.ProcessCfgData;
  if CfgData.Locate((Node as TCfgProcess).ProcessID) then
  begin
  //dsDics := TDataSource.Create(nil);
  //try
    //dsDics.DataSet := DictionaryList.DataSet;
    if ExecSrvProps(StructData, Srv{, sdm.dsServices, dsDics}) = mrOk then
    begin
      //sdm.cdServices.DisableControls;
      //try
        // Параметры процесса могли измениться и структура тоже
        TConfigManager.Instance.ModifySrvTable(Srv, StructData);
        TConfigManager.Instance.NeedRefreshServices := true;
        //sdm.cdServices.Locate(F_SrvID, SrvID, []);

        TConfigManager.Instance.ApplySrvGroupsPages(true);  // раньше было ApplySrv
        ReloadTree;
      //finally
      //  sdm.cdServices.EnableControls;
      //end
    end
    else
      TConfigManager.Instance.ProcessCfgData.CancelUpdates;//.CancelProcessCfg;
  end
  else
    ExceptionHandler.Raise_('DeleteProcess: процесс не найден');
  //finally
  //  dsDics.Free;
  //end;
end;

procedure TProcessEditor.CreateTriggers(Sender: TObject);
begin
  //TConfigManager.Instance.ApplySrvGroupsPages(true);  // раньше было ApplySrv
  TConfigManager.Instance.CreateProcessTriggers((Node as TCfgProcess).ProcessID);//sdm.cdServices[F_SrvID]);
end;

procedure TProcessEditor.EditCode(Sender: TObject);
var
  CfgData: TProcessCfgData;
begin
  //if not sdm.cdServices.Active or sdm.cdServices.IsEmpty then Exit;
  CfgData := TConfigManager.Instance.ProcessCfgData;
  if CfgData.Locate((Node as TCfgProcess).ProcessID) then
  begin
    if ExecCodeEditForm(false, -1, '', '', not AccessManager.CurUser.EditProcCfg,
           CodeEditGetCaption, CodeEditGetScripts,
           CodeEditGetScriptDesc, CodeEditWriteScripts, TSettingsManager.Instance.Storage) then
    begin
      CfgData.ApplyUpdates;
      TConfigManager.Instance.UpdateScripts;//RefreshProcessCfg;
    end;
  end;
end;

function TProcessEditor.GetProcessCfg: TPolyProcessCfg;
begin
  Result := TConfigManager.Instance.ServiceByID((Node as TCfgProcess).ProcessID);
end;

procedure TProcessEditor.DeleteProcess(Sender: TObject);
var
  CfgData: TProcessCfgData;
begin
  TConfigManager.Instance.SaveDicConfig;

  //if sdm.cdServices.Active and not sdm.cdServices.IsEmpty then
  //begin
    CfgData := TConfigManager.Instance.ProcessCfgData;
    if CfgData.Locate((Node as TCfgProcess).ProcessID) then
    begin
      if RusMessageDlg('Вы действительно желаете удалить процесс "' +
         CfgData.ProcessDescription + '"?' + #13'Все данные по этому процессу будут потеряны.',
         mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        CfgData.DataSet.Delete;//sdm.cdServices.Delete;
        TConfigManager.Instance.ApplySrvGroupsPages(true);  // раньше было ApplySrv
        ReloadTree;
      end;
    end
    else
      ExceptionHandler.Raise_('DeleteProcess: процесс не найден');
  //end;
end;

procedure TProcessEditor.ExportProcess(Sender: TObject);
var
  Process: TPolyProcessCfg;
begin
  //if not sdm.cdServices.IsEmpty then
  //begin
    Process := TConfigManager.Instance.ServiceByID((Node as TCfgProcess).ProcessID);
    ScriptExchange.ExportScriptsToFiles(Process);
  //end;
end;

function TProcessEditor.CodeEditGetCaption(Sender: TObject): string;
begin
  Result := GetProcessCfg.ServiceName;
end;

function TProcessEditor.CodeEditGetScripts(Sender: TObject): TStringList;
begin
  Result := GetProcessCfg.GetScriptsCopyFromDataSet(TConfigManager.Instance.ProcessCfgData.DataSet);//sdm.cdServices);
end;

function TProcessEditor.CodeEditGetScriptDesc(Sender: TObject; ScriptName: string): string;
begin
  Result := TConfigManager.Instance.GetProcessScriptDesc(ScriptName);
end;

procedure CommonWriteScripts(Scripts: TStringList; cd: TDataSet);
var
  OldS: TDataSetState;
  i: integer;
begin
  OldS := cd.State;
  if not (OldS in [dsEdit, dsInsert]) then cd.Edit;
  if Scripts.Count > 0 then
    for i := 0 to Pred(Scripts.Count) do
      WriteStringListToBlob((Scripts.Objects[i] as TScript).Script,
        cd.FieldByName(Scripts[i]) as TBlobField);
  if OldS = dsBrowse then cd.CheckBrowseMode;
end;

procedure TProcessEditor.CodeEditWriteScripts(Sender: TObject; Scripts: TStringList);
begin
  CommonWriteScripts(Scripts, TConfigManager.Instance.ProcessCfgData.DataSet);
end;

procedure TProcessEditor.AddGrid(Sender: TObject);
var
  CfgData: TProcessGridCfgData;
  PrcData: TProcessCfgData;
begin
  TConfigManager.Instance.SaveDicConfig;

  CfgData := TConfigManager.Instance.ProcessGridCfgData;
  PrcData := TConfigManager.Instance.ProcessCfgData;
  if PrcData.Locate((Node as TCfgProcess).ProcessID) then
  begin
    CfgData.DataSet.Append;
    CfgData.ProcessPageID := TConfigManager.Instance.ProcessPageData.ProcessPageID;
    CfgData.ProcessID := PrcData.KeyValue;
    //CfgData.ApplyUpdates;
    //TConfigManager.Instance.ApplyProcessCfg;
    TConfigManager.Instance.ApplySrvGroupsPages(true);
    ReloadTree;
  end else
    ExceptionHandler.Raise_('AddGrid: процесс не найден');
end;

{$ENDREGION}

{$REGION 'TProcessRootEditor'}

procedure TProcessRootEditor.ExportScripts(Sender: TObject);
begin
  ScriptExchange.ExportScriptsToFiles;
end;

procedure TProcessRootEditor.ImportScripts(Sender: TObject);
begin
  ScriptExchange.ImportScriptsFromFiles;
end;

procedure TProcessRootEditor.AddProcess(Sender: TObject);
var
  Ok: boolean;
  R, ID: integer;
  StructData: TClientDataSet;
  SrvProp: TPolyProcessCfg;
  ProcessCfgData: TProcessCfgData;
  //dsDics: TDataSource;
begin
  Ok := false;
  //TConfigManager.Instance.ApplySrvGroupsPages(true);  // раньше было ApplySrv
  //sdm.AppendService;
  ProcessCfgData := TConfigManager.Instance.ProcessCfgData;
  ProcessCfgData.Append;
  StructData := nil;
  //dsDics := TDataSource.Create(nil);
  try
    SrvProp := TPolyProcessCfg.Create(ProcessCfgData.KeyValue);
    SrvProp.FieldInfoData := TConfigManager.Instance.ProcessFieldData.DataSet;
    repeat
      R := ExecSrvProps(StructData, SrvProp);//, sdm.dsServices, dsDics);
      if R <> mrOk then
      begin
        ProcessCfgData.CancelUpdates;//CancelProcessCfg;
        Ok := true;
      end
      else
      begin
        if TConfigManager.Instance.CheckSrvName(ProcessCfgData.ProcessName) then
        begin
          ID := TConfigManager.Instance.CreateProcessTable(StructData as TClientDataSet);
          Ok := ID > 0;
          TConfigManager.Instance.NeedRefreshServices := true;
          if Ok then
          begin
            TConfigManager.Instance.ApplySrvGroupsPages(true);  // раньше было ApplySrv
            ReloadTree;
            //sdm.cdServices.Locate(F_SrvID, ID, []);   // TODO: не надо
          end;
        end;
      end;
    until Ok;
  finally
    if StructData <> nil then
      StructData.Close;
    //dsDics.Free;
  end;
end;

procedure TProcessRootEditor.CreateProcessTrigger(Prc: TPolyProcessCfg);
begin
  if Prc.IsActive then
    TConfigManager.Instance.CreateProcessTriggers(Prc.SrvID);
end;

procedure TProcessRootEditor.CreateAllTriggers(Sender: TObject);
//var
//  CfgData: TProcessCfgData;
begin
  //CfgData := TConfigManager.Instance.ProcessCfgData;
  //CfgData.First;
  //while not CfgData.Eof do
  //begin
  //  TConfigManager.Instance.CreateProcessTriggers(CfgData.KeyValue);
  //  CfgData.Next;
  //end;
  TConfigManager.Instance.ForEachProcess(CreateProcessTrigger);
end;

{$ENDREGION}

{$REGION 'TProcessGridEditor'}

function TProcessGridEditor.GetGridCfg: TProcessGridCfg;
begin
  Result := TConfigManager.Instance.GridByID((Node as TCfgProcessGrid).GridID);
end;

function TProcessGridEditor.CodeEditGetCaption(Sender: TObject): string;
begin
  Result := GetGridCfg.GridName;  { TODO: Надо сделать ScriptedObj.InternalName }
end;

function TProcessGridEditor.CodeEditGetScripts(Sender: TObject): TStringList;
begin
  Result := GetGridCfg.GetScriptsCopyFromDataSet(TConfigManager.Instance.ProcessGridCfgData.DataSet); {CurGrid.Scripts;}
end;

procedure TProcessGridEditor.CodeEditWriteScripts(Sender: TObject; Scripts: TStringList);
begin
  CommonWriteScripts(Scripts, TConfigManager.Instance.ProcessGridCfgData.DataSet);
end;

function TProcessGridEditor.CodeEditGetScriptDesc(Sender: TObject; ScriptName: string): string;
begin
  Result := TConfigManager.Instance.GetProcessScriptDesc(ScriptName);
end;

procedure TProcessGridEditor.EditGridCols(Sender: TObject);
var
  p: integer;
  NeedRefreshServices: boolean;
  Grids: TProcessGridCfgData;
begin
  TConfigManager.Instance.SaveDicConfig;

  //if not sdm.cdServices.Active or sdm.cdServices.IsEmpty then Exit;
  NeedRefreshServices := false;
  //ApplySrvGroupsPages(true);  // раньше было ApplySrv
  Grids := TConfigManager.Instance.ProcessGridCfgData;
  //if not VarIsNull(Grids.ProcessID) then
  //begin
    p := Grids.ProcessID;
    if ExecEditGridForm(p, Grids.KeyValue) <> mrOk then
      TConfigManager.Instance.ProcessGridColData.CancelUpdates
    else
      NeedRefreshServices := true;
  //end;
  if NeedRefreshServices then
  begin
    // TODO: все сразу применяется
    TConfigManager.Instance.ApplySrvGroupsPages(true);
  end;
end;

procedure TProcessGridEditor.DeleteGrid(Sender: TObject);
var
  Grids: TProcessGridCfgData;
begin
  TConfigManager.Instance.SaveDicConfig;

  Grids := TConfigManager.Instance.ProcessGridCfgData;
  if not Grids.IsEmpty then
  begin
    //Grids.Locate((Node as TCfgProcessGrid).GridID);
    if RusMessageDlg('Вы действительно желаете удалить таблицу "' +
      Grids.GridName + '"?', mtConfirmation, mbYesNoCancel, 0) = mrYes then
    begin
      Grids.DataSet.Delete;
      //Grids.ApplyUpdates;
      //TConfigManager.Instance.ApplyProcessCfg;
      TConfigManager.Instance.ApplySrvGroupsPages(true);
      ReloadTree;
    end;
  end;
end;

procedure TProcessGridEditor.EditGridProperties(Sender: TObject);
var
  GridID: integer;
  Srv: TPolyProcessCfg;
  Grids: TProcessGridCfgData;
begin
  TConfigManager.Instance.SaveDicConfig;

  //TConfigManager.Instance.ApplySrvGroupsPages(true);  // раньше было ApplySrv
  Srv := TConfigManager.Instance.ServiceByID((Node.Parent as TCfgProcess).ProcessID);
  if Srv <> nil then
  begin
    Grids := TConfigManager.Instance.ProcessGridCfgData;
    //GridID := (Node as TCfgProcessGrid).GridID;
    //if Grids.Locate(GridID) then
    //begin
      if ExecGridProps(Srv) = mrOk then
      begin
        TConfigManager.Instance.ApplySrvGroupsPages(true);  { TODO: Надо ли здесь обновлять ВСЕ? }
        ReloadTree;
      end
      else
        Grids.CancelUpdates;
    //end
    //else
    //  ExceptionHandler.Raise_('EditGridProperties: таблица не найдена');
  end;
end;

procedure TProcessGridEditor.EditGridCode(Sender: TObject);
var
  Grids: TProcessGridCfgData;
begin
  TConfigManager.Instance.SaveDicConfig;

  Grids := TConfigManager.Instance.ProcessGridCfgData;
  if Grids.Active and not Grids.IsEmpty then
  begin
    //CurGrid := TConfigManager.Instance.GridByID(Grids.KeyValue);
    if ExecCodeEditForm(false, -1, '', '', not AccessManager.CurUser.EditProcCfg,
        CodeEditGetCaption, CodeEditGetScripts,
        CodeEditGetScriptDesc, CodeEditWriteScripts, TSettingsManager.Instance.Storage) then
    begin
      Grids.ApplyUpdates;
      TConfigManager.Instance.UpdateScripts;//RefreshProcessCfg;
    end;
  end;
end;

{$ENDREGION}

end.
