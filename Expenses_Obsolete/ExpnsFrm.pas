unit ExpnsFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Grids, DBGrids, JvDBControls, Menus, ComCtrls,
  DB, Mask, DBCtrls, JvCtrls,
  DBClient, JvComponent, JvExControls, JvDBLookup, JvExDBGrids, JvDBGrid,
  JvSpeedButton, JvAppStorage, DBGridEh,

  PmProcess, DicData, DataHlp, MyDBGridEh, ExpData, DicObj, PmUtils;

type
  TExpenseForm = class(TForm)
    btNewComExp: TSpeedButton;
    btDelComExp: TSpeedButton;
    btSaveComExp: TBitBtn;
    pmExp: TPopupMenu;
    pcExp: TPageControl;
    tsExp: TTabSheet;
    tsOwnExp: TTabSheet;
    dgComExp: TMyDBGridEh;
    Label68: TLabel;
    ComGrnItogo: TPanel;
    Bevel1: TBevel;
    Label2: TLabel;
    btToUSD: TSpeedButton;
    dgOwnExp: TMyDBGridEh;
    Label3: TLabel;
    Bevel2: TBevel;
    pmMyExp: TPopupMenu;
    edComExpAdd: TDBEdit;
    edOwnExpAdd: TDBEdit;
    dsComExpKind: TDataSource;
    dsOwnExpKind: TDataSource;
    ComUSDItogo: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    OwnUSDItogo: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    OwnGrnItogo: TPanel;
    lkComExp: TJvDBLookupCombo;
    Label1: TLabel;
    cbRangeEn: TCheckBox;
    btRange: TBitBtn;
    cbMonthEn: TCheckBox;
    cbMonth: TComboBox;
    cbYearEn: TCheckBox;
    edYear: TEdit;
    udYear: TUpDown;
    Bevel3: TBevel;
    Label4: TLabel;
    lkOwnExp: TJvDBLookupCombo;
    btMakeComCat: TJvSpeedButton;
    btMakeOwnCat: TJvSpeedButton;
    procedure btNewComExpClick(Sender: TObject);
    procedure btDelComExpClick(Sender: TObject);
    procedure btSaveComExpClick(Sender: TObject);
    procedure dgComExpColEnter(Sender: TObject);
    procedure pmComExpOtherClick(Sender: TObject);
    procedure pmOwnExpOtherClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure dgComExpColExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btToUSDClick(Sender: TObject);
    procedure btRangeClick(Sender: TObject);
    procedure cbRangeEnClick(Sender: TObject);
    procedure cbMonthEnClick(Sender: TObject);
    procedure cbYearEnClick(Sender: TObject);
    procedure edYearChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pcExpChange(Sender: TObject);
    procedure lkOwnExpChange(Sender: TObject);
    procedure lkComExpChange(Sender: TObject);
    procedure edOwnExpAddKeyPress(Sender: TObject; var Key: Char);
    procedure dgComExpGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure FormDestroy(Sender: TObject);
  private
    function SelectDS: TDataSet;
//    procedure SetupExpKind(de: TDicElement);
//    procedure SetupAllExpKinds;
    procedure ApplyAllAndClose;
    procedure RefreshCurrent;
    procedure UpdateViewRange;
    procedure SelToUSD(ConvMode: integer);   // Локальный пересчет гривен в доллары
    procedure RefreshAll;
    procedure UpdateExpKind(qi: TExpQueryIndex; MakeActive: boolean);
  public
    procedure UpdateItogos;
    procedure UpdateExpItogo(dq: TDataSet; USDPanel, GrnPanel: TPanel);
    procedure SaveSettings(Ini: TJvCustomAppStorage);
    procedure LoadSettings(Ini: TJvCustomAppStorage);
  end;

var
  ExpenseForm: TExpenseForm;

const
  iniRange = 'ExpenseDateRange';
  TrackMonth: boolean = false;  // Отслеживать текущий месяц. Пока не изменяется,
                                // но можно внести в настройки интерфейса
procedure ExecExpenseForm;

implementation

uses MainData, RDialogs, ToUsdFrm, Variants, CalcUtils, CalcSettings,
  MainForm, JvJVCLUtils, rrangefrm, ADOUtils, RDBUtils, MMYYList, PmInit,
  ExHandler;

{$R *.DFM}

procedure ExecExpenseForm;
begin
  try
    Application.CreateForm(TExpenseForm, ExpenseForm);
    Application.CreateForm(TToUSDForm, ToUSDForm);
    ExpenseForm.ShowModal;
  finally
    FreeAndNil(ExpenseForm);
    FreeAndNil(ToUSDForm);
  end;
