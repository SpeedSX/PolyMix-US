unit PmJobParams;

interface

uses Classes, SysUtils, RDBUtils;

type
  // вид разбивки - тираж, лист, сторона
  TSplitMode = (smQuantity, smMultiplier, smSide);

  // параметры работы. Используется при планировании. Не содержит BL
  TJobParams = class
  private
    FIsNew: boolean;
    FJobID: variant;
    FItemID: variant;
    FEquipCode: Variant;
    FEquipCodeSet: Boolean;
    FEstimatedDuration: Integer;
    FEstimatedDurationSet: Boolean;
    FExecutor: Variant;
    FExecutorSet: Boolean;
    FFactFinish: Variant;
    FFactFinishSet: Boolean;
    FFactStart: Variant;
    FJobComment: Variant;
    FJobAlert: boolean;
    FPlanFinish: Variant;
    FPlanStart: Variant;
    FFactProductOut: Variant;
    FFactProductOutSet: Boolean;
    FFactStartSet: Boolean;
    FJobCommentSet: Boolean;
    FJobAlertSet: Boolean;
    FPlanFinishSet: Boolean;
    FPlanStartSet: Boolean;
    FSplitMode1: variant;
    FSplitMode1Set: Boolean;
    FSplitMode2: variant;
    FSplitMode2Set: Boolean;
    FSplitMode3: variant;
    FSplitMode3Set: Boolean;
    FSplitPart1: variant;
    FSplitPart1Set: Boolean;
    FSplitPart2: variant;
    FSplitPart2Set: Boolean;
    FSplitPart3: variant;
    FSplitPart3Set: Boolean;
    FTimeLocked: Boolean;
    FTimeLockedSet: Boolean;
    FJobType: integer;
    FItemDesc: string;
    FComment: string;
    FCustomerName: string;
    FOrderNumber: string;
    FOrderState: integer;
    FAutoSplit: boolean;
    FAutoSplitSet: boolean;
    FProductOut: variant;
    FMultiplier: extended;
    FSideCount: variant;
    FPart: integer;
    FPartName: string;
    FItemProductOut: integer;
    FIsPaused: boolean;
    FIsPausedSet: boolean;
    FExecState: integer;
    FOrderID: variant;
    FJobColor: variant;
    FJobColorSet: boolean;
    FOverlapShift: boolean;
    FJobCost: extended;
    function GetAnyFinish: TDateTime;
    function GetAnyStart: TDateTime;
    procedure SetEquipCode(const Value: Variant);
    procedure SetEstimatedDuration(const Value: Integer);
    procedure SetExecutor(const Value: Variant);
    procedure SetFactFinish(const Value: Variant);
    procedure SetFactStart(const Value: Variant);
    procedure SetJobComment(const Value: Variant);
    procedure SetJobAlert(const Value: Boolean);
    procedure SetPlanFinish(const Value: Variant);
    procedure SetPlanStart(const Value: Variant);
    procedure SetFactProductOut(const Value: Variant);
    procedure SetSplitMode1(const Value: variant);
    procedure SetSplitMode2(const Value: variant);
    procedure SetSplitMode3(const Value: variant);
    procedure SetSplitPart1(const Value: variant);
    procedure SetSplitPart2(const Value: variant);
    procedure SetSplitPart3(const Value: variant);
    procedure SetTimeLocked(const Value: boolean);
    procedure SetAutoSplit(const Value: boolean);
    procedure SetIsPaused(const Value: boolean);
    procedure SetJobColor(const Value: variant);
  public
    constructor Create;
    property IsNew: boolean read FIsNew write FIsNew; 
    property AnyFinish: TDateTime read GetAnyFinish;
    property AnyStart: TDateTime read GetAnyStart;
    property EquipCode: Variant read FEquipCode write SetEquipCode;
    property EquipCodeSet: Boolean read FEquipCodeSet;
    property EstimatedDuration: Integer read FEstimatedDuration write
        SetEstimatedDuration;
    property EstimatedDurationSet: Boolean read FEstimatedDurationSet;
    property Executor: Variant read FExecutor write SetExecutor;
    property ExecutorSet: Boolean read FExecutorSet;
    property FactFinish: Variant read FFactFinish write SetFactFinish;
    property FactFinishSet: Boolean read FFactFinishSet;
    property FactStart: Variant read FFactStart write SetFactStart;
    property JobComment: Variant read FJobComment write SetJobComment;
    property JobAlert: Boolean read FJobAlert write SetJobAlert;
    property PlanFinish: Variant read FPlanFinish write SetPlanFinish;
    property PlanStart: Variant read FPlanStart write SetPlanStart;
    property FactProductOut: Variant read FFactProductOut write SetFactProductOut;
    property FactProductOutSet: Boolean read FFactProductOutSet;
    property FactStartSet: Boolean read FFactStartSet;
    property JobCommentSet: Boolean read FJobCommentSet;
    property JobAlertSet: Boolean read FJobAlertSet;
    property PlanFinishSet: Boolean read FPlanFinishSet;
    property PlanStartSet: Boolean read FPlanStartSet;
    property SplitMode1: variant read FSplitMode1 write SetSplitMode1;
    property SplitMode1Set: Boolean read FSplitMode1Set;
    property SplitMode2: variant read FSplitMode2 write SetSplitMode2;
    property SplitMode2Set: Boolean read FSplitMode2Set;
    property SplitMode3: variant read FSplitMode3 write SetSplitMode3;
    property SplitMode3Set: Boolean read FSplitMode3Set;
    property SplitPart1: variant read FSplitPart1 write SetSplitPart1;
    property SplitPart1Set: Boolean read FSplitPart1Set;
    property SplitPart2: variant read FSplitPart2 write SetSplitPart2;
    property SplitPart2Set: Boolean read FSplitPart2Set;
    property SplitPart3: variant read FSplitPart3 write SetSplitPart3;
    property SplitPart3Set: Boolean read FSplitPart3Set;
    property TimeLocked: Boolean read FTimeLocked write SetTimeLocked;
    property TimeLockedSet: Boolean read FTimeLockedSet;
    property AutoSplit: Boolean read FAutoSplit write SetAutoSplit;
    property AutoSplitSet: Boolean read FAutoSplitSet;
    property IsPaused: Boolean read FIsPaused write SetIsPaused;
    property IsPausedSet: Boolean read FIsPausedSet;
    property JobColor: variant read FJobColor write SetJobColor;
    property JobColorSet: Boolean read FJobColorSet;
    // перекрывается ли со сменой
    property OverlapShift: boolean read FOverlapShift write FOverlapShift;
    property JobCost: extended read FJobCost write FJobCost;

    // Другие параметры процесса и заказа
    property JobID: variant read FJobID write FJobID;  // ключевое поле работы
    property ItemID: variant read FItemID write FItemID;  // ключевое поле процесса
    property JobType: integer read FJobType write FJobType;
    property ItemDesc: string read FItemDesc write FItemDesc;
    property Comment: string read FComment write FComment;
    property CustomerName: string read FCustomerName write FCustomerName;
    property OrderNumber: string read FOrderNumber write FOrderNumber;
    property OrderState: integer read FOrderState write FOrderState;
    property ProductOut: variant read FProductOut write FProductOut;
    property Multiplier: extended read FMultiplier write FMultiplier;
    property SideCount: variant read FSideCount write FSideCount;
    property Part: integer read FPart write FPart;
    property PartName: string read FPartName write FPartName;
    property ItemProductOut: integer read FItemProductOut write FItemProductOut;
    property ExecState: integer read FExecState write FExecState;
    property OrderID: variant read FOrderID write FOrderID;

    procedure ClearChanges;
    function DatesChanged: boolean;
    function Changed: boolean;
    function HasSplitMode(SplitMode: TSplitMode): boolean;
    function ItemHasSplitMode(SplitMode: TSplitMode): boolean;
    function GetSplitPart(SplitMode: TSplitMode): integer;
    function HasSplit: boolean;
    function Copy: TJobParams;
    function ExactCopy: TJobParams;
    function Equals(Another: TJobParams): boolean;
    function AssignChanges(From: TJobParams): boolean;
  end;

