### runSync.py - Extract RT data since yesterday and include all exterior lines.
import os,sys,subprocess, datetime, time, etl

timeout = 10
sites = ['UWS'] # add more later
fname = 'routingsites.txt'
sitefile = os.path.join(os.path.dirname(os.path.realpath(__file__)),fname)
with open(sitefile,'r') as infile:
	data = infile.read()
	sites = data.splitlines()
	print('Sites from ' + fname + ': ' + " ".join(sites))
	
pyt = r'C:\Python27\ArcGIS10.4\python.exe'
fme = "c:\\apps\\FME\\fme.exe"
etlFolder = "c:\\apps\\Gizinta\\gseUW\\ETL"
routeparams = []
rtFolder = os.path.join(etlFolder,"batch","Routing")

today = datetime.datetime.now()
day = datetime.timedelta(days=1)
yesterday = today - day
#extractSince = yesterday.strftime("%m/%d/%Y %I:%M %p")
extractSince = yesterday.strftime("%Y%m%d%H%M%S")
print ('Extracting since ' +  extractSince)

routeparams.append([fme,os.path.join(rtFolder,"RT_Extract.fmw"),'--Extract_Since',extractSince])
stdout = sys.stdout
sys.stdout = open(os.path.realpath(__file__) + '.log', "w+")

def main(argv = None):
        
	### Main function - loop through files
	res = 0
	etl.pprint('Starting ' + __file__)
	error = False
	doSites(routeparams)
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
	etl.pprint('Completed Extract')
	return error
	

if __name__ == "__main__":
	main()
