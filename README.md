## photoseive utility scripts

Various utilities to do photoseiving on a larger scale.

### Config file key

The config file is a yaml file that looks like this:
```
calibration_file: C:\\data\\data\\stripes\\cameras\\raleigh\\calibration.txt
clahe_dims: 16
density: 10
dofilter: 1
maxscale: 8
minscale: 3.14
notes: 8
resolution: 0.04965243
used_calibrated: 'yes'
verbose: 0
```

- **calibration_file:** the file which contains the image calibration data (ignore the 'C:\\data\\data\\stripes\\' part of the path).
- **clahe_dims:** this is the dimensions of the local histogram equalization applied to the images, which gives the 'clahe_image.jpg' files. This was used to enhance local contrast.
- **density:** this is the interval of the rows for calculation (e.g., calculate every 10 rows).
- **dofilter:** this does a prefilter on the greyscale converted images (1 = yes).
- **maxscale:** this cuts the maximum scale reported from the pyDGS program.
- **minscale:** this cuts the minimum scale reported from the pyDGS program.
- **notes:** this is the wavelet notes used.
- **resolution:** this is the measured mm/pixel, which is essential data as I've cropped out the ruler from the images.
- **used_calibrated:** this is either 'yes' or 'no' to denote whether I used the calibrated image, some of the calibrated images yeilded too much distortion on the ruler, thus I used uncalibrated images.
- **verbose:** this prints more stuff to the console.

See the pyDGS readme for more instructions: https://github.com/dbuscombe-usgs/pyDGS
