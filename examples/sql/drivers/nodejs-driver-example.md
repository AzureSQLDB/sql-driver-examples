# Create a Node.js app that connects to SQL Server and executes queries using Visual Studio Code

> These examples may be used with Azure SQL Database

## Prerequisites

1. [Node.js](https://nodejs.org/en/download) installed

## Step 1, Setup Node.js for development in Visual Studio Code

1. Start Visual Studio Code.

1. Select File > Open Folder (File > Open... on macOS) from the main menu.

1. In the Open Folder dialog, create a nodeexample folder in a directory of your choice and select it. Then click Select Folder (Open on macOS).

1. In the Do you trust the authors of the files in this folder? dialog, select **Yes, I trust the authors**.

1. Open the **Terminal** in Visual Studio Code by selecting View > Terminal from the main menu.

    The Terminal opens with the command prompt in the nodeexample folder.

1. In the Terminal, enter the following command to initialize Node dependencies.

    ```bash
    npm init -y
    ```

1. Next, in the terminal, install tedious and async module in the same project folder by running the following commands:

    ```bash
    npm install tedious
    npm install async
    ```

## Step 2, Create a Node.js app that connects to SQL Server

1. Create a file in Visual Studio Code by selecting File > New File from the main menu.

1. Enter connect.js for the file's name in the New File dialog and press enter/return.

1. Choose the nodeexample directory and create the file.

1. Replace the contents of connect.js by copying and pasting the code below into the file. Don't forget to replace

    ```javascript
    server: '<your_server.database.windows.net>',
    userName: '<your_username>',
    password: '<your_password>',
    port: <your_database_port>,
    ```

    with the values of your database.

    ```javascript
    var Connection = require('tedious').Connection;  
    
    var config = {
        server: '<your_server.database.windows.net>',
        authentication: {
            type: 'default',
            options: {
            userName: '<your_username>',
            password: '<your_password>' 
            }
        },
        options: {
            database: 'master',
            port: <your_database_port>,
            trustServerCertificate: true,
            encrypt: true
        }
    };
    
    const connection = new Connection(config);
    
    connection.connect((err) => {  
            if (err) 
            {
                console.log(err)
            }else{
                console.log("Connected");
                connection.close();
            }
    });
    ```

1. **Save** the file.

1. Run the application in the terminal with the following command:

    ```bash
    node connect.js
    ```

    with the output of the command being:

    ```results
    Connected
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

## Step 4, Create a sample Node.js app that gets rows from the database

1. Create a file in Visual Studio Code by selecting File > New File from the main menu.

1. Enter select.js for the file's name in the New File dialog and press enter/return.

1. Choose the nodeexample directory and create the file.

1. Replace the contents of select.js by copying and pasting the code below into the file. Don't forget to replace

    ```javascript
    server: '<your_server.database.windows.net>',
    userName: '<your_username>',
    password: '<your_password>',
    port: <your_database_port>,
    ```

    with the values of your database.

    ```javascript
    var Connection = require('tedious').Connection;

    var config = {
        server: '<your_server.database.windows.net>',
        authentication: {
            type: 'default',
            options: {
            userName: '<your_username>',
            password: '<your_password>' 
            }
        },
        options: {
            database: 'SampleDB',
            port: <your_database_port>,
            trustServerCertificate: true,
            encrypt: true
        }
    };
    
    const connection = new Connection(config);
    
    connection.connect((err) => {  
        // If no error, then good to proceed.  
        console.log("Connected");  
        executeStatement();  
    });  
    
    var Request = require('tedious').Request;  
    var TYPES = require('tedious').TYPES;  
    
    function executeStatement() {  
        var request = new Request("SELECT * from [TestSchema].[Employees];", function(err) {  
        if (err) {  
            console.log(err);}  
        });  
        var result = "";  
        request.on('row', function(columns) {  
            columns.forEach(function(column) {  
              if (column.value === null) {  
                console.log('NULL');  
              } else {  
                result+= column.value + " ";  
              }  
            });  
            console.log(result);  
            result ="";  
        });  
    
        request.on('done', function(rowCount, more) {  
        console.log(rowCount + ' rows returned');  
        });  
        
        // Close the connection after the final event emitted by the request, after the callback passes
        request.on("requestCompleted", function (rowCount, more) {
            connection.close();
        });
        connection.execSql(request);  
    } 
    ```

1. **Save** the file.

1. Run the application in the terminal with the following command:

    ```bash
    node select.js
    ```

    with the output of the command being:

    ```results
    Connected
    1 Jared Australia
    2 Nikita India
    3 Tom Germany
    ```

## Step 5, Create a sample Node.js app that interacts with the database

1. Create a file in Visual Studio Code by selecting File > New File from the main menu.

1. Enter interact.js for the file's name in the New File dialog and press enter/return.

1. Choose the nodeexample directory and create the file.

1. Replace the contents of interact.js by copying and pasting the code below into the file. Don't forget to replace

    ```javascript
    server: '<your_server.database.windows.net>',
    userName: '<your_username>',
    password: '<your_password>',
    port: <your_database_port>,
    ```

    with the values of your database.

    ```javascript
    var Connection = require('tedious').Connection;
    var Request = require('tedious').Request;
    var TYPES = require('tedious').TYPES;
    var async = require('async');
    
    var config = {
        server: '<your_server.database.windows.net>',
        authentication: {
            type: 'default',
            options: {
            userName: '<your_username>',
            password: '<your_password>' 
            }
        },
        options: {
            database: 'SampleDB',
            port: <your_database_port>,
            trustServerCertificate: true,
            encrypt: true
        }
    };
    
    function Start(callback) {
        console.log('Starting...');
        callback(null, 'Jake', 'United States');
    }
    
    function Insert(name, location, callback) {
        console.log("Inserting '" + name + "' into Table...");
    
        request = new Request(
            'INSERT INTO TestSchema.Employees (Name, Location) OUTPUT INSERTED.Id VALUES (@Name, @Location);',
            function(err, rowCount, rows) {
            if (err) {
                callback(err);
            } else {
                console.log(rowCount + ' row(s) inserted');
                callback(null, 'Nikita', 'United States');
            }
            });
        request.addParameter('Name', TYPES.NVarChar, name);
        request.addParameter('Location', TYPES.NVarChar, location);
    
        // Execute SQL statement
        connection.execSql(request);
    }
    
    function Update(name, location, callback) {
        console.log("Updating Location to '" + location + "' for '" + name + "'...");
    
        // Update the employee record requested
        request = new Request(
        'UPDATE TestSchema.Employees SET Location=@Location WHERE Name = @Name;',
        function(err, rowCount, rows) {
            if (err) {
            callback(err);
            } else {
            console.log(rowCount + ' row(s) updated');
            callback(null, 'Jared');
            }
        });
        request.addParameter('Name', TYPES.NVarChar, name);
        request.addParameter('Location', TYPES.NVarChar, location);
    
        // Execute SQL statement
        connection.execSql(request);
    }
    
    function Delete(name, callback) {
        console.log("Deleting '" + name + "' from Table...");
    
        // Delete the employee record requested
        request = new Request(
            'DELETE FROM TestSchema.Employees WHERE Name = @Name;',
            function(err, rowCount, rows) {
            if (err) {
                callback(err);
            } else {
                console.log(rowCount + ' row(s) deleted');
                callback(null);
            }
            });
        request.addParameter('Name', TYPES.NVarChar, name);
    
        // Execute SQL statement
        connection.execSql(request);
    }
    
    function Read(callback) {
        console.log('Reading rows from the Table...');
    
        // Read all rows from table
        request = new Request(
        'SELECT Id, Name, Location FROM TestSchema.Employees;',
        function(err, rowCount, rows) {
        if (err) {
            callback(err);
        } else {
            console.log(rowCount + ' row(s) returned');
            callback(null);
        }
        });
    
        // Print the rows read
        var result = ""; 
        request.on('row', function(columns) {
            columns.forEach(function(column) {
                if (column.value === null) {
                    console.log('NULL');
                } else {
                    result += column.value + " ";
                }
            });
            console.log(result);
            result = "";
        });
    
        // Execute SQL statement
        connection.execSql(request);
    }
    
    function Complete(err, result) {
        if (err) {
            callback(err);
        } else {
            console.log("Done!");
            connection.close();
        }
    }
    
    // Attempt to connect and execute queries if connection goes through
    
    const connection = new Connection(config);
    
    connection.connect((err) => {  
      if (err) {
        console.log(err);
      } else {
        console.log('Connected');
    
        // Execute all functions in the array serially
        async.waterfall([
            Start,
            Insert,
            Update,
            Delete,
            Read
        ], Complete)
      }
    });
    ```

1. **Save** the file.

1. Run the application in the terminal with the following command:

    ```bash
    node interact.js
    ```

    with the results being:

    ```results
    Connected
    Starting...
    Inserting 'Jake' into Table...
    1 row(s) inserted
    Updating Location to 'United States' for 'Nikita'...
    1 row(s) updated
    Deleting 'Jared' from Table...
    1 row(s) deleted
    Reading rows from the Table...
    2 Nikita United States
    3 Tom Germany
    4 Jake United States
    3 row(s) returned
    Done!
    ```

> Congratulations! You created your first Node.js apps with SQL Server!
