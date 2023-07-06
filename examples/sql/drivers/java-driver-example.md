# Create a Java app that connects to SQL Server and executes queries using Visual Studio Code

> These examples may be used with Azure SQL Database

## Prerequisites

1. [Java](https://www.java.com/en/download/)
1. [Maven](https://maven.apache.org/download.cgi)
1. Ensure that both Maven and Java are in you Environment PATH. You can check Maven with **mvn -version** and Java with **java -version**.

## Step 1, Create a Java app that connects to SQL Server

1. Start Visual Studio Code.

1. Select File > Open Folder (File > Open... on macOS) from the main menu.

1. In the Open Folder dialog, create a javaexample folder in a directory of your choice and select it. Then click Select Folder (Open on macOS).

1. In the Do you trust the authors of the files in this folder? dialog, select **Yes, I trust the authors**.

1. Open the **Terminal** in Visual Studio Code by selecting View > Terminal from the main menu.

    The Terminal opens with the command prompt in the javaexample folder.

1. In the Terminal, enter the following command to create a Maven starter package:

    ```bash
    mvn archetype:generate "-DgroupId=com.sqlsamples" "-DartifactId=SqlServerSample" "-DarchetypeArtifactId=maven-archetype-quickstart" "-Dversion=1.0.0"
    ```

    > You may need to press enter/return to have the command continue when you come to a point with the text " Y: :".

1. In the Visual Studio Code file explorer, expand the SqlServerSample directory and click on the pom.xml file.

    > What is a [pom.xml](https://maven.apache.org/pom.html)?

1. Replace the contents of the pom.xml file with the following code:

    ```xml
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <groupId>com.sqlsamples</groupId>
        <artifactId>SqlServerSample</artifactId>
        <packaging>jar</packaging>
        <version>1.0.0</version>
        <name>SqlServerSample</name>
        <url>http://maven.apache.org</url>
        <dependencies>
            <dependency>
                <groupId>junit</groupId>
                <artifactId>junit</artifactId>
                <version>4.13.2</version>
                <scope>test</scope>
            </dependency>
            <!-- add the JDBC Driver -->
            <dependency>
                <groupId>com.microsoft.sqlserver</groupId>
                <artifactId>mssql-jdbc</artifactId>
                <version>12.2.0.jre8</version>
            </dependency>
        </dependencies>
        <properties>
            <!-- specify which version of Java to build against-->
            <maven.compiler.source>1.8</maven.compiler.source>
            <maven.compiler.target>1.8</maven.compiler.target>
        </properties>
    </project>
    ```

1. **Save** the file.

1. Using the Visual Studio Code file explorer again, find the App.java file located at SqlServerSample\src\main\java\com\sqlsamples\App.java

1. Click on the App.java file to bring it up in the Visual Studio Code editor.

1. Replace the contents of App.java by copying and pasting the code below into the file. Don't forget to replace

    ```java
    String connectionUrl = "jdbc:sqlserver://<your_server.database.windows.net>:<your_database_port>;databaseName=master;encrypt=true;trustServerCertificate=true;user=<your_username>;password=<your_password>";
    ```

    with the values of your database.

    ```java
    package com.sqlsamples;
    
    import java.sql.Connection;
    import java.sql.DriverManager;
    
    public class App {
    
        public static void main(String[] args) {
    
            String connectionUrl = "jdbc:sqlserver://<your_server.database.windows.net>:<your_database_port>;databaseName=master;encrypt=true;trustServerCertificate=true;user=<your_username>;password=<your_password>";
    
            try {
                // Load SQL Server JDBC driver and establish connection.
                System.out.print("Connecting to SQL Server ... ");
                try (Connection connection = DriverManager.getConnection(connectionUrl)) {
                    System.out.println("Done.");
                }
            } catch (Exception e) {
                System.out.println();
                e.printStackTrace();
            }
        }
    }
    ```

1. **Save** the file.

1. Using the terminal, enter the javaexample\SqlServerSample directory. You can check in the terminal with the pwd command with the output of the command being similar to the following. The important point is to be in the SqlServerSample directory:

    ```results
    PS C:\projects\javaexample\SqlServerSample> pwd

    Path
    ----
    C:\projects\javaexample\SqlServerSample
    ```

1. While in the SqlServerSample directory, build the project and create a jar package using the following command:

    ```bash
    mvn package
    ```

1. Again, in the terminal, run the application with the following command. You can remove the “-q” in the command below to show info messages from Maven.

    ```bash
    mvn -q exec:java "-Dexec.mainClass=com.sqlsamples.App"
    ```

    with the output of the command being:

    ```results
    Connecting to SQL Server ... Done.
    ```

## Step 2, Create a Java app that connects to SQL Server and executes queries using Visual Studio Code

1. Open the App.java file in a Visual Studio Code editor page if not already opened. The next app will create a database and a table, and will insert, update, delete, and read a few rows.

1. Replace the contents of App.java by copying and pasting the code below into the file. Don't forget to replace

    ```java
    String connectionUrl = "jdbc:sqlserver://<your_server.database.windows.net>:<your_database_port>;databaseName=master;encrypt=true;trustServerCertificate=true;user=<your_username>;password=<your_password>";
    ```

    with the values of your database.

    ```java
    package com.sqlsamples;
    
    import java.sql.Connection;
    import java.sql.Statement;
    import java.sql.PreparedStatement;
    import java.sql.ResultSet;
    import java.sql.DriverManager;
    
    public class App {
    
        public static void main(String[] args) {
    
            System.out.println("Connect to SQL Server and demo Create, Read, Update and Delete operations.");
    
            //Update the username and password below
            String connectionUrl = "jdbc:sqlserver://<your_server.database.windows.net>:<your_database_port>;databaseName=master;encrypt=true;trustServerCertificate=true;user=<your_username>;password=<your_password>";
    
            try {
                // Load SQL Server JDBC driver and establish connection.
                System.out.print("Connecting to SQL Server ... ");
                try (Connection connection = DriverManager.getConnection(connectionUrl)) {
                    System.out.println("Done.");
    
                    // Create a sample database
                    System.out.print("Dropping and creating database 'SampleDB' ... ");
                    String sql = "DROP DATABASE IF EXISTS [SampleDB]; CREATE DATABASE [SampleDB]";
                    try (Statement statement = connection.createStatement()) {
                        statement.executeUpdate(sql);
                        System.out.println("Done.");
                    }
    
                    // Create a Table and insert some sample data
                    System.out.print("Creating sample table with data, press ENTER to continue...");
                    System.in.read();
                    sql = new StringBuilder().append("USE SampleDB; ").append("CREATE TABLE Employees ( ")
                            .append(" Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY, ").append(" Name NVARCHAR(50), ")
                            .append(" Location NVARCHAR(50) ").append("); ")
                            .append("INSERT INTO Employees (Name, Location) VALUES ").append("(N'Jared', N'Australia'), ")
                            .append("(N'Nikita', N'India'), ").append("(N'Tom', N'Germany'); ").toString();
                    try (Statement statement = connection.createStatement()) {
                        statement.executeUpdate(sql);
                        System.out.println("Done.");
                    }
    
                    // INSERT demo
                    System.out.print("Inserting a new row into table, press ENTER to continue...");
                    System.in.read();
                    sql = new StringBuilder().append("INSERT Employees (Name, Location) ").append("VALUES (?, ?);")
                            .toString();
                    try (PreparedStatement statement = connection.prepareStatement(sql)) {
                        statement.setString(1, "Jake");
                        statement.setString(2, "United States");
                        int rowsAffected = statement.executeUpdate();
                        System.out.println(rowsAffected + " row(s) inserted");
                    }
    
                    // UPDATE demo
                    String userToUpdate = "Nikita";
                    System.out.print("Updating 'Location' for user '" + userToUpdate + "', press ENTER to continue...");
                    System.in.read();
                    sql = "UPDATE Employees SET Location = N'United States' WHERE Name = ?";
                    try (PreparedStatement statement = connection.prepareStatement(sql)) {
                        statement.setString(1, userToUpdate);
                        int rowsAffected = statement.executeUpdate();
                        System.out.println(rowsAffected + " row(s) updated");
                    }
    
                    // DELETE demo
                    String userToDelete = "Jared";
                    System.out.print("Deleting user '" + userToDelete + "', press ENTER to continue...");
                    System.in.read();
                    sql = "DELETE FROM Employees WHERE Name = ?;";
                    try (PreparedStatement statement = connection.prepareStatement(sql)) {
                        statement.setString(1, userToDelete);
                        int rowsAffected = statement.executeUpdate();
                        System.out.println(rowsAffected + " row(s) deleted");
                    }
    
                    // READ demo
                    System.out.print("Reading data from table, press ENTER to continue...");
                    System.in.read();
                    sql = "SELECT Id, Name, Location FROM Employees;";
                    try (Statement statement = connection.createStatement();
                            ResultSet resultSet = statement.executeQuery(sql)) {
                        while (resultSet.next()) {
                            System.out.println(
                                    resultSet.getInt(1) + " " + resultSet.getString(2) + " " + resultSet.getString(3));
                        }
                    }
                    connection.close();
                    System.out.println("All done.");
                }
            } catch (Exception e) {
                System.out.println();
                e.printStackTrace();
            }
        }
    }
    ```

1. **Save** the file.

1. Using the terminal, enter the javaexample\SqlServerSample directory if not already there from the previous example. You can check in the terminal with the pwd command with the output of the command being similar to the following. The important point is to be in the SqlServerSample directory:

    ```results
    PS C:\projects\javaexample\SqlServerSample> pwd

    Path
    ----
    C:\projects\javaexample\SqlServerSample
    ```

1. While in the SqlServerSample directory, build the project and create a jar package using the following command:

    ```bash
    mvn package
    ```

1. Again, in the terminal, run the application with the following command. You can remove the “-q” in the command below to show info messages from Maven.

    ```bash
    mvn -q exec:java "-Dexec.mainClass=com.sqlsamples.App"
    ```

    with the output of the command being similar to the following. You will have to press enter/return to interact with the operations that the app is performing:

    ```results
    Connect to SQL Server and demo Create, Read, Update and Delete operations.
    Connecting to SQL Server ... Done.
    Dropping and creating database 'SampleDB' ... Done.
    Creating sample table with data, press ENTER to continue...
    Done.
    Inserting a new row into table, press ENTER to continue...1 row(s) inserted
    Updating 'Location' for user 'Nikita', press ENTER to continue...
    1 row(s) updated
    Deleting user 'Jared', press ENTER to continue...1 row(s) deleted
    Reading data from table, press ENTER to continue...
    2 Nikita United States
    3 Tom Germany
    4 Jake United States
    All done.
    ```

> Congratulations! You created your first Java apps with SQL Server! 