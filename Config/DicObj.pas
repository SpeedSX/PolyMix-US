unit DicObj;

interface

uses Classes, Variants, SysUtils, Graphics, DBCLient, DB, Provider, Menus, RDialogs,
  Dialogs, MemTableEh, DataDriverEh;

const
  DicItemNameSize = 200;
  F_DicItemCode = 'Code';
  F_DicItemID = 'DicItemID';
  F_DicItemName = 'Name';
  F_DicItemParentCode = 'ParentCode';
  F_DicItemSyncState = 'SyncState';
  F_DicItemOrdNum = 'OrdNum';
  DicPredefFieldsSQL  = 'DicItemID int identity(1,1), Code int not null, Name varchar(200) not null, Visible bit null, ParentCode int null, OrdNum int null, SyncState int null';
  DicPredefFieldsStr = 'DicItemID,Code,Name,Visible,ParentCode,OrdNum,SyncState';  // без пробела!
  F_DicItemValue = 'A';
  F_DicItemVisible = 'Visible';
  DimValueField = 'D';
  MaxDimensions = 255;   // не принципиально, можно и другое число

const
  ftDictionary = 100;
  ftProcess = 101;
  ftProcessGrid = 102;

type
  TFieldDesc = class(TObject)
    FieldDesc: string;
    FieldType: integer;
    ReferenceID, FieldLength, FieldPrecision: integer;
    constructor Create(const FDesc: string; FType: integer);
    function IsLookup: boolean;
  end;

  TDictionary = class(TObject)
  private
    FReadOnly, FBuiltIn: boolean;
    FMultiDim, FIsDim: boolean;
    FAllowModifyDim: boolean;
    FDicFields: TStringList; 
    //FOnPopupSelected: TNotifyEvent;
    function GetItemName(Index: integer): string;
    procedure SetItemName(Index: integer; const Value: string);
    function GetItemValue(Index, ValIndex: integer): variant;
    procedure SetItemValue(Index, ValIndex: integer; Value: variant);
    function GetItemFloat(Index, ValIndex: integer): extended;
    procedure SetItemFloat(Index, ValIndex: integer; Value: extended);
    function GetItemEnabled(Index: integer): boolean;
    procedure SetItemEnabled(Index: integer; Value: boolean);
    function GetItemCode(FindName: string): integer;
    procedure SetReadOnly(Value: boolean);
    function GetItemCount: integer;
    function GetMultiValue(const DimFieldNames: string; const DimValues: variant; const ValFieldName: string): variant;
    function GetCurrentValue(ValIndex: integer): Variant;
    function GetCurrentIsNull(ValIndex: integer): boolean;
    function GetCurrentCode: integer;
    function GetCurrentParentCode: integer;
    function GetCurrentID: integer;
    function GetCurrentEnabled: boolean;
    function GetCurrentName: string;
    procedure SetCurrentName(Value: string);
    procedure SetCurrentCode(Value: integer);
    procedure SetCurrentParentCode(Value: integer);
    procedure SetCurrentEnabled(Value: boolean);
    procedure SetDicFields(Value: TStringList);
  public
    Name: string;
    Desc: string;
    TableName: string;
    DicItems: TMemTableEh;
    MultiItems: TClientDataSet;
    DicDataSet, MultiDataSet: TDataSet;
    {DicProvider, }MultiDataProvider: TDataSetProvider;
    //DicDataDriver: TDataDriverEh;
    DicID, ParentID: integer;
    //FieldInfoData: TDataSet;  // Ссылка на набор данных со свойствами полей
    constructor Create(_Name: string; ADicID: integer; _MultiDim, _IsDim: boolean);
    destructor Destroy; override;
    procedure OpenData;
    procedure CloseData;
    procedure ClearDataFields;
    procedure ClearDicFields;
    function OpenMultiItems: boolean;
    procedure RefreshData;
    //procedure ReadDicFields;
    procedure LoadImage(Bmp: TBitmap; Index: integer);
    function LocateCode(Code: integer): boolean;
    function LocateFilter(FilterExpr: string): boolean;
    // создает по справочнику список имен с ассоциированным кодом (в Objects)
    function CreateList: TStringList;

    property DicFields: TStringList read FDicFields write SetDicFields;

    property ItemName[Index: integer]: string read GetItemName write SetItemName;// default;
    property ItemValue[Index, ValIndex: integer]: variant read GetItemValue write SetItemValue;
    property ItemFloat[Index, ValIndex: integer]: extended read GetItemFloat write SetItemFloat;
    property ItemCode[FindName: string]: integer read GetItemCode;
    property ItemEnabled[Index: integer]: boolean read GetItemEnabled write SetItemEnabled;
    property CurrentName: string read GetCurrentName write SetCurrentName;
    property CurrentValue[ValIndex: integer]: variant read GetCurrentValue;
    property CurrentIsNull[ValIndex: integer]: boolean read GetCurrentIsNull;
    property CurrentCode: integer read GetCurrentCode write SetCurrentCode;
    property CurrentParentCode: integer read GetCurrentParentCode write SetCurrentParentCode;
    property CurrentID: integer read GetCurrentID;
    property CurrentEnabled: boolean read GetCurrentEnabled write SetCurrentEnabled;
    // получение значения многомерного справочника
    property MultiValue[const DimFieldNames: string; const DimValues: variant; const ValFieldName: string]: variant read GetMultiValue;
    // Означает, что этот справочник встроен, его нельзя удалять, и нежелательно удалять значения
    property BuiltIn: boolean read FBuiltIn write FBuiltIn;
    // Означает, что в этот справочник нельзя добавлять новые значения (BuiltIn = true)
    property ReadOnly: boolean read FReadOnly write SetReadOnly;
    property MultiDim: boolean read FMultiDim;
    property IsDimension: boolean read FIsDim;
    property AllowModifyDim: boolean read FAllowModifyDim write FAllowModifyDim;
    //property OnPopupSelected: TNotifyEvent read FOnPopupSelected write FOnPopupSelected;
    property ItemCount: integer read GetItemCount;
  end;

  TGetDimValueEvent = function (DataSet: TDataSet; DimDic: TDictionary): variant of object;

  TInternalDictionaryList = class(TStringList)
  private
    function GetElem(Name: string): TDictionary;
  protected
