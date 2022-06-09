unit DicFrm;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, ComCtrls, Buttons, ExtCtrls, DB, DBCLient, Menus, ADODB, ActiveX,
  Variants,

  JvDBSpinEdit, JvSpin, JvDBLookup, JvDBGrid, JvAppStorage,
  JvSplit, JvFormPlacement, JvxCheckListBox,

  MyDBGridEh,

  PmProcessCfg, PmAccessManager,
  ImgList, JvComponentBase, JvExControls, Mask, JvExMask, GridsEh, DBGridEh,
  Grids, DBGrids, JvExDBGrids, JvExExtCtrls, JvExtComponent, DBGridEhGrouping;

type
  TDicEditForm = class(TForm)
    pcConf: TPageControl;
    tsSrvGrp: TTabSheet;
    tsParams: TTabSheet;
    dgParams: TJvDBGrid;               
    sbNewPrm: TSpeedButton;
    sbDelPrm: TSpeedButton;
    GroupBox2: TGroupBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    paBut: TPanel;
    btOk: TButton;
    btCancel: TButton;
    Panel2: TPanel;
    paGrpLeft: TPanel;
    dgSrvGroups: TJvDBGrid;
    Panel7: TPanel;
    Label2: TLabel;
    Panel6: TPanel;
    sbNewGrp: TSpeedButton;
    sbDelGrp: TSpeedButton;
    GroupBox1: TGroupBox;
    Label8: TLabel;
    vgDBSpinEdit2: TJvDBSpinEdit;
    DBEdit3: TDBEdit;
    spPages: TJvxSplitter;
    Panel4: TPanel;
    paSrvPages: TPanel;
    Panel8: TPanel;
    Label7: TLabel;
    dgGrpPages: TJvDBGrid;
    Panel9: TPanel;
    sbNewSrvPage: TSpeedButton;
    sbDelSrvGrp: TSpeedButton;
    JvxSplitter3: TJvxSplitter;
    Panel10: TPanel;
    dgPageGrids: TJvDBGrid;
    DBCheckBox3: TDBCheckBox;
    JvDBSpinEdit1: TJvDBSpinEdit;
    Label11: TLabel;
    DBCheckBox5: TDBCheckBox;
    Panel11: TPanel;
    Label9: TLabel;
    JvFormStorage1: TJvFormStorage;
    btEditOnCreateFrame: TButton;
    DBCheckBox6: TDBCheckBox;
    DBCheckBox7: TDBCheckBox;
    tsOrdKind: TTabSheet;
    spKind: TJvxSplitter;
    paKinds: TPanel;
    dgOrderKind: TJvDBGrid;
    Panel15: TPanel;
    Label3: TLabel;
    Panel16: TPanel;
    sbNewKind: TSpeedButton;
    sbDelKind: TSpeedButton;
    GroupBox3: TGroupBox;
    DBEdit4: TDBEdit;
    paProcessKinds: TPanel;
    Panel18: TPanel;
    Label10: TLabel;
    dgKindProcess: TJvDBGrid;
    Panel19: TPanel;
    sbAddKindProcess: TSpeedButton;
    sbDeleteKindProcess: TSpeedButton;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox9: TDBCheckBox;
    tsUser: TTabSheet;
    sbAddAllKindProcess: TSpeedButton;
    paUsers: TPanel;
    dgUsers: TDBGridEh;
    Panel21: TPanel;
    Label13: TLabel;
    Panel22: TPanel;
    sbAddUser: TSpeedButton;
    sbDelUser: TSpeedButton;
    Panel23: TPanel;
    paKindAccessHeader: TPanel;
    Label14: TLabel;
    JvxSplitter6: TJvxSplitter;
    sbCopyUser: TSpeedButton;
    DBEdit5: TDBEdit;
    Label15: TLabel;
    Label16: TLabel;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    Label17: TLabel;
    paKindAccess: TPanel;
    paUserAccess: TPanel;
    boxUserAccess: TJvxCheckListBox;
    JvxSplitter7: TJvxSplitter;
    pcKindAccess: TPageControl;
    tsKindXS: TTabSheet;
    tsProcXS: TTabSheet;
    Panel25: TPanel;
    cbOrderKind: TJvDBLookupCombo;
    Label18: TLabel;
    Panel26: TPanel;
    sbCheckAllUser: TSpeedButton;
    sbUnCheckAllUser: TSpeedButton;
    Panel27: TPanel;
    sbCheckAllKind: TSpeedButton;
    sbUncheckAllKind: TSpeedButton;
    boxKindAccess: TJvxCheckListBox;
    dgProcessAccess: TMyDBGridEh;
    paProcessAccess: TPanel;
    boxProcAccess: TJvxCheckListBox;
    cbDefOrderKind: TJvDBLookupCombo;
    Label19: TLabel;
    rbDraftAccess: TRadioButton;
    rbWorkAccess: TRadioButton;
    Panel28: TPanel;
    sbCheckAllKindProcess: TSpeedButton;
    sbUncheckAllKindProcess: TSpeedButton;
    JvxSplitter8: TJvxSplitter;
    pmCheckAllProc: TPopupMenu;
    N1: TMenuItem;
    miCheckAllProcAllProcCurKind: TMenuItem;
    miCheckAllProcCur: TMenuItem;
    pmCheckAllKind: TPopupMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    miCheckAllProcCurProcAllKinds: TMenuItem;
    DBCheckBox4: TDBCheckBox;
    Label20: TLabel;
    JvDBLookupCombo1: TJvDBLookupCombo;
    dsUserRoles: TDataSource;
    cdUserRoles: TClientDataSet;
    cbMainProcess: TDBLookupComboBox;
    Label21: TLabel;
    pmSrv: TPopupMenu;
    pmUserPass: TPopupMenu;
    btnUserPass: TMenuItem;
    procedure btOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dgServicesGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure sbDelGrpClick(Sender: TObject);
    procedure sbNewGrpClick(Sender: TObject);
    procedure pcConfChange(Sender: TObject);
    procedure sbNewSrvPageClick(Sender: TObject);
    procedure sbDelSrvGrpClick(Sender: TObject);
    procedure pcConfChanging(Sender: TObject; var AllowChange: Boolean);
    procedure btEditOnCreateFrameClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure sbNewKindClick(Sender: TObject);
    procedure sbDelKindClick(Sender: TObject);
    procedure sbAddKindProcessClick(Sender: TObject);
    procedure sbDeleteKindProcessClick(Sender: TObject);
    procedure sbAddAllKindProcessClick(Sender: TObject);
    procedure cbOrderKindChange(Sender: TObject);
    procedure sbCheckAllUserClick(Sender: TObject);
    procedure sbUnCheckAllUserClick(Sender: TObject);
    procedure sbCheckAllKindClick(Sender: TObject);
    procedure sbUncheckAllKindClick(Sender: TObject);
    procedure sbCheckAllKindProcessClick(Sender: TObject);
    procedure sbUncheckAllKindProcessClick(Sender: TObject);
    procedure sbAddUserClick(Sender: TObject);
    procedure miCheckAllProcCurClick(Sender: TObject);
    procedure miCheckAllProcCurProcAllKindClick(Sender: TObject);
    procedure miCheckAllProcAllProcCurKindClick(Sender: TObject);
    procedure miCheckAllProcAllProcAllKindClick(Sender: TObject);
    procedure sbCopyUserClick(Sender: TObject);
    procedure sbDelUserClick(Sender: TObject);
    procedure dgUsersGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure btnUserPassClick(Sender: TObject);
  private
    FDicOnly: boolean;
    CurService: TPolyProcessCfg; // используется при редактированиии скриптов
    CurGrid: TProcessGridCfg;   { TODO: эти две строки надо тоже заменить на CurScriptedObj: TScriptedObjCfg }
    AppStorage: TJvCustomAppStorage;
    KRec: TKindPerm;
    KPRec: TKindProcPerm;
    CurKindAccessID: integer;
    CurKindDraft: boolean;
    CurProcessID: integer;
    CurUserID: integer;
    ApplyingUsers, DisableProcSetData, CheckAllProcMode: boolean;
    Save_cdSrvPagesNewRecord, Save_cdSrvGrpsAfterScroll,
    Save_cdSrvPagesAfterScroll,
    //Save_cdServicesAfterScroll, Save_cdProcessGridsAfterScroll,
    Save_cdOrderKindAfterScroll, Save_cdKindProcessNewRecord,
    Save_cdAccessUserAfterScroll, Save_cdAccessUserBeforeScroll,
    Save_cdAccessProcAfterScroll, Save_cdAccessProcBeforeScroll: TDataSetNotifyEvent;
    HandlersAssigned, CfgActivated: boolean;
    //cdUserRoles: TDataSet;
    //procedure cdServicesAfterScroll(Dataset: TDataSet);
    procedure cdSrvGrpsAfterScroll(Dataset: TDataSet);
    procedure cdSrvPagesAfterScroll(Dataset: TDataSet);
    procedure cdOrderKindAfterScroll(Dataset: TDataSet);
    procedure cdSrvPagesNewRecord(Dataset: TDataSet);
    procedure cdKindProcessNewRecord(Dataset: TDataSet);
    procedure cdAccessUserBeforeScroll(Dataset: TDataSet);
    procedure cdAccessUserAfterScroll(Dataset: TDataSet);
    procedure cdAccessProcBeforeScroll(Dataset: TDataSet);
    procedure cdAccessProcAfterScroll(Dataset: TDataSet);
    procedure RestoreDataSets;
    procedure pmAddKindProcessClick(Sender: TObject);
    procedure FillAddProcessMenu;
    procedure EnableUserControls;
    procedure DisableUserControls;
    procedure ControlsToUserData;
    function UserDataToControls: boolean;
    procedure UserKindDataToControls;
    procedure ControlsToUserKindData;
    procedure ControlsToUserKindProcData;
    procedure UserKindProcDataToControls;
    procedure AllControlsToUserData;
    procedure CheckAllBox(box: TjvxCheckListBox; Val: boolean);
    procedure ApplyUsers;
    procedure RefreshUsers;
    procedure ApplySrvGroupsPages(DoOpen: boolean);
  public
    procedure SetVisiblePages(DicOnly: boolean);
    procedure SaveSettings;
    procedure LoadSettings;
  end;

