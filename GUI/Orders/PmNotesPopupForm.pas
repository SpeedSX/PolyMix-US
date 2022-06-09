unit PmNotesPopupForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, MyDBGridEh,

  CalcUtils, PmOrderNotes, MemTableDataEh, Db, DataDriverEh, MemTableEh,
  DBGridEhGrouping;

type
  TNotesPopupForm = class(TForm)
    dgNotes: TMyDBGridEh;
    mtNotes: TMemTableEh;
    ddNotes: TDataSetDriverEh;
    dsNotes: TDataSource;
    procedure dgNotesDblClick(Sender: TObject);
    procedure dgNotesGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
  private
    FOrderNotes: TOrderNotes;
    FOnNoteClick: TIntNotifyEvent;
    procedure SetOrderNotes(Value: TOrderNotes);
    procedure CMMouseLeave(var Msg: TMessage); message CM_MouseLeave;
    procedure UserNameGetText(Sender: TField; var Text: String; DisplayText: Boolean);
  public
    property OrderNotes: TOrderNotes read FOrderNotes write SetOrderNotes;
    property OnNoteClick: TIntNotifyEvent read FOnNoteClick write FOnNoteClick;
  end;

procedure ShowNotesPopupForm(OrderNotes: TOrderNotes; _OnNoteClick: TIntNotifyEvent);

implementation

{$R *.dfm}

uses fOrderNotesFrame, PmAccessManager, RDBUtils;

var
  NotesPopupForm: TNotesPopupForm;

procedure ShowNotesPopupForm(OrderNotes: TOrderNotes; _OnNoteClick: TIntNotifyEvent);
var
  {I, }RH: Integer;
begin
  if NotesPopupForm = nil then
    NotesPopupForm := TNotesPopupForm.Create(nil);
  NotesPopupForm.Left := Mouse.CursorPos.X - 50;
  NotesPopupForm.Top := Mouse.CursorPos.Y - 5;

  NotesPopupForm.OrderNotes := OrderNotes;

  //TOrderNotesFrame.UpdateRowHeight(OrderNotes, NotesPopupForm.dgNotes);
  //NotesPopupForm.dgNotes.FieldColumns['Note'].WordWrap := false;
  {RH := 15 * NotesPopupForm.dgNotes.RowLines;
  if OrderNotes.DataSet.RecordCount < 6 then
    NotesPopupForm.Height := RH * OrderNotes.DataSet.RecordCount
  else
    NotesPopupForm.Height := RH * 6;
  if NotesPopupForm.Top + NotesPopupForm.Height > Screen.Height then
    NotesPopupForm.Top := Screen.Height - NotesPopupForm.Height - 55;
  if NotesPopupForm.Left + NotesPopupForm.Width > Screen.Width then
    NotesPopupForm.Left := Screen.Width - NotesPopupForm.Width - 20;
}
  NotesPopupForm.OnNoteClick := _OnNoteClick;
  if NotesPopupForm.Visible then
    NotesPopupForm.Hide; 
  //if not NotesPopupForm.Visible then
  //begin
    //NotesPopupForm.AlphaBlend := true;
    //NotesPopupForm.AlphaBlendValue := 0;
    NotesPopupForm.Show;
    {for I := 0 to 127 do
    begin
      Application.ProcessMessages;
      if NotesPopupForm = nil then break;
      NotesPopupForm.AlphaBlendValue := i * 2;
    end;
    if NotesPopupForm <> nil then
      NotesPopupForm.AlphaBlend := false;}
  //end;
end;

procedure TNotesPopupForm.CMMouseLeave(var Msg: TMessage);
begin
  Close;
  NotesPopupForm := nil;
end;

procedure TNotesPopupForm.dgNotesDblClick(Sender: TObject);
begin
  Close;
  NotesPopupForm := nil;
  FOnNoteClick(NvlInteger(mtNotes[FOrderNotes.KeyField])); // передаем ключ записи
end;

procedure TNotesPopupForm.dgNotesGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
{  if not FOrderNotes.IsEmpty then
    if FOrderNotes.UseTech then
      Background := clInfoBk;}
end;

procedure TNotesPopupForm.FormShow(Sender: TObject);
var
  I, TotalHeight: Integer;
begin
  // считаем общую высоту строк
  {mtNotes.DisableControls;
  try
    while not mtNotes.Eof do
    begin
      mtNotes
      mtNotes.Next;
    end;
  finally
    mtNotes.EnableControls;
  end;}
  TotalHeight := 0;
  for I := 0 to mtNotes.RecordCount - 1 do
  begin
    if TotalHeight + dgNotes.RowHeights[I] + 2 > Screen.Height then
      break;
    TotalHeight := TotalHeight + dgNotes.RowHeights[I] + 2;
  end;
  Height := TotalHeight;
  if Top + Height > Screen.Height then
    Top := Screen.Height - Height - 55;
  if Left + Width > Screen.Width then
    Left := Screen.Width - Width - 20;
end;

procedure TNotesPopupForm.SetOrderNotes(Value: TOrderNotes);
begin
  FOrderNotes := Value;
  ddNotes.ProviderDataSet := FOrderNotes.DataSet;
  mtNotes.Open;
  mtNotes.FieldByName(TOrderNotes.F_UserName).OnGetText := UserNameGetText;
  //dgNotes.DataSource := FOrderNotes.DataSource;
end;

procedure TNotesPopupForm.UserNameGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if (AccessManager.Users <> nil) and not Sender.IsNull then
  begin
    Text := AccessManager.FormatUserName(NvlString(Sender.Value));
  end;
end;

end.
