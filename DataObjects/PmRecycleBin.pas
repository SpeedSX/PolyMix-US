unit PmRecycleBin;

interface

uses SysUtils, Variants, DB, Graphics, ADODB,
  JvThread,
  ExHandler, CalcUtils, PmEntity, NotifyEvent, CalcSettings, ExtCtrls;

type
  TBaseRecycleBin = class(TEntity)
  private
    FPurgeThread: TJvThread;
    FConCopy: TADOConnection;
    FPurgeError: boolean;
    FPurgeErrorMsg: string;
    FPurgeKeyValues: TIntArray;
    FPurgeIndex: integer;
    //function CheckPurgeThread: Boolean;
    procedure LaunchPurgeThread;
    //procedure PurgeCompleteCheck(Sender: TObject);
    procedure PurgeThreadExecute(Sender: TObject; params: Pointer);
    procedure PurgeThreadFinished(Sender: TObject);
  protected
    // Запускается асинхронно для очистки корзины
    //FPurgeCmd: TADOCommand;
    //FPurgeCheckTimer: TTimer;
    FObjectType: integer;
    // Процедура, которая удаляет объект окончательно
    FPurgeProcedureName: string;
    FRestoreProcedureName: string;
    FDataSource: TDataSource;
    function GetPurgeText(KeyFieldValue: Variant): string; virtual;
    procedure DoBeforeOpen; override;
    function GetSQL: string; virtual; abstract;
    function GetEntityName: string; virtual; abstract;
    procedure PurgeObject(ObjectKey: variant); virtual;
    procedure RestoreObject(ObjectKey: variant); virtual;
  public
    procedure PurgeCurrentObject;
    procedure PurgeObjects(KeyValues: TIntArray); virtual;
    procedure PurgeAll;
    procedure RestoreObjects(KeyValues: TIntArray); virtual;

    property DataSource: TDataSource read FDataSource;

    property EntityName: string read GetEntityName;
    property ObjectType: integer read FObjectType write FObjectType;
  end;

  TOrderRecycleBin = class(TBaseRecycleBin)
  private
    FCfgChangedID: TNotifyHandlerID;
    // Здесь сохраняются ключи видов заказов, доступных для просмотра
    AllDraftOrderKindValues: TIntArray;
    AllWorkOrderKindValues: TIntArray;
    FRestoredIDNumbers: TIntArray;
    FOldIDNumbers: TIntArray;
    procedure ProcessCfgChanged_Handler(Sender: TObject);
    function GetKindID: Integer;
    function GetOrderID: string;
    function GetOrderNumber: Integer;
    function GetOrderFilterExpr: string;
    function GetIsDraft: Boolean;
    function GetRowColor: TColor;
    procedure CustGetText(Sender: TField; var Text: String; DisplayText: Boolean);
  protected
    procedure DoOnCalcFields; override;
    procedure DoAfterOpen; override;
    function GetSQL: string; override;
    // Здесь еще указывается проверка блокировки
    function GetPurgeText(KeyFieldValue: Variant): string; override;
    procedure RestoreObject(ObjectKey: variant); override;
    function GetEntityName: string; override;
  public
    constructor Create(_DataSet: TDataSet);
    destructor Destroy; override;
    procedure RestoreObjects(KeyValues: TIntArray); override;

    property IsDraft: Boolean read GetIsDraft;
    property KindID: Integer read GetKindID;
    property OrderID: string read GetOrderID;
    property OrderNumber: Integer read GetOrderNumber;
    property RowColor: TColor read GetRowColor;

    // номера восстановленных заказов
    property RestoredIDNumbers: TIntArray read FRestoredIDNumbers;
    property OldIDNumbers: TIntArray read FOldIDNumbers;
  end;

  TContragentRecycleBin = class(TBaseRecycleBin)
  private
    FCfgChangedID: TNotifyHandlerID;
    procedure ProcessCfgChanged_Handler(Sender: TObject);
  protected
    function GetSQL: string; override;
    function GetEntityName: string; override;
    procedure DoOnCalcFields; override;
  public
    constructor Create(_DataSet: TDataSet); 
    destructor Destroy; override;
  end;

