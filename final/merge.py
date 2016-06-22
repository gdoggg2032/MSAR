#!/usr/bin/env python
# -*- coding: utf-8 -*-
import pyaudio, librosa, mlabwrap
import os, sys, time, signal
import wave
import speech_recognition as sr
from numpy.linalg import norm
import numpy as np
from dtw import dtw
from threading import *
from actor_beta import Actor

STOP_POINT = 1000
CHUNK = 8192
FORMAT = pyaudio.paInt16
CHANNELS = 1
RATE = 44100

CHUNK_BUFFER_SIZE = 10
chunks = []
exitThread = False



class Recorder(Thread):

	def __init__(self, con, chunk, format, channels, rate, chunk_buffer_size):
		Thread.__init__(self)
		
		RECORD_SECONDS = 2147483647
		self.p = pyaudio.PyAudio()
		self.con = con
		self.chunk = chunk
		self.format = format
		self.channels = channels
		self.rate = rate
		self.chunk_buffer_size = chunk_buffer_size

	def run(self):
		global chunks
		self.stream = self.p.open(format=self.format, channels=self.channels, rate=self.rate, input=True, frames_per_buffer=self.chunk)

		print "* Recording audio..."
		while (True):
			data = self.stream.read(CHUNK)
			
			self.con.acquire()
			chunks.append(data)
			if len(chunks) > self.chunk_buffer_size:
				chunks = chunks[(len(chunks)-self.chunk_buffer_size):]
			self.con.release()
			if counter > STOP_POINT:
				break

def read_from_recorder(con, num_chunk):
	if chunks:
		return chunks
	return []

# def segmenting(data):
# 	# Running EPD and trim the files to tmp2.wav
# 	mlab.run('myTest.m')
# 	y0, sr0 = librosa.load('tmp2.wav')
# 	mfcc0 = librosa.feature.mfcc(y0, sr0)
# 	mspec0 = librosa.feature.melspectrogram(y0, sr0)

def stretch_signal(v1, v2, path):
	# stretch v2 to the equal length of v1
	nv = []
	pass
	# for i in range(len(v1))



def write2wav(frame, fileName, p):
	waveFile = wave.open(fileName, 'wb')
	waveFile.setnchannels(CHANNELS)
	waveFile.setsampwidth(p.get_sample_size(FORMAT))
	waveFile.setframerate(RATE)
	waveFile.writeframes(b''.join(frame))
	waveFile.close()

def getDistances(f1, f2):
	mfcc1 = f1[0]
	mspec1 = f1[1]
	mfcc2 = f2[0]
	mspec2 = f2[1]
	
	dist, cost, acc, path = dtw(mfcc1.T, mfcc2.T, dist=lambda x, y: norm(x - y, ord=2))
	# print path
	dist2, cost2, acc2, path2 = dtw(mspec1.T, mspec2.T, dist=lambda x, y: norm(x - y,ord=2))	
	return dist + dist2, dist * dist2
	
def getSimpleDistance(mfcc0, mfcc1):
	dist, cost, acc, path = dtw(mfcc0.T, mfcc1.T, dist=lambda x, y: norm(x - y, ord=2))
	return dist

def getFeatures(data, play):
	write2wav(data, 'wavFile/tmp.wav', play)
	write2wav(data, 'tmp/check' + str(counter) + '.wav', play)
	# os.system("ffmpeg -loglevel panic -i wavFile/tmp.wav -af \"volume=-20dB\" -y wavFile/tmp.wav")
	# os.system("ffmpeg -loglevel panic -i wavFile/tmp.wav -af \"volume=4.0\" -y wavFile/tmp.wav")
	### Endpoint detection ###
	targetdB = -25
	mlab.run('myTest.m')
	print 'loading EPDed file'
	os.system('cp wavFile/tmp.wav tmp/check' + str(counter) + '_2.wav')
	os.system('ffmpeg-normalize -f --level ' + str(targetdB) + ' wavFile/tmp.wav')
	y1, sr1 = librosa.load('wavFile/normalized-tmp.wav')
	mfcc1 = librosa.feature.mfcc(y1, sr1)
	mspec1 = librosa.feature.melspectrogram(y1, sr1)
	return [mfcc1, mspec1]

def loadGroundTruth(lst):
	ret = []
	for name in lst:
		y0, sr0 = librosa.load('ground_truth/normalized-' + name + '.wav')
		mfcc0 = librosa.feature.mfcc(y0, sr0)
		mspec0 = librosa.feature.melspectrogram(y0, sr0)
		ret.append((name, (mfcc0, mspec0)))
	return ret

def getAllDistances(f1, GTF):
	distances = []

	mfcc1 = f1[0]
	mspec1 = f1[1]
	for instance in GTF:
		mfcc2 = instance[1][0]
		mspec2 = instance[1][1]
		dist, cost, acc, path = dtw(mfcc1.T, mfcc2.T, dist=lambda x, y: norm(x - y, ord=2))
		dist2, cost2, acc2, path2 = dtw(mspec1.T, mspec2.T, dist=lambda x, y: norm(x - y,ord=2))	
		# print "#####LEN", len(mfcc1.T), len(mfcc1.T[0])
		# print "#####LEN", len(mfcc2.T), len(mfcc2.T[0])
		# print "#####DLEN", len(path[0])
		distances.append((instance[0], dist + dist2))
	return distances

