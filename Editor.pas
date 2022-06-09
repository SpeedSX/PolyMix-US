unit Editor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TEditForm = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    bSave: TButton;
    bCancel: TButton;
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditForm: TEditForm;

implementation

{$R *.DFM}

procedure TEditForm.Memo1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then ModalResult := mrCancel;
end;

end.
