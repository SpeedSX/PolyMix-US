unit fmTabDic;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, JvDBControls, StdCtrls, DBCtrls, DB, Menus,
  ExtCtrls, DBGridEh, MemTableDataEh,

  CalcUtils, MyDBGridEh, DicObj, PmUtils, GridsEh, DBGridEhGrouping;

type
  TfrTabDic = class(TFrame)
    Panel1: TPanel;
    dgDic: TMyDBGridEh;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    pmGraphic: TPopupMenu;
    miOpenBmp: TMenuItem;
    miSaveBmp: TMenuItem;
    miClearBmp: TMenuItem;
    Panel2: TPanel;
    DBCheckBox1: TDBCheckBox;
    Panel3: TPanel;
    sbDelValue: TSpeedButton;
    sbNewSubValue: TSpeedButton;
    dsDic: TDataSource;
    sbNewValue: TSpeedButton;
    sbNewUpValue: TSpeedButton;
    procedure sbNewValueClick(Sender: TObject);
    procedure sbDelValueClick(Sender: TObject);
    procedure dgDicGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dgDicDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure dgDicContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure miOpenBmpClick(Sender: TObject);
    procedure miSaveBmpClick(Sender: TObject);
    procedure miClearBmpClick(Sender: TObject);
    procedure sbNewSubValueClick(Sender: TObject);
    procedure sbNewUpValueClick(Sender: TObject);
    procedure dgDicCellClick(Column: TColumnEh);
  private
    FDic: TDictionary;
    procedure SetupElemGrid(de: TDictionary);
    procedure SetTreeEnabled(TreeNode: TMemRecViewEh; Enabled: boolean);
  public
    property Dictionary: TDictionary read FDic write SetupElemGrid;
  end;

implementation

uses DicUtils, RDialogs, DBTables, JvJVCLUtils, EnPaint;

{$R *.DFM}

procedure TfrTabDic.sbNewSubValueClick(Sender: TObject);
var
  CurCode: integer;
begin
  if FDic.DicItems.Active and not FDic.DicItems.IsEmpty then
  begin
    CurCode := FDic.CurrentCode;
    FDic.DicItems.Append;
    FDic.CurrentParentCode := CurCode;
    FDic.DicItems.Post;
    dgDic.FieldColumns[F_DicItemVisible].OptimizeWidth; // корректируем ширину столбца с кодом
  end;
end;

procedure TfrTabDic.sbNewUpValueClick(Sender: TObject);
var
  CurCode, CurParentCode, NewCode: integer;
  OldFiltered: boolean;
  OldFilter, Filter: string;
begin
  if FDic.DicItems.Active and not FDic.DicItems.IsEmpty then
  begin
    CurCode := FDic.CurrentCode;
    CurParentCode := FDic.CurrentParentCode;
    FDic.DicItems.Append;
    FDic.CurrentParentCode := CurParentCode;
    NewCode := FDic.CurrentCode;
    FDic.DicItems.Post;
    // Переместить под нового родителя все элементы, которые были на этом уровне
    OldFilter := FDic.DicItems.Filter;
    OldFiltered := FDic.DicItems.Filtered;
    if CurParentCode = 0 then
      Filter := '(ParentCode = ' + IntToStr(CurParentCode) + ' or ParentCode is null)'
    else
      Filter := '(ParentCode = ' + IntToStr(CurParentCode) + ')';
    Filter := Filter + ' and (Code <> ' + IntToStr(NewCode) + ')';
    FDic.DicItems.Filter := Filter;
    FDic.DicItems.Filtered := true;
    try
      while not FDic.DicItems.Eof do
      begin
        FDic.CurrentParentCode := NewCode;
        FDic.DicItems.Next;
      end;
    finally
      FDic.DicItems.Filtered := OldFiltered;
      FDic.DicItems.Filter := OldFilter;
    end;
    FDic.LocateCode(NewCode);
    dgDic.FieldColumns[F_DicItemVisible].OptimizeWidth; // корректируем ширину столбца с кодом
  end;
end;

procedure TfrTabDic.sbNewValueClick(Sender: TObject);
var
  CurCode: integer;
begin
  // Если стоим на дочернем, то запись добавляется на тот же уровень
  if not FDic.DicItems.IsEmpty and (FDic.CurrentParentCode > 0) then
  begin
    CurCode := FDic.CurrentParentCode;
    FDic.DicItems.Append;
    FDic.CurrentParentCode := CurCode;
  end
  else
    FDic.DicItems.Append;
  FDic.DicItems.Post;
  dgDic.FieldColumns[F_DicItemVisible].OptimizeWidth; // корректируем ширину столбца с кодом
