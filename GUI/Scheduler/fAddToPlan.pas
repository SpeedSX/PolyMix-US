unit fAddToPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ExtCtrls, JvExMask, JvToolEdit,
  ComCtrls, DBCtrls, DB, Grids, DBGridEh, MyDBGridEh, fmRelated, JvSpin,
  PmJobParams, anycolor;

type
  TJobNotifyEvent = function(Job: TJobParams): boolean of object;
  TJobEditMode = (jemNew, jemEdit, jemView);

  TAddToPlanForm = class(TForm)
    paDates: TPanel;
    Label3: TLabel;
    sbLockDur: TSpeedButton;
    Label4: TLabel;
    lbEstimatedDuration: TLabel;
    sbCurFactStart: TSpeedButton;
    sbCurFactFinish: TSpeedButton;
    lbExecutor: TLabel;
    lbfactProductOut: TLabel;
    cbExecutor: TDBLookupComboBox;
    edFactProductOut: TEdit;
    dsEmployees: TDataSource;
    paPreceding: TPanel;
    Label7: TLabel;
    paFollowing: TPanel;
    Label8: TLabel;
    paButtons: TPanel;
    btOk: TButton;
    btCancel: TButton;
    edDurMin: TJvSpinEdit;
    lbDurHour: TLabel;
    lbDurMin: TLabel;
    edDurHour: TJvSpinEdit;
    btJobComment: TBitBtn;
    sbFactStartPrev: TSpeedButton;
    sbFactFinishPlan: TSpeedButton;
    sbClearFactStart: TSpeedButton;
    sbClearFactFinish: TSpeedButton;
    paStart: TPanel;
    imStart: TImage;
    Label1: TLabel;
    dePlanStart: TJvDateEdit;
    edmPlanStart: TMaskEdit;
    udStart: TUpDown;
    sbCurPlanStart: TSpeedButton;
    paFinish: TPanel;
    imFinish: TImage;
    Label2: TLabel;
    dePlanFinish: TJvDateEdit;
    edmPlanFinish: TMaskEdit;
    udFinish: TUpDown;
    sbCurPlanFinish: TSpeedButton;
    colorJob: TAnyColorCombo;
    lbColorJob: TLabel;
    cbAutoSplit: TCheckBox;
    btAdvanced: TBitBtn;
    procedure btOkClick(Sender: TObject);
    procedure sbCurPlanStartClick(Sender: TObject);
    procedure sbCurPlanFinishClick(Sender: TObject);
    procedure sbLockDurClick(Sender: TObject);
    procedure edmPlanStartChange(Sender: TObject);
    procedure dePlanFinishChange(Sender: TObject);
    procedure edmPlanFinishChange(Sender: TObject);
    procedure dePlanStartChange(Sender: TObject);
    //procedure edmFactStartChange(Sender: TObject);
    //procedure deFactFinishChange(Sender: TObject);
    //procedure edmFactFinishChange(Sender: TObject);
    //procedure deFactStartChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edmPlanDurChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure udStartChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure udFinishChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure sbCurFactStartClick(Sender: TObject);
    procedure sbCurFactFinishClick(Sender: TObject);
    {procedure udFactStartChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
    procedure udFactFinishChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);}
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure btJobCommentClick(Sender: TObject);
    procedure sbFactStartPrevClick(Sender: TObject);
    procedure sbFactFinishPlanClick(Sender: TObject);
    procedure sbClearFactStartClick(Sender: TObject);
    procedure sbClearFactFinishClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cbAutoSplitClick(Sender: TObject);
    procedure btAdvancedClick(Sender: TObject);
  private
    FEditMode: TJobEditMode;
    FFinishTime: Variant;
    FStartTime: Variant;
    FLockControls: boolean;
    FFactFinishTime: variant;
    FFactStartTime: variant;
    FFactProductOut, FPlanProductOut: variant;
    FollowingFrame, PrecedingFrame: TRelatedProcessGridFrame;
    FActivated: boolean;
    FJobComment: variant;
    FJobAlert: boolean;
    FPrevFinishTime: TDateTime;
    FShowPlanEmployee: boolean;
    FShowFactProductOut: boolean;
    FReadOnly: boolean;
    FJobColor: TColor;
    FOnEditJobComment: TJobNotifyEvent;
    FOnEditAdvanced: TJobNotifyEvent;
    FJob: TJobParams;
    FShowTime: boolean;
    FAutoSplit, FShowAutoSplit: boolean;
    FSplitMode1, FSplitMode2, FSplitMode3, FSplitPart1, FSplitPart2, FSplitPart3: variant;
    procedure GetFinishTime;
    procedure GetStartTime;
    procedure SetEstimatedDuration(const Value: Integer);
    procedure SetFinishTime(const Value: Variant);
    procedure SetStartTime(const Value: Variant);
    procedure UpdateFinishTime;
    procedure UpdateStartTime;
    procedure UpdateDuration;
    procedure SetEditMode(Value: TJobEditMode);
    function ChangeTime(var AllowChange: boolean; CurTime: TDateTime;
      Direction: TUpDownDirection): TDateTime;
    function CheckPassDateTime(dt: variant; DateControl: TJvDateEdit): Boolean;
    function CheckTimeControl(edm: TMaskEdit): Boolean;
    //procedure GetFactFinishTime;
    //procedure GetFactStartTime;
    procedure SetFactFinishTime(const Value: variant);
    procedure SetFactStartTime(const Value: variant);
    procedure SetExecutor(const Value: variant);
    function GetExecutor: variant;
    procedure SetFactProductOut(const Value: variant);
    function GetFactProductOut: variant;
    function GetFollowingDataSource: TDataSource;
    function GetPrecedingDataSource: TDataSource;
    procedure SetFollowingDataSource(const Value: TDataSource);
    procedure SetPrecedingDataSource(const Value: TDataSource);
    //procedure UpdateFactDuration;
    //procedure UpdateFactFinishTime;
    //procedure UpdateFactStartTime;
    procedure UpdateHeight;
    function AnyStartTime: variant;
    function AnyFinishTime: variant;
    procedure UpdateFactControls;
    procedure SetAutoSplit(Value: boolean);
    procedure SetShowAutoSplit(Value: boolean);
  public
    property EstimatedDuration: Integer write SetEstimatedDuration;
    property EditMode: TJobEditMode read FEditMode write SetEditMode;
    property FinishTime: Variant read FFinishTime write SetFinishTime;
    property StartTime: Variant read FStartTime write SetStartTime;
    property FactFinishTime: variant read FFactFinishTime write SetFactFinishTime;
    property FactStartTime: variant read FFactStartTime write SetFactStartTime;
    property FactProductOut: variant read GetFactProductOut write SetFactProductOut;
    property PlanProductOut: variant read FPlanProductOut write FPlanProductOut;
    property Executor: variant read GetExecutor write SetExecutor;
    property FollowingDataSource: TDataSource read GetFollowingDataSource write
        SetFollowingDataSource;
    property JobComment: variant read FJobComment write FJobComment;
    property JobAlert: boolean read FJobAlert write FJobAlert;
    property JobColor: TColor read FJobColor write FJobColor;
    property PrecedingDataSource: TDataSource read GetPrecedingDataSource write
        SetPrecedingDataSource;
    property AutoSplit: boolean read FAutoSplit write SetAutoSplit;
    property SplitMode1: variant read FSplitMode1 write FSplitMode1;
    property SplitMode2: variant read FSplitMode2 write FSplitMode2;
    property SplitMode3: variant read FSplitMode3 write FSplitMode3;
    property SplitPart1: variant read FSplitPart1 write FSplitPart1;
    property SplitPart2: variant read FSplitPart2 write FSplitPart2;
    property SplitPart3: variant read FSplitPart3 write FSplitPart3;
    // Надо ли показывать галочку авторазбивки
    property ShowAutoSplit: boolean read FShowAutoSplit write SetShowAutoSplit;
    // Время завершения предыдущего процесса
    property PrevFinishTime: TDateTime read FPrevFinishTime write FPrevFinishTime;
    property ShowPlanEmployee: boolean read FShowPlanEmployee write FShowPlanEmployee;
    property ShowFactProductOut: boolean read FShowFactProductOut write FShowFactProductOut;
    property ReadOnly: boolean read FReadOnly write FReadOnly;
    property OnEditJobComment: TJobNotifyEvent read FOnEditJobComment write FOnEditJobComment;
    property OnEditAdvanced: TJobNotifyEvent read FOnEditAdvanced write FOnEditAdvanced;
    property Job: TJobParams read FJob write FJob;
    // Надо ли показывать временнЫе параметры
    property ShowTime: boolean read FShowTime write FShowTime;
  end;

