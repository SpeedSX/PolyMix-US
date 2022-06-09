unit PmConfigTreeView;

interface

uses Windows,Messages,SysUtils,Graphics,VirtualTrees,Classes,StdCtrls,
     Controls,Forms,ImgList,ActiveX,

     PmConfigTree;

type
     { Here's the Viewer. I have descended from the base class to maximize
       the functionality that is moved to our code, should you be happy
       with any of the predeclared descendants use of them. }
     TMVCEditLink=class;
     TMVCTreeView=class(TVirtualStringTree)//(TBaseVirtualTree)
     private
       { This is a pointer to the structure associated with
         this viewer. }
       FTree:TMVCTree;
       FInternalDataOffset: Cardinal;               // offset to the internal data

       { Make and break the link with a list }
       procedure SetTree(aTree:TMVCTree);

       { These are for direct access to our structure
         through the viewer. You can use them to find
         the TMVCNode that corresponds to a selected
         VirtualNode for instance. }
       function GetMVCNode(VirtualNode:PVirtualNode):TMVCNode;
       procedure SetMVCNode(VirtualNode:PVirtualNode; aNode:TMVCNode);

        //function GetOptions: TVirtualTreeOptions;
        //procedure SetOptions(const Value: TVirtualTreeOptions);
     protected
       { Overridden methods of the tree, see their implementation for
         details on what they do and why they are overridden. }
       //function DoGetNodeWidth(Node: PVirtualNode; Column: TColumnIndex; Canvas: TCanvas = nil): Integer; override;
       //procedure DoPaintNode(var PaintInfo: TVTPaintInfo); override;
       procedure DoInitChildren(Node:PVirtualNode;var ChildCount:Cardinal); override;
       procedure DoInitNode(aParent,aNode:PVirtualNode;
                            var aInitStates:TVirtualNodeInitStates); override;
       procedure DoFreeNode(aNode:PVirtualNode); override;
       function DoGetImageIndex(Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
         var Ghosted: Boolean; var Index: Integer): TCustomImageList; override;
       procedure DoChecked(aNode:PVirtualNode); override;
       function DoCreateEditor(Node: PVirtualNode; Column: TColumnIndex): IVTEditLink; override;
       function InternalData(Node: PVirtualNode): Pointer;
       function InternalDataSize: Cardinal;
       function DoDragOver(Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
         var Effect: Integer): Boolean; override;
       procedure DoDragDrop(Source: TObject; DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint;
         var Effect: Integer; Mode: TDropMode); override;
       function DoBeforeDrag(Node: PVirtualNode; Column: TColumnIndex): Boolean; override;
       function DoNodeMoving(Node, NewParent: PVirtualNode): Boolean; override;
       procedure DoNodeMoved(Node: PVirtualNode); override;
       procedure DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
         var Text: WideString); override;

       //function GetOptionsClass: TTreeOptionsClass; override;
     public
       constructor Create(AOwner: TComponent); override;
       destructor Destroy; override;

       { Properties for the link to a list and the individual Node.
         these form the interface to the application. See the main form
         to check it out. }
       property Tree:TMVCTree read FTree write SetTree;
       property MVCNode[VirtualNode:PVirtualNode]:TMVCNode read GetMVCNode;

       function GetNodeText(aNode:TMVCNode;
                            aColumn:integer):string;
       procedure SetNodeText(aNode:TMVCNode;
                             aColumn:integer;
                             aText:string);
     published
       { We descend from the base class, publish whatever you want to.
         The demo only needs the Header, it is initialized in the fixed
         panel-code. }
       //property TreeOptions: TVirtualTreeOptions read GetOptions write SetOptions;
       //property Header;
       //property Images;
       //property OnChange;
     end;

   TMVCEdit = class(TCustomEdit)
    private
      FLink:TMVCEditLink;
      procedure WMChar(var Message: TWMChar); message WM_CHAR;
      procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
      procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    protected
      procedure AutoAdjustSize;
      procedure CreateParams(var Params:TCreateParams); override;
    public
      constructor Create(Link:TMVCEditLink); reintroduce;
    end;

   TMVCEditLink = class(TInterfacedObject, IVTEditLink)
   private
     FEdit:TMVCEdit;                    // a normal custom edit control
     FTree:TMVCTreeView;               // a back reference to the tree calling
     FNode:PVirtualNode;               // the node to be edited
     FColumn:Integer;                  // the column of the node
   public
     constructor Create;
     destructor Destroy; override;

     function BeginEdit: Boolean; stdcall;
     function CancelEdit: Boolean; stdcall;
     function EndEdit: Boolean; stdcall;
     function GetBounds: TRect; stdcall;
     function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
     procedure ProcessMessage(var Message: TMessage); stdcall;
     procedure SetBounds(R:TRect); stdcall;

     property Tree:TMVCTreeView read FTree;
   end;


