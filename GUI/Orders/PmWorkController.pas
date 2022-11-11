unit PmWorkController;

interface

uses SysUtils, Classes, Controls, Forms, Dialogs, RDialogs, JvSpeedbar,
  DBClient, CalcUtils,

  PmOrderController, fOrderInvPay, PmProviders, fOrdersFrame, PmEntity,
  fWorkListToolbar, fBaseToolbar, fOrderListToolbar, PmOrder, MainFilter,
  fBaseFrame, pmOrderInvoiceItems, PmOrderPayments, PmShipment, PmShipmentDoc,
  PmCustomerOrders, pmProductToStorage;

type
  TWorkController = class(TOrderController)
  private
    OldIncludeAdv: boolean;
    FToolbarFrame: TOrderListToolbar;
    FDelayedOrders: TWorkOrder;
    FDelayedFilterObj: TOrderFilterObj;
    //FOrderInvPayFrame: TOrderInvPayFrame;
    function GetInvoiceID: variant;
    function GetInvoiceItemID: variant;
  protected
    FOrderInvoiceItems: TOrderInvoiceItems;
    FOrderPayments: TOrderPayments;
    FOrderShipment: TShipment;
    FOrderShipmentCriteria: TShipmentFilterObj;
    FMaterialsCopy: TClientDataSet;
    FProductStorage : TProductStorageController;
    procedure EditInvoice(Sender: TObject);
    procedure PayInvoice(Sender: TObject);
    procedure DoEditShipmentDoc(DocID: integer);
    procedure SelectExternalMaterial(Sender: TObject);
    procedure CancelMaterialRequest(Sender: TObject);
    procedure EditMaterialRequest(Sender: TObject);
    procedure DoBeforeEditEntityProperties; override;
    procedure DoBeforeUpdateOrder; override;
    function GetCostVisible: boolean; override;
    procedure AfterOpenProcessItems; override;
    procedure OpenInvoicesPayments;
    procedure OpenShipment;
    function GetFrameClass: TOrdersFrameClass; override;
    //property OrderInvPayFrame: TOrderInvPayFrame read FOrderInvPayFrame write FOrderInvPayFrame;
    procedure UpdateActionState; override;
    function DoAfterUpdateOrder: boolean; override;
    procedure BeforeCloseProcessItems; override;
    // Отображает список просроченных заказов, если активирована настройка для пользовтеля
    procedure CheckDelayedOrders;
    procedure DoEditDelayedOrderProps(Sender: TObject);
    procedure CopyMaterialItems;
    procedure CheckRequestsModified(Msgs: TCollection);
    procedure GetCheckMessages(Msgs: TCollection); override;
    function ShowCheckResults(ShowCancel: boolean; Msgs: TCollection): boolean; override;
    procedure BulkEdit(SelectedRows: TIntArray); override;
  public
    constructor Create(_Entity: TEntity);
    destructor Destroy; override;
    function Visible: boolean; override;
    function MakeDraft(ParamsProvider: IMakeDraftParamsProvider; var NewId: integer): boolean;
    function CreateFrame(Owner: TComponent): TBaseFrame; override;
    // определяет, является ли заказ срочным
    //function IsUrgentOrder(UrgentHours: integer): boolean;
    function GetToolbar: TjvSpeedbar; override;
    procedure Activate; override;
    procedure RefreshData; override;
    procedure AddShipment(Sender: TObject);
    procedure EditShipment(Sender: TObject);
    procedure DeleteShipment(Sender: TObject);
    procedure ApproveShipment(Sender: TObject);
    procedure ApproveOrderMaterials(Sender: TObject);
    procedure MakeInvoice(Sender: TObject);
    function OpenOrderDetails: boolean; override;
    procedure UpdateUSDCourse; override;

    procedure AddToStorage(Sender: TObject);
    procedure DeleteFromStorage(Sender: TObject);

    property OrderShipment: TShipment read FOrderShipment;
    property InvoiceID: variant read GetInvoiceID;
    property InvoiceItemID: variant read GetInvoiceItemID;
    property OrderInvoiceItems: TOrderInvoiceItems read FOrderInvoiceItems;
    property OrderPayments: TOrderPayments read FOrderPayments;

  end;

