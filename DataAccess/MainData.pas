unit Maindata;

{$I Calc.inc}

interface

uses
  Windows, SysUtils, Classes, Dialogs,
  Db, DataHlp, ADODB, Variants,
  Provider, DBClient,

  PmConnect, StdDic, PmDatabase, PmChangeLock, PmUpdate,
  PmMaterials, PmOperations, PmEntity, NotifyEvent;

type
  Tdm = class(TDataModule{, IRCDataModule})
    aqCalcOrder: TADOQuery;
    aqCalcOrderClientTotal: TBCDField;
    aqCalcOrderCloseDate: TDateTimeField;
    aqCalcOrderCloseTime: TDateTimeField;
    aqCalcOrderComment: TStringField;
    aqCalcOrderComment2: TStringField;
    aqCalcOrderCostOf1: TBCDField;
    aqCalcOrderCreationDate: TDateTimeField;
    aqCalcOrderCreationTime: TDateTimeField;
    aqCalcOrderCreatorName: TStringField;
    aqCalcOrderCustomer: TIntegerField;
    aqCalcOrderCustomerFax: TStringField;
    aqCalcOrderCustomerName: TStringField;
    aqCalcOrderCustomerPhone: TStringField;
    aqCalcOrderID: TStringField;
    aqCalcOrderID_char: TSmallintField;
    aqCalcOrderID_color: TSmallintField;
    aqCalcOrderID_date: TSmallintField;
    aqCalcOrderID_kind: TSmallintField;
    aqCalcOrderID_number: TIntegerField;
    aqCalcOrderID_Year: TIntegerField;
    aqCalcOrderIsProcessCostStored: TBooleanField;
    aqCalcOrderKindID: TIntegerField;
    aqCalcOrderModifierName: TStringField;
    aqCalcOrderModifyDate: TDateTimeField;
    aqCalcOrderModifyTime: TDateTimeField;
    aqCalcOrderN: TIntegerField;
    aqCalcOrderRowColor: TIntegerField;
    aqCalcOrderTirazz: TIntegerField;
    aqCalcOrderTotalCost: TBCDField;
    aqCalcOrderTotalGrn: TBCDField;
    aqDisplayInfo: TADOQuery;
    aqProcessItems: TADOQuery;
    aqProcessItemsContractor: TIntegerField;
    aqProcessItemsContractorCost: TBCDField;
    aqProcessItemsContractorPercent: TBCDField;
    aqProcessItemsContractorProcess: TBooleanField;
    aqProcessItemsCost: TBCDField;
    aqProcessItemsEnabled: TBooleanField;
    aqProcessItemsEnablePlanning: TBooleanField;
    aqProcessItemsEnableTracking: TBooleanField;
    aqProcessItemsEquipCode: TIntegerField;
    aqProcessItemsFactFinishDate: TDateTimeField;
    aqProcessItemsFactProductIn: TIntegerField;
    aqProcessItemsFactProductOut: TIntegerField;
    aqProcessItemsFactStartDate: TDateTimeField;
    aqProcessItemsHideItem: TBooleanField;
    aqProcessItemsIsItemInProfit: TBooleanField;
    aqProcessItemsIsPartName: TBooleanField;
    aqProcessItemsItemDesc: TStringField;
    aqProcessItemsItemID: TAutoIncField;
    aqProcessItemsItemProfit: TBCDField;
    aqProcessItemsLeft: TADOQuery;
    aqProcessItemsMatCost: TBCDField;
    aqProcessItemsMatPercent: TBCDField;
    aqProcessItemsMultiplier: TFloatField;
    aqProcessItemsOwnCost: TBCDField;
    aqProcessItemsOwnPercent: TBCDField;
    aqProcessItemsPart: TIntegerField;
    aqProcessItemsPermitDelete: TBooleanField;
    aqProcessItemsPermitFact: TBooleanField;
    aqProcessItemsPermitInsert: TBooleanField;
    aqProcessItemsPermitPlan: TBooleanField;
    aqProcessItemsPermitUpdate: TBooleanField;
    aqProcessItemsPlanFinishDate: TDateTimeField;
    aqProcessItemsPlanStartDate: TDateTimeField;
    aqProcessItemsProcessID: TIntegerField;
    aqProcessItemsProductIn: TIntegerField;
    aqProcessItemsProductOut: TIntegerField;
    aqProcessItemsUseInProfitMode: TIntegerField;
    aqProcessItemsUseInTotal: TBooleanField;
    aqUSD: TADOQuery;
    aqWorkOrder: TADOQuery;
    aqWorkOrderClientTotal: TBCDField;
    aqWorkOrderCloseDate: TDateTimeField;
    aqWorkOrderCloseTime: TDateTimeField;
    aqWorkOrderComment: TStringField;
    aqWorkOrderComment2: TStringField;
    aqWorkOrderCostOf1: TBCDField;
    aqWorkOrderCourse: TBCDField;
    aqWorkOrderCreationDate: TDateTimeField;
    aqWorkOrderCreationTime: TDateTimeField;
    aqWorkOrderCreatorName: TStringField;
    aqWorkOrderCustomer: TIntegerField;
    aqWorkOrderCustomerFax: TStringField;
    aqWorkOrderCustomerName: TStringField;
    aqWorkOrderCustomerPhone: TStringField;
    aqWorkOrderFactFinishDate: TDateTimeField;
    aqWorkOrderFactFinishTime: TDateTimeField;
    aqWorkOrderFinishDate: TDateTimeField;
    aqWorkOrderID: TStringField;
    aqWorkOrderID_char: TSmallintField;
    aqWorkOrderID_color: TSmallintField;
    aqWorkOrderID_date: TSmallintField;
    aqWorkOrderID_kind: TSmallintField;
    aqWorkOrderID_number: TIntegerField;
    aqWorkOrderID_Year: TIntegerField;
    aqWorkOrderIncludeAdv: TBooleanField;
    aqWorkOrderIsComposite: TBooleanField;
    aqWorkOrderIsProcessCostStored: TBooleanField;
    aqWorkOrderKindID: TIntegerField;
    aqWorkOrderModifierName: TStringField;
    aqWorkOrderModifyDate: TDateTimeField;
    aqWorkOrderModifyTime: TDateTimeField;
    aqWorkOrderN: TIntegerField;
    aqWorkOrderOrderState: TIntegerField;
    aqWorkOrderPayState: TIntegerField;
    aqWorkOrderPlanFinishTime: TDateTimeField;
    aqWorkOrderRowColor: TIntegerField;
    aqWorkOrderSourceCalcID: TIntegerField;
    aqWorkOrderStartDate: TDateTimeField;
    aqWorkOrderTirazz: TIntegerField;
    aqWorkOrderTotalCost: TBCDField;
    aqWorkOrderTotalGrn: TBCDField;
    aspChangeOrderStatus: TADOStoredProc;
    aspCopyOrder: TADOStoredProc;
    aspDelOrder: TADOStoredProc;
    aspGetCurDate: TADOStoredProc;
    aspGetLastCourse: TADOStoredProc;
    aspNewOrder: TADOStoredProc;
    aspNewOrderProcessItem: TADOStoredProc;
    aspSetNewCourse: TADOStoredProc;
    aspUpdateOrder: TADOStoredProc;
    cdDisplayInfo: TClientDataSet;
    cdDisplayInfoBkColor: TIntegerField;
    cdDisplayInfoDisplayInfoItemID: TAutoIncField;
    cdDisplayInfoFontBold: TBooleanField;
    cdDisplayInfoFontColor: TIntegerField;
    cdDisplayInfoItemFormat: TStringField;
    cdDisplayInfoItemLabel: TStringField;
    cdDisplayInfoItemType: TIntegerField;
    cdDisplayInfoItemWidth: TIntegerField;
    cdDisplayInfoLabelFontBold: TBooleanField;
    cdDisplayInfoLabelFontColor: TIntegerField;
    cdDisplayInfoLabelWidth: TIntegerField;
    cdDisplayInfoStartGroup: TBooleanField;
    cdDisplayInfoTransparent: TBooleanField;
    cnCalc: TADOConnection;
    dsDisplayInfo: TDataSource;
    pvCalcOrder: TDataSetProvider;
    pvDisplayInfo: TDataSetProvider;
    pvProcessItems: TDataSetProvider;
    pvProcessItemsLeft: TDataSetProvider;
    pvUSD: TDataSetProvider;
    pvWorkOrder: TDataSetProvider;
    aspENewOrder: TADOStoredProc;
    cdEntSettings: TClientDataSet;
    pvEntSettings: TDataSetProvider;
    aqEntSettings: TADOQuery;
    cdEntSettingsSettingID: TIntegerField;
    cdEntSettingsEditLock: TBooleanField;
    cdEntSettingsGetCourseOnStart: TBooleanField;
    cdEntSettingsPermitFilterOff: TBooleanField;
    cdEntSettingsBriefOrderID: TBooleanField;
    cdEntSettingsRoundTotalMode: TIntegerField;
    cdEntSettingsRoundUSD: TBooleanField;
    cdEntSettingsRoundPrecision: TIntegerField;
    cdEntSettingsPermitKindChange: TBooleanField;
    aqProcessItemsFactContractorCost: TBCDField;
    aqProcessItemsManualContractorCost: TBooleanField;
    cdEntSettingsNativeCurrency: TBooleanField;
    aqCalcOrderClientTotalGrn: TBCDField;
    aqCalcOrderCostOf1Grn: TBCDField;
    aqWorkOrderClientTotalGrn: TBCDField;
    aqWorkOrderCostOf1Grn: TBCDField;
    aqCalcOrderCostProtected: TBooleanField;
    aqCalcOrderContentProtected: TBooleanField;
    aqWorkOrderCostProtected: TBooleanField;
    aqWorkOrderContentProtected: TBooleanField;
    aqProcessItemsOldCost: TBCDField;
    cdEntSettingsRequireCustomer: TBooleanField;
    cdEntSettingsRequireBranch: TBooleanField;
    cdEntSettingsRequireActivity: TBooleanField;
    cdEntSettingsRequireProductType: TBooleanField;
    cdEntSettingsRequireFinishDate: TBooleanField;
    cdEntSettingsRequireInfoSource: TBooleanField;
    aqProcessItemsEstimatedDuration: TIntegerField;
    aqProcessItemsLinkedItemID: TIntegerField;
    aqProcessItemsSequenceOrder: TIntegerField;
    aqOrderRecycleBin: TADOQuery;
    pvOrderRecycleBin: TDataSetProvider;
    cdOrderRecycleBin: TClientDataSet;
    cdOrderRecycleBinN: TAutoIncField;
    cdOrderRecycleBinComment: TStringField;
    cdOrderRecycleBinCustomer: TIntegerField;
    cdOrderRecycleBinCustomerName: TStringField;
    cdOrderRecycleBinCreationDate: TDateTimeField;
    cdOrderRecycleBinID: TStringField;
    cdOrderRecycleBinUserName: TStringField;
    cdOrderRecycleBinIsDraft: TBooleanField;
    cdOrderRecycleBinRowColor: TIntegerField;
    cdOrderRecycleBinEntityName: TStringField;
    cdOrderRecycleBinDeleteDate: TDateTimeField;
    cdOrderRecycleBinID_Number: TIntegerField;
    cdOrderRecycleBinKindID: TIntegerField;
    aqProcessItemsEquipCount: TIntegerField;
    aqProcessItemsIsPaused: TBooleanField;
    aspUpdateOrderProcessItem: TADOStoredProc;
    aspNewSpecialJob: TADOStoredProc;
    aqProcessItemsIsPausedCount: TIntegerField;
    aspAddToGlobalHistory: TADOStoredProc;
    aqProcessItemsContractorPayDate: TDateTimeField;
    aspSetOrderOwner: TADOStoredProc;
    cdEntSettingsExecNewRecordAfterInsert: TBooleanField;
    cdEntSettingsAutoPayState: TBooleanField;
    aqWorkOrderAutoPayState: TIntegerField;
    aqContragentRecycleBin: TADOQuery;
    cdContragentRecycleBin: TClientDataSet;
    pvContragentRecycleBin: TDataSetProvider;
    cdContragentRecycleBinN: TIntegerField;
    cdContragentRecycleBinName: TStringField;
    cdContragentRecycleBinCreationDate: TDateTimeField;
    cdContragentRecycleBinDeleteDate: TDateTimeField;
    cdContragentRecycleBinUserName: TStringField;
    cdContragentRecycleBinContragentType: TIntegerField;
    cdContragentRecycleBinIsWork: TBooleanField;
    cdContragentRecycleBinContragentTypeName: TStringField;
    cdEntSettingsRequireFirmType: TBooleanField;
    pvGlobalHistory: TDataSetProvider;
    cdGlobalHistory: TClientDataSet;
    cdGlobalHistoryEventDate: TDateTimeField;
    cdGlobalHistoryEventText: TStringField;
    cdGlobalHistoryEventUser: TStringField;
    cdGlobalHistoryEventKind: TIntegerField;
    aqGlobalHistory: TADOQuery;
    aqGlobalHistoryEventDate: TDateTimeField;
    aqGlobalHistoryEventText: TStringField;
    aqGlobalHistoryEventUser: TStringField;
    aqGlobalHistoryEventKind: TIntegerField;
    pvOrderHistory: TDataSetProvider;
    cdOrderHistory: TClientDataSet;
    DateTimeField1: TDateTimeField;
    StringField1: TStringField;
    StringField2: TStringField;
    IntegerField1: TIntegerField;
    aqOrderHistory: TADOQuery;
    DateTimeField2: TDateTimeField;
    StringField3: TStringField;
    StringField4: TStringField;
    IntegerField2: TIntegerField;
    aqOrderHistoryEventID: TIntegerField;
    cdOrderHistoryEventID: TIntegerField;
    aqGlobalHistoryEventID: TIntegerField;
    cdGlobalHistoryEventID: TIntegerField;
    aqContragentHistory: TADOQuery;
    IntegerField3: TIntegerField;
    DateTimeField3: TDateTimeField;
    StringField5: TStringField;
    StringField6: TStringField;
    IntegerField4: TIntegerField;
    pvContragentHistory: TDataSetProvider;
    cdContragentHistory: TClientDataSet;
    IntegerField5: TIntegerField;
    DateTimeField4: TDateTimeField;
    StringField7: TStringField;
    StringField8: TStringField;
    IntegerField6: TIntegerField;
    aqWorkOrderFinalCostGrn: TBCDField;
    aqCalcOrderFinalCostGrn: TBCDField;
    cdEntSettingsShowAddPlanDialog: TBooleanField;
    cdEntSettingsNewPlanInterface: TBooleanField;
    cdEntSettingsVATPercent: TFloatField;
    cdEntSettingsCheckOverdueJobs: TBooleanField;
    cdEntSettingsRequireFullName: TBooleanField;
    cdEntSettingsShowSyncInfo: TBooleanField;
    aqWorkOrderStateChangeDate: TDateTimeField;
    cdEntSettingsPayStateMode: TIntegerField;
    aqWorkOrderHasInvoice: TBooleanField;
    aqWorkOrderTotalInvoiceCost: TBCDField;
    aqWorkOrderTotalPayCost: TBCDField;
    cdEntSettingsLockSyncData: TBooleanField;
    cdEntSettingsFactDateStrictOrder: TBooleanField;
    cdEntSettingsRequireFactProductOut: TBooleanField;
    aqProcessItemsSideCount: TIntegerField;
    aqWorkOrderTotalExpenseCost: TBCDField;
    aqCalcOrderTotalExpenseCost: TBCDField;
    aqWorkOrderProfitByGrn: TBooleanField;
    aqWorkOrderCostView: TBooleanField;
    aqCalcOrderCostView: TBooleanField;
    aqCalcOrderProfitByGrn: TBooleanField;
    aqWorkOrderShipmentState: TIntegerField;
    aqWorkOrderIsLockedByUser: TBooleanField;
    cdEntSettingsShipmentApprovement: TBooleanField;
    aqWorkOrderShipmentApproved: TBooleanField;
    aqWorkOrderPrePayPercent: TFloatField;
    aqWorkOrderPreShipPercent: TFloatField;
    aqWorkOrderPayDelay: TIntegerField;
    aqCalcOrderPrePayPercent: TFloatField;
    aqCalcOrderPreShipPercent: TFloatField;
    aqCalcOrderPayDelay: TIntegerField;
    aqCalcOrderIsLockedByUser: TBooleanField;
    aqWorkOrderMatRequestModified: TBooleanField;
    cdEntSettingsFileStoragePath: TStringField;
    aqCalcOrderCallCustomer: TBooleanField;
    aqCalcOrderCallCustomerPhone: TStringField;
    aqCalcOrderHaveLayout: TBooleanField;
    aqCalcOrderHavePattern: TBooleanField;
    aqCalcOrderSignManager: TBooleanField;
    aqCalcOrderSignProof: TBooleanField;
    aqCalcOrderProductFormat: TStringField;
    aqCalcOrderProductPages: TIntegerField;
    aqCalcOrderIncludeCover: TBooleanField;
    aqWorkOrderCallCustomer: TBooleanField;
    aqWorkOrderCallCustomerPhone: TStringField;
    aqWorkOrderHaveLayout: TBooleanField;
    aqWorkOrderHavePattern: TBooleanField;
    aqWorkOrderSignManager: TBooleanField;
    aqWorkOrderSignProof: TBooleanField;
    aqWorkOrderProductFormat: TStringField;
    aqWorkOrderProductPages: TIntegerField;
    aqWorkOrderIncludeCover: TBooleanField;
    aqCalcOrderHasNotes: TBooleanField;
    aqWorkOrderHasNotes: TBooleanField;
    aqCalcOrderIsComposite: TBooleanField;
    cdEntSettingsJobColorByExecState: TBooleanField;
    cdEntSettingsPlanShowExecState: TBooleanField;
    cdEntSettingsPlanShowOrderState: TBooleanField;
    aqCalcOrderHaveProof: TBooleanField;
    aqWorkOrderHaveProof: TBooleanField;
    aqProcessItemsPlanDuration: TIntegerField;
    aqProcessItemsFactDuration: TIntegerField;
    cdEntSettingsShowExpenseCost: TBooleanField;
    cdEntSettingsAllowCostProtect: TBooleanField;
    cdEntSettingsRedScheduleSpace: TBooleanField;
    cdEntSettingsSplitJobs: TBooleanField;
    cdEntSettingsInvoiceAllPayments: TBooleanField;
    cdEntSettingsShowPartialInvoice: TBooleanField;
    cdEntSettingsShowContragentFullName: TBooleanField;
    cdEntSettingsAllContractors: TBooleanField;
    cdEntSettingsSyncProducts: TBooleanField;
    cdEntSettingsNewInvoicePayState: TBooleanField;
    cdEntSettingsShowInvoicePayerFilter: TBooleanField;
    cdEntSettingsShowInvoiceCustomerFilter: TBooleanField;
    aqWorkOrderOrderMaterialsApproved: TBooleanField;
    cdEntSettingsOrderMaterialsApprovement: TBooleanField;
    aqWorkOrderIsPayDelayInBankDays: TBooleanField;
    aqCalcOrderIsPayDelayInBankDays: TBooleanField;
    aqCalcOrderProfitPercent: TFloatField;
    aqWorkOrderProfitPercent: TFloatField;
    aqWorkOrderExternalId: TStringField;
    cdEntSettingsShowExternalId: TBooleanField;
    procedure aqOrderRecordChangeComplete(DataSet: TCustomADODataSet;
      const Reason: TEventReason; const RecordCount: Integer;
      const Error: Error; var EventStatus: TEventStatus);
    procedure cdOrderFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure cnCalcAfterConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure pvWorkOrderGetTableName(Sender: TObject; DataSet: TDataSet;
      var TableName: WideString);
  private
    //function CalcPricesCode(DataSet: TDataSet; FieldName: string): integer;
  public
    procedure AddEventToHistory(EventKind: integer; EventText: string;
      EventValue: variant);
    procedure AddLogoffEvent;
    procedure AddLogonEvent;
    function GetCurrentServerDate: TDateTime;
    function GetLastCourse: extended;  // Получение курса с сервера
    //procedure OpenDataSet(DataSet: TDataSet);
    function SetSrvCourse(NewCourse: extended): boolean;  // Установка нового курса на сервере
    procedure SetupSrvDatasets;
    procedure ShowProcErrorMessage(ErrCode: integer);
    function GetProcErrorMessage(ErrCode: integer): string;
  end;

