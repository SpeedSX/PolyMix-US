unit tousdfrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, JvToolEdit, JvBaseEdits, Buttons, JvExStdCtrls, JvEdit,
  JvValidateEdit;

type
  TToUSDForm = class(TForm)
    btOk: TBitBtn;
    btCancel: TBitBtn;
    GroupBox1: TGroupBox;
    rbAll: TRadioButton;
    rbCurSel: TRadioButton;
    rbCurKind: TRadioButton;
    ceDollar: TjvValidateEdit;
    Label1: TLabel;
    rbCurRec: TRadioButton;
    procedure FormActivate(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
  private
    TempCourse: extended;
    TempMode: integer;
    function GetUSDCourse: extended;
    procedure SetUSDCourse(_Course: extended);
    function GetConvertMode: integer;
    procedure SetConvertMode(_Mode: integer);
  public
    property ConvertMode: integer read GetConvertMode write SetConvertMode;
    property USDCourse: extended read GetUSDCourse write SetUSDCourse;
  end;

var
  ToUSDForm: TToUSDForm;

const
  cmAll = 0;
  cmCurSel = 1;
  cmCurKind = 2;
  cmCurRec = 3;

implementation

{$R *.DFM}

function TToUSDForm.GetConvertMode: integer;
begin
  if rbCurSel.Checked then Result := cmCurSel
  else if rbCurKind.Checked then Result := cmCurKind
  else if rbCurRec.Checked then Result := cmCurRec
  else Result := cmAll;
end;

procedure TToUSDForm.SetConvertMode(_Mode: integer);
begin
  if _Mode = cmCurSel then rbCurSel.Checked := true
  else if _Mode = cmCurKind then rbCurKind.Checked := true
  else if _Mode = cmCurRec then rbCurRec.Checked := true
  else rbAll.Checked := true;
end;

function TToUSDForm.GetUSDCourse: extended;
begin
  Result := ceDollar.Value;
end;

procedure TToUSDForm.SetUSDCourse(_Course: extended);
begin
  ceDollar.Value := _Course;
end;

procedure TToUSDForm.FormActivate(Sender: TObject);
begin
  TempCourse := USDCourse;
  TempMode := ConvertMode;
end;

procedure TToUSDForm.btCancelClick(Sender: TObject);
begin
  USDCourse := TempCourse;
  ConvertMode := TempMode;
end;

end.
