unit MainFormTest;

interface

uses Classes, SysUtils,
  MainForm,
  TestFrameWork,
  PmProcess, PmProcessCfg, DICObj, Variants, PmEntity, CalcUtils;

type
  TMainFormTests = class(TTestCase)
  private
    LastGrandTotal, LastGrandTotalGrn, LastClientTotal: extended;
    LastFinishDate: TDateTime;
    DeletedList: TStringList;
    function CreateTestOrder(IsWork: boolean; OrdNum: integer; Filled: boolean): string;
    procedure DeleteTestOrder(IsWork: boolean; cm: string);
    procedure TestNew(IsWork, Filled: boolean);
    procedure TestCopy(IsWork: boolean; Filled: boolean);
    function Fill(Prc: TPolyProcess; IsWorkPtr: pointer): boolean;
    procedure FillOrder(IsWork: boolean);
    procedure FillGrid(Prc: TPolyProcess);
    procedure DeleteAllTestOrders;
    procedure CheckMoney(V1, V2: extended; Name: string);
    function CheckDeleted(Prc: TPolyProcess; IsWorkPtr: pointer): boolean;
    function DelRecord(Prc: TPolyProcess; IsWorkPtr: pointer): boolean;
    procedure TestEditDelete(IsWork: boolean);
    procedure EditOrderParams(IsWork: boolean);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    // Test methods
    procedure TestNewOrder;
    procedure TestFilledNewOrder;
    procedure TestNewDraft;
    procedure TestCopyOrder;
    procedure TestCopyDraft;
    procedure TestCopyFilledOrder;
    procedure TestCopyFilledDraft;
    //procedure TestDeleteOrder;
    //procedure TestDeleteDraft;
    procedure TestMakeOrder;
    procedure TestMakeDraft;
    procedure TestMoveToOrder;
    procedure TestMoveToDraft;
    procedure TestEditOrder;
    procedure TestEditDraft;
    procedure TestEditDraftParams;
    procedure TestEditOrderParams;
    procedure TestFilter;
    procedure TestAddShipment;
    procedure TestEditShipment;
    procedure TestDeleteShipment;
  end;

implementation

uses DB, Controls, DateUtils,

  MainData, PmProviders, PmAccessManager, Dialogs,
  ServMod, CalcSettings, RDBUtils, PmEntityController, MainFilter,
  PmAppController, RDialogs, PmDictionaryList, PmOrder, PmOrderController,
  PmDraftController, PmWorkController, PmConfigManager;

const
  CopyPrefix = '(К) ';

{$REGION 'Mock Objects'}
type
  TBaseParamsMock = class(TInterfacedObject, IOrderParamsProvider)
  private
    FComment: string;
    FOnAddAttachedFile: TNotifyEvent;
    FOnRemoveAttachedFile: TNotifyEvent;
    FOnOpenAttachedFile: TNotifyEvent;
    FOnGetCostVisible: TBooleanEvent;
    FOnAddNote: TNotifyEvent;
    FOnEditNote: TIntNotifyEvent;
    FOnDeleteNote: TIntNotifyEvent;
    FOnSelectTemplate: TNotifyEvent;
    procedure SetOnAddAttachedFile(Value: TNotifyEvent);
    procedure SetOnRemoveAttachedFile(Value: TNotifyEvent);
    procedure SetOnOpenAttachedFile(Value: TNotifyEvent);
    procedure SetOnGetCostVisible(Value: TBooleanEvent);
    procedure SetOnAddNote(Value: TNotifyEvent);
    procedure SetOnEditNote(Value: TIntNotifyEvent);
    procedure SetOnDeleteNote(Value: TIntNotifyEvent);
    procedure SetOnSelectTemplate(Value: TNotifyEvent);
    function GetOnAddAttachedFile: TNotifyEvent;
    function GetOnRemoveAttachedFile: TNotifyEvent;
    function GetOnOpenAttachedFile: TNotifyEvent;
    function GetOnGetCostVisible: TBooleanEvent;
    function GetOnAddNote: TNotifyEvent;
    function GetOnEditNote: TIntNotifyEvent;
    function GetOnDeleteNote: TIntNotifyEvent;
    function GetOnSelectTemplate: TNotifyEvent;
  public
    function ExecOrderProps(Order: TOrder; InsideOrder, ReadOnly: boolean): integer; virtual; abstract;
    constructor Create(_Comment: string);
    property OnGetCostVisible: TBooleanEvent read GetOnGetCostVisible write SetOnGetCostVisible;
    property OnAddAttachedFile: TNotifyEvent read GetOnAddAttachedFile write SetOnAddAttachedFile;
    property OnRemoveAttachedFile: TNotifyEvent read GetOnRemoveAttachedFile write SetOnRemoveAttachedFile;
    property OnOpenAttachedFile: TNotifyEvent read GetOnOpenAttachedFile write SetOnOpenAttachedFile;
    property OnAddNote: TNotifyEvent read GetOnAddNote write SetOnAddNote;
    property OnEditNote: TIntNotifyEvent read GetOnEditNote write SetOnEditNote;
    property OnDeleteNote: TIntNotifyEvent read GetOnDeleteNote write SetOnDeleteNote;
    property OnSelectTemplate: TNotifyEvent read GetOnSelectTemplate write SetOnSelectTemplate;
  end;

