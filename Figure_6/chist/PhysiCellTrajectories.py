"""
Colony history class 
"""

import h5py 
import pandas as pd
import numpy as np 
import matplotlib.pyplot as plt
from scipy import interpolate
from .auxiliary.errors import Poisson_error as error

class CloneTrajectory:
    """ This class contains all of the important methods to do on clones """
    def __init__(self, dfs): 
        """
        dfs - fictionary 
        """
        self.R_df = dfs['Red']
        self.B_df = dfs['Blue']
        self.T_df = dfs['Tot']
        self.Rad = dfs['Tot'].index
        
    def plot(self, *args, clone = 'red', **kwargs): 
        """
        plotting of means 
        """
        ax = args[0] 
        if clone == 'red': 
            ax.plot(self.R_df.mean(axis = 1 ), **kwargs)
        elif clone == 'blue':
            ax.plot(self.B_df.mean(axis =1), **kwargs)
        elif clone == 'total': 
            ax.plot(self.T_df.mean(axis=1), **kwargs) 
        elif clone =='both':
            ax.plot(self.R_df.mean(axis = 1), **kwargs) 
            ax.plot(self.B_df.mean(axis = 1), **kwargs)
            
        return 
    
    def get_counts(self, clone = 'red'): 
        """
        get counts of the clones
        """
        if clone=='red':
            return self.R_df.count(axis=1).values
        elif clone=='blue':
            return self.B_df.count(axis=1).values 
        elif clone == 'total':
            return self.T_df.count(axis=1).values 
        
    def get_probability(self):
        return self.get_counts(clone='total')/self.get_counts(clone='total')[0]
    
    def plot_probability(self,*args,fill_between = True, **kwargs): 
        """
        plot probability
        """
        
        ax = args[0]
        
        if fill_between == False: 
            ax.plot(self.Rad,self.get_probability(),**kwargs)
        else:
            err = error(self.get_counts(clone='total'),self.get_counts(clone='total')[0])
            ax.fill_between(self.Rad,self.get_probability()-err,self.get_probability()+err ,**kwargs)
        return
    def plot_efficacy(self, control_probability, control_max,*args,**kwargs):
        """
        plot efficacy 
        """
        ax = args[0]
        this_probability = self.get_probability() 
        efficacy = 1-control_probability/this_probability

        # get efficacy errors
        no_switch = control_probability
        switch = this_probability
        no_switch_n = control_probability*control_max
        err = no_switch/switch*np.sqrt(
            (error(self.get_counts(clone='total'),self.get_counts(clone='total')[0]) / this_probability) ** 2 +
            (error(no_switch_n, no_switch_n[0]) / no_switch) ** 2)

        ax.plot(self.Rad, efficacy,**kwargs)
        ax.fill_between(self.Rad,efficacy-err,efficacy+err,alpha=0.5,**kwargs)

        # Interpolate efficacy to get window of inefficacy
        # interpolation to find the cut
        with_window_of_inefficacy = True
        if with_window_of_inefficacy == True:
            x = self.Rad[50:80]
            y = 1 - no_switch[50:80] / switch[50:80] - err[50:80]
            f = interpolate.interp1d(x, y)
            g = interpolate.interp1d(x, y + err[50:80])

            xnew = np.linspace(x[0], x[-1], 1000)
            ynew = f(xnew)
            yline = g(xnew)

            yintercept = yline[abs(ynew) == min(abs(ynew))]

            xintercept = xnew[abs(ynew) == min(abs(ynew))]
            print('xintercept = ', xintercept)
            ax.set_ylim([-.2, .75])

            ax.axvline(x=xintercept, ymin=0.2, color='k')
            ax.fill_betweenx([0., .75], x1=0, x2=xintercept, color='k', alpha=.4)
            ax.axhline(y=0, color='k', linestyle='--')
            ax.axhline(y=yintercept, color='k', linestyle=':', linewidth=1, label='Non-zero efficacy')
            ax.set_xlim(xmin=0)
        return

