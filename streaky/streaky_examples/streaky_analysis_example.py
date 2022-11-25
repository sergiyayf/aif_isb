from streaky import analysis

import matplotlib as mpl
mpl.use('TkAgg')
mpl.rcParams['pdf.fonttype'] = 42 #to make text editable in pdf output
mpl.rcParams['font.sans-serif'] = ['Arial'] #to make it Arial

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

analysis = analysis.Analysis()
fig1, ax1 = plt.subplots(1,1)

groups = [
    'withswitching',
    'noswitching',
    'static_withswitching',
    'static_noswitching',
    'static_highcost_withswitching',
    'static_highcost_noswitching'
]

color = [
    'grey',
    'black',
    'grey',
    'black',
    'grey',
    'black',
]

linestyle = [
    '-',
    '-',
    ':',
    ':',
    '--',
    '--',
]

for idx, group in enumerate(groups):
    analysis.load_dataset(filename='../../python_plotting/rw_output_combo.hdf5', group=group)
    df = analysis.get_summary_dataframe()
    df.loc[:, ['psurv_total']].plot(color=color[idx], linestyle=linestyle[idx], ax=ax1)


# dynamic with switching (including shaded areas)
analysis.load_dataset(filename='../../python_plotting/rw_output_combo.hdf5', group='withswitching')
df = analysis.get_summary_dataframe()
# df.loc[:, ['psurv_type1', 'psurv_type2', 'psurv_total','radius']].plot(x='radius', color=['red', 'blue', 'black'], ax=ax1)

bottom_line = np.ones(len(df.loc[:, 'radius']))*ax1.get_ylim()[0]
ax1.fill_between(df.loc[:,'radius'], bottom_line, df.loc[:, 'psurv_type2'], color='blue', alpha=0.25)
ax1.fill_between(df.loc[:,'radius'], df.loc[:, 'psurv_type2'], df.loc[:, 'psurv_total'], color='red', alpha=0.25)

ax1.set_xlabel('radius [um]')
ax1.set_ylabel('survival probability')
ax1.set_yscale('log')
ax1.legend(groups)

fig2, ax2 = plt.subplots(1,1)

for idx in range(len(groups)//2):
    analysis.load_dataset(filename='../../python_plotting/rw_output_combo.hdf5', group=groups[idx * 2])
    df = analysis.get_summary_dataframe()
    P_with = df.loc[:, ['psurv_total']]

    analysis.load_dataset(filename='../../python_plotting/rw_output_combo.hdf5', group=groups[idx * 2 + 1])
    df = analysis.get_summary_dataframe()
    P_no = df.loc[:, ['psurv_total']]

    efficacy = 1-P_no/P_with
    ax2.plot(df.loc[:,'radius'], efficacy, color='black', linestyle=linestyle[(idx * 2)])

ax2.set_xlabel('radius [um]')
ax2.set_ylabel('efficacy (1-P_no/P_with)')
ax2.set_yscale('linear')
ax2.legend(['dynamic', 'fixed', 'fixed highcost'])

plt.show()
