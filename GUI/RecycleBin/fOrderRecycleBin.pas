unit fOrderRecycleBin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs, fBaseRecycleBin, Menus, StdCtrls, Buttons, ExtCtrls, GridsEh,
  DBGridEh, MyDBGridEh, JvFormPlacement,
  
  PmRecycleBin, PmEntity;

type
  TOrderRecycleBinFrame = class(TBaseRecycleBinFrame)
  private
    procedure dgBinGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      State: TGridDrawState);   
  protected
    procedure SetupGrid; override;
  public
    constructor Create(Owner: TComponent; _RecyleBin: TEntity); override;
    procedure UpdateButtons(Sender: TObject); override;
    procedure SaveSettings; override;
    procedure LoadSettings; override;
  end;

var
  OrderRecycleBinFrame: TOrderRecycleBinFrame;

implementation

{$R *.dfm}

uses CalcSettings, PmAccessManager, CalcUtils;

constructor TOrderRecycleBinFrame.Create(Owner: TComponent; _RecyleBin: TEntity);
begin
  inherited Create(Owner, _RecyleBin{, 'OrderRecycleBin'});
end;

procedure TOrderRecycleBinFrame.SetupGrid;
begin
  inherited;
  with dgBin.Columns.Add do
  begin
    FieldName := 'EntityName';
    Title.Caption := 'Наименование';
    Width := 119;
  end;
  with dgBin.Columns.Add do
  begin
    FieldName := 'CreationDate';
    Title.Caption := 'Дата создания';
    Width := 85;
  end;
  with dgBin.Columns.Add do
  begin
    FieldName := 'Comment';
    Title.Caption := 'Описание';
    Width := 163;
  end;
  with dgBin.Columns.Add do
  begin
    FieldName := 'CustomerName';
    Title.Caption := 'Заказчик';
    Width := 165;
  end;
  with dgBin.Columns.Add do
  begin
    FieldName := 'UserName';
    Title.Caption := 'Пользователь';
    Width := 81;
  end;
  with dgBin.Columns.Add do
  begin
    FieldName := 'DeleteDate';
    Title.Caption := 'Дата удаления';
    Title.SortIndex := 1;
    Title.SortMarker := smDownEh;
    Width := 93;
  end;
  dgBin.OnGetCellParams := dgBinGetCellParams;
end;

procedure TOrderRecycleBinFrame.SaveSettings;
begin
  //inherited SaveSettings;
  TSettingsManager.Instance.SaveGridLayout(dgBin, 'OrderRecycleBin');
  //MainAppStorage.WriteInteger();
end;

procedure TOrderRecycleBinFrame.LoadSettings;
begin
  //inherited LoadSettings;
  TSettingsManager.Instance.LoadGridLayout(dgBin, 'OrderRecycleBin');
end;

procedure TOrderRecycleBinFrame.dgBinGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if not Options.OrdStateRowColor then
  begin
    Background := TOrderRecycleBin(RecycleBin).RowColor;
    if Background = clBlack then AFont.Color := clWhite;
  end;
end;

procedure TOrderRecycleBinFrame.UpdateButtons(Sender: TObject);
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
    if TOrderRecycleBin(RecycleBin).IsDraft then
      CreateKinds := AccessManager.GetPermittedKinds(AccessManager.CurUser.ID, 'DraftCreate')
    else
      CreateKinds := AccessManager.GetPermittedKinds(AccessManager.CurUser.ID, 'WorkCreate');
    btRestore.Enabled := IntInArray(TOrderRecycleBin(RecycleBin).KindID, CreateKinds);
  end
  else
    btRestore.Enabled := false;
end;

end.
