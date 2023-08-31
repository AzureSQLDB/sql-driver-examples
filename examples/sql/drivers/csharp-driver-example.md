# Create a C#/.NET app that connects to SQL Server and executes queries using Visual Studio Code

> These examples may be used with Azure SQL Database

## Prerequisites

1. [.NET 7.0](https://dotnet.microsoft.com/download/dotnet/7.0)

## Step 1, Create a C# app that connects to SQL Server and executes queries using Visual Studio Code

1. Start Visual Studio Code.

1. Select File > Open Folder (File > Open... on macOS) from the main menu.

1. In the Open Folder dialog, create a csharpexample folder in a directory of your choice and select it. Then click Select Folder (Open on macOS).

1. In the Do you trust the authors of the files in this folder? dialog, select **Yes, I trust the authors**.

1. Open the **Terminal** in Visual Studio Code by selecting View > Terminal from the main menu.

    The Terminal opens with the command prompt in the csharpexample folder.

1. In the Terminal, enter the following command:

    ```bash
    dotnet new console --framework net7.0
    ```

1. While still in the terminal, run the following command:

    ```bash
    dotnet add package Microsoft.Data.SqlClient
    ```

## Step 2, Issue a database query with the Microsoft SqlClient Data Provider for SQL Server

1. Visual Studio Code creates a new C# Console Application project (csharpexample.csproj) and and a file  named **Program.cs**.

    Click on the Program.cs file to see it in the Visual Studio Code editor.

1. Replace the contents of Program.cs by copying and pasting the code below into the file. Don't forget to replace

    ```csharp
    builder.DataSource = "<your_server.database.windows.net>"; 
    builder.UserID = "<your_username>";            
    builder.Password = "<your_password>";     
    builder.InitialCatalog = "<your_database>";
    ```

    with the values of your database.

    ```csharp
    using Microsoft.Data.SqlClient;
    
    namespace sqltest
    {
        class Program
        {
            static void Main(string[] args)
            {
                try 
                { 
                    SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
    
                    builder.DataSource = "<your_server.database.windows.net>"; 
                    builder.UserID = "<your_username>";            
                    builder.Password = "<your_password>";     
                    builder.InitialCatalog = "<your_database>";
                    builder.TrustServerCertificate = true;
             
                    using (SqlConnection connection = new SqlConnection(builder.ConnectionString))
                    {
                        Console.WriteLine("\nQuery data example:");
                        Console.WriteLine("=========================================\n");
                        
                        connection.Open();       
    
                        String sql = "SELECT name, collation_name FROM sys.databases";
    
                        using (SqlCommand command = new SqlCommand(sql, connection))
                        {
                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                while (reader.Read())
                                {
                                    Console.WriteLine("{0} {1}", reader.GetString(0), reader.GetString(1));
                                }
                            }
                        }                    
                    }
                }
                catch (SqlException e)
                {
                    Console.WriteLine(e.ToString());
                }
                Console.WriteLine("\nDone. Press enter.");
                Console.ReadLine(); 
            }
        }
    }
    ```

1. **Save** the file.

1. Run the following command in the Terminal:

    ```bash
    dotnet run
    ```

    Verify that the rows are returned, your output may include other values.

    ```results
    Query data example:
    =========================================
    
    master SQL_Latin1_General_CP1_CI_AS
    tempdb SQL_Latin1_General_CP1_CI_AS
    model SQL_Latin1_General_CP1_CI_AS
    msdb SQL_Latin1_General_CP1_CI_AS
    drivers1 SQL_Latin1_General_CP1_CI_AS
    
    Done. Press enter.
    ```

## Step 3, Issue Insert, Update and Delete command to the database with the Microsoft SqlClient Data Provider for SQL Server

1. Now replace the code in **Program.cs** by copying and pasting the code below into the file. This will create a database and a table, and will [insert](https://docs.microsoft.com/en-us/sql/t-sql/statements/insert-transact-sql), [update](https://docs.microsoft.com/en-us/sql/t-sql/queries/update-transact-sql), [delete](https://docs.microsoft.com/en-us/sql/t-sql/statements/delete-transact-sql), and read a few rows. Don't forget to update the username and password with your own. Save and close the file.

    ```csharp
    using System.Text;
    using Microsoft.Data.SqlClient;
    
    namespace sqltest
    {
        class Program
        {
            static void Main(string[] args)
            {
                try 
                { 
                    SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
    
                    builder.DataSource = "<your_server.database.windows.net>"; 
                    builder.UserID = "<your_username>";            
                    builder.Password = "<your_password>";     
                    builder.InitialCatalog = "<your_database>";
                    builder.TrustServerCertificate = true;
             
                    // Connect to SQL
                    Console.Write("Connecting to SQL Server ... ");
                    using (SqlConnection connection = new SqlConnection(builder.ConnectionString))
                    {
                        connection.Open();
                        Console.WriteLine("Done.");
    
                        // Create a sample database
                        Console.Write("Dropping and creating database 'SampleDB' ... ");
                        String sql = "DROP DATABASE IF EXISTS [SampleDB]; CREATE DATABASE [SampleDB]";
                        using (SqlCommand command = new SqlCommand(sql, connection))
                        {
                            command.ExecuteNonQuery();
                            Console.WriteLine("Done.");
                        }
    
                        // Create a Table and insert some sample data
                        Console.Write("Creating sample table with data, press any key to continue...");
                        Console.ReadKey(true);
                        StringBuilder sb = new StringBuilder();
                        sb.Append("USE SampleDB; ");
                        sb.Append("CREATE TABLE Employees ( ");
                        sb.Append(" Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY, ");
                        sb.Append(" Name NVARCHAR(50), ");
                        sb.Append(" Location NVARCHAR(50) ");
                        sb.Append("); ");
                        sb.Append("INSERT INTO Employees (Name, Location) VALUES ");
                        sb.Append("(N'Jared', N'Australia'), ");
                        sb.Append("(N'Nikita', N'India'), ");
                        sb.Append("(N'Tom', N'Germany'); ");
                        sql = sb.ToString();
                        using (SqlCommand command = new SqlCommand(sql, connection))
                        {
                            command.ExecuteNonQuery();
                            Console.WriteLine("Done.");
                        }
    
                        // INSERT demo
                        Console.Write("Inserting a new row into table, press any key to continue...");
                        Console.ReadKey(true);
                        sb.Clear();
                        sb.Append("INSERT Employees (Name, Location) ");
                        sb.Append("VALUES (@name, @location);");
                        sql = sb.ToString();
                        using (SqlCommand command = new SqlCommand(sql, connection))
                        {
                            command.Parameters.AddWithValue("@name", "Jake");
                            command.Parameters.AddWithValue("@location", "United States");
                            int rowsAffected = command.ExecuteNonQuery();
                            Console.WriteLine(rowsAffected + " row(s) inserted");
                        }
    
                        // UPDATE demo
                        String userToUpdate = "Nikita";
                        Console.Write("Updating 'Location' for user '" + userToUpdate + "', press any key to continue...");
                        Console.ReadKey(true);
                        sb.Clear();
                        sb.Append("UPDATE Employees SET Location = N'United States' WHERE Name = @name");
                        sql = sb.ToString();
                        using (SqlCommand command = new SqlCommand(sql, connection))
                        {
                            command.Parameters.AddWithValue("@name", userToUpdate);
                            int rowsAffected = command.ExecuteNonQuery();
                            Console.WriteLine(rowsAffected + " row(s) updated");
                        }
    
                        // DELETE demo
                        String userToDelete = "Jared";
                        Console.Write("Deleting user '" + userToDelete + "', press any key to continue...");
                        Console.ReadKey(true);
                        sb.Clear();
                        sb.Append("DELETE FROM Employees WHERE Name = @name;");
                        sql = sb.ToString();
                        using (SqlCommand command = new SqlCommand(sql, connection))
                        {
                            command.Parameters.AddWithValue("@name", userToDelete);
                            int rowsAffected = command.ExecuteNonQuery();
                            Console.WriteLine(rowsAffected + " row(s) deleted");
                        }
    
                        // READ demo
                        Console.WriteLine("Reading data from table, press any key to continue...");
                        Console.ReadKey(true);
                        sql = "SELECT Id, Name, Location FROM Employees;";
                        using (SqlCommand command = new SqlCommand(sql, connection))
                        {
    
                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                while (reader.Read())
                                {
                                    Console.WriteLine("{0} {1} {2}", reader.GetInt32(0), reader.GetString(1), reader.GetString(2));
                                }
                            }
                        }
                    }
                }
                catch (SqlException e)
                {
                    Console.WriteLine(e.ToString());
                }
    
                Console.WriteLine("All done. Press any key to finish...");
                Console.ReadKey(true);
            }
        }
    }
    ```

1. Run the following command in the Terminal:

    ```bash
    dotnet run
    ```

    with the output being:

    ```results
    Connecting to SQL Server ... Done.
    Dropping and creating database 'SampleDB' ... Done.
    Creating sample table with data, press any key to continue...Done.
    Inserting a new row into table, press any key to continue...1 row(s) inserted
    Updating 'Location' for user 'Nikita', press any key to continue...1 row(s) updated
    Deleting user 'Jared', press any key to continue...1 row(s) deleted
    Reading data from table, press any key to continue...
    2 Nikita United States
    3 Tom Germany
    4 Jake United States
    All done. Press any key to finish...
    ```

> You have created your first C# + SQL Server example with the .NET Framework on Windows!
