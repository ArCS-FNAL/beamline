bookdir=/pnfs/lariat/resilient/users/mdeltutt/beamline_bookdir
n_jobs=10

source /cvmfs/fermilab.opensciencegrid.org/products/common/etc/setups.sh
setup ifdhc

cp -f $PWD/MergeTrees.py ${bookdir}
cp -f $PWD/LAriaT_13degProdxn_10degAna_SurveyedGeom_10000jobsof35k_64GeV_pos60Amps.in ${bookdir}
cp -f ${PWD}/JGG.in ${bookdir}
cp -f ${PWD}/jgg_field_map.txt ${bookdir}

jobsub_submit --debug -G lariat --memory=500MB --expected-lifetime=20h -N ${n_jobs} \
    -l '+SingularityImage=\"/cvmfs/singularity.opensciencegrid.org/fermilab/fnal-wn-sl7:latest\"' \
    --append_condor_requirements='(TARGET.HAS_SINGULARITY=?=true)' \
    --resource-provides=usage_model=DEDICATED,OPPORTUNISTIC,OFFSITE \
    --tar_file_name dropbox:///pnfs/lariat/persistent/users/mdeltutt/G4beamline/G4beamline-3.06-06102024.tar \
    -f ${bookdir}/MergeTrees.py \
    -f ${bookdir}/LAriaT_13degProdxn_10degAna_SurveyedGeom_10000jobsof35k_64GeV_pos60Amps.in \
    -f ${bookdir}/JGG.in \
    -f ${bookdir}/jgg_field_map.txt \
    --use-cvmfs-dropbox file://$PWD/Script.sh

