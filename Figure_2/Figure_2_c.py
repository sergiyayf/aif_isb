import matplotlib as mpl
mpl.use('TkAgg')
import matplotlib.pyplot as plt
from auxiliary.ColonyPlot import *
import os

def plot_median_width(ax, colplt, CHX=50, BED=4, indicate_treatment=False):
    """
    plot median width vs Colony radius
    """
    # initialize some variables
    mean_w_r = []
    median_w_r = []
    first_q_w_r = []
    third_q_w_r = []
    mean_w_b = []
    median_w_b = []
    first_q_w_b = []
    third_q_w_b = []

    # loop through all imaging days and load data
    for day in range(1, 10):
        width_r = colplt.get_width(CHX=50, BED=4, day=day, color=0)
        width_b = colplt.get_width(CHX=50, BED=4, day=day, color=1)
        width_m = colplt.get_width(CHX=50, BED=4, day=day, color=2)
        # calculate means and standard deviations

        mean_w_r.append(np.nanmean(width_r))  # mean
        median_w_r.append(np.nanmedian(width_r))  # Q2
        first_q_w_r.append(np.nanpercentile(width_r, 25))  # Q1
        third_q_w_r.append(np.nanpercentile(width_r, 75))  # Q3
        mean_w_b.append(np.nanmean(width_b))  # mean
        median_w_b.append(np.nanmedian(width_b))  # Q2
        first_q_w_b.append(np.nanpercentile(width_b, 25))  # Q1
        third_q_w_b.append(np.nanpercentile(width_b, 75))  # Q3
    # load average colony radii
    Rad = colplt.get_radii(CHX, BED, treatment=10)
    # set plotting parameters
    custom_blue = (82 / 255, 175 / 255, 230 / 255)
    custom_red = (190 / 255, 28 / 255, 45 / 255)
    ax.errorbar(Rad[1:], median_w_b,
                yerr=[np.array(median_w_b) - np.array(first_q_w_b), np.array(third_q_w_b) - np.array(median_w_b)],
                color=custom_blue, linewidth=2, alpha=1, capsize=2, capthick=2)
    ax.errorbar(Rad[1:], median_w_r,
                yerr=[np.array(median_w_r) - np.array(first_q_w_r), np.array(third_q_w_r) - np.array(median_w_r)],
                color=custom_red, linewidth=2, alpha=1, capsize=2, capthick=2, label="Median")

    ax.fill_between(Rad[1:], first_q_w_r, third_q_w_r, color=custom_red, linewidth=2, alpha=0.5)
    ax.fill_between(Rad[1:], first_q_w_b, third_q_w_b, color=custom_blue, linewidth=2, alpha=0.5)
    ax.scatter(Rad[1:], mean_w_r, marker='o', s=12, color=[120 / 255, 28 / 255, 45 / 255], label="Mean")
    ax.scatter(Rad[1:], mean_w_b, marker='o', s=12, color=[35 / 255, 109 / 255, 200 / 255])
    # indicate treatment onset
    if indicate_treatment == True:
        ax.arrow(x=Rad[5], y=0, dx=0, dy=100, width=2, length_includes_head=True, label='early treatment')
        ax.arrow(x=Rad[9], y=0, dx=0, dy=100, width=2, length_includes_head=True, label='late treatment')

def figure_setup(save_figure = False):
    # set plot font and fontsizes
    plt.rcParams.update({'font.size': 6,
                         'font.weight': 'normal',
                         'font.family': 'sans-serif'})
    mpl.rcParams['pdf.fonttype'] = 42  # to make text editable in pdf output
    mpl.rcParams['font.sans-serif'] = ['Arial']  # to make it Arial

    # load data
    filename = os.path.join('..','data','experimental_data.h5')
    f = h5py.File(filename, 'r')
    colplt = Colony(filename)

    cm = 1 / 2.54
    fig, ax = plt.subplots(figsize=(235 / 72, 170 / 72), constrained_layout=True)
    plot_median_width(ax, colplt)
    ax.legend()
    ax.set_ylim(0, 220)
    ax.set_yticks([0, 50, 100, 150, 200])
    fig.set_constrained_layout_pads(w_pad=10 / 72, h_pad=10 / 72, hspace=2 / 72, wspace=2 / 72)
    if save_figure:
        fig.savefig(r'figures\Median_width_mean_scatter.pdf', transparent = True)

    plt.show()

if __name__ == '__main__':
    figure_setup(save_figure=False)