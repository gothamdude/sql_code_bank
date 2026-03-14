/*
Using GEOGRAPHY
The GEOGRAPHY data type is even more interesting than the GEOMETRY type. With the GEOGRAPHY type, you
can store longitude and latitude values for actual locations or areas. Just like the GEOMETRY type, you can
use several built-in methods to work with the data. You can also extract the data in a special XML format
that can be used along with Microsoft’s Virtual Earth application. Unfortunately, integrating the
GEOMETRY data with the Virtual Earth is beyond the scope of this book. To learn more about creating
Virtual Earth applications with SQL Server Geometry data, see the book Beginning Spatial with SQL
Server 2008 by Alastair Aitchison (Apress, 2009).
The AdventureWorks2008 database contains one GEOMETRY column in the Person.Address table.
Type in and execute the code in Listing 9-12 to learn more.
*/

--Listing 9-12. Using the GEOGRAPHY Data Type

USE AdventureWorks2008;
GO
--1
DECLARE @OneAddress GEOGRAPHY;
--2
SELECT @OneAddress = SpatialLocation
FROM Person.Address
WHERE AddressID = 91;

--3
SELECT AddressID,PostalCode, SpatialLocation.ToString(),
@OneAddress.STDistance(SpatialLocation) AS DiffInMeters
FROM Person.Address
WHERE AddressID IN (1,91, 831,11419);

/*Figure 9-15 shows the results. Statement 1 declares a variable, @OneAddress, of the GEOGRAPHY
type. Statement 2 assigns one value to the variable. Query 3 displays the data including the AddressID,
the PostalCode, and the SpatialLocation.ToString method. The DiffInMeters column displays the
distance between the location saved in the variable to the stored data. Notice that the difference is zero
when comparing a location to itself.*/



/*Viewing the Spatial Results Tab
When you select GEOMETRY or GEOGRAPHY data in the native binary format, another tab shows up in the
results. This tab displays a visual representation of the spatial data. Type in and execute Listing 9-13 to
see how this works.*/

--Listing 9-13. Viewing Spatial Results
--1
DECLARE @Area GEOMETRY;
--2
SET @Area = GEOMETRY::Parse('Polygon((1 4, 2 5, 5 2, 0 4, 1 4))');
--3
SELECT @Area AS Area;