alter table Customer add IsDead bit not null default(0)
go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER            PROCEDURE [dbo].[up_NewContragent]
   @Name VARCHAR(50),
   @Fax VARCHAR(50),
   @Phone VARCHAR(40),
   @Address VARCHAR(150),
   @Email VARCHAR(70),
   @Bank VARCHAR(80),
   @IndCode VARCHAR(12),
   @NDSCode VARCHAR(12),
   @IsWork BIT,
   @SourceCode INT,
   @UserCode INT,
   @ContragentType INT,
   @SourceOther VARCHAR(50),
   @FirmBirthday DATETIME,
   @FirmType VARCHAR(30),
   @PersonType INT,
   @ContragentGroup INT,
   @Notes TEXT = NULL,
   @FullName VARCHAR(300) = NULL,
   @OKPOCode VARCHAR(10) = NULL,
   @Phone2 VARCHAR(40) = NULL,
   @LegalAddress VARCHAR(200) = NULL,
   @ExternalName VARCHAR(50) = NULL,
   @PrePayPercent FLOAT = NULL,
   @PreShipPercent FLOAT = NULL,
   @PayDelay INT = NULL,
   @IsPayDelayInBankDays BIT = 0,
   @StatusCode INT = NULL,
   @CheckPayConditions BIT = NULL,
   @ActivityCode INT = NULL,
   @BriefNote VARCHAR(128) = NULL,
   @SyncWeb BIT = NULL,
   @Alert BIT = NULL,
   @IsDead BIT = NULL
AS
begin
  -- вставляем заказчика в таблицу

  insert into Customer ([Name], Fax, Phone, Bank, Address, IndCode, NDSCode, SourceCode, SourceOther, 
    ContragentType, UserCode, FirmBirthday, Email, IsWork, FirmType, PersonType, CreationDate, 
    FullName, Notes, OKPOCode, Phone2, LegalAddress, ExternalName, ContragentGroup, 
    PrePayPercent, PreShipPercent, PayDelay, IsPayDelayInBankDays, StatusCode, CheckPayConditions, ActivityCode,
    BriefNote, SyncWeb, Alert, IsDead
  )
  values (@Name,  @Fax,  @Phone,  @Bank,  @Address, @IndCode, @NDSCode, @SourceCode, @SourceOther,
    @ContragentType, @UserCode, @FirmBirthday, @Email, @IsWork, @FirmType, @PersonType, GETDATE(), 
    @FullName, @Notes, @OKPOCode, @Phone2, @LegalAddress, @ExternalName, @ContragentGroup,
    @PrePayPercent, @PreShipPercent, @PayDelay, @IsPayDelayInBankDays, @StatusCode, @CheckPayConditions, @ActivityCode,
    @BriefNote, @SyncWeb, @Alert, @IsDead
  )

  return SCOPE_IDENTITY()
end


