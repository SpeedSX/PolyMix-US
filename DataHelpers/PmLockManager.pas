unit PmLockManager;

interface

uses Classes;

type
  TLockManager = class
  public
    const
      Order = 'Order';
      Workload = 'Workload';
      Contragent = 'Contragent';
      Dictionary = 'Dictionary';
      User = 'User';
      Invoice = 'Invoice';
      ShipmentDoc = 'ShipmentDoc';
    class function Lock(ObjectClassID: string; ObjectID: integer): boolean;
    class procedure Unlock(ObjectClassID: string; ObjectID: integer);
    class procedure UnlockClass(ObjectClassID: string);
    class procedure UnlockAll;
    class function IsLockedByAnotherUser(var UserName: string; ObjectClassID: string; ObjectID: integer): boolean;
    class function GetSelectLockExpr(ObjectClassID: string; KeyFieldName: string): string;
  end;

implementation

uses SysUtils, CalcSettings, PmEntSettings, PmDatabase, RDBUtils;

class function TLockManager.Lock(ObjectClassID: string; ObjectID: integer): boolean;
begin
  Result := Database.ExecuteScalar('declare @OK int; exec up_SetObjectLock ''' + ObjectClassID
    + ''', '+ IntToStr(ObjectID) + ', @OK; select @OK') = 1;
end;

class procedure TLockManager.Unlock(ObjectClassID: string; ObjectID: integer);
begin
  Database.ExecuteNonQuery('exec up_RemoveObjectLock ''' + ObjectClassID
    + ''', ' + IntToStr(ObjectID));
end;

class procedure TLockManager.UnlockClass(ObjectClassID: string);
begin
  Database.ExecuteNonQuery('exec up_RemoveClassLock ''' + ObjectClassID + '''');
end;

class procedure TLockManager.UnlockAll;
begin
  Database.ExecuteNonQuery('exec up_RemoveUserLocks');
end;

class function TLockManager.IsLockedByAnotherUser(var UserName: string; ObjectClassID: string; ObjectID: integer): boolean;
begin
  UserName := NvlString(Database.ExecuteScalar('declare @UserName varchar(40); exec up_IsObjectLocked ''' + ObjectClassID + ''', '
    + IntToStr(ObjectID) + ', ' + IntToStr(EntSettings.EditLockTimeoutInterval)
    + ', @UserName OUTPUT; select @UserName'));
  Result := UserName <> '';
end;

class function TLockManager.GetSelectLockExpr(ObjectClassID: string; KeyFieldName: string): string;
const
  NoLockStr = 'cast(0 as bit)';
begin
  if Options.ShowLockState then
  begin
    if EntSettings.EditLock then
      Result := 'cast((case when exists (select * from ObjectLock where ObjectID = ' + KeyFieldName
        + ' and UserName <> SYSTEM_USER and DATEDIFF(second, LockDate, GETDATE()) < '
        + IntToStr(TEntSettings.EditLockTimeoutInterval)
        + ' and ClassID = ''' + ObjectClassID + ''''
        + ') then 1 else 0 end) as bit)'
    else
      Result := NoLockStr
  end else
    Result := NoLockStr;
end;

end.
