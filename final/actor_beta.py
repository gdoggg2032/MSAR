import commands
import os
import time, datetime
import pyautogui as pag
from AppKit import NSWorkspace
import subprocess

class Actor():

	def __init__(self, actList, itemList):
		self.appPath = '/Applications/'
		self.actList = actList
		self.itemList = itemList

		#automatically add some app names
		#need to move this to link manager
		#for root, dirs, files, in os.walk(self.appPaths):
		#	self.itemList.append(os.path.join(root, name))
	def isApp(self, itemId, itemPath):
		currentAppPath = NSWorkspace.sharedWorkspace().activeApplication()['NSApplicationPath']
		currentApp = currentAppPath.split('/')[-1]
		if itemId != -1:
			assert itemId < len(self.itemList), "Actor::isApp: itemId not exist"
			app = self.itemList[itemId].split('/')[-1]
		else:
			app = itemPath.split('/')[-1]
		return currentApp == app

	def getCurrentLanguage(self):
		data = commands.getoutput("locale").split("\n")
		for locale in data:
			ltype, lan = locale.split("=")
			if ltype == "LANG":
				language, encoding = lan.split(".")
		return language, encoding
				


	def open(self, itemId, itemPath):
		if itemId != -1:
			assert itemId < len(self.itemList), "Actor::open: itemId not exist"
			instruction = "open " + self.itemList[itemId]
	 		os.system(instruction)
	 	else:
			instruction = "open " + itemPath
	 		os.system(instruction)
	 		

	def kill(self, itemId):
		#osascript -e 'quit app "/Applications/Calculator.app"'
		assert itemId < len(self.itemList), "Actor::kill: itemId not exist"
		instruction = "osascript -e \'quit app \"" + self.itemList[itemId] + "\"\'"
		os.system(instruction)

	#def trackpadControl(self, fingerNum, direction):
	#the gestures for trackpad are only links!!

	def switchDesktop(self, direction):

		#left = 0, right = 1
		if direction == 0:
			pag.hotkey('ctrl', 'left')
		elif direction == 1:
			pag.hotkey('ctrl', 'right')
		else:
			assert direction == 0 or direction == 1, "Actor::switchDesktop: wrong direction"
	
	def switchWindow(self, direction):
		#left = 0, right = 1
		if direction == 0:
			pag.hotkey('command', 'shift', '`')
		elif direction == 1:
			pag.hotkey('command', '`')
		else:
			assert direction == 0 or direction == 1, "Actor::switchWindow: wrong direction"
		
	def switchTabWindow(self, direction):
		#left = 0, right = 1
		if direction == 0:
			pag.hotkey('command', 'shift', '[')
		elif direction == 1:
			pag.hotkey('command', 'shift', ']')
		else:
			assert direction == 0 or direction == 1, "Actor::switchWindow: wrong direction"

	def musicControl(self, command):
		'''command: 0 = playpause
		            1 = prevtrack
		   			2 = nexttrack
		   			3 = volumedown
		   			4 = volumeup
		   			5 = mute'''
		if command == 0:
		   os.system("osascript -e 'tell application \"Spotify\" to playpause'")
		elif command == 1:
		   os.system("osascript -e 'tell application \"Spotify\" to previous track'")
		elif command == 2:
		   os.system("osascript -e 'tell application \"Spotify\" to next track'")
		elif command == 3:
			batcmd="osascript -e 'output volume of (get volume settings)'"
			vol = int(subprocess.check_output(batcmd, shell=True))
			vol = max(0, vol-20)
			cmd = "osascript -e 'set volume output volume "+str(vol)+"'"
			os.system(cmd)
		elif command == 4:
			batcmd="osascript -e 'output volume of (get volume settings)'"
			vol = int(subprocess.check_output(batcmd, shell=True))
			vol = min(100, vol+20)
			cmd = "osascript -e 'set volume output volume "+str(vol)+"'"
			os.system(cmd)
		elif command == 5:
			batcmd = "osascript -e 'output muted of (get volume settings)'"
			result = subprocess.check_output(batcmd, shell=True)
			if result == 'false\n':
				os.system("osascript -e 'set volume output muted true'")
			else:
				os.system("osascript -e 'set volume output muted false'")
				
		   	
	def gotoWeb(self, itemId, webName):
		appPath = self.appPath + 'Safari.app'
		self.open(-1, appPath)
		wait = 5
		startTime = time.time()
		success = 0
		while time.time() - startTime < 5:
			if self.isApp(-1, appPath):
				success = 1
				break
		assert success == 1, "Exceed Waiting Time: " + str(wait)
		pag.hotkey('command', 'l')	
		time.sleep(1)
		if itemId != -1:
		  assert itemId < len(self.itemList), "Actor::gotoWeb: itemId not exist"
		  pag.typewrite(self.itemList[itemId]+'\n', interval=0.05)
		else:
			pag.typewrite(webName+'\n', interval=0.05)
	def facebookPost(self):
		self.gotoWeb(-1,'www.facebook.com')
		time.sleep(3)
		pag.press('p')
		currentTime = '{:%Y-%b-%d %H:%M:%S}'.format(datetime.datetime.now())
		context = 'Hello, facebook!\n\nSent from Music: Project -- ' + currentTime+'\n'
		pag.typewrite(context, interval=0.2)
		loc = pag.locateOnScreen('./post_zh.png')
		if loc:
			pos = pag.center(loc)
			pag.click(pos[0]/2, pos[1]/2)
		else:
			pos = pag.center(pag.locateOnScreen('./post.png'))
			pag.click(pos[0]/2, pos[1]/2)
	def selfDefineAction(self, actId, itemId):
		assert itemId < len(self.itemList), "Actor::selfDefineAction: itemId not exist"
		assert actId < len(self.actList), "Actor::selfDefineAction: actId not exist"
		instruction = self.actList[actId] + " " + self.itemList[itemId]
		os.system(instruction)
if __name__ == "__main__":

	actList = ['echo']
	itemList = ['/Applications/Calculator.app', \
		'/Applications/Utilities/Terminal.app', \
		'hahaBenChouhaha','www.google.com', 'www.youtube.com']

	actor = Actor(actList, itemList)
	actor.musicControl(0)
	time.sleep(3)
	actor.musicControl(0)
	time.sleep(3)
	actor.musicControl(0)
	time.sleep(3)
	actor.musicControl(1)
	time.sleep(3)
	actor.musicControl(2)
	time.sleep(3)
	actor.musicControl(3)
	time.sleep(3)
	actor.musicControl(4)
	time.sleep(3)
	actor.musicControl(5)
	time.sleep(3)
	actor.musicControl(5)
	time.sleep(3)
	#actor.gotoWeb(3,"")
	#time.sleep(3)
	#actor.facebookPost()
	
