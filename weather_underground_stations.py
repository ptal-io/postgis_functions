# ============================================================
# Author: Grant McKenzie (gmck@umd.edu)
# Date: April 20, 2017
# Client: UMD Geography 376
# Description: This script loops through a list of stations 
#	that were accessed via a URL and tells me which ones have
#	data for january 2011.
# ============================================================

import urllib
import json


# Function for loading the URL (I gave you in lab) with the station ID and checking to see if data exists for the station in 2011
def loadStationData(station):
	# This is the link, I just replaced the station
	link = "https://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID={}&year=2011&month=1&graphspan=month&format=1".format(station)
	response = urllib.urlopen(link)
	content = response.read()
	# If the amount of data at the URL is more than just the header, TELL ME
	if (len(content) >  300):
		print "{} HAS DATA!!!!!!!".format(station)
	else:
		print "{} has no data".format(station)

# This is a URL with a bunch of stations in it.  I got it from the weatherunderground map
jsonurl = "https://stationdata.wunderground.com/cgi-bin/stationdata?iconsize=8&width=512&height=512&maxage=3600&format=json&maxstations=100&rf_filter=1&minlat=38.54762840618702&minlon=-76.2883758544922&maxlat=38.82205601494022&maxlon=-75.9368133544922"

# call the URL to get the data and parse the JSON format that is returned
response = urllib.urlopen(jsonurl)
data = json.load(response)   

# loop through all the stations
for station in data['conds']:
	loadStationData(station)