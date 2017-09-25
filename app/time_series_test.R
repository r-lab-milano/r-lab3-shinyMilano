	
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
	ggplot() +
		geom_area(data = SpeseMilanoTimeSeriesLiv2 %>% 
								filter(ds_livello1 == spesa, ds_programma == nome_programma), 
							aes(x = anno, y = Total, fill = ds_livello2)) +
		theme_minimal() +
		geom_vline(xintercept = 2016.5, colour = 1, linetype = 2) +
		ggtitle(paste(nome_programma, "- Dettaglio spese correnti")) +
		labs(x="anno", y = "importo") + 
		theme(legend.position = "bottom") +
		annotate("text", x = 2017.5, y = 1000000, label = "stanziamento")+
		annotate("text", x = 2015.5, y = 1000000, label = "rendiconto")
	}
	
# TimeSeries_Correnti <- function(nome_programma) {
# 	ggplot() +
# 		geom_area(data = tab_liv2 %>% 
# 								filter(ds_livello1 == "SPESE CORRENTI", ds_programma == nome_programma), 
# 							aes(x = anno, y = Total, fill = ds_livello2)) +
# 		theme_minimal() +
# 		geom_vline(xintercept = 2016.5, colour = 1, linetype = 2) +
# 		ggtitle(paste(nome_programma, "- Dettaglio spese correnti")) +
# 		labs(x="anno", y = "importo") + 
# 		theme(legend.position = "bottom") +
# 		annotate("text", x = 2017.5, y = 1000000, label = "stanziamento")+
# 		annotate("text", x = 2015.5, y = 1000000, label = "rendiconto")
# }

#TimeSeries_Correnti("ORGANI ISTITUZIONALI")


# 	
# 		ggplot(data = SpeseMilanoTimeSeries %>% 
# 				 	filter(ds_programma == nome_programma), 
# 				 aes(x = anno, y = Total, col = ds_livello1)) +
# 		theme_minimal() +
# 		geom_line(size = 2) +
# 		geom_point(size = 3) +
# 		geom_vline(xintercept = 2016.5, colour = "darkgrey", linetype = 2) +
# 		ggtitle(nome_programma) +
# 		labs(x="anno", y = "importo") + 
# 		theme(legend.position = "bottom") +
# 		annotate("text", x = 2017.5, y = Inf, label = "stanziamento")+
# 		annotate("text", x = 2015.5, y = Inf, label = "rendiconto") +
# 		scale_colour_manual(values = c("red2", "firebrick4"))
# }
# 
# TimeSeries_Programma("ORGANI ISTITUZIONALI")
# 
# 
# ggplot() +
# 	# geom_area(data = SpeseMilanoTimeSeriesLiv2 %>% 
# 	# 						filter(ds_livello1 == "SPESE CORRENTI", ds_programma == 'ORGANI ISTITUZIONALI'), 
# 	# 					aes(x = anno, y = Total),
# 	# 					fill = "lightgrey") +
# 	geom_area(data = tab_liv2 %>% 
# 							filter(ds_livello1 == "SPESE CORRENTI", ds_programma == 'ORGANI ISTITUZIONALI'
# 										 # ds_livello2 == "REDDITI DA LAVORO DIPENDENTE"
# 										 ), 
# 						aes(x = anno, y = Total, fill = ds_livello2)) +
# 	theme_minimal()
# 	
# 
# 
# #TimeSeries1PossibleValues <- SpeseMilanoTimeSeries %>% select(ds_programma) %>% unique()
# 
