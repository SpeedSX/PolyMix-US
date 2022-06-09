unit CalcUtils;

interface

uses JvAppStorage, SysUtils, Classes, Graphics, DBGridEh, MyDBGridEh,
  jvPageList, Types,
  PmUtils;

const
  SEmptyBitmap = 'BMP_EMPTY';
  SHasCommentBitmap = 'BMP_HASCOMMENT';
  SHasJobCommentBitmap = 'BMP_HASJOBCOMMENT';
  SHasAlertBitmap = 'BMP_HASALERT';
  SError16Bitmap = 'BMP_ERROR16';
  SError32Bitmap = 'BMP_ERROR32';
  STick16Bitmap = 'BMP_TICK16';
  SYellowTick16Bitmap = 'BMP_YELLOWTICK16';
  SContractorBitmap = 'BMP_CONTRACTOR';
  SArrowDownBitmap = 'BMP_ARROW_DOWN';

  NumDisplayFmt = '###,###,##0.00';
  NumDisplayFmt4 = '###,###,##0.0000';
  NumEditFmt = '#0.00';
  StdDateFmt = 'dd/mm/yyyy';
  ShortDateFormat2 = 'dd/mm/yy';
  OrderNumDisplayFmt = '00000';

type
  TOrderGridClass = TMyDBGridEh;
  TPageClass = TjvStandardPage;
  TIntArray = array of integer;

  TBooleanEvent = function: boolean of object;
  TIntNotifyEvent = procedure (Value: integer) of object;
  TIntArrayNotifyEvent = procedure (Value: TIntArray) of object;
  TInt2NotifyEvent = procedure (Value1, Value2: integer) of object;
  TBooleanNotifyEvent = function (Sender: TObject): boolean of object;
  TBooleanIntNotifyEvent = function (Value: integer): boolean of object;
  TVariantNotifyEvent = procedure (Value: variant) of object;
  TStringNotifyEvent = procedure (Value: string) of object;

var
  SortDownBmp, SortUpBmp, CheckedBmp, UncheckedBmp, NoCheckBmp: TBitmap;
  PlusBmp, MinusBmp, ClearBmp, RedCheckBmp: TBitmap;
  MakeBmp: TBitmap;
  bmpSyncOK, bmpNew, bmpSyncFailed, bmpNoInvoice, bmpNoInvoiceDis,
  bmpNoInvoiceForIncome, bmpNoShipment, bmpPartialShipment, bmpCompleteShipment,
  bmpShipmentApproved,
  bmpEditLock, bmpMultiInvoice: TBitmap;
  bmpCostProtected: TBitmap;
  bmpContentProtected: TBitmap;
  bmpCostProtected16: TBitmap;
  bmpContentProtected16: TBitmap;
  bmpHasNotes, bmpHasAlert, bmpHasJobNotes: TBitmap;
  bmpError16, bmpError32, bmpTick16, bmpYellowTick16, bmpContractor: TBitmap;
  bmpArrowDown: TBitmap;

// Состояния синхронизации с внешней системой
const
  SyncState_Old = 0;
  SyncState_New = 1;
  SyncState_Syncronized = 2;
  SyncState_SyncFailed = 3;

  ShipmentState_None = 0;
  ShipmentState_Partial = 1;
  ShipmentState_Complete = 2;

// локально-независимый формат даты
function DateToStrMyFmt(ADate: TDateTime): string;
function StrToDateMyFmt(s: string): TDateTime;

// форматирует только время из даты
function ExtractTimeStr(Dt: TDateTime): string;
function RoundByMode(t, USDCrs: extended; n: integer): extended;
procedure SaveOrderColumns(IniF: TJvCustomAppStorage; dg: TOrderGridClass; const KeyName: string);
procedure LoadOrderColumns(IniF: TJvCustomAppStorage; dg: TOrderGridClass; const KeyName: string);
function GetComponentName(_dm: TComponent; BaseName: string): string;
function IntInArray(os: integer; const StateValues: TIntArray): boolean;

