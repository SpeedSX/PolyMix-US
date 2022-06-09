unit CalcSettings;

interface

uses Classes, Graphics, JvAppStorage, SysUtils, NotifyEvent, XPMenu,
  Singleton, MyDBGridEh, jvImageList, Menus, JvFormPlacement;

{$I Calc.inc}

//type
//  TFullStateType = (fsNo, fsReadOnly, fsEdit);
  
const
  {$IFDEF IniStorage}
  iniName = 'calc.ini';
  {$ENDIF}
  {$IFDEF XMLStorage}
  iniName = 'pp_order.cfg';
  {$ENDIF}
  iniGlobal = 'Global';           
  iniInterface = 'Interface';
  iniMsgClient = 'Messages';
  iniSecretNames = 'SecretNames';
  iniReports = 'Reports';
  iniFilter = 'MainFilter';
  iniProductionFilter = 'ProductionFilter';
  iniPaymentsFilter = 'PaymentsFilter';
  iniInvoicesFilter = 'InvoicesFilter';
  iniCust = 'Customers';

  sDisabledPageText = 'DisabledPageText';
  sPageGroupBk = 'PageGroupBk';
  sPageGroupText = 'PageGroupText';
  sDisabledProcessBk = 'DisabledProcessBk';
  sDisabledProcessSelText = 'DisabledProcessSelText';
  sDisabledProcessText = 'DisabledProcessText';
  sNewPrice = 'NewPrice';
  sCurrentPrice = 'CurrentPrice';
  sPartBk = 'PartBk';
  sPartText = 'PartText';
  sFDText = 'FDText';
  sFDBack = 'FDBack';
  sUEBk = 'UEBk';
  sNText = 'NText';
  sNBack = 'NBack';
  sComInfoDraftBack = 'ComInfoDraftBack';
  sComInfoWorkBack = 'ComInfoWorkBack';
  sWorkTotalBk = 'WorkTotalBk';
  sWorkTotalText = 'WorkTotalText';
  sMatTotalBk = 'MatTotalBk';
  sMatTotalText = 'MatTotalText';
  sProcessTotalBk = 'ProcessTotalBk';
  sProcessTotalText = 'ProcessTotalText';
  sUrgentOrderText = 'UrgentOrderText';
  sProcessNameText = 'ProcessNameText';
  sParamsPanelBk = 'ParamsPanelBk';

type
  TOptions = class(TObject)
  private
    procedure FreeColorList;
  public
    ColorList: TStringList;
    ServFilter, SaveUser, NewAtEnd, CheckDep: boolean;
    HideOnEdit: boolean;
    GrayBtn, FlatBtn, ConfirmDelete, CheckEXEUpdate, CheckXLSUpdate: boolean;
    ShowFormula, AutoOpen: boolean;
    ShowOrderState, OrdStateRowColor, ShowPayState, ErrorEdit, ProcessAutoAppend,
    ProcessEnterAsTab, ShowShipmentState, ShowLockState: boolean;
    PageCostRowHeight: integer;
    PageCostRowLines: boolean;
    //FullOrdStateMode: TFullStateType;
    ShowFilterPanel, WideOrderList: boolean;
    EnableVB: boolean;
    ShowFinalNative: boolean;  // TRUE from 2.7.20
    VerboseLog: boolean;
    // состояния по умолчанию
    DefOrderPayState: variant; // состояние оплаты может быть не указано
    DefOrderExecState, DefProcessExecState: variant; // эти вообще-то должны быть указаны, то теоретически тоже могут отсутствовать
    fnBack, fnLogo: string;
    {$IFDEF NoFinance}
    DicPsw: string;
    {$ENDIF}
    TranspLogo, LogoEn, BackEn: boolean;
    // Для документов
    LinkFolderStr: string;
    // Это относится к экспорту, но пока находится здесь
    ExportAddComment: string;
    CopyToWork: boolean;   // означает, что исходный расчет сохраняется
    CopyToDraft: boolean;  // означает, что исходный заказ сохраняется  01.04.2009 - TRUE
    ShortExcel: boolean;   // укороченный интерфейс Excel
    XPStyleEnabled: boolean;
    ShowProcessCount: boolean;
    ContragentConfirmDelete: boolean;
    ScheduleFontSize: integer;
    ScheduleFontName: string;
    ScheduleShowCost: boolean;
    CustFilterMode: integer;  // фильтрация статуса заказчиков
    CustFilterCat: integer;  // фильтрация категории заказчиков
    CustFilterType: integer;  // фильтрация вида заказчиков
    //NewInvoices: boolean;
    MarkUrgentOrders: boolean; // выделять срочные (просроченные) заказы
    UrgentHours: integer;      // за сколько часов предупреждать (0 = просроченные)
    ShowUserLogin: boolean;    // Показывать логин пользователя в списке пользователей и свойствах заказа
    EmergencyMode: boolean;  // Не сохраняется и не загружается, устанавливается в коде
    ShowTotalInvoices: boolean; // Итоговые суммы в счетах (несовместимо с потсраничной загрузкой счетов)
    ShowTotalMatRequests: boolean; // Итоговые суммы в закупках (несовместимо с потсраничной загрузкой закупок)
    EditMatRequest: boolean; // Редактирование закупок прямо в таблице
    OpenOffice: boolean; // Использовать OpenOffice
    ShowMatDateInWorkOrderPreview: boolean; // Показывать даты план факт получения материалов и дату оплаты
                                  // при просмотре таблицы заказов (на закладке материалов).
    InvoiceNotPaidOnly: boolean; // настройка для диалога добавления новой позиции счета
                                 // - выбирать только неоплаченные
    InvoiceNotExistOnly: boolean; // настройка для диалога добавления новой позиции счета
                                 // - выбирать только те, для которых не созданы счета
    ConfirmQuit: boolean;
    function GetColor(const ColorName: string): TColor;
    procedure SetNewColor(const ColorName: string; ColorValue: integer);
    constructor Create;
    destructor Destroy; override;
  end;