//
  public
//    function ElementByName(const Name: string): TDicElement;
    constructor Create;
    function AddDictionary(_Element: TDictionary): Integer;
    function FindTable(const TabName: string): TMemTableEh;
//    function FindByFieldName(const FieldName: string): TDicElement;
    procedure FreeByName(const DicName: string);
    procedure ClearAll;
    function FindID(_DicID: integer): TDictionary;
    function FindByMultiData(MultiData: TDataSet): TDictionary;
    // Ищет не-case-sensitive
    property DicElements[Name: string]: TDictionary read GetElem; default;
  end;

implementation

uses ExHandler, CalcUtils, RDBUtils, PmDatabase;

constructor TFieldDesc.Create(const FDesc: string; FType: integer);
begin
  FieldDesc := FDesc;
  FieldType := FType;
end;

function TFieldDesc.IsLookup: boolean;
begin
  Result := (FieldType = ftDictionary) or (FieldType = ftProcess) or (FieldType = ftProcessGrid);
end;

constructor TDictionary.Create(_Name: string; ADicID: integer; _MultiDim, _IsDim: boolean);
begin
  inherited Create;
  Name := _Name;
  DicID := ADicID;
  FMultiDim := _MultiDim;
  FIsDim := _IsDim;
end;

destructor TDictionary.Destroy;
begin
  ClearDicFields;
  FreeAndNil(FDicFields);
  inherited Destroy;
end;