implementation

{ The internal node-data assigned to every virtual node consist only of
  a reference to an instance of TMVCNode. }
type PMyNodeData=^TMyNodeData;
     TMyNodeData=packed record Node:TMVCNode end;

destructor TMVCTreeView.Destroy;
begin
  { When destroying the tree, break the link with the list. Note that
    we do NOT set FNodes:=NIL. By using the Set-Method it is made sure
    that the List gets notified of our demise and sets its own reference
    to NIL too. }
  Tree:=NIL;
  inherited Destroy;
end;

procedure TMVCTreeView.SetTree(aTree:TMVCTree);
begin
  if FTree=aTree then exit;

  { If we already have a list, break the link to it. }
  if Assigned(FTree) then FTree.Viewer:=NIL;

  { Now make a link to the new structure: }
  FTree:=aTree;
  if Assigned(FTree)
    then
      begin
        FTree.Viewer:=Self;
        RootNodeCount:=FTree.Root.ChildCount;
        if FTree.Root.ChildCount>0 then ValidateNode(GetFirst, False);
      end
    else RootNodeCount:=0;
end;

function TMVCTreeView.GetMVCNode(VirtualNode:PVirtualNode):TMVCNode;
begin
  { Return the reference to the TMVCNode that is represented by
    Virtualnode }
  if VirtualNode=NIL
    then Result:=NIL
    else Result:=PMyNodeData(InternalData(VirtualNode)).Node;
end;

procedure TMVCTreeView.SetMVCNode(VirtualNode:PVirtualNode;aNode:TMVCNode);
begin
  { Note the relationship between a VirtualNode and the TMVCNode it
    represents in the Nodes data. }
  PMyNodeData(InternalData(VirtualNode)).Node:=aNode;
end;

function TMVCTreeView.DoCreateEditor(Node: PVirtualNode; Column: TColumnIndex): IVTEditLink;
var Link:TMVCEditLink;
begin
  Result:=inherited DoCreateEditor(Node,Column);
  if Result=nil then
  begin
    Link:=TMVCEditLink.Create;
    Result:=Link;
  end;
end;

(*function TMVCTreeView.DoGetNodeWidth(Node: PVirtualNode; Column: TColumnIndex; Canvas: TCanvas = nil): Integer;
{ How wide is the the node in pixels. This is interesting if the graphic
  representation includes elements that are not text and whose width needs
  to be calculated. Here we draw a bar whose width corresponds to the
  value of the Incidence-property of the MVCNode. }
var N:TMVCNode;
  Text: string;
begin
  N:=GetMVCNode(Node);
  if Canvas = nil then
    Canvas := Self.Canvas;
  if not Assigned(N)
    then Result:=0
    else
      begin
        Text:=GetNodeText(N, Column);
        Result:=Canvas.TextWidth(Text);
        //if Column + 1 in [0, 1] then
        //  Result := Result + 8 + N.Incidence;
      end;
end;*)

procedure TMVCTreeView.DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
   var Text: WideString);
var
  aNode: TMVCNode;
begin
  aNode := GetMVCNode(Node);
  if aNode = nil then
    Text := ''
  else
  case Column of
    -1,0: Text := aNode.Caption;
       1: Text := aNode.SubCaption;
     else Text := '';
  end;
end;

function TMVCTreeView.GetNodeText(aNode:TMVCNode;aColumn:integer):string;
{ This method returns the text that is to be displayed in aColumn for
  the Node aNode. It is in a separate function so that it can be used
  for the calculation of width and for the actual drawing. You could
  also process the data from the actual Node as stored in your structure
  to give some other text as shown here for the third column. }
