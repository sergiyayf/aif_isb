import matplotlib as mpl
mpl.use('TkAgg')
import matplotlib.pyplot as plt
from streaky import analysis as ana
import os

def setup_figure(save_figure=False):
    fig, ax = plt.subplots(figsize=(235 / 72, 170 / 72), constrained_layout=True)
    mpl.rcParams['pdf.fonttype'] = 42  # to make text editable in pdf output
    mpl.rcParams['font.sans-serif'] = ['Arial']  # to make it Arial
    plt.rcParams.update({'font.size': 6,
                         'font.weight': 'normal',
                         'font.family': 'sans-serif'})
    analysis = ana.Analysis()
    analysis.load_dataset(filename=os.path.join('..', 'data', 'rw_output_Serhii_main.hdf5'),
                          group='dynamic_s=1.3e-2_mu=1.0e-4_d=0.23_wc=280_w0=r20pm5_f')
    analysis.plot_median_width(ax)
    ax.set_ylim([0, 270])
    ax.set_yticks([0, 50, 100, 150, 200, 250])
    ax.legend()
    fig.set_constrained_layout_pads(w_pad=10 / 72, h_pad=10 / 72, hspace=2 / 72, wspace=2 / 72)

    if save_figure:
        fig.savefig(r'figures\Median_width.pdf', transparent = True)

if __name__ =='__main__':
    setup_figure(save_figure=False)
    plt.show()