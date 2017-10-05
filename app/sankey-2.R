##
## Sunkey Diagram Representation 
## By ..., Emanuele Cordano, ... (aggiungere  altri autori) 
## Date: 2017-09-23
##

rm(list=ls())

library(networkD3)
library(dplyr)
library(reshape2)
#library(xlsx)
# library(sqldf)

anno <- 2013
tipo <- "USCITE"

load_data <- function() {
	load("data/data_reshape.Rdata")
	datafin
}
data_comune <- load_data()
filter_period <- function(df, anno, tipo) {
	data_comune <- df
	data_comune[data_comune$anno == anno & data_comune$tipo == tipo & data_comune$rendiconto!=0,]
}
data_comune_this_  <- filter_period(data_comune, anno, tipo)

## LIVELLI DI COSTI (TIPO ENTRATE)

colnodes <- c("missione","programma",sprintf("livello%d",1:4),"cdc")

## DA AGGIUNGERE LE DESCRIZIONI
add_unique_level <- function(df) {
	data_comune_this_ <- df
	data_comune_this <- data_comune_this_[,c(colnodes,"rendiconto")]
	## LIVELLO ZERO
	data_comune_this$parent <- 1
	it__ <- "parent"
	for (i in 1:length(colnodes)) {
		
		it <- colnodes[i]
		it_ <- paste(it,"resh",sep="_")
		data_comune_this[,it_] <- paste(data_comune_this[,it__], data_comune_this[,it], sep=".") 
		it__ <- it_
		
	}
	data_comune_this
}
data_comune_this <- add_unique_level(data_comune_this_)
#data_comune_this$livello0_resh <- as.character(data_comune_this$livello0)
#data_comune_this$livello1_resh <- paste(data_comune_this$livello0_resh, data_comune_this$livello1, sep=".")
#data_comune_this$livello2_resh <- paste(data_comune_this$livello1_resh, data_comune_this$livello2, sep=".")
#data_comune_this$livello3_resh <- paste(data_comune_this$livello2_resh, data_comune_this$livello3, sep=".")
#data_comune_this$livello4_resh <- paste(data_comune_this$livello3_resh, data_comune_this$livello4, sep=".")
#data_comune_this$cdc_resh <- paste(data_comune_this$livello4_resh, data_comune_this$cdc, sep=".")

colnodes_resh <- c("parent",paste(colnodes,"resh",sep="_"))

lnc <- length(colnodes_resh)-1


rendiconto <- data_comune_this$rendiconto
names(rendiconto) <- data_comune_this$cdc_resh
values <- rendiconto
options(max.print = 100)

edges_get <- function(variables) {
	links <- NULL ## accumulator
	for (i in rev(1:lnc)) {
		
		## seleziona i livelli consecutivi
		icol <- colnodes_resh[c(i,i+1)]
		## le prende con la colonna rendiconto
		temp <- data_comune_this[,c(icol,"rendiconto")]
		## set names expected by sankey
		names(temp) <- c("source","target","value")
		
		## remove duplicated
		ic <- duplicated(temp$target)
		temp$ic <- ic 
		temp <- temp[which(!ic),]
		temp$level <- i+1-1
		
		if (!is.null(values)) temp$value <- as.numeric(values[temp$target])
		
		values <- tapply(X=temp$value,FUN=sum,INDEX=temp$source,simplify=TRUE)
		
		
		links <- rbind(temp,links)  
	}
	links
}
links <- edges_get()

max_level <- 2 ## massimo livello rappresentato , va sommato +1 !!! 
links <- links[links$level<=max_level,]

id_nodes <- unique(c(links$source[links$level==1],links$target))
id_nodes <- sort(id_nodes)  
###  sort(unique(c(links$source,links$target)))
nodes <- 1:length(id_nodes)-1
names(nodes) <- id_nodes

df_nodes <- data.frame(name=names(nodes),ID=nodes,stringsAsFactors=FALSE)

links$source <- nodes[links$source]
links$target <- nodes[links$target]


 ss <- sankeyNetwork(Links = links, Nodes = df_nodes, Source = 'source',
							Target = 'target', Value = 'value',NodeID = 'name',	units = 'euro', fontSize = 10, nodeWidth = 10)
ss
