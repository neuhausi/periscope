library(dplyr)

df <- read.csv("program/data/example.csv",
               strip.white = T,
               comment.char = "#")


load_data1 <- function() {
    ldf <- df %>%
        filter(substr(Geographic.Area, 1, 1) == ".") %>%
        mutate(Geographic.Area = substring(Geographic.Area, 2))

    as.data.frame(ldf)
}


load_data2 <- function() {
    ldf <- df %>%
        filter(substr(Geographic.Area, 1, 1) != ".")

    as.data.frame(ldf)
}

load_data3 <- function() {
    ldf <- df %>%
        select(1:3)

    as.data.frame(ldf)
}
