# Evolutionary rescue of resistant mutants is governed by a balance between radial expansion and selection in compact populations

This repository contains code to analyze experimental and simulation data of evolutionary rescue
in dense populations. 

## System requirements

No non-standard hardware is required to run this code. 

Analysis software was tested on Windows 10 Version 10.0.19043. 

## Installation guide 

To run the software to reproduce the Figures install Python (with required packages) and R and run respective script. See `Dependencies` for software and packages versions.

## Dependencies 

### Software 
Python = 3.8

R = 4.2.1 

MatLab = R2020a

PhysiCell = V1.8.0 [source code](https://github.com/MathCancer/PhysiCell)

Ilastik = 1.3.3

### Python packages

numpy = 1.21.5

matplotlib = 3.5.1

pandas = 1.4.1 

seaborn = 0.11.2

scipy = 1.7.3 

h5py = 2.10

rpy2 = 3.5.4 

## Figures 
Figure in this manuscript were produced using the corresponding python scripts Figure_X/Figure_x_y.py

### Figure 1
Synthetic mutation assay to study evolutionary rescue dynamics in expanding microbial colonies.

![Figure 1](/paper_figures/Figure_synmut.png)

### Figure 2
Slower-growing resistant mutants are stabilized at a quasi-constant equilibrium width, reshaping
the acquisition and effect of compensatory mutations. The Source Data for this Figure is `data/experimental_data.h5`.

![Figure 2](/paper_figures/Figure_experiment.png)

### Figure 3
The impact of compensatory mutations on
treatment failure is delayed. The Source Data for this Figure is `data/Fig3_source_data.xlsx`.

![Figure 3](/paper_figures/Figure_treatment.png)

### Figure 4
The opposing effects of peripheral inflation
and width-dependent selection create a quasistable
equilibrium width. 

![Figure 4](/paper_figures/Figure_ISB.png)

### Figure 5
Including inflation-selection balance in a random walk model of range expansion reproduces experimental
observations.
Simulations for this figure can be produced by running the script `streaky/streaky_examples/streaky_sim_example.py` and analyzed with `streky/streaky_examples/streaky_analysis_example.py`.
The Source Data for this Figure can be provided upon request due to its large size.

![Figure 5](/paper_figures/Figure_RW.png)

### Figure 6
The interplay of inflation-selection balance and evolutionary rescue inherently emerges in an agentbased
in silico tumor model.
Simulations for this Figure can be produced using [PhysiCell](https://github.com/MathCancer/PhysiCell)
V.1.8.0 with config and custom modules from `PhysiCell_config_and_custom_modules`. Code can be analyzed by first running `Figure_6/chist/load/matTohdf.py` to transform .mat PhysiCell files to hdf5 format and preserach for cells at the boundaries. Then similar to the figure analysis can be reproduced with the corresponding Figure_6_x.py scripts. 
The Source Date for this Figure is `Figure_6/chist/data/ER_data_collection.h5`.

![Figure 6](/paper_figures/Figure_ABS.png)


## Data
Random walk model data (streaky) files are too large for the repository due to very large number of clones (same file also contains all of the controls presented in the SI), and can be provided by the authors upon request.

## Instruction to use 

### Experimental data 

Segment microscopy images with Ilastik, using different labels for 3 different fluorescent signals, colony edge and the background. For label order see `matlab_data_processing/Single_colony_analysis.m` file and either adapt the labeling or script accordingly. Run `mattoh5.m` script to transform data to hdf5 format for futher analysis. Run the scripts in `Figure_2` directory.

### Streaky simulations 

To run sample simulation use `streaky/streaky_examples/streaky_sim_example.py`. To analyse the data either use `streaky_analysis_example` or scripts in the `Figure_5` directory. 

### Agent-based simulations

Agent-based simulations can be produced using [PhysiCell](https://github.com/MathCancer/PhysiCell)
V.1.8.0 with config and custom modules from `PhysiCell_config_and_custom_modules`. Visit [PhysiCell](https://github.com/MathCancer/PhysiCell) for installation and run instructions. Code can be analyzed by first running `Figure_6/chist/load/matTohdf.py` to transform .mat PhysiCell files to hdf5 format and preserach for cells at the boundaries. Then similar to the figure analysis can be reproduced with the corresponding Figure_6_x.py scripts. 

## Reference
Preprint: 
https://www.biorxiv.org/content/10.1101/2022.05.27.493727v1.abstract


