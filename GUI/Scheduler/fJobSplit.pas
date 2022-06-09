unit fJobSplit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PmJobParams;

type
  TJobSplitForm = class(TForm)
    GroupBox1: TGroupBox;
    rbN: TRadioButton;
    rbMult: TRadioButton;
    rbColor: TRadioButton;
    btOk: TButton;
    btCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ExecJobSplitForm(var SplitMode: TSplitMode;
  AllowSplitQuantity, AllowSplitMult, AllowSplitSide: boolean): boolean;

implementation

{$R *.dfm}

function ExecJobSplitForm(var SplitMode: TSplitMode;
  AllowSplitQuantity, AllowSplitMult, AllowSplitSide: boolean): boolean;
var
  EForm: TJobSplitForm;
begin
  EForm := TJobSplitForm.Create(nil);
  try
    EForm.rbN.Enabled := AllowSplitQuantity;
    EForm.rbMult.Enabled := AllowSplitMult;//not HasMultSplitMode or VarIsNull(SplitPartMult);
    EForm.rbColor.Enabled := AllowSplitSide;//not HasSideSplitMode or VarIsNull(SplitPartSide);
    if EForm.rbN.Enabled then
      EForm.rbN.Checked := true
    else if EForm.rbMult.Enabled then
      EForm.rbMult.Checked := true
    else if EForm.rbColor.Enabled then
      EForm.rbColor.Checked := true;
    Result := EForm.ShowModal = mrOk;
    if Result then
    begin
      if EForm.rbN.Checked then SplitMode := smQuantity
      else if EForm.rbMult.Checked then SplitMode := smMultiplier
      else SplitMode := smSide;
    end;
  finally
    EForm.Free;
  end;
end;

end.
