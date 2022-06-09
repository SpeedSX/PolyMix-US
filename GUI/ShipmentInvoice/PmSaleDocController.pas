unit PmSaleDocController;

interface

uses Classes, Variants, Forms,

  PmOrderInvoiceItems, PmSaleDocs, PmSaleItems, PmSaleDocForm, PmSaleItemForm,
  PmDocController, PmEntity, PmDocument, PmDocEditForm, PmDocItemEditForm;

type
  // �������������� ��������� ��������
  TSaleDocController = class(TDocController)
  protected
    FItemSource: TEntity;
    procedure CheckItemSource; override;
    {function ExecAddItemForm: boolean; override;
    function ExecEditItemForm: boolean; override;
    // ���������� ����� �������� ��������� ����������.
    function ExecNewDocForm(_OnAddItem,
      _OnEditItem, _OnRemoveItem: TNotifyEvent): boolean;
    // ���������� ����� �������������� ��������� ����������.
    function ExecEditDocForm(_OnAddItem,
      _OnEditItem, _OnRemoveItem: TNotifyEvent): boolean;}
    function GetFormClass: TDocEditFormClass; override;
    function GetItemFormClass: TDocItemEditFormClass; override;
  public
    destructor Destroy; override;
    // � ������ �������������� ���������� _InvoiceItemID, ��� ����� ������� = 0
    class function OpenCustomerOrders(_CustomerID, _PayType, _InvoiceItemID: integer): TOrderInvoiceItems;
    //property SaleDocs: TSaleDocs read FSaleDocs write FSaleDocs;   // ��������� ��� ��������������
  end;

implementation

uses SysUtils, Controls, Dialogs, DateUtils,

  CalcUtils, RDialogs, PmDatabase, MainFilter, RDBUtils, StdDic,
  PmConfigManager;

destructor TSaleDocController.Destroy;
begin
  FreeAndNil(FItemSource);
  inherited;
end;

procedure TSaleDocController.CheckItemSource;
begin
  if FItemSource <> nil then
  begin
    if ((FItemSource as TOrderInvoiceItems).Criteria.CustomerID <> FDocs.ContragentID)
      or ((FItemSource as TOrderInvoiceItems).Criteria.PayType <> FDocs.PayType) then
      FreeAndNil(FItemSource);
  end;
  if FItemSource = nil then
  begin
    FItemSource := OpenCustomerOrders(FDocs.ContragentID, FDocs.PayType, NvlInteger((FDocs as TSaleDocs).SaleItems.InvoiceItemID));
  end;
  FItemSourceData := FItemSource.DataSet;
end;

class function TSaleDocController.OpenCustomerOrders(_CustomerID, _PayType, _InvoiceItemID: integer): TOrderInvoiceItems;
var
  FCustomerOrders: TOrderInvoiceItems;
  Criteria: TOrderInvoiceItemsCriteria;
begin
  Criteria := TOrderInvoiceItemsCriteria.Default;
  FCustomerOrders := TOrderInvoiceItems.Create;
  Criteria.CustomerID := _CustomerID;
  Criteria.PayType := _PayType;
  Criteria.ForSale := true;
  Criteria.SaleInvoiceItemID := _InvoiceItemID;
  Criteria.Mode := TOrderInvoiceItemsCriteria.Mode_Normal;
  FCustomerOrders.Criteria := Criteria;
  FCustomerOrders.Open;
  Result := FCustomerOrders;
end;

function TSaleDocController.GetFormClass: TDocEditFormClass;
begin
  Result := TSaleDocForm;
end;

function TSaleDocController.GetItemFormClass: TDocItemEditFormClass;
begin
  Result := TSaleItemForm;
end;

end.
