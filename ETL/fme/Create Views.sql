CREATE VIEW dbo.eFloorPageTExceptProduction AS SELECT BUILDINGID,SOURCEID,CALCROT,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.FloorPageTemplate EXCEPT  SELECT BUILDINGID,SOURCEID,CALCROT,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.FloorPageTemplate;
GO
CREATE VIEW dbo.eFloorPageTExceptStaging AS SELECT BUILDINGID,SOURCEID,CALCROT,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.FloorPageTemplate EXCEPT  SELECT BUILDINGID,SOURCEID,CALCROT,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.FloorPageTemplate;
GO
CREATE VIEW dbo.eBuildingExceptProduction AS SELECT SOURCEDWG,BUILDINGID,FACILITYNO,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.Building EXCEPT  SELECT SOURCEDWG,BUILDINGID,FACILITYNO,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.Building;
GO
CREATE VIEW dbo.eBuildingExceptStaging AS SELECT SOURCEDWG,BUILDINGID,FACILITYNO,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.Building EXCEPT  SELECT SOURCEDWG,BUILDINGID,FACILITYNO,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.Building;
GO
CREATE VIEW dbo.eBuildingPointExceptProduction AS SELECT BUILDINGID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.Building_Point EXCEPT  SELECT BUILDINGID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.Building_Point;
GO
CREATE VIEW dbo.eBuildingPointExceptStaging AS SELECT BUILDINGID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.Building_Point EXCEPT  SELECT BUILDINGID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.Building_Point;
GO
CREATE VIEW dbo.eLandscapeAreaExceptProduction AS SELECT FACILITYID,SURFTYPE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.LandscapeArea EXCEPT  SELECT FACILITYID,SURFTYPE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.LandscapeArea;
GO
CREATE VIEW dbo.eLandscapeAreaExceptStaging AS SELECT FACILITYID,SURFTYPE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.LandscapeArea EXCEPT  SELECT FACILITYID,SURFTYPE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.LandscapeArea;
GO
CREATE VIEW dbo.eStreetPavementExceptProduction AS SELECT FACILITYID,SURFTYPE,PAVEUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.StreetPavement EXCEPT  SELECT FACILITYID,SURFTYPE,PAVEUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.StreetPavement;
GO
CREATE VIEW dbo.eStreetPavementExceptStaging AS SELECT FACILITYID,SURFTYPE,PAVEUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.StreetPavement EXCEPT  SELECT FACILITYID,SURFTYPE,PAVEUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.StreetPavement;
GO
CREATE VIEW dbo.eStreetPavementExceptProduction AS SELECT FACILITYID,SURFTYPE,PAVEUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.StreetPavement EXCEPT  SELECT FACILITYID,SURFTYPE,PAVEUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.StreetPavement;
GO
CREATE VIEW dbo.eStreetPavementExceptStaging AS SELECT FACILITYID,SURFTYPE,PAVEUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.StreetPavement EXCEPT  SELECT FACILITYID,SURFTYPE,PAVEUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.StreetPavement;
GO
CREATE VIEW dbo.eStreetPavementExceptProduction AS SELECT FACILITYID,SURFTYPE,PAVEUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.StreetPavement EXCEPT  SELECT FACILITYID,SURFTYPE,PAVEUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.StreetPavement;
GO
CREATE VIEW dbo.eStreetPavementExceptStaging AS SELECT FACILITYID,SURFTYPE,PAVEUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.StreetPavement EXCEPT  SELECT FACILITYID,SURFTYPE,PAVEUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.StreetPavement;
GO
CREATE VIEW dbo.eStreetPavementExceptProduction AS SELECT FACILITYID,SURFTYPE,PAVEUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.StreetPavement EXCEPT  SELECT FACILITYID,SURFTYPE,PAVEUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.StreetPavement;
GO
CREATE VIEW dbo.eStreetPavementExceptStaging AS SELECT FACILITYID,SURFTYPE,PAVEUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.StreetPavement EXCEPT  SELECT FACILITYID,SURFTYPE,PAVEUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.StreetPavement;
GO
CREATE VIEW dbo.eSiteAmenityExceptProduction AS SELECT SOURCEDWG,SOURCEID,AMENTYPE,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.SiteAmenityLine EXCEPT  SELECT SOURCEDWG,SOURCEID,AMENTYPE,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.SiteAmenityLine;
GO
CREATE VIEW dbo.eSiteAmenityExceptStaging AS SELECT SOURCEDWG,SOURCEID,AMENTYPE,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.SiteAmenityLine EXCEPT  SELECT SOURCEDWG,SOURCEID,AMENTYPE,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.SiteAmenityLine;
GO
CREATE VIEW dbo.eWaterbodyExceptProduction AS SELECT NAME,TYPE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.Waterbody EXCEPT  SELECT NAME,TYPE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.Waterbody;
GO
CREATE VIEW dbo.eWaterbodyExceptStaging AS SELECT NAME,TYPE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.Waterbody EXCEPT  SELECT NAME,TYPE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.Waterbody;
GO
CREATE VIEW dbo.eFloorAreaExceptProduction AS SELECT FLOORID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.FloorArea EXCEPT  SELECT FLOORID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.FloorArea;
GO
CREATE VIEW dbo.eFloorAreaExceptStaging AS SELECT FLOORID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.FloorArea EXCEPT  SELECT FLOORID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.FloorArea;
GO
CREATE VIEW dbo.eFloorplanLineExceptProduction AS SELECT FLOORID,SOURCELAYER,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.FloorplanLine EXCEPT  SELECT FLOORID,SOURCELAYER,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.FloorplanLine;
GO
CREATE VIEW dbo.eFloorplanLineExceptStaging AS SELECT FLOORID,SOURCELAYER,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.FloorplanLine EXCEPT  SELECT FLOORID,SOURCELAYER,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.FloorplanLine;
GO
CREATE VIEW dbo.eFloorPolyExceptProduction AS SELECT BUILDINGID,FLOORCODE,FLOORID,FLOORAREA,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.Floor_Poly EXCEPT  SELECT BUILDINGID,FLOORCODE,FLOORID,FLOORAREA,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.Floor_Poly;
GO
CREATE VIEW dbo.eFloorPolyExceptStaging AS SELECT BUILDINGID,FLOORCODE,FLOORID,FLOORAREA,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.Floor_Poly EXCEPT  SELECT BUILDINGID,FLOORCODE,FLOORID,FLOORAREA,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.Floor_Poly;
GO
CREATE VIEW dbo.eInteriorSpaceExceptProduction AS SELECT FLOORID,ROOMNUMBER,SPACEID,SPACEAREA,SOURCEID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.InteriorSpace EXCEPT  SELECT FLOORID,ROOMNUMBER,SPACEID,SPACEAREA,SOURCEID,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.InteriorSpace;
GO
CREATE VIEW dbo.eInteriorSpaceExceptStaging AS SELECT FLOORID,ROOMNUMBER,SPACEID,SPACEAREA,SOURCEID,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.InteriorSpace EXCEPT  SELECT FLOORID,ROOMNUMBER,SPACEID,SPACEAREA,SOURCEID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.InteriorSpace;
GO
CREATE VIEW dbo.eInteriorSpacePointExceptProduction AS SELECT ROOMNUMBER,SPACEID,FLOORID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.InteriorSpace_Point EXCEPT  SELECT ROOMNUMBER,SPACEID,FLOORID,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.InteriorSpace_Point;
GO
CREATE VIEW dbo.eInteriorSpacePointExceptStaging AS SELECT ROOMNUMBER,SPACEID,FLOORID,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.InteriorSpace_Point EXCEPT  SELECT ROOMNUMBER,SPACEID,FLOORID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.InteriorSpace_Point;
GO
CREATE VIEW dbo.eInteriorSpaceIsoExceptProduction AS SELECT BUILDINGID,FLOORCODE,FLOORID,ROOMNUMBER,SPACEID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.InteriorSpace_Isometric EXCEPT  SELECT BUILDINGID,FLOORCODE,FLOORID,ROOMNUMBER,SPACEID,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.InteriorSpace_Isometric;
GO
CREATE VIEW dbo.eInteriorSpaceIsoExceptStaging AS SELECT BUILDINGID,FLOORCODE,FLOORID,ROOMNUMBER,SPACEID,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.InteriorSpace_Isometric EXCEPT  SELECT BUILDINGID,FLOORCODE,FLOORID,ROOMNUMBER,SPACEID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.InteriorSpace_Isometric;
GO
CREATE VIEW dbo.eFloorplanLineIsoExceptProduction AS SELECT FLOORID,SOURCELAYER,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.FloorplanLine_Isometric EXCEPT  SELECT FLOORID,SOURCELAYER,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.FloorplanLine_Isometric;
GO
CREATE VIEW dbo.eFloorplanLineIsoExceptStaging AS SELECT FLOORID,SOURCELAYER,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.FloorplanLine_Isometric EXCEPT  SELECT FLOORID,SOURCELAYER,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.FloorplanLine_Isometric;
GO
CREATE VIEW dbo.eFloorAreaIsoExceptProduction AS SELECT FLOORID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.FloorArea_Isometric EXCEPT  SELECT FLOORID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.FloorArea_Isometric;
GO
CREATE VIEW dbo.eFloorAreaIsoExceptStaging AS SELECT FLOORID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.FloorArea_Isometric EXCEPT  SELECT FLOORID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.FloorArea_Isometric;
GO
CREATE VIEW dbo.eDoorPointExceptProd AS SELECT FLOORID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.RT_DoorPoint EXCEPT  SELECT FLOORID,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.RT_DoorPoint;
GO
CREATE VIEW dbo.eDoorPointStaging AS SELECT FLOORID,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.RT_DoorPoint EXCEPT  SELECT FLOORID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.RT_DoorPoint;
GO
CREATE VIEW dbo.eStopProd AS SELECT FLOORID,SPACEID1,SPACEID2,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.RT_Stop EXCEPT  SELECT FLOORID,SPACEID1,SPACEID2,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.RT_Stop;
GO
CREATE VIEW dbo.eStopStaging AS SELECT FLOORID,SPACEID1,SPACEID2,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.RT_Stop EXCEPT  SELECT FLOORID,SPACEID1,SPACEID2,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.RT_Stop;
GO
CREATE VIEW dbo.eRoomPointProd AS SELECT FLOORID,SPACEID,ADA,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.RT_RoomPoint EXCEPT  SELECT FLOORID,SPACEID,ADA,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.RT_RoomPoint;
GO
CREATE VIEW dbo.eRoomPointStaging AS SELECT FLOORID,SPACEID,ADA,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.RT_RoomPoint EXCEPT  SELECT FLOORID,SPACEID,ADA,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.RT_RoomPoint;
GO
CREATE VIEW dbo.eLineInteriorProd AS SELECT FLOORID,SPACEID,ADA,SHAPE.STAsText() AS SHAPE_TEXT,FROMFLOOR,TOFLOOR FROM UWCadStaging.dbo.RT_LineInterior EXCEPT  SELECT FLOORID,SPACEID,ADA,SHAPE.STAsText() AS SHAPE_TEXT,FROMFLOOR,TOFLOOR FROM CadSde.dbo.RT_LineInterior;
GO
CREATE VIEW dbo.eLineInteriorStaging AS SELECT FLOORID,SPACEID,ADA,SHAPE.STAsText() AS SHAPE_TEXT,FROMFLOOR,TOFLOOR FROM CadSde.dbo.RT_LineInterior EXCEPT  SELECT FLOORID,SPACEID,ADA,SHAPE.STAsText() AS SHAPE_TEXT,FROMFLOOR,TOFLOOR FROM UWCadStaging.dbo.RT_LineInterior;
GO
CREATE VIEW dbo.eLineRmConnectorProd AS SELECT FLOORID,SPACEID,ADA,SHAPE.STAsText() AS SHAPE_TEXT,FROMFLOOR,TOFLOOR FROM UWCadStaging.dbo.RT_LineRmConnector EXCEPT  SELECT FLOORID,SPACEID,ADA,SHAPE.STAsText() AS SHAPE_TEXT,FROMFLOOR,TOFLOOR FROM CadSde.dbo.RT_LineRmConnector;
GO
CREATE VIEW dbo.eLineRmConnectorStaging AS SELECT FLOORID,SPACEID,ADA,SHAPE.STAsText() AS SHAPE_TEXT,FROMFLOOR,TOFLOOR FROM CadSde.dbo.RT_LineRmConnector EXCEPT  SELECT FLOORID,SPACEID,ADA,SHAPE.STAsText() AS SHAPE_TEXT,FROMFLOOR,TOFLOOR FROM UWCadStaging.dbo.RT_LineRmConnector;
GO
CREATE VIEW dbo.eLineTransitionProd AS SELECT FLOORID,SPACEID,ADA,SHAPE.STAsText() AS SHAPE_TEXT,FROMFLOOR,TOFLOOR FROM UWCadStaging.dbo.RT_LineTransition EXCEPT  SELECT FLOORID,SPACEID,ADA,SHAPE.STAsText() AS SHAPE_TEXT,FROMFLOOR,TOFLOOR FROM CadSde.dbo.RT_LineTransition;
GO
CREATE VIEW dbo.eLineTransitionStaging AS SELECT FLOORID,SPACEID,ADA,SHAPE.STAsText() AS SHAPE_TEXT,FROMFLOOR,TOFLOOR FROM CadSde.dbo.RT_LineTransition EXCEPT  SELECT FLOORID,SPACEID,ADA,SHAPE.STAsText() AS SHAPE_TEXT,FROMFLOOR,TOFLOOR FROM UWCadStaging.dbo.RT_LineTransition;
GO
CREATE VIEW dbo.eWaypointProd AS SELECT FLOORID,NAME,WAYPOINTTYPE,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.RT_Waypoint EXCEPT  SELECT FLOORID,NAME,WAYPOINTTYPE,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.RT_Waypoint;
GO
CREATE VIEW dbo.eWaypointStaging AS SELECT FLOORID,NAME,WAYPOINTTYPE,SHAPE.STAsText() AS SHAPE_TEXT FROM CadSde.dbo.RT_Waypoint EXCEPT  SELECT FLOORID,NAME,WAYPOINTTYPE,SHAPE.STAsText() AS SHAPE_TEXT FROM UWCadStaging.dbo.RT_Waypoint;
GO
