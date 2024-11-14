DELETE FROM [dbo].[$__dbup_journal]
DROP SEQUENCE web.global_id ;  
GO  


IF NOT EXISTS (SELECT * FROM sys.change_tracking_databases WHERE database_id = DB_ID())
BEGIN
ALTER DATABASE CURRENT 
SET CHANGE_TRACKING = ON  
(CHANGE_RETENTION = 2 DAYS, AUTO_CLEANUP = ON)  
END
GO