// оптимизирует ширину столбцов по содержимому
procedure OptimizeColumns(dg: TDBGridEh);

// Обрезает секунды
function TruncSeconds(_DateTime: TDateTime): TDateTime;

// округляет до двух знаков после запятой
function Round2(f: extended): extended;

// обрезает до двух знаков после запятой
function Trunc2(f: extended): extended;

// рисует состояние оплаты в таблице
procedure DrawPayState(Grid: TOrderGridClass; Column: TColumnEh; const Rect: TRect);

// рисует состояние выполнения заказа в таблице
procedure DrawOrderState(Grid: TOrderGridClass; Column: TColumnEh; const Rect: TRect);

// рисует состояние синхронизации в таблице
procedure DrawSyncState(Grid: TGridClass; Column: TColumnEh; const Rect: TRect);

// возвращает изображение для состояния синхронизации
function GetSyncStateImage(SyncValue: integer): TBitmap;

// рисует состояние отгрузки в таблице
procedure DrawShipmentState(Grid: TOrderGridClass; Column: TColumnEh; const Rect: TRect);

// рисует состояние блокировки в таблице
procedure DrawLockState(Grid: TOrderGridClass; Column: TColumnEh; const Rect: TRect);

// рисует пачку листиков слева в ячейке. Меняет Rect.
procedure DrawManyItemsIcon(Grid: TGridClass; Column: TColumnEh; var Rect: TRect);

// рисует картинку в ячейке с прозрачностью и выравниванием
procedure DrawGridCellBitmap(Canvas: TCanvas; const Rect: TRect; bmp: TBitmap;
  TransColor: TColor; Alignment: TAlignment);

// преобразование записи типа rrggbb в цвет
function MyHexToColor(const AText: string; var Color: TColor): boolean;

implementation

uses JvJCLUtils, JvJVCLUtils, Variants, DB,

  StdDic, PmStates, RDBUtils, CalcSettings, PmEntSettings, PmConfigManager,
  PmOrder;

function DateToStrMyFmt(ADate: TDateTime): string;

  function Int2Str(i: integer): string;
  begin
    Result := IntToStr(i);
    if Length(Result) = 1 then Result := '0' + Result;
  end;

var
  Y, D, M: word;
begin
  DecodeDate(ADate, Y, M, D);
  Result := Int2Str(M) + Int2Str(D) + IntToStr(Y);
end;

function StrToDateMyFmt(s: string): TDateTime;
begin
  Result := NullDate;
  if Length(s) = 8 then
    try
      Result := EncodeDate(StrToInt(Copy(s, 5, 4)), StrToInt(Copy(s, 1, 2)), StrToInt(Copy(s, 3, 2)));
    except end;
end;

function ExtractTimeStr(Dt: TDateTime): string;
var
  fmt: TFormatSettings;
begin
  fmt.LongTimeFormat := 'hh:mm';
  fmt.TimeSeparator := ':';
  fmt.TimeAMString := '';
  fmt.TimePMString := '';
  Result := TimeToStr(Dt, fmt);
end;

function rpow(n, p: integer): extended;
var t: integer;
begin
  if p = 0 then Result := 1
  else begin
    t := n;
    while p > 1 do begin
      t := t * n;
      Dec(p);
    end;
    Result := t;
  end;
end;

// Если USDCrs < 0 , то t - в долларах
function RoundByMode(t, USDCrs: extended; n: integer): extended;
begin
  if UsdCrs > 0 then t := t * USDCrs;
  // Округление по стоимости одного экземпляра (n - тираж)
  if (EntSettings.RoundTotalMode = rndBy1) and (n > 0) and not ((USDCrs <= 0) and not EntSettings.RoundUSD) then begin
    t := Round(t / n * rpow(10, EntSettings.RoundPrecision) + 0.5); // в большую сторону до Precision знаков
    t := Round(t / rpow(10, EntSettings.RoundPrecision - 2) * n) / 100.0;  // общую сумму - до 2 знаков
  end else
  // Округление по десятичным цифрам
  if EntSettings.RoundTotalMode = rndByDig then begin   // Здесь только грн округляем.
    t := Round(t * 100.0 / rpow(10, EntSettings.RoundPrecision) + 0.5);
    t := t * rpow(10, EntSettings.RoundPrecision) / 100.0;
  end
  else
    t := Round2(t); // Иначе - До двух знаков (02.06.2008 - раньше не округлялось)

  Result := t;