begin
  case aColumn of
    -1,0:Result:=aNode.Caption;
       1:Result:=aNode.SubCaption;
       2:{case aNode.Incidence of
             0..5:Result:='under 6';
            6..20:Result:='6 to 21';
           21..62:Result:='21 or above';
               63:Result:='Max.';
             else Result:='What?';
         end;}
         Result := '';
    else Result:='What *"§ added columns without giving data?';
  end;
end;

procedure TMVCTreeView.SetNodeText(aNode:TMVCNode;aColumn:integer;aText:string);
{ Set the text for the node and column. This is called by the editor when
  editing has finished. }
begin
  case aColumn of
    -1,0:aNode.Caption:=aText;
       1:aNode.SubCaption:=aText;
    else { Error, this column should not / cannot be edited }
  end; (* of case aColumn *)
end;

(*procedure TMVCTreeView.DoPaintNode(var PaintInfo: TVTPaintInfo);
{ Here we actually draw the graphical representation of the node. It is
  drawn one cell, i.e. Node/Column at a time. All relevant data is either
  passed as a parameter or we look it up in our TMVCNode-Structure that
  is linked to the Node via the internal data. }

var N:TMVCNode;
    SaveFontColor:TColor;
    Flags:Integer;
    TxtRect:TRect;
    NodeText:string;
    OldBrushColor,OldPenColor:TColor;

  procedure SaveDC;
  begin
    OldBrushColor:=PaintInfo.Canvas.Brush.Color;
    OldPenColor:=PaintInfo.Canvas.Pen.Color;
  end;

  procedure RestoreDC;
  begin
    PaintInfo.Canvas.Brush.Color:=OldBrushColor;
    PaintInfo.Canvas.Pen.Color:=OldPenColor;
  end;

begin
  SaveDC; { No-brainer: We save and restore every canvas-setting, we _ever_
                        change in this method. So initial and final state
                        of the canvas are of no concern. }
  try
    with PaintInfo, Canvas do
      begin
        Font:=Self.Font;

        { Get a reference to our data. If this fails bail out - this
          should not happen anyway. If it does you will notice on screen.
          Paranoics add assertions as you like. }
        N:=MVCNode[Node]; if N=NIL then exit;

        { Get the text-string to be displayed in the column. }
        NodeText:=GetNodeText(N, Column);

        { Some shuffling of feet and rectangles. Try for yourself what
          happens here be adding offsets, changing colors etc.. }
        if (toHotTrack in Self.TreeOptions.PaintOptions) and
           (Node=HotNode)
          then Font.Style:=Font.Style+[fsUnderline]
          else Font.Style:=Font.Style-[fsUnderline];

        if vsSelected in Node.States
          then
            begin
              if Focused
                then { Selected, focused }
                  begin
                    Brush.Color:=clHighLight;
                    Font.Color:=clWhite;
                  end
                else { Selected, non-focused }
                  begin
                    Brush.Color:=clBtnFace;
                    Font.Color:=Self.Font.Color;
                  end;
              { Fill out the entire rectangle }
              FillRect(ContentRect);
            end
          else { not selected, see Mikes samples on what is going on... }
            if Node=DropTargetNode
              then
                begin
                  if LastDropMode=dmOnNode
                    then
                      begin
                        Brush.Color:=clHighLight;
                        Font.Color:=clWhite;
                      end
                    else
                      begin
                        Brush.Style:=bsClear;
                        Font.Color:=Self.Font.Color;
                      end;
                  FillRect(ContentRect);
                end;

        if Focused
           and (FocusedNode=Node) and
           not(toFullRowSelect in Self.TreeOptions.SelectionOptions)
          then
            begin
              if Self.Color=clGray
                then Brush.Color:=clWhite
                else Brush.Color:=clBlack;
              SaveFontColor:=Font.Color;
              Font.Color:=Self.Color;
              Windows.DrawFocusRect(Handle,ContentRect);
              Font.Color:=SaveFontColor;
            end;

        { Disabled node color overrides all other variants }
        if vsDisabled in Node.States then Font.Color:=clBtnShadow;

        {if Column+1 in [0,1] then
          begin
            // Draw the Incidence-Bar
            Pen.Color:=clBlack;
            Brush.Style:=bsSolid;
            // Mix a color for an incidence-value
            Brush.Color:= RGB(4 * N.Incidence, 128, 255 - 4 * N.Incidence);
            Rectangle(ContentRect.Left+2,
                      ContentRect.Top+2,
                      ContentRect.Left+2+N.Incidence,
                      ContentRect.Bottom-2);
          end;}

        { Paint corresponding text }
        Brush.Color:=Color;
        SetBkMode(Handle,TRANSPARENT);

        TxtRect.Left:=  ContentRect.Left;
        TxtRect.Top:=   ContentRect.Top;
        TxtRect.Right:= ContentRect.Right;
        TxtRect.Bottom:=ContentRect.Bottom;
        {if Column+1 in [0,1]
          then TxtRect.Left:=TxtRect.Left+6+N.Incidence;}
        Flags:=DT_LEFT or DT_SINGLELINE or DT_VCENTER;
        DrawText(Handle,PChar(NodeText),Length(NodeText),TxtRect,Flags);
      end; { of with Canvas }
  finally
    RestoreDC;
  end;
end;
*)
procedure TMVCTreeView.DoFreeNode(aNode:PVirtualNode);
{ A virtual node is being freed by the tree. Make sure the associated Node
  loses its pointer to the node. }
