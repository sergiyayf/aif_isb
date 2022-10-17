/*
###############################################################################
# If you use PhysiCell in your project, please cite PhysiCell and the version #
# number, such as below:                                                      #
#                                                                             #
# We implemented and solved the model using PhysiCell (Version x.y.z) [1].    #
#                                                                             #
# [1] A Ghaffarizadeh, R Heiland, SH Friedman, SM Mumenthaler, and P Macklin, #
#     PhysiCell: an Open Source Physics-Based Cell Simulator for Multicellu-  #
#     lar Systems, PLoS Comput. Biol. 14(2): e1005991, 2018                   #
#     DOI: 10.1371/journal.pcbi.1005991                                       #
#                                                                             #
# See VERSION.txt or call get_PhysiCell_version() to get the current version  #
#     x.y.z. Call display_citations() to get detailed information on all cite-#
#     able software used in your PhysiCell application.                       #
#                                                                             #
# Because PhysiCell extensively uses BioFVM, we suggest you also cite BioFVM  #
#     as below:                                                               #
#                                                                             #
# We implemented and solved the model using PhysiCell (Version x.y.z) [1],    #
# with BioFVM [2] to solve the transport equations.                           #
#                                                                             #
# [1] A Ghaffarizadeh, R Heiland, SH Friedman, SM Mumenthaler, and P Macklin, #
#     PhysiCell: an Open Source Physics-Based Cell Simulator for Multicellu-  #
#     lar Systems, PLoS Comput. Biol. 14(2): e1005991, 2018                   #
#     DOI: 10.1371/journal.pcbi.1005991                                       #
#                                                                             #
# [2] A Ghaffarizadeh, SH Friedman, and P Macklin, BioFVM: an efficient para- #
#     llelized diffusive transport solver for 3-D biological simulations,     #
#     Bioinformatics 32(8): 1256-8, 2016. DOI: 10.1093/bioinformatics/btv730  #
#                                                                             #
###############################################################################
#                                                                             #
# BSD 3-Clause License (see https://opensource.org/licenses/BSD-3-Clause)     #
#                                                                             #
# Copyright (c) 2015-2021, Paul Macklin and the PhysiCell Project             #
# All rights reserved.                                                        #
#                                                                             #
# Redistribution and use in source and binary forms, with or without          #
# modification, are permitted provided that the following conditions are met: #
#                                                                             #
# 1. Redistributions of source code must retain the above copyright notice,   #
# this list of conditions and the following disclaimer.                       #
#                                                                             #
# 2. Redistributions in binary form must reproduce the above copyright        #
# notice, this list of conditions and the following disclaimer in the         #
# documentation and/or other materials provided with the distribution.        #
#                                                                             #
# 3. Neither the name of the copyright holder nor the names of its            #
# contributors may be used to endorse or promote products derived from this   #
# software without specific prior written permission.                         #
#                                                                             #
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" #
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE   #
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  #
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE   #
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR         #
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF        #
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS    #
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     #
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)     #
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE  #
# POSSIBILITY OF SUCH DAMAGE.                                                 #
#                                                                             #
###############################################################################
*/

#include "./custom.h"

