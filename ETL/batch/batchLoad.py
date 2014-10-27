# batchLoad.py - run multiple processes to load all floorplans to staging database

import Queue, thread, subprocess, os, sys, time

floorplans = r'C:\Apps\Gizinta\CADVault\Floorplans'
numProcs = 4 # number of processes to run at one time.
folderCount = 0
for i in range(0,100,1):
    # get the number of folders
    fp = floorplans + str(i)
    if os.path.exists(fp):
        folderCount += 1
    else:
        break

def main(argv = None):

    try:
        for group in range(0,maxgroup,1):
            print "Group",group
            groupTime = timer(0)
            doSet(group,comm)
            print "Group processing time:", getTimeElapsed(groupTime)
    finally:
        print "Total processing time:", getTimeElapsed(totalTime)
        log.close()

# need to make this better... use the gseRunFME approach...
comm = []
comm.append(r'C:\Apps\FME\fme.exe')
comm.append(r"C:\Apps\Gizinta\gseUW\ETL\fme\gseFloorplanLoader.fmw")
comm.append('--DestDataset_GEODATABASE_SDE') 
comm.append('sde')
comm.append('--OUT_CONNECTION_FILE_GEODATABASE_SDE')
comm.append(r"C:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde")
comm.append('--ProductionConnectionFile')
comm.append(r"C:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Production.sde")
comm.append('--GizintaProject')
comm.append(r'C:\Apps\Gizinta\gseUW\ETL\config\fpLoadPlaylist.xml')
comm.append('--TargetFieldQA')
comm.append('True')
comm.append('--SourceFieldQA')
comm.append('False')
comm.append('--IgnoreErrors')
comm.append('False')
comm.append('--SourceDatasetTypes')
comm.append('CADDataset')
comm.append('--SourceCoordinateSystem')
comm.append('EPSG:2285')
comm.append('--gzDebug')
comm.append('False')
comm.append('--truncate')
comm.append('N')
comm.append('--LOG_FILE')
comm.append(r'C:\Apps\Gizinta\gseUW\ETL\fme\log\gseFloorplanLoader###.log')
comm.append('--FEATURE_TYPES')
comm.append("Floor_Poly FloorplanLine InteriorSpace")
comm.append('--FEATURE_TYPES_READ')
comm.append("GSF BSE RMS")
comm.append('--SourceDataset_ESRIMSD')
comm.append(r'C:\Apps\Gizinta\CADVault\Floorplans###\**\*XP*.dwg')

thefile = os.path.join(sys.path[0],'truncateStagingLoad.py')
print thefile
python = r'C:\Python27\ArcGISx6410.2\python.exe'
subprocess.call(python + " " + thefile)
print "staging truncate complete"

log = open(os.path.join(sys.path[0],'batchLoad.log'),'w')
threads = []
fnum = 0

results= Queue.Queue()

def process_waiter(popen, description, que):
    try: popen.wait()
    finally: que.put( (description, popen.returncode) )

def timer(input):
    # time difference
    return time.time() - input

thefile = os.path.join(sys.path[0],'mytest.py')
totalTime = timer(0)
maxgroup = int(folderCount/numProcs)

def getTimeElapsed(timeVal):
    # format elapsed time string
    return (str(int(timer(timeVal)/60)) + 'm' + str(int(timer(timeVal) % 60)) + 's\n')

def doSet(group,comm):
    # do a set of drawings, fnum keeps track of the total processes
    global fnum,numProcs,folderCount
    process_count= 0

    for i in range(0,numProcs,1):
        if fnum < folderCount:
            commi = []
            for item in comm:
                commi.append(item.replace("###",str(fnum)))
            log.write(str(commi)+'\n')
            threads.append(subprocess.Popen(commi))
            #threads.append(subprocess.Popen( [python, thefile] ))
            thread.start_new_thread(process_waiter,(threads[i], fnum, results))
            process_count += 1
            fnum += 1

    while process_count > 0:
        description, rc = results.get()
        print "job", description, "ended with return code =", rc
        process_count -= 1
        threads.pop(process_count)



if __name__ == "__main__":
    main()

        