implementation

uses Variants;

constructor TJobParams.Create;
begin
  inherited;
  EquipCode := null;
  Executor := null;
  FactFinish := null;
  FactStart := null;
  JobComment := null;
  PlanFinish := null;
  PlanStart := null;
  FactProductOut := null;
  SplitMode1 := null;
  SplitMode2 := null;
  SplitMode3 := null;
  SplitPart1 := null;
  SplitPart2 := null;
  SplitPart3 := null;
end;

function TJobParams.GetAnyFinish: TDateTime;
begin
  if VarIsEmpty(FactFinish) or VarIsNull(FactFinish) then Result := PlanFinish
  else Result := FactFinish;
end;

function TJobParams.GetAnyStart: TDateTime;
begin
  if VarIsEmpty(FactStart) or VarIsNull(FactStart) then Result := PlanStart
  else Result := FactStart;
end;

procedure TJobParams.SetEquipCode(const Value: Variant);
begin
  FEquipCode := Value;
  FEquipCodeSet := true;
end;

procedure TJobParams.SetEstimatedDuration(const Value: Integer);
begin
  FEstimatedDuration := Value;
  FEstimatedDurationSet := true;
end;

procedure TJobParams.SetExecutor(const Value: Variant);
begin
  FExecutor := Value;
  FExecutorSet := true;
