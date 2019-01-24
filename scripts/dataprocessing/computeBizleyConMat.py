#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tues Apr 18 09:29:49 2018
Updated on Tues Sept 11 11:29:49 2018
@author: celinede
"""

import sys
import os
import subprocess
import pandas as pd
import normalizeMatrix as nm
import diagonalToZero as dz
import selectRegionsInConMat as sr

home='/home/celine'

sub = 'F01_Adult'
nbfib = '1M'
tcknames = ['whole_csd_SD_1M_',
'whole_dti_1M_',
'whole_msmt_dhollander_1M_',
'whole_csd_iFOD2_1M_',
'whole_dti_Prob_1M_',
'whole_msmt_dhollander_SD_1M_'
]
it = 1

for tname in tcknames:
    for i in range(it):
        tck = tname + str(i)

        #### compute connectomes from parcellation ####
        inTck = home+'/ferret-mri-annex/scratch/work_celine/compDiffTT/data/dwi/'+sub+'/'+tck+'.tck'
        inParc = home+'/ferret-mri-annex/scratch/work_celine/compDiffTT/data/dwi/'+sub+'/Bizley2009_flirt_uint32_conv.nii.gz'

        outConnPath = home+'/ferret-mri-annex/scratch/work_celine/compDiffTT/data/connectomes/'+sub+'/'
        subprocess.call(['mkdir',outConnPath])

        fileNameW = 'connectomeBizley_'+tck+'_weights'
        outConnW = outConnPath+'/'+fileNameW+'.csv'
        subprocess.call(['mkdir',outConnPath+'/length'])
        fileNameL = 'connectomeBizley_'+tck+'_lengths'
        outConnL = outConnPath+'/length/'+fileNameL+'.csv'

        subprocess.call(['tck2connectome',inTck,inParc,outConnW,'-symmetric','-force','-assignment_end_voxels'])
        subprocess.call(['tck2connectome',inTck,inParc,outConnL,'-symmetric','-scale_length','-stat_edge','mean','-force','-assignment_end_voxels'])

        #### select regions to compare with TT ####
        outSelectW = outConnPath+'/selected/'
        subprocess.call(['mkdir',outSelectW])
        outSelectL = outConnPath+'/length/selected/'
        subprocess.call(['mkdir',outSelectL])

        inLut = '/home/celine/ferret-mri-annex/scratch/work_celine/compDiffTT/data/Bizley2009/LUT.csv'
        TTfile = '/home/celine/ferret-mri-annex/scratch/work_celine/compDiffTT/data/Bizley2009/retrogradeTT.csv'
        TT_conMat = pd.DataFrame.from_csv(TTfile,header=0,index_col=0)

        outSelectMatW = outSelectW+'/'+fileNameW+'_selected.csv'
        sr.selectRegions(outConnW,inLut,TT_conMat.columns.values,outSelectMatW)

        outSelectMatL = outSelectL+'/'+fileNameL+'_selected.csv'
        sr.selectRegions(outConnL,inLut,TT_conMat.columns.values,outSelectMatL)

