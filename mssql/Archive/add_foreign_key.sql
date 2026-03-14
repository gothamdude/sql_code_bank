-- Recreate costraints for Insurer, Service Center, State  
ALTER TABLE  FR_AccountGraphic
ADD CONSTRAINT FK_FR_AccountGraphic_InsurerID foreign key (InsurerID) references BE_Entity(BusinessEntityID), 
	CONSTRAINT FK_FR_AccountGraphic_ServiceCenterID foreign key (ServiceCenterID) references BE_Entity(BusinessEntityID), 
	CONSTRAINT FK_FR_AccountGraphic_StateID foreign key (StateID) references Rule_State (StateID) 
GO 	