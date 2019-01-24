#!/bin/bash
# processall.sh

###subject id
subs=(
  'F01_Adult')


for ((i=0;i<=${#subs[@]};i++));
#for sub in "${subs[@]}"
do
sub=${subs[i]}

home=/home/celine
inDwiDir=$home/ferret-mri-annex/data/derived/dwi/$sub/mrtrix
inDwi=dwi.nii.gz
inBvDir=$home/ferret-mri-annex/data/derived/converted/$sub/dwi
inBvecs=bvecs.txt
inBvals=bvals.txt
inDwiMaskDir=$home/ferret-mri-annex/data/derived/converted/$sub/seg-pial-dwi

outDwiDir=$home/ferret-mri-annex/scratch/work_celine/compDiffTT/data/dwi/$sub
outBvDir=$home/ferret-mri-annex/data/derived/converted/$sub

echo ---Start preproc "$sub"---
./preproc.sh "$inDwiDir" "$inDwi" "$inBvDir" "$inBvecs" "$inBvals" "$outDwiDir" "$outBvDir"

echo ---Start tracking "$sub"---
rep=1
nbfib=1000000    #1000000
nbfibname=1M    #1M

echo $nbfib
	for ((r=0; r<rep; r++))
	do
		outsuffix=_${nbfibname}_${r}

    echo -- DTI tracking "$sub" -
		./tract_dti.sh "$inDwiDir" dwi.volexcl.denoised.degibbs.eddy.unbiased_ants.mif \
      "$inDwiMaskDir"/ref_to_b0.sel.nii.gz \
      "$outDwiDir" "$outsuffix" "$nbfib"

    echo -- DTI tracking Prob "$sub" -
		./tract_dti_prob.sh "$inDwiDir" dwi.volexcl.denoised.degibbs.eddy.unbiased_ants.mif \
      "$inDwiMaskDir"/ref_to_b0.sel.nii.gz \
      "$outDwiDir" "$outsuffix" "$nbfib"

    echo -- CSD tracking "$sub" --
		./tract_csd_SD.sh "$inDwiDir" dwi.volexcl.denoised.degibbs.eddy.unbiased_ants.mif \
		  "$inDwiMaskDir"/ref_to_b0.sel.nii.gz \
		  "$outDwiDir" "$outsuffix" "$nbfib"

    echo -- CSD tracking iFOD2 "$sub" --
    ./tract_csd_iFOD2.sh "$inDwiDir" dwi.volexcl.denoised.degibbs.eddy.unbiased_ants.mif \
      "$inDwiMaskDir"/ref_to_b0.sel.nii.gz \
      "$outDwiDir" "$outsuffix" "$nbfib"

    echo -- MSMT CSD tracking "$sub" --
		./tract_msmt_csd_wmcsf.sh "$inDwiDir" dwi.volexcl.denoised.degibbs.eddy.unbiased_ants.mif \
      "$inDwiMaskDir"/ref_to_b0.sel.nii.gz \
			"$outDwiDir" "$outsuffix" "$nbfib"

    echo -- MSMT CSD tracking "$sub" --
    ./tract_msmt_csd_wmcsf_SD.sh "$inDwiDir" dwi.volexcl.denoised.degibbs.eddy.unbiased_ants.mif \
      "$inDwiMaskDir"/ref_to_b0.sel.nii.gz \
		  "$outDwiDir" "$outsuffix" "$nbfib"

	 done

done
