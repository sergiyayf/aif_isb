"""
sandbox code for using chist package to plot things 
"""
import h5py
from chist import width as w
import matplotlib as mpl
mpl.use('TkAgg')
from matplotlib import pyplot as plt 
from chist.auxiliary.analyze_history import *
from chist.establishment import get_establishment_statistics
import numpy as np
from chist import PhysiCellTrajectories as pcT
import seaborn as sns
import statsmodels.api as sm
from scipy.stats import norm

plt.rcParams.update({'font.size': 6,
                    'font.weight': 'normal',
                    'font.family': 'sans-serif'})
mpl.rcParams['pdf.fonttype'] = 42 #to make text editable in pdf output
mpl.rcParams['font.sans-serif'] = ['Arial'] #to make it Arial

custom_blue =(82/255,175/255,230/255)
custom_red =(190/255,28/255,45/255)

def error(a,b): 
    """
    error of a/b for Poisson
    """
    return a/b*(np.sqrt( (np.sqrt(a)/a)**2 + (np.sqrt(b)/b)**2))

def average_width_example(): 
    """
    plot average width 
    """
    fig, ax = plt.subplots()
    
    for switch in [5,15,20,25,30,35,40,45,50]:
        pulled_t = w.pull_histories_together('tailored_switch_at_'+str(switch))
        pulled_r = w.pull_histories_together('tailored_switch_at_'+str(switch),clone_type = 'red')
        pulled_b = w.pull_histories_together('tailored_switch_at_'+str(switch), clone_type = 'blue')
                
        #ax.plot(pulled_t.mean(axis = 1),color = 'k', label = 'tot')
        ax.plot(pulled_r.mean(axis = 1),color = 'r', label = 'r')
        ax.plot(pulled_b.mean(axis = 1),color = 'b', label = 'b')
        
    ax.set_title('average width')
    ax.set_xlabel('Radius')
    ax.set_ylabel('width in cell number') 
    #ax.legend()
    return
            

def fit_line_example(): 
    """
    fit line to average width
    """
    fig2, ax2 = plt.subplots()
    for switch in [5,15,20,25,30,35,40,45,50]:
        
        pulled_b = w.pull_histories_together('tailored_switch_at_'+str(switch), clone_type = 'blue')
        w.blue_fit_line(ax2,pulled_b, include_original_errorbars = False, label = switch)
    ax2.set_title('average width')
    ax2.set_xlabel('Radius')
    ax2.set_ylabel('width in cell number') 
    #ax2.legend()
    return

def rho_escape(): 
    """
    plot rho escape
    """
    fig3, ax3 = plt.subplots()
    rhos = []
    err_rhos = []
    switching_rads = [] 
    for switch in [5,15,20,25,30,35,40,45,50]:
        
        pulled_b = w.pull_histories_together('tailored_switch_at_'+str(switch), clone_type = 'blue')
        
        rho, rho_err = w.get_rho_escape(pulled_b,nstd = 1, escape_width = 7)
        rhos.append(rho)
        err_rhos.append(rho_err)
        switching_rads.append(pulled_b.index[switch])
        
    ax3.errorbar(switching_rads, rhos, yerr = err_rhos)
    ax3.set_title('Rho escape')
    ax3.set_xlabel('Switching radius')
    ax3.set_ylabel('Rho escape') 
    return    
def escape_stats():
    """
    get escape statistics and plot establishment probability
    """
    p_escape = []
    p_mutate = []
    mu = 1e-2
    p_err = []
    R = []
    fig4, ax4 = plt.subplots()
    for switch in [5,15,20,25,30,35,40,45,50]: 
        pulled_b = w.pull_histories_together('tailored_switch_at_'+str(switch), clone_type = 'blue')
        R.append(pulled_b.index[switch])
        
        tot,escaped,rw = get_establishment_statistics('tailored_switch_at_'+str(switch),switch,w_escape=6)
        p_escape.append(escaped/tot) 
        p_mutate.append(1-(1-mu)**(rw/tot))
        
        p_err.append(error(escaped,tot))
    ax4.errorbar(R, p_escape, yerr = p_err,color = 'k', ls = '',marker = 'o', ms = 10, linewidth = 2, mfs=None, label = 'P_escape')
    ax5 = ax4.twinx()
    ax5.plot(R,p_mutate,color = 'purple', label = 'P_mutate' )
    ax5.plot(R,3*np.array(p_mutate)*np.array(p_escape),color = 'red',ls='--',label='3 x P_full')
    ax5.legend()

