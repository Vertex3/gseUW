
use UWGISProduction

update Building_Table set 
GROUNDELEV = bz.Z 
from dbo.BuildingZ as bz where bz.BUILDINGID=Building_Table.BUILDINGID

update Building_Table set 
SENSITIVITY = 'None'

update dbo.Building_Table set 
SENSITIVITY = 'Hidden'
where BUILDINGID in ('1212',  '1053',  '6327')

update DRAWINGTYPE_OUTLINE set FLOORPAGETEMPLATE = 'Y'
update DRAWINGTYPE_XP set FLOORPLANLINE = 'Y', INTERIORSPACE='Y',FLOORAREA='Y'
update DRAWINGTYPE_RT set DRAWINGNAME = REPLACE(DRAWINGNAME,'XP','RT')
update DRAWINGTYPE_WF set DRAWINGNAME = REPLACE(DRAWINGNAME,'XP','WF')