go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER         trigger [dbo].[TR_Contragents_Update] on [dbo].[CUSTOMER]
for update as
begin
  declare @s varchar(4000), @ContragentType int
  declare @NewName varchar(50), @NewSourceCode int
  declare @OldName varchar(50), @OldSourceCode int
  declare @NewPersonType int, @OldPersonType int, @NewPT varchar(30), @OldPT varchar(30)
  declare @NewFirmType varchar(30), @OldFirmType varchar(30)
  declare @NewPhone varchar(40), @OldPhone varchar(40)
  declare @NewPhone2 varchar(40), @OldPhone2 varchar(40)
  declare @NewFax varchar(50), @OldFax varchar(50)
  declare @NewEmail varchar(70), @OldEmail varchar(70)
  declare @NewAddress varchar(150), @OldAddress varchar(150)
  declare @NewFullName varchar(300), @OldFullName varchar(300)
  declare @NewPrePayPercent float, @OldPrePayPercent float
  declare @NewPreShipPercent float, @OldPreShipPercent float
  declare @NewPayDelay int, @OldPayDelay int
  declare @NewCheckPayConditions bit, @OldCheckPayConditions bit
  declare @NewAlert bit, @OldAlert bit
  declare @NewIsDead bit, @OldIsDead bit
  declare @id int, @r int

  if @@ROWCOUNT = 1 and SYSTEM_USER <> 'sa'
  begin

    select @ContragentType = [ContragentType], @id = n from inserted

    select @NewName = [Name], @NewSourceCode = [SourceCode], @NewPhone = Phone, @NewFax = Fax, 
           @NewAddress = Address, @NewEmail = Email, @NewPersonType = PersonType, @NewFirmType = FirmType,
           @NewFullName = FullName, @NewPhone2 = Phone2, @NewPrePayPercent = PrePayPercent, 
           @NewPreShipPercent = PreShipPercent, @NewPayDelay = PayDelay, @NewCheckPayConditions = CheckPayConditions,
           @NewAlert = Alert, @NewIsDead = IsDead
    from inserted
    
    select @OldName = [Name], @OldSourceCode = [SourceCode], @OldPhone = Phone, @OldFax = Fax, 
           @OldAddress = Address, @OldEmail = Email, @OldPersonType = PersonType, @OldFirmType = FirmType,
           @OldFullName = FullName, @OldPhone2 = Phone2, @OldPrePayPercent = PrePayPercent, 
           @OldPreShipPercent = PreShipPercent, @OldPayDelay = PayDelay, @OldCheckPayConditions = CheckPayConditions,
           @OldAlert = Alert, @OldIsDead = IsDead
    from deleted

    set @s = 'Изменение контрагента (имя: "' + @NewName + '", тип: ' + cast(@ContragentType as varchar(10)) + ')'
    exec up_AddToGlobalHistory 1, @s, null

    if @OldName <> @NewName begin
      set @s = 'Имя: ' + @OldName + ' -> ' + @NewName
      exec up_AddContragentHistory 1, @s, @id
    end

    if @OldSourceCode <> @NewSourceCode
    begin
      set @s = 'Источник: ' + cast(@OldSourceCode as varchar(5)) + ' -> ' + cast(@NewSourceCode as varchar(5))
      exec up_AddContragentHistory 1, @s, @id
    end

    if coalesce(@OldPhone, 'null') <> coalesce(@NewPhone, 'null')
    begin
      set @s = 'Телефон 1: ' + coalesce(@OldPhone, 'null') + ' -> ' + coalesce(@NewPhone, 'null')
      exec up_AddContragentHistory 1, @s, @id
    end

    if coalesce(@OldPhone2, 'null') <> coalesce(@NewPhone2, 'null')
    begin
      set @s = 'Телефон 2: ' + coalesce(@OldPhone2, 'null') + ' -> ' + coalesce(@NewPhone2, 'null')
      exec up_AddContragentHistory 1, @s, @id
    end

    if coalesce(@OldFax, 'null') <> coalesce(@NewFax, 'null') 
    begin
      set @s = 'Факс: ' + coalesce(@OldFax, 'null') + ' -> ' + coalesce(@NewFax, 'null')
      exec up_AddContragentHistory 1, @s, @id
    end

    if coalesce(@OldAddress, 'null') <> coalesce(@NewAddress, 'null')
     begin
      set @s = 'Адрес: ' + substring(coalesce(@OldAddress, 'null'), 1, 100) + ' -> ' + substring(coalesce(@NewAddress, 'null'), 1, 100)
      exec up_AddContragentHistory 1, @s, @id
    end

    if coalesce(@OldEmail, 'null') <> coalesce(@NewEmail, 'null')
    begin
      set @s = 'Email: ' + coalesce(@OldEmail, 'null') + ' -> ' + coalesce(@NewEmail, 'null')
      exec up_AddContragentHistory 1, @s, @id
    end

    if coalesce(@OldFirmType, 'null') <> coalesce(@NewFirmType, 'null')
    begin
      set @s = 'Форма соб.: ' + coalesce(@OldFirmType, 'null') + ' -> ' + coalesce(@NewFirmType, 'null')
      exec up_AddContragentHistory 1, @s, @id
    end

    if coalesce(@OldFullName, 'null') <> coalesce(@NewFullName, 'null')
    begin
      set @s = 'Полное имя: ' + substring(coalesce(@OldFullName, 'null'), 1, 100) + ' -> ' + substring(coalesce(@NewFullName, 'null'), 1, 100)
      exec up_AddContragentHistory 1, @s, @id
    end

    /*if exists(select * from inserted i inner join deleted d on i.N = d.N where coalesce(i.Notes, 'null') <> coalesce(d.Notes, 'null'))
    begin
      set @s = 'Заметки'-- + substring(coalesce(@OldNotes, 'null'), 1, 100) + ' -> ' + substring(coalesce(@NewNotes, 'null'), 1, 100)
      exec up_AddContragentHistory 1, @s, @id
    end*/

    if @OldPersonType <> @NewPersonType begin
      if @OldPersonType = 0 
        set @OldPT = 'Юр. лицо'
      else
        set @OldPT = 'Физ. лицо'
      if @NewPersonType = 0 
        set @NewPT = 'Юр. лицо'
      else
        set @NewPT = 'Физ. лицо'
      set @s = 'Тип контрагента: ' + @OldPT + ' -> ' + @NewPT
      exec up_AddContragentHistory 1, @s, @id
    end

    if @OldPrePayPercent <> @NewPrePayPercent
    begin
      set @s = 'Предоплата: ' + cast(@OldPrePayPercent as varchar(10)) + ' -> ' + cast(@NewPrePayPercent as varchar(10))
      exec up_AddContragentHistory 1, @s, @id
    end
  
    if @OldPreShipPercent <> @NewPreShipPercent
    begin
      set @s = 'Предотгрузка: ' + cast(@OldPreShipPercent as varchar(10)) + ' -> ' + cast(@NewPreShipPercent as varchar(10))
      exec up_AddContragentHistory 1, @s, @id
    end

    if @OldPayDelay <> @NewPayDelay
    begin
      set @s = 'Отсрочка: ' + cast(@OldPayDelay as varchar(10)) + ' -> ' + cast(@NewPayDelay as varchar(10))
      exec up_AddContragentHistory 1, @s, @id
    end

    if @OldCheckPayConditions <> @NewCheckPayConditions
    begin
      set @s = 'Контроль условий оплаты: ' + cast(@OldCheckPayConditions as varchar(10)) + ' -> ' + cast(@NewCheckPayConditions as varchar(10))
      exec up_AddContragentHistory 1, @s, @id
    end

    if @OldAlert <> @NewAlert
    begin
      set @s = 'Увага: ' + cast(@OldAlert as varchar(10)) + ' -> ' + cast(@NewAlert as varchar(10))
      exec up_AddContragentHistory 1, @s, @id
    end

    if @OldIsDead <> @NewIsDead
    begin
      set @s = 'Неіснуючий: ' + cast(@OldIsDead as varchar(10)) + ' -> ' + cast(@NewIsDead as varchar(10))
      exec up_AddContragentHistory 1, @s, @id
    end
  end

  exec up_RegisterChange 'Contragents'

end

go

exec up_NewTableDictionary;1 'ContragentAttrPermissions','Права Доступа: Параметри Контрагентов',0,2
go
alter table Dic_ContragentAttrPermissions add A1 bit null
go
insert into DicFields (DicID, FieldName, FieldDesc,FieldType,[Length],[Precision],ReferenceID) values (152, 'A1', 'Неіснуючий', 5, 1, 0, null)
go
alter table Dic_ContragentAttrPermissions add A2 bit null
go
insert into DicFields (DicID, FieldName, FieldDesc,FieldType,[Length],[Precision],ReferenceID) values (152, 'A2', 'Платники', 5, 1, 0, null)
go

alter table Customer add ActivityCodes varchar(300) null
go 