end;

function TExpenseForm.SelectDS: TDataSet;
begin
  if pcExp.ActivePage = tsExp then Result := ExpDM.cdComExp
  else Result := ExpDM.cdOwnExp;
end;

procedure TExpenseForm.btNewComExpClick(Sender: TObject);
begin
  SelectDS.Append;
end;

procedure TExpenseForm.btDelComExpClick(Sender: TObject);
var dbx: TDataSet;
begin
  dbx := SelectDS;
  if not dbx.IsEmpty then dbx.Delete
  else
    RusMessageDlg('Да тут и так ничего нет...', mtInformation, [mbok], 0);
end;

procedure TExpenseForm.ApplyAllAndClose;
begin
  ApplyTable(ExpDM.cdComExp);
  ExpDM.cdComExp.Active := false;
  ApplyTable(ExpDM.cdOwnExp);
  ExpDM.cdOwnExp.Active := false;
end;

procedure TExpenseForm.btSaveComExpClick(Sender: TObject);
begin
  Close;
end;

procedure TExpenseForm.dgComExpColEnter(Sender: TObject);
begin
{  with Sender as TGridClass do begin
    if SelectedField.FieldName='ExpOther' then begin
      if pcExp.ActivePage = tsExp then
        deComExp.FillPopupMenu(pmExp, -1, -1)
      else
        deOwnExp.FillPopupMenu(pmMyExp, -1, -1)
    end;
  end;
  ToggleEditing(Sender as TGridClass, false);}
end;

procedure TExpenseForm.pmComExpOtherClick(Sender: TObject);
begin
{  ExpDM.cdComExp.edit;
  ExpDM.cdComExp['ExpKind']:=(Sender as TMenuItem).tag;
  ExpDM.cdComExp.CheckBrowseMode;
  dgComExp.Refresh;}
end;

procedure TExpenseForm.pmOwnExpOtherClick(Sender: TObject);
begin
{  ExpDM.cdOwnExp.edit;
  ExpDM.cdOwnExp['ExpKind']:=(Sender as TMenuItem).tag;
  ExpDM.cdOwnExp.CheckBrowseMode;
  dgOwnExp.Refresh;}
end;

procedure TExpenseForm.RefreshCurrent;
begin
  if pcExp.ActivePage = tsExp then begin
    ExpDM.ExpRefresh(qiComExp, true);
    UpdateExpItogo(ExpDM.cdComExp, ComUSDItogo, ComGrnItogo);
  end else begin
    ExpDM.ExpRefresh(qiOwnExp, true);
    UpdateExpItogo(ExpDM.cdOwnExp, OwnUSDItogo, OwnGrnItogo);
  end;
end;
{
procedure TExpenseForm.SetupAllExpKinds;
begin
  SetupExpKind(mtComExpKind, deComExp);
  SetupExpKind(mtOwnExpKind, deMyExp);
end;
}
procedure TExpenseForm.FormActivate(Sender: TObject);
begin
  cbMonth.ItemIndex := CurMonth - 1;
  udYear.Position := CurYear;
  ActiveControl := btSaveComExp;
//  SetupAllExpKinds;
  RefreshAll;
  pcExpChange(Sender);
end;

procedure TExpenseForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  try   // Сохраняет без вопросов
    if ExpDM.cdComExp.Active or ExpDM.cdOwnExp.Active then begin
      ExpDM.cdComExp.CheckBrowseMode;
      ExpDM.cdOwnExp.CheckBrowseMode;
      if (ExpDM.cdComExp.ChangeCount > 0) or (ExpDM.cdOwnExp.ChangeCount > 0) then begin
         btSaveComExpClick(Sender);
      end;
      CanClose := true;
    end else
      CanClose := true;
  except CanClose := true; end;
end;

procedure TExpenseForm.dgComExpColExit(Sender: TObject);
begin
//  ToggleEditing(Sender as TGridClass, true);
end;

procedure TExpenseForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if MForm <> nil then begin
    SaveSettings(MForm.AppStorage);
    SaveColumns(MForm.AppStorage, dgComExp, iniInterface + '\CommonExpense');
    SaveColumns(MForm.AppStorage, dgOwnExp, iniInterface + '\OwnExpense');
  end;
  ApplyAllAndClose;
end;

procedure TExpenseForm.UpdateItogos;
begin
  UpdateExpItogo(ExpDM.cdComExp, ComUSDItogo, ComGrnItogo);
  UpdateExpItogo(ExpDM.cdOwnExp, OwnUSDItogo, OwnGrnItogo);
