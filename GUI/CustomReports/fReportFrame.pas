unit fReportFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseFrame, ExtCtrls, PmReportData, DB, StdCtrls, Buttons, GridsEh,
  DBGridEh, MyDBGridEh, JvFormPlacement,

  PmEntity;

type
  TReportFrame = class(TBaseFrame)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn2: TBitBtn;
    btXL: TBitBtn;
    dgReport: TMyDBGridEh;
    dsReport: TDataSource;
    Label1: TLabel;
    cbAutoFit: TCheckBox;
    //procedure btXLClick(Sender: TObject);
    procedure cbAutoFitClick(Sender: TObject);
    procedure btXLClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    //FReportData: TReportData;
    function ReportData: TReportData;
  public
    constructor Create(Owner: TComponent; _ReportData: TEntity); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses PmActions, CalcUtils, CalcSettings;

constructor TReportFrame.Create(Owner: TComponent; _ReportData: TEntity);
begin
  inherited Create(Owner, _ReportData{GetComponentName(Owner, 'frCustomReport')});
  //FReportData := _ReportData;
  dsReport.DataSet := ReportData.DataSet;
  paFilter.Visible := false;
  // Первые два поля не показываем
  dgReport.Columns[0].Visible := false;
  dgReport.Columns[1].Visible := false;
  OptimizeColumns(dgReport);
end;

destructor TReportFrame.Destroy;
begin
  inherited Destroy;
end;

{procedure TReportFrame.btXLClick(Sender: TObject);
begin
  CustomReportBuilder.ReportToExcel;
end;}

procedure TReportFrame.BitBtn2Click(Sender: TObject);
begin
  TMainActions.GetAction(TMainActions.CloseView).Execute;
end;

procedure TReportFrame.btXLClick(Sender: TObject);
begin
  TMainActions.GetAction(TReportActions.ExportToExcel).Execute;
end;

procedure TReportFrame.cbAutoFitClick(Sender: TObject);
begin
  dgReport.AutoFitColWidths := cbAutoFit.Checked;
end;

function TReportFrame.ReportData: TReportData;
begin
  Result := Entity as TReportData;
end;

end.
