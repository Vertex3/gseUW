There are several scripts and batch files in this folder:

tIncremental_scheduled_task - the main hourly sync task. Calls partial vault mirror and runSyncSites.py.
tNavigation_scheduled_task - daily navigation data update. Calls runSyncNavigation.py
tExteriorLines - Just updates the exterior lines, included in the Nav update but also can be run separately.

runSyncSites.py - calls bldg, fp, rt, and rt extract tools.
runSyncNavigation.py - rebuilds elevators, connects buildings, builds network dataset and remote file geodatabase
runRoutingExtract.py - called from runSyncSites to extract buildings + exterior lines changed since a date.

sitesCAD.txt - list of sites to run bldg, fp, and rt loads for
sitesNavigation.txt - list of sites for routable network generation, currently just UWS