unit PmDictionaryRootEditorFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PmBaseConfigEditorFrame, JvExControls, JvGradientHeaderPanel, Menus;

type
  TDictionaryRootEditorFrame = class(TBaseConfigEditorFrame)
    pmDicFolder: TPopupMenu;
    miNewDic: TMenuItem;
    miNewFolder: TMenuItem;
    N1: TMenuItem;
    miShowInternalName: TMenuItem;
    procedure miNewDicClick(Sender: TObject);
    procedure miNewFolderClick(Sender: TObject);
    procedure miShowInternalNameClick(Sender: TObject);
  private
    FOnNewDictionary: TNotifyEvent;
    FOnNewFolder: TNotifyEvent;
    FOnShowInternalName: TNotifyEvent;
  public
    function GetPopupMenu: TPopupMenu; override;
    property OnNewDictionary: TNotifyEvent read FOnNewDictionary write FOnNewDictionary;
    property OnNewFolder: TNotifyEvent read FOnNewFolder write FOnNewFolder;
    property OnShowInternalName: TNotifyEvent read FOnShowInternalName write FOnShowInternalName;
  end;

implementation

{$R *.dfm}

function TDictionaryRootEditorFrame.GetPopupMenu: TPopupMenu;
begin
  Result := pmDicFolder;
end;

procedure TDictionaryRootEditorFrame.miNewDicClick(Sender: TObject);
begin
  FOnNewDictionary(Self);
end;

procedure TDictionaryRootEditorFrame.miNewFolderClick(Sender: TObject);
begin
  FOnNewFolder(Self);
end;

procedure TDictionaryRootEditorFrame.miShowInternalNameClick(Sender: TObject);
begin
  FOnShowInternalName(Self);
end;

end.
