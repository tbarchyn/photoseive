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

# run distortion calibration on the images

import os
import sys
import cv2
import yaml
import numpy as np

class distortion_calibration:
    def __init__ (self, image_file):
        '''
        constructor takes the file name of the image to evaluate
        image_file = the input image name
        '''
        
        self.image_file = image_file
        file_dir = os.path.dirname (image_file)
        self.config_file = os.path.join (file_dir, 'config.txt')
        self.out_image_file = image_file.strip('.JPG') + '_c.JPG'
        
        # read the config file
        self.read_config ()

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

    def run (self):
        '''
        method to unwarp the image. This uses a calibration file which comes out of
        the U of C distortion calibration toolbox. Note that the calibration files
        are simply executed carte blanche (not a secure way to go about this . . but
        fine for this as backwards compatibility here is likely more valuable than
        security).
        
        This returns the image name for posterity
        '''
        
        # run the unwarping
        if not self.config_file_error:
            
            # run the calibration file
            try:
                execfile (str(self.config ['calibration_file']), globals())
            except:
                print ('ERROR: cannot read the calibration file: ' + self.config ['calibration_file'])
            
            # read in the image
            try:
                img = cv2.imread (self.image_file)
            except:
                print ('ERROR: cannot read the image file: ' + self.image_file)
                
            # unwarp the image
            h, w = img.shape[:2]
            newcamera, roi = cv2.getOptimalNewCameraMatrix (K, d, (w,h), 0) 
            newimg = cv2.undistort (img, K, d, None, newcamera)
    
            # write the image
            cv2.imwrite (self.out_image_file, newimg)  
            
        return (self.out_image_file)
            
            
            