unit PmReportController;

interface

uses Classes, SysUtils, JvAppStorage, JvSpeedBar,

  fBaseFrame, PmEntity, PmEntityController, PmReportData, fReportToolbar,
  BaseRpt, fReportFrame;

type
  TReportController = class(TEntityController)
  private
    FToolbarFrame: TReportToolbarFrame;
    FReportID: integer;
    FSourceFilterPhrase: string;
    function GetFrame: TReportFrame;
    function GetReportData: TReportData;
  protected
    Rpt: TBaseReport;
    CurRow: integer;
    procedure DoExportToExcel(Sender: TObject);
    procedure ProcessExcelHeader;
    procedure ApplyColumnStyle;
    function GetFieldIndexForColumn(ColNum: integer): integer;
    procedure ProcessColumnsWidth;
  public
    // данные передаются в собственность!
    constructor Create(_Entity: TEntity); override;
    destructor Destroy; override;
    function Visible: boolean; override;
    function CreateFrame(Owner: TComponent): TBaseFrame; override;
    procedure Activate; override;
    //procedure LoadSettings(AppStorage: TjvCustomAppStorage); override;
    //procedure SaveSettings(AppStorage: TjvCustomAppStorage); override;
    function GetFilterPhrase: string; override;
    function GetToolbar: TjvSpeedbar; override;

    property Frame: TReportFrame read GetFrame;
    property ReportData: TReportData read GetReportData;
    property ReportID: integer read FReportID write FReportID;
    // здесь запоминается описание фильтра для данных, по которым был построен отчет. 
    property SourceFilterPhrase: string read FSourceFilterPhrase write FSourceFilterPhrase;
  end;

implementation

uses Controls, Forms, DB, ComObj, Dialogs, Variants,

  RDBUtils, RDialogs, ExHandler, PmCustomReport, PmActions, 
  PmScriptManager;

function TReportController.GetFrame: TReportFrame;
begin
  Result := TReportFrame(FFrame);
end;

constructor TReportController.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  FCaption := CustomReports.ReportCaption;
end;

destructor TReportController.Destroy;
begin
  Entity.Free;
  inherited Destroy;
end;

function TReportController.Visible: boolean;
begin
  Result := true;
end;

function TReportController.CreateFrame(Owner: TComponent): TBaseFrame;
begin
  FFrame := TReportFrame.Create(Owner, ReportData);
  Result := FFrame;
end;

{procedure TReportView.LoadSettings(AppStorage: TjvCustomAppStorage);
begin
  TReportFrame(FFrame).LoadSettings;
end;

procedure TReportView.SaveSettings(AppStorage: TjvCustomAppStorage);
begin
  if FFrame <> nil then
    TReportFrame(FFrame).SaveSettings;
end;}

function TReportController.GetReportData: TReportData;
begin
  Result := TReportData(FEntity);
end;

function TReportController.GetFieldIndexForColumn(ColNum: integer): integer;
begin
  Result := ReportData.DataSet.Fields.IndexOf(TField(ReportData.FieldList[ColNum - 1]))
    - TReportData.AuxFieldsCount + 1;
end;

// Здесь надо учесть оригинальный порядок полей
procedure TReportController.ProcessExcelHeader;
var
  I: Integer;
  cdDetails: TDataSet;
  CurCol, FieldIndex: integer;
begin
  cdDetails := CustomReports.Details.DataSet;
  CurCol := 1;
  Rpt.FontApplied := true;
  cdDetails.First;
  while not cdDetails.eof do
  begin
    // Определяем номер соответствующего столбца
    FieldIndex := GetFieldIndexForColumn(CurCol);
    if FieldIndex > 0 then
    begin
      Rpt.FontBold := cdDetails['CaptionFontBold'];
      Rpt.FontItalic := cdDetails['CaptionFontItalic'];
      Rpt.FontColorIndex := cdDetails['CaptionFontColor'];
      Rpt.InteriorColorIndex := cdDetails['CaptionBkColor'];
      Rpt.HorizontalAlignment := cdDetails['CaptionAlignment'];
      Rpt.VerticalAlignment := xlVAlignCenter;
      Rpt.Cells[CurRow, FieldIndex] := cdDetails['Caption'];
    end;
    cdDetails.Next;
    Inc(CurCol);
  end;
end;

procedure TReportController.ApplyColumnStyle;
var
  cdDetails: TDataSet;
  Flags, CurCol, FieldIndex: integer;