ALTER            PROCEDURE [dbo].[up_NewContragent]
   @Name VARCHAR(50),
   @Fax VARCHAR(50),
   @Phone VARCHAR(40),
   @Address VARCHAR(150),
   @Email VARCHAR(70),
   @Bank VARCHAR(80),
   @IndCode VARCHAR(12),
   @NDSCode VARCHAR(12),
   @IsWork BIT,
   @SourceCode INT,
   @UserCode INT,
   @ContragentType INT,
   @SourceOther VARCHAR(50),
   @FirmBirthday DATETIME,
   @FirmType VARCHAR(30),
   @PersonType INT,
   @ContragentGroup INT,
   @Notes TEXT = NULL,
   @FullName VARCHAR(300) = NULL,
   @OKPOCode VARCHAR(10) = NULL,
   @Phone2 VARCHAR(40) = NULL,
   @LegalAddress VARCHAR(200) = NULL,
   @ExternalName VARCHAR(50) = NULL,
   @PrePayPercent FLOAT = NULL,
   @PreShipPercent FLOAT = NULL,
   @PayDelay INT = NULL,
   @IsPayDelayInBankDays BIT = 0,
   @StatusCode INT = NULL,
   @CheckPayConditions BIT = NULL,
   @ActivityCode INT = NULL,
   @BriefNote VARCHAR(128) = NULL,
   @SyncWeb BIT = NULL,
   @Alert BIT = NULL,
   @IsDead BIT = NULL,
   @ActivityCodes VARCHAR(300) = NULL
AS
begin
  -- вставляем заказчика в таблицу

  insert into Customer ([Name], Fax, Phone, Bank, Address, IndCode, NDSCode, SourceCode, SourceOther, 
    ContragentType, UserCode, FirmBirthday, Email, IsWork, FirmType, PersonType, CreationDate, 
    FullName, Notes, OKPOCode, Phone2, LegalAddress, ExternalName, ContragentGroup, 
    PrePayPercent, PreShipPercent, PayDelay, IsPayDelayInBankDays, StatusCode, CheckPayConditions, ActivityCode,
    BriefNote, SyncWeb, Alert, IsDead, ActivityCodes
  )
  values (@Name,  @Fax,  @Phone,  @Bank,  @Address, @IndCode, @NDSCode, @SourceCode, @SourceOther,
    @ContragentType, @UserCode, @FirmBirthday, @Email, @IsWork, @FirmType, @PersonType, GETDATE(), 
    @FullName, @Notes, @OKPOCode, @Phone2, @LegalAddress, @ExternalName, @ContragentGroup,
    @PrePayPercent, @PreShipPercent, @PayDelay, @IsPayDelayInBankDays, @StatusCode, @CheckPayConditions, @ActivityCode,
    @BriefNote, @SyncWeb, @Alert, @IsDead, @ActivityCodes
  )

  return SCOPE_IDENTITY()
end


