/*    ==Scripting Parameters==

    Source Database Engine Edition : Microsoft Azure SQL Database Edition
    Source Database Engine Type : Microsoft Azure SQL Database

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/
USE [master]
GO
/****** Object:  Database [EventReplay]    Script Date: 9/24/2017 2:41:59 AM ******/
CREATE DATABASE [EventReplay]
GO
ALTER DATABASE [EventReplay] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [EventReplay].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [EventReplay] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [EventReplay] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [EventReplay] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [EventReplay] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [EventReplay] SET ARITHABORT OFF 
GO
ALTER DATABASE [EventReplay] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [EventReplay] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [EventReplay] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [EventReplay] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [EventReplay] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [EventReplay] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [EventReplay] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [EventReplay] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [EventReplay] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [EventReplay] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [EventReplay] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [EventReplay] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [EventReplay] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [EventReplay] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [EventReplay] SET  MULTI_USER 
GO
ALTER DATABASE [EventReplay] SET DB_CHAINING OFF 
GO
ALTER DATABASE [EventReplay] SET ENCRYPTION ON
GO
ALTER DATABASE [EventReplay] SET QUERY_STORE = ON
GO
ALTER DATABASE [EventReplay] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 7), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 10, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO)
GO
USE [EventReplay]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [EventReplay]
GO
/****** Object:  Table [dbo].[Contract]    Script Date: 9/24/2017 2:41:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract](
	[ContractId] [int] IDENTITY(1,1) NOT NULL,
	[ContractName] [varchar](50) NOT NULL,
	[ContractAddress] [varchar](42) NOT NULL,
	[ContractABI] [varchar](4096) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Contract] PRIMARY KEY CLUSTERED 
(
	[ContractId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
/****** Object:  Table [dbo].[EntityLock]    Script Date: 9/24/2017 2:41:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EntityLock](
	[EntityLockId] [int] IDENTITY(1,1) NOT NULL,
	[EntityName] [varchar](50) NOT NULL,
	[EntityId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_EntityLock] PRIMARY KEY CLUSTERED 
(
	[EntityLockId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
/****** Object:  Table [dbo].[Event]    Script Date: 9/24/2017 2:41:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Event](
	[EventId] [int] IDENTITY(1,1) NOT NULL,
	[ContractId] [int] NOT NULL,
	[EventName] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
/****** Object:  Table [dbo].[Subscriber]    Script Date: 9/24/2017 2:42:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subscriber](
	[SubscriberId] [int] IDENTITY(1,1) NOT NULL,
	[SubscriberName] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Subscriber] PRIMARY KEY CLUSTERED 
(
	[SubscriberId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
/****** Object:  Table [dbo].[Subscription]    Script Date: 9/24/2017 2:42:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subscription](
	[SubscriptionId] [int] IDENTITY(1,1) NOT NULL,
	[SubscriberId] [int] NOT NULL,
	[EventId] [int] NOT NULL,
	[LastBlockRead] [bigint] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Subscription] PRIMARY KEY CLUSTERED 
(
	[SubscriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Contract]    Script Date: 9/24/2017 2:42:00 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Contract] ON [dbo].[Contract]
(
	[ContractAddress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_EntityLock_EntityName_EntityId]    Script Date: 9/24/2017 2:42:00 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_EntityLock_EntityName_EntityId] ON [dbo].[EntityLock]
(
	[EntityName] ASC,
	[EntityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Event_EventName]    Script Date: 9/24/2017 2:42:00 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Event_EventName] ON [dbo].[Event]
(
	[EventName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
/****** Object:  Index [IX_Subscriber_SubscriberName]    Script Date: 9/24/2017 2:42:00 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Subscriber_SubscriberName] ON [dbo].[Subscriber]
(
	[SubscriberId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
/****** Object:  Index [IX_Subscription_SubscriberId_EventId]    Script Date: 9/24/2017 2:42:00 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Subscription_SubscriberId_EventId] ON [dbo].[Subscription]
(
	[SubscriberId] ASC,
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
ALTER TABLE [dbo].[Contract] ADD  CONSTRAINT [DF_Contract_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Contract] ADD  CONSTRAINT [DF_Contract_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Contract] ADD  CONSTRAINT [DF_Contract_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Contract] ADD  CONSTRAINT [DF_Contract_UpdatedBy]  DEFAULT ((0)) FOR [UpdatedBy]
GO
ALTER TABLE [dbo].[Contract] ADD  CONSTRAINT [DF_Contract_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [DF_Event_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [DF_Event_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [DF_Event_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [DF_Event_UpdatedBy]  DEFAULT ((0)) FOR [UpdatedBy]
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [DF_Event_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[Subscriber] ADD  CONSTRAINT [DF_Subscriber_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Subscriber] ADD  CONSTRAINT [DF_Subscriber_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Subscriber] ADD  CONSTRAINT [DF_Subscriber_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Subscriber] ADD  CONSTRAINT [DF_Subscriber_UpdatedBy]  DEFAULT ((0)) FOR [UpdatedBy]
GO
ALTER TABLE [dbo].[Subscriber] ADD  CONSTRAINT [DF_Subscriber_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[Subscription] ADD  CONSTRAINT [DF_Subscription_LastBlockRead]  DEFAULT ((0)) FOR [LastBlockRead]
GO
ALTER TABLE [dbo].[Subscription] ADD  CONSTRAINT [DF_Subscription_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Subscription] ADD  CONSTRAINT [DF_Subscription_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Subscription] ADD  CONSTRAINT [DF_Subscription_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Subscription] ADD  CONSTRAINT [DF_Subscription_UpdatedBy]  DEFAULT ((0)) FOR [UpdatedBy]
GO
ALTER TABLE [dbo].[Subscription] ADD  CONSTRAINT [DF_Subscription_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_Contract] FOREIGN KEY([ContractId])
REFERENCES [dbo].[Contract] ([ContractId])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_Contract]
GO
ALTER TABLE [dbo].[Subscription]  WITH CHECK ADD  CONSTRAINT [FK_Subscription_Event] FOREIGN KEY([EventId])
REFERENCES [dbo].[Event] ([EventId])
GO
ALTER TABLE [dbo].[Subscription] CHECK CONSTRAINT [FK_Subscription_Event]
GO
ALTER TABLE [dbo].[Subscription]  WITH CHECK ADD  CONSTRAINT [FK_Subscription_Subscriber] FOREIGN KEY([SubscriberId])
REFERENCES [dbo].[Subscriber] ([SubscriberId])
GO
ALTER TABLE [dbo].[Subscription] CHECK CONSTRAINT [FK_Subscription_Subscriber]
GO
/****** Object:  StoredProcedure [dbo].[Contract_GetList]    Script Date: 9/24/2017 2:42:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
---------------------------------------------------------------------------------------------------------
--COPYRIGHT (C) 2017 Title Source Inc.
---------------------------------------------------------------------------------------------------------
--Contract_GetList
---------------------------------------------------------------------------------------------------------
--  ** SAMPLE CODE: USE WITH CAUTION. CONSULT WITH AUTHOR BEFORE USING IN PRODUCTION IF POSSIBLE. **
--
--
--Revision History
--Date                 Author                                                Description
-------------------    ----------------------                                ----------------------------
2017-09-22             Bryan Bedard (BryanBedard@titlesource.com)            Initial version
---------------------------------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[Contract_GetList] (
  @ContractId INT = NULL,
  @ContractName VARCHAR(50) = NULL,
  @ContractAddress VARCHAR(42) = NULL,
  @IsActive BIT = 1
) AS

SELECT [Contract].[ContractId] AS ContractContractId,
  [Contract].[ContractName] AS ContractContractName,
  [Contract].[ContractAddress] AS ContractContractAddresss,
  [Contract].[ContractABI] AS ContractContractABI,
  [Contract].[IsActive] AS ContractIsActive,
  [Contract].[CreatedBy] AS ContractCreatedBy,
  [Contract].[CreatedDate] AS ContractCreatedDate,
  [Contract].[UpdatedBy] AS ContractUpdatedBy,
  [Contract].[UpdatedDate] AS ContractUpdatedDate

FROM [dbo].[Contract]

WHERE ((@ContractId IS NULL) OR ([Contract].[ContractId] = @ContractId))
  AND ((@ContractName IS NULL) OR ([Contract].[ContractName] = @ContractName))
  AND ((@ContractAddress IS NULL) OR ([Contract].[ContractAddress] = @ContractAddress))
  AND ((@IsaCtive IS NULL) OR ([Contract].[IsActive] = @IsActive))

GO
/****** Object:  StoredProcedure [dbo].[Contract_Save]    Script Date: 9/24/2017 2:42:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
---------------------------------------------------------------------------------------------------------
--COPYRIGHT (C) 2017 Title Source Inc.
---------------------------------------------------------------------------------------------------------
--Contract_Save
---------------------------------------------------------------------------------------------------------
--  ** SAMPLE CODE: USE WITH CAUTION. CONSULT WITH AUTHOR BEFORE USING IN PRODUCTION IF POSSIBLE. **
--
--
--Revision History
--Date                 Author                                                Description
-------------------    ----------------------                                ----------------------------
2017-09-21             Bryan Bedard (BryanBedard@titlesource.com)            Initial version
---------------------------------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[Contract_Save] (
  @ContractId INT,
  @ContractName VARCHAR(50),
  @ContractAddress VARCHAR(42),
  @ContractABI VARCHAR(4096),
  @IsActive BIT,
  @CreatedBy INT,
  @UpdatedBy INT,
  @IsDelete BIT = 0
) AS

MERGE [dbo].[Contract]
USING (SELECT @ContractId AS ContractId) AS TableVariable ON [dbo].[Contract].[ContractId] = [TableVariable].[ContractId]
WHEN MATCHED AND @IsDelete <> 0 THEN
  DELETE
WHEN MATCHED AND @IsDelete = 0 THEN 
  UPDATE
    SET ContractName = @ContractName,
	  ContractAddress = @ContractAddress,
	  ContractABI = @ContractABI,
	  IsActive = @IsActive,
	  UpdatedBy = @UpdatedBy,
	  UpdatedDate = GETDATE()

WHEN NOT MATCHED THEN
  INSERT(
    ContractName,
	ContractAddress,
	ContractABI,
	IsActive,
	CreatedBy,
	UpdatedBy)
  VALUES(
    @ContractName,
	@ContractAddress,
	@ContractABI,
	@IsActive,
	@CreatedBy,
	@UpdatedBy
  )
	
OUTPUT
  INSERTED.ContractId AS ContractContractId,
  INSERTED.ContractName AS ContractContractName,
  INSERTED.ContractAddress AS ContractContractAddress,
  INSERTED.ContractABI AS ContractContractABI,
  INSERTED.IsActive AS ContractIsActive,
  INSERTED.CreatedBy AS ContractCreatedBy,
  INSERTED.CreatedDate AS ContractCreatedDate,
  INSERTED.UpdatedBy AS ContractUpdatedBy,
  INSERTED.UpdatedDate AS ContractUpdatedDate;

GO
/****** Object:  StoredProcedure [dbo].[EntityLock_GetList]    Script Date: 9/24/2017 2:42:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
---------------------------------------------------------------------------------------------------------
--COPYRIGHT (C) 2017 Title Source Inc.
---------------------------------------------------------------------------------------------------------
--EntityLock_GetList
---------------------------------------------------------------------------------------------------------
--  ** SAMPLE CODE: USE WITH CAUTION. CONSULT WITH AUTHOR BEFORE USING IN PRODUCTION IF POSSIBLE. **
--
--
--Revision History
--Date                 Author                                                Description
-------------------    ----------------------                                ----------------------------
2017-09-22             Bryan Bedard (BryanBedard@titlesource.com)            Initial version
---------------------------------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[EntityLock_GetList] (
  @EntityLockId INT = NULL,
  @EntityName VARCHAR(50) = NULL,
  @EntityId INT = NULL
) AS

SELECT [EntityLock].[EntityLockId] AS EntityLockEntityLockId,
  [EntityLock].[EntityName] AS EntityLockEntityName,
  [EntityLock].[EntityId] AS EntityLockEntityId,
  [EntityLock].[CreatedBy] AS EntityLockCreatedBy,
  [EntityLock].[CreatedDate] AS EntityLockCreatedDate,
  [EntityLock].[UpdatedBy] AS EntityLockUpdatedBy,
  [EntityLock].[UpdatedDate] AS EntityLockUpdatedDate

FROM [dbo].[EntityLock]

WHERE ((@EntityLockId IS NULL) OR ([EntityLock].[EntityLockId] = @EntityLockId))
  AND ((@EntityName IS NULL) OR ([EntityLock].[EntityName] = @EntityName))
  AND ((@EntityId IS NULL) OR ([EntityLock].[EntityId] = @EntityId))

GO
/****** Object:  StoredProcedure [dbo].[EntityLock_Save]    Script Date: 9/24/2017 2:42:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
---------------------------------------------------------------------------------------------------------
--COPYRIGHT (C) 2017 Title Source Inc.
---------------------------------------------------------------------------------------------------------
--EntityLock_Save
---------------------------------------------------------------------------------------------------------
--  ** SAMPLE CODE: USE WITH CAUTION. CONSULT WITH AUTHOR BEFORE USING IN PRODUCTION IF POSSIBLE. **
--
--
--Revision History
--Date                 Author                                                Description
-------------------    ----------------------                                ----------------------------
2017-09-21             Bryan Bedard (BryanBedard@titlesource.com)            Initial version
---------------------------------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[EntityLock_Save] (
  @EntityLockId INT,
  @EntityName VARCHAR(50),
  @EntityId INT,
  @CreatedBy INT,
  @UpdatedBy INT,
  @IsDelete BIT = 0
) AS

MERGE [dbo].[EntityLock]
USING (SELECT @EntityLockId AS EntityLockId) AS TableVariable ON [dbo].[EntityLock].[EntityLockId] = [TableVariable].[EntityLockId]
WHEN MATCHED AND @IsDelete <> 0 THEN
  DELETE
WHEN MATCHED AND @IsDelete = 0 THEN 
  UPDATE
    SET EntityName = @EntityName,
	  EntityId = @EntityId,
	  UpdatedBy = @UpdatedBy,
	  UpdatedDate = GETDATE()

WHEN NOT MATCHED THEN
  INSERT(
    EntityName,
	EntityId,
	CreatedBy,
	UpdatedBy)
  VALUES(
    @EntityName,
	@EntityId,
	@CreatedBy,
	@UpdatedBy
  )
	
OUTPUT
  INSERTED.EntityLockId AS EntityLockEntityLockId,
  INSERTED.EntityName AS EntityLockEntitykName,
  INSERTED.EntityId AS EntityLockEntityEntityId,
  INSERTED.CreatedBy AS EntityLockCreatedBy,
  INSERTED.CreatedDate AS EntityLockCreatedDate,
  INSERTED.UpdatedBy AS EntityLockUpdatedBy,
  INSERTED.UpdatedDate AS EntityLockUpdatedDate;


GO
/****** Object:  StoredProcedure [dbo].[Event_GetList]    Script Date: 9/24/2017 2:42:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
---------------------------------------------------------------------------------------------------------
--COPYRIGHT (C) 2017 Title Source Inc.
---------------------------------------------------------------------------------------------------------
--Event_GetList
---------------------------------------------------------------------------------------------------------
--  ** SAMPLE CODE: USE WITH CAUTION. CONSULT WITH AUTHOR BEFORE USING IN PRODUCTION IF POSSIBLE. **
--
--
--Revision History
--Date                 Author                                                Description
-------------------    ----------------------                                ----------------------------
2017-09-22             Bryan Bedard (BryanBedard@titlesource.com)            Initial version
---------------------------------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[Event_GetList] (
  @EventId INT = NULL,
  @ContractId INT = NULL,
  @ContractAddress VARCHAR(42) = NULL,
  @EventName VARCHAR(50) = NULL,
  @IsActive BIT = 1
) AS

SELECT [Event].[EventId] AS EventEventId,
  [Event].[ContractId] AS EventContractId,
  [Contract].[ContractAddress] AS ContractContractAddress,
  [Event].[EventName] AS EventEventName,
  [Event].[IsActive] AS EventIsActive,
  [Event].[CreatedBy] AS EventCreatedBy,
  [Event].[CreatedDate] AS EventCreatedDate,
  [Event].[UpdatedBy] AS EventUpdatedBy,
  [Event].[UpdatedDate] AS EventUpdatedDate

FROM [dbo].[Event]
  INNER JOIN [dbo].[Contract] ON [Contract].[ContractId] = [Event].[ContractId]

WHERE ((@EventId IS NULL) OR ([Event].[EventId] = @EventId))
  AND ((@ContractId IS NULL) OR ([Event].[ContractId] = @ContractId))
  AND ((@ContractAddress IS NULL) OR ([Contract].[ContractAddress] = @ContractAddress))
  AND ((@EventName IS NULL) OR ([Event].[EventName] = @EventName))
  AND ((@IsaCtive IS NULL) OR ([Event].[IsActive] = @IsActive))

GO
/****** Object:  StoredProcedure [dbo].[Event_Save]    Script Date: 9/24/2017 2:42:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
---------------------------------------------------------------------------------------------------------
--COPYRIGHT (C) 2017 Title Source Inc.
---------------------------------------------------------------------------------------------------------
--Event_Save
---------------------------------------------------------------------------------------------------------
--  ** SAMPLE CODE: USE WITH CAUTION. CONSULT WITH AUTHOR BEFORE USING IN PRODUCTION IF POSSIBLE. **
--
--
--Revision History
--Date                 Author                                                Description
-------------------    ----------------------                                ----------------------------
2017-09-21             Bryan Bedard (BryanBedard@titlesource.com)            Initial version
---------------------------------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[Event_Save] (
  @EventId INT,
  @ContractId INT,
  @EventName VARCHAR(50),
  @IsActive BIT,
  @CreatedBy INT,
  @UpdatedBy INT,
  @IsDelete BIT = 0
) AS

MERGE [dbo].[Event]
USING (SELECT @EventId AS EventId) AS TableVariable ON [dbo].[Event].[EventId] = [TableVariable].[EventId]
WHEN MATCHED AND @IsDelete <> 0 THEN
  DELETE
WHEN MATCHED AND @IsDelete = 0 THEN 
  UPDATE
    SET ContractId = @ContractId, 
	  EventName = @EventName,
	  IsActive = @IsActive,
	  UpdatedBy = @UpdatedBy,
	  UpdatedDate = GETDATE()

WHEN NOT MATCHED THEN
  INSERT(
    ContractId,
    EventName,
	IsActive,
	CreatedBy,
	UpdatedBy)
  VALUES(
    @ContractId,
    @EventName,
	@IsActive,
	@CreatedBy,
	@UpdatedBy
  )
	
OUTPUT
  INSERTED.EventId AS EventEventId,
  INSERTED.ContractId AS EventContractId,
  INSERTED.EventName AS EventEventName,
  INSERTED.IsActive AS EventIsActive,
  INSERTED.CreatedBy AS EventCreatedBy,
  INSERTED.CreatedDate AS EventCreatedDate,
  INSERTED.UpdatedBy AS EventUpdatedBy,
  INSERTED.UpdatedDate AS EventUpdatedDate;


GO
/****** Object:  StoredProcedure [dbo].[Subscriber_GetList]    Script Date: 9/24/2017 2:42:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
---------------------------------------------------------------------------------------------------------
--COPYRIGHT (C) 2017 Title Source Inc.
---------------------------------------------------------------------------------------------------------
--Subscriber_GetList
---------------------------------------------------------------------------------------------------------
--  ** SAMPLE CODE: USE WITH CAUTION. CONSULT WITH AUTHOR BEFORE USING IN PRODUCTION IF POSSIBLE. **
--
--
--Revision History
--Date                 Author                                                Description
-------------------    ----------------------                                ----------------------------
2017-09-22             Bryan Bedard (BryanBedard@titlesource.com)            Initial version
---------------------------------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[Subscriber_GetList] (
  @SubscriberId INT = NULL,
  @SubscriberName VARCHAR(50) = NULL,
  @IsActive BIT = 1
) AS

SELECT [Subscriber].[SubscriberId] AS SubscriberSubscriberId,
  [Subscriber].[SubscriberName] AS SubscriberSubscriberName,
  [Subscriber].[IsActive] AS SubscriberIsActive,
  [Subscriber].[CreatedBy] AS SubscriberCreatedBy,
  [Subscriber].[CreatedDate] AS SubscriberCreatedDate,
  [Subscriber].[UpdatedBy] AS SubscriberUpdatedBy,
  [Subscriber].[UpdatedDate] AS SubscriberUpdatedDate

FROM [dbo].[Subscriber]

WHERE ((@SubscriberId IS NULL) OR ([Subscriber].[SubscriberId] = @SubscriberId))
  AND ((@SubscriberName IS NULL) OR ([Subscriber].[SubscriberName] = @SubscriberName))
  AND ((@IsaCtive IS NULL) OR ([Subscriber].[IsActive] = @IsActive))

GO
/****** Object:  StoredProcedure [dbo].[Subscriber_Save]    Script Date: 9/24/2017 2:42:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
---------------------------------------------------------------------------------------------------------
--COPYRIGHT (C) 2017 Title Source Inc.
---------------------------------------------------------------------------------------------------------
--Subscriber_Save
---------------------------------------------------------------------------------------------------------
--  ** SAMPLE CODE: USE WITH CAUTION. CONSULT WITH AUTHOR BEFORE USING IN PRODUCTION IF POSSIBLE. **
--
--
--Revision History
--Date                 Author                                                Description
-------------------    ----------------------                                ----------------------------
2017-09-21             Bryan Bedard (BryanBedard@titlesource.com)            Initial version
---------------------------------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[Subscriber_Save] (
  @SubscriberId INT,
  @SubscriberName VARCHAR(50),
  @IsActive BIT,
  @CreatedBy INT,
  @UpdatedBy INT,
  @IsDelete BIT = 0
) AS

MERGE [dbo].[Subscriber]
USING (SELECT @SubscriberId AS SubscriberId) AS TableVariable ON [dbo].[Subscriber].[SubscriberId] = [TableVariable].[SubscriberId]
WHEN MATCHED AND @IsDelete <> 0 THEN
  DELETE
WHEN MATCHED AND @IsDelete = 0 THEN 
  UPDATE
    SET SubscriberName = @SubscriberName,
	  IsActive = @IsActive,
	  UpdatedBy = @UpdatedBy,
	  UpdatedDate = GETDATE()

WHEN NOT MATCHED THEN
  INSERT(
    SubscriberName,
	IsActive,
	CreatedBy,
	UpdatedBy)
  VALUES(
    @SubscriberName,
	@IsActive,
	@CreatedBy,
	@UpdatedBy
  )
	
OUTPUT
  INSERTED.SubscriberId AS SubscriberSubscriberId,
  INSERTED.SubscriberName AS SubscriberSubscriberName,
  INSERTED.IsActive AS SubscriberIsActive,
  INSERTED.CreatedBy AS SubscriberCreatedBy,
  INSERTED.CreatedDate AS SubscriberCreatedDate,
  INSERTED.UpdatedBy AS SubscriberUpdatedBy,
  INSERTED.UpdatedDate AS SubscriberUpdatedDate;


GO
/****** Object:  StoredProcedure [dbo].[Subscription_GetList]    Script Date: 9/24/2017 2:42:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
---------------------------------------------------------------------------------------------------------
--COPYRIGHT (C) 2017 Title Source Inc.
---------------------------------------------------------------------------------------------------------
--Subscription_GetList
---------------------------------------------------------------------------------------------------------
--  ** SAMPLE CODE: USE WITH CAUTION. CONSULT WITH AUTHOR BEFORE USING IN PRODUCTION IF POSSIBLE. **
--
--
--Revision History
--Date                 Author                                                Description
-------------------    ----------------------                                ----------------------------
2017-09-22             Bryan Bedard (BryanBedard@titlesource.com)            Initial version
---------------------------------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[Subscription_GetList] (
  @SubscriptionId INT = NULL,
  @SubscriberId INT = NULL,
  @SubscriberName VARCHAR(50) = NULL,
  @ContractId INT = NULL,
  @ContractAddress VARCHAR(42) = NULL,
  @EventId INT = NULL,
  @EventName VARCHAR(50) = NULL,
  @IsActive BIT = 1
) AS

SELECT [Subscription].[SubscriptionId] AS SubscriptionSubscriptionId,
  [Subscription].[SubscriberId] AS SubscriptionSubscriberId,
  [Subscriber].[SubscriberName] AS SubscriberSubscriberName,
  [Contract].[ContractId] AS ContractContractId,
  [Contract].[ContractAddress] AS ContractContractAddress,
  [Subscription].[EventId] AS SubscriptionEventId,
  [Event].[EventName] AS EventEventName,
  [Subscription].[LastBlockRead] AS SubscriptionLastBlockRead,
  [Subscription].[IsActive] AS SubscriptionIsActive,
  [Subscription].[CreatedBy] AS SubscriptionCreatedBy,
  [Subscription].[CreatedDate] AS SubscriptionCreatedDate,
  [Subscription].[UpdatedBy] AS SubscriptionUpdatedBy,
  [Subscription].[UpdatedDate] AS SubscriptionUpdatedDate

FROM [dbo].[Subscription]
  INNER JOIN [dbo].[Subscriber] ON [Subscriber].[SubscriberId] = [Subscription].[SubscriberId]
  INNER JOIN [dbo].[Event] ON [Event].[EventId] = [Subscription].[EventId]
  INNER JOIN [dbo].[Contract] ON [Contract].[ContractId] = [Event].[ContractId]

WHERE ((@SubscriptionId IS NULL) OR ([Subscription].[SubscriptionId] = @SubscriptionId))
  AND ((@SubscriberId IS NULL) OR ([Subscription].[SubscriberId] = @SubscriberId))
  AND ((@SubscriberName IS NULL) OR ([Subscriber].[SubscriberName] = @SubscriberName))
  AND ((@ContractId IS NULL) OR ([Contract].[ContractId] = @ContractId))
  AND ((@ContractAddress IS NULL) OR ([Contract].[ContractAddress] = @ContractAddress))
  AND ((@EventId IS NULL) OR ([Subscription].[EventId] = @EventId))
  AND ((@EventName IS NULL) OR ([Event].[EventName] = @EventName))
  AND ((@IsaCtive IS NULL) OR ([Subscription].[IsActive] = @IsActive))

GO
/****** Object:  StoredProcedure [dbo].[Subscription_Save]    Script Date: 9/24/2017 2:42:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
---------------------------------------------------------------------------------------------------------
--COPYRIGHT (C) 2017 Title Source Inc.
---------------------------------------------------------------------------------------------------------
--Subscription_Save
---------------------------------------------------------------------------------------------------------
--  ** SAMPLE CODE: USE WITH CAUTION. CONSULT WITH AUTHOR BEFORE USING IN PRODUCTION IF POSSIBLE. **
--
--
--Revision History
--Date                 Author                                                Description
-------------------    ----------------------                                ----------------------------
2017-09-21             Bryan Bedard (BryanBedard@titlesource.com)            Initial version
---------------------------------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[Subscription_Save] (
  @SubscriptionId INT,
  @SubscriberId INT,
  @EventId INT,
  @LastBlockRead BIGINT,
  @IsActive BIT,
  @CreatedBy INT,
  @UpdatedBy INT,
  @IsDelete BIT = 0
) AS

MERGE [dbo].[Subscription]
USING (SELECT @SubscriptionId AS SubscriptionId) AS TableVariable ON [dbo].[Subscription].[SubscriptionId] = [TableVariable].[SubscriptionId]
WHEN MATCHED AND @IsDelete <> 0 THEN
  DELETE
WHEN MATCHED AND @IsDelete = 0 THEN 
  UPDATE
    SET SubscriberId = @SubscriberId,
	  EventId = @EventId,
	  LastBlockRead = @LastBlockRead,
	  IsActive = @IsActive,
	  UpdatedBy = @UpdatedBy,
	  UpdatedDate = GETDATE()

WHEN NOT MATCHED THEN
  INSERT(
    SubscriberId,
	EventId,
	LastBlockRead,
	IsActive,
	CreatedBy,
	UpdatedBy)
  VALUES(
    @SubscriberId,
	@EventId,
	@LastBlockRead,
	@IsActive,
	@CreatedBy,
	@UpdatedBy
  )
	
OUTPUT
  INSERTED.SubscriptionId AS SubscriptionSubscriptionId,
  INSERTED.SubscriberId AS SubscriptionSubscriberId,
  INSERTED.EventId AS SubscriptionEventId,
  INSERTED.LastBlockRead AS SubscriptionLastBlockRead,
  INSERTED.IsActive AS SubscriptionIsActive,
  INSERTED.CreatedBy AS SubscriptionCreatedBy,
  INSERTED.CreatedDate AS SubscriptionCreatedDate,
  INSERTED.UpdatedBy AS SubscriptionUpdatedBy,
  INSERTED.UpdatedDate AS SubscriptionUpdatedDate;


GO
USE [master]
GO
ALTER DATABASE [EventReplay] SET  READ_WRITE 
GO
