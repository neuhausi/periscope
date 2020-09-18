library(ggplot2)
library(lattice)


# -- data for plots
data(mtcars)
mtcars$cyl <- factor(mtcars$cyl, levels = c(4,6,8),
                     labels = c("4cyl", "6cyl", "8cyl"))
attr(mtcars, "show_rownames") <- TRUE


# -- plotting functions

plot2ggplot <- function() {
    plot <- ggplot(data = mtcars, aes(x = wt, y = mpg)) +
        geom_point(aes(color = cyl)) +
        theme(legend.justification = c(1, 1),
              legend.position = c(1, 1),
              legend.title = element_blank()) +
        ggtitle("GGPlot Example w/Hover") +
        xlab("wt") +
        ylab("mpg")
    return(plot)
}


plot2ggplot_data <- function() {
    return(mtcars)
}


plot3lattice <- function() {
    plot <- xyplot(mpg ~ wt , data = mtcars,
                   pch = 1, groups = factor(cyl),
                   auto.key = list(corner = c(1, 1)),
                   main = "Lattice Example")
    return(plot)
}

plot3lattice_data <- function() {
    return(mtcars)
}


plot_htmlwidget <- function(report_modus = FALSE) {
    venn <- data.frame(A   = 57,   B = 12, C   = 67, D   = 72, AB   = 4,
                       AC  = 67,  AD = 25, BC  = 67, BD  = 27, CD   = 38,
                       ABC = 69, ABD = 28, ACD = 52, BCD = 46, ABCD = 3)

    htmlwidget <- canvasXpress(vennData = venn,
                               graphType = 'Venn',
                               vennGroups = 4,
                               vennLegend = list(A = "List1", B = "List2", C = "List3", D = "List4"),
                               title = "CanvasXpress Example",
                               disableToolbar = report_modus,
                               disableTouchToolbar = report_modus)
    return(htmlwidget)
}
