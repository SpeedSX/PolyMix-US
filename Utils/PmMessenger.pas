unit PmMessenger;

interface

uses Classes, Windows, DB, ADODB, SysUtils, JvThread,

  PmDatabase;

type
  //  ласс дл€ получени€ сообщений с сервера
  TMessenger = class(TObject)
  private
    // ¬рем€ последней проверки (врем€ сервера)
    FLastCheckTime: TDateTime;
    // Ќитка дл€ автоматической периодической проверки
    FWorkerThread: TjvThread;
    // интервал автоматической периодической проверки
    FInterval: integer;
    //FChanged: boolean;
    FStopped: boolean;
    FMessages: TStringList;
    FSec: TRTLCriticalSection;
    procedure DoDetect(Sender: TObject; params: Pointer);
  protected
    // ¬озвращает список новых сообщений и текущую дату сервера или 0 если ошибка
    function GetNewMessages(LastCheckTime: TDateTime; var CurT: TDateTime): TStringList; virtual; abstract;
    // «апускает разовую проверку сообщений
    procedure DoCheckNow;
  public
    constructor Create;
    destructor Destroy; override;
    // «апускает режим автоматической периодической проверки сообщений
    procedure Start; virtual;
    // ќстанавливает режим автоматической периодической проверки сообщений
    procedure Stop; virtual;
    procedure CheckNow;
    function GetMessages: TStringList;

    // »нтервал автоматической периодической проверки
    property Interval: integer read FInterval write FInterval;

    //property Messages: TStringList read GetMessages write FMessages;
    //property Changed: boolean read FChanged;
  end;

  TADOMessenger = class(TMessenger)
  private
    //FCon: TADOConnection;
    FDatabase: TDatabase;
  protected
    // ¬озвращает список новых сообщений и текущую дату сервера или 0 если ошибка
    function GetNewMessages(LastCheckTime: TDateTime; var CurT: TDateTime): TStringList; override;
  public
    procedure Start; override;
    procedure Stop; override;
  end;

var
  Messenger: TMessenger;
  
implementation

uses PmAccessManager, TLoggerUnit, RDBUtils;

{$REGION 'TMessenger' }

constructor TMessenger.Create;
begin
  inherited Create;
  FInterval := 60000;
  InitializeCriticalSection(FSec);
end;

destructor TMessenger.Destroy;
begin
  DeleteCriticalSection(FSec);
  inherited;
end;

procedure TMessenger.Start;
begin
  FStopped := false;
  FWorkerThread := TJvThread.Create(nil);
  FWorkerThread.Exclusive := True;
  FWorkerThread.RunOnCreate := true;
  FWorkerThread.FreeOnTerminate := False;
  FWorkerThread.OnExecute := DoDetect;
  FWorkerThread.Execute(Self);
end;

procedure TMessenger.Stop;
begin
  FStopped := true;
end;

procedure TMessenger.DoDetect(Sender: TObject; params: Pointer);
var
  Msg: TMessenger;
begin
  Msg := TMessenger(params);
  while not Msg.FStopped do
  begin
    //Msg.CheckNow;
    Msg.CheckNow;
    Sleep(Msg.FInterval);
  end;
end;

procedure TMessenger.CheckNow;
begin
  EnterCriticalSection(FSec);
  DoCheckNow;
  LeaveCriticalSection(FSec);
end;

// «апускает разовую проверку сообщений
procedure TMessenger.DoCheckNow;
var
  CurT: TDateTime;
  Msgs: TStringList;
  I: Integer;
begin
  try
    Msgs := GetNewMessages(FLastCheckTime, CurT);
    if CurT > 0 then
      FLastCheckTime := CurT;
    if Msgs <> nil then
    begin
      TLogger.getInstance.Debug('Thread Check ' + IntToStr(Msgs.Count));
      if FMessages = nil then
        FMessages := Msgs
      else
      begin
        for I := 0 to Msgs.Count - 1 do
          FMessages.Add(Msgs[I]);
        Msgs.Free;
      end;
    end;
  except
    on E: Exception do
    begin
      // игнорируем ошибки
      TLogger.getInstance.Warn(E.Message);
    end;
  end;
end;

function TMessenger.GetMessages: TStringList;
begin
  if TryEnterCriticalSection(FSec) then
  begin
    Result := FMessages;
    FMessages := nil;
    LeaveCriticalSection(FSec);
  end
  else
    Result := nil;
end;

{$ENDREGION}

{$REGION 'TADOMessenger'}

procedure TADOMessenger.Start;
begin
  //if FCon = nil then
  //  FCon := Database.CloneConnection(nil, AccessManager.CurUserPass);
  //FCon.Connected := true;
  if FDatabase = nil then
  begin
    FDatabase := TDatabase.Create(Database, AccessManager.CurUserPass);
    FDatabase.SuppressExceptions := true;  // не восстанавливать соединение
  end;
  inherited;
end;

procedure TADOMessenger.Stop;
begin
  inherited Stop;
  //FreeAndNil(FCon);
  FDatabase.Connection.Free; // сама не освобождает!
  FreeAndNil(FDatabase);
  //FreeAndNil(FQuery);
end;

function TADOMessenger.GetNewMessages(LastCheckTime: TDateTime; var CurT: TDateTime): TStringList;
var
  Msgs: TStringList;
  nm: string;
  s: string;
  FQuery: TDataSet;
begin
  {if FQuery = nil then
  begin
    FQuery := TADOQuery.Create(nil);
  end;
  if FCon <> nil then
    FQuery.Connection := FCon
  else
    FQuery.Connection := Database.Connection;

  FQuery.SQL.Clear;
  FQuery.SQL.Add('declare @dt datetime');
  FQuery.SQL.Add('set @dt = ' + FormatSQLDateTime(LastCheckTime));
  FQuery.SQL.Add('exec up_GetNewMessages @dt');
  FQuery.Open;}
  
  if not FDatabase.Connected then
    FDatabase.Connection.Connected := true;

  s := 'declare @dt datetime' + #13#10
     + 'set @dt = ' + FormatSQLDateTime(LastCheckTime) + #13#10
     + 'exec up_GetNewMessages @dt';
  FQuery := FDatabase.ExecuteQuery(s);
  try
    if FQuery.RecordCount > 0 then
    begin
      CurT := FQuery.Fields[0].Value;
      Msgs := TStringList.Create;
      while not FQuery.Eof do
      begin
        nm := NvlString(FQuery.Fields[1].Value);
        if nm <> '' then
          Msgs.Add(nm);
        FQuery.Next;
      end;
      if Msgs.Count = 0 then
        FreeAndNil(Msgs);
      Result := Msgs;
    end
    else
    begin
      Result := nil; // что-то пошло не так
      CurT := 0;
    end;
    //FQuery.Close;
  finally
    FQuery.Free;
  end;
end;

{$ENDREGION}

initialization

  Messenger := TADOMessenger.Create;

finalization

  FreeAndNil(Messenger);
end.
