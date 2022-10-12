import matplotlib as mpl
mpl.use('TkAgg')
import matplotlib.pyplot as plt
from streaky import analysis as ana
import numpy as np
from auxiliary import efficacy
from scipy import interpolate
import os
mpl.rcParams['pdf.fonttype'] = 42 #to make text editable in pdf output
mpl.rcParams['font.sans-serif'] = ['Arial'] #to make it Arial
plt.rcParams.update({'font.size': 6,
                    'font.weight': 'normal',
                    'font.family': 'sans-serif'})

def Poisson_error(a, b):
    """
    error of a/b for Poisson
    """
    return a / b * (np.sqrt((np.sqrt(a) / a) ** 2 + (np.sqrt(b) / b) ** 2))

def plot_efficacy(DataFrame, control, ax=None, color ='k',**kwargs):
    df = DataFrame
    ctrl = control
    efficacy = 1-ctrl['psurv_total']/df['psurv_total']

    # get efficacy errors
    no_switch = ctrl['psurv_total']
    switch = df['psurv_total']
    no_switch_n = no_switch * max(ctrl['num_total'])
    err = no_switch/switch*np.sqrt(
        (Poisson_error(df['num_total'], df['num_total'][0]) / switch) ** 2 +
        (Poisson_error(no_switch_n, no_switch_n[0]) / no_switch) ** 2)
    ax.plot(df['radius'], efficacy, alpha = 1, color=color,**kwargs)
    ax.fill_between(df['radius'], efficacy-err, efficacy+err, alpha = 0.5, lw = 0, color=color)

def window_of_inefficacy(DataFrame, control, ax=None, color ='k',**kwargs):
    df = DataFrame
    ctrl = control
    efficacy = 1 - ctrl['psurv_total'] / df['psurv_total']

    # get efficacy errors
    no_switch = ctrl['psurv_total']
    switch = df['psurv_total']
    no_switch_n = no_switch * max(ctrl['num_total'])
    err = no_switch / switch * np.sqrt(
        (Poisson_error(df['num_total'], df['num_total'][0]) / switch) ** 2 +
        (Poisson_error(no_switch_n, no_switch_n[0]) / no_switch) ** 2)

    # Find the cut and plot window of inefficacy
    x = np.array(df['radius'])[2500:4500]
    y = 1 - no_switch[2500:4500] / switch[2500:4500] - err[2500:4500]
    f = interpolate.interp1d(x, y)
    g = interpolate.interp1d(x, y + err[2500:4500])

    xnew = np.linspace(x[0], x[-1], 1000)
    ynew = f(xnew)
    yline = g(xnew)
    yintercept = yline[abs(ynew) == min(abs(ynew))]

    xintercept = xnew[abs(ynew) == min(abs(ynew))]

    ax.axvline(x=xintercept, ymin=0.15, color=color)
    ax.fill_betweenx([0., 1.05], x1=1800, x2=xintercept, color=color, alpha=.2)
    ax.axhline(y=0, color='k', linestyle='--')
    ax.axhline(y=yintercept, color='k', linestyle=':', linewidth=1, label='Non-zero efficacy')

def setup_figure(save_figure=False):
    groups = ['dynamic_s=1.3e-2_mu=1.0e-4_d=0.23_wc=280_w0=r20pm5_f',
                'static_s=0_mu=1.0e-4_d=0.23_wc=280_w0=r20pm5',
                'static_s=1.3e-3_mu=1.0e-4_d=0.23_wc=280_w0=r20pm5']

    controls = ['dynamic_s=1.3e-2_mu=0_d=0.23_wc=280_w0=r20pm5_f',
                'static_s=0_mu=0_d=0.23_wc=280_w0=r20pm5',
                'static_s=1.3e-3_mu=0_d=0.23_wc=280_w0=r20pm5']#,

    color = [plt.get_cmap("Greys_r")(x) for x in np.linspace(0, 1, 6)]
    linestyles = ['-','--',':','-.']
    analysis = ana.Analysis()

    fig2, ax2 = plt.subplots(figsize=(170/72,170/72),constrained_layout=True)

    # plot simulation data
    for idx, group in enumerate(groups):
        analysis.load_dataset(filename=os.path.join('..','data','rw_output_Serhii_main.hdf5'), group=group)
        df = analysis.get_summary_dataframe()
        analysis.load_dataset(filename=os.path.join('..','data','rw_output_Serhii_main.hdf5'), group=controls[idx])
        df_control = analysis.get_summary_dataframe()


        # plot survival probabilities
        plot_efficacy(df,df_control,ax=ax2,color = color[idx],linestyle = linestyles[idx])
        if group == 'dynamic_s=1.3e-2_mu=1.0e-4_d=0.23_wc=280_w0=r20pm5_f':
            window_of_inefficacy(df,df_control,ax=ax2,color = color[idx],linestyle = linestyles[idx])

    efficacy.plot_efficacy_only_points(ax2,50,4,10,filename=os.path.join('..','data','experimental_data.h5'),color='r',label='experimental data')
    ax2.set_ylim([-0.2,1.05])
    ax2.axhline(y=0,xmin=0,xmax=9000,linestyle='--',color='grey')
    ax2.legend()
    fig2.set_constrained_layout_pads(w_pad=10 / 72, h_pad=10 / 72, hspace=2 / 72, wspace=2 / 72)
    if save_figure:
        fig2.savefig('figures/Efficacy_with_experiment.pdf', transparent=True)

    plt.show()

if __name__=='__main__':
    setup_figure(save_figure=False)