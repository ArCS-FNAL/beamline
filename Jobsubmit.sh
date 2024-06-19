export BOOKDIR=/pnfs/lariat/resilient/users/mdeltutt/beamline_bookdir
export OUTDIR=/pnfs/lariat/persistent/users/mdeltutt/BeamLineSimOutputs/pos60Amps/test/

# Number of jobs to submit
export NJOBS=2 # 10000

# Number of pions on target per job
export JOBSIZE=10 # 35000

# Bending magnets fields
export BFIELD=-0.2121 # 60 Amps
# export BFIELD=-0.3361 # 100 Amps
export BSCALE=+1 # pos
# export BSCALE=-1 # neg

mkdir -p ${OUTDIR}

cp -f ${PWD}/arcs_beamline.in ${BOOKDIR}
cp -f ${PWD}/JGG.in ${BOOKDIR}
cp -f ${PWD}/jgg_field_map.txt ${BOOKDIR}
cp -f ${PWD}/MergeTrees.py ${BOOKDIR}

jobsub_submit -G lariat --memory=500MB --expected-lifetime=23h -N ${NJOBS} \
-l '+SingularityImage=\"/cvmfs/singularity.opensciencegrid.org/fermilab/fnal-wn-sl7:latest\"' \
--append_condor_requirements='(TARGET.HAS_SINGULARITY=?=true)' \
--resource-provides=usage_model=DEDICATED,OPPORTUNISTIC,OFFSITE \
--tar_file_name dropbox:///pnfs/lariat/persistent/users/mdeltutt/G4beamline/G4beamline-3.06-06102024.tar \
-f ${BOOKDIR}/MergeTrees.py \
-f ${BOOKDIR}/LAriaT_13degProdxn_10degAna_SurveyedGeom_10000jobsof35k_64GeV_pos60Amps.in \
-f ${BOOKDIR}/JGG.in \
-f ${BOOKDIR}/jgg_field_map.txt \
--use-cvmfs-dropbox \
-e OUTDIR \
-e JOBSIZE \
-e BFIELD \
-e BSCALE \
--mail_always \
--debug file://$PWD/Script.sh


# Also copy the file to a config directory for bookkeping
mkdir -p ${OUTDIR}/config/
cp -f ${PWD}/arcs_beamline.in ${OUTDIR}/config/
cp -f ${PWD}/JGG.in ${OUTDIR}/config/
cp -f ${PWD}/jgg_field_map.txt ${OUTDIR}/config/
cp -f ${PWD}/MergeTrees.py ${OUTDIR}/config/
cp -f ${PWD}/Script.sh ${OUTDIR}/config/
cp -f ${PWD}/Jobsubmit.sh ${OUTDIR}/config/
