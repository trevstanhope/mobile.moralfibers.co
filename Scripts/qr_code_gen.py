# QRCode generator
# Specifically for Moral Fibers
# written by Joseph Pintozzi
# Creates 10-digit serial code and hash for the url

import re, string, sys, ast, os, time, base64
import httplib, urllib

# change this as needed
# This wil be the PHP script that checks to see if a serial # is registered already or not
baseURL = "http://moralfibers.net/iphone/qrscan.php?"

# python qr_code_gen.py <# TO START AT> <# of QR CODES WANTED>
startingnum = int(sys.argv[1])
count = int(sys.argv[2])

numbers = range(startingnum, count + startingnum)
# loooooooop
for i in numbers:
	# algorithm goes here
	num1 = str(i)[:-5]
	num2 = str(i)[-5:]
	tots = int(num1) + int(num2)
	hashy = base64.b64encode(str(tots))
	# algorithm stops here, value stored in "hashy"
	fullURL = baseURL + urllib.urlencode( { 'serial': str(i) , "key": str(hashy)})
	
	print fullURL
	f = urllib.urlopen("http://qrcode.kaywa.com/img.php?s=5&d=" + urllib.quote(fullURL))
	image = f.read()
	
	# now save file
	fout = open(str(i) + ".png", "wb")
	fout.write(image)
	fout.close()