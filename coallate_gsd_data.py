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

# coallate the data

import os
import sys
import glob
import numpy as np
import pandas as pd
import yaml
import copy

# coallate all the data into a pandas dataframe

def coallate_gsd_data (base_dir, output_file):
    '''
    method to coallate all the data into a pandas dataframe
    
    base_dir = the base directory to walk from
    output_file = the output file to place the pandas dataframe into
    '''

    first_row = True
    
    # walk down the dirs, looking for config files and images
    for dir in os.walk (base_dir):
        files = dir[2]

        # look for a config file
        if files.count('config.txt') == 1:
            try:
                # ok, lets go ahead and try to run the coallation
                directory = dir[0]                            # get directory
                os.chdir (directory)                          # get local
                directory_base = os.path.basename (dir[0])    # get dir
                oneup = dir[0].strip(os.path.basename(dir[0]))
                oneup = oneup.strip ('\\')
                oneup = oneup.strip ('/')
                oneup_dir_base = os.path.basename (oneup)   # get directory name one up
                
                # get the summary data
                try:
                    with open ('config.txt', 'r') as f:
                        config = yaml.load (f)
                    with open ('stats.txt', 'r') as f:
                        stats = yaml.load (f)
                except:
                    print('ERROR with directory: ' + directory)
                
                # get the gsd and percentiles
                gsd = pd.read_csv ('gsd.txt')
                perc = pd.read_csv ('percentiles.txt')
                
                # create the keys
                keys = list (('dir_base', 'dir', 'dir_oneup_base'))
                keys.extend (config.keys ())
                keys.extend (stats.keys ())
                keys.extend (list('p_' + perc['percentiles'].astype ('str')))
                keys.extend (list('b_' + gsd['bins'].astype ('str')))
                
                # create the data list
                dta = list ((directory_base, directory, oneup_dir_base))
                dta.extend (config.values ())
                dta.extend (stats.values ())
                dta.extend (list(perc['vals']))
                dta.extend (list(gsd['freqs']))
                dta = pd.Series (data = dta, index = keys)
                
                # if this the first row, make the dataframe
                if first_row:
                    res = pd.DataFrame (columns = keys)
                    init_keys = copy.copy (keys)            # copy the keys
                    first_row = False                       # set the flag low
                else:
                    # check the keys 
                    if not init_keys == keys:
                        print ('WHOA! Error with the keys we found in: ' + directory)
                        print (init_keys)
                        print ('\n\n\n')
                        print (keys)
                        sys.exit ()
                        
                # append the data list
                res = res.append (dta, ignore_index = True)
                print ('completed: ' + directory)
            except:
                print ('error with: ' + directory)
                
    # save the file
    res.to_csv (output_file, index = False)
    return
            
