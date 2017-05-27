library("shiny")
library("shinydashboard")
library("tidyverse")

load("../data/data_reshape.Rdata")

df <- as_tibble(datafin)

tipo <- unique(df$tipo)
pdc_descrizione_misione <- unique(df$ds_missione)
pdc_descrizione_programma <- unique(df$ds_programma)

