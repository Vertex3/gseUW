# gseSyncChanges.py - Sync changes from a staging GDB to Production
# ---------------------------------------------------------------------------
# Created on: 2014 01 03
#
# Description: Sync changes from Staging to Production, uses Gizinta Xml files to drive the process
# performs change detection/update if SQL Server views are set up and there is a change node in the Gizinta.
# updated May 2015 to allow direct calling from other scripts in addition to arcpy method.
# ---------------------------------------------------------------------------

import os, sys, arcpy, time, datetime, xml.dom.minidom, gzSupport 

ospath = os.path.realpath(__file__)
etl = os.sep+'ETL'+os.sep
gsepath = ospath[:ospath.rfind(etl)]
etlpath = gsepath + etl
pypath = gsepath + "\\ETL\\fme\\"
if (etlpath) not in sys.path:
    sys.path.insert(0, etlpath)
    # print etlpath
if (pypath) not in sys.path:
    sys.path.insert(0, pypath)
    # print pypath

import gseDrawing, gse

log = None
inputDrawing = arcpy.GetParameterAsText(0)
playlists = arcpy.GetParameterAsText(1)
GISStagingDefault_sde = arcpy.GetParameterAsText(2)
GISProdDefault_sde = arcpy.GetParameterAsText(3)
successParam = 4
debug = False

def main(argv = None):
    global log
    tm = time.strftime("%Y%m%d%H%M%S")
    drawingID = inputDrawing.split('.')[0]
    log = open(gse.pyLogFolder + 'gseSyncChanges_' + drawingID + '_' + tm + '.log','w')
    retVal = sync(inputDrawing,playlists,GISStagingDefault_sde,GISProdDefault_sde,log)
    arcpy.SetParameter(successParam,retVal)

    log.close()

def sync(inputDrawing,playlists,GISStagingDefault_sde,GISProdDefault_sde,logfile):
    
    # sync from the staging database to prod. The staging database should have rows for the current drawing
    # This process will replace rows in the production database for the floor/drawing, it uses change detection if it is set up in the Gizinta Xml files
    global log
    log = logfile
    plists = playlists.split(" ")
    arcpy.AddMessage(playlists)
    datasets = []
    for playlist in plists:
        #xmlFile = os.path.join(gse.configFolder,playlist + ".xml")
        datasets = datasets + gzSupport.getXmlElements(playlist,"Dataset")
    gzSupport.workspace = GISProdDefault_sde
    retVal = True
    if inputDrawing == '*':
        dwg = '*'
        drawingID = 'all'
    else:
        dwg = inputDrawing[inputDrawing.rfind(os.sep)+1:]
        drawingID = gseDrawing.getDrawingFromName(dwg)
    processed = []
    for dataset in datasets:
        name = dataset.getAttributeNode("name").nodeValue
        try:
            name = dataset.getAttributeNode("targetName").nodeValue # special case to handle multi sources to one target.
        except:
            pass
        if name not in processed:
            sourceDataset = os.path.join(GISStagingDefault_sde,name)
            targetDataset = os.path.join(GISProdDefault_sde,name)
            changeNode = dataset.getElementsByTagName("ChangeDetection")[0]
            if changeNode != None and changeNode != []:
                try:
                    processed.index(name)
                except:
                    processed.append(name)
                # if there is a change node then do change detection using views
                arcpy.env.workspace = GISStagingDefault_sde
                desc = arcpy.Describe(os.path.join(GISProdDefault_sde,name))

                idField = changeNode.getAttributeNode("idField").nodeValue
                try:
                    viewIdField = changeNode.getAttributeNode("viewIdField").nodeValue
                    if debug == True:
                        msg("Using Change detection id field " + viewIdField)
                except:
                    viewIdField = "floorid" # the default
                    if inputDrawing != '*':
                        if debug == True:
                            msg("Using default id field " + viewIdField)
                whereClause = buildViewWhereClause(viewIdField,inputDrawing)
                adds = getChanges(changeNode,"exceptProductionView",GISStagingDefault_sde,whereClause,idField)
                deletes = getChanges(changeNode,"exceptStagingView",GISStagingDefault_sde,whereClause,idField)

                if len(deletes) > 0:
                    deleteExpr = getDeltaWhereClause(desc,idField,deletes)
                    arcpy.env.workspace = GISProdDefault_sde
                    retcode = gzSupport.deleteRows(GISProdDefault_sde,name,deleteExpr)
                    if retcode == True:
                        msg(str(len(deletes)) + " Rows deleted in prod for " + name)
                    else:
                        msg("Failed to delete rows")
                        retVal = False
                #else:
                #    msg("No changed rows found to delete")

                if len(adds) > 0:
                    addExpr = getDeltaWhereClause(desc,idField,adds)
                    arcpy.env.workspace = GISProdDefault_sde
                    gzSupport.workspace = GISProdDefault_sde
                    retcode = gzSupport.appendRows(sourceDataset,targetDataset,addExpr)
                    if retcode == True:
                        msg(str(len(adds)) + " Rows appended in prod for " + name)
                    else:
                        msg("Failed to append rows for " + name)
                        retVal = False
                #else:
                #    msg("No changed rows found to add for " + name)
                del adds
                del deletes

            else:
                # if there is no change node then replace everything for a floor
                if inputDrawing == '*':
                    idField = ''
                else:
                    idField = "FLOORID"
                whereClause = buildViewWhereClause(idField,inputDrawing)
                desc = arcpy.Describe(sourceDataset)
                view = "tempCount"
                gzSupport.workspace = GISStagingDefault_sde
                arcpy.env.workspace = GISStagingDefault_sde
                gzSupport.makeView(desc.DataElementType,GISStagingDefault_sde,name,view,whereClause,[])
                res = arcpy.GetCount_management(view)
                count = int(res.getOutput(0))
                if(count > 0):
                    msg("Replacing rows for " + name + ", " + str(count) + " rows")
                    retcode = gzSupport.deleteRows(GISProdDefault_sde,name,whereClause)
                    retcode = gzSupport.appendRows(sourceDataset,targetDataset,whereClause)
                else:
                    msg("No rows in source database to update for " + name)
                del view
    #msg(processed)
    return retVal

