# gseSyncChanges.py - Sync changes from a staging GDB to Production
# ---------------------------------------------------------------------------
# Created on: 2014 01 03
#
# Description: Sync changes from Staging to Production, uses Gizinta Xml files to drive the process
# performs change detection/update if SQL Server views are set up and there is a change node in the Gizinta.
# ---------------------------------------------------------------------------

import os, sys, arcpy, time, datetime, xml.dom.minidom, gzSupport 

ospath = os.path.realpath(__file__)
etl = os.sep+'ETL'+os.sep
gsepath = ospath[:ospath.rfind(etl)]
etlpath = gsepath + etl
pypath = gsepath + "\\ETL\\fme\\"
if (etlpath) not in sys.path:
    sys.path.insert(0, etlpath)
    print etlpath
if (pypath) not in sys.path:
    sys.path.insert(0, pypath)
    print pypath

import gseDrawing, gse

log = None
arg0 = arcpy.GetParameterAsText(0)
playlists = arcpy.GetParameterAsText(1)
GISSource_sde = arcpy.GetParameterAsText(2)
GISTarget_sde = arcpy.GetParameterAsText(3)
successParam = 4

def main(argv = None):
    global log
    # sync from the staging database to prod. The staging database should have rows for the current drawing
    # This process will replace rows in the production database for the floor/drawing, it uses change detection if it is set up in the Gizinta Xml files
    plists = playlists.split(" ")
    arcpy.AddMessage(playlists)
    datasets = []
    for playlist in plists:
        #xmlFile = os.path.join(gse.configFolder,playlist + ".xml")
        datasets = datasets + gzSupport.getXmlElements(playlist,"Dataset")
    gzSupport.workspace = GISTarget_sde
    retVal = True
    tm = time.strftime("%Y%m%d%H%M%S")
    dwg = None
    flr = None
    if arg0.find(os.sep) > -1:
        dwg = arg0#[inputDrawing.rfind(os.sep)+1:]
        if dwg.lower().endswith('.dwg'):
            dwg = dwg[:len(dwg)-4]
        dsname = dwg[dwg.rfind(os.sep)+1:].lower().replace('.dwg','')
    elif arg0.upper() == "ALL":
        dwg="ALL"
        dsname = "PublicationAll"
    else:
        dwg = arg0
        dsname = dwg
    log = open(gse.pyLogFolder + 'gseSyncChanges_' + dsname + '_' + tm + '.log','w')
    processed = []
    for dataset in datasets:
        name = dataset.getAttributeNode("name").nodeValue
        try:
            name = dataset.getAttributeNode("targetName").nodeValue # special case to handle multi sources to one target.
        except:
            pass
        if name not in processed:
            changeNode = dataset.getElementsByTagName("ChangeDetection")[0]
            if changeNode != None and changeNode != []:
                try:
                    processed.index(name)
                except:
                    processed.append(name)
                # if there is a change node then do change detection using views
                arcpy.env.workspace = GISSource_sde
                desc = arcpy.Describe(os.path.join(GISTarget_sde,name))
                if dwg == 'ALL':
                    replaceAllForDataset(dwg,dataset,name,changeNode)
                else:
                    replaceDwgForDataset(dwg,dataset,name,changeNode)

            else:
                # if there is no change node then replace everything for a floor
                idField = "FLOORID"
                whereClause = buildViewWhereClause(idField,dwg)
                desc = arcpy.Describe(sourceDataset)
                view = "tempCount"
                gzSupport.workspace = GISSource_sde
                arcpy.env.workspace = GISSource_sde
                gzSupport.makeView(desc.DataElementType,GISSource_sde,sourceName,view,whereClause,[])
                res = arcpy.GetCount_management(view)
                count = int(res.getOutput(0))
                if(count > 0):
                    msg("Replacing rows for " + name + ", " + str(count) + " rows")
                    retcode = gzSupport.deleteRows(GISTarget_sde,targetName,whereClause)
                    retcode = gzSupport.appendRows(sourceDataset,targetDataset,whereClause)
                else:
                    msg("No rows in source database to update for " + targetName)
                del view
    #msg(processed)
    arcpy.SetParameter(successParam,retVal)

