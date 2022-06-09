unit PmDictionaryList;

interface

{$I calc.inc}

uses Classes, SysUtils, DB, DBClient, Variants, ADODB, Provider, MemTableEh,
  DataDriverEh, MemTableDataEh,

  PmEntity, DicObj, CalcSettings, NotifyEvent;

type
  TDictionaryList = class(TEntity)
  private
    DicElemList: TInternalDictionaryList;
    FDictionariesCreated: TNotifier;

    function GetDictionary(Name: string): TDictionary;
    procedure cdMultiFieldGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    function CreateDictionary(DicName, DicDesc: String; DicID, ParentID: integer;
       BuiltIn, ReadOnly, MultiDim, IsDim, AllowModifyDim: boolean): TDictionary;
    procedure ReadDicFields(Dic: TDictionary);
    procedure CreateDicFields(Dic: TDictionary);
  protected
    procedure DoAfterConnect; override;
    procedure ApplyDicItems(Dic: TDictionary);
    {procedure DoOnUpdateError(DataDriver: TDataDriverEh; MemTableData: TMemTableDataEh;
       MemRec: TMemoryRecordEh; var Action: TUpdateErrorActionEh);}
  public
    constructor Create; override;
    destructor Destroy; override;
    // Ищет не-case-sensitive
    property Dictionaries[Name: string]: TDictionary read GetDictionary; default;
    property DictionariesCreated: TNotifier read FDictionariesCreated;

    function Current: TDictionary; // TODO: а надо ли?
    function FindID(_DicID: integer): TDictionary;
    function FindDicByMultiData(MultiData: TDataSet): TDictionary;
    // Открывает все справочники, создает компоненты наборы данных для них
    // и заполняет список объектов-справочников с помощью CreateDictionary.
    procedure CreateDictionaries;
    // перечитывает структуру справочника, и переоткрывает его
    procedure ReInitDictionary(de: TDictionary);
    function GetAllDictionaries: TStringList;
    procedure RefreshMultiData(Dic: TDictionary; Combos: TList);
    procedure ApplyMultiData(Dic: TDictionary);
    procedure DeleteDictionary(_DicID: integer);
    function CreateMultiDimValueTable(de: TDictionary): boolean;
    function CurrentChanged: boolean;
    procedure CancelCurrent;
    procedure ApplyCurrent;
    procedure ApplyDic(Dic: TDictionary);
    // Определяет, есть ли изменения в данных справочников
    function HasChanges: boolean;
    // Применяет изменения ко всем справочникам
    procedure ApplyAll;
    // Отменяет изменения во всех справочниках
    procedure CancelAll;
    // Создает новый справочник с заданной структурой
    function CreateNewDictionary(DicName, DicDesc: string; MultiDim: boolean;
       ParentID: integer; StructData: TClientDataSet): TDictionary;
    // Проверяет, существует ли справочник с таким внутренним именем
    // и другим ключом. Возвращает false если уже существует и выдает сообщение об ошибке
    function CheckDicName(DicName: string; DicID: integer): boolean;
    // Модифицирует параметры справочника и компонент справочника в списке
    function ModifyDicTable(DicID: integer; DicName, DicDesc: string; MultiDim: boolean;
       StructData: TClientDataSet; de: TDictionary): integer;
    // обновляет родительскую папку справочника
    procedure UpdateParentID(_DicID, _ParentID: integer);
  end;

  TDictionaryFolders = class(TEntity)
  private
    procedure SetFolderName(Value: string);
    function GetFolderName: string;
    procedure SetParentID(Value: integer);
    function GetParentID: integer;
    //function GetParentIDFilter: integer;
  public
    constructor Create; override;
    property FolderName: string read GetFolderName write SetFolderName;
    property ParentID: integer read GetParentID write SetParentID;
    procedure SetParentIDFilter(Value: integer);
    procedure ResetFilter;
    //property ParentIDFilter: integer read GetParentIDFilter write SetParentIDFilter;
  end;

implementation

