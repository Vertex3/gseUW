# gzSupport - Common supporting functions
# Feb 2013 SG
# ---------------------------------------------------------------------------
# Copyright 2012-2014 Vertex3 Inc
# This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

import sys,os,traceback,xml.dom.minidom,time,datetime,gc,arcpy,myGizinta
from xml.dom.minidom import Document

debug = False
log = None # must be set by calling program with an open
logs = [] # list of log files for nested calls in gizinta scripts
startTime = time.localtime() # start time for a script
ignoreErrors = False # default, can override in script
loadTime = "20130101 12:00:00" # default, override in script
logTableName = "gzLog" # status of processing logged here
workspace = "Gizinta.gdb" # default, override in script
errorTableName = "gzError" # errors logged here
sourceIDField = "a" # id field name in source dataset
sourceNameField = "b" # source file name - used to look for errors in original data
successParameterNumber = 3 # parameter number to set at end of script to indicate success of the program
maxErrorCount = 100 # max errors before a script will stop
logFileName = "gz.log"
dirName = os.path.dirname( os.path.realpath( __file__) )

# helper functions
def startLog(*args):
    # gz functions write to a log file. Use this function to open it
    gc.enable()
    global log, logs

    global startTime
    global loadTime
    startTime = timer(0)
    loadTime = getDBTime()

    openLog(args)
    addMessageLocal(loadTime)
    setupLogTables()

def openLog(*args):
    # open the log file for writing
    global log,logs
    try: 
        logfile = args[0][0] # get the first arg if a filename has been passed
    except:
        logfile = getLogFileName()
    try: # append if the file already has been opened, otherwise write a new one
        logs.index(logfile)
        log = open(logfile, "a+") # if found
    except: 
        log = open(logfile, "w+") # if new
    logs.append(logfile)
    logFileName = logfile

def closeLog(*args):
    # close the log file, write some messages and clean up
    global log,logs,logFileName
    endTime = timer(0)
    addMessageLocal(getDBTime())
    addMessageLocal("Processing time: " + ' (' + str(int(timer(startTime)/60)) + 'm ' + str(int(timer(startTime) % 60)) + 's)')
    if log != None:
        log.close()
    logs.pop()
    if len(logs) > 0:
        logFileName = logs[len(logs)-1]       
        log = open(logFileName, "a+") # open the last log file and append
    cleanupGarbage()

def getLogFileName():
    # get the name of the log file to write
    global logFileName, dirName
    fName = ""
    try:
        if sys.argv == "" or sys.argv == None:
            fName = logFileName # can set this if there are no params or a custom script that uses gz logging
        else:
            fName = sys.argv[0][:sys.argv[0].rfind(".py")] + ".log" # make it a .log file
            fName = fName.replace(os.sep+"arcpy"+os.sep,os.sep+"log"+os.sep) # put it in ../log folder.
    except:
        #addError("Could not get log file name from " + str(sys.argv))
        fName = os.path.join(dirName,'gz.log')
        #print sys.argv
    logFileName = fName
    return fName

def timer(input):
    # time difference
    return time.time() - input

def getDBTime():
    # format time val for db insert
    return getStrTime(time.localtime())

def getStrTime(timeVal):
    # get string time for a time value
    return time.strftime("%Y-%m-%d %H:%M:%S", timeVal)

def getTimeFromStr(timeStr):
    # get timeVal from a string
    return time.strptime(timeStr,"%d/%m/%Y %I:%M:%S %p")

def addMessage(val):
    # write a message to the screen and the log file
    global log
    try:
        if sys.stdin.isatty():
            arcpy.AddMessage(str(val))
            print str(val)
        else:
            arcpy.AddMessage(str(val))
    except:
        arcpy.AddMessage(str(val))
    logMessage(val)

def addMessageLocal(val):
    # write a message to the screen and the log file
    global log
    try:
        if sys.stdin.isatty():
            print(str(val))
        else:
            arcpy.AddMessage(str(val))
    except:
        arcpy.AddMessage(str(val))
    logMessage(val)

def addError(val):
    # add an error to the screen output and log file
    global log
    arcpy.AddMessage("Error: " + str(val))
    logMessage(val)

def logMessage(val):
    # write a message to the log file
    try:
        if log != []:
            log.write(str(val) + "\n")
    except:
        try:
            openLog()
            log.write(str(val) + "\n")
        except:
            msg = "Unable to write to log file " + getLogFileName()
            arcpy.AddMessage(msg)
            print msg

def strToBool(s):
    # return a boolean for values like 'true'
    return s.lower() in ("yes", "true", "t", "1")

