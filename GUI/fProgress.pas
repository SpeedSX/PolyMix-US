unit fProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrlsEh, StdCtrls, Mask, JvExMask, JvToolEdit, JvDBControls,
  DBCtrls, ExtCtrls, Buttons, DB, PmProcess, CalcSettings, CalcUtils;

type
  TProgressFrame = class(TFrame)
    paWorkBottom: TPanel;
    lbPlan: TLabel;
    lbFact: TLabel;
    btFactStartNow: TSpeedButton;
    btFactFinishNow: TSpeedButton;
    imPlanArr: TImage;
    imFactArr: TImage;
    shPlanDur: TShape;
    shFactDur: TShape;
    Bevel1: TBevel;
    shPlanExec: TShape;
    dtPlanDur: TDBText;
    shFactExec: TShape;
    dtFactDur: TDBText;
    deFactStart: TJvDBDateEdit;
    tmFactStart: TDBDateTimeEditEh;
    deFactFinish: TJvDBDateEdit;
    tmFactFinish: TDBDateTimeEditEh;
    dtPlanStartDate: TDBText;
    dtPlanStartTime: TDBText;
    dtPlanFinishDate: TDBText;
    dtPlanFinishTime: TDBText;
    procedure btFactStartNowClick(Sender: TObject);
    procedure btFactFinishNowClick(Sender: TObject);
  private
    FAllowEdit: Boolean;
    FDataSource: TDataSource;
    FDataSet: TDataSet;
    FLastPermitFactKinds: TIntArray;
    FLastProcessID: Integer;
    FProcess: TPolyProcess;
    FPermittedFactKinds: TIntArray;  // Виды, в которых разрешена установка фактических дат в нашем процессе
    function GetProcessPermitFactKinds: TIntArray;
    function IsPartName: Boolean;
    procedure SetCurDate(const DateField, TimeField: string);
    procedure SetDataSource(const Value: TDataSource);
    procedure SetProcess(const Value: TPolyProcess);
  public
    procedure UpdateControls;
    procedure ReDraw;
    procedure HideShapes;

    // Разрешать ли редактирование фактических дат
    property AllowEdit: Boolean read FAllowEdit write FAllowEdit;
    // Откуда брать даты
    property DataSource: TDataSource read FDataSource write SetDataSource;
    // Если указан процесс, то настройки берем из него
    property Process: TPolyProcess read FProcess write SetProcess;
  end;

implementation

uses MainData, RDBUtils, PlanUtils, PmAccessManager, PmOrderProcessItems;

{$R *.dfm}

procedure TProgressFrame.btFactStartNowClick(Sender: TObject);
begin
  SetCurDate(TOrderProcessItems.F_FactStart, 'FactStartTime_ICalc');
end;

procedure TProgressFrame.btFactFinishNowClick(Sender: TObject);
begin
  SetCurDate(TOrderProcessItems.F_FactFinish, 'FactFinishTime_ICalc');
end;

// Получает виды заказа, в которых есть право на изменение фактических дат
function TProgressFrame.GetProcessPermitFactKinds: TIntArray;
begin
  if FLastProcessID <> FDataSet['ProcessID'] then
  begin
    FLastProcessID := FDataSet['ProcessID'];
    FLastPermitFactKinds := AccessManager.GetPermittedKindsProcess(AccessManager.CurUser.ID, FLastProcessID, 'FactDate')
  end;
  Result := FLastPermitFactKinds;
end;

procedure TProgressFrame.UpdateControls;
var
  NotPart, EnPlan, EnFact, VisPlan, PermitFact: boolean;
begin
  if FDataSet = nil then Exit;

  NotPart := not FDataSet.IsEmpty and ((FDataSet.FindField(TOrderProcessItems.F_IsPartName) = nil)
    or not NvlBoolean(FDataSet[TOrderProcessItems.F_IsPartName]));

  if FProcess <> nil then
    VisPlan := FProcess.ProcessCfg.PlanningEnabled and not FDataSet.IsEmpty
  else
    VisPlan := ((FDataSet.FindField(TOrderProcessItems.F_PlanningEnabled) = nil)
      or NvlBoolean(FDataSet[TOrderProcessItems.F_PlanningEnabled])) and not FDataSet.IsEmpty;
  dtPlanStartDate.Visible := VisPlan;
  dtPlanStartTime.Visible := VisPlan;
  //btPlanStartNow.Visible := VisPlan;
  imPlanArr.Visible := VisPlan;
  dtPlanFinishDate.Visible := VisPlan;
  dtPlanFinishTime.Visible := VisPlan;
  //btPlanFinishNow.Visible := VisPlan;
  dtPlanDur.Visible := VisPlan;
  lbPlan.Visible := VisPlan;
  if VisPlan then
  begin
    EnPlan := NotPart {and NvlBoolean(FDataSet['PermitPlan'])};
    dtPlanStartDate.Enabled := NotPart;//EnPlan;
    dtPlanStartTime.Enabled := NotPart;//EnPlan;
    //btPlanStartNow.Enabled := EnPlan;
    imPlanArr.Enabled := NotPart;//EnPlan;
    dtPlanFinishDate.Enabled := NotPart;//EnPlan;
    dtPlanFinishTime.Enabled := NotPart;//EnPlan;
    //btPlanFinishNow.Enabled := EnPlan;
    dtPlanDur.Enabled := NotPart;//EnPlan;
    imPlanArr.Visible := imPlanArr.Visible and NotPart;
    lbPlan.Visible := lbPlan.Visible and NotPart;
  end;

  deFactStart.Visible := NotPart;
  tmFactStart.Visible := NotPart;
  btFactStartNow.Visible := NotPart and AllowEdit;
  imFactArr.Visible := NotPart;
  deFactFinish.Visible := NotPart;
  tmFactFinish.Visible := NotPart;
  btFactFinishNow.Visible := NotPart and AllowEdit;
  dtFactDur.Visible := NotPart;
  lbFact.Visible := NotPart;

  PermitFact := not FDataSet.IsEmpty;
  if PermitFact then
  begin
    if FProcess <> nil then
      PermitFact := IntInArray(FDataSet['KindID'], FPermittedFactKinds)
    else
     // Если не указан процесс, то либо должно быть поле
     if FDataSet.FindField('PermitFact') <> nil then
       PermitFact := NvlBoolean(FDataSet['PermitFact'])
     else
     begin  // иначе определяем есть ли право на этот процесс
       PermitFact := IntInArray(FDataSet['ProcessID'], GetProcessPermitFactKinds);
     end;
  end;
  PermitFact := PermitFact and AllowEdit;
  EnFact := NotPart and PermitFact;
  deFactStart.Enabled := EnFact;
  tmFactStart.Enabled := EnFact;
  btFactStartNow.Enabled := EnFact;
  imFactArr.Enabled := EnFact;
  deFactFinish.Enabled := EnFact;
  tmFactFinish.Enabled := EnFact;
  btFactFinishNow.Enabled := EnFact;
  dtFactDur.Enabled := EnFact;
