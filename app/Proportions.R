ristruttura <- function(dati_milano) {
	dati_long <- gather(dati_milano, anno, rendiconto, `RENDICONTO 2013`:`RENDICONTO 2016`)
	dati_long$anno <- as.numeric(str_replace(dati_long$anno,"RENDICONTO ",""))
	return(dati_long)
}

compute_proportions <- function(dati, group_var) {
	dati_plot <- dati %>% 
		#filter(TIPO==tipo_voce) %>% 
		group_by_("anno", group_var) %>% 
		summarise(totale=sum(rendiconto)) %>% 
		group_by(anno) %>% 
		mutate(totale_anno=sum(totale), 
					 prop_cat_anno=totale/totale_anno)
	return(dati_plot)
}

compute_proportions_all <- function(dati, group_var) {
	dati_plot <- dati %>% 
		#filter(TIPO==tipo_voce) %>% 
		group_by_(group_var) %>% 
		summarise(totale=sum(rendiconto)) %>% 
		mutate(prop_totale=totale/sum(totale))
	return(dati_plot)
}

plot_proportions <- function(dati, group_var) {
	ggplot(dati) +
		aes_string(x="anno", y="prop_cat_anno", fill=group_var) +
		geom_bar(stat="identity")+ 
		ylab("") +
		scale_y_continuous(labels = percent_format()) +
		ggtitle(str_c("Proporzione in base al ", group_var , " (2013-2016)", sep=" ")) +
		theme(plot.title=element_text(size = 11, face="bold", hjust = 0.5))
}

plot_final_per_year <- function(dati, group_var){
	dati_ristrutturati <- ristruttura(dati)
	proporzioni <- compute_proportions(dati_ristrutturati, group_var)
	plot_proportions(proporzioni, group_var)
}

plot_proportions_all <- function(dati, group_var) {
	ggplot(dati) +
		aes_string(x=factor(1), y="prop_totale", fill=group_var) +
		geom_bar(stat="identity", width=1)+ 
		ylab("") +
		scale_y_continuous(labels = percent_format()) +
		ggtitle(str_c("Proporzione in base al ", group_var , sep=" ")) +
		theme(plot.title=element_text(size = 11, face="bold", hjust = 0.5)) +
		theme_bw() +
		theme(axis.text.y = element_blank(),
					axis.text.x = element_blank(),
					axis.title  = element_blank(),
					axis.ticks = element_blank(),
					plot.title=element_text(size = 11, face="bold", hjust=0.5),
					panel.grid.major.x = element_blank(),
					panel.grid.major.y = element_blank(),
					panel.border = element_blank()) + 
		coord_polar("y") +
		guides(fill=FALSE)
}

plot_final_all <- function(dati, group_var){
	dati_ristrutturati <- ristruttura(dati)
	proporzioni <- compute_proportions_all(dati_ristrutturati, group_var)
	plot_proportions_all(proporzioni, group_var)
}
