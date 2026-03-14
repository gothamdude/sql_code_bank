SELECT name AS [Configuration], CONVERT(INT, ISNULL(value, value_in_use)) AS [IsEnabled]
FROM  master.sys.configurations
WHERE  name = 'xp_cmdshell'