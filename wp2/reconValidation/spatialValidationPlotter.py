# -*- coding: utf-8 -*-
"""
Created on Wed Jul 16 15:00:00 2020

where does each reanalysis perform best
spatially?

@author: Michael Tadesse
"""
import os 
import numpy as np
import pandas as pd 
import seaborn as sns
import matplotlib.pyplot as plt
#locate the file that basemap needs
os.environ["PROJ_LIB"] = "C:\\Users\\WahlInstall\\Anaconda3\\Library\\share\\basemap"
from mpl_toolkits.basemap import Basemap

def starter():
    twcrDat, era20cDat, eraintDat, merraDat = loadData()
    allCorr = processData(twcrDat, era20cDat, eraintDat, merraDat)[0]
    allRMSE = processData(twcrDat, era20cDat, eraintDat, merraDat)[1]

    return allCorr, allRMSE

def plotGlobal(metric):
    """
    this function plots the chosen metric 
    globallly using the basemap library

    metric = {'corr', 'rmse'}

    """
    #call processData here
    if metric == 'corr':
        dat = starter()[0]
        varToPlot = 'maxCorr'
        title = 'Pearson\'s Correlation - 1980-2010'
    else:
        dat = starter()[1]
        varToPlot = 'minRMSE'
        title = 'RMSE(m) - 1980-2010'

    #increase plot font size
    sns.set_context('notebook', font_scale = 1.5)
    
    plt.figure(figsize=(20, 10))
    m=Basemap(projection='cyl', lat_ts=20, llcrnrlon=-180, 
              urcrnrlon=180,llcrnrlat=-90,urcrnrlat=90, resolution='c')
    x,y = m(dat['lon'].tolist(), dat['lat'].tolist())
    m.drawcoastlines()

    #draw parallels and meridians 
    parallels = np.arange(-80,81,20.)
    m.drawparallels(parallels,labels=[True,False,False,False], linewidth = 0)

    m.bluemarble(alpha = 0.8) #basemap , alpha = transparency
    # plt.scatter(x, y, 70, marker = 'o', edgecolors = 'black', c = 
    #             dat[varToPlot], hue = dat['reanalysis'])
    
    #define markers
    markers = {"20CR": "X", "ERA-20C": "s", "ERA-Interim":'o', "MERRA":'^'}
    
    sns.scatterplot(x = x, y = y, s =80, markers = markers, style = 'reanalysis',\
                    hue = 'reanalysis', data = dat)
    # m.colorbar(location = 'bottom')

    # if metric == "corr":
    #     plt.clim(0, 1)
    # else:
    #     plt.clim(0,0.4)
        
    plt.title(title)



def processData(twcrDat, era20cDat, eraintDat, merraDat):
    """
    this function cleans and prepares
    the data for plotting
    """
    #merge everything
    twcr_era20c = pd.merge(twcrDat, era20cDat, on='tg', how='left')
    twcr_era20c_eraint = pd.merge(twcr_era20c, eraintDat, on='tg', how='left')
    twcr_era20c_eraint_merra = pd.merge(twcr_era20c_eraint, merraDat, on='tg', how='left')

    allCorr = twcr_era20c_eraint_merra[['tg', 'lon', 'lat', 'corrTwcr', 'corrEra20c', \
         'corrEraint', 'corrMerra']]
    allCorr.columns = ['tg', 'lon', 'lat', '20CR', 'ERA-20C', 'ERA-Interim', 'MERRA']
    allRMSE = twcr_era20c_eraint_merra[['tg', 'lon', 'lat',  'rmseTwcr', 'rmseEra20c',\
         'rmseEraint',  'rmseMerra']]
    allRMSE.columns = ['tg', 'lon', 'lat', '20CR', 'ERA-20C', 'ERA-Interim', 'MERRA']
    
    #get max corr values 
    allCorr['maxCorr'] = allCorr.iloc[:,4:].max(axis = 1)
    allCorr['reanalysis'] = allCorr.iloc[:, 4:8].idxmax(axis = 1)

    #get min rmse values 
    allRMSE['minRMSE'] = allRMSE.iloc[:,4:8].min(axis = 1)
    allRMSE['reanalysis'] = allRMSE.iloc[:, 4:8].idxmin(axis = 1)


    # allCorr.to_csv("allCorr.csv")
    # allRMSE.to_csv("allRMSE.csv")
    
    return allCorr, allRMSE

def loadData():
    """
    loads the relevant validation files
    """
        #dictionary for datasets
    data = {'twcr': ["twcr19802010Validation.csv", "20CR"],
            'era20c': ["era20c19802010Validation.csv", "ERA20C"],
            'eraint':["eraint19802010Validation.csv", "ERA-Interim"],
            'merra': ["merra19802010Validation.csv", "MERAA"]
            }
    os.chdir("D:\\data\\allReconstructions\\validation\\commonPeriodValidation")

    twcrDat = pd.read_csv(data['twcr'][0])
    twcrDat.columns = ['deleteIt','tg', 'lon', 'lat', 'reanalysis', 'corrTwcr', 'rmseTwcr']
    era20cDat = pd.read_csv(data['era20c'][0])
    era20cDat.columns = ['deleteIt','tg', 'long', 'latt', 'reanalysis', 'corrEra20c', 'rmseEra20c']
    eraintDat = pd.read_csv(data['eraint'][0])
    eraintDat.columns = ['deleteIt','tg', 'long', 'latt', 'reanalysis', 'corrEraint', 'rmseEraint']
    merraDat = pd.read_csv(data['merra'][0])
    merraDat.columns = ['deleteIt','tg', 'long', 'latt', 'reanalysis', 'corrMerra', 'rmseMerra']


    return twcrDat, era20cDat, eraintDat, merraDat
