unit GridProp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvExControls, JvComponent, JvDBLookup, StdCtrls, Mask, DBCtrls,
  ExtCtrls, DB, DBClient, PmProcessCfg, JvExMask, JvSpin, JvDBSpinEdit;

type
  TGridPropForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    Label3: TLabel;
    btOk: TButton;
    btCancel: TButton;
    GroupBox2: TGroupBox;
    cb4: TDBCheckBox;
    cb12: TDBCheckBox;
    cb15: TDBCheckBox;
    edName: TDBEdit;
    edDesc: TDBEdit;
    cb11: TDBCheckBox;
    lkBaseGrid: TJvDBLookupCombo;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    lkTotal: TJvDBLookupCombo;
    Label5: TLabel;
    lkWorkTotal: TJvDBLookupCombo;
    Label6: TLabel;
    lkMatTotal: TJvDBLookupCombo;
    dsGrid: TDataSource;
    dsTotalFields: TDataSource;
    dsTempGrid: TDataSource;
    edGrpNum: TJvDBSpinEdit;
    lbGrpNum: TLabel;
    lbSrvPage: TLabel;
    lkSrvPage: TDBLookupComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btOkClick(Sender: TObject);
  private
    NewMode: boolean;
    FDataSet, FFieldsDS: TDataSet;
    //FDataSrc: TDataSource;
    cdTemp: TClientDataSet;
    //dsTemp: TDataSource;
    cdTotalFields: TClientDataSet;
    //dsTotalFields: TDataSource;
    FirstActive: boolean;
    FSrv: TPolyProcessCfg;
    //procedure SetSrc(Val: TDataSource);
    procedure UpdateControls;
  public
    //property DataSrc: TDataSource read FDataSrc write SetSrc;
    //property FieldsDataSet: TDataSet read FFieldsDS write FFieldsDS;
    property Srv: TPolyProcessCfg read FSrv write FSrv;
  end;

var
  GridPropForm: TGridPropForm;

function ExecGridProps({ds: TDataSource; }SrvProp: TPolyProcessCfg{; FieldsDataSet: TDataSet}): integer;

implementation

{$R *.dfm}

uses PmConfigManager;

const
  sNewGridCap = 'Новая таблица';
  sEditGridCap = 'Свойства таблицы';

function ExecGridProps({ds: TDataSource; }SrvProp: TPolyProcessCfg{; FieldsDataSet: TDataSet}): integer;
begin
  GridPropForm := TGridPropForm.Create(nil);
  try
    //GridPropForm.DataSrc := ds;
    GridPropForm.Srv := SrvProp;
    Result := GridPropForm.ShowModal;
  finally
    GridPropForm.Free;
  end;
end;

procedure TGridPropForm.FormCreate(Sender: TObject);
begin
  FirstActive := true;
end;

procedure TGridPropForm.FormActivate(Sender: TObject);
var
  i: integer;
begin
  if FirstActive then
  begin
    FFieldsDS := TConfigManager.Instance.ProcessFieldData.DataSet;
    FDataSet := TConfigManager.Instance.ProcessGridCfgData.DataSet;
    cdTemp := TClientDataSet.Create(nil);
    cdTemp.CloneCursor(FDataSet as TClientDataSet, true);
    //dsTemp := TDataSource.Create(nil);
    dsTempGrid.DataSet := cdTemp;
    cdTotalFields := TClientDataSet.Create(nil);
    cdTotalFields.CloneCursor(FFieldsDS as TClientDataSet, true);
    cdTotalFields.Filter := 'SrvID=' + IntToStr(FSrv.SrvID) + ' and CalcTotal';
    cdTotalFields.Filtered := true;
    //dsTotalFields := TDataSource.Create(nil);
    dsTotalFields.DataSet := cdTotalFields;
    FirstActive := false;
  end;
  NewMode := FDataSet.State = dsInsert;
  if NewMode then Caption := sNewGridCap
  else Caption := sEditGridCap;

  dsGrid.DataSet := FDataSet;

  lkBaseGrid.LookupSource := dsTempGrid;
  lkTotal.LookupSource := dsTotalFields;
  lkWorkTotal.LookupSource := dsTotalFields;
  lkMatTotal.LookupSource := dsTotalFields;
  UpdateControls;
end;

procedure TGridPropForm.FormDestroy(Sender: TObject);
begin
  //if Assigned(dsTemp) then dsTemp.Free;
  if Assigned(cdTemp) then cdTemp.Free;
  if Assigned(dsTotalFields) then dsTotalFields.Free;
  if Assigned(cdTotalFields) then cdTotalFields.Free;
end;

procedure TGridPropForm.UpdateControls;
begin
  //btStruct.Enabled := VarIsNull(FDataSet[GridBaseGridField]) or (FDataSet[GridBaseGridField] <= 0);
  // Изменение базовой таблицы разрешено только при создании таблицы
  lkBaseGrid.Enabled := NewMode;
end;

procedure TGridPropForm.btOkClick(Sender: TObject);
begin
  if (edDesc.Text = '') or (edName.Text = '') then ModalResult := mrNone;
end;

{procedure TGridPropForm.SetSrc(Val: TDataSource);
begin
  FDataSrc := Val;
  FDataSet := FDataSrc.DataSet;
end;}

end.
