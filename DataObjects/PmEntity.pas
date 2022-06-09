unit PmEntity;

interface

uses Classes, SysUtils, DBClient, DB, ADODB, Provider, Forms, Controls,
  PmConnect, NotifyEvent, DBSettings, RDBUtils, DBIDList, ADOUtils,
  PmQueryPager;

type
  TPagerMode = (pmCursor, pmStructuredQuery);

  TDateArray = array of string;

  TEntity = class(TObject)
  private
    FNtfID: string;
    FDataSet: TDataSet;
    FDataSetProvider: TDataSetProvider;
    //FADODataSet: TADOQuery;
    FCurKeyValue: variant; // временно используется при обновлении
    FRefreshAfterApply: Boolean;
    FDefaultLastRecord: boolean;
    FUsePager: boolean;
    FPagerMode: TPagerMode;
    FQueryObject: TQueryObject;
    FQueryPager: TQueryPager;  // объект постраничной загрузки
    FMergingData: boolean;
    FTempEnableCalcFields: boolean;
    FSavePagePosition: boolean;
    FSavePositionRecordCount, FSavePositionRecNo: integer;
    FUseWaitCursor: boolean;
    procedure ConnectHandler(Sender: TObject);
    procedure DataSetAfterDelete(DataSet: TDataSet);
    procedure DataSetAfterEdit(DataSet: TDataSet);
    procedure DataSetBeforeDelete(DataSet: TDataSet);
    procedure DataSetAfterInsert(DataSet: TDataSet);
    function GetKeyValue: variant;
    procedure SetKeyValue(KeyValue: variant);
    procedure DataSetNewRecord(DataSet: TDataSet);
    procedure DataSetBeforeOpen(DataSet: TDataSet);
    procedure DataSetBeforeInsert(DataSet: TDataSet);
    procedure DataSetAfterOpen(DataSet: TDataSet);
    procedure DataSetAfterScroll(_DataSet: TDataSet);
    procedure DataSetCalcFields(DataSet: TDataSet);
    procedure DataSetAfterPost(DataSet: TDataSet);
    procedure SetDataSetProvider(_DataSetProvider: TDataSetProvider);
    procedure SetADODataSet(_ADODataSet: TADOQuery);
    procedure SetDetailData(Index: integer; _DetailData: TEntity);
    procedure DataSetAfterApplyUpdates(Sender: TObject; var OwnerData: OleVariant);
    procedure DataSetBeforeApplyUpdates(Sender: TObject; var OwnerData: OleVariant);
    procedure SetActive(_Value: boolean);
    function GetActive: boolean;
    procedure DataSetBeforeScroll(_DataSet: TDataSet);
    procedure SetConnection(_Connection: TADOConnection);
    function GetConnection: TADOConnection;
    function GetDetailData(Index: integer): TEntity;
    function GetNewRecordProc: string;
    procedure SetNewRecordProc(const Value: string);
    function GetDeleteRecordProc: string;
    procedure SetDeleteRecordProc(const Value: string);
    function GetUpdateRecordProc: string;
    procedure SetUpdateRecordProc(const Value: string);
    procedure CheckPager;
    procedure CopyRecordFromDataSet(DestDataSet: TDataSet; Delta: TDataSet);
    procedure InsertRecordset(_RecSet: _Recordset);
    procedure SetUsePager(_UsePager: boolean);
    function GetADODataSet: TADOQuery;
    procedure DumpData(DataSet: TDataSet; DataName: string);
  protected
    FOpenNotifier, FAfterInsertNotifier, FAfterScrollNotifier, FAfterDeleteNotifier,
    FOnCalcFieldsNotifier, FAfterApplyNotifier, FBeforeScrollNotifier, FBeforeApplyNotifier,
    FBeforeOpenNotifier, FAfterEditNotifier: TNotifier;
    FKeyField: string;
    FMaxKeyValue: integer;
    FDetailData: array of TEntity;
    FMasterData: TEntity;
    // Означает, что должно присваиваться какое-нибудь уникальное значение ключевому полю
    FAssignKeyValue: boolean;
    // Используется для хранения соответствия реальных и временных ключей
    // и применяется при обновлении дочерних таблиц.
    FItemIds: TIdList;
    FNewRecordProc, FDeleteRecordProc, FUpdateRecordProc: TADOStoredProc;
    // Поле внешнего ключа
    FForeignKeyField: string;
    // Здесь хранится реальный ключ последней добавленной записи после применения изменений
    // с помощью NewRecordProc
    FNewItemID: variant;
    // Список ошибок
    FErrors: TStringList;
    FEnableClearEvents: boolean; // включить если надо очищать события навешенные на датасет на деструкторе
                                 // Не надо включать, если деструктор срабатывает после деструктора датасета
                                 // (например, в finalization)
    FLowPageNum, FHiPageNum: integer; // первая и последняя загруженные страницы
    FInternalName: string;
    // имена полей сортировки
    FSortField: string;
    // поля дат для выборки
    FDateFields: TDateArray;
    // Установить в true если нужно отключить фильтрацию дочерних данных
    FDisableChildDataFilter: boolean;
    // Сначала устанавливается provider, потом ADODataSet (если надо)
    property DataSetProvider: TDataSetProvider read FDataSetProvider write SetDataSetProvider;
    // Сначала устанавливается provider, потом ADODataSet
    // (если уже есть связь между ними, то не надо устанавливать).
    property ADODataSet: TADOQuery read GetADODataSet write SetADODataSet;
    property ADOConnection: TADOCOnnection read GetConnection write SetConnection;

    // Процедура которая применяется для применения изменений при вставке
    property NewRecordProc: string read GetNewRecordProc write SetNewRecordProc;
    // Процедура которая применяется для применения изменений при удалении
    property DeleteRecordProc: string read GetDeleteRecordProc write SetDeleteRecordProc;
    // Процедура, которая применяется для применения изменений при изменении
    property UpdateRecordProc: string read GetUpdateRecordProc write SetUpdateRecordProc;
    // дочерние данные
    property DetailData[Index: integer]: TEntity read GetDetailData write SetDetailData;
    function GetDetailDataNoOpen(Index: integer): TEntity;

    procedure SetDataSet(_DataSet: TDataSet);
    procedure DoOnNewRecord; virtual;
    procedure DoAfterConnect; virtual;
    procedure DoBeforeOpen; virtual;
    procedure DoBeforeInsert; virtual;
    procedure DoAfterOpen; virtual;
    procedure DoAfterApplyUpdates; virtual;
    procedure DoAfterScroll; virtual;
    procedure DoBeforeApplyUpdates; virtual;
    procedure DoOnCalcFields; virtual;
    procedure DoAfterDelete; virtual;
    procedure DoBeforeDelete; virtual;
    procedure DoAfterPost; virtual;
    procedure ProviderBeforeUpdateRecord(Sender: TObject; SourceDS: TDataSet;
      DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind; var Applied: Boolean); virtual;
    procedure ProviderUpdateError(Sender: TObject;
      DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind;
      var Response: TResolverResponse); virtual;
    // обновить фильтр у дочерних
    procedure UpdateChildDataFilter;
    // открыть все дочерние данные
    procedure OpenDetailData;
    procedure SetParentKeyValue(const Value: Variant);
    procedure ClearEvents; virtual;
    procedure LocateRec(KeyVal: variant);
    procedure SetProcParams(FProc: TADOStoredProc; DeltaDS: TDataSet);
    function CreateProc(const ProcName: string; ReturnParam, IncludeKey: boolean): TADOStoredProc;
    function IsFieldForUpdate(f: TField): boolean;
  public
    property DataSet: TDataSet read FDataSet;
    property KeyValue: variant read GetKeyValue write SetKeyValue;
    property Active: boolean read GetActive write SetActive;
    property BeforeOpenNotifier: TNotifier read FBeforeOpenNotifier;
    property OpenNotifier: TNotifier read FOpenNotifier;
    property AfterInsertNotifier: TNotifier read FAfterInsertNotifier;
    property AfterScrollNotifier: TNotifier read FAfterScrollNotifier;
    property BeforeScrollNotifier: TNotifier read FBeforeScrollNotifier;
    property AfterDeleteNotifier: TNotifier read FAfterDeleteNotifier;
    property AfterEditNotifier: TNotifier read FAfterEditNotifier;
    property OnCalcFieldsNotifier: TNotifier read FOnCalcFieldsNotifier;
    property AfterApplyNotifier: TNotifier read FAfterApplyNotifier;
    property KeyField: string read FKeyField write FKeyField;
    property RefreshAfterApply: Boolean read FRefreshAfterApply write FRefreshAfterApply;
    property DefaultLastRecord: Boolean read FDefaultLastRecord write FDefaultLastRecord;

    // Использовать постраничную загрузку
    property UsePager: Boolean read FUsePager write SetUsePager;
    // Управление постраничной загрузкой
    property PagerMode: TPagerMode read FPagerMode write FPagerMode;
    property QueryObject: TQueryObject read FQueryObject write FQueryObject;
    property QueryPager: TQueryPager read FQueryPager;
    // Отображать SQLWait курсор при загрузке (default=true)
    property UseWaitCursor: Boolean read FUseWaitCursor write FUseWaitCursor;

    property InternalName: string read FInternalName;
    property SortField: string read FSortField;
    property DateFields: TDateArray read FDateFields;
    property ItemIds: TIdList read FItemIds;
    // True, если после перезагрузки надо остаться на той же странице (в режиме постраничной загрузки)
    property SavePagePosition: boolean read FSavePagePosition write FSavePagePosition;
    property NewItemID: variant read FNewItemID;

    constructor Create; virtual;
    destructor Destroy; override;
    procedure Open; virtual;
    procedure Close; virtual;
    function Locate(_KeyValue: variant): boolean; virtual;
    function ApplyUpdates: boolean; overload; virtual;
    procedure CancelUpdates; virtual;
    procedure Reload; virtual;
    procedure ReloadLocate(KeyVal: variant);
    // проверяет есть ли изменения в данных или в дочерних
    function HasChanges: boolean;
    procedure Append;
    procedure Delete;
    // удаляет запись, применяет изменения к БД и фокусирует следующую строку (или предыдущую, если нет след.)
    procedure DeleteAndApply;
    // Создает набор данных с копией данных. Если DisableFilter = true,
    // то отключает фильтр на текущем наборе перед копированием.
    function CopyData(DisableFilter: boolean): TClientDataSet;
    procedure MergeData(Delta: TClientDataSet);
    function IsEmpty: boolean; virtual;
    procedure SaveLocation;
    procedure RestoreLocation;
    function RecordCount: integer;
    function TotalRecordCount: integer; virtual;
    procedure FetchAllRecords;
    function Modified: boolean; virtual;
    procedure SetSortOrder(_SortField: string; MakeActive: boolean); virtual;
    // Перекрыв эту функцию, можно указать, надо ли обновить данные при вызове Reload, ReloadLocate
    function NeedReload: boolean; virtual;
    //function Copy: TEntity; virtual; abstract;
  end;

