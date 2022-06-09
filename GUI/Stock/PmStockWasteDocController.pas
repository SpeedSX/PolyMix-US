unit PmStockWasteDocController;

interface

uses Classes, Variants, Forms,

  PmOrderInvoiceItems, PmStockWaste, PmStockWasteItems, PmSaleItemForm,
  PmDocController, PmEntity, PmDocument, PmDocEditForm, PmDocItemEditForm,
  PmStockWasteDocEditForm, PmStockWasteDocItemEditForm, PmMatRequest;

type
  // редактирование приходной накладной
  TStockWasteDocController = class(TDocController)
  protected
    FItemSource: TMaterialRequests;
    FOrderNumber: integer;
    procedure CheckItemSource; override;
    function GetFormClass: TDocEditFormClass; override;
    function GetItemFormClass: TDocItemEditFormClass; override;
    procedure DoItemFormCreated(_Form: TForm); override;
    procedure DoOrderSelected(Sender: TObject);
    class procedure UpdateSourceCriteria(FItemSource: TMaterialRequests; _OrderNumber: integer);
  public
    destructor Destroy; override;
    class function OpenMaterialRequests(_OrderNumber: integer): TMaterialRequests;
  end;

implementation

uses SysUtils, Controls, Dialogs, DateUtils,

  CalcUtils, RDialogs, PmDatabase, MainFilter, RDBUtils, StdDic,
  PmConfigManager;

destructor TStockWasteDocController.Destroy;
begin
  FreeAndNil(FItemSource);
  inherited;
end;

procedure TStockWasteDocController.CheckItemSource;
begin
  if FItemSource <> nil then
  begin
    if (FItemSource.Criteria.udNumEQPosition <> FOrderNumber) then
      UpdateSourceCriteria(FItemSource, FOrderNumber);
  end;
  if FItemSource = nil then
  begin
    FItemSource := OpenMaterialRequests(FOrderNumber);
  end;
  FItemSourceData := FItemSource.DataSet;
end;

class procedure TStockWasteDocController.UpdateSourceCriteria(FItemSource: TMaterialRequests; _OrderNumber: integer);
begin
  FItemSource.Criteria.cbNumChecked := true;
  FItemSource.Criteria.rbNumEQChecked := true;
  FItemSource.Criteria.udNumEQPosition := _OrderNumber;
  FItemSource.Criteria.cbMonthYearChecked := true;
  FItemSource.Criteria.rbCurYearChecked := true;
  FItemSource.Reload;
  // Если в текущем году нет ни одного материала в заказе с указанным номером, то берем за прошлый год
  // TODO: предупреждение?
  if FItemSource.IsEmpty then
  begin
    FItemSource.Criteria.rbYearChecked := true;
    FItemSource.Criteria.rbCurYearChecked := false;
    FItemSource.Criteria.YearValue := YearOf(Now) - 1;
    FItemSource.Reload;
  end;
end;

class function TStockWasteDocController.OpenMaterialRequests(_OrderNumber: integer): TMaterialRequests;
var
  FMatRequests: TMaterialRequests;
  Criteria: TMaterialFilterObj;
begin
  Criteria := TMaterialFilterObj.Create;
  FMatRequests := TMaterialRequests.Create;
  FMatRequests.Criteria := Criteria;
  UpdateSourceCriteria(FMatRequests, _OrderNumber);
  Result := FMatRequests;
end;

function TStockWasteDocController.GetFormClass: TDocEditFormClass;
begin
  Result := TStockWasteDocEditForm;
end;

function TStockWasteDocController.GetItemFormClass: TDocItemEditFormClass;
begin
  Result := TStockWasteDocItemEditForm;
end;

procedure TStockWasteDocController.DoItemFormCreated(_Form: TForm);
begin
  inherited;
  (_Form as TStockWasteDocItemEditForm).OnOrderSelected := DoOrderSelected;
end;

// Изменился номер заказа
procedure TStockWasteDocController.DoOrderSelected(Sender: TObject);
begin
  FOrderNumber := ((FDocs as TStockWaste).Items as TStockWasteItems).OrderNumber;//(Sender as TStockWasteDocItemEditForm).OrderNumber;
  CheckItemSource;
end;

end.
