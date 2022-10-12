from chist.load.pyMCDS import pyMCDS
import os
import pathlib
from chist.features.pre_processing import Population

def load_data(direct):
    """
    Load data to mcds pandas dataframe using pymcds code written by PhysiCell developers
    """
    # define the path
    directory = pathlib.Path(direct)

    # define the pattern
    pattern = "output*.xml"

    # list files with pattern in the directory
    files = []
    for output in directory.glob(pattern):
        a = os.path.basename(output)
        files.append(a)

    # make sure file list is sorted
    files.sort()

    # load data
    mcdss = []
    for eachfile in files[::10]:
        mc = pyMCDS(eachfile, directory)
        mcdss.append(mc)

    return mcdss

def mat_to_hdf(directory_path):
    h5File = directory_path + '\\all_data.h5'  # "D:\Serhii\Projects\EvoChan\Simulations\sim_results_garching\\20210401_rad_tests\\01_04_rad_test_500\output\\all_data.h5";
    data = load_data(directory_path)

    # get number of time steps
    num_steps = len(data)

    for time_index in range(num_steps):
        colony = data[time_index]
        population = Population(colony)
        growth_layer = population.get_cells_in_growth_layer()
        lineage = population.reconstruct_lineage()
        growth_layer.to_hdf(h5File, 'data/growth_layer/cell' + str(time_index))
        lineage.to_hdf(h5File, 'data/tracked/cell' + str(time_index))
def main():
    mat_to_hdf(r'C:\Users\saif\Desktop\Serhii\Projects\code\PC_sims\chist\tests\test_data\output')
if __name__ == '__main__':
    main()