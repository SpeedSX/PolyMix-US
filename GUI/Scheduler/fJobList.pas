unit fJobList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB,
  fmRelated, StdCtrls, ExtCtrls;

type
  TJobListForm = class(TForm)
    paJobList: TPanel;
    paBottom: TPanel;
    btOk: TButton;
    btCancel: TButton;
    procedure FormCreate(Sender: TObject);
  private
    ListFrame: TRelatedProcessGridFrame;
    procedure SetListSource(Value: TDataSource);
  public
    property ListSource: TDataSource write SetListSource;
  end;

var
  JobListForm: TJobListForm;

// Отображает диалог выбора работы из списка, возвращает false,
// если была нажата Отмена. Выбранная работа - текущая позиция
// в наборе данных.
function ExecJobListForm(ListSource: TDataSource): boolean;

implementation

{$R *.dfm}

function ExecJobListForm(ListSource: TDataSource): boolean;
begin
  Application.CreateForm(TJobListForm, JobListForm);
  try
    JobListForm.ListSource := ListSource;
    Result := JobListForm.ShowModal = mrOk;
  finally
    JobListForm.Free;
  end;
end;

procedure TJobListForm.FormCreate(Sender: TObject);
begin
  ListFrame := TRelatedProcessGridFrame.Create(Self);
  ListFrame.Parent := paJobList;
  ListFrame.Align := alClient;
  ListFrame.Top := 10;
  ListFrame.Name := 'frameList';
  ListFrame.ShowProcessState := false;
  ListFrame.ShowPartName := true;
  ListFrame.ShowOrderDate := true;

  ActiveControl := ListFrame.DBGrid;
end;

procedure TJobListForm.SetListSource(Value: TDataSource);
begin
  ListFrame.DBGrid.DataSource := Value;
end;

end.
