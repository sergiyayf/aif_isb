"""
Clone numbers / probabilities 
"""

from .auxiliary import errors.Poisson_error as err


def get_counts(collectionname): 
    """
    survival probabilities 
    
    Input
    -----
    
    
    Return
    ------
    
    """
    
    # open data file 
    h5File = 'chist/data/ER_data_collection.h5'
    f = h5py.File(h5File, 'r')
       
    # loop through all the data in this collection
    for key in f['data/'+collectionname].keys() : 
        R_df = pd.read_hdf(h5File, 'data/'+collectionname+'/'+keys+'/red')
        B_df = pd.read_hdf(h5File, 'data/'+collectionname+'/'+key+'/blue')
        T_df = R_df.add(B_df,axis = 1, fill_value = 0)
        
        # add up counts 
        counts_red = R_df.count(axis=1).values 
        counts_blue = B_df.count(axis=1).values 
        counts_tot = T_df.coung(axis=1).values
    
    return counts_red, counts_blue, counts_tot´
        
        
def get_survival_probability(counts_tot): 
    