def showTraceback():
    # get the traceback object and print it out
    tBack = sys.exc_info()[2]
    # tbinfo contains the line number that the code failed on and the code from that line
    tbinfo = traceback.format_tb(tBack)
    tbStr = ""
    for i in range(0,len(tbinfo)):
        tbStr = tbStr + str(tbinfo[i])
    # concatenate information together concerning the error into a message string
    pymsg = "Python Error messages:\nTraceback Info:\n" + tbStr + "Error Info:    " + str(sys.exc_type)+ ": " + str(sys.exc_value) + "\n"
    # print messages for use in Python/PythonWin
    addError(pymsg)

def getDatasets(xmlFile):
    # get the list of datasets from XML doc
    dsTypes = ["MapLayer","CADDataset","GDBDataset","Dataset"]
    for atype in dsTypes:
        datasets = getXmlElements(xmlFile,atype)
        if datasets != []:
            return datasets

def getAllDatasets(xmlFile):
    # get the list of datasets from XML doc
    dsTypes = ["MapLayer","CADDataset","GDBDataset","Dataset"]
    datasets = []
    for atype in dsTypes:
        ds = getXmlElements(xmlFile,atype)
        if ds != [] and ds != None:
            datasets = datasets + ds
    return datasets


def collect_text(node):
    # "A function that collects text inside 'node', returning that text."
    s = ""
    for child_node in node.childNodes:
        if child_node.nodeType == child_node.TEXT_NODE:
            s += child_node.nodeValue
        else:
            s += collect_text(child_node)
    return s

def getNodeValue(xmlDoc,nodeName):
    # get an xml node value
    node = xmlDoc.getElementsByTagName(nodeName)
    try:
        str = collect_text(node.item(0))
    except:
        str = ""
    return str

def getArcpyErrorMessage():
    # parse out python exception content into the part after the "." - the message
    parts = str(sys.exc_value).split(".")
    if len(parts) == 1:
        retVal = parts[0]
    else:
        retVal = parts[1][1:] # first char after dot always appears to be newline char
    return retVal

def testSchemaLock(dataset):
    # test if a schema lock is possible
    res = arcpy.TestSchemaLock(dataset)
    return res

def cleanupGarbage():
    # cleanup python garbage
    for obj in gc.garbage:
        del obj # remove local reference so the node can be deleted
    del gc.garbage[:]
    for i in range(2):
        if debug == True:
            addMessageLocal('cleanup pass: ' + str(i))
        n = gc.collect()
        if debug == True:
            print('Unreachable objects:' + str(n))
            print('Remaining Garbage:' + str(gc.garbage))

def cleanup(inWorkspace):
    # general cleanup function
    cleanupGarbage()
    arcpy.ClearWorkspaceCache_management(inWorkspace)

def getWorkspacePath(path):
    # get the path of the workspace
    workspace = arcpy.Describe(path) # preset
    dirName = os.path.dirname(path)
    if dirName and arcpy.Exists(dirName):
        dataset = arcpy.Describe(dirName)
    try:
        if dataset and dataset.datasetType == "FeatureDataset":
            # strip off last value to get workspace
            dirs = dirName.split(os.sep)
            dirs.pop()
            datasetStr = os.sep.join(dirs)
            workspace = arcpy.Describe(datasetStr) # use the next level up from feature dataset
    except:
        workspace = dataset # use the first dataset, datasetType fails on workspace values

    return workspace

def getCleanName(nameVal):
    # strip leading database prefix values
    cleanName = nameVal
    dotCount = nameVal.count(".")
    if dotCount > 0:
        cleanName = nameVal.split(".")[dotCount]
    return cleanName

def makeFeatureView(workspace,sourceFC,viewName,whereClause,xmlFields):
    # make a feature view using the where clause
    if arcpy.Exists(sourceFC):
        if arcpy.Exists(viewName):
            arcpy.Delete_management(viewName) # delete view if it exists
        desc = arcpy.Describe(sourceFC)
        fields = arcpy.ListFields(sourceFC)
        fStr = getViewString(fields,xmlFields)
        arcpy.MakeFeatureLayer_management(sourceFC, viewName , whereClause, workspace, fStr)
        #addMessageLocal("Feature Layer " + viewName + " created for " + str(whereClause))
    else:
        addError(sourceFC + " does not exist, exiting")

    if not arcpy.Exists(viewName):
        exit(-1)
    return(viewName)

