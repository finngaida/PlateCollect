#geocodebing.py
#Script to geocode addresses in a text file seperated by \n 
#with Bing Maps API
#(better ratelimit than google)


import urllib
import time
import json
baseURL="http://dev.virtualearth.net/REST/v1/Locations/"
bingKey = "" #get your own on http://www.bingmapsportal.com/  (basic key)
def geocode(address):
  response = urllib.urlopen(baseURL+address.replace(" ","%20")+"?o=json&key="+bingKey).read() #format url and off we go
  print baseURL+address.replace(" ","%20")+"?o=json&key="+bingKey
  print response
  coords = json.loads(response)["resourceSets"][0]['resources'][0]['geocodePoints'][0]['coordinates']
  print coords
  lat = str(coords[0])
  lon = str(coords[1])
  return lat+","+lon

def main():
  output = open('output.txt','w+')
  for line in open("addresses.txt",'r'):
    output.write(line + "," +geocode(line.replace('\n',''))+"\n")

if __name__ == '__main__':
  main()