uses JvDBLookup, RDBUtils, RDialogs, Dialogs, PmAccessManager,
  DicData, PmDatabase, ExHandler, DataHlp;

const
  F_DicFolderID = 'FolderID';
  F_FolderName = 'DicDesc';
  F_ParentID = 'ParentID';

{$REGION 'TDictionaryList'}

constructor TDictionaryList.Create;
begin
  inherited Create;
  FKeyField := DicKeyField;

  SetDataSet(DicDM.cdAllDics);
  DataSetProvider := DicDM.pvAllDics;

  DicElemList := TInternalDictionaryList.Create;
  FDictionariesCreated := TNotifier.Create;
end;

destructor TDictionaryList.Destroy;
begin
  if DicElemList <> nil then
    DicElemList.ClearAll;
  FreeAndNil(DicElemList);
  FreeAndNil(FDictionariesCreated);
  inherited;
end;

procedure TDictionaryList.DoAfterConnect;
begin
end;

// Открывает все справочники, создает компоненты наборы данных для них
// и заполняет список объектов-справочников с помощью CreateDictionary.
procedure TDictionaryList.CreateDictionaries;
var
  DicID: integer;
  I: Integer;
  CurDic: TDictionary;
begin
  DicDM.OpenAllDics;
  DicDM.cdAllDics.First;
  while not DicDM.cdAllDics.eof do
  try
    if VarIsNull(DicDM.cdAllDics[DicKeyField]) then DicID := -1
    else DicID := DicDM.cdAllDics[DicKeyField];
    CreateDictionary(
      DicDM.cdAllDics['DicName'],
      DicDM.cdAllDics['DicDesc'],
      DicID,
      DicDM.cdAllDics['ParentID'],
      NvlBoolean(DicDM.cdAllDics['DicBuiltIn']),
      NvlBoolean(DicDM.cdAllDics['DicReadOnly']),
      NvlBoolean(DicDM.cdAllDics['MultiDim']),
      NvlBoolean(DicDM.cdAllDics['IsDim']),
      NvlBoolean(DicDM.cdAllDics['AllowModifyDim']));
  finally
    DicDM.cdAllDics.Next;
  end;
  // создаем поля после создания всех справочников, т.к. могут быть ссылки
  for I := 0 to DicElemList.Count - 1 do
  begin
    CurDic := DicElemList.Objects[I] as TDictionary;
    CreateDicFields(CurDic);
  end;
  // после этого все открываем, т.к. м.б. ссылки
  for I := 0 to DicElemList.Count - 1 do
  begin
    CurDic := DicElemList.Objects[I] as TDictionary;
    CurDic.OpenData;
  end;

  FDictionariesCreated.Notify(Self);
end;

procedure TDictionaryList.ReadDicFields(Dic: TDictionary);
var
  cdFieldInfo: TDataSet;
  DicFields: TStringList;
  FieldDesc: TFieldDesc;
begin
  cdFieldInfo := DicDM.cdFieldInfo;
  cdFieldInfo.Filter := 'DicID = ' + IntToStr(Dic.DicID);
  cdFieldInfo.Filtered := true;
  Dic.ClearDicFields;
  DicFields := TStringList.Create;
  try
    if cdFieldInfo.FindFirst then
    begin
      repeat
        FieldDesc := TFieldDesc.Create(NvlString(cdFieldInfo['FieldDesc']), NvlInteger(cdFieldInfo['FieldType']));
        FieldDesc.ReferenceID := NvlInteger(cdFieldInfo['ReferenceID']);
        FieldDesc.FieldLength := NvlInteger(cdFieldInfo['Length']);
        FieldDesc.FieldPrecision := NvlInteger(cdFieldInfo['Precision']);
        DicFields.AddObject(NvlString(cdFieldInfo['FieldName']), FieldDesc);
      until not cdFieldInfo.FindNext;
    end;
  finally
    cdFieldInfo.Filtered := false;
  end;
  Dic.DicFields := DicFields;
end;

