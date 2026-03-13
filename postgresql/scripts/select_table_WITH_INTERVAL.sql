/**
 
Interval datatype The interval data type allows you to store and manipulate a period of time in years, months, days, hours, minutes, seconds, and so on. 
PostgreSQL interval data type value involves 16 bytes storage size, which helps store a period with the acceptable range from -178000000 years to 178000000 years.

**/

 select now(), now()-interval '4 months 1 hours 30 minutes' as "1 hour 30mins before last year";


 
 select interval '1h 50m' + interval '5m';
 
 
 
 -- We can use the EXTRACT() function to extract the fields from an interval value, For example, year, month, date, and so on.
 --EXTRACT(field FROM interval) In the above syntax, we can use the year, month, date, hour, minutes, and such values, in the field parameter.
-- In the above syntax, we can use the year, month, date, hour, minutes, and such values, in the field parameter. 
-- The extract function returns a value of type double-precision if we want to extract from the interval, as shown:


 
 SELECT   EXTRACT (MINUTE   FROM   INTERVAL '2 hours 30 minutes'   ) as Minute,
          EXTRACT (hour   from INTERVAL '2 hours 30 minutes'   ) as Hour;


 -- In PostgreSQL, there are two functions called justify_days 
 -- and justify_hours that let us change the way that a 24-hour period counts as one day and a 30-day period counts as one month.
 
 
 select justify_days(interval '30 days'),
 justify_hours(interval '24 hours'),
 justify_interval(interval '6 months + 1 hour');
 
-- validate 
 -- justify_days	justify_hours	justify_interval
 -- 1 mon			1 day			6 mons 01:00:00
 

 
  


