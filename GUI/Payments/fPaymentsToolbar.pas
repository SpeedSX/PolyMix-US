unit fPaymentsToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvSpeedbar, JvExControls, JvLabel, ExtCtrls,
  JvExExtCtrls, JvExtComponent,

  fBaseToolbar, Menus;

type
  TPaymentsToolbar = class(TBaseToolbarFrame)
    Toolbar: TJvSpeedBar;
    lbOrderType: TJvLabel;
    SpeedbarSection1: TJvSpeedBarSection;
    siNew: TJvSpeedItem;
    siEdit: TJvSpeedItem;
    siDelete: TJvSpeedItem;
    siPrint: TJvSpeedItem;
    pmPaymentReports: TPopupMenu;
    miPrintOrders: TMenuItem;
    miPrintIncomes: TMenuItem;
    siLocateInvoice: TJvSpeedItem;
    siClosePayments: TJvSpeedItem;
  private
  protected
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses CalcSettings, PmActions;

constructor TPaymentsToolbar.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetAction(siNew, TPaymentActions.New);
  SetAction(siEdit, TPaymentActions.Edit);
  SetAction(siDelete, TPaymentActions.Delete);
  SetAction(siLocateInvoice, TPaymentActions.EditInvoice);
  SetAction(siClosePayments, TMainActions.CloseView);
  TMainActions.SetAction(miPrintOrders, TPaymentActions.PrintOrders);
  TMainActions.SetAction(miPrintIncomes, TPaymentActions.PrintIncomes);
  TSettingsManager.Instance.XPInitComponent(pmPaymentReports);
  TSettingsManager.Instance.XPActivateMenuItem(pmPaymentReports.Items, true);
  //siExport.Action := TMainActions.GetAction(TOrderActions.Export);
  //siImport.Action := TMainActions.GetAction(TOrderActions.Import);
end;

end.
