unit SplForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, JvCtrls, ExtCtrls, JvExControls, JvComponent, JvLabel,
  XPMenu, JvButton, JvTransparentButton, ImgList;

type
  TSplash = class(TForm)
    Panel1: TPanel;        
    Image1: TImage;
    lbName: TJvLabel;
    edUserName: TEdit;
    lbPass: TJvLabel;
    edPassword: TEdit;
    lbStatus: TLabel;
    lbVer: TLabel;
    lbCopy: TLabel;
    sbOk: TJvTransparentButton;
    sbExit: TJvTransparentButton;
    ImageList1: TImageList;
    procedure sbOkClick(Sender: TObject);
    procedure sbExitClick(Sender: TObject);
    procedure edUserNameKeyPress(Sender: TObject; var Key: Char);
    procedure edPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    function GetAppVersion: String;
  private
    XPMenuPainter: TXPMenu;
    procedure SetMode(Stat: boolean);
    procedure SetMsg(_Msg: string);
  public
    Ok: boolean;
    property Msg: string write SetMsg;
    procedure SetStatusMode;
    procedure SetPasswordMode;
  end;

  procedure SplashEvent(Msg: string);

var
  Splash: TSplash;

implementation

uses JvJVCLUtils, CalcSettings;

{$R *.DFM}

procedure SplashEvent(Msg: string);
begin
  Splash.Msg := Msg;
  Splash.Update;
  delay(10);
end;

procedure TSplash.SetMsg(_Msg: string);
begin
  SetStatusMode;
  lbStatus.Caption := _Msg;
end;

procedure TSplash.sbOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
  OK := true;
end;

procedure TSplash.sbExitClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  OK := true;
end;

procedure TSplash.SetMode(Stat: boolean);
begin
  lbStatus.Visible := stat;
  lbName.Visible := not stat;
  lbPass.Visible := not stat;
  edPassword.Visible := not stat;
  edUserName.Visible := not stat;
  lbCopy.Visible := not Stat;
  sbOk.Visible := not stat;
  sbExit.Visible := not stat;
end;

procedure TSplash.SetStatusMode;
begin
  SetMode(true);
//  Height := 163;
end;

procedure TSplash.SetPasswordMode;
begin
  SetMode(false);
  ClientHeight := 222;
end;

procedure TSplash.edUserNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    FocusControl(FindNextControl(Sender as TWinControl, true, true, false));
    Key := #0;
  end;
end;

procedure TSplash.edPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    sbOkClick(Sender);
    Key := #0;
  end;
end;

procedure TSplash.FormActivate(Sender: TObject);
begin
  if edUserName.Visible then ActiveControl := edUserName;
  OK := false;
//  ClientHeight := 222;
end;

procedure TSplash.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := OK;
end;

procedure TSplash.FormCreate(Sender: TObject);
begin
  XPMenuPainter := TSettingsManager.Instance.CreateXPPainter(Self);
  lbVer.Caption := 'Версія ' + GetAppVersion;
end;

function TSplash.GetAppVersion: String;
var
  Size, Size2: DWord;
  Pt, Pt2: Pointer;
begin
  Size := GetFileVersionInfoSize(PChar(ParamStr(0)), Size2);
  if Size > 0 then
  begin
    GetMem(Pt, Size);
    try
      GetFileVersionInfo(PChar(ParamStr(0)), 0, Size, Pt);
      VerQueryValue(Pt, '\', Pt2, Size2);
      with TVSFixedFileInfo(Pt2^) do
        Result := IntToStr(HiWord(dwFileVersionMS)) + '.' + IntToStr(LoWord(dwFileVersionMS)) + '.' + IntToStr(HiWord(dwFileVersionLS));
    finally
      FreeMem(Pt);
    end;
  end;
end;

end.