procedure TBaseParamsMock.SetOnAddAttachedFile(Value: TNotifyEvent);
begin
  FOnAddAttachedFile := Value;
end;

procedure TBaseParamsMock.SetOnRemoveAttachedFile(Value: TNotifyEvent);
begin
  FOnRemoveAttachedFile := Value;
end;

procedure TBaseParamsMock.SetOnOpenAttachedFile(Value: TNotifyEvent);
begin
  FOnOpenAttachedFile := Value;
end;

procedure TBaseParamsMock.SetOnGetCostVisible(Value: TBooleanEvent);
begin
  FOnGetCostVisible := Value;
end;

procedure TBaseParamsMock.SetOnAddNote(Value: TNotifyEvent);
begin
  FOnAddNote := Value;
end;

procedure TBaseParamsMock.SetOnEditNote(Value: TIntNotifyEvent);
begin
  FOnEditNote := Value;
end;

procedure TBaseParamsMock.SetOnDeleteNote(Value: TIntNotifyEvent);
begin
  FOnDeleteNote := Value;
end;

procedure TBaseParamsMock.SetOnSelectTemplate(Value: TNotifyEvent);
begin
  FOnSelectTemplate := Value;
end;

function TBaseParamsMock.GetOnAddAttachedFile: TNotifyEvent;
begin
  Result := FOnAddAttachedFile;
end;

function TBaseParamsMock.GetOnRemoveAttachedFile: TNotifyEvent;
begin
  Result := FOnRemoveAttachedFile;
end;

function TBaseParamsMock.GetOnOpenAttachedFile: TNotifyEvent;
begin
  Result := FOnOpenAttachedFile;
end;

function TBaseParamsMock.GetOnGetCostVisible: TBooleanEvent;
begin
  Result := FOnGetCostVisible;
end;

function TBaseParamsMock.GetOnAddNote: TNotifyEvent;
begin
  Result := FOnAddNote;
end;

function TBaseParamsMock.GetOnEditNote: TIntNotifyEvent;
begin
  Result := FOnEditNote;
end;

function TBaseParamsMock.GetOnDeleteNote: TIntNotifyEvent;
begin
  Result := FOnDeleteNote;
end;

function TBaseParamsMock.GetOnSelectTemplate: TNotifyEvent;
begin
  Result := FOnSelectTemplate;
end;

constructor TBaseParamsMock.Create(_Comment: string);
begin
  FComment := _Comment;
end;

type
  TWorkParamsMock = class(TBaseParamsMock)
  public
    function ExecOrderProps(Order: TOrder; InsideOrder, ReadOnly: boolean): integer; override;
  end;

function TWorkParamsMock.ExecOrderProps(Order: TOrder; InsideOrder, ReadOnly: boolean): integer;
var
  FCreateKinds: TStringList;
  DataSet: TDataSet;
begin
  DataSet := Order.DataSet;
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  AccessManager.GetPermittedKindsList(FCreateKinds, AccessManager.CurUser.ID, 'WorkCreate');
  DataSet['KindID'] := integer(FCreateKinds.Objects[0]);
  DataSet['RowColor'] := $D0C0FF;
  //DataSet['OrdState'] := 1;
  //DataSet['PayState'] := 1;
  DataSet['Comment'] := FComment;
  DataSet['Customer'] := 0;
  DataSet['FinishDate'] := IncHour(TruncSeconds(Now));
  Result := mrOk;
end;

type
  TDraftParamsMock = class(TBaseParamsMock)
  public
    function ExecOrderProps(Order: TOrder; InsideOrder, ReadOnly: boolean): integer; override;
  end;

function TDraftParamsMock.ExecOrderProps(Order: TOrder; InsideOrder, ReadOnly: boolean): integer;
var
  FCreateKinds: TStringList;
  DataSet: TDataSet;
