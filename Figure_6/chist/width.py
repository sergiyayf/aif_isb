"""
This code analyzes widths of clones

"""

import pandas as pd 
import h5py 
from .auxiliary.fitting import fit_line 
import numpy as np

def pull_histories_together(collectionname, clone_type = 'total'): 
    """
    This code pulls all the clone trajectories together for further analysis 
    
    Input
    -----
    collectionname
    
    clone_type - red , blue or total 
    Default = 'total'
    
    Returns
    -------
    
    concatenated dataframe 
    
    """
    
    # open data file 
    #h5File = 'chist/data/growth_layer.h5'
    h5File = 'chist/data/ER_data_collection.h5'
    f = h5py.File(h5File, 'r')
    
    # define dataframes of full data for concatenation
    
    F_T_df = pd.DataFrame()
    F_R_df = pd.DataFrame()
    F_B_df = pd.DataFrame()
    Rad = pd.DataFrame()
    
    # loop through all the collonies in this collection 
    if clone_type == 'total': 
        for key in f['data/'+collectionname].keys(): 
            
            # get clones trajectories Red, Blue and Total dataframes
            R_df = pd.read_hdf(h5File, 'data/'+collectionname+'/'+key+'/red')
            B_df = pd.read_hdf(h5File, 'data/'+collectionname+'/'+key+'/blue')
            T_df = R_df.add(B_df, axis=1,fill_value=0)
                      
            # get average radius
            Rad = pd.concat([Rad,T_df.reset_index()['rad']],axis = 1)
            # reset index from Radius to series to concatenate dataframes 
            
            temptot = T_df.reset_index()
            temptot = temptot.drop(columns=['rad'])
               
            # concatenate
            
            F_T_df = pd.concat([F_T_df,temptot], axis =1 ) 
        F_T_df['rad'] = Rad.mean(axis=1) 
        F_T_df = F_T_df.set_index('rad')
        
        return F_T_df
    
    elif clone_type == 'red': 
        for key in f['data/'+collectionname].keys(): 
            
            # get clones trajectories Red, Blue and Total dataframes
            R_df = pd.read_hdf(h5File, 'data/'+collectionname+'/'+key+'/red')
            # get average radius
            Rad = pd.concat([Rad,R_df.reset_index()['rad']],axis = 1)
            # reset index from Radius to series to concatenate dataframes 
            
            tempred = R_df.reset_index()
            tempred = tempred.drop(columns=['rad'])
            
            # concatenate
       
            F_R_df = pd.concat([F_R_df,tempred], axis =1 ) 
        F_R_df['rad'] = Rad.mean(axis=1) 
        F_R_df = F_R_df.set_index('rad')
            
        return F_R_df
    
    elif clone_type == 'blue': 
        for key in f['data/'+collectionname].keys(): 
            
            # get clones trajectories Red, Blue and Total dataframes
         
            B_df = pd.read_hdf(h5File, 'data/'+collectionname+'/'+key+'/blue')
            # get average radius
            Rad = pd.concat([Rad,B_df.reset_index()['rad']],axis = 1)
            
            # reset index from Radius to series to concatenate dataframes 
            tempblue = B_df.reset_index()
            tempblue = tempblue.drop(columns=['rad'])
  
            # concatenate
      
            F_B_df = pd.concat([F_B_df,tempblue], axis =1 ) 
        F_B_df['rad'] = Rad.mean(axis=1) 
        F_B_df = F_B_df.set_index('rad')
            

        
        return F_B_df
    
def blue_fit_line(ax, b_df, nstd = 1, plot_original = True, include_original_errorbars = True, label = 'no label given'): 
    """
    fits line to the widht plot
    
    Input
    -----
    ax - axis to plot on 
    b_df - pandas dataframe with all blue clones 
    plot_original - boolean if plotting average width or only fit to it, Default = True  
    include_original_errorbars - boolean if to include errorbars on average width, Default = True
    label 
    
    Returns
    -------
    
    plots fit to the average blue clone width 
    """
    
    # get average and std 
    
    average_blue_w = b_df.mean(axis=1) 
    std_blue_w = b_df.std(axis=1) 
    
    # get radius 
    rad = b_df.index
    
    if plot_original == True:
        if include_original_errorbars:
            ax.errorbar(rad, average_blue_w,yerr = std_blue_w, label = label)
        else:
            ax.plot(rad, average_blue_w, label = label)
    
    # weights to calculate convarience matrix 
    weights = 1/std_blue_w
    
    # fit line 
    coef, cov = fit_line(rad,average_blue_w,weights)
    # calculate standard deviation     
    err = np.sqrt(np.diag(cov))
    # declare line function 
    poly1d_fn = np.poly1d(coef) 
    
    # plot line
    x = rad[~np.isnan(average_blue_w)]
    x = np.linspace(x[0], 9000, 1000)
    ax.plot(x,poly1d_fn(x),'k--',lw = 1.)
    
    # prepare confidence level curves
    
    popt_up = coef + nstd * err
    popt_dw = coef - nstd * err
    
    # get lower and upper lines for the errors 
    func = np.poly1d(coef)
    fit = func(x)
    fit_up = np.poly1d(popt_up)
    fit_dw = np.poly1d(popt_dw)
    
    ax.fill_between(x, fit_up(x), fit_dw(x), alpha=.5,lw=0.)
    
    return 0
    
    
def get_rho_escape(b_df, nstd = 1,escape_width = 7):

    # get average and std 
    
    average_blue_w = b_df.mean(axis=1) 
    std_blue_w = b_df.std(axis=1) 
    
    # get radius 
    rad = b_df.index
    
    # weights to calculate convarience matrix 
    weights = 1/std_blue_w
    
    # fit line 
    coef, cov = fit_line(rad,average_blue_w,weights)
    # calculate standard deviation     
    err = np.sqrt(np.diag(cov))
    # declare line function 
    poly1d_fn = np.poly1d(coef) 
    
    # plot line
    x = rad[~np.isnan(average_blue_w)]
    x = np.linspace(x[0], 9000, 1000)
    
    # prepare confidence level curves
    
    popt_up = coef + nstd * err
    popt_dw = coef - nstd * err
    
    # get lower and upper lines for the errors 
    func = np.poly1d(coef)
    fit = func(x)
    fit_up = np.poly1d(popt_up)
    fit_dw = np.poly1d(popt_dw)
        
    # get rho escape 
    x_large = min(x[poly1d_fn(x)>escape_width])
    x_large_up = min(x[fit_up(x)>escape_width])
    #x_large_dw = min(x[fit_dw(x)>escape_width])
    
    rho_escape = x_large - x[0] 
    rho_escape_err = x_large_up-x_large
     
    return rho_escape, rho_escape_err
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
