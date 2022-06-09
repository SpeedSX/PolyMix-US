unit fMatRequestFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, MyDBGridEh,
  JvFormPlacement, DB, Menus, JvJCLUtils,

  fBaseFrame, fBaseFilter, PmMatRequest, PmEntity, CalcUtils, DicObj,
  DBGridEhGrouping;

type
  TMatRequestFrame = class(TBaseFrame)
    dgMatRequests: TMyDBGridEh;
    Panel7: TPanel;
    Label5: TLabel;
    Panel8: TPanel;
    sbLocateOrder: TSpeedButton;
    btXLMaterials: TBitBtn;
    btEditMaterial: TBitBtn;
    dsParam1: TDataSource;
    dsParam2: TDataSource;
    dsParam3: TDataSource;
    pmDic: TPopupMenu;
    procedure dgMatRequestsDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure dgMatRequestsGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dgMatRequestsDblClick(Sender: TObject);
    procedure dgMatRequestsTitleBtnClick(Sender: TObject; ACol: Integer;
      Column: TColumnEh);
    procedure dgMatRequestsPlanReceiveDateUpdateData(Sender: TObject;
      var Text: string; var Value: Variant; var UseText, Handled: Boolean);
    procedure dgMatRequestsFactReceiveDateUpdateData(Sender: TObject;
      var Text: string; var Value: Variant; var UseText, Handled: Boolean);
    procedure dgMatRequestsAllUpdateData(Sender: TObject; var Text: string;
      var Value: Variant; var UseText, Handled: Boolean);
    procedure FactParamSelected(Sender: TObject);
    procedure pmDicPopup(Sender: TObject);
    procedure dgMatRequestsColumns25UpdateData(Sender: TObject;
      var Text: string; var Value: Variant; var UseText, Handled: Boolean);
  private
    //FMatRequests: TMaterialRequests;
    FOnUpdateData: TNotifyEvent;
    FOnSetSortOrder: TStringNotifyEvent;
  protected
    procedure DateUpdateData(FieldName: string; var Text: string;
      var Value: Variant; var Handled: Boolean);
    function MatRequests: TMaterialRequests;
     procedure FillKeys(Col: TColumnEh; Dic: TDictionary);
     procedure FillKeys2(Dic: TDictionary; MatTypeName: string);
  public
    constructor Create(Owner: TComponent; _MatRequests: TEntity); override;
    procedure SaveSettings; override;
    procedure LoadSettings; override;
    function CreateFilterFrame: TBaseFilterFrame; override;
    procedure SettingsChanged; override;
    property OnUpdateData: TNotifyEvent read FOnUpdateData write FOnUpdateData;
    property OnSetSortOrder: TStringNotifyEvent read FOnSetSortOrder write FOnSetSortOrder;
  end;

implementation

uses fMatRequestFilterFrame, CalcSettings, PmOrder, PmActions,
  PmMaterials, PmConfigManager, PmAccessManager;

{$R *.dfm}

constructor TMatRequestFrame.Create(Owner: TComponent; _MatRequests: TEntity);
begin
  inherited Create(Owner, _MatRequests{'MatRequest'});
  //FMatRequests := _MatRequests;

  FilterObject := MatRequests.Criteria;
  FilterFrame.Entity := MatRequests;

  dgMatRequests.DataSource := MatRequests.DataSource;

  SettingsChanged;
end;

function TMatRequestFrame.CreateFilterFrame: TBaseFilterFrame;
begin
  Result := TMatRequestFilterFrame.Create(Self);
end;

procedure TMatRequestFrame.dgMatRequestsAllUpdateData(Sender: TObject;
  var Text: string; var Value: Variant; var UseText, Handled: Boolean);
var
  Field: TField;
  {Col: TColumnEh;
  I: Integer;}
begin
  // Присвоение данных обрабатываем сами, т.к. это надо сделать перед вызовом OnUpdateData
  {for I := 0 to dgMatRequests.Columns.Count - 1 do
  begin
    Col := dgMatRequests.Columns[I];
    if Col.Index = dgMatRequests.Col then

  end;
  Field := dgMatRequests.Columns[dgMatRequests.Col].Field;}
  Field := dgMatRequests.SelectedField;
  if Field <> nil then
  begin
    if Text = '' then
      Field.Value := null
    else if Field.FieldKind = fkLookup then
      Field.DataSet[Field.KeyFields] := Value  // тут упрощенно
    else
      Field.Value := Value;
    if Assigned(FOnUpdateData) then
      FOnUpdateData(Self);
    Handled := true;
  end;
