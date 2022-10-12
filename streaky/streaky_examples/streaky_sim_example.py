from streaky import simulation as sim

# set experimental conditions
experiment = sim.Experiment(fitness_cost=1e-3,
                        selection_type='static',
                        mutation_rate=0,
                        diffusion_coefficient=0.08,
                        initial_radius=1827,
                        initial_width=10,
                        sector_number=1000,
                        num_steps=7000)

# run the experiment
experiment.run()

# save as hdf5
experiment.save_as_hdf(file='../../python_plotting/rw_output_combo.hdf5', group='static_highcost_noswitching')


# set experimental conditions
experiment = sim.Experiment(fitness_cost=1e-3,
                        selection_type='static',
                        mutation_rate=1e-4,
                        diffusion_coefficient=0.08,
                        initial_radius=1827,
                        initial_width=10,
                        sector_number=1000,
                        num_steps=7000)

# run the experiment
experiment.run()

# save as hdf5
experiment.save_as_hdf(file='../../python_plotting/rw_output_combo.hdf5', group='static_highcost_withswitching')