procedure TDictionaryList.CreateDicFields(Dic: TDictionary);
var
  I: Integer;
  f: TField;
  fd: TFieldDesc;
  fn: string;
  ft: integer;
  NeedFields: boolean;
  LookupDic: TDictionary;
begin
  // Если уже есть какие-то поля, то это модификация справочника, значит, надо их создать
  NeedFields := Dic.DicItems.FieldCount > 0;
  if not NeedFields then
  begin
     // Надо создавать или все поля или ни одного. Создавать надо если указан тип
    for I := 0 to Dic.DicFields.Count - 1 do
    begin
      // пользовательские поля
      fn := Dic.DicFields[I];
      fd := Dic.DicFields.Objects[I] as TFieldDesc;
      if fd.FieldType <> 0 then
      begin
        NeedFields := true;
        break;
      end;
    end;
  end;

  if NeedFields then
  begin
    // обязательные поля
    f := TIntegerField.Create(Dic.DicItems.Owner);
    f.FieldName := F_DicItemID;
    f.DataSet := Dic.DicItems;

    f := TIntegerField.Create(Dic.DicItems.Owner);
    f.FieldName := F_DicItemCode;
    f.DataSet := Dic.DicItems;

    f := TStringField.Create(Dic.DicItems.Owner);
    f.FieldName := F_DicItemName;
    f.Size := DicItemNameSize;
    f.DataSet := Dic.DicItems;

    f := TBooleanField.Create(Dic.DicItems.Owner);
    f.FieldName := F_DicItemVisible;
    f.DataSet := Dic.DicItems;

    f := TIntegerField.Create(Dic.DicItems.Owner);
    f.FieldName := F_DicItemParentCode;
    f.DataSet := Dic.DicItems;

    f := TIntegerField.Create(Dic.DicItems.Owner);
    f.FieldName := F_DicItemOrdNum;
    f.DataSet := Dic.DicItems;

    f := TIntegerField.Create(Dic.DicItems.Owner);
    f.FieldName := F_DicItemSyncState;
    f.DataSet := Dic.DicItems;

    for I := 0 to Dic.DicFields.Count - 1 do
    begin
      // пользовательские поля
      fn := Dic.DicFields[I];
      fd := Dic.DicFields.Objects[I] as TFieldDesc;
      ft := fd.FieldType;
      if fd.IsLookup then
      begin
        f := TIntegerField.Create(Dic.DicItems.Owner);
        f.FieldName := fn;
        f.DataSet := Dic.DicItems;

        f := TStringField.Create(Dic.DicItems.Owner);
        f.Size := DicItemNameSize;
        f.FieldName := 'Lookup_' + fn;
        f.FieldKind := fkLookup;
        f.DataSet := Dic.DicItems;
        f.LookupCache := true;
        f.KeyFields := fn;

        if ft = ftDictionary then   // поле-ссылка на значение другого справочника
        begin
          LookupDic := FindID(fd.ReferenceID);
          if LookupDic = nil then
            ExceptionHandler.Raise_('Не найден справочник для ссылки ' + fd.FieldDesc
              + ' для справочника ' + Dic.Desc);
          f.LookupDataSet := LookupDic.DicItems;
          f.LookupKeyFields := F_DicItemCode;
          f.LookupResultField := F_DicItemName;
        end
        else
          ExceptionHandler.Raise_('Тип ссылки ' + IntToStr(ft)
            + ' не поддерживается, справочник ' + Dic.Desc);
      end
      else if ft <> 0 then  // пропускаем нулевые поля
      begin
        f := GetFieldClass(TFieldType(ft)).Create(Dic.DicItems.Owner);
        if f is TStringField then
          f.Size := fd.FieldLength
        else if f is TBCDField then
        begin
          f.Size := 0;//fd.FieldPrecision;
          (f as TBCDField).Precision := fd.FieldLength;
        end;
        f.FieldName := fn;
        f.DataSet := Dic.DicItems;
      end
      else
        ExceptionHandler.Raise_('Не указан тип поля ' + fn + ' в справочнике ' + Dic.Desc);
     end;
  end;