def replaceDwgForDataset(dwg,dataset,name,changeNode):
    retVal = True
    sourceName = name
    targetName = name
    sourceDataset = os.path.join(GISSource_sde,name)
    targetDataset = os.path.join(GISTarget_sde,name)
    idField = changeNode.getAttributeNode("idField").nodeValue
    desc = arcpy.Describe(sourceDataset)    
    try:
        viewIdField = changeNode.getAttributeNode("viewIdField").nodeValue
        gzSupport.addMessage("Using Change detection id field " + viewIdField)
    except:
        viewIdField = "floorid" # the default
        gzSupport.addMessage("Using default id field " + viewIdField)

    whereClause = buildViewWhereClause(viewIdField,dwg)
    adds = getChanges(changeNode,"exceptProductionView",GISSource_sde,whereClause,idField)
    deletes = getChanges(changeNode,"exceptStagingView",GISSource_sde,whereClause,idField)

    if len(deletes) > 0:
        deleteExpr = getDeltaWhereClause(desc,idField,deletes)
        arcpy.env.workspace = GISTarget_sde
        retcode = gzSupport.deleteRows(GISTarget_sde,targetName,deleteExpr)
        if retcode == True:
            msg(str(len(deletes)) + " Rows deleted in prod")
        else:
            msg("Failed to delete rows")
            retVal = False
    else:
        msg("No changed rows found to delete")

    if len(adds) > 0 and retVal == True:
        addExpr = getDeltaWhereClause(desc,idField,adds)
        arcpy.env.workspace = GISTarget_sde
        gzSupport.workspace = GISTarget_sde
        retcode = gzSupport.appendRows(sourceDataset,targetDataset,addExpr)
        if retcode == True:
            msg(str(len(adds)) + " Rows appended in prod for " + targetName)
        else:
            msg("Failed to append rows for " + targetName)
            retVal = False
    else:
        msg("No changed rows found to add for " + targetName)
    del adds
    del deletes
    return retVal

def replaceAllForDataset(dwg,dataset,name,changeNode):
    retVal = True
    sourceName = name
    targetName = name
    sourceDataset = name
    targetDataset = name

    try: # override defaults
        targetName = changeNode.getAttributeNode("exceptPubTargetTable").nodeValue
        sourceName = changeNode.getAttributeNode("exceptPubSourceTable").nodeValue
        try:
            dbname = changeNode.getAttributeNode("exceptPubDatabasePrefix").nodeValue
            targetName = dbname + targetName
            targetDataset = os.path.join(GISTarget_sde,targetName) # dname like "campus.dbo."
        except:
            targetDataset = os.path.join(GISTarget_sde,targetName)
        sourceDataset = os.path.join(GISSource_sde,sourceName)
    except:
        pass
    idField = changeNode.getAttributeNode("idField").nodeValue
    #desc = arcpy.Describe(sourceDataset)    
    try:
        viewIdField = changeNode.getAttributeNode("viewIdField").nodeValue
        gzSupport.addMessage("Using Change detection id field " + viewIdField)
    except:
        viewIdField = "floorid" # the default
        gzSupport.addMessage("Using default id field " + viewIdField)

    deletes = getChanges(changeNode,"exceptPubTargetView",GISSource_sde,"",idField)
    if len(deletes) > 0:
        desc = arcpy.Describe(targetDataset)    
        deleteExpr = getDeltaWhereClause(desc,idField,deletes)
        #    sql = '"' + idField + '" =' + "'" + delete + "'"
        sql_statement = 'DELETE FROM ' + targetName + " WHERE " + deleteExpr
        sde_conn = arcpy.ArcSDESQLExecute(GISTarget_sde)
        try:
            # Pass the SQL statement to the database.
            sde_conn.startTransaction()    
            sde_return = sde_conn.execute(sql_statement)
            sde_conn.commitTransaction()
        except Exception as err:
            print(err)
            sde_return = False        

### try an insert cursor...
##            ***************
    arcpy.env.workspace = GISSource_sde
    gzSupport.workspace = GISSource_sde
    vw = changeNode.getAttributeNode("exceptPubSourceView").nodeValue
    adds = getAllRows(vw,idField)
    if len(adds) > 0 and retVal == True:
        #addExpr = getDeltaWhereClause(desc,idField,adds)
        sql =  idField + ' IN (SELECT ' +  idField + ' FROM ' + vw + ')'
        #retcode = arcpy.Append_management([GISSource_sde + os.sep + 'pFloorAppendSource'],targetDataset, "NO_TEST","","")
        #gzSupport.appendRows(GISSource_sde + os.sep + 'pFloorAppendSource',targetDataset,'')
        retcode = gzSupport.appendRows(sourceDataset,targetDataset,sql)
        # arcpy.Append_management(sourceDataset,targetDataset,"NO_TEST")
        msg("Rows appended in prod for " + targetName)
    return retVal

