unit PmMatRequestForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseEditForm, DB, DBCtrls, StdCtrls, Mask, JvComponentBase,
  JvFormPlacement, PmMaterials, JvExMask, JvToolEdit, JvDBControls, DBGridEh,
  DBCtrlsEh, DBLookupEh;

type
  TMaterialRequestEditForm = class(TBaseEditForm)
    edMatDesc: TDBEdit;
    Label1: TLabel;
    gbCalc: TGroupBox;
    Label2: TLabel;
    edMatAmount: TDBEdit;
    lbMatUnitName: TDBText;
    edMatCost: TDBEdit;
    lbMatCost: TLabel;
    GroupBox1: TGroupBox;
    lbFactMatAmount: TLabel;
    lbFactMatUnitName: TDBText;
    lbFactMatCost: TLabel;
    edFactMatAmount: TDBEdit;
    edFactMatCost: TDBEdit;
    lbPlanDate: TLabel;
    dePlanDate: TJvDBDateEdit;
    lbFactDate: TLabel;
    deFactDate: TJvDBDateEdit;
    lbMatCostGrn: TLabel;
    lbFactMatCostGrn: TLabel;
    cbSupplier: TDBLookupComboBox;
    lbSupplier: TLabel;
    dsSuppliers: TDataSource;
    dePayDate: TJvDBDateEdit;
    lbPayDate: TLabel;
    cbFactMat: TDBLookupComboboxEh;
    lbFactMat: TLabel;
    btFindFact: TButton;
    dsMaterials: TDataSource;
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    FMaterials: TMaterials;
    FReadOnly, FFactReadOnly: boolean;
    FShowCost, FShowFactCost: boolean;
    WasActive: boolean;
    procedure SetMaterials(Value: TMaterials);
    procedure SetReadOnly(Value: boolean);
    procedure SetFactReadOnly(Value: boolean);
    procedure SetShowCost(Value: boolean);
    procedure SetShowFactCost(Value: boolean);
    procedure ApplyReadOnly;
  public
    property Materials: TMaterials read FMaterials write SetMaterials;
    property ReadOnly: boolean read FReadOnly write SetReadOnly;
    property FactReadOnly: boolean read FFactReadOnly write SetFactReadOnly;
    property ShowCost: boolean read FShowCost write SetShowCost;
    property ShowFactCost: boolean read FShowFactCost write SetShowFactCost;
  end;

function ExecMaterialRequestForm(_Materials: TMaterials; _ReadOnly, _FactReadOnly,
  _ShowCost, _ShowFactCost: boolean): boolean;

implementation

uses CalcSettings, PmProcess, PmContragent, PmConfigManager;

{$R *.dfm}

function ExecMaterialRequestForm(_Materials: TMaterials; _ReadOnly, _FactReadOnly,
  _ShowCost, _ShowFactCost: boolean): boolean;
var
  MaterialRequestEditForm: TMaterialRequestEditForm;
begin
  MaterialRequestEditForm := TMaterialRequestEditForm.Create(nil);
  try
    MaterialRequestEditForm.Materials := _Materials;
    MaterialRequestEditForm.ReadOnly := _ReadOnly;
    MaterialRequestEditForm.FactReadOnly := _FactReadOnly;
    MaterialRequestEditForm.ShowCost := _ShowCost;
    MaterialRequestEditForm.ShowFactCost := _ShowFactCost;
    Result := MaterialRequestEditForm.ShowModal = mrOk;
  finally
    MaterialRequestEditForm.Free;
  end;
end;

procedure TMaterialRequestEditForm.FormCreate(Sender: TObject);
begin
  inherited;
  //btSelectProduct.Glyph := GetSyncStateImage(SyncState_Syncronized);
  dsMaterials.DataSet := TConfigManager.Instance.StandardDics.deExternalMaterials.DicItems;
end;

