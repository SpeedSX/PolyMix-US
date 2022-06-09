unit PmSelectTemplate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseEditForm, JvComponentBase, JvFormPlacement, StdCtrls;

type
  TSelectTemplateForm = class(TBaseEditForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ExecSelectTemplateForm(var TemplateOrderID: integer): boolean;

implementation

{$R *.dfm}

function ExecSelectTemplateForm(var TemplateOrderID: integer): boolean;
var
  SelectTemplateForm: TSelectTemplateForm;
begin
  SelectTemplateForm := TSelectTemplateForm.Create(nil);
  try
    Result := SelectTemplateForm.ShowModal = mrOk;
  finally
    SelectTemplateForm.Free;
  end;
end;

end.