end;

procedure TMatRequestFrame.dgMatRequestsColumns25UpdateData(Sender: TObject;
  var Text: string; var Value: Variant; var UseText, Handled: Boolean);
begin
  DateUpdateData(TMaterials.F_PayDate, Text, Value, Handled);
end;

procedure TMatRequestFrame.dgMatRequestsDblClick(Sender: TObject);
begin
  TMainActions.GetAction(TMaterialRequestActions.Edit).Execute;
end;

procedure TMatRequestFrame.dgMatRequestsDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  if (CompareText(Column.FieldName, TOrder.F_OrderState) = 0) and (Column.Field <> nil) then
  begin
    DrawOrderState(Sender as TOrderGridClass, Column, Rect);
  end;
end;

procedure TMatRequestFrame.dgMatRequestsGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  //if (Column.Field <> nil) and Column.Field.DataSet then
  // Выделяем отмененные заявки
  if not MatRequests.IsEmpty and MatRequests.RequestModified then
  begin
    Background := clRed;
    AFont.Color := clWhite;
  end;
end;

procedure TMatRequestFrame.dgMatRequestsTitleBtnClick(Sender: TObject;
  ACol: Integer; Column: TColumnEh);
begin
  if Column.Field.Origin <> '' then
    FOnSetSortOrder(Column.Field.Origin)
  else
    FOnSetSortOrder(Column.Field.FieldName);
end;

procedure TMatRequestFrame.SaveSettings;
begin
  inherited;
  TSettingsManager.Instance.SaveGridLayout(dgMatRequests, 'MatRequest_MatRequest');
  TSettingsManager.Instance.Storage.WriteInteger('MatRequest_RowHeight', dgMatRequests.RowHeight);
end;

procedure TMatRequestFrame.LoadSettings;
begin
  {FUpdatingControls := true;
  try}
    inherited;
    TSettingsManager.Instance.LoadGridLayout(dgMatRequests, 'MatRequest_MatRequest');
    dgMatRequests.RowHeight := TSettingsManager.Instance.Storage.ReadInteger('MatRequest_RowHeight', dgMatRequests.RowHeight);
  {finally
    FUpdatingControls := false;
  end;}
end;

function TMatRequestFrame.MatRequests: TMaterialRequests;
begin
  Result := Entity as TMaterialRequests;
end;

procedure TMatRequestFrame.pmDicPopup(Sender: TObject);
var
  Field: TField;
  Col: TColumnEh;
begin
  Field := dgMatRequests.SelectedField;
  Col := dgMatRequests.FieldColumns[Field.FieldName];
  if Field.FieldName = TMaterials.F_FactParam1 then
    FillKeys2(TConfigManager.Instance.StandardDics.deParam1, MatRequests.MatTypeName)
  else if Field.FieldName = TMaterials.F_FactParam2 then
    FillKeys2(TConfigManager.Instance.StandardDics.deParam2, MatRequests.MatTypeName)
  else if Field.FieldName = TMaterials.F_FactParam3 then
    FillKeys2(TConfigManager.Instance.StandardDics.deParam3, MatRequests.MatTypeName)
  else
    pmDic.Items.Clear;
end;

procedure TMatRequestFrame.DateUpdateData(FieldName: string; var Text: string;
  var Value: Variant; var Handled: Boolean);
begin
  MatRequests.DataSet.Edit;
  if Text = '' then
    MatRequests.DataSet[FieldName] := null
  else
    MatRequests.DataSet[FieldName] := Value;
  MatRequests.DataSet.Post;
  Handled := true;
  if Assigned(FOnUpdateData) then
    FOnUpdateData(Self);
end;

procedure TMatRequestFrame.dgMatRequestsPlanReceiveDateUpdateData(Sender: TObject;
  var Text: string; var Value: Variant; var UseText, Handled: Boolean);
begin
  DateUpdateData(TMaterials.F_PlanReceiveDate, Text, Value, Handled);
end;

procedure TMatRequestFrame.dgMatRequestsFactReceiveDateUpdateData(Sender: TObject;
  var Text: string; var Value: Variant; var UseText, Handled: Boolean);
begin
  DateUpdateData(TMaterials.F_FactReceiveDate, Text, Value, Handled);
end;

