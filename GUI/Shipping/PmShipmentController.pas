unit PmShipmentController;

interface

uses Classes, Controls, Forms, SysUtils, JvAppStorage, Dialogs, ExtCtrls,
  JvSpeedBar,

  NotifyEvent, fBaseFrame, PmEntity, PmEntityController, fShipmentFrame, PmShipment,
  PmCustomerOrders, fShipmentToolbar, PmShipmentDoc;

type
  TShipmentController = class(TEntityController)
  private
    //FCustomerOrders: TCustomerInvoiceOrders;
    FToolbarFrame: TShipmentToolbar;
    function GetFrame: TShipmentFrame;
    function GetShipment: TShipment;
    procedure FilterChange;
    procedure DisableFilter;
    procedure DoNewShipment(Sender: TObject);
    procedure DoDeleteShipment(Sender: TObject);
    procedure DoEditShipment(Sender: TObject);
    procedure DoPrintShipmentReport(Sender: TObject);
    procedure DoPrintShipmentForm(Sender: TObject);
    procedure GoToOrder(Sender: TObject);
    //procedure EditShipment(ShipmentID: integer);
    procedure DoOpenOrder(Sender: TObject);
    procedure DoEditShipmentDoc(ShipmentDocID: integer);
  public
    constructor Create(_Entity: TEntity); override;
    destructor Destroy; override;
    function Visible: boolean; override;
    procedure EditCurrent;
    procedure DeleteCurrent(Confirm: boolean);
    function CreateFrame(Owner: TComponent): TBaseFrame; override;
    procedure Activate; override;
    //procedure LoadSettings(AppStorage: TjvCustomAppStorage); override;
    //procedure SaveSettings(AppStorage: TjvCustomAppStorage); override;
    procedure RefreshData; override;
    function GetToolbar: TjvSpeedbar; override;
    {class function OpenShipmentDocEntity(DocID: integer): TShipmentDoc;
    class function OpenShipmentDetailsEntity(ShipmentDoc: TShipmentDoc): TShipment;
    class function OpenCustomerOrders(_CustomerID: integer): TCustomerInvoiceOrders;}

    property Frame: TShipmentFrame read GetFrame;
    property Shipment: TShipment read GetShipment;
  end;

implementation

uses Variants, DB, DateUtils, 

  CalcUtils, RDialogs, PmDatabase, PmAppController,
  DicObj, RDBUtils, MainFilter,
  CalcSettings, PmActions, PmScriptManager, PmShipmentDocController;

constructor TShipmentController.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  FFilter := TShipmentFilterObj.Create;
  Shipment.Criteria := FFilter as TShipmentFilterObj;
  FFilter.RestoreFilter(TSettingsManager.Instance.Storage, iniFilter + FEntity.InternalName);
  FCaption := 'Отгрузка';

  TMainActions.GetAction(TShipmentActions.Edit).OnExecute := DoEditShipment;
  TMainActions.GetAction(TShipmentActions.New).OnExecute := DoNewShipment;
  TMainActions.GetAction(TShipmentActions.Delete).OnExecute := DoDeleteShipment;
  TMainActions.GetAction(TShipmentActions.PrintReport).OnExecute := DoPrintShipmentReport;
  TMainActions.GetAction(TShipmentActions.PrintForm).OnExecute := DoPrintShipmentForm;
  TMainActions.GetAction(TShipmentActions.OpenOrder).OnExecute := DoOpenOrder;
end;

destructor TShipmentController.Destroy;
begin
  inherited;
end;

function TShipmentController.Visible: boolean;
begin
  Result := true;
end;

procedure TShipmentController.DeleteCurrent(Confirm: boolean);
var
  CurKey, NextKey: variant;
  OK: boolean;
