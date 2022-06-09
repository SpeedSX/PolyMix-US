unit PmIncomingInvoice;

interface

uses DB, SysUtils,

  CalcUtils, PmEntity;

type
  TIncomingInvoices = class(TEntity)
  protected
    FDataSource: TDataSource;
    procedure CreateFields;
  public
    constructor Create; override;
    property DataSource: TDataSource read FDataSource;
  end;

implementation

uses Forms,

  RDBUtils, PlanData, PmDatabase;
  
const
  F_InvoiceKey = 'InvoiceID';

constructor TIncomingInvoices.Create;
var
  _DataSource: TDataSource;
  _DataSet: TDataSet;
begin
  if PlanDM = nil then
    Application.CreateForm(TPlanDM, PlanDM);

  _DataSource := CreateQueryExDM(PlanDM, PlanDM, ClassName,
    [{poAllowMultiRecordUpdates, poDisableInserts, poDisableDeletes, poDisableEdits}],
    upWhereKeyOnly, false {ResolveToDataSet}, Database.Connection);
  _DataSet := _DataSource.DataSet;

  inherited Create;
  FKeyField := F_InvoiceKey;

  FInternalName := ClassName;

  SetDataSet(_DataSet);

  //FDataSource.Free;  // меняем на свой

  FDataSource := _DataSource;

  CreateFields;

  {FNumberField := 'wo.ID_Number';
  SetLength(FDateFields, 5);
  FDateFields[0] := 'wo.CreationDate';
  FDateFields[1] := 'wo.ModifyDate';
  FDateFields[2] := 'wo.FinishDate';
  FDateFields[3] := 'wo.FactFinishDate';
  FDateFields[4] := 'wo.CloseDate';}
end;

procedure TIncomingInvoices.CreateFields;
begin

end;

end.
