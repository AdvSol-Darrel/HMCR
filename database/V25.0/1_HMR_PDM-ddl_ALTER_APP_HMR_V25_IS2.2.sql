-- Script generated by Aqua Data Studio Schema Synchronization for MS SQL Server 2016 on Tue Oct 20 10:33:19 PDT 2020
-- Execute this script on:
-- 		HMR V24.0/dbo - This database/schema will be modified
-- to synchronize it with MS SQL Server 2016:
-- 		HMR V25.0/dbo

-- We recommend backing up the database prior to executing the script.

SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Drop trigger dbo.HMR_CODE_LKUP_A_S_IUD_TR
PRINT N'Drop trigger dbo.HMR_CODE_LKUP_A_S_IUD_TR'
GO
DROP TRIGGER [dbo].[HMR_CODE_LKUP_A_S_IUD_TR]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Drop trigger dbo.HMR_ACT_CODE_A_S_IUD_TR
PRINT N'Drop trigger dbo.HMR_ACT_CODE_A_S_IUD_TR'
GO
DROP TRIGGER [dbo].[HMR_ACT_CODE_A_S_IUD_TR]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Drop trigger dbo.HMR_ACT_CODE_I_S_I_TR
PRINT N'Drop trigger dbo.HMR_ACT_CODE_I_S_I_TR'
GO
DROP TRIGGER [dbo].[HMR_ACT_CODE_I_S_I_TR]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Drop trigger dbo.HMR_ACT_CODE_I_S_U_TR
PRINT N'Drop trigger dbo.HMR_ACT_CODE_I_S_U_TR'
GO
DROP TRIGGER [dbo].[HMR_ACT_CODE_I_S_U_TR]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Drop trigger dbo.HMR_CODE_LKUP_I_S_I_TR
PRINT N'Drop trigger dbo.HMR_CODE_LKUP_I_S_I_TR'
GO
DROP TRIGGER [dbo].[HMR_CODE_LKUP_I_S_I_TR]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Drop trigger dbo.HMR_CODE_LKUP_I_S_U_TR
PRINT N'Drop trigger dbo.HMR_CODE_LKUP_I_S_U_TR'
GO
DROP TRIGGER [dbo].[HMR_CODE_LKUP_I_S_U_TR]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create sequence dbo.HMR_SERVICE_AREA_ACTIVITY_ID_SEQ
PRINT N'Create sequence dbo.HMR_SERVICE_AREA_ACTIVITY_ID_SEQ'
GO
CREATE SEQUENCE [dbo].[HMR_SERVICE_AREA_ACTIVITY_ID_SEQ]
	AS bigint
	START WITH 1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 999999999
	NO CYCLE
	CACHE 50
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Alter table dbo.HMR_ACTIVITY_CODE
PRINT N'Alter table dbo.HMR_ACTIVITY_CODE'
GO
ALTER TABLE [dbo].[HMR_ACTIVITY_CODE]
	ADD [MIN_VALUE] numeric(11,2) NULL, 
	[MAX_VALUE] numeric(11,2) NULL, 
	[REPORTING_FREQUENCY] int NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create check constraint dbo.CC_HMR_ACTIVITY_CODE_REPORTING_FREQUENCY
PRINT N'Create check constraint dbo.CC_HMR_ACTIVITY_CODE_REPORTING_FREQUENCY'
GO
ALTER TABLE [dbo].[HMR_ACTIVITY_CODE]
	ADD  CHECK ([REPORTING_FREQUENCY]>=(0) AND [REPORTING_FREQUENCY]<=(366))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create check constraint dbo.CC_HMR_ACTIVITY_CODE_MIN_VALUE
PRINT N'Create check constraint dbo.CC_HMR_ACTIVITY_CODE_MIN_VALUE'
GO
ALTER TABLE [dbo].[HMR_ACTIVITY_CODE]
	ADD  CHECK ([MIN_VALUE]>=(0) AND [MIN_VALUE]<=(999999999.99))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create check constraint dbo.CC_HMR_ACTIVITY_CODE_MAX_VALUE
