unit fBaseFilter;

{$I Calc.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvExControls, JvComponent, JvgCheckBox, JvDBLookup, StdCtrls,
  ComCtrls, JvExStdCtrls, JvEdit, JvValidateEdit, Buttons, JvgGroupBox,
  ExtCtrls, JvExExtCtrls, JvToolEdit, jvAppStorage, JvJCLUtils,
  JvxCheckListBox, DB, JvgTypes, ImgList, JvImageList,
  DBCtrlsEh, JvExComCtrls, JvUpDown, Mask, DateUtils,

  CalcUtils, NotifyEvent, MainFilter, DicObj, PmAccessManager, CalcSettings, PmEntSettings,
  PmEntity, PmProcessCfg, RDBUtils;

type
  TBaseFilterFrame = class(TFrame)
    ScrollBox1: TScrollBox;
    paFilterHdr: TPanel;
    Image1: TImage;
    lbFilterHdr: TLabel;
    gbMonthYear: TJvgGroupBox;
    sbMonthDn: TSpeedButton;
    sbMonthUp: TSpeedButton;
    sbYearUp: TSpeedButton;
    sbYearDn: TSpeedButton;
    cbMonth: TComboBox;
    ceYear: TJvValidateEdit;
    rbYear: TRadioButton;
    rbCurMonth: TRadioButton;
    rbCurYear: TRadioButton;
    chbMonth: TCheckBox;
    Panel1: TPanel;
    Label2: TLabel;
    cbRangeEnd: TCheckBox;
    rbDateRange: TRadioButton;
    gbCust: TJvgGroupBox;
    btCustSel: TSpeedButton;
    lcCust: TJvDBLookupCombo;
    gbComment: TJvgGroupBox;
    Label1: TLabel;
    edComment: TEdit;
    gbCreator: TJvgGroupBox;
    cbCreatorName: TComboBox;
    gbEvent: TJvgGroupBox;
    cbEventUser: TComboBox;
    lbEventText: TLabel;
    edEventText: TEdit;
    deEventStart: TDBDateTimeEditEh;
    deEventEnd: TDBDateTimeEditEh;
    gbNum: TJvgGroupBox;
    lbNum: TLabel;
    rbNumEQ: TRadioButton;
    rbNumBounds: TRadioButton;
    gbOrdState: TJvgGroupBox;
    boxOrdState: TJvxCheckListBox;
    gbPayState: TJvgGroupBox;
    boxPayState: TJvxCheckListBox;
    Bevel1: TBevel;
    imOrdState: TJvImageList;
    imPayState: TJvImageList;
    imDisOrdState: TJvImageList;
    imDisPayState: TJvImageList;
    cbDateType: TComboBox;
    rbOneDay: TRadioButton;
    gbOrderKind: TJvgGroupBox;
    boxOrderKind: TJvxCheckListBox;
    sbCloseFilter: TSpeedButton;
    Panel3: TPanel;
    edNumEQ: TEdit;
    edNumGT: TEdit;
    edNumLT: TEdit;
    gbProcess: TJvgGroupBox;
    boxProcessList: TComboBox;
    gbProcessState: TJvgGroupBox;
    boxProcessState: TJvxCheckListBox;
    imDisProcessState: TJvImageList;
    imProcessState: TJvImageList;
    cbProcessInvert: TCheckBox;
    deRangeStart: TDBDateTimeEditEh;
    deRangeEnd: TDBDateTimeEditEh;
    deOneDay: TDBDateTimeEditEh;
    btIncDate: TSpeedButton;
    btDecDate: TSpeedButton;
    dsCust: TDataSource;
    gbExternalId: TJvgGroupBox;
    edExternalId: TEdit;
    procedure sbMonthDnClick(Sender: TObject);
    procedure sbMonthUpClick(Sender: TObject);
    procedure cbMonthYearClick(Sender: TObject);
    procedure sbYearDnClick(Sender: TObject);
    procedure sbYearUpClick(Sender: TObject);
    procedure cbNumClick(Sender: TObject);
    procedure cbCustClick(Sender: TObject);
    procedure rbNumEQClick(Sender: TObject);
    procedure cbCommentClick(Sender: TObject);
    procedure btCustSelClick(Sender: TObject);
    procedure cbCreatorClick(Sender: TObject);
    procedure cbEventClick(Sender: TObject);
    procedure cbOrdStateClick(Sender: TObject);
    procedure cbPayStateClick(Sender: TObject);
    procedure edCommentChange(Sender: TObject);
    procedure lcCustChange(Sender: TObject);
    procedure lcCustGetImage(Sender: TObject; IsEmpty: Boolean;
      var Graphic: TGraphic; var TextMargin: Integer);
    procedure boxPayStateDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cbDateTypeChange(Sender: TObject);
    procedure gbOrderKindClick(Sender: TObject);
    procedure boxOrderKindDrawItem(Control: TWinControl;
      Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure sbCloseFilterClick(Sender: TObject);
    procedure gbProcessClick(Sender: TObject);
    procedure boxProcessListChange(Sender: TObject);
    procedure cbProcessStateClick(Sender: TObject);
    procedure btIncDateClick(Sender: TObject);
    procedure btDecDateClick(Sender: TObject);
    procedure boxProcessListCloseUp(Sender: TObject);
    procedure gbExternalIdClick(Sender: TObject);
    procedure edExternalIdChange(Sender: TObject);
  private
    RestoringControls: boolean;
    FOnFilterChange, FOnDisableFilter: TFilterEvent;
    FFilterObj: TFilterObj;
    FilterActive: boolean;
    //FAppStorage: TjvCustomAppStorage;
    FOnHideFrame: TNotifyEvent;
    FProcessList: TStringList;
    FCfgChangedID: TNotifyHandlerID;
    procedure SetFilterObj(Value: TFilterObj);
    procedure FillStateBox(boxState: TJvxCheckListBox;
      ImList, DisImList: TjvImageList;
      de: TDictionary; var StateValues: TIntArray);
    procedure UpdateMonthYearControls;
    procedure UpdateFilterControlsEnabled(En: boolean);
    //procedure FreeProcessList;
    procedure FillProcessBox;
    procedure SetProcessIndex(Index: integer);
    procedure RestoreControls;
    function CheckNumbers: boolean;
  protected
    UsersCopy: TStringList;
    ControlsRestored: boolean;
    FEntity: TEntity;
    FilterControlsInUpdate: boolean;
    procedure AdjustGroupBoxHeight(gb: TjvgGroupBox; clb: TjvxCheckListBox);
    procedure DoRestoreControls; virtual;
    procedure DoSaveControls; virtual;
    procedure DisableFilter; virtual;
    procedure DoOnCfgChanged(Sender: TObject); virtual;
    procedure UpdateGroupsEnabledState; virtual;
    //procedure ChangeOrderKind;
    procedure EnableDBControls; virtual;
    procedure DisableDBControls; virtual;
    //function CurOrderKindIsDraft: boolean; virtual;
    function GetCustomerKey: Integer; virtual;
    function SupportsOrderState: boolean; virtual;
    function SupportsPayState: boolean; virtual;
    function SupportsExternalId: boolean; virtual;
    function GetDateList: TStringList; virtual;
    //procedure DoOnEntityChange; virtual;
    procedure FillOrderKindBox;
    procedure SaveCheckedStateValues(var StateValues: TIntArray; boxState: TJvxCheckListBox);
    procedure SetEntity(_Entity: TEntity); virtual;
    procedure SaveControls;
    procedure UpdateCustomerControls(GroupBox: TJvgGroupBox;
      ComboBox: TjvDBLookupCombo; SelectButton: TSpeedButton);
    procedure FreeUsersCopy;
  public
    property FilterObj: TFilterObj read FFilterObj write SetFilterObj;
    property OnFilterChange: TFilterEvent read FOnFilterChange write FOnFilterChange;
    property OnDisableFilter: TFilterEvent read FOnDisableFilter write FOnDisableFilter;
    //property AppStorage: TJvCustomAppStorage read FAppStorage write FAppStorage;
    property OnHideFrame: TNotifyEvent read FOnHideFrame write FOnHideFrame;
    property Entity: TEntity read FEntity write SetEntity;

    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

    procedure OnCreate; virtual;
    procedure Activate; virtual;
    //procedure OnHide;  // Not used
    procedure UpdateFilterControls;
    procedure ApplyFilter;
    procedure DisableControls;
    procedure EnableControls;
    procedure SettingsChanged;
  end;

implementation

uses MainData, ServData, PmContragentListForm, MMYYList, ExHandler,
  Math, JvJVCLUtils, StdDic, PmContragent, PmOrder,
  PmContragentPainter, PmConfigManager, PmStates;

{$R *.dfm}

const
  FilterInactiveCaptionColor = $E0F0F0;

constructor TBaseFilterFrame.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  FCfgChangedID := '';
end;

destructor TBaseFilterFrame.Destroy;
begin
  if (FCfgChangedID <> '') then
    TConfigManager.Instance.ProcessCfgChanged.UnregisterHandler(FCfgChangedID);
  FreeUsersCopy;
  //FreeProcessList;
  inherited Destroy;
end;

procedure TBaseFilterFrame.FreeUsersCopy;
var
  I: Integer;
begin
  if UsersCopy <> nil then
  begin
    for I := 0 to UsersCopy.Count - 1 do
       (UsersCopy.Objects[i] as TUserInfo).Free;
    FreeAndNil(UsersCopy);
  end;
end;

procedure TBaseFilterFrame.ApplyFilter;
begin
  if not FilterControlsInUpdate and FilterActive and not RestoringControls then
  begin
    SaveControls;
    if Assigned(FOnFilterChange) then FOnFilterChange;
  end;
end;

procedure TBaseFilterFrame.sbMonthDnClick(Sender: TObject);
begin
  if cbMonth.ItemIndex > 0 then
    cbMonth.ItemIndex := cbMonth.ItemIndex - 1
  else
  begin
    cbMonth.ItemIndex := cbMonth.Items.Count - 1;
    ceYear.Value := ceYear.Value - 1;
  end;
  cbMonthYearClick(Sender);
end;

procedure TBaseFilterFrame.sbMonthUpClick(Sender: TObject);
begin
  if cbMonth.ItemIndex < Pred(cbMonth.Items.Count) then
    cbMonth.ItemIndex := cbMonth.ItemIndex + 1
  else begin
    cbMonth.ItemIndex := 0;
    ceYear.Value := ceYear.Value + 1;
  end;
  cbMonthYearClick(Sender);
end;

procedure TBaseFilterFrame.cbMonthYearClick(Sender: TObject);
begin
  if FilterControlsInUpdate then Exit;
  UpdateMonthYearControls;
  ApplyFilter;
end;

procedure TBaseFilterFrame.sbYearDnClick(Sender: TObject);
begin
  ceYear.Value := ceYear.Value - 1;
end;

procedure TBaseFilterFrame.sbYearUpClick(Sender: TObject);
begin
  ceYear.Value := ceYear.Value + 1;
end;

function TBaseFilterFrame.GetDateList: TStringList;
begin
  raise Exception.Create('TBaseFilterFrame.GetDateList is not implemented');
end;

procedure TBaseFilterFrame.UpdateMonthYearControls;
var
  c, c1: boolean;
begin
  FilterControlsInUpdate := true;
  c := not gbMonthYear.Collapsed and (cbDateType.ItemIndex <> -1);
  //c := IsChecked(cbMonthYear);
  //SetChecked(cbMonthYear, c);

  rbYear.Enabled := c;
  rbCurYear.Enabled := c;
  rbCurMonth.Enabled := c;
  rbDateRange.Enabled := c;

  c1 := rbDateRange.Checked and c;
  deRangeStart.Enabled := c1;
  cbRangeEnd.Enabled := c1;
  deRangeEnd.Enabled := c1 and cbRangeEnd.Checked;

  c1 := rbYear.Checked and c;
  sbYearDn.Enabled := c1;
  sbYearUp.Enabled := c1;
  ceYear.Enabled := c1;
  chbMonth.Enabled := c1;
  ceYear.Enabled := c1;
  c1 := chbMonth.Checked and c1;
  sbMonthDn.Enabled := c1;
  sbMonthUp.Enabled := c1;
  cbMonth.Enabled := c1;

  c1 := rbOneDay.Checked and c;
  deOneDay.Enabled := c1;
  btDecDate.Enabled := c1;
  btIncDate.Enabled := c1;
  {if cbQuery.Checked then begin
    paQuery.Color := $E0E0E0;
    cbQuery.Font.Style := [fsBold];
  end else begin
    paQuery.Color := clBtnFace;
    cbQuery.Font.Style := [];
  end;}
  FilterControlsInUpdate := false;
end;

procedure TBaseFilterFrame.UpdateFilterControls;
begin
  UpdateMonthYearControls;
end;

procedure TBaseFilterFrame.UpdateFilterControlsEnabled(En: boolean);
begin
  //cbQuery.Enabled := En;
  chbMonth.Enabled := En;
  cbMonth.Enabled := En;
  sbMonthDn.Enabled := En;
  sbMonthUp.Enabled := En;
  rbYear.Enabled := En;
  sbYearDn.Enabled := En;
  sbYearUp.Enabled := En;
  ceYear.Enabled := En;
  //btApply.Enabled := En;
  if En then UpdateFilterControls;
end;

procedure TBaseFilterFrame.FillStateBox(boxState: TJvxCheckListBox;
  ImList, DisImList: TjvImageList;
  de: TDictionary; var StateValues: TIntArray);
var
  i: integer;
  Bmp: TBitmap;
begin
  boxState.Clear;
  ImList.Clear;
  DisImList.Clear;
  // Заполняем список именами справочника состояний заказа, давая каждому
  // в качестве объекта его код.
  if (de <> nil) and (de.ItemCount > 0) then
  begin
    de.DicItems.First;
    i := 0;
    while not de.DicItems.eof do
    try
      if de.CurrentEnabled then
      begin
        boxState.Items.AddObject(de.CurrentName, TObject(de.CurrentCode));
        Bmp := TBitmap.Create;
        de.LoadImage(Bmp, DicStateImageIndex);
        //if Bmp.Width <> 0 then
        //begin
          imList.Add(Bmp, nil);
          Bmp := TBitmap.Create;
          de.LoadImage(Bmp, DicStateDisabledImageIndex);
          DisImList.Add(Bmp, nil);
          // Проверяет, есть ли в списке сохраненных отмеченных состояний данное состояние
          if IntInArray(de.CurrentCode, StateValues) then
            boxState.Checked[i] := true;
        //end;
      end;
    finally
      de.DicItems.Next;
      Inc(i);
    end;
    boxState.Height := boxState.ItemHeight * boxState.Items.Count;
    {if boxState.Parent is TjvgGroupBox then begin
      if not (boxState.Parent as TjvgGroupBox).Collapsed then
        (boxState.Parent as TjvgGroupBox).Height := boxState.Height + boxState.Top + 3;
      //boxState.Width := (boxState.Parent as TjvgGroupBox).Width - boxState.Left - 3;
    end;}
  end;
end;

procedure TBaseFilterFrame.FillOrderKindBox;
var
  i: integer;
  cd: TDataSet;
  KindValues, AllKindValues: TIntArray;
begin
  boxOrderKind.Clear;
  cd := sdm.cdOrderKind;
  KindValues := FFilterObj.GetCheckedOrderKindValues(Entity);
  AllKindValues := FFilterObj.GetAllOrderKindValues(Entity);
  // Заполняем список именами видов заказа, давая каждому
  // в качестве объекта его ключ.
  if (cd <> nil) and (cd.RecordCount > 0) then
  begin
    cd.First;
    i := 0;
    while not cd.eof do
    try
      // берем только разрешенные
      if IntInArray(cd[TOrder.F_KindID], AllKindValues) then
      begin
        boxOrderKind.Items.AddObject(cd[OrderKindDescField],
          TObject(cd.FieldByName(TOrder.F_KindID).AsInteger));
        // ставим галочки
        if IntInArray(cd[TOrder.F_KindID], KindValues) then
          boxOrderKind.Checked[i] := true;
        Inc(i);
      end;
    finally
      cd.Next;
    end;
  end;
  boxOrderKind.Height := boxOrderKind.ItemHeight * boxOrderKind.Items.Count;
  AdjustGroupBoxHeight(gbOrderKind, boxOrderKind);
end;

{procedure TBaseFilterFrame.FreeProcessList;
begin
  if FProcessList <> nil then FreeAndNil(FProcessList);
end;}

procedure TBaseFilterFrame.FillProcessBox;
var
  cd: TDataSet;
begin
  //FreeProcessList;
  FProcessList := TConfigManager.Instance.GetActiveProcessList;
  boxProcessList.Items.Assign(FProcessList);
  if FCfgChangedID = '' then
    FCfgChangedID := TConfigManager.Instance.ProcessCfgChanged.RegisterHandler(DoOnCfgChanged);
end;

procedure TBaseFilterFrame.RestoreControls;
begin
  if not Assigned(FFilterObj) then Exit;
  RestoringControls := true;
  try
    DoRestoreControls;
  finally
    RestoringControls := false;
  end;
end;

procedure TBaseFilterFrame.DoRestoreControls;
var
  ui: TUserInfo;
  I: integer;
begin
  with FFilterObj do
    begin
      try
        gbNum.Collapsed := not cbNumChecked;
        rbNumEQ.Checked := rbNumEQChecked;
        //udNumEQ.Position := udNumEQPosition;
        edNumEQ.Text := IntToStr(udNumEQPosition);  // 7.11.2005
        rbNumBounds.Checked := rbNumBoundsChecked;
        //udNumLT.Position := udNumLTPosition;
        edNumLT.Text := IntToStr(udNumLTPosition);
        //udNumGT.Position := udNumGTPosition;
        edNumGT.Text := IntToStr(udNumGTPosition);
      except on e: Exception do
        // НЕПОНЯТНАЯ ОШИБКА AV ПОЯВИЛАСЬ. ПРОСТО ЛОВИМ ПОКА.  01.12.2005
        ExceptionHandler.Log_(e);
      end;

      gbOrderKind.Collapsed := not cbOrderKindChecked;
      FillOrderKindBox;

      gbCust.Collapsed := not cbCustChecked;
      cbCustClick(nil);
      if lcCustKeyValue > 0 then
        lcCust.KeyValue := lcCustKeyValue;

      gbMonthYear.Collapsed := not cbMonthYearChecked;
      cbDateType.ItemIndex := cbDateTypeIndex;
      rbYear.Checked := rbYearChecked;
      chbMonth.Checked := cbMonthChecked;
      ceYear.Text := IntToStr(YearValue);
      cbMonth.ItemIndex := MonthValue - 1;
      rbCurMonth.Checked := rbCurMonthChecked;
      rbDateRange.Checked := rbDateRangeChecked;
      rbCurYear.Checked := rbCurYearChecked;
      cbRangeEnd.Checked := cbRangeEndChecked;
      deRangeStart.Value := RangeStartDate;
      deRangeEnd.Value := RangeEndDate;
      rbOneDay.Checked := rbOneDayChecked;
      deOneDay.Value := DateValue;

      gbProcessState.Collapsed := not cbProcessStateChecked;
      FillStateBox(boxProcessState, imProcessState, imDisProcessState,
        TConfigManager.Instance.StandardDics.deProcessExecState, ProcessStateValues);

      gbOrdState.Collapsed := not cbOrdStateChecked;
      //SetChecked(cbOrdState, cbOrdStateChecked);
      FillStateBox(boxOrdState, imOrdState, imDisOrdState,
        TConfigManager.Instance.StandardDics.deOrderState, OrdStateValues);

      gbPayState.Collapsed := not cbPayStateChecked;
      //SetChecked(cbPayState, cbPayStateChecked);
      FillStateBox(boxPayState, imPayState, imDisPayState,
        TConfigManager.Instance.StandardDics.dePayState, PayStateValues);

      //SetChecked(cbComment, cbCommentChecked);
      gbComment.Collapsed := not cbCommentChecked;
      edComment.Text := edCommentText;

      gbExternalId.Collapsed := not ExternalIdChecked;
      edExternalId.Text := ExternalId;

      //SetChecked(cbCreator, cbCreatorChecked);
      gbCreator.Collapsed := not cbCreatorChecked;
      if (UsersCopy <> nil) then
      begin
        cbCreatorName.Items.Assign(UsersCopy);
        if CreatorName <> '' then
        begin
          for I := 0 to UsersCopy.Count - 1 do
          begin
            ui := UsersCopy.Objects[i] as TUserInfo;
            if ui.Login = CreatorName then
            begin
              cbCreatorName.ItemIndex := i;
              break;
            end;
          end;
        end;
      end;

      gbEvent.Collapsed := not cbEventChecked;
      if (UsersCopy <> nil) then
      begin
        cbEventUser.Items.Assign(UsersCopy);
        if EventUserName <> '' then
        begin
          for I := 0 to UsersCopy.Count - 1 do
          begin
            ui := UsersCopy.Objects[i] as TUserInfo;
            if ui.Login = EventUserName then
            begin
              cbEventUser.ItemIndex := i;
              break;
            end;
          end;
        end;
      end;
      edEventText.Text := EventText;
      deRangeStart.Value := EventStartDate;
      deRangeEnd.Value := EventEndDate;

      FillProcessBox;
      SetProcessIndex(FilterProcessID);
      cbProcessInvert.Checked := cbInvertProcessChecked;

      ControlsRestored := true;

      cbNumClick(nil);
      cbMonthYearClick(nil);
      cbCreatorClick(nil);
      cbEventClick(nil);
      cbCommentClick(nil);
      cbOrdStateClick(nil);
      cbPayStateClick(nil);
      cbProcessStateClick(nil);
      gbOrderKindClick(nil);
      gbProcessClick(nil);
      gbExternalIdClick(nil);
    end;
end;

procedure TBaseFilterFrame.Activate;
begin
  FilterActive := true;

  // Создаем копию списка пользователей с полным именем и логином для комбобокса
  if UsersCopy <> nil then UsersCopy.Free;
  UsersCopy := AccessManager.GetUsersCopy;

  EnableDBControls;
  RestoreControls;
  UpdateGroupsEnabledState;
end;

procedure TBaseFilterFrame.UpdateGroupsEnabledState;

  procedure UpdateCheckListBoxState(boxState: TjvxCheckListBox);
  begin
    if boxState.Enabled then
    begin
      boxState.Color := clBtnFace;
      boxState.Font.Color := clWindowText;
    end
    else
    begin
      boxState.Color := clBtnFace;
      boxState.Font.Color := clGray;
    end;
  end;

  procedure UpdateGroupBoxEnabled(GrBox: TjvgGroupBox);
  begin
    if GrBox.Enabled then
    begin
      GrBox.Colors.CaptionActive := clActiveCaption;
      GrBox.Colors.TextActive := clCaptionText;
      GrBox.Colors.Text := clBtnText;
      GrBox.Colors.Caption := FilterInactiveCaptionColor;
    end
    else
    begin
      GrBox.Colors.CaptionActive := clInactiveCaption;
      GrBox.Colors.TextActive := clInactiveCaptionText;
      GrBox.Colors.Text := clInactiveCaptionText;
      GrBox.Colors.Caption := clBtnFace;
    end;
    GrBox.Repaint;
  end;

var
  v: boolean;
begin
  if gbProcessState.Visible then
  begin
    UpdateCheckListBoxState(boxProcessState);
    UpdateGroupBoxEnabled(gbProcessState);
  end;
  v := SupportsOrderState;
  gbOrdState.Enabled := v;
  boxOrdState.Enabled := v;
  UpdateCheckListBoxState(boxOrdState);
  UpdateGroupBoxEnabled(gbOrdState);
  v := SupportsPayState;
  gbPayState.Enabled := v;
  boxPayState.Enabled := v;
  UpdateCheckListBoxState(boxPayState);
  UpdateGroupBoxEnabled(gbPayState);
  v := SupportsExternalId;
  gbExternalId.Visible := v;
  gbExternalId.Enabled := v;
  {$IFDEF Manager}
  gbCust.Enabled := false;
  UpdateGroupBoxEnabled(gbCust);
  gbCreator.Enabled := false;
  UpdateGroupBoxEnabled(gbCreator);
  {$ENDIF}
end;

function TBaseFilterFrame.CheckNumbers: boolean;

  function ValidNum(s: string): boolean;
  var
    i: integer;
  begin
    Result := TryStrToInt(s, i) and (i <> 0);
  end;

begin
  Result := rbNumEQ.Checked and ValidNum(edNumEQ.Text)
      or rbNumBounds.Checked and ValidNum(edNumLT.Text) and ValidNum(edNumGT.Text);
end;

procedure TBaseFilterFrame.cbNumClick(Sender: TObject);
var
  NeedApply: boolean;
begin
  //SetChecked(cbNum, not gbNum.Collapsed);
  if not gbNum.Collapsed then
  begin
    rbNumEQ.Enabled:=true;
    rbNumBounds.Enabled:=true;
    lbNum.Enabled:=true;
    edNumEQ.Enabled:=rbNumEQ.Checked;
    edNumGT.Enabled:=rbNumBounds.Checked;
    edNumLT.Enabled:=rbNumBounds.Checked;
    //udNumEQ.Enabled:=rbNumEQ.Checked;
    //udNumGT.Enabled:=rbNumBounds.Checked;
    //udNumLT.Enabled:=rbNumBounds.Checked;
    if not rbNumEQ.Checked and not rbNumBounds.Checked then rbNumEQ.Checked := true;
    NeedApply := CheckNumbers;
  end
  else
  begin
    rbNumEQ.Enabled:=false;
    rbNumEQ.Checked:=false;
    rbNumBounds.Enabled:=false;
    rbNumBounds.Checked:=false;
    lbNum.Enabled:=false;
    edNumEQ.Enabled:=false;
    edNumGT.Enabled:=false;
    edNumLT.Enabled:=false;
    NeedApply := true;
    //udNumEQ.Enabled:=false;
    //udNumGT.Enabled:=false;
    //udNumLT.Enabled:=false;
  end;
  if NeedApply then
    ApplyFilter
  else
    SaveControls;
end;

procedure TBaseFilterFrame.gbExternalIdClick(Sender: TObject);
begin
  edExternalId.Enabled := not gbExternalId.Collapsed;
  if edExternalId.Text <> '' then
    ApplyFilter
  else
    SaveControls;
end;

procedure TBaseFilterFrame.cbCustClick(Sender: TObject);
begin
  UpdateCustomerControls(gbCust, lcCust, btCustSel);
end;

procedure TBaseFilterFrame.UpdateCustomerControls(GroupBox: TJvgGroupBox;
  ComboBox: TjvDBLookupCombo; SelectButton: TSpeedButton);
begin
  if FilterControlsInUpdate then Exit;
  FilterControlsInUpdate := true;
  try
    if not GroupBox.Collapsed then
    begin
      try
        Customers.Open;
      except on E: Exception do
        begin
          GroupBox.Collapsed := true;
          ExceptionHandler.Raise_(E);
        end;
      end;
      ComboBox.Enabled := true;
      SelectButton.Enabled := true;
      if Customers.DataSet.IsEmpty then
        ComboBox.KeyValue := TContragents.NoNameKey
      else
      try
        ComboBox.KeyValue := GetCustomerKey;
      except
        ComboBox.KeyValue := TContragents.NoNameKey
      end;
    end
    else
    begin
      ComboBox.Enabled := false;
      SelectButton.Enabled := false;
    end;
  finally
    FilterControlsInUpdate := false;
  end;
  ApplyFilter;
end;

procedure TBaseFilterFrame.rbNumEQClick(Sender: TObject);
begin
  edNumEQ.Enabled := rbNumEQ.Checked;
  edNumGT.Enabled := rbNumBounds.Checked;
  edNumLT.Enabled := rbNumBounds.Checked;
  if CheckNumbers then
    ApplyFilter
  else
    SaveControls;
end;

procedure TBaseFilterFrame.btCustSelClick(Sender: TObject);
var
  i, c: integer;
begin
  i := custError;
  if VarIsNull(lcCust.KeyValue) then
    c := TContragents.NoNameKey
  else
    c := lcCust.KeyValue;
  try
    i := ExecContragentSelect(Customers, {CurCustomer} c, {SelectMode=} true);
  except end;
  // custNoName надо обрабатывать иначе ?
  if (i <> custError) and (i <> custNoName) and (i <> custCancel) then
    lcCust.KeyValue := i;
end;

procedure TBaseFilterFrame.btDecDateClick(Sender: TObject);
begin   
  if NvlDateTime(deOneDay.Value) <> NullDate  then
    deOneDay.Value := IncDay(deOneDay.Value, -1);
end;

procedure TBaseFilterFrame.btIncDateClick(Sender: TObject);
begin
  if NvlDateTime(deOneDay.Value) <> NullDate  then
    deOneDay.Value := IncDay(deOneDay.Value, 1);
end;

procedure TBaseFilterFrame.OnCreate;
begin
  cbMonth.Items.Assign(GetMonthList);
  cbDateType.Items.Assign(GetDateList);
  dsCust.DataSet := Customers.DataSet;
  SettingsChanged;
end;

procedure TBaseFilterFrame.EnableDBControls;
begin
  if (dm = nil) then Exit;
  {if lcCust.LookupSource <> dm.dsCust then
    lcCust.LookupSource := dm.dsCust;}
  //if lcCust.LookupSource <> Customers.DataSource then lcCust.LookupSource := Customers.DataSource;
  Customers.Open;
end;

procedure TBaseFilterFrame.DisableDBControls;
begin
  lcCust.LookupSource := nil;
end;

{procedure TBaseFilterFrame.OnHide; // not used
begin
  DisableDBControls;
  if UsersCopy <> nil then FreeAndNil(UsersCopy);
  FreeProcessList;
end;}

{procedure LocateCustName(SrcDS, DstDS: TDataSet; var DstKey: integer);
var
  CustName: string;
  CustOpen: boolean;
begin
  try
    CustName := SrcDS[CustNameField];
    CustOpen := DstDS.Active;
    if not CustOpen then
    try
      DstDS.Open;
    except on E: Exception do begin
        ProcessError(E); Exit;
      end;
    end;
    if DstDS.Locate(CustNameField, CustName, [loCaseInsensitive]) then
      DstKey := DstDS[CustKeyField]
    else
      DstKey := -1;
    if not CustOpen then DstDS.Close;
  except end;
end;}

procedure TBaseFilterFrame.SaveCheckedStateValues(var StateValues: TIntArray; boxState: TJvxCheckListBox);
var
  i, cc: integer;
begin
  SetLength(StateValues, 0);
  cc := 0;
  for i := 0 to Pred(boxState.Items.Count) do
    if boxState.Checked[i] then Inc(cc);
  if cc > 0 then
  begin
    SetLength(StateValues, cc);
    cc := 0;
    for i := 0 to Pred(boxState.Items.Count) do
      if boxState.Checked[i] then begin
        StateValues[cc] := integer(boxState.Items.Objects[i]);
        Inc(cc);
      end;
  end;
end;

{procedure SaveAllStateValues(var StateValues: TIntArray; boxState: TJvxCheckListBox);
var
  i: integer;
begin
  SetLength(StateValues, boxState.Items.Count);
  if boxState.Items.Count > 0 then begin
    for i := 0 to Pred(boxState.Items.Count) do
      StateValues[i] := integer(boxState.Items.Objects[i]);
  end;
end;}

procedure TBaseFilterFrame.SaveControls;
begin
  if FFilterObj <> nil then
    if not FilterControlsInUpdate and FilterActive and not RestoringControls then
      DoSaveControls;
end;

procedure TBaseFilterFrame.DoSaveControls;
var
  CheckedOrderKinds: TIntArray;
begin
  with FFilterObj do
  begin
    cbNumChecked := not gbNum.Collapsed;
    rbNumEQChecked := rbNumEQ.Checked;
    try udNumEQPosition := StrToInt(edNumEQ.Text) except udNumEQPosition := 0; end; //udNumEQ.Position;
    rbNumBoundsChecked := rbNumBounds.Checked;
    //udNumLTPosition := udNumLT.Position;
    //udNumGTPosition := udNumGT.Position;
    try udNumLTPosition := StrToInt(edNumLT.Text) except udNumLTPosition := 0; end;
    try udNumGTPosition := StrToInt(edNumGT.Text) except udNumGTPosition := 0; end;

    cbMonthYearChecked := not gbMonthYear.Collapsed;
    cbDateTypeIndex := cbDateType.ItemIndex;
    cbMonthChecked := chbMonth.Checked;
    rbCurMonthChecked := rbCurMonth.Checked;
    rbYearChecked := rbYear.Checked;
    rbCurYearChecked := rbCurYear.Checked;
    MonthValue := cbMonth.ItemIndex + 1;
    try YearValue := StrToInt(ceYear.Text);
    except end;
    rbDateRangeChecked := rbDateRange.Checked;
    RangeStartDate := deRangeStart.Value;
    RangeEndDate := deRangeEnd.Value;
    cbRangeEndChecked := cbRangeEnd.Checked;
    rbOneDayChecked := rbOneDay.Checked;
    DateValue := deOneDay.Value;

    cbOrderKindChecked := not gbOrderKind.Collapsed;
    {if not CurOrderKindIsDraft then
      SaveCheckedStateValues(WorkOrderKindValues, boxOrderKind)
    else
      SaveCheckedStateValues(DraftOrderKindValues, boxOrderKind);}
    SaveCheckedStateValues(CheckedOrderKinds, boxOrderKind);
    SetCheckedOrderKindValues(Entity, CheckedOrderKinds);

    cbCustChecked := not gbCust.Collapsed;
    if VarIsNull(lcCust.KeyValue) then lcCustKeyValue := TContragents.NoNameKey
    else lcCustKeyValue := lcCust.KeyValue;

    cbCreatorChecked := not gbCreator.Collapsed;
    if cbCreatorName.Enabled then
    try
      if (UsersCopy <> nil) and (cbCreatorName.ItemIndex <> -1) then
        CreatorName := (UsersCopy.Objects[cbCreatorName.ItemIndex] as TUserInfo).Login
      else
        CreatorName := '';
    except CreatorName := ''; end;

    cbEventChecked := not gbEvent.Collapsed;
    if cbEventUser.Enabled then
    try
      if (UsersCopy <> nil) and (cbEventUser.ItemIndex <> -1) then
        EventUserName := (UsersCopy.Objects[cbEventUser.ItemIndex] as TUserInfo).Login
      else
        EventUserName := '';
    except EventUserName := ''; end;
    EventText := edEventText.Text;
    if not VarIsNull(deEventStart.Value) then
      EventStartDate := deEventStart.Value
    else
      EventStartDate := NullDate;
    if not VarIsNull(deEventEnd.Value) then
      EventEndDate := deEventEnd.Value
    else
      EventEndDate := NullDate;

    cbCommentChecked := not gbComment.Collapsed;
    edCommentText := edComment.Text;

    ExternalIdChecked := not gbExternalId.Collapsed;
    ExternalId := edExternalId.Text;

    cbProcessStateChecked := not gbProcessState.Collapsed;
    SaveCheckedStateValues(ProcessStateValues, boxProcessState);

    cbOrdStateChecked := not gbOrdState.Collapsed;
    SaveCheckedStateValues(OrdStateValues, boxOrdState);
    //SaveAllStateValues(AllOrdStateValues, boxOrdState);
    cbPayStateChecked := not gbPayState.Collapsed;
    SaveCheckedStateValues(PayStateValues, boxPayState);
    //SaveAllStateValues(AllPayStateValues, boxPayState);

    if gbProcess.Collapsed then
      FilterProcessID := -1
    else if (boxProcessList.ItemIndex <> -1) then
    begin
      FilterProcessID := TPolyProcessCfg(FProcessList.Objects[boxProcessList.ItemIndex]).SrvID;
      cbInvertProcessChecked := cbProcessInvert.Checked;
    end else
      FilterProcessID := -1;
  end;
end;

{procedure TFilterForm.btShowAllClick(Sender: TObject);
begin
  DisableOrderFilter;  // обязательно сначала это
  SaveControls;        // потом это
end;
}

procedure TBaseFilterFrame.cbCreatorClick(Sender: TObject);
begin
  if (cbCreatorName.ItemIndex <> -1) then
    ApplyFilter
  else
    SaveControls;
end;

procedure TBaseFilterFrame.cbEventClick(Sender: TObject);
begin
  //if (cbEventUser.ItemIndex <> -1) then
    ApplyFilter
  //else
  //  SaveControls;
end;

procedure TBaseFilterFrame.cbCommentClick(Sender: TObject);
begin
  //SetChecked(cbComment, not gbComment.Collapsed);
  edComment.Enabled := not gbComment.Collapsed;
  if edComment.Text <> '' then
    ApplyFilter
  else
    SaveControls;
end;

procedure TBaseFilterFrame.cbOrdStateClick(Sender: TObject);
begin
  boxOrdState.Enabled := not gbOrdState.Collapsed and gbOrdState.Enabled;
  if not gbOrdState.Collapsed then
  begin
    boxOrdState.Font.Color := clWindowText;
    AdjustGroupBoxHeight(gbOrdState, boxOrdState);
  end
  else
    boxOrdState.Font.Color := clGrayText;
  ApplyFilter;
end;

procedure TBaseFilterFrame.cbPayStateClick(Sender: TObject);
begin
  boxPayState.Enabled := not gbPayState.Collapsed and gbPayState.Enabled;
  if not gbPayState.Collapsed then
  begin
    boxPayState.Font.Color := clWindowText;
    AdjustGroupBoxHeight(gbPayState, boxPayState);
  end
  else
    boxPayState.Font.Color := clGrayText;
  ApplyFilter;
end;

procedure TBaseFilterFrame.cbProcessStateClick(Sender: TObject);
begin
  boxProcessState.Enabled := not gbProcessState.Collapsed and gbProcessState.Enabled;
  if not gbProcessState.Collapsed then
  begin
    boxProcessState.Font.Color := clWindowText;
    AdjustGroupBoxHeight(gbProcessState, boxProcessState);
  end
  else
    boxProcessState.Font.Color := clGrayText;
  ApplyFilter;
end;

procedure TBaseFilterFrame.DisableFilter;
begin
  //SetChecked(cbNum, false);
  gbNum.Collapsed := true;
  //SetChecked(cbCust, false);
  gbCust.Collapsed := true;
  //SetChecked(cbMonthYear, false);
  gbMonthYear.Collapsed := true;
  //SetChecked(cbCreator, false);
  gbOrderKind.Collapsed := true;
  gbCreator.Collapsed := true;
  gbEvent.Collapsed := true;
  //SetChecked(cbComment, false);
  gbComment.Collapsed := true;
  gbProcessState.Collapsed := true;
  //SetChecked(cbOrdState, false);
  gbOrdState.Collapsed := true;
  //SetChecked(cbPayState, false);
  gbPayState.Collapsed := true;
  gbExternalId.Collapsed := true;
end;

procedure TBaseFilterFrame.SetFilterObj(Value: TFilterObj);
begin
  FFilterObj := Value;
  if FFilterObj <> nil then begin
    FFilterObj.OnDisableFilter := DisableFilter;
    //FFilterObj.OnRestoreFilter := RestoreControls;
  end;
end;

procedure TBaseFilterFrame.DisableControls;
begin
  UpdateFilterControlsEnabled(false);
end;

procedure TBaseFilterFrame.EnableControls;
begin
  UpdateFilterControlsEnabled(true);
end;

procedure TBaseFilterFrame.edCommentChange(Sender: TObject);
begin
  ApplyFilter;                        
end;

procedure TBaseFilterFrame.edExternalIdChange(Sender: TObject);
begin
  ApplyFilter;
end;

procedure TBaseFilterFrame.lcCustChange(Sender: TObject);
begin
  ApplyFilter;
end;

procedure TBaseFilterFrame.SettingsChanged;
begin
  paFilterHdr.Color := Options.GetColor(sNBack);
  lbFilterHdr.Font.Color := Options.GetColor(sNText);
  if not EntSettings.PermitFilterOff and (fgoCanCollapse in gbMonthYear.Options) then begin
    if gbMonthYear.Collapsed then gbMonthYear.Collapsed := false;
    //Exclude(fgoCanCollapse, gbMonthYear.Options);
    gbMonthYear.Options := gbMonthYear.Options - [fgoCanCollapse];
  end else if EntSettings.PermitFilterOff and not (fgoCanCollapse in gbMonthYear.Options) then
    gbMonthYear.Options := gbMonthYear.Options + [fgoCanCollapse];
end;

procedure TBaseFilterFrame.lcCustGetImage(Sender: TObject; IsEmpty: Boolean;
  var Graphic: TGraphic; var TextMargin: Integer);
begin
  CustomerPainter.JvDbLookupComboGetImage(lcCust, IsEmpty, Graphic, TextMargin);
end;

procedure TBaseFilterFrame.boxPayStateDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Bmp: TBitmap;
  //ImList: TjvImageList;
  TransColor: TColor;
begin
  with Control as TjvxCheckListBox do
  begin
    //Canvas.Brush.Color := clBtnFace;//(Control as TjvxCheckListBox).Color;
    Canvas.FillRect(Rect);
    if Index < Items.Count then
    begin
      if not UseRightToLeftAlignment then
        Inc(Rect.Left, 2)
      else
        Dec(Rect.Right, 2);
      Bmp := nil;
      try
        if Control.Enabled and Checked[Index] then
        begin
          if Control = boxOrdState then
            Bmp := (TConfigManager.Instance.StandardDics.OrderStates.Objects[Index] as TOrderState).Graphic
          //if Control = boxOrdState then ImList := imOrdState
          //else if Control = boxProcessState then ImList := imProcessState
          else if Control = boxProcessState then
            Bmp := (TConfigManager.Instance.StandardDics.ProcessExecStates.Objects[Index] as TOrderState).Graphic
          else
            Bmp := (TConfigManager.Instance.StandardDics.PayStates.Objects[Index] as TOrderState).Graphic
          //else ImList := imPayState;
        end
        else
        begin
          if Control = boxOrdState then
            Bmp := (TConfigManager.Instance.StandardDics.OrderStates.Objects[Index] as TOrderState).DisabledGraphic
          //ImList := imDisOrdState
          //else if Control = boxProcessState then ImList := imDisProcessState
          else if Control = boxProcessState then
            Bmp := (TConfigManager.Instance.StandardDics.ProcessExecStates.Objects[Index] as TOrderState).DisabledGraphic
          else
            Bmp := (TConfigManager.Instance.StandardDics.PayStates.Objects[Index] as TOrderState).DisabledGraphic
          //else ImList := imDisPayState;
        end;
        {if Bmp = nil then
        begin
          Bmp := TBitmap.Create;
          try imList.GetBitmap(Index, Bmp);
          except end;
        end;}
        TransColor := clOlive;
        if (Bmp <> nil) and (Bmp.Height > 0) then
          DrawBitmapTransparent(Canvas, Rect.Left,
            (Rect.Top + Rect.Bottom - Bmp.Height) div 2 - 1, Bmp, TransColor);
        //ImList.Draw(Canvas, Rect.Left, (Rect.Top + Rect.Bottom - 16) div 2, Index, dsNormal, itImage, Control.Enabled);
        DefaultDrawText(Rect.Left + Bmp.Width + 4, Max(Rect.Top, (Rect.Bottom +
          Rect.Top - CanvasMaxTextHeight(Canvas)) div 2 - 1), Items[Index]);
      finally
        //if (Bmp <> nil) and (Control <> boxOrdState) then Bmp.Free;
      end;
    end;
  end;
end;

procedure TBaseFilterFrame.boxOrderKindDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with Control as TjvxCheckListBox do
  begin
    //Canvas.Brush.Color := clBtnFace;//(Control as TjvxCheckListBox).Color;
    Canvas.FillRect(Rect);
    if Index < Items.Count then
    begin
      if not UseRightToLeftAlignment then
        Inc(Rect.Left, 2)
      else
        Dec(Rect.Right, 2);
      DefaultDrawText(Rect.Left, Max(Rect.Top, (Rect.Bottom +
        Rect.Top - CanvasMaxTextHeight(Canvas)) div 2 - 1), Items[Index]);
    end;
  end;
end;

procedure TBaseFilterFrame.cbDateTypeChange(Sender: TObject);
begin
  if FilterControlsInUpdate then Exit;
  ApplyFilter;
end;

procedure TBaseFilterFrame.AdjustGroupBoxHeight(gb: TjvgGroupBox; clb: TjvxCheckListBox);
begin
  if not gb.Collapsed then
    gb.Height := clb.Height + clb.Top + 3;
end;

procedure TBaseFilterFrame.gbOrderKindClick(Sender: TObject);
begin
  boxOrderKind.Enabled := not gbOrderKind.Collapsed and gbOrderKind.Enabled;
  if not gbOrderKind.Collapsed then
  begin
    boxOrderKind.Font.Color := clWindowText;
    AdjustGroupBoxHeight(gbOrderKind, boxOrderKind);
  end
  else
    boxOrderKind.Font.Color := clGrayText;
  ApplyFilter;
end;

procedure TBaseFilterFrame.sbCloseFilterClick(Sender: TObject);
begin
  if Assigned(FOnHideFrame) then FOnHideFrame(Self);
end;

procedure TBaseFilterFrame.gbProcessClick(Sender: TObject);
var
  WasEnabled: boolean;
begin
  WasEnabled := boxProcessList.Enabled;
  boxProcessList.Enabled := not gbProcess.Collapsed and gbProcess.Enabled;
  cbProcessInvert.Enabled := boxProcessList.Enabled;
  if boxProcessList.Enabled and (boxProcessList.ItemIndex <> -1)
    or (WasEnabled and not boxProcessList.Enabled) then
    ApplyFilter
  else
    SaveControls;
end;

procedure TBaseFilterFrame.SetProcessIndex(Index: integer);
var
  i: integer;
  boxProcessIndex: integer;
begin
  boxProcessIndex := -1;
  if Index > 0 then
    for i := 0 to FProcessList.Count - 1 do
      if TPolyProcessCfg(FProcessList.Objects[i]).SrvID = Index then
      begin
        boxProcessIndex := i;
        break;
      end;

  boxProcessList.ItemIndex := boxProcessIndex;
end;

procedure TBaseFilterFrame.boxProcessListChange(Sender: TObject);
begin
  if not FilterControlsInUpdate and boxProcessList.Enabled
      and not boxProcessList.DroppedDown then
    ApplyFilter;
end;

procedure TBaseFilterFrame.boxProcessListCloseUp(Sender: TObject);
begin
  if not FilterControlsInUpdate then
    ApplyFilter;
end;

{function TBaseFilterFrame.CurOrderKindIsDraft: boolean;
begin
  Result := true;
end;}

function TBaseFilterFrame.GetCustomerKey: Integer;
begin
  Result := TContragents.NoNameKey;
end;

function TBaseFilterFrame.SupportsOrderState: boolean;
begin
  Result := false;
end;

function TBaseFilterFrame.SupportsPayState: boolean;
begin
  Result := false;
end;

function TBaseFilterFrame.SupportsExternalId: boolean;
begin
  Result := false;
end;

procedure TBaseFilterFrame.DoOnCfgChanged(Sender: TObject);
var
  i: integer;
  Found: boolean;
begin
  // При изменении конфигурации заполняем новыми процессами
  FillProcessBox;
  if FFilterObj.FilterProcessID <> -1 then
  begin
    // Ищем, жив ли тот процесс, который был раньше
    Found := false;
    for i := 0 to FProcessList.Count - 1 do
      if (FProcessList.Objects[i] as TPolyProcessCfg).SrvID = FFilterObj.FilterProcessID then
      begin
        Found := true;
        break;
      end;
    if not Found then
      FFilterObj.FilterProcessID := -1;
    SetProcessIndex(FFilterObj.FilterProcessID)
  end;
  if not gbProcess.Collapsed then
    ApplyFilter;
end;

procedure TBaseFilterFrame.SetEntity(_Entity: TEntity);
begin
  FEntity := _Entity;
  //DoOnEntityChange;
end;

{procedure TBaseFilterFrame.DoOnEntityChange;
begin
end;}

end.



