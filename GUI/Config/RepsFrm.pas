unit RepsFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, JvDBControls, JvDBCombobox, ExtCtrls, ComCtrls, CodeEdit,
  DB, JvComponent, JvFormPlacement, DBGridEh, MyDBGridEh, JvExStdCtrls,
  JvComponentBase, GridsEh, DBGridEhGrouping, JvCombobox, Mask, DBCtrlsEh,
  DBLookupEh;

type
  TReportsForm = class(TForm)
    btOk: TButton;
    btCancel: TButton;
    btEdit: TButton;
    btDelete: TButton;
    btAdd: TButton;
    pgGlobal: TPageControl;
    tsReports: TTabSheet;
    tsGlobal: TTabSheet;
    tsForms: TTabSheet;
    Panel1: TPanel;
    Label2: TLabel;
    cbShortCut: TJvDBComboBox;
    DBCheckBox1: TDBCheckBox;
    dgForms: TMyDBGridEh;
    Panel2: TPanel;
    btEditDfm: TButton;
    DBCheckBox3: TDBCheckBox;
    dbcDefault: TDBCheckBox;
    dgOrdScripts: TMyDBGridEh;
    btSave: TButton;
    btLoad: TButton;
    btUpdate: TButton;
    OpenDlg: TOpenDialog;
    SaveDlg: TSaveDialog;
    ReportStorage: TJvFormStorage;
    dgReports: TMyDBGridEh;
    DBCheckBox2: TDBCheckBox;
    Label1: TLabel;
    dsReportGroups: TDataSource;
    cbReportGroup: TDBLookupComboboxEh;
    procedure btEditClick(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btEditDfmClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure pgGlobalChange(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btLoadClick(Sender: TObject);
    procedure btUpdateClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure GetShortCutProc(S: string; SC: TShortCut);
    //procedure EditScript(cd: TDataSet; NameField, DescField, ScriptField: string);
    procedure EditReport;
    procedure EditFormScript;
    procedure EditOrderScript;
    procedure EditFormDfm;
    procedure UpdateButtons;
    procedure SavePosition(ds: TDataSet; Key: string; KeyField: string);
    procedure LoadPosition(ds: TDataSet; Key: string; KeyField: string);
    procedure GetCurData(var cd: TDataSet; var s, ss: string);
  public
  end;

var
  ReportsForm: TReportsForm;

function ExecReportsForm: integer;

const
  InsideTag = 1000;  // Признак MenuItem, что отчет работает при открытом заказе.

implementation

{$R *.DFM}

uses RepData, EScrFrm, ShortCt, ServData, RDBUtils, PmProcess, RDialogs,
  Variants, CalcSettings, PmConfigManager;

function ExecReportsForm: integer;
begin
  try
    rdm.CloseAll;
    rdm.OpenAll;
    Application.CreateForm(TReportsForm, ReportsForm);
    ReportsForm.ReportStorage.AppStorage := TSettingsManager.Instance.Storage;
    Result := ReportsForm.ShowModal;
    if Result = mrOk then
      rdm.ApplyAll
    else
      rdm.CancelAll;
  finally
    FreeAndNil(ReportsForm);
  end;
end;

procedure TReportsForm.EditReport;
begin
  EditScript(rdm.cdReports, F_ScriptName, F_ScriptDesc, ScriptField, FormDateField);
end;

procedure TReportsForm.EditFormScript;
begin
  EditScript(rdm.cdForms, FormNameField, FormDescField, FormPasField, FormDateField);
end;

procedure TReportsForm.EditOrderScript;
begin
  EditScript(rdm.cdOrdScripts, F_ScriptName, F_ScriptDesc, ScriptField, FormDateField);
end;

procedure TReportsForm.EditFormDfm;
begin
  EditScript(rdm.cdForms, FormNameField, FormDescField, FormDfmField, FormDateField);
end;

procedure TReportsForm.btEditClick(Sender: TObject);
begin
  if pgGlobal.ActivePage = tsGlobal then EditOrderScript
  else if pgGlobal.ActivePage = tsReports then EditReport
  else if pgGlobal.ActivePage = tsForms then EditFormScript;
end;

procedure TReportsForm.btEditDfmClick(Sender: TObject);
begin
  EditFormDfm;
end;

procedure TReportsForm.btAddClick(Sender: TObject);
begin
  if pgGlobal.ActivePage = tsGlobal then
  else if pgGlobal.ActivePage = tsReports then rdm.cdReports.Append
  else if pgGlobal.ActivePage = tsForms then rdm.cdForms.Append;
end;

procedure TReportsForm.btDeleteClick(Sender: TObject);
begin
  if pgGlobal.ActivePage = tsGlobal then
  else if pgGlobal.ActivePage = tsReports then begin
    if rdm.cdReports.Active and not rdm.cdReports.IsEmpty and
      (RusMessageDlg('Вы действительно хотите удалить отчет?',
        mtConfirmation, mbYesNoCancel, 0) = mrYes) then
      rdm.cdReports.Delete;
  end else if pgGlobal.ActivePage = tsForms then begin
    if rdm.cdForms.Active and not rdm.cdForms.IsEmpty and
      (RusMessageDlg('Вы действительно хотите удалить форму?',
        mtConfirmation, mbYesNoCancel, 0) = mrYes) then
      rdm.cdForms.Delete;
  end;
end;

procedure TReportsForm.GetShortCutProc(S: string; SC: TShortCut);
begin
  cbShortCut.Items.Add(S);
  cbShortCut.Values.Add(IntToStr(SC));
end;

procedure TReportsForm.FormCreate(Sender: TObject);
begin
  GetShortCuts(GetShortCutProc);
  dsReportGroups.DataSet := TConfigManager.Instance.StandardDics.deReportGroups.DicItems;
  UpdateButtons;
end;

{// -------------- Обработчики редактора скриптов формы ----------------
  Все формы - модули, поэтому у них только один скрипт, так что это все пока убрано
  и обработчкки назначены другие.

function TReportsForm.CodeEditGetCaption(Sender: TObject): string;
begin
  if not VarIsNull(rdm.cdForms[FormDescField]) and (rdm.cdForms[FormDescField] <> '') then
    Result := rdm.cdForms[FormDescField]
  else
    Result := rdm.cdForms[FormNameField];
end;

function TReportsForm.CodeEditGetScripts(Sender: TObject): TStringList;
begin
  Result := rdm.GetFormScripts;
end;

function TReportsForm.CodeEditGetScriptDesc(Sender: TObject; ScriptName: string): string;
begin
  Result := sdm.GetScriptDesc(ScriptName);
end;

procedure TReportsForm.CodeEditWriteScripts(Sender: TObject; Scripts: TStringList);
var
  OldS: TDataSetState;
  i: integer;
begin
  OldS := rdm.cdForms.State;
  if not (OldS in [dsEdit, dsInsert]) then rdm.cdForms.Edit;
  if Scripts.Count > 0 then
    for i := 0 to Pred(Scripts.Count) do
      WriteStringListToBlob((Scripts.Objects[i] as TScript).Script,
        rdm.cdForms.FieldByName(Scripts[i]) as TBlobField);
  if OldS = dsBrowse then rdm.cdForms.CheckBrowseMode;
end;
}

procedure TReportsForm.SavePosition(ds: TDataSet; Key: string; KeyField: string);
begin
  if ds.Active and not ds.IsEmpty and not VarIsNull(ds[KeyField]) then
    ReportStorage.AppStorage.WriteString(ReportStorage.AppStoragePath + Key,
      ds.FieldByName(KeyField).AsString);
end;

procedure TReportsForm.LoadPosition(ds: TDataSet; Key: string; KeyField: string);
var
  s: string;
begin
  if ds.Active and not ds.IsEmpty and not VarIsNull(ds[KeyField]) then begin
    s := ReportStorage.AppStorage.ReadString(ReportStorage.AppStoragePath + Key, '');
    if s <> '' then ds.Locate(KeyField, s, []);
  end;
end;

procedure TReportsForm.btOkClick(Sender: TObject);
var
  HasDefault: boolean;  // Означает, что отчет по умолчанию назначен
begin
  SavePosition(rdm.cdReports, 'ReportScriptID', F_ScriptName);
  SavePosition(rdm.cdOrdScripts, 'OrderScriptID', F_ScriptName);
  SavePosition(rdm.cdForms, 'FormScriptID', FormNameField);
  // Ищется отчет по умолчанию, если не находится, то не даем закрыть
  if rdm.cdReports.Active and not rdm.cdReports.IsEmpty then begin
    rdm.cdReports.DisableControls;
    try
      rdm.cdReports.First;
      HasDefault := false;
      while not rdm.cdReports.eof do
      try
        if not VarIsNull(rdm.cdReports['IsDefault']) and rdm.cdReports['IsDefault'] then begin
          if not VarIsNull(rdm.cdReports['IsUnit']) and rdm.cdReports['IsUnit'] then begin
            RusMessageDlg('Отчетом по умолчанию не может быть назначен вспомогательный модуль', mtError, [mbOk], 0);
            ModalResult := mrNone;
            break;
          end else if HasDefault then begin
            RusMessageDlg('Отчет по умолчанию может быть только один', mtError, [mbOk], 0);
            ModalResult := mrNone;
            break;
          end else HasDefault := true;
        end;
      finally
        rdm.cdReports.Next;
      end;
    finally
      rdm.cdReports.EnableControls;
    end;
  end;
end;

procedure TReportsForm.UpdateButtons;
begin
  if pgGlobal.ActivePage = tsGlobal then begin
    btAdd.Enabled := false;
    btDelete.Enabled := false;
    btEdit.Enabled := rdm.cdOrdScripts.Active and not rdm.cdOrdScripts.IsEmpty;
    btSave.Enabled := btEdit.Enabled;
    btUpdate.Enabled := false;
    btLoad.Enabled := btEdit.Enabled;
  end else if pgGlobal.ActivePage = tsReports then begin
    btAdd.Enabled := rdm.cdReports.Active;
    btDelete.Enabled := rdm.cdReports.Active and not rdm.cdReports.IsEmpty;
    btEdit.Enabled := btDelete.Enabled;
    btSave.Enabled := btDelete.Enabled;
    btLoad.Enabled := btDelete.Enabled;
    btUpdate.Enabled := btAdd.Enabled;
  end else if pgGlobal.ActivePage = tsForms then begin
    btAdd.Enabled := rdm.cdForms.Active;
    btDelete.Enabled := rdm.cdForms.Active and not rdm.cdForms.IsEmpty;
    btEdit.Enabled := btDelete.Enabled;
    btSave.Enabled := btDelete.Enabled;
    btLoad.Enabled := btDelete.Enabled;
    btUpdate.Enabled := btAdd.Enabled;
  end;
end;

procedure TReportsForm.pgGlobalChange(Sender: TObject);
begin
  UpdateButtons;
end;

procedure TReportsForm.btSaveClick(Sender: TObject);
var
  cd: TDataSet;
  s, ss: string;
  sd: variant;
begin
  if pgGlobal.ActivePage = tsGlobal then begin cd := rdm.cdOrdScripts; s := F_ScriptName; ss := ScriptField end
  else if pgGlobal.ActivePage = tsReports then begin cd := rdm.cdReports; s := F_ScriptName; ss := ScriptField end
  else if pgGlobal.ActivePage = tsForms then begin cd := rdm.cdForms; s := FormNameField; ss := FormPasField end
  else Exit;
  SaveDlg.FileName := cd[s];
  if SaveDlg.Execute then
  begin
    (cd.FieldByName(ss) as TBlobField).SaveToFile(SaveDlg.FileName);
    sd := cd[FormDateField];
    if not VarIsNull(cd[FormDateField]) then
      FileSetDate(SaveDlg.FileName, DateTimeToFileDate(sd));
    if pgGlobal.ActivePage = tsForms then
    begin
      ss := ChangeFileExt(SaveDlg.FileName, '.dfm');
      (cd.FieldByName(FormDfmField) as TBlobField).SaveToFile(ss);
      if not VarIsNull(sd) then
        FileSetDate(ss, DateTimeToFileDate(sd));
    end;
  end;
end;

procedure TReportsForm.GetCurData(var cd: TDataSet; var s, ss: string);
begin
  if pgGlobal.ActivePage = tsGlobal then begin cd := rdm.cdOrdScripts; s := F_ScriptName; ss := ScriptField end
  else if pgGlobal.ActivePage = tsReports then begin cd := rdm.cdReports; s := F_ScriptName; ss := ScriptField end
  else if pgGlobal.ActivePage = tsForms then begin cd := rdm.cdForms; s := FormNameField; ss := FormPasField end
  else Exit;
end;

procedure TReportsForm.btLoadClick(Sender: TObject);
var
  cd: TDataSet;
  s, ss: string;
begin
  {if pgGlobal.ActivePage = tsGlobal then begin cd := rdm.cdOrdScripts; s := ScriptNameField; ss := ScriptField end
  else if pgGlobal.ActivePage = tsReports then begin cd := rdm.cdReports; s := ScriptNameField; ss := ScriptField end
  else if pgGlobal.ActivePage = tsForms then begin cd := rdm.cdForms; s := FormNameField; ss := FormPasField end
  else Exit;}
  GetCurData(cd, s, ss);
  OpenDlg.FileName := cd[s] + '.pas';
  if OpenDlg.Execute then begin
    cd.Edit;
    (cd.FieldByName(ss) as TBlobField).LoadFromFile(OpenDlg.FileName);
    if pgGlobal.ActivePage = tsForms then begin
      ss := ChangeFileExt(OpenDlg.FileName, '.dfm');
      (cd.FieldByName(FormDfmField) as TBlobField).LoadFromFile(ss);
    end;
  end;
end;

procedure TReportsForm.btUpdateClick(Sender: TObject);
var
  cd: TDataSet;
  s, ss, NameOnly, ExtOnly: string;
begin
  GetCurData(cd, s, ss);
  if not cd.IsEmpty and cd.Active then
  try
    OpenDlg.FileName := cd[s];
  except
    OpenDlg.FileName := '';
  end;
  if OpenDlg.Execute then begin
    NameOnly := ExtractFileName(OpenDlg.FileName);
    ExtOnly := ExtractFileExt(NameOnly);
    if ExtOnly <> '' then
      NameOnly := Copy(NameOnly, 1, Pos(ExtOnly, NameOnly) - 1);
    if FileExists(ChangeFileExt(OpenDlg.FileName, '.dfm')) then
      pgGlobal.ActivePage := tsForms
    else
      pgGlobal.ActivePage := tsReports;
    GetCurData(cd, s, ss);  // т.к. страница могла поменяться
    if cd.Locate(s, NameOnly, [loCaseInsensitive]) then begin
      if RusMessageDlg('Сценарий "' + NameOnly + '" уже существует. Заменить?',
                     mtConfirmation, mbYesNoCancel, 0) <> mrYes then Exit
      else cd.Edit;
    end else begin
      cd.Append;
      cd[s] := NameOnly;
    end;
    (cd.FieldByName(ss) as TBlobField).LoadFromFile(OpenDlg.FileName);
    if pgGlobal.ActivePage = tsForms then begin
      ss := ChangeFileExt(OpenDlg.FileName, '.dfm');
      (cd.FieldByName(FormDfmField) as TBlobField).LoadFromFile(ss);
    end;
  end;
end;

procedure TReportsForm.FormShow(Sender: TObject);
begin
  LoadPosition(rdm.cdReports, 'ReportScriptID', F_ScriptName);
  LoadPosition(rdm.cdOrdScripts, 'OrderScriptID', F_ScriptName);
  LoadPosition(rdm.cdForms, 'FormScriptID', FormNameField);
end;

end.