var
  dm: Tdm;

const
  // виды записей в глобальной истории
  GlobalHistory_Debug = 0;
  GlobalHistory_Info = 1;
  GlobalHistory_Warn = 2;
  GlobalHistory_Error = 3;
  GlobalHistory_Fail = 4;

  NoClient = false; // Означает что GUI работает напрямую с ADODataSet для заказов,
                    // начиная с 2.3.7 при true нормально работать не будет

implementation

uses TLoggerUnit, RDialogs, ADOUtils, RDBUtils,
  CalcUtils, ExHandler, PmContragent
{$IFNDEF NoExpenses}
  , ExpData, ExpnsFrm
{$ENDIF}
{$IFNDEF NoDocs}
  , DocDM
{$ENDIF}
;
{$R *.DFM}

procedure Tdm.aqOrderRecordChangeComplete(DataSet: TCustomADODataSet;
  const Reason: TEventReason; const RecordCount: Integer;
  const Error: Error; var EventStatus: TEventStatus);
begin
  //if (Reason = erUpdate) or (Reason = erFirstChange) then MForm.UpdateModified;
  // 21.07.2008 - тк. не используется aqOrder
end;

// Это осталось от старого редактора цен - в ElemData есть такая де функция GetDicCode
// (или не такая же?) Используется при разбивке заказа
{function TDM.CalcPricesCode(DataSet: TDataSet; FieldName: string): integer;
var k: integer;
begin
  Result := 0;
  if not DataSet.Active then Exit;
  DataSet.CheckBrowseMode;
  if DataSet.IsEmpty then begin Result := 1; Exit; end;
  DataSet.DisableControls;
  try
    DataSet.First;
    k := 0;
    while not DataSet.EOF do begin
      try if k < DataSet[FieldName] then k := DataSet[FieldName]; except end;
      DataSet.Next;
    end;
  finally
    DataSet.EnableControls;
  end;
  Result := k + 1;
end;}

