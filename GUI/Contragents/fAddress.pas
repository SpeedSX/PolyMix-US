unit fAddress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PmContragent, DB, Buttons, Mask, DBCtrls, JvExMask,
  JvToolEdit, fBaseEditForm, JvComponentBase, JvFormPlacement, DBGridEh,
  DBCtrlsEh, DBLookupEh;

type
  TAddressForm = class(TBaseEditForm)
    AddressDataSource: TDataSource;
    edAddr: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    edNote: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    Label4: TLabel;
    Label3: TLabel;
    cbPersonType: TDBLookupComboboxEh;
    Label5: TLabel;
    DBEdit1: TDBEdit;
    Label6: TLabel;
    dsPersonType: TDataSource;
    procedure FormCreate(Sender: TObject);
  private
    FAddrData: TAddresses;
    procedure SetAddrData(const Value: TAddresses);
  protected
    function ValidateForm: boolean; override;
  public
    property AddressData: TAddresses read FAddrData write SetAddrData;
  end;

function ExecAddressForm(AddressData: TAddresses): boolean;

implementation

uses JvJCLUtils, RDBUtils, ExHandler, PmConfigManager;

{$R *.dfm}

function ExecAddressForm(AddressData: TAddresses): boolean;
var
  AddressForm: TAddressForm;
begin
  Application.CreateForm(TAddressForm, AddressForm);
  try
    AddressForm.AddressData := AddressData;
    Result := AddressForm.ShowModal = mrOk;
  finally
    FreeAndNil(AddressForm);
  end;
end;

procedure TAddressForm.FormCreate(Sender: TObject);
begin
  dsPersonType.DataSet := TConfigManager.Instance.StandardDics.dePersonType.DicItems;
end;

procedure TAddressForm.SetAddrData(const Value: TAddresses);
begin
  FAddrData := Value;
  AddressDataSource.DataSet := FAddrData.DataSet;
end;

function TAddressForm.ValidateForm: boolean;
begin
  ActiveControl := btOk;
  Result := Trim(NvlString(FAddrData.Address)) <> '';
  if not Result then
  begin
    ActiveControl := edAddr;
    ExceptionHandler.Raise_('Пожалуйста, укажите адрес');
  end;
end;

end.
