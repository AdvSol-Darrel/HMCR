-- Script generated by Aqua Data Studio Schema Synchronization for MS SQL Server 2016 on Thu Nov 19 16:01:42 PST 2020
-- Execute this script on:
-- 		HMR V25.0/dbo - This database/schema will be modified
-- to synchronize it with MS SQL Server 2016:
-- 		HMR V27.0/dbo

-- We recommend backing up the database prior to executing the script.

SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Drop trigger dbo.HMR_RCKFL_RPT_I_S_I_TR
PRINT N'Drop trigger dbo.HMR_RCKFL_RPT_I_S_I_TR'
GO
DROP TRIGGER [dbo].[HMR_RCKFL_RPT_I_S_I_TR]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Drop trigger dbo.HMR_WRK_RPT_I_S_I_TR
PRINT N'Drop trigger dbo.HMR_WRK_RPT_I_S_I_TR'
GO
DROP TRIGGER [dbo].[HMR_WRK_RPT_I_S_I_TR]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Drop trigger dbo.HMR_WRK_RPT_I_S_U_TR
PRINT N'Drop trigger dbo.HMR_WRK_RPT_I_S_U_TR'
GO
DROP TRIGGER [dbo].[HMR_WRK_RPT_I_S_U_TR]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Drop trigger dbo.HMR_RCKFL_RPT_I_S_U_TR
PRINT N'Drop trigger dbo.HMR_RCKFL_RPT_I_S_U_TR'
GO
DROP TRIGGER [dbo].[HMR_RCKFL_RPT_I_S_U_TR]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Drop trigger dbo.HMR_RCKFL_RPT_A_S_IUD_TR
PRINT N'Drop trigger dbo.HMR_RCKFL_RPT_A_S_IUD_TR'
GO
DROP TRIGGER [dbo].[HMR_RCKFL_RPT_A_S_IUD_TR]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Drop trigger dbo.HMR_WRK_RPT_A_S_IUD_TR
PRINT N'Drop trigger dbo.HMR_WRK_RPT_A_S_IUD_TR'
GO
DROP TRIGGER [dbo].[HMR_WRK_RPT_A_S_IUD_TR]
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

-- Alter table dbo.HMR_WORK_REPORT
PRINT N'Alter table dbo.HMR_WORK_REPORT'
GO
ALTER TABLE [dbo].[HMR_WORK_REPORT]
	ADD [RECORD_VERSION_NUMBER] int NOT NULL DEFAULT ((1))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Alter table dbo.HMR_WORK_REPORT_HIST
PRINT N'Alter table dbo.HMR_WORK_REPORT_HIST'
GO
ALTER TABLE [dbo].[HMR_WORK_REPORT_HIST]
	ADD [RECORD_VERSION_NUMBER] int NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Alter table dbo.HMR_ROCKFALL_REPORT
PRINT N'Alter table dbo.HMR_ROCKFALL_REPORT'
GO
ALTER TABLE [dbo].[HMR_ROCKFALL_REPORT]
	ADD [RECORD_VERSION_NUMBER] int NOT NULL DEFAULT ((1))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Alter table dbo.HMR_ROCKFALL_REPORT_HIST
