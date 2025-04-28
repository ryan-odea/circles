#' Generate Points for Drawing Circles
#'
#' Creates points along the perimeter of a circle for plotting as a path.
#'
#' @param data A data frame containing circle data (centers and radii).
#' @param x_col Name of the column containing x-coordinates of circle centers.
#' @param y_col Name of the column containing y-coordinates of circle centers.
#' @param r_col Name of the column containing circle radii.
#' @param n_points Number of points to generate around each circle perimeter.
#' 
#' @importFrom data.table rbindlist
#'
#' @return A dataframe with x, y coordinates for plotting and group identifier per circle plotted.
#'
#' @export
draw_circles <- function(data, x_col = "x", y_col = "y", r_col = "r", n_points = 500) {

  missing <- setdiff(c(x_col, y_col, r_col), names(data))
  if (length(missing) > 0) {
    stop("Missing required column(s):", paste(missing, collapse = ", "))
  }
  
  theta <- seq(0, 2 * pi, length.out = n_points)
  result_list <- vector("list", nrow(data))
  
  for (i in 1:nrow(data)) {
    cx <- data[[x_col]][i]
    cy <- data[[y_col]][i]
    cr <- data[[r_col]][i]
    
    result_list[[i]] <- data.frame(
      x = cx + cr * cos(theta),
      y = cy + cr * sin(theta),
      group = i
    )
  }
  return(rbindlist(result_list))
}