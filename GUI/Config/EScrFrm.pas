unit EScrFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, JvEditor, JvHLEditor, DB, ComCtrls, JvExControls,
  JvComponent, JvEditorCommon, JvFormPlacement, JvComponentBase;

type
  TEditScriptForm = class(TForm)
    edScript: TJvHLEditor ;
    Panel1: TPanel;
    lbErrMsg: TLabel;
    Panel2: TPanel;
    btOk: TButton;
    btCancel: TButton;
    sbScript: TStatusBar;
    ScriptStorage: TJvFormStorage;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure edScriptChangeStatus(Sender: TObject);
  private
    Script: TStringList;
    procedure GetEditor;
    procedure SetEditor;
    procedure WriteScript;
  public
    ShowError: boolean;
    ErrPos: integer;
    ErrMsg: string;
    ScriptFieldName: string;
    ScriptDateFieldName: string;
    ScriptData: TDataSet;
    ScriptCaption: string;
    CaretY, CaretX: integer;
  end;

var
  EditScriptForm: TEditScriptForm;

procedure EditScript(cd: TDataSet; NameField, DescField, ScriptFieldName, ScriptDateFieldName: string);

// _ScriptUnit используется для сохранения состояния редактора в файле настроек
function ExecEditScriptForm(_OnError: boolean; _ErrPos: integer; _ErrMsg:
    string; _ScriptData: TDataSet; _ScriptFieldName, _ScriptCaption,
    _ScriptUnit, _ScriptDateFieldName: string): boolean;

implementation

{$R *.DFM}

uses RDBUtils, Variants, CalcSettings;

procedure EditScript(cd: TDataSet; NameField, DescField, ScriptFieldName, ScriptDateFieldName: string);
var s, ns: string;
begin
  if cd.Active and not cd.IsEmpty then begin
    s := '';
    if DescField <> '' then begin
      if not VarIsNull(cd[DescField]) and (cd[DescField] <> '') then
        s := cd[DescField]
      else if NameField <> '' then
        s := cd[NameField];
    end;
    if NameField = '' then ns := ScriptFieldName else ns := cd[NameField];
    ExecEditScriptForm(false, -1, '', cd, ScriptFieldName, s, ns, ScriptDateFieldName);
  end;
end;

// _ScriptUnit используется для сохранения состояния редактора в файле настроек
function ExecEditScriptForm(_OnError: boolean; _ErrPos: integer;
  _ErrMsg: string; _ScriptData: TDataSet; _ScriptFieldName,
  _ScriptCaption, _ScriptUnit, _ScriptDateFieldName: string): boolean;
begin
  Result := false;
  try
    Application.CreateForm(TEditScriptForm, EditScriptForm);
    with EditScriptForm do begin
      ShowError := _OnError;
      ErrPos := _ErrPos;
      ScriptFieldName := _ScriptFieldName;
      ScriptData := _ScriptData;
      ScriptCaption := _ScriptCaption;
      ErrMsg := _ErrMsg;
      ScriptDateFieldName := _ScriptDateFieldName;
      ScriptStorage.AppStorage := TSettingsManager.Instance.Storage;
      if not _OnError then begin
        CaretY := TSettingsManager.Instance.Storage.ReadInteger(ScriptStorage.AppStoragePath + _ScriptUnit + 'CaretY', 0);
        CaretX := TSettingsManager.Instance.Storage.ReadInteger(ScriptStorage.AppStoragePath + _ScriptUnit + 'CaretX', 0);
      end;
      Result := ShowModal = mrOk;
      //if Result then begin
        TSettingsManager.Instance.Storage.WriteInteger(ScriptStorage.AppStoragePath + _ScriptUnit + 'CaretY', CaretY);
        TSettingsManager.Instance.Storage.WriteInteger(ScriptStorage.AppStoragePath + _ScriptUnit + 'CaretX', CaretX);
      //end;
    end;
  finally
    if EditScriptForm <> nil then FreeAndNil(EditScriptForm);
  end;
end;

procedure TEditScriptForm.FormActivate(Sender: TObject);
begin
  Caption := Caption + ' - ' + ScriptCaption;
  ReadStringListFromBlob(Script, ScriptData.FieldByName(ScriptFieldName) as TBlobField);
  if not Assigned(Script) then Exit;
  SetEditor;
  if ShowError then begin
    lbErrMsg.Caption := ErrMsg;
    if ErrPos > -1 then
    begin
      edScript.SelStart := ErrPos;
      edScript.SelLength := 0;
    end;
  end else begin
    lbErrMsg.Caption := '';
    edScript.CaretY := CaretY;
    edScript.CaretX := CaretX;
  end;
  edScriptChangeStatus(nil);
end;

procedure TEditScriptForm.SetEditor;
begin
  edScript.Lines.Assign(Script);
end;

procedure TEditScriptForm.GetEditor;
begin
  Script.Assign(edScript.Lines);
  CaretY := edScript.CaretY;
  CaretX := edScript.CaretX;
end;

procedure TEditScriptForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then begin
    GetEditor;  // забираем из редактора скрипт
    WriteScript;
  end;
  FreeAndNil(Script);
end;

procedure TEditScriptForm.WriteScript;
var
  OldS: TDataSetState;
begin
  OldS := ScriptData.State;
  if not (OldS in [dsEdit, dsInsert]) then ScriptData.Edit;
  WriteStringListToBlob(Script, ScriptData.FieldByName(ScriptFieldName) as TBlobField);
  if ScriptDateFieldName <> '' then ScriptData[ScriptDateFieldName] := Now;
  if OldS = dsBrowse then ScriptData.CheckBrowseMode;
end;

procedure TEditScriptForm.FormCreate(Sender: TObject);
begin
  Script := TStringList.Create;
end;

// TODO: Такой же код в CodeEditForm - надо бы вынести все в одну форму или фрейм
procedure TEditScriptForm.edScriptChangeStatus(Sender: TObject);
const
  Modi : array[boolean] of string[10] = ('', 'Изменен');
  Modes : array[boolean] of string[10] = ('Замена', 'Вставка');
begin
  with sbScript, edScript do
  begin
    Panels[0].Text := IntToStr(CaretY) + ':' + IntToStr(CaretX);
    Panels[1].Text := Modi[Modified];
    Panels[2].Text := Modes[InsertMode];
  end;
end;

end.
