unit fDocFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseFrame, ExtCtrls, GridsEh, DBGridEh, MyDBGridEh, Menus,
  DBGridEhGrouping;

type
  TDocumentsFrame = class(TBaseFrame)
    dgContract: TMyDBGridEh;
    ContrMenu: TPopupMenu;
    miOpen: TMenuItem;
    miSigned: TMenuItem;
    miComplete: TMenuItem;
    N1: TMenuItem;
    miContrProp: TMenuItem;
    miMakeContrTempl: TMenuItem;
    miDeleteDoc: TMenuItem;
    procedure dgContractDblClick(Sender: TObject);
    procedure dgContractDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure miDeleteDocClick(Sender: TObject);
    procedure miStateClick(Sender: TObject);
    procedure ContrMenuPopup(Sender: TObject);
    procedure dgContractEnter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DB;

procedure TDocumentsFrame.dgContractDblClick(Sender: TObject);
begin
{$IFNDEF NoDocs}
  EditDoc(dmd.cdContract, qiContract, false)
{$ENDIF}
end;

procedure TDocumentsFrame.dgContractDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
{$IFNDEF NoDocs}
var
  i: integer;
  Bmp: TBitmap;
{$ENDIF}
begin
{$IFNDEF NoDocs}
  if (Column.Field <> nil) and (Column.FieldName = 'State') then
  begin
    try
      i := Column.Field.Value;
    except i := Ord(csOpen) end;
    if (i < Ord(csOpen)) or (i > Ord(csComplete)) then Exit;
    Bmp := ContrClip.GraphicCell[i];
    (Sender as TOrderGridClass).Canvas.FillRect(Rect);
    DrawBitmapTransparent((Sender as TOrderGridClass).Canvas, (Rect.Left + Rect.Right - Bmp.Width) div 2,
      (Rect.Top + Rect.Bottom - Bmp.Height) div 2, Bmp, clOlive);
  end;
  // Рисует стрелочку, обозначающую сортирующее поле.
  // Принадлежность ячейки заголовку определяется ТУПО!!!!!!!!!!! По Rect.Top.
  // При к-л сдвигах может перестать работать !!!!!!!!!!!!
  if (Column.Field <> nil) and (Rect.Top < 20)
     and (CompareText(Column.Field.Origin, SortFields[qiContract]) = 0)
     and (SortDownBmp <> nil) then
  begin
       DrawBitmapTransparent((Sender as TOrderGridClass).Canvas, Rect.Right - SortDownBmp.Width - 4,
          1, SortDownBmp, clSilver);
  end;
{$ENDIF}
end;

procedure TDocumentsFrame.ContrMenuPopup(Sender: TObject);
{$IFNDEF NoDocs}
var
  En: boolean;
  St: integer;
{$ENDIF}
begin
{$IFNDEF NoDocs}
  En := dmd.cdContract.Active and not dmd.cdContract.IsEmpty
    and not VarIsNull(dmd.cdContract['State']);
  miOpen.Enabled := En;
  miSigned.Enabled := En;
  miComplete.Enabled := En;
  miMakeContrTempl.Enabled := En;
  miContrProp.Enabled := En;
  if not En then Exit;
  St := Ord(csOpen);
  try
    St := dmd.cdContract['State'];
  except end;
  miOpen.Checked := St = Ord(csOpen);
  miSigned.Checked := St = Ord(csSigned);
  miComplete.Checked := St = Ord(csComplete);
{$ENDIF}
end;

procedure TDocumentsFrame.miDeleteDocClick(Sender: TObject);
begin
{$IFNDEF NoDocs}
      if dmd.cdContract.Active and not dmd.cdContract.IsEmpty and
         (RusMessageDlg('Удалить документ вместе с дополнениями? Вы уверены?',
                 mtWarning, [mbYes, mbNo], 0) = mrYes) then begin
        ContrNum := dmd.cdContract['ID'];
        dmd.cdContract.Delete;
        ApplyTable(dmd.cdContract);
        ReloadQuery(qiContract);
        {$IFNDEF NoNet}
        if SendContr then SendNotif(ContractNotif);
        {$ENDIF}
        // Посылаем всем сообщение, что надо перечитать документы
      end;
{$ENDIF}
end;

procedure TDocumentsFrame.miStateClick(Sender: TObject);
begin
{$IFNDEF NoDocs}
  AllNotifIgnore := true;
  try
    dmd.cdContract.Edit;
    dmd.cdContract['State'] := (Sender as TMenuItem).Tag;
    ApplyTable(dmd.cdContract);
    {$IFNDEF NoNet}
    if SendContr then SendNotif(ContractNotif);
    {$ENDIF}
  finally
    AllNotifIgnore := false;
  end;
{$ENDIF}
end;

procedure TDocumentsFrame.dgContractEnter(Sender: TObject);
{var
  dq: TDataSet;}
begin
{  try
    dq := (Sender as TOrderGridClass).DataSource.DataSet;
    siCopy.Enabled := dq.Active and not dq.IsEmpty;
    siEdit.Enabled := siCopy.Enabled;
    siDelete.Enabled := siCopy.Enabled;
    siNew.Enabled := dq.Active;
    acPrint.Enabled := siCopy.Enabled;
    siPrint.DropDownMenu := nil;
    siPrint.Action := acPrint;
  except end;}
end;

end.
