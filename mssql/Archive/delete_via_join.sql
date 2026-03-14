DELETE Rule_RuleReason 
	FROM Rule_RuleReason Rr
		LEFT OUTER JOIN @temp T ON  Rr.LOBID =  T.LOBID 
								AND Rr.ActionID = T.ActionID 
								AND Rr.StateID = T.StateID
								AND Rr.CircumstanceID = T.CircumstanceID
								AND UPPER(RTRIM(LTRIM(ISNULL(Rr.Reason,'')))) = UPPER(RTRIM(LTRIM(T.Reason)))
								AND Rr.BusinessID = T.BusinessID
								AND Rr.GroupID = T.GroupID 