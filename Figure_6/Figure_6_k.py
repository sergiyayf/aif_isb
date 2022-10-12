from chist import width as w
import matplotlib as mpl
mpl.use('TkAgg')
from matplotlib import pyplot as plt 
from chist.auxiliary.errors import Poisson_error as error
from chist.establishment import get_establishment_statistics
import numpy as np

def escape_stats(ax4):
    """
    get escape statistics and plot establishment probability
    """
    p_escape = []
    p_mutate = []
    mu = 1e-1
    p_err = []
    R = []
    
    for switch in [5,15,20,25,30,35,40,45,50]: 
        pulled_b = w.pull_histories_together('tailored_switch_at_'+str(switch), clone_type = 'blue')
        R.append(pulled_b.index[switch])
        
        tot,escaped,rw = get_establishment_statistics('tailored_switch_at_'+str(switch),switch,w_escape=6)
        p_escape.append(escaped/tot) 
        p_mutate.append(1-(1-mu)**(rw/tot))
        
        p_err.append(error(escaped,tot))
    ax4.set_xlim(xmin=500,xmax=3400)
    ax4.errorbar(R, p_escape, yerr = p_err,color = 'k', ls = '--',marker = 'o',lw=1, ms=4, capsize=1, mfs=None, label = r'$P_{escape}$')
    ax5 = ax4.twinx()
    ax4.plot(R,p_mutate,color = 'k',ls='--',marker = 'd',ms=4,lw=1, label = r'$P_{mutate}$' )
    ax5.plot(R,np.array(p_mutate)*np.array(p_escape),color = 'r',ls='-',marker='s',ms=4, lw=1, label=r'$P_{full}$')
    ax5.tick_params(axis="y", direction="in", pad=-12)
    ax4.set_yticks([0,0.1,0.2,0.3,0.4])
    ax5.set_ylim(ymin=0)
    ax5.set_yticks([0.01, 0.02, 0.03, 0.04, 0.05])
    ax5.set_yticklabels([1, 2, 3, 4, 5])

def setup_figure(save_figure=False):
    plt.rcParams.update({'font.size': 6,
                         'font.weight': 'normal',
                         'font.family': 'sans-serif'})
    mpl.rcParams['pdf.fonttype'] = 42  # to make text editable in pdf output
    mpl.rcParams['font.sans-serif'] = ['Arial']  # to make it Arial
    fig, ax = plt.subplots(figsize=(170/72,170/72),constrained_layout=True)
    escape_stats(ax)


    fig.set_constrained_layout_pads(w_pad=10 / 72, h_pad=10 / 72, hspace=2 / 72, wspace=2 / 72)
    plt.subplots_adjust(left=0.167647,right=0.9411764)
    if save_figure:
        fig.savefig('images/Escape_probability_all_connected.pdf',transparent = True)
    plt.show()

if __name__ == "__main__":
    setup_figure(save_figure=False)