def makeTableView(workspace,sourceTable,viewName,whereClause,xmlField):
    # make a table view using the where clause
    if arcpy.Exists(sourceTable):
        if arcpy.Exists(viewName):
            arcpy.Delete_management(viewName) # delete view if it exists
        desc = arcpy.Describe(sourceTable)
        fields = arcpy.ListFields(sourceTable)
        fStr = getViewString(fields,xmlField)
        arcpy.MakeTableView_management(sourceTable, viewName , whereClause, workspace, fStr)
    else:
        addError(sourceTable + " does not exist, exiting")

    if not arcpy.Exists(viewName):
        exit(-1)
    return(viewName)

def makeFeatureViewForLayer(workspace,sourceLayer,viewName,whereClause,xmlFields):
    # Process: Make Feature Layers - drop prefixes as needed
    if arcpy.Exists(sourceLayer):
        if arcpy.Exists(viewName):
            arcpy.Delete_management(viewName) # delete view if it exists

        desc = arcpy.Describe(sourceLayer)
        fields = arcpy.ListFields(sourceLayer)
        fLayerStr = getViewString(fields,xmlFields)
        arcpy.MakeFeatureLayer_management(sourceLayer, viewName, whereClause, workspace,fLayerStr)
    else:
        addError(sourceFC + " does not exist, exiting")

    if not arcpy.Exists(viewName):
        exit(-1)
    return(viewName)

def getViewString(fields,xmlFields):
    # get the string for creating a view
    viewStr = ""
    for field in fields: # drop any field prefix from the source layer (happens with map joins)
        thisFieldName = field.name[field.name.rfind(".")+1:]
        for xmlField in xmlFields:
            sourcename = getNodeValue(xmlField,"SourceName")
            if sourcename == thisFieldName:
                targetname = getNodeValue(xmlField,"TargetName")
                if sourcename != targetname and sourcename.upper() == targetname.upper():
                    # this is a special case where the source name is different case but the same string as the target
                    # need to create table so that the name matches the target name so there is no conflict later
                    thisFieldName = targetname

        thisFieldStr = field.name + " " + thisFieldName + " VISIBLE NONE;"
        viewStr += thisFieldStr

    return viewStr

def getWhereClause(dataset):
    whereClause = ''
    try:
        whereClause = getNodeValue(dataset,"WhereClause")
    except:
        whereClause = ''
    if whereClause != '' and whereClause != '' and whereClause != None:
        addMessageLocal("Where \"" + whereClause + "\"")
    else:
        addMessageLocal("No Where Clause")

    return whereClause

def deleteRows(workspace,fClassName,expr):
    # delete rows in feature class
    arcpy.env.workspace = workspace # keep setting the workspace to force load activities
    tableName = workspace + os.sep + fClassName
    if debug:
        addMessageLocal(tableName)
    retcode = False
    if arcpy.Exists(tableName):
        viewName = fClassName + "_View"
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

def appendRows(sourceTable,targetTable,expr):
    # append rows in feature class with a where clause
    workspace = sourceTable[:sourceTable.rfind("\\")]
    arcpy.env.Workspace = workspace
    if debug:
        addMessageLocal(tableName)
    retcode = False
    targTable = targetTable[targetTable.rfind("\\")+1:]
    sTable = sourceTable[sourceTable.rfind("\\")+1:]
    viewName = sTable + "_View"
    desc = arcpy.Describe(targetTable)
    viewName = makeView(desc.dataElementType,workspace,sourceTable,viewName,expr,[])
    arcpy.Append_management(viewName,targetTable,"NO_TEST")
    addMessageLocal(targTable + " rows Appended ")
    retcode = True

    return retcode

def logDatasetProcess(loadName,dataset,status):
    # log process status for a function after completion
    logTable = os.path.join(workspace,logTableName)
    retcode = False
    if not arcpy.Exists(logTable):
        addMessageLocal(logTable + " does not exist, exiting")
        retcode = False
    else:
        procName = sys.argv[0][sys.argv[0].rfind(os.sep)+1:sys.argv[0].find(".py")]
        userName = os.getenv('USERNAME')

        insertCursor = arcpy.InsertCursor(logTable)
        if debug:
            addMessageLocal("Inserting into " +  logTable)

        try:
            insRow = insertCursor.newRow()
            insRow.setValue("PROCNAME",procName)
            insRow.setValue("LOADNAME",loadName)
            insRow.setValue("DATASET",dataset)
            insRow.setValue("COMPLETED",int(status))
            insRow.setValue("LOADUSER",userName)
            insRow.setValue("LOADTIME",getDBTime())
            insRow.setValue("ACTIVEFLAG","Y")
            insertCursor.insertRow(insRow)
            addMessageLocal("Row inserted into Log table")
            retcode = True
        except:
            showTraceback()
            message = "Unable to insert row into log table\n"
            message += "PROCNAME:" + str(procName) + "\n"
            message += "LOADNAME:" + str(loadName) + "\n"
            message += "DATASET:" + str(dataset) + "\n"
            message += "COMPLETED:" + str(status) + "\n"
            message += "LOADUSER:" + str(userName) + "\n"
            message += "LOADTIME:" + str(getDBTime()) + "\n"
            message += "ACTIVEFLAG:" + "Y"
            addMessageLocal(message)
        del insertCursor
    return retcode


