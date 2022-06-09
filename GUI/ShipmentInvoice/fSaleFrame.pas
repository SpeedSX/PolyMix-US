unit fSaleFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseFrame, ExtCtrls, JvExExtCtrls, JvNetscapeSplitter, GridsEh,
  DBGridEh, MyDBGridEh, JvFormPlacement, StdCtrls, Buttons,

  NotifyEvent, PmEntity, PmSaleDocs, fBaseFilter;

type
  TSaleFrame = class(TBaseFrame)
    Panel1: TPanel;
    paInvoices: TPanel;
    dgSale: TMyDBGridEh;
    procedure dgSaleDblClick(Sender: TObject);
    procedure dgSaleDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure dgInvoicesColumns0GetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
  private
    //FSaleDocs: TSaleDocs;
    //FOnEditShipment: TNotifyEvent;
  protected
    function SaleDocs: TSaleDocs;
  public
    constructor Create(Owner: TComponent; _SaleDocs: TEntity); override;
    destructor Destroy; override;
    procedure SaveSettings; override;
    procedure LoadSettings; override;
    function CreateFilterFrame: TBaseFilterFrame; override;

    //property OnEditShipment: TNotifyEvent read FOnEditShipment write FOnEditShipment;
  end;

implementation

uses JvJVCLUtils,

  PmUtils, MainFilter, fShipmentFilterFrame, CalcSettings, CalcUtils, PmEntSettings,
  PmActions, PmInvoiceItems, PmOrder;

{$R *.dfm}

constructor TSaleFrame.Create(Owner: TComponent; _SaleDocs: TEntity);
begin
  inherited Create(Owner, _SaleDocs{'SaleDoc'});
  //FSaleDocs := _SaleDocs;

  FilterObject := SaleDocs.Criteria;
  FilterFrame.Entity := SaleDocs;

  dgSale.DataSource := SaleDocs.DataSource;

  //dgShipment.FieldColumns['SyncState'].Visible := EntSettings.ShowSyncInfo;
end;

destructor TSaleFrame.Destroy;
begin
  inherited;
end;

function TSaleFrame.CreateFilterFrame: TBaseFilterFrame;
begin
  Result := TShipmentFilterFrame.Create(Self);
end;

procedure TSaleFrame.dgInvoicesColumns0GetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  Params.Text := ''
end;

procedure TSaleFrame.dgSaleDblClick(Sender: TObject);
begin
  //FOnEditShipment(Self);
  TMainActions.GetAction(TSaleActions.Edit).Execute;
end;

procedure TSaleFrame.dgSaleDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  RectCopy: TRect;
begin
  try
    if (CompareText(Column.FieldName, 'SyncState') = 0) and (Column.Field <> nil) then
      DrawSyncState(Sender as TGridClass, Column, Rect)
    {else if (CompareText(Column.FieldName, TOrder.F_PayState) = 0) and (Column.Field <> nil) then
      DrawPayState(Sender as TGridClass, Column, Rect)}
    else if (CompareText(Column.FieldName, TOrder.F_ShipmentState) = 0) and (Column.Field <> nil) then
    begin
      DrawShipmentState(Sender as TGridClass, Column, Rect)
    end
    else if (CompareText(Column.FieldName, TInvoiceItems.F_ItemText) = 0) then
    begin
      if SaleDocs.HasManyItems then
      begin
        RectCopy := Rect;
        DrawManyItemsIcon(Sender as TGridClass, Column, RectCopy);
        dgSale.DefaultDrawColumnCell(RectCopy, DataCol, Column, State);
      end else
        dgSale.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
  except end;
end;

procedure TSaleFrame.SaveSettings;
begin
  inherited;
  TSettingsManager.Instance.SaveGridLayout(dgSale, 'Sale_SaleDoc');
end;

procedure TSaleFrame.LoadSettings;
begin
  {FUpdatingControls := true;
  try}
    inherited;
    TSettingsManager.Instance.LoadGridLayout(dgSale, 'Sale_SaleDoc');
  {finally
    FUpdatingControls := false;
  end;}
end;

function TSaleFrame.SaleDocs: TSaleDocs;
begin
  Result := Entity as TSaleDocs;
end;

end.
