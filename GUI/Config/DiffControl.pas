unit DiffControl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, ShellApi;

type

  TDropFilesEvent = procedure(Sender: TObject;
    dropHandle: integer; var DropHandled: boolean) of object;

  TDiffLines = class(TStringList)
  private
    function GetClrIndex(index: integer): integer;
    procedure SetClrIndex(index, NewClrIndex: integer);
    function GetLineNum(index: integer): integer;
    procedure SetLineNum(index, NewLineNum: integer);
  public
    function AddLineInfo(const S: string; LineNum, ClrIndex: integer): integer;
    procedure InsertLineInfo(index: integer; const S: string; LineNum, ClrIndex: integer);
    property ColorIndex[index: integer]: integer read GetClrIndex write SetClrIndex;
    property LineNum[index: integer]: integer read GetLineNum write SetLineNum;
  end;
  
  TDiffControl = class(TCustomControl)
  private
    fAveCharWidth: integer;
    fLineHeight: integer;                          
    fVertDelta, fHorzDelta: integer;
    fVertExponent: integer;
    fNumWidth: integer;
    fLines: TDiffLines;
    fUseFocusRect: boolean;
    fFocusStart,
    fFocusEnd: integer;
    fColors: array [0..15] of TColor;
    fOnScroll: TNotifyEvent;
    fOnDropFiles: TDropFilesEvent;
    procedure VertKey(Key: Word);
    procedure HorzKey(Key: Word);
    function GetTopLine: integer;
    procedure SetTopLine(TopLine: integer);
    function GetHorzScroll: integer;
    procedure SetHorzScroll(HorzScroll: integer);
    function GetVisibleLines: integer;
    function GetColor(index: integer): TColor;
    procedure SetColor(index: integer; NewColor: TColor);
    procedure SetMaxLineNum(MaxLineNum: integer);
    procedure SetFocusStart(FocusStart: integer);
    function GetFocusLength: integer;
    procedure UpdateScrollbars;
    procedure UpdateFocus(FromTop: boolean);
    function NextVisibleFocus: boolean;
    function PriorVisibleFocus: boolean;
  protected
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure LinesChanged(Sender: TObject);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMSetFont(var Message: TMessage); message WM_SETFONT;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMVScroll(var Message: TWMScroll); message WM_VSCROLL;
    procedure WMHScroll(var Message: TWMScroll); message WM_HSCROLL;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMSetFocus); message WM_KILLFOCUS;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMDropFiles(var Message: TWMDropFiles); message WM_DROPFILES;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure KillFocus;
    function ClientPtToTextPoint(pt: TPoint):TPoint;
    property LineHeight: integer read fLineHeight;
    property TopVisibleLine: integer read GetTopLine write SetTopLine;
    //HorzScroll - horizontal pixel offset
    property HorzScroll: integer read GetHorzScroll write SetHorzScroll;
    property VisibleLines: integer read GetVisibleLines;
    //LineColors - array of up to 15 background colors ...
    property LineColors[index: integer]: TColor read GetColor write SetColor;
    //FocusStart - index of first focused line...
    property FocusStart: integer read fFocusStart write SetFocusStart;
    property FocusLength: integer read GetFocusLength;
  published
    property Align;
    property Ctl3D;
    property Color;
    property Font;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseUp;
    property Lines: TDiffLines read fLines;
    property UseFocusRect: boolean read fUseFocusRect write fUseFocusRect;
    //MaxLineNum - maximum *displayed* line number ...
    property MaxLineNum: integer write SetMaxLineNum;
    property OnScroll: TNotifyEvent read fOnScroll write fOnScroll;
    property OnDropFiles: TDropFilesEvent read fOnDropFiles write fOnDropFiles;
  end;

const
  DIFF_COLOR_MASK = $F0000000;
  DIFF_NUM_MASK = not DIFF_COLOR_MASK;

procedure Register;

function Min(a,b: integer): integer;
function Max(a,b: integer): integer;

implementation

const
  LEFTOFFSET =4; TOPOFFSET =2;

type
  PIntArray = ^TIntArray;
  TIntArray = array [0..(MAXINT div sizeof(integer))-1] of integer;

resourcestring
  s_out_of_range_error = 'DiffControl: Index is out of range.';
  
procedure Register;
begin
  RegisterComponents('Samples', [TDiffControl]);