def logProcessError(sourceName,sourceIDField,sourceIDValue,dataset,reason):
    # log a specific error that ocurred in the processing
    errTable = os.path.join(workspace,errorTableName)
    retcode = False
    if not arcpy.Exists(errTable):
        addMessageLocal(errTable + " does not exist, exiting")
        retcode = False
    else:
        procName = sys.argv[0][sys.argv[0].rfind(os.sep)+1:sys.argv[0].find(".py")]
        sourceName = sourceName[sourceName.rfind(os.sep)+1:]
        userName = os.getenv('USERNAME')

        insertCursor = arcpy.InsertCursor(errTable)
        if debug:
            addMessageLocal("Inserting into " +  errTable)

        insRow = insertCursor.newRow()
        insRow.setValue("PROCNAME",procName)
        insRow.setValue("SOURCENAME",sourceName)
        insRow.setValue("SRCIDFIELD",sourceIDField)
        insRow.setValue("SRCIDVAL",str(sourceIDValue))
        insRow.setValue("DATASET",dataset)
        insRow.setValue("REASON",reason)
        insRow.setValue("ERRUSER",userName)
        insRow.setValue("ERRTIME",getDBTime())
        insRow.setValue("ACTIVEFLAG","Y")
        try:
            insertCursor.insertRow(insRow)
            addMessageLocal("Row inserted into Error table")
            retcode = True
        except:
            showTraceback()
            message = "Unable to insert row into error table\n"
            message += "SOURCENAME:" + str(sourceName) + "\n"
            message += "SRCIDFIELD:" + str(sourceIDField) + "\n"
            message += "SRCIDVAL:" + str(sourceIDValue) + "\n"
            message += "DATASET:" + str(dataset) + "\n"
            message += "REASON:" + str(reason) + "\n"
            message += "ERRUSER:" + str(userName) + "\n"
            message += "ERRTIME:" + str(getDBTime()) + "\n"
            message += "ACTIVEFLAG:" + "Y"
            addMessageLocal(message)

        del insertCursor

    return retcode


def deleteLogRows(mode,tableName):
    # delete rows from the log tables
    table = os.path.join(workspace,tableName)
    if mode.upper() == "ARCHIVE":
        try:
            arcpy.CalculateField_management(table,"ACTIVEFLAG","N")
            msg = "Existing rows flagged as inactive: "
        except:
            msg = "Error: Unable to flag rows as inactive: "

    else:
        try:
            arcpy.DeleteRows_management(table)
            msg = "Existing rows deleted: "
        except:
            msg = "Error: Unable to delete existing rows: "
    addMessageLocal(msg + tableName)

def deleteLogTableRows(mode):
    # delete from gzlog
    deleteLogRows(mode,logTableName)

def deleteErrorTableRows(mode):
    # delete from gzError
    deleteLogRows(mode,errorTableName)

def createVersion(sde,defaultVersion,versionName):
    # create a version in the database
    retcode = False
    loc = versionName.find(".")
    if loc > -1:
        versionName = versionName.split(".")[1]
    addMessageLocal("Creating Version: " + versionName)
    try:
        retcode = arcpy.CreateVersion_management(sde, defaultVersion, versionName, "PRIVATE")
        if debug == True:
            addMessageLocal("create version " + str(retcode))
    except:
        if debug == True:
            addMessageLocal("create version exception: " + str(retcode))
        retcode = False # have to assume this means it exists already
        try: # but try to change it to check
            retcode = arcpy.AlterVersion_management(sde, versionName, "", "Version for Data loading", "PRIVATE")
            if debug == True:
                addMessageLocal("alter version " + str(retcode))
            #addMessageLocal "Alter version succeeded"
        except:
            addMessageLocal("Create version failed - please try to manually delete any existing version in ArcCatalog")
            addMessageLocal("Error: " + str(sys.exc_value))
            retcode = False # if we can't change it the version probably doesn't exist
            if debug == True:
                addMessageLocal("except: alter version (doesn't exist) " + str(retcode))
            exit(-1)

    if retcode != False: # this means that the create version call returned a value
        retcode = True
    if debug == True:
        addMessageLocal("final retcode " + str(retcode))
    return retcode

