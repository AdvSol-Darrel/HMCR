-- Script generated by Aqua Data Studio Schema Synchronization for MS SQL Server 2016 on Wed Oct 07 16:12:21 PDT 2020
-- Execute this script on:
-- 		HMR_DEV/dbo - This database/schema will be modified
-- to synchronize it with MS SQL Server 2016:
-- 		HMR V24.0/dbo

-- We recommend backing up the database prior to executing the script.
USE HMR_DEV; -- uncomment appropriate instance
--USE HMR_TST;
--USE HMR_UAT;
--USE HMR_PRD;
GO

SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
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

-- Drop view dbo.HMR_WILDLIFE_REPORT_VW
PRINT N'Drop view dbo.HMR_WILDLIFE_REPORT_VW'
GO
DROP VIEW [dbo].[HMR_WILDLIFE_REPORT_VW]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Drop view dbo.HMR_ROCKFALL_REPORT_VW
PRINT N'Drop view dbo.HMR_ROCKFALL_REPORT_VW'
GO
DROP VIEW [dbo].[HMR_ROCKFALL_REPORT_VW]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Drop view dbo.HMR_WORK_REPORT_VW
PRINT N'Drop view dbo.HMR_WORK_REPORT_VW'
GO
DROP VIEW [dbo].[HMR_WORK_REPORT_VW]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Drop procedure dbo.hmr_error_handling
PRINT N'Drop procedure dbo.hmr_error_handling'
GO
DROP PROCEDURE [dbo].[hmr_error_handling]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create sequence dbo.HMR_ACTIVITY_RULE_CODE_ID_SEQ
PRINT N'Create sequence dbo.HMR_ACTIVITY_RULE_CODE_ID_SEQ'
GO
CREATE SEQUENCE [dbo].[HMR_ACTIVITY_RULE_CODE_ID_SEQ]
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

-- Create table dbo.HMRX_TableDefinitions
PRINT N'Create table dbo.HMRX_TableDefinitions'
GO
CREATE TABLE [dbo].[HMRX_TableDefinitions]  ( 
	[TABLE_NAME] 	nvarchar(255) NULL,
	[TABLE_ALIAS]	nvarchar(255) NULL,
	[HIST]       	nvarchar(1) NULL,
	[DESCRIPTION]	nvarchar(max) NULL 
	)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create sequence dbo.HMR_ACTIVITY_RULE_ID_SEQ
PRINT N'Create sequence dbo.HMR_ACTIVITY_RULE_ID_SEQ'
GO
CREATE SEQUENCE [dbo].[HMR_ACTIVITY_RULE_ID_SEQ]
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

-- Create procedure dbo.hmr_error_handling
PRINT N'Create procedure dbo.hmr_error_handling'
GO
/* ---------------------------------------------------------------------- */
/* Add procedures                                                         */
/* ---------------------------------------------------------------------- */

/* ---------------------------------------------------------------------- */
/* Add procedures                                                         */
/* ---------------------------------------------------------------------- */

CREATE PROCEDURE [dbo].[hmr_error_handling] AS

  begin
    DECLARE @errmsg   nvarchar(2048),
      @severity tinyint,
      @state    tinyint,
      @errno    int,
      @proc     sysname,
      @lineno   int

    SELECT @errmsg = error_message(), @severity = error_severity(),
      @state  = error_state(), @errno = error_number(),
      @proc   = error_procedure(), @lineno = error_line()

    IF @errmsg NOT LIKE '***%'
      BEGIN
        SELECT @errmsg = '*** ' + coalesce(quotename(@proc), '<dynamic SQL>') +
          ', Line ' + ltrim(str(@lineno)) + '. Errno ' +
          ltrim(str(@errno)) + ': ' + @errmsg
      END

    RAISERROR('%s', @severity, @state, @errmsg)
  end
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create sequence dbo.HMR_ACTIVITY_CODE_RULE_ID_SEQ
PRINT N'Create sequence dbo.HMR_ACTIVITY_CODE_RULE_ID_SEQ'
GO
CREATE SEQUENCE [dbo].[HMR_ACTIVITY_CODE_RULE_ID_SEQ]
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