implementation

uses Variants, DB, DateUtils, TLoggerUnit,

  ExHandler, CalcSettings, PmDatabase, RDBUtils, PmAccessManager, ADOReClc,
  MainData, ServMod, StdDic, PmProcess, ChkOrd,
  fWorkOrdersFrame, fEditOrderState,
  PmActions, PmDelayedOrdersForm, OrdProp, PmShipmentForm, PmShipmentDocForm,
  PmShipmentController, PmShipmentDocController, PmMaterials, PmSelectExtMatForm,
  PmInvoiceDocController, PmMatRequestForm, PmEntSettings, PmConfigManager;

constructor TWorkController.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);

  FOrderInvoiceItems := TOrderInvoiceItems.Create;
  FOrderPayments := TOrderPayments.Create;
  FOrderShipment := TShipment.Create;
  FOrderShipmentCriteria := TShipmentFilterObj.Create;
  FOrderShipment.DetailMode := ShipmentDetailMode_Simple;
  FOrderShipment.Criteria := FOrderShipmentCriteria;
  FOrderShipment.UseWaitCursor := false;
//  FProductStorage := TProductStorageController.Create(NvlInteger(Order.KeyValue));

  //TMainActions.GetAction(TOrderActions.MakeWork).OnExecute := acMakeDraftExecute;
  TMainActions.GetAction(TOrderActions.EditInvoice).OnExecute := EditInvoice;
  TMainActions.GetAction(TOrderActions.MakeInvoice).OnExecute := MakeInvoice;
end;

destructor TWorkController.Destroy;
begin
  FreeAndNil(FOrderPayments);
  FreeAndNil(FOrderInvoiceItems);
  FreeAndNil(FOrderShipment);
  FreeAndNil(FOrderShipmentCriteria);
  FreeAndNil(FMaterialsCopy);

  FDelayedOrders.Free;
  FDelayedFilterObj.Free;
  inherited;
end;

function TWorkController.Visible: boolean;
begin
  Result := AccessManager.CurUser.WorkVisible;
end;

procedure TWorkController.DoBeforeEditEntityProperties;
begin
  // на самом деле это вроде не используется
  OldIncludeAdv := NvlBoolean(FEntity.DataSet['IncludeAdv']);
end;

procedure TWorkController.DoBeforeUpdateOrder;
var
  ReOrderID: integer;
  ReOrderCode: string;
  ReKind: TChangeKind;
  NewTotalGrn: extended;
  NewIncludeAdv: boolean;
begin
  // Для заказов - Обрабатываем зависимые документы...
  ReOrderID := Order.NewOrderKey;
  ReOrderCode := FEntity.DataSet['ID'];
  ReKind := chSumChanged;
  NewTotalGrn := Order.Processes.GrandTotalGrn;
  NewIncludeAdv := FEntity.DataSet['IncludeAdv'];
end;

function TWorkController.GetCostVisible: boolean;
begin
  Result := not VarIsNull(Order.KindID) and IntInArray(Order.KindID, AllWorkCostViewKindValues);
end;

// Создание нового расчета из заказа. Возвращает ключ нового заказа
function TWorkController.MakeDraft(ParamsProvider: IMakeDraftParamsProvider; var NewId: integer): boolean;
var
  Res: integer;
  Applied: boolean;
