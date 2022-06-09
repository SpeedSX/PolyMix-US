unit PmMatRequest;

interface

uses DB, SysUtils, Variants, DBClient,

  CalcUtils, PmEntity, MainFilter, PmQueryPager;

const
  MaterialRequest_New = 0;
  MaterialRequest_Ordered = 1;
  MaterialRequest_Received = 2;
  MaterialRequest_Used = 3;

type
  TMaterialRequests = class(TEntity)
  private
  protected
    FDataSource: TDataSource;
    FCriteria: TMaterialFilterObj;
    procedure CreateFields;
    procedure DoBeforeOpen; override;
    procedure DoOnCalcFields; override;
    function GetSQL: TQueryObject;
    function GetCustomerName: string;
    function GetSupplierName: string;
    function GetOrderNumber: integer;
    function GetCreatorName: string;
    function GetNumberField: string;
    function GetMatDesc: string;
    function GetParam1: string;
    function GetParam2: string;
    function GetParam3: string;
    function GetFactParam1: string;
    function GetFactParam2: string;
    function GetFactParam3: string;
    function GetMatAmount: extended;
    function GetFactMatAmount: variant;
    function GetFactReceiveDate: variant;
    function GetPlanReceiveDate: variant;
    function GetPayDate: variant;
    function GetCustomerID: integer;
    function GetSupplierID: integer;
    function GetOrderID: integer;
    function GetKindID: integer;
    function GetRequestState: integer;
    function GetExchangeRate: extended;
    function GetRequestModified: boolean;
    function GetMatTypeName: string;
    function GetMatUnitName: string;
    procedure GetEmptyText(Sender: TField; var Text: String; DisplayText: Boolean);
  public
    const
      F_MarginCost = 'MarginCost';
      F_MatCostNative = 'MatCostNative';
      F_MatCost1 = 'MatCost1';
      F_FactMatCost1 = 'FactMatCost1';
      MatCost1Fmt = '#0.000';

    constructor Create; override;
    //procedure SetSortOrder(_SortField: string; MakeActive: boolean); override;
    property DataSource: TDataSource read FDataSource;
    property Criteria: TMaterialFilterObj read FCriteria write FCriteria;
    property CustomerID: integer read GetCustomerID;
    property SupplierID: integer read GetSupplierID;
    property CustomerName: string read GetCustomerName;
    property OrderNumber: integer read GetOrderNumber;
    property SupplierName: string read GetSupplierName;
    property CreatorName: string read GetCreatorName;
    property OrderID: integer read GetOrderID;
    property KindID: integer read GetKindID;
    property ExchangeRate: extended read GetExchangeRate;
    property RequestState: integer read GetRequestState;
    property NumberField: string read GetNumberField;
    property RequestModified: boolean read GetRequestModified;
    property MatDesc: string read GetMatDesc;
    property Param1: string read GetParam1;
    property Param2: string read GetParam2;
    property Param3: string read GetParam3;
    property FactParam1: string read GetFactParam1;
    property FactParam2: string read GetFactParam2;
    property FactParam3: string read GetFactParam3;
    property MatAmount: extended read GetMatAmount;
    property MatUnitName: string read GetMatUnitName;
    property MatTypeName: string read GetMatTypeName;
    property FactMatAmount: variant read GetFactMatAmount;
    property FactReceiveDate: variant read GetFactReceiveDate;
    property PlanReceiveDate: variant read GetPlanReceiveDate;
    property PayDate: variant read GetPayDate;
  end;

implementation

uses Forms, Provider, Graphics,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmOrder,
  PmContragent, DicObj, StdDic, PmMaterials;

constructor TMaterialRequests.Create;
var
  _DataSource: TDataSource;
  _DataSet: TDataSet;
  _Provider: TDataSetProvider;
begin
  if PlanDM = nil then
    Application.CreateForm(TPlanDM, PlanDM);

  _DataSource := CreateQueryExDM(PlanDM, PlanDM, ClassName,
    [{poAllowMultiRecordUpdates, poDisableInserts, poDisableDeletes, poDisableEdits}],
    upWhereKeyOnly, false {ResolveToDataSet}, Database.Connection, _Provider);
  _DataSet := _DataSource.DataSet;

  inherited Create;
  FKeyField := TMaterials.F_Key;

  FInternalName := ClassName;
  DefaultLastRecord := true;

  SetDataSet(_DataSet);
  {_Provider.UpdateMode := upWhereKeyOnly;
  _Provider.OnGetTableName := GetTableName;}
  DataSetProvider := _Provider;

  //FDataSource.Free;  // мен€ем на свой
  FDataSource := _DataSource;

  CreateFields;

  //TWorkOrder.FillDateFields(FDateFields, 'wo.');
  // ƒобавл€ем еще плановую и фактическую даты поставки
  //SetLength(FDateFields, Length(FDateFields) + 2);
  //FDateFields[Length(FDateFields) - 2] := TMaterials.F_PlanReceiveDate;
  //FDateFields[Length(FDateFields) - 1] := TMaterials.F_FactReceiveDate;
  SetLength(FDateFields, 4);
  FSortField := 'wo.CreationDate';
  FDateFields[0] := 'wo.CreationDate';
  FDateFields[1] := TMaterials.F_PlanReceiveDate;
  FDateFields[2] := TMaterials.F_FactReceiveDate;
  FDateFields[3] := TMaterials.F_PayDate;
