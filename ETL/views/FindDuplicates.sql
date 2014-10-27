select FloorID,COUNT(*) from dbo.pubFloor_Outlines group by FloorID having COUNT(*) >1;
select FloorID,COUNT(*) from dbo.pubFloor_Areas group by FLOORID having COUNT(*) >1;
select SpaceID,COUNT(*) from dbo.pubInteriorSpaces group by SpaceID having COUNT(*) >1;
select SpaceID,COUNT(*) from dbo.pubInteriorSpaces_Tilt group by SpaceID having COUNT(*) >1;
select SpaceID,COUNT(*) from dbo.pubInteriorSpace_Points group by SpaceID having COUNT(*) >1;

