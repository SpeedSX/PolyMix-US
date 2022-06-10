unit PmRelatedContragentForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponentBase, JvFormPlacement, StdCtrls,

  fBaseEditForm, PmContragent, DB, ExtCtrls, GridsEh, DBGridEh, MyDBGridEh,
  DBGridEhGrouping, Mask, DBCtrls;

type
  TRelatedContragentForm = class(TBaseEditForm)
    RelatedDataSource: TDataSource;
    Label1: TLabel;
    edName: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label5: TLabel;
    DBEdit5: TDBEdit;
  private
    FContragents: TRelated;
    procedure SetContragents(const Value: TRelated);
  protected
    function ValidateForm: boolean; override;
  public
    property Contragents: TRelated read FContragents write SetContragents;
  end;

var
  RelatedContragentForm: TRelatedContragentForm;

function ExecRelatedContragentForm(_RelatedContragents: TRelated): boolean;

implementation

{$R *.dfm}

uses RDBUtils, ExHandler;

function ExecRelatedContragentForm(_RelatedContragents: TRelated): boolean;
var
  RelatedContragentForm: TRelatedContragentForm;
begin
  Application.CreateForm(TRelatedContragentForm, RelatedContragentForm);
  try
    RelatedContragentForm.Contragents := _RelatedContragents;
    Result := RelatedContragentForm.ShowModal = mrOk;
  finally
    FreeAndNil(RelatedContragentForm);
  end;
end;

procedure TRelatedContragentForm.SetContragents(const Value: TRelated);
begin
  FContragents := Value;
  RelatedDataSource.DataSet := FContragents.DataSet;
end;

function TRelatedContragentForm.ValidateForm: boolean;
begin
  ActiveControl := btOk;
  Result := Trim(NvlString(FContragents.ContragentName)) <> '';
  if not Result then
  begin
    ActiveControl := edName;
    ExceptionHandler.Raise_('Укажите имя');
  end;
end;

end.