begin
  DataSet := Order.DataSet;
  if not (DataSet.State in [dsInsert, dsEdit]) then DataSet.Edit;
  AccessManager.GetPermittedKindsList(FCreateKinds, AccessManager.CurUser.ID, 'DraftCreate');
  DataSet['KindID'] := integer(FCreateKinds.Objects[0]);
  DataSet['RowColor'] := $C0F0D0;
  //DataSet['OrdState'] := 1;
  //DataSet['PayState'] := 1;
  DataSet['Comment'] := FComment;
  DataSet['Customer'] := 0;
  Result := mrOk;
end;

type
  TMakeWorkParamsMock = class(TInterfacedObject, IMakeOrderParamsProvider)
  private
    FCopytoWork: boolean;
  public
    function IncludeAdv: boolean;
    function OrderState: integer;
    function PayState: variant;
    function RowColor: integer;
    function FinishDate: variant;
    function CopyToWork: boolean;
    procedure CreateForm;
    function Execute: integer;
    constructor Create(_CopyToWork: boolean);
  end;

function TMakeWorkParamsMock.IncludeAdv: boolean;
begin
  Result := false;
end;

function TMakeWorkParamsMock.OrderState: integer;
begin
  Result := NvlInteger(Options.DefOrderExecState);
end;

function TMakeWorkParamsMock.PayState: variant;
begin
  Result := Options.DefOrderPayState;
end;

function TMakeWorkParamsMock.RowColor: integer;
begin
  Result := $F0F0F0;
end;

function TMakeWorkParamsMock.FinishDate: variant;
begin
  Result := IncHour(Now, 1);
end;

procedure TMakeWorkParamsMock.CreateForm;
begin
end;

function TMakeWorkParamsMock.CopyToWork: boolean;
begin
  Result := FCopytoWork;
end;

constructor TMakeWorkParamsMock.Create(_CopyToWork: boolean);
begin
  FCopytoWork := _CopyToWork;
end;

function TMakeWorkParamsMock.Execute: integer;
begin
  Result := mrOk;
end;

type
  TMakeDraftParamsMock = class(TInterfacedObject, IMakeDraftParamsProvider)
  private
    FCopytoDraft: boolean;
  public
    function RowColor: integer;
    function CopyToDraft: boolean;
    procedure CreateForm;
    function Execute: integer;
    constructor Create(_CopyToDraft: boolean);
  end;

constructor TMakeDraftParamsMock.Create(_CopyToDraft: boolean);
begin
  FCopyToDraft := _CopyToDraft;
end;

procedure TMakeDraftParamsMock.CreateForm;
begin
end;

function TMakeDraftParamsMock.Execute: integer;
begin
  Result := mrOk;
end;

function TMakeDraftParamsMock.RowColor: integer;
begin
  result := 126516222;
end;

function TMakeDraftParamsMock.CopyToDraft: boolean;
begin
  Result := FCopyToDraft;
end;

type
  TCopyParamsMock = class(TInterfacedObject, ICopyParamsProvider)
  private
    FOrder: TOrder;
  public
    function Execute: integer;
    procedure CreateForm(Order: TOrder);
    function FinishDate: variant;
  end;

procedure TCopyParamsMock.CreateForm(Order: TOrder);
begin
  FOrder := Order;
end;

function TCopyParamsMock.Execute: integer;
begin
  Result := mrOk;
end;

function TCopyParamsMock.FinishDate: variant;
begin
  if FOrder is TDraftOrder then
    Result := null
  else
    Result := IncHour(Now, 1);
end;
{$ENDREGION}

{$REGION 'Utility Methods'}
function TMainFormTests.CreateTestOrder(IsWork: boolean; OrdNum: integer; Filled: boolean): string;
var
  c: integer;
  cm: string;
  ParamsProvider: IOrderParamsProvider;
  Notes: TPolyProcess;
