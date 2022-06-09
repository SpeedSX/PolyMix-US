unit fStockIncomeToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseToolbar, JvSpeedbar, JvExControls, JvLabel, ExtCtrls,
  JvExExtCtrls, JvExtComponent, fDocumentToolbar, Menus;

type
  TStockIncomeToolbarFrame = class(TDocumentToolbar)
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses PmActions;

constructor TStockIncomeToolbarFrame.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetAction(siNew, TStockIncomeActions.New);
  SetAction(siEdit, TStockIncomeActions.Edit);
  SetAction(siDelete, TStockIncomeActions.Delete);
  miPrintForm.Action := TMainActions.GetAction(TStockIncomeActions.PrintForm);
  miPrintReport.Action := TMainActions.GetAction(TStockIncomeActions.PrintReport);
end;

end.
