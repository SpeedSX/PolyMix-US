unit fComInfo;

interface

{$I calc.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvExComCtrls, JvProgressBar, ExtCtrls, Buttons,
  StdCtrls, DBCtrls, ActnList, DB,

  ProgressObj, PmEntity, PmOrder;

type
  TInfoLayout = (ilHorizontal, ilVertical);

  TfrCommonInfo = class(TFrame)
    paCommonInfo: TPanel;
    bvlCreation: TBevel;
    paNText: TPanel;
    dtID: TDBText;
    lbID: TLabel;
    Bevel10: TBevel;
    lbStateInHdr: TLabel;
    paCreationInfo: TPanel;
    dtDModify: TDBText;
    dtTModify: TDBText;
    dtModifierName: TDBText;
    Label17: TLabel;
    dtDCreation: TDBText;
    dtTCreation: TDBText;
    dtCreatorName: TDBText;
    Label48: TLabel;
    sbHistory: TBitBtn;
    btDecompose: TBitBtn;
    paCostInfo: TPanel;
    lbCost1Name: TLabel;
    dtCost1: TDBText;
    lbOld: TLabel;
    lbNew: TLabel;
    lbCost1: TLabel;
    paCost2: TPanel;
    dtCost2: TDBText;
    lbCost2: TLabel;
    lbCost2Name: TLabel;
    dtCostOf1BaseCurrency: TDBText;
    lbCostOf1BaseCurrency: TLabel;
    lbCostOf1BaseCurrencyName: TLabel;
    dtCostClientBaseCurrency: TDBText;
    lbCostClientBaseCurrencyName: TLabel;
    lbFinishDate: TLabel;
    paFinishDate: TPanel;
    dtFinishDate: TDBText;
    btProperties: TBitBtn;
    pbOpenProgress: TJvProgressBar;
    Label2: TLabel;
    Bevel1: TBevel;
    lbFactFinDate: TLabel;
    dtDFactFDate: TDBText;
    dtTFactFDate: TDBText;
    dtKindName: TDBText;
    imLock: TImage;
    imNotes: TImage;
    lbCostClientBaseCurrency: TLabel;
    procedure FrameResize(Sender: TObject);
    procedure imNotesClick(Sender: TObject);
  private
    FLayout: TInfoLayout;
    FInsideOrder: boolean;
    FCostVisible: boolean;
    FCost1Field, FCost2Field, FCostOf1BaseCurrencyField, FCostClientBaseCurrencyField: string;
    btOk, btCancel: TBitBtn;
    EntChangedID{, EntOpenID}: string;
    FOrder: TOrder;
    FOnNoteClick: TNotifyEvent; 
    procedure SetLayout(value: TInfoLayout);
    procedure SetVertLayout;
    procedure SetHorzLayout;
    procedure CheckEqual;
    function GetEntityCaption: string;
    procedure UpdateCostControlsVisibility;
    procedure SetCostVisible(c: boolean);
    procedure OnEntSettingsChanged(Sender: TObject);
    procedure SetEntityCaption(const Value: string);
    procedure SetOrder(_Order: TOrder);
    procedure SetDataSource(ds: TDataSource);
    procedure SetFinishDateVisibility(c: boolean);
    procedure SetFactFinishDateVisibility(c: boolean);
    procedure SetFactFinishDateMode(DateFieldName, TimeFieldName, FieldLabel: string);
    procedure DoOnNoteClick(Sender: TObject);
  public
    const
      // Минимальная ширина фрейма, при которой еще возможен горизонтальный режим
      // при отображении всех цен, т.е. при редактировании
      MinHorFrameWidth = 483;
      // Минимальная ширина фрейма, при которой еще возможен горизонтальный режим
      // при отображении только текущих цен
      MinHorViewFrameWidth = 402;
      MinHorFrameHeight = 186;   // Минимальная высота в горизонтальном режиме
      DatePanelWidth = 185;
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure SetPropAction(_A: TAction);
    procedure SetHistoryAction(_A: TAction);
    procedure LeftToRight;
    procedure RightToLeft;
    procedure SettingsChanged;
    procedure SetGrnCost(s: string);
    procedure SetUECost(s: string);
    procedure SetExpenseCost(s: string);
    procedure Set1Cost(s: string);
    procedure SetClientCost(s: string);
    function OpenProgress: TProgressObj;
    procedure HideProgress;
    procedure ClearCost;
    function GetMinWidth: integer;
    function GetMinHeight: integer;
    function GetNormalHeight: integer;
    procedure SetOkCancel(_btOk, _btCancel: TBitBtn);

