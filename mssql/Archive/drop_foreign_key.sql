-- DROP existing costraints for Insurer and Service Center 
ALTER TABLE  FR_AccountGraphic
DROP CONSTRAINT FK_FR_BEGraphic_BE_Entity, 
	CONSTRAINT FK_FR_BE_Graphic_BE_Entity 
GO 	
