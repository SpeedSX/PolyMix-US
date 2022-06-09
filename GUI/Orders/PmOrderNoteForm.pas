unit PmOrderNoteForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseEditForm, JvComponentBase, JvFormPlacement, StdCtrls, DBCtrls,
  PmOrderNotes;

type
  TOrderNoteForm = class(TBaseEditForm)
    DBText1: TDBText;
    DBMemo1: TDBMemo;
    cbUseTech: TDBCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    DBText2: TDBText;
  private
    FNotes: TOrderNotes;
    FReadOnly: boolean;
    procedure SetNotes(Value: TOrderNotes);
    procedure SetReadOnly(Value: boolean);
  public
    property Notes: TOrderNotes read FNotes write SetNotes;
    property ReadOnly: boolean read FReadOnly write SetReadOnly;
  end;

function ExecOrderNoteForm(_Notes: TOrderNotes; _ReadOnly: boolean): boolean;

implementation

{$R *.dfm}

function ExecOrderNoteForm(_Notes: TOrderNotes; _ReadOnly: boolean): boolean;
var
  OrderNoteForm: TOrderNoteForm;
begin
  OrderNoteForm := TOrderNoteForm.Create(nil);
  try
    OrderNoteForm.Notes := _Notes;
    OrderNoteForm.ReadOnly := _ReadOnly;
    Result := OrderNoteForm.ShowModal = mrOk;
  finally
    OrderNoteForm.Free;
  end;
end;

procedure TOrderNoteForm.SetNotes(Value: TOrderNotes);
begin
  FNotes := Value;
  DbText1.DataSource := FNotes.DataSource;
  DbMemo1.DataSource := FNotes.DataSource;
  cbUseTech.DataSource := FNotes.DataSource;
  DbText2.DataSource := FNotes.DataSource;
end;

procedure TOrderNoteForm.SetReadOnly(Value: boolean);
begin
  FReadOnly := Value;
  DbMemo1.ReadOnly := FReadOnly;
end;

end.
