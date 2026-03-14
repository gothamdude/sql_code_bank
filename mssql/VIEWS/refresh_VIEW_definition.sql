/*
Refreshing aView’s Definition

When table objects referenced by the view are changed, the view’smetadata can become outdated.
For example, if you change the column width for a column referenced in a view definition, the new
sizemay not be reflected until themetadata is refreshed. In this recipe, I’ll show you how to refresh
a view’smetadata if the dependent objects referenced in the view definition have changed:

*/

EXEC sp_refreshview 'dbo.v_Product_TransactionHistory'

/*
You can also use the systemstored procedure sp_refreshsqlmodule, which can be used not
only for views, but also for stored procedures, triggers, and user-defined functions:
*/

EXEC sys.sp_refreshsqlmodule @name = 'dbo.v_Product_TransactionHistory'