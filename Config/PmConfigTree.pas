unit PmConfigTree;

interface

uses Windows,Messages,SysUtils,Graphics,VirtualTrees,Classes,StdCtrls,
     Controls,Forms,ImgList;

type { TMVCNode is the encapsulation of a single Node in the structure.
       This implementation is a bit bloated because in my project
       everything is in memory at all times.
       In such an implementation there is not much "virtual" about the
       tree anymore - still it's of incredible usefulness as you will
       see. }
     TNodeClass = class of TMVCNode;
     TMVCNode=class(TObject)
       private
         { Here's the data associated with a single Node in the
           tree. This structure defines a caption and a subcaption, add
           whatever defines your data completely. }
         FParent:TMVCNode;
         FChildren:TList;
         FCheckState:TCheckState;
         FCaption,FSubCaption:string;
         { The FIncidence-Field is special in the way that it's
           value is never displayed directly but used to
           graphically alter the node's display. In my project it
           is a "weight" showing the number of hits from a
           database. Here it is displayed next to the caption
           as a colored speck. }
         //FIncidence:integer;

        { Here's where we start to think of visualization. This
          field points to the VirtualNode in a virtual tree that
          is associated with the Node - if there is one,
          otherwise it is NIL, there may be no virtual node
          allocated for the TMVCNode or no tree linked. }
         FVirtualNode:PVirtualNode;

         { Here are reader/writer-methods for the properties that
           define our data. We need set-properties because we want
           to update linked nodes directly. }
         procedure SetCaption(aCaption:string);
         procedure SetSubCaption(aSubCaption:string);
         procedure SetCheckState(aCheckState:TCheckState);
         //procedure SetIncidence(aValue:integer);
         function GetChildCount:integer;
         function GetChild(n:integer):TMVCNode;
       protected
         FCanMove, FCanAddChild: boolean;
       public
         constructor Create; virtual;
         destructor Destroy; override;

         { Take a look at our data and pick an icon from the
           Imagelist to be displayed in the tree. }
         function GetImageIndex:integer; virtual;
         { Tell the tree to invalidate the node it displayes the
           information for this Node in. It will be repainted
           next }
         procedure InvalidateVirtualNode;

         { properties exposing our internal data to the world.
           set-methods are given so the Node can always invalidate
           its node. }
         property CheckState:TCheckState read FCheckState write SetCheckState;
         property Caption:string read FCaption write SetCaption;
         property SubCaption:string read FSubCaption write SetSubCaption;
         //property Incidence:integer read FIncidence write SetIncidence;

         property Parent:TMVCNode read FParent;
         property ChildCount:integer read GetChildCount;
         property Child[n:integer]:TMVCNode read GetChild;
         property CanMove: boolean read FCanMove;
         property CanAddChild: boolean read FCanAddChild;

         function CreateChild(NodeType: TNodeClass): TMVCNode;
         procedure RemoveChild(n:integer);
         procedure MoveChild(ChildNode, NewParent: TMVCNode);
         procedure DestroyChild(n:integer);

         { This field is only exposed because I advise you to put
           the Tree-Code in a separate unit and then you won't get
           far privatizing it. Allowing public write-access to it
           is a bit hairy though, you should never write to the
           field outside of this or the Tree-unit.
           This is where a friend-declaration is missing from OP}
         property VirtualNode:PVirtualNode read FVirtualNode write FVirtualNode;

         function CanAddMovingChild(aNode: TMVCNode): boolean;

         // определяет можно ли добавлять дочерний узел к текущему.
         // перекрывается в наследниках.
         function DoCanAddMovingChild(aNode: TMVCNode): boolean; virtual;

         function IsParentOf(aNode: TMVCNode): boolean;

         // Возвращает по возможности уникальный идентификатор узла для сохранения состояния дерева
         function GetUniqueID: string; virtual;
       end;

     { TMVCTree keeps the TMVCNodes. It also maintains the link to a
       virtual treeview. }
     TMVCTree=class
       private
         { This is the Root of the Tree. In this Demo that Root is there
           purely to hold the structure together, it is never displayed -
           just like TVirtualTrees own Root. }
         FRoot:TMVCNode;

         { The Viewer-Field points to any component or object
           used to visualize or edit this structure. It is
           not really used in this demo, in a real application
           you will find situations where you have to find out
           whether you are linked and if so where to.

           Why is the Viewer declared as TObject and not as
           the specific class? Two reasons:

           1) The viewer should be implemented in a different
              unit, either there or here you will have to
              cast or you will build a circular reference. I
              choose to cast here because

           2) You may want to have _different_ viewers for
              the same structure. Keeping that in mind you
              may even want to change the declaration to
              a list of linked viewers... }
         FSettingViewer:integer;
         FViewer:TObject;

         { Access-methods to expose the list in a type safe
           way. }

         { A set-method that updates the link to a viewer. }
         procedure SetViewer(aViewer:TObject);

       public
         constructor Create; 
         destructor Destroy; override;

         property Root:TMVCNode read FRoot;

         { Assign to this to create or break the link with
           a viewer. If you are about to add, remove or edit
           a zillion Nodes you can call BeginUpdate and
           EndUpdate. In this demo they just do the same for
           any assigned viewer - Caution: The demo does not
           make provisions for the case where you call
           BeginUpdate and then switch to another viewer! }
         property Viewer:TObject read FViewer write SetViewer;
         procedure BeginUpdate;
         procedure EndUpdate;
       end;

