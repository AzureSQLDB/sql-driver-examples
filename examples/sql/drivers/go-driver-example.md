# Create a Go app that connects to SQL Server

> These examples may be used with Azure SQL Database

## Prerequisites

1. Have [Go](https://go.dev/dl/) installed
1. Install the [SQL Server (mssql) extension](https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql)

## Step 1, Setup Go for development in Visual Studio Code

1. Start Visual Studio Code.

1. Select File > Open Folder (File > Open... on macOS) from the main menu.

1. In the Open Folder dialog, create a goexample folder in a directory of your choice and select it. Then click Select Folder (Open on macOS).

1. In the Do you trust the authors of the files in this folder? dialog, select **Yes, I trust the authors**.

1. Open the **Terminal** in Visual Studio Code by selecting View > Terminal from the main menu.

    The Terminal opens with the command prompt in the goexample folder.

1. In the Terminal, enter the following command to initialize the go.mod file:

    ```bash
    go mod init goexample.com/m/v2
    ```

    with the output of the command being

    ```results
    go: creating new go.mod: module goexample.com/m/v2
    ```

    and a go.mod file created.

1. Add the Microsoft SQL driver for Go to the project with the following command in the terminal:

    ```bash
    go get github.com/microsoft/go-mssqldb@latest
    ```

    with the output of the command being similar to the following (version numbers may be different):

    ```results
    go: added github.com/golang-sql/civil v0.0.0-20220223132316-b832511892a9
    go: added github.com/golang-sql/sqlexp v0.1.0
    go: added github.com/microsoft/go-mssqldb v1.3.0
    go: added golang.org/x/crypto v0.9.0
    ```

## Step 2, Create a Go app that connects to SQL Server

1. Create a file in Visual Studio Code by selecting File > New File from the main menu.

1. Enter connect.go for the file's name in the New File dialog and press enter/return.

1. Choose the goexample directory and create the file.

1. Replace the contents of connect.go by copying and pasting the code below into the file. Don't forget to replace

    ```go
    var server = "<your_server.database.windows.net>"
    var port = <your_database_port>
    var user = "<your_username>"
    var password = "<your_password>"
    ```

    with the values of your database.

    ```go
    package main
    
    import (
        _ "github.com/microsoft/go-mssqldb"
        "database/sql"
        "context"
        "log"
        "fmt"
    )
    
    // Replace with your own connection parameters
    var server = "<your_server.database.windows.net>"
    var port = <your_database_port>
    var user = "<your_username>"
    var password = "<your_password>"
    
    var db *sql.DB
    
    func main() {
        var err error
    
        // Create connection string
        connString := fmt.Sprintf("server=%s;user id=%s;password=%s;port=%d",
            server, user, password, port)
    
        // Create connection pool
        db, err = sql.Open("sqlserver", connString)
        if err != nil {
            log.Fatal("Error creating connection pool: " + err.Error())
        }
        log.Printf("Connected!\n")
    
        // Close the database connection pool after program executes
        defer db.Close()
    
        SelectVersion()
    }
    
    // Gets and prints SQL Server version
    func SelectVersion(){
        // Use background context
        ctx := context.Background()
    
        // Ping database to see if it's still alive.
        // Important for handling network issues and long queries.
        err := db.PingContext(ctx)
        if err != nil {
            log.Fatal("Error pinging database: " + err.Error())
        }
    
        var result string
    
        // Run query and scan for result
        err = db.QueryRowContext(ctx, "SELECT @@version").Scan(&result)
        if err != nil {
            log.Fatal("Scan failed:", err.Error())
        }
        fmt.Printf("%s\n", result)
    }
    ```

1. **Save** the file.

1. Run the application in the terminal with the following command:

    ```terminal
    go run connect.go
    ```

    with the output of the command being similar to the following (version numbers may be different):

    ```results
    2023/07/05 12:54:35 Connected!
    Microsoft SQL Server 2022 (RTM-CU5) (KB5026806) - 16.0.4045.3 (X64) 
            May 26 2023 12:52:08
            Copyright (C) 2022 Microsoft Corporation
            Developer Edition (64-bit) on Linux (Ubuntu 20.04.6 LTS) <X64>
    ```

## Step 3, Create a sample database, schema, and objects

Use [Query Editor sheets in Visual Studio Code](https://code.visualstudio.com/docs/languages/tsql) to run the following TSQL in the Master and SampleDB Databases.

1. Run the following TSQL in the **Master** database.

    ```sql
    DROP DATABASE IF EXISTS [SampleDB]; CREATE DATABASE [SampleDB]
    GO
    ```

1. Run the following TSQL in the **SampleDB** database.

    ```sql
    CREATE SCHEMA TestSchema;
    GO
    
    CREATE TABLE TestSchema.Employees (
      Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
      Name NVARCHAR(50),
      Location NVARCHAR(50)
    );
    GO
    
    INSERT INTO TestSchema.Employees (Name, Location) VALUES
    (N'Jared', N'Australia'),
    (N'Nikita', N'India'),
    (N'Tom', N'Germany');
    GO
    
    SELECT * FROM TestSchema.Employees;
    GO
    ```

## Step 4, Create a sample Go app that interacts with the database

1. Create a file in Visual Studio Code by selecting File > New File from the main menu.

1. Enter interact.go for the file's name in the New File dialog and press enter/return.

1. Choose the goexample directory and create the file.

1. Replace the contents of interact.go by copying and pasting the code below into the file. Don't forget to replace

    ```go
    var server = "<your_server.database.windows.net>"
    var port = <your_database_port>
    var user = "<your_username>"
    var password = "<your_password>"
    ```

    with the values of your database.

    ```go
    package main
    
    import (
        _ "github.com/microsoft/go-mssqldb"
        "database/sql"
        "context"
        "log"
        "fmt"
    )
    
    var db *sql.DB
    
    var server = "<your_server.database.windows.net>"
    var port = <your_database_port>
    var user = "<your_username>"
    var password = "<your_password>"
    var database = "SampleDB"
    
    func main() {
        // Build connection string
        connString := fmt.Sprintf("server=%s;user id=%s;password=%s;port=%d;database=%s;",
            server, user, password, port, database)
    
        var err error
    
        // Create connection pool
        db, err = sql.Open("sqlserver", connString)
        if err != nil {
            log.Fatal("Error creating connection pool:", err.Error())
        }
        fmt.Printf("Connected!\n")
    
        // Create employee
        createId, err := CreateEmployee("Jake", "United States")
        fmt.Printf("Inserted ID: %d successfully.\n", createId)
    
        // Read employees
        count, err := ReadEmployees()
        fmt.Printf("Read %d rows successfully.\n", count)
    
        // Update from database
        updateId, err := UpdateEmployee("Jake", "Poland")
        fmt.Printf("Updated row with ID: %d successfully.\n", updateId)
    
        // Delete from database
        rows, err := DeleteEmployee("Jake")
        fmt.Printf("Deleted %d rows successfully.\n", rows)
    }
    
    func CreateEmployee(name string, location string) (int64, error) {
        ctx := context.Background()
        var err error
    
        if db == nil {
            log.Fatal("What?")
        }
    
        // Check if database is alive.
        err = db.PingContext(ctx)
        if err != nil {
            log.Fatal("Error pinging database: " + err.Error())
        }
    
        tsql := fmt.Sprintf("INSERT INTO TestSchema.Employees (Name, Location) VALUES ('%s','%s');",
            name, location)
    
        // Execute non-query
        result, err := db.ExecContext(ctx, tsql)
        if err != nil {
            log.Fatal("Error inserting new row: " + err.Error())
            return -1, err
        }
    
        return result.LastInsertId()
    }
    
    func ReadEmployees() (int, error) {
        ctx := context.Background()
    
        // Check if database is alive.
        err := db.PingContext(ctx)
        if err != nil {
            log.Fatal("Error pinging database: " + err.Error())
        }
    
        tsql := fmt.Sprintf("SELECT Id, Name, Location FROM TestSchema.Employees;")
    
        // Execute query
        rows, err := db.QueryContext(ctx, tsql)
        if err != nil {
            log.Fatal("Error reading rows: " + err.Error())
            return -1, err
        }
    
        defer rows.Close()
    
        var count int = 0
    
        // Iterate through the result set.
        for rows.Next() {
            var name, location string
            var id int
    
            // Get values from row.
            err := rows.Scan(&id, &name, &location)
            if err != nil {
                log.Fatal("Error reading rows: " + err.Error())
                return -1, err
            }
    
            fmt.Printf("ID: %d, Name: %s, Location: %s\n", id, name, location)
            count++
        }
    
        return count, nil
    }
    
    // Update an employee's information
    func UpdateEmployee(name string, location string) (int64, error) {
        ctx := context.Background()
    
        // Check if database is alive.
        err := db.PingContext(ctx)
        if err != nil {
            log.Fatal("Error pinging database: " + err.Error())
        }
    
        tsql := fmt.Sprintf("UPDATE TestSchema.Employees SET Location = @Location WHERE Name= @Name")
    
        // Execute non-query with named parameters
        result, err := db.ExecContext(
            ctx,
            tsql,
            sql.Named("Location", location),
            sql.Named("Name", name))
        if err != nil {
            log.Fatal("Error updating row: " + err.Error())
            return -1, err
        }
    
        return result.LastInsertId()
    }
    
    // Delete an employee from database
    func DeleteEmployee(name string) (int64, error) {
        ctx := context.Background()
    
        // Check if database is alive.
        err := db.PingContext(ctx)
        if err != nil {
            log.Fatal("Error pinging database: " + err.Error())
        }
    
        tsql := fmt.Sprintf("DELETE FROM TestSchema.Employees WHERE Name=@Name;")
    
        // Execute non-query with named parameters
        result, err := db.ExecContext(ctx, tsql, sql.Named("Name", name))
        if err != nil {
            fmt.Println("Error deleting row: " + err.Error())
            return -1, err
        }
    
        return result.RowsAffected()
    }
    ```

1. Run the interact.go app in the terminal to see the results

    ```terminal
    go run interact.go
    ```

    with the results being:

    ```results
    Connected!
    Inserted ID: 4 successfully.
    ID: 1, Name: Jared, Location: Australia
    ID: 2, Name: Nikita, Location: India
    ID: 3, Name: Tom, Location: Germany
    ID: 4, Name: Jake, Location: United States
    Read 4 rows successfully.
    Updated row with ID: 4 successfully.
    Deleted 1 rows successfully.
    ```

> Congratulations! You created your first Go apps with SQL Server!
