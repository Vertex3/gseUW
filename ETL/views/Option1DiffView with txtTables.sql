select FLOORID,SPACEID, SHAPE_TEXT from [maps.uw.edu].UWCadSde.dbo.txtInteriorSpace
EXCEPT select FLOORID,SPACEID, SHAPE.STAsText() as SHAPE_TEXT from dbo.INTERIORSPACE
