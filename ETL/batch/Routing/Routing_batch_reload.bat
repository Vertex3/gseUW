call fme c:\Apps\Gizinta\gseUW\ETL\fme\gseRoutingLoader.fmw
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
call C:\Apps\Gizinta\gseUW\ETL\Routing_ElevatorRebuild_sync.bat
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
call C:\Apps\Gizinta\gseUW\ETL\PublicationRouting_sync.bat
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
call fme C:\Apps\Gizinta\gseUW\ETL\batch\Exterior\gseBuildingConnector.fmw
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
call C:\Apps\Gizinta\gseUW\ETL\batch\Routing\doNetwork.bat