def changeVersion(tableName,versionName):
    # change to a new version in the database
    retVal = False
    try:
        arcpy.ChangeVersion_management(tableName,"TRANSACTIONAL",versionName)
        retVal = True
    except:
        addMessageLocal("Failed to change version: " + tableName + ", " + versionName)
    return retVal

def deleteVersion(sde,versionName):
    # delete a version from the database
    addMessageLocal("Deleting Version...")
    retcode = False
    if versionName.split(".")[0] == versionName:
        # default to DBO
        versionName = "DBO." + versionName
    if debug == True:
        addMessageLocal(sde + "|" + versionName)
    try:
        try:
            retcode = arcpy.DeleteVersion_management(sde, versionName)
        except:
            retcode = arcpy.DeleteVersion_management(sde, versionName)
        if debug == True:
            addMessageLocal(versionName + " version deleted")
        retcode = True
    except:
        retcode = False
        #addMessageLocal("Error: " + str(sys.exc_value))
        #addMessageLocal(versionName + " version not deleted... Please delete manually in ArcCatalog")
        #exit(-1)
    return retcode

def reconcilePost(sdeDefault,versionName,defaultVersion):
    # reconcile and post a version
    addMessageLocal("Reconcile and Post Version... ")

    if versionName.split(".")[0] == versionName:
        # default to DBO
        versionName = "DBO." + versionName
    retcode = False

    addMessageLocal("Reconciling " + versionName + "..." )
    try:
        retcode = arcpy.ReconcileVersion_management(sdeDefault, versionName, defaultVersion , "BY_OBJECT", "FAVOR_TARGET_VERSION", "LOCK_ACQUIRED", "NO_ABORT", "POST")
        if str(retcode) == sdeDefault:
            retcode = True
        else:
            addMessageLocal("Unexpected result: " + str(retcode) + ", continuing...")
            retcode = True
    except:
            addMessageLocal("Reconcile failed: \n" + str(retcode) + "\n" + sdeDefault)
            retcode = False
    arcpy.env.workspace = sdeDefault
    arcpy.ClearWorkspaceCache_management(sdeDefault)
    return retcode

def listDatasets(gdb):
    # list all of the datasets and tables
    dsNames = []
    dsFullNames = []
    arcpy.env.workspace = gdb
    addMessageLocal("Getting list of Datasets from " + gdb)
    wsDatasets = arcpy.ListDatasets()
    wsTables = arcpy.ListTables()
    if wsDatasets:
        for fds in wsDatasets:
            desc = arcpy.Describe(fds)
            if desc.DatasetType == "FeatureDataset" :
                arcpy.env.workspace = desc.CatalogPath
                fcs = arcpy.ListFeatureClasses()
                for fc in fcs:
                    descfc = arcpy.Describe(fc)
                    if descfc.DatasetType == "FeatureClass":
                        dsNames.append(nameTrimmer(fc))
                        dsFullNames.append(desc.CatalogPath + os.sep + fc)
                        if debug:
                            arcpy.AddMessage(desc.CatalogPath + os.sep + fc)
            arcpy.env.workspace = gdb

    arcpy.env.workspace = gdb
    fcs = arcpy.ListFeatureClasses()
    for fClass in fcs:
        descfc = arcpy.Describe(fClass)
        if descfc.DatasetType == "FeatureClass":
            dsNames.append(nameTrimmer(fClass))
            dsFullNames.append(gdb + os.sep + fClass)
            if debug:
                arcpy.AddMessage(gdb + os.sep + fClass)

    arcpy.env.workspace = gdb
    for table in wsTables:
        descfc = arcpy.Describe(table)
        if descfc.DatasetType == "Table":
            dsNames.append(nameTrimmer(table))
            dsFullNames.append(gdb + os.sep + table)
            if debug:
                arcpy.AddMessage(gdb + os.sep + table)

    return([dsNames,dsFullNames])

def getFullName(searchName,names,fullNames):
    # find full name for searchName string
    try:
        # look for the matching name in target names
        t = names.index(searchName.upper())
        fullName = fullNames[t]
        return fullName
    except:
        # will get here if no match
        t = -1

    return ""

