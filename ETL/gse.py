# gse.py - Gizinta Sync Engine Supporting functions for University of Washington
# ---------------------------------------------------------------------------
# Created on: 2014.923 SG
#
# Description: Supporting functions
# ---------------------------------------------------------------------------

import os, sys

dbSchema = 'dbo'

gsepath = r'C:\apps\gizinta\gseUW'

fmeFolder = gsepath + "\\ETL\\fme\\"
configFolder = gsepath + "\\ETL\\config\\"
serverConfigFolder = gsepath + "\\ETL\\serverConfig\\"
etlFolder = gsepath + "\\ETL\\"
sdeConnFolder = gsepath + "\\ETL\\serverConfig"
pyFolder = gsepath + "\\ETL\\py\\"
pyLogFolder = pyFolder + "\\log\\"

if pyFolder not in sys.path:
	sys.path.insert(0, pyFolder)

if etlFolder not in sys.path:
    sys.path.insert(0, etlFolder)

if fmeFolder not in sys.path:
    sys.path.insert(0, fmeFolder)