const
  DictionaryDescIndex = 0;
  DictionaryNameIndex = 1;

var
  DicEditForm: TDicEditForm;

function ExecDicEditForm(DicOnly: boolean; AppStorage: TJvCustomAppStorage): boolean;
procedure CreateDicEditForm(DicOnly: boolean);
procedure DestroyDicEditForm(DicOnly: boolean);

implementation

uses MainData, ServData, RDialogs, RDBUtils, EScrFrm, CalcSettings, AccessDM,
  PmConfigManager, ExHandler, PmProcessCfgData;

{$R *.DFM}

var
  NeedRefreshServices: boolean;

// Внимание! Вызывает обновление компонент процессов
// и страниц только при DoOpen=true! (false сейчас не используется) 02.05.2004
procedure TDicEditForm.ApplySrvGroupsPages(DoOpen: boolean);
var
  k1, k2, k3, k4, k5, k6: integer;
begin
  //try
    if sdm.cdSrvGrps.State in [dsEdit, dsInsert] then sdm.cdSrvGrps.Post;
    if sdm.cdSrvPages.State in [dsEdit, dsInsert] then sdm.cdSrvPages.Post;
    //k1 := NvlInteger(sdm.cdServices[F_SrvID]);
    //k4 := NvlInteger(sdm.cdProcessGrids[F_GridID]);
    k2 := NvlInteger(sdm.cdSrvGrps['GrpID']);
    k3 := NvlInteger(sdm.cdSrvPages[F_ProcessPageID]);
    k5 := NvlInteger(sdm.cdOrderKind['KindID']);
    k6 := NvlInteger(sdm.cdKindProcess['KindProcessID']);
    //if sdm.cdServices.State in [dsEdit, dsInsert] then sdm.cdServices.Post;
    //if sdm.cdProcessGrids.State in [dsEdit, dsInsert] then sdm.cdProcessGrids.Post;
    if sdm.cdOrderKind.State in [dsEdit, dsInsert] then sdm.cdOrderKind.Post;
    if sdm.cdKindProcess.State in [dsEdit, dsInsert] then sdm.cdKindProcess.Post;
    if sdm.cdPageGrids.Active and (sdm.cdPageGrids.State in [dsEdit, dsInsert]) then
      sdm.cdPageGrids.Post;
    NeedRefreshServices := NeedRefreshServices
    //or (sdm.cdServices.ChangeCount > 0)
      or (sdm.cdSrvGrps.ChangeCount > 0)
      or (sdm.cdSrvPages.ChangeCount > 0)
      or (sdm.cdPageGrids.ChangeCount > 0)
      //or (sdm.cdProcessGrids.ChangeCount > 0)
      or (sdm.cdOrderKind.ChangeCount > 0)
      or (sdm.cdKindProcess.ChangeCount > 0);
    sdm.ApplyProcessCfg;
    sdm.CloseSrvGroups;
    sdm.CloseSrvPages;
    sdm.ClosePageGrids;
    //sdm.CloseProcessGrids;
    sdm.CloseOrderKind;
    sdm.CloseKindProcess;
    if DoOpen then begin
      sdm.RefreshSrvGroups;
      sdm.RefreshSrvPages;
      sdm.RefreshPageGrids;
      //sdm.RefreshProcessGrids;
      sdm.RefreshOrderKind;
      sdm.RefreshKindProcess;
      if NeedRefreshServices then
      begin
        TConfigManager.Instance.RefreshProcessCfg;
        RefreshUsers;
      end;
      NeedRefreshServices := false;
      //sdm.cdServices.Locate(F_SrvID, k1, []);
      //sdm.cdProcessGrids.Locate(F_GridID, k4, []);
      sdm.cdSrvGrps.Locate('GrpID', k2, []);
      sdm.cdSrvPages.Locate(F_ProcessPageID, k3, []);
      sdm.cdOrderKind.Locate('KindID', k5, []);
      sdm.cdKindProcess.Locate('KindProcessID', k6, []);
    end;
  //except on E: Exception do
  //end;
end;

procedure CreateDicEditForm(DicOnly: boolean);
begin
  Application.CreateForm(TDicEditForm, DicEditForm);
  try
    TConfigManager.Instance.DictionaryList.Open;
    if not DicOnly then
    begin
      //sdm.OpenServices;
      sdm.RefreshOrderKind;
      sdm.RefreshKindProcess;
      if AccessManager.CurUser.EditUsers then
      begin
        //adm.OpenUsers;
        DicEditForm.cdUserRoles.CloneCursor(AccessManager.UserData, true);
        DicEditForm.cdUserRoles.Filter := 'IsRole';
        DicEditForm.cdUserRoles.Filtered := true;
      end;
    end;
  except
    FreeAndNil(DicEditForm);
    raise;
  end;
end;

procedure DestroyDicEditForm(DicOnly: boolean);
begin
  FreeAndNil(DicEditForm);
end;

// true если все успешно (ок и отмена не играют роли)
function ExecDicEditForm(DicOnly: boolean; AppStorage: TJvCustomAppStorage): boolean;
begin
  Result := false;
  CreateDicEditForm(DicOnly);
  try
    DicEditForm.AppStorage := AppStorage;
    DicEditForm.SetVisiblePages(DicOnly);
    Result := DicEditForm.ShowModal = mrOk;
  finally
    DestroyDicEditForm(DicOnly);
  end;
end;

