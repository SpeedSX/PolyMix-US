unit ContragentHistoryFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, HistFrm, DB, JvComponentBase, JvFormPlacement, Buttons, StdCtrls,
  GridsEh, DBGridEh, MyDBGridEh, ExtCtrls, JvAppStorage,

  PmContragent, PmHistory, DBGridEhGrouping;

type
  TContragentHistoryForm = class(THistoryForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FHistory: TContragentHistoryView;
  protected
    procedure DoFormActivate; override;
    procedure DoRefreshHistory; override;
  public
    Contragents: TContragents;
  end;

var
  ContragentHistoryForm: TContragentHistoryForm;

procedure ExecContragentHistoryForm(Contragents: TContragents; MainStorage: TJvCustomAppStorage);

implementation

{$R *.dfm}

procedure ExecContragentHistoryForm(Contragents: TContragents; MainStorage: TJvCustomAppStorage);
begin
  try
    Application.CreateForm(TContragentHistoryForm, ContragentHistoryForm);
    ContragentHistoryForm.Contragents := Contragents;
    ContragentHistoryForm.MainStorage := MainStorage;
    ContragentHistoryForm.ShowModal;
  finally
    FreeAndNil(ContragentHistoryForm);
  end;
end;

procedure TContragentHistoryForm.DoFormActivate;
begin
  FHistory := TContragentHistoryView.Create(Contragents.KeyValue);
  dsHistory.DataSet := FHistory.DataSet;
  DoRefreshHistory;
end;

procedure TContragentHistoryForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FHistory.Free;
end;

procedure TContragentHistoryForm.DoRefreshHistory;
begin
  FHistory.Reload;
end;

end.
