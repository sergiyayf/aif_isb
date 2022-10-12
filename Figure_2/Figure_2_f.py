import matplotlib as mpl
mpl.use('TkAgg')
import matplotlib.pyplot as plt
from streaky import analysis as ana
from auxiliary.ColonyPlot import *
import os

def error(a, b):
    """
    error of a/b for Poisson
    """
    a = a[1:]
    return np.insert(a / b * (np.sqrt((np.sqrt(a) / a) ** 2 + (np.sqrt(b) / b) ** 2)), 0, 0.)

def Poisson_error(a, b):
    """
    error of a/b for Poisson
    """

    return a / b * (np.sqrt((np.sqrt(a) / a) ** 2 + (np.sqrt(b) / b) ** 2))


def plot_experimental_probability(ax, CHX, BED, treatment, **kwargs):
    """
    """
    filename = os.path.join('..','data','experimental_data.h5')
    colplt = Colony(filename)
    Rad = colplt.get_radii(CHX, BED, treatment)
    tot_num = colplt.get_numbers(CHX, BED, treatment, 0) + colplt.get_numbers(CHX, BED, treatment,
                                                                              1) + colplt.get_numbers(CHX, BED,
                                                                                                      treatment, 2)
    P = tot_num / tot_num[0]
    Rad_errs = colplt.get_radii_std(CHX, BED, treatment)
    ax.errorbar(Rad, P, error(tot_num, tot_num[0]), Rad_errs, **kwargs)
    ax.set_yscale('log')

def plot_probability(DataFrame, ax=None, color='k',fill_between=False, **kwargs):
    df = DataFrame
    ax.plot(df['radius'],df['psurv_total'], color= color, **kwargs)
    err = Poisson_error(df['num_total'],df['num_total'][0])
    if fill_between == True:
        ax.fill_between(df['radius'],df['psurv_total']-err,df['psurv_total']+err, alpha = 0.5, lw=0, color=color)

    ax.set_yscale('log')

def setup_figure():
    mpl.rcParams['pdf.fonttype'] = 42  # to make text editable in pdf output
    mpl.rcParams['font.sans-serif'] = ['Arial']  # to make it Arial
    plt.rcParams.update({'font.size': 6,
                         'font.weight': 'normal',
                         'font.family': 'sans-serif'})

    analysis = ana.Analysis()
    colors = [plt.get_cmap("Greens_r")(x) for x in np.linspace(0, 1, 6)]
    colors_ctrl = [plt.get_cmap("Greys_r")(x) for x in np.linspace(0, 1, 6)]
    fig, ax = plt.subplots(figsize=(170 / 72, 170 / 72), constrained_layout=True)
    analysis.load_dataset(filename=os.path.join('..','data','rw_output_Serhii_main.hdf5'), group='static_s=1.3e-2_mu=1.0e-4_d=0.23_wc=280_w0=r20pm5')
    df = analysis.get_summary_dataframe()
    fill_between = True
    plot_probability(df, ax, color=colors[2],fill_between=fill_between, linestyle=':')

    analysis.load_dataset(filename=os.path.join('..','data','rw_output_Serhii_main.hdf5'), group='static_s=1.3e-2_mu=0_d=0.23_wc=280_w0=r20pm5')
    df2 = analysis.get_summary_dataframe()
    df2 = df2[0:263]
    fill_between = False
    plot_probability(df2, ax, color=colors_ctrl[2],fill_between=fill_between, linestyle=':')
    ax.set_ylim([0.001, 1.2])
    plot_experimental_probability(ax, 50, 4, 10, color='green', label='with rescue', linestyle='', marker='s', ms=1,
                                  alpha=1, capsize=1)
    plot_experimental_probability(ax, 50, 0, 10, color='k', label='no rescue', linestyle='', marker='s', ms=1,
                                  alpha=1, capsize=1)
    fig.set_constrained_layout_pads(w_pad=10 / 72, h_pad=10 / 72, hspace=2 / 72, wspace=2 / 72)

if __name__ == '__main__':
    setup_figure()