unit fShipmentFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseFrame, ExtCtrls, JvExExtCtrls, JvNetscapeSplitter, GridsEh,
  DBGridEh, MyDBGridEh, JvFormPlacement, StdCtrls, Buttons,

  NotifyEvent, PmEntity, PmShipment, fBaseFilter;

type
  TShipmentFrame = class(TBaseFrame)
    Panel1: TPanel;
    paInvoices: TPanel;
    dgShipment: TMyDBGridEh;
    procedure dgShipmentDblClick(Sender: TObject);
    procedure dgShipmentDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure dgInvoicesColumns0GetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
    procedure dgShipmentGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dgShipmentColumns1GetCellParams(Sender: TObject;
      EditMode: Boolean; Params: TColCellParamsEh);
  private
    //FShipment: TShipment;
    FOnEditShipment: TNotifyEvent;
  protected
    function Shipment: TShipment;
  public
    constructor Create(Owner: TComponent; _Shipment: TEntity); override;
    destructor Destroy; override;
    procedure SaveSettings; override;
    procedure LoadSettings; override;
    function CreateFilterFrame: TBaseFilterFrame; override;

    property OnEditShipment: TNotifyEvent read FOnEditShipment write FOnEditShipment;
  end;

implementation

uses JvJVCLUtils,

  PmUtils, MainFilter, fShipmentFilterFrame, CalcSettings, CalcUtils, PmEntSettings,
  PmOrder;

{$R *.dfm}

constructor TShipmentFrame.Create(Owner: TComponent; _Shipment: TEntity);
begin
  inherited Create(Owner, _Shipment{'Shipment'});
  //FShipment := _Shipment;

  FilterObject := Shipment.Criteria;
  FilterFrame.Entity := _Shipment;

  dgShipment.DataSource := Shipment.DataSource;

  //dgShipment.FieldColumns['SyncState'].Visible := EntSettings.ShowSyncInfo;
end;

destructor TShipmentFrame.Destroy;
begin
  inherited;
end;

function TShipmentFrame.CreateFilterFrame: TBaseFilterFrame;
begin
  Result := TShipmentFilterFrame.Create(Self);
end;

procedure TShipmentFrame.dgInvoicesColumns0GetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  Params.Text := ''
end;

procedure TShipmentFrame.dgShipmentColumns1GetCellParams(Sender: TObject;
  EditMode: Boolean; Params: TColCellParamsEh);
begin
  try
    if not VarIsNull(Shipment.IsTotal) then
      if Shipment.IsTotal then begin
      if not Shipment.IsFirstRow then begin
        if TDBGridColumnEh(Sender).FieldName = 'Comment' then
          Params.Text := 'Всего отгружено: '
        else
          Params.Text := '';
      end
      else
        Params.Text := TDBGridColumnEh(Sender).Field.AsString;
    end
    else
    if not Shipment.IsFirstRow then
      Params.Text := ''
    else
      Params.Text := TDBGridColumnEh(Sender).Field.AsString;
  except end;
end;

procedure TShipmentFrame.dgShipmentDblClick(Sender: TObject);
begin
  FOnEditShipment(Self);
end;

procedure TShipmentFrame.dgShipmentDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  try
    if (CompareText(Column.FieldName, 'SyncState') = 0) and (Column.Field <> nil) then
      DrawSyncState(Sender as TGridClass, Column, Rect)
    else if (CompareText(Column.FieldName, TOrder.F_PayState) = 0) and (Column.Field <> nil) then
      DrawPayState(Sender as TGridClass, Column, Rect)
    else if (CompareText(Column.FieldName, TOrder.F_ShipmentState) = 0) and (Column.Field <> nil) then
    begin
      if Shipment.IsFirstRow then
        DrawShipmentState(Sender as TGridClass, Column, Rect)
      {else
        (Sender as TGridClass).Canvas.FillRect(Rect);}
    end;
  except end;
end;

procedure TShipmentFrame.dgShipmentGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if Column.Field <> nil then
  begin
    if not VarIsNull(Column.Field.DataSet['IsTotal']) and Column.Field.DataSet['IsTotal'] then begin
      if (Column.FieldName = 'NOut') then begin
        AFont.Style := [fsBold];
        AFont.Color := clNavy;
      end;
    end;
    {if not VarIsNull(Column.Field.DataSet['FirstRow']) and Column.Field.DataSet['FirstRow'] and
      ((Column.FieldName = 'Comment') or (Column.FieldName = 'ID_Number')
        or (Column.FieldName = 'CustomerName')) then
       AFont.Style := [fsBold];}
    if not VarIsNull(Column.Field.DataSet['RColor']) then
      Background := Column.Field.DataSet['RColor'];
  end;
end;

procedure TShipmentFrame.SaveSettings;
begin
  inherited;
  TSettingsManager.Instance.SaveGridLayout(dgShipment, 'Shipment_Shipment');
end;

procedure TShipmentFrame.LoadSettings;
begin
  {FUpdatingControls := true;
  try}
    inherited;
    TSettingsManager.Instance.LoadGridLayout(dgShipment, 'Shipment_Shipment');
  {finally
    FUpdatingControls := false;
  end;}
end;

function TShipmentFrame.Shipment: TShipment;
begin
  Result := Entity as TShipment;
end;

end.