procedure TMatRequestFrame.FactParamSelected(Sender: TObject);
var
  //Code: integer;
  Field: TField;
begin
  //Code := (Sender as TMenuItem).Tag;
  Field := dgMatRequests.SelectedField;
  //if Field.FieldName = TMaterials.F_FactParam1 then
  MatRequests.DataSet.Edit;
  Field.Value := ReplaceString((Sender as TMenuItem).Caption, '&', '');
  MatRequests.DataSet.Post;
  if Assigned(FOnUpdateData) then
    FOnUpdateData(Self);
end;

procedure TMatRequestFrame.FillKeys2(Dic: TDictionary; MatTypeName: string);
var
  Code: integer;
  mi: TMenuItem;
begin
  Code := Dic.ItemCode[MatTypeName];
  Dic.DicItems.First;
  pmDic.Items.Clear;
  while not Dic.DicItems.Eof do
  begin
    if Dic.CurrentEnabled and (Dic.DicItems['ParentCode'] = Code) then
    begin
      mi := TMenuItem.Create(nil);
      mi.Caption := Dic.CurrentName;
      mi.Tag := Dic.CurrentCode;
      mi.OnClick := FactParamSelected;
      pmDic.Items.Add(mi);
    end;
    Dic.DicItems.Next;
  end;

  {Col.KeyList.Clear;
  Col.PickList.Clear;
  Dic.DicItems.First;
  while not Dic.DicItems.Eof do
  begin
    if Dic.CurrentEnabled and (Dic.DicItems['ParentCode'] = Code) then
    begin
      Col.KeyList.Add(Dic.CurrentName);
      Col.PickList.Add(Dic.CurrentName);
    end;
    Dic.DicItems.Next;
  end;}
end;

procedure TMatRequestFrame.FillKeys(Col: TColumnEh; Dic: TDictionary);
begin
  Dic.DicItems.First;
  while not Dic.DicItems.Eof do
  begin
    if Dic.CurrentEnabled then
    begin
      Col.KeyList.Add(Dic.CurrentName);
      Col.PickList.Add(Dic.CurrentName);
    end;
    Dic.DicItems.Next;
  end;
end;

procedure TMatRequestFrame.SettingsChanged;
begin
  {dsParam1.DataSet := TConfigManager.Instance.StandardDics.deParam1.DicItems;
  dsParam2.DataSet := TConfigManager.Instance.StandardDics.deParam2.DicItems;
  dsParam3.DataSet := TConfigManager.Instance.StandardDics.deParam3.DicItems;}

  {FillKeys(dgMatRequests.FieldColumns[TMaterials.F_FactParam1], TConfigManager.Instance.StandardDics.deParam1);
  FillKeys(dgMatRequests.FieldColumns[TMaterials.F_FactParam2], TConfigManager.Instance.StandardDics.deParam2);
  FillKeys(dgMatRequests.FieldColumns[TMaterials.F_FactParam3], TConfigManager.Instance.StandardDics.deParam3);}

  dgMatRequests.Font.Name := Options.ScheduleFontName;
  dgMatRequests.Font.Size := Options.ScheduleFontSize;
  if not Options.EditMatRequest then
    dgMatRequests.Options := dgMatRequests.Options + [dgRowSelect]
  else
  begin
    dgMatRequests.AllowedOperations := [alopUpdateEh];
    dgMatRequests.Options := dgMatRequests.Options + [dgEditing];
    dgMatRequests.FieldColumns[TMaterials.F_SupplierName].AlwaysShowEditButton := true;
    dgMatRequests.FieldColumns[TMaterials.F_PlanReceiveDate].AlwaysShowEditButton := true;
    dgMatRequests.FieldColumns[TMaterials.F_FactReceiveDate].AlwaysShowEditButton := true;
    dgMatRequests.FieldColumns[TMaterials.F_PayDate].AlwaysShowEditButton := AccessManager.CurUser.UpdateMatPayDate;
    dgMatRequests.FieldColumns[TMaterials.F_PayDate].ReadOnly := not AccessManager.CurUser.UpdateMatPayDate;
    dgMatRequests.FieldColumns[TOrder.F_Comment].Visible := false;
  end;
  dgMatRequests.SumList.Active := Options.ShowTotalMatRequests;
  if Options.ShowTotalMatRequests then
    dgMatRequests.FooterRowCount := 1
  else
    dgMatRequests.FooterRowCount := 0;
end;

end.
