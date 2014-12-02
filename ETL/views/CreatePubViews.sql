-- Create Pub Views - create publishing views
go
CREATE VIEW ALLFloors AS
SELECT     
 activefloors.FLOORID,
 activefloors.FLOORCODE,
 fl.NAMESHORT,
 fl.NAMELONG,
 activefloors.HASINTERIORSPACES,
 activefloors.HASFLOORPLANLINES,
 activefloors.HASFLOORAREA,
 activefloors.SCHELEV,
 activefloors.GROUNDELEV,
 fl.FLOORLEVEL,
 ROW_NUMBER() OVER (partition BY activefloors.BUILDINGID ORDER BY fl.FLOORLEVEL) - 1 AS StackLevel,
 activefloors.SENSITIVITY,
 activefloors.SOURCEDWG,
 activefloors.BUILDINGID,
 tilt.BLDGNAME,
 tilt.CALCROT,
 activefloors.BLDGCODE + '_' + LTRIM(STR(fl.FLOORLEVEL)) AS DDPFLOORSORT,
 activefloors.LASTUPDATE,
 activefloors.LASTEDITOR
FROM
 dbo.ACTIVE_FLOOR AS activefloors LEFT OUTER JOIN
 dbo.BUILDING_OUTLINE_TILT AS tilt ON tilt.BUILDINGID = activefloors.BUILDINGID INNER JOIN
 dbo.FLOOR_LEVEL AS fl ON activefloors.FLOORCODE = fl.FLOORCODE
GO
------------------------------------------------------------------------
go
CREATE VIEW pubFloors AS
SELECT     
 activefloors.FLOORID,
 activefloors.FLOORCODE,
 fl.NAMESHORT,
 fl.NAMELONG,
 activefloors.HASINTERIORSPACES,
 activefloors.HASFLOORPLANLINES,
 activefloors.HASFLOORAREA,
 activefloors.SCHELEV,
 activefloors.GROUNDELEV,
 fl.FLOORLEVEL,
 ROW_NUMBER() OVER (partition BY activefloors.BUILDINGID ORDER BY fl.FLOORLEVEL) - 1 AS StackLevel,
 activefloors.SENSITIVITY,
 activefloors.SOURCEDWG,
 activefloors.BUILDINGID,
 tilt.BLDGNAME,
 tilt.CALCROT,
 activefloors.BLDGCODE + '_' + LTRIM(STR(fl.FLOORLEVEL)) AS DDPFLOORSORT,
 activefloors.LASTUPDATE,
 activefloors.LASTEDITOR
FROM
 dbo.ACTIVE_FLOOR AS activefloors LEFT OUTER JOIN
 dbo.BUILDING_OUTLINE_TILT AS tilt ON tilt.BUILDINGID = activefloors.BUILDINGID INNER JOIN
 dbo.FLOOR_LEVEL AS fl ON activefloors.FLOORCODE = fl.FLOORCODE
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
dbo.pubFloors AS floors ON fpline.FLOORID = Floors.FLOORID
WHERE (floors.SENSITIVITY = 'None')
------------------------------------------------------------------------
GO
CREATE VIEW pubFloor_Areas AS
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
dbo.FLOOR_AREA AS floorarea INNER JOIN
dbo.pubFloors AS floors ON floors.FLOORID = floorarea.FLOORID
WHERE     (floors.SENSITIVITY = 'None')
------------------------------------------------------------------------
GO
CREATE VIEW pubFloor_Outlines AS
SELECT     
 flooroutlines.FLOORID,
 flooroutlines.FLOORCODE,
 floors.NAMESHORT,
 floors.NAMELONG,
 floors.SCHELEV,
 floors.GROUNDELEV,
 floors.FLOORLEVEL,
 floors.STACKLEVEL,
 floors.SENSITIVITY,
 floors.CALCROT,
 floors.DDPFLOORSORT,
 flooroutlines.BUILDINGID,
 flooroutlines.SITEID,
 flooroutlines.SOURCEDWG,
 flooroutlines.LASTUPDATE,
 flooroutlines.LASTEDITOR,
 flooroutlines.SHAPE,
 flooroutlines.OBJECTID
FROM         
dbo.FLOOR_OUTLINE AS flooroutlines INNER JOIN
dbo.pubFloors AS floors ON flooroutlines.FLOORID = floors.FLOORID
WHERE     (floors.SENSITIVITY = 'None')
------------------------------------------------------------------------
GO
CREATE VIEW pubFloor_Points AS
SELECT     
 floorpoint.FLOORCODE,
 floorpoint.FLOORID,
 floors.NAMESHORT,
 floors.NAMELONG,
 floors.SCHELEV,
 floors.GROUNDELEV,
 floors.FLOORLEVEL,
 floors.STACKLEVEL,
 floors.SENSITIVITY,
 floors.CALCROT,
 (SELECT     COUNT(*) AS Expr1 FROM dbo.INTERIORSPACE AS SPC WHERE (floors.FLOORID = floors.FLOORID)) AS INTERIORSPACECOUNT,
 (SELECT COUNT(*) AS Expr1 FROM dbo.FLOORPLANLINE AS fpl WHERE (floors.FLOORID = floors.FLOORID)) AS FLOORPLANLINECOUNT,
 (SELECT     COUNT(*) AS Expr1 FROM dbo.FLOOR_AREA AS FA WHERE (floors.FLOORID = floors.FLOORID)) AS FLOORAREACOUNT,
 ddp.MODPORTRAIT,
 ddp.MODLANDSCAPE,
 ddp.Scale85X11,
 ddp.Scale11X17,
 floors.DDPFLOORSORT,
 floorpoint.SITEID,
 floorpoint.BUILDINGID,
 floorpoint.LASTUPDATE,
 floorpoint.LASTEDITOR,
 floorpoint.SHAPE,
 floorpoint.OBJECTID
FROM         
 dbo.FLOOR_POINT as floorpoint INNER JOIN
 dbo.pubFloors as floors ON floors.FLOORID = floorpoint.FLOORID LEFT OUTER JOIN
 dbo.DDPINDEX_SUPPORT ddp ON floorpoint.BUILDINGID = ddp.BUILDINGID
WHERE     (floors.SENSITIVITY = 'None')

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
dbo.pubFloors AS floors ON floors.FLOORID = spaces.FLOORID
WHERE     (floors.SENSITIVITY = 'None')
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
dbo.pubFloors AS floors ON floors.FLOORID = spaces.FLOORID
WHERE     (floors.SENSITIVITY = 'None')
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
dbo.pubFloors AS floors ON floors.FLOORID = spaces.FLOORID
WHERE     (floors.SENSITIVITY = 'None')
------------------------------------------------------------------------
GO
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