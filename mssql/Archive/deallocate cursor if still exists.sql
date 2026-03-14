IF CURSOR_STATUS('global','curOrgGrpIDs')>=-1
	BEGIN
	 DEALLOCATE curOrgGrpIDs
	END