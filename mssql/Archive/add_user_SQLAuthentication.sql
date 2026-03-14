Add User Using SQL Authentication

-- Create user for SQL Authentication
CREATE LOGIN JohnJacobs WITH PASSWORD = 'JinGleHeimerSchmidt'
,DEFAULT_DATABASE = [YourDatabaseHere]
GO
-- Add User to first database
USE YourDatabaseHere;
CREATE USER JohnJacobs FOR LOGIN JohnJacobs;
EXEC sp_addrolemember 'db_datareader', 'JohnJacobs'
EXEC sp_addrolemember 'db_datawriter', 'JohnJacobs'
GO
-- Add User to second database
USE YourSecondDatabaseHere;
CREATE USER JohnJacobs FOR LOGIN JohnJacobs;
EXEC sp_addrolemember 'db_datareader', 'JohnJacobs'
EXEC sp_addrolemember 'db_datawriter', 'JohnJacobs'
