unit SrcDFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TSrcDimForm = class(TForm)
    GroupBox1: TGroupBox;
    rbEmpty: TRadioButton;
    rbCopy: TRadioButton;
    edSrc: TEdit;
    udSrc: TUpDown;
    btOk: TButton;
    btCancel: TButton;
    procedure btOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    DestCode, SrcCode: integer;
  end;

var
  SrcDimForm: TSrcDimForm;

function ExecSrcDimDlg(DestCode: integer): integer;

implementation

uses RDialogs;

{$R *.DFM}

function ExecSrcDimDlg(DestCode: integer): integer;
begin
  Application.CreateForm(TSrcDimForm, SrcDimForm);
  try
    SrcDimForm.DestCode := DestCode;
    SrcDimForm.ShowModal;
    Result := SrcDimForm.SrcCode;
  finally
    FreeAndNil(SrcDimForm);
  end;
end;

procedure TSrcDimForm.btOkClick(Sender: TObject);
begin
  if rbCopy.Checked and (udSrc.Position = DestCode) then begin
    RusMessageDlg('Ќельз€ скопировать значение само в себ€', mtError, [mbOk], 0);
    ModalResult := mrNone;
  end else begin
    if rbCopy.Checked then SrcCode := udSrc.Position
    else SrcCode := -1;
  end;
end;

procedure TSrcDimForm.FormActivate(Sender: TObject);
begin
  SrcCode := -1;
end;

end.
