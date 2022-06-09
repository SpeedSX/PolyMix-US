unit PmInvoiceController;

interface

uses Classes, Controls, Forms, SysUtils, JvAppStorage, Dialogs, ExtCtrls,
  JvSpeedBar,

  NotifyEvent, fBaseFrame, PmEntity, PmEntityController, fInvoiceFrame, PmInvoice,
  PmCustomerOrders, fInvoicesToolbar;

type
  TInvoiceController = class(TEntityController)
  private
    FAfterScrollID, FAfterScrollID2: TNotifyHandlerID;
    FOpenID: TNotifyHandlerID;
    //FCustomerOrders: TCustomerInvoiceOrders;
    InvoiceTimer: TTimer;
    FToolbarFrame: TInvoicesToolbar;
    function GetFrame: TInvoicesFrame;
    procedure UpdateDetails(Sender: TObject);
    function GetInvoices: TInvoices;
    function GetInvoiceItemID: variant;
    function GetOrderCustomerID: variant;
    procedure FilterChange;
    procedure DisableFilter;
    {procedure AddInvoiceItem(Sender: TObject);
    procedure EditInvoiceItem(Sender: TObject);
    procedure RemoveInvoiceItem(Sender: TObject);}
    //procedure PayInvoice(Sender: TObject);
    procedure DoNewInvoice(Sender: TObject);
    procedure DoDeleteInvoice(Sender: TObject);
    procedure DoEditInvoice(Sender: TObject);
    procedure InstantUpdateDetails;
    procedure InvoiceTimerTimer(Sender: TObject);
    procedure DoPrintInvoiceForm(Sender: TObject);
    procedure DoPrintInvoiceReport(Sender: TObject);
    procedure GoToOrder(Sender: TObject);
    procedure SettingsChanged; override;
    //procedure InvStateChange(Sender: TObject);
  public
    constructor Create(_Entity: TEntity);
    destructor Destroy; override;
    function Visible: boolean; override;
    procedure EditCurrent;
    procedure DeleteCurrent(Confirm: boolean);
    function CreateFrame(Owner: TComponent): TBaseFrame; override;
    procedure Activate; override;
    //procedure LoadSettings(AppStorage: TjvCustomAppStorage); override;
    //procedure SaveSettings(AppStorage: TjvCustomAppStorage); override;
    procedure RefreshData; override;
    procedure NewInvoice(CurCustomer: integer); // счет для заказчика
    procedure EditInvoice(InvoiceID, InvoiceItemID: integer);
    function GetToolbar: TjvSpeedbar; override;

    property Frame: TInvoicesFrame read GetFrame;
    property Invoices: TInvoices read GetInvoices;
    // возвращает текущий Invoices.Items.KeyValue, открывая Items, если надо
    property InvoiceItemID: variant read GetInvoiceItemID;
    // возвращает текущий Invoices.Items.OrderCustomerID, открывая Items, если надо
    property OrderCustomerID: variant read GetOrderCustomerID;
    //property AfterScrollID: TNotifyHandlerID read FAfterScrollID;
    // TODO: потом надо убрать это все отсюда проперти не нужны
    // Эти два назначаются извне
    property AfterScrollID2: TNotifyHandlerID read FAfterScrollID2 write FAfterScrollID2;
    property OpenID: TNotifyHandlerID read FOpenID write FOpenID;
  end;

implementation

uses Variants, DB, DateUtils,

  CalcUtils, RDialogs, PmDatabase, PmAppController, PmInvoiceForm, PmInvoiceItemForm,
  DicObj, StdDic, RDBUtils, PmInvoiceItems, PmInvoiceExistForm, MainFilter,
  CalcSettings, PmActions, PmScriptManager, PmInvoiceDocController;

constructor TInvoiceController.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  FFilter := TInvoicesFilterObj.Create;
  Invoices.Criteria := FFilter as TInvoicesFilterObj;
  FFilter.RestoreFilter(TSettingsManager.Instance.Storage, iniFilter + FEntity.InternalName);
  FCaption := 'Счета';
  FAfterScrollID := FEntity.AfterScrollNotifier.RegisterHandler(UpdateDetails);

  TMainActions.GetAction(TInvoiceActions.Edit).OnExecute := DoEditInvoice;
  TMainActions.GetAction(TInvoiceActions.New).OnExecute := DoNewInvoice;
  TMainActions.GetAction(TInvoiceActions.Delete).OnExecute := DoDeleteInvoice;
  TMainActions.GetAction(TInvoiceActions.PrintForm).OnExecute := DoPrintInvoiceForm;
  TMainActions.GetAction(TInvoiceActions.PrintReport).OnExecute := DoPrintInvoiceReport;
