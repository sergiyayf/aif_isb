import matplotlib as mpl
mpl.use('TkAgg')
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
from chist import width as w
from auxiliary.asymmetric_kde import ImproperGammaEstimator


def plot_width_distributions(ax = None, n_radii=10, kernel='logGauss'):
    """plots the distribution (kde plot) of sector widths"""

    # initialize some things
    pulled_r = w.pull_histories_together('random_switching_new', clone_type='red')
    if kernel == 'compare':
        start_range = 60
        end_range = 65
    else:
        start_range = 10
        end_range = 101
    for idx, loc in enumerate(range(start_range, end_range, 10)):

        x = pulled_r.iloc[[loc]]
        width = x.values[0][~np.isnan(x.values[0])]

        colors = [plt.get_cmap('Reds')(x) for x in np.linspace(0.1, 1, n_radii)]

        if kernel == 'gamma':
            ige = ImproperGammaEstimator(width, .5)
            x = np.linspace(0, 15, 50)
            ax.plot(x, ige(x), color=colors[idx])
        if kernel=='Gauss':
            sns.kdeplot(data=width,
                        color=colors[idx],
                        linewidth=2,
                        ax=ax,
                        bw=1,
                        cumulative=False)
        elif kernel=='logGauss':
            from rpy2.robjects import numpy2ri
            from rpy2.robjects.packages import importr
            from rpy2.robjects import default_converter
            from rpy2.robjects.conversion import localconverter
            logKDE = importr('logKDE')
            np_cv_rules = default_converter + numpy2ri.converter

            with localconverter(np_cv_rules) as cv:
                cut_width = width[width > 0]

                log_density_dict = logKDE.logdensity(cut_width+0, bw='logg',adjust = 2,to=15+0, **{'from': 0+0})
                x = log_density_dict['x']-0
                y = log_density_dict['y']

            ax.plot(x, y, color=colors[idx], label='logKDE')


        elif kernel == 'compare':
            ige = ImproperGammaEstimator(width, .5)
            x = np.linspace(0, 15, 50)
            ax.plot(x, ige(x), color='darkred',label='gamma')
            from rpy2.robjects import numpy2ri
            from rpy2.robjects.packages import importr
            from rpy2.robjects import default_converter
            from rpy2.robjects.conversion import localconverter
            logKDE = importr('logKDE')
            np_cv_rules = default_converter + numpy2ri.converter

            with localconverter(np_cv_rules) as cv:
                cut_width = width[width > 0]

                log_density_dict = logKDE.logdensity(cut_width + 0, bw='logg', adjust=2, to=15 + 0, **{'from': 0 + 0})
                x = log_density_dict['x'] - 0
                y = log_density_dict['y']

            ax.plot(x, y, color='k', label='logKDE')
            sns.histplot(data=cut_width, bins=32, stat='density', color=colors[idx], alpha=0.1, label='histogram')
            sns.kdeplot(data=cut_width, bw=1.5, color='steelblue', label='GaussianKDE')




def setup_figure(save_figure=False, compare=False):
    mpl.rcParams['pdf.fonttype'] = 42  # to make text editable in pdf output
    mpl.rcParams['font.sans-serif'] = ['Arial']  # to make it Arial
    plt.rcParams.update({'font.size': 8,
                         'font.weight': 'normal',
                         'font.family': 'sans-serif'})

    if compare:
        fig, ax = plt.subplots()
        plot_width_distributions(ax=ax, n_radii=10, kernel='compare')
        ax.legend()

    else:
        fig, ax = plt.subplots(figsize=(170 / 72, 45 / 72), constrained_layout=True)
        plt.subplots_adjust(left=0.058823, right=0.8676471, top=0.99, bottom=0.01)
        plot_width_distributions(ax=ax, n_radii=10,kernel='logGauss')
    ax.set_xlim([15, 0])
    ax.set_ylabel("")
    ax.yaxis.tick_right()
    ax.set_xticks([0, 2, 4, 6, 8, 10, 12, 14])
    ax.set_yticklabels(ax.get_yticks(), rotation=90)

    if save_figure:
        fig.savefig(r'SI_Rev_Width_distribution_red_logKDE_pts.pdf', transparent=True)

if __name__ =='__main__':
    setup_figure(save_figure=True,compare=True)
    plt.show()