begin
  Result := false;
  ParamsProvider.CreateForm;
  if not Order.Active or Order.IsEmpty then Exit;
  Applied := false;
  repeat
    Res := ParamsProvider.Execute;
    if Res = mrOk then
    begin
      dm.aspChangeOrderStatus.Parameters.ParamByName('@Src').Value := Order.KeyValue;
      dm.aspChangeOrderStatus.Parameters.ParamByName('@RowColor').Value := ParamsProvider.RowColor;
      // берем параметры из CalcOrder, потом изменения будут отменены
      dm.aspChangeOrderStatus.Parameters.ParamByName('@ID_Kind').Value := Order.DataSet['ID_Kind'];
      dm.aspChangeOrderStatus.Parameters.ParamByName('@ID_Char').Value := Order.DataSet['ID_Char'];
      dm.aspChangeOrderStatus.Parameters.ParamByName('@ID_Color').Value := Order.DataSet['ID_Color'];
      dm.aspChangeOrderStatus.Parameters.ParamByName('@IncludeAdv').Value := Order.DataSet['IncludeAdv'];
      dm.aspChangeOrderStatus.Parameters.ParamByName('@Course').Value := Order.Processes.USDCourse;
      dm.aspChangeOrderStatus.Parameters.ParamByName('@TotalGrn').Value := Order.DataSet['TotalGrn'];
      dm.aspChangeOrderStatus.Parameters.ParamByName('@Lock').Value := 1;
      dm.aspChangeOrderStatus.Parameters.ParamByName('@MakeCopy').Value := ParamsProvider.CopyToDraft;
      if not Database.InTransaction then Database.BeginTrans;
      try
        dm.aspChangeOrderStatus.ExecProc;
        NewId := dm.aspChangeOrderStatus.Parameters[0].Value;    // destination key
        if NewId < 0 then
        begin
          Database.RollbackTrans;
          dm.ShowProcErrorMessage(NewId);       // Не получилось
          Exit;
        end
        else
        begin
          Database.CommitTrans;
          Applied := true;
          Result := true;
        end;
      except
        on E: EDatabaseError do
        begin
          Database.RollbackTrans;
          ExceptionHandler.Raise_(E);
          Exit;
        end;
        on EConvertError do
        begin
          Database.RollbackTrans;
          RusMessageDlg('Неправильно введены данные', mtError, [mbOk], 0);
          Exit;
        end;
      end;
    end;
  until Applied or (Res = mrCancel);
end;

procedure TWorkController.CopyMaterialItems;
begin
  FreeAndNil(FMaterialsCopy);
  FMaterialsCopy := Order.OrderItems.Materials.CopyData(true);
end;

// Если Msgs = nil, то помечаем как измененные, иначе добавляем сообщение
procedure TWorkController.CheckRequestsModified(Msgs: TCollection);
var
  Mat: TMaterials;
  MatAmount, MatCost: extended;
  MatUnitName, MatTypeName, MatDesc, Param1, Param2, Param3: string;
  NewMsg: TCheckMsg;