def nameTrimmer(name):
    # trim any database prefixes from table names
    if name.count(".") > 0:
        return name.split(".")[name.count(".")].upper()
    else:
        return name.upper()

def getFieldValues(mode,fields,datasets):
    # get a list of field values, returns all values and the unique values.
    theValues = [] # unique list of values
    theDiff = [] # all values
    for dataset in datasets:
        name = dataset.getAttributeNode("name").nodeValue
        table = os.path.join(workspace,name)
        desc = arcpy.Describe(table)
        try:
            cursor = arcpy.SearchCursor(table)
            row = cursor.next()
        except Exception, ErrorDesc:
            printMsg( "Unable to read the Dataset, Python error is: ")
            msg = str(getTraceback(Exception, ErrorDesc))
            printMsg(msg[msg.find("Error Info:"):])
            row = None

        numFeat = int(arcpy.GetCount_management(table).getOutput(0))
        addMessageLocal(table + ", " + str(numFeat) + " (get " + mode + ") features")
        progressUpdate = 1
        i=0
        if numFeat > 100:
            progressUpdate = numFeat/100
        arcpy.SetProgressor("Step","Getting " + mode + " values...",0,numFeat,progressUpdate)
        attrs = [f.name for f in arcpy.ListFields(table)]

        if row is not None:
            while row:
                i += 1
                if i % progressUpdate == 0:
                    arcpy.SetProgressorPosition(i)
                try:
                    for field in fields:
                        if field in attrs:
                            currentValue = row.getValue(field)
                            if mode.upper() == "UNIQUE":
                                if currentValue != None:
                                    try:
                                        theValues.index(currentValue) # if the current value is present
                                        theDiff.append(currentValue) # add to the list of differences if it is found
                                    except:
                                        theValues.append(currentValue) # else add the value if the first check fails.
                            elif mode.upper() == "ALL":
                                theValues.append(currentValue)
                except:
                    err = "Exception caught: unable to get field values"
                    addError(err)
                    logProcessError(row.getValue(field),sourceIDField,row.getValue(sourceIDField),"Cannot read",err)
                    theValues = []

                row = cursor.next()

        del cursor
        arcpy.RefreshCatalog(table)

    return [theValues,theDiff]

def addGizintaField(table,targetName,field,attrs):
    # add a field to a gizinta Geodatabase
    retcode = False
    fieldProperties = []
    fieldProps = getNodeValue(field,"FieldProperties")
    if fieldProps == "":
        fieldType = getNodeValue(field,"FieldType")
        fieldLength = getNodeValue(field,"FieldLength")
        fieldProperties = [fieldType,"","",fieldLength]
    else:
        fieldProperties = fieldProps.split(",")

    addMessageLocal("Field " + targetName)
    try:
        attrs.index(targetName)
        retcode = True
    except:
        try:
            table = table.replace("\\","\\\\")
            callStr = "arcpy.AddField_management('" + table + "','" + targetName + "'"
            for prop in fieldProperties:
                callStr = callStr + ",'" +  str(prop) + "'"
            callStr = callStr + ")"
            eval(callStr)
            retcode = True
        except :
            showTraceback()
            fields = arcpy.ListFields(table)
            for field in fields: # drop any field prefix from the source layer (happens with map joins)
                thisFieldName = field.name[field.name.rfind(".")+1:]
                if thisFieldName.upper() == targetName.upper():
                    addMessageLocal("WARNING: Existing field name '" + thisFieldName + "' conflicts with new field name '" + targetName + "'. Identical names with different case are not supported by databases!\n")
    return retcode

def addField(table,fieldName,fieldType,fieldLength):
    # add a field to a Geodatabase
    retcode = False
    try:
        if fieldLength == None:
            fieldLength = ""
        arcpy.AddField_management(table, fieldName, fieldType,fieldLength)
        retcode = True
    except:
        showTraceback()

    return retcode

