unit PmGantt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvComponentBase, JvBalloonHint;

type
  TGanttFrame = class(TFrame)
    JvBalloonHint1: TJvBalloonHint;
  private
    FWorkloads: TList;
    FTimeLines: TList;
    procedure CreateTimeLines;
  public
    constructor Create(Owner: TComponent; _Workloads: TList);
    destructor Destroy; override;
    property TimeLines: TList read FTimeLines;
  end;

implementation

uses PmTimeLine, PmPlan;

{$R *.dfm}

const
  TL_HEIGHT = 80;
  TL_SPACE = 10;
  LABEL_OFFSET = 10;
  LR_OFFSET = 10;
  TOP_OFFSET = 5;

constructor TGanttFrame.Create(Owner: TComponent; _Workloads: TList);
begin
  inherited Create(Owner);
  FWorkloads := _Workloads;

  CreateTimeLines;
end;

destructor TGanttFrame.Destroy;
begin
  FTimeLines.Free;
  inherited;
end;

procedure TGanttFrame.CreateTimeLines;
var
  I: Integer;
  tl: TSingleTimeLine;
  lb: TLabel;
  w: TWorkload;
  MaxLabelWidth: integer;
  tb: TList;
begin
  if FTimeLines <> nil then
    FreeAndNil(FTimeLines);

  FTimeLines := TList.Create;
  MaxLabelWidth := 0;
  for I := 0 to FWorkloads.Count - 1 do
  begin
    w := TWorkload(FWorkloads[I]);
    lb := TLabel.Create(Self);
    lb.Parent := Self;
    lb.Left := LABEL_OFFSET;
    lb.Top := i * TL_HEIGHT + i * TL_SPACE + TOP_OFFSET * 2;
    lb.Caption := w.EquipName;
    if MaxLabelWidth < lb.Width then
      MaxLabelWidth := lb.Width;
  end;
  for I := 0 to FWorkloads.Count - 1 do
  begin
    tl := TSingleTimeLine.Create(Self);
    tl.Parent := Self;
    tl.Left := MaxLabelWidth + LABEL_OFFSET + LR_OFFSET;
    tl.Top := i * TL_HEIGHT + TOP_OFFSET;
    tl.Height := TL_HEIGHT;
    tl.Width := Self.Width - LR_OFFSET * 2;
    tl.Anchors := [akLeft, akTop, akRight];

    tl.BalloonHint := JvBalloonHint1;

    tb := TList.Create;
    tl.TimeBlocks := tb;
    FTimeLines.Add(tl);
  end;
end;

end.