    property Order: TOrder read FOrder write SetOrder;
    property CostVisible: boolean read FCostVisible write SetCostVisible;
    //property EntityCaption: string read GetEntityCaption write SetEntityCaption;
    property Layout: TInfoLayout read FLayout write SetLayout;
    property OnNoteClick: TNotifyEvent read FOnNoteClick write FOnNoteClick;
  end;

implementation

uses RVCLUtils, CalcSettings, PmEntSettings, PmAccessManager, CalcUtils;

var
  FProgressObj: TProgressObj;

{$R *.dfm}

constructor TfrCommonInfo.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  EntChangedID := EntSettings.AfterApplyNotifier.RegisterHandler(OnEntSettingsChanged);
  SettingsChanged;
  //EntOpenID := EntSettings.OpenNotifier.RegisterHandler(OnEntSettingsChanged);
end;

destructor TfrCommonInfo.Destroy;
begin
  // могла уже сработать финализация поэтому проверяем
  if EntSettings <> nil then EntSettings.AfterApplyNotifier.UnregisterHandler(EntChangedID);
  //EntSettings.OpenNotifier.UnregisterHandler(EntOpenID);
  inherited Destroy;
end;

procedure TfrCommonInfo.OnEntSettingsChanged(Sender: TObject);
begin
  if EntSettings.NativeCurrency then
  begin
    if EntSettings.ShowExpenseCost then
    begin
      lbCost1Name.Visible := true;
      FCost1Field := 'TotalGrn';
      lbCost1Name.Caption := 'Стоимость, грн.';
      lbCost2Name.Visible := true;
      FCost2Field := TOrder.F_TotalExpenseCost;
      lbCost2Name.Caption := 'Затраты, грн.';
    end
    else
    begin
      lbCost1Name.Visible := false;
      FCost2Field := 'TotalGrn';
      lbCost2Name.Caption := 'Стоимость, грн.';
    end;
    FCostOf1BaseCurrencyField := 'CostOf1Grn';
    FCostClientBaseCurrencyField := 'ClientTotalGrn';
    lbCostOf1BaseCurrencyName.Caption := 'Цена 1 экз., грн.';
  end
  else
  begin
    lbCost1Name.Visible := true;
    FCost1Field := 'TotalGrn';
    lbCost1Name.Caption := 'Стоимость, грн.';
    if EntSettings.ShowExpenseCost then
    begin
      lbCost2Name.Visible := true;
      FCost2Field := TOrder.F_TotalExpenseCost;
      lbCost2Name.Caption := 'Затраты, грн.';
    end
    else
    begin
      lbCost2Name.Visible := true;
      FCost2Field := 'TotalCost';
      lbCost2Name.Caption := 'Стоимость, у.е.';
    end;
    if Options.ShowFinalNative then
    begin
      FCostOf1BaseCurrencyField := 'CostOf1Grn';
      FCostClientBaseCurrencyField := 'ClientTotalGrn';
      lbCostOf1BaseCurrencyName.Caption := 'Цена 1 экз., грн.';
    end
    else
    begin
      FCostOf1BaseCurrencyField := 'CostOf1';
      FCostClientBaseCurrencyField := 'ClientTotal';
      lbCostOf1BaseCurrencyName.Caption := 'Цена 1 экз., у.е.';
    end;
    lbCost1Name.Visible := true;
  end;
  SetDataSource(dtID.DataSource);
end;

procedure TfrCommonInfo.SetPropAction(_A: TAction);
begin
  btProperties.Action := _A;
end;

procedure TfrCommonInfo.SetHistoryAction(_A: TAction);
begin
  sbHistory.Action := _A;
end;

procedure TfrCommonInfo.SetFinishDateVisibility(c: boolean);
begin
  lbFinishDate.Visible := c;
  //dtFinishDate.Visible := c;
  paFinishDate.Visible := c;
  if c then
    dtFinishDate.DataSource := FOrder.DataSource
  else
    dtFinishDate.DataSource := nil;
end;

procedure TfrCommonInfo.SetFactFinishDateVisibility(c: boolean);
begin
  lbFactFinDate.Visible := c;
  dtDFactFDate.Visible := c;
  dtTFactFDate.Visible := c;
  if c then
  begin
    dtDFactFDate.DataSource := FOrder.DataSource;
    dtTFactFDate.DataSource := FOrder.DataSource;
  end
  else
  begin
    dtDFactFDate.DataSource := nil;
    dtTFactFDate.DataSource := nil;
  end;
end;

procedure TfrCommonInfo.SetFactFinishDateMode(DateFieldName, TimeFieldName, FieldLabel: string);
var f: variant;
begin
  //if dtDFactFDate.DataSource <> nil then
    f := FOrder.DataSet[DateFieldName];
  //else
  //  f := null;
  SetFactFinishDateVisibility(not VarIsNull(f) and (f <> 0));
  lbFactFinDate.Caption := FieldLabel;
  dtDFactFDate.DataField := DateFieldName;
  dtTFactFDate.DataField := TimeFieldName;
end;

procedure TfrCommonInfo.SetCostVisible(c: boolean);
begin
  FCostVisible := c;
  UpdateCostControlsVisibility;
end;

procedure TfrCommonInfo.SetDataSource(ds: TDataSource);
begin
  if dtID.DataSource <> ds then
  begin
    dtID.DataSource := ds;
    dtCost1.DataSource := ds;
    dtCost1.DataField := FCost1Field;
    dtCost2.DataSource := ds;
    dtCost2.DataField := FCost2Field;
    dtCostOf1BaseCurrency.DataSource := ds;
    dtCostOf1BaseCurrency.DataField := FCostOf1BaseCurrencyField;
    dtCostClientBaseCurrency.DataSource := ds;
    dtCostClientBaseCurrency.DataField := FCostClientBaseCurrencyField;
    dtDCreation.DataSource := ds;
    dtTCreation.DataSource := ds;
    dtDModify.DataSource := ds;
    dtTModify.DataSource := ds;
    dtCreatorName.DataSource := ds;
    dtModifierName.DataSource := ds;
    dtKindName.DataSource := ds;
  end;
end;

procedure TfrCommonInfo.SetOrder(_Order: TOrder);
var c: boolean;
begin
  FOrder := _Order;
  SetDataSource(FOrder.DataSource);
  SetEntityCaption(FOrder.NameSingular);

