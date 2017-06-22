### runSync.py - run a floorplan sync process with subprocesses
import os,sys,subprocess, time, traceback, multiprocessing, etl

timeout = 10
sites = ['UWS'] # add more later
sitefile = os.path.join(os.path.dirname(os.path.realpath(__file__)),'routingsites.txt')
with open(sitefile,'r') as infile:
	data = infile.read()
	sites = data.splitlines()
	print('Sites from routingsites.txt: ' + " ".join(sites))
pyt = r'C:\Python27\ArcGIS10.4\python.exe'
#pyt = "python.exe"
fme = "c:\\apps\\FME\\fme.exe"
etlFolder = "c:\\apps\\Gizinta\\gseUW\\ETL"
script = r"C:\Apps\Gizinta\gseUW\ETL\py\gseLoaderFME.py"
siteparams = []
siteparams.append([pyt,script,"rtLoadPlaylist.xml","gseDataConfig_%SITE%.xml"])

stdout = sys.stdout
sys.stdout = open(os.path.realpath(__file__) + '.log', "w+")

def main(argv = None):
	### Main function - loop through files
	res = 0
	etl.pprint('Starting ' + __file__)
	error = False
	doSites(siteparams)
	etl.pprint('Completed ' + __file__)
	sys.stdout = stdout

	if error:
		raise Exception("Error in processing",res)

def doSites(params):		
	error = False
	for site in sites:
		for param in params: # continue regardless of errors.
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
				error = True
			print("non-zero result")
	etl.pprint('Completed Sites')
	return error
	

if __name__ == "__main__":
	main()
