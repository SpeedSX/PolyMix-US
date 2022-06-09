unit PmShipment;

interface

uses DB, SysUtils, Variants, DBClient,

  CalcUtils, PmEntity, MainFilter;

type
  TShipmentDetailMode = (ShipmentDetailMode_WithTotals, ShipmentDetailMode_AllWithTotals,
    ShipmentDetailMode_Simple);

  TShipment = class(TEntity)
  private
    FCriteria: TShipmentFilterObj;
    procedure GetTableName(Sender: TObject; DataSet: TDataSet;
      var TableName: WideString);
    //procedure StoreOutCommentGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure ShipmentStateGetText(Sender: TField; var Text: String; DisplayText: Boolean);
  protected
    FDataSource: TDataSource;
    FDetailMode: TShipmentDetailMode;
    procedure CreateFields;
    procedure DoBeforeOpen; override;
    procedure DoOnNewRecord; override;
    function GetSQL: string;
    function GetShipmentDate: TDateTime;
    procedure SetShipmentDate(Value: TDateTime);
    function GetShipmentDocNum: variant;
    procedure SetShipmentDocNum(Value: variant);
    function GetShipmentDocID: variant;
    procedure SetShipmentDocID(Value: variant);
    function GetOrderID: integer;
    procedure SetOrderID(Value: integer);
    function GetOrderNumber: integer;
    procedure SetOrderNumber(Value: integer);
    function GetProductNumber: integer;
    procedure SetProductNumber(Value: integer);
    function GetNumberToShip: integer;
    procedure SetNumberToShip(Value: integer);
    function GetIsTotal: boolean;
    procedure SetIsTotal(Value: boolean);
    function GetIsFirstRow: boolean;
    procedure SetIsFirstRow(Value: boolean);
    function GetTotalNumberShipped: integer;
    procedure DoAfterOpen; override;
    function GetCustomerName: string;
    function GetCustomerID: integer;
    function GetWhoIn: string;
    function GetWhoOut: string;
    function GetComment: string;
    function GetItemText: string;
    procedure SetItemText(Value: string);
    function GetBatchNum: variant;
    function GetTrustSerie: variant;
    function GetTrustNum: variant;
    function GetTrustDate: variant;
    {function GetNotes: variant;
    procedure SetNotes(Value: variant);}
    procedure ProviderBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
      var Applied: Boolean); override;
  public
    const
      F_ShipmentKey = 'ShipmentID';
      F_ProductNumber = 'Tirazz';
      F_NumberToShip = 'Quantity';
      //F_TotalNumberShipped = 'TotalNumberShipped';
      F_ShipmentDate = 'ShipmentDate';
      F_ShipmentDocNum = 'ShipmentDocNum';
      F_ShipmentDocID = 'ShipmentDocID';
      F_WhoIn = 'WhoIn';
      F_WhoOut = 'WhoOut';
      F_Comment = 'Comment';

    constructor Create; override;
    property DataSource: TDataSource read FDataSource;
    //property CustomerID: variant read GetCustomerID write SetCustomerID;
    property ShipmentDocNum: variant read GetShipmentDocNum write SetShipmentDocNum;
    property ShipmentDate: TDateTime read GetShipmentDate write SetShipmentDate;
    property ShipmentDocID: variant read GetShipmentDocID write SetShipmentDocID;
    property OrderID: integer read GetOrderID write SetOrderID;
    property OrderNumber: integer read GetOrderNumber write SetOrderNumber;
    property CustomerName: string read GetCustomerName;
    property CustomerID: integer read GetCustomerID;
    property WhoIn: string read GetWhoIn;
    property WhoOut: string read GetWhoOut;
    property Comment: string read GetComment;
    property ItemText: string read GetItemText write SetItemText;
    property BatchNum: variant read GetBatchNum;
    property TrustSerie: variant read GetTrustSerie;
    property TrustNum: variant read GetTrustNum;
    property TrustDate: variant read GetTrustDate;
    // общий тираж изделий
    property ProductNumber: integer read GetProductNumber write SetProductNumber;
    // отгружено изделий
    property NumberToShip: integer read GetNumberToShip write SetNumberToShip;
    // всего отгружено изделий по заказу
    property TotalNumberShipped: integer read GetTotalNumberShipped;
    property IsTotal: boolean read GetIsTotal write SetIsTotal;
    property IsFirstRow: boolean read GetIsFirstRow write SetIsFirstRow;
    //property Notes: variant read GetNotes write SetNotes;
    destructor Destroy; override;
    property Criteria: TShipmentFilterObj read FCriteria write FCriteria;
    property DetailMode: TShipmentDetailMode read FDetailMode write FDetailMode;
  end;

