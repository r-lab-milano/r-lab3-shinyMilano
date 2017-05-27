library("shiny")
library("shinydashboard")
library("stringr")
library("tidyverse")
library("wordcloud2")

source("renderSelect.R")
source("words.R")

load("../data/data_reshape.Rdata")

df <- as_tibble(datafin)
tipo <- unique(df$tipo)


