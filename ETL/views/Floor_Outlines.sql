SELECT 
 FLOORID as FloorID,
 FLOOR as Floor,
 SCHELEV as SchematicElevation,
-- ALTITUDE,
 SENSITIVITY as Sensitivity,
 IN_DATE as InDate,
 LAST_USER as LastUser,
 SOURCEDWG as SourceDWG,
-- GlobalID,
 SITEID as SiteID,
 BUILDINGID as BuildingID,
-- FLOOR_NAME,
-- BLDG_NAME,
 SHAPE,
 OBJECTID
FROM            dbo.FLOOR_OUTLINE
WHERE        (SENSITIVITY <> 'Hidden')