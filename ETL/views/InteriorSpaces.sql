SELECT        
dbo.INTERIORSPACE.SPACEID as SpaceID, 
dbo.INTERIORSPACE.ROOM as Room, 
--dbo.INTERIORSPACE.SPACECLASS as SpaceClass, 
dbo.INTERIORSPACE.SPACEAREA as SpaceArea, 
dbo.INTERIORSPACE.SENSITIVITY as Sensitivity, 
dbo.INTERIORSPACE.IN_DATE as InDate, 
dbo.INTERIORSPACE.LAST_USER as LastUser, 
dbo.INTERIORSPACE.SOURCEID as SourceID, 
dbo.INTERIORSPACE.SOURCEDWG as SourceDWG, 
--dbo.INTERIORSPACE.GlobalID, 
--dbo.INTERIORSPACE.FLOOR_NAME as FloorName, 
--dbo.INTERIORSPACE.BLDG_NAME AS BuildingName, 
dbo.INTERIORSPACE.FLOOR as Floor, 
dbo.ACTIVE_FLOOR.SCHELEV as SchematicElevation,
dbo.FLOOR_LEVEL.NAME_LONG as FloorNameLong,
dbo.FLOOR_LEVEL.NAME_SHORT as FloorNameShort,
dbo.INTERIORSPACE.FLOORID as FloorID, 
dbo.INTERIORSPACE.BUILDINGID as BuildingID, 
dbo.INTERIORSPACE.SITEID as SiteID, 

dbo.INTERIORSPACE.SHAPE,
dbo.INTERIORSPACE.OBJECTID as ObjectID

FROM dbo.INTERIORSPACE INNER JOIN
  dbo.FLOOR_LEVEL ON dbo.INTERIORSPACE.FLOOR = dbo.FLOOR_LEVEL.FLOOR,
  dbo.ACTIVE_FLOOR on DBO.INTERIORSPACE.FLOORID = dbo.ACTIVE_FLOORID
WHERE
  (dbo.INTERIORSPACE.SENSITIVITY <> 'Hidden')
  --
  --
  SELECT        
  SPC.SPACEID AS SpaceID, 
  SPC.ROOM AS Room, 
  SPC.SPACEAREA AS SpaceArea, 
  SPC.SENSITIVITY AS Sensitivity, 
  SPC.IN_DATE AS InDate, 
  SPC.LAST_USER AS LastUser, 
  SPC.SOURCEID AS SourceID, 
  SPC.SOURCEDWG AS SourceDWG, 
  SPC.FLOOR AS Floor, 
  AF.SCHELEV AS SchematicElevation, 
  FL.NAME_LONG AS FloorNameLong, 
  FL.NAME_SHORT AS FloorNameShort, 
  SPC.FLOORID AS FloorID, 
  SPC.BUILDINGID AS BuildingID, 
  SPC.SITEID AS SiteID, 
  SPC.SHAPE, 
  SPC.OBJECTID AS ObjectID
FROM dbo.INTERIORSPACE SPC 
INNER JOIN
     dbo.ACTIVE_FLOOR AF ON dbo.INTERIORSPACE.FLOORID = dbo.ACTIVE_FLOOR.FLOORID 
INNER JOIN
     dbo.FLOOR_LEVEL FL ON dbo.ACTIVE_FLOOR.FLOOR = dbo.FLOOR_LEVEL.FLOOR
WHERE        (SPC.SENSITIVITY <> 'Hidden')