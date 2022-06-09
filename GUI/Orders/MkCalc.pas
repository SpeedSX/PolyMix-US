unit MkCalc;

{$I calc.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, anycolor, DBCtrls, Mask, JvToolEdit, ExtCtrls,
  Variants, JvExControls, JvComponent, JvDBLookup, JvExMask, JvSpin,
  PmProviders, PmOrder, JvExStdCtrls, JvHtControls;

type
  TMakeCalcForm = class(TForm)
    btOk: TBitBtn;
    btCancel: TBitBtn;
    Label2: TLabel;
    acColorBox: TAnyColorCombo;
    Panel1: TPanel;
    lbWarning: TJvHTLabel;
    procedure btOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FOrder: TOrder;
    procedure EnableDBControls;
    procedure DisableDBControls;
  public
    CustNum: integer;
    property Order: TOrder read FOrder write FOrder;
  end;

type
  TMakeDraftFormParamsProvider = class(TInterfacedObject, IMakeDraftParamsProvider)
  private
    FOrder: TOrder;
  public
    function RowColor: integer;
    procedure CreateForm;
    function CopyToDraft: boolean;
    function Execute: integer;
    destructor Destroy; override;
    constructor Create(Order: TOrder);
  end;

implementation

uses DataHlp, DB, RDialogs, CalcSettings, ExHandler, fCopyOrder
  {$IFNDEF NoNet}
  , NtfQueue, OptCalc, NtfConst
  {$ENDIF}
;

{$R *.DFM}

var
  MakeCalcForm: TMakeCalcForm;

constructor TMakeDraftFormParamsProvider.Create(Order: TOrder);
begin
  FOrder := Order;
end;

procedure TMakeDraftFormParamsProvider.CreateForm;
begin
  Application.CreateForm(TMakeCalcForm, MakeCalcForm);
  MakeCalcForm.Order := FOrder;
end;

destructor TMakeDraftFormParamsProvider.Destroy;
begin
  if MakeCalcForm <> nil then
    FreeAndNil(MakeCalcForm);
  inherited Destroy;
end;

function TMakeDraftFormParamsProvider.RowColor: integer;
begin
  Result := MakeCalcForm.acColorBox.ColorValue;
end;

function TMakeDraftFormParamsProvider.CopyToDraft: boolean;
begin
  Result := true;//MakeCalcForm.cbMakeCopy.Checked;
end;

function TMakeDraftFormParamsProvider.Execute: integer;
begin
  Result := MakeCalcForm.ShowModal;
end;

procedure TMakeCalcForm.EnableDBControls;
begin
end;

procedure TMakeCalcForm.DisableDBControls;
begin
end;

procedure TMakeCalcForm.FormActivate(Sender: TObject);
begin
  EnableDBControls;
  //deDate.Date := Now;
  acColorBox.ColorValue := Order.RowColor;
  //cbMakeCopy.Checked := Options.CopyToDraft;
  //ActiveControl := deDate;
end;

procedure TMakeCalcForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DisableDBControls;
end;

procedure TMakeCalcForm.FormCreate(Sender: TObject);
begin
  lbWarning.Caption := CopyWarningText;
end;

procedure TMakeCalcForm.btOkClick(Sender: TObject);
begin
  //Options.CopyToDraft := cbMakeCopy.Checked;
  ModalResult := mrOk;
end;

end.
