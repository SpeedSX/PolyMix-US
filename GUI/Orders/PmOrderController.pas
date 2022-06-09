unit PmOrderController;

interface

uses Classes, DB, ADODB, Variants, Forms, ExtCtrls, ShellAPI, Windows,

  JvFormPlacement, JvAppStorage,

  PmEntity, PmOrder, PmProviders, CalcUtils, ServMod, MainFilter, NotifyEvent,
  ExHandler, CalcSettings, fBaseFrame,
  PmEntityController, fOrdersFrame, PmReportData;

{$I calc.inc}

type
  TOrderEditMode = (stNone, stNew, stEdit);

  TOrderController = class(TEntityController)
  private
    FMasterGrid: TOrderGridClass;
    FOnRightToLeft: TNotifyEvent;
    //FOnEnterOrder: TNotifyEvent;
    //FViewMode: TOrderViewMode;
    FState: TOrderEditMode;
    InstantOpenProcessItems: boolean; // ������, ���������� ��������
    FPrevOrderKind: integer;
    FPrevOrderPermitUpdate: boolean;
    //FPrevOrderIsDraft: boolean;
    FAllNotifIgnore: boolean;
    FBeforeCfgID: TNotifyHandlerID;
    WasActive: boolean;
    AfterScrollID, BeforeScrollID, AfterOpenID: TNotifyHandlerID;
    FEditLockTimer: TTimer;

    function GetOrder: TOrder;
    procedure OrderAfterScroll(Sender: TObject);
    {procedure NotifyCreation;
    procedure NotifyModification;}
    procedure StartFramesToRight;
    procedure FinishFramesToRight;
    function GetViewMode: TOrderViewMode;
    procedure SetViewMode(Value: TOrderViewMode);
    procedure ClientCostChanged(Sender: TObject);
    procedure GrandTotalChanged(Sender: TObject);
    procedure GrnGrandTotalChanged(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure DoEditLockTimer(Sender: TObject);
  protected
    FLastExportDir: string;
    ProcessingOrder: boolean; // ���������� ������������ �������-������
    OrdWaitRefresh: integer;   // ������� �������� �������� ��������-�������
    FAutoClose: boolean;

    class var
      AllWorkCostViewKindValues, AllDraftCostViewKindValues,
      AllProfitPreviewKindValues, AllProfitInsideKindValues,
      AllModifyProfitKindValues: TIntArray;

    procedure DoBeforeUpdateOrder; virtual;
    function DoAfterUpdateOrder: boolean; virtual; // ����� ����������� ��������� ������
    // ������� ��� ����������
    function DoDeleteOrder(Confirm: boolean): boolean;
    function GetProfitPreviewVisible: boolean;
    function GetProfitInsideVisible: boolean;
    function GetModifyProfit: boolean;
    procedure AfterOpenProcessItems; virtual;
    procedure BeforeCloseProcessItems; virtual;
    function GetFrameClass: TOrdersFrameClass; virtual; abstract;
    procedure EditOrderProps(OrderEntity: TOrder; ParamsProvider: IOrderParamsProvider);
    procedure EnterOrder(Sender: TObject);
    function Modified: boolean; virtual;
    procedure OrderBeforeScroll(Sender: TObject);
    procedure OrderAfterOpen(Sender: TObject);
    procedure RefreshOrderItems;
    function GetCostVisible: boolean; virtual; abstract;
    procedure UpdateOrderInfoPanel;
    procedure DoOnUnProtectContent(Sender: TObject);
    procedure DoOnUnProtectCost(Sender: TObject);
    procedure DoOnProtectContent(Sender: TObject);
    procedure DoOnProtectCost(Sender: TObject);
    procedure ContentPageActivated(Sender: TObject);
    procedure acOrderPropsExecute(Sender: TObject);
    procedure SetAllNotifIgnore(val: boolean);
    property AllNotifIgnore: boolean read FAllNotifIgnore write SetAllNotifIgnore;
    procedure RightToLeft;
    procedure LeftToRight;
    function LoadCurrent: boolean;
    procedure UpdateModified(Sender: TObject);
    function MainModified: boolean;
    procedure BeforeProcessCfgChange_Handler(Sender: TObject);
    procedure OrderInfoTimerTimer(Sender: TObject);
    function OrderInfoTimer: TTimer;
    procedure UpdateRepMenuEnabled;
    function AskForSave: boolean;
    procedure acDeleteOrderExecute(Sender: TObject);
    procedure acNewOrderExecute(Sender: TObject);
    procedure acCopyOrderExecute(Sender: TObject);
    procedure acExportExecute(Sender: TObject);
    procedure DoPrintOrderReport(ReportKey: integer);
    procedure acSetPricesExecute(Sender: TObject);
    procedure acHistoryExecute(Sender: TObject);
    procedure acImportBatchExecute(Sender: TObject);
    procedure FilterChange;
    procedure OpenOrderItems;
    procedure UpdateActionState; virtual;
    procedure CheckAndLockOrder;  // ������ ���������� ������
    procedure UnlockOrder(OrderID: integer);   // ����� ���������� ������
    procedure DoOnOpenAttachedFile(Sender: TObject);
    procedure DoOnRemoveAttachedFile(Sender: TObject);
    procedure DoOnAddAttachedFile(Sender: TObject);
    procedure DoOnAddNote(Sender: TObject);
    procedure DoOnEditNote(OrderNoteID: integer);
    procedure DoOnDeleteNote(OrderNoteID: integer);
    procedure DoOnSelectTemplate(Sender: TObject);
    procedure EditNote;
    procedure SetProviderEvents(ParamsProvider: IOrderParamsProvider);
    procedure DoOnNoteClick(Sender: TObject);
    function CanEditNote: boolean;
    procedure SettingsChanged; override;
    procedure GetCheckMessages(Msgs: TCollection); virtual;
    function ShowCheckResults(ShowCancel: boolean; Msgs: TCollection): boolean; virtual;
    procedure BulkEdit(SelectedRows: TIntArray); virtual;
    class function GetAttachedFilePath(Order: TOrder; FileName: string): string;
  public
    constructor Create(_Entity: TEntity); override;
    destructor Destroy; override;
    procedure EditCurrent; overload;
    procedure EditCurrent(Sender: TObject); overload;
    procedure EditEntityProperties(OrderEntity: TOrder; ParamsProvider: IOrderParamsProvider); virtual;
    procedure CancelCurrent(Sender: TObject);
    procedure AskCancelCurrent(Sender: TObject);
    function SaveCurrent: boolean; virtual;
    function SaveAndClose: boolean; virtual;
    function CheckOrder(ShowCancel: boolean): boolean;
    // ������� ��� ����������
    procedure DeleteCurrent(Confirm: boolean);
    function CreateFrame(Owner: TComponent): TBaseFrame; override;
    procedure SaveSettings; override;
    procedure LoadSettings; override;
    // ��������� ��������� � ������ �������
    procedure LogMessage(Msg: string; Value: variant);
    procedure ExportData; virtual;
    procedure ImportData; override;
    procedure Activate; override;
    // ���������, ����� �� ������������� ������� ��������
    function CanClose: boolean; override;
    procedure RefreshData; override;
    procedure PrintReport(ReportKey: integer; AllowInside: boolean); override;
    procedure PrintDefaultOrderReport;
    function BuildCustomReport(ReportKey: integer): TReportData;
    function OpenOrderDetails: boolean; virtual;
    // ���������� true ���� ��������� ����� ����� (State = stNew)
    function IsNewOrder: boolean;
    // true ���� ����� �������������� ������
    function InsideOrder: boolean;
    // ��������� ����� (������� �� ������ ���������� ���������-��������������)
    procedure CloseOrder; virtual;
    function CopyOrder(ParamsProvider: ICopyParamsProvider): boolean; virtual;
    function Description: string; override;
    procedure NewOrder(ParamsProvider: IOrderParamsProvider);
    procedure DisableProcessControls;
    procedure EnableProcessControls;
    procedure SetSingleOrderFilter(OrderID: integer);  // ������������� ������ �� ������������ �����
    procedure ResetSingleOrderFilter;   // ���������� ������ ������������� ������
    procedure UpdateUSDCourse; virtual; abstract;

    //property MasterGrid: TOrderGridClass read FMasterGrid write FMasterGrid;

    // �������� ��������� ��� ������� ������ ��������!
    //property OnEnterOrder: TNotifyEvent read FOnEnterOrder write FOnEnterOrder;
    property OnRightToLeft: TNotifyEvent read FOnRightToLeft write FOnRightToLeft;

    property Order: TOrder read GetOrder;
    property ViewMode: TOrderViewMode read GetViewMode write SetViewMode;
    property State: TOrderEditMode read FState write FState;
    // ��������, ��� ����������� ���� ������� ����� ���������� ��������������
    property AutoClose: boolean read FAutoClose write FAutoClose;

    class procedure UpdateKindLists;
    class procedure OpenAttachedFile(Order: TOrder);
  end;

implementation

uses Controls, SysUtils, FileCtrl, JvJclUtils, TLoggerUnit, DateUtils, 

  RVCLUtils, PmAccessManager, RDialogs, Dialogs, PmEntSettings, MainData,
  PmScriptManager, ChkOrd, RDBUtils, ADOReClc, PmOrderExchange,
  PmDatabase, PmAppController, OrdProp, fCopyOrder, PmCustomReportBuilder,
  PmActions, PmProcess, ServData, fViewImport, PmConfigManager, RAI2_CalcSrv,
  PmOrderNoteForm, PmNotesPopupForm, PmSelectTemplate;

{$REGION 'TOrderView'}

constructor TOrderController.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  FFilter := TOrderFilterObj.Create;
  Order.Criteria := FFilter as TOrderFilterObj;
  FFilter.RestoreFilter(TSettingsManager.Instance.Storage, iniFilter + FEntity.InternalName);

  FCaption := Order.NamePlural;
  FState := stNone;

  Order.Processes.OnUpdateModified := UpdateModified;
  Order.OrderItems.OnUpdateModified := UpdateModified;
  Order.Processes.OnGrnGrandTotalChanged := GrnGrandTotalChanged;
  Order.Processes.OnGrandTotalChanged := GrandTotalChanged;
  Order.Processes.OnClientCostChanged := ClientCostChanged;

  FBeforeCfgID := TConfigManager.Instance.BeforeProcessCfgChange.RegisterHandler(BeforeProcessCfgChange_Handler);

  AfterScrollID := Entity.AfterScrollNotifier.RegisterHandler(OrderAfterScroll);
  BeforeScrollID := Entity.BeforeScrollNotifier.RegisterHandler(OrderBeforeScroll);
  AfterOpenID := Entity.OpenNotifier.RegisterHandler(OrderAfterOpen);

  FEditLockTimer := TTimer.Create(nil);
  FEditLockTimer.Enabled := false;
  FEditLockTimer.Interval := EntSettings.EditLockConfirmInterval * 1000;
  FEditLockTimer.OnTimer := DoEditLockTimer;

  UpdateUSDCourse;
end;

destructor TOrderController.Destroy;
begin
  FreeAndNil(FFilter);
  FreeAndNil(FEditLockTimer);

  TConfigManager.Instance.BeforeProcessCfgChange.UnregisterHandler(FBeforeCfgID);
  Entity.AfterScrollNotifier.UnRegisterHandler(AfterScrollID);
  Entity.BeforeScrollNotifier.UnRegisterHandler(BeforeScrollID);
  Entity.OpenNotifier.UnRegisterHandler(AfterOpenID);

  inherited;
end;

procedure TOrderController.acOrderPropsExecute(Sender: TObject);
begin
  if not Entity.IsEmpty then
    EditOrderProps(Order, TOrderFormParamsProvider.Create);
end;

procedure TOrderController.SettingsChanged;
begin
  if Assigned(Entity) and Assigned(Entity.DataSet) then
  begin
    if TSettingsManager.Instance.NeedReload then
      Entity.Reload
    else
      FreshQuery(Entity.DataSet);
  end;
end;

function TOrderController.GetOrder: TOrder;
begin
  Result := FEntity as TOrder;
end;

function TOrderController.IsNewOrder: boolean;
begin
  Result := FState = stNew;
end;

procedure TOrderController.BulkEdit(SelectedRows: TIntArray);
begin
end;

procedure TOrderController.EditCurrent;
begin
  if Order.DataSet.IsEmpty then Exit;

  // ��������� ���� �� ��������� � ����
  if not IsNewOrder then Order.CheckActualState;

  Order.ReadKindPermissions(IsNewOrder);
  if not IsNewOrder then
  begin
    if not AccessManager.CurKindPerm.Browse then
    begin
      raise Exception.Create('�������� ������ ���� "' + Order.DataSet['KindName'] + '" ��� ��� ��������');
      //RusMessageDlg('�������� ������ ���� "' + Order.DataSet['KindName'] + '" ��� ��� ��������', mtError, [mbOk], 0);
      //Exit;
    end;
    // ��������/��������� ����������, ���� ����� �� ���� ���� ������
    CheckAndLockOrder;
  end;

  EnterOrder(Self);
end;

procedure TOrderController.CheckAndLockOrder;
var
  LockerName: string;
  LockerInfo: TUserInfo;
begin
  FReadOnly := false;
  if EntSettings.EditLock then
  begin
    // ��������� ������� ����������
    if TOrder.IsLockedByAnother(LockerName, Order.KeyValue) then
    begin
      LockerInfo := AccessManager.UserInfo(LockerName);
      if LockerInfo <> nil then
        LockerName := LockerInfo.Name;
      RusMessageDlg('���� ' + Order.NameSingular + ' ��� ������������� ������������� '
        + QuotedStr(LockerName) + #13 +
        '� ����� ������ ������ ��� ���������.'#13 +
        '�� �� ������� ������� ��������� ���������� ��������������.', mtInformation, [mbok], 0);
      FReadOnly := true;
    end
    else
    begin
      // ���� ��������, �� ��������� (����, �������, ����� �����������)
      TOrder.LockForEdit(Order.KeyValue);
      FEditLockTimer.Enabled := true;
    end;
  end;
end;

procedure TOrderController.UnlockOrder(OrderID: integer);
begin
  FEditLockTimer.Enabled := false;
  if EntSettings.EditLock and (OrderID <> 0) then
    Order.UnLock(OrderID);   // ������� ���������� � ������
end;

procedure TOrderController.SetProviderEvents(ParamsProvider: IOrderParamsProvider);
begin
  ParamsProvider.OnAddAttachedFile := DoOnAddAttachedFile;
  ParamsProvider.OnRemoveAttachedFile := DoOnRemoveAttachedFile;
  ParamsProvider.OnOpenAttachedFile := DoOnOpenAttachedFile;
  ParamsProvider.OnGetCostVisible := GetCostVisible;
  ParamsProvider.OnAddNote := DoOnAddNote;
  ParamsProvider.OnEditNote := DoOnEditNote;
  ParamsProvider.OnDeleteNote := DoOnDeleteNote;
  ParamsProvider.OnSelectTemplate := DoOnSelectTemplate;
end;

procedure TOrderController.EditEntityProperties(OrderEntity: TOrder; ParamsProvider: IOrderParamsProvider);
var
  OrderID: integer;
begin
  if OrderEntity.IsEmpty then Exit;

  if ViewMode = vmLeft then
    LogMessage('���� � ���������', null);

  // ��������� ���� �� ��������� � ����
  OrderEntity.CheckActualState;

  OrderEntity.ReadKindPermissions(false);  // �� ����� �����

  CheckAndLockOrder;  // ������ ���������� ������

  OrderID := OrderEntity.KeyValue;

  try
    DoBeforeEditEntityProperties;
    OrderEntity.DataSet.Edit;
    SetProviderEvents(ParamsProvider);
    if ParamsProvider.ExecOrderProps(OrderEntity, ViewMode = vmRight, FReadOnly) = mrOk then
    begin
      if OrderEntity.DataSet.State in [dsInsert, dsEdit] then OrderEntity.DataSet.Post;
      if Order.Notes.DataSet.State in [dsInsert, dsEdit] then Order.Notes.DataSet.Post;
      if Order.AttachedFiles.DataSet.State in [dsInsert, dsEdit] then Order.AttachedFiles.DataSet.Post;

      if not FReadOnly and (OrderEntity.HasChanges or Order.AttachedFiles.HasChanges
        or Order.Notes.HasChanges) then
      begin
        try
          LogMessage('���������� ��������� � ����������', null);

          if not Database.InTransaction then Database.BeginTrans;
          OrderEntity.ApplyUpdates;
          Order.AttachedFiles.ApplyUpdates;
          Order.Notes.ApplyUpdates;
          Database.CommitTrans;
          //NotifyModification;
          // ���� ����� � ������ ����������, �� �������� �������� ���� ����������
          // � ������� ����� ���������.
          {if (not InCalc) and
             (cdOrd['IncludeAdv'] <> OldIncludeAdv) then begin
            ReOrderID := cdOrd['N'];
            ReOrderCode := cdOrd['ID'];
            ReKind := chSumChanged;
            if CheckDep then CheckDependsAndShowForm(ReOrderID, ReOrderCode, ReKind,
                  Database.Connection);
          end;}
        except on E: Exception do
          if Database.InTransaction then
          begin
            Database.RollbackTrans;
            ExceptionHandler.Raise_(E);
          end;
        end;

        // ����� �������� �� ��� �� ��������
        //Entity.SavePagePosition := true;
        //try
          RefreshData;
          //if Entity <> OrderEntity then
          //  OrderEntity.Reload;
        //finally
        //  Entity.SavePagePosition := false;
        //end;

      end
    end
    else
    begin
      LogMessage('������ ��������� � ����������', null);
      Order.Notes.CancelUpdates;
      //Order.AttachedFiles.CancelUpdates;  // ����������� �����
      OrderEntity.CancelUpdates;
    end;
  finally
    UnlockOrder(OrderID);  // ������� ����������
    if ViewMode = vmLeft then
      LogMessage('����� �� ����������', null);
  end;
end;

procedure TOrderController.AskCancelCurrent(Sender: TObject);
begin
  if Options.ConfirmQuit and not ReadOnly and MainModified then
    AskForSave
  else
    CancelCurrent(Sender);
end;

procedure TOrderController.CancelCurrent(Sender: TObject);
var
  OrderID: integer;
begin
  LogMessage('������ ���������', null);
  OrderID := NvlInteger(Order.KeyValue);
  Order.Processes.CancelUpdates;
  Order.CancelUpdates;
  try
    UnLockOrder(OrderID);
  except
    LogMessage('�� ������� ����� ����������!', null);
  end;

  Order.Processes.CloseServices;

  CloseOrder;
end;

function TOrderController.Description: string;
begin
  Result := Order.NameSingular + ' ' + VarToStr(Order.OrderNumber);
end;

procedure TOrderController.LogMessage(Msg: string; Value: variant);
begin
  TLogger.getInstance.Info(Description + ': ' + Msg);
  dm.AddEventToHistory(GlobalHistory_Info, Description + ': ' + Msg, Value);
end;

function TOrderController.SaveAndClose: boolean;
var
  OrderID: integer;
begin
  ProcessingOrder := true;
  try
    if not FReadOnly then
    begin
      LogMessage('���������� ���������', null);

      FEditLockTimer.Enabled := false;
      OrderID := NvlInteger(Order.KeyValue);
      Result := SaveCurrent;
      if Result then
      begin
        Order.Processes.CloseServices;
        UnLockOrder(OrderID);
        CloseOrder;
      end;
    end
    else
    begin
      Result := RusMessageDlg(Order.NameSingular + ' �� ����� ��������, ��� ��� �� ������ ������ ��� ������. ����������?',
        mtConfirmation, mbYesNoCancel, 0) = mrYes;
      if Result then
        CancelCurrent(nil);
    end;
  finally
    ProcessingOrder := false;
  end;
end;

function TOrderController.SaveCurrent: boolean;
var
  cdOrd: TDataSet;
  KindPerm: TKindPerm;

  procedure UpcaseFirstComment;
  var
    s: string[128];
    s1: string[1];
  begin
    // ��������� ������ ����� �����������
    if not VarIsNull(cdOrd['Comment']) then
    begin
      s := TrimLeft(cdOrd['Comment']);
      if Length(s) <> 0 then begin
        s1 := s[1];
        if s1 <> AnsiUppercase(s1) then
        begin
          s1 := AnsiUppercase(s1);
          s[1] := s1[1];
          cdOrd.Edit;
          cdOrd['Comment'] := s;
        end;
      end
      else
      begin
        cdOrd.Edit;
        cdOrd['Comment'] := '';
      end;
    end;
  end;

begin
  cdOrd := Order.DataSet;
  Result := false;
  if ReadOnly then CancelCurrent(nil);

  Order.Processes.SetScriptedItemParams;
  ScriptManager.ExecOrderEvent(Order, TScriptManager.OrderBeforeSaveEvent);

  AccessManager.ReadKindPermTo(KindPerm, Order.KindID);
  if KindPerm.CheckOnSave and not CheckOrder(true) then Exit;

  UpcaseFirstComment;

  if cdOrd.State <> dsEdit then cdOrd.Edit;
  if Order is TWorkOrder then
    Order.USDCourse := Order.Processes.USDCourse;
  Order.DataSet['TotalCost'] := Order.Processes.GrandTotal;
  Order.DataSet['TotalGrn'] := Order.Processes.GrandTotalGrn;
  Order.DataSet['ClientTotal'] := Order.Processes.ClientTotal;

  if IsNewOrder then            // New Order
  begin
    if not Database.InTransaction then Database.BeginTrans;
    try
      FEntity.ApplyUpdates;

      if Order.NewOrderKey > 0 then
      begin
        { ������������� ����� }
        if not Order.AttachedFiles.ApplyUpdates  then begin Database.RollbackTrans; Exit; end;
        { ���������� }
        if not Order.Notes.ApplyUpdates  then begin Database.RollbackTrans; Exit; end;
        { �������� }
        if not Order.OrderItems.ApplyUpdates then begin Database.RollbackTrans; Exit; end;
        if not Order.Processes.ApplyAllProcessData then begin Database.RollbackTrans; Exit; end;
        { ��������� }
        Database.CommitTrans;

        FEntity.ReloadLocate(Order.NewOrderKey);

      end
      else   // ���� �����-�� ������, �����
      begin
        MessageDlg('������������ ��������� ������. ��������, ����������, ������������', mtError, [mbOk], 0);
        TLogger.getInstance.Warn('������������ ��������� ������');
        Database.RollbackTrans;
        dm.ShowProcErrorMessage(Order.NewOrderKey);
        if Order.NewOrderKey = 0 then
          CancelCurrent(nil);  // ���� ����-������, �� ���� ������ = 0
        Exit;
      end;

    except
     on E: Exception do
     begin
        Database.RollbackTrans;
        ExceptionHandler.Raise_(E);
        Exit;
     end;
    end;
  end
  else

  // Updating Order

  begin
    if cdOrd.State <> dsEdit then cdOrd.Edit;

    cdOrd.CheckBrowseMode;

    //if not InCalc and WorkOrderNumberExists then Exit;  20.08.2004
    if not Database.InTransaction then Database.BeginTrans;
    try
      DoBeforeUpdateOrder;
      Order.ApplyUpdates;
      if not DoAfterUpdateOrder then
      begin
        Database.RollbackTrans;
        Exit;
      end;
      Database.CommitTrans;

      // ����� �������� �� ��� �� ��������
      FEntity.SavePagePosition := true;
      try
        //RefreshData;
        FEntity.ReloadLocate(Order.NewOrderKey);
      finally
        FEntity.SavePagePosition := false;
      end;

    except
      on E: Exception do begin
        if Database.InTransaction then Database.RollbackTrans;
        ExceptionHandler.Raise_(E);
        Exit;
      end;
    end;
  end;
  Result := true;
end;

procedure TOrderController.GetCheckMessages(Msgs: TCollection);
begin
  Order.Processes.CheckServices(Msgs);
end;

function TOrderController.ShowCheckResults(ShowCancel: boolean; Msgs: TCollection): boolean;
begin
  Result := ExecCheckOrdForm(ShowCancel, Msgs);
end;

function TOrderController.CheckOrder(ShowCancel: boolean): boolean;
var Msgs: TCollection;
begin
  Result := true;
  try
    Msgs := TCollection.Create(TCheckMsg);
    try
      GetCheckMessages(Msgs);
      // ��� �������������� �������� ���������� ������
      if (Msgs.Count > 0) or not ShowCancel then
        Result := ShowCheckResults(ShowCancel, Msgs);
    finally
      FreeAndNil(Msgs);
    end;
  except end;
end;

procedure TOrderController.DoBeforeUpdateOrder;
begin
end;

function TOrderController.DoAfterUpdateOrder: boolean;
begin
  Result :=
    Order.OrderItems.ApplyUpdates  // ���������� ������� ������ - ������� ������
    and Order.Processes.ApplyAllProcessData  // ���������� ������� ���� ���������
    and Order.AttachedFiles.ApplyUpdates    // ������������� �����
    and Order.Notes.ApplyUpdates;          // ����������
end;

// ������� ��� ����������
procedure TOrderController.DeleteCurrent(Confirm: boolean);
var
  cdOrd: TDataSet;
  NextID: integer;
begin
  OrderBeforeScroll(nil);  // ��� ������ ��������������� ��������

  cdOrd := FEntity.DataSet;
  cdOrd.DisableControls;
  try
    try
      cdOrd.Next;
      if not cdOrd.eof then
      begin
        NextID := FEntity.KeyValue;
        cdOrd.Prior;
      end
      else
      begin
        cdOrd.Prior;
        if not cdOrd.bof then
        begin
          NextID := FEntity.KeyValue;
          cdOrd.Next;
        end
        else
          NextID := -1;
      end;
    except NextID := -1; end;
  finally
    cdOrd.EnableControls;
  end;
  if DoDeleteOrder(Confirm) then
  begin
    FEntity.ReloadLocate(NextID);
    //NotifyModification;
  end;
end;

// ������� ��� ����������
function TOrderController.DoDeleteOrder(Confirm: boolean): boolean;
var
  i: integer;
  s: string;
  EntityName, EntityNames: string;
  cdOrd: TDataSet;
begin
  Result := false;
  cdOrd := FEntity.DataSet;
  if cdOrd.IsEmpty then
  begin
    if Confirm then RusMessageDlg('� ��� ������ ���...', mtInformation, [mbok], 0);
    exit;
  end;

  if Confirm then
  begin
    EntityName := Order.NameSingular;
    EntityNames := Order.NamePlural;
    if FMasterGrid.SelectedRows.Count <= 1 then
    begin
      //s := '����������� � ������� ' + EntityName + ' ' + cdOrd['ID'] + ' ?'#13'������������: ' + NvlString(cdOrd['Comment'])
      //  + #13'��������: ' + NvlString(cdOrd['CustomerName']);
      s := Format('����������� � ������� %s %s ?'#13'������������: %s'#13'��������: %s',
         [EntityName, cdOrd['ID'], NvlString(cdOrd['Comment']), NvlString(cdOrd['CustomerName'])]);
    end
    else
      s := Format('����������� � ������� ���������� %s?', [EntityNames]);
      //s := '����������� � ������� ���������� ' + EntityNames + '?';

    if RusMessageDlg(s, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then exit;
  end;

  if FMasterGrid.SelectedRows.Count > 1 then
  begin
    for i := 0 to Pred(FMasterGrid.SelectedRows.Count) do
    begin
      cdOrd.GotoBookmark(pointer(FMasterGrid.SelectedRows[i]));
      if not Order.DeleteOrder(i = 0, i = Pred(FMasterGrid.SelectedRows.Count)) then Exit;
    end;
    FMasterGrid.SelectedRows.Clear;
    Result := true;
  end
  else
    Result := Order.DeleteOrder(true, true);
end;

procedure TOrderController.FilterChange;
begin
  // ����� ������ �������� �� RefreshData.
  // �������� ������, ��������, �� ���������. 
  OrderBeforeScroll(nil);
  Order.Reload;
end;

function TOrderController.CreateFrame(Owner: TComponent): TBaseFrame;
begin
  FFrame := GetFrameClass.Create(Owner,
    {GetComponentName(Owner, 'fr' + Order.InternalName), }Order
    {FOrderInvoiceItems, FOrderPayments, FOrderShipment});
  TOrdersFrame(FFrame).SetImageList(TSettingsManager.Instance.MainImageList);
  TOrdersFrame(FFrame).OnFilterChange := FilterChange;
  TOrdersFrame(FFrame).OnEditOrder := EditCurrent;
  TOrdersFrame(FFrame).OnBulkEdit := BulkEdit;
  TOrdersFrame(FFrame).OnProtectCost := DoOnProtectCost;
  TOrdersFrame(FFrame).OnProtectContent := DoOnProtectContent;
  TOrdersFrame(FFrame).OnUnProtectCost := DoOnUnProtectCost;
  TOrdersFrame(FFrame).OnUnProtectContent := DoOnUnProtectContent;
  TOrdersFrame(FFrame).OnGetCostVisible := GetCostVisible;
  TOrdersFrame(FFrame).OnContentPageActivated := ContentPageActivated;
  TOrdersFrame(FFrame).OnOrderBeforeScroll := OrderBeforeScroll;
  TOrdersFrame(FFrame).OnCancel := AskCancelCurrent;
  TOrdersFrame(FFrame).OnSaveAndClose := SaveAndClose;
  TOrdersFrame(FFrame).OnUpdateModified := UpdateModified;
  TOrdersFrame(FFrame).OrderInfoTimer.OnTimer := OrderInfoTimerTimer;

  FMasterGrid := TOrdersFrame(FFrame).dgOrders;

  ViewMode := vmLeft;

  (FFrame as TOrdersFrame).AfterCreate;
  Result := FFrame;
end;

procedure TOrderController.LoadSettings;
var
  AppStorage: TjvCustomAppStorage;
begin
  inherited LoadSettings;
  AppStorage := TSettingsManager.Instance.Storage;
  //TSettingsManager.Instance.LoadGridLayout(FMasterGrid, iniInterface + '\' + FEntity.InternalName);
  FLastExportDir := AppStorage.ReadString(iniInterface + '\' + FEntity.InternalName + '\' + 'LastExportDir', FLastExportDir);
  //FFrame.LoadSettings;
  Order.Processes.LoadSettings(AppStorage);
end;

procedure TOrderController.SaveSettings;
var
  AppStorage: TjvCustomAppStorage;
begin
  inherited SaveSettings;
  AppStorage := TSettingsManager.Instance.Storage;
  //TSettingsManager.Instance.SaveGridLayout(FMasterGrid, iniInterface + '\' + FEntity.InternalName);
  AppStorage.WriteString(iniInterface + '\' + FEntity.InternalName + '\' + 'LastExportDir', FLastExportDir);
  if Order.Processes <> nil then
    Order.Processes.SaveSettings(AppStorage);
  {if FFrame <> nil then
    FFrame.SaveSettings;}
end;

procedure TOrderController.ExportData;

  function GetFileName: string;
  begin
    Result := AddPath(FEntity.InternalName + '_' + IntToStr(Order.OrderNumber)
      + '_' + FormatDateTime('yyyy_mm_dd', Order.CreationDate) + '.xml', FLastExportDir);
  end;

var
  c: boolean;
  i: integer;
begin
  if FLastExportDir = '' then FLastExportDir := ExtractFileDir(ParamStr(0));
  if SelectDirectory(FLastExportDir, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
  begin
    c := false;
    // �� � ������
    if ViewMode = vmLeft then
    begin
      if FMasterGrid.SelectedRows.Count > 1 then
      begin
        // �����
        for i := 0 to Pred(FMasterGrid.SelectedRows.Count) do
        begin
          FEntity.DataSet.GotoBookmark(pointer(FMasterGrid.SelectedRows[i]));
          EditCurrent;
          OrderExchange.ExportOrder(FEntity as TOrder, GetFileName);
          CancelCurrent(nil);
        end;
        FMasterGrid.SelectedRows.Clear;
      end
      else
      if not FEntity.DataSet.IsEmpty then
      begin
        // ����
        EditCurrent;
        OrderExchange.ExportOrder(FEntity as TOrder, GetFileName);
        CancelCurrent(nil);
      end;
      if ViewMode = vmLeft then Exit;
      c := true;
    end else
      // ������ ������
      OrderExchange.ExportOrder(FEntity as TOrder, GetFileName);
  end;
end;

procedure TOrderController.ImportData;
begin
end;

procedure TOrderController.UpdateActionState;
var
  acen: boolean;
begin
  TMainActions.GetAction(TOrderActions.Copy).Enabled := not Entity.IsEmpty and (ViewMode = vmLeft)
    and AccessManager.CurKindPerm.CreateNew;
  TMainActions.GetAction(TOrderActions.Edit).Enabled := not Entity.IsEmpty and (ViewMode = vmLeft);
  TMainActions.GetAction(TOrderActions.Delete).Enabled := not Entity.IsEmpty and (ViewMode = vmLeft)
    and AccessManager.CurKindPerm.Delete;
  TMainActions.GetAction(TOrderActions.Print).Enabled := not Entity.IsEmpty;
  TMainActions.GetAction(TOrderActions.History).Enabled := not Entity.IsEmpty;
  TMainActions.GetAction(TMainActions.Reload).Enabled := ViewMode = vmLeft;
  TMainActions.GetAction(TOrderActions.New).Enabled := ViewMode = vmLeft;
  TMainActions.GetAction(TOrderActions.Import).Enabled := ViewMode = vmLeft;
  TMainActions.GetAction(TOrderActions.Check).Enabled := ViewMode = vmRight;
  TMainActions.GetAction(TOrderActions.Cancel).Enabled := ViewMode = vmRight;
  TMainActions.GetAction(TOrderActions.SetPrices).Enabled := (ViewMode = vmRight)
    and AccessManager.CurKindPerm.PriceView and AccessManager.CurKindPerm.Update;
  TMainActions.GetAction(TOrderActions.EditProperties).Enabled := not Entity.IsEmpty;
  acen := (ViewMode = vmRight) and not ReadOnly;// and (FFrame as TOrdersFrame).Modified;
  TMainActions.GetAction(TOrderActions.Save).Enabled := acen;
end;

procedure TOrderController.Activate;
begin
  // ����� ������������ ��������������� ��� ��������������, ������� �� ���������
  if not AutoClose and not Order.Active then
    Order.SetSortOrder(Order.SortField, true);

  TMainActions.GetAction(TOrderActions.EditProperties).OnExecute := acOrderPropsExecute;
  TMainActions.GetAction(TOrderActions.Delete).OnExecute := acDeleteOrderExecute;
  TMainActions.GetAction(TOrderActions.Edit).OnExecute := EditCurrent;
  TMainActions.GetAction(TOrderActions.New).OnExecute := acNewOrderExecute;
  TMainActions.GetAction(TOrderActions.Copy).OnExecute := acCopyOrderExecute;
  TMainActions.GetAction(TOrderActions.Export).OnExecute := acExportExecute;
  TMainActions.GetAction(TOrderActions.Import).OnExecute := acImportBatchExecute;
  TMainActions.GetAction(TOrderActions.SetPrices).OnExecute := acSetPricesExecute;
  TMainActions.GetAction(TOrderActions.History).OnExecute := acHistoryExecute;
  TMainActions.GetAction(TOrderActions.Save).OnExecute := acSaveExecute;
  TMainActions.GetAction(TOrderActions.Cancel).OnExecute := AskCancelCurrent;

  Order.ReadKindPermissions(false);

  if not WasActive and (ViewMode = vmLeft) then
  begin
    (FFrame as TOrdersFrame).RightToLeft;
    WasActive := true;
  end;

  if not Order.OrderItems.Active then
  begin
    OpenOrderItems;
  end;

  UpdateActionState;

end;

procedure TOrderController.OpenOrderItems;
begin
  OrderInfoTimer.Enabled := false;  // ��������� ������, ����� 2 ���� �� ���������

  BeforeCloseProcessItems;
  // ��������� ������ ������
  Order.OpenProcessItems(ViewMode = vmLeft);
  AfterOpenProcessItems;
end;

procedure TOrderController.UpdateOrderInfoPanel;
var
  cv: boolean;
begin
  cv := GetCostVisible;
  (FFrame as TOrdersFrame).ComInfoFrame.CostVisible := cv;
  (FFrame as TOrdersFrame).OrderItemsFrame.CostVisible := cv;
  (FFrame as TOrdersFrame).PageCostFrame.CostVisible := cv;
  (FFrame as TOrdersFrame).OrderItemsFrame.ProfitPreviewVisible := GetProfitPreviewVisible;
  (FFrame as TOrdersFrame).OrderItemsFrame.ProfitInsideVisible := GetProfitInsideVisible;
  (FFrame as TOrdersFrame).OrderItemsFrame.ModifyProfit := GetModifyProfit;

  if not Order.IsEmpty then
  begin
    (FFrame as TOrdersFrame).OrderItemsFrame.CostProtected := Order.CostProtected;
    (FFrame as TOrdersFrame).OrderItemsFrame.ContentProtected :=
       Order.ContentProtected or not AccessManager.CurKindPerm.Update;
  end;

  (FFrame as TOrdersFrame).ComInfoFrame.Order := Order;
  (FFrame as TOrdersFrame).ComInfoFrame.OnNoteClick := DoOnNoteClick;
end;

function TOrderController.OpenOrderDetails: boolean;
var
  oid: integer;
begin
  oid := NvlInteger(Order.KeyValue);

  {BeforeCloseProcessItems;
  dm.OpenProcessItems(oid, false);   // ������ �����
  AfterOpenProcessItems;}
  OpenOrderItems;

  Order.Processes.InDraft := Order is TDraftOrder;   //TODO: !!!!!!!!!!!!!!!!!!!!!!! ���������
  Order.Processes.CurOrderKind := Order.KindID;

  Result := Order.Processes.OpenAllProcessData(State <> stEdit, Order is TDraftOrder,
        oid, (FFrame as TOrdersFrame).ComInfoFrame.OpenProgress, Order.OrderItems.DataSet);
end;

procedure TOrderController.AfterOpenProcessItems;
begin
  if ViewMode = vmRight then
  begin
    Order.OrderItems.UpdateGrandTotal;
//    CalculateProfits;
  end;
  UpdateOrderInfoPanel;
  RefreshOrderItems;
end;

procedure TOrderController.BeforeCloseProcessItems;
begin
  (FFrame as TOrdersFrame).BeforeCloseProcessItems;
end;

function TOrderController.GetProfitPreviewVisible: boolean;
begin
  Result := not VarIsNull(Order.KindID) and IntInArray(Order.KindID, AllProfitPreviewKindValues);
end;

function TOrderController.GetProfitInsideVisible: boolean;
begin
  Result := not VarIsNull(Order.KindID) and IntInArray(Order.KindID, AllProfitInsideKindValues);
end;

function TOrderController.GetModifyProfit: boolean;
begin
  Result := not VarIsNull(Order.KindID) and IntInArray(Order.KindID, AllModifyProfitKindValues);
end;

procedure TOrderController.CloseOrder;
begin
  ViewMode := vmLeft;
  //(FFrame as TOrdersFrame).RightToLeft;
  RightToLeft;
  State := stNone;
  ResetSingleOrderFilter;
  OpenOrderItems;
  OnRightToLeft(Self);  // TODO: ������ ����� ���������� ������������� �������� ������� � ������
  if AutoClose then
    FOnCloseMe(Self);
end;

// ���������� ������ ������������� ������
procedure TOrderController.ResetSingleOrderFilter;
begin
  if FFilter.SingleOrderFilterSet then
  begin
    FFilter.ResetPrintFilter;
    if not AutoClose then
      Order.Reload;
  end;
end;

// ������������� ������ �� ������������ �����
procedure TOrderController.SetSingleOrderFilter(OrderID: integer);
begin
  if not MainModified or CanClose then
  begin
    FFilter.SetSingleOrderFilter(OrderID);
    Order.Reload;
  end;
end;

class procedure TOrderController.UpdateKindLists;
begin
  AllWorkCostViewKindValues := AccessManager.GetPermittedKinds('WorkCostView');
  AllDraftCostViewKindValues := AccessManager.GetPermittedKinds('DraftCostView');
  AllProfitPreviewKindValues := AccessManager.GetPermittedKinds('ShowProfitPreview');
  AllProfitInsideKindValues := AccessManager.GetPermittedKinds('ShowProfitInside');
  AllModifyProfitKindValues := AccessManager.GetPermittedKinds('ModifyProfit');
end;

function TOrderController.CopyOrder(ParamsProvider: ICopyParamsProvider): boolean;
var
  i: integer;
  Res: integer;
begin
  Result := false;
  ParamsProvider.CreateForm(Order);
  if Order.DataSet.IsEmpty then Exit;
  Res := ParamsProvider.Execute;
  if Res = mrOk then
  begin
    try
      if not Database.InTransaction then Database.BeginTrans;
      dm.aspCopyOrder.Parameters.ParamByName('@Src').Value := Order.KeyValue;
      //dm.aspCopyOrder.Parameters.ParamByName('@Calc').Value := InCalc;
      //dm.aspCopyOrder.Parameters.ParamByName('@Lock').Value := 1;       // ����������
      dm.aspCopyOrder.Parameters.ParamByName('@DefOrderState').Value := Options.DefOrderExecState;
      dm.aspCopyOrder.Parameters.ParamByName('@DefPayState').Value := Options.DefOrderPayState;
      dm.aspCopyOrder.Parameters.ParamByName('@FinishDate').Value := ParamsProvider.FinishDate;
      dm.aspCopyOrder.ExecProc;
      i := dm.aspCopyOrder.Parameters.ParamByName('@Dst').Value;   // ����� ������ ������
      if i < 0 then begin
        Database.RollbackTrans;
        dm.ShowProcErrorMessage(i);       // �� ����������
        Exit;
      end else
        Database.CommitTrans;
    except
      on E: Exception do begin
        Database.RollbackTrans;
        ExceptionHandler.Raise_(E);
      end;
    end;
    Order.ReloadLocate(i);
    Result := true;
    if not Order.Active then Order.Open;  // ���� �����-��... �� ������� �����
  end;
end;

procedure TOrderController.EditOrderProps(OrderEntity: TOrder; ParamsProvider: IOrderParamsProvider);
begin
{$B-}
  if ViewMode = vmLeft then
  begin  // �� � �������/������
    AllNotifIgnore := true;  // ��������� ��������� ��������
    ProcessingOrder := true;
    try
      EditEntityProperties(OrderEntity, ParamsProvider);
    finally
      AllNotifIgnore := false; // � � ��������� ���������
      ProcessingOrder := false; // � � ������������
    end;
  end
  else
  begin                            // � �������/������
    SetProviderEvents(ParamsProvider);
    ParamsProvider.ExecOrderProps(OrderEntity, ViewMode = vmRight, false {��������� ���������});
    if Order.Notes.DataSet.State in [dsInsert, dsEdit] then Order.Notes.DataSet.Post;
    //if Order.AttachedFiles.DataSet.State in [dsInsert, dsEdit] then Order.AttachedFiles.DataSet.Post;
    if Order.Notes.HasChanges then
      UpdateModified(nil);
    RefreshOrderItems;
  end;
end;

procedure TOrderController.OrderAfterScroll(Sender: TObject);
begin
  // ������ ��� �������� �������� ������ ������
  if Entity.DataSet.State <> dsInsert then
  begin
    Order.ReadKindPermissions(false);
    if not IsNewOrder then
      UpdateOrderInfoPanel;
    UpdateActionState;
    (FFrame as TOrdersFrame).UpdateMainParamsVisible;
    if InstantOpenProcessItems then
      OrderInfoTimerTimer(nil)
    else
    begin
      // reset timer for detailed view
      if OrderInfoTimer.Enabled then OrderInfoTimer.Enabled := false;
      OrderInfoTimer.Enabled := true;
    end;
  end;
end;

procedure TOrderController.OrderInfoTimerTimer(Sender: TObject);
begin
  if Entity.DataSet.Active and Database.Connected
    and not InsideOrder then
  begin
    OrderInfoTimer.Enabled := false;
    OpenOrderItems;
  end;
end;

(*procedure TOrderView.NotifyModification;
begin
  {$IFNDEF NoNet}
  if InCalc then begin
    if SendCalc then SendNotif(CalcNotif); // �������� ���� ���������, ��� ���� ���������� �������
  end else
    if SendOrd then SendNotif(WorkOrderNotif); // �������� ���� ���������, ��� ���� ���������� ������
  {$ENDIF}
end;

procedure TOrderView.NotifyCreation;
begin
 {$IFNDEF NoNet}
  if InCalc then begin
    if SendCalc then SendNotif(CalcNotif); // �������� ���� ���������, ��� ���� ���������� �������
  end else
    if SendNewOrd then SendNotif(NewWorkOrderNotif); // �������� ���� ��������� "����� �����"
 {$ENDIF}
end; *)

function TOrderController.InsideOrder: boolean;
begin
  Result := ViewMode = vmRight;
end;

procedure TOrderController.UpdateModified(Sender: TObject);
begin
  if InsideOrder then
    (FFrame as TOrdersFrame).Modified := MainModified;
end;

function TOrderController.LoadCurrent: boolean;
var
  //oid: integer;
  cdOrd: TDataSet;
  Save_Cursor: TCursor;
begin
  Result := false;

  Save_Cursor := Screen.Cursor;
  Screen.Cursor := crSQLWait;    { Show hourglass cursor }
  try
    (FFrame as TOrdersFrame).Modified := false;   // 19.10.2008 �� ����, ����� ����...
    
    cdOrd := Entity.DataSet;
    Order.Processes.Tirazz := Order.Tirazz;
    //oid := NvlInteger(FCurrentView.Entity.KeyValue);

    {if Entity is TWorkOrder then  // 2006-06-07 ������� ������� ����, ���� ����� try-finally
    begin
      // CurCourse := sm.USDCourse;      // ��� ������ - ��������� ���� � �������������
                                      // ����, ���������� � ������
      if not VarIsNull(cdOrd['Course']) then
        Order.Processes.USDCourse := cdOrd['Course']; // ���� �� ������.
      // ��������� ����� ��� ������������ ������������ ����������, ���� ��� ���������
      //OldTotalGrn := NvlFloat(cdOrd['TotalGrn']);  // 2008-06-05
      //OldIncludeAdv := NvlBoolean(cdOrd['IncludeAdv']);
    end;
    //else  // ��� ���������� ������ ������� ������� ����
    //  Order.Processes.USDCourse := TSettingsManager.Instance.AppCourse;
    }
    UpdateUSDCourse;

    try
      if not OpenOrderDetails then Exit;

      // �������� ����������� ��������� � �������������
      //dm.CompareCosts;

      // ����� ���� �������, �.�. ��� �������� �� ������ ���������� ���������� ���� �������
      Order.OrderItems.RefreshPartRecords;

      Order.OrderItems.EnableGrandTotal;
      Order.OrderItems.UpdateGrandTotal;
      Order.OrderItems.CalculateProfits;

    finally
      Order.DisableCalcFields := false;
    end;

    if State = stNew then
      Order.NewOrderKey := -1
    else
      Order.NewOrderKey := Entity.KeyValue;

    // ��������� ������ ����������
    UpdateModified(nil);
    // �������� ������ ��� ��������
    Order.Processes.AfterOrderOpen;

    if EntSettings.NativeCurrency and (Abs(Order.Processes.USDCourse - 1) >= 0.01) then
    begin
      if RusMessageDlg('���� ������ ���������� �� 1, ������ ��� ������� ������������ � ������������ ������.'
          + #13'��� ��������� ���������� ��������� ������ ���������� ���������� ���� ������ � 1 � ���������� ���� �� ������ � ������ ������'
          + #13'��������� �������������?', mtWarning, [mbYes, mbNo], 0) = mrYes then
      begin
        Order.Processes.USDCourse := 1;
        Order.Processes.UpdateAllPrices;
      end;
    end;

    Result := true;
  finally
    Screen.Cursor := Save_Cursor;  { Always restore to normal }
    (FFrame as TOrdersFrame).HideProgress;
  end;
end;

procedure TOrderController.StartFramesToRight;
var csg, csp: boolean;
begin
  {if FInvoicePage <> nil then
  begin
    PageCostFrame.InvoicePageIndex := FInvoicePage.PageIndex;
    FOrderInvPayFrame.Parent := FInvoicePage;
  end;}

  if not sdm.cdSrvPages.Active then
  begin
    sdm.RefreshSrvPages;
    csp := true;
  end else
    csp := false;
  if not sdm.cdSrvGrps.Active then
  begin
    sdm.RefreshSrvGroups;
    csg := true;
  end else
    csg := false;

  (FFrame as TOrdersFrame).StartFramesToRight;

  if csg then sdm.CloseSrvGroups;
  if csp then sdm.CloseSrvPages;
end;

procedure TOrderController.FinishFramesToRight;
begin
  (FFrame as TOrdersFrame).FinishFramesToRight;
end;

procedure TOrderController.EnterOrder(Sender: TObject);
begin
    if IsNewOrder then
      LogMessage('��������', null)
    else
      LogMessage('����', null);

    if (ViewMode <> vmLeft) or Order.IsEmpty then exit;

    if State = stNone then
      State := stEdit;

    // ��������� ���� �� ����������� ��������
    if (FPrevOrderKind <> Order.KindID) {or (FPrevOrderIsDraft <> (Entity is TDraftOrder))} // TODO! ��������� !!!!!!!!!!!!!!!!!!!!!!!!
       or not Assigned((FFrame as TOrdersFrame).ProcessPages)
       // ���� ����� �� ��������� ������� �� ����, ���� ��� �����, �� ���� �����������
       or (AccessManager.CurKindPerm.Update <> FPrevOrderPermitUpdate) then
    begin
      (FFrame as TOrdersFrame).FreeProcessPageList;
      (FFrame as TOrdersFrame).CreateProcessPageList;
      (FFrame as TOrdersFrame).CreatePages;
      FPrevOrderKind := Order.KindID;
      FPrevOrderPermitUpdate := AccessManager.CurKindPerm.Update;
      //FPrevOrderIsDraft := Order is TDraftOrder;     // TODO! ��������� !!!!!!!!!!!!!!!!!!!!!!!!
    end;
    //else if FPrevContentProtected <> (CurrentView as TOrder).ContentProtected then

    ViewMode := vmRight;
    LeftToRight;
    
    // ��������� ��������� ������ ���������
    Order.Processes.SetProtection(Order.CostProtected, Order.ContentProtected);
    Order.OrderItems.SetProtection(Order.CostProtected, Order.ContentProtected);

    Order.Processes.OnGridTotalUpdate := (FFrame as TOrdersFrame).GridTotalUpdate;

    StartFramesToRight;
    try
      if LoadCurrent then
      begin
        RefreshOrderItems;
        //OnEnterOrder(Self); // TODO: ������ ����� ���������� ������������� �������� ������� � ������
      end
      else
        RightToLeft;
    finally
      FinishFramesToRight;
    end;

end;

procedure TOrderController.RightToLeft;
begin
  UpdateActionState;
  UpdateRepMenuEnabled;
  //Order.Processes.USDCourse := TSettingsManager.Instance.AppCourse;
  UpdateUSDCourse;
  FreshQuery(Entity.DataSet);
  (FFrame as TOrdersFrame).RightToLeft;
  FCaption := Order.NamePlural;
  AfterRefresh(Self);  // ����� �������� ���������
  State := stNone;
end;

procedure TOrderController.LeftToRight;
begin
  AllNotifIgnore := true;         // ����. ��������� ���������� ��������
                                   // �. �. ����� ������� ��� ����� ��������������
  UpdateActionState;
  UpdateOrderInfoPanel;

  // ��� ������ ������ �� ��������, ��. ����. �����������
  //ViewMode := vmRight;
  // ����������� ����� ��������� ViewMode
  UpdateRepMenuEnabled;
  if VarIsNull(Order.OrderNumber) then
    FCaption := Order.NameSingular
  else
    FCaption := Order.NameSingular + ' ' + IntToStr(Order.OrderNumber);
  AfterRefresh(Self);  // ����� �������� ���������
  (FFrame as TOrdersFrame).LeftToRight;
end;

procedure TOrderController.SetAllNotifIgnore(val: boolean);
begin
  {$IFNDEF NoNet}
  FAllNotifIgnore := val;
  //if FAllNotifIgnore then sbStatus.Panels[0].Text := '������� �������������'
  //else sbStatus.Panels[0].Text := '������� �����������';
  {$ENDIF}
end;

function TOrderController.Modified: boolean;
begin
  if Entity = nil then
    raise EAssertionFailed.Create('EntityView.Modified: �� �������������� Entity');
  Result := (ViewMode = vmRight) and Entity.Modified;
end;

procedure TOrderController.NewOrder(ParamsProvider: IOrderParamsProvider);
var
  CreateKinds: TIntArray;
  cdOrd: TDataSet;
begin
  // TODO: ������� ����������� �����!
  if Entity is TWorkOrder then
    CreateKinds := AccessManager.GetPermittedKinds('WorkCreate')
  else
    CreateKinds := AccessManager.GetPermittedKinds('DraftCreate');

  if CreateKinds = nil then
  begin
    // TODO: ���������
    if Entity is TWorkOrder then
      RusMessageDlg('�������� ������� ���������', mtError, [mbOk], 0)
    else
      RusMessageDlg('�������� �������� ���������', mtError, [mbOk], 0);
  end
  else
  begin
    OrderBeforeScroll(nil);
    FReadOnly := false;    // �����������
    //ViewMode := vmDoing;
    State := stNew;
    AllNotifIgnore := true;
    {CalcTimer.Enabled := false;
    try}
      Order.NewOrderKey := -1;  // ����� ������-����� - ��� ������
      cdOrd := Entity.DataSet;
      cdOrd.Append;    // ��������� ������
      Order.USDCourse := TSettingsManager.Instance.AppCourse;
      SetProviderEvents(ParamsProvider);
      if ParamsProvider.ExecOrderProps(Order, ViewMode = vmRight,
        false {��������� ���������} ) = mrOk then
      begin
        ViewMode := vmLeft;
        State := stNew;
        EditCurrent;                 // ��������� ���
        UpdateModified(nil);
      end
      else
      begin
        Entity.CancelUpdates;  // ������ �������
        ViewMode := vmLeft;
        State := stNone;
      end;
    {finally
      AllNotifIgnore := ViewMode = vmRight;
      CalcTimer.Enabled := Options.AutoOpen;
    end;}
  end;
end;

procedure TOrderController.DoOnProtectCost(Sender: TObject);
begin
  Order.ProtectCost;
  OrderAfterScroll(Order);
end;

procedure TOrderController.DoOnProtectContent(Sender: TObject);
begin
  Order.ProtectContent;
  OrderAfterScroll(Order);
end;

procedure TOrderController.DoOnUnProtectCost(Sender: TObject);
begin
  Order.UnprotectCost;
  OrderAfterScroll(Order);
end;

procedure TOrderController.DoOnUnProtectContent(Sender: TObject);
begin
  Order.UnprotectContent;
  OrderAfterScroll(Order);
end;

function TOrderController.AskForSave: boolean;
var r: integer;
begin
  r := RusMessageDlg('����� ��� �������. ��������� ���������?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);
  if r = mrYes then
    Result := SaveAndClose
  else if r = mrNo then
  begin
    CancelCurrent(nil);
    Result := true;
  end
  else
    Result := false;
end;

procedure TOrderController.OrderBeforeScroll(Sender: TObject);
begin
  if Options.AutoOpen and not ProcessingOrder then
  begin
    if not InsideOrder then OrdWaitRefresh := 0
    else
    begin
      {CalcTimer.Enabled := false;}
      try
        if Order.Processes.ProcessesModified or Modified then
          AskForSave
        else
          CancelCurrent(nil);
      finally
        //CalcTimer.Enabled := true;
        OrdWaitRefresh := 0;
      end;
    end;
  end;
end;

procedure TOrderController.OrderAfterOpen(Sender: TObject);
begin
  UpdateActionState;
end;

procedure TOrderController.DisableProcessControls;
begin
  (FFrame as TOrdersFrame).OrderItemsFrame.DisableControls;
end;

procedure TOrderController.EnableProcessControls;
begin
  (FFrame as TOrdersFrame).OrderItemsFrame.EnableControls;
end;

procedure TOrderController.ContentPageActivated(Sender: TObject);
begin
  Order.Processes.SetScriptedItemParams;
end;

function TOrderController.MainModified: boolean;
var
  cdOrd: TDataSet;
begin
  cdOrd := Order.DataSet;
  if InsideOrder then
  begin
    {Result := AccessManager.CurKindPerm.Update; // ���� ��������� ���������, �� false
    if Result then
    begin}
      // �������� ���� �� ���������. sm ��� �����������, �������� �� ��������.
      // TODO: ���� ��������� �������� �� ���������� �������� � ��������� (������ ��� ���� � �.�.)
      Result := Modified or Order.Processes.ProcessesModified or Order.Notes.HasChanges;
      if not Result then
      begin
        // ���� ��������� � ������� �� ����
        Result := not Order.CostProtected;
        if Result then  // ���� ��������� ��������� ���������, �� ���������
          Result := FieldValueChanged(Order.DataSet.FieldByName(TOrder.F_ClientTotal), Order.Processes.ClientTotal)
                  or FieldValueChanged(Order.DataSet.FieldByName(TOrder.F_TotalCost), Order.Processes.GrandTotal);
                  //or FieldValueChanged(cdOrd.FieldByName('FinalCostGrn'), Order.Processes.GrandTotalGrn);
                  // 2006-06-07 ������� ������, 2006-09-04 1e-2, 2008-06-05 ����� OldTotalGrn
      end;
    //end;
  end
  else
   { TODO: ���� ����� ����� ������������� ��������� ���-�� �� ������ � �����, �� ����� ���� �������� ������� }
    Result := false;
end;

procedure TOrderController.BeforeProcessCfgChange_Handler(Sender: TObject);
begin
  (FFrame as TOrdersFrame).FreeProcessPageList;
  UpdateKindLists;
end;

procedure TOrderController.UpdateRepMenuEnabled;
begin
  // TODO
  //siReports.Enabled := AccessManager.CurUser.ViewReports;
  //FOnUpdateReportMenuEnabled(Self);
end;

function TOrderController.GetViewMode: TOrderViewMode;
begin
  Result := (FFrame as TOrdersFrame).ViewMode;
end;

procedure TOrderController.SetViewMode(Value: TOrderViewMode);
begin
  (FFrame as TOrdersFrame).ViewMode := Value;
end;

function TOrderController.OrderInfoTimer: TTimer;
begin
  Result := (FFrame as TOrdersFrame).OrderInfoTimer;
end;

procedure TOrderController.GrnGrandTotalChanged(Sender: TObject);
var s: string;
begin
  s := FloatToStrF(Order.Processes.GrandTotalGrn, ffNumber, 12, 2);
  (FFrame as TOrdersFrame).ComInfoFrame.SetGrnCost(s);
  //sbStatus.Panels[1].Text := s + ' ���. �� ����� ' + floattostrf(sm.USDCourse, ffNumber, 12, 2);
end;

procedure TOrderController.GrandTotalChanged(Sender: TObject);
var
  s: string;
  gt: extended;
begin
  s := FloatToStrF(Order.Processes.GrandTotal, ffNumber, 12, 2);
  //TotalItogo.Caption := s;
  (FFrame as TOrdersFrame).ComInfoFrame.SetUECost(s);
  // ���� �� 1 - � ������ ���� ��� ��������� � ������� ����������
  // ��������� ��� ���������, � �.�. - ���������!
  if Options.ShowFinalNative then
    gt := Order.Processes.ClientTotalGrn   // 28/04/2008  ������ ���� GrandTotalGrn
  else
    gt := Order.Processes.GrandTotal;
  if Order.Processes.Tirazz > 0 then
    s := FloatToStrF(Round2(gt / Order.Processes.Tirazz), ffNumber, 12, 2)
  else
    s := '';
  (FFrame as TOrdersFrame).ComInfoFrame.Set1Cost(s);
  // ���������� ����� ������
  if EntSettings.ShowExpenseCost then
  begin
    s := FloatToStrF(Order.Processes.TotalExpenseCost, ffNumber, 12, 2);
    (FFrame as TOrdersFrame).ComInfoFrame.SetExpenseCost(s);
  end;
end;

procedure TOrderController.ClientCostChanged(Sender: TObject);
var
  s: string;
  gt: extended;
begin
  Order.OrderItems.CalculateProfits;

  if Options.ShowFinalNative then
    gt := Order.Processes.ClientTotalGrn
  else
    gt := Order.Processes.ClientTotal;
  s := FloatToStrF(gt, ffNumber, 12, 2);
  (FFrame as TOrdersFrame).ComInfoFrame.SetClientCost(s);
end;

procedure TOrderController.RefreshOrderItems;
begin
  (FFrame as TOrdersFrame).RefreshOrderItems;
end;

procedure TOrderController.EditCurrent(Sender: TObject);
begin
  EditCurrent;
end;

procedure TOrderController.acDeleteOrderExecute(Sender: TObject);
begin
  {AllNotifIgnore := true;
  try}
    DeleteCurrent(true);  // ask confirmation
  {finally
    AllNotifIgnore := false;
  end;}
end;

procedure TOrderController.acNewOrderExecute(Sender: TObject);
begin
  OrderBeforeScroll(nil);  // ��� ������ ��������������� ��������
  NewOrder(TOrderFormParamsProvider.Create);
end;

procedure TOrderController.acCopyOrderExecute(Sender: TObject);
begin
  OrderBeforeScroll(nil);  // ��� ������ ��������������� ��������
  CopyOrder(TCopyOrderFormParamsProvider.Create)
end;

procedure TOrderController.acExportExecute(Sender: TObject);
begin
  ExportData;
end;

function TOrderController.CanClose: boolean;
var
  res: word;
begin
  Result := true;
  if Order.Active and (ViewMode = vmRight) then
  begin
    if Options.AutoOpen and not MainModified{Modified and not sm.ProcessesModified} then
      res := mrNo
    else
    if not ReadOnly and MainModified{(Modified or sm.ProcessesModified)} then
      res := RusMessageDlg('��������� ������� ' + Order.NameSingular + '?', mtConfirmation, mbYesNoCancel, 0)
    else
      res := mrNo;

    if res = mrCancel then
      Result := false
    else
    if res = mrYes then
      SaveAndClose
    else
    if res = mrNo then
      CancelCurrent(nil);
  end;
end;

procedure TOrderController.RefreshData;
begin
  OrderBeforeScroll(nil);
  // ����� �������� �� ��� �� ��������
  FEntity.SavePagePosition := true;
  try
    Order.Reload;
  finally
    FEntity.SavePagePosition := false;
  end;
end;

procedure TOrderController.PrintDefaultOrderReport;
begin
  if not TSettingsManager.Instance.DefaultAllowInside then
    OrderBeforeScroll(nil);
  DoPrintOrderReport(TSettingsManager.Instance.DefaultReportID);
end;

procedure TOrderController.PrintReport(ReportKey: integer; AllowInside: boolean);
begin
  // �������� �������� �������
  if InsideOrder then
    Order.Processes.SetScriptedItemParams;

  if not AllowInside then
    OrderBeforeScroll(nil);  // ���� ������ ������ ��������� ������, �� ������� ���������
  DoPrintOrderReport(ReportKey);
end;

procedure TOrderController.DoPrintOrderReport(ReportKey: integer);
begin
  {CalcTimer.Enabled := false;}
  ProcessingOrder := true;
  InstantOpenProcessItems := true;
  ScriptOrder := Order;
  try
    ScriptManager.ExecExcelReport(ReportKey);
  finally
    //AllNotifIgnore := false;
    InstantOpenProcessItems := false;
    ProcessingOrder := false;
    //CalcTimer.Enabled := Options.AutoOpen;
  end;
end;

function TOrderController.BuildCustomReport(ReportKey: integer): TReportData;
begin
  AllNotifIgnore := true;
  //CalcTimer.Enabled := false;
  ProcessingOrder := true;
  InstantOpenProcessItems := true;
  try
    Result := CustomReportBuilder.ExecCustomReport(Order, ReportKey);
  finally
    AllNotifIgnore := false;
    InstantOpenProcessItems := false;
    ProcessingOrder := false;
    //CalcTimer.Enabled := Options.AutoOpen;
  end;
end;

procedure TOrderController.acSetPricesExecute(Sender: TObject);
begin
  Order.Processes.UpdateAllPrices;
end;

procedure TOrderController.acHistoryExecute(Sender: TObject);
begin
  AppController.ViewOrderHistory(Order);
end;

function OverrideParameters(ID_Number: integer; CreatorName: string;
  ModifierName: string; CreationDate, ModifyDate: TDateTime): string;
var
  aq: TADOQuery;
  LastN: integer;
begin
  aq := TADOQuery.Create(nil);
  aq.Connection := Database.Connection;
  aq.SQL.Add('select max(N) from WorkOrder');
  aq.Open;
  LastN := aq.Fields[0].Value;
  aq.Free;
  Result := 'update WorkOrder set ID_Number = ' + IntToStr(ID_number)
    + ', CreatorName = ''' + CreatorName + ''', ModifierName = ''' + ModifierName
    + ''', CreationDate = ' + FormatSQLDateTime(CreationDate)
    + ', ModifyDate = ' + FormatSQLDateTime(ModifyDate)
    + ' where N = ' + IntToStr(LastN);
end;

procedure TOrderController.acImportBatchExecute(Sender: TObject);
var
  I: Integer;
  FileList: TStringList;
  FromFileName: string;
  Provider: TOrderImportParamsProvider;
  OrderInfo: TOrderInfo;
  UpdateSQL: TStringList;
begin
    if ViewImportFolder(FileList) then
    begin
      // ������������� ������ ��������� ��� ������ ��������, � ������� �����
      // � ������� ������ ������������. ���� ����� �������������, � �� ������ ������ ������,
      // �� ���� ��������� ����������� sql ���� ��� sa.
      UpdateSQL := TStringList.Create;
      try
        for I := 0 to FileList.Count - 1 do
        begin
          // ��� ���������, ��� ��� � �������.
          // ���� ��� ������ �� ���������������, �� ����� ������ �����.
          if not InsideOrder then
          begin
            FromFileName := FileList[i];
            Provider := TOrderImportParamsProvider.Create;
            Provider.FileName := FromFileName;
            NewOrder(Provider);
            if not OrderExchange.ImportOrder(Order, FromFileName) then
              CancelCurrent(nil)
            else
            begin
              SaveAndClose;
              if OrderExchange.ReadOrderInfo(FromFileName, OrderInfo) then
                UpdateSQL.Add(OverrideParameters(OrderInfo.ID_Number, OrderInfo.CreatorName, OrderInfo.ModifierName, OrderInfo.CreationDate, OrderInfo.ModifyDate))
              else
                raise Exception.Create('�� ������� ������� ���� ' + FromFileName);
            end;
          end else
            break;
        end;
        if FileList.Count > 0 then
          UpdateSQL.SaveToFile(AddPath('ImportSQL.sql', ExtractFileDir(FileList[0])));
      finally
        UpdateSQL.Free;
      end;
    end;
end;

procedure TOrderController.acSaveExecute(Sender: TObject);
begin
  SaveAndClose;
end;

procedure TOrderController.DoEditLockTimer(Sender: TObject);
begin
  TOrder.LockForEdit(Order.KeyValue);
end;

class function TOrderController.GetAttachedFilePath(Order: TOrder; FileName: string): string;
var
  p: string;
begin
  //Result := AddPath(AddPath(AddPath(FileName, VarToStr(Order.OrderNumber)), IntToStr(YearOf(Order.CreationDate))), EntSettings.FileStoragePath);
  p := AddPath(IntToStr(YearOf(Order.CreationDate)), EntSettings.FileStoragePath);
  if not SysUtils.DirectoryExists(p) then
    CreateDir(p);
  p := AddPath(VarToStr(Order.OrderNumber), p);
  if not SysUtils.DirectoryExists(p) then
    CreateDir(p);
  Result := AddPath(FileName, p);
end;

procedure TOrderController.DoOnOpenAttachedFile(Sender: TObject);
begin
  OpenAttachedFile(Order);
end;

class procedure TOrderController.OpenAttachedFile(Order: TOrder);
var
  p: string;
begin
  if not Order.AttachedFiles.IsEmpty then
  begin
    p := GetAttachedFilePath(Order, Order.AttachedFiles.FileName);
    ShellExecute(0, nil, PChar(p), nil, nil, SW_NORMAL);
  end;
end;

procedure TOrderController.DoOnRemoveAttachedFile(Sender: TObject);
var
  p: string;
begin
  if not Order.AttachedFiles.IsEmpty
    and (RusMessageDlg('�� ������������� ������ ������� ���� ' + Order.AttachedFiles.FileName + '?'#13
      + '��� �������� �� ����� ���� ��������.', mtWarning, mbYesNoCancel, 0) = mrYes) then
  begin
    p := GetAttachedFilePath(Order, Order.AttachedFiles.FileName);
    DeleteFile(p);
    Order.AttachedFiles.Delete;
    Order.AttachedFiles.ApplyUpdates;
  end;
end;

procedure TOrderController.DoOnAddAttachedFile(Sender: TObject);
var
  DestFile, SourceFile, OnlyFileName: string;
  Dlg: TOpenDialog;
begin
  Dlg := TOpenDialog.Create(nil);
  try
    if Dlg.Execute then
    begin
      SourceFile := Dlg.FileName;
      OnlyFileName := SysUtils.ExtractFileName(SourceFile);
      DestFile := GetAttachedFilePath(Order, OnlyFileName);
      if CopyFile(PChar(SourceFile), PChar(DestFile), false) then
      begin
        Order.AttachedFiles.Append;
        Order.AttachedFiles.FileName := OnlyFileName;
        //Order.AttachedFiles.OrderID := Order.NewOrderKey; // ��� ������ ������ -1
        Order.AttachedFiles.ApplyUpdates;
      end
      else
        RusMessageDlg(SysErrorMessage(GetLastError), mtError, [mbOk], 0);
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TOrderController.EditNote;
var
  _ReadOnly: boolean;
  Trimmed: string;
begin
  _ReadOnly := not CanEditNote;
  if ExecOrderNoteForm(Order.Notes, _ReadOnly) then
  begin
    Trimmed := Trim(Order.Notes.NoteText);
    if Order.Notes.NoteText <> Trimmed then
      Order.Notes.NoteText := Trimmed;
    {if ViewMode = vmLeft then
    begin
      Order.Notes.ApplyUpdates;
      //Order.Notes.Reload;
    end;}
  end
  else
  begin
    {if ViewMode = vmLeft then
      Order.Notes.CancelUpdates
    else}
      Order.Notes.DataSet.Cancel;
  end;
end;

procedure TOrderController.DoOnAddNote(Sender: TObject);
begin
  Order.Notes.Append;
  Order.Notes.UserName := AccessManager.CurUser.Login;
  //Order.Notes.OrderID := Order.NewOrderKey;   // ��� ������ ������ -1
  EditNote;
end;

procedure TOrderController.DoOnEditNote(OrderNoteID: integer);
begin
  if not Order.Notes.IsEmpty and Order.Notes.Locate(OrderNoteID) then
    EditNote;
end;

function TOrderController.CanEditNote: boolean;
begin
  Result := SameText(Order.Notes.UserName, AccessManager.CurUser.Login)
         or (Order.Notes.UserName = '') or AccessManager.CurUser.EditUsers;
end;

procedure TOrderController.DoOnDeleteNote(OrderNoteID: integer);
begin
  if not Order.Notes.IsEmpty and Order.Notes.Locate(OrderNoteID) and CanEditNote then
  begin
    Order.Notes.DataSet.Delete;
    {if ViewMode = vmLeft then
      Order.Notes.ApplyUpdates;}
  end;
end;

procedure TOrderController.DoOnSelectTemplate(Sender: TObject);
var
  TemplateOrderID: integer;
begin
  ExecSelectTemplateForm(TemplateOrderID);
end;

procedure TOrderController.DoOnNoteClick(Sender: TObject);
begin
  ShowNotesPopupForm(Order.Notes, DoOnEditNote);
end;

{procedure TOrderView.DoOnPopupNoteClick(Sender: TObject);
begin
  // �������� ���� ���������
end;}

end.
