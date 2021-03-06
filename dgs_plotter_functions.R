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
individual_plot <- function (input_dataframe, row, gsd, mask, log2_gsd = F, filename) {
    # function to make an individual plot for each individual site 
    # input_dataframe = the input dataframe
    # row = the row to make a plot for
    # gsd = the grain size distribution x axis numbers
    # mask = the column mask to use for the plot
    # log2_gsd = boolean to control whether or not to plot gsd as log2(gsd)
    # filename = the filename for the output png

    input_dataframe [input_dataframe == 0.0] <- NA
    gsd[gsd == 0.0] <- NA
    
    if (log2_gsd) {
        gsd <- log2 (gsd)
        x_label <- 'log2 (grainsize) (log2 (mm))'
    } else {
        x_label <- 'grainsize (mm)'
    }

    plot_title = input_dataframe$dir_base [row]
    
    if (!missing (filename)) {
        png (filename = filename)
    }
    
    plot (gsd, input_dataframe [row, mask], col = 'red',
          xlab = x_label, ylab = 'relative frequency',
          main = plot_title)
    lines (gsd, input_dataframe [row, mask], col = 'red')
    
    if (!missing (filename)) {
        dev.off ()
    }    
}

# collection plot of an individual transect
collection_plot <- function (input_dataframe, key, gsd, mask, filename, log2_gsd = F, 
                             logaxes = F) {
    # function to make a collection plot across a given transect (or zone
    # where it is meaningful to compare across) 
    # input_dataframe = the input dataframe
    # key = the input key dataframe with columns dir_base, and type, which
    #       is one of s (stripe) or r (ripple).
    # gsd = the grain size distribution x axis numbers
    # mask = the column mask to use for the plot
    # filename = the filename for the output png (optional)
    # log2_gsd = boolean to control whether or not to plot gsd as log2(gsd)
    # logaxes = use log axes or not

    stripe_color <- 'red'
    ripple_color <- 'blue'
    
    input_dataframe [input_dataframe == 0.0] <- NA
    gsd[gsd == 0.0] <- NA
    
    if (log2_gsd) {
        gsd <- log2 (gsd)
        x_label <- 'log2 (grainsize) (log2 (mm))'
    } else {
        x_label <- 'grainsize (mm)'
    }
    
    if (!missing (filename)) {
        png (filename = filename)
    }
    
    # find the max density to make the plot properly
    max_density <- 1e-10
    for (i in 1:nrow(key)) {
        row_max <- max (as.numeric (
            input_dataframe[input_dataframe$dir_base == key$dir_base[i], mask]),
            na.rm = T)
        if (!is.na(row_max)) {
            if (row_max > max_density) {
                max_density <- row_max
            }
        }    
    }

    # make the plot starting with a prototype call
    if (logaxes) {
        plot (gsd, input_dataframe [1, mask], cex = 0, ylim = c(1e-5, max_density),
              xlab = x_label, ylab = 'relative frequency', log = 'xy')
    } else {
        plot (gsd, input_dataframe [1, mask], cex = 0, ylim = c(1e-5, max_density),
              xlab = x_label, ylab = 'relative frequency')
    }
    
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

collection_plot_pismo <- function (input_dataframe, key, gsd, mask, filename, log2_gsd = F,
                                   logaxes = F) {
    # function to make a collection plot across a given transect (or zone
    # where it is meaningful to compare across). Special for pismo. 
    # input_dataframe = the input dataframe
    # key = the input key dataframe with columns dir_base, and type, which
    #       is one of s (stripe) or r (ripple).
    # gsd = the grain size distribution x axis numbers
    # mask = the column mask to use for the plot
    # filename = the filename for the output png (optional)
    # log2_gsd = boolean to control whether or not to plot gsd as log2(gsd)
    # logaxes = use log axes or not
    
    stripe_color <- 'red'
    ripple_color <- 'blue'
    
    input_dataframe [input_dataframe == 0.0] <- NA
    gsd[gsd == 0.0] <- NA
    
    # ensure we don't have any broken factors
    input_dataframe$dir_oneup_base <- as.character (input_dataframe$dir_oneup_base)
    key$dir_base <- as.character (key$dir_base)
    
    if (log2_gsd) {
        gsd <- log2 (gsd)
        x_label <- 'log2 (grainsize) (log2 (mm))'
    } else {
        x_label <- 'grainsize (mm)'
    }
    
    if (!missing (filename)) {
        png (filename = filename)
    }
    
    # find the max density to make the plot properly
    max_density <- 1e-10
    for (i in 1:nrow(key)) {
        # mod for pismo, use dir_oneup_base
        cut_dataframe <- input_dataframe [input_dataframe$dir_oneup_base == key$dir_base[i], ]
        cut_dataframe <- cut_dataframe [, mask]
        row_max <- max (cut_dataframe, na.rm = T)
        if (!is.na(row_max)) {
            if (row_max > max_density) {
                max_density <- row_max
            }
        }    
    }

    # make the plot starting with a prototype call
    if (logaxes) {
        plot (gsd, input_dataframe [1, mask], cex = 0, ylim = c(1e-5, max_density),
          xlab = x_label, ylab = 'relative frequency', log = 'xy')
    } else {
        plot (gsd, input_dataframe [1, mask], cex = 0, ylim = c(1e-5, max_density),
              xlab = x_label, ylab = 'relative frequency')
    }
    
    
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
mean_collection_plot <- function (input_dataframe, key, gsd, mask, filename, pismo_treatment,
                                  log2_gsd = F, logaxes = F) {
    # function to make a mean collection plot across a given transect (or zone
    # where it is meaningful to compare across) 
    # input_dataframe = the input dataframe
    # key = the input key dataframe with columns dir_base, and type, which
    #       is one of s (stripe) or r (ripple).
    # gsd = the grain size distribution x axis numbers
    # mask = the column mask to use for the plot
    # filename = the filename for the output png (optional)
    # pismo_treatment = the special boolean to deal with pismo
    # log2_gsd = boolean to control whether or not to plot gsd as log2(gsd)
    # logaxes = use log axes
    
    stripe_color <- 'red'
    ripple_color <- 'blue'
    
    input_dataframe [input_dataframe == 0.0] <- NA
    gsd[gsd == 0.0] <- NA
    
    if (log2_gsd) {
        gsd <- log2 (gsd)
        x_label <- 'log2 (grainsize) (log2 (mm))'
    } else {
        x_label <- 'grainsize (mm)'
    }
    
    if (!missing (filename)) {
        png (filename = filename)
    }
    
    # ensure we don't have any broken factors
    input_dataframe$dir_oneup_base <- as.character (input_dataframe$dir_oneup_base)
    input_dataframe$dir_base <- as.character (input_dataframe$dir_base)
    key$dir_base <- as.character (key$dir_base)
    
    # do the special treatment for pismo where the images are in directories named
    # by their image name (which doesn't correspond to site). The site corresponds
    # to the dir_oneup_base, which is the directory oneup
    if (pismo_treatment) {
        input_dataframe$dir_base <- input_dataframe$dir_oneup_base
    }
    
    # take means of all the stripes and ripples
    stripe_names <- key$dir_base [key$type == 's']
    ripple_names <- key$dir_base [key$type == 'r']
    
    # assemble the stripes
    cut_dataframe <- input_dataframe [1, ]          # make a base dataframe
    for (i in stripe_names) {
        new_dataframe <- input_dataframe [input_dataframe$dir_base == i, ]
        cut_dataframe <- rbind (cut_dataframe, new_dataframe)
    }
    
    cut_dataframe <- cut_dataframe [-1, ]   # get rid of the first column
    cut_dataframe <- cut_dataframe [, mask]
    stripes <- apply (X = cut_dataframe, MARGIN = 2, FUN = mean)

    # assemble the ripples
    cut_dataframe <- input_dataframe [1, ]          # make a base dataframe
    for (i in ripple_names) {
        new_dataframe <- input_dataframe [input_dataframe$dir_base == i, ]
        cut_dataframe <- rbind (cut_dataframe, new_dataframe)
    }
    
    cut_dataframe <- cut_dataframe [-1, ]   # get rid of the first column
    cut_dataframe <- cut_dataframe [, mask]
    ripples <- apply (X = cut_dataframe, MARGIN = 2, FUN = mean)

    # find the maximum density
    max_density <- max (c(max(ripples, na.rm = T), max(stripes, na.rm = T)))
    
    # setup the plots
    if (logaxes) {
        plot (gsd, stripes, col = 'red', ylim = c(1e-5, max_density), 
              xlab = x_label, ylab = 'relative frequency', log = 'xy')
    } else {
        plot (gsd, stripes, col = 'red', ylim = c(1e-5, max_density), 
              xlab = x_label, ylab = 'relative frequency')
    }
    
    lines (gsd, stripes, col = 'red')
    points (gsd, ripples, col = 'blue')
    lines (gsd, ripples, col = 'blue')

    # add a legend
    legend (x = max(gsd) - 2, y = max_density, legend = c('stripes', 'ripples'),
            col = c(stripe_color, ripple_color), lty = 1)
    
    if (!missing(filename)) {
        dev.off ()
    }    
}

# quantile plot of all the stripes and ripples in a collection
quantile_collection_plot <- function (input_dataframe, key, gsd, mask, filename, pismo_treatment,
                                      log2_gsd = F, logaxes = F) {
    # function to make a median collection plot across a given transect (or zone
    # where it is meaningful to compare across) 
    # input_dataframe = the input dataframe
    # key = the input key dataframe with columns dir_base, and type, which
    #       is one of s (stripe) or r (ripple).
    # gsd = the grain size distribution x axis numbers
    # mask = the column mask to use for the plot
    # filename = the filename for the output png (optional)
    # pismo_treatment = the special boolean to deal with pismo
    # log2_gsd = boolean to control whether or not to plot gsd as log2(gsd)
    # logaxes = use log axes
    
    stripe_color <- 'red'
    ripple_color <- 'blue'
    alpha_transparency <- 0.2
    
    input_dataframe [input_dataframe == 0.0] <- NA
    gsd[gsd == 0.0] <- NA
    
    if (log2_gsd) {
        gsd <- log2 (gsd)
        x_label <- 'log2 (grainsize) (log2 (mm))'
    } else {
        x_label <- 'grainsize (mm)'
    }
    
    if (!missing (filename)) {
        png (filename = filename)
    }
    
    # ensure we don't have any broken factors
    input_dataframe$dir_oneup_base <- as.character (input_dataframe$dir_oneup_base)
    input_dataframe$dir_base <- as.character (input_dataframe$dir_base)
    key$dir_base <- as.character (key$dir_base)
    
    # do the special treatment for pismo where the images are in directories named
    # by their image name (which doesn't correspond to site). The site corresponds
    # to the dir_oneup_base, which is the directory oneup
    if (pismo_treatment) {
        input_dataframe$dir_base <- input_dataframe$dir_oneup_base
    }
    
    # take means of all the stripes and ripples
    stripe_names <- key$dir_base [key$type == 's']
    ripple_names <- key$dir_base [key$type == 'r']
    
    # assemble the stripes
    cut_dataframe <- input_dataframe [1, ]          # make a base dataframe
    for (i in stripe_names) {
        new_dataframe <- input_dataframe [input_dataframe$dir_base == i, ]
        cut_dataframe <- rbind (cut_dataframe, new_dataframe)
    }
    
    cut_dataframe <- cut_dataframe [-1, ]   # get rid of the first column
    cut_dataframe <- cut_dataframe [, mask]
    stripes_0.1 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.1, na.rm = T)
    stripes_0.25 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.25, na.rm = T)
    stripes_0.5 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.5, na.rm = T)
    stripes_0.75 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.75, na.rm = T)
    stripes_0.9 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.9, na.rm = T)
    
    # assemble the ripples
    cut_dataframe <- input_dataframe [1, ]          # make a base dataframe
    for (i in ripple_names) {
        new_dataframe <- input_dataframe [input_dataframe$dir_base == i, ]
        cut_dataframe <- rbind (cut_dataframe, new_dataframe)
    }
    
    cut_dataframe <- cut_dataframe [-1, ]   # get rid of the first column
    cut_dataframe <- cut_dataframe [, mask]
    ripples_0.1 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.1, na.rm = T)
    ripples_0.25 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.25, na.rm = T)
    ripples_0.5 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.55, na.rm = T)
    ripples_0.75 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.75, na.rm = T)
    ripples_0.9 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.9, na.rm = T)
    
    # find the maximum density
    max_density <- max (c(max(ripples_0.9, na.rm = T), max(stripes_0.9, na.rm = T)))
    
    # setup the plots
    if (logaxes) {
        plot (gsd, stripes_0.5, col = 'red', cex = 0.0, ylim = c(1e-5, max_density), 
              xlab = x_label, ylab = 'relative frequency', log = 'xy')
    } else {
        plot (gsd, stripes_0.5, col = 'red', cex = 0.0, ylim = c(1e-5, max_density), 
              xlab = x_label, ylab = 'relative frequency')
    }
    
    # plot the polygons between 0.25 and 0.75 quantiles
    # stripes
    polygon (x = c(gsd, rev(gsd)), y = c(stripes_0.75, rev(stripes_0.25)), 
            col = adjustcolor (stripe_color, alpha.f = alpha_transparency), border = NA)
    polygon (x = c(gsd, rev(gsd)), y = c(ripples_0.75, rev(ripples_0.25)), 
             col = adjustcolor (ripple_color, alpha.f = alpha_transparency), border = NA)
    
    # plot the 0.9 and 0.1 quantiles as dotted lines
    lines (gsd, stripes_0.9, col = stripe_color, lty = 3)
    lines (gsd, stripes_0.1, col = stripe_color, lty = 3)
    lines (gsd, ripples_0.9, col = ripple_color, lty = 3)
    lines (gsd, ripples_0.1, col = ripple_color, lty = 3)
    
    # plot the 0.5 quantiles as solid lines
    lines (gsd, stripes_0.5, col = stripe_color)
    lines (gsd, ripples_0.5, col = ripple_color)
    
    # add a legend, showing the quantiles
    legend (x = max(gsd) - 3, y = max_density, 
            legend = c('90%, 10% stripes', '90%, 10% ripples', '50% stripes', '50% ripples',
                       '75% to 25% stripes', '75% to 25% ripples'),
            col = c(stripe_color, ripple_color, stripe_color, ripple_color,
                    stripe_color, ripple_color),
                    lty = c(3, 3, 1, 1, NA, NA),
                    fill = c(NA, NA, NA, NA, adjustcolor (stripe_color, alpha.f = alpha_transparency),
                             adjustcolor (ripple_color, alpha.f = alpha_transparency)),
                    border = c(NA, NA, NA, NA, NA, NA),
                    bty = 'n', merge = T)

    if (!missing(filename)) {
        dev.off ()
    }    
}