procedure TMaterialRequestEditForm.FormActivate(Sender: TObject);
begin
  if not WasActive then
  begin
    ApplyReadOnly;

    if FReadOnly then
      ActiveControl := btOk
    else
    if dePlanDate.Field.IsNull then
      ActiveControl := dePlanDate
    else
    if deFactDate.Field.IsNull then
      ActiveControl := deFactDate
    else
    if FShowCost and FShowFactCost and edFactMatCost.Field.IsNull then
      ActiveControl := edFactMatCost
    else
      ActiveControl := btOk;
    WasActive := true;
  end;
end;

procedure TMaterialRequestEditForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  ActiveControl := btOk;
  {if ModalResult = mrOk then
    cbSupplier.CloseUp(true);}
  inherited;
end;

procedure TMaterialRequestEditForm.SetMaterials(Value: TMaterials);
begin
  FMaterials := Value;
  edMatDesc.DataSource := FMaterials.DataSource;
  edMatAmount.DataSource := FMaterials.DataSource;
  edFactMatAmount.DataSource := FMaterials.DataSource;
  lbMatUnitName.DataSource := FMaterials.DataSource;
  lbFactMatUnitName.DataSource := FMaterials.DataSource;
  if not Options.ShowFinalNative then
    edMatCost.DataField := TMaterials.F_MatCost;
  edMatCost.DataSource := FMaterials.DataSource;
  edFactMatCost.DataSource := FMaterials.DataSource;
  dePlanDate.DataSource := FMaterials.DataSource;
  deFactDate.DataSource := FMaterials.DataSource;
  cbSupplier.DataSource := FMaterials.DataSource;
  dsSuppliers.DataSet := Suppliers.DataSet;
  dePayDate.DataSource := FMaterials.DataSource;
  cbFactMat.DataSource := FMaterials.DataSource;
  Suppliers.Reload;
end;

procedure TMaterialRequestEditForm.SetReadOnly(Value: boolean);
begin
  FReadOnly := Value;
  ApplyReadOnly;
end;

procedure TMaterialRequestEditForm.SetFactReadOnly(Value: boolean);
begin
  FFactReadOnly := Value;
  ApplyReadOnly;
end;

procedure TMaterialRequestEditForm.SetShowCost(Value: boolean);
begin
  FShowCost := Value;
  edMatCost.Visible := FShowCost;
  edFactMatCost.Visible := FShowCost;
  lbMatCost.Visible := FShowCost;
  lbMatCostGrn.Visible := FShowCost;
  lbFactMatCost.Visible := FShowCost;
  lbFactMatCostGrn.Visible := FShowCost;
end;

procedure TMaterialRequestEditForm.SetShowFactCost(Value: boolean);
begin
  FShowFactCost := Value;
  edFactMatCost.Visible := FShowFactCost;
  lbFactMatCost.Visible := FShowFactCost;
  lbFactMatCostGrn.Visible := FShowFactCost;
  edFactMatAmount.Visible := FShowFactCost;
  lbFactMatAmount.Visible := FShowFactCost;
  cbSupplier.Visible := FShowFactCost;
  lbSupplier.Visible := FShowFactCost;
  lbFactMatUnitName.Visible := FShowFactCost;
  lbFactMat.Visible := FShowFactCost;
  cbFactMat.Visible := FShowFactCost;
  lbPayDate.Visible := FShowCost;
  dePayDate.Visible := FShowCost;
end;

procedure TMaterialRequestEditForm.ApplyReadOnly;
begin
  edFactMatAmount.ReadOnly := FReadOnly or FFactReadOnly;
  edFactMatCost.ReadOnly := FReadOnly or FFactReadOnly;
  dePlanDate.ReadOnly := FReadOnly or FFactReadOnly;
  deFactDate.ReadOnly := FReadOnly or FFactReadOnly;
  cbSupplier.ReadOnly := FReadOnly;
  dePayDate.ReadOnly := FReadOnly;
  cbFactMat.ReadOnly := FReadOnly or FFactReadOnly;
end;

end.