end;

//--------------------------------------------------------------------------
// Miscellaneous functions ...
//--------------------------------------------------------------------------

function intLog10(int: integer): integer;
begin
  result := 1;
  while int > 9 do begin inc(result); int := int div 10; end;
end;
//--------------------------------------------------------------------------

function Max(a,b: integer): integer;
begin
  if a > b then result := a else result := b;
end;
//--------------------------------------------------------------------------

function Min(a,b: integer): integer;
begin
  if a < b then result := a else result := b;
end;

//--------------------------------------------------------------------------
// TDiffLines class methods ...                                            .
//--------------------------------------------------------------------------

function TDiffLines.GetClrIndex(index: integer): integer;
begin
  if (index < 0) or (index > count) then exception.create(s_out_of_range_error);
  result := integer(objects[index]) shr 28;
end;
//--------------------------------------------------------------------------

procedure TDiffLines.SetClrIndex(index, NewClrIndex: integer);
begin
  if (index < 0) or (index > count) then exception.create(s_out_of_range_error);
  objects[index] :=
    pointer((integer(objects[index]) and DIFF_NUM_MASK) or ((index and $F) shl 28));
end;
//--------------------------------------------------------------------------

function TDiffLines.GetLineNum(index: integer): integer;
begin
  if (index < 0) or (index > count) then exception.create(s_out_of_range_error);
  result := integer(objects[index]) and DIFF_NUM_MASK;
end;
//--------------------------------------------------------------------------

procedure TDiffLines.SetLineNum(index, NewLineNum: integer);
begin
  if (index < 0) or (index > count) then exception.create(s_out_of_range_error);
  objects[index] :=
    pointer((integer(objects[index]) and integer(DIFF_COLOR_MASK)) or (NewLineNum));
end;
//--------------------------------------------------------------------------

function TDiffLines.AddLineInfo(const S: string; LineNum, ClrIndex: integer): integer;
begin
  if (ClrIndex > $F) then exception.create(s_out_of_range_error);
  result := Add(S);
  objects[result] := pointer( LineNum or (ClrIndex shl 28));
end;
//--------------------------------------------------------------------------

procedure TDiffLines.InsertLineInfo(index: integer;
  const S: string; LineNum, ClrIndex: integer);
begin
  if (ClrIndex > $F) then exception.create(s_out_of_range_error);
  Insert(index,S);
  objects[index] := pointer( LineNum or (ClrIndex shl 28));
end;
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
// TDiffControl class methods ...                                          .
//--------------------------------------------------------------------------

constructor TDiffControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csOpaque, csClickEvents, csDoubleClicks];
  SetBounds(Left, Top, 180, 90);
  ParentFont := true;
  ParentColor := false;
  tabstop := true;
  fLines := TDiffLines.create;
  TStringList(fLines).OnChange := LinesChanged;
  fNumWidth := 1;
  fLineHeight := 10; //avoids divideByZero error
end;
//--------------------------------------------------------------------------

procedure TDiffControl.CreateWnd;
begin
  inherited CreateWnd;
  if assigned(fOnDropFiles) then DragAcceptFiles(Handle, True);
end;
//--------------------------------------------------------------------------

procedure TDiffControl.DestroyWnd;
begin
  if assigned( fOnDropFiles ) then DragAcceptFiles(Handle, False);
  inherited DestroyWnd;
end;
//--------------------------------------------------------------------------

destructor TDiffControl.Destroy;
begin
  fLines.free;
  inherited Destroy;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_VSCROLL or WS_HSCROLL or WS_TABSTOP;
    if NewStyleControls and Ctl3D then
      ExStyle := ExStyle or WS_EX_CLIENTEDGE else
      Style := Style or WS_BORDER;
  end;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.WMSetFont(var Message: TMessage);
var
  dc: HDC;
  oldFont: HFont;
  tm: TTextMetric;
begin
  inherited;
  canvas.font := font;
  oldFont := 0;
  dc := GetDC(handle);
  try
    oldFont := SelectObject(dc,canvas.font.handle);
    GetTextMetrics(dc,tm);
  finally
    SelectObject(dc,oldFont);
    ReleaseDc(handle,dc);
  end;
  fAveCharWidth := tm.tmAveCharWidth;
  fLineHeight := tm.tmHeight + tm.tmExternalLeading;
  UpdateScrollbars;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.UpdateScrollbars;