implementation

uses PmDatabase, Variants, TLoggerUnit;

const
  PageLoadMargin = 100;

constructor TEntity.Create;
begin
  inherited Create;
  FInternalName := ClassName;
  FNtfID := ConnectNotifier.RegisterHandler(ConnectHandler);
  FBeforeOpenNotifier := TNotifier.Create;
  FOpenNotifier := TNotifier.Create;
  FAfterScrollNotifier := TNotifier.Create;
  FBeforeScrollNotifier := TNotifier.Create;
  FAfterDeleteNotifier := TNotifier.Create;
  FAfterEditNotifier := TNotifier.Create;
  FAfterInsertNotifier := TNotifier.Create;
  FOnCalcFieldsNotifier := TNotifier.Create;
  FAfterApplyNotifier := TNotifier.Create;
  FBeforeApplyNotifier := TNotifier.Create;
  FRefreshAfterApply := true;
  FDefaultLastRecord := false;
  FUseWaitCursor := true;

  FItemIds := TIdList.Create;

  FErrors := TStringList.Create;
end;

destructor TEntity.Destroy;
begin
//  if FDataSet <> nil then FreeAndNil(FDataSet);
  //if FDataSetProvider <> nil then FreeAndNil(FDataSetProvider);
  //if FADODataSet <> nil then FreeAndNil(FADODataSet);
  if FEnableClearEvents then ClearEvents;
  ConnectNotifier.UnregisterHandler(FNtfID);
  FBeforeOpenNotifier.Free;
  FOpenNotifier.Free;
  FAfterInsertNotifier.Free;
  FAfterDeleteNotifier.Free;
  FAfterEditNotifier.Free;
  FAfterScrollNotifier.Free;
  FBeforeScrollNotifier.Free;
  FOnCalcFieldsNotifier.Free;
  FAfterApplyNotifier.Free;
  FBeforeApplyNotifier.Free;
  FItemIds.Free;
  FErrors.Free;
  FQueryPager.Free;
  inherited Destroy;
end;

procedure TEntity.ConnectHandler(Sender: TObject);
begin
  DoAfterConnect;
  SetConnection(TADOConnection(Sender));
end;

