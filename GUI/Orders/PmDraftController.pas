unit PmDraftController;

interface

uses Classes, SysUtils, Forms, Dialogs, Controls, JvSpeedbar,

  RDialogs, PmOrderController, PmProviders, PmEntity, fOrdersFrame,
  fDraftListToolbar, fOrderListToolbar;

type
  TDraftController = class(TOrderController)
  protected
    FToolbarFrame: TOrderListToolbar;
    function GetCostVisible: boolean; override;
    function GetFrameClass: TOrdersFrameClass; override;
    procedure UpdateActionState; override;
    procedure UpdateUSDCourse; override;
  public
    constructor Create(_Entity: TEntity);
    function Visible: boolean; override;
    function MakeOrder(ParamsProvider: IMakeOrderParamsProvider; var NewId: integer): boolean;
    procedure Activate; override;
    function GetToolbar: TjvSpeedbar; override;
  end;

implementation

uses Variants, DB, ExHandler,

  PmAccessManager, CalcUtils, CalcSettings, MainData, PmDatabase, ServMod, fDraftOrdersFrame,
  PmActions;

constructor TDraftController.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  //TMainActions.GetAction(TOrderActions.MakeWork).OnExecute := acMakeOrderExecute;
end;

function TDraftController.Visible: boolean;
begin
  Result := AccessManager.CurUser.DraftVisible;
end;

function TDraftController.GetCostVisible: boolean;
begin
  Result := not VarIsNull(Order.KindID) and IntInArray(Order.KindID, AllDraftCostViewKindValues);
end;

// Создание нового заказа из расчета
function TDraftController.MakeOrder(ParamsProvider: IMakeOrderParamsProvider; var NewId: integer): boolean;
var
  FinDate: variant;
  Res: integer;
  Applied: boolean;
begin
  Result := false;
  ParamsProvider.CreateForm;
  if not Order.DataSet.Active or Order.DataSet.IsEmpty then Exit;
  Applied := false;
  repeat
    Res := ParamsProvider.Execute;
    if Res = mrOk then
    begin
      dm.aspChangeOrderStatus.Parameters.ParamByName('@Src').Value := Order.KeyValue;
      dm.aspChangeOrderStatus.Parameters.ParamByName('@Course').Value := Order.Processes.USDCourse;
      dm.aspChangeOrderStatus.Parameters.ParamByName('@TotalGrn').Value := Order.DataSet['TotalGrn'];
      dm.aspChangeOrderStatus.Parameters.ParamByName('@IncludeAdv').Value := false;//ParamsProvider.IncludeAdv;
      dm.aspChangeOrderStatus.Parameters.ParamByName('@OrderState').Value := ParamsProvider.OrderState;
      dm.aspChangeOrderStatus.Parameters.ParamByName('@RowColor').Value := ParamsProvider.RowColor;
      // берем параметры из CalcOrder, потом изменения будут отменены
      dm.aspChangeOrderStatus.Parameters.ParamByName('@ID_Kind').Value := Order.DataSet['ID_Kind'];
      dm.aspChangeOrderStatus.Parameters.ParamByName('@ID_Char').Value := Order.DataSet['ID_Char'];
      dm.aspChangeOrderStatus.Parameters.ParamByName('@ID_Color').Value := Order.DataSet['ID_Color'];
      dm.aspChangeOrderStatus.Parameters.ParamByName('@Lock').Value := 1;
      dm.aspChangeOrderStatus.Parameters.ParamByName('@FinishDate').Value := ParamsProvider.FinishDate;
      dm.aspChangeOrderStatus.Parameters.ParamByName('@PayState').Value := ParamsProvider.PayState;
      dm.aspChangeOrderStatus.Parameters.ParamByName('@MakeCopy').Value := ParamsProvider.CopyToWork;
      if not Database.InTransaction then Database.BeginTrans;
      try
        dm.aspChangeOrderStatus.ExecProc;
        NewId := dm.aspChangeOrderStatus.Parameters[0].Value;    // destination key
        if NewId < 0 then
        begin
          Database.RollbackTrans;
          dm.ShowProcErrorMessage(NewId);       // Не получилось
          Exit;
        end
        else
        begin
          Database.CommitTrans;
          Applied := true;
          Result := true;
        end;
      except on E: EDatabaseError do
      begin
        Database.RollbackTrans;
        ExceptionHandler.Raise_(E);
        Exit;
      end;
      on EConvertError do begin
        Database.RollbackTrans;
        RusMessageDlg('Неправильно введены данные', mtError, [mbOk], 0);
        Exit;
      end;
      on Exception do
      begin
        Database.RollbackTrans;
        raise;
      end;
      end;
      //  if SendOrder then SendNotif(WorkOrderNotif); // Посылаем всем сообщение, что надо перечитать заказы
    end;
  until Applied or (Res = mrCancel);
end;

function TDraftController.GetToolbar: TjvSpeedbar;
begin
  if FToolbarFrame = nil then
    FToolbarFrame := TDraftOrderListToolbar.Create(nil);
  Result := FToolbarFrame.Toolbar;
end;

procedure TDraftController.Activate;
begin
  inherited;
end;

procedure TDraftController.UpdateActionState;
begin
  inherited;
  TMainActions.GetAction(TOrderActions.MakeDraft).Enabled := false;
  TMainActions.GetAction(TOrderActions.MakeInvoice).Enabled := false;
  TMainActions.GetAction(TOrderActions.MakeWork).Enabled := (ViewMode = vmLeft)
    and AccessManager.CurUser.WorkVisible;
end;

function TDraftController.GetFrameClass: TOrdersFrameClass;
begin
  Result := TDraftOrdersFrame;
end;

procedure TDraftController.UpdateUSDCourse;
begin
  Order.Processes.USDCourse := TSettingsManager.Instance.AppCourse;
end;

end.
