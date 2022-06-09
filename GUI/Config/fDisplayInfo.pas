unit fDisplayInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGridEh, MyDBGridEh, DB, StdCtrls, ExtCtrls, Buttons,
  PmEntity, GridsEh;

type
  TEditCommonInfoForm = class(TForm)
    paLeft: TPanel;
    Panel1: TPanel;
    dgInfo: TMyDBGridEh;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    btOk: TButton;
    btCancel: TButton;
    Button1: TButton;
    Button2: TButton;
    sbUp: TSpeedButton;
    sbDown: TSpeedButton;
  private
    InfoData: TEntity;
    InfoSource: TDataSource;
  public
    constructor Create(_InfoData: TEntity);
  end;

var
  EditCommonInfoForm: TEditCommonInfoForm;

function ExecCommonInfoEditor(InfoData: TEntity): boolean;

implementation

{$R *.dfm}

function ExecCommonInfoEditor(InfoData: TEntity): boolean;
begin
  EditCommonInfoForm := TEditCommonInfoForm.Create(InfoData);
  try
    Result := EditCommonInfoForm.ShowModal = mrOk;
  finally
    FreeAndNil(EditCommonInfoForm);
  end;
end;

constructor TEditCommonInfoForm.Create(_InfoData: TEntity);
begin
  inherited Create(nil);
  InfoData := _InfoData;
  InfoSource := TDataSource.Create(Self);
  InfoSource.DataSet := InfoData.DataSet;
  dgInfo.DataSource := InfoSource;
  InfoData.Open;
end;

end.
