unit fProductionFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PmProduction, Grids, DBGridEh, MyDBGridEh, JvAppStorage, JvFormPlacement,
  Buttons, StdCtrls, ExtCtrls, ImgList, GridsEh,

  fProdBase, fProdFilter, MainFilter, fProgress, NotifyEvent, fBaseFilter,
  PmEntity, DBGridEhGrouping;

type
  TProductionFrame = class(TProductionBaseFrame)
    paTable: TPanel;
    dgProduction: TMyDBGridEh;
    paCommands: TPanel;
    btApplyDay: TBitBtn;
    btCancelDay: TBitBtn;
    btEditJob: TBitBtn;
    Panel1: TPanel;
    sbOpenOrder: TSpeedButton;
    btXLDayPlan: TBitBtn;
    btPause: TBitBtn;
    Panel2: TPanel;
    procedure btXLDayPlanClick(Sender: TObject);
    procedure sbOpenOrderClick(Sender: TObject);
    procedure btEditJobClick(Sender: TObject);
    procedure btPauseClick(Sender: TObject);
    procedure dgProductionGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
  private
    //FProduction: TProduction;
    FOnLaunchReport, FOnOpenOrder, FOnEditJob, FOnPauseJob: TNotifyEvent;
    FAfterScrollID, FAfterOpenID: TNotifyHandlerID;
    procedure Plan_ProductionCreateGridColumns(dg: TMyDBGridEh);
    procedure Production_AfterScroll(Sender: TObject);
    procedure Production_AfterOpen(Sender: TObject);
  protected
    FProgressFrame: TProgressFrame;
    procedure DefaultCreateGridColumns(dg: TDBGridEh);
  public
    constructor Create(Owner: TComponent; _Production: TEntity); override;
    destructor Destroy; override;
    procedure AfterCreate; override;
    function GetColumnFields: string;
    procedure OpenData; override;
    procedure SaveSettings; override;
    procedure LoadSettings; override;
    function CreateFilterFrame: TBaseFilterFrame; override;
    function Production: TProduction;

    property OnLaunchReport: TNotifyEvent read FOnLaunchReport write FOnLaunchReport;
    property OnOpenOrder: TNotifyEvent read FOnOpenOrder write FOnOpenOrder;
    property OnPauseJob: TNotifyEvent read FOnPauseJob write FOnPauseJob;
    property OnEditJob: TNotifyEvent read FOnEditJob write FOnEditJob;

  end;

implementation

uses CalcSettings, PmProcess, PlanUtils, PmOrder, fMainFilter, PmOrderProcessItems;

{$R *.dfm}

constructor TProductionFrame.Create(Owner: TComponent; _Production: TEntity);
{var
  _Name: string;}
begin
  //_Name := 'Production_'  + IntToStr(_Production.EquipGroupCode);
  inherited Create(Owner, _Production{, _Name});
  //FProduction := _Production;
  //FMainStorage := _MainStorage;
  dgProduction.DataSource := Production.DataSource;
  CreateStateLists;
  FAfterScrollID := Entity.AfterScrollNotifier.RegisterHandler(Production_AfterScroll);
  FAfterOpenID := Entity.OpenNotifier.RegisterHandler(Production_AfterOpen);

  // создаем фрейм с фильтром
  FilterObject := Production.Criteria;
  FilterFrame.Entity := Entity;

  FProgressFrame := TProgressFrame.Create(Self);
  FProgressFrame.Parent := paTable;
  FProgressFrame.Top := paCommands.Top + 5;
  FProgressFrame.DataSource := Production.DataSource;
  //FProgressFrame.Process := FProduction.Process;
end;

destructor TProductionFrame.Destroy;
begin
  if Entity <> nil then
  begin
    Entity.AfterScrollNotifier.UnregisterHandler(FAfterScrollID);
    Entity.OpenNotifier.UnregisterHandler(FAfterOpenID);
  end;
  FStateTextList.Free;
  FStateCodeList.Free;
  FOrderStateTextList.Free;
  FOrderStateCodeList.Free;
  inherited Destroy;
end;

function TProductionFrame.CreateFilterFrame: TBaseFilterFrame;
begin
  Result := TProdFilterFrame.Create(Self);
end;

procedure TProductionFrame.AfterCreate;
begin
  inherited;
  Plan_ProductionCreateGridColumns(dgProduction);
end;

procedure TProductionFrame.OpenData;
begin
(*var
  Save_Cursor: TCursor;
begin
  Save_Cursor := Screen.Cursor;
  Screen.Cursor := crSQLWait;
  try
    UpdateViewRange(false);  // не обновлять если уже открыта
  finally
    Screen.Cursor := Save_Cursor;  { Always restore to normal }
  end;*)
