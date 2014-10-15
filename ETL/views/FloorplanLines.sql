SELECT    
 FLOORID as FloorID,
 FLOOR as Floor,
 SOURCELAYER as SourceLayer,
 SENSITIVITY as Sensitivity,
 IN_DATE as InDate,
 LAST_USER as LastUser,
 BUILDINGID as BuildingID,
 SITEID as SiteID,
 SHAPE,
 OBJECTID
FROM            dbo.FLOORPLANLINE AS FPL
WHERE        (SENSITIVITY <> 'Hidden')