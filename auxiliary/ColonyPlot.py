import h5py
import pandas as pd 
import numpy as np

class Colony: 
    """This Class is for easily getting experimental data for plotting"""
    
    def __init__(self,filename):
        
        self.hdf = h5py.File(filename,'r'); 
        
    def get_ds(self,index): 
        """
        Get raw saved dataset of a index
        
        """
        ds = self.hdf['colonies/col'+str(index)]
        return ds
      
    def get_width(self,CHX,BED,day,color): 
        """ 
        Get width vector of all clones of a color present at the perifery for a specific day and condition
        
        This method simply goes through all of the datasets and checks for condition in the attributes
        
        Parameters
        ----------
        
        CHX - Cycloheximide concentration, possible values: 0, 50 
        
        BED - Betaestradiol concentraion, possible values: 0, 4, 6 and 10 that corresponds to yJK26c control 
        
        day - day of imaging: 1:9
                
        colors: red = 0 , blue = 1, mixed = 2; 
        
        
        Returns
        -------
        np.array that contains all sector width of a color 
                        
        
        """
        
        # initialize an array
        width = np.array([]); 
        
        # loop through all datasets
        for i in range(len(self.hdf['colonies'].keys())):
            # store current dataset to a variable
            ds = self.hdf['colonies/col'+str(i)]
            # check for conditions specified when calling a method
            if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day: 
                
                # widths and colors of this dataset 
                width_ds = np.array(self.hdf['colonies/col'+str(i)]) [0] * self.hdf['colonies/col'+str(i)].attrs['Radius']
                color_ds = np.array(self.hdf['colonies/col'+str(i)]) [2]
                # remove negative width measurements artifact
                color_ds = color_ds[width_ds>0]
                width_ds = width_ds[width_ds>0]
                                
                width_ds = width_ds[color_ds == color];
                
                # concatenate for different plates and wells of the same day and condition
                width = np.concatenate((width,width_ds),axis = 0)
                
                                
        return width;

    def get_one_colony_width(self, CHX, BED, day, color,plate='C', scene = 6):
        """
        Get width vector of all clones of a color present at the perifery for a specific day and condition
        This method simply goes through all of the datasets and checks for condition in the attributes

        Parameters
        ----------

        CHX - Cycloheximide concentration, possible values: 0, 50
        BED - Betaestradiol concentraion, possible values: 0, 4, 6 and 10 that corresponds to yJK26c control
        day - day of imaging: 1:9
        colors: red = 0 , blue = 1, mixed = 2;

        Returns
        -------
        np.array that contains all sector width of a color

        """

        # initialize an array
        width = np.array([]);

        # loop through all datasets
        for i in range(len(self.hdf['colonies'].keys())):
            # store current dataset to a variable
            ds = self.hdf['colonies/col' + str(i)]
            # check for conditions specified when calling a method
            if ds.attrs['BED'] == BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] == day and ds.attrs['plate'] == plate and ds.attrs['scene'] == scene:
                # widths and colors of this dataset
                width_ds = np.array(self.hdf['colonies/col' + str(i)])[0] * self.hdf['colonies/col' + str(i)].attrs[
                    'Radius']
                color_ds = np.array(self.hdf['colonies/col' + str(i)])[2]
                # remove negative width measurements artifact
                color_ds = color_ds[width_ds > 0]
                width_ds = width_ds[width_ds > 0]

                width_ds = width_ds[color_ds == color];

                # concatenate for different plates and wells of the same day and condition
                width = np.concatenate((width, width_ds), axis=0)

        return width;

    def get_radii(self, CHX, BED, treatment): 
        """ 
        Get colony radii
        
        This method calculates mean colony radii of a specified condition
        
        Parameters
        ----------
        CHX - Cycloheximide concentration, possible values: 0, 50 
        
        BED - Betaestradiol concentraion, possible values: 0, 4, 6 and 10 that corresponds to yJK26c control 
        
        treatment - day of treatment, to specify, because some of the plates were treated earlier and some later, possible values: 6 and 10 
        
        
        Returns
        -------
        numpy array of radii for different days of this condition. 
        
        day 0 radii would be the same for all conditions
        
        """ 
        
        # initial colony radii measured with ZEISS software
        rad_ini = 1/2*np.array([3670.,3550.,3690.,3790.,3850.,3500.,3450.,3700.,3870.,3420.,3660.,3700.] )
        rad_ini_mean = np.mean(rad_ini); 
        
        # initialize array for storing values for different colonies
        radii = np.empty(treatment)
        radii[0] = rad_ini_mean
        
        #check treatment onset
        if treatment == 6 and BED != 10:
            plate = 'A'
            #loop through different days 
            for day in range(1,10):
                Radius = np.array([])
                for i in range(len(self.hdf['colonies'].keys())):
                    ds = self.hdf['colonies/col'+str(i)]
                    if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day and ds.attrs['plate'] == plate: 
                        
                        # Radius 
                        Radius = np.concatenate( (Radius,self.hdf['colonies/col'+str(i)].attrs['Radius']),axis=0)
                radii[day] = np.mean(Radius)
                       
        elif treatment ==6 and BED ==10: 
            plate = 'C'
            for day in range(1,10):
                Radius = np.array([])
                for i in range(len(self.hdf['colonies'].keys())):
                    ds = self.hdf['colonies/col'+str(i)]
                    if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day and ds.attrs['plate'] == plate: 
                        
                        # Radius 
                        Radius = np.concatenate( (Radius,self.hdf['colonies/col'+str(i)].attrs['Radius']),axis=0)
                radii[day] = np.mean(Radius)
        else: 
            
            for day in range(1,10):
                Radius = np.array([])
                for i in range(len(self.hdf['colonies'].keys())):
                    ds = self.hdf['colonies/col'+str(i)]
                    if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day: 
                        
                        # Radius 
                        Radius = np.concatenate( (Radius,self.hdf['colonies/col'+str(i)].attrs['Radius']),axis=0)
                radii[day] = np.mean(Radius)
                    
                                
        return radii;
    def get_radii_std(self, CHX, BED, treatment): 
        """ 
        Get colony radii standard deviations
        
        This method calculates std of colony radii of a specified condition
        
        Parameters
        ----------
        CHX - Cycloheximide concentration, possible values: 0, 50 
        
        BED - Betaestradiol concentraion, possible values: 0, 4, 6 and 10 that corresponds to yJK26c control 
        
        treatment - day of treatment, to specify, because some of the plates were treated earlier and some later, possible values: 6 and 10 
        
        
        Returns
        -------
        numpy array of radii standard deviations for different days of this condition. 
        
        day 0 radii would be the same for all conditions
        
        """ 
        rad_ini = 1/2*np.array([3670.,3550.,3690.,3790.,3850.,3500.,3450.,3700.,3870.,3420.,3660.,3700.] )
        rad_ini_std = np.std(rad_ini); 
        
        radiistd = np.empty(treatment)
        radiistd[0] = rad_ini_std
        
        
        if treatment == 6 and BED != 10:
            plate = 'A'
            for day in range(1,10):
                Radius = np.array([])
                for i in range(len(self.hdf['colonies'].keys())):
                    ds = self.hdf['colonies/col'+str(i)]
                    if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day and ds.attrs['plate'] == plate: 
                        
                        # Radius 
                        Radius = np.concatenate( (Radius,self.hdf['colonies/col'+str(i)].attrs['Radius']),axis=0)
                radiistd[day] = np.std(Radius)
                       
        elif treatment ==6 and BED ==10: 
            plate = 'C'
            for day in range(1,10):
                Radius = np.array([])
                for i in range(len(self.hdf['colonies'].keys())):
                    ds = self.hdf['colonies/col'+str(i)]
                    if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day and ds.attrs['plate'] == plate: 
                        
                        # Radius 
                        Radius = np.concatenate( (Radius,self.hdf['colonies/col'+str(i)].attrs['Radius']),axis=0)
                radiistd[day] = np.std(Radius)
        else: 
            
            for day in range(1,10):
                Radius = np.array([])
                for i in range(len(self.hdf['colonies'].keys())):
                    ds = self.hdf['colonies/col'+str(i)]
                    if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day: 
                        
                        # Radius 
                        Radius = np.concatenate( (Radius,self.hdf['colonies/col'+str(i)].attrs['Radius']),axis=0)
                radiistd[day] = np.std(Radius)
                    
                                
        return radiistd;
    
    def get_numbers(self, CHX, BED, treatment, color): 
        """ 
        Get numbers of clones of specific color
        
                
        Parameters
        ----------
        
        CHX - Cycloheximide concentration, possible values: 0, 50 
        
        BED - Betaestradiol concentraion, possible values: 0, 4, 6 and 10 that corresponds to yJK26c control 
        
        treatment - day after treatment onset 6 or 10
                
        colors: red = 0 , blue = 1, mixed = 2; 
        
        
        Returns
        -------
        np.array that contains numbers - errors can then be calculated by Poisson statistics by taking sqrt
                        
        
        """    
           
        num_ini = [158,161,167,174,158,152]
        num_ini_mean = np.mean(num_ini)
        num_ini_std = np.std(num_ini)
        
        # initialize array for storing values for different colonies
        number = np.empty(treatment)
        
               
        
        if color == 0: 
            number[0] = num_ini_mean
            counts = 'count_red'
        elif color == 1: 
            number[0] = 0
            counts = 'count_blue' 
        elif color == 2:
            number[0] = 0
            counts = 'count_mixed'
        else:
            print('unknown color')
                
        
        #check treatment onset
        if treatment == 6 and BED != 10:
            plate = 'A'
            #loop through different days 
            for day in range(1,6):
                # colony_counter needed to correctly estimate initial amount of clones
                colony_counter = 0; 
                nums = np.array([])
                for i in range(len(self.hdf['colonies'].keys())):
                    ds = self.hdf['colonies/col'+str(i)]
                    if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day and ds.attrs['plate'] == plate: 
                        # numbers 
                        nums = np.concatenate( (nums,self.hdf['colonies/col'+str(i)].attrs[counts]),axis=0)
                        colony_counter +=1 
                number[day] = np.sum(nums)
            number[0]*=colony_counter
            
        elif treatment ==6 and BED ==10: 
            plate = 'C'
            for day in range(1,6):
                colony_counter = 0; 
                nums = np.array([])
                for i in range(len(self.hdf['colonies'].keys())):
                    ds = self.hdf['colonies/col'+str(i)]
                    if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day and ds.attrs['plate'] == plate: 
                        
                        # numbers 
                        nums = np.concatenate( (nums,self.hdf['colonies/col'+str(i)].attrs[counts]),axis=0)
                        colony_counter += 1
                number[day] = np.sum(nums)
            number[0] *=colony_counter
        elif treatment ==10 and BED ==10: 
            plate = 'D'
            for day in range(1,10):
                colony_counter = 0; 
                nums = np.array([])
                for i in range(len(self.hdf['colonies'].keys())):
                    ds = self.hdf['colonies/col'+str(i)]
                    if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day and ds.attrs['plate'] == plate: 
                        
                        # numbers 
                        nums = np.concatenate( (nums,self.hdf['colonies/col'+str(i)].attrs[counts]),axis=0)
                        colony_counter += 1
                number[day] = np.sum(nums)
            number[0] *=colony_counter
        else: 
            
            for day in range(1,10):
                colony_counter = 0; 
                nums = np.array([])
                for i in range(len(self.hdf['colonies'].keys())):
                    ds = self.hdf['colonies/col'+str(i)]
                    if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day and ds.attrs['plate'] != 'A': 
                        
                        # numbers 
                        nums = np.concatenate( (nums,self.hdf['colonies/col'+str(i)].attrs[counts]),axis=0)
                        colony_counter+=1
                number[day] = np.sum(nums)
            number[0]*=colony_counter
                    
                             
        return number;
    
    def get_frequency(self, CHX, BED, treatment, color): 
        """ 
        Get frequency of clones of specific color
        
                
        Parameters
        ----------
        
        CHX - Cycloheximide concentration, possible values: 0, 50 
        
        BED - Betaestradiol concentraion, possible values: 0, 4, 6 and 10 that corresponds to yJK26c control 
        
        treatment - day after treatment onset 6 or 10
                
        colors: red = 0 , blue = 1; 
        
        
        Returns
        -------
        np.array that contains mean frequencies for all the colonies of this condition and day
        and 
        np.array of standard deviations 
                        
        
        """    
           
        # initialize array for storing values for different colonies
        frequency = np.empty(treatment)
        std_frequency = np.empty(treatment)
        if color == 0: 
            frequency[0] = 0.1
            std_frequency[0] = 0.1
            col = 'red_pixels'
        elif color == 1: 
            frequency[0] = 0
            std_frequency[0] = 0
            col = 'blue_pixels' 
       
        else:
            print('unknown color')
                
        
        #check treatment onset
        if treatment == 6 and BED != 10:
            plate = 'A'
            #loop through different days 
            for day in range(1,6):
                freqs = np.array([])
                for i in range(len(self.hdf['colonies'].keys())):
                    ds = self.hdf['colonies/col'+str(i)]
                    if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day and ds.attrs['plate'] == plate: 
                        
                        # numbers 
                        freqs = np.concatenate( (freqs,self.hdf['colonies/col'+str(i)].attrs[col]/self.hdf['colonies/col'+str(i)].attrs['total_pixels']),axis=0)
                frequency[day] = np.mean(freqs)
                std_frequency[day] = np.std(freqs)
                       
        elif treatment ==6 and BED ==10: 
            plate = 'C'
            for day in range(1,6):
                freqs = np.array([])
                for i in range(len(self.hdf['colonies'].keys())):
                    ds = self.hdf['colonies/col'+str(i)]
                    if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day and ds.attrs['plate'] == plate: 
                        
                        # numbers 
                        freqs = np.concatenate( (freqs,self.hdf['colonies/col'+str(i)].attrs[col]/self.hdf['colonies/col'+str(i)].attrs['total_pixels']),axis=0)
                frequency[day] = np.mean(freqs)
                std_frequency[day] = np.std(freqs)
        elif treatment ==10 and BED ==10: 
            plate = 'D'
            for day in range(1,10):
                freqs = np.array([])
                for i in range(len(self.hdf['colonies'].keys())):
                    ds = self.hdf['colonies/col'+str(i)]
                    if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day and ds.attrs['plate'] == plate: 
                        
                        # numbers 
                        freqs = np.concatenate( (freqs,self.hdf['colonies/col'+str(i)].attrs[col]/self.hdf['colonies/col'+str(i)].attrs['total_pixels']),axis=0)
                frequency[day] = np.mean(freqs)
                std_frequency[day] = np.std(freqs)
        else: 
            
            for day in range(1,10):
                freqs = np.array([])
                for i in range(len(self.hdf['colonies'].keys())):
                    ds = self.hdf['colonies/col'+str(i)]
                    if ds.attrs['BED']==BED and ds.attrs['CHX'] == CHX and ds.attrs['day'] ==day: 
                        
                        # numbers 
                        freqs = np.concatenate( (freqs,self.hdf['colonies/col'+str(i)].attrs[col]/self.hdf['colonies/col'+str(i)].attrs['total_pixels']),axis=0)
                frequency[day] = np.mean(freqs)
                std_frequency[day] = np.std(freqs)
                    
                                
        return frequency, std_frequency;
        


    
 
