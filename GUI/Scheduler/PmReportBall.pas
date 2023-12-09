unit PmReportBall;

interface

procedure ShowReportBall;

implementation

uses Classes, Variants, DB, PmScriptManager, SysUtils, ExcelRpt, DateUtils, RDBUtils, JvInterpreter_CustomQuery, PmDatabase,
  Dialogs, RDialogs, PmConfigManager, DicObj, BaseRpt, fSelectReportBall, PmShiftEmployees, PlanUtils, CalcSettings,
  PmPlan;

function GetSQL(Department: integer; DateStart, DateEnd: TDateTime): string;
begin
  Result :=
    'select j.JobID, CONVERT(NVARCHAR, j.PlanStartDate, 104) jobDate, CAST(j.PlanStartDate as Time(0)) PlanStart, ' +
    'j.FactStartDate, j.FactFinishDate, CAST(j.FactStartDate as Time(0)) TimeStart, CAST(j.FactFinishDate as time(0)) TimeFinish, ' +
    'CAST((j.FactFinishDate - j.FactStartDate) as time(0)) as TaskTime, j.JobType, c.Name as Customer, opi.ProductOut, j.FactProductOut, ' +
    'de.Name as EquipName, de.A1 as EquipGroupCode, j.EquipCode, e.Name as ExecutorName, sj.Name as JobName, opi.ItemDesc as OrderItemName, opi.ItemID,' +
    'wo.ID_number, wo.Comment, opi.EstimatedDuration ' + #13#10 +
    'from job as j ' +
    'join Dic_Equip de on de.Code = j.EquipCode ' +
    'join Dic_EquipGroup deg on deg.Code = de.A1 ' +
    'left join Dic_Employees e on e.Code = j.Executor ' +
    'left join Dic_SpecialJob sj on sj.code = j.JobType ' +
    'left join OrderProcessItem opi on opi.ItemID = j.ItemID ' +
    'left join  WorkOrder wo on wo.n = opi.OrderID ' +
    'left join CUSTOMER c on c.n = wo.Customer ' + #13#10 +
    'where j.FactStartDate between ''' + FormatDateTime('yyyy-mm-dd', DateStart) + ''' and ''' + FormatDateTime('yyyy-mm-dd', DateEnd) + ''' ' + #13#10 +
    ' and de.A4 = ' + IntToStr(Department) +
    'order by j.FactStartDate, j.Executor';
end;

// вспомогательная
function GetShiftFieldValueDic(de: TDictionary; ShiftNum, FieldNum: integer; var ID: integer): TDateTime;
var
  ds: TDataSet;
  RecNum: integer;
begin
  ds := de.DicItems;
  // номер записи соотв. номеру смены, пропускаем нужное кол-во записей
  RecNum := 1;
  while not ds.eof and (RecNum < ShiftNum) do
  begin
    Inc(RecNum);
    ds.Next;
  end;
  try
    Result := StrToTime(de.CurrentValue[FieldNum]);
    ID := de.CurrentID;
  except
    Result := EncodeTime(0, 0, 0, 0);
  end;
end;

// Возвращает указанное поле для смены для текущей группы оборудования в справочнике
function GetShiftFieldValue(ShiftNum, FieldNum: integer; var ShiftCount, ID: integer;
  EquipCode, EquipGroupCode: integer): TDateTime;
var
  ds: TDataSet;
  de: TDictionary;
begin
  de := TConfigManager.Instance.StandardDics.deEquipTime;
  ds := de.DicItems;
  // Фильтруем справочник по коду оборудования
  ds.Filter := 'A1 = ' + IntToStr(EquipCode);
  ds.Filtered := true;
  try
    ShiftCount := ds.RecordCount;
    if ShiftCount > 0 then  // Если что-то есть, то
      Result := GetShiftFieldValueDic(de, ShiftNum, FieldNum, ID)
    else
    begin
      de := TConfigManager.Instance.StandardDics.deEquipGroupTime;
      ds := de.DicItems;
      // Фильтруем справочник по коду группы
      ds.Filter := 'A1 = ' + IntToStr(EquipGroupCode);
      ds.Filtered := true;
      try
        ShiftCount := ds.RecordCount;
        if ShiftCount <> 0 then
          Result := GetShiftFieldValueDic(de, ShiftNum, FieldNum, ID)
        else
          RusMessageDlg('Отсутствует расписание смен для оборудования '
            + TConfigManager.Instance.StandardDics.deEquip.ItemName[EquipCode], mtError, [mbOk], 0);
      finally
        ds.Filtered := false;
      end;
    end;
  finally
    ds.Filtered := false;
  end;
end;

// Возвращает количество смен для данной группы оборудования
function GetShiftCount(EquipCode, EquipGroupCode: integer): integer;
var
  ID: integer;
begin
  GetShiftFieldValue(-1, 2, Result, ID, EquipCode, EquipGroupCode);
end;

// Возвращает начало указанной смены для текущей группы оборудования в справочнике
function GetShiftStartTime(ShiftNum, EquipCode, EquipGroupCode: integer): TDateTime;
var
  ShiftCount, ID: integer;
begin
  Result := GetShiftFieldValue(ShiftNum, 2, ShiftCount, ID, EquipCode, EquipGroupCode);
end;

// Возвращает окончание указанной смены для текущей группы оборудования в справочнике
function GetShiftFinishTime(ShiftNum, EquipCode, EquipGroupCode: integer): TDateTime;
var
  ShiftCount, ID: integer;
begin
  Result := GetShiftFieldValue(ShiftNum, 3, ShiftCount, ID, EquipCode, EquipGroupCode);
end;

procedure SortDayByExecutorName(var Day: Variant; Rows, Cols: integer);
var
  i, j: Integer;
  tempRow: array of Variant;
  isSorted: Boolean;
begin
  // Bubble Sort by ExecutorName
  repeat
    isSorted := True;
    for i := 1 to Rows - 1 do
    begin
      if AnsiCompareText(VarToStr(Day[i, 1]), VarToStr(Day[i + 1, 1])) > 0 then
      begin
        // Swap rows
        SetLength(tempRow, Cols);
        for j := 1 to Cols do
        begin
          tempRow[j - 1] := Day[i, j];
          Day[i, j] := Day[i + 1, j];
          Day[i + 1, j] := tempRow[j - 1];
        end;
        isSorted := False;
      end;
    end;
  until isSorted;
end;

function GetAssistant(EquipCode: integer; DateStart, DateEnd, ShiftStart: TDateTime): integer;
var
  EquipAssistants: TEquipAssistants;
  NewCriteria: TShiftEmployeeCriteria;
begin
  NewCriteria.StartTime := DateStart;
  NewCriteria.FinishTime := DateEnd;
  EquipAssistants := TEquipAssistants.Create(EquipCode);
  try
    EquipAssistants.Criteria := NewCriteria;
    EquipAssistants.Reload;
    Result := NvlInteger(EquipAssistants.GetAssistant(ShiftStart));
  finally
    EquipAssistants.Free;
  end;
end;

procedure ShowReportBall;
var
  Rpt: TBaseReport;
  ds: TDataSource;
  FormResult: TSelectReportBallResult;
  sql, CurExecutorName: string;
  ColOffset, ColCount, r, I, J, ShiftCount, ShiftNum, EquipEmployeeID, EquipAssistantID,
  EquipCode, EquipGroupCode, FactDuration, TotalEstimated, TotalFact, HeaderOffset, RowOffset,
  Estimated, er, es: integer;
  ShiftStart, ShiftEnd, CurDate, CurShiftStart, CurShiftEnd: TDateTime;
  //ShiftEmployees: TShiftEmployees;
  //ShiftAssistants: TShiftAssistants;
  //EquipEmployees: TEquipEmployees;
  dt: TDataSet;
  Day: variant;
  UseFormulas, IsDelay: boolean;
  ExecutorTotalDelay: TStringList;
begin
  // Formulas do not work in OpenOffice
  UseFormulas := not Options.OpenOffice;

  FormResult := ExecSelectReportBallForm;
  if not FormResult.OK then Exit;

  Rpt := ScriptManager.OpenReport(ExtractFileDir(ParamStr(0)) + '\ReportBall.xls');
  if Rpt <> nil then
  begin
    Rpt.WinCaption1 := 'Excel -::- PolyMix';
    Rpt.WinCaption2 := 'Розрахунок баллів';
    Rpt.FontApplied := false;

    InitCustomSQL;
    ExecutorTotalDelay := TStringList.Create;
    try
      ds := CreateQueryEx('ReportBall', [], upWhereKeyOnly, false);

      sql := GetSQL(FormResult.Department, FormResult.DateStart, FormResult.DateEnd);
      SetQuerySQL(ds, sql);

      dt := ds.DataSet;
      dt.Open;

      if dt.RecordCount = 0 then
        Exit;

      // открываем списки сотрудников для смен
      //ShiftEmployees := TShiftEmployees.Create(TConfigManager.Instance.StandardDics.deDepartments.CurrentID);
      //ShiftAssistants := TShiftAssistants.Create(TConfigManager.Instance.StandardDics.deDepartments.CurrentID);
      //EquipEmployees := TEquipEmployees.Create(TConfigManager.Instance.StandardDics.deDepartments.CurrentID);
      //NewCriteria.StartTime := FormResult.DateStart;
      //NewCriteria.FinishTime := FormResult.DateEnd;
      //EquipEmployees.Criteria := NewCriteria;
      //EquipEmployees.Reload;
      //EquipAssistants.Criteria := NewCriteria;

      // This is not actual equipment for each row in dataset, but we assume that timetable is the same for all.
      EquipCode := NvlInteger(dt['EquipCode']);
      EquipGroupCode := NvlInteger(dt['EquipGroupCode']);
      if (EquipCode = 0) or (EquipGroupCode = 0) then
        Exit;

      ShiftCount := GetShiftCount(EquipCode, EquipGroupCode); // кол-во смен в сутках

      ShiftNum := 1;
      ColOffset := 0;
      RowOffset := 3;
      HeaderOffset := 1;
      ColCount := 9;

      CurDate := FormResult.DateStart;
      while CurDate < FormResult.DateEnd do
      begin
        for I := 1 to ShiftCount do
        begin
          ExecutorTotalDelay.Clear;
          ShiftStart := GetShiftStartTime(I, EquipCode, EquipGroupCode);
          CurShiftStart := CurDate;
          ReplaceTime(CurShiftStart, ShiftStart);
          // определяем конец смены
          if I < ShiftCount then
          begin
            ShiftEnd := GetShiftStartTime(I + 1, EquipCode, EquipGroupCode);
            CurShiftEnd := CurDate;
          end
          else
          begin
            ShiftEnd := GetShiftStartTime(1, EquipCode, EquipGroupCode);
            CurShiftEnd := IncDay(CurDate, 1);
          end;
          ReplaceTime(CurShiftEnd, ShiftEnd);

          Rpt.Cells[HeaderOffset,     ColOffset + 1] := VarToStr(dt['FactStartDate']) + ' Зміна ' + IntToStr(ShiftNum);
          Rpt.Cells[HeaderOffset + 1, ColOffset + 1] := 'Оператор';
          Rpt.Cells[HeaderOffset + 1, ColOffset + 2] := 'Назва роботи';
          Rpt.Cells[HeaderOffset + 1, ColOffset + 3] := 'Замовник';
          Rpt.Cells[HeaderOffset + 1, ColOffset + 4] := 'Обладнання';
          Rpt.Cells[HeaderOffset + 1, ColOffset + 5] := 'Оператор/ Помічник';
          Rpt.Cells[HeaderOffset + 1, ColOffset + 6] := 'Норма часу';
          Rpt.Cells[HeaderOffset + 1, ColOffset + 7] := 'Фактичний час';
          Rpt.Cells[HeaderOffset + 1, ColOffset + 8] := 'Коеф. ефективності';
          Rpt.Cells[HeaderOffset + 1, ColOffset + 9] := 'Результат по співробітнику';

          Day := VarArrayCreate([1, 100, 1, ColCount], varVariant);
          r := 0;
          // Now we have start and end
          while (dt['FactStartDate'] < CurShiftEnd) and not dt.eof do
          begin
            // TODO: Роботу без виконавця пропускаємо але її треба буде врахувати в загальних коефіціентах по підрозділу
            if VarIsNull(dt['ExecutorName']) then
            begin
              dt.Next;
              continue;
            end;

            Inc(r);
            Day[r, 1] := dt['ExecutorName'];
            if dt['JobType'] >= JobType_Special then
              Day[r, 2] := dt['JobName']
            else
              Day[r, 2] := dt['OrderItemName'];
            Day[r, 3] := dt['Customer'];
            Day[r, 4] := dt['EquipName'];
            Day[r, 5] := 'Оператор'; //Оператор/помощник

            FactDuration := PlanUtils.RoundMinutesBetween(dt['FactStartDate'], dt['FactFinishDate']);
            Day[r, 7] := FactDuration;

            if NvlInteger(dt['JobType']) >= JobType_Special then
            begin
              Estimated := NvlInteger(TConfigManager.Instance.StandardDics.deSpecialJob.ItemValue[dt['JobType'], 1]);
              if Estimated = 0 then Estimated := 1; // нулевая длительность не прокатит

              IsDelay := NvlBoolean(TConfigManager.Instance.StandardDics.deSpecialJob.ItemValue[dt['JobType'], 8]);
              if IsDelay then
              begin
                // Накопичуємо загальний час простою для виконавця
                ExecutorTotalDelay.Values[dt['ExecutorName']] := IntToStr(StrToIntDef(ExecutorTotalDelay.Values[dt['ExecutorName']], 0) + FactDuration);
              end;
            end else
              Estimated := NvlInteger(dt['EstimatedDuration']);
            Day[r, 6] := Estimated;

            if not UseFormulas then
            begin
              if NvlInteger(FactDuration) > 0 then
                Day[r, 8] := Estimated / FactDuration;
            end;

            EquipAssistantID := GetAssistant(dt['EquipCode'], FormResult.DateStart, FormResult.DateEnd, CurShiftStart);

            if EquipAssistantID > 0 then
            begin
              Inc(r);
              Day[r, 1] := TConfigManager.Instance.StandardDics.deEmployees.ItemName[EquipAssistantID];
              if dt['JobType'] >= JobType_Special then
                Day[r, 2] := dt['JobName']
              else
                Day[r, 2] := dt['OrderItemName'];
              Day[r, 3] := dt['Customer'];
              Day[r, 4] := dt['EquipName'];
              Day[r, 5] := 'Помічник'; //Оператор/помощник

              FactDuration := PlanUtils.RoundMinutesBetween(dt['FactStartDate'], dt['FactFinishDate']);
              Day[r, 7] := FactDuration;
              if NvlInteger(dt['JobType']) >= JobType_Special then
              begin
                Estimated := NvlInteger(TConfigManager.Instance.StandardDics.deSpecialJob.ItemValue[dt['JobType'], 1]);
                if Estimated = 0 then Estimated := 1; // нулевая длительность не прокатит

                IsDelay := NvlBoolean(TConfigManager.Instance.StandardDics.deSpecialJob.ItemValue[dt['JobType'], 8]);
                if IsDelay then
                begin
                  // Накопичуємо загальний час простою для виконавця
                  ExecutorTotalDelay.Values[dt['ExecutorName']] := IntToStr(StrToIntDef(ExecutorTotalDelay.Values[dt['ExecutorName']], 0) + FactDuration);
                end;
              end else
                Estimated := NvlInteger(dt['EstimatedDuration']);
                
              Day[r, 6] := Estimated;

              if not UseFormulas then
              begin
                if NvlInteger(FactDuration) > 0 then
                  Day[r, 8] := Estimated / FactDuration;
              end;
            end;

            dt.Next;
          end;

          SortDayByExecutorName(Day, r, ColCount);

          if r > 0 then
          begin
            Rpt.CreateTable(Day, RowOffset, 1 + ColOffset, false, false);

            if UseFormulas then
            begin
              for J := 0 to r - 1 do
              begin
                Rpt.Formulas[J + RowOffset, ColOffset + 8] := '=RC[-2]/RC[-1]';
              end;
              Rpt.Formulas[J + RowOffset, ColOffset + 9] := '=SUM(RC[-2]:R[' + IntToStr(r) + ']C[-1]) / SUM(RC[-1]:R[' + IntToStr(r) + ']C[-1])';
            end
            else
            begin
              // Розрахунок Коеф. ефективності за день для кожного виконавця
              CurExecutorName := Day[1, 1];
              TotalEstimated := 0;
              TotalFact := 0;
              es := 1;
              for er := 1 to r do
              begin
                if Day[er, 1] <> CurExecutorName then
                begin
                  if (TotalFact > 0) and (er > es + 1) then
                  begin
                    Rpt.Cells[es + RowOffset - 1, ColOffset + 9] := TotalEstimated * 1.0 / TotalFact;
                    // коєф. простоя
                    Rpt.Cells[es + RowOffset, ColOffset + 9] := StrToIntDef(ExecutorTotalDelay.Values[CurExecutorName], 0) * 1.0 / TotalFact;
                  end;
                  es := er;
                  TotalEstimated := 0;
                  TotalFact := 0;
                  CurExecutorName := Day[es, 1];
                end;
                TotalEstimated := TotalEstimated + Day[er, 6];
                TotalFact := TotalFact + Day[er, 7];
              end;
              if (TotalFact > 0) and (er > es + 1) then
              begin
                Rpt.Cells[es + RowOffset - 1, ColOffset + 9] := TotalEstimated * 1.0 / TotalFact;
                // коєф. простоя
                Rpt.Cells[es + RowOffset, ColOffset + 9] := StrToIntDef(ExecutorTotalDelay.Values[CurExecutorName], 0) * 1.0 / TotalFact;
              end;

            end;

          end;

          //ShiftEmployeeID := NvlInteger(ShiftEmployees.GetEmployee(CurShiftStart));
          //EquipEmployeeID := NvlInteger(EquipEmployees.GetEmployee(CurShiftStart));
          Inc(ShiftNum);
          Inc(ColOffset, ColCount);
        end;

        CurDate := IncDay(CurDate);
      end;

      Rpt.AutoFitColumns(1, ColOffset);

      Rpt.Visible := true;
    finally
      ExecutorTotalDelay.Free;
      DoneCustomSQL;
    end;
  end;
end;

function GetStartDic(de: TDictionary): TDateTime;
var
  MinCode: integer;
  ds: TDataSet;
begin
  ds := de.DicItems;
  // находим мин. код - это первая смена
  MinCode := 0;
  while not ds.eof do
  begin
    if (MinCode = 0) or (de.CurrentCode < MinCode) then
      MinCode := de.CurrentCode;
    ds.Next;
  end;
  if MinCode > 0 then
    try
      Result := StrToTime(de.ItemValue[MinCode, 2]);
    except
      Result := EncodeTime(0, 0, 0, 0);
    end
  else
    Result := EncodeTime(0, 0, 0, 0);
end;

// Ищет начало первой смены для текущей группы оборудования в справочнике
function GetFirstShiftStartTime(EquipCode, EquipGroupCode: integer): TDateTime;
var
  ds: TDataSet;
  de: TDictionary;
begin
  de := TConfigManager.Instance.StandardDics.deEquipTime;
  ds := de.DicItems;
  // Фильтруем справочник по коду оборудования
  ds.Filter := 'A1 = ' + IntToStr(EquipCode);
  ds.Filtered := true;
  try
    if ds.RecordCount > 0 then  // Если есть данные, то берем мз этого справочника
      Result := GetStartDic(de)
    else                       // иначе ищем в справочнике смен для групп
    begin
      de := TConfigManager.Instance.StandardDics.deEquipGroupTime;
      ds := de.DicItems;
      // Фильтруем справочник по коду группы
      ds.Filter := 'A1 = ' + IntToStr(EquipGroupCode);
      ds.Filtered := true;
      try
        if ds.RecordCount > 0 then
          Result := GetStartDic(de);
      finally
        ds.Filtered := false;
      end;
    end;
  finally
    ds.Filtered := false;
  end;
end;

end.
