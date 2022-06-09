unit fPerson;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PmContragent, DB, Buttons, Mask, DBCtrls, JvExMask,
  JvToolEdit, DBGridEh, DBCtrlsEh, DBLookupEh;

type
  TPersonForm = class(TForm)
    btOk: TButton;
    btCancel: TButton;
    PersonDataSource: TDataSource;
    DBEdit1: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    Label5: TLabel;
    DBEdit5: TDBEdit;
    dtBirthday: TJvDateEdit;
    Label6: TLabel;
    cbPersonType: TDBLookupComboboxEh;
    Label7: TLabel;
    dsPersonType: TDataSource;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbPersonTypeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FPersonData: TPersons;
    procedure SetPersonData(const Value: TPersons);
  public
    property PersonData: TPersons read FPersonData write SetPersonData;
  end;

function ExecPersonForm(PersonData: TPersons): boolean;

implementation

uses JvJCLUtils, PmConfigManager, RDialogs;

{$R *.dfm}

function ExecPersonForm(PersonData: TPersons): boolean;
var
  PersonForm: TPersonForm;
begin
  Application.CreateForm(TPersonForm, PersonForm);
  try
    PersonForm.PersonData := PersonData;
    Result := PersonForm.ShowModal = mrOk;
  finally
    FreeAndNil(PersonForm);
  end;
end;

function CheckNullDate(d: variant): TDateTime;
begin
  if VarIsNull(d) then Result := NullDate
  else Result := d;
end;

procedure TPersonForm.cbPersonTypeClick(Sender: TObject);
begin
  if cbPersonType.Enabled and not cbPersonType.ReadOnly then
    cbPersonType.DropDown;
end;

procedure TPersonForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ActiveControl := btOk;
end;

procedure TPersonForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Msg: string;
begin
  if btOK.Visible then
    ActiveControl := btOk
  else
    ActiveControl := btCancel;
  if ModalResult = mrOk then
  begin
    if FPersonData.Birthday <> dtBirthday.Date then
    begin
      if dtBirthday.Date = NullDate then
        FPersonData.Birthday := null
      else
        FPersonData.Birthday := dtBirthday.Date;
    end;
    CanClose := FPersonData.Validate(Msg);
    if not CanClose then
      RusMessageDlg(Msg, mtError, [mbOk], 0);
  end;
end;

procedure TPersonForm.FormCreate(Sender: TObject);
begin
  dsPersonType.DataSet := TConfigManager.Instance.StandardDics.dePersonType.DicItems;
end;

procedure TPersonForm.SetPersonData(const Value: TPersons);
begin
  FPersonData := Value;
  PersonDataSource.DataSet := FPersonData.DataSet;
  dtBirthday.Date := CheckNullDate(FPersonData.Birthday);
end;

end.