implementation

uses PmConfigTreeView;

constructor TMVCNode.Create;
begin
  inherited Create;
  FChildren:=TList.Create;
end;

destructor TMVCNode.Destroy;
begin
  if Assigned(FParent) then
    with FParent do
      RemoveChild(FChildren.IndexOf(Self));
  { When destroying free all children. }
  while ChildCount>0 do DestroyChild(0);

  inherited Destroy;
end;

function TMVCNode.GetImageIndex:integer;
begin
  { Take a close look at your data and return the index of whatever image
    you want next to it. Here we base the choice on the length of the
    caption. No caption, no icon. }
  {if Caption=''
    then Result:=-1 else Result:=(Length(Caption) mod 4);}
  Result := -1;
end;

procedure TMVCNode.InvalidateVirtualNode;
var T:TBaseVirtualTree;
begin
  { If the tree has a node that displays this Node then invalidate it. }
  if Assigned(FVirtualNode) then
  begin
    T := TreeFromNode(FVirtualNode);
    T.InvalidateNode(FVirtualNode);
  end;
end;

procedure TMVCNode.SetCheckState(aCheckState:TCheckState);
begin
  { Update the checkstate that is stored in our Node. If the tree has a
    node for the Node then invalidate it. }
  if aCheckState=FCheckstate then exit;
  FCheckState:=aCheckState;
  if Assigned(FVirtualNode) then FVirtualNode.CheckState:=aCheckState;
  InvalidateVirtualNode;
end;

(*procedure TMVCNode.SetIncidence(aValue:integer);
begin
  { Set the Nodes property Incidence and invalidate the node in the tree
    if there is one. We fix the value into its valid range. }
  if aValue=FIncidence then exit;
  FIncidence:=aValue;
  if FIncidence<0
    then FIncidence:=0
    else
      if FIncidence>63
        then FIncidence:=63;
  InvalidateVirtualNode;
end;*)

procedure TMVCNode.SetCaption(aCaption:string);
begin
  { Set the Nodes property Caption and invalidate the node in the tree
    if there is one. }
  if aCaption=FCaption then exit;
  FCaption:=aCaption;
  InvalidateVirtualNode;
end;

procedure TMVCNode.SetSubCaption(aSubCaption:string);
begin
  { Set the Nodes property Subcaption and invalidate the node in the tree
    if there is one. }
  if aSubCaption=FSubCaption then exit;
  FSubCaption:=aSubCaption;
  InvalidateVirtualNode;
end;

function TMVCNode.GetChildCount:integer;
begin
  Result := FChildren.Count;