go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER         trigger [dbo].[TR_Contragents_Update] on [dbo].[CUSTOMER]
for update as
begin
  declare @s varchar(4000), @ContragentType int
  declare @NewName varchar(50), @NewSourceCode int
  declare @OldName varchar(50), @OldSourceCode int
  declare @NewPersonType int, @OldPersonType int, @NewPT varchar(30), @OldPT varchar(30)
  declare @NewFirmType varchar(30), @OldFirmType varchar(30)
  declare @NewPhone varchar(40), @OldPhone varchar(40)
  declare @NewPhone2 varchar(40), @OldPhone2 varchar(40)
  declare @NewFax varchar(50), @OldFax varchar(50)
  declare @NewEmail varchar(70), @OldEmail varchar(70)
  declare @NewAddress varchar(150), @OldAddress varchar(150)
  declare @NewFullName varchar(300), @OldFullName varchar(300)
  declare @NewPrePayPercent float, @OldPrePayPercent float
  declare @NewPreShipPercent float, @OldPreShipPercent float
  declare @NewPayDelay int, @OldPayDelay int
  declare @NewCheckPayConditions bit, @OldCheckPayConditions bit
  declare @NewAlert bit, @OldAlert bit
  declare @NewIsDead bit, @OldIsDead bit
  declare @NewActivityCodes varchar(300), @OldActivityCodes varchar(300)
  declare @id int, @r int

  if @@ROWCOUNT = 1 and SYSTEM_USER <> 'sa'
  begin

    select @ContragentType = [ContragentType], @id = n from inserted

    select @NewName = [Name], @NewSourceCode = [SourceCode], @NewPhone = Phone, @NewFax = Fax, 
           @NewAddress = Address, @NewEmail = Email, @NewPersonType = PersonType, @NewFirmType = FirmType,
           @NewFullName = FullName, @NewPhone2 = Phone2, @NewPrePayPercent = PrePayPercent, 
           @NewPreShipPercent = PreShipPercent, @NewPayDelay = PayDelay, @NewCheckPayConditions = CheckPayConditions,
           @NewAlert = Alert, @NewIsDead = IsDead, @NewActivityCodes = ActivityCodes
    from inserted
    
    select @OldName = [Name], @OldSourceCode = [SourceCode], @OldPhone = Phone, @OldFax = Fax, 
           @OldAddress = Address, @OldEmail = Email, @OldPersonType = PersonType, @OldFirmType = FirmType,
           @OldFullName = FullName, @OldPhone2 = Phone2, @OldPrePayPercent = PrePayPercent, 
           @OldPreShipPercent = PreShipPercent, @OldPayDelay = PayDelay, @OldCheckPayConditions = CheckPayConditions,
           @OldAlert = Alert, @OldIsDead = IsDead, @OldActivityCodes = ActivityCodes
    from deleted

    set @s = 'Изменение контрагента (имя: "' + @NewName + '", тип: ' + cast(@ContragentType as varchar(10)) + ')'
    exec up_AddToGlobalHistory 1, @s, null

    if @OldName <> @NewName begin
      set @s = 'Имя: ' + @OldName + ' -> ' + @NewName
      exec up_AddContragentHistory 1, @s, @id
    end

    if @OldSourceCode <> @NewSourceCode
    begin
      set @s = 'Источник: ' + cast(@OldSourceCode as varchar(5)) + ' -> ' + cast(@NewSourceCode as varchar(5))
      exec up_AddContragentHistory 1, @s, @id
    end

    if coalesce(@OldPhone, 'null') <> coalesce(@NewPhone, 'null')
    begin
      set @s = 'Телефон 1: ' + coalesce(@OldPhone, 'null') + ' -> ' + coalesce(@NewPhone, 'null')
      exec up_AddContragentHistory 1, @s, @id
    end

    if coalesce(@OldPhone2, 'null') <> coalesce(@NewPhone2, 'null')
    begin
      set @s = 'Телефон 2: ' + coalesce(@OldPhone2, 'null') + ' -> ' + coalesce(@NewPhone2, 'null')
      exec up_AddContragentHistory 1, @s, @id
    end

    if coalesce(@OldFax, 'null') <> coalesce(@NewFax, 'null') 
    begin
      set @s = 'Факс: ' + coalesce(@OldFax, 'null') + ' -> ' + coalesce(@NewFax, 'null')
      exec up_AddContragentHistory 1, @s, @id
    end

    if coalesce(@OldAddress, 'null') <> coalesce(@NewAddress, 'null')
     begin
      set @s = 'Адрес: ' + substring(coalesce(@OldAddress, 'null'), 1, 100) + ' -> ' + substring(coalesce(@NewAddress, 'null'), 1, 100)
      exec up_AddContragentHistory 1, @s, @id
    end

    if coalesce(@OldEmail, 'null') <> coalesce(@NewEmail, 'null')
    begin
      set @s = 'Email: ' + coalesce(@OldEmail, 'null') + ' -> ' + coalesce(@NewEmail, 'null')
      exec up_AddContragentHistory 1, @s, @id
    end

    if coalesce(@OldFirmType, 'null') <> coalesce(@NewFirmType, 'null')
    begin
      set @s = 'Форма соб.: ' + coalesce(@OldFirmType, 'null') + ' -> ' + coalesce(@NewFirmType, 'null')
      exec up_AddContragentHistory 1, @s, @id
    end

    if coalesce(@OldFullName, 'null') <> coalesce(@NewFullName, 'null')
    begin
      set @s = 'Полное имя: ' + substring(coalesce(@OldFullName, 'null'), 1, 100) + ' -> ' + substring(coalesce(@NewFullName, 'null'), 1, 100)
      exec up_AddContragentHistory 1, @s, @id
    end

    /*if exists(select * from inserted i inner join deleted d on i.N = d.N where coalesce(i.Notes, 'null') <> coalesce(d.Notes, 'null'))
    begin
      set @s = 'Заметки'-- + substring(coalesce(@OldNotes, 'null'), 1, 100) + ' -> ' + substring(coalesce(@NewNotes, 'null'), 1, 100)
      exec up_AddContragentHistory 1, @s, @id
    end*/

    if @OldPersonType <> @NewPersonType begin
      if @OldPersonType = 0 
        set @OldPT = 'Юр. лицо'
      else
        set @OldPT = 'Физ. лицо'
      if @NewPersonType = 0 
        set @NewPT = 'Юр. лицо'
      else
        set @NewPT = 'Физ. лицо'
      set @s = 'Тип контрагента: ' + @OldPT + ' -> ' + @NewPT
      exec up_AddContragentHistory 1, @s, @id
    end

    if @OldPrePayPercent <> @NewPrePayPercent
    begin
      set @s = 'Предоплата: ' + cast(@OldPrePayPercent as varchar(10)) + ' -> ' + cast(@NewPrePayPercent as varchar(10))
      exec up_AddContragentHistory 1, @s, @id
    end
  
    if @OldPreShipPercent <> @NewPreShipPercent
    begin
      set @s = 'Предотгрузка: ' + cast(@OldPreShipPercent as varchar(10)) + ' -> ' + cast(@NewPreShipPercent as varchar(10))
      exec up_AddContragentHistory 1, @s, @id
    end

    if @OldPayDelay <> @NewPayDelay
    begin
      set @s = 'Отсрочка: ' + cast(@OldPayDelay as varchar(10)) + ' -> ' + cast(@NewPayDelay as varchar(10))
      exec up_AddContragentHistory 1, @s, @id
    end

    if @OldCheckPayConditions <> @NewCheckPayConditions
    begin
      set @s = 'Контроль условий оплаты: ' + cast(@OldCheckPayConditions as varchar(10)) + ' -> ' + cast(@NewCheckPayConditions as varchar(10))
      exec up_AddContragentHistory 1, @s, @id
    end

    if @OldAlert <> @NewAlert
    begin
      set @s = 'Увага: ' + cast(@OldAlert as varchar(10)) + ' -> ' + cast(@NewAlert as varchar(10))
      exec up_AddContragentHistory 1, @s, @id
    end

    if @OldIsDead <> @NewIsDead
    begin
      set @s = 'Неіснуючий: ' + cast(@OldIsDead as varchar(10)) + ' -> ' + cast(@NewIsDead as varchar(10))
      exec up_AddContragentHistory 1, @s, @id
    end

	 if @OldActivityCodes <> @NewActivityCodes
    begin
      set @s = 'Види діяльності'
      exec up_AddContragentHistory 1, @s, @id
    end
  end

  exec up_RegisterChange 'Contragents'

end
go

alter table Addresses
  add [Name] varchar(150) null,
  Phone1 varchar(40) null,
  Phone2 varchar(40) null,
  PersonType int null
go

create table RelatedContragents (
  RelatedContragentID int not null identity(1, 1),
  CustomerID int not null,
  [Name] varchar(200) not null,
  Code varchar(50) null,
  Phone1 varchar(100) null,
  Phone2 varchar(100) null,
  ContactName varchar(200) null,
  CONSTRAINT PK_ContragentActivityID PRIMARY KEY (RelatedContragentID),
  CONSTRAINT FK_CustomerID_N FOREIGN KEY (CustomerID)
        REFERENCES Customer (N)
        ON DELETE CASCADE
)

go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER         procedure [dbo].[up_SetupUserRoles]
as 

if exists (select * from sysusers where name = 'power_user')
  deny all to power_user
else
  exec sp_addrole 'power_user'

if exists (select * from sysusers where name = 'just_user')
  deny all to just_user
else
  exec sp_addrole 'just_user'

