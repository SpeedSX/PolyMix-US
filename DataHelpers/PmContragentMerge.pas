unit PmContragentMerge;

interface

uses PmContragent;

type
  TContragentMerge = class
    // Объединяет заказчиков. Переносит все заказы и поступления закачика SourceID
    // на заказчика DestID. SourceID переносит в корзину
    procedure Execute(Contragents: TContragents; SourceID, DestID: integer;
      MergeFields, MergePersons: boolean);
  end;

implementation

uses SysUtils, Variants, ADODB, DB, DBSettings, PmDatabase;

procedure TContragentMerge.Execute(Contragents: TContragents; SourceID, DestID: integer;
  MergeFields, MergePersons: boolean);
var
  ac: TADOCommand;
  //Fields: Variant;
  //FieldCount: integer;
  //I: Integer;
  SInfo, DInfo: TContragentInfo;
  Changed: boolean;
  SourcePersons, DestPersons: TPersons;
  PInfo: TPersonInfo;
begin
  //FieldCount := 0;
  Changed := false;
  if MergeFields then
  begin
    //Fields := VarArrayCreate([0, Contragents.DataSet.FieldCount - 1], varVariant);
    SInfo := Contragents.GetInfo(SourceID);
    DInfo := Contragents.GetInfo(DestID);
    //for I := 0 to Contragents.DataSet.Count - 1 do
    if (SInfo.Fax <> '') and (DInfo.Fax = '') then
      DInfo.Fax := SInfo.Fax;
    if (SInfo.Phone <> '') and (DInfo.Phone = '') then
      DInfo.Phone := SInfo.Phone;
    if (SInfo.Address <> '') and (DInfo.Address = '') then
      DInfo.Address := SInfo.Address;
    if (SInfo.Bank <> '') and (DInfo.Bank = '') then
      DInfo.Bank := SInfo.Bank;
    if (SInfo.IndCode <> '') and (DInfo.IndCode = '') then
      DInfo.IndCode := SInfo.IndCode;
    if (SInfo.NDSCode <> '') and (DInfo.NDSCode = '') then
      DInfo.NDSCode := SInfo.NDSCode;
    if (SInfo.Email <> '') and (DInfo.Email = '') then
      DInfo.Email := SInfo.Email;
    if (SInfo.FirmBirthday <> 0) and (DInfo.FirmBirthday = 0) then
      DInfo.FirmBirthday := SInfo.FirmBirthday;
    //if (SInfo.DirectorBirthday <> 0) and (DInfo.DirectorBirthday = 0) then
    //  DInfo.DirectorBirthday := SInfo.DirectorBirthday;
    Contragents.SetInfo(DestID, DInfo);
    Changed := true;
  end;
  if MergePersons then
  begin
    Changed := true;
    Contragents.Locate(SourceID);
    SourcePersons := TPersons.Copy(Contragents.Persons);
    try
      Contragents.Locate(DestID);
      DestPersons := Contragents.Persons;
      SourcePersons.DataSet.First;
      while not SourcePersons.DataSet.eof do
      begin
        PInfo := SourcePersons.GetInfo;
        if not DestPersons.LocateByName(PInfo.Name, [loCaseInsensitive]) then
        begin
          DestPersons.AddNew(PInfo);
        end;
        SourcePersons.DataSet.Next;
      end;
    finally
      SourcePersons.Free;
    end;
  end;
  if Changed then
    Contragents.ApplyUpdates;

  ac := TADOCommand.Create(nil);
  try
    ac.Connection := Database.Connection;
    ac.CommandTimeout := ConnectInfo.CommandTimeout;
    ac.CommandText := 'exec up_MergeContragents ' + IntToStr(SourceID) + ', ' + IntToStr(DestID);
    ac.Execute;
  finally
    ac.Free;
  end;
end;

end.
