import os
import datetime
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import matplotlib.gridspec as gridspec
import uproot
import math
from glob import glob
import awkward as ak
from matplotlib.colors import Normalize
from matplotlib.cm import get_cmap
%matplotlib inline

prop_cycle = plt.rcParams['axes.prop_cycle']
_colors = prop_cycle.by_key()['color']

##########################################################################################

_save_dir = 'plots/lariat_off_JGG_on/T0/'

colors = [
    '#2c5d77',  # Deep Sky Blue
    '#4a7a9b',  # Medium Blue Gray
    '#6a9bb9',  # Light Steel Blue
    '#94c7d6',  # Soft Blue
    '#cbe4eb',  # Slightly Darker Pale Blue 
    '#c1d0da',  # Light Blue Gray
    '#d1dce3',  # Darker Light Gray 
    '#e1e8ed'   # Very Light Gray
]


##########################################################################################

f = '/pnfs/lariat/persistent/users/gcicogna/BeamLineSimOutputs/pos60Amps/config09_2/merged_sim_arcs_beamline_simple_5706of30k_config09_2.root'

n_pions = 5706 * 30000
config = 'config09_2'

det_beam = ['StartLine', 'DetT0']
det_list = ['DetT0', 'Det7', 'JGGDet1']
#det_list = ['DetT2', 'Det7', 'JGGDet1']
det_four = ['DetT0', 'DetT2', 'Det7', 'JGGDet1']

##########################################################################################

file = uproot.open(f)
print('Detectors:', file.keys())

n_spills = n_pions / 2.5e5
n_hours = n_spills / 60
n_months = n_spills / 60 / 24 / 30

print('Number of pions:', n_pions)
print('Number of spills:', n_spills)
print('Number of hours:', n_hours)
print('Number of months:', n_months)

##########################################################################################

print('TTree variables:', file[f'VirtualDetector/JGGDet1'].keys())
print('Number of entries in StartLine:', file[f'VirtualDetector/StartLine'].num_entries)
#print('Number of entries in Det4:', file[f'VirtualDetector/Det4'].num_entries)
print('Number of entries in DetT0:', file[f'VirtualDetector/DetT0'].num_entries)
print('Number of entries in DetT1:', file[f'VirtualDetector/DetT1'].num_entries)
print('Number of entries in DetT2:', file[f'VirtualDetector/DetT2'].num_entries)
print('Number of entries in Det7:', file[f'VirtualDetector/Det7'].num_entries)
print('Number of entries in JGGDet1:', file[f'VirtualDetector/JGGDet1'].num_entries)

##########################################################################################

def add_vars_to_df(df):
    '''
    Adds total momentum, as well as theta and phi, to the dataframe
    '''

    px = df['Px'].values
    py = df['Py'].values
    pz = df['Pz'].values

    p = np.sqrt(px**2 + py**2 + pz**2)
    theta = np.arccos(pz / p) / np.pi * 180
    phi = np.arctan2(py, px) / np.pi * 180

    df['P'] = p
    df['theta'] = theta
    df['phi'] = phi

    return df

##########################################################################################

branches = ['x', 'y', 'z', 'Px', 'Py', 'Pz', 'PDGid', 'EventID', 'TrackID']

dfs = {} # dictionary to store dataframes, list accessible by detector name

#reading data from .root file

#dfs['StartLine'] = file[f'VirtualDetector/StartLine'].arrays(branches, library='pd')
dfs['DetT0'] = file[f'VirtualDetector/DetT0'].arrays(branches, library='pd')
#dfs['DetT1'] = file[f'VirtualDetector/DetT1'].arrays(branches, library='pd')
#dfs['DetT2'] = file[f'VirtualDetector/DetT2'].arrays(branches, library='pd')
dfs['Det7'] = file[f'VirtualDetector/Det7'].arrays(branches, library='pd')
dfs['JGGDet1'] = file[f'VirtualDetector/JGGDet1'].arrays(branches, library='pd')

#removing duplicates
#dfs['StartLine'] = dfs['StartLine'].drop_duplicates(['EventID', 'TrackID'])
dfs['DetT0'] = dfs['DetT0'].drop_duplicates(['EventID', 'TrackID'])
#dfs['DetT1'] = dfs['DetT1'].drop_duplicates(['EventID', 'TrackID'])
#dfs['DetT2'] = dfs['DetT2'].drop_duplicates(['EventID', 'TrackID'])
dfs['Det7'] = dfs['Det7'].drop_duplicates(['EventID', 'TrackID'])
dfs['JGGDet1'] = dfs['JGGDet1'].drop_duplicates(['EventID', 'TrackID'])

#adding total momentum, theta and phi to the dataframes
#dfs['StartLine'] = add_vars_to_df(dfs['StartLine'])
dfs['DetT0'] = add_vars_to_df(dfs['DetT0'])
#dfs['DetT1'] = add_vars_to_df(dfs['DetT1'])
#dfs['DetT2'] = add_vars_to_df(dfs['DetT2'])
dfs['Det7'] = add_vars_to_df(dfs['Det7'])
dfs['JGGDet1'] = add_vars_to_df(dfs['JGGDet1'])

# print(dfs['DetT1'])
# print(dfs['JGGDet1'])

# df2.loc[(df2['EventID'] == 29970112.0) & (df2['TrackID'] == 121664.0)

##########################################################################################

def merge_detectors(dfs, detector_names):
    '''
    Merges dataframes based on the provided detector names (return final merged df)

    - dfs (dict): Dictionary where keys are detector names and values are DataFrames.
    - detector_names (list): List of detector names to be merged *** in order ***.
    '''
    # Check if all detector names are present in the dfs
    missing_detectors = [det for det in detector_names if det not in dfs]
    if missing_detectors:
        raise ValueError(f"Detector names not found in dictionary: {', '.join(missing_detectors)}")
    
    if not detector_names:
        raise ValueError("detector_names list is empty")
    
    # Initialize the merged DataFrame with the first detector
    df_merged = dfs[detector_names[0]]
    
    # Loop through the remaining detectors and perform the appropriate merge
    for i in range(1, len(detector_names)):
        #print(f"Merging number: {i}")
        
        current_det = detector_names[i]
        prev_det = detector_names[i - 1]
        
        # Perform the merge
        df_merged = df_merged.merge(dfs[current_det], on=['EventID', 'TrackID'], how='left', indicator=f'_merge_{i}', suffixes=('_' + prev_det, '_' + current_det))
        
        # Keep only rows that are present in both detectors
        df_merged = df_merged[df_merged[f'_merge_{i}'] == 'both']
        
        # Drop redundant columns
        columns_to_drop = [col for col in df_merged.columns if col.startswith('PDGid_')]
        if columns_to_drop:
            df_merged = df_merged.drop(columns=columns_to_drop)
        
        # Check for columns without an underscore in the name, excluding 'EventID', 'TrackID', and 'PDGid_' columns
        columns_without_underscore = [col for col in df_merged.columns if (
            '_' not in col and col not in ['EventID', 'TrackID'] and not col.startswith('PDGid_'))]
        
        # Append the current detector's suffix to these columns
        rename_dict = {col: col + '_' + current_det for col in columns_without_underscore}
        df_merged = df_merged.rename(columns=rename_dict)

        #print(df_merged.head())

    df_merged = df_merged.rename(columns={f'PDGid_{detector_names[len(detector_names)-1]}':'PDGid'})
    
    return df_merged
    
##########################################################################################

detectors_to_merge = det_list
merged_df = merge_detectors(dfs, detectors_to_merge)
print(merged_df.columns)

##########################################################################################
