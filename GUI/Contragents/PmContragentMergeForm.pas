unit PmContragentMergeForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBGridEh, Mask, DBCtrlsEh, DBLookupEh, fBaseEditForm,
  PmContragent, DB, JvComponentBase, JvFormPlacement;

type
  TContragentMergeForm = class(TBaseEditForm)
    Label1: TLabel;
    comboSource: TDBLookupComboboxEh;
    Label2: TLabel;
    comboDest: TDBLookupComboboxEh;
    cbMergeFields: TCheckBox;
    cbMergePersons: TCheckBox;
    ListSource: TDataSource;
  private
    { Private declarations }
  public
    function ValidateForm: boolean; override;
  end;

// ¬озвращает 0 если не был выбран второй контрагент
function ExecContragentMergeForm(Contragents: TContragents; SourceID: integer;
  var MergeFields, MergePersons: boolean): integer;

implementation

{$R *.dfm}

function ExecContragentMergeForm(Contragents: TContragents; SourceID: integer;
  var MergeFields, MergePersons: boolean): integer;
var
  ContragentMergeForm: TContragentMergeForm;
begin
  ContragentMergeForm := TContragentMergeForm.Create(nil);
  try
    ContragentMergeForm.ListSource.DataSet := Contragents.DataSet;
    ContragentMergeForm.comboSource.KeyValue := SourceID;
    if ContragentMergeForm.ShowModal = mrOk then
    begin
      Result := ContragentMergeForm.comboDest.KeyValue;
      MergeFields := ContragentMergeForm.cbMergeFields.Checked;
      MergePersons := ContragentMergeForm.cbMergePersons.Checked;
    end else
      Result := 0;
  finally
    FreeAndNil(ContragentMergeForm);
  end;
end;

function TContragentMergeForm.ValidateForm: boolean;
begin
  Result := comboDest.KeyValue <> comboSource.KeyValue;
  if not Result then
    raise Exception.Create(' онтрагенты не могут совпадать!');
end;

end.
