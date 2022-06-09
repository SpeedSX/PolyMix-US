unit fBaseRecycleBin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, Grids, DBGridEh, MyDBGridEh, StdCtrls, Buttons,
  JvAppStorage, JvFormPlacement, PmRecycleBin, NotifyEvent, Menus, GridsEh,

  fBaseFrame, PmEntity, DBGridEhGrouping;

type
  TBaseRecycleBinFrame = class(TBaseFrame)
    dgBin: TMyDBGridEh;
    Panel1: TPanel;
    Panel2: TPanel;
    btPurge: TBitBtn;
    btRestore: TBitBtn;
    btPurgeAll: TBitBtn;
    pmRecycleBin: TPopupMenu;
    miRestore: TMenuItem;
    miPurge: TMenuItem;
    miPurgeAll: TMenuItem;
    miRefresh: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Label1: TLabel;
    procedure btPurgeClick(Sender: TObject);
    procedure btPurgeAllClick(Sender: TObject);
    procedure btRestoreClick(Sender: TObject);
    procedure miRefreshClick(Sender: TObject);
  private
    FOnPurgeSelected: TNotifyEvent;
    FOnPurgeAll: TNotifyEvent;
    FOnRestoreSelected: TNotifyEvent;
    FOnRefresh: TNotifyEvent;
    AfterScrollID: TNotifyHandlerID;
    FOpenID: TNotifyHandlerID;
    function GetObjectType: Integer;
    function GetSelectedRows: TBookmarkListEh;
  protected
    //FRecycleBin: TBaseRecycleBin;
    procedure SetupGrid; virtual;
  public
    constructor Create(Owner: TComponent; _RecycleBin: TEntity{; _Name: string}); override;
    destructor Destroy; override;
    //procedure LoadSettings; override;
    //procedure SaveSettings; override;
    procedure UpdateButtons(Sender: TObject); virtual;
    procedure ClearSelectedRows;

    function RecycleBin: TBaseRecycleBin;
    property ObjectType: Integer read GetObjectType;
    property SelectedRows: TBookmarkListEh read GetSelectedRows;

    property OnRestoreSelected: TNotifyEvent read FOnRestoreSelected write FOnRestoreSelected;
    property OnPurgeSelected: TNotifyEvent read FOnPurgeSelected write FOnPurgeSelected;
    property OnPurgeAll: TNotifyEvent read FOnPurgeAll write FOnPurgeAll;
    property OnRefresh: TNotifyEvent read FOnRefresh write FOnRefresh;
  end;

implementation

{$R *.dfm}

uses CalcSettings, RDialogs, CalcUtils;

constructor TBaseRecycleBinFrame.Create(Owner: TComponent; _RecycleBin: TEntity{;
  _Name: string});
begin
  inherited Create(Owner, _RecycleBin{_Name});
  //FRecycleBin := _RecycleBin;
  dgBin.DataSource := RecycleBin.DataSource;
  AfterScrollID := Entity.AfterScrollNotifier.RegisterHandler(UpdateButtons);
  FOpenID := Entity.OpenNotifier.RegisterHandler(UpdateButtons);
  UpdateButtons(nil);
  SetupGrid;
end;

destructor TBaseRecycleBinFrame.Destroy;
begin
  Entity.AfterScrollNotifier.UnRegisterHandler(AfterScrollID);
  Entity.OpenNotifier.UnRegisterHandler(FOpenID);
  inherited Destroy;
end;

procedure TBaseRecycleBinFrame.btPurgeClick(Sender: TObject);
begin
  FOnPurgeSelected(Self);
end;

procedure TBaseRecycleBinFrame.btPurgeAllClick(Sender: TObject);
begin
  FOnPurgeAll(Self);
end;

procedure TBaseRecycleBinFrame.btRestoreClick(Sender: TObject);
begin
  FOnRestoreSelected(Self);
end;

procedure TBaseRecycleBinFrame.UpdateButtons(Sender: TObject);
var
  e: boolean;
begin
  e := Entity.DataSet.IsEmpty;
  btPurge.Enabled := not e;
  btPurgeAll.Enabled := btPurge.Enabled;
  btRestore.Enabled := btPurge.Enabled;
end;

function TBaseRecycleBinFrame.GetObjectType: Integer;
begin
  Result := RecycleBin.ObjectType;
end;

procedure TBaseRecycleBinFrame.miRefreshClick(Sender: TObject);
begin
  FOnRefresh(Self);
end;

procedure TBaseRecycleBinFrame.SetupGrid;
begin
end;

function TBaseRecycleBinFrame.GetSelectedRows: TBookmarkListEh;
begin
  Result := dgBin.SelectedRows;
end;

procedure TBaseRecycleBinFrame.ClearSelectedRows;
begin
  dgBin.SelectedRows.Clear;
end;

function TBaseRecycleBinFrame.RecycleBin: TBaseRecycleBin;
begin
  Result := Entity as TBaseRecycleBin;
end;

end.
