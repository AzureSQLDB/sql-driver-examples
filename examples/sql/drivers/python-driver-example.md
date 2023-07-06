# Create a Python app that connects to SQL Server and executes queries using Visual Studio Code

> These examples may be used with Azure SQL Database

## Prerequisites

1. [Python](https://www.python.org/downloads/)
1. [Microsoft ODBC Driver 18 for SQL Server](https://learn.microsoft.com/sql/connect/odbc/download-odbc-driver-for-sql-server)

## Step 1, Setup Python for development in Visual Studio Code

1. Start Visual Studio Code.

1. Select File > Open Folder (File > Open... on macOS) from the main menu.

1. In the Open Folder dialog, create a pythonexample folder in a directory of your choice and select it. Then click Select Folder (Open on macOS).

1. In the Do you trust the authors of the files in this folder? dialog, select **Yes, I trust the authors**.

1. Open the **Terminal** in Visual Studio Code by selecting View > Terminal from the main menu.

    The Terminal opens with the command prompt in the pythonexample folder.

1. In the Terminal, enter the following command to install the [Python SQL Driver](https://learn.microsoft.com/sql/connect/python/pyodbc/python-sql-driver-pyodbc):

    ```bash
    pip install pyodbc 
    ```

## Step 2, Create a Python app that connects to SQL Server

1. Create a file in Visual Studio Code by selecting File > New File from the main menu.

1. Enter connect.py for the file's name in the New File dialog and press enter/return.

1. Choose the pythonexample directory and create the file.

1. Replace the contents of connect.py by copying and pasting the code below into the file. Don't forget to replace

    ```python
    server = 'tcp:<your_server.database.windows.net>'
    username = '<your_username>'
    password = '<your_password>'
    port = '<your_port_number>'
    ```

    with the values of your database.

    ```python
    import pyodbc 

    server = 'tcp:<your_server.database.windows.net>'
    database = 'master'
    username = '<your_username>'
    password = '<your_password>'
    port = '<your_port_number>'

    # ENCRYPT defaults to yes starting in ODBC Driver 18. It's good to always specify ENCRYPT=yes on the client side to avoid MITM attacks.
    cnxn = pyodbc.connect('DRIVER={ODBC Driver 18 for SQL Server};SERVER='+server+','+port+';DATABASE='+database+';ENCRYPT=yes;TrustServerCertificate=yes;UID='+username+';PWD='+ password)
    cursor = cnxn.cursor()
    
    #Sample select query
    cursor.execute("SELECT @@version;") 
    row = cursor.fetchone() 
    while row: 
        print(row[0])
        row = cursor.fetchone()
    ```

1. **Save** the file.

1. Run the application in the terminal with the following command:

    ```terminal
    python connect.py
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

## Step 4, Create a sample Python app that interacts with the database

1. Create a file in Visual Studio Code by selecting File > New File from the main menu.

1. Enter interact.go for the file's name in the New File dialog and press enter/return.

1. Choose the pythonexample directory and create the file.

1. Replace the contents of interact.py by copying and pasting the code below into the file. Don't forget to replace

    ```python
    server = 'tcp:<your_server.database.windows.net>'
    username = '<your_username>'
    password = '<your_password>'
    port = '<your_port_number>'
    ```

    with the values of your database.

    ```python
    import pyodbc
    server = 'tcp:<your_server.database.windows.net>'
    database = 'SampleDB'
    username = '<your_username>'
    password = '<your_password>'
    port = '<your_port_number>'
    cnxn = pyodbc.connect('DRIVER={ODBC Driver 18 for SQL Server};SERVER='+server+','+port+';DATABASE='+database+';ENCRYPT=yes;TrustServerCertificate=yes;UID='+username+';PWD='+ password)
    cursor = cnxn.cursor()
    
    print ('Inserting a new row into table')
    #Insert Query
    tsql = "INSERT INTO TestSchema.Employees (Name, Location) VALUES (?,?);"
    with cursor.execute(tsql,'Jake','United States'):
        print ('Successfully Inserted!')
    
    
    #Update Query
    print ('Updating Location for Nikita')
    tsql = "UPDATE TestSchema.Employees SET Location = ? WHERE Name = ?"
    with cursor.execute(tsql,'Sweden','Nikita'):
        print ('Successfully Updated!')
    
    
    #Delete Query
    print ('Deleting user Jared')
    tsql = "DELETE FROM TestSchema.Employees WHERE Name = ?"
    with cursor.execute(tsql,'Jared'):
        print ('Successfully Deleted!')
    
    
    #Select Query
    print ('Reading data from table')
    tsql = "SELECT Name, Location FROM TestSchema.Employees;"
    with cursor.execute(tsql):
        row = cursor.fetchone()
        while row:
            print (str(row[0]) + " " + str(row[1]))
            row = cursor.fetchone()
    ```

1. **Save** the file.

1. Run the application in the terminal with the following command:

    ```terminal
    python interact.py
    ```

    with the output of the command being similar to the following (version numbers may be different):

    ```results
    Inserting a new row into table
    Successfully Inserted!
    Updating Location for Nikita
    Successfully Updated!
    Deleting user Jared
    Successfully Deleted!
    Reading data from table
    Nikita Sweden
    Tom Germany
    Jake United States
    ```

> Congratulations! You created your first Python apps with SQL Server!
