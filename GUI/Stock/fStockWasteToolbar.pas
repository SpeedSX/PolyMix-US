unit fStockWasteToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseToolbar, JvSpeedbar, JvExControls, JvLabel, ExtCtrls,
  JvExExtCtrls, JvExtComponent, fDocumentToolbar, Menus;

type
  TStockWasteToolbarFrame = class(TDocumentToolbar)
  private
    { Private declarations }
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses PmActions;

constructor TStockWasteToolbarFrame.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetAction(siNew, TStockWasteActions.New);
  SetAction(siEdit, TStockWasteActions.Edit);
  SetAction(siDelete, TStockWasteActions.Delete);
  miPrintForm.Action := TMainActions.GetAction(TStockWasteActions.PrintForm);
  miPrintReport.Action := TMainActions.GetAction(TStockWasteActions.PrintReport);
end;

end.
