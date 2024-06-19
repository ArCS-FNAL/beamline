BOOKDIR=/pnfs/lariat/resilient/users/mdeltutt/beamline_bookdir
OUTDIR=/pnfs/lariat/persistent/users/mdeltutt/BeamLineSimOutputs/pos60Amps/test/
NJOBS=10000

# Bending magnets fields
BFIELD=-0.2121 # 60 Amps
BFIELD=-0.3361 # 100 Amps
BSCALE=+1 # pos

mkdir -p ${OUTDIR}

cp -f ${PWD}/MergeTrees.py ${BOOKDIR}
cp -f ${PWD}/LAriaT_13degProdxn_10degAna_SurveyedGeom_10000jobsof35k_64GeV_pos60Amps.in ${BOOKDIR}
cp -f ${PWD}/JGG.in ${BOOKDIR}
cp -f ${PWD}/jgg_field_map.txt ${BOOKDIR}

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
    -e BFIELD \
    -e BSCALE \
    --mail_always \
#    --debug \
    file://$PWD/Script.sh

