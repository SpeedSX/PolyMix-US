unit coursfrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, TeeProcs, TeEngine, Chart, DBChart, Db, Series,
  ComCtrls, Buttons, StdCtrls, DBClient, MainData,
  MyDBGridEh, GridsEh, DBGridEh, DBGridEhGrouping;

type
  TCourseForm = class(TForm)
    dsDollar: TDataSource;
    PageControl1: TPageControl;
    pgTable: TTabSheet;
    pgChart: TTabSheet;
    DBChart1: TDBChart;
    Series1: TLineSeries;
    dqDollar: TClientDataSet;
    dgDollar: TMyDBGridEh;
    Panel1: TPanel;
    CloseBtn: TSpeedButton;
    btClearDollar: TBitBtn;
    btDelDollar: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseBtnClick(Sender: TObject);
    procedure btDelDollarClick(Sender: TObject);
    procedure btClearDollarClick(Sender: TObject);
    procedure RefreshDollar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CourseForm: TCourseForm;

procedure ExecCourseForm;

implementation

uses RDialogs, ExHandler, PmDatabase;

{$R *.DFM}

procedure ExecCourseForm;
begin
  try
    Application.CreateForm(TCourseForm, CourseForm);
//    CourseForm.dqDollar.ProviderName := dm.pvUSD.Name;
    CourseForm.ShowModal;
  finally
    FreeAndNil(CourseForm);
  end;
end;

procedure TCourseForm.FormActivate(Sender: TObject);
begin
  dqDollar.SetProvider(dm.pvUSD);
  Database.OpenDataSet(dqDollar);
  Series1.DataSource := dqDollar;
  Series1.XLabelsSource := 'DateOnly';
  Series1.XValues.ValueSource := 'Date';
  Series1.YValues.ValueSource := 'Value';
//    DBChart1.RefreshData;
end;

procedure TCourseForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dqDollar.Active := false;
end;

procedure TCourseForm.CloseBtnClick(Sender: TObject);
begin
  dqDollar.Active := false;
  Close;
end;

procedure TCourseForm.RefreshDollar;
var
  i: integer;
{  DMin, DMax: extended;

  procedure FindMinMax;
  begin
    DMin := 1;
    DMax := 1;
    if not dqDollar.Active or dqDollar.IsEmpty then Exit;
    dqDollar.DisableControls;
    try
      dqDollar.First;
      while not dqDollar.EOF do begin
        try
          if DMin > dqDollar['Value'] then DMin := dqDollar['Value'];
          if DMax < dqDollar['Value'] then DMax := dqDollar['Value'];
        except end;
        dqDollar.Next;
      end;
    finally
      dqDollar.EnableControls;
    end;
  end;}

begin
    i := dqDollar['ID'];
    dqDollar.Close;
    dqDollar.SetProvider(dm.pvUSD);
    Database.OpenDataSet(dqDollar);
{    FindMinMax;
    DBChart1.LeftAxis.Minimum := DMin;
    DBChart1.LeftAxis.Maximum := DMax;}
    if not dqDollar.Locate('ID', i, []) then dqDollar.Last;
    //if EntSettings.GetCourseOnStart then AppController.RequestUSDCourse;
    DBChart1.RefreshData;
end;

// ЭТО НА СЕРВЕРЕ !!!!!!!!!!!!!!!!!!!!!!!!!
procedure TCourseForm.btDelDollarClick(Sender: TObject);
begin
  if dqDollar.Active and not dqDollar.IsEmpty then begin
    try
      if not Database.InTransaction then Database.BeginTrans;
      Database.ExecuteNonQuery('DELETE Dollar WHERE ID = ' + IntToStr(dqDollar['ID']));
      Database.CommitTrans;
    except
      on E: Exception do begin
        Database.RollbackTrans;
        ExceptionHandler.Raise_(E);
      end;
    end;
    RefreshDollar;
  end;
end;

// ЭТО НА СЕРВЕРЕ !!!!!!!!!!!!!!!!!!!!!!!!!
procedure TCourseForm.btClearDollarClick(Sender: TObject);
begin
  if dqDollar.Active and not dqDollar.IsEmpty then begin
    if RusMessageDlg('Вы действительно хотите очистить таблицу курсов доллара?', mtConfirmation,
       [mbYes, mbNo], 0) <> mrYes then Exit;
    try
      if not Database.InTransaction then Database.BeginTrans;
      Database.ExecuteNonQuery('TRUNCATE TABLE Dollar');
      Database.CommitTrans;
    except
      on E: EDatabaseError do begin
        Database.RollbackTrans;
        ExceptionHandler.Raise_(E);
      end;
    end;
    RefreshDollar;
  end;
end;

end.
