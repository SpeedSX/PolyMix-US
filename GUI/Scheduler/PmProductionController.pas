unit PmProductionController;

interface

uses Classes, Forms, DB, SysUtils, ADODB,
   JvAppStorage, JvJCLUtils, Variants, JvSpeedBar,

   PmEntity, PmEntityController, DicObj, PmProviders, PmProcessCfg, fProductionFrame,
   BaseRpt, PmScriptManager, PmProduction, PmDatabase, fBaseFrame,
   fProductionToolbar;

type
  TProductionController = class(TEntityController)
  private
    FToolbarFrame: TProductionToolbar;
    function GetProduction: TProduction;
    procedure ScriptError(_Process: TPolyProcessCfg; _ScriptFieldName: string;
       _ErrPos: integer; _Msg: string);
    function GetProductionFrame: TProductionFrame;
    procedure LaunchReport(Sender: TObject);
    procedure OpenOrder(Sender: TObject);
    procedure FilterChange;
    procedure DisableFilter;
    procedure DoOpenOrder(Sender: TObject);
    procedure PauseJob(Sender: TObject);
  public
    constructor Create(_Entity: TEntity); override;
    destructor Destroy; override;
    function Visible: boolean; override;
    //procedure EditCurrent; override;
    //procedure DeleteCurrent(Confirm: boolean); override;
    function CreateFrame(Owner: TComponent): TBaseFrame; override;
    //procedure CancelCurrent; override;
    procedure RefreshProduction;
    procedure Activate; override;
    //procedure LoadSettings(AppStorage: TjvCustomAppStorage); override;
    //procedure SaveSettings(AppStorage: TjvCustomAppStorage); override;
    function GetToolbar: TjvSpeedbar; override;

    property Production: TProduction read GetProduction;
    property ProdFrame: TProductionFrame read GetProductionFrame;
  end;

implementation

uses Dialogs, RDialogs, MainData, RDBUtils, DateUtils, Controls,
  PmAccessManager, CalcSettings, PmAppController, MainFilter, StdDic,
  PmConfigManager;

constructor TProductionController.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  FFilter := TProductionFilterObj.Create;
  Production.Criteria := FFilter as TProductionFilterObj;
  FFilter.RestoreFilter(TSettingsManager.Instance.Storage, iniFilter + FEntity.InternalName);
  FCaption := 'В работе: ' + TConfigManager.Instance.StandardDics.deEquipGroup.ItemName[TProduction(_Entity).EquipGroupCode];
  Production.OnScriptError := ScriptError;
end;

destructor TProductionController.Destroy;
begin
  inherited Destroy;
end;

function TProductionController.Visible: boolean;
begin
  Result := AccessManager.CurUser.ViewProduction;
end;

function TProductionController.GetProduction: TProduction;
begin
  Result := FEntity as TProduction;
end;

function TProductionController.CreateFrame(Owner: TComponent): TBaseFrame;
begin
  FFrame := TProductionFrame.Create(Owner, Production);
  Production.OnScriptError := ScriptError;
  TProductionFrame(FFrame).OnScriptError := ScriptError;
  FFrame.OnFilterChange := FilterChange;
  FFrame.OnDisableFilter := DisableFilter;
  FFrame.OnHideFilter := AppController.HideFilter;
  TProductionFrame(FFrame).OnLaunchReport := LaunchReport;
  TProductionFrame(FFrame).OnOpenOrder := DoOpenOrder;
  TProductionFrame(FFrame).OnPauseJob := PauseJob;
  FFrame.AfterCreate;
  Result := FFrame;
end;

procedure TProductionController.PauseJob(Sender: TObject);
begin
  Database.ExecuteNonQuery('update OrderProcessItem set IsPaused = '
      + IntToStr(Ord(not Production.IsPaused))
      + ' where ItemID = ' + IntToStr(Production.ItemID));
  Production.Reload;
end;

procedure TProductionController.ScriptError(_Process: TPolyProcessCfg; _ScriptFieldName: string;
   _ErrPos: integer; _Msg: string);
begin
  ScriptManager.ShowScriptError(_Process, _ScriptFieldName, _ErrPos, _Msg, TSettingsManager.Instance.Storage);
end;

procedure TProductionController.RefreshProduction;
begin
  Production.Reload;
end;

procedure TProductionController.Activate;
var
  Save_Cursor: TCursor;
begin
  // не обновлять если уже открыт
  if not Production.DataSet.Active then
  begin
    //TProductionFrame(FFrame).OpenData;
    Save_Cursor := Screen.Cursor;
    Screen.Cursor := crSQLWait;
    try
      Production.Reload;
    finally
      Screen.Cursor := Save_Cursor;  { Always restore to normal }
    end;
  end;