implementation

uses Forms, Provider, Graphics,

  RDBUtils, JvInterpreter_CustomQuery, PmDatabase, PlanData, PmOrder,
  PmContragent, DicObj, StdDic, PmShipmentDoc;

const
  clFirst = clWindow;
  clSecond = clInfoBk;

constructor TShipment.Create;
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
  FKeyField := F_ShipmentKey;

  FInternalName := ClassName;
  DefaultLastRecord := true;
  FAssignKeyValue := true;

  SetDataSet(_DataSet);
  _Provider.UpdateMode := upWhereKeyOnly;
  _Provider.OnGetTableName := GetTableName;
  DataSetProvider := _Provider;

  //FDataSource.Free;  // мен€ем на свой
  FDataSource := _DataSource;

  CreateFields;

  SetLength(FDateFields, 6);
  FDateFields[0] := 'wo.CreationDate';
  FDateFields[1] := 'wo.ModifyDate';
  FDateFields[2] := 'wo.FinishDate';
  FDateFields[3] := 'wo.FactFinishDate';
  FDateFields[4] := 'wo.CloseDate';
  FDateFields[5] := 'sh.ShipmentDate';

  FDetailMode := ShipmentDetailMode_WithTotals;
end;

destructor TShipment.Destroy;
begin
  inherited;
end;

procedure TShipment.CreateFields;
var
  f: TField;
begin
  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_ShipmentKey;
  f.ProviderFlags := [pfInKey, pfInWhere];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := F_ShipmentDate;
  (f as TDateTimeField).DisplayFormat := ShortDateFormat2;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_ShipmentDocID;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'Customer';
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  {f := TIntegerField.Create(nil);
  f.FieldName := 'SyncState';
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;}

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'OrderID';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  {f := TStringField.Create(nil);
  f.FieldName := 'Notes';
  f.Size := 300;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(nil);
  f.FieldName := 'UserLogin';
  f.Size := 50;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(nil);
  f.FieldName := 'UserName';
  f.ReadOnly := true;
  f.Size := 50;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;}

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TShipmentDoc.F_WhoOut;
  f.Size := 40;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TShipmentDoc.F_WhoIn;
  f.Size := 40;
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
  //f.OnGetText := StoreOutCommentGetText;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'CustomerFullName';
  f.ReadOnly := true;
  f.Size := 300;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_Comment;
  f.ReadOnly := true;
  f.Size := TOrder.CommentSize;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  //f.OnGetText := StoreOutCommentGetText;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_NumberToShip;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := TOrder.F_OrderNumber;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  (f as TNumericField).DisplayFormat := CalcUtils.OrderNumDisplayFmt;
  //f.OnGetText := StoreOutCommentGetText;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_ProductNumber;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  //f.OnGetText := StoreOutCommentGetText;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := 'ShipmentApproved';
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'ShipmentState';
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.OnGetText := ShipmentStateGetText;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'BatchNum';
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'ItemText';
  f.Size := TOrder.CommentSize;
  f.ProviderFlags := [pfInUpdate];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := F_ShipmentDocNum;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'TrustSerie';
  f.Size := 19;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TStringField.Create(DataSet.Owner);
  f.FieldName := 'TrustNum';
  f.Size := 31;
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  f := TDateTimeField.Create(DataSet.Owner);
  f.FieldName := 'TrustDate';
  f.ProviderFlags := [];
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;

  // INTERNALCALC

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := 'IsTotal';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.FieldKind := fkInternalCalc;

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'IntCount';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.FieldKind := fkInternalCalc;

  {f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'NOutToSum';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.FieldKind := fkInternalCalc;}

  f := TIntegerField.Create(DataSet.Owner);
  f.FieldName := 'RColor';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.FieldKind := fkInternalCalc;

  f := TBooleanField.Create(DataSet.Owner);
  f.FieldName := 'FirstRow';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.FieldKind := fkInternalCalc;

  // Aggregate

  {f := TAggregateField.Create(DataSet.Owner);
  f.FieldName := 'TotalNumberShipped';
  f.DataSet := DataSet;
  f.Name := DataSet.Name + f.FieldName;
  f.FieldKind := fkAggregate;
  (f as TAggregateField).Expression := 'sum(NOutToSum)';
  (f as TAggregateField).Active := true;}

  NewRecordProc := 'up_NewShipment';
  DeleteRecordProc := 'up_DeleteShipment';
