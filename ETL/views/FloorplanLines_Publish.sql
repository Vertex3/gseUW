SELECT        
FLOORID, 
FLOOR, 
AF.SCHELEV AS SchematicElevation, 
FL.NAME_SHORT AS FloorNameShort, 
FL.NAME_LONG AS FloorNameLong, 
SOURCELAYER, 
SENSITIVITY, 
IN_DATE, 
LAST_USER, 
SOURCEID, 
SOURCEDWG, 
BUILDINGID, 
SITEID, 
SHAPE,
OBJECTID
FROM            dbo.FLOORPLANLINE AS FPL
INNER JOIN
     dbo.ACTIVE_FLOOR AF ON fpl.FLOORID = dbo.ACTIVE_FLOOR.FLOORID 
INNER JOIN
     dbo.FLOOR_LEVEL FL ON dbo.ACTIVE_FLOOR.FLOOR = dbo.FLOOR_LEVEL.FLOOR
WHERE        (SENSITIVITY <> 'Hidden')


-- GlobalID, 