end;

procedure TExpenseForm.UpdateExpItogo(dq: TDataSet; USDPanel, GrnPanel: TPanel);
begin
  try
    if dq.IsEmpty then begin
      FormatTotal(0, USDPanel);
      FormatTotal(0, GrnPanel);
      Exit;
    end;
    //FormatTotal(CalcCommonTotal(dq, 'CostUSD'), USDPanel);  // TODO: Отключено при переделке 02.2006
    //FormatTotal(CalcCommonTotal(dq, 'CostGrn'), GrnPanel);
  except end;
end;

procedure TExpenseForm.SelToUSD(ConvMode: integer);   // Локальный пересчет гривен в доллары
var
  bm: TBookmark;
  dq: TClientDataSet;

  procedure ConvertRecord;
  begin
    // Логика пересчета дублируется на сервере процедурой up_ComExpToUSD
    if (VarIsNull(dq['CostUSD']) or (dq['CostUSD'] = 0)) and
      not VarIsNull(dq['CostGrn']) and (dq['CostGrn'] <> 0) then begin
      if not (dq.State in [dsEdit, dsInsert]) then dq.Edit;
      dq['CostUSD'] := dq['CostGrn'] / ToUSDForm.USDCourse;
      // CostGrn обнуляется автоматически
    end;
  end;

begin
  MForm.AllNotifIgnore := true;
  try
    if pcExp.ActivePage = tsExp then dq := ExpDm.cdComExp else dq := ExpDm.cdOwnExp;
    if not dq.Active or dq.IsEmpty then Exit;
    bm := dq.GetBookmark;
    try
      if ConvMode = cmCurRec then ConvertRecord  // Одну строку пересчитываем
      else begin                                 // Весь диапазон
        dq.First;
        while not dq.EOF do begin
          ConvertRecord;
          dq.Next;
        end;
        dq.Gotobookmark(bm);
        dq.Freebookmark(bm);
      end;
      ApplyTable(dq);
    except on E: EDatabaseError do begin
        dq.CancelUpdates;
        ExceptionHandler.Raise_(E);
      end;
    end;
  finally
    MForm.AllNotifIgnore := false;
  end;
end;

procedure TExpenseForm.btToUSDClick(Sender: TObject);
var
  Code: integer;
begin
  if ToUSDForm.ShowModal = mrOk then begin
    if (ToUSDForm.ConvertMode = cmCurSel) or (ToUSDForm.ConvertMode = cmCurRec) then begin
       // надо пересчитать локально
      SelToUSD(ToUSDForm.ConvertMode);
      RefreshCurrent;
      Exit;
    end;                                    // в остальных режимах - считаем на сервере
    ApplyTable(ExpDM.cdComExp);
    ApplyTable(ExpDM.cdOwnExp);

    ExpDM.aspComExpToUSD.Parameters.ParamByName('@Course').Value := ToUSDForm.USDCourse;
    ExpDM.aspComExpToUSD.Parameters.ParamByName('@Mode').Value := ToUSDForm.ConvertMode;
    ExpDM.aspComExpToUSD.Parameters.ParamByName('@FromDate').Value := Now;  // не используется
    ExpDM.aspComExpToUSD.Parameters.ParamByName('@ToDate').Value := Now;    // не используется
    if pcExp.ActivePage = tsExp then begin
      if (lkComExp.Value = '') or ExpDM.cdComExpKind.IsEmpty then Code := -1
      else Code := ExpDM.cdComExpKind[DicItemCodeField];
    end else begin
      if (lkOwnExp.Value = '') or ExpDM.cdOwnExpKind.IsEmpty then Code := -1
      else Code := ExpDM.cdOwnExpKind[DicItemCodeField];
    end;
    ExpDM.aspComExpToUSD.Parameters.ParamByName('@ExpKind').Value := Code;
    ExpDM.aspComExpToUSD.Parameters.ParamByName('@OwnExp').Value := pcExp.ActivePage = tsOwnExp;
    if not ExpDM.InTransaction then ExpDM.BeginTrans;
    try
      ExpDM.aspComExpToUSD.ExecProc;
      // Есть еще параметр @OK, но он пока не вычисляется и не проверяется.
      // (был) - пока я его вообще убил
      ExpDM.CommitTrans;
    except
       on E: EDatabaseError do begin
         ExpDM.RollbackTrans;
         ExceptionHandler.Raise_(E);
       end;
    end;
    RefreshCurrent;
  end;
end;

