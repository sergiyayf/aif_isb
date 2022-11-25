import numpy as np

import matplotlib as mpl
mpl.use('TkAgg')
from matplotlib import pyplot as plt
plt.rcParams.update({'font.size': 6,
                    'font.weight': 'normal',
                    'font.family': 'sans-serif'})
mpl.rcParams['pdf.fonttype'] = 42 #to make text editable in pdf output
mpl.rcParams['font.sans-serif'] = ['Arial'] #to make it Arial

mu = [5.65e-6, 1.53e-4,2.65e-4,4.48e-4];
error_mu = [3.46e-6,1.33e-5, 2.49e-5, 3.37e-5];

BED = [0, 2,4,6]; 

cm = 1/2.54
fig, ax = plt.subplots(figsize=(125/72,125/72),constrained_layout=True)

plt.errorbar(BED, mu, error_mu, ls='--', color = 'k', marker='o',ms = 4, alpha = 1, capsize= 2)
plt.ylim([-1e-4,6e-4])
plt.xlim([-1,7]) 
plt.xticks([0,2,4,6])

plt.yticks([0,1e-4,2e-4,3e-4,4e-4,5e-4],[0,1,2,3,4,5],rotation=90)

#plt.tight_layout()

#plt.title('Switching rates')
#plt.xlabel('BED, nM')
#plt.ylabel(r'$\mu $ $\times10^{-4}$, [$s^{-1}$] ' )

plt.savefig('Switching_rates.pdf',transparent=True)
plt.show()
