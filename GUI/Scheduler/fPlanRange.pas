unit fPlanRange;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, JvExMask, JvToolEdit;

type
  TPlanRangeForm = class(TForm)
    GroupBox1: TGroupBox;
    rbDay: TRadioButton;
    rbDateRange: TRadioButton;
    deFrom: TJvDateEdit;
    deTo: TJvDateEdit;
    Label1: TLabel;
    btOk: TButton;
    btCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PlanRangeForm: TPlanRangeForm;

function ExecPlanRangeForm(var DayOnly: boolean; var FromDate, ToDate: TDateTime): boolean;

implementation

{$R *.dfm}

function ExecPlanRangeForm(var DayOnly: boolean; var FromDate, ToDate: TDateTime): boolean;
var
  EForm: TPlanRangeForm;
begin
  EForm := TPlanRangeForm.Create(nil);
  try
    if DayOnly then
      EForm.rbDay.Checked := true
    else
      EForm.rbDateRange.Checked := true;
    EForm.deFrom.Date := FromDate;
    EForm.deTo.Date := ToDate;
    Result := EForm.ShowModal = mrOk;
    if Result then
    begin
      DayOnly := EForm.rbDay.Checked;
      if not DayOnly then
      begin
        FromDate := EForm.deFrom.Date;
        ToDate := EForm.deTo.Date;
      end;
    end;
  finally
    EForm.Free;
  end;
end;

end.
