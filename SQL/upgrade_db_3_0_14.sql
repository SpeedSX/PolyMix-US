SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[EnabledMix]
with schemabinding
as
  select j.JobID, opi.ItemID, OrderID, Part, ProductOut, ProductIn, ProcessID, j.EquipCode, j.PlanFinishDate, j.FactFinishDate,
   ss.DefaultEquipGroupCode, wo.OrderState, cc.Name as CustomerName, wo.Comment, wo.ID_Number, opi.ItemDesc, wo.FinishDate,
   j.FactStartDate, j.PlanStartDate, opi.EstimatedDuration, opi.OwnCost, opi.ItemProfit, opi.SideCount, opi.Multiplier,
   j.JobComment, j.JobAlert, opi.SplitMode1, opi.SplitMode2, opi.SplitMode3, j.SplitPart1, j.SplitPart2, j.SplitPart3, j.FactProductOut,
   wo.Customer, j.IsPaused, j.Executor, opi.AutoSplit, j.TimeLocked, j.JobColor, wo.KindID, wo.CreatorName
  from dbo.OrderProcessItem opi
    inner join dbo.WorkOrder wo on wo.N = opi.OrderID 
    inner join dbo.Job j on j.ItemID = opi.ItemID 
    inner join dbo.Customer cc on cc.N = wo.Customer 
    inner join dbo.Services ss on ss.SrvID = opi.ProcessID 
  where opi.Enabled = 1 and wo.IsDraft = 0 and wo.IsDeleted = 0
GO


/****** Object:  Index [IX_EnabledMix_JobID]    Script Date: 02/06/2023 20:44:04 ******/
CREATE UNIQUE CLUSTERED INDEX [IX_EnabledMix_JobID] ON [dbo].[EnabledMix] 
(
	[JobID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [IX_EnabledMix_EquipCode] ON [dbo].[EnabledMix] 
(
	[EquipCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_EnabledMix_ItemID]    Script Date: 02/06/2023 20:43:45 ******/
CREATE NONCLUSTERED INDEX [IX_EnabledMix_ItemID] ON [dbo].[EnabledMix] 
(
	[ItemID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


/****** Object:  Index [IX_EnabledMix_OrderID]    Script Date: 02/06/2023 20:44:18 ******/
CREATE NONCLUSTERED INDEX [IX_EnabledMix_OrderID] ON [dbo].[EnabledMix] 
(
	[OrderID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


/****** Object:  Index [IX_EnabledMix_OrderState]    Script Date: 02/06/2023 20:44:37 ******/
CREATE NONCLUSTERED INDEX [IX_EnabledMix_OrderState] ON [dbo].[EnabledMix] 
(
	[OrderState] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


