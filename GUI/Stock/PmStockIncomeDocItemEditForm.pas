unit PmStockIncomeDocItemEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PmDocItemEditForm, DBGridEh, DB, JvComponentBase, JvFormPlacement,
  DBCtrls, StdCtrls, Mask, DBCtrlsEh, DBLookupEh,

  DicObj, PmDocument, PmStockIncomeItems;

type
  TStockIncomeDocItemEditForm = class(TDocItemEditForm)
    edMatUnit: TDBEdit;
    Label6: TLabel;
    edItemPrice: TDBEdit;
    cbManualFix: TDBCheckBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure SetItems(Value: TDocumentItems); override;
    procedure DoOnSourceChanged; override;
  public
    function ValidateForm: boolean; override;
  end;

implementation

{$R *.dfm}

uses RDBUtils, PmConfigManager;

function TStockIncomeDocItemEditForm.ValidateForm: boolean;
var
  de: TDictionary;
begin
  ActiveControl := btOk;
  Result := NvlInteger(comboSource.KeyValue) > 0;
  if not Result then
  begin
    ActiveControl := comboSource;
    raise Exception.Create('ѕожалуйста, укажите номенклатуру материала');
  end
  else
  begin
    Result := NvlFloat((Items as TStockIncomeItems).Quantity) > 0;
    if not Result then
    begin
      ActiveControl := edQuantity;
      raise Exception.Create('ѕожалуйста, укажите количество');
    end
    else
    begin
      // провер€ем, чтобы не выбрали группу
      de := TConfigManager.Instance.StandardDics.deExternalMaterials;
      Result := not de.DicItems.TreeNodeHasChildren;
      if not Result then
      begin
        ActiveControl := comboSource;
        raise Exception.Create('¬ыбрана группа материалов');
      end;
    end;
  end;
end;

procedure TStockIncomeDocItemEditForm.FormCreate(Sender: TObject);
begin
  inherited;
  lbEditableName.Visible := false;
  edItemText.Visible := false;
end;

procedure TStockIncomeDocItemEditForm.SetItems(Value: TDocumentItems);
begin
  inherited;
  edMatUnit.DataSource := FItems.DataSource;
  edItemPrice.DataSource := FItems.DataSource;
  cbManualFix.DataSource := FItems.DataSource;
end;

procedure TStockIncomeDocItemEditForm.DoOnSourceChanged;
begin
  // устанавливаем параметры только если это друга€ запись.
  // дл€ того чтобы не испортить значени€ при редактировании существующего
  if (FItems as TStockIncomeItems).MatCode <> FItemSourceData[F_DicItemCode] then
  begin
    (FItems as TStockIncomeItems).MatCode := FItemSourceData[F_DicItemCode];
    //(FItems as TStockIncomeItems).ItemPrice := FItemSourceData[TStandardDics.F_MatPrice];
    //(FItems as TStockIncomeItems).MatUnitCode := FItemSourceData[TStandardDics.F_MatUnitCode];
    //(FItems as TStockIncomeItems).MatName := FItemSourceData[F_DicItemName];
  end;
end;

end.
