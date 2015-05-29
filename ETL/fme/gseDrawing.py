# gseDrawing.py - Gizinta Sync Engine drawing functions - get ID values from drawing name and/or FME feature
# SG Jan 2014
# ---------------------------------------------------------------------------

import sys,os,time

namedelimiter = '_'
dash = '-'
def getDrawing(feature):
	#dwgName = feature.getAttribute("DRAWING")
	dwgName = feature.getAttribute("fme_basename")
	return dwgName

def getSiteID(feature):
	site = "MAIN"
	pth = feature.getAttribute("autocad_source_filename")
	site = getSiteIDFromPath(pth)
	return site

def getBuildingName(feature):
	pth = feature.getAttribute("autocad_source_filename")
	bldgname = getBuildingNameFromPath(pth)
	return bldgname

def getSiteIDFromPath(pth):
	site = None
	try:
		pth = pth.split(os.sep)
		if len(pth) > 3:
			if pth[len(pth)-2].lower() == 'routing':
				site = pth[len(pth)-4] # this will get the site folder name when Routing drawing
			else:
				site = pth[len(pth)-3] # this will get the site folder name, needs to be set up for specific file structure
			site = site.split("-")[0]# get the first part of the string if there is a dash
	except:
		site = feature.getAttribute('siteid')
		if site == None or site == '':		
			print "Error getting SiteID for:" + str(pth)
	return site

def getFloorIDFromPath(pth):
	global namedelimiter
	dwg = pth[pth.rfind(os.sep)+1:]
	#site = getSiteIDFromPath(pth)
	floorID = getBuildingFromName(dwg) + namedelimiter + getFloorCodeFromName(dwg)
	return floorID

def getBuildingIDFromPath(pth):
	global namedelimiter
	dwg = pth[pth.rfind(os.sep)+1:]
	#site = getSiteIDFromPath(pth)
	buildingID = getBuildingFromName(dwg)
	return buildingID

def getBuildingNameFromPath(pth):
	name = None
	# look in the parent folder
	try:
		pth = pth.split(os.sep)
		folder = pth[len(pth)-2] # this will get the parent folder name, needs to be set up for specific file structure
		name = folder[9:].replace(dash,' ').strip(' ').title()
	except:
		print "Error getting Building Name for:" + str(pth)
	return name

def getSiteplanID(feature):
	site = "MAIN"
	pth = feature.getAttribute("autocad_source_filename")
	try:
		pth = pth.split(os.sep)
		if len(pth) > 2:
			site = pth[len(pth)-3] # this will get the site folder name, needs to be set up for specific file structure
			site = site.split("-")[0]# get the first part of the string if there is a dash
	except:
		print "Error getting SiteID for:" + str(pth)
	return site

def getSiteplanBuildingID(feature):
	try:
		building = str(feature.getAttribute("FACNUM"))
	except:
		building = None
	return building

def getBuildingID(feature):
	try:
		building = str(getBuilding(feature))
	except:
		building = None
	return building

def getBuilding(feature):
	dwgName = getDrawing(feature)
	try:
		building = dwgName[:4]
	except:
		building = None
	return building

def getFloor(feature):
	dwgName = getDrawing(feature)
	dwgName.split(os.sep)[0]
	floorNum = dwgName[len(dwgName)-3:]
	floorNum = floorNum.replace(dash,'')
	return floorNum

def getFloorID(feature):
	global namedelimiter
	dwgName = getDrawing(feature)
	floorID = getBuildingID(feature) + namedelimiter + getFloor(feature)
	return floorID

def getSpaceID(feature,attrname):
	global namedelimiter
	spaceID = getFloorID(feature) + namedelimiter + feature.getAttribute(attrname)
	return spaceID

def getSensitivity(feature):
	bldg = getBuilding(feature)
	if bldg in ('1212',  '1053',  '6327'):
		return 'Hidden'
	else:
		return 'None'

def getBuildingFromName(dwg):
	building = ""
	if dwg and len(dwg) > 3:
		building = dwg[:4]
	return building

def getFloorFromName(dwg):
	global namedelimiter
	floor = getBuildingFromName(dwg)  + namedelimiter + getFloorCodeFromName(dwg)
	return floor

def getFloorCodeFromName(dwg):
	dwg = dwg.split('.')[0]
	floorNum = dwg[len(dwg)-3:]
	floorNum = floorNum.replace(dash,'')
	return floorNum.upper()

def getDrawingFromName(dwg):
	dwg.split('.')[0]
	return dwg

def getSensitivityFromName(dwg):
	bldg = getBuildingFromName(dwg)
	if bldg in ('1212',  '1053',  '6327'):
		return 'Hidden'
	else:
		return 'None'

def defaultUserName():
	return "DataLoad"

def timer(input):
	return time.time() - input

def getDBTime():
	return getStrTime(time.localtime())

def getStrTime(timeVal):
	return time.strftime("%Y%m%d%H%M%S", timeVal)

def getTimeFromStr(timeStr):
	return time.strptime(timeStr,"%d/%m/%Y %I:%M:%S %p")

def getAmenityLayer(layer):
	if layer == "MISC-FENCE":
		layer = "Fence"
	else:
		layer = "Other"
	return layer
