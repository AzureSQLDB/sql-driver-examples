---
layout: page-steps
language: C#
title: Windows
permalink: /csharp/win/server/step/2
---

# Create a C# app that connects to SQL Server with the Microsoft SqlClient Data Provider for SQL Server

> Prerequisites
    1. C# for Visual Studio Code

## Step 1, Create a C# app that connects to SQL Server and executes queries using Visual Studio Code

Start Visual Studio Code.

Select File > Open Folder (File > Open... on macOS) from the main menu.

In the Open Folder dialog, create a HelloWorld folder and select it. Then click Select Folder (Open on macOS).

The folder name becomes the project name and the namespace name by default. You'll add code later in the tutorial that assumes the project namespace is HelloWorld.

In the Do you trust the authors of the files in this folder? dialog, select Yes, I trust the authors.

Open the Terminal in Visual Studio Code by selecting View > Terminal from the main menu.

The Terminal opens with the command prompt in the HelloWorld folder.

In the Terminal, enter the following command:

.NET CLI


dotnet new console --framework net7.0


dotnet add package Microsoft.Data.SqlClient

**Create a C# console application**

1. Launch Visual Studio Community
1. Click **File -> New -> Project**
1. In the **New project** dialog, click **Windows** located under **Visual C#** in the **Templates** node
1. Click **Console Application Visual C#**
1. Name the project _"SqlServerSample"_
1. Click **OK** to create the project


## Step 2, Issue a database query with the Microsoft SqlClient Data Provider for SQL Server

Visual Studio creates a new C# Console Application project and opens the file **Program.cs**. Replace the contents of Program.cs by copying and pasting the code below into the file. Don't forget to replace the username and password with your own. Save and close the file.


Section on
                builder.DataSource = "<your_server.database.windows.net>"; 
                builder.UserID = "<your_username>";            
                builder.Password = "<your_password>";     
                builder.InitialCatalog = "<your_database>";
and can be Azure or SQL Server


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

Run the following command in the Terminal:

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

