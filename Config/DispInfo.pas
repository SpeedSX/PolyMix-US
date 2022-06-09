unit DispInfo;

interface

uses PmEntity;

type
  TDisplayInfo = class(TEntity)
    procedure DoAfterConnect; override;
  public
    constructor Create; override;
  end;

var
  DisplayInfo: TDisplayInfo;

implementation

uses SysUtils, MainData;

const
  F_DispInfoKey = 'DisplayInfoItemID';

constructor TDisplayInfo.Create;
begin
  inherited Create;
  FKeyField := F_DispInfoKey;
end;

procedure TDisplayInfo.DoAfterConnect;
begin
  SetDataSet(dm.cdDisplayInfo);
  DataSetProvider := dm.pvDisplayInfo;
  //ADODataSet := dm.aqDisplayInfo;
end;

initialization

DisplayInfo := TDisplayInfo.Create;

finalization

FreeAndNil(DisplayInfo);

end.
