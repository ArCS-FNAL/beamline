jobsub_submit --debug -G lariat --memory=500MB --expected-lifetime=20h -N 2 -l '+SingularityImage=\"/cvmfs/singularity.opensciencegrid.org/fermilab/fnal-wn-sl7:latest\"' --append_condor_requirements='(TARGET.HAS_SINGULARITY=?=true)' --resource-provides=usage_model=DEDICATED,OPPORTUNISTIC,OFFSITE --tar_file_name dropbox:///pnfs/lariat/persistent/users/suprajab/G4beamline-3.06_7june2022.tar -f /pnfs/lariat/resilient/users/suprajab/pos60Amps/MergeTrees.py -f /pnfs/lariat/resilient/users/suprajab/pos60Amps/LAriaT_13degProdxn_10degAna_SurveyedGeom_10000jobsof35k_64GeV_pos60Amps.in -f /pnfs/lariat/resilient/users/suprajab/pos60Amps/JGG.in -f /pnfs/lariat/resilient/users/suprajab/pos60Amps/MIPPFieldMapForG4Beamline.txt --use-cvmfs-dropbox file://$PWD/Script.sh