procedure TEntity.SetConnection(_Connection: TADOConnection);
begin
  // Датасет может быть еще не создан, т.к. это событие вызывается при соединении
  // главного модуля, а датасет может быть в другом.
  if ADODataSet <> nil then
  begin
    ADODataSet.Connection := _Connection;
    ADODataSet.CommandTimeout := ConnectInfo.CommandTimeout;
  end;
  if FNewRecordProc <> nil then
  begin
    FNewRecordProc.Connection := _Connection;
    FNewRecordProc.CommandTimeout := ConnectInfo.CommandTimeout;
  end;
  if FDeleteRecordProc <> nil then
  begin
    FDeleteRecordProc.Connection := _Connection;
    FDeleteRecordProc.CommandTimeout := ConnectInfo.CommandTimeout;
  end;
end;

function TEntity.GetConnection: TADOConnection;
begin
  Result := ADODataSet.Connection;
end;

procedure TEntity.DataSetBeforeOpen(DataSet: TDataSet);
begin
  FBeforeOpenNotifier.Notify(Self);
  DoBeforeOpen;
end;

procedure TEntity.DataSetAfterOpen(DataSet: TDataSet);
begin
  if FNewRecordProc <> nil then
  begin
    // Отрицательные значения используются
    FMaxKeyValue := -1;
  end;
    
  FOpenNotifier.Notify(Self);
  DoAfterOpen;
end;

procedure TEntity.DataSetBeforeInsert(DataSet: TDataSet);
begin
  if not FMergingData then
    DoBeforeInsert;
end;

procedure TEntity.DoBeforeInsert;
begin

end;

procedure TEntity.SetProcParams(FProc: TADOStoredProc; DeltaDS: TDataSet);
var
  f: TField;
  I: Integer;
begin
  for I := 0 to DataSet.Fields.Count - 1 do
  begin
    // Пропускаем ключевые и необновляемые поля
    f := DataSet.Fields[i];  // Здесь нужно анализировать оригинальное поле в наборе данных
    if IsFieldForUpdate(f) and (DeltaDS.FindField(f.FieldName) <> nil) then
    begin
      AssignProcParam(FProc, DeltaDS, f.FieldName);
    end;
  end;
end;

procedure TEntity.ProviderBeforeUpdateRecord(Sender: TObject; SourceDS: TDataSet;
  DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind; var Applied: Boolean);
var
  TmpID, RealID: integer;
begin
  DeltaDS.FieldByName(FKeyField).ProviderFlags := [pfInKey, pfInWhere];

  // Вставляем реальный ключ родительской записи вместо временного
  if (UpdateKind = ukInsert) and (FMasterData <> nil) and (FMasterData.FNewRecordProc <> nil) then
  begin
    RealID := FMasterData.FItemIds.GetRealItemID(DeltaDS[FForeignKeyField], false);
    if (RealID <> 0) and (RealID <> DeltaDS[FForeignKeyField]) then
    begin
      DeltaDS.Edit;
      DeltaDS[FForeignKeyField] := RealID;
    end;
  end;
  //DoBeforeUpdateRecord(Sender, SourceDS, DeltaDS, UpdateKind, Applied);

  if (FNewRecordProc <> nil) and (UpdateKind = ukInsert) then
  begin
    TmpID := DeltaDS[KeyField];
    SetProcParams(FNewRecordProc, DeltaDS);
    FNewRecordProc.ExecProc;
    FNewItemID := FNewRecordProc.Parameters.ParamValues['@RETURN_VALUE'];
    // Сохраняем реальное значение ключа в списке соответствия ключей
    FItemIDs.AddRealItemID(TmpID, FNewItemID);
    Applied := true;
  end
  else if (FDeleteRecordProc <> nil) and (UpdateKind = ukDelete) then
  begin
    FDeleteRecordProc.Parameters[0].Value := DeltaDS.FieldByName(KeyField).OldValue;
    FDeleteRecordProc.ExecProc;
    Applied := true;
  end
  else if (FUpdateRecordProc <> nil) and (UpdateKind = ukModify) then
  begin
    AssignProcParam(FUpdateRecordProc, DeltaDS, KeyField);  // здесь еще и ключевое поле
    SetProcParams(FUpdateRecordProc, DeltaDS);
    FUpdateRecordProc.ExecProc;
    Applied := true;
  end;
end;

{procedure TEntity.DoBeforeUpdateRecord(Sender: TObject; SourceDS: TDataSet;
  DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind; var Applied: Boolean);
begin
  DeltaDS.FieldByName(FKeyField).ProviderFlags := [pfInKey, pfInWhere];
end;}

function TEntity.Locate(_KeyValue: variant): boolean;
begin
  if not DataSet.Active then Open;//Database.OpenDataSet(DataSet);
  Result := DataSet.Locate(FKeyField, _KeyValue, []);
  if not Result and FDefaultLastRecord then DataSet.Last;
end;

function TEntity.GetKeyValue: variant;
begin
  Result := DataSet[FKeyField];
end;

procedure TEntity.SetKeyValue(KeyValue: variant);
begin
  Locate(KeyValue);
end;

procedure TEntity.Open;
var
  OldUsePager: boolean;
  FromRowNum: integer;
begin
  if not FDataSet.Active then
  begin
    DataSetBeforeOpen(FDataSet);

    if FUsePager then
    begin
      CheckPager;
      if FDefaultLastRecord then
      begin
        if FSavePagePosition and (FSavePositionRecNo > 0) then
        begin
          // FSavePositionRecNo будет = 0, если DataSet был неактивен до обновления.
          // Если надо остаться на этой же странице после перезагрузки:
          // Определяем, с какой страницы надо загружать данные, чтобы туда вошла текущая запись.
          {CurrentPageNum := FQueryPager.PageCount - (FSavePositionRecordCount div FQueryPager.RowsOnPage)
            + FSavePositionRecNo div FQueryPager.RowsOnPage;}
          FromRowNum := ((FQueryPager.RowCount - FSavePositionRecordCount + FSavePositionRecNo)
            div FQueryPager.RowsOnPage) * FQueryPager.RowsOnPage + 1;
          if (FSavePositionRecNo < PageLoadMargin) and (FromRowNum > FQueryPager.RowsOnPage) then
            FromRowNum := FromRowNum - FQueryPager.RowsOnPage;
          ADODataSet.RecordSet := FQueryPager.LoadFromRow(FromRowNum);
          FLowPageNum := FromRowNum div FQueryPager.RowsOnPage + 1;
        end
        else
        begin
          ADODataSet.Recordset := FQueryPager.LoadLastPage;
          FLowPageNum := FQueryPager.PageCount;
        end;
        FHiPageNum := 1;
      end
      else
      begin
        ADODataSet.Recordset := FQueryPager.LoadFirstPage;
        FLowPageNum := 1;
        FHiPageNum := FQueryPager.PageCount;
      end;
    end;

    OldUsePager := FUsePager;
    // надо отключить, чтобы не сработал AfterScroll, иначе в режиме загрузки
    // с конца сразу сработает загрузка предыдущей страницы. 
    FUsePager := false;
    try
      Database.OpenDataSet(FDataSet);
      DataSetAfterOpen(FDataSet);
    finally
      FUsePager := OldUsePager;
    end;

    OpenDetailData;
    UpdateChildDataFilter;
  end;
