--1. get current date  
DECLARE @vCurrDate DATE 
SET @vCurrDate  = GETDATE()		 --#test 1 
--SET @vCurrDate  = '2/7/2015'   --#test 2 
--SET @vCurrDate  = '2/8/2015'   --#test 3 
--SET @vCurrDate  = '2/28/2015'  --#test 4 
 
--2. get the first date of the current date's month 
DECLARE @vFirstDayOfMonth DATE
SET @vFirstDayOfMonth = DATEADD(MONTH, DATEDIFF(MONTH, 0, @vCurrDate), 0)

-- 3. list first and last saturday for the current month 
DECLARE @vFirstSatOfMonth DATE, 
		@vLastSatOfMonth DATE 

SELECT ROW_NUMBER() OVER(ORDER BY DATEADD(dd,number,@vFirstDayOfMonth) ASC) AS WeekNum, 	
	   DATEADD(dd,number,@vFirstDayOfMonth) AS SaturdayDates 
INTO #TempSatWeekDays	   
from master..spt_values
where type = 'p'
and YEAR(DATEADD(dd,number,@vFirstDayOfMonth))=YEAR(@vFirstDayOfMonth)
and MONTH(DATEADD(dd,number,@vFirstDayOfMonth))=MONTH(@vFirstDayOfMonth)
and DATEPART(dw,DATEADD(dd,number,@vFirstDayOfMonth)) = 7

SET @vFirstSatOfMonth = (SELECT SaturdayDates FROM #TempSatWeekDays WHERE WeekNum =1)
SET @vLastSatOfMonth = (SELECT SaturdayDates FROM #TempSatWeekDays WHERE WeekNum = 4)

--4. if today's date falls within the 1st week or it's the first saturday ; run whole job
IF (@vCurrDate<=@vFirstSatOfMonth) 
BEGIN 
	SELECT 'WE WILL RUN WHOLE JOB'
END 
--5. if today's date is greater than 1st saturday but less than the last saturday ; run physical only
ELSE IF (@vCurrDate>@vFirstSatOfMonth) AND (@vCurrDate<@vLastSatOfMonth) 
BEGIN 
	SELECT 'WE WILL RUN PHYSICAL ONLY '
END 
--6. if today's date is the last saturday of the month or greater;  do not do anything 
ELSE IF (@vCurrDate >=@vLastSatOfMonth) 
BEGIN 
	SELECT 'WE WILL DO NOTHING '
END 

--7. do cleanup 
IF OBJECT_ID('tempdb..#TempSatWeekDays') IS NOT NULL
    DROP TABLE #TempSatWeekDays


