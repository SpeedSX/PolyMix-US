unit PmStockWasteDocItemEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PmDocItemEditForm, DBGridEh, DB, JvComponentBase, JvFormPlacement,
  DBCtrls, StdCtrls, Mask, DBCtrlsEh, DBLookupEh, Buttons,

  PmDocument;

type
  TStockWasteDocItemEditForm = class(TDocItemEditForm)
    btSelect: TBitBtn;
    Label1: TLabel;
    comboStock: TDBLookupComboboxEh;
    dsStockItems: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btSelectClick(Sender: TObject);
  private
    //function GetOrderNumber: integer;
    FOnOrderSelected: TNotifyEvent;
  protected
    procedure SetItems(Value: TDocumentItems); override;
  public
    function ValidateForm: boolean; override;
    //property OrderNumber: integer read GetOrderNumber;
    property OnOrderSelected: TNotifyEvent read FOnOrderSelected write FOnOrderSelected;
  end;

implementation

uses RDBUtils, DicObj, PmStockWasteItems, PmConfigManager;

{$R *.dfm}

procedure TStockWasteDocItemEditForm.SetItems(Value: TDocumentItems);
begin
  inherited;
  comboStock.DataSource := FItems.DataSource;
end;

function TStockWasteDocItemEditForm.ValidateForm: boolean;
var
  de: TDictionary;
begin
  ActiveControl := btOk;
  Result := NvlInteger(comboSource.KeyValue) > 0;
  if not Result then
  begin
    ActiveControl := comboSource;
    raise Exception.Create('Пожалуйста, укажите материал в заказе');
  end
  else
  begin
    Result := NvlFloat((Items as TStockWasteItems).Quantity) > 0;
    if not Result then
    begin
      ActiveControl := edQuantity;
      raise Exception.Create('Пожалуйста, укажите количество');
    end
    else
    begin
      Result := NvlInteger(comboStock.KeyValue) > 0;
      if not Result then
      begin
        ActiveControl := comboStock;
        raise Exception.Create('Пожалуйста, укажите номенклатуру материала');
      end;
    end;
  end;
end;

procedure TStockWasteDocItemEditForm.btSelectClick(Sender: TObject);
begin
  FOnOrderSelected(Self);
  if not FItemSourceData.IsEmpty then
    comboSource.KeyValue := FItemSourceData[comboSource.KeyField];
end;

procedure TStockWasteDocItemEditForm.FormCreate(Sender: TObject);
begin
  inherited;
  lbItemCost.Visible := false;
  edItemCost.Visible := false;
  lbItemPrice.Visible := false;
  dtPrice.Visible := false;
  dsStockItems.DataSet := TConfigManager.Instance.StandardDics.deExternalMaterials.DicItems;
end;

{function TStockWasteDocItemEditForm.GetOrderNumber: integer;
begin
  Result :=
end;}

end.
