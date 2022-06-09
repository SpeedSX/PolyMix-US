unit fAddIncomesForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseEditForm, StdCtrls, GridsEh, DBGridEh, DB,

  MyDBGridEh,

  PmCustomerPayments, Buttons, JvComponentBase, JvFormPlacement,
  DBGridEhGrouping;

type
  TAddIncomesForm = class(TBaseEditForm)
    dgIncomes: TMyDBGridEh;
    btAdd: TBitBtn;
    btDelete: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
  private
    FIncomeData: TCustomerIncomes;
    procedure SetIncomeData(_IncomeData: TCustomerIncomes);
  public
    property IncomeData: TCustomerIncomes read FIncomeData write SetIncomeData;
  end;

function ExecAddIncomesDialog(Incomes: TCustomerIncomes; Params: pointer): boolean;

implementation

{$R *.dfm}

uses JvJCLUtils,

  DicObj, StdDic, PmConfigManager;

function ExecAddIncomesDialog(Incomes: TCustomerIncomes; Params: pointer): boolean;
var
  IncomeForm: TAddIncomesForm;
begin
  Application.CreateForm(TAddIncomesForm, IncomeForm);
  try
    IncomeForm.IncomeData := Incomes;
    Result := IncomeForm.ShowModal = mrOk;
  finally
    FreeAndNil(IncomeForm); 
  end;
end;

procedure TAddIncomesForm.btAddClick(Sender: TObject);
begin
  FIncomeData.DataSet.Append;
  FIncomeData.IncomeDate := CutTime(Now);
end;

procedure TAddIncomesForm.btDeleteClick(Sender: TObject);
begin
  if not FIncomeData.DataSet.IsEmpty then
    FIncomeData.DataSet.Delete;
end;

procedure TAddIncomesForm.FormCreate(Sender: TObject);
var
  PayKeys, PayTypes: TStringList;
  ds: TDataSet;
  de: TDictionary;
begin
  inherited;

  // Инициализивать список видов оплат
  PayTypes := TStringList.Create;
  PayKeys := TStringList.Create;
  de := TConfigManager.Instance.StandardDics.dePayKind;
  ds := de.DicItems;
  ds.First;
  while not ds.eof do
  begin
    if de.CurrentEnabled then
    begin
      PayTypes.Add(de.CurrentName);
      PayKeys.Add(VarToStr(de.CurrentCode));
    end;
    ds.Next;
  end;

  dgIncomes.FieldColumns['PayType'].PickList := PayTypes;
  dgIncomes.FieldColumns['PayType'].KeyList := PayKeys;
end;

procedure TAddIncomesForm.SetIncomeData(_IncomeData: TCustomerIncomes);
begin
  FIncomeData := _IncomeData;
  dgIncomes.DataSource := FIncomeData.DataSource;
end;

end.
