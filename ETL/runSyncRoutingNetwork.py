### runSync.py - run a floorplan sync process with subprocesses
import os,sys,subprocess, time, traceback, multiprocessing, etl

timeout = 10
sites = ['UWS'] # add more later
sitefile = os.path.join(os.path.dirname(os.path.realpath(__file__)),'routingsites.txt')
with open(sitefile,'r') as infile:
	data = infile.read()
	sites = data.splitlines()
	print('Sites from routingsites.txt: ' + " ".join(sites))
#pyt = r'C:\Python27\ArcGIS10.3\python.exe'
pyt = "python.exe"
fme = "c:\\apps\\FME\\fme.exe"
etlFolder = "c:\\apps\\Gizinta\\gseUW\\ETL"


routeparams = []
rtFolder = os.path.join(etlFolder,"batch","Routing")

# This section replaces the old "doNetwork.bat" - take data from the production database and push into network dataset.
routeparams.append([fme,os.path.join(etlFolder,"fme","gseRoutingElevatorConstructor.fmw")])# *** ? ,os.path.join(etlFolder,"serverConfig","gseDataConfig_%SITE%.xml")])
routeparams.append([fme,os.path.join(etlFolder,"batch","Exterior","gseBuildingConnector.fmw")])# *** ? ,os.path.join(etlFolder,"serverConfig","gseDataConfig_%SITE%.xml")])
routeparams.append(['del',os.path.join(rtFolder,'Routing.gdb'), '/s', '/q'])
routeparams.append(['xcopy',os.path.join(rtFolder,'Template.gdb'), os.path.join(rtFolder,'Routing.gdb'), '/e', '/i', '/y'])
routeparams.append([fme,os.path.join(rtFolder,'GenerateNetworkDataset.fmw'),'--GEODATABASE_SDE_IN_CONNECTION_FILE', r'C:\apps\Gizinta\gseUW\ETL\serverConfig\GIS Production.sde'])
routeparams.append([pyt,os.path.join(rtFolder,'buildNDS.py')])
routeparams.append(['del',os.path.join(rtFolder,'RemoteRouting.gdb'), '/s', '/q'])
routeparams.append(['xcopy',os.path.join(rtFolder,'Routing.gdb'),os.path.join(rtFolder,'RemoteRouting.gdb'), '/e', '/i', '/y'])

stdout = sys.stdout
sys.stdout = open(os.path.realpath(__file__) + '.log', "w+")

def main(argv = None):
	### Main function - loop through files
	res = 0
	etl.pprint('Starting ' + __file__)
	error = False
	doNetwork(routeparams,sites)
	etl.pprint('Completed ' + __file__)
	sys.stdout = stdout

	if error:
		raise Exception("Error in processing",res)

def doNetwork(params,site):
	error = False
	for site in sites:
		for param in params:
			if error == False: # this case is different, stop if any errors.
				ps = []
				for p in range(0,len(param)):
					if p == 0:
						ps.append(etl.getParam(param,p,'',site))
					else:
						ps.append(etl.getParam(param,p,'\"',site))
				comm = " ".join(ps).strip()
				print(comm)
				res = subprocess.call(comm, shell=True)
				if res != 0:
					#error = True
					print("non-zero result")
	etl.pprint('Completed Routing Network')
	return error
		

if __name__ == "__main__":
	main()
