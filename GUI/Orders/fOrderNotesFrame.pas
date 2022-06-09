unit fOrderNotesFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, GridsEh, DBGridEh, MyDBGridEh, Mask, DBCtrls,
  DB, JvJCLUtils,

  CalcUtils, PmOrder, PmOrderNotes, MemTableDataEh, DataDriverEh, MemTableEh,
  DBGridEhGrouping;

type
  TOrderNotesFrame = class(TFrame)
    Label9: TLabel;
    dgNotes: TMyDBGridEh;
    btAddNote: TBitBtn;
    btEditNote: TBitBtn;
    btDeleteNote: TBitBtn;
    cbCallCustomer: TDBCheckBox;
    cbHaveLayout: TDBCheckBox;
    cbHavePattern: TDBCheckBox;
    cbSignProof: TDBCheckBox;
    cbSignManager: TDBCheckBox;
    Label5: TLabel;
    Label6: TLabel;
    edCustomerPhone: TDBEdit;
    edProductFormat: TDBEdit;
    edProductPages: TDBEdit;
    cbIncludeCover: TDBCheckBox;
    cbHaveProof: TDBCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    mtNotes: TMemTableEh;
    ddNotes: TDataSetDriverEh;
    dsNotes: TDataSource;
    procedure btAddNoteClick(Sender: TObject);
    procedure btEditNoteClick(Sender: TObject);
    procedure btDeleteNoteClick(Sender: TObject);
    procedure dgNotesGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
  private
    FOnAddNote: TNotifyEvent;
    FOnEditNote: TIntNotifyEvent;
    FOnDeleteNote: TIntNotifyEvent;
    FOrder: TOrder;
    FReadOnly: boolean;
    procedure SetOrder(Value: TOrder);
    procedure SetReadOnly(Value: boolean);
    procedure DoUpdateRowHeight;
    procedure UserNameGetText(Sender: TField; var Text: String; DisplayText: Boolean);
  public
    //class procedure UpdateRowHeight(_OrderNotes: TOrderNotes; NotesGrid: TMyDbGridEh);
    property Order: TOrder read FOrder write SetOrder;
    property ReadOnly: boolean read FReadOnly write SetReadOnly;
    property OnAddNote: TNotifyEvent read FOnAddNote write FOnAddNote;
    property OnEditNote: TIntNotifyEvent read FOnEditNote write FOnEditNote;
    property OnDeleteNote: TIntNotifyEvent read FOnDeleteNote write FOnDeleteNote;
  end;

implementation

uses EnPaint, PmAccessManager, RDBUtils;

{$R *.dfm}

procedure TOrderNotesFrame.btAddNoteClick(Sender: TObject);
begin
  FOnAddNote(nil);
  DoUpdateRowHeight;
end;

procedure TOrderNotesFrame.btDeleteNoteClick(Sender: TObject);
begin
  FOnDeleteNote(NvlInteger(mtNotes[FOrder.Notes.KeyField]));
  DoUpdateRowHeight;
end;

procedure TOrderNotesFrame.btEditNoteClick(Sender: TObject);
begin
  FOnEditNote(NvlInteger(mtNotes[FOrder.Notes.KeyField]));
  DoUpdateRowHeight;
end;

procedure TOrderNotesFrame.dgNotesGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if not FOrder.Notes.IsEmpty then
    if FOrder.Notes.UseTech then
      Background := clInfoBk;
end;

procedure TOrderNotesFrame.SetOrder(Value: TOrder);
begin
  FOrder := Value;
  //dgNotes.DataSource := Order.Notes.DataSource;
  cbCallCustomer.DataSource := Order.DataSource;
  edCustomerPhone.DataSource := Order.DataSource;
  cbHaveLayout.DataSource := Order.DataSource;
  cbHavePattern.DataSource := Order.DataSource;
  cbSignManager.DataSource := Order.DataSource;
  cbSignProof.DataSource := Order.DataSource;
  cbHaveProof.DataSource := Order.DataSource;
  cbIncludeCover.DataSource := Order.DataSource;
  edProductFormat.DataSource := Order.DataSource;
  edProductPages.DataSource := Order.DataSource;

  dgNotes.OnDrawColumnCell := EnablePainter.DrawCheckBox;
  dgNotes.FieldColumns['Note'].WordWrap := false;

  ddNotes.ProviderDataSet := Order.Notes.DataSet;
  //Order.Notes.CopyFieldDefs(mtNotes);
  //if mtNotes.Active then
  dgNotes.DataSource := dsNotes;

  DoUpdateRowHeight;
end;

procedure TOrderNotesFrame.DoUpdateRowHeight;
begin
  if (Order.Notes.DataSet.State in [dsInsert, dsEdit]) then
    Order.Notes.DataSet.Post;
  ddNotes.ProviderDataSet := nil;
  mtNotes.Active := false;
  ddNotes.ProviderDataSet := Order.Notes.DataSet;
  mtNotes.Active := true;
  mtNotes.Locate(FOrder.Notes.KeyField, FOrder.Notes.KeyValue, []);
  mtNotes.FieldByName(TOrderNotes.F_UserName).OnGetText := UserNameGetText;
  //UpdateRowHeight(FOrder.Notes, dgNotes);
end;

procedure TOrderNotesFrame.UserNameGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if (AccessManager.Users <> nil) and not Sender.IsNull then
  begin
    Text := AccessManager.FormatUserName(NvlString(Sender.Value));
  end;
end;

{class procedure TOrderNotesFrame.UpdateRowHeight(_OrderNotes: TOrderNotes; NotesGrid: TMyDbGridEh);
var
  ds: TDataSet;
  txt: string;
  c, MaxC: integer;
begin
  ds := _OrderNotes.DataSet;
  if ds.IsEmpty then
    NotesGrid.RowLines := 1
  else
  begin
    ds.DisableControls;
    try
      MaxC := 0;
      ds.First;
      while not ds.Eof do
      begin
        txt := _OrderNotes.NoteText;
        c := CountOfChar(#13, txt);
        if c > MaxC then MaxC := c;
        ds.Next;
      end;
      NotesGrid.RowLines := MaxC + 1;
    finally
      ds.EnableControls;
    end;
  end;
end;}

procedure TOrderNotesFrame.SetReadOnly(Value: boolean);
begin
  FReadOnly := Value;
  btEditNote.Enabled := not FReadOnly;
  btAddNote.Enabled := not FReadOnly;
  btDeleteNote.Enabled := not FReadOnly;
end;

end.
