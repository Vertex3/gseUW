-- Create Pub Views - create publishing views
go
CREATE VIEW pubFloors AS
SELECT     
 activefloors.FloorID,
 activefloors.FloorCode,
 fl.NameShort,
 fl.NameLong,
 activefloors.HasInteriorSpaces,
 activefloors.HasFloorplanLines,
 activefloors.HasFloorArea,
 activefloors.SCHELEV AS "SchematicElevation",
 activefloors.GROUNDELEV AS "GroundElevation",
 fl.FloorLevel,
 ROW_NUMBER() OVER (partition BY activefloors.buildingid ORDER BY fl.FloorLevel) - 1 AS StackLevel,
 activefloors.Sensitivity,
 activefloors.SourceDWG,
 activefloors.BuildingID,
 tilt.BLDGNAME as "BuildingName",
 tilt.CalcRot as "CalcRot",
 activefloors.BLDGCODE + '_' + LTRIM(STR(fl.FloorLevel)) AS DDPFloorSort,
 activefloors.LastUpdate,
 activefloors.LastEditor
FROM
 dbo.ACTIVE_FLOOR AS activefloors LEFT OUTER JOIN
 dbo.BUILDING_OUTLINE_TILT AS tilt ON tilt.BuildingID = activefloors.BuildingID INNER JOIN
 dbo.FLOOR_LEVEL AS fl ON activefloors.FloorCode = fl.FloorCode
WHERE Sensitivity = 'None'
GO
------------------------------------------------------------------------
go
CREATE VIEW pubFloorplanLines AS
SELECT     
 fpline.FloorID,
 fpline.FloorCode,
 floors.NameShort,
 floors.NameLong,
 floors.SchematicElevation,
 floors.GroundElevation,
 floors.FloorLevel,
 floors.StackLevel,
 floors.Sensitivity,
 fpline.SiteID,
 fpline.BuildingID,
 fpline.SourceLayer,
 fpline.SourceID,
 fpline.SourceDWG,
 fpline.LastUpdate,
 fpline.LastEditor,
 fpline.SHAPE,
 fpline.OBJECTID
FROM         
dbo.FLOORPLANLINE AS fpline INNER JOIN
dbo.pubFloors AS floors ON fpline.FloorID = Floors.FloorID
WHERE (floors.Sensitivity = 'None')
------------------------------------------------------------------------
GO
CREATE VIEW pubFloor_Areas AS
SELECT     
 floorarea.FloorID,
 floorarea.FloorCode,
 floorarea.FloorArea,
 floors.NameShort,
 floors.NameLong,
 floors.SchematicElevation,
 floors.GroundElevation,
 floors.FloorLevel,
 floors.StackLevel, 
 floors.Sensitivity,
 floors.CalcRot,
 floors.DDPFloorSort,
 floorarea.BuildingID,
 floorarea.SiteID,
 floorarea.SourceDWG,
 floorarea.LastUpdate,
 floorarea.LastEditor,
 floorarea.SHAPE,
 floorarea.OBJECTID
FROM
dbo.FLOOR_AREA AS floorarea INNER JOIN
dbo.pubFloors AS floors ON floors.FloorID = floorarea.FloorID
WHERE     (floors.Sensitivity = 'None')
------------------------------------------------------------------------
GO
CREATE VIEW pubFloor_Outlines AS
SELECT     
 flooroutlines.FloorID,
 flooroutlines.FloorCode,
 floors.NameShort,
 floors.NameLong,
 floors.SchematicElevation,
 floors.GroundElevation,
 floors.FloorLevel,
 floors.StackLevel,
 floors.Sensitivity,
 floors.CalcRot,
 floors.DDPFloorSort,
 flooroutlines.BuildingID,
 flooroutlines.SiteID,
 flooroutlines.SourceDWG,
 flooroutlines.LastUpdate,
 flooroutlines.LastEditor,
 flooroutlines.SHAPE,
 flooroutlines.OBJECTID
FROM         
dbo.FLOOR_OUTLINE AS flooroutlines INNER JOIN
dbo.pubFloors AS floors ON flooroutlines.FloorID = floors.FloorID
WHERE     (floors.Sensitivity = 'None')
------------------------------------------------------------------------
GO
CREATE VIEW pubFloor_Points AS
SELECT     
 floorpoint.FloorCode,
 floorpoint.FloorID,
 floors.NameShort,
 floors.NameLong,
 floors.SchematicElevation,
 floors.GroundElevation,
 floors.FloorLevel,
 floors.StackLevel,
 floors.Sensitivity,
 floors.CalcRot,
 (SELECT     COUNT(*) AS Expr1 FROM dbo.INTERIORSPACE AS SPC WHERE (floors.FloorID = floors.FloorID)) AS InteriorSpaceCount,
 (SELECT COUNT(*) AS Expr1 FROM dbo.FLOORPLANLINE AS fpl WHERE (floors.FloorID = floors.FloorID)) AS FloorplanLineCount,
 (SELECT     COUNT(*) AS Expr1 FROM dbo.FLOOR_AREA AS FA WHERE (floors.FloorID = floors.FloorID)) AS FloorAreaCount,
 ddp.ModPortrait,
 ddp.ModLandscape,
 ddp.Scale85X11,
 ddp.Scale11X17,
 floors.DDPFloorSort,
 floorpoint.SiteID,
 floorpoint.BuildingID,
 floorpoint.LastUpdate,
 floorpoint.LastEditor,
 floorpoint.SHAPE,
 floorpoint.OBJECTID
