#!/bin/bash -e

while [ -z $matlabpath ]
do
echo -n 'Please enter your MATLAB installation path: '
read matlabpath
done

matlabpath=${matlabpath%/}

echo Patching...
patch "${matlabpath}/toolbox/stats/stats/kmeans.m" -i kmeans_2011b_patch.txt -o kmeans3.m
echo Copying statinsertnan...
cp "${matlabpath}/toolbox/stats/stats/private/statinsertnan.m" ./statinsertnan2.m
echo Copying statremovenan...
cp "${matlabpath}/toolbox/stats/stats/private/statremovenan.m" ./statremovenan2.m
echo Copying parseArgs...
cp "${matlabpath}/toolbox/stats/stats/+internal/+stats/parseArgs.m" ./parseArgs2.m
echo Copying getParamVal...
cp "${matlabpath}/toolbox/stats/stats/+internal/+stats/getParamVal.m" ./getParamVal2.m
echo Patch Succeeded! Accelerated version is now available as function 'kmeans3'.
