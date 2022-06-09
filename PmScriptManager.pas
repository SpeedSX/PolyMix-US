unit PmScriptManager;

interface

uses Classes, DB, SysUtils, JvInterpreter, JvInterpreterFm, BaseRpt, JvAppStorage,

  PmOrder;

type
  TScriptManager = class
  private
    procedure ClearError;
    procedure SetError(_ErrUnitName: string; _ErrPos: integer; _ErrMsg: string);
    procedure ShowGlobalScriptError(ScriptData: TDataSet; ScriptFieldName, ScriptDateFieldName: string;
      ErrPos: integer; ErrMsg, UnitName: string);
    procedure HandleException(E: Exception; FPrg: TJvInterpreterFm);
  public
    ErrUnitName: string;
    ErrPos: integer;
    ErrMsg: string;
    const
      OrderTotalChangedEvent = 'AfterCalcTotalCost';
      OrderBeforeSaveEvent = 'BeforeSaveOrder';
      PrintInvoiceForm = 'PrintInvoice';
      PrintInvoiceReport = 'PrintInvoiceReport';
      PrintPaymentIncomes = 'PrintPaymentIncomes';
      PrintPaymentOrders = 'PrintPaymentOrders';
      PrintShipmentReport = 'PrintShipmentReport';
      PrintShipmentForm = 'PrintShipmentForm';
      PrintSaleDocForm = 'PrintSaleDocForm';
      PrintStockIncomeForm = 'PrintStockIncomeForm';
      PrintStockIncomeReport = 'PrintStockIncomeReport';
      PrintMatRequestReport = 'PrintMatRequestReport';
      PrintStockWasteForm = 'PrintStockWasteForm';
      PrintStockWasteReport = 'PrintStockWasteReport';
    procedure ExecExcelReport(ScriptID: integer);
    procedure ExecOrderEvent(Order: TOrder; EventName: string);
    function ExecScript(DataSet: TDataSet; ScriptFieldName: string; ShowCancel: boolean;
      GetValueHandler: TJvInterpreterGetValue): boolean;
    procedure ShowScriptErrorDataSet(DataSet: TDataSet; ScriptFieldName: string;
      UnitName: string; ErrPos: integer; Msg: string);
    function GetFilterPhrase: string;
    function OpenReport(FileName: string): TBaseReport;
    procedure RunProgram(Sender: TObject);
    procedure ExecPageScript(ScriptFieldName: string; PageID: integer;
      GetValueFunc: TJvInterpreterGetValue);
    procedure ShowScriptError(ScriptedObj: TObject; ScriptFld: string;
      ErrPos: integer; ErrMsg: string; AppStorage: TJvCustomAppStorage);
  end;

var
  ScriptManager: TScriptManager;

implementation

uses Windows, JvJCLUtils, Dialogs, TLoggerUnit,

  JvInterpreter_Reports, CalcSettings, PmProcess, PmProcessCfg,
  RepData, RDialogs, EScrFrm, RAI2_CalcSrv, PmProcessCfgData,
  fCanRep, MainData, RDBUtils, MainForm, ExHandler, CodeEdit,
  PmConfigEditors, PmConfigObjects, PmConfigManager, PmAccessManager,
  ExcelRpt, OpenOfficeRpt;

procedure TScriptManager.RunProgram(Sender: TObject);
begin
  try
    (Sender as TJvInterpreterFm).Run;
  except
    on E: Exception do HandleException(E, Sender as TJvInterpreterFm);
  end;
end;

procedure TScriptManager.HandleException(E: Exception; FPrg: TJvInterpreterFm);
var
  ejv: EJvInterpreterError;
  esc: EJvScriptError;
  Msg: string;
