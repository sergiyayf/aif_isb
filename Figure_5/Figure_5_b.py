import matplotlib as mpl
mpl.use('TkAgg')
import matplotlib.pyplot as plt
from streaky import analysis as ana
import os

def setup_figure(save_figure=False):
    mpl.rcParams['pdf.fonttype'] = 42 #to make text editable in pdf output
    mpl.rcParams['font.sans-serif'] = ['Arial'] #to make it Arial
    plt.rcParams.update({'font.size': 6,
                        'font.weight': 'normal',
                        'font.family': 'sans-serif'})
    analysis = ana.Analysis()
    analysis.load_dataset(filename=os.path.join('..','data','rw_output_Serhii_for_trajectories.hdf5'), group='trajectories_dynamic_s=1.3e-2,wc=280_random_ini')
    fig, ax = plt.subplots(figsize=(101/72,170/72),constrained_layout=True)
    analysis.plot_trajectories(ax= ax,spacing_factor=0.35)
    #ax.set_xticks([])
    ax.set_yticks([])
    fig.set_constrained_layout_pads(w_pad=2 / 72, h_pad=10 / 72, hspace=2 / 72, wspace=0 / 72)
    plt.subplots_adjust(left=0.02970297, right=0.980198, bottom=0.132353, top=0.94117649)
    if save_figure:
        fig.savefig('figures/Trajectories.pdf', transparent=True)

    plt.show()

if __name__=='__main__':
    setup_figure(save_figure=False)