var
  AddToPlanForm: TAddToPlanForm;

  // Просмотр незапланированной работы
function ExecViewNotPlannedForm(Job: TJobParams;
    PrecedingDataSource, FollowingDataSource: TDataSource;
    _OnEditJobComment: TJobNotifyEvent): boolean;

  // добавление работы в план
function ExecAddToPlanForm(Job: TJobParams; PrevFinishTime: TDateTime;
    PrecedingDataSource, FollowingDataSource: TDataSource;
    ShowPlanEmployee: boolean; _OnEditJobComment: TJobNotifyEvent): boolean;

  // добавление работы в план для специальных работ
function ExecAddSpecialToPlanForm(Job: TJobParams; PrevFinishTime: TDateTime;
    _OnEditJobComment: TJobNotifyEvent): boolean;

  // редактирование параметров работы в плане
function ExecEditPlanJobForm(Job: TJobParams; PrevFinishTime: variant;
    PrecedingDataSource, FollowingDataSource: TDataSource;
    ShowPlanEmployee, ReadOnly: boolean;
    _OnEditJobComment, _OnEditAdvanced: TJobNotifyEvent): boolean;

  // редактирование параметров специальной работы в плане
function ExecEditSpecialJobForm(Job: TJobParams; PrevFinishTime: TDateTime;
    ReadOnly: boolean;
    _OnEditJobComment: TJobNotifyEvent): boolean;


implementation

uses TLoggerUnit, DateUtils, RDialogs, StdDic, fEditJobComment, RDBUtils, PlanUtils,
  CalcSettings, PmEntSettings, CalcUtils, PmConfigManager;

{$R *.dfm}

function IsNull(v: variant): boolean;
begin
  Result := VarIsEmpty(v) or VarIsNull(v);
end;

function ExecEditPlanJobFormEx(Job: TJobParams;
    EditMode: TJobEditMode; PrevFinishTime: TDateTime;
    PrecedingDataSource, FollowingDataSource: TDataSource;
    ShowPlanEmployee, ShowFactProductOut, ReadOnly: boolean;
    _OnEditJobComment, _OnEditAdvanced: TJobNotifyEvent; ShowTime: boolean = true): boolean;
