### runSync.py - Extract RT data start yesterday and include all exterior lines.
import os,sys,subprocess, datetime, time, etl


site = sys.argv[1]
startTime = sys.argv[2]

print(site + ' last run ' + str(startTime))
	
pyt = r'C:\Python27\ArcGIS10.4\python.exe'
fme = "c:\\apps\\FME\\fme.exe"
etlFolder = "c:\\apps\\Gizinta\\gseUW\\ETL"
routeparams = []
rtFolder = os.path.join(etlFolder,"batch","Routing")

print ('Extracting since ' +  startTime)

routeparams.append([fme,os.path.join(rtFolder,"RT_Extract.fmw"),'--Extract_Since',startTime])
stdout = sys.stdout
sys.stdout = open(os.path.realpath(__file__) + '.log', "w+")

def main(argv = None):

	### Main function - loop through files
	res = 0
	etl.pprint('Starting ' + __file__)
	error = False
	doSite(routeparams)
	etl.pprint('Completed ' + __file__)
	sys.stdout = stdout

	if error:
		raise Exception("Error in processing",res)

def doSite(params):		
	error = False
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
