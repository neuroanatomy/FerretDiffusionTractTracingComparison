#!/bin/bash
# preproc.sh

inDwiDir=$1
inDwi=$2
inBvDir=$3
inBvecs=$4
inBvals=$5
outDwiDir=$6
outBvDir=$7

mkdir -p "$outDwiDir"

# exclude noisy volumes
n0=$outDwiDir/dwi.volexcl
bvecs=$outBvDir/bvecs.volexcl.txt
bvals=$outBvDir/bvals.volexcl.txt
echo Exclude noisy volumes ...
runp preproc.py excludeNoisyVolumes:"$inDwiDir"/"$inDwi","$inBvDir"/"$inBvecs","$inBvDir"/"$inBvals","$n0".nii.gz,"$bvecs","$bvals"

# convert
mrconvert "$n0".nii.gz -fslgrad "$bvecs" "$bvals" "$n0".mif -force

# lpca denoise
n1="$n0".denoised
echo LPCA denoising ...
dwidenoise "$n0".mif "$n1".mif -force

# gibbs ringing correction
n2="$n1".degibbs
echo DeGibbs ...
mrdegibbs "$n1".mif "$n2".mif -force
mrconvert "$n2".mif "$n2".nii.gz -force

# eddy current correction
n3="$n2".eddy
echo Eddy correction ...
runp preproc.py eddyCorrect:"$n2".nii.gz,"$n3".nii.gz

# b1 bias correct
n4="$n3".unbiased_ants
echo Bias correction ...
dwibiascorrect "$n3".nii.gz "$n4".mif -ants -fslgrad "$bvecs" "$bvals" -force
mrconvert "$n4".mif "$n4".nii.gz -force

# corse mask
dwi2mask "$n4".mif "${n4}"_mask.nii.gz -force
