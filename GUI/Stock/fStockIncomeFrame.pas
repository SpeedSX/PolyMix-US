unit fStockIncomeFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, MyDBGridEh, ActnList,

  fBaseFrame, fBaseFilter, PmStockIncome, PmEntity, DBGridEhGrouping;

type
  TStockIncomeFrame = class(TBaseFrame)
    dgStockIncome: TMyDBGridEh;
    procedure dgStockIncomeDblClick(Sender: TObject);
    procedure dgStockIncomeDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
  private
    //FStockIncome: TStockIncome;
    function StockIncome: TStockIncome;
  public
    constructor Create(Owner: TComponent; _StockIncome: TEntity); override;
    procedure SaveSettings; override;
    procedure LoadSettings; override;
    function CreateFilterFrame: TBaseFilterFrame; override;
  end;

implementation

uses CalcSettings, PmOrder, CalcUtils, fStockIncomeFilterFrame, fMainFilter,
  PmActions, PmStockDocument, PmUtils;

{$R *.dfm}

constructor TStockIncomeFrame.Create(Owner: TComponent; _StockIncome: TEntity);
begin
  inherited Create(Owner, _StockIncome{'StockIncome'});
  //FStockIncome := _StockIncome;

  dgStockIncome.DataSource := StockIncome.DataSource;

  FilterObject := StockIncome.Criteria;
  FilterFrame.Entity := StockIncome;
end;

procedure TStockIncomeFrame.SaveSettings;
begin
  inherited;
  TSettingsManager.Instance.SaveGridLayout(dgStockIncome, 'StockIncome_StockIncome');
end;

procedure TStockIncomeFrame.LoadSettings;
begin
  {FUpdatingControls := true;
  try}
    inherited;
    TSettingsManager.Instance.LoadGridLayout(dgStockIncome, 'StockIncome_StockIncome');
  {finally
    FUpdatingControls := false;
  end;}
end;

function TStockIncomeFrame.CreateFilterFrame: TBaseFilterFrame;
begin
  Result := TStockIncomeFilterFrame.Create(Self);
end;

procedure TStockIncomeFrame.dgStockIncomeDblClick(Sender: TObject);
var
  ac: TAction;
begin
  ac := TMainActions.GetAction(TStockIncomeActions.Edit);
  if ac.Enabled then
    ac.Execute;
end;

procedure TStockIncomeFrame.dgStockIncomeDrawColumnCell(Sender: TObject;
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
      if StockIncome.HasManyItems then
      begin
        RectCopy := Rect;
        DrawManyItemsIcon(Sender as TGridClass, Column, RectCopy);
        dgStockIncome.DefaultDrawColumnCell(RectCopy, DataCol, Column, State);
      end else
        dgStockIncome.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
  except end;
end;

function TStockIncomeFrame.StockIncome: TStockIncome;
begin
  Result := Entity as TStockIncome;
end;

end.
