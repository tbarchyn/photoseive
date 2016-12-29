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

source ('C://Users//tom//Dropbox//python//photoseive//dgs_plotter_functions.R')


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
if (FALSE) {
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
}
    
###################################################################
# plot collections
# these are collections across various transects to be plotted on the same
# plot to faciliate better comparison between various types
# ARGENTINA 2014
ar2014_key <- read.csv ('C://data//data//stripes//photoseives//argentina_2014_key.csv')
ar2014_filename <- 'C://data//data//stripes//photoseives//argentina_2014_collection.png'

collection_plot (ar2014, ar2014_key, ar2014_gsdbins, ar2014_gsdmask, ar2014_filename, log2_gsd = TRUE)
collection_plot (ar2014, ar2014_key, ar2014_gsdbins, ar2014_gsdmask, log2_gsd = TRUE)


# ARGENTINA 2015
ar2015_key <- read.csv ('C://data//data//stripes//photoseives//argentina_2015_key.csv')
ar2015_filename <- 'C://data//data//stripes//photoseives//argentina_2015_collection.png'

collection_plot (ar2015, ar2015_key, ar2015_gsdbins, ar2015_gsdmask, ar2015_filename, log2_gsd = TRUE)
collection_plot (ar2015, ar2015_key, ar2015_gsdbins, ar2015_gsdmask, log2_gsd = TRUE)


# PISMO
pismo_key <- read.csv ('C://data//data//stripes//photoseives//pismo_key.csv')
    
# split up into the various transects
pismo_key_1 <- pismo_key [pismo_key$transect == 1, ]
pismo_key_3 <- pismo_key [pismo_key$transect == 3, ]

pismo_filename_1 <- 'C://data//data//stripes//photoseives//pismo_collection_1.png'
pismo_filename_3 <- 'C://data//data//stripes//photoseives//pismo_collection_3.png'

# collection plots
collection_plot_pismo (pismo, pismo_key_1, pismo_gsdbins, pismo_gsdmask, log2_gsd = TRUE)
collection_plot_pismo (pismo, pismo_key_3, pismo_gsdbins, pismo_gsdmask, log2_gsd = TRUE)

collection_plot_pismo (pismo, pismo_key_1, pismo_gsdbins, pismo_gsdmask, pismo_filename_1, log2_gsd = TRUE)
collection_plot_pismo (pismo, pismo_key_3, pismo_gsdbins, pismo_gsdmask, pismo_filename_3, log2_gsd = TRUE)



# MEAN PLOTS
# argentina 2015
ar2014_mean_filename <- 'C://data//data//stripes//photoseives//argentina_2014_mean_collection.png'
mean_collection_plot (ar2014, ar2014_key, ar2014_gsdbins, ar2014_gsdmask, pismo_treatment = FALSE, log2_gsd = TRUE)
mean_collection_plot (ar2014, ar2014_key, ar2014_gsdbins, ar2014_gsdmask, ar2014_mean_filename, 
                      pismo_treatment = FALSE, log2_gsd = TRUE)

# argentina 2015
ar2015_mean_filename <- 'C://data//data//stripes//photoseives//argentina_2015_mean_collection.png'
mean_collection_plot (ar2015, ar2015_key, ar2015_gsdbins, ar2015_gsdmask, pismo_treatment = FALSE, log2_gsd = TRUE)
mean_collection_plot (ar2015, ar2015_key, ar2015_gsdbins, ar2015_gsdmask, ar2015_mean_filename,
                      pismo_treatment = FALSE, log2_gsd = TRUE)

# pismo
pismo_mean_filename_1 <- 'C://data//data//stripes//photoseives//pismo_means_collection_1.png'
pismo_mean_filename_3 <- 'C://data//data//stripes//photoseives//pismo_means_collection_3.png'

mean_collection_plot (pismo, pismo_key_1, pismo_gsdbins, pismo_gsdmask, pismo_treatment = TRUE, log2_gsd = TRUE)
mean_collection_plot (pismo, pismo_key_3, pismo_gsdbins, pismo_gsdmask, pismo_treatment = TRUE, log2_gsd = TRUE)
mean_collection_plot (pismo, pismo_key_1, pismo_gsdbins, pismo_gsdmask, pismo_mean_filename_1, 
                      pismo_treatment = TRUE, log2_gsd = TRUE)
