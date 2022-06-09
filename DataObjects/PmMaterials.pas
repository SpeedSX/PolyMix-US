unit PmMaterials;

interface

uses Classes, Variants, DB, DBClient, Provider,

  PmOrderItemDetails;

type
  TMatResolveEvent = function(MatName: string; UpdateKind: TUpdateKind): boolean;
  TGetCourseEvent = function: extended of object;

  TMaterials = class(TOrderItemDetails)
  private
    FFactMatCostChanging: boolean;
    FFieldChanged: TFieldNotifyEvent;
    FOnGetCourse: TGetCourseEvent; 
    FDataSource: TDataSource;
    FOrderID: integer;
    procedure SetFactReceiveDate(Value: variant);
    procedure SetPlanReceiveDate(Value: variant);
    function GetFactReceiveDate: variant;
    function GetPlanReceiveDate: variant;
    function GetRequestModified: boolean;
    procedure SetRequestModified(Value: boolean);
    procedure CreateDataSet(DataOwner: TComponent);
    procedure AnyChange(Sender: TField);
    procedure FactMatCostChange(Sender: TField);
    function GetExternalMatID: variant;
    procedure SetExternalMatID(Value: variant);
    function GetFactMatCost: variant;
    procedure SetFactMatCost(Value: variant);
    procedure SetFactMatAmount(Value: variant);
    procedure SetMatAmount(Value: extended);
    procedure SetMatCost(Value: extended);
    procedure SetMatTypeName(Value: string);
    procedure SetMatUnitName(Value: string);
    procedure SetMatDesc(Value: string);
    procedure SetParam1(Value: string);
    procedure SetParam2(Value: string);
    procedure SetParam3(Value: string);
    procedure SetPayDate(Value: variant);
    function GetMatDesc: string;
    function GetParam1: string;
    function GetParam2: string;
    function GetParam3: string;
    function GetFactParam1: string;
    function GetFactParam2: string;
    function GetFactParam3: string;
    function GetMatAmount: extended;
    function GetItemID: integer;
    function GetMatCost: extended;
    function GetMatTypeName: string;
    function GetMatUnitName: string;
    function GetPayDate: variant;
    procedure SafeDateGetText(Sender: TField; var Text: String; DisplayText: Boolean);
  protected
    procedure DoBeforeOpen; override;
    procedure DoAfterOpen; override;
    procedure DoOnCalcFields; override;
    procedure DoAfterDelete; override;
    procedure ProviderUpdateError(Sender: TObject;
      DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind;
      var Response: TResolverResponse); override;
    function GetSQL: string; virtual;
    function HasFactInfo: boolean; overload;
    procedure UpdateMaterialCost(ItemKey: integer);
  public
    const
      F_Key = 'MatID';
      // Material fields
      F_SupplierID = 'SupplierID';
      F_SupplierName = 'SupplierName';
      F_MatAmount = 'MatAmount';
      F_FactMatAmount = 'FactMatAmount';
      F_FactMatCost = 'FactMatCost';
      F_MatUnitName = 'MatUnitName';
      F_MatTypeName = 'MatTypeName';
      F_PlanReceiveDate = 'PlanReceiveDate';
      F_FactReceiveDate = 'FactReceiveDate';
      F_ExternalMatID = 'ExternalMatID';
      F_RequestModified = 'RequestModified';
      F_AnyMatCost = 'AnyMatCost';
      F_Param1 = 'Param1';
      F_Param2 = 'Param2';
      F_Param3 = 'Param3';
      F_FactParam1 = 'FactParam1';
      F_FactParam2 = 'FactParam2';
      F_FactParam3 = 'FactParam3';
      F_MatDesc = 'MatDesc';
      MatTypeNameSize = 40;
      MatDescSize = 80;
      MatUnitNameSize = 20;
      ParamSize = 50;
      MatNoteSize = 200;
      InvoiceNumSize = 20;
      F_MatCost = 'MatCost';
      F_MatCostNative = 'MatCostNative';
      F_PayDate = 'PayDate';

    constructor Create(DataOwner: TComponent);
    destructor Destroy; override;
    function GetMaterialData(ItemKey: integer; MatTypeName: string): TDataSet;
    // Добавить информацию о материале для записи процесса с указанным ключом
    procedure SetMaterial(ItemKey: integer; MatTypeName: string; MatDesc: string;
      MatAmount: extended; MatUnitName: string; MatCost: extended;
      ReplaceAnyType: boolean; Resolver: TMatResolveEvent);
    // Добавить информацию о материале для записи процесса с указанным ключом
    procedure SetMaterialEx(ItemKey: integer; MatTypeName: string;
      MatDesc: string; MatParam1, MatParam2, MatParam3: variant;
      MatAmount: extended; MatUnitName: string; MatCost: extended;
      ReplaceAnyType: boolean; Resolver: TMatResolveEvent);
    // Заменить информацию о материале для записи процесса с указанным ключом
    procedure ReplaceMaterial(ItemKey: integer; MatTypeName: string; MatDesc: string;
      MatAmount: extended; MatUnitName: string; MatCost: extended;
      Resolver: TMatResolveEvent);
    // Заменить информацию о материале для записи процесса с указанным ключом
    procedure ReplaceMaterialEx(ItemKey: integer; MatTypeName: string; MatDesc: string;
      MatParam1, MatParam2, MatParam3: variant;
      MatAmount: extended; MatUnitName: string; MatCost: extended;
      Resolver: TMatResolveEvent);
    procedure ClearMaterial(ItemKey: integer; MatTypeName: string;
      Resolver: TMatResolveEvent);
    function HasFactInfo(ItemKey: integer): boolean; overload;
    function GetFactMaterialCost(ItemKey: integer): extended;
    // Установить фактические параметры материала
    procedure SetFactMaterial(ItemKey: integer; MatTypeName: string;
      _FactAmount, _FactCost: variant);
    function HasFactInfoCurrent: boolean;

    property PlanReceiveDate: variant read GetPlanReceiveDate write SetPlanReceiveDate;
    property FactReceiveDate: variant read GetFactReceiveDate write SetFactReceiveDate;
    // Был ли материал изменен после установки фактических параметров
    property RequestModified: boolean read GetRequestModified write SetRequestModified;

    property FieldChanged: TFieldNotifyEvent read FFieldChanged write FFieldChanged;
    property OnGetCourse: TGetCourseEvent read FOnGetCourse write FOnGetCourse;
    property DataSource: TDataSource read FDataSource;
    property OrderID: integer read FOrderID write FOrderID;
    property ExternalMatID: variant read GetExternalMatID write SetExternalMatID;
    // фактическая стоимость материала, устанавливать надо через SetFactMaterialCost
    property FactMatCost: variant read GetFactMatCost;// write SetFactMatCost;
    property MatDesc: string read GetMatDesc write SetMatDesc;
    property Param1: string read GetParam1 write SetParam1;
    property Param2: string read GetParam2 write SetParam2;
    property Param3: string read GetParam3 write SetParam3;
    property FactParam1: string read GetFactParam1;
    property FactParam2: string read GetFactParam2;
    property FactParam3: string read GetFactParam3;
    property MatUnitName: string read GetMatUnitName write SetMatUnitName;
    property MatTypeName: string read GetMatTypeName write SetMatTypeName;
    property MatAmount: extended read GetMatAmount write SetMatAmount;
    property MatCost: extended read GetMatCost write SetMatCost;
    property ItemID: integer read GetItemID;
    // дата оплаты
    property PayDate: variant read GetPayDate write SetPayDate;
  end;

