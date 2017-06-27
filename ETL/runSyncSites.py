### runSync.py - run a floorplan sync process with subprocesses
import os,sys,subprocess, time, datetime, traceback, multiprocessing, etl

timeout = 10
sites = [] # add more later

pyt = r'C:\Python27\ArcGIS10.4\python.exe'
#pyt = "python.exe"
fme = "c:\\apps\\FME\\fme.exe"
etlFolder = "c:\\apps\\Gizinta\\gseUW\\ETL"
rtFolder = os.path.join(etlFolder,"batch","Routing")
script = r"C:\Apps\Gizinta\gseUW\ETL\py\gseLoaderFME.py"

siteparams = []
siteparams.append([pyt,script,"bldgLoadPlaylist.xml","gseDataConfig_%SITE%.xml"])
siteparams.append([pyt,script,"fpLoadPlaylist.xml","gseDataConfig_%SITE%.xml"])
siteparams.append([pyt,script,"rtLoadPlaylist.xml","gseDataConfig_%SITE%.xml"])

#today = datetime.datetime.now()
#day = datetime.timedelta(days=1) # default to 1 day for first time run.
#yesterday = today - day
start = datetime.datetime.now()
startTime = start.strftime("%Y%m%d%H%M%S")
RTscript = r'C:\Apps\Gizinta\gseUW\ETL\runRoutingExtract.py'
siteparams.append([pyt,RTscript,'%SITE%',startTime])
#siteparams.append([fme,os.path.join(rtFolder,"RT_Extract.fmw"),'--Extract_Since',startTime])
siteStart = []
stdout = sys.stdout
sys.stdout = open(os.path.realpath(__file__) + '.log', "w+")

def main(argv = None):
	### Main function - loop through files
	res = 0
	etl.pprint('Starting ' + __file__)

	sitesCAD = getSites('sitesCAD.txt')
	sitesNav = getSites('sitesNavigation.txt')
	error = doSites(siteparams,sitesCAD,sitesNav,startTime)
	etl.pprint('Completed ' + __file__)
	sys.stdout = stdout

	if error:
		raise Exception("Error in processing",res)

def doSites(params,sitesCAD,sitesNav,startTime):		
	error = False
	for site in sitesCAD:
		for param in params: # continue regardless of errors.
			ps = []
			for p in range(0,len(param)):
				if p == 0:
					ps.append(etl.getParam(param,p,'',site))
				else:
					ps.append(etl.getParam(param,p,'\"',site))
			comm = " ".join(ps).strip()
			if site in sitesNav and comm.find('runRoutingExtract.py') > 0:
				print('Nav ' + comm)
				res = subprocess.call(comm, shell=True)
			elif comm.find('runRoutingExtract.py') < 0:
				print('Site ' + comm)
				res = subprocess.call(comm, shell=True)
			print("result=" + str(res))
			if res != 0:
				error = True
			etl.pprint('Completed')
	etl.pprint('Completed Sites')
	return error

def getSites(sitetxt):

	sitefile = os.path.join(os.path.dirname(os.path.realpath(__file__)),sitetxt)
	with open(sitefile,'r') as infile:
		data = infile.read()
		sites = data.splitlines()
		print('Sites from ' + sitetxt  + ' ' + ' '.join(sites))
		infile.close()
	return sites
	
if __name__ == "__main__":
	main()
