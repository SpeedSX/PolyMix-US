unit CodeEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  JvEditor, JvHLEditor, StdCtrls, ExtCtrls, ComCtrls, PmProcessCfg, Buttons,
  JvExControls, JvComponent, JvEditorCommon, JvFormPlacement, JvAppStorage,
  JvComponentBase;

type
  TCEGetCaptionProc = function (Sender: TObject): string of object;
  TCEGetScriptsProc = function (Sender: TObject): TStringList of object;
  TCEGetScriptDescProc = function (Sender: TObject; ScriptName: string): string of object;
  TCEWriteScriptsProc = procedure (Sender: TObject; Scripts: TStringList) of object;

  TCodeEditForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btOk: TButton;
    btCancel: TButton;
    lbErrMsg: TLabel;
    Panel3: TPanel;
    edScript: TJvHLEditor ;
    cbScript: TComboBox;
    Label1: TLabel;
    sbFirst: TSpeedButton;
    sbPrev: TSpeedButton;
    sbNext: TSpeedButton;
    sbNextNonEmp: TSpeedButton;
    sbPrevNonEmp: TSpeedButton;
    sbLast: TSpeedButton;
    CodeEditFormStorage: TJvFormStorage;
    sbScript: TStatusBar;
    procedure FormActivate(Sender: TObject);
    procedure cbScriptChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbScriptMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure sbFirstClick(Sender: TObject);
    procedure sbPrevNonEmpClick(Sender: TObject);
    procedure sbPrevClick(Sender: TObject);
    procedure sbNextClick(Sender: TObject);
    procedure sbNextNonEmpClick(Sender: TObject);
    procedure sbLastClick(Sender: TObject);
    procedure edScriptChangeStatus(Sender: TObject);
  private
    Scripts: TStringList;
    FAppStorage: TJvCustomAppStorage;
    procedure WriteScripts;
    function GetItemText(ScriptName, ScriptDesc: string): string;
    procedure SetEditor;
    procedure GetEditor;
    procedure SetAppStorage(_AppStorage: TjvCustomAppStorage);
  public
    ShowError: boolean;  // Показ позиции ошибки
    CurScript: string;  // имя поля с исполняемым скриптом.
                        // Для переключения на нужный табчик при ошибке.
    ErrPos: integer;
    ErrMsg: string;
    ReadOnly: boolean;
    OnGetCaption: TCEGetCaptionProc;
    OnGetScripts: TCEGetScriptsProc;
    OnGetScriptDesc: TCEGetScriptDescProc;
    OnWriteScripts: TCEWriteScriptsProc;
    property AppStorage: TJvCustomAppStorage read FAppStorage write SetAppStorage;
  end;

function ExecCodeEditForm(OnError: boolean; ErrPos: integer;
  ScriptFieldName, ErrMsg: string; ReadOnly: boolean;
  _OnGetCaption: TCEGetCaptionProc;
  _OnGetScripts: TCEGetScriptsProc;
  _OnGetScriptDesc: TCEGetScriptDescProc;
  _OnWriteScripts: TCEWriteScriptsProc;
  _AppStorage: TJvCustomAppStorage): boolean;

implementation

{$R *.DFM}

var
  CodeEditForm: TCodeEditForm;

function ExecCodeEditForm(OnError: boolean; ErrPos: integer;
  ScriptFieldName, ErrMsg: string; ReadOnly: boolean;
  _OnGetCaption: TCEGetCaptionProc;
  _OnGetScripts: TCEGetScriptsProc;
  _OnGetScriptDesc: TCEGetScriptDescProc;
  _OnWriteScripts: TCEWriteScriptsProc;
  _AppStorage: TJvCustomAppStorage): boolean;
begin
  if not Assigned(CodeEditForm) then Application.CreateForm(TCodeEditForm, CodeEditForm);
  try
    CodeEditForm.ShowError := OnError;
    CodeEditForm.ErrPos := ErrPos;
    CodeEditForm.ErrMsg := ErrMsg;
    CodeEditForm.CurScript := ScriptFieldName;
    CodeEditForm.ReadOnly := ReadOnly;
    CodeEditForm.OnGetCaption := _OnGetCaption;
    CodeEditForm.OnGetScripts := _OnGetScripts;
    CodeEditForm.OnGetScriptDesc := _OnGetScriptDesc;
    CodeEditForm.OnWriteScripts := _OnWriteScripts;
    CodeEditForm.AppStorage := _AppStorage;
    Result := CodeEditForm.ShowModal = mrOk;
  finally
    FreeAndNil(CodeEditForm);
  end;
