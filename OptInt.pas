unit optint;

{$I Calc.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Mask, JvToolEdit, JvBaseEdits, ComCtrls,
  {$IFDEF IniStorage}IniFiles,{$ENDIF}
  DB, Variants, JvExControls, JvComponent, JvDBLookup, JvExMask, JvAppStorage,
  CalcSettings, JvExStdCtrls, JvListBox, JvCombobox, JvColorCombo, Grids,
  DBGridEh, MyDBGridEh, DBClient, GridsEh, Spin, DBGridEhGrouping;

type
  TOptIntForm = class(TForm)
    btOk: TBitBtn;
    btCancel: TBitBtn;
    pcOptions: TPageControl;
    tsCommon: TTabSheet;
    tsView: TTabSheet;
    ColorDlg: TColorDialog;
    gbPanel: TGroupBox;
    cbGrayBtn: TCheckBox;
    cbFlatBtn: TCheckBox;
    feBack: TJvFilenameEdit;
    cbBack: TCheckBox;
    tsDoc: TTabSheet;
    Label3: TLabel;
    dirDoc: TJvDirectoryEdit;
    cbConfDel: TCheckBox;
    cbAutoOpen: TCheckBox;
    cbCheckDep: TCheckBox;
    tsWork: TTabSheet;
    GroupBox2: TGroupBox;
    rbStateRowColor: TRadioButton;
    rbUserRowColor: TRadioButton;
    cbCustConfDel: TCheckBox;
    cbHideOnEdit: TCheckBox;
    tsConnection: TTabSheet;
    cbSaveUser: TCheckBox;
    rgFilter: TRadioGroup;
    GroupBox4: TGroupBox;
    cbCheckEXEUpdate: TCheckBox;
    cbCheckXLSUpdate: TCheckBox;
    GroupBox5: TGroupBox;
    cbEnterAsTab: TCheckBox;
    cbAutoAppend: TCheckBox;
    cbCopyToWork: TCheckBox;
    GroupBox6: TGroupBox;
    edPageCostRowHeight: TEdit;
    udPageCostRowHeight: TUpDown;
    Label7: TLabel;
    cbPageCostRowLines: TCheckBox;
    clNewColor: TJvColorComboBox;
    cdColors: TClientDataSet;
    dsColors: TDataSource;
    cdColorsColorDesc: TStringField;
    cdColorsColorValue: TIntegerField;
    cdColorsColorName: TStringField;
    MyDBGridEh1: TMyDBGridEh;
    cbShowProcessCount: TCheckBox;
    gbErrHandling: TGroupBox;
    rbErrorEdit: TRadioButton;
    rbErrorMsg: TRadioButton;
    cbNewAtEnd: TCheckBox;
    cbEnableVB: TCheckBox;
    Label1: TLabel;
    boxFonts: TJvFontComboBox;
    cbVerboseLog: TCheckBox;
    cbMarkUrgent: TCheckBox;
    Label5: TLabel;
    edUrgent: TSpinEdit;
    Label8: TLabel;
    cbShowUserLogin: TCheckBox;
    GroupBox3: TGroupBox;
    cbShowOrderState: TCheckBox;
    cbShowPayState: TCheckBox;
    cbShowShipmentState: TCheckBox;
    cbShowLockState: TCheckBox;
    cbShortExcel: TCheckBox;
    tsInvoice: TTabSheet;
    tsSchedule: TTabSheet;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    edScheduleFontSize: TSpinEdit;
    cbScheduleShowCost: TCheckBox;
    boxGridFonts: TJvFontComboBox;
    cbShowTotalInvoices: TCheckBox;
    Label9: TLabel;
    tsMat: TTabSheet;
    cbEditMatRequest: TCheckBox;
    cbShowTotalMatRequests: TCheckBox;
    Label10: TLabel;
    Label11: TLabel;
    cbOpenOffice: TCheckBox;
    cbShowMatDateInWorkOrderPreview: TCheckBox;
    cbConfirmQuit: TCheckBox;
    procedure btOkClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cbBackClick(Sender: TObject);
    procedure cdColorsBeforeScroll(DataSet: TDataSet);
    procedure cdColorsAfterScroll(DataSet: TDataSet);
  private
    FillingColors, WasActive: boolean;
    procedure ApplyColors;
    procedure FillColors;
  public
    procedure SetOptions;
  end;

function ExecOptIntForm: integer;

implementation

uses JvSpeedbar, RDialogs,
  ADOUtils, RDBUtils, JvJVCLUtils, PmAppController;

{$R *.DFM}

function ExecOptIntForm: integer;
var
  OptIntForm: TOptIntForm;
begin
  Application.CreateForm(TOptIntForm, OptIntForm);
  try
    OptIntForm.SetOptions;
    Result := OptIntForm.ShowModal;
  finally
    FreeAndNil(OptIntForm);
  end;
end;

function Int64ToInt(i: int64): integer;
var x: int64; ix: integer absolute x;
begin
  x := i; Result := ix;
end;

procedure TOptIntForm.ApplyColors;
begin
  cdColors.First;
  while not cdColors.eof do
  begin
    Options.SetNewColor(cdColors['ColorName'], cdColors['ColorValue']);
    cdColors.Next;
  end;
end;

procedure TOptIntForm.btOkClick(Sender: TObject);
//var
//  OldFS: TFullStateType;
begin
  TSettingsManager.Instance.NeedReload := false;
  ApplyColors;

  Options.VerboseLog := cbVerboseLog.Checked;
  //Options.ShowFinalNative := cbShowFinalNative.Checked;
  Options.CheckDep := cbCheckDep.Checked;
  if Options.NewAtEnd <> cbNewAtEnd.Checked then
  begin
    Options.NewAtEnd := cbNewAtEnd.Checked;
    AppController.UpdateSortOrder(false); // Установка порядка сортировки
    TSettingsManager.Instance.NeedReload := true;
  end;

  Options.ErrorEdit := rbErrorEdit.Checked;
  Options.ProcessAutoAppend := cbAutoAppend.Checked;
  Options.ProcessEnterAsTab := cbEnterAsTab.Checked;
  // Настройка тулбара
  Options.FlatBtn := cbFlatBtn.Checked;
  Options.GrayBtn := cbGrayBtn.Checked;
  Options.CheckEXEUpdate := cbCheckEXEUpdate.Checked;
  Options.CheckXLSUpdate := cbCheckXLSUpdate.Checked;
  Options.LinkFolderStr := dirDoc.Text;
  Options.ConfirmDelete := cbConfDel.Checked;
  Options.ContragentConfirmDelete := cbCustConfDel.Checked;
  Options.ShowOrderState := cbShowOrderState.Checked;
  Options.OrdStateRowColor := rbStateRowColor.Checked;
  Options.ShowPayState := cbShowPayState.Checked;
  Options.ShowShipmentState := cbShowShipmentState.Checked;
  Options.ShowLockState := cbShowLockState.Checked;
  Options.ConfirmQuit := cbConfirmQuit.Checked;
  //OldFS := Options.FullOrdStateMode;
  //Options.FullOrdStateMode := fsEdit;
  // При изменении режима перечитать поля сервисов, т.к. некоторые могут не обновляться
  // или наоборот, теперь обновляться.
  //if OldFS <> Options.FullOrdStateMode then sdm.RefreshProcessCfg;  // 21.10.2008 пока убрал
  Options.ShowProcessCount := cbShowProcessCount.Checked;

  Options.AutoOpen := cbAutoOpen.Checked;
  Options.HideOnEdit := cbHideOnEdit.Checked;

  Options.PageCostRowHeight := udPageCostRowHeight.Position;
  Options.PageCostRowLines := cbPageCostRowLines.Checked;

  Options.BackEn := cbBack.Checked;
  Options.fnBack := feBack.Text;
  if CompareText(ExtractFileDir(Options.fnBack), ExtractFileDir(ParamStr(0))) = 0 then
    Options.fnBack := ExtractFileName(Options.fnBack);

  Options.EnableVB := cbEnableVB.Checked;
  Options.ShortExcel := cbShortExcel.Checked;
  Options.ShowUserLogin := cbShowUserLogin.Checked;
  TSettingsManager.Instance.XPFontName := boxFonts.FontName;

  Options.ScheduleFontSize := edScheduleFontSize.Value;
  Options.ScheduleFontName := boxGridFonts.FontName;
  Options.ScheduleShowCost := cbScheduleShowCost.Checked;
  Options.MarkUrgentOrders := cbMarkUrgent.Checked;
  Options.UrgentHours := edUrgent.Value;
  Options.ShowTotalInvoices := cbShowTotalInvoices.Checked;
  Options.EditMatRequest := cbEditMatRequest.Checked;
  Options.ShowTotalMatRequests := cbShowTotalMatRequests.Checked;
  Options.OpenOffice := cbOpenOffice.Checked;
  Options.ShowMatDateInWorkOrderPreview := cbShowMatDateInWorkOrderPreview.Checked;

  TSettingsManager.Instance.SettingsChanged.Notify(Self);
  TSettingsManager.Instance.NeedReload := false;

  TSettingsManager.Instance.SaveInterfaceSettings;  // и сразу сохраняем
end;

procedure TOptIntForm.btCancelClick(Sender: TObject);
begin
  SetOptions;
end;

procedure TOptIntForm.FillColors;
var
  i: integer;
  co: TColorObj;
begin
  FillingColors := true;
  if cdColors.Active then cdColors.Close;
  cdColors.CreateDataSet;
  if Options.ColorList.Count > 0 then
    for i := 0 to Pred(Options.ColorList.Count) do begin
      co := Options.ColorList.Objects[i] as TColorObj;
      cdColors.Append;
      cdColors['ColorName'] := Options.ColorList[i];
      cdColors['ColorDesc'] := co.ColorDesc;
      cdColors['ColorValue'] := co.Color;
    end;
  cdColors.CheckBrowseMode;
  FillingColors := false;
  cdColorsAfterScroll(cdColors);
end;

procedure TOptIntForm.SetOptions;
begin
  FillColors;

  //cbShowFinalNative.Checked := Options.ShowFinalNative;
  cbVerboseLog.Checked := Options.VerboseLog;
  cbCheckDep.Checked := Options.CheckDep;
  cbSaveUser.Checked := Options.SaveUser;
  cbNewAtEnd.Checked := Options.NewAtEnd;
  cbAutoOpen.Checked := Options.AutoOpen;
  rgFilter.ItemIndex := Ord(Options.ServFilter);
  cbGrayBtn.Checked := Options.GrayBtn;
  cbFlatBtn.Checked := Options.FlatBtn;
  cbAutoAppend.Checked := Options.ProcessAutoAppend;
  cbEnterAsTab.Checked := Options.ProcessEnterAsTab;
  rbErrorEdit.Checked := Options.ErrorEdit;
  cbEnableVB.Checked := Options.EnableVB;
  cbShortExcel.Checked := Options.ShortExcel;
  cbShowUserLogin.Checked := Options.ShowUserLogin;
  boxFonts.FontName := TSettingsManager.Instance.XPFontName;

  // картинки
  cbBack.Checked := Options.BackEn;
  feBack.Text := Options.fnBack;
  cbCheckEXEUpdate.Checked := Options.CheckEXEUpdate;
  cbCheckXLSUpdate.Checked := Options.CheckXLSUpdate;
  dirDoc.Text := Options.LinkFolderStr;
  cbConfDel.Checked := Options.ConfirmDelete;
  cbCustConfDel.Checked := Options.ContragentConfirmDelete;
  cbHideOnEdit.Checked := Options.HideOnEdit;
  cbShowOrderState.Checked := Options.ShowOrderState;
  rbStateRowColor.Checked := Options.OrdStateRowColor;
  cbShowPayState.Checked := Options.ShowPayState;
  cbShowShipmentState.Checked := Options.ShowShipmentState;
  cbShowLockState.Checked := Options.ShowLockState;
  cbMarkUrgent.Checked := Options.MarkUrgentOrders;
  edUrgent.Value := Options.UrgentHours;
  rbUserRowColor.Checked := not Options.OrdStateRowColor;
  cbShowProcessCount.Checked := Options.ShowProcessCount;
  cbShowTotalInvoices.Checked := Options.ShowTotalInvoices;
  cbConfirmQuit.Checked := Options.ConfirmQuit;

  udPageCostRowHeight.Position := Options.PageCostRowHeight;
  cbPageCostRowLines.Checked := Options.PageCostRowLines;

  edScheduleFontSize.Value := Options.ScheduleFontSize;
  boxGridFonts.FontName := Options.ScheduleFontName;
  cbScheduleShowCost.Checked := Options.ScheduleShowCost;

  cbEditMatRequest.Checked := Options.EditMatRequest;
  cbShowTotalMatRequests.Checked := Options.ShowTotalMatRequests;
  cbOpenOffice.Checked := Options.OpenOffice;
  cbShowMatDateInWorkOrderPreview.Checked := Options.ShowMatDateInWorkOrderPreview;
end;

procedure TOptIntForm.FormActivate(Sender: TObject);
begin
  if not WasActive then
  begin
    SetOptions;
    WasActive := true;
  end;
end;

procedure TOptIntForm.cbBackClick(Sender: TObject);
begin
  feBack.Enabled := cbBack.Checked;
end;

procedure TOptIntForm.cdColorsBeforeScroll(DataSet: TDataSet);
begin
  if not FillingColors then begin
    cdColors.Edit;
    cdColors['ColorValue'] := clNewColor.ColorValue;
    cdColors.Post;
  end;
end;

procedure TOptIntForm.cdColorsAfterScroll(DataSet: TDataSet);
begin
  if not FillingColors then
    clNewColor.ColorValue := cdColors['ColorValue'];
end;

end.