end;

procedure LoadOrderColumns(IniF: TJvCustomAppStorage; dg: TOrderGridClass; const KeyName: string);
var
  i: integer;
  s: string;
begin
  if dg <> nil then
  with dg do
    if (Columns <> nil) and (Columns.Count > 0) then
      for i := 0 to Columns.Count - 1 do
        try
          s := 'ColWidth\Col' + IntToStr(i);
          //if IniF.ValueExists(SecName, s) then
            Columns[i].Width := StrToInt(IniF.ReadString(KeyName + s, IntToStr(Columns[i].Width)));
        except end;
end;

procedure SaveOrderColumns(IniF: TJvCustomAppStorage; dg: TOrderGridClass; const KeyName: string);
var i: integer;
begin
  if dg <> nil then
  with dg do
    if (Columns <> nil) and (Columns.Count > 0) then
      for i := 0 to Columns.Count - 1 do
          IniF.WriteInteger(KeyName + 'ColWidth\Col' + IntToStr(i), Columns[i].Width);
end;

function GetComponentName(_dm: TComponent; BaseName: string): string;
var i: integer;
begin
  i := 1;
  while _dm.FindComponent(BaseName + IntToStr(i)) <> nil do
    Inc(i);
  Result := BaseName + IntToStr(i);
end;

function IntInArray(os: integer; const StateValues: TIntArray): boolean;
var
  i: integer;
begin
  Result := false;
  if StateValues = nil then Exit;
  if Length(StateValues) <> 0 then
    for i := 0 to High(StateValues) do
      if StateValues[i] = os then begin
        Result := true;
        Exit;
      end;
end;

procedure OptimizeColumns(dg: TDBGridEh);
var
  ColumnsList: TColumnsEhList;
  I: integer;
begin
  ColumnsList := TColumnsEhList.Create;
  try
    for I := 0 to dg.Columns.Count - 1 do
      if dg.Columns[i].Visible then
        dg.Columns[i].OptimizeWidth;
    //dg.OptimizeColsWidth(ColumnsList);
  finally
    ColumnsList.Free;
  end;
end;

// Обрезает секунды
function TruncSeconds(_DateTime: TDateTime): TDateTime;
var
  Hour, Min, Sec, MSec: word;
begin
  DecodeTime(_DateTime, Hour, Min, Sec, MSec);
  Result := Trunc(_DateTime) + EncodeTime(Hour, Min, 0, 0);
end;

// округляет до двух знаков
function Round2(f: extended): extended;
begin
  Result := Round(f * 100) / 100.0;
end;

function Trunc2(f: extended): extended;
begin
  Result := Trunc(f * 100) / 100.0;
end;

procedure DrawPayState(Grid: TOrderGridClass; Column: TColumnEh; const Rect: TRect);
var
  StateField, InvoiceField: TField;
  i: integer;
  Bmp: TBitmap;
  dePayStates: TStringList;