const
  BinObjectType_Orders = 0;
  BinObjectType_Contragents = 1;

implementation

uses Dialogs,

  RDialogs, MainData, RDBUtils, PmAccessManager, JvStrings, PmContragent,
  PmDatabase, PmConfigManager, PmOrder;

//const RangeMacro = '@@@RANGE';

procedure TBaseRecycleBin.DoBeforeOpen;
begin
  inherited DoBeforeOpen;
  //ADODataSet.SQL[FRangeLine] := GetOrderFilterExpr;
  ADODataSet.SQL.Text := GetSQL;
end;

procedure TBaseRecycleBin.PurgeCurrentObject;
begin
  PurgeObject(KeyValue);
  Reload;
end;

// Здесь еще указывается проверка блокировки
procedure TBaseRecycleBin.PurgeObject(ObjectKey: variant);
var
  Cmd: TADOCommand;
begin
  Cmd := TADOCommand.Create(nil);
  try
    Cmd.Connection := Database.Connection;
    Cmd.CommandText := GetPurgeText(ObjectKey);
    if not Database.InTransaction then Database.BeginTrans;
    try
      Cmd.Execute;
      Database.CommitTrans;
    except
      on E: Exception do
      begin
        Database.RollbackTrans;
        ExceptionHandler.Raise_(E);
      end;
    end;
  finally
    Cmd.Free;
  end;
end;

{procedure TBaseRecycleBin.PurgeObjects(OrderIds: TIntArray);
var
  I: Integer;
begin
  for I := Low(OrderIds) to High(OrderIds) do
    PurgeObject(OrderIds[I]);
  Reload;
end;}

// Возвращает true если нитка очистки корзины еще выполняется
{function TBaseRecycleBin.CheckPurgeThread: Boolean;
begin
  Result := FPurgeThread <> nil;
end;}

{procedure TBaseRecycleBin.PurgeThreadExecute(Sender: TObject; params: Pointer);
var
  FPurgeCmd: TADOCommand;
begin
    FPurgeCmd := TADOCommand.Create(nil);
    FPurgeCmd.Connection := TADOConnection(params);
    //FPurgeCmd.ExecuteOptions := [eoAsyncExecute];
    FPurgeCmd.CommandTimeout := 10000;
    FPurgeCmd.CommandText := 'up_PurgeAll 0';
  try
    FPurgeCmd.Execute;
  except
    FPurgeCmd.Free;
    Exit;
  end;
end;}

procedure TBaseRecycleBin.PurgeThreadExecute(Sender: TObject; params: Pointer);
var
  Cmd: TADOCommand;
  Con: TADOConnection;
begin
  Cmd := TADOCommand.Create(nil);
  try
    con := TBaseRecycleBin(params).FConCopy;
    Cmd.Connection := con;
    Cmd.CommandText := GetPurgeText(TBaseRecycleBin(params).FPurgeKeyValues[TBaseRecycleBin(params).FPurgeIndex]);
    if not Con.InTransaction then Con.BeginTrans;
    TBaseRecycleBin(params).FPurgeError := false;
    try
      Cmd.Execute;
      if Con.Errors.Count = 0 then
        Con.CommitTrans
      else
        raise Exception.Create(Con.Errors[0].Description);
    except
      on E: Exception do
      begin
        Con.RollbackTrans;
        TBaseRecycleBin(params).FPurgeError := true;
        TBaseRecycleBin(params).FPurgeErrorMsg := E.Message;
      end;
    end;
  finally
    Cmd.Free;
  end;
end;

procedure TBaseRecycleBin.PurgeAll;
var
  KeyValues: TIntArray;
  I: integer;
begin
  if DataSet.RecordCount > 0 then
  begin
    // собираем ключи всех записей
    SetLength(KeyValues, DataSet.RecordCount);
    DataSet.DisableControls;
    try
      DataSet.First;
      I := 0;
      while not DataSet.Eof do
      begin
        KeyValues[I] := KeyValue;
        Inc(I);
        DataSet.Next;
      end;    // while
    finally
      DataSet.EnableControls;
    end;
    PurgeObjects(KeyValues);  // запускаем удаление
  end;
end;