PRINT N'Create check constraint dbo.CC_HMR_ACTIVITY_CODE_MAX_VALUE'
GO
ALTER TABLE [dbo].[HMR_ACTIVITY_CODE]
	ADD  CHECK ([MAX_VALUE]>=(0) AND [MAX_VALUE]<=(999999999.99))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create table dbo.HMR_SERVICE_AREA_ACTIVITY
PRINT N'Create table dbo.HMR_SERVICE_AREA_ACTIVITY'
GO
CREATE TABLE [dbo].[HMR_SERVICE_AREA_ACTIVITY]  ( 
	[SERVICE_AREA_ACTIVITY_ID]      	numeric(9,0) NOT NULL DEFAULT (NEXT VALUE FOR [HMR_SERVICE_AREA_ACTIVITY_ID_SEQ]),
	[ACTIVITY_CODE_ID]              	numeric(9,0) NOT NULL,
	[SERVICE_AREA_NUMBER]           	numeric(9,0) NOT NULL,
	[END_DATE]                      	datetime NULL,
	[CONCURRENCY_CONTROL_NUMBER]    	bigint NOT NULL DEFAULT ((1)),
	[APP_CREATE_USERID]             	varchar(30) NOT NULL,
	[APP_CREATE_TIMESTAMP]          	datetime NOT NULL,
	[APP_CREATE_USER_GUID]          	uniqueidentifier NOT NULL,
	[APP_CREATE_USER_DIRECTORY]     	varchar(12) NOT NULL,
	[APP_LAST_UPDATE_USERID]        	varchar(30) NOT NULL,
	[APP_LAST_UPDATE_TIMESTAMP]     	datetime NOT NULL,
	[APP_LAST_UPDATE_USER_GUID]     	uniqueidentifier NOT NULL,
	[APP_LAST_UPDATE_USER_DIRECTORY]	varchar(12) NOT NULL,
	[DB_AUDIT_CREATE_USERID]        	varchar(30) NOT NULL DEFAULT (user_name()),
	[DB_AUDIT_CREATE_TIMESTAMP]     	datetime NOT NULL DEFAULT (getutcdate()),
	[DB_AUDIT_LAST_UPDATE_USERID]   	varchar(30) NOT NULL DEFAULT (user_name()),
	[DB_AUDIT_LAST_UPDATE_TIMESTAMP]	datetime NOT NULL DEFAULT (getutcdate()),
	PRIMARY KEY CLUSTERED([SERVICE_AREA_ACTIVITY_ID])
 ON [PRIMARY])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create unique constraint dbo.TUC_HMR_SERVICE_AREA_ACTIVITY_1
PRINT N'Create unique constraint dbo.TUC_HMR_SERVICE_AREA_ACTIVITY_1'
GO
ALTER TABLE [dbo].[HMR_SERVICE_AREA_ACTIVITY]
	ADD UNIQUE ([SERVICE_AREA_NUMBER], [ACTIVITY_CODE_ID])
	WITH (
		DATA_COMPRESSION = NONE
	) ON [PRIMARY]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create sequence dbo.HMR_SERVICE_AREA_ACTIVITY_H_ID_SEQ