-- POWER_USER
grant select on WorkOrder to power_user
--grant select on WorkOrderItem to power_user
grant select, update on Customer to power_user
grant select, update, insert, delete on Persons to power_user
grant select, update, insert, delete on RelatedContragents to power_user
--grant select, update, insert, delete on _Code to power_user
--grant select, update, insert, delete on _Formats to power_user
--grant select, update, insert, delete on _Types to power_user
--grant select, update, insert, delete on CommonExpenses to power_user
grant select, update, insert, delete on DicElements to power_user
grant select, update, insert, delete on DicFolders to power_user
grant select, update, insert, delete on DicFields to power_user
grant select, update, insert, delete on Dollar to power_user
grant select, update, insert, delete on GlobalScripts to power_user
grant select, update, insert, delete on OrderParams to power_user
grant select, update, insert, delete on OrderScripts to power_user
grant select, update, insert, delete on ScriptedForms to power_user
grant select, update, insert, delete on Services to power_user
grant select, update, insert, delete on SrvFields to power_user
grant select, update, insert, delete on SrvGridColumns to power_user
grant select, update, insert, delete on SrvGroups to power_user
grant select, update, insert, delete on SrvPages to power_user
grant select, update, insert, delete on SrvScriptInfo to power_user
--grant select, update, insert, delete on SrvVFields to power_user
--grant select, update, insert, delete on UserIP to power_user
--grant select, update, insert, delete on WorkLock to power_user
grant select, update, insert, delete on PolyCalcVersion to power_user
grant select, update, delete on OrderProcessItem to power_user
grant select, update, insert, delete on Job to power_user
grant select, update, insert, delete on OrderProcessItemMaterial to power_user
grant select, update, insert, delete on DisplayInfo to power_user
grant select, update, insert, delete on CustomReports to power_user
grant select, update, insert, delete on CustomReportColumns to power_user
grant select, update, insert, delete on EnterpriseSettings to power_user
grant select on GlobalHistory to power_user
grant select on OrderHistory to power_user
grant select on ContragentHistory to power_user
--grant select on Dic_DummyInt to power_user
grant select on AccessUser to power_user
grant select on AccessKind to power_user
grant select on AccessKindProcess to power_user
grant select on ProcessGrids to power_user
grant select on KindOrder to power_user
grant select on KindProcess to power_user
grant select on OrderProcessItemJobs to power_user
grant select, update, insert on CustomerIncome to power_user
grant select on LastStateChangeDate to power_user
grant select on InvoiceItemPayments to power_user
grant select, update, insert, delete on EmployeeToEquipShift to power_user
grant select, update, insert, delete on EmployeeToDepartmentShift to power_user
grant select on Addresses to power_user
grant select on Invoices to power_user
grant select on InvoiceItems to power_user
grant select on Payments to power_user
grant select, update on Shipment to power_user
grant select, update on ShipmentDoc to power_user
grant select, delete on OrderAttachedFiles to power_user
grant select, insert, update, delete on OrderNotes to power_user
grant select on EnabledMix to power_user
grant select on StockMove to power_user
grant select on StockMoveProcess to power_user
grant select on StockIncomeDoc to power_user
grant select on StockIncomeItem to power_user
grant select on AliveWorkOrders to power_user
grant select on ObjectLock to power_user

-- Таблицы процессов

declare @OK int
declare @SrvID int, @SrvName sysname, @ns nvarchar(500)
declare SrvCursor cursor local for
    select SrvID, SrvName from Services
open SrvCursor
fetch next from SrvCursor
into @SrvID, @SrvName
set @OK = 0
WHILE @@FETCH_STATUS = 0 and @OK <> -3
BEGIN
    if exists (select * from sysobjects where id = object_id(N'Service_' + @SrvName) and OBJECTPROPERTY(id, N'IsTable') = 1) begin
      set @ns = N'grant select, update, insert, delete on Service_' + @SrvName + N' to power_user'
      exec sp_executesql @ns
      if @@ERROR <> 0 set @OK = -3
    end
    fetch next from SrvCursor
    into @SrvID, @SrvName
END
close SrvCursor
deallocate SrvCursor

-- Таблицы справочников
declare @MultiDim bit
declare DicCursor cursor local for
    select DicID, DicName, MultiDim from DicElements
open DicCursor
fetch next from DicCursor
into @SrvID, @SrvName, @MultiDim
set @OK = 0
WHILE @@FETCH_STATUS = 0 and @OK <> -3
BEGIN
    if exists (select * from sysobjects where id = object_id(N'Dic_' + @SrvName) and OBJECTPROPERTY(id, N'IsTable') = 1) begin
      set @ns = N'grant select, update, insert, delete on Dic_' + @SrvName + N' to power_user'
      exec sp_executesql @ns
      if @@ERROR <> 0 set @OK = -3
      if (@MultiDim = 1) and exists (select * from sysobjects where id = object_id(N'DicMulti_' + @SrvName) and OBJECTPROPERTY(id, N'IsTable') = 1) begin
        set @ns = N'grant select, update, insert, delete on DicMulti_' + @SrvName + N' to power_user'
        exec sp_executesql @ns
      end
    end
    fetch next from DicCursor
    into @SrvID, @SrvName, @MultiDim
END
close DicCursor
deallocate DicCursor

--grant execute on up_AddUserIP to power_user
--grant execute on up_ClearUserIP to power_user
--grant execute on up_ComExpToUSD to power_user
grant execute on up_DeleteDictionary to power_user
--grant execute on up_DeleteOrderItem to power_user
grant execute on up_DeleteService to power_user
--grant execute on up_DelOrderItemDependent to power_user
--grant execute on up_DelUserIP to power_user
grant execute on up_DelSrvGroup to power_user
grant execute on up_NewService to power_user
grant execute on up_NewSrvGroup to power_user
grant execute on up_NewTableDictionary to power_user
--grant execute on up_NewWorkCustomer to power_user
grant execute on up_UpdateTableDictionary to power_user

grant execute on up_GetOrderNumber to power_user
grant execute on up_ChangeOrderStatus to power_user
grant execute on up_NewOrder to power_user
grant execute on up_EmergencyNewOrder to power_user
grant execute on up_UpdateOrder to power_user
grant execute on up_SetOrderOwner to power_user
grant execute on up_ChangeOrderState to power_user
grant execute on up_CopyOrder to power_user
grant execute on up_CopyOrder2 to power_user
grant execute on up_DelOrder to power_user
grant execute on up_PurgeAll to power_user
grant execute on up_PurgeOrder to power_user
grant execute on up_RestoreOrder to power_user

