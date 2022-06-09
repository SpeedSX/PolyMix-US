unit fStockFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, MyDBGridEh,

  fBaseFrame, fBaseFilter, PmStock, PmEntity;

type
  TStockFrame = class(TBaseFrame)
    dgStock: TMyDBGridEh;
  private
    //FStock: TStock;
  public
    constructor Create(Owner: TComponent; _Stock: TEntity); override;
    procedure SaveSettings; override;
    procedure LoadSettings; override;
    function Stock: TStock;
  end;

implementation

uses CalcSettings, PmOrder, CalcUtils;

{$R *.dfm}

constructor TStockFrame.Create(Owner: TComponent; _Stock: TEntity);
begin
  inherited Create(Owner, _Stock{'Stock'});
  //FStock := _Stock;

  dgStock.DataSource := Stock.DataSource;

  paFilter.Visible := false;
end;

procedure TStockFrame.SaveSettings;
begin
  inherited;
  TSettingsManager.Instance.SaveGridLayout(dgStock, 'Stock_Stock');
end;

procedure TStockFrame.LoadSettings;
begin
  {FUpdatingControls := true;
  try}
    inherited;
    TSettingsManager.Instance.LoadGridLayout(dgStock, 'Stock_Stock');
  {finally
    FUpdatingControls := false;
  end;}
end;

function TStockFrame.Stock: TStock;
begin
  Result := Entity as TStock;
end;

end.