end;

// Создает компонент связи со справочником, помещает его в список, создает набор
// данных, если его еще нет.
function TDictionaryList.CreateDictionary(DicName, DicDesc: String; DicID, ParentID: integer;
  BuiltIn, ReadOnly, MultiDim, IsDim, AllowModifyDim: boolean): TDictionary;
var
  de: TDictionary;
  mcd: TClientDataSet;
  aq, maq: TADOQuery;
  mpv: TDataSetProvider;
  mt: TMemTableEh;
  dd: TDataSetDriverEh;
  // ADOQuery и Provider APPServer ДОЛЖЕН сохранять в своем списке !!!!!!!!!!!!!!!!!!!!!!!
  // а не в создаваемом объекте.
begin
  Result := nil;
  try
    mt := nil;
    // Ищем, может быть, уже есть набор данных для этого справочника
    mt := DicElemList.FindTable(DicTablePrefix + DicName);
    // Если нет, создаем и открываем
    if mt = nil then
      DicDM.CreateDicItems(DicName, MultiDim, IsDim, aq, mt{, dd});
    // Создаем новый справочник и добавляем его в список справочников
    de := TDictionary.Create(DicName, DicID, MultiDim, IsDim);
    de.Desc := DicDesc;
    de.BuiltIn := BuiltIn;
    de.ReadOnly := ReadOnly;
    de.ParentID := ParentID;
    // Назначаем набор данных
    de.DicItems := mt;
    de.DicDataSet := aq;
    //de.DicProvider := pv;
    //de.DicDataDriver := dd;
    ReadDicFields(de);
    //de.FieldInfoData := DicDM.cdFieldInfo;
    // Для многомерного - создаем набор данных со значениями
    if MultiDim then begin
      DicDM.CreateMultiItems(DicName, maq, mpv, mcd);
      de.MultiItems := mcd;
      de.MultiDataSet := maq;
      de.MultiDataProvider := mpv;
      de.AllowModifyDim := AllowModifyDim;
      RefreshMultiData(de, nil);
    end;
    // Добавляем в общий список
    DicElemList.AddDictionary(de);
    // Читаем данные
  except
    on E: Exception do begin
      ExceptionHandler.Raise_(E, 'Не могу создать справочник "' + DicDesc + '"',
         'CreateDictionary');
    end;
  end;
  Result := de;
end;

procedure TDictionaryList.ReInitDictionary(de: TDictionary);
begin
  de.CloseData;
  de.ClearDataFields;
  ReadDicFields(de);
  CreateDicFields(de);
  de.OpenData;
end;

function TDictionaryList.CreateNewDictionary(DicName, DicDesc: string; MultiDim: boolean;
  ParentID: integer; StructData: TClientDataSet): TDictionary;
var
  FCurDicID: integer;
begin
  FCurDicID := DicDM.CreateNewDictionary(DicName, DicDesc, MultiDim, ParentID, StructData);
  Result := CreateDictionary(DicName, DicDesc, FCurDicID, ParentID, false, false, false, false, false);
  if Result <> nil then
  begin
    //Result.RefreshData;
    DicDM.RefreshDics;  // сначала это, чтобы обновились описания полей
    ReInitDictionary(Result);
    {if DataSet.Locate('DicName', DicName, [loCaseInsensitive]) then
      Result.DicID := KeyValue
    else
      ExceptionHandler.Raise_('Не найден справочник с именем ' + DicName);}
  end;
end;

// Формирует запрос и перечитывает данные многомерного справочника,
// зависящие от значений нескольких комобобоксов, т. е. размерностей.
// !!!!!!!!!!!! APPSERVER частично
procedure TDictionaryList.RefreshMultiData(Dic: TDictionary; Combos: TList);
var
  dq: TADOQuery;
  cd: TDataSet;
  i: integer;
  f: string;
  Cbx: TJvDBLookupCombo;
  w: boolean;
  fld: TField;