begin
  Check(not (MForm.CurrentController as TOrderController).InsideOrder, 'Must not be inside order');
  if IsWork then
    MForm.CurrentController := MForm.FindController(TWorkController)
  else
    MForm.CurrentController := MForm.FindController(TDraftController);

  c := MForm.CurrentData.RecordCount;
  if IsWork then
  begin
    cm := 'Test Order ' + IntToStr(OrdNum);
    ParamsProvider := TWorkParamsMock.Create(cm);
  end
  else
  begin
    cm := 'Test Draft ' + IntToStr(OrdNum);
    ParamsProvider := TDraftParamsMock.Create(cm);
  end;

  (MForm.CurrentController as TOrderController).NewOrder(ParamsProvider);
  { TODO check incorrect finishdate }
  Check((MForm.CurrentController as TOrderController).InsideOrder, 'Must be inside order');

  Notes := (MForm.CurrentController as TOrderController).Order.Processes.ServiceByTabName('ClientPrice', false);
  CheckNotNull(Notes, 'ClientPrice not found');
  CheckTrue(Notes.DataSet.Active, 'Client not active');
  CheckEquals(Notes.DataSet.RecordCount, 1, 'Should be the only one ClientPrice record');

  if Filled then begin
    //dm.cdProcessItems.DisableControls;
    (MForm.CurrentController as TOrderController).DisableProcessControls;
    try
      FillOrder(IsWork);
    finally
      (MForm.CurrentController as TOrderController).EnableProcessControls;
      //dm.cdProcessItems.EnableControls;
    end;
  end;

  //Notes := sm.ServiceByTabName('Notes', false);
  //CheckEquals(Notes.DataSet.RecordCount, 1, 'Should be the only one Notes record');

  LastGrandTotal := (MForm.CurrentController as TOrderController).Order.Processes.GrandTotal;
  LastClientTotal := (MForm.CurrentController as TOrderController).Order.Processes.ClientTotal;
  LastGrandTotalGrn := (MForm.CurrentController as TOrderController).Order.Processes.GrandTotalGrn;
  if IsWork then
  begin
    LastFinishDate := MForm.CurrentData['FinishDate'];
  end;
  (MForm.CurrentController as TOrderController).SaveAndClose;
  //Check(, 'Failed saving empty order');

  Check(not (MForm.CurrentController as TOrderController).InsideOrder, 'Must not be inside order');
  CheckEquals(c + 1, MForm.CurrentData.RecordCount, 'Order not added');
  CheckEquals(MForm.CurrentData['Comment'], cm, 'Order not selected');
  CheckMoney(MForm.CurrentData['TotalCost'], LastGrandTotal, 'TotalCost after save');
  CheckMoney(MForm.CurrentData['TotalGrn'], LastGrandTotalGrn, 'TotalGrn after save');
  CheckMoney(MForm.CurrentData['ClientTotal'], LastClientTotal, 'ClientTotal after save');
  if IsWork then
  begin
    //CheckTrue(cdOrd.FieldByName('FinishDate').AsDateTime = LastFinishDate, 'FinishDate');
  end;
  // TODO: Check other parameters!
  Result := cm;
end;

function TMainFormTests.Fill(Prc: TPolyProcess; IsWorkPtr: pointer) : boolean;
var
  I, RandValue: Integer;
begin
  Result := true;

  if not boolean(IsWorkPtr^) and Prc.ProcessCfg.OnlyWorkOrder then Exit;
    
  if not Prc.DataSet.Active then
    (MForm.CurrentController as TOrderController).Order.Processes.OpenProcess(Prc)
  else if not Prc.DataSet.IsEmpty then Exit; // непустые пропускаем

  if Prc.TableName = 'Notes' then
    RandValue := 1
  else begin
    // Добавляем случайное кол-во записей
    RandValue := Random(3);
    if RandValue = 0 then RandValue := 1;  // не меньше одной
  end;

  Prc.DataSet.DisableControls;
  try
    for I := 1 to RandValue do
    begin
      Prc.DataSet.Append;
      FillGrid(Prc);
    end;
  finally
    Prc.DataSet.EnableControls;
  end;
end;

procedure TMainFormTests.FillGrid(Prc: TPolyProcess);
var
  GridList, GridCols: TCollection;
  GridCol: TGridCol;
  CurrentField : TField;
  FieldDataType : TFieldType;
  I, J, c, RandValue, StringCount: Integer;
  FieldData: TDataSet;
  Element : TDictionary;
  OldFilter: string;
  OldFiltered: boolean;