begin
  //Grid.Canvas.FillRect(Rect);
  StateField := Column.Field;

  if Options.ShowPayState then
  begin
    if StateField.DataSet.Active and not StateField.DataSet.IsEmpty then
    begin
      // Режим автоматического определения состояния оплаты
      if EntSettings.AutoPayState then
      begin
        // Если поле дополнительного состояния пусто, то показываем автоматическое
        if ((NvlInteger(StateField.Value) = 0) or (EntSettings.PayStateMode = AutoPayState_InvoicePosition))
           and (StateField.DataSet.FindField('AutoPayState') <> nil) then
        begin
          StateField := StateField.DataSet.FieldByName('AutoPayState');
          // Рисуем что нету счета, если есть поле HasInvoice и оно false.
          // Или, при наличии настройки, если сумма выставленных счетов меньше стоимости заказа.
          // Только в случае, если состояние определилось автоматически!
          InvoiceField := StateField.DataSet.FindField('HasInvoice');
          if (InvoiceField <> nil) then
          begin
            if not NvlBoolean(InvoiceField.Value)
               or (EntSettings.ShowPartialInvoice
                  and (StateField.DataSet.FindField(TWorkOrder.F_TotalInvoiceCost) <> nil)
                  and (NvlFloat(StateField.DataSet.FieldByName(TWorkOrder.F_TotalInvoiceCost).Value)
                        < NvlFloat(StateField.DataSet.FieldByName(TOrder.F_FinalCostGrn).Value))) then
            begin
              Bmp := bmpNoInvoice;
              DrawBitmapTransparent(Grid.Canvas, (Rect.Right + Rect.Left - Bmp.Width) div 2 + 1,
                                 (Rect.Top + Rect.Bottom - Bmp.Height) div 2, Bmp, clFuchsia);
              Exit;
            end;
          end;
        end;
      end;

      if not StateField.IsNull then
      begin
        // Если есть состояние оплаты с таким кодом, то рисуем соотв. картинку
        // (если она есть)
        dePayStates := TConfigManager.Instance.StandardDics.PayStates;
        i := dePayStates.IndexOf(IntToStr(StateField.AsInteger));
        if (i <> -1) and (dePayStates.Objects[i] <> nil) then
        begin
          if Grid.Enabled then
            Bmp := (dePayStates.Objects[i] as TOrderState).Graphic
          else
            Bmp := (dePayStates.Objects[i] as TOrderState).DisabledGraphic;
          if Bmp <> nil then
            DrawBitmapTransparent(Grid.Canvas, (Rect.Right + Rect.Left - Bmp.Width) div 2 + 1,
                              (Rect.Top + Rect.Bottom - Bmp.Height) div 2, Bmp, clOlive)
          else
            Grid.Canvas.FillRect(Rect);
        end
        else
          Grid.Canvas.FillRect(Rect);
      end
      else
        Grid.Canvas.FillRect(Rect);
    end
    else
      Grid.Canvas.FillRect(Rect);
  end
  else
    Grid.Canvas.FillRect(Rect);
end;

procedure DrawOrderState(Grid: TOrderGridClass; Column: TColumnEh; const Rect: TRect);
var
  i: integer;
  Bmp: TBitmap;
  States: TStringList;
begin
  //Grid.Canvas.FillRect(Rect);
  if Options.ShowOrderState and not Column.Field.IsNull then
  begin
    // Если есть состояние заказа с таким кодом, то рисуем соотв. картинку
    // (если она есть)
    States := TConfigManager.Instance.StandardDics.OrderStates;
    i := States.IndexOf(IntToStr(Column.Field.AsInteger));
    if (i <> -1) and (States.Objects[i] <> nil) then
    begin
      if Grid.Enabled then
        Bmp := (States.Objects[i] as TOrderState).Graphic
      else
        Bmp := (States.Objects[i] as TOrderState).DisabledGraphic;
      if Bmp <> nil then
        DrawBitmapTransparent(Grid.Canvas, (Rect.Right + Rect.Left - Bmp.Width) div 2 + 1,
                          (Rect.Top + Rect.Bottom - Bmp.Height) div 2, Bmp, clOlive)
      else
        Grid.Canvas.FillRect(Rect);
    end
    else
      Grid.Canvas.FillRect(Rect);
  end
  else
    Grid.Canvas.FillRect(Rect);
end;

