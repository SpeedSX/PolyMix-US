unit PmDocumentView;

interface

uses Classes, Controls, Forms, SysUtils, JvAppStorage, Dialogs, ExtCtrls,
  JvSpeedBar,

  NotifyEvent, fBaseFrame, fBaseToolbar, PmEntity, PmEntityController,
  PmCustomerOrders, PmDocController, PmDocument, MainFilter;

type
  TDocumentView = class(TEntityController)
  private
    FToolbarFrame: TBaseToolbarFrame;
    function GetDocs: TDocument;
    procedure FilterChange;
    procedure DisableFilter;
    procedure DoNewDoc(Sender: TObject);
    procedure DoDeleteDoc(Sender: TObject);
    procedure DoEditDoc(Sender: TObject);
    procedure DoPrintReport(Sender: TObject);
    procedure DoPrintForm(Sender: TObject);
    procedure NewDoc(CurCustomer: integer);
    function CreateController: TDocController;
  protected
    function GetControllerClass: TDocControllerClass; virtual; abstract;
    function GetFilterClass: TFilterClass; virtual; abstract;
    function GetEditAction: string; virtual; abstract;
    function GetNewAction: string; virtual; abstract;
    function GetDeleteAction: string; virtual; abstract;
    function GetPrintFormAction: string; virtual; abstract;
    function GetPrintReportAction: string; virtual; abstract;
    function GetFrameClass: TBaseFrameClass; virtual; abstract;
    function GetFormScriptID: string; virtual; abstract;
    function GetReportScriptID: string; virtual; abstract;
  public
    constructor Create(_Entity: TEntity); override;
    destructor Destroy; override;
    function Visible: boolean; override;
    procedure EditCurrent;
    procedure DeleteCurrent(Confirm: boolean);
    function CreateFrame(Owner: TComponent): TBaseFrame; override;
    procedure Activate; override;
    procedure RefreshData; override;

    property Frame: TBaseFrame read FFrame;
    property Document: TDocument read GetDocs;
  end;

implementation

uses Variants, DB, DateUtils,

  CalcUtils, RDialogs, PmDatabase, PmAppController,
  DicObj, StdDic, RDBUtils,
  CalcSettings, PmActions, PmScriptManager;

constructor TDocumentView.Create(_Entity: TEntity);
begin
  inherited Create(_Entity);
  FFilter := GetFilterClass.Create;
  Document.Criteria := FFilter;
  FFilter.RestoreFilter(TSettingsManager.Instance.Storage, iniFilter + FEntity.InternalName);
  FCaption := 'Реализация';

  TMainActions.GetAction(GetEditAction).OnExecute := DoEditDoc;
  TMainActions.GetAction(GetNewAction).OnExecute := DoNewDoc;
  TMainActions.GetAction(GetDeleteAction).OnExecute := DoDeleteDoc;
  //TMainActions.GetAction(TShipmentActions.PrintReport).OnExecute := DoPrintShipmentReport;
  TMainActions.GetAction(GetPrintFormAction).OnExecute := DoPrintForm;
  TMainActions.GetAction(GetPrintReportAction).OnExecute := DoPrintReport;
  //TMainActions.GetAction(TShipmentActions.OpenOrder).OnExecute := DoOpenOrder;
end;

destructor TDocumentView.Destroy;
begin
  inherited;
end;

function TDocumentView.Visible: boolean;
begin
  Result := true;
end;

procedure TDocumentView.DeleteCurrent(Confirm: boolean);
var
  //CurKey, NextKey: variant;
  OK: boolean;
begin
  if not Document.IsEmpty then
  begin
    if Confirm then
      OK := RusMessageDlg('Удалить документ?', mtConfirmation, mbYesNoCancel, 0) = mrYes
    else
      OK := true;

    if OK then
    begin
      Document.DeleteAndApply;
    end;
  end;
end;

