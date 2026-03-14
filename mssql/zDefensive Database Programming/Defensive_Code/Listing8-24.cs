    class RetryAfterDeadlockDemo
    {
        static void Main(string[] args)
        {
            try
            {
                using (SqlConnection connection =
                    new SqlConnection
                         ("server=(local);
                           trusted_connection=true;
                           database=test8;"))
                {
                    connection.Open();
                    SqlCommand command = 
                         connection.CreateCommand();
                    command.CommandText = 
                      "EXEC dbo.ChangeCodeDescription
                        @code='IL', @Description='?' ;";
                 command.CommandType = CommandType.Text;
                    SqlCommandExecutor.
                       RetryAfterDeadlock(command, 3);
                    Console.WriteLine("Command succeeded");
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Error in Main:" + e);
            }
        }
    }
