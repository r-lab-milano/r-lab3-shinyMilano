library("shiny")
library("shinydashboard")
library("stringr")
library("tidyverse")

source("renderSelect.R")

load("../data/data_reshape.Rdata")

df <- as_tibble(datafin)
tipo <- unique(df$tipo)


