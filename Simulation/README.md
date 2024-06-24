# G4Beamline Simulation

To submit jobs to the grid, modify `Jobsubmit.sh` appropriately, then:
```
source setup.sh
source Jobsubmit.sh
```

G4Beamline input files are in `inputs/`. Description:

| G4 Input File  | Description |
| ------------- | ------------- |
| `JGG_test.g4bl`  | JGG only, for testing purposes  | Issues |
| `arcs_beamline_22aug2022.in`  | Original simulation file from Supraja, pos60Amps | MuRS overlaps concrete stand |
| `arcs_beamline_2sep2022.in`  | Same as 22aug2022, but larger virtual detectors  | MuRS overlaps concrete stand |
| `arcs_beamline_24jun2024.in`  | Same as 2sep2022, but with no MuRS  | |
