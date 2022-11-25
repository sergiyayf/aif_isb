import matplotlib as mpl
mpl.use('TkAgg')
from scipy import interpolate
import matplotlib.pyplot as plt
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

def plot_interpolated_efficacy(ax, CHX, BED, treatment, color='r', label='a set'):
    """
    plot efficacy
    """
    filename = os.path.join('..','data','experimental_data.h5')
    colplt = Colony(filename)

    # load radii data
    Rad_no_switch = colplt.get_radii(50, 0, treatment)
    Rad_switch = colplt.get_radii(CHX, BED, treatment)
    Rad_errs_sw = colplt.get_radii_std(CHX, BED, treatment)[1:]
    Rad_errs_no_sw = colplt.get_radii_std(50, 0, treatment)[1:]

    # interpolate no switch sample
    no_switch_n = colplt.get_numbers(50, 0, treatment, 0) + colplt.get_numbers(50, 0, treatment,
                                                                               1) + colplt.get_numbers(50, 0, treatment,
                                                                                                       2)
    no_switch_function = interpolate.interp1d(Rad_no_switch, no_switch_n)
    # interpolate switch sample
    switch_n = colplt.get_numbers(CHX, BED, treatment, 0) + colplt.get_numbers(CHX, BED, treatment,
                                                                               1) + colplt.get_numbers(CHX, BED,
                                                                                                       treatment, 2)
    switch_function = interpolate.interp1d(Rad_switch, switch_n)

    new_r_switch = np.linspace(int(Rad_switch[0]) + 1, int(Rad_switch[-1]),
                               int(Rad_switch[-1]) + 1 - int(Rad_switch[0]))
    new_r_no_switch = np.linspace(int(Rad_no_switch[0]) + 1, int(Rad_no_switch[-1]),
                                  int(Rad_no_switch[-1]) + 1 - int(Rad_no_switch[0]))

    # new probabilities
    switch = switch_function(new_r_switch) / switch_n[0]
    no_switch = no_switch_function(new_r_no_switch) / no_switch_n[0]
    switch = switch[0:len(no_switch)]

    # indices of real radii in interpolated ones
    idx_nsw = []
    idx_sw = []
    for r in Rad_no_switch:
        idx_nsw.append(np.abs(new_r_no_switch - r).argmin())

        idx_sw.append(np.abs(new_r_switch - r).argmin())

    # take only points of real radii
    switch = switch[idx_sw]
    no_switch = no_switch[idx_nsw]
    new_r_no_switch = new_r_no_switch[idx_nsw]
    new_r_switch = new_r_switch[idx_sw]

    # calculate errors
    # Poisson error y-axis
    delta_switch_probability = Poisson_error(switch*switch_n[0],switch_n[0])
    # derivative to get into account x-axis
    switch_deriv = np.diff(switch)/np.diff(new_r_switch)
    x_err = np.insert(switch_deriv*Rad_errs_sw, 0, 0.)
    delta_switch = np.sqrt( delta_switch_probability**2 + (x_err)**2 )

    # same for no switch
    delta_no_switch_probability = Poisson_error(no_switch * no_switch_n[0], no_switch_n[0])
    # drivative to get into account x-axis
    no_switch_deriv = np.diff(no_switch) / np.diff(new_r_no_switch)
    x_err_ns = np.insert(no_switch_deriv * Rad_errs_no_sw, 0, 0.)
    delta_no_switch = np.sqrt(delta_no_switch_probability ** 2 + (x_err_ns) ** 2)

    err = no_switch / switch * np.sqrt(
        (delta_switch / switch) ** 2 +
        (delta_no_switch / no_switch) ** 2)
    #ax.errorbar(new_r_no_switch, switch, yerr = delta_switch,color='c', alpha=0.5)
    #ax.errorbar(new_r_no_switch, no_switch,yerr = delta_no_switch, color='r', alpha=0.5)
    ax.plot(new_r_no_switch, 1 - no_switch / switch, '-o',ms = 1, linewidth=1., color=color, label=label)
    ax.fill_between(new_r_no_switch, 1 - no_switch / switch - err, 1 - no_switch / switch + err, linewidth=0,
                    color=color, alpha=0.5)
    # Find the cut and plot window of inefficacy
    x = new_r_no_switch[4:6]
    y = 1 - no_switch[4:6] / switch[4:6] - err[4:6]
    f = interpolate.interp1d(x, y)
    g = interpolate.interp1d(x, y + err[4:6])

    xnew = np.linspace(x[0], x[1], 1000)
    ynew = f(xnew)
    yline = g(xnew)
    yintercept = yline[abs(ynew) == min(abs(ynew))]

    xintercept = xnew[abs(ynew) == min(abs(ynew))]
    ax.set_xlim([1000, 8500])
    ax.set_ylim([-.2, .75])
    ax.axvline(x=xintercept, ymin=0.2, color=color)
    ax.fill_betweenx([0., .75], x1=0, x2=xintercept, color=color, alpha=.4)
    ax.axhline(y=0, color='k', linestyle='--')
    #ax.axhline(y=yintercept, color='k', linestyle=':', linewidth=1, label='Non-zero efficacy')

    return 0;

def setup_figure(save_figure=False):
    plt.rcParams.update({'font.size': 6,
                         'font.weight': 'normal',
                         'font.family': 'sans-serif'})
    mpl.rcParams['pdf.fonttype'] = 42  # to make text editable in pdf output
    mpl.rcParams['font.sans-serif'] = ['Arial']  # to make it Arial
    fig, ax = plt.subplots(figsize=(170 / 72, 170 / 72), constrained_layout=True)
    plot_interpolated_efficacy(ax, 50, 4, 10, color='k')
    fig.set_constrained_layout_pads(w_pad=10 / 72, h_pad=10 / 72, hspace=2 / 72, wspace=2 / 72)
    if save_figure:
        fig.savefig('figures/Interpolated_efficacy.pdf', transparent=True)

if __name__ == '__main__':
    setup_figure(save_figure=False)