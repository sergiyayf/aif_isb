'''
This script takes data from experiments and simulations to create a combined barplot.
Run barplots_Pfail_experiments.py first.
'''

import matplotlib as mpl
mpl.use('TkAgg')
mpl.rcParams['pdf.fonttype'] = 42 #to make text editable in pdf output
mpl.rcParams['font.sans-serif'] = ['Arial'] #to make it Arial
import matplotlib.pyplot as plt

import numpy as np
import pandas as pd
import pickle




def load_object(filename):
    """function to reload saved data"""
    try:
        with open(filename, "rb") as f:
            return pickle.load(f)
    except Exception as ex:
        print("Error during unpickling object (Possibly unsupported):", ex)


def errorprop_sum(sigma_A, sigma_B):
    """returns the standard deviation sigma_f for f = A + B"""

    sigma_f = np.sqrt(sigma_A ** 2 + sigma_B ** 2)

    return sigma_f


def errorprop_ratio(A, B, sigma_A, sigma_B):
    """returns the standard deviation sigma_f for f = A + B"""

    sigma_f = abs(A / B) * np.sqrt((sigma_A / A) ** 2 + (sigma_B / B) ** 2)

    return sigma_f


def errorprop_ratio(A, B, sigma_A, sigma_B):
    """returns the standard deviation sigma_f for f = A + B"""

    sigma_f = np.sqrt(sigma_A ** 2 + sigma_B ** 2)

    return sigma_f


def combine_statistics(experiment_stats, simulation_stats):
    """combines statistics from experiments and simulations into one comprehensive data frame object"""

    # initialize with experimental samples
    combined_stats = pd.concat([
        experiment_stats,
        simulation_stats])

    return combined_stats


def plot_probabilities(combined_stats, samples, day):
    """creates a barplot of the data specified in samples and saves it as a figure"""

    selected_stats = combined_stats.loc[samples]

    yerr = [selected_stats['err_P_fail_s1'], selected_stats['err_P_fail_s2']]
    ax = selected_stats[['P_fail_s1', 'P_fail_s2']].plot.bar(stacked=True,
                                                             color=['red', 'deepskyblue'],
                                                             yerr=yerr)
    ax.set_xlabel('BED')
    ax.set_ylabel('Probability (per sector) of treatment failure')
    ax.set_title(f'day {day}')
    ax.set_ylim([0, 0.3])
    fig = ax.get_figure()

    # save output as png
    output_folder = 'Figure_output'
    plot_file_name = output_folder + f'/Pfail_combined_bars_day{day}.pdf'
    fig.savefig(plot_file_name, bbox_inches='tight', dpi=600)
    print('Plot has been saved in {}'.format(plot_file_name))


def plot_efficacy(combined_stats, samples, control, day):
    """creates a barplot of the data specified in samples and saves it as a figure"""

    selected_stats = combined_stats.loc[samples]
    control_stats = combined_stats.loc[control]

    # calculate totals

    selected_stats['efficacy'] = 1 - (control_stats['P_fail_s1'] + control_stats['P_fail_s2']) / \
                                 (selected_stats['P_fail_s1'] + selected_stats['P_fail_s2'])

    # caluclate error of efficacy

    err_efficacy =(control_stats['P_fail_s1'] + control_stats['P_fail_s2']) / (selected_stats['P_fail_s1'] + selected_stats['P_fail_s2']) * np.sqrt(
        ((errorprop_sum(selected_stats['err_P_fail_s1'],selected_stats['err_P_fail_s2'])) /
        (selected_stats['P_fail_s1'] + selected_stats['P_fail_s2'])) ** 2 + ((errorprop_sum(control_stats['err_P_fail_s1'],control_stats['err_P_fail_s2'])) /
        (control_stats['P_fail_s1'] + control_stats['P_fail_s2'])) ** 2 )
    selected_stats['err_efficacy'] = err_efficacy
    #selected_stats['err_efficacy'] = errorprop_ratio(control_stats['P_fail_s1'] + control_stats['P_fail_s2'],
    #                                                 selected_stats['P_fail_s1'] + selected_stats['P_fail_s2'],
    #                                                 errorprop_sum(
    #                                                     control_stats['err_P_fail_s1'],
    #                                                     control_stats['err_P_fail_s2']),
    #                                                 errorprop_sum(
    #                                                     selected_stats['err_P_fail_s1'],
    #                                                     selected_stats['err_P_fail_s2'])
    #                                                 )

    ax = selected_stats[['efficacy']].plot.bar(color='gray', yerr=selected_stats['err_efficacy'])
    ax.set_xlabel('BED')
    ax.set_ylabel('Efficacy (1-P_ctrl/P_sample)')
    ax.set_title(f'day {day}')
    ax.set_ylim([-0.1, 1])
    ax.axhline(y=0, color='k', linestyle=':')
    fig = ax.get_figure()

    # save output as png
    output_folder = 'Figure_output'
    plot_file_name = output_folder + f'/Efficacy_combined_bars_day{day}.pdf'
    #fig.savefig(plot_file_name, bbox_inches='tight', dpi=600)
    print('Plot has been saved in {}'.format(plot_file_name))


def main():
    '''main function'''

    # load experimental and simulated data, combine to one big data
    days = [6, 10]
    for day in days:
        experiment_stats = load_object(f'exp_stats_day{day}.pickle')
        simulation_stats = load_object('sim_stats.pickle')
        combined_stats = combine_statistics(experiment_stats, simulation_stats)

        # create composite plot
        # samples_to_plot = ['ctrl-', '0nM', 'rw_s=0.01_mu=0_D=0.07', 'rw_s=0_mu=0_D=0.07', 'rw_s=1e-05_mu=0_D=0.07',
        #                    '4nM', 'rw_s=0.01_mu=0.0001_D=0.07', 'rw_s=0_mu=0.0001_D=0.07', 'rw_s=1e-05_mu=0.0001_D=0.07'

        # plot experimental samples
        plot_probabilities(combined_stats, ['0nM', '4nM', '6nM'], day)
        plot_efficacy(combined_stats, ['0nM','4nM', '6nM'], '0nM', day)

        # # plot simulated samples
        # plot_probabilities(combined_stats, ['rw_s=0.01_mu=0_D=0.07', 'rw_s=0.01_mu=0.0001_D=0.07'], day)
        # plot_efficacy(combined_stats, ['rw_s=0.01_mu=0.0001_D=0.07'], 'rw_s=0.01_mu=0_D=0.07', day)


    plt.show()

if __name__ == '__main__':
    main()
