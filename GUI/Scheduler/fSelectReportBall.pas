unit fSelectReportBall;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, StdCtrls, Mask, JvExMask, JvToolEdit;

type
  TSelectReportBallForm = class(TForm)
    Label1: TLabel;
    cbDepartment: TComboBox;
    deStart: TJvDateEdit;
    Label2: TLabel;
    Label3: TLabel;
    deEnd: TJvDateEdit;
    btOk: TButton;
    btCancel: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TSelectReportBallResult = record
    Ok: boolean;
    Department: integer;
    DateStart, DateEnd: TDateTime;
  end;

//var
//  SelectReportBallResult: TSelectReportBallResult;

function ExecSelectReportBallForm: TSelectReportBallResult;

implementation

uses DicObj, StdDic, PmConfigManager, RDBUtils, DB;

{$R *.dfm}

var
  SelectReportBallForm: TSelectReportBallForm;

function ExecSelectReportBallForm: TSelectReportBallResult;
var
  ItemN: integer;
  de: TDictionary;
  ds: TDataSet;
begin
  SelectReportBallForm := TSelectReportBallForm.Create(nil);
  try
    de := TConfigManager.Instance.StandardDics.deDepartments;
    ds := de.DicItems;
    ds.First;
    while not ds.eof do
    begin
      if NvlBoolean(ds['Visible']) then
        SelectReportBallForm.cbDepartment.Items.Add(ds['Name']);
      ds.Next;
    end;

    if SelectReportBallForm.ShowModal = mrOk then
    begin
      ItemN := SelectReportBallForm.cbDepartment.ItemIndex;
      if ItemN <> -1 then
      begin
        Result.Ok := true;
        Result.Department := de.ItemCode[SelectReportBallForm.cbDepartment.Items[SelectReportBallForm.cbDepartment.ItemIndex]];
        Result.DateStart := SelectReportBallForm.deStart.Date;
        Result.DateEnd := SelectReportBallForm.deEnd.Date;
      end;
    end;
  finally
    SelectReportBallForm.Free;
  end;
end;

procedure TSelectReportBallForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := (ModalResult = mrCancel) or
   (cbDepartment.ItemIndex >= 0) and (deStart.Date > 0) and (deEnd.Date > deStart.Date); 
end;

end.
