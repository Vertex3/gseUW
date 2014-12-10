import os,sys,arcpy,gzSupport

ospath = os.path.realpath(__file__)
etl = os.sep+'ETL'+os.sep
gsepath = ospath[:ospath.rfind(etl)]
etlpath = gsepath + etl
if (etlpath) not in sys.path:
    sys.path.insert(0, etlpath)

import gse

ws = arcpy.GetParameterAsText(0)
if ws == None or ws == '' or ws == '#':
    ws = r'C:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Production.sde'
print "Source: ", ws

pubws = arcpy.GetParameterAsText(1)
if pubws == None or pubws == '' or pubws == '#':
    pubws = r'C:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Publication.sde'
print "Target: ", pubws

config = arcpy.GetParameterAsText(2)
if config == None or config == '' or config == '#':
    config = r'C:\Apps\Gizinta\gseUW\ETL\config\fp\fpFloorArea.xml'
print "Playlist: ", config

def main(argv = None):
    fcs = gzSupport.getDatasets(config)
    for fc in fcs:
        try:
            arcpy.ImportToolbox(os.path.join(gse.etlFolder,"gse.tbx"))
            result = arcpy.gseSyncChanges_gse("ALL",config,ws,pubws)
        except:
            # sometimes there are deadlocks, try again
            print("Error encountered, attempting to sync again...")
            result = arcpy.gseSyncChanges_gse("ALL",config,ws,pubws)
    print "completed"
    

if __name__ == "__main__":
    main()
