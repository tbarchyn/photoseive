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

# STEP 1: take raw photos, and put them into directories

import os
import sys
import glob
import shutil
import numpy as np
import pandas as pd

def make_photodirs (target_dir):
    '''
    function to make sub directories for each image, labeled with the
    image name. Also copy over a blank config file.
    target_dir = directory that contains all the images
    '''
    
    default_config_file = 'C:\\data\\data\\stripes\\photoseives\\config.txt'
    
    oldwd = os.getcwd ()
    os.chdir (target_dir)
    
    images = glob.glob ('*.jpg')
    if len(images) == 0:
        print ('no images found!')
    
    for im in images:
        im_name = im.strip ('.jpg')         # get image name
        im_name = im.strip ('.JPG') 
        dir_name = 'image_' + im_name       # make a dir name
        os.mkdir (dir_name)                 # make a directory
        shutil.copy2 (im, os.path.join(os.getcwd(), dir_name, im))
        shutil.copy2 (default_config_file, os.path.join (os.getcwd(), dir_name, 'config.txt'))
        print ('completed: ' + im)
    
    os.chdir (oldwd)
    print ('complete!')
        
    return

def make_key_dataframe (base_dir, output_dataframe):
    '''
    function to make a 'key' dataframe with a list of all the images we are going to analyze.
    base_dir = base directory to walk down through
    output_dataframe = the output file to write the dataframe
    '''
    indices = ('name', 'location')
    key_dataframe = pd.DataFrame (index = indices)

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
                image_name_base = os.path.basename (image_name)
                image_location = os.path.dirname (image_name)
                
                # construct the new row and append
                add_row = pd.Series (data = (image_name_base, image_location), index = indices)
                key_dataframe = key_dataframe.append (add_row, ignore_index = True)

    # write out the dataframe to disk
    key_dataframe.to_csv (output_dataframe, index = False)
    print ('complete!')
    
    return


if __name__ == '__main__':    
    target_dirs = 'C://data//data//stripes//photoseives//pismo'
    #make_photodirs (target_dirs)

    output_dataframe = 'C://data//data//stripes//photoseives//pismo_key.csv'
    make_key_dataframe (target_dirs, output_dataframe)




