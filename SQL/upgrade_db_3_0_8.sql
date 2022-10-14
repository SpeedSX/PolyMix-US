exec up_NewTableDictionary;1 'ReportPermissionGroups','Права Доступа: Группы отчетов',0,2
go
exec up_NewTableDictionary;1 'Reports','Права Доступа: Отчеты',0,2
go
alter table Dic_Reports add A1 int null
go
insert into DicFields (DicID, FieldName, FieldDesc,FieldType,[Length],[Precision],ReferenceID) values (154, 'A1', 'Група', 100, 0, 0, 153)
go
exec up_NewTableDictionary;1 'ReportUserPermissions','Права Доступа: Отчеты для Пользователей',0,2
go
alter table Dic_ReportUserPermissions add A1 int null
alter table Dic_ReportUserPermissions add A2 bit null
go
insert into DicFields (DicID, FieldName, FieldDesc,FieldType,[Length],[Precision],ReferenceID) values (155, 'A1', 'Група', 100, 0, 0, 153)
insert into DicFields (DicID, FieldName, FieldDesc,FieldType,[Length],[Precision],ReferenceID) values (155, 'A2', 'Доступ', 5, 1, 0, null)
go
ALTER TABLE dbo.CustomReports ADD
	ReportGroupId int NULL
go
ALTER TABLE dbo.GlobalScripts ADD
    ReportGroupId int NULL
go
exec up_SetupUserRoles
go
update DBVersion set Version = 30008
go