begin
  if not Prc.DataSet.Active then Exit;
  if not (Prc is TGridPolyProcess) then Exit;

  StringCount := 1;

  GridList := (Prc as TGridPolyProcess).Grids;
  if GridList.Count > 0 then
  begin
    for I := 0 to GridList.Count - 1 do
      begin
          GridCols := (GridList.Items[i] as TProcessGrid).GridCfg.GridCols;
          if (GridCols <> nil) and (GridCols.Count > 0) then begin
           for c := 0 to GridCols.Count - 1 do
           begin
              GridCol := (GridCols.Items[c] as TGridCol);

              CurrentField := Prc.DataSet.FieldByName(GridCol.FieldName);
              FieldDataType := CurrentField.DataType;

              if (CurrentField.FieldKind = fkCalculated) then
              begin
                FieldData := Prc.ProcessCfg.GetFieldInfo(GridCol.FieldName);
                if not VarIsNull(FieldData['LookupDicID']) and not VarIsNull(FieldData['LookupKeyField']) then
                begin
                  Element := TConfigManager.Instance.DictionaryList.FindID(FieldData['LookupDicID']);
                  OldFilter := Element.DicItems.Filter;
                  OldFiltered := Element.DicItems.Filtered;
                  Element.DicItems.Filter := 'Visible';
                  Element.DicItems.Filtered := true;
                  try
                    // пропускаем пустые справочники
                    if not Element.DicItems.IsEmpty then
                    begin
                      RandValue := Random(Element.DicItems.RecordCount + 1);
                      if RandValue = 0 then RandValue:=1;

                      Element.DicItems.First;
                      for J := 1 to RandValue - 1 do
                        Element.DicItems.Next;
                      Prc.DataSet.FieldByName(FieldData['LookupKeyField']).AsInteger := Element.DicItems[F_DicItemCode];
                    end;
                  finally
                    Element.DicItems.Filtered := OldFiltered;
                    Element.DicItems.Filter := OldFilter;
                  end;
                end;
              end
              else if (CurrentField.FieldKind = fkData) and CurrentField.IsNull
                and not GridCol.ReadOnly then
              begin
                if FieldDataType = ftString then
                begin
                  //StringValue:='';
                  //for J := 0 to 9 do
                  //begin
                  //  StringValue:=StringValue + Chr(Random(256));
                  //end;
                  Prc.DataSet.FieldByName(GridCol.FieldName).AsString := 'Тест ' + IntToStr(StringCount);
                  Inc(StringCount);
                end
                else if FieldDataType = ftBoolean then
                  Prc.DataSet.FieldByName(GridCol.FieldName).AsBoolean:=(Random(2) = 1)
                else if FieldDataType in [ftSmallInt, ftInteger, ftCurrency, ftBCD, ftFloat] then
                begin
                  RandValue := Random(31); //1000
                  if RandValue = 0 then RandValue := 1;
                  Prc.DataSet.Edit;
                  if FieldDataType in [ftCurrency, ftBCD] then
                    Prc.DataSet[GridCol.FieldName] := RandValue * 0.54
                  else if FieldDataType = ftFloat then
                    Prc.DataSet[GridCol.FieldName] := RandValue * 0.54
                  else if (FieldDataType = ftInteger) or (FieldDataType = ftSmallInt) then
                    Prc.DataSet[GridCol.FieldName] := RandValue;
                end;
              end
           end;
          end
      end;
  end;
end;

procedure TMainFormTests.FillOrder(IsWork: boolean);
begin
  MForm.CurrentData.FieldByName('Tirazz').AsInteger := Random(100000) + 500;
  (MForm.CurrentController as TOrderController).Order.Processes.ForEachKindProcess(Fill, @IsWork);
end;

procedure TMainFormTests.DeleteTestOrder(IsWork: boolean; cm: string);
var
  n, c: integer;
begin
  if IsWork then
    MForm.CurrentController := MForm.FindController(TWorkController)
  else
    MForm.CurrentController := MForm.FindController(TDraftController);
  CheckEquals(MForm.CurrentData['Comment'], cm, 'Delete: Comment does not match');
  n := MForm.CurrentController.Entity.KeyValue;
  c := MForm.CurrentData.RecordCount;
  (MForm.CurrentController as TOrderController).DeleteCurrent(false);
  CheckEquals(c, MForm.CurrentData.RecordCount + 1, 'Order not deleted');
  if c > 1 then
    CheckNotEquals(n, NvlInteger(MForm.CurrentController.Entity.KeyValue));
end;

procedure TMainFormTests.CheckMoney(V1, V2: extended; Name: string);
begin
  CheckTrue(Abs(V1 - V2) < 0.01, Name + ': ' + FloatToStr(V1) + ' <> ' + FloatToStr(V2));
end;

procedure TMainFormTests.TestNew(IsWork, Filled: boolean);
var
  cm: string;
