import sys
import csvkit
import pandas as pd

# calculate R style summary on a the column in a csv file
# arguments
# 1 - column number (1 start idx)
# 2...ns - file names

def main():
    # print >> sys.stderr, sys.argv
    print "filename, count, mean, std, min, 25pct, median, 75pct, max"
    column = int(sys.argv[1]) - 1
    filenames = sys.argv[2:]
    for filename in filenames:
        processFile(column, filename)

def processFile(column, filename):
    dataValues = [] # the data
    with open(filename, 'r') as csvData:
        csvReader = csvkit.reader(csvData, delimiter=',', quotechar='"', skipinitialspace=True)
        for row in csvReader:
            dataValues.append(int(row[column]))
    dataSeries = pd.Series(dataValues)
    dataDescription = dataSeries.describe()
    descriptonStr = [str(e) for e in dataDescription.tolist()]
    descriptonStr.insert(0, filename)
    print ", ". join(descriptonStr)
    # print(dataDescription)

if __name__ == "__main__":
    main()
