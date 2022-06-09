unit PmSaleItemForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseEditForm, JvComponentBase, StdCtrls, DBGridEh, JvFormPlacement,
  Mask, DBCtrlsEh, DBLookupEh, DBCtrls, Buttons, DB,

  PmOrderInvoiceItems, PmSaleItems, PmDocItemEditForm, PmInvoiceItems;

type
  TSaleItemForm = class(TDocItemEditForm)
    btSelectProduct: TBitBtn;
    procedure btSelectProductClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  protected
    function ValidateForm: boolean; override;
    procedure DoOnSourceChanged; override;
  public
  end;

implementation

uses RDBUtils, CalcUtils, StdDic, PmSelectExtMatForm;

{$R *.dfm}

function TSaleItemForm.ValidateForm: boolean;
begin
  ActiveControl := btOk;
  Result := NvlInteger(comboSource.KeyValue) > 0;
  if not Result then
  begin
    ActiveControl := comboSource;
    raise Exception.Create('ѕожалуйста, укажите заказ');
  end
  else
  begin
    Result := NvlInteger((Items as TSaleItems).SaleQuantity) > 0;
    if not Result then
    begin
      ActiveControl := edQuantity;
      raise Exception.Create('ѕожалуйста, укажите количество');
    end;
  end;
end;

procedure TSaleItemForm.btSelectProductClick(Sender: TObject);
//var
//  ExtProductID: variant;
begin
{  ExtProductID := FSaleItems.ExternalProductID;
  if ExecSelectExternalDictionaryForm(ExtProductID, StandardDics.deExternalProducts, '') then
  begin
    FSaleItems.ExternalProductID := ExtProductID;
    if not VarIsNull(FSaleItems.ExternalProductID) then
      FSaleItems.ItemText := StandardDics.deExternalProducts.CurrentName;
    UpdateItemText;
  end;}
end;

{procedure TSaleItemForm.UpdateItemText;
begin
  edItemText.Enabled := VarIsNull(FSaleItems.ExternalProductID);
end;}

procedure TSaleItemForm.DoOnSourceChanged;
begin
  // устанавливаем параметры только если это другой заказ.
  // дл€ того чтобы не испортить значени€ при редактировании существующего
  if (FItems as TSaleItems).InvoiceItemID <> FItemSourceData[TInvoiceItems.F_InvoiceItemKey] then
  begin
    (FItems as TSaleItems).SaleQuantity := FItemSourceData[TOrderInvoiceItems.F_Quantity];
    (FItems as TSaleItems).ItemCost := FItemSourceData[TOrderInvoiceItems.F_ItemCost];
    (FItems as TSaleItems).ItemText := FItemSourceData[TOrderInvoiceItems.F_ItemText];
    (FItems as TSaleItems).OrderNumber := FItemSourceData[TOrderInvoiceItems.F_OrderNumber];
  end;
end;

procedure TSaleItemForm.FormCreate(Sender: TObject);
begin
  btSelectProduct.Glyph := GetSyncStateImage(SyncState_Syncronized);
end;


end.
