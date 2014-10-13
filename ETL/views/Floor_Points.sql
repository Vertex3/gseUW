SELECT        
FP.FLOORID as FloorID, 
FP.FLOOR as Floor, 
FL.NAME_SHORT as NameShort, 
FL.NAME_LONG as NameLong, 
AF.SCHELEV as SchematicElevation, 
FP.CALCROT as CalculatedRotation, 
FP.MODPORTRAIT as ModPortrait, 
FP.MODLANDSCAPE as ModLandscape, 
FP.SCALE_85X11 as Scale85X11, 
FP.SCALE_11X17 as Scale11X17, 
FP.FLOOR_LEVEL as FloorLevel, 
(Select Count(*) from dbo.InteriorSpaces SPC where SPC.FLOORID=FP.FLOORID) as HasInteriorSpaces, 
(Select Count(*) from dbo.FloorplanLine fpl where fpl.FLOORID=FP.FLOORID) as HasFloorplanLines, 
(Select Count(*) from dbo.Floor_Area FA where FA.FLOORID=FP.FLOORID) as HasFloorAreas, 
FP.SENSITIVITY as Sensitivity, 
FP.IN_DATE as InDate, 
FP.LAST_USER as LastUser, 
FP.BUILDINGID as BuildingID, 
FP.SITEID as SiteID, 
FP.SHAPE, 
FP.OBJECTID

FROM dbo.FLOOR_POINT AS FP 
INNER JOIN
  dbo.ACTIVE_FLOOR AS AF ON FP.FLOORID = AF.FLOORID
INNER JOIN
     dbo.FLOOR_LEVEL FL ON AF.FLOOR = FL.FLOOR
WHERE        (FP.SENSITIVITY <> 'Hidden')

-- leaving out
-- FACILITY_CODE
-- FACLEVEL
-- GlobalID
-- FLOOR_NAME1
-- BLDG_NAME
-- WEBMERCROT
-- FP.FLOOR_NAME as FloorName, 
-- unresolved - Has fields as select count(*)? seems to work
--AF.ALTITUDE as Altitude,
--FP.NAME, 
