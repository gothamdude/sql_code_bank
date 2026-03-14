    class SqlCommandExecutor
    {
        public static void RetryAfterDeadlock
            (SqlCommand command, int timesToRetry)
        {
            int retryCount = 0;
            while (retryCount < timesToRetry)
            {
                retryCount++;
                try
                {
                    command.ExecuteNonQuery();
                    Console.WriteLine
                       ("Command succeeded:" + 
                           command.CommandText);
                    return;
                }
                catch (SqlException e)
                {
                    if (e.Number != 1205)
                    {
                        throw;
                    }
                    Console.WriteLine("Retrying after deadlock:" + command.CommandText);
                }
            }
        }
    }
