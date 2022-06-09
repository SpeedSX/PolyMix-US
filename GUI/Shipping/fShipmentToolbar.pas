unit fShipmentToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvSpeedbar, JvExControls, JvLabel, ExtCtrls,
  JvExExtCtrls, JvExtComponent,

  fBaseToolbar, Menus;

type
  TShipmentToolbar = class(TBaseToolbarFrame)
    Toolbar: TJvSpeedBar;
    lbOrderType: TJvLabel;
    SpeedbarSection1: TJvSpeedBarSection;
    siNew: TJvSpeedItem;
    siEdit: TJvSpeedItem;
    siDelete: TJvSpeedItem;
    siPrint: TJvSpeedItem;
    siGotoOrder: TJvSpeedItem;
    pmShipmentReport: TPopupMenu;
    miShipmentForm: TMenuItem;
    miShipmentReport: TMenuItem;
  private
  protected
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses PmActions, CalcSettings;

constructor TShipmentToolbar.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetAction(siNew, TShipmentActions.New);
  SetAction(siEdit, TShipmentActions.Edit);
  SetAction(siDelete, TShipmentActions.Delete);
  TMainActions.SetAction(miShipmentReport, TShipmentActions.PrintReport);
  TMainActions.SetAction(miShipmentForm, TShipmentActions.PrintForm);
  SetAction(siGoToOrder, TShipmentActions.OpenOrder);
  TSettingsManager.Instance.XPInitComponent(pmShipmentReport);
  TSettingsManager.Instance.XPActivateMenuItem(pmShipmentReport.Items, true);
end;


end.