  // показываем-прячем элементы в зависимости расчет или заказ
  c := (FOrder is TWorkOrder) and not FOrder.DataSet.IsEmpty;
  SetFinishDateVisibility(c and not VarIsNull(FOrder.DataSet['FinishDate']) and (FOrder.DataSet['FinishDate'] <> 0));
  if not c then
    SetFactFinishDateVisibility(false)
  else if not VarIsNull(FOrder.DataSet['CloseDate']) then
    SetFactFinishDateMode('CloseDate', 'CloseTime', 'Дата закрытия')
  else
    SetFactFinishDateMode('FactFinishDate', 'FactFinishTime', 'Факт. завершение');
  //SetFactFinishDateVisibility(c and not VarIsNull(cdOrd['FactFinishDate']) and (cdOrd['FactFinishDate'] <> 0));

  if not FOrder.DataSet.IsEmpty then
  begin
    // картинку рисуем если установлена защита
    if FOrder.IsLockedByUser then
    begin
      if imLock.Picture.Bitmap <> bmpEditLock then
        imLock.Picture.Bitmap := bmpEditLock;
      imLock.Visible := true;
    end
    else
    if FOrder.ContentProtected then
    begin
      if imLock.Picture.Bitmap <> bmpContentProtected then
        imLock.Picture.Bitmap := bmpContentProtected;
      imLock.Visible := true;
    end
    else
    if FOrder.CostProtected then
    begin
      if imLock.Picture.Bitmap <> bmpCostProtected then
        imLock.Picture.Bitmap := bmpCostProtected;
      imLock.Visible := true;
    end
    else
      imLock.Visible := false;
  end
  else
    imLock.Visible := false;

