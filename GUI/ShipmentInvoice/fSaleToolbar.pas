unit fSaleToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvSpeedbar, JvExControls, JvLabel, ExtCtrls,
  JvExExtCtrls, JvExtComponent, Menus,

  fBaseToolbar, fDocumentToolbar;

type
  TSaleToolbar = class(TDocumentToolbar)
  private
  protected
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses PmActions, CalcSettings;

constructor TSaleToolbar.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetAction(siNew, TSaleActions.New);
  SetAction(siEdit, TSaleActions.Edit);
  SetAction(siDelete, TSaleActions.Delete);
  miPrintForm.Action := TMainActions.GetAction(TSaleActions.PrintForm);
  miPrintReport.Action := TMainActions.GetAction(TSaleActions.PrintReport);
end;


end.
