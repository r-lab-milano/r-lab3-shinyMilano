
################################################
######### DATA MANIPULATION ####################
################################################

# sistemo dati per mostrare dettaglio di livello2

SpeseMilanoTimeSeriesLiv2 <- datafin %>% 
	filter(tipo == "USCITE") %>% 
	filter(ds_livello1 == "SPESE CORRENTI" | 
				 	ds_livello1 == "SPESE IN CONTO CAPITALE") %>%
	mutate(spesa = rendiconto_1000+stanziamento_1000) %>%
	group_by(anno, ds_livello2, ds_programma) %>%
	mutate(Total = sum(spesa)) %>%
	select(anno, ds_livello1, ds_livello2, ds_programma, Total) %>%
	unique() %>% ungroup() 

# funzione che trova i migliori 5 e li divido da tutti gli altri
top_ones_against_others <- function(nome_programma, spesa, n = 5) {
	
	SpeseMilanoTimeSeriesLiv2_percentage <- SpeseMilanoTimeSeriesLiv2  %>% 
		filter(ds_programma == nome_programma & ds_livello1 == spesa) %>%
		group_by(anno) %>%
		mutate(percentage = Total/sum(Total)) %>%
		ungroup() %>%
		group_by(ds_livello2) %>%
		summarise(average_percentage = mean(percentage)) %>%
		arrange(desc(average_percentage))
	
	if(dim(SpeseMilanoTimeSeriesLiv2_percentage)[1] > n) { 
		
		SpeseMilanoTimeSeriesLiv2_tops <- SpeseMilanoTimeSeriesLiv2_percentage %>%
			slice(1:n) %>% select(ds_livello2)
		
		SpeseMilanoTimeSeriesLiv2_tops <- SpeseMilanoTimeSeriesLiv2_tops$ds_livello2
	
	SpeseMilanoTimeSeriesLiv2_worst <- SpeseMilanoTimeSeriesLiv2_percentage %>%
		slice((n+1):n()) %>% select(ds_livello2)
	
	SpeseMilanoTimeSeriesLiv2_worst <- 	SpeseMilanoTimeSeriesLiv2_worst$ds_livello2
	
	return(list(tops = SpeseMilanoTimeSeriesLiv2_tops, 
							worst = SpeseMilanoTimeSeriesLiv2_worst))
	}
	
	else {
		SpeseMilanoTimeSeriesLiv2_tops <- SpeseMilanoTimeSeriesLiv2_percentage$ds_livello2
		
		return(list(tops = SpeseMilanoTimeSeriesLiv2_tops,
								worst = NULL))
	}
}


# funzione che costruisce dataset su cui devo lavorare, con valori aggregati se ci sono troppe modalità

trova_dataset_finale <- function(nome_programma, spesa) {
	
	SpeseMilanoTimeSeriesLiv2_final_best <- SpeseMilanoTimeSeriesLiv2 %>% 
		filter(ds_programma == nome_programma & ds_livello1 == spesa) %>%
		filter(ds_livello2 %in% top_ones_against_others(nome_programma, spesa)$tops) %>%
		select(anno, ds_livello2, Total)
	
	if(length(top_ones_against_others(nome_programma, spesa)$worst > 0)) {
	
	SpeseMilanoTimeSeriesLiv2_final_worst <- SpeseMilanoTimeSeriesLiv2 %>% 
		filter(ds_programma == nome_programma & 
					 	ds_livello1 == spesa) %>%
		filter(ds_livello2 %in% 
					 	top_ones_against_others(nome_programma, spesa)$worst) %>%
		group_by(anno) %>%
		summarise(Total = sum(Total)) %>%
		mutate(ds_livello2 = "ALTRO") %>%
		select(anno, ds_livello2, Total)
	}
	
	else{
		SpeseMilanoTimeSeriesLiv2_final_worst <- NULL
	}
	
	SpeseMilanoTimeSeriesLiv2_final <- rbind(SpeseMilanoTimeSeriesLiv2_final_best, 
																					 SpeseMilanoTimeSeriesLiv2_final_worst)
	
	return(SpeseMilanoTimeSeriesLiv2_final)
}

##################################################
####### PLOT DA INSERIRE IN SHINY ################
##################################################

TimeSeries_Dettaglio <- function(nome_programma, spesa) {
	y_lim <- max(SpeseMilanoTimeSeries %>% 
							 	filter(ds_programma == nome_programma & ds_livello1 == spesa) %>% 
							 	select(Total)) + max(SpeseMilanoTimeSeries %>% 
							 											 	filter(ds_programma == nome_programma, ds_livello1 == spesa) %>% 
							 											 	select(Total))*0.05
	y_position <- max(SpeseMilanoTimeSeries %>% 
											filter(ds_programma == nome_programma, ds_livello1 == spesa) %>% 
											select(Total)) + max(SpeseMilanoTimeSeries %>% 
																					 	filter(ds_programma == nome_programma, ds_livello1 == spesa) %>% 
																					 	select(Total))*0.03
	
	if(length(top_ones_against_others(nome_programma, spesa)$worst)>0) {
		
		labels_legenda <- c(top_ones_against_others(nome_programma, spesa)$tops, "ALTRO")
	}
	
	if(length(top_ones_against_others(nome_programma, spesa)$worst) == 0) {
		
		labels_legenda <- c(top_ones_against_others(nome_programma, spesa)$tops)
	}

	ggplot() +
		geom_area(data = trova_dataset_finale(nome_programma, spesa), 
							aes(x = anno, y = Total, fill = ds_livello2)) +
		theme_minimal() +
		geom_vline(xintercept = 2016.5, colour = "darkgrey", linetype = 2) +
		ggtitle(paste("Dettaglio", spesa)) +
		labs(x="anno", y = "importo") + 
		ylim(NA, y_lim) +
		theme(legend.position = "bottom", plot.title = element_text(size = 12, hjust = 0.5)) +
		annotate("text", x = 2017.5, y = y_position, label = "stanziamento_1000",
						 fontface = "italic", size = 4)+
		annotate("text", x = 2015.5, y = y_position, label = "rendiconto_1000",
						 fontface = "italic", size = 4) +
		scale_fill_discrete(name= "Dettaglio spesa", 
												labels = sapply(labels_legenda, stringr::str_wrap, width = 20)) +
		guides(fill = guide_legend(nrow=2, byrow=TRUE))
}

