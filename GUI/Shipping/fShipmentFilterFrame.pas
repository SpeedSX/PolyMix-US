unit fShipmentFilterFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseFilter, ImgList, JvImageList, JvExControls, JvxCheckListBox,
  StdCtrls, JvDBLookup, Mask, JvExMask, JvToolEdit, JvExStdCtrls, JvEdit,
  JvValidateEdit, JvgGroupBox, Buttons, ExtCtrls, DBCtrlsEh, ComCtrls,
  JvExComCtrls, JvUpDown, DB;

type
  TShipmentFilterFrame = class(TBaseFilterFrame)
  protected
    procedure DoOnCfgChanged(Sender: TObject); override;
    function SupportsOrderState: boolean; override;
    function SupportsPayState: boolean; override;
    function GetDateList: TStringList; override;
    procedure DisableFilter; override;
  public
    constructor Create(Owner: TComponent);
    destructor Destroy; override;
    procedure Activate; override;
  end;

implementation

{$R *.dfm}

var
  ShipmentDateList: TStringList;

constructor TShipmentFilterFrame.Create(Owner: TComponent);
begin
  inherited Create(Owner);
end;

destructor TShipmentFilterFrame.Destroy;
begin
  inherited;
end;

procedure TShipmentFilterFrame.DoOnCfgChanged(Sender: TObject);
begin
  inherited;
end;

function TShipmentFilterFrame.SupportsOrderState: boolean;
begin
  Result := true;
end;

function TShipmentFilterFrame.SupportsPayState: boolean;
begin
  Result := true;
end;

function TShipmentFilterFrame.GetDateList: TStringList;
begin
  Result := ShipmentDateList;
end;

procedure TShipmentFilterFrame.Activate;
begin
  inherited;
  gbProcessState.Visible := false;
  gbProcess.Visible := false;
  gbPayState.Visible := false;
  gbOrdState.Visible := false;
  gbComment.Visible := false;
  gbNum.Visible := false;
  gbOrderKind.Visible := false;
  gbCreator.Visible := false;
end;

procedure TShipmentFilterFrame.DisableFilter;
begin
  inherited;
end;

initialization

ShipmentDateList := TStringList.Create;
ShipmentDateList.Add('Отгрузки');

finalization

ShipmentDateList.Free;

end.
