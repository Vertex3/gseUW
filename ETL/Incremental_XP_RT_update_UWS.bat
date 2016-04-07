call C:\Apps\Gizinta\gseUW\ETL\BldgOutline_sync_UWS.bat
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
call C:\Apps\Gizinta\gseUW\ETL\Floorplan_sync_UWS.bat
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
call C:\Apps\Gizinta\gseUW\ETL\Publication_sync.bat
call C:\Apps\Gizinta\gseUW\ETL\Routing_Sync_UWS.bat
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
call C:\Apps\Gizinta\gseUW\ETL\Routing_ElevatorRebuild_sync.bat
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
call C:\Apps\Gizinta\gseUW\ETL\PublicationRouting_sync.bat
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
call fme C:\Apps\Gizinta\gseUW\ETL\batch\Exterior\gseBuildingConnector.fmw
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%