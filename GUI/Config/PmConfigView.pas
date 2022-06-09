unit PmConfigView;

interface

uses Classes, JvAppStorage, JvSpeedBar, VirtualTrees,

  PmEntity, PmEntityController, PmConfigTreeEntity, fBaseFrame, fConfigToolbar,
  PmConfigTreeView, PmConfigTree, PmConfigEditors, PmBaseConfigEditorFrame,
  PmConfigObjects;

type
  TConfigView = class(TEntityController)
  private
    FToolbarFrame: TConfigToolbarFrame;
    CurrentEditor: TBaseConfigEditor;
    FEditorList: TList;
    function FocusedNode: TMVCNode;
    procedure UpdateFromNode;
    procedure TreeViewChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure TreeViewFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode;
      OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
    function CreateEditor(ANode: TMVCNode): TBaseConfigEditor;
    function CreateEditorFrame(_Node: TMVCNode; _Editor: TBaseConfigEditor): TBaseConfigEditorFrame;
    procedure ReloadTree(Sender: TObject);
    procedure ClearEditors;
    procedure DoSaveConfig(Sender: TObject);
  public
    constructor Create(_Entity: TEntity); override;
    destructor Destroy; override;
    function Visible: boolean; override;
    function CreateFrame(Owner: TComponent): TBaseFrame; override;
    procedure Activate; override;
    procedure Deactivate(var AllowLeave: boolean); override;
    //procedure LoadSettings; override;
    //procedure SaveSettings; override;
    procedure RefreshData; override;
    function GetToolbar: TjvSpeedbar; override;
  end;

implementation

uses SysUtils, Controls, Dialogs, RDialogs,

  ExHandler, CalcSettings, CodeEdit, PmConfigFrame, PmDictionaryEditorFrame,
  PmProcessEditorFrame, PmConfigManager, PmDictionaryFolderEditorFrame,
  PmProcessRootFrame, PmProcessCfg, PmAccessManager, PmActions,
  PmDictionaryRootEditorFrame, PmProcessGridEditorFrame;

constructor TConfigView.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  FCaption := 'Конфигуратор';
  FEditorList := TList.Create;
  TMainActions.GetAction(TConfigActions.SaveConfig).OnExecute := DoSaveConfig;
end;

procedure TConfigView.DoSaveConfig(Sender: TObject);
begin
  TConfigManager.Instance.SaveDicConfig;
end;

procedure TConfigView.ClearEditors;
var
  I: Integer;
begin
  CurrentEditor := nil;
  // уничтожаем все редакторы и фреймы
  for I := 0 to FEditorList.Count - 1 do
  begin
    TBaseConfigEditor(FEditorList[I]).Frame.Free;
    TBaseConfigEditor(FEditorList[I]).Free;
  end;
  FEditorList.Clear;
end;

destructor TConfigView.Destroy;
begin
  ClearEditors;
  FreeAndNil(FEditorList);
  TMainActions.GetAction(TConfigActions.SaveConfig).OnExecute := nil;
  //CustomersWithIncome.AfterScrollNotifier.UnRegisterHandler(AfterScrollID);
  inherited Destroy;
end;

function TConfigView.Visible: boolean;
begin
  Result := true;
end;

function TConfigView.CreateFrame(Owner: TComponent): TBaseFrame;
begin
  FFrame := TConfigFrame.Create(Owner, Entity);
  TConfigFrame(FFrame).TreeView.OnFocusChanging := TreeViewFocusChanging;
  TConfigFrame(FFrame).TreeView.OnChange := TreeViewChange;
  UpdateFromNode;

  //TCustomerPaymentsFrame(FFrame).OnGoToOrder := GoToOrder;

  Result := FFrame;
end;

procedure TConfigView.RefreshData;
begin
  // TODO
end;


procedure TConfigView.Activate;
{var
  Save_Cursor: TCursor;}
begin
  // не обновлять если уже открыт
{  if not FEntity.DataSet.Active then
  begin
    Save_Cursor := Screen.Cursor;
    Screen.Cursor := crSQLWait;
    try
      FEntity.Reload;
    finally
      Screen.Cursor := Save_Cursor;
    end;
  end;}
end;

{procedure TConfigView.LoadSettings;
begin
  TBaseFrame(FFrame).LoadSettings;
end;

procedure TConfigView.SaveSettings;
begin
  TBaseFrame(FFrame).SaveSettings;
end;}

