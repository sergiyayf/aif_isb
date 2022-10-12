import matplotlib as mpl

mpl.use('TkAgg')
import matplotlib.pyplot as plt
import seaborn as sns
from auxiliary.ColonyPlot import *
from auxiliary.asymmetric_kde import ImproperGammaEstimator
import numpy as np
import os


def plot_width_distribution(ax, colplt, CHX=50, BED=4, color=0, kernel='gamma'):
    # distribution plotting
    n_bins = 20
    max_w = 300
    # single pixel sizes for all days
    cut_off = [2.9, 3.7, 4.6, 5.7, 5.7, 7.3, 7.3, 9.1, 9.1]

    if color == 0:
        c1 = [plt.get_cmap("Reds")(x) for x in np.linspace(0, 1, 9)]
    elif color == 1:
        c1 = [plt.get_cmap("Blues")(x) for x in np.linspace(0, 1, 9)]
    if kernel == 'compare':
        range_start = 4
        range_end = 5
    else:
        range_start = 1
        range_end = 10
    for day in range(range_start, range_end):

        width = colplt.get_width(CHX, BED, day, color)
        ige = ImproperGammaEstimator(width, 1.)
        x = np.linspace(0, 250, 1000)
        if kernel == 'gamma':
            ax.plot(x, ige(x), color=c1[day - 1])

        elif kernel == 'logGauss':
            from rpy2.robjects import numpy2ri
            from rpy2.robjects.packages import importr
            from rpy2.robjects import default_converter
            from rpy2.robjects.conversion import localconverter
            logKDE = importr('logKDE')
            np_cv_rules = default_converter + numpy2ri.converter
            with localconverter(np_cv_rules) as cv:
                cut_width = width[width > 1.5 * cut_off[day - 1]]
                # cut_width=width
                log_density_dict = logKDE.logdensity(cut_width, bw='logg', to=220, **{'from': 0})
                x = log_density_dict['x']
                y = log_density_dict['y']
            ax.plot(x, y, color=c1[day - 1], label='logKDE')
        elif kernel == 'compare':
            from rpy2.robjects import numpy2ri
            from rpy2.robjects.packages import importr
            from rpy2.robjects import default_converter
            from rpy2.robjects.conversion import localconverter
            logKDE = importr('logKDE')
            np_cv_rules = default_converter + numpy2ri.converter
            cut_width = width[width > 1.5 * cut_off[day - 1]]
            ige = ImproperGammaEstimator(cut_width, 1.)
            x = np.linspace(0, 250, 1000)
            ax.plot(x, ige(x), color='darkred', label='gamma')
            with localconverter(np_cv_rules) as cv:
                cut_width = width[width > 1.5 * cut_off[day - 1]]
                # cut_width=width
                log_density_dict = logKDE.logdensity(cut_width, bw='logg', to=220, **{'from': 0})
                x = log_density_dict['x']
                y = log_density_dict['y']
            ax.plot(x, y, color='k', label='logKDE')
            ax.axvline(x=cut_off[day - 1], ymin=0, ymax=1, ls='--', color='k', label='cutoff')
            sns.histplot(width, bins=150, stat='density', color=c1[6], alpha=0.1, label='histogram')
            sns.kdeplot(cut_width, color='steelblue', label='GaussianKDE')

        elif kernel == 'gauss':
            # plot the cumulative histogram
            sns.distplot(width, n_bins, ax=ax, kde_kws={"color": c1[day - 1], "lw": 2},

                         hist_kws={"histtype": "step", "linewidth": 3,

                                   "alpha": 1, "color": "g"}, hist=False).set(xlim=(0, max_w))

    # plt.xlabel('Width')
    # plt.ylabel('P(w)')


def figure_setup(save_figure=False, compare=True):
    plt.rcParams.update({'font.size': 8,
                         'font.weight': 'normal',
                         'font.family': 'sans-serif'})
    mpl.rcParams['pdf.fonttype'] = 42  # to make text editable in pdf output
    mpl.rcParams['font.sans-serif'] = ['Arial']  # to make it Arial

    # load data
    filename = os.path.join('..', 'data', 'experimental_data.h5')
    colplt = Colony(filename)
    if compare == True:
        fig, ax = plt.subplots()  # figsize=(170 / 72, 45 / 72))
        plot_width_distribution(ax, colplt, 50, 4, 1, kernel='compare')
        # ax.set_yticks([])
        ax.legend()

        ax.set_yticklabels(ax.get_yticks(), rotation=90)

    else:
        fig, ax = plt.subplots(figsize=(170 / 72, 45 / 72))
        plot_width_distribution(ax, colplt, 50, 4, 1, kernel='logGauss')
        fig.set_constrained_layout_pads(w_pad=20 / 72, h_pad=0, hspace=0, wspace=1 / 72)
        plt.subplots_adjust(left=0.058823, right=0.8676471, top=0.99, bottom=0.01)

    ax.yaxis.tick_right()
    ax.set_xlim(220, 0)
    ax.set_xticks([0, 50, 100, 150, 200])
    #ax.set_xticklabels([])
    ax.set_xlabel('')
    ax.set_ylabel('')

    if save_figure:
        fig.savefig(r'SI_Rev_Width_distribution_blue_logkde.pdf', transparent=True)


if __name__ == '__main__':
    figure_setup(save_figure=False, compare=False)
    plt.show()
