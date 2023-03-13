# importing pandas module
import pandas as pd
import json
import sys
from openpyxl import load_workbook

# input excel file path
try:
    inputExcelFile = str(sys.argv[1])
except: 
     inputExcelFile = 'gcp_projects.xlsx'

#deletes highlighted rows in excel
wb = load_workbook(inputExcelFile, data_only = True,)
sh = wb['Sheet1']
excelDF = []
for row in sh:
    if row[0].fill.start_color.index == '00000000':
        excelDF.append([row[i].value for i in range(len(row))])
        
#Target excel columns
projectID = "Project ID"
violationDetails = "Violation Detail"

# Reading in new excel df 
excelFile = pd.DataFrame(excelDF[1:],columns=excelDF[0])
excelFile = excelFile.dropna(axis=1,how='all').dropna()
gcpItems = excelFile.loc[::,[projectID,violationDetails]]
gcpItems = gcpItems.values.tolist()

#parsing for csv conversion
csvDict = {}
for e in gcpItems:
    violations= json.loads(e[1].replace("'", '"'))[1] #necessary to turn str into list
    vStr = ""
    for v in violations:
        vStr +=v+','
    csvDict[e[0]] = vStr[:-1]

#creating csv file
with open("gcp_projects.csv", 'w') as file:
    for key, value in csvDict.items():
        file.write(f"{key},{value}\n")
