unit fReportToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseToolbar, JvSpeedbar, JvExControls, JvLabel, ExtCtrls,
  JvExExtCtrls, JvExtComponent;

type
  TReportToolbarFrame = class(TBaseToolbarFrame)
    Toolbar: TJvSpeedBar;
    lbOrderType: TJvLabel;
    SpeedbarSection1: TJvSpeedBarSection;
    siExportToExcel: TJvSpeedItem;
    siCloseReport: TJvSpeedItem;
  private
    { Private declarations }
  public
    constructor Create(Owner: TComponent); override;
  end;

{var
  ReportToolbarFrame: TReportToolbarFrame;}

implementation

{$R *.dfm}

uses PmActions;

constructor TReportToolbarFrame.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetAction(siExportToExcel, TReportActions.ExportToExcel);
  SetAction(siCloseReport, TMainActions.CloseView);
end;

end.