begin
  AddToPlanForm := TAddToPlanForm.Create(nil);
  try
    AddToPlanForm.Job := Job;  // Добавлено позже, поэтому присвоения ниже можно было бы перенести и в форму
    AddToPlanForm.OnEditJobComment := _OnEditJobComment;
    AddToPlanForm.OnEditAdvanced := _OnEditAdvanced;

    if IsNull(Job.PlanStart) and not IsNull(Job.FactStart) then
      AddToPlanForm.StartTime := Job.FactStart
    else
      AddToPlanForm.StartTime := Job.PlanStart;

    if IsNull(Job.PlanFinish) and not IsNull(Job.FactFinish) then
      AddToPlanForm.FinishTime := Job.FactFinish
    else
      AddToPlanForm.FinishTime := Job.PlanFinish;

    AddToPlanForm.FactStartTime := Job.FactStart;
    AddToPlanForm.FactFinishTime := Job.FactFinish;

    AddToPlanForm.PrevFinishTime := PrevFinishTime;
    AddToPlanForm.EditMode := EditMode;
    AddToPlanForm.EstimatedDuration := Job.EstimatedDuration;
    AddToPlanForm.FactProductOut := Job.FactProductOut;
    AddToPlanForm.PlanProductOut := Job.ProductOut;
    AddToPlanForm.Executor := Job.Executor;
    AddToPlanForm.JobComment := Job.JobComment;
    AddToPlanForm.JobAlert := Job.JobAlert;
    AddToPlanForm.ShowTime := ShowTime;
    AddToPlanForm.SplitMode1 := Job.SplitMode1;
    AddToPlanForm.SplitMode2 := Job.SplitMode2;
    AddToPlanForm.SplitMode3 := Job.SplitMode3;
    AddToPlanForm.SplitPart1 := Job.SplitPart1;
    AddToPlanForm.SplitPart2 := Job.SplitPart2;
    AddToPlanForm.SplitPart3 := Job.SplitPart3;

    AddToPlanForm.ShowAutoSplit := Job.HasSplit;
    if Job.HasSplit then
      AddToPlanForm.AutoSplit := Job.AutoSplit;

    if VarIsNull(Job.JobColor) then
      AddToPlanForm.JobColor := clWhite
    else
      AddToPlanForm.JobColor := TColor(Job.JobColor);

    AddToPlanForm.PrecedingDataSource := PrecedingDataSource;
    AddToPlanForm.FollowingDataSource := FollowingDataSource;

    AddToPlanForm.ShowPlanEmployee := ShowPlanEmployee;
    AddToPlanForm.ShowFactProductOut := ShowFactProductOut;
    AddToPlanForm.ReadOnly := ReadOnly;

    Result := AddToPlanForm.ShowModal = mrOk;
    if Result then
    begin
      if not PlanUtils.EqualDates(Job.PlanStart, AddToPlanForm.StartTime) then
        Job.PlanStart := AddToPlanForm.StartTime;
      if not PlanUtils.EqualDates(Job.PlanFinish, AddToPlanForm.FinishTime) then
        Job.PlanFinish := AddToPlanForm.FinishTime;
      if not PlanUtils.EqualDates(Job.FactStart, AddToPlanForm.FactStartTime) then
        Job.FactStart := AddToPlanForm.FactStartTime;
      if not PlanUtils.EqualDates(Job.FactFinish, AddToPlanForm.FactFinishTime) then
        Job.FactFinish := AddToPlanForm.FactFinishTime;
      if Job.FactProductOut <> AddToPlanForm.FactProductOut then
        Job.FactProductOut := AddToPlanForm.FactProductOut;
      if Job.Executor <> AddToPlanForm.Executor then
        Job.Executor := AddToPlanForm.Executor;
      if Job.JobComment <> AddToPlanForm.JobComment then
        Job.JobComment := AddToPlanForm.JobComment;
      if Job.JobAlert <> AddToPlanForm.JobAlert then
        Job.JobAlert := AddToPlanForm.JobAlert;
      if Job.JobColor <> AddToPlanForm.JobColor then
        Job.JobColor := AddToPlanForm.JobColor;
      if Job.HasSplit then
        if Job.AutoSplit <> AddToPlanForm.AutoSplit then
          Job.AutoSplit := AddToPlanForm.AutoSplit;
      if Job.SplitMode1 <> AddToPlanForm.SplitMode1 then
        Job.SplitMode1 := AddToPlanForm.SplitMode1;
      if Job.SplitMode2 <> AddToPlanForm.SplitMode2 then
        Job.SplitMode2 := AddToPlanForm.SplitMode2;
      if Job.SplitMode3 <> AddToPlanForm.SplitMode3 then
        Job.SplitMode3 := AddToPlanForm.SplitMode3;
      if Job.SplitPart1 <> AddToPlanForm.SplitPart1 then
        Job.SplitPart1 := AddToPlanForm.SplitPart1;
      if Job.SplitPart2 <> AddToPlanForm.SplitPart2 then
        Job.SplitPart2 := AddToPlanForm.SplitPart2;
      if Job.SplitPart3 <> AddToPlanForm.SplitPart3 then
        Job.SplitPart3 := AddToPlanForm.SplitPart3;
    end;
  finally
    AddToPlanForm.Free;
  end;
end;

// добавление работы в план
function ExecAddToPlanForm(Job: TJobParams; PrevFinishTime: TDateTime;
  PrecedingDataSource, FollowingDataSource: TDataSource;
  ShowPlanEmployee: boolean; _OnEditJobComment: TJobNotifyEvent): boolean;