--grant execute on up_IsOrderRowLocked to power_user
--grant execute on up_SetOrderLock to power_user
--grant execute on up_DelOrderLock to power_user

grant execute on up_IsObjectLocked to power_user
grant execute on up_SetObjectLock to power_user
grant execute on up_RemoveObjectLock to power_user
grant execute on up_RemoveUserLocks to power_user
grant execute on up_RemoveClassLock to power_user

grant execute on up_NewOrderAttachedFile to power_user

grant execute on up_NewOrderProcessItem to power_user
grant execute on up_UpdateOrderProcessItem to power_user
grant execute on up_UpdateOrderProcessItem2 to power_user
grant execute on up_DeleteOrderProcessItem to power_user
grant execute on up_NewSpecialJob to power_user
grant execute on up_NewProcessJob to power_user
grant execute on up_DeleteJob to power_user
grant execute on up_UnPlanJob to power_user
grant execute on up_UnPlanItem to power_user
grant execute on up_RenumberSplitPartsItem to power_user
grant execute on up_RenumberSplitPartsJob to power_user

grant execute on up_CopyAccessUser to power_user

grant execute on up_GetNoNameKey to power_user
grant execute on up_DeleteContragent to power_user
grant execute on up_NewContragent to power_user
grant execute on up_PurgeContragent to power_user

grant execute on up_AddPayment to power_user
grant execute on up_NewCustomerIncome to power_user
grant execute on up_DeleteCustomerIncome to power_user
grant execute on up_AddPaymentIncome to power_user
--grant execute on up_UpdatePayment to power_user

grant execute on up_SetupUserRoles to power_user
grant execute on up_RegisterChange to power_user
grant execute on up_SelectPage to power_user
grant execute on up_GetRecordCount to power_user
grant execute on up_GetNewMessages to power_user
grant execute on up_AddToGlobalHistory to power_user
grant execute on up_GetCurDate to power_user
grant execute on up_SetNewCourse to power_user
grant execute on up_GetLastCourse to power_user

grant execute on up_NewShipment to power_user
grant execute on up_DeleteShipment to power_user
grant execute on up_NewShipmentDoc to power_user
grant execute on up_DeleteShipmentDoc to power_user
grant execute on up_HistoryAdd to power_user

grant execute on dbo.SplitCount to power_user
grant execute on dbo.SplitCost to power_user
grant execute on dbo.GetPayState to power_user
grant execute on dbo.GetProcessExecState to power_user
grant execute on dbo.GetShipmentState to power_user
grant execute on dbo.GetInkNames to power_user

declare @EditUsers bit, @EditDics bit, @USD bit, @EditProcesses bit, @EditModules bit,  @Upload bit,
  @EditCustomReports bit, @DeleteCustomReports bit, @ViewPayments bit, @EditPayments bit, @AddCustomer bit,
  @ViewInvoices bit, @AddInvoices bit, @DeleteInvoices bit, @ViewShipment bit, @AddShipment bit, @DeleteShipment bit,
  @PermitShipmentApprovement bit, @PermitOrderMaterialsApprovement bit

declare UserCursor cursor local for 
  select Login, EditUsers, EditDics, EditProcesses, EditModules, UploadFiles, SetCourse, 
    EditCustomReports, DeleteCustomReports, ViewPayments, EditPayments, AddCustomer, 
    ViewInvoices, AddInvoices, DeleteInvoices, ShipmentApprovement, OrderMaterialsApprovement,
    ViewShipment, AddShipment, DeleteShipment
  from AccessUser au inner join sysusers su on au.Login = su.name
  where IsRole = 0 

open UserCursor

fetch next from UserCursor into @SrvName, @EditUsers, @EditDics, @EditProcesses, @EditModules, @Upload, @USD,
  @EditCustomReports, @DeleteCustomReports, @ViewPayments, @EditPayments, @AddCustomer, 
  @ViewInvoices, @AddInvoices, @DeleteInvoices, @PermitShipmentApprovement, @PermitOrderMaterialsApprovement,
  @ViewShipment, @AddShipment, @DeleteShipment

set @OK = 0

