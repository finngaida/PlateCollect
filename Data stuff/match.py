# -*- coding: utf-8 -*-
#match.py
#Script to match up geocoded coordinates to entries in the CSV
#via the Address field
#by Daniel Petri

csv = open("stolpersteine.csv","r")
newcsv=open("final.csv","w+")
addresslist = open("betterout.txt","r")
addresslines=addresslist.readlines()

def coordsForAddress(address):
  for line in addresslines: #loop through address list to find matching address
    addresspart = line.split(",")[0]
    if addresspart == address:
      return ","+line.split(",")[1]+","+line.split(",")[2]


def fullStringForLine(line):
    comps = line.split(',')
    address=comps[4] # Address is 5th component
    #print coordsForAddress(coordsForAddress)
    return line[:-1]+coordsForAddress(address) #:-1 to remove \n. Append coordinates

def main():
  lines = csv.readlines()
  for line in lines:
    newcsv.write(fullStringForLine(line))



if __name__ == '__main__':
  main()