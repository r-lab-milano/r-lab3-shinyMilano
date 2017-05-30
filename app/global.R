library("shiny")
library("shinydashboard")
library("stringr")
library("dplyr")
library("wordcloud2")
library("tidytext")
library("readr")
# library("scales")
# library("dplyr")
# library("tidyr")
# library("stringr")
library("ggplot2")

source("time_series_1.R")
# source("renderSelect.R")
source("words.R")
source("structure_plot.R")


# load("../data/data_reshape.Rdata")

#df <- as_tibble(datafin)

df <- read_delim("~/R/shinyMilano/data/data_reshape.csv",
                 ";", escape_double = FALSE, col_types = cols(stanziamento = col_number(),
                                                              stanziamento_cassa = col_number()),
                 trim_ws = TRUE)
tipo <- unique(df$tipo)

# tipo <- unique(df$TIPO)