##    deletes = getChanges(changeNode,"exceptPubTargetView",GISSource_sde,whereClause,idField)
##    if len(deletes) > 0:
##        deleteExpr = getDeltaWhereClause(desc,idField,deletes)
##        arcpy.env.workspace = GISTarget_sde
##        retcode = gzSupport.deleteRows(GISTarget_sde,targetName,deleteExpr)
##        if retcode == True:
##            msg(str(len(deletes)) + " Rows deleted in prod")
##        else:
##            msg("Failed to delete rows")
##            retVal = False
##    else:
##        msg("No changed rows found to delete")

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

def buildViewWhereClause(viewIdField,dwg):
    # build a where clause based on the idfield
    if dwg.find(os.sep) > -1:
        # this is a drawing
        if viewIdField.upper() == "SOURCEDWG":
            drawingID = gseDrawing.getDrawingFromName(dwg[dwg.rfind(os.sep)+1:])
            whereClause = viewIdField + " = '" + drawingID  + "'"
        elif viewIdField.upper() == "FLOORID":
            floorID = gseDrawing.getFloorIDFromPath(dwg)
            whereClause = viewIdField + " = '" + floorID  + "'"
        elif viewIdField.upper() == "BUILDINGID":
            buildingID = gseDrawing.getBuildingIDFromPath(dwg)
            whereClause = viewIdField + " = '" + buildingID  + "'"
        else:
            raise Exception("Could not build a view where clause for " + viewIdField)
    elif dwg.upper() == "ALL":
        whereClause = ""
    else:
        # this is a floor value
        if viewIdField.upper() == "FLOORID":
            floorID = gseDrawing.getFloorFromName(dwg)
            whereClause = viewIdField + " = '" + floorID  + "'"
        elif viewIdField.upper() == "BUILDINGID":
            buildingID = gseDrawing.getBuildingFromName(dwg)
            whereClause = viewIdField + " = '" + buildingID  + "'"
        else:
            raise Exception("Could not build a view where clause for " + viewIdField)

    arcpy.AddMessage( whereClause)
    return whereClause

def getChangedRows(view,idField,whereClause):
    # get the actual list of idFields by row
    deltas = []
    msg("Getting changed rows for " + view[view.rfind(os.sep)+1:])
    try:
        with arcpy.da.SearchCursor(view, idField,whereClause) as cursor:
            for row in cursor:
                for item in row:
                    deltas.append(item)
        del cursor
    except:
        print "No deltas found"
    return deltas

def getAllRows(view,idField):
    # get the actual list of idFields by row
    deltas = []
    with arcpy.da.SearchCursor(view, idField) as cursor:
        for row in cursor:
            for item in row:
                deltas.append(item)
    del cursor
    return deltas


def getDeltaWhereClause(desc,idField,theList):
    # build a where clause from the list of IDs
    ftype = "STRING"
    try:
        for field in desc.Fields:
            if field.name.upper() == idField.upper():
                ftype = field.type.upper()
    except:
        ftype = 'STRING'
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
    gzSupport.addMessage(whereClause)
    return whereClause

def msg(val):
    #write messages
    global log
    strVal = str(val)
    print strVal
    if log != None:
        log.write(strVal + "\n")
    gzSupport.addMessage(strVal)

def deleteRows(fClassName,expr):
    # delete rows in feature class
    arcpy.env.workspace = GISSource_sde # keep setting the workspace to force load activities
    tableName = GISTarget_sde + os.sep + fClassName
    retcode = False
    if arcpy.Exists(tableName):
        viewName = fClassName[fClassName.rfind('.')+1:] + "_View"
        if arcpy.Exists(viewName):
            arcpy.Delete_management(viewName) # delete view if it exists

        arcpy.MakeTableView_management(tableName, viewName ,  expr)
        arcpy.DeleteRows_management(viewName)
        addMessageLocal("Existing " + fClassName + " rows deleted ")
        try:
            arcpy.Delete_management(viewName) # delete view if it exists
        except:
            addMessageLocal("Could not delete view, continuing...")
        retcode = True
    else:
        addMessageLocal( "Feature class " + fClassName + " does not exist, skipping " + fClassName)
        retcode = False
    return retcode


if __name__ == "__main__":
    main()