end;

procedure TProgressFrame.ReDraw;
var
  es, w, w1: integer;
  FactStart, PlanStart, PlanFinish, ps: variant;
begin
  if FDataSet = nil then Exit;

  if not FDataSet.IsEmpty and not IsPartName then
  try
    es := NvlInteger(FDataSet[TOrderProcessItems.F_ExecState]);
    FactStart := FDataSet[TOrderProcessItems.F_FactStart];
    PlanStart := FDataSet[TOrderProcessItems.F_PlanStart];
    PlanFinish := FDataSet[TOrderProcessItems.F_PlanFinish];
    //FactFinish := cdExecState['FactStartDate'];
    w1 := shPlanDur.Width - 2;
    if (es = esPlanInProgress) and not VarIsNull(PlanFinish) then
    begin
      w := Round((Now - PlanStart) / (PlanFinish - PlanStart) * w1);
      if w > w1 then w := w1;
      shPlanExec.Width := w;
      shPlanExec.Visible := true;
      //shPlanDur.Visible := true;
      shFactExec.Visible := false;
      //shFactDur.Visible := false;
    end
    else
    if es = esInProgress then
    begin
      if VarIsNull(PlanStart) then ps := FactStart else ps := PlanStart;
      if not VarIsNull(PlanFinish) and (Now > ps) then
      begin
        w := Round((Now - ps) / (PlanFinish - ps) * w1);
        if w > w1 then w := w1;
        shPlanExec.Width := w;
        shPlanExec.Visible := true;
      end
      else
        shPlanExec.Visible := false;
      if not VarIsNull(PlanFinish) and (Now > FactStart) and (PlanFinish > FactStart) then
      begin
        w := Round((Now - FactStart) / (PlanFinish - FactStart) * w1);
        if w > w1 then w := w1;
        shFactExec.Width := w;
        shFactExec.Visible := true;
      end
      else
        shFactExec.Visible := false;
    end
    else
    if es = esPlanFinished then
    begin
      shPlanExec.Width := shPlanDur.Width - 1;
      shPlanExec.Visible := true;
      //shPlanDur.Visible := true;
      shFactExec.Visible := false;
      //shFactDur.Visible := false;
    end
    else
    if es = esFactFinished then
    begin
      shPlanExec.Visible := false;
      shFactExec.Visible := true;
      shFactExec.Width := shFactDur.Width - 1;
    end
    else
    begin
      HideShapes;
    end;
  except
    HideShapes;
  end
  else
    HideShapes;
  shPlanDur.Visible := shPlanExec.Visible;
  shFactDur.Visible := shFactExec.Visible;
end;

procedure TProgressFrame.HideShapes;
begin
  shPlanExec.Visible := false;
  //shPlanDur.Visible := false;
  shFactExec.Visible := false;
  //shFactDur.Visible := false;
end;

function TProgressFrame.IsPartName: Boolean;
begin
  Result := (FDataSet.FindField(TOrderProcessItems.F_IsPartName) = nil)
    or NvlBoolean(FDataSet[TOrderProcessItems.F_IsPartName]);
end;

procedure TProgressFrame.SetCurDate(const DateField, TimeField: string);
var Nw: TDateTime;
begin
  if FDataSet.Active then
  begin
    Nw := dm.GetCurrentServerDate;
    FDataSet.Edit;
    FDataSet[DateField] := Nw;
    FDataSet.Edit;
    FDataSet[TimeField] := Nw;
    //cdExecState.Post;
  end;
end;

procedure TProgressFrame.SetDataSource(const Value: TDataSource);
begin
  if Value <> nil then
    FDataSet := Value.DataSet
  else
    FDataSet := nil;

  dtPlanStartDate.DataSource := Value;
  dtPlanStartTime.DataSource := Value;
  dtPlanFinishDate.DataSource := Value;
  dtPlanFinishTime.DataSource := Value;

  deFactStart.DataSource := Value;
  tmFactStart.DataSource := Value;
  deFactFinish.DataSource := Value;
  tmFactFinish.DataSource := Value;

  dtPlanDur.DataSource := Value;
  dtFactDur.DataSource := Value;

  UpdateControls;
  ReDraw;
end;

procedure TProgressFrame.SetProcess(const Value: TPolyProcess);
begin
  FProcess := Value;
  FPermittedFactKinds := AccessManager.GetPermittedKindsProcess(AccessManager.CurUser.ID, FProcess.SrvID, 'PlanDate');
  UpdateControls;
  ReDraw;
end;

end.
