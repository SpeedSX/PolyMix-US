unit DicData;

{$I calc.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Dialogs,
  DB, Provider, DBClient, ADODB, Variants, DicObj,
  PmDatabase, MemTableEh, DataDriverEh;

const
  DicTablePrefix = 'Dic_';
  DicMultiTablePrefix = 'DicMulti_';

  DicFieldsTableName = 'DicFields';
  SrvFieldsTableName = 'SrvFields';
  DicKeyField = 'DicID';
  F_DicName = 'DicName';
  StructKeyField = 'ID';
  // При добавлении нового свойства поля справочника надо его регистрировать здесь
  // и в методе ApplyDicStructChange!
  DicStructPropFields = 'FieldType,[Length],[Precision],ReferenceID';

type
  TDicDM = class(TDataModule, IRCDataModule)
    dsFieldInfo: TDataSource;
    cdAllDics: TClientDataSet;
    pvAllDics: TDataSetProvider;
    aqAllDics: TADOQuery;
    cdAllDicsDicName: TStringField;
    cdAllDicsDicDesc: TStringField;
    cdAllDicsDicBuiltIn: TBooleanField;
    cdAllDicsDicReadOnly: TBooleanField;
    cdAllDicsIsDim: TBooleanField;
    cdAllDicsMultiDim: TBooleanField;
    cdAllDicsDicID: TAutoIncField;
    aqFieldInfo: TADOQuery;
    pvFieldInfo: TDataSetProvider;
    aqFieldInfoDicFieldID: TAutoIncField;
    aqFieldInfoDicID: TIntegerField;
    aqFieldInfoFieldName: TStringField;
    aqFieldInfoFieldDesc: TStringField;
    cdFieldInfo: TClientDataSet;
    cdFieldInfoDicFieldID: TAutoIncField;
    cdFieldInfoDicID: TIntegerField;
    cdFieldInfoFieldName: TStringField;
    cdFieldInfoFieldDesc: TStringField;
    aupNewDic: TADOStoredProc;
    aupDelDic: TADOStoredProc;
    aupUpdateDic: TADOStoredProc;
    aqStruct: TADOQuery;
    cdStruct: TClientDataSet;
    pvStruct: TDataSetProvider;
    cdStructFieldName: TStringField;
    cdStructFIeldDesc: TStringField;
    cdStructFieldType: TIntegerField;
    cdStructLength: TIntegerField;
    cdStructPrecision: TIntegerField;
    aqOldStruct: TADOQuery;
    pvOldStruct: TDataSetProvider;
    cdOldStruct: TClientDataSet;
    cdStructID: TIntegerField;
    cdOldStructID: TIntegerField;
    cdOldStructFieldName: TStringField;
    cdOldStructFIeldDesc: TStringField;
    cdOldStructFieldType: TIntegerField;
    cdOldStructLength: TIntegerField;
    cdOldStructPrecision: TIntegerField;
    cdStructPredefined: TBooleanField;
    cdOldStructPredefined: TBooleanField;
    aqAllDicsDicBuiltIn: TBooleanField;
    aqAllDicsDicReadOnly: TBooleanField;
    aqAllDicsIsDim: TBooleanField;
    aqAllDicsMultiDim: TBooleanField;
    aqAllDicsDicID: TIntegerField;
    aqAllDicsDicName: TStringField;
    aqAllDicsDicDesc: TStringField;
    aqStructID: TIntegerField;
    aqStructFieldType: TIntegerField;
    aqStructLength: TIntegerField;
    aqStructPrecision: TIntegerField;
    aqStructPredefined: TBooleanField;
    aqStructFieldName: TStringField;
    aqStructFieldDesc: TStringField;
    aqOldStructID: TIntegerField;
    aqOldStructFieldType: TIntegerField;
    aqOldStructLength: TIntegerField;
    aqOldStructPrecision: TIntegerField;
    aqOldStructPredefined: TBooleanField;
    aqOldStructFieldName: TStringField;
    aqOldStructFieldDesc: TStringField;
    aqDicsFolders: TADOQuery;
    pvDicsFolders: TDataSetProvider;
    cdDicsFolders: TClientDataSet;
    cdDicsFoldersFolderID: TAutoIncField;
    cdDicsFoldersDicDesc: TStringField;
    cdDicsFoldersParentID: TIntegerField;
    cdAllDicsAllowModifyDim: TBooleanField;
    aqAllDicsAllowModifyDim: TBooleanField;
    cdFieldInfoFieldType: TIntegerField;
    cdFieldInfoReferenceID: TIntegerField;
    cdFieldInfoLength: TIntegerField;
    cdFieldInfoPrecision: TIntegerField;
    aqFieldInfoFieldType: TIntegerField;
    aqFieldInfoReferenceID: TIntegerField;
    aqFieldInfoLength: TIntegerField;
    aqFieldInfoPrecision: TIntegerField;
    cdStructReferenceID: TIntegerField;
    cdOldStructReferenceID: TIntegerField;
    aqStructReferenceID: TIntegerField;
    aqOldStructReferenceID: TIntegerField;
    cdStructHasFieldType: TBooleanField;
    aqStructHasFieldType: TBooleanField;
    cdOldStructHasFieldType: TBooleanField;
    aqOldStructHasFieldType: TBooleanField;
    cdAllDicsParentID: TIntegerField;
    aqAllDicsParentID: TIntegerField;
    procedure DataModuleDestroy(Sender: TObject);
    procedure cdCurDicNewRecord(DataSet: TDataSet);
    procedure cdCurDicBeforeInsert(DataSet: TDataSet);
    procedure DicStructNewRecord(DataSet: TDataSet);
    procedure DicStructBeforeInsert(DataSet: TDataSet);
    procedure DicStructBeforeDelete(DataSet: TDataSet);
    procedure DicFieldTypeChange(Sender: TField);
    procedure pvStructBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
      var Applied: Boolean);
    procedure DataModuleCreate(Sender: TObject);
  private
    DicCode: integer;
    FCurDicName: string; // используется временно для работы со структурой таблиц
    FCurDicID: integer;  // используется временно для работы со структурой таблиц
    FStructFName: string; // используется временно для работы со структурой таблиц
    FDicContainer: TDataModule; // Вложенный модуль для создания наборов данных справочников

    function CalcDicCode(DataSet: TDataSet; FieldName: string): integer;

    function ApplyDicStructChange(StructData: TClientDataSet; de: TDictionary): boolean;
    function ApplyDicStructCreate(StructData: TClientDataSet): boolean;
    function CalcDicFieldName(DataSet: TDataSet): string;
    //procedure AbortEdit(DataSet: TDataSet);
    procedure pvCurDimDicBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
      var Applied: Boolean);
{    procedure CreateDicItemsUpdateSQL(DicName: string; MultiDim: boolean;
      aq: TADOQuery);}
    procedure pvMultiTableBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
      var Applied: Boolean);
    {procedure pvCurDicUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
      var Applied: Boolean);}
  public
    // TODO: временно здесь, но надо попробовать что-то придумать
    UDimDic, UMultiDic: TDictionary;
    UDimCode: integer;

    // Открытие таблиц 'ВСЕХ справочников' и 'описаний полей'
    function OpenAllDics: boolean;
    // Закрытие таблиц 'ВСЕХ справочников' и 'описаний полей'
    procedure CloseAllDics;

    // Закрывает все и удаляет наборы данных справочников
    procedure CloseDicData;

    // Обновляет списки справочников и описания полей
    procedure RefreshDics;

    function CheckDicName(DicName: string; DicID: integer): boolean;
    function CreateNewDictionary(DicName, DicDesc: string; MultiDim: boolean;
      ParentID: integer; StructData: TClientDataSet): integer;
    function ModifyDicTable(DicID: integer; DicName, DicDesc: string; MultiDim: boolean;
     StructData: TClientDataSet; de: TDictionary): integer;
    function CreateDicStructData(var StructData: TClientDataSet; de: TDictionary;
     UseOld: boolean): boolean;
    procedure DeleteDic(DicName: string);
    //procedure CreateAllOrderStates;
    //procedure UpdateAllOrderStates;
    //procedure DoneAllOrderStates;
    function CommonApplyStructCreate(TableName, FieldsTableName: string;
      FieldsTableKeyField: string;
      PropFields: string;      // дополнительные поля структуры
      KeyValue: integer; StructData: TClientDataSet;
      IncludePredefined: boolean): boolean;
    function CommonApplyStructChange(TableName, TableKeyField,
      FieldsTableName, FieldsTableKeyField,
      PredefFieldsSQL, PredefFields: string;
      PropFields: string;  // дополнительные поля структуры
      KeyValue: integer;
      OldStructData, StructData: TClientDataSet; UseIdentity: boolean): boolean;
    //procedure UpdateStdDics;
    procedure OpenDataSet(DataSet: TDataSet);
    //procedure ApplyTreeViewData;
    function CreateDicItems(const DicName: string; MultiDim, IsDim: boolean;
      var aq: TADOQuery;
      var mt: TMemTableEh{; var dd: TDataSetDriverEh}): boolean;
    function CreateMultiItems(const DicName: string;
      var aq: TADOQuery; var pv: TDataSetProvider; var cd: TClientDataSet): boolean;
  end;

