#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu Nov 30 15:15:49 2017

@author: celinede
"""

#import fire

#def print2(text, text2):
 #   print text
  #  print text2


def eddyCorrect(inDwi, output):
    from nipype.interfaces import fsl

    eddyc = fsl.EddyCorrect()
    eddyc.inputs.in_file = inDwi
    eddyc.inputs.out_file = output
    eddyc.inputs.ref_num = 0
    eddyc.run()

def excludeNoisyVolumes(inDwi, inBvecs, inBvals, outDwi, outBvecs, outBvals):
    #import sys
    #sys.path.insert(0, '../')
    import detectExcludeNoisyVolumes as nv

    noisyvol = nv.detectNoisyVolumes(inDwi, inBvals)
    print('number of excluded volumes :', len(noisyvol))
    nv.excludeNoisyVolumes(inDwi, inBvecs, inBvals, noisyvol, outDwi, outBvecs, outBvals)
