unit fMatRequestFilterFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, JvImageList, JvExControls, JvxCheckListBox,
  StdCtrls, JvDBLookup, Mask, JvExMask, JvToolEdit, JvExStdCtrls, JvEdit,
  JvValidateEdit, JvgGroupBox, Buttons, ExtCtrls,

  fBaseFilter, PmEntity, DBCtrlsEh, DB;

type
  TMatRequestFilterFrame = class(TBaseFilterFrame)
    gbSupplier: TJvgGroupBox;
    btSupplierSelect: TSpeedButton;
    lkSupplier: TJvDBLookupCombo;
    gbMatCat: TJvgGroupBox;
    cbMatCat: TComboBox;
    gbMatGroup: TJvgGroupBox;
    boxMatGroup: TJvxCheckListBox;
    dsSupplier: TDataSource;
    cbSupplierInvert: TCheckBox;
    procedure btSupplierSelectClick(Sender: TObject);
    procedure gbSupplierClick(Sender: TObject);
    procedure lkSupplierChange(Sender: TObject);
    procedure lkSupplierGetImage(Sender: TObject; IsEmpty: Boolean;
      var Graphic: TGraphic; var TextMargin: Integer);
    procedure cbMatCatClick(Sender: TObject);
    procedure gbMatGroupClick(Sender: TObject);
  private
    FMatCats: TStringList;
  protected
    function SupportsOrderState: boolean; override;
    function SupportsPayState: boolean; override;
    procedure DoRestoreControls; override;
    procedure DoSaveControls; override;
    procedure EnableDBControls; override;
    procedure DisableDBControls; override;
    procedure FillMatCats;
    procedure DoOnCfgChanged(Sender: TObject); override;
    procedure FillMatGroupBox;
  public
    constructor Create(Owner: TComponent); override;
    procedure Activate; override;
    destructor Destroy; override;
    function GetDateList: TStringList; override;
  end;

implementation

uses fMainFilter, PmContragentListForm, PmContragent, MainData, ExHandler,
  MainFilter, PmContragentPainter, PmConfigManager, DicObj, RDbUtils, CalcUtils;

{$R *.dfm}

var
  MaterialDateList: TStringList;

constructor TMatRequestFilterFrame.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  FillMatCats;
end;

destructor TMatRequestFilterFrame.Destroy;
begin
  FreeAndNil(FMatCats);
  inherited;
end;

procedure TMatRequestFilterFrame.DoOnCfgChanged(Sender: TObject);
begin
  inherited;
  FillMatCats;
end;

function TMatRequestFilterFrame.SupportsOrderState: boolean;
begin
  Result := true;
end;

function TMatRequestFilterFrame.SupportsPayState: boolean;
begin
  Result := false;
end;

procedure TMatRequestFilterFrame.btSupplierSelectClick(Sender: TObject);
var
  i, c: integer;
begin
  i := custError;
  if VarIsNull(lkSupplier.KeyValue) then
    c := TContragents.NoNameKey
  else
    c := lkSupplier.KeyValue;
  try
    i := ExecContragentSelect(Suppliers, {CurCustomer} c, {SelectMode=} true);
  except end;
  // custNoName надо обрабатывать иначе ?
  if (i <> custError) and (i <> custNoName) and (i <> custCancel) then
    lkSupplier.KeyValue := i;
end;

procedure TMatRequestFilterFrame.gbMatGroupClick(Sender: TObject);
begin
  boxMatGroup.Enabled := not gbMatGroup.Collapsed and gbMatGroup.Enabled;
  if not gbMatGroup.Collapsed then
  begin
    boxMatGroup.Font.Color := clWindowText;
    AdjustGroupBoxHeight(gbMatGroup, boxMatGroup);
  end
  else
    boxMatGroup.Font.Color := clGrayText;
  ApplyFilter;
end;

procedure TMatRequestFilterFrame.gbSupplierClick(Sender: TObject);
begin
  if FilterControlsInUpdate then Exit;
  FilterControlsInUpdate := true;
  try
    if not gbSupplier.Collapsed then
    begin
      try
        Suppliers.Open;
      except on E: Exception do
        begin
          gbSupplier.Collapsed := true;
          ExceptionHandler.Raise_(E);
        end;
      end;
      lkSupplier.Enabled := true;
      btSupplierSelect.Enabled := true;
      if Suppliers.IsEmpty then
        lkSupplier.KeyValue := TContragents.NoNameKey
      else
      try
        lkSupplier.KeyValue := GetCustomerKey;
      except
        lkSupplier.KeyValue := TContragents.NoNameKey
      end;
    end
    else
    begin
      lkSupplier.Enabled := false;
      btSupplierSelect.Enabled := false;
    end;
  finally
    FilterControlsInUpdate := false;
  end;
  ApplyFilter;
end;

procedure TMatRequestFilterFrame.lkSupplierChange(Sender: TObject);
begin
  ApplyFilter;
end;

procedure TMatRequestFilterFrame.lkSupplierGetImage(Sender: TObject;
  IsEmpty: Boolean; var Graphic: TGraphic; var TextMargin: Integer);
begin
  CustomerPainter.JvDbLookupComboGetImage(lcCust, IsEmpty, Graphic, TextMargin);
end;

procedure TMatRequestFilterFrame.Activate;
begin
  inherited;
  gbProcessState.Visible := false;
  gbPayState.Visible := false;
end;

procedure TMatRequestFilterFrame.DoRestoreControls;
var
  i, c: integer;
  Found: boolean;
