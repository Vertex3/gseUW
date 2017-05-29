### runSync.py - run a floorplan sync process with subprocesses
import os,sys,subprocess, time, traceback, multiprocessing

timeout = 10

def getParam(params,num,enc,site):
	param = ''
	if len(params) > num:
		if params[num].startswith('/') or params[num].startswith('--'):
			enc = ''
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
		p.join(timeout)	# Wait
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
	for item in args:
		print(str(item))
	if len(args) > 0:
		print('\n')

if __name__ == "__main__":
	main()
