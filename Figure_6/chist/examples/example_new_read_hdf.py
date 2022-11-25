import h5py
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

import matplotlib

font = {'family': 'normal',
        'weight': 'bold',
        'size': 22}

matplotlib.rc('font', **font)


class visualize:
    """contains all the plotting functions"""

    def __init__(self, x, rows, cols):
        self.rows = rows
        self.cols = cols
        self.x = x

        # plt.close('all')
        plt.figure(figsize=(8, 8))

    def create_plot(self, y, plotIndex, xscale, yscale, xlabel='x', ylabel='y'):
        plt.subplot(self.rows, self.cols, plotIndex)
        for line_index in range(y.shape[1]):
            plt.plot(self.x, y[:, line_index], color_order[line_index], linewidth=2)
        plt.xscale(xscale)
        plt.yscale(yscale)
        plt.ylabel(ylabel)
        plt.xlabel(xlabel)
        plt.legend(types)

    def numbers(self, plotIndex, xscale='linear', yscale='linear'):
        y = num_cells
        self.create_plot(y, plotIndex, xscale, yscale, xlabel='R', ylabel='number of cells')

    def frequencies(self, plotIndex, xscale='linear', yscale='linear'):
        y = num_cells / np.sum(num_cells, 1)[:, None]
        self.create_plot(y, plotIndex, xscale, yscale, xlabel='R', ylabel='frequencies')

    def GrowthLayerPlot(self, plotIndex, xscale='linear', yscale='linear'):
        y = Growth;
        self.create_plot(y, plotIndex, xscale, yscale, xlabel='R', ylabel='growth layer')


###

filename = r'C:\Users\saif\Desktop\Serhii\Projects\code\PC_sims\chist\tests\test_data\output\all_data.h5'
TitleName = 'run3';
f = h5py.File(filename, 'r')

history_read = pd.read_hdf(filename,'data/tracked/cell1')
history = []
for key in f['data/tracked'].keys():
    history_read = pd.read_hdf(filename, 'data/tracked/'+key)
    ancestor =history_read['ancestor']
    history.append(np.array(ancestor));
history_df = pd.DataFrame(history)
print(history_df)