function TDictionary.GetItemName(Index: integer): string;
begin
//  if not DicItems.Locate(DicItemCodeField, Index, []) then Result := ''
//  else Result := DicItems[DicItemNameField];
  Result := NvlString(DicItems.Lookup(F_DicItemCode, Index, F_DicItemName));
  //if VarIsNull(Result) then Result := '';
end;

procedure TDictionary.SetItemName(Index: integer; const Value: string);
begin
  if DicItems.Locate(F_DicItemCode, Index, []) then
    DicItems[F_DicItemName] := Value;
end;

function TDictionary.GetItemValue(Index, ValIndex: integer): Variant;
begin
//  if not DicItems.Locate(DicItemCodeField, Index, []) then Result := null
//  else Result := DicItems[DicItemValueField + IntToStr(ValIndex)];
  Result := DicItems.Lookup(F_DicItemCode, Index, F_DicItemValue + IntToStr(ValIndex));
end;

procedure TDictionary.SetItemValue(Index, ValIndex: integer; Value: variant);
begin
  if DicItems.Locate(F_DicItemCode, Index, []) then
    DicItems[F_DicItemValue + IntToStr(ValIndex)] := Value;
end;

function TDictionary.GetItemCode(FindName: string): integer;
begin
//  if not DicItems.Locate(DicItemNameField, FindName, []) then Result := -1
//  else Result := DicItems[DicItemCodeField];
  Result := NvlInteger(DicItems.Lookup(F_DicItemName, FindName, F_DicItemCode));
  if Result = 0 then Result := -1;
end;

function TDictionary.GetCurrentName: string;
begin
  Result := NvlString(DicItems[F_DicItemName]);
end;

procedure TDictionary.SetCurrentName(Value: string);
begin
  if not (DicItems.State in [dsInsert, dsEdit]) then
    DicItems.Edit;
  DicItems[F_DicItemName] := Value;
end;

procedure TDictionary.SetCurrentCode(Value: integer);
begin
  if not (DicItems.State in [dsInsert, dsEdit]) then
    DicItems.Edit;
  DicItems[F_DicItemCode] := Value;
end;

procedure TDictionary.SetCurrentParentCode(Value: integer);
begin
  if not (DicItems.State in [dsInsert, dsEdit]) then
    DicItems.Edit;
  DicItems[F_DicItemParentCode] := Value;
end;

procedure TDictionary.SetCurrentEnabled(Value: boolean);
begin
  if not (DicItems.State in [dsInsert, dsEdit]) then
    DicItems.Edit;
  DicItems[F_DicItemVisible] := Value;
  DicItems.Post;
end;

function TDictionary.GetCurrentCode: integer;
begin
  Result := NvlInteger(DicItems[F_DicItemCode]);
end;

function TDictionary.GetCurrentParentCode: integer;
begin
  Result := NvlInteger(DicItems[F_DicItemParentCode]);
end;

function TDictionary.GetCurrentID: integer;
begin
  Result := NvlInteger(DicItems[F_DicItemID]);
end;

function TDictionary.GetCurrentEnabled: boolean;
begin
  Result := NvlBoolean(DicItems[F_DicItemVisible]);
end;

function TDictionary.GetCurrentValue(ValIndex: integer): Variant;
begin
  Result := DicItems[F_DicItemValue + IntToStr(ValIndex)];
end;

function TDictionary.GetCurrentIsNull(ValIndex: integer): boolean;
begin
  Result := DicItems.FieldByName(F_DicItemValue + IntToStr(ValIndex)).IsNull;
end;

function NvlFloatField(Field: TField): extended;
begin
  if Field.IsNull then Result := 0
  else Result := Field.AsFloat;
end;

function TDictionary.GetItemFloat(Index, ValIndex: integer): extended;
begin
//  if not DicItems.Locate(DicItemCodeField, Index, []) then Result := 0
//  else Result := NvlFloatField(DicItems.FindField(DicItemValueField + IntToStr(ValIndex)));
  Result := NvlFloat(DicItems.Lookup(F_DicItemCode, Index, F_DicItemValue + IntToStr(ValIndex)));