begin
  // Применяем стиль
  cdDetails := CustomReports.Details.DataSet;
  CurCol := 1;
  Rpt.FontApplied := false;
  cdDetails.First;
  while not cdDetails.eof do
  begin
    Rpt.FontBold := cdDetails['FontBold'];
    Rpt.FontItalic := cdDetails['FontItalic'];
    //Rpt.SetInterior(3, 1, CurRow - 1, ColCount, cdDetails[
    Rpt.FontColorIndex := cdDetails['FontColor'];
    Rpt.InteriorColorIndex := cdDetails['BkColor'];
    Rpt.HorizontalAlignment := cdDetails['Alignment'];
    //Rpt.VerticalAlignment := xlVAlignCenter;
    //Rpt.AlignHorizontal(3, 1, CurRow - 1, ColCount, cdDetails['Alignment']);
    Flags := frFontBold or frFontItalic or frFontColorIndex or frHorizontalAlignment
      or frInteriorColorIndex;
    // Определяем номер соответствующего столбца
    //FieldIndex := cdReport.Fields.IndexOf(TField(FReportFieldList[CurCol - 1]))
    //  - AuxFieldsCount + 1;
    FieldIndex := GetFieldIndexForColumn(CurCol);
    Rpt.FormatRange(3, FieldIndex, CurRow + 2, FieldIndex, Flags);

    if NvlString(cdDetails['DisplayFormat']) <> '' then
    try
      Rpt.ApplyNumberFormat(3, FieldIndex, CurRow + 2, FieldIndex, cdDetails['DisplayFormat']);
    except on e: EOleException do
      RusMessageDlg(e.Message, mtError, [mbOk], 0);
    end;

    Inc(CurCol);
    cdDetails.Next;
  end;
end;

function GetBoolText(v: variant): string;
begin
  if VarIsNull(v) then Result := ''
  else if v then Result := 'да'
  else Result := 'нет';
end;

procedure TReportController.ProcessColumnsWidth;
var
  Col, i: integer;
  cdDetails: TDataSet;
begin
  cdDetails := CustomReports.Details.DataSet;
  cdDetails.First;
  Col := 1;
  while not cdDetails.Eof do
  begin
    //i := GetFieldIndexForColumn(Col);
    i := Col;
    if NvlBoolean(cdDetails['AutoFitColumn']) then
      Rpt.AutoFitColumns(Col, Col)
    else
    begin
      if not VarIsNull(cdDetails['ColumnWidth']) then
        Rpt.SetColumnWidth(i, cdDetails['ColumnWidth']);
      Rpt.WrapText := true;
      Rpt.FormatRange(3, i, ReportData.RecordCount, i, frWrapText);
      Rpt.AutoFitRows(3, ReportData.RecordCount);
    end;
    Inc(Col);
    cdDetails.Next;
  end;
end;

procedure TReportController.DoExportToExcel(Sender: TObject);
var
  i: Integer;
  SaveCursor: TCursor;
  V: variant;
  f: TField;
  cdReport: TDataSet;
  Hdr: string;
begin
  SaveCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;    { Show hourglass cursor }
  try
    Rpt := ScriptManager.OpenReport(ExtractFileDir(ParamStr(0)) + '\CustomReport.xls');
    if Rpt <> nil then
    begin
      Rpt.WinCaption1 := 'Excel для PolyMix';
      Rpt.WinCaption2 := CustomReports.ReportCaption;
      Rpt.FontApplied := false;

      if CustomReports.AddFilter then
        Hdr := CustomReports.ReportCaption + ' (' + ScriptManager.GetFilterPhrase + ')'
      else
        Hdr := CustomReports.ReportCaption;

      Rpt.Cells[1, 1] := Hdr;
      CurRow := 2;
      cdReport := ReportData.DataSet;
      ProcessExcelHeader;
      //CurRow := 3;
      CurRow := 1;
      if cdReport.Fields.Count > 2 then
      begin
        V := VarArrayCreate([1, cdReport.RecordCount, 1, cdReport.Fields.Count - 2], varVariant);
        cdReport.DisableControls;
        try
          cdReport.First;
          while not cdReport.eof do
          begin
            // Первые два поля пропускаем - они служебные
            for i := TReportData.AuxFieldsCount to cdReport.Fields.Count - 1 do
            begin
              //Rpt.Cells[CurRow, i - 1] := cdReport.Fields[i].Value;
              f := cdReport.Fields[i];
              // Первые два поля пропустили, поэтому - 1
              if f is TBooleanField then
                V[CurRow, i - 1] := GetBoolText(f.Value) // текст для булевых полей
              else
                V[CurRow, i - 1] := f.Value;
            end;
            Inc(CurRow);
            cdReport.Next;
          end;    // while
        finally
          cdReport.EnableControls;
        end;
        Rpt.CreateTable(V, 3, 1);
        ProcessColumnsWidth;
        //Rpt.WrapText := True; // Можно сделать в зависимости от настройки
        //Rpt.DrawAllFrames(2, 1, CurRow - 1, CustomReports.DetailData.DataSet.RecordCount);
        Rpt.DrawAllFrames(2, 1, CurRow + 1, CustomReports.Details.DataSet.RecordCount);
        ApplyColumnStyle;
      end;
      Rpt.Visible := true;
    end;
  finally
    Screen.Cursor := SaveCursor;  { Always restore to normal }
  end;
end;

function TReportController.GetToolbar: TjvSpeedbar;
begin
  if FToolbarFrame = nil then
    FToolbarFrame := TReportToolbarFrame.Create(nil);
  Result := FToolbarFrame.Toolbar;
end;

procedure TReportController.Activate;
begin
  inherited;
  TMainActions.GetAction(TReportActions.ExportToExcel).OnExecute := DoExportToExcel;
end;

function TReportController.GetFilterPhrase: string;
begin
  Result := FSourceFilterPhrase;
end;

end.
