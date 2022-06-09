unit PmContragentPainter;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, GridsEh, StdCtrls, db, ComCtrls, ExtCtrls, DBGridEh, PmUtils;

type
  TContragentPainter = class(TObject)
  private
    function GetSyncImage(SyncState: integer): TBitmap;
  public
    procedure AddControl(Control: TWinControl); virtual;
  end;

  TCustomerPainter = class(TContragentPainter)
  private
    bmpWorkCust, bmpCalcCust, bmpFilterWorkCalcCust, bmpFilterCalcCust,
    bmpFilterWorkCust, bmpSyncState: TBitmap;
  public
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure ComboBoxDrawItem(Control: TWinControl; Index: Integer;
      R: TRect; State: TOwnerDrawState);
    procedure JvDBLookupComboGetImage(Sender: TObject; IsEmpty: Boolean;
       var Graphic: TGraphic; var TextMargin: Integer);
    procedure AddControl(Control: TWinControl); override;
    constructor Create;
    destructor Destroy; override;
    function GetWorkCustomerBitmap: TBitmap;
  end;

var
  CustomerPainter: TCustomerPainter;
  ContractorPainter: TContragentPainter;
  SupplierPainter: TContragentPainter;

const
  SYNC_SOURCE_CODE = 9;

implementation

{$R CUST.RES}

uses CalcUtils, JvJVCLUtils, JvDBLookup, RDBUtils, PmEntSettings, ExHandler,
  Variants;

procedure TContragentPainter.AddControl(Control: TWinControl);
begin
end;

function TContragentPainter.GetSyncImage(SyncState: integer): TBitmap;
begin
  if (SyncState = SyncState_Syncronized) then
    Result := bmpSyncOK
  else if (SyncState = SyncState_New) then
    Result := bmpNew
  else if (SyncState = SyncState_SyncFailed) then
    Result := bmpSyncFailed
  else if (SyncState = SyncState_Old) then
    Result := nil
  else
    ExceptionHandler.Raise_('Некорректное состояние синхронизации: ' + VarToStr(SyncState));
end;

procedure TCustomerPainter.DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
var
  //i: integer;
  Bmp: TBitmap;
  ds: TDataSet;
  f: TField;
begin
  if (CompareText(Column.FieldName, 'IsWork') = 0) and (Column.Field <> nil) then
  try
    (Sender as TGridClass).Canvas.FillRect(Rect);

    Bmp := nil;

    if EntSettings.ShowSyncInfo then
    begin
      ds := Column.Field.DataSet;
      f := ds.FieldByName('SyncState');
      if f.IsNull then
        Bmp := bmpCalcCust
      else
        Bmp := GetSyncImage(f.Value);
    end;

    if Bmp = nil then
    begin
      if not Column.Field.IsNull and Column.Field.Value then
        Bmp := bmpWorkCust
      else
        Bmp := bmpCalcCust;
    end;

    DrawBitmapTransparent((Sender as TGridClass).Canvas,
      (Rect.Right + Rect.Left - Bmp.Width) div 2 + 1,
      (Rect.Top + Rect.Bottom - Bmp.Height) div 2, Bmp, clFuchsia);
  except end;
end;

procedure TCustomerPainter.ComboBoxDrawItem(Control: TWinControl; Index: Integer;
  R: TRect; State: TOwnerDrawState);
var
  aBmp: TBitmap;
  aColor: TColor;
  aWidth: Integer;