procedure Tdm.cdOrderFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept := false;//MFFilter.OrderApplyFilter(Dataset);
end;

procedure Tdm.cnCalcAfterConnect(Sender: TObject);
begin
  Database.SetConnectionOptions(cnCalc);
  FileUpdater.ADOConnection := Database.Connection;
  if FileUpdater.IsVersionOk then // проверка обновлений
  begin
    ConnectNotifier.Notify(cnCalc);   // только тогда генерируется событие
    ConnectNotifier.UnregisterAll;    // только при первом соединении
  end;
end;

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  // Глобальная ссылка на соединение
  Database.Connection := dm.cnCalc;
  //MainDataSets[qiCalc] := aqCalcOrder;
  //MainDataSets[qiWork] := aqWorkOrder;
  //dsCust.DataSet := Customers.DataSet;
  //dsContractor.DataSet := Contractors.DataSet;
  //dsSupplier.DataSet := Suppliers.DataSet;
{$IFNDEF NoExpenses}
{  MainDataSets[qiComExp] := ExpDM.aqComExp;
  MainDataSets[qiOwnExp] := ExpDM.aqOwnExp;
  ClientMainDataSets[qiComExp] := ExpDM.cdComExp;
  ClientMainDataSets[qiOwnExp] := ExpDM.cdOwnExp;}
{$ENDIF}
  {(cdProcessItems.FieldByName('PlanStartDate') as TDateTimeField).DisplayFormat := ShortDateFormat;
  (cdProcessItems.FieldByName('PlanFinishDate') as TDateTimeField).DisplayFormat := ShortDateFormat;
  (cdProcessItems.FieldByName('FactStartDate') as TDateTimeField).DisplayFormat := ShortDateFormat;
  (cdProcessItems.FieldByName('FactFinishDate') as TDateTimeField).DisplayFormat := ShortDateFormat;
  (cdProcessItems.FieldByName('PlanStartTime') as TDateTimeField).DisplayFormat := ShortTimeFormat;
  (cdProcessItems.FieldByName('PlanFinishTime') as TDateTimeField).DisplayFormat := ShortTimeFormat;
  (cdProcessItems.FieldByName('FactStartTime') as TDateTimeField).DisplayFormat := ShortTimeFormat;
  (cdProcessItems.FieldByName('FactFinishTime') as TDateTimeField).DisplayFormat := ShortTimeFormat;}
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
end;

