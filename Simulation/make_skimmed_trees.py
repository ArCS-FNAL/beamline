import argparse
import uproot

parser = argparse.ArgumentParser(
                    prog='Skimmer',
                    description='Filters out events with no tracks and makes one tree for each detector')

parser.add_argument('filename')
args = parser.parse_args()

print('Using input file', args.filename)

out_file_name = args.filename[:-5] + '_skimmed.root'

file = uproot.open(args.filename)
name = file.keys()[0]
arrays = file[name].arrays()

with uproot.recreate(out_file_name) as output_file:
    
    for det in ['Det1', 'Det2', 'Det3', 'Det4', 'Det5', 'Det6', 'Det7', 'Det8', 'TOFus', 'TOFds']:
        
        if f'TrackPresent{det}' not in arrays:
          continue

        mask = arrays[f'TrackPresent{det}'] == True
        output_file[f'Events{det}'] = arrays[mask]

