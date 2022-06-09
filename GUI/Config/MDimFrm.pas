unit MDimFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, JvDBControls, ExtCtrls, DB,
  DBClient, Variants, JvExControls, JvComponent, JvDBLookup, 
  DicObj, PmDictionaryList, GridsEh, DBGridEh, MyDBGridEh;

type
  TMultiDimForm = class(TForm)
    Panel1: TPanel;
    btOk: TButton;
    btCancel: TButton;
    btApply: TButton;
    Panel2: TPanel;
    dgItems: TMyDBGridEh;
    paDim: TPanel;
    CheckBox1: TCheckBox;
    RxDBLookupCombo1: TJvDBLookupCombo;
    dsItems: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CheckBoxClick(Sender: TObject);
    procedure LookupComboChange(Sender: TObject);
    procedure btApplyClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FDic: TDictionary;
    Combos: TList;
    Boxes: TList;
    DSs: TList;
    DimDics: TList;
    procedure RefreshMultiQuery;
    procedure SetupGrid;
  protected
    procedure SetDic(_Dic: TDictionary);
  public
    //procedure SetupControls;
    property Dictionary: TDictionary read FDic write SetDic;
  end;

function ExecMultiDimForm(Dic: TDictionary): boolean;

implementation

{$R *.DFM}

uses PmConfigManager;

function ExecMultiDimForm(Dic: TDictionary): boolean;
var
  MultiDimForm: TMultiDimForm;
begin
  Application.CreateForm(TMultiDimForm, MultiDimForm);
  try
    //MultiDimForm.SetupControls;
    MultiDimForm.Dictionary := Dic;
    Result := MultiDimForm.ShowModal = mrOk;
  finally
    FreeAndNil(MultiDimForm);
  end;
end;

procedure TMultiDimForm.SetDic(_Dic: TDictionary);
var
  dcc, i: integer;
  rxl: TJvDBLookupCombo;
  cbx: TCheckBox;
  mde: TDictionary;
  ds: TDataSource;
begin
  FDic := _Dic;
  
  dsItems.DataSet := FDic.MultiItems;
  dcc := FDic.ItemCount;
  paDim.Height := dcc * 28 + 10;

  for i := 1 to dcc do
  begin    // по всем размерностям
    mde := TConfigManager.Instance.DictionaryList[FDic.Name + '_' + FDic.ItemValue[i, 1]];  // размерность
    if mde = nil then continue;   // ошибка, но без сообщения
    DimDics.Add(mde);
    ds := TDataSource.Create(Self);
    ds.DataSet := mde.DicItems;
    DSs.Add(ds);   // этот список не используется

    rxl := TJvDBLookupCombo.Create(Self);
    Combos.Add(rxl);
    RemoveControl(rxl);
    paDim.InsertControl(rxl);
    rxl.Top := 10 + (i - 1) * 28;
    rxl.Left := 125;
    rxl.Width := paDim.Width - 125 - 10;
    rxl.Tag := i;  // не используется
    rxl.OnChange := LookupComboChange;
    rxl.DisplayEmpty := '< нет значения >';
    rxl.LookupSource := ds;
    rxl.LookupField := F_DicItemCode;
    rxl.LookupDisplay := F_DicItemName;
    rxl.Enabled := false;

    cbx := TCheckBox.Create(Self);
    Boxes.Add(cbx);
    RemoveControl(cbx);
    paDim.InsertControl(cbx);
    cbx.Top := 12 + (i - 1) * 28;
    cbx.Left := 12;
    cbx.Width := 113;
    cbx.Caption := FDic.ItemName[i];
    cbx.Tag := i;  // потом найдем по этому тагу нужную размерность в DimDics
    cbx.OnClick := CheckBoxClick;
  end;

  RefreshMultiQuery;
end;

procedure TMultiDimForm.FormCreate(Sender: TObject);
begin
  Combos := TList.Create;
  Boxes := TList.Create;
  DSs := TList.Create;
  DimDics := TList.Create;
end;

procedure TMultiDimForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Combos);
  FreeAndNil(Boxes);
  FreeAndNil(DSs);
  FreeAndNil(DimDics);
end;

procedure TMultiDimForm.CheckBoxClick(Sender: TObject);
var wc: TWinControl;
begin
  wc := Combos[(Sender as TWinControl).Tag - 1];
  wc.Enabled := (Sender as TCheckBox).Checked;
  RefreshMultiQuery;
end;

procedure TMultiDimForm.LookupComboChange(Sender: TObject);
begin
  RefreshMultiQuery;
end;

// устнавливает заголовки столбцов таблицы
procedure TMultiDimForm.SetupGrid;
var
  cbx: TJvDBLookupCombo;
  Cols: TDBGridColumnsEh;
  i, k: integer;
  n: string;
begin
  Cols := dgItems.Columns;
  Cols.RebuildColumns;
  Cols[0].Title.Caption := '#';
  Cols[0].Color := clBtnFace;
  Cols[0].Width := 25;
  // поля измерений
  for i := 1 to FDic.ItemCount do
  begin
    Cols[i].Title.Caption := FDic.ItemName[i];
    cbx := Combos[i - 1];
    Cols[i].Visible := not cbx.Enabled or VarIsNull(cbx.KeyValue);
  end;
  // теперь идут поля данных
  for i := 0 to Pred(FDic.DicFields.Count) do
  begin
    // вырезаем из имени поля его номер
    n := FDic.DicFields[i];
    k := StrToInt(Copy(n, Length(F_DicItemValue) + 1, Length(n) - 1));
    Cols[FDic.ItemCount + k].Title.Caption :=
      (FDic.DicFields.Objects[i] as TFieldDesc).FieldDesc;
  end;
end;

procedure TMultiDimForm.RefreshMultiQuery;
begin
  TConfigManager.Instance.DictionaryList.ApplyMultiData(FDic);
  TConfigManager.Instance.DictionaryList.RefreshMultiData(FDic, Combos);
  SetupGrid;
end;

procedure TMultiDimForm.btApplyClick(Sender: TObject);
begin
  RefreshMultiQuery;
end;

procedure TMultiDimForm.btCancelClick(Sender: TObject);
begin
  (FDic.MultiItems as TClientDataSet).CancelUpdates;
end;

procedure TMultiDimForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TConfigManager.Instance.DictionaryList.ApplyMultiData(FDic);
  TConfigManager.Instance.DictionaryList.RefreshMultiData(FDic, nil);   // загрузить все записи
end;

end.
