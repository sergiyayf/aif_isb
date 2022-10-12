# check if on mac and change backend if necessary (needs to be done before other imports of matplotlib
import platform
if platform.system() == 'Darwin':
    import matplotlib as mpl
    mpl.use('TkAgg')

import numpy as np
import pandas as pd
import pickle
from os.path import join

def pfail_error(n_cones, n_colonies):
    """function to calculate error of p_fail based based on total values of
    counted sectors. Only average is done for estimating the initial number of colonies"""

    n_ini = n_colonies * num_ini_mean
    err_P_fail = np.sqrt(n_cones / n_ini ** 2 +
                         (n_cones / n_ini ** 2) ** 2 * (n_colonies * num_ini_std / np.sqrt(len(num_ini))) ** 2)
    return err_P_fail

def import_data(day):
    '''imports data into DataFrame platform'''

    # set sample conditions dependent on plate (REMEMBER: the first plate has index 0 !!!)
    if day == 6:
        file_path = join('csv_output','manual_output_day06.csv')
        df = pd.read_csv(file_path)
        df.columns = ['index','plate','scene','y','x','label']

        df['CHX'] = 0
        df.loc[df['plate'] >= 4, ('CHX')] = 50

        df['BED'] = 0
        df.loc[df['plate'] >= 8,('BED')] = 4
        df.loc[df['plate'] >= 12,('BED')] = 6

        df['converted'] = 0
        df.loc[df['plate'] == 2,'converted'] = 1
        df.loc[df['plate'] == 3,'converted'] = 1

    elif day == 10:
        file_path = join('csv_output','manual_output_day10.csv')
        df = pd.read_csv(file_path)
        df.columns = ['index', 'plate', 'scene', 'y', 'x', 'label']

        # set CHX concentrations
        df['CHX'] = 0
        df.loc[df['plate'] >= 2, ('CHX')] = 50

        # set BED concentrations
        df['BED'] = 0
        df.loc[df['plate'] >= 5, ('BED')] = 4
        df.loc[df['plate'] >= 8, ('BED')] = 6

        # set plates that have the 'already-switched" control
        df['converted'] = 0
        df.loc[df['plate'] == 1, 'converted'] = 1

    else:
        print('No data for day {} available (see import_data and calculate_statistics functions).'.format(day))
        quit()  #stop the script

    return df

def calculate_statistics(df):
    '''calculates Probability of treatment failure'''
    stats_data = {'sample': [ 'ctrl-','ctrl+','0nM', '4nM', '6nM'],
                     'state1': [
                         df[(df['CHX'] == 0) & (df['BED'] == 0) & (df['converted'] == 0)].groupby(['label']).size()['state1'],
                         0,
                         df[(df['CHX'] == 50) & (df['BED'] == 0) & (df['converted'] == 0)].groupby(['label']).size()['state1'],
                         df[(df['CHX'] == 50) & (df['BED'] == 4) & (df['converted'] == 0)].groupby(['label']).size()['state1'],
                         df[(df['CHX'] == 50) & (df['BED'] == 6) & (df['converted'] == 0)].groupby(['label']).size()['state1']],
                     'state2': [
                         df[(df['CHX'] == 0) & (df['BED'] == 0) & (df['converted'] == 0)].groupby(['label']).size()['state2'],
                         df[(df['CHX'] == 0) & (df['BED'] == 0) & (df['converted'] == 1)].groupby(['label']).size()['state2'],
                         df[(df['CHX'] == 50) & (df['BED'] == 0) & (df['converted'] == 0)].groupby(['label']).size()['state2'],
                         df[(df['CHX'] == 50) & (df['BED'] == 4) & (df['converted'] == 0)].groupby(['label']).size()['state2'],
                         df[(df['CHX'] == 50) & (df['BED'] == 6) & (df['converted'] == 0)].groupby(['label']).size()['state2']]}

    # convert to DataFrame
    stats = pd.DataFrame(stats_data)

    # add number of colonies and calculate sectors per colony
    if day == 6:
        stats['num_of_colonies'] = 6
        stats.loc[2,'num_of_colonies'] = 5 # one colony was forgotten during drug application

    elif day == 10:
        stats['num_of_colonies'] = 18
        stats.loc[0:1, 'num_of_colonies'] = 6

    else:
        print('No data for day {} available (see import_data and calculate_statistics functions).'.format(day))
        quit()  # stop the script

    # calculate probabilities and errors

    stats['P_fail_s1'] = stats['state1']/(num_ini_mean*stats['num_of_colonies'])
    stats['P_fail_s2'] = stats['state2']/(num_ini_mean*stats['num_of_colonies'])
    stats['err_P_fail_s1'] = pfail_error(stats['state1'],stats['num_of_colonies'])
    stats['err_P_fail_s2'] = pfail_error(stats['state2'],stats['num_of_colonies'])

    stats.set_index(["sample"],inplace=True)

    return stats

def plot_data(stats):
    yerr = [stats['err_P_fail_s2'], stats['err_P_fail_s1']]
    ax = stats[['P_fail_s2', 'P_fail_s1']].plot.bar(stacked=True,
                                                    color=['deepskyblue','red'],
                                                    yerr=yerr)
    ax.set_xlabel('BED')
    ax.set_ylabel('Probability (per sector) of treatment failure')
    ax.set_title('day {}'.format(day))
    ax.set_ylim([0, 0.3])
    fig = ax.get_figure()

    plot_file_name = 'Pfail_day{}_bars.png'.format(day)
    fig.savefig(plot_file_name, bbox_inches='tight', dpi=600)
    print('Plot has been saved as {}'.format(plot_file_name))

def save_object(obj,pickle_name):
    try:
        with open(pickle_name, "wb") as f:
            pickle.dump(obj, f, protocol=pickle.HIGHEST_PROTOCOL)
            print('Object has been saved as {} '.format(pickle_name))
    except Exception as ex:
        print("Error during pickling object (Possibly unsupported):", ex)

#MAIN

# calculate average number of individual cells at day 0 and associated standard dev
num_ini = [158,161,167,174,158,152]
num_ini_mean = np.mean(num_ini)
num_ini_std = np.std(num_ini)
print('average number of initial clones per colony: {0:.2f} +/- {1:.2f}'.format(num_ini_mean, num_ini_std))

days = [6, 10]

for day in days:
    # import data
    df = import_data(day)

    # calculate statisitcs
    stats = calculate_statistics(df)

    # plot data
    plot_data(stats)
    
    # save data
    save_object(stats,'exp_stats_day{}.pickle'.format(day))