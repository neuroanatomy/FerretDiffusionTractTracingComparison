#!/bin/bash
# tract_dti.sh
# DTI


inDwiDir=$1
inDwi=$2
inDwiMask=$3
outDir=$4
outsuffix=$5
nbfib=$6

mkdir "$outDir"


echo Tracking ...
tckgen \
    "$inDwiDir"/"$inDwi" \
    "$outDir"/whole_dti"$outsuffix".tck \
    -algorithm Tensor_Det \
    -seed_image "$inDwiMask" \
    -mask "$inDwiMask" \
    -select "$nbfib" \
    -force
