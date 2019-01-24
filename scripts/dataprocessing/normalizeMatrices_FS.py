#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec 12 09:41:49 2018

@author: celinede
"""

import os
import numpy as np

def plusOne(path, fileName, extension, saveDir):
    conMat = np.genfromtxt(path+fileName+extension, delimiter=' ')
    conMat_norm = np.empty(conMat.shape)
    for y in range(conMat.shape[1]):
        for x in range(conMat.shape[0]):
            conMat_norm[x, y] = conMat[x, y]+1

    if not os.path.exists(saveDir):
        os.makedirs(saveDir)
    np.savetxt(saveDir+fileName+'_1plus'+extension, conMat_norm, delimiter=' ')

def diagZero(path, fileName, extension, saveDir):
    conMat = np.genfromtxt(path+fileName+extension, delimiter=' ')
    conMat_dzero = np.copy(conMat)

    for x in range(conMat.shape[0]):
        conMat_dzero[x, x] = 0

    if not os.path.exists(saveDir):
        os.makedirs(saveDir)
    np.savetxt(saveDir+fileName+'_dzero'+extension, conMat_dzero, delimiter=' ')

def normalize(path, fileName, extension, saveDir):
    conMat = np.genfromtxt(path+fileName+extension, delimiter=' ')
    conMat_norm = np.empty(conMat.shape)
    for y in range(conMat.shape[1]):
        for x in range(conMat.shape[0]):
            if conMat[x, y] == 0:
                conMat_norm[x, y] = 0
            else:
                conMat_norm[x, y] = conMat[x, y] / (np.sum(conMat[x, :])+np.sum(conMat[:, y]))

    if not os.path.exists(saveDir):
        os.makedirs(saveDir)
    np.savetxt(saveDir+fileName+'_normFS'+extension, conMat_norm, delimiter=' ')

def symeterize(path, fileName, extension, saveDir):
    conMat = np.genfromtxt(path+fileName+extension, delimiter=' ')
    conMat_norm = np.empty(conMat.shape)
    for y in range(conMat.shape[1]):
        for x in range(conMat.shape[0]):
            conMat_norm[x, y] = (conMat[x, y]+conMat[y, x])/2

    if not os.path.exists(saveDir):
        os.makedirs(saveDir)
    np.savetxt(saveDir+fileName+'_sym'+extension, conMat_norm, delimiter=' ')


path = '/home/celine/ferret-mri-annex/scratch/work_celine/compDiffTT/data/connectomes/F01_Adult/selected/'
extension = '.csv'
saveDir = '/home/celine/ferret-mri-annex/scratch/work_celine/compDiffTT/data/connectomes/F01_Adult/selected/processed/'

files = [   'connectomeBizley_whole_dti_1M_0_weights_selected',
            'connectomeBizley_whole_dti_Prob_1M_0_weights_selected',
            'connectomeBizley_whole_csd_SD_1M_0_weights_selected',
            'connectomeBizley_whole_csd_iFOD2_1M_0_weights_selected',
            'connectomeBizley_whole_msmt_dhollander_SD_1M_0_weights_selected',
            'connectomeBizley_whole_msmt_dhollander_1M_0_weights_selected']

#path = '/home/celine/ferret-mri-annex/scratch/work_celine/compDiffTT/data/Bizley2009/'
#saveDir = '/home/celine/ferret-mri-annex/scratch/work_celine/compDiffTT/data/Bizley2009/'
#files = ['retrogradeTT_raw']

for f in files:
    fileName = f
    diagZero(path, fileName, extension, saveDir)
    fileName1 = fileName + '_dzero'
    normalize(saveDir, fileName1, extension, saveDir)
    fileName2 = fileName1 + '_normFS'
    symeterize(saveDir, fileName2, extension, saveDir)

    fileName = f
    plusOne(path, fileName, extension, saveDir)
    fileName1 = fileName + '_1plus'
    diagZero(saveDir, fileName1, extension, saveDir)
    fileName2 = fileName1 + '_dzero'
    normalize(saveDir, fileName2, extension, saveDir)
    fileName3 = fileName2 + '_normFS'
    symeterize(saveDir, fileName3, extension, saveDir)
