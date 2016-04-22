update Building_Table set 
GROUNDELEV = bz.Z 
from dbo.BuildingZ as bz INNER JOIN 
dbo.BUILDING_Table as bt ON bz.BUILDINGID=bz.BUILDINGID
