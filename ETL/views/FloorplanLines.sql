SELECT    
 SITEID as SiteID,
 BUILDINGID as BuildingID,
 FLOOR as Floor,
 FLOORID as FloorID,
 SENSITIVITY as Sensitivity,
 IN_DATE as InDate,
 LAST_USER as LastUser,
 SHAPE,
 OBJECTID
FROM            dbo.FLOORPLANLINE AS FPL
WHERE        (SENSITIVITY <> 'Hidden')