def class_clones():   
    switch = 20 
    fig, ax = plt.subplots()
    pulled_t = w.pull_histories_together('tailored_switch_at_'+str(switch))
    pulled_r = w.pull_histories_together('tailored_switch_at_'+str(switch),clone_type = 'red')
    pulled_b = w.pull_histories_together('tailored_switch_at_'+str(switch), clone_type = 'blue')
    
    dfs ={'Red': pulled_r, 'Blue': pulled_b, 'Tot': pulled_t}
    CT = pcT.CloneTrajectory(dfs) 
    print(CT.R_df)
    #CT.plot(ax, clone = 'both') 
    print(CT.get_probability())
    CT.plot_probability(ax)


def growth_layer_width_example():
    """
    plot average width
    """

    h5File = 'chist/data/growth_layer.h5'

    fig, axs = plt.subplots()
    for diffusion in [7, 9, 11]:
        growth_layer = pd.read_hdf(h5File, 'data/sw_35_diff_' + str(diffusion) + '/ds3/growth_layer')
        axs.plot(growth_layer,label = str(diffusion))

    axs.legend()
    axs.set_ylabel('Growth layer width, microns')
    fig, ax = plt.subplots()

    for switch in [7,9,11]:
        pulled_t = w.pull_histories_together('sw_35_diff_' + str(switch))
        pulled_r = w.pull_histories_together('sw_35_diff_' + str(switch), clone_type='red')
        pulled_b = w.pull_histories_together('sw_35_diff_' + str(switch), clone_type='blue')

        # ax.plot(pulled_t.mean(axis = 1),color = 'k', label = 'tot')
        ax.plot(pulled_r.mean(axis=1),  label=str(switch))
        ax.plot(pulled_b.mean(axis=1), label=str(switch))

    ax.set_title('average width')
    ax.set_xlabel('Radius')
    ax.set_ylabel('width in cell number')
    ax.legend()
    return


def random_width_with_errorbars():
    fig, ax = plt.subplots(figsize=(235/72,170/72),constrained_layout=True)
    pulled_r = w.pull_histories_together('random_switching_new', clone_type='red')
    pulled_b = w.pull_histories_together('random_switching_new', clone_type='blue') #random_switching_new

    ax.plot(pulled_b.mean(axis=1), color=custom_blue, label='c')
    ax.fill_between(pulled_b.index, pulled_b.mean(axis=1) - pulled_b.std(axis=1),
                    pulled_b.mean(axis=1) + pulled_b.std(axis=1), color=custom_blue, label='c', alpha=0.5)
    ax.plot(pulled_r.mean(axis=1), color=custom_red, label='r')
    ax.fill_between(pulled_r.index, pulled_r.mean(axis=1) - pulled_r.std(axis=1),
                    pulled_r.mean(axis=1) + pulled_r.std(axis=1), color=custom_red, label='r', alpha=0.5)
    ax.grid(True, linestyle='--', color='grey')
    ax.set_ylim([0,15])
    fig.set_constrained_layout_pads(w_pad=10 / 72, h_pad=10 / 72, hspace=2 / 72, wspace=2 / 72)

    #fig.savefig('images/width_random.pdf',transparent=True)
