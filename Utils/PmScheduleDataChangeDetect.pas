unit PmScheduleDataChangeDetect;

interface

uses Classes, PmDataChangeDetect, ADODB;

type
  TScheduleDataChangeDetect = class(TADODataChangeDetect)
  private
    FEquipCode: integer;
  protected
    function GetLastModification(var CurT: TDateTime): TDateTime; override;
  public
    constructor Create;
    property EquipCode: integer read FEquipCode write FEquipCode;
  end;

implementation

uses SysUtils, PmDatabase, RDBUtils;

constructor TScheduleDataChangeDetect.Create;
begin
  TObject.Create;
  Interval := 10000;
end;

function TScheduleDataChangeDetect.GetLastModification(var CurT: TDateTime): TDateTime;
begin
  if FQuery = nil then
  begin
    FQuery := TADOQuery.Create(nil);
    FQuery.SQL.Add('select (select A8 from Dic_Equip where Code = ' + IntToStr(EquipCode) + '), GETDATE()');
  end;
  if FCon <> nil then
    FQuery.Connection := FCon
  else
    FQuery.Connection := Database.Connection;

  FQuery.Open;
  if FQuery.RecordCount > 0 then
  begin
    Result := NvlFloat(FQuery.Fields[0].Value);
    CurT := FQuery.Fields[1].Value;
  end
  else
  begin
    Result := 0; // что-то пошло не так
    CurT := 0;
  end;
  FQuery.Close;
end;

end.
