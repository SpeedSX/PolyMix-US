unit fStockWasteFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, MyDBGridEh, ActnList,

  fBaseFrame, fBaseFilter, PmStockWaste, PmEntity, DBGridEhGrouping;

type
  TStockWasteFrame = class(TBaseFrame)
    dgStockWaste: TMyDBGridEh;
    procedure dgStockWasteDblClick(Sender: TObject);
    procedure dgStockWasteDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
  private
    //FStockWaste: TStockWaste;
  protected
    function StockWaste: TStockWaste;
  public
    constructor Create(Owner: TComponent; _StockWaste: TEntity); override;
    procedure SaveSettings; override;
    procedure LoadSettings; override;
    function CreateFilterFrame: TBaseFilterFrame; override;
  end;

implementation

uses CalcSettings, PmOrder, CalcUtils, PmActions, fStockWasteFilterFrame,
  PmStockDocument, PmUtils;

{$R *.dfm}

constructor TStockWasteFrame.Create(Owner: TComponent; _StockWaste: TEntity);
begin
  inherited Create(Owner, _StockWaste{'StockWaste'});
  //FStockWaste := _StockWaste;

  dgStockWaste.DataSource := StockWaste.DataSource;

  FilterObject := StockWaste.Criteria;
  FilterFrame.Entity := StockWaste;
end;

procedure TStockWasteFrame.SaveSettings;
begin
  inherited;
  TSettingsManager.Instance.SaveGridLayout(dgStockWaste, 'StockWaste_StockWaste');
end;

procedure TStockWasteFrame.LoadSettings;
begin
  {FUpdatingControls := true;
  try}
    inherited;
    TSettingsManager.Instance.LoadGridLayout(dgStockWaste, 'StockWaste_StockWaste');
  {finally
    FUpdatingControls := false;
  end;}
end;

function TStockWasteFrame.CreateFilterFrame: TBaseFilterFrame;
begin
  Result := TStockWasteFilterFrame.Create(Self);
end;

procedure TStockWasteFrame.dgStockWasteDblClick(Sender: TObject);
var
  ac: TAction;
begin
  ac := TMainActions.GetAction(TStockWasteActions.Edit);
  if ac.Enabled then
    ac.Execute;
end;

procedure TStockWasteFrame.dgStockWasteDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  RectCopy: TRect;
begin
  if (Column.Field <> nil) then
  try
    if (CompareText(Column.FieldName, TStockDocument.F_SyncState) = 0) then
      DrawSyncState(Sender as TGridClass, Column, Rect)
    else
    if (CompareText(Column.FieldName, TStockDocument.F_MatName) = 0) then
    begin
      if StockWaste.HasManyItems then
      begin
        RectCopy := Rect;
        DrawManyItemsIcon(Sender as TGridClass, Column, RectCopy);
        dgStockWaste.DefaultDrawColumnCell(RectCopy, DataCol, Column, State);
      end else
        dgStockWaste.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
  except end;
end;

function TStockWasteFrame.StockWaste: TStockWaste;
begin
  Result := Entity as TStockWaste;
end;

end.
