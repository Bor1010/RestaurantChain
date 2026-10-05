-- Initialize database schema and settings
-- This script sets up the default schema and database collation

USE RestaurantChain
GO

-- Create schemas (dbo exists by default; rsn holds reservation procedures)
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'rsn')
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA [rsn]'
END
GO

PRINT 'Schema initialization completed successfully!'
GO