end;

procedure TDictionary.SetItemFloat(Index, ValIndex: integer; Value: extended);
begin
  if DicItems.Locate(F_DicItemCode, Index, []) then
    DicItems[F_DicItemValue + IntToStr(ValIndex)] := Value;
end;

function TDictionary.GetItemEnabled(Index: integer): boolean;
begin
//  if not DicItems.Locate(DicItemCodeField, Index, []) then Result := 0
//  else Result := NvlFloatField(DicItems.FindField(DicItemValueField + IntToStr(ValIndex)));
  Result := NvlBoolean(DicItems.Lookup(F_DicItemCode, Index, F_DicItemVisible));
end;

procedure TDictionary.SetItemEnabled(Index: integer; Value: boolean);
begin
  if DicItems.Locate(F_DicItemCode, Index, []) then
    DicItems[F_DicItemVisible] := Value;
end;

procedure TDictionary.LoadImage(Bmp: TBitmap; Index: integer);
var
  ImField: TBlobField;
begin
  ImField := DicItems.FieldByName(F_DicItemValue + IntToStr(Index)) as TBlobField;
  if not ImField.IsNull then
    Bmp.Assign(ImField)
  else
    Bmp.LoadFromResourceName(hInstance, SEmptyBitmap);
end;

function TDictionary.GetItemCount: integer;
begin
  if DicItems.Active then
    Result := DicItems.RecordCount
  else result := 0;
end;

