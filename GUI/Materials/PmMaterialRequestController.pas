unit PmMaterialRequestController;

interface

uses Classes, Controls, Forms, SysUtils, JvAppStorage, Dialogs, ExtCtrls,
  JvSpeedBar,

  NotifyEvent, fBaseFrame, PmEntity, PmEntityController, fMatRequestFrame, PmMatRequest,
  fMatRequestToolbar;

type
  TMaterialRequestController = class(TEntityController)
  private
    FToolbarFrame: TMatRequestToolbar;
    FSetID, {FEditID, }FOpenID: TNotifyHandlerID;
    function GetFrame: TMatRequestFrame;
    function GetMatRequest: TMaterialRequests;
    procedure FilterChange;
    procedure DisableFilter;
    procedure DoPrintMatRequestReport(Sender: TObject);
    procedure DoPrintMatRequestForm(Sender: TObject);
    procedure DoOpenOrder(Sender: TObject);
    procedure DoSave(Sender: TObject);
    procedure DoCancel(Sender: TObject);
    procedure DoEditMatRequest(Sender: TObject);
    procedure DoDeleteMatRequest(Sender: TObject);
    function HandleGetCourse: extended;
    procedure UpdateActionState;
    procedure DoAfterEdit(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    function CheckChanges: boolean;
    procedure SettingsChanged; override;
    procedure SetSortOrder(SortField: string);
  public
    constructor Create(_Entity: TEntity); override;
    destructor Destroy; override;
    function Visible: boolean; override;
    procedure EditCurrent;
    function CreateFrame(Owner: TComponent): TBaseFrame; override;
    procedure Activate; override;
    procedure Deactivate(var AllowLeave: boolean); override;
    //procedure LoadSettings(AppStorage: TjvCustomAppStorage); override;
    //procedure SaveSettings(AppStorage: TjvCustomAppStorage); override;
    procedure RefreshData; override;
    function GetToolbar: TjvSpeedbar; override;
    property Frame: TMatRequestFrame read GetFrame;
    property MatRequests: TMaterialRequests read GetMatRequest;
  end;

implementation

uses Variants, DB, DateUtils,

  CalcUtils, RDialogs, PmDatabase, PmAppController, PmOrder,
  DicObj, StdDic, RDBUtils, MainFilter, PmAccessManager, PmEntSettings,
  CalcSettings, PmActions, PmScriptManager, PmMaterials, PmMatRequestForm;

constructor TMaterialRequestController.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  FFilter := TMaterialFilterObj.Create;
  MatRequests.Criteria := FFilter as TMaterialFilterObj;
  FFilter.RestoreFilter(TSettingsManager.Instance.Storage, iniFilter + FEntity.InternalName);
  FCaption := 'ћатериалы: «акупка';

  //FEditID := MatRequests.AfterEditNotifier.RegisterHandler(DoAfterEdit);
  FOpenID := MatRequests.OpenNotifier.RegisterHandler(DoAfterOpen);

  TMainActions.GetAction(TMaterialRequestActions.Edit).OnExecute := DoEditMatRequest;
  {TMainActions.GetAction(TMatRequestActions.New).OnExecute := DoNewMatRequest;}
  TMainActions.GetAction(TMaterialRequestActions.Delete).OnExecute := DoDeleteMatRequest;
  TMainActions.GetAction(TMaterialRequestActions.PrintReport).OnExecute := DoPrintMatRequestReport;
  //TMainActions.GetAction(TMatRequestActions.PrintForm).OnExecute := DoPrintMatRequestForm;
  TMainActions.GetAction(TMaterialRequestActions.OpenOrder).OnExecute := DoOpenOrder;
  TMainActions.GetAction(TMaterialRequestActions.Save).OnExecute := DoSave;
  TMainActions.GetAction(TMaterialRequestActions.Cancel).OnExecute := DoCancel;

  SettingsChanged;
end;

destructor TMaterialRequestController.Destroy;
begin
  //MatRequests.AfterEditNotifier.UnregisterHandler(FEditID);
  MatRequests.OpenNotifier.UnregisterHandler(FOpenID);
  inherited;
end;

function TMaterialRequestController.Visible: boolean;
begin
  Result := true;
end;

function TMaterialRequestController.CreateFrame(Owner: TComponent): TBaseFrame;
begin
  FFrame := TMatRequestFrame.Create(Owner, MatRequests);

  FFrame.OnFilterChange := FilterChange;
  FFrame.OnDisableFilter := DisableFilter;
  FFrame.OnHideFilter := AppController.HideFilter;
  (FFrame as TMatRequestFrame).OnSetSortOrder := SetSortOrder;
  (FFrame as TMatRequestFrame).OnUpdateData := DoAfterEdit;

  //TMatRequestFrame(FFrame).OnEditMatRequest := DoEditMatRequest;

  Result := FFrame;
end;

procedure TMaterialRequestController.Activate;
var
  Save_Cursor: TCursor;
begin
  // не обновл€ть если уже открыт
  if not FEntity.DataSet.Active then
  begin
    Save_Cursor := Screen.Cursor;
    Screen.Cursor := crSQLWait;
    try
      FEntity.Reload;
    finally
      Screen.Cursor := Save_Cursor;  { Always restore to normal }
    end;
  end;
end;

procedure TMaterialRequestController.Deactivate(var AllowLeave: boolean);
begin
  AllowLeave := CheckChanges;
end;

{procedure TMaterialRequestView.LoadSettings(AppStorage: TjvCustomAppStorage);
begin
  inherited LoadSettings(AppStorage);
  if FFrame <> nil then // на вс€кий аварийный
    TMatRequestFrame(FFrame).LoadSettings;
end;

procedure TMaterialRequestView.SaveSettings(AppStorage: TjvCustomAppStorage);
begin
  inherited SaveSettings(AppStorage); // сохран€ет фильтр!
  if FFrame <> nil then // на вс€кий аварийный
    TMatRequestFrame(FFrame).SaveSettings;
end;}

function TMaterialRequestController.GetFrame: TMatRequestFrame;
begin
  Result := TMatRequestFrame(FFrame);
end;

procedure TMaterialRequestController.RefreshData;
begin
  if CheckChanges then
    inherited;
  //MatRequest.Reload;
end;

function TMaterialRequestController.GetMatRequest: TMaterialRequests;
begin
  Result := Entity as TMaterialRequests;
end;

procedure TMaterialRequestController.FilterChange;
begin
  RefreshData;
end;

procedure TMaterialRequestController.DisableFilter;
begin

end;

procedure TMaterialRequestController.DoPrintMatRequestReport(Sender: TObject);
begin
  if CheckChanges then
  begin
    MatRequests.FetchAllRecords;
    ScriptManager.ExecOrderEvent(nil, TScriptManager.PrintMatRequestReport);
  end;
end;

procedure TMaterialRequestController.DoPrintMatRequestForm(Sender: TObject);
begin
  //ScriptManager.ExecOrderEvent(nil, TScriptManager.PrintMatRequestForm);
end;

procedure TMaterialRequestController.EditCurrent;
var
  //MatID: integer;
  AllowEdit, _ReadOnly, NeedLock: boolean;
  LockerName: string;
  LockerInfo: TUserInfo;
  MaterialItem: TMaterials;
begin
  if not Options.EditMatRequest and not MatRequests.IsEmpty then
  begin
    {MatID := MatData.KeyValue;
    // ѕровер€ем были ли изменени€ в базе
    Order.CheckActualState;
    // провер€ем на случай если заказ перезагрузилс€
    AllowEdit := MatData.Locate(MatID) and not MatData.IsEmpty;}

    AllowEdit := true;

    if AllowEdit then
    begin
      AccessManager.ReadCurKindPerm(false, MatRequests.KindID, AccessManager.GetUserID(MatRequests.CreatorName));
      _ReadOnly := not AccessManager.CurKindPerm.EditMaterialRequest;
      NeedLock := EntSettings.EditLock and not _ReadOnly;
      if NeedLock then
      begin
        // ѕровер€ем наличие блокировки
        if TOrder.IsLockedByAnother(LockerName, MatRequests.OrderID) then
        begin
          LockerInfo := AccessManager.UserInfo(LockerName);
          if LockerInfo <> nil then
            LockerName := LockerInfo.Name;
          RusMessageDlg('«аказ редактируетс€ пользователем '
            + QuotedStr(LockerName) + #13 +
            '¬ы не сможете сможете сохранить изменени€.', mtInformation, [mbok], 0);
          _ReadOnly := true;
        end;
      end;

      if not _ReadOnly and NeedLock then
      begin
        TOrder.LockForEdit(MatRequests.OrderID); // устанавливаем блокировку заказа
        //FEditLockTimer.Enabled := true;
      end;
      try
        try
          MaterialItem := TMaterials.Create(MatRequests.DataSet.Owner);
          MaterialItem.OnGetCourse := HandleGetCourse;
          MaterialItem.OrderID := MatRequests.OrderID;
          MaterialItem.Open;
          if MaterialItem.Locate(MatRequests.KeyValue) then
          begin
            if ExecMaterialRequestForm(MaterialItem, _ReadOnly, false, AccessManager.CurKindPerm.CostView,
              AccessManager.CurKindPerm.FactCostView) then
            begin
              MaterialItem.ApplyUpdates;
              MatRequests.Reload;
            end;
          end;
        finally
          FreeAndNil(MaterialItem);
        end;
      finally
        if not _ReadOnly and NeedLock then
        begin
          TOrder.Unlock(MatRequests.OrderID);   // снимаем блокировку
          //FEditLockTimer.Enabled := false;
        end;
      end;
    end;
  end;
end;

function TMaterialRequestController.HandleGetCourse: extended;
begin
  Result := MatRequests.ExchangeRate;
end;

procedure TMaterialRequestController.DoEditMatRequest(Sender: TObject);
begin
  EditCurrent;
end;

// «апрашивает у пользовател€, сохранить ли данные и сохран€ет если дв, отмен€ет если нет.
// ¬озвращает true, если ситуаци€ разрешена или не было изменений, false - если пользователь
// нажал cancel.
function TMaterialRequestController.CheckChanges: boolean;
var
  Res: integer;
begin
  if MatRequests.HasChanges then
  begin
    Res := RusMessageDlg('ƒанные изменены. —охранить?', mtConfirmation, mbYesNoCancel, 0);
    if Res = mrYes then
    begin
      MatRequests.ApplyUpdates;
      Result := true;
    end
    else if Res = mrNo then
    begin
      MatRequests.CancelUpdates;
      Result := true;
    end
    else
      Result := false;
  end
  else
    Result := true;
end;

procedure TMaterialRequestController.DoDeleteMatRequest(Sender: TObject);
var
  MatID: integer;
begin
  if not MatRequests.IsEmpty and MatRequests.RequestModified then
  begin
    // ≈сли разрешено редактирование пр€мо в таблице, то сначла надо проверить, были ли изменени€
    if not Options.EditMatRequest or CheckChanges then
    begin
      MatID := MatRequests.KeyValue;
      // ѕровер€ем были ли изменени€ в базе
      //Order.CheckActualState;
      // провер€ем на случай если таблица перезагрузилась
      //if MatRequests.Locate(MatID) and not MatRequests.IsEmpty and MatRequests.RequestModified then
      begin
        MatRequests.Delete;
        // ѕримен€ем изменени€
        MatRequests.ApplyUpdates;
      end;
    end;
  end;
end;

function TMaterialRequestController.GetToolbar: TjvSpeedbar;
begin
  if FToolbarFrame = nil then
    FToolbarFrame := TMatRequestToolbar.Create(nil);
  Result := FToolbarFrame.Toolbar;
end;

procedure TMaterialRequestController.DoOpenOrder(Sender: TObject);
var
  OrderID: variant;
begin
  OrderID := MatRequests.OrderID;
  if not VarIsNull(OrderID) then
  begin
    AppController.EditWorkOrder(OrderID);
  end;
end;

procedure TMaterialRequestController.DoSave(Sender: TObject);
begin
  MatRequests.ApplyUpdates;
end;

procedure TMaterialRequestController.DoCancel(Sender: TObject);
begin
  MatRequests.CancelUpdates;
  UpdateActionState;
end;

procedure TMaterialRequestController.SettingsChanged;
begin
  UpdateActionState;
  AppController.SetPaging(MatRequests, not Options.ShowTotalMatRequests);
end;

procedure TMaterialRequestController.DoAfterEdit(Sender: TObject);
begin
  if MatRequests.DataSet.State = dsEdit then
  begin
    MatRequests.DataSet.Post;
    UpdateActionState;
    MatRequests.DataSet.Edit;
  end
  else
    UpdateActionState;
end;

procedure TMaterialRequestController.DoAfterOpen(Sender: TObject);
begin
  UpdateActionState;
end;

procedure TMaterialRequestController.UpdateActionState;
var
  e: boolean;
begin
  e := Options.EditMatRequest and MatRequests.Active and MatRequests.HasChanges;
  TMainActions.GetAction(TMaterialRequestActions.Save).Enabled := e;
  TMainActions.GetAction(TMaterialRequestActions.Cancel).Enabled := e;
  TMainActions.GetAction(TMaterialRequestActions.Edit).Enabled := not Options.EditMatRequest;
end;

procedure TMaterialRequestController.SetSortOrder(SortField: string);
begin
  if CheckChanges then
    MatRequests.SetSortOrder(SortField, true);
end;

end.