PRINT N'Create sequence dbo.HMR_SERVICE_AREA_ACTIVITY_H_ID_SEQ'
GO
CREATE SEQUENCE [dbo].[HMR_SERVICE_AREA_ACTIVITY_H_ID_SEQ]
	AS bigint
	START WITH 1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 999999999
	NO CYCLE
	CACHE 50
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create table dbo.HMR_SERVICE_AREA_ACTIVITY_HIST
PRINT N'Create table dbo.HMR_SERVICE_AREA_ACTIVITY_HIST'
GO
CREATE TABLE [dbo].[HMR_SERVICE_AREA_ACTIVITY_HIST]  ( 
	[SERVICE_AREA_ACTIVITY_HIST_ID] 	bigint NOT NULL DEFAULT (NEXT VALUE FOR [HMR_SERVICE_AREA_ACTIVITY_H_ID_SEQ]),
	[EFFECTIVE_DATE_HIST]           	datetime NOT NULL DEFAULT (getutcdate()),
	[END_DATE_HIST]                 	datetime NULL,
	[SERVICE_AREA_ACTIVITY_ID]      	numeric(9,0) NOT NULL,
	[ACTIVITY_CODE_ID]              	numeric(9,0) NOT NULL,
	[SERVICE_AREA_NUMBER]           	numeric(9,0) NOT NULL,
	[END_DATE]                      	datetime NULL,
	[CONCURRENCY_CONTROL_NUMBER]    	bigint NOT NULL DEFAULT ((1)),
	[APP_CREATE_USERID]             	varchar(30) NOT NULL,
	[APP_CREATE_TIMESTAMP]          	datetime NOT NULL,
	[APP_CREATE_USER_GUID]          	uniqueidentifier NOT NULL,
	[APP_CREATE_USER_DIRECTORY]     	varchar(12) NOT NULL,
	[APP_LAST_UPDATE_USERID]        	varchar(30) NOT NULL,
	[APP_LAST_UPDATE_TIMESTAMP]     	datetime NOT NULL,
	[APP_LAST_UPDATE_USER_GUID]     	uniqueidentifier NOT NULL,
	[APP_LAST_UPDATE_USER_DIRECTORY]	varchar(12) NOT NULL,
	[DB_AUDIT_CREATE_USERID]        	varchar(30) NOT NULL DEFAULT (user_name()),
	[DB_AUDIT_CREATE_TIMESTAMP]     	datetime NOT NULL DEFAULT (getutcdate()),
	[DB_AUDIT_LAST_UPDATE_USERID]   	varchar(30) NOT NULL DEFAULT (user_name()),
	[DB_AUDIT_LAST_UPDATE_TIMESTAMP]	datetime NOT NULL DEFAULT (getutcdate()),
	PRIMARY KEY CLUSTERED([SERVICE_AREA_ACTIVITY_HIST_ID])
 ON [PRIMARY])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Alter table dbo.HMR_CODE_LOOKUP
PRINT N'Alter table dbo.HMR_CODE_LOOKUP'
GO
ALTER TABLE [dbo].[HMR_CODE_LOOKUP]
	ADD [IS_INTEGER_ONLY] bit NOT NULL DEFAULT ((0))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Alter table dbo.HMR_ACTIVITY_CODE_HIST
PRINT N'Alter table dbo.HMR_ACTIVITY_CODE_HIST'
GO
ALTER TABLE [dbo].[HMR_ACTIVITY_CODE_HIST]
	ADD [MIN_VALUE] numeric(11,2) NULL, 
	[MAX_VALUE] numeric(11,2) NULL, 
	[REPORTING_FREQUENCY] int NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create check constraint dbo.CC_HMR_ACTIVITY_CODE_HIST_MAX_VALUE
PRINT N'Create check constraint dbo.CC_HMR_ACTIVITY_CODE_HIST_MAX_VALUE'
GO
ALTER TABLE [dbo].[HMR_ACTIVITY_CODE_HIST]
	ADD  CHECK ([MAX_VALUE]>=(0) AND [MAX_VALUE]<=(999999999.99))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create check constraint dbo.CC_HMR_ACTIVITY_CODE_HIST_MIN_VALUE
PRINT N'Create check constraint dbo.CC_HMR_ACTIVITY_CODE_HIST_MIN_VALUE'
GO
ALTER TABLE [dbo].[HMR_ACTIVITY_CODE_HIST]
	ADD  CHECK ([MIN_VALUE]>=(0) AND [MIN_VALUE]<=(999999999.99))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create check constraint dbo.CC_HMR_ACTIVITY_CODE_HIST_REPORTING_FREQUENCY