PRINT N'Alter table dbo.HMR_ROCKFALL_REPORT_HIST'
GO
ALTER TABLE [dbo].[HMR_ROCKFALL_REPORT_HIST]
	ADD [RECORD_VERSION_NUMBER] int NULL
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
	  ,CAST(subm_obj.APP_CREATE_TIMESTAMP  AS datetime) AS SUBMISSION_DATE
	  ,wrkrpt.RECORD_VERSION_NUMBER
	  ,REPLACE((SELECT distinct FIELDMESSAGE FROM OPENJSON(subm_rw.WARNING_DETAIL,'$.fieldMessages') 
			WITH (FIELD nvarchar(255) '$.field', FIELDMESSAGE nvarchar(255) '$.messages[0]') WHERE charindex('Minimum / Maximum Value Validation', FIELD) >= 1 ), ',', '/') AS 'MIN_MAX_VALUE_VALID_WARNING'
	  ,REPLACE((SELECT distinct FIELDMESSAGE FROM OPENJSON(subm_rw.WARNING_DETAIL,'$.fieldMessages') 
			WITH (FIELD nvarchar(255) '$.field', FIELDMESSAGE nvarchar(255) '$.messages[0]') WHERE charindex('Data Precision Validation', FIELD) >= 1 ), ',', '/') AS 'DATA_PRECISION_VALID_WARNING'
	  ,REPLACE((SELECT distinct FIELDMESSAGE FROM OPENJSON(subm_rw.WARNING_DETAIL,'$.fieldMessages') 
			WITH (FIELD nvarchar(255) '$.field', FIELDMESSAGE nvarchar(255) '$.messages[0]') WHERE charindex('Reporting Frequency Validation', FIELD) >= 1 ), ',', '/') AS 'REPORTING_FREQ_VALID_WARNING'
	  ,REPLACE((SELECT distinct FIELDMESSAGE FROM OPENJSON(subm_rw.WARNING_DETAIL,'$.fieldMessages') 
			WITH (FIELD nvarchar(255) '$.field', FIELDMESSAGE nvarchar(255) '$.messages[0]') WHERE FIELD = 'Surface Type Validation'), ',', '/') AS 'SURFACE_TYPE_VALID_WARNING'
	  ,REPLACE((SELECT distinct FIELDMESSAGE FROM OPENJSON(subm_rw.WARNING_DETAIL,'$.fieldMessages') 
			WITH (FIELD nvarchar(255) '$.field', FIELDMESSAGE nvarchar(255) '$.messages[0]') WHERE FIELD = 'Road Class Validation'), ',', '/') AS 'ROAD_CLASS_VALID_WARNING'
	  ,REPLACE((SELECT distinct FIELDMESSAGE FROM OPENJSON(subm_rw.WARNING_DETAIL,'$.fieldMessages') 
			WITH (FIELD nvarchar(255) '$.field', FIELDMESSAGE nvarchar(255) '$.messages[0]') WHERE FIELD = 'Road Length Validation'), ',', '/') AS 'ROAD_LENGTH_VALID_WARNING'
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
	  ,CAST(subm_obj.APP_CREATE_TIMESTAMP  AS datetime) AS SUBMISSION_DATE
	  ,rckflrpt.RECORD_VERSION_NUMBER
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
	  ,CAST(subm_obj.APP_CREATE_TIMESTAMP  AS datetime) AS SUBMISSION_DATE
  FROM [dbo].[HMR_WILDLIFE_REPORT] wldlfrpt
  INNER JOIN HMR_SUBMISSION_OBJECT subm_obj ON wldlfrpt.SUBMISSION_OBJECT_ID = subm_obj.SUBMISSION_OBJECT_ID
  LEFT OUTER JOIN HMR_SUBMISSION_ROW subm_rw ON wldlfrpt.ROW_ID = subm_rw.ROW_ID
  LEFT OUTER JOIN HMR_SUBMISSION_STATUS subm_stat ON subm_rw.ROW_STATUS_ID = subm_stat.STATUS_ID
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create trigger dbo.HMR_WRK_RPT_A_S_IUD_TR
PRINT N'Create trigger dbo.HMR_WRK_RPT_A_S_IUD_TR'
GO
CREATE TRIGGER [dbo].[HMR_WRK_RPT_A_S_IUD_TR] ON HMR_WORK_REPORT FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    RETURN;

  -- historical
  IF EXISTS(SELECT * FROM deleted)
    update HMR_WORK_REPORT_HIST set END_DATE_HIST = @curr_date where WORK_REPORT_ID in (select WORK_REPORT_ID from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT * FROM inserted)
    insert into HMR_WORK_REPORT_HIST ([WORK_REPORT_ID], [SUBMISSION_OBJECT_ID], [ROW_ID], [ROW_NUM], [VALIDATION_STATUS_ID], [RECORD_TYPE], [SERVICE_AREA], [RECORD_NUMBER], [TASK_NUMBER], [ACTIVITY_NUMBER], [START_DATE], [END_DATE], [ACCOMPLISHMENT], [UNIT_OF_MEASURE], [POSTED_DATE], [HIGHWAY_UNIQUE], [HIGHWAY_UNIQUE_NAME], [HIGHWAY_UNIQUE_LENGTH], [LANDMARK], [START_OFFSET], [END_OFFSET], [START_LATITUDE], [START_LONGITUDE], [END_LATITUDE], [END_LONGITUDE], [WORK_LENGTH], [STRUCTURE_NUMBER], [SITE_NUMBER], [VALUE_OF_WORK], [COMMENTS], [GEOMETRY], [RECORD_VERSION_NUMBER], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_CREATE_USER_DIRECTORY], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [APP_LAST_UPDATE_USER_DIRECTORY], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], [WORK_REPORT_HIST_ID], [END_DATE_HIST], [EFFECTIVE_DATE_HIST])
      select [WORK_REPORT_ID], [SUBMISSION_OBJECT_ID], [ROW_ID], [ROW_NUM], [VALIDATION_STATUS_ID], [RECORD_TYPE], [SERVICE_AREA], [RECORD_NUMBER], [TASK_NUMBER], [ACTIVITY_NUMBER], [START_DATE], [END_DATE], [ACCOMPLISHMENT], [UNIT_OF_MEASURE], [POSTED_DATE], [HIGHWAY_UNIQUE], [HIGHWAY_UNIQUE_NAME], [HIGHWAY_UNIQUE_LENGTH], [LANDMARK], [START_OFFSET], [END_OFFSET], [START_LATITUDE], [START_LONGITUDE], [END_LATITUDE], [END_LONGITUDE], [WORK_LENGTH],  [STRUCTURE_NUMBER], [SITE_NUMBER], [VALUE_OF_WORK], [COMMENTS], [GEOMETRY], [RECORD_VERSION_NUMBER], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_CREATE_USER_DIRECTORY], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [APP_LAST_UPDATE_USER_DIRECTORY], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[HMR_WORK_REPORT_H_ID_SEQ]) as [WORK_REPORT_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST] from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC hmr_error_handling