end;

function TMVCNode.GetChild(n:integer):TMVCNode;
begin
  Result:=TMVCNode(FChildren[n]);
end;

function TMVCNode.CreateChild(NodeType: TNodeClass): TMVCNode;
begin
  Result := NodeType.Create;
  Result.FParent := Self;
  FChildren.Add(Result);
  if Assigned(FVirtualNode) then
    with TreeFromNode(FVirtualNode) do
    begin
      ReinitNode(FVirtualNode,False);
      InvalidateToBottom(FVirtualNode);
    end;
end;

procedure TMVCNode.RemoveChild(n:integer);
var C:TMVCNode;
begin
  { Remove Child number n from our Children-List and the tree }
  C:=Child[n];
  C.FParent:=NIL;
  FChildren.Delete(n);
  if Assigned(C.FVirtualNode) then
    TreeFromNode(C.FVirtualNode).DeleteNode(C.FVirtualNode);
end;

procedure TMVCNode.MoveChild(ChildNode, NewParent: TMVCNode);
begin
  ChildNode.FParent := NewParent;
  FChildren.Remove(ChildNode);
  NewParent.FChildren.Add(ChildNode);
  if Assigned(ChildNode.FVirtualNode) then
    TreeFromNode(ChildNode.FVirtualNode).MoveTo(ChildNode.VirtualNode,
      NewParent.VirtualNode, amAddChildLast, false);
end;

procedure TMVCNode.DestroyChild(n:integer);
var C:TMVCNode;
begin
  C:=Child[n];
  RemoveChild(n);
  C.Free;
end;

function TMVCNode.IsParentOf(aNode: TMVCNode): boolean;
var
  NextParent: TMVCNode;
begin
  Result := false;
  NextParent := aNode.Parent;
  while (NextParent <> nil) and not Result do
  begin
    Result := Self = NextParent;
    NextParent := NextParent.Parent;
  end;
end;

function TMVCNode.CanAddMovingChild(aNode: TMVCNode): boolean;
begin
  Result := FCanAddChild and (aNode <> Self) and not aNode.IsParentOf(Self)
    and (aNode.Parent <> Self)
    and DoCanAddMovingChild(aNode);
end;

function TMVCNode.DoCanAddMovingChild(aNode: TMVCNode): boolean;
begin
  Result := true;
end;

// Возвращает по возможности уникальный идентификатор узла для сохранения состояния дерева
function TMVCNode.GetUniqueID: string;
begin
  Result := ClassName;
end;

{$REGION 'TMVCTree'}

constructor TMVCTree.Create;
begin
  inherited Create;
  FRoot:=TMVCNode.Create;
end;

destructor TMVCTree.Destroy;
begin
  { Upon destruction we need to break the link to the Viewer and free
    all our Nodes and last the list itself. }
  Viewer:=NIL;
  FRoot.Free;
  FRoot:=NIL;
  inherited Destroy;
end;

procedure TMVCTree.SetViewer(aViewer:TObject);
begin
  { Assign a viewer, De-Assign a viewer (by passing NIL) and assigning
    a different viewer than the one that is already linked. }

  { Prevent recursion when the viewer itself sets this property. }
  if FSettingViewer>0 then exit;

  inc(FSettingViewer);
  try
    { First de-assign any viewer that is already linked. }
    if Assigned(FViewer) then TMVCTreeView(FViewer).Tree:=NIL;
    { Set our field to point to the new viewer. }
    FViewer:=aViewer;
    { Now assign this List to the new viewer. }
    if Assigned(FViewer) then TMVCTreeView(FViewer).Tree:=Self;
  finally
    dec(FSettingViewer);
  end;
end;

procedure TMVCTree.BeginUpdate;
begin
  if Assigned(FViewer) then TMVCTreeView(FViewer).BeginUpdate;
end;

procedure TMVCTree.EndUpdate;
begin
  if Assigned(FViewer) then TMVCTreeView(FViewer).EndUpdate;
end;

{$ENDREGION}

end.