var N:TMVCNode;
begin
  N:=MVCNode[aNode];
  if Assigned(N) then
    begin
      N.VirtualNode:=NIL;
      SetMVCNode(aNode,NIL);
    end;
  inherited DoFreeNode(aNode);
end;

procedure TMVCTreeView.DoInitChildren(Node:PVirtualNode;var ChildCount:Cardinal);
begin
  inherited DoInitChildren(Node,ChildCount);
  ChildCount:=MVCNode[Node].ChildCount;
end;

procedure TMVCTreeView.DoInitNode(aParent,aNode:PVirtualNode;
                                  var aInitStates:TVirtualNodeInitStates);
{ The tree has just allocated a new virtual node. Link it to the TMVCNode
  it is to represent. }
var P,I:TMVCNode;
begin
  inherited DoInitNode(aParent,aNode,aInitStates);
  with aNode^ do
    begin
      { Wich MVCNode corresponds to the virtual node being initialized?
        Find the Parent-MVCNode via the Parent-VirtualNode }
      if (aParent=RootNode) or (aParent=NIL)
        then P:=FTree.Root
        else P:=MVCNode[aParent];
      { MVCNode we are looking for is child number aIndex. }
      I:=P.Child[Index];

      { Now set all the data the Treeview needs plus our link to the node }
      SetMVCNode(aNode,I);
      I.VirtualNode:=aNode;

      if I.ChildCount>0
        then Include(aInitStates,ivsHasChildren)
        else Exclude(aInitStates,ivsHasChildren);
      CheckState:=I.CheckState;
    end;
end;

function TMVCTreeView.DoGetImageIndex(Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var Index: Integer): TCustomImageList;
{ The tree requests the image-index for a Node and column. }
var N:TMVCNode;
begin
  case Column of
    -1,0:begin
           { We only want Icons in the first column. Ask the node which
             one it wants. }
           N:=MVCNode[Node];
           if N=NIL { No node assigned, this should not happen. }
             then Index:=-1
             else Index:=N.GetImageIndex;
         end;
    else Index:=-1;
  end;
  Result := nil;
end;

procedure TMVCTreeView.DoChecked(aNode:PVirtualNode);
{ In the tree a node has been checked, unchecked or whatever change to
  the CheckState happens. Propagate that to the TMVCNode. }
var N:TMVCNode;
begin
  if Assigned(FTree) then
    begin
      N:=MVCNode[aNode];
      if Assigned(N) then N.CheckState:=aNode^.CheckState;
    end;
  inherited DoChecked(aNode);
end;

function TMVCTreeView.InternalData(Node: PVirtualNode): Pointer;

begin
  if (Node = RootNode) or (Node = nil) then
    Result := nil
  else
    Result := PAnsiChar(Node) + FInternalDataOffset;
end;

function TMVCTreeView.InternalDataSize: Cardinal;
begin
  // The size of the internal data this tree class needs.
  Result := SizeOf(TMyNodeData);
end;

constructor TMVCEditLink.Create;
begin
  inherited;
  FEdit := TMVCEdit.Create(Self);
  with FEdit do
  begin
    Visible := False;
    Ctl3D := False;
    BorderStyle := bsSingle;
    AutoSize := False;
  end;
