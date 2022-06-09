unit PmTimeLine;

interface

uses Classes, Graphics, DateUtils, Controls, ExtCtrls, Windows, JvBalloonHint;

type
  TTimeBlock = class(TObject)
  public
    JobID: integer;
    Start, Finish: TDateTime;
    Comment: string;
    Color: TColor;
    Rect: TRect;
    Selected: boolean;
    ShowAlert: boolean;
  end;

  TSingleTimeLine = class(TShape)
  private
    FStartTime, FFinishTime: TDateTime;
    FTimeBlocks: TList;
    FRulerHeight: integer;
    FBalloonHint: TJvBalloonHint;
    FSelectedBlock, FPrevSelectedBlock: TTimeBlock;
    FOnBlockSelected: TNotifyEvent;
    FEmptyColor: TColor;
    function GetTimeText(ATime: TDateTime): string;
    procedure SetStartTime(const Value: TDateTime);
    procedure SetFinishTime(const Value: TDateTime);
    procedure SetTimeBlocks(const Value: TList);
    procedure UpdateHint;
    procedure DoOnMouseLeave(Sender: TObject);
  protected
    procedure Paint; override;
    procedure Click; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    function GetBlockUnderCursor(PosX, PosY: integer): TTimeBlock; virtual;
  public
    constructor Create(Owner: TComponent);
    destructor Destroy; override;
    property EmptyColor: TColor read FEmptyColor write FEmptyColor;
    property StartTime: TDateTime read FStartTime write SetStartTime;
    property FinishTime: TDateTime read FFinishTime write SetFinishTime;
    property TimeBlocks: TList read FTimeBlocks write SetTimeBlocks;
    property BalloonHint: TJvBalloonHint read FBalloonHint write FBalloonHint;
    property SelectedBlock: TTimeBlock read FSelectedBlock;
    property OnBlockSelected: TNotifyEvent read FOnBlockSelected write FOnBlockSelected;
  end;

const
  BLOCK_COLOR = clSkyBlue;

implementation

uses SysUtils;

const
  HINT_MS = 12000;

constructor TSingleTimeLine.Create(Owner: TComponent);
begin
  inherited;
  FRulerHeight := 16;
  OnMouseLeave := DoOnMouseLeave;
  FEmptyColor := clWhite;
end;

destructor TSingleTimeLine.Destroy;
begin
  FTimeBlocks.Free;
  inherited;
end;

function TSingleTimeLine.GetTimeText(ATime: TDateTime): string;
begin
  Result := FormatDateTime('hh:nn', ATime);
end;

procedure TSingleTimeLine.Paint;
var
  I: Integer;
  PenWidth: Integer;
  Hours: Int64;
  X, Y, W, HBlock, WBlock, XBlockEnd: Integer;
  Block: TTimeBlock;
begin
  //inherited Paint;
  Canvas.Pen := Pen;
  Canvas.Brush := Brush;
  Brush.Color := FEmptyColor;
  with Canvas do
  begin
    Font.Name := 'Tahoma';
    Font.Height := 10;
    //Brush.Color := BLOCK_COLOR;
    PenWidth := Pen.Width;
    W := Width - PenWidth * 2;
    Y := PenWidth;
    HBlock := Height - FRulerHeight;
    // общий прямоугольник
    Rectangle(0, 0, Width - PenWidth * 2, Y + HBlock + 1);
    Hours := HoursBetween(StartTime, FinishTime);
    for I := 0 to Hours - 1 do    // Iterate
    begin
      X := Trunc((I / Hours) * Width);
      MoveTo(X, Y + HBlock + 1);
      LineTo(X, Height - 5);
      Brush.Style := bsClear;
      TextOut(X + 1, Y + HBlock + 2, GetTimeText(IncHour(FStartTime, I)));
    end;    // for
  end;    // with
  if FTimeBlocks <> nil then
  begin
    with Canvas do
    begin
      for I := 0 to FTimeBlocks.Count - 1 do
      begin
        Pen.Width := 0;
        Pen.Style := psClear;
        Block := TTimeBlock(FTimeBlocks[i]);
        X := Trunc(W * (SecondsBetween(FStartTime, Block.Start) * 1.0 / (Hours * 3600)));
        if X < 0 then X := 0;
        WBlock := Trunc(W * (SecondsBetween(Block.Start, Block.Finish) * 1.0 / (Hours * 3600)));
        XBlockEnd := X + WBlock + 1;
        if XBlockEnd > Width then XBlockEnd := Width;
        Brush.Color := Block.Color;
        if Block.Selected then
        begin
          Pen.Style := psSolid;
          Pen.Color := clHighlight;
          Pen.Width := 1;
        end;
        Rectangle(X + 1, Y, XBlockEnd, Y + HBlock + 1);
        // сохранить координаты
        Block.Rect.Left := X;
        Block.Rect.Top := Y;
        Block.Rect.Right := XBlockEnd;
        Block.Rect.Bottom := Y + HBlock;
        // Линия на конце блока
        Pen.Width := PenWidth;
        Pen.Style := psSolid;
        MoveTo(X + WBlock, Y);
        LineTo(X + WBlock, Y + HBlock);
      end;
    end;
  end;