FROM         
 dbo.FLOOR_POINT as floorpoint INNER JOIN
 dbo.pubFloors as floors ON floors.FloorID = floorpoint.FloorID LEFT OUTER JOIN
 dbo.DDPINDEX_SUPPORT ddp ON floorpoint.BuildingID = ddp.BuildingID
WHERE     (floors.Sensitivity = 'None')

------------------------------------------------------------------------
GO
CREATE VIEW pubInteriorSpace_Points AS
SELECT     
 spaces.SpaceID,
 spaces.RoomNumber,
 spaces.FloorID,
 spaces.FloorCode,
 floors.NameShort,
 floors.NameLong,
 floors.SchematicElevation,
 floors.GroundElevation,
 floors.FloorLevel,
 floors.StackLevel,
 floors.Sensitivity,
 spaces.BuildingID,
 spaces.SiteID,
 spaces.SourceDWG,
 spaces.LastUpdate,
 spaces.LastEditor,
 spaces.SHAPE,
 spaces.OBJECTID

FROM         
dbo.INTERIORSPACE_POINT AS spaces INNER JOIN
dbo.pubFloors AS floors ON floors.FloorID = spaces.FloorID
WHERE     (floors.Sensitivity = 'None')
------------------------------------------------------------------------
GO
CREATE VIEW pubInteriorSpaces AS
SELECT     
 spaces.SpaceID,
 spaces.RoomNumber,
 spaces.FloorID,
 spaces.FloorCode,
 floors.NameShort,
 floors.NameLong,
 floors.SchematicElevation,
 floors.GroundElevation,
 floors.FloorLevel,
 floors.StackLevel,
 floors.Sensitivity,
 spaces.SpaceClass,
 spaces.SpaceArea,
 spaces.BuildingID,
 spaces.SiteID,
 spaces.SourceID,
 spaces.SourceDWG,
 spaces.LastUpdate,
 spaces.LastEditor,
 spaces.SHAPE,
 spaces.OBJECTID
FROM
dbo.INTERIORSPACE as spaces INNER JOIN
dbo.pubFloors AS floors ON floors.FloorID = spaces.FloorID
WHERE     (floors.Sensitivity = 'None')
------------------------------------------------------------------------
GO
CREATE VIEW pubInteriorSpaces_Tilt AS
SELECT     
 spaces.SpaceID,
 spaces.RoomNumber,
 spaces.FloorID,
 spaces.FloorCode,
 floors.NameShort,
 floors.NameLong,
 floors.FloorLevel,
 floors.StackLevel,
 floors.Sensitivity,
 spaces.BuildingID,
 spaces.SiteID,
 spaces.LastUpdate,
 spaces.LastEditor,
 spaces.SHAPE,
 spaces.OBJECTID
FROM
dbo.INTERIORSPACE_Tilt AS spaces INNER JOIN
dbo.pubFloors AS floors ON floors.FloorID = spaces.FloorID
WHERE     (floors.Sensitivity = 'None')
------------------------------------------------------------------------
GO
CREATE VIEW qaMissingFeaturesByFloor AS
SELECT     
 activefloors.HasInteriorSpaces,
 activefloors.HasFloorplanLines,
 activefloors.HasFloorArea,
 activefloors.FloorID,
 floorpoints.InteriorSpaceCount,
 floorpoints.FloorplanLineCount,
 floorpoints.FloorAreaCount
FROM         
 dbo.ACTIVE_FLOOR AS activefloors INNER JOIN
 dbo.pubFloor_Points AS floorpoints ON activefloors.FloorID = floorpoints.FloorID
WHERE     
(floorpoints.InteriorSpaceCount = 0) AND (activefloors.HasInteriorSpaces = 'T') OR
(floorpoints.FloorplanLineCount = 0) AND (activefloors.HasFloorplanLines = 'T') OR
(floorpoints.FloorAreaCount = 0) AND (activefloors.HasFloorArea = 'T')
------------------------------------------------------------------------
GO
CREATE VIEW qaMissingFloorPoints AS
SELECT     
 FloorCode,
 FloorID,
 BuildingID,
 SourceDWG
FROM         
dbo.ACTIVE_FLOOR
WHERE
(FloorID NOT IN (SELECT FloorID FROM dbo.pubFloor_Points))
 ------------------------------------------------------------------------
GO
CREATE VIEW qaUnexpectedFeaturesByFloor AS
SELECT     
 activefloors.HasInteriorSpaces,
 activefloors.HasFloorplanLines,
 activefloors.HasFloorArea,
 activefloors.FloorID,
 FP.InteriorSpaceCount,
 FP.FloorplanLineCount,
 FP.FloorAreaCount,
 FP.SHAPE,
 FP.OBJECTID
FROM         
dbo.ACTIVE_FLOOR AS activefloors INNER JOIN
dbo.pubFloor_Points AS FP ON activefloors.FloorID = FP.FloorID
WHERE     
(FP.InteriorSpaceCount > 0) AND (activefloors.HasInteriorSpaces IS NULL OR activefloors.HasInteriorSpaces = 'F') OR
(FP.FloorplanLineCount > 0) AND (activefloors.HasFloorplanLines IS NULL OR activefloors.HasFloorplanLines = 'F') OR
(FP.FloorAreaCount > 0) AND (activefloors.HasFloorArea IS NULL OR activefloors.HasFloorArea = 'F')
------------------------------------------------------------------------
GO
CREATE VIEW qaUnexpectedFloorPoints AS
SELECT     
 FloorID,
 FloorCode,
 NameShort,
 LastUpdate,
 LastEditor,
 BuildingID,
 SiteID
FROM         
 dbo.pubFloor_Points as floorpoints
WHERE    
(FloorID NOT IN
 (SELECT floorpoints.FloorID FROM dbo.ACTIVE_FLOOR))
 
 GO