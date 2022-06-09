unit PmSaleView;

interface

uses Classes, Controls, Forms, SysUtils, JvAppStorage, Dialogs, ExtCtrls,
  JvSpeedBar,

  NotifyEvent, fBaseFrame, PmEntity, PmEntityController, fSaleFrame, PmSaleItems,
  PmCustomerOrders, fSaleToolbar, PmSaleDocs, PmDocController, PmDocumentView,
  MainFilter;

type
  TSaleView = class(TDocumentView)
  private
    //FCustomerOrders: TCustomerInvoiceOrders;
    FToolbarFrame: TSaleToolbar;
    function GetFrame: TSaleFrame;
    function GetSaleDocs: TSaleDocs;
    //procedure FilterChange;
    //procedure DisableFilter;
    //procedure DoNewSaleDoc(Sender: TObject);
    //procedure DoDeleteSaleDoc(Sender: TObject);
    //procedure DoEditSaleDoc(Sender: TObject);
    //procedure DoPrintShipmentReport(Sender: TObject);
    //procedure DoPrintSaleForm(Sender: TObject);
    //procedure GoToOrder(Sender: TObject);
    //procedure EditSaleDoc(SaleDocID: integer);
    //procedure DoOpenOrder(Sender: TObject);
    //procedure NewSaleDoc(CurCustomer: integer);
  protected
    function GetControllerClass: TDocControllerClass; override;
    function GetFilterClass: TFilterClass; override;
    function GetEditAction: string; override;
    function GetNewAction: string; override;
    function GetDeleteAction: string; override;
    function GetPrintFormAction: string; override;
    function GetPrintReportAction: string; override;
    function GetFormScriptID: string; override;
    function GetFrameClass: TBaseFrameClass; override;
    //function GetReportScriptID: string; override;  not implemented
  public
    constructor Create(_Entity: TEntity); override;
    function GetToolbar: TjvSpeedbar; override;

    property Frame: TSaleFrame read GetFrame;
    property SaleDocs: TSaleDocs read GetSaleDocs;
  end;

implementation

uses Variants, DB, DateUtils,

  CalcUtils, RDialogs, PmDatabase, PmAppController,
  DicObj, StdDic, RDBUtils,  
  CalcSettings, PmActions, PmScriptManager, PmSaleDocController;

constructor TSaleView.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  FCaption := 'Реализация';
end;

function TSaleView.GetEditAction: string;
begin
  Result := TSaleActions.Edit;
end;

function TSaleView.GetNewAction: string;
begin
  Result := TSaleActions.New;
end;

function TSaleView.GetDeleteAction: string;
begin
  Result := TSaleActions.Delete;
end;

function TSaleView.GetPrintFormAction: string;
begin
  Result := TSaleActions.PrintForm;
end;

function TSaleView.GetPrintReportAction: string;
begin
  Result := TSaleActions.PrintReport;
end;

function TSaleView.GetFrame: TSaleFrame;
begin
  Result := TSaleFrame(FFrame);
end;

function TSaleView.GetSaleDocs: TSaleDocs;
begin
  Result := Entity as TSaleDocs;
end;

function TSaleView.GetToolbar: TjvSpeedbar;
begin
  if FToolbarFrame = nil then
    FToolbarFrame := TSaleToolbar.Create(nil);
  Result := FToolbarFrame.Toolbar;
end;

function TSaleView.GetFormScriptID: string;
begin
  Result := TScriptManager.PrintSaleDocForm;
end;

// переход на выбранный заказ
{procedure TShipmentInvoiceView.GoToOrder(Sender: TObject);
begin
  if not ShipmentDoc.IsEmpty then
  begin
    AppController.EditWorkOrder(ShipmentDoc.OrderID);
  end;
end;

procedure TShipmentView.DoOpenOrder(Sender: TObject);
var
  OrderID: variant;
begin
  OrderID := ShipmentDoc.OrderID;
  if not VarIsNull(OrderID) then
  begin
    AppController.EditWorkOrder(OrderID);
  end;
end;}

function TSaleView.GetFrameClass: TBaseFrameClass;
begin
  Result := TSaleFrame;
end;

function TSaleView.GetControllerClass: TDocControllerClass;
begin
  Result := TSaleDocController;
end;

function TSaleView.GetFilterClass: TFilterClass;
begin
  Result := TShipmentFilterObj;
end;

end.