end;

procedure TEntity.OpenDetailData;
var
  I: integer;
  _DetailData: TEntity;
begin
  for I := Low(FDetailData) to High(FDetailData) do
  begin
    _DetailData := FDetailData[I];
    if _DetailData <> nil then
      _DetailData.Open;
  end;
end;

procedure TEntity.CheckPager;
begin
  if PagerMode = pmCursor then
  begin
    if (FQueryPager = nil) and (ADODataSet <> nil) then
    begin
      FQueryPager := TADOCursorQueryPager.Create(ADODataSet.SQL.Text);
    end else
      if FQueryPager.QueryText <> ADODataSet.SQL.Text then
        FQueryPager.QueryText := ADODataSet.SQL.Text;
  end
  else if PagerMode = pmStructuredQuery then
  begin
    if FQueryPager = nil then
    begin
      FQueryPager := TADOStructuredQueryPager.Create;
      FQueryPager.QueryObject := FQueryObject;
    end else
      if not FQueryPager.QueryObject.Equals(FQueryObject) then
        FQueryPager.QueryObject := FQueryObject;
  end;

end;

procedure TEntity.Close;
var
  I: integer;
  _DetailData: TEntity;
begin
  if FQueryPager <> nil then FQueryPager.Close;

  for I := Low(FDetailData) to High(FDetailData) do
  begin
    _DetailData := FDetailData[I];
    if _DetailData <> nil then _DetailData.Close;
  end;
  
  DataSet.Close;
end;

procedure TEntity.DataSetNewRecord(DataSet: TDataSet);
begin
  if not FMergingData then
  begin
    // В режиме отслеживания новых записей
    if (FNewRecordProc <> nil) or FAssignKeyValue then
    begin
      // Отрицательные значения используются
      DataSet[KeyField] := FMaxKeyValue;
      FMaxKeyValue := FMaxKeyValue - 1;
    end;

    if FMasterData <> nil then
      DataSet[FForeignKeyField] := FMasterData.KeyValue;

    DoOnNewRecord;
  end;
end;

procedure TEntity.SetDataSet(_DataSet: TDataSet);
begin
  FDataSet := _DataSet;
  if FDataSet <> nil then
  begin
    FDataSet.OnNewRecord := DataSetNewRecord;
    //FDataSet.BeforeOpen := DataSetBeforeOpen;
    //FDataSet.AfterOpen := DataSetAfterOpen;
    FDataSet.BeforeScroll := DataSetBeforeScroll;
    FDataSet.AfterScroll := DataSetAfterScroll;
    FDataSet.BeforeDelete := DataSetBeforeDelete;
    FDataSet.AfterDelete := DataSetAfterDelete;
    FDataSet.AfterEdit := DataSetAfterEdit;
    FDataSet.AfterInsert := DataSetAfterInsert;
    FDataSet.BeforeInsert := DataSetBeforeInsert;
    FDataSet.OnCalcFields := DataSetCalcFields;
    FDataSet.AfterPost := DataSetAfterPost;
    if FDataSet is TClientDataSet then
    begin
      TClientDataset(FDataSet).AfterApplyUpdates := DataSetAfterApplyUpdates;
      TClientDataset(FDataSet).BeforeApplyUpdates := DataSetBeforeApplyUpdates;
    end;
  end;
end;

procedure TEntity.ClearEvents;
begin
  if FDataSet <> nil then
  begin
    FDataSet.OnNewRecord := nil;
    FDataSet.BeforeOpen := nil;
    FDataSet.AfterOpen := nil;
    FDataSet.BeforeScroll := nil;
    FDataSet.AfterScroll := nil;
    FDataSet.BeforeDelete := nil;
    FDataSet.AfterDelete := nil;
    FDataSet.AfterInsert := nil;
    FDataSet.BeforeInsert := nil;
    FDataSet.OnCalcFields := nil;
    FDataSet.AfterPost := nil;
    if FDataSet is TClientDataSet then
    begin
      TClientDataset(FDataSet).AfterApplyUpdates := nil;
      TClientDataset(FDataSet).BeforeApplyUpdates := nil;
    end;
  end;
  if FDataSetProvider <> nil then
  begin
    FDataSetProvider.BeforeUpdateRecord := nil;
    FDataSetProvider.OnUpdateError := nil;
  end;
end;

procedure TEntity.SetADODataSet(_ADODataSet: TADOQuery);
begin
  //FADODataSet := _ADODataSet;
  FDataSetProvider.DataSet := _ADODataSet;
end;

procedure TEntity.SetDataSetProvider(_DataSetProvider: TDataSetProvider);
begin
  FDataSetProvider := _DataSetProvider;
  if FDataSetProvider <> nil then
  begin
    FDataSetProvider.BeforeUpdateRecord := ProviderBeforeUpdateRecord;
    FDataSetProvider.OnUpdateError := ProviderUpdateError;
  end;
end;

procedure TEntity.DoOnNewRecord;
begin
end;

procedure TEntity.DoAfterConnect;
begin
end;

procedure TEntity.DoBeforeOpen;
begin
end;

procedure TEntity.DoAfterOpen;
begin
end;

procedure TEntity.DataSetAfterApplyUpdates(Sender: TObject; var OwnerData: OleVariant);
begin
  //DoAfterApplyUpdates;
end;

procedure TEntity.DoAfterApplyUpdates;
begin
  if FRefreshAfterApply then
  begin
    Reload;
  end;
  FAfterApplyNotifier.Notify(Self);
end;

procedure TEntity.DataSetBeforeApplyUpdates(Sender: TObject; var OwnerData: OleVariant);
begin
  FErrors.Clear;
  DoBeforeApplyUpdates;
end;

procedure TEntity.DoBeforeApplyUpdates;
begin
  FBeforeApplyNotifier.Notify(Self);
end;

{function TEntity.ApplyUpdates(_ParentIds: TIdList): boolean;
begin
  FParentIds := _ParentIds;
  Result := ApplyUpdates;
end;}

// Применяет изменения данных и вызывает AfterApplyUpdates, который
// при необходимости обновляет их и восстанавливает текущую запись.
function TEntity.ApplyUpdates: boolean;
var
  ds: TClientDataSet;
  I: integer;
  _DetailData: TEntity;
  CCount: integer;
