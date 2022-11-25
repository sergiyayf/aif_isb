import matplotlib as mpl
mpl.use('TkAgg')
from matplotlib import pyplot as plt 
from chist.auxiliary.analyze_history import *

def plot_history(save_figure=False):
    plt.rcParams.update({'font.size': 6,
                         'font.weight': 'normal',
                         'font.family': 'sans-serif'})
    mpl.rcParams['pdf.fonttype'] = 42  # to make text editable in pdf output
    mpl.rcParams['font.sans-serif'] = ['Arial']  # to make it Arial
    h5File = 'chist/data/ER_data_collection.h5'
    df = pd.read_hdf(h5File, 'data/random_switching_new/ds14/red')
    df2 = pd.read_hdf(h5File, 'data/random_switching_new/ds14/blue')
    width = [df,df2]
    fig, ax = plt.subplots(figsize=(101/72,170/72),constrained_layout=True)
    plot_sorted(ax,sort(width), width)
    ax.set_yticks([])
    ax.set_xticks([1000,2000,3000,4000,5000])
    ax.set_xticklabels([1000,2000,3000,4000,5000])
    if save_figure:
        fig.savefig('images/tailored_switch_at_50_trajectory.pdf',transparent = True)

if __name__ == "__main__":
    plot_history(save_figure=False)
    plt.show()
