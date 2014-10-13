  SELECT        
  SPC.SPACEID AS SpaceID, 
  SPC.ROOM AS Room, 
  SPC.SENSITIVITY AS Sensitivity, 
  SPC.IN_DATE AS InDate, 
  SPC.LAST_USER AS LastUser, 
  SPC.FLOOR AS Floor, 
  AF.SCHELEV AS SchematicElevation, 
  SPC.STACKLEVEL AS StackLevel, 
  FL.NAME_LONG AS FloorNameLong, 
  FL.NAME_SHORT AS FloorNameShort, 
  SPC.FLOORID AS FloorID, 
  SPC.BUILDINGID AS BuildingID, 
  SPC.SITEID AS SiteID, 
  SPC.SHAPE, 
  SPC.OBJECTID AS ObjectID
FROM dbo.INTERIORSPACE_TILT SPC 
INNER JOIN
     dbo.ACTIVE_FLOOR AF ON SPC.FLOORID = dbo.ACTIVE_FLOOR.FLOORID 
INNER JOIN
     dbo.FLOOR_LEVEL FL ON dbo.ACTIVE_FLOOR.FLOOR = dbo.FLOOR_LEVEL.FLOOR
WHERE        (SPC.SENSITIVITY <> 'Hidden')