begin
  Result := true;
  CCount := 1;
  //DataSet.CheckBrowseMode;
  if DataSet.State in [dsInsert, dsEdit] then DataSet.Post;

  FItemIds.Clear;
  FNewItemID := null;

  if DataSet is TClientDataSet then
  begin
    ds := DataSet as TClientDataSet;
    try
      CCount := ds.ChangeCount;
    except
      TLogger.GetInstance.Error('ChangeCount failed for ' + ds.Name);
      CCount := 1;
    end;
    if CCount > 0 then
    begin
      //if ds.IsEmpty then FCurKeyValue := -1000 else FCurKeyValue := ds[FKeyField];
      SaveLocation;
      try
        Result := ds.ApplyUpdates(0) = 0;
        if FErrors.Count > 0 then raise Exception.Create(FErrors[0]);
      except on e: Exception do
        if FErrors.Count > 0 then raise Exception.Create(FErrors[0])
        else raise;
      end;
      // остальное в AfterApplyUpdates
    end;
  end
  else if DataSet is TADOQuery then
  begin
    if (DataSet as TADOQuery).UpdateStatus <> usUnmodified then
    begin
      //if DataSet.IsEmpty then FCurKeyValue := -1000 else FCurKeyValue := DataSet[FKeyField];
      SaveLocation;
      (DataSet as TADOQuery).UpdateBatch;
    end;
  end;

  if Result then
  begin
    //if FDetailData then
    //begin
//      try
        for I := Low(FDetailData) to High(FDetailData) do
        begin
          _DetailData := FDetailData[I];
          Result := _DetailData.ApplyUpdates;
          if not Result then break;
        end;
//      except on e: Exception do
//        if FDetailData.FErrors.Count > 0 then raise FDetailData.FErrors.Objects[0]
//        else raise;
//      end;
    //end;
    DoAfterApplyUpdates;
  end;
end;

procedure TEntity.CancelUpdates;
var
  I: integer;
  _DetailData: TEntity;
begin
  for I := Low(FDetailData) to High(FDetailData) do
  begin
    _DetailData := FDetailData[I];
    if _DetailData <> nil then _DetailData.CancelUpdates;
  end;
  if DataSet is TClientDataSet then
    (DataSet as TClientDataSet).CancelUpdates
  else if DataSet is TADOQuery then begin
    { Было обнаружено странное поведение в этом месте: при выполнении
      CancelUpdates выскакивает ошиька ADO, что текущая запись была удалена,
      но except почему-то не срабатывает.
      Если в таблице нет ни одной записи, то грид потом начинает страшно глючить.
      Поэтому в этом случае просто перезагружаем запрос. }
    if DataSet.RecordCount > 1 then (DataSet as TADOQuery).CancelUpdates
    else Reload;
  end;
end;

procedure TEntity.ReloadLocate(KeyVal: variant);
var
  Save_Cursor: TCursor;
begin
  // Проверяем, требуется ли обновление
  if not DataSet.Active or NeedReload then
  begin
    if FSavePagePosition then
    begin
      if DataSet.Active then
      begin
        // сохраняем позицию для восстановления текущей страницы
        FSavePositionRecordCount := FDataSet.RecordCount;
        FSavePositionRecNo := FDataSet.RecNo;
      end
      else
      begin
        FSavePositionRecordCount := 0;
        FSavePositionRecNo := 0;
      end;
    end;
    if FUseWaitCursor then
    begin
      Save_Cursor := Screen.Cursor;
      Screen.Cursor := crSQLWait;    { Show hourglass cursor }
    end;
    DataSet.DisableControls;
    try
      Close; // with child data
      //RemoteControl.OpenDataSet(DataSet);
      Open;
      LocateRec(KeyVal);
      UpdateChildDataFilter;
    finally
      DataSet.EnableControls;
      if FUseWaitCursor then
        Screen.Cursor := Save_Cursor;  { Always restore to normal }
    end;
  end
  else
    LocateRec(KeyVal);
end;

procedure TEntity.LocateRec(KeyVal: variant);
begin
  if not VarIsEmpty(KeyVal) and (NvlInteger(KeyVal) <> -1000) then
  begin
    if not DataSet.Locate(FKeyField, KeyVal, []) then
      if FDefaultLastRecord then DataSet.Last;
  end
  else
    if FDefaultLastRecord then DataSet.Last;
end;

function TEntity.NeedReload: boolean;
begin
  Result := true;
end;

procedure TEntity.Reload;
begin
  SaveLocation;
  ReloadLocate(FCurKeyValue);
  FCurKeyValue := Unassigned;
end;

procedure TEntity.SaveLocation;
begin
  if (DataSet = nil) or not DataSet.Active or DataSet.IsEmpty then
    FCurKeyValue := -1000
  else
    FCurKeyValue := DataSet[FKeyField];
end;

procedure TEntity.RestoreLocation;
begin
  Locate(FCurKeyValue);
end;

procedure TEntity.DataSetAfterDelete(DataSet: TDataSet);
begin
  DoAfterDelete;
  FAfterDeleteNotifier.Notify(Self);
end;

procedure TEntity.DataSetBeforeDelete(DataSet: TDataSet);
begin
  DoBeforeDelete;
end;

procedure TEntity.DataSetAfterEdit(DataSet: TDataSet);
begin
  //DoAfterDelete;
  FAfterEditNotifier.Notify(Self);
end;

procedure TEntity.DataSetAfterInsert(DataSet: TDataSet);
begin
  if not FMergingData then
    FAfterInsertNotifier.Notify(Self);
end;

procedure TEntity.DataSetAfterScroll(_DataSet: TDataSet);
var
  NewData: _Recordset;
  //NewLowPageNum: integer;
begin
  if not FMergingData then
  begin
    if FUsePager and (FDataSet.RecNo <> -1) then  // проверка для режима добавления записи
    begin
      // проверяем, не дошли ли до начала набора данных и если ли еще страницы
      if (FDataSet.RecNo < PageLoadMargin) and (FLowPageNum > 1)
        and (FQueryPager.RowCount > FQueryPager.RowsOnPage) then
      begin
        //NewLowPageNum := FQueryPager.PageCount - (FDataSet.RecordCount - FDataSet.RecNo) div FQueryPager.RowsOnPage; //FLowPageNum - 1;
        //if NewLowPageNum < FLowPageNum then
        //begin
          //FLowPageNum := NewLowPageNum;
          FLowPageNum := FLowPageNum - 1;
          NewData := FQueryPager.LoadPage(FLowPageNum);
          if NewData <> nil then
            InsertRecordset(NewData);
        //end;
      end;
    end;  //UpdateChildDataFilter;
    if FAfterScrollNotifier <> nil then
      FAfterScrollNotifier.Notify(Self);
    DoAfterScroll;
  end;
end;

