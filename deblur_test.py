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

# deblur test: quick testing script for the deblur utility

from deblur import *

# MAIN
if __name__ == '__main__':
    # read in test image
    test_image = 'C://Users//tom//Dropbox//python//photoseive//image.jpg'
    output_image = 'C://Users//tom//Dropbox//python//photoseive//tint_test.jpg'
    
    im = deblur (test_image)
    im.tinted_highpass (radius = 20, tint = 0, output_file = output_image)
    
