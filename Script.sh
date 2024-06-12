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
source ${CONDOR_DIR_INPUT}/G4beamline-3.06_7june2022/G4beamline-3.06/bin/g4bl-setup.sh
source ${CONDOR_DIR_INPUT}/G4beamline-3.06_7june2022/G4beamline-3.06/root/bin/thisroot.sh

jobsize=100 #35000
SUBspillcount=10000
first=$((${PROCESS}*${jobsize}))
last=$(( ${first} + $jobsize - 1 ))
echo "PROCESS is: $PROCESS"
echo "jobsize is: $jobsize" 
echo "first = $first"
echo "last = $last"
SUBSPILL=$((${PROCESS}+1 ))

echo ${CONDOR_DIR_INPUT}
ls -lh ${CONDOR_DIR_INPUT}

g4bl ${CONDOR_DIR_INPUT}/LAriaT_13degProdxn_10degAna_SurveyedGeom_10000jobsof35k_64GeV_pos60Amps.in first=$first last=$last
if [[ $? -ne 0 ]]; then
   echo "The g4bl command failed"
   exit 1
fi
ls -lrth

chmod 777 sim_LAriaT_13degProdxn_10degAna_SurveyedGeom_10000jobsof35k_64GeV_pos60Amps.root
chmod 777 ${CONDOR_DIR_INPUT}/MergeTrees.py
${CONDOR_DIR_INPUT}/MergeTrees.py sim_LAriaT_13degProdxn_10degAna_SurveyedGeom_10000jobsof35k_64GeV_pos60Amps.root --subspillnumber $SUBSPILL --subspillcount $SUBspillcount
if [[ $? -ne 0 ]]; then
   echo "Running MergeTrees.py failed"
   exit 1
fi
chmod 777 MergedAtStartLinesim_LAriaT_13degProdxn_10degAna_SurveyedGeom_10000jobsof35k_64GeV_pos60Amps.root
chmod 777 MergedAtStartLinesim_LAriaT_13degProdxn_10degAna_SurveyedGeom_10000jobsof35k_64GeV_pos60Amps.pickle
ls -lrth

REALUSER=`basename ${X509_USER_PROXY} .proxy | grep -o -P '(?<=_).*(?=_)'`
echo '$USER: ' $USER
echo '$REALUSER: ' $REALUSER

ifdh cp MergedAtStartLinesim_LAriaT_13degProdxn_10degAna_SurveyedGeom_10000jobsof35k_64GeV_pos60Amps.root /pnfs/lariat/persistent/users/suprajab/BeamLineSimOutputs/17may2023/pos60Amps/MergedAtStartLinesim_LAriaT_13degProdxn_10degAna_SurveyedGeom_10000jobsof35k_64GeV_pos60Amps$SUBSPILL.root
if [[ $? -ne 0 ]]; then
   echo "Copying of the output ROOT file failed"
   exit 1
fi
ifdh cp MergedAtStartLinesim_LAriaT_13degProdxn_10degAna_SurveyedGeom_10000jobsof35k_64GeV_pos60Amps.pickle /pnfs/lariat/persistent/users/suprajab/BeamLineSimOutputs/17may2023/pos60Amps/MergedAtStartLinesim_LAriaT_13degProdxn_10degAna_SurveyedGeom_10000jobsof35k_64GeV_pos60Amps$SUBSPILL.pickle
if [[ $? -ne 0 ]]; then
   echo "Copying of the output pickle file failed"
   exit 1
fi
ls -lrth
echo $CONDOR_DIR_INPUT

#touch MyFile
#ifdh cp MyFile 