begin
  // Если Combos = nil - то считывать все данные, иначе сделать выборку по
  // указанным в них значениям. Не Enabled и нулевые не учитываются.
  dq := Dic.MultiDataSet as TADOQuery;
  if dq = nil then Exit;
  cd := Dic.MultiItems;
  if cd = nil then Exit;
  cd.Close;
  dq.SQL.Clear;
  dq.SQL.Add('select * from ' + DicMultiTablePrefix + Dic.Name);
  if Combos <> nil then
  begin
    f := 'where ';
    w := false;
    for i := 1 to Dic.ItemCount do
    begin
      cbx := Combos[i - 1];
      if cbx.Enabled and not VarIsNull(cbx.KeyValue) then
      begin
        if w then f := f + ' and ';
        f := f + DimValueField + IntToStr(i) + ' = ' + IntToStr(cbx.KeyValue);
        w := true;
      end;
    end;
    if w then dq.SQL.Add(f);
  end;
  dq.SQL.Add('order by MultiID');
  Dic.OpenMultiItems;
  for i := 0 to Pred(cd.Fields.Count) do
  begin
    fld := cd.Fields[i];
    if (Pos(DimValueField, fld.FieldName) <> 0) and
       (CompareText(fld.FieldName, 'MultiID') <> 0) then
    begin
      fld.OnGetText := cdMultiFieldGetText;
      fld.ReadOnly := true;
      fld.Alignment := taLeftJustify;
    end;
  end;
end;

// Применение изменений (только модификация!) к таблице ЗНАЧЕНИЙ для
// многомерного справочника. См. CreateDicItemsUpdateSQL
procedure TDictionaryList.ApplyMultiData(Dic: TDictionary);
begin
  Database.ApplyDataSet(Dic.MultiItems);
end;

procedure TDictionaryList.cdMultiFieldGetText(Sender: TField; var Text: String; DisplayText: Boolean);
var
  i: integer;
  Dic: TDictionary;
begin
  if (Pos(DimValueField, Sender.FieldName) <> 0) then
  try
    i := StrToInt(Copy(Sender.FieldName, Length(DimValueField) + 1,
                       Length(Sender.FieldName) - Length(DimValueField)));
    Dic := FindDicByMultiData(Sender.DataSet);
    Text := DicElemList[Dic.Name + '_' + Dic.ItemValue[i, 1]].ItemName[Sender.AsInteger];
  except
  end;
end;

// Отмена изменений в текущем справочнике
procedure TDictionaryList.CancelCurrent;
var
  de, mde: TDictionary;
  mcd: TClientDataSet;
  mt: TMemTableEh;
begin
  de := DicElemList[DataSet['DicName']];
  if de = nil then Exit;
  mt := de.DicItems;
  mt.CheckBrowseMode;
  mt.CancelUpdates;

  // Для многомерных - отдельно, так как в списке справочников-измерений нет
  // TODO: вроде бы уже есть! значит, не надо?
  {if de.MultiDim then
  begin
    mt.First;
    while not mt.eof do
    begin
      mde := nil;
      mde := DicElemList[DataSet['DicName'] + '_' + mt['A1']];
      if mde = nil then
        raise Exception.Create('Справочник размерности ' + DataSet['DicName'] + '_' + mt['A1']
          + ' не найден');
      mcd := mde.DicItems;
      mcd.CheckBrowseMode;
      if mcd.ChangeCount > 0 then mcd.CancelUpdates;
      mt.Next;
    end;
  end;}
end;

function TDictionaryList.CurrentChanged: boolean;
var
  de: TDictionary;
  cd: TMemTableEh;
begin
  Result := false;
  de := DicElemList[DataSet['DicName']];
  if de = nil then Exit;
  cd := de.DicItems;
  if cd.Active then
  begin
    cd.CheckBrowseMode;
    Result := cd.RecordsView.MemTableData.RecordsList.HasCachedChanges;
  end
  else
    Result := false;