end;

procedure TJobParams.SetFactFinish(const Value: Variant);
begin
  FFactFinish := Value;
  FFactFinishSet := true;
end;

procedure TJobParams.SetFactStart(const Value: Variant);
begin
  FFactStart := Value;
  FFactStartSet := true;
end;

procedure TJobParams.SetJobComment(const Value: Variant);
begin
  FJobComment := Value;
  FJobCommentSet := true;
end;

procedure TJobParams.SetJobAlert(const Value: Boolean);
begin
  FJobAlert := Value;
  FJobAlertSet := true;
end;

procedure TJobParams.SetPlanFinish(const Value: Variant);
begin
  FPlanFinish := Value;
  FPlanFinishSet := true;
end;

procedure TJobParams.SetPlanStart(const Value: Variant);
begin
  FPlanStart := Value;
  FPlanStartSet := true;
end;

procedure TJobParams.SetFactProductOut(const Value: Variant);
begin
  FFactProductOut := Value;
  FFactProductOutSet := true;
end;

procedure TJobParams.SetSplitMode1(const Value: variant);
begin
  FSplitMode1 := Value;
  FSplitMode1Set := true;
end;

procedure TJobParams.SetSplitMode2(const Value: variant);
begin
  FSplitMode2 := Value;
  FSplitMode2Set := true;
end;

procedure TJobParams.SetSplitMode3(const Value: variant);
begin
  FSplitMode3 := Value;
  FSplitMode3Set := true;
end;

procedure TJobParams.SetSplitPart1(const Value: variant);
begin
  FSplitPart1 := Value;
  FSplitPart1Set := true;
end;

procedure TJobParams.SetSplitPart2(const Value: variant);
begin
  FSplitPart2 := Value;
  FSplitPart2Set := true;
end;

procedure TJobParams.SetSplitPart3(const Value: variant);
begin
  FSplitPart3 := Value;
  FSplitPart3Set := true;
end;

procedure TJobParams.SetTimeLocked(const Value: boolean);
begin
  FTimeLocked := Value;
  FTimeLockedSet := true;
end;

procedure TJobParams.SetAutoSplit(const Value: boolean);
begin
  FAutoSplit := Value;
  FAutoSplitSet := true;
end;

procedure TJobParams.SetIsPaused(const Value: boolean);
begin
  FIsPaused := Value;
  FIsPausedSet := true;
end;

procedure TJobParams.SetJobColor(const Value: variant);
begin
  FJobColor := Value;
  FJobColorSet := true;
end;

procedure TJobParams.ClearChanges;
begin
  FTimeLockedSet := false;
  FSplitMode1Set := false;
  FSplitMode2Set := false;
  FSplitMode3Set := false;
  FSplitPart1Set := false;
  FSplitPart2Set := false;
  FSplitPart3Set := false;
  FFactProductOutSet := false;
  FPlanStartSet := false;
  FPlanFinishSet := false;
  FJobCommentSet := false;
  FJobAlertSet := false;
  FFactStartSet := false;
  FFactFinishSet := false;
  FExecutorSet := false;
  FEstimatedDurationSet := false;
  FEquipCodeSet := false;
  FAutoSplitSet := false;
  FIsPausedSet := false;
  FJobColorSet := false;
