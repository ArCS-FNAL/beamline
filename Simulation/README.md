# G4Beamline Simulation

To submit jobs to the grid, modify `Jobsubmit.sh` appropriately, then:
```
source setup.sh
source Jobsubmit.sh
```

G4Beamline input files are in `inputs/`. Description:

| Config | G4 Input File  | Description |
| ------------- | ------------- | ------------- |
| `JGG_test.g4bl`  | JGG only, for testing purposes  | Issues |
| config01 | `arcs_beamline_config01.in`  | Original simulation file from Supraja from 22aug2022, pos60Amps | MuRS overlaps concrete stand |
| config02 | `arcs_beamline_config02.in`  | Same as config01, but larger virtual detectors, from 2sep2022 | MuRS overlaps concrete stand |
| config03 | `arcs_beamline_config03.in`  | Same as config03, but with no MuRS, 25jun2025  | |
