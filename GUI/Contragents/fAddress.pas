unit fAddress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PmContragent, DB, Buttons, Mask, DBCtrls, JvExMask,
  JvToolEdit, fBaseEditForm, JvComponentBase, JvFormPlacement;

type
  TAddressForm = class(TBaseEditForm)
    AddressDataSource: TDataSource;
    edAddr: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    edNote: TDBEdit;
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

uses JvJCLUtils, RDBUtils, ExHandler;

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
