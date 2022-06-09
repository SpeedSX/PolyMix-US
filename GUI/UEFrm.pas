unit UEFrm;

{$I Calc.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, Mask, JvToolEdit, JvBaseEdits, JvExStdCtrls,
  JvEdit, JvValidateEdit;

type
  TUEForm = class(TForm)
    lbAppCourse: TLabel;
    lbGlobalCap: TLabel;
    edAppCourse: TjvValidateEdit;
    edOrdCourse: TjvValidateEdit;
    lbOrdCourse: TLabel;
    btViewCourse: TSpeedButton;
    lbSrvCourse: TLabel;
    Bevel1: TBevel;
    btOk: TButton;
    btCancel: TButton;
    btSetSrvCourse: TBitBtn;
    Bevel2: TBevel;
    procedure btViewCourseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UEForm: TUEForm;

function ExecUEForm(var SrvCourse, AppCourse, OrdCourse: extended;
  AllowEdit: boolean): integer;

implementation

{$IFNDEF Demo}
uses CoursFrm;
{$ENDIF}
{$R *.DFM}

function ExecUEForm(var SrvCourse, AppCourse, OrdCourse: extended;
  AllowEdit: boolean): integer;
begin
  Application.CreateForm(TUEForm, UEForm);
  try
    with UEForm do
    begin
      if OrdCourse < 0 then
      begin  // Если < 0, то не вошли в заказ
        lbOrdCourse.Enabled := false;
        edOrdCourse.Value := 0;
        edOrdCourse.Enabled := false;
      end
      else
        edOrdCourse.Value := OrdCourse;
      edAppCourse.ReadOnly := not AllowEdit;
      edOrdCourse.ReadOnly := not AllowEdit;
      btSetSrvCourse.Enabled := AllowEdit;
      edAppCourse.Value := AppCourse;
      lbSrvCourse.Caption := FloatToStrF(SrvCourse, ffFixed, 5, 2);
      ActiveControl := btOk;
      Result := UEForm.ShowModal;
      // mrYes означает установку курса на сервере
      if (Result = mrOk) or (Result = mrYes) and AllowEdit then
      begin
        AppCourse := edAppCourse.Value;
        {if OrdCourse > 0 then }
          OrdCourse := edOrdCourse.Value;
      end;
    end;
  finally
    FreeAndNil(UEForm);
  end;
end;

procedure TUEForm.btViewCourseClick(Sender: TObject);
begin
{$IFNDEF Demo}
  ExecCourseForm;
{$ENDIF}
end;

end.