end;

procedure TfrTabDic.sbDelValueClick(Sender: TObject);
begin
  if FDic.DicItems.Active and not FDic.DicItems.IsEmpty and
    (RusMessageDlg('Удаление записи справочника может привести к потере' +
      #13'информации в расчетах и заказах. Рекомендуется сделать запись неактивной.' +
      #13'Вы уверены, что желаете удалить запись?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    FDic.DicItems.Delete;
end;

procedure TfrTabDic.SetupElemGrid(de: TDictionary);
begin
  FDic := de;
  sbDelValue.Enabled := not de.DicItems.IsEmpty and not de.DicItems.ReadOnly;
  sbNewValue.Enabled := not de.DicItems.ReadOnly;
  dsDic.DataSet := de.DicItems;
  de.DicItems.TreeList.Active := true;
  //de.DicItems.OnRecordsViewTreeNodeExpanded :=
  DicSetupGridColumns(de, dgDic);
  OptimizeColumns(dgDic);
end;

procedure TfrTabDic.dgDicGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  if not (gdSelected in State) and not (gdFocused in State) and (Column <> nil) then begin
    if CompareText(Column.FieldName, F_DicItemName) = 0 then Background := clInfoBk;
    //else if CompareText(Column.FieldName, F_DicItemCode) = 0 then Background := clBtnFace;
  end;
  DicGetCellParams(Column, AFont, Background, State);
end;

procedure TfrTabDic.dgDicDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
var
  Bmp: TBitmap;
begin
  if (Column.Field <> nil) and (Column.Field is TBlobField)
       and not Column.Field.IsNull then
  begin
    (Sender as TGridClass).Canvas.FillRect(Rect);
    Bmp := TBitmap.Create;
    try
      try
        Bmp.Assign(Column.Field);
        if (Bmp.Height = 16) then
          DrawBitmapTransparent((Sender as TGridClass).Canvas,
            (Rect.Right + Rect.Left - Bmp.Width) div 2 + 1,
            (Rect.Top + Rect.Bottom - Bmp.Height) div 2, Bmp, clOlive);
      except end;
    finally
      Bmp.Free;
    end;
  end
  else
    EnablePainter.DrawCheckBox(Sender, Rect, DataCol, Column, State);
end;

procedure TfrTabDic.SetTreeEnabled(TreeNode: TMemRecViewEh; Enabled: boolean);
var
  I: Integer;
  ChildNode: TMemRecViewEh;
begin
  if TreeNode.NodesCount > 0 then
  begin
    for I := 0 to TreeNode.NodesCount - 1 do
    begin
      ChildNode := TreeNode.NodeItems[i];
      ChildNode.Rec.Edit;
      ChildNode.Rec.DataValues[F_DicItemVisible, dvvValueEh] := Enabled;
      ChildNode.Rec.Post;
      SetTreeEnabled(ChildNode, Enabled);
    end;
  end;
end;

procedure TfrTabDic.dgDicCellClick(Column: TColumnEh);
var
  CurEn: boolean;
begin
  // рекурсивно включаем-выключаем все дочерние
  if Column.FieldName = F_DicItemVisible then
  begin
    FDic.CurrentEnabled := not FDic.CurrentEnabled;
    CurEn := FDic.CurrentEnabled;
    SetTreeEnabled(FDic.DicItems.TreeNode, CurEn);  // дочерние тоже включаем-выключаем
  end;
end;

procedure TfrTabDic.dgDicContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  try
    if dgDic.SelectedField is TBlobField then
    begin
      pmGraphic.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
      Handled := true;
    end;
  except end;
end;

procedure TfrTabDic.miOpenBmpClick(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    if not (dgDic.DataSource.DataSet.State in [dsInsert, dsEdit]) then
      dgDic.DataSource.DataSet.Edit;
    (dgDic.SelectedField as TBlobField).LoadFromFile(OpenDialog.FileName);
  end;
end;

procedure TfrTabDic.miSaveBmpClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    (dgDic.SelectedField as TBlobField).SaveToFile(SaveDialog.FileName);
end;

procedure TfrTabDic.miClearBmpClick(Sender: TObject);
begin
  if not (dgDic.DataSource.DataSet.State in [dsInsert, dsEdit]) then
    dgDic.DataSource.DataSet.Edit;
  (dgDic.SelectedField as TBlobField).Clear;
end;

end.
