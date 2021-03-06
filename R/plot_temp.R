#'@title plot water temperatures from a GLM simulation
#'@param file a string with the path to the netcdf output from GLM
#'@param reference a string for 'surface' or 'bottom'
#'@param num_cells number of vertical cells to use for heatmap
#'@param fig_path F if plot to screen, string path if save plot as .png
#'@param add F if create new figure, T if add to existing
#'@keywords methods
#'@seealso \link{get_temp}
#'@author
#'Jordan S. Read, Luke A. Winslow
#'@examples 
#'file <- system.file('extdata', 'output.nc', package = 'glmtools')
#'plot_temp(file = file, fig_path = FALSE)
#'plot_temp(file = file, fig_path = '../test_figure.png')
#'@export
plot_temp <- function(file, reference = 'surface', num_cells = 100, fig_path = F, add = F){

  plot_var(file, var_name = 'temp', col_lim = c(0,36), 
           reference, num_cells, fig_path, add, bar_title = 'Temperature (\u00B0C)')
  
}

colbar_layout <- function(nrow = 1){
  # ensures all colorbar plots use same x scaling for divs
  mx <- matrix(c(rep(1,5),2),nrow=1)
  panels <- mx
  if (nrow > 2){
    for (i in 2:nrow){
      panels <- rbind(panels,mx+(i-1)*2)
    }
  }
  
  layout(panels)
  
}

plot_layout <- function(xaxis, yaxis, add, data = NA){
  
  if (!add){
    panels <- colbar_layout()
  }
  
  
  plot(data, xlim = xaxis$lim,
       ylim=yaxis$lim,
       xlab=xaxis$x_lab, ylab=' ',
       frame=FALSE,axes=F,xaxs="i",yaxs="i")
  
  
}
