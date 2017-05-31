# 
# load("data/data_reshape.Rdata")
# 
# # To be added in a function in SE version
# datafin %>% select(ds_livello1, tipo,anno, rendiconto) %>%
# 	filter(tipo == "ENTRATE", anno == 2013) %>%
# 	arrange(desc(rendiconto)) %>%
# 	head(n=10)
# 
# 
# # Beginning, working
# top_n <- function(var){
# 	datafin %>% select_(var, "tipo", "anno", "rendiconto")
# }
# 
# top_n("ds_livello1")
# 
# 
# # Attempt, not working!
# top_n <- function(var, tipo_sel){
# 	datafin %>% select_(var, "tipo", "anno", "rendiconto") %>%
# 		filter_("tipo" == tipo_sel) %>%
# 		arrange_(desc("rendiconto")) #%>%
# 		#head(n=ntop)
# }
# 
# top_n("programma", quote("ENTRATE"))
# 
# 
# # Selectors, to be added in Shiny
# top10selectors <- c("ds_missione", "ds_programma", "ds_livello1", "ds_livello2", "ds_livello3", "ds_livello4",
# 											 "ds_cdc", "capitolo", "ds_capitolo_PEG", "ds_centro_resp", "ds_dir")