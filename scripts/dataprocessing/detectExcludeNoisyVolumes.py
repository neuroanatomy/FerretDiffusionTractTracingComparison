#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu Dec  7 10:53:22 2017

@author: celinede
"""

def detectNoisyVolumes(fdwi, fbvals):
    #imports
    import numpy as np
    import nibabel as nib

    #load files
    img = nib.load(fdwi)
    data = img.get_data()
    bvals = np.loadtxt(fbvals)

    #identify number of volumes
    bvals_rounded = bvals
    bvals_rounded[bvals_rounded < 50] = 0
    meanbval = np.mean(bvals_rounded[bvals_rounded != 0])
    bvals_rounded[bvals_rounded > 50] = int(round(meanbval, -3))
    nbvol = len(bvals_rounded)
    nbB0 = nbvol - np.count_nonzero(bvals_rounded)

    #compute mean signal for each volume
    means = []
    for i in range(nbvol):
        img_tmp = nib.Nifti1Image(data[:, :, :, i], img.affine)
        data_tmp = img_tmp.get_data()
        means.append(data_tmp.mean())

    #identify noisy volumes (2std away from total mean signal)
    std = np.std(means[nbB0:])
    mean = np.mean(means[nbB0:])
    noisyvol = []
    for i in range(nbB0, nbvol):
        if (means[i] > mean+(std * 2)) or (means[i] < mean - (std * 2)):
            noisyvol.append(i + 1)

    return noisyvol


def excludeNoisyVolumes(fdwi, fbvecs, fbvals, noisyvol, savedwi, savebvecs, savebvals):
    #imports
    import numpy as np
    import nibabel as nib

    #load files
    img = nib.load(fdwi)
    data = img.get_data()
    bvecs = np.loadtxt(fbvecs)
    bvals = np.loadtxt(fbvals)

    #create mask to exclude noisy volumes
    mask = np.ones(data.shape[3], dtype=bool)
    mask[noisyvol] = False

    #save nii without noisy volumes
    result = data[:, :, :, mask]
    img_masked = nib.Nifti1Image(result, img.affine)
    nib.save(img_masked, savedwi)

    #save bvecs bvals without noisy volumes
    bvecs_res = bvecs[:, mask]
    np.savetxt(savebvecs, bvecs_res)

    bvals_res = bvals[mask]
    np.savetxt(savebvals, bvals_res)
