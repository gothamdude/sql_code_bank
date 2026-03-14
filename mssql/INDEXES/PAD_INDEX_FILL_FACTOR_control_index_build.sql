/*

Using PAD_INDEX and FILLFACTOR

In this recipe, I’ll show you how to set the initial percentage of rows to fill the index leaf level pages
and intermediate levels of an index. The fill factor percentage of an index refers to how full the leaf
level of the index pages should be when the index is first created. The default fill factor, if not explicitly
set, is 0, which equates to filling the pages as full as possible (SQL Server does leave some space
available—enough for a single index row). Leaving some space available, however, allows new rows
to be inserted without resorting to page splits. A page split occurs when a new row is added to a full
index page. In order tomake room, half the rows aremoved fromthe existing full page to a new
page. Numerous page splits can slow down INSERT operations. On the other hand, however, fully
packed data pages allow for faster read activity, as the database engine can retrievemore rows from
less data pages.

The PAD_INDEX option, used only in conjunction with FILLFACTOR, specifies that the specified
percentage of free space be left open on the intermediate level pages of an index.
These options are set in the WITH clause of the CREATE INDEX and ALTER INDEX commands. The
syntax is as follows:

WITH (PAD_INDEX = { ON | OFF }
| FILLFACTOR = fillfactor)

In this example, an index is dropped and re-created with a 50% fill factor and PAD_INDEX
enabled:

*/

DROP INDEX HumanResources.TerminationReason.NI_TerminationReason_TerminationReason_DepartmentID

CREATE NONCLUSTERED INDEX NI_TerminationReason_TerminationReason_DepartmentID
ON HumanResources.TerminationReason (TerminationReason ASC, DepartmentID ASC)
WITH (PAD_INDEX=ON, FILLFACTOR=50)

/*

How It Works

In this recipe, the fill factor was configured to 50%, leaving 50% of the index pages free for new rows.
PAD_INDEX was also enabled, so the intermediate index pages will also be left half free. Both options
are used in the WITH clause of the CREATE INDEX syntax:
WITH (PAD_INDEX=ON, FILLFACTOR=50)

Using FILLFACTOR can be a balancing act between reads and writes. For example, a 100% fill factor
can improve reads, but slow down write activity, causing frequent page splitting as the database
enginemust continually shift row locations in order tomake space in the data pages. Having too
low of a fill factor can benefit row inserts, but it can also slow down read operations, asmore data
pagesmust be accessed in order to retrieve all required rows. If you’re looking for a general rule of
thumb, use a 100% fill factor for tables with almost no datamodification activity, 80–90% for low
activity, 60–70% formediumactivity, and 50% or lower for high activity on the index key.
*/