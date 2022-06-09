unit PmInit;

{$I Calc.inc}

interface

uses Classes, {$IFDEF IniStorage}JvAppIniStorage, {$ENDIF} DB, JvAppStorage
  {$IFDEF XMLStorage}, JvAppXMLStorage, JvSimpleXML{$ENDIF}, PmEntSettings;

var
  // SE version
  //SecretNames: TStringList;
  //SecretFilter: boolean;
  // end SE

  LoadSuccess: boolean;

function PasswordCheck(UserName, Password: string): boolean;
procedure LoadAppSettings;
procedure SaveAppSettings;
procedure SetupDialogs;

function UserLogin: boolean;
//function GetUserGroup(ULevel: integer): integer;

procedure InitController;
procedure InitDataAccess;
procedure InitApplication;
procedure DoneApplication;

{$IFNDEF NoNet}
procedure NotifyLogon;
procedure NotifyLogoff;
{$ENDIF}

procedure LoadOrdStateSettings;

implementation

uses DbGrids, SysUtils, JvJVCLUtils, Forms, StdCtrls, Controls,  Dialogs,

     MainForm, MainData, CalcSettings, CalcUtils, PmDatabase,
     PmContragentListForm, ADOReClc, PmContragent,
     {NtfConst, }SplForm, DataHlp, ADOUtils, RDBUtils, RDialogs,
     PmProcess, ADODB, PmAccessManager, PmConfigManager,
     ExHandler, PmUpdate, PmAppController, MainFilter, TLoggerUnit,
     ServData, DicData, RepData{, PmMessenger}
{$IFDEF XmlStorage}
	, PmAppSettings
{$ENDIF}
{$IFNDEF NoExpenses}
     , ExpnsFrm, ExpData
{$ENDIF}
{$IFNDEF NoDocs}
     , DocDM, NDocFrm, OrdSel, EDocOrd
{$ENDIF}
{$IFNDEF NoNet}
  , OptCalc, NtfQueue
{$ENDIF}
{$IFDEF RepBuild}
  , fOrdRep, PrintFrm, UpcoForm
{$ENDIF}
     ;

procedure SaveAppSettings;
begin
  try
    if MForm = nil then Exit;
    with TSettingsManager.Instance do
    begin
      Storage.BeginUpdate;
      //Storage.WriteString(iniGlobal + '\Course', FloatToStr(MForm.AppCourse));

    {$IFNDEF NoNet}
      OptCalcForm.SaveSettings(Storage);
    {$ENDIF}

      Storage.WriteInteger(iniInterface + '\Width', MForm.Width);
      Storage.WriteInteger(iniInterface + '\Height', MForm.Height);
  {    Ini.WriteInteger(iniInterface, 'Top', MForm.Top);
      Ini.WriteInteger(iniInterface, 'Left', MForm.Left);
      Ini.WriteInteger(iniInterface, 'WindowState', Ord(MForm.WindowState));}

      if dm <> nil then AppController.SaveSettings(Storage);

    {$IFDEF RepBuild}
      OrdRepFormSaveSettings(Storage);
    {$ENDIF}
    //    ExpenseForm.SaveSettings(Ini);   сама теперь сохраняет
    {$IFNDEF NoDocs}
      SelectOrderSaveSettings(Storage);
    {$ENDIF}

     (*MFFilter.StoreFilter(Storage, iniFilter);
  {$IFNDEF NoProduction}
      ProductionFilter.StoreFilter(Storage, iniProductionFilter);
  {$ENDIF}
      CustomerPaymentsFilter.StoreFilter(Storage, iniPaymentsFilter);
      InvoicesFilter.StoreFilter(Storage, iniInvoicesFilter);*)
      Storage.EndUpdate;
    end;
  except
    RusMessageDlg('Ошибка записи в файл конфигурации', mtError, [mbOk], 0);
  end;
end;

// Выполняется обязательно ПОСЛЕ создания главной формы!
procedure LoadAppSettings;

  {procedure ReadSecretNames;
  var
    i: integer;
    s: string;
  begin
    try
      s := TSettingsManager.Instance.Storage.ReadString(iniSecretNames + '\Enabled', '0');
    except exit; end;
    if s <> '1' then begin SecretNames := nil; exit; end;
    SecretNames := TStringList.Create;
    i := 1;
    while true do begin
      try
        s := TSettingsManager.Instance.Storage.ReadString(iniSecretNames + '\Name' + IntToStr(i), 'NONAME');
      except Exit; end;
      if s <> 'NONAME' then SecretNames.Add(s) else Exit;
      Inc(i);
    end;
  end;}

var
  NormWidth: boolean;
