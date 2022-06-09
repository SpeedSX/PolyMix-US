unit PmShipmentDocController;

interface

uses Classes, Variants,

  PmShipmentDoc, PmShipment, PmCustomerOrders, PmShipmentDocForm, PmShipmentForm;

type
  // редактирование накладной отгрузки
  TShipmentDocController = class
  private
    FShipDoc: TShipmentDoc;   // накладная для редактирования
    FShipDetails: TShipment;  //  отгрузки, входящие в накладную
    FCustomerOrders: TCustomerInvoiceOrders;
    procedure EditShipmentItem(Sender: TObject);
    procedure AddShipmentItem(Sender: TObject);
    procedure RemoveShipmentItem(Sender: TObject);
    function AppendShipment(_ShipmentEntity: TShipment): integer;
  public
    OrderID, OrderTotalNumberShipped, OrderTirazz: integer;
    OrderNumber, CustomerID: integer;
    OrderComment: string;
    // ShipmentDocID = 0 если новая накладная
    function EditShipmentDoc(ShipmentDocID: integer): boolean;
    class function OpenCustomerOrders(_CustomerID: integer): TCustomerInvoiceOrders;
    class function OpenShipmentDetailsEntity(ShipmentDocID: integer): TShipment;
    class function OpenShipmentDocEntity(DocID: integer): TShipmentDoc;
  end;

implementation

uses SysUtils, Controls, Dialogs, RDialogs, PmDatabase, MainFilter, RDBUtils, PmAccessManager;

// Добавить заказ для отгрузки в редактируемую накладную
procedure TShipmentDocController.AddShipmentItem(Sender: TObject);
var
  TotalShipped: integer;
begin
  TotalShipped := AppendShipment(FShipDetails);
  FShipDetails.ShipmentDocID := FShipDoc.KeyValue;
  if not ExecNewShipmentForm(FShipDetails, FCustomerOrders,
     TotalShipped, FShipDetails.ProductNumber) then
    FShipDetails.DataSet.Cancel;
end;

procedure TShipmentDocController.EditShipmentItem(Sender: TObject);
begin
  if not FShipDetails.IsEmpty then
    if not ExecEditShipmentForm(FShipDetails, FCustomerOrders,
        FShipDetails.TotalNumberShipped - FShipDetails.NumberToShip, FShipDetails.ProductNumber) then
      FShipDetails.DataSet.Cancel;
end;

procedure TShipmentDocController.RemoveShipmentItem(Sender: TObject);
begin
  if not FShipDetails.IsEmpty
    and (RusMessageDlg('Вы действительно хотите удалить запись об отгрузке?',
              mtConfirmation, mbYesNoCancel, 0) = mrYes) then
    FShipDetails.Delete;
end;

// Возвращает общее отгруженное кол-во
function TShipmentDocController.AppendShipment(_ShipmentEntity: TShipment): integer;
begin
  Result := OrderTotalNumberShipped;
  //if TotalShipped < Order.Tirazz then
  //begin
    _ShipmentEntity.Append;
    _ShipmentEntity.OrderID := OrderID;
    _ShipmentEntity.OrderNumber := OrderNumber;
    _ShipmentEntity.ProductNumber := OrderTirazz;
    //_ShipmentEntity.ShipmentDate := Now;
    _ShipmentEntity.ItemText := OrderComment;
    if Result < OrderTirazz then
      _ShipmentEntity.NumberToShip := OrderTirazz - Result
    else
      _ShipmentEntity.NumberToShip := 0;
end;

function TShipmentDocController.EditShipmentDoc(ShipmentDocID: integer): boolean;
var
  TotalShipped, NewDocID: integer;