begin
  cm := CreateTestOrder(IsWork, 1, Filled);
  (MForm.CurrentController as TOrderController).EditCurrent;
  CheckMoney(LastGrandTotal, (MForm.CurrentController as TOrderController).Order.Processes.GrandTotal, 'GrandTotal after edit');
  CheckMoney(LastGrandTotalGrn, (MForm.CurrentController as TOrderController).Order.Processes.GrandTotalGrn, 'GrandTotalGrn after edit');
  CheckMoney(LastClientTotal, (MForm.CurrentController as TOrderController).Order.Processes.ClientTotal, 'ClientTotal after edit');
  //if IsWork then
    //CheckTrue(cdOrd.FieldByName('FinishDate').AsDateTime = LastFinishDate, 'FinishDate');
  CheckEquals((MForm.CurrentController as TOrderController).Order.Processes.ServiceByTabName('ClientPrice', true).DataSet.RecordCount, 1, 'ClientPrice record not found');
  CheckEquals(MForm.CurrentData['Comment'], cm);
  Check((MForm.CurrentController as TOrderController).InsideOrder, 'Must be inside order');

  (MForm.CurrentController as TOrderController).CancelCurrent(nil);

  CheckEquals(MForm.CurrentData['Comment'], cm);
  Check(not (MForm.CurrentController as TOrderController).InsideOrder, 'Must not be inside order');
  // Check Comment2
  // TODO: Restore filter
  //DeleteTestOrder(IsWork, cm);
end;

function TMainFormTests.CheckDeleted(Prc: TPolyProcess; IsWorkPtr: pointer): boolean;
var
  c: Integer;
begin
  if (Prc.TableName <> 'ClientPrice') and (Prc.DataSet.Active) then
  begin
    c := DeletedList.IndexOf(Prc.TableName);
    CheckEquals(integer(DeletedList.Objects[c]), Prc.DataSet.RecordCount);
  end;
  Result := true;
end;

function TMainFormTests.DelRecord(Prc: TPolyProcess; IsWorkPtr: pointer): boolean;
var
  c, I: Integer;
begin
  if (Prc.TableName <> 'ClientPrice') and (Prc.DataSet.Active) then
  begin
    c := Prc.DataSet.RecordCount;
    c := c div 2;
    for I := 1 to C do
    begin
      Prc.DeleteRecord;
    end;
    DeletedList.AddObject(Prc.TableName, pointer(Prc.DataSet.RecordCount));
  end;
  Result := true;
end;

procedure TMainFormTests.TestCopy(IsWork: boolean; Filled: boolean);
var
  cm: string;
  c: integer;
begin
  cm := CreateTestOrder(IsWork, 1, Filled);

  c := MForm.CurrentData.RecordCount;
  //n := MForm.CurrentView.Entity.KeyValue;
  CheckTrue((MForm.CurrentController as TOrderController).CopyOrder(TCopyParamsMock.Create), 'Error copying');

  Check(not (MForm.CurrentController as TOrderController).InsideOrder, 'Must not be inside order');
  CheckEquals(c + 1, MForm.CurrentData.RecordCount, 'Order was not added');
  CheckEquals(MForm.CurrentData['Comment'], CopyPrefix + cm, 'New order is not selected');
  CheckMoney(MForm.CurrentData['TotalCost'], LastGrandTotal, 'TotalCost after copy');
  CheckMoney(MForm.CurrentData['TotalGrn'], LastGrandTotalGrn, 'TotalGrn after copy');
  CheckMoney(MForm.CurrentData['ClientTotal'], LastClientTotal, 'ClientTotal after copy');

  (MForm.CurrentController as TOrderController).EditCurrent;
  CheckEquals(MForm.CurrentData['Comment'], CopyPrefix + cm, 'Comment is not equal');
  CheckMoney(LastGrandTotal, (MForm.CurrentController as TOrderController).Order.Processes.GrandTotal, 'GrandTotal after edit');
  CheckMoney(LastGrandTotalGrn, (MForm.CurrentController as TOrderController).Order.Processes.GrandTotalGrn, 'GrandTotalGrn after edit');
  CheckMoney(LastClientTotal, (MForm.CurrentController as TOrderController).Order.Processes.ClientTotal, 'ClientTotal after edit');
  (MForm.CurrentController as TOrderController).CancelCurrent(nil);

  DeleteTestOrder(IsWork, CopyPrefix + cm);
  DeleteTestOrder(IsWork, cm);
end;

// вспомогательный методя для проверки удаления записей из процессов
// в существующем заказе
procedure TMainFormTests.TestEditDelete(IsWork: boolean);
var
  cm: string;
begin
  cm := CreateTestOrder(IsWork, 1, true);
  (MForm.CurrentController as TOrderController).EditCurrent;

  DeletedList.Clear;
  // delete random processes
  (MForm.CurrentController as TOrderController).Order.Processes.ForEachKindProcess(DelRecord, @IsWork);

  (MForm.CurrentController as TOrderController).SaveAndClose;
  (MForm.CurrentController as TOrderController).EditCurrent;

  // check deleted processes
  (MForm.CurrentController as TOrderController).Order.Processes.ForEachKindProcess(CheckDeleted, @IsWork);

  (MForm.CurrentController as TOrderController).CancelCurrent(nil);