function TDocumentView.CreateFrame(Owner: TComponent): TBaseFrame;
begin
  FFrame := GetFrameClass.Create(Owner, Document);

  FFrame.OnFilterChange := FilterChange;
  FFrame.OnDisableFilter := DisableFilter;
  FFrame.OnHideFilter := AppController.HideFilter;

  Result := FFrame;
end;

procedure TDocumentView.Activate;
var
  Save_Cursor: TCursor;
begin
  // не обновлять если уже открыт
  if not FEntity.DataSet.Active then
  begin
    Save_Cursor := Screen.Cursor;
    Screen.Cursor := crSQLWait;
    try
      FEntity.Reload;
    finally
      Screen.Cursor := Save_Cursor;  { Always restore to normal }
    end;
  end;
end;

{procedure TSaleView.LoadSettings(AppStorage: TjvCustomAppStorage);
begin
  inherited LoadSettings(AppStorage);
  if FFrame <> nil then // на всякий аварийный
    TSaleFrame(FFrame).LoadSettings;
end;

procedure TSaleView.SaveSettings(AppStorage: TjvCustomAppStorage);
begin
  inherited SaveSettings(AppStorage); // сохраняет фильтр!
  if FFrame <> nil then // на всякий аварийный
    TSaleFrame(FFrame).SaveSettings;
end;}

procedure TDocumentView.RefreshData;
begin
  inherited;
  //Shipment.Reload;
end;

function TDocumentView.GetDocs: TDocument;
begin
  Result := Entity as TDocument;
end;

procedure TDocumentView.FilterChange;
begin
  RefreshData;
end;

procedure TDocumentView.DisableFilter;
begin

end;

procedure TDocumentView.DoNewDoc(Sender: TObject);
begin
  NewDoc(0);
end;

function TDocumentView.CreateController: TDocController;
begin
  Result := GetControllerClass.Create;
  Result.Document := Document;
end;

procedure TDocumentView.NewDoc(CurCustomer: integer);
var
  Cnt: TDocController;
begin
  Cnt := CreateController;
  try
    Document.Append;
    Cnt.SetDefaultPayType(Document);
    if CurCustomer <> 0 then
      Document.ContragentID := CurCustomer;
    Document.DocDate := Now;
    if Cnt.EditDocForm then
    begin
      try
        Document.ApplyUpdates;
        Document.Reload;
      except
        Document.CancelUpdates;
        raise;
      end;
    end
    else
      Document.CancelUpdates;
  finally
    Cnt.Free;
  end;
end;

procedure TDocumentView.DoDeleteDoc(Sender: TObject);
begin
  DeleteCurrent(true);
end;

{procedure TSaleView.EditSaleDoc(SaleDocID: integer);
var
  Cnt: TSaleDocController;
begin
  if not SaleDocs.IsEmpty then
  begin
    Cnt := TSaleDocController.Create;
    try
      if Cnt.EditSaleDoc(SaleDocID) then
      begin
        SaleDocs.ApplyUpdates;
        //Shipment.Reload;
      end;
    finally
      Cnt.Free;
    end;
  end;
end;}

procedure TDocumentView.DoPrintReport(Sender: TObject);
begin
  ScriptManager.ExecOrderEvent(nil, GetReportScriptID);
end;

procedure TDocumentView.DoPrintForm(Sender: TObject);
begin
  ScriptManager.ExecOrderEvent(nil, GetFormScriptID);
end;

procedure TDocumentView.EditCurrent;
var
  Cnt: TDocController;
begin
  Cnt := CreateController;
  try
    if not Document.IsEmpty then
    begin
      //InstantUpdateDetails;
      Document.Items;
      if Cnt.EditDocForm then
      begin
        try
          Document.ApplyUpdates;
          Document.Reload;
        except
          Document.CancelUpdates;
          raise;
        end;
      end
      else
        Document.CancelUpdates;
    end;
  finally
    Cnt.Free;
  end;
end;

procedure TDocumentView.DoEditDoc(Sender: TObject);
begin
  EditCurrent;
end;

end.
