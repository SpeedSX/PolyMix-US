unit PmStockIncomeDocEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PmDocEditForm, DB, JvComponentBase, JvFormPlacement, Buttons,
  GridsEh, DBGridEh, MyDBGridEh, JvExControls, JvDBLookup, JvExMask, JvToolEdit,
  JvMaskEdit, JvCheckedMaskEdit, JvDatePickerEdit, JvDBDatePickerEdit, Mask,
  DBCtrls, StdCtrls, DBCtrlsEh, DBLookupEh,

  PmContragent, PmDocument, DBGridEhGrouping;

type
  TStockIncomeDocEditForm = class(TDocEditForm)
    cbWare: TDBLookupComboboxEh;
    lbWare: TLabel;
    dsWare: TDataSource;
    procedure FormCreate(Sender: TObject);
  private
  protected
    function GetContragents: TContragents; override;
    procedure SetDoc(Value: TDocument); override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses PmConfigManager;

procedure TStockIncomeDocEditForm.FormCreate(Sender: TObject);
begin
  inherited;
  dsWare.DataSet := TConfigManager.Instance.StandardDics.deWarehouse.DicItems;
end;

function TStockIncomeDocEditForm.GetContragents: TContragents;
begin
  Result := Suppliers;
end;

procedure TStockIncomeDocEditForm.SetDoc(Value: TDocument);
begin
  inherited SetDoc(Value);
  cbWare.DataSource := Value.DataSource;
end;

end.