procedure TBaseRecycleBin.PurgeObjects(KeyValues: TIntArray);
begin
//  if CheckPurgeThread then
//    raise Exception.Create('Очистка корзины уже выполняется')
//  else
  begin
    FPurgeKeyValues := KeyValues;
    if FConCopy = nil then
      FConCopy := Database.CloneConnection(nil, AccessManager.CurUserPass);
    try
      FConCopy.Connected := true;
      TDatabase.SetConnectionOptions(FConCopy);
      FPurgeIndex := 0;
    except
      FreeAndNil(FConCopy);
      raise;
    end;

    FPurgeIndex := 0;
    LaunchPurgeThread;

  end;
  // Транзакцию не запускаем! Слишком большая
end;

// Запускается синхронно!
procedure TBaseRecycleBin.RestoreObjects(KeyValues: TIntArray);
var
  I: Integer;
begin
  for I := Low(KeyValues) to High(KeyValues) do
    RestoreObject(KeyValues[I]);
  Reload;
end;

procedure TBaseRecycleBin.RestoreObject(ObjectKey: variant);
var
  Cmd: TADOCommand;
begin
  Cmd := TADOCommand.Create(nil);
  try
    Cmd.Connection := Database.Connection;
    Cmd.CommandText := FRestoreProcedureName + ' ' + IntToStr(ObjectKey);
    if not Database.InTransaction then Database.BeginTrans;
    try
      Cmd.Execute;
      Database.CommitTrans;
    except
      on E: Exception do
      begin
        Database.RollbackTrans;
        ExceptionHandler.Raise_(E);
      end;
    end;
  finally
    Cmd.Free;
  end;
end;

(*procedure TBaseRecycleBin.PurgeCompleteCheck(Sender: TObject);
begin
  if (FPurgeThread <> nil) and FPurgeThread.Terminated then
  begin
    FPurgeThread.Terminate;
    FreeAndNil(FPurgeThread);
    FreeAndNil(FPurgeCheckTimer);
    Reload;
  end;
  {if (FPurgeCmd <> nil) and not (stExecuting in FPurgeCmd.States) then
  begin
    FreeAndNil(FPurgeCmd);
    FreeAndNil(FPurgeCheckTimer);
    Reload;
  end;}
end;*)

// Выполняется в Main Thread
procedure TBaseRecycleBin.PurgeThreadFinished(Sender: TObject);
begin
    // Если ошибка или закончился список элементов
    if FPurgeError or (FPurgeIndex = Length(FPurgeKeyValues) - 1) then
    begin
      FreeAndNil(FConCopy);
      Reload;
      if FPurgeError then
        RusMessageDlg(FPurgeErrorMsg, mtError, [mbOk], 0);
    end
    else // Иначе продолжаем - запускаем новую нитку
    begin
      Inc(FPurgeIndex);
      LaunchPurgeThread;
    end;
end;

function TBaseRecycleBin.GetPurgeText(KeyFieldValue: Variant): string;
begin
  Result := FPurgeProcedureName + ' ' + VarToStr(KeyFieldValue);
end;

procedure TBaseRecycleBin.LaunchPurgeThread;
begin
    FPurgeThread := TJvThread.Create(nil);
    //FPurgeThread.Exclusive := True;
    //FPurgeThread.RunOnCreate := true;
    //FPurgeThread.FreeOnTerminate := False;
    FPurgeThread.OnExecute := PurgeThreadExecute;
    FPurgeThread.OnFinish := PurgeThreadFinished;
    FPurgeThread.Execute(Self);
  {PurgeThreadExecute(Self, Self);
  PurgeThreadFinished(Self);}
end;

{ --------- TOrderRecycleBin ----------- }

constructor TOrderRecycleBin.Create(_DataSet: TDataSet);
begin
  inherited Create;
  FKeyField := TOrder.F_OrderKey;
  FInternalName := 'OrderRecycleBin';
  SetDataSet(_DataSet);

  FCfgChangedID := TConfigManager.Instance.ProcessCfgChanged.RegisterHandler(ProcessCfgChanged_Handler);
  ProcessCfgChanged_Handler(nil);

  DefaultLastRecord := true;
  FSortField := TOrder.F_OrderNumber;
  RefreshAfterApply := true;
  //SetDataSet(_DataSet);
  FDataSource := TDataSource.Create(nil);
  FDataSource.DataSet := DataSet;
  DataSetProvider := dm.pvOrderRecycleBin;
  ObjectType := BinObjectType_Orders;
  FPurgeProcedureName := 'up_PurgeOrder';
  FRestoreProcedureName := 'up_RestoreOrder';
