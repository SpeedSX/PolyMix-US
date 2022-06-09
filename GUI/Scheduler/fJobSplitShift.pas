unit fJobSplitShift;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PmJobParams;

type
  TJobSplitShiftForm = class(TForm)
    GroupBox1: TGroupBox;
    rbN: TRadioButton;
    rbMult: TRadioButton;
    rbColor: TRadioButton;
    btOk: TButton;
    btCancel: TButton;
    Label1: TLabel;
    lbOrderNumber: TLabel;
    lbJobComment: TLabel;
    rbAtShiftStart: TRadioButton;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ExecJobSplitShiftForm(var SplitMode: TSplitMode; var AtShiftStart: boolean;
  AllowSplitQuantity, AllowSplitMult, AllowSplitSide: boolean; Job: TJobParams;
  ShiftStart: TDateTime): boolean;

implementation

uses PlanUtils;

{$R *.dfm}

function ExecJobSplitShiftForm(var SplitMode: TSplitMode; var AtShiftStart: boolean;
  AllowSplitQuantity, AllowSplitMult, AllowSplitSide: boolean; Job: TJobParams;
  ShiftStart: TDateTime): boolean;
var
  EForm: TJobSplitShiftForm;
begin
  EForm := TJobSplitShiftForm.Create(nil);
  try
    EForm.btCancel.Enabled := false;
    EForm.rbN.Enabled := AllowSplitQuantity;
    EForm.rbMult.Enabled := AllowSplitMult;//not HasMultSplitMode or VarIsNull(SplitPartMult);
    EForm.rbColor.Enabled := AllowSplitSide;//not HasSideSplitMode or VarIsNull(SplitPartSide);
    EForm.lbOrderNumber.Caption := Job.OrderNumber + ' ' + PlanUtils.GetPartName(Job, false);
    EForm.lbJobComment.Caption := Job.Comment;
    if EForm.rbN.Enabled then
      EForm.rbN.Checked := true
    else if EForm.rbMult.Enabled then
      EForm.rbMult.Checked := true
    else if EForm.rbColor.Enabled then
      EForm.rbColor.Checked := true
    else
      EForm.rbAtShiftStart.Checked := true;
    Result := EForm.ShowModal = mrOk;
    if Result then
    begin
      AtShiftStart := false;
      if EForm.rbN.Checked then SplitMode := smQuantity
      else if EForm.rbMult.Checked then SplitMode := smMultiplier
      else if EForm.rbColor.Checked then SplitMode := smSide
      else AtShiftStart := true;
    end;
  finally
    EForm.Free;
  end;
end;

end.
