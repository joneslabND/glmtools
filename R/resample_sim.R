#'@title get subset of time from a generic timeseries data.frame
#'@description 
#'resamples the input data.frame to only have rows corresponding to matches between 
#'df$DateTime and t_out. Both df$DateTime and t_out are of type POSIXct, and the 
#'precision of the match is passed in through the \code{precision} argument. 
#'\emph{The order of t_out}, not df$DateTime is retained.
#'
#'@param df a data.frame with DateTime and potentially other columns
#'@param t_out a vector of POSIXct dates (or character array that can be coerced into POSIXct) 
#'for matching to df$DateTime
#'@param method 'match' for exact match or 'interp' for temporal interpolation
#'@param precision matching precision (must be 'secs', 'mins','hours', or 'days')
#'@return a data.frame with DateTime other original columns, resampled according to t_out
#'@keywords methods
#'@seealso \link{get_temp}, \link{get_wind}, \link{get_surface_height}, \link{get_evaporation}, \link{get_ice}
#'@author
#'Jordan S. Read
#'@examples 
#'file <- system.file('extdata', 'output.nc', package = 'glmtools')
#'temp_surf <- get_temp(file, reference = 'surface', z_out = c(0,1,2))
#'t_out <- as.POSIXct(c("2011-04-01", "2011-06-14", "2011-04-05", "2011-07-28"))
#'temp_out <- resample_sim(df = temp_surf, t_out = t_out)
#'
#'t_out <- c("2011-04-01 10:00", "2011-04-05 08:15", 
#'       "2011-06-14 10:30", "2011-04-05 10:21", 
#'       "2011-07-28 10:00")
#'temp_out <- resample_sim(df = temp_surf, t_out = t_out, precision = 'days')
#'
#'temp_out <- resample_sim(df = temp_surf, t_out = t_out, method = 'interp', precision = 'hours')
#'@export
resample_sim <- function(df, t_out, method = 'match', precision = 'days'){
  
  if (length(unique(t_out)) != length(t_out)){stop('t_out values must be unique')}
  if (is.null(t_out)){
    return(df)
  } 
  
  t_out <- coerce_date(t_out)
  
  if (!(method %in% c("match", "interp"))){
    stop(paste0('method ', method, ' not currently supported'))
  }
  
  # wish this could be vectorized, but we need to retain the order of *t_out*, not df
  time <- time_precision(t_out, precision)
  
  if (method == 'interp'){
    
    df <- df_interp(df, time)
    time_compr <- df$DateTime
  } else {
    time_compr <- time_precision(df$DateTime, precision)
  }
  
  idx_out <- vector(length = length(time))
  for (j in 1:length(time)){
    m_i <- which(time[j] - time_compr == 0) #funny, match doesn't work (lt vs ct types)
    idx_out[j] = ifelse(length(m_i)==0,NA,m_i)
  }
  
  idx_out <- idx_out[!is.na(idx_out)]
  
  df_out <- df[idx_out, ]
  
  if (nrow(df_out) == 0){
    add_msg = ''
    if (method == 'match'){
      add_msg = ". Try method = 'interp'"
    }
    stop(paste0("no matches found using method = '",method,"' at ",precision,' precision',add_msg))
  }
  
  return(df_out)
  
}

