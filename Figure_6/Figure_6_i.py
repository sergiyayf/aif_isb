"""
sandbox code for using chist package to plot things 
"""

from chist import width as w 
import matplotlib as mpl
mpl.use('TkAgg')
from matplotlib import pyplot as plt 
from cycler import cycler


def setup_figure(save_figure=False):
    plt.rcParams.update({'font.size': 6,
                         'font.weight': 'normal',
                         'font.family': 'sans-serif'})
    mpl.rcParams['pdf.fonttype'] = 42  # to make text editable in pdf output
    mpl.rcParams['font.sans-serif'] = ['Arial']  # to make it Arial

    ncolors = 4
    fig, ax = plt.subplots(figsize=(150/72,90/72),constrained_layout=True)

    colorlist = [plt.get_cmap('Blues_r',ncolors)(i) for i in range(ncolors)]
    ax.set_prop_cycle(cycler('color', colorlist))
    ax.set_xlim(xmax = 7000)
    ax.set_ylim(ymax = 19)
    # plot red clones width
    for switch in [5, 15, 20, 25, 30, 35, 40, 45, 50]:
        pulled_r = w.pull_histories_together('tailored_switch_at_' + str(switch), clone_type='red')

        ax.plot(pulled_r.mean(axis=1), color='r', lw=0.5)
    # plot blue clone width and fit
    for switch in [5, 20, 45]:  # [5,15,20,25,30,35,40,45,50]:

        pulled_b = w.pull_histories_together('tailored_switch_at_' + str(switch), clone_type='blue')
        w.blue_fit_line(ax, pulled_b, include_original_errorbars=False, label=switch)
    plt.show()
    if save_figure:
        fig.savefigure('Tuned_switching_width.pdf',transparent=True)

if __name__ == "__main__":
    setup_figure(save_figure=False)
