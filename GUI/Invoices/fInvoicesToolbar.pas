unit fInvoicesToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvSpeedbar, JvExControls, JvLabel, ExtCtrls,
  JvExExtCtrls, JvExtComponent,

  fBaseToolbar, Menus;

type
  TInvoicesToolbar = class(TBaseToolbarFrame)
    Toolbar: TJvSpeedBar;
    lbOrderType: TJvLabel;
    SpeedbarSection1: TJvSpeedBarSection;
    siNew: TJvSpeedItem;
    siEdit: TJvSpeedItem;
    siDelete: TJvSpeedItem;
    siPrint: TJvSpeedItem;
    siPayInvoice: TJvSpeedItem;
    siCloseView: TJvSpeedItem;
    pmInvoiceReports: TPopupMenu;
    miInvoiceForm: TMenuItem;
    miInvoiceReport: TMenuItem;
  private
  protected
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses PmActions, CalcSettings;

constructor TInvoicesToolbar.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetAction(siNew, TInvoiceActions.New);
  SetAction(siEdit, TInvoiceActions.Edit);
  SetAction(siDelete, TInvoiceActions.Delete);
  SetAction(siPayInvoice, TInvoiceActions.PayInvoice);
  SetAction(siCloseView, TMainActions.CloseView);
  TMainActions.SetAction(miInvoiceForm, TInvoiceActions.PrintForm);
  TMainActions.SetAction(miInvoiceReport, TInvoiceActions.PrintReport);
  TSettingsManager.Instance.XPInitComponent(pmInvoiceReports);
  TSettingsManager.Instance.XPActivateMenuItem(pmInvoiceReports.Items, true);
  //siExport.Action := TMainActions.GetAction(TOrderActions.Export);
  //siImport.Action := TMainActions.GetAction(TOrderActions.Import);
end;


end.