procedure TExpenseForm.UpdateViewRange;
begin
  MForm.AllNotifIgnore := true;
  try
    ApplyTable(ExpDM.cdComExp);
    ApplyTable(ExpDM.cdOwnExp);
    RefreshAll;
    {SetViewRange(qiComExp, true, false);
    SetViewRange(qiOwnExp, true, false);}
    UpdateItogos;
  finally
    MForm.AllNotifIgnore := false;
  end;
end;

// ====================== Диапазон дат: общий код! =============================
// ==========     см. DocFrm (документация) и Common/OrdSel(без кнопки Range) ==

procedure TExpenseForm.btRangeClick(Sender: TObject);
begin
  if ShowRangeForm(btRange, rpRight, RangeStart, RangeEnd) = mrOk then begin
    NoUpdate := true;
    cbMonthEn.Checked := false;
    cbMonthEnClick(Sender);
    cbYearEn.Checked := false;
    cbYearEnClick(Sender);
    cbRangeEn.Checked := true;
    RangeEn := true;
    NoUpdate := false;
    UpdateViewRange;
  end{ else begin
    RangeForm.deStart.Date := RangeStart;
    RangeForm.deEnd.Date := RangeEnd;
  end};
end;

procedure TExpenseForm.cbRangeEnClick(Sender: TObject);
begin
  if cbRangeEn.Checked then begin
    cbMonthEn.Checked := false;
    CurMonthEn := false;
    cbYearEn.Checked := false;
    CurYearEn := false;
    RangeEn := true;
//    cbRangeEn.Checked := true;
  end else
    RangeEn := false;
  if NoUpdate then Exit;
  UpdateViewRange;
end;

procedure TExpenseForm.cbMonthEnClick(Sender: TObject);
begin
  CurMonthEn := cbMonthEn.Checked;
  cbMonth.Enabled := CurMonthEn;
  RangeEn := not CurMonthEn and not CurYearEn and RangeEn;
  cbRangeEn.Checked := RangeEn;
  if NoUpdate then Exit;
  UpdateViewRange;
end;

procedure TExpenseForm.cbYearEnClick(Sender: TObject);
begin
  CurYearEn := cbYearEn.Checked;
  udYear.Enabled := CurYearEn;
  edYear.Enabled := CurYearEn;
  RangeEn := not CurMonthEn and not CurYearEn and RangeEn;
  cbRangeEn.Checked := RangeEn;
  if NoUpdate then Exit;
  UpdateViewRange;
end;

procedure TExpenseForm.edYearChange(Sender: TObject);
begin
  if NoUpdate then Exit;
  try
    if (dm = nil) or not ExpDM.Connected then Exit;
    CurMonth := cbMonth.ItemIndex + 1;
    CurYear := udYear.Position;
    UpdateViewRange;
  except end;
end;

procedure TExpenseForm.SaveSettings(Ini: TJvCustomAppStorage);
begin
  try
    Ini.WriteInteger(iniRange + '\CurMonth', CurMonth);
    Ini.WriteInteger(iniRange + '\CurMonthEnabled', Ord(CurMonthEn));
    Ini.WriteInteger(iniRange + '\CurYear', CurYear);
    Ini.WriteInteger(iniRange + '\CurYearEnabled', Ord(CurYearEn));
    Ini.WriteInteger(iniRange + '\RangeEnabled', Ord(RangeEn));
    Ini.WriteDateTime(iniRange + '\RangeStart', RangeStart);
    Ini.WriteDateTime(iniRange + '\RangeEnd', RangeEnd);
  except end;
end;

procedure TExpenseForm.LoadSettings(Ini: TJvCustomAppStorage);
var
  Present: TDatetime;
