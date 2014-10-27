CREATE VIEW dbo.BuildingFoundationExceptProduction AS SELECT SOURCEDWG,BUILDINGID,FACILITYNO,FOUNDTYPE,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Building_Foundation EXCEPT  SELECT SOURCEDWG,BUILDINGID,FACILITYNO,FOUNDTYPE,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Building_Foundation;
GO
CREATE VIEW dbo.BuildingFoundationExceptStaging AS SELECT SOURCEDWG,BUILDINGID,FACILITYNO,FOUNDTYPE,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Building_Foundation EXCEPT  SELECT SOURCEDWG,BUILDINGID,FACILITYNO,FOUNDTYPE,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Building_Foundation;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\BuildingFoundationExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\BuildingFoundationExceptStaging
CREATE VIEW dbo.BuildingOutlineTiltExceptProduction AS SELECT BUILDINGID,BLDGHEIGHT,SPACING,MARGIN,XCENTER,YCENTER,SOURCEID,CALCROT,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Building_Outline_Tilt EXCEPT  SELECT BUILDINGID,BLDGHEIGHT,SPACING,MARGIN,XCENTER,YCENTER,SOURCEID,CALCROT,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Building_Outline_Tilt;
GO
CREATE VIEW dbo.BuildingOutlineTiltExceptStaging AS SELECT BUILDINGID,BLDGHEIGHT,SPACING,MARGIN,XCENTER,YCENTER,SOURCEID,CALCROT,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Building_Outline_Tilt EXCEPT  SELECT BUILDINGID,BLDGHEIGHT,SPACING,MARGIN,XCENTER,YCENTER,SOURCEID,CALCROT,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Building_Outline_Tilt;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\BuildingOutlineTiltExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\BuildingOutlineTiltExceptStaging
CREATE VIEW dbo.BuildingOutlinePtExceptProduction AS SELECT BUILDINGID,SOURCEDWG FROM UWGISStaging.dbo.Building_Outline_Point EXCEPT  SELECT BUILDINGID,SOURCEDWG FROM UWGISProduction.dbo.Building_Outline_Point;
GO
CREATE VIEW dbo.BuildingOutlinePtExceptStaging AS SELECT BUILDINGID,SOURCEDWG FROM UWGISProduction.dbo.Building_Outline_Point EXCEPT  SELECT BUILDINGID,SOURCEDWG FROM UWGISStaging.dbo.Building_Outline_Point;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\BuildingOutlinePtExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\BuildingOutlinePtExceptStaging
CREATE VIEW dbo.BuildingRoofExceptProduction AS SELECT SOURCEDWG,BUILDINGID,FACILITYNO,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Building_Roof EXCEPT  SELECT SOURCEDWG,BUILDINGID,FACILITYNO,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Building_Roof;
GO
CREATE VIEW dbo.BuildingRoofExceptStaging AS SELECT SOURCEDWG,BUILDINGID,FACILITYNO,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Building_Roof EXCEPT  SELECT SOURCEDWG,BUILDINGID,FACILITYNO,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Building_Roof;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\BuildingRoofExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\BuildingRoofExceptStaging
CREATE VIEW dbo.BuildingExceptProduction AS SELECT SOURCEDWG,BUILDINGID,FACILITYNO,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Building EXCEPT  SELECT SOURCEDWG,BUILDINGID,FACILITYNO,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Building;
GO
CREATE VIEW dbo.BuildingExceptStaging AS SELECT SOURCEDWG,BUILDINGID,FACILITYNO,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Building EXCEPT  SELECT SOURCEDWG,BUILDINGID,FACILITYNO,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Building;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\BuildingExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\BuildingExceptStaging
CREATE VIEW dbo.BuildingPointExceptProduction AS SELECT BUILDINGID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Building_Point EXCEPT  SELECT BUILDINGID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Building_Point;
GO
CREATE VIEW dbo.BuildingPointExceptStaging AS SELECT BUILDINGID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Building_Point EXCEPT  SELECT BUILDINGID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Building_Point;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\BuildingPointExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\BuildingPointExceptStaging
CREATE VIEW dbo.LandscapeAreaExceptProduction AS SELECT FACILITYID,SURFTYPE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.LandscapeArea EXCEPT  SELECT FACILITYID,SURFTYPE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.LandscapeArea;
GO
CREATE VIEW dbo.LandscapeAreaExceptStaging AS SELECT FACILITYID,SURFTYPE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.LandscapeArea EXCEPT  SELECT FACILITYID,SURFTYPE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.LandscapeArea;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\LandscapeAreaExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\LandscapeAreaExceptStaging
CREATE VIEW dbo.StreetPavementExceptProduction AS SELECT FACILITYID,SURFTYPE,SURFUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.StreetPavement EXCEPT  SELECT FACILITYID,SURFTYPE,SURFUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.StreetPavement;
GO
CREATE VIEW dbo.StreetPavementExceptStaging AS SELECT FACILITYID,SURFTYPE,SURFUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.StreetPavement EXCEPT  SELECT FACILITYID,SURFTYPE,SURFUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.StreetPavement;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\StreetPavementExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\StreetPavementExceptStaging
CREATE VIEW dbo.StreetPavementExceptProduction AS SELECT FACILITYID,SURFTYPE,SURFUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.StreetPavement EXCEPT  SELECT FACILITYID,SURFTYPE,SURFUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.StreetPavement;
GO
CREATE VIEW dbo.StreetPavementExceptStaging AS SELECT FACILITYID,SURFTYPE,SURFUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.StreetPavement EXCEPT  SELECT FACILITYID,SURFTYPE,SURFUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.StreetPavement;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\StreetPavementExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\StreetPavementExceptStaging
CREATE VIEW dbo.StreetPavementExceptProduction AS SELECT FACILITYID,SURFTYPE,SURFUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.StreetPavement EXCEPT  SELECT FACILITYID,SURFTYPE,SURFUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.StreetPavement;
GO
CREATE VIEW dbo.StreetPavementExceptStaging AS SELECT FACILITYID,SURFTYPE,SURFUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.StreetPavement EXCEPT  SELECT FACILITYID,SURFTYPE,SURFUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.StreetPavement;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\StreetPavementExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\StreetPavementExceptStaging
CREATE VIEW dbo.StreetPavementExceptProduction AS SELECT FACILITYID,SURFTYPE,SURFUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.StreetPavement EXCEPT  SELECT FACILITYID,SURFTYPE,SURFUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.StreetPavement;
GO
CREATE VIEW dbo.StreetPavementExceptStaging AS SELECT FACILITYID,SURFTYPE,SURFUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.StreetPavement EXCEPT  SELECT FACILITYID,SURFTYPE,SURFUSE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.StreetPavement;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\StreetPavementExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\StreetPavementExceptStaging
CREATE VIEW dbo.SiteAmenityExceptProduction AS SELECT SOURCEDWG,SOURCEID,AMENTYPE,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.SiteAmenityLine EXCEPT  SELECT SOURCEDWG,SOURCEID,AMENTYPE,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.SiteAmenityLine;
GO
CREATE VIEW dbo.SiteAmenityExceptStaging AS SELECT SOURCEDWG,SOURCEID,AMENTYPE,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.SiteAmenityLine EXCEPT  SELECT SOURCEDWG,SOURCEID,AMENTYPE,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.SiteAmenityLine;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\SiteAmenityExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\SiteAmenityExceptStaging
CREATE VIEW dbo.WaterbodyExceptProduction AS SELECT NAME,TYPE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Waterbody EXCEPT  SELECT NAME,TYPE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Waterbody;
GO
CREATE VIEW dbo.WaterbodyExceptStaging AS SELECT NAME,TYPE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Waterbody EXCEPT  SELECT NAME,TYPE,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Waterbody;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\WaterbodyExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\WaterbodyExceptStaging
CREATE VIEW dbo.FloorExceptProduction AS SELECT FLOORID,SCHELEV,ALTITUDE,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Floor_Area EXCEPT  SELECT FLOORID,SCHELEV,ALTITUDE,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Floor_Area;
GO
CREATE VIEW dbo.FloorExceptStaging AS SELECT FLOORID,SCHELEV,ALTITUDE,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Floor_Area EXCEPT  SELECT FLOORID,SCHELEV,ALTITUDE,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Floor_Area;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\FloorExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\FloorExceptStaging
CREATE VIEW dbo.FloorplanLineExceptProduction AS SELECT BUILDINGID,FLOOR,FLOORID,SOURCELAYER,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.FloorplanLine EXCEPT  SELECT BUILDINGID,FLOOR,FLOORID,SOURCELAYER,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.FloorplanLine;
GO
CREATE VIEW dbo.FloorplanLineExceptStaging AS SELECT BUILDINGID,FLOOR,FLOORID,SOURCELAYER,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.FloorplanLine EXCEPT  SELECT BUILDINGID,FLOOR,FLOORID,SOURCELAYER,SOURCEID,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.FloorplanLine;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\FloorplanLineExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\FloorplanLineExceptStaging
CREATE VIEW dbo.FloorplanLinePublishExceptProduction AS SELECT BUILDINGID,FLOOR,FLOORID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.FloorplanLine_Publish EXCEPT  SELECT BUILDINGID,FLOOR,FLOORID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.FloorplanLine_Publish;
GO
CREATE VIEW dbo.FloorplanLinePublishExceptStaging AS SELECT BUILDINGID,FLOOR,FLOORID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.FloorplanLine_Publish EXCEPT  SELECT BUILDINGID,FLOOR,FLOORID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.FloorplanLine_Publish;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\FloorplanLinePublishExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\FloorplanLinePublishExceptStaging
CREATE VIEW dbo.FloorOutlineExceptProduction AS SELECT floorid,sourcedwg,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Floor_Outline EXCEPT  SELECT floorid,sourcedwg,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Floor_Outline;
GO
CREATE VIEW dbo.FloorOutlineExceptStaging AS SELECT floorid,sourcedwg,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Floor_Outline EXCEPT  SELECT floorid,sourcedwg,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Floor_Outline;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\FloorOutlineExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\FloorOutlineExceptStaging
CREATE VIEW dbo.FloorPointExceptProduction AS SELECT FLOORID,CALCROT,WEBMERCROT,FLOOR_NAME,SCALE_85X11,SCALE_11X17,FLOOR_LEVEL,NAME_LONG,NAME_SHORT,NAME,HASINTERIORSPACES,HASFLOORPLANLINES,HASFLOORAREAS,FACILITY_CODE,FACLEVEL FROM UWGISStaging.dbo.Floor_Point EXCEPT  SELECT FLOORID,CALCROT,WEBMERCROT,FLOOR_NAME,SCALE_85X11,SCALE_11X17,FLOOR_LEVEL,NAME_LONG,NAME_SHORT,NAME,HASINTERIORSPACES,HASFLOORPLANLINES,HASFLOORAREAS,FACILITY_CODE,FACLEVEL FROM UWGISProduction.dbo.Floor_Point;
GO
CREATE VIEW dbo.FloorPointExceptStaging AS SELECT FLOORID,CALCROT,WEBMERCROT,FLOOR_NAME,SCALE_85X11,SCALE_11X17,FLOOR_LEVEL,NAME_LONG,NAME_SHORT,NAME,HASINTERIORSPACES,HASFLOORPLANLINES,HASFLOORAREAS,FACILITY_CODE,FACLEVEL FROM UWGISProduction.dbo.Floor_Point EXCEPT  SELECT FLOORID,CALCROT,WEBMERCROT,FLOOR_NAME,SCALE_85X11,SCALE_11X17,FLOOR_LEVEL,NAME_LONG,NAME_SHORT,NAME,HASINTERIORSPACES,HASFLOORPLANLINES,HASFLOORAREAS,FACILITY_CODE,FACLEVEL FROM UWGISStaging.dbo.Floor_Point;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\FloorPointExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\FloorPointExceptStaging
CREATE VIEW dbo.FloorAreaExceptProduction AS SELECT BUILDINGID,FLOOR,FLOORID,FLOOR_AREA,SCHELEV,ALTITUDE,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Floor_Poly EXCEPT  SELECT BUILDINGID,FLOOR,FLOORID,FLOOR_AREA,SCHELEV,ALTITUDE,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Floor_Poly;
GO
CREATE VIEW dbo.FloorAreaExceptStaging AS SELECT BUILDINGID,FLOOR,FLOORID,FLOOR_AREA,SCHELEV,ALTITUDE,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.Floor_Poly EXCEPT  SELECT BUILDINGID,FLOOR,FLOORID,FLOOR_AREA,SCHELEV,ALTITUDE,SOURCEDWG,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.Floor_Poly;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\FloorAreaExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\FloorAreaExceptStaging
CREATE VIEW dbo.InteriorSpaceExceptProduction AS SELECT BUILDINGID,FLOOR,FLOORID,ROOM,SPACEID,SPACEAREA,SOURCEID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.InteriorSpace EXCEPT  SELECT BUILDINGID,FLOOR,FLOORID,ROOM,SPACEID,SPACEAREA,SOURCEID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.InteriorSpace;
GO
CREATE VIEW dbo.InteriorSpaceExceptStaging AS SELECT BUILDINGID,FLOOR,FLOORID,ROOM,SPACEID,SPACEAREA,SOURCEID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.InteriorSpace EXCEPT  SELECT BUILDINGID,FLOOR,FLOORID,ROOM,SPACEID,SPACEAREA,SOURCEID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.InteriorSpace;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\InteriorSpaceExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\InteriorSpaceExceptStaging
CREATE VIEW dbo.InteriorSpacePointExceptProduction AS SELECT ROOM,SPACEID,FLOORID FROM UWGISStaging.dbo.InteriorSpace_Point EXCEPT  SELECT ROOM,SPACEID,FLOORID FROM UWGISProduction.dbo.InteriorSpace_Point;
GO
CREATE VIEW dbo.InteriorSpacePointExceptStaging AS SELECT ROOM,SPACEID,FLOORID FROM UWGISProduction.dbo.InteriorSpace_Point EXCEPT  SELECT ROOM,SPACEID,FLOORID FROM UWGISStaging.dbo.InteriorSpace_Point;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\InteriorSpacePointExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\InteriorSpacePointExceptStaging
CREATE VIEW dbo.InteriorSpaceTiltExceptProduction AS SELECT BUILDINGID,FLOOR,FLOORID,ROOM,SPACEID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.InteriorSpace_Tilt EXCEPT  SELECT BUILDINGID,FLOOR,FLOORID,ROOM,SPACEID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.InteriorSpace_Tilt;
GO
CREATE VIEW dbo.InteriorSpaceTiltExceptStaging AS SELECT BUILDINGID,FLOOR,FLOORID,ROOM,SPACEID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISProduction.dbo.InteriorSpace_Tilt EXCEPT  SELECT BUILDINGID,FLOOR,FLOORID,ROOM,SPACEID,SHAPE.STAsText() AS SHAPE_TEXT FROM UWGISStaging.dbo.InteriorSpace_Tilt;
GO
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\InteriorSpaceTiltExceptProduction
-- View createdC:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde\InteriorSpaceTiltExceptStaging
