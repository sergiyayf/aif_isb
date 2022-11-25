""" script to add new collections to the existing """ 
from .load.h5tohist import *
import pandas as pd
from .auxiliary.analyze_history import *

def main():
    """
    add new data to the hdf5 file
    """
    
    # Filename with collection of all data
    h5File = 'chist/data/growth_layer.h5'
    # filename with potentially first dataset of this collection
    filename = r'D:\Serhii\Projects\EvoChan\Simulations\sim_results_garching\Important_Selection_escape_sims\20211129_sw_at_35\29_11_sw_at_35_run_1\output\all_data.h5'
    # collection name 
    col_name = 'growth_layer'
    # Try to write the file to new collection if there is none with the same name
    write_to_new_collection(col_name,filename,h5File = h5File)
    
    # loop throug files in this batch to add them to the same collection of data
    for i in range(1,11): 
        filename = r'D:\Serhii\Projects\EvoChan\Simulations\sim_results_garching\Important_Selection_escape_sims\20211129_sw_at_35\29_11_sw_at_35_run_'+str(i)+r'\output\all_data.h5'
        write_to_existing_collection(col_name,filename,h5File = h5File)
    
    print('Script was run with no errors')

if __name__ == "__main__":
    main()
    
