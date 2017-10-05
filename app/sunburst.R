# Sunburst dataset
data_sun <- datafin %>%
	mutate(grouping = 
				 	as.factor(paste0(ds_livello1, "-", ds_livello2, "-", ds_livello3, "-", ds_livello4))) %>%
	select(tipo, grouping, rendiconto, year = anno)

# Sunburst function
printSun <- function(input_year, input_tipo){
	sunburst(data_sun %>% filter(year == input_year, tipo == input_tipo) %>%
					 	select(grouping, rendiconto, year))
}

# printSun(2013)