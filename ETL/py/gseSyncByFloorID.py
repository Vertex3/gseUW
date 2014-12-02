import os,sys,arcpy,gzSupport

ospath = os.path.realpath(__file__)
etl = os.sep+'ETL'+os.sep
gsepath = ospath[:ospath.rfind(etl)]
etlpath = gsepath + etl
if (etlpath) not in sys.path:
    sys.path.insert(0, etlpath)

import gse
arcpy.ImportToolbox(os.path.join(gse.etlFolder,"gse.tbx"))

ws = arcpy.GetParameterAsText(0)
if ws == None or ws == '' or ws == '#':
    ws = r'C:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde'
print "Staging: ", ws
prodws = arcpy.GetParameterAsText(1)
if prodws == None or prodws == '' or prodws == '#':
    prodws = r'C:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Production.sde'
print "Target: ", prodws

config = arcpy.GetParameterAsText(2)
if config == None or config == '' or config == '#':
    config = r'C:\Apps\Gizinta\gseUW\ETL\config\rtElevatorPlaylist.xml'
print "Playlist: ", config

def main(argv = None):
    fcs = gzSupport.getDatasets(config)
    field = 'FLOORID'
    floors = []
    for fc in fcs:
        dsname = fc.getAttributeNode("targetName").nodeValue
        table = os.path.join(ws,dsname)
        floors = getFloors(floors,table,field) 
    floors.sort()
    print floors
    for floor in floors:
        try:
            result = arcpy.gseSyncChanges_gse(floor,config,ws,prodws)
        except:
            # sometimes there are deadlocks, try again
            msg("Error encountered, attempting to sync again...")
            result = arcpy.gseSyncChanges_gse(inputDrawing,config,ws,prodws)
    print "completed"
    
def getFloors(floors,table,fieldname):
    try:
        cursor = arcpy.SearchCursor(table)
        row = cursor.next()
    except Exception, ErrorDesc:
        print( "Unable to read the Dataset, Python error is: ")
        row = None

    while row:
        floorid = row.getValue(fieldname)
        try:
            floors.index(floorid)
        except:
            floors.append(floorid)
        row = cursor.next()

    del cursor
    return floors

if __name__ == "__main__":
    main()
