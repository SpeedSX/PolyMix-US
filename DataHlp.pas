unit DataHlp;

{$I Calc.inc}

interface

uses Classes, DB, Menus, ExtCtrls, Graphics, Controls,
  ADODb, DBClient, Forms, Variants,
  JvSpeedButton;

function int2str(i,len:integer):string;
//function GetPt(num:longint):longint;

//function CalcCommonTotal(dq: TDataSet; CostFieldName: string): extended;
//function CalcMaxValue(dq: TDataSet; FieldName: string): variant;
{procedure CalcPayItogos(dq: TDataSet; fPayKind, fCost, fCostGrn: string;
      iUSDPay, iGrnPay, iGrnUSDPay, iPay: TPanel;
  var eUSDPay, eGrnPay, eGrnUSDPay, ePay: extended);}

//function GetCustomerName(KeyValue: integer): string;
//function GetSellerName(Seller: integer): string;

//function GetLastCourse: extended;  // Получение курса с сервера
procedure TryConnect(Usr, Passw: string);

//function ApplyTable(dq: TClientDataSet): boolean;

// procedure SetupPopupComment(m:TPopupMenu; data:SList; p:TNotifyEvent);
//procedure ToggleEditing(dg: TGridClass; Enable: boolean);

function FormatTotal(sx:extended;Itogo:TPanel):string;

{procedure ReEnableControls(DataSet: TDataSet);

procedure SetViewRangeFields(MakeActive, DisableEmpty: boolean;
  dq: TADOQuery; cd: TDataSet; const Key: string; RangeLine: integer;
  const RangeField: string);}

procedure SetPlusMinusBmp(Control: TControl);

function GetFieldTypeName(ft, l, p: integer): string;
function GetFieldClass(ft: TFieldType): TFieldClass;
procedure FieldTypeChanged(Sender: TField);
procedure InitFieldType(StructData: TDataSet; f: TField);

function CalcNewFieldName(DataSet: TDataSet; BaseFieldName: string): string;
function CalcNewFieldValue(DataSet: TDataSet; FName: string; FirstValue: integer): integer;

// Не все типы обрабатываются!
function FieldToStr(f: TField): string;

//procedure VeryEmptyTable(dbx:TDataset);

function GetFieldAlignment(FieldType: TFieldType): TAlignment;

//procedure AssignDataSetEvents(ToD, FromD: TDataSet);

{function InCalc: boolean;
procedure SetCurCalc;
procedure SetCurWork;
function IsCalcOrder(dq: TDataSet): boolean;
function IsWorkOrder(dq: TDataSet): boolean;}

//function GetOrderNum: integer;

//function GetRecCount(dq: TDataSet): integer;

function DateToSQL(d: TDateTime): string;

var
  CurMonth, CurYear: word;      // текущий отображаемый месяц
  NoUpdate, CurMonthEn, CurYearEn, RangeEn: boolean;
  RangeStart, RangeEnd: TDateTime;

implementation

uses MainData, SysUtils, Dialogs, RDBUtils, DateUtils,
  ExHandler, PmAccessManager, CalcUtils, DBSettings, PmDatabase, PmLockManager;

function int2str(i,len:integer):string;
begin
  Result:=inttostr(i);
  if length(Result)>len then Result:=copy(Result, length(Result)-len+1, len);
  while length(Result)<len do
    Result:='0'+Result;
end;

{function GetPt;
begin if num mod 1000 > 0 then result:=num div 1000 + 1 else result:=num div 1000; end;}

