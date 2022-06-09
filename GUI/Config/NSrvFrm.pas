unit NSrvFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, PmProcessCfg, DB, DataHlp, DBCtrls, Mask, Variants, DBCLient, ExtCtrls,
  JvExControls, JvComponent, JvDBLookup;

const
  sNewSrvCap = 'Новый процесс';
  sEditSrvCap = 'Свойства процесса';

type
  TSrvPropForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    btOk: TButton;
    btCancel: TButton;
    GroupBox1: TGroupBox;
    rbTable: TRadioButton;
    rbForm: TRadioButton;
    btStruct: TButton;
    rbSimple: TRadioButton;
    GroupBox2: TGroupBox;
    cb1: TDBCheckBox;
    cb2: TDBCheckBox;
    cb3: TDBCheckBox;
    cb9: TDBCheckBox;
    cb8: TDBCheckBox;
    edName: TDBEdit;
    edDesc: TDBEdit;
    cb13: TDBCheckBox;
    Bevel1: TBevel;
    cb14: TDBCheckBox;
    lkBaseSrv: TJvDBLookupCombo;
    Label3: TLabel;
    cb16: TDBCheckBox;
    cb17: TDBCheckBox;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox5: TDBCheckBox;
    gbUseInProfit: TGroupBox;
    rbFullCost: TRadioButton;
    rbNoCost: TRadioButton;
    rbScriptedCost: TRadioButton;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox6: TDBCheckBox;
    DBCheckBox7: TDBCheckBox;
    Label4: TLabel;
    edSequenceOrder: TDBEdit;
    Label5: TLabel;
    DBCheckBox8: TDBCheckBox;
    dsEquipGroup: TDataSource;
    lkEquipGroup: TJvDBLookupCombo;
    DBCheckBox9: TDBCheckBox;
    dsServices: TDataSource;
    DBCheckBox10: TDBCheckBox;
    procedure btStructClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lkBaseSrvChange(Sender: TObject);
  private
    FStructData: TClientDataSet;
    FSrvDS: TDataSet;
    //FSrvSrc: TDataSource;
    cdTempSrv: TClientDataSet;
    dsTempSrv: TDataSource;
    //FDicDataSource: TDataSource;
    FirstActive: boolean;
    //procedure SetSrvSrc(Val: TDataSource);
    procedure UpdateControls;
  public
    Srv: TPolyProcessCfg;

    // не используется
    //property DicDataSource: TDataSource read FDicDataSource write FDicDataSource;

    property StructData: TClientDataSet read FStructData write FStructData;
    //property SrvDataSrc: TDataSource read FSrvSrc write SetSrvSrc;
    function GetServiceKind: TProcessViewKind;
    //constructor Create(ASrv: TPolyProcess);
  end;

var
  SrvPropForm: TSrvPropForm;

function ExecSrvProps(var StructData: TClientDataSet; SrvProp: TPolyProcessCfg
//; SrvDataSrc, DicDataSrc: TDataSource
): integer;

implementation

{$R *.DFM}

uses ExHandler, DicStFrm, ServMod, StdDic, PmConfigManager, PmProcessCfgData;

function ExecSrvProps(var StructData: TClientDataSet; SrvProp: TPolyProcessCfg
//;  SrvDataSrc, DicDataSrc: TDataSource
): integer;
var
  ProcessCfgData: TProcessCfgData;
begin
  SrvPropForm := TSrvPropForm.Create(nil);
  try
    ProcessCfgData := TConfigManager.Instance.ProcessCfgData;
    if (ProcessCfgData.DataSet.State <> dsInsert)
         and not ProcessCfgData.Locate(SrvProp.SrvID) then
       ExceptionHandler.Raise_('ExecSrvProps: не найден процесс');
    // Создаем набор данных, описывающий структуру процесса
    if (StructData = nil)
      and not TConfigManager.Instance.CreateSrvStructData(StructData, SrvProp, false, SrvProp = nil) then Exit;
    SrvPropForm.StructData := StructData;
    SrvPropForm.Srv := SrvProp;
    Result := SrvPropForm.ShowModal;
    // StructData здесь не освобождается!
  finally
    SrvPropForm.Free;
  end;
end;

procedure TSrvPropForm.btStructClick(Sender: TObject);
begin
  if FSrvDS['ServiceKind'] = cskTable then
    ExecStructForm(FStructData, stService, cmClose);
end;

procedure TSrvPropForm.btOkClick(Sender: TObject);
begin
  if (edDesc.Text = '') or (edName.Text = '') then ModalResult := mrNone;
  if ModalResult = mrOk then
  begin
    if FSrvDS.State = dsInsert then
    try
      FSrvDS['ServiceKind'] := GetServiceKind;
    except end;
    //if not (FSrvDS.State in [dsInsert, dsEdit]) then FSrvDS.Edit;
    //FSrvDS['DefaultEquipGroupCode'] := lkEquipGroup.KeyValue;
  end;
