unit PmMessageDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, JvExStdCtrls, JvHtControls;

type
  TMessageDialog = class(TForm)
    btClose: TBitBtn;
    Memo1: TMemo;
  private
    { Private declarations }
  public
    class procedure ShowMessage(const Msg: string);
  end;

var
  MessageDialog: TMessageDialog;

implementation

{$R *.dfm}

class procedure TMessageDialog.ShowMessage(const Msg: string);
begin
  MessageDialog := TMessageDialog.Create(nil);
  try
    MessageDialog.Memo1.Lines.Text := Msg;
    MessageDialog.ShowModal;
  finally
    MessageDialog.Free;
  end;
end;

end.