begin
  Mat := Order.OrderItems.Materials;
  FMaterialsCopy.First;
  while not FMaterialsCopy.eof do
  begin
    if Mat.Locate(FMaterialsCopy[TMaterials.F_Key]) then
    begin
      if Mat.HasFactInfoCurrent and
        ((NvlFloat(FMaterialsCopy[TMaterials.F_MatAmount]) <> Mat.MatAmount)
        or (NvlString(FMaterialsCopy[TMaterials.F_MatUnitName]) <> Mat.MatUnitName)
        or (NvlString(FMaterialsCopy[TMaterials.F_MatTypeName]) <> Mat.MatTypeName)
        or (NvlString(FMaterialsCopy[TMaterials.F_MatDesc]) <> Mat.MatDesc)
        or ((Abs(NvlFloat(FMaterialsCopy[TMaterials.F_MatCost]) - Mat.MatCost) >= 0.01)   // изменилась стоимость и она меньше фактической
          and (NvlFloat(FMaterialsCopy[TMaterials.F_MatCost]) < NvlFloat(Mat.FactMatCost)))) then
      begin
        if Msgs <> nil then
        begin
          NewMsg := TmpMsgs.Add as TCheckMsg;
          NewMsg.SrvName := '';//sm.ServiceByID(ProcessID);
          if (NvlString(FMaterialsCopy[TMaterials.F_MatDesc]) <> Mat.MatDesc)
              or (NvlString(FMaterialsCopy[TMaterials.F_MatUnitName]) <> Mat.MatUnitName)
              or (NvlString(FMaterialsCopy[TMaterials.F_MatTypeName]) <> Mat.MatTypeName) then
            NewMsg.Msg := 'Изменились параметры материала с отметками снабжения: '
              + NvlString(FMaterialsCopy[TMaterials.F_MatDesc]) + ' -> ' + Mat.MatDesc
          else
          if NvlFloat(FMaterialsCopy[TMaterials.F_MatAmount]) <> Mat.MatAmount then
            NewMsg.Msg := 'Изменилось количество материала с отметками снабжения: '
              + VarToStr(FMaterialsCopy[TMaterials.F_MatAmount]) + ' -> ' + VarToStr(Mat.MatAmount)
          else
          if (Abs(NvlFloat(FMaterialsCopy[TMaterials.F_MatCost]) - Mat.MatCost) >= 0.01)   // изменилась стоимость и она меньше фактической
             and (NvlFloat(FMaterialsCopy[TMaterials.F_MatCost]) < NvlFloat(Mat.FactMatCost)) then
            NewMsg.Msg := 'Изменилась стоимость материала с отметками снабжения: '
              + VarToStr(FMaterialsCopy[TMaterials.F_MatCost]) + ' -> ' + VarToStr(Mat.MatCost);
          NewMsg.MsgType := mtWarning;
        end
        else
        begin
          // сохраняем параметры
          MatCost := Mat.MatCost;
          MatAmount := Mat.MatAmount;
          MatUnitName := Mat.MatUnitName;
          MatTypeName := Mat.MatTypeName;
          MatDesc := Mat.MatDesc;
          Param1 := Mat.Param1;
          Param2 := Mat.Param2;
          Param3 := Mat.Param3;
          // запись помечаем как измененную
          Mat.RequestModified := true;
          // возвращаем старое количество и параметры
          Mat.MatAmount := NvlFloat(FMaterialsCopy[TMaterials.F_MatAmount]);
          Mat.MatDesc := NvlString(FMaterialsCopy[TMaterials.F_MatDesc]);
          Mat.Param1 := NvlString(FMaterialsCopy[TMaterials.F_Param1]);
          Mat.Param2 := NvlString(FMaterialsCopy[TMaterials.F_Param2]);
          Mat.Param3 := NvlString(FMaterialsCopy[TMaterials.F_Param3]);
          Mat.MatUnitName := NvlString(FMaterialsCopy[TMaterials.F_MatUnitName]);
          Mat.MatTypeName := NvlString(FMaterialsCopy[TMaterials.F_MatTypeName]);
          //Mat.MatCost := NvlFloat(FMaterialsCopy[TMaterials.F_MatCost]);  чтобы не суммировалось

          // добавляем новый расходный материал с новыми параметрами
          {Mat.DataSet.Append;
          Mat.ItemID := FMaterialsCopy[PmProcess.F_ItemID];
          Mat.MatAmount := MatAmount;
          Mat.MatUnitName := MatUnitName;
          Mat.MatTypeName := MatTypeName;
          Mat.MatDesc := MatDesc;
          Mat.Param1 := MatParam1;
          Mat.Param2 := MatParam2;
          Mat.Param3 := MatParam3;
          Mat.MatCost := MatCost;
          Mat.DataSet.Post;}

          // добавляем новый расходный материал с новыми параметрами и стоимостью
          Mat.SetMaterialEx(Mat.ItemID, MatTypeName, MatDesc, Param1, Param2, Param3,
            MatAmount, MatUnitName, MatCost, false, nil);
        end;
      end;
    end;
    FMaterialsCopy.Next;
  end;
end;

function TWorkController.OpenOrderDetails: boolean;
begin
  Result := inherited OpenOrderDetails;
  //if Result then
  //  OpenInvoicesPayments;
end;

procedure TWorkController.AfterOpenProcessItems;
begin
  inherited;
  if not FReadOnly and (ViewMode = vmRight) then
    CopyMaterialItems;   // создаем копию записей о материалах
  try
    OpenInvoicesPayments;
  except on E: Exception do
    begin
      MessageDlg('Не удалось открыть данные о счетах или оплатах', mtError, [mbOk], 0);
      ExceptionHandler.Log_(E.Message);
    end;
  end;
  try
    OpenShipment;
  except on E: Exception do
    begin
      MessageDlg('Не удалось открыть данные об отгрузках', mtError, [mbOk], 0);
      ExceptionHandler.Log_(E.Message);
    end;
  end;
end;

procedure TWorkController.OpenInvoicesPayments;
var
  cr: TOrderPaymentsCriteria;
  crii: TOrderInvoiceItemsCriteria;