begin
  Result := ExecEditPlanJobFormEx(Job, jemNew, PrevFinishTime,
    PrecedingDataSource, FollowingDataSource, ShowPlanEmployee, true, false {not ReadOnly},
    _OnEditJobComment, nil);
end;

// добавление работы в план для специальных работ
function ExecAddSpecialToPlanForm(Job: TJobParams; PrevFinishTime: TDateTime;
  _OnEditJobComment: TJobNotifyEvent): boolean;
begin
  Result := ExecEditPlanJobFormEx(Job, jemNew, PrevFinishTime, nil, nil, false,
    false, false {not ReadOnly}, _OnEditJobComment, nil);
end;

function ExecEditPlanJobForm(Job: TJobParams; PrevFinishTime: variant;
    PrecedingDataSource, FollowingDataSource: TDataSource;
    ShowPlanEmployee, ReadOnly: boolean;
    _OnEditJobComment, _OnEditAdvanced: TJobNotifyEvent): boolean;
begin
  Result := ExecEditPlanJobFormEx(Job, jemEdit, PrevFinishTime,
    PrecedingDataSource, FollowingDataSource, ShowPlanEmployee, true, ReadOnly,
    _OnEditJobComment, _OnEditAdvanced);
end;

// редактирование параметров специальной работы в плане
function ExecEditSpecialJobForm(Job: TJobParams; PrevFinishTime: TDateTime;
  ReadOnly: boolean;
  _OnEditJobComment: TJobNotifyEvent): boolean;
begin
  Result := ExecEditPlanJobFormEx(Job, jemEdit, PrevFinishTime, nil, nil, false,
    false, ReadOnly, _OnEditJobComment, nil);
end;

  // Просмотр незапланированной работы
function ExecViewNotPlannedForm(Job: TJobParams;
    PrecedingDataSource, FollowingDataSource: TDataSource;
    _OnEditJobComment: TJobNotifyEvent): boolean;
begin
  Result := ExecEditPlanJobFormEx(Job, jemView, 0, PrecedingDataSource, FollowingDataSource,
    false, false, true, _OnEditJobComment, nil, false);
end;

procedure TAddToPlanForm.btOkClick(Sender: TObject);
begin
  if not CheckTimeControl(edmPlanStart)
    or not CheckTimeControl(edmPlanFinish)
    or (not IsNull(FactStartTime) and not CheckPassDateTime(FactStartTime, dePlanStart))
    or (not IsNull(FactFinishTime) and not CheckPassDateTime(FactFinishTime, dePlanFinish)) then
    ModalResult := mrNone;
end;

procedure TAddToPlanForm.cbAutoSplitClick(Sender: TObject);
begin
  FAutoSplit := cbAutoSplit.Checked;
end;

procedure TAddToPlanForm.sbCurPlanStartClick(Sender: TObject);
begin
  StartTime := TruncSeconds(Now);
  UpdateDuration;
end;

procedure TAddToPlanForm.sbCurPlanFinishClick(Sender: TObject);
begin
  FinishTime := TruncSeconds(Now);
  UpdateDuration;
end;

procedure TAddToPlanForm.sbLockDurClick(Sender: TObject);
var
  DurRO: boolean;
begin
  DurRO := not sbLockDur.Down;
  edDurHour.ReadOnly := DurRO;
  edDurMin.ReadOnly := DurRO;
  if DurRO then
  begin
    edDurHour.Color := clBtnFace;
    edDurMin.Color := clBtnFace;
    edmPlanFinish.Color := clWindow;
    dePlanFinish.Color := clWindow;
  end
  else
  begin
    edDurHour.Color := clWindow;
    edDurMin.Color := clWindow;
    edmPlanFinish.Color := clBtnFace;
    dePlanFinish.Color := clBtnFace;
  end;
  dePlanFinish.ReadOnly := sbLockDur.Down;
  edmPlanFinish.ReadOnly := sbLockDur.Down;
  sbCurPlanFinish.Enabled := not sbLockDur.Down;
  udFinish.Enabled := not sbLockDur.Down;
  UpdateDuration;
end;

procedure TAddToPlanForm.UpdateDuration;
var
  CheckTime: TDateTime;
  m: integer;
  Day, Hour, Minute, Sec: word;
begin
  if FLockControls then Exit;

  if not IsNull(AnyStartTime) and not IsNull(AnyFinishTime) then
  begin
    if sbLockDur.Down then
    begin
      // расчет конечной даты-времени
      try
        Hour := edDurHour.AsInteger;
        Day := Hour div 24;
        Hour := Hour mod 24;
        CheckTime := EncodeTime(Hour, edDurMin.AsInteger, 0, 0);
        //CheckTime := StrToTime(edmPlanDur.Text);
        FinishTime := AnyStartTime + CheckTime;
        FinishTime := IncDay(AnyFinishTime, Day);
        btOk.Enabled := not FReadOnly;
      except
        btOk.Enabled := false;
      end;
    end
    else
    begin
      // расчет длительности
      //edmDur.Enabled := false;
      try
        CheckTime := AnyStartTime;
        ReplaceTime(CheckTime, StrToTime(edmPlanStart.Text));
        if CheckTime > AnyFinishTime then
          raise Exception.Create('')
        else
          StartTime := CheckTime;
        //m := Round(MinuteSpan(StartTime, FinishTime));
        //edmPlanDur.Text := FormatTimeValue(m);
        //TLogger.GetInstance.Info('SecondsBetween = ' + VarToStr(SecondsBetween(StartTime, FinishTime)));
        edDurHour.AsInteger := RoundMinutesBetween(AnyStartTime, AnyFinishTime) div 60;
        edDurMin.AsInteger := RoundMinutesBetween(AnyStartTime, AnyFinishTime) mod 60;
        btOk.Enabled := not FReadOnly;
      except
        btOk.Enabled := false;
      end;
    end;
  end;
