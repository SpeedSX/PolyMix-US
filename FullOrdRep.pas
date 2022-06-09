unit FullOrdRep;

interface

uses BaseRpt;

const
  MaxCols = 200;
  MaxLines = 100;

procedure MakeOrderReport(_Rep: TBaseReport);

implementation

uses JvJCLUtils, DB, SysUtils,

  PmProcess, MainForm, PmEntityController, PmOrderController, PmProcessCfg, PmOrder,
  CalcSettings, PmOrderProcessItems;

var
  CurRow: integer;
  Rep: TBaseReport;

{function SetNewLength(const S: string; Len: integer): string;
begin
  if Length(s) < Len then s := s + StringOfChar(
end;}

function EachServiceRep(Srv: TPolyProcess): boolean;
var
  MaxLen: array[0..MaxCols - 1] of integer;
  Cap, CurCap, FieldName, FieldValue: string;
  DataLine: array[0..MaxLines - 1] of string;
  f, tc, ec: TField;
  StartRow, i, k, cnt, GridNum: integer;
  SrvGrid: TProcessGrid;
  dq: TDataSet;
  dgcol: boolean;
begin
  Result := true;
  // Если в сервисе не установлен признак, он нас не интересует.
  // Если установлено "не печатать с нулевой суммой", и сумма 0, тоже пропуск.
  if not Srv.ProcessCfg.ShowInReport or (Srv.TotalCost < 1e-5) then Exit;
  Rep.FontBold := true;
  Rep.FontSize := 11;
  Rep.Cells[CurRow, 1] := Srv.ServiceName;
  Rep.InteriorColorIndex := xlColor15;
  Rep.FormatRange(CurRow, 1, CurRow, 1, frInteriorColorIndex);
  Rep.Cells[CurRow, 2] := FloatToStrF(Srv.TotalCost, ffNumber, 12, 4) + ' у.е.';
  Rep.FormatRange(CurRow, 1, CurRow, 2, frFontSize);
  CurRow := CurRow + 1;
  Rep.FontBold := false;
  if (Srv is TGridPolyProcess) and ((Srv as TGridPolyProcess).Grids.Count > 0) then
    for GridNum := 0 to (Srv as TGridPolyProcess).Grids.Count - 1 do
    begin
      SrvGrid := (Srv as TGridPolyProcess).Grids.Items[GridNum] as TProcessGrid;
      if SrvGrid.GridCfg.GridCols <> nil then begin
        dgcol := false;
        cnt := SrvGrid.GridCfg.GridCols.Count;
      end else if SrvGrid.DBGrid <> nil then begin
        dgcol := true;
        cnt := SrvGrid.DBGrid.Columns.Count;
      end else
        cnt := 0;
      if cnt > 0 then begin
        // Все колонки будут записываться в одну ячейку Excel, форматирование - пробелами,
        // поэтому сначала надо определить ширину колонок в символах.
        // Максимальную ширину текста колонок уст. в ширину заголовков:
        for i := 0 to Pred(cnt) do begin  // Для каждой колонки
          if dgcol then
            Cap := SrvGrid.DBGrid.Columns[i].Title.Caption
          else
            Cap := (SrvGrid.GridCfg.GridCols.Items[i] as TGridCol).Caption;
          MaxLen[i] := Length(Cap) + 2;
        end;
        dq := Srv.DataSet;
        if dq = nil then Exit;
        dq.DisableControls;
        try
          dq.First;
          while not dq.eof do
          try
            tc := dq.FindField(TOrderProcessItems.F_Cost);
            ec := dq.FindField(TOrderProcessItems.F_Enabled);
            // Если в очередной строке сервиса есть деньги и она не отключена
            if (tc <> nil) and not tc.IsNull and (tc.Value > 1e-6) then
            begin
              try
                if (ec <> nil) and not ec.IsNull and not ec.Value then continue;
              except end;
              for i := 0 to Pred(cnt) do
              begin  // Для каждой колонки
                if dgcol then
                  FieldName := SrvGrid.DBGrid.Columns[i].FieldName
                else
                  FieldName := (SrvGrid.GridCfg.GridCols.Items[i] as TGridCol).FieldName;
                f := dq.FindField(FieldName);
                if (f <> nil) and not f.IsNull and not (f is TBooleanField) then
                begin
                  if (f is TFloatField) or (f is TCurrencyField) or (f is TBCDField) then
                    try FieldValue := FloatToStrF(f.Value, ffNumber, 12, 4);
                    except FieldValue := '' end
                  else
                    FieldValue := f.AsString;
                  if Length(FieldValue) > MaxLen[i] - 2 then MaxLen[i] := Length(FieldValue) + 2;
                end;
              end; // конец цикла по колонкам
            end;
          finally
            dq.Next;
          end;
        finally
          dq.EnableControls;
        end;
        // Теперь MaxLen - ширины колонок в символах
        dq.DisableControls;
        try
          Cap := '';
          for i := 0 to dq.RecordCount - 1 do DataLine[i] := '';
          for i := 0 to Pred(cnt) do
          begin  // Для каждой колонки
            if dgcol then begin
              FieldName := SrvGrid.DBGrid.Columns[i].FieldName;
              CurCap := SrvGrid.DBGrid.Columns[i].Title.Caption;
            end else begin
              FieldName := (SrvGrid.GridCfg.GridCols.Items[i] as TGridCol).FieldName;
              CurCap := (SrvGrid.GridCfg.GridCols.Items[i] as TGridCol).Caption;
            end;
            f := dq.FindField(FieldName);
            // Пропускаем логические поля
            if (f <> nil) and not (f is TBooleanField) then
            begin
              Cap := Cap + AddCharR(' ', CurCap, MaxLen[i]);
              k := 0;
              dq.First;
              while not dq.eof do  // Для каждой строки сервиса
              try
                tc := dq.FindField(TOrderProcessItems.F_Cost);
                ec := dq.FindField(TOrderProcessItems.F_Enabled);
                // Если в очередной строке сервиса есть деньги и она не отключена
                if (tc <> nil) and not tc.IsNull and (tc.Value > 1e-6) then
                begin
                  try
                    if (ec <> nil) and not ec.IsNull and not ec.Value then continue;
                  except end;
                  if (f is TFloatField) or (f is TCurrencyField) or (f is TBCDField) then
                    try FieldValue := FloatToStrF(f.Value, ffNumber, 12, 4);
                    except FieldValue := ''; end
                  else
                    FieldValue := f.AsString;
                  DataLine[k] := DataLine[k] + AddCharR(' ', FieldValue, MaxLen[i]);
                  k := k + 1;
                end;
              finally
                dq.Next;
              end;
            end;
          end;
        finally
          dq.EnableControls;
        end;
        // Теперь все - в Excel
        if k > 0 then
        begin
          StartRow := CurRow - 1;
          Rep.Cells[CurRow, 1] := Cap;
          Rep.MergeRowCells(CurRow, 1, CurRow, 2);
          Rep.FontBold := true;
          Rep.FormatRange(StartRow, 1, CurRow, 2, frFontBold);
          Rep.FontBold := false;
          CurRow := CurRow + 1;
          for i := 0 to Pred(k) do begin
            Rep.Cells[CurRow, 1] := DataLine[i];
            Rep.MergeRowCells(CurRow, 1, CurRow, 2);
            CurRow := CurRow + 1;
          end;
          Rep.DrawAllFrames(StartRow, 1, CurRow - 1, 2);
        end;
        CurRow := CurRow + 1;
      end;
    end;
end;

procedure MakeOrderReport(_Rep: TBaseReport);
var
  s: string;
  cdOrd: TDataSet;
  CurOrder: TOrder;
begin
  Rep := _Rep;
  Rep.FontApplied := false;
  CurOrder := (MForm.CurrentController as TOrderController).Order;
  s := CurOrder.NameSingular;
  cdOrd := CurOrder.DataSet;
  Rep.Cells[1, 1] := s + ' № ' + IntToStr(CurOrder.OrderNumber) + '  ' + DateToStr(CurOrder.ModifyDate);
  Rep.Cells[1, 2] := CurOrder.CustomerName;
  Rep.Cells[2, 1] := CurOrder.Comment;
  if not Options.ShowFinalNative then
    Rep.Cells[3, 1] := FloatToStrF(CurOrder.Processes.GrandTotal, ffNumber, 12, 2) + ' у.е.';
  Rep.Cells[3, 2] := FloatToStrF(CurOrder.Processes.ClientTotalGrn, ffNumber, 12, 2) + ' грн.';
  CurRow := 5;
  CurOrder.Processes.ForEachKindProcessNonObj(EachServiceRep);
end;

end.
