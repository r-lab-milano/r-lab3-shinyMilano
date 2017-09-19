library(tidyverse)

#Carico dataset
load("app/data/data_reshape.Rdata")

SpeseMilanoTimeSeries <- datafin %>% filter(tipo == "USCITE") %>% 
	filter(ds_livello1 == "SPESE CORRENTI" | 
				 	ds_livello1 == "SPESE IN CONTO CAPITALE") %>%
	mutate(spesa = rendiconto+stanziamento) %>%
	group_by(anno, ds_livello1, ds_programma) %>%
	mutate(Total = sum(spesa)) %>%
	select(anno, ds_livello1, ds_programma, Total) %>%
	unique() %>% ungroup()

TimeSeries1PossibleValues <- SpeseMilanoTimeSeries %>% select(ds_programma) %>% unique()

TimeSeries_Programma <- function(nome_programma) {
	ggplot(data = SpeseMilanoTimeSeries %>% 
				 	filter(ds_programma == nome_programma), 
				 aes(x = anno, y = Total, col = ds_livello1)) +
		geom_line(size = 2) +
		geom_point(size = 3) +
		geom_vline(xintercept = 2016.5, colour = "darkgrey", linetype = 2) +
		ggtitle(nome_programma) +
		labs(x="anno") + 
		theme(legend.position = "bottom") 
}

TimeSeries_Programma2("ORGANI ISTITUZIONALI")
