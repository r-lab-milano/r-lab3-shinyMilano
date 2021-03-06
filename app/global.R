library("shiny")
library("shinydashboard")
library("stringr")
library("tidytext")
library("tidyverse")
library("wordcloud2")
library("sunburstR")
library("d3r")

df <- read_delim("./data/data_reshape.csv", ";", escape_double = FALSE,
								 col_types = cols(stanziamento = col_number(),
								 								 stanziamento_cassa = col_number()),
                 trim_ws = TRUE)

tipo <- unique(df$tipo)

load("./data/data_reshape.Rdata")

datafin <- datafin %>%
	mutate(rendiconto_1000 = round(rendiconto/1000),
				 stanziamento_1000 = round(stanziamento/1000))


source("structure_plot.R")
source("time_series.R")
source("time_series_test.R")
# source("time_series_2.R")
# source("renderSelect.R")
source("wordcloud.R")
source("toptable.R")
#source("top10.R")
source("sunburst.R")
source("sankey_2.R")