end;

procedure TProductionFrame.SaveSettings;
begin
  inherited SaveSettings;
  TSettingsManager.Instance.SaveGridLayout(dgProduction, GetIniSection);
end;

procedure TProductionFrame.LoadSettings;
begin
  inherited LoadSettings;
  TSettingsManager.Instance.LoadGridLayout(dgProduction, GetIniSection);
end;

procedure TProductionFrame.Plan_ProductionCreateGridColumns(dg: TMyDBGridEh);
begin
  // Сначала создаем все стандартные столбцы, потом запускаем скрипт
  DefaultCreateGridColumns(dg);
  ExecGridCode(PmProcess.PlanScr_OnCreateProductionColumns, dg, Production);
end;

// Собираем поля столбцов для экспорта
function TProductionFrame.GetColumnFields: string;
var
  dgTemp: TMyDbGridEh;
begin
  // воссоздаем оригинальные стобцы на случай если они были перемещены
  dgTemp := TMyDBGridEh.Create(nil);
  try
    Plan_ProductionCreateGridColumns(dgTemp);
    dgTemp.DataSource := Production.DataSource;
    Result := GetColumnsFieldList(dgTemp);
  finally
    dgTemp.Free;
  end;
end;

procedure TProductionFrame.btXLDayPlanClick(Sender: TObject);
begin
  FOnLaunchReport(Production);
end;

procedure TProductionFrame.sbOpenOrderClick(Sender: TObject);
begin
  FOnOpenOrder(Production);
end;

procedure TProductionFrame.btEditJobClick(Sender: TObject);
begin
  FOnEditJob(Production);
end;

procedure TProductionFrame.btPauseClick(Sender: TObject);
begin
  FOnPauseJob(Production);
end;

procedure TProductionFrame.DefaultCreateGridColumns(dg: TDBGridEh);
var
  c: TColumnEh;
  im: TimageList;
