CREATE VIEW dbo.pFloorExceptTarget AS SELECT * from OPENQUERY([assus\sqlexpress],'SELECT FLOORID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM campus.dbo.Floor_Area') EXCEPT  SELECT FLOORID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM dbo.pubFloor_Areas;
GO
CREATE VIEW dbo.pFloorExceptSource AS SELECT FLOORID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM dbo.pubFloor_Areas EXCEPT SELECT * from OPENQUERY([assus\sqlexpress],'SELECT FLOORID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM campus.dbo.Floor_Area');
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Production.sde\pFloorExceptTarget
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Production.sde\pFloorExceptSource
