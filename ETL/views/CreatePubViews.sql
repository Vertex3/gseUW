-- Create Pub Views - create publishing views
use UWGISProduction
go
CREATE VIEW AllFloors AS
SELECT     
 ft.OBJECTID,
 ft.FLOORID,
 ft.FLOORCODE,
 fl.NAMESHORT,
 fl.NAMELONG,
 xp.INTERIORSPACE,
 xp.FLOORPLANLINE,
 xp.FLOORAREA,
 ft.SCHELEV,
 (ft.GROUNDOFFSET + bt.GROUNDELEV) AS GROUNDELEV,
 fl.FLOORLEVEL,
 ROW_NUMBER() OVER (partition BY ft.BUILDINGID ORDER BY fl.FLOORLEVEL) - 1 AS STACKLEVEL,
 bt.SENSITIVITY,
 xp.DRAWINGNAME,
 ft.BUILDINGID,
 fact.NAME as BLDGNAME,
 fpt.CALCROT,
 ft.BUILDINGID + '_' + LTRIM(STR(fl.FLOORLEVEL)) AS DDPFLOORSORT
FROM
 dbo.Floor_Table AS ft INNER JOIN
 dbo.DrawingType_XP AS xp ON ft.FLOORID = xp.FLOORID INNER JOIN
 dbo.FLOOR_LEVEL AS fl ON ft.FLOORCODE = fl.FLOORCODE INNER JOIN
 dbo.FloorPageTemplate AS fpt ON fpt.BUILDINGID = ft.BUILDINGID INNER JOIN
 dbo.FACILITY_TABLE AS fact ON ft.BUILDINGID = CAST(fact.FACILITY_NUMBER AS nvarchar(20)) INNER JOIN
 dbo.Building_Table as bt ON ft.BUILDINGID = bt.BUILDINGID
GO
------------------------------------------------------------------------
go
CREATE VIEW PubFloors AS
SELECT * from AllFloors 
WHERE SENSITIVITY = 'None'
GO
------------------------------------------------------------------------
go
CREATE VIEW pubFloorplanLines AS
SELECT     
 fpline.FLOORID,
 fpline.FLOORCODE,
 floors.NAMESHORT,
 floors.NAMELONG,
 floors.SCHELEV,
 floors.GROUNDELEV,
 floors.FLOORLEVEL,
 floors.STACKLEVEL,
 floors.SENSITIVITY,
 fpline.SITEID,
 fpline.BUILDINGID,
 fpline.SOURCELAYER,
 fpline.SOURCEID,
 fpline.SOURCEDWG,
 fpline.LASTUPDATE,
 fpline.LASTEDITOR,
 fpline.SHAPE,
 fpline.OBJECTID
FROM         
dbo.FLOORPLANLINE AS fpline INNER JOIN
dbo.PubFloors AS floors ON fpline.FLOORID = Floors.FLOORID

------------------------------------------------------------------------
GO
CREATE VIEW pubFloorAreas AS
SELECT     
 floorarea.FLOORID,
 floorarea.FLOORCODE,
 floorarea.FLOORAREA,
 floors.NAMESHORT,
 floors.NAMELONG,
 floors.SCHELEV,
 floors.GROUNDELEV,
 floors.FLOORLEVEL,
 floors.STACKLEVEL, 
 floors.SENSITIVITY,
 floors.CALCROT,
 floors.DDPFLOORSORT,
 floorarea.BUILDINGID,
 floorarea.SITEID,
 floorarea.SOURCEDWG,
 floorarea.LASTUPDATE,
 floorarea.LASTEDITOR,
 floorarea.SHAPE,
 floorarea.OBJECTID
FROM
dbo.FLOORAREA AS floorarea INNER JOIN
dbo.PubFloors AS floors ON floors.FLOORID = floorarea.FLOORID

------------------------------------------------------------------------
GO
CREATE VIEW pubFloorPages AS
SELECT     
 floors.FLOORID,
 floors.FLOORCODE,
 floors.NAMESHORT,
 floors.NAMELONG,
 floors.SCHELEV,
 floors.GROUNDELEV,
 floors.FLOORLEVEL,
 floors.STACKLEVEL,
 floors.SENSITIVITY,
 floors.CALCROT,
 floors.DDPFLOORSORT,
 fpt.BUILDINGID,
 fpt.SITEID,
 fpt.SOURCEDWG,
 fpt.LASTUPDATE,
 fpt.LASTEDITOR,
 fpt.SHAPE,
 floors.OBJECTID
FROM         
dbo.FloorPageTemplate AS fpt INNER JOIN
dbo.PubFloors AS floors ON fpt.BUILDINGID = floors.BUILDINGID

------------------------------------------------------------------------
GO
CREATE VIEW pubInteriorSpace_Points AS
SELECT     
 spaces.SPACEID,
 spaces.ROOMNUMBER,
 spaces.FLOORID,
 spaces.FLOORCODE,
 floors.NAMESHORT,
 floors.NAMELONG,
 floors.SCHELEV,
 floors.GROUNDELEV,
 floors.FLOORLEVEL,
 floors.STACKLEVEL,
 floors.SENSITIVITY,
 spaces.BUILDINGID,
 spaces.SITEID,
 spaces.SOURCEDWG,
 spaces.LASTUPDATE,
 spaces.LASTEDITOR,
 spaces.SHAPE,
 spaces.OBJECTID

FROM         
dbo.INTERIORSPACE_POINT AS spaces INNER JOIN
dbo.PubFloors AS floors ON floors.FLOORID = spaces.FLOORID