PRINT N'Create check constraint dbo.CC_HMR_ACTIVITY_CODE_HIST_REPORTING_FREQUENCY'
GO
ALTER TABLE [dbo].[HMR_ACTIVITY_CODE_HIST]
	ADD  CHECK ([REPORTING_FREQUENCY]>=(0) AND [REPORTING_FREQUENCY]<=(366))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Alter table dbo.HMR_CODE_LOOKUP_HIST
PRINT N'Alter table dbo.HMR_CODE_LOOKUP_HIST'
GO
ALTER TABLE [dbo].[HMR_CODE_LOOKUP_HIST]
	ADD [IS_INTEGER_ONLY] bit NOT NULL DEFAULT 0
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create index dbo.IDX_HMR_SVC_AR_ACT_ACT_CD
PRINT N'Create index dbo.IDX_HMR_SVC_AR_ACT_ACT_CD'
GO
CREATE NONCLUSTERED INDEX [IDX_HMR_SVC_AR_ACT_ACT_CD]
	ON [dbo].[HMR_SERVICE_AREA_ACTIVITY]([ACTIVITY_CODE_ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create index dbo.IDX_HMR_SVC_AR_ACT_SVC_AREA
PRINT N'Create index dbo.IDX_HMR_SVC_AR_ACT_SVC_AREA'
GO
CREATE NONCLUSTERED INDEX [IDX_HMR_SVC_AR_ACT_SVC_AREA]
	ON [dbo].[HMR_SERVICE_AREA_ACTIVITY]([SERVICE_AREA_NUMBER])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create foreign key constraint dbo.HMR_SERVICE_AREA_HMR_SERVICE_AREA_ACTIVITY
PRINT N'Create foreign key constraint dbo.HMR_SERVICE_AREA_HMR_SERVICE_AREA_ACTIVITY'
GO
ALTER TABLE [dbo].[HMR_SERVICE_AREA_ACTIVITY]
	ADD FOREIGN KEY([SERVICE_AREA_NUMBER])
	REFERENCES [dbo].[HMR_SERVICE_AREA]([SERVICE_AREA_NUMBER])
	ON DELETE NO ACTION 
	ON UPDATE NO ACTION 
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create foreign key constraint dbo.HMR_ACTIVITY_CODE_HMR_SERVICE_AREA_ACTIVITY
PRINT N'Create foreign key constraint dbo.HMR_ACTIVITY_CODE_HMR_SERVICE_AREA_ACTIVITY'
GO
ALTER TABLE [dbo].[HMR_SERVICE_AREA_ACTIVITY]
	ADD FOREIGN KEY([ACTIVITY_CODE_ID])
	REFERENCES [dbo].[HMR_ACTIVITY_CODE]([ACTIVITY_CODE_ID])
	ON DELETE NO ACTION 
	ON UPDATE NO ACTION 
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create trigger dbo.HMR_SVC_AR_ACT_A_S_IUD_TR
PRINT N'Create trigger dbo.HMR_SVC_AR_ACT_A_S_IUD_TR'
GO
CREATE TRIGGER [dbo].[HMR_SVC_AR_ACT_A_S_IUD_TR] ON HMR_SERVICE_AREA_ACTIVITY FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    RETURN;

  -- historical
  IF EXISTS(SELECT * FROM deleted)
    update HMR_SERVICE_AREA_ACTIVITY_HIST set END_DATE_HIST = @curr_date where SERVICE_AREA_ACTIVITY_ID in (select SERVICE_AREA_ACTIVITY_ID from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT * FROM inserted)
    insert into HMR_SERVICE_AREA_ACTIVITY_HIST ([SERVICE_AREA_ACTIVITY_ID], [ACTIVITY_CODE_ID], [SERVICE_AREA_NUMBER], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_CREATE_USER_DIRECTORY], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [APP_LAST_UPDATE_USER_DIRECTORY], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], SERVICE_AREA_ACTIVITY_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
      select [SERVICE_AREA_ACTIVITY_ID], [ACTIVITY_CODE_ID], [SERVICE_AREA_NUMBER], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_CREATE_USER_DIRECTORY], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [APP_LAST_UPDATE_USER_DIRECTORY], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[HMR_SERVICE_AREA_ACTIVITY_H_ID_SEQ]) as [SERVICE_AREA_ACTIVITY_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST] from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC hmr_error_handling
