unit PmExecCode;

interface

uses Classes, SysUtils, DB, JvInterpreter, PmProcessCfg;

type
  TScriptError = procedure(_Process: TPolyProcessCfg; _ScriptFieldName: string;
    _ErrPos: integer; _Msg: string) of object;

  TCode = class
  private
    FOnScriptError: TScriptError;
  protected
    FProcess: TPolyProcessCfg;
    FScriptFieldName: string;
    procedure DoPrgGetValue(Sender: TObject; Identifer: String;
      var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean); virtual; abstract;
    procedure DoPrgSetValue(Sender: TObject; Identifer: String;
      const Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean); virtual; abstract;
  public
    constructor Create(_Process: TPolyProcessCfg; _ScriptFieldName: string);
    function ExecCode: boolean;

    property OnScriptError: TScriptError read FOnScriptError write FOnScriptError;
  end;

  TDataSetCode = class(TCode)
  protected
    FDataSet: TDataSet;
    FExposeDataSet: boolean;
    procedure DoPrgGetValue(Sender: TObject; Identifer: String;
      var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean); override;
    procedure DoPrgSetValue(Sender: TObject; Identifer: String;
      const Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean); override;
  public
    constructor Create(_DataSet: TDataSet; _Process: TPolyProcessCfg; _ScriptFieldName: string);
    property ExposeDataSet: boolean read FExposeDataSet write FExposeDataSet;
  end;

implementation

uses Repdata, ExHandler, JvDBUtils, JvInterpreterConst;

constructor TCode.Create(_Process: TPolyProcessCfg; _ScriptFieldName: string);
begin
  inherited Create;
  FProcess := _Process;
  FScriptFieldName := _ScriptFieldName;
end;

function LoadStr2(const ResID: Integer): string;
var
  I: Integer;
begin
  for I := Low(JvInterpreterErrors) to High(JvInterpreterErrors) do
    if JvInterpreterErrors[I].ID = ResID then
    begin
      Result := JvInterpreterErrors[I].Description;
      Break;
    end;
end;

function TCode.ExecCode: boolean;
var
  FPrg: TJvInterpreterProgram;
  Script: TStringList;
  Msg, s: string;
begin
  Result := false;
  FPrg := TJvInterpreterProgram.Create(nil);
  try
    Script := FProcess.GetScript(FScriptFieldName);
    if Script = nil then Exit;  // во избежание надоедающих ошибок
    s := Script.Text;
    if Trim(s) <> '' then
    try
      // Установка глобальных переменных для скрипта
      //ScriptDicElements := DicElemList;
      FPrg.OnGetValue := DoPrgGetValue;
      FPrg.OnSetValue := DoPrgSetValue;
      //FPrg.OnCreateDfmStream := rdm.CreateDfmStream;
      //FPrg.OnFreeDfmStream := rdm.FreeDfmStream;
      FPrg.OnGetUnitSource := rdm.GetUnitSource;
      FPrg.Source := s;
      // Запуск...
      FPrg.Run;
      Result := true;
    except
      on E : EJvInterpreterError  do
      begin
        // Игнорируем ошибку, выскакивающую при пустом скрипте
        s := LoadStr2(irExpression);
        if (Trim(s) = '') and (E.ErrCode = ieExpected) and (CompareText(E.ErrName1, s) = 0) then Exit;
        Msg := IntToStr(E.ErrCode) + ': ' + StringReplace(E.Message, #10, ' ', [rfReplaceAll]);
      	ExceptionHandler.Log_(Msg);
        FOnScriptError(FProcess, FScriptFieldName, E.ErrPos, Msg);
      end;
      on E : EJvScriptError do begin
        Msg := StringReplace(E.Message, #10, ' ', [rfReplaceAll]);
      	ExceptionHandler.Log_(Msg);
        FOnScriptError(FProcess, FScriptFieldName, E.ErrPos, Msg);
      end;
      on E : Exception do
      begin
        Msg := IntToStr(FPrg.LastError.ErrCode) + ': ' +
          StringReplace(FPrg.LastError.Message, #10, ' ', [rfReplaceAll]);
      	ExceptionHandler.Log_(Msg);
        FOnScriptError(FProcess, FScriptFieldName, FPrg.LastError.ErrPos, Msg);
      end
      else begin
        Msg := 'Ошибка при выполнении сценария';
      	ExceptionHandler.Log_(Msg);
        FOnScriptError(FProcess, FScriptFieldName, 1, Msg);
        //RusMessageDlg(Msg, mtError, [mbOk], 0);
      end;
    end;
  finally
    if Assigned(FPrg) then FreeAndNil(FPrg);
  end;
end;

constructor TDataSetCode.Create(_DataSet: TDataSet; _Process: TPolyProcessCfg; _ScriptFieldName: string);
begin
  inherited Create(_Process, _ScriptFieldName);
  FDataSet := _DataSet;
end;

procedure TDataSetCode.DoPrgGetValue(Sender: TObject; Identifer: String;
  var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
var
  f: TField;
begin
    f := FDataSet.FindField(Identifer);
    if f <> nil then
    begin
      if (f is TStringField) and f.IsNull then Value := ''
      else Value := f.Value;
      Done := true;
    end
    else if FExposeDataSet and (CompareText(Identifer, 'DataSet') = 0) then
    begin
      Value := O2V(FDataSet);
      Done := true;
    end;
end;

procedure TDataSetCode.DoPrgSetValue(Sender: TObject; Identifer: String;
  const Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
var
  f: TField;
  OldState: TDataSetState;
begin
  f := FDataSet.FindField(Identifer);
  if f <> nil then begin
    if f.Value <> Value then
    begin
      OldState := FDataSet.State;
      if not (OldState in [dsInsert, dsEdit, dsCalcFields, dsInternalCalc]) then
        FDataSet.Edit;
      f.Value := Value;
    end;
    Done := true;
  end;
end;

end.
 