------------------------------------------------------------------------
GO
CREATE VIEW pubInteriorSpaces AS
SELECT     
 spaces.SPACEID,
 spaces.ROOMNUMBER,
 spaces.FLOORID,
 spaces.FLOORCODE,
 floors.NAMESHORT,
 floors.NAMELONG,
 floors.SCHELEV,
 floors.GROUNDELEV,
 floors.FLOORLEVEL,
 floors.STACKLEVEL,
 floors.SENSITIVITY,
 spaces.SpaceClass,
 spaces.SpaceArea,
 spaces.BUILDINGID,
 spaces.SITEID,
 spaces.SOURCEID,
 spaces.SOURCEDWG,
 spaces.LASTUPDATE,
 spaces.LASTEDITOR,
 spaces.SHAPE,
 spaces.OBJECTID
FROM
dbo.INTERIORSPACE as spaces INNER JOIN
dbo.PubFloors AS floors ON floors.FLOORID = spaces.FLOORID

------------------------------------------------------------------------
GO
CREATE VIEW pubInteriorSpaces_Tilt AS
SELECT     
 spaces.SPACEID,
 spaces.ROOMNUMBER,
 spaces.FLOORID,
 spaces.FLOORCODE,
 floors.NAMESHORT,
 floors.NAMELONG,
 floors.FLOORLEVEL,
 floors.STACKLEVEL,
 floors.SENSITIVITY,
 spaces.BUILDINGID,
 spaces.SITEID,
 spaces.LASTUPDATE,
 spaces.LASTEDITOR,
 spaces.SHAPE,
 spaces.OBJECTID
FROM
dbo.INTERIORSPACE_Tilt AS spaces INNER JOIN
dbo.PubFloors AS floors ON floors.FLOORID = spaces.FLOORID

------------------------------------------------------------------------
GO
CREATE VIEW pubSitePoints AS
SELECT     OBJECTID, SITEID, SITENAME, SOURCEID, SOURCEDWG, LASTUPDATE, LASTEDITOR, SHAPE.STCentroid() AS SHAPE
FROM         dbo.SITE
------------------------------------------------------------------------
GO
/*
CREATE VIEW qaMissingFeaturesByFloor AS
SELECT     
 activefloors.HASINTERIORSPACES,
 activefloors.HASFLOORPLANLINES,
 activefloors.HASFLOORAREA,
 activefloors.FLOORID,
 floorpoints.INTERIORSPACECOUNT,
 floorpoints.FLOORPLANLINECOUNT,
 floorpoints.FLOORAREACOUNT
FROM         
 dbo.ACTIVE_FLOOR AS activefloors INNER JOIN
 dbo.pubFloor_Points AS floorpoints ON activefloors.FLOORID = floorpoints.FLOORID
WHERE     
(floorpoints.INTERIORSPACECOUNT = 0) AND (activefloors.HASINTERIORSPACES = 'T') OR
(floorpoints.FLOORPLANLINECOUNT = 0) AND (activefloors.HASFLOORPLANLINES = 'T') OR
(floorpoints.FLOORAREACOUNT = 0) AND (activefloors.HASFLOORAREA = 'T')
------------------------------------------------------------------------
GO
CREATE VIEW qaMissingFloorPoints AS
SELECT     
 FLOORCODE,
 FLOORID,
 BUILDINGID,
 SOURCEDWG
FROM         
dbo.ACTIVE_FLOOR
WHERE
(FLOORID NOT IN (SELECT FLOORID FROM dbo.pubFloor_Points))
 ------------------------------------------------------------------------
GO
CREATE VIEW qaUnexpectedFeaturesByFloor AS
SELECT     
 activefloors.HASINTERIORSPACES,
 activefloors.HASFLOORPLANLINES,
 activefloors.HASFLOORAREA,
 activefloors.FLOORID,
 FP.INTERIORSPACECOUNT,
 FP.FLOORPLANLINECOUNT,
 FP.FLOORAREACOUNT,
 FP.SHAPE,
 FP.OBJECTID
FROM         
dbo.ACTIVE_FLOOR AS activefloors INNER JOIN
dbo.pubFloor_Points AS FP ON activefloors.FLOORID = FP.FLOORID
WHERE     
(FP.INTERIORSPACECOUNT > 0) AND (activefloors.HASINTERIORSPACES IS NULL OR activefloors.HASINTERIORSPACES = 'F') OR
(FP.FLOORPLANLINECOUNT > 0) AND (activefloors.HASFLOORPLANLINES IS NULL OR activefloors.HASFLOORPLANLINES = 'F') OR
(FP.FLOORAREACOUNT > 0) AND (activefloors.HASFLOORAREA IS NULL OR activefloors.HASFLOORAREA = 'F')
------------------------------------------------------------------------
GO
CREATE VIEW qaUnexpectedFloorPoints AS
SELECT     
 FLOORID,
 FLOORCODE,
 NAMESHORT,
 LASTUPDATE,
 LASTEDITOR,
 BUILDINGID,
 SITEID
FROM         
 dbo.pubFloor_Points as floorpoints
WHERE    
(FLOORID NOT IN
 (SELECT floorpoints.FLOORID FROM dbo.ACTIVE_FLOOR))
 
 GO
------------------------------------------------------------------------
 
 create view qaDuplicateFloorPoints as  
(SELECT max(objectid) as oid,count(*) as CountStar, FLOORID FROM UWGISProduction.dbo.FLOOR_POINT group by FLOORID having COUNT(*) > 1)   
GO
*/