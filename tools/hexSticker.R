library(hexSticker)
library(circles)
library(ggplot2)

data <- draw_circles(bubblebath())
p <- ggplot(data = data, aes(x = x, y = y, group = group)) + 
  geom_path() + theme_void()

sticker(p, package = "circles",
        p_size = 0,
        filename = "../tools/hex.png",
        s_height = 3, s_width = 3,
        h_fill = "white", h_color = "black",
        dpi = 600)
