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

# script to run the analysis

import os
import sys
import glob
import numpy as np
import pandas as pd

from distortion_calibration import *
from dgs_analysis import *
from coallate_gsd_data import *

def run_test ():
    '''
    method to run a local test for debugging - this is a temporary method that does nothing
    of significance - will eventually be deleted!
    '''
    test_file = 'C:\\data\\data\\stripes\\photoseives\\pismo\\image_DSC_0046_test\\test.JPG'
    dst = distortion_calibration (test_file)
    cal_test_file = dst.run ()
    
    gs = dgs_analysis (cal_test_file)
    gs.run ()
    return

def run_photoseive_tree (base_dir, scales):
    '''
    method to run photoseives for a tree of subdirectories from the base_dir.
    This looks for a config file and 1 image. The config.txt file contains all 
    the scaling data, the 1 image present is the 1 image to perform analysis on.
    This helps avoid errors as it is physical, the image present is analysed.
    
    base_dir = base directory to start the walk
    scales = user supplied scales
    '''

    # walk down the dirs, looking for config files and images
    for dir in os.walk (base_dir):
        files = dir[2]

        # look for a config file
        if files.count('config.txt') == 1:
            # we found one, let's see try to find the image
            images = glob.glob (os.path.join (dir[0], '*.JPG'))
            if len (images) != 1:
                print ('ERROR: there is a problem with the images here: ' + str(dir[0]))
            else:    
                # ok, looks good, there is 1 image, lets get that image name
                image_name = images[0]
                
                # run the analysis
                gs = dgs_analysis (image_name, scales)
                gs.run ()
                
    return

def change_config (base_dir, key, value):
    '''
    method to change some part of the config file
    
    base_dir = base directory to start the walk
    key = key to modify
    value = value to modify the key to
    '''

    # walk down the dirs, looking for config files and images
    for dir in os.walk (base_dir):
        files = dir[2]

        # look for a config file
        if files.count('config.txt') == 1:
            # we found one, let's see try to find the image
            images = glob.glob (os.path.join (dir[0], '*.JPG'))
            if len (images) != 1:
                print ('ERROR: there is a problem with the images here: ' + str(dir[0]))
            else:    
                # ok, looks good, there is 1 image, lets get that image name
                image_name = images[0]
                
                # init the dgs analysis object, then modify the config key and write
                gs = dgs_analysis (image_name, None)
                gs.config[key] = value
                gs.write_config ()
                
                
    return

def run_calibration_tree (base_dir):
    '''
    method to run camera distortion calibrations for a tree of subdirectories 
    from the base_dir. This looks for a config file and 1 image. The config.txt
    file contains all the scaling data, the 1 image present is the 1 image to
    perform analysis on. This helps avoid errors as it is physical, the image
    present is analysed.
    
    base_dir = base directory to start the walk
    '''
    
    # walk down the dirs, looking for config files and images
    for dir in os.walk (base_dir):
        files = dir[2]
        
        # look for a config file
        if files.count('config.txt') == 1:
            # we found one, let's see try to find the images
            images = glob.glob (os.path.join (dir[0], '*.JPG'))
            
            # ok let's do the calibration on all the images present
            for i in images:
                
                # check to see if we calibrated this image already
                i_strip = i.strip ('.JPG')
                if not i_strip[(len(i_strip) - 1)] == 'c':

                    # run the unwarping
                    dst = distortion_calibration (i)
                    cal_test_file = dst.run ()
                    
                    print ('completed image: ' + i)

    return

    
########################################################################################
# MAIN
if __name__ == '__main__':

    # set directories
    argentina_2014_directory = 'C:\\data\\data\\stripes\\photoseives\\argentina_2014'
    argentina_2015_directory = 'C:\\data\\data\\stripes\\photoseives\\argentina_2015'
    pismo_directory = 'C:\\data\\data\\stripes\\photoseives\\pismo'

    # set the scales of analysis as linear interval
    min_scale = 0.1
    max_scale = 5.0
    interval = 0.05
    scales = np.arange (min_scale, max_scale, interval)

    ##############################################################################
    # run the distortion calibration
    # run_calibration_tree (argentina_2014_directory)
    # run_calibration_tree (argentina_2015_directory)
    # run_calibration_tree (pismo_directory)
    
    ## STOP! CROP THE PHOTOS! ##
    ## MEASURE THE SCALES ##
    
    ##############################################################################
    # change the density for more detail
    # new_density = 10
    # change_config (argentina_2014_directory, 'density', new_density)
    # change_config (argentina_2015_directory, 'density', new_density)
    # change_config (pismo_directory, 'density', new_density)
    
    # run the photoseive calculations
    # run_photoseive_tree (argentina_2014_directory, scales)
    # run_photoseive_tree (argentina_2015_directory)
    # run_photoseive_tree (pismo_directory)
    
    ##############################################################################
    # coallate the output data
    argentina_2014_coallated_data = 'C:\\data\\data\\stripes\\photoseives\\argentina_2014.csv'
    argentina_2015_coallated_data = 'C:\\data\\data\\stripes\\photoseives\\argentina_2015.csv'
    pismo_coallated_data = 'C:\\data\\data\\stripes\\photoseives\\pismo.csv'
    
    # run the coallate data function
    coallate_gsd_data (argentina_2014_directory, argentina_2014_coallated_data)
    # coallate_gsd_data (argentina_2015_directory, argentina_2015_coallated_data)
    # coallate_gsd_data (pismo_directory, pismo_coallated_data)

    
    