begin
  if AccessManager.CurUser.ViewInvoices
    and AccessManager.CurUser.ViewPayments then
  begin
    crii := TOrderInvoiceItemsCriteria.Default;
    crii.OrderID := NvlInteger(Order.KeyValue);
    crii.Mode := TOrderInvoiceItemsCriteria.Mode_Normal;
    FOrderInvoiceItems.Criteria := crii;
    //FOrderInvPayFrame.OrderInvoiceItems.OrderID := Order.KeyValue;
    FOrderInvoiceItems.Reload;
    cr.OrderID := NvlInteger(Order.KeyValue);
    cr.Mode := TOrderPaymentsCriteria.Mode_Normal;
    FOrderPayments.Criteria := cr;
    FOrderPayments.Reload;
  end;
end;

procedure TWorkController.OpenShipment;
begin
  if AccessManager.CurUser.ViewShipment then
  begin
    FOrderShipment.Criteria.OrderID := NvlInteger(Order.KeyValue);
    FOrderShipment.Reload;
  end;
end;

function TWorkController.GetInvoiceID: variant;
begin
  Result := FOrderInvoiceItems.InvoiceID;
end;

function TWorkController.GetInvoiceItemID: variant;
begin
  Result := FOrderInvoiceItems.KeyValue;
end;

function TWorkController.GetFrameClass: TOrdersFrameClass;
begin
  Result := TWorkOrdersFrame;
end;

function TWorkController.GetToolbar: TjvSpeedbar;
begin
  if FToolbarFrame = nil then
    FToolbarFrame := TWorkOrderListToolbar.Create(nil);
  Result := FToolbarFrame.Toolbar;
end;

procedure TWorkController.Activate;
begin
  inherited;
  CheckDelayedOrders;
end;

procedure TWorkController.UpdateActionState;
var
  acen: boolean;
begin
  inherited;
  TMainActions.GetAction(TOrderActions.MakeWork).Enabled := false;
  TMainActions.GetAction(TOrderActions.MakeInvoice).Enabled := AccessManager.CurUser.AddInvoices
    and not Entity.IsEmpty;
  TMainActions.GetAction(TOrderActions.EditInvoice).Enabled := AccessManager.CurUser.AddInvoices
    and not Entity.IsEmpty;
  TMainActions.GetAction(TOrderActions.PayInvoice).Enabled := AccessManager.CurUser.ViewInvoices
      and AccessManager.CurUser.AddPayments and not Entity.IsEmpty;
// 07.03.2021    and AccessManager.CurUser.EditPayments and not Entity.IsEmpty;
  TMainActions.GetAction(TOrderActions.MakeDraft).Enabled := AccessManager.CurUser.DraftVisible
    and (ViewMode = vmLeft);
  {if FToolbarFrame <> nil then
  begin
    acen := TMainActions.GetAction(TOrderActions.Save).Enabled;
    FToolbarFrame.siSaveOrder.Enabled := acen;
  end;}
end;

procedure TWorkController.UpdateUSDCourse;
begin
  // тут вообще-то непонятно
  if (FFrame <> nil) and (ViewMode = vmRight) then
    Order.Processes.USDCourse := Order.USDCourse //TSettingsManager.Instance.NewOrderCourse;
  else
    Order.Processes.USDCourse := TSettingsManager.Instance.AppCourse;
end;

procedure TWorkController.BeforeCloseProcessItems;
begin
  inherited;
  // Должен быть корректный курс, иначе стоимость материалов в нац. валюте не посчитается
  Order.Processes.USDCourse := Order.USDCourse;
end;

// Отображает список просроченных заказов, если активирована настройка для пользовтеля
procedure TWorkController.CheckDelayedOrders;
begin
  if Order.Active and AccessManager.CurUser.ShowDelayedOrders then
  begin
    if FDelayedOrders = nil then
    begin
      FDelayedOrders := TWorkOrder.Create(dm.aqWorkOrder);
      FDelayedFilterObj := TOrderFilterObj.Create;
      FDelayedFilterObj.ShowDelayed := true;
      FDelayedFilterObj.cbDateTypeIndex := FDelayedOrders.FinishDateIndex;
      FDelayedOrders.Criteria := FDelayedFilterObj;
      FDelayedOrders.SetSortOrder(FDelayedOrders.GetOrderPrefix + FDelayedOrders.KeyField, false);
    end;
    FDelayedOrders.Reload;
    if not FDelayedOrders.IsEmpty then
      ExecDelayedOrdersForm(FDelayedOrders, DoEditDelayedOrderProps);
    FDelayedOrders.Close;
  end;
