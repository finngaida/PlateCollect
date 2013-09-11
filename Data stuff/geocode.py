#geocode.py
#Script to geocode Addresses in a file seperated by \n to Lat/Lon
#with Google Maps API
#(very strict rate limit sadly, also they seem to 'remember' the data so you can't do it from another maschine)
#outputs file with lines: address,latitude,longitude 

import urllib
import time
import json
baseURL="http://maps.googleapis.com/maps/api/geocode/json?address="

def geocode(address):
  response = urllib.urlopen(baseURL+address.replace(" ","+")+"&sensor=false").read()
  coords = json.loads(response)["results"][0]["geometry"]["location"] 
  lat = str(coords["lat"])
  lon = str(coords["lng"])
  return lat+","+lon

def main():
  output = open('output.txt','w+')
  for line in open("addresses.txt",'r'):
    output.write(line[:-1] + "," +geocode(line)+"\n")#:-1 to remove \n

if __name__ == '__main__':
  main()