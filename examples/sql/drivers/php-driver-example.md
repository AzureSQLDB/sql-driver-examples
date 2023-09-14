# Create a PHP app that connects to SQL Server and executes queries

> These examples may be used with Azure SQL Database

## Prerequisites

1. Ensure PHP is installed on your system. You can download PHP [here](https://www.php.net/downloads.php). In this example, PHP version 8.2 is used.


## Step 2.1 Install the PHP Drivers for SQL Server

1. Install the Microsoft PHP Drivers for SQL Server. You can download the drivers from the [download page](https://aka.ms/downloadmsphpsql). In this example, Microsoft Drivers 5.11 for PHP for SQL Server are used.

1. Next, copy the php_sqlsrv_82_ts_x64.dll and php_pdo_sqlsrv_82_ts_x64.dll files into your PHP extensions directory. This directory is usually the ext directory in your main PHP install folder.  

1. Enable Microsoft PHP Drivers for SQL Server by modifying the **php.ini** file. First, navigate to where you have PHP installed. If you do not find the **php.ini** file, make a copy of either **php.ini-development** or **php.ini-production** (depending on whether your system is a development environment or production environment) and rename it **php.ini**.

1. Using the windows terminal, change the directory to where you found the php.ini file. Now run the following command:

```terminal
    echo extension=php_sqlsrv_82_ts_x64.dll >> php.ini
    echo extension=php_pdo_sqlsrv_82_ts_x64.dll >> php.ini
```

## Step 2.2 Create a database for your application 

1. Create the database using sqlcmd.

```terminal
sqlcmd -S localhost -U sa -P your_password -Q "CREATE DATABASE SampleDB;"
```

## Step 2.3 Create a PHP app that connects to SQL Server and executes queries

1. Start by making a directory for the sample.

```terminal
mkdir SqlServerSample
cd SqlServerSample
```

1. Using your favorite text editor, create a new file called connect.php in the SqlServerSample folder. Paste the code below inside into the new file.

```php
<?php
    $serverName = "localhost";
    $connectionOptions = array(
        "Database" => "SampleDB",
        "Uid" => "sa",
        "PWD" => "your_password"
    );
    //Establishes the connection
    $conn = sqlsrv_connect($serverName, $connectionOptions);
    if($conn)
        echo "Connected!"
?>
```

1. Run your PHP script from the terminal.

```terminal
php connect.php
```

```results
Connected!
```

1. Execute the T-SQL scripts below in the terminal with sqlcmd to create a schema, table, and insert a few rows.

```terminal
sqlcmd -S localhost -U sa -P your_password -d SampleDB -Q "CREATE SCHEMA TestSchema;"
sqlcmd -S localhost -U sa -P your_password -d SampleDB -Q "CREATE TABLE TestSchema.Employees (Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY, Name NVARCHAR(50), Location NVARCHAR(50));"
sqlcmd -S localhost -U sa -P your_password -d SampleDB -Q "INSERT INTO TestSchema.Employees (Name, Location) VALUES (N'Jared', N'Australia'), (N'Nikita', N'India'), (N'Tom', N'Germany');"
sqlcmd -S localhost -U sa -P your_password -d SampleDB -Q "SELECT * FROM TestSchema.Employees;"
```

1. Using your favorite text editor, create a new file called interact.php in the SqlServerSample folder. Paste the code below inside into the new file. This will insert, update, delete, and read a few rows. 

```php
<?php
$serverName = "localhost";
$connectionOptions = array(
    "Database" => "SampleDB",
    "Uid" => "sa",
    "PWD" => "your_password"
);

//Establishes the connection
$conn = sqlsrv_connect($serverName, $connectionOptions);

//Insert Query
echo ("Inserting a new row into table" . PHP_EOL);
$tsql= "INSERT INTO TestSchema.Employees (Name, Location) VALUES (?,?);";
$params = array('Jake','United States');
$getResults= sqlsrv_query($conn, $tsql, $params);
$rowsAffected = sqlsrv_rows_affected($getResults);
if ($getResults == FALSE or $rowsAffected == FALSE)
    die(FormatErrors(sqlsrv_errors()));
echo ($rowsAffected. " row(s) inserted: " . PHP_EOL);

sqlsrv_free_stmt($getResults);

//Update Query

$userToUpdate = 'Nikita';
$tsql= "UPDATE TestSchema.Employees SET Location = ? WHERE Name = ?";
$params = array('Sweden', $userToUpdate);
echo("Updating Location for user " . $userToUpdate . PHP_EOL);

$getResults= sqlsrv_query($conn, $tsql, $params);
$rowsAffected = sqlsrv_rows_affected($getResults);
if ($getResults == FALSE or $rowsAffected == FALSE)
    die(FormatErrors(sqlsrv_errors()));
echo ($rowsAffected. " row(s) updated: " . PHP_EOL);
sqlsrv_free_stmt($getResults);

//Delete Query
$userToDelete = 'Jared';
$tsql= "DELETE FROM TestSchema.Employees WHERE Name = ?";
$params = array($userToDelete);
$getResults= sqlsrv_query($conn, $tsql, $params);
echo("Deleting user " . $userToDelete . PHP_EOL);
$rowsAffected = sqlsrv_rows_affected($getResults);
if ($getResults == FALSE or $rowsAffected == FALSE)
    die(FormatErrors(sqlsrv_errors()));
echo ($rowsAffected. " row(s) deleted: " . PHP_EOL);
sqlsrv_free_stmt($getResults);


//Read Query
$tsql= "SELECT Id, Name, Location FROM TestSchema.Employees;";
$getResults= sqlsrv_query($conn, $tsql);
echo ("Reading data from table" . PHP_EOL);
if ($getResults == FALSE)
    die(FormatErrors(sqlsrv_errors()));
while ($row = sqlsrv_fetch_array($getResults, SQLSRV_FETCH_ASSOC)) {
    echo ($row['Id'] . " " . $row['Name'] . " " . $row['Location'] . PHP_EOL);
}
sqlsrv_free_stmt($getResults);

function FormatErrors( $errors )
{
    /* Display errors. */
    echo "Error information: ";

    foreach ( $errors as $error )
    {
        echo "SQLSTATE: ".$error['SQLSTATE']."";
        echo "Code: ".$error['code']."";
        echo "Message: ".$error['message']."";
    }
}
?>
```

1. Run your PHP script from the terminal.

```terminal
php interact.php
```

```results
Inserting a new row into table
1 row(s) inserted:
Updating Location for user Nikita
1 row(s) updated:
Deleting user Jared
1 row(s) deleted:
Reading data from table
2 Nikita Sweden
3 Tom Germany
4 Jake United States
```

> Congratulations! You have created your first PHP app with SQL Server! Check out the next section to learn about how you can make your PHP faster with SQL Server's Columnstore feature.
