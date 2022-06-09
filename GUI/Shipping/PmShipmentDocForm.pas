unit PmShipmentDocForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseEditForm, JvComponentBase, JvFormPlacement, StdCtrls, Mask,
  DBCtrls, JvExMask, JvToolEdit, JvMaskEdit, JvCheckedMaskEdit,
  JvDatePickerEdit, JvDBDatePickerEdit, Buttons, GridsEh, DBGridEh, MyDBGridEh,

  PmShipment, PmShipmentDoc, DBGridEhGrouping, DBCtrlsEh, DBLookupEh, DB;

type
  TShipmentDocForm = class(TBaseEditForm)
    Label7: TLabel;
    edWhoOut: TDBEdit;
    edWhoIn: TDBEdit;
    Label3: TLabel;
    Label8: TLabel;
    edShipDocNum: TDBEdit;
    deDateOut: TJvDBDatePickerEdit;
    Label2: TLabel;
    Label6: TLabel;
    dgShipment: TMyDBGridEh;
    btNewItem: TBitBtn;
    btEditItem: TBitBtn;
    btDelItem: TBitBtn;
    cbWhoOut: TDBComboBoxEh;
    procedure btNewItemClick(Sender: TObject);
    procedure btEditItemClick(Sender: TObject);
    procedure btDelItemClick(Sender: TObject);
  private
    FShipmentDoc: TShipmentDoc;
    FShipment: TShipment;
    FOnAddItem: TNotifyEvent;
    FOnEditItem: TNotifyEvent;
    FOnRemoveItem: TNotifyEvent;
    FUsers: TStringList;
    FUserIDs: TStringList;
    FOrderKindID: integer;
    procedure SetShipmentDoc(Value: TShipmentDoc);
    procedure SetShipment(Value: TShipment);
  public
    property ShipmentDoc: TShipmentDoc read FShipmentDoc write SetShipmentDoc;
    property Shipment: TShipment read FShipment write SetShipment;
    //property OrderKindID: integer read FOrderKindID write FOrderKindID;
    property OnAddItem: TNotifyEvent read FOnAddItem write FOnAddItem;
    property OnEditItem: TNotifyEvent read FOnEditItem write FOnEditItem;
    property OnRemoveItem: TNotifyEvent read FOnRemoveItem write FOnRemoveItem;
  end;

function ExecEditShipmentDocForm(ShipmentDoc: TShipmentDoc; Shipment: TShipment;
  _OnAddItem, _OnEditItem, _OnRemoveItem: TNotifyEvent): boolean;

implementation

uses PmAccessManager;

{$R *.dfm}

function ExecEditShipmentDocForm(ShipmentDoc: TShipmentDoc; Shipment: TShipment;
  //OrderKindID: integer;
  _OnAddItem, _OnEditItem, _OnRemoveItem: TNotifyEvent): boolean;
var
  ShipmentDocForm: TShipmentDocForm;
begin
  Application.CreateForm(TShipmentDocForm, ShipmentDocForm);
  try
    ShipmentDocForm.ShipmentDoc := ShipmentDoc;
    ShipmentDocForm.Shipment := Shipment;
    //ShipmentDocForm.OrderKindID := OrderKindID;
    ShipmentDocForm.OnAddItem := _OnAddItem;
    ShipmentDocForm.OnEditItem := _OnEditItem;
    ShipmentDocForm.OnRemoveItem := _OnRemoveItem;
    Result := ShipmentDocForm.ShowModal = mrOk;
  finally
    FreeAndNil(ShipmentDocForm);
  end;
end;

procedure TShipmentDocForm.btDelItemClick(Sender: TObject);
begin
  FOnRemoveItem(nil);
end;

procedure TShipmentDocForm.btEditItemClick(Sender: TObject);
begin
  FOnEditItem(nil);
end;

procedure TShipmentDocForm.btNewItemClick(Sender: TObject);
begin
  FOnAddItem(nil);
end;

procedure TShipmentDocForm.SetShipmentDoc(Value: TShipmentDoc);
var
  i: integer;
  ui: TUserInfo;
  PermRec: TUserPermissionInfo;
begin
  FShipmentDoc := Value;
  deDateOut.DataSource := FShipmentDoc.DataSource;
  //edWhoOut.DataSource := FShipmentDoc.DataSource;
  cbWhoOut.DataSource := FShipmentDoc.DataSource;
  edWhoIn.DataSource := FShipmentDoc.DataSource;
  edShipDocNum.DataSource := FShipmentDoc.DataSource;

  if FUsers <> nil then
    FreeAndNil(FUsers);
  FUsers := TStringList.Create;
  if FUserIDs <> nil then
    FreeAndNil(FUserIDs);
  FUserIDs := TStringList.Create;

  for i := 0 to AccessManager.Users.Count - 1 do
  begin
    ui := AccessManager.Users.Objects[i] as TUserInfo;
    //AccessManager.ReadKindPermTo(KindPerm, OrderKindID, ui.ID);
    AccessManager.ReadUserIDPermTo(PermRec, ui.ID);
    if PermRec.AddShipment then
    begin
      FUsers.Add(ui.Name);
      FUserIDs.Add(IntToStr(ui.ID));
    end;
  end;
  cbWhoOut.Items := FUsers;
  cbWhoOut.KeyItems := FUserIDs;

  cbWhoOut.ReadOnly := not AccessManager.CurUser.EditProcCfg; // Если есть админские права
end;

procedure TShipmentDocForm.SetShipment(Value: TShipment);
begin
  FShipment := Value;
  dgShipment.DataSource := FShipment.DataSource;
end;

end.
