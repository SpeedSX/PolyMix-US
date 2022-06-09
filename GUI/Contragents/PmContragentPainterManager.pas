unit PmContragentPainterManager;

interface

uses Classes, SysUtils, PmContragent, PmContragentPainter;

type
  TContragentPainterManager = class
  public
    class function GetPainter(Obj: TContragents): TContragentPainter;
  end;

implementation

class function TContragentPainterManager.GetPainter(Obj: TContragents): TContragentPainter;
begin
  if Obj is TCustomers then
    Result := CustomerPainter
  else if Obj is TContractors then
    Result := ContractorPainter
  else if Obj is TSuppliers then
    Result := SupplierPainter
  else
    raise Exception.Create('Неизвестный тип контрагента');
end;

end.
