unit fDiffBase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DiffUnit, ExtCtrls, DiffControl, Menus, ComCtrls, HashUnit,
  ShellApi, About, Editor, IniFiles;

type

  TDiffBaseForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    mnuOpen1: TMenuItem;
    N1: TMenuItem;
    mnuExit: TMenuItem;
    Options1: TMenuItem;
    mnuIgnoreBlanks: TMenuItem;
    mnuIgnoreCase: TMenuItem;
    N2: TMenuItem;
    mnuCompare: TMenuItem;
    OpenDialog1: TOpenDialog;
    N3: TMenuItem;
    mnuFont: TMenuItem;
    Help1: TMenuItem;
    mnuAbout: TMenuItem;
    mnuOpen2: TMenuItem;
    FontDialog1: TFontDialog;
    mnuSplitHorizontally: TMenuItem;
    N4: TMenuItem;
    pnlDisplay: TPanel;
    PaintBox1: TPaintBox;
    PaintBox2: TPaintBox;
    N5: TMenuItem;
    mnuHighlightColors: TMenuItem;
    Added1: TMenuItem;
    Modified1: TMenuItem;
    Deleted1: TMenuItem;
    ColorDialog1: TColorDialog;
    mnuCancel: TMenuItem;
    mnuMergeOptions: TMenuItem;
    mnuMergeFromFile1: TMenuItem;
    mnuMergeFromFile2: TMenuItem;
    mnuMergeFromNeither: TMenuItem;
    SaveDialog1: TSaveDialog;
    mnuSaveMerged: TMenuItem;
    Panel1: TPanel;
    pnlMain: TPanel;
    Splitter1: TSplitter;
    pnlLeft: TPanel;
    pnlCaptionLeft: TPanel;
    pnlRight: TPanel;
    pnlCaptionRight: TPanel;
    pnlMerge: TPanel;
    Splitter2: TSplitter;
    mnuActions: TMenuItem;
    N6: TMenuItem;
    mnuMergeFocusedText: TMenuItem;
    mnuEditFocusedText: TMenuItem;
    Contents1: TMenuItem;
    mnuShowDiffsOnly: TMenuItem;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuCompareClick(Sender: TObject);
    procedure mnuOpen1Click(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuIgnoreBlanksClick(Sender: TObject);
    procedure mnuIgnoreCaseClick(Sender: TObject);
    procedure mnuOpen2Click(Sender: TObject);
    procedure mnuFontClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure mnuSplitHorizontallyClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox2Paint(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure Added1Click(Sender: TObject);
    procedure Modified1Click(Sender: TObject);
    procedure Deleted1Click(Sender: TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuCancelClick(Sender: TObject);
    procedure mnuMergeFromClick(Sender: TObject);
    procedure mnuMergeClick(Sender: TObject);
    procedure mnuActionsClick(Sender: TObject);
    procedure mnuSaveMergedClick(Sender: TObject);
    procedure mnuEditMergeClick(Sender: TObject);
    procedure Contents1Click(Sender: TObject);
    procedure mnuShowDiffsOnlyClick(Sender: TObject);
  private
    FilesCompared: boolean;
    Lines1, Lines2: TStrings;
    Paintbox1Bmp: TBitmap;
    Diff: TDiff;
    DiffControl1: TDiffControl;
    DiffControl2: TDiffControl;
    DiffControlMerge: TDiffControl;
    procedure DiffCtrlMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DiffCtrlDblClick(Sender: TObject);
    procedure LoadOptions;
    procedure SaveOptions;
    procedure RepaintControls;
    procedure UpdatePaintbox1Bmp;
    procedure SyncScroll(Sender: TObject);
    procedure FileDrop(Sender: TObject; dropHandle: integer; var DropHandled: boolean);
    procedure DiffProgress(Sender: TObject; percent: integer);
    procedure DisplayDiffs;
  protected
    procedure DoOpenFile(const Filename: string; OpenFile1: boolean);
    procedure Compare;
  end;

var
  DiffBaseForm: TDiffBaseForm;

const
  colorAdd = 1;
  colorMod = 2;
  colorDel = 3;

implementation

{$R *.DFM}

//---------------------------------------------------------------------
//---------------------------------------------------------------------

procedure TDiffBaseForm.FormCreate(Sender: TObject);
begin
  Lines1 := TStringList.create;
  Lines2 := TStringList.create;
  Diff := TDiff.create(self);
  Diff.OnProgress := DiffProgress;

  DiffControl1 := TDiffControl.create(self);
  with DiffControl1 do
  begin
    parent := pnlLeft;
    Align := alClient;
    OnMouseDown := DiffCtrlMouseDown;
    OnDropFiles := FileDrop;
    OnDblClick := DiffCtrlDblClick;
  end;

  DiffControl2 := TDiffControl.create(self);
  with DiffControl2 do
  begin
    parent := pnlRight;
    Align := alClient;
    OnMouseDown := DiffCtrlMouseDown;
    OnDropFiles := FileDrop;
    OnDblClick := DiffCtrlDblClick;
  end;

  DiffControlMerge := TDiffControl.create(self);
  with DiffControlMerge do
  begin
    parent := pnlMerge;
    Align := alClient;
    OnMouseDown := DiffCtrlMouseDown;
    OnDblClick := DiffCtrlDblClick;
    Color := $d9d9d9;
  end;

  Splitter2.Visible := false;

  PaintBox2.Canvas.Pen.Color := clBlack;
  PaintBox2.Canvas.Pen.Width := 2;

  Paintbox1Bmp := TBitmap.create;
  Paintbox1Bmp.Canvas.Brush.Color := clWindow;

  LoadOptions;
  //application.helpfile := changefileext(ParamStr(0), '.hlp');

  //if paramcount > 0 then DoOpenFile(paramstr(1), true);
  //if paramcount > 1 then DoOpenFile(paramstr(2),false);

end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.LoadOptions;
var
  l,t,w,h: integer;
begin
  with TIniFile.create(changefileext(paramstr(0),'.ini')) do
  try
    l := ReadInteger('Options','Bounds.Left', 0);
    t := ReadInteger('Options','Bounds.Top', 0);
    w := ReadInteger('Options','Bounds.Width', -1);
    h := ReadInteger('Options','Bounds.Height', -1);

    //set (Add, Del, Mod) colors...
    DiffControl1.LineColors[colorAdd] :=
      strtointdef(ReadString('Options','AddColor', ''),$FF6666);
    DiffControl1.LineColors[colorMod] :=
      strtointdef(ReadString('Options','ModColor', ''),$FF00);
    DiffControl1.LineColors[colorDel] :=
      strtointdef(ReadString('Options','DelColor', ''),$6666FF);

    DiffControl1.Font.name := ReadString('Options','Font.name', 'Arial');
    DiffControl1.Font.size := ReadInteger('Options','Font.size', 8);
    DiffControl1.Font.color := ReadInteger('Options','Font.color', $0);
    
    // AR: Added
    DiffControl1.Font.CharSet := RUSSIAN_CHARSET;

    if ReadBool('Options','Font.style.bold', true) then
      DiffControl1.Font.style := [fsBold] else
      DiffControl1.Font.style := [];
    if ReadBool('Options','Horizontal',false) then mnuSplitHorizontallyClick(nil);
    OpenDialog1.InitialDir :=
      ReadString('Options','OpenDialog.path', extractfilepath(paramstr(0)));
  finally
    free;
  end;
  DiffControl2.Font.Assign(DiffControl1.font);
  DiffControlMerge.Font.Assign(DiffControl1.font);
  DiffControl2.LineColors[colorAdd] := DiffControl1.LineColors[colorAdd];
  DiffControlMerge.LineColors[colorAdd] := DiffControl1.LineColors[colorAdd];
  DiffControl2.LineColors[colorMod] := DiffControl1.LineColors[colorMod];
  DiffControlMerge.LineColors[colorMod] := DiffControl1.LineColors[colorMod];
  DiffControl2.LineColors[colorDel] := DiffControl1.LineColors[colorDel];
  DiffControlMerge.LineColors[colorDel] := DiffControl1.LineColors[colorDel];
  //make sure the form is positioned on screen ...
  //(ie make sure nobody's fiddled with the INI file!)
  if (w > 0) and (h > 0) and
    (l < screen.Width) and (t < screen.Height) and
    (l+w > 0) and (t+h > 0) then
      setbounds(l,t,w,h);
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.SaveOptions;
begin
  with TIniFile.create(changefileext(paramstr(0),'.ini')) do
  try
    if windowState = wsNormal then
    begin
      WriteInteger('Options','Bounds.Left', self.Left);
      WriteInteger('Options','Bounds.Top', self.Top);
      WriteInteger('Options','Bounds.Width', self.Width);
      WriteInteger('Options','Bounds.Height', self.Height);
    end;
    WriteString('Options','AddColor', '$'+inttohex(DiffControl1.LineColors[colorAdd],8));
    WriteString('Options','ModColor', '$'+inttohex(DiffControl1.LineColors[colorMod],8));
    WriteString('Options','DelColor', '$'+inttohex(DiffControl1.LineColors[colorDel],8));
    WriteString('Options','Font.name', DiffControl1.Font.name);
    WriteInteger('Options','Font.size', DiffControl1.Font.size);
    WriteInteger('Options','Font.color', DiffControl1.Font.color);
    WriteBool('Options','Font.style.bold', fsBold in DiffControl1.Font.style);
    WriteBool('Options','Horizontal', mnuSplitHorizontally.Checked);
    WriteString('Options','OpenDialog.path', OpenDialog1.InitialDir);
  finally
    free;
  end;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveOptions;
  Application.HelpCommand(HELP_QUIT, 0);
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.FormDestroy(Sender: TObject);
begin
  Diff.free;
  Paintbox1Bmp.free;
  Lines2.free;
  Lines1.free;
  DiffControl2.free;
  DiffControl1.free;
  DiffControlMerge.free;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.FormResize(Sender: TObject);
begin
  if mnuSplitHorizontally.checked then
    pnlLeft.height := pnlMain.ClientHeight div 2 -1 else
    pnlLeft.width := pnlMain.ClientWidth div 2 -1;
end;
//---------------------------------------------------------------------

//Syncronise scrolling of both DiffControls...
procedure TDiffBaseForm.SyncScroll(Sender: TObject);
begin
  //stop recursive WM_SCROLL messages...
  DiffControl1.OnScroll := nil;
  DiffControl2.OnScroll := nil;
  DiffControlMerge.OnScroll := nil;

  if Sender = DiffControl1 then
  begin
    DiffControl2.TopVisibleLine := DiffControl1.TopVisibleLine;
    DiffControl2.HorzScroll := DiffControl1.HorzScroll;
    if pnlMerge.visible then
    begin
      DiffControlMerge.TopVisibleLine := DiffControl1.TopVisibleLine;
      DiffControlMerge.HorzScroll := DiffControl1.HorzScroll;
    end;
  end
  else if Sender = DiffControl2 then
  begin
    DiffControl1.TopVisibleLine := DiffControl2.TopVisibleLine;
    DiffControl1.HorzScroll := DiffControl2.HorzScroll;
    if pnlMerge.visible then
    begin
      DiffControlMerge.TopVisibleLine := DiffControl1.TopVisibleLine;
      DiffControlMerge.HorzScroll := DiffControl1.HorzScroll;
    end;
  end
  else if Sender = DiffControlMerge then
  begin
    DiffControl1.TopVisibleLine := DiffControlMerge.TopVisibleLine;
    DiffControl1.HorzScroll := DiffControlMerge.HorzScroll;
    DiffControl2.TopVisibleLine := DiffControlMerge.TopVisibleLine;
    DiffControl2.HorzScroll := DiffControlMerge.HorzScroll;
  end;

  DiffControl1.OnScroll := SyncScroll;
  DiffControl2.OnScroll := SyncScroll;
  if pnlMerge.visible then DiffControlMerge.OnScroll := SyncScroll;

  PaintBox2Paint(self);
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.DoOpenFile(const Filename: string; OpenFile1: boolean);
var
  DiffControl: TDiffControl;
begin
  if not fileexists(Filename) then exit;
  FilesCompared := false;
  if OpenFile1 then
  begin
    DiffControl := DiffControl1;
    Lines1.LoadFromFile(filename);
    DiffControl.Lines.Assign(Lines1);
    pnlCaptionLeft.caption := '  '+ filename;
  end
  else
  begin
    DiffControl := DiffControl2;
    Lines2.LoadFromFile(filename);
    DiffControl.Lines.Assign(Lines2);
    pnlCaptionRight.caption := '  '+ filename;
  end;
  DiffControl.MaxLineNum := 1;
  DiffControl.TopVisibleLine := 0;
  DiffControl.HorzScroll := 0;
  DiffControl1.UseFocusRect := false;
  DiffControl2.UseFocusRect := false;
  DiffControlMerge.UseFocusRect := false;
  OpenDialog1.InitialDir := extractfilepath(filename);
  mnuCompare.enabled := (Lines1.Count > 0) and (Lines2.Count > 0);
  DiffControl1.OnScroll := nil;
  DiffControl2.OnScroll := nil;
  Statusbar1.Panels[3].text := '';
  pnlDisplay.visible := false;
  mnuMergeOptions.Enabled := false;
  mnuMergeFocusedText.enabled := false;
  pnlMerge.Visible := false;
  mnuSaveMerged.enabled := false;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.mnuOpen1Click(Sender: TObject);
begin
  if OpenDialog1.execute then DoOpenFile(OpenDialog1.filename,true);
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.mnuOpen2Click(Sender: TObject);
begin
  if OpenDialog1.execute then DoOpenFile(OpenDialog1.filename, false);
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.FileDrop(Sender: TObject; dropHandle: integer; var DropHandled: boolean);
var
  fileBuffer: array [0..MAX_PATH] of char;
begin
  DropHandled := DragQueryFile(dropHandle, 0, @fileBuffer, MAX_PATH) > 0;
  DoOpenFile(fileBuffer, Sender = DiffControl1);
  setForegroundWindow(application.handle);
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.DiffCtrlDblClick(Sender: TObject);
begin
  if not (Sender is TDiffControl) or
    (TDiffControl(Sender).FocusLength = 0) then exit;
  if Sender = DiffControlMerge then
  begin
    //don't allow editing empty lines...
    with DiffControlMerge do
      if (FocusLength > 0) and (Lines.LineNum[FocusStart] <> 0) then
        mnuEditMergeClick(nil)
  end else
    mnuMergeClick(nil);
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.DiffCtrlMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  clrIndex, ClickedLine: integer;
begin
  with TDiffControl(Sender) do
  begin
    ClickedLine := ClientPtToTextPoint(Point(X,Y)).y;
    if ClickedLine >= Lines.Count then exit;
    clrIndex := Lines.ColorIndex[ClickedLine];
    if clrIndex = 0 then
      KillFocus else
      FocusStart := ClickedLine;
  end;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.mnuExitClick(Sender: TObject);
begin
  close;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.mnuCompareClick(Sender: TObject);
begin
  Compare;
end;

procedure TDiffBaseForm.Compare;
var
  i: integer;
  HashList1,HashList2: TList;
  optionsStr: string;
begin
  if (Lines1.Count = 0) or (Lines2.Count = 0) then exit;

  if mnuIgnoreCase.checked then
    optionsStr := 'Case Ignored';
  if mnuIgnoreBlanks.checked then
    if optionsStr = '' then
      optionsStr := 'Blanks Ignored' else
      optionsStr := optionsStr + ', Blanks Ignored';
  if optionsStr <> '' then
    optionsStr := '  ('+optionsStr+')';

  HashList1 := TList.create;
  HashList2 := TList.create;
  try
    //create the hash lists to compare...
    HashList1.capacity := Lines1.Count;
    HashList2.capacity := Lines2.Count;
    for i := 0 to Lines1.Count-1 do
      HashList1.add(HashLine(Lines1[i],mnuIgnoreCase.checked,mnuIgnoreBlanks.checked));
    for i := 0 to Lines2.Count-1 do
      HashList2.add(HashLine(Lines2[i],mnuIgnoreCase.checked,mnuIgnoreBlanks.checked));

    screen.cursor := crHourglass;
    try
      mnuCancel.Enabled := true;
      //CALCULATE THE DIFFS HERE ...
      if not Diff.Execute(PIntArray(HashList1.List),PIntArray(HashList2.List),
        HashList1.count, HashList2.count) then exit;
      FilesCompared := true;
      DisplayDiffs;
    finally
      screen.cursor := crDefault;
      mnuCancel.Enabled := false;
    end;
    Statusbar1.Panels[3].text := format('  Changes: %d %s',[Diff.ChangeCount,optionsStr]);
    DiffControl1.OnScroll := SyncScroll;
    DiffControl2.OnScroll := SyncScroll;
    pnlDisplay.visible := true;
    mnuMergeOptions.Enabled := not mnuShowDiffsOnly.checked;

  finally
    HashList1.Free;
    HashList2.Free;
  end;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.DiffProgress(Sender: TObject; percent: integer);
begin
  Statusbar1.Panels[3].text := format('Approx. %d%% complete',[percent] );
  Statusbar1.Refresh;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.DisplayDiffs;
var
  i,j, k: integer;
begin
  DiffControl1.Lines.BeginUpdate;
  DiffControl2.Lines.BeginUpdate;
  try
    DiffControl1.Lines.Clear;
    DiffControl2.Lines.Clear;
    DiffControl1.MaxLineNum := Lines1.Count;
    DiffControl2.MaxLineNum := Lines2.Count;

    ////////////////////////////////////////////////////////////////////////
    j := 0; k := 0;
    with Diff do
    for i := 0 to ChangeCount-1 do
      with Changes[i] do
      begin
        //first add preceeding unmodified lines...
        if mnuShowDiffsOnly.Checked then
          inc(k, x - j)
        else
          while j < x do
          begin
             DiffControl1.lines.AddLineInfo(lines1[j],j+1, 0);
             DiffControl2.lines.AddLineInfo(lines2[k],k+1, 0);
             inc(j); inc(k);
          end;

        if Kind = ckAdd then
        begin
          for j := k to k+Range-1 do
          begin
           DiffControl1.lines.AddLineInfo('',0, colorAdd);
           DiffControl2.lines.AddLineInfo(lines2[j],j+1, colorAdd);
          end;
          j := x;
          k := y+Range;
        end else if Kind = ckModify then
        begin
          for j := 0 to Range-1 do
          begin
           DiffControl1.lines.AddLineInfo(lines1[x+j],x+j+1, colorMod);
           DiffControl2.lines.AddLineInfo(lines2[k+j],k+j+1, colorMod);
          end;
          j := x+Range;
          k := y+Range;
        end else
        begin
          for j := x to x+Range-1 do
          begin
           DiffControl1.lines.AddLineInfo(lines1[j],j+1, colorDel);
           DiffControl2.lines.AddLineInfo('',0, colorDel);
          end;
          j := x+Range;
        end;
      end;
    //add remaining unmodified lines...
    if not mnuShowDiffsOnly.Checked then
      while j < lines1.count do
      begin
         DiffControl1.lines.AddLineInfo(lines1[j],j+1, 0);
         DiffControl2.lines.AddLineInfo(lines2[k],k+1, 0);
         inc(j); inc(k);
      end;
  finally
    DiffControl1.Lines.EndUpdate;
    DiffControl2.Lines.EndUpdate;
    DiffControl1.TopVisibleLine := 0;
    DiffControl2.TopVisibleLine := 0;
    UpdatePaintbox1Bmp;
    PaintBox2.Repaint;
  end;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.mnuIgnoreBlanksClick(Sender: TObject);
begin
  mnuIgnoreBlanks.checked := not mnuIgnoreBlanks.checked;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.mnuIgnoreCaseClick(Sender: TObject);
begin
  mnuIgnoreCase.checked := not mnuIgnoreCase.checked;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.mnuShowDiffsOnlyClick(Sender: TObject);
begin
  mnuShowDiffsOnly.checked := not mnuShowDiffsOnly.checked;
  //if files have already been compared then refresh the changes
  //as long as no merge has been atarted ...
  if FilesCompared and not pnlMerge.visible then
  begin
    //prevent merges when ShowDiffsOnly is checked...
    mnuMergeOptions.Enabled := not mnuShowDiffsOnly.checked;
    DisplayDiffs;
  end;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.mnuFontClick(Sender: TObject);
begin
  FontDialog1.font := DiffControl1.font;
  if not FontDialog1.execute then exit;
  DiffControl1.font := FontDialog1.font;
  DiffControl2.font := FontDialog1.font;
  DiffControlMerge.font := FontDialog1.font;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.mnuSplitHorizontallyClick(Sender: TObject);
begin
  mnuSplitHorizontally.checked := not mnuSplitHorizontally.checked;
  if mnuSplitHorizontally.checked then
  begin
    pnlLeft.Align := alTop;
    pnlLeft.Height := pnlMain.ClientHeight div 2 -1;
    Splitter1.Align := alTop;
    Splitter1.cursor := crVSplit;
  end else
  begin
    pnlLeft.Align := alLeft;
    pnlLeft.Width := pnlMain.ClientWidth div 2 -1;
    Splitter1.Align := alLeft;
    Splitter1.Left := 10;
    Splitter1.cursor := crHSplit;
  end;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.UpdatePaintbox1Bmp;
var
  i,y: integer;
  clrIndex: integer;
  HeightRatio: single;
begin
  if (DiffControl1.Lines.Count = 0) or (DiffControl2.Lines.Count = 0) then exit;
  HeightRatio := Screen.Height/DiffControl1.Lines.Count;

  Paintbox1Bmp.Height := Screen.Height;
  Paintbox1Bmp.Width := Paintbox1.ClientWidth;
  Paintbox1Bmp.Canvas.Pen.Width := 2;
  with Paintbox1Bmp do Canvas.FillRect(Rect(0,0,width,height));
  with DiffControl1 do
  begin
    for i := 0 to Lines.Count-1 do
    begin
      clrIndex := Lines.ColorIndex[i];
      if (clrIndex = 0) then continue;
      Paintbox1Bmp.Canvas.Pen.Color := LineColors[clrIndex];
      y := trunc(i*HeightRatio);
      Paintbox1Bmp.Canvas.MoveTo(0,y);
      Paintbox1Bmp.Canvas.LineTo(Paintbox1Bmp.Width,y);
    end;
  end;
  PaintBox1.Invalidate;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.PaintBox1Paint(Sender: TObject);
begin
  with PaintBox1 do
    Canvas.StretchDraw(Rect(0,0,width,Height),Paintbox1Bmp);
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.PaintBox2Paint(Sender: TObject);
var
  yPos: integer;
begin
  if DiffControl1.Lines.Count = 0 then exit;
  with PaintBox2 do
  begin
    Canvas.Brush.Color := clWindow;
    Canvas.FillRect(ClientRect);
    yPos := DiffControl1.TopVisibleLine + DiffControl1.VisibleLines div 2;
    yPos := clientHeight*ypos div DiffControl1.Lines.Count;
    Canvas.MoveTo(0,yPos);
    Canvas.LineTo(ClientWidth,yPos);
  end;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.mnuAboutClick(Sender: TObject);
begin
  with TAboutForm.create(self) do
  try
    showmodal;
  finally
    free;
  end;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.RepaintControls;
begin
  DiffControl1.Repaint;
  DiffControl2.Repaint;
  UpdatePaintbox1Bmp;
  PaintBox1.Repaint;
  //PaintBox2.Repaint;
  StatusBar1.Repaint;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.Added1Click(Sender: TObject);
begin
  with ColorDialog1 do
  begin
    color := DiffControl1.LineColors[colorAdd];
    if not execute then exit;
    DiffControl1.LineColors[colorAdd] := color;
    DiffControl2.LineColors[colorAdd] := color;
    DiffControlMerge.LineColors[colorAdd] := color;
  end;
  RepaintControls;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.Modified1Click(Sender: TObject);
begin
  with ColorDialog1 do
  begin
    color := DiffControl1.LineColors[colorMod];
    if not execute then exit;
    DiffControl1.LineColors[colorMod] := color;
    DiffControl2.LineColors[colorMod] := color;
    DiffControlMerge.LineColors[colorMod] := color;
  end;
  RepaintControls;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.Deleted1Click(Sender: TObject);
begin
  with ColorDialog1 do
  begin
    color := DiffControl1.LineColors[colorDel];
    if not execute then exit;
    DiffControl1.LineColors[colorDel] := color;
    DiffControl2.LineColors[colorDel] := color;
    DiffControlMerge.LineColors[colorDel] := color;
  end;
  RepaintControls;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  case Panel.Index of
    0: StatusBar1.Canvas.Brush.Color := DiffControl1.LineColors[colorAdd];
    1: StatusBar1.Canvas.Brush.Color := DiffControl1.LineColors[colorMod];
    2: StatusBar1.Canvas.Brush.Color := DiffControl1.LineColors[colorDel];
  else exit;
  end;
  StatusBar1.Canvas.FillRect(Rect);
  StatusBar1.Canvas.TextOut(Rect.Left+4,Rect.Top,Panel.Text);
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.mnuCancelClick(Sender: TObject);
begin
  Diff.Cancel;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.mnuMergeFromClick(Sender: TObject);
var
  i: integer;
begin
  DiffControl1.UseFocusRect := true;
  DiffControl2.UseFocusRect := true;
  DiffControlMerge.UseFocusRect := true;
  if (Sender = mnuMergeFromFile1) or (Sender = mnuMergeFromNeither) then
  begin
    DiffControlMerge.Lines.Assign(DiffControl1.Lines);
    DiffControlMerge.MaxLineNum := Lines1.Count;
    if (Sender = mnuMergeFromNeither) then
      with DiffControlMerge.Lines do
      begin
        beginupdate;
        for i := 0 to Count-1 do
          if ColorIndex[i] <> 0 then Strings[i] := '';
        endupdate;
      end;
  end else
  begin
    DiffControlMerge.Lines.Assign(DiffControl2.Lines);
    DiffControlMerge.MaxLineNum := Lines2.Count;
  end;

  pnlMerge.visible := true;
  if mnuSplitHorizontally.checked then
  begin
    pnlMerge.Height := (clientheight -
      statusbar1.height - pnlCaptionLeft.height) div 3;
    pnlLeft.Height := pnlMerge.Height;
  end
  else
    pnlMerge.Height := (clientheight -
      statusbar1.height - pnlCaptionLeft.height) div 2;
  pnlMerge.Top := 1; //force pnlMerge above statusbar
  Splitter2.visible := true;
  Splitter2.Top := 0; //force Splitter2 above pnlMerge
  DiffControlMerge.OnScroll := SyncScroll;
  SyncScroll(DiffControl1);
  mnuSaveMerged.enabled := true;
  mnuMergeFocusedText.enabled := true;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.mnuMergeClick(Sender: TObject);
var
  i: integer;
  DiffControl: TDiffControl;
begin
  if DiffControl1.Focused then
    DiffControl := DiffControl1 else
    DiffControl := DiffControl2;
  with DiffControl do
  begin
    if FocusLength <= 0 then exit;
    for i := FocusStart to FocusStart + FocusLength -1 do
    begin
      DiffControlMerge.Lines[i] := Lines[i];
      DiffControlMerge.Lines.LineNum[i] := Lines.LineNum[i];
    end;
  end;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.mnuActionsClick(Sender: TObject);
var
  DiffControl: TDiffControl;
begin
  mnuEditFocusedText.Enabled := false;
  mnuMergeFocusedText.Enabled := false;
  if not pnlMerge.Visible then exit;

  if DiffControl1.Focused then DiffControl := DiffControl1
  else if DiffControl2.Focused then DiffControl := DiffControl2
  else DiffControl := DiffControlMerge;

  //don't allow editing empty lines...
  if (DiffControl.FocusLength = 0) or
     ((DiffControl = DiffControlMerge) and
     (DiffControlMerge.Lines.LineNum[DiffControlMerge.FocusStart] = 0)) then
        exit;

  if DiffControl = DiffControlMerge then
    mnuEditFocusedText.Enabled := true else
    mnuMergeFocusedText.Enabled := true;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.mnuSaveMergedClick(Sender: TObject);
var
  i: integer;
begin
  SaveDialog1.InitialDir := OpenDialog1.InitialDir;
  if not SaveDialog1.execute then exit;
  with TStringList.create do
  try
    beginupdate;
    //todo - watch out for merges with ShowDiffsOnly checked!!!
    for i := 0 to DiffControlMerge.Lines.count-1 do
      if DiffControlMerge.Lines.LineNum[i] > 0 then
        add(DiffControlMerge.Lines[i]);
    endupdate;
    savetofile(SaveDialog1.FileName);
  finally
    free;
  end;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.mnuEditMergeClick(Sender: TObject);
var
  i, oldLineNum, oldClrIdx: integer;
begin
  with TEditForm.create(self) do
  try
    width := self.clientwidth -20;
    clientheight := min(65 +
      (DiffControlMerge.LineHeight+1)*DiffControlMerge.FocusLength,
        DiffControlMerge.Height);
    memo1.Font.Assign(DiffControlMerge.Font);
    with DiffControlMerge do
      memo1.Color := LineColors[lines.ColorIndex[FocusStart]];
    memo1.lines.BeginUpdate;
    with DiffControlMerge do
      for i := FocusStart to FocusStart + FocusLength - 1 do
        memo1.lines.add(Lines[i]);
    memo1.Lines.EndUpdate;
    memo1.SelStart := 0;
    memo1.Modified := false;
    if (ShowModal <> mrOK) or not memo1.Modified then exit;
    with DiffControlMerge do
    begin
      oldLineNum := lines.LineNum[FocusStart];
      oldClrIdx := lines.ColorIndex[FocusStart];
      lines.BeginUpdate;
      //for the moment the no. of lines after editing must remain the same...
      while memo1.lines.Count < FocusLength do memo1.lines.add('');
      for i := 1 to FocusLength do lines.delete(FocusStart);
      for i := FocusLength -1 downto 0 do
        lines.InsertLineInfo(FocusStart, memo1.lines[i],oldLineNum+i,oldClrIdx);
      Lines.EndUpdate;
    end;
  finally
    free;
  end;
end;
//---------------------------------------------------------------------

procedure TDiffBaseForm.Contents1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTENTS, 0);
end;
//---------------------------------------------------------------------

end.
