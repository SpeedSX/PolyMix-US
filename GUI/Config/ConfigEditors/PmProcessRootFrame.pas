unit PmProcessRootFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PmBaseConfigEditorFrame, JvExControls, JvGradientHeaderPanel, Menus;

type
  TProcessRootEditorFrame = class(TBaseConfigEditorFrame)
    pmProcessRoot: TPopupMenu;
    miExportScripts: TMenuItem;
    miImportScripts: TMenuItem;
    miAddProcess: TMenuItem;
    N3: TMenuItem;
    miCreateAllTriggers: TMenuItem;
    N2: TMenuItem;
    procedure miAddProcessClick(Sender: TObject);
    procedure miExportScriptsClick(Sender: TObject);
    procedure miImportScriptsClick(Sender: TObject);
    procedure miCreateAllTriggersClick(Sender: TObject);
  private
    FOnAddProcess: TNotifyEvent;
    FOnExportScripts: TNotifyEvent;
    FOnImportScripts: TNotifyEvent;
    FOnCreateAllTriggers: TNotifyEvent;
  public
    function GetPopupMenu: TPopupMenu; override;
    property OnAddProcess: TNotifyEvent read FOnAddProcess write FOnAddProcess;
    property OnExportScripts: TNotifyEvent read FOnExportScripts write FOnExportScripts;
    property OnImportScripts: TNotifyEvent read FOnImportScripts write FOnImportScripts;
    property OnCreateAllTriggers: TNotifyEvent read FOnCreateAllTriggers write FOnCreateAllTriggers;
  end;

implementation

{$R *.dfm}

procedure TProcessRootEditorFrame.miAddProcessClick(Sender: TObject);
begin
  FOnAddProcess(Self);
end;

procedure TProcessRootEditorFrame.miCreateAllTriggersClick(Sender: TObject);
begin
  FOnCreateAllTriggers(Self);
end;

procedure TProcessRootEditorFrame.miExportScriptsClick(Sender: TObject);
begin
  FOnExportScripts(Self);
end;

procedure TProcessRootEditorFrame.miImportScriptsClick(Sender: TObject);
begin
  FOnImportScripts(Self);
end;

function TProcessRootEditorFrame.GetPopupMenu: TPopupMenu;
begin
  Result := pmProcessRoot;
end;

end.
