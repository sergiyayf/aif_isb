"""

getting establishment statistics

"""

import pandas as pd 
import h5py 
import numpy as np

def get_establishment_statistics(collectionname,switching_time,w_escape):
    """
    get establishment probabilities of switched clones
    
    Input
    ----
    collection name, or maybe better red and blue clones 
    
    
    Returns
    -------
    
    number of all switched 
    number of switched and survived 
    width of red clones that did switch
    
    """
    # open data file 
    h5File = 'chist/data/ER_data_collection.h5'
    f = h5py.File(h5File, 'r')
    # loop through all the colonies in this collection
    escaped_number = 0
    switched_number = 0
    red_cells = 0 
    for ds in f['data/'+collectionname].keys(): 
        # get clones trajectories Red, Blue and Total dataframes
        R_df = pd.read_hdf(h5File, 'data/'+collectionname+'/'+ds+'/red')
        B_df = pd.read_hdf(h5File, 'data/'+collectionname+'/'+ds+'/blue')
        T_df = R_df.add(B_df, axis=1,fill_value=0)
        
        # loop through all blue clones
        switched_number+=len(B_df.keys())
        for key in B_df.keys(): 
            # get width 
            b_w = B_df[key].values
            # get switching radius 
            rho_star = B_df.index[switching_time]
            rad = B_df.index
            # get the width of corresponding red clone one timepoint before 
            r_w = R_df[key].values[switching_time-1]
            if ~np.isnan(r_w):
                red_cells+=r_w
            # find out if escaped in 2500 microns
            idx = np.abs(rad-rho_star-2500).argmin()
            #print(idx)
            new_bw = b_w[0:idx]

            if np.nanmax(new_bw)>w_escape:
                escaped = True
                escaped_number+=1
                
            else:
                escaped = False
    return switched_number, escaped_number, red_cells 
