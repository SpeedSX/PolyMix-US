unit PmDictionaryFolderEditorFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PmBaseConfigEditorFrame, JvExControls, JvGradientHeaderPanel, Menus;

type
  TDictionaryFolderEditorFrame = class(TBaseConfigEditorFrame)
    pmDicFolder: TPopupMenu;
    miNewFolder: TMenuItem;
    miNewDic: TMenuItem;
    miRemoveFolder: TMenuItem;
    N14: TMenuItem;
    miShowInternalName: TMenuItem;
    N1: TMenuItem;
    miEditProperties: TMenuItem;
    procedure miNewDicClick(Sender: TObject);
    procedure miNewFolderClick(Sender: TObject);
    procedure miRemoveFolderClick(Sender: TObject);
    procedure miShowInternalNameClick(Sender: TObject);
    procedure miEditPropertiesClick(Sender: TObject);
  private
    FOnEditFolderProperties: TNotifyEvent;
    FOnNewDictionary: TNotifyEvent;
    FOnNewFolder: TNotifyEvent;
    FOnDeleteFolder: TNotifyEvent;
    FOnShowInternalName: TNotifyEvent;
  public
    function GetPopupMenu: TPopupMenu; override;
    property OnEditFolderProperties: TNotifyEvent read FOnEditFolderProperties write FOnEditFolderProperties;
    property OnNewDictionary: TNotifyEvent read FOnNewDictionary write FOnNewDictionary;
    property OnNewFolder: TNotifyEvent read FOnNewFolder write FOnNewFolder;
    property OnDeleteFolder: TNotifyEvent read FOnDeleteFolder write FOnDeleteFolder;
    property OnShowInternalName: TNotifyEvent read FOnShowInternalName write FOnShowInternalName;
  end;

implementation

{$R *.dfm}

function TDictionaryFolderEditorFrame.GetPopupMenu: TPopupMenu;
begin
  Result := pmDicFolder;
end;

procedure TDictionaryFolderEditorFrame.miNewDicClick(Sender: TObject);
begin
  FOnNewDictionary(Self);
end;

procedure TDictionaryFolderEditorFrame.miNewFolderClick(Sender: TObject);
begin
  FOnNewFolder(Self);
end;

procedure TDictionaryFolderEditorFrame.miRemoveFolderClick(Sender: TObject);
begin
  FOnDeleteFolder(Self);
end;

procedure TDictionaryFolderEditorFrame.miShowInternalNameClick(Sender: TObject);
begin
  FOnShowInternalName(Self);
end;

procedure TDictionaryFolderEditorFrame.miEditPropertiesClick(Sender: TObject);
begin
  FOnEditFolderProperties(Self);
end;

end.