type
  TColorObj = class(TObject)
  public
    Color: TColor;
    ColorDesc: string;
    //NewColor: TColor;
  end;

var
  Options: TOptions;  // управляется TSettingsManager, но оставлена как глобальная
                      // для удобства доступа.

type
  TSettingsManager = class(TSingleton)
  private
    FStorage: TJvCustomAppStorage;
    FMainFormStorage: TJvFormPlacement;
    MainXPMenu: TXPMenu; // можно использовать для придания другим формам-фреймам ХР-вида
    function CreateStorage: TJvCustomAppStorage;
    function GetXPFontName: string;
    procedure SetXPFontName(_FontName: string);
    //procedure ConvertSettingsFile;
    function OpenSettingsFile: TJvCustomAppStorage;
  public
    SettingsChanged: TNotifier;
    CurUserLogin: string; // Имя текущего пользователя
    NeedReload: boolean;
    MainImageList: TjvImageList;
    AppCourse: extended;   // Курс для новых заказов-расчетов
    DefaultReportID: integer;
    DefaultAllowInside: boolean;
    {procedure ApplyColors;
    procedure RevertColors;}
    procedure ReadColors(Ini: TJvCustomAppStorage; const Section: string);
    procedure WriteColors(Ini: TJvCustomAppStorage; const Section: string);
    function CreateXPPainter(Owner: TComponent): TXPMenu;
    procedure LoadInterfaceSettings;
    procedure LoadOrdStateSettings;
    procedure SaveCheckUpdate;
    procedure LoadCheckUpdate;
    procedure SaveUserName;
    procedure LoadUserName;
    procedure SaveInterfaceSettings;
    procedure SaveMiscSettings;
    procedure InitSingleton; override;
    procedure DestroySingleton; override;
    function ApplicationDataPath: string;
    function UserSettingsFilePath: string;
    function ReportTempPath: string;
    procedure SaveGridLayout(Grid: TMyDBGridEh; IniSection: string);
    procedure LoadGridLayout(Grid: TMyDBGridEh; IniSection: string);
    function Storage: TJvCustomAppStorage;
    property MainFormStorage: TJvFormPlacement read FMainFormStorage write FMainFormStorage;
    // Возвращает true, если надо включить XPMenu.
    function XPPainterEnabled: boolean;
    procedure XPActivateMenuItem(mi: TMenuItem; SubItems: boolean);
    procedure XPInitComponent(c: TComponent);
    property XPFontName: string read GetXPFontName write SetXPFontName;

    class function Instance: TSettingsManager;
  end;

implementation

uses ShlObj, TLoggerUnit, Windows, JclShell, JvJCLUtils, JclRegistry, JvAppXMLStorage,
  //JclPCRE, JclSimpleXML, это было для конвертирования настроек
  ExHandler, PmAppSettings, RDialogs, Dialogs;

const
  TEMP_REPORT_FOLDER = 'Reports';

{$REGION 'TOptions'}

function NewColorObj(Color: TColor; const ColorDesc: string): TColorObj;
var co: TColorObj;
begin
  co := TColorObj.Create;
  co.Color := Color;
  co.ColorDesc := ColorDesc;
  //co.NewColor := Color;
  Result := co;
end;

function TOptions.GetColor(const ColorName: string): TColor;
var i: integer;
begin
  if Assigned(ColorList) then
  begin
    i := ColorList.IndexOf(ColorName);
    if i >= 0 then Result := (ColorList.Objects[i] as TColorObj).Color
    else Raise EAssertionFailed.Create('Неизвестный цвет: ' + ColorName + '. Обратитесь к разработчику.');
  end
    else Raise EAssertionFailed.Create('Список цветов пуст');