var
  DicDm: TDicDM;

implementation

uses RDBUtils, RDialogs, ExHandler, DataHlp, SrcDFrm, JvJCLUtils, PmAccessManager,
  CalcUtils, DBSettings, PmProcess
{$IFNDEF NoExpenses}
  , ExpData, ExpBuiltIn
{$ENDIF}
  ;

{$R *.DFM}

// Открытие таблицы ВСЕХ справочников и описаний полей
function TDicDM.OpenAllDics: boolean;
begin
  // Если уже открыт, то не открываем
  //if cdAllDics.Active then begin Result := true; Exit; end;
  try
    OpenDataSet(cdFieldInfo); // сначала описания полей открываем
    OpenDataSet(cdAllDics);
    OpenDataSet(cdDicsFolders);
  except
    on E: EDatabaseError do
      ExceptionHandler.Raise_(E, 'Не могу открыть таблицу справочников',
        'OpenSrvDics');
  end;
  Result := true;
end;

procedure TDicDM.CloseAllDics;
begin
  if cdAllDics.Active then cdAllDics.Close;
  if cdFieldInfo.Active then cdFieldInfo.Close;
end;

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// ЭТУ И СЛЕДУЮЩУЮ ПРОЦЕДУРЫ НАДО РАЗДЕЛИТЬ НА ДВЕ ЧАСТИ - ОДНА СРАБОТАЕТ НА СЕРЕРЕ И
// СОЗДАСТ *ADOQUERY* И *DATASETPROVIDER*, А ДРУГАЯ - НА КЛИЕНТЕ СОЗДАСТ *CLIENTDATASET*.

function TDicDM.CreateDicItems(const DicName: string; MultiDim, IsDim: boolean;
  var aq: TADOQuery;
  var mt: TMemTableEh{; var dd: TDataSetDriverEh}): boolean;
var
  dd: TDataSetDriverEh;
begin
  try
    aq := TADOQuery.Create(FDicContainer);
    //cd := TClientDataSet.Create(FDicContainer);
    //pv := TDataSetProvider.Create(FDicContainer);

    //pv.Name := GetComponentName(FDicContainer, PVNamePrfx + DicName);
    aq.Connection := Database.Connection;
    //pv.DataSet := aq;
    //cd.ProviderName := pv.Name;
    {aq.LockType := ltBatchOptimistic;
    aq.CursorType := ctStatic;}
    aq.LockType := ltOptimistic;
    aq.CursorType := ctDynamic;
    aq.SQL.Add('select * from ' + DicTablePrefix + DicName + ' order by Code');

    mt := TMemTableEh.Create(FDicContainer);       // 22.07.2009
    dd := TDataSetDriverEh.Create(FDicContainer);
    mt.DataDriver := dd;
    mt.FetchAllOnOpen := true;
    mt.CachedUpdates := true;
    mt.TreeList.KeyFieldName := F_DicItemCode;
    mt.TreeList.RefParentFieldName := F_DicItemParentCode;
    mt.TreeList.DefaultNodeExpanded := true;
    mt.TreeList.Active := true;
    dd.KeyFields := F_DicItemID;
    dd.ProviderDataSet := aq;

    // Многомерные справочники пока нельзя редактировать
    if MultiDim then
    begin
      aq.LockType := ltOptimistic;
      //pv.Options := pv.Options + [poDisableInserts, poDisableDeletes];
    end
    else
    if IsDim then
    begin
      // справочники размерностей
      aq.LockType := ltOptimistic;
      //pv.BeforeUpdateRecord := pvCurDimDicBeforeUpdateRecord;   // TODO!
      mt.BeforeInsert := cdCurDicBeforeInsert;
      mt.OnNewRecord := cdCurDicNewRecord;
    end
    else
    begin   // Для табличных справочников
      aq.LockType := ltOptimistic;
      //pv.BeforeUpdateRecord := pvCurDicUpdateRecord;           // TODO!
      mt.BeforeInsert := cdCurDicBeforeInsert;
      mt.OnNewRecord := cdCurDicNewRecord;
    end;
    Result := true;
  except
    on E: Exception do begin
      ExceptionHandler.Raise_(E, 'Не могу создать набор данных для справочника "' + DicName + '"',
           'CreateDicItems');
      Result := false;
    end;
  end;
end;

