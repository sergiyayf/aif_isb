import matplotlib as mpl

import numpy as np
import h5py
from os import path
import pandas as pd
from .general import EffectiveFitness, population_to_array

class Sector:
    """represents an individual sector and the functions needed to propagate itself (including growth, mutation, extinction)"""

    def __init__(self, ini_width, ini_radius, params):
        self.phi = [[-ini_width/2/ini_radius, ini_width/2/ini_radius, np.nan, np.nan]]
        self.radius = [ini_radius]
        self.params = params

    def mutate(self):
        """spawn a mutant sector in the center of the unmutated sector at the given mutation rate"""

        # set decision threshold to mutate (or not)
        threshold = (self.phi[-1][1] - self.phi[-1][0]) * self.radius[-1] / self.params['cell_size'] * self.params['mutation_rate']
        if np.random.uniform(0, 1) < threshold:
            center = self.phi[-1][0] + (self.phi[-1][1] - self.phi[-1][0]) / 2
            self.phi[-1][2] = center - self.params['cell_size'] / 2 / self.radius[-1]
            self.phi[-1][3] = center + self.params['cell_size'] / 2 / self.radius[-1]

    def get_seff(self):
        """returns the effective selection coefficient, depending on the type of selection speciefied.
         See streaky/general.py for form of s_eff"""

        widths = (self.phi[-1][1] - self.phi[-1][0]) * self.radius[-1]  # current sector widths

        if self.params['selection_type'] == 'dynamic':  # width dependent selection scenario
            s_eff = getattr(EffectiveFitness, self.params['seff_type'])(self,
                                                                        self.params['fitness_cost'],
                                                                        widths,
                                                                        self.params['seff_critical_width'],
                                                                        self.params['seff_deadzone'])
        elif self.params['selection_type'] == 'neutral':    # no selection scenario
            s_eff = 0
        else:   # constant selection scenario
            s_eff = self.params['fitness_cost']

        return s_eff

    def update_boundaries(self,s_eff):
        """update sector boundary (angle) conditions according to the given diffusion coefficient"""
        sigma = 2 * np.sqrt(self.params['diffusion_coefficient'])   # random genetic drift
        selection_bias = np.sqrt(abs(s_eff) * (2 + abs(s_eff))) * np.sign(s_eff)    # bias due to selection
        neutral_bias = 0 #np.sqrt(abs(s0_neutral) * (2 + abs(s0_neutral))) * np.sign(s0_neutral)

        # update angles
        new_phi = [self.phi[-1][0] + np.random.normal(selection_bias, sigma) / self.radius[-1],
                   self.phi[-1][1] + np.random.normal(-selection_bias, sigma) / self.radius[-1],
                   self.phi[-1][2] + np.random.normal(neutral_bias, sigma) / self.radius[-1],
                   self.phi[-1][3] + np.random.normal(-neutral_bias, sigma) / self.radius[-1]]

        # check for boundary collisions
        if new_phi[0] >= new_phi[1]:
            new_phi[0], new_phi[1] = np.nan, np.nan
        if new_phi[2] >= new_phi[3]:
            new_phi[2], new_phi[3] = np.nan, np.nan
        if new_phi[0] >= new_phi[2]:
            new_phi[0] = new_phi[3]
        if new_phi[3] >= new_phi[1]:
            new_phi[1] = new_phi[2]

        return new_phi


    def step_forward(self):
        """progress the simulation on step forward (i.e. grow radially).
        This also triggers all subdynamics, such as mutation, selection and boundary updates"""
        # mutation
        if np.isnan(self.phi[-1][2]):
            self.mutate()

        # selection
        s_eff = self.get_seff()

        # update boundary positions
        new_phi = self.update_boundaries(s_eff)

        self.phi.append(new_phi)

        # expand
        self.radius.append(self.radius[-1] + self.params['delta_r'])

