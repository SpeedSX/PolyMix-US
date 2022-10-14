unit fPaperSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEhGrouping, StdCtrls, GridsEh, DBGridEh, MyDBGridEh,
  JvInterpreter_CustomQuery, JvComponentBase, JvFormPlacement, ServMod, PmEntity,
  DB, DBClient, PmDatabase;

type
  TPaperSelectForm = class(TForm)
    FormStorage: TJvFormStorage;
    gdPaperList: TMyDBGridEh;
    btCancel: TButton;
    btOk: TButton;
    Label5: TLabel;
    Label1: TLabel;
    edPaperFind: TEdit;
    dsPaperList: TDataSource;
    procedure edPaperFindChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PaperSelectForm: TPaperSelectForm;

implementation

{$R *.dfm}

procedure TPaperSelectForm.edPaperFindChange(Sender: TObject);
begin
  dsPaperList.DataSet.Filtered := false;
  if edPaperFind.Text <> '' then
  begin
    dsPaperList.DataSet.Filter :='Name LIKE ''' + edPaperFind.Text + '%''';
    dsPaperList.DataSet.Filtered := true;
  end;

end;

end.

