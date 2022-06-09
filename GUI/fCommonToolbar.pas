unit fCommonToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseToolbar, JvSpeedbar, ExtCtrls, JvExExtCtrls, JvExtComponent,
  Menus;

type
  TCommonToolbarFrame = class(TBaseToolbarFrame)
    Toolbar: TJvSpeedBar;
    SpeedbarSection1: TJvSpeedBarSection;
    siCustomers: TJvSpeedItem;
    siCustomize: TJvSpeedItem;
    siExit: TJvSpeedItem;
    siReports: TJvSpeedItem;
    OptMenu: TPopupMenu;
    miUsers: TMenuItem;
    miGScripts: TMenuItem;
    miCustomReports: TMenuItem;
    miUE: TMenuItem;
    miEntSettings: TMenuItem;
    miUpdateCfg: TMenuItem;
    N2: TMenuItem;
    miInterface: TMenuItem;
    siReload: TJvSpeedItem;
    miConfig: TMenuItem;
    siContractors: TJvSpeedItem;
    siSuppliers: TJvSpeedItem;
    procedure OptMenuPopup(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(Owner: TComponent); override;
    procedure UpdateActions;
  end;

implementation

{$R *.dfm}

uses PmActions, PmAccessManager, CalcSettings, PmEntSettings;

constructor TCommonToolbarFrame.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  OptMenu.Images := TSettingsManager.Instance.MainImageList;
  TSettingsManager.Instance.XPInitComponent(OptMenu);
  TSettingsManager.Instance.XPActivateMenuItem(OptMenu.Items, true);
  UpdateActions;
end;

procedure TCommonToolbarFrame.UpdateActions;
begin
  siCustomers.Action := TMainActions.GetAction(TMainActions.Customers);
  siContractors.Action := TMainActions.GetAction(TMainActions.Contractors);
  if EntSettings.AllContractors then
    siContractors.Caption := 'Подрядчики';
  siSuppliers.Action := TMainActions.GetAction(TMainActions.Suppliers);
  siExit.Action := TMainActions.GetAction(TMainActions.Quit);
  siReload.Action := TMainActions.GetAction(TMainActions.Reload);
  miEntSettings.Action := TMainActions.GetAction(TMainActions.EntSettings);
  miUE.Action := TMainActions.GetAction(TMainActions.Rates);
  miConfig.Action := TMainActions.GetAction(TMainActions.NewConfig);
  miUsers.Action := TMainActions.GetAction(TMainActions.OldConfig);
  miGScripts.Action := TMainActions.GetAction(TMainActions.GlobalScripts);
  miUpdateCfg.Action := TMainActions.GetAction(TMainActions.UpdateCfg);
  miInterface.Action := TMainActions.GetAction(TMainActions.InterfaceOptions);
  miCustomReports.Action := TMainActions.GetAction(TMainActions.CustomReports);
end;

procedure TCommonToolbarFrame.OptMenuPopup(Sender: TObject);
begin
  miConfig.Enabled := AccessManager.CurUser.EditProcCfg or AccessManager.CurUser.EditDics;
  miUsers.Enabled := AccessManager.CurUser.EditProcCfg or AccessManager.CurUser.EditUsers;
end;

end.