// Если эта штука будет на APPSERVER, то можно просто возвращать Now,
// а сейчас лезем через SQL.
function Tdm.GetCurrentServerDate: TDateTime;
begin
  aspGetCurDate.ExecProc;
  Result := aspGetCurDate.Parameters.ParamByName('@CurDate').Value;
end;

(*procedure Tdm.cdOrderPayDetCalcFields(DataSet: TDataSet);
begin
{$IFNDEF NoFinance}
  try
    if DataSet['PayKind'] = 2 then begin
      if VarIsNull(DataSet['PayAccount']) then
        DataSet['PayKindName'] := 'б/н'//MForm.PayKindItem1.Caption;
      else
        DataSet['PayKindName'] := 'б/н счет ' + IntToStr(DataSet['PayAccount']);
      DataSet['MoneyName'] := 'грн'
    end else begin
      DataSet['PayKindName'] := 'нал'; //MForm.PayKindItem2.Caption;
      DataSet['MoneyName'] := '$';
    end;
  except DataSet['PayKindName'] := ''; DataSet['MoneyName'] := '' end;
{$ENDIF}
end;*)

function Tdm.GetLastCourse: extended;  // Получение курса с сервера
begin
  aspGetLastCourse.ExecProc;
  Result := aspGetLastCourse.Parameters.ParamByName('@Val').Value;
