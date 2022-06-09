unit fOrderFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  PmOrder, DBGridEhGrouping, StdCtrls, DBCtrls, GridsEh, DBGridEh, MyDBGridEh,
  Buttons;

type
  TOrderFilesForm = class(TForm)
    Label4: TLabel;
    dgAttached: TMyDBGridEh;
    Label5: TLabel;
    memoFileDesc: TDBMemo;
    btOpenFile: TBitBtn;
    btOk: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure btOpenFileClick(Sender: TObject);
  private
    FOrder: TOrder;
    FInitialized: boolean;
  public
    property Order: TOrder read FOrder write FOrder;
  end;

var
  OrderFilesForm: TOrderFilesForm;

procedure ExecOrderFilesForm(Order: TOrder);

implementation

uses PmOrderController;

{$R *.dfm}

procedure ExecOrderFilesForm(Order: TOrder);
begin
  Application.CreateForm(TOrderFilesForm, OrderFilesForm);
  try
    OrderFilesForm.Order := Order;
    OrderFilesForm.ShowModal;
  finally
    OrderFilesForm.Free;
  end;
end;

procedure TOrderFilesForm.btOpenFileClick(Sender: TObject);
begin
  TOrderController.OpenAttachedFile(Order);
end;

procedure TOrderFilesForm.FormActivate(Sender: TObject);
begin
  if FInitialized then Exit;

  dgAttached.DataSource := Order.AttachedFiles.DataSource;
  FInitialized := true;
end;

end.