end;

procedure TMaterialRequests.CreateFields;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TMaterials.F_Key;
  f.ReadOnly := true;
  f.ProviderFlags := [pfInKey, pfInWhere];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'OrderID';
  f.ReadOnly := true;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TMaterials.F_MatTypeName;
  f.ReadOnly := true;
  f.ProviderFlags := [];
  f.Size := TMaterials.MatTypeNameSize;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TMaterials.F_MatDesc;
  f.ReadOnly := true;
  f.ProviderFlags := [];
  f.Size := TMaterials.MatDescSize;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TFloatField.Create(DataSet.Owner);
  f.FieldName := TMaterials.F_MatAmount;
  f.ReadOnly := true;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TFloatField.Create(DataSet.Owner);
  f.FieldName := TMaterials.F_FactMatAmount;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'MatCost';
  f.ReadOnly := true;
  f.ProviderFlags := [pfInUpdate];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).EditFormat := NumEditFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_MatCostNative;
  f.ReadOnly := true;
  f.ProviderFlags := [];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).EditFormat := NumEditFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := 'FactMatCost';
  f.ProviderFlags := [pfInUpdate];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).EditFormat := NumEditFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_Course;
  f.ProviderFlags := [pfInUpdate];
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).EditFormat := NumEditFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TMaterials.F_SupplierID;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  {f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'SupplierName';
  f.ProviderFlags := [];
  f.Size := TContragents.CustNameSize;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.Origin := 'SupplierID';}

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'SupplierName';
  f.ProviderFlags := [];
  f.Size := TContragents.CustNameSize;
  f.FieldKind := fkLookup;
  f.LookupResultField := TContragents.F_CustName;
  f.LookupCache := true;
  f.LookupKeyFields := TContragents.F_CustKey;
  f.KeyFields := 'SupplierID';
  f.LookupDataSet := Suppliers.DataSet;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.Origin := TMaterials.F_SupplierID + ',' + TMaterials.F_FactParam1 + ',' + TMaterials.F_FactParam2 + ',' + TMaterials.F_FactParam3;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'MatUnitName';
  f.Size := TMaterials.MatUnitNameSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := TMaterials.F_PlanReceiveDate;
  f.ProviderFlags := [pfInUpdate];
  (f as TDateTimeField).DisplayFormat := CalcUtils.ShortDateFormat2;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := TMaterials.F_FactReceiveDate;
  f.ProviderFlags := [pfInUpdate];
  (f as TDateTimeField).DisplayFormat := CalcUtils.ShortDateFormat2;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'FinishDate';
  f.ReadOnly := true;
  f.ProviderFlags := [];
  (f as TDateTimeField).DisplayFormat := CalcUtils.ShortDateFormat2;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'ExternalMatID';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := TMaterials.F_RequestModified;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'KindID';
  f.ReadOnly := true;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'CustomerID';
  f.ReadOnly := true;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'CustomerName';
  f.ReadOnly := true;
  f.Size := TContragents.CustNameSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.Origin := 'wo.Customer';

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_CreatorName;
  f.ReadOnly := true;
  f.Size := TOrder.CreatorNameSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'Comment';
  f.ReadOnly := true;
  f.Size := TOrder.CommentSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.Origin := 'wo.Comment';

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TMaterials.F_Param1;
  f.Origin := TMaterials.F_Param1 + ',' + TMaterials.F_Param2 + ',' + TMaterials.F_Param3 + ',' + TMaterials.F_SupplierID;
  f.ReadOnly := true;
  f.Size := TMaterials.ParamSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TMaterials.F_Param2;
  f.Origin := TMaterials.F_Param2 + ',' + TMaterials.F_Param1 + ',' + TMaterials.F_Param3 + ',' + TMaterials.F_SupplierID;
  f.ReadOnly := true;
  f.Size := TMaterials.ParamSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TMaterials.F_Param3;
  f.Origin := TMaterials.F_Param3 + ',' + TMaterials.F_Param1 + ',' + TMaterials.F_Param2 + ',' + TMaterials.F_SupplierID;
  f.ReadOnly := true;
  f.Size := TMaterials.ParamSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TMaterials.F_FactParam1;
  f.Origin := TMaterials.F_FactParam1 + ',' + TMaterials.F_FactParam2 + ',' + TMaterials.F_FactParam3 + ',' + TMaterials.F_SupplierID;
  f.Size := TMaterials.ParamSize;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TMaterials.F_FactParam2;
  f.Origin := TMaterials.F_FactParam2 + ',' + TMaterials.F_FactParam1 + ',' + TMaterials.F_FactParam3 + ',' + TMaterials.F_SupplierID;
  f.Size := TMaterials.ParamSize;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TMaterials.F_FactParam3;
  f.Origin := TMaterials.F_FactParam3 + ',' + TMaterials.F_FactParam1 + ',' + TMaterials.F_FactParam2 + ',' + TMaterials.F_SupplierID;
  f.Size := TMaterials.ParamSize;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'MatNote';
  f.Size := TMaterials.MatNoteSize;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'InvoiceNum';
  f.Size := TMaterials.InvoiceNumSize;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_OrderNumber;
  f.ReadOnly := true;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.Origin := 'YEAR(wo.CreationDate), wo.ID_Number';

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_OrderState;
  f.ReadOnly := true;
  f.OnGetText := GetEmptyText;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.Origin := 'wo.OrderState';

  // ¬ычисл€емые
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'MatRequestState';
  f.ProviderFlags := [];
  f.Calculated := true;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_MarginCost;
  f.ProviderFlags := [];
  f.Calculated := true;
  (f as TBCDField).DisplayFormat := NumDisplayFmt;
  (f as TBCDField).EditFormat := NumEditFmt;
  (f as TBCDField).Precision := 18;
  f.Size := 2;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_MatCost1;
  f.ProviderFlags := [];
  f.Calculated := true;
  (f as TBCDField).DisplayFormat := MatCost1Fmt;
  (f as TBCDField).EditFormat := MatCost1Fmt;
  (f as TBCDField).Precision := 18;
  f.Size := 3;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TBCDField.Create(DataSet.Owner);
  f.FieldName := F_FactMatCost1;
  f.ProviderFlags := [];
  f.Calculated := true;
  (f as TBCDField).DisplayFormat := MatCost1Fmt;
  (f as TBCDField).EditFormat := MatCost1Fmt;
  (f as TBCDField).Precision := 18;
  f.Size := 3;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := TMaterials.F_PayDate;
  f.ProviderFlags := [pfInUpdate];
  (f as TDateTimeField).DisplayFormat := CalcUtils.ShortDateFormat2;
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
end;

