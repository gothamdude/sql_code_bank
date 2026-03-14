/*

One solution to this problemis the INCLUDE keyword, which allows you to add up to 1023 nonkey
columns to the nonclustered index, helping you improve query performance by creating a
covered index. These non-key columns are not stored at each level of the index, but instead are
only found in the leaf level of the nonclustered index. The syntax for using INCLUDE with CREATE

NONCLUSTERED INDEX is as follows:

CREATE NONCLUSTERED INDEX index_name
ON table_or_view_name ( column [ ASC | DESC ] [ ,...n ] )
INCLUDE ( column [ ,... n ] )

Whereas the first column list is for key index columns, the column list after INCLUDE is for
non-key columns. In this example, I’ll create a new large object data type column to the
TerminationReason table. I’ll drop the existing index on DepartmentID and re-create it with
the new non-key value in the index:

*/

ALTER TABLE HumanResources.TerminationReason
ADD LegalDescription varchar(max)

DROP INDEX HumanResources.TerminationReason.NI_TerminationReason_TerminationReason_DepartmentID

CREATE NONCLUSTERED INDEX NI_TerminationReason_TerminationReason_DepartmentID
ON HumanResources.TerminationReason (TerminationReason, DepartmentID)
INCLUDE (LegalDescription)

/*
How It Works

This recipe demonstrated a technique for enhancing a nonclustered index’s usefulness. The example
started off by creating a new varchar(max) data type column. Because of its data type, it cannot
be used as a key value in the index; however, using it within the INCLUDE keyword will allow you to
reference the new large object data types. The existing index on the TerminationReason table was
then dropped and re-created using INCLUDE with the new non-key column.
You can use INCLUDE only with a nonclustered index (where a covered query comes in handy),
and you still can’t include the deprecated image, ntext, and text data types. Also, if the index size
increases too significantly because of the additional non-key values, youmay lose some of the
query benefits that a covering query can give you, so be sure to test comparative before/after performance.

*/