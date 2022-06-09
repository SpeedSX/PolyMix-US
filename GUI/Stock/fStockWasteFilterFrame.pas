unit fStockWasteFilterFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fMatRequestFilterFrame, ImgList, JvImageList, JvExControls,
  JvxCheckListBox, StdCtrls, JvDBLookup, Mask, DBCtrlsEh, JvExStdCtrls, JvEdit,
  JvValidateEdit, JvgGroupBox, Buttons, ExtCtrls, DB;

type
  TStockWasteFilterFrame = class(TMatRequestFilterFrame)
  private
  protected
    function SupportsOrderState: boolean; override;
    function GetDateList: TStringList; override;
  public
    procedure Activate; override;
  end;

implementation

{$R *.dfm}

var
  StockWasteDateList: TStringList;

function TStockWasteFilterFrame.SupportsOrderState: boolean;
begin
  Result := false;
end;

function TStockWasteFilterFrame.GetDateList: TStringList;
begin
  Result := StockWasteDateList;
end;

procedure TStockWasteFilterFrame.Activate;
begin
  inherited;
  gbProcessState.Visible := false;
  gbPayState.Visible := false;
  gbOrdState.Visible := false;
  //gbComment.Visible := false;
  gbNum.Visible := false;
  gbProcess.Visible := false;
  gbOrderKind.Visible := false;
end;

initialization

StockWasteDateList := TStringList.Create;
StockWasteDateList.Add('Расхода');

finalization

StockWasteDateList.Free;

end.
