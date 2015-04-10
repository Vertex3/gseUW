del C:\apps\Gizinta\gseUW\ETL\batch\Routing\Routing.gdb /s /q
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
xcopy C:\apps\Gizinta\gseUW\ETL\batch\Routing\Template.gdb C:\apps\Gizinta\gseUW\ETL\batch\Routing\Routing.gdb /e /i /y
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
fme C:\apps\Gizinta\gseUW\ETL\batch\Routing\GenerateNetworkDataset.fmw
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
C:\apps\Gizinta\gseUW\ETL\batch\Routing\buildNDS.py
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
del r:\routing.gdb  /s /q
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
xcopy C:\apps\Gizinta\gseUW\ETL\batch\Routing\Routing.gdb r:\Routing.gdb /e /i /y