-- Create table dbo.HMR_ACTIVITY_CODE_RULE
PRINT N'Create table dbo.HMR_ACTIVITY_CODE_RULE'
GO
CREATE TABLE [dbo].[HMR_ACTIVITY_CODE_RULE]  ( 
	[ACTIVITY_CODE_RULE_ID]         	numeric(9,0) NOT NULL DEFAULT (NEXT VALUE FOR [HMR_ACTIVITY_CODE_RULE_ID_SEQ]),
	[ACTIVITY_RULE_SET]             	varchar(20) NOT NULL,
	[ACTIVITY_RULE_NAME]            	nvarchar(150) NOT NULL,
	[ACTIVITY_RULE_EXEC_NAME]       	varchar(150) NOT NULL,
	[DISPLAY_ORDER]                 	numeric(3,0) NULL,
	[END_DATE]                      	datetime NULL,
	[CONCURRENCY_CONTROL_NUMBER]    	bigint NOT NULL DEFAULT ((1)),
	[DB_AUDIT_CREATE_USERID]        	varchar(30) NOT NULL DEFAULT (user_name()),
	[DB_AUDIT_CREATE_TIMESTAMP]     	datetime NOT NULL DEFAULT (getutcdate()),
	[DB_AUDIT_LAST_UPDATE_USERID]   	varchar(30) NOT NULL DEFAULT (user_name()),
	[DB_AUDIT_LAST_UPDATE_TIMESTAMP]	datetime NOT NULL DEFAULT (getutcdate()),
	PRIMARY KEY CLUSTERED([ACTIVITY_CODE_RULE_ID])
 ON [PRIMARY])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Alter table dbo.HMR_ACTIVITY_CODE
PRINT N'Alter table dbo.HMR_ACTIVITY_CODE'
GO
ALTER TABLE [dbo].[HMR_ACTIVITY_CODE]
	ADD [ROAD_CLASS_RULE] numeric(9,0) NOT NULL DEFAULT ((0)), 
	[ROAD_LENGTH_RULE] numeric(9,0) NOT NULL DEFAULT ((0)), 
	[SURFACE_TYPE_RULE] numeric(9,0) NOT NULL DEFAULT ((0))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Alter table dbo.HMR_ACTIVITY_CODE_HIST
PRINT N'Alter table dbo.HMR_ACTIVITY_CODE_HIST'
GO
ALTER TABLE [dbo].[HMR_ACTIVITY_CODE_HIST]
	ADD [ROAD_CLASS_RULE] numeric(9,0) NOT NULL DEFAULT ((0)), 
	[ROAD_LENGTH_RULE] numeric(9,0) NOT NULL DEFAULT ((0)), 
	[SURFACE_TYPE_RULE] numeric(9,0) NOT NULL DEFAULT ((0))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create view dbo.HMR_WORK_REPORT_VW
PRINT N'Create view dbo.HMR_WORK_REPORT_VW'
GO
/* ---------------------------------------------------------------------- */
/* Add views                                                              */
/* ---------------------------------------------------------------------- */

/* ---------------------------------------------------------------------- */
/* Add views                                                              */
/* ---------------------------------------------------------------------- */

/* Update 23/04/2020

i) Added spatial warning thresholds

*/


