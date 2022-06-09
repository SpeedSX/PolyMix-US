unit fStockIncomeFilterFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fMatRequestFilterFrame, ImgList, JvImageList, JvExControls,
  JvxCheckListBox, StdCtrls, JvDBLookup, Mask, DBCtrlsEh, JvExStdCtrls, JvEdit,
  JvValidateEdit, JvgGroupBox, Buttons, ExtCtrls, DB;

type
  TStockIncomeFilterFrame = class(TMatRequestFilterFrame)
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
  StockIncomeDateList: TStringList;

function TStockIncomeFilterFrame.SupportsOrderState: boolean;
begin
  Result := false;
end;

function TStockIncomeFilterFrame.GetDateList: TStringList;
begin
  Result := StockIncomeDateList;
end;

procedure TStockIncomeFilterFrame.Activate;
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

StockIncomeDateList := TStringList.Create;
StockIncomeDateList.Add('Получения');

finalization

StockIncomeDateList.Free;

end.
