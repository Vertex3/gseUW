-- Create Pub Views - create publishing views
-- Note: to use this script, modify the name of the database in the USE
-- statement below. This is the database where the views will be created.
-- Also modify the name of the schema for the table names to ensure this is 
-- the cadsde database where the tables and feature classes are managed.
-- Optionally also change the name of the schema owner from "dbo"

-- Note: You must set SQLCMD mode for this script to work:
-- In the "Query" menu in SSMS, simply toggle "SQLCMD Mode"

:setvar schema "dbo"
:setvar pubdb "GDB_D"
:setvar cadsde "UWGISProduction"

-- set the database where views will be created
USE $(pubdb);
-- 
DROP VIEW vw_Floor
GO
CREATE VIEW vw_Floor AS
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
 [$(cadsde)].[$(schema)].Floor_Table AS ft INNER JOIN
 [$(cadsde)].[$(schema)].DrawingType_XP AS xp ON ft.FLOORID = xp.FLOORID INNER JOIN
 [$(cadsde)].[$(schema)].FLOOR_LEVEL AS fl ON ft.FLOORCODE = fl.FLOORCODE INNER JOIN
 [$(cadsde)].[$(schema)].FloorPageTemplate AS fpt ON fpt.BUILDINGID = ft.BUILDINGID INNER JOIN
 [$(cadsde)].[$(schema)].FACILITY_TABLE AS fact ON ft.BUILDINGID = CAST(fact.FACILITY_NUMBER AS nvarchar(20)) INNER JOIN
 [$(cadsde)].[$(schema)].Building_Table as bt ON ft.BUILDINGID = bt.BUILDINGID
GO
------------------------------------------------------------------------
--go NO Longer needed, where clause moved to each view.
--DROP VIEW PubFloors
--go
--CREATE VIEW PubFloors AS
--SELECT * from AllFloors 
--WHERE SENSITIVITY = 'None'
--GO
------------------------------------------------------------------------
go
drop VIEW vw_FloorplanLine
go
CREATE VIEW vw_FloorplanLine AS
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
[$(cadsde)].[$(schema)].FLOORPLANLINE AS fpline INNER JOIN
[$(schema)].vw_Floor AS floors ON fpline.FLOORID = Floors.FLOORID
WHERE floors.SENSITIVITY = 'None'
------------------------------------------------------------------------
go
drop VIEW vw_FloorplanLine_Isometric
go
CREATE VIEW vw_FloorplanLine_Isometric AS
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
 --fpline.SOURCELAYER,
 --fpline.SOURCEDWG,
 fpline.LASTUPDATE,
 fpline.LASTEDITOR,
 fpline.SHAPE,
 fpline.OBJECTID
FROM          
[$(cadsde)].[$(schema)].FLOORPLANLINE_Isometric AS fpline INNER JOIN
[$(schema)].vw_Floor AS floors ON fpline.FLOORID = Floors.FLOORID
WHERE floors.SENSITIVITY = 'None'


------------------------------------------------------------------------
GO
DROP VIEW vw_FloorArea
go
CREATE VIEW vw_FloorArea AS
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
[$(cadsde)].[$(schema)].FLOORAREA AS floorarea INNER JOIN
[$(schema)].vw_Floor AS floors ON floors.FLOORID = floorarea.FLOORID
WHERE floors.SENSITIVITY = 'None'

------------------------------------------------------------------------
GO
DROP VIEW vw_FloorArea_Isometric
go
CREATE VIEW vw_FloorArea_Isometric AS
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
[$(cadsde)].[$(schema)].FLOORAREA_Isometric AS floorarea INNER JOIN
[$(schema)].vw_Floor AS floors ON floors.FLOORID = floorarea.FLOORID
WHERE floors.SENSITIVITY = 'None'

------------------------------------------------------------------------
GO
DROP VIEW vw_FloorPage
go
CREATE VIEW vw_FloorPage AS
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
[$(cadsde)].[$(schema)].FloorPageTemplate AS fpt INNER JOIN
[$(schema)].vw_Floor AS floors ON fpt.BUILDINGID = floors.BUILDINGID
WHERE floors.SENSITIVITY = 'None'

------------------------------------------------------------------------
GO
DROP VIEW vw_InteriorSpace_Point
go
CREATE VIEW vw_InteriorSpace_Point AS
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
[$(cadsde)].[$(schema)].INTERIORSPACE_POINT AS spaces INNER JOIN
[$(schema)].vw_Floor AS floors ON floors.FLOORID = spaces.FLOORID
WHERE floors.SENSITIVITY = 'None'

------------------------------------------------------------------------
GO
DROP VIEW vw_InteriorSpace
go
CREATE VIEW vw_InteriorSpace AS
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
[$(cadsde)].[$(schema)].INTERIORSPACE as spaces INNER JOIN
[$(schema)].vw_Floor AS floors ON floors.FLOORID = spaces.FLOORID
WHERE floors.SENSITIVITY = 'None'

------------------------------------------------------------------------
GO
DROP VIEW vw_InteriorSpace_Isometric
go
CREATE VIEW vw_InteriorSpace_Isometric AS
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
[$(cadsde)].[$(schema)].INTERIORSPACE_Isometric AS spaces INNER JOIN
[$(schema)].vw_Floor AS floors ON floors.FLOORID = spaces.FLOORID
WHERE floors.SENSITIVITY = 'None'

------------------------------------------------------------------------
GO
DROP VIEW vw_SitePoint
go
CREATE VIEW vw_SitePoint AS
SELECT     OBJECTID, SITEID, SITENAME, SOURCEID, SOURCEDWG, LASTUPDATE, LASTEDITOR, SHAPE.STCentroid() AS SHAPE
FROM       [$(cadsde)].[$(schema)].SITE
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
 [$(schema)].ACTIVE_FLOOR AS activefloors INNER JOIN
 [$(schema)].pubFloor_Points AS floorpoints ON activefloors.FLOORID = floorpoints.FLOORID
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
[$(schema)].ACTIVE_FLOOR
WHERE
(FLOORID NOT IN (SELECT FLOORID FROM [$(schema)].pubFloor_Points))
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
[$(schema)].ACTIVE_FLOOR AS activefloors INNER JOIN
[$(schema)].pubFloor_Points AS FP ON activefloors.FLOORID = FP.FLOORID
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
 [$(schema)].pubFloor_Points as floorpoints
WHERE    
(FLOORID NOT IN
 (SELECT floorpoints.FLOORID FROM [$(schema)].ACTIVE_FLOOR))
 
 GO
------------------------------------------------------------------------
 
 create view qaDuplicateFloorPoints as  
(SELECT max(objectid) as oid,count(*) as CountStar, FLOORID FROM [$(cadsde)].[$(schema)].FLOOR_POINT group by FLOORID having COUNT(*) > 1)   
GO
*/