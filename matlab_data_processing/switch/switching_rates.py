import numpy as np
import matplotlib
matplotlib.use('TkAgg')
from matplotlib import pyplot as plt 
from scipy.optimize import curve_fit
from scipy import odr
import h5py

plt.rcParams.update({'font.size': 12})
#plt.style.use('default')
#plt.style.use('dark_background')

class frequencies: 
    """plottting of the colony data"""
    
    def __init__(self,filename):
        
        self.hdf = h5py.File(filename,'r'); 
        
    def get_ds(self,index): 
        """get dataset of the index"""
        return 
    
    def get_frequency(self,index): 
        """get width in microns of the index"""
        return np.array(self.hdf['colonies/col'+str(index)]) 
    
    def get_frequency_array(self,CHX,BED): 
        """ returns mean blue frequency and std of a specific condition """
        freq_array = np.array([])
        std_array = np.array([])
        rad_array = np.array([])
        rad_std = np.array([])
        for d in range(1,6):
            f_b = np.array([]); 
            rads = np.array([]);
            for i in range(len(self.hdf['colonies'].keys())):
                ds = self.hdf['colonies/col'+str(i)]
                if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==d: 
                                
                    blue_ds = np.array(self.hdf['colonies/col'+str(i)])[1]
                    rad =  self.hdf['colonies/col'+str(i)].attrs['Radius']
                    
                    f_b = np.concatenate((f_b,blue_ds),axis = 0)
                    rads = np.concatenate((rads,rad),axis =0)
            freq_array = np.concatenate((freq_array,np.array([np.nanmean(f_b)])),axis = 0 )
            std_array = np.concatenate((std_array,np.array([np.nanstd(f_b)])),axis=0)
            rad_array = np.concatenate((rad_array,np.array([np.nanmean(rads)])),axis =0)
            rad_std = np.concatenate((rad_std,np.array([np.std(rads)])),axis =0)
                                    
        return [freq_array, std_array, rad_array, rad_std];
    
    def get_frequency(self,CHX,BED,day): 
        """ returns mean blue frequency and std of a specific condition """
        f_b = np.array([]); 
        for i in range(len(self.hdf['colonies'].keys())):
            ds = self.hdf['colonies/col'+str(i)]
            if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day: 
                               
                blue_ds = np.array(self.hdf['colonies/col'+str(i)])[1]
                
                f_b = np.concatenate((f_b,blue_ds),axis = 0)
                
                                
        return [np.nanmean(f_b),np.nanstd(f_b)];
    
       
    

def func(x, mu,R0): 
    #R0 = radius[0]
    f0 = 0#frequency[0]
    return 1-(1-f0)*np.exp(mu*R0-mu*x)

# function for ODR
def fit_func(B,x):
    return 1-1*np.exp(B[0]*B[1]-B[0]*x)

fig = plt.figure()
filename = 'data_switch.h5'
f = h5py.File(filename, 'r')
freqs = frequencies(filename)

# create model
sigmoid = odr.Model(fit_func)

# loop through different switching rates
for bed in [0,2,4,6]:

    [frequency, frequency_error, radius, radius_error] = freqs.get_frequency_array(0,bed)
    data = odr.RealData(radius, frequency, sx=radius_error, sy=frequency_error)
    myodr = odr.ODR(data, sigmoid, beta0=[0.0002, 1000])
    myoutput = myodr.run()
    myoutput.pprint()
    print(myoutput.beta[0])
    plt.errorbar(radius, frequency, yerr=frequency_error, xerr=radius_error,
                 label='BED ' + str(bed) + r' $\mu=$''%.2e' % myoutput.beta[0] + r'$\pm$''%.2e' % np.sqrt(myoutput.cov_beta[0,0]))

    """ curve_fit 
    popt,pcov = curve_fit(func, radius, frequency, sigma = frequency_error, absolute_sigma = True, p0 = [0.0002,1000] )
    plt.errorbar(radius, frequency,yerr =frequency_error, xerr = radius_error, label = 'BED '+str(bed)+r' $\mu=$''%.2e' % popt[0]+r'$\pm$''%.2e' % np.sqrt(pcov[0][0]))
    y = func(radius,*popt) 
    plt.plot(radius, y, color = 'k', linestyle = '--', linewidth = 1.5)#label = r'fit $y=1-f_r e^{\mu(R_0-r)}$ ',
    r = frequency-y;
    chisq = np.sum((r/frequency_error)**2)
    print('chisq =''%.2f' %chisq)
    """

plt.xlabel('Radius')
plt.ylabel('Frequency change')
plt.title('Switching rates')
plt.legend()
fig.savefig('Freaquency_fit_for_switching_rates.pdf',transparent=True)

plt.show()