CREATE VIEW [dbo].[HMR_WORK_REPORT_VW] AS
	SELECT
      wrkrpt.WORK_REPORT_ID
      ,'WORK_REPORT' AS REPORT_TYPE
	  ,wrkrpt.RECORD_TYPE
      ,CAST(wrkrpt.[SERVICE_AREA] AS numeric) AS SERVICE_AREA
      ,wrkrpt.RECORD_NUMBER
      ,wrkrpt.TASK_NUMBER
      ,wrkrpt.ACTIVITY_NUMBER
	  ,actcode.ACTIVITY_NAME
      ,wrkrpt.START_DATE
      ,wrkrpt.END_DATE
      ,wrkrpt.ACCOMPLISHMENT
      ,wrkrpt.UNIT_OF_MEASURE
      ,wrkrpt.POSTED_DATE
      ,wrkrpt.HIGHWAY_UNIQUE
	  ,wrkrpt.HIGHWAY_UNIQUE_NAME
	  ,wrkrpt.HIGHWAY_UNIQUE_LENGTH
      ,wrkrpt.LANDMARK
      ,wrkrpt.START_OFFSET
      ,wrkrpt.END_OFFSET
      ,wrkrpt.START_LATITUDE
      ,wrkrpt.START_LONGITUDE
	  ,subm_rw.START_VARIANCE
      ,wrkrpt.END_LATITUDE
      ,wrkrpt.END_LONGITUDE
	  ,subm_rw.END_VARIANCE
	  ,subm_rw.WARNING_SP_THRESHOLD
	  ,wrkrpt.WORK_LENGTH
	  ,CASE
			WHEN ISNULL(subm_rw.START_VARIANCE,0) > ISNULL(subm_rw.WARNING_SP_THRESHOLD,0)
				OR ISNULL(subm_rw.END_VARIANCE,0) > ISNULL(subm_rw.WARNING_SP_THRESHOLD,0)
			THEN 'Y' ELSE 'N'
	   END IS_OVER_SP_THRESHOLD
      ,wrkrpt.STRUCTURE_NUMBER
      ,wrkrpt.SITE_NUMBER
      ,wrkrpt.VALUE_OF_WORK
      ,wrkrpt.COMMENTS
      ,wrkrpt.GEOMETRY
	  ,wrkrpt.SUBMISSION_OBJECT_ID
	  ,CAST(subm_obj.[FILE_NAME] AS varchar) AS FILE_NAME
      ,wrkrpt.ROW_NUM
      ,CAST(subm_stat.[STATUS_CODE] + ' - ' + subm_stat.[DESCRIPTION] AS varchar) AS VALIDATION_STATUS
      ,CAST(wrkrpt.APP_CREATE_TIMESTAMP AS datetime) AS APP_CREATE_TIMESTAMP_UTC
	  ,CAST(wrkrpt.APP_LAST_UPDATE_TIMESTAMP  AS datetime) AS APP_LAST_UPDATE_TIMESTAMP_UTC
  FROM HMR_WORK_REPORT wrkrpt
  INNER JOIN HMR_SUBMISSION_OBJECT subm_obj ON wrkrpt.SUBMISSION_OBJECT_ID = subm_obj.SUBMISSION_OBJECT_ID
  LEFT OUTER JOIN HMR_ACTIVITY_CODE actcode ON wrkrpt.ACTIVITY_NUMBER = actcode.ACTIVITY_NUMBER
  LEFT OUTER JOIN HMR_SUBMISSION_ROW subm_rw ON wrkrpt.ROW_ID = subm_rw.ROW_ID
  LEFT OUTER JOIN HMR_SUBMISSION_STATUS subm_stat ON subm_rw.ROW_STATUS_ID = subm_stat.STATUS_ID
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create view dbo.HMR_ROCKFALL_REPORT_VW
PRINT N'Create view dbo.HMR_ROCKFALL_REPORT_VW'
GO
/* Update 23/04/2020

i) Added spatial warning thresholds

*/