procedure TMaterialRequests.GetEmptyText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := '';
end;

function TMaterialRequests.GetSQL: TQueryObject;
var
  expr: string;
begin
  Result.Select := 'MatID, MatTypeName, MatDesc, opim.MatCost, MatAmount, MatUnitName, FactMatCost, FactMatAmount,'#13#10
    + ' SupplierID, '{cs.Name as SupplierName,} + ' cast(opim.MatCost * wo.Course as decimal(18,2)) as MatCostNative,'#13#10
    + ' Param1, Param2, Param3, FactParam1, FactParam2, FactParam3, InvoiceNum, MatNote, PayDate,'#13#10
    + ' ExternalMatID, RequestModified, opi.OrderID, PlanReceiveDate, FactReceiveDate, wo.Course,'#13#10
    + ' wo.Customer as CustomerID, c.Name as CustomerName, wo.FinishDate, wo.ID_Number, wo.Comment, wo.OrderState, wo.KindID, wo.CreatorName';
  Result.From := ' inner join OrderProcessItem opi on opi.ItemID = opim.ItemID'#13#10
    + ' inner join WorkOrder wo on opi.OrderID = wo.N'#13#10
    + ' left join Customer c on wo.Customer = c.N'#13#10;
//    + ' left join Customer cs on SupplierID = cs.N';

  Result.Where := 'wo.IsDraft = 0 and wo.IsDeleted = 0';
  expr := FCriteria.GetFilterExpr(Self);// AppendDateFilterExpr(Result.Where, 'wo.CreationDate', false);
  if expr <> '' then
    Result.Where := Result.Where + ' and (' + expr + ')';
  Result.Sort := FSortField;//'wo.CreationDate';
  Result.KeyFieldName := 'MatID';
  Result.TableName := 'OrderProcessItemMaterial';
  Result.TableAlias := 'opim';
end;

procedure TMaterialRequests.DoBeforeOpen;
begin
  inherited DoBeforeOpen;
  QueryObject := GetSQL;
  SetQuerySQL(DataSource, QueryObject.GetSQL);
  (DataSet as TClientDataSet).IndexFieldNames := '';
end;

