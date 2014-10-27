
prog = r'C:\Apps\FME\fme.exe'
comm = r" C:\Apps\Gizinta\gseUW\ETL\fme\gseFloorplanLoader.fmw "  + \
' --DestDataset_GEODATABASE_SDE sde ' + \
r' --OUT_CONNECTION_FILE_GEODATABASE_SDE "C:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde" ' + \
r' --ProductionConnectionFile "C:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Production.sde" ' + \
r' --GizintaProject C:\Apps\Gizinta\gseUW\ETL\config\fpLoadPlaylist.xml ' + \
' --TargetFieldQA True ' + \
' --SourceFieldQA False ' + \
' --IgnoreErrors False ' + \
' --SourceDatasetTypes CADDataset ' + \
' --SourceCoordinateSystem EPSG:2285 ' + \
' --gzDebug False ' + \
' --truncate N ' + \
r' --LOG_FILE C:\Apps\Gizinta\gseUW\ETL\fme\log\gseFloorplanLoader###.log ' + \
' --FEATURE_TYPES  "Floor_Poly FloorplanLine InteriorSpace" ' + \
' --FEATURE_TYPES_READ "GSF BSE RMS"' + \
r' --SourceDataset_ESRIMSD C:\Apps\Gizinta\CADVault\Floorplans###\**\*XP*.dwg'

print comm.replace("###",'0') 

