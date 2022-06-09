unit PmContragentListForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, db, ComCtrls, ExtCtrls, DBClient, ADODB,
  ImgList, JvComponent, JvFormPlacement, JvAppStorage, JvDBLookup, DBGridEh,
  GridsEh, ActnList, Menus,

  MyDBGridEh, PmContragent, PmUtils, JvComponentBase,
  NotifyEvent, JvExStdCtrls, JvDBCombobox, Mask, DBCtrlsEh, DBLookupEh,
  DBGridEhGrouping;

type
  TContragentListForm = class(TForm)
    Panel1: TPanel;
    dsCust: TDataSource;
    lbFilt: TLabel;
    edName: TEdit;
    Label1: TLabel;
    Bevel1: TBevel;
    cbbFilter: TComboBox;
    Panel2: TPanel;
    InsertBtn: TSpeedButton;
    EditBtn: TSpeedButton;
    DeleteBtn: TSpeedButton;
    Panel3: TPanel;
    dgCust: TMyDBGridEh;
    Panel4: TPanel;
    OkBtn: TButton;
    CancelBtn: TSpeedButton;
    FormStorage: TJvFormStorage;
    Label2: TLabel;
    btActions: TButton;
    pmActions: TPopupMenu;
    acContragent: TActionList;
    acMerge: TAction;
    miMerge: TMenuItem;
    acHistory: TAction;
    miHistory: TMenuItem;
    imContragent: TImageList;
    lbFilter: TLabel;
    cbbCat: TComboBox;
    Label4: TLabel;
    lbContrType: TLabel;
    cbbActivity: TComboBox;
    pmContragentType: TPopupMenu;
    miNewContractor: TMenuItem;
    miNewSupplier: TMenuItem;
    cbbActivityEh: TDBLookupComboboxEh;
    dsActivity: TDataSource;
    procedure FormActivate(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure InsertBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure EditBtnClick(Sender: TObject);
    procedure pcCustChanging(Sender: TObject; var AllowChange: Boolean);
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure dgGridKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dgCustDblClick(Sender: TObject);
    procedure acMergeExecute(Sender: TObject);
    procedure acHistoryExecute(Sender: TObject);
    procedure btActionsClick(Sender: TObject);
    procedure dgCustGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure miNewContractorClick(Sender: TObject);
    procedure miNewSupplierClick(Sender: TObject);
    procedure cbbCatChange(Sender: TObject);
  private
    LastAddName: string;
    FCurCustomer: integer;
    FContragents: TContragents;
    FSelectMode: Boolean;
    FCustAfterScrollEventId: TNotifyHandlerID;
    WasActive: boolean;
    procedure SetCustDS;
    procedure ResetCustDS;
    function Apply: boolean;
    procedure CustAfterScroll(Sender: TObject);
    function GetFilterExpr: string;
    procedure ReOpenData;
    //procedure LocateCust;
    procedure SetCurCustomer(Value: integer);
    procedure RestoreFilterControls;
    procedure SaveFilterControls;
    procedure CustRestoreColumns;
    procedure CustSaveColumns;
    function GetDataSet: TClientDataSet;
    property DataSet: TClientDataSet read GetDataSet;
    procedure SetContragents(c: TContragents);
    procedure SetSelectMode(const Value: Boolean);
    procedure NewContragent(_ContragentType: integer);
    procedure FillActivities;
    procedure FillCategories;
    function AllContractors: boolean;
  public
    property CurCustomer: integer read FCurCustomer write SetCurCustomer; // Текущий заказчик
    property Contragents: TContragents read FContragents write SetContragents;
    property SelectMode: Boolean read FSelectMode write SetSelectMode;
  end;

var
  ContragentListForm: TContragentListForm;
  CustNum: integer;
  CustAppStorage: TjvCustomAppStorage;

const
  custCancel = 2000000001;
  custNoName = 2000000002;
  custError =  2000000003;

// SelectMode = true если режим выбора, false если режим просмотра.
// Если выбор, то по двойному нажатию окно закрывается, иначе свойства заказчика.
function ExecContragentSelect(Contragents: TContragents; CurCustomer: integer;
  SelectMode: boolean): integer;

implementation

uses PmContragentForm, RDialogs, {UkrUtils, }ADOUtils, RDBUtils,
  Variants, jvJVCLUtils, CalcSettings, DicObj, StdDic, ExHandler, PmAccessManager,
  PmAppController, PmContragentPainter, PmContragentPainterManager, CalcUtils,
  PmConfigManager, PmEntSettings;

{$R *.DFM}

const
  iAll = 0;
  iWork = 1;
  iCalc = 2;

function ExecContragentSelect(Contragents: TContragents; CurCustomer: integer;
  SelectMode: boolean): integer;
begin
  Application.CreateForm(TContragentListForm, ContragentListForm);
  Application.CreateForm(TContragentForm, ContragentForm);
  try
    ContragentListForm.Contragents := Contragents;
    ContragentListForm.CurCustomer := CurCustomer;
    ContragentListForm.SelectMode := SelectMode;
    ContragentListForm.FormStorage.AppStorage := CustAppStorage;
    ContragentForm.FormStorage.AppStorage := CustAppStorage;
    Result := ContragentListForm.ShowModal;
  finally
    FreeAndNil(ContragentListForm);
    FreeAndNil(ContragentForm);
  end;
end;

type
  TCodeObject = class
    Code: integer;
    Name: string;
    constructor Create(_Code: integer; _Name: string);
  end;

constructor TCodeObject.Create(_Code: integer; _Name: string);
begin
  inherited Create;
  Code := _Code;
  Name := _Name;
end;

function TContragentListForm.GetDataSet: TClientDataSet;
begin
  Result := Contragents.DataSet as TClientDataSet;
end;

{procedure TContragentListForm.LocateCust;
begin
  Contragents.KeyValue := CurCustomer;
end;}

procedure TContragentListForm.ReOpenData;
begin
  Contragents.ReloadLocate(CurCustomer);
end;

procedure TContragentListForm.RestoreFilterControls;
begin
  if Options.CustFilterMode < 0 then Options.CustFilterMode := iAll;
  // TODO: Пока отключено, надо хранить отдельно настройки для заказчиков и контрагентов 
  {cbbFilter.ItemIndex := Options.CustFilterMode;
  if Options.CustFilterType < cbbActivity.Items.Count then
    cbbActivity.ItemIndex := Options.CustFilterType;
  if Options.CustFilterCat < cbbCat.Items.Count then
    cbbCat.ItemIndex := Options.CustFilterCat;}
  edNameChange(nil);
end;

procedure TContragentListForm.SaveFilterControls;
begin
  Options.CustFilterMode := cbbFilter.ItemIndex;
  Options.CustFilterType := cbbActivity.ItemIndex;
  Options.CustFilterCat := cbbCat.ItemIndex;
end;

function TContragentListForm.AllContractors: boolean;
begin
  Result := EntSettings.AllContractors and (FContragents.ContragentType <> caCustomer);
end;

procedure TContragentListForm.FillActivities;
var
  ds, dsType: TDictionary;
  dsf: string;
begin
  // список видов деятельности заказчиков
  cbbActivity.Items.Clear;
  cbbActivity.Items.Add('<Все>');
  ds := TConfigManager.Instance.StandardDics.deContragentActivity;
  // В режиме объединения подрядчиков и поставщиков фильтр устанавливается по текущей выбранной категории
  if AllContractors then
  begin
    if cbbCat.ItemIndex > 0 then
      ds.DicItems.Filter := 'A1=' + IntToStr(TCodeObject(cbbCat.Items.Objects[cbbCat.ItemIndex]).Code)
    else
    begin   // Если категория не выбрана, то берем все категории
      dsf := '';
      dsType := TConfigManager.Instance.StandardDics.deContragentType;
      dsType.DicItems.First;
      dsType.DicItems.Next; // Первый пропускаем, это заказчики
      while not dsType.DicItems.eof do
      begin
        if dsf <> '' then
          dsf := dsf + ' or ';
        dsf := dsf + '(A1=' + IntToStr(dsType.CurrentCode) + ')';
        dsType.DicItems.Next;
      end;
      //if dsf <> '' then dsf := '(' + dsf + ') and Visible';
      ds.DicItems.Filter := dsf;
    end;
  end
  else
  begin
    // Если указана категория, то показываем виды для этой категории и те,
    // для которых категория не указана. И только для выбранного вида контрагента.
    dsf := 'A1=' + IntToStr(FContragents.ContragentType) + ' and Visible';
    if cbbCat.ItemIndex > 0 then
      dsf := dsf + ' and (A2 is null or A2='
        + IntToStr(TCodeObject(cbbCat.Items.Objects[cbbCat.ItemIndex]).Code) + ')';
    ds.DicItems.Filter := dsf;
  end;

  ds.DicItems.Filtered := true;
  try
    ds.DicItems.First;
    while not ds.DicItems.Eof do
    begin
      if ds.CurrentEnabled then
        cbbActivity.Items.AddObject(ds.CurrentName, TCodeObject.Create(ds.CurrentCode, ds.CurrentName));
      ds.DicItems.Next;
    end;
  finally
    ds.DicItems.Filtered := false;
  end;
  
  cbbActivity.ItemIndex := 0;
end;

procedure TContragentListForm.FillCategories;
var
  ds: TDictionary;
begin
  cbbCat.Items.Clear;
  cbbCat.Items.Add('<Все>');

  // В режиме объединения подрядчиков и поставщиков отображаем список видов контрагентов
  if AllContractors then
  begin
    ds := TConfigManager.Instance.StandardDics.deContragentType;
    ds.DicItems.Filter := '(Code <> 1) and Visible';
    dgCust.FieldColumns[TContragents.F_StatusName].Visible := false;
  end
  else
  begin
    // список категорий контрагентов для вида контрагента
    ds := TConfigManager.Instance.StandardDics.deContragentStatus;
    ds.DicItems.Filter := '(A1=' + IntToStr(FContragents.ContragentType) + ') and Visible';
  end;

  ds.DicItems.Filtered := true;
  try
    while not ds.DicItems.Eof do
    begin
      if ds.CurrentEnabled then
        cbbCat.Items.AddObject(ds.CurrentName, TCodeObject.Create(ds.CurrentCode, ds.CurrentName));
      ds.DicItems.Next;
    end;
  finally
    ds.DicItems.Filtered := false;
  end;

  cbbCat.ItemIndex := 0;
end;

procedure TContragentListForm.FormActivate(Sender: TObject);
begin
  // проверка корректности формы - чтобы избежать глюка с пропаданием списка в комбобоксе
  //if cbbFilter.Items.Count = 0 then
  //  raise Exception.Create('Программа некорректно собрана! Пустой список фильтра!');

  if not WasActive then
  begin
    if AllContractors then
      InsertBtn.PopupMenu := pmContragentType;

    cbbFilter.Items.Add('<Все>');
    cbbFilter.Items.Add('Подтвержденные');
    cbbFilter.Items.Add('Неподтвержденные');

    FillCategories;

    FillActivities;

    // Вид заказчика
    {cbbType.Items.Add('<Все>');
    cbbType.Items.Add('Юридическое лицо');
    cbbType.Items.Add('Физическое лицо');}

    InsertBtn.Enabled := AccessManager.CurUser.AddCustomer;

    ReOpenData; // открываем данные

    RestoreFilterControls;

    if FCustAfterScrollEventId = TNotifier.EmptyId then
      FCustAfterScrollEventId := Contragents.AfterScrollNotifier.RegisterHandler(CustAfterScroll);

    WasActive := true;
  end;
end;

function TContragentListForm.GetFilterExpr: string;
var s, xs: string;

  procedure add(var s: string; adds: string);
  begin
    if s <> '' then s := s + ' and ';
    s := s + adds;
  end;

begin
  if edName.Text <> '' then s := 'Name=''' + edName.Text + '*''' else s := '';
  if Contragents.WorkSeparation and (cbbFilter.ItemIndex = iWork) or (cbbFilter.ItemIndex = iCalc) then begin
    if (cbbFilter.ItemIndex = 1) then xs := xs + ' IsWork'
    else xs := xs + ' not IsWork';
    add(s, xs);
  end;
  if cbbCat.ItemIndex > 0 then
  begin
    if AllContractors then
      xs := 'ContragentType=' + IntToStr(TCodeObject(cbbCat.Items.Objects[cbbCat.ItemIndex]).Code)
    else
      xs := 'StatusCode=' + IntToStr(TCodeObject(cbbCat.Items.Objects[cbbCat.ItemIndex]).Code);
    add(s, xs);
  end;
  if cbbActivity.ItemIndex > 0 then
  begin
    xs := 'ActivityCode=' + IntToStr(TCodeObject(cbbActivity.Items.Objects[cbbActivity.ItemIndex]).Code);
    add(s, xs);
  end;
  {if cbbType.ItemIndex > 0 then
  begin
    xs := 'PersonType=' + IntToStr(cbbType.ItemIndex - 1);
    add(s, xs);
  end;}
  Result := s;
end;

procedure TContragentListForm.edNameChange(Sender: TObject);
var
  CurID: integer;
begin
  CurID := NvlInteger(FContragents.KeyValue);
  DataSet.Filter := GetFilterExpr;
  if CurID <> 0 then
    FContragents.Locate(CurID);
end;

procedure TContragentListForm.OkBtnClick(Sender: TObject);
var
  k: integer;
begin
  try
    Apply;
  except on e: Exception do
  begin
    RusMessageDlg('Ошибка при сохранении данных:' + #13 + E.message, mtError, [mbOK], 0);
    ModalResult := mrNone;
  end;
  end;
  if CustNum = custError then begin
    if RusMessageDlg('Закрыть без сохранения?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
      DataSet.CancelUpdates;
      ModalResult := custNoName;
    end
  end
  else
  begin
    k := NvlInteger(Contragents.KeyValue);
    if k = 0 then
      ModalResult := custNoName
    else
      ModalResult := k;
  end;
end;

procedure TContragentListForm.CancelBtnClick(Sender: TObject);
begin
  if Assigned(DataSet) and DataSet.Active then DataSet.CancelUpdates;
  ModalResult := custCancel;
end;

procedure TContragentListForm.cbbCatChange(Sender: TObject);
begin
  FillActivities;
  edNameChange(Sender);
end;

procedure TContragentListForm.acHistoryExecute(Sender: TObject);
begin
  AppController.ViewContragentHistory(Contragents);
end;

procedure TContragentListForm.acMergeExecute(Sender: TObject);
begin
  AppController.MergeContragent(Contragents);
end;

function TContragentListForm.Apply: boolean;
var
  k: integer;                                    
begin
  Result := false;
  Contragents.DataSet.CheckBrowseMode;
  if not Contragents.DataSet.IsEmpty then
  begin
    if not VarIsNull(Contragents.KeyValue) and (Contragents.KeyValue > 0) then
    begin
      k := Contragents.KeyValue;
      LastAddName := '';
    end else
      LastAddName := Contragents.Name;
  end;
  if Contragents.HasChanges then
  begin
    Contragents.ApplyUpdates;
    Contragents.Reload;
  end;
  if LastAddName <> '' then Contragents.FindName(LastAddName)
  else Contragents.KeyValue := k;
  LastAddName := '';
  Result := true;
end;

procedure TContragentListForm.btActionsClick(Sender: TObject);
begin
  pmActions.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;


procedure TContragentListForm.NewContragent(_ContragentType: integer);
var FilterName: string;
begin
  if not Contragents.Active then Exit;
  SetCustDS;
  if (cbbFilter.ItemIndex = iWork) and cbbFilter.Visible then
    cbbFilter.ItemIndex := iAll;
  FilterName := edName.Text;
  edName.Text := '';
  Contragents.DataSet.Append;
  Contragents.Name := FilterName;
  Contragents.ContragentTypeValue := _ContragentType;
  // В режиме объединения подрядчиков присваиваем категорию как вид
  if AllContractors then
    Contragents.StatusCode := _ContragentType;
  ContragentForm.ReadOnly := false;
  // Проверяем можно ли менять владельца
  ContragentForm.AllowUserChange := AccessManager.CurUser.ChangeCustomerOwner;
  ContragentForm.Contragents := Contragents;
  if ContragentForm.ShowModal = mrOk then
  begin
    // В режиме объединения подрядчиков присваиваем категорию как вид
    if AllContractors then
      Contragents.ContragentTypeValue := Contragents.StatusCode;
    LastAddName := Contragents.Name;
    dgCust.SetFocus;
  end else
    Contragents.DataSet.Cancel;
  ResetCustDS;
end;

procedure TContragentListForm.InsertBtnClick(Sender: TObject);
begin
  NewContragent(Contragents.ContragentType);
end;

procedure TContragentListForm.miNewContractorClick(Sender: TObject);
begin
  NewContragent(caContractor);
end;

procedure TContragentListForm.miNewSupplierClick(Sender: TObject);
begin
  NewContragent(caSupplier);
end;

procedure TContragentListForm.EditBtnClick(Sender: TObject);
begin
  if not DataSet.Active or DataSet.IsEmpty then Exit;
  SetCustDS;
  // В режиме объединения подрядчиков присваиваем категорию как вид
  if AllContractors and (Contragents.StatusCode <> Contragents.ContragentTypeValue) then
    Contragents.StatusCode := Contragents.ContragentTypeValue;
  // Разрешить если свой или разрешено редактирование чужого
  ContragentForm.ReadOnly := not (AccessManager.CurUser.EditOtherCustomer
    or (AccessManager.CurUser.ID = Contragents.UserCode));
  // Проверяем можно ли менять владельца
  ContragentForm.AllowUserChange := AccessManager.CurUser.ChangeCustomerOwner;
  ContragentForm.Contragents := Contragents;
  if ContragentForm.ShowModal <> mrOk then
    DataSet.RevertRecord
  else
  begin
    // В режиме объединения подрядчиков присваиваем категорию как вид
    if AllContractors and (Contragents.ContragentTypeValue <> Contragents.StatusCode) then
      Contragents.ContragentTypeValue := Contragents.StatusCode;
    Contragents.DataSet.CheckBrowseMode;
  end;
  ResetCustDS;
end;

procedure TContragentListForm.DeleteBtnClick(Sender: TObject);
begin
  if not DataSet.Active or DataSet.IsEmpty then Exit;
  if AccessManager.CurUser.EditOtherCustomer or (AccessManager.CurUser.ID = Contragents.UserCode) then
  begin
    if Options.ContragentConfirmDelete and
      (RusMessageDlg('Удалить запись?', mtConfirmation, mbYesNoCancel, 0) <> mrYes) then Exit;
    try
      DataSet.Delete;
    except on E: Exception do
      ExceptionHandler.Raise_(E, 'Ошибка при удалении записи');
    end;
  end;
end;

procedure TContragentListForm.SetCustDS;
begin
  ContragentForm.DataSource := dsCust;
  if Contragents.RequireInfoSource then
    ContragentForm.InfoData := TConfigManager.Instance.StandardDics.deInfoSource.DicItems
  else
    ContragentForm.InfoData := nil;
  ContragentForm.UserData := AccessManager.AllUsersData;
end;

procedure TContragentListForm.ResetCustDS;
begin
  ContragentForm.DataSource := nil;
  ContragentForm.InfoData := nil;
  ContragentForm.UserData := nil;
end;

procedure TContragentListForm.pcCustChanging(Sender: TObject; var AllowChange: Boolean);
begin
  edName.Text := '';
//  Apply(DataSet);
  AllowChange := true;
  ResetCustDS;
end;

procedure TContragentListForm.edNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then begin edName.Text := ''; DataSet.Filter := ''; Key := #0; end
  else if Key = #13 then begin
    dgCust.SetFocus;
    //FocusControl(FindNextControl(Sender as TWinControl, true, true, false));
    Key := #0;
  end;
end;

procedure TContragentListForm.FormCreate(Sender: TObject);
begin
  //lbFilt.Caption := LoadStr(SUFilter + SSS);
  {with dgCust do begin
    Columns[1].Title.Caption := ;
    Columns[4].Title.Caption := LoadStr(S_ColRepres);
    Columns[5].Title.Caption := LoadStr(S_ColAddr);
  end;
  InsertBtn.Caption := LoadStr(S_Add);
  EditBtn.Caption := LoadStr(S_Edit);
  DeleteBtn.Caption := LoadStr(S_Delete);
  OKBtn.Caption := LoadStr(S_OK);
  CancelBtn.Caption := LoadStr(S_Cancel);}

  TSettingsManager.Instance.XPInitComponent(pmActions);
end;

procedure TContragentListForm.dgGridKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin OkBtnClick(Sender); Key := #0 end;
end;

procedure TContragentListForm.CustAfterScroll(Sender: TObject);
var En: boolean;
begin
  En := not DataSet.IsEmpty;
  EditBtn.Enabled := En;
  DeleteBtn.Enabled := En;
end;

procedure TContragentListForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin
  //if DataSet <> nil then DataSet.AfterScroll := Save_DataSetAfterScroll;
  Contragents.AfterScrollNotifier.UnregisterHandler(FCustAfterScrollEventId);
  SaveFilterControls;
  CustSaveColumns;
  if DataSet <> nil then DataSet.Filtered := false;
  for I := 0 to cbbCat.Items.Count - 1 do
    cbbCat.Items.Objects[I].Free;
  for I := 0 to cbbActivity.Items.Count - 1 do
    cbbActivity.Items.Objects[I].Free;
end;

procedure TContragentListForm.SetCurCustomer(Value: integer);
begin
  FCurCustomer := Value;
  DataSet.Filtered := true;
  DataSet.Filter := GetFilterExpr;
  if not DataSet.Active then ReOpenData;
  //LocateCust;
end;

procedure TContragentListForm.CustRestoreColumns;
begin
  LoadColumns(CustAppStorage, dgCust, iniCust + Contragents.ClassName);
end;

procedure TContragentListForm.CustSaveColumns;
begin
  SaveColumns(CustAppStorage, dgCust, iniCust + Contragents.ClassName);
end;

procedure TContragentListForm.SetContragents(c: TContragents);
var
  ContragentPainter: TContragentPainter;
begin
  FContragents := c;
  if AllContractors then
    Caption := 'Поставщики и подрядчики'
  else
    Caption := Contragents.NamePlural;
  ContragentPainter := TContragentPainterManager.GetPainter(c);
  ContragentPainter.AddControl(cbbFilter);
  ContragentPainter.AddControl(dgCust);
  cbbFilter.Visible := Contragents.WorkSeparation;
  lbFilter.Visible := Contragents.WorkSeparation;
  dgCust.Columns[0].Visible := Contragents.WorkSeparation;
  CustRestoreColumns;
  dsCust.DataSet := DataSet;
  ContragentForm.Contragents := FContragents;
end;

procedure TContragentListForm.SetSelectMode(const Value: Boolean);
begin
  FSelectMode := Value;
  if FSelectMode then OkBtn.Caption := 'Выбрать' else OkBtn.Caption := 'OK';
end;

procedure TContragentListForm.dgCustDblClick(Sender: TObject);
begin
  if FSelectMode then
    OkBtnClick(Sender)
  else
    EditBtnClick(Sender);
end;

procedure TContragentListForm.dgCustGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
var
  s: string;
  bk: TColor;
begin
  Background := clWindow;
  if NvlInteger(FContragents.StatusCode) > 0 then
  begin
    s := Trim(NvlString(TConfigManager.Instance.StandardDics.deContragentStatus.ItemValue[FContragents.StatusCode, 2]));
    if (s <> '') and MyHexToColor(s, bk) then
      Background := bk;
  end;
end;

end.
