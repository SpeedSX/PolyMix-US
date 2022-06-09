unit PmRelatedContragentForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponentBase, JvFormPlacement, StdCtrls,

  fBaseEditForm, PmContragent, DB, ExtCtrls, GridsEh, DBGridEh, MyDBGridEh;

type
  TRelatedContragentForm = class(TBaseEditForm)
    RelatedDataSource: TDataSource;
    dgCustomers: TMyDBGridEh;
    lbFilt: TLabel;
    Bevel1: TBevel;
    Label1: TLabel;
    edName: TEdit;
    procedure edNameChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FContragents: TContragents;
    procedure SetContragents(const Value: TContragents);
    procedure SetFilter(s: string);
  protected
    function ValidateForm: boolean; override;
  public
    property Contragents: TContragents read FContragents write SetContragents;
  end;

var
  RelatedContragentForm: TRelatedContragentForm;

function ExecRelatedContragentForm(_Contragents: TContragents;
  var ContragentKey: integer): boolean;

implementation

{$R *.dfm}

function ExecRelatedContragentForm(_Contragents: TContragents;
  var ContragentKey: integer): boolean;
var
  RelatedContragentForm: TRelatedContragentForm;
begin
  Application.CreateForm(TRelatedContragentForm, RelatedContragentForm);
  try
    RelatedContragentForm.Contragents := _Contragents;
    Result := RelatedContragentForm.ShowModal = mrOk;
    if Result then
      ContragentKey := _Contragents.KeyValue;
  finally
    FreeAndNil(RelatedContragentForm);
  end;
end;

procedure TRelatedContragentForm.edNameChange(Sender: TObject);
var
  s: string;
begin
  if edName.Text <> '' then
    s := 'Name=''' + edName.Text + '*'''
  else
    s := '';
  SetFilter(s);
end;

procedure TRelatedContragentForm.SetFilter(s: string);
var
  s1: string;
begin
  s1 := 'ParentID is null';
  if s = '' then
    FContragents.DataSet.Filter := s1
  else
    FContragents.DataSet.Filter := s1 + ' and (' + s + ')';
  FContragents.DataSet.Filtered := true;
  FContragents.DataSet.FilterOptions := [foCaseInsensitive];
end;

procedure TRelatedContragentForm.FormActivate(Sender: TObject);
begin
  inherited;
  ActiveControl := edName;
end;

procedure TRelatedContragentForm.SetContragents(const Value: TContragents);
begin
  FContragents := Value;
  RelatedDataSource.DataSet := FContragents.DataSet;
  SetFilter('');
end;

function TRelatedContragentForm.ValidateForm: boolean;
begin
  Result := not VarIsNull(FContragents.KeyValue);
end;

end.