  if not FOrder.DataSet.IsEmpty then
  begin
    // картинку рисуем если есть комментарии
    if FOrder.HasNotes then
    begin
      if imNotes.Picture.Bitmap <> bmpHasNotes then
        imNotes.Picture.Bitmap := bmpHasNotes;
      imNotes.Visible := true;
    end
    else
      //imNotes.Visible := false;
      imNotes.Picture.Bitmap := nil;
  end
  else
    //imNotes.Visible := false;
    imNotes.Picture.Bitmap := nil;
end;

procedure TfrCommonInfo.UpdateCostControlsVisibility;  // Right state!
begin
  dtCost1.Visible := (not EntSettings.NativeCurrency or EntSettings.ShowExpenseCost) and FCostVisible;
  SetControlVisible([dtCost2, dtCostOf1BaseCurrency, dtCostClientBaseCurrency], FCostVisible);
  lbCost1.Visible := (not EntSettings.NativeCurrency or EntSettings.ShowExpenseCost) and FCostVisible and FInsideOrder;
  SetControlVisible([lbOld, lbNew, lbCost2, lbCostOf1BaseCurrency, lbCostClientBaseCurrency], FCostVisible and FInsideOrder);
end;

procedure TfrCommonInfo.LeftToRight;
begin
  FInsideOrder := true;
  ClearCost;
  {$IFDEF Manager}
  dtClientPrice.Visible := false;
  lbClientPrice.Visible := false;
  {$ENDIF}
  UpdateCostControlsVisibility;
  lbOld.Font.Color := Options.GetColor(sNewPrice);
  SetDBTextFontColor([dtCost1, dtCost2, dtCostOf1BaseCurrency, dtCostClientBaseCurrency],
    Options.GetColor(sCurrentPrice));
  sbHistory.Visible := false;
  btOk.Top := sbHistory.Top;
  btOk.Left := 1;
  btCancel.Top := sbHistory.Top;
  btCancel.Left := btOk.Left + btOk.Width + 6;
  btOk.Visible := true;
  btCancel.Visible := true;
  //Width := MinWidth;
end;

procedure TfrCommonInfo.RightToLeft;
begin
  TSettingsManager.Instance.XPInitComponent(btProperties);
  TSettingsManager.Instance.XPInitComponent(sbHistory);
  FInsideOrder := false;
  SetControlVisible([lbOld, lbNew, lbCost2, lbCost1,
    lbCostOf1BaseCurrency, lbCostClientBaseCurrency], false);
  dtCost1.Visible := (not EntSettings.NativeCurrency or EntSettings.ShowExpenseCost) and FCostVisible;
  SetControlVisible([dtCost2, dtCostOf1BaseCurrency, dtCostClientBaseCurrency], FCostVisible);
  lbOld.Font.Color := Options.GetColor(sCurrentPrice);
  SetDBTextFontColor([dtCost1, dtCost2, dtCostOf1BaseCurrency, dtCostClientBaseCurrency],
    Options.GetColor(sNewPrice));
  ClearCost; // на всякий случай
  btOk.Visible := false;
  btCancel.Visible := false;
  sbHistory.Visible := true;
  FrameResize(nil);
end;

procedure TfrCommonInfo.ClearCost;
begin
  lbCost1.Caption := '-';
  lbCost2.Caption := '-';
  lbCostOf1BaseCurrency.Caption := '-';
  lbCostClientBaseCurrency.Caption := '-';
end;

procedure TfrCommonInfo.SettingsChanged;
begin
  // вызывается, чтобы учесть новые настройки интерфейса
  OnEntSettingsChanged(nil);

