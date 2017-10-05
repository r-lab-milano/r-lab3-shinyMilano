
# SpeseMilanoTimeSeries <- datafin %>% filter(tipo == "USCITE") %>% 
# 	filter(ds_livello1 == "SPESE CORRENTI" | 
# 				 	ds_livello1 == "SPESE IN CONTO CAPITALE") %>%
# 	mutate(spesa = rendiconto+stanziamento) %>%
# 	group_by(anno, ds_livello1, ds_programma) %>%
# 	mutate(Total = sum(spesa)) %>%
# 	select(anno, ds_livello1, ds_programma, Total) %>%
# 	unique() %>% ungroup()


SpeseMilanoTimeSeriesLiv2 <- datafin %>% 
	filter(tipo == "USCITE") %>% 
	filter(ds_livello1 == "SPESE CORRENTI" | 
				 	ds_livello1 == "SPESE IN CONTO CAPITALE") %>%
	mutate(spesa = rendiconto+stanziamento) %>%
	group_by(anno, ds_livello2, ds_programma) %>%
	mutate(Total = sum(spesa)) %>%
	select(anno, ds_livello1, ds_livello2, ds_programma, Total) %>%
	unique() %>% ungroup() 

TimeSeries_Dettaglio <- function(nome_programma, spesa) {
	labels_mie <- SpeseMilanoTimeSeriesLiv2  %>% 
		filter(ds_programma == nome_programma & ds_livello1 == spesa) %>% 
		select(ds_livello2) %>% unique()
	ggplot() +
		geom_area(data = SpeseMilanoTimeSeriesLiv2 %>% 
								filter(ds_livello1 == spesa, ds_programma == nome_programma), 
							aes(x = anno, y = Total, fill = ds_livello2)) +
		theme_minimal() +
		geom_vline(xintercept = 2016.5, colour = "darkgrey", linetype = 2) +
		ggtitle(paste(nome_programma, "- Dettaglio spese correnti (valori in migliaia di Euro)")) +
		labs(x="anno", y = "importo") + 
		theme(legend.position = "bottom") +
		annotate("text", x = 2017.5, y = max(SpeseMilanoTimeSeries  %>% 
																				 	filter(ds_programma == nome_programma) %>% 
																				 	select(Total)), label = "stanziamento",
						 fontface = "italic", size = 4)+
		annotate("text", x = 2015.5, y = max(SpeseMilanoTimeSeries %>% 
																				 	filter(ds_programma == nome_programma) %>% 
																				 	select(Total)), label = "rendiconto",
						 fontface = "italic", size = 4) +
		scale_fill_discrete(name= "Dettaglio spesa", 
												labels = sapply(labels_mie, stringr::str_wrap, width = 30))
}

