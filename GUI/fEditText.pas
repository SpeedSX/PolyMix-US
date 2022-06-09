unit fEditText;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvExControls, JvComponent, JvEditorCommon, JvEditor, StdCtrls;

type
  TEditTextForm = class(TForm)
    btSave: TButton;
    btCancel: TButton;
    TextEditor: TMemo;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    RequireText: boolean;
  end;

var
  EditTextForm: TEditTextForm;

function ExecEditText(Caption: string; var _Text: string;
  RequireText: boolean = false): boolean;

implementation

uses RDialogs;

{$R *.dfm}

function ExecEditText(Caption: string; var _Text: string;
  RequireText: boolean = false): boolean;
var
  EForm: TEditTextForm;
begin
  EForm := TEditTextForm.Create(nil);
  try
    EForm.Caption := Caption;
    EForm.TextEditor.Lines.Text := _Text;
    EForm.RequireText := RequireText;
    Result := EForm.ShowModal = mrOk;
    if Result then
      _Text := EForm.TextEditor.Lines.Text;
  finally
    EForm.Free;
  end;
end;

procedure TEditTextForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not RequireText or (ModalResult <> mrOk) or (Trim(TextEditor.Lines.Text) <> '');
  if not CanClose then
    RusMessageDlg('Пожалуйста, введите описание', mtError, [mbOk], 0);
end;

end.