implementation

uses SysUtils, Dialogs,

  RDialogs, MainData, PmProcess, RDBUtils, ServMod, PmContragent, PmOrderProcessItems,
  CalcUtils, PmDatabase, JvInterpreter_CustomQuery;

constructor TMaterials.Create(DataOwner: TComponent);
var
  _DataSource: TDataSource;
  _DataSet: TDataSet;
  _Provider: TDataSetProvider;
begin
  _DataSource := CreateQueryExDM(DataOwner as TDataModule, DataOwner as TDataModule,
    GetComponentName(DataOwner, 'cd' + ClassName),
    [{poAllowMultiRecordUpdates, poDisableInserts, poDisableDeletes, poDisableEdits}],
    upWhereKeyOnly, false {ResolveToDataSet}, Database.Connection, _Provider);
  _DataSet := _DataSource.DataSet;
  inherited Create;
  FKeyField := F_Key;
  FInternalName := 'OrderProcessItemMaterials';

  SetDataSet(_DataSet);
  CreateDataSet(DataOwner);
  //FDataSource := TDataSource.Create(DataOwner);
  //FDataSource.DataSet := DataSet;
  RefreshAfterApply := false;
  FForeignKeyField := F_ItemID;
  DataSetProvider := _Provider;
  FDataSource := _DataSource;
  DataSet.FieldByName(F_SupplierName).LookupDataSet := Suppliers.DataSet;
