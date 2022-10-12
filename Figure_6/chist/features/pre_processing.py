from chist.auxiliary.get_perifery import front_cells
import pandas as pd
class Population:

    def __init__(self, cells):
        self.cells = cells.get_cell_df()

    def get_cells_in_growth_layer(self):
        """
        Checks for cells that are not stack in G0 phase for long time (growing once)

        Returns:
            pandas dataframe of cells in growth layer
        """

        current_population = self.cells
        cells_in_growth_layer = current_population[~( (current_population['current_phase']==4) &
                                                      (current_population['elapsed_time_in_phase']>400))]

        return cells_in_growth_layer

    def get_periphery(self):
        """
        This method returns cell periphery using convex hull function defined in auxiliary
        """
        positions, types = front_cells(self.get_cells_in_growth_layer())
        current_population = self.cells
        cells_at_front = pd.DataFrame()
        for front_pos in positions:
            cells_at_front = pd.concat([cells_at_front,current_population[(current_population['position_x']==front_pos[0])] ])

        return cells_at_front

    def reconstruct_lineage(self, exclude_wild_type = True):
        """
        This method reconstructs lineage of the cells at the front
        """
        cells_at_front = self.get_periphery()
        current_population = self.cells
        ancestors = []
        if exclude_wild_type == True:
            cells_at_front = cells_at_front[cells_at_front['cell_type'] != 0]
            current_population = current_population[current_population['cell_type'] != 0]

        for idx in cells_at_front.index:

            cell = current_population[current_population['ID'] == cells_at_front.loc[idx]['ID']]
            mom_of_this_cell = current_population[current_population['ID'] == current_population['parent_ID'].values[0]];
            cell2 = cell

            while not current_population[current_population['ID'] == cell2['parent_ID'].values[0]].empty:
                mom_of_this_cell = current_population[current_population['ID'] == cell2['parent_ID'].values[0]];
                cell2 = mom_of_this_cell;

            if mom_of_this_cell.empty:
                mom_of_this_cell = cell;
            oldest_ancestor = mom_of_this_cell['ID'].values[0]
            ancestors.append(oldest_ancestor)

        cells_at_front['ancestor'] = ancestors
        #print(cells_at_front['ancestor'])
        return cells_at_front