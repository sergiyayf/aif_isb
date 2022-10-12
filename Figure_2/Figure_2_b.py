import numpy as np
import matplotlib as mpl
mpl.use('TkAgg')
from matplotlib import pyplot as plt
import pandas as pd
import os

def plot_histories(ax,ax2):
    # Read width matrix
    file = open(os.path.join("..","data","WidthMatrix.txt"))
    numpy_array = np.loadtxt(file, delimiter=",")
    widthMatrix = numpy_array.T

    # Read color matrix
    df = pd.read_csv(os.path.join("..","data","ColorMatrix.txt"), header = None)
    array = df.to_numpy()
    colorMatrix = array.T
    # sort for the number of zeros
    colorMatrix = colorMatrix[(widthMatrix == 0).sum(axis=1).argsort()]
    widthMatrix = 0.001*widthMatrix[(widthMatrix == 0).sum(axis=1).argsort()]

    # get slices that survived
    colors_slice = colorMatrix[0:16]
    width_slice = widthMatrix[0:16]

    # sort for width
    colors_slice[::-1] = colors_slice[width_slice[:,8].argsort()]
    width_slice[::-1] = width_slice[width_slice[:,8].argsort()]

    custom_blue =(82/255,175/255,230/255)
    custom_red =(190/255,28/255,45/255)

    for i in range(len(widthMatrix)):
        for j in range(len(widthMatrix[i])):
            if (widthMatrix[i][j] == 0 and widthMatrix[i][j-1] == 0) or np.isnan(widthMatrix[i][j-1]):
                widthMatrix[i][j] = np.nan

    for i in range(len(colorMatrix)):
        for j in range(len(colorMatrix[i])):

            if np.isnan(widthMatrix[i][j]) and widthMatrix[i][j-1] == 0:
                colorMatrix[i][j-1] = colorMatrix[i][j-2]
            elif widthMatrix[i][j] == 0 and j == 8:
                colorMatrix[i][j-1] = colorMatrix[i][j-2]

    x_coord = np.arange(1,10,1)
    labels = np.array(range(0,len(widthMatrix),1))

    for n in range(0,len(widthMatrix),1):

        for j in range(8):

            ax.fill_between(x_coord[j:j+2],1*labels[n]+1+widthMatrix[n][j:j+2],1*labels[n]+1-widthMatrix[n][j:j+2],where = [colorMatrix[n][j]=='r',True],lw=0, color = custom_red, alpha = 1.)
            ax.fill_between(x_coord[j:j+2],1*labels[n]+1+widthMatrix[n][j:j+2],1*labels[n]+1-widthMatrix[n][j:j+2],where = [colorMatrix[n][j]=='m',True],lw=0, color = custom_blue, alpha = 1.)
            ax.fill_between(x_coord[j:j+2],1*labels[n]+1+widthMatrix[n][j:j+2],1*labels[n]+1-widthMatrix[n][j:j+2],where = [colorMatrix[n][j]=='b',True],lw=0, color = custom_blue, alpha = 1.)

            ax2.fill_between(x_coord[j:j+2],1*labels[n]+1+widthMatrix[n][j:j+2],1*labels[n]+1-widthMatrix[n][j:j+2],where = [colorMatrix[n][j]=='r',True],lw=0, color = custom_red, alpha = 1.)
            ax2.fill_between(x_coord[j:j+2],1*labels[n]+1+widthMatrix[n][j:j+2],1*labels[n]+1-widthMatrix[n][j:j+2],where = [colorMatrix[n][j]=='m',True],lw=0, color = custom_blue, alpha = 1.)
            ax2.fill_between(x_coord[j:j+2],1*labels[n]+1+widthMatrix[n][j:j+2],1*labels[n]+1-widthMatrix[n][j:j+2],where = [colorMatrix[n][j]=='b',True],lw=0, color = custom_blue, alpha = 1.)

def setup_figure(save_figure=False):
    plt.rcParams.update({'font.size': 6,
                         'font.weight': 'normal',
                         'font.family': 'sans-serif'})
    mpl.rcParams['pdf.fonttype'] = 42  # to make text editable in pdf output
    mpl.rcParams['font.sans-serif'] = ['Arial']  # to make it Arial
    cm = 1 / 2.54
    fig, (ax, ax2) = plt.subplots(2, 1, sharex=False, figsize=(105.5 / 72, 170 / 72),
    gridspec_kw={'height_ratios': [1, 14]}, constrained_layout=True)
    plot_histories(ax,ax2)
    ax.set_yticks([])
    ax2.set_yticks([])
    ax.set_xticks([])
    ax2.set_xticks(range(1, 10))
    ax.set_ylim(98, 104)  # early dead
    ax2.set_ylim(0, 70)  # most of the data
    ax.spines['bottom'].set_visible(False)
    ax2.spines['top'].set_visible(False)
    ax2.xaxis.tick_bottom()
    d = .015  # how big to make the diagonal lines in axes coordinates
    kwargs = dict(transform=ax.transAxes, color='k', clip_on=False)
    ax.plot((-d, +d), (-d, +d), **kwargs)  # top-left diagonal
    ax.plot((1 - d, 1 + d), (-d, +d), **kwargs)  # top-right diagonal
    kwargs.update(transform=ax2.transAxes)  # switch to the bottom axes
    ax2.plot((-d, +d), (1 - d / 14, 1 + d / 14), **kwargs)  # bottom-left diagonal
    ax2.plot((1 - d, 1 + d), (1 - d / 14, 1 + d / 14), **kwargs)  # bottom-right diagonal
    # fig.tight_layout()
    fig.set_constrained_layout_pads(w_pad=2 / 72, h_pad=10 / 72, hspace=0, wspace=0)
    if save_figure:
        fig.savefig("histories.pdf",transparent = True)

if __name__ == '__main__':

    setup_figure(save_figure=False)
    plt.show()