CREATE VIEW [dbo].[HMR_ROCKFALL_REPORT_VW] AS
SELECT
      rckflrpt.[ROCKFALL_REPORT_ID]
      ,'ROCKFALL_REPORT' AS REPORT_TYPE
      ,CAST(rckflrpt.[RECORD_TYPE] AS varchar) AS RECORD_TYPE
      ,CAST(rckflrpt.[SERVICE_AREA] AS numeric) AS SERVICE_AREA
	  ,rckflrpt.[MCRR_INCIDENT_NUMBER]
      ,rckflrpt.[ESTIMATED_ROCKFALL_DATE]
      ,rckflrpt.[ESTIMATED_ROCKFALL_TIME]
      ,rckflrpt.[START_LATITUDE]
      ,rckflrpt.[START_LONGITUDE]
	  ,subm_rw.[START_VARIANCE]
      ,rckflrpt.[END_LATITUDE]
      ,rckflrpt.[END_LONGITUDE]
	  ,subm_rw.[END_VARIANCE]
	  ,subm_rw.[WARNING_SP_THRESHOLD]
	  ,CASE
			WHEN ISNULL(subm_rw.START_VARIANCE,0) > ISNULL(subm_rw.WARNING_SP_THRESHOLD,0)
				OR ISNULL(subm_rw.END_VARIANCE,0) > ISNULL(subm_rw.WARNING_SP_THRESHOLD,0)
			THEN 'Y' ELSE 'N'
	   END IS_OVER_SP_THRESHOLD
      ,rckflrpt.[HIGHWAY_UNIQUE]
      ,rckflrpt.[HIGHWAY_UNIQUE_NAME]
      ,rckflrpt.[HIGHWAY_UNIQUE_LENGTH]
      ,rckflrpt.[LANDMARK]
      ,rckflrpt.[LANDMARK_NAME]
      ,rckflrpt.[START_OFFSET]
      ,rckflrpt.[END_OFFSET]
      ,rckflrpt.[DIRECTION_FROM_LANDMARK]
      ,rckflrpt.[LOCATION_DESCRIPTION]
      ,rckflrpt.[TRAVELLED_LANES_VOLUME]
      ,rckflrpt.[OTHER_TRAVELLED_LANES_VOLUME]
      ,rckflrpt.[DITCH_VOLUME]
      ,rckflrpt.[OTHER_DITCH_VOLUME]
      ,rckflrpt.[HEAVY_PRECIP]
      ,rckflrpt.[FREEZE_THAW]
      ,rckflrpt.[DITCH_SNOW_ICE]
      ,rckflrpt.[VEHICLE_DAMAGE]
      ,rckflrpt.[COMMENTS]
      ,rckflrpt.[REPORTER_NAME]
      ,rckflrpt.[MC_PHONE_NUMBER]
	  ,usr.[BUSINESS_LEGAL_NAME] AS MC_NAME
      ,rckflrpt.[REPORT_DATE]
      ,rckflrpt.[GEOMETRY]
      ,rckflrpt.SUBMISSION_OBJECT_ID
	  ,CAST(subm_obj.[FILE_NAME] AS varchar) AS FILE_NAME
      ,rckflrpt.[ROW_NUM]
      ,CAST(subm_stat.[STATUS_CODE] + ' - ' + subm_stat.[DESCRIPTION] AS varchar) AS VALIDATION_STATUS
	  ,CAST(rckflrpt.APP_CREATE_TIMESTAMP AS datetime) AS APP_CREATE_TIMESTAMP_UTC
	  ,CAST(rckflrpt.APP_LAST_UPDATE_TIMESTAMP  AS datetime) AS APP_LAST_UPDATE_TIMESTAMP_UTC
  FROM HMR_ROCKFALL_REPORT rckflrpt
  INNER JOIN HMR_SUBMISSION_OBJECT subm_obj ON rckflrpt.SUBMISSION_OBJECT_ID = subm_obj.SUBMISSION_OBJECT_ID
  LEFT OUTER JOIN HMR_SUBMISSION_ROW subm_rw ON rckflrpt.ROW_ID = subm_rw.ROW_ID
  LEFT OUTER JOIN HMR_SUBMISSION_STATUS subm_stat ON subm_rw.ROW_STATUS_ID = subm_stat.STATUS_ID
  LEFT OUTER JOIN HMR_SYSTEM_USER usr ON rckflrpt.APP_CREATE_USER_GUID = usr.APP_CREATE_USER_GUID
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create view dbo.HMR_WILDLIFE_REPORT_VW
PRINT N'Create view dbo.HMR_WILDLIFE_REPORT_VW'
GO
/* Update 23/04/2020

i) Added spatial warning thresholds

*/

