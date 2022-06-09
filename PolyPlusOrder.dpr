program PolyPlusOrder;

{$I Calc.inc}

uses
  SysUtils,
  Forms,
  JvJCLUtils,
  TConfiguratorUnit,
  TLoggerUnit,
  MidasLib,
  Controls,
  MainData in 'DataAccess\MainData.pas' {dm: TDataModule},
  OptInt in 'OptInt.pas' {OptIntForm},
  MainForm in 'GUI\MainForm.pas' {MForm},
  DataHlp in 'DataHlp.pas',
  DicUtils in 'Config\DicUtils.pas',
  PmInit in 'PmInit.pas',
  SplForm in 'GUI\SplForm.pas' {Splash},
  RDialogs,
  JvJVCLUtils,
  PmProcess in 'PmProcess.pas',
  UkrUtils,
  ServData in 'DataAccess\ServData.pas' {sdm: TDataModule},
  DicData in 'DataAccess\DicData.pas' {DicDm: TDataModule},
  ChkOrd in 'GUI\Orders\ChkOrd.pas' {ChkOrdForm},
  fTabSrv in 'GUI\Orders\fTabSrv.pas' {frTabSrv: TFrame},
  fTabSrv2 in 'GUI\Orders\fTabSrv2.pas' {frTabSrsv2H: TFrame},
  fSrvTmpl in 'GUI\Orders\fSrvTmpl.pas' {frSrvTemplate: TFrame},
  RepData in 'DataAccess\RepData.pas' {rdm: TDataModule},
  UEFrm in 'GUI\UEFrm.pas' {UEForm},
  fCanRep in 'GUI\fCanRep.pas' {CancelRepForm},
  ColorLst in '..\Common\ColorLst.pas',
  FullOrdRep in 'FullOrdRep.pas',
  fTabSrv3L1 in 'GUI\Orders\fTabSrv3L1.pas' {frTabSrv3L1: TFrame},
  RAI2_CalcSrv in 'Interpreter\RAI2_CalcSrv.pas',
  RAI2_SrvPage in 'Interpreter\RAI2_SrvPage.pas',
  ServMod in 'ServMod.pas' {sm: TDataModule},
  PmAccessManager in 'PmAccessManager.pas',
  RAI2_Mouse in '..\Common\RAI2_Mouse.pas',
  fComInfo in 'GUI\Orders\fComInfo.pas' {frCommonInfo: TFrame},
  RVCLUtils in '..\Common\RVCLUtils.pas',
  CalcUtils in 'CalcUtils.pas',
  ProgressObj in 'ProgressObj.pas',
  JvInterpreter_CustomQuery in 'Interpreter\JvInterpreter_CustomQuery.pas',
  RAI2_JvxCheckListBox in '..\Common\RAI2_JvxCheckListBox.pas',
  fOrderItems in 'GUI\Orders\fOrderItems.pas' {
  DicObj in 'Config\DicObj.pas',
  fPageCost in 'GUI\Orders\fPageCost.pas' {frPageCost},
  DicObj in 'Config\DicObj.pas',
  fPageCost in 'GUI\Orders\fPageCost.pas' {frPageCost: TFrame},
  EnPaint in 'GUI\EnPaint.pas',
  HistFrm in 'GUI\History\HistFrm.pas' {HistoryForm},
  ExHandler in '..\Common\ExHandler.pas',
  NotifyEvent in '..\Common\NotifyEvent.pas',
  PmContragent in 'DataObjects\PmContragent.pas',
  PmUpdate in '..\Common\PmUpdate.pas',
  PmSplash in '..\Common\PmSplash.pas',
  PmContragentPainter in 'GUI\Contragents\PmContragentPainter.pas',
  PmConnect in '..\Common\PmConnect.pas',
  PmChangeLock in '..\Common\PmChangeLock.pas',
  PmASMainData in 'PmASMainData.pas' {SrvDM: TDataModule},
  DBIDList in '..\Common\DBIDList.pas',
  DispInfo in 'Config\DispInfo.pas',
  fDisplayInfo in 'GUI\Config\fDisplayInfo.pas' {EditCommonInfoForm},
  PmCustomReport in 'DataObjects\PmCustomReport.pas',
  fCustomReports in 'GUI\Config\fCustomReports.pas' {EditCustomReportsForm},
  MainFormTest in 'dunit\MainFormTest.pas',
  PmProviders in 'PmProviders.pas',
  fViewImport in 'fViewImport.pas' {ViewImportForm},
  JvInterpreter_UserRights in 'Interpreter\JvInterpreter_UserRights.pas',
  fEntSettings in 'GUI\fEntSettings.pas' {EntSettingsForm},
  PmEntSettings in 'DataObjects\PmEntSettings.pas',
  PmCfgUpdater in 'PmCfgUpdater.pas',
  fCustomReportDetails in 'GUI\Config\fCustomReportDetails.pas' {CustomReportDetailsForm},
  PmCustomReportBuilder in 'PmCustomReportBuilder.pas',
  PmMaterials in 'DataObjects\PmMaterials.pas',
  PmOperations in 'DataObjects\PmOperations.pas',
  PmOrderItemDetails in 'DataObjects\PmOrderItemDetails.pas',
  PmEntity in 'DataObjects\PmEntity.pas',
  PmOrderController in 'GUI\Orders\PmOrderController.pas',
  PmAppController in 'PmAppController.pas',
  OrdProp in 'GUI\Orders\OrdProp.pas' {OrderProp},
  PmPlan in 'DataObjects\PmPlan.pas',
  PmPlanController in 'GUI\Scheduler\PmPlanController.pas',
  fPlanFrame in 'GUI\Scheduler\fPlanFrame.pas' {PlanFrame: TFrame},
  PlanData in 'DataAccess\PlanData.pas' {PlanDM: TDataModule},
  MainFilter in 'MainFilter.pas',
  PmExecCode in 'PmExecCode.pas',
  ProdData in 'DataAccess\ProdData.pas' {ProductionDM: TDataModule},
  fBaseFrame in 'GUI\fBaseFrame.pas' {BaseFrame: TFrame},
  fProdBase in 'GUI\Scheduler\fProdBase.pas' {ProductionBaseFrame: TFrame},
  fBaseFilter in 'GUI\fBaseFilter.pas' {BaseFilterFrame: TFrame},
  fMainFilter in 'GUI\Orders\fMainFilter.pas' {TFilterFrame: TFrame},
  PmProcessEntity in 'DataObjects\PmProcessEntity.pas',
  fProgress in 'GUI\fProgress.pas' {ProgressFrame: TFrame},
  PmRecycleBin in 'DataObjects\PmRecycleBin.pas',
  fBaseRecycleBin in 'GUI\RecycleBin\fBaseRecycleBin.pas' {BaseRecycleBinFrame: TFrame},
  fAddToPlan in 'GUI\Scheduler\fAddToPlan.pas' {AddToPlanForm},
  fEditText in 'GUI\fEditText.pas' {EditTextForm},
  fJobSplit in 'GUI\Scheduler\fJobSplit.pas' {JobSplitForm},
  fPlanRange in 'GUI\Scheduler\fPlanRange.pas' {PlanRangeForm},
  PmJobParams in 'DataObjects\PmJobParams.pas',
  GlobalHistoryFrm in 'GUI\History\GlobalHistoryFrm.pas' {GlobalHistoryForm},
  PmProduction in 'DataObjects\PmProduction.pas',
  PmScriptExchange in 'PmScriptExchange.pas',
  fOrderRecycleBin in 'GUI\RecycleBin\fOrderRecycleBin.pas' {OrderRecycleBinFrame: TFrame},
  PmBaseRecycleBinView in 'GUI\RecycleBin\PmBaseRecycleBinView.pas',
  PmOrderRecycleBinView in 'GUI\RecycleBin\PmOrderRecycleBinView.pas',
  fContragentRecycleBin in 'GUI\RecycleBin\fContragentRecycleBin.pas' {ContragentRecycleBinFrame: TFrame},
  PmContragentRecycleBinView in 'GUI\RecycleBin\PmContragentRecycleBinView.pas',
  fPerson in 'GUI\Contragents\fPerson.pas' {PersonForm},
  PmHistory in 'DataObjects\PmHistory.pas',
  OrderHistoryFrm in 'GUI\History\OrderHistoryFrm.pas' {OrderHistoryForm},
  BaseExceptionHandler in '..\Common\BaseExceptionHandler.pas',
  PlanUtils in 'GUI\Scheduler\PlanUtils.pas',
  DBSettings in '..\Common\DBSettings.pas',
  RDBUtils in '..\Common\RDBUtils.pas',
  coursfrm in 'GUI\coursfrm.pas' {CourseForm},
  PmDictionaryList in 'DataObjects\PmDictionaryList.pas',
  StdDic in 'Config\StdDic.pas',
  PmProductionController in 'GUI\Scheduler\PmProductionController.pas',
  fProductionFrame in 'GUI\Scheduler\fProductionFrame.pas' {ProductionFrame: TFrame},
  PmTimeLine in 'GUI\Scheduler\PmTimeLine.pas',
  fProdFilter in 'GUI\Scheduler\fProdFilter.pas' {ProdFilterFrame},
  ContragentHistoryFrm in 'GUI\History\ContragentHistoryFrm.pas' {ContragentHistoryForm},
  MMYYList in '..\Common\MMYYList.pas',
  fEditOrderState in 'GUI\Scheduler\fEditOrderState.pas' {EditOrderStateForm},
  ConfigEditorTest in 'dunit\ConfigEditorTest.pas',
  PmOrder in 'DataObjects\PmOrder.pas',
  RAI2_MyDBGridEh in '..\Common\RAI2_MyDBGridEh.pas',
  fOrderNum in 'GUI\Scheduler\fOrderNum.pas' {OrderNumForm},
  fJobList in 'GUI\Scheduler\fJobList.pas' {JobListForm},
  fmRelated in 'GUI\Scheduler\fmRelated.pas' {RelatedProcessGridFrame: TFrame},
  fMatRequestFrame in 'GUI\Materials\fMatRequestFrame.pas' {MatRequestFrame: TFrame},
  CodeEdit in 'GUI\Config\CodeEdit.pas' {CodeEditForm},
  DicFrm in 'GUI\Config\DicFrm.pas' {DicEditForm},
  DicStFrm in 'GUI\Config\DicStFrm.pas' {StructForm},
  DiffControl in 'GUI\Config\DiffControl.pas',
  DiffUnit in 'GUI\Config\DiffUnit.pas',
  EGridFrm in 'GUI\Config\EGridFrm.pas' {EditProcessGridForm},
  EScrFrm in 'GUI\Config\EScrFrm.pas' {EditScriptForm},
  fCfgDiff in 'GUI\Config\fCfgDiff.pas' {CfgDiffForm},
  fDiff in 'GUI\Config\fDiff.pas',
  fDiffBase in 'GUI\Config\fDiffBase.pas' {DiffBaseForm},
  fmDimDic in 'GUI\Config\fmDimDic.pas' {frDimDic: TFrame},
  fmEmptyTabDic in 'GUI\Config\fmEmptyTabDic.pas' {frEmptyTabDic: TFrame},
  fmTabDic in 'GUI\Config\fmTabDic.pas' {frTabDic: TFrame},
  GridProp in 'GUI\Config\GridProp.pas' {GridPropForm},
  MDimFrm in 'GUI\Config\MDimFrm.pas' {MultiDimForm},
  NDicFrm in 'GUI\Config\NDicFrm.pas' {NewDicForm},
  NSrvFrm in 'GUI\Config\NSrvFrm.pas' {SrvPropForm},
  RepsFrm in 'GUI\Config\RepsFrm.pas' {ReportsForm},
  SrcDFrm in 'GUI\Config\SrcDFrm.pas' {SrcDimForm},
  PmDatabase in '..\Common\PmDatabase.pas',
  fCopyOrder in 'GUI\Orders\fCopyOrder.pas' {CopyOrderForm},
  PmQueryPager in '..\Common\PmQueryPager.pas',
  DataTest in 'dunit\DataTest.pas',
  PmDataChangeDetect in 'Utils\PmDataChangeDetect.pas',
  PmChangeObjectIds in 'DataObjects\PmChangeObjectIds.pas',
  PmScriptList in 'DataObjects\PmScriptList.pas',
  PmCustomerPaymentsView in 'GUI\Payments\PmCustomerPaymentsView.pas',
  PmCustomerPayments in 'DataObjects\PmCustomerPayments.pas',
  PmCustomersWithIncome in 'DataObjects\PmCustomersWithIncome.pas',
  JvInterpreter_Settings in 'Interpreter\JvInterpreter_Settings.pas',
  fCustomerIncome in 'GUI\Payments\fCustomerIncome.pas' {CustomerIncomeForm},
  fCustomerPayments in 'GUI\Payments\fCustomerPayments.pas' {CustomerPaymentsFrame: TFrame},
  fAddIncomesForm in 'GUI\Payments\fAddIncomesForm.pas',
  fBaseEditForm in 'GUI\fBaseEditForm.pas' {BaseEditForm},
  PmContragentPainterManager in 'GUI\Contragents\PmContragentPainterManager.pas',
  fPaymentsFilter in 'GUI\Payments\fPaymentsFilter.pas' {PaymentsFilterFrame: TFrame},
  fMoneyRequestForm in 'GUI\fMoneyRequestForm.pas' {MoneyRequestForm},
  JvInterpreter_Reports in 'Interpreter\JvInterpreter_Reports.pas',
  PmContragentMerge in 'DataHelpers\PmContragentMerge.pas',
  PmContragentMergeForm in 'GUI\Contragents\PmContragentMergeForm.pas' {ContragentMergeForm},
  PmConfigView in 'GUI\Config\PmConfigView.pas',
  PmConfigFrame in 'GUI\Config\PmConfigFrame.pas' {ConfigFrame: TFrame},
  PmConfigTree in 'Config\PmConfigTree.pas',
  PmConfigTreeView in 'GUI\Config\PmConfigTreeView.pas',
  PmConfigObjects in 'Config\PmConfigObjects.pas',
  PmConfigTreeEntity in 'Config\PmConfigTreeEntity.pas',
  PmConfigManager in 'Config\PmConfigManager.pas',
  PmOrderExchange in 'PmOrderExchange.pas',
  JvInterpreterInit in 'Interpreter\JvInterpreterInit.pas',
  AccessDM in 'DataAccess\AccessDM.pas' {adm},
  PmOrderParts in 'DataObjects\PmOrderParts.pas',
  PmStates in 'Config\PmStates.pas',
  PmScheduleGrid in 'GUI\Scheduler\PmScheduleGrid.pas',
  PmSQLScheduleAdapter in 'DataHelpers\PmSQLScheduleAdapter.pas',
  PmShiftEmployees in 'DataObjects\PmShiftEmployees.pas',
  PmGantt in 'GUI\Scheduler\PmGantt.pas' {GanttFrame: TFrame},
  PmRelatedContragentForm in 'GUI\Contragents\PmRelatedContragentForm.pas' {RelatedContragentForm},
  PmIncomingInvoice in 'DataObjects\PmIncomingInvoice.pas',
  PmIncomingInvoiceView in 'GUI\IncomingInvoices\PmIncomingInvoiceView.pas',
  PmInvoiceController in 'GUI\Invoices\PmInvoiceController.pas',
  PmInvoice in 'DataObjects\PmInvoice.pas',
  PmInvoiceItems in 'DataObjects\PmInvoiceItems.pas',
  fInvoiceFrame in 'GUI\Invoices\fInvoiceFrame.pas' {InvoicesFrame: TFrame},
  fInvoiceFilterFrame in 'GUI\Invoices\fInvoiceFilterFrame.pas' {InvoicesFilterFrame: TFrame},
  PmOrderInvoiceItems in 'DataObjects\PmOrderInvoiceItems.pas',
  PmInvoiceForm in 'GUI\Invoices\PmInvoiceForm.pas' {InvoiceForm},
  PmInvoiceItemForm in 'GUI\Invoices\PmInvoiceItemForm.pas' {InvoiceItemForm},
  PmCustomerOrders in 'DataObjects\PmCustomerOrders.pas',
  PmScriptManager in 'PmScriptManager.pas',
  fOrderInvPay in 'GUI\Orders\fOrderInvPay.pas' {OrderInvPayFrame},
  PmOrderPayments in 'DataObjects\PmOrderPayments.pas',
  PmWorkController in 'GUI\Orders\PmWorkController.pas',
  PmDraftController in 'GUI\Orders\PmDraftController.pas',
  PmEntityController in 'GUI\PmEntityController.pas',
  fAddress in 'GUI\Contragents\fAddress.pas' {AddressForm},
  PmMessenger in 'Utils\PmMessenger.pas',
  PmMessageDialog in 'GUI\PmMessageDialog.pas' {MessageDialog},
  PmCustomReportCommon in 'PmCustomReportCommon.pas',
  MkCalc in 'GUI\Orders\MkCalc.pas' {MakeCalcForm},
  MkOrder in 'GUI\Orders\MkOrder.pas' {MakeOrderForm},
  PmInvoiceExistForm in 'GUI\Invoices\PmInvoiceExistForm.pas' {InvoiceExistForm},
  JvInterpreter_Schedule in 'Interpreter\JvInterpreter_Schedule.pas',
  fOrderPayments in 'GUI\Payments\fOrderPayments.pas' {OrderPaymentsForm},
  fBaseToolbar in 'GUI\fBaseToolbar.pas' {BaseToolbarFrame: TFrame},
  fOrderListToolbar in 'GUI\Orders\fOrderListToolbar.pas' {OrderListToolbar: TFrame},
  fCommonToolbar in 'GUI\fCommonToolbar.pas' {CommonToolbarFrame: TFrame},
  fDraftListToolbar in 'GUI\Orders\fDraftListToolbar.pas' {DraftOrderListToolbar: TFrame},
  fWorkListToolbar in 'GUI\Orders\fWorkListToolbar.pas' {WorkOrderListToolbar: TFrame},
  fOrdersFrame in 'GUI\Orders\fOrdersFrame.pas' {OrdersFrame: TFrame},
  fDraftOrdersFrame in 'GUI\Orders\fDraftOrdersFrame.pas' {DraftOrdersFrame: TFrame},
  fWorkOrdersFrame in 'GUI\Orders\fWorkOrdersFrame.pas' {WorkOrdersFrame: TFrame},
  fDocFrame in 'GUI\fDocFrame.pas' {DocumentsFrame: TFrame},
  PmActions in 'GUI\PmActions.pas',
  fInvoicesToolbar in 'GUI\Invoices\fInvoicesToolbar.pas' {InvoicesToolbar: TFrame},
  fPaymentsToolbar in 'GUI\Payments\fPaymentsToolbar.pas' {PaymentsToolbar: TFrame},
  fProductionToolbar in 'GUI\Scheduler\fProductionToolbar.pas' {ProductionToolbar: TFrame},
  fScheduleToolbar in 'GUI\Scheduler\fScheduleToolbar.pas' {ScheduleToolbar: TFrame},
  PmOrderProcessItems in 'DataObjects\PmOrderProcessItems.pas',
  PmProcessCfg in 'PmProcessCfg.pas',
  fBaseRecycleBinToolbar in 'GUI\RecycleBin\fBaseRecycleBinToolbar.pas' {BaseRecycleBinToolbar: TFrame},
  fReportToolbar in 'GUI\CustomReports\fReportToolbar.pas' {ReportToolbarFrame: TFrame},
  fReportFrame in 'GUI\CustomReports\fReportFrame.pas' {ReportFrame: TFrame},
  PmReportController in 'GUI\CustomReports\PmReportController.pas',
  PmReportData in 'DataObjects\PmReportData.pas',
  fConfigToolbar in 'GUI\Config\fConfigToolbar.pas' {ConfigToolbarFrame: TFrame},
  PmDelayedOrdersForm in 'GUI\Orders\PmDelayedOrdersForm.pas' {DelayedOrdersForm},
  PmSelectInvoiceForm in 'GUI\Payments\PmSelectInvoiceForm.pas' {SelectInvoiceForm},
  PmSelectExtMatForm in 'GUI\Orders\PmSelectExtMatForm.pas' {SelectExternalDicForm},
  PmShipmentController in 'GUI\Shipping\PmShipmentController.pas',
  PmShipment in 'DataObjects\PmShipment.pas',
  fShipmentFrame in 'GUI\Shipping\fShipmentFrame.pas',
  fShipmentFilterFrame in 'GUI\Shipping\fShipmentFilterFrame.pas' {ShipmentFilterFrame: TFrame},
  fShipmentToolbar in 'GUI\Shipping\fShipmentToolbar.pas' {ShipmentToolbar: TFrame},
  PmShipmentForm in 'GUI\Shipping\PmShipmentForm.pas' {ShipmentForm},
  PmBaseConfigEditorFrame in 'GUI\Config\PmBaseConfigEditorFrame.pas' {BaseConfigEditorFrame: TFrame},
  PmConfigEditors in 'GUI\Config\PmConfigEditors.pas',
  PmDictionaryEditorFrame in 'GUI\Config\ConfigEditors\PmDictionaryEditorFrame.pas' {DictionaryEditorFrame: TFrame},
  PmProcessEditorFrame in 'GUI\Config\ConfigEditors\PmProcessEditorFrame.pas' {ProcessEditorFrame: TFrame},
  PmShipmentDocForm in 'GUI\Shipping\PmShipmentDocForm.pas' {ShipmentDocForm},
  PmShipmentDoc in 'DataObjects\PmShipmentDoc.pas',
  PmInvoiceDocController in 'GUI\Invoices\PmInvoiceDocController.pas',
  PmMatRequestForm in 'GUI\Orders\PmMatRequestForm.pas' {MaterialRequestEditForm},
  fMatRequestToolbar in 'GUI\Materials\fMatRequestToolbar.pas' {MatRequestToolbar: TFrame},
  fMatRequestFilterFrame in 'GUI\Materials\fMatRequestFilterFrame.pas' {MatRequestFilterFrame: TFrame},
  PmMaterialRequestController in 'GUI\Materials\PmMaterialRequestController.pas',
  PmMatRequest in 'DataObjects\PmMatRequest.pas',
  PmOrderAttachedFiles in 'DataObjects\PmOrderAttachedFiles.pas',
  fOrderNotesFrame in 'GUI\Orders\fOrderNotesFrame.pas' {OrderNotesFrame: TFrame},
  PmOrderNoteForm in 'GUI\Orders\PmOrderNoteForm.pas' {OrderNoteForm},
  PmOrderNotes in 'DataObjects\PmOrderNotes.pas',
  fEditJobComment in 'GUI\fEditJobComment.pas' {EditJobCommentForm},
  PmNotesPopupForm in 'GUI\Orders\PmNotesPopupForm.pas' {NotesPopupForm},
  PmSelectTemplate in 'GUI\Orders\PmSelectTemplate.pas' {SelectTemplateForm},
  PmSaleDocs in 'DataObjects\PmSaleDocs.pas',
  PmSaleItems in 'DataObjects\PmSaleItems.pas',
  PmSaleView in 'GUI\ShipmentInvoice\PmSaleView.pas',
  fSaleFrame in 'GUI\ShipmentInvoice\fSaleFrame.pas' {SaleFrame},
  fSaleToolbar in 'GUI\ShipmentInvoice\fSaleToolbar.pas' {SaleToolbar: TFrame},
  PmShipmentDocController in 'GUI\Shipping\PmShipmentDocController.pas',
  PmSaleDocController in 'GUI\ShipmentInvoice\PmSaleDocController.pas',
  PmSaleItemForm in 'GUI\ShipmentInvoice\PmSaleItemForm.pas',
  PmScheduleAdapter in 'DataHelpers\PmScheduleAdapter.pas',
  PmCachedScheduleAdapter in 'DataHelpers\PmCachedScheduleAdapter.pas',
  anycolor in '..\Common\anycolor.pas',
  fJobSplitShift in 'GUI\Scheduler\fJobSplitShift.pas' {JobSplitShiftForm},
  fJobOverlap in 'GUI\Scheduler\fJobOverlap.pas' {JobOverlapForm},
  PmDictionaryFolderEditorFrame in 'GUI\Config\ConfigEditors\PmDictionaryFolderEditorFrame.pas' {DictionaryFolderEditorFrame: TFrame},
  PmProcessCfgData in 'DataObjects\PmProcessCfgData.pas',
  PmProcessRootFrame in 'GUI\Config\ConfigEditors\PmProcessRootFrame.pas' {ProcessRootEditorFrame: TFrame},
  PmDictionaryRootEditorFrame in 'GUI\Config\ConfigEditors\PmDictionaryRootEditorFrame.pas' {DictionaryRootEditorFrame: TFrame},
  PmProcessGridEditorFrame in 'GUI\Config\ConfigEditors\PmProcessGridEditorFrame.pas' {ProcessGridEditorFrame: TFrame},
  CalcSettings in 'CalcSettings.pas',
  PmStock in 'DataObjects\PmStock.pas',
  PmStockMove in 'DataObjects\PmStockMove.pas',
  PmStockIncome in 'DataObjects\PmStockIncome.pas',
  PmStockWaste in 'DataObjects\PmStockWaste.pas',
  PmStockView in 'GUI\Stock\PmStockView.pas',
  fStockToolbar in 'GUI\Stock\fStockToolbar.pas' {StockToolbarFrame: TFrame},
  fStockFrame in 'GUI\Stock\fStockFrame.pas',
  PmStockMoveView in 'GUI\Stock\PmStockMoveView.pas',
  fStockMoveFrame in 'GUI\Stock\fStockMoveFrame.pas' {StockMoveFrame: TFrame},
  fStockMoveToolbar in 'GUI\Stock\fStockMoveToolbar.pas' {StockMoveToolbarFrame: TFrame},
  PmStockIncomeView in 'GUI\Stock\PmStockIncomeView.pas',
  fStockIncomeToolbar in 'GUI\Stock\fStockIncomeToolbar.pas' {StockIncomeToolbarFrame: TFrame},
  fStockIncomeFrame in 'GUI\Stock\fStockIncomeFrame.pas' {StockIncomeFrame: TFrame},
  PmStockWasteView in 'GUI\Stock\PmStockWasteView.pas',
  fStockWasteFrame in 'GUI\Stock\fStockWasteFrame.pas' {StockWasteFrame: TFrame},
  fStockWasteToolbar in 'GUI\Stock\fStockWasteToolbar.pas' {StockWasteToolbarFrame: TFrame},
  fStockMoveFilterFrame in 'GUI\Stock\fStockMoveFilterFrame.pas' {StockMoveFilterFrame: TFrame},
  PmStockIncomeItems in 'DataObjects\PmStockIncomeItems.pas',
  fStockIncomeFilterFrame in 'GUI\Stock\fStockIncomeFilterFrame.pas' {StockIncomeFilterFrame: TFrame},
  VistaHint in '..\Common\VistaHint.pas',
  PmDocument in 'DataObjects\PmDocument.pas',
  PmDocController in 'GUI\PmDocController.pas',
  PmDocumentView in 'GUI\PmDocumentView.pas',
  fDocumentToolbar in 'GUI\fDocumentToolbar.pas' {DocumentToolbar: TFrame},
  PmStockIncomeDocController in 'GUI\Stock\PmStockIncomeDocController.pas',
  PmDocEditForm in 'GUI\PmDocEditForm.pas' {DocEditForm},
  PmStockIncomeDocEditForm in 'GUI\Stock\PmStockIncomeDocEditForm.pas' {StockIncomeDocEditForm},
  PmDocItemEditForm in 'GUI\PmDocItemEditForm.pas' {DocItemEditForm},
  PmSaleDocForm in 'GUI\ShipmentInvoice\PmSaleDocForm.pas' {SaleDocForm},
  PmStockIncomeDocItemEditForm in 'GUI\Stock\PmStockIncomeDocItemEditForm.pas' {StockIncomeDocItemEditForm},
  PmAdvancedEdit in 'GUI\Scheduler\PmAdvancedEdit.pas' {JobAdvancedEditForm},
  PmLockManager in 'DataHelpers\PmLockManager.pas',
  PmScheduleDataChangeDetect in 'Utils\PmScheduleDataChangeDetect.pas',
  fStockWasteFilterFrame in 'GUI\Stock\fStockWasteFilterFrame.pas' {StockWasteFilterFrame: TFrame},
  PmStockWasteDocController in 'GUI\Stock\PmStockWasteDocController.pas',
  PmStockWasteDocEditForm in 'GUI\Stock\PmStockWasteDocEditForm.pas' {StockWasteDocEditForm},
  PmStockWasteDocItemEditForm in 'GUI\Stock\PmStockWasteDocItemEditForm.pas' {StockWasteDocItemEditForm},
  PmStockDocument in 'DataObjects\PmStockDocument.pas',
  PmStockDocumentItems in 'DataObjects\PmStockDocumentItems.pas',
  PmStockWasteItems in 'DataObjects\PmStockWasteItems.pas',
  PmContragentListForm in 'GUI\Contragents\PmContragentListForm.pas' {ContragentListForm},
  PmContragentForm in 'GUI\Contragents\PmContragentForm.pas' {ContragentForm},
  CostUkr in '..\Common\CostUkr.pas',
  ExcelRpt in 'C:\DPacks2007\OfficeReport\ExcelRpt.pas',
  OpenOfficeRpt in 'C:\DPacks2007\OfficeReport\OpenOfficeRpt.pas',
  BaseRpt in 'C:\DPacks2007\OfficeReport\BaseRpt.pas',
  fOrderFiles in 'GUI\Scheduler\fOrderFiles.pas' {OrderFilesForm},
  fOrderProductStorageFrom in 'GUI\Orders\fOrderProductStorageFrom.pas' {OrderProductStorageFrom},
  pmProductToStorage in 'GUI\Orders\pmProductToStorage.pas';

{$R *.RES}

var
  LogFileName: string;
begin
  //ReportMemoryLeaksOnShutdown := true;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  //LogFileName := AddPath('pp_order_log.cfg', TSettingsManager.Instance.ApplicationDataPath{ExtractFileDir(Application.ExeName),} );
  LogFileName := AddPath('pp_order_log.cfg', ExtractFileDir(Application.ExeName));
  TConfiguratorUnit.doPropertiesConfiguration(LogFileName);

  ExceptionHandler.Refresh;

  DecimalSeparator := ',';
  TextLang := langRus;    // Установить РУССКИЙ язык
  Application.Title := 'PolyMIX';
  LoadSuccess := false;
  repeat
    Splash := TSplash.Create(Application);
    try
      try
        FileUpdater.SplashEvent := SplashEvent;
        if not UserLogin then
        begin
          if (Splash.ModalResult = mrCancel) or (ParamCount >= 1) then
          begin
            Application.Terminate;
            Exit;
          end
        end
        else
        begin
          //FileUpdater.ADOConnection := Database.Connection;
          if Options.CheckEXEUpdate or Options.CheckXLSUpdate then
            if not FileUpdater.IsVersionOk then
            begin
              Application.Terminate;
              Exit;
            end;

          Splash.SetStatusMode;
          Splash.Show;
          Splash.Msg := 'Создание главной формы...';
          Splash.Update;
          delay(10);
          Application.CreateForm(TMForm, MForm);
  //Splash.Msg := 'Создание форм...';
          //Splash.Update;
          //delay(10);
          Splash.Msg := 'Загрузка конфигурации...';
          Splash.Update;
          delay(10);
          {$IFNDEF NoExpenses}
          InitExpenses(dm.cnCalc);
          {$ENDIF}
          // Некоторые параметры необходимо знать для формирования запросов (FullOrdStateMode)
          LoadOrdStateSettings;
          PmInit.InitDataAccess;
          TInterpreterInitializer.Init;
          TConfigManager.Instance.InitDictionaries;
          Splash.Msg := 'Создание форм...';
          Splash.Update;
          delay(10);

          {$IFNDEF NoNet}
          //Application.CreateForm(TOptCalcForm, OptCalcForm); // нельзя создавать динамически
          {$ENDIF}

          InitApplication;
        end;
      except on E: EHandlerException do ;
      end;
    finally
      Splash.Free;
    end;
  until LoadSuccess;  // повторяем попытку логина до победы
  //if not LoadSuccess then Application.Terminate;
  Application.Run;
end.
