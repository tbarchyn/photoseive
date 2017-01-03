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

# deblur: this utility experiments with deblurring photoseived imagery
#         to accentuate the edges of the grains, and help correct for
#         the issues with camera lenses being inherently less awesome
#         than the number of pixels in the imagery.

import os
import sys
import yaml
import numpy as np
import cv2

class deblur:
    def __init__ (self, filename):
        '''
        constructor takes the file and reads it into disk
        filename = the filename of the file to deblur
        '''
        try:
            self.frame = cv2.imread (filename)
        except:
            print ('ERROR reading file: ' + filename)
            
        return
    
    def tinted_highpass (self, radius, tint, output_file = None):
        '''
        method to perform a tinted highpass filter with a circular radius
        of a certain number of pixels. This is then tinted with the pre-existing
        rgb value and written to disk. The tint ranges from 0 to 1, where 0
        is where the reported value from the highpass filter, and 1 is just the
        input image.
        
        radius = the circular radius of the highpass mean filter
        tint = the amount to tint the highpass filter value with the input image,
               ranges from 0 (no tint) to 1 (full tint)
        output_file = the output filename (optional, writes to disk if supplied, else
               returns the numpy array).
        '''
        # figure out the kernel dimensions, ensure it is odd
        kernel_dim = int(radius * 2.0)
        if kernel_dim % 2 == 0:
            kernel_dim = kernel_dim + 1
            
        center_dim = int (kernel_dim / 2)
        
        # make the kernel, by setting the kernel to 0 outside the radius
        kernel = np.ones ((kernel_dim, kernel_dim))
        for i in range (0, kernel.shape[0]):
            for j in range (0, kernel.shape[1]):
                dist_to_center = np.sqrt ((i - center_dim)**2.0 + (j - center_dim)**2.0)
                if dist_to_center > radius:
                    kernel[i, j] = 0.0
                    
        # normalize
        kernel = kernel / kernel.sum ()            
        
        # perform highpass
        avg = cv2.filter2D (self.frame, -1, kernel)
        highpass = self.frame - avg
        
        # tint
        oput = np.array ((tint * highpass) + ((1.0 - tint) * self.frame), np.uint8)
        
        # return the output or write to disk
        if output_file is None:
            return (oput)
        else:
            try:
                cv2.imwrite (oput, output_file)
            except:
                print ('ERROR: cannot write output file: ' + output_file)
        
        



