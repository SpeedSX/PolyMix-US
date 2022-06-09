unit fProductionToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvSpeedbar, JvExControls, JvLabel, ExtCtrls,
  JvExExtCtrls, JvExtComponent,

  fBaseToolbar;

type
  TProductionToolbar = class(TBaseToolbarFrame)
    Toolbar: TJvSpeedBar;
    SpeedbarSection1: TJvSpeedBarSection;
    siPrint: TJvSpeedItem;
  private
  protected
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses PmActions;

constructor TProductionToolbar.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetAction(siPrint, TProductionActions.Print);
end;

end.
