# G4Beamline Simulation

To submit jobs to the grid, modify `Jobsubmit.sh` appropriately, then:
```
source setup.sh
source Jobsubmit.sh
```

G4Beamline input files are in `inputs/`. Description:

| G4 Input File  | Description |
| ------------- | ------------- |
| `arcs_beamline_22aug2024.in`  | Original simulation file from Supraja, pos60Amps |
| `arcs_beamline_2sep2024.in`  | Same as 22aug2024, but larger virtual detectors  |
| `JGG_test.g4bl`  | JGG only, for testing purposes  |
