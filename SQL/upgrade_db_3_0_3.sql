alter table Dic_ContragentAttrPermissions add A3 bit null
go
insert into DicFields (DicID, FieldName, FieldDesc,FieldType,[Length],[Precision],ReferenceID) values (152, 'A3', 'Адреси', 5, 1, 0, null)
go

go
update DBVersion set Version = 30003
go
