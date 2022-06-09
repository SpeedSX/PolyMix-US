unit PmDataChangeDetect;

interface

uses Classes, DB, ADODB, SysUtils, JvThread;

type
  // ����� ��� ����������� ��������� � ������ �� �������
  TDataChangeDetect = class(TObject)
  private
    // ����� ��������� �������� ��������� (����� �������)
    FLastCheckTime: TDateTime;
    // ����� ��� �������������� ������������� ��������
    FWorkerThread: TjvThread;
    // �������� �������������� ������������� ��������
    FInterval: integer;
    FChanged: boolean;
    FStopped: boolean;
    procedure DoDetect(Sender: TObject; params: Pointer);
  protected
    FObjectTypeId: string;
    // ���������� ���� ���������� ��������� ������� � ������� ���� �������
    // ��� 0 ���� ������
    function GetLastModification(var CurT: TDateTime): TDateTime; virtual; abstract;
  public
    constructor Create(_ObjectTypeId: string);
    // ��������� ����� �������������� ������������� �������� ���������
    procedure Start; virtual;
    // ������������� ����� �������������� ������������� �������� ���������
    procedure Stop; virtual;
    // ��������� ������� �������� ���������
    procedure CheckNow;
    // ���������� ������� ��������� �������
    procedure Reset;

    // �������� �������������� ������������� ��������
    property Interval: integer read FInterval write FInterval;
    // ������ ��� �������
    property Changed: boolean read FChanged;
  end;

  TADODataChangeDetect = class(TDataChangeDetect)
  protected
    FCon: TADOConnection;
    FQuery: TADOQuery;
    function GetLastModification(var CurT: TDateTime): TDateTime; override;
  public
    constructor Create(_ObjectTypeId: string);
    procedure Start; override;
    procedure Stop; override;
  end;

implementation

uses PmDatabase, PmAccessManager, TLoggerUnit, RDBUtils;

{$REGION 'TDataChangeDetect' }

constructor TDataChangeDetect.Create(_ObjectTypeId: string);
begin
  inherited Create;
  FObjectTypeId := _ObjectTypeId;
  FInterval := 10000;
end;

procedure TDataChangeDetect.Start;
begin
  FStopped := false;
  FWorkerThread := TJvThread.Create(nil);
  FWorkerThread.Exclusive := True;
  FWorkerThread.RunOnCreate := true;
  FWorkerThread.FreeOnTerminate := False;
  FWorkerThread.OnExecute := DoDetect;
  FWorkerThread.Execute(Self);
end;

procedure TDataChangeDetect.Stop;
begin
  FStopped := true;
end;

procedure TDataChangeDetect.DoDetect(Sender: TObject; params: Pointer);
var
  Detector: TDataChangeDetect;
begin
  Detector := TDataChangeDetect(params);
  while not Detector.FStopped do
  begin
    if not Detector.Changed then
      Detector.CheckNow;
    Sleep(Detector.FInterval);
  end;
end;

// ��������� ������� �������� ���������
procedure TDataChangeDetect.CheckNow;
var
  dt, CurT: TDateTime;
begin
  try
    dt := GetLastModification(CurT);
    if dt > FLastCheckTime then
      FChanged := true;
    if CurT > 0 then
      FLastCheckTime := CurT;
  except
    on E: Exception do
    begin
      // ���������� ������
      TLogger.getInstance.Warn(E.Message);
      FChanged := true;  // �������� ��� ����������
    end;
  end;
end;

procedure TDataChangeDetect.Reset;
begin
  FChanged := false;
end;

{$ENDREGION}

{$REGION 'TADODataChangeDetect' }

constructor TADODataChangeDetect.Create(_ObjectTypeId: string);
begin
  inherited Create(_ObjectTypeId);
end;

procedure TADODataChangeDetect.Start;
begin
  if FCon = nil then
    FCon := Database.CloneConnection(nil, AccessManager.CurUserPass);
  FCon.Connected := true;
  inherited Start;
end;

procedure TADODataChangeDetect.Stop;
begin
  inherited Stop;
  FreeAndNil(FCon);
  FreeAndNil(FQuery);
end;

function TADODataChangeDetect.GetLastModification(var CurT: TDateTime): TDateTime;
begin
  if FQuery = nil then
  begin
    FQuery := TADOQuery.Create(nil);
    FQuery.SQL.Add('exec up_GetLastModifyDate ''' + FObjectTypeId + '''');
  end;
  if FCon <> nil then
    FQuery.Connection := FCon
  else
    FQuery.Connection := Database.Connection;

  FQuery.Open;
  if FQuery.RecordCount > 0 then
  begin
    Result := NvlFloat(FQuery.Fields[0].Value);
    CurT := FQuery.Fields[1].Value;
  end
  else
  begin
    Result := 0; // ���-�� ����� �� ���
    CurT := 0;
  end;
  FQuery.Close;
end;

{$ENDREGION}

end.