var
  si: TScrollInfo;
begin
  if not handleallocated then exit;
  si.cbSize := sizeof(TScrollInfo);
  si.fMask  := SIF_RANGE or SIF_POS or SIF_PAGE;
  si.nMin := 0;

  fVertExponent := 0;
  si.nMax := fLines.count-1;
  while si.nMax >= $7FFF do //ie: nMax <= $7FFF
  begin
    si.nMax := si.nMax div 2;
    inc(fVertExponent);
  end;

  si.nPage := (ClientHeight div fLineHeight) shr fVertExponent;
  si.nPos := fVertDelta shr fVertExponent;
  SetScrollInfo(handle, SB_VERT, si, true);
  si.nMax := fAveCharWidth* 256 -1;             //fix this!!!
  si.nPage := ClientWidth;
  si.nPos := fHorzDelta;
  SetScrollInfo(handle, SB_HORZ, si, true);
end;
//--------------------------------------------------------------------------

function TDiffControl.NextVisibleFocus: boolean;
var
  i, ci: integer;
begin
  result := false;
  if not fUseFocusRect then exit;
  i := max(fFocusStart, fVertDelta);
  if (i >= fLines.count) then exit;
  //skip current focus block...
  ci := fLines.GetClrIndex(i);
  while (i < fLines.count) and (fLines.GetClrIndex(i) = ci) do inc(i);
  //if next block is non-colored then skip it too...
  while (i < fLines.count) and (fLines.GetClrIndex(i) = 0) do inc(i);
  if (i >= fLines.count) or (i >= fVertDelta + VisibleLines) then exit;
  SetFocusStart(i);
  result := true;
end;
//--------------------------------------------------------------------------

function TDiffControl.PriorVisibleFocus: boolean;
var
  i, ci: integer;
begin
  result := false;
  if not fUseFocusRect then exit;
  i := min(fFocusStart, fVertDelta+VisibleLines-1);
  if (i <= fVertDelta) or (i >= fLines.count) then exit;
  //skip current focus block...
  ci := fLines.GetClrIndex(i);
  while (i >= fVertDelta) and (fLines.GetClrIndex(i) = ci) do dec(i);
  //if prior block is non-colored then skip it too...
  while (i >= fVertDelta) and (fLines.GetClrIndex(i) = 0) do dec(i);
  if (i < fVertDelta) then exit;
  SetFocusStart(i);
  result := true;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.UpdateFocus(FromTop: boolean);
var
  i: integer;
begin
  invalidate;
  if not fUseFocusRect or ((fFocusStart >= fVertDelta) and
    (fFocusStart < fVertDelta + VisibleLines)) then exit; //focus is already OK
  if fLines.Count = 0 then
    i := 0
  else if FromTop then
  begin
    i := fVertDelta;
    while (i < fLines.Count) and (i < fVertDelta + VisibleLines) and
      (fLines.ColorIndex[i] = 0) do inc(i);
  end else
  begin
    i := min(fVertDelta + VisibleLines, fLines.Count) -1;
    while (i >= 0) and (i >= fVertDelta) and
      (fLines.ColorIndex[i] = 0) do dec(i);
  end;
  if (i = fLines.Count) or (fLines.ColorIndex[i] = 0) then
    FocusStart := -1 else
    FocusStart := i;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.WMSize(var Message: TWMSize);
begin
  inherited;
  UpdateScrollbars;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.WMVScroll(var Message: TWMScroll);
var
  si: TScrollInfo;
  oldVertDelta, VisibleLines: integer;
  goingDown: boolean;
