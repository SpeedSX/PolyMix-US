unit DicUtils;

interface

uses Classes, Db, Graphics, DBGridEh, GridsEh,
  DicObj, PmUtils, Menus, RDBUtils;

const
  NameSeparator = ':';

//procedure SetupAccounts(ds: TDataSet; deAcc: TDictionary);

function GetDictionaryComment(s: string): string;
function GetDictionaryText(s: string): string;
function GetDictionaryPercent(s: string): extended;
function GetDictionaryFloat(s: string): extended;
procedure DicSetupGridColumns(de: TDictionary; dgDic: TGridClass);

function GetNProductValue(_NProduct: integer; DimDic: TDictionary): variant;

procedure DicGetCellParams(Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);

//procedure FillPopupMenuFromDic(PopupMenu: TPopupMenu; de: TDicElement; RangeStart, RangeEnd: integer);
procedure FillPopupMenuFromDicEv(PopupMenu: TPopupMenu; de: TDictionary;
  RangeStart, RangeEnd: integer; OnPopSel: TNotifyEvent);

// Заполняет контекстное меню из набора данных
// VisibleFieldName можно не указывать ('')
procedure FillPopupMenuFromDataSetEv(PopupMenu: TPopupMenu;
  DicItems: TDataSet;
  RangeStart, RangeEnd: integer;
  CodeFieldName, NameFieldName, VisibleFieldName: string;
  OnPopSel: TNotifyEvent);

implementation

uses JvJCLUtils, SysUtils, Variants, CalcSettings, MemTableEh;

type
  TDropDownGetParams = class
  public
    // рисует неактивные записи справочника сереньким
    procedure DropDownBoxGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
  end;

var
  DropDownGetParams: TDropDownGetParams;

function GetDictionaryComment(s: string): string;
begin
  Result := DelRSpace(ExtractWord(1, s, [NameSeparator]));
end;

function GetDictionaryText(s: string): string;
var p: integer;
begin
  p := Pos(NameSeparator, s);
  if p <> 0 then begin
    if p = length(s) then Exit;
    Result := DelRSpace(copy(s, p + 1, length(s) - p));
  end else
    Result := s;
end;

function GetDictionaryPercent(s: string): extended;
var p: integer;
begin
  p := Pos(NameSeparator, s);
  if p <> 0 then begin
    if p = length(s) then Exit;
    try   // Знак процента отсекаем - он последний
      Result := StrToFloat(DelRSpace(copy(s, p + 1, length(s) - p - 1)));
    except Result := 0; end;
  end else begin
    s := DelRSpace(s);     // Знак процента отсекаем - он последний
    Result := StrToFloat(copy(s, 1, length(s) - 1));
  end;
end;

function GetDictionaryFloat(s: string): extended;
var p: integer;
begin
  p := Pos(NameSeparator, s);
  if p <> 0 then begin
    if p = length(s) then Exit;
    try
      Result := StrToFloat(DelRSpace(copy(s, p + 1, length(s) - p)));
    except Result := 0; end;
  end else
    Result := StrToFloat(DelRSpace(s));
end;

// Вызывается из обработчиков табличек OnColEnter, OnEnter
// для списка оплат заказа
{procedure SetupAccounts(ds: TDataSet; deAcc: TDictionary);
var
  bm: TBookmark;
begin
  bm := ds.GetBookmark;
  ds.DisableControls;
  try
    (deAcc.DicItems as TClientDataSet).CancelUpdates;
    ds.First;
    while not ds.eof do begin
      try
        deAcc.DicItems.Append;
        if ds['PayKind'] = 2 then begin
          if VarIsNull(ds['AccountNum']) then
            deAcc.DicItems[DicItemNameField] := 'Безналичные'
          else begin
            deAcc.DicItems[DicItemValueField + '1'] := ds['AccountNum'];   // Номер счета записывем
            deAcc.DicItems[DicItemNameField] := 'Безналичные - счет ' + IntToStr(ds['AccountNum']);
          end;
        end else
          deAcc.DicItems[DicItemNameField] := 'Наличные';
      except end;
      ds.Next;
    end;
  finally
    ds.GotoBookmark(bm);
    ds.FreeBookmark(bm);
    ds.EnableControls;
  end;
end;}

// Устанавливает заголовки в таблице справочника
// в соотв-е с именами полей de.DicFields и некоторые параметры столбцов
procedure DicSetupGridColumns(de: TDictionary; dgDic: TGridClass);
var
  i, k: integer;
  n: string;
  fd: TFieldDesc;
begin
  // начинаются поля данных с 4-го столбца!
  k := 3;
  if (de.DicFields <> nil) and (de.DicFields.Count > 0) then
  begin
    for i := 0 to Pred(de.DicFields.Count) do
    begin
      // вырезаем из имени поля его номер
      n := de.DicFields[i];
      fd := de.DicFields.Objects[I] as TFieldDesc;
      if fd.IsLookup then
      begin
        dgDic.Columns[k].FieldName := 'Lookup_' + n;
        dgDic.Columns[k].AlwaysShowEditButton := true;
        // рисует неактивные записи сереньким
        dgDic.Columns[k].OnDropDownBoxGetCellParams := DropDownGetParams.DropDownBoxGetCellParams;
      end
      else
      begin
        dgDic.Columns[k].FieldName := n;
        dgDic.Columns[k].AlwaysShowEditButton := false;
      end;
      //k := StrToInt(Copy(n, Length(DicItemValueField) + 1, Length(n) - 1)) + 1;
      dgDic.Columns[k].Title.Caption := fd.FieldDesc;
      dgDic.Columns[k].Visible := true;
      Inc(k);
      {f := de.DicItems.FindField(de.DicFields[i]);
      if (f <> nil) and (f is TBlobField) then }
    end;
  end;
  // все остальные делаем невидимыми
  if k < dgDic.Columns.Count then
    for i := k to Pred(dgDic.Columns.Count) do
      dgDic.Columns[i].Visible := false;