end;

destructor TMaterials.Destroy;
begin
  //DataSet.Free;
  inherited;
end;

procedure TMaterials.CreateDataSet(DataOwner: TComponent);
var
  //_DataSet: TClientDataSet;
  f: TField;
begin
  //_DataSet := TClientDataSet.Create(DataOwner);
  (DataSet as TClientDataSet).AggregatesActive := True;
  //_DataSet.Name := GetComponentName(DataOwner, 'cd', InternalName);
  DataSet.FilterOptions := [foCaseInsensitive];
  //DataSetProvider := dm.pvItemMaterial;
  //_DataSet.ProviderName := DataSetProvider.Name;
  //_DataSet.SetProvider(dm.pvItemMaterial);
  //SetDataSet(_DataSet);

  f := TAutoIncField.Create(DataSet.Owner);
  f.FieldName := F_Key;
  f.ReadOnly := True;
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_ItemID;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_MatTypeName;
  f.ProviderFlags := [pfInUpdate];
  f.Size := TMaterials.MatTypeNameSize;
  f.DataSet := DataSet;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_MatDesc;
  f.ProviderFlags := [pfInUpdate];
  f.Size := TMaterials.MatDescSize;
  f.DataSet := DataSet;

  f := TFloatField.Create(DataSet.Owner);
  f.FieldName := F_MatAmount;
  f.ProviderFlags := [pfInUpdate];
  (f as TFloatField).DisplayFormat := '#0.####';
  f.DataSet := DataSet;

  f := TFloatField.Create(DataSet.Owner);
  f.FieldName := F_FactMatAmount;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := AnyChange;
  f.DataSet := DataSet;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_Param1;
  f.Size := TMaterials.ParamSize;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_Param2;
  f.Size := TMaterials.ParamSize;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_Param3;
  f.Size := TMaterials.ParamSize;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_MatCost;
  f.ProviderFlags := [pfInUpdate];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).EditFormat := NumEditFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldKind := fkInternalCalc;
  f.FieldName := F_MatCostNative;
  f.ProviderFlags := [];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).EditFormat := NumEditFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_FactMatCost;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := FactMatCostChange;
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).EditFormat := NumEditFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_AnyMatCost;
  f.FieldKind := fkInternalCalc;
  f.ProviderFlags := [pfInUpdate];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).EditFormat := NumEditFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_SupplierID;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := AnyChange;
  f.DataSet := DataSet;

  f := TStringField.Create(DataSet.Owner);
  f.DisplayWidth := TContragents.CustNameSize;
  f.FieldKind := fkLookup;
  f.FieldName := F_SupplierName;
  f.LookupKeyFields := TContragents.F_CustKey;
  f.LookupResultField := 'Name';
  f.KeyFields := F_SupplierID;
  f.ProviderFlags := [];
  f.Size := TContragents.CustNameSize;
  f.Lookup := True;
  f.DataSet := DataSet;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := F_MatUnitName;
  f.Size := TMaterials.MatUnitNameSize;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := F_PlanReceiveDate;
  (f as TDateTimeField).DisplayFormat := CalcUtils.ShortDateFormat2;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := AnyChange;
  f.OnGetText := SafeDateGetText;
  f.DataSet := DataSet;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := F_FactReceiveDate;
  (f as TDateTimeField).DisplayFormat := CalcUtils.ShortDateFormat2;
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := AnyChange;
  f.OnGetText := SafeDateGetText;
  f.DataSet := DataSet;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'ExternalMatID';
  f.ProviderFlags := [pfInUpdate];
  f.OnChange := AnyChange;
  f.DataSet := DataSet;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := F_RequestModified;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := F_PayDate;
  (f as TDateTimeField).DisplayFormat := CalcUtils.ShortDateFormat2;
  f.OnChange := AnyChange;
  f.OnGetText := SafeDateGetText;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;

  // aggregate
  f := TAggregateField.Create(DataSet.Owner);
  f.DefaultExpression := '0';
  f.FieldName := 'TotalMatCost';
  f.ProviderFlags := [];
  (f as TAggregateField).Active := True;
  (f as TAggregateField).Expression := 'sum(MatCost)';
  f.DataSet := DataSet;

  f := TAggregateField.Create(DataSet.Owner);
  f.DefaultExpression := '0';
  f.FieldName := 'TotalFactMatCost';
  f.ProviderFlags := [];
  (f as TAggregateField).Active := True;
  (f as TAggregateField).Expression := 'sum(AnyMatCost)';
  f.DataSet := DataSet;
