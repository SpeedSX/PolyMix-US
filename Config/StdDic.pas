unit StdDic;

interface

uses Classes, Db, DbClient, Variants, MemTableEh,

  CalcUtils, DicObj, NotifyEvent, CalcSettings, PmDictionaryList;

const
  // поля справочника состояний
  DicStateColorIndex = 1;
  DicStateImageIndex = 2;
  DicStateFileIndex = 3;
  DicStateDisabledImageIndex = 4;
  DicStateDisabledFileIndex = 5;
  DicStateDefaultIndex = 6;
  DicStateIsFinalFieldIndex = 7;

const
  partNoBinding = 1002;

function DicCodesToArray(de: TDictionary): TIntArray;
function StateListToArray(sl: TStringList): TIntArray; // пока не используется

function GetPayStateFilter(PayState: variant): string;

type
  TStandardDics = class
    FStdDicsChanged: TNotifier;
    FDicsCreatedID: TNotifyHandlerID;
    procedure UpdateAllOrderStates;
    procedure DoneAllOrderStates;
    procedure Update(Sender: TObject);
  public
    const
      SpecialJob_Unscheduled = 999;
      FN_MatUnitCode = 1;
    var
      //dePayer,
      //dePaper,
      deParts,
      dePayKind,     // вид оплаты
      deOrderState,
      deProcessExecState,
      dePayState,
      deInfoSource,
      deEquip,
      deEquipGroup,
      deSpecialJob,  // специальные работы, добавляемые в план
      deEquipTime,   // смены работы оборудования
      deEquipGroupTime,   // смены работы оборудования по группам

      // В этом списке хранятся счета для использования в "Состоянии оплаты".
      // Он может меняться при работе и НЕ сохраняется в справочнике.
      // НE создается при загрузке справочника.
      deAccounts,
      deProfessions,  // специальности
      deEmployees,    // сотрудники
      deDepartments,  // подразделения
      deOperators,    // операторы оборудования
      deTSColors, deTSKind, deTSChar,  // Справочники для компонентов расширенного шифра заказа (оригинальная идея "Таких Справ")
      deExternalMaterials,   // импортированные номенклатуры материалов
      deExternalProducts,    // импортированные номенклатуры продукции
      deContragentType,      // вид контрагента
      deContragentStatus,    // категория контрагента
      deContragentActivity,  // вид деятельности контрагента
      deMatCats,             // категории материалов
      deMatUnits,            // единицы измерения материалов
      deMatGroups,           // группы материалов
      dePersonType,          // вид контакта
      deWarehouse,            // склад
      deParam1,
      deParam2,
      deParam3,
      deContragentAttrPerm    // УкрСіч - доступ до зміни параметра 'Неіснуючий'
      : TDictionary;

      OrderStates: TStringList;  // В этот список считывается содержимое справочника OrderState
                                 // для ускорения работы. Список заполняется кодами справочника
                                 // и объектами типа TOrderState
      ProcessExecStates: TStringList;  // В этот список считывается содержимое справочника ServiceState
                                    // ..... (см. выше)
      PayStates: TStringList;  // В этот список считывается содержимое справочника PayState
                                  // ..... (см. выше)
    // Справочник основных состояний оплаты. Получается фильтрацией справочника всех состояний
    // Вызывающий метод отвечает за освобождение памяти.
    function CreateAutoPayStateData(Owner: TComponent): TDataSet;

    // Справочник случаев оплаты. Получается фильтрацией справочника всех состояний
    // Вызывающий метод отвечает за освобождение памяти.
    function CreateManualPayStateData(Owner: TComponent): TDataSet;

    constructor Create;
    destructor Destroy; override;
    function GetDefaultPayType: integer;

    property StdDicsChanged: TNotifier read FStdDicsChanged;

  end;

implementation

uses SysUtils, PmStates, RDBUtils, PmConfigManager;

