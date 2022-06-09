unit fDocumentToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvSpeedbar, JvExControls, JvLabel, ExtCtrls,
  JvExExtCtrls, JvExtComponent,

  fBaseToolbar, Menus;

type
  TDocumentToolbar = class(TBaseToolbarFrame)
    Toolbar: TJvSpeedBar;
    lbDocType: TJvLabel;
    SpeedbarSection1: TJvSpeedBarSection;
    siNew: TJvSpeedItem;
    siEdit: TJvSpeedItem;
    siDelete: TJvSpeedItem;
    siPrint: TJvSpeedItem;
    siClose: TJvSpeedItem;
    pmDocReports: TPopupMenu;
    miPrintForm: TMenuItem;
    miPrintReport: TMenuItem;
  private
  protected
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

uses PmActions;

{$R *.dfm}

constructor TDocumentToolbar.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetAction(siClose, TMainActions.CloseView);
end;


end.
