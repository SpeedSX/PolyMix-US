unit EnPaint;

interface

uses Types, Graphics, DBGridEh, GridsEh, DB, JvJVCLUtils, PmUtils, CalcUtils;

type
  TEnablePainter = class(TObject)
  public
    procedure DrawCheckBox(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure DrawRedCheck(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
  end;

var
  EnablePainter: TEnablePainter;

implementation

//uses MemTableEh;

procedure TEnablePainter.DrawCheckBox(Sender: TObject; const Rect: TRect;
     DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
var
  db: TDataset;
  dg: TGridClass;
  bmp: TBitmap;
  bval: boolean;
  Background{, SavedColor}: TColor;
begin
  try
    dg := Sender as TGridClass;
    db := dg.DataSource.Dataset;
    //if not ((DataCol = 0) and (db is TMemTableEh) and (db as TMemTableEh).TreeList.Active) then
    //begin
      if Column.Field is TBooleanField then
      begin
        //dg.DefaultDrawColumnCell(Rect,Datacol,Column,State);
        try
          if Column.Field.IsNull then bmp := NoCheckBmp
          else begin
            bval := db[Column.FieldName];
            if bval then bmp := CheckedBmp
            else bmp := UncheckedBmp;
          end;
        except bmp := NoCheckBmp; end;

        {SavedColor := dg.Canvas.Brush.Color;
        try}
          if Assigned(dg.OnGetCellParams) then
          begin
            Background := Column.Color;
            dg.OnGetCellParams(Sender, Column, dg.Canvas.Font, Background, State);
            dg.Canvas.Brush.Color := Background;
          end
          else
            dg.Canvas.Brush.Color := Column.Color;  // не обращаем внимание на хайлайт
          dg.Canvas.FillRect(Rect);
        {finally
          dg.Canvas.Brush.Color := SavedColor;
        end;}
        DrawBitmapTransparent(dg.Canvas, (Rect.Left + Rect.Right - Bmp.Width) div 2,
          (Rect.Top + Rect.Bottom - Bmp.Height) div 2, Bmp, clOlive);
      end else
        dg.DefaultDrawColumnCell(Rect,Datacol,Column,State);
    //end else
    //  dg.DefaultDrawColumnCell(Rect,Datacol,Column,State);
  except
    dg.DefaultDrawColumnCell(Rect,Datacol,Column,State);
  end;
end;

procedure TEnablePainter.DrawRedCheck(Sender: TObject; const Rect: TRect;
     DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
var
  db: TDataset;
  dg: TGridClass;
  bmp: TBitmap;
begin
  try
    dg := Sender as TGridClass;
    db := dg.DataSource.Dataset;
    if Column.Field is TBooleanField then
    begin
      bmp := nil;
      try
        if not Column.Field.IsNull then
        begin
          if db[Column.FieldName] then bmp := RedCheckBmp;
        end;
      except
      end;
      //dg.Canvas.Brush.Color := Column.Color;  // не обращаем внимание на хайлайт
      //dg.Canvas.FillRect(Rect);
      (Sender as TDbGridEh).Canvas.FillRect(Rect);
      if bmp <> nil then
        DrawBitmapTransparent(dg.Canvas, (Rect.Left + Rect.Right - Bmp.Width) div 2,
          (Rect.Top + Rect.Bottom - Bmp.Height) div 2, Bmp, clOlive);
    end
    else
      dg.DefaultDrawColumnCell(Rect,Datacol,Column,State);
  except
    dg.DefaultDrawColumnCell(Rect,Datacol,Column,State);
  end;
end;

initialization
  EnablePainter := TEnablePainter.Create;

finalization
  EnablePainter.Free;

end.
 