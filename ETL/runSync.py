### runSync.py - run a floorplan sync process with subprocesses
import os,sys,subprocess, time, traceback, multiprocessing

timeout = 10
sites = ['UWS'] # add more later
#pyt = r'C:\Python27\ArcGIS10.3\python.exe'
pyt = "python.exe"
fme = "c:\\apps\\FME\\fme.exe"
etlFolder = "c:\\apps\\Gizinta\\gseUW\\ETL"
script = r"C:\Apps\Gizinta\gseUW\ETL\py\gseLoaderFME.py"
params = []
params.append([pyt,script,"rtLoadPlaylist.xml","gseDataConfig_%SITE%.xml"])
params.append([fme,os.path.join(etlFolder,"fme","gseRoutingElevatorConstructor.fmw")])#,os.path.join(etlFolder,"serverConfig","gseDataConfig_%SITE%.xml")])
params.append([pyt,r'C:\Apps\Gizinta\gseUW\ETL\py\gseSyncByFloorID.py',r'C:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Staging.sde',r'C:\Apps\Gizinta\gseUW\ETL\serverConfig\GIS Production.sde',r'C:\Apps\Gizinta\gseUW\ETL\config\rtElevatorPlaylist.xml'])
#params.append([os.path.join(etlFolder,"PublicationRouting_sync.bat")])
params.append([fme,os.path.join(etlFolder,"batch","Exterior","gseBuildingConnector.fmw")])#,os.path.join(etlFolder,"serverConfig","gseDataConfig_%SITE%.xml")])
params.append([os.path.join(etlFolder,"batch","Routing","doNetwork.bat")])

log = open(os.path.realpath(__file__) + '.log', "w+")

def main(argv = None):
    ### Main function - loop through files
    res = 0
    pprint('Starting runSync.py')
    error = False
    for site in sites:
        for param in params:
            if error == False:
                ps = []
                for p in range(0,len(param)):
                    if p == 0:
                        ps.append(getParam(param,p,'',site))
                    else:
                        ps.append(getParam(param,p,'\"',site))
                comm = " ".join(ps).strip()
                print(comm)
                res = subprocess.call(comm, shell=True)
                if res != 0:
                    error = True
                    print("non-zero result")
    pprint('Completed runSync.py')
    if log != None:
        log.close()
    if error:
        raise Exception("Error in processing",res)

def getParam(params,num,enc,site):
    param = ''
    if len(params) > num:
        param = (enc + params[num] + enc).replace('%SITE%',site)
    return param

def runproc(script,q1):
    items = []
    res = ''
    proc = subprocess.Popen(script, stderr=subprocess.STDOUT)

    proc.wait()
    pprint('res=' + str(proc.returncode))
    items.append(proc.returncode)
    q1.put(items)
    return True

def runProcess(script):
    items = []
    q1 = multiprocessing.Queue()
    p = multiprocessing.Process(target=runproc, name='runSync1', args=(script,q1,))
    started_at = time.time()
    p.daemon = True # this will kill the process even if there are fatal errors (like corrupt mxds)
    p.start() 

    # If thread is active
    if p.is_alive():
        print ('running process with timeout =',timeout)
        p.join(timeout)    # Wait
        ended_at = time.time()
        diff = ended_at - started_at
        print(round(diff,2)), 'seconds elapsed'

        if(diff < timeout): # only get from the queue if less time than timeout
            items = q1.get()
        # Terminate
        p.terminate()
        
        if(diff < timeout):
            if items != [] and items[0] == 0:
                return True
        else:
            return False

def pprint(*args):
    global log
    for item in args:
        print(str(item))
        log.write(str(item))
    if len(args) > 0:
        log.write('\n')

if __name__ == "__main__":
    main()