end;

procedure TWorkController.DoEditDelayedOrderProps(Sender: TObject);
begin
  EditOrderProps(FDelayedOrders, TOrderFormParamsProvider.Create);
end;

procedure TWorkController.RefreshData;
begin
  inherited;
  CheckDelayedOrders;
end;

function TWorkController.DoAfterUpdateOrder: boolean;
var Success: boolean;
begin
  Success := inherited DoAfterUpdateOrder;
  // отгрузки
  if Success and AccessManager.CurUser.AddShipment and AccessManager.CurUser.ViewShipment then
    Result := FOrderShipment.ApplyUpdates
  else
    Result := Success;
end;

function TWorkController.CreateFrame(Owner: TComponent): TBaseFrame;
begin
  Result := inherited CreateFrame(Owner);

  TWorkOrdersFrame(FFrame).OrderInvoiceItems := FOrderInvoiceItems;
  TWorkOrdersFrame(FFrame).OrderPayments := FOrderPayments;
  TWorkOrdersFrame(FFrame).OrderShipment := FOrderShipment;
  TWorkOrdersFrame(FFrame).OrderItemsFrame.CreateOrderInvPayFrame;

  TWorkOrdersFrame(FFrame).OnEditInvoice := EditInvoice;
  TWorkOrdersFrame(FFrame).OnMakeInvoice := MakeInvoice;
  TWorkOrdersFrame(FFrame).OnPayInvoice := PayInvoice;
  TWorkOrdersFrame(FFrame).OnAddShipment := AddShipment;
  TWorkOrdersFrame(FFrame).OnEditShipment := EditShipment;
  TWorkOrdersFrame(FFrame).OnDeleteShipment := DeleteShipment;
  TWorkOrdersFrame(FFrame).OnApproveShipment := ApproveShipment;
  TWorkOrdersFrame(FFrame).OnApproveOrderMaterials := ApproveOrderMaterials;
  TWorkOrdersFrame(FFrame).OnSelectExternalMaterial := SelectExternalMaterial;
  TWorkOrdersFrame(FFrame).OnCancelMaterialRequest := CancelMaterialRequest;
  TWorkOrdersFrame(FFrame).OnEditMaterialRequest := EditMaterialRequest;
  TWorkOrdersFrame(FFrame).OnAddToStorage := AddToStorage;
  TWorkOrdersFrame(FFrame).OnDeleteFromStorage := DeleteFromStorage;

end;

procedure TWorkController.MakeInvoice(Sender: TObject);
begin
  //TMainActions.GetAction(TOrderActions.MakeInvoice).Execute;
  if not IsNewOrder then
  begin
    if TInvoiceDocController.MakeInvoice(Order.CustomerID, Order.KeyValue) then
    begin
      if ViewMode = vmLeft then
      begin
        Order.SavePagePosition := true;
        try
          Order.Reload;
        finally
          Order.SavePagePosition := false;
        end;
      end
      else
        FOrderInvoiceItems.Reload;
    end;
  end;
end;

procedure TWorkController.EditInvoice(Sender: TObject);
begin
  //TMainActions.GetAction(TOrderActions.EditInvoice).Execute;
  if not FOrderInvoiceItems.IsEmpty then
    if TInvoiceDocController.EditInvoice(FOrderInvoiceItems.InvoiceID) then
      FOrderInvoiceItems.Reload;
end;

procedure TWorkController.PayInvoice(Sender: TObject);
begin
  TMainActions.GetAction(TOrderActions.PayInvoice).Execute;
end;

procedure TWorkController.AddToStorage(Sender: TObject);
begin
   FProductStorage.AppendRecord;
end;

procedure TWorkController.DeleteFromStorage(Sender: TObject);
begin
   FProductStorage.DeleteRecord;
end;

procedure TWorkController.AddShipment(Sender: TObject);
{var
  TotalShipped: integer;}