end;

procedure TCodeEditForm.SetAppStorage(_AppStorage: TjvCustomAppStorage);
begin
  CodeEditFormStorage.AppStorage := _AppStorage;
end;

function TCodeEditForm.GetItemText(ScriptName, ScriptDesc: string): string;
begin
  Result := ScriptName + ' : ' + ScriptDesc;
end;

procedure TCodeEditForm.FormActivate(Sender: TObject);
var i: integer;
begin
  Scripts := nil;
  if Assigned(OnGetCaption) then Caption := Caption + ' - ' + OnGetCaption(Self);
  if Assigned(OnGetScripts) then Scripts := OnGetScripts(Self);
  if not Assigned(Scripts) then Exit;
  if Assigned(OnGetScriptDesc) and (Scripts.Count > 0) then
    for i := 0 to Pred(Scripts.Count) do
      cbScript.Items.Add(GetItemText(Scripts[i], OnGetScriptDesc(Self, Scripts[i])));
  if ShowError then
  begin
    if CurScript = '' then CurScript := Scripts[0];
    lbErrMsg.Caption := ErrMsg;
    cbScript.ItemIndex := Scripts.IndexOf(CurScript);
    SetEditor;
    if ErrPos > -1 then
    begin
      edScript.SelStart := ErrPos;
      edScript.SelLength := 0;
    end;
  end
  else
  begin
    lbErrMsg.Caption := '';
    CurScript := Scripts[0];
    cbScript.ItemIndex := 0;
    SetEditor;
  end;
  edScript.ReadOnly := ReadOnly;
  if ReadOnly then edScript.Color := clScrollBar else edScript.Color := clWindow;
end;

procedure TCodeEditForm.SetEditor;
begin
  edScript.Lines.Assign((Scripts.Objects[cbScript.ItemIndex] as TScript).Script);
end;

procedure TCodeEditForm.GetEditor;
begin
  (Scripts.Objects[Scripts.IndexOf(CurScript)] as TScript).Script.Assign(edScript.Lines);
end;

procedure TCodeEditForm.cbScriptChange(Sender: TObject);
begin
  GetEditor;
  SetEditor;
  CurScript := Scripts[cbScript.ItemIndex];
end;

procedure TCodeEditForm.WriteScripts;
begin
  if Assigned(OnWriteScripts) then OnWriteScripts(Self, Scripts);
end;

procedure TCodeEditForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then begin
    GetEditor;  // забираем из редактора последний редактируемый скрипт
    WriteScripts;
  end;
  FreeAndNil(Scripts);
end;

procedure TCodeEditForm.cbScriptMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  Height := 20;
end;

procedure TCodeEditForm.sbFirstClick(Sender: TObject);
begin
  cbScript.ItemIndex := 0;
  cbScriptChange(Sender);
end;

procedure TCodeEditForm.sbPrevNonEmpClick(Sender: TObject);
begin
  if cbScript.ItemIndex > 0 then
   repeat
     cbScript.ItemIndex := cbScript.ItemIndex - 1;
   until not IsEmptyScript((Scripts.Objects[cbScript.ItemIndex] as TScript).Script)
     or (cbScript.ItemIndex = 0);
  cbScriptChange(Sender);
end;

procedure TCodeEditForm.sbPrevClick(Sender: TObject);
begin
  if cbScript.ItemIndex > 0 then cbScript.ItemIndex := cbScript.ItemIndex - 1;
  cbScriptChange(Sender);
end;

procedure TCodeEditForm.sbNextClick(Sender: TObject);
begin
  if cbScript.ItemIndex < Pred(Scripts.Count) then
    cbScript.ItemIndex := cbScript.ItemIndex + 1;
  cbScriptChange(Sender);
end;

procedure TCodeEditForm.sbNextNonEmpClick(Sender: TObject);
begin
  if cbScript.ItemIndex < Pred(Scripts.Count) then
   repeat
     cbScript.ItemIndex := cbScript.ItemIndex + 1;
   until not IsEmptyScript((Scripts.Objects[cbScript.ItemIndex] as TScript).Script)
     or (cbScript.ItemIndex = Pred(Scripts.Count));
  cbScriptChange(Sender);
end;

procedure TCodeEditForm.sbLastClick(Sender: TObject);
begin
  cbScript.ItemIndex := Pred(Scripts.Count);
  cbScriptChange(Sender);
end;

// TODO: Такой же код в EScrFrm - надо бы вынести все в одну форму или фрейм
procedure TCodeEditForm.edScriptChangeStatus(Sender: TObject);
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
