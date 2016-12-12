# dgs_plotter_functions.R
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

# collection plot of an individual transect
collection_plot <- function (input_dataframe, key, gsd, mask, filename) {
    # function to make a collection plot across a given transect (or zone
    # where it is meaningful to compare across) 
    # input_dataframe = the input dataframe
    # key = the input key dataframe with columns dir_base, and type, which
    #       is one of s (stripe) or r (ripple).
    # gsd = the grain size distribution x axis numbers
    # mask = the column mask to use for the plot
    # filename = the filename for the output png (optional)
    
    stripe_color <- 'red'
    ripple_color <- 'blue'
    
    if (!missing (filename)) {
        png (filename = filename)
    }
    
    # find the max density to make the plot properly
    max_density = 0.0
    for (i in 1:nrow(key)) {
        row_max <- max (input_dataframe[input_dataframe$dir_base == key$dir_base[i], mask])
        if (row_max > max_density) {
            max_density <- row_max
        }
    }
    
    # make the plot starting with a prototype call
    plot (gsd, input_dataframe [1, mask], cex = 0, ylim = c(0, max_density),
          xlab = 'grainsize (mm)', ylab = 'relative frequency')
    
    # loop through the individual sites
    for (i in 1:nrow(key)) {
        # set color
        if (key$type[i] == 's') {
            color <- stripe_color
        } else if (key$type[i] == 'r') {
            color <- ripple_color
        } else {
            print ('undefined key type')
        }
        
        # add the points
        #points (gsd, input_dataframe [input_dataframe$dir_base == key$dir_base[i], mask],
        #        col = color)
        # add the lines
        lines (gsd, input_dataframe [input_dataframe$dir_base == key$dir_base[i], mask],
               col = color)
    }
    
    # add a legend
    legend (x = max(gsd) - 2, y = max_density, legend = c('stripes', 'ripples'),
            col = c(stripe_color, ripple_color), lty = 1)
    
    if (!missing(filename)) {
        dev.off ()
    }    
}

collection_plot_pismo <- function (input_dataframe, key, gsd, mask, filename) {
    # function to make a collection plot across a given transect (or zone
    # where it is meaningful to compare across). Special for pismo. 
    # input_dataframe = the input dataframe
    # key = the input key dataframe with columns dir_base, and type, which
    #       is one of s (stripe) or r (ripple).
    # gsd = the grain size distribution x axis numbers
    # mask = the column mask to use for the plot
    # filename = the filename for the output png (optional)
    
    stripe_color <- 'red'
    ripple_color <- 'blue'
    
    # ensure we don't have any broken factors
    input_dataframe$dir_oneup_base <- as.character (input_dataframe$dir_oneup_base)
    key$dir_base <- as.character (key$dir_base)
    
    if (!missing (filename)) {
        png (filename = filename)
    }
    
    # find the max density to make the plot properly
    max_density = 0.0
    for (i in 1:nrow(key)) {
        # mod for pismo, use dir_oneup_base
        cut_dataframe <- input_dataframe [input_dataframe$dir_oneup_base == key$dir_base[i], ]
        cut_dataframe <- cut_dataframe [, mask]
        row_max <- max (cut_dataframe)
        
        if (row_max > max_density) {
            max_density <- row_max
        }
    }

    # make the plot starting with a prototype call
    plot (gsd, input_dataframe [1, mask], cex = 0, ylim = c(0, max_density),
          xlab = 'grainsize (mm)', ylab = 'relative frequency')
    
    # loop through the individual sites
    for (i in 1:nrow(key)) {
        # set color
        if (key$type[i] == 's') {
            color <- stripe_color
        } else if (key$type[i] == 'r') {
            color <- ripple_color
        } else {
            print ('undefined key type')
        }
        
        # for pismo, we need to plot the mean of values where there was more than one
        # photo taken of the same patch of sediment.
        cut_dataframe <- input_dataframe [input_dataframe$dir_oneup_base == key$dir_base[i], ]
        cut_dataframe <- cut_dataframe [, mask]
        mean_gsds <- apply (X = cut_dataframe, MARGIN = 2, FUN = mean)
        
        # add the points
        #points (gsd, input_dataframe [input_dataframe$dir_base == key$dir_base[i], mask],
        #        col = color)
        # add the lines
        lines (gsd, mean_gsds, col = color)
    }
    
    # add a legend
    legend (x = max(gsd) - 2, y = max_density, legend = c('stripes', 'ripples'),
            col = c(stripe_color, ripple_color), lty = 1)
    
    if (!missing(filename)) {
        dev.off ()
    }    
}




# mean plot of all the stripes and ripples in a collection
mean_collection_plot <- function (input_dataframe, key, gsd, mask, filename) {
    # function to make a mean collection plot across a given transect (or zone
    # where it is meaningful to compare across) 
    # input_dataframe = the input dataframe
    # key = the input key dataframe with columns dir_base, and type, which
    #       is one of s (stripe) or r (ripple).
    # gsd = the grain size distribution x axis numbers
    # mask = the column mask to use for the plot
    # filename = the filename for the output png (optional)
    
    stripe_color <- 'red'
    ripple_color <- 'blue'
    
    if (!missing (filename)) {
        png (filename = filename)
    }
    
    # take means of all the stripes and ripples
    stripe_names <- key$dir_base [key$type == 's']
    ripple_names <- key$dir_base [key$type == 'r']
    
    cut_dataframe <- input_dataframe []
    for (i in stripe_names) {
        cut_data <- NULL
        
        
        
    }
    #cut_dataframe <- input_dataframe [in]
    
    
    
    # find the max density to make the plot properly
    max_density = 0.0
    for (i in 1:nrow(key)) {
        row_max <- max (input_dataframe [input_dataframe$dir_base == key$dir_base[i], mask])
        if (row_max > max_density) {
            max_density <- row_max
        }
    }
    
    # make the plot starting with a prototype call
    plot (gsd, input_dataframe [1, mask], cex = 0, ylim = c(0, max_density),
          xlab = 'grainsize (mm)', ylab = 'relative frequency')
    
    # loop through the individual sites
    for (i in 1:nrow(key)) {
        # set color
        if (key$type[i] == 's') {
            color <- stripe_color
        } else if (key$type[i] == 'r') {
            color <- ripple_color
        } else {
            print ('undefined key type')
        }
        
        # add the points
        #points (gsd, input_dataframe [input_dataframe$dir_base == key$dir_base[i], mask],
        #        col = color)
        # add the lines
        lines (gsd, input_dataframe [input_dataframe$dir_base == key$dir_base[i], mask],
               col = color)
    }
    
    # add a legend
    legend (x = max(gsd) - 2, y = max_density, legend = c('stripes', 'ripples'),
            col = c(stripe_color, ripple_color), lty = 1)
    
    if (!missing(filename)) {
        dev.off ()
    }    
}




