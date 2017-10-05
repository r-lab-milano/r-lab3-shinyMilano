library("shiny")
library("shinydashboard")
library("stringr")
library("tidytext")
library("tidyverse")
library("wordcloud2")
library("sunburstR")
library("d3r")



source("time_series.R")
source("time_series_test.R")
# source("time_series_2.R")
# source("renderSelect.R")
source("wordcloud.R")
source("structure_plot.R")
#source("top10.R")


df <- read_delim("./data/data_reshape.csv", ";", escape_double = FALSE,
								 col_types = cols(stanziamento = col_number(),
								 								 stanziamento_cassa = col_number()),
								 trim_ws = TRUE)

tipo <- unique(df$tipo)

load("./data/data_reshape.Rdata")

data_sun <- data.frame(grouping = paste0(datafin$ds_livello1,"-",
																				 datafin$ds_livello2,"-",
																				 datafin$ds_livello3,"-",
																				 datafin$ds_livello4),
											 rendiconto = datafin$rendiconto,
											 year=datafin$anno)

