unit PmReportPreview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DB, Grids, DBGridEh, MyDBGridEh, GridsEh;

type
  TReportPreviewForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn2: TBitBtn;
    btXL: TBitBtn;
    dgReport: TMyDBGridEh;
    dsReport: TDataSource;
    Label1: TLabel;
    cbAutoFit: TCheckBox;
    procedure cbAutoFitClick(Sender: TObject);
  private
    //
  public
    constructor Create(cdReport: TDataSet; Hdr: string);
  end;

var
  ReportPreviewForm: TReportPreviewForm;

function ExecCustomReportPreview(cdReport: TDataSet; Hdr: string): boolean;

implementation

{$R *.dfm}

uses CalcUtils;

function ExecCustomReportPreview(cdReport: TDataSet; Hdr: string): boolean;
begin
  ReportPreviewForm := TReportPreviewForm.Create(cdReport, Hdr);
  try
    Result := ReportPreviewForm.ShowModal = mrOk;
  finally
    FreeAndNil(ReportPreviewForm);
  end;
end;

constructor TReportPreviewForm.Create(cdReport: TDataSet; Hdr: string);
begin
  inherited Create(nil);
  dsReport.DataSet := cdReport;
  Caption := Hdr;
  // Первые два поля не показываем
  dgReport.Columns[0].Visible := false;
  dgReport.Columns[1].Visible := false;
  OptimizeColumns(dgReport);
end;

procedure TReportPreviewForm.cbAutoFitClick(Sender: TObject);
begin
  dgReport.AutoFitColWidths := cbAutoFit.Checked;
end;

end.