function TConfigView.GetToolbar: TjvSpeedbar;
begin
  if FToolbarFrame = nil then
    FToolbarFrame := TConfigToolbarFrame.Create(nil);
  Result := FToolbarFrame.Toolbar;
end;

function TConfigView.FocusedNode: TMVCNode;
begin
  with TConfigFrame(FFrame).TreeView do
    if FocusedNode <> NIL then
      Result := MVCNode[FocusedNode]
    else
      Result := NIL;
end;

function TConfigView.CreateEditor(ANode: TMVCNode): TBaseConfigEditor;
begin
  if ANode is TCfgDictionary then
    Result := TDictionaryEditor.Create(ANode)
  else if (ANode is TCfgDictionaryFolder) or (ANode is TCfgDictionaryRoot) then
    Result := TDictionaryFolderEditor.Create(ANode)
  else if ANode is TCfgProcess then
    Result := TProcessEditor.Create(ANode)
  else if ANode is TCfgProcessGrid then
    Result := TProcessGridEditor.Create(ANode)
  else if ANode is TCfgProcessRoot then
    Result := TProcessRootEditor.Create(ANode)
  else if ANode is TCfgUser then
    Result := TUserEditor.Create(ANode)
  else
    Result := TBaseConfigEditor.Create(ANode);
  Result.OnReloadTree := ReloadTree;
end;

procedure TConfigView.ReloadTree(Sender: TObject);
begin
  TConfigFrame(FFrame).SaveExpandedNodes;
  TConfigFrame(FFrame).ResetEditor;
  ClearEditors;

  TConfigManager.Instance.ReloadTree;

  TConfigFrame(FFrame).TreeView.Tree := TConfigManager.Instance.Tree;  // обновляем структуру конфигурации
  TConfigFrame(FFrame).TreeView.Update;
  TConfigFrame(FFrame).RestoreExpandedNodes;
end;

function TConfigView.CreateEditorFrame(_Node: TMVCNode; _Editor: TBaseConfigEditor): TBaseConfigEditorFrame;
begin
  if _Node is TCfgDictionary then
  begin
    Result := TDictionaryEditorFrame.Create(nil);
    (Result as TDictionaryEditorFrame).OnEditDictionaryProperties := (_Editor as TDictionaryEditor).EditProperties;
    //(Result as TDictionaryEditorFrame).OnNewDictionary := (_Editor as TDictionaryEditor).NewDictionary;
    (Result as TDictionaryEditorFrame).OnDeleteDictionary := (_Editor as TDictionaryEditor).DeleteDictionary;
  end
  else
  if _Node is TCfgDictionaryFolder then
  begin
    Result := TDictionaryFolderEditorFrame.Create(nil);
    (Result as TDictionaryFolderEditorFrame).OnEditFolderProperties := (_Editor as TDictionaryFolderEditor).EditProperties;
    (Result as TDictionaryFolderEditorFrame).OnNewDictionary := (_Editor as TDictionaryFolderEditor).NewDictionary;
    (Result as TDictionaryFolderEditorFrame).OnNewFolder := (_Editor as TDictionaryFolderEditor).NewFolder;
    (Result as TDictionaryFolderEditorFrame).OnDeleteFolder := (_Editor as TDictionaryFolderEditor).DeleteFolder;
    (Result as TDictionaryFolderEditorFrame).OnShowInternalName := (FFrame as TConfigFrame).ToggleShowInternalName;
  end
  else
  if _Node is TCfgDictionaryRoot then
  begin
    Result := TDictionaryRootEditorFrame.Create(nil);
    (Result as TDictionaryRootEditorFrame).OnNewDictionary := (_Editor as TDictionaryFolderEditor).NewDictionary;
    (Result as TDictionaryRootEditorFrame).OnNewFolder := (_Editor as TDictionaryFolderEditor).NewFolder;
    (Result as TDictionaryRootEditorFrame).OnShowInternalName := (FFrame as TConfigFrame).ToggleShowInternalName;
  end
  else
  if _Node is TCfgProcess then
  begin
    Result := TProcessEditorFrame.Create(nil);
    (Result as TProcessEditorFrame).OnModifyStructure := (_Editor as TProcessEditor).ModifyStructure;
    (Result as TProcessEditorFrame).OnEditCode := (_Editor as TProcessEditor).EditCode;
    (Result as TProcessEditorFrame).OnEditProperties := (_Editor as TProcessEditor).EditProperties;
    //(Result as TProcessEditorFrame).OnAddProcess := (_Editor as TProcessEditor).AddProcess;
    (Result as TProcessEditorFrame).OnDeleteProcess := (_Editor as TProcessEditor).DeleteProcess;
    (Result as TProcessEditorFrame).OnExportProcess := (_Editor as TProcessEditor).ExportProcess;
    (Result as TProcessEditorFrame).OnCreateTriggers := (_Editor as TProcessEditor).CreateTriggers;

    (Result as TProcessEditorFrame).OnAddGrid := (_Editor as TProcessEditor).AddGrid;
  end
  else
  if _Node is TCfgProcessGrid then
  begin
    Result := TProcessGridEditorFrame.Create(nil);
    (Result as TProcessGridEditorFrame).OnEditGridProperties := (_Editor as TProcessGridEditor).EditGridProperties;
    (Result as TProcessGridEditorFrame).OnEditGridCols := (_Editor as TProcessGridEditor).EditGridCols;
    (Result as TProcessGridEditorFrame).OnEditGridCode := (_Editor as TProcessGridEditor).EditGridCode;
    (Result as TProcessGridEditorFrame).OnDeleteGrid := (_Editor as TProcessGridEditor).DeleteGrid;
  end
  else
  if _Node is TCfgProcessRoot then
  begin
    Result := TProcessRootEditorFrame.Create(nil);
    (Result as TProcessRootEditorFrame).OnAddProcess := (_Editor as TProcessRootEditor).AddProcess;
    (Result as TProcessRootEditorFrame).OnExportScripts := (_Editor as TProcessRootEditor).ExportScripts;
    (Result as TProcessRootEditorFrame).OnImportScripts := (_Editor as TProcessRootEditor).ImportScripts;
    (Result as TProcessRootEditorFrame).OnCreateAllTriggers := (_Editor as TProcessRootEditor).CreateAllTriggers;
  end
  else
    Result := TBaseConfigEditorFrame.Create(nil);
  Result.Node := _Node;
