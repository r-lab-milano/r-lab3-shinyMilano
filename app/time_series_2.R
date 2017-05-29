###############################################################################
# Libraries
###############################################################################

library("tidyverse")
library("stringr")

###############################################################################
# Functions
###############################################################################

char_to_num <- function(col) {
  # Converts characters to numerical values after removeing commas
  as.numeric(gsub(",", "", col))
}


###############################################################################
# Load and clean data
###############################################################################

dati_bil <- read.csv(
  "../data/PEG_2017_2019_opendata_16_05_anni2013_2019.csv",
  header = TRUE,
  stringsAsFactors = FALSE
  )


names(dati_bil) <- names(dati_bil) %>% 
  gsub(".", "_", ., fixed = TRUE) %>% 
  tolower

dati_bil <- dati_bil %>% 
  mutate(
    rendiconto_2013   = char_to_num(rendiconto_2013),
    rendiconto_2014   = char_to_num(rendiconto_2014),
    rendiconto_2015   = char_to_num(rendiconto_2015),
    rendiconto_2016   = char_to_num(rendiconto_2016),
    stanziamento_2017 = char_to_num(stanziamento_2017),
    stanziamento_2018 = char_to_num(stanziamento_2018),
    stanziamento_2019 = char_to_num(stanziamento_2019),
    stanziamento_di_cassa_2017 = char_to_num(stanziamento_di_cassa_2017)
    )


# Rimuovo le seguenti voci:
#   - Entrate per conto terzi e partite di giro
#   - Spese per conto terzi e partite di giro
dati_bil <- dati_bil %>% 
  filter(
    !(tipo == "ENTRATE" & pdc_livello1 == 9),
    !(tipo == "USCITE"  & pdc_livello1 == 7)
    )

server <- function(input, output) {
  output$bar_plot <- renderPlot({
    dati_bil %>% 
      ggplot(aes(x = pdc_livello1, y = rendiconto_2013)) + 
        geom_bar(stat = "identity")
  })
}

# Dati da formato largo a formato lungo
dati_bil <- dati_bil %>%
	select(-stanziamento_di_cassa_2017) %>% 
	gather(anno, importo, rendiconto_2013:stanziamento_2019) %>%
	mutate(anno = as.numeric(str_sub(anno, -4, -1)))

plot_level_series <- function(descrizione, val) {
  
  filter_string <- paste0("pdc_livello", level, " == ", val)
  sub_level     <- paste0("pdc_descrizione_livello", level + 1) 
  fill_string   <- paste0("as.integer(", sub_level, ")")
  
  dati_bil %>%
    filter(pdc_descrizione_programma == descrizione) %>%
    group_by_("anno", sub_level) %>%
    summarise(importo = sum(importo) / 1e6) %>%
    ggplot(aes_string(x = "anno", y = "importo", fill = sub_level)) +
    geom_area() +
    xlab(" Anno") + 
    ylab("Importo (mln)") +
    theme(legend.text =element_text(size = 6))

}