end;

destructor TMVCEditLink.Destroy;
begin
  FEdit.Free;
  inherited;
end;

function TMVCEditLink.BeginEdit: Boolean;
begin
  Result := True;
  FEdit.Show;
  FEdit.SetFocus;
end;

function TMVCEditLink.CancelEdit: Boolean;
begin
  Result := True;
  // to show the kill focus handler that we don't need a second notification for the tree
  FTree:=nil;
  FEdit.Hide;
end;

function TMVCEditLink.EndEdit: Boolean;
var LastTree:TMVCTreeView;
    MVCNode:TMVCNode;
begin
  Result := True;
  try
    if Assigned(FTree) then
    begin
      if FEdit.Modified then
      begin
        MVCNode:=FTree.MVCNode[FNode];
        // keep tree reference because the application might want to change the focuse while
        // processing the NewText event
        LastTree:=FTree;
        FTree:=nil;

        LastTree.SetNodeText(MVCNode,FColumn,FEdit.Caption);
      end;
      FTree:=nil;
    end;
  finally
    FEdit.Hide;
  end;
end;

function TMVCEditLink.GetBounds: TRect;
begin
  Result:=FEdit.BoundsRect;
end;

function TMVCEditLink.PrepareEdit(Tree:TBaseVirtualTree;Node:PVirtualNode;Column:TColumnIndex): Boolean;
// retrieves the true text bounds from the owner tree
var R:TRect;
    MVCNode:TMVCNode;
begin
  Result := True;
  FTree:=Tree as TMVCTreeView;

  FNode:=Node;
  FColumn:=Column;

  MVCNode:=FTree.MVCNode[Node];

  FEdit.Caption:=FTree.GetNodeText(MVCNode,Column);
  FEdit.Parent:=Tree;
  R:=FTree.GetDisplayRect(Node,Column,True);

  { In the primary column there is the "Incidence-Bar". Adjust the left
    side of the rect to exclude it }
  //if Column+1 in [0,1] then R.Left:=R.Left+MVCNode.Incidence;

  with R do
    begin
      // set the edit's bounds but make sure there's a minimum width and the right border does not
      // extend beyond the parent's right border
      if Right-Left<50 then Right:=Left+50;
      if Right>FTree.Width then Right:=FTree.Width;
      FEdit.SetBounds(Left,Top,Right-Left,Bottom-Top);
      FEdit.Font:=FTree.Font;
    end;
end;

procedure TMVCEditLink.SetBounds(R: TRect);
begin
  // ignore this one as we get here the entire node rect but want the minimal text bounds
end;

constructor TMVCEdit.Create(Link:TMVCEditLink);
begin
  inherited Create(nil);
  ShowHint:=False;
  ParentShowHint:=False;
  FLink:=Link;
end;

procedure TMVCEdit.WMChar(var Message: TWMChar);
// handle character keys
begin
  // avoid beep
  if Message.CharCode <> VK_ESCAPE then
  begin
    inherited;
    if Message.CharCode > $20 then AutoAdjustSize;
  end;
end;

procedure TMVCEdit.WMKeyDown(var Message: TWMKeyDown);
// handles some control keys (either redirection to tree, edit window size or clipboard handling)
begin
  case Message.CharCode of
    // pretend these keycodes were send to the tree
    VK_ESCAPE,
    VK_UP,
    VK_DOWN:
      FLink.FTree.WndProc(TMessage(Message));
    VK_RETURN:
      FLink.FTree.DoEndEdit;
    // standard clipboard actions,
    // Caution: to make these work you must not use default TAction classes like TEditPaste etc. in the application!
    Ord('C'):
      if (Message.KeyData and MK_CONTROL) <> 0 then CopyToClipboard;
    Ord('X'):
      if (Message.KeyData and MK_CONTROL) <> 0 then
      begin
        CutToClipboard;
        AutoAdjustSize;
      end;
    Ord('V'):
      if (Message.KeyData and MK_CONTROL) <> 0 then
      begin
        PasteFromClipboard;
        AutoAdjustSize;
      end;
  else
    inherited;
    // second level for keys to be passed to its target
    case Message.CharCode of
      VK_BACK,
      VK_DELETE:
        AutoAdjustSize;
    end;
  end;
end;