function GetSyncStateImage(SyncValue: integer): TBitmap;
begin
  if (SyncValue = SyncState_Syncronized) then
    Result := bmpSyncOK
  else if (SyncValue = SyncState_New) then
    Result := bmpNew
  else if (SyncValue = SyncState_SyncFailed) then
    Result := bmpSyncFailed
  else
    Result := nil;
end;

procedure DrawSyncState(Grid: TOrderGridClass; Column: TColumnEh; const Rect: TRect);
var
  Bmp: TBitmap;
begin
  if not Column.Field.IsNull then
  begin
    // рисуем состояние синхронизации
    Bmp := GetSyncStateImage(Column.Field.Value);
    if Bmp <> nil then
      DrawBitmapTransparent(Grid.Canvas,
        (Rect.Right + Rect.Left - bmp.Width) div 2 + 1,
        (Rect.Top + Rect.Bottom - bmp.Height) div 2, bmp, clFuchsia)
    else
      Grid.Canvas.FillRect(Rect);
  end
  else
    Grid.Canvas.FillRect(Rect);
end;

function GetShipmentStateImage(ShipValue: integer; Approved: boolean): TBitmap;
begin
  if (ShipValue = ShipmentState_Complete) then
    Result := bmpCompleteShipment
  else
  if (ShipValue = ShipmentState_None) then
  begin
    if EntSettings.ShipmentApprovement and Approved then
      Result := bmpShipmentApproved
    else
      Result := bmpNoShipment
  end
  else if (ShipValue = ShipmentState_Partial) then
    Result := bmpPartialShipment
  else
    Result := nil;
end;

// рисует состояние отгрузки в таблице
procedure DrawShipmentState(Grid: TOrderGridClass; Column: TColumnEh; const Rect: TRect);
var
  Bmp: TBitmap;
begin
  if not Column.Field.IsNull then
  begin
    // рисуем состояние отгрузки
    Bmp := GetShipmentStateImage(Column.Field.Value, NvlBoolean(Column.Field.DataSet['ShipmentApproved']));
    if Bmp <> nil then
      DrawBitmapTransparent(Grid.Canvas,
        Rect.Left + 1,//(Rect.Right + Rect.Left - bmp.Width) div 2 + 1,
        (Rect.Top + Rect.Bottom - bmp.Height) div 2, bmp, clFuchsia)
    else
      Grid.Canvas.FillRect(Rect);
  end
  else
    Grid.Canvas.FillRect(Rect);
end;

// рисует состояние блокировки в таблице
procedure DrawLockState(Grid: TOrderGridClass; Column: TColumnEh; const Rect: TRect);
var
 bmp: TBitmap;
begin
  if not Column.Field.IsNull then
  begin
    if NvlBoolean(Column.Field.Value) then
      bmp := bmpEditLock
    else if Column.Field.DataSet['ContentProtected'] then
      bmp := bmpContentProtected16
    else if Column.Field.DataSet['CostProtected'] then
      bmp := bmpCostProtected16
    else
    begin
      bmp := nil;
      Grid.Canvas.FillRect(Rect);
    end;             
    if bmp <> nil then
      // рисуем состояние блокировки
      DrawBitmapTransparent(Grid.Canvas,
        (Rect.Right + Rect.Left - bmp.Width) div 2 + 1,
        (Rect.Top + Rect.Bottom - bmp.Height) div 2,
        bmp, clFuchsia)
  end
  else
    Grid.Canvas.FillRect(Rect);
end;

procedure DrawManyItemsIcon(Grid: TGridClass; Column: TColumnEh; var Rect: TRect);
var
  Rect1: TRect;
  Bmp: TBitmap;
begin
  Rect1 := Rect;
  Rect1.Right := Rect1.Left + 18;
  Grid.Canvas.FillRect(Rect1);
  Bmp := bmpMultiInvoice;
  DrawBitmapTransparent(Grid.Canvas, (Rect1.Right + Rect1.Left - Bmp.Width) div 2 + 1,
     (Rect1.Top + Rect1.Bottom - Bmp.Height) div 2, Bmp, clFuchsia);
  Rect.Left := Rect.Left + 18;
