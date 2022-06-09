unit fBaseEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvComponentBase, JvFormPlacement;

type
  TBaseEditForm = class(TForm)
    btOk: TButton;
    btCancel: TButton;
    FormStorage: TJvFormStorage;
    procedure FormCloseQuery(Sender: TObject; var _CanClose: Boolean);
  private
    { Private declarations }
  protected
    function ValidateForm: boolean; virtual;
    function CanClose: boolean; virtual;
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

uses JvJVCLUtils, CalcSettings;

{$R *.dfm}

constructor TBaseEditForm.Create;
begin
  inherited Create(Owner);
  FormStorage.AppStorage := TSettingsManager.Instance.Storage;
  if BorderStyle = bsSizeable then
    FormStorage.Options := FormStorage.Options + [fpSize];
end;

procedure TBaseEditForm.FormCloseQuery(Sender: TObject; var _CanClose: Boolean);
begin
  _CanClose := CanClose;
end;

function TBaseEditForm.CanClose: boolean;
begin
  if ModalResult = mrOk then
  begin
    Result := ValidateForm;
  end
  else
    Result := true;
end;

function TBaseEditForm.ValidateForm: boolean;
begin
  Result := true;
end;

end.
