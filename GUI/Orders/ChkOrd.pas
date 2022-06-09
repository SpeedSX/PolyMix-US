unit ChkOrd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Jvgrids, ComCtrls, StdCtrls, ExtCtrls, RDialogs, JvExGrids;

type
  TChkOrdForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btOk: TButton;
    btCancel: TButton;
    PageControl1: TPageControl;
    tsMsgs: TTabSheet;
    dgMsgs: TJvDrawGrid;
    procedure FormActivate(Sender: TObject);
    procedure dgMsgsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    IconPics: array[TMsgDlgType] of TIcon;
    function CheckForErrors: boolean;
  public
    ShowCancel: boolean;
    Msgs: TCollection;
  end;

  TCheckMsg = class(TCollectionItem)
  public
    SrvName: string;
    Msg: string;
    MsgType: TMsgDlgType;
    RecNo: integer;
  end;

var
  ChkOrdForm: TChkOrdForm;

function ExecCheckOrdForm(ShowCancel: boolean; Msgs: TCollection): boolean;

implementation

{$R *.DFM}

// Возвращает true, если нажата ОК, false - Cancel
function ExecCheckOrdForm(ShowCancel: boolean; Msgs: TCollection): boolean;
begin
  Application.CreateForm(TChkOrdForm, ChkOrdForm);
  try
    ChkOrdForm.ShowCancel := ShowCancel;
    ChkOrdForm.Msgs := Msgs;
    Result := ChkOrdForm.ShowModal = mrOk;
  finally
    FreeAndNil(ChkOrdForm);
  end;
end;

function TChkOrdForm.CheckForErrors: boolean;
var i: integer;
begin
  Result := false;
  for i := 0 to Pred(Msgs.Count) do
    if (Msgs.Items[i] as TCheckMsg).MsgType = mtError then begin
      Result := true;
      break;
    end;
end;

procedure TChkOrdForm.FormActivate(Sender: TObject);
begin
  dgMsgs.RowCount := Msgs.Count;
  // Обычно в режиме автопроверки видны кнопки Сохранить и Вернуться...,
  // а в режиме принудительной проверки - только Закрыть (=ОК).
  if not ShowCancel then begin
    btCancel.Visible := false;
    btOk.Width := 161;
    btOk.Caption := 'Закрыть';
  end else begin
    btOk.Caption := 'Сохранить';
  end;
  btOk.Enabled := not CheckForErrors;
  tsMsgs.Caption := IntToStr(Msgs.Count) + ' сообщений';
end;

procedure TChkOrdForm.dgMsgsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  Ico: TGraphic;
begin
  if (Msgs = nil) or (Msgs.Count = 0) then Exit;
  if ACol = 0 then begin
    Ico := IconPics[(Msgs.Items[ARow] as TCheckMsg).MsgType];
    if Ico <> nil then
      dgMsgs.DrawPicture(Rect, Ico);
  end else if ACol = 1 then
    dgMsgs.DrawMultiline(Rect, (Msgs.Items[ARow] as TCheckMsg).SrvName + ' (' +
      IntToStr((Msgs.Items[ARow] as TCheckMsg).RecNo) + ')', taLeftJustify)
  else if ACol = 2 then
    dgMsgs.DrawMultiline(Rect, (Msgs.Items[ARow] as TCheckMsg).Msg, taLeftJustify);
end;

procedure TChkOrdForm.FormCreate(Sender: TObject);
var
  IconID: PChar;
  i: integer;
begin
  for i := Ord(low(IconPics)) to Ord(High(IconPics)) do begin
    IconID := IconIDs[TMsgDlgType(i)];
    if IconID <> nil then begin
      IconPics[TMsgDlgType(i)] := TIcon.Create;
      IconPics[TMsgDlgType(i)].Handle := LoadIcon(0, IconID);
    end;
  end;
end;

procedure TChkOrdForm.FormDestroy(Sender: TObject);
var i: integer;
begin
  for i := Ord(Low(IconPics)) to Ord(High(IconPics)) do
    IconPics[TMsgDlgType(i)].Free
end;

end.