begin
    FShipDoc := nil;
    FShipDetails := nil;
    FCustomerOrders := nil;
    NewDocID := ShipmentDocID;
    Result := false;
    try
      FShipDoc := OpenShipmentDocEntity(ShipmentDocID);
      FShipDetails := OpenShipmentDetailsEntity(ShipmentDocID);
      // новый документ отгрузки
      if ShipmentDocID = 0 then
      begin
        FShipDoc.Append;
        FShipDoc.ShipmentDate := Now;
        FShipDoc.CustomerID := CustomerID;
        FShipDoc.ShipmentDocNum := OrderNumber;
        FShipDoc.WhoOutUserId := AccessManager.CurUser.ID;
        TotalShipped := AppendShipment(FShipDetails);
        FShipDetails.ShipmentDocID := FShipDoc.KeyValue;
      end;
      FCustomerOrders := OpenCustomerOrders(CustomerID);
      if ExecEditShipmentDocForm(FShipDoc, FShipDetails,
        AddShipmentItem, EditShipmentItem, RemoveShipmentItem) then
        //FOrderShipment.TotalNumberShipped - FOrderShipment.NumberToShip, Order.Tirazz) then
      begin
          FShipDoc.WhoOut := AccessManager.GetUserName(FShipDoc.WhoOutUserId);

          if not Database.InTransaction then
            Database.BeginTrans;
          try
            if ShipmentDocID = 0 then
              NewDocID := FShipDoc.KeyValue; // временный ключ
            if FShipDoc.ApplyUpdates then
            begin
              FShipDetails.DataSet.First;
              // при добавлении нового документа надо обновить реальный ключ в дочерних записях
              if ShipmentDocID = 0 then
                while not FShipDetails.DataSet.Eof do
                begin
                  //if FShipDetails.ShipmentDocID = CurrentDocID then
                    FShipDetails.ShipmentDocID := FShipDoc.ItemIds.GetRealItemID(NewDocID, true);
                  FShipDetails.DataSet.Next;
                end;
              FShipDetails.ApplyUpdates;
              Database.CommitTrans;
              Result := true;
            end;
          except
            if Database.InTransaction then
              Database.RollbackTrans;
            raise;
          end;
        //end;
      end
      {else
        FOrderShipment.DataSet.Cancel};
    finally
      FreeAndNil(FShipDoc);
      if FShipDetails <> nil then
      begin
        FShipDetails.Criteria.Free;
        FShipDetails.Criteria := nil;
        FreeAndNil(FShipDetails);
      end;
      FreeAndNil(FCustomerOrders);
    end;
end;

class function TShipmentDocController.OpenShipmentDocEntity(DocID: integer): TShipmentDoc;
var
  ShipDoc: TShipmentDoc;
  Criteria: TShipmentDocFilterCriteria;
begin
  ShipDoc := TShipmentDoc.Create;
  //Criteria.DocNum := SourceShipment.ShipmentDocNum;
  Criteria.DocID := DocID;
  ShipDoc.Criteria := Criteria;
  ShipDoc.Open;
  Result := ShipDoc;
end;

class function TShipmentDocController.OpenShipmentDetailsEntity(ShipmentDocID: integer): TShipment;
var
  ShipDet: TShipment;
  Criteria: TShipmentFilterObj;
begin
  ShipDet := TShipment.Create;
  Criteria := TShipmentFilterObj.Create;
  Criteria.ShipmentDocID := NvlInteger(ShipmentDocID);
  ShipDet.Criteria := Criteria;
  // Если есть номер накладной, то включаем туда все отгрузки с этим номеров,
  // иначе берем просто одну строку.
  {if not VarIsNull(ShipmentDoc.ShipmentDocNum) and not VarIsEmpty(SourceShipment.ShipmentDocNum) then
  begin
    Criteria.ShipmentDocNum := SourceShipment.ShipmentDocNum;
    Criteria.ShipmentDate := SourceShipment.ShipmentDate;
  end
  else
    Criteria.ShipmentID := SourceShipment.KeyValue;}
  //ShipmentDoc.Items := ShipDet;
  ShipDet.DetailMode := ShipmentDetailMode_Simple;
  ShipDet.Open;
  Result := ShipDet;
end;

class function TShipmentDocController.OpenCustomerOrders(_CustomerID: integer): TCustomerInvoiceOrders;
var
  FCustomerOrders: TCustomerInvoiceOrders;
  Criteria: TCustomerInvoiceOrdersCriteria;
begin
  FCustomerOrders := TCustomerInvoiceOrders.Create;
  Criteria.CustomerID := _CustomerID;
  Criteria.ForShipment := true;
  Criteria.NotPaidOnly := false;
  Criteria.NotInvoicedOnly := false;
  Criteria.NotShippedOnly := false;
  FCustomerOrders.Criteria := Criteria;
  FCustomerOrders.Open;
  Result := FCustomerOrders;
end;

end.
