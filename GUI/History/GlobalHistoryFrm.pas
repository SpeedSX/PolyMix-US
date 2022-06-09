unit GlobalHistoryFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGridEh, MyDBGridEh, JvComponent, JvFormPlacement,
  StdCtrls, ExtCtrls, JvAppStorage,
  PmEntity, HistFrm, Mask, JvExMask, JvToolEdit, Buttons, PmHistory,
  JvComponentBase, GridsEh, DB, DBGridEhGrouping;

type
  TGlobalHistoryForm = class(THistoryForm)
    Panel4: TPanel;
    cbUser: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    deStart: TJvDateEdit;
    deFinish: TJvDateEdit;
    Label3: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FilterChanged(Sender: TObject);
    procedure FormStorageStoredValues0Restore(Sender: TJvStoredValue;
      var AValue: Variant);
    procedure FormStorageStoredValues0Save(Sender: TJvStoredValue;
      var AValue: Variant);
    procedure FormStorageStoredValues1Restore(Sender: TJvStoredValue;
      var AValue: Variant);
    procedure FormStorageStoredValues1Save(Sender: TJvStoredValue;
      var AValue: Variant);
    procedure FormStorageStoredValues2Restore(Sender: TJvStoredValue;
      var AValue: Variant);
    procedure FormStorageStoredValues2Save(Sender: TJvStoredValue;
      var AValue: Variant);
    procedure FormCreate(Sender: TObject);
  private
    FHistory: TGlobalHistoryView;
    FSettingFilter: boolean;
    function GetUser: variant;
    procedure SetUser(UserLogin: string);
  protected
    UsersCopy: TStringList;
    procedure DoFormActivate; override;
    procedure DoRefreshHistory; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  GlobalHistoryForm: TGlobalHistoryForm;

procedure ExecGlobalHistoryForm(_MainStorage: TJvCustomAppStorage);

implementation

uses JvJCLUtils, CalcUtils, PmAccessManager, RDBUtils;

{$R *.dfm}

procedure ExecGlobalHistoryForm(_MainStorage: TJvCustomAppStorage);
begin
  try
    Application.CreateForm(TGlobalHistoryForm, GlobalHistoryForm);
    GlobalHistoryForm.MainStorage := _MainStorage;
    GlobalHistoryForm.ShowModal;
  finally
    FreeAndNil(GlobalHistoryForm);
  end;
end;

constructor TGlobalHistoryForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TGlobalHistoryForm.DoFormActivate;
begin
  FHistory := TGlobalHistoryView.Create;
  FHistory.UsePager := true;

  FSettingFilter := false;
  // Восстанавливаем фильтр
  //deStart.Date := StrToDateMyFmt(NvlString(FormStorage.StoredValue['StartDate']));
  //deFinish.Date := StrToDateMyFmt(NvlString(FormStorage.StoredValue['EndDate']));
  //SetUser(NvlString(FormStorage.StoredValue['UserLogin']));
  FilterChanged(nil);

  dsHistory.DataSet := FHistory.DataSet;
end;

function TGlobalHistoryForm.GetUser: variant;
begin
  // Последний элемент списка означает отсутствие фильтра
  if (cbUser.ItemIndex <> -1) and (cbUser.ItemIndex <> UsersCopy.Count - 1) then
    Result := AccessManager.Users[cbUser.ItemIndex]
  else
    Result := null;
end;

procedure TGlobalHistoryForm.SetUser(UserLogin: string);
begin
  cbUser.ItemIndex := AccessManager.Users.IndexOf(UserLogin);
end;

procedure TGlobalHistoryForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // TODO: Надо ли освобождать список пользователей?
  FHistory.Free;
  // Сохраняем фильтр
  //FormStorage.StoredValue['StartDate'] := DateToStrMyFmt(deStart.Date);
  //FormStorage.StoredValue['EndDate'] := DateToStrMyFmt(deFinish.Date);
  //FormStorage.StoredValue['UserLogin'] := VarToStr(GetUser);
end;

procedure TGlobalHistoryForm.FormCreate(Sender: TObject);
begin
  inherited;
  // Отключаем обработку событий изменения фильтра, пока они не загрузятся все
  FSettingFilter := true;
  deStart.Date := CutTime(Now);
  deFinish.Date := Now;
  // Создаем копию списка пользователей с полным именем и логином для комбобокса
  if UsersCopy <> nil then UsersCopy.Free;
  UsersCopy := AccessManager.GetUsersCopy;
  UsersCopy.Add('<все>');
  cbUser.Items := UsersCopy;
end;

procedure TGlobalHistoryForm.FormStorageStoredValues0Restore(
  Sender: TJvStoredValue; var AValue: Variant);
begin
  deStart.Date := StrToDateMyFmt(VarToStr(AValue));
end;

procedure TGlobalHistoryForm.FormStorageStoredValues0Save(
  Sender: TJvStoredValue; var AValue: Variant);
begin
  AValue := DateToStrMyFmt(deStart.Date);
end;

procedure TGlobalHistoryForm.FormStorageStoredValues1Restore(
  Sender: TJvStoredValue; var AValue: Variant);
begin
  deFinish.Date := StrToDateMyFmt(VarToStr(AValue));
end;

procedure TGlobalHistoryForm.FormStorageStoredValues1Save(
  Sender: TJvStoredValue; var AValue: Variant);
begin
  AValue := DateToStrMyFmt(deFinish.Date);
end;

procedure TGlobalHistoryForm.FormStorageStoredValues2Restore(
  Sender: TJvStoredValue; var AValue: Variant);
begin
  if not VarIsNull(AValue) then
    SetUser(VarToStr(AValue));
end;

procedure TGlobalHistoryForm.FormStorageStoredValues2Save(
  Sender: TJvStoredValue; var AValue: Variant);
begin
  AValue := VarToStr(GetUser);
end;

procedure TGlobalHistoryForm.FilterChanged(Sender: TObject);
var
  Criteria: TGlobalHistoryCriteria;
begin
  if not FSettingFilter then
  begin
    if deStart.Date = NullDate then
      Criteria.StartDate := null
    else
      Criteria.StartDate := deStart.Date;

    if deFinish.Date = NullDate then
      Criteria.EndDate := null
    else
      Criteria.EndDate := deFinish.Date;

    Criteria.UserLogin := GetUser;

    FHistory.Criteria := Criteria;
    FHistory.Reload;
  end;
end;

procedure TGlobalHistoryForm.DoRefreshHistory;
begin
  FHistory.Reload;
end;

end.
