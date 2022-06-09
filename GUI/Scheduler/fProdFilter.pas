unit fProdFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvExControls, JvComponent, JvxCheckListBox, StdCtrls,
  JvDBLookup, Mask, JvExMask, JvToolEdit, JvExStdCtrls, JvEdit,
  JvValidateEdit, JvgGroupBox, Buttons, ExtCtrls, fBaseFilter, ImgList,
  JvImageList, PmProduction;

type
  TProdFilterFrame = class(TBaseFilterFrame)
  private
    function GetProduction: TProduction;
  protected
    //function CurOrderKindIsDraft: boolean; override;
    function SupportsOrderState: boolean; override;
    function SupportsPayState: boolean; override;
    function GetCustomerKey: Integer; override;
    function GetDateList: TStringList; override;
  public
    procedure Activate; override;
    property Production: TProduction read GetProduction;
  end;

implementation

{$R *.dfm}

var
  ProdDateList: TStringList;

{function TProdFilterFrame.CurOrderKindIsDraft: boolean;
begin
  Result := false;
end;}

function TProdFilterFrame.SupportsOrderState: boolean;
begin
  Result := true;
end;

function TProdFilterFrame.SupportsPayState: boolean;
begin
  Result := true;
end;

function TProdFilterFrame.GetCustomerKey: Integer;
begin
  Result := Production.DataSet['Customer'];
end;

function TProdFilterFrame.GetDateList: TStringList;
begin
  Result := ProdDateList;
end;

procedure TProdFilterFrame.Activate;
begin
  inherited Activate;
  gbProcess.Visible := false;
end;

function TProdFilterFrame.GetProduction: TProduction;
begin
  Result := Entity as TProduction;
end;

initialization

ProdDateList := TStringList.Create;
ProdDateList.Add('Планового начала');
ProdDateList.Add('Фактического начала');
ProdDateList.Add('Планового завершения');
ProdDateList.Add('Фактического завершения');
ProdDateList.Add('Сдачи заказа');

finalization

ProdDateList.Free;

end.