end;

procedure TOptions.SetNewColor(const ColorName: string; ColorValue: integer);
var i: integer;
begin
  if Assigned(ColorList) then
  begin
    i := ColorList.IndexOf(ColorName);
    if i >= 0 then (ColorList.Objects[i] as TColorObj).Color := ColorValue
    else raise EAssertionFailed.Create('Неизвестный цвет: ' + ColorName + '. Обратитесь к разработчику.');
  end
    else raise EAssertionFailed.Create('Список цветов пуст');
end;

constructor TOptions.Create;
begin
  inherited;

  XPStyleEnabled := true;
  ShowFinalNative := true;
  
  ColorList := TStringList.Create;
  ColorList.AddObject(sNText, NewColorObj(clWhite, 'Заголовок панели: текст'));
  ColorList.AddObject(sNBack, NewColorObj(clGray, 'Заголовок панели: Фон'));
  ColorList.AddObject(sComInfoDraftBack, NewColorObj(clInfoBk, 'Панель информации о расчете: Фон'));
  ColorList.AddObject(sComInfoWorkBack, NewColorObj(clInfoBk, 'Панель информации о заказе: Фон'));
  ColorList.AddObject(sParamsPanelBk, NewColorObj($00A6CAF0, 'Панель параметров заказа: фон'));
  ColorList.AddObject(sUEBk, NewColorObj(clYellow, 'Стоимость заказа в основной валюте: фон'));
  ColorList.AddObject(sNewPrice, NewColorObj(clWindowText, 'Новая стоимость: текст'));
  ColorList.AddObject(sCurrentPrice, NewColorObj(clGray, 'Текущая стоимость: текст'));
  ColorList.AddObject(sFDText, NewColorObj(clWindowText, 'Дата сдачи заказа: текст'));
  ColorList.AddObject(sFDBack, NewColorObj(clYellow, 'Дата сдачи заказа: фон'));
  ColorList.AddObject(sDisabledPageText, NewColorObj(clDkGray, 'Незаполненная страница: текст'));
  ColorList.AddObject(sPageGroupText, NewColorObj(clWhite, 'Группа страниц: текст'));
  ColorList.AddObject(sPageGroupBk, NewColorObj(clDkGray, 'Группа страниц: фон'));
  ColorList.AddObject(sDisabledProcessSelText, NewColorObj(clInactiveCaptionText, 'Неактивный процесс выбранный: текст'));
  ColorList.AddObject(sDisabledProcessText, NewColorObj(clDkGray, 'Неактивный процесс: текст'));
  ColorList.AddObject(sDisabledProcessBk, NewColorObj(clWindow, 'Неактивный процесс: фон'));
  ColorList.AddObject(sPartText, NewColorObj(clWindowText, 'Часть в составе заказа: текст'));
  ColorList.AddObject(sPartBk, NewColorObj(clCream, 'Часть в составе заказа: фон'));
  ColorList.AddObject(sWorkTotalBk, NewColorObj(clBtnFace, 'Итог стоимости работ процесса: фон'));
  ColorList.AddObject(sWorkTotalText, NewColorObj(clWindowText, 'Итог стоимости работ процесса: текст'));
  ColorList.AddObject(sMatTotalBk, NewColorObj(clBtnFace, 'Итог стоимости материалов процесса: фон'));
  ColorList.AddObject(sMatTotalText, NewColorObj(clWindowText, 'Итог стоимости материалов процесса: текст'));
  ColorList.AddObject(sProcessTotalBk, NewColorObj(clInfoBk, 'Итог стоимости процесса: фон'));
  ColorList.AddObject(sProcessTotalText, NewColorObj(clWindowText, 'Итог стоимости процесса: текст'));
  ColorList.AddObject(sUrgentOrderText, NewColorObj(clRed, 'Срочный заказ: текст'));
  ColorList.AddObject(sProcessNameText, NewColorObj(clNavy, 'Название процесса: текст'));
end;

destructor TOptions.Destroy;
begin
  FreeColorList;
  inherited;
end;

procedure TOptions.FreeColorList;
var i: integer;
begin
  if Assigned(ColorList) then
  begin
    if ColorList.Count > 0 then
      for i := 0 to Pred(ColorList.Count) do ColorList.Objects[i].Free;
    FreeAndNil(ColorList);
  end;
end;

{$ENDREGION}

{$REGION 'TSettingsManager'}

function TSettingsManager.Storage: TJvCustomAppStorage;
begin
  if FStorage = nil then
    FStorage := CreateStorage;
  Result := FStorage;
end;

