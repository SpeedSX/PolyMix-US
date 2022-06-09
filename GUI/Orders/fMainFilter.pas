unit fMainFilter;

{$I Calc.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvExControls, JvComponent, JvgCheckBox, JvDBLookup, StdCtrls,
  ComCtrls, JvExStdCtrls, JvEdit, JvValidateEdit, Buttons, JvgGroupBox,
  ExtCtrls, JvExExtCtrls, Mask, JvExMask, JvToolEdit, jvAppStorage,
  JvxCheckListBox, JvImageList, DB, JvgTypes, ImgList,

  MainFilter, DicObj, CalcSettings, PmEntSettings,
  PmEntity, PmOrder, fBaseFilter, DBCtrlsEh, JvExComCtrls, JvUpDown;

type
  TFilterFrame = class(TBaseFilterFrame)
    gbCustomerCreator: TJvgGroupBox;
    cbCustomerCreatorName: TComboBox;
    procedure cbCustomerCreatorClick(Sender: TObject);
  private
    //FcdCur: TDataSet;
    function GetOrder: TOrder;
  protected
    //function CurOrderKindIsDraft: boolean; override;
    function SupportsOrderState: boolean; override;
    function SupportsPayState: boolean; override;
    function SupportsExternalId: boolean; override;
    function GetCustomerKey: Integer; override;
    function GetDateList: TStringList; override;
    //procedure DoOnEntityChange; override;
    //procedure ChangeOrderKind;
    procedure SetEntity(_Entity: TEntity); override;
    procedure DoRestoreControls; override;
    procedure DoSaveControls; override;
    procedure DisableFilter; override;
  public
    class var
      MainDateList: TStringList;
    property Order: TOrder read GetOrder;
    procedure Activate; override;
  end;

implementation

uses Math, JvJVCLUtils,

  ExHandler, CalcUtils, PmAccessManager;

{$R *.dfm}

{procedure TFilterFrame.DoOnEntityChange;
begin
  //FcdCur := Entity.DataSet;
  UpdateGroupsEnabledState;
  ChangeOrderKind;
  EnableDBControls;
end;}

procedure TFilterFrame.SetEntity(_Entity: TEntity);
var
  CheckedOrderKinds: TIntArray;
begin
  if ControlsRestored then
  begin
    SaveCheckedStateValues(CheckedOrderKinds, boxOrderKind);
    FilterObj.SetCheckedOrderKindValues(Entity, CheckedOrderKinds);
  end;

  FEntity := _Entity;

  FillOrderKindBox;
  UpdateGroupsEnabledState;
  EnableDBControls;
end;

(*procedure TFilterFrame.ChangeOrderKind;
var
  CheckedOrderKinds: TIntArray;
begin
  if ControlsRestored then
  begin
    SaveCheckedStateValues(CheckedOrderKinds, boxOrderKind);
    FilterObj.SetCheckedOrderKindValues(Entity, CheckedOrderKinds);
    FillOrderKindBox;
  end;
end;*)

function TFilterFrame.GetOrder: TOrder;
begin
  Result := Entity as TOrder;
end;

{function TFilterFrame.CurOrderKindIsDraft: boolean;
begin
  if Order = nil then
    Result := true
  else
    Result := Order is TDraftOrder;
end;}

function TFilterFrame.SupportsOrderState: boolean;
begin
  Result := Order is TWorkOrder;
end;

function TFilterFrame.SupportsPayState: boolean;
begin
  Result := Order is TWorkOrder;
end;

function TFilterFrame.SupportsExternalId: boolean;
begin
  Result := Order is TWorkOrder and EntSettings.ShowExternalId;
end;

procedure TFilterFrame.cbCustomerCreatorClick(Sender: TObject);
begin
  if (cbCustomerCreatorName.ItemIndex <> -1) then
    ApplyFilter
  else
    SaveControls;
end;

function TFilterFrame.GetCustomerKey: Integer;
begin
  Result := Order.CustomerID;
end;

function TFilterFrame.GetDateList: TStringList;
begin
  Result := MainDateList;
end;

procedure TFilterFrame.Activate;
begin
  inherited;
  gbProcessState.Visible := false;
end;

procedure TFilterFrame.DoRestoreControls;
var
  Name: string;
  I: Integer;
  ui: TUserInfo;
begin
  gbCustomerCreator.Collapsed := not (FilterObj as TOrderFilterObj).cbCustomerCreatorChecked;
  if (UsersCopy <> nil) then
  begin
    cbCustomerCreatorName.Items.Assign(UsersCopy);
    Name := (FilterObj as TOrderFilterObj).CustomerCreatorName;
    if Name <> '' then
    begin
      for I := 0 to UsersCopy.Count - 1 do
      begin
        ui := UsersCopy.Objects[i] as TUserInfo;
        if ui.Login = Name then
        begin
          cbCustomerCreatorName.ItemIndex := i;
          break;
        end;
      end;
    end;
  end;
  inherited;
end;

procedure TFilterFrame.DoSaveControls;
begin
  (FilterObj as TOrderFilterObj).cbCustomerCreatorChecked := not gbCustomerCreator.Collapsed;
  if cbCustomerCreatorName.Enabled then
  try
    if (UsersCopy <> nil) and (cbCustomerCreatorName.ItemIndex <> -1) then
      (FilterObj as TOrderFilterObj).CustomerCreatorName := (UsersCopy.Objects[cbCustomerCreatorName.ItemIndex] as TUserInfo).Login
    else
      (FilterObj as TOrderFilterObj).CustomerCreatorName := '';
  except (FilterObj as TOrderFilterObj).CustomerCreatorName := ''; end;

  inherited;
end;

procedure TFilterFrame.DisableFilter;
begin
  inherited;
  gbCreator.Collapsed := true;
end;

initialization

TFilterFrame.MainDateList := TStringList.Create;
TFilterFrame.MainDateList.Add('Создания заказа');
TFilterFrame.MainDateList.Add('Изменения заказа');
TFilterFrame.MainDateList.Add('Планового завершения');
TFilterFrame.MainDateList.Add('Фактического завершения');
TFilterFrame.MainDateList.Add('Планового начала работ');
TFilterFrame.MainDateList.Add('Фактического начала работ');
TFilterFrame.MainDateList.Add('Закрытия заказа');
TFilterFrame.MainDateList.Add('Последней оплаты заказа');
TFilterFrame.MainDateList.Add('Любой оплаты заказа');

finalization

TFilterFrame.MainDateList.Free;

end.