end;

function GetNProductValue(_NProduct: integer; DimDic: TDictionary): variant;

  function Conf(s: string; n: integer): boolean;
  var
    m, i: integer;
  begin
    Result := false;
    s := DelSpace(s);
    if s = '' then Exit;
    if s[2] = '=' then i := 3 else i := 2;
    try m := StrToInt(Copy(s, i, Length(s) - 1))
    except Exit end;
    if s[2] = '=' then begin
      if s[1] = '<' then Result := n <= m
      else if s[1] = '>' then Result := n >= m
    end else begin
      if s[1] = '<' then Result := n < m
      else if s[1] = '>' then Result := n > m
    end;
  end;

var
  i: integer;
  Ok: boolean;
begin
  Result := null;
  Ok := false;
  if DimDic.ItemCount > 0 then
    for i := 1 to DimDic.ItemCount do begin
      Ok := Conf(DimDic.ItemName[i], _NProduct);
      if Ok then break;
    end;
  if Ok then Result := i;
end;

procedure DicGetCellParams(Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
var
  f: TField;
begin
  f := Column.Field;
  if f <> nil then
  try
    f := F.DataSet.FieldByName(F_DicItemVisible);
    if f = nil then Exit;
    if not VarIsNull(f.Value) and not f.Value then
    begin
      if gdSelected in State then
      begin
        Background := clInactiveCaption;
        AFont.Color := clInactiveCaptionText;
      end
      else
      begin
        Background := clInactiveCaptionText;
        AFont.Color := clInactiveCaption;
      end;
    end
    else
    begin
      if gdSelected in State then
      begin
        Background := clHighlight;
        AFont.Color := clHighlightText;
      end;
    end;
  except end;
end;

{procedure FillPopupMenuFromDic(PopupMenu: TPopupMenu; de: TDicElement; RangeStart, RangeEnd: integer);
begin
  FillPopupMenuEv(PopupMenu, de, RangeStart, RangeEnd, OnPopupSelected);
end;}

procedure FillPopupMenuFromDicEv(PopupMenu: TPopupMenu;
  de: TDictionary; RangeStart, RangeEnd: integer; OnPopSel: TNotifyEvent);
begin
  FillPopupMenuFromDataSetEv(PopupMenu, de.DicItems, RangeStart, RangeEnd,
    F_DicItemCode, F_DicItemName, F_DicItemVisible, OnPopSel);
end;

// Заполняет контекстное меню из набора данных
// VisibleFieldName можно не указывать ('')
procedure FillPopupMenuFromDataSetEv(PopupMenu: TPopupMenu;
  DicItems: TDataSet;
  RangeStart, RangeEnd: integer;
  CodeFieldName, NameFieldName, VisibleFieldName: string;
  OnPopSel: TNotifyEvent);
var
  i: integer;
  mi: TMenuItem;
  WasTree: boolean;
begin
  PopupMenu.Items.Clear;
  if Assigned(DicItems) and DicItems.Active and not DicItems.IsEmpty
    and (DicItems.FindField(NameFieldName) <> nil) then
  begin
    if (DicItems is TMemTableEh) and (DicItems as TMemTableEh).TreeList.Active then
    begin
      (DicItems as TMemTableEh).TreeList.Active := false;
      WasTree := true
    end
    else
      WasTree := false;
    try
      DicItems.First;
      while not DicItems.eof do
      try
        if (VisibleFieldName = '') or NvlBoolean(DicItems[VisibleFieldName]) then
        begin
          // Проверка на попадание в диапазон кодов
          if (RangeEnd <> -1) and ((DicItems[CodeFieldName] > RangeEnd) or
              (DicItems[CodeFieldName] < RangeStart)) then continue;
          mi := TMenuItem.Create(PopupMenu.Owner);
          mi.Caption := DicItems[NameFieldName];
          mi.Tag := DicItems[CodeFieldName];
          mi.OnClick := OnPopSel;
          mi.Visible := true;
          PopupMenu.Items.Add(mi);
          // установка стиля
          TSettingsManager.Instance.XPActivateMenuItem(mi, true);
        end;
      finally
        DicItems.Next;
      end;
    finally
      if (DicItems is TMemTableEh) and WasTree then
        (DicItems as TMemTableEh).TreeList.Active := true;
    end;
  end;
  //TSettingsManager.Instance.XPInitComponent(PopupMenu); как то оно не очень...
end;

procedure TDropDownGetParams.DropDownBoxGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
var
  ds: TDataSet;
begin
  if (Column <> nil) and (Column.Field <> nil) then
  begin
    ds := Column.Field.DataSet;
    if not NvlBoolean(ds[F_DicItemVisible]) then
      AFont.Color := clGrayText;
  end;
end;

initialization
  DropDownGetParams := TDropDownGetParams.Create;

finalization
  DropDownGetParams.Free;

end.
