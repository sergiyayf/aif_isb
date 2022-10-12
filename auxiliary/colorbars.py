import matplotlib as mpl
mpl.use('TkAgg')
import matplotlib.pyplot as plt
from plot.ColonyPlot import *

filename = 'h5_data_cleaned.h5'
colplt = Colony(filename)
cm = 1 / 2.54
fig, ax = plt.subplots(figsize=(6 * cm, 2 * cm))
cmap = mpl.colors.ListedColormap([plt.get_cmap("Reds")(x) for x in np.linspace(0, 1, 9)], 'my_map')
rad = colplt.get_radii(CHX=50, BED=0, treatment=10)
cb1 = ax.figure.colorbar(mpl.cm.ScalarMappable(cmap=cmap), orientation='horizontal',
                         ticks=[x + 0.05 for x in np.linspace(0, 1, 10)])
cb1.ax.set_xticklabels([])
#fig.savefig(r'figures\cbar_red.pdf', transparent=True)
fig, ax = plt.subplots(figsize=(6 * cm, 2 * cm))
cmap = mpl.colors.ListedColormap([plt.get_cmap("Blues")(x) for x in np.linspace(0, 1, 9)], 'my_map')
rad = colplt.get_radii(CHX=50, BED=0, treatment=10)
cb1 = ax.figure.colorbar(mpl.cm.ScalarMappable(cmap=cmap), orientation='horizontal',
                         ticks=[x + 0.05 for x in np.linspace(0, 1, 10)])
cb1.ax.set_xticklabels([])
#fig.savefig(r'figures\cbar_blue.pdf', transparent=True)
# fig.savefig(r'figures\Width_distribution_b.pdf', transparent = True)