void create_cell_types( void )
{
	// use the same random seed so that future experiments have the 
	// same initial histogram of oncoprotein, even if threading means 
	// that future division and other events are still not identical 
	// for all runs 
	
	SeedRandom( parameters.ints("random_seed") ); // or specify a seed here 
	
	/* 
	   Put any modifications to default cell definition here if you 
	   want to have "inherited" by other cell types. 
	   
	   This is a good place to set default functions. 
	*/ 
	
	initialize_default_cell_definition(); 	
	
	cell_defaults.functions.volume_update_function = standard_volume_update_function;
	cell_defaults.functions.update_velocity = standard_update_cell_velocity;

	cell_defaults.functions.update_migration_bias = NULL; 
	cell_defaults.functions.update_phenotype = update_cell_and_death_parameters_O2_based; 
	
	cell_defaults.functions.contact_function = contact_function; 	
	
	cell_defaults.functions.add_cell_basement_membrane_interactions = NULL; 
	cell_defaults.functions.calculate_distance_to_membrane = NULL; 
	
	cell_defaults.functions.cycle_model = flow_cytometry_separated_cycle_model; 
	
    cell_defaults.parameters.o2_proliferation_saturation = 14;
    cell_defaults.parameters.o2_proliferation_threshold = 10;
    cell_defaults.parameters.o2_necrosis_threshold = 0;
    cell_defaults.parameters.o2_necrosis_max = 0; 
    
    cell_defaults.functions.custom_cell_rule = NULL;// remove_core_rule;//switching_rule; //NULL; 
	/*
	   This parses the cell definitions in the XML config file. 
	*/
	
	initialize_cell_definitions_from_pugixml(); 
	
	/* 
	   Put any modifications to individual cell definitions here. 
	   
	   This is a good place to set custom functions. 
	*/ 

	// set the rate terms in the default phenotype 

	Cell_Definition* pResistant = find_cell_definition("resistant deleterious cell"); 
	pResistant->functions.custom_cell_rule = switching_rule;
	//pResistant->parameters.o2_proliferation_saturation = 40;
	//pResistant->parameters.o2_proliferation_threshold = 40; 
	//Cell_Definition* pCD = find_cell_definition( "motile tumor cell" ); 
	
	// Set cell-cell adhesion to 5% of other cells 
	//pCD->phenotype.mechanics.cell_cell_adhesion_strength *= parameters.doubles( "motile_cell_relative_adhesion" ); 
	
	// Set proliferation to 10% of other cells. 
	// Alter the transition rate from G0G1 state to S state
	int G0G1_index = flow_cytometry_separated_cycle_model.find_phase_index( PhysiCell_constants::G0G1_phase );
	int S_index = flow_cytometry_separated_cycle_model.find_phase_index( PhysiCell_constants::S_phase );

	//pCD->phenotype.cycle.data.transition_rate(G0G1_index,S_index) *= 
	//	parameters.doubles( "motile_cell_relative_cycle_entry_rate" ); 
		
	/*
	   This builds the map of cell definitions and summarizes the setup. 
	*/
		
	build_cell_definitions_maps(); 
	display_cell_definitions( std::cout ); 
	
	return; 
}
/*
   Switching rule, to allow cells switching:
     
*/
void switching_rule(Cell* pCell, Phenotype& phenotype, double dt) {
    double rate = 0.000001; // switching rate
    double random_val =0;	
	//SeedRandom();
    random_val = UniformRandom();
	if (random_val<=rate) {
		//Cell_Definition* pWild = find_cell_definition("wild type cell"); 
		pCell->phenotype.cycle.data.transition_rate(1,2) = 0.003333;//0.00208; // 8 hours, this should correspont to wildtype.
		pCell->type = 2;
		//pCell->is_movable = false; 
	}
	return;
}

void remove_core_rule(Cell * pCell, Phenotype& phenotype, double dt) {
	 
	double time_now = PhysiCell_globals.current_time;
       if (time_now > 3600) {
	       double distance_to_origin = dist(pCell->position,{0.0,0.0,0.0}); 
			      if (distance_to_origin < time_now/3600*100) {
			     pCell->flag_for_removal();
			     } else if (distance_to_origin < time_now/3600*150) {
			    pCell->is_movable = false;
			    pCell->type = 2;
			    } 

	}	       


}

