CREATE   TRIGGER [dbo].[TR_Shipment_Insert]
ON [dbo].[Shipment]
FOR INSERT 
AS 
BEGIN
  declare @s varchar(4000), @OrderID int, @ShipmentDocNum int
  declare @NewItemText varchar(128), @NewQuantity int, @NewBatchNum int

  if @@ROWCOUNT > 0 and SYSTEM_USER <> 'sa' begin

    select top 1
		@NewItemText = ItemText, 
		@NewQuantity = Quantity, 
		@NewBatchNum = BatchNum,
		@ShipmentDocNum = sd.ShipmentDocNum,
		@OrderID = OrderID
    from inserted i inner join ShipmentDoc sd on sd.ShipmentDocID = i.ShipmentDocID

	print @ShipmentDocNum

    set @s = 'Отгрузка (документ № ' + cast(@ShipmentDocNum as varchar(15)) + ') '
		+ ', Наименование: "' + @NewItemText + '"'
		+ ', Кол-во: ' + cast(@NewQuantity as varchar(15))
		+ ', Кол-во пачек: ' + cast(ISNULL(@NewBatchNum, 0) as varchar(15))

    exec up_HistoryAdd 2, @s, @OrderID
  end
END

GO

ALTER TABLE [dbo].[Shipment] ENABLE TRIGGER [TR_Shipment_Insert]
GO


update DBVersion set Version = 30009
go