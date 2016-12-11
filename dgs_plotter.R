# make some simple plots for the dgs data
# Copyright 2014-2016 Thomas E. Barchyn
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

# this plots the dgs results

source ('C://Users//tom//Dropbox//python//photoseive//violinplot.R')


###################################################################
# FUNCTIONS
# get the column masks
get_col_mask <- function (input_dataframe, first_letter) {
    # function to split up the names of the dataframe by a mask first letter
    # input_dataframe = the input dataframe
    # first_letter = the first letter to split out
    # returns a mask of the names with that first letter
    
    names <- names(input_dataframe)
    names_split <- strsplit (names, '_')
    mask <- rep (FALSE, length(names))
    
    for (i in 1:length(names)) {
        # check the split
        if (names_split[[i]][1] == first_letter) {
            mask[i] <- TRUE
        } else {
            mask[i] <- FALSE
        }
    }
    return (mask)
}

# get the numbers from the column names
get_numbers <- function (input_dataframe, first_letter) {
    # function to get the numbers from a masked column name list
    # input_dataframe = the input dataframe
    # first_letter = the first letter to split out
    # returns a list of the numbers in the mask
    
    mask <- get_col_mask (input_dataframe, first_letter)
    names <- names(input_dataframe)[mask]
    names_split <- strsplit (names, '_')
    vals <- rep (NA, length(names))
    
    for (i in 1:length(names)) {
        # pull out the number
        vals[i] <- as.numeric (names_split[[i]][2])
    }
    return (vals)
}

# make individual plots of each photoseive
individual_plot <- function (input_dataframe, row, gsd, mask, filename) {
    # function to make an individual plot for each individual site 
    # input_dataframe = the input dataframe
    # row = the row to make a plot for
    # gsd = the grain size distribution x axis numbers
    # mask = the column mask to use for the plot
    # filename = the filename for the output png
    
    plot_title = input_dataframe$dir_base [row]
    png (filename = filename)
    plot (gsd, input_dataframe [row, mask], col = 'red',
          xlab = 'grainsize (mm)', ylab = 'relative frequency',
          main = plot_title)
    lines (gsd, input_dataframe [row, mask], col = 'red')
    dev.off ()
}

###################################################################
# read in the data
ar2014 <- read.csv ('C://data//data//stripes//photoseives//argentina_2014.csv')
ar2015 <- read.csv ('C://data//data//stripes//photoseives//argentina_2015.csv')
pismo <- read.csv ('C://data//data//stripes//photoseives//pismo.csv')

# get the masks for percentiles and gsd
ar2014_percmask <- get_col_mask (ar2014, 'p')
ar2014_gsdmask <- get_col_mask (ar2014, 'b')
ar2015_percmask <- get_col_mask (ar2015, 'p')
ar2015_gsdmask <- get_col_mask (ar2015, 'b')
pismo_percmask <- get_col_mask (pismo, 'p')
pismo_gsdmask <- get_col_mask (pismo, 'b')

# get the percentiles and gsd bins
ar2014_percbins <- get_numbers (ar2014, 'p')
ar2014_gsdbins <- get_numbers (ar2014, 'b')
ar2015_percbins <- get_numbers (ar2015, 'p')
ar2015_gsdbins <- get_numbers (ar2015, 'b')
pismo_percbins <- get_numbers (pismo, 'p')
pismo_gsdbins <- get_numbers (pismo, 'b')

###################################################################
# plot individual plots of each site
# ARGENTINA 2014
setwd ('C://data//data//stripes//photoseives//argentina_2014//plots')
for (i in 1:nrow (ar2014)) {
    filename = paste (ar2014$dir_base[i], '.png', sep = '')
    individual_plot (ar2014, i, ar2014_gsdbins, ar2014_gsdmask, filename)
    print (paste ('completed: ', i))
}

# ARGENTINA 2015
setwd ('C://data//data//stripes//photoseives//argentina_2015//plots')
for (i in 1:nrow (ar2015)) {
    filename = paste (ar2015$dir_base[i], '.png', sep = '')
    individual_plot (ar2015, i, ar2015_gsdbins, ar2015_gsdmask, filename)
    print (paste ('completed: ', i))
}

# PISMO
setwd ('C://data//data//stripes//photoseives//pismo//plots')
for (i in 1:nrow (pismo)) {
    filename = paste (pismo$dir_base[i], '.png', sep = '')
    individual_plot (pismo, i, pismo_gsdbins, pismo_gsdmask, filename)
    print (paste ('completed: ', i))
}










