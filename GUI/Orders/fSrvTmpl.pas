unit fSrvTmpl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, JvAppStorage,
  PmProcess, NotifyEvent, CalcSettings, PmOrder;

type
  TfrSrvTemplate = class(TFrame)
  private
    FAppStorage: TjvCustomAppStorage;
    SettingsChangedHandlerID: TNotifyHandlerID;
    procedure SetAppStorage(_AppStorage: TJvCustomAppStorage);
    procedure OnSettingsChanged(Sender: TObject);
  protected
    FGridList: TList;
    FOrder: TOrder;
    procedure OnCreate; virtual;
    procedure CheckOpenProcess(Srv: TPolyProcess);
    procedure DoSettingsChanged; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure BeforeDelete; virtual;
    procedure SaveSettings;
    procedure LoadSettings;
    procedure SaveLayout; virtual;
    procedure LoadLayout; virtual;
    function GetFrameTotal(var ItemCount: integer): extended; virtual;
    procedure OpenProcesses; virtual;
    procedure AddProcessGrid(AProcessGrid: TProcessGrid); virtual;
    procedure AddProcess(AProcess: TPolyProcess); virtual;

    property Order: TOrder read FOrder write FOrder;
    property AppStorage: TjvCustomAppStorage read FAppStorage write SetAppStorage;
    property GridList: TList read FGridList;
  end;

implementation

uses CalcUtils, ServMod;

{$R *.DFM}

// В GridList обычно хранятся объекты типа TProcessGrid, что используется
// фреймами, унаследованными от этого фрейма. Однако может быть ситуация,
// например с фреймом цены для клиента, когда создается пустой фрейм класса
// TfrSrvTemplate. В нем регистрируется не TProcessGrid, а TPolyProcess,
// т.к. никаких таблиц здесь нет.
procedure TfrSrvTemplate.SaveSettings;

  procedure Process(FProcessGrid: TProcessGrid);
  begin
    if FProcessGrid <> nil then
      FProcessGrid.SaveGridColsWidth;
  end;

var
  i: integer;
begin
  SaveLayout;
  if FGridList.Count > 0 then
    for i := 0 to Pred(FGridList.Count) do
      if TObject(FGridList[i]).ClassName = 'TProcessGrid' then
        Process(TProcessGrid(FGridList.Items[i]));
end;

procedure TfrSrvTemplate.LoadSettings;

  procedure Process(FProcessGrid: TProcessGrid);
  begin
    if FProcessGrid <> nil then
      FProcessGrid.LoadGridColsWidth;
  end;

var
  i: integer;
begin
  DoSettingsChanged;
  LoadLayout;
  if FGridList.Count > 0 then
    for i := 0 to Pred(FGridList.Count) do
      if TObject(FGridList[i]).ClassName = 'TProcessGrid' then
        Process(TProcessGrid(FGridList.Items[i]));
end;

procedure TfrSrvTemplate.BeforeDelete;

 procedure Process(FProcessGrid: TProcessGrid);
  begin
    if FProcessGrid <> nil then
    begin
      FProcessGrid.ClearDBGrid;
      FProcessGrid.TotalPanel := nil;
      FProcessGrid.TotalWorkPanel := nil;
      FProcessGrid.TotalMatPanel := nil;
      FProcessGrid.Page := nil;
    end;
  end;

var
  i: integer;
begin
  if FGridList.Count > 0 then
    for i := 0 to Pred(FGridList.Count) do
      if TObject(FGridList[i]).ClassName = 'TProcessGrid' then
        Process(TProcessGrid(FGridList.Items[i]));
  FGridList.Clear;
end;

procedure TfrSrvTemplate.SaveLayout;
begin
end;

procedure TfrSrvTemplate.LoadLayout;
begin
end;

constructor TfrSrvTemplate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Name := GetComponentName(AOwner, Name);
  FGridList := TList.Create;
  OnCreate;
  SettingsChangedHandlerID := TSettingsManager.Instance.SettingsChanged.RegisterHandler(OnSettingsChanged);
end;

destructor TfrSrvTemplate.Destroy;
begin
  if Assigned(FGridList) then FreeAndNil(FGridList);
  TSettingsManager.Instance.SettingsChanged.UnregisterHandler(SettingsChangedHandlerID);
  inherited Destroy;
end;

procedure TfrSrvTemplate.SetAppStorage(_AppStorage: TJvCustomAppStorage);
begin
  FAppStorage := _AppStorage;
end;

procedure TfrSrvTemplate.OnCreate;
begin
end;

function TfrSrvTemplate.GetFrameTotal(var ItemCount: integer): extended;
begin
  {if (FGridList.Count = 1) and (TObject(FGridList[0]).ClassName = 'TPolyProcess') then
    ItemCount := TPolyProcess(FGridList[0]).DataSet.RecordCount}
  if (FGridList.Count = 1) then
  begin
    Result := TProcessGrid(FGridList[0]).TotalCost;
    ItemCount := TProcessGrid(FGridList[0]).Srv.DataSet.RecordCount;
  end
  else
  begin
    Result := 0;
    ItemCount := 0;
  end;
end;

procedure TfrSrvTemplate.OpenProcesses;
var i: integer;
begin
  if FGridList.Count > 0 then
    for i := 0 to Pred(FGridList.Count) do
      if TObject(FGridList[i]).ClassName = 'TProcessGrid' then
        CheckOpenProcess(TProcessGrid(FGridList.Items[i]).Srv)
      else if TObject(FGridList[i]).ClassName = 'TPolyProcess' then
        CheckOpenProcess(TPolyProcess(FGridList[i]));
end;

procedure TfrSrvTemplate.CheckOpenProcess(Srv: TPolyProcess);
begin
  if not Assigned(Srv.DataSet) or not Srv.DataSet.Active then
    Order.Processes.OpenProcess(Srv);
end;

procedure TfrSrvTemplate.AddProcessGrid(AProcessGrid: TProcessGrid);
begin
  FGridList.Add(AProcessGrid);
end;

procedure TfrSrvTemplate.AddProcess(AProcess: TPolyProcess);
begin
  FGridList.Add(AProcess);
end;

procedure TfrSrvTemplate.OnSettingsChanged(Sender: TObject);
begin
  DoSettingsChanged;
end;

procedure TfrSrvTemplate.DoSettingsChanged;
begin
end;

end.