def width_distribution_r():

    pulled_r = w.pull_histories_together('random_switching_new', clone_type='red')
    pulled_b = w.pull_histories_together('random_switching_new', clone_type='blue')  # random_switching_new
    n_bins = 10
    max_w = 20
    n_rads = 10

    #fig, ax = plt.subplots(figsize=(170/72,45/72),constrained_layout=True)
    fig, ax = plt.subplots()
    colors = [plt.get_cmap("Reds")(x) for x in np.linspace(0.1, 1, 10)]
    for idx, loc in enumerate(range(10,101,10)):
        x=pulled_r.iloc[[loc]]
        width_array = x.values[0][~np.isnan(x.values[0])]
        width, counts = np.unique(width_array, return_counts=True)


        #ax.scatter(width, counts/np.sum(counts),color=colors[idx],s=20)
        #ax.plot(width, counts / np.sum(counts), color=colors[idx])
        #sns.histplot(data=x.values[0],ax=ax, color=colors[idx], lw=2,element="step",alpha=0,cumulative=True,kde=True)
        #sns.histplot(data=x.values[0], ax=ax, color=colors[idx], lw=2, element="step", kde=False, alpha=0,binwidth=0.1)
        sns.kdeplot(data=x.values[0], ax=ax, color=colors[idx], lw=2, alpha=1, bw=1.5, cumulative=False)
        #sns.distplot(x, n_bins, ax=ax, kde_kws={"color": colors[idx], "lw": 2,"bw":1.5},
        #             hist_kws={"histtype": "step", "linewidth": 3,
        #                       "alpha": 1, "color": "g"},
        #             hist=False).set(xlim=(0, max_w))

    ax.set_xlim([15, 0])
    ax.set_ylabel("")
    ax.yaxis.tick_right()
    ax.set_xticks([0,2,4,6,8,10,12,14])
    #ax.set_yticklabels(ax.get_yticks(), rotation=90)
    #ax.grid(True, linestyle='--', color='grey')
    fig.set_constrained_layout_pads(w_pad=20 / 72, h_pad=0, hspace=0, wspace=1 / 72)
    plt.subplots_adjust(left=0.058823, right=0.8676471, top=0.99, bottom=0.01)
    #fig.savefig(r'images\Width_distribution_r_scatter.pdf', transparent=True)
def width_distribution_b():

    pulled_b = w.pull_histories_together('random_switching_new', clone_type='blue')  # random_switching_new
    n_bins = 20
    max_w = 20
    n_rads = 10

    fig, ax = plt.subplots(figsize=(170/72,45/72),constrained_layout=True)
    colors = [plt.get_cmap("Blues")(x) for x in np.linspace(0.1, 1, 10)]
    for idx, loc in enumerate(range(10, 101, 10)):
        x = pulled_b.iloc[[loc]]
        print(x)

        sns.distplot(x,bins = n_bins, ax=ax, kde_kws={"color": colors[idx], "lw": 2, "bw": 1.5}, kde = True,
                     hist_kws={"histtype": "bar", "linewidth": 3,
                               "alpha": 1, "color": colors[idx]},
                     hist=False).set(xlim=(0, max_w))
    ax.set_xlim([15, 0])
    ax.set_ylabel("")
    ax.yaxis.tick_right()
    ax.set_xticks([0,2,4,6,8,10,12,14])
    ax.set_yticklabels(ax.get_yticks(), rotation=90)
    #ax.grid(True, linestyle='--', color='grey')
    fig.set_constrained_layout_pads(w_pad=20 / 72, h_pad=0, hspace=0, wspace=1 / 72)
    plt.subplots_adjust(left=0.058823, right=0.8676471, top=0.99, bottom=0.01)
    #fig.savefig(r'images\Width_distribution_b.pdf', transparent=True)

def plot_colorbars():
    fig, ax = plt.subplots(figsize=(6 , 2 ))
    cmap = mpl.colors.ListedColormap([plt.get_cmap("Reds")(x) for x in np.linspace(.1, 1, 10)], 'my_map')

    cb1 = ax.figure.colorbar(mpl.cm.ScalarMappable(cmap=cmap), orientation='horizontal',
                             ticks=[x + 0.05 for x in np.linspace(0, 1, 10)])
    cb1.ax.set_xticklabels([])
    #fig.savefig(r'images\cbar_red.pdf', transparent=True)
    fig, ax = plt.subplots(figsize=(6 , 2 ))
    cmap = mpl.colors.ListedColormap([plt.get_cmap("Blues")(x) for x in np.linspace(0.1, 1, 10)], 'my_map')

    cb1 = ax.figure.colorbar(mpl.cm.ScalarMappable(cmap=cmap), orientation='horizontal',
                             ticks=[x + 0.05 for x in np.linspace(0, 1, 10)])
    cb1.ax.set_xticklabels([])
    #fig.savefig(r'images\cbar_blue.pdf', transparent=True)

def main():
    #average_width_example()
    #fit_line_example()
    #rho_escape()
    #escape_stats()
    #class_clones()

    #random_width_with_errorbars()
    width_distribution_r()
    #width_distribution_b()
    #class_clones()
    #escape_stats()
    #plot_colorbars()

    plt.show()

if __name__ == "__main__":
    main()