end;

procedure TMainFormTests.EditOrderParams(IsWork: boolean);
var
  cm, NewCm: string;
begin
  cm := CreateTestOrder(IsWork, 1, true);
  NewCm := 'Edited comment';
  (MForm.CurrentController as TOrderController).EditEntityProperties((MForm.CurrentController as TOrderController).Order, TWorkParamsMock.Create(NewCm));
  MForm.CurrentController := MForm.FindController(TWorkController);
  CheckEquals(NvlString((MForm.CurrentController.Entity as TOrder).Comment), NewCm, 'Editing comment failed');
  DeleteTestOrder(IsWork, NewCm);
end;

{$ENDREGION}

{$REGION 'Test methods'}

procedure TMainFormTests.TestNewOrder;
begin
  TestNew(true,false);
end;

procedure TMainFormTests.TestFilledNewOrder;
begin
  TestNew(true,true);
end;

procedure TMainFormTests.TestNewDraft;
begin
  TestNew(true,false);
end;

procedure TMainFormTests.TestCopyOrder;
begin
  TestCopy(true, false);
end;

procedure TMainFormTests.TestCopyFilledOrder;
begin
  TestCopy(true, true);
end;

procedure TMainFormTests.TestCopyDraft;
begin
  TestCopy(false, false);
end;

procedure TMainFormTests.TestCopyFilledDraft;
begin
  TestCopy(false, true);
end;

{procedure TMainFormTests.TestDeleteOrder;
begin
end;

procedure TMainFormTests.TestDeleteDraft;
begin
end;}

// TODO: Test check finish date!
procedure TMainFormTests.TestMakeOrder;
var
  //ParamsProvider: IMakeOrderParamsProvider;
  cm: string;
begin
  cm := CreateTestOrder(false, 1, true);
  MForm.MakeWorkOrder(TMakeWorkParamsMock.Create(true));
  CheckTrue(MForm.CurrentController is TWorkController, 'Not switched to works');
  MForm.CurrentController := MForm.FindController(TDraftController);
  CheckEquals(MForm.CurrentData['Comment'], cm, 'Draft not found');
  MForm.CurrentController := MForm.FindController(TWorkController);
  CheckEquals(MForm.CurrentData['Comment'], cm, 'Order is not created');

  DeleteTestOrder(true, cm);
  DeleteTestOrder(false, cm);
end;

procedure TMainFormTests.TestMakeDraft;
var
  //ParamsProvider: IMakeDraftParamsProvider;
  cm: string;
begin
  cm := CreateTestOrder(true, 1, true);
  MForm.MakeDraftOrder(TMakeDraftParamsMock.Create(true));  // copy
  CheckTrue(MForm.CurrentController is TDraftController, 'Not switched to drafts');
  MForm.CurrentController := MForm.FindController(TWorkController);
  CheckEquals(MForm.CurrentData['Comment'], cm, 'Work not found');
  MForm.CurrentController := MForm.FindController(TDraftController);
  CheckEquals(MForm.CurrentData['Comment'], cm, 'Draft is not created');

  DeleteTestOrder(true, cm);
  DeleteTestOrder(false, cm);
end;

// TODO: Test check finish date!
procedure TMainFormTests.TestMoveToOrder;
var
  //ParamsProvider: IMakeOrderParamsProvider;
  cm: string;
begin
  cm := CreateTestOrder(false, 1, true);  // create draft
  MForm.MakeWorkOrder(TMakeWorkParamsMock.Create(false));  // move
  CheckTrue(MForm.CurrentController is TWorkController, 'Not switched to works');
  MForm.CurrentController := MForm.FindController(TDraftController);
  CheckNotEquals(NvlString(MForm.CurrentData['Comment']), cm, 'Draft is not moved');
  MForm.CurrentController := MForm.FindController(TWorkController);
  CheckEquals(MForm.CurrentData['Comment'], cm, 'Order is not created');

  DeleteTestOrder(true, cm);
end;

procedure TMainFormTests.TestMoveToDraft;
var
  //ParamsProvider: IMakeDraftParamsProvider;
  cm: string;
begin
  cm := CreateTestOrder(true, 1, true);
  MForm.MakeDraftOrder(TMakeDraftParamsMock.Create(false));  // move
  CheckTrue(MForm.CurrentController is TDraftController, 'Not switched to drafts');
  MForm.CurrentController := MForm.FindController(TWorkController);
  CheckNotEquals(NvlString(MForm.CurrentData['Comment']), cm, 'Order is not moved');
  MForm.CurrentController := MForm.FindController(TDraftController);
  CheckEquals(MForm.CurrentData['Comment'], cm, 'Draft is not created');

  DeleteTestOrder(false, cm);
