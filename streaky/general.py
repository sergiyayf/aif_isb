"""This module contains functions that are used by other modules"""

import numpy as np

class EffectiveFitness:
    """Definitions of effective fitness shapes"""

    def linetension(self, s0, width, width_c, deadzone):
        """line tension inspired, see Kayser et. al. NatEcoEvo 2019 SI"""
        dwdy_inf = 2 * np.sqrt(s0 ** 2 + 2 * s0)
        dw_dy = dwdy_inf * np.tanh((width) / (2 * width_c))  # factor two because we have two boundaries
        s_eff = np.sqrt(1 + (dw_dy / 2) ** 2) - 1
        return s_eff

    def sigmoid(self, s0, width, width_c, deadzone):
        """Shifted sigmoid"""
        s_eff = s0 * (2 / (1 + np.exp(-(width - deadzone) / width_c)) - 1)  # sigmoid
        s_eff = np.where(s_eff<0, 0, s_eff)  # create 0 plateau for very small clones if necessary
        return s_eff

    def hill(self, s0, width, width_c, deadzone):
        """Hill equation. Hill-coefficient is currently hard-coded"""
        hill_coefficient = 8
        s_eff = s0 / (1 + (width_c / width)**hill_coefficient)  # hill equation
        return s_eff

    def inverse_logistic(self, s0, width, width_c, deadzone):
        """inverse logistic form."""
        s_eff = s0 * 2 / (1 + np.exp(width_c / width))  # inverse logistic
        return s_eff

    def exponential(self, s0, width, width_c, deadzone):
        """exponential approach to s0. Note, this function is always convex (negative second derivative)"""
        s_eff = s0 * (1 - np.exp(-width / width_c))  # 1-exponential
        return s_eff

    def constant(self, s0, width, width_c, deadzone):
        """constant fitness. This is equivalent to using the static scenario in the simulation"""
        s_eff = s0*np.ones(np.shape(width)) #constant fitness
        return s_eff


def population_to_array(population):
    """converts population object to numpy array"""
    phi_array = np.empty((len(population[0].phi), 4, len(population)))
    for sector in population:
        phi_array[:, :, sector.id] = np.array(sector.phi)

    return phi_array