mean_collection_plot (pismo, pismo_key_3, pismo_gsdbins, pismo_gsdmask, pismo_mean_filename_3, 
                      pismo_treatment = TRUE, log2_gsd = TRUE)


# QUANTILE plots
# argentina 2015
ar2014_quantile_filename <- 'C://data//data//stripes//photoseives//argentina_2014_quantile_collection.png'
quantile_collection_plot (ar2014, ar2014_key, ar2014_gsdbins, ar2014_gsdmask, pismo_treatment = FALSE, log2_gsd = TRUE)
quantile_collection_plot (ar2014, ar2014_key, ar2014_gsdbins, ar2014_gsdmask, ar2014_quantile_filename,
                          pismo_treatment = FALSE, log2_gsd = TRUE)

# argentina 2015
ar2015_quantile_filename <- 'C://data//data//stripes//photoseives//argentina_2015_quantile_collection.png'
quantile_collection_plot (ar2015, ar2015_key, ar2015_gsdbins, ar2015_gsdmask, pismo_treatment = FALSE, log2_gsd = TRUE)
quantile_collection_plot (ar2015, ar2015_key, ar2015_gsdbins, ar2015_gsdmask, ar2015_quantile_filename,
                          pismo_treatment = FALSE, log2_gsd = TRUE)

# pismo
pismo_quantile_filename_1 <- 'C://data//data//stripes//photoseives//pismo_quantile_collection_1.png'
pismo_quantile_filename_3 <- 'C://data//data//stripes//photoseives//pismo_quantile_collection_3.png'

quantile_collection_plot (pismo, pismo_key_1, pismo_gsdbins, pismo_gsdmask, pismo_treatment = TRUE, log2_gsd = TRUE)
quantile_collection_plot (pismo, pismo_key_3, pismo_gsdbins, pismo_gsdmask, pismo_treatment = TRUE, log2_gsd = TRUE)
quantile_collection_plot (pismo, pismo_key_1, pismo_gsdbins, pismo_gsdmask, pismo_quantile_filename_1,
                          pismo_treatment = TRUE, log2_gsd = TRUE)
quantile_collection_plot (pismo, pismo_key_3, pismo_gsdbins, pismo_gsdmask, pismo_quantile_filename_3,
                          pismo_treatment = TRUE, log2_gsd = TRUE)


# RATIO plots
# argentina 2015
ar2014_ratio_filename <- 'C://data//data//stripes//photoseives//argentina_2014_quantile_ratio.png'
quantile_ratio_plot (ar2014, ar2014_key, ar2014_gsdbins, ar2014_gsdmask, pismo_treatment = FALSE, log2_gsd = TRUE)
quantile_ratio_plot (ar2014, ar2014_key, ar2014_gsdbins, ar2014_gsdmask, ar2014_ratio_filename, 
                     pismo_treatment = FALSE, log2_gsd = TRUE)

# argentina 2015
ar2015_ratio_filename <- 'C://data//data//stripes//photoseives//argentina_2015_quantile_ratio.png'
quantile_ratio_plot (ar2015, ar2015_key, ar2015_gsdbins, ar2015_gsdmask, pismo_treatment = FALSE, log2_gsd = TRUE)
quantile_ratio_plot (ar2015, ar2015_key, ar2015_gsdbins, ar2015_gsdmask, ar2015_ratio_filename, 
                     pismo_treatment = FALSE, log2_gsd = TRUE)

# pismo
pismo_ratio_filename_1 <- 'C://data//data//stripes//photoseives//pismo_quantile_ratio_1.png'
pismo_ratio_filename_3 <- 'C://data//data//stripes//photoseives//pismo_quantile_ratio_3.png'
quantile_ratio_plot (pismo, pismo_key_1, pismo_gsdbins, pismo_gsdmask, pismo_treatment = TRUE, log2_gsd = TRUE)
quantile_ratio_plot (pismo, pismo_key_3, pismo_gsdbins, pismo_gsdmask, pismo_treatment = TRUE, log2_gsd = TRUE)
quantile_ratio_plot (pismo, pismo_key_1, pismo_gsdbins, pismo_gsdmask, pismo_ratio_filename_1, 
                     pismo_treatment = TRUE, log2_gsd = TRUE)
quantile_ratio_plot (pismo, pismo_key_3, pismo_gsdbins, pismo_gsdmask, pismo_ratio_filename_3, 
                     pismo_treatment = TRUE, log2_gsd = TRUE)



