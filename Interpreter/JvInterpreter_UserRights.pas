unit JvInterpreter_UserRights;

interface

uses JvInterpreter, PmAccessManager;

procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);

implementation

// Описание интерфейса к правам пользвателя для текущего вида заказа.

type
  TCurKindPermClass = class(TObject)
  end;

var
  CurKindPermObj: TCurKindPermClass;

procedure RAI2_CurKindPerm(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(CurKindPermObj);
end;

procedure TCurKindPerm_CreateNew(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := AccessManager.CurKindPerm.CreateNew;
end;

procedure TCurKindPerm_Update(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := AccessManager.CurKindPerm.Update;
end;

procedure TCurKindPerm_Delete(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := AccessManager.CurKindPerm.Delete;
end;

procedure TCurKindPerm_Browse(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := AccessManager.CurKindPerm.Browse;
end;

procedure TCurKindPerm_PriceView(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := AccessManager.CurKindPerm.PriceView;
end;

procedure TCurKindPerm_CostView(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := AccessManager.CurKindPerm.CostView;
end;

procedure TCurKindPerm_CheckOnSave(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := AccessManager.CurKindPerm.CheckOnSave;
end;

procedure TCurKindPerm_PlanFinishDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := AccessManager.CurKindPerm.PlanFinishDate;
end;

procedure TCurKindPerm_PlanStartDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := AccessManager.CurKindPerm.PlanStartDate;
end;

procedure TCurKindPerm_FactStartDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := AccessManager.CurKindPerm.FactStartDate;
end;

procedure TCurKindPerm_FactFinishDate(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := AccessManager.CurKindPerm.FactFinishDate;
end;

procedure TCurKindPerm_ShowProfitPreview(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := AccessManager.CurKindPerm.ShowProfitPreview;
end;

procedure TCurKindPerm_ShowProfitInside(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := AccessManager.CurKindPerm.ShowProfitInside;
end;

procedure TCurKindPerm_ModifyProfit(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := AccessManager.CurKindPerm.ModifyProfit;
end;

procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);
begin
  with JvInterpreterAdapter do
  begin
    { TCurKindPerm }
    AddClass('UserRights', TCurKindPermClass, 'TCurKindPerm');
    AddGet(TCurKindPermClass, 'CreateNew', TCurKindPerm_CreateNew, 0, [0], varEmpty);
    AddGet(TCurKindPermClass, 'Update', TCurKindPerm_Update, 0, [0], varEmpty);
    AddGet(TCurKindPermClass, 'Delete', TCurKindPerm_Delete, 0, [0], varEmpty);
    AddGet(TCurKindPermClass, 'Browse', TCurKindPerm_Browse, 0, [0], varEmpty);
    AddGet(TCurKindPermClass, 'PriceView', TCurKindPerm_PriceView, 0, [0], varEmpty);
    AddGet(TCurKindPermClass, 'CostView', TCurKindPerm_CostView, 0, [0], varEmpty);
    AddGet(TCurKindPermClass, 'CheckOnSave', TCurKindPerm_CheckOnSave, 0, [0], varEmpty);
    AddGet(TCurKindPermClass, 'PlanFinishDate', TCurKindPerm_PlanFinishDate, 0, [0], varEmpty);
    AddGet(TCurKindPermClass, 'PlanStartDate', TCurKindPerm_PlanStartDate, 0, [0], varEmpty);
    AddGet(TCurKindPermClass, 'FactStartDate', TCurKindPerm_FactStartDate, 0, [0], varEmpty);
    AddGet(TCurKindPermClass, 'FactFinishDate', TCurKindPerm_FactFinishDate, 0, [0], varEmpty);
    AddGet(TCurKindPermClass, 'ShowProfitPreview', TCurKindPerm_ShowProfitPreview, 0, [0], varEmpty);
    AddGet(TCurKindPermClass, 'ShowProfitInside', TCurKindPerm_ShowProfitInside, 0, [0], varEmpty);
    AddGet(TCurKindPermClass, 'ModifyProfit', TCurKindPerm_ModifyProfit, 0, [0], varEmpty);
    AddFunction('UserRights', 'CurKindPerm', RAI2_CurKindPerm, 0, [0], varEmpty);
  end;
end;

initialization

CurKindPermObj := TCurKindPermClass.Create;

finalization

CurKindPermObj.Free;

end.
 