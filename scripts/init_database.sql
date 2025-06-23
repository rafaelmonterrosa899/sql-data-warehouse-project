
/*
=============================================================== 
Create Database and Schemas
===============================================================

Script Pupose: 
    This Script Crates a new database named 'DataWaharehouse' after checking if its already exits. 
    If the database exists, it is dropped and recreated. Additionaly, the script sets up three schemas within the database: 
    'bronze', 'silver', and 'gold'.

Warning: 
   Running this script will drop the entire 'DataWaharehouse' database if it exists. 
   All data in the database will be permanently delete. Proceed with caution and ensure you have the proper backups before running the script. 

*/

USE master;
GO 

--DROP and recreate the DataWarehouse database. 

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWaharehouse')
BEGIN
    ALTER DATABASE [DataWaharehouse] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [DataWaharehouse];
END

--CREATE the DataWarehouse database.
CREATE DATABASE [DataWaharehouse];
GO


USE [DataWaharehouse];
GO

-- Create schemas
CREATE SCHEMA [bronze];
GO
CREATE SCHEMA [silver];
GO
CREATE SCHEMA [gold];
