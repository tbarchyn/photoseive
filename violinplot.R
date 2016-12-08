# violin plot
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

# simple violin plot base



violinplot <- function (psd, summary_results, samples, x_positions, colvector, yl_pass) {
    # this function creates violin plot for each wavelet density estimate
    # arguments:
    # psd is the psd list of data table
    # summary_results = the summary table which we can extract means, etc.
    # samples = a vector of the numeric samples for inclusion in the plot
    # x_positions = the positioning of the violins
    # colvector = the colour vector that is used to create colours
    
    violinspread <- 0.4     # spread of the violin edges
    plot_dimensions <- c((min(samples) - 1), (max(samples) + 1))
    
    if (missing(yl_pass)) {yl_pass <- c(0.3, 10)}
    tom.plots ( 1,1, log.y = T, cex = 0.0, col = 'blue', xl = plot_dimensions,
                yl = yl_pass, pin = c (150, 100), label.x = 'sample',
                label.y = 'grainsize (mm)', gridlines_maj.y = T, gridlines_min.y = T)
    
    # add the lines to the plot
    for (i in 1:length(samples)) {
        # pull and normalize the density pull to the violinspread
        density_pull <- psd[[ (samples[i]) ]]$density
        density_pull <- density_pull / max(density_pull)    # normalize
        density_pull <- density_pull * violinspread         # spread to violin spread
        
        # add the polygon
        polygon (c(x_positions[i] + density_pull, x_positions[i] - density_pull),
                 c( psd[[ (samples[i]) ]]$size, psd[[ (samples[i]) ]]$size),
                 col = colvector[i], border = F)
        
        # add the left outline line
        linepoints_x <- x_positions[i] + density_pull
        linepoints_y <- psd[[ (samples[i]) ]]$size
        lines (linepoints_x, linepoints_y, col = 'black', lwd = 1)
        
        # add the right outline line
        linepoints_x <- x_positions[i] - density_pull 
        linepoints_y <- psd[[ (samples[i]) ]]$size
        lines (linepoints_x, linepoints_y, col = 'black', lwd = 1)
        
        # add the points for mean values
        means_collection <- summary_results$mean_gs[ (summary_results$id == samples[1]) ]
        if (length(samples) > 1) {
            for (j in 2:length(samples)) {
                means_collection <- c(means_collection, 
                                      summary_results$mean_gs[ (summary_results$id == samples[j]) ] )
            }
        }
        points (samples, means_collection, col = 'black')
    }
}