end;

// Применение изменений к таблице значений справочника.
// У многомерного в ней хранятся размерности.
procedure TDictionaryList.ApplyCurrent;
var
  cdCurDic: TMemTableEh;
  de: TDictionary;
begin
  de := DicElemList[DataSet['DicName']];
  if de = nil then Exit;
  cdCurDic := de.DicItems;
  if cdCurDic = nil then Exit;
  ApplyDic(de);
end;

procedure TDictionaryList.ApplyDic(Dic: TDictionary);
var
  mde: TDictionary;
begin
  if Dic.DicItems.State in [dsInsert, dsEdit] then
    Dic.DicItems.Post;

  ApplyDicItems(Dic);

  // Для многомерных - отдельно, так как в списке справочников-измерений нет
  if Dic.MultiDim then
  begin // обновление значений размерностей
    Dic.DicItems.First;
    while not Dic.DicItems.eof do
    begin
      mde := nil;
      mde := DicElemList[Dic.Name + '_' + Dic.CurrentValue[1]];
      //if mde = nil then continue;  // на всякий случай...
      DicDM.UDimDic := mde;
      DicDM.UMultiDic := Dic;
      DicDM.UDimCode := Dic.CurrentCode;
      ApplyDic(mde);
      Dic.DicItems.Next;
    end;
  end;
end;

procedure TDictionaryList.ApplyDicItems(Dic: TDictionary);
begin
  if Dic.DicItems.RecordsView.MemTableData.RecordsList.HasCachedChanges then
  begin
    //Dic.DicItems.DataDriver.OnUpdateError := DoOnUpdateError;
    //try
      Dic.DicItems.ApplyUpdates(0);
      //Database.ApplyDataSet(Dic.DicItems);
      Dic.DicItems.Close;
      Database.OpenDataSet(Dic.DicItems);
    //finally
    //  Dic.DicItems.DataDriver.OnUpdateError := nil;
    //end;
  end;
end;

{procedure TDictionaryList.DoOnUpdateError(DataDriver: TDataDriverEh; MemTableData: TMemTableDataEh;
  MemRec: TMemoryRecordEh; var Action: TUpdateErrorActionEh);
begin
  Action := ueaBreakRaiseEh;
end;}

procedure TDictionaryList.DeleteDictionary(_DicID: integer);
var
  de: TDictionary;
begin
  de := FindID(_DicID);
  if de <> nil then
  begin
    DicDM.DeleteDic(de.Name);
    // !!!!!!!!!!!!! ПОЧЕМУ не удаляем запись в списке и набор данных?????????????????
    DicElemList.FreeByName(de.Name);
  end;
end;

function TDictionaryList.GetDictionary(Name: string): TDictionary;
begin
  Result := DicElemList[Name];
end;

function TDictionaryList.FindID(_DicID: integer): TDictionary;
begin
  Result := DicElemList.FindID(_DicID);
end;

function TDictionaryList.FindDicByMultiData(MultiData: TDataSet): TDictionary;
begin
  Result := DicElemList.FindByMultiData(MultiData);
end;

function TDictionaryList.GetAllDictionaries: TStringList;
begin
  Result := DicElemList;
end;

function TDictionaryList.Current: TDictionary;
begin
  Result := DicElemList[DataSet[F_DicName]];
end;