end;

procedure TConfigView.UpdateFromNode;
var
  I: Integer;
begin
  if FocusedNode = NIL then
  begin
  end
  else
  begin
    if (CurrentEditor = nil) or (CurrentEditor.Node <> FocusedNode) then
    begin
      CurrentEditor := nil;
      for I := 0 to FEditorList.Count - 1 do
        if TBaseConfigEditor(FEditorList[I]).Node.ClassName = FocusedNode.ClassName then
          CurrentEditor := TBaseConfigEditor(FEditorList[I]);
      if CurrentEditor = nil then
      begin
        CurrentEditor := CreateEditor(FocusedNode);
        FEditorList.Add(CurrentEditor);
        CurrentEditor.Frame := CreateEditorFrame(FocusedNode, CurrentEditor);
      end
      else
      begin
        CurrentEditor.Node := FocusedNode;
        CurrentEditor.Frame.Node := FocusedNode;
      end;
      TConfigFrame(FFrame).ShowEditor(CurrentEditor.Frame);
    end;
    //TConfigFrame(FFrame).ShowEditor(FocusedNode);
{      edCaption.Text:=      FocusedNode.Caption;
       edCaption.Enabled:=   True;
       edSubCaption.Text:=   FocusedNode.SubCaption;
       edSubCaption.Enabled:=True;
       edIncidence.Text:=    IntToStr(FocusedNode.Incidence);
       edIncidence.Enabled:= True;
       btnDelete.Enabled:=   True;}
  end;
end;

procedure TConfigView.TreeViewChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  UpdateFromNode;
end;

procedure TConfigView.TreeViewFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode;
  OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
begin
  if (CurrentEditor <> nil) and (OldNode <> NewNode) then
    Allowed := CurrentEditor.Frame.AllowLeaveEditor;
end;

procedure TConfigView.Deactivate(var AllowLeave: boolean);
var
  Res: integer;
begin
  AllowLeave := true;
  if TConfigManager.Instance.DictionaryList.HasChanges then
  begin
    Res := RusMessageDlg('Сохранить изменения в справочниках?', mtConfirmation,
      mbYesNoCancel, 0);
    if Res = mrYes then
    begin
      if CurrentEditor <> nil then
        CurrentEditor.Frame.AllowLeaveEditor;
      TConfigManager.Instance.DictionaryList.ApplyAll;
    end
    else if Res = mrCancel then
      AllowLeave := false;
  end;
end;

end.