begin
  if not Shipment.IsEmpty and (not Shipment.IsTotal or Shipment.IsFirstRow) then
  begin
    if Confirm then
      OK := RusMessageDlg('Удалить запись об отгрузке?', mtConfirmation, mbYesNoCancel, 0) = mrYes
    else
      OK := true;

    if OK then
    begin
      Shipment.DeleteAndApply;
    end;
  end;
end;

function TShipmentController.CreateFrame(Owner: TComponent): TBaseFrame;
begin
  FFrame := TShipmentFrame.Create(Owner, Shipment);

  FFrame.OnFilterChange := FilterChange;
  FFrame.OnDisableFilter := DisableFilter;
  FFrame.OnHideFilter := AppController.HideFilter;

  TShipmentFrame(FFrame).OnEditShipment := DoEditShipment;

  Result := FFrame;
end;

procedure TShipmentController.Activate;
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

{procedure TShipmentView.LoadSettings(AppStorage: TjvCustomAppStorage);
begin
  inherited LoadSettings(AppStorage);
  if FFrame <> nil then // на всякий аварийный
    TShipmentFrame(FFrame).LoadSettings;
end;

procedure TShipmentView.SaveSettings(AppStorage: TjvCustomAppStorage);
begin
  inherited SaveSettings(AppStorage); // сохраняет фильтр!
  if FFrame <> nil then // на всякий аварийный
    TShipmentFrame(FFrame).SaveSettings;
end;}

function TShipmentController.GetFrame: TShipmentFrame;
begin
  Result := TShipmentFrame(FFrame);
end;

procedure TShipmentController.RefreshData;
begin
  inherited;
  //Shipment.Reload;
end;

function TShipmentController.GetShipment: TShipment;
begin
  Result := Entity as TShipment;
end;

procedure TShipmentController.FilterChange;
begin
  RefreshData;
end;

procedure TShipmentController.DisableFilter;
begin

end;

procedure TShipmentController.DoNewShipment(Sender: TObject);
begin
  DoEditShipmentDoc(0);
end;

procedure TShipmentController.DoDeleteShipment(Sender: TObject);
begin
  DeleteCurrent(true);
end;

procedure TShipmentController.DoEditShipmentDoc(ShipmentDocID: integer);
var
  //CurOrdNum, CurOrdID, CurTirazz, CurTotalShipped: integer;
  //CurComment: string;
  //FCustomerOrders: TCustomerInvoiceOrders;
  Cnt: TShipmentDocController;
begin
  if not Shipment.IsEmpty then
  begin
    Cnt := TShipmentDocController.Create;
    try
      Cnt.OrderID := Shipment.OrderID;
      Cnt.OrderNumber := Shipment.OrderNumber;
      Cnt.OrderTirazz := Shipment.ProductNumber;
      Cnt.OrderTotalNumberShipped := Shipment.TotalNumberShipped;
      Cnt.OrderComment := Shipment.Comment;
      Cnt.CustomerID := Shipment.CustomerID;
      if Cnt.EditShipmentDoc(ShipmentDocID) then
      begin
        Shipment.ApplyUpdates;
        //Shipment.Reload;
      end;
    finally
      Cnt.Free;
    end;
    ///if CurTirazz > CurTotalShipped then begin

    {Shipment.Append;
    Shipment.ShipmentDate := Now;
    Shipment.OrderID := CurOrdID;
    Shipment.OrderNumber := CurOrdNum;
    if CurTirazz > CurTotalShipped then
      Shipment.NumberToShip := CurTirazz - CurTotalShipped
    else
      Shipment.NumberToShip := 0; 
    Shipment.ItemText := CurComment;
    FCustomerOrders := nil;
    try
      //FCustomerOrders := OpenCustomerOrders(Shipment);
      if ExecEditShipmentDocForm(FShipDoc, Shipment, FCustomerOrders, CurTotalShipped, Shipment.ProductNumber) then
      begin
        try
          Shipment.ApplyUpdates;
          //Shipment.Reload;
        except
          Shipment.DataSet.Cancel;
          raise;
        end;
      end
      else
        Shipment.DataSet.Cancel;
    finally
      FreeAndNil(FCustomerOrders);
    end; }
  end;