end;

procedure Tdm.AddEventToHistory(EventKind: integer; EventText: string;
    EventValue: variant);
begin
  try
    aspAddToGlobalHistory.Parameters.ParamByName('@EventKind').Value := EventKind;
    aspAddToGlobalHistory.Parameters.ParamByName('@EventText').Value := EventText;
    aspAddToGlobalHistory.Parameters.ParamByName('@EventValue').Value := EventValue;
    aspAddToGlobalHistory.ExecProc;
  except on E: Exception do
    TLogger.getInstance.Error('Ошибка записи события (тип ' + IntToStr(EventKind) + ') '
      + EventText + ', ' + E.Message);
  end;
end;

procedure Tdm.AddLogoffEvent;
begin
  // игнорируем проблемы
  try
    AddEventToHistory(GlobalHistory_Info, 'Выход из PolyMix:Заказы', null);
  except
  end;
end;

procedure Tdm.AddLogonEvent;
begin
  AddEventToHistory(GlobalHistory_Info, 'Вход в PolyMix:Заказы', null);
end;

procedure Tdm.pvWorkOrderGetTableName(Sender: TObject; DataSet: TDataSet;
  var TableName: WideString);
begin
  TableName := 'WorkOrder';
end;

{function TDm.GetOrderIDText(dq: TDataSet): string;
var
  s1, s2, s3, s4, s5: string[7];
begin
  if FullOrderID then begin
    try s1 := int2str(dq['ID_date'], 3); except s1 := '###'; end;
    try s2 := inttostr(dq['ID_kind']); except s2 := '#'; end;
    try s3 := inttostr(dq['ID_char']); except s3 := '#'; end;
    try s4 := inttostr(dq['ID_color']); except s4 := '#'; end;
  end;
  try s5 := int2str(dq['ID_Number'], 5);
    except on EVariantError do s5 := '#####'; end;
  if FullOrderID then
    Result := s1 + '-' + s2 + s3 + s4 + '-' + s5
  else
    Result := s5;
end;}

