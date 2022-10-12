from chist import width as w
import matplotlib as mpl
mpl.use('TkAgg')
from matplotlib import pyplot as plt 


def rho_escape(ax3): 
    """
    plot rho escape
    """
    
    rhos = []
    err_rhos = []
    switching_rads = [] 
    for switch in [5,15,20,25,30,35,40,45,50]:
        
        pulled_b = w.pull_histories_together('tailored_switch_at_'+str(switch), clone_type = 'blue')
        
        rho, rho_err = w.get_rho_escape(pulled_b,nstd = 1, escape_width = 6)
        rhos.append(rho)
        err_rhos.append(rho_err)
        switching_rads.append(pulled_b.index[switch])
        
    ax3.errorbar(switching_rads, rhos, yerr = err_rhos, color ='k')


def setup_figure(save_figure=False):
    plt.rcParams.update({'font.size': 6,
                         'font.weight': 'normal',
                         'font.family': 'sans-serif'})
    mpl.rcParams['pdf.fonttype'] = 42  # to make text editable in pdf output
    mpl.rcParams['font.sans-serif'] = ['Arial']  # to make it Arial
    fig, ax = plt.subplots(figsize=(150/72,90/72),constrained_layout=True)

    ax.set_yticks([2000,4000,6000])
    ax.set_yticklabels([2,4,6])
    ax.set_yticklabels(ax.get_yticklabels(),rotation=90)

    rho_escape(ax)
    if save_figure:
        fig.savefigure('rho_escape.pdf',transparent=True)
    plt.show()

if __name__ == "__main__":
    setup_figure(save_figure=False)
