unit PmBaseRecycleBinView;

interface

uses Classes, Forms, Controls, Dialogs, SysUtils, JvAppStorage, JvSpeedBar,

  CalcUtils, PmEntity, PmRecycleBin, PmEntityController, fBaseRecycleBin,
  CalcSettings, fBaseFrame, fBaseRecycleBinToolbar;

type
  TBaseRecycleBinView = class(TEntityController)
  private
    FToolbarFrame: TBaseRecycleBinToolbar;
    function GetFrame: TBaseRecycleBinFrame;
    function GetRecycleBin: TBaseRecycleBin;
  protected
    function DoCreateFrame(Owner: TComponent): TBaseRecycleBinFrame; virtual; abstract;
    procedure DoRestoreSelected(Sender: TObject); virtual;
    procedure DoPurgeSelected(Sender: TObject); virtual;
    procedure DoPurgeAll(Sender: TObject); virtual;
    procedure DoRefresh(Sender: TObject); virtual;
    function GetSelectedKeyValues: TIntArray;
  public
    constructor Create(_Entity: TEntity); override;
    destructor Destroy; override;
    function Visible: boolean; override;
    //procedure EditCurrent; override;
    //procedure DeleteCurrent(Confirm: boolean); override;
    function CreateFrame(Owner: TComponent): TBaseFrame; override;
    //procedure CancelCurrent; override;
    procedure RefreshRecycleBin;
    procedure Activate; override;
    function GetToolbar: TjvSpeedbar; override;
    //procedure LoadSettings(AppStorage: TjvCustomAppStorage); override;
    //procedure SaveSettings(AppStorage: TjvCustomAppStorage); override;

    property RecycleBin: TBaseRecycleBin read GetRecycleBin;
    property Frame: TBaseRecycleBinFrame read GetFrame;
  end;

implementation

uses RDialogs, DBGridEh, PmActions;

constructor TBaseRecycleBinView.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  TMainActions.GetAction(TRecycleBinActions.Restore).OnExecute := DoRestoreSelected;
  TMainActions.GetAction(TRecycleBinActions.Purge).OnExecute := DoPurgeSelected;
  TMainActions.GetAction(TRecycleBinActions.PurgeAll).OnExecute := DoPurgeAll;
end;

destructor TBaseRecycleBinView.Destroy;
begin
  inherited Destroy;
end;

function TBaseRecycleBinView.Visible: boolean;
begin
  Result := true;
end;

{procedure TBaseRecycleBinView.EditCurrent;
begin
end;

procedure TBaseRecycleBinView.CancelCurrent;
begin
end;

procedure TBaseRecycleBinView.DeleteCurrent(Confirm: boolean);
begin
end;}

function TBaseRecycleBinView.GetRecycleBin: TBaseRecycleBin;
begin
  Result := FEntity as TBaseRecycleBin;
end;

function TBaseRecycleBinView.CreateFrame(Owner: TComponent): TBaseFrame;
begin
  FFrame := DoCreateFrame(Owner);
  TBaseRecycleBinFrame(FFrame).OnPurgeSelected := DoPurgeSelected;
  TBaseRecycleBinFrame(FFrame).OnRestoreSelected := DoRestoreSelected;
  TBaseRecycleBinFrame(FFrame).OnPurgeAll := DoPurgeAll;
  TBaseRecycleBinFrame(FFrame).OnRefresh := DoRefresh;
  //TRecycleBinFrame(FFrame).AfterCreate;
  Result := FFrame;
end;

procedure TBaseRecycleBinView.RefreshRecycleBin;
begin
  RecycleBin.Reload;
end;

procedure TBaseRecycleBinView.Activate;
var
  Save_Cursor: TCursor;
begin
  // не обновлять если уже открыт
  if not RecycleBin.DataSet.Active then
  begin
    //TProductionFrame(FFrame).OpenData;
    Save_Cursor := Screen.Cursor;
    Screen.Cursor := crSQLWait;
    try
      RecycleBin.Reload;
    finally
      Screen.Cursor := Save_Cursor;  { Always restore to normal }
    end;
  end;
end;

{procedure TBaseRecycleBinView.LoadSettings(AppStorage: TjvCustomAppStorage);
begin
  TBaseRecycleBinFrame(FFrame).LoadSettings;
end;

procedure TBaseRecycleBinView.SaveSettings(AppStorage: TjvCustomAppStorage);
begin
  if FFrame <> nil then
    TBaseRecycleBinFrame(FFrame).SaveSettings;
end;}

function TBaseRecycleBinView.GetFrame: TBaseRecycleBinFrame;
begin
  Result := TBaseRecycleBinFrame(FFrame);
end;

function TBaseRecycleBinView.GetSelectedKeyValues: TIntArray;
var
  KeyValues: TIntArray;
  Rows: TBookmarkListEh;
  I: Integer;
begin
  Rows := TBaseRecycleBinFrame(FFrame).SelectedRows;
  if Rows.Count > 1 then
  begin
    SetLength(KeyValues, Rows.Count);
    for i := 0 to Pred(Rows.Count) do
    begin
      RecycleBin.DataSet.GotoBookmark(pointer(Rows[i]));
      KeyValues[i] := RecycleBin.KeyValue;
    end;
  end
  else
  begin
    SetLength(KeyValues, 1);
    KeyValues[0] := RecycleBin.KeyValue;
  end;
  Result := KeyValues;
end;

procedure TBaseRecycleBinView.DoPurgeSelected(Sender: TObject);
var
  s: string;
  KeyValues: TIntArray;
begin
  KeyValues := GetSelectedKeyValues;
  if Length(KeyValues) > 1 then
    s := IntToStr(Length(KeyValues)) + ' объектов'
  else
    s := RecycleBin.EntityName;

  if RusMessageDlg('Вы хотите удалить ' + s + '.'
    + #13'Восстановление будет невозможно. Продолжить?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then

  // Запускается асинхронное удаление
  RecycleBin.PurgeObjects(KeyValues);

  TBaseRecycleBinFrame(FFrame).ClearSelectedRows;
end;

procedure TBaseRecycleBinView.DoPurgeAll(Sender: TObject);
begin
  if RusMessageDlg('Вы хотите очистить корзину.'
    + #13'Восстановление будет невозможно. Продолжить?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  RecycleBin.PurgeAll;
end;

procedure TBaseRecycleBinView.DoRefresh(Sender: TObject);
begin
  RefreshRecycleBin;
end;

procedure TBaseRecycleBinView.DoRestoreSelected(Sender: TObject);
var
  KeyValues: TIntArray;
begin
  KeyValues := GetSelectedKeyValues;

  RecycleBin.RestoreObjects(KeyValues);

  TBaseRecycleBinFrame(FFrame).ClearSelectedRows;
end;

function TBaseRecycleBinView.GetToolbar: TjvSpeedbar;
begin
  if FToolbarFrame = nil then
    FToolbarFrame := TBaseRecycleBinToolbar.Create(nil);
  Result := FToolbarFrame.Toolbar;
end;

end.
