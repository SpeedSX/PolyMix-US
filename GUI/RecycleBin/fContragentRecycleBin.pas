unit fContragentRecycleBin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseRecycleBin, Menus, StdCtrls, Buttons, ExtCtrls, Grids,
  DBGridEh, MyDBGridEh, PmRecycleBin, jvFormPlacement, GridsEh,

  PmEntity, DBGridEhGrouping;

type
  TContragentRecycleBinFrame = class(TBaseRecycleBinFrame)
  protected
    procedure SetupGrid; override;
    procedure SaveSettings; override;
    procedure LoadSettings; override;
  public
    constructor Create(Owner: TComponent; _RecyleBin: TEntity); override;
    procedure UpdateButtons(Sender: TObject); override;
  end;

var
  ContragentRecycleBinFrame: TContragentRecycleBinFrame;

implementation

{$R *.dfm}

uses CalcUtils, CalcSettings, PmAccessManager;

constructor TContragentRecycleBinFrame.Create(Owner: TComponent; _RecyleBin: TEntity);
begin
  inherited Create(Owner, _RecyleBin{, 'ContragentRecycleBin'});
end;

procedure TContragentRecycleBinFrame.SetupGrid;
begin
  inherited;
  with dgBin.Columns.Add do
  begin
    FieldName := 'Name';
    Title.Caption := 'Имя';
    Width := 220;
  end;
  with dgBin.Columns.Add do
  begin
    FieldName := 'ContragentTypeName';
    Title.Caption := 'Вид';
    Width := 110;
  end;
  with dgBin.Columns.Add do
  begin
    FieldName := 'CreationDate';
    Title.Caption := 'Дата создания';
    Width := 85;
  end;
  with dgBin.Columns.Add do
  begin
    FieldName := 'UserName';
    Title.Caption := 'Пользователь';
    Width := 85;
  end;
  with dgBin.Columns.Add do
  begin
    FieldName := 'DeleteDate';
    Title.Caption := 'Дата удаления';
    Title.SortIndex := 1;
    Title.SortMarker := smDownEh;
    Width := 90;
  end;
end;

procedure TContragentRecycleBinFrame.SaveSettings;
begin
  //inherited SaveSettings;
  TSettingsManager.Instance.SaveGridLayout(dgBin, 'ContragentRecycleBin');
  //MainAppStorage.WriteInteger();
end;

procedure TContragentRecycleBinFrame.LoadSettings;
begin
  //inherited LoadSettings;
  TSettingsManager.Instance.LoadGridLayout(dgBin, 'ContragentRecycleBin');
end;

procedure TContragentRecycleBinFrame.UpdateButtons(Sender: TObject);
var
  e: boolean;
  CreateKinds: TIntArray;
begin
  //inherited UpdateButtons;
  e := RecycleBin.DataSet.IsEmpty;
  // право окончательного удаления определяется по праву редактирования пользователей
  btPurge.Enabled := not e and AccessManager.CurUser.EditUsers;
  btPurgeAll.Enabled := btPurge.Enabled;
  // право восстановления определяется по праву создания
  if not e then
  begin
    btRestore.Enabled := AccessManager.CurUser.AddCustomer
  end
  else
    btRestore.Enabled := false;
end;

end.