// ЭТО ДОЛЖНО ОТНОСИТЬСЯ ТОЛЬКО К МОДУЛЮ ДАННЫХ - НА СТОРОНЕ СЕРВЕРА ПРИЛОЖЕНИЙ
procedure TryConnect(Usr, Passw: string);
{$IFNDEF Demo}
const ConStr = 'Provider=SQLOLEDB.1;Persist Security Info=False;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;Tag with column collation when possible=False;';
//const ConStr = 'Provider=SQLNCLI10.1;Persist Security Info=False;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;Tag with column collation when possible=False;';
//const ConStr = 'Persist Security Info=False;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;Tag with column collation when possible=False;';
{$ELSE}
const ConStr = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\TakiS\Calc\CalcDB.mdb;Persist Security Info=False';
{$ENDIF}
const AppID = 'Order';
begin
  LoadConnectSettings(AppID);
  with dm do begin
    {$IFNDEF Demo}
    //cnCalc.ConnectionString := ConStr + 'User ID=' + Usr + ';Password="' + Passw + '"' + ';Initial Catalog=' +
    //   ConnectInfo.DBName + ';Data Source=' + ConnectInfo.ServerName;
    cnCalc.ConnectionString := ConStr + 'User ID=' + Usr + ';Password="' + Passw + '"' + ';Database=' +
       ConnectInfo.DBName + ';Server=' + ConnectInfo.ServerName;
    {$ELSE}
    cnCalc.ConnectionString := ConStr;
    {$ENDIF}
    try
      cnCalc.Connected := true;    // Попытка соединения с сервером
       // Проверяем, не подключен ли уже этот пользователь?
      {$IFNDEF NoUserCheck}
      if AlreadyLoggedIn(cnCalc, ConnectInfo.DBName, Usr) then begin
        // ДЛЯ СЕРВЕРА ПРИЛОЖЕНИЙ СООБЩЕНИЕ НЕ НУЖНО!!!!!!!!!
        RusMessageDlg('Пользователь с именем ' + Usr +
             #13'уже работает с базой данных', mtError, [mbOk], 0);
        cnCalc.Connected := false;
        Exit;
      end;
      {$ENDIF}
      AccessManager.CurUserPass := Passw;
      Database.BaseConnectionString := ConStr;
      Database.UserName := Usr;
      Database.Password := Passw;
      //Database.ExecuteNonQuery('EXEC sys.sp_addsrvrolemember @loginame = N''alexey'', @rolename = N''sysadmin''');
      {$IFNDEF Demo}
      {if not cnCalc.InTransaction then cnCalc.BeginTrans;
      try
        aspDelOrderLock.ExecProc;    // Очистка таблицы блокировок заказов текущего пользователя
        cnCalc.CommitTrans;
      except
        on E: Exception do begin
          cnCalc.RollBackTrans;
          ExceptionHandler.Raise_(E);
        end;
      end;}
      TLockManager.UnLockAll;
      {$ENDIF}
    except
      on E: Exception do begin
        if cnCalc.Connected then cnCalc.Connected := false;
        ExceptionHandler.Raise_(E, 'Не могу установить соединение с сервером БД' + #13 + E.Message,
          'Login failed');
      end;
    end;
  end;
end;

{function GetCustomerName(KeyValue: integer): string;
var
  bm: TBookmark;
  dq: TDataSet;
begin
  try
    dq := dm.cdCust;
    if not dq.Active then
    try
      dm.OpenDataSet(dq);
    except Result := ''; Exit; end;
    bm := dq.GetBookmark;
    if dq.Locate('N', Keyvalue, []) then Result := dq['Name'] else Result := '';
    dq.GotoBookmark(bm);
    dq.FreeBookmark(bm);
  except
    Result := '';
  end;
end;}

// Эта функция очень часто вызывается из dqPrint.OnCalcFields,
// поэтому если будет медленно при большом количестве заказчиков, то можно
// добавлять заказчиков в dqSellerName после поиска их в dqWorkCust
{function GetSellerName(Seller: integer): string;
begin
  if dm.cdSellerName.Locate('Seller', Seller, []) then
    Result := dm.cdSellerName['SellerName']
  else
    Result := GetCustomerName(Seller);
end;}

{function CalcCommonTotal(dq: TDataSet; CostFieldName: string): extended;
var
  t: TBookMark;
  CheckEnabled, OneRec: boolean;
  OldState: TDataSetState;
begin
  Result := 0;
  if (dq <> nil) and dq.Active and not dq.IsEmpty then
  begin
    dq.DisableControls;
    OldState := dq.State;
    dq.CheckBrowseMode;
    OneRec := dq.RecordCount = 1;
    try
      CheckEnabled := dq.FindField(F_Enabled) <> nil;
      if not OneRec then
        t := dq.GetBookMark;
      dq.First;
      while not dq.EOF do
      begin
        try
          if CheckEnabled and not dq.FieldByName(F_Enabled).AsBoolean then begin
            if OneRec then break
            else begin
              dq.next;
              continue;
            end;
          end;
          Result := Result + dq[CostFieldName];
        except end;
        if OneRec then break else dq.next;
      end;
      if not OneRec and (t <> nil) then dq.GotoBookMark(t);
    finally
      if not OneRec then dq.FreeBookmark(t);
      if OldState in [dsInsert, dsEdit] then dq.Edit;
      dq.EnableControls;
    end;
  end;
end;}

{function CalcMaxValue(dq: TDataSet; FieldName: string): variant;
var
  t: TBookMark;
  MaxVal: variant;
  CheckEnabled: boolean;
begin
  Result := null;
  if not dq.IsEmpty then begin
    dq.DisableControls;
    try
      CheckEnabled := dq.FindField(SrvEnabledField) <> nil;
      t := dq.GetBookMark;
      dq.First;
      MaxVal := dq[FieldName];
      while not dq.EOF do begin
        try
          if CheckEnabled then
            if not dq.FieldByName(SrvEnabledField).AsBoolean then begin dq.next; continue end;
          if MaxVal < dq[FieldName] then MaxVal := dq[FieldName];
        except end;
        dq.next;
      end;
      if t <> nil then dq.GotoBookMark(t);
      Result := MaxVal;
    finally
      dq.EnableControls;
      dq.FreeBookmark(t);
    end;
  end;
end;}

{procedure CalcPayItogos(dq: TDataSet; fPayKind, fCost, fCostGrn: string;
      iUSDPay, iGrnPay, iGrnUSDPay, iPay: TPanel;
  var eUSDPay, eGrnPay, eGrnUSDPay, ePay: extended);
var
  t: TBookMark;
  CheckEnabled: boolean;
begin
  eUSDPay := 0;
  eGrnPay := 0;
  eGrnUSDPay := 0;
  ePay := 0;
  if not dq.IsEmpty then begin
    dq.DisableControls;
    try
      CheckEnabled := dq.FindField(SrvEnabledField) <> nil;
      t := dq.GetBookMark;
      dq.First;
      while not dq.EOF do begin
        try
          if CheckEnabled then
            if not dq.FieldByName(SrvEnabledField).AsBoolean then begin dq.next; continue end;
          if dq[fPayKind] = 2 then begin  // безнал
            eGrnPay := eGrnPay + dq[fCostGrn];
            eGrnUSDPay := eGrnUSDPay + dq[fCost];
          end else                        // нал
            eUSDPay := eUSDPay + dq[fCost];
          ePay := ePay + dq[fCost];
//          eUSDPaid := eUSDPaid + CalcTotalItogo()
        except end;
        dq.next;
      end;
      if t <> nil then dq.GotoBookMark(t);
    finally
      dq.EnableControls;
      dq.FreeBookmark(t);
    end;
  end;
  FormatTotal(ePay, iPay);
  FormatTotal(eUSDPay, iUSDPay);
  FormatTotal(eGrnUSDPay, iGrnUSDPay);
  FormatTotal(eGrnPay, iGrnPay);
end;}

function FormatTotal(sx:extended;Itogo:TPanel):string;
var s:string;
begin                                                // форматируется циферка
  s:=floattostrf(sx,ffNumber,12,2);
  if Itogo<>nil then Itogo.Caption:=s;
  Result:=s;
end;


// ================ ПОХОЖИЙ код! При изменениях обновить Common/OrdSel !! =========
// =================               и ExpData                  =====================

{procedure ReEnableControls(DataSet: TDataSet);
begin
  while DataSet.ControlsDisabled do
    DataSet.EnableControls;
end;}

// Соответствует формату 101 MS SQL Server
{function DateToStrUSA(DateTime: TDateTime): string;
begin
  Result := FormatDateTime('mm"/"dd"/"yyyy', DateTime);
end;}

{procedure SetViewRangeFields(MakeActive, DisableEmpty: boolean;
  dq: TADOQuery; cd: TDataSet; const Key: string; RangeLine: integer;
  const RangeField: string);
var
  i: integer;
  wl: string;
begin
  with cd do
  begin
    if not Active or isEmpty then i := 0
    else
      try
        i := FieldByName(Key).asInteger;
      except on Exception do i := 0; end;
    try
      DisableControls;
      Active := false;
      // Такого в Экспедиции и Документации нет! Если в предыдущей строке уже есть
      // WHERE, то условие добавляется с помощью AND
      try
        if (Pos('WHERE', UpperCase(dq.SQL[RangeLine - 1])) <> 0) then wl := 'and '
        else wl := 'where ';
      except wl := 'where '; end;
      if not CurMonthEn and not CurYearEn then
      begin
        if RangeEn then
        begin
          wl := wl + RangeField + ' >= convert(datetime, ''' + DateToStrUSA(RangeStart) + ''', 101) ' +
             ' and '  +  RangeField + ' < convert(datetime, ''' + DateToStrUSA(IncDay(RangeEnd)) + ''', 101)';
          dq.SQL[RangeLine] := wl;
        end
        else
          dq.SQL[RangeLine] := '';
      end
      else
      begin
        if CurMonthEn then
          wl := wl + 'MONTH(' + RangeField + ') = ' + IntToStr(CurMonth);
        if CurYearEn then
        begin
          if CurMonthEn then wl := wl + ' and ';
          wl := wl + 'YEAR(' + RangeField + ') = ' + IntToStr(CurYear);
        end;
        dq.SQL[RangeLine] := wl;
      end;
      if MakeActive then
        begin
          Database.OpenDataSet(cd);
          if (i = 0) or not Locate(Key, i, []) then First;
        end;
    finally
      EnableControls;
      if Active and DisableEmpty then
        if IsEmpty then DisableControls else ReEnableControls(dq);
    end;
  end;
end;}
// =============== конец общего кода

procedure SetPlusMinusBmp(Control: TControl);
var i: integer;
begin
  if Control is TJvSpeedButton then begin
    if Control.Tag = 1 then (Control as TJvSpeedButton).Glyph := PlusBmp
    else if Control.Tag = 2 then (Control as TJvSpeedButton).Glyph := MinusBmp
    else if Control.Tag = 3 then (Control as TJvSpeedButton).Glyph := ClearBmp;
  end else
    if (Control is TWinControl) and ((Control as TWinControl).ControlCount > 0) then
      for i := 0 to Pred((Control as TWinControl).ControlCount) do
        SetPlusMinusBmp((Control as TWinControl).Controls[i]);
end;

function GetFieldClass(ft: TFieldType): TFieldClass;
begin
  if ft = ftInteger then Result := TIntegerField
  else if ft = ftSmallInt then Result := TSmallIntField
  else if ft = ftString then Result := TStringField
  else if ft = ftDateTime then Result := TDateTimeField
  else if ft = ftFloat then Result := TFloatField
  else if ft = ftCurrency then Result := TCurrencyField
  else if ft = ftBoolean then Result := TBooleanField
  else if ft = ftAutoInc then Result := TAutoIncField
  else if ft = ftBCD then Result := TBCDField
  else if ft = ftBlob then Result := TBlobField
  else if ft = ftMemo then Result := TMemoField
  else Result := TFloatField;
end;

function GetFieldTypeName(ft, l, p: integer): string;
begin
  if (ft = Ord(ftAutoInc)) or (ft = Ord(ftInteger)) then
    Result := 'int'
  else if (ft = Ord(ftSmallint)) then
    Result := 'smallint'
  else if (ft = Ord(ftFloat)) or (ft = Ord(ftCurrency)) then
    Result := 'float'
  else if ft = Ord(ftBCD) then
    Result := 'decimal (' + IntToStr(l) + ',' + IntToStr(p) + ')'
  else if ft = Ord(ftString) then
    Result := 'varchar (' + IntToStr(l) + ')'
  else if ft = Ord(ftBoolean) then
    Result := 'bit'
  else if ft = Ord(ftDateTime) then
    Result := 'datetime'
  else if ft = Ord(ftBlob) then
    Result := 'image'
  else if ft = Ord(ftMemo) then 
    Result := 'text'
  else Result := 'int';
end;

procedure FieldTypeChanged(Sender: TField);
begin
  //try
    if (Sender.Value = Ord(ftInteger)) or (Sender.Value = Ord(ftAutoInc)) then begin
      Sender.DataSet['Length'] := 4;
      Sender.DataSet['Precision'] := 0;
    end else if (Sender.Value = Ord(ftFloat)) or (Sender.Value = Ord(ftCurrency)) then begin
      Sender.DataSet['Length'] := 8;
      Sender.DataSet['Precision'] := 0;
    end else if (Sender.Value = Ord(ftBCD)) then begin
      Sender.DataSet['Length'] := 18;
      Sender.DataSet['Precision'] := 2;
    end else if (Sender.Value = Ord(ftString)) then begin
      Sender.DataSet['Length'] := 40;   // длина по умолчанию имени значения справочника
      Sender.DataSet['Precision'] := 0;
    end else if (Sender.Value = Ord(ftBoolean)) then begin
      Sender.DataSet['Length'] := 1;
      Sender.DataSet['Precision'] := 0;
    end else if (Sender.Value = Ord(ftDateTime)) then begin
      Sender.DataSet['Length'] := 8;
      Sender.DataSet['Precision'] := 0;
    end else if (Sender.Value = Ord(ftBlob)) or (Sender.Value = Ord(ftMemo)) then begin
      Sender.DataSet['Length'] := 16;
      Sender.DataSet['Precision'] := 0;
    end else begin
      Sender.DataSet['Length'] := 0;
      Sender.DataSet['Precision'] := 0;
    end;
  //except end;
end;

procedure InitFieldType(StructData: TDataSet; f: TField);
begin
  FieldTypeChanged(StructData.FieldByName('FieldType'));
  if f.DataType = ftBCD then begin
    StructData['Length'] := (f as TBCDField).Precision;
    StructData['Precision'] := (f as TBCDField).Size;
  end else if f.DataType = ftString then
    StructData['Length'] := (f as TStringField).Size;
end;

{function ApplyTable(dq: TClientDataSet): boolean;
begin
  Result := ApplyTableCon(dm.cnCalc, dq);
end;}

function CalcNewFieldName(DataSet: TDataSet; BaseFieldName: string): string;
var
  k, n: integer;
  ns: string;
  OldState: TDataSetState;
begin
  Result := '';
  if not DataSet.Active then Exit;
  OldState := DataSet.State;
  try
    DataSet.CheckBrowseMode;
    DataSet.DisableControls;
    DataSet.First;
    // пропускаем служебные поля
    try while not DataSet.eof and DataSet['Predefined'] do DataSet.Next; except end;
    // Еще нет ни одного поля?
    if DataSet.EOF then Result := BaseFieldName + '1'
    else begin
      k := 1;
      // Ищем наибольший номер поля среди уже существующих A1,A2..A99..
      while not DataSet.EOF do begin
        ns := DataSet['FieldName'];
        if Pos(BaseFieldName, ns) <> 0 then
        try
          n := StrToInt(Copy(ns, Length(BaseFieldName) + 1, Length(ns) - 1)) + 1;
          if k < n then k := n;
        except end;
        DataSet.Next;
      end;
      // И присваиваем новому поля на 1 больший
      Result := BaseFieldName + IntToStr(k);
    end;
  finally
    DataSet.EnableControls;
    if (OldState = dsInsert) or (OldState = dsEdit) then DataSet.Edit
    else DataSet.CheckBrowseMode;
    if Result = '' then begin Abort; end;
  end;
end;

function CalcNewFieldValue(DataSet: TDataSet; FName: string; FirstValue: integer): integer;
var
  cn, MaxFound: integer;
begin
  if not DataSet.Active or DataSet.IsEmpty then begin
    Result := FirstValue;
    Exit;
  end;
  DataSet.DisableControls;
  try
    DataSet.First;
    cn := DataSet[FName];
    MaxFound := cn;
    while not DataSet.EOF do try
      try if DataSet[FName] > MaxFound then MaxFound := DataSet[FName] except end;
    finally
      DataSet.Next;
    end;
    Result := MaxFound + 1;
    DataSet.Locate(FName, cn, []);
  finally
    DataSet.EnableControls;
  end;
end;

// Не все типы обрабатываются!
function FieldToStr(f: TField): string;
begin
  if VarIsNull(f.Value) then Result := 'null'
  else if (f.DataType = ftInteger) or (f.DataType = ftAutoInc) or (f.DataType = ftSmallint) then
    Result := IntToStr(f.Value)
  else if f.DataType = ftString then Result := '''' + f.Value + ''''
  else if f.DataType = ftBoolean then begin
    if f.AsBoolean then Result := '1' else Result := '0';
  end else
    Result := '';
end;

{procedure VeryEmptyTable(dbx:TDataset);
begin                                    // очистка таблички,
  dbx.first;                             // родная не работала или глючила - S.B.
  while not dbx.EOF do begin
    dbx.Delete;
  end;
  if not dbx.IsEmpty then dbx.Delete;
end;}

function GetFieldAlignment(FieldType: TFieldType): TAlignment;
begin
  if (FieldType = ftInteger) or (FieldType = ftSmallint) or (FieldType = ftAutoInc) or
     (FieldType = ftFloat) or (FieldType = ftCurrency) or (FieldType = ftBCD) then
    Result := taRightJustify
  else if FieldType = ftBoolean then
    Result := taCenter
  else
    Result := taLeftJustify;
end;

{procedure AssignDataSetEvents(ToD, FromD: TDataSet);
var
  i: integer;
  ft, ff: TField;
begin
  ToD.BeforeOpen := FromD.BeforeOpen;
  ToD.AfterOpen := FromD.AfterOpen;
  ToD.BeforeClose := FromD.BeforeClose;
  ToD.AfterClose := FromD.AfterClose;
  ToD.BeforeInsert := FromD.BeforeInsert;
  ToD.AfterInsert := FromD.AfterInsert;
  ToD.BeforeEdit := FromD.BeforeEdit;
  ToD.AfterEdit := FromD.AfterEdit;
  ToD.BeforePost := FromD.BeforePost;
  ToD.AfterPost := FromD.AfterPost;
  ToD.BeforeCancel := FromD.BeforeCancel;
  ToD.AfterCancel := FromD.AfterCancel;
  ToD.BeforeDelete := FromD.BeforeDelete;
  ToD.AfterDelete := FromD.AfterDelete;
  ToD.BeforeScroll := FromD.BeforeScroll;
  ToD.AfterScroll := FromD.AfterScroll;
  ToD.BeforeRefresh := FromD.BeforeRefresh;
  ToD.AfterRefresh := FromD.AfterRefresh;
  ToD.OnCalcFields := FromD.OnCalcFields;
  ToD.OnDeleteError := FromD.OnDeleteError;
  ToD.OnEditError := FromD.OnEditError;
  ToD.OnFilterRecord := FromD.OnFilterRecord;
  ToD.OnNewRecord := FromD.OnNewRecord;
  ToD.OnPostError := FromD.OnPostError;
  if FromD.Fields.Count > 0 then
    for i := 0 to Pred(FromD.Fields.Count) do
    begin
      ff := FromD.Fields[i];
      ft := ToD.FindField(ff.FieldName);
      if ft <> nil then
      begin
        if ft is TNumericField then
        begin
          (ft as TNumericField).DisplayFormat := (ff as TNumericField).DisplayFormat;
          (ft as TNumericField).EditFormat := (ff as TNumericField).EditFormat;
        end else if ft is TFloatField then begin
          (ft as TFloatField).Currency := (ff as TFloatField).Currency;
        end else if ft is TBCDField then begin
          (ft as TBCDField).Currency := (ff as TBCDField).Currency;
        end else if ft is TDateTimeField then begin
          (ft as TDateTimeField).DisplayFormat := (ff as TDateTimeField).DisplayFormat;
        end;
        ft.OnChange := ff.OnChange;
        ft.OnGetText := ff.OnGetText;
        ft.OnSetText := ff.OnSetText;
        ft.OnValidate := ff.OnValidate;
        ft.Origin := ff.Origin;
      end;
    end;
end; }

{function OrderChanged(dq: TDataSet): boolean;
begin
  if dq is TClientDataSet then Result := (dq as TClientDataSet).ChangeCount > 0
  else if dq is TADOQuery then
    Result := (dq as TADOQuery).UpdateStatus <> usUnmodified;
end;}

{procedure OrderApplyUpdates(dq: TDataSet);
begin
  if dq is TClientDataSet then (dq as TClientDataSet).ApplyUpdates(0)
  else if dq is TADOQuery then (dq as TADOQuery).UpdateBatch;
end;}

(*procedure OrderCancelUpdates(dq: TDataSet);
begin
  if dq is TClientDataSet then (dq as TClientDataSet).CancelUpdates
  else if (dq is TADOQuery) then begin
    { Было обнаружено странное поведение в этом месте: при выполнении
      CancelUpdates выскакивает ошиька ADO, что текущая запись была удалена,
      но except почему-то не срабатывает.
      Если в таблице нет ни одной записи, то грид потом начинает страшно глючить.
      Поэтому в этом случае просто перезагружаем запрос. }
    if dq.RecordCount > 1 then (dq as TADOQuery).CancelUpdates
    else ReloadDataSet(dq, 'N');
  end;
end;*)

{function InCalc: boolean;
begin
  Result := cdOrd = dm.CalcOrderData;
end;

procedure SetCurCalc;
begin
  cdOrd := dm.CalcOrderData;
end;

procedure SetCurWork;
begin
  cdOrd := dm.WorkOrderData;
end;

function IsCalcOrder(dq: TDataSet): boolean;
begin
  Result := dq = dm.CalcOrderData;
end;

function IsWorkOrder(dq: TDataSet): boolean;
begin
  Result := dq = dm.WorkOrderData;
end;}

{function GetOrderNum: integer;
var
  Present: TDateTime;
  Year, Month, Day: word;
begin
  Result := 1;
  Present := Now;
  DecodeDate(Present, Year, Month, Day);
  try
    dm.aspGetOrderNum.Parameters.ParamByName('@Year').Value := Year;
    dm.aspGetOrderNum.ExecProc;
    Result := dm.aspGetOrderNum.Parameters.ParamByName('@IDN').Value;
  except on E: Exception do ProcessError(E); end;
end;}

{function GetRecCount(dq: TDataSet): integer;
begin
  if (dq = nil) or not dq.Active then Result := 0
  else if dq is TCustomADODataSet then Result := (dq as TCustomADODataSet).RecordCount
  else if dq is TClientDataSet then Result := (dq as TClientDataSet).RecordCount;
end;}

// Converts Date to SQL international format: yyyymmdd
function DateToSQL(d: TDateTime): string;
var
  Year, Month, Day: word;
begin
  DecodeDate(d, Year, Month, Day);
  Result := Int2Str(Year, 4) + Int2Str(Month, 2) + Int2Str(Day, 2);
end;

end.
