unit PmStockView;

interface

uses Classes, Controls, Forms, SysUtils, Dialogs, ExtCtrls,
  JvSpeedBar,

  NotifyEvent, fBaseFrame, PmEntity, PmEntityController, fStockFrame, PmStock,
  fStockToolbar;

type
  TStockView = class(TEntityController)
  private
    FToolbarFrame: TStockToolbarFrame;
    function GetFrame: TStockFrame;
    function GetStock: TStock;
    procedure DoPrintReport(Sender: TObject);
    procedure DoPrintForm(Sender: TObject);
    procedure DoEditStock(Sender: TObject);
    procedure DoNewStock(Sender: TObject);
    procedure DoDeleteStock(Sender: TObject);
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
    property Frame: TStockFrame read GetFrame;
    property Stock: TStock read GetStock;
  end;

implementation

uses Variants, DB, DateUtils,

  CalcUtils, RDialogs, PmDatabase, PmAppController,
  DicObj, StdDic, RDBUtils, MainFilter,
  CalcSettings, PmActions, PmScriptManager;

constructor TStockView.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  FCaption := 'ќстатки';

  TMainActions.GetAction(TStockActions.Edit).OnExecute := DoEditStock;
  TMainActions.GetAction(TStockActions.New).OnExecute := DoNewStock;
  TMainActions.GetAction(TStockActions.Delete).OnExecute := DoDeleteStock;
  TMainActions.GetAction(TStockActions.PrintReport).OnExecute := DoPrintReport;
  TMainActions.GetAction(TStockActions.PrintForm).OnExecute := DoPrintForm;
end;

destructor TStockView.Destroy;
begin
  inherited;
end;

function TStockView.Visible: boolean;
begin
  Result := true;
end;

function TStockView.CreateFrame(Owner: TComponent): TBaseFrame;
begin
  FFrame := TStockFrame.Create(Owner, Stock);
  Result := FFrame;
end;

procedure TStockView.Activate;
var
  Save_Cursor: TCursor;
begin
  // не обновл€ть если уже открыт
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

{procedure TStockView.LoadSettings(AppStorage: TjvCustomAppStorage);
begin
  inherited LoadSettings(AppStorage);
  if FFrame <> nil then // на вс€кий аварийный
    TStockFrame(FFrame).LoadSettings;
end;

procedure TStockView.SaveSettings(AppStorage: TjvCustomAppStorage);
begin
  inherited SaveSettings(AppStorage); // сохран€ет фильтр!
  if FFrame <> nil then // на вс€кий аварийный
    TStockFrame(FFrame).SaveSettings;
end;}

function TStockView.GetFrame: TStockFrame;
begin
  Result := TStockFrame(FFrame);
end;

procedure TStockView.RefreshData;
begin
  inherited;
  //MatRequest.Reload;
end;

function TStockView.GetStock: TStock;
begin
  Result := Entity as TStock;
end;

procedure TStockView.DoPrintReport(Sender: TObject);
begin
  //ScriptManager.ExecOrderEvent(nil, TScriptManager.PrintMatRequestReport);
end;

procedure TStockView.DoPrintForm(Sender: TObject);
begin
  //ScriptManager.ExecOrderEvent(nil, TScriptManager.PrintMatRequestForm);
end;

procedure TStockView.EditCurrent;
begin
end;

procedure TStockView.DoEditStock(Sender: TObject);
begin
  EditCurrent;
end;

procedure TStockView.DoNewStock(Sender: TObject);
begin

end;

procedure TStockView.DoDeleteStock(Sender: TObject);
begin

end;

function TStockView.GetToolbar: TjvSpeedbar;
begin
  if FToolbarFrame = nil then
    FToolbarFrame := TStockToolbarFrame.Create(nil);
  Result := FToolbarFrame.Toolbar;
end;

end.