function TSettingsManager.OpenSettingsFile: TJvCustomAppStorage;
begin
  {$IFDEF IniStorage}
  Result := TJvAppIniFileStorage.Create(nil);
  (Result as TJvAppIniFileStorage).FileName := iniName;
  {$ENDIF}
  {$IFDEF XMLStorage}
  CheckConvertAppSettings(iniName);
  Result := TJvAppXMLFileStorage.Create(nil);
  (Result as TJvAppXMLFileStorage).RootNodeName := 'Configuration';
  (Result as TJvAppXMLFileStorage).Location := flUserFolder;
  (Result as TJvAppXMLFileStorage).FileName := 'PolyMix\' + iniName;
  {$ENDIF}
end;

{procedure TSettingsManager.ConvertSettingsFile;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.LoadFromFile(UserSettingsFilePath);
    // Тэги вида <MinMaxPos(1024x1208)> заменяем на <MinMaxPos_1024x1208_>
    sl.Text := StrReplaceRegEx(sl.Text, '</?[a-zA-Z]+Pos(?<Left>\()[0-9]+x[0-9]+(?<Right>\))>',
      ['Left', '_', 'Right', '_']);
    sl.SaveToFile(UserSettingsFilePath);
  finally
    sl.Free;
  end;
end;}

function TSettingsManager.CreateStorage: TJvCustomAppStorage;
var
  LocalName: string;
begin
  LocalName := AddPath(iniName, ExtractFileDir(ParamStr(0)));
  if not FileExists(UserSettingsFilePath)
     and FileExists(LocalName) then
  try
    CopyFile(PChar(LocalName), PChar(UserSettingsFilePath), false);
  except on E: Exception do
    begin
      ExceptionHandler.Log_(E, 'Ошибка копирования файла ' + LocalName + ' в ' + UserSettingsFilePath);
    end;
  end;

  //IniPath := ExtractFileDir(paramstr(0)) + '\';
  try
    Result := OpenSettingsFile;
  {except on E: EJclSimpleXMLError do
    begin
      // Конвертируем файл, если он в старом формате
      // Не получилось, т.к. заменяется только один инвалидный тег
      //ConvertSettingsFile;
      // И пробуем открыть еще раз
      Result := OpenSettingsFile;
    end;}
  except on E: Exception do
    begin
      ExceptionHandler.Log_(E, 'Ошибка создания файла ' + UserSettingsFilePath);
      RusMessageDlg('Не удалось открыть файл настроек ' + UserSettingsFilePath, mtWarning, [mbOk], 0);
      // Просто удаляем
      SysUtils.DeleteFile(UserSettingsFilePath);
      // И пробуем открыть еще раз
      Result := OpenSettingsFile;
    end;
  end;
end;

function TSettingsManager.ApplicationDataPath: string;
begin
  Result := JclShell.GetSpecialFolderLocation(CSIDL_APPDATA);
  Result := AddPath('PolyMix', Result);
  if not DirectoryExists(Result) then
    CreateDir(Result);
end;

function TSettingsManager.UserSettingsFilePath: string;
begin
  Result := AddPath(iniName, TSettingsManager.Instance.ApplicationDataPath);
end;

function TSettingsManager.ReportTempPath: string;
begin
  Result := AddPath(TEMP_REPORT_FOLDER, TSettingsManager.Instance.ApplicationDataPath);
  if not DirectoryExists(Result) then
    CreateDir(Result);
end;

{procedure ApplyColors;
var
  i: integer;
  co: TColorObj;
begin
  if ColorList.Count > 0 then
    for i := 0 to Pred(ColorList.Count) do begin
      co := ColorList.Objects[i] as TColorObj;
      co.Color := co.NewColor;
    end;
end;

procedure RevertColors;
var
  i: integer;
  co: TColorObj;
begin
  if ColorList.Count > 0 then
    for i := 0 to Pred(ColorList.Count) do begin
      co := ColorList.Objects[i] as TColorObj;
      co.NewColor := co.Color;
    end;
end;}

