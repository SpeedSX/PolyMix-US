unit JvInterpreter_Reports;

interface

uses DB, SysUtils, JvInterpreter,

  DicObj, PmContragent, BaseRpt;

procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);

var
  Rpt: TBaseReport = nil;

implementation

uses Controls, DBCLient, ComCtrls,
  Classes, JvJVCLUtils, Dialogs, Forms, Variants, Graphics, DateUtils,

  JvInterpreterFm, TLoggerUnit,

  ExHandler, MainData, MainForm, CostUkr, UkrUtils, PmScriptManager,
  fCanRep, RDBUtils, RDialogs, FullOrdRep, PmAccessManager, fOrdersFrame,
  PmOrder, CalcUtils, PmEntity, PmEntityController, MainFilter, PmAppController,
  PmInvoice, PmInvoiceItems, PmOrderController, PmDraftController, PmWorkController,
  PmCustomerPayments, PmOrderPayments, PmShipment, PmShipmentDoc,
  PmShipmentDocController, PmShipmentController, PmOrderNotes, PmOrderInvoiceItems,
  PmSaleDocs, PmSaleItems, PmDocument, PmMatRequest, PmPlan, PmPlanController,
  PmProcessEntity;

(*type
  TExcelReportLauncher = class
    procedure RunProgram(Sender: TObject);
    procedure HandleException(E: Exception; FPrg: TJvInterpreterFm);
  end;

var
  ExcelReportLauncher: TExcelReportLauncher;

procedure TExcelReportLauncher.RunProgram(Sender: TObject);
begin
  try
    (Sender as TJvInterpreterFm).Run;
  except
    on E: Exception do HandleException(E, Sender as TJvInterpreterFm);
  end;
end;

procedure TExcelReportLauncher.HandleException(E: Exception; FPrg: TJvInterpreterFm);
var
  ejv: EJvInterpreterError;
  esc: EJvScriptError;
  Msg: string;
begin
  if E is EJvInterpreterError then
  begin
    ejv := E as EJvInterpreterError;
    // Игнорируем ошибку, выскакивающую при пустом скрипте
    if (ejv.ErrCode = ieExpected) and
       (CompareText(ejv.ErrName1, LoadStr(irExpression)) = 0) then Exit;
    Msg := IntToStr(ejv.ErrCode) + ': ' + StringReplace(ejv.ErrMessage, #10, ' ', [rfReplaceAll]);
    //ShowScriptErrorDataSet(DataSet, E.ErrUnitName, E.ErrPos, Msg);
    ScriptManager.SetError(ejv.ErrUnitName, ejv.ErrPos, Msg);
  end
  else if E is EJvScriptError then
  begin
    esc := E as EJvScriptError;
    Msg := StringReplace(esc.Message, #10, ' ', [rfReplaceAll]);
    //ShowScriptErrorDataSet(DataSet, E.ErrUnitName, E.ErrPos, Msg);
    ScriptManager.SetError(esc.ErrUnitName, esc.ErrPos, Msg);
  end
  else
  begin
    Msg := IntToStr(FPrg.LastError.ErrCode) + ': ' +
      StringReplace(FPrg.LastError.ErrMessage, #10, ' ', [rfReplaceAll]);
    //ShowGlobalScriptError(rdm.cdReports, FPrg.LastError.ErrPos, Msg);
    //ShowScriptErrorDataSet(DataSet, FPrg.LastError.ErrUnitName, FPrg.LastError.ErrPos, Msg);
    ScriptManager.SetError(FPrg.LastError.ErrUnitName, FPrg.LastError.ErrPos, Msg);
  end;
end; *)

type
  TVarArray = class(TObject)
    V: variant;
  end;

{ function VarArrayCreate(const Bounds: array of Integer; VarType: Integer): Variant; }
procedure RAI2_VarArrayCreate2D(var Value: Variant; Args: TJvInterpreterArgs);
var
  VV: TVarArray;
begin
  VV := TVarArray.Create;
  VV.V := VarArrayCreate([Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3]],
                                            varVariant);
  Value := O2V(VV);
end;

{procedure RAI2_VarArrayRedim(var Value: Variant; Args: TJvInterpreterArgs);
begin
  VarArrayRedim(TVarArray(V2O(Args.Values[0])).V, integer(Args.Values[1]));
end;

procedure RAI2_VarArrayLowBound(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := VarArrayLowBound(TVarArray(V2O(Args.Values[0])).V, integer(Args.Values[1]));
end;

procedure RAI2_VarArrayHighBound(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := VarArrayHighBound(TVarArray(V2O(Args.Values[0])).V, integer(Args.Values[1]));
end;}

procedure TVarArray_Free(var Value: Variant; Args: TJvInterpreterArgs);
var
  VV: TVarArray;
begin
  VV := Args.Obj as TVarArray;
  if VV <> nil then VV.Free;
end;

procedure TVarArray_Read_Value(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TVarArray(Args.Obj).V[Args.Values[0], Args.Values[1]];
end;

procedure TVarArray_Write_Value(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TVarArray(Args.Obj).V[Args.Values[0], Args.Values[1]] := Value;
end;

procedure RAI2_WorkOrderData(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(MForm.FindController(TWorkController).Entity.DataSet);
end;

procedure RAI2_WorkOrderDataSource(var Value: Variant; Args: TJvInterpreterArgs);
begin
  raise Exception.Create('Вызов CalcOrderDataSource не поддерживается данной версией');
end;

procedure RAI2_CalcOrderData(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(MForm.FindController(TDraftController).Entity.DataSet);
end;

procedure RAI2_CalcOrderDataSource(var Value: Variant; Args: TJvInterpreterArgs);
begin
  raise Exception.Create('Вызов CalcOrderDataSource не поддерживается данной версией');
end;

procedure RAI2_CurrentData(var Value: Variant; Args: TJvInterpreterArgs);
var
  CurView: TEntityController;
begin
  CurView := MForm.CurrentOrderView;
  if CurView <> nil then
    Value := O2V(CurView.Entity.DataSet)
  else
    Value := null;
end;

procedure RAI2_FetchAllCurrentData(var Value: Variant; Args: TJvInterpreterArgs);
var
  CurView: TEntityController;
begin
  CurView := MForm.CurrentOrderView;
  if CurView <> nil then
    (CurView as TOrderController).Order.FetchAllRecords;
end;

procedure TOrder_FetchAllReportData(var Value: Variant; Args: TJvInterpreterArgs);
var
  CurView: TEntityController;
begin
  CurView := MForm.CurrentOrderView;
  if CurView <> nil then
    (CurView as TOrderController).Order.FetchAllReportData;
end;

procedure RAI2_SetCurrentData(var Value: Variant; Args: TJvInterpreterArgs);
var
  dq: TDataSet;
begin
  dq := V2O(Args.Values[0]) as TDataSet;
  MForm.SetCurrentData(dq);
end;

procedure RAI2_InCalc(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := MForm.CurrentController is TDraftController;
end;

procedure RAI2_OpenReport(var Value: Variant; Args: TJvInterpreterArgs);
begin
  ScriptManager.OpenReport(string(Args.Values[0]));
  Value := O2V(Rpt);
end;

procedure RAI2_OrderIsOpen(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := (MForm.CurrentController is TOrderController) and ((MForm.CurrentController as TOrderController).ViewMode = vmRight);
end;

procedure RAI2_CustomerData(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Customers.Open;
  Value := O2V(Customers.DataSet);
end;

procedure RAI2_ContractorData(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Contractors.Open;
  Value := O2V(Contractors.DataSet);
end;

procedure RAI2_SupplierData(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Suppliers.Open;
  Value := O2V(Suppliers.DataSet);
end;

procedure RAI2_CustomerPersonData(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Customers.Open;
  Value := O2V(Customers.Persons.DataSet);
end;

procedure RAI2_CustomerRelatedContragentData(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Customers.Open;
  Value := O2V(Customers.Related.DataSet);
end;

procedure RAI2_CustomerAddressData(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Customers.Open;
  Value := O2V(Customers.Addresses.DataSet);
end;

procedure RAI2_ContractorPersonData(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Contractors.Open;
  Value := O2V(Contractors.Persons.DataSet);
end;

procedure RAI2_ContractorAddressData(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Contractors.Open;
  Value := O2V(Contractors.Addresses.DataSet);
end;

procedure RAI2_SupplierPersonData(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Suppliers.Open;
  Value := O2V(Suppliers.Persons.DataSet);
end;

procedure RAI2_SupplierAddressData(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Suppliers.Open;
  Value := O2V(Suppliers.Addresses.DataSet);
end;

procedure RAI2_UserAccessData(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(AccessManager.UserData);
end;

procedure RAI2_UserName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := AccessManager.CurUser.Login;
end;

procedure RAI2_UserFullName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := AccessManager.CurUser.Name;
end;

procedure RAI2_MessageDlg(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := RusMessageDlg(Args.Values[0], Args.Values[1], TMsgDlgButtons(Word(V2S(Args.Values[2]))), Args.Values[3]);
end;

procedure RAI2_InputBox(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := RusInputBox(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

procedure RAI2_InputQuery(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := RusInputQuery(Args.Values[0], Args.Values[1], string(TVarData(Args.Values[2]).vString));
end;

procedure RAI2_InputDateQuery(var Value: Variant; Args: TJvInterpreterArgs);
var v: double;
begin
  v := TVarData(Args.Values[2]).vDate;
  Value := RusInputDateQuery(Args.Values[0], Args.Values[1], TDateTime(v));
//  TVarData(Args.Values[2]).vDate := v;
  Args.Values[2] := TDateTime(v);
end;

procedure RAI2_OpenOrder(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if MForm.CurrentController is TOrderController then
    (MForm.CurrentController as TOrderController).EditCurrent;
end;

procedure RAI2_CancelOrder(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if MForm.CurrentController is TOrderController then
    (MForm.CurrentController as TOrderController).CancelCurrent(nil);
end;

procedure RAI2_SaveOrder(var Value: Variant; Args: TJvInterpreterArgs);
begin
  //if MForm.CurrentView is TOrderView then
  //  Value := (MForm.CurrentView as TOrderView).SaveCurrent
  //else
  //  raise Exception.Create('Для выполнения SaveOrder текущий вид должен содержать заказ');
  if MForm.CurrentController is TOrderController then
    Value := (MForm.CurrentController as TOrderController).SaveCurrent
  else
    ExceptionHandler.Raise_('Недопустимая операция в данном контексте');
end;

procedure RAI2_CreatingOrder(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := (MForm.CurrentController is TOrderController) and ((MForm.CurrentController as TOrderController).State = stNew);
end;

procedure RAI2_CreatedOrderID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := (MForm.CurrentController as TOrderController).Order.NewOrderKey;
end;

procedure RAI2_CloseOrder(var Value: Variant; Args: TJvInterpreterArgs);
begin
  RusMessageDlg('Вызов устаревшей функции CloseOrder', mtWarning, [mbOk], 0);
  (MForm.CurrentController as TOrderController).CloseOrder;
end;

procedure RAI2_CloseServices(var Value: Variant; Args: TJvInterpreterArgs);
begin
  RusMessageDlg('Вызов устаревшей функции CloseServices', mtWarning, [mbOk], 0);
  (MForm.CurrentController as TOrderController).Order.Processes.CloseServices;
end;

procedure RAI2_MakeOrderReport(var Value: Variant; Args: TJvInterpreterArgs);
begin
  MakeOrderReport(Rpt);
end;

procedure RAI2_HInstance(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := HInstance;
end;

procedure RAI2_DrawBitmapTransparent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  DrawBitmapTransparent(TCanvas(V2O(Args.Values[0])), Args.Values[1], Args.Values[2],
    TBitmap(V2O(Args.Values[3])), Args.Values[4]);
end;

{ TODO -cJEDI Bug: Пришлось ввести такую процедуру, т.к. DecodeDate, описанная в JvInterpreter_SysUtils,
 не выдавала правильный год. Надо еще проверить и отправить ошибку }
procedure RAI2_DateToYear(var Value: Variant; Args: TJvInterpreterArgs);
{var
  Year, Month, Day: word;}
begin
  //DecodeDate(TDateTime(Args.Values[0]), Year, Month, Day);
  //Value := Year;
  Value := YearOf(TDateTime(Args.Values[0]));
end;

procedure RAI2_DateToMonth(var Value: Variant; Args: TJvInterpreterArgs);
{var
  Year, Month, Day: word;}
begin
  //DecodeDate(TDateTime(Args.Values[0]), Year, Month, Day);
  //Value := Month;
  Value := MonthOf(TDateTime(Args.Values[0]));
end;

procedure RAI2_DateToDay(var Value: Variant; Args: TJvInterpreterArgs);
//var
//  Year, Month, Day: word;
begin
  //DecodeDate(TDateTime(Args.Values[0]), Year, Month, Day);
  //Value := Day;
  Value := DayOf(TDateTime(Args.Values[0]));
end;

procedure RAI2_IncDay(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := IncDay(Args.Values[0], Args.Values[1]);
end;

procedure RAI2_SQLDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := FormatSQLDateTime(Args.Values[0]);
end;

//function Q_NumToGrn(V: Currency; RubFormat, CopFormat: LongWord): string;
procedure RAI2_NumToGrn(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := Q_NumToGrn(Args.Values[0], nrFull, nrNumShort);
end;

procedure RAI2_DateToUkrStr(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := DateToUkrStr(Args.Values[0]);
end;

procedure TBaseReport_SetColumnsPrnHeader(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).SetColumnsPrnHeader(Args.Values[0], Args.Values[1]);
end;

procedure TBaseReport_SetRowsPrnHeader(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).SetRowsPrnHeader(Args.Values[0], Args.Values[1]);
end;

procedure TBaseReport_Read_NameOfSheet(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).NameOfSheet[Args.Values[0]];
end;

procedure TBaseReport_Write_NameOfSheet(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).NameOfSheet[Args.Values[0]] := Value;
end;

procedure TBaseReport_Write_ActiveSheetNumber(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).ActiveSheetNumber := Value;
end;

procedure TBaseReport_Read_ActiveSheetNumber(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).ActiveSheetNumber;
end;

procedure TBaseReport_Read_Visible(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).Visible;
end;

procedure TBaseReport_Write_Visible(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).Visible := Value;
end;

procedure TBaseReport_Read_ScreenUpdating(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).ScreenUpdating;
end;

procedure TBaseReport_Write_ScreenUpdating(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).ScreenUpdating := Value;
end;

procedure TBaseReport_Read_DisplayStatusBar(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).DisplayStatusBar;
end;

procedure TBaseReport_Write_DisplayStatusBar(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).DisplayStatusBar := Value;
end;

procedure TBaseReport_Write_DisplayGridLines(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).DisplayGridLines := Value;
end;

procedure TBaseReport_Write_DisplayFormulaBar(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).DisplayFormulaBar := Value;
end;

procedure TBaseReport_Read_WinCaption1(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).WinCaption1;
end;

procedure TBaseReport_Write_WinCaption1(const Value: Variant; Args: TJvInterpreterArgs);
begin
  // Отключено, устанавливается автоматически
  //TBaseReport(Args.Obj).WinCaption1 := Value;
end;

procedure TBaseReport_Read_WinCaption2(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).WinCaption2;
end;

procedure TBaseReport_Write_WinCaption2(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).WinCaption2 := Value;
end;

procedure TBaseReport_Read_ScrollColumn(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).ScrollColumn;
end;

procedure TBaseReport_Write_ScrollColumn(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).ScrollColumn := Value;
end;

procedure TBaseReport_Read_ScrollRow(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).ScrollRow;
end;

procedure TBaseReport_Write_ScrollRow(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).ScrollRow := Value;
end;

procedure TBaseReport_CreateTable(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).CreateTable(TVarArray(V2O(Args.Values[0])).V, Args.Values[1], Args.Values[2],
    Args.Values[3], Args.Values[4]);
end;

procedure TBaseReport_Read_Cells(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).Cells[Args.Values[0], Args.Values[1]];
end;

procedure TBaseReport_Write_Cells(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).Cells[Args.Values[0], Args.Values[1]] := Value;
end;

procedure TBaseReport_Read_FontApplied(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).FontApplied;
end;

procedure TBaseReport_Write_FontApplied(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).FontApplied := Value;
end;

procedure TBaseReport_Read_Formulas(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).Formulas[Args.Values[0], Args.Values[1]];
end;

procedure TBaseReport_Write_Formulas(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).Formulas[Args.Values[0], Args.Values[1]] := Value;
end;

procedure TBaseReport_Read_DisplayZeros(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).DisplayZeros;
end;

procedure TBaseReport_Write_DisplayZeros(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).DisplayZeros := Value;
end;

procedure TBaseReport_Read_PrecisionAsDisplayed(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).PrecisionAsDisplayed;
end;

procedure TBaseReport_Write_PrecisionAsDisplayed(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).PrecisionAsDisplayed := Value;
end;

procedure TBaseReport_SetColumnsViewHeader(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).SetColumnsViewHeader(Args.Values[0], Args.Values[1]);
end;

procedure TBaseReport_SetRowsViewHeader(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).SetRowsViewHeader(Args.Values[0], Args.Values[1]);
end;

procedure TBaseReport_DrawAllFrames(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).DrawAllFrames(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3]);
end;

procedure TBaseReport_DrawInnerFrames(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).DrawInnerFrames(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3]);
end;

procedure TBaseReport_DrawOuterFrame(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).DrawOuterFrame(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3]);
end;

procedure TBaseReport_DrawRightLines(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).DrawRightLines(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3]);
end;

procedure TBaseReport_DrawLeftLines(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).DrawLeftLines(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3]);
end;

procedure TBaseReport_DrawTopLines(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).DrawTopLines(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3]);
end;

procedure TBaseReport_DrawBottomLines(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).DrawBottomLines(Args.Values[0], Args.Values[1], Args.Values[2], Args.Values[3]);
end;

procedure TBaseReport_DrawDiagonalLines(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).DrawDiagonalLines(Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3], Args.Values[4], Args.Values[5]);
end;

procedure TBaseReport_Read_FontBold(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).FontBold;
end;

procedure TBaseReport_Write_FontBold(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).FontBold := Value;
end;

procedure TBaseReport_Read_FontColorIndex(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).FontColorIndex;
end;

procedure TBaseReport_Write_FontColorIndex(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).FontColorIndex := Value;
end;

procedure TBaseReport_Read_FontItalic(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).FontItalic;
end;

procedure TBaseReport_Write_FontItalic(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).FontItalic := Value;
end;

procedure TBaseReport_Read_FontName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).FontName;
end;

procedure TBaseReport_Write_FontName(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).FontName := Value;
end;

procedure TBaseReport_Read_FontSize(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).FontSize;
end;

procedure TBaseReport_Write_FontSize(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).FontSize := Value;
end;

procedure TBaseReport_Read_FontStrikethrough(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).FontStrikethrough;
end;

procedure TBaseReport_Write_FontStrikethrough(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).FontStrikethrough := Value;
end;

procedure TBaseReport_Read_FontUnderline(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).FontUnderline;
end;

procedure TBaseReport_Write_FontUnderline(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).FontUnderline := Value;
end;

procedure TBaseReport_Read_FontSubscript(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).FontSubscript;
end;

procedure TBaseReport_Write_FontSubscript(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).FontSubscript := Value;
end;

procedure TBaseReport_Read_FontSuperscript(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).FontSuperscript;
end;

procedure TBaseReport_Write_FontSuperscript(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).FontSuperscript := Value;
end;

procedure TBaseReport_Read_HorizontalAlignment(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).HorizontalAlignment;
end;

procedure TBaseReport_Write_HorizontalAlignment(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).HorizontalAlignment := Value;
end;

procedure TBaseReport_Read_VerticalAlignment(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).VerticalAlignment;
end;

procedure TBaseReport_Write_VerticalAlignment(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).VerticalAlignment := Value;
end;

procedure TBaseReport_Read_WrapText(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).WrapText;
end;

procedure TBaseReport_Write_WrapText(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).WrapText := Value;
end;

procedure TBaseReport_Read_ShrinkToFit(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).ShrinkToFit;
end;

procedure TBaseReport_Write_ShrinkToFit(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).ShrinkToFit := Value;
end;

procedure TBaseReport_Read_InteriorColorIndex(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).InteriorColorIndex;
end;

procedure TBaseReport_Write_InteriorColorIndex(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).InteriorColorIndex := Value;
end;

procedure TBaseReport_Read_InteriorPatternColorIndex(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).InteriorPatternColorIndex;
end;

procedure TBaseReport_Write_InteriorPatternColorIndex(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).InteriorPatternColorIndex := Value;
end;

procedure TBaseReport_Read_InteriorPattern(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).InteriorPattern;
end;

procedure TBaseReport_Write_InteriorPattern(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).InteriorPattern := Value;
end;

procedure TBaseReport_Read_NumberFormat(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).NumberFormat;
end;

procedure TBaseReport_Write_NumberFormat(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).NumberFormat := Value;
end;

procedure TBaseReport_Read_Orientation(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).Orientation;
end;

procedure TBaseReport_Write_Orientation(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).Orientation := Value;
end;

procedure TBaseReport_Read_DisplayCommentIndicator(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).DisplayCommentIndicator;
end;

procedure TBaseReport_Write_DisplayCommentIndicator(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).DisplayCommentIndicator := Value;
end;

procedure TBaseReport_Read_BordersWeight(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).BordersWeight;
end;

procedure TBaseReport_Write_BordersWeight(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).BordersWeight := Value;
end;

procedure TBaseReport_Read_BordersColorIndex(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).BordersColorIndex;
end;

procedure TBaseReport_Write_BordersColorIndex(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).BordersColorIndex := Value;
end;

procedure TBaseReport_Read_BordersLineStyle(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).BordersLineStyle;
end;

procedure TBaseReport_Write_BordersLineStyle(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).BordersLineStyle := Value;
end;

procedure TBaseReport_GetRowHeight(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).GetRowHeight(Args.Values[0]);
end;

procedure TBaseReport_SetRowHeight(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).SetRowHeight(Args.Values[0], Args.Values[1]);
end;

procedure TBaseReport_SetColumnWidth(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).SetColumnWidth(Args.Values[0], Args.Values[1]);
end;

procedure TBaseReport_GetColumnWidth(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).GetColumnWidth(Args.Values[0]);
end;

procedure TBaseReport_ApplyNumberFormat(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).ApplyNumberFormat(Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3], Args.Values[4]);
end;

procedure TBaseReport_ProtectSheet(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).ProtectSheet(string(Args.Values[0]));
end;

procedure TBaseReport_UnprotectSheet(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).UnprotectSheet(string(Args.Values[0]));
end;

procedure TBaseReport_Lock(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).Lock(Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3]);
end;

procedure TBaseReport_UnLock(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).UnLock(Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3]);
end;

procedure TBaseReport_ClearInnerHLines(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).ClearInnerHLines(Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3]);
end;

procedure TBaseReport_Read_EnableSelection(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TBaseReport(Args.Obj).EnableSelection;
end;

procedure TBaseReport_Write_EnableSelection(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).EnableSelection := Value;
end;

procedure TBaseReport_Clear(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).Clear(Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3], Args.Values[4], Args.Values[5], Args.Values[6]);
end;

procedure TBaseReport_SetArrangement(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).SetArrangement(Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3], Args.Values[4], Args.Values[5], Args.Values[6]);
end;

procedure TBaseReport_SetInterior(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).SetInterior(Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3], Args.Values[4], Args.Values[5], Args.Values[6]);
end;

procedure TBaseReport_FormatRange(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).FormatRange(Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3], Args.Values[4]);
end;

procedure TBaseReport_Justify(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).Justify(Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3]);
end;

procedure TBaseReport_AlignHorizontal(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).AlignHorizontal(Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3], Args.Values[4], Args.Values[5]);
end;

procedure TBaseReport_AlignVertical(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).AlignVertical(Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3], Args.Values[4]);
end;

procedure TBaseReport_AutoFitColumns(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).AutoFitColumns(Args.Values[0], Args.Values[1]);
end;

procedure TBaseReport_AutoFitRows(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).AutoFitRows(Args.Values[0], Args.Values[1]);
end;

procedure TBaseReport_DeleteColumns(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).DeleteColumns(Args.Values[0], Args.Values[1]);
end;

procedure TBaseReport_InsertColumns(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).InsertColumns(Args.Values[0], Args.Values[1]);
end;

procedure TBaseReport_DeleteRows(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).DeleteRows(Args.Values[0], Args.Values[1]);
end;

procedure TBaseReport_InsertRows(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).InsertRows(Args.Values[0], Args.Values[1]);
end;

procedure TBaseReport_MergeAllCells(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).MergeAllCells(Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3]);
end;

procedure TBaseReport_MergeRowCells(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).MergeRowCells(Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3]);
end;

procedure TBaseReport_UnMergeCells(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).UnMergeCells(Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3]);
end;

procedure TBaseReport_CopyRange(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).CopyRange(Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3]);
end;

procedure TBaseReport_Paste(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TBaseReport(Args.Obj).Paste(Args.Values[0], Args.Values[1],
    Args.Values[2], Args.Values[3]);
end;

{ read ShortDateFormat }
procedure RAI2_Read_ShortDateFormat(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ShortDateFormat;
end;

{ read ShortDateFormat2 }
procedure RAI2_Read_ShortDateFormat2(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ShortDateFormat2;
end;

{ read LongDateFormat }
procedure RAI2_Read_LongDateFormat(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := LongDateFormat;
end;

{ read ShortTimeFormat }
procedure RAI2_Read_ShortTimeFormat(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ShortTimeFormat;
end;

{ read LongTimeFormat }
procedure RAI2_Read_LongTimeFormat(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := LongTimeFormat;
end;

procedure RAI2_Read_XLCancelled(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := XLCancelled;
end;

procedure RAI2_SetMaxProgress(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if CancelRepForm <> nil then
    CancelRepForm.MaxProgress := Args.Values[0];
end;

procedure RAI2_SetProgress(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if CancelRepForm <> nil then
    CancelRepForm.Progress := Args.Values[0];
end;

procedure RAI2_ProcessMessages(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Application.ProcessMessages;
end;

procedure RAI2_FilterPhrase(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := ScriptManager.GetFilterPhrase;
end;

procedure RAI2_OrderFilterEnabled(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := MForm.CurrentOrderView.Order.Criteria.FilterEnabled;
end;

procedure RAI2_SetSingleOrderFilter(var Value: Variant; Args: TJvInterpreterArgs);
begin
  MForm.CurrentOrderView.SetSingleOrderFilter(Args.Values[0]);
end;

procedure RAI2_ResetSingleOrderFilter(var Value: Variant; Args: TJvInterpreterArgs);
begin
  MForm.CurrentOrderView.ResetSingleOrderFilter;
end;

procedure RAI2_SingleOrderFilterSet(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := MForm.CurrentOrderView.Order.Criteria.SingleOrderFilterSet;
end;

procedure TPageControl_Read_ActivePage(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TPageControl(Args.Obj).ActivePage);
end;

procedure TPageControl_Write_ActivePage(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TPageControl(Args.Obj).ActivePage := TTabSheet(V2O(Value));
end;

procedure TPageControl_Read_ActivePageIndex(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPageControl(Args.Obj).ActivePageIndex;
end;

procedure TPageControl_Write_ActivePageIndex(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TPageControl(Args.Obj).ActivePageIndex := Value;
end;

procedure TStringList_Read_DelimitedText(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TStringList(Args.Obj).DelimitedText;
end;

procedure TStringList_Write_DelimitedText(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TStringList(Args.Obj).DelimitedText := Value;
end;

procedure TStringList_Read_Delimiter(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TStringList(Args.Obj).Delimiter;
end;

procedure TStringList_Write_Delimiter(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TStringList(Args.Obj).Delimiter := string(Value)[1];
end;

procedure TStringList_Read_StrictDelimiter(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TStringList(Args.Obj).StrictDelimiter;
end;

procedure TStringList_Write_StrictDelimiter(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TStringList(Args.Obj).StrictDelimiter := boolean(Value);
end;

procedure JvInterpreter_Invoices(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(AppController.Invoices);
end;

procedure JvInterpreter_InvoiceItems(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(AppController.Invoices.Items);
end;

procedure TInvoices_Create(var  Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TInvoices.Create);
end;

procedure TInvoices_Read_InvoiceNum(var  Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoices(Args.Obj).InvoiceNum;
end;

procedure TInvoices_Read_InvoiceDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoices(Args.Obj).InvoiceDate;
end;

procedure TInvoices_Read_CustomerID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoices(Args.Obj).CustomerID;
end;

procedure TInvoices_Read_Notes(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoices(Args.Obj).Notes;
end;

procedure TInvoices_Read_CustomerName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoices(Args.Obj).CustomerName;
end;

procedure TInvoices_Read_CustomerFullName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoices(Args.Obj).CustomerFullName;
end;

procedure TInvoices_Read_InvoiceCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoices(Args.Obj).InvoiceCost;
end;

procedure TInvoices_Read_InvoiceDebt(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoices(Args.Obj).InvoiceDebt;
end;

procedure TInvoices_Read_InvoiceCredit(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoices(Args.Obj).InvoiceCredit;
end;

procedure TInvoices_Read_PayType(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoices(Args.Obj).PayType;
end;

procedure TInvoices_Read_PayTypeName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoices(Args.Obj).PayTypeName;
end;

procedure TInvoices_Read_Items(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TInvoices(Args.Obj).Items);
end;

procedure TInvoices_Read_Criteria(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TInvoices(Args.Obj).Criteria);
end;

procedure TInvoices_Write_Criteria(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TInvoices(Args.Obj).Criteria := V2O(Value) as TInvoicesFilterObj;
end;

procedure TInvoicesFilterObj_Create(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TInvoicesFilterObj.Create);
end;

procedure TInvoiceItems_Read_ItemText(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoiceItems(Args.Obj).ItemText;
end;

procedure TInvoiceItems_Read_OrderNumber(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoiceItems(Args.Obj).OrderNumber;
end;

procedure TInvoiceItems_Read_CreationDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoiceItems(Args.Obj).CreationDate;
end;

procedure TInvoiceItems_Read_OrderID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoiceItems(Args.Obj).OrderID;
end;

procedure TInvoiceItems_Read_Quantity(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoiceItems(Args.Obj).Quantity;
end;

procedure TInvoiceItems_Read_ItemCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoiceItems(Args.Obj).ItemCost;
end;

procedure TInvoiceItems_Read_CriteriaInvoiceID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TInvoiceItems(Args.Obj).Criteria.InvoiceID;
end;

procedure TInvoiceItems_Write_CriteriaInvoiceID(const Value: Variant; Args: TJvInterpreterArgs);
var
  Criteria: TInvoiceItemsCriteria;
begin
  Criteria.InvoiceID := Value;
  TInvoiceItems(Args.Obj).Criteria := Criteria;
end;

procedure TOrderInvoiceItems_Read_ItemCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrderInvoiceItems(Args.Obj).ItemCost;
end;

procedure TOrderInvoiceItems_Read_PayType(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrderInvoiceItems(Args.Obj).PayType;
end;

procedure TOrderInvoiceItems_Read_InvoiceNumber(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrderInvoiceItems(Args.Obj).InvoiceNumber;
end;

procedure TOrderInvoiceItems_Read_InvoiceDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrderInvoiceItems(Args.Obj).InvoiceDate;
end;

procedure TOrderInvoiceItems_Read_CriteriaOrderID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrderInvoiceItems(Args.Obj).Criteria.OrderID;
end;

procedure TOrderInvoiceItems_Write_CriteriaOrderID(const Value: Variant; Args: TJvInterpreterArgs);
var
  Criteria: TOrderInvoiceItemsCriteria;
begin
  Criteria := TOrderInvoiceItemsCriteria.Default;
  Criteria.OrderID := Value;
  TOrderInvoiceItems(Args.Obj).Criteria := Criteria;
end;

procedure JvInterpreter_CustomerIncomes(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(AppController.CustomerIncomes);
end;

procedure TCustomerIncomes_Create(var  Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TCustomerIncomes.Create);
end;

procedure TCustomerIncomes_Read_IncomeCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerIncomes(Args.Obj).IncomeGrn;
end;

procedure TCustomerIncomes_Read_IncomeDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerIncomes(Args.Obj).IncomeDate;
end;

procedure TCustomerIncomes_Read_PayType(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerIncomes(Args.Obj).PayType;
end;

procedure TCustomerIncomes_Read_PayTypeName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerIncomes(Args.Obj).PayTypeName;
end;

procedure TCustomerIncomes_Read_Comment(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerIncomes(Args.Obj).GetterComment;
end;

procedure TCustomerIncomes_Read_CustomerID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerIncomes(Args.Obj).FieldCustomerID;
end;

procedure TCustomerIncomes_Read_CustomerName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerIncomes(Args.Obj).CustomerName;
end;

procedure TCustomerIncomes_Read_InvoiceID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerIncomes(Args.Obj).InvoiceID;
end;

procedure TCustomerIncomes_Read_InvoiceNum(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerIncomes(Args.Obj).IncomeInvoiceNumber;
end;

procedure TCustomerIncomes_Read_RestIncome(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerIncomes(Args.Obj).RestIncome;
end;

procedure TCustomerIncomes_Read_CriteriaInvoiceID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerIncomes(Args.Obj).Criteria.InvoiceID;
end;

procedure TCustomerIncomes_Write_CriteriaInvoiceID(const Value: Variant; Args: TJvInterpreterArgs);
{var
  Criteria: TInvoiceItemsCriteria;}
begin
  //Criteria.InvoiceID := Value;
  if TCustomerIncomes(Args.Obj).Criteria = nil then
    TCustomerIncomes(Args.Obj).Criteria := TPaymentsFilterObj.Create;
  TCustomerIncomes(Args.Obj).Criteria.InvoiceID := Value;
end;

procedure TCustomerIncomes_Read_Criteria(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TCustomerIncomes(Args.Obj).Criteria);
end;

procedure TCustomerIncomes_Write_Criteria(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TCustomerIncomes(Args.Obj).Criteria := TPaymentsFilterObj(V2O(Value));
end;

procedure TPaymentsFilterObj_Create(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TPaymentsFilterObj.Create);
end;

procedure JvInterpreter_CustomerOrders(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(AppController.CustomerOrders);
end;

procedure TCustomerOrders_Read_CustomerID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerOrders(Args.Obj).FieldCustomerID;
end;

procedure TCustomerOrders_Read_CustomerName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerOrders(Args.Obj).CustomerName;
end;

procedure TCustomerOrders_Read_OrderNumber(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerOrders(Args.Obj).OrderNumber;
end;

procedure TCustomerOrders_Read_CreationDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerOrders(Args.Obj).CreationDate;
end;

procedure TCustomerOrders_Read_Comment(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerOrders(Args.Obj).Comment;
end;

procedure TCustomerOrders_Read_PayTotal(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerOrders(Args.Obj).PayTotal;
end;

procedure TCustomerOrders_Read_FinalCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerOrders(Args.Obj).FinalCost;
end;

procedure TCustomerOrders_Read_InvoiceTotal(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerOrders(Args.Obj).InvoiceTotal;
end;

procedure TCustomerOrders_Read_PayDebt(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TCustomerOrders(Args.Obj).PayDebtGrn;
end;

procedure JvInterpreter_Shipment(var Value: Variant; Args: TJvInterpreterArgs);
begin
  // Зависит от контекста
  if MForm.CurrentController is TShipmentController then
    Value := O2V(MForm.CurrentController.Entity)
  else
    Value := O2V((MForm.CurrentController as TWorkController).OrderShipment);
end;

procedure TShipment_Read_QuantityToShip(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipment(Args.Obj).NumberToShip;
end;

procedure TShipment_Read_TotalQuantity(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipment(Args.Obj).ProductNumber;
end;

procedure TShipment_Read_CustomerName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipment(Args.Obj).CustomerName;
end;

procedure TShipment_Read_OrderNumber(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipment(Args.Obj).OrderNumber;
end;

procedure TShipment_Read_OrderID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipment(Args.Obj).OrderID;
end;

procedure TShipment_Read_ShipmentDocID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipment(Args.Obj).ShipmentDocID;
end;

procedure TShipment_Read_ShipmentDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipment(Args.Obj).ShipmentDate;
end;

procedure TShipment_Read_ShipmentDocNum(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipment(Args.Obj).ShipmentDocNum;
end;

procedure TShipment_Read_Comment(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipment(Args.Obj).Comment;
end;

procedure TShipment_Read_ItemText(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipment(Args.Obj).Comment;
end;

procedure TShipment_Read_WhoOut(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipment(Args.Obj).WhoOut;
end;

procedure TShipment_Read_WhoIn(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipment(Args.Obj).WhoIn;
end;

procedure TShipment_Read_BatchNum(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipment(Args.Obj).BatchNum;
end;

procedure TShipment_Read_IsTotal(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipment(Args.Obj).IsTotal;
end;

procedure TShipment_Read_IsFirstRow(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipment(Args.Obj).IsFirstRow;
end;

procedure TShipment_Read_Criteria(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TShipment(Args.Obj).Criteria);
end;

procedure JvInterpreter_OpenShipmentDoc(var Value: Variant; Args: TJvInterpreterArgs);
var
  ShipDoc: TShipmentDoc;
begin
  ShipDoc := TShipmentDocController.OpenShipmentDocEntity(Args.Values[0]);
  Value := O2V(ShipDoc);
end;

procedure JvInterpreter_OpenShipmentDetails(var Value: Variant; Args: TJvInterpreterArgs);
var
  ShipDetails: TShipment;
begin
  ShipDetails := TShipmentDocController.OpenShipmentDetailsEntity(Args.Values[0]);
  Value := O2V(ShipDetails);
end;

procedure TShipmentDoc_Read_ShipmentDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipmentDoc(Args.Obj).ShipmentDate;
end;

procedure TShipmentDoc_Read_ShipmentDocNum(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipmentDoc(Args.Obj).ShipmentDocNum;
end;

procedure TShipmentDoc_Read_CustomerName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipmentDoc(Args.Obj).CustomerName;
end;

procedure TShipmentDoc_Read_TrustSerie(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipmentDoc(Args.Obj).TrustSerie;
end;

procedure TShipmentDoc_Read_TrustNum(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipmentDoc(Args.Obj).TrustNum;
end;

procedure TShipmentDoc_Read_TrustDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipmentDoc(Args.Obj).TrustDate;
end;

procedure TShipmentDoc_Read_WhoOut(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipmentDoc(Args.Obj).WhoOut;
end;

procedure TShipmentDoc_Read_WhoIn(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TShipmentDoc(Args.Obj).WhoIn;
end;

procedure TShipmentFilterObj_Create(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TShipmentFilterObj.Create);
end;

procedure TOrderPayments_Read_PayType(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrderPayments(Args.Obj).PayType;
end;

procedure TOrderPayments_Read_PayDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrderPayments(Args.Obj).PayDate;
end;

procedure TOrderPayments_Create(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TOrderPayments.Create);
end;

procedure TOrderPayments_Read_PayCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrderPayments(Args.Obj).PaidGrn;
end;

procedure TOrderPayments_Read_CriteriaOrderID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrderPayments(Args.Obj).Criteria.OrderID;
end;

procedure TOrderPayments_Write_CriteriaOrderID(const Value: Variant; Args: TJvInterpreterArgs);
var
  Criteria: TOrderPaymentsCriteria;
begin
  Criteria.OrderID := Value;
  Criteria.Mode := TOrderPaymentsCriteria.Mode_Normal;
  TOrderPayments(Args.Obj).Criteria := Criteria;
end;

procedure TDocument_Read_DocNum(var  Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TDocument(Args.Obj).DocNum;
end;

procedure TDocument_Read_DocDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TDocument(Args.Obj).DocDate;
end;

procedure TDocument_Read_Items(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TDocument(Args.Obj).Items);
end;

procedure TDocument_Read_ContragentID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TDocument(Args.Obj).ContragentID;
end;

procedure TDocument_Read_PayType(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TDocument(Args.Obj).PayType;
end;

procedure JvInterpreter_SaleDocs(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(AppController.SaleDocs);
end;

procedure TSaleDocs_Create(var  Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TSaleDocs.Create);
end;

procedure TSaleDocs_Read_SaleCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TSaleDocs(Args.Obj).SaleCost;
end;

procedure TSaleDocs_Read_CustomerName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TSaleDocs(Args.Obj).CustomerName;
end;

procedure TSaleDocs_Read_Criteria(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TSaleDocs(Args.Obj).Criteria);
end;

procedure TSaleDocs_Write_Criteria(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TSaleDocs(Args.Obj).Criteria := TShipmentFilterObj(V2O(Value));
end;

procedure TSaleDocs_Read_SaleItems(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TSaleDocs(Args.Obj).SaleItems);
end;

procedure TSaleItems_Read_ItemText(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TSaleItems(Args.Obj).ItemText;
end;

procedure TSaleItems_Read_SaleQuantity(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TSaleItems(Args.Obj).SaleQuantity;
end;

procedure TSaleItems_Read_ItemCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TSaleItems(Args.Obj).ItemCost;
end;

procedure TSaleItems_Read_SaleCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TSaleItems(Args.Obj).SaleCost;
end;

{$REGION 'TMaterialRequests - Заявки на материалы'}

procedure JvInterpreter_MaterialRequests(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(AppController.MaterialRequests);
end;

procedure TMaterialRequests_Create(var  Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TMaterialRequests.Create);
end;

procedure TMaterialRequests_Read_CustomerName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TMaterialRequests(Args.Obj).CustomerName;
end;

procedure TMaterialRequests_Read_SupplierName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TMaterialRequests(Args.Obj).SupplierName;
end;

procedure TMaterialRequests_Read_OrderNumber(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TMaterialRequests(Args.Obj).OrderNumber;
end;

procedure TMaterialRequests_Read_MatDesc(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TMaterialRequests(Args.Obj).MatDesc;
end;

procedure TMaterialRequests_Read_Param1(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TMaterialRequests(Args.Obj).Param1;
end;

procedure TMaterialRequests_Read_Param2(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TMaterialRequests(Args.Obj).Param2;
end;

procedure TMaterialRequests_Read_Param3(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TMaterialRequests(Args.Obj).Param3;
end;

procedure TMaterialRequests_Read_FactParam1(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TMaterialRequests(Args.Obj).FactParam1;
end;

procedure TMaterialRequests_Read_FactParam2(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TMaterialRequests(Args.Obj).FactParam2;
end;

procedure TMaterialRequests_Read_FactParam3(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TMaterialRequests(Args.Obj).FactParam3;
end;

procedure TMaterialRequests_Read_MatAmount(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TMaterialRequests(Args.Obj).MatAmount;
end;

procedure TMaterialRequests_Read_FactMatAmount(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TMaterialRequests(Args.Obj).FactMatAmount;
end;

procedure TMaterialRequests_Read_FactReceiveDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TMaterialRequests(Args.Obj).FactReceiveDate;
end;

procedure TMaterialRequests_Read_PlanReceiveDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TMaterialRequests(Args.Obj).PlanReceiveDate;
end;

procedure TMaterialRequests_Read_Criteria(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TMaterialRequests(Args.Obj).Criteria);
end;

procedure TMaterialRequests_Write_Criteria(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TMaterialRequests(Args.Obj).Criteria := TMaterialFilterObj(V2O(Value));
end;

{$ENDREGION}

{$REGION 'TPlan, TWorkload - Планирование'}

const
  SCHEDULE_EXPECTED = 'Нет текущего плана';

procedure TProcessEntity_EquipGroupCode(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TProcessEntity(Args.Obj).EquipGroupCode;
end;

procedure TProcessEntity_ExecState(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TProcessEntity(Args.Obj).ExecState;
end;

procedure TProcessEntity_ItemDesc(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TProcessEntity(Args.Obj).ItemDesc;
end;

procedure TProcessEntity_Comment(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TProcessEntity(Args.Obj).Comment;
end;

procedure TProcessEntity_OrderNumber(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TProcessEntity(Args.Obj).OrderNumber;
end;

procedure TProcessEntity_OrderState(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TProcessEntity(Args.Obj).OrderState;
end;

procedure TProcessEntity_ItemID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TProcessEntity(Args.Obj).ItemID;
end;

procedure TProcessEntity_JobID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TProcessEntity(Args.Obj).JobID;
end;

procedure TProcessEntity_Part(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TProcessEntity(Args.Obj).Part;
end;

procedure TProcessEntity_ProcessID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TProcessEntity(Args.Obj).ProcessID;
end;

procedure TProcessEntity_Multiplier(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TProcessEntity(Args.Obj).Multiplier;
end;

procedure TProcessEntity_SideCount(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TProcessEntity(Args.Obj).SideCount;
end;

procedure TProcessEntity_EstimatedDuration(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TProcessEntity(Args.Obj).EstimatedDuration;
end;

procedure TProcessEntity_OrderID(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TProcessEntity(Args.Obj).OrderID;
end;

procedure TProcessEntity_PartName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TProcessEntity(Args.Obj).PartName;
end;

procedure JvInterpreter_ScheduleQueue(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if MForm.CurrentController is TPlanController then
    Value := O2V(MForm.CurrentController.Entity)
  else
    ExceptionHandler.Raise_(SCHEDULE_EXPECTED);
end;

procedure TScheduleQueue_EquipCode(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPlan(Args.Obj).EquipCode;
end;

// Признак есть ли комментарий к работе (JobComment)
procedure TScheduleQueue_HasComment(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPlan(Args.Obj).HasComment;
end;

// Признак есть ли технологические примечания к заказу
procedure TScheduleQueue_HasTechNotes(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPlan(Args.Obj).HasTechNotes;
end;

procedure TScheduleQueue_JobComment(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TPlan(Args.Obj).JobComment;
end;

procedure JvInterpreter_Workload(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if MForm.CurrentController is TPlanController then
  begin
    Value := O2V((MForm.CurrentController as TPlanController).CurrentWorkload);
  end else
    ExceptionHandler.Raise_(SCHEDULE_EXPECTED);
end;

procedure TWorkload_ShiftForemanName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TWorkload(Args.Obj).ShiftForemanName;
end;

procedure TWorkload_OperatorName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TWorkload(Args.Obj).OperatorName;
end;

{$ENDREGION}

{$REGION 'TEntity'}

procedure TEntity_Read_DataSet(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TEntity(Args.Obj).DataSet);
end;

procedure TEntity_Read_KeyValue(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TEntity(Args.Obj).KeyValue;
end;

procedure TEntity_Reload(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TEntity(Args.Obj).Reload;
end;

procedure TEntity_IsEmpty(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TEntity(Args.Obj).IsEmpty;
end;

procedure TEntity_Open(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TEntity(Args.Obj).Open;
end;

{$ENDREGION}

const
  ORDER_EXPECTED = 'Нет текущего заказа';

procedure JvInterpreter_Order(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if MForm.CurrentController is TOrderController then
    Value := O2V(MForm.CurrentController.Entity)
  else
    ExceptionHandler.Raise_(ORDER_EXPECTED);
end;

procedure TOrder_Read_Criteria(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TOrder(Args.Obj).Criteria);
end;

procedure TOrder_Write_Criteria(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TOrder(Args.Obj).Criteria := TOrderFilterObj(V2O(Value));
end;

procedure TOrder_Read_CostProtected(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrder(Args.Obj).CostProtected;
end;

procedure TOrder_Read_ContentProtected(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrder(Args.Obj).ContentProtected;
end;

procedure TOrder_Read_CallCustomer(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrder(Args.Obj).CallCustomer;
end;

procedure TOrder_Read_CallCustomerPhone(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrder(Args.Obj).CallCustomerPhone;
end;

procedure TOrder_Read_ProductFormat(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrder(Args.Obj).ProductFormat;
end;

procedure TOrder_Read_ProductPages(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrder(Args.Obj).ProductPages;
end;

procedure TOrder_Read_HaveLayout(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrder(Args.Obj).HaveLayout;
end;

procedure TOrder_Read_HavePattern(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrder(Args.Obj).HavePattern;
end;

procedure TOrder_Read_SignManager(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrder(Args.Obj).SignManager;
end;

procedure TOrder_Read_SignProof(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrder(Args.Obj).SignProof;
end;

procedure TOrder_Read_HaveProof(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrder(Args.Obj).HaveProof;
end;

procedure TOrder_Read_IncludeCover(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrder(Args.Obj).IncludeCover;
end;

procedure TOrder_Read_IsComposite(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrder(Args.Obj).IsComposite;
end;

procedure TOrder_Read_CreationDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrder(Args.Obj).CreationDate;
end;

procedure TOrder_Read_TotalExpenseCost(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrder(Args.Obj).TotalExpenseCost;
end;

procedure TOrder_Read_FinalCostNative(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrder(Args.Obj).FinalCostGrn;
end;

procedure TOrder_WriteEvent(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TOrder(Args.Obj).WriteEvent(string(Args.Values[0]), Args.Values[1]);
end;

procedure TOrder_Read_Notes(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TOrder(Args.Obj).Notes);
end;

procedure RAI2_OrderInvoiceItems(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if MForm.CurrentController is TWorkController then
    Value := O2V((MForm.CurrentController as TWorkController).OrderInvoiceItems)
  else
    ExceptionHandler.Raise_(ORDER_EXPECTED);
end;

procedure RAI2_OrderPayments(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if MForm.CurrentController is TWorkController then
    Value := O2V((MForm.CurrentController as TWorkController).OrderPayments)
  else
    ExceptionHandler.Raise_(ORDER_EXPECTED);
end;

procedure RAI2_OrderShipment(var Value: Variant; Args: TJvInterpreterArgs);
begin
  if MForm.CurrentController is TWorkController then
    Value := O2V((MForm.CurrentController as TWorkController).OrderShipment)
  else
    ExceptionHandler.Raise_(ORDER_EXPECTED);
end;

procedure TOrderNotes_Read_Note(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrderNotes(Args.Obj).NoteText;
end;

procedure TOrderNotes_Read_UseTech(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrderNotes(Args.Obj).UseTech;
end;

procedure TOrderNotes_Read_UserName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TOrderNotes(Args.Obj).UserName;
end;

procedure TFilterObj_Read_MonthYearChecked(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TFilterObj(Args.Obj).cbMonthYearChecked;
end;

procedure TFilterObj_Write_MonthYearChecked(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TFilterObj(Args.Obj).cbMonthYearChecked := Value;
end;

procedure TFilterObj_Read_MonthChecked(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TFilterObj(Args.Obj).cbMonthChecked;
end;

procedure TFilterObj_Write_MonthChecked(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TFilterObj(Args.Obj).cbMonthChecked := Value;
end;

procedure TFilterObj_Read_YearChecked(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TFilterObj(Args.Obj).rbYearChecked;
end;

procedure TFilterObj_Write_YearChecked(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TFilterObj(Args.Obj).rbYearChecked := Value;
end;

procedure TFilterObj_Read_MonthValue(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TFilterObj(Args.Obj).MonthValue;
end;

procedure TFilterObj_Write_MonthValue(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TFilterObj(Args.Obj).MonthValue := Value;
end;

procedure TFilterObj_Read_YearValue(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TFilterObj(Args.Obj).YearValue;
end;

procedure TFilterObj_Write_YearValue(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TFilterObj(Args.Obj).YearValue := Value;
end;

procedure TFilterObj_Read_CreatorChecked(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TFilterObj(Args.Obj).cbCreatorChecked;
end;

procedure TFilterObj_Write_CreatorChecked(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TFilterObj(Args.Obj).cbCreatorChecked := Value;
end;

procedure TFilterObj_Read_EventChecked(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TFilterObj(Args.Obj).cbEventChecked;
end;

procedure TFilterObj_Write_EventChecked(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TFilterObj(Args.Obj).cbEventChecked := Value;
end;

procedure TFilterObj_Read_CreatorName(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TFilterObj(Args.Obj).CreatorName;
end;

procedure TFilterObj_Write_CreatorName(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TFilterObj(Args.Obj).CreatorName := Value;
end;

procedure TFilterObj_Read_DayChecked(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TFilterObj(Args.Obj).rbOneDayChecked;
end;

procedure TFilterObj_Write_DayChecked(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TFilterObj(Args.Obj).rbOneDayChecked := Value;
end;

procedure TOrderFilterObj_Create(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TOrderFilterObj.Create);
end;

procedure TDraftOrder_Create(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TDraftOrder.Create(dm.aqCalcOrder));
end;

procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter );
begin
  with JvInterpreterAdapter do
  begin
    AddFunction('OrdRep', 'OpenReport', RAI2_OpenReport, 1, [varEmpty], varEmpty);
    AddFunction('OrdRep', 'ProcessMessages', RAI2_ProcessMessages, 0, [0], varEmpty);

    AddFunction('OrdRep', 'WorkOrderData', RAI2_WorkOrderData, 0, [0], varEmpty);
    AddFunction('OrdRep', 'CalcOrderData', RAI2_CalcOrderData, 0, [0], varEmpty);
    AddFunction('OrdRep', 'CurrentData', RAI2_CurrentData, 0, [0], varEmpty);
    AddFunction('OrdRep', 'FetchAllCurrentData', RAI2_FetchAllCurrentData, 0, [0], varEmpty);
    AddFunction('OrdRep', 'SetCurrentData', RAI2_SetCurrentData, 1, [varEmpty], varEmpty);
    AddFunction('OrdRep', 'InCalc', RAI2_InCalc, 0, [0], varEmpty);
    AddFunction('OrdRep', 'CreatingOrder', RAI2_CreatingOrder, 0, [0], varEmpty);
    AddFunction('OrdRep', 'OpenOrder', RAI2_OpenOrder, 0, [0], varEmpty);
    AddFunction('OrdRep', 'OrderIsOpen', RAI2_OrderIsOpen, 0, [0], varEmpty);
    AddFunction('OrdRep', 'CancelOrder', RAI2_CancelOrder, 0, [0], varEmpty);
    AddFunction('OrdRep', 'SaveOrder', RAI2_SaveOrder, 0, [0], varEmpty);
    AddFunction('OrdRep', 'CreatedOrderID', RAI2_CreatedOrderID, 0, [0], varEmpty);
    AddFunction('OrdRep', 'CloseServices', RAI2_CloseServices, 0, [0], varEmpty);
    AddFunction('OrdRep', 'CloseOrder', RAI2_CloseOrder, 0, [0], varEmpty);
    AddFunction('OrdRep', 'ReportCancelled', RAI2_Read_XLCancelled, 0, [0], varEmpty);
    AddFunction('OrdRep', 'SetMaxProgress', RAI2_SetMaxProgress, 1, [varEmpty], varEmpty);
    AddFunction('OrdRep', 'SetProgress', RAI2_SetProgress, 1, [varEmpty], varEmpty);

    AddFunction('OrdRep', 'FilterPhrase', RAI2_FilterPhrase, 0, [0], varEmpty);
    AddFunction('OrdRep', 'OrderFilterEnabled', RAI2_OrderFilterEnabled, 0, [0], varEmpty);

    // OBSOLETE. SetSingleOrderFilter
    AddFunction('OrdRep', 'SetPrintFilter', RAI2_SetSingleOrderFilter, 1, [varEmpty], varEmpty);
    // OBSOLETE. SingleOrderFilterSet
    AddFunction('OrdRep', 'PrintFilterSet', RAI2_SingleOrderFilterSet, 0, [0], varEmpty);

    AddFunction('OrdRep', 'SetSingleOrderFilter', RAI2_SetSingleOrderFilter, 1, [varEmpty], varEmpty);
    AddFunction('OrdRep', 'ResetSingleOrderFilter', RAI2_ResetSingleOrderFilter, 1, [varEmpty], varEmpty);
    AddFunction('OrdRep', 'SingleOrderFilterSet', RAI2_SingleOrderFilterSet, 0, [0], varEmpty);

    AddFunction('OrdRep', 'CustomerData', RAI2_CustomerData, 0, [0], varEmpty);
    AddFunction('OrdRep', 'ContractorData', RAI2_ContractorData, 0, [0], varEmpty);
    AddFunction('OrdRep', 'SupplierData', RAI2_SupplierData, 0, [0], varEmpty);
    AddFunction('OrdRep', 'CustomerPersonData', RAI2_CustomerPersonData, 0, [0], varEmpty);
    AddFunction('OrdRep', 'ContractorPersonData', RAI2_ContractorPersonData, 0, [0], varEmpty);
    AddFunction('OrdRep', 'SupplierPersonData', RAI2_SupplierPersonData, 0, [0], varEmpty);
    AddFunction('OrdRep', 'CustomerRelatedContragentData', RAI2_CustomerRelatedContragentData, 0, [0], varEmpty);
    AddFunction('OrdRep', 'CustomerAddressData', RAI2_CustomerAddressData, 0, [0], varEmpty);
    AddFunction('OrdRep', 'ContractorAddressData', RAI2_ContractorAddressData, 0, [0], varEmpty);
    AddFunction('OrdRep', 'SupplierAddressData', RAI2_SupplierAddressData, 0, [0], varEmpty);
    // CurrentCustomerData - obsolete (for compatibility only)
    AddFunction('OrdRep', 'CurrentCustomerData', RAI2_CustomerData, 0, [0], varEmpty);

    AddFunction('OrdRep', 'UserAccessData', RAI2_UserAccessData, 0, [0], varEmpty);

    AddFunction('OrdRep', 'UserName', RAI2_UserName, 0, [0], varEmpty);
    AddFunction('OrdRep', 'UserFullName', RAI2_UserFullName, 0, [0], varEmpty);
    AddFunction('OrdRep', 'MakeOrderReport', RAI2_MakeOrderReport, 0, [0], varEmpty);

    AddFunction('RDialogs', 'InputDateQuery', RAI2_InputDateQuery, 3, [varEmpty, varEmpty, varByRef], varEmpty);
    AddFunction('RDialogs', 'InputQuery', RAI2_InputQuery, 3, [varEmpty, varEmpty, varByRef], varEmpty);
    AddFunction('RDialogs', 'InputBox', RAI2_InputBox, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFunction('RDialogs', 'MessageDlg', RAI2_MessageDlg, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);

    AddFunction('SysInit', 'HInstance', RAI2_HInstance, 0, [0], varEmpty);
    AddFunction('jvJVCLUtils', 'DrawBitmapTransparent', RAI2_DrawBitmapTransparent, 5,
      [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddFunction('SysUtils', 'DateToYear', RAI2_DateToYear, 1, [varEmpty], varEmpty);
    AddFunction('SysUtils', 'DateToMonth', RAI2_DateToMonth, 1, [varEmpty], varEmpty);
    AddFunction('SysUtils', 'YearOf', RAI2_DateToYear, 1, [varEmpty], varEmpty);
    AddFunction('SysUtils', 'MonthOf', RAI2_DateToMonth, 1, [varEmpty], varEmpty);
    AddFunction('SysUtils', 'DayOf', RAI2_DateToDay, 1, [varEmpty], varEmpty);
    AddFunction('DateUtils', 'IncDay', RAI2_IncDay, 2, [varEmpty, varEmpty], varEmpty);
    AddFunction('OrdRep', 'FormatSQLDateTime', RAI2_SQLDate, 1, [varEmpty], varEmpty);
    //function Q_NumToGrn(V: Currency; RubFormat, CopFormat: LongWord): string;
    AddFunction('OrdRep', 'NumToGrn', RAI2_NumToGrn, 1, [varEmpty], varEmpty);
    AddFunction('OrdRep', 'DateToUkrStr', RAI2_DateToUkrStr, 1, [varEmpty], varEmpty);

    AddClass('OrdRep', TBaseReport, 'TExcelReport');
    AddGet(TBaseReport, 'SetColumnsPrnHeader', TBaseReport_SetColumnsPrnHeader, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'SetRowsPrnHeader', TBaseReport_SetRowsPrnHeader, 2, [varEmpty, varEmpty], varEmpty);
    AddIGet(TBaseReport, 'NameOfSheet', TBaseReport_Read_NameOfSheet, 1, [0], varEmpty);
    AddISet(TBaseReport, 'NameOfSheet', TBaseReport_Write_NameOfSheet, 1, [1]);
    AddGet(TBaseReport, 'ActiveSheetNumber', TBaseReport_Read_ActiveSheetNumber, 0, [0], varEmpty);
    AddSet(TBaseReport, 'ActiveSheetNumber', TBaseReport_Write_ActiveSheetNumber, 0, [0]);
    AddGet(TBaseReport, 'Visible', TBaseReport_Read_Visible, 0, [0], varEmpty);
    AddSet(TBaseReport, 'Visible', TBaseReport_Write_Visible, 0, [0]);
    AddGet(TBaseReport, 'ScreenUpdating', TBaseReport_Read_ScreenUpdating, 0, [0], varEmpty);
    AddSet(TBaseReport, 'ScreenUpdating', TBaseReport_Write_ScreenUpdating, 0, [0]);
    AddGet(TBaseReport, 'DisplayStatusBar', TBaseReport_Read_DisplayStatusBar, 0, [0], varEmpty);
    AddSet(TBaseReport, 'DisplayStatusBar', TBaseReport_Write_DisplayStatusBar, 0, [0]);
    AddSet(TBaseReport, 'DisplayGridLines', TBaseReport_Write_DisplayGridLines, 0, [0]);
    AddSet(TBaseReport, 'DisplayFormulaBar', TBaseReport_Write_DisplayFormulaBar, 0, [0]);
    AddGet(TBaseReport, 'WinCaption1', TBaseReport_Read_WinCaption1, 0, [0], varEmpty);
    AddSet(TBaseReport, 'WinCaption1', TBaseReport_Write_WinCaption1, 0, [0]);
    AddGet(TBaseReport, 'WinCaption2', TBaseReport_Read_WinCaption2, 0, [0], varEmpty);
    AddSet(TBaseReport, 'WinCaption2', TBaseReport_Write_WinCaption2, 0, [0]);
    AddGet(TBaseReport, 'ScrollColumn', TBaseReport_Read_ScrollColumn, 0, [0], varEmpty);
    AddSet(TBaseReport, 'ScrollColumn', TBaseReport_Write_ScrollColumn, 0, [0]);
    AddGet(TBaseReport, 'ScrollRow', TBaseReport_Read_ScrollRow, 0, [0], varEmpty);
    AddSet(TBaseReport, 'ScrollRow', TBaseReport_Write_ScrollRow, 0, [0]);
    AddGet(TBaseReport, 'CreateTable', TBaseReport_CreateTable, 5, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddIGet(TBaseReport, 'Cells', TBaseReport_Read_Cells, 2, [0, 0], varEmpty);
    AddISet(TBaseReport, 'Cells', TBaseReport_Write_Cells, 2, [0, 0]);
    AddGet(TBaseReport, 'FontApplied', TBaseReport_Read_FontApplied, 0, [0], varEmpty);
    AddSet(TBaseReport, 'FontApplied', TBaseReport_Write_FontApplied, 0, [0]);
    AddIGet(TBaseReport, 'Formulas', TBaseReport_Read_Formulas, 2, [0, 0], varEmpty);
    AddISet(TBaseReport, 'Formulas', TBaseReport_Write_Formulas, 2, [0, 0]);
    AddGet(TBaseReport, 'PrecisionAsDisplayed', TBaseReport_Read_PrecisionAsDisplayed, 0, [0], varEmpty);
    AddSet(TBaseReport, 'PrecisionAsDisplayed', TBaseReport_Write_PrecisionAsDisplayed, 0, [0]);
    AddGet(TBaseReport, 'DisplayZeros', TBaseReport_Read_DisplayZeros, 0, [0], varEmpty);
    AddSet(TBaseReport, 'DisplayZeros', TBaseReport_Write_DisplayZeros, 0, [0]);
    AddGet(TBaseReport, 'SetColumnsViewHeader', TBaseReport_SetColumnsViewHeader, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'SetRowsViewHeader', TBaseReport_SetRowsViewHeader, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'DrawAllFrames', TBaseReport_DrawAllFrames, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'DrawInnerFrames', TBaseReport_DrawInnerFrames, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'DrawOuterFrame', TBaseReport_DrawOuterFrame, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'DrawRightLines', TBaseReport_DrawRightLines, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'DrawLeftLines', TBaseReport_DrawLeftLines, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'DrawTopLines', TBaseReport_DrawTopLines, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'DrawBottomLines', TBaseReport_DrawBottomLines, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'DrawDiagonalLines', TBaseReport_DrawDiagonalLines, 6, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'ClearInnerHLines', TBaseReport_ClearInnerHLines, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'AutoFitColumns', TBaseReport_AutoFitColumns, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'AutoFitRows', TBaseReport_AutoFitRows, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'DeleteColumns', TBaseReport_DeleteColumns, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'DeleteRows', TBaseReport_DeleteRows, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'InsertColumns', TBaseReport_InsertColumns, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'InsertRows', TBaseReport_InsertRows, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'MergeRowCells', TBaseReport_MergeRowCells, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'MergeAllCells', TBaseReport_MergeAllCells, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'UnMergeCells', TBaseReport_UnMergeCells, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'FontBold', TBaseReport_Read_FontBold, 0, [0], varEmpty);
    AddSet(TBaseReport, 'FontBold', TBaseReport_Write_FontBold, 0, [0]);
    AddGet(TBaseReport, 'FontColorIndex', TBaseReport_Read_FontColorIndex, 0, [0], varEmpty);
    AddSet(TBaseReport, 'FontColorIndex', TBaseReport_Write_FontColorIndex, 0, [0]);
    AddGet(TBaseReport, 'FontItalic', TBaseReport_Read_FontItalic, 0, [0], varEmpty);
    AddSet(TBaseReport, 'FontItalic', TBaseReport_Write_FontItalic, 0, [0]);
    AddGet(TBaseReport, 'FontName', TBaseReport_Read_FontName, 0, [0], varEmpty);
    AddSet(TBaseReport, 'FontName', TBaseReport_Write_FontName, 0, [0]);
    AddGet(TBaseReport, 'FontSize', TBaseReport_Read_FontSize, 0, [0], varEmpty);
    AddSet(TBaseReport, 'FontSize', TBaseReport_Write_FontSize, 0, [0]);
    AddGet(TBaseReport, 'FontStrikethrough', TBaseReport_Read_FontStrikethrough, 0, [0], varEmpty);
    AddSet(TBaseReport, 'FontStrikethrough', TBaseReport_Write_FontStrikethrough, 0, [0]);
    AddGet(TBaseReport, 'FontSubscript', TBaseReport_Read_FontSubscript, 0, [0], varEmpty);
    AddSet(TBaseReport, 'FontSubscript', TBaseReport_Write_FontSubscript, 0, [0]);
    AddGet(TBaseReport, 'FontSuperscript', TBaseReport_Read_FontSuperscript, 0, [0], varEmpty);
    AddSet(TBaseReport, 'FontSuperscript', TBaseReport_Write_FontSuperscript, 0, [0]);
    AddGet(TBaseReport, 'FontUnderline', TBaseReport_Read_FontUnderline, 0, [0], varEmpty);
    AddSet(TBaseReport, 'FontUnderline', TBaseReport_Write_FontUnderline, 0, [0]);
    AddGet(TBaseReport, 'AlignHorizontal', TBaseReport_AlignHorizontal, 6, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'AlignVertical', TBaseReport_AlignVertical, 5, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'SetArrangement', TBaseReport_SetArrangement, 7, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'SetInterior', TBaseReport_SetInterior, 7, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'Justify', TBaseReport_Justify, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'HorizontalAlignment', TBaseReport_Read_HorizontalAlignment, 0, [0], varEmpty);
    AddSet(TBaseReport, 'HorizontalAlignment', TBaseReport_Write_HorizontalAlignment, 0, [0]);
    AddGet(TBaseReport, 'VerticalAlignment', TBaseReport_Read_VerticalAlignment, 0, [0], varEmpty);
    AddSet(TBaseReport, 'VerticalAlignment', TBaseReport_Write_VerticalAlignment, 0, [0]);
    AddGet(TBaseReport, 'Orientation', TBaseReport_Read_Orientation, 0, [0], varEmpty);
    AddSet(TBaseReport, 'Orientation', TBaseReport_Write_Orientation, 0, [0]);
    AddGet(TBaseReport, 'WrapText', TBaseReport_Read_WrapText, 0, [0], varEmpty);
    AddSet(TBaseReport, 'WrapText', TBaseReport_Write_WrapText, 0, [0]);
    AddGet(TBaseReport, 'ShrinkToFit', TBaseReport_Read_ShrinkToFit, 0, [0], varEmpty);
    AddSet(TBaseReport, 'ShrinkToFit', TBaseReport_Write_ShrinkToFit, 0, [0]);
    AddGet(TBaseReport, 'InteriorColorIndex', TBaseReport_Read_InteriorColorIndex, 0, [0], varEmpty);
    AddSet(TBaseReport, 'InteriorColorIndex', TBaseReport_Write_InteriorColorIndex, 0, [0]);
    AddGet(TBaseReport, 'InteriorPattern', TBaseReport_Read_InteriorPattern, 0, [0], varEmpty);
    AddSet(TBaseReport, 'InteriorPattern', TBaseReport_Write_InteriorPattern, 0, [0]);
    AddGet(TBaseReport, 'InteriorPatternColorIndex', TBaseReport_Read_InteriorPatternColorIndex, 0, [0], varEmpty);
    AddSet(TBaseReport, 'InteriorPatternColorIndex', TBaseReport_Write_InteriorPatternColorIndex, 0, [0]);
    AddGet(TBaseReport, 'ApplyNumberFormat', TBaseReport_ApplyNumberFormat, 5, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'NumberFormat', TBaseReport_Read_NumberFormat, 0, [0], varEmpty);
    AddSet(TBaseReport, 'NumberFormat', TBaseReport_Write_NumberFormat, 0, [0]);
    AddGet(TBaseReport, 'ProtectSheet', TBaseReport_ProtectSheet, 1, [varEmpty], varEmpty);
    AddGet(TBaseReport, 'UnprotectSheet', TBaseReport_UnprotectSheet, 1, [varEmpty], varEmpty);
    AddGet(TBaseReport, 'Lock', TBaseReport_Lock, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'UnLock', TBaseReport_Unlock, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'EnableSelection', TBaseReport_Read_EnableSelection, 0, [0], varEmpty);
    AddSet(TBaseReport, 'EnableSelection', TBaseReport_Write_EnableSelection, 0, [0]);
    AddGet(TBaseReport, 'Clear', TBaseReport_Clear, 7, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'FormatRange', TBaseReport_FormatRange, 5, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'DisplayCommentIndicator', TBaseReport_Read_DisplayCommentIndicator, 0, [0], varEmpty);
    AddSet(TBaseReport, 'DisplayCommentIndicator', TBaseReport_Write_DisplayCommentIndicator, 0, [0]);
    AddGet(TBaseReport, 'BordersWeight', TBaseReport_Read_BordersWeight, 0, [0], varEmpty);
    AddSet(TBaseReport, 'BordersWeight', TBaseReport_Write_BordersWeight, 0, [0]);
    AddGet(TBaseReport, 'BordersColorIndex', TBaseReport_Read_BordersColorIndex, 0, [0], varEmpty);
    AddSet(TBaseReport, 'BordersColorIndex', TBaseReport_Write_BordersColorIndex, 0, [0]);
    AddGet(TBaseReport, 'BordersLineStyle', TBaseReport_Read_BordersLineStyle, 0, [0], varEmpty);
    AddSet(TBaseReport, 'BordersLineStyle', TBaseReport_Write_BordersLineStyle, 0, [0]);
    AddGet(TBaseReport, 'GetRowHeight', TBaseReport_GetRowHeight, 1, [varEmpty], varEmpty);
    AddGet(TBaseReport, 'SetRowHeight', TBaseReport_SetRowHeight, 2, [varEmpty, varEmpty], varEmpty);
    { TODO -cInterpreter: Вообще-то есть еще SetRowsHeight, но там динамический массив }
    AddGet(TBaseReport, 'GetColumnWidth', TBaseReport_GetColumnWidth, 1, [varEmpty], varEmpty);
    AddGet(TBaseReport, 'SetColumnWidth', TBaseReport_SetColumnWidth, 2, [varEmpty, varEmpty], varEmpty);

    AddGet(TBaseReport, 'CopyRange', TBaseReport_CopyRange, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddGet(TBaseReport, 'Paste', TBaseReport_Paste, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);

    AddConst('OrdRep', 'frBordersLineStyle', frBordersLineStyle);  // Задание стиля линий
    AddConst('OrdRep', 'frBordersWeight', frBordersWeight); // Задание толщины линий
    AddConst('OrdRep', 'frBordersColorIndex', frBordersColorIndex);  // Задание цвета линий
    AddConst('OrdRep', 'frFontBold', frFontBold);  // Включение/отключение жирного шрифта
    AddConst('OrdRep', 'frFontColorIndex', frFontColorIndex); // Задание цвета шрифта
    AddConst('OrdRep', 'frFontItalic', frFontItalic); // Включение/отключение наклонного шрифта
    AddConst('OrdRep', 'frFontName', frFontName); // Выбор типа шрифта (названия фонта)
    AddConst('OrdRep', 'frFontSize', frFontSize);  // Изменение размера символов
    AddConst('OrdRep', 'frFontStrikethrough', frFontStrikethrough); // Включение/отключение наклонного шрифта
    AddConst('OrdRep', 'frFontSubscript', frFontSubscript);  // Включение/отключение нижнего индекса
    AddConst('OrdRep', 'frFontSuperscript', frFontSuperscript);// Включение/отключение верхнего индекса
    AddConst('OrdRep', 'frFontUnderline', frFontUnderline);// Включение/отключение режима подчеркивания
    AddConst('OrdRep', 'frHorizontalAlignment', frHorizontalAlignment);  // Задание режима горизонтального выравнивания
    AddConst('OrdRep', 'frVerticalAlignment', frVerticalAlignment); // Задание режима вертикального выравнивания
    AddConst('OrdRep', 'frOrientation', frOrientation); // Задание ориентации надписей
    AddConst('OrdRep', 'frWrapText' , frWrapText); // Включение/отключение режима переноса слов
    AddConst('OrdRep', 'frShrinkToFit', frShrinkToFit); // Изменение размера символов так, чтобы надписи умещались в ячейках
    AddConst('OrdRep', 'frInteriorColorIndex', frInteriorColorIndex);  // Задание цвета фона ячеек
    AddConst('OrdRep', 'frInteriorPattern', frInteriorPattern); // Задание способа штриховки ячеек
    AddConst('OrdRep', 'frInteriorPCI', frInteriorPCI); // Задание цвета штриховки
    AddConst('OrdRep', 'frNumberFormat', frNumberFormat); // Изменение формата представления содержимого ячеек

    AddConst('OrdRep', 'frBorders', frBorders);  // Изменение всех параметров, касающихся границ ячеек
    AddConst('OrdRep', 'frFont', frFont);  // Изменение всех параметров, касающихся шрифта
    AddConst('OrdRep', 'frAligns', frAligns); // Изменение всех параметров, связанных с выравниванием содержимого ячеек
    AddConst('OrdRep', 'frInterior', frInterior);  // Изменение параметров, касающихся фона и заливки ячеек

    // Стиль линий (XlLineStyle)
    AddConst('OrdRep', 'xlNone', xlNone);           // Линия отсутствует
    AddConst('OrdRep', 'xlLineStyleNone', xlLineStyleNone); // Линия отсутствует
    AddConst('OrdRep', 'xlContinuous', xlContinuous); // Непрерывная линия
    AddConst('OrdRep', 'xlDash', xlDash);           // Линия состоит из тире
    AddConst('OrdRep', 'xlDashDot', xlDashDot);     // Точка - тире
    AddConst('OrdRep', 'xlDashDotDot', xlDashDotDot);  // Тире - точка - точка
    AddConst('OrdRep', 'xlDot', xlDot);            // Линия состоит из точек
    AddConst('OrdRep', 'xlDouble', xlDouble);         // Двойная сплошная линия
    AddConst('OrdRep', 'xlSlantDashDot', xlSlantDashDot); // Линия состоит из тире и косых черточек

    // Толщина линий (XlBordersWeight)
    AddConst('OrdRep', 'xlHairline', xlHairline); // Самая тонкая линия
    AddConst('OrdRep', 'xlThin', xlThin);             // Тонкая линия
    AddConst('OrdRep', 'xlMedium', int(xlMedium));  // Линия средней толщины (жирная)
    AddConst('OrdRep', 'xlThick', xlThick); // Толстая линия

    AddConst('OrdRep', 'xlColorIndexAutomatic', xlColorIndexAutomatic); // Цвет выбирается автоматически
    AddConst('OrdRep', 'xlColorIndexNone', xlColorIndexNone); // Цвет отсутствует
    AddConst('OrdRep', 'xlColor1', xlColor1); // Черный
    AddConst('OrdRep', 'xlColor53', xlColor53); // Коричневый
    AddConst('OrdRep', 'xlColor52', xlColor52); // Оливковый
    AddConst('OrdRep', 'xlColor51', xlColor51); // Темно-зеленый
    AddConst('OrdRep', 'xlColor49', xlColor49); // Темно-сизый
    AddConst('OrdRep', 'xlColor11', xlColor11); // Темно-синий
    AddConst('OrdRep', 'xlColor55', xlColor55); // Индиго
    AddConst('OrdRep', 'xlColor56', xlColor56); // Серый 80%
    AddConst('OrdRep', 'xlColor9', xlColor9); // Темно-красный
    AddConst('OrdRep', 'xlColor46', xlColor46); // Оранжевый
    AddConst('OrdRep', 'xlColor12', xlColor12); // Коричнево-зеленый
    AddConst('OrdRep', 'xlColor10', xlColor10); // Зеленый
    AddConst('OrdRep', 'xlColor14', xlColor14); // Сине-зеленый
    AddConst('OrdRep', 'xlColor5', xlColor5); // Синий
    AddConst('OrdRep', 'xlColor47', xlColor47); // Сизый
    AddConst('OrdRep', 'xlColor16', xlColor16); // Серый 50%
    AddConst('OrdRep', 'xlColor3', xlColor3); // Красный
    AddConst('OrdRep', 'xlColor45', xlColor45); // Светло-оранжевый
    AddConst('OrdRep', 'xlColor43', xlColor43); // Травяной
    AddConst('OrdRep', 'xlColor50', xlColor50); // Изумрудный
    AddConst('OrdRep', 'xlColor42', xlColor42); // Темно-бирюзовый
    AddConst('OrdRep', 'xlColor41', xlColor41); // Темно-голубой
    AddConst('OrdRep', 'xlColor13', xlColor13); // Фиолетовый
    AddConst('OrdRep', 'xlColor48', xlColor48); // Серый 40%
    AddConst('OrdRep', 'xlColor7', xlColor7); // Лиловый
    AddConst('OrdRep', 'xlColor44', xlColor44); // Золотистый
    AddConst('OrdRep', 'xlColor6', xlColor6); // Желтый
    AddConst('OrdRep', 'xlColor4', xlColor4); // Ярко-зеленый
    AddConst('OrdRep', 'xlColor8', xlColor8); // Бирюзовый
    AddConst('OrdRep', 'xlColor33', xlColor33); // Голубой
    AddConst('OrdRep', 'xlColor54', xlColor54); // Вишневый
    AddConst('OrdRep', 'xlColor15', xlColor15); // Серый 25%
    AddConst('OrdRep', 'xlColor38', xlColor38); // Розовый
    AddConst('OrdRep', 'xlColor40', xlColor40); // Светло-коричневый
    AddConst('OrdRep', 'xlColor36', xlColor36); // Светло-желтый
    AddConst('OrdRep', 'xlColor35', xlColor35); // Бледно-зеленый
    AddConst('OrdRep', 'xlColor34', xlColor34); // Светло-бирюзовый
    AddConst('OrdRep', 'xlColor37', xlColor37); // Бледно-голубой
    AddConst('OrdRep', 'xlColor39', xlColor39); // Сиреневый
    AddConst('OrdRep', 'xlColor2', xlColor2); // Белый
    AddConst('OrdRep', 'xlColor17', xlColor17); // Сине-фиолетовый
    AddConst('OrdRep', 'xlColor18', xlColor18); // Вишневый
    AddConst('OrdRep', 'xlColor19', xlColor19); // Слоновая кость
    AddConst('OrdRep', 'xlColor20', xlColor20); // Светло-бирюзовый
    AddConst('OrdRep', 'xlColor21', xlColor21); // Темно-фиолетовый
    AddConst('OrdRep', 'xlColor22', xlColor22); // Коралловый
    AddConst('OrdRep', 'xlColor23', xlColor23); // Васильковый
    AddConst('OrdRep', 'xlColor24', xlColor24); // Пастельный голубой
    AddConst('OrdRep', 'xlColor25', xlColor25); // Темно-синий
    AddConst('OrdRep', 'xlColor26', xlColor26); // Лиловый
    AddConst('OrdRep', 'xlColor27', xlColor27); // Желтый
    AddConst('OrdRep', 'xlColor28', xlColor28); // Бирюзовый
    AddConst('OrdRep', 'xlColor29', xlColor29); // Фиолетовый
    AddConst('OrdRep', 'xlColor30', xlColor30); // Темно-красный
    AddConst('OrdRep', 'xlColor31', xlColor31); // Сине-зеленый
    AddConst('OrdRep', 'xlColor32', xlColor32); // Синий

    AddConst('OrdRep', 'xlUnderlineStyleNone', xlUnderlineStyleNone); // Подчеркивание отсутствует
    AddConst('OrdRep', 'xlUnderlineStyleSingle', xlUnderlineStyleSingle); // Одинарное подчеркивание по значению
    AddConst('OrdRep', 'xlUnderlineStyleSingleAccounting', xlUnderlineStyleSingleAccounting); // Одинарное подчеркивание по ячейке
    AddConst('OrdRep', 'xlUnderlineStyleDouble', xlUnderlineStyleDouble); // Двойное подчеркивание по значению
    AddConst('OrdRep', 'xlUnderlineStyleDoubleAccounting', xlUnderlineStyleDoubleAccounting); // Двойное подчеркивание по ячейке

    AddConst('OrdRep', 'xlHAlignCenter', xlHAlignCenter); // Выравнивание по центру
    AddConst('OrdRep', 'xlHAlignCenterAcrossSelection', xlHAlignCenterAcrossSelection); // Выравнивание по центру выделения
    AddConst('OrdRep', 'xlHAlignLeft', xlHAlignLeft); // Выравнивание по левому краю (может быть отступ)
    AddConst('OrdRep', 'xlHAlignRight', xlHAlignRight); // Выравнивание по правому краю
    AddConst('OrdRep', 'xlHAlignFill', xlHAlignFill); // Выравнивание с заполнением
    AddConst('OrdRep', 'xlHAlignGeneral', xlHAlignGeneral); // Выравнивание в зависимости от значения ячейки
    AddConst('OrdRep', 'xlHAlignJustify', xlHAlignJustify); // Изменение ширины столбца, чтобы полностью отобразить содержимое ячейки
    AddConst('OrdRep', 'xlVAlignCenter', xlVAlignCenter); // Выравнивание по центру
    AddConst('OrdRep', 'xlVAlignTop', xlVAlignTop); // Выравнивание по верхнему краю
    AddConst('OrdRep', 'xlVAlignBottom', xlVAlignBottom); // Выравнивание по нижнему краю
    AddConst('OrdRep', 'xlVAlignJustify', xlVAlignJustify); // Подбор высоты строки, чтобы полностью отобразить содержимое ячейки

    AddConst('OrdRep', 'xlPatternAutomatic', xlPatternAutomatic); // Автоматическая штриховка
    AddConst('OrdRep', 'xlPatternChecker', xlPatternChecker); // Диагональная клетчатая штриховка
    AddConst('OrdRep', 'xlPatternCrissCross', xlPatternCrissCross); // Тонкая диагональная клетчатая
    AddConst('OrdRep', 'xlPatternDown', xlPatternDown); // Диагональная штриховка вниз
    AddConst('OrdRep', 'xlPatternGray16', xlPatternGray16); // 12.5-ный серый
    AddConst('OrdRep', 'xlPatternGray25', xlPatternGray25); // 25%-ный серый
    AddConst('OrdRep', 'xlPatternGray50', xlPatternGray50); // 50%-ный серый
    AddConst('OrdRep', 'xlPatternGray75', xlPatternGray75); // 75%-ный серый
    AddConst('OrdRep', 'xlPatternGray8', xlPatternGray8); // 6.25-ный серый
    AddConst('OrdRep', 'xlPatternGrid', xlPatternGrid); // Тонкая горизонтальная клетчатая
    AddConst('OrdRep', 'xlPatternHorizontal', xlPatternHorizontal); // Горизонтальная штриховка
    AddConst('OrdRep', 'xlPatternLightDown', xlPatternLightDown); // Тонкая диагональная штриховка вниз
    AddConst('OrdRep', 'xlPatternLightHorizontal', xlPatternLightHorizontal); // Тонкая горизонтальная штриховка
    AddConst('OrdRep', 'xlPatternLightUp', xlPatternLightUp); // Тонкая диагональная штриховка вверх
    AddConst('OrdRep', 'xlPatternLightVertical', xlPatternLightVertical); // Тонкая вертикальная штриховка
    AddConst('OrdRep', 'xlPatternNone', xlPatternNone); // Штриховка отсутствует
    AddConst('OrdRep', 'xlPatternSemiGray75', xlPatternSemiGray75); // Толстая диагональная клетчатая
    AddConst('OrdRep', 'xlPatternSolid', xlPatternSolid); // Сплошная штриховка
    AddConst('OrdRep', 'xlPatternUp', xlPatternUp); // Диагональная штриховка вверх
    AddConst('OrdRep', 'xlPatternVertical', xlPatternVertical); // Вертикальная штриховка

   // Ориентация надписи (может быть также целым числом от -90 до 90 градусов)
   // (XlOrientation)
    AddConst('OrdRep', 'xlDownward', xlDownward); // Надпись сверху вниз.
    AddConst('OrdRep', 'xlHorizontal', xlHorizontal); // Обычная горизонтальная надпись
    AddConst('OrdRep', 'xlUpward', xlUpward); // Надпись снизу вверх.
    AddConst('OrdRep', 'xlVertical', xlVertical); // Вертикальная надпись. Буквы пишутся одна под другой и располагаются горизонтально.

    AddConst('OrdRep', 'xlNoRestrictions', xlNoRestrictions); // Без всяких ограничений
    AddConst('OrdRep', 'xlUnlockedCells', xlUnlockedCells); // Можно выделять только незаблокированные ячейки
    AddConst('OrdRep', 'xlNoSelection', xlNoSelection); // Выделение ячеек на рабочем листе не разрешено

    // Ориентация страницы (XlPageOrientation)
    AddConst('OrdRep', 'xlPortrait', xlPortrait);   // Книжная
    AddConst('OrdRep', 'xlLandscape', xlLandscape);  // Альбомная

   // Способ отображения примечаний (XlCommentDisplayMode)
    AddConst('OrdRep', 'xlNoIndicator', xlNoIndicator);  // Не отображать
    AddConst('OrdRep', 'xlCommentIndicatorOnly', xlCommentIndicatorOnly); // Только индикатор
    AddConst('OrdRep', 'xlCommentAndIndicator', xlCommentAndIndicator); // Примечание и индикатор

    AddFunction('OrdRep', 'ShortDateFormat', RAI2_Read_ShortDateFormat, 0, [0], varEmpty);
    AddFunction('OrdRep', 'ShortDateFormat2', RAI2_Read_ShortDateFormat2, 0, [0], varEmpty);
    AddFunction('OrdRep', 'LongDateFormat', RAI2_Read_LongDateFormat, 0, [0], varEmpty);
    AddFunction('OrdRep', 'ShortTimeFormat', RAI2_Read_ShortTimeFormat, 0, [0], varEmpty);
    AddFunction('OrdRep', 'LongTimeFormat', RAI2_Read_LongTimeFormat, 0, [0], varEmpty);

    AddFunction('OrdRep', 'VarArrayCreate2D', RAI2_VarArrayCreate2D, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    {AddFunction('OrdRep', 'VarArrayRedim', RAI2_VarArrayRedim, 2, [varEmpty, varEmpty], varEmpty);
    AddFunction('OrdRep', 'VarArrayLowBound', RAI2_VarArrayLowBound, 2, [varEmpty, varEmpty], varEmpty);
    AddFunction('OrdRep', 'VarArrayHighBound', RAI2_VarArrayHighBound, 2, [varEmpty, varEmpty], varEmpty);}
    AddClass('OrdRep', TVarArray, 'TVarArray');
    AddIGet(TVarArray, 'Value', TVarArray_Read_Value, 2, [0], varEmpty);
    AddISet(TVarArray, 'Value', TVarArray_Write_Value, 2, [0]);
    AddIDGet(TVarArray, TVarArray_Read_Value, 2, [0], varEmpty);
    AddIDSet(TVarArray, TVarArray_Write_Value, 2, [0]);
    AddGet(TVarArray, 'Free', TVarArray_Free, 0, [0], varEmpty);

    // вообще-то это должно быть в jvInterpreter_ComCtrls, но ребята не добавили
    AddGet(TPageControl, 'ActivePage', TPageControl_Read_ActivePage, 0, [0], varEmpty);
    AddSet(TPageControl, 'ActivePage', TPageControl_Write_ActivePage, 0, [0]);
    AddGet(TPageControl, 'ActivePageIndex', TPageControl_Read_ActivePageIndex, 0, [0], varEmpty);
    AddSet(TPageControl, 'ActivePageIndex', TPageControl_Write_ActivePageIndex, 0, [0]);

    AddGet(TStringList, 'DelimitedText', TStringList_Read_DelimitedText, 0, [varEmpty], varEmpty);
    AddSet(TStringList, 'DelimitedText', TStringList_Write_DelimitedText, 0, [varEmpty]);
    AddGet(TStringList, 'Delimiter', TStringList_Read_Delimiter, 0, [varEmpty], varEmpty);
    AddSet(TStringList, 'Delimiter', TStringList_Write_Delimiter, 0, [varEmpty]);
    AddGet(TStringList, 'StrictDelimiter', TStringList_Read_StrictDelimiter, 0, [varEmpty], varEmpty);
    AddSet(TStringList, 'StrictDelimiter', TStringList_Write_StrictDelimiter, 0, [varEmpty]);

    // устаревшие - оставлены заглушки которые бросают исключение
    AddFunction('OrdRep', 'CalcOrderDataSource', RAI2_CalcOrderDataSource, 0, [0], varEmpty);
    AddFunction('OrdRep', 'WorkOrderDataSource', RAI2_WorkOrderDataSource, 0, [0], varEmpty);

    AddClass('PmEntity', TEntity, 'TEntity');
    AddGet(TEntity, 'DataSet', TEntity_Read_DataSet, 0, [0], varEmpty);
    AddGet(TEntity, 'KeyValue', TEntity_Read_KeyValue, 0, [0], varEmpty);
    AddGet(TEntity, 'Reload', TEntity_Reload, 0, [0], varEmpty);
    AddGet(TEntity, 'IsEmpty', TEntity_IsEmpty, 0, [0], varEmpty);
    AddGet(TEntity, 'Open', TEntity_Open, 0, [0], varEmpty);

    AddClass('PmInvoice', TInvoices, 'TInvoices');
    AddFunction('PmInvoice', 'Invoices', JvInterpreter_Invoices, 0, [0], varEmpty);
    AddGet(TInvoices, 'Create', TInvoices_Create, 0, [0], varEmpty);
    AddGet(TInvoices, 'InvoiceNum', TInvoices_Read_InvoiceNum, 0, [0], varEmpty);
    AddGet(TInvoices, 'InvoiceDate', TInvoices_Read_InvoiceDate, 0, [0], varEmpty);
    AddGet(TInvoices, 'CustomerID', TInvoices_Read_CustomerID, 0, [0], varEmpty);
    AddGet(TInvoices, 'Notes', TInvoices_Read_Notes, 0, [0], varEmpty);
    AddGet(TInvoices, 'CustomerName', TInvoices_Read_CustomerName, 0, [0], varEmpty);
    AddGet(TInvoices, 'CustomerFullName', TInvoices_Read_CustomerFullName, 0, [0], varEmpty);
    AddGet(TInvoices, 'InvoiceCost', TInvoices_Read_InvoiceCost, 0, [0], varEmpty);
    AddGet(TInvoices, 'PayType', TInvoices_Read_PayType, 0, [0], varEmpty);
    AddGet(TInvoices, 'PayTypeName', TInvoices_Read_PayTypeName, 0, [0], varEmpty);
    AddGet(TInvoices, 'Items', TInvoices_Read_Items, 0, [0], varEmpty);
    AddGet(TInvoices, 'InvoiceDebt', TInvoices_Read_InvoiceDebt, 0, [0], varEmpty);
    AddGet(TInvoices, 'InvoiceCredit', TInvoices_Read_InvoiceCredit, 0, [0], varEmpty);
    AddGet(TInvoices, 'Criteria', TInvoices_Read_Criteria, 0, [0], varEmpty);
    AddSet(TInvoices, 'Criteria', TInvoices_Write_Criteria, 0, [0]);

    AddClass('PmInvoice', TInvoicesFilterObj, 'TInvoicesFilterObj');
    AddGet(TInvoicesFilterObj, 'Create', TInvoicesFilterObj_Create, 0, [0], varEmpty);

    AddClass('PmInvoice', TInvoiceItems, 'TInvoiceItems');
    AddFunction('PmInvoice', 'InvoiceItems', JvInterpreter_InvoiceItems, 0, [0], varEmpty);
    AddGet(TInvoiceItems, 'OrderNumber', TInvoiceItems_Read_OrderNumber, 0, [0], varEmpty);
    AddGet(TInvoiceItems, 'CreationDate', TInvoiceItems_Read_CreationDate, 0, [0], varEmpty);
    AddGet(TInvoiceItems, 'OrderID', TInvoiceItems_Read_OrderID, 0, [0], varEmpty);
    AddGet(TInvoiceItems, 'ItemCost', TInvoiceItems_Read_ItemCost, 0, [0], varEmpty);
    AddGet(TInvoiceItems, 'ItemText', TInvoiceItems_Read_ItemText, 0, [0], varEmpty);
    AddGet(TInvoiceItems, 'Quantity', TInvoiceItems_Read_Quantity, 0, [0], varEmpty);
    AddGet(TInvoiceItems, 'CriteriaInvoiceID', TInvoiceItems_Read_CriteriaInvoiceID, 0, [0], varEmpty);
    AddSet(TInvoiceItems, 'CriteriaInvoiceID', TInvoiceItems_Write_CriteriaInvoiceID, 0, [0]);

    AddClass('PmInvoice', TOrderInvoiceItems, 'TOrderInvoiceItems');
    AddGet(TOrderInvoiceItems, 'CriteriaOrderID', TOrderInvoiceItems_Read_CriteriaOrderID, 0, [0], varEmpty);
    AddSet(TOrderInvoiceItems, 'CriteriaOrderID', TOrderInvoiceItems_Write_CriteriaOrderID, 0, [0]);
    AddGet(TOrderInvoiceItems, 'ItemCost', TOrderInvoiceItems_Read_ItemCost, 0, [0], varEmpty);
    AddGet(TOrderInvoiceItems, 'PayType', TOrderInvoiceItems_Read_PayType, 0, [0], varEmpty);
    AddGet(TOrderInvoiceItems, 'InvoiceNumber', TOrderInvoiceItems_Read_InvoiceNumber, 0, [0], varEmpty);
    AddGet(TOrderInvoiceItems, 'InvoiceDate', TOrderInvoiceItems_Read_InvoiceDate, 0, [0], varEmpty);

    AddClass('PmCustomerIncomes', TCustomerIncomes, 'TCustomerIncomes');
    AddFunction('PmCustomerIncomes', 'CustomerIncomes', JvInterpreter_CustomerIncomes, 0, [0], varEmpty);
    AddGet(TCustomerIncomes, 'Create', TCustomerIncomes_Create, 0, [0], varEmpty);
    AddGet(TCustomerIncomes, 'PayType', TCustomerIncomes_Read_PayType, 0, [0], varEmpty);
    AddGet(TCustomerIncomes, 'PayTypeName', TCustomerIncomes_Read_PayTypeName, 0, [0], varEmpty);
    AddGet(TCustomerIncomes, 'IncomeCost', TCustomerIncomes_Read_IncomeCost, 0, [0], varEmpty);
    AddGet(TCustomerIncomes, 'IncomeDate', TCustomerIncomes_Read_IncomeDate, 0, [0], varEmpty);
    AddGet(TCustomerIncomes, 'Comment', TCustomerIncomes_Read_Comment, 0, [0], varEmpty);
    AddGet(TCustomerIncomes, 'CustomerID', TCustomerIncomes_Read_CustomerID, 0, [0], varEmpty);
    AddGet(TCustomerIncomes, 'CustomerName', TCustomerIncomes_Read_CustomerName, 0, [0], varEmpty);
    AddGet(TCustomerIncomes, 'InvoiceID', TCustomerIncomes_Read_InvoiceID, 0, [0], varEmpty);
    AddGet(TCustomerIncomes, 'InvoiceNum', TCustomerIncomes_Read_InvoiceNum, 0, [0], varEmpty);
    AddGet(TCustomerIncomes, 'RestIncome', TCustomerIncomes_Read_RestIncome, 0, [0], varEmpty);
    AddGet(TCustomerIncomes, 'CriteriaInvoiceID', TCustomerIncomes_Read_CriteriaInvoiceID, 0, [0], varEmpty);
    AddSet(TCustomerIncomes, 'CriteriaInvoiceID', TCustomerIncomes_Write_CriteriaInvoiceID, 0, [0]);
    AddGet(TCustomerIncomes, 'Criteria', TCustomerIncomes_Read_Criteria, 0, [0], varEmpty);
    AddSet(TCustomerIncomes, 'Criteria', TCustomerIncomes_Write_Criteria, 0, [0]);
    //AddGet(TCustomerIncomes, 'CriteriaIncomeDate', TCustomerIncomes_Read_CriteriaDate, 0, [0], varEmpty);
    //AddSet(TCustomerIncomes, 'CriteriaIncomeDate', TCustomerIncomes_Write_CriteriaDate, 0, [0]);

    AddClass('PmCustomerIncomes', TPaymentsFilterObj, 'TPaymentsFilterObj');
    AddGet(TPaymentsFilterObj, 'Create', TPaymentsFilterObj_Create, 0, [0], varEmpty);

    AddClass('PmCustomerOrders', TCustomerOrders, 'TCustomerOrders');
    AddFunction('PmCustomerOrders', 'CustomerOrders', JvInterpreter_CustomerOrders, 0, [0], varEmpty);
    AddGet(TCustomerOrders, 'CustomerID', TCustomerOrders_Read_CustomerID, 0, [0], varEmpty);
    AddGet(TCustomerOrders, 'CustomerName', TCustomerOrders_Read_CustomerName, 0, [0], varEmpty);
    AddGet(TCustomerOrders, 'OrderNumber', TCustomerOrders_Read_OrderNumber, 0, [0], varEmpty);
    AddGet(TCustomerOrders, 'CreationDate', TCustomerOrders_Read_CreationDate, 0, [0], varEmpty);
    AddGet(TCustomerOrders, 'Comment', TCustomerOrders_Read_Comment, 0, [0], varEmpty);
    AddGet(TCustomerOrders, 'FinalCost', TCustomerOrders_Read_FinalCost, 0, [0], varEmpty);
    AddGet(TCustomerOrders, 'PayTotal', TCustomerOrders_Read_PayTotal, 0, [0], varEmpty);
    AddGet(TCustomerOrders, 'InvoiceTotal', TCustomerOrders_Read_InvoiceTotal, 0, [0], varEmpty);
    AddGet(TCustomerOrders, 'PayDebt', TCustomerOrders_Read_PayDebt, 0, [0], varEmpty);

    AddClass('PmOrderPayments', TOrderPayments, 'TOrderPayments');
    AddGet(TOrderPayments, 'Create', TOrderPayments_Create, 0, [0], varEmpty);
    AddGet(TOrderPayments, 'PayCost', TOrderPayments_Read_PayCost, 0, [0], varEmpty);
    AddGet(TOrderPayments, 'PayDate', TOrderPayments_Read_PayDate, 0, [0], varEmpty);
    AddGet(TOrderPayments, 'PayType', TOrderPayments_Read_PayType, 0, [0], varEmpty);
    AddGet(TOrderPayments, 'CriteriaOrderID', TOrderPayments_Read_CriteriaOrderID, 0, [0], varEmpty);
    AddSet(TOrderPayments, 'CriteriaOrderID', TOrderPayments_Write_CriteriaOrderID, 0, [0]);
    //AddFunction('PmOrderPayments', 'CustomerOrders', JvInterpreter_CustomerOrders, 0, [0], varEmpty);

    AddClass('PmShipment', TShipment, 'TShipment');
    AddFunction('PmShipment', 'Shipment', JvInterpreter_Shipment, 0, [0], varEmpty);
    AddGet(TShipment, 'QuantityToShip', TShipment_Read_QuantityToShip, 0, [0], varEmpty);
    AddGet(TShipment, 'TotalQuantity', TShipment_Read_TotalQuantity, 0, [0], varEmpty);
    AddGet(TShipment, 'CustomerName', TShipment_Read_CustomerName, 0, [0], varEmpty);
    AddGet(TShipment, 'OrderNumber', TShipment_Read_OrderNumber, 0, [0], varEmpty);
    AddGet(TShipment, 'ShipmentDate', TShipment_Read_ShipmentDate, 0, [0], varEmpty);
    AddGet(TShipment, 'ShipmentDocID', TShipment_Read_ShipmentDocID, 0, [0], varEmpty);
    AddGet(TShipment, 'OrderID', TShipment_Read_OrderID, 0, [0], varEmpty);
    AddGet(TShipment, 'Comment', TShipment_Read_Comment, 0, [0], varEmpty);
    AddGet(TShipment, 'ItemText', TShipment_Read_ItemText, 0, [0], varEmpty);
    AddGet(TShipment, 'WhoOut', TShipment_Read_WhoOut, 0, [0], varEmpty);
    AddGet(TShipment, 'WhoIn', TShipment_Read_WhoIn, 0, [0], varEmpty);
    AddGet(TShipment, 'BatchNum', TShipment_Read_BatchNum, 0, [0], varEmpty);
    AddGet(TShipment, 'IsTotal', TShipment_Read_IsTotal, 0, [0], varEmpty);
    AddGet(TShipment, 'IsFirstRow', TShipment_Read_IsFirstRow, 0, [0], varEmpty);
    AddGet(TShipment, 'Criteria', TShipment_Read_Criteria, 0, [0], varEmpty);

    AddClass('PmShipment', TShipmentFilterObj, 'TShipmentFilterObj');
    AddGet(TShipmentFilterObj, 'Create', TShipmentFilterObj_Create, 0, [0], varEmpty);

    AddFunction('PmShipment', 'OpenShipmentDetails', JvInterpreter_OpenShipmentDetails, 1, [varEmpty], varEmpty);

    AddClass('PmShipment', TShipmentDoc, 'TShipmentDoc');
    AddFunction('PmShipment', 'OpenShipmentDoc', JvInterpreter_OpenShipmentDoc, 1, [varEmpty], varEmpty);
    AddGet(TShipmentDoc, 'CustomerName', TShipmentDoc_Read_CustomerName, 0, [0], varEmpty);
    AddGet(TShipmentDoc, 'ShipmentDate', TShipmentDoc_Read_ShipmentDate, 0, [0], varEmpty);
    AddGet(TShipmentDoc, 'ShipmentDocNum', TShipmentDoc_Read_ShipmentDocNum, 0, [0], varEmpty);
    AddGet(TShipmentDoc, 'WhoOut', TShipmentDoc_Read_WhoOut, 0, [0], varEmpty);
    AddGet(TShipmentDoc, 'WhoIn', TShipmentDoc_Read_WhoIn, 0, [0], varEmpty);
    AddGet(TShipmentDoc, 'TrustSerie', TShipmentDoc_Read_TrustSerie, 0, [0], varEmpty);
    AddGet(TShipmentDoc, 'TrustNum', TShipmentDoc_Read_TrustNum, 0, [0], varEmpty);
    AddGet(TShipmentDoc, 'TrustDate', TShipmentDoc_Read_TrustDate, 0, [0], varEmpty);

    AddClass('PmOrderNotes', TOrderNotes, 'TOrderNotes');
    AddGet(TOrderNotes, 'Note', TOrderNotes_Read_Note, 0, [0], varEmpty);
    AddGet(TOrderNotes, 'UseTech', TOrderNotes_Read_UseTech, 0, [0], varEmpty);
    AddGet(TOrderNotes, 'UserName', TOrderNotes_Read_UserName, 0, [0], varEmpty);

    AddClass('PmOrder', TFilterObj, 'TFilterObj');
    AddGet(TFilterObj, 'MonthYearChecked', TFilterObj_Read_MonthYearChecked, 0, [0], varEmpty);
    AddSet(TFilterObj, 'MonthYearChecked', TFilterObj_Write_MonthYearChecked, 0, [0]);
    AddGet(TFilterObj, 'YearChecked', TFilterObj_Read_YearChecked, 0, [0], varEmpty);
    AddSet(TFilterObj, 'YearChecked', TFilterObj_Write_YearChecked, 0, [0]);
    AddGet(TFilterObj, 'MonthChecked', TFilterObj_Read_MonthChecked, 0, [0], varEmpty);
    AddSet(TFilterObj, 'MonthChecked', TFilterObj_Write_MonthChecked, 0, [0]);
    AddGet(TFilterObj, 'MonthValue', TFilterObj_Read_MonthValue, 0, [0], varEmpty);
    AddSet(TFilterObj, 'MonthValue', TFilterObj_Write_MonthValue, 0, [0]);
    AddGet(TFilterObj, 'YearValue', TFilterObj_Read_YearValue, 0, [0], varEmpty);
    AddSet(TFilterObj, 'YearValue', TFilterObj_Write_YearValue, 0, [0]);
    AddGet(TFilterObj, 'CreatorChecked', TFilterObj_Read_CreatorChecked, 0, [0], varEmpty);
    AddSet(TFilterObj, 'CreatorChecked', TFilterObj_Write_CreatorChecked, 0, [0]);
    AddGet(TFilterObj, 'CreatorName', TFilterObj_Read_CreatorName, 0, [0], varEmpty);
    AddSet(TFilterObj, 'CreatorName', TFilterObj_Write_CreatorName, 0, [0]);
    AddGet(TFilterObj, 'DayChecked', TFilterObj_Read_DayChecked, 0, [0], varEmpty);
    AddSet(TFilterObj, 'DayChecked', TFilterObj_Write_DayChecked, 0, [0]);

    AddClass('PmOrder', TOrderFilterObj, 'TOrderFilterObj');
    AddGet(TOrderFilterObj, 'Create', TOrderFilterObj_Create, 0, [0], varEmpty);

    AddClass('PmOrder', TOrder, 'TOrder');
    AddFunction('PmOrder', 'Order', JvInterpreter_Order, 0, [0], varEmpty);
    AddGet(TOrder, 'Criteria', TOrder_Read_Criteria, 0, [0], varEmpty);
    AddSet(TOrder, 'Criteria', TOrder_Write_Criteria, 0, [0]);
    AddGet(TOrder, 'CostProtected', TOrder_Read_CostProtected, 0, [0], varEmpty);
    AddGet(TOrder, 'ContentProtected', TOrder_Read_ContentProtected, 0, [0], varEmpty);
    AddGet(TOrder, 'CallCustomer', TOrder_Read_CallCustomer, 0, [0], varEmpty);
    AddGet(TOrder, 'CallCustomerPhone', TOrder_Read_CallCustomerPhone, 0, [0], varEmpty);
    AddGet(TOrder, 'ProductFormat', TOrder_Read_ProductFormat, 0, [0], varEmpty);
    AddGet(TOrder, 'ProductPages', TOrder_Read_ProductPages, 0, [0], varEmpty);
    AddGet(TOrder, 'HaveLayout', TOrder_Read_HaveLayout, 0, [0], varEmpty);
    AddGet(TOrder, 'HavePattern', TOrder_Read_HavePattern, 0, [0], varEmpty);
    AddGet(TOrder, 'SignManager', TOrder_Read_SignManager, 0, [0], varEmpty);
    AddGet(TOrder, 'SignProof', TOrder_Read_SignProof, 0, [0], varEmpty);
    AddGet(TOrder, 'HaveProof', TOrder_Read_HaveProof, 0, [0], varEmpty);
    AddGet(TOrder, 'IncludeCover', TOrder_Read_IncludeCover, 0, [0], varEmpty);
    AddGet(TOrder, 'IsComposite', TOrder_Read_IsComposite, 0, [0], varEmpty);
    AddGet(TOrder, 'CreationDate', TOrder_Read_CreationDate, 0, [0], varEmpty);
    AddGet(TOrder, 'Notes', TOrder_Read_Notes, 0, [0], varEmpty);
    AddGet(TOrder, 'FetchAllData', RAI2_FetchAllCurrentData, 0, [0], varEmpty);
    AddGet(TOrder, 'FetchAllReportData', TOrder_FetchAllReportData, 0, [0], varEmpty);
    AddGet(TOrder, 'TotalExpenseCost', TOrder_Read_TotalExpenseCost, 0, [0], varEmpty);
    AddGet(TOrder, 'FinalCostNative', TOrder_Read_FinalCostNative, 0, [0], varEmpty);
    AddGet(TOrder, 'WriteEvent', TOrder_WriteEvent, 2, [varEmpty, varEmpty], varEmpty);
    AddConst('OrdRep', 'Event_Info', GlobalHistory_Info);
    AddConst('OrdRep', 'Event_Warning', GlobalHistory_Warn);
    AddConst('OrdRep', 'Event_Error', GlobalHistory_Error);
    AddConst('OrdRep', 'Event_Fail', GlobalHistory_Fail);
    AddConst('OrdRep', 'Event_Debug', GlobalHistory_Debug);

    AddClass('PmOrder', TDraftOrder, 'TDraftOrder');
    AddGet(TDraftOrder, 'Create', TDraftOrder_Create, 0, [0], varEmpty);

    AddFunction('OrdRep', 'OrderInvoiceItems', RAI2_OrderInvoiceItems, 0, [0], varEmpty);
    AddFunction('OrdRep', 'OrderPayments', RAI2_OrderPayments, 0, [0], varEmpty);
    AddFunction('OrdRep', 'OrderShipment', RAI2_OrderShipment, 0, [0], varEmpty);

    AddClass('PmDocument', TDocument, 'TDocument');
    AddGet(TDocument, 'DocNum', TDocument_Read_DocNum, 0, [0], varEmpty);
    AddGet(TDocument, 'DocDate', TDocument_Read_DocDate, 0, [0], varEmpty);
    AddGet(TDocument, 'Items', TDocument_Read_Items, 0, [0], varEmpty);
    AddGet(TDocument, 'ContragentID', TDocument_Read_ContragentID, 0, [0], varEmpty);
    AddGet(TDocument, 'PayType', TDocument_Read_PayType, 0, [0], varEmpty);

    AddClass('PmSale', TSaleDocs, 'TSaleDocs');
    AddFunction('PmSale', 'SaleDocs', JvInterpreter_SaleDocs, 0, [0], varEmpty);
    AddGet(TSaleDocs, 'Create', TSaleDocs_Create, 0, [0], varEmpty);
    AddGet(TSaleDocs, 'Criteria', TSaleDocs_Read_Criteria, 0, [0], varEmpty);
    AddSet(TSaleDocs, 'Criteria', TSaleDocs_Write_Criteria, 0, [0]);
    AddGet(TSaleDocs, 'SaleCost', TSaleDocs_Read_SaleCost, 0, [0], varEmpty);
    //AddGet(TSaleDocs, 'Notes', TSaleDocs_Read_Notes, 0, [0], varEmpty);
    AddGet(TSaleDocs, 'CustomerName', TSaleDocs_Read_CustomerName, 0, [0], varEmpty);
    //AddGet(TSaleDocs, 'InvoiceCost', TSaleDocs_Read_InvoiceCost, 0, [0], varEmpty);

    AddClass('PmSale', TSaleItems, 'TSaleItems');
    //AddFunction('PmSale', 'SaleItems', JvInterpreter_InvoiceItems, 0, [0], varEmpty);
    AddGet(TSaleItems, 'ItemCost', TSaleItems_Read_ItemCost, 0, [0], varEmpty);
    AddGet(TSaleItems, 'SaleCost', TSaleItems_Read_SaleCost, 0, [0], varEmpty);
    AddGet(TSaleItems, 'ItemText', TSaleItems_Read_ItemText, 0, [0], varEmpty);
    AddGet(TSaleItems, 'SaleQuantity', TSaleItems_Read_SaleQuantity, 0, [0], varEmpty);

    AddClass('PmMatRequest', TMaterialRequests, 'TMaterialRequests');
    AddFunction('PmMatRequest', 'MaterialRequests', JvInterpreter_MaterialRequests, 0, [0], varEmpty);
    AddGet(TMaterialRequests, 'Create', TMaterialRequests_Create, 0, [0], varEmpty);
    AddGet(TMaterialRequests, 'Criteria', TMaterialRequests_Read_Criteria, 0, [0], varEmpty);
    AddSet(TMaterialRequests, 'Criteria', TMaterialRequests_Write_Criteria, 0, [0]);
    AddGet(TMaterialRequests, 'OrderNumber', TMaterialRequests_Read_OrderNumber, 0, [0], varEmpty);
    AddGet(TMaterialRequests, 'CustomerName', TMaterialRequests_Read_CustomerName, 0, [0], varEmpty);
    AddGet(TMaterialRequests, 'SupplierName', TMaterialRequests_Read_SupplierName, 0, [0], varEmpty);
    AddGet(TMaterialRequests, 'MatDesc', TMaterialRequests_Read_MatDesc, 0, [0], varEmpty);
    AddGet(TMaterialRequests, 'Param1', TMaterialRequests_Read_Param1, 0, [0], varEmpty);
    AddGet(TMaterialRequests, 'Param2', TMaterialRequests_Read_Param2, 0, [0], varEmpty);
    AddGet(TMaterialRequests, 'Param3', TMaterialRequests_Read_Param3, 0, [0], varEmpty);
    AddGet(TMaterialRequests, 'MatAmount', TMaterialRequests_Read_MatAmount, 0, [0], varEmpty);
    AddGet(TMaterialRequests, 'FactParam1', TMaterialRequests_Read_FactParam1, 0, [0], varEmpty);
    AddGet(TMaterialRequests, 'FactParam2', TMaterialRequests_Read_FactParam2, 0, [0], varEmpty);
    AddGet(TMaterialRequests, 'FactParam3', TMaterialRequests_Read_FactParam3, 0, [0], varEmpty);
    AddGet(TMaterialRequests, 'FactMatAmount', TMaterialRequests_Read_FactMatAmount, 0, [0], varEmpty);
    AddGet(TMaterialRequests, 'FactReceiveDate', TMaterialRequests_Read_FactReceiveDate, 0, [0], varEmpty);
    AddGet(TMaterialRequests, 'PlanReceiveDate', TMaterialRequests_Read_PlanReceiveDate, 0, [0], varEmpty);

    AddClass('PmSchedule', TProcessEntity, 'TProcessEntity');
    AddGet(TProcessEntity, 'EquipGroupCode', TProcessEntity_EquipGroupCode, 0, [0], varEmpty);
    AddGet(TProcessEntity, 'ExecState', TProcessEntity_ExecState, 0, [0], varEmpty);
    AddGet(TProcessEntity, 'ItemDesc', TProcessEntity_ItemDesc, 0, [0], varEmpty);
    AddGet(TProcessEntity, 'Comment', TProcessEntity_Comment, 0, [0], varEmpty);
    AddGet(TProcessEntity, 'OrderNumber', TProcessEntity_OrderNumber, 0, [0], varEmpty);
    AddGet(TProcessEntity, 'OrderState', TProcessEntity_OrderState, 0, [0], varEmpty);
    AddGet(TProcessEntity, 'ItemID', TProcessEntity_ItemID, 0, [0], varEmpty);
    AddGet(TProcessEntity, 'JobID', TProcessEntity_JobID, 0, [0], varEmpty);
    AddGet(TProcessEntity, 'Part', TProcessEntity_Part, 0, [0], varEmpty);
    AddGet(TProcessEntity, 'ProcessID', TProcessEntity_ProcessID, 0, [0], varEmpty);
    // количество листов
    AddGet(TProcessEntity, 'Multiplier', TProcessEntity_Multiplier, 0, [0], varEmpty);
    // количество сторон
    AddGet(TProcessEntity, 'SideCount', TProcessEntity_SideCount, 0, [0], varEmpty);
    AddGet(TProcessEntity, 'EstimatedDuration', TProcessEntity_EstimatedDuration, 0, [0], varEmpty);
    AddGet(TProcessEntity, 'OrderID', TProcessEntity_OrderID, 0, [0], varEmpty);
    AddGet(TProcessEntity, 'PartName', TProcessEntity_PartName, 0, [0], varEmpty);

    AddClass('PmSchedule', TPlan, 'TScheduleQueue');
    AddFunction('PmSchedule', 'ScheduleQueue', JvInterpreter_ScheduleQueue, 0, [0], varEmpty);
    AddGet(TPlan, 'EquipCode', TScheduleQueue_EquipCode, 0, [0], varEmpty);
    // Признак есть ли комментарий к работе (JobComment)
    AddGet(TPlan, 'HasComment', TScheduleQueue_HasComment, 0, [0], varEmpty);
    // Признак есть ли технологические примечания к заказу
    AddGet(TPlan, 'HasTechNotes', TScheduleQueue_HasTechNotes, 0, [0], varEmpty);
    AddGet(TPlan, 'JobComment', TScheduleQueue_JobComment, 0, [0], varEmpty);

    AddClass('PmSchedule', TWorkload, 'TWorkload');
    AddFunction('PmSchedule', 'Workload', JvInterpreter_Workload, 0, [0], varEmpty);
    AddGet(TWorkload, 'ShiftForemanName', TWorkload_ShiftForemanName, 0, [0], varEmpty);
    AddGet(TWorkload, 'OperatorName', TWorkload_OperatorName, 0, [0], varEmpty);
  end;
end;

initialization
  {ExcelReportLauncher := TBaseReportLauncher.Create;}

finalization
  ToggleScrollLockOff;   // Выключение режима ScrollLock
  //FreeAndNil(ExcelReportLauncher);
  FreeAndNil(Rpt);       // Освобождение экземпляра объекта
end.
