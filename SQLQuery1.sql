
--1. Base de datos principal 
USE MASTER;
GO

--Crear base de datos 
-- 2 Validando existencia de la base de datos 
IF OBJECT_ID('DEMO_UNC') IS NULL 
BEGIN
   DROP DATABASE DEMO UNC;
   print 'la Base de datos DEMO_UNC eliminada'
   END 
   GO 

