# library(tidyverse)

#Carico dataset
#load("app/data/data_reshape.Rdata")

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
	y_lim <- max(SpeseMilanoTimeSeries %>% 
							 	filter(ds_programma == nome_programma) %>% 
							 	select(Total)) + max(SpeseMilanoTimeSeries %>% 
							 											 	filter(ds_programma == nome_programma) %>% 
							 											 	select(Total))*0.05
	y_position <- max(SpeseMilanoTimeSeries %>% 
							 	filter(ds_programma == nome_programma) %>% 
							 	select(Total)) + max(SpeseMilanoTimeSeries %>% 
							 											 	filter(ds_programma == nome_programma) %>% 
							 											 	select(Total))*0.03
	
	ggplot(data = SpeseMilanoTimeSeries %>% 
				 	filter(ds_programma == nome_programma), 
				 aes(x = anno, y = Total, col = ds_livello1)) +
		theme_minimal()  +
		geom_line(size = 2) + geom_point(size = 2) +
		ylim(NA, y_lim) +
		labs(x = "anno", y = "importo") 	+
		guides(col = guide_legend(title = "Tipo di spesa"))+
		geom_vline(xintercept = 2016.5, colour = "darkgrey", linetype = 2) +
    annotate("text", x = 2017, y = y_position, label = "stanziamento",
						 fontface = "italic", size = 4)+
		annotate("text", x = 2016, y = y_position, label = "rendiconto",
						 fontface = "italic", size = 4) +
		ggtitle(paste(nome_programma, "(valori in migliaia di Euro)")) +
		theme(legend.position = "bottom", plot.title = element_text(size = 15, hjust = 0.5)) +
	scale_colour_manual(values = c("red2", "firebrick4"))
}




# TimeSeries_Programma("ORGANI ISTITUZIONALI")