function Tdm.SetSrvCourse(NewCourse: extended): boolean;
begin
  Result := false;
  {$IFNDEF Demo}
  dm.aspSetNewCourse.Parameters.ParamByName('@New').Value := NewCourse;
  if not dm.cnCalc.InTransaction then dm.cnCalc.BeginTrans;
  try
    dm.aspSetNewCourse.ExecProc;
    dm.cnCalc.CommitTrans;
    Result := true;
  except
    on E: Exception do begin
      dm.cnCalc.RollbackTrans;
      ExceptionHandler.Raise_(E);
      Exit;
    end;
  end;
{$ENDIF}
end;

// Назначение наборам данных обработчиков из DM - не используется
procedure Tdm.SetupSrvDatasets;
begin
  {try cdPrint.FieldByName('Seller').OnChange := cdPrintSellerChange; except end;
  cdPrint.FieldByName('SellerName').OnGetText := cdPrintSellerNameGetText;}
//  cdPrint.OnCalcFields := cdPrintCalcFields;
  //try cdPrint.FieldByName('KG').OnGetText := cdPrintKGGetText; except end;
  {try cdOrderPay.FieldByName('Cost').OnChange := cdOrderPayCostChange; except end;
  try cdOrderPayDet.FieldByName('Cost').OnChange := cdOrderPayCostChange; except end;
  try cdOrderPayDet.FieldByName('PayKind').OnChange := cdOrderPayCostChange; except end;
  cdOrderPay.OnCalcFields := cdOrderPayCalcFields;
  cdOrderPayDet.OnCalcFields := cdOrderPayDetCalcFields;}