end;

function TJobParams.Copy: TJobParams;
begin
  Result := TJobParams.Create;
  Result.TimeLocked := TimeLocked;
  Result.SplitMode1 := SplitMode1;
  Result.SplitMode2 := SplitMode2;
  Result.SplitMode3 := SplitMode3;
  Result.SplitPart1 := SplitPart1;
  Result.SplitPart2 := SplitPart2;
  Result.SplitPart3 := SplitPart3;
  Result.FactProductOut := FactProductOut;
  Result.PlanStart := PlanStart;
  Result.PlanFinish := PlanFinish;
  Result.JobComment := JobComment;
  Result.JobAlert := JobAlert;
  Result.FactStart := FactStart;
  Result.FactFinish := FactFinish;
  Result.Executor := Executor;
  Result.EstimatedDuration := EstimatedDuration;
  Result.EquipCode := EquipCode;
  Result.AutoSplit := AutoSplit;
  Result.IsPaused := IsPaused;
  Result.JobColor := JobColor;
  Result.OverlapShift := OverlapShift;
  Result.JobCost := JobCost;

  Result.JobID := JobID;
  Result.ItemID := ItemID;
  Result.JobType := JobType;
  Result.ItemDesc := ItemDesc;
  Result.Comment := Comment;
  Result.CustomerName := CustomerName;
  Result.OrderNumber := OrderNumber;
  Result.OrderState := OrderState;
  Result.ProductOut := ProductOut;
  Result.Multiplier := Multiplier;
  Result.SideCount := SideCount;
  Result.Part := Part;
  Result.PartName := PartName;
  Result.ItemProductOut := ItemProductOut;
  Result.OrderID := OrderID;
end;

function TJobParams.ExactCopy: TJobParams;
begin
  Result := Copy;
  Result.FTimeLockedSet := FTimeLockedSet;
  Result.FSplitMode1Set := FSplitMode1Set;
  Result.FSplitMode2Set := FSplitMode2Set;
  Result.FSplitMode3Set := FSplitMode3Set;
  Result.FSplitPart1Set := FSplitPart1Set;
  Result.FSplitPart2Set := FSplitPart2Set;
  Result.FSplitPart3Set := FSplitPart3Set;
  Result.FFactProductOutSet := FFactProductOutSet;
  Result.FPlanStartSet := FPlanStartSet;
  Result.FPlanFinishSet := FPlanFinishSet;
  Result.FJobCommentSet := FJobCommentSet;
  Result.FJobAlertSet := FJobAlertSet;
  Result.FFactStartSet := FFactStartSet;
  Result.FFactFinishSet := FFactFinishSet;
  Result.FExecutorSet := FExecutorSet;
  Result.FEstimatedDurationSet := FEstimatedDurationSet;
  Result.FEquipCodeSet := FEquipCodeSet;
  Result.FAutoSplitSet := FAutoSplitSet;
  Result.FIsPausedSet := FIsPausedSet;
  Result.FJobColorSet := FJobColorSet;
end;

function TJobParams.DatesChanged: boolean;
begin
  Result := FPlanStartSet or FPlanFinishSet or FFactStartSet or FFactFinishSet;
end;

function TJobParams.Changed: boolean;
begin
  Result := DatesChanged or FTimeLockedSet or FAutoSplitSet
    or FSplitMode1Set or FSplitMode2Set or FSplitMode3Set
    or FSplitPart1Set or FSplitPart2Set or FSplitPart3Set
    or FFactProductOutSet or FJobCommentSet or FJobAlertSet or FExecutorSet
    or FEstimatedDurationSet or FEquipCodeSet or FIsPausedSet
    or FJobColorSet;
end;

function TJobParams.HasSplitMode(SplitMode: TSplitMode): boolean;
begin
  Result := ((FSplitMode1 = SplitMode) and not VarIsNull(FSplitPart1))
     or ((FSplitMode2 = SplitMode) and not VarIsNull(FSplitPart2))
     or ((FSplitMode3 = SplitMode) and not VarIsNull(FSplitPart3));
