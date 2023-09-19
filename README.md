# Get started developing with SQL Server and Azure SQL Database

## Driver code examples for SQL Server and Azure SQL DB developers to get started.


### Using codespaces

Can't install VS Code? Or the drivers? Or just want to test drive these examples? No problem! Create a codespace on this repository with everything you need pre-installed!

This codespace takes a bit of time to create seeing we are installing all the languages and components you need.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&skip_quickstart=true)

Quickly create a database in your codespace with the following command:

```bash
sqlcmd create mssql -u devDB --accept-eula
```

## Repository Structure

* examples
  * azure (Azure SQL database examples)
  * codespace (broken out scripts to run in your codespace)
    * C# example scripts
    * Go example scripts
    * Java example scripts
    * NodeJS example scripts
    * PHP example scripts
    * Python example scripts
  * sql (SQL Server database examples)
    * drivers
      * [C#](./examples/sql/drivers/csharp-driver-example.md)
      * [Go](/examples/sql/drivers/go-driver-example.md)
      * [Java](./examples/sql/drivers/java-driver-example.md)
      * [Node.js](./examples/sql/drivers/nodejs-driver-example.md)
      * [Python](./examples/sql/drivers/python-driver-example.md)
      * [PHP](./examples/sql/drivers/php-driver-example.md)
    * orm (in progress)
      * [C#](./examples/sql/orm/csharp-orm-example.md)
      * [Go](/examples/sql/orm/go-orm-example.md)
      * [Java](./examples/sql/orm/java-orm-example.md)
      * [Node.js](./examples/sql/orm/nodejs-orm-example.md)
      * [Python](./examples/sql/orm/python-orm-example.md)
    * scripts (for example database objects)
* archivedPage (old pages/examples/scripts from retired SQL Developers page)