// APPSERVER !!!!!!!!!!!!!!!!!!!!!!!!!!!
// Создает UpdateSQL для DicItems и MultiItems. Вызывается после активизации
// этих наборов данных, т.к. названия полей заранее не известны.
{procedure Tedm.CreateDicItemsUpdateSQL(DicName: string; MultiDim: boolean;
  aq: TADOQuery); // - этот параметр не должен передаваться АППСЕРВЕРУ клиентом,
                     // он должен находить его по имени справочника в своем списке.
var
  TableName: string;
  us: Tvg2ADOUpdateSQL;
  i: integer;
begin
  aq.Open;
  try
    us := Tvg2ADOUpdateSQL.Create(edm);
    // Для многомерного справочника - только обновление и только значений
    if MultiDim then begin
      TableName := DicMultiTablePrefix + DicName;
      us.ModifySQL.Clear;
      us.ModifySQL.Add('update ' + TableName + ' set ');
      i := 1;
      while aq.FindField(DicItemValueField + IntToStr(i)) <> nil do begin
        if i > 1 then us.ModifySQL.Add(',');
        us.ModifySQL.Add(DicItemValueField + IntToStr(i) +
          ' = :' + DicItemValueField + IntToStr(i));
        Inc(i);
      end;
      us.ModifySQL.Add('where MultiID = :OLD_MultiID');
    end else begin                       // обычный справочник
      TableName := DicTablePrefix + DicName;
      us.ModifySQL.Clear;
      us.ModifySQL.Add(GetDataSetUpdateSQL(aq, TableName, DicItemCodeField, ukModify));
      us.InsertSQL.Clear;
      us.InsertSQL.Add(GetDataSetUpdateSQL(aq, TableName, DicItemCodeField, ukInsert));
      us.DeleteSQL.Clear;
      us.DeleteSQL.Add(GetDataSetUpdateSQL(aq, TableName, DicItemCodeField, ukDelete));
    end;
    aq.UpdateObject := us;
  finally
    aq.Close;
  end;
end;}

// SQL не генерится!!!!!!!!
function TDicDM.CreateMultiItems(const DicName: string;
  var aq: TADOQuery; var pv: TDataSetProvider; var cd: TClientDataSet): boolean;
begin
  try
    aq := TADOQuery.Create(FDicContainer);
    aq.Connection := Database.Connection;
    cd := TClientDataSet.Create(FDicContainer);
    pv := TDataSetProvider.Create(FDicContainer);
    pv.Name := GetComponentName(FDicContainer, PVNamePrfx + 'Multi');
    aq.Connection := Database.Connection;
    pv.DataSet := aq;
    cd.ProviderName := pv.Name;
    aq.LockType := ltOptimistic;
    pv.BeforeUpdateRecord := pvMultiTableBeforeUpdateRecord;
    pv.Options := pv.Options + [poDisableDeletes, poDisableInserts];

    Result := true;
  except
    on E: Exception do begin
      ExceptionHandler.Raise_(E, 'Не могу создать набор данных для справочника "' + DicName + '"',
           'CreateMultiItems');
      Result := false;
    end;
  end;
end;

{function FieldBoolean(F: TField): boolean;
begin
  try
    Result := not F.IsNull and F.AsBoolean;
  except
    Result := false;
  end;
end;}

// Закрываем все наборы данных, удаляем компоненты и справочники из списка
procedure TDicDM.CloseDicData;
var
  i: integer;
  tc: TComponent;
begin
  for i := Pred(FDicContainer.ComponentCount) downto 0 do
  begin
    tc := FDicContainer.Components[i];
    if (tc is TClientDataSet) then
      (tc as TDataSet).Close;
    tc.Free;
  end;
  CloseAllDics;
end;

procedure TDicDM.DataModuleCreate(Sender: TObject);
begin
  FDicContainer := TDataModule.Create(nil);
end;

procedure TDicDM.DataModuleDestroy(Sender: TObject);
begin
  CloseDicData;
  FDicContainer.Free;
end;

// ---------------- Редактор справочников --------------------

// !!!!!!!!!!!!!!! ЭТО ДОЛЖНО БЫТЬ НА АППСЕРВЕРЕ !!!!!!!!!!!!
// DicID - ключ исходного справочника, используется при переименовании
function TDicDM.CheckDicName(DicName: string; DicID: integer): boolean;
var
  dq: TADOQuery;