const
  dePartName = 'Parts';
  deDummyName = 'DummyInt';
  deOrderStateName = 'OrderState';
  deProcessExecStateName = 'ServiceState';
  dePayStateName = 'OrderPayState';
  deInfoSourceName = 'CustInfoSource';
  deEquipName = 'Equip';
  deEquipGroupName = 'EquipGroup';
  deSpecialJobName = 'SpecialJob';
  deEquipTimeName = 'EquipTime';
  deEquipGroupTimeName = 'EquipGroupTime';
  dePayKindName = 'Cash';
  deProfessionsName = 'Professions';
  deEmployeesName = 'Employees';
  deDepartmentsName = 'Departments';
  deOperatorsName = 'Operators';
  deTSColorsName = 'TSColors';
  deTSKindName = 'TSKind';
  deTSCharName = 'TSChar';
  deExternalMaterialsName = 'ExternalMaterials';
  deExternalProductsName = 'ExternalProducts';
  deContragentTypeName = 'ContragentType';
  deContragentStatusName = 'ContragentStatus';
  deContragentActivityName = 'ContragentActivity';
  deMatCatName = 'MaterialCat';
  deMatUnitName = 'MaterialUnit';
  deMatGroupName = 'MaterialGroup';
  dePersonTypeName = 'PersonType';
  deWarehouseName = 'Warehouse';
  deParam1Name = 'MatParam1';
  deParam2Name = 'MatParam2';
  deParam3Name = 'MatParam3';
  deContragentAttrPermName = 'ContragentAttrPermissions';

function DicCodesToArray(de: TDictionary): TIntArray;
var
  i: integer;
  R: TIntArray;
begin
  SetLength(R, 0);
  de.DicItems.First;
  i := 0;
  while not de.DicItems.Eof do
  begin
    if de.CurrentEnabled then
    begin
      SetLength(R, i + 1);
      R[i] := de.CurrentCode;
      Inc(i);
    end;
    de.DicItems.Next;
  end;
  Result := R;
end;

function StateListToArray(sl: TStringList): TIntArray;
begin
{  SetLength(Result, sl.Count);
  for i := 0 to Pred(sl.Count) do
    Result[i] := StrToInt(sl[i])}
end;

// Справочник основных состояний оплаты. Получается фильтрацией справочника всех состояний
// Вызывающий метод отвечает за освобождение памяти.
function TStandardDics.CreateAutoPayStateData(Owner: TComponent): TDataSet;
var
  //cdAutoPayState: TClientDataSet;
  cdAutoPayState: TMemTableEh;
begin
  //cdAutoPayState := TClientDataSet.Create(Owner);
  cdAutoPayState := TMemTableEh.Create(Owner);
  //cdAutoPayState.CopyStructure(dePayState.DicItems);
  cdAutoPayState.ExternalMemData := dePayState.DicItems;
  cdAutoPayState.Active := true;
  //cdAutoPayState.CloneCursor(dePayState.DicItems, true);
  Result := cdAutoPayState;
end;

// Справочник случаев оплаты. Получается фильтрацией справочника всех состояний
// Вызывающий метод отвечает за освобождение памяти.
function TStandardDics.CreateManualPayStateData(Owner: TComponent): TDataSet;
var
  //cdSubPayState: TClientDataSet;
  cdSubPayState: TMemTableEh;
begin
  //cdSubPayState := TClientDataSet.Create(Owner);
  //cdSubPayState.CloneCursor(dePayState.DicItems, true);
  cdSubPayState := TMemTableEh.Create(Owner);
  //cdSubPayState.CopyStructure(dePayState.DicItems);
  cdSubPayState.ExternalMemData := dePayState.DicItems;
  cdSubPayState.Filter := 'A8 <> null';
  cdSubPayState.Filtered := true;
  cdSubPayState.Active := true;
  Result := cdSubPayState;
end;

function GetPayStateFilter(PayState: variant): string;
begin
  if VarIsNull(PayState) then
    Result := '0=1'
  else
    Result := 'A8=' + IntToStr(PayState);
end;

procedure TStandardDics.Update(Sender: TObject);
var
  DictionaryList: TDictionaryList;
