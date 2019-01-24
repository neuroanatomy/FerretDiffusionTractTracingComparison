#!/bin/bash
# tract_csd.sh
# CSD


inDwiDir=$1
inDwi=$2
inDwiMask=$3
outDir=$4
outsuffix=$5
nbfib=$6

mkdir "$outDir"

echo Response computation ...
dwi2response \
    tournier \
    "$inDwiDir"/"$inDwi" \
    "$outDir"/response_tournier.txt \
    -voxels "$outDir"/voxels_tournier.mif \
    -force

echo FOD computation ...
dwi2fod \
    csd \
    "$inDwiDir"/"$inDwi" \
    "$outDir"/response_tournier.txt \
    "$outDir"/fod_tournier.mif \
    -mask "$inDwiMask" \
    -force

echo Tracking ...
tckgen \
    "$outDir"/fod_tournier.mif \
    "$outDir"/whole_csd_SD"$outsuffix".tck \
    -algorithm SD_STREAM \
    -seed_image "$inDwiMask" \
    -mask "$inDwiMask" \
    -select "$nbfib" \
    -force
