#!/bin/bash
source /cvmfs/larsoft.opensciencegrid.org/setup_larsoft.sh
source /cvmfs/fermilab.opensciencegrid.org/products/common/etc/setups.sh
setup ifdhc
setup g4abla v3_1
setup g4emlow v7_9_1
setup g4nuclide v2_2
setup g4incl v1_0
setup g4neutronxs v1_4
setup g4particlexs v2_1
setup g4pii v1_3
setup g4tendl v1_3_2
setup g4photon v5_5
setup g4radiative v5_4
setup g4surface v2_1_1
source ${CONDOR_DIR_INPUT}/G4beamline-3.06-06102024/G4beamline-3.06/bin/g4bl-setup.sh
source ${CONDOR_DIR_INPUT}/G4beamline-3.06-06102024/G4beamline-3.06/root/bin/thisroot.sh

jobsize=$JOBSIZE
SUBspillcount=10000
first=$((${PROCESS}*${jobsize}))
last=$(( ${first} + $jobsize - 1 ))
echo "PROCESS is: $PROCESS"
echo "jobsize is: $jobsize" 
echo "first = $first"
echo "last = $last"
echo "OUTDIR = $OUTDIR"
echo "BFIELD = $BFIELD"
echo "BSCALE = $BSCALE"
SUBSPILL=$((${PROCESS}+1 ))

echo
echo "running echo CONDOR_DIR_INPUT"
echo ${CONDOR_DIR_INPUT}
echo

echo "Copy relevat files here"
cp ${CONDOR_DIR_INPUT}/*.in .
cp ${CONDOR_DIR_INPUT}/*.txt .
cp ${CONDOR_DIR_INPUT}/*.py .
echo "Available files in this directory:"
ls -lh .

echo ${INPUT_TAR_DIR_LOCAL}
ls -lh ${INPUT_TAR_DIR_LOCAL}
echo

echo ${CONDOR_DIR_INPUT}
ls -lh ${CONDOR_DIR_INPUT}
echo 

echo "Running g4bl"
g4bl arcs_beamline.in first=$first last=$last BFIELD=$BFIELD BSCALE=$BSCALE
if [[ $? -ne 0 ]]; then
   echo "The g4bl command failed"
   exit 1
fi
ls -lrth

chmod 777 sim_arcs_beamline.root
chmod 777 MergeTrees.py

echo "Running MergeTrees.py"
MergeTrees.py sim_arcs_beamline.root --subspillnumber $SUBSPILL --subspillcount $SUBspillcount
if [[ $? -ne 0 ]]; then
   echo "Running MergeTrees.py failed"
   exit 1
fi
chmod 777 MergedAtStartLinesim_arcs_beamline.root
chmod 777 MergedAtStartLinesim_arcs_beamline.pickle
ls -lrth

REALUSER=`basename ${X509_USER_PROXY} .proxy | grep -o -P '(?<=_).*(?=_)'`
echo '$USER: ' $USER
echo '$REALUSER: ' $REALUSER
echo 'Copying files to ', $OUTDIR

ifdh mkdir ${OUTDIR}/files/

ifdh cp sim_arcs_beamline.root ${OUTDIR}/files/sim_arcs_beamline_$SUBSPILL.root
if [[ $? -ne 0 ]]; then
   echo "Copying of the g4bl output ROOT file failed"
   exit 1
fi
ifdh cp MergedAtStartLinesim_arcs_beamline.root ${OUTDIR}/files/MergedAtStartLinesim_arcs_beamline_$SUBSPILL.root
if [[ $? -ne 0 ]]; then
   echo "Copying of the output ROOT file failed"
   exit 1
fi
ifdh cp MergedAtStartLinesim_arcs_beamline.pickle ${OUTDIR}/files/MergedAtStartLinesim_arcs_beamline_$SUBSPILL.pickle
if [[ $? -ne 0 ]]; then
   echo "Copying of the output pickle file failed"
   exit 1
fi

ls -lrth
echo $CONDOR_DIR_INPUT

#touch MyFile
#ifdh cp MyFile 