end;

function TSrvPropForm.GetServiceKind: TProcessViewKind;
begin
  if rbTable.Checked then Result := cskTable
  else if rbSimple.Checked then Result := cskSimple
  else if rbForm.Checked then Result := cskForm
  else ExceptionHandler.Raise_('Неизвестный тип процесса');
end;

{procedure TSrvPropForm.SetSrvSrc(Val: TDataSource);
begin
  FSrvSrc := Val;
  FSrvDS := FSrvSrc.DataSet;
end;}

procedure TSrvPropForm.FormActivate(Sender: TObject);
var
  NewMode: boolean;
  i: integer;
begin
  if FirstActive then
  begin
    FSrvDS := TConfigManager.Instance.ProcessCfgData.DataSet;//SrvDataSrc;
    dsServices.DataSet := FSrvDS;

    // Копия таблицы процессов
    cdTempSrv := TClientDataSet.Create(nil);
    cdTempSrv.CloneCursor(FSrvDS as TClientDataSet, true);
    dsTempSrv := TDataSource.Create(nil);
    dsTempSrv.DataSet := cdTempSrv;

    dsEquipGroup.DataSet := TConfigManager.Instance.StandardDics.deEquipGroup.DicItems;

    NewMode := FSrvDS.State = dsInsert;
    if NewMode then SrvPropForm.Caption := sNewSrvCap
    else SrvPropForm.Caption := sEditSrvCap;

    // Менять тип и имя таблицы можно только в новом процессе
    rbTable.Enabled := NewMode;
    rbSimple.Enabled := NewMode;
    rbForm.Enabled := NewMode;
    edName.ReadOnly := not NewMode;

    try
      if FSrvDS['ServiceKind'] = cskSimple then rbSimple.Checked := true
      else if FSrvDS['ServiceKind'] = cskTable then rbTable.Checked := true
      else rbForm.Checked := true;
    except end;
    try
      if FSrvDS['UseInProfitMode'] = upmFullCost then rbFullCost.Checked := true
      else if FSrvDS['UseInProfitMode'] = upmNoCost then rbNoCost.Checked := true
      else rbScriptedCost.Checked := true;
    except end;

    {for i := 0 to Pred(ComponentCount) do
      if Components[i] is TDBCheckBox then
        (Components[i] as TDBCheckBox).DataSource := FSrvSrc
      else if Components[i] is TDBEdit then
        (Components[i] as TDBEdit).DataSource := FSrvSrc;
    lkBaseSrv.DataSource := FSrvSrc;
    lkEquipGroup.DataSource := FSrvSrc;
    edSequenceOrder.DataSource := FSrvSrc;}
    lkBaseSrv.LookupSource := dsTempSrv;

    UpdateControls;

    FirstActive := false;
  end;
end;

procedure TSrvPropForm.FormCreate(Sender: TObject);
begin
{  cdTempSrv := TClientDataSet.Create(nil);
  cdTempSrv.CloneCursor(FSrvDS as TClientDataSet, true);
  dsTempSrv := TDataSource.Create(nil);
  dsTempSrv.DataSet := cdTempSrv;}
  FirstActive := true;
end;

procedure TSrvPropForm.FormDestroy(Sender: TObject);
begin
  if Assigned(dsTempSrv) then dsTempSrv.Free;
  if Assigned(cdTempSrv) then cdTempSrv.Free;
end;

procedure TSrvPropForm.lkBaseSrvChange(Sender: TObject);
var
  BSrv: TPolyProcessCfg;
begin
  if VarIsNull(FSrvDS[F_BaseSrvID]) or (FSrvDS[F_BaseSrvID] <= 0) then
    TConfigManager.Instance.CreateSrvStructData(FStructData, Srv, false, Srv = nil)
  else begin
    // Если указывается новый базовый сервис, то создаем новую структуру
    // сервиса на основе базового.
    BSrv := TConfigManager.Instance.ServiceByID(FSrvDS[F_BaseSrvID]);
    if BSrv <> nil then
      TConfigManager.Instance.CreateSrvStructData(FStructData, BSrv, false, false);
  end;
  UpdateControls;
end;

procedure TSrvPropForm.UpdateControls;
begin
  btStruct.Enabled := VarIsNull(FSrvDS[F_BaseSrvID]) or (FSrvDS[F_BaseSrvID] <= 0);
  // Изменение базового сервиса разрешено только при создании сервиса
  lkBaseSrv.Enabled := (Srv = nil);
end;

end.
