unit fOrderProductStorageFrom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEhGrouping, StdCtrls, GridsEh, DBGridEh, MyDBGridEh,
  JvInterpreter_CustomQuery, JvComponentBase, JvFormPlacement, ServMod, PmEntity,
  DB, DBClient, PmDatabase, Mask, JvExMask, JvToolEdit, JvBaseEdits;

type
  TOrderProductStorageFrom = class(TForm)
    FormStorage: TJvFormStorage;
    gdProductList: TMyDBGridEh;
    btCancel: TButton;
    btOk: TButton;
    Label5: TLabel;
    Label1: TLabel;
    edProductFind: TEdit;
    edQty: TJvCalcEdit;
    Label2: TLabel;
    procedure edProductFindChange(Sender: TObject);
  private
    { Private declarations }
  public
     qProductList : TDataSet;
    { Public declarations }

  end;

var
  OrderProductStorageFrom: TOrderProductStorageFrom;

implementation

{$R *.dfm}

procedure TOrderProductStorageFrom.edProductFindChange(Sender: TObject);
begin
  gdProductList.DataSource.DataSet.Filtered := false;
  if edProductFind.Text<>'' then
  begin
    gdProductList.DataSource.DataSet.Filter :='Name LIKE ''' + edProductFind.Text + '%''';
    gdProductList.DataSource.DataSet.Filtered:=true;
  end;
end;

end.