begin
  try
    // ====================== Диапазон дат: общий код! =============================
    // ==========      см. InitForm (документация) и InitForm (экспедиция) ===========
    // если будет меняться, тогда можно было бы и внешнюю процедуру сделать
    NoUpdate := true;
    Present := Now;

    try CurMonthEn := Ini.ReadString(iniRange + '\CurMonthEnabled', '0') = '1';
    except on Exception do CurMonthEn := false; end;
    cbMonth.Enabled := CurMonthEn;
    cbMonthEn.Checked := CurMonthEn;
    if TrackMonth then
      CurMonth := GetMonth(Present)
    else
      try CurMonth := StrToInt(Ini.ReadString(iniRange + '\CurMonth', '1'));
      except on Exception do CurMonth := 1; end;
    cbMonth.ItemIndex := CurMonth - 1;

    try CurYearEn := Ini.ReadString(iniRange + '\CurYearEnabled', '0') = '1';
    except on Exception do CurYearEn := false; end;
    udYear.Enabled := CurYearEn;
    edYear.Enabled := CurYearEn;
    cbYearEn.Checked := CurYearEn;
    if TrackMonth then
      CurYear := GetYear(Present)
    else
      try CurYear := StrToInt(Ini.ReadString(iniRange + '\CurYear', '2000'));
      except on Exception do CurYear := 2000; end;
    udYear.Position := CurYear;

    try RangeEn := Ini.ReadString(iniRange + '\RangeEnabled', '0') = '1';
    except on Exception do RangeEn := false; end;
    cbRangeEn.Checked := RangeEn;
    try RangeStart := Ini.ReadDateTime(iniRange + '\RangeStart', Present);
    except on Exception do RangeStart := Present end;
    try RangeEnd := Ini.ReadDateTime(iniRange + '\RangeEnd', Present);
    except on Exception do RangeEnd := Present end;

    NoUpdate := false;
  except end;
end;

procedure TExpenseForm.FormCreate(Sender: TObject);
begin
  cbMonth.Items.Assign(GetMonthList);
  if MForm <> nil then
  LoadSettings(MForm.AppStorage);
  LoadColumns(MForm.AppStorage, dgComExp, iniInterface + '\CommonExpense');
  LoadColumns(MForm.AppStorage, dgOwnExp, iniInterface + '\OwnExpense');
  dsComExpKind.DataSet := ExpDM.cdComExpKind;
  dsOwnExpKind.DataSet := ExpDM.cdOwnExpKind;
  dgComExp.Columns[0].DropdownBox.ListSource := dsComExpKind;
  dgOwnExp.Columns[0].DropdownBox.ListSource := dsOwnExpKind;
end;

procedure TExpenseForm.pcExpChange(Sender: TObject);
begin
  if pcExp.ActivePage = tsExp then begin
    lkComExp.Visible := true;
    lkOwnExp.Visible := false;
  end else begin
    lkComExp.Visible := false;
    lkOwnExp.Visible := true;
  end;
end;

procedure TExpenseForm.lkOwnExpChange(Sender: TObject);
begin
  MForm.AllNotifIgnore := true;
  try
    ApplyTable(ExpDM.cdOwnExp);
    UpdateExpKind(qiOwnExp, false);  // Раньше делалось при каждом рефреше
    ExpDM.ExpRefresh(qiOwnExp, true);
    UpdateItogos;
  finally
    MForm.AllNotifIgnore := false;
  end;
end;

procedure TExpenseForm.lkComExpChange(Sender: TObject);
begin
  MForm.AllNotifIgnore := true;
  try
    ApplyTable(ExpDM.cdComExp);
    UpdateExpKind(qiComExp, false);
    ExpDM.ExpRefresh(qiComExp, true);
    UpdateItogos;
  finally
    MForm.AllNotifIgnore := false;
  end;
end;

procedure TExpenseForm.edOwnExpAddKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    FocusControl(FindNextControl(Sender as TWinControl, true, true, false));
    Key := #0;
  end;
end;

procedure TExpenseForm.dgComExpGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  try
    if (Column <> nil) and (Column.Field.DataSet.Active)
       and not (gdFocused in State) and not (gdSelected in State) then begin
      if Column.Field.DataSet['ExpKind'] = 0 then
        AFont.Color := clNavy
      else
        AFont.Color := clWindowText;
    end;
  except end;
end;

procedure TExpenseForm.FormDestroy(Sender: TObject);
begin
  {deComExp.OnPopupSelected := nil;
  deOwnExp.OnPopupSelected := nil;}
end;

procedure TExpenseForm.UpdateExpKind(qi: TExpQueryIndex; MakeActive: boolean);
var
  m: TDataSet;
  lk: TJvDBLookupCombo;
begin
  try
    if qi = qiOwnExp then begin m := ExpDM.cdOwnExpKind; lk := lkOwnExp end
    else begin m := ExpDM.cdComExpKind; lk := lkComExp end;
    if m.Active and not m.IsEmpty and (lk.Value <> '') then
      ExpDM.SetExpKind(qi, m[DicItemCodeField], MakeActive, false)
    else
      ExpDM.SetExpKind(qi, -1, MakeActive, false);
  except end;
end;

procedure TExpenseForm.RefreshAll;
begin
  ExpDM.ExpRefresh(qiComExp, true);
  ExpDM.ExpRefresh(qiOwnExp, true);
  UpdateItogos;
end;

end.