{// используется в режиме постраничной выборки для пристыковки набора данных
procedure TEntity.InsertRecordset(_RecSet: _Recordset);
var
  FieldHandlers: array of TDataSetNotifyEvent;

  procedure DisableFieldChange;
  var
    I: Integer;
  begin
    SetLength(FieldHandlers, FDataSet.Fields.Count);
    for I := 0 to FDataSet.Fields.Count - 1 do
    begin
      //FieldHandlers[I].FieldName := FDataSet.Fields[I].FieldName;
      //FieldHandlers[I] := FDataSet.Fields[I].OnChange;
      FDataSet.Fields[I].OnChange := nil;
      FDataSet.Fields[I].OnGetText := nil;
    end;
  end;

  procedure EnableFieldChange;
  var
    I: Integer;
  begin
    for I := 0 to FDataSet.Fields.Count - 1 do
    begin
      //FDataSet.Fields[I].OnChange := FieldHandlers[I];
    end;
  end;

var
  aq: TADOQuery;
  OldKeyValue: variant;
begin
  aq := TADOQuery.Create(nil);
  OldKeyValue := KeyValue;
  FDataSet.DisableControls;
  FUsePager := false;
  FMergingData := true;
  FDataSet.AutoCalcFields := false;
  (FDataSet as TClientDataSet).LogChanges := false;
  try
    aq.Recordset := _RecSet;
    aq.Last;
    while not aq.Bof do
    begin
      FDataSet.First;
      FDataSet.Insert;
      CopyRecordFromDataSet(aq);
      FDataSet.CheckBrowseMode;
      aq.Prior;
    end;
    // айяяяй
    (FDataSet as TClientDataSet).MergeChangeLog;
  finally
    aq.Free;
    if not VarIsEmpty(OldKeyvalue) and not VarIsNull(OldKeyValue) then
      Locate(OldKeyValue);
    FUsePager := true;
    FDataSet.EnableControls;
    FMergingData := false;
    (FDataSet as TClientDataSet).LogChanges := true;
    FDataSet.AutoCalcFields := true;
  end;
end;}

procedure TEntity.DumpData(DataSet: TDataSet; DataName: string);
var
  s: string;
  i: integer;
  k: variant;
begin
  TLogger.GetInstance.Info('-------------- ' + DataName + ' ----------------');
  k := DataSet[KeyField];
  DataSet.First;
  while not DataSet.eof do
  begin
    //s := IntToStr(DataSet[KeyField]);
    //TLogger.getInstance.Info('Record #' + IntToStr(i) + ' ' + s);
    s := '';
    for I := 0 to DataSet.Fields.Count - 1 do
    begin
      if s <> '' then
        s := s + #9;
      s := s + VarToStr(DataSet.Fields[I].Value);
    end;
    TLogger.getInstance.Info(s);
    DataSet.Next;
  end;
  if not VarIsNull(k) then DataSet.Locate(KeyField, k, []);
  TLogger.GetInstance.Info('-------------- End of ' + DataName + ' ----------------');
end;


// используется в режиме постраничной выборки для пристыковки набора данных
procedure TEntity.InsertRecordset(_RecSet: _Recordset);
var
  aq: TADOQuery;
  OldKeyValue: variant;
  NewData: TClientDataSet;
  SavedFlags: TProviderFlags;
begin
  aq := TADOQuery.Create(nil);
  OldKeyValue := KeyValue;
  FDataSet.DisableControls;
  FUsePager := false;
  FMergingData := true;
  FDataSet.AutoCalcFields := false;
  try
    //(FDataSet as TClientDataSet).LogChanges := false;
    NewData := CopyData(true); // копия текущих данных
    SavedFlags := FDataSet.FieldByName(KeyField).ProviderFlags;
    NewData.FieldByName(KeyField).ProviderFlags := [pfInUpdate];
    //DumpData(NewData, 'NewData 1');
    try
      aq.Recordset := _RecSet;
      aq.Last;
      // Добавляем новые данные в начало копии текущих
      while not aq.Bof do
      begin
        NewData.First;
        NewData.Insert;
        CopyRecordFromDataSet(NewData, aq);
        NewData.CheckBrowseMode;
        aq.Prior;
      end;
      //DumpData(aq, 'RecSet');
      //DumpData(NewData, 'NewData 2');
      NewData.MergeChangeLog;
      (FDataSet as TClientDataSet).EmptyDataSet;
      (FDataSet as TClientDataSet).MergeChangeLog;
      FDataSet.FieldByName(KeyField).ProviderFlags := [pfInUpdate];
      // заменяем данные на новые
      (FDataSet as TClientDataSet).Data := NewData.Data;
      //DumpData(FDataSet, 'Current after assign');
      // айяяяй
      //(FDataSet as TClientDataSet).MergeChangeLog;
    finally
      NewData.Free;
      aq.Free;
      FDataSet.FieldByName(KeyField).ProviderFlags := SavedFlags;
      if not VarIsEmpty(OldKeyvalue) and not VarIsNull(OldKeyValue) then
        Locate(OldKeyValue);
      FUsePager := true;
      FDataSet.EnableControls;
      //(FDataSet as TClientDataSet).LogChanges := true;
    end;
  finally
    // временно разрешаем вычисление полей
    FTempEnableCalcFields := true;
    try
      FDataSet.AutoCalcFields := true;
      FreshQuery(FDataSet);
    finally
      FTempEnableCalcFields := false;
    end;
    // теперь разрешаем все
    FMergingData := false;
  end;
end;

procedure TEntity.DataSetBeforeScroll(_DataSet: TDataSet);
begin
  if not FMergingData then
    if FBeforeScrollNotifier <> nil then FBeforeScrollNotifier.Notify(Self);
end;

procedure TEntity.DataSetCalcFields(DataSet: TDataSet);
begin
  if not FMergingData or FTempEnableCalcFields then
  begin
    DoOnCalcFields;
    FOnCalcFieldsNotifier.Notify(Self);
  end;
end;

procedure TEntity.DataSetAfterPost(DataSet: TDataSet);
begin
  DoAfterPost;
end;

procedure TEntity.SetDetailData(Index: integer; _DetailData: TEntity);
var
  Det: TEntity;
begin
  if Index >= Length(FDetailData) then
    SetLength(FDetailData, Index + 1);

  Det := FDetailData[Index];
  if (Det <> nil) and (Det.FMasterData = Self) then begin
    Det.FMasterData := nil;
    Det.DataSet.Filter := '';
    Det.DataSet.Filtered := false;
  end;

  FDetailData[Index] := _DetailData;
  if _DetailData <> nil then _DetailData.FMasterData := Self;
  DataSetAfterScroll(DataSet);
end;

procedure TEntity.SetActive(_Value: boolean);
begin
  if _Value then Open else Close;
end;

function TEntity.GetActive: boolean;
begin
  Result := FDataSet.Active;
end;

function TEntity.HasChanges: boolean;
var
  I: Integer;
