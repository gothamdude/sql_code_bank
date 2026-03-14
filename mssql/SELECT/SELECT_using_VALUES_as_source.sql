-- Using VALUES As a Table Source

SELECT DegreeNM, DegreeCD, ModifiedDT
FROM (VALUES	('Bachelor of Arts', 'B.A.', GETDATE()),
				('Bachelor of Science', 'B.S.', GETDATE()),
				('Master of Arts', 'M.A.', GETDATE()),
				('Master of Science', 'M.S.', GETDATE()),
				('Associate''s Degree', 'A.A.', GETDATE()
	  )) Degree (DegreeNM, DegreeCD, ModifiedDT)

/*
This returns

DegreeNM			DegreeCD ModifiedDT
Bachelor of Arts	B.A.	2007-08-21 19:10:34.667
Bachelor of Science B.S.	2007-08-21 19:10:34.667
Master of Arts		M.A.	2007-08-21 19:10:34.667
Master of Science	M.S.	2007-08-21 19:10:34.667
Associate's Degree	A.A.	2007-08-21 19:10:34.667

(5 row(s) affected)

*/