unit PmConfigFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseFrame, ExtCtrls, JvFormPlacement, ImgList, ActiveX,
  VirtualTrees, JvExExtCtrls, JvNetscapeSplitter,

  PmConfigTree, PmConfigTreeView, PmBaseConfigEditorFrame, PmDictionaryList,
  PmEntity;

type
  TConfigFrame = class(TBaseFrame)
    imlNodes: TImageList;
    paCfgObjectEditor: TPanel;
    paCfgTree: TPanel;
    splitterCfg: TJvNetscapeSplitter;
  private
    FTreeView: TMVCTreeView;
    FEditorFrame: TBaseConfigEditorFrame;
    FShowInternalName: boolean;
    FExpandedState: TStringList;
    FCurrentNodeID: string;

    procedure TreeViewDragDrop(Sender: TBaseVirtualTree;
      Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
      Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure UpdateFolderParentID(SourceFolderID: integer; TargetFolderID: integer);
    procedure UpdateDictionaryParentID(SourceDicID: integer; TargetFolderID: integer);
    procedure TreeViewResize(Sender: TObject);
  protected
    procedure CreateWnd; override;
    procedure GetExpandedState(Node: TMVCNode);
    procedure SetExpandedState(Node: TMVCNode);
    procedure UpdateShowInternalName;
  public
    constructor Create(Owner: TComponent; _Entity: TEntity); override;
    destructor Destroy; override;
    procedure ResetEditor;
    procedure ShowEditor(NodeEditorFrame: TBaseConfigEditorFrame);
    procedure ToggleShowInternalName(Sender: TObject);
    procedure SaveExpandedNodes;
    procedure RestoreExpandedNodes;

    property TreeView: TMVCTreeView read FTreeView;
  end;

implementation

uses PmConfigManager, PmConfigObjects, ExHandler;

{$R *.dfm}

constructor TConfigFrame.Create(Owner: TComponent; _Entity: TEntity);
begin
  inherited Create(Owner, _Entity{'ConfigEditor'});

  FTreeView := TMVCTreeView.Create(Self);
  with FTreeView do
  begin
    Parent := Self;
    Align := alLeft;
    Tree := TConfigManager.Instance.Tree;  // получаем структуру конфигурации
  end;

  paFilter.Visible := false; // фильтр не нужен
end;

procedure TConfigFrame.CreateWnd;
begin
  inherited CreateWnd;

  FTreeView.Images := imlNodes;
  with FTreeView, TreeOptions do
    begin
      AutoOptions := [toAutoDropExpand, toAutoScroll, toAutoScrollOnExpand, toAutoSpanColumns, toAutoTristateTracking, toAutoDeleteMovedNodes];
      SelectionOptions := [toFullRowSelect, toRightClickSelect];
      DragMode := dmAutomatic;
      IncrementalSearch := isAll;
      IncrementalSearchStart := ssAlwaysStartOver;
      PaintOptions:=PaintOptions+[toShowButtons,        // display collapse/expand
                        toShowHorzGridLines,  // display horizontal lines
                        toShowRoot,           // show lines also at root level
                        toShowTreeLines,      // display tree lines to show
                                              // hierarchy of nodes
                                              // buttons left to a node
                        toShowVertGridLines]; // display vertical lines
                                              // (depending on columns) to
                                              // simulate a grid
      //MiscOptions := MiscOptions+[toEditable];
      //SelectionOptions := SelectionOptions+[toExtendedFocus];
                                              // to simulate a grid
      with Header do
        begin
          Height := 18;
          Options := Options + [hoVisible];
          Background := clBtnFace;
          AutoSize := True;
          Style := hsFlatButtons;
          with Columns.Add do
            begin
              Text := 'Имя';
              Width := 300;
              Options := Options + [coDraggable];
            end;
          with Columns.Add do
            begin
              Text := 'Внутр. имя';
              Width := 100;
            end;
        end;
      // обработчики
      OnDragDrop := TreeViewDragDrop;
      OnResize := TreeViewResize;
    end;
  UpdateShowInternalName;
  TreeViewResize(nil);
end;

destructor TConfigFrame.Destroy;
begin
  // Вообще-то это раньше было в TMVCTreeView.Destroy,
  // но пришлось перенести сюда потому что вылетало при закрытии,
  // если выделить хоть один узел. Причина неизвестна. В демке то же самое.
  FTreeView.Tree := nil;

  FreeAndNil(FExpandedState);

  inherited;
end;

procedure TConfigFrame.ResetEditor;
begin
  TreeView.PopupMenu := nil;
  if FEditorFrame <> nil then
    paCfgObjectEditor.RemoveControl(FEditorFrame);
  FEditorFrame := nil;
end;

procedure TConfigFrame.ShowEditor(NodeEditorFrame: TBaseConfigEditorFrame);
begin
  if (FEditorFrame <> nil) and (FEditorFrame <> NodeEditorFrame) then
    paCfgObjectEditor.RemoveControl(FEditorFrame);
  if FEditorFrame <> NodeEditorFrame then
  begin
    FEditorFrame := NodeEditorFrame;
    //paCfgObjectEditor.InsertControl(FEditorFrame);
    FEditorFrame.Parent := paCfgObjectEditor;
    TreeView.PopupMenu := FEditorFrame.GetPopupMenu;
  end;
end;

procedure TConfigFrame.UpdateShowInternalName;
var
  options: TVTColumnOptions;
  columOfFoldersAndDictionary: TVirtualTreeColumn;
  columOfInternalNames: TVirtualTreeColumn;
  workingSizeOfTreeView: integer;
begin
  columOfFoldersAndDictionary := FTreeView.Header.Columns[0];
  columOfInternalNames := FTreeView.Header.Columns[1];
  options := columOfInternalNames.Options;

  workingSizeOfTreeView := FTreeView.ClientWidth;

  if FShowInternalName then
  begin
    options := options + [coVisible, coEnabled];
    columOfFoldersAndDictionary.Width := workingSizeOfTreeView - columOfInternalNames.Width;
  end
  else
  begin
    options := options - [coVisible, coEnabled];
    columOfFoldersAndDictionary.Width := workingSizeOfTreeView;
  end;

  FTreeView.Header.Columns[1].Options := options;
end;

procedure TConfigFrame.ToggleShowInternalName(Sender: TObject);
begin
  FShowInternalName := not FShowInternalName;
  UpdateShowInternalName;
end;

procedure TConfigFrame.TreeViewResize(Sender: TObject);
begin
  if (FTreeView <> nil) and (FTreeView.Header.Columns.Count > 1) then
  begin
    if coVisible in FTreeView.Header.Columns[1].Options then
    begin
      FTreeView.Header.Columns[0].Width := FTreeView.ClientWidth * 2 div 3;
      FTreeView.Header.Columns[1].Width := FTreeView.ClientWidth - FTreeView.Header.Columns[0].Width;
    end
    else
      FTreeView.Header.Columns[0].Width := FTreeView.ClientWidth;
  end;
end;

procedure TConfigFrame.GetExpandedState(Node: TMVCNode);
var
  I: Integer;
  ChildNode: TMVCNode;
begin
  for I := 0 to Node.ChildCount - 1 do
  begin
    ChildNode := Node.Child[I];
    if Assigned(ChildNode.VirtualNode) and FTreeView.Expanded[ChildNode.VirtualNode] then
    begin
      FExpandedState.Add(ChildNode.GetUniqueID);
      GetExpandedState(ChildNode);
    end;
  end;
end;

procedure TConfigFrame.SaveExpandedNodes;
begin
  if FTreeView.FocusedNode <> nil then
    FCurrentNodeID := FTreeView.MVCNode[FTreeView.FocusedNode].GetUniqueID
  else
    FCurrentNodeID := '';

  FreeAndNil(FExpandedState);
  FExpandedState := TStringList.Create;
  FExpandedState.Sorted := true;

  GetExpandedState(FTreeView.Tree.Root);
end;

procedure TConfigFrame.SetExpandedState(Node: TMVCNode);
var
  I: Integer;
  ChildNode: TMVCNode;
begin
  for I := 0 to Node.ChildCount - 1 do
  begin
    ChildNode := Node.Child[I];
    if FExpandedState.IndexOf(ChildNode.GetUniqueID) >= 0 then
    begin
      FTreeView.Expanded[ChildNode.VirtualNode] := true;
      FTreeView.Update;
      SetExpandedState(ChildNode);
    end;
    // Если этот узел был сфокусированным, то устанавливаем фокус на него
    if (FCurrentNodeID <> '') and (ChildNode.GetUniqueID = FCurrentNodeID) then
    begin
      FTreeView.FocusedNode := ChildNode.VirtualNode;
      //FTreeView.FocusedNode.States := FTreeView.FocusedNode.States + [vsSelected];
    end;
  end;
end;

procedure TConfigFrame.RestoreExpandedNodes;
begin
  SetExpandedState(FTreeView.Tree.Root);

  FreeAndNil(FExpandedState);
end;

procedure TConfigFrame.UpdateFolderParentID(SourceFolderID: integer; TargetFolderID: integer);
var
  DicFolders: TDictionaryFolders;
begin
  DicFolders := TDictionaryFolders.Create;
  try
    if DicFolders.Locate(SourceFolderID) then
    begin
      DicFolders.ParentID := TargetFolderID;
      DicFolders.ApplyUpdates;
    end
    else
      ExceptionHandler.Raise_('UpdateFolderParentID: Внутренняя ошибка: папка на найдена');
  finally
    DicFolders.Free;
  end;
end;

procedure TConfigFrame.UpdateDictionaryParentID(SourceDicID: integer; TargetFolderID: integer);
begin
  TConfigManager.Instance.DictionaryList.UpdateParentID(SourceDicID, TargetFolderID);
  TConfigManager.Instance.DictionaryList.ApplyUpdates;
  //DicDm.RefreshDics;
end;

procedure TConfigFrame.TreeViewDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  sourceVNode, targetVNode: PVirtualNode;
  sourceNode, targetNode: TMVCNode;
  attachMode: TVTNodeAttachMode;
  isFolder: boolean;
  targetParentID: integer;
begin
  sourceVNode := TBaseVirtualTree(Sender).FocusedNode;
  targetVNode := TBaseVirtualTree(Sender).DropTargetNode;
  attachMode := amAddChildLast;

  if sourceVNode <> targetVNode then
  begin
    if targetVNode <> nil then
    begin
      SourceNode := FTreeView.MVCNode[SourceVNode];
      TargetNode := FTreeView.MVCNode[TargetVNode];
      isFolder := SourceNode is TCfgDictionaryFolder;
      if TargetNode is TCfgDictionaryRoot then
        targetParentID := 0
      else
        targetParentID := (TargetNode as TCfgDictionaryFolder).FolderID;
      if isFolder then
      begin
        attachMode := amAddChildFirst;
        UpdateFolderParentID((SourceNode as TCfgDictionaryFolder).FolderID, targetParentID);
      end
      else
      begin
        attachMode := amAddChildLast;
        UpdateDictionaryParentID((SourceNode as TCfgDictionary).DicID, targetParentID);
      end;
    end
    else
    begin
      attachMode := amNoWhere;
      Effect := DROPEFFECT_NONE;
    end;
  end
  else
  begin
    attachMode := amNoWhere;
    Effect := DROPEFFECT_NONE;
  end;

  TBaseVirtualTree(Sender).ProcessDrop(DataObject, targetVNode, Effect, attachMode);
end;

end.