begin
  with Control as TComboBox do
  begin
    aColor := Brush.Color;
    Brush.Color := Color;
    Canvas.Pen.Color := Font.Color;
    Canvas.FillRect(R);
    Inc(R.Top);
    // TODO: Здесь не рисуется состояние синхронизации
    if Index = 0 then aBmp := bmpFilterWorkCalcCust
    else if Index = 1 then aBmp := bmpFilterWorkCust
    else aBmp := bmpFilterCalcCust;
    aWidth := aBmp.Width;
    Canvas.BrushCopy(Bounds(R.Left + 2, (R.Top + R.Bottom - aBmp.Height) div 2,
       aBmp.Width, aBmp.Height), aBmp, Bounds(0, 0, aBmp.Width, aBmp.Height), clFuchsia);
    R.Left := R.Left + aWidth + 6;
    Brush.Color := aColor;
    R.Right := R.Left + Canvas.TextWidth((Control as TComboBox).Items[Index]) + 6;
    Canvas.FillRect(R);
    OffsetRect(R, 2, 0);
    DrawText(Canvas.Handle, PChar((Control as TComboBox).Items[Index]), -1, R, DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
  end;
end;

procedure TCustomerPainter.AddControl(Control: TWinControl);
begin
  if Control is TDbGridEh then
    (Control as TDBGridEh).OnDrawColumnCell := DBGridDrawColumnCell
  else if Control is TComboBox then begin
    (Control as TComboBox).OnDrawItem := ComboBoxDrawItem;
    (Control as TComboBox).Style := csOwnerDrawFixed;
    (Control as TComboBox).ItemHeight := 17;
  end else if Control is TjvDBLookupCombo then begin
    (Control as TjvDBLookupCombo).OnGetImage := JvDBLookupComboGetImage;
  end;
end;

procedure TCustomerPainter.JvDBLookupComboGetImage(Sender: TObject; IsEmpty: Boolean;
  var Graphic: TGraphic; var TextMargin: Integer);
var
  f: TField;
  ds: TDataSet;
begin
  if not IsEmpty and (Sender is TjvDBLookupCombo) then
  begin
    if (Sender as TjvDBLookupCombo).LookupSource <> nil then
    begin
      ds := (Sender as TjvDBLookupCombo).LookupSource.DataSet;
      //f := ds.FindField('SourceCode');
      if EntSettings.ShowSyncInfo then
        f := ds.FindField('SyncState')
      else
        f := nil;
      if (f <> nil) and (NvlInteger(f.Value) <> SyncState_Old) {(NvlInteger(f.Value) = SYNC_SOURCE_CODE)} then
        Graphic := GetSyncImage(f.Value)//bmpSyncState
      else
      begin
        f := ds.FieldByName('IsWork');
        if not f.IsNull then
        begin
          if f.Value then Graphic := bmpWorkCust
          else Graphic := bmpCalcCust;
        end;
      end;
      TextMargin := 18;
    end;
  end;
end;

constructor TCustomerPainter.Create;
begin
  inherited Create;
  bmpWorkCust := TBitmap.Create;
  bmpWorkCust.LoadFromResourceName(hInstance, 'WORKCUSTBMP');
  bmpCalcCust := TBitmap.Create;
  bmpCalcCust.LoadFromResourceName(hInstance, 'CALCCUSTBMP');
  bmpFilterWorkCalcCust := TBitmap.Create;
  bmpFilterWorkCalcCust.LoadFromResourceName(hInstance, 'CALCWORKCUSTBMP');
  bmpFilterCalcCust := TBitmap.Create;
  bmpFilterCalcCust.LoadFromResourceName(hInstance, 'CALCCUSTSBMP');
  bmpFilterWorkCust := TBitmap.Create;
  bmpFilterWorkCust.LoadFromResourceName(hInstance, 'WORKCUSTSBMP');
  bmpSyncState := TBitmap.Create;
  bmpSyncState.LoadFromResourceName(hInstance, 'SYNCSTATE_OK');
end;

destructor TCustomerPainter.Destroy;
begin
  bmpWorkCust.Free;
  bmpCalcCust.Free;
  bmpFilterWorkCalcCust.Free;
  bmpFilterCalcCust.Free;
  bmpFilterWorkCust.Free;
  bmpSyncState.Free;
  inherited Destroy;
end;

function TCustomerPainter.GetWorkCustomerBitmap: TBitmap;
begin
  Result := bmpWorkCust;
end;

initialization
  CustomerPainter := TCustomerPainter.Create;
  ContractorPainter := TContragentPainter.Create;
  SupplierPainter := TContragentPainter.Create;

finalization
  if CustomerPainter <> nil then FreeAndNil(CustomerPainter);
  if ContractorPainter <> nil then FreeAndNil(ContractorPainter);
  if SupplierPainter <> nil then FreeAndNil(SupplierPainter);

end.