function TMaterialRequests.GetCustomerName: string;
begin
  Result := NvlString(DataSet['CustomerName']);
end;

function TMaterialRequests.GetSupplierName: string;
begin
  Result := NvlString(DataSet[TMaterials.F_SupplierName]);
end;

function TMaterialRequests.GetOrderNumber: integer;
begin
  Result := NvlInteger(DataSet[TOrder.F_OrderNumber]);
end;

function TMaterialRequests.GetCreatorName: string;
begin
  Result := NvlString(DataSet[TOrder.F_CreatorName]);
end;

function TMaterialRequests.GetCustomerID: integer;
begin
  Result := NvlInteger(DataSet['CustomerID']);
end;

function TMaterialRequests.GetSupplierID: integer;
begin
  Result := NvlInteger(DataSet[TMaterials.F_SupplierID]);
end;

function TMaterialRequests.GetOrderID: integer;
begin
  Result := NvlInteger(DataSet['OrderID']);
end;

function TMaterialRequests.GetKindID: integer;
begin
  Result := NvlInteger(DataSet[TOrder.F_KindID]);
end;

function TMaterialRequests.GetRequestState: integer;
begin
  Result := NvlInteger(DataSet['MatRequestState']);
end;

function TMaterialRequests.GetExchangeRate: extended;
begin
  Result := NvlFloat(DataSet[TOrder.F_Course]);
end;

function TMaterialRequests.GetNumberField: string;
begin
  Result := TOrder.F_OrderNumber;
end;

function TMaterialRequests.GetRequestModified: boolean;
begin
  Result := NvlBoolean(DataSet[TMaterials.F_RequestModified]);
end;

function TMaterialRequests.GetMatDesc: string;
begin
  Result := NvlString(DataSet[TMaterials.F_MatDesc]);
end;

function TMaterialRequests.GetParam1: string;
begin
  Result := NvlString(DataSet[TMaterials.F_Param1]);
end;

function TMaterialRequests.GetParam2: string;
begin
  Result := NvlString(DataSet[TMaterials.F_Param2]);
end;

function TMaterialRequests.GetParam3: string;
begin
  Result := NvlString(DataSet[TMaterials.F_Param3]);
end;

function TMaterialRequests.GetFactParam1: string;
begin
  Result := NvlString(DataSet[TMaterials.F_FactParam1]);
end;

function TMaterialRequests.GetFactParam2: string;
begin
  Result := NvlString(DataSet[TMaterials.F_FactParam2]);
end;

function TMaterialRequests.GetFactParam3: string;
begin
  Result := NvlString(DataSet[TMaterials.F_FactParam3]);
end;

function TMaterialRequests.GetMatUnitName: string;
begin
  Result := NvlString(DataSet[TMaterials.F_MatUnitName]);
end;

function TMaterialRequests.GetMatTypeName: string;
begin
  Result := NvlString(DataSet[TMaterials.F_MatTypeName]);
end;

function TMaterialRequests.GetMatAmount: extended;
begin
  Result := NvlFloat(DataSet[TMaterials.F_MatAmount]);
end;

function TMaterialRequests.GetFactMatAmount: variant;
begin
  Result := DataSet[TMaterials.F_FactMatAmount];
end;

function TMaterialRequests.GetFactReceiveDate: variant;
begin
  Result := DataSet[TMaterials.F_FactReceiveDate];
end;

function TMaterialRequests.GetPlanReceiveDate: variant;
begin
  Result := DataSet[TMaterials.F_PlanReceiveDate];
end;

function TMaterialRequests.GetPayDate: variant;
begin
  Result := DataSet[TMaterials.F_PayDate];
end;

procedure TMaterialRequests.DoOnCalcFields;
var
  k: extended;
begin
  if VarIsNull(DataSet[TMaterials.F_FactMatCost]) then
  begin
    DataSet[F_MarginCost] := null;
    DataSet[F_FactMatCost1] := null;
  end
  else
  begin
    DataSet[F_MarginCost] := NvlFloat(DataSet[F_MatCostNative]) - DataSet[TMaterials.F_FactMatCost];
    k := NvlFloat(DataSet[TMaterials.F_FactMatAmount]);
    if k <> 0 then
      DataSet[F_FactMatCost1] := DataSet[TMaterials.F_FactMatCost] / k
    else
      DataSet[F_FactMatCost1] := null;
  end;
  if VarIsNull(DataSet[TMaterials.F_MatCostNative]) then
    DataSet[F_MatCost1] := null
  else
  begin
    k := NvlFloat(DataSet[TMaterials.F_MatAmount]);
    if k <> 0 then
      DataSet[F_MatCost1] := DataSet[TMaterials.F_MatCostNative] / k
    else
      DataSet[F_MatCost1] := null;
  end;
end;

end.

