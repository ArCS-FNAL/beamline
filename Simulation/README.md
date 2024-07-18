# G4Beamline Simulation

To submit jobs to the grid, modify `Jobsubmit.sh` appropriately, then:
```
source setup.sh
source Jobsubmit.sh
```

## Input Files

G4Beamline input files are in `inputs/`. Description:

| Config | G4 Input File  | Description |
| ------------- | ------------- | ------------- |
| `JGG_test.g4bl`  | JGG only, for testing purposes  | Known Issues |
| config01 | `arcs_beamline_config01.in`  | Original simulation file from Supraja from 22aug2022, pos60Amps | MuRS overlaps concrete stand |
| config02 | `arcs_beamline_config02.in`  | Same as config01, but larger virtual detectors, from 2sep2022 | MuRS overlaps concrete stand, Wrong Y for JGG |
| config03 | `arcs_beamline_config03.in`  | Same as config03, but with no MuRS, 25jun2025  | JGG too far away, also in previous versions, Wrong Y for JGG |
| config04 | `arcs_beamline_config04.in`  | Same as config03, but with JGG closer  | Wrong Y for JGG |
| config05 | `arcs_beamline_config05.in`  | Same as config04, but with proper JGG implementation and field. Y corrected to 0. | |
| config06 | `arcs_beamline_config06.in`  | Same as config05, but LArIAT bending magnets field can be set with BFIELD | Det8 overlaps with JGG group volume and particles were not saved in this volume. |
| config07 | `arcs_beamline_config07.in`  | Same as config06, but Det8 has been removed. We have JGGDet1, JGGDet2, JGGDet3 instead, placed at 1/4, 1/2, and 3/4 of the JGG. They no longer overlap with the JGG volume. | |
| config08 | `arcs_beamline_config08.in`  | Same as config07, but with two disks of 5 mm of steel to emulate the cryostat front face, plus 50 mm of LAr before the TPC. These items are just before JGGDet1, which is still at 1/4 of the JGG. | |


## Productions

Produced files are in
```
/pnfs/lariat/persistent/users/mdeltutt/BeamLineSimOutputs/
```

| Name | Input  | Description |
| ------------- | ------------- | ------------- |
| `config03`  | config03  | Nominal |
| `config04`  | config04  | Nominal |
| `config05`  | config05  | Nominal |
| `config05_2`  | config05  | Added script to make simpler G4Beamline output files |
| `config06_1`  | config06  | BFIELD=-0.2121. Same as 05... |
| `config07_1`  | config07  | BFIELD = 0. Turn off LArIAT magnets. |


## Useful Commands

Check status of all your jobs: `jobsub_q -G lariat`
Remove all your jobs: `jobsub_rm -all  -G lariat`

To run the simulation on Mac, for testing, go to the `inputs` folder, then:
```
/Applications/G4beamline-3.08.app/Contents/MacOS/g4bl arcs_beamline_config07.in first=0 last=10 BFIELD=-0.2
```