end;

procedure DrawGridCellBitmap(Canvas: TCanvas; const Rect: TRect; bmp: TBitmap;
  TransColor: TColor; Alignment: TAlignment);
var
  x: integer;
begin
  if Alignment = taCenter then
    x := (Rect.Right + Rect.Left - bmp.Width) div 2 + 1
  else if Alignment = taLeftJustify then
    x := Rect.Left
  else if Alignment = taRightJustify then
    x := Rect.Right - bmp.Width;

  DrawBitmapTransparent(Canvas, x,
                       (Rect.Top + Rect.Bottom - bmp.Height) div 2, bmp, TransColor);
end;

function MyHexToColor(const AText: string; var Color: TColor): boolean;
begin
  if Length(AText) = 6 then
  begin
    try
      Color := StringToColor('$' + Copy(AText, 5, 2) + Copy(AText, 3, 2) + Copy(AText, 1, 2));
      Result := true;
    except
      Result := false;
    end;
  end
  else
    Result := false;
end;

initialization
  SortDownBmp := TBitmap.Create;
  SortDownBmp.LoadFromResourceName(hInstance, 'SORTDOWN');
  SortUpBmp := TBitmap.Create;
  SortUpBmp.LoadFromResourceName(hInstance, 'SORTUP');
  MinusBmp := TBitmap.Create;
  MinusBmp.LoadFromResourceName(hInstance, 'BTN_DELETE');
  PlusBmp := TBitmap.Create;
  PlusBmp.LoadFromResourceName(hInstance, 'BTN_INSERT');
  ClearBmp := TBitmap.Create;
  ClearBmp.LoadFromResourceName(hInstance, 'BTN_CLEAR');
  CheckedBmp := TBitmap.Create;
  CheckedBmp.LoadFromResourceName(hInstance, 'BOX_CHECKED');
  UncheckedBmp := TBitmap.Create;
  UncheckedBmp.LoadFromResourceName(hInstance, 'BOX_UNCHECKED');
  NoCheckBmp := TBitmap.Create;
  NoCheckBmp.LoadFromResourceName(hInstance, 'BOX_NOCHECK');
  RedCheckBmp := TBitmap.Create;
  RedCheckBmp.LoadFromResourceName(hInstance, 'RED_CHECK');
  bmpSyncOK := TBitmap.Create;
  bmpSyncOK.LoadFromResourceName(hInstance, 'SYNCSTATE_OK');
  bmpNew := TBitmap.Create;
  bmpNew.LoadFromResourceName(hInstance, 'SYNCSTATE_NEW');
  bmpSyncFailed := TBitmap.Create;
  bmpSyncFailed.LoadFromResourceName(hInstance, 'SYNCSTATE_FAILED');
  bmpNoInvoice := TBitmap.Create;
  bmpNoInvoice.LoadFromResourceName(hInstance, 'NO_INVOICE');
  bmpNoInvoiceDis := TBitmap.Create;
  bmpNoInvoiceDis.LoadFromResourceName(hInstance, 'NO_INVOICE_DISABLED');
  bmpNoInvoiceForIncome := TBitmap.Create;
  bmpNoInvoiceForIncome.LoadFromResourceName(hInstance, 'NO_INVOICE_FOR_INCOME');
  bmpNoShipment := TBitmap.Create;
  bmpNoShipment.LoadFromResourceName(hInstance, 'NOSHIPMENT');
  bmpPartialShipment := TBitmap.Create;
  bmpPartialShipment.LoadFromResourceName(hInstance, 'PARTIALSHIPMENT');
  bmpCompleteShipment := TBitmap.Create;
  bmpCompleteShipment.LoadFromResourceName(hInstance, 'COMPLETESHIPMENT');
  bmpShipmentApproved := TBitmap.Create;
  bmpShipmentApproved.LoadFromResourceName(hInstance, 'SHIPMENT_APPROVED');
  bmpEditLock := TBitmap.Create;
  bmpEditLock.LoadFromResourceName(hInstance, 'EDITLOCK');
  bmpMultiInvoice := TBitmap.Create;
  bmpMultiInvoice.LoadFromResourceName(hInstance, 'MULTI_INVOICE');
  bmpCostProtected := TBitmap.Create;         
  bmpCostProtected.LoadFromResourceName(hInstance, 'COSTPROTECTED');
  bmpContentProtected := TBitmap.Create;
  bmpContentProtected.LoadFromResourceName(hInstance, 'CONTENTPROTECTED');
  bmpCostProtected16 := TBitmap.Create;
  bmpCostProtected16.LoadFromResourceName(hInstance, 'COSTPROTECTED16');
  bmpContentProtected16 := TBitmap.Create;
  bmpContentProtected16.LoadFromResourceName(hInstance, 'CONTENTPROTECTED16');
  bmpHasNotes := TBitmap.Create;
  bmpHasNotes.LoadFromResourceName(hInstance, SHasCommentBitmap);
  bmpHasAlert := TBitmap.Create;
  bmpHasAlert.LoadFromResourceName(hInstance, SHasAlertBitmap);
  bmpHasJobNotes := TBitmap.Create;
  bmpHasJobNotes.LoadFromResourceName(hInstance, SHasJobCommentBitmap);
  bmpTick16 := TBitmap.Create;
  bmpTick16.LoadFromResourceName(hInstance, STick16Bitmap);
  bmpYellowTick16 := TBitmap.Create;
  bmpYellowTick16.LoadFromResourceName(hInstance, SYellowTick16Bitmap);
  bmpError16 := TBitmap.Create;
  bmpError16.LoadFromResourceName(hInstance, SError16Bitmap);
  bmpError32 := TBitmap.Create;
  bmpError32.LoadFromResourceName(hInstance, SError32Bitmap);
  bmpContractor := TBitmap.Create;
  bmpContractor.LoadFromResourceName(hInstance, SContractorBitmap);
  bmpArrowDown := TBitmap.Create;
  bmpArrowDown.LoadFromResourceName(hInstance, SArrowDownBitmap);