begin
  VisibleLines := ClientHeight div fLineHeight;
  si.cbSize := sizeof(TScrollInfo);
  si.fMask  := SIF_RANGE or SIF_PAGE or SIF_POS;
  GetScrollInfo(handle, SB_VERT, si);
  oldVertDelta := fVertDelta;
  case Message.ScrollCode of
    SB_PAGEUP     : dec(fVertDelta, VisibleLines);
    SB_PAGEDOWN   : inc(fVertDelta, VisibleLines);
    SB_LINEUP     : dec(fVertDelta, 1);
    SB_LINEDOWN   : inc(fVertDelta, 1);
    SB_THUMBTRACK : fVertDelta := Message.Pos shl fVertExponent;
  end;
  if fVertDelta < 0 then fVertDelta := 0
  else if fVertDelta > fLines.count - VisibleLines then
    fVertDelta := fLines.count - VisibleLines;

  if fVertDelta = oldVertDelta then
  begin
    if (fVertDelta = 0) or (fVertDelta = fLines.count - VisibleLines) then
    begin
      fFocusStart := -1;
      UpdateFocus(fVertDelta = 0);
    end;
    exit;
  end;
  goingDown := oldVertDelta < fVertDelta;
  si.nPos := fVertDelta shr fVertExponent;
  SetScrollInfo(handle, SB_VERT, si, true);
  UpdateFocus(goingDown);
  if assigned(fOnScroll) then fOnScroll(self);
end;
//--------------------------------------------------------------------------

procedure TDiffControl.WMHScroll(var Message: TWMScroll);
var
  si: TScrollInfo;
  oldHorzDelta: integer;
begin
  si.cbSize := sizeof(TScrollInfo);
  si.fMask  := SIF_RANGE or SIF_PAGE or SIF_POS;
  GetScrollInfo(handle, SB_HORZ, si);
  oldHorzDelta := fHorzDelta;
  case Message.ScrollCode of
    SB_PAGEUP     : dec(fHorzDelta, ClientWidth - fAveCharWidth);
    SB_PAGEDOWN   : inc(fHorzDelta, ClientWidth - fAveCharWidth);
    SB_LINEUP     : dec(fHorzDelta, fAveCharWidth);
    SB_LINEDOWN   : inc(fHorzDelta, fAveCharWidth);
    SB_THUMBTRACK : fHorzDelta := Message.Pos;
  end;
  if fHorzDelta < 0 then fHorzDelta := 0
  else if fHorzDelta > si.nMax-ClientWidth then
    fHorzDelta := max(0,si.nMax-ClientWidth);
  if fHorzDelta = oldHorzDelta then exit;
  si.nPos := fHorzDelta;
  SetScrollInfo(handle, SB_HORZ, si, true);
  refresh;
  if assigned(fOnScroll) then fOnScroll(self);
end;
//--------------------------------------------------------------------------

function TDiffControl.GetTopLine: integer;
begin
  result := fVertDelta;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.SetTopLine(TopLine: integer);
begin
  if TopLine = fVertDelta then
    exit
  else if TopLine < 0 then
    fVertDelta := 0
  else if TopLine > fLines.Count - (clientheight div fLineHeight) then
    fVertDelta := fLines.Count - (clientheight div fLineHeight)
  else
    fVertDelta := TopLine;
  UpdateScrollbars;
  UpdateFocus(true);
end;
//--------------------------------------------------------------------------

function TDiffControl.GetHorzScroll: integer;
begin
  result := fHorzDelta;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.SetHorzScroll(HorzScroll: integer);
begin
  if HorzScroll = fHorzDelta then
    exit
  else if HorzScroll < 0 then
    fHorzDelta := 0
  else if fHorzDelta > fAveCharWidth* 256 - clientwidth -1 then
    fHorzDelta := fAveCharWidth* 256 - clientwidth -1
  else
    fHorzDelta := HorzScroll;
  invalidate;
  UpdateScrollbars;
end;
//--------------------------------------------------------------------------

function TDiffControl.GetVisibleLines: integer;
begin
  result := clientheight div fLineHeight;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  Msg.Result := DLGC_WANTARROWS;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.Paint;
var
  numRec ,textRec: TRect;
  i, colorIndex, visibleLines: integer;
  numColor: TColor;
  FocusNeeded: boolean;
