#' Generate Bubble Bath (Chart) Dataframe
#'
#' Creates a dataset of circles ("bubbles") with random centers and specified radii.
#' When overlap is FALSE, circles are placed so they do not overlap.
#'
#' @param frameSize A numeric vector of length 2 defining the frame's width and height (centered at 0).
#' @param circSize A numeric vector specifying the radii of circles to place.
#'        If length is 2, it's interpreted as min and max for a sequence.
#'        If length > 2, the exact values are used as radii.
#' @param maxCircsPerRad Maximum number of circles per radius.
#' @param max_iter Maximum attempts to place each circle.
#' @param density Density of circles, between 0 and 1.
#' @param overlap Logical; if FALSE, circles won't overlap.
#' @param suppressWarning Logical; if TRUE internal warnings are suppressed.
#'
#' @importFrom stats runif
#'
#' @return A data frame with columns x, y, and r (circle centers and radii).
#'
#' @examples
#' # Create bubble bath points
#' circles <- bubblebath(circSize = c(0.5, 1, 2, 3), overlap = FALSE)
#' @export
bubblebath <- function(frameSize = c(50, 50),
                       circSize = seq(0.2, 5, length.out = 25),
                       maxCircsPerRad = 1e4,
                       max_iter = 1e4,
                       density = 0.7,
                       overlap = FALSE,
                       suppressWarning = FALSE) {
  
  r <- sort(circSize, decreasing = TRUE)
  size <- length(circSize)
  circle_data <- data.frame(x = numeric(), y = numeric(), r = numeric())
  frameW <- frameSize[1] / 2
  frameH <- frameSize[2] / 2
  
  for (radius in r) {
    frame_area <- prod(frameSize)
    circle_area <- pi * radius^2
    approx_count <- ceiling((frame_area / size) / circle_area * density)
    n <- min(approx_count, maxCircsPerRad)
    

    new_circles <- data.frame(x = numeric(), y = numeric())
    attempts <- 0
    
    while (nrow(new_circles) < n && attempts < max_iter) {
      candidate_x <- runif(1, -frameW + radius, frameW - radius)
      candidate_y <- runif(1, -frameW + radius, frameW - radius)
      candidate_ok <- TRUE
      
      if (!overlap) {
        if (nrow(circle_data) > 0) {
          dists <- sqrt((candidate_x - circle_data$x)^2 +
                          (candidate_y - circle_data$y)^2)
          if (any(dists < (radius + circle_data$r))) candidate_ok <- FALSE
        }
        if (nrow(new_circles) > 0) {
          dists <- sqrt((candidate_x - new_circles$x)^2 +
                          (candidate_y - new_circles$y)^2)
          if (any(dists < (radius * 2))) candidate_ok <- FALSE
        }
      }
      
      if (candidate_ok) {
        new_circles <- rbind(new_circles, data.frame(x = candidate_x, y = candidate_y))
      }
      attempts <- attempts + 1
    }
    
    if (attempts >= max_iter && !suppressWarning) {
      warning(sprintf("Max iteration reached. Placed %d of %d circles for radius %.3f", 
                      nrow(new_circles), n, radius))
    }
    
    if (nrow(new_circles) > 0) {
      circle_data <- rbind(circle_data, cbind(new_circles, r = radius))
    }
  }
  
  return(circle_data)
}
