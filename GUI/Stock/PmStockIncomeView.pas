unit PmStockIncomeView;

interface

uses Classes, Controls, Forms, SysUtils, JvAppStorage, Dialogs, ExtCtrls,
  JvSpeedBar,

  NotifyEvent, fBaseFrame, PmEntity, PmEntityController, fStockIncomeFrame, PmStockIncome,
  fStockIncomeToolbar, PmDocumentView, PmDocController, MainFilter;

type
  TStockIncomeView = class(TDocumentView)
  private
    FToolbarFrame: TStockIncomeToolbarFrame;
    function GetFrame: TStockIncomeFrame;
    function GetStockIncome: TStockIncome;
  protected
    function GetControllerClass: TDocControllerClass; override;
    function GetFilterClass: TFilterClass; override;
    function GetEditAction: string; override;
    function GetNewAction: string; override;
    function GetDeleteAction: string; override;
    function GetPrintFormAction: string; override;
    function GetPrintReportAction: string; override;
    function GetFormScriptID: string; override;
    function GetFrameClass: TBaseFrameClass; override;
  public
    constructor Create(_Entity: TEntity); override;
    function GetToolbar: TjvSpeedbar; override;
    
    property Frame: TStockIncomeFrame read GetFrame;
    property StockIncome: TStockIncome read GetStockIncome;
  end;

implementation

uses Variants, DB, DateUtils,

  CalcUtils, RDialogs, PmDatabase, PmAppController,
  DicObj, StdDic, RDBUtils, CalcSettings, PmActions, PmScriptManager,
  PmStockIncomeDocController;

constructor TStockIncomeView.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  FCaption := 'Приход материалов';
end;

function TStockIncomeView.GetFrame: TStockIncomeFrame;
begin
  Result := TStockIncomeFrame(FFrame);
end;

function TStockIncomeView.GetStockIncome: TStockIncome;
begin
  Result := Entity as TStockIncome;
end;

function TStockIncomeView.GetEditAction: string;
begin
  Result := TStockIncomeActions.Edit;
end;

function TStockIncomeView.GetNewAction: string;
begin
  Result := TStockIncomeActions.New;
end;

function TStockIncomeView.GetDeleteAction: string;
begin
  Result := TStockIncomeActions.Delete;
end;

function TStockIncomeView.GetPrintFormAction: string;
begin
  Result := TStockIncomeActions.PrintForm;
end;

function TStockIncomeView.GetPrintReportAction: string;
begin
  Result := TStockIncomeActions.PrintReport;
end;

function TStockIncomeView.GetFormScriptID: string;
begin
  Result := TScriptManager.PrintStockIncomeForm;
end;

function TStockIncomeView.GetToolbar: TjvSpeedbar;
begin
  if FToolbarFrame = nil then
    FToolbarFrame := TStockIncomeToolbarFrame.Create(nil);
  Result := FToolbarFrame.Toolbar;
end;

function TStockIncomeView.GetFrameClass: TBaseFrameClass;
begin
  Result := TStockIncomeFrame;
end;

function TStockIncomeView.GetControllerClass: TDocControllerClass;
begin
  Result := TStockIncomeDocController;
end;

function TStockIncomeView.GetFilterClass: TFilterClass;
begin
  Result := TStockIncomeFilterObj;
end;

end.
