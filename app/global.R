library("shiny")
library("shinydashboard")
library("tidyverse")

df <- read_csv("app/PEG_2017_2019_opendata_16_05_anni2013_2019.csv")

tipo <- unique(df$TIPO)
pdc_descrizione_misione <- unique(df$`PDC-Descrizione Missione`)
pdc_descrizione_programma <- unique(df$`PDC-Descrizione Programma`)