def setupLogTables():
    # setup the log tables if they do not exist
    if logTableName.rfind(os.sep) == -1:
        logTableFull = os.path.join(workspace,logTableName)
    else:
        logTableFull = logTableName
        logTable = logTable[rfind(os.sep)+1:]

    if errorTableName.rfind(os.sep) == -1:
        errorTableFull = os.path.join(workspace,errorTableName)
    else:
        errorTableFull = errorTableName
        errorTable = errorTable[rfind(os.sep)+1:]

    if not arcpy.Exists(logTableFull):
        try:
            arcpy.CreateTable_management(workspace,logTableName)
            addField(logTableFull,"PROCNAME","TEXT",100)
            addField(logTableFull,"LOADTIME","DATE","")
            addField(logTableFull,"LOADNAME","TEXT",100)
            addField(logTableFull,"DATASET","TEXT",50)
            addField(logTableFull,"COMPLETED","SHORT","")
            addField(logTableFull,"LOADUSER","TEXT",50)
            addField(logTableFull,"ACTIVEFLAG","TEXT",3)
            addMessageLocal(logTableName + " Created")
        except:
            msg = "Failed to Create " + logTableName

    if not arcpy.Exists(errorTableFull):
        try:
            arcpy.CreateTable_management(workspace,errorTableName)
            addField(errorTableFull,"PROCNAME","TEXT",100)
            addField(errorTableFull,"SOURCENAME","TEXT",100)
            addField(errorTableFull,"SRCIDFIELD","TEXT",50)
            addField(errorTableFull,"SRCIDVAL","TEXT",50)
            addField(errorTableFull,"DATASET","TEXT",50)
            addField(errorTableFull,"REASON","TEXT",100)
            addField(errorTableFull,"ERRUSER","TEXT",50)
            addField(errorTableFull,"ERRTIME","DATE","")
            addField(errorTableFull,"ACTIVEFLAG","TEXT",3)
            addMessageLocal(errorTableName + " Created")
        except:
            msg = "Failed to Create " + errorTableName

def createGizintaGeodatabase():
    # Create a workspace - file GDB
    folder = workspace[:workspace.rfind(os.sep)]
    fgdb = workspace[workspace.rfind(os.sep)+1:]
    retcode = False
    try:
        arcpy.CreateFileGDB_management(folder,fgdb)
        retcode = True
        addMessageLocal("New Gizinta Geodatabase created: " + workspace)
    except:
        showTraceback()
        addMessageLocal("Unable to create Gizinta Geodatabase: " + folder + "\\" + fgdb)
    return retcode

def checkXmlSettings(xmlFile,sources,targets):
    # not implemented, could check all XML settings
    retVal = True
    return retVal

def isGizintaDocument(xmlDoc):
    # Is the first node Gizinta in the XML document?
    GizintaNode = None
    try:
        GizintaNode = xmlDoc.getElementsByTagName("Gizinta")
    except:
        pass
    if GizintaNode:
       retVal = True
    else:
       retVal = False
    return retVal

def isPlaylistDocument(xmlDoc):
    # Is the first node a Gizinta Playlist?
    PlaylistNode = None
    try:
        PlaylistNode = xmlDoc.getElementsByTagName("GizintaPlaylist")
    except:
        pass
    if PlaylistNode:
       retVal = True
    else:
       retVal = False
    return retVal

def getRootElement(xmlDoc):
    # get the root element
    retDoc = None
    if isGizintaDocument(xmlDoc):
        retDoc = xmlDoc.getElementsByTagName("Gizinta")[0]
    elif isPlaylistDocument(xmlDoc):
        retDoc = xmlDoc.getElementsByTagName("GizintaPlaylist")[0]
    return retDoc

def getXmlElements(xmlFile,elemName):
    # get Xml elements from a file or files in a playlist
    retDoc = None
    xmlDoc = xml.dom.minidom.parse(xmlFile)
    if isGizintaDocument(xmlDoc):
        retDoc = xmlDoc.getElementsByTagName(elemName)
    elif isPlaylistDocument(xmlDoc):
        docs = xmlDoc.getElementsByTagName("File")
        for doc in docs:
            fileName = collect_text(doc)
            folder = xmlFile[:xmlFile.rfind(os.sep)]
            theFile = os.path.join(folder,fileName)
            if os.path.exists(theFile):
                xmlDoc2 = xml.dom.minidom.parse(theFile)
                xmlNodes = xmlDoc2.getElementsByTagName(elemName)
                if retDoc == None:
                    retDoc = xmlNodes
                else:
                    for node in xmlNodes:
                        retDoc.append(node)
            else:
                addMessageLocal(theFile + " does not exist, continuing...")
    else:
        retDoc = None
    return retDoc

def convertDataset(dataElementType,sourceTable,workspace,targetName,whereClause):
    # convert a dataset
    if dataElementType == "DEFeatureClass":
        arcpy.FeatureClassToFeatureClass_conversion(sourceTable,workspace,targetName,whereClause)
    elif dataElementType == "DETable":
        arcpy.TableToTable_conversion(sourceTable,workspace,targetName,whereClause)


