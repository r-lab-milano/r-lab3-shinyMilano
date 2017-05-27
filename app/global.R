library("shiny")
library("shinydashboard")
library("stringr")
library("tidyverse")
library("wordcloud2")
library("tidytext")
library("readxl")
library("scales")
library("dplyr")
library("tidyr")
library("stringr")
library("ggplot2")
source("renderSelect.R")
source("words.R")
source("Proportions.R")


#load("../data/data_reshape.Rdata")

#df <- as_tibble(datafin)
#tipo <- unique(df$tipo)

df <- read_csv("../data/PEG_2017_2019_opendata_16_05_anni2013_2019.csv")


