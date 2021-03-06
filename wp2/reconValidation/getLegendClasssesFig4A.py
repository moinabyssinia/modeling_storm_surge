# -*- coding: utf-8 -*-
"""
Created on Tue Feb 09 10:50:35 2021

add a column of marker size - to create 
only four classes of legends with distinct
sizes - for correlation - to plot figure 4A

@author: Michael Tadesse
"""
import os
import pandas as pd

os.chdir("G:\\data\\allReconstructions\\validation\\"\
             "commonPeriodValidationExtremes\\percentile")

#load corr/rmse/rrmse files
dat = pd.read_csv("allCorr.csv")
dat.drop('Unnamed: 0', axis = 1, inplace = True)

#find the four classes - look at std histogram

##rmse - [1, 2, 4, 6]

dat['size'] = 'nan'

for ii in range(len(dat)):
    row = dat['metricSTD'][ii] #already std
    print(row)
    if (row <= 0.25):
        dat['size'][ii] = 50
    elif ((row > 0.25) & (row < 0.5)):
        dat['size'][ii] = 250
    elif ((row >= 0.5) & (row < 0.75)):
        dat['size'][ii] = 500
    elif ((row >= 0.75) & (row <= 1.0)):
        dat['size'][ii] = 750
    else:
        "something is wrong!"
        
#save as csv
dat.to_csv("corrSTDFixedLegend.csv")