end;

procedure TOrderRecycleBin.ProcessCfgChanged_Handler(Sender: TObject);
begin
  AllWorkOrderKindValues := AccessManager.GetPermittedKinds(AccessManager.CurUser.ID, 'WorkVisible');
  AllDraftOrderKindValues := AccessManager.GetPermittedKinds(AccessManager.CurUser.ID, 'DraftVisible');
end;

function TOrderRecycleBin.GetSQL: string;
begin
    Result := 'select wo.N, wo.Comment, Customer, c.Name as CustomerName, wo.CreationDate, wo.ID_Number, wo.KindID,'
      + ' CAST(REPLICATE(''0'', 5 - DATALENGTH(CAST(ID_Number as varchar(5)))) + CAST(ID_Number as varchar(5)) as varchar(5)) as ID,'
      + ' (select top 1 EventUser from OrderHistory where OrderID = wo.N order by EventDate desc) as UserName,'
      + ' (select top 1 EventDate from OrderHistory where OrderID = wo.N order by EventDate desc) as DeleteDate,'
      + ' wo.IsDraft, wo.RowColor'
      + ' from WorkOrder wo left join Customer c on c.N = wo.Customer'
      + ' where wo.IsDeleted = 1 ' + GetOrderFilterExpr
      + ' order by DeleteDate';
end;

destructor TOrderRecycleBin.Destroy;
begin
  TConfigManager.Instance.ProcessCfgChanged.UnregisterHandler(FCfgChangedID);
  inherited;
end;

procedure TOrderRecycleBin.DoAfterOpen;
begin
  inherited DoAfterOpen;
  DataSet.FieldByName('CustomerName').OnGetText := CustGetText;
end;

function TOrderRecycleBin.GetOrderFilterExpr: string;

  function FilterByOrderKind(const OrderKindValues: TIntArray): string;
  var
    ts: string;
    i: integer;
  begin
    if OrderKindValues <> nil then
    begin
      ts := '';
      for i := 0 to High(OrderKindValues) do
      begin
        ts := ts + IntToStr(OrderKindValues[i]);
        if i <> High(OrderKindValues) then ts := ts + ',';
      end;
      Result := 'wo.KindID in (' + ts + ')';
    end
    else
      Result := '0=1';
  end;

begin
  Result := 'and (wo.IsDraft=1 and ' + FilterByOrderKind(AllDraftOrderKindValues)
    + ' or wo.IsDraft=0 and ' + FilterByOrderKind(AllWorkOrderKindValues) + ')';
end;

procedure TOrderRecycleBin.CustGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if not DataSet.IsEmpty and DataSet.Active then
    if DataSet['CustomerName'] = 'NONAME' then
      Text := ''
    else
      Text := NvlString(DataSet['CustomerName']);
end;

function TOrderRecycleBin.GetEntityName: string;
begin
  if IsDraft then
    Result := 'Расчет'
  else
    Result := 'Заказ';
  Result := Result + ' ' + OrderID;
end;

function TOrderRecycleBin.GetIsDraft: Boolean;
begin
  Result := DataSet['IsDraft'];
end;

function TOrderRecycleBin.GetOrderID: string;
begin
  Result := DataSet['ID'];
end;

function TOrderRecycleBin.GetRowColor: TColor;
begin
  if not VarIsNull(DataSet['RowColor']) then
    Result := DataSet['RowColor']
  else
    Result := clWhite;
end;

procedure TOrderRecycleBin.DoOnCalcFields;
begin
  inherited DoOnCalcFields;
  DataSet['EntityName'] := EntityName;
end;

function TOrderRecycleBin.GetKindID: Integer;
begin
  Result := DataSet['KindID'];
end;

