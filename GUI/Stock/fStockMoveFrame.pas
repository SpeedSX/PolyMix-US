unit fStockMoveFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, MyDBGridEh,

  fBaseFrame, fBaseFilter, PmStockMove, PmEntity, DBGridEhGrouping;

type
  TStockMoveFrame = class(TBaseFrame)
    dgStockMove: TMyDBGridEh;
  private
    //FStockMove: TStockMove;
  protected
    function StockMove: TStockMove;
  public
    constructor Create(Owner: TComponent; _StockMove: TEntity); override;
    procedure SaveSettings; override;
    procedure LoadSettings; override;
    function CreateFilterFrame: TBaseFilterFrame; override;
  end;

implementation

uses CalcSettings, PmOrder, CalcUtils, fStockMoveFilterFrame;

{$R *.dfm}

constructor TStockMoveFrame.Create(Owner: TComponent; _StockMove: TEntity);
begin
  inherited Create(Owner, _StockMove{'StockMove'});
  //FStockMove := _StockMove;

  FilterObject := StockMove.Criteria;
  FilterFrame.Entity := StockMove;

  dgStockMove.DataSource := StockMove.DataSource;
end;

procedure TStockMoveFrame.SaveSettings;
begin
  inherited;
  TSettingsManager.Instance.SaveGridLayout(dgStockMove, 'StockMove_StockMove');
end;

procedure TStockMoveFrame.LoadSettings;
begin
  {FUpdatingControls := true;
  try}
    inherited;
    TSettingsManager.Instance.LoadGridLayout(dgStockMove, 'StockMove_StockMove');
  {finally
    FUpdatingControls := false;
  end;}
end;

function TStockMoveFrame.CreateFilterFrame: TBaseFilterFrame;
begin
  Result := TStockMoveFilterFrame.Create(Self);
end;

function TStockMoveFrame.StockMove: TStockMove;
begin
  Result := Entity as TStockMove;
end;

end.
