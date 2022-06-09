unit PmStockWasteDocEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PmDocEditForm, DB, JvComponentBase, JvFormPlacement, Buttons,
  GridsEh, DBGridEh, MyDBGridEh, JvExControls, JvDBLookup, JvExMask, JvToolEdit,
  JvMaskEdit, JvCheckedMaskEdit, JvDatePickerEdit, JvDBDatePickerEdit, Mask,
  DBCtrls, StdCtrls, DBCtrlsEh, DBLookupEh,

  PmDocument, PmContragent, DBGridEhGrouping;

type
  TStockWasteDocEditForm = class(TDocEditForm)
    lbWare: TLabel;
    cbWare: TDBLookupComboboxEh;
    dsWare: TDataSource;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure SetDoc(Value: TDocument); override;
    function GetContragents: TContragents; override;
  end;

implementation

uses PmConfigManager;

{$R *.dfm}

procedure TStockWasteDocEditForm.FormCreate(Sender: TObject);
begin
  inherited;
  dsWare.DataSet := TConfigManager.Instance.StandardDics.deWarehouse.DicItems;
end;

procedure TStockWasteDocEditForm.SetDoc(Value: TDocument);
begin
  inherited SetDoc(Value);
  cbWare.DataSource := Value.DataSource;
end;

function TStockWasteDocEditForm.GetContragents: TContragents;
begin
  Result := nil;
end;

end.
