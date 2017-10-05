

dataTop <- function(topTipo, topAnno, topN){
	datafin %>% select(ds_centro_resp, tipo, anno, rendiconto_1000) %>% 	
		filter(tipo == topTipo, anno == topAnno) %>%
		group_by(ds_centro_resp) %>%
		summarize(valore = sum(rendiconto_1000)) %>%
		arrange(desc(valore)) %>%
		# rename("Centro di responsabilità" = ds_centro_resp,
		# 			 "Valore (in migliaia di euro)" = valore) %>%
		head(n=topN)	
}

dt <- dataTop("USCITE", 2016, 10)


## plot
ggplot(data = dt,
			 aes(x = reorder(ds_centro_resp, -valore),
			 		valore, fill = reorder(ds_centro_resp, -valore))) +
	geom_bar(stat = "identity") +
	guides(fill=guide_legend(title="Centro di responsabilità")) +
	ylab("Valore (in migliaia di euro)") +
	theme(axis.title.x=element_blank(),
				axis.text.x=element_blank(),
				axis.ticks.x=element_blank())


# histPlot <- 

# dataTop(10)