WHILE @@FETCH_STATUS = 0 and @OK <> -3
BEGIN
  /*if @UserLevel = 0 
    set @ns = N'exec sp_droprolemember ''just_user'', ''' + @SrvName + ''''
  else
    set @ns = N'exec sp_droprolemember ''power_user'', ''' + @SrvName + ''''
  exec sp_executesql @ns*/
  set @ns = N'exec sp_addrolemember ''power_user'', ''' + @SrvName + ''''
  exec sp_executesql @ns

  -- отменяем все предыдущие назначения для конкретного пользователя
  set @ns = N'revoke all privileges on AccessUser from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on AccessKind from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on AccessKindProcess from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on up_CopyAccessUser from [' + @SrvName + ']'
  exec sp_executesql @ns

  if @EditUsers = 0 begin
    set @ns = N'deny update, insert, delete on AccessUser to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update, insert, delete on AccessKind to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update, insert, delete on AccessKindProcess to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_CopyAccessUser to [' + @SrvName + ']'
    exec sp_executesql @ns
  end

  set @ns = N'revoke all privileges on KindOrder from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on KindProcess from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on Services from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on OrderScripts from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on OrderParams from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on SrvFields from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on SrvGridColumns from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on SrvGroups from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on SrvPages from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on up_NewService from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on up_DeleteService from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on up_NewSrvGroup from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on up_DelSrvGroup from [' + @SrvName + ']'
  exec sp_executesql @ns

  if @EditProcesses = 0 begin
    set @ns = N'deny update, insert, delete on KindOrder to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update, insert, delete on KindProcess to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update, insert, delete on Services to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update, insert, delete on OrderScripts to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update, insert, delete on OrderParams to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update, insert, delete on SrvFields to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update, insert, delete on SrvGridColumns to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update, insert, delete on SrvGroups to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update, insert, delete on SrvPages to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_NewService to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_DeleteService to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_NewSrvGroup to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_DelSrvGroup to [' + @SrvName + ']'
    exec sp_executesql @ns
  end

  set @ns = N'revoke all privileges on DicElements from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on DicFolders from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on DicFields from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on up_NewTableDictionary from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on up_DeleteDictionary from [' + @SrvName + ']'
  exec sp_executesql @ns

  if @EditDics = 0 begin
    set @ns = N'deny update, insert, delete on DicElements to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update, insert, delete on DicFolders to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update, insert, delete on DicFields to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_NewTableDictionary to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_DeleteDictionary to [' + @SrvName + ']'
    exec sp_executesql @ns
  end

  set @ns = N'revoke all privileges on ScriptedForms from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on GlobalScripts from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on DisplayInfo from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on EnterpriseSettings from [' + @SrvName + ']'
  exec sp_executesql @ns

  if @EditModules = 0 begin
    set @ns = N'deny update, insert, delete on ScriptedForms to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update, insert, delete on GlobalScripts to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update, insert, delete on DisplayInfo to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update, insert, delete on EnterpriseSettings to [' + @SrvName + ']'
    exec sp_executesql @ns
  end

  set @ns = N'revoke all privileges on CustomReports from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on CustomReportColumns from [' + @SrvName + ']'
  exec sp_executesql @ns

  if @EditCustomReports = 0 begin
    set @ns = N'deny update, insert on CustomReports to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny delete, update, insert on CustomReportColumns to [' + @SrvName + ']'
    exec sp_executesql @ns
  end
  /*else
  begin
    set @ns = N'grant update, insert on CustomReports to ' + @SrvName
    exec sp_executesql @ns
    set @ns = N'grant delete, update, insert on CustomReportColumns to ' + @SrvName
    exec sp_executesql @ns
  end*/

  if @DeleteCustomReports = 0 begin
    set @ns = N'deny delete on CustomReports to [' + @SrvName + ']'
    exec sp_executesql @ns
  end
  /*else
  begin
    set @ns = N'grant delete on CustomReports to ' + @SrvName
    exec sp_executesql @ns
  end*/

  set @ns = N'revoke all privileges on CustomerIncome from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on Payments from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on up_NewCustomerIncome from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on up_DeleteCustomerIncome from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on up_AddPayment from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on up_AddPaymentIncome from [' + @SrvName + ']'
  exec sp_executesql @ns
  --set @ns = N'revoke all privileges on up_UpdatePayment from [' + @SrvName + ']'
  --exec sp_executesql @ns

  if @ViewPayments = 0 
  begin
    set @ns = N'deny select, update, insert, delete on CustomerIncome to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny select, update, insert, delete on Payments to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_NewCustomerIncome to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_DeleteCustomerIncome to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_AddPayment to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_AddPaymentIncome to [' + @SrvName + ']'
    exec sp_executesql @ns
    --set @ns = N'deny execute on up_UpdatePayment to [' + @SrvName + ']'
    --exec sp_executesql @ns
  end
  else
  begin
    set @ns = N'grant select on CustomerIncome to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant select on Payments to [' + @SrvName + ']'
    exec sp_executesql @ns

    if @EditPayments = 0 
    begin
      set @ns = N'deny update, insert on CustomerIncome to [' + @SrvName + ']'
      exec sp_executesql @ns
      set @ns = N'deny update, insert, delete on Payments to [' + @SrvName + ']'
      exec sp_executesql @ns
      set @ns = N'deny execute on up_NewCustomerIncome to [' + @SrvName + ']'
      exec sp_executesql @ns
      set @ns = N'deny execute on up_DeleteCustomerIncome to [' + @SrvName + ']'
      exec sp_executesql @ns
      set @ns = N'deny execute on up_AddPayment to [' + @SrvName + ']'
      exec sp_executesql @ns
      set @ns = N'deny execute on up_AddPaymentIncome to [' + @SrvName + ']'
      exec sp_executesql @ns
      --set @ns = N'deny execute on up_UpdatePayment to [' + @SrvName + ']'
      --exec sp_executesql @ns
    end
    else
    begin
      set @ns = N'grant update, insert on CustomerIncome to [' + @SrvName + ']'
      exec sp_executesql @ns
      -- TODO: а надо ли здесь update - insert?
      set @ns = N'grant update, insert, delete on Payments to [' + @SrvName + ']'
      exec sp_executesql @ns
      set @ns = N'grant execute on up_NewCustomerIncome to [' + @SrvName + ']'
      exec sp_executesql @ns
      set @ns = N'grant execute on up_DeleteCustomerIncome to [' + @SrvName + ']'
      exec sp_executesql @ns
      set @ns = N'grant execute on up_AddPayment to [' + @SrvName + ']'
      exec sp_executesql @ns
      set @ns = N'grant execute on up_AddPaymentIncome to [' + @SrvName + ']'
      exec sp_executesql @ns
      --set @ns = N'grant execute on up_UpdatePayment to [' + @SrvName + ']'
      --exec sp_executesql @ns
    end
  end

/*  if @EditPayments = 0 or @ViewPayments = 0 
  begin
    set @ns = N'deny execute on up_NewCustomerIncome to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_DeleteCustomerIncome to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_AddPayment to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_AddPaymentIncome to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_UpdatePayment to [' + @SrvName + ']'
    exec sp_executesql @ns
  end
  */

  set @ns = N'revoke all privileges on up_SetNewCourse from [' + @SrvName + ']'
  exec sp_executesql @ns

  if @USD = 0 begin
    set @ns = N'deny execute on up_SetNewCourse to [' + @SrvName + ']'
    exec sp_executesql @ns
  end

  set @ns = N'revoke all privileges on PolyCalcVersion from [' + @SrvName + ']'
  exec sp_executesql @ns

  if @Upload = 0 begin
    set @ns = N'deny update, insert, delete on PolyCalcVersion to [' + @SrvName + ']'
    exec sp_executesql @ns
  end

  set @ns = N'revoke all privileges on Customer from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on Persons from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on RelatedContragents from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on up_NewContragent from [' + @SrvName + ']'
  exec sp_executesql @ns

  if @AddCustomer = 0 begin
    set @ns = N'deny insert on Customer to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny insert on Persons to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny insert on RelatedContragents to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_NewContragent to [' + @SrvName + ']'
    exec sp_executesql @ns
  end  
  else
  begin
    set @ns = N'grant insert on Customer to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant insert on Persons to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant insert on RelatedContragents to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant execute on up_NewContragent to [' + @SrvName + ']'
    exec sp_executesql @ns
  end

  set @ns = N'revoke all privileges on up_NewInvoice from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on up_DeleteInvoice from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on Invoices from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke all privileges on InvoiceItems from [' + @SrvName + ']'
  exec sp_executesql @ns

  if @ViewInvoices = 0 begin
    set @ns = N'deny select on Invoices to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny select on InvoiceItems to [' + @SrvName + ']'
    exec sp_executesql @ns
  end  
  else
  begin
    set @ns = N'grant select on Invoices to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant select on InvoiceItems to [' + @SrvName + ']'
    exec sp_executesql @ns
  end

  if @AddInvoices = 0 begin
    set @ns = N'deny execute on up_NewInvoice to [' + @SrvName + ']'
    exec sp_executesql @ns
  end  
  else
  begin
    set @ns = N'grant execute on up_NewInvoice to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant update on Invoices to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant insert, update, delete on InvoiceItems to [' + @SrvName + ']'
    exec sp_executesql @ns
  end

  if @DeleteInvoices = 0 begin
    set @ns = N'deny execute on up_DeleteInvoice to [' + @SrvName + ']'
    exec sp_executesql @ns
  end  
  else
  begin
    set @ns = N'grant execute on up_DeleteInvoice to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant delete on InvoiceItems to [' + @SrvName + ']'
    exec sp_executesql @ns
  end

  set @ns = N'revoke execute on up_NewShipment from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke execute on up_DeleteShipment from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke execute on up_NewShipmentDoc from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke execute on up_DeleteShipmentDoc from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke select, update on Shipment from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke select, update on ShipmentDoc from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke execute on up_NewSaleDoc from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke execute on up_DeleteSaleDoc from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke execute on up_NewSaleItem from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke execute on up_DeleteSaleItem from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke select, update on SaleDocs from [' + @SrvName + ']'
  exec sp_executesql @ns
  set @ns = N'revoke select, update on SaleItems from [' + @SrvName + ']'
  exec sp_executesql @ns

  if @ViewShipment = 0 begin
    set @ns = N'deny select on Shipment to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny select on ShipmentDoc to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny select on SaleDocs to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny select on SaleItems to [' + @SrvName + ']'
    exec sp_executesql @ns
  end  
  else
  begin
    set @ns = N'grant select on Shipment to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant select on ShipmentDoc to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant select on SaleDocs to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant select on SaleItems to [' + @SrvName + ']'
    exec sp_executesql @ns
  end

  if @AddShipment = 0 begin
    set @ns = N'deny execute on up_NewShipment to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_NewShipmentDoc to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update on Shipment to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update on ShipmentDoc to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_NewSaleDoc to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_NewSaleItem to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update on SaleDocs to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny update on SaleItems to [' + @SrvName + ']'
    exec sp_executesql @ns
  end  
  else
  begin
    set @ns = N'grant execute on up_NewShipment to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant execute on up_NewShipmentDoc to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant update on Shipment to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant update on ShipmentDoc to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant execute on up_NewSaleDoc to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant execute on up_NewSaleItem to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant update on SaleDocs to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant update on SaleItems to [' + @SrvName + ']'
    exec sp_executesql @ns
  end

  if @DeleteShipment = 0 begin
    set @ns = N'deny execute on up_DeleteShipment to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_DeleteShipmentDoc to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_DeleteSaleDoc to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'deny execute on up_DeleteSaleItem to [' + @SrvName + ']'
    exec sp_executesql @ns
  end  
  else
  begin
    set @ns = N'grant execute on up_DeleteShipment to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant execute on up_DeleteShipmentDoc to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant execute on up_DeleteSaleDoc to [' + @SrvName + ']'
    exec sp_executesql @ns
    set @ns = N'grant execute on up_DeleteSaleItem to [' + @SrvName + ']'
    exec sp_executesql @ns
  end

  -- Разрешение на отгрузку

  set @ns = N'revoke all privileges on up_UpdateOrderShipmentApproved to [' + @SrvName + ']'
  exec sp_executesql @ns

  if @PermitShipmentApprovement = 0 begin
    set @ns = N'deny execute on up_UpdateOrderShipmentApproved to [' + @SrvName + ']'
    exec sp_executesql @ns
  end  
  else
  begin
    set @ns = N'grant execute on up_UpdateOrderShipmentApproved to [' + @SrvName + ']'
    exec sp_executesql @ns
  end

  -- Разрешение на закупку материалов

  set @ns = N'revoke all privileges on up_UpdateOrderMaterialsApproved to [' + @SrvName + ']'
  exec sp_executesql @ns

  if @PermitOrderMaterialsApprovement = 0 begin
    set @ns = N'deny execute on up_UpdateOrderMaterialsApproved to [' + @SrvName + ']'
    exec sp_executesql @ns
  end  
  else
  begin
    set @ns = N'grant execute on up_UpdateOrderMaterialsApproved to [' + @SrvName + ']'
    exec sp_executesql @ns
  end

  fetch next from UserCursor into @SrvName, @EditUsers, @EditDics, @EditProcesses, @EditModules, @Upload, @USD,
    @EditCustomReports, @DeleteCustomReports, @ViewPayments, @EditPayments, @AddCustomer,
    @ViewInvoices, @AddInvoices, @DeleteInvoices, @PermitShipmentApprovement, @PermitOrderMaterialsApprovement,
    @ViewShipment, @AddShipment, @DeleteShipment
END
close UserCursor
deallocate UserCursor

--- END OF UP_SETUPUSERROLES


go
exec up_SetupUserRoles
go

update DBVersion set Version = 30002
go
