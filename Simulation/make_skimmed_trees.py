import argparse
import uproot

parser = argparse.ArgumentParser(
                    prog='Skimmer',
                    description='Filters out events with no tracks and makes one tree for each detector')

parser.add_argument('filename')
parser.add_argument('-o', '--outname', default=None)
args = parser.parse_args()

print('Using input file', args.filename)

out_file_name = args.outname

if out_file_name is None:
    out_file_name = args.filename[:-5] + '_skimmed.root'

file = uproot.open(args.filename)
name = file.keys()[0]
arrays = file[name].arrays()

with uproot.recreate(out_file_name) as output_file:
    
    # for det in ['Det1', 'Det2', 'Det3', 'Det4', 'Det5', 'Det6', 'Det7', 'Det8', 'TOFus', 'TOFds']:
    # for det in ['Det3', 'Det4', 'Det5', 'Det6', 'Det7', 'Det8', 'TOFus', 'TOFds']:
    for det in ['Det3', 'Det4', 'Det5', 'Det6', 'Det7', 'DetT1', 'DetT2', 'JGGDet1', 'JGGDet2', 'JGGDet3', 'TOFus', 'TOFds']:
        
        mask = arrays[f'TrackPresent{det}'] == True
        output_file[f'Events{det}'] = arrays[mask]

