/*

The DB_CHAINING option, when enabled,allows the new database to participate in a cross-database ownership chain. In its simplest form, an
ownership chain occurs when one object (such as a view or stored procedure) references another
object. If the owner of the schema that contains these objects is the same as the referenced object,
permissions on the referenced object are not checked.

The TRUSTWORTHY option is used to specify whether or not SQL Server will “trust” anymodules
or assemblies within a given database.When this option is OFF, SQL Server will protect against certainmalicious
EXTERNAL_ACCESS or UNSAFE activities within that database’s assemblies, or from
malicious code executed under the context of high-privileged users.

CREATE DATABASE database_name
...
[ WITH { DB_CHAINING { ON | OFF }
|TRUSTWORTHY { ON | OFF }]]

ALTER DATABASE database_name
{SET DB_CHAINING { ON | OFF }
| TRUSTWORTHY { ON | OFF }}

*/


USE master
GO
-- Create a database with the model database defaults
CREATE DATABASE BookData
WITH DB_CHAINING ON
GO


USE master
GO
-- Now modify the new database to also have the
-- TRUSTWORTHY option ON
ALTER DATABASE BookData
SET TRUSTWORTHY ON
GO