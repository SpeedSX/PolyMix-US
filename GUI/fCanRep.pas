unit fCanRep;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, JvExComCtrls, JvProgressBar;

type
  TCancelRepForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    btCancel: TButton;
    pbProgress: TJvProgressBar;
    CloseTimer: TTimer;
    procedure btCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CloseTimerTimer(Sender: TObject);
  private
    FArgument: TObject;
    FLaunched: boolean;
    FOnCreateReport: TNotifyEvent;
    function GetMaxProgress: Integer;
    procedure SetMaxProgress(const Value: Integer);
    procedure SetProgress(Value: integer);
  public
    property Argument: TObject read FArgument write FArgument;
    property MaxProgress: Integer read GetMaxProgress write SetMaxProgress;
    property OnCreateReport: TNotifyEvent read FOnCreateReport write
        FOnCreateReport;
    property Progress: integer write SetProgress;
  end;

var
  CancelRepForm: TCancelRepForm;
  XLCancelled: boolean;

procedure OpenReportProgressForm(_OnCreateReport: TNotifyEvent; Arg: TObject);
procedure CloseReportProgressForm;
function ReportInProgress: boolean;

implementation

{$R *.DFM}

procedure OpenReportProgressForm(_OnCreateReport: TNotifyEvent; Arg: TObject);
begin
  CloseReportProgressForm;
  Application.CreateForm(TCancelRepForm, CancelRepForm);
  CancelRepForm.OnCreateReport := _OnCreateReport;
  CancelRepForm.Argument := Arg;
  CancelRepForm.ShowModal;
  //CancelRepForm.Update;
end;

procedure CloseReportProgressForm;
begin
  if Assigned(CancelRepForm) then begin
    if CancelRepForm.Visible then CancelRepForm.Close;
    FreeAndNil(CancelRepForm);
  end;
end;

function ReportInProgress: boolean;
begin
  Result := CancelRepForm <> nil;
end;

procedure TCancelRepForm.btCancelClick(Sender: TObject);
begin
  XLCancelled := true;
  Close;
end;

procedure TCancelRepForm.FormCreate(Sender: TObject);
begin
  XLCancelled := false;
end;

function TCancelRepForm.GetMaxProgress: Integer;
begin
  Result := pbProgress.Max;
end;

procedure TCancelRepForm.SetMaxProgress(const Value: Integer);
begin
  pbProgress.Max := Value;
end;

procedure TCancelRepForm.SetProgress(Value: integer);
begin
  pbProgress.Position := Value;
end;

procedure TCancelRepForm.FormActivate(Sender: TObject);
begin
  if not FLaunched then
  begin
    Update;
    try
      FLaunched := true;
      FOnCreateReport(FArgument);
    finally
      CloseTimer.Enabled := true;
    end;
  end;
end;

procedure TCancelRepForm.CloseTimerTimer(Sender: TObject);
begin
  PostMessage(Self.Handle, WM_CLOSE, 0, 0);
end;

end.
