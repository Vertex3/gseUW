call C:\Apps\Gizinta\gseUW\ETL\BldgOutline_sync.bat
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
call C:\Apps\Gizinta\gseUW\ETL\Floorplan_sync.bat
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
call C:\Apps\Gizinta\gseUW\ETL\Publication_sync.bat
