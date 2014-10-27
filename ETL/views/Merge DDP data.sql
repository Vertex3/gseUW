/****** Script for SelectTopNRows command from SSMS  ******/
UPDATE
  [UWGISProduction].[dbo].[DDPINDEX_SUPPORT] 
  set SITEID = (  Select TOP 1 SITEID from UWGISProduction.dbo.ACTIVE_FLOOR AF where [UWGISProduction].[dbo].[DDPINDEX_SUPPORT].BUILDINGID = AF.BLDGCODE );

UPDATE
  [UWGISProduction].[dbo].[DDPINDEX_SUPPORT] 
  set BUILDINGID = SITEID + '_' + BUILDINGID;
