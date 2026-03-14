/*
Using GEOMETRY
By using the GEOMETRY type, you can store points, lines, and polygons. You can calculate the difference
between two shapes, you can determine whether they intersect, and you can do much more. Just like
HIERARCHYID, the database engine stores the data as a binary value. GEOMETRY also has many built-in
methods for working with the data. Type in and execute Listing 9-11 to learn how to use the GEOMETRY
data type with some simple examples.
*/

USE tempdb;
GO
--1
IF OBJECT_ID('dbo.GeometryData') IS NOT NULL BEGIN
DROP TABLE dbo.GeometryData;
END;
--2
CREATE TABLE dbo.GeometryData (
Point1 GEOMETRY, Point2 GEOMETRY,
Line1 GEOMETRY, Line2 GEOMETRY,
Polygon1 GEOMETRY, Polygon2 GEOMETRY);
--3
INSERT INTO dbo.GeometryData (Point1, Point2, Line1, Line2, Polygon1, Polygon2)
VALUES (
GEOMETRY::Parse('Point(1 4)'),
GEOMETRY::Parse('Point(2 5)'),
GEOMETRY::Parse('LineString(1 4, 2 5)'),
GEOMETRY::Parse('LineString(4 1, 5 2, 7 3, 10 6)'),
GEOMETRY::Parse('Polygon((1 4, 2 5, 5 2, 0 4, 1 4))'),
GEOMETRY::Parse('Polygon((1 4, 2 7, 7 2, 0 4, 1 4))'));
--4
SELECT Point1.ToString() AS Point1, Point2.ToString() AS Point2,
Line1.ToString() AS Line1, Line2.ToString() AS Line2,
Polygon1.ToString() AS Polygon1, Polygon2.ToString() AS Polygon2
FROM dbo.GeometryData;
--5
SELECT Point1.STX AS Point1X, Point1.STY AS Point1Y,
Line1.STIntersects(Polygon1) AS Line1Poly1Intersects,
Line1.STLength() AS Line1Len,
Line1.STStartPoint().ToString() AS Line1Start,
Line2.STNumPoints() AS Line2PtCt,
Polygon1.STArea() AS Poly1Area,
Polygon1.STIntersects(Polygon2) AS Poly1Poly2Intersects
FROM dbo.GeometryData;


/*Figure 9-14 shows the results. Code section 1 drops the dbo.GeometryData table if it already
exists. Statement 2 creates the table along with six GEOMETRY columns each named for the type of shape it
will contain. Even though this example named the shape types, a GEOMETRY column can store any of the
shapes; it is not limited to one shape. Statement 3 inserts one row into the table using the Parse method.
Query 4 displays the data using the ToString method so that you can read the data. Notice that the data
returned from the ToString method looks just like it does when inserted. Query 5 demonstrates a few of
the methods available for working with GEOMETRY data. For example, you can display the X and Y
coordinates of a point, determine the length or area of a shape, determine whether two shapes intersect,
and count the number of points in a shape.*/