def getChanges(changeNode,viewAttribute,sde,whereClause,idField):
    # get the list of changed rows - just the IDs
    exceptViewName = changeNode.getAttributeNode(viewAttribute).nodeValue
    view = os.path.join(sde,exceptViewName)
    #try:
    #    arcpy.AnalyzeDatasets_management(sde,"NO_SYSTEM",exceptViewName,"ANALYZE_BASE")
    #except:
    #    pass
    diffs = getChangedRows(view,idField,whereClause)
    del view

    return diffs

def buildViewWhereClause(viewIdField,inputDrawing):
    # build a where clause based on the idfield
    dwg = inputDrawing[inputDrawing.rfind(os.sep)+1:]
    if inputDrawing == '*':
        whereClause = ''
    elif viewIdField.upper() == "SOURCEDWG":
        drawingID = gseDrawing.getDrawingFromName(dwg)
        whereClause = viewIdField + " = '" + drawingID  + "'"
    elif viewIdField.upper() == "FLOORID":
        floorID = gseDrawing.getFloorIDFromPath(inputDrawing)
        whereClause = viewIdField + " = '" + floorID  + "'"
    elif viewIdField.upper() == "BUILDINGID":
        buildingID = gseDrawing.getBuildingIDFromPath(inputDrawing)
        whereClause = viewIdField + " = '" + buildingID  + "'"
    else:
        raise Exception("Could not build a view where clause for " + viewIdField)

    arcpy.AddMessage( whereClause)
    return whereClause

def getChangedRows(view,idField,whereClause):
    # get the actual list of idFields by row
    deltas = []
    if debug == True: 
        msg("Getting changed rows for " + view[view.rfind(os.sep)+1:])
    with arcpy.da.SearchCursor(view, idField,whereClause) as cursor:
        for row in cursor:
            for item in row:
                deltas.append(item)
    del cursor
    return deltas

def getDeltaWhereClause(desc,idField,theList):
    # build a where clause from the list of IDs
    ftype = "STRING"
    for field in desc.Fields:
        if field.name.upper() == idField.upper():
            ftype = field.type.upper()
    hasNone = False
    num = 0
    strList = '('
    for item in theList:
        if strList != '(' and strList.endswith(",") == False and num < len(theList):
            strList = strList + ","
        if item == None or item == 'None' or str(item) == '':
            hasNone = True
        elif item == str(item) and ftype == "STRING":
            strItem = "'" + str(item) + "'"
            if strList.find(strItem) == -1:
                strList = strList + strItem
        else:
            if strList.find(str(item)+",") == -1:
                strList = strList + str(item)
        num += 1
    if strList.endswith(","):
        strList = strList[:strList.rfind(",")]
    strList = strList + ')'
    if strList.find('()') == -1: # empty list needs a value ***
        whereClause = '\"' + idField + '\" in ' + strList
        if hasNone == True:
            whereClause = whereClause + " or \"" + idField + "\" IS NULL"
    else:
        whereClause = ''
    if debug == True:
        msg(whereClause)
    return whereClause

def msg(val):
    #write messages
    global log
    strVal = str(val)
    log.write(strVal + "\n")
    arcpy.AddMessage(strVal)

if __name__ == "__main__":
    main()