// !!!!!!!!!!!!! НА АППСЕРВЕРЕ!!!!!!!!!!!!!!!!!
// Создает *только таблицу значений* для многомерного справочника.
// НИКУДА НЕ ПРИКРУЧЕНА
function TDictionaryList.CreateMultiDimValueTable(de: TDictionary): boolean;
var
  ValCount: array[1..MaxDimensions] of integer;
  FList: string;
  dq: TADOCommand;

  function GenInsert(p: string): string;
  var
    i: integer;
  begin
    Result := 'insert into ' + DicMultiTablePrefix + de.Name + ' (' + FList + ') values (';
    for i := 1 to Length(p) do begin
      Result := Result + IntToStr(Ord(p[i]));
      if i < Length(p) then Result := Result + ', ';
    end;
    Result := Result + ')';
  end;

  function InsertValues(p: string; ppos: integer): boolean;
  var
    i: integer;
  begin
    Result := false;
    for i := 1 to ValCount[ppos] do begin
      p[ppos] := Chr(i);
      if ppos = Length(p) then begin
        dq.CommandText := GenInsert(p);
        try
          dq.Execute;                       // Вставляем строку
          Result := true;
        except on E: Exception do begin
            Database.RollbackTrans;
            ExceptionHandler.Raise_(E);
          end;
        end
      end else
        Result := InsertValues(p, ppos + 1);
    end;
  end;

var
  i: integer;
  mde: TDictionary;
  DName: string;
  TransStarted: boolean;
begin
  Result := false;
  dq := TADOCommand.Create(nil);
  dq.Connection := Database.Connection;
  try  // Формируем SQL для создания таблицы           // 09.05.2004 commented out
    {s := 'create table ' + DicMultiTablePrefix + de.Name + ' (';
    s := s + 'MultiID int not null identity(1, 1)';}
    if not de.DicItems.Active then Exit;
    de.DicItems.DisableControls;
    FList := '';
    try
      // Проходим по всем размерностям...
      for i := 1 to de.ItemCount do
      begin
        // находим справочник текущей размерности...
        DName := de.Name + '_' + de.ItemValue[i, 1];
        mde := DicElemList.DicElements[DName];
        if mde = nil then
        begin
          RusMessageDlg('Не найден справочник размерности ' + DName + ' для ' + de.Desc,
             mtError, [mbOk], 0);
          Exit;
        end;
        // перечисляем поля-размерности...
        (*s := s + ', ' + DimValueField + IntToStr(i) + ' int not null';*)  // 09.05.2004
        // количество значений каждой размерности (для генерации перестановок)...
        ValCount[i] := mde.ItemCount;
        // ... и список полей для формирования SQL вставки в эту таблицу
        FList := FList + DimValueField + IntToStr(i);
        if i < de.ItemCount then FList := FList + ', ';
      end;
    finally
      de.DicItems.EnableControls;
    end;
    // 09.05.2004 commented out
    // ПОКА ТОЛЬКО ОДНО ПОЛЕ ЗНАЧЕНИЯ ДОПУСКАЕТСЯ - А1 float!
    {s := s + ', ' + DicItemValueField + '1' + ' float null';
    s := s + ') on [primary]';
    dq.CommandText := s;
    if not dm.cnCalc.InTransaction then dm.cnCalc.BeginTrans;
    try
      dq.Execute;                       // Создаем таблицу
    except on E: Exception do begin
        ProcessError(E);
        dm.cnCalc.RollbackTrans;
        Exit;
      end;
    end;
    dq.CommandText := 'alter table ' + DicMultiTablePrefix + de.Name + ' add constraint PK_' +
      DicMultiTablePrefix + de.Name + ' primary key nonclustered (MultiID) on [primary]';
    try
      dq.Execute;                       // Создаем ключ
    except on E: Exception do begin
        ProcessError(E);
        dm.cnCalc.RollbackTrans;
        Exit;
      end;
    end;
    DName := '';
    if de.DicItems.IsEmpty then begin   // Нет измерений
      dm.cnCalc.CommitTrans;
      if not dm.cnCalc.InTransaction then edm.SetUserRights;
      Result := true;
      Exit;
    end;}
    TransStarted := not Database.InTransaction;
    if TransStarted then
      Database.BeginTrans;
    try
      DName := '';
      for i := 1 to de.ItemCount do DName := DName + #1;
      if InsertValues(DName, 1) then
      begin
        if TransStarted then
          Database.CommitTrans;
        if not Database.InTransaction then
          AccessManager.SetUserRights;
        Result := true;
      end;
    except
      if TransStarted and Database.InTransaction then
        Database.RollbackTrans;
    end;
  finally
    dq.Free;
  end;