END CATCH;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create trigger dbo.HMR_CODE_LKUP_I_S_U_TR
PRINT N'Create trigger dbo.HMR_CODE_LKUP_I_S_U_TR'
GO
CREATE TRIGGER [dbo].[HMR_CODE_LKUP_I_S_U_TR] ON HMR_CODE_LOOKUP INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM deleted)
    RETURN;

  -- validate concurrency control
  if exists (select 1 from inserted, deleted where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.CODE_LOOKUP_ID = deleted.CODE_LOOKUP_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)


  -- update statement
  update HMR_CODE_LOOKUP
    set "CODE_LOOKUP_ID" = inserted."CODE_LOOKUP_ID",
      "CODE_SET" = inserted."CODE_SET",
      "CODE_NAME" = inserted."CODE_NAME",
      "CODE_VALUE_TEXT" = inserted."CODE_VALUE_TEXT",
      "CODE_VALUE_NUM" = inserted."CODE_VALUE_NUM",
      "CODE_VALUE_FORMAT" = inserted."CODE_VALUE_FORMAT",
      "DISPLAY_ORDER" = inserted."DISPLAY_ORDER",
      "END_DATE" = inserted."END_DATE",
      "IS_INTEGER_ONLY" = inserted."IS_INTEGER_ONLY",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from HMR_CODE_LOOKUP
    inner join inserted
    on (HMR_CODE_LOOKUP.CODE_LOOKUP_ID = inserted.CODE_LOOKUP_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC hmr_error_handling
END CATCH;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create trigger dbo.HMR_CODE_LKUP_I_S_I_TR
PRINT N'Create trigger dbo.HMR_CODE_LKUP_I_S_I_TR'
GO
CREATE TRIGGER [dbo].[HMR_CODE_LKUP_I_S_I_TR] ON HMR_CODE_LOOKUP INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;


  insert into HMR_CODE_LOOKUP ("CODE_LOOKUP_ID",
      "CODE_SET",
      "CODE_NAME",
      "CODE_VALUE_TEXT",
      "CODE_VALUE_NUM",
      "CODE_VALUE_FORMAT",
      "DISPLAY_ORDER",
      "END_DATE",        
      "IS_INTEGER_ONLY",
      "CONCURRENCY_CONTROL_NUMBER")
    select "CODE_LOOKUP_ID",
      "CODE_SET",
      "CODE_NAME",
      "CODE_VALUE_TEXT",
      "CODE_VALUE_NUM",
      "CODE_VALUE_FORMAT",
      "DISPLAY_ORDER",
      "END_DATE",       
      "IS_INTEGER_ONLY",
      "CONCURRENCY_CONTROL_NUMBER"
    from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC hmr_error_handling
END CATCH;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create trigger dbo.HMR_ACT_CODE_I_S_U_TR
PRINT N'Create trigger dbo.HMR_ACT_CODE_I_S_U_TR'
GO
CREATE TRIGGER [dbo].[HMR_ACT_CODE_I_S_U_TR] ON HMR_ACTIVITY_CODE INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM deleted)
    RETURN;

  -- validate concurrency control
  if exists (select 1 from inserted, deleted where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.ACTIVITY_CODE_ID = deleted.ACTIVITY_CODE_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)


  -- update statement
  update HMR_ACTIVITY_CODE
    set "ACTIVITY_CODE_ID" = inserted."ACTIVITY_CODE_ID",
      "ACTIVITY_NUMBER" = inserted."ACTIVITY_NUMBER",
      "ACTIVITY_NAME" = inserted."ACTIVITY_NAME",
      "UNIT_OF_MEASURE" = inserted."UNIT_OF_MEASURE",
      "MAINTENANCE_TYPE" = inserted."MAINTENANCE_TYPE",
      "LOCATION_CODE_ID" = inserted."LOCATION_CODE_ID",
      "FEATURE_TYPE" = inserted."FEATURE_TYPE",
      "SP_THRESHOLD_LEVEL" = inserted."SP_THRESHOLD_LEVEL",
      "IS_SITE_NUM_REQUIRED" = inserted."IS_SITE_NUM_REQUIRED",
      "ACTIVITY_APPLICATION" = inserted."ACTIVITY_APPLICATION",
      "END_DATE" = inserted."END_DATE",     
      "ROAD_CLASS_RULE" = inserted."ROAD_CLASS_RULE",
      "ROAD_LENGTH_RULE" = inserted."ROAD_LENGTH_RULE",
      "SURFACE_TYPE_RULE" = inserted."SURFACE_TYPE_RULE",   
      "MIN_VALUE" = inserted."MIN_VALUE",
      "MAX_VALUE" = inserted."MAX_VALUE",
      "REPORTING_FREQUENCY" = inserted."REPORTING_FREQUENCY",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID",
      "APP_LAST_UPDATE_USER_DIRECTORY" = inserted."APP_LAST_UPDATE_USER_DIRECTORY"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from HMR_ACTIVITY_CODE
    inner join inserted
    on (HMR_ACTIVITY_CODE.ACTIVITY_CODE_ID = inserted.ACTIVITY_CODE_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC hmr_error_handling
END CATCH;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create trigger dbo.HMR_SVC_AR_ACT_I_S_I_TR
PRINT N'Create trigger dbo.HMR_SVC_AR_ACT_I_S_I_TR'
GO
CREATE TRIGGER [dbo].[HMR_SVC_AR_ACT_I_S_I_TR] ON HMR_SERVICE_AREA_ACTIVITY INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;

  insert into HMR_SERVICE_AREA_ACTIVITY ("SERVICE_AREA_ACTIVITY_ID",
      "ACTIVITY_CODE_ID",
      "SERVICE_AREA_NUMBER",
      "END_DATE",
      "CONCURRENCY_CONTROL_NUMBER",
      "APP_CREATE_USERID",
      "APP_CREATE_TIMESTAMP",
      "APP_CREATE_USER_GUID",
      "APP_CREATE_USER_DIRECTORY",
      "APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID",
      "APP_LAST_UPDATE_USER_DIRECTORY")
    select "SERVICE_AREA_ACTIVITY_ID",
      "ACTIVITY_CODE_ID",
      "SERVICE_AREA_NUMBER",
      "END_DATE",
      "CONCURRENCY_CONTROL_NUMBER",
      "APP_CREATE_USERID",
      "APP_CREATE_TIMESTAMP",
      "APP_CREATE_USER_GUID",
      "APP_CREATE_USER_DIRECTORY",
      "APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID",
      "APP_LAST_UPDATE_USER_DIRECTORY"
    from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC hmr_error_handling
END CATCH;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create trigger dbo.HMR_ACT_CODE_I_S_I_TR
PRINT N'Create trigger dbo.HMR_ACT_CODE_I_S_I_TR'
GO
CREATE TRIGGER [dbo].[HMR_ACT_CODE_I_S_I_TR] ON HMR_ACTIVITY_CODE INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;


  insert into HMR_ACTIVITY_CODE ("ACTIVITY_CODE_ID",
      "ACTIVITY_NUMBER",
      "ACTIVITY_NAME",
      "UNIT_OF_MEASURE",
      "MAINTENANCE_TYPE",
      "LOCATION_CODE_ID",
      "FEATURE_TYPE",
      "SP_THRESHOLD_LEVEL",
      "IS_SITE_NUM_REQUIRED",
      "ACTIVITY_APPLICATION",
      "END_DATE",
      "ROAD_CLASS_RULE",
      "ROAD_LENGTH_RULE",
      "SURFACE_TYPE_RULE",
      "MIN_VALUE", 
      "MAX_VALUE", 
      "REPORTING_FREQUENCY",
      "CONCURRENCY_CONTROL_NUMBER",
      "APP_CREATE_USERID",
      "APP_CREATE_TIMESTAMP",
      "APP_CREATE_USER_GUID",
      "APP_CREATE_USER_DIRECTORY",
      "APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID",
      "APP_LAST_UPDATE_USER_DIRECTORY")
    select "ACTIVITY_CODE_ID",
      "ACTIVITY_NUMBER",
      "ACTIVITY_NAME",
      "UNIT_OF_MEASURE",
      "MAINTENANCE_TYPE",
      "LOCATION_CODE_ID",
      "FEATURE_TYPE",
      "SP_THRESHOLD_LEVEL",
      "IS_SITE_NUM_REQUIRED",
      "ACTIVITY_APPLICATION",
      "END_DATE",        
      "ROAD_CLASS_RULE",
      "ROAD_LENGTH_RULE",
      "SURFACE_TYPE_RULE",
      "MIN_VALUE", 
      "MAX_VALUE", 
      "REPORTING_FREQUENCY",
      "CONCURRENCY_CONTROL_NUMBER",
      "APP_CREATE_USERID",
      "APP_CREATE_TIMESTAMP",
      "APP_CREATE_USER_GUID",
      "APP_CREATE_USER_DIRECTORY",
      "APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID",
      "APP_LAST_UPDATE_USER_DIRECTORY"
    from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC hmr_error_handling
END CATCH;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create trigger dbo.HMR_ACT_CODE_A_S_IUD_TR
PRINT N'Create trigger dbo.HMR_ACT_CODE_A_S_IUD_TR'
GO
/* ---------------------------------------------------------------------- */
/* Add triggers                                                           */
/* ---------------------------------------------------------------------- */

/* ---------------------------------------------------------------------- */
/* Add triggers                                                           */
/* ---------------------------------------------------------------------- */

CREATE TRIGGER [dbo].[HMR_ACT_CODE_A_S_IUD_TR] ON HMR_ACTIVITY_CODE FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    RETURN;

  -- historical
  IF EXISTS(SELECT * FROM deleted)
    update HMR_ACTIVITY_CODE_HIST set END_DATE_HIST = @curr_date where ACTIVITY_CODE_ID in (select ACTIVITY_CODE_ID from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT * FROM inserted)
    insert into HMR_ACTIVITY_CODE_HIST ([ACTIVITY_CODE_ID], [ACTIVITY_NUMBER], [ACTIVITY_NAME], [UNIT_OF_MEASURE], [MAINTENANCE_TYPE], [LOCATION_CODE_ID], [FEATURE_TYPE], [SP_THRESHOLD_LEVEL], [IS_SITE_NUM_REQUIRED], [ACTIVITY_APPLICATION], [END_DATE], [ROAD_CLASS_RULE], [ROAD_LENGTH_RULE], [SURFACE_TYPE_RULE], [MIN_VALUE], [MAX_VALUE], [REPORTING_FREQUENCY], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_CREATE_USER_DIRECTORY], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [APP_LAST_UPDATE_USER_DIRECTORY], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], ACTIVITY_CODE_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
      select [ACTIVITY_CODE_ID], [ACTIVITY_NUMBER], [ACTIVITY_NAME], [UNIT_OF_MEASURE], [MAINTENANCE_TYPE], [LOCATION_CODE_ID], [FEATURE_TYPE], [SP_THRESHOLD_LEVEL], [IS_SITE_NUM_REQUIRED], [ACTIVITY_APPLICATION], [END_DATE], [ROAD_CLASS_RULE], [ROAD_LENGTH_RULE], [SURFACE_TYPE_RULE], [MIN_VALUE], [MAX_VALUE], [REPORTING_FREQUENCY], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_CREATE_USER_DIRECTORY], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [APP_LAST_UPDATE_USER_DIRECTORY], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[HMR_ACTIVITY_CODE_H_ID_SEQ]) as [ACTIVITY_CODE_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST] from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC hmr_error_handling
