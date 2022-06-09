unit PmStockMoveView;

interface

uses Classes, Controls, Forms, SysUtils, JvAppStorage, Dialogs, ExtCtrls,
  JvSpeedBar,

  NotifyEvent, fBaseFrame, PmEntity, PmEntityController, fStockMoveFrame, PmStockMove,
  fStockMoveToolbar;

type
  TStockMoveView = class(TEntityController)
  private
    FToolbarFrame: TStockMoveToolbarFrame;
    function GetFrame: TStockMoveFrame;
    function GetStock: TStockMove;
    procedure DoPrintReport(Sender: TObject);
    procedure FilterChange;
    procedure DisableFilter;
  public
    constructor Create(_Entity: TEntity); override;
    destructor Destroy; override;
    function Visible: boolean; override;
    procedure EditCurrent;
    function CreateFrame(Owner: TComponent): TBaseFrame; override;
    procedure Activate; override;
    //procedure LoadSettings(AppStorage: TjvCustomAppStorage); override;
    //procedure SaveSettings(AppStorage: TjvCustomAppStorage); override;
    procedure RefreshData; override;
    function GetToolbar: TjvSpeedbar; override;
    property Frame: TStockMoveFrame read GetFrame;
    property StockMove: TStockMove read GetStock;
  end;

implementation

uses Variants, DB, DateUtils,

  CalcUtils, RDialogs, PmDatabase, PmAppController,
  DicObj, StdDic, RDBUtils, MainFilter,
  CalcSettings, PmActions, PmScriptManager;

constructor TStockMoveView.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  FCaption := 'Материалы:Движение';

  FFilter := TStockFilterObj.Create;
  StockMove.Criteria := FFilter as TStockFilterObj;
  FFilter.RestoreFilter(TSettingsManager.Instance.Storage, iniFilter + FEntity.InternalName);

  TMainActions.GetAction(TStockMoveActions.PrintReport).OnExecute := DoPrintReport;
end;

destructor TStockMoveView.Destroy;
begin
  inherited;
end;

function TStockMoveView.Visible: boolean;
begin
  Result := true;
end;

function TStockMoveView.CreateFrame(Owner: TComponent): TBaseFrame;
begin
  FFrame := TStockMoveFrame.Create(Owner, StockMove);
  FFrame.OnFilterChange := FilterChange;
  FFrame.OnDisableFilter := DisableFilter;
  FFrame.OnHideFilter := AppController.HideFilter;
  Result := FFrame;
end;

procedure TStockMoveView.Activate;
var
  Save_Cursor: TCursor;
begin
  // не обновлять если уже открыт
  if not FEntity.DataSet.Active then
  begin
    Save_Cursor := Screen.Cursor;
    Screen.Cursor := crSQLWait;
    try
      FEntity.Reload;
    finally
      Screen.Cursor := Save_Cursor;  { Always restore to normal }
    end;
  end;
end;

{procedure TStockMoveView.LoadSettings(AppStorage: TjvCustomAppStorage);
begin
  inherited LoadSettings(AppStorage);
  if FFrame <> nil then // на всякий аварийный
    TStockMoveFrame(FFrame).LoadSettings;
end;

procedure TStockMoveView.SaveSettings(AppStorage: TjvCustomAppStorage);
begin
  inherited SaveSettings(AppStorage); // сохраняет фильтр!
  if FFrame <> nil then // на всякий аварийный
    TStockMoveFrame(FFrame).SaveSettings;
end;}

function TStockMoveView.GetFrame: TStockMoveFrame;
begin
  Result := TStockMoveFrame(FFrame);
end;

procedure TStockMoveView.RefreshData;
begin
  inherited;
  //MatRequest.Reload;
end;

function TStockMoveView.GetStock: TStockMove;
begin
  Result := Entity as TStockMove;
end;

procedure TStockMoveView.DoPrintReport(Sender: TObject);
begin
  //ScriptManager.ExecOrderEvent(nil, TScriptManager.PrintMatRequestReport);
end;

procedure TStockMoveView.EditCurrent;
begin
end;

function TStockMoveView.GetToolbar: TjvSpeedbar;
begin
  if FToolbarFrame = nil then
    FToolbarFrame := TStockMoveToolbarFrame.Create(nil);
  Result := FToolbarFrame.Toolbar;
end;

procedure TStockMoveView.FilterChange;
begin
  RefreshData;
end;

procedure TStockMoveView.DisableFilter;
begin

end;

end.