END CATCH;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create trigger dbo.HMR_RCKFL_RPT_A_S_IUD_TR
PRINT N'Create trigger dbo.HMR_RCKFL_RPT_A_S_IUD_TR'
GO
CREATE TRIGGER [dbo].[HMR_RCKFL_RPT_A_S_IUD_TR] ON HMR_ROCKFALL_REPORT FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    RETURN;

  -- historical
  IF EXISTS(SELECT * FROM deleted)
    update HMR_ROCKFALL_REPORT_HIST set END_DATE_HIST = @curr_date where ROCKFALL_REPORT_ID in (select ROCKFALL_REPORT_ID from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT * FROM inserted)
    insert into HMR_ROCKFALL_REPORT_HIST ([ROCKFALL_REPORT_ID], [SUBMISSION_OBJECT_ID], [ROW_ID], [ROW_NUM], [VALIDATION_STATUS_ID], [MCRR_INCIDENT_NUMBER], [RECORD_TYPE], [SERVICE_AREA], [ESTIMATED_ROCKFALL_DATE], [ESTIMATED_ROCKFALL_TIME], [START_LATITUDE], [START_LONGITUDE], [END_LATITUDE], [END_LONGITUDE], [HIGHWAY_UNIQUE], [HIGHWAY_UNIQUE_NAME], [HIGHWAY_UNIQUE_LENGTH], [LANDMARK], [LANDMARK_NAME], [START_OFFSET], [END_OFFSET], [DIRECTION_FROM_LANDMARK], [LOCATION_DESCRIPTION], [DITCH_VOLUME], [TRAVELLED_LANES_VOLUME], [OTHER_TRAVELLED_LANES_VOLUME], [OTHER_DITCH_VOLUME], [HEAVY_PRECIP], [FREEZE_THAW], [DITCH_SNOW_ICE], [VEHICLE_DAMAGE], [COMMENTS], [REPORTER_NAME], [MC_PHONE_NUMBER], [REPORT_DATE], [GEOMETRY], [RECORD_VERSION_NUMBER], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_CREATE_USER_DIRECTORY], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [APP_LAST_UPDATE_USER_DIRECTORY], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], ROCKFALL_REPORT_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
      select [ROCKFALL_REPORT_ID], [SUBMISSION_OBJECT_ID], [ROW_ID], [ROW_NUM], [VALIDATION_STATUS_ID], [MCRR_INCIDENT_NUMBER], [RECORD_TYPE], [SERVICE_AREA], [ESTIMATED_ROCKFALL_DATE], [ESTIMATED_ROCKFALL_TIME], [START_LATITUDE], [START_LONGITUDE], [END_LATITUDE], [END_LONGITUDE], [HIGHWAY_UNIQUE], [HIGHWAY_UNIQUE_NAME], [HIGHWAY_UNIQUE_LENGTH], [LANDMARK], [LANDMARK_NAME], [START_OFFSET], [END_OFFSET], [DIRECTION_FROM_LANDMARK], [LOCATION_DESCRIPTION], [DITCH_VOLUME], [TRAVELLED_LANES_VOLUME], [OTHER_TRAVELLED_LANES_VOLUME], [OTHER_DITCH_VOLUME], [HEAVY_PRECIP], [FREEZE_THAW], [DITCH_SNOW_ICE], [VEHICLE_DAMAGE], [COMMENTS], [REPORTER_NAME], [MC_PHONE_NUMBER], [REPORT_DATE], [GEOMETRY], [RECORD_VERSION_NUMBER], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_CREATE_USER_DIRECTORY], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [APP_LAST_UPDATE_USER_DIRECTORY], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[HMR_ROCKFALL_REPORT_H_ID_SEQ]) as [ROCKFALL_REPORT_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST] from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC hmr_error_handling