end;

destructor TInvoiceController.Destroy;
begin
  FEntity.AfterScrollNotifier.UnregisterHandler(FAfterScrollID);
  //FCustomerOrders.Free;
  inherited;
end;

function TInvoiceController.Visible: boolean;
begin
  Result := true;
end;

procedure TInvoiceController.SettingsChanged;
begin
  AppController.SetPaging(Invoices, not Options.ShowTotalInvoices);
end;

procedure TInvoiceController.DeleteCurrent(Confirm: boolean);
var
  OK: boolean;
begin
  if not Invoices.IsEmpty then
  begin
    if Confirm then
      OK := RusMessageDlg('Удалить счет № ' + VarToStr(Invoices.InvoiceNum)
        + ' "' + Invoices.PayTypeName + '"?', mtConfirmation, mbYesNoCancel, 0) = mrYes
    else
      OK := true;

    if OK then
    begin
      Invoices.DeleteAndApply;
    end;
  end;
end;

function TInvoiceController.CreateFrame(Owner: TComponent): TBaseFrame;
begin
  FFrame := TInvoicesFrame.Create(Owner, Invoices);

  FFrame.OnFilterChange := FilterChange;
  FFrame.OnDisableFilter := DisableFilter;
  FFrame.OnHideFilter := AppController.HideFilter;

  {TInvoicesFrame(FFrame).OnAddItem := AddInvoiceItem;
  TInvoicesFrame(FFrame).OnEditItem := EditInvoiceItem;
  TInvoicesFrame(FFrame).OnRemoveItem := RemoveInvoiceItem;}
  TInvoicesFrame(FFrame).OnEditInvoice := DoEditInvoice;
  InvoiceTimer := TInvoicesFrame(FFrame).InvoiceTimer;
  InvoiceTimer.OnTimer := InvoiceTimerTimer;

  Result := FFrame;
end;

procedure TInvoiceController.Activate;
var
  Save_Cursor: TCursor;
begin
  // не обновлять если уже открыт
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

{procedure TInvoiceView.LoadSettings(AppStorage: TjvCustomAppStorage);
begin
  inherited LoadSettings(AppStorage);
  if FFrame <> nil then // на всякий аварийный
    TInvoicesFrame(FFrame).LoadSettings;
end;

procedure TInvoiceView.SaveSettings(AppStorage: TjvCustomAppStorage);
begin
  inherited SaveSettings(AppStorage); // сохраняет фильтр!
  if FFrame <> nil then // на всякий аварийный
    TInvoicesFrame(FFrame).SaveSettings;
end;}

function TInvoiceController.GetFrame: TInvoicesFrame;
begin
  Result := TInvoicesFrame(FFrame);
end;

procedure TInvoiceController.RefreshData;
begin
  inherited;
  //Invoices.Reload;
end;

procedure TInvoiceController.UpdateDetails(Sender: TObject);
begin
  //InstantUpdateDetails;
  // reset timer for detailed view
  {if InvoiceTimer.Enabled then
    InvoiceTimer.Enabled := false;
  InvoiceTimer.Enabled := true;}
end;

procedure TInvoiceController.InvoiceTimerTimer(Sender: TObject);
begin
  if Invoices.Active and Database.Connected then
  begin
    //InvoiceTimer.Enabled := false;
    InstantUpdateDetails;
  end;
end;

procedure TInvoiceController.InstantUpdateDetails;
begin
  InvoiceTimer.Enabled := false;
  Invoices.OpenInvoiceItems;
end;

function TInvoiceController.GetInvoices: TInvoices;
begin
  Result := Entity as TInvoices;
end;

procedure TInvoiceController.FilterChange;
begin
  RefreshData;
end;

procedure TInvoiceController.DisableFilter;
begin

end;

procedure TInvoiceController.DoNewInvoice(Sender: TObject);
begin
  NewInvoice(0);
end;

procedure TInvoiceController.DoDeleteInvoice(Sender: TObject);
begin
  DeleteCurrent(true);
end;

procedure TInvoiceController.NewInvoice(CurCustomer: integer);
begin
  Invoices.Append;
  TInvoiceDocController.SetDefaultPayType(Invoices);
  if CurCustomer <> 0 then
    Invoices.CustomerID := CurCustomer;
  Invoices.InvoiceDate := Now;
  if TInvoiceDocController.EditInvoiceForm(Invoices) then
  begin
    try
      Invoices.ApplyUpdates;
      Invoices.Reload;
    except
      Invoices.CancelUpdates;
      raise;
    end;
  end
  else
    Invoices.CancelUpdates;
end;

procedure TInvoiceController.DoPrintInvoiceForm(Sender: TObject);
begin
  ScriptManager.ExecOrderEvent(nil, TScriptManager.PrintInvoiceForm);
end;

procedure TInvoiceController.DoPrintInvoiceReport(Sender: TObject);
begin
  Invoices.FetchAllRecords;
  ScriptManager.ExecOrderEvent(nil, TScriptManager.PrintInvoiceReport);
end;

{procedure TInvoiceView.CheckInvoiceNumber(var Cancel, AddToExisting: boolean);
var
  InvoiceIDs: TIntArray;
begin
  // Проверяем, есть ли уже такой номер счета
  InvoiceIDs := Invoices.FindByInvoiceNum(Invoices.InvoiceNum,
    YearOf(Invoices.InvoiceDate), Invoices.KeyValue, null);
  AddToExisting := Length(InvoiceIDS) = 0;
  if not AddToExisting then
    Cancel := not ShowInvoiceExistForm(Invoices.InvoiceNum, AddToExisting);
end;}

procedure TInvoiceController.EditInvoice(InvoiceID, InvoiceItemID: integer);
var
  NewInvoices: TInvoices;
  NewFilterObj: TInvoicesFilterObj;
  InvYear: integer;
  Found: boolean;
begin
  Found := false;
  if not Invoices.Locate(InvoiceID) then
  begin
    // если не нашли сразу, то определяем год и заменяем текущую выборку в счетах
    // создаем временный объект счетов
    NewInvoices := TInvoices.Create;
    try
      NewFilterObj := TInvoicesFilterObj.Create;
      try
        NewInvoices.Criteria := NewFilterObj;
        NewFilterObj.InvoiceID := InvoiceID;
        NewInvoices.Reload;
        if NewInvoices.IsEmpty then
          RusMessageDlg('Счет не найден', mtError, [mbOk], 0)
        else
        begin
          InvYear := YearOf(NewInvoices.InvoiceDate);
          // устанавливаем условие фильтрации
          Invoices.Criteria.DisableFilter;
          Invoices.Criteria.cbDateTypeIndex := 0;
          Invoices.Criteria.cbMonthYearChecked := true;
          Invoices.Criteria.rbYearChecked := true;
          Invoices.Criteria.cbMonthChecked := false;
          Invoices.Criteria.YearValue := InvYear;
          Invoices.Reload;
          if not Invoices.Locate(InvoiceID) then
            RusMessageDlg('Счет не найден', mtError, [mbOk], 0)
          else
            Found := true;
        end;
      finally
        NewFilterObj.Free;
      end;
    finally
      NewInvoices.Free;
    end;
    //RusMessageDlg('Счет не найден', mtError, [mbOk], 0);
  end
  else
    Found := true;

  if Found then
  begin
    {InstantUpdateDetails;
    if not Invoices.Items.Locate(InvoiceItemID) then
      RusMessageDlg('Позиция счета не найдена', mtError, [mbOk], 0)
    else
      EditInvoiceItem(nil);}
    EditCurrent;
  end;
end;

procedure TInvoiceController.EditCurrent;
begin
  if not Invoices.IsEmpty then
  begin
    InstantUpdateDetails;
    if TInvoiceDocController.EditInvoiceForm(Invoices) then
    begin
      try
        Invoices.ApplyUpdates;
        Invoices.Reload;
      except
        Invoices.CancelUpdates;
        raise;
      end;
    end
    else
      Invoices.CancelUpdates;
  end;
end;

{procedure TInvoiceView.InvStateChange(Sender: TObject);
var
  ds: TDataSet;
begin
  ds := Invoices.Items.DataSet;
  if ds.State = dsBrowse then
    RusMessageDlg('dsBrowse', mtInformation, [mbOk], 0);
end;}

procedure TInvoiceController.DoEditInvoice(Sender: TObject);
begin
  EditCurrent;
end;

function TInvoiceController.GetToolbar: TjvSpeedbar;
begin
  if FToolbarFrame = nil then
    FToolbarFrame := TInvoicesToolbar.Create(nil);
  Result := FToolbarFrame.Toolbar;
end;

// переход на выбранный заказ
procedure TInvoiceController.GoToOrder(Sender: TObject);
begin
  if not Invoices.Items.IsEmpty then
  begin
    AppController.EditWorkOrder(Invoices.Items.OrderID);
  end;
end;

function TInvoiceController.GetInvoiceItemID: variant;
begin
  InstantUpdateDetails;
  Result := Invoices.Items.KeyValue;
end;

function TInvoiceController.GetOrderCustomerID: variant;
begin
  InstantUpdateDetails;
  Result := Invoices.Items.OrderCustomerID;
end;

end.
