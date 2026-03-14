USE SwapMap
GO 


-- POPULATE Entity Table 
INSERT INTO [ITEM](
	  [UserID]
      ,[Name]
      ,[Description]
      ,[ImageFile]
      ,[Value])
VALUES (1,
		'Introducing HTML 5, 2nd Edition',
		'HTML 5 introduction for beginners',
		'015.jpg',
		24.50)
GO 


-- POPULATE Reference Table 
INSERT INTO lkup_Status(Name, [Description])
VALUES ( 'Offered','Item swap is offered')	
GO