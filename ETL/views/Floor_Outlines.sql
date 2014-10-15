SELECT 
 FLOORID as FloorID,
 FLOOR as Floor,
 SCHELEV as SchematicElevation,

 SENSITIVITY as Sensitivity,
 IN_DATE as InDate,
 LAST_USER as LastUser,
 SOURCEDWG as SourceDWG,

 SITEID as SiteID,
 BUILDINGID as BuildingID,

 SHAPE,
 OBJECTID
FROM            dbo.FLOOR_OUTLINE
WHERE        (SENSITIVITY <> 'Hidden')