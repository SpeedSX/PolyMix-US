unit MkOrder;

{$I Calc.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, StdCtrls, ExtCtrls, Buttons, Mask, JvToolEdit, JvBaseEdits, 
  ComCtrls, anycolor, DB, JvDBUtils, JvExControls, JvComponent, JvDBLookup,
  JvExMask, JvSpin, PmProviders, PmEntSettings, PmOrder;

type
  TMakeOrderForm = class(TForm)
    btOk: TBitBtn;
    btCancel: TBitBtn;
    Panel1: TPanel;
    Label1: TLabel;
    udNum: TUpDown;
    edNum: TEdit;
    cbMakeCopy: TCheckBox;
    acColorBox: TAnyColorCombo;
    deFinishDate: TJvDateEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    cbOrderState: TJvDBLookupCombo;
    cbPayState: TJvDBLookupCombo;
    Label2: TLabel;
    tmFinish: TMaskEdit;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btOkClick(Sender: TObject);
    procedure cbIncludeAdvClick(Sender: TObject);
    procedure cbOrderStateGetImage(Sender: TObject; IsEmpty: Boolean;
      var Graphic: TGraphic; var TextMargin: Integer);
    procedure cbPayStateGetImage(Sender: TObject; IsEmpty: Boolean;
      var Graphic: TGraphic; var TextMargin: Integer);
    procedure deFinishDateChange(Sender: TObject);
  private
    dsOrderState, dsPayState: TDataSource;
    FOrder: TOrder;
    //procedure CalcSums;
  public
    CustNum: integer;
    procedure EnableDBControls;
    procedure DisableDBControls;
    property Order: TOrder read FOrder write FOrder;
  end;

type
  TMakeOrderFormParamsProvider = class(TInterfacedObject, IMakeOrderParamsProvider)
  private
    FOrder: TOrder;
  public
    //function IncludeAdv: boolean;
    function OrderState: integer;
    function PayState: variant;
    function RowColor: integer;
    function FinishDate: variant;
    procedure CreateForm;
    function Execute: integer;
    function CopyToWork: boolean;
    destructor Destroy; override;
    constructor Create(Order: TOrder);
  end;

implementation

uses RDialogs, Nalog, DataHlp, PmStates, Variants, CalcSettings, DicObj,
   ExHandler, DateUtils, PmConfigManager, RDBUtils
   {$IFNDEF NoNet}
  , OptCalc, NtfQueue, NtfConst
  {$ENDIF}
;

{$R *.DFM}

var
  MakeOrderForm: TMakeOrderForm;

constructor TMakeOrderFormParamsProvider.Create(Order: TOrder);
begin
  FOrder := Order;
end;

{function TMakeOrderFormParamsProvider.IncludeAdv: boolean;
begin
  Result := MakeOrderForm.cbIncludeAdv.Checked;
end;}

function TMakeOrderFormParamsProvider.OrderState: integer;
begin
  Result := MakeOrderForm.cbOrderState.KeyValue;
end;

function TMakeOrderFormParamsProvider.RowColor: integer;
begin
  Result := MakeOrderForm.acColorBox.ColorValue;
end;

function TMakeOrderFormParamsProvider.PayState: variant;
begin
  Result := MakeOrderForm.cbPayState.KeyValue;
end;

function TMakeOrderFormParamsProvider.CopyToWork: boolean;
begin
  Result := MakeOrderForm.cbMakeCopy.Checked;
end;

function TMakeOrderFormParamsProvider.FinishDate: variant;
var
  FinDate: variant;

  function FixDate(dt: TDateTime): TDateTime;
  var
    S: string;
  begin
    s := MakeOrderForm.deFinishDate.Text;
    if MakeOrderForm.tmFinish.EditText <> NullTime then
      s := s + ' ' + MakeOrderForm.tmFinish.EditText;
    Result := StrToDateTime(s);
  end;

begin
  if MakeOrderForm.deFinishDate.Date = 0 then FinDate := null
  else FinDate := FixDate(MakeOrderForm.deFinishDate.Date);
  Result := FinDate;
end;

function TMakeOrderFormParamsProvider.Execute: integer;
begin
  Result := MakeOrderForm.ShowModal;
end;

procedure TMakeOrderFormParamsProvider.CreateForm;
begin
  Application.CreateForm(TMakeOrderForm, MakeOrderForm);
  MakeOrderForm.cbMakeCopy.Checked := Options.CopyToWork;
  MakeOrderForm.Order := FOrder;
end;

destructor TMakeOrderFormParamsProvider.Destroy;
begin
  if MakeOrderForm <> nil then
    FreeAndNil(MakeOrderForm);
  inherited Destroy;
end;

procedure TMakeOrderForm.EnableDBControls;
begin
  cbOrderState.LookupSource := dsOrderState;
  cbPayState.LookupSource := dsPayState;

  // В режиме автоопределения состояния оплаты для упрощения
  // здесь подсостояние не указывается.
  if EntSettings.AutoPayState then
    cbPayState.ReadOnly := true;
end;

procedure TMakeOrderForm.DisableDBControls;
begin
  cbOrderState.LookupSource := nil;
  cbPayState.LookupSource := nil;
end;

{procedure TMakeOrderForm.CalcSums;
begin
  try
    lbNDS.Caption := FloatToStrF(Total2NDS(dm.CalcOrderData['TotalGrn'], cbIncludeAdv.Checked),
        ffNumber, 18, 2);
    if cbIncludeAdv.Checked then
      lbAdv.Caption := FloatToStrF(Total2Adv(dm.CalcOrderData['TotalGrn']), ffNumber, 18, 2)
    else lbAdv.Caption := '0.00';
  except
  end;
end;}

procedure TMakeOrderForm.FormActivate(Sender: TObject);
var
  e: boolean;
begin
  if TConfigManager.Instance.StandardDics.deOrderState <> nil then begin
    dsOrderState := TDataSource.Create(Self);
    dsOrderState.DataSet := TConfigManager.Instance.StandardDics.deOrderState.DicItems;
  end;
  if TConfigManager.Instance.StandardDics.dePayState <> nil then begin
    dsPayState := TDataSource.Create(Self);
    dsPayState.DataSet := TConfigManager.Instance.StandardDics.dePayState.DicItems;
  end;
  EnableDBControls;
  //deDate.Date := Now;
  //cbIncludeAdv.Checked := false;
  e := not EntSettings.BriefOrderID;
  //lbColor.Visible := e;
  //lkColor.Visible := e;
  //lbKind.Visible := e;
  //lkKind.Visible := e;
  //lbChar.Visible := e;
  //lkChar.Visible := e;
  // Состояния по умолчанию берутся из опций
  if NvlInteger(Options.DefOrderExecState) > 0 then
    cbOrderState.KeyValue := Options.DefOrderExecState
  else cbOrderState.KeyValue := 0;
  if NvlInteger(Options.DefOrderPayState) > 0 then
    cbPayState.KeyValue := Options.DefOrderPayState
  else cbPayState.KeyValue := 0;
  acColorBox.ColorValue := Order.RowColor;
  cbMakeCopy.Checked := Options.CopyToWork;
  //CalcSums;
  //ActiveControl := deDate;
  ActiveControl := cbOrderState;
end;

procedure TMakeOrderForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DisableDBControls;
end;

procedure TMakeOrderForm.btOkClick(Sender: TObject);
begin
  {if RequireFinishDate and (deFinishDate.Date = 0) then begin
    RusMessageDlg('Не указана дата исполнения заказа', mtError, [mbOk], 0);
    ModalResult := mrNone;
    Exit;
  end;
  if RequireRealFinishDate and (deFinishDate.Date <> 0) and (deFinishDate.Date < Date) then begin
    RusMessageDlg('Некорректная дата исполнения заказа', mtError, [mbOk], 0);
    ModalResult := mrNone;
    Exit;
  end;}
  Options.CopyToWork := cbMakeCopy.Checked;
end;

procedure TMakeOrderForm.cbIncludeAdvClick(Sender: TObject);
begin
  //CalcSums;
end;

procedure TMakeOrderForm.cbOrderStateGetImage(Sender: TObject;
  IsEmpty: Boolean; var Graphic: TGraphic; var TextMargin: Integer);
var
  os, gi: integer;
begin
  TextMargin := 18;
  if not IsEmpty and (dsOrderState <> nil) and not VarIsNull(dsOrderState.DataSet[F_DicItemCode]) then
  try
    os := dsOrderState.DataSet[F_DicItemCode];
    gi := TConfigManager.Instance.StandardDics.OrderStates.IndexOf(IntToStr(os));
    if gi <> -1 then
      Graphic := (TConfigManager.Instance.StandardDics.OrderStates.Objects[gi] as TOrderState).Graphic;
  except end;
end;

procedure TMakeOrderForm.cbPayStateGetImage(Sender: TObject;
  IsEmpty: Boolean; var Graphic: TGraphic; var TextMargin: Integer);
var
  os, gi: integer;
begin
  TextMargin := 18;
  if not IsEmpty and (dsPayState <> nil) and not VarIsNull(dsPayState.DataSet[F_DicItemCode]) then
  try
    os := dsPayState.DataSet[F_DicItemCode];
    gi := TConfigManager.Instance.StandardDics.PayStates.IndexOf(IntToStr(os));
    if gi <> -1 then
      Graphic := (TConfigManager.Instance.StandardDics.PayStates.Objects[gi] as TOrderState).Graphic;
  except end;
end;

procedure TMakeOrderForm.deFinishDateChange(Sender: TObject);
begin
  if (CompareDate(deFinishDate.Date, Today) = 0) and (tmFinish.Text = NullTime) then
    tmFinish.Text := SysUtils.FormatDateTime('t', Now);
end;

end.