class Experiment:
    """This class contains all the sector objects, simulation functions and environmental conditions"""

    def __init__(self,
                 fitness_cost=0,
                 selection_type='fixed',
                 seff_type='inverse_logistic',
                 seff_critical_width=558,   #from SI in Kayser et al. NatEcoEvo 2019
                 seff_deadzone=32,
                 mutation_rate=1e-4,
                 diffusion_coefficient=0.08,
                 cell_size=5,
                 delta_r=1,
                 initial_radius=1827,
                 initial_width=5,
                 initial_width_distribution = 'non_random',
                 mean_initial = 22,
                 std_initial = 12,
                 sector_number=10,
                 num_steps=7000):

        # environment parameters
        self.attrs = {
            'fitness_cost': fitness_cost,                       # relative fitness cost of unmutated type
            'selection_type': selection_type,                   # type of selection ('fixed', 'dynamic' or 'neutral')
            'mutation_rate': mutation_rate,                     # mutation rate in mutations per cell per simulated step
            'seff_type': seff_type,                             # the function name within the EffectiveFitness class
            'seff_critical_width': seff_critical_width,         # critical width for s_eff
            'seff_deadzone': seff_deadzone,                     # deadzone at which, if applicable, s_eff = 0
            'diffusion_coefficient': diffusion_coefficient,     # diffusion coefficient of boundary random walk
            'cell_size': cell_size,                             # cell size in um
            'delta_r': delta_r,                                 # radius increase per simulation step in um
            'initial_radius': initial_radius,                   # initial radius of colony
            'initial_width': initial_width,                     # initial sector width in um
            'initial_width_distribution' : initial_width_distribution, # initial width distribtuion
            'mean_initial': mean_initial,                       # mean initial width of clones for random distr
            'std_initial': std_initial,                         # variance of initial clone distribution
            'sector_number': sector_number,                     # number of simulated sectors
            'steps': num_steps                                  # number of simulated growth steps
        }

        # simulation parameters
        self.steps = num_steps                      # number of steps in simulation

    def initialize_population(self):
        """initializes the entire population of independent sectors"""
        # initialize sectors
        if self.attrs['initial_width_distribution'] == 'random':
            self.population = []
            for id in range(self.attrs['sector_number']):
                self.population.append(Sector(np.abs(np.random.normal(loc=self.attrs['mean_initial'],scale=self.attrs['std_initial'])), self.attrs['initial_radius'], self.attrs))
                self.population[id].id = id
        else:
            self.population = []
            for id in range(self.attrs['sector_number']):
                self.population.append(Sector(self.attrs['initial_width'], self.attrs['initial_radius'], self.attrs))
                self.population[id].id = id

    def run(self):
        """executes the functions within Sector to progress expand the population"""
        self.initialize_population()
        for _ in range(self.attrs['steps']):
            for sector in self.population:
                sector.step_forward()

    def save_as_hdf(self, file='rw_output.hdf5', group='experiment_group'):
        """saves the simulation results as hdf5 file. The group should be the name of a given run.
        Sector data is stored in one large array within that group, along with simulation parameters as attributes"""
        with h5py.File(file, "a") as f:
            phi_array = population_to_array(self.population)
            dset = f.create_dataset(group + f"/phi_array", data=phi_array)
            for key in self.attrs.keys():
                dset.attrs[key] = self.attrs[key]
        print(f'Saved data in {file}/{group}/phi_array.')

    def save_xml(self, file='rw_output.xml', sim_name='experiment_group'):
        """saves simulation parameters as xml file for future reference.
        Note, currently pandas xml implementation does not allow for appending a xml file.
        Therefore loading and re-saving of previous parameter sets is necessary."""

        current_attr_df = pd.DataFrame([self.attrs])
        current_attr_df['sim_name'] = sim_name

        if path.exists(file):
            previous_attr_df = pd.read_xml(file)
            previous_attr_df.drop(['index'], axis=1, inplace=True)
            new_attr_df = previous_attr_df.append(current_attr_df)
            new_attr_df.reset_index(inplace=True, drop=True)
        else:
            new_attr_df = current_attr_df

        new_attr_df.to_xml(file)
        print(f'Saved attributes in {file}.')
        


def main():
    """Simple example to test functionality. Outputs the file 'rw_output.hd5f' and 'rw_output.xml' into the current
     working directory"""

    # set experimental conditions different from standard values
    experiment = Experiment(fitness_cost=0.001,
                    selection_type='dynamic',
                    seff_type='sigmoid',
                    mutation_rate=1e-4,
                    diffusion_coefficient=0.08,
                    initial_radius=1827,
                    sector_number=10,
                    num_steps=7000)

    # run the experiment
    experiment.run()

    # save as hdf5 and attributes as xml
    experiment.save_as_hdf()
    experiment.save_xml()

    return experiment

if __name__ == '__main__':
    experiment = main()


