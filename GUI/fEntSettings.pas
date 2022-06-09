unit fEntSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, DBCtrls, DB, PmEntSettings,
  JvExStdCtrls, JvEdit, JvValidateEdit, Mask, JvExMask, JvToolEdit;

type
  TEntSettingsForm = class(TForm)
    pcSettings: TPageControl;
    tsCommon: TTabSheet;
    tsOther: TTabSheet;
    Panel1: TPanel;
    Memo1: TMemo;
    btOk: TButton;
    btCancel: TButton;
    DBCheckBox2: TDBCheckBox;
    dsEntSettings: TDataSource;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    gbRound: TGroupBox;
    lb1: TLabel;
    lbAtt: TLabel;
    lb2: TLabel;
    lbAtt2: TLabel;
    edPrec: TEdit;
    udPrec: TUpDown;
    rbCorTotal: TRadioButton;
    rbRoundTotal: TRadioButton;
    edPrec2: TEdit;
    udPrec2: TUpDown;
    rbNoRoundTotal: TRadioButton;
    Panel2: TPanel;
    rbUSD: TRadioButton;
    rbUAH: TRadioButton;
    DBCheckBox5: TDBCheckBox;
    DBCheckBox6: TDBCheckBox;
    GroupBox1: TGroupBox;
    DBCheckBox8: TDBCheckBox;
    GroupBox2: TGroupBox;
    DBCheckBox7: TDBCheckBox;
    DBCheckBox9: TDBCheckBox;
    DBCheckBox10: TDBCheckBox;
    DBCheckBox11: TDBCheckBox;
    DBCheckBox12: TDBCheckBox;
    tsPayments: TTabSheet;
    DBCheckBox13: TDBCheckBox;
    Label1: TLabel;
    dbcFirmType: TDBCheckBox;
    tsPlan: TTabSheet;
    DBCheckBox14: TDBCheckBox;
    DBCheckBox15: TDBCheckBox;
    Label2: TLabel;
    edVATPercent: TJvValidateEdit;
    DBCheckBox1: TDBCheckBox;
    dbcRequireFullName: TDBCheckBox;
    DBCheckBox16: TDBCheckBox;
    rbPayStateMode: TRadioGroup;
    rbPayStateModeInvPos: TRadioButton;
    rbPayStateModeInvoice: TRadioButton;
    rbPayStateModeOrder: TRadioButton;
    DBCheckBox17: TDBCheckBox;
    DBCheckBox18: TDBCheckBox;
    DBCheckBox19: TDBCheckBox;
    DBCheckBox20: TDBCheckBox;
    tsFiles: TTabSheet;
    DirEditAttached: TJvDirectoryEdit;
    Label3: TLabel;
    rbPayStateModeOldInvoices: TRadioButton;
    DBCheckBox21: TDBCheckBox;
    DBCheckBox22: TDBCheckBox;
    DBCheckBox23: TDBCheckBox;
    DBCheckBox24: TDBCheckBox;
    DBCheckBox25: TDBCheckBox;
    DBCheckBox26: TDBCheckBox;
    DBCheckBox27: TDBCheckBox;
    DBCheckBox28: TDBCheckBox;
    DBCheckBox29: TDBCheckBox;
    DBCheckBox30: TDBCheckBox;
    DBCheckBox31: TDBCheckBox;
    DBCheckBox32: TDBCheckBox;
    DBCheckBox33: TDBCheckBox;
    DBCheckBox34: TDBCheckBox;
    DBCheckBox35: TDBCheckBox;
    DBCheckBox36: TDBCheckBox;
    DBCheckBox37: TDBCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SetREnabled;
    procedure rbCorTotalClick(Sender: TObject);
    procedure rbRoundTotalClick(Sender: TObject);
  private
    procedure ControlsToData;
    procedure DataToControls;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EntSettingsForm: TEntSettingsForm;

function EditEnterpriseSettings: boolean;

implementation

{$R *.dfm}

