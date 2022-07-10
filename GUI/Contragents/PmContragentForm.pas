unit PmContragentForm;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Mask, ExtCtrls, Buttons,
  PmContragent, ComCtrls, JvExComCtrls, JvDateTimePicker,
  JvJCLUtils, JvDBDateTimePicker, JvExMask, JvToolEdit, OutlookTools,
  XPMenu, DBGridEh, JvComponent, JvFormPlacement, MyDBGridEh, DBClient,
  JvExStdCtrls, JvDBCombobox, JvComponentBase, GridsEh, JvEdit, JvValidateEdit,
  JvExControls, JvDBLookup, DBCtrlsEh, DBLookupEh, DBGridEhGrouping, JvCombobox;

type
  TContragentForm = class(TForm)
    btOk: TBitBtn;
    btCancel: TBitBtn;
    pcProps: TPageControl;
    tsCommon: TTabSheet;
    tsFinance: TTabSheet;
    tsOther: TTabSheet;
    lbBank: TLabel;
    edBank: TDBEdit;
    lbIndCode: TLabel;
    edIndCode: TDBEdit;
    edNDSCode: TDBEdit;
    lbNDSCode: TLabel;
    lbName: TLabel;
    edName: TDBEdit;
    Label2: TLabel;
    edPhone: TDBEdit;
    lbAddr: TLabel;
    edAddress: TDBEdit;
    paInfoSource: TPanel;
    lbOther: TLabel;
    lbSource: TLabel;
    edOther: TDBEdit;
    lkSource: TDBLookupComboBox;
    lbUser: TLabel;
    lkUser: TDBLookupComboBox;
    Label5: TLabel;
    edEmail: TDBEdit;
    btSendMail: TBitBtn;
    dsPersons: TDataSource;
    Panel1: TPanel;
    btAdd: TBitBtn;
    btDelete: TBitBtn;
    FormStorage: TJvFormStorage;
    dgPersons: TMyDBGridEh;
    tsPerson: TTabSheet;
    tsContact: TTabSheet;
    dtFirmBirthday: TJvDateEdit;
    Label1: TLabel;
    btEdit: TBitBtn;
    lbFirmType: TLabel;
    edFirmType: TDBEdit;
    lbContrType: TLabel;
    lbFullName: TLabel;
    edFullName: TDBEdit;
    tsRelated: TTabSheet;
    Panel2: TPanel;
    btAddRelated: TBitBtn;
    btDeleteRelated: TBitBtn;
    btEditRelated: TBitBtn;
    dgRelated: TMyDBGridEh;
    Label3: TLabel;
    memoNotes: TDBMemo;
    dsRelated: TDataSource;
    Label4: TLabel;
    edOKPO: TDBEdit;
    tsAddress: TTabSheet;
    Panel3: TPanel;
    btAddAddress: TBitBtn;
    btDeleteAddress: TBitBtn;
    btEditAddress: TBitBtn;
    dgAddr: TMyDBGridEh;
    dsAddrs: TDataSource;
    Label7: TLabel;
    edPhone2: TDBEdit;
    Label8: TLabel;
    edLegalAddress: TDBEdit;
    Label9: TLabel;
    edExternalName: TDBEdit;
    Panel4: TPanel;
    gbPayCond: TGroupBox;
    Label10: TLabel;
    lbPrePay: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edPrePayPercent: TDBEdit;
    edPreShipPercent: TDBEdit;
    edPayDelay: TDBEdit;
    Label13: TLabel;
    dsStatus: TDataSource;
    cbCheckPayConditions: TDBCheckBox;
    cbActivity: TDBLookupComboboxEh;
    dsActivity: TDataSource;
    Label14: TLabel;
    cbStatus: TDBLookupComboboxEh;
    cbPersonType: TDBComboBoxEh;
    cbSyncWeb: TDBCheckBox;
    Label16: TLabel;
    edFullName2: TDBEdit;
    cbIsPayDelayInBankDays: TDBCheckBox;
    DBCheckBox1: TDBCheckBox;
    cbIsDead: TDBCheckBox;
    cbMultiActivity: TJvCheckedComboBox;
    cbAlert: TDBCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btSendMailClick(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure dgPersonsColumnsBirthdayUpdateData(Sender: TObject;
      var Text: String; var Value: Variant; var UseText, Handled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btEditPersonClick(Sender: TObject);
    procedure cbPersonTypeChange(Sender: TObject);
    procedure cbAlertChange(Field: TField);
    procedure btAddRelatedClick(Sender: TObject);
    procedure btDeleteRelatedClick(Sender: TObject);
    procedure btAddAddressClick(Sender: TObject);
    procedure btEditAddressClick(Sender: TObject);
    procedure btDeleteAddressClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cbActivityClick(Sender: TObject);
    procedure cbStatusClick(Sender: TObject);
    procedure cbPersonTypeClick(Sender: TObject);
    procedure cbStatusCloseUp(Sender: TObject; Accept: Boolean);
    procedure cbMultiActivityChange(Sender: TObject);
    procedure btEditRelatedClick(Sender: TObject);
  private
    FAllowUserChange: Boolean;
    FSetActivities: Boolean;
    FDataSource, FInfoSource, FUserSource: TDataSource;
    FcdInfo, FcdUser: TDataSet;
    FContragents: TContragents;
    FReadOnly: boolean;
    OutlookConnect1: TOutlookConnect;
    FPersons: TPersons;
    FRelated: TRelated;
    FAddrs: TAddresses;
    function CheckNullDate(d: variant): TDateTime;
    function EditPerson: boolean;
    function EditAddress: boolean;
    //function EditRelatedContragent: boolean;
    function AddPerson: boolean;
    function AddRelatedContragent: boolean;
    function EditRelatedContragent: boolean;
    procedure DeleteRelatedContragent;
    function AddAddress: boolean;
    procedure DeletePerson;
    procedure DeleteAddress;
    procedure SetContragents(const Value: TContragents);
    procedure SetDataSource(ds: TDataSource);
    procedure SetInfoData(cd: TDataSet);
    procedure SetUserData(cd: TDataSet);
    procedure UpdateActivityFilter;
    procedure FillActivities;
    procedure SetActivities;
    function HasDicPermission(PermIndex: integer): boolean;
  public
    property AllowUserChange: Boolean read FAllowUserChange write FAllowUserChange;
    property Contragents: TContragents read FContragents write SetContragents;
    property DataSource: TDataSource read FDataSource write SetDataSource;

    // Набор данных с источниками информации
    property InfoData: TDataSet read FcdInfo write SetInfoData;

    // Набор данных со списком пользователей
    property UserData: TDataSet read FcdUser write SetUserData;

    property ReadOnly: boolean read FReadOnly write FReadOnly;
  end;

var
  ContragentForm: TContragentForm;

implementation

uses Variants, JvTypes, StdDic, PmAccessManager, RDialogs, Dialogs, RDBUtils,
  fPerson, PmRelatedContragentForm, fAddress, PmEntSettings, CalcUtils,
  PmConfigManager, DicObj;

{$R *.DFM}

const
  DicPermission_IsDead = 1;
  DicPermission_Related = 2;
  DicPermission_Addresses = 3;

procedure TContragentForm.SetDataSource(ds: TDataSource);
begin
  FDataSource := ds;
  edName.DataSource := ds;
  edFullName.DataSource := ds;
  edPhone.DataSource := ds;
  edPhone2.DataSource := ds;
  edAddress.DataSource := ds;
  edEmail.DataSource := ds;
  //edGertva.DataSource := ds;
  edIndCode.DataSource := ds;
  edNDSCode.DataSource := ds;
  edOKPO.DataSource := ds;
  //edDirector.DataSource := ds;
  edBank.DataSource := ds;
  edLegalAddress.DataSource := ds;
  edExternalName.DataSource := ds;
  lkSource.DataSource := ds;
  lkUser.DataSource := ds;
  edOther.DataSource := ds;
  cbPersonType.DataSource := ds;
  cbStatus.DataSource := ds;
  edFirmType.DataSource := ds;
  memoNotes.DataSource := ds;
  edPrePayPercent.DataSource := ds;
  edPreShipPercent.DataSource := ds;
  edPayDelay.DataSource := ds;
  cbIsPayDelayInBankDays.DataSource := ds;
  cbCheckPayConditions.DataSource := ds;
  cbActivity.DataSource := ds;
  edFullName2.DataSource := ds;
  cbAlert.DataSource := ds;
  cbIsDead.dataSource := ds;
  if ds <> nil then
  begin
    dtFirmBirthday.Date := CheckNullDate(Contragents.FirmBirthday);
    //dtDirectorBirthday.Date := CheckNullDate(ds.Dataset['DirectorBirthday']);
    //dtGertvaBirthday.Date := CheckNullDate(ds.Dataset['GertvaBirthday']);
  end;
  cbSyncWeb.DataSource := ds;
end;

// Установка набора данных об источнике информации
procedure TContragentForm.SetInfoData(cd: TDataSet);
begin
  FcdInfo := cd;
  if FcdInfo = nil then
  begin
    FreeAndNil(FInfoSource);
    lkSource.ListSource := nil;
    paInfoSource.Visible := false;
  end
  else
  begin
    if FInfoSource = nil then FInfoSource := TDataSource.Create(Self);
    FInfoSource.DataSet := FcdInfo;
    lkSource.ListSource := FInfoSource;
    paInfoSource.Visible := true;
  end;
end;

// Установка набора данных со списком пользователей
procedure TContragentForm.SetUserData(cd: TDataSet);
begin
  FcdUser := cd;
  if FcdUser = nil then
  begin
    FreeAndNil(FUserSource);
    lkUser.ListSource := nil;
  end else begin
    if FUserSource = nil then
      FUserSource := TDataSource.Create(Self);
    FUserSource.DataSet := FcdUser;
    lkUser.ListSource := FUserSource;
  end;
end;

procedure TContragentForm.FormActivate(Sender: TObject);
var
  //St: TDataSetState;
  LockSync: boolean;
  StatusData: TDataSet;
  s: string;
begin
  if DataSource <> nil then
  begin
    //St := DataSource.DataSet.State;
    {if St = dsInsert then Caption := LoadStr(S_NewCust)
    else Caption := LoadStr(S_EditCust);}
    if not EntSettings.AllContractors or (Contragents.ContragentType = caCustomer) then
      s := TConfigManager.Instance.StandardDics.deContragentType.ItemName[Contragents.ContragentType]
    else
      s := 'Контрагент';
    Caption := AnsiProperCase(s, [' ']);
    // Попробуем отображать в этом поле доп информацию для всех видов контрагентов
    //if Contragents.ContragentType <> caCustomer then
    //begin
      edFullName.DataField := TContragents.F_BriefNote;
      lbFullName.Caption := 'Дополнительная информация';
    //end;
    pcProps.ActivePage := tsCommon;
    if FReadOnly
       and not HasDicPermission(DicPermission_Related)
       and not HasDicPermission(DicPermission_Addresses) then
    begin
      btOk.Visible := false;
      btCancel.Caption := 'Закрыть';
      ActiveControl := btCancel;
    end
    else
    begin
      // проверяем состояние синхронизации и запрещено ли редактирование некоторых данных в этом состоянии
      // только при редактировании. при создании нового можно редактировать все данные.
      LockSync := not VarIsNull(Contragents.KeyValue)
        and EntSettings.LockSyncData
        and (Contragents.SyncState = SyncState_Syncronized);
      edFullName.ReadOnly := LockSync or FReadOnly;
      edOKPO.ReadOnly := LockSync or FReadOnly;
      edNDSCode.ReadOnly := LockSync or FReadOnly;
      edIndCode.ReadOnly := LockSync or FReadOnly;
      edBank.ReadOnly := LockSync or FReadOnly;
      edAddress.ReadOnly := LockSync or FReadOnly;
      edLegalAddress.ReadOnly := LockSync or FReadOnly;
      edExternalName.ReadOnly := LockSync or FReadOnly;

      btOk.Visible := true;
      btCancel.Caption := 'Отмена';
      lkUser.ReadOnly := not AllowUserChange or FReadOnly;
      ActiveControl := edName;
    end;

    edName.ReadOnly := FReadOnly;
    cbPersonType.ReadOnly := FReadOnly;
    cbStatus.ReadOnly := FReadOnly;
    edPhone.ReadOnly := FReadOnly;
    edPhone2.ReadOnly := FReadOnly;
    cbMultiActivity.ReadOnly := FReadOnly;
    edEmail.ReadOnly := FReadOnly;
    lkSource.ReadOnly := FReadOnly;
    edOther.ReadOnly := FReadOnly;
    
    if EntSettings.AllContractors and (Contragents.ContragentType <> caCustomer) then
    begin
      // В режиме объединения вместо категории отображаем вид контрагента
      StatusData := TConfigManager.Instance.StandardDics.deContragentType.DicItems;
      StatusData.Filter := '(Code<>' + IntToStr(Customers.ContragentType) + ') and Visible';
      //cbStatus.DataField := TContragents.F_ContragentType;
    end
    else
    begin
      // Категория контрагента - включаем фильтр по виду контрагента
      StatusData := TConfigManager.Instance.StandardDics.deContragentStatus.DicItems;
      StatusData.Filter := '(A1=' + IntToStr(Contragents.ContragentType) + ') and Visible';
      //cbStatus.DataField := TContragents.F_StatusCode;
    end;
    StatusData.Filtered := true;
    dsStatus.DataSet := StatusData;

    // Вид деятельности контрагента - включаем фильтр по виду контрагента
    UpdateActivityFilter;
    FillActivities;
    SetActivities;

    // обновляем вид
    cbPersonTypeChange(Sender);
    cbAlertChange(FContragents.DataSet.FieldByName(TContragents.F_Alert));

    cbIsDead.Enabled := HasDicPermission(DicPermission_IsDead);
    tsRelated.TabVisible := HasDicPermission(DicPermission_Related);
    tsAddress.TabVisible := HasDicPermission(DicPermission_Addresses);
  end;
end;

function TContragentForm.HasDicPermission(PermIndex: integer): boolean;
var
  dicPerm: TDictionary;
  permCode: integer;
begin
  dicPerm := TConfigManager.Instance.StandardDics.deContragentAttrPerm;
  permCode := dicPerm.ItemCode[AccessManager.CurUser.Login];
  if permCode > 0 then
    Result := NvlBoolean(dicPerm.ItemValue[permCode, PermIndex])
  else
    Result := false;
end;

procedure TContragentForm.UpdateActivityFilter;
var
  ct: variant;
  ActivityData: TDataSet;
  s: string;
begin
  // Вид деятельности контрагента - обновляем фильтр по виду контрагента
  ActivityData := TConfigManager.Instance.StandardDics.deContragentActivity.DicItems;
  if EntSettings.AllContractors and (Contragents.ContragentType <> caCustomer) then
  begin
    ct := cbStatus.KeyValue;
    if VarIsNull(ct) then
      ActivityData.Filter := '1=0'
    else
      ActivityData.Filter := '(A1=' + IntToStr(ct) + ') and Visible';
  end
  else
  begin
    // Если указана категория, то показываем виды для этой категории и те,
    // для которых категория не указана. И только для выбранного вида контрагента.
    ct := cbStatus.KeyValue;
    s := '(A1=' + IntToStr(Contragents.ContragentType) + ') and Visible';
    if not VarIsNull(ct) then
      s := s + ' and (A2 is null or A2=' + VarToStr(ct) + ')';
    ActivityData.Filter := s;
  end;
  ActivityData.Filtered := true;
  dsActivity.DataSet := ActivityData;
end;

procedure TContragentForm.FormCreate(Sender: TObject);
begin
  cbPersonType.KeyItems.Add('0');
  cbPersonType.Items.Add('Юридическое лицо');
  cbPersonType.KeyItems.Add('1');
  cbPersonType.Items.Add('Физическое лицо');

  tsContact.TabVisible := false;
  tsFinance.TabVisible := false;
  
  //XpMenuManager.AddForm(Self);
  {lbName.Caption := LoadStr(S_CName);
  lbAddr.Caption := LoadStr(S_ColAddr);
  lbIndCode.Caption := LoadStr(S_IndCode);
  lbNDSCode.Caption := LoadStr(S_NDSCode);
  lbSource.Caption := LoadStr(S_CustSource);
  lbOther.Caption := LoadStr(S_Other);
  lbUser.Caption := LoadStr(S_User);
  btOk.Caption := LoadStr(S_OK);
  btCancel.Caption := LoadStr(S_Cancel);
  lbDir.Caption := LoadStr(S_Director);
  lbGertva.Caption := LoadStr(S_ColRepres);
  lbBank.Caption := LoadStr(S_Rekv);}
end;

function TContragentForm.CheckNullDate(d: variant): TDateTime;
begin
  if VarIsNull(d) then Result := NullDate
  else Result := d;
end;

procedure TContragentForm.btSendMailClick(Sender: TObject);
var
  MyMail: Variant;
begin
  if OutlookConnect1 = nil then
  begin
    OutlookConnect1 := TOutlookConnect.Create(Self);
    OutlookConnect1.Connected := true;
  end;
  MyMail := OutlookConnect1.CreateMail(NvlString(edEmail.Field.Value));
  MyMail.To := NvlString(edEmail.Field.Value);
//  OutlookConnect1.AddRecipientToMail(MyMail,'lothar.perr@gmx.net');
//  OutlookConnect1.AddAttachmentToMail(MyMail,'c:\autoexec.bat');
  MyMail.Display;
//  MyMail.Send; // Send the mail (save it in the outbox-folder)
end;

procedure TContragentForm.SetContragents(const Value: TContragents);
begin
  FContragents := Value;
  FPersons := nil;
  FAddrs := nil;
  if FContragents <> nil then
  begin
    FPersons := TPersons.Copy(FContragents.Persons);
    dsPersons.DataSet := FPersons.DataSet;

    if FContragents = Customers then
    begin
      FRelated := TRelated.Copy(FContragents.Related);
      dsRelated.DataSet := FRelated.DataSet;
      tsRelated.TabVisible := true;
    end
    else
      tsRelated.TabVisible := false;

    FAddrs := TAddresses.Copy(FContragents.Addresses);
    dsAddrs.DataSet := FAddrs.DataSet;

    FContragents.DataSet.FieldByName(TContragents.F_Alert).OnChange := cbAlertChange;
  end;
end;

procedure TContragentForm.FillActivities;
var
  ActivityData: TDataSet;
begin
  cbMultiActivity.Items.Clear;
  ActivityData := dsActivity.DataSet;
  ActivityData.First;
  while not ActivityData.eof do
  begin
    if NvlBoolean(ActivityData['Visible']) then
    begin
      cbMultiActivity.Items.AddObject(ActivityData['Name'], pointer(NvlInteger(ActivityData['Code'])));
      cbMultiActivity.Checked[cbMultiActivity.Items.Count - 1] := false;
    end;
    ActivityData.Next;
  end;
end;

procedure TContragentForm.SetActivities;
var
  I, ActivityID: Integer;
begin
  FSetActivities := true;
  for I := 0 to cbMultiActivity.Items.Count - 1 do
  begin
    ActivityID := Integer(cbMultiActivity.Items.Objects[I]);
    cbMultiActivity.Checked[I] := FContragents.FindActivity(ActivityID);
  end;
  FSetActivities := false;
end;

procedure TContragentForm.btAddAddressClick(Sender: TObject);
begin
  AddAddress;
end;

procedure TContragentForm.btAddClick(Sender: TObject);
begin
  {FPersons.DataSet.Append;
  if not EditPerson then FPersons.DataSet.Cancel;}
  AddPerson;
end;

procedure TContragentForm.btAddRelatedClick(Sender: TObject);
begin
  AddRelatedContragent;
end;

procedure TContragentForm.btDeleteAddressClick(Sender: TObject);
begin
  DeleteAddress;
end;

procedure TContragentForm.btDeleteClick(Sender: TObject);
begin
  DeletePerson;
end;

procedure TContragentForm.btDeleteRelatedClick(Sender: TObject);
begin
  DeleteRelatedContragent;
end;

// Пришлось сделать такой обработчик, иначе не получается одновременно вводить
// дату вручную и выбирать из календаря.
procedure TContragentForm.dgPersonsColumnsBirthdayUpdateData(Sender: TObject;
  var Text: String; var Value: Variant; var UseText, Handled: Boolean);
begin
  FPersons.Birthday := Value;
  FPersons.DataSet.Post;
  Handled := true;
end;

procedure TContragentForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FContragents <> nil then
    FContragents.DataSet.FieldByName(TContragents.F_Alert).OnChange := nil;

  // отключаем фильтр по виду контрагента
  TConfigManager.Instance.StandardDics.deContragentStatus.DicItems.Filtered := false;
  TConfigManager.Instance.StandardDics.deContragentType.DicItems.Filtered := false;
  TConfigManager.Instance.StandardDics.deContragentActivity.DicItems.Filtered := false;

  FreeAndNil(FPersons);
  FreeAndNil(FAddrs);
  FreeAndNil(FRelated);
end;

procedure TContragentForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Msg: string;
begin
  if btOK.Visible then
    ActiveControl := btOk
  else
    ActiveControl := btCancel;
  if ModalResult = mrOk then
  begin
    if not Contragents.Validate(Msg) then
    begin
      CanClose := false;//ModalResult := mrNone;
      RusMessageDlg(Msg, mtError, [mbOk], 0);
    end
    else
    begin
      Contragents.FirmBirthday := dtFirmBirthday.Date;
      Contragents.DataSet.Post;
      // Применяем изменения в дочерних таблицах контрагента
      FContragents.Persons.MergeData(FPersons.DataSet as TClientDataSet);
      if FRelated <> nil then
        FContragents.Related.MergeData(FRelated.DataSet as TClientDataSet);
      FContragents.Addresses.MergeData(FAddrs.DataSet as TClientDataSet);
    end;
  end;
end;

procedure TContragentForm.btEditAddressClick(Sender: TObject);
begin
  EditAddress;
end;

procedure TContragentForm.btEditPersonClick(Sender: TObject);
begin
  EditPerson;
end;

procedure TContragentForm.btEditRelatedClick(Sender: TObject);
begin
  EditRelatedContragent;
end;

function TContragentForm.AddPerson: boolean;
var
  FPersonsCopy: TPersons;
begin
  FPersonsCopy := TPersons.Copy(FPersons);
  try
    FPersonsCopy.DataSet.Append;
    if ExecPersonForm(FPersonsCopy) then
    begin
      FPersons.MergeData(FPersonsCopy.DataSet as TClientDataSet);
      Result := true;
    end
    else
      Result := false;
  finally
    FPersonsCopy.Free;
  end;
end;

function TContragentForm.EditPerson: boolean;
var
  FPersonsCopy: TPersons;
begin
  if not FPersons.DataSet.IsEmpty then
  begin
    FPersonsCopy := TPersons.Copy(FPersons);
    try
      if ExecPersonForm(FPersonsCopy) then
      begin
        FPersons.MergeData(FPersonsCopy.DataSet as TClientDataSet);
        Result := true;
      end
      else
        Result := false;
    finally
      FPersonsCopy.Free;
    end;
  end
  else
    Result := false;
end;

procedure TContragentForm.DeletePerson;
begin
  if not FPersons.DataSet.IsEmpty then
    FPersons.DataSet.Delete;
end;

procedure TContragentForm.cbActivityClick(Sender: TObject);
begin
  if cbActivity.Enabled and not cbActivity.ReadOnly then
    cbActivity.DropDown;
end;

procedure TContragentForm.cbPersonTypeChange(Sender: TObject);
begin
  //FContragents.DataSet.CheckBrowseMode;
  // if FContragents.PersonType = PersonType_Juri then
  if cbPersonType.ItemIndex = PersonType_Juri then
  begin
    lbName.Caption := 'Краткое наименование';
    lbFullName.Visible := true;
    edFullName.Visible := true;
    cbAlert.Visible := true;
    //lbFirmType.Visible := true;
    //edFirmType.Visible := true;
  end
  else
  begin
    lbName.Caption := 'Ф.И.О.';
    lbFullName.Visible := false;
    edFullName.Visible := false;
    cbAlert.Visible := false;
    //lbFirmType.Visible := false;
    //edFirmType.Visible := false;
  end;
end;

procedure TContragentForm.cbAlertChange(Field: TField);
begin
  if NvlBoolean(FContragents.DataSet[TContragents.F_Alert]) then
  begin
    edFullName.Font.Color := clRed;
    edFullName.Font.Style := [fsBold];
  end
  else
  begin
    edFullName.Font.Color := clWindowText;
    edFullName.Font.Style := [];
  end;
end;

procedure TContragentForm.cbMultiActivityChange(Sender: TObject);
var
  I, ActivityID: Integer;
begin
  if FSetActivities then Exit;
  
  for I := 0 to cbMultiActivity.Items.Count - 1 do
  begin
    ActivityID := Integer(cbMultiActivity.Items.Objects[I]);
    if cbMultiActivity.Checked[I] then
      FContragents.AddActivity(ActivityID)
    else
      FContragents.DeleteActivity(ActivityID);
  end;
end;

procedure TContragentForm.cbPersonTypeClick(Sender: TObject);
begin
  if cbPersonType.Enabled and not cbPersonType.ReadOnly then
    cbPersonType.DropDown;
end;

procedure TContragentForm.cbStatusClick(Sender: TObject);
begin
  if cbStatus.Enabled and not cbStatus.ReadOnly then
    cbStatus.DropDown;
end;

procedure TContragentForm.cbStatusCloseUp(Sender: TObject; Accept: Boolean);
begin
  UpdateActivityFilter;
end;

function TContragentForm.AddRelatedContragent: boolean;
var
  FContragentsCopy: TRelated;
begin
  FContragentsCopy := TRelated.Copy(FRelated);
  try
    FContragentsCopy.DataSet.Append;
    if ExecRelatedContragentForm(FContragentsCopy) then
    begin
      FRelated.MergeData(FContragentsCopy.DataSet as TClientDataSet);
      Result := true;
    end
    else
      Result := false;
  finally
    FContragentsCopy.Free;
  end;
end;

function TContragentForm.EditRelatedContragent: boolean;
var
  FContragentsCopy: TRelated;
begin
  if not FRelated.IsEmpty then
  begin
    FContragentsCopy := TRelated.Copy(FRelated);
    try
      if ExecRelatedContragentForm(FContragentsCopy) then
      begin
        FRelated.MergeData(FContragentsCopy.DataSet as TClientDataSet);
        Result := true;
      end
      else
        Result := false;
    finally
      FContragentsCopy.Free;
    end;
  end
  else
    Result := false;
end;

procedure TContragentForm.DeleteRelatedContragent;
begin
  if not FRelated.DataSet.IsEmpty then
    FRelated.DataSet.Delete;
end;

function TContragentForm.EditAddress: boolean;
var
  FAddrsCopy: TAddresses;
begin
  if not FAddrs.IsEmpty then
  begin
    FAddrsCopy := TAddresses.Copy(FAddrs);
    try
      if ExecAddressForm(FAddrsCopy) then
      begin
        FAddrs.MergeData(FAddrsCopy.DataSet as TClientDataSet);
        Result := true;
      end
      else
        Result := false;
    finally
      FAddrsCopy.Free;
    end;
  end
  else
    Result := false;
end;

function TContragentForm.AddAddress: boolean;
var
  FAddrsCopy: TAddresses;
begin
  FAddrsCopy := TAddresses.Copy(FAddrs);
  try
    FAddrsCopy.DataSet.Append;
    if ExecAddressForm(FAddrsCopy) then
    begin
      FAddrs.MergeData(FAddrsCopy.DataSet as TClientDataSet);
      Result := true;
    end
    else
      Result := false;
  finally
    FAddrsCopy.Free;
  end;
end;

procedure TContragentForm.DeleteAddress;
begin
  if not FAddrs.DataSet.IsEmpty then
    FAddrs.DataSet.Delete;
end;


end.
