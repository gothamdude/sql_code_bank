-- Change Primary Key Column Name 
EXEC sp_rename
    @objname = 'FR_AccountGraphic.BusinessEntityGraphicID',
    @newname = 'FR_AccountGraphicID',
    @objtype = 'COLUMN'
    