begin
  if E is EJvInterpreterError then
  begin
    ejv := E as EJvInterpreterError;
    // Игнорируем ошибку, выскакивающую при пустом скрипте
    if (ejv.ErrCode = ieExpected) and
       (CompareText(ejv.ErrName1, LoadStr(irExpression)) = 0) then Exit;
    Msg := IntToStr(ejv.ErrCode) + ': ' + StringReplace(ejv.ErrMessage, #10, ' ', [rfReplaceAll]);
    //ShowScriptErrorDataSet(DataSet, E.ErrUnitName, E.ErrPos, Msg);
    SetError(ejv.ErrUnitName, ejv.ErrPos, Msg);
  end
  else if E is EJvScriptError then
  begin
    esc := E as EJvScriptError;
    Msg := StringReplace(esc.Message, #10, ' ', [rfReplaceAll]);
    //ShowScriptErrorDataSet(DataSet, E.ErrUnitName, E.ErrPos, Msg);
    SetError(esc.ErrUnitName, esc.ErrPos, Msg);
  end
  else
  begin
    Msg := IntToStr(FPrg.LastError.ErrCode) + ': ' +
      StringReplace(FPrg.LastError.ErrMessage, #10, ' ', [rfReplaceAll]);
    //ShowGlobalScriptError(rdm.cdReports, FPrg.LastError.ErrPos, Msg);
    //ShowScriptErrorDataSet(DataSet, FPrg.LastError.ErrUnitName, FPrg.LastError.ErrPos, Msg);
    SetError(FPrg.LastError.ErrUnitName, FPrg.LastError.ErrPos, Msg);
  end;
end;

procedure TScriptManager.ShowGlobalScriptError(ScriptData: TDataSet; ScriptFieldName, ScriptDateFieldName: string;
  ErrPos: integer; ErrMsg, UnitName: string);
begin
  if Options.ErrorEdit then begin
    if ExecEditScriptForm(true, ErrPos, ErrMsg, ScriptData, ScriptFieldName, ScriptDateFieldName,
        'Ошибка', UnitName) then
      rdm.ApplyAll
    else
      rdm.CancelAll;
  end else
    RusMessageDlg('Ошибка при выполнении сценария в модуле ''' + UnitName + ''': ' + #13 + ErrMsg,
        mtError, [mbOk], 0);
end;

procedure TScriptManager.ShowScriptErrorDataSet(DataSet: TDataSet; ScriptFieldName: string;
  UnitName: string; ErrPos: integer; Msg: string);
var
  dq: TDataSet;
  FName: string;

  procedure _Exec;
  begin
    if Options.ErrorEdit then begin
      if ExecEditScriptForm(true, ErrPos, Msg, dq, FName, 'Ошибка', UnitName, FormDateField) then
        rdm.ApplyAll
      else
        rdm.CancelAll;
    end else
      RusMessageDlg('Ошибка при выполнении сценария в модуле ''' + UnitName + ''': ' + #13 + Msg,
        mtError, [mbOk], 0);
  end;

begin
  if UnitName = '' then  // Модуль, в котором произошла ошибка
    ShowGlobalScriptError(DataSet, ScriptFieldName, FormDateField, ErrPos, Msg, UnitName)
  else begin
    // Если модуль известен, то ищем его в отчетах, формах и обработчиках.
    // В обработчиках желательно объявлять модули с именем обработчика,
    // чтобы можно было найти ошибку.
    if rdm.cdForms.Locate(FormNameField, UnitName, [loCaseInsensitive]) then begin
      dq := rdm.cdForms;
      FName := FormPasField;
      _Exec;
    end else
    if rdm.cdReports.Locate(F_ScriptName, UnitName, [loCaseInsensitive]) then begin
      dq := rdm.cdReports;
      FName := ScriptField;
      _Exec;
    end else
    if rdm.cdOrdScripts.Locate(F_ScriptName, UnitName, [loCaseInsensitive]) then begin
      dq := rdm.cdOrdScripts;
      FName := ScriptField;
      _Exec;
    end else
      ShowGlobalScriptError(DataSet, ScriptFieldName, FormDateField, ErrPos, Msg, UnitName);
  end;
end;

procedure TScriptManager.SetError(_ErrUnitName: string; _ErrPos: integer; _ErrMsg: string);
begin
  ErrUnitName := _ErrUnitName;
  ErrPos := _ErrPos;
  ErrMsg := _ErrMsg;
end;

procedure TScriptManager.ClearError;
begin
  ErrMsg := '';
end;


function TScriptManager.ExecScript(DataSet: TDataSet; ScriptFieldName: string; ShowCancel: boolean;
  GetValueHandler: TJvInterpreterGetValue): boolean;
var
  FPrg: TJvInterpreterFm;
  Script: TStringList;
  OldScriptService: TPolyProcess;
  OldScriptDataSet: TDataSet;
  OldScriptChangedField: TField;
  OldScriptOldFieldValue: variant;
begin
  ErrUnitName := '';
  ErrPos := -1;
  ErrMsg := '';
  Result := false;
  OldScriptDataSet := ScriptDataSet;
  OldScriptService := ScriptService;
  OldScriptChangedField := ScriptChangedField;
  if ScriptService <> nil then
    OldScriptOldFieldValue := ScriptService.ScriptOldFieldValue;

  FPrg := TJvInterpreterFm.Create(nil);
  FPrg.OnCreateDfmStream := rdm.CreateDfmStream;
  FPrg.OnFreeDfmStream := rdm.FreeDfmStream;
  FPrg.OnGetUnitSource := rdm.GetUnitSource;
  if Assigned(GetValueHandler) then FPrg.OnGetValue := GetValueHandler;
  Script := TStringList.Create;
  try
    ReadStringListFromBlob(Script, DataSet.FieldByName(ScriptFieldName) as TBlobField);
    if IsEmptyScript(Script) then
    begin
      Result := true;
      Exit;
    end;
    ClearError;
    try
      FPrg.Source := Script.Text;
      // Запуск...
      if ShowCancel then
        OpenReportProgressForm(RunProgram, FPrg)
      else
        RunProgram(FPrg);
      Result := true;
    except
      on E: Exception do
      begin
        HandleException(E, FPrg);
      end;
    end;
    Result := ErrMsg = '';
  finally
    ScriptService := OldScriptService;
    ScriptDataSet := OldScriptDataSet;
    ScriptChangedField := OldScriptChangedField;
    if ScriptService <> nil then
      ScriptService.ScriptOldFieldValue := OldScriptOldFieldValue;
    if FPrg <> nil then FPrg.Free;
    if Script <> nil then Script.Free;
    //if ShowCancel then CloseReportProgressForm;
  end;
end;

function GetTempName(FName, Path: string): string;
var
  Num: integer;
begin
  Num := 1;
  repeat
    Result := AddPath(ChangeFileExt(ChangeFileExt(FName, '') + IntToStr(Num), ExtractFileExt(FName)), Path);
    Inc(Num);
  until not FileExists(Result);
end;

procedure TScriptManager.ExecExcelReport(ScriptID: integer);
var
  Msg: string;
begin
  if not rdm.OpenAll then Exit;
  if rdm.cdReports.Locate(F_ScriptID, ScriptID, []) then
  begin
    Msg := 'Запуск отчета ' + rdm.cdReports[F_ScriptName];
    TLogger.getInstance.Info(Msg);
    dm.AddEventToHistory(GlobalHistory_Info, Msg, ScriptID);

    if not ExecScript(rdm.cdReports, ScriptField, rdm.cdReports['ShowCancel'], nil) then
    begin
      rdm.cdReports.Locate(F_ScriptID, ScriptID, []);
      ShowScriptErrorDataSet(rdm.cdReports, ScriptField, ErrUnitName, ErrPos, ErrMsg);
    end
    else
      if (Rpt <> nil) and not Options.EnableVB then
      begin
        Rpt.Save;
      end;
  end;
end;

function TScriptManager.OpenReport(FileName: string): TBaseReport;
{var
  SourceFileName: string;}
begin
  if ExtractFileDir(FileName) = '' then
    FileName := AddPath(FileName, ExtractFileDir(ParamStr(0)));

  {if not Options.EnableVB then
  begin
    // создаем копию шаблона во временной папке
    // можно не указывать путь к файлу
    if ExtractFileDir(FileName) = '' then
      SourceFileName := AddPath(FileName, ExtractFileDir(ParamStr(0)))
    else
      SourceFileName := FileName;
    FileName := GetTempName(ExtractFileName(SourceFileName), TSettingsManager.Instance.ReportTempPath);
    if FileExists(SourceFileName) then
    begin
      CopyFile(PChar(SourceFileName), PChar(FileName), false);
    end
    else
      ExceptionHandler.Raise_('Файл шаблона не найден: ' + FileName);
  end;}
  try
    if Rpt <> nil then
    begin
      if not Options.OpenOffice then
        TExcelReport(Rpt).EnableVBScript := Options.EnableVB;
      Rpt.OpenNewFile(FileName)
    end
    else
    if Options.OpenOffice then
      Rpt := TOpenOfficeReport.OpenFile(FileName)
    else
      Rpt := TExcelReport.OpenFile2(FileName, False, True, Options.EnableVB);
    if not Rpt.AppWasFound then
      FreeAndNil(Rpt)
    else
      Rpt.WinCaption1 := 'Excel - PolyMix'; // Изменение заголовка окна
    Result := Rpt;
  except on E: Exception do
    begin
      if Pos('Visual Basic', E.Message) <> 0 then
        MessageDlg('Для использования отчетов необходимо активировать'#13
          + 'доверенный доступ к проектам Visual Basic:'#13
          + 'Для Excel 2000/XP/2003 - в меню Сервис-Макросы-Безопасность-Надежные издатели'#13
          + '(Tools-Macro-Security-Trusted Publishers)'#13
          + 'Для Excel 2007 - в меню приложения (круглая кнопка)-Настройки Excel-Центр управления безопасностью-'#13
          + 'Параметры центра управления безопасностью-Параметры макросов',
        mtError, [mbOk], 0)
      else
        raise;
    end;
  end;
end;

procedure TScriptManager.ExecOrderEvent(Order: TOrder; EventName: string);
begin
  ScriptOrder := Order;
  if not rdm.OpenAll then Exit;
  if not rdm.cdOrdScripts.Locate(F_ScriptName, EventName, [loCaseInsensitive]) then Exit;
  if not ExecScript(rdm.cdOrdScripts, ScriptField, false, nil) then
  begin
    rdm.cdOrdScripts.Locate(F_ScriptName, EventName, [loCaseInsensitive]);
    ShowScriptErrorDataSet(rdm.cdOrdScripts, ScriptField, ErrUnitName, ErrPos, ErrMsg);
  end;
end;

function TScriptManager.GetFilterPhrase: string;
begin
  Result := MForm.CurrentController.GetFilterPhrase;
  //if not InCalc then Result := MFFilter.GetFilterPhrase(qiWork)
  //else Result := MFFilter.GetFilterPhrase(qiCalc);
end;

procedure TScriptManager.ExecPageScript(ScriptFieldName: string; PageID: integer;
  GetValueFunc: TJvInterpreterGetValue);
var
  PageData: TProcessPageData;
begin
  PageData := TConfigManager.Instance.ProcessPageData;
  PageData.Open;
  if PageData.DataSet.Filtered then
    PageData.DataSet.Filtered := false;
  if PageData.Locate(PageID) then
    if not ScriptManager.ExecScript(PageData.DataSet, ScriptFieldName, false, GetValueFunc) then
      ScriptManager.ShowScriptErrorDataSet(PageData.DataSet,
         ScriptFieldName, ErrUnitName, ErrPos, ErrMsg);
end;

procedure TScriptManager.ShowScriptError(ScriptedObj: TObject; ScriptFld: string;
  ErrPos: integer; ErrMsg: string; AppStorage: TJvCustomAppStorage);
var
  Located: boolean;
  GetCapProc: TCEGetCaptionProc;
  GetScriptsProc: TCEGetScriptsProc;
  WriteScriptsProc: TCEWriteScriptsProc;
  FProcessEditor: TScriptedObjectEditor;
  FProcessNode: TCfgProcess;
  //FProcessGridEditor: TProcessGridEditor;
  FProcessGridNode: TCfgProcessGrid;
begin
  if Options.ErrorEdit then
  begin
    //CreateDicEditForm(false);
    try
      if ScriptedObj is TPolyProcessCfg then
      begin
        FProcessNode := TCfgProcess.Create;
        FProcessEditor := TProcessEditor.Create(FProcessNode);
        Located := TConfigManager.Instance.ProcessCfgData.Locate((ScriptedObj as TPolyProcessCfg).SrvID);
        FProcessNode.ProcessID := (ScriptedObj as TPolyProcessCfg).SrvID;
        FProcessNode.IsActive := (ScriptedObj as TPolyProcessCfg).IsActive;
        GetCapProc := FProcessEditor.CodeEditGetCaption;
        GetScriptsProc := FProcessEditor.CodeEditGetScripts;
        WriteScriptsProc := FProcessEditor.CodeEditWriteScripts;
      end
      else
      if ScriptedObj is TProcessGridCfg then
      begin
        FProcessGridNode := TCfgProcessGrid.Create;
        FProcessEditor := TProcessGridEditor.Create(FProcessGridNode);
        Located := TConfigManager.Instance.ProcessGridCfgData.Locate((ScriptedObj as TProcessGridCfg).GridID);
        FProcessGridNode.GridID := (ScriptedObj as TProcessGridCfg).GridID;
        GetCapProc := FProcessEditor.CodeEditGetCaption;
        GetScriptsProc := FProcessEditor.CodeEditGetScripts;
        WriteScriptsProc := FProcessEditor.CodeEditWriteScripts;
      end
      else
        ExceptionHandler.Raise_('Неизвестный класс в ShowScriptError: ' + ScriptedObj.ClassName);
      if Located then
      begin
        if ExecCodeEditForm(true, ErrPos, ScriptFld, ErrMsg, not AccessManager.CurUser.EditProcCfg,
            GetCapProc, GetScriptsProc, FProcessEditor.CodeEditGetScriptDesc, WriteScriptsProc,
            AppStorage) then
        begin
          TConfigManager.Instance.ApplyProcessCfg;
          TConfigManager.Instance.UpdateScripts;
        end;
      end;
    finally
      FProcessEditor.Free;
      FProcessNode.Free;
      //DestroyDicEditForm(false);
    end;
  end
  else
  begin
    if ScriptedObj is TPolyProcessCfg then
      RusMessageDlg('Ошибка при выполнении сценария процесса (' +
        (ScriptedObj as TPolyProcessCfg).ServiceName + '.' + ScriptFld + '): ' + #13 + ErrMsg,
        mtError, [mbOk], 0)
    else if ScriptedObj is TProcessGridCfg then
      RusMessageDlg('Ошибка при выполнении сценария таблицы (' +
        (ScriptedObj as TProcessGridCfg).GridCaption + '.' + ScriptFld + '): ' + #13 + ErrMsg,
        mtError, [mbOk], 0)
   end;
end;

initialization
  ScriptManager := TScriptManager.Create;

finalization
  FreeAndNil(ScriptManager);

end.