/*
    Circular boundary conditions implementation 
*/
void set_circular_boundary_conditions( void ) {
    
    std::vector<double> center_by_indices = {(double)microenvironment.mesh.x_coordinates.size()/2, (double)microenvironment.mesh.y_coordinates.size()/2, (double)microenvironment.mesh.z_coordinates.size()/2}; // find center voxel 
    double system_radius = (double)microenvironment.mesh.x_coordinates.size()/2-5.0;
	// if there are more substrates, resize accordingly 
	std::vector<double> bc_vector( 1 , 38.0 );
	for (unsigned int k = 0; k< microenvironment.mesh.z_coordinates.size(); k++) {
		// loop through y  
		for (unsigned int j = 0; j< microenvironment.mesh.y_coordinates.size() ; j++) {
			// loop through x  
			for (unsigned int I = 0; I< microenvironment.mesh.x_coordinates.size(); I++) {
				std::vector<double> current_index_position = {(double)I, (double)j, (double)k};
				 
				if(dist(current_index_position,center_by_indices)>system_radius) {
						
					microenvironment.add_dirichlet_node( microenvironment.voxel_index(I,j,k), bc_vector);
                    
				}
			}
		}
	}	
                                                                   
	// initialize BioFVM 
	 get_default_microenvironment()->set_substrate_dirichlet_activation(1,true);
	 
}
void setup_microenvironment( void )
{
	// make sure to override and go back to 2D 
	if( default_microenvironment_options.simulate_2D == false )
	{
		std::cout << "Warning: overriding XML config option and setting to 2D!" << std::endl; 
		default_microenvironment_options.simulate_2D = true; 
	}
	
	// set domain parameters 
	
	// put any custom code to set non-homogeneous initial conditions or 
	// extra Dirichlet nodes here. 
	
	// initialize BioFVM 
	initialize_microenvironment(); 	
	set_circular_boundary_conditions();
    
	
	
	return; 
}
void get_2d_circular_colony(int radius, int step){
    Cell* pC;
    static Cell_Definition* pWildTypeDef = find_cell_definition("wild type cell");	
	static Cell_Definition* pRedDef = find_cell_definition("resistant deleterious cell");	
	static Cell_Definition* pBlueDef = find_cell_definition("resistant compensated cell");
    
	double flag=0;
	SeedRandom();
    	
    for (int R = 100; R<=radius; R+=20 ){
	    int k = 0; 
        for (int j=0; j<step; j+=1){
		
                if (j == k && R ==radius){
			k+=step/50;
			pC = create_cell(*pRedDef);
			pC->assign_position(R*sin(2*3.1415*j/step),R*cos(2*3.1415*j/step),0.0);
		}
	       else {
		       pC = create_cell(*pWildTypeDef);
		       pC->assign_position(R*sin(2*3.1415*j/step),R*cos(2*3.1415*j/step),0.0);
			       
		   /*    
	       flag = UniformRandom();	
		if (0.0<=flag && flag<0.75){
            pC = create_cell(*pWildTypeDef);
		    pC->assign_position(R*sin(2*3.1415*j/step), R*cos(2*3.1415*j/step), 0.0);
		  		
		} else if (1.0<=flag && flag<2.0) {
            pC = create_cell(*pStifferDef);
            pC->assign_position(R*sin(2*3.1415*j/step), R*cos(2*3.1415*j/step),0.0);
		}
		else{
            pC = create_cell(*pRedDef); 
            pC->assign_position( R*sin(2*3.1415*j/step), R*cos(2*3.1415*j/step), 0.0 );
        
		}*/
	       }
    }
    } 
    return;
}
void setup_tissue( void )
{
	// create some cells near the origin
	get_2d_circular_colony(600,300);
	
	
	//load_cells_from_pugixml(); 
	
	return; 
}

std::vector<std::string> my_coloring_function( Cell* pCell )
{
	// start with flow cytometry coloring 
	
	std::vector<std::string> output = false_cell_coloring_cytometry(pCell); 
		
	if( pCell->phenotype.death.dead == false && pCell->type == 0 )
	{
		 output[0] = "yellow"; 
		 output[2] = "yellow"; 
	}
	if(pCell->phenotype.death.dead == true && pCell->type ==0) {
	       output[0] = "orange";
               output[2] = "orange";
	}	       

	if(pCell->phenotype.death.dead == false && pCell->type == 1) {
		output[0] = "red";
		output[2] = "red";

	}
	if(pCell->phenotype.death.dead == true && pCell->type == 1) {
		output[0] = "magenta";
		output[2] = "magenta";

	}
    if(pCell->phenotype.death.dead == false && pCell->type == 2){
        output[0]="cyan";
        output[2]="cyan";
	}
	if(pCell->phenotype.death.dead == true && pCell->type ==2) {
		output[0] ="blue";
		output[2] ="blue";
	}
	return output;  
}

void contact_function( Cell* pMe, Phenotype& phenoMe , Cell* pOther, Phenotype& phenoOther , double dt )
{ return; } 