procedure TDictionary.OpenData;
begin
  if DicItems = nil then Exit;
  try
    if not DicItems.Active then  // 22.07.2009
    begin
      Database.OpenDataSet(DicItems);
    end;
    DicItems.Filtered := false;  // 09.05.2005 (некоторые отчеты меняют фильтр)
    OpenMultiItems;
  except
    on E: Exception do
      ExceptionHandler.Raise_(E, 'Не могу открыть данные справочника ''' + Desc + ''' (' + Name +  '): ' + E.Message, 'OpenData');
  end;
end;

function TDictionary.OpenMultiItems: boolean;
begin
  Result := true;
  if MultiItems = nil then Exit;
  try
    Database.OpenDataSet(MultiItems);
  except
    on E: EDatabaseError do begin
      ExceptionHandler.Raise_(E, 'Не могу открыть многомерный справочник ''' + Desc + '''',
        'OpenMultiItems');
      Result := false;
    end;
  end;
end;

procedure TDictionary.CloseData;
begin
  if DicItems <> nil then DicItems.Close;
  if MultiItems <> nil then MultiItems.Close;
end;

procedure TDictionary.RefreshData;
begin
  CloseData;
  OpenData;
end;

procedure TDictionary.ClearDicFields;
var
  i: integer;
begin
  if Assigned(FDicFields) then begin
    if FDicFields.Count > 0 then
      for i := 0 to Pred(FDicFields.Count) do
        (FDicFields.Objects[i] as TObject).Free;
    FDicFields.Clear;
  end;
end;

procedure TDictionary.ClearDataFields;
begin
  DicItems.Fields.Clear;
end;

function TDictionary.GetMultiValue(const DimFieldNames: string; const DimValues: variant; const ValFieldName: string): variant;
begin
  try
    Result := null;
    if not MultiDim or not MultiItems.Active then Exit;
    if MultiItems.Locate(DimFieldNames, DimValues, []) then
      Result := MultiItems[ValFieldName];
  except end;
end;

procedure TDictionary.SetReadOnly(Value: boolean);
begin
  FReadOnly := Value;
  if FReadOnly then BuiltIn := true;
end;

function TDictionary.LocateCode(Code: integer): boolean;
begin
  Result := DicItems.Locate(F_DicItemCode, Code, []);
end;

function TDictionary.LocateFilter(FilterExpr: string): boolean;
var
  OldFilter: string;
  OldFiltered: boolean;
  CodeVal: integer;
begin
  OldFilter := DicItems.Filter;
  OldFiltered := DicItems.Filtered;
  try
    DicItems.Filter := FilterExpr;
    DicItems.Filtered := true;
    CodeVal := CurrentCode;
  finally
    DicItems.Filter := OldFilter;
    DicItems.Filtered := OldFiltered;
  end;
  Result := CodeVal <> 0;
  if Result then
    LocateCode(CodeVal);
end;

procedure TDictionary.SetDicFields(Value: TStringList);
begin
  ClearDicFields;
  FDicFields := Value;
end;

function TDictionary.CreateList: TStringList;
begin
  Result := TStringList.Create;
  DicItems.First;
  while not DicItems.Eof do
  begin
    if CurrentEnabled then
      Result.AddObject(CurrentName, pointer(CurrentCode));
    DicItems.Next;
  end;
end;

{$REGION 'TInternalDictionaryList' }

constructor TInternalDictionaryList.Create;
begin
  inherited Create;
  Sorted := false;
  Duplicates := dupAccept;
end;

function TInternalDictionaryList.AddDictionary(_Element: TDictionary): Integer;
begin
  Result := AddObject(_Element.Name, _Element);
end;

// Ищет не-case-sensitive
function TInternalDictionaryList.GetElem(Name: string): TDictionary;
var I: integer;
begin
  Result := nil;
  I := IndexOf(Name);
  if I <> -1 then
    Result := Objects[I] as TDictionary
  else
  begin
    for i := 0 to Pred(Count) do
      if CompareText((Objects[i] as TDictionary).Name, Name) = 0 then begin
        Result := Objects[i] as TDictionary;
        Exit;
      end;
  end;
end;

function TInternalDictionaryList.FindTable(const TabName: string): TMemTableEh;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Pred(Count) do
    if CompareText((Objects[i] as TDictionary).TableName, TabName) = 0 then begin
      Result := (Objects[i] as TDictionary).DicItems;
      Exit;
    end;
end;

procedure TInternalDictionaryList.ClearAll;
var i: integer;
begin
  if Count > 0 then
    for i := 0 to Pred(Count) do Objects[i].Free;
  Clear;
end;

{function TDicElemList.FindByFieldName(const FieldName: string): TDicElement;
var
  i: integer;
  de: TDicElement;
  fn: string;
begin
  Result := nil;
  if Count = 0 then Exit;
  for i := 0 to Pred(Count) do
    try
      de := Objects[i] as TDicElement;
      if AnsiCompareText(de.GetFieldName, FieldName) = 0 then begin
        Result := de;
        Exit;
      end;
    except end;
end;}

// НЕ удаляет набор данных! Только компонент справочника!
// Используется при удалении справочника.

// ПОЗЖЕ: ПОЧЕМУ не удаляем запись в списке и набор данных?????????????????
// Пока сделал, чтобы удалялись...
procedure TInternalDictionaryList.FreeByName(const DicName: string);
var
  Index: integer;
  de: TDictionary;
begin
  while true do
  begin
    Index := IndexOf(DicName);
    if Index = -1 then Exit;
    de := Objects[Index] as TDictionary;
    de.DicItems.Free;
    de.Free;
    Delete(Index);
  end;
end;

function TInternalDictionaryList.FindID(_DicID: integer): TDictionary;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Pred(Count) do
    if _DicID = (Objects[i] as TDictionary).DicID then
    begin
      Result := Objects[i] as TDictionary;
      Exit;
    end;
end;

function TInternalDictionaryList.FindByMultiData(MultiData: TDataSet): TDictionary;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Pred(Count) do
    if MultiData = (Objects[i] as TDictionary).MultiItems then
    begin
      Result := Objects[i] as TDictionary;
      Exit;
    end;
end;

{$ENDREGION}

end.
