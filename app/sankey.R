library(networkD3)
library(dplyr)



data_comune <- read.xlsx("data comune.xlsx", 1)

data_comune <- data_comune %>% 
  select(TIPO, `PDC-Livello1`, `PDC-Livello2`, RENDICONTO.2016) %>% 
  filter(`PDC-Livello1` %in% c(1:6) & TIPO=="ENTRATE" | `PDC-Livello1` %in% c(1:4) & TIPO=="USCITE") %>% 
  mutate(Tipologia = ifelse(TIPO == "ENTRATE" & `PDC-Livello1` %in% c(1:3) | 
                              TIPO == "USCITE" & `PDC-Livello1` %in% c(1,4), "CORRENTE", "CAPITALE"), 
         TIPO_L1 = paste(TIPO, "L1", `PDC-Livello1`, sep="-"), 
         TIPO_L2 = paste(TIPO, "L2", `PDC-Livello2`, sep="-"))


head(data_comune)

data_comune2 <- as.data.frame(data_comune %>% group_by(TIPO_L2, TIPO_L1) %>% summarise(sum(RENDICONTO.2016)))
colnames(data_comune2) <- c("source", "target", "value")
data_comune3 <- as.data.frame(data_comune %>% group_by(TIPO_L1, Tipologia) %>% summarise(sum(RENDICONTO.2016)))
colnames(data_comune3) <- c("source", "target", "value")

head(data_comune2)
head(data_comune3)

Links <- rbind(data_comune2, data_comune3)

Nodes <- data.frame(name = c(unique(data_comune4$source), unique(data_comune3$target)))


sankeyNetwork(Links = Links, Nodes = Nodes, Source = "source", Target = "target", Value = "value", NodeID = "name")

plot(gvisSankey(Links, from='source', to='target', weight='value',
                options=list(height=1000, width=1000, sankey="{link:{color:{fill:'lightblue'}}}")))


#--- SANKEY

?sankeyNetwork

URL <- paste0('https://cdn.rawgit.com/christophergandrud/networkD3/',
              'master/JSONdata/energy.json')
energy <- jsonlite::fromJSON(URL)

# Plot
sankeyNetwork(Links = energy$links, Nodes = energy$nodes, Source = 'source',
              Target = 'target', Value = 'value', NodeID = 'name',
              units = 'TWh', fontSize = 12, nodeWidth = 30)




#--- LOAD 

load("data_reshape.Rdata")
require(dplyr)



datafin$sezione_bilancio <- 0
datafin$sezione_bilancio <- ifelse(
	(datafin$tipo=="ENTRATE" & datafin$livello1 %in% c(1,2,3)) | (datafin$tipo=="USCITE" & datafin$livello1 %in% c(1,4)),1,
	datafin$sezione_bilancio)
datafin$sezione_bilancio <- ifelse((datafin$tipo=="ENTRATE" & datafin$livello1 %in% c(4,5,6)) |
																	 	(datafin$tipo=="USCITE" & datafin$livello1 %in% c(2,3)),2,
																	 datafin$sezione_bilancio)
datafin$ds_sezione_bilancio <- ifelse(datafin$sezione_bilancio==1,"Bilancio corrente",
																			ifelse(datafin$sezione_bilancio==2,"Bilancio investimento",""))

UL1 <- datafin %>%
	filter(anno == "2016", sezione_bilancio!=0, tipo == "USCITE") %>%
	group_by(ds_sezione_bilancio, ds_livello1) %>%
	summarize(sum(rendiconto))

EL1 <- datafin %>%
	filter(anno == "2016", sezione_bilancio!=0, tipo == "ENTRATE") %>%
	group_by(ds_livello1, ds_sezione_bilancio) %>%
	summarize(sum(rendiconto))

L1 <- rbind(UL1, EL1) 
colnames(L1) <- c("source","target","value")


plot(gvisSankey(L1, from='source', to='target', weight='value',
								options=list(height=1000, width=1000, sankey="{link:{color:{fill:'lightblue'}}}")))

sankeyNetwork(Links = L1, Nodes = as.data.frame(unique(L1$source)), Source = 'source',
							Target = 'target', Value = 'value', NodeID = 'source', fontSize = 12, nodeWidth = 30)

URL <- paste0('https://cdn.rawgit.com/christophergandrud/networkD3/',
							'master/JSONdata/energy.json')
energy <- jsonlite::fromJSON(URL)
sankeyNetwork(Links = energy$links, Nodes = energy$nodes, Source = 'source',
							Target = 'target', Value = 'value', NodeID = 'name',
							LinkGroup = 'energy_type', NodeGroup = NULL)