  dtCost2.Font.Color := Options.GetColor(sNewPrice);
  lbCost2.Font.Color := Options.GetColor(sNewPrice);
  paNText.Color := Options.GetColor(sNBack);
  dtID.Font.Color := Options.GetColor(sNText);
  lbID.Font.Color := Options.GetColor(sNText);
  lbStateInHdr.Font.Color := Options.GetColor(sNText);
  dtKindName.Font.Color := Options.GetColor(sNText);
  paFinishDate.Color := Options.GetColor(sFDBack);
  dtFinishDate.Font.Color := Options.GetColor(sFDText);
  paCostInfo.Color := Options.GetColor(sComInfoDraftBack);
  paCreationInfo.Color := Options.GetColor(sComInfoDraftBack);
  paCommonInfo.Color := Options.GetColor(sComInfoDraftBack);
  //paCost2.Color := Options.GetColor(sUEBk);
  paCost2.Color := paCommonInfo.Color;
end;

procedure TfrCommonInfo.SetGrnCost(s: string);
begin
  if lbCost1.Caption <> s then
    lbCost1.Caption := s;
  if s <> '-' then CheckEqual;
end;

procedure TfrCommonInfo.SetUECost(s: string);
begin
  if not EntSettings.ShowExpenseCost then
  begin
    if lbCost2.Caption <> s then
      lbCost2.Caption := s;
    if s <> '-' then CheckEqual;
  end;
end;

procedure TfrCommonInfo.SetExpenseCost(s: string);
begin
  if EntSettings.ShowExpenseCost then
  begin
    if lbCost2.Caption <> s then
      lbCost2.Caption := s;
    if s <> '-' then CheckEqual;
  end;
end;

procedure TfrCommonInfo.Set1Cost(s: string);
begin
  if lbCostOf1BaseCurrency.Caption <> s then
    lbCostOf1BaseCurrency.Caption := s;
  if s <> '-' then CheckEqual;
end;

procedure TfrCommonInfo.SetClientCost(s: string);
begin
  if lbCostClientBaseCurrency.Caption <> s then
    lbCostClientBaseCurrency.Caption := s;
  if s <> '-' then CheckEqual;
end;

procedure TfrCommonInfo.CheckEqual;

