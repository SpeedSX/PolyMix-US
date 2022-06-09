unit fBaseToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Menus,

  JvSpeedBar;

type
  TBaseToolbarFrame = class(TFrame)
  private
    { Private declarations }
  protected
    procedure SetAction(Item: TJvSpeedItem; ActionName: string); overload;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses PmActions, CalcSettings;

procedure TBaseToolbarFrame.SetAction(Item: TJvSpeedItem; ActionName: string);
var
  SaveCaption: string;
begin
  SaveCaption := Item.BtnCaption;
  Item.Action := TMainActions.GetAction(ActionName);
  Item.BtnCaption := SaveCaption;
end;

end.