procedure TSettingsManager.ReadColors(Ini: TJvCustomAppStorage; const Section: string);
var i: integer;
begin
  if Options.ColorList.Count > 0 then
  begin
    for i := 0 to Pred(Options.ColorList.Count) do
      Options.SetNewColor(Options.ColorList[i], Ini.ReadInteger(Section + '\' + Options.ColorList[i], TColorObj(Options.ColorList.Objects[i]).Color));
    //ApplyColors;
  end;
end;

procedure TSettingsManager.WriteColors(Ini: TJvCustomAppStorage; const Section: string);
var i: integer;
begin
  if Options.ColorList.Count > 0 then
    for i := 0 to Pred(Options.ColorList.Count) do
      Ini.WriteInteger(Section + '\' + Options.ColorList[i], TColorObj(Options.ColorList.Objects[i]).Color);
end;

function TSettingsManager.CreateXPPainter(Owner: TComponent): TXPMenu;
begin
  Result := TXPMenu.Create(Owner);
  with Result do
  begin
    AutoDetect := true;
    DrawMenuBar := true;
    FlatMenu := true;
    UseSystemColors := false;
    //OverrideOwnerDraw := true;
    XPControls := [xcMainMenu, xcPopupMenu, xcCombo, xcEdit, xcMaskEdit, xcMemo,
      xcUpDown, xcBitBtn, xcSpeedButton, xcButton, xcCombo, xcPanel];
    Active := Options.XPStyleEnabled;
  end;
  MainXPMenu := Result;
end;

procedure TSettingsManager.LoadInterfaceSettings;
begin
  Storage;
  //try Options.ShowFinalNative := FStorage.ReadString(iniInterface + '\ShowFinalNative', '1') = '1';
  //except Options.ShowFinalNative := true; end;
  try Options.VerboseLog := FStorage.ReadString(iniInterface + '\VerboseLog', '0') = '1';
  except Options.VerboseLog := false; end;
  try Options.NewAtEnd := FStorage.ReadString(iniInterface + '\ShowNewAtEnd', '1') = '1';
  except Options.NewAtEnd := false; end;
  try Options.GrayBtn := FStorage.ReadString(iniInterface + '\GrayedButtons', '1') = '1';
  except Options.GrayBtn := true; end;
  try Options.FlatBtn := FStorage.ReadString(iniInterface + '\FlatButtons', '1') = '1';
  except Options.FlatBtn := true; end;

  ReadColors(Storage, iniInterface + '\Colors');

  try Options.ErrorEdit := FStorage.ReadString(iniInterface + '\ErrorEdit', '0') = '1';
  except Options.ErrorEdit := true; end;

  try Options.CheckDep := FStorage.ReadString(iniInterface + '\CheckDep', '1') = '1';
  except Options.CheckDep := true; end;
  try Options.AutoOpen := FStorage.ReadString(iniInterface + '\AutoOpen', '0') = '1';
  except Options.AutoOpen := false; end;
  try Options.HideOnEdit := FStorage.ReadString(iniInterface + '\HideOnEdit', '0') = '1';
  except Options.HideOnEdit := false; end;
  // см. OptIntLoadOrdStateSettings
  try Options.ShowFilterPanel := FStorage.ReadString(iniInterface + '\ShowFilterPanel', '1') = '1';
  except Options.ShowFilterPanel := true; end;
  try Options.WideOrderList := FStorage.ReadString(iniInterface + '\WideOrderList', '0') = '1';
  except Options.WideOrderList := true; end;

  {$IFDEF NoFinance}
  try Options.DicPsw := FStorage.ReadString(iniInterface + '\DicPsw', '30');
  except Options.DicPsw := '30'; end;
  {$ENDIF}
  try Options.ProcessAutoAppend := FStorage.ReadString(iniInterface + '\ProcessAutoAppend', '1') = '1';
  except Options.ProcessAutoAppend := true; end;
  try Options.ProcessEnterAsTab := FStorage.ReadString(iniInterface + '\ProcessEnterAsTab', '1') = '1';
  except Options.ProcessEnterAsTab := true; end;
  try Options.BackEn := FStorage.ReadString(iniInterface + '\BackEnabled', '1') = '1';
  except Options.BackEn := true; end;
  try Options.fnBack := FStorage.ReadString(iniInterface + '\BackFile', '');
  except Options.fnBack := ''; end;
  try Options.PageCostRowHeight := FStorage.ReadInteger(iniInterface + '\PageCostRowHeight', 16);
  except Options.PageCostRowHeight := 16; end;
  try Options.PageCostRowLines := FStorage.ReadString(iniInterface + '\PageCostRowLines', '1') = '1';
  except Options.PageCostRowLines := true; end;

  try Options.LinkFolderStr := FStorage.ReadString(iniInterface + '\LinkFolderStr', '');
  except Options.LinkFolderStr := ''; end;
  try Options.ConfirmDelete := FStorage.ReadString(iniInterface + '\ConfirmDelete', '0') = '1';
  except Options.ConfirmDelete := false; end;
  try Options.ContragentConfirmDelete := FStorage.ReadString(iniInterface + '\CustomerConfirmDelete', '1') = '1';
  except Options.ContragentConfirmDelete := true; end;
  try Options.ServFilter := FStorage.ReadString(iniInterface + '\ServerFilter', '1') = '1';
  except Options.ServFilter := true; end;

  try Options.ExportAddComment := FStorage.ReadString(iniInterface + '\ExportAddComment', '');
  except Options.ExportAddComment := '' end;

  try Options.CopyToWork := FStorage.ReadString(iniInterface + '\CopyToWork', '1') = '1';
  except Options.CopyToWork := true; end;
  {try Options.CopyToDraft := FStorage.ReadString(iniInterface + '\CopyToDraft', '1') = '1';
  except Options.CopyToDraft := true; end;}
  Options.CopyToDraft := true;

  try Options.XPStyleEnabled := FStorage.ReadString(iniInterface + '\XPStyleEnabled', '1') = '1';
  except Options.XPStyleEnabled := true; end;
  try Options.ShowProcessCount := FStorage.ReadString(iniInterface + '\ShowProcessCount', '0') = '1';
  except Options.ShowProcessCount := true; end;

  try Options.EnableVB := FStorage.ReadString(iniInterface + '\EnableVB', '1') = '1';
  except Options.EnableVB := true; end;
  try Options.ShortExcel := FStorage.ReadString(iniInterface + '\ShortExcel', '1') = '1';
  except Options.ShortExcel := true; end;
  try Options.ShowUserLogin := FStorage.ReadString(iniInterface + '\ShowUserLogin', '0') = '1';
  except Options.ShowUserLogin := false; end;

  try Options.ScheduleFontSize := FStorage.ReadInteger(iniInterface + '\ScheduleFontSize', 8);
  except Options.ScheduleFontSize := 8; end;
  try Options.ScheduleFontName := FStorage.ReadString(iniInterface + '\ScheduleFontName', 'Tahoma');
  except Options.ScheduleFontName := 'Tahoma'; end;
  try Options.ScheduleShowCost := FStorage.ReadString(iniInterface + '\ScheduleShowCost', '0') = '1';
  except Options.ScheduleShowCost := false; end;
  try Options.ConfirmQuit := FStorage.ReadString(iniInterface + '\ConfirmQuit', '0') = '1';
  except Options.ConfirmQuit := false; end;

{  try Options.NewInvoices := FStorage.ReadString(iniInterface + '\NewInvoices', '1') = '1';
  except Options.NewInvoices := true; end;}

  try Options.MarkUrgentOrders := FStorage.ReadString(iniInterface + '\MarkUrgentOrders', '0') = '1';
  except Options.MarkUrgentOrders := false; end;
  try Options.UrgentHours := FStorage.ReadInteger(iniInterface + '\UrgentHours', 0);
  except Options.UrgentHours := 0; end;
  try Options.ShowTotalInvoices := FStorage.ReadString(iniInterface + '\ShowTotalInvoices', '0') = '1';
  except Options.ShowTotalInvoices := false; end;
  try Options.EditMatRequest := FStorage.ReadString(iniInterface + '\EditMatRequest', '0') = '1';
  except Options.EditMatRequest := false; end;
  try Options.ShowTotalMatRequests := FStorage.ReadString(iniInterface + '\ShowTotalMatRequests', '0') = '1';
  except Options.ShowTotalMatRequests := false; end;
  try Options.OpenOffice := FStorage.ReadString(iniInterface + '\OpenOffice', '0') = '1';
  except Options.OpenOffice := false; end;
  try Options.ShowMatDateInWorkOrderPreview := FStorage.ReadString(iniInterface + '\ShowMatDateInWorkOrderPreview', '1') = '1';
  except Options.ShowMatDateInWorkOrderPreview := true; end;

  try Options.InvoiceNotPaidOnly := FStorage.ReadString(iniInterface + '\InvoiceNotPaidOnly', '0') = '1';
  except Options.InvoiceNotPaidOnly := false; end;
  try Options.InvoiceNotExistOnly := FStorage.ReadString(iniInterface + '\InvoiceNotExistOnly', '0') = '1';
  except Options.InvoiceNotExistOnly := false; end;

  MainXPMenu.Font.Name := FStorage.ReadString(iniInterface + '\MenuFontName', MainXPMenu.Font.Name);

  SettingsChanged.Notify(nil);
end;

procedure TSettingsManager.LoadOrdStateSettings;
begin
  try Options.ShowOrderState := FStorage.ReadString(iniInterface + '\ShowOrderState', '1') = '1';
  except Options.ShowOrderState := true; end;
  try Options.ShowPayState := FStorage.ReadString(iniInterface + '\ShowPayState', '1') = '1';
  except Options.ShowPayState := true; end;
  try Options.ShowShipmentState := FStorage.ReadString(iniInterface + '\ShowShipmentState', '0') = '1';
  except Options.ShowShipmentState := false; end;
  try Options.ShowLockState := FStorage.ReadString(iniInterface + '\ShowLockState', '0') = '1';
  except Options.ShowLockState := false; end;
  //try Options.FullOrdStateMode := TFullStateType(FStorage.ReadInteger(iniInterface + '\FullOrdStateMode', 0));
  //except Options.FullOrdStateMode := fsNo; end;
  try Options.OrdStateRowColor := FStorage.ReadString(iniInterface + '\OrdStateRowColor', '0') = '1';
  except Options.OrdStateRowColor := false; end;
end;

procedure TSettingsManager.SaveInterfaceSettings;
begin
  //try
    FStorage.WriteInteger(iniInterface + '\VerboseLog', Ord(Options.VerboseLog));
    //FStorage.WriteInteger(iniInterface + '\ShowFinalNative', Ord(Options.ShowFinalNative));
    FStorage.WriteInteger(iniInterface + '\ShowNewAtEnd', Ord(Options.NewAtEnd));
    FStorage.WriteInteger(iniInterface + '\GrayedButtons', Ord(Options.GrayBtn));
    FStorage.WriteInteger(iniInterface + '\FlatButtons', Ord(Options.FlatBtn));

    WriteColors(Storage, iniInterface + '\Colors');

    FStorage.WriteInteger(iniInterface + '\ErrorEdit', Ord(Options.ErrorEdit));
    FStorage.WriteInteger(iniInterface + '\CheckDep', Ord(Options.CheckDep));

    FStorage.WriteInteger(iniInterface + '\ShowOrderState', Ord(Options.ShowOrderState));
    FStorage.WriteInteger(iniInterface + '\OrdStateRowColor', Ord(Options.OrdStateRowColor));
    FStorage.WriteInteger(iniInterface + '\ShowPayState', Ord(Options.ShowPayState));
    FStorage.WriteInteger(iniInterface + '\ShowShipmentState', Ord(Options.ShowShipmentState));
    FStorage.WriteInteger(iniInterface + '\ShowLockState', Ord(Options.ShowLockState));
    //FStorage.WriteInteger(iniInterface + '\FullOrdStateMode', Ord(Options.FullOrdStateMode));

    FStorage.WriteInteger(iniInterface + '\ProcessAutoAppend', Ord(Options.ProcessAutoAppend));
    FStorage.WriteInteger(iniInterface + '\ProcessEnterAsTab', Ord(Options.ProcessEnterAsTab));
    FStorage.WriteInteger(iniInterface + '\LogoEnabled', Ord(Options.LogoEn));
    FStorage.WriteInteger(iniInterface + '\LogoTransparent', Ord(Options.TranspLogo));
    FStorage.WriteString(iniInterface + '\LogoFile', Options.fnLogo);
    FStorage.WriteInteger(iniInterface + '\BackEnabled', Ord(Options.BackEn));
    FStorage.WriteString(iniInterface + '\BackFile', Options.fnBack);
    {$IFDEF NoFinance}
    FStorage.WriteString(iniInterface + '\DicPsw', Options.DicPsw);  { TODO: Что такое DicPsw? }
    {$ENDIF}
    FStorage.WriteString(iniInterface + '\ExportAddComment', Options.ExportAddComment);
    FStorage.WriteString(iniInterface + '\LinkFolderStr', Options.LinkFolderStr);
    FStorage.WriteInteger(iniInterface + '\ConfirmDelete', Ord(Options.ConfirmDelete));
    FStorage.WriteInteger(iniInterface + '\CustomerConfirmDelete', Ord(Options.ContragentConfirmDelete));
    FStorage.WriteInteger(iniInterface + '\ShowFormula', Ord(Options.ShowFormula));
    FStorage.WriteInteger(iniInterface + '\ServerFilter', Ord(Options.ServFilter));
    FStorage.WriteInteger(iniInterface + '\AutoOpen', Ord(Options.AutoOpen));
    FStorage.WriteInteger(iniInterface + '\HideOnEdit', Ord(Options.HideOnEdit));
    FStorage.WriteInteger(iniInterface + '\PageCostRowLines', Ord(Options.PageCostRowLines));
    FStorage.WriteInteger(iniInterface + '\PageCostRowHeight', Options.PageCostRowHeight);

    FStorage.WriteInteger(iniInterface + '\XPStyleEnabled', Ord(Options.XPStyleEnabled));
    FStorage.WriteInteger(iniInterface + '\ShowProcessCount', Ord(Options.ShowProcessCount));

    FStorage.WriteInteger(iniInterface + '\EnableVB', Ord(Options.EnableVB));
    FStorage.WriteInteger(iniInterface + '\ShortExcel', Ord(Options.ShortExcel));
    FStorage.WriteInteger(iniInterface + '\ShowUserLogin', Ord(Options.ShowUserLogin));
    FStorage.WriteString(iniInterface + '\MenuFontName', MainXPMenu.Font.Name);

    FStorage.WriteInteger(iniInterface + '\ScheduleFontSize', Ord(Options.ScheduleFontSize));
    FStorage.WriteString(iniInterface + '\ScheduleFontName', Options.ScheduleFontName);
    FStorage.WriteInteger(iniInterface + '\ScheduleShowCost', Ord(Options.ScheduleShowCost));

    FStorage.WriteInteger(iniInterface + '\MarkUrgentOrders', Ord(Options.MarkUrgentOrders));
    FStorage.WriteInteger(iniInterface + '\UrgentHours', Ord(Options.UrgentHours));
    FStorage.WriteInteger(iniInterface + '\ShowTotalInvoices', Ord(Options.ShowTotalInvoices));
    FStorage.WriteInteger(iniInterface + '\EditMatRequest', Ord(Options.EditMatRequest));
    FStorage.WriteInteger(iniInterface + '\ShowTotalMatRequests', Ord(Options.ShowTotalMatRequests));
    FStorage.WriteInteger(iniInterface + '\OpenOffice', Ord(Options.OpenOffice));
    FStorage.WriteInteger(iniInterface + '\ShowMatDateInWorkOrderPreview', Ord(Options.ShowMatDateInWorkOrderPreview));
    FStorage.WriteInteger(iniInterface + '\ConfirmQuit', Ord(Options.ConfirmQuit));

  //except end;
end;

procedure TSettingsManager.LoadUserName;
begin
  Storage;
  try Options.SaveUser := FStorage.ReadString(iniInterface + '\SaveUserName', '1') = '1';
  except on Exception do Options.SaveUser := true; end;
  if Options.SaveUser then
    try CurUserLogin := FStorage.ReadString(iniGlobal + '\LastUser', '');
    except on Exception do CurUserLogin := ''; end
  else
    CurUserLogin := '';
end;

procedure TSettingsManager.SaveUserName;
begin
  //try
    Storage.WriteInteger(iniInterface + '\SaveUserName', Ord(Options.SaveUser));
    if Options.SaveUser then Storage.WriteString(iniGlobal + '\LastUser', CurUserLogin);
  //except end;
end;

procedure TSettingsManager.LoadCheckUpdate;
begin
  Storage;
  try Options.CheckEXEUpdate := FStorage.ReadString(iniInterface + '\CheckEXEUpdate', '1') = '1';
  except Options.CheckEXEUpdate := true; end;
  try Options.CheckXLSUpdate := FStorage.ReadString(iniInterface + '\CheckXLSUpdate', '1') = '1';
  except Options.CheckXLSUpdate := true; end;
end;

procedure TSettingsManager.SaveCheckUpdate;
begin
  //try
    FStorage.WriteInteger(iniInterface + '\CheckEXEUpdate', Ord(Options.CheckEXEUpdate));
    FStorage.WriteInteger(iniInterface + '\CheckXLSUpdate', Ord(Options.CheckXLSUpdate));
  //except end;
end;

procedure TSettingsManager.SaveMiscSettings;
begin
  FStorage.WriteInteger(iniInterface + '\ShowFilterPanel', Ord(Options.ShowFilterPanel));
  FStorage.WriteInteger(iniInterface + '\WideOrderList', Ord(Options.WideOrderList));
end;

procedure TSettingsManager.InitSingleton;
begin
  AfterConstruction;
  
  Options := TOptions.Create;

  Options.EmergencyMode := false;  // АВАРИЙНЫЙ РЕЖИМ

  SettingsChanged := TNotifier.Create;

end;

procedure TSettingsManager.DestroySingleton;
begin
  FreeAndNil(SettingsChanged);
  FreeAndNil(Options);
  FreeAndNil(FStorage);
end;

procedure TSettingsManager.SaveGridLayout(Grid: TMyDBGridEh; IniSection: string);
begin
  Grid.SaveToAppStore(Storage, IniSection);
end;

procedure TSettingsManager.LoadGridLayout(Grid: TMyDBGridEh; IniSection: string);
begin
  Grid.LoadFromAppStore(Storage, IniSection);
end;

class function TSettingsManager.Instance: TSettingsManager;
begin
  Result := TSettingsManager.NewInstance as TSettingsManager;
end;

function TSettingsManager.XPPainterEnabled: boolean;
var
  ThemeActive: boolean;
begin
  ThemeActive := MainXPMenu.IsWXP or MainXPMenu.IsW2003 or MainXPMenu.IsWVista;
  // Если активна тема XP, то не надо включать свою отрисовку.
  if ThemeActive then
    ThemeActive := RegReadStringDef(HKCU, 'Software\Microsoft\Windows\CurrentVersion\ThemeManager', 'ThemeActive', '0') = '1';
  Result := Options.XPStyleEnabled and not ThemeActive;
end;

procedure TSettingsManager.XPInitComponent(c: TComponent);
begin
  if XPPainterEnabled then
    MainXPMenu.InitComponent(c);
end;

procedure TSettingsManager.XPActivateMenuItem(mi: TMenuItem; SubItems: boolean);
begin
  if XPPainterEnabled then
    MainXPMenu.ActivateMenuItem(mi, SubItems);
end;

function TSettingsManager.GetXPFontName: string;
begin
  Result := MainXPMenu.Font.Name;
end;

procedure TSettingsManager.SetXPFontName(_FontName: string);
begin
  MainXPMenu.Font.Name := _FontName;
end;

{$ENDREGION}

end.
