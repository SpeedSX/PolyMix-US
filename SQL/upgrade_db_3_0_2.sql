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


update DBVersion set Version = 30002
go
