unit fEditJobComment;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvExControls, JvComponent, JvEditorCommon, JvEditor, StdCtrls,
  ComCtrls,

  fOrderNotesFrame, PmOrderNotes, PmOrder, ExtCtrls;

type
  TEditJobCommentForm = class(TForm)
    btSave: TButton;
    btCancel: TButton;
    pcComments: TPageControl;
    tsJobComment: TTabSheet;
    tsOrderComment: TTabSheet;
    paAlert: TPanel;
    cbJobAlert: TCheckBox;
    TextEditor: TMemo;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cbJobAlertClick(Sender: TObject);
  private
    FOrder: TOrder;
    FNotesFrame: TOrderNotesFrame;
    WasActive: boolean;
    procedure DoOnAddNote(Sender: TObject);
    procedure DoOnEditNote(OrderNoteID: integer);
    procedure DoOnDeleteNote(OrderNoteID: integer);
    procedure SetOrder(Value: TOrder);
    procedure EditNote;
  public
    RequireText: boolean;
    property Order: TOrder read FOrder write SetOrder;
  end;

function ExecEditJobComment(Order: TOrder; Caption: string; var _Text: string;
  var _Alert: boolean; RequireText: boolean = false): boolean;

implementation

uses RDialogs, PmAccessManager, PmOrderNoteForm, PmPlan;

{$R *.dfm}

function ExecEditJobComment(Order: TOrder; Caption: string; var _Text: string;
  var _Alert: boolean; RequireText: boolean = false): boolean;
var
  EForm: TEditJobCommentForm;
begin
  EForm := TEditJobCommentForm.Create(nil);
  try
    EForm.Caption := Caption;
    EForm.TextEditor.Lines.Text := _Text;
    EForm.cbJobAlert.Checked := _Alert;
    EForm.RequireText := RequireText;
    EForm.Order := Order;
    Result := EForm.ShowModal = mrOk;
    if Result then
    begin
      _Text := Trim(EForm.TextEditor.Lines.Text);
      _Alert := EForm.cbJobAlert.Checked;
    end;
  finally
    EForm.Free;
  end;
end;

procedure TEditJobCommentForm.FormActivate(Sender: TObject);
begin
  if not WasActive then
  begin
    WasActive := false;
    // сразу переключаем на комментарии к заказу, если они есть, а к работе ничего нет
    if (TextEditor.Lines.Text = '') and (Order <> nil) and not Order.Notes.IsEmpty then
      pcComments.ActivePage := tsOrderComment;

    cbJobAlertClick(nil);
  end;
end;

procedure TEditJobCommentForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  TextEditor.Lines.Text := Trim(TextEditor.Lines.Text);
  CanClose := not RequireText or (ModalResult <> mrOk) or (TextEditor.Lines.Text <> '')
    or not cbJobAlert.Checked;
  if not CanClose then
    RusMessageDlg('Пожалуйста, введите описание', mtError, [mbOk], 0)
  else
  begin
    CanClose := (ModalResult <> mrOk) or (Length(TextEditor.Lines.Text) < TPlan.JobCommentSize);
    if not CanClose then
    begin
      if RusMessageDlg('Слишком длинный текст. Укоротить?', mtError, mbYesNoCancel, 0) = mrYes then
      begin
        TextEditor.Lines.Text := Copy(TextEditor.Lines.Text, 1, 500);
        CanClose := true;
      end;
    end;
  end;
end;

procedure TEditJobCommentForm.FormCreate(Sender: TObject);
begin
  FNotesFrame := TOrderNotesFrame.Create(Self);
  FNotesFrame.Parent := tsOrderComment;
  FNotesFrame.OnAddNote := DoOnAddNote;
  FNotesFrame.OnEditNote := DoOnEditNote;
  FNotesFrame.OnDeleteNote := DoOnDeleteNote;
  FNotesFrame.ReadOnly := true;
end;

procedure TEditJobCommentForm.cbJobAlertClick(Sender: TObject);
begin
  if cbJobAlert.Checked then
  begin
    cbJobAlert.Font.Color := clMaroon;
    cbJobAlert.Font.Style := [fsBold];
  end
  else
  begin
    cbJobAlert.Font.Color := clWindowText;
    cbJobAlert.Font.Style := [];
  end;
end;

procedure TEditJobCommentForm.DoOnAddNote(Sender: TObject);
begin
  Order.Notes.Append;
  Order.Notes.UserName := AccessManager.CurUser.Login;
  EditNote;
end;

procedure TEditJobCommentForm.DoOnEditNote(OrderNoteID: integer);
begin
  if Order.Notes.Locate(OrderNoteID) then
    EditNote;
end;

procedure TEditJobCommentForm.DoOnDeleteNote(OrderNoteID: integer);
begin
  if not Order.Notes.IsEmpty and Order.Notes.Locate(OrderNoteID)
    and SameText(Order.Notes.UserName, AccessManager.CurUser.Login) then
    Order.Notes.DataSet.Delete;
end;

procedure TEditJobCommentForm.EditNote;
var
  _ReadOnly: boolean;
begin
  _ReadOnly := true;//not SameText(Order.Notes.UserName, AccessManager.CurUser.Login);
  if not ExecOrderNoteForm(Order.Notes, _ReadOnly) or _ReadOnly then
    Order.Notes.DataSet.Cancel;
end;

procedure TEditJobCommentForm.SetOrder(Value: TOrder);
begin
  FOrder := Value;
  if FOrder = nil then
    tsOrderComment.TabVisible := false
  else
  begin
    tsOrderComment.TabVisible := true;
    FNotesFrame.Order := FOrder;
  end;
end;

end.
