"""reads hdf5 files output from random_walk.py and processes them"""
import matplotlib as mpl
#mpl.use('TkAgg')
import matplotlib.pyplot as plt

import numpy as np
import pandas as pd
import seaborn as sns
import h5py
from auxiliary.ColonyPlot import Colony

# update plotting parameters for editable pdf output
plt.rcParams.update({'font.size': 8,
                     'font.weight': 'normal',
                     'font.family': 'sans-serif',
                     'font.sans-serif': 'Arial',
                     'pdf.fonttype': 42})
def error(a, b):
    """
    error of a/b for Poisson
    """

    return a / b * (np.sqrt((np.sqrt(a) / a) ** 2 + (np.sqrt(b) / b) ** 2))

def get_groups(filename='rw_output.hdf5'):
    '''get all keys in the analysis file, i.e. the group names'''
    with h5py.File(filename, 'r') as f:
        key_list = [key for key in f.keys()]
    return key_list


class Analysis():
    """Class to hold all simulation data and functions to be analysed"""
    def __init__(self):
        self.attrs = {}
        self.radius = np.array([])

    def load_dataset(self, filename='rw_output.hdf5', group='experiment_group', dataset='phi_array'):
        """Load the specified groups (i.e. simulation runs) from a hdf5 output file."""
        with h5py.File(filename, 'r') as f:
            dset = f[group + '/' + dataset]
            self.phi_array = np.array(dset)
            for key in dset.attrs.keys():
                self.attrs[key] = dset.attrs[key]

        # get the radius vector and save it to the class
        self.radius = self.calculate_radius()

    def calculate_radius(self):
        """returns the radius vector"""
        radius = np.arange(0, self.attrs['steps']+1, self.attrs['delta_r'])+self.attrs['initial_radius']
        return radius

    def get_widths_arrays(self):
        """returns widths of type1 (unmutated) and type2 (mutated) sectors based on boundary angles and radius."""
        width_type1 = (self.phi_array[:, 1, :].T - self.phi_array[:, 0, :].T)*self.radius
        width_type2 = (self.phi_array[:, 3, :].T - self.phi_array[:, 2, :].T)*self.radius

        return width_type1, width_type2

    def get_lengths(self):
        """returns sector lengths in um"""
        type1_w, type2_w = self.get_widths_arrays()
        type1_w[np.isnan(type1_w)] = 0
        type2_w[np.isnan(type2_w)] = 0
        combined = type1_w+type2_w
        lengths = []
        for streak in combined:
            lengths.append(np.max(np.nonzero(streak)))


        #lengths = np.sum((width_array[0]+width_array[1]) > 0, axis=1)*self.attrs['delta_r']
        return lengths

    def get_summary_dataframe(self):
        """returns pandas DataFrame with summary statistics of population"""
        num_sectors = np.empty((self.phi_array.shape[0], 2))
        num_sectors[:, 0] = np.count_nonzero(~np.logical_or(np.isnan(self.phi_array[:, 0, :]), ~np.isnan(self.phi_array[:, 2, :])), axis=1)
        num_sectors[:, 1] = np.count_nonzero(~np.isnan(self.phi_array[:, 2, :]), axis=1)
        df = pd.DataFrame(num_sectors, columns=['num_type1', 'num_type2'])
        df['num_total'] = df.loc[:, ['num_type1', 'num_type2']].sum(axis=1)
        df['psurv_type1'] = df['num_type1']/self.attrs['sector_number']
        df['psurv_type2'] = df['num_type2'] / self.attrs['sector_number']
        df['psurv_total'] = df['num_total'] / self.attrs['sector_number']
        df['radius'] = self.radius

        return df

    def get_sorted_index(self):
        """returns the index for sorting of the trajectories,
        sorting from shortes to longest and then from type1 to type2"""
        lengths = self.get_lengths()    # total sector length
        
        width_array = self.get_widths_arrays()
        lengths_type2 = np.sum((width_array[1]) > 0, axis=1)*self.attrs['delta_r']     # length containing type2
        
        sorted_index = np.lexsort((lengths_type2, lengths))     # sort first by total length and then by type2 length

        return np.flip(sorted_index)

    def plot_trajectories(self,ax = None, spacing_factor=0.1):
        """creates the trajectory plot, sorting sector from shortes (bottom) to longest(top).
        The parameter spacing_factor allows for rescaling of displayed sector width to minimize overlap"""

        # get overall dimensions
        final_circumference = 2 * np.pi * self.radius[-1]
        spacing = final_circumference / self.attrs['sector_number'] * spacing_factor

        # get sorting index according to size and type
        sorted_index = self.get_sorted_index()
        custom_blue = (82 / 255, 175 / 255, 230 / 255)
        custom_red = (190 / 255, 28 / 255, 45 / 255)
        # plot trajectories
        if ax == None:
            fig, ax = plt.subplots(1, 1, figsize=(15, 5))
        for plot_offset, sector_id in enumerate(sorted_index): #range(self.attrs['sector_number']):
            type1_left = self.phi_array[:, 0, sector_id] * self.radius + plot_offset * spacing
            type1_right = self.phi_array[:, 1, sector_id] * self.radius + plot_offset * spacing
            type2_left = self.phi_array[:, 2, sector_id] * self.radius + plot_offset * spacing
            type2_right = self.phi_array[:, 3, sector_id] * self.radius + plot_offset * spacing

            ax.fill_between(self.radius, type1_left, type1_right, color=custom_red, lw=0)
            ax.fill_between(self.radius, type2_left, type2_right, color=custom_blue, lw=0)

        #ax.set_xlabel('radius [um]')
        #ax.set_ylabel('rank')

        plt.show()

    def plot_mean_width(self, ax=None):
        """ Creates the plots for mean sector width. ax can be specified to overlay different simulation runs"""
        if not ax:  #create axis if none is specified
            fig, ax = plt.subplots(1, 1)

        # initialize some things
        width_array_list = self.get_widths_arrays()
        custom_blue = (82 / 255, 175 / 255, 230 / 255)
        custom_red = (190 / 255, 28 / 255, 45 / 255)
        colors = [custom_red, custom_blue]

        # calculate and plot sector trajectories
        for idx, width_array in reversed(list(enumerate(width_array_list))):
            y = np.nanmean(width_array, axis=0)
            yerr = np.nanstd(width_array, axis=0)
            ax.plot(self.radius, y, color=colors[idx])
            ax.fill_between(self.radius, y-yerr, y+yerr, color=colors[idx],lw = 0, alpha=0.5)

        #ax.set_xlabel('radius [um]')
        #ax.set_ylabel('mean width [um]')

        bottom, top = ax.get_ylim()
        ax.set_ylim((0, top))

        plt.show()

    def plot_median_width(self, ax=None):
        """ Creates the plots for mean sector width. ax can be specified to overlay different simulation runs"""
        if not ax:  # create axis if none is specified
            fig, ax = plt.subplots(1, 1)
        # initialize some things
        width_array_list = self.get_widths_arrays()
        custom_blue = (82 / 255, 175 / 255, 230 / 255)
        custom_red = (190 / 255, 28 / 255, 45 / 255)
        colors = [custom_red, custom_blue]
        colors_for_means = [(120 / 255, 28 / 255, 45 / 255),(35 / 255, 109 / 255, 200 / 255)]

        # calculate and plot sector trajectories
        for idx, width_array in reversed(list(enumerate(width_array_list))):
            y = np.nanmedian(width_array, axis=0)
            y_first_q = np.nanpercentile(width_array,25, axis=0)
            y_third_q = np.nanpercentile(width_array,75, axis=0)
            y_mean =np.nanmean(width_array,axis=0)
            ax.plot(self.radius, y, color=colors[idx],label="Median")
            ax.plot(self.radius,y_mean,'--',color=colors_for_means[idx],label="Mean")
            ax.fill_between(self.radius,y_first_q, y_third_q, color=colors[idx], lw=0, alpha=0.5)


        # ax.set_xlabel('radius [um]')
        # ax.set_ylabel('mean width [um]')

        bottom, top = ax.get_ylim()
        ax.set_ylim((0, top))

        plt.show()

    def plot_width_distributions(self,ax = None, n_radii=20, max_width=200, cumulative=False):
        """plots the distribution (kde plot) of sector widths"""

        # initialize some things
        if ax == None:
            fig, ax = plt.subplots(2, figsize=(6 * 2.54, 4 * 2.54))
        cmaps = ['Reds','Blues']
        width_array_list = self.get_widths_arrays()

        # create width distribution plots
        for idx, width_array in enumerate(width_array_list):
            colors = [plt.get_cmap(cmaps[idx])(x) for x in np.linspace(0.1, 1, n_radii)]

            for color_idx, radius_idx in enumerate(np.linspace(50, width_array.shape[1]-1, n_radii, dtype=int)):
                print(radius_idx)
                # plot the cumulative histogram
                sns.kdeplot(data=width_array[:, radius_idx],
                            color=colors[color_idx],
                            linewidth=2,
                            ax=ax[idx],
                            cumulative=cumulative)

                ax[idx].set(xlim=(0, max_width),ylim=(0,0.025), yscale='linear')

        plt.show()

    def plot_num(self):
        """ Create plot for number of sectors"""
        df = self.get_summary_dataframe()

        ax = df.loc[:, ['num_type1', 'num_type2', 'num_total']].plot(color=['red', 'blue', 'black'])
        ax.set_xlabel('radius [um]')
        ax.set_ylabel('number of clones')
        ax.set_yscale('log')
        plt.show()

    def plot_psurv(self):
        """Create plot for survival probability"""

        # load the summary statistics DataFrame
        df = self.get_summary_dataframe()

        ax = df.loc[:, ['psurv_type1', 'psurv_type2', 'psurv_total', 'radius']].plot(x='radius', color=['red', 'blue', 'black'])
        ax.set_xlabel('radius [um]')
        ax.set_ylabel('survival probability')
        ax.set_yscale('log')

        plt.show()

    def plot_psurv_experiments(self, ax, CHX, BED, treatment,filename='experimental_data.h5', **kwargs):
        """BETA! Plot the experimentally measured sutvival probability.
        Note, the origin file for that data is currently hard-coded below. Needs the functions 'Colony' (and 'error')"""
        #filename = '../../../python_plotting/data/h5_data_cleaned.h5'
        colplt = Colony(filename)
        Rad = colplt.get_radii(CHX, BED, treatment)
        Rad_errs = colplt.get_radii_std(CHX, BED, treatment)
        tot_num = colplt.get_numbers(CHX, BED, treatment, 0) + colplt.get_numbers(CHX, BED, treatment,
                                                                                  1) + colplt.get_numbers(CHX, BED,
                                                                                                          treatment, 2)
        P = tot_num / tot_num[0]
        # ax.fill_between(Rad, tot_num / tot_num[0] - error(tot_num, tot_num[0]),
        #                 tot_num / tot_num[0] + error(tot_num, tot_num[0]), color=shadecolor, alpha=1.)
        ax.errorbar(Rad,P,error(tot_num,tot_num[0]),Rad_errs,**kwargs)

        return 0


def main():
    """Simple funcitonality test"""
    analysis = Analysis()
    analysis.load_dataset()
    analysis.plot_trajectories()
    analysis.plot_mean_width()

    return analysis

if __name__ == '__main__':
    analysis = main()