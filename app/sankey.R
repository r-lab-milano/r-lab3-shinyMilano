library(networkD3)
library(dplyr)
library(xlsx)
# library(sqldf)

anno <- 2013
tipo <- "USCITE"

load("~/GIT/r-lab3-shinyMilano/data_reshape.Rdata")
data_comune <- datafin

data_comune_this  <- data_comune[data_comune$anno == anno & data_comune$tipo == tipo,]

data_comune_this$livello2_resh <- paste(data_comune_this$livello1, data_comune_this$livello2, sep=".")
data_comune_this$livello3_resh <- paste(data_comune_this$livello2_resh, data_comune_this$livello3, sep=".")
data_comune_this$livello4_resh <- paste(data_comune_this$livello3_resh, data_comune_this$livello4, sep=".")

data_comune_this_resh <- data.frame(Source = 0, Target = 0, Value = 0)
# data_comune_this_resh <- data_comune_this_resh[-1,]

row=0
for (i in unique(data_comune_this$livello2_resh)) {
	row <- row +1
	data_comune_this_this <- data_comune_this[data_comune_this$livello2_resh == i,]
	data_comune_this_resh[row,"Source"] <- data_comune_this_this$livello1[1]
	data_comune_this_resh[row,"Target"] <- data_comune_this_this$livello2_resh[1]
	data_comune_this_resh[row,"Value"] <- sum(data_comune_this_this$rendiconto)
}

# for (i in unique(data_comune_this$livello3_resh)) {
# 	row <- row +1
# 	data_comune_this_this <- data_comune_this[data_comune_this$livello3_resh == i,]
# 	data_comune_this_resh[row,"Source"] <- data_comune_this_this$livello2_resh[1]
# 	data_comune_this_resh[row,"Target"] <- data_comune_this_this$livello3_resh[1]
# 	data_comune_this_resh[row,"Value"] <- sum(data_comune_this_this$rendiconto)
# }

# for (i in unique(data_comune_this$livello4_resh)) {
# 	row <- row +1
# 	data_comune_this_this <- data_comune_this[data_comune_this$livello4_resh == i,]
# 	data_comune_this_resh[row,"Source"] <- data_comune_this_this$livello3_resh[1]
# 	data_comune_this_resh[row,"Target"] <- data_comune_this_this$livello4_resh[1]
# 	data_comune_this_resh[row,"Value"] <- sum(data_comune_this_this$rendiconto)
# }

data_comune_nodes_name <- as.data.frame(unique(rbind(cbind(data_comune_this$livello1, data_comune_this$ds_livello1),
																										 cbind(data_comune_this$livello2_resh, data_comune_this$ds_livello2),
																										 cbind(data_comune_this$livello3_resh, data_comune_this$ds_livello3),
																										 cbind(data_comune_this$livello4_resh, data_comune_this$ds_livello4))))

names_to_include <- unique(c(data_comune_this_resh$Source, data_comune_this_resh$Target))

data_comune_nodes_name <- data_comune_nodes_name[data_comune_nodes_name$V1 %in% names_to_include,]

data_comune_nodes_name[,"ID"] <- 1:nrow(data_comune_nodes_name) -1 

for (i in unique(data_comune_nodes_name$V1)) {
	data_comune_this_resh[data_comune_this_resh$Source == i,"Source_new"] <- data_comune_nodes_name$ID[data_comune_nodes_name$V1 == i]
	data_comune_this_resh[data_comune_this_resh$Target == i,"Target_new"] <- data_comune_nodes_name$ID[data_comune_nodes_name$V1 == i]
}



# nnodes <- data_comune_nodes_name$ID
# names(nnodes) <- data_comune_nodes_name$V1
# 
# data_comune_this_resh$Source <- nnodes[data_comune_this_resh$Source]
# data_comune_this_resh$Target <- nnodes[data_comune_this_resh$Target]
# 
names(data_comune_nodes_name)[2] <- "name"

sankeyNetwork(Links = data_comune_this_resh, Nodes = data_comune_nodes_name, Source = 'Source_new',
							Target = 'Target_new', Value = 'Value', NodeID = "name",
							units = 'TWh', fontSize = 12, nodeWidth = 30)


################################## OLD VERSION

