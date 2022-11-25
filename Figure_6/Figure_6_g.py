from chist import width as w
import h5py
import matplotlib as mpl
mpl.use('TkAgg')
from matplotlib import pyplot as plt
import pandas as pd
from chist import PhysiCellTrajectories as pcT

def setup_figure(save_figure=False):
    plt.rcParams.update({'font.size': 6,
                         'font.weight': 'normal',
                         'font.family': 'sans-serif'})
    mpl.rcParams['pdf.fonttype'] = 42  # to make text editable in pdf output
    mpl.rcParams['font.sans-serif'] = ['Arial']  # to make it Arial
    fig, ax = plt.subplots(figsize=(170/72,170/72),constrained_layout=True)

    # load no switch sample
    h5File = 'chist/data/ER_data_collection.h5'
    f = h5py.File(h5File, 'r')
    counts_red = 0 
    for key in f['data/no_switch_control']:
        if key != 'ds1' and key!='ds2' and key != 'ds9' and key != 'ds4' and key!= 'ds17' and key!='ds14': 
            df = pd.read_hdf(h5File, 'data/no_switch_control/'+key+'/red')
                
            counts_red += df.count(axis=1).values 

    probability = counts_red/max(counts_red)
    # load random switch sample
    colname = 'random_switching_new'
    pulled_t = w.pull_histories_together(colname)
    pulled_r = w.pull_histories_together(colname,clone_type = 'red')
    pulled_b = w.pull_histories_together(colname, clone_type = 'blue')
    dfs ={'Red': pulled_r, 'Blue': pulled_b, 'Tot': pulled_t}
    CT = pcT.CloneTrajectory(dfs)
    CT.plot_efficacy(probability,max(counts_red),ax,color = 'k')

    fig.set_constrained_layout_pads(w_pad=10 / 72, h_pad=10 / 72, hspace=2 / 72, wspace=2 / 72)
    if save_figure:
        fig.savefig('images/Efficacy.pdf', transparent=True)
    plt.show()

if __name__ == "__main__":
    setup_figure(save_figure=False)