begin
  inherited;

  gbCust.Collapsed := not (FilterObj as TMaterialFilterObj).SupplierChecked;
  gbSupplierClick(nil);
  if (FilterObj as TMaterialFilterObj).SupplierKeyValue > 0 then
    lkSupplier.KeyValue := (FilterObj as TMaterialFilterObj).SupplierKeyValue;
  cbSupplierInvert.Checked := (FilterObj as TMaterialFilterObj).SupplierInvert;

  // группа материалов
  gbMatGroup.Collapsed := not (FilterObj as TMaterialFilterObj).MatGroupChecked;
  FillMatGroupBox;

  // категория материала
  gbMatCat.Collapsed := not (FilterObj as TMaterialFilterObj).MatCatChecked;
  c := (FilterObj as TMaterialFilterObj).MatCatCode;
  Found := false;
  for i := 0 to Pred(FMatCats.Count) do
    if integer(FMatCats.Objects[i]) = c then
    begin
      Found := true;
      break;
    end;
  if Found and (i < cbMatCat.Items.Count) then
    cbMatCat.ItemIndex := i;
end;

procedure TMatRequestFilterFrame.EnableDBControls;
begin
  inherited;
  {if lkSupplier.LookupSource <> dm.dsSupplier then
    lkSupplier.LookupSource := dm.dsSupplier;}
  if dsSupplier.DataSet <> Suppliers.DataSet then
    dsSupplier.DataSet := Suppliers.DataSet;
  Suppliers.Open;
end;

procedure TMatRequestFilterFrame.DisableDBControls;
begin
  inherited;
  lkSupplier.LookupSource := nil;
end;

procedure TMatRequestFilterFrame.FillMatCats;
var
  de: TDictionary;
begin
  // Заполняем список категорий материалов
  if FMatCats <> nil then
    FreeAndNil(FMatCats);
  FMatCats := TStringList.Create;

  de := TConfigManager.Instance.StandardDics.deMatCats;
  de.DicItems.First;
  while not de.DicItems.Eof do
  begin
    if de.CurrentEnabled then
      FMatCats.AddObject(NvlString(de.CurrentValue[1]), pointer(de.CurrentCode));
    de.DicItems.Next;
  end;
  cbMatCat.Items.Assign(FMatCats);
end;

procedure TMatRequestFilterFrame.DoSaveControls;
var
  Codes: TIntArray;
begin
  inherited;
  // поставщик
  (FilterObj as TMaterialFilterObj).SupplierChecked := not gbSupplier.Collapsed;
  (FilterObj as TMaterialFilterObj).SupplierKeyValue := NvlInteger(lkSupplier.KeyValue);
  (FilterObj as TMaterialFilterObj).SupplierInvert := cbSupplierInvert.Checked;

  // группа материалов
  (FilterObj as TMaterialFilterObj).MatGroupChecked := not gbMatGroup.Collapsed;
  SaveCheckedStateValues(Codes, boxMatGroup);
  (FilterObj as TMaterialFilterObj).MatGroupCodes := Codes;

  // категория материала
  (FilterObj as TMaterialFilterObj).MatCatChecked := not gbMatCat.Collapsed;
  if cbMatCat.ItemIndex >= 0 then
    (FilterObj as TMaterialFilterObj).MatCatCode := integer(FMatCats.Objects[cbMatCat.ItemIndex])
  else
    (FilterObj as TMaterialFilterObj).MatCatCode := 0;
end;

procedure TMatRequestFilterFrame.cbMatCatClick(Sender: TObject);
begin
  if (cbMatCat.ItemIndex >= 0) then
    ApplyFilter
  else
    SaveControls;
end;

function TMatRequestFilterFrame.GetDateList: TStringList;
begin
  Result := MaterialDateList;
end;

procedure TMatRequestFilterFrame.FillMatGroupBox;
var
  i: integer;
  MatGroupCodes{, AllMatGroupCodes}: TIntArray;
  de: TDictionary;
begin
  boxMatGroup.Clear;
  MatGroupCodes := (FilterObj as TMaterialFilterObj).MatGroupCodes;
  //AllMatGroupCodes := (FilterObj as TMaterialFilterObj).AllMatGroupCodes;
  // Заполняем список именами групп материалов, давая каждому
  // в качестве объекта его ключ.
  de := TConfigManager.Instance.StandardDics.deMatGroups;
  i := 0;
  de.DicItems.First;
  while not de.DicItems.eof do
  begin
    if de.CurrentEnabled then
    begin
      boxMatGroup.Items.AddObject(de.CurrentName, TObject(de.CurrentCode));
      // ставим галочки
      if IntInArray(de.CurrentCode, MatGroupCodes) then
        boxMatGroup.Checked[i] := true;
      Inc(i);
    end;
    de.DicItems.Next;
  end;
  boxMatGroup.Height := boxMatGroup.ItemHeight * boxMatGroup.Items.Count;
  AdjustGroupBoxHeight(gbMatGroup, boxMatGroup);
end;

initialization

MaterialDateList := TStringList.Create;
MaterialDateList.Add('Создания заказа');
MaterialDateList.Add('Плановая дата поставки');
MaterialDateList.Add('Фактическая дата поставки');
MaterialDateList.Add('Дата оплаты');

//InvoicesDateList.Add('Изменения счета');
//InvoicesDateList.Add('Фактического завершения');
//InvoicesDateList.Add('Закрытия заказа');
//InvoicesDateList.Add('Последней оплаты заказа');

finalization

MaterialDateList.Free;

end.
