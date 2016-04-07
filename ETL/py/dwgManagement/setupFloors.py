### setupFloors.py - Insert records into active floor and floor level tables based on a set of
### drawings defined in settings.py
import os, sys, time, arcpy, traceback, settings, glob

workspace = settings.workspace
dwgfolder = settings.dwgfolder
splitstr = settings.filestring
floorlevel = 'Floor_Level'
activefloor = 'Active_Floor'
tabActive_Floor = os.path.join(workspace,activefloor)
tabFloor_Level = os.path.join(workspace,floorlevel)

debug = False
arcpy.env.workspace = workspace

dwgs = []
flrs = []
activeFloors = []
floorLevels = []

def main(argv = None):
    global flrs, activeFloors,floorLevels,dwgs
    if not arcpy.Exists(tabActive_Floor):
        addMessageLocal(tabActive_Floor + " table does not exist, exiting")
        exit(-1)
    if not arcpy.Exists(tabFloor_Level):
        addMessageLocal(tabFloor_Level + " table does not exist, exiting")
        exit(-1)
    floorLevels = getFloorLevels()
    activeFloors = getActiveFloors()
    os.path.walk(dwgfolder,processDir,None)
    # insert rows for floor levels found into Floor Levels table
    insertFloorLevels(flrs,floorLevels)

    print "processed " + str(len(dwgs)) + " drawings", str(dwgs)
    del flrs, floorLevels, dwgs, activeFloors

def processDir(args,dir,files):
    global dwgs
    global flrs
    global activeFloors
    for dwg in files:
        if dwg.lower().endswith(".dwg") and dwg.lower().find("outline") < 0 and dwg.find(splitstr) > - 1:
            # for each drawing split into parts and insert to table.
            dwg = dwg[:dwg.rfind('.')]
            try:
                dwgs.index(dwg)
            except:
                dwgs.append(dwg)
                parts = dwg.split(splitstr)
                bldg = parts[0]
                flr = parts[1]
                try:
                    flrs.index(flr)
                except:
                    flrs.append(flr)
                # insert a record into the active floors table
                if (bldg + '_' + flr) not in activeFloors:
                    insertActiveFloor(dwg,bldg,flr)
    

def insertActiveFloor(dwg,bldg,flr):
    retcode = False
    insertCursor = arcpy.InsertCursor(tabActive_Floor)
    if debug:
        addMessageLocal("Inserting into " +  tabActive_Floor)
    try:
        insRow = insertCursor.newRow()
        siteid = settings.siteid
        #buildingid = siteid + "_" + str(bldg)
        buildingid = str(bldg)
        floorid = buildingid + "_" + flr
        
        insRow.setValue("siteid",siteid)
        insRow.setValue("buildingid",buildingid)
        insRow.setValue("bldgcode",bldg)
        insRow.setValue("floorcode",flr)
        insRow.setValue("floorid",floorid)
        insRow.setValue("sourcedwg",dwg)
        #insRow.setValue("hasinteriorspaces","Y")
        #insRow.setValue("hasfloorplanlines","Y")
        #insRow.setValue("hasfloorarea","Y")
        insRow.setValue("schelev",getElev(flr))
        #insRow.setValue("altitude",getElev(flr))
        insRow.setValue("sensitivity","None")
        insRow.setValue("lastupdate",time.strftime("%Y-%m-%d %H:%M:%S",time.localtime()))
        insRow.setValue("lasteditor","setupFloors.py")
        insertCursor.insertRow(insRow)
        addMessageLocal("Row inserted into Active_Floor table for " + floorid)
        retcode = True
    except:
        print "error processing",floorid
        showTraceback()
    finally:
        del insertCursor
    return retcode

def insertFloorLevels(flrs,floorLevels):
    retcode = False
    insertCursor = arcpy.InsertCursor(tabFloor_Level)
    if debug:
        addMessageLocal("Inserting into " +  tabFloor_Level)
    for flr in flrs:
        if flr not in floorLevels:
            try:
                insRow = insertCursor.newRow()
                siteid = settings.siteid
                insRow.setValue("siteid",siteid)
                insRow.setValue("floorcode",flr)
                insRow.setValue("floorlevel",getElev(flr))
                insRow.setValue("namelong",flr)
                insRow.setValue("nameshort",flr)
                insertCursor.insertRow(insRow)
                addMessageLocal("Row inserted into Floor_Level table for " + flr)
                retcode = True
            except:
                showTraceback()
        
    del insertCursor
    return retcode

def getActiveFloors():
    theValues = getValues(tabActive_Floor,"floorid")
    return theValues

def getFloorLevels():
    theValues = getValues(tabFloor_Level,"floorcode")
    return theValues

def getValues(table,fieldname):
    theValues = [] # unique list of floorid values
    try:
        cursor = arcpy.SearchCursor(table)
        row = cursor.next()
    except Exception, ErrorDesc:
        addMessageLocal( "Unable to read the Dataset, Python error is: ")
        showTraceback()
        row = None

    while row:
        try:
            currentValue = row.getValue(fieldname)
            try:
                theValues.index(currentValue) # if the current value is present
            except:
                theValues.append(currentValue) # else add the value if the first check fails.
        except:
            err = "Exception caught: unable to get field values"
            addMessageLocal(err)
            showTraceback()
        row = cursor.next()

    del cursor
    return theValues


def getElev(flr):
    elev = 0
    if flr[0] == 'B':
        elev = - int(flr[1:]) 
    elif flr[0] == 'M':
        if flr[1] == 'G':
            elev = 0.5
        if flr[1] == 'P':
            elev = - int(flr[2:]) + 0.5
        if flr[1] == 'B':
            elev = - int(flr[2:]) + 0.5
        else:
            elev = int(flr[1:]) + 0.5
    elif flr == '0G' or flr == 'MG':
        elev = 0
    elif flr == 'RF':
        elev = 9.8
    elif flr == 'MRF':
        elev = 9.9
    else:
        try:
            elev = int(flr)
        except:
            elev = 0
            print "Error getting floor level, defaulted to 0"

    return (elev * 10)

def addMessageLocal(txt):
    print txt
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
    arcpy.AddError(pymsg)


if __name__ == "__main__":
    main()