# quantile plot of all the stripes and ripples as a ratio of ripple / stripe
quantile_ratio_plot <- function (input_dataframe, key, gsd, mask, filename, pismo_treatment,
                                 log2_gsd = F, logaxes = F) {
    # function to make a median collection plot across a given transect (or zone
    # where it is meaningful to compare across). This plots the ratio of ripple / stripe
    # input_dataframe = the input dataframe
    # key = the input key dataframe with columns dir_base, and type, which
    #       is one of s (stripe) or r (ripple).
    # gsd = the grain size distribution x axis numbers
    # mask = the column mask to use for the plot
    # filename = the filename for the output png (optional)
    # pismo_treatment = the special boolean to deal with pismo
    # log2_gsd = boolean to control whether or not to plot gsd as log2(gsd)
    # logaxes = use log axes
    
    ratio_color = 'forestgreen'

    input_dataframe [input_dataframe == 0.0] <- NA
    gsd[gsd == 0.0] <- NA
    
    if (log2_gsd) {
        gsd <- log2 (gsd)
        x_label <- 'log2 (grainsize) (log2 (mm))'
    } else {
        x_label <- 'grainsize (mm)'
    }
    
    if (!missing (filename)) {
        png (filename = filename)
    }
    
    # ensure we don't have any broken factors
    input_dataframe$dir_oneup_base <- as.character (input_dataframe$dir_oneup_base)
    input_dataframe$dir_base <- as.character (input_dataframe$dir_base)
    key$dir_base <- as.character (key$dir_base)
    
    # do the special treatment for pismo where the images are in directories named
    # by their image name (which doesn't correspond to site). The site corresponds
    # to the dir_oneup_base, which is the directory oneup
    if (pismo_treatment) {
        input_dataframe$dir_base <- input_dataframe$dir_oneup_base
    }
    
    # take means of all the stripes and ripples
    stripe_names <- key$dir_base [key$type == 's']
    ripple_names <- key$dir_base [key$type == 'r']
    
    # assemble the stripes
    cut_dataframe <- input_dataframe [1, ]          # make a base dataframe
    for (i in stripe_names) {
        new_dataframe <- input_dataframe [input_dataframe$dir_base == i, ]
        cut_dataframe <- rbind (cut_dataframe, new_dataframe)
    }
    
    cut_dataframe <- cut_dataframe [-1, ]   # get rid of the first column
    cut_dataframe <- cut_dataframe [, mask]
    stripes_0.1 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.1, na.rm = T)
    stripes_0.25 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.25, na.rm = T)
    stripes_0.5 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.5, na.rm = T)
    stripes_0.75 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.75, na.rm = T)
    stripes_0.9 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.9, na.rm = T)
    
    # assemble the ripples
    cut_dataframe <- input_dataframe [1, ]          # make a base dataframe
    for (i in ripple_names) {
        new_dataframe <- input_dataframe [input_dataframe$dir_base == i, ]
        cut_dataframe <- rbind (cut_dataframe, new_dataframe)
    }
    
    cut_dataframe <- cut_dataframe [-1, ]   # get rid of the first column
    cut_dataframe <- cut_dataframe [, mask]
    ripples_0.1 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.1, na.rm = T)
    ripples_0.25 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.25, na.rm = T)
    ripples_0.5 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.55, na.rm = T)
    ripples_0.75 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.75, na.rm = T)
    ripples_0.9 <- apply (X = cut_dataframe, MARGIN = 2, FUN = quantile, probs = 0.9, na.rm = T)
    
    # calculate the ratio of ripple to stripe for every quantile
    ratio_0.9 <- ripples_0.9 / stripes_0.9
    ratio_0.75 <- ripples_0.75 / stripes_0.75
    ratio_0.5 <- ripples_0.5 / stripes_0.5
    ratio_0.25 <- ripples_0.25 / stripes_0.25
    ratio_0.1 <- ripples_0.1 / stripes_0.1
    
    # find the maximum value
    max_ratio <- max (c(
        max (ratio_0.9, na.rm = T),
        max (ratio_0.75, na.rm = T),
        max (ratio_0.5, na.rm = T),
        max (ratio_0.25, na.rm = T),
        max (ratio_0.1, na.rm = T)
    ), na.rm = T)
    
    # setup the plots
    if (logaxes) {
        plot (gsd, ratio_0.5, col = 'red', cex = 0.0, ylim = c(1e-5, max_ratio), 
              xlab = x_label, ylab = 'ripples / stripes', log = 'xy')
    } else {
        plot (gsd, ratio_0.5, col = 'red', cex = 0.0, ylim = c(1e-5, max_ratio), 
              xlab = x_label, ylab = 'ripples / stripes')
    }
    
    # add a grey line at 0
    abline (h = 1, col = 'grey')
    
    # add the lines
    #lines (gsd, ratio_0.9, col = ratio_color, lty = 3)
    lines (gsd, ratio_0.75, col = ratio_color, lty = 3)
    lines (gsd, ratio_0.5, col = ratio_color, lwd = 1)
    lines (gsd, ratio_0.25, col = ratio_color, lty = 5)
    #lines (gsd, ratio_0.1, col = ratio_color, lty = 3)

    # add a legend, showing the quantiles
    legend (x = 0, y = max_ratio, 
            legend = c('75%', '50%', '25%'),
            col = c(ratio_color, ratio_color, ratio_color),
            lty = c(3, 1, 5),
            bty = 'n')
    
    if (!missing(filename)) {
        dev.off ()
    }    
}