function EditEnterpriseSettings: boolean;
begin
  EntSettingsForm := TEntSettingsForm.Create(nil);
  try
    Result := EntSettingsForm.ShowModal = mrOk;
  finally
    EntSettingsForm.Free;
  end;
end;

procedure TEntSettingsForm.FormCreate(Sender: TObject);
begin
  dsEntSettings.DataSet := EntSettings.DataSet;
  DataToControls;
end;

// При измененении настройки BriefOrderID раньше делалось так
//    dm.SetOrderIDSQL(qiCalc);
//    dm.SetOrderIDSQL(qiWork);

procedure TEntSettingsForm.ControlsToData;
begin
  if rbCorTotal.Checked then begin
    EntSettings.RoundTotalMode := rndBy1;
    EntSettings.RoundPrecision := udPrec.Position;
  end else if rbRoundTotal.Checked then begin
    EntSettings.RoundTotalMode := rndByDig;
    EntSettings.RoundPrecision := udPrec2.Position;
  end else
    EntSettings.RoundTotalMode := rndNo;
  EntSettings.RoundUSD := rbUSD.Checked;
  EntSettings.VATPercent := edVATPercent.Value;
  if rbPayStateModeOrder.Checked then
    EntSettings.PayStateMode := AutoPayState_OrderTotal
  else if rbPayStateModeInvPos.Checked then
    EntSettings.PayStateMode := AutoPayState_InvoicePosition
  else if rbPayStateModeInvoice.Checked then
    EntSettings.PayStateMode := AutoPayState_InvoiceTotal
  else if rbPayStateModeOldInvoices.Checked then
    EntSettings.PayStateMode := AutoPayState_OldInvoices;
  EntSettings.FileStoragePath := DirEditAttached.Text;
end;

procedure TEntSettingsForm.DataToControls;
begin
  rbCorTotal.Checked := EntSettings.RoundTotalMode = rndBy1;
  rbRoundTotal.Checked := EntSettings.RoundTotalMode = rndByDig;
  rbNoRoundTotal.Checked := EntSettings.RoundTotalMode = rndNo;
  rbUSD.Checked := EntSettings.RoundUSD;
  if rbCorTotal.Checked then udPrec.Position := EntSettings.RoundPrecision
  else if rbRoundTotal.Checked then udPrec2.Position := EntSettings.RoundPrecision;
  edVATPercent.Value := EntSettings.VATPercent;
  rbPayStateModeOrder.Checked := EntSettings.PayStateMode = AutoPayState_OrderTotal;
  rbPayStateModeInvPos.Checked := EntSettings.PayStateMode = AutoPayState_InvoicePosition;
  rbPayStateModeInvoice.Checked := EntSettings.PayStateMode = AutoPayState_InvoiceTotal;
  rbPayStateModeOldInvoices.Checked := EntSettings.PayStateMode = AutoPayState_OldInvoices;
  DirEditAttached.Text := EntSettings.FileStoragePath;
end;

procedure TEntSettingsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ModalResult = mrOk then
    ControlsToData;
end;

procedure TEntSettingsForm.SetREnabled;
var e: boolean;
begin
  e := rbCorTotal.Checked;
  lb1.Enabled := e;
  edPrec.Enabled := e;
  udPrec.Enabled := e;
  rbUAH.Enabled := e;
  rbUSD.Enabled := e;
  lbAtt.Enabled := e;
  e := rbRoundTotal.Checked;
  lb2.Enabled := e;
  edPrec2.Enabled := e;
  udPrec2.Enabled := e;
  lbAtt2.Enabled := e;
  if not rbUAH.Checked and not rbUSD.checked then rbUSD.Checked := true;
end;

procedure TEntSettingsForm.rbCorTotalClick(Sender: TObject);
begin
  SetREnabled;
end;

procedure TEntSettingsForm.rbRoundTotalClick(Sender: TObject);
begin
  SetREnabled;
end;

end.
