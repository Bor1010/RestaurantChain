--Before run: Query->SQLCMD Mode
-- Master script

:setvar DatabaseName "RestaurantChain"
:setvar ScriptsPath "C:\Users\BOR\Desktop\MyFiles\Projects\RestaurantChain\DataBase\Scripts"

-- Delete the database if it exists (be careful in production!)
IF EXISTS (SELECT * FROM sys.databases WHERE name = '$(DatabaseName)')
BEGIN
    ALTER DATABASE [$(DatabaseName)] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE [$(DatabaseName)]
END
GO

-- Create the database
CREATE DATABASE [$(DatabaseName)]
GO

USE [$(DatabaseName)]
GO

-- Run all scripts in order
:r $(ScriptsPath)\001_InitialSchema.sql
:r $(ScriptsPath)\002_CreateTables.sql
:r $(ScriptsPath)\003_AddIndexes.sql
:r $(ScriptsPath)\004_SeedData.sql
:r $(ScriptsPath)\005_StoredProcedures.sql

PRINT 'Database setup completed successfully!'
GO