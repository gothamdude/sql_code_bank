Add User Using Windows Authentication

-- Create user windows Authentication
CREATE LOGIN [YourDomainName\JohnJacobs] FROM WINDOWS
WITH DEFAULT_DATABASE = [YourDatabaseHere];
GO
-- Add User to first database
USE YourDatabaseHere;
CREATE USER JohnJacobs FOR LOGIN [YourDomainName\JohnJacobs];
EXEC sp_addrolemember 'db_datareader', 'JohnJacobs'
EXEC sp_addrolemember 'db_datawriter', 'JohnJacobs'
-- Add User to second database
USE YourSecondDatabaseHere;
CREATE USER JohnJacobs FOR LOGIN [YourDomainName\JohnJacobs];
EXEC sp_addrolemember 'db_datareader', 'JohnJacobs'
EXEC sp_addrolemember 'db_datawriter', 'JohnJacobs'
