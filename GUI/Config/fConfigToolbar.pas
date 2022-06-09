unit fConfigToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseToolbar, ExtCtrls, JvExExtCtrls, JvExtComponent, JvSpeedbar,
  JvExControls, JvLabel;

type
  TConfigToolbarFrame = class(TBaseToolbarFrame)
    Toolbar: TJvSpeedBar;
    siCloseConfig: TJvSpeedItem;
    JvSpeedBarSection1: TJvSpeedBarSection;
    lbOrderType: TJvLabel;
    siSaveConfig: TJvSpeedItem;
  private
    { Private declarations }
  public
    constructor Create(Owner: TComponent); override;
  end;

{var
  ConfigToolbarFrame: TConfigToolbarFrame;}

implementation

{$R *.dfm}

uses PmActions;

constructor TConfigToolbarFrame.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetAction(siCloseConfig, TMainActions.CloseView);
  SetAction(siSaveConfig, TConfigActions.SaveConfig);
end;

end.
