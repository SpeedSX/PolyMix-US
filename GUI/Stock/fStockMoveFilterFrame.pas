unit fStockMoveFilterFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fMatRequestFilterFrame, ImgList, JvImageList, JvExControls,
  JvxCheckListBox, StdCtrls, JvDBLookup, Mask, DBCtrlsEh, JvExStdCtrls, JvEdit,
  JvValidateEdit, JvgGroupBox, Buttons, ExtCtrls, DB;

type
  TStockMoveFilterFrame = class(TMatRequestFilterFrame)
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
  StockMoveDateList: TStringList;

function TStockMoveFilterFrame.SupportsOrderState: boolean;
begin
  Result := false;
end;

function TStockMoveFilterFrame.GetDateList: TStringList;
begin
  Result := StockMoveDateList;
end;

procedure TStockMoveFilterFrame.Activate;
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

StockMoveDateList := TStringList.Create;
StockMoveDateList.Add('Движения');

finalization

StockMoveDateList.Free;

end.