end;

procedure TAddToPlanForm.SetFinishTime(const Value: Variant);
begin
  if not IsNull(FFactFinishTime) then
    FFactFinishTime := Value
  else
    FFinishTime := Value;
  UpdateFinishTime;
end;

procedure TAddToPlanForm.SetStartTime(const Value: Variant);
begin
  if not IsNull(FFactStartTime) then
    FFactStartTime := Value
  else
    FStartTime := Value;
  UpdateStartTime;
end;

procedure TAddToPlanForm.UpdateFactControls;
var
  FS, FF: boolean;
const
  FactDateColor = $DDFFDD;
begin
  FS := not IsNull(FactStartTime);
  FF := not IsNull(FactFinishTime);
  sbClearFactStart.Enabled := FS and not FF and not FReadOnly;
  sbClearFactFinish.Enabled := FF and not FReadOnly;
  sbCurFactFinish.Enabled := FS and not FReadOnly;
  sbFactFinishPlan.Enabled := FS and not FReadOnly;
  sbCurPlanStart.Enabled := not FS and not FReadOnly;
  sbCurPlanFinish.Enabled := not FF and not FReadOnly;
  sbCurFactStart.Enabled := not FReadOnly;
  sbFactStartPrev.Enabled := not FReadOnly;
  if FS then
    paStart.Color := FactDateColor
  else
    paStart.Color := clBtnFace;
  if FF then
    paFinish.Color := FactDateColor
  else
    paFinish.Color := clBtnFace;
  imStart.Visible := FS and not FF;
  imFinish.Visible := FF;
  lbFactProductOut.Visible := FF and FShowFactProductOut;
  edFactProductOut.Visible := FF and FShowFactProductOut;
  edFactProductOut.Enabled := not FReadOnly;
  cbExecutor.Visible := FS or FShowPlanEmployee;
  cbExecutor.Enabled := not FReadOnly;
  lbExecutor.Visible := FS or FShowPlanEmployee;
end;

procedure TAddToPlanForm.UpdateFinishTime;
begin
  if FLockControls then Exit;

  FLockControls := true;
  try
    if not IsNull(AnyFinishTime) then
    begin
      dePlanFinish.Date := AnyFinishTime;
      edmPlanFinish.Text := FormatDateTime('h:nn', AnyFinishTime);
    end
    else
    begin
      dePlanFinish.Clear;
      edmPlanFinish.Clear;
    end;
    UpdateFactControls;
  finally
    FLockControls := false;
  end;
end;

procedure TAddToPlanForm.UpdateStartTime;
begin
  if FLockControls then Exit;

  FLockControls := true;
  try
    if not IsNull(AnyStartTime) then
    begin
      dePlanStart.Date := AnyStartTime;
      edmPlanStart.Text := FormatDateTime('h:nn', AnyStartTime);
    end
    else
    begin
      dePlanStart.Clear;
      edmPlanStart.Clear;
    end;
    UpdateFactControls;
  finally
    FLockControls := false;
  end;
end;

procedure TAddToPlanForm.dePlanFinishChange(Sender: TObject);
begin
  GetFinishTime;
  UpdateDuration;
end;

procedure TAddToPlanForm.edmPlanFinishChange(Sender: TObject);
begin
  GetFinishTime;
  UpdateDuration;
end;

procedure TAddToPlanForm.dePlanStartChange(Sender: TObject);
begin
  GetStartTime;
  UpdateDuration;
end;

procedure TAddToPlanForm.edmPlanStartChange(Sender: TObject);
begin
  GetStartTime;
  UpdateDuration;
end;

procedure TAddToPlanForm.FormShow(Sender: TObject);
begin
  sbLockDurClick(Sender);
  //UpdateFactDuration;
end;

procedure TAddToPlanForm.GetFinishTime;
var
  CheckTime: TDateTime;
begin
  if FLockControls then Exit;
  try
    CheckTime := dePlanFinish.Date;
    ReplaceTime(CheckTime, StrToTime(edmPlanFinish.Text));
    // Если уже завершен, то меняем фактическую дату
    if not IsNull(FFactFinishTime) then
      FFactFinishTime := CheckTime
    else
      FFinishTime := CheckTime;
  except end;
end;

procedure TAddToPlanForm.GetStartTime;
var
  CheckTime: TDateTime;
begin
  if FLockControls then Exit;
  try
    CheckTime := dePlanStart.Date;
    ReplaceTime(CheckTime, StrToTime(edmPlanStart.Text));
    // Если уже начат, то меняем фактическую дату
    if not IsNull(FFactStartTime) then
      FFactStartTime := CheckTime
    else
      FStartTime := CheckTime;
  except end;
end;

procedure TAddToPlanForm.SetEstimatedDuration(const Value: Integer);
begin
  lbEstimatedDuration.Caption := FormatTimeValue(Value);
end;

procedure TAddToPlanForm.SetEditMode(Value: TJobEditMode);
begin
  FEditMode := Value;
  if FEditMode = jemEdit then
  begin
    //Caption := 'Изменение плана';
    btOk.Caption := 'Сохранить';
  end
  else
  if FEditMode = jemView then
  begin
    btOk.Visible := false;
    btCancel.Caption := 'Закрыть';
  end;
end;

