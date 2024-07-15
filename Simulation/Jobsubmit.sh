export BOOKDIR=/pnfs/lariat/resilient/users/mdeltutt/beamline_bookdir
export OUTDIR=/pnfs/lariat/persistent/users/mdeltutt/BeamLineSimOutputs/pos60Amps/config06_1/
export G4BNBINPUT=arcs_beamline_config06.in
export OUTFILE=sim_arcs_beamline

# Number of jobs to submit
export NJOBS=10000

# Number of pions on target per job
export JOBSIZE=30000

# Bending magnets fields
export BFIELD=-0.2121 # 60 Amps pos
# export BFIELD=-0.3361 # 100 Amps pos
# export BFIELD=0.2121 # 60 Amps neg
# export BFIELD=0.3361 # 100 Amps neg

# Copy all neded files to a folder on resilient
mkdir -p ${OUTDIR}
cp -f ${PWD}/inputs/${G4BNBINPUT} ${BOOKDIR}
cp -f ${PWD}/inputs/JGG.in ${BOOKDIR}
cp -f ${PWD}/inputs/jgg_field_map.txt ${BOOKDIR}
cp -f ${PWD}/MergeTrees.py ${BOOKDIR}
cp -f ${PWD}/make_skimmed_trees.py ${BOOKDIR}
cp -f ${PWD}/make_g4bl_simple_trees.py ${BOOKDIR}

# Submit grid job
jobsub_submit -G lariat --memory=500MB --expected-lifetime=23h -N ${NJOBS} \
-l '+SingularityImage=\"/cvmfs/singularity.opensciencegrid.org/fermilab/fnal-wn-sl7:latest\"' \
--append_condor_requirements='(TARGET.HAS_SINGULARITY=?=true)' \
--resource-provides=usage_model=DEDICATED,OPPORTUNISTIC,OFFSITE \
--tar_file_name dropbox:///pnfs/lariat/persistent/users/mdeltutt/G4beamline/G4beamline-3.06-06102024.tar \
-f ${BOOKDIR}/$G4BNBINPUT \
-f ${BOOKDIR}/JGG.in \
-f ${BOOKDIR}/jgg_field_map.txt \
-f ${BOOKDIR}/MergeTrees.py \
-f ${BOOKDIR}/make_skimmed_trees.py \
-f ${BOOKDIR}/make_g4bl_simple_trees.py \
--use-cvmfs-dropbox \
-e OUTDIR \
-e JOBSIZE \
-e G4BNBINPUT \
-e OUTFILE \
-e BFIELD \
--debug file://$PWD/Script.sh


# Also copy the file to a config directory for bookkeping
mkdir -p ${OUTDIR}/config/
cp -f ${PWD}/inputs/${G4BNBINPUT} ${OUTDIR}/config/
cp -f ${PWD}/inputs/JGG.in ${OUTDIR}/config/
cp -f ${PWD}/inputs/jgg_field_map.txt ${OUTDIR}/config/
cp -f ${PWD}/MergeTrees.py ${OUTDIR}/config/
cp -f ${PWD}/make_skimmed_trees.py ${OUTDIR}/config/
cp -f ${PWD}/make_g4bl_simple_trees.py ${OUTDIR}/config/
cp -f ${PWD}/Script.sh ${OUTDIR}/config/
cp -f ${PWD}/Jobsubmit.sh ${OUTDIR}/config/
