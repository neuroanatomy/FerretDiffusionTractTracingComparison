#!/bin/bash
# tract.sh
# multitissue CSD (CSF+WM)


inDwiDir=$1
inDwi=$2
inDwiMask=$3
outDir=$4
outsuffix=$5
nbfib=$6

mkdir "$outDir"

echo Response computation ...
dwi2response \
    dhollander \
    "$inDwiDir"/"$inDwi" \
    "$outDir"/response_wm.txt \
    "$outDir"/response_gm.txt \
    "$outDir"/response_csf.txt \
    -voxels "$outDir"/voxels_dhollander.mif \
    -force

echo FOD computation ...
dwi2fod \
    msmt_csd \
    -mask "$inDwiMask" \
    "$inDwiDir"/"$inDwi" \
    "$outDir"/response_wm.txt \
    "$outDir"/fod_wm.mif \
    "$outDir"/response_csf.txt \
    "$outDir"/fod_csf.mif \
    -force

echo Tracking ...
tckgen \
    "$outDir"/fod_wm.mif \
    "$outDir"/whole_msmt_dhollander"$outsuffix".tck \
    -seed_dynamic "$outDir"/fod_wm.mif \
    -mask "$inDwiMask" \
    -select "$nbfib" \
    -force
