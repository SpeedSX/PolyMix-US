unit PmStockIncomeDocController;

interface

uses Classes, Variants, Forms,

  PmOrderInvoiceItems, PmStockIncome, PmStockIncomeItems, PmSaleDocForm, PmSaleItemForm,
  PmDocController, PmEntity, PmDocument, PmDocEditForm, PmDocItemEditForm,
  PmStockIncomeDocEditForm, PmStockIncomeDocItemEditForm;

type
  // редактирование приходной накладной
  TStockIncomeDocController = class(TDocController)
  protected
    procedure CheckItemSource; override;
    function GetFormClass: TDocEditFormClass; override;
    function GetItemFormClass: TDocItemEditFormClass; override;
  public
    destructor Destroy; override;
  end;

implementation

uses SysUtils, Controls, Dialogs, DateUtils,

  CalcUtils, RDialogs, PmDatabase, MainFilter, RDBUtils, StdDic,
  PmConfigManager;

destructor TStockIncomeDocController.Destroy;
begin
  //FreeAndNil(FItemSource);
  inherited;
end;

procedure TStockIncomeDocController.CheckItemSource;
begin
  FItemSourceData := TConfigManager.Instance.StandardDics.deExternalMaterials.DicItems;
end;

function TStockIncomeDocController.GetFormClass: TDocEditFormClass;
begin
  Result := TStockIncomeDocEditForm;
end;

function TStockIncomeDocController.GetItemFormClass: TDocItemEditFormClass;
begin
  Result := TStockIncomeDocItemEditForm;
end;

end.
