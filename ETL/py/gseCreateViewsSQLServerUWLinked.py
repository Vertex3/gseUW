# gseCreateViewsSQLServer.py - Create views from ChangeDetection nodes in Playlist
# ---------------------------------------------------------------------------
# Created on: 20140115 SG
#
# Description: Get values from change detection nodes in xml files and construct view statements
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
    playlist_xml = "gsePlaylistAll.xml" # default value

stagingWSName = arcpy.GetParameterAsText(1) # Database name for Staging Workspace
if stagingWSName == '#' or stagingWSName == None or stagingWSName == '':
    stagingWSName = "UWCADStaging"

productionWSName = arcpy.GetParameterAsText(2) # Database name for production Workspace
if productionWSName == '#' or productionWSName == None or productionWSName == '':
    productionWSName = "UWCadSde"

sde = arcpy.GetParameterAsText(3) # sde Connection file for views Workspace
if sde == '#' or sde == None or sde == '':
    sde = os.path.join(gse.sdeConnFolder,"GIS Staging.sde")

log = open(os.path.join(sys.path[0],"Create Views.sql"),"w")

recreate = arcpy.GetParameterAsText(4)
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
            exceptProd = changeNode.getAttributeNode("exceptProductionView").nodeValue
            exceptStaging = changeNode.getAttributeNode("exceptStagingView").nodeValue
            fieldStr = changeNode.getAttributeNode("viewFields").nodeValue
            fieldStr = fieldStr.replace(" ","")
            fields = fieldStr.split(",")
            eprodSql = getExceptProdViewSql(name,exceptProd,exceptStaging,fields)
            estagingSql = getExceptStagingViewSql(name,exceptProd,exceptStaging,fields)
            retVal = createView(exceptProd,eprodSql)
            if retVal == False:
                outputSuccess = False
            createView(exceptStaging,estagingSql)
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

def getExceptProdViewSql(dsname,exceptProd,exceptStaging,fields):
    evwname = dsname #+ "_EVW"
    viewSql = ""
    viewSql = "CREATE VIEW dbo." + exceptProd + " AS SELECT "
    viewSql += getFieldSql(fields)
    viewSql += " FROM " + stagingWSName + ".dbo." + evwname + " EXCEPT "
    viewSql += " SELECT " + getFieldSql(fields).replace('SHAPE.STAsText() AS ','')
    viewSql += " FROM OPENQUERY([maps.uw.edu], 'SELECT " + getFieldSql(fields) + " FROM " + productionWSName + ".dbo." + evwname + "');" + "\nGO"

    msg(viewSql)
    return viewSql

def getExceptStagingViewSql(dsname,exceptProd,exceptStaging,fields):
    evwname = dsname #+ "_EVW"
    viewSql = ""
    viewSql = "CREATE VIEW dbo." + exceptStaging + " AS "
    viewSql += " SELECT " + getFieldSql(fields).replace('SHAPE.STAsText() AS ','')
    viewSql += " FROM OPENQUERY([maps.uw.edu], 'SELECT " + getFieldSql(fields) + " FROM " + productionWSName + ".dbo." + evwname + "')"
    viewSql += " EXCEPT " 
    viewSql += " SELECT " + getFieldSql(fields)
    viewSql += " FROM " +  stagingWSName + ".dbo." + evwname + ";" + "\nGO"

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
    global log
    log.write(strVal + "\n")

if __name__ == "__main__":
    main()