end;

{procedure TProductionView.LoadSettings(AppStorage: TjvCustomAppStorage);
begin
  TProductionFrame(FFrame).LoadSettings;
end;

procedure TProductionView.SaveSettings(AppStorage: TjvCustomAppStorage);
begin
  if FFrame <> nil then
    TProductionFrame(FFrame).SaveSettings;
end;}

function TProductionController.GetProductionFrame: TProductionFrame;
begin
  Result := TProductionFrame(FFrame);
end;

procedure TProductionController.LaunchReport(Sender: TObject);
var
  Rpt: TBaseReport;
  StartRow, StartCol, ColCount: integer;
  FileName, RptCaption, ReportFields: string;
  DataSet: TDataSet;
  V: Variant;
  r, c: integer;
  FName: string;
  DateTo: TDateTime;
begin
  // TODO: Здесь надо было бы выдать предупреждение, если много записей
  Production.FetchAllRecords;
  //Plan_GetReportParams(FileName, RptCaption, ReportFields);
  { TODO: ЗАПЛАТКА, надо где-то брать это имя файла!!!!!!!!!!!!!!!!!! }
  if Production.EquipGroupCode = 1 then
    FileName := 'Production_Print.xls'
  else
    FileName := 'Production.xls';
  RptCaption := FCaption;
  //ReportFields := 'ID_Number;CustomerName;CommentPart;Colors;PaperTypeName;PaperDensity;PrintPages;PrintTotal;PrintPause;PlanFinishDate';
  ReportFields := ProdFrame.GetColumnFields;
  StartRow := 4;//Plan_GetReportStartRow;
  StartCol := 1;//Plan_GetReportStartCol;

  Rpt := ScriptManager.OpenReport(ExtractFileDir(ParamStr(0)) + '\' + FileName);
  if Rpt <> nil then
  begin
    Rpt.WinCaption1 := 'Excel -::- PolyMix'; // Изменение заголовка окна
    Rpt.WinCaption2 := RptCaption; //Plan_GetReportCaption;
    Rpt.FontApplied := false;
    DataSet := Production.DataSet;
    ColCount := CountOfChar(';', ReportFields) + 1;
    if (ColCount > 0) and (DataSet.RecordCount > 0) then
    begin
      V := VarArrayCreate([1, DataSet.RecordCount, 1, ColCount], varVariant);
      DataSet.First;
      r := 1;
      while not DataSet.eof do
      begin
        for c := 1 to ColCount do
        begin
          FName := SubStrBySeparator(ReportFields, c - 1, ';');
          V[r, c] := DataSet[FName];
        end;
        r := r + 1;
        DataSet.Next;
      end;
      Rpt.CreateTable(V, StartRow, StartCol, false, false);
      Rpt.DrawAllFrames(StartRow, StartCol,
        StartRow + DataSet.RecordCount - 1, StartCol + ColCount - 1);
      Rpt.Cells[1, 1] := TConfigManager.Instance.StandardDics.deEquipGroup.ItemName[Production.EquipGroupCode]
        + '  (' + FFilter.GetFilterPhrase(Production) + ')';
      Rpt.Visible := true;
    end;
  end;
end;

procedure TProductionController.OpenOrder(Sender: TObject);
begin
  // TODO -cMM: TPlanView.OpenOrder default body inserted
end;

{procedure TProductionView.HideFilter(Sender: TObject);
begin
  AppController.HideFilter(Sender);
end;}

procedure TProductionController.FilterChange;
begin
  Production.Reload;
end;

procedure TProductionController.DisableFilter;
begin

end;

// Открывает текущий заказ для редактирования
procedure TProductionController.DoOpenOrder(Sender: TObject);
var
  KRec: TKindPerm;
begin
  if Production.OrderID > 0 then
  begin
    // Мають бути права на перегляд замовлення
    if AccessManager.CurUser.WorkViewOwnOnly and (CompareText(Production.CreatorName, AccessManager.CurUser.Login) <> 0) then
      Exit;

    AccessManager.ReadUserKindPermTo(KRec, Production.KindID, AccessManager.CurUser.ID);
    if not KRec.WorkVisible or not KRec.WorkBrowse then Exit;

    AppController.EditWorkOrder(Production.OrderID);
  end;
end;

function TProductionController.GetToolbar: TjvSpeedbar;
begin
  if FToolbarFrame = nil then
    FToolbarFrame := TProductionToolbar.Create(nil);
  Result := FToolbarFrame.Toolbar;
end;

end.
