import sys
import csv

with open(sys.argv[1], 'rb') as csvfile:
    csv_reader = csv.reader(csvfile, delimiter=',')

    max_columns=0
    for row in csv_reader:
        if (len(row) > max_columns):
            max_columns = len(row)
    print max_columns
