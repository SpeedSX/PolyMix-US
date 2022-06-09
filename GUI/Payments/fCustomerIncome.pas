unit fCustomerIncome;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, JvExControls, JvDBLookup, Mask, JvExMask,
  JvToolEdit, JvDBControls, DB,

  PmCustomerPayments, ComCtrls, GridsEh, DBGridEh, MyDBGridEh, ExtCtrls,
  DBCtrlsEh, DBLookupEh, Buttons, DBGridEhGrouping;

type
  TCustomerIncomeForm = class(TForm)
    btOk: TButton;
    btCancel: TButton;
    dsPayType: TDataSource;
    pcIncomeProps: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    deDate: TJvDBDateEdit;
    Label2: TLabel;
    comboPayKind: TJvDBLookupCombo;
    Label3: TLabel;
    edIncomeCost: TDBEdit;
    Label4: TLabel;
    Memo1: TMemo;
    dgPayments: TMyDBGridEh;
    Panel1: TPanel;
    btDelete: TButton;
    Label5: TLabel;
    comboCustomer: TDBLookupComboboxEh;
    dsCust: TDataSource;
    edInvoiceNum: TDBEdit;
    Label6: TLabel;
    Label7: TLabel;
    edReturnCost: TDBEdit;
    btRestIncome: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btDeleteClick(Sender: TObject);
    procedure btRestIncomeClick(Sender: TObject);
  private
    FIncomeData: TCustomerIncomes;
    FPaymentsData: TCustomerPayments;
    OldPayCost: extended;
    procedure SetIncomeData(_IncomeData: TCustomerIncomes);
    procedure SetPaymentsData(_PaymentsData: TCustomerPayments);
  protected
    function ValidateForm: boolean; virtual;
  public
    property IncomeData: TCustomerIncomes read FIncomeData write SetIncomeData;
    property PaymentsData: TCustomerPayments read FPaymentsData write SetPaymentsData;
  end;

function ExecCustomerIncomeDialog(Incomes: TCustomerIncomes;
  IncomePayments: TCustomerPayments): boolean;

implementation

{$R *.dfm}

uses StdDic, PmAccessManager, PmContragent, RDBUtils, PmConfigManager;

function ExecCustomerIncomeDialog(Incomes: TCustomerIncomes;
  IncomePayments: TCustomerPayments): boolean;
var
  IncomeForm: TCustomerIncomeForm;
begin
  Application.CreateForm(TCustomerIncomeForm, IncomeForm);
  try
    IncomeForm.IncomeData := Incomes;
    IncomeForm.PaymentsData := IncomePayments;
    Result := IncomeForm.ShowModal = mrOk;
  finally
    FreeAndNil(IncomeForm);
  end;
end;

procedure TCustomerIncomeForm.btDeleteClick(Sender: TObject);
begin
  if not FPaymentsData.IsEmpty and AccessManager.CurUser.AddPayments then
    FPaymentsData.DataSet.Delete;
end;

procedure TCustomerIncomeForm.btRestIncomeClick(Sender: TObject);
begin
  FIncomeData.ReturnCost := FIncomeData.RestIncome + FIncomeData.ReturnCost;
end;

procedure TCustomerIncomeForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult = mrOk then
  begin
    if FIncomeData.DataSet.State in [dsInsert, dsEdit] then
      FIncomeData.DataSet.Post;
    FIncomeData.GetterComment := Memo1.Lines.Text;
    CanClose := ValidateForm;
  end;
end;

procedure TCustomerIncomeForm.FormCreate(Sender: TObject);
begin
  dsPayType.DataSet := TConfigManager.Instance.StandardDics.dePayKind.DicItems;

//  btDelete.Enabled := AccessManager.CurUser.EditPayments;
//  btOk.Enabled := AccessManager.CurUser.EditPayments;

  btDelete.Enabled := AccessManager.CurUser.AddPayments;
  btOk.Enabled := AccessManager.CurUser.AddPayments;
  dsCust.DataSet := Customers.DataSet;
end;

procedure TCustomerIncomeForm.SetIncomeData(_IncomeData: TCustomerIncomes);
begin
  FIncomeData := _IncomeData;
  deDate.DataSource := FIncomeData.DataSource;
  comboPayKind.DataSource := FIncomeData.DataSource;
  edIncomeCost.DataSource := FIncomeData.DataSource;
  edReturnCost.DataSource := FIncomeData.DataSource;
  comboCustomer.DataSource := FIncomeData.DataSource;
  edInvoiceNum.DataSource := FIncomeData.DataSource;
  Memo1.Lines.Text := FIncomeData.GetterComment;
  OldPayCost := FIncomeData.IncomeGrn - FIncomeData.RestIncome - NvlFloat(FIncomeData.ReturnCost);
end;

procedure TCustomerIncomeForm.SetPaymentsData(_PaymentsData: TCustomerPayments);
begin
  FPaymentsData := _PaymentsData;
  dgPayments.DataSource := FPaymentsData.DataSource;
end;

function TCustomerIncomeForm.ValidateForm: boolean;
begin
  Result := (FIncomeData.IncomeDate > 0)
    and (FIncomeData.PayType > 0)
    and (NvlFloat(FIncomeData.IncomeGrn) > 0)
    and (NvlFloat(FIncomeData.ReturnCost) >= 0)
    and (NvlFloat(FIncomeData.ReturnCost) + OldPayCost <= NvlFloat(FIncomeData.IncomeGrn));
end;

end.