function TOrderRecycleBin.GetOrderNumber: Integer;
begin
  Result := DataSet[TOrder.F_OrderNumber];
end;

procedure TOrderRecycleBin.RestoreObjects(KeyValues: TIntArray);
begin
  SetLength(FRestoredIDNumbers, 0);
  SetLength(FOldIDNumbers, 0);

  inherited RestoreObjects(KeyValues);
end;

procedure TOrderRecycleBin.RestoreObject(ObjectKey: variant);
var
  OldIdNumber, RestoredIdNumber: variant;
  QueryText: string;
begin
  QueryText := 'select ID_Number from WorkOrder where N = ' + IntToStr(ObjectKey);
  // определяем номер заказа
  OldIDNumber := Database.ExecuteScalar(QueryText);

  if not VarIsNull(OldIdNumber) then
  begin
    // Восстанавливаем
    inherited RestoreObject(ObjectKey);

    // определяем номер восстановленного заказа
    RestoredIDNumber := Database.ExecuteScalar(QueryText);

    if not VarIsNull(RestoredIdNumber) then
    begin
      // увеличиваем размеры списков номеров
      SetLength(FRestoredIdNumbers, Length(FRestoredIdNumbers) + 1);
      SetLength(FOldIdNumbers, Length(FOldIdNumbers) + 1);
      FRestoredIDNumbers[Length(FRestoredIdNumbers) - 1] := RestoredIdNumber;
      FOldIDNumbers[Length(FOldIdNumbers) - 1] := OldIdNumber;
    end;
  end;
end;

function TOrderRecycleBin.GetPurgeText(KeyFieldValue: variant): string;
begin
  Result := inherited GetPurgeText(KeyFieldValue) + ', 1';
end;

{ --------- TContragentRecycleBin ----------- }

constructor TContragentRecycleBin.Create(_DataSet: TDataSet);
begin
  inherited Create;
  FKeyField := TContragents.F_CustKey;
  FInternalName := 'ContragentRecycleBin';
  SetDataSet(_DataSet);

  FCfgChangedID := TConfigManager.Instance.ProcessCfgChanged.RegisterHandler(ProcessCfgChanged_Handler);
  ProcessCfgChanged_Handler(nil);

  DefaultLastRecord := true;
  FSortField := TOrder.F_OrderNumber;
  RefreshAfterApply := true;
  //SetDataSet(_DataSet);
  FDataSource := TDataSource.Create(nil);
  FDataSource.DataSet := DataSet;
  DataSetProvider := dm.pvContragentRecycleBin;
  ObjectType := BinObjectType_Contragents;
  FPurgeProcedureName := 'up_PurgeContragent';
  FRestoreProcedureName := 'up_RestoreContragent';
end;

function TContragentRecycleBin.GetSQL: string;
begin
    Result := 'select cc.N, cc.Name, cc.CreationDate, cc.ContragentType,'
      + ' (select top 1 EventUser from ContragentHistory where ContragentID = cc.N order by EventDate desc) as UserName,'
      + ' (select top 1 EventDate from ContragentHistory where ContragentID = cc.N order by EventDate desc) as DeleteDate,'
      + ' cc.IsWork'
      + ' from Customer cc '
      + ' where cc.IsDeleted = 1 '
      + ' order by DeleteDate';
end;

function TContragentRecycleBin.GetEntityName: string;
begin
  Result := DataSet['Name'];
end;

destructor TContragentRecycleBin.Destroy;
begin
  TConfigManager.Instance.ProcessCfgChanged.UnregisterHandler(FCfgChangedID);
  inherited;
end;

procedure TContragentRecycleBin.ProcessCfgChanged_Handler(Sender: TObject);
begin
//   sdm.
end;

procedure TContragentRecycleBin.DoOnCalcFields;
begin
  if DataSet['ContragentType'] = caCustomer then
    DataSet['ContragentTypeName'] := Customers.NameSingular
  else if DataSet['ContragentType'] = caContractor then
    DataSet['ContragentTypeName'] := Contractors.NameSingular
  else if DataSet['ContragentType'] = caSupplier then
    DataSet['ContragentTypeName'] := Suppliers.NameSingular;
end;

end.