begin
  numRec := clientrect;
  textRec := numRec;
  if focused then numColor := $d9d9d9 else numColor := clSilver;
  with canvas do
  begin
    //get the width of the line numbers border...
    numRec.Right := TextWidth('0')*fNumWidth +(LEFTOFFSET*2) +2 ;
    //get the rect where the text will be displayed...
    inc(textRec.Left,numRec.Right);
    //brush fill in the top offset...
    textRec.Bottom := textRec.Top + TOPOFFSET;
    brush.color := Color;
    fillrect(textRec);
    //color fill the line number edge ...
    brush.color := numColor;
    fillrect(numRec);
    pen.color := clGray;
    dec(numRec.Right);
    moveto(numRec.Right,0);
    lineto(numRec.Right,clientheight);
    pen.color := clWhite;
    dec(numRec.Right);
    moveto(numRec.Right,0);
    lineto(numRec.Right,clientheight);
    pen.color := clSilver;
    dec(numRec.Right);
    moveto(numRec.Right,0);
    lineto(numRec.Right,clientheight);
    //color each visible line according to its color mask ...
    visibleLines := clientheight div fLineHeight;

    FocusNeeded := false;
    if fLines.count > 0 then
      for i := fVertDelta to fLines.count-1 do
        if (i-fVertDelta > visibleLines) then break
        else
        begin
          if UseFocusRect and focused and
            (i >= fFocusStart) and (i < fFocusEnd) then
              FocusNeeded := true;
          colorIndex := fLines.ColorIndex[i];
          if colorIndex = 0 then
            brush.color := color else
            brush.color := fColors[colorIndex];
          //textout for each line ...
          textRec.top := (i-fVertDelta)*fLineHeight +TOPOFFSET;
          textRec.Bottom := textRec.Top + fLineHeight +1;
          textrect(textRec, textRec.Left -fHorzDelta +LEFTOFFSET,
            (i-fVertDelta)*fLineHeight +TOPOFFSET, fLines[i]);
          //number lines using the line numbers stored in fLines.objects[] ...
          brush.color := numColor;
          numRec.top := textRec.top;
          numRec.bottom := textRec.bottom;
          if integer(fLines.objects[i]) and DIFF_NUM_MASK <> 0 then
            textrect(numRec,LEFTOFFSET,TOPOFFSET + (i-fVertDelta)*fLineHeight,
            format('%*.*d',[fNumWidth,fNumWidth,
            integer(fLines.objects[i]) and DIFF_NUM_MASK]))
          else fillRect(numRec);
        end;
    //fill any remaining area below lines ...
    if textRec.Bottom < clientHeight then
    begin
      brush.color := Color;
      textRec.Top := textRec.Bottom;
      textRec.Bottom := clientHeight;
      fillRect(textRec);
    end;
    if FocusNeeded then
    begin
      textRec.Top := (fFocusStart-fVertDelta)*fLineHeight +TOPOFFSET;
      textRec.Bottom := (fFocusEnd-fVertDelta)*fLineHeight +TOPOFFSET;
      drawFocusRect(textRec);
    end;
  end;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  invalidate;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.WMKillFocus(var Message: TWMSetFocus);
begin
  inherited;
  invalidate;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.WMDropFiles(var Message: TWMDropFiles);
var
  DropHandled: boolean;
begin
  inherited;
  if Assigned(fOnDropFiles) then
  begin
    DropHandled := false;
    fOnDropFiles(self, Message.Drop, DropHandled);
    Message.Result := integer(DropHandled);
  end;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.LinesChanged(Sender: TObject);
begin
  UpdateScrollbars;
  invalidate;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.VertKey(Key: Word);
var
  Msg: TWMScroll;
begin
  case Key of
    VK_UP:
      if PriorVisibleFocus then
        exit else
        Msg.ScrollCode := SB_LINEUP;
    VK_DOWN:
      if NextVisibleFocus then
        exit else
        Msg.ScrollCode := SB_LINEDOWN;

    VK_PRIOR: Msg.ScrollCode := SB_PAGEUP;
    VK_NEXT: Msg.ScrollCode := SB_PAGEDOWN;
    VK_HOME:
      begin
        Msg.ScrollCode := SB_THUMBTRACK;
        Msg.Pos := 0;
      end;
    VK_END:
      begin
        Msg.ScrollCode := SB_THUMBTRACK;
        Msg.Pos := fLines.count;
      end;
  end;
  WMVScroll(Msg);
end;
//--------------------------------------------------------------------------

procedure TDiffControl.HorzKey(Key: Word);
var
  Msg: TWMScroll;
begin
  case Key of
    VK_LEFT: Msg.ScrollCode := SB_LINEUP;
    VK_RIGHT: Msg.ScrollCode := SB_LINEDOWN;
  end;
  WMHScroll(Msg);
end;
//--------------------------------------------------------------------------

