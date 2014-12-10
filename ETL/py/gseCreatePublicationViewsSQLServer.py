# gseCreatePublicationViewsSQLServer.py - Create views from ChangeDetection nodes in Playlist, use linked server approach
# ---------------------------------------------------------------------------
# Created on: 20141204 SG
#
# Description: Get values from change detection nodes in xml files and construct/execute view statements
# ---------------------------------------------------------------------------

import os, sys

ospath = os.path.realpath(__file__)
etl = os.sep+'ETL'+os.sep
gsepath = ospath[:ospath.rfind(etl)]
etlpath = gsepath + etl
if (etlpath) not in sys.path:
	sys.path.insert(0, etlpath)
	print etlpath

import arcpy, datetime, xml.dom.minidom, gse, gzSupport

# Script arguments
playlist_xml = arcpy.GetParameterAsText(0) # one playlist xml value.
if playlist_xml == '#' or playlist_xml == None or playlist_xml == '':
    playlist_xml = r"C:\Apps\Gizinta\gseUW\ETL\config\fp\fpFloorArea.xml" # default value

sourceWSName = arcpy.GetParameterAsText(1) # Database name for source Workspace
if sourceWSName == '#' or sourceWSName == None or sourceWSName == '':
    sourceWSName = "UWGISProduction"

targetWSName = arcpy.GetParameterAsText(2) # Database name for target Workspace
if targetWSName == '#' or targetWSName == None or targetWSName == '':
    targetWSName = "campus"

sde = arcpy.GetParameterAsText(3) # sde Connection file for views Workspace
if sde == '#' or sde == None or sde == '':
    sde = os.path.join(gse.sdeConnFolder,"GIS Production.sde")

targetServer = arcpy.GetParameterAsText(4) # remote linked server name
if targetServer == '#' or targetServer == None or targetServer == '':
	targetServer = "ASSUS\SQLEXPRESS"

log = open(os.path.join(etlpath+os.sep+'views'+os.sep,"CreatePublicationViews.sql"),"w")

recreate = arcpy.GetParameterAsText(5)
if recreate == '#' or recreate == None or recreate == '':
    recreate = False
elif recreate.lower() == "true":
    recreate = True
else:
    recreate = False

def main(argv = None):
    # process one or more views
    global log, playlists_xml
    outputSuccess = True # default value, will be set to False if any processing errors returned
    processed = 0
    plist = fixConfigPath(playlist_xml)
    xmlDataDoc = xml.dom.minidom.parse(plist)
    datasets = gzSupport.getXmlElements(plist,"Dataset")
    for dataset in datasets:
        name = dataset.getAttributeNode("name").nodeValue
        try:
            name = dataset.getAttributeNode("targetName").nodeValue # special case to handle multi sources to one target.
        except:
            pass

        printmsg(name)
        changeNodes = dataset.getElementsByTagName("ChangeDetection")
        if len(changeNodes) == 0:
            printmsg("No Change Detection Node")
        else:
            changeNode = changeNodes[0]
            exceptTarget = changeNode.getAttributeNode("exceptPubTargetView").nodeValue
            exceptSource = changeNode.getAttributeNode("exceptPubSourceView").nodeValue
            try:
                targetTable = changeNode.getAttributeNode("exceptPubTargetTable").nodeValue
                sourceTable = changeNode.getAttributeNode("exceptPubSourceTable").nodeValue
            except:
                targetTable = name
                sourceTable = name
                
            fieldStr = changeNode.getAttributeNode("viewFields").nodeValue
            fieldStr = fieldStr.replace(" ","")
            fields = fieldStr.split(",")
            eprodSql = getexceptTargetViewSql(name,exceptTarget,exceptSource,fields,sourceTable,targetTable)
            eSourceSql = getExceptSourceViewSql(name,exceptTarget,exceptSource,fields,sourceTable,targetTable)
            retVal = createView(exceptTarget,eprodSql)
            if retVal == False:
                outputSuccess = False
            createView(exceptSource,eSourceSql)
            if retVal == False:
                outputSuccess = False

    log.close()

def createView(viewName,sql):
    view = os.path.join(sde,viewName)
    printmsg(view)
    sql = sql[sql.find("AS SELECT ")+3:]
    retVal = False
    if arcpy.Exists(view) and recreate == False:
        printmsg("View already exists " + viewName)
    else:
        try:
            arcpy.CreateDatabaseView_management(sde,viewName,sql)
            retVal = True
            msg("-- View created" + view)
        except:
            printmsg("Failed to Create View")
            gzSupport.showTraceback()
            retVal = False
    return retVal

##Create view 
##[dbo].[exFloor_Area] as 
##SELECT *
##FROM OPENQUERY([CPO-SDE.CPO.WASHINGTON.EDU], 'SELECT FLOORID, SHAPE.STAsText() as ShapeText FROM [campus].[dbo].[FLOOR_AREA]') 
##  except
##SELECT [FLOORID],  SHAPE.STAsText() as ShapeText
##  FROM uwgis.[dbo].[pubFloor_Areas]


def getExceptSourceViewSql(dsname,exceptTarget,exceptSource,fields,sourceTable,targetTable):
    viewSql = ""
    viewSql = "CREATE VIEW dbo." + exceptSource + " AS SELECT "
    viewSql += getFieldSql(fields)
    viewSql += " FROM " + "dbo." + sourceTable + " EXCEPT " + \
    "SELECT * from OPENQUERY([" + targetServer + "],'SELECT "
    viewSql += getFieldSql(fields)
    viewSql += " FROM " + targetWSName + ".dbo." + targetTable + "');" + "\nGO"

    msg(viewSql)
    return viewSql

def getexceptTargetViewSql(dsname,exceptTarget,exceptSource,fields,sourceTable,targetTable):
    viewSql = ""
    viewSql = "CREATE VIEW dbo." + exceptTarget + " AS " + \
    "SELECT * from OPENQUERY([" + targetServer + "],'SELECT " 
    viewSql += getFieldSql(fields)
    viewSql += " FROM " + targetWSName + ".dbo." + targetTable + "') EXCEPT "
    viewSql += " SELECT " + getFieldSql(fields)
    viewSql += " FROM " + "dbo." + sourceTable + ";" + "\nGO"

    msg(viewSql)
    return viewSql


def getFieldSql(fields):
    fnum = 0
    fieldSql = ""
    for field in fields:
        if field.upper() == "SHAPE":
            field = "SHAPE.STAsText() AS SHAPE_TEXT"
        fieldSql += field
        if fnum < len(fields) -1:
            fieldSql += ","
        fnum += 1
    return fieldSql

def fixConfigPath(playlist_xml):
    if playlist_xml == None:
        return None
    if not playlist_xml.find(os.sep) > 1:
        playlist_xml = os.path.join(gse.configFolder,playlist_xml)
    return playlist_xml

def printmsg(strVal):
    gzSupport.addMessageLocal(strVal)

def msg(val):
    # simple print message function - want to log messages to screen and log file
    strVal = str(val)
    print val
    global log
    log.write(strVal + "\n")

if __name__ == "__main__":
    main()