Now replace the code in **Program.cs** by copying and pasting the code below into the file. This will create a database and a table, and will [insert](https://docs.microsoft.com/en-us/sql/t-sql/statements/insert-transact-sql), [update](https://docs.microsoft.com/en-us/sql/t-sql/queries/update-transact-sql), [delete](https://docs.microsoft.com/en-us/sql/t-sql/statements/delete-transact-sql), and read a few rows. Don't forget to update the username and password with your own. Save and close the file.

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

Press **F5** to build and run your project.

```results
Connect to SQL Server and demo Create, Read, Update and Delete operations.
Connecting to SQL Server ...
Done.
Dropping and creating database 'SampleDB' ... Done.
Creating sample table with data, press any key to continue...
Done.
Inserting a new row into table, press any key to continue...
1 row(s) inserted
Updating 'Location' for user 'Nikita', press any key to continue...
1 row(s) updated
Deleting user 'Jared', press any key to continue...
1 row(s) deleted
Reading data from table, press any key to continue...
2 Nikita United States
3 Tom Germany
4 Jake United States
All done. Press any key to finish...
```

> You created your first C# + SQL Server app with .NET Framework on Windows! Check out the next section to create a C# app using an ORM!

## Step 2.2 Create a C# app that connects to SQL Server using the Entity Framework ORM in .NET Framework

**Create a C# console application**

1. Launch Visual Studio Community
1. Click **File -> New -> Project**
1. In the **New project** dialog, click **Windows** located under **Visual C#** in the **Templates** node 
1. Click **Console Application Visual C#**
1. Name the project "_SqlServerEFSample"_
1. Click **OK** to create the project

Visual Studio creates a new C# Console Application project and opens the file **Program.cs**.

**Add Entity Framework dependencies to your project**

1. Open the Package Manager Console in Visual Studio with "Tools -> Nuget Package Manager -> Package Manager Console"
1. Type: "Install-Package EntityFramework"
1. Hit enter

```results
Attempting to gather dependency information for package 'EntityFramework.6.1.3' with respect to project 'SqlServerEFSample', targeting '.NETFramework,Version=v4.5.2'
Attempting to resolve dependencies for package 'EntityFramework.6.1.3' with DependencyBehavior 'Lowest'
Resolving actions to install package 'EntityFramework.6.1.3'
Resolved actions to install package 'EntityFramework.6.1.3'
  GET https://api.nuget.org/packages/entityframework.6.1.3.nupkg
  OK https://api.nuget.org/packages/entityframework.6.1.3.nupkg 17ms
Installing EntityFramework 6.1.3.
Adding package 'EntityFramework.6.1.3' to folder 'c:\users\usr1\documents\visual studio 2015\Projects\SqlServerEFSample\packages'
Added package 'EntityFramework.6.1.3' to folder 'c:\users\usr1\documents\visual studio 2015\Projects\SqlServerEFSample\packages'
Added package 'EntityFramework.6.1.3' to 'packages.config'
Executing script file 'c:\users\usr1\documents\visual studio 2015\Projects\SqlServerEFSample\packages\EntityFramework.6.1.3\tools\init.ps1'
Executing script file 'c:\users\usr1\documents\visual studio 2015\Projects\SqlServerEFSample\packages\EntityFramework.6.1.3\tools\install.ps1'

Type 'get-help EntityFramework' to see all available Entity Framework commands.
Successfully installed 'EntityFramework 6.1.3' to SqlServerEFSample
```

Close the Package Manager Console. You have successfully added the required Entity Framework dependencies to your project.

For this sample, let's create two tables. The first will hold data about "users" and the other will hold data about “tasks”.

**Create User.cs:**

1. Click **Project -> Add Class**
1. Type "User.cs" in the name field
1. Click **Add** to add the new class to your project

Copy and paste the following code into the **User.cs** file. Save and close the file.

{% include partials/csharp/sample_3.md %}

**Create Task.cs:**

1. Click **Project -> Add Class**
2. Type "Task.cs" in the name field
3. Click **Add** to add the new class to your project

Copy and paste the following code into the **Task.cs** file. Save and close the file.
{% include partials/csharp/sample_4.md %}

**Create EFSampleContext.cs:**

1. Click Project -> Add Class
2. Type "EFSampleContext.cs" in the name field
3. Click Add to add the new class to your project

Copy and paste the following code into the **EFSampleContext.cs** file. Save and close the file.
{% include partials/csharp/sample_5.md %}

Replace the code in the **Program.cs** file in your by copying and pasting the code into the file. Don't forget to update the username and password with your own. Save and close the file.
{% include partials/csharp/sample_6.md %}

Press **F5** to build and run the project.

```results
** C# CRUD sample with Entity Framework and SQL Server **

Created database schema from C# classes.

Created User: User [id=1, name=Anna Shrestinian]

Created Task: Task [id=1, title=Ship Helsinki, dueDate=4/1/2017 12:00:00 AM, IsComplete=False]

Assigned Task: 'Ship Helsinki' to user 'Anna Shrestinian'

Incomplete tasks assigned to 'Anna':
Task [id=1, title=Ship Helsinki, dueDate=4/1/2017 12:00:00 AM, IsComplete=False]

Updating task: Task [id=1, title=Ship Helsinki, dueDate=4/1/2017 12:00:00 AM, IsComplete=False]
dueDate changed: Task [id=1, title=Ship Helsinki, dueDate=6/30/2016 12:00:00 AM, IsComplete=False]

Deleting all tasks with a dueDate in 2016
Deleting task: Task [id=1, title=Ship Helsinki, dueDate=6/30/2016 12:00:00 AM, IsComplete=False]

Tasks after delete:
[None]
All done. Press any key to finish...
```

> Congratulations! You just created two C# apps! Check out the next section to learn about how you can **make your C# apps faster with SQL Server's Columnstore feature.**
