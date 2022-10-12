import h5py
import pandas as pd 
import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('TkAgg')

import numpy as np

plt.rcParams.update({'font.size': 24,
                    'font.weight': 'normal'})
#plt.style.use('default')
plt.style.use('dark_background')

class plotcol: 
    """plottting of the colony data"""
    
    def __init__(self,filename):
        
        self.hdf = h5py.File(filename,'r'); 
        
    def get_ds(self,index): 
        """get dataset of the index"""
        return 
    
    def get_width(self,index): 
        """get width in microns of the index"""
        return np.array(self.hdf['colonies/col'+str(index)]) [0] * self.hdf['colonies/col'+str(index)].attrs['Radius']
    
    def get_width(self,CHX,BED): 
        """ this method is not yet developed """
        for i in range(len(self.hdf['colonies'].keys())):
            ds = self.hdf['colonies/col'+str(i)]
            if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX: 
                print(ds.attrs['BED'])
        return;
    def get_width(self,CHX,BED,day): 
        """ this method is not yet developed """
        width = np.array([]); 
        for i in range(len(self.hdf['colonies'].keys())):
            ds = self.hdf['colonies/col'+str(i)]
            if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day: 
                print(ds.attrs['BED'])
                #width of one ds 
                width_ds = np.array(self.hdf['colonies/col'+str(i)]) [0] * self.hdf['colonies/col'+str(i)].attrs['Radius']
                # remove negative width measurements artifact
                width_ds = width_ds[width_ds>0]
                width = np.concatenate((width,width_ds),axis = 0)
                
                                
        return width;
    
    def get_width(self,CHX,BED,day,color): 
        """ this method is not yet developed 
        colors: red = 0 , blue = 1, mixed = 2; 
        
        
        """
        width = np.array([]); 
       
        for i in range(len(self.hdf['colonies'].keys())):
            ds = self.hdf['colonies/col'+str(i)]
            if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day: 
                
                #width of one ds 
                width_ds = np.array(self.hdf['colonies/col'+str(i)]) [0] * self.hdf['colonies/col'+str(i)].attrs['Radius']
                color_ds = np.array(self.hdf['colonies/col'+str(i)]) [2]
                # remove negative width measurements artifact
                color_ds = color_ds[width_ds>0]
                width_ds = width_ds[width_ds>0]
                                
                width_ds = width_ds[color_ds == color];
                
                width = np.concatenate((width,width_ds),axis = 0)
                
                                
        return width;
    


filename = 'h5_data_cleaned.h5'
f = h5py.File(filename, 'r')
print(f['colonies'].keys())
colplt = plotcol(filename) 

mean_w_r = [] 
std_w_r = []
mean_w_b = [] 
std_w_b = []

fig, ax = plt.subplots(1,2)
for day in range(1,10):

    width_r = colplt.get_width(CHX=50, BED=4, day=day, color=0)
    width_b = colplt.get_width(CHX=50, BED=4, day=day, color=1)

    #calculate means
    mean_w_r.append(np.nanmean(width_r))
    std_w_r.append(np.nanstd(width_r))
    mean_w_b.append(np.nanmean(width_b))
    std_w_b.append(np.nanstd(width_b))

    #append plot histogram
    ax[0].hist(width_r,100, histtype='step', cumulative=-1)
    ax[1].hist(width_b, 100, histtype='step', cumulative=-1)

ax[0].set_yscale('log')
ax[0].set_xscale('log')
ax[1].set_yscale('log')
ax[1].set_xscale('log')
plt.legend(range(1,10))


plt.figure(2)
plt.errorbar(range(1,10), mean_w_r, yerr=std_w_r, color='r', linewidth = 2)
plt.errorbar(range(1,10), mean_w_b, yerr=std_w_r,color='c', linewidth = 2)
plt.xlabel('day')
plt.ylabel(r'width $\mu m$')
plt.title('CHX50BED4 mean width')
plt.show()

