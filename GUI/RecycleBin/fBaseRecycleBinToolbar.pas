unit fBaseRecycleBinToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseToolbar, JvSpeedbar, JvExControls, JvLabel, ExtCtrls,
  JvExExtCtrls, JvExtComponent;

type
  TBaseRecycleBinToolbar = class(TBaseToolbarFrame)
    Toolbar: TJvSpeedBar;
    lbOrderType: TJvLabel;
    SpeedbarSection1: TJvSpeedBarSection;
    siRestore: TJvSpeedItem;
    siPurge: TJvSpeedItem;
    siPurgeAll: TJvSpeedItem;
  private
    { Private declarations }
  public
    constructor Create(Owner: TComponent); override;
  end;

var
  BaseRecycleBinToolbar: TBaseRecycleBinToolbar;

implementation

{$R *.dfm}

uses CalcSettings, PmActions;

constructor TBaseRecycleBinToolbar.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetAction(siRestore, TRecycleBinActions.Restore);
  SetAction(siPurge, TRecycleBinActions.Purge);
  SetAction(siPurgeAll, TRecycleBinActions.PurgeAll);
  //siExport.Action := TMainActions.GetAction(TOrderActions.Export);
  //siImport.Action := TMainActions.GetAction(TOrderActions.Import);
end;

end.
