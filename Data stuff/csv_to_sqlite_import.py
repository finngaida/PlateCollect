#!/usr/bin/python
# This script imports the csv file into a prepared sqlite database
# Made by Niklas Riekenbrauck

import csv
import sqlite3 as lite
import sys

def console_log(output):
	print output
	
def create_array():
	csv_data = open("stolpersteine.csv","r")
	read_data = csv.reader(csv_data, dialect='excel', delimiter=',', quotechar='"',skipinitialspace=True)
	lines =[]
	for line in read_data:
		lines.append(line)
		print line
	console_log("Finished array creation")	
	return lines
	
def insert_array_in_sqlite(array):
	connection = None
	try:
		connection = lite.connect('stolpersteine_final.sqlite')
		connection.text_factory = str 
		
		with connection:
			cursor = connection.cursor()
			for line_item in array:
				
				cursor.execute('SELECT location_id FROM location WHERE adress = ? AND neighbourhood = ?' , (line_item[4],line_item[5],))
				location_id_row = cursor.fetchall()
				location_id = None
				if len(location_id_row) == 0:
					cursor.execute('INSERT INTO location (adress, neighbourhood, longitude, latitude, city, country) VALUES (?,?,?,?,?,?)',(line_item[4],line_item[5],line_item[15],line_item[14],"Berlin","Deutschland",))
					connection.commit()
					cursor.execute('SELECT location_id FROM location WHERE adress = ? AND neighbourhood = ?' , (line_item[4],line_item[5],))
					location_id_row = cursor.fetchall()

				location_id = location_id_row[0][0]
				
				cursor.execute('INSERT INTO stolperstein(firstname, lastname, birthname, birthday, place_of_death, day_of_death, location_id) VALUES (?,?,?,?,?,?,?)' , (line_item[0],line_item[2], line_item[1],line_item[3],line_item[13],line_item[12],location_id,))
				connection.commit()
				
				cursor.execute('SELECT last_insert_rowid()')
				st_id_row = cursor.fetchall()
				st_id = st_id_row[0][0]
				print st_id
				if (len(line_item[6])> 0 or len(line_item[7]) > 0):
					cursor.execute('INSERT INTO deportation (st_id, dep_index, date, destination) VALUES (?,?,?,?)', (st_id, 0,line_item[6],line_item[7],))
					
				if (len(line_item[8])> 0 or len(line_item[9]) > 0):
					cursor.execute('INSERT INTO deportation (st_id, dep_index, date, destination) VALUES (?,?,?,?)', (st_id,1,line_item[8],line_item[9],))
					
				if (len(line_item[10])> 0 or len(line_item[11]) > 0):
					cursor.execute('INSERT INTO deportation (st_id, dep_index, date, destination) VALUES (?,?,?,?)', (st_id,2,line_item[10],line_item[11],))
				
				connection.commit()
		console_log("Finished insert")
				
	except lite.Error, e:
		print ("SQLite Error: %s:" % e.args[0])
		sys.exit(1)
    	
	finally:
		if connection:
			connection.close()
	
def main():
	text_factory = str
	csv_array = create_array()
	insert_array_in_sqlite(csv_array)
	
if __name__ == '__main__':
	main()
	