procedure TAddToPlanForm.FormCreate(Sender: TObject);
begin
  TSettingsManager.Instance.XPInitComponent(Self);

  //sbLockDur.Down := true;
  dsEmployees.DataSet := TConfigManager.Instance.StandardDics.deEmployees.DicItems;
  dsEmployees.DataSet.Filter := 'Visible';
  dsEmployees.DataSet.Filtered := true;

  // При закрытии восстанавливаем

  PrecedingFrame := TRelatedProcessGridFrame.Create(Self);
  PrecedingFrame.Parent := Self;
  PrecedingFrame.Align := alTop;
  PrecedingFrame.Top := paPreceding.Top + 10;
  PrecedingFrame.Name := 'framePreceding';
  PrecedingFrame.ShowProcessState := true;
  PrecedingFrame.ShowPartName := true;
  PrecedingFrame.ShowOrderDate := false;

  FollowingFrame := TRelatedProcessGridFrame.Create(Self);
  FollowingFrame.Parent := Self;
  FollowingFrame.Align := alTop;
  FollowingFrame.Top := paFollowing.Top + 10;
  FollowingFrame.Name := 'frameFollowing';
  FollowingFrame.ShowProcessState := true;
  FollowingFrame.ShowPartName := true;
  FollowingFrame.ShowOrderDate := false;
end;

procedure TAddToPlanForm.udStartChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
var
  NewTime: TDateTime;
begin
  NewTime := ChangeTime(AllowChange, AnyStartTime, Direction);
  if AllowChange then
  begin
    SetStartTime(NewTime);
    UpdateDuration;
  end;
end;

procedure TAddToPlanForm.udFinishChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
var
  NewTime: TDateTime;
begin
  NewTime := ChangeTime(AllowChange, AnyFinishTime, Direction);
  begin
    if AllowChange then
    begin
      SetFinishTime(NewTime);
      UpdateDuration;
    end;
  end;
end;

const
  TIME_STEP = 15;  // minutes

function TAddToPlanForm.ChangeTime(var AllowChange: boolean; CurTime: TDateTime;
  Direction: TUpDownDirection): TDateTime;
var
  {LimitTime, }NewStartTime: TDateTime;
  Hour, Min, Sec, MSec: word;
  MinNew: integer;
begin
  //LimitTime := CurTime;
  AllowChange := true;
  DecodeTime(CurTime, Hour, Min, Sec, MSec);
    if Direction = updUp then
    begin
      //ReplaceTime(LimitTime, EncodeTime(23, 59, 59, 999));
      NewStartTime := IncMinute(CurTime, ((Min div TIME_STEP) + 1) * TIME_STEP - Min);
      //AllowChange := LimitTime > CurTime;
    end
    else
    begin
      //ReplaceTime(LimitTime, EncodeTime(0, 00, 00, 0));
      if Min mod TIME_STEP = 0 then
        NewStartTime := IncMinute(CurTime, -TIME_STEP)
      else //if Min < TIME_STEP then
      begin
        MinNew := -(Min mod TIME_STEP);
        NewStartTime := IncMinute(CurTime, MinNew);
      end;
      //AllowChange := LimitTime < CurTime;
    end;
  Result := NewStartTime;
end;

procedure TAddToPlanForm.sbCurFactStartClick(Sender: TObject);
begin
  FactStartTime := TruncSeconds(Now);
  UpdateDuration;
end;

procedure TAddToPlanForm.sbCurFactFinishClick(Sender: TObject);
begin
  if sbLockDur.Down then
    sbLockDur.Down := false;

  FactFinishTime := TruncSeconds(Now);
  UpdateDuration;
end;

{procedure TAddToPlanForm.GetFactStartTime;
var
  CheckTime: TDateTime;
begin
  if FLockControls then Exit;
  try
    CheckTime := deFactStart.Date;
    ReplaceTime(CheckTime, StrToTime(edmFactStart.Text));
    FFactStartTime := CheckTime;
  except end;
end;}

{procedure TAddToPlanForm.GetFactFinishTime;
var
  CheckTime: TDateTime;
begin
  if FLockControls then Exit;
  try
    CheckTime := deFactFinish.Date;
    ReplaceTime(CheckTime, StrToTime(edmFactFinish.Text));
    FFactFinishTime := CheckTime;
  except end;
end;}

{procedure TAddToPlanForm.UpdateFactFinishTime;
begin
  if FLockControls then Exit;
  if not VarIsEmpty(FFactFinishTime) and not VarIsNull(FFactFinishTime) then
  begin
    FLockControls := true;
    try
      deFactFinish.Date := FFactFinishTime;
      edmFactFinish.Text := FormatDateTime('h:nn', FFactFinishTime);
    finally
      FLockControls := false;
    end;
  end
  else
  begin
    FLockControls := true;
    try
      deFactFinish.Clear;
      edmFactFinish.Clear;
    finally
      FLockControls := false;
    end;
  end;
end; }

{procedure TAddToPlanForm.UpdateFactStartTime;
begin
  if FLockControls then Exit;
  if not VarIsEmpty(FFactStartTime) and not VarIsNull(FFactStartTime) then
  begin
    FLockControls := true;
    try
      deFactStart.Date := FFactStartTime;
      edmFactStart.Text := FormatDateTime('h:nn', FFactStartTime);
    finally
      FLockControls := false;
    end;
  end
  else
  begin
    FLockControls := true;
    try
      deFactStart.Clear;
      edmFactStart.Clear;
    finally
      FLockControls := false;
    end;
  end;
end;}

