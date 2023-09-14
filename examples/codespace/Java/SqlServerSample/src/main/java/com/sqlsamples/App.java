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