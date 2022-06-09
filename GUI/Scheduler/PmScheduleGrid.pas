unit PmScheduleGrid;

interface

uses Classes, Types, Graphics, Forms, GridsEh, DBGridEh, MyDBGridEh,

 PmPlan;

type
  TScheduleGrid = class(TMyDBGridEh)
  private
    FWorkload: TWorkload;
  protected
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    //procedure MyDrawColumnCell(Sender: TObject; const Rect: TRect;
    //  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
  public
    constructor Create(_Owner: TComponent); override;
    property Workload: TWorkload read FWorkload write FWorkload;
  end;

implementation

uses RDBUtils;

constructor TScheduleGrid.Create(_Owner: TComponent);
begin
  inherited Create(_Owner);
end;

procedure TScheduleGrid.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
var
  FOldActiveRecord: Integer;
  Rect: TRect;
begin
  if (ACol = LeftCol) and not (gdFixed in AState) then
  begin
      //ARect := CellRect(IndicatorOffset, ARow);
      //inherited DrawCell(IndicatorOffset, ARow, ARect, AState)
    // рисуем первую колонку
    inherited DrawCell(ACol, ARow, ARect, AState);
  end
  else
  if (gdFixed in AState) then
    inherited DrawCell(ACol, ARow, ARect, AState)
  else
  if DataLink.Active and (DataLink.RecordCount > 0) and (ARow > 0) and (ACol > 0) then
  begin
    // не рисуем колонки в спец строке, кроме первой
    FOldActiveRecord := DataLink.ActiveRecord;
    if FOldActiveRecord >= 0 then
    begin
      DataLink.ActiveRecord := ARow - 1;
      if not FWorkload.IsShiftMarker {and (FWorkload.JobType < JobType_Special)} then
        inherited DrawCell(ACol, ARow, ARect, AState)
      else
      if not (gdSelected in AState) then
      begin
        ARect := CellRect(IndicatorOffset, ARow);
        inherited DrawCell(IndicatorOffset, ARow, ARect, AState);
      end;
      DataLink.ActiveRecord := FOldActiveRecord;
    end;
  end
  else
    inherited DrawCell(ACol, ARow, ARect, AState);

  if not (dghHighlightFocus in OptionsEh) and (gdSelected in AState) then
  begin
    Rect := CellRect(LeftCol, ARow);
    Rect.Right := Width - Rect.Left;
    //SavePen := TPen.Create;
    //try
      //SavePen.Assign(ACanvas.Pen);
      //ACanvas.Pen.Color := clGray;
      //ACanvas.Pen.Width := 1;
      //ACanvas.Pen.Style := psDash;
      //ACanvas.Rectangle(ARect);
      Canvas.Brush.Color := clHighlight;
      Canvas.FrameRect(Rect);
    //finally
    //  ACanvas.Pen.Assign(SavePen);
    //  SavePen.Free;
    //end;
  end;
end;

end.
