unit PmStockWasteView;

interface

uses Classes, Controls, Forms, SysUtils, JvAppStorage, Dialogs, ExtCtrls,
  JvSpeedBar,

  NotifyEvent, fBaseFrame, PmEntity, PmEntityController, fStockWasteFrame, PmStockWaste,
  fStockWasteToolbar, PmDocumentView, PmDocController, MainFilter;

type
  TStockWasteView = class(TDocumentView)
  private
    FToolbarFrame: TStockWasteToolbarFrame;
    function GetFrame: TStockWasteFrame;
    function GetStockWaste: TStockWaste;
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
    //destructor Destroy; override;
    //function Visible: boolean; override;
    //procedure Activate; override;
    //procedure RefreshData; override;
    function GetToolbar: TjvSpeedbar; override;
    property Frame: TStockWasteFrame read GetFrame;
    property StockWaste: TStockWaste read GetStockWaste;
  end;

implementation

uses Variants, DB, DateUtils,

  CalcUtils, RDialogs, PmDatabase, PmAppController,
  DicObj, StdDic, RDBUtils, 
  CalcSettings, PmActions, PmScriptManager, PmStockWasteDocController;

constructor TStockWasteView.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  FCaption := 'Расход материалов';
end;
{
destructor TStockWasteView.Destroy;
begin
  inherited;
end;

function TStockWasteView.Visible: boolean;
begin
  Result := true;
end;

function TStockWasteView.CreateFrame(Owner: TComponent): TBaseFrame;
begin
  FFrame := TStockWasteFrame.Create(Owner, StockWaste);
  Result := FFrame;
end;
      }
function TStockWasteView.GetFrame: TStockWasteFrame;
begin
  Result := TStockWasteFrame(FFrame);
end;

{procedure TStockWasteView.RefreshData;
begin
  inherited;
  //MatRequest.Reload;
end;}

function TStockWasteView.GetStockWaste: TStockWaste;
begin
  Result := Entity as TStockWaste;
end;

function TStockWasteView.GetToolbar: TjvSpeedbar;
begin
  if FToolbarFrame = nil then
    FToolbarFrame := TStockWasteToolbarFrame.Create(nil);
  Result := FToolbarFrame.Toolbar;
end;

function TStockWasteView.GetEditAction: string;
begin
  Result := TStockWasteActions.Edit;
end;

function TStockWasteView.GetNewAction: string;
begin
  Result := TStockWasteActions.New;
end;

function TStockWasteView.GetDeleteAction: string;
begin
  Result := TStockWasteActions.Delete;
end;

function TStockWasteView.GetPrintFormAction: string;
begin
  Result := TStockWasteActions.PrintForm;
end;

function TStockWasteView.GetPrintReportAction: string;
begin
  Result := TStockWasteActions.PrintReport;
end;

function TStockWasteView.GetFormScriptID: string;
begin
  Result := TScriptManager.PrintStockWasteForm;
end;

function TStockWasteView.GetFrameClass: TBaseFrameClass;
begin
  Result := TStockWasteFrame;
end;

function TStockWasteView.GetControllerClass: TDocControllerClass;
begin
  Result := TStockWasteDocController;
end;

function TStockWasteView.GetFilterClass: TFilterClass;
begin
  Result := TStockWasteFilterObj;
end;

end.