{procedure TDicEditForm.cdServicesAfterScroll(Dataset: TDataSet);
var
  en, IsBased, Act: boolean;
  Srv: TPolyProcessCfg;
begin
    en := not DataSet.IsEmpty;
    Act := NvlBoolean(DataSet['SrvActive']);
    IsBased := NvlInteger(DataSet['BaseSrvID']) > 0;
    lkSrvPage.Enabled := en and Act;
    lbSrvPage.Enabled := en and Act;
    lbGrpNum.Enabled := en and Act;
    edGrpNum.Enabled := en and Act;
    btCode.Enabled := en and not IsBased and Act;
    if en and Act and not VarIsNull(sdm.cdServices[F_SrvID]) then begin
      Srv := TConfigManager.Instance.ServiceByID(sdm.cdServices[F_SrvID]);
      btStruct.Enabled := (Srv <> nil) and not IsBased;
    end
    else
      btStruct.Enabled := false;
    sdm.SetCurProcess(NvlInteger(sdm.cdServices[F_SrvID]));
end;}

{procedure TDicEditForm.cdGridsAfterScroll(Dataset: TDataSet);
var
  en, IsBased, Act: boolean;
begin
  en := not DataSet.IsEmpty;
  Act := NvlBoolean(sdm.cdServices['SrvActive']);
  IsBased := NvlInteger(DataSet['BaseGridID']) > 0;
  btCols.Enabled := en and not IsBased and DataSet['EditableGrid'] and Act;
  btGridCode.Enabled := en and not IsBased and Act;
end;}

procedure TDicEditForm.cdSrvGrpsAfterScroll(Dataset: TDataSet);
begin
  if pcConf.ActivePage = tsSrvGrp then
  if not DataSet.IsEmpty then
    sdm.SetCurGrp(NvlInteger(DataSet['GrpID']));
end;

procedure TDicEditForm.cdSrvPagesAfterScroll(Dataset: TDataSet);
begin
  if pcConf.ActivePage = tsSrvGrp then
  if not DataSet.IsEmpty then
    sdm.SetCurPage(NvlInteger(DataSet[F_ProcessPageID]));
end;

procedure TDicEditForm.btOkClick(Sender: TObject);
begin
  RestoreDataSets;
    if not FDicOnly then
    begin
      ApplySrvGroupsPages(true);
      if AccessManager.CurUser.EditUsers then ApplyUsers;
    end;
  SaveSettings;
end;

procedure TDicEditForm.RestoreDataSets;
begin
  if not FDicOnly and HandlersAssigned then
  begin
    if Assigned(Save_cdSrvPagesNewRecord) then
      sdm.cdSrvPages.OnNewRecord := Save_cdSrvPagesNewRecord;
    if Assigned(Save_cdKindProcessNewRecord) then
      sdm.cdKindProcess.OnNewRecord := Save_cdKindProcessNewRecord;
    sdm.cdSrvGrps.AfterScroll := Save_cdSrvGrpsAfterScroll;
    sdm.cdSrvPages.AfterScroll := Save_cdSrvPagesAfterScroll;
    sdm.cdOrderKind.AfterScroll := Save_cdOrderKindAfterScroll;
    sdm.cdSrvPages.Filtered := false;
    sdm.cdSrvPages.Filter := '';
    sdm.cdPageGrids.Filtered := false;
    sdm.cdPageGrids.Filter := '';
    sdm.cdKindProcess.Filtered := false;
    sdm.cdKindProcess.Filter := '';
    adm.cdAccessUser.AfterScroll := Save_cdAccessUserAfterScroll;
    adm.cdAccessUser.BeforeScroll := Save_cdAccessUserBeforeScroll;
    adm.cdAccessProc.AfterScroll := Save_cdAccessProcAfterScroll;
    adm.cdAccessProc.BeforeScroll := Save_cdAccessProcBeforeScroll;
    HandlersAssigned := false;
  end;
end;

procedure TDicEditForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RestoreDataSets;
  if ModalResult = mrNone then
    btCancelClick(Sender);
end;

procedure TDicEditForm.btCancelClick(Sender: TObject);
begin
    if not FDicOnly then
    begin
      try
        sdm.CancelProcessCfg;
      except
        RusMessageDlg('Ошибка отмены изменений в процессах', mtWarning, [mbOk], 0);
      end;
      if AccessManager.CurUser.EditUsers then adm.CancelUsers;
    end;
end;

procedure TDicEditForm.dgServicesGetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
  try
    if (Field <> nil) and not Highlight then
    begin
      if not Field.DataSet['SrvActive'] then Background := clSilver;
    end;
  except end;
end;

procedure TDicEditForm.FormCreate(Sender: TObject);
begin
  with boxUserAccess, Items do
  begin
    Clear;
    Add('Изменение прав пользователей');
    Add('Изменение справочников');
    Add('Изменение процессов');
    Add('Изменение отчетов');
    Add('Загрузка файлов на сервер');
    Add('Установка курса у.е.');
    Add('Доступ только к своим расчетам');
    Add('Доступ только к своим заказам и счетам');
    Add('Просмотр загрузки оборудования');
    Add('Добавление заказчика');
    Add('Удаление своего заказчика');
    Add('Изменение/удаление чужого заказчика');
    Add('Отображение чужих заказчиков');
    Add('Изменение владельца заказчика');
    Add('Постраничная загрузка');
    Add('Просмотр отчетов');
    Add('Создание/изменение отчетов');
    Add('Удаление отчетов');
    Add('Просмотр расчетов с заказчиками');
    Add('Добавление поступлений');
    Add('Изменение/удаление поступлений');
    Add('Просмотр счетов');
    Add('Создание/изменение счетов');
    Add('Удаление счетов');
    Add('Объяснять снятие работы в плане');
    Add('Просмотр работ в очереди');
    Add('Просмотр работ по оборудованию');
    Add('Показывать просроченные заказы этого пользователя');
    Add('Просмотр отгрузки');
    Add('Создание/изменение отгрузки');
    Add('Удаление отгрузки');
    Add('Разрешение отгрузки');
    Add('Разрешение закупки материалов');
    Add('Просмотр закупок');
    Add('Изменение даты оплаты материалов');
    Add('Изменение статуса оплаты заказа');
  end;
  with boxProcAccess, Items do
  begin
    Clear;
    Add('Просмотр записей');
    Add('Добавление записи');
    Add('Изменение записи');
    Add('Удаление записи');
    Add('Установка плановых дат');
    Add('Установка фактических дат');
  end;
  with boxKindAccess, Items do
  begin
    Clear;
    Add('Создание');
    Add('Изменение состава своего заказа');
    Add('Изменение состава чужого заказа');
    Add('Удаление своего');
    Add('Удаление чужого');
    Add('Просмотр');
    Add('Вход');
    Add('Проверка при сохранении');
    Add('Просмотр цен');
    Add('Просмотр стоимости');
    Add('Преобразование в заказ');
    Add('Преобразование в черновик');
    Add('Установка плановой даты начала работ');
    Add('Установка плановой даты сдачи');
    Add('Установка фактической даты начала работ');
    Add('Установка фактической даты сдачи');
    Add('Отображение наценки при просмотре');
    Add('Отображение наценки внутри заказа');
    Add('Изменение наценки');
    Add('Доступ только к защищенным');
    Add('Защита стоимости');
    Add('Защита состава');
    Add('Изменение владельца заказа');
    Add('Изменение условий оплаты');
    Add('Отмена заявки на материал');
    Add('Изменение заявки на материал');
    Add('Просмотр фактических затрат');
  end;

  {frTabDic := TfrTabDic.Create(Self);
  DicEditForm.RemoveControl(frTabDic);
  paDicFrame.InsertControl(frTabDic);
  frTabDic.Visible := true;
  frTabDic.Align := alClient;

  frDimDic := TfrDimDic.Create(Self);
  DicEditForm.RemoveControl(frDimDic);
  paDicFrame.InsertControl(frDimDic);
  frDimDic.Visible := false;

  frEmptyTabDic := TfrEmptyTabDic.Create(Self);
  DicEditForm.RemoveControl(frEmptyTabDic);
  paDicFrame.InsertControl(frEmptyTabDic);
  frEmptyTabDic.Visible := false;}

  NeedRefreshServices := false;
