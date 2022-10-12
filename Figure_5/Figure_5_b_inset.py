import matplotlib as mpl
mpl.use('TkAgg')
import numpy as np
from matplotlib import pyplot as plt

def inverse_logistic(s0, width, width_c):
    """inverse logistic form."""
    s_eff = s0 / (1 + np.exp(width_c / width))  # inverse logistic
    return s_eff

def figure_setup(save_figure=False):
    mpl.rcParams['pdf.fonttype'] = 42  # to make text editable in pdf output
    mpl.rcParams['font.sans-serif'] = ['Arial']  # to make it Arial
    plt.rcParams.update({'font.size': 6,
                         'font.weight': 'normal',
                         'font.family': 'sans-serif'})
    fig, ax = plt.subplots(figsize=(170/72,170/72),constrained_layout=True)

    w = np.linspace(0,1000,5000)
    s = inverse_logistic(0.013,w,280)
    ax.axhline(y=0,xmin=0,xmax=1000,linestyle='--',color='grey')
    ax.axhline(y=0.013,xmin=0,xmax=1000,linestyle='--',color='grey')
    ax.plot(w,2*s,'k')
    if save_figure:
        fig2.savefig('figures/inset_b_s_eff.pdf',transparent=True)
    plt.show()