CREATE VIEW [dbo].[HMR_WILDLIFE_REPORT_VW] AS
      SELECT
	   wldlfrpt.[WILDLIFE_RECORD_ID]
	  ,'WILDLIFE_REPORT' AS REPORT_TYPE
      ,wldlfrpt.[RECORD_TYPE]
      ,CAST(wldlfrpt.[SERVICE_AREA] AS numeric) AS SERVICE_AREA
      ,wldlfrpt.[ACCIDENT_DATE]
      ,wldlfrpt.[TIME_OF_KILL]
      ,wldlfrpt.[LATITUDE]
      ,wldlfrpt.[LONGITUDE]
	  ,subm_rw.[START_VARIANCE]	AS SPATIAL_VARIANCE
	  ,subm_rw.[WARNING_SP_THRESHOLD]
	  ,CASE
			WHEN ISNULL(subm_rw.START_VARIANCE,0) > ISNULL(subm_rw.WARNING_SP_THRESHOLD,0)
				OR ISNULL(subm_rw.END_VARIANCE,0) > ISNULL(subm_rw.WARNING_SP_THRESHOLD,0)
			THEN 'Y' ELSE 'N'
	   END IS_OVER_SP_THRESHOLD
      ,wldlfrpt.[HIGHWAY_UNIQUE]
      ,wldlfrpt.[HIGHWAY_UNIQUE_NAME]
      ,wldlfrpt.[HIGHWAY_UNIQUE_LENGTH]
      ,wldlfrpt.[LANDMARK]
      ,wldlfrpt.[OFFSET]
      ,wldlfrpt.[NEAREST_TOWN]
      ,wldlfrpt.[WILDLIFE_SIGN]
      ,wldlfrpt.[QUANTITY]
      ,wldlfrpt.[SPECIES]
      ,wldlfrpt.[SEX]
      ,wldlfrpt.[AGE]
      ,wldlfrpt.[COMMENT]
      ,wldlfrpt.[GEOMETRY]
      ,CAST(wldlfrpt.[SUBMISSION_OBJECT_ID] AS numeric) AS SUBMISSION_OBJECT_ID
	  ,CAST(subm_obj.[FILE_NAME] AS varchar) AS FILE_NAME
	  ,wldlfrpt.[ROW_NUM]
      ,CAST(subm_stat.[STATUS_CODE] + ' - ' + subm_stat.[DESCRIPTION] AS varchar) AS VALIDATION_STATUS
      ,CAST(wldlfrpt.APP_CREATE_TIMESTAMP AS datetime) AS APP_CREATE_TIMESTAMP_UTC
	  ,CAST(wldlfrpt.APP_LAST_UPDATE_TIMESTAMP  AS datetime) AS APP_LAST_UPDATE_TIMESTAMP_UTC
  FROM [dbo].[HMR_WILDLIFE_REPORT] wldlfrpt
  INNER JOIN HMR_SUBMISSION_OBJECT subm_obj ON wldlfrpt.SUBMISSION_OBJECT_ID = subm_obj.SUBMISSION_OBJECT_ID
  LEFT OUTER JOIN HMR_SUBMISSION_ROW subm_rw ON wldlfrpt.ROW_ID = subm_rw.ROW_ID
  LEFT OUTER JOIN HMR_SUBMISSION_STATUS subm_stat ON subm_rw.ROW_STATUS_ID = subm_stat.STATUS_ID
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
    insert into HMR_ACTIVITY_CODE_HIST ([ACTIVITY_CODE_ID], [ACTIVITY_NUMBER], [ACTIVITY_NAME], [UNIT_OF_MEASURE], [MAINTENANCE_TYPE], [LOCATION_CODE_ID], [FEATURE_TYPE], [SP_THRESHOLD_LEVEL], [IS_SITE_NUM_REQUIRED], [ACTIVITY_APPLICATION], [END_DATE], [ROAD_CLASS_RULE], [ROAD_LENGTH_RULE], [SURFACE_TYPE_RULE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_CREATE_USER_DIRECTORY], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [APP_LAST_UPDATE_USER_DIRECTORY], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], ACTIVITY_CODE_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
      select [ACTIVITY_CODE_ID], [ACTIVITY_NUMBER], [ACTIVITY_NAME], [UNIT_OF_MEASURE], [MAINTENANCE_TYPE], [LOCATION_CODE_ID], [FEATURE_TYPE], [SP_THRESHOLD_LEVEL], [IS_SITE_NUM_REQUIRED], [ACTIVITY_APPLICATION], [END_DATE], [ROAD_CLASS_RULE], [ROAD_LENGTH_RULE], [SURFACE_TYPE_RULE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_CREATE_USER_DIRECTORY], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [APP_LAST_UPDATE_USER_DIRECTORY], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[HMR_ACTIVITY_CODE_H_ID_SEQ]) as [ACTIVITY_CODE_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST] from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC hmr_error_handling