(*procedure TAddToPlanForm.UpdateFactDuration;
var
  CheckTime: TDateTime;
  m: integer;
begin
  // расчет длительности
  // try
  //  CheckTime := FactStartTime;
  //  ReplaceTime(CheckTime, StrToTime(edmFactStart.Text));
    {if CheckTime > FactFinishTime then
      raise Exception.Create('')
    else}
  //    FactStartTime := CheckTime;
    // не помню почему написал тут VarIsEmpty, но VarIsNull надо обязательно!
    if not VarIsEmpty(FFactStartTime) and not VarIsEmpty(FFactFinishTime)
      and not VarIsNull(FFactStartTime) and not VarIsNull(FFactFinishTime) then
    begin
      m := Round(MinuteSpan(FactStartTime, FactFinishTime));
      lbFactDuration.Caption := FormatTimeValue(m);
      lbFactDuration.Visible := true;
      lbFactDurationText.Visible := true;
      // Для спец работ невидимы
      lbFactProductOut.Visible := PrecedingFrame.Visible;
      edFactProductOut.Visible := PrecedingFrame.Visible;
    end
    else
    begin
      lbFactDuration.Visible := false;
      lbFactDurationText.Visible := false;
      lbFactProductOut.Visible := false;
      edFactProductOut.Visible := false;
    end;
   // btOk.Enabled := true;
  // except
  //  btOk.Enabled := false;
  // end;
end; *)

procedure TAddToPlanForm.SetFactFinishTime(const Value: variant);
begin
  FFactFinishTime := Value;
  UpdateFinishTime;
end;

procedure TAddToPlanForm.SetFactStartTime(const Value: variant);
begin
  FFactStartTime := Value;
  UpdateStartTime;
end;

{procedure TAddToPlanForm.udFactStartChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
var
  NewTime: TDateTime;
begin
  NewTime := ChangeTime(AllowChange, FFactStartTime, Direction);
  if AllowChange then
  begin
    SetFactStartTime(NewTime);
    UpdateFactDuration;
  end;
end;}

{procedure TAddToPlanForm.udFactFinishChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
var
  NewTime: TDateTime;
begin
  NewTime := ChangeTime(AllowChange, FFactFinishTime, Direction);
  begin
    if AllowChange then
    begin
      SetFactFinishTime(NewTime);
      UpdateFactDuration;
    end;
  end;
end;}

procedure TAddToPlanForm.SetExecutor(const Value: variant);
begin
  cbExecutor.KeyValue := Value;
end;

function TAddToPlanForm.GetExecutor: variant;
begin
  Result := cbExecutor.KeyValue;
end;

procedure TAddToPlanForm.SetFactProductOut(const Value: variant);
begin
  FFactProductOut := Value;
  if not IsNull(Value) then
  begin
    if Value = -1 then
      edFactProductOut.Visible := false
    else
      edFactProductOut.Text := IntToStr(Value);
  end;
end;

function TAddToPlanForm.GetFactProductOut: variant;
begin
  if edFactProductOut.Visible then
  begin
    try
      FFactProductOut := StrToInt(edFactProductOut.Text);
    except
      FFactProductOut := null;
    end;
  end;
  Result := FFactProductOut;
end;

procedure TAddToPlanForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FJobColor := colorJob.ColorValue;
  //dsEmployees.DataSet.Filtered := false;
  // При создании устанавливаем
end;

procedure TAddToPlanForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // проверяем, надо ли обязательно указывать фактич. выработку
  CanClose := ModalResult <> mrOk;
  if not CanClose then
  begin
    if EntSettings.RequireFactProductOut and not VarIsNull(FactFinishTime) then
      CanClose := not VarIsNull(GetFactProductOut)
    else
      CanClose := true;
  end;
  if not CanClose then
    RusMessageDlg('Не указана фактическая выработка', mtError, [mbOk], 0);
end;

{procedure TAddToPlanForm.deFactFinishChange(Sender: TObject);
begin
  GetFactFinishTime;
  UpdateFactDuration;
end;}

{procedure TAddToPlanForm.edmFactFinishChange(Sender: TObject);
begin
  GetFactFinishTime;
  UpdateFactDuration;
end;}

{procedure TAddToPlanForm.deFactStartChange(Sender: TObject);
begin
  GetFactStartTime;
  UpdateFactDuration;
end;}

{procedure TAddToPlanForm.edmFactStartChange(Sender: TObject);
begin
  GetFactStartTime;
  UpdateFactDuration;
end;}

function TAddToPlanForm.GetFollowingDataSource: TDataSource;
begin
  Result := FollowingFrame.DBGrid.DataSource;
end;

function TAddToPlanForm.GetPrecedingDataSource: TDataSource;
begin
  Result := PrecedingFrame.DBGrid.DataSource;
end;

procedure TAddToPlanForm.SetFollowingDataSource(const Value: TDataSource);
begin
  if Value <> nil then
  begin
    FollowingFrame.DBGrid.DataSource := Value;
    FollowingFrame.UpdateHeight;
  end
  else
  begin
    FollowingFrame.Visible := false;
    paFollowing.Visible := false;
  end;
  UpdateHeight;
end;

procedure TAddToPlanForm.SetPrecedingDataSource(const Value: TDataSource);
begin
  if Value <> nil then
  begin
    PrecedingFrame.DBGrid.DataSource := Value;
    PrecedingFrame.UpdateHeight;
  end
  else
  begin
    PrecedingFrame.Visible := false;
    paPreceding.Visible := false;
  end;
  UpdateHeight;
end;