END CATCH;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create trigger dbo.HMR_RCKFL_RPT_I_S_U_TR
PRINT N'Create trigger dbo.HMR_RCKFL_RPT_I_S_U_TR'
GO
CREATE TRIGGER [dbo].[HMR_RCKFL_RPT_I_S_U_TR] ON HMR_ROCKFALL_REPORT INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM deleted)
    RETURN;

  -- validate concurrency control
  if exists (select 1 from inserted, deleted where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.ROCKFALL_REPORT_ID = deleted.ROCKFALL_REPORT_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)


  -- update statement
  update HMR_ROCKFALL_REPORT
    set "ROCKFALL_REPORT_ID" = inserted."ROCKFALL_REPORT_ID",
      "SUBMISSION_OBJECT_ID" = inserted."SUBMISSION_OBJECT_ID",
      "ROW_ID" = inserted."ROW_ID",
      "ROW_NUM" = inserted."ROW_NUM",
      "VALIDATION_STATUS_ID" = inserted."VALIDATION_STATUS_ID",
      "MCRR_INCIDENT_NUMBER" = inserted."MCRR_INCIDENT_NUMBER",
      "RECORD_TYPE" = inserted."RECORD_TYPE",
      "SERVICE_AREA" = inserted."SERVICE_AREA",
      "ESTIMATED_ROCKFALL_DATE" = inserted."ESTIMATED_ROCKFALL_DATE",
      "ESTIMATED_ROCKFALL_TIME" = inserted."ESTIMATED_ROCKFALL_TIME",
      "START_LATITUDE" = inserted."START_LATITUDE",
      "START_LONGITUDE" = inserted."START_LONGITUDE",
      "END_LATITUDE" = inserted."END_LATITUDE",
      "END_LONGITUDE" = inserted."END_LONGITUDE",
      "HIGHWAY_UNIQUE" = inserted."HIGHWAY_UNIQUE",
      "HIGHWAY_UNIQUE_NAME" = inserted."HIGHWAY_UNIQUE_NAME",
      "HIGHWAY_UNIQUE_LENGTH" = inserted."HIGHWAY_UNIQUE_LENGTH",
      "LANDMARK" = inserted."LANDMARK",
      "LANDMARK_NAME" = inserted."LANDMARK_NAME",
      "START_OFFSET" = inserted."START_OFFSET",
      "END_OFFSET" = inserted."END_OFFSET",
      "DIRECTION_FROM_LANDMARK" = inserted."DIRECTION_FROM_LANDMARK",
      "LOCATION_DESCRIPTION" = inserted."LOCATION_DESCRIPTION",
      "DITCH_VOLUME" = inserted."DITCH_VOLUME",
      "TRAVELLED_LANES_VOLUME" = inserted."TRAVELLED_LANES_VOLUME",
      "OTHER_TRAVELLED_LANES_VOLUME" = inserted."OTHER_TRAVELLED_LANES_VOLUME",
      "OTHER_DITCH_VOLUME" = inserted."OTHER_DITCH_VOLUME",
      "HEAVY_PRECIP" = inserted."HEAVY_PRECIP",
      "FREEZE_THAW" = inserted."FREEZE_THAW",
      "DITCH_SNOW_ICE" = inserted."DITCH_SNOW_ICE",
      "VEHICLE_DAMAGE" = inserted."VEHICLE_DAMAGE",
      "COMMENTS" = inserted."COMMENTS",
      "REPORTER_NAME" = inserted."REPORTER_NAME",
      "MC_PHONE_NUMBER" = inserted."MC_PHONE_NUMBER",
      "REPORT_DATE" = inserted."REPORT_DATE",
      "GEOMETRY" = inserted."GEOMETRY", 
      "RECORD_VERSION_NUMBER" = inserted."RECORD_VERSION_NUMBER",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID",
      "APP_LAST_UPDATE_USER_DIRECTORY" = inserted."APP_LAST_UPDATE_USER_DIRECTORY"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from HMR_ROCKFALL_REPORT
    inner join inserted
    on (HMR_ROCKFALL_REPORT.ROCKFALL_REPORT_ID = inserted.ROCKFALL_REPORT_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC hmr_error_handling
END CATCH;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create trigger dbo.HMR_WRK_RPT_I_S_U_TR
PRINT N'Create trigger dbo.HMR_WRK_RPT_I_S_U_TR'
GO
CREATE TRIGGER [dbo].[HMR_WRK_RPT_I_S_U_TR] ON HMR_WORK_REPORT INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM deleted)
    RETURN;

  -- validate concurrency control
  if exists (select 1 from inserted, deleted where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.WORK_REPORT_ID = deleted.WORK_REPORT_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)


  -- update statement
  update HMR_WORK_REPORT
    set "WORK_REPORT_ID" = inserted."WORK_REPORT_ID",
      "SUBMISSION_OBJECT_ID" = inserted."SUBMISSION_OBJECT_ID",
      "ROW_ID" = inserted."ROW_ID",
      "ROW_NUM" = inserted."ROW_NUM",
      "VALIDATION_STATUS_ID" = inserted."VALIDATION_STATUS_ID",
      "RECORD_TYPE" = inserted."RECORD_TYPE",
      "SERVICE_AREA" = inserted."SERVICE_AREA",
      "RECORD_NUMBER" = inserted."RECORD_NUMBER",
      "TASK_NUMBER" = inserted."TASK_NUMBER",
      "ACTIVITY_NUMBER" = inserted."ACTIVITY_NUMBER",
      "START_DATE" = inserted."START_DATE",
      "END_DATE" = inserted."END_DATE",
      "ACCOMPLISHMENT" = inserted."ACCOMPLISHMENT",
      "UNIT_OF_MEASURE" = inserted."UNIT_OF_MEASURE",
      "POSTED_DATE" = inserted."POSTED_DATE",
      "HIGHWAY_UNIQUE" = inserted."HIGHWAY_UNIQUE",
      "HIGHWAY_UNIQUE_NAME" = inserted."HIGHWAY_UNIQUE_NAME",
      "HIGHWAY_UNIQUE_LENGTH" = inserted."HIGHWAY_UNIQUE_LENGTH",
      "LANDMARK" = inserted."LANDMARK",
      "START_OFFSET" = inserted."START_OFFSET",
      "END_OFFSET" = inserted."END_OFFSET",
      "START_LATITUDE" = inserted."START_LATITUDE",
      "START_LONGITUDE" = inserted."START_LONGITUDE",
      "END_LATITUDE" = inserted."END_LATITUDE",
      "END_LONGITUDE" = inserted."END_LONGITUDE",
      "WORK_LENGTH" = inserted."WORK_LENGTH",
      "STRUCTURE_NUMBER" = inserted."STRUCTURE_NUMBER",
      "SITE_NUMBER" = inserted."SITE_NUMBER",
      "VALUE_OF_WORK" = inserted."VALUE_OF_WORK",
      "COMMENTS" = inserted."COMMENTS",
      "GEOMETRY" = inserted."GEOMETRY",
      "RECORD_VERSION_NUMBER" = inserted."RECORD_VERSION_NUMBER",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID",
      "APP_LAST_UPDATE_USER_DIRECTORY" = inserted."APP_LAST_UPDATE_USER_DIRECTORY"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from HMR_WORK_REPORT
    inner join inserted
    on (HMR_WORK_REPORT.WORK_REPORT_ID = inserted.WORK_REPORT_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC hmr_error_handling
END CATCH;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

-- Create trigger dbo.HMR_WRK_RPT_I_S_I_TR
PRINT N'Create trigger dbo.HMR_WRK_RPT_I_S_I_TR'
GO
CREATE TRIGGER [dbo].[HMR_WRK_RPT_I_S_I_TR] ON HMR_WORK_REPORT INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;


  insert into HMR_WORK_REPORT ("WORK_REPORT_ID",
      "SUBMISSION_OBJECT_ID",
      "ROW_ID",
      "ROW_NUM",
      "VALIDATION_STATUS_ID",
      "RECORD_TYPE",
      "SERVICE_AREA",
      "RECORD_NUMBER",
      "TASK_NUMBER",
      "ACTIVITY_NUMBER",
      "START_DATE",
      "END_DATE",
      "ACCOMPLISHMENT",
      "UNIT_OF_MEASURE",
      "POSTED_DATE",
      "HIGHWAY_UNIQUE",
      "HIGHWAY_UNIQUE_NAME",
      "HIGHWAY_UNIQUE_LENGTH",
      "LANDMARK",
      "START_OFFSET",
      "END_OFFSET",
      "START_LATITUDE",
      "START_LONGITUDE",
      "END_LATITUDE",
      "END_LONGITUDE",
      "WORK_LENGTH",
      "STRUCTURE_NUMBER",
      "SITE_NUMBER",
      "VALUE_OF_WORK",
      "COMMENTS",
      "GEOMETRY",   
      "RECORD_VERSION_NUMBER", 
      "CONCURRENCY_CONTROL_NUMBER",
      "APP_CREATE_USERID",
      "APP_CREATE_TIMESTAMP",
      "APP_CREATE_USER_GUID",
      "APP_CREATE_USER_DIRECTORY",
      "APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID",
      "APP_LAST_UPDATE_USER_DIRECTORY")
    select "WORK_REPORT_ID",
      "SUBMISSION_OBJECT_ID",
      "ROW_ID",
      "ROW_NUM",
      "VALIDATION_STATUS_ID",
      "RECORD_TYPE",
      "SERVICE_AREA",
      "RECORD_NUMBER",
      "TASK_NUMBER",
      "ACTIVITY_NUMBER",
      "START_DATE",
      "END_DATE",
      "ACCOMPLISHMENT",
      "UNIT_OF_MEASURE",
      "POSTED_DATE",
      "HIGHWAY_UNIQUE",
      "HIGHWAY_UNIQUE_NAME",
      "HIGHWAY_UNIQUE_LENGTH",
      "LANDMARK",
      "START_OFFSET",
      "END_OFFSET",
      "START_LATITUDE",
      "START_LONGITUDE",
      "END_LATITUDE",
      "END_LONGITUDE",
      "WORK_LENGTH",
      "STRUCTURE_NUMBER",
      "SITE_NUMBER",
      "VALUE_OF_WORK",
      "COMMENTS",
      "GEOMETRY",      
      "RECORD_VERSION_NUMBER",
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

-- Create trigger dbo.HMR_RCKFL_RPT_I_S_I_TR
PRINT N'Create trigger dbo.HMR_RCKFL_RPT_I_S_I_TR'
GO
CREATE TRIGGER [dbo].[HMR_RCKFL_RPT_I_S_I_TR] ON HMR_ROCKFALL_REPORT INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;


  insert into HMR_ROCKFALL_REPORT ("ROCKFALL_REPORT_ID",
      "SUBMISSION_OBJECT_ID",
      "ROW_ID",
      "ROW_NUM",
      "VALIDATION_STATUS_ID",
      "MCRR_INCIDENT_NUMBER",
      "RECORD_TYPE",
      "SERVICE_AREA",
      "ESTIMATED_ROCKFALL_DATE",
      "ESTIMATED_ROCKFALL_TIME",
      "START_LATITUDE",
      "START_LONGITUDE",
      "END_LATITUDE",
      "END_LONGITUDE",
      "HIGHWAY_UNIQUE",
      "HIGHWAY_UNIQUE_NAME",
      "HIGHWAY_UNIQUE_LENGTH",
      "LANDMARK",
      "LANDMARK_NAME",
      "START_OFFSET",
      "END_OFFSET",
      "DIRECTION_FROM_LANDMARK",
      "LOCATION_DESCRIPTION",
      "DITCH_VOLUME",
      "TRAVELLED_LANES_VOLUME",
      "OTHER_TRAVELLED_LANES_VOLUME",
      "OTHER_DITCH_VOLUME",
      "HEAVY_PRECIP",
      "FREEZE_THAW",
      "DITCH_SNOW_ICE",
      "VEHICLE_DAMAGE",
      "COMMENTS",
      "REPORTER_NAME",
      "MC_PHONE_NUMBER",
      "REPORT_DATE",
      "GEOMETRY",   
      "RECORD_VERSION_NUMBER",
      "CONCURRENCY_CONTROL_NUMBER",
      "APP_CREATE_USERID",
      "APP_CREATE_TIMESTAMP",
      "APP_CREATE_USER_GUID",
      "APP_CREATE_USER_DIRECTORY",
      "APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID",
      "APP_LAST_UPDATE_USER_DIRECTORY")
    select "ROCKFALL_REPORT_ID",
      "SUBMISSION_OBJECT_ID",
      "ROW_ID",
      "ROW_NUM",
      "VALIDATION_STATUS_ID",
      "MCRR_INCIDENT_NUMBER",
      "RECORD_TYPE",
      "SERVICE_AREA",
      "ESTIMATED_ROCKFALL_DATE",
      "ESTIMATED_ROCKFALL_TIME",
      "START_LATITUDE",
      "START_LONGITUDE",
      "END_LATITUDE",
      "END_LONGITUDE",
      "HIGHWAY_UNIQUE",
      "HIGHWAY_UNIQUE_NAME",
      "HIGHWAY_UNIQUE_LENGTH",
      "LANDMARK",
      "LANDMARK_NAME",
      "START_OFFSET",
      "END_OFFSET",
      "DIRECTION_FROM_LANDMARK",
      "LOCATION_DESCRIPTION",
      "DITCH_VOLUME",
      "TRAVELLED_LANES_VOLUME",
      "OTHER_TRAVELLED_LANES_VOLUME",
      "OTHER_DITCH_VOLUME",
      "HEAVY_PRECIP",
      "FREEZE_THAW",
      "DITCH_SNOW_ICE",
      "VEHICLE_DAMAGE",
      "COMMENTS",
      "REPORTER_NAME",
      "MC_PHONE_NUMBER",
      "REPORT_DATE",
      "GEOMETRY",  
      "RECORD_VERSION_NUMBER",
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