  function CheckLabelEquals(lb: TLabel; dt: TDBtext): boolean;
  var v: variant;
  begin
    if dt.Field <> nil then begin
      v := dt.Field.Value;
      Result := (VarIsNull(v) and (lb.Caption = '-'))
         or (not VarIsNull(v) and (lb.Caption = FormatFloat((dt.Field as TNumericField).DisplayFormat, v)));
    end else
      Result := false;
  end;

var
  Changed: boolean;
begin
  if (dtCost1.DataSource = nil) or not FCostVisible then Exit;
  Changed := not (
    ((EntSettings.NativeCurrency and not EntSettings.ShowExpenseCost) or CheckLabelEquals(lbCost1, dtCost1))
    and (EntSettings.ShowExpenseCost or CheckLabelEquals(lbCost2, dtCost2))
    and CheckLabelEquals(lbCostOf1BaseCurrency, dtCostOf1BaseCurrency)
    and CheckLabelEquals(lbCostClientBaseCurrency, dtCostClientBaseCurrency));
  // т.е. если цены в грн и не отображаются затраты, то первая строка пустая, и ее не надо проверять
  // если затраты отображаются, то вторую строку не надо проверять
  if dtCost2.Visible <> Changed then
    SetControlVisible([lbOld, lbNew, dtCost2, dtCostOf1BaseCurrency,
      dtCostClientBaseCurrency], Changed);
  dtCost1.Visible := (not EntSettings.NativeCurrency or EntSettings.ShowExpenseCost) and Changed;
end;

function TfrCommonInfo.OpenProgress: TProgressObj;
begin
  imNotes.Visible := false;
  FProgressObj.ProgressBar := pbOpenProgress;
  Result := FProgressObj;
end;

procedure TfrCommonInfo.HideProgress;
begin
  pbOpenProgress.Visible := false;
  imNotes.Visible := true;
end;

procedure TfrCommonInfo.imNotesClick(Sender: TObject);
begin
  if imNotes.Picture.Bitmap <> nil then
    DoOnNoteClick(Sender);
end;

procedure TfrCommonInfo.DoOnNoteClick(Sender: TObject);
begin
  FOnNoteClick(Sender);
end;

function TfrCommonInfo.GetNormalHeight: integer;
begin
  if Flayout = ilVertical then
    Result := paCostInfo.Height +
      paNText.Height + bvlCreation.Height + paCreationInfo.Height
  else
    Result := GetMinHeight;
end;

procedure TfrCommonInfo.SetVertLayout;
var
  paParent: TPanel;
begin
  FLayout := ilVertical;
  paNText.Height := 40;
  lbStateInHdr.Left := lbId.Left;
  lbStateInHdr.Top := 23;
  dtKindName.Left := dtId.Left;
  dtKindName.Top := 23;
  paCostInfo.Align := alTop;
  paCostInfo.Top := paNText.Height + 1;
  paCostInfo.Height := btProperties.Top + btProperties.Height + 6;
  bvlCreation.Align := alTop;
  bvlCreation.Shape := bsTopLine;
  bvlCreation.Height := 7;
  bvlCreation.Top := paNText.Height + 10;
  paCreationInfo.Align := alTop;
  paCreationInfo.Top := paNText.Height + paCostInfo.Height + 20;
  paCreationInfo.Height := sbHistory.Top + sbHistory.Height + 6;
  paParent := Parent as TPanel;
  paParent.Height := GetNormalHeight;
  Height := paParent.Height;    // tweak... not updated otherwise
  {paCommonInfo.Align := alTop;
  paCommonInfo.Height := paParent.Height - paParent.BorderWidth * 2;}
end;

procedure TfrCommonInfo.SetHorzLayout;
var
  paParent: TPanel;
begin
  FLayout := ilHorizontal;
  paNText.Height := 25;
  lbStateInHdr.Left := 174;
  lbStateInHdr.Top := lbID.Top;
  dtKindName.Left := 202;
  dtKindName.Top := dtID.Top;
  paCostInfo.Align := alClient;
  bvlCreation.Align := alRight;
  bvlCreation.Shape := bsRightLine;
  bvlCreation.Width := 7;
  paCreationInfo.Align := alRight;
  paCreationInfo.Width := DatePanelWidth;
  paParent := Parent as TPanel;
  paParent.Height := paParent.BorderWidth * 2 + btProperties.Top +
    btProperties.Height + 6 + paNText.Height;
  {paCommonInfo.Align := alTop;
  paCommonInfo.Height := Height;}
end;

procedure TfrCommonInfo.SetLayout(value: TInfoLayout);
begin
  if (Layout = ilHorizontal) and (paCreationInfo.Align = alRight) then
    SetHorzLayout
  else if (Layout = ilVertical) and (paCreationInfo.Align = alTop) then
    SetVertLayout;
end;

procedure TfrCommonInfo.FrameResize(Sender: TObject);
begin
  if (Width < GetMinWidth) and (FLayout = ilHorizontal) then SetVertLayout
  else if (Width >= GetMinWidth) and (FLayout = ilVertical) then SetHorzLayout;
end;

function TfrCommonInfo.GetMinWidth: integer;
begin
  if lbCost2.Visible then Result := MinHorFrameWidth
  else Result := MinHorViewFrameWidth;
end;

function TfrCommonInfo.GetMinHeight: integer;
begin
  Result := MinHorFrameHeight;
end;

function TfrCommonInfo.GetEntityCaption: string;
begin
  Result := lbID.Caption;
end;

procedure TfrCommonInfo.SetEntityCaption(const Value: string);
begin
  lbID.Caption := Value;
end;

procedure TfrCommonInfo.SetOkCancel(_btOk, _btCancel: TBitBtn);
begin
  btOk := _btOk;
  btCancel := _btCancel;
  btOk.Parent := paCreationInfo;
  btCancel.Parent := paCreationInfo;
end;

initialization
  FProgressObj := TProgressObj.Create;

finalization
  FreeAndNil(FProgressObj);

end.