def doAction(actor, apps, paras, buff):
	if buff[0] == 'open':
		actor.open(apps.index(buff[1]), '')
		# try:
		# 	actor.open(apps.index(buff[1]), '')
		# except:
		# 	print "Application " + buff[1] + " is not defined"
		pass
	elif buff[0] == 'kill':
		actor.kill(apps.index(buff[1]))
		# try:
		# 	actor.kill(apps.index(buff[1]))
		# except:
		# 	print "Application " + buff[1] + " is not defined"
		pass
	elif buff[0] == 'switchDesktop':
		try:
			actor.switchDesktop(paras.index(buff[1]) - 6)
		except:
			print "Direction " + buff[1] + " is not defined"
	elif buff[0] == 'switchTabWindow':
		try:
			actor.switchTabWindow(paras.index(buff[1]) - 6)
		except:
			print "Direction " + buff[1] + " is not defined"
	elif buff[0] == 'musicControl':
		try:
			actor.musicControl(paras.index(buff[1]))
		except:
			print 'Music command ' + buff[1] + ' is not defined'
	elif buff[0] == 'gotoWeb':
		try:
			actor.gotoWeb(-1, buff[1])
		except:
			print 'Web ' + buff[1] + ' is not defined'
	elif buff[0] == 'facebookPost':
		try:
			actor.facebookPost()
		except:
			print 'This must be GDogs fault'


def main():
	print 'loading...'
	# Loading mlabwrap to enable matlab usage
	global mlab
	mlab = mlabwrap.init()

	global counter
	counter = 0
	l = ['/Applications/Sublime\ Text\ 2.app', '/Applications/Spotify.app', '/Applications/Safari.app', '/Applications/Keynote.app', 'www.youtube.com', 'www.facebook.com']
	actor = Actor([], l)
	
	#### Pu_Ro_Jay features ####

	initialF = loadGroundTruth(['pu_ro_jay'])
	instructF = loadGroundTruth(['open', 'kill', 'gotoWeb', 'switchDesktop', 'switchTabWindow', 'facebookPost', 'musicControl'])
	apps = ['sublime', 'spotify', 'safari', 'keynote', 'youtube', 'facebook']
	appsF = loadGroundTruth(apps)
	paras = ['playpause', 'prevtrack', 'nexttrack', 'volumedown', 'volumeup', 'mute','left', 'right']
	parasF = loadGroundTruth(paras)
	
	con = Condition()
	Recorder(con, CHUNK, FORMAT, CHANNELS, RATE, CHUNK_BUFFER_SIZE).start()
	# signal.signal(signal.SIGINT, signal_handler_SIGINT)

	time.sleep(5)

	tmpData = []

	play=pyaudio.PyAudio()
	stream_play = play.open(format=FORMAT, channels=CHANNELS, rate=RATE, output=True)
	print "* Start playing"
	data = ""
	# counter = 0
	frame = []
	dists = [10000, 10000]

	DETECTING_FLAG = 0
	INSTRUCT_FLAG = 0
	SECOND_FLAG = 0
	buff = []

	while(1):
		
		
		data = read_from_recorder(con, 1)

		if tmpData != data:
			print counter
			counter += 1
			f1 = getFeatures(data, play)

			# write2wav(data, 'wavFile/tmp' + str(counter) + '_.wav', play)
			
			if DETECTING_FLAG == False:
				DETECTING_FLAG = True
				# f1 = getFeatures(data, play)
				tmpDist = getDistances(f1, initialF[0][1])[0]
				dists.pop(0)
				dists.append(tmpDist)
				print tmpDist

				if sum(dists) < 180:
					print "DETECTING!!"
					DETECTING_FLAG = True
					#counter = STOP_POINT + 1
					#break 

			elif INSTRUCT_FLAG == False:
				tmpDists = getAllDistances(f1, instructF)
				newList = sorted(tmpDists, key = lambda t: t[1])
				for tup in newList:
					print tup[0], tup[1]
				m = min(tmpDists, key = lambda t: t[1])
				if m[1] < 93:
					### instruction name ###
					INSTRUCT_FLAG = True
					buff.append(m[0])
					print m[0]
					# ['open', 'kill', 'gotoWeb', 'switchDesktop', 'switchTabWindow', 'facebookPost', 'musicControl']
					if m[0] == 'open' or m[0] == 'kill':
						os.system('say what')
					elif m[0] == 'gotoWeb' or m[0] == 'switchTabWindow' or m[0] == 'switchDesktop':
						os.system('say 哪邊')
					elif m[0] == 'musicControl':
						os.system('say 請說')
					# counter = STOP_POINT + 1
					# break
					if m[0] == 'facebookPost':
						os.system('say okay')
						doAction(actor, apps, paras, buff)
						buff = []
						DETECTING_FLAG = False
						INSTRUCT_FLAG = False
					
				
			else:
				print "PARA"
				tmpDists = []
				if buff[0] == 'open' or buff[0] == 'kill' or buff[0] == 'gotoWeb':
					tmpDists = getAllDistances(f1, appsF)
				else:
					tmpDists = getAllDistances(f1, parasF)
				newList = sorted(tmpDists, key = lambda t: t[1])
				for tup in newList:
					print tup[0], tup[1]
				m = min(tmpDists, key = lambda t: t[1])
				if m[1] < 93:
					buff.append(m[0])
					print m[0]
					os.system('say okay')
					doAction(actor, apps, paras, buff)
					buff = []
					DETECTING_FLAG = False
					INSTRUCT_FLAG = False
				
			tmpData = data

			if counter > STOP_POINT:
				break
		
	stream_play.stop_stream()
	stream_play.close()
	# play.terminate()

if __name__ == "__main__":

	try:
		main()
	except KeyboardInterrupt:
		exitapp = True
		raise