end;

function Tdm.GetProcErrorMessage(ErrCode: integer): string;
var s: string;
begin
  if ErrCode = 0 then s := 'В демонстрационной версии системы сохранение заказа отключено'
  else if ErrCode = -1 then s := 'Заказ был удален другим пользователем'
  else if ErrCode = -2 then s := 'Заказ редактируется другим пользователем'
  else if ErrCode = -3 then s := 'Ошибка при выполнении процедуры'
  else if ErrCode = -100 then s := 'Не указаны права пользователя. Заказ не сохранен.' +
    #13'Обратитесь к администратору системы.'
  else if ErrCode = -101 then s := 'Не указана дата исполнения заказа.'#13'Заказ не сохранен.'
  else if ErrCode = -102 then s := 'Некорректная дата исполнения заказа.'#13'Заказ не сохранен.'
  else if ErrCode = -103 then s := 'Нет права на выполнение операции.'
  else if ErrCode = -104 then s := 'Нельзя удалить защищенный заказ.'
  else if ErrCode = -105 then s := 'Нельзя удалить заказ, для которого выставлен счет.'
  else if ErrCode = -106 then s := 'Нельзя удалить заказ, для которого есть отгрузки.'
  else s := 'Неизвестная ошибка (' + IntToStr(ErrCode) + '). Операция не выполнена.'#13'Обратитесь к разработчику';
  Result := s;
end;

procedure Tdm.ShowProcErrorMessage(ErrCode: integer);
begin
  RusMessageDlg(GetProcErrorMessage(ErrCode), mtError, [mbOk], 0);
end;

end.