begin
  DoEditShipmentDoc(0);
    {TotalShipped := AppendShipment(FOrderShipment);
    if ExecEditShipmentDocForm(FOrderShipment, nil, TotalShipped, Order.Tirazz) then
    begin
      if ViewMode = vmLeft then
      begin
        FOrderShipment.ApplyUpdates;
        Order.Reload;
      end;
    end else
      FOrderShipment.DataSet.Cancel;}
  {end
  else
    RusMessageDlg('Заказ уже полностью отгружен', mtInformation, [mbOk], 0);}
end;

procedure TWorkController.EditShipment(Sender: TObject);
begin
  if not FOrderShipment.IsEmpty then
  begin
    DoEditShipmentDoc(FOrderShipment.ShipmentDocID);
  end;
end;

procedure TWorkController.DoEditShipmentDoc(DocID: integer);
var
  Cnt: TShipmentDocController;
  ShipID: integer;
begin
  Cnt := TShipmentDocController.Create;
  try
    Cnt.OrderTotalNumberShipped := FOrderShipment.TotalNumberShipped;
    Cnt.OrderID := Order.KeyValue;
    Cnt.OrderTirazz := Order.Tirazz;
    Cnt.OrderNumber := Order.OrderNumber;
    Cnt.OrderComment := Order.Comment;
    Cnt.CustomerID := Order.CustomerID;
    if Cnt.EditShipmentDoc(DocID) then
    begin
      FOrderShipment.Reload;
      if ViewMode = vmLeft then
      begin
        // Чтобы остаться на той же странице
        Order.SavePagePosition := true;
        try
          Order.Reload;
        finally
          Order.SavePagePosition := false;
        end;
        OpenOrderItems;  // сразу обновляем детали
      end;
      FOrderShipment.DataSet.Last;
    end;
  finally
    Cnt.Free;
  end;
end;

procedure TWorkController.DeleteShipment(Sender: TObject);
begin
  if not FOrderShipment.IsEmpty
    and (RusMessageDlg('Вы действительно хотите удалить запись об отгрузке?',
    mtConfirmation, mbYesNoCancel, 0) = mrYes) then
  begin
    FOrderShipment.Delete;
    if ViewMode = vmLeft then
    begin
      FOrderShipment.ApplyUpdates;
      // Чтобы остаться на той же странице
      Order.SavePagePosition := true;
      try
        Order.Reload;
      finally
        Order.SavePagePosition := false;
      end;
      OpenOrderItems;  // сразу обновляем детали
    end;
  end;
end;

procedure TWorkController.ApproveShipment(Sender: TObject);
begin
  if not IsNewOrder then
  begin
    (Order as TWorkOrder).ToggleApproveShipment;
    if ViewMode = vmLeft then
    begin
      // Чтобы остаться на той же странице
      Order.SavePagePosition := true;
      try
        Order.Reload;
      finally
        Order.SavePagePosition := false;
      end;
    end;
  end;
end;

procedure TWorkController.ApproveOrderMaterials(Sender: TObject);
begin
  if not IsNewOrder then
  begin
    (Order as TWorkOrder).ToggleApproveOrderMaterials;
    if ViewMode = vmLeft then
    begin
      // Чтобы остаться на той же странице
      Order.SavePagePosition := true;
      try
        Order.Reload;
      finally
        Order.SavePagePosition := false;
      end;
    end;
  end;
end;

procedure TWorkController.SelectExternalMaterial(Sender: TObject);
var
  ExtMatID: variant;
  MatData: TMaterials;
begin
  MatData := Order.OrderItems.Materials;
  if not MatData.IsEmpty then
  begin
    ExtMatID := MatData.ExternalMatID;
    if ExecSelectExternalDictionaryForm(ExtMatID, TConfigManager.Instance.StandardDics.deExternalMaterials, '') then
      MatData.ExternalMatID := ExtMatID;
    // Применяем изменения в режиме "превью"
    if ViewMode = vmLeft then
      MatData.ApplyUpdates;
  end;
end;

procedure TWorkController.CancelMaterialRequest(Sender: TObject);
var
  MatData: TMaterials;
  MatID: integer;
  AllowDelete: boolean;