begin
  if MForm = nil then Exit;
  with TSettingsManager.Instance do
  begin
    // Установка курса
    {try MForm.AppCourse := StrToFloat(Storage.ReadString(iniGlobal + '\Course', '1'));
    except on Exception do MForm.AppCourse := 1.0; end;
    sm.USDCourse := MForm.AppCourse;}

    // SE version
    //ReadSecretNames;
    //SecretFilter := (SecretNames <> nil);
    //if SecretNames <> nil then SecretFilter := SecretNames.Count > 0;
    // end SE

  {$IFNDEF NoNet}
    OptCalcForm.LoadSettings(Ini);
  {$ENDIF}

    try MForm.Width := StrToInt(Storage.ReadString(iniInterface + '\Width', IntToStr(Screen.Width - 2)));
    except end;
    try MForm.Height := StrToInt(Storage.ReadString(iniInterface + '\Height', IntToStr(Screen.Height - 30)));
    except end;

    LoadInterfaceSettings;
    TConfigManager.Instance.LoadProcessSettings;

    {$IFDEF RepBuild}
    OrdRepFormLoadSettings(Storage);
    {$ENDIF}
  //    ExpenseForm.LoadSettings(ini);
  {$IFNDEF NoDocs}
    SelectOrderLoadSettings(Storage);
  {$ENDIF}

    (*MFFilter.RestoreFilter(Storage, iniFilter);
  {$IFNDEF NoProduction}
    ProductionFilter.RestoreFilter(Storage, iniProductionFilter);
  {$ENDIF}
    CustomerPaymentsFilter.RestoreFilter(Storage, iniPaymentsFilter);
    InvoicesFilter.RestoreFilter(Storage, iniInvoicesFilter);*)
  end;
end;

procedure SetupDialogs;
begin
{$IFNDEF NoNet}
  if OptCalcForm <> nil then OptCalcForm.SetOptions;
{$ENDIF}
  PmContragentListForm.CustAppStorage := TSettingsManager.Instance.Storage;
end;

{$IFNDEF NoNet}

// !!!!!!!!!!!!!!!!!!!! APPSERVER и тогда сообщение можно не посылать
procedure NotifyLogon;
begin
  if (dm = nil) or (dm.cnCalc = nil) then Exit;
  Database.ExecuteNonQuery('exec up_AddUserIP ''' + Usr + ''', ''' + MForm.NotifServ.LocalIP + '''');
  SendNotif(RefreshUsersNotif);
end;

procedure NotifyLogoff;
begin
  if (dm = nil) or (dm.cnCalc = nil) then Exit;
  try
    Database.ExecuteNonQuery('exec up_DelUserIP ''' + Usr + '''');
  except end;
  SendNotif(RefreshUsersNotif);
end;

{$ENDIF}

function GetNoNameKeyFor(ADOCon: TADOConnection; const TableName, KeyFieldName: string; var KeyValue: integer): boolean;
var
  aq: TDataSet;
begin
{$IFNDEF Demo}
  Result := false;
  KeyValue := 0;
  aq := Database.ExecuteQuery('select N from ' + TableName + ' where Name = ''NONAME''');
  try
    if aq.RecordCount = 0 then
      RusMessageDlg('Не найден заказчик без имени в ' + TableName + '. Обратитесь к системному администратору', mtWarning, [mbOk], 0)
    else
    begin
      KeyValue := aq[KeyFieldName];
      Result := true;
    end;
  finally
    aq.Free;
  end;
  {with TADOQuery.Create(Application) do
  try
    Connection := ADOCon;
    SQL.Add('select N from ' + TableName + ' where Name = ''NONAME''');
    Active := true;
    if recordCount = 0 then
      RusMessageDlg('Не найден заказчик без имени в ' + TableName + '. Обратитесь к системному администратору', mtWarning, [mbOk], 0)
    else begin
      KeyValue := FieldByName('N').AsInteger;
      Result := true;
    end;
  finally
    Active := false;
    Free;
  end;}
{$ELSE}
  Result := true;
  KeyValue := 1;
{$ENDIF}
end;

// !!!!!!!!!!!!!!!!!!!! APPSERVER
function PasswordCheck(UserName, Password: string): boolean;
begin
  result := false;

  // FileUpdater начнет проверять обновления сразу после соединения
  FileUpdater.CheckEXEUpdate := Options.CheckEXEUpdate;
  FileUpdater.CheckXLSUpdate := Options.CheckXLSUpdate;

  Splash.Msg := 'Соединение с сервером...';
  Splash.Update;
  delay(10);
  TSettingsManager.Instance.CurUserLogin := UserName;
  if TSettingsManager.Instance.CurUserLogin <> '' then
  begin
    if dm = nil then Application.CreateForm(tdm, dm);
    if (dm <> nil) and not dm.cnCalc.Connected then
    begin
      FileUpdater.UserName := UserName;
      FileUpdater.Password := Password;
      TryConnect(TSettingsManager.Instance.CurUserLogin, Password);
    end;
    Result := (dm <> nil) and dm.cnCalc.Connected;
  end
  else
    RusMessageDlg('Не введено имя пользователя', mtError, [mbok], 0);
end;