begin
  if DataSet is TClientDataSet then
    Result := (DataSet as TClientDataSet).ChangeCount > 0
  else if DataSet is TADOQuery then
    Result := (DataSet as TADOQuery).UpdateStatus <> usUnmodified
  else
    raise EAssertionFailed.Create('Неизвестный тип набора данных ' + DataSet.ClassName);

  // ищем изменения в дочерних
  if not Result then
    for I := Low(FDetailData) to High(FDetailData) do
    begin
      Result := Result or DetailData[I].HasChanges;
      if Result then break;
    end;
end;

procedure TEntity.DoAfterScroll;
begin
end;

procedure TEntity.DoOnCalcFields;
begin
end;

procedure TEntity.DoAfterDelete;
begin
end;

procedure TEntity.DoBeforeDelete;
begin
end;

procedure TEntity.DoAfterPost;
begin
end;

function TEntity.GetDetailData(Index: integer): TEntity;
begin
  Result := FDetailData[Index];
  if not Result.Active then
    Result.Open;

  // обновить фильтр у дочерних
  UpdateChildDataFilter;
end;

function TEntity.GetDetailDataNoOpen(Index: integer): TEntity;
begin
  Result := FDetailData[Index];
end;

function TEntity.GetNewRecordProc: string;
begin
  Result := FNewRecordProc.ProcedureName;
end;

procedure TEntity.SetNewRecordProc(const Value: string);
begin
  if FNewRecordProc <> nil then FreeAndNil(FNewRecordProc);
  if Value <> '' then
  begin
    FNewRecordProc := CreateProc(Value, true, false);
  end;
end;

function TEntity.IsFieldForUpdate(f: TField): boolean;
begin
  Result := (pfInUpdate in f.ProviderFlags) and not (pfInKey in f.ProviderFlags)
      and (f.FieldKind = fkData)
      and (CompareText(f.FieldName, KeyField) <> 0);
end;

function TEntity.CreateProc(const ProcName: string; ReturnParam, IncludeKey: boolean): TADOStoredProc;
var
  I: Integer;
  f: TField;
  Param: TParameter;
begin
  Result := TADOStoredProc.Create(nil);
  if ADODataSet <> nil then
  begin
    Result.Connection := ADODataSet.Connection;
    Result.CommandTimeout := ADODataSet.CommandTimeout;
  end
  else
  begin
    Result.Connection := Database.Connection;
    Result.CommandTimeout := ConnectInfo.CommandTimeout;
  end;
  Result.ProcedureName := ProcName;

  if ReturnParam then
    Result.Parameters.CreateParameter('@RETURN_VALUE', ftInteger, pdReturnValue, 0, null);

  for I := 0 to DataSet.Fields.Count - 1 do
  begin
    f := DataSet.Fields[i];
    if IsFieldForUpdate(f) or (IncludeKey and (CompareText(f.FieldName, KeyField) = 0)) then
    begin
      Param := TParameter.Create(Result.Parameters);
      Param.Name := '@' + f.FieldName;
      Param.DataType := f.DataType;
    end;
  end;
end;

function TEntity.GetDeleteRecordProc: string;
begin
  Result := FDeleteRecordProc.ProcedureName;
end;

function TEntity.GetUpdateRecordProc: string;
begin
  Result := FUpdateRecordProc.ProcedureName;
end;

procedure TEntity.SetDeleteRecordProc(const Value: string);
begin
  if FDeleteRecordProc <> nil then FreeAndNil(FDeleteRecordProc);
  if Value <> '' then
  begin
    FDeleteRecordProc := TADOStoredProc.Create(nil);
    if ADODataSet <> nil then
    begin
      FDeleteRecordProc.Connection := ADODataSet.Connection;
      FDeleteRecordProc.CommandTimeout := ADODataSet.CommandTimeout;
    end
    else
    begin
      //raise Exception.Create('Не создан набор данных');
      FDeleteRecordProc.Connection := Database.Connection;
      FDeleteRecordProc.CommandTimeout := ConnectInfo.CommandTimeout;
    end;
    FDeleteRecordProc.ProcedureName := Value;
    FDeleteRecordProc.Parameters.CreateParameter('@' + KeyField, ftInteger, pdInput, 0, null);
  end;
end;

procedure TEntity.SetUpdateRecordProc(const Value: string);
begin
  if FUpdateRecordProc <> nil then
    FreeAndNil(FUpdateRecordProc);
  if Value <> '' then
    FUpdateRecordProc := CreateProc(Value, false, true);
//    if FUpdateProc = nil then
      //FUpdateProc := CreateProc(FUpdateRecordProc, false);
end;


// обновить фильтр у дочерних
procedure TEntity.UpdateChildDataFilter;
var
  I: integer;
  _DetailData: TEntity;
begin
  if not FDisableChildDataFilter then
  begin
    for I := Low(FDetailData) to High(FDetailData) do
    begin
      _DetailData := FDetailData[I];
      if (DataSet <> nil) and (_DetailData <> nil) and (_DetailData.DataSet <> nil) then
        _DetailData.SetParentKeyValue(KeyValue);
    end;
  end;
end;

procedure TEntity.SetParentKeyValue(const Value: Variant);
var
  NewFilter: string;
begin
  //FParentKeyValue := Value;
  if VarIsNull(Value) then
  begin
    NewFilter := FForeignKeyField + ' = null';
  end
  else
  begin
    NewFilter := FForeignKeyField + ' = ' + VarToStr(Value);
  end;
  if DataSet.Filter <> NewFilter then
    DataSet.Filter := NewFilter;
  if not DataSet.Filtered then
    DataSet.Filtered := true;
end;

function TEntity.CopyData(DisableFilter: boolean): TClientDataSet;
var
  f: TField;
  KeyVal: variant;
  I: integer;
  WasFiltered: boolean;
begin
  Result := TClientDataSet.Create(FDataSet.Owner);
  CopyFieldDefs(FDataSet, Result);
  Result.CreateDataSet;

  KeyVal := KeyValue;  // Запоминаем текущее значение ключа

  FDataSet.DisableControls;
  try
    WasFiltered := FDataSet.Filtered; //отключаем фильтр если надо
    if DisableFilter and WasFiltered then
    begin
      // 08.09.2008 Более простой способ для этого случая, но кажись не более быстрый
      //Result.Data := (FDataSet as TClientDataSet).Data;
      //DumpData(Result, 'Result.Data');
      FDataSet.Filtered := false;  // фильтр можно не отключать
    end
    else
    begin
      FDataSet.First;
      while not FDataSet.Eof do
      begin
        Result.Append;
        for I := 0 to FDataSet.Fields.Count - 1 do
        begin
          f := FDataSet.Fields[i];
          //TLogger.GetInstance.Debug(Result.Fields[i].FieldName + ' ' + IntToStr(VarType(f.Value)));
          //TLogger.GetInstance.Debug(VarToStr(f.Value));
          try
            Result.Fields[i].Assign(f);
          except
            TLogger.GetInstance.Error('Пропущено: некорректное преобразование типа в TEntity.CopyData, поле ' + f.FieldName);
          end;
        end;    // for
        FDataSet.Next;
      end;    // while
    end;
  finally
    FDataSet.EnableControls;
    if WasFiltered then        // фильтр можно не восстанавливать, не отключали
      FDataSet.Filtered := true;
  end;

  Result.CheckBrowseMode;
  Result.MergeChangeLog;

  // Устанавливаем текущую позицию в копии и оригинале
  if not Result.IsEmpty and not VarIsNull(KeyVal)
     and not Result.Locate(KeyField, KeyVal, []) then
    raise Exception.Create('Не найдено значение ключа ' + VarToStr(KeyVal));

  if not DataSet.IsEmpty and not VarIsNull(KeyVal)
     and not DataSet.Locate(KeyField, KeyVal, []) then
    raise Exception.Create('Не найдено значение ключа ' + VarToStr(KeyVal));