def makeView(deType,workspace,sourceTable,viewName,whereClause, xmlFields):
    # make a view
    view = None
    if deType == "DETable":
        view = makeTableView(workspace,sourceTable,viewName, whereClause,xmlFields)
    if deType == "DEFeatureClass":
        view = makeFeatureView(workspace,sourceTable,viewName, whereClause, xmlFields)

    return view

def exportDataset(sourceWorkspace,sourceName,targetName,dataset,xmlFields):
    # export a dataset
    result = True
    sourceTable = os.path.join(sourceWorkspace,sourceName)
    targetTable = os.path.join(workspace,targetName)
    addMessageLocal("Exporting dataset " + sourceTable)

    try:
        desc = arcpy.Describe(sourceTable)
        deType = desc.dataElementType
        whereClause = getWhereClause(dataset)
        viewName = sourceName + "_View"
        view = makeView(deType,workspace,sourceTable,viewName, whereClause,xmlFields)
        count = arcpy.GetCount_management(view).getOutput(0)
        addMessageLocal(str(count) + " source rows")
        convertDataset(deType,view,workspace,targetName,whereClause)
    except:
        err = "Failed to create new dataset " + targetName
        addError(err)
        logProcessError(sourceTable,sourceIDField,sourceName,targetName,err)
        result = False
    return result


def importDataset(sourceWorkspace,sourceName,targetName,dataset,xmlFields):
    # import a dataset
    result = True
    sourceTable = os.path.join(sourceWorkspace,sourceName)
    targetTable = os.path.join(workspace,targetName)
    addMessageLocal("Importing dataset " + sourceTable)

    try:
        whereClause = getWhereClause(dataset)
        if not arcpy.Exists(sourceTable):
            err = sourceTable + " does not exist"
            addError(err)
            logProcessError(sourceTable,sourceIDField,sourceName,targetName,err)
            return False
        if not arcpy.Exists(targetTable):
            err = targetTable + " does not exist"
            addError(err)
            logProcessError(targetTable,sourceIDField,sourceName,targetName,err)
            return False
        desc = arcpy.Describe(sourceTable)
        deType = desc.dataElementType
        viewName = sourceName + "_View"
        view = makeView(deType,workspace,sourceTable,viewName, whereClause, xmlFields)
        count = arcpy.GetCount_management(view).getOutput(0)
        addMessageLocal(str(count) + " source rows")
        arcpy.Append_management([view],targetTable, "NO_TEST","","")

    except:
        err = "Failed to import layer " + targetName
        addError(err)
        logProcessError(sourceTable,sourceIDField,sourceName,targetName,err)
        result = False
    return result

def deleteExistingRows(datasets):
    # delete existing rows in a dataset
    for dataset in datasets:
        name = dataset.getAttributeNode("targetName").nodeValue
        table = os.path.join(workspace,name)
        if arcpy.Exists(table):
            arcpy.DeleteRows_management(table)
            addMessageLocal("Rows deleted from: " + name)
        else:
            addMessageLocal(table + " does not exist")


def compressGDB(workspace):
    # compact or compress the workspace
    retVal = False
    desc = arcpy.Describe(workspace)
    if desc.workspaceType == "RemoteDatabase":
        try:
            addMessageLocal("Database Compress...")
            arcpy.Compress_management(workspace)
            retVal = True
        except:
            addMessageLocal("Database Compress failed, continuing")
    elif desc.workspaceType == "LocalDatabase":
        try:
            addMessageLocal("Database Compact...")
            arcpy.Compact_management(workspace)
            retVal = True
        except:
            addMessageLocal("Local Database Compact failed, continuing")
    return retVal

def getFileList(inputFolder,fileExt,minTime): # get a list of files - recursively
    inputFiles = []
    if inputFolder.lower().endswith(".dwg") == True: # if the arg is a file instead of a folder just get that as a list
        inputFiles.append([os.path.dirname(inputFolder), os.path.basename(inputFolder)])
        addMessageLocal(os.path.dirname(inputFolder))
        addMessageLocal(os.path.basename(inputFolder))
        return inputFiles
    docList = os.listdir(inputFolder) #Get directory list for inputDirectory
    for doc in docList:
        docLow = doc.lower()
        ffile = os.path.join(inputFolder,doc)
        if docLow.endswith(fileExt.lower()):
            t = os.path.getmtime(ffile)
            modTime = datetime.datetime.fromtimestamp(t)
            if modTime > minTime:
                inputFiles.append([inputFolder,doc])
        elif os.path.isdir(ffile):
            newFiles = getFileList(ffile,fileExt,minTime)
            inputFiles = newFiles + inputFiles
    inputFiles = sorted(inputFiles)
    return(inputFiles)
