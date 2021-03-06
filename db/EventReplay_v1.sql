USE [master]
GO
/****** Object:  Database [EventReplay]    Script Date: 9/21/2017 5:10:17 PM ******/
CREATE DATABASE [EventReplay]
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
/****** Object:  Table [dbo].[Contract]    Script Date: 9/21/2017 5:10:17 PM ******/
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
/****** Object:  Table [dbo].[EntityLock]    Script Date: 9/21/2017 5:10:17 PM ******/
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
/****** Object:  Table [dbo].[Event]    Script Date: 9/21/2017 5:10:17 PM ******/
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
/****** Object:  Table [dbo].[Subscriber]    Script Date: 9/21/2017 5:10:17 PM ******/
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
/****** Object:  Table [dbo].[Subscription]    Script Date: 9/21/2017 5:10:17 PM ******/
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
/****** Object:  Index [IX_Contract]    Script Date: 9/21/2017 5:10:18 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Contract] ON [dbo].[Contract]
(
	[ContractAddress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_EntityLock_EntityName_EntityId]    Script Date: 9/21/2017 5:10:18 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_EntityLock_EntityName_EntityId] ON [dbo].[EntityLock]
(
	[EntityName] ASC,
	[EntityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Event_EventName]    Script Date: 9/21/2017 5:10:18 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Event_EventName] ON [dbo].[Event]
(
	[EventName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
/****** Object:  Index [IX_Subscriber_SubscriberName]    Script Date: 9/21/2017 5:10:18 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Subscriber_SubscriberName] ON [dbo].[Subscriber]
(
	[SubscriberId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
/****** Object:  Index [IX_Subscription_SubscriberId_EventId]    Script Date: 9/21/2017 5:10:18 PM ******/
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
USE [master]
GO
ALTER DATABASE [EventReplay] SET  READ_WRITE 
GO
