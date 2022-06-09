unit fMatRequestToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvSpeedbar, JvExControls, JvLabel, ExtCtrls,
  JvExExtCtrls, JvExtComponent,

  fBaseToolbar, Menus;

type
  TMatRequestToolbar = class(TBaseToolbarFrame)
    Toolbar: TJvSpeedBar;
    lbOrderType: TJvLabel;
    SpeedbarSection1: TJvSpeedBarSection;
    siEdit: TJvSpeedItem;
    siDelete: TJvSpeedItem;
    siPrint: TJvSpeedItem;
    siGotoOrder: TJvSpeedItem;
    siCloseMatRequests: TJvSpeedItem;
    pmMatRequestReport: TPopupMenu;
    miMatRequestForm: TMenuItem;
    miMatRequestReport: TMenuItem;
    siSaveRequests: TJvSpeedItem;
    siCancelRequests: TjvSpeedItem;
  private
  protected
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses PmActions, CalcSettings;

constructor TMatRequestToolbar.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetAction(siEdit, TMaterialRequestActions.Edit);
  SetAction(siDelete, TMaterialRequestActions.Delete);
  SetAction(siPrint, TMaterialRequestActions.PrintReport);
  //SetAction(miMatRequestForm, TMaterialRequestActions.PrintForm);
  SetAction(siGoToOrder, TMaterialRequestActions.OpenOrder);
  SetAction(siCloseMatRequests, TMainActions.CloseView);
  SetAction(siCancelRequests, TMaterialRequestActions.Cancel);
  SetAction(siSaveRequests, TMaterialRequestActions.Save);
  TSettingsManager.Instance.XPInitComponent(pmMatRequestReport);
  TSettingsManager.Instance.XPActivateMenuItem(pmMatRequestReport.Items, true);
end;


end.
