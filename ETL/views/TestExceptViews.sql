CREATE VIEW dbo.eInteriorSpaceExceptProduction AS 
SELECT FLOORID,ROOMNUMBER,SPACEID,SPACEAREA,SOURCEID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.InteriorSpace 
EXCEPT  
OPENQUERY([cad.maps.uw.edu],'SELECT FLOORID,ROOMNUMBER,SPACEID,SPACEAREA,SOURCEID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWMapData.dbo.InteriorSpace');
GO
CREATE VIEW dbo.eInteriorSpaceExceptStaging AS 
OPENQUERY([cad.maps.uw.edu],'SELECT FLOORID,ROOMNUMBER,SPACEID,SPACEAREA,SOURCEID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWMapData.dbo.InteriorSpace');
EXCEPT  
SELECT FLOORID,ROOMNUMBER,SPACEID,SPACEAREA,SOURCEID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.InteriorSpace;
GO