END CATCH;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create trigger dbo.HMR_CODE_LKUP_A_S_IUD_TR
PRINT N'Create trigger dbo.HMR_CODE_LKUP_A_S_IUD_TR'
GO
CREATE TRIGGER [dbo].[HMR_CODE_LKUP_A_S_IUD_TR] ON HMR_CODE_LOOKUP FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    RETURN;

  -- historical
  IF EXISTS(SELECT * FROM deleted)
    update HMR_CODE_LOOKUP_HIST set END_DATE_HIST = @curr_date where CODE_LOOKUP_ID in (select CODE_LOOKUP_ID from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT * FROM inserted)
    insert into HMR_CODE_LOOKUP_HIST ([CODE_LOOKUP_ID], [CODE_SET], [CODE_NAME], [CODE_VALUE_TEXT], [CODE_VALUE_NUM], [CODE_VALUE_FORMAT], [DISPLAY_ORDER], [END_DATE], [IS_INTEGER_ONLY], [CONCURRENCY_CONTROL_NUMBER], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], CODE_LOOKUP_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
      select [CODE_LOOKUP_ID], [CODE_SET], [CODE_NAME], [CODE_VALUE_TEXT], [CODE_VALUE_NUM], [CODE_VALUE_FORMAT], [DISPLAY_ORDER], [END_DATE], [IS_INTEGER_ONLY], [CONCURRENCY_CONTROL_NUMBER], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[HMR_CODE_LOOKUP_H_ID_SEQ]) as [CODE_LOOKUP_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST] from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC hmr_error_handling