end;

procedure TMaterials.DoBeforeOpen;
begin
  inherited DoBeforeOpen;
  SetQuerySQL(DataSource, GetSQL);
end;

procedure TMaterials.DoAfterOpen;
begin
  inherited DoAfterOpen;
  TClientDataSet(DataSet).AddIndex('iMatTypeName', F_MatTypeName + ';' + F_ItemID, [ixCaseInsensitive]);
  TClientDataSet(DataSet).IndexDefs.Update;
  TClientDataSet(DataSet).IndexFieldNames := F_MatTypeName + ';' + F_ItemID;
end;

function TMaterials.GetSQL: string;
begin
  Result := 'select im.MatID, im.ItemID, im.MatTypeName, im.MatDesc, im.MatAmount, im.FactMatAmount, im.FactMatCost, im.PlanReceiveDate, im.FactReceiveDate,'#13#10
    + 'im.MatCost, im.SupplierID, im.MatUnitName, im.ExternalMatID, im.RequestModified,'#13#10
    + 'im.Param1, im.Param2, im.Param3, im.PayDate'#13#10
    + 'from OrderProcessItemMaterial im inner join OrderProcessItem opi on im.ItemID = opi.ItemID'#13#10
    + 'where opi.OrderID = ' + IntToStr(OrderID) + #13#10
    + 'order by im.MatTypeName, im.ItemID';
end;

function TMaterials.HasFactInfoCurrent: boolean;
begin
  Result := not VarIsNull(DataSet[F_FactMatCost]) or not VarIsNull(DataSet[F_FactMatAmount])
    or not VarIsNull(DataSet[F_FactReceiveDate]) or not VarIsNull(DataSet[F_PlanReceiveDate]);
end;

function TMaterials.HasFactInfo: boolean;
var
  CurKey: integer;
begin
  if DataSet.RecordCount > 0 then
  begin
    CurKey := NvlInteger(KeyValue);
    Result := false;
    while not DataSet.eof and not Result do
    begin
      if HasFactInfoCurrent then
        Result := true
      else
        DataSet.Next;
    end;
    Locate(CurKey);
  end else
    Result := false;
end;

function TMaterials.HasFactInfo(ItemKey: integer): boolean;
var
  OldFilter: string;
  OldFiltered: boolean;
begin
  OldFilter := DataSet.Filter;
  OldFiltered := DataSet.Filtered;
  DataSet.Filter := 'ItemID = ' + IntToStr(ItemKey);
  DataSet.Filtered := true;
  try
    Result := HasFactInfo;
  finally
    DataSet.Filtered := OldFiltered;
    DataSet.Filter := OldFilter;
  end;
end;

procedure TMaterials.SetRequestModified(Value: boolean);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  DataSet[F_RequestModified] := Value;
  DataSet[F_MatCost] := 0;   // обнуляем стоимость
  DataSet.Post;
end;

procedure TMaterials.SetMaterial(ItemKey: integer; MatTypeName: string; MatDesc: string;
  MatAmount: extended; MatUnitName: string; MatCost: extended;
  ReplaceAnyType: boolean; Resolver: TMatResolveEvent);
begin
  SetMaterialEx(ItemKey, MatTypeName, MatDesc, null, null, null, MatAmount, MatUnitName,
    MatCost, ReplaceAnyType, Resolver);
