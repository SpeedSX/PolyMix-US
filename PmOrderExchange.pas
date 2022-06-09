unit PmOrderExchange;

{$I Calc.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, {IniFiles, }StdCtrls, Mask, JvToolEdit, Buttons, PmProcess, Variants,
  JvExMask, JvBrowseFolder, JvAppXMLStorage, jvAppStorage, TLoggerUnit,

  DicObj, PmContragent, PmOrder,
  PmEntSettings, PmEntity, PmProviders, CalcUtils;

var
  ScriptDir: string;

type
  TStorageClass = TJvAppXMLFileStorage;

  TOrderInfo = record
    ID_Number: integer;
    Comment: string;
    CustomerName: string;
    CreationDate, ModifyDate: TDateTime;
    CreatorName, ModifierName: string;
    TotalCost: extended;
    IsWork: boolean;
    KindID: integer;
  end;

  TOrderExchange = class(TObject)
  private
    WriteFin: boolean;
    CommentAdd: string;
    ExpF: TStorageClass;
    CurOrder: TOrder;
    function EachWriteService(Srv: TPolyProcess): boolean;
    function EachReadService(Srv: TPolyProcess): boolean;
    function ExportServiceData(Srv: TPolyProcess): boolean;
    function ImportServiceData(Srv: TPolyProcess): boolean;
    procedure CreateReadStorage(FName: string);
    procedure CreateWriteStorage(FName: string);
    procedure FreeStorage;
    procedure ExportField(sf: TField; ProcessData: TDataSet; SecName: string);
    function ImportField(sf: TField; dqc: TDataSet; SecName: string): boolean;
    procedure AlertUnknownField(sf: TField);
  public
    function ExportOrder(Order: TOrder; FName: string): boolean;
    function ImportOrder(Order: TOrder; FName: string): boolean;
    function ReadOrderInfo(FName: string; var OrderInfo: TOrderInfo): boolean;
  end;

  TOrderImportParamsProvider = class(TInterfacedObject, IOrderParamsProvider)
  private
    FOrderInfo: TOrderInfo;
    FFileName: string;
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
    function ExecOrderProps(Order: TOrder; InsideOrder, ReadOnly: boolean): integer;
    property FileName: string read FFileName write FFileName;
    property OnGetCostVisible: TBooleanEvent read GetOnGetCostVisible write SetOnGetCostVisible;
    property OnAddAttachedFile: TNotifyEvent read GetOnAddAttachedFile write SetOnAddAttachedFile;
    property OnRemoveAttachedFile: TNotifyEvent read GetOnRemoveAttachedFile write SetOnRemoveAttachedFile;
    property OnOpenAttachedFile: TNotifyEvent read GetOnOpenAttachedFile write SetOnOpenAttachedFile;
    property OnAddNote: TNotifyEvent read GetOnAddNote write SetOnAddNote;
    property OnEditNote: TIntNotifyEvent read GetOnEditNote write SetOnEditNote;
    property OnDeleteNote: TIntNotifyEvent read GetOnDeleteNote write SetOnDeleteNote;
    property OnSelectTemplate: TNotifyEvent read GetOnSelectTemplate write SetOnSelectTemplate;
  end;

var
  OrderExchange: TOrderExchange;

implementation

uses MainData, RDialogs,
   ADOUtils, RDBUtils, ServMod, JvJCLUtils, CalcSettings, ExHandler;

const
  MaxItems = 255;
  secCommon = 'Common\';
  secFinance = 'Finance\';
  secServices = 'Processes\';
  RootNode = 'Order';
  ProcessItemExportFields = 'Enabled,ItemProfit,ItemDesc,Part'
    + ',Contractor,ContractorProcess,ContractorPercent,ContractorCost,ManualContractorCost,FactContractorCost,ContractorPayDate'
    + ',OwnCost,OwnPercent'
    + ',EstimatedDuration,LinkedItemID,SequenceOrder,MatPercent,MatCost'
    + ',FactProductIn,FactProductOut,Multiplier,SideCount,ProductIn,ProductOut,EquipCode'
    + ',FactStartDate,FactFinishDate,PlanStartDate,PlanFinishDate,IsPaused';
  ProcessItemImportFields = 'Enabled,Part'
    + ',Contractor,ContractorProcess,ContractorPercent,ManualContractorCost,FactContractorCost,ContractorPayDate'
    + ',EstimatedDuration,SequenceOrder,'
    + ',FactProductIn,FactProductOut,EquipCode'
    + ',FactStartDate,FactFinishDate,PlanStartDate,PlanFinishDate,IsPaused';
  secMaterials = 'Materials\';
  secJobs = 'Jobs\';

// ----------------------------- Export utilities ------------------------------

function ExportedField(sf: TField): boolean;
begin
  Result := (sf.FieldKind <> fkCalculated)
      and ((sf.Tag = ftData) or (sf.Tag = ftIndependent))
      and (CompareText(sf.FieldName, F_ProcessKey) <> 0)
      and (CompareText(sf.FieldName, F_ItemID) <> 0)
      and not IsWordPresent(sf.FieldName, ProcessItemExportFields, [',']);
end;

function ImportedField(sf: TField): boolean;
begin
  Result := (sf.FieldKind <> fkCalculated)
      and ((sf.Tag = ftData) or (sf.Tag = ftIndependent))
      and (CompareText(sf.FieldName, F_ProcessKey) <> 0)
      and (CompareText(sf.FieldName, F_ItemID) <> 0)
      and not IsWordPresent(sf.FieldName, ProcessItemImportFields, [',']);
end;

procedure WNotNullS(IniF: TStorageClass; dq: TDataSet; SecName, FName: string);
begin
    if not VarIsNull(dq[FName]) then
      IniF.WriteString(SecName + FName, dq[FName]);
end;

procedure WNotNullI(IniF: TStorageClass; dq: TDataSet; SecName, FName: string);
begin
    if not VarIsNull(dq[FName]) then
      IniF.WriteInteger(SecName + FName, dq[FName]);
end;

procedure WNotNullF(IniF: TStorageClass; dq: TDataSet; SecName, FName: string);
begin
    if not VarIsNull(dq[FName]) then
      IniF.WriteFloat(SecName + FName, dq[FName]);
end;

procedure WNotNullB(IniF: TStorageClass; dq: TDataSet; SecName, FName: string);
begin
    if not VarIsNull(dq[FName]) then
      IniF.WriteInteger(SecName + FName, Ord(dq.FieldByName(FName).AsBoolean));
end;

procedure WNotNullD(IniF: TStorageClass; dq: TDataSet; SecName, FName: string);
var
  dt: TdateTime;
  idt: int64 absolute dt;
begin
    if not VarIsNull(dq[FName]) then
    begin
      dt := dq[FName];
      IniF.WriteString(SecName + FName, IntToStr(idt));
    end;
end;

procedure WNotNullM(IniF: TStorageClass; dq: TDataSet; SecName, FName: string);
var
  sl: TStringList;
begin
    if not dq.FieldByName(FName).IsNull then
    begin
      sl := nil;
      try
        ReadStringListFromBlob(sl, dq.FieldByName(FName) as TBlobField);
        //IniF.WriteString(SecName + FName, sl.Text);
        IniF.WriteStringList(SecName + FName, sl);
      finally
        if sl <> nil then sl.Free;
      end;
    end;
end;

procedure WriteDate(IniF: TStorageClass; SecName, FName: string; Value: TDateTime);
var
  dt: TDateTime;
  idt: int64 absolute dt;
begin
  dt := Value;
  IniF.WriteString(SecName + FName, IntToStr(idt));
end;

// ----------------------------- Import utilities ------------------------------

function SearchName(Data: TDictionary; Name: string): integer;
begin
  if Name = '' then
    Result := -1
  else begin
 //  if AnsiCompareText(Data[i], Name) = 0 then begin Result := i; Exit; end;
    Result := Data.ItemCode[Name];
    if Result = -1 then
       RusMessageDlg('Не найдено значение ''' + Name + '''', mtError, [mbOk], 0);
  end;
end;

procedure RNotNullF(IniF: TStorageClass; dq: TDataSet; SecName, FName: string);
var
  v: extended;
begin
    if IniF.ValueStored(SecName + FName) then
    begin
      if not (dq.State in [dsInsert, dsEdit]) then dq.Edit;
      v := IniF.ReadFloat(SecName + FName, 0);
      dq[FName] := v;
    end;
end;

procedure RNotNullI(IniF: TStorageClass; dq: TDataSet; SecName, FName: string);
begin
    if IniF.ValueStored(SecName + FName) then begin
      if not (dq.State in [dsInsert, dsEdit]) then dq.Edit;
      dq[FName] := IniF.ReadInteger(SecName + FName, 0);
    end;
end;

procedure RNotNullS(IniF: TStorageClass; dq: TDataSet; SecName, FName: string);
begin
    if IniF.ValueStored(SecName + FName) then begin
      if not (dq.State in [dsInsert, dsEdit]) then dq.Edit;
      dq[FName] := IniF.ReadString(SecName + FName, '');
    end;
end;

procedure RNotNullB(IniF: TStorageClass; dq: TDataSet; SecName, FName: string);
begin
    if IniF.ValueStored(SecName + FName) then begin
      if not (dq.State in [dsInsert, dsEdit]) then dq.Edit;
      dq.FieldByName(FName).AsBoolean := (IniF.ReadInteger(SecName + FName, 0) = 1);
    end;
end;

procedure RNotNullD(IniF: TStorageClass; dq: TDataSet; SecName, FName: string);
var
  dt: TDateTime;
  idt: int64 absolute dt;
begin
    if IniF.ValueStored(SecName + FName) then
    begin
      if not (dq.State in [dsInsert, dsEdit]) then dq.Edit;
      idt := StrToInt64(IniF.ReadString(SecName + FName, '0'));
      if dt <> 0 then dq[FName] := dt;
    end;
end;

procedure RNotNullM(IniF: TStorageClass; dq: TDataSet; SecName, FName: string);
var
  sl: TStringList;
begin
  if IniF.ValueStored(SecName + FName) then
  begin
    sl := TStringList.Create;
    try
      IniF.ReadStringList(SecName + FName, sl, false);
      WriteStringListToBlob(sl, dq.FieldByName(FName) as TBlobField);
    finally
      sl.Free;
    end;
  end;
end;

function ReadDate(IniF: TStorageClass; SecName, FName: string): TDateTime;
var
  dt: TDateTime;
  idt: int64 absolute dt;
begin
  idt := StrToInt64(IniF.ReadString(SecName + FName, '0'));
  Result := dt;
end;

function ReadString(IniF: TStorageClass; SecName, FName: string): string;
begin
  Result := IniF.ReadString(SecName + FName, '');
end;

function ReadFloat(IniF: TStorageClass; SecName, FName: string): extended;
begin
  Result := IniF.ReadFloat(SecName + FName, 0);
end;

procedure SearchCustomer(dq: TDataSet; FName: string; CustInfo: TContragentInfo);
begin
  if Customers.FindName(CustInfo.Name) then
    dq[FName] := Customers.KeyValue
  else
    if (CustInfo.Name <> '')
       or (RusMessageDlg('Заказчик ''' + CustInfo.Name + ''' не найден. Создать нового?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      dq[FName] := Customers.AddNew(CustInfo)
    else
      dq[FName] := TContragents.NoNameKey;
end;

// --------------------- Error handling ---------------------
procedure WriteAlert(Msg: string);
begin
  RusMessageDlg('Ошибка при записи в файл: ' + Msg, mtError, [mbOk], 0);
end;

procedure ReadAlert(Msg: string);
begin
  RusMessageDlg('Ошибка при чтении из файла: ' + Msg, mtError, [mbOk], 0);
end;

// --------------------- OrderExchange -----------------------

function TOrderExchange.ExportServiceData(Srv: TPolyProcess): boolean;
var
  i, j, k, Count: integer;
  sf: TField;
  SecName: string;
  dqc: TDataSet;
begin
  dqc := Srv.DataSet;
  if dqc.Active and not dqc.IsEmpty then
  begin
    ExpF.WriteInteger(secServices + Srv.TableName + '\RecordCount', dqc.RecordCount);
    dqc.DisableControls;
    i := 1;
    try
      dqc.First;
      while not dqc.eof do
      try
        SecName := SecServices + Srv.TableName + '\Record' + IntToStr(i) + '\';
        for k := 0 to Pred(dqc.Fields.Count) do
        begin
          sf := dqc.Fields[k];
          if ExportedField(sf) then
            ExportField(sf, dqc, SecName);
        end;
        if not CurOrder.OrderItems.Locate(dqc[F_ItemID]) then
          raise Exception.Create('Не найдена запись в общем списке процессов.');
        Count := WordCount(ProcessItemExportFields, [',']);
        for j := 1 to Count do
        begin
          sf := CurOrder.OrderItems.DataSet.FieldByName(ExtractWord(j, ProcessItemExportFields, [',']));
          ExportField(sf, CurOrder.OrderItems.DataSet, SecName);
        end;
        dqc.Next;
        Inc(i);
        Result := true;
      except on e: Exception do
        begin
          WriteAlert(e.Message);
          Result := false;
          Exit;
        end;
      end;
    finally
      dqc.EnableControls;
    end;
  end else
    Result := true;  // пропуск
end;

procedure TOrderExchange.ExportField(sf: TField; ProcessData: TDataSet; SecName: string);
begin
  if sf is TBooleanField then
    WNotNullB(ExpF, ProcessData, SecName, sf.FieldName)
  else if (sf is TFloatField) or (sf is TBCDField) then
    WNotNullF(ExpF, ProcessData, SecName, sf.FieldName)
  else if (sf is TIntegerField) or (sf is TSmallIntField) then
    WNotNullI(ExpF, ProcessData, SecName, sf.FieldName)
  else if sf is TStringField then
    WNotNullS(ExpF, ProcessData, SecName, sf.FieldName)
  else if sf is TMemoField then
    WNotNullM(ExpF, ProcessData, SecName, sf.FieldName)
  else if sf is TDateTimeField then
    WNotNullD(ExpF, ProcessData, SecName, sf.FieldName)
  else
    AlertUnknownField(sf);
end;

procedure TOrderExchange.AlertUnknownField(sf: TField);
begin
  raise Exception.Create('Неизвестный тип поля ' + VarToStr(sf.DataType)
      + ' (' + sf.DataSet.Name + '.' + sf.FieldName + ')');
end;

function TOrderExchange.ImportServiceData(Srv: TPolyProcess): boolean;
var
  i, j, k, Recs, Count: integer;
  sf: TField;
  SecName: string;
  dqc: TDataSet;
begin
  dqc := Srv.DataSet;
  if not dqc.Active then
    CurOrder.Processes.OpenProcess(Srv);

  CurOrder.DisableCalcFields := true;
  dqc.DisableControls;
  i := 1;
  try
   // Если нет записей о процессе или закончились,
   // или превышено максимальное число, уходим
    Recs := ExpF.ReadInteger(secServices + Srv.TableName + '\RecordCount', 0);
    TLogger.getInstance.Info('Чтение ' + secServices + Srv.TableName);
    while i <= Recs do
    try
      SecName := SecServices + Srv.TableName + '\Record' + IntToStr(i) + '\';
      dqc.Append;
      for k := 0 to Pred(dqc.Fields.Count) do
      begin
        sf := dqc.Fields[k];
        if ImportedField(sf) then
          ImportField(sf, dqc, SecName);
      end;
      dqc.CheckBrowseMode;

      if not CurOrder.OrderItems.Locate(dqc[F_ItemID]) then
        raise Exception.Create('Не найдена запись в общем списке процессов.');
      Count := WordCount(ProcessItemImportFields, [',']);
      for j := 1 to Count do
      begin
        sf := CurOrder.OrderItems.DataSet.FieldByName(ExtractWord(j, ProcessItemImportFields, [',']));
        TLogger.getInstance.Info('Чтение поля ' + sf.FieldName);
        ImportField(sf, CurOrder.OrderItems.DataSet, SecName);
      end;

      dqc.CheckBrowseMode;
      Inc(i);
    except on e: Exception do
      begin
        ReadAlert(e.Message);
        Result := false;
        Exit;
      end;
    end;
    Result := true;
  finally
    CurOrder.DisableCalcFields := false;
    FreshQuery(dqc);
    dqc.EnableControls;
  end;
end;

function TOrderExchange.ImportField(sf: TField; dqc: TDataSet; SecName: string): boolean;
begin
  if sf is TBooleanField then
    RNotNullB(ExpF, dqc, SecName, sf.FieldName)
  else if (sf is TFloatField) or (sf is TBCDField) then
    RNotNullF(ExpF, dqc, SecName, sf.FieldName)
  else if sf is TIntegerField then
    RNotNullI(ExpF, dqc, SecName, sf.FieldName)
  else if sf is TStringField then
    RNotNullS(ExpF, dqc, SecName, sf.FieldName)
  else if sf is TMemoField then
    RNotNullM(ExpF, dqc, SecName, sf.FieldName)
  else if sf is TDateTimeField then
    RNotNullD(ExpF, dqc, SecName, sf.FieldName)
  else
    AlertUnknownField(sf);
end;

function TOrderExchange.EachWriteService(Srv: TPolyProcess): boolean;
begin
  if (Srv.DataSet <> nil) then
  begin
    Result := ExportServiceData(Srv);
  end
  else
    Result := true;  // просто пропускаем
end;

function TOrderExchange.EachReadService(Srv: TPolyProcess): boolean;
begin
  if (Srv.DataSet <> nil) then
    Result := ImportServiceData(Srv)
  else
    Result := true;  // просто пропускаем
end;
(*
function ReadHugeString(const Section, Ident, Default: string): string;
var
  Buffer: PChar;
begin
  GetMem(Buffer, 1 shl 16);
  try
    SetString(Result, Buffer, GetPrivateProfileString(PChar(Section),
      PChar(Ident), PChar(Default), Buffer, 1 shl 16, PChar(ExpF.FileName)));
  finally
    FreeMem(Buffer);
  end;
end;

function ReadScript(SrvName, ScrName: string): boolean;
var
  Lines: TStringList;
  Res: boolean;
begin
  Result := true;   // всегда возвращает true
  DbgF.WriteString('ReadScript', SrvName + '_' + ScrName + '_' + 'Enter', '1');
  Lines := TStringList.Create;
  try
    Lines.Text := ReplaceStr(ReadHugeString(SrvName, ScrName, ''), #3, #13#10);
    if not (sdm.cdServices.State in [dsEdit, dsInsert]) then sdm.cdServices.Edit;
    DbgF.WriteString('ReadScript', SrvName + '_' + ScrName + '_' + 'BeforeBlob', '1');
    Res := WriteStringListToBlob(Lines, sdm.cdServices.FieldByName(ScrName) as TBlobField);
    DbgF.WriteString('ReadScript', SrvName + '_' + ScrName + '_' + 'AfterBlob', IntToStr(Ord(Res)));
  finally
    FreeAndNil(Lines);
  end;
  DbgF.WriteString('ReadScript', SrvName + '_' + ScrName + '_' + 'Exit', '1');
end;

function TImpExpForm.EachReadScripts(Srv: TPolyProcess): boolean;
var i: integer;
begin
  DbgF.WriteString('EachReadScripts', 'Enter', '1');
  Result := true;
  if sdm.cdServices.Locate('SrvID', Srv.SrvID, []) {and not Srv.OnlyWorkOrder} then begin
    DbgF.WriteString('EachReadScripts', Srv.Name + 'Located', '1');
    if Srv.Scripts.Count > 0 then
      for i := 0 to Pred(Srv.Scripts.Count) do begin
        DbgF.WriteString('EachReadScripts', Srv.Name + 'ReadingScripts' + IntToStr(i), '1');
        ReadScript(Srv.Name, Srv.Scripts[i]);
      end;
  end;
  DbgF.WriteString('EachReadScripts', 'Exit', '1');
end;

function WriteScript(SrvName, ScrName: string): boolean;
var
  Lines: TStringList;
begin
  Result := true;   // всегда возвращает true
  Lines := TStringList.Create;
  try
    ReadStringListFromBlob(Lines, sdm.cdServices.FieldByName(ScrName) as TBlobField);
    ExpF.WriteString(SrvName, ScrName, ReplaceStr(Lines.Text, #13#10, #3));
 finally
    FreeAndNil(Lines);
  end;
end;

function TImpExpForm.EachWriteScripts(Srv: TPolyProcess): boolean;
var i: integer;
begin
  Result := true;
  if sdm.cdServices.Locate('SrvID', Srv.SrvID, []) {and not Srv.OnlyWorkOrder} then
  begin
    if Srv.Scripts.Count > 0 then
      for i := 0 to Pred(Srv.Scripts.Count) do
        WriteScript(Srv.Name, Srv.Scripts[i]);
  end;
end;
*)
//procedure TOrderExchange.CannotCreateAlert;
//begin
//  RusMessageDlg('Не могу создать файл', mtError, [mbOk], 0);
//end;
//
// -----------------------------------------------------------------------------

function TOrderExchange.ExportOrder(Order: TOrder; FName: string): boolean;
var
  dq: TDataSet;

  procedure WriteCustInfo(secName: string; CustInfo: TContragentInfo);
  begin
    ExpF.WriteString(secName + 'Name', CustInfo.Name);
    ExpF.WriteString(secName + 'FullName', CustInfo.FullName);
    ExpF.WriteString(secName + 'Address', CustInfo.Address);
    ExpF.WriteString(secName + 'Fax', CustInfo.Fax);
    ExpF.WriteString(secName + 'Phone', CustInfo.Phone);
    //ExpF.WriteString(secName + 'Gertva', CustInfo.Gertva);
    ExpF.WriteString(secName + 'SourceOther', CustInfo.SourceOther);
    ExpF.WriteInteger(secName + 'SourceCode', CustInfo.SourceCode);
    //ExpF.WriteInteger(secName + 'SourceCode', CustInfo.StatusCode);      // а вдруг нет значения в справочнике?
    //ExpF.WriteInteger(secName + 'ActivityCode', CustInfo.ActivityCode);  // а вдруг нет значения в справочнике?
    ExpF.WriteString(secName + 'Email', CustInfo.Email);

    //ExpF.WriteString(secName + 'Director', CustInfo.Director);
    ExpF.WriteString(secName + 'IndCode', CustInfo.IndCode);
    ExpF.WriteString(secName + 'NDSCode', CustInfo.NDSCode);
    ExpF.WriteString(secName + 'Bank', CustInfo.Bank);

    WriteDate(ExpF, secName, 'FirmBirthday', CustInfo.FirmBirthday);
    //WriteDate(ExpF, secName, 'DirectorBirthday', CustInfo.DirectorBirthday);
    //WriteDate(ExpF, secName, 'GertvaBirthday', CustInfo.GertvaBirthday);
    WriteDate(ExpF, secName, 'CreationDate', CustInfo.CreationDate);
  end;

  procedure WriteCommon;
  begin
      ExpF.WriteString(secCommon + 'Chifer', dq['ID']);
      ExpF.WriteInteger(secCommon + 'BriefChifer', Ord(EntSettings.BriefOrderID));
      ExpF.WriteInteger(secCommon + 'IsWork', Ord(Order is TWorkOrder));
      ExpF.WriteInteger(secCommon + 'KindID', dq['KindID']);
      if not VarIsNull(dq['Customer']) and (dq['Customer'] <> TContragents.NoNameKey) then
        WriteCustInfo(secCommon + 'CustomerInfo\', Order.GetCustomerInfo);
      //ExpF.WriteString(secCommon + 'Customer', NvlString(dq['CustomerName']));
      WNotNullD(ExpF, dq, secCommon, 'CreationDate');
      WNotNullD(ExpF, dq, secCommon, 'ModifyDate');
      ExpF.WriteString(secCommon + 'CreatorName', dq['CreatorName']);
      ExpF.WriteString(secCommon + 'ModifierName', dq['ModifierName']);
      WNotNullI(ExpF, dq, secCommon, 'RowColor');
      ExpF.WriteString(secCommon + 'Comment', NvlString(dq['Comment']) + CommentAdd);
      ExpF.WriteString(secCommon + 'Comment2', NvlString(dq['Comment2']));
      WNotNullI(ExpF, dq, secCommon, 'Tirazz');
      WNotNullF(ExpF, dq, secCommon, 'TotalCost');  // для preview

      if WriteFin then
      begin
        if Order is TWorkOrder then
          WNotNullF(ExpF, dq, secFinance, 'CourseNBU');
        if not VarIsNull(dq['ClientTotal']) then ExpF.WriteFloat(secFinance + 'ClientTotal', dq['ClientTotal']);
      end;

      if Order is TWorkOrder then
      begin
        WNotNullD(ExpF, dq, secCommon, 'FinishDate');
        WNotNullI(ExpF, dq, secCommon, TOrder.F_OrderState);
        WNotNullI(ExpF, dq, secCommon, TOrder.F_PayState);
        WNotNullD(ExpF, dq, secCommon, 'FactFinishDate');
        WNotNullD(ExpF, dq, secCommon, 'CloseDate');
      end;
  end;

  procedure WriteServices;
  begin
    Order.Processes.ForEachKindProcess(EachWriteService);
  end;

begin
  CurOrder := Order;
  dq := Order.DataSet;
  WriteFin := true;
  CommentAdd := '';
  try if FileExists(FName) then DeleteFile(FName); except end;
  CreateWriteStorage(FName);
  try
    WriteCommon;
    WriteServices;
    Result := true;
    {if WriteFin then
      Result := ExportDataSet(dm.cdOrderPay) and
                ExportDataSet(dm.cdOrderPayDet);}
  finally
    ExpF.Flush;
    FreeStorage;
  end;
end;

{procedure CannotOpenAlert;
begin
  RusMessageDlg('Не могу открыть файл ''' + FName + '''', mtError, [mbOk], 0);
end;}

function TOrderExchange.ReadOrderInfo(FName: string; var OrderInfo: TOrderInfo): boolean;
var
  sID: string;
begin
  Result := false;
  CreateReadStorage(FName);
  if ExpF <> nil then
  try
    OrderInfo.IsWork := ExpF.ReadInteger(secCommon + 'IsWork') = 1;
    sID := ExpF.ReadString(secCommon + 'Chifer', '');
    if sID = '' then
      raise Exception.Create('Не указан номер заказа');
    OrderInfo.CustomerName := ExpF.ReadString(secCommon + 'CustomerInfo\Name', '');
    {FullID := ExpF.ReadInteger(secCommon + 'FullChifer', 0) = 1;
    if FullID then begin
      dq['ID_date'] := StrToInt(Copy(sID, 1, 3));
      dq['ID_kind'] := StrToInt(Copy(sID, 5, 1));
      dq['ID_char'] := StrToInt(Copy(sID, 6, 1));
      dq['ID_color'] := StrToInt(Copy(sID, 7, 1));
    end;}
    if Length(sID) > 5 then
      OrderInfo.ID_Number := StrToInt(Copy(sID, 9, 5))
    else
      OrderInfo.ID_Number := StrToInt(sID);
    //SearchCustomer(dq, 'Customer', dq['CustomerName']);
    OrderInfo.CreationDate := ReadDate(ExpF, secCommon, 'CreationDate');
    OrderInfo.ModifyDate := ReadDate(ExpF, secCommon, 'ModifyDate');
    OrderInfo.CreatorName := ReadString(ExpF, secCommon, 'CreatorName');
    OrderInfo.ModifierName := ReadString(ExpF, secCommon, 'ModifierName');
    //dq['ModifyDate'] := dq['CreationDate'];
    //RNotNullI(ExpF, dq, secCommon, 'RowColor');
    OrderInfo.Comment := ReadString(ExpF, secCommon, 'Comment');
    OrderInfo.TotalCost := ReadFloat(ExpF, secCommon, 'TotalCost');
    OrderInfo.KindID := ExpF.ReadInteger(secCommon + 'KindID', 0);
    if OrderInfo.KindID = 0 then
      raise Exception.Create('Не указан вид заказа, файл ' + FName);
    //RNotNullS(ExpF, dq, secCommon, 'Comment2');
    //RNotNullI(ExpF, dq, secCommon, 'Tirazz');
    Result := true;
  finally
    FreeStorage;
  end;
end;

function TOrderExchange.ImportOrder(Order: TOrder; FName: string): boolean;
var
  dq: TDataSet;

  procedure ReadCustInfo(secName: string; var CustInfo: TContragentInfo);
  begin
    CustInfo.Name := ExpF.ReadString(secName + 'Name', CustInfo.Name);
    CustInfo.FullName := ExpF.ReadString(secName + 'FullName', CustInfo.FullName);
    CustInfo.Address := ExpF.ReadString(secName + 'Address', CustInfo.Address);
    CustInfo.Fax := ExpF.ReadString(secName + 'Fax', CustInfo.Fax);
    CustInfo.Phone := ExpF.ReadString(secName + 'Phone', CustInfo.Phone);
    //CustInfo.Gertva := ExpF.ReadString(secName + 'Gertva', CustInfo.Gertva);
    CustInfo.SourceOther := ExpF.ReadString(secName + 'SourceOther', CustInfo.SourceOther);
    CustInfo.SourceCode := ExpF.ReadInteger(secName + 'SourceCode', CustInfo.SourceCode);
    CustInfo.Email := ExpF.ReadString(secName + 'Email', CustInfo.Email);

    //CustInfo.Director := ExpF.ReadString(secName + 'Director', CustInfo.Director);
    CustInfo.IndCode := ExpF.ReadString(secName + 'IndCode', CustInfo.IndCode);
    CustInfo.NDSCode := ExpF.ReadString(secName + 'NDSCode', CustInfo.NDSCode);
    CustInfo.Bank := ExpF.ReadString(secName + 'Bank', CustInfo.Bank);

    CustInfo.FirmBirthday := ReadDate(ExpF, secName, 'FirmBirthday');
    //CustInfo.DirectorBirthday := ReadDate(ExpF, secName, 'DirectorBirthday');
    //CustInfo.GertvaBirthday := ReadDate(ExpF, secName, 'GertvaBirthday');
    CustInfo.CreationDate := ReadDate(ExpF, secName, 'CreationDate');
  end;

  procedure ReadCommon;
  var
    sID: string;
    FullID: boolean;
    CustInfo: TContragentInfo;
  begin
      CurOrder.DisableCalcFields := true;
      try
        if not (dq.State in [dsInsert, dsEdit]) then dq.Edit;
        sID := ExpF.ReadString(secCommon + 'Chifer', '');
        if sID = '' then
          raise Exception.Create('Не указан номер заказа');

        FullID := ExpF.ReadInteger(secCommon + 'BriefChifer', 0) = 0;
        if FullID then begin
          dq['ID_date'] := StrToInt(Copy(sID, 1, 3));
          dq['ID_kind'] := StrToInt(Copy(sID, 5, 1));
          dq['ID_char'] := StrToInt(Copy(sID, 6, 1));
          dq['ID_color'] := StrToInt(Copy(sID, 7, 1));
        end;
  //      dq['ID_Number'] := StrToInt(Copy(sID, 9, 5));
        //dq['CustomerName'] := ExpF.ReadString(secCommon + 'Customer', '');
        ReadCustInfo(secCommon + 'CustomerInfo\', CustInfo);
        SearchCustomer(dq, 'Customer', CustInfo);

        RNotNullD(ExpF, dq, secCommon, 'CreationDate');
        RNotNullD(ExpF, dq, secCommon, 'ModifyDate');
        //dq['ModifyDate'] := dq['CreationDate'];
        RNotNullI(ExpF, dq, secCommon, 'RowColor');
        RNotNullS(ExpF, dq, secCommon, 'Comment');
        RNotNullS(ExpF, dq, secCommon, 'Comment2');
        RNotNullS(ExpF, dq, secCommon, 'CreatorName');
        RNotNullS(ExpF, dq, secCommon, 'ModifierName');
        RNotNullI(ExpF, dq, secCommon, 'Tirazz');
        RNotNullI(ExpF, dq, secCommon, 'Kind');

        if Order is TWorkOrder then begin
          RNotNullF(ExpF, dq, secFinance, 'CourseNBU');
          RNotNullD(ExpF, dq, secCommon, 'FinishDate');
          RNotNullI(ExpF, dq, secCommon, TOrder.F_OrderState);
          RNotNullI(ExpF, dq, secCommon, TOrder.F_PayState);
          RNotNullD(ExpF, dq, secCommon, 'FactFinishDate');
          RNotNullD(ExpF, dq, secCommon, 'CloseDate');
        end;

        dq.CheckBrowseMode;
      finally
        CurOrder.DisableCalcFields := false;
      end;
  end;

  procedure ReadServices;
  begin
    Order.Processes.BeforeImportServices;
    CurOrder := Order;
    Order.Processes.ForEachKindProcess(EachReadService);
    Order.Processes.AfterImportServices;
  end;

begin
  CurOrder := Order;
  dq := Order.DataSet;
  CreateReadStorage(FName);
  if ExpF <> nil then
  try
    ReadCommon;
    ReadServices;
    Result := true;
  finally
    FreeStorage;
  end;
end;

procedure CheckConvertImportFile(iniName: string);
var
  Lines: TStringList;
  NewFileName, OldFileName: string;
begin
  if FileExists(iniName) then
  begin
    Lines := TStringList.Create;
    try
      Lines.LoadFromFile(iniName);
      if Lines.Count > 3 then
      begin
        if (Lines[2] = '  <Order>')
           and (Lines[Lines.Count - 2] = '  </Order>') then
        begin
          Lines.Delete(Lines.Count - 2);
          Lines.Delete(2);
          NewFileName := ChangeFileExt(iniName, '.new');
          Lines.SaveToFile(NewFileName);
          OldFileName := ChangeFileExt(iniName, '.old');
          //if FileExists(OldFileName) then
          DeleteFile(OldFileName);
          RenameFile(iniName, OldFileName);
          RenameFile(NewFileName, iniName);
        end;
      end;
    finally
      Lines.Free;
    end;
  end;
end;

procedure TOrderExchange.CreateReadStorage(FName: string);
begin
  CheckConvertImportFile(FName);
  try
    ExpF := TStorageClass.Create(nil);
    ExpF.ReadOnly := true;
    ExpF.FileName := FName;
    ExpF.Location := flCustom;
    ExpF.RootNodeName := RootNode;
    ExpF.StorageOptions.FloatAsString := true;
    //ExpF.AutoFlush := true;
    //ExpF.AutoReload := true;
    ExpF.Reload;
  except
    if ExpF <> nil then FreeAndNil(ExpF);
    raise;
  end;
end;

procedure TOrderExchange.CreateWriteStorage(FName: string);
begin
  try
    ExpF := TStorageClass.Create(nil);
    ExpF.FileName := FName;
    ExpF.Location := flCustom;
    ExpF.RootNodeName := RootNode;
    //ExpF.AutoFlush := true;
    //ExpF.AutoReload := true;
    ExpF.Reload;
  except
    if ExpF <> nil then FreeAndNil(ExpF);
    raise;
  end;
end;

procedure TOrderExchange.FreeStorage;
begin
  if ExpF <> nil then
  begin
    ExpF.FileName := '';  // Для того чтобы не сохранялись изменения
    FreeAndNil(ExpF);
  end;
end;

function TOrderImportParamsProvider.ExecOrderProps(Order: TOrder;
  InsideOrder, ReadOnly: boolean): integer;
begin
  if OrderExchange.ReadOrderInfo(FFileName, FOrderInfo) then
  begin
    Result := mrOk;
    Order.DataSet['KindID'] := FOrderInfo.KindID;
    //Order.DataSet[''];
  end
  else
    Result := mrCancel;
end;

procedure TOrderImportParamsProvider.SetOnAddAttachedFile(Value: TNotifyEvent);
begin
end;

procedure TOrderImportParamsProvider.SetOnRemoveAttachedFile(Value: TNotifyEvent);
begin
end;

procedure TOrderImportParamsProvider.SetOnOpenAttachedFile(Value: TNotifyEvent);
begin
end;

procedure TOrderImportParamsProvider.SetOnGetCostVisible(Value: TBooleanEvent);
begin
end;

procedure TOrderImportParamsProvider.SetOnAddNote(Value: TNotifyEvent);
begin
end;

procedure TOrderImportParamsProvider.SetOnEditNote(Value: TIntNotifyEvent);
begin
end;

procedure TOrderImportParamsProvider.SetOnDeleteNote(Value: TIntNotifyEvent);
begin
end;

procedure TOrderImportParamsProvider.SetOnSelectTemplate(Value: TNotifyEvent);
begin
end;

function TOrderImportParamsProvider.GetOnAddAttachedFile: TNotifyEvent;
begin
  Result := nil;
end;

function TOrderImportParamsProvider.GetOnRemoveAttachedFile: TNotifyEvent;
begin
  Result := nil;
end;

function TOrderImportParamsProvider.GetOnOpenAttachedFile: TNotifyEvent;
begin
  Result := nil;
end;

function TOrderImportParamsProvider.GetOnGetCostVisible: TBooleanEvent;
begin
  Result := nil;
end;

function TOrderImportParamsProvider.GetOnAddNote: TNotifyEvent;
begin
  Result := nil;
end;

function TOrderImportParamsProvider.GetOnEditNote: TIntNotifyEvent;
begin
  Result := nil;
end;

function TOrderImportParamsProvider.GetOnDeleteNote: TIntNotifyEvent;
begin
  Result := nil;
end;

function TOrderImportParamsProvider.GetOnSelectTemplate: TNotifyEvent;
begin
  Result := nil;
end;

initialization
  OrderExchange := TOrderExchange.Create;

finalization
  FreeAndNil(OrderExchange);
end.
