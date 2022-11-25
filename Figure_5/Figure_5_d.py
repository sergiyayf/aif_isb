import matplotlib as mpl
mpl.use('TkAgg')
import matplotlib.pyplot as plt
from streaky import analysis as ana
import os
import numpy as np
import seaborn as sns
from auxiliary.asymmetric_kde import ImproperGammaEstimator

def plot_width_distributions(analysis,ax = None, n_radii=20, max_width=200, cumulative=False,kernel='logGauss'):
    """plots the distribution (kde plot) of sector widths"""

    # initialize some things
    width_array_list = analysis.get_widths_arrays()
    # create width distribution plots
    width_array = width_array_list[0]
    colors = [plt.get_cmap('Reds')(x) for x in np.linspace(0.1, 1, n_radii)]
    if kernel == 'compare':
        radius = 4500
    else:
        radius = 50

    for color_idx, radius_idx in enumerate(np.linspace(radius, width_array.shape[1]-1, n_radii, dtype=int)):
    #for color_idx, radius_idx in enumerate(np.linspace(4500, width_array.shape[1] - 1, n_radii, dtype=int)):
        # plot kde
        if kernel=='Gauss':
            sns.kdeplot(data=width_array[:, radius_idx],
                        color=colors[color_idx],
                        linewidth=2,
                        ax=ax[idx],
                        cumulative=cumulative)
        elif kernel=='logGauss':
            from rpy2.robjects import numpy2ri
            from rpy2.robjects.packages import importr
            from rpy2.robjects import default_converter
            from rpy2.robjects.conversion import localconverter
            logKDE = importr('logKDE')
            np_cv_rules = default_converter + numpy2ri.converter
            width = width_array[:,radius_idx]
            with localconverter(np_cv_rules) as cv:
                cut_width = width[width > 0]
                log_density_dict = logKDE.logdensity(cut_width, bw='logg',adjust=1.5, to=270, **{'from': 0})
                x = log_density_dict['x']
                y = log_density_dict['y']
            ax.plot(x, y, color=colors[color_idx],label='logKDE')

        elif kernel == 'compare':
            from rpy2.robjects import numpy2ri
            from rpy2.robjects.packages import importr
            from rpy2.robjects import default_converter
            from rpy2.robjects.conversion import localconverter
            logKDE = importr('logKDE')
            np_cv_rules = default_converter + numpy2ri.converter
            width = width_array[:, radius_idx]
            ige = ImproperGammaEstimator(width[width>0], 2.)
            x = np.linspace(0, 250, 1000)
            ax.plot(x, ige(x), color='darkred',label='gamma')
            with localconverter(np_cv_rules) as cv:
                cut_width = width[width > 0]
                log_density_dict = logKDE.logdensity(cut_width, bw='logg', adjust=1.5, to=270, **{'from': 0})
                x = log_density_dict['x']
                y = log_density_dict['y']
            ax.plot(x, y, color='k', label='logKDE')
            sns.histplot(width, bins=50, stat='density', color=colors[color_idx], alpha=0.1,label='histogram')
            sns.kdeplot(width, color='steelblue',label='GaussianKDE')


        #ax.set(xlim=(0, max_width),ylim=(0,0.025), yscale='linear')

def setup_figure(save_figure=False,compare=False):
    mpl.rcParams['pdf.fonttype'] = 42  # to make text editable in pdf output
    mpl.rcParams['font.sans-serif'] = ['Arial']  # to make it Arial
    plt.rcParams.update({'font.size': 8,
                         'font.weight': 'normal',
                         'font.family': 'sans-serif'})
    analysis = ana.Analysis()
    analysis.load_dataset(filename=os.path.join('..', 'data', 'rw_output_Serhii_main.hdf5'),
                          group='dynamic_s=1.3e-2_mu=1.0e-4_d=0.23_wc=280_w0=r20pm5_f')
    if compare:
        fig, ax = plt.subplots()
        plot_width_distributions(analysis,ax=ax, n_radii=1,kernel='compare')
        ax.legend()

    else:
        fig, ax = plt.subplots(figsize=(170 / 72, 45 / 72), constrained_layout=True)
        plt.subplots_adjust(left=0.058823, right=0.8676471, top=0.99, bottom=0.01)
        plot_width_distributions(analysis, ax=ax, n_radii=10,kernel='logGauss')

    ax.set_xlim([270, 0])
    ax.set_xticks([0, 50, 100, 150, 200, 250])
    ax.yaxis.tick_right()
    ax.set_yticklabels(ax.get_yticks(), rotation=90)
    ax.set_ylabel("")

    if save_figure:
        fig.savefig(r'SI_Rev_Width_distribution_red_logKDE.pdf', transparent=True)

if __name__ =='__main__':
    setup_figure(save_figure=False,compare=False)
    plt.show()