procedure Alert(const Msg: string);
begin
  RusMessageDlg(Msg + '. Обратитесь к разработчикам.', mtWarning, [mbOk], 0);
end;

// !!!!!!!!!!!!!!!!!!!! APPSERVER тоже
// инициализация переменных и открытие таблиц, создание AppController
// и списка Entity.
procedure InitController;
begin
  try
    {$IFNDEF NoDocs}
    if PermitContract then Application.CreateForm(Tdmd, dmd);
    {$ENDIF}

    AppController.InitEntities;
    MForm.CreateViews(AppController.Entities);
    MForm.LoadViewSettings;

    {$IFNDEF Demo}
    // Получаем курс с сервера и вызываем SetCourse для обновления Controls в главной форме.
    if EntSettings.GetCourseOnStart then AppController.RequestUSDCourse;
    {$ELSE}
    MForm.SetCourse(sm.USDCourse);
    {$ENDIF}
    // Получение ключа заказчика без имени для возможности работы с пустыми заказчиками
    GetNoNameKeyFor(dm.cnCalc, 'Customer', TContragents.F_CustKey, TContragents.NoNameKey);
  except
     on E: Exception do begin
       dm.cnCalc.Connected := false;    // Отсоединились и до свидания...
       //raise;
       ExceptionHandler.Raise_(E);
     end;
    //RusMessageDlg('Ошибка инициализации данных', mtError, [mbok], 0);
    //raise;
  end;
end;

function UserLogin: boolean;
begin
  TSettingsManager.Instance.LoadUserName;
  TSettingsManager.Instance.LoadCheckUpdate;

  if ParamCount >= 2 then
  begin
    Result := PasswordCheck(ParamStr(1), ParamStr(2));
  end
  else
  begin
    Splash.SetPasswordMode;
    Splash.edUserName.Text := TSettingsManager.Instance.CurUserLogin;
    Splash.edPassword.Text := '';
    Splash.Show;
    repeat
      Application.ProcessMessages;
      Sleep(10);
    until Splash.CloseQuery;
    if Splash.ModalResult = mrCancel then
    //if Splash.ShowModal = mrCancel then
    begin
      LoadSuccess := false;
      Result := false;
    end
    else
    begin
      Splash.Show;
      Result := PasswordCheck(Splash.edUserName.Text, Splash.edPassword.Text);
    end;
  end;
end;

procedure LoadOrdStateSettings;
begin
  if MForm <> nil then
    TSettingsManager.Instance.LoadOrdStateSettings;
end;

procedure InitDataAccess;
begin
  //Application.CreateForm(Tsdm, sdm);
  sdm := Tsdm.Create(nil);
  // DicDm создается после Sdm и ExpDM!
  Application.CreateForm(TDicDm, DicDm);
  Application.CreateForm(Trdm, rdm);
  sdm.InitProcesses;
  TConfigManager.Instance.InitProcessCfg;
  // Форма TDMD создается по условию, и не здесь, а в IniCalc.IniDataModule
end;

// К этому моменту уже созданы все модули данных
procedure InitApplication;
begin
  Splash.Msg := 'Настройка среды...';
  delay(10);
  LoadAppSettings;   // Загрузка всех настроек

  Splash.Msg := 'Загрузка данных...';
  delay(10);

  InitController;

  SetupDialogs;

  //if dm <> nil then SetCurCalc;
 {$IFNDEF NoNet}
  OptCalcForm.InitNotif;
 {$ENDIF}

  Splash.Msg := 'Все.';
  delay(10);

  MForm.Caption := 'PolyMix Заказы   [Пользователь: ' + AccessManager.CurUser.Name + ']';

  //MForm.UpdateFilterControls;

  MForm.SetupServices; // Назначения сервисам обработчиков из MForm

  {$IFNDEF NoNet}
  MForm.Timer.Enabled := true;
  {$ENDIF}
  if (dm <> nil) and dm.cnCalc.Connected then MForm.Show else Exit;

  {$IFNDEF NoNet}
  OptCalcForm.SetNotifParams;
  NotifyLogon;
  {$ENDIF}
  dm.AddLogonEvent;

  //Messenger.Start;
  //MForm.MessageTimer.Enabled := true;

  LoadSuccess := true;
end;

procedure DoneApplication;
begin
  //Messenger.Stop;
  {$IFNDEF NoNet}
  NotifyLogoff;
  {$ENDIF}
  if dm <> nil then dm.AddLogoffEvent;
  if LoadSuccess then
      if MForm <> nil then
      begin
        TSettingsManager.Instance.SaveUserName;
        TSettingsManager.Instance.SaveMiscSettings;
        TConfigManager.Instance.SaveProcessSettings;
        //SaveCheckUpdate(MForm.AppStorage);
        SaveAppSettings;
      end;
      TSettingsManager.Instance.Storage.Flush;
  //DoneUsers;
  {$IFNDEF NoNet}
  OptCalcForm.DoneNotif;
  {$ENDIF}
end;

end.