END CATCH;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create trigger dbo.HMR_SVC_AR_ACT_I_S_U_TR
PRINT N'Create trigger dbo.HMR_SVC_AR_ACT_I_S_U_TR'
GO
CREATE TRIGGER [dbo].[HMR_SVC_AR_ACT_I_S_U_TR] ON HMR_SERVICE_AREA_ACTIVITY INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM deleted)
    RETURN;

  -- validate concurrency control
  if exists (select 1 from inserted, deleted where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.SERVICE_AREA_ACTIVITY_ID = deleted.SERVICE_AREA_ACTIVITY_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)


  -- update statement
  update HMR_SERVICE_AREA_ACTIVITY
    set "SERVICE_AREA_ACTIVITY_ID" = inserted."SERVICE_AREA_ACTIVITY_ID",
      "ACTIVITY_CODE_ID" = inserted."ACTIVITY_CODE_ID",
      "SERVICE_AREA_NUMBER" = inserted."SERVICE_AREA_NUMBER",
      "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID",
      "APP_LAST_UPDATE_USER_DIRECTORY" = inserted."APP_LAST_UPDATE_USER_DIRECTORY"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from HMR_SERVICE_AREA_ACTIVITY
    inner join inserted
    on (HMR_SERVICE_AREA_ACTIVITY.SERVICE_AREA_ACTIVITY_ID = inserted.SERVICE_AREA_ACTIVITY_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC hmr_error_handling
END CATCH;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
   IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
   PRINT 'The database update failed'
END
GO