procedure TDiffControl.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Assigned(OnKeyDown) then OnKeyDown(Self, Key, Shift);
  case Key of
    VK_UP,VK_DOWN,VK_PRIOR,VK_NEXT,VK_HOME,VK_END: VertKey(Key);
    VK_LEFT,VK_RIGHT: HorzKey(Key);
  end;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if not (csDesigning in ComponentState) and CanFocus then
  begin
    if not Focused then
    begin
      SetFocus;
      if ValidParentForm(Self).ActiveControl <> Self then
      begin
        MouseCapture := False;
        Exit;
      end;
    end;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;
//--------------------------------------------------------------------------

function TDiffControl.GetColor(index: integer): TColor;
begin
  if (index < 1) or (index > 7) then exception.create(s_out_of_range_error);
  result := fColors[index];
end;
//--------------------------------------------------------------------------

procedure TDiffControl.SetColor(index: integer; NewColor: TColor);
begin
  if (index < 1) or (index > 15) then exit;
  fColors[index] := NewColor;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.SetMaxLineNum(MaxLineNum: integer);
begin
  fNumWidth := intLog10(MaxLineNum);
end;
//--------------------------------------------------------------------------

procedure TDiffControl.KillFocus;
begin
  if fFocusEnd <> fFocusStart then invalidate;
  fFocusEnd := 0;
  fFocusStart := 0;
end;
//--------------------------------------------------------------------------

procedure TDiffControl.SetFocusStart(FocusStart: integer);
var
  clrIdx: integer;
  OldStart, OldEnd: integer;
begin
  OldStart := fFocusStart;
  OldEnd := fFocusEnd;
  fFocusEnd := 0;
  fFocusStart := 0;
  if not UseFocusRect or (FocusStart < 0) or (FocusStart >= fLines.count) then exit;
  fFocusStart := FocusStart;
  fFocusEnd := FocusStart+1;
  clrIdx := fLines.ColorIndex[FocusStart];
  while (fFocusStart > 0) and (fLines.ColorIndex[fFocusStart-1] = clrIdx) do
    dec(fFocusStart);
  while (fFocusEnd <= fLines.count-1) and (fLines.ColorIndex[fFocusEnd] = clrIdx) do
    inc(fFocusEnd);
  if (OldStart <> fFocusStart) or (OldEnd <> fFocusEnd) then invalidate;
end;
//--------------------------------------------------------------------------

function TDiffControl.GetFocusLength: integer;
begin
  result := fFocusEnd - fFocusStart;
end;
//--------------------------------------------------------------------------

//GetCharOffsets() assumes ints is a
//memory allocated array of [0..length(line)] of integers...
function GetCharOffsets(dc: HDC; const line: string; ints: PIntArray): boolean;
var
  gcpResults: TgcpResults;
  gcpFlags, lineLen: dword;
begin
  //nb: modifications for tabs will be needed
  lineLen := length(line);
  fillchar(gcpResults,sizeof(TgcpResults),0);
  gcpResults.lStructSize := sizeof(TgcpResults);
  gcpResults.lpCaretPos := pointer(ints);
  gcpResults.nGlyphs     := lineLen;
  gcpFlags := GetFontLanguageInfo(dc) and not FLI_GLYPHS;
  ints[lineLen] := GetCharacterPlacement(dc, pchar(line),
    integer(lineLen), integer(0), gcpResults, gcpFlags) and $FFFF;
  result := ints[lineLen] > 0;
end;
//--------------------------------------------------------------------------

function TDiffControl.ClientPtToTextPoint(pt: TPoint):TPoint;
var
  lineLen, leftMarginOffset: integer;
  IntArray: PIntArray;
begin
    result.y := fVertDelta + ((pt.y - TOPOFFSET) div LineHeight);
    result.x := 0;
    if result.y >= fLines.count then exit;
    lineLen := length(fLines[result.y]);
    if lineLen = 0 then exit;
    getMem(IntArray,(lineLen+1)*sizeof(integer));
    try
      //the following function will also handle proportional fonts...
      if not GetCharOffsets(canvas.handle,fLines[result.y],IntArray) then exit;
      leftMarginOffset :=
        canvas.TextWidth('0')*fNumWidth +(LEFTOFFSET*3)+2 - fHorzDelta;
      dec(pt.x, leftMarginOffset);
      while (result.x < lineLen) do
        if pt.x <= intArray[result.x] then break else inc(result.x);
    finally
      freeMem(IntArray);
    end;
end;
//--------------------------------------------------------------------------


end.