begin
  // Создаем списки для состояний заказа и процессов
  //CreateAllOrderStates;
  //DoneAllOrderStates;
  UpdateAllOrderStates;
  DictionaryList := TConfigManager.Instance.DictionaryList;
  deParts := DictionaryList[dePartName];
  deInfoSource := DictionaryList[deInfoSourceName];
  deEquip := DictionaryList[deEquipName];
  deEquipGroup := DictionaryList[deEquipGroupName];
  deSpecialJob := DictionaryList[deSpecialJobName];
  deEquipTime := DictionaryList[deEquipTimeName];
  deEquipGroupTime := DictionaryList[deEquipGroupTimeName];
  dePayKind := DictionaryList[dePayKindName];
  deEmployees := DictionaryList[deEmployeesName];
  deDepartments := DictionaryList[deDepartmentsName];
  deOperators := DictionaryList[deOperatorsName];
  deProfessions := DictionaryList[deProfessionsName];
  deTSColors := DictionaryList[deTSColorsName];
  deTSKind := DictionaryList[deTSKindName];
  deTSChar := DictionaryList[deTSCharName];
  deExternalMaterials := DictionaryList[deExternalMaterialsName];
  deExternalProducts := DictionaryList[deExternalProductsName];
  deContragentType := DictionaryList[deContragentTypeName];
  deContragentStatus := DictionaryList[deContragentStatusName];
  deContragentActivity := DictionaryList[deContragentActivityName];
  deMatCats := DictionaryList[deMatCatName];
  deMatUnits := DictionaryList[deMatUnitName];
  deMatGroups := DictionaryList[deMatGroupName];
  dePersonType := DictionaryList[dePersonTypeName];
  deWarehouse := DictionaryList[deWarehouseName];
  deParam1 := DictionaryList[deParam1Name];
  deParam2 := DictionaryList[deParam2Name];
  deParam3 := DictionaryList[deParam3Name];
  deContragentAttrPerm := DictionaryList[deContragentAttrPermName];

  FStdDicsChanged.Notify(Self);
end;

procedure TStandardDics.UpdateAllOrderStates;
var
  DictionaryList: TDictionaryList;
begin
  DictionaryList := TConfigManager.Instance.DictionaryList;

  deOrderState := DictionaryList[deOrderStateName];
  deProcessExecState := DictionaryList[deProcessExecStateName];
  dePayState := DictionaryList[dePayStateName];
  UpdateOrderStates(OrderStates, deOrderState, Options.DefOrderExecState,
    DicStateColorIndex, DicStateImageIndex, DicStateFileIndex,
    DicStateDisabledImageIndex, DicStateDisabledFileIndex, DicStateDefaultIndex,
    DicStateIsFinalFieldIndex);
  UpdateOrderStates(ProcessExecStates, deProcessExecState, Options.DefProcessExecState,
    DicStateColorIndex, DicStateImageIndex, DicStateFileIndex,
    DicStateDisabledImageIndex, DicStateDisabledFileIndex, DicStateDefaultIndex,
    -1);
  UpdateOrderStates(PayStates, dePayState, Options.DefOrderPayState,
    DicStateColorIndex, DicStateImageIndex, DicStateFileIndex,
    DicStateDisabledImageIndex, DicStateDisabledFileIndex, DicStateDefaultIndex,
    -1);
end;

procedure TStandardDics.DoneAllOrderStates;
begin
  DoneOrderStates(OrderStates);
  DoneOrderStates(ProcessExecStates);
  DoneOrderStates(PayStates);
end;

constructor TStandardDics.Create;
begin
  inherited;
  FStdDicsChanged := TNotifier.Create;
  FDicsCreatedID := TConfigManager.Instance.DictionaryList.DictionariesCreated.RegisterHandler(Update);
end;

destructor TStandardDics.Destroy;
begin
  FreeAndNil(FStdDicsChanged);
  DoneAllOrderStates;
  TConfigManager.Instance.DictionaryList.DictionariesCreated.UnregisterHandler(FDicsCreatedID);
  inherited;
end;

function TStandardDics.GetDefaultPayType: integer;
var
  de: TDictionary;
  PayType: integer;
begin
  // Ищем вид оплаты по умолчанию
  de := dePayKind;
  PayType := 0;
  de.DicItems.First;
  while not de.DicItems.Eof do
  begin
    if de.CurrentEnabled and NvlBoolean(de.CurrentValue[1]) then
    begin
      PayType := de.CurrentCode;
      break;
    end;
    de.DicItems.Next;
  end;
  Result := PayType;
end;

end.
