# photoseive utilities
# Copyright 2016 Thomas E. Barchyn
# Contact: Thomas E. Barchyn [tbarchyn@gmail.com]

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# Please familiarize yourself with the license of this tool, available
# in the distribution with the filename: /docs/license.txt
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# run grainsize code on cropped images

import os
import sys
import DGS
import yaml
import datetime
import numpy as np
import pandas as pd

class dgs_analysis:
    def __init__ (self, image_file, scales):
        '''
        constructor takes the file name of the image to evaluate
        image_file = the input image name
        scales = input scales for analysis (a numpy array)
        '''
        self.image_file = image_file
        self.scales = scales
        file_dir = os.path.dirname (image_file)
        self.config_file = os.path.join (file_dir, 'config.txt')
        self.stats_file = os.path.join (file_dir, 'stats.txt')
        self.percentiles_file = os.path.join (file_dir, 'percentiles.txt')
        self.gsd_file = os.path.join (file_dir, 'gsd.txt')
        
        # read the config file
        self.read_config ()
        
        return
    
    def run (self):
        '''
        function to run the DGS grainsize analysis on an image
        '''
        
        # run the analysis if we successfully read the file
        if not self.config_file_error:
            self.dgs_stats = DGS.dgs (self.image_file, self.config ['density'], self.config ['resolution'],
                                      self.config ['dofilter'], self.config ['maxscale'], self.config ['notes'],
                                      self.config ['verbose'], scales = self.scales)
            
            # write the stats files
            self.write_stats ()
            self.write_gsd ()
        
        print ('completed: ' + self.image_file)
        print ('---------------------------------------------------------------')
        return
    
    def read_config (self):
        '''
        method to read the config file to figure out the stats
        the config file is a simple yaml file that gets interpreted into
        a python dict
        '''
        self.config_file_error = False
        
        try:
            with open (self.config_file, 'r') as f:
                self.config = yaml.load (f)
            
        except:
            self.config_file_error = True
            print ('Cannot open config file: ' + self.config_file)

        return
    
    def write_stats (self):
        '''
        method to write the stats as a yaml file
        '''
        self.stats = dict()
        self.stats['skewness'] = float (self.dgs_stats['grain size skewness'])
        self.stats['mean'] = float (self.dgs_stats['mean grain size'])
        self.stats['sorting'] = float (self.dgs_stats['grain size sorting'])
        self.stats['kurtosis'] = float (self.dgs_stats['grain size kurtosis'])
        self.stats['time'] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        
        with open (self.stats_file, 'w') as f:
            yaml.dump (self.stats, f, default_flow_style = False)
            
        return
    
    def write_gsd (self):
        '''
        method to write the grain size distributions as a pandas dataframes
        '''
        
        # stack the arrays into pandas dataframes
        self.percentiles = pd.DataFrame (np.column_stack ([self.dgs_stats['percentiles'], 
                                                   self.dgs_stats['percentile_values']]),
                                                   columns = ('percentiles', 'vals'))
        self.gsd = pd.DataFrame (np.column_stack ([self.dgs_stats['grain size bins'], 
                                                   self.dgs_stats['grain size frequencies']]),
                                                   columns = ('bins', 'freqs'))
                                                    
        # write the csv files to disk
        self.percentiles.to_csv (self.percentiles_file, index = False)                                            
        self.gsd.to_csv (self.gsd_file, index = False)
                                                    
        return
    