# library(networkD3)
# library(dplyr)
# 
# 
# 
# data_comune <- read.xlsx("data comune.xlsx", 1)
# 
# data_comune <- data_comune %>% 
#   select(TIPO, `PDC-Livello1`, `PDC-Livello2`, RENDICONTO.2016) %>% 
#   filter(`PDC-Livello1` %in% c(1:6) & TIPO=="ENTRATE" | `PDC-Livello1` %in% c(1:4) & TIPO=="USCITE") %>% 
#   mutate(Tipologia = ifelse(TIPO == "ENTRATE" & `PDC-Livello1` %in% c(1:3) | 
#                               TIPO == "USCITE" & `PDC-Livello1` %in% c(1,4), "CORRENTE", "CAPITALE"), 
#          TIPO_L1 = paste(TIPO, "L1", `PDC-Livello1`, sep="-"), 
#          TIPO_L2 = paste(TIPO, "L2", `PDC-Livello2`, sep="-"))
# 
# 
# head(data_comune)
# 
# data_comune2 <- as.data.frame(data_comune %>% group_by(TIPO_L2, TIPO_L1) %>% summarise(sum(RENDICONTO.2016)))
# colnames(data_comune2) <- c("source", "target", "value")
# data_comune3 <- as.data.frame(data_comune %>% group_by(TIPO_L1, Tipologia) %>% summarise(sum(RENDICONTO.2016)))
# colnames(data_comune3) <- c("source", "target", "value")
# 
# head(data_comune2)
# head(data_comune3)
# 
# Links <- rbind(data_comune2, data_comune3)
# 
# Nodes <- data.frame(name = c(unique(data_comune4$source), unique(data_comune3$target)))
# 
# 
# sankeyNetwork(Links = Links, Nodes = Nodes, Source = "source", Target = "target", Value = "value", NodeID = "name")
# 
# plot(gvisSankey(Links, from='source', to='target', weight='value',
#                 options=list(height=1000, width=1000, sankey="{link:{color:{fill:'lightblue'}}}")))
# 
# 
# #--- SANKEY
# 
# ?sankeyNetwork
# 
# URL <- paste0('https://cdn.rawgit.com/christophergandrud/networkD3/',
#               'master/JSONdata/energy.json')
# energy <- jsonlite::fromJSON(URL)
# 
# # Plot
# sankeyNetwork(Links = energy$links, Nodes = energy$nodes, Source = 'source',
#               Target = 'target', Value = 'value', NodeID = 'name',
#               units = 'TWh', fontSize = 12, nodeWidth = 30)
# 
# 
# 
# 
# #--- LOAD 
# 
# load("data_reshape.Rdata")
# require(dplyr)
# 
# 
# 
# datafin$sezione_bilancio <- 0
# datafin$sezione_bilancio <- ifelse(
# 	(datafin$tipo=="ENTRATE" & datafin$livello1 %in% c(1,2,3)) | (datafin$tipo=="USCITE" & datafin$livello1 %in% c(1,4)),1,
# 	datafin$sezione_bilancio)
# datafin$sezione_bilancio <- ifelse((datafin$tipo=="ENTRATE" & datafin$livello1 %in% c(4,5,6)) |
# 																	 	(datafin$tipo=="USCITE" & datafin$livello1 %in% c(2,3)),2,
# 																	 datafin$sezione_bilancio)
# datafin$ds_sezione_bilancio <- ifelse(datafin$sezione_bilancio==1,"Bilancio corrente",
# 																			ifelse(datafin$sezione_bilancio==2,"Bilancio investimento",""))
# 
# UL1 <- datafin %>%
# 	filter(anno == "2016", sezione_bilancio!=0, tipo == "USCITE") %>%
# 	group_by(ds_sezione_bilancio, ds_livello1) %>%
# 	summarize(sum(rendiconto))
# 
# EL1 <- datafin %>%
# 	filter(anno == "2016", sezione_bilancio!=0, tipo == "ENTRATE") %>%
# 	group_by(ds_livello1, ds_sezione_bilancio) %>%
# 	summarize(sum(rendiconto))
# 
# L1 <- rbind(UL1, EL1) 
# colnames(L1) <- c("source","target","value")
# 
# 
# plot(gvisSankey(L1, from='source', to='target', weight='value',
# 								options=list(height=1000, width=1000, sankey="{link:{color:{fill:'lightblue'}}}")))
# 
# sankeyNetwork(Links = L1, Nodes = as.data.frame(unique(L1$source)), Source = 'source',
# 							Target = 'target', Value = 'value', NodeID = 'source', fontSize = 12, nodeWidth = 30)
# 
# URL <- paste0('https://cdn.rawgit.com/christophergandrud/networkD3/',
# 							'master/JSONdata/energy.json')
# energy <- jsonlite::fromJSON(URL)
# sankeyNetwork(Links = energy$links, Nodes = energy$nodes, Source = 'source',
# 							Target = 'target', Value = 'value', NodeID = 'name',
# 							LinkGroup = 'energy_type', NodeGroup = NULL)
# 
