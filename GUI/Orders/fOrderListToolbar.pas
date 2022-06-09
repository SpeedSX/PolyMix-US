unit fOrderListToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvSpeedbar, JvExControls, JvLabel, ExtCtrls,
  JvExExtCtrls, JvExtComponent,

  fBaseToolbar;

type
  TOrderListToolbar = class(TBaseToolbarFrame)
    Toolbar: TJvSpeedBar;
    lbOrderType: TJvLabel;
    SpeedbarSection1: TJvSpeedBarSection;
    siNew: TJvSpeedItem;
    siCopy: TJvSpeedItem;
    siEdit: TJvSpeedItem;
    siDelete: TJvSpeedItem;
    siPrint: TJvSpeedItem;
    siExport: TJvSpeedItem;
    siImport: TJvSpeedItem;
    siSaveOrder: TJvSpeedItem;
    siCancelOrder: TJvSpeedItem;
  private
  protected
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses PmActions;

constructor TOrderListToolbar.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetAction(siNew, TOrderActions.New);
  SetAction(siCopy, TOrderActions.Copy);
  SetAction(siEdit, TOrderActions.Edit);
  SetAction(siDelete, TOrderActions.Delete);
  SetAction(siPrint, TOrderActions.Print);
  SetAction(siSaveOrder, TOrderActions.Save);
  SetAction(siCancelOrder, TOrderActions.Cancel);
  //siExport.Action := TMainActions.GetAction(TOrderActions.Export);
  //siImport.Action := TMainActions.GetAction(TOrderActions.Import);
end;

end.
