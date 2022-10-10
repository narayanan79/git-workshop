#!/usr/bin/python

import psycopg2
import csv
#conn = psycopg2.connect(database="xxx", user="xx", password="xx", host="xxx", port="1234")

cur = conn.cursor()
try:
    cur.execute("""select

 build_id,
 grn, build_state,
 build_name,
'FreeBSD Current' as build_flag,
 'Daily' as build_schedule,
 Component_Date as Date
 from test.test_tab
""")
except:
    print "Error Connecting to database"
with open('/host/sdc-filer1/vol/junosbuild/junosbuild/METRICS/DailyBuildData/storm_build_data.csv', 'w') as f:
    writer = csv.writer(f, delimiter=',')
    rows = cur.fetchall()
    hed = ['Build Id', 'GRN','Build State', 'Build Name', 'Build Flag', 'Build Schedule', 'Date']
    writer.writerow(hed)
    for row in rows:
	if row[2] == "PASSED" or row[2] == "Archived" or row[2] == "Posted":
	    build_state_val = 1
	else:
	    build_state_val = 0
 #       print "   ", row[1],row[2],row[3],row[4],row[5],row[6]
	row1 = [row[0],row[1],build_state_val,row[3],row[4],row[5],row[6]]
        writer.writerow(row1)

conn.close()