end;

procedure TSingleTimeLine.SetStartTime(const Value: TDateTime);
begin
  if FStartTime <> Value then
  begin
    FStartTime := Value;
  end;
end;

procedure TSingleTimeLine.SetFinishTime(const Value: TDateTime);
begin
  if FFinishTime <> Value then
  begin
    FFinishTime := Value;
  end;
end;

procedure TSingleTimeLine.SetTimeBlocks(const Value: TList);
begin
  FSelectedBlock := nil;
  UpdateHint;
  if FTimeBlocks <> Value then
  begin
    FTimeBlocks.Free;
    FTimeBlocks := Value;
  end;
end;

procedure TSingleTimeLine.Click;
var
  CurBlock: TTimeBlock;
  //p: TPoint;
begin
  inherited Click;
  CurBlock := GetBlockUnderCursor(Mouse.CursorPos.X, Mouse.CursorPos.Y);
  if CurBlock <> nil then
  begin
    FSelectedBlock := CurBlock;
    UpdateHint;
    if Assigned(FOnBlockSelected) then
      FOnBlockSelected(Self);
    //p := ClientToScreen(Mouse.CursorPos);
  end
  else
  begin
    FSelectedBlock := nil;
    UpdateHint;
  end;
end;

function TSingleTimeLine.GetBlockUnderCursor(PosX, PosY: integer): TTimeBlock;
var
  I: Integer;
  Block: TTimeBlock;
begin
  Result := nil;
  if FTimeBlocks <> nil then
  begin
    for I := 0 to FTimeBlocks.Count - 1 do
    begin
      Block := TTimeBlock(FTimeBlocks[i]);
      if (Block.Rect.Left > PosX) or (Block.Rect.Right < PosX) then
        continue;
      if (Block.Rect.Left < PosX) and (Block.Rect.Right > PosX) then
      begin
        Result := Block;
        break;
      end;
    end;
  end;
end;

procedure TSingleTimeLine.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Block: TTimeBlock;
begin
  inherited MouseMove(Shift, X, Y);
  Block := GetBlockUnderCursor(X, Y);
  if Block <> nil then
  begin
    FSelectedBlock := Block;
    UpdateHint;
  end
  else
  begin
    FSelectedBlock := nil;
    UpdateHint;
  end;
end;

procedure TSingleTimeLine.UpdateHint;
var
  R: TRect;
  Icon: TjvIconKind;
begin
  if FSelectedBlock <> nil then
  begin
    if FSelectedBlock <> FPrevSelectedBlock then
    begin
      R := FSelectedBlock.Rect;
      R.TopLeft := ClientToScreen(R.TopLeft);
      R.BottomRight := ClientToScreen(R.BottomRight);
      if FSelectedBlock.ShowAlert then
        Icon := ikWarning
      else
        Icon := ikInformation;
      FBalloonHint.ActivateHintRect(R, FSelectedBlock.Comment, '', HINT_MS, Icon);
    end;
  end
  else
  begin
    if FBalloonHint.Active then
      FBalloonHint.CancelHint;
  end;
  FPrevSelectedBlock := FSelectedBlock;
end;

procedure TSingleTimeLine.DoOnMouseLeave(Sender: TObject);
begin
  FSelectedBlock := nil;
  UpdateHint;
end;

end.
