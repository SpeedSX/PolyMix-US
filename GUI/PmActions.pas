unit PmActions;

interface

uses Classes, ActnList, Variants, Menus;

type
  TActionArray = array of TAction;
  TStringArray = array of string;

  TMainActions = class
  public
    const
      Customers = 'acCustomers';
      Contractors = 'acContractors';
      Suppliers = 'acSuppliers';
      Quit = 'acExit';
      EntSettings = 'acEntSettings';
      Rates = 'acUE';
      NewConfig = 'acEditConfig';
      OldConfig = 'acUsers';
      GlobalScripts = 'acGScripts';
      UpdateCfg = 'acUpdateCfg';
      InterfaceOptions = 'acInterface';
      CustomReports = 'acCustomReports';
      Reload = 'acRefresh';
      CloseView = 'acCloseView';
    class var Actions: TActionList;
    class function GetAction(Name: string): TAction;
    class function GetActions(Names: array of string): TActionArray;
    class procedure SetActionsEnabled(Actions: TStringArray; Enabled: boolean);
    class procedure SetAction(Item: TMenuItem; ActionName: string);
  end;

  TOrderActions = class
  public
    const
      New = 'acNewOrder';
      Delete = 'acDelOrder';
      Copy = 'acCopyOrder';
      Save = 'acSaveOrder';
      Cancel = 'acCancelOrder';
      EditProperties = 'acOrderProps';
      Edit = 'acEditOrder';
      Check = 'acCheckOrder';
      SetPrices = 'acSetPrices';
      Export = 'acExportOrder';
      Import = 'acImportOrder';
      MakeWork = 'acMakeWork';
      MakeDraft = 'acMakeCalc';
      MakeInvoice = 'acMakeInvoice';
      EditInvoice = 'acEditOrderInvoice';
      PayInvoice = 'acPayInvoice';
      Print = 'acPrint';
      History = 'acHistory';
    class function All: TStringArray;
  end;

  TInvoiceActions = class
  public
    const
      New = 'acNewInvoice';
      Delete = 'acDeleteInvoice';
      Edit = 'acEditInvoice';
      PrintForm = 'acPrintInvoiceForm';
      PrintReport = 'acPrintInvoiceReport';
      PayInvoice = 'acPayInvoice';
  end;

  TPaymentActions = class
  public
    const
      New = 'acNewIncome';
      Delete = 'acDeleteIncome';
      Edit = 'acEditIncome';
      PrintOrders = 'acPrintOrders';
      PrintIncomes = 'acPrintIncomes';
      EditInvoice = 'acEditPaymentInvoice';
  end;

  TProductionActions = class
  public
    const
      Print = 'acPrintProduction';
  end;

  TScheduleActions = class
  public
    const
      Add = 'acAddJob';
      Edit = 'acEditJob';
      Remove = 'acRemoveJob';
      Print = 'acPrintSchedule';
      Split = 'acSplitJob';
      OpenOrder = 'acOpenOrderJob';
      EditComment = 'acEditCommentJob';
      Undo = 'acUndo';
      Lock = 'acLockSchedule';
      Unlock = 'acUnlockSchedule';
  end;

  TRecycleBinActions = class
  public
    const
      Restore = 'acRestore';
      Purge = 'acPurge';
      PurgeAll = 'acPurgeAll';
  end;

  TReportActions = class
  public
    const
      ExportToExcel = 'acExportToExcel';
  end;

  TShipmentActions = class
    const
      New = 'acNewShipment';
      Edit = 'acEditShipment';
      Delete = 'acDeleteShipment';
      PrintReport = 'acShipmentReport';
      PrintForm = 'acShipmentForm';
      OpenOrder = 'acOpenShipmentOrder';
  end;

  TSaleActions = class
    const
      New = 'acNewSaleDoc';
      Edit = 'acEditSaleDoc';
      Delete = 'acDeleteSaleDoc';
      PrintForm = 'acPrintSaleDocForm';
      PrintReport = 'acPrintSaleReport';
  end;

  TStockActions = class
    const
      New = 'acNewStock';
      Edit = 'acEditStock';
      Delete = 'acDeleteStock';
      PrintReport = 'acPrintStockReport';
      PrintForm = 'acPrintStockForm';
  end;

  TStockMoveActions = class
    const
      PrintReport = 'acPrintStockMoveReport';
  end;

  TStockIncomeActions = class
    const
      New = 'acNewStockIncome';
      Edit = 'acEditStockIncome';
      Delete = 'acDeleteStockIncome';
      PrintForm = 'acPrintStockIncomeForm';
      PrintReport = 'acPrintStockIncomeReport';
  end;

  TStockWasteActions = class
    const
      New = 'acNewStockWaste';
      Edit = 'acEditStockWaste';
      Delete = 'acDeleteStockWaste';
      PrintForm = 'acPrintStockWasteForm';
      PrintReport = 'acPrintStockWasteReport';
  end;

  TMaterialRequestActions = class
    const
      Edit = 'acEditMatRequest';
      Delete = 'acDeleteMatRequest';
      OpenOrder = 'acOpenMatRequestOrder';
      Save = 'acSaveMatRequests';
      Cancel = 'acCancelMatRequests';
      PrintReport = 'acPrintMatRequestsReport';
  end;

  TConfigActions = class
    const
      SaveConfig = 'acSaveConfig';
  end;

implementation

uses ExHandler;

class function TMainActions.GetAction(Name: string): TAction;
var
  I: Integer;
begin
  for I := 0 to Actions.ActionCount - 1 do
  begin
    Result := Actions[I] as TAction;
    if Result.Name = Name then
      Exit;
  end;
  ExceptionHandler.Raise_('Action not found ' + Name);
end;

class function TMainActions.GetActions(Names: array of string): TActionArray;
var
  I: Integer;
begin
  SetLength(Result, Length(Names));
  for I := Low(Names) to High(Names) do
    Result[I] := GetAction(Names[I]);
end;

class procedure TMainActions.SetActionsEnabled(Actions: TStringArray; Enabled: boolean);
var
  I: Integer;
begin
  for I := Low(Actions) to High(Actions) do
    GetAction(Actions[I]).Enabled := Enabled;
end;

class procedure TMainActions.SetAction(Item: TMenuItem; ActionName: string);
var
  SaveCaption: string;
begin
  SaveCaption := Item.Caption;
  Item.Action := TMainActions.GetAction(ActionName);
  Item.Caption := SaveCaption;
end;

function ReturnArray(arr: TStringArray): TStringArray;
begin
  Result := Arr;
end;

class function TOrderActions.All: TStringArray;
begin
  Result := VarArrayOf([TOrderActions.New, Delete, Copy, Save, EditProperties, Edit, Check, SetPrices,
    Export, Import, MakeWork, MakeDraft, MakeInvoice, EditInvoice, PayInvoice,
    Print, History]);
end;

end.
