#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tues Apr 18 11:35:49 2018

@author: celinede
"""

def selectRegions(inMat,inLut,inRegions,outMat):
    import pandas as pd
    import numpy as np

    lut = np.genfromtxt(inLut,dtype=str,delimiter='\n')

    if len(lut)==16:
        lut_d = {0:lut[0],1:lut[1],2:lut[2],3:lut[3],4:lut[4],5:lut[5],6:lut[6],7:lut[7],8:lut[8],
        9:lut[9],10:lut[10],11:lut[11],12:lut[12],13:lut[13],14:lut[14],15:lut[15]}
    else:
        print('Sorry, I don\'t know how to handle that ...')

    conMat = pd.DataFrame.from_csv(inMat,header=None,sep=' ',index_col=None)
    conMat = conMat.rename(lut_d,axis='columns')
    conMat = conMat.rename(lut_d,axis='rows')

    conMat_selected = conMat[inRegions]
    conMat_selected = conMat_selected.loc[inRegions]

    conMat_selected.to_csv(outMat,index=None,header=None,sep=' ')
