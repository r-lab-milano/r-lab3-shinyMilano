library("shiny")
library("shinydashboard")
library("stringr")
library("tidytext")
library("tidyverse")
library("wordcloud2")



source("time_series_1.R")
# source("renderSelect.R")
source("words.R")
source("structure_plot.R")


df <- read_delim("../data/data_reshape.csv", ";", escape_double = FALSE, 
								 col_types = cols(stanziamento = col_number(),
								 								 stanziamento_cassa = col_number()),
                 trim_ws = TRUE)

tipo <- unique(df$tipo)
