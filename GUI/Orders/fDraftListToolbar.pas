unit fDraftListToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fOrderListToolbar, JvSpeedbar, JvExControls, JvLabel, ExtCtrls,
  JvExExtCtrls, JvExtComponent;

type
  TDraftOrderListToolbar = class(TOrderListToolbar)
    siMakeOrder: TJvSpeedItem;
  private
    { Private declarations }
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses PmActions;

constructor TDraftOrderListToolbar.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetAction(siMakeOrder, TOrderActions.MakeWork);
end;

end.
