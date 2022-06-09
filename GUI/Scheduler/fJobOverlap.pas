unit fJobOverlap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TJobOverlapForm = class(TForm)
    lbJob: TLabel;
    Label1: TLabel;
    lbStart: TLabel;
    Label3: TLabel;
    lbFinish: TLabel;
    Label5: TLabel;
    lbLockedJob: TLabel;
    Label7: TLabel;
    lbLockedStart: TLabel;
    Label9: TLabel;
    lbLockedFinish: TLabel;
    GroupBox1: TGroupBox;
    rbAfter: TRadioButton;
    rbSplit: TRadioButton;
    btOk: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

// Возвращает true, если надо разбивать
function ExecJobOverlapForm(JobName: string; JobStart, JobFinish: TDateTime;
  LockedJobName: string; LockedJobStart, LockedJobFinish: TDateTime): boolean;

implementation

{$R *.dfm}

function ExecJobOverlapForm(JobName: string; JobStart, JobFinish: TDateTime;
  LockedJobName: string; LockedJobStart, LockedJobFinish: TDateTime): boolean;
var
  EForm: TJobOverlapForm;
begin
  EForm := TJobOverlapForm.Create(nil);
  try
    EForm.lbJob.Caption := JobName;
    EForm.lbStart.Caption := FormatDateTime('hh:mm', JobStart);
    EForm.lbFinish.Caption := FormatDateTime('hh:mm', JobFinish);
    EForm.lbLockedJob.Caption := LockedJobName;
    EForm.lbLockedStart.Caption := FormatDateTime('hh:mm', LockedJobStart);
    EForm.lbLockedFinish.Caption := FormatDateTime('hh:mm', LockedJobFinish);
    Result := EForm.ShowModal = mrOk;
    if Result then
      Result := EForm.rbSplit.Checked;
  finally
    EForm.Free;
  end;
end;

end.