end;

procedure TEntity.MergeData(Delta: TClientDataSet);
var
  I: Integer;
  OldFiltered: boolean;
  f, nf: TField;
  SaveStatusFilter: set of TUpdateStatus;
begin
  // TODO: Не запоминает текущую позицию
  FDataSet.DisableControls;
  OldFiltered := FDataSet.Filtered;
  FDataSet.Filtered := false;
  try
    Delta.DisableControls;
    try
      Delta.First;
      while not Delta.Eof do
      begin
        if FDataSet.Locate(FKeyField, Delta[FKeyField], []) then
        begin
          // запись с таким ключом есть - надо сравнить данные
          for I := 0 to FDataSet.Fields.Count - 1 do
          begin
            f := FDataSet.Fields[i];
            if {(f.FieldKind <> fkInternalCalc) and }
              (f.FieldKind <> fkCalculated)
              and not (pfInKey in f.ProviderFlags) then //and (pfInUpdate in f.ProviderFlags) then
            begin
              nf := Delta.Fields[i];
              if f.Value <> nf.Value then
              begin
                if not (FDataSet.State in [dsInsert, dsEdit]) then
                  FDataSet.Edit;
                f.Assign(nf);
              end;
            end;
          end;
          FDataSet.CheckBrowseMode;
        end
        else
        begin
          // такой записи нет, надо добавить
          FDataSet.Append;
          CopyRecordFromDataSet(FDataSet, Delta);
          FDataSet.CheckBrowseMode;
        end;

        Delta.Next;
      end;
    finally
      Delta.EnableControls;
    end;

    // Теперь проверяем, были ли удалены какие-либо строки
    SaveStatusFilter := Delta.StatusFilter;
    Delta.StatusFilter := [usDeleted];
    while not Delta.Eof do
    begin
      if FDataSet.Locate(FKeyField, Delta[FKeyField], []) then
        FDataSet.Delete;
      Delta.Next;
    end;
    Delta.StatusFilter := SaveStatusFilter;

  finally
    FDataSet.Filtered := OldFiltered;
    FDataSet.EnableControls;
  end;
end;

procedure TEntity.CopyRecordFromDataSet(DestDataSet: TDataSet; Delta: TDataSet);
var
  I: integer;
  f, nf: TField;
begin
    for I := 0 to DestDataSet.Fields.Count - 1 do
    begin
      f := DestDataSet.Fields[i];
      if {(f.FieldKind <> fkInternalCalc) and }
        (f.FieldKind <> fkCalculated)
        and (f.FieldKind <> fkLookup)
        and not (pfInKey in f.ProviderFlags) then//and (pfInUpdate in f.ProviderFlags) then
      begin
        nf := Delta.FindField(f.FieldName);
        if nf <> nil then  // internalcalc поля не будет
        begin
          if not (DestDataSet.State in [dsInsert, dsEdit]) then
            DestDataSet.Edit;
          f.Assign(nf);
        end;
      end;
    end;
end;

procedure TEntity.ProviderUpdateError(Sender: TObject;
  DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind;
  var Response: TResolverResponse);
begin
  //FErrors.AddObject(E.Message, Exception.Create(E.Message));
  FErrors.Add(E.Message);
end;

function TEntity.IsEmpty: boolean;
begin
  Result := DataSet.IsEmpty;
end;

procedure TEntity.SetUsePager(_UsePager: boolean);
begin
  FUsePager := _UsePager;
  if FUsePager then CheckPager;
end;

function TEntity.RecordCount: integer;
begin
  Result := DataSet.RecordCount;
end;

function TEntity.TotalRecordCount: integer;
begin
  if (FQueryPager <> nil) then  // не проверяем FUsePager, т.к. он может быть временно отключен
    Result := FQueryPager.RowCount
  else
    Result := DataSet.RecordCount;
end;

// Загружает весь набор данных в режиме постраничной выборки
procedure TEntity.FetchAllRecords;
begin
  if FUsePager then
  begin
    FUsePager := false;
    try
      Reload;
      FLowPageNum := 1;
    finally
      FUsePager := true;
    end;
  end;
end;

function TEntity.Modified: boolean;
begin
  if (DataSet.State = dsInsert) or (DataSet.State = dsEdit) then
    Result := true
  else
  if DataSet is TClientDataSet then
    Result := ((DataSet as TClientDataSet).ChangeCount > 0)
  else if DataSet is TADOQuery then
    Result := ((DataSet as TADOQuery).UpdateStatus <> usUnmodified)
  else
    raise EAssertionFailed.Create('Неизвестный тип набора данных ' + DataSet.ClassName);
end;

procedure TEntity.SetSortOrder(_SortField: string; MakeActive: boolean);
begin
  FSortField := _SortField;
  if MakeActive then Reload;
end;

function TEntity.GetADODataSet: TADOQuery;
begin
  if DataSetProvider = nil then
    Result := nil
  else
    Result := DataSetProvider.DataSet as TADOQuery;
end;

procedure TEntity.Append;
begin
  DataSet.Append;
end;

procedure TEntity.Delete;
begin
  DataSet.Delete;
end;

procedure TEntity.DeleteAndApply;
var
  CurKey, NextKey: variant;
begin
  FDataSet.DisableControls;
  try
    CurKey := KeyValue;
    FDataSet.Next;
    if not FDataSet.Eof then
      NextKey := KeyValue
    else
    begin
      FDataSet.Prior;
      if not FDataSet.Bof then
        NextKey := KeyValue
      else
        NextKey := null;
    end;
    if Locate(CurKey) then
    begin
      Delete;
      try
        ApplyUpdates;
        if not VarIsNull(NextKey) then
          ReloadLocate(NextKey)
        else
        begin
          Reload;
          FDataSet.Last;
        end;
      except
        CancelUpdates;
        Locate(CurKey);
        raise;
      end;
    end;
  finally
    FDataSet.EnableControls;
  end;
end;

end.
