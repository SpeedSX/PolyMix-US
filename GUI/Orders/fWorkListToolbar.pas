unit fWorkListToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fOrderListToolbar, JvSpeedbar, JvExControls, JvLabel, ExtCtrls,
  JvExExtCtrls, JvExtComponent;

type
  TWorkOrderListToolbar = class(TOrderListToolbar)
    siMakeInvoice: TJvSpeedItem;
    siMakeDraft: TJvSpeedItem;
  private
    { Private declarations }
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses PmActions;

constructor TWorkOrderListToolbar.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetAction(siMakeInvoice, TOrderActions.MakeInvoice);
  SetAction(siMakeDraft, TOrderActions.MakeDraft);
end;

end.
