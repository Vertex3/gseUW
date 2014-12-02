UPDATE UWGISProduction.dbo.ACTIVE_FLOOR set HASFLOORAREA = 'Y' where FLOORID in
(SELECT FLOORID From UWGISProduction.dbo.pubFloor_Points where FloorAreaCount <> '0')
GO
UPDATE UWGISProduction.dbo.ACTIVE_FLOOR set HASFLOORPLANLINES = 'Y' where FLOORID in
(SELECT FLOORID From UWGISProduction.dbo.pubFloor_Points where FloorplanlineCount <> '0')
GO
UPDATE UWGISProduction.dbo.ACTIVE_FLOOR set HASINTERIORSPACES = 'Y' where FLOORID in
(SELECT FLOORID From UWGISProduction.dbo.pubFloor_Points where InteriorSpaceCount <> '0')
GO
