import matplotlib as mpl
mpl.use('TkAgg')
mpl.rcParams['pdf.fonttype'] = 42 #to make text editable in pdf output
mpl.rcParams['font.sans-serif'] = ['Arial'] #to make it Arial
import matplotlib.pyplot as plt
from scipy import stats as sts
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

def Gaussian_CDF(x,mu,sigma):
    return sts.norm.cdf(x, loc = mu, scale = sigma)

day = 6
experiment_stats = load_object(f'exp_stats_day{day}.pickle')
print(experiment_stats)
tot_p = experiment_stats['P_fail_s1']+experiment_stats['P_fail_s2']
err_p = np.sqrt( experiment_stats['err_P_fail_s1']**2+experiment_stats['err_P_fail_s2']**2)

p_value = Gaussian_CDF(tot_p['0nM'],tot_p['6nM'],err_p['6nM'])
print('p_value',p_value)


print(experiment_stats['P_fail_s2']/tot_p)