begin
  MatData := Order.OrderItems.Materials;
  if not MatData.IsEmpty and MatData.RequestModified then
  begin
    if ViewMode = vmLeft then
    begin
      MatID := MatData.KeyValue;
      // Проверяем были ли изменения в базе
      Order.CheckActualState;
      // проверяем на случай если заказ перезагрузился
      AllowDelete := MatData.Locate(MatID) and not MatData.IsEmpty and MatData.RequestModified;
    end else
      AllowDelete := true;
    if AllowDelete then
    begin
      MatData.Delete;
      // Применяем изменения в режиме "превью"
      if ViewMode = vmLeft then
        MatData.ApplyUpdates;
    end;
  end;
end;

procedure TWorkController.EditMaterialRequest(Sender: TObject);
var
  MatData: TMaterials;
  MatID: integer;
  AllowEdit, _ReadOnly, _FactReadOnly, NeedLock: boolean;
  LockerName: string;
  LockerInfo: TUserInfo;
begin
  if Order.IsEmpty then Exit;

  MatData := Order.OrderItems.Materials;
  if not MatData.IsEmpty then
  begin
    if ViewMode = vmLeft then
    begin
      MatID := MatData.KeyValue;
      // Проверяем были ли изменения в базе
      Order.CheckActualState;
      // проверяем на случай если заказ перезагрузился
      AllowEdit := MatData.Locate(MatID) and not MatData.IsEmpty;
    end else
      AllowEdit := true;

    if AllowEdit then
    begin
      Order.ReadKindPermissions(false);

      _ReadOnly := not AccessManager.CurKindPerm.EditMaterialRequest;
      // Если не разрешена закупка, то фактические параметры и дата закупки только для чтения
      _FactReadOnly := EntSettings.OrderMaterialsApprovement and not (Order as TWorkOrder).OrderMaterialsApproved;
      NeedLock := EntSettings.EditLock and not _ReadOnly and (ViewMode = vmLeft);
      if NeedLock then
      begin
        // Проверяем наличие блокировки
        if TOrder.IsLockedByAnother(LockerName, Order.KeyValue) then
        begin
          LockerInfo := AccessManager.UserInfo(LockerName);
          if LockerInfo <> nil then
            LockerName := LockerInfo.Name;
          RusMessageDlg(Order.NameSingular + ' редактируется пользователем '
            + QuotedStr(LockerName) + #13 +
            'Вы не сможете сможете сохранить изменения.', mtInformation, [mbok], 0);
          _ReadOnly := true;
        end;
      end;

      if not _ReadOnly and NeedLock then
        CheckAndLockOrder;  // устанавливаем блокировку
      // отключаем автообновление
      OrderInfoTimer.Enabled := false;
      try
        if ExecMaterialRequestForm(MatData, _ReadOnly, _FactReadOnly,
          AccessManager.CurKindPerm.CostView, AccessManager.CurKindPerm.FactCostView) then
        begin
          // Применяем изменения в режиме "превью"
          if not _ReadOnly and (ViewMode = vmLeft) then
            MatData.ApplyUpdates;
        end
        else
          MatData.DataSet.Cancel;
      finally
        if not _ReadOnly and NeedLock then
          UnlockOrder(Order.KeyValue);   // снимаем блокировку
      end;
    end;
  end;
end;

procedure TWorkController.GetCheckMessages(Msgs: TCollection);
begin
  inherited GetCheckMessages(Msgs);
  // Сначала проверяем, какие материалы изменились
  CheckRequestsModified(Msgs);
end;

function TWorkController.ShowCheckResults(ShowCancel: boolean; Msgs: TCollection): boolean;
begin
  Result := inherited ShowCheckResults(ShowCancel, Msgs);
  if Result and (Msgs.Count > 0) then
    // помечаем как измененные
    CheckRequestsModified(nil);
end;

procedure TWorkController.BulkEdit(SelectedRows: TIntArray);
var
  i, NewOrderState: integer;
begin
  NewOrderState := ExecEditOrderStateForm(0, '');
  if NewOrderState > 0 then
  begin
    for i := 0 to High(SelectedRows) - 1 do
      Database.ExecuteNonQuery('exec up_ChangeOrderState ' + IntToStr(SelectedRows[i])
        + ', ' + IntToStr(NewOrderState));
    RefreshData;
  end;
end;

end.
