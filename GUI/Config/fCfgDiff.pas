unit fCfgDiff;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGridEh, MyDBGridEh, StdCtrls, ExtCtrls,
  JvComponent, JvPicClip, JvFormPlacement, JvJCLUtils, JvComponentBase, GridsEh,
  DBGridEhGrouping;

type
  TCfgDiffForm = class(TForm)
    Panel1: TPanel;
    btOk: TButton;
    btCancel: TButton;
    Panel2: TPanel;
    dgDiff: TMyDBGridEh;
    dsDiff: TDataSource;
    StateClip: TJvPicClip;
    FormStorage: TJvFormStorage;
    btDiff: TButton;
    procedure dgDiffDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure dgDiffGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dgDiffColumns3GetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure dgDiffColumns5GetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure btDiffClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dgDiffColumns1GetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure dgDiffColumnsFileNameGetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
  private
    FDiffDataSet: TDataSet;
    FOnWriteScriptToFile: TNotifyEvent;
    procedure DataSetAfterScroll(DataSet: TDataSet);
    procedure SetDiffDataSet(const Value: TDataSet);
  public
    property DiffDataSet: TDataSet read FDiffDataSet write SetDiffDataSet;
    property OnWriteScriptToFile: TNotifyEvent read FOnWriteScriptToFile write FOnWriteScriptToFile;
  end;

var
  CfgDiffForm: TCfgDiffForm;

const
  CfgTempFileName = 'temp.pas';

implementation

uses JvJVCLUtils, RDBUtils, CalcSettings, PmCfgUpdater, fDiff;

{$R *.dfm}

var
  StateColors: array[1..4] of TColor = (clMaroon, clGreen, clNavy, clRed);

procedure TCfgDiffForm.dgDiffDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  Bmp: TBitmap;
  i: integer;
begin
  if Column.FieldName = 'FileState' then begin
    (Sender as TDBGridEh).Canvas.FillRect(Rect);
    i := NvlInteger(Column.Field.Value);
    Bmp := StateClip.GraphicCell[i - 1];
    DrawBitmapTransparent((Sender as TDBGridEh).Canvas, (Rect.Left + Rect.Right - Bmp.Width) div 2,
      (Rect.Top + Rect.Bottom - Bmp.Height) div 2, Bmp, clFuchsia);
  end;
end;

procedure TCfgDiffForm.FormCreate(Sender: TObject);
begin
  FormStorage.AppStorage := TSettingsManager.Instance.Storage;
end;

procedure TCfgDiffForm.dgDiffGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
var
  FileState: integer;
begin
  if not Column.Field.DataSet.IsEmpty then begin
    FileState := Column.Field.DataSet['FileState'];
    AFont.Color := StateColors[FileState];
    if Column.Field.DataSet['Checked'] then
      Background := clYellow;
  end;
end;

procedure TCfgDiffForm.dgDiffColumns3GetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
var
  FileState: integer;
  f: TDateTimeField;
begin
  if not dsDiff.DataSet.IsEmpty then begin
    FileState := dsDiff.DataSet['FileState'];
    if (FileState = fsNewStandard) {or (FileState = fsChangedStandard)} then
      Params.Text := ''
    else begin
      f := dsDiff.DataSet.FieldByName('CurDate') as TDateTimeField;
      Params.Text := FormatDateTime(f.DisplayFormat, f.Value);
    end;
  end;
end;

procedure TCfgDiffForm.dgDiffColumns5GetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
var
  FileState: integer;
  f: TDateTimeField;
begin
  if not dsDiff.DataSet.IsEmpty then begin
    FileState := dsDiff.DataSet['FileState'];
    if (FileState = fsNewCurrent) {or (FileState = fsChangedCurrent)} then
      Params.Text := ''
    else begin
      f := dsDiff.DataSet.FieldByName('FileDate') as TDateTimeField;
      Params.Text := FormatDateTime(f.DisplayFormat, f.Value);
    end;
  end;
end;

procedure TCfgDiffForm.SetDiffDataSet(const Value: TDataSet);
begin
  if FDiffDataSet <> Value then
  begin
    FDiffDataSet := Value;
    dsDiff.DataSet := FDiffDataSet;
    FDiffDataSet.AfterScroll := DataSetAfterScroll;
  end;
end;

procedure TCfgDiffForm.btDiffClick(Sender: TObject);
begin
  DiffForm := TDiffForm.Create(nil);
  try
    DiffForm.File1 := ExtractFilePath(ParamStr(0)) + CfgTempFileName;
    FOnWriteScriptToFile(Self);  // можно было бы передавать как параметр имя файла
    try
      DiffForm.File2 := FDiffDataSet['FilePath'];
      DiffForm.ShowModal;
    finally
      DeleteFile(DiffForm.File1);
    end;
  finally
    DiffForm.Free;
  end;
end;

procedure TCfgDiffForm.DataSetAfterScroll(DataSet: TDataSet);
var
  FileState: integer;
begin
  if not FDiffDataSet.IsEmpty then
  begin
    FileState := dsDiff.DataSet['FileState'];
    btDiff.Enabled := (FileState = fsChangedCurrent) or (FileState = fsChangedStandard);
  end else
    btDiff.Enabled := false;
end;

procedure TCfgDiffForm.FormDestroy(Sender: TObject);
begin
  if FDiffDataSet <> nil then FDiffDataSet.AfterScroll := nil;
end;

procedure TCfgDiffForm.dgDiffColumns1GetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
var
  FileState: integer;
begin
  if not dsDiff.DataSet.IsEmpty then begin
    FileState := dsDiff.DataSet['FileState'];
    if (FileState = fsNewStandard) {or (FileState = fsChangedStandard)} then
      Params.Text := ''
    else
      Params.Text := dsDiff.DataSet['ScriptName'];
  end;
end;

procedure TCfgDiffForm.dgDiffColumnsFileNameGetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
var
  FileState: integer;
begin
  if not dsDiff.DataSet.IsEmpty then
  begin
    FileState := dsDiff.DataSet['FileState'];
    Params.Text := dsDiff.DataSet['FileName'];
  end;
end;

end.
