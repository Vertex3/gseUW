/****** Script for SelectTopNRows command from SSMS  ******/
  SELECT FLOORID, FLOORCODE
  FROM [UWGISProduction].[dbo].FLOOR_AREA except select floorid,FLOORCODE from [UWGISProduction].[dbo].active_floor;

  SELECT FLOORID, FLOORCODE
  FROM [UWGISProduction].[dbo].FLOOR_AREA except select floorid,FLOORCODE from [UWGISProduction].[dbo].active_floor;
  
/*
SELECT *
  FROM [UWGISProduction].[dbo].active_floor where FLOORID = '5973_04'

  SELECT *
  FROM [UWGISProduction].[dbo].FLOOR_AREA where FLOORID = '5973_04'
*/