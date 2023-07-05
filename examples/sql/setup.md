# Example Setups

To run the SQL Server examples, you will need the following:

1. A SQL Server database. This can be a full version downloaded [here](https://www.microsoft.com/sql-server/sql-server-downloads) and installed or it can be running in a [container](https://learn.microsoft.com/sql/linux/quickstart-install-connect-docker?view=sql-server-ver16&pivots=cs1-bash).
1. VS Code which can be downloaded from [here](https://code.visualstudio.com/download).
1. The sample schema deployed into your database. The script can be found [here](./scripts/demo_schema.sql) and the following code can also be used:

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