end;

{procedure TShipment.StoreOutCommentGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
end;}

procedure TShipment.ShipmentStateGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := '';
end;

function TShipment.GetSQL: string;
var
  expr: string;
  ShipmentFilter: string;
begin
  ShipmentFilter := '';
  if NvlInteger(FCriteria.ShipmentID) > 0 then
    ShipmentFilter := 'sh.ShipmentID = ' + VarToStr(FCriteria.ShipmentID)
  else
    FCriteria.AppendDateFilterExpr(ShipmentFilter, TShipmentDoc.F_ShipmentDate, false);

  Result := 'select ShipmentID, sh.ShipmentDocID, Quantity, ShipmentDate, wo.Tirazz, wo.ShipmentApproved,'#13#10
    + ' wo.Customer, sh.OrderID, c.Name as CustomerName, c.FullName as CustomerFullName,'#13#10
    + ' WhoOut, WhoIn, wo.Comment, wo.ID_Number, ItemText, BatchNum, TrustSerie, TrustNum, TrustDate, ShipmentDocNum,'#13#10
    + TWorkOrder.GetShipmentStateExpr + #13#10
    + 'from Shipment sh inner join ShipmentDoc shd on shd.ShipmentDocID = sh.ShipmentDocID'#13#10
    + ' inner join WorkOrder wo on wo.N = sh.OrderID'#13#10
    + ' inner join Customer c on wo.Customer = c.N'#13#10;

  if FCriteria.Mode = TShipmentFilterObj.Mode_Normal then
  begin
    if FCriteria.cbCustChecked and (FCriteria.lcCustKeyValue > 0) then
    begin
      expr := 'wo.Customer = ' + IntToStr(FCriteria.lcCustKeyValue);
      if ShipmentFilter <> '' then
        ShipmentFilter := '(' + ShipmentFilter + ') and (' + expr + ')'
      else
        ShipmentFilter := expr;
    end;
    if not VarIsNull(FCriteria.OrderID) and not VarIsEmpty(FCriteria.OrderID) then
    begin
      expr := 'wo.N = ' + IntToStr(FCriteria.OrderID);
      if ShipmentFilter <> '' then
        ShipmentFilter := '(' + ShipmentFilter + ') and (' + expr + ')'
      else
        ShipmentFilter := expr;
    end;
    if not VarIsNull(FCriteria.ShipmentDocID) and not VarIsEmpty(FCriteria.ShipmentDocID) then
    begin
      expr := 'sh.ShipmentDocID = ' + VarToStr(FCriteria.ShipmentDocID);
      if ShipmentFilter <> '' then
        ShipmentFilter := '(' + ShipmentFilter + ') and (' + expr + ')'
      else
        ShipmentFilter := expr;
    end;
  end
  else
  if FCriteria.Mode = TShipmentFilterObj.Mode_Empty then
    ShipmentFilter := '1 = 0'
  else
  if FCriteria.Mode = TShipmentFilterObj.Mode_TempTable then
    Result := Result + 'inner join #OrderIDs ids on sh.OrderID = ids.OrderID' + #13#10;

  {if FCriteria.cbCreatorChecked and (FCriteria.CreatorName <> '') then
  begin
    expr := 'exists(select * from WorkOrder wo inner join InvoiceItems ii on ii.OrderID = wo.N'#13#10
      + ' where ii.InvoiceID = i.InvoiceID and wo.CreatorName = ''' + FCriteria.CreatorName + ''')';
    if InvFilter <> '' then
      InvFilter := '(' + InvFilter + ') and (' + expr + ')'
    else
      InvFilter := expr;
  end;}

  if ShipmentFilter <> '' then
    Result := Result + 'where ' + ShipmentFilter;

  Result := Result + #13#10'order by ' + TShipmentDoc.F_ShipmentDate;
end;

procedure TShipment.DoBeforeOpen;
begin
  inherited DoBeforeOpen;
  SetQuerySQL(DataSource, GetSQL);
  (DataSet as TClientDataSet).IndexFieldNames := '';
end;

function TShipment.GetShipmentDate: TDateTime;
begin
  Result := NvlDateTime(DataSet['ShipmentDate']);
end;

procedure TShipment.SetShipmentDate(Value: TDateTime);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['ShipmentDate'] := Value;
end;

function TShipment.GetShipmentDocNum: variant;
begin
  Result := DataSet['ShipmentDocNum'];
end;

procedure TShipment.SetShipmentDocNum(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['ShipmentDocNum'] := Value;
end;

function TShipment.GetShipmentDocID: variant;
begin
  Result := DataSet['ShipmentDocID'];
end;

procedure TShipment.SetShipmentDocID(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['ShipmentDocID'] := Value;
end;

function TShipment.GetOrderID: integer;
begin
  Result := NvlInteger(DataSet['OrderID']);
end;

procedure TShipment.SetOrderID(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['OrderID'] := Value;
end;

function TShipment.GetOrderNumber: integer;
begin
  Result := NvlInteger(DataSet[TOrder.F_OrderNumber]);
end;

procedure TShipment.SetOrderNumber(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[TOrder.F_OrderNumber] := Value;
end;

function TShipment.GetProductNumber: integer;
begin
  Result := NvlInteger(DataSet[F_ProductNumber]);
end;

procedure TShipment.SetProductNumber(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_ProductNumber] := Value;
end;

function TShipment.GetNumberToShip: integer;
begin
  Result := NvlInteger(DataSet[F_NumberToShip]);
end;

procedure TShipment.SetNumberToShip(Value: integer);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet[F_NumberToShip] := Value;
end;

function TShipment.GetIsTotal: boolean;
begin
  Result := NvlBoolean(DataSet['IsTotal']);
end;

procedure TShipment.SetIsTotal(Value: boolean);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['IsTotal'] := Value;
end;

function TShipment.GetIsFirstRow: boolean;
begin
  Result := NvlBoolean(DataSet['FirstRow']);
end;

procedure TShipment.SetIsFirstRow(Value: boolean);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['FirstRow'] := Value;
end;

function TShipment.GetCustomerName: string;
begin
  Result := NvlString(DataSet['CustomerName']);
end;

function TShipment.GetCustomerID: integer;
begin
  Result := NvlInteger(DataSet['Customer']);
end;

function TShipment.GetWhoIn: string;
begin
  Result := NvlString(DataSet[TShipmentDoc.F_WhoIn]);
end;

function TShipment.GetWhoOut: string;
begin
  Result := NvlString(DataSet[TShipmentDoc.F_WhoOut]);
end;

function TShipment.GetComment: string;
begin
  Result := NvlString(DataSet['Comment']);
end;

function TShipment.GetItemText: string;
begin
  Result := NvlString(DataSet['ItemText']);
end;

procedure TShipment.SetItemText(Value: string);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['ItemText'] := Value;
end;

function TShipment.GetBatchNum: variant;
begin
  Result := DataSet['BatchNum'];
end;

function TShipment.GetTrustSerie: variant;
begin
  Result := DataSet['TrustSerie'];
end;

function TShipment.GetTrustNum: variant;
begin
  Result := DataSet['TrustNum'];
end;

function TShipment.GetTrustDate: variant;
begin
  Result := DataSet['TrustDate'];
end;

// ќпредел€ем общее кол-во отгрузок по закащу - ищем итоговую строку
function TShipment.GetTotalNumberShipped: integer;
var
  CurID: integer;
begin
  //Result := NvlInteger(DataSet[F_TotalNumberShipped]);
  Result := 0;
  if FDetailMode <> ShipmentDetailMode_Simple then
  begin
    if not DataSet.IsEmpty then
    begin
      if IsTotal then
        Result := NumberToShip
      else
      begin
        // в режиме с итогами ищем метку итога
        CurID := KeyValue;
        DataSet.DisableControls;
        try
          while not DataSet.eof do
          begin
            if IsTotal then
            begin
              Result := NumberToShip;
              break;
            end;
            DataSet.Next;
          end;
        finally
          Locate(CurID);
          DataSet.EnableControls;
        end;
      end;
    end;
  end
  else
  begin     // просто суммируем
    CurID := NvlInteger(KeyValue);
    DataSet.DisableControls;
    DataSet.First;
    try
      while not DataSet.eof do
      begin
        Result := Result + NumberToShip;
        DataSet.Next;
      end;
    finally
      if CurID <> 0 then Locate(CurID);
      DataSet.EnableControls;
    end;
  end;
end;

{function TShipment.GetNotes: variant;
begin
  Result := DataSet['Notes'];
end;

procedure TShipment.SetNotes(Value: variant);
begin
  if not (DataSet.State in [dsInsert, dsEdit]) then
    DataSet.Edit;
  DataSet['Notes'] := Value;
end;}

procedure TShipment.GetTableName(Sender: TObject; DataSet: TDataSet;
    var TableName: WideString);
begin
  TableName := 'Shipment';
end;

procedure TShipment.DoOnNewRecord;
begin
  inherited;
end;

procedure TShipment.DoAfterOpen;
var
  ODTemp_IntCount, ODTemp_CurID, ODTemp_CurN, ODTemp_TotalOut, ODTemp_OutCount: integer;
  ODTemp_Color: TColor;

  procedure NextOrder(LastOrder: boolean);
  begin
    //–ешаем, делать итоговую строку или нет.
    if (DetailMode = ShipmentDetailMode_AllWithTotals)
       or ((DetailMode = ShipmentDetailMode_WithTotals) and (ODTemp_OutCount > 1)) then
    begin
      if not LastOrder then
      begin
        ODTemp_OutCount := 1;                           // Ёто перва€ строка следующего заказа
        IsFirstRow := true;
        ODTemp_CurN := KeyValue;
        DataSet['IntCount'] := ODTemp_IntCount;
        ODTemp_CurID := OrderID;
      end
      else
        ODTemp_CurN := -1;

      DataSet.Append;               // —троим итоговую строку предыдущего заказа
      IsFirstRow := false;
      IsTotal := true;
      OrderID := ODTemp_CurID;
      NumberToShip := ODTemp_TotalOut;
      //DataSet['NOutToSum'] := 0;
      DataSet['IntCount'] := ODTemp_IntCount - 1;
      DataSet['RColor'] := ODTemp_Color;
      ODTemp_IntCount := ODTemp_IntCount + 1;
      if ODTemp_CurN <> -1 then begin
        Locate(ODTemp_CurN);  // возвращаемс€
        ODTemp_TotalOut := NumberToShip;  // Ёто перва€ строка следующего заказа
        if ODTemp_Color = clFirst then ODTemp_Color := clSecond else ODtemp_Color := clFirst; // мен€ем цвет
        DataSet.Edit;
        DataSet['RColor'] := ODTemp_Color;
      end;
    end
    else
    if DetailMode = ShipmentDetailMode_WithTotals then
    begin
      if not LastOrder then
      begin
        ODTemp_TotalOut := NumberToShip;  // Ёто перва€ строка следующего заказа
        ODTemp_OutCount := 1;
        IsFirstRow := true;
        ODTemp_CurID := OrderID;
        IsTotal := false;
        if ODTemp_Color = clFirst then ODTemp_Color := clSecond else ODtemp_Color := clFirst; // мен€ем цвет
        DataSet['RColor'] := ODTemp_Color;
      end
      else
      begin
        IsTotal := true;  // ѕоследн€€ строка
        OrderID := ODTemp_CurID;
      end;
      DataSet.Prior;
      if IsFirstRow then
        IsTotal := true;
        //if LastOrder then MessageDlg('IsTotal := true, NOut = ' + IntToStr(ODTemp_DataSet['NOut']), mtInformation, [mbOk], 0);
      if not LastOrder then DataSet.Next;
    end;
  end;

begin
  inherited;
  if (DetailMode <> ShipmentDetailMode_Simple) and (DataSet.RecordCount > 0) then
  begin
    DataSet.DisableControls;
    DataSet.First;
    ODTemp_IntCount := 1;
    ODTemp_CurID := -1;
    ODTemp_OutCount := 1;
    ODTemp_TotalOut := 0;
    ODTemp_Color := clFirst;
    // IntCount нумерует все строки, потом упор€дочиваем их индексом.
    // ѕросматриваем до тех пор, пока не дойдем до конца или до итоговых строк,
    // которые добавл€ютс€ в конец.
    while not DataSet.eof and (VarIsNull(DataSet['IsTotal']) or not DataSet['IsTotal']) do
    begin
      DataSet.Edit;
      DataSet['IntCount'] := ODTemp_IntCount;
      ODTemp_IntCount := ODTemp_IntCount + 1;
      DataSet['IsTotal'] := false;
      //DataSet['NOutToSum'] := DataSet['NOut'];
      DataSet['RColor'] := ODTemp_Color;
      if ODTemp_CurID < 0 then begin
        ODTemp_CurID := OrderID;
        ODTemp_TotalOut := NumberToShip;
        DataSet['FirstRow'] := true;
      end else if OrderID = ODTemp_CurID then begin
        ODTemp_TotalOut := ODTemp_TotalOut + NumberToShip;
        ODTemp_OutCount := ODTemp_OutCount + 1;
        DataSet['FirstRow'] := false;
      end else
        NextOrder(false); // ѕерешли на следующий заказ.
      DataSet.Next;
    end;
    NextOrder(true);

    (DataSet as TClientDataSet).AddIndex('iIntCount', 'IntCount', []);
    (DataSet as TClientDataSet).IndexDefs.Update;
    (DataSet as TClientDataSet).IndexFieldNames := 'IntCount';
    DataSet.EnableControls;
  end;
end;

procedure TShipment.ProviderBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
  var Applied: Boolean); 
begin
  if (UpdateKind = ukInsert) and VarIsNull(DeltaDS[TShipmentDoc.F_ShipmentDocKey]) then
    Applied := true
  else
    inherited ProviderBeforeUpdateRecord(Sender, SourceDS, DeltaDS, UpdateKind, Applied);
end;

end.