end;

procedure TDictionaryList.ApplyAll;
begin
  if not DataSet.Active then Exit;
  DataSet.DisableControls;
  try
    DataSet.First;
    while not DataSet.eof do
    begin
      ApplyCurrent;
      DataSet.Next;
    end;
  finally
    DataSet.EnableControls;
  end;

  // Теперь применяем изменения в справочниках размерностей
  {cdAllDics.DisableControls;
  cdAllDics.Filter := 'IsDim';
  cdAllDics.Filtered := true;
  try
    cdAllDics.First;
    while not cdAllDics.eof do
    begin
      ApplyCurDicElement;
      cdAllDics.Next;
    end;
  finally
    cdAllDics.EnableControls;
    cdAllDics.Filtered := false;
  end;}
end;

// Определяет, есть ли изменения в данных справочников
function TDictionaryList.HasChanges: boolean;
begin
  Result := false;
  if not DataSet.Active then Exit;

  DataSet.DisableControls;
  try
    DataSet.First;
    while not DataSet.eof do
    begin
      //try
        if CurrentChanged then
        begin
          Result := true;
          Exit;
        end;
      //except
      //end;
      DataSet.Next;
    end;
  finally
    DataSet.EnableControls;
  end;
end;

procedure TDictionaryList.CancelAll;
begin
  if not DataSet.Active then Exit;
  DataSet.DisableControls;
  try
    DataSet.First;
    while not DataSet.eof do
    begin
      //try
        CancelCurrent;
      //except
      //end;
      DataSet.Next;
    end;
  finally
    DataSet.EnableControls;
  end;
end;

function TDictionaryList.CheckDicName(DicName: string; DicID: integer): boolean;
begin
  Result := DicDM.CheckDicName(DicName, DicID);
  if not Result then
      RusMessageDlg('Справочник с именем "' + DicName + '" уже существует', mtError, [mbOk], 0);
end;

// Модифицирует параметры справочника и компонент справочника в списке
function TDictionaryList.ModifyDicTable(DicID: integer; DicName, DicDesc: string; MultiDim: boolean;
  StructData: TClientDataSet; de: TDictionary): integer;

begin
  Result := DicDM.ModifyDicTable(DicID, DicName, DicDesc, MultiDim, StructData, de);
  DicDm.RefreshDics;  // сначала это, чтобы обновились описания полей
  ReInitDictionary(de);
  //de.RefreshData;
end;

procedure TDictionaryList.UpdateParentID(_DicID, _ParentID: integer);
begin
  if Locate(_DicID) then
  begin
    if not (DataSet.State in [dsInsert, dsEdit]) then
      DataSet.Edit;
    DataSet[F_ParentID] := _ParentID;
  end
  else
    ExceptionHandler.Raise_('Внутренняя ошибка. Не найдена запись справочника');
end;

{$ENDREGION}

{$REGION 'TDictionaryFolders'}

constructor TDictionaryFolders.Create;
begin
  inherited Create;
  FKeyField := F_DicFolderID;
  FEnableClearEvents := true;
  SetDataSet(DicDm.cdDicsFolders);
  DataSetProvider := DicDM.pvDicsFolders;
end;

procedure TDictionaryFolders.SetFolderName(Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_FolderName] := Value;
end;

function TDictionaryFolders.GetFolderName: string;
begin
  Result := NvlString(DataSet[F_FolderName]);
end;

procedure TDictionaryFolders.SetParentID(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_ParentID] := Value;
end;

function TDictionaryFolders.GetParentID: integer;
begin
  Result := NvlInteger(DataSet[F_ParentID]);
end;

procedure TDictionaryFolders.SetParentIDFilter(Value: integer);
begin
  DataSet.Filter := F_ParentID + '=' + IntToStr(Value);
  DataSet.Filtered := true;
end;

procedure TDictionaryFolders.ResetFilter;
begin
  DataSet.Filtered := false;
end;

{$ENDREGION}

end.