finalization
  FreeAndNil(SortDownBmp);
  FreeAndNil(SortUpBmp);
  FreeAndNil(PlusBmp);
  FreeAndNil(MinusBmp);
  FreeAndNil(ClearBmp);
  FreeAndNil(CheckedBmp);
  FreeAndNil(UnCheckedBmp);
  FreeAndNil(NoCheckBmp);
  FreeAndNil(MakeBmp);
  FreeAndNil(RedCheckBmp);
  FreeAndNil(bmpSyncOK);
  FreeAndNil(bmpNew);
  FreeAndNil(bmpSyncFailed);
  FreeAndNil(bmpNoInvoice);
  FreeAndNil(bmpNoInvoiceDis);
  FreeAndNil(bmpNoInvoice);
  FreeAndNil(bmpNoShipment);
  FreeAndNil(bmpPartialShipment);
  FreeAndNil(bmpCompleteShipment);
  FreeAndNil(bmpShipmentApproved);
  FreeAndNil(bmpEditLock);
  FreeAndNil(bmpMultiInvoice);
  FreeAndNil(bmpCostProtected);
  FreeAndNil(bmpCostProtected);
  FreeAndNil(bmpContentProtected16);
  FreeAndNil(bmpCostProtected16);
  FreeAndNil(bmpHasNotes);
  FreeAndNil(bmpHasAlert);
  FreeAndNil(bmpHasJobNotes);
  FreeAndNil(bmpTick16);
  FreeAndNil(bmpYellowTick16);
  FreeAndNil(bmpError16);
  FreeAndNil(bmpError32);
  FreeAndNil(bmpContractor);
  FreeAndNil(bmpArrowDown);
end.