END CATCH;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create trigger dbo.HMR_ACT_CD_RL_I_S_U_TR
PRINT N'Create trigger dbo.HMR_ACT_CD_RL_I_S_U_TR'
GO
CREATE TRIGGER [dbo].[HMR_ACT_CD_RL_I_S_U_TR] ON HMR_ACTIVITY_CODE_RULE INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM deleted)
    RETURN;

  -- validate concurrency control
  if exists (select 1 from inserted, deleted where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.ACTIVITY_CODE_RULE_ID = deleted.ACTIVITY_CODE_RULE_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)


  -- update statement
  update HMR_ACTIVITY_CODE_RULE
    set "ACTIVITY_CODE_RULE_ID" = inserted."ACTIVITY_CODE_RULE_ID",
      "ACTIVITY_RULE_SET" = inserted."ACTIVITY_RULE_SET",
      "ACTIVITY_RULE_NAME" = inserted."ACTIVITY_RULE_NAME",
      "ACTIVITY_RULE_EXEC_NAME" = inserted."ACTIVITY_RULE_EXEC_NAME",
      "DISPLAY_ORDER" = inserted."DISPLAY_ORDER",
      "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from HMR_ACTIVITY_CODE_RULE
    inner join inserted
    on (HMR_ACTIVITY_CODE_RULE.ACTIVITY_CODE_RULE_ID = inserted.ACTIVITY_CODE_RULE_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC hmr_error_handling
END CATCH;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create trigger dbo.HMR_ACT_CD_RL_I_S_I_TR
PRINT N'Create trigger dbo.HMR_ACT_CD_RL_I_S_I_TR'
GO
CREATE TRIGGER [dbo].[HMR_ACT_CD_RL_I_S_I_TR] ON HMR_ACTIVITY_CODE_RULE INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;


  insert into HMR_ACTIVITY_CODE_RULE (
      "ACTIVITY_CODE_RULE_ID",
      "ACTIVITY_RULE_SET",
      "ACTIVITY_RULE_NAME",
      "ACTIVITY_RULE_EXEC_NAME",
      "DISPLAY_ORDER",
      "END_DATE",
      "CONCURRENCY_CONTROL_NUMBER")
    select "ACTIVITY_CODE_RULE_ID",
      "ACTIVITY_RULE_SET",
      "ACTIVITY_RULE_NAME",
      "ACTIVITY_RULE_EXEC_NAME",
      "DISPLAY_ORDER",
      "END_DATE",
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
