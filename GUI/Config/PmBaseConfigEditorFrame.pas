unit PmBaseConfigEditorFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Menus, JvExControls, JvGradientHeaderPanel,

  PmConfigTree;

type
  TBaseConfigEditorFrame = class(TFrame)
    paHeaderPanel: TJvGradientHeaderPanel;
  protected
    FNode: TMVCNode;
    procedure SetNode(ANode: TMVCNode); virtual;
  public
    constructor Create(Owner: TComponent);
    function AllowLeaveEditor: boolean; virtual;
    function GetPopupMenu: TPopupMenu; virtual;
    property Node: TMVCNode read FNode write SetNode;
  end;

implementation

{$R *.dfm}

constructor TBaseConfigEditorFrame.Create(Owner: TComponent);
begin
  inherited Create(Owner);
end;

procedure TBaseConfigEditorFrame.SetNode(ANode: TMVCNode);
begin
  FNode := ANode;
  paHeaderPanel.LabelCaption := FNode.Caption;
end;

function TBaseConfigEditorFrame.GetPopupMenu: TPopupMenu;
begin
  Result := nil;
end;

function TBaseConfigEditorFrame.AllowLeaveEditor: boolean;
begin
  Result := true;
end;

end.
