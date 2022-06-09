unit fStockMoveToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseToolbar, JvSpeedbar, JvExControls, JvLabel, ExtCtrls,
  JvExExtCtrls, JvExtComponent;

type
  TStockMoveToolbarFrame = class(TBaseToolbarFrame)
    Toolbar: TJvSpeedBar;
    lbOrderType: TJvLabel;
    SpeedbarSection1: TJvSpeedBarSection;
    siCloseReport: TJvSpeedItem;
  private
    { Private declarations }
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses PmActions;

constructor TStockMoveToolbarFrame.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetAction(siCloseReport, TMainActions.CloseView);
end;

end.