procedure TAddToPlanForm.UpdateHeight;
begin
  if ShowTime then
    ClientHeight := paDates.Height + paButtons.Height
  else
    ClientHeight := paButtons.Height;

  if PrecedingFrame.Visible then
    ClientHeight := ClientHeight + paPreceding.Height + PrecedingFrame.Height
        + paFollowing.Height + FollowingFrame.Height;
end;

procedure TAddToPlanForm.FormActivate(Sender: TObject);
begin
  if not FActivated then
  begin
    cbExecutor.Visible := FShowPlanEmployee;
    lbExecutor.Visible := FShowPlanEmployee;
    FActivated := true;
    sbLockDur.Down := true;
    sbLockDurClick(Sender);
    colorJob.ColorValue := JobColor;
    colorJob.Visible := not EntSettings.JobColorByExecState;
    lbColorJob.Visible := colorJob.Visible;
    paDates.Visible := ShowTime;
    btAdvanced.Visible := Assigned(FOnEditAdvanced);
    if paDates.Visible then
      ActiveControl := dePlanStart
    else if btOk.Visible then
      ActiveControl := btOk
    else
      ActiveControl := btCancel;
  end;
end;

procedure TAddToPlanForm.btAdvancedClick(Sender: TObject);
var
  JobCopy: TJobParams;
begin
  if Assigned(FOnEditAdvanced) then
  begin
    JobCopy := FJob.Copy;
    try
      if FOnEditAdvanced(JobCopy) then
      begin
        FSplitMode1 := JobCopy.SplitMode1;
        FSplitMode2 := JobCopy.SplitMode2;
        FSplitMode3 := JobCopy.SplitMode3;
        FSplitPart1 := JobCopy.SplitPart1;
        FSplitPart2 := JobCopy.SplitPart2;
        FSplitPart3 := JobCopy.SplitPart3;
      end;
    finally
      JobCopy.Free;
    end;
  end;
end;

procedure TAddToPlanForm.btJobCommentClick(Sender: TObject);
var
  JobCopy: TJobParams;
begin
  JobCopy := FJob.Copy;
  JobCopy.JobComment := FJobComment;
  JobCopy.JobAlert := FJobAlert;
  JobCopy.ClearChanges;
  try
    if FOnEditJobComment(JobCopy) and (JobCopy.JobCommentSet or JobCopy.JobAlertSet) then
    begin
      FJobComment := JobCopy.JobComment;
      FJobAlert := JobCopy.JobAlert;
    end;
  finally
    JobCopy.Free;
  end;
end;

// Проверяет что фактические даты не установлены наперед, т.е. больше текущего
// времени. ВРЕМЯ ЛОКАЛЬНОЕ!! возможно лучше брать с сервера
function TAddToPlanForm.CheckPassDateTime(dt: variant; DateControl: TJvDateEdit): Boolean;
begin
  if not IsNull(dt) and (dt > TruncSeconds(Now)) then
  begin
    ActiveControl := DateControl;
    RusMessageDlg('Фактическое время начала или завершения работы не может опережать текущее', mtError, [mbOk], 0);
    Result := false;
  end
  else
    Result := true;
end;

// Проверяет корректность времени в текстовом поле
function TAddToPlanForm.CheckTimeControl(edm: TMaskEdit): Boolean;
var CheckTime: TDateTime;
begin
  try
    CheckTime := StrToTime(edm.Text);
    Result := true;
  except
    ActiveControl := edm;
    RusMessageDlg('Некорректное значение времени', mtError, [mbOk], 0);
    Result := false;
  end;
end;

procedure TAddToPlanForm.sbFactStartPrevClick(Sender: TObject);
begin
  FactStartTime := FPrevFinishTime;
  UpdateDuration;
end;

procedure TAddToPlanForm.sbFactFinishPlanClick(Sender: TObject);
begin
  // Если указано фактическое начало, то добавляем плановую длительность
  if not IsNull(FFactStartTime) then
    FactFinishTime := FFactStartTime + (FFinishTime - FStartTime)
  else
    // иначе просто устанавливаем фактическое окончание в плановое
    FactFinishTime := FinishTime;
  // Если не обязательно вводить фактич. выработку, то ставим плановую по умолчанию
  if EntSettings.RequireFactProductOut and VarIsNull(FactProductOut) then
    FactProductOut := PlanProductOut;
  UpdateDuration;
end;

procedure TAddToPlanForm.sbClearFactStartClick(Sender: TObject);
begin
  FactStartTime := null;
  UpdateDuration;
end;

procedure TAddToPlanForm.sbClearFactFinishClick(Sender: TObject);
begin
  FactFinishTime := null;
  UpdateDuration;
end;

function TAddToPlanForm.AnyStartTime: variant;
begin
  if IsNull(FFactStartTime) then
    Result := FStartTime
  else
    Result := FFactStartTime;
end;

function TAddToPlanForm.AnyFinishTime: variant;
begin
  if IsNull(FFactFinishTime) then
    Result := FFinishTime
  else
    Result := FFactFinishTime;
end;

procedure TAddToPlanForm.edmPlanDurChange(Sender: TObject);
begin
  UpdateDuration;
end;

procedure TAddToPlanForm.SetAutoSplit(Value: boolean);
begin
  FAutoSplit := Value;
  cbAutoSplit.Checked := FAutoSplit;
end;

procedure TAddToPlanForm.SetShowAutoSplit(Value: boolean);
begin
  FShowAutoSplit := Value;
  cbAutoSplit.Visible := FShowAutoSplit;
end;

end.
