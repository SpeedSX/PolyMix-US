unit fScheduleToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvSpeedbar, JvExControls, JvLabel, ExtCtrls,
  JvExExtCtrls, JvExtComponent, Menus,

  fBaseToolbar;

type
  TScheduleToolbar = class(TBaseToolbarFrame)
    Toolbar: TJvSpeedBar;
    lbOrderType: TJvLabel;
    SpeedbarSection1: TJvSpeedBarSection;
    siNew: TJvSpeedItem;
    siEdit: TJvSpeedItem;
    siDelete: TJvSpeedItem;
    siPrint: TJvSpeedItem;
    siOpenOrder: TJvSpeedItem;
    siEditComment: TJvSpeedItem;
    siSplit: TJvSpeedItem;
    siSpecJobs: TJvSpeedItem;
    siExportScheduleToExcel: TJvSpeedItem;
    siUndo: TJvSpeedItem;
    siLock: TJvSpeedItem;
    siUnlock: TJvSpeedItem;
    JvSpeedBarSection1: TJvSpeedBarSection;
    siCloseSchedule: TJvSpeedItem;
  private
    procedure SetSpecJobMenu(_SpecJobMenu: TPopupMenu);
  protected
  public
    constructor Create(Owner: TComponent); override;
    property SpecialJobMenu: TPopupMenu write SetSpecJobMenu;
  end;

implementation

{$R *.dfm}

uses PmActions;

constructor TScheduleToolbar.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetAction(siNew, TScheduleActions.Add);
  SetAction(siEdit, TScheduleActions.Edit);
  SetAction(siDelete, TScheduleActions.Remove);
  SetAction(siPrint, TScheduleActions.Print);
  SetAction(siOpenOrder, TScheduleActions.OpenOrder);
  SetAction(siEditComment, TScheduleActions.EditComment);
  SetAction(siSplit, TScheduleActions.Split);
  SetAction(siUndo, TScheduleActions.Undo);
  SetAction(siLock, TScheduleActions.Lock);
  SetAction(siUnlock, TScheduleActions.Unlock);
  SetAction(siCloseSchedule, TMainActions.CloseView);
  siNew.Visible := false;
  siDelete.Visible := false;
  //siExport.Action := TMainActions.GetAction(TOrderActions.Export);
  //siImport.Action := TMainActions.GetAction(TOrderActions.Import);
end;

procedure TScheduleToolbar.SetSpecJobMenu(_SpecJobMenu: TPopupMenu);
begin
  siSpecJobs.DropDownMenu := _SpecJobMenu;
end;

end.