begin
  dq := TADOQuery.Create(nil);
  try
    dq.Connection := Database.Connection;
    dq.SQL.Add('select DicID from DicElements where DicName = ''' + DicName +
      ''' and DicID <> ' + IntToStr(DicID));
    dq.Open;
    Result := dq.IsEmpty;
    dq.Close;
  finally
    dq.Free;
  end;
end;

// Для структуры справочников. для сервисов похожий в SDM
procedure TDicDM.DicFieldTypeChange(Sender: TField);
begin
  FieldTypeChanged(Sender);
end;

// Для структуры справочников. для сервисов похожий в SDM
procedure TDicDM.DicStructNewRecord(DataSet: TDataSet);
begin
  DataSet['FieldType'] := Ord(ftInteger);
  DataSet['FieldDesc'] := '';
  DataSet['FieldName'] := FStructFName;
  DataSet['Predefined'] := false;
  DataSet['HasFieldType'] := true;
  DataSet[StructKeyField] := DataSet.Tag;  // IDENTITY
  DataSet.Tag := DataSet.Tag + 1;  // Наращиваем Identity
end;

// ТОЖЕ НАДО РАЗДЕЛИТЬ НА 2 ЧАСТИ !!!!!!!!!!!!!!!!!!!!!!!!!!!
// Создает набор данных StructData, описывающий структуру справочника для справочника de
// Tag выполняет роль IDENTITY для этой таблицы - номер следующего ID.
function TDicDM.CreateDicStructData(var StructData: TClientDataSet; de: TDictionary;
  UseOld: boolean): boolean;
var
  i: integer;
  f: TField;
  fd: TFieldDesc;
begin
  Result := false;
  try
    if UseOld then StructData := cdOldStruct else StructData := cdStruct;
    OpenDataSet(StructData);
    with StructData do
    begin
      Append;
      FieldByName(StructKeyField).Value := 1;
      FieldByName('FieldName').Value := F_DicItemCode;
      FieldByName('FieldDesc').Value := 'Код';
      FieldByName('FieldType').Value := Ord(ftInteger);
      FieldByName('Predefined').Value := true;  // означает, что поле предопределенное
      Append;
      FieldByName(StructKeyField).Value := 2;
      FieldByName('FieldName').Value := F_DicItemName;
      FieldByName('FieldDesc').Value := 'Название';
      FieldByName('FieldType').Value := Ord(ftString);
      FieldByName('Predefined').Value := true;  // означает, что поле предопределенное
      Append;
      FieldByName(StructKeyField).Value := 3;
      FieldByName('FieldName').Value := F_DicItemVisible;
      FieldByName('FieldDesc').Value := 'Активен';
      FieldByName('FieldType').Value := Ord(ftBoolean);
      FieldByName('Predefined').Value := true;  // означает, что поле предопределенное
      Append;
      FieldByName(StructKeyField).Value := 4;
      FieldByName('FieldName').Value := F_DicItemParentCode;
      FieldByName('FieldDesc').Value := 'Код верхнего уровня';
      FieldByName('FieldType').Value := Ord(ftInteger);
      FieldByName('Predefined').Value := true;  // означает, что поле предопределенное
      Append;
      FieldByName(StructKeyField).Value := 5;
      FieldByName('FieldName').Value := F_DicItemOrdNum;
      FieldByName('FieldDesc').Value := 'Порядковый номер';
      FieldByName('FieldType').Value := Ord(ftInteger);
      FieldByName('Predefined').Value := true;  // означает, что поле предопределенное
      Append;
      FieldByName(StructKeyField).Value := 6;
      FieldByName('FieldName').Value := F_DicItemSyncState;
      FieldByName('FieldDesc').Value := 'Состояние синхронизации';
      FieldByName('FieldType').Value := Ord(ftInteger);
      FieldByName('Predefined').Value := true;  // означает, что поле предопределенное

      if (de <> nil) and (de.DicFields.Count > 0) then
        for i := 0 to Pred(de.DicFields.Count) do
        begin
          Append;
          FieldByName(StructKeyField).Value := i + 7;
          FieldByName('FieldName').Value := de.DicFields[i];
          fd := de.DicFields.Objects[i] as TFieldDesc;
          FieldByName('FieldDesc').Value := fd.FieldDesc;
          // Раньше поля не имели указания типа поля в структуре данных, а тип определялся "по факту".
          // Теперь должен быть указан.
          if fd.FieldType <> 0 then  // тип поля явно указан
          begin
            FieldByName('FieldType').Value := fd.FieldType;
            if fd.FieldLength <> 0 then
              FieldByName('Length').Value := fd.FieldLength;
            if fd.FieldPrecision <> 0 then
              FieldByName('Precision').Value := fd.FieldPrecision;
            if fd.ReferenceID <> 0 then
              FieldByName('ReferenceID').Value := fd.ReferenceID;
            FieldByName('HasFieldType').Value := true;
          end
          else
          begin
            // Если тип поля не указан и это "старая" струкура данных, т.е. "до редактирования"
            // то отмечаем это установкой HasFieldType = false. Новые добавленные поля должны
            // иметь HasFieldType = true. После применения изменений уже все будут иметь
            // явно указанный тип поля.
            FieldByName('HasFieldType').Value := not UseOld;
            f := de.DicItems.FieldByName(de.DicFields[i]);
            FieldByName('FieldType').Value := f.DataType;
            InitFieldType(StructData, f);
          end;
        end;
      CheckBrowseMode;
      StructData.Tag := FieldByName(StructKeyField).Value + 1;
      // Tag выполняет роль IDENTITY для этой таблицы - номер следующего ID.
      Result := true;
    end;
  except on E: Exception do
    ExceptionHandler.Raise_(E, 'Не могу создать временную таблицу для конструктора справочника',
      'CreateDicStructData');
  end;
end;

// Определяем имя нового поля и передаем обработчику OnNewRecord
// через "глобальную" переменную FStructFName.
procedure TDicDM.DicStructBeforeInsert(DataSet: TDataSet);
begin
  FStructFName := CalcDicFieldName(DataSet);
end;

procedure TDicDM.DicStructBeforeDelete(DataSet: TDataSet);
begin
  if not VarIsNull(DataSet['FieldName']) and (DataSet['Predefined']) then Abort;
end;

// Вычисляет имя следующего поля при добавлении поля в структуру справочника
// вида "DicItemValueField + номер"
function TDicDM.CalcDicFieldName(DataSet: TDataSet): string;
begin
  Result := CalcNewFieldName(DataSet, F_DicItemValue);
end;

function TDicDM.ApplyDicStructCreate(StructData: TClientDataSet): boolean;
begin
  Result := CommonApplyStructCreate(DicTablePrefix + FCurDicName, DicFieldsTableName,
    DicKeyField, DicStructPropFields, FCurDicID, StructData,
    false); // предопределенные поля не пишутся в таблицу описания полей
end;

// !!!!!!!!!!!!!!!!!!!!!!! ЭТО НА СЕРВЕРЕ !!!!!!!!!!!!!!!!!!!
// Внесение изменений в структуру таблицы справочника
// ПРИ СОЗДАНИИ НОВОГО СПРАВОЧНИКА ИЛИ ПРОЦЕССА,
// исходя из уже отредактированного набора данных с описанием
// структуры таблицы - StructData.
// Формирует SQL и выполняет его. Таблица должна быть уже создана. Вносятся только отличия
// от стандартного (минимального) справочника-сервиса.
// ТРАНЗАКЦИЯ НЕ СТАРТУЕТСЯ И НЕ ЗАВЕРШАЕТСЯ!
function TDicDM.CommonApplyStructCreate(TableName, FieldsTableName: string;
  FieldsTableKeyField: string;
  PropFields: string;      // дополнительные поля структуры
  KeyValue: integer; StructData: TClientDataSet;
  IncludePredefined: boolean): boolean;

var dq: TADOCommand;

  procedure UpdateInsert;
  begin
    dq.CommandText := 'alter table ' + TableName + ' add ' +
      StructData['FieldName'] + ' ' +
      GetFieldTypeName(StructData['FieldType'], NvlInteger(StructData['Length']),
        NvlInteger(StructData['Precision'])) + ' null';
  end;

  procedure UpdateFieldsInsert;
  var
    p: integer;
    pf, PropF: string;
    PropValues: string;
  begin
    // модифицируем таблицу описания полей
    PropValues := '';          // Обрабатываем список дополнительных свойств полей
    if PropFields <> '' then begin
      P := 1;
      while P <= Length(PropFields) do begin
        pf := DelChars(DelChars(ExtractSubstr(PropFields, P, [',']), '['), ']');
        if (StructData.FindField(pf) <> nil) then begin
          if PropValues <> '' then
            PropValues := PropValues + ', ' + FieldToStr(StructData.FieldByName(pf))
          else
            PropValues := FieldToStr(StructData.FieldByName(pf));
        end;
      end;
      PropF := ',' + PropFields;
      if PropValues <> '' then PropValues := ', ' + PropValues;
    end else
      PropF := PropFields;
    dq.CommandText := 'insert into ' + FieldsTableName + ' (' + FieldsTableKeyField +
      ', FieldName, FieldDesc' + PropF + ') values ('
       + IntToStr(KeyValue) + ', ''' + StructData['FieldName'] + ''', '''
       + NvlString(StructData['FieldDesc']) + '''' + PropValues + ')';
  end;

  procedure PrepareDQ;
  begin
    dq := TADOCommand.Create(nil);
    dq.Connection := aqAllDics.Connection;
  end;

  function AddField: boolean;
  begin
    Result := not (StructData['Predefined']
                 or ((StructData.FindField('FieldStatus') <> nil) and
                 ((StructData['FieldStatus'] = ftVirtual) or
                 (StructData['FieldStatus'] = ftCalculated))));
  end;

begin
  StructData.First;
  PrepareDQ;
  try
    while not StructData.eof do begin
      if AddField then begin
        // Добавляем само поле
        UpdateInsert;
        dq.Execute;
      end;
      if IncludePredefined or not StructData['Predefined'] then begin
        // Добавляем описание поля
        UpdateFieldsInsert;
        dq.Execute;
      end;
      StructData.Next;
    end;
    Result := true;
  finally
    dq.Free;
  end;
end;

function TDicDM.ApplyDicStructChange(StructData: TClientDataSet; de: TDictionary): boolean;
var
  OldStructData: TClientDataSet;
begin
  // Сохраняем старую структуру
  Result := CreateDicStructData(OldStructData, de, true);
  if Result then
  try
    Result := CommonApplyStructChange(DicTablePrefix + de.Name, F_DicItemID,
      DicFieldsTableName, DicKeyField,
      DicPredefFieldsSQL, DicPredefFieldsStr,
      DicStructPropFields,
      FCurDicID,
      OldStructData, StructData, true);
  finally
    if OldStructData <> nil then OldStructData.Close;
  end;
end;

// Применение изменений структуры справочника или процесса на основе сравнения
// старой структуры и новой.
function TDicDM.CommonApplyStructChange(TableName, TableKeyField,
  FieldsTableName, FieldsTableKeyField,
  PredefFieldsSQL, PredefFields: string;
  PropFields: string;      // дополнительные поля структуры
  KeyValue: integer;
  OldStructData, StructData: TClientDataSet; UseIdentity: boolean): boolean;

type
  TIndexDefRec = record
    Name: string;
    Clustered: boolean;
    Keys: string;
  end;

var
  str: string;
  dq: TADOCommand;
  TrigList: TStringList;
  //RestoreTr: boolean;
  IndexDefs: array of TIndexDefRec;
  RestoreInd: boolean;

const TmpPrefix = 'Tmp_';

  procedure PrepareDQ;
  begin
    dq := TADOCommand.Create(nil);
    dq.Connection := aqAllDics.Connection;
    dq.CommandTimeout := ConnectInfo.CommandTimeout;
  end;

  procedure PrepareDropTmpSQL;
  begin
    dq.CommandText := 'if exists (select * from dbo.sysobjects where id = object_id(N''' +
      TmpPrefix + TableName + ''') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)' +
      ' drop table ' + TmpPrefix + TableName;
  end;

  function NoUpdate: boolean;
  begin
    if StructData.FindField('FieldStatus') = nil then
      Result := StructData['Predefined']
    else
      Result := StructData['Predefined'] or
              ((StructData.FindField('FieldStatus') <> nil) and
              ((StructData['FieldStatus'] = ftVirtual) or
              (StructData['FieldStatus'] = ftCalculated)));
  end;

  procedure PrepareTmpSQL;
  begin
    str := 'create table ' + TmpPrefix + TableName + ' (' + PredefFieldsSQL;
    StructData.First;
    while not StructData.eof do begin
      if not IsWordPresent(StructData['FieldName'], PredefFieldsSQL, [' ', ',', ')', '('])
         and not NoUpdate then
        str := str + ', ' + StructData['FieldName'] + ' ' +
          GetFieldTypeName(StructData['FieldType'], NvlInteger(StructData['Length']),
          NvlInteger(StructData['Precision'])) + ' null';
      StructData.Next;
    end;
    dq.CommandText := str + ') on [primary]';
  end;

  function DifFields(os, s: TClientDataSet): boolean;
  var
    n, i: integer;
    w: string;
  begin
    Result := not NvlBoolean(S['Predefined']);
    if Result then
    begin
      Result := (S['FieldName'] <> OS['FieldName']) or (S['FieldDesc'] <> OS['FieldDesc'])
        or (S['FieldType'] <> OS['FieldType']) or (S['Length'] <> OS['Length'])
        or (S['Precision'] <> OS['Precision']);
      // Если все равны и есть еще такое поле, то сравнить по нему
      if not Result and (S.FindField('HasFieldType') <> nil) then
        Result := S['HasFieldType'] <> OS['HasFieldType'];
      // Если опять все равны, то по остальным
      if not Result then begin
        n := WordCount(PropFields, [',']);
        for i := 1 to n do begin
          w := ExtractWord(i, PropFields, [',']);
          w := DelChars(DelChars(w, '['), ']');
          if S.FindField(w) <> nil then begin
            Result := Result or (S[w] <> OS[w]);
            if Result then break;
          end;
        end;
      end;
    end;
  end;

  procedure ExecCopySQL;
  var
    SNew, SOld, PropAssign, pf, pf1: string;
    i, p: integer;
    nst, ost: integer;
  begin
    //Result := true;
//    Updated := false;
    for i := 1 to Pred(OldStructData.Tag) do
      // Становимся на нужную запись
      if OldStructData.Locate(StructKeyField, i, []) and
        StructData.Locate(StructKeyField, i, []) and
          // и если параметры поля изменились, то...
        DifFields(OldStructData, StructData) then begin
          // модифицируем сразу таблицу описания полей
          dq.CommandText := 'update ' + FieldsTableName + ' set ';
          if not VarIsNull(StructData['FieldDesc']) then
            dq.CommandText := dq.CommandText + 'FieldDesc = ''' + StructData['FieldDesc'] + ''', ';
          dq.CommandText := dq.CommandText + 'FieldName = ''' + StructData['FieldName'] + '''';
          // Обрабатываем список дополнительных свойств полей
          if PropFields <> '' then begin
            P := 1;
            PropAssign := '';
            while P <= Length(PropFields) do begin
              pf := ExtractSubstr(PropFields, P, [',']);
              pf1 := DelChars(DelChars(pf, '['), ']');
              if (StructData.FindField(pf1) <> nil) then begin
                if PropAssign <> '' then
                  PropAssign := PropAssign + ', ' + pf + ' = '
                    + FieldToStr(StructData.FieldByName(pf1))
                else
                  PropAssign := pf + ' = ' + FieldToStr(StructData.FieldByName(pf1));
              end;
            end;
            if PropAssign <> '' then
              dq.CommandText := dq.CommandText + ', ' + PropAssign;
          end;
          dq.CommandText := dq.CommandText + ' where '
            + FieldsTableKeyField + ' = ' + IntToStr(KeyValue) + ' and FieldName = '''
            + OldStructData['FieldName'] + '''';
          dq.Execute;
        // Updated := true;
      end;
    SNew := PredefFields;
    SOld := PredefFields;
    // Скопировать в созданную временную таблицу поля, которые есть в обеих,
    // кроме виртуальных и вычисляемых полей (только для процессов, не для справочников),
    // т.к их нет в БД.
    for i := 1 to Pred(StructData.Tag) do
      if StructData.Locate(StructKeyField, i, []) and
         OldStructData.Locate(StructKeyField, i, []) then
      begin
          if NoUpdate then continue;
          SNew := SNew + ', ' + StructData['FieldName'];
          if DifFields(OldStructData, StructData) then
          begin // преобразование типа или статуса
            if StructData.FindField('FieldStatus') <> nil then
            begin
              nst := StructData['FieldStatus'];
              ost := OldStructData['FieldStatus'];
            end else begin
              nst := 1;
              ost := 1;
            end;
            // Если поля раньше физически не было в таблице, а теперь есть,
            // то вставлять NULL.
            if (nst <> ost) and
             (((nst = ftIndependent) or (nst = ftData)) and
              ((ost = ftVirtual) or (ost = ftCalculated))) then
              SOld := SOld + ', null'
            else
              SOld := SOld + ', ' + 'convert(' +
                GetFieldTypeName(StructData['FieldType'], NvlInteger(StructData['Length']),
                  NvlInteger(StructData['Precision'])) + ', ' + OldStructData['FieldName'] + ')'
          end
          else
            SOld := SOld + ', ' + OldStructData['FieldName'];
      end;
    dq.CommandText := 'if exists(select * from ' + TableName + ') ' +
       'insert into ' + TmpPrefix + TableName + '(' + SNew + ') ' +
       'select ' + SOld + ' from ' + TableName + ' TABLOCKX';
    dq.Execute;
      { IF EXISTS(SELECT * FROM dbo.Dic_XXXXX)
           EXEC('INSERT INTO dbo.Tmp_Dic_XXXXX (Code, Name, A2, A3)
                  SELECT Code, Name, A2, CONVERT(float(53), A3) FROM dbo.Dic_XXXXX TABLOCKX') }
  end;

  procedure ExecAddSQL;
  var
    i, p: integer;
    pf, PropF: string;
    PropValues: string;
  begin
    //Result := true;
    for i := 1 to StructData.Tag do
      if StructData.Locate(StructKeyField, i, []) and
        not OldStructData.Locate(StructKeyField, i, []) then
          begin
            // модифицируем таблицу описания полей
            PropValues := '';          // Обрабатываем список дополнительных свойств полей
            if PropFields <> '' then begin
              P := 1;
              while P <= Length(PropFields) do begin
                pf := DelChars(DelChars(ExtractSubstr(PropFields, P, [',']), ']'), '[');
                if (StructData.FindField(pf) <> nil) then begin
                  if PropValues <> '' then
                    PropValues := PropValues + ', ' + FieldToStr(StructData.FieldByName(pf))
                  else
                    PropValues := FieldToStr(StructData.FieldByName(pf));
                end;
              end;
              PropF := ',' + PropFields;
              if PropValues <> '' then PropValues := ', ' + PropValues;
            end else
              PropF := PropFields;
            dq.CommandText := 'insert into ' + FieldsTableName + ' (' + FieldsTableKeyField +
              ', FieldName, FieldDesc' + PropF + ') values ('
               + IntToStr(KeyValue) + ', ''' + StructData['FieldName'] + ''', '''
               + StructData['FieldDesc'] + '''' + PropValues + ')';
            dq.Execute;
          {except
            on E: Exception do begin
              Result := false;
              ProcessError(E);
              Exit;
            end;}
          end;
  end;

  procedure ExecDeleteSQL;
  var
    i: integer;
  begin
    for i := 1 to StructData.Tag do
      if OldStructData.Locate(StructKeyField, i, []) and
        not StructData.Locate(StructKeyField, i, []) then
          begin
            // модифицируем только таблицу описания полей,
            // т.к. удаленные поля просто не создаются в новой таблице (см. ExecCopySQL)
            dq.CommandText := 'delete from ' + FieldsTableName +
             ' where ' + FieldsTableKeyField + ' = ' + IntToStr(KeyValue) + ' and FieldName = ''' +
             OldStructData['FieldName'] + '''';
            dq.Execute;
          end;
  end;

  procedure PrepareDropSQL;
  begin
    dq.CommandText := 'drop table ' + TableName;
  end;

  procedure PrepareRenameSQL;
  begin
    dq.CommandText := 'exec sp_rename N''' + TmpPrefix + TableName + ''', N''' +
      TableName + ''', ''OBJECT''';
  end;

  procedure PrepareKeySQL;
  begin
    dq.CommandText := 'ALTER TABLE ' + TableName + ' ADD CONSTRAINT PK_' +
      TableName + ' PRIMARY KEY NONCLUSTERED (' + TableKeyField + ') ON [PRIMARY]';
  end;

  procedure ExecSetIdInsert(_On: boolean);
  begin
    //Result := true;
    begin
      dq.CommandText := 'set identity_insert ' + TmpPrefix + TableName;
      if _On then dq.CommandText := dq.CommandText + ' on'
      else dq.CommandText := dq.CommandText + ' off';
      dq.Execute;
    end;
  end;

  function StructModified: boolean;
  begin
    StructData.First;
    OldStructData.First;
    Result := StructData.RecordCount <> OldStructData.RecordCount;
    if Result then Exit;
    while not StructData.eof do
    begin
      Result := DifFields(StructData, OldStructData);
      if Result then Exit;  // прекращаем проверку если найдены различия

      StructData.Next;
      OldStructData.Next;
    end;
  end;

  {procedure SaveTriggers;
  var
    q, qt: TADOQuery;  // Не используем Command, как в остальных процедурах
    TrigText: TStringList;
    s: string;
  begin
    RestoreTr := false;
    try
      q := TADOQuery.Create(nil);
      q.Connection := aqDics.Connection;
      q.SQL.Add('exec sp_helptrigger ' + TableName);
      q.Open;
      if q.RecordCount > 0 then begin
        TrigList := TStringList.Create;
        qt := TADOQuery.Create(nil);
        try
          qt.Connection := aqDics.Connection;
          q.First;
          while not q.eof do
          try
            qt.SQL.Clear;
            qt.SQL.Add('sp_helptext ''' + q['trigger_name'] + '''');
            qt.Open;
            if qt.RecordCount > 0 then begin
              TrigText := TStringList.Create;
              qt.First;
              while not qt.eof do
              try
                s := qt.FieldByName('Text').AsString;
                if Length(s) > 2 then begin
                  if s[Length(s) - 1] = #$D then s := Copy(s, 1, Length(s) - 2);
                  TrigText.Add(s);
                end;
              finally
                qt.Next;
              end;
            end;
            TrigList.AddObject(q['trigger_name'], TrigText);
            qt.Close;
          finally
            q.Next;
          end;
        finally
          if qt <> nil then qt.Free;
          if (TrigList <> nil) and (TrigList.Count = 0) then begin
            RestoreTr := false;
            TrigList.Free;
          end else if TrigList <> nil then
            RestoreTr := true;
        end;
      end;
    finally
      q.Free;
    end;
  end;}

  {procedure RestoreTriggers;
  var
    i: integer;
    q: TADOQuery;
  begin
    q := nil;
    try
      q := TADOQuery.Create(nil);
      q.Connection := aqDics.Connection;
      for i := 0 to Pred(TrigList.Count) do begin
        q.SQL.Clear;
        q.SQL.Assign(TrigList.Objects[i] as TStringList);
        q.ExecSQL;
      end;
    finally
      TrigList.Free;
      q.Free;
    end;
  end;}

  procedure SaveIndexes;
  var
    q: TADOQuery;  // Не используем Command, как в остальных процедурах
    s: string;
    rec: TIndexDefRec;
  begin
    RestoreInd := false;
    try
      q := TADOQuery.Create(nil);
      q.Connection := aqAllDics.Connection;
      q.SQL.Add('exec sp_helpindex ' + TableName);
      q.Open;
      if q.RecordCount > 0 then
      begin
        q.First;
        while not q.eof do
        try
          s := q['index_description'];
          if Pos('primary key', s) = 0 then
          begin
            rec.Name := q['index_name'];
            rec.Keys := q['index_keys'];
            rec.Clustered := Pos('nonclustered', s) = -1;
            SetLength(IndexDefs, Length(IndexDefs) + 1);
            IndexDefs[Length(IndexDefs) - 1] := rec;
          end;
        finally
          q.Next;
        end;
        RestoreInd := Length(IndexDefs) > 0;
      end;
    finally
      q.Free;
    end;
  end;

  procedure RestoreIndexes;
  var
    i: integer;
    q: TADOQuery;
    IndexText: string;
  begin
    q := nil;
    try
      q := TADOQuery.Create(nil);
      q.Connection := aqAllDics.Connection;
      for i := Low(IndexDefs) to High(IndexDefs) do
      begin
        IndexText := 'CREATE ';
        if IndexDefs[i].Clustered then
          IndexText := IndexText + 'CLUSTERED'
        else
          IndexText := IndexText + 'NONCLUSTERED';
        IndexText := IndexText + ' INDEX ' + IndexDefs[i].Name + ' ON ' + TableName
           + ' (' + IndexDefs[i].Keys + ')';
        q.SQL.Clear;
        q.SQL.Text := IndexText;
        q.ExecSQL;
      end;
    finally
      q.Free;
    end;
  end;

begin
  Result := false;
  if StructModified then
  begin
    PrepareDQ;
    try
      ExecDeleteSQL;// then Exit;   // сначала удаление полей!
      ExecAddSQL;// then Exit;   // потом новые поля
      // изменение полей, которые есть и в старой структуре и в новой
      PrepareDropTmpSQL;   // удаление временной таблицы (вряд ли она сущ., конечно...)
      dq.Execute;// except Exit end;
      PrepareTmpSQL;        // создание временной таблицы
      dq.Execute;// except Exit end;
      if UseIdentity then
        ExecSetIdInsert(true);// then Exit;
      ExecCopySQL;// then Exit;   // переименование и преобразование полей
//      if Updated then begin
      if UseIdentity then
        ExecSetIdInsert(false);// then Exit;
      //SaveTriggers;
      SaveIndexes;
      PrepareDropSQL;
      dq.Execute;// except Exit end;
      PrepareRenameSQL;
      dq.Execute;// except Exit end;
      PrepareKeySQL;
      dq.Execute;// except Exit end;
      //if RestoreTr then RestoreTriggers;
      if RestoreInd then RestoreIndexes;
      Result := true;
    finally
      dq.Free;
    end;
  end else
    Result := true; 
end;

procedure TDicDM.RefreshDics;
begin
  CloseAllDics;      // Перечитываем список справочников
  OpenAllDics;
end;

// Модифицирует параметры справочника и компонент справочника в списке
function TDicDM.ModifyDicTable(DicID: integer; DicName, DicDesc: string; MultiDim: boolean;
  StructData: TClientDataSet; de: TDictionary): integer;

var
  pc, TransStarted: boolean;

  procedure Alert(E: Exception);
  begin
    Database.RollbackTrans;
    ExceptionHandler.Raise_(E, 'Ошибка при модификации справочника', 'ModifyDicTable');
  end;

  function PropsChanged: boolean;
  begin
    Result := (DicName <> de.Name) or (DicDesc  <> de.Desc);
  end;

begin
  Result := -1;
  pc := PropsChanged;

  if pc then
  begin
    aupUpdateDic.Parameters.ParamByName('@DicID').Value := DicID;
    aupUpdateDic.Parameters.ParamByName('@DicName').Value := DicName;
    aupUpdateDic.Parameters.ParamByName('@DicDesc').Value := DicDesc;
    aupUpdateDic.Parameters.ParamByName('@DicBuiltIn').Value := false;
    // теперь обновляем компонент
    de.Name := DicName;
    de.Desc := DicDesc;
  end;

  TransStarted := not Database.InTransaction;
  if TransStarted then
    Database.BeginTrans;

  try
    if pc then aupUpdateDic.ExecProc;
    FCurDicName := DicName;
    FCurDicID := DicID;
    ApplyDicStructChange(StructData, de);
    if TransStarted then
      Database.CommitTrans;

    if not Database.InTransaction then
      AccessManager.SetUserRights;  // в транзакции нельзя запускать

    Result := DicID;
  except
    //on E: EDatabaseError do Alert(E);
    if TransStarted and Database.InTransaction then
      Database.RollbackTrans;
  end;
end;

// Создает таблицу для табличного справочника и компонент справочника в списке
// DIM НЕ ИСПОЛЬЗУЕТСЯ
function TDicDM.CreateNewDictionary(DicName, DicDesc: string; MultiDim: boolean;
  ParentID: integer; StructData: TClientDataSet): integer;
var
  de: TDictionary;
begin
  Result := -1;
  try
    aupNewDic.Parameters.ParamByName('@DicName').Value := DicName;
    aupNewDic.Parameters.ParamByName('@DicDesc').Value := DicDesc;
    aupNewDic.Parameters.ParamByName('@DicBuiltIn').Value := false;
    aupNewDic.Parameters.ParamByName('@ParentID').Value := ParentID;
    if not Database.InTransaction then Database.BeginTrans;
    aupNewDic.ExecProc;
    // Определяем ключ справочника в списке
    FCurDicID := aupNewDic.Parameters[0].Value;
    FCurDicName := DicName;  // внутреннее имя справочника
    StructData.CheckBrowseMode;
    ApplyDicStructCreate(StructData);
    Database.CommitTrans;
    if not Database.InTransaction then
      AccessManager.SetUserRights;
  except
    on E: Exception do
    begin
      Database.RollbackTrans;
      ExceptionHandler.Raise_(E, 'Ошибка при создании справочника', 'CreateNewDictionary');
    end;
  end;
  Result := FCurDicID;
end;

// При добавлении новой записи устанавливает вычисленный заранее код
procedure TDicDM.cdCurDicNewRecord(DataSet: TDataSet);
begin
  try
    DataSet[F_DicItemCode] := DicCode;
    DataSet[F_DicItemVisible] := true;
    DataSet[F_DicItemName] := '';
  except on E: Exception do
    ExceptionHandler.Raise_(E, 'Ошибка при добавлении записи в ' + DataSet.Name,
      'cdCurDicNewRecord');
  end;
end;

// Перед добавлением новой записи вычисляет код записи
procedure TDicDM.cdCurDicBeforeInsert(DataSet: TDataSet);
begin
  DicCode := CalcDicCode(DataSet, F_DicItemCode);
end;

// вычисляет код записи - следующий по порядку
function TDicDM.CalcDicCode(DataSet: TDataSet; FieldName: string): integer;
var k: integer;
begin
  Result := 0;
  if not DataSet.Active then Exit;
  DataSet.CheckBrowseMode;
  // Если пусто - код 1
  if DataSet.IsEmpty then begin Result := 1; Exit; end;
  DataSet.DisableControls;
  try
    DataSet.First;
    k := 0;
    while not DataSet.EOF do
    begin
      if k < DataSet[FieldName] then k := DataSet[FieldName];
      DataSet.Next;
    end;
  finally
    DataSet.EnableControls;
  end;
  Result := k + 1;
end;

procedure TDicDM.pvMultiTableBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
  var Applied: Boolean);
begin
  Applied := UpdateKind <> ukModify;
end;

// APPSERVER !!!!!!!!!!!!!!!!!!!!!!!
// Для справочника-размерности
procedure TDicDM.pvCurDimDicBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
  var Applied: Boolean);

  function UpdateInsert: boolean;
  var
    SrcD, i: integer;
    scmd, s: string;
  begin
    Result := false;
    // параметры должны быть установлены перед обновлением данных в ApplyCurDicElement!
    if (UMultiDic = nil) or (UDimDic = nil) then Exit;
    SrcD := ExecSrcDimDlg(DeltaDS[F_DicItemCode]);
    scmd := 'insert into ' + DicMultiTablePrefix + UMultiDic.Name + ' (';
    i := 1;
    while UMultiDic.MultiItems.FindField(DimValueField + IntToStr(i)) <> nil do begin
      if i > 1 then scmd := scmd + ',';
      scmd := scmd + DimValueField + IntToStr(i);
      Inc(i);
    end;
    if SrcD > 0 then begin // Если копируем данные с другого значения размерности
      i := 1;
      while UMultiDic.MultiItems.FindField(F_DicItemValue + IntToStr(i)) <> nil do begin
        scmd := scmd + ',' + F_DicItemValue + IntToStr(i);
        Inc(i);
      end;
    end;
    scmd := scmd + ')';
    s := ' select ';
    i := 1;
    while UMultiDic.MultiItems.FindField(DimValueField + IntToStr(i)) <> nil do begin
      if i > 1 then s := s + ',';
      if UDimCode = i then
        s := s + IntToStr(DeltaDS[F_DicItemCode]) // та размерность, в которую добавляем
      else s := s + DimValueField + IntToStr(i);
      Inc(i);
    end;
    // Повторяем то же, что было выше
    if SrcD > 0 then begin // Если копируем данные с другого значения размерности
      i := 1;
      while UMultiDic.MultiItems.FindField(F_DicItemValue + IntToStr(i)) <> nil do begin
        s := s + ',' + F_DicItemValue + IntToStr(i);
        Inc(i);
      end;
    end;
    s := s + ' from ' + DicMultiTablePrefix + UMultiDic.Name + ' where ' +
           DimValueField + IntToStr(UDimCode) + ' = ';
    if SrcD > 0 then s := s + IntToStr(SrcD)
    else s := s + IntToStr(DeltaDS[F_DicItemCode] - 1);
    //try
      Database.ExecuteNonQuery(scmd + s);
      Result := true;
    {except
      on E: EDatabaseError do ProcessError(E);
    end;}
  end;

  function UpdateDelete: boolean;
  begin
    Result := false;
    // параметры должны быть установлены перед обновлением данных в ApplyCurDicElement!
    if (UMultiDic = nil) or (UDimDic = nil) then Exit;
    //try
      // Удаляем все связанное с этим значением
      Database.ExecuteNonQuery('delete from ' + DicMultiTablePrefix + UMultiDic.Name + ' where ' +
        DimValueField + IntToStr(UDimCode) + ' = ' +
        IntToStr(DeltaDS.FieldByName(F_DicItemCode).OldValue));
      Result := true;
    {except
      on E: EDatabaseError do ProcessError(E);
    end;}
  end;

begin
  Applied := false;
  if UpdateKind = ukInsert then begin
    UpdateInsert;
    //Applied := true;
  end else if UpdateKind = ukDelete then begin
    UpdateDelete;
    //Applied := true;
  end;
end;

{procedure TDicDM.pvCurDicUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
  var Applied: Boolean);
var
  I: Integer;
  f: TField;
begin
  for I := 0 to DeltaDS.Fields.Count - 1 do    // Iterate
  begin
    f := DeltaDS.Fields[i];
    if f.FieldName = DicItemIDField then
      f.ProviderFlags := [pfInKey, pfInWhere]
    else
      f.ProviderFlags := [pfInUpdate];
  end;
end;}

procedure TDicDM.pvStructBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
  var Applied: Boolean);
begin
  Applied := true;
end;

procedure TDicDM.OpenDataSet(DataSet: TDataSet);
begin
  Database.OpenDataSet(DataSet);
end;

procedure TDicDM.DeleteDic(DicName: string);
var
  de: TDictionary;
begin
  try
    aupDelDic.Parameters.ParamByName('@DicName').Value := DicName;
    aupDelDic.ExecProc;
  except on E: Exception do
    ExceptionHandler.Raise_(E, 'Ошибка при удалении справочника');
  end;
  //CloseDicLists;      // Перечитываем список справочников
  //OpenDicLists;
end;

end.
