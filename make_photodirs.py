# make_photodirs
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

def make_photodirs (target_dir):
    '''
    function to make sub directories for each image, labeled with the
    image name.
    target_dir = directory that contains all the images
    '''
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
        print ('completed: ' + im)
    
    os.chdir (oldwd)    
    return

if __name__ == '__main__':    
    target_dirs = 'C://data//data//stripes//photoseives//pismo'
    make_photodirs (target_dirs)