procedure TMVCEdit.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  // FLink.FTree is set to nil if the link doesn't need to notify the tree (e.g. hiding the edit causes
  // a kill focus message)
  if Assigned(FLink.FTree) then FLink.FTree.DoCancelEdit;
end;

procedure TMVCEdit.AutoAdjustSize;
var
  DC: HDC;
  Size: TSize;
  EditRect,
  TreeRect: TRect;
begin
  DC := GetDc(Handle);
  GetTextExtentPoint32(DC, PChar(Text), Length(Text), Size);
  // determine minimum and maximum sizes
  if Size.cx < 50 then Size.cx := 50;
  EditRect := ClientRect;
  MapWindowPoints(Handle, HWND_DESKTOP, EditRect, 2);
  TreeRect := FLink.FTree.ClientRect;
  MapWindowPoints(FLink.FTree.Handle, HWND_DESKTOP, TreeRect, 2);
  if (EditRect.Left + Size.cx) > TreeRect.Right then Size.cx := TreeRect.Right - EditRect.Left;
  SetWindowPos(Handle, 0, 0, 0, Size.cx, Height, SWP_NOMOVE or SWP_NOOWNERZORDER or SWP_NOZORDER);
  ReleaseDC(Handle, DC);
end;

procedure TMVCEdit.CreateParams(var Params:TCreateParams);
begin
  Ctl3D := False;
  inherited;
end;

procedure TMVCEditLink.ProcessMessage(var Message: TMessage);
begin
  // nothing to do
end;

constructor TMVCTreeView.Create(AOwner: TComponent);
begin
  inherited;
  FInternalDataOffset := AllocateInternalDataArea(SizeOf(Cardinal));
end;

{function TMVCTreeView.GetOptions: TVirtualTreeOptions;
begin
  Result := inherited TreeOptions as TVirtualTreeOptions;
end;

procedure TMVCTreeView.SetOptions(const Value: TVirtualTreeOptions);
begin
  TreeOptions.Assign(Value);
end;

function TMVCTreeView.GetOptionsClass: TTreeOptionsClass;
begin
  Result := TVirtualTreeOptions;
end;}

function TMVCTreeView.DoDragOver(Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
   var Effect: Integer): Boolean;
var
  TargetNode: PVirtualNode;
  CurMVCNode, TargetMVCNode: TMVCNode;
begin
  Result := inherited DoDragOver(Source, Shift, State, Pt, Mode, Effect);
  //if Result then
  //begin
    TargetNode := GetNodeAt(Pt.X, Pt.Y);
    TargetMVCNode := GetMVCNode(TargetNode);
    if TargetMVCNode <> nil then
    begin
      CurMVCNode := GetMVCNode(FocusedNode);
      Result := CurMVCNode.CanMove and TargetMVCNode.CanAddMovingChild(CurMVCNode);
    end;
  //end;
end;

procedure TMVCTreeView.DoDragDrop(Source: TObject; DataObject: IDataObject;
   Formats: TFormatArray; Shift: TShiftState; Pt: TPoint;
   var Effect: Integer; Mode: TDropMode);
var
  TargetMVCNode: TMVCNode;
  CurMVCNode: TMVCNode;
begin
  inherited DoDragDrop(Source, DataObject, Formats, Shift, Pt, Effect, Mode);
  TargetMVCNode := GetMVCNode(DropTargetNode);
  CurMVCNode := GetMVCNode(FocusedNode);
  CurMVCNode.Parent.MoveChild(CurMVCNode, TargetMVCNode);
end;

function TMVCTreeView.DoNodeMoving(Node, NewParent: PVirtualNode): Boolean;
begin
  Result := true;
{var
  CurMVCNode: TMVCNode;
  TargetMVCNode: TMVCNode;
begin
  TargetMVCNode := GetMVCNode(NewParent);
  CurMVCNode := GetMVCNode(FocusedNode);
  Result := TargetMVCNode.CanAddMovingChild(CurMVCNode);}
end;

procedure TMVCTreeView.DoNodeMoved(Node: PVirtualNode);
begin
  inherited DoNodeMoved(Node);
end;

function TMVCTreeView.DoBeforeDrag(Node: PVirtualNode; Column: TColumnIndex): Boolean;
begin
  inherited DoBeforeDrag(Node, Column);
  Result := true;
end;

end.
