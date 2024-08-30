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
    out_file_name = args.filename[:-5] + '_simple.root'

file = uproot.open(args.filename)
# name = file.keys()[0]
# arrays = file[name].arrays()
# Adjust the keep_trees list to only include the desired trees
keep_trees = [
    'VirtualDetector/DetT1',
    'VirtualDetector/DetT2',
    'VirtualDetector/Det7',
    'VirtualDetector/JGGDet1',
]

with uproot.recreate(out_file_name) as output_file:
    for tree_name in keep_trees:
        output_file[tree_name] = file[tree_name].arrays()