begin
  dg.UseMultiTitle := true;

  c := dg.Columns.Add;
  c.FieldName := TOrder.F_OrderState;
  c.Alignment := taCenter;
  c.Width := 16;
  c.Title.Caption := ' ';
  c.ReadOnly := true;
  c.Title.TitleButton := true;
  c.ImageList := imOrderState;
  c.NotInKeyListIndex := 0;
  c.DblClickNextval := false;
  c.KeyList.Assign(FOrderStateCodeList);
  c.PickList.Assign(FOrderStateTextList);

  c := dg.Columns.Add;
  c.FieldName := 'ExecState';
  c.Alignment := taCenter;
  c.Width := 16;
  c.Title.Caption := ' ';
  c.ReadOnly := true;
  c.Title.TitleButton := true;
  c.ImageList := imSrvState;
  c.NotInKeyListIndex := 0;
  c.DblClickNextval := false;
  c.KeyList.Assign(FStateCodeList);
  c.PickList.Assign(FStateTextList);
  c := dg.Columns.Add;

  c.FieldName := 'ID_Number';
  c.Alignment := taRightJustify;
  c.Width := 53;
  c.Title.Caption := '№ заказа';
  c.Title.TitleButton := true;
  c.Title.SortMarker := smDownEh;

  c := dg.Columns.Add;
  c.FieldName := 'CustomerName';
  c.Alignment := taLeftJustify;
  c.Width := 200;
  c.Title.Caption := 'Заказчик';
  c.Title.TitleButton := true;

  c := dg.Columns.Add;
  c.FieldName := 'Comment';
  c.Alignment := taLeftJustify;
  c.Width := 200;
  c.Title.Caption := 'Наименование';
  c.ReadOnly := true;
  c.Title.TitleButton := true;

  c := dg.Columns.Add;
  c.FieldName := F_PartName;
  c.Alignment := taLeftJustify;
  c.Width := 50;
  c.Title.Caption := 'Часть';
  c.ReadOnly := true;
  c.Title.TitleButton := true;

  {c := dg.Columns.Add;
  c.FieldName := 'EquipName';
  c.Alignment := taLeftJustify;
  c.Width := 50;
  c.Title.Caption := 'Оборудование';
  c.Title.TitleButton := true;}

  c := dg.Columns.Add;
  c.FieldName := 'ItemDesc';
  c.Alignment := taLeftJustify;
  c.Width := 150;
  c.Title.Caption := 'Описание';
  c.Title.TitleButton := true;

  c := dg.Columns.Add;
  c.FieldName := TOrderProcessItems.F_ProductOut;
  c.Alignment := taLeftJustify;
  c.Width := 50;
  c.Title.Caption := 'Кол-во';
  c.Title.TitleButton := true;

  c := dg.Columns.Add;
  c.FieldName := 'FinishDate';
  c.Alignment := taLeftJustify;
  c.Width := 50;
  c.Title.Caption := 'Плановая сдача';
  c.Title.TitleButton := true;

  // Plan
  c := dg.Columns.Add;
  c.FieldName := TOrderProcessItems.F_PlanStart;
  c.Alignment := taCenter;
  c.Width := 80;
  c.Title.Caption := 'План|начало';
  c.ButtonStyle := cbsNone;

  c := dg.Columns.Add;
  c.FieldName := TOrderProcessItems.F_PlanFinish;
  c.Alignment := taCenter;
  c.Width := 80;
  c.Title.Caption := 'План|завершение';
  c.ButtonStyle := cbsNone;

  // Fact
  c := dg.Columns.Add;
  c.FieldName := TOrderProcessItems.F_FactStart;
  c.Alignment := taCenter;
  c.Width := 80;
  c.Title.Caption := 'Факт|начало';
  c.ButtonStyle := cbsNone;

  c := dg.Columns.Add;
  c.FieldName := TOrderProcessItems.F_FactFinish;
  c.Alignment := taCenter;
  c.Width := 80;
  c.Title.Caption := 'Факт|завершение';
  c.ButtonStyle := cbsNone;

  c := dg.Columns.Add;
  c.FieldName := 'Cost';
  c.Alignment := taRightJustify;
  c.Width := 50;
  c.Title.Caption := 'Стоимость';
  c.ReadOnly := true;

  {// Plan
  c := dg.Columns.Add;
  c.FieldName := 'PlanStartDate_icalc';
  c.Alignment := taCenter;
  c.Width := 50;
  c.Title.Caption := 'План.начало|дата';
  c.ButtonStyle := cbsNone;

  c := dg.Columns.Add;
  c.FieldName := 'PlanStartTime_icalc';
  c.Alignment := taCenter;
  c.Width := 50;
  c.Title.Caption := 'План.начало|время';
  c.ButtonStyle := cbsNone;

  c := dg.Columns.Add;
  c.FieldName := 'PlanFinishDate_icalc';
  c.Alignment := taCenter;
  c.Width := 50;
  c.Title.Caption := 'План.завершение|дата';
  c.ButtonStyle := cbsNone;

  c := dg.Columns.Add;
  c.FieldName := 'PlanFinishTime_icalc';
  c.Alignment := taCenter;
  c.Width := 50;
  c.Title.Caption := 'План.завершение|время';
  c.ButtonStyle := cbsNone;

  // Fact
  c := dg.Columns.Add;
  c.FieldName := 'FactStartDate_icalc';
  c.Alignment := taCenter;
  c.Width := 50;
  c.Title.Caption := 'Факт.начало|дата';
  c.ButtonStyle := cbsNone;

  c := dg.Columns.Add;
  c.FieldName := 'FactStartTime_icalc';
  c.Alignment := taCenter;
  c.Width := 50;
  c.Title.Caption := 'Факт.начало|время';
  c.ButtonStyle := cbsNone;

  c := dg.Columns.Add;
  c.FieldName := 'FactFinishDate_icalc';
  c.Alignment := taCenter;
  c.Width := 50;
  c.Title.Caption := 'Факт.завершение|дата';
  c.ButtonStyle := cbsNone;

  c := dg.Columns.Add;
  c.FieldName := 'FactFinishTime_icalc';
  c.Alignment := taCenter;
  c.Width := 50;
  c.Title.Caption := 'Факт.завершение|время';
  c.ButtonStyle := cbsNone;}
end;

procedure TProductionFrame.dgProductionGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  Background := GetProcessStateColor(Production.ExecState);
end;

procedure TProductionFrame.Production_AfterOpen(Sender: TObject);
begin
  Production_AfterScroll(Sender);
end;

procedure TProductionFrame.Production_AfterScroll(Sender: TObject);
var
  e: boolean;
begin
  e := not Production.DataSet.IsEmpty;
  btEditJob.Enabled := e;
  btXLDayPlan.Enabled := e;
  sbOpenOrder.Enabled := e;
  btPause.Enabled := e and PlanUtils.CanPause(Production.ExecState);
  if e then
  begin
    if Production.ExecState = esPaused then btPause.Caption := 'Продолжить'
    else btPause.Caption := 'Приостановить';
  end;

  FProgressFrame.UpdateControls;
  FProgressFrame.ReDraw;
end;

function TProductionFrame.Production: TProduction;
begin
  Result := Entity as TProduction;
end;

end.