end;

procedure TMainFormTests.TestEditOrder;
begin
  TestEditDelete(true); // work
end;

procedure TMainFormTests.TestEditDraft;
begin
  TestEditDelete(true); // draft
end;

procedure TMainFormTests.TestEditOrderParams;
begin
  EditOrderParams(true);
end;

procedure TMainFormTests.TestEditDraftParams;
begin
  EditOrderParams(false);
end;

procedure TMainFormTests.TestFilter;
begin
end;

procedure TMainFormTests.TestAddShipment;
var
  cm: string;
begin
  cm := CreateTestOrder(true, 1, false);
  MForm.CurrentController := MForm.FindController(TWorkController);
  (MForm.CurrentController as TWorkController).AddShipment(nil);
  CheckEquals((MForm.CurrentController as TWorkController).OrderShipment.DataSet.RecordCount, 1);
end;

procedure TMainFormTests.TestEditShipment;
var
  cm: string;
begin
  cm := CreateTestOrder(true, 1, false);
  MForm.CurrentController := MForm.FindController(TWorkController);
  (MForm.CurrentController as TWorkController).AddShipment(nil);
  CheckEquals((MForm.CurrentController as TWorkController).OrderShipment.DataSet.RecordCount, 1);
  (MForm.CurrentController as TWorkController).EditShipment(nil);
  CheckEquals((MForm.CurrentController as TWorkController).OrderShipment.DataSet.RecordCount, 1);
end;

procedure TMainFormTests.TestDeleteShipment;
var
  cm: string;
begin
  cm := CreateTestOrder(true, 1, false);
  MForm.CurrentController := MForm.FindController(TWorkController);
  (MForm.CurrentController as TWorkController).AddShipment(nil);
  CheckEquals((MForm.CurrentController as TWorkController).OrderShipment.DataSet.RecordCount, 1);
  (MForm.CurrentController as TWorkController).DeleteShipment(nil);
  CheckEquals((MForm.CurrentController as TWorkController).OrderShipment.DataSet.RecordCount, 0);
end;

{$ENDREGION}

// Отключаем фильтр оставляем только текущий месяц чтобы побыстрее
procedure TMainFormTests.SetUp;
begin
  MForm.CurrentOrderView.Order.Criteria.DisableFilter;
  MForm.CurrentOrderView.Order.Criteria.rbCurMonthChecked := true;
  MForm.CurrentOrderView.Order.Reload;
  DeletedList := TStringList.Create;
end;

procedure TMainFormTests.TearDown;
begin
  DeletedList.Free;
  //if RusMessageDlg('Удалить тестовые заказы?', mtConfirmation, mbYesNoCancel, 0) = mrYes then
  //  DeleteAllTestOrders;
end;

procedure TMainFormTests.DeleteAllTestOrders;
begin
  //Заказы
  MForm.CurrentController := MForm.FindController(TWorkController);
  MForm.CurrentOrderView.Order.Criteria.edCommentText := 'Test Order';
  MForm.CurrentOrderView.Order.Criteria.cbCommentChecked := true;
  MForm.CurrentOrderView.Order.Reload;
  MForm.CurrentData.First;
  while not MForm.CurrentData.Eof do
  begin
    if Pos('Test Order', MForm.CurrentData['Comment']) = 0 then
      raise Exception.Create('Attempt to delete not a test order');

    (MForm.CurrentController as TOrderController).DeleteCurrent(false);  // do not ask confirm
  end;

  // Расчеты
  MForm.CurrentController := MForm.FindController(TDraftController);
  MForm.CurrentOrderView.Order.Criteria.edCommentText := 'Test Draft';
  MForm.CurrentOrderView.Order.Reload;
  MForm.CurrentData.First;
  while not MForm.CurrentData.Eof do
  begin
    if Pos('Test Order', MForm.CurrentData['Comment']) = 0 then
      raise Exception.Create('Attempt to delete not a test order');

    (MForm.CurrentController as TOrderController).DeleteCurrent(false);  // do not ask confirm
  end;

  MForm.CurrentOrderView.Order.Criteria.cbCommentChecked := false;
  MForm.CurrentOrderView.Order.Criteria.edCommentText := '';
  MForm.CurrentOrderView.Order.Reload;
end;

initialization

  TestFramework.RegisterTest('MainFormTests Suite',
    TMainFormTests.Suite);

end.
