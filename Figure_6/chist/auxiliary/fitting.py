"""
fitting 
"""
import numpy as np 

def fit_line(x,y,weights): 
    """
    auxiliary fit line function for blue clones width fit
    """
    new_x = x[~np.isnan(y)]
    new_y = y[~np.isnan(y)]
    new_w = weights[~np.isnan(y)]
   
    coef, cov = np.polyfit(new_x,new_y,1, cov = 'unscaled') 
    
    return coef, cov;