end;

procedure TMaterials.SetMaterialEx(ItemKey: integer; MatTypeName: string; MatDesc: string;
  MatParam1, MatParam2, MatParam3: variant;
  MatAmount: extended; MatUnitName: string; MatCost: extended; ReplaceAnyType: boolean;
  Resolver: TMatResolveEvent);

  procedure AddNew;
  begin
    // добавляем новый расходный материал
    DataSet.Append;
    DataSet[PmProcess.F_ItemID] := ItemKey;
    DataSet[F_MatAmount] := MatAmount;
    DataSet[F_MatUnitName] := MatUnitName;
    DataSet[F_MatTypeName] := MatTypeName;
    DataSet[F_MatDesc] := MatDesc;
    DataSet[F_Param1] := MatParam1;
    DataSet[F_Param2] := MatParam2;
    DataSet[F_Param3] := MatParam3;
    DataSet[F_MatCost] := MatCost;
    DataSet.Post;
  end;

var
  ModifiedRecs: integer;
begin
  if (ItemKey = 0) or FReadOnly then Exit;
  if ReplaceAnyType then
    // заменяется любой расходный материал, остальные удаляются
    DataSet.Filter := F_ItemID + ' = ' + IntToStr(ItemKey)
  else
    // обновляется только материал указанного вида
    DataSet.Filter := F_ItemID + ' = ' + IntToStr(ItemKey) + ' and MatTypeName = ''' + MatTypeName + '''';
  DataSet.Filtered := true;
  try
    if DataSet.RecordCount > 0 then
      DataSet.Filter := DataSet.Filter + ' and not RequestModified';

    if DataSet.RecordCount > 0 then
    begin
      if ReplaceAnyType and (DataSet.RecordCount > 1) and not FCostReadOnly then
      begin
        // в случае удаления записи с фактическими параметрами запрашиваем подтверждение
        // if not HasFactInfo or not Assigned(Resolver) or Resolver('', ukDelete) then

        // В случае удаления данных с фактическими полями оставляем старую запись
        // и устанавливаем признак.
        if not HasFactInfo then
        begin
          // оставляем только одну строку
          DataSet.Next;
          ModifiedRecs := 0;
          while DataSet.RecordCount - ModifiedRecs > 1 do
          begin
            if HasFactInfoCurrent then
            begin
              SetRequestModified(true);
              Inc(ModifiedRecs);
              DataSet.Next;
            end
            else
              DataSet.Delete;
          end;
        end;
      end;
      {else // если несколько записей, то нам нужны НЕотмененные
        if DataSet.RecordCount > 1 then
          DataSet.Filter := DataSet.Filter + ' and not RequestModified';}

      // обновляем параметры расходного материала, если нужно
      if (DataSet[F_MatAmount] <> MatAmount)
        or (DataSet[F_MatUnitName] <> MatUnitName)
        or (DataSet[F_MatTypeName] <> MatTypeName)
        or (DataSet[F_MatDesc] <> MatDesc)
        or (DataSet[F_Param1] <> MatParam1)
        or (DataSet[F_Param2] <> MatParam2)
        or (DataSet[F_Param3] <> MatParam3)
        or (Abs(DataSet[F_MatCost] - MatCost) >= 0.01) then
      begin
        // в случае изменения данных с фактическими полями запрашиваем подтверждение
        //if not HasFactInfoCurrent or not Assigned(Resolver) or Resolver(NvlString(DataSet['MatDesc']), ukModify) then

        // в случае изменения записи с фактическими параметрами добавляем новую запись
        // 2.11.2009 Пробуем сравнивать записи перед сохранением кучей все сразу
        {if HasFactInfoCurrent and
          ((DataSet[F_MatAmount] <> MatAmount)
          or (DataSet[F_MatUnitName] <> MatUnitName)
          or (DataSet[F_MatTypeName] <> MatTypeName)
          or (DataSet[F_MatDesc] <> MatDesc)
          or ((Abs(DataSet[F_MatCost] - MatCost) >= 0.01)   // изменилась стоимость и она меньше фактической
            and (MatCost < NvlFloat(FactMatCost)))) then
        begin
          if DataSet.RecordCount > 1 then
            // вообще-то такого впредь не должно быть, но было из-за неправильного копирования.
            RusMessageDlg('Для процесса указано два материала одной категории.'
              + 'Такая возможность не реализована.', mtError, [mbOk], 0)
          else
          begin
            // для старой устанавливаем признак, что она устарела и обнуляем стоимость
            SetRequestModified(true);
            AddNew;
          end;
        end
        else
        begin}
          // иначе просто обновляем параметры
          if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
          DataSet[F_MatAmount] := MatAmount;
          DataSet[F_MatUnitName] := MatUnitName;
          DataSet[F_MatTypeName] := MatTypeName;
          DataSet[F_MatDesc] := MatDesc;
          DataSet[F_Param1] := MatParam1;
          DataSet[F_Param2] := MatParam2;
          DataSet[F_Param3] := MatParam3;
          if not FCostReadOnly then
            DataSet[F_MatCost] := MatCost;
          DataSet.Post;
        //end;
      end
      else
        Exit;  // ничего не изменилось
    end
    else
      AddNew;
    // обновляем стоимость материалов в записи процесса
    UpdateMaterialCost(ItemKey);
  finally
    DataSet.Filtered := false;
  end;
end;

procedure TMaterials.SetFactMaterial(ItemKey: integer; MatTypeName: string;
  _FactAmount, _FactCost: variant);
begin
  if (ItemKey = 0) then Exit;
  // обновляется только материал указанного вида
  DataSet.Filter := F_ItemID + ' = ' + IntToStr(ItemKey) + ' and MatTypeName = ''' + MatTypeName + '''';
  try
    if not DataSet.IsEmpty then
    begin
      SetFactMatAmount(_FactAmount);
      SetFactMatCost(_FactCost);
    end;
    // Обновить итоговую сумму расходных материалов процесса
    UpdateMaterialCost(ItemKey);
  finally
    DataSet.Filtered := false;
  end;

end;

procedure TMaterials.ReplaceMaterial(ItemKey: integer; MatTypeName: string; MatDesc: string;
  MatAmount: extended; MatUnitName: string; MatCost: extended; Resolver: TMatResolveEvent);
begin
  SetMaterial(ItemKey, MatTypeName, MatDesc, MatAmount, MatUnitName, MatCost, true, Resolver);
end;

// Заменить информацию о материале для записи процесса с указанным ключом
procedure TMaterials.ReplaceMaterialEx(ItemKey: integer; MatTypeName: string; MatDesc: string;
  MatParam1, MatParam2, MatParam3: variant;
  MatAmount: extended; MatUnitName: string; MatCost: extended;
  Resolver: TMatResolveEvent);
begin
  SetMaterialEx(ItemKey, MatTypeName, MatDesc, MatParam1, MatParam2, MatParam3, MatAmount,
    MatUnitName, MatCost, true, Resolver);
end;

// Если не указан MatTypeName, то удаляет все виды материалов
procedure TMaterials.ClearMaterial(ItemKey: integer; MatTypeName: string;
  Resolver: TMatResolveEvent);
begin
  if (ItemKey = 0) or FReadOnly or FCostReadOnly then Exit;
  DataSet.Filter := F_ItemID + ' = ' + IntToStr(ItemKey);
  if MatTypeName <> '' then
    DataSet.Filter := DataSet.Filter + ' and MatTypeName = ''' + MatTypeName + '''';
  DataSet.DisableControls;
  try
    DataSet.Filtered := true;
    try
      // в случае удаления данных с фактическими полями запрашиваем подтверждение
      //if not HasFactInfo or not Assigned(Resolver) or Resolver('', ukDelete) then

      // В случае удаления данных с фактическими полями оставляем старые записи
      // и устанавливаем признак.
      if not HasFactInfo then
      begin
        while DataSet.RecordCount > 0 do
        begin
          DataSet.Delete;
        end;
      end
      else
      begin
        while not DataSet.eof do
        begin
          if HasFactInfoCurrent then
          begin
            SetRequestModified(true);
            DataSet.Next;
          end
          else
            DataSet.Delete;
        end;
      end;
      // Обновляем стоимость метериалов
      UpdateMaterialCost(ItemKey);
    finally
      DataSet.Filtered := false;
    end;
  finally
    DataSet.EnableControls;
  end;
end;

function TMaterials.GetMaterialData(ItemKey: integer; MatTypeName: string): TDataSet;
begin
  DataSet.Filter := F_ItemID + ' = ' + IntToStr(ItemKey);
  if MatTypeName <> '' then
    DataSet.Filter := DataSet.Filter + ' and MatTypeName = ''' + MatTypeName + '''';
  Result := DataSet;
end;

function TMaterials.GetFactMaterialCost(ItemKey: integer): extended;
begin
  // фильтруем все записи в материалах, относящиеся в процессу
  DataSet.Filter := F_ItemID + ' = ' + IntToStr(ItemKey);
  DataSet.Filtered := true;
  try
    Result := NvlFloat(DataSet['TotalFactMatCost']);
  finally
    DataSet.Filtered := false;
  end;
end;

// Обновляет стоимость материалов в записи процесса. Меняет фильтр!
procedure TMaterials.UpdateMaterialCost(ItemKey: integer);
var
  NewCost, NewFactCost: extended;
begin
  if (FMasterData <> nil) and FMasterData.Locate(ItemKey) then
  begin
    // фильтруем все записи в материалах, относящиеся в процессу
    DataSet.Filter := F_ItemID + ' = ' + IntToStr(ItemKey);
    DataSet.Filtered := true;
    NewCost := NvlFloat(DataSet['TotalMatCost']);
    if DataSet.State in [dsInsert, dsEdit] then DataSet.Post;  // НАДО?
    NewFactCost := NvlFloat(DataSet['TotalFactMatCost']);
    if (FMasterData as TOrderProcessItems).MatCost <> NewCost then
      (FMasterData as TOrderProcessItems).MatCost := NewCost;
    if (FMasterData as TOrderProcessItems).FactMatCost <> NewFactCost then
      (FMasterData as TOrderProcessItems).FactMatCost := NewFactCost;
  end;
end;

procedure TMaterials.ProviderUpdateError(Sender: TObject;
  DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind;
  var Response: TResolverResponse);
begin
  // Обман MIDAS. При удалении мастер-записи на сервере срабатывают триггеры,
  // поэтому возвращается нулевое количество обновленных строк.
  // Пытался сделать это в Reconcile, но там как-то хитрее (надо ставить raSkip
  // еще раз изменения применять, что ли).
  if (E.ErrorCode = 1) and (UpdateKind = ukDelete) then
    Response := rrIgnore
  else if (E.ErrorCode = 1) and (UpdateKind = ukModify) then
  begin
    {RusMessageDlg('Некорректная операция при сохранении материалов.'#13
      + 'Данные не будут потеряны, но сообщите, пожалуйста, разработчику.',
      mtWarning, [mbOk], 0);}
     // такое может быть, если удалена родительская запись в процессах,
     // а в материалах записи остались, т.к. были заказаны.
     // Они будут удалены на сервере, после внесения информации в историю заказа.
    Response := rrIgnore;
  end
  else
    inherited ProviderUpdateError(Sender, DataSet, E, UpdateKind, Response);
end;

procedure TMaterials.SetPlanReceiveDate(Value: variant);
begin
  DataSet[F_PlanReceiveDate] := Value;
  DataSet.Post;
end;

procedure TMaterials.SetFactReceiveDate(Value: variant);
begin
  DataSet[F_FactReceiveDate] := Value;
  DataSet.Post;
end;

function TMaterials.GetPlanReceiveDate: variant;
begin
  Result := DataSet[F_PlanReceiveDate];
end;

function TMaterials.GetFactReceiveDate: variant;
begin
  Result := DataSet[F_FactReceiveDate];
end;

function TMaterials.GetRequestModified: boolean;
begin
  Result := NvlBoolean(DataSet[F_RequestModified]);
end;

procedure TMaterials.DoOnCalcFields;
begin
  if Assigned(FOnGetCourse) then
    DataSet[F_MatCostNative] := DataSet[F_MatCost] * FOnGetCourse;

  if not NvlBoolean(DataSet[F_RequestModified]) then
  begin
    if not VarIsNull(DataSet[F_FactMatCost]) then
      DataSet[F_AnyMatCost] := DataSet[F_FactMatCost]
    else
      DataSet[F_AnyMatCost] := DataSet[F_MatCostNative];
  end
  else
    DataSet[F_AnyMatCost] := 0;
end;

procedure TMaterials.AnyChange(Sender: TField);
begin
  if Assigned(FFieldChanged) then
    FFieldChanged(Sender);
end;

procedure TMaterials.FactMatCostChange(Sender: TField);
var
  CurID: integer;
begin
  if not FFactMatCostChanging then
  begin
    FFactMatCostChanging := true;
    try
      CurID := NvlInteger(KeyValue);
      // обновляем фактическую стоимость материалов в процессе
      UpdateMaterialCost(DataSet[F_ItemID]);
      DataSet.Filtered := false;
      if CurID <> 0 then Locate(CurID);
      FFieldChanged(Sender);
    finally
      FFactMatCostChanging := false;
    end;
  end;
end;

procedure TMaterials.SetExternalMatID(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['ExternalMatID'] := Value;
end;

function TMaterials.GetExternalMatID: variant;
begin
  Result := DataSet['ExternalMatID'];
end;

procedure TMaterials.SetFactMatCost(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_FactMatCost] := Value;
end;

function TMaterials.GetFactMatCost: variant;
begin
  Result := DataSet[F_FactMatCost];
end;

procedure TMaterials.SetFactMatAmount(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_FactMatAmount] := Value;
end;

procedure TMaterials.DoAfterDelete;
begin
  inherited;
end;

function TMaterials.GetMatDesc: string;
begin
  Result := NvlString(DataSet[TMaterials.F_MatDesc]);
end;

function TMaterials.GetParam1: string;
begin
  Result := NvlString(DataSet[TMaterials.F_Param1]);
end;

function TMaterials.GetParam2: string;
begin
  Result := NvlString(DataSet[TMaterials.F_Param2]);
end;

function TMaterials.GetParam3: string;
begin
  Result := NvlString(DataSet[TMaterials.F_Param3]);
end;

function TMaterials.GetFactParam1: string;
begin
  Result := NvlString(DataSet[TMaterials.F_FactParam1]);
end;

function TMaterials.GetFactParam2: string;
begin
  Result := NvlString(DataSet[TMaterials.F_FactParam2]);
end;

function TMaterials.GetFactParam3: string;
begin
  Result := NvlString(DataSet[TMaterials.F_FactParam3]);
end;

function TMaterials.GetMatAmount: extended;
begin
  Result := NvlFloat(DataSet[TMaterials.F_MatAmount]);
end;

procedure TMaterials.SetMatAmount(Value: extended);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_MatAmount] := Value;
end;

function TMaterials.GetItemID: integer;
begin
  Result := NvlInteger(DataSet[PmProcess.F_ItemID]);
end;

function TMaterials.GetMatCost: extended;
begin
  Result := NvlFloat(DataSet[TMaterials.F_MatCost]);
end;

function TMaterials.GetMatUnitName: string;
begin
  Result := NvlString(DataSet[TMaterials.F_MatUnitName]);
end;

function TMaterials.GetPayDate: variant;
begin
  Result := DataSet[TMaterials.F_PayDate];
end;

function TMaterials.GetMatTypeName: string;
begin
  Result := NvlString(DataSet[TMaterials.F_MatTypeName]);
end;

procedure TMaterials.SetMatCost(Value: extended);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_MatCost] := Value;
end;

procedure TMaterials.SetMatTypeName(Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_MatTypeName] := Value;
end;

procedure TMaterials.SetMatUnitName(Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_MatUnitName] := Value;
end;

procedure TMaterials.SetMatDesc(Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_MatDesc] := Value;
end;

procedure TMaterials.SetParam1(Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_Param1] := Value;
end;

procedure TMaterials.SetParam2(Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_Param2] := Value;
end;

procedure TMaterials.SetParam3(Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_Param3] := Value;
end;

procedure TMaterials.SetPayDate(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_PayDate] := Value;
end;

procedure TMaterials.SafeDateGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  //if DisplayText then
  try
    if not VarIsNull(Sender.Value) then
      Text := SysUtils.FormatDateTime((Sender as TDateTimeField).DisplayFormat, Sender.Value)
    else
      Text := '';
  except
    Text := '';
  end;
end;

end.
