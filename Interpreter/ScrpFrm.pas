unit ScrpFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, DB,
  JvInterpreter;

const
  ScrCreateFormField = 'OnCreateForm';
  ScrCloseFormField = 'OnCloseForm';
  ScrClickControlField = 'OnClickControl';
  ScrActivateFormField = 'OnActivateForm';

type
  TScriptedForm = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FScripts: TStringList;
    FClicked: TControl;
    procedure ExecCode(ScriptField: String);
    function GetScript(const ScrField: string): TStringList;
    procedure SetScripts(Value: TStringList);
    procedure SetClicked(Value: TControl);
    procedure ShowFormScriptError(ScriptFld: string; ErrPos: integer; ErrMsg: string);
    procedure FreeScripts;
  public
    ScriptName: string;
    property Scripts: TStringList read FScripts write SetScripts;
    property ClickedControl: TControl read FClicked write SetClicked;
  end;

var
  ScriptedForm: TScriptedForm;

  ScriptForm: TScriptedForm;
  ScriptClicked: TControl;

procedure RegisterRAI2Adapter(RAI2Adapter: TJvInterpreterAdapter );

implementation

{$R *.DFM}

uses RepData, IniCalc, RepsFrm, PmProcess, CodeEdit, JvInterpreterFm, JvJCLUtils, JvJVCLUtils,
  RDialogs;

function TScriptedForm.GetScript(const ScrField: string): TStringList;
begin
  if FScripts <> nil then
    Result := (FScripts.Objects[FScripts.IndexOf(ScrField)] as TScript).Script
  else
    Result := nil;
end;

procedure TScriptedForm.ShowFormScriptError(ScriptFld: string; ErrPos: integer;
  ErrMsg: string);
begin
  if rdm.cdForms.Locate(FormNameField, ScriptName, []) then begin
    if ErrorEdit then begin
      if ExecCodeEditForm(true, ErrPos, ScriptFld, ErrMsg, UserLevel > lvlAdmin,
          ReportsForm.CodeEditGetCaption, ReportsForm.CodeEditGetScripts,
          ReportsForm.CodeEditGetScriptDesc, ReportsForm.CodeEditWriteScripts) then
        rdm.ApplyAll;
    end else
      RusMessageDlg('Ошибка при выполнении сценария ' + ScriptName + ': ' + #13 + ErrMsg,
        mtError, [mbOk], 0);
  end;
end;

procedure TScriptedForm.ExecCode(ScriptField: string);
var
  Msg: string;
  FForm: TJvInterpreterFm ;
  OldScriptForm: TScriptedForm;
  OldScriptClicked: TControl;
  Script: TStringList;
begin
  OldScriptForm := ScriptForm;
  OldScriptClicked := ScriptClicked;
  Script := GetScript(ScriptField);
  if (Script = nil) or IsEmptyScript(Script) then Exit;
  Msg := '';
  FForm := TJvInterpreterFm.Create(nil);
  try
    try
      // Установка глобальных переменных для скрипта
      ScriptForm := Self;
      ScriptClicked := FClicked;
      {FPrg.OnGetValue := PrgGetValue;
      FPrg.OnSetValue := PrgSetValue;}
      FForm.Source := Script.Text;
      // Запуск...
      FForm.Run;
    except
      on E : EJvInterpreterError  do
      begin
        // Игнорируем ошибку, выскакивающую при пустом скрипте
        if (E.ErrCode = ieExpected) and
           (CompareText(E.ErrName, LoadStr(irExpression)) = 0) then Exit;
        Msg := IntToStr(E.ErrCode) + ': ' + ReplaceString(E.Message, #10, ' ');
        ShowFormScriptError(E.ErrUnitName, E.ErrPos, Msg);
      end;
      on E : EJvScriptError  do begin
        Msg := ReplaceString(E.Message, #10, ' ');
        ShowFormScriptError(E.ErrUnitName, E.ErrPos, Msg);
      end;
      on E : Exception do
      begin
        Msg := IntToStr(FForm.LastError.ErrCode) + ': ' +
          ReplaceString(FForm.LastError.Message, #10, ' ');
        ShowFormScriptError(E.ErrUnitName, FForm.LastError.ErrPos, Msg);
      end
      else begin
        Msg := 'Ошибка при выполнении сценария';
        RusMessageDlg(Msg, mtError, [mbOk], 0);
      end;
    end;
  finally
    FreeAndNil(FForm);
    ScriptForm := OldScriptForm;
    ScriptClicked := OldScriptClicked;
  end;
end;

procedure TScriptedForm.FreeScripts;
var
 i: integer;
begin
  if Assigned(FScripts) then begin
    if FScripts.Count > 0 then
      for i := 0 to pred(FScripts.Count) do
        if Assigned(FScripts.Objects[i]) then FScripts.Objects[i].Free;
    FreeAndNil(FScripts);
  end;
end;

procedure TScriptedForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ExecCode(ScrCloseFormField);
  FreeScripts;
end;

procedure TScriptedForm.SetScripts(Value: TStringList);
begin
  FreeScripts;
  FScripts := Value;
end;

procedure RAI2_CreateForm(var Value: Variant; Args: TArgs);
var
  Msg: string;
  FPrg: TJvInterpreterProgram ;
  Script: TStringList;
  FName: string;
begin
  FPrg := nil;
  Script := nil;
  Value := null;
  if not rdm.OpenForms then Exit;
  try
    FName := Args.Values[0];
    if FName = '' then Exit;
  except Exit; end;
  if rdm.cdForms.Locate('FormName', FName, []) then begin
    Application.CreateForm(TScriptedForm, ScriptForm);
    ScriptForm.ScriptName := FName;
    ScriptForm.Scripts := rdm.GetFormScripts;
  end;
  rdm.CloseAll;
end;

procedure RegisterRAI2Adapter(RAI2Adapter: TJvInterpreterAdapter );
begin
  with RAI2Adapter do
  begin
    AddFun('ScriptedForm', 'CreateForm', RAI2_CreateForm, 1, [varEmpty], varEmpty);
  end;
end;

end.