end;

procedure TDicEditForm.SetVisiblePages(DicOnly: boolean);
begin
  FDicOnly := DicOnly;
  //tsSrv.TabVisible := not FDicOnly;
  tsSrvGrp.TabVisible := not FDicOnly;
  tsParams.TabVisible := not FDicOnly;
  tsOrdKind.TabVisible := not FDicOnly;
  tsUser.TabVisible := not FDicOnly and AccessManager.CurUser.EditUsers;
//  pcConf.ActivePage := tsDic;
end;

procedure TDicEditForm.sbDelGrpClick(Sender: TObject);
begin
  if sdm.cdSrvGrps.Active and not sdm.cdSrvGrps.IsEmpty
    and (RusMessageDlg('Вы действительно желаете удалить группу ''' +
    sdm.cdSrvGrps['GrpDesc'] +
    '''?'#13 + 'Страницы этой группы будут удалены.' +
    #13 + 'Процессы, размещенные на этих страницах, не будут удалены.',
    mtConfirmation, mbYesNoCancel, 0) = mrYes) then
      sdm.cdSrvGrps.Delete;
end;

procedure TDicEditForm.sbNewGrpClick(Sender: TObject);
begin
  ApplySrvGroupsPages(true);  // reopen
  sdm.cdSrvGrps.Append;
  ApplySrvGroupsPages(true);  // reopen
  sdm.cdSrvGrps.Locate('GrpID', NewGrpID, []);
end;

procedure TDicEditForm.pcConfChange(Sender: TObject);
begin
  {if pcConf.ActivePage = tsSrv then
  begin
    sdm.cdServices.AfterScroll(sdm.cdServices);
    sdm.cdSrvPages.Filtered := false;
    lkSrvPage.ListSource := sdm.dsSrvPages;  // refresh
  end
  else}
  if pcConf.ActivePage = tsSrvGrp then
  begin
    sdm.cdSrvGrps.AfterScroll(sdm.cdSrvGrps);
    sdm.cdSrvPages.Filtered := true;
  end
  else
  if pcConf.ActivePage = tsOrdKind then
  begin
    sdm.cdOrderKind.AfterScroll(sdm.cdOrderKind);
    sdm.cdOrderKind.Filtered := true;
  end
  else
  if pcConf.ActivePage = tsUser then
  begin
    adm.cdAccessUser.AfterScroll(adm.cdAccessUser);
  end;
end;

procedure TDicEditForm.pcConfChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if (pcConf.ActivePage = tsSrvGrp)
    //or (pcConf.ActivePage = tsSrv)
     or (pcConf.ActivePage = tsOrdKind) then
    ApplySrvGroupsPages(true)
  else if pcConf.ActivePage = tsUser then
    ApplyUsers;
end;

procedure TDicEditForm.cdSrvPagesNewRecord(Dataset: TDataSet);
begin
  if Assigned(Save_cdSrvPagesNewRecord) then Save_cdSrvPagesNewRecord(DataSet);
  if sdm.cdSrvGrps.Active then DataSet['GrpID'] := sdm.cdSrvGrps['GrpID'];
end;

procedure TDicEditForm.sbNewSrvPageClick(Sender: TObject);
begin
  sdm.cdSrvPages.Append;
end;

procedure TDicEditForm.sbDelSrvGrpClick(Sender: TObject);
begin
  if sdm.cdSrvPages.Active and not sdm.cdSrvPages.IsEmpty
    and (RusMessageDlg('Вы действительно желаете удалить страницу ''' +
    sdm.cdSrvPages['PageCaption'] +
    '''?'#13 + 'Процессы, размещенные на этой странице, не будут удалены.',
    mtConfirmation, mbYesNoCancel, 0) = mrYes) then
      sdm.cdSrvPages.Delete;
end;

procedure TDicEditForm.SaveSettings;
begin
  with TSettingsManager.Instance do
  begin
    //Storage.WriteInteger(iniInterface + '\paDicLeftWidth', paDicLeft.Width);
    Storage.WriteInteger(iniInterface + '\paGrpLeftWidth', paGrpLeft.Width);
    Storage.WriteInteger(iniInterface + '\paSrvPagesHeight', paSrvPages.Height);
  end;
end;

procedure TDicEditForm.LoadSettings;
begin
  with TSettingsManager.Instance do
  begin
    //paDicLeft.Width := Storage.ReadInteger(iniInterface + '\paDicLeftWidth', paDicLeft.Width);
    paGrpLeft.Width := Storage.ReadInteger(iniInterface + '\paGrpLeftWidth', paGrpLeft.Width);
    paSrvPages.Height := Storage.ReadInteger(iniInterface + '\paSrvPagesHeight', paSrvPages.Height);
  end;
end;

procedure TDicEditForm.btEditOnCreateFrameClick(Sender: TObject);
begin
  if not sdm.cdSrvPages.Active or sdm.cdSrvPages.IsEmpty then Exit;
  EditScript(sdm.cdSrvPages, '', '', 'OnCreateFrame', '');
end;

procedure TDicEditForm.btnUserPassClick(Sender: TObject);
var
  newPass : string;
  tmpQuery: TADOQuery;
  s: String;
  ds:TDataSource;
begin
  newPass := InputBox('Задать пароль для ' + dgUsers.Columns[1].Field.Value ,'Укажите новый пароль','');
  if NewPass <> '' then
  begin
    try
      try
        tmpQuery := TADOQuery.Create(nil);
        tmpQuery.Connection := dm.cnCalc;
        tmpQuery.SQL.Text:='alter login ' +dgUsers.Columns[1].Field.Value + ' with password = ''' + NewPass + '''';
//      tmpQuery.Parameters.ParamByName('newPass').Value := NewPass;
        tmpQuery.ExecSQL;
        showMessage('Пароль изменен успешно.');
      except
        showMessage('Возникла ошибка при смене пароля. Обратитесь к разработчику.');
      end;

    finally
     tmpQuery.Close;
     tmpQuery.Free;
    end;
  end;

end;

procedure TDicEditForm.FormActivate(Sender: TObject);
begin
  if CfgActivated then Exit;
  HandlersAssigned := false;
  LoadSettings;
  if not FDicOnly then
  begin
    sdm.RefreshSrvGroups;
    sdm.RefreshSrvGridCols;
    sdm.RefreshSrvPages;
    sdm.RefreshPageGrids;
    sdm.SetCurPage(0);

    Save_cdSrvGrpsAfterScroll := sdm.cdSrvGrps.AfterScroll;
    Save_cdSrvPagesAfterScroll := sdm.cdSrvPages.AfterScroll;
    //Save_cdProcessGridsAfterScroll := sdm.cdProcessGrids.AfterScroll;
    //Save_cdServicesAfterScroll := sdm.cdServices.AfterScroll;
    Save_cdSrvPagesNewRecord := sdm.cdSrvPages.OnNewRecord;
    Save_cdOrderKindAfterScroll := sdm.cdOrderKind.AfterScroll;
    Save_cdKindProcessNewRecord := sdm.cdKindProcess.OnNewRecord;

    if AccessManager.CurUser.EditUsers then
    begin
      Save_cdAccessProcAfterScroll := adm.cdAccessProc.AfterScroll;
      Save_cdAccessProcBeforeScroll := adm.cdAccessProc.BeforeScroll;
      Save_cdAccessUserAfterScroll := adm.cdAccessUser.AfterScroll;
      Save_cdAccessUserBeforeScroll := adm.cdAccessUser.BeforeScroll;
    end;

    sdm.cdSrvGrps.AfterScroll := cdSrvGrpsAfterScroll;
    cdSrvGrpsAfterScroll(sdm.cdSrvGrps);
    sdm.cdSrvPages.AfterScroll := cdSrvPagesAfterScroll;
    cdSrvPagesAfterScroll(sdm.cdSrvPages);
    //sdm.cdProcessGrids.AfterScroll := cdGridsAfterScroll;
    //cdGridsAfterScroll(sdm.cdProcessGrids);
    //sdm.cdServices.AfterScroll := cdServicesAfterScroll;
    //cdServicesAfterScroll(sdm.cdServices);
    sdm.cdSrvPages.OnNewRecord := cdSrvPagesNewRecord;
    sdm.cdOrderKind.AfterScroll := cdOrderKindAfterScroll;
    cdOrderKindAfterScroll(sdm.cdOrderKind);
    sdm.cdKindProcess.OnNewRecord := cdKindProcessNewRecord;

    if AccessManager.CurUser.EditUsers then
    begin
      adm.RefreshUsers;
      adm.cdAccessProc.AfterScroll := cdAccessProcAfterScroll;
      adm.cdAccessProc.BeforeScroll := cdAccessProcBeforeScroll;
      adm.cdAccessUser.AfterScroll := cdAccessUserAfterScroll;
      adm.cdAccessUser.BeforeScroll := cdAccessUserBeforeScroll;
      cdAccessUserAfterScroll(adm.cdAccessUser);
    end;

    HandlersAssigned := true;

  end;
  pcConfChange(nil);
  CfgActivated := true;
end;

procedure TDicEditForm.sbNewKindClick(Sender: TObject);
begin
  sdm.cdOrderKind.Append;
end;

procedure TDicEditForm.sbDelKindClick(Sender: TObject);
begin
  if sdm.cdOrderKind.Active and not sdm.cdOrderKind.IsEmpty
    and (RusMessageDlg('Вы действительно желаете удалить вид заказа ''' +
    sdm.cdOrderKind['KindDesc'] + '''?'#13,
    mtConfirmation, mbYesNoCancel, 0) = mrYes) then
      sdm.cdOrderKind.Delete;
end;

procedure TDicEditForm.sbAddKindProcessClick(Sender: TObject);
begin
  FillAddProcessMenu;
  pmSrv.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TDicEditForm.pmAddKindProcessClick(Sender: TObject);
var
  mi: TMenuItem;
begin
  mi := Sender as TMenuItem;
  if mi.Tag > 0 then begin
    sdm.cdKindProcess.Append;
    sdm.cdKindProcess['ProcessID'] := mi.Tag;
    sdm.cdKindProcess.Post;
  end;
end;

procedure TDicEditForm.FillAddProcessMenu;
var
  cdTmpSrv: TClientDataSet;
  mi: TMenuItem;
begin
  pmSrv.Items.Clear;
  cdTmpSrv := TClientDataSet.Create(Self);
  try
    cdTmpSrv.CloneCursor(TConfigManager.Instance.ProcessCfgData.DataSet as TClientDataSet, true);
    cdTmpSrv.First;
    while not cdTmpSrv.Eof do
    try
      if NvlBoolean(cdTmpSrv['SrvActive']) and
         VarIsNull(sdm.cdKindProcess.Lookup('ProcessID', cdTmpSrv[F_SrvID], 'ProcessID')) then
      begin
        mi := TMenuItem.Create(Self);
        mi.Caption := cdTmpSrv['SrvDesc'];
        mi.Tag := cdTmpSrv[F_SrvID];
        mi.OnClick := pmAddKindProcessClick;
        pmSrv.Items.Add(mi);
      end;
    finally
      cdTmpSrv.Next;
    end;
  finally
    cdTmpSrv.Free;
  end;
end;

procedure TDicEditForm.cdOrderKindAfterScroll(Dataset: TDataSet);
begin
  if pcConf.ActivePage = tsOrdKind then
  try
    if not DataSet.IsEmpty and not VarIsNull(DataSet['KindID']) then
     sdm.SetCurKind(DataSet['KindID'])
    else
      sdm.SetCurKind(0);
  except
    sdm.SetCurKind(0);
  end;
end;

procedure TDicEditForm.cdKindProcessNewRecord(Dataset: TDataSet);
begin
  if Assigned(Save_cdKindProcessNewRecord) then Save_cdKindProcessNewRecord(DataSet);
  if sdm.cdOrderKind.Active then DataSet['KindID'] := sdm.cdOrderKind['KindID']
  else Abort;
end;

procedure TDicEditForm.sbDeleteKindProcessClick(Sender: TObject);
begin
  if not sdm.cdKindProcess.IsEmpty then sdm.cdKindProcess.Delete;
end;

procedure TDicEditForm.sbAddAllKindProcessClick(Sender: TObject);
var
  cdTmpSrv: TClientDataSet;
begin
  cdTmpSrv := TClientDataSet.Create(Self);
  try
    cdTmpSrv.CloneCursor(sdm.cdServices, true);
    cdTmpSrv.First;
    while not cdTmpSrv.Eof do
    try
      if VarIsNull(sdm.cdKindProcess.Lookup('ProcessID', cdTmpSrv[F_SrvID], 'ProcessID')) then begin
        sdm.cdKindProcess.Append;
        sdm.cdKindProcess['ProcessID'] := cdTmpSrv[F_SrvID];
      end;
    finally
      cdTmpSrv.Next;
    end;
  finally
    cdTmpSrv.Free;
  end;
  sdm.cdKindProcess.CheckBrowseMode;
end;

procedure TDicEditForm.EnableUserControls;
begin
  {boxUserAccess.Enabled := true;
  cbOrderKind.Enabled := true;
  rbDraftAccess.Enabled := true;
  rbWorkAccess.Enabled := true;
  pcKindAccess.Enabled := true;}
  paKindAccess.Visible := true;
end;

procedure TDicEditForm.DisableUserControls;
begin
  {boxUserAccess.Enabled := true;
  cbOrderKind.Enabled := true;
  rbDraftAccess.Enabled := true;
  rbWorkAccess.Enabled := true;
  pcKindAccess.Enabled := true;}
  paKindAccess.Visible := false;
  CurUserID := 0;
end;

procedure TDicEditForm.ControlsToUserData;
var
  URec: TUserPermissionInfo;
begin
  ControlsToUserKindData;
  URec.ID := CurUserID;
  URec.EditUsers := boxUserAccess.Checked[0];
  URec.EditDics := boxUserAccess.Checked[1];
  URec.EditProcCfg := boxUserAccess.Checked[2];
  URec.EditModules := boxUserAccess.Checked[3];
  URec.UploadFiles := boxUserAccess.Checked[4];
  URec.SetCourse := boxUserAccess.Checked[5];
  URec.DraftViewOwnOnly := boxUserAccess.Checked[6];
  URec.WorkViewOwnOnly := boxUserAccess.Checked[7];
  URec.PermitPlanView := boxUserAccess.Checked[8];
  URec.AddCustomer := boxUserAccess.Checked[9];
  URec.DeleteOwnCustomer := boxUserAccess.Checked[10];
  URec.EditOtherCustomer := boxUserAccess.Checked[11];
  URec.ViewOtherCustomer := boxUserAccess.Checked[12];
  URec.ChangeCustomerOwner := boxUserAccess.Checked[13];
  URec.DataPaging := boxUserAccess.Checked[14];
  URec.ViewReports := boxUserAccess.Checked[15];
  URec.EditCustomReports := boxUserAccess.Checked[16];
  URec.DeleteCustomReports := boxUserAccess.Checked[17];
  URec.ViewPayments := boxUserAccess.Checked[18];
  URec.AddPayments := boxUserAccess.Checked[19];
  URec.EditPayments := boxUserAccess.Checked[20];
  URec.ViewInvoices := boxUserAccess.Checked[21];
  URec.AddInvoices := boxUserAccess.Checked[22];
  URec.DeleteInvoices := boxUserAccess.Checked[23];
  URec.DescribeUnScheduleJob := boxUserAccess.Checked[24];
  URec.ViewNotPlanned := boxUserAccess.Checked[25];
  URec.ViewProduction := boxUserAccess.Checked[26];
  URec.ShowDelayedOrders := boxUserAccess.Checked[27];
  URec.ViewShipment := boxUserAccess.Checked[28];
  URec.AddShipment := boxUserAccess.Checked[29];
  URec.DeleteShipment := boxUserAccess.Checked[30];
  URec.ApproveShipment := boxUserAccess.Checked[31];
  URec.ApproveOrderMaterials := boxUserAccess.Checked[32];
  URec.ViewMatRequests := boxUserAccess.Checked[33];
  URec.UpdateMatPayDate := boxUserAccess.Checked[34];
  URec.SetPaymentStatus := boxUserAccess.Checked[35];
  AccessManager.WriteUserPermFrom(URec);
end;

function TDicEditForm.UserDataToControls: boolean;
var
  urec: TUserPermissionInfo;
begin
  if AccessManager.ReadUserIDPermTo(URec, adm.cdAccessUser['AccessUserID']) then
  begin
    boxUserAccess.Checked[0] := URec.EditUsers;
    boxUserAccess.Checked[1] := URec.EditDics;
    boxUserAccess.Checked[2] := URec.EditProcCfg;
    boxUserAccess.Checked[3] := URec.EditModules;
    boxUserAccess.Checked[4] := URec.UploadFiles;
    boxUserAccess.Checked[5] := URec.SetCourse;
    boxUserAccess.Checked[6] := URec.DraftViewOwnOnly;
    boxUserAccess.Checked[7] := URec.WorkViewOwnOnly;
    boxUserAccess.Checked[8] := URec.PermitPlanView;
    boxUserAccess.Checked[9] := URec.AddCustomer;
    boxUserAccess.Checked[10] := URec.DeleteOwnCustomer;
    boxUserAccess.Checked[11] := URec.EditOtherCustomer;
    boxUserAccess.Checked[12] := URec.ViewOtherCustomer;
    boxUserAccess.Checked[13] := URec.ChangeCustomerOwner;
    boxUserAccess.Checked[14] := URec.DataPaging;
    boxUserAccess.Checked[15] := URec.ViewReports;
    boxUserAccess.Checked[16] := URec.EditCustomReports;
    boxUserAccess.Checked[17] := URec.DeleteCustomReports;
    boxUserAccess.Checked[18] := URec.ViewPayments;
    boxUserAccess.Checked[19] := URec.AddPayments;
    boxUserAccess.Checked[20] := URec.EditPayments;
    boxUserAccess.Checked[21] := URec.ViewInvoices;
    boxUserAccess.Checked[22] := URec.AddInvoices;
    boxUserAccess.Checked[23] := URec.DeleteInvoices;
    boxUserAccess.Checked[24] := URec.DescribeUnScheduleJob;
    boxUserAccess.Checked[25] := URec.ViewNotPlanned;
    boxUserAccess.Checked[26] := URec.ViewProduction;
    boxUserAccess.Checked[27] := URec.ShowDelayedOrders;
    boxUserAccess.Checked[28] := URec.ViewShipment;
    boxUserAccess.Checked[29] := URec.AddShipment;
    boxUserAccess.Checked[30] := URec.DeleteShipment;
    boxUserAccess.Checked[31] := URec.ApproveShipment;
    boxUserAccess.Checked[32] := URec.ApproveOrderMaterials;
    boxUserAccess.Checked[33] := URec.ViewMatRequests;
    boxUserAccess.Checked[34] := URec.UpdateMatPayDate;
    boxUserAccess.Checked[35] := URec.SetPaymentStatus;

    if (cbOrderKind.KeyValue = 0) and not sdm.cdOrderKind.IsEmpty then
      cbOrderKind.KeyValue := sdm.cdOrderKind['KindID']
    else
      cbOrderKindChange(nil);
    CurUserID := adm.cdAccessUser['AccessUserID'];
    Result := true;
  end
  else
    Result := false;
end;

procedure TDicEditForm.cdAccessUserAfterScroll(Dataset: TDataSet);
begin
  if pcConf.ActivePage = tsUser then
  try
    if not DataSet.IsEmpty and not VarIsNull(DataSet['AccessUserID']) and not ApplyingUsers then
    begin
      //adm.SetCurUser(DataSet['AccessUserID']);
      if UserDataToControls then
        EnableUserControls;
    end else begin
      //adm.SetCurUser(0);
      DisableUserControls;
    end;
  except
    //adm.SetCurUser(0);
    DisableUserControls;
  end;
end;

procedure TDicEditForm.cdAccessUserBeforeScroll(Dataset: TDataSet);
begin
  if (pcConf.ActivePage = tsUser) and not ApplyingUsers then
    if paKindAccess.Visible and not DataSet.IsEmpty and (CurUserID > 0) then
      ControlsToUserData;
end;

procedure TDicEditForm.cbOrderKindChange(Sender: TObject);
begin
  ControlsToUserKindData;
  CurUserID := adm.cdAccessUser['AccessUserID'];
  CurKindAccessID := cbOrderKind.KeyValue;
  CurKindDraft := rbDraftAccess.Checked;
  UserKindDataToControls;
end;

procedure TDicEditForm.UserKindDataToControls;
begin
  if not VarIsNull(cbOrderKind.KeyValue) and (CurKindAccessID > 0)
     and (CurUserID > 0)
     and AccessManager.ReadUserKindPermTo(KRec, CurKindAccessID, CurUserID) then
  begin
    if CurKindDraft then
    begin
      boxKindAccess.Checked[0] := Krec.DraftCreate;
      boxKindAccess.Checked[1] := Krec.DraftUpdateOwn;
      boxKindAccess.Checked[2] := Krec.DraftUpdateOther;
      boxKindAccess.Checked[3] := Krec.DraftDeleteOwn;
      boxKindAccess.Checked[4] := Krec.DraftDeleteOther;
      boxKindAccess.Checked[5] := Krec.DraftVisible;
      boxKindAccess.Checked[6] := Krec.DraftBrowse;
      boxKindAccess.Checked[8] := Krec.DraftPriceView;
      boxKindAccess.Checked[9] := Krec.DraftCostView;
      boxKindAccess.Checked[10] := Krec.MakeWork;
      boxKindAccess.EnabledItem[10] := true;
      boxKindAccess.Checked[11] := false;
      boxKindAccess.EnabledItem[11] := false;
      boxKindAccess.Checked[12] := false;
      boxKindAccess.EnabledItem[12] := false;
      boxKindAccess.Checked[13] := false;
      boxKindAccess.EnabledItem[13] := false;
      boxKindAccess.Checked[14] := false;
      boxKindAccess.EnabledItem[14] := false;
      boxKindAccess.Checked[15] := false;
      boxKindAccess.EnabledItem[15] := false;
    end
    else
    begin
      boxKindAccess.Checked[0] := Krec.WorkCreate;
      boxKindAccess.Checked[1] := Krec.WorkUpdateOwn;
      boxKindAccess.Checked[2] := Krec.WorkUpdateOther;
      boxKindAccess.Checked[3] := Krec.WorkDeleteOwn;
      boxKindAccess.Checked[4] := Krec.WorkDeleteOther;
      boxKindAccess.Checked[5] := Krec.WorkVisible;
      boxKindAccess.Checked[6] := Krec.WorkBrowse;
      boxKindAccess.Checked[8] := Krec.WorkPriceView;
      boxKindAccess.Checked[9] := Krec.WorkCostView;
      boxKindAccess.Checked[10] := false;
      boxKindAccess.EnabledItem[10] := false;
      boxKindAccess.Checked[11] := Krec.MakeDraft;
      boxKindAccess.EnabledItem[11] := true;
      boxKindAccess.Checked[12] := Krec.PlanStartDate;
      boxKindAccess.EnabledItem[12] := true;
      boxKindAccess.Checked[13] := Krec.PlanFinishDate;
      boxKindAccess.EnabledItem[13] := true;
      boxKindAccess.Checked[14] := Krec.FactStartDate;
      boxKindAccess.EnabledItem[14] := true;
      boxKindAccess.Checked[15] := Krec.FactFinishDate;
      boxKindAccess.EnabledItem[15] := true;
    end;
    boxKindAccess.Checked[7] := Krec.CheckOnSave;
    boxKindAccess.Checked[16] := Krec.ShowProfitPreview;
    boxKindAccess.Checked[17] := Krec.ShowProfitInside;
    boxKindAccess.Checked[18] := Krec.ModifyProfit;
    boxKindAccess.Checked[19] := Krec.ViewOnlyProtected;
    boxKindAccess.Checked[20] := Krec.CostProtection;
    boxKindAccess.Checked[21] := Krec.ContentProtection;
    boxKindAccess.Checked[22] := Krec.ChangeOrderOwner;
    boxKindAccess.Checked[23] := Krec.UpdatePayConditions;
    boxKindAccess.Checked[24] := Krec.CancelMaterialRequest;
    boxKindAccess.Checked[25] := Krec.EditMaterialRequest;
    boxKindAccess.Checked[26] := Krec.FactCostView;
    DisableProcSetData := true;
    adm.SetCurUserKind(CurUserID, CurKindAccessID);
    DisableProcSetData := false;
  end;
end;

procedure TDicEditForm.ControlsToUserKindData;
begin
  if (CurKindAccessID > 0) and (CurUserID > 0) then
  begin
    ControlsToUserKindProcData;
    if CurKindDraft then
    begin
      Krec.DraftCreate := boxKindAccess.Checked[0];
      Krec.DraftUpdateOwn := boxKindAccess.Checked[1];
      Krec.DraftUpdateOther := boxKindAccess.Checked[2];
      Krec.DraftDeleteOwn := boxKindAccess.Checked[3];
      Krec.DraftDeleteOther := boxKindAccess.Checked[4];
      Krec.DraftVisible := boxKindAccess.Checked[5];
      Krec.DraftBrowse := boxKindAccess.Checked[6];
      Krec.DraftPriceView := boxKindAccess.Checked[8];
      Krec.DraftCostView := boxKindAccess.Checked[9];
      Krec.MakeWork := boxKindAccess.Checked[10];
    end
    else
    begin
      Krec.WorkCreate := boxKindAccess.Checked[0];
      Krec.WorkUpdateOwn := boxKindAccess.Checked[1];
      Krec.WorkUpdateOther := boxKindAccess.Checked[2];
      Krec.WorkDeleteOwn := boxKindAccess.Checked[3];
      Krec.WorkDeleteOther := boxKindAccess.Checked[4];
      Krec.WorkVisible := boxKindAccess.Checked[5];
      Krec.WorkBrowse := boxKindAccess.Checked[6];
      Krec.WorkPriceView := boxKindAccess.Checked[8];
      Krec.WorkCostView := boxKindAccess.Checked[9];
      Krec.MakeDraft := boxKindAccess.Checked[11];
      Krec.PlanStartDate := boxKindAccess.Checked[12];
      Krec.PlanFinishDate := boxKindAccess.Checked[13];
      Krec.FactStartDate := boxKindAccess.Checked[14];
      Krec.FactFinishDate := boxKindAccess.Checked[15];
    end;
    Krec.CheckOnSave := boxKindAccess.Checked[7];
    Krec.ShowProfitPreview := boxKindAccess.Checked[16];
    Krec.ShowProfitInside := boxKindAccess.Checked[17];
    Krec.ModifyProfit := boxKindAccess.Checked[18];
    Krec.ViewOnlyProtected := boxKindAccess.Checked[19];
    Krec.CostProtection := boxKindAccess.Checked[20];
    Krec.ContentProtection := boxKindAccess.Checked[21];
    Krec.ChangeOrderOwner := boxKindAccess.Checked[22];
    Krec.UpdatePayConditions := boxKindAccess.Checked[23];
    Krec.CancelMaterialRequest := boxKindAccess.Checked[24];
    Krec.EditMaterialRequest := boxKindAccess.Checked[25];
    Krec.FactCostView := boxKindAccess.Checked[26];
    AccessManager.WriteUserKindPermFrom(KRec);
  end;
end;

procedure TDicEditForm.CheckAllBox(box: TjvxCheckListBox; Val: boolean);
var
  i: integer;
begin
  for i := 0 to Pred(box.Items.Count) do
    if box.EnabledItem[i] then box.Checked[i] := Val;
end;

procedure TDicEditForm.sbCheckAllUserClick(Sender: TObject);
begin
  CheckAllBox(boxUserAccess, true);
end;

procedure TDicEditForm.sbUnCheckAllUserClick(Sender: TObject);
begin
  CheckAllBox(boxUserAccess, false);
end;

procedure TDicEditForm.sbCheckAllKindClick(Sender: TObject);
begin
  CheckAllBox(boxKindAccess, true);
end;

procedure TDicEditForm.sbUncheckAllKindClick(Sender: TObject);
begin
  CheckAllBox(boxKindAccess, false);
end;

procedure TDicEditForm.sbCheckAllKindProcessClick(Sender: TObject);
begin
  CheckAllProcMode := true;
  pmCheckAllProc.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TDicEditForm.sbUncheckAllKindProcessClick(Sender: TObject);
begin
  CheckAllProcMode := false;
  pmCheckAllProc.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
  //CheckAllBox(boxProcAccess, false);
end;

procedure TDicEditForm.miCheckAllProcCurClick(Sender: TObject);
begin
  CheckAllBox(boxProcAccess, CheckAllProcMode);
end;

procedure TDicEditForm.miCheckAllProcCurProcAllKindClick(Sender: TObject);
var
  k, pk: integer;
begin
  if not sdm.cdOrderKind.IsEmpty then
  begin
    k := sdm.cdOrderKind['KindID'];
    pk := adm.cdAccessProc['ProcessID'];
    rbDraftAccess.Checked := true;
    sdm.cdOrderKind.First;
    while not sdm.cdOrderKind.eof do
    try
      cbOrderKind.KeyValue := sdm.cdOrderKind['KindID'];
      adm.cdAccessProc.Locate('ProcessID', pk, []);
      CheckAllBox(boxProcAccess, CheckAllProcMode);
      rbWorkAccess.Checked := true;
      CheckAllBox(boxProcAccess, CheckAllProcMode);
      rbDraftAccess.Checked := true;
    finally
      sdm.cdOrderKind.Next;
    end;
    sdm.cdOrderKind.Locate('KindID', k, []);
  end;
end;

procedure TDicEditForm.cdAccessProcBeforeScroll(Dataset: TDataSet);
begin
  if not ApplyingUsers and not DisableProcSetData then
  begin
    DisableProcSetData := true;
    try
      ControlsToUserKindProcData;
    finally
      DisableProcSetData := false;
    end;
  end;
end;

procedure TDicEditForm.cdAccessProcAfterScroll(Dataset: TDataSet);
begin
  if not ApplyingUsers then
  begin
    try
      CurProcessID := adm.cdAccessProc['ProcessID'];
      UserKindProcDataToControls;
    except CurProcessID := 0 end;
  end;
end;

procedure TDicEditForm.UserKindProcDataToControls;
begin
  if not VarIsNull(cbOrderKind.KeyValue) and (CurKindAccessID > 0) and (CurProcessID > 0)
     and (CurUserID > 0)
     and AccessManager.ReadUserKindProcPermTo(KPRec, CurKindAccessID, CurUserID, CurProcessID) then
  begin
    if CurKindDraft then
    begin
      boxProcAccess.Checked[0] := KPRec.DraftView;
      boxProcAccess.Checked[1] := KPRec.DraftInsert;
      boxProcAccess.Checked[2] := KPRec.DraftUpdate;
      boxProcAccess.Checked[3] := KPRec.DraftDelete;
      boxProcAccess.EnabledItem[4] := false;
      boxProcAccess.Checked[4] := false;
      boxProcAccess.EnabledItem[5] := false;
      boxProcAccess.Checked[5] := false;
    end else begin
      boxProcAccess.Checked[0] := KPRec.WorkView;
      boxProcAccess.Checked[1] := KPRec.WorkInsert;
      boxProcAccess.Checked[2] := KPRec.WorkUpdate;
      boxProcAccess.Checked[3] := KPRec.WorkDelete;
      boxProcAccess.Checked[4] := KPRec.PlanDate;
      boxProcAccess.EnabledItem[4] := true;
      boxProcAccess.Checked[5] := KPRec.FactDate;
      boxProcAccess.EnabledItem[5] := true;
    end;
  end;
end;

procedure TDicEditForm.ControlsToUserKindProcData;
begin
  if (CurKindAccessID > 0) and (CurProcessID > 0) then
  begin
    if CurKindDraft then
    begin
      KPRec.DraftView := boxProcAccess.Checked[0];
      KPRec.DraftInsert := boxProcAccess.Checked[1];
      KPRec.DraftUpdate := boxProcAccess.Checked[2];
      KPRec.DraftDelete := boxProcAccess.Checked[3];
    end
    else
    begin
      KPRec.WorkView := boxProcAccess.Checked[0];
      KPRec.WorkInsert := boxProcAccess.Checked[1];
      KPRec.WorkUpdate := boxProcAccess.Checked[2];
      KPRec.WorkDelete := boxProcAccess.Checked[3];
      KPRec.PlanDate := boxProcAccess.Checked[4];
      KPRec.FactDate := boxProcAccess.Checked[5];
    end;
    AccessManager.WriteUserKindProcPermFrom(KPRec);
  end;
end;

procedure TDicEditForm.sbAddUserClick(Sender: TObject);
begin
  ApplyUsers;
  AccessManager.AddUser;
  ApplyUsers;
  adm.cdAccessUser.Locate('Login', adm.DefaultUserLogin, []);
end;

procedure TDicEditForm.ApplyUsers;
begin
  AllControlsToUserData;
  ApplyingUsers := true;
  AccessManager.ApplyUsers(true);
  ApplyingUsers := false;
  cdAccessUserAfterScroll(adm.cdAccessUser);
end;

procedure TDicEditForm.RefreshUsers;
begin
  ApplyingUsers := true;
  adm.RefreshUsers;
  ApplyingUsers := false;
  cdAccessUserAfterScroll(adm.cdAccessUser);
end;

procedure TDicEditForm.AllControlsToUserData;
begin
  //ControlsToUserKindProcData;
  //ControlsToUserKindData;
  ControlsToUserData;
end;

// Все процессы в текущем виде. И черновики и в работе
procedure TDicEditForm.miCheckAllProcAllProcCurKindClick(Sender: TObject);
var
  pk, ppk: integer;
  CurIsDraft: boolean;
begin
  if not adm.cdAccessProc.IsEmpty then
  begin
    CurIsDraft := rbDraftAccess.Checked;
    rbDraftAccess.Checked := true;
    ppk := adm.cdAccessProc['ProcessID'];
    adm.cdAccessProc.First;
    while not adm.cdAccessProc.eof do
    begin
      pk := adm.cdAccessProc['ProcessID'];
      CheckAllBox(boxProcAccess, CheckAllProcMode);

      rbWorkAccess.Checked := true;
      adm.cdAccessProc.Locate('ProcessID', pk, []);
      CheckAllBox(boxProcAccess, CheckAllProcMode);

      rbDraftAccess.Checked := true;
      adm.cdAccessProc.Locate('ProcessID', pk, []);

      if not adm.cdAccessProc.eof then adm.cdAccessProc.Next;
    end;
    adm.cdAccessProc.Locate('ProcessID', ppk, []);
    rbDraftAccess.Checked := CurIsDraft;
  end;
end;

// Все процессы во всех видах. И черновики и в работе
procedure TDicEditForm.miCheckAllProcAllProcAllKindClick(Sender: TObject);
var
  k, pk: integer;
begin
  if not sdm.cdOrderKind.IsEmpty then
  begin
    k := sdm.cdOrderKind['KindID'];
    pk := adm.cdAccessProc['ProcessID'];
    rbDraftAccess.Checked := true;
    sdm.cdOrderKind.First;
    while not sdm.cdOrderKind.eof do
    begin
      cbOrderKind.KeyValue := sdm.cdOrderKind['KindID'];
      miCheckAllProcAllProcCurKindClick(nil);
      sdm.cdOrderKind.Next;
    end;
    sdm.cdOrderKind.Locate('KindID', k, []);
    adm.cdAccessProc.Locate('ProcessID', pk, []);
  end;
end;

procedure TDicEditForm.sbCopyUserClick(Sender: TObject);
var NewUserID: integer;
begin
  ApplyUsers;
  if not adm.cdAccessUser.IsEmpty then
  begin
    NewUserID := adm.CopyUser(adm.cdAccessUser['AccessUserID']);
    if NewUserID > 0 then
    begin
      RefreshUsers;
      adm.cdAccessUser.Locate('AccessUserID', NewUserID, []);
    end;
  end;
end;

procedure TDicEditForm.sbDelUserClick(Sender: TObject);
begin
  if not adm.cdAccessUser.IsEmpty then
  begin
    if RusMessageDlg('Вы действительно желаете удалить пользователя "' +
      adm.cdAccessUser['Name'] + '"?', mtConfirmation, mbYesNoCancel, 0) = mrYes then
    begin
      adm.cdAccessUser.Delete;
      ApplyUsers;
    end;
  end;
end;

procedure TDicEditForm.dgUsersGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  if not (gdSelected in State) then begin
    if NvlBoolean(Column.Field.DataSet['IsRole']) then
      Background := clInfoBk;
  end;
end;
{
procedure TDicEditForm.miExportProcessClick(Sender: TObject);
var Process: TPolyProcessCfg;
begin
  if not sdm.cdServices.IsEmpty then
  begin
    Process := TConfigManager.Instance.ServiceByID(sdm.cdServices[F_SrvID]);
    ScriptExchange.ExportScriptsToFiles(Process);
  end;
end;
}
{
procedure TDicEditForm.DicElemsTreeViewInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
var
  isFolder, index: integer;
  nodeData: PNodeData;
  recordId, dicName: string;
begin
  nodeData := TDBVirtualStringTree(Sender).GetNodeData(Node);
  recordId := IntToStr(nodeData.RecordId);
  isFolder := Folder(Node);

  if ((isFolder<>-1) and (isFolder = 1)) then
  begin
     index := ExpandedNodes.IndexOf(recordId);

     if (index <> -1) then
     begin
       ExpandedNodes.Delete(index);
       InitialStates := [ivsExpanded];
     end;
  end;

  if selectedDicId <> -1 then
  begin
    dicName := nodeData.FieldValues[DictionaryNameIndex];
    if (nodeData.RecordId = selectedDicId) and (dicName = selectedDicName) then
    begin
      TDBVirtualStringTree(Sender).Selected[Node] := true;
      TDBVirtualStringTree(Sender).FocusedNode := Node;

      selectedDicId := -1;
      selectedDicName := '';
    end;
  end;
end;
}
end.
