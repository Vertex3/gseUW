-- Create Cadsde Views - create views needed for ETL Processing
-- Note: to use this script, modify the name of the database in the USE
-- statement below. This is the database where the views will be created.
-- Also modify the name of the schema for the table names to ensure this is 
-- the cadsde database where the tables and feature classes are managed.
-- Optionally also change the name of the schema owner from "dbo"

-- Note: You must set SQLCMD mode for this script to work:
-- In the "Query" menu in SSMS, simply toggle "SQLCMD Mode"

:setvar schema "dbo"
:setvar pubdb "UWGISProduction"
:setvar cadsde "UWGISProduction"

-- set the database where views will be created
USE $(pubdb);
-- 
DROP VIEW Floor
GO
CREATE VIEW Floor AS
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
GO
DROP VIEW FloorPage
go
CREATE VIEW FloorPage AS
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
[$(schema)].Floor AS floors ON fpt.BUILDINGID = floors.BUILDINGID
WHERE floors.SENSITIVITY = 'None'