end;

procedure TShipmentController.DoPrintShipmentReport(Sender: TObject);
begin
  ScriptManager.ExecOrderEvent(nil, TScriptManager.PrintShipmentReport);
end;

procedure TShipmentController.DoPrintShipmentForm(Sender: TObject);
begin
  ScriptManager.ExecOrderEvent(nil, TScriptManager.PrintShipmentForm);
end;

{function TShipmentView.EditShipmentForm: boolean;
begin
  Result := ExecEditShipmentForm(Shipment, nil,
    Shipment.TotalNumberShipped - Shipment.NumberToShip, Shipment.ProductNumber);
end;}

(*procedure TShipmentView.EditShipment(ShipmentID: integer);
var
  NewShipment: TShipment;
  NewFilterObj: TShipmentFilterObj;
  ShipYear: integer;
  Found: boolean;
begin
  Found := false;
  if not Shipment.Locate(ShipmentID) then
  begin
    // если не нашли сразу, то определяем год и заменяем текущую выборку в счетах
    // создаем временный объект счетов
    NewShipment := TShipment.Create;
    try
      NewFilterObj := TShipmentFilterObj.Create;
      try
        NewShipment.Criteria := NewFilterObj;
        NewFilterObj.ShipmentID := ShipmentID;
        NewShipment.Reload;
        if NewShipment.IsEmpty then
          RusMessageDlg('Отгрузка не найдена', mtError, [mbOk], 0)
        else
        begin
          ShipYear := YearOf(NewShipment.ShipmentDate);
          // устанавливаем условие фильтрации
          Shipment.Criteria.DisableFilter;
          Shipment.Criteria.cbDateTypeIndex := 0;
          Shipment.Criteria.cbMonthYearChecked := true;
          Shipment.Criteria.rbYearChecked := true;
          Shipment.Criteria.cbMonthChecked := false;
          Shipment.Criteria.YearValue := ShipYear;
          Shipment.Reload;
          if not Shipment.Locate(ShipmentID) then
            RusMessageDlg('Отгрузка не найдена', mtError, [mbOk], 0)
          else
            Found := true;
        end;
      finally
        NewFilterObj.Free;
      end;
    finally
      NewShipment.Free;
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
end;*)

procedure TShipmentController.EditCurrent;
begin
  if not Shipment.IsEmpty and (not Shipment.IsTotal or Shipment.IsFirstRow) then
  begin
    {if Shipment.ItemText = '' then
      Shipment.ItemText := Shipment.Comment;  // Для старых отгрузок}
    DoEditShipmentDoc(Shipment.ShipmentDocID);
    {if EditShipmentForm then
    begin
      try
        if Shipment.HasChanges then
        begin
          Shipment.ApplyUpdates;
          //Shipment.Reload;
        end;
      except
        Shipment.CancelUpdates;
        raise;
      end;
    end
    else
      Shipment.DataSet.Cancel;}
  end;
end;

procedure TShipmentController.DoEditShipment(Sender: TObject);
begin
  EditCurrent;
end;

function TShipmentController.GetToolbar: TjvSpeedbar;
begin
  if FToolbarFrame = nil then
    FToolbarFrame := TShipmentToolbar.Create(nil);
  Result := FToolbarFrame.Toolbar;
end;

// переход на выбранный заказ
procedure TShipmentController.GoToOrder(Sender: TObject);
begin
  if not Shipment.IsEmpty then
  begin
    AppController.EditWorkOrder(Shipment.OrderID);
  end;
end;

procedure TShipmentController.DoOpenOrder(Sender: TObject);
var
  OrderID: variant;
begin
  OrderID := Shipment.OrderID;
  if not VarIsNull(OrderID) then
  begin
    AppController.EditWorkOrder(OrderID);
  end;
end;

end.
