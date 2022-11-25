"""
error module 
"""
import numpy as np 

def Poisson_error(a,b): 
    """
    error of a/b for Poisson
    """
    
    return a / b * (np.sqrt((np.sqrt(a) / a) ** 2 + (np.sqrt(b) / b) ** 2))
