import numpy as np
import matplotlib as mpl
mpl.use('TkAgg')
from matplotlib import pyplot as plt 

plt.rcParams.update({'font.size': 6,
                    'font.weight': 'normal',
                    'font.family': 'sans-serif'})
mpl.rcParams['pdf.fonttype'] = 42 #to make text editable in pdf output
mpl.rcParams['font.sans-serif'] = ['Arial'] #to make it Arial


delta_s = [0.000995, 0.0126, 0.023];
error_delta_s = [0.00085, 0.0064, 0.0035]; 

CHX = [0, 50 ,100]; 


cm = 1/2.54
fig, ax = plt.subplots(figsize=(125/72,125/72),constrained_layout=True)

plt.errorbar(CHX, delta_s, error_delta_s, ls='--', color = 'k',  marker='o',ms = 4, alpha = 1, capsize= 2)
plt.ylim([0,0.06])
plt.xlim([-20,120]) 
plt.xticks([0,50,100])

plt.yticks([0,0.02,0.04],[0,2,4],rotation=90)

#plt.tight_layout()

#plt.title('Fitness difference')
#plt.xlabel('CHX, nM')
#plt.ylabel(r'$\Delta s$, %')

    
plt.savefig('Fitness_diff.pdf',transparent=True)
plt.show()