end;

function TJobParams.ItemHasSplitMode(SplitMode: TSplitMode): boolean;
begin
  Result := (FSplitMode1 = SplitMode) or (FSplitMode2 = SplitMode) or (FSplitMode3 = SplitMode);
end;

function TJobParams.GetSplitPart(SplitMode: TSplitMode): integer;
begin
  if SplitMode1 = SplitMode then
    Result := NvlInteger(SplitPart1)
  else if SplitMode2 = SplitMode then
    Result := NvlInteger(SplitPart2)
  else if SplitMode3 = SplitMode then
    Result := NvlInteger(SplitPart3)
  else
    raise Exception.Create('Неправильный код разбивки ' + IntToStr(Ord(SplitMode)));
end;

function TJobParams.HasSplit: boolean;
begin
  Result := (not VarIsNull(FSplitMode1) and not VarIsNull(FSplitPart1))
     or (not VarIsNull(FSplitMode2) and not VarIsNull(FSplitPart2))
     or (not VarIsNull(FSplitMode3) and not VarIsNull(FSplitPart3));
end;

function TJobParams.Equals(Another: TJobParams): boolean;
begin
  Result := (JobID = Another.JobID)
   and (TimeLocked = Another.TimeLocked)
   and (SplitMode1 = Another.SplitMode1)
   and (SplitMode2 = Another.SplitMode2)
   and (SplitMode3 = Another.SplitMode3)
   and (SplitPart1 = Another.SplitPart1)
   and (SplitPart2 = Another.SplitPart2)
   and (SplitPart3 = Another.SplitPart3)
   and (FactProductOut = Another.FactProductOut)
   and (PlanStart = Another.PlanStart)
   and (PlanFinish = Another.PlanFinish)
   and (JobComment = Another.JobComment)
   and (JobAlert = Another.JobAlert)
   and (FactStart = Another.FactStart)
   and (FactFinish = Another.FactFinish)
   and (Executor = Another.Executor)
   and (EquipCode = Another.EquipCode)
   and (AutoSplit = Another.AutoSplit)
   and (IsPaused = Another.IsPaused)
   and (JobColor = Another.JobColor);
end;

function TJobParams.AssignChanges(From: TJobParams): boolean;
begin
  if (TimeLocked <> From.TimeLocked) then
    TimeLocked := From.TimeLocked;
  if (SplitMode1 <> From.SplitMode1) then
    SplitMode1 := From.SplitMode1;
  if (SplitMode2 <> From.SplitMode2) then
    SplitMode2 := From.SplitMode2;
  if (SplitMode3 <> From.SplitMode3) then
    SplitMode3 := From.SplitMode3;
  if (SplitPart1 <> From.SplitPart1) then
    SplitPart1 := From.SplitPart1;
  if (SplitPart2 <> From.SplitPart2) then
    SplitPart2 := From.SplitPart2;
  if (SplitPart3 <> From.SplitPart3) then
    SplitPart3 := From.SplitPart3;
  if (FactProductOut <> From.FactProductOut) then
    FactProductOut := From.FactProductOut;
  if (PlanStart <> From.PlanStart) then
    PlanStart := From.PlanStart;
  if (PlanFinish <> From.PlanFinish) then
    PlanFinish := From.PlanFinish;
  if (JobComment <> From.JobComment) then
    JobComment := From.JobComment;
  if (JobAlert <> From.JobAlert) then
    JobAlert := From.JobAlert;
  if (FactStart <> From.FactStart) then
    FactStart := From.FactStart;
  if (FactFinish <> From.FactFinish) then
    FactFinish := From.FactFinish;
  if (Executor <> From.Executor) then
    Executor := From.Executor;
  if (EquipCode <> From.EquipCode) then
    EquipCode := From.EquipCode;
  if (AutoSplit <> From.AutoSplit) then
    AutoSplit := From.AutoSplit;
  if (IsPaused <> From.IsPaused) then
    IsPaused := From.IsPaused;
  if (JobColor <> From.JobColor) then
    JobColor := From.JobColor;
end;

end.
