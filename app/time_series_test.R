
SpeseMilanoTimeSeriesLiv2 <- datafin %>% 
	filter(tipo == "USCITE") %>% 
	filter(ds_livello1 == "SPESE CORRENTI" | 
				 	ds_livello1 == "SPESE IN CONTO CAPITALE") %>%
	mutate(spesa = rendiconto+stanziamento) %>%
	group_by(anno, ds_livello2, ds_programma) %>%
	mutate(Total = sum(spesa)) %>%
	select(anno, ds_livello1, ds_livello2, ds_programma, Total) %>%
	unique() %>% ungroup() 

top_ones_againts_others <- function(nome_programma, spesa, n = 5) {
	SpeseMilanoTimeSeriesLiv2_percentage <- SpeseMilanoTimeSeriesLiv2  %>% 
		filter(ds_programma == nome_programma & ds_livello1 == spesa) %>%
		group_by(anno) %>%
		mutate(percentage = Total/sum(Total)) %>%
		ungroup() %>%
		group_by(ds_livello2) %>%
		summarise(average_percentage = mean(percentage)) %>%
		arrange(desc(average_percentage))
	
	SpeseMilanoTimeSeriesLiv2_tops <- SpeseMilanoTimeSeriesLiv2_percentage %>%
		slice(1:n) %>% select(ds_livello2)
	SpeseMilanoTimeSeriesLiv2_tops <- SpeseMilanoTimeSeriesLiv2_tops$ds_livello2
	
	SpeseMilanoTimeSeriesLiv2_worst <- SpeseMilanoTimeSeriesLiv2_percentage %>%
		slice((n+1):n()) %>% select(ds_livello2)
	
	SpeseMilanoTimeSeriesLiv2_worst <- 	SpeseMilanoTimeSeriesLiv2_worst$ds_livello2
	
	return(list(SpeseMilanoTimeSeriesLiv2_tops, SpeseMilanoTimeSeriesLiv2_worst))
}

trova_dataset_finale <- function(nome_programma, spesa) {
	SpeseMilanoTimeSeriesLiv2_final_worst <- SpeseMilanoTimeSeriesLiv2 %>% 
		filter(ds_programma == nome_programma & ds_livello1 == spesa) %>%
		filter(ds_livello2 %in% top_ones_againts_others(nome_programma, spesa)[[2]]) %>%
		group_by(anno) %>%
		summarise(Total = sum(Total)) %>%
		mutate(ds_livello2 = "ALTRO") %>%
		select(anno, ds_livello2, Total)
	
	SpeseMilanoTimeSeriesLiv2_final_best <- SpeseMilanoTimeSeriesLiv2 %>% 
		filter(ds_programma == nome_programma & ds_livello1 == spesa) %>%
		filter(ds_livello2 %in% top_ones_againts_others(nome_programma, spesa)[[1]]) %>%
		select(anno, ds_livello2, Total)
	
	SpeseMilanoTimeSeriesLiv2_final <- rbind(SpeseMilanoTimeSeriesLiv2_final_best, 
																					 SpeseMilanoTimeSeriesLiv2_final_worst)
	
	return(SpeseMilanoTimeSeriesLiv2_final)
}


TimeSeries_Dettaglio <- function(nome_programma, spesa) {
	labels_legenda <- c(as.vector(top_ones_againts_others(nome_programma, spesa)[[1]]), "ALTRO")
	ggplot() +
		geom_area(data = trova_dataset_finale(nome_programma, spesa), 
							aes(x = anno, y = Total, fill = ds_livello2)) +
		theme_minimal() +
		geom_vline(xintercept = 2016.5, colour = "darkgrey", linetype = 2) +
		ggtitle(paste("Dettaglio", spesa)) +
		labs(x="anno", y = "importo") + 
		theme(legend.position = "bottom", plot.title = element_text(hjust = 0.5)) +
		annotate("text", x = 2017.5, y = max(trova_dataset_finale(nome_programma, spesa)  %>% 
																				 	select(Total)), label = "stanziamento",
						 fontface = "italic", size = 4)+
		annotate("text", x = 2015.5, y = max(trova_dataset_finale(nome_programma, spesa) %>% 
																				 	select(Total)), label = "rendiconto",
						 fontface = "italic", size = 4) +
		scale_fill_discrete(name= "Dettaglio spesa", 
												labels = sapply(labels_legenda, stringr::str_wrap, width = 30))
}

