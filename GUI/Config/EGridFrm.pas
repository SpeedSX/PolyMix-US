unit EGridFrm;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Dialogs,
  StdCtrls, JvDBSpinEdit, JvColorCombo,
  ServData, DBCtrls, JvDBCombobox, DB, Buttons, ExtCtrls, Variants,
  JvJCLUtils, GridsEh, DBGridEh, MyDBGridEh, Controls, JvExStdCtrls, JvCombobox,
  Mask, JvExMask, JvSpin, PmProcessCfg;

type
  TEditProcessGridForm = class(TForm)
    btOk: TButton;
    btCancel: TButton;
    Label1: TLabel;
    vgDBSpinEdit1: TjvDBSpinEdit;
    cldbColor: TjvColorComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DBEdit1: TDBEdit;
    Label5: TLabel;
    RxDBComboBox1: TJvDBComboBox;
    cbField: TDBLookupComboBox;
    Label6: TLabel;
    DBCheckBox1: TDBCheckBox;
    Label7: TLabel;
    RxDBComboBox2: TJvDBComboBox;
    cldbCaptionColor: TjvColorComboBox;
    cldbFontColor: TjvColorComboBox;
    cldbCaptionFontColor: TjvColorComboBox;
    Label8: TLabel;
    DBCheckBox2: TDBCheckBox;
    Label9: TLabel;
    Label10: TLabel;
    btNew: TSpeedButton;
    btDel: TSpeedButton;
    btClear: TSpeedButton;
    btAddAll: TSpeedButton;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox5: TDBCheckBox;
    DBCheckBox6: TDBCheckBox;
    Label11: TLabel;
    Bevel1: TBevel;
    DBCheckBox7: TDBCheckBox;
    cbShowEditButton: TDBCheckBox;
    DBCheckBox8: TDBCheckBox;
    dgCols: TMyDBGridEh;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cldbFontColorCloseUp(Sender: TObject);
    procedure cldbColorCloseUp(Sender: TObject);
    procedure cldbCaptionFontColorCloseUp(Sender: TObject);
    procedure cldbCaptionColorCloseUp(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cdColsAfterScroll(DataSet: TDataSet);
    procedure btNewClick(Sender: TObject);
    procedure btDelClick(Sender: TObject);
    procedure btClearClick(Sender: TObject);
    procedure cbFieldCloseUp(Sender: TObject);
    procedure cdColsAfterInsert(DataSet: TDataSet);
    procedure cdColsAfterDelete(DataSet: TDataSet);
    procedure cdColsBeforeInsert(DataSet: TDataSet);
    procedure btAddAllClick(Sender: TObject);
    procedure dgColsGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
  private
    NewColNumber: integer;
    FSettingBoxes: boolean;
    procedure SetColor(FName: string; ColorVal: TColor);
    procedure SetControlsEnabled;
  public
    SrvID: integer;
    GridID: integer;
  end;

var
  EditProcessGridForm: TEditProcessGridForm;

function ExecEditGridForm(SrvID, GridID: integer): integer;

implementation

uses DataHlp, PmProcess;

{$R *.DFM}

function ExecEditGridForm(SrvID, GridID: integer): integer;
begin
  Application.CreateForm(TEditProcessGridForm, EditProcessGridForm);
  try
    EditProcessGridForm.SrvID := SrvID;
    EditProcessGridForm.GridID := GridID;
    Result := EditProcessGridForm.ShowModal;
  finally
    EditProcessGridForm.Free;
  end;
end;

procedure TEditProcessGridForm.FormCreate(Sender: TObject);
begin
{
clBlack = Черный
clMaroon = Темно-красный
clGreen = Заленый
clOlive = Оливковый
clNavy = Темно-синий
clPurple = Фиолетовый
clTeal = Морской
clGray = Серый
clSilver = Серебряный
clRed = Красный
clLime = Лимон
clYellow = Желтый
clBlue = Синий
clFuchsia = Малиновый
clAqua = Аква
clWhite = Белый
clScrollBar = Полоса прокрутки
clBackground = Фон
clActiveCaption = Заголовок
clInactiveCaption = Неактивный заголовок
clMenu = Меню
clWindow = Фон окна
clWindowFrame = Рамка окна
clMenuText = Тест меню
clWindowText = Текст окна
clCaptionText = Текст заголовка
clActiveBorder = Активная рамка
clInactiveBorder = Неактивная рамка
clAppWorkSpace = Рабочее пространство
clHighlight = Выделение
clHighlightText = Выделенный текст
clBtnFace = Кнопка
clBtnShadow = Тень кнопки
clGrayText = Серый текст
clBtnText = Текст кнопки
clInactiveCaptionText = Текст неактивного заголовка
clBtnHighlight = Выделенная кнопка
clDkShadow3D = 3D тень
clLight3D = 3D свет
clInfoText = Инфо-текст
clInfoBk = Инфо-панель
clNone = Нет
clCustom = Другой...
clDefault = По умолчанию
}
  cldbFontColor.ColorNameMap.Assign(cldbColor.ColorNameMap);
  cldbCaptionFontColor.ColorNameMap.Assign(cldbColor.ColorNameMap);
  cldbCaptionColor.ColorNameMap.Assign(cldbColor.ColorNameMap);
  sdm.cdSrvGridCols.AfterScroll := cdColsAfterScroll;
  sdm.cdSrvGridCols.AfterInsert := cdColsAfterInsert;
  sdm.cdSrvGridCols.BeforeInsert := cdColsBeforeInsert;
  sdm.cdSrvGridCols.AfterDelete := cdColsAfterDelete;
  try Caption := Caption + ' ''' + sdm.cdServices['SrvDesc'] + ''''; except end;
  FSettingBoxes := false;
end;

procedure TEditProcessGridForm.FormDestroy(Sender: TObject);
begin
  sdm.cdSrvGridCols.AfterScroll := nil;
  sdm.cdSrvGridCols.AfterInsert := nil;
  sdm.cdSrvGridCols.BeforeInsert := nil;
  sdm.cdSrvGridCols.AfterDelete := nil;
end;

procedure TEditProcessGridForm.dgColsGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
var
  Field: TField;
  Highlight: boolean;
begin
  try
    Field := Column.Field;
    Highlight := (gdSelected in State) and (gdFocused in State);
    if (Field <> nil) and not VarIsNull(Field.DataSet['Color']) and not Highlight then
      Background := Field.DataSet['Color'];
    if (Field <> nil) and not VarIsNull(Field.DataSet['FontColor']) and not Highlight then
      AFont.Color := Field.DataSet['FontColor'];
  except
    // мало ли что... а исключение на отрисовке - это обычно неприятно
  end;
end;

procedure TEditProcessGridForm.cdColsAfterScroll(DataSet: TDataSet);
begin
  DataSet.CheckBrowseMode;
  if not DataSet.IsEmpty then begin
    FSettingBoxes := true;
    try
      cldbColor.ColorValue := DataSet['Color'];
      cldbFontColor.ColorValue := DataSet['FontColor'];
      cldbCaptionColor.ColorValue := DataSet['CaptionColor'];
      cldbCaptionFontColor.ColorValue := DataSet['CaptionFontColor'];
    finally
      FSettingBoxes := false;
    end;
  end;
end;

procedure TEditProcessGridForm.cldbFontColorCloseUp(Sender: TObject);
begin
  if not FSettingBoxes then
    SetColor('FontColor', cldbFontColor.ColorValue);
end;

procedure TEditProcessGridForm.cldbColorCloseUp(Sender: TObject);
begin
  if not FSettingBoxes then
    SetColor('Color', cldbColor.ColorValue);
end;

procedure TEditProcessGridForm.cldbCaptionFontColorCloseUp(Sender: TObject);
begin
  if not FSettingBoxes then
    SetColor('CaptionFontColor', cldbCaptionFontColor.ColorValue);
end;

procedure TEditProcessGridForm.cldbCaptionColorCloseUp(Sender: TObject);
begin
  if not FSettingBoxes then
    SetColor('CaptionColor', cldbCaptionColor.ColorValue);
end;

procedure TEditProcessGridForm.SetColor(FName: string; ColorVal: TColor);
begin
  if not sdm.cdSrvGridCols.Active or sdm.cdSrvGridCols.IsEmpty then Exit;
  if not (sdm.cdSrvGridCols.State in [dsInsert, dsEdit]) then sdm.cdSrvGridCols.Edit;
  sdm.cdSrvGridCols[FName] := ColorVal;
end;

procedure TEditProcessGridForm.FormActivate(Sender: TObject);
begin
  sdm.cdSrvGridCols.CheckBrowseMode;
  sdm.cdSrvGridCols.Filter := 'GridID = ' + IntToStr(GridID);
  sdm.cdSrvGridCols.Filtered := true;
  sdm.cdSrvFieldInfo.Filter := 'SrvID = ' + IntToStr(SrvID);
  sdm.cdSrvFieldInfo.Filtered := true;
  cdColsAfterScroll(sdm.cdSrvGridCols);
  SetControlsEnabled;
end;

procedure TEditProcessGridForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  sdm.cdSrvGridCols.Filtered := false;
  sdm.cdSrvFieldInfo.Filtered := false;
end;

procedure TEditProcessGridForm.SetControlsEnabled;
var p: boolean;
begin
  p := sdm.cdSrvGridCols.Active and not sdm.cdSrvGridCols.IsEmpty;
  cldbColor.Enabled := p;
  cldbFontColor.Enabled := p;
  cldbCaptionColor.Enabled := p;
  cldbCaptionFontColor.Enabled := p;
end;

procedure TEditProcessGridForm.btNewClick(Sender: TObject);
begin
  if sdm.cdSrvGridCols.Active then sdm.cdSrvGridCols.Append;
end;

procedure TEditProcessGridForm.btDelClick(Sender: TObject);
begin
  if sdm.cdSrvGridCols.Active and not sdm.cdSrvGridCols.IsEmpty then
    sdm.cdSrvGridCols.Delete;
end;

procedure TEditProcessGridForm.btClearClick(Sender: TObject);
begin
  if sdm.cdSrvGridCols.Active then
    sdm.cdSrvGridCols.EmptyDataSet;
    //VeryEmptyTable(sdm.cdSrvGridCols);
end;

procedure TEditProcessGridForm.cdColsBeforeInsert(DataSet: TDataSet);
begin
  NewColNumber := CalcNewFieldValue(DataSet, 'ColNumber', 0);
end;

procedure TEditProcessGridForm.cdColsAfterInsert(DataSet: TDataSet);
begin
  if not (DataSet.State in [dsEdit, dsInsert]) then DataSet.Edit;
  DataSet[F_GridID] := GridID;
  DataSet['ColNumber'] := NewColNumber;
  DataSet['Color'] := clWindow;
  SetControlsEnabled;
end;

procedure TEditProcessGridForm.cdColsAfterDelete(DataSet: TDataSet);
begin
  SetControlsEnabled;
end;

procedure TEditProcessGridForm.cbFieldCloseUp(Sender: TObject);
var cd: TDataSet;
begin
  cd := sdm.cdSrvGridCols;
  if cd.Active and not sdm.cdSrvFieldInfo.IsEmpty then begin
    if not (cd.State in [dsEdit, dsInsert]) then cd.Edit;
    cd['Alignment'] := GetFieldAlignment(sdm.cdSrvFieldInfo['FieldType']);
  end;
end;

procedure TEditProcessGridForm.btAddAllClick(Sender: TObject);
var
  k: integer;
  FName: string;
begin
  if not sdm.cdSrvFieldInfo.Active or not sdm.cdSrvGridCols.Active then Exit;
  sdm.cdSrvFieldInfo.First;
  while not sdm.cdSrvFieldInfo.eof do
  begin
    try
      FName := sdm.cdSrvFieldInfo['FieldName'];
      if not sdm.cdSrvGridCols.Locate('FieldName', FName, []) then
      begin
        k := sdm.cdSrvFieldInfo['SrvFieldID'];
        sdm.cdSrvGridCols.Append;
        // возвращаем текущую позицию на место, так как перепрыгнула из-за элементов управления
        sdm.cdSrvFieldInfo.Locate('SrvFieldID', k, []);
//        sdm.cdSrvGridCols['SrvID'] := sdm.cdServices['SrvID'];
        sdm.cdSrvGridCols.Edit;
        sdm.cdSrvGridCols['FieldName'] := FName;
        try
          sdm.cdSrvGridCols['Caption'] := sdm.cdSrvFieldInfo['FieldDesc'];
        except
          sdm.cdSrvGridCols['Caption'] := FName;
        end;
        sdm.cdSrvGridCols['Alignment'] := GetFieldAlignment(sdm.cdSrvFieldInfo['FieldType']);
        if IsWordPresent(FName, ProcessPredefFieldsStr, [',']) then
          sdm.cdSrvGridCols['ReadOnly'] := true;
        sdm.cdSrvGridCols.CheckBrowseMode;
      end;
    finally
      sdm.cdSrvFieldInfo.Next;
    end;
  end;
end;

end.
