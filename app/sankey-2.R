##
## Sunkey Diagram Representation 
## By ..., Emanuele Cordano, ... (aggiungere  altri autori) 
## Date: 2017-09-23
##


library(networkD3)
library(dplyr)
library(reshape2)
#library(xlsx)
# library(sqldf)


rm(list=ls())
load_data <- function() {
	load("data/data_reshape.Rdata")
	datafin
}
filter_period <- function(df, anno, tipo) {
	data_comune <- df
	data_comune[data_comune$anno == anno & data_comune$tipo == tipo & data_comune$rendiconto!=0,]
}
## DA AGGIUNGERE LE DESCRIZIONI
add_unique_level <- function(df, parent, colnodes) {
	data_comune_this_ <- df
	data_comune_this <- data_comune_this_[,c(colnodes,"rendiconto")]
	## LIVELLO ZERO
	data_comune_this$parent <- parent
	it__ <- "parent"
	for (i in 1:length(colnodes)) {
		
		it <- colnodes[i]
		it_ <- paste(it,"resh",sep="_")
		data_comune_this[,it_] <- paste(data_comune_this[,it__], data_comune_this[,it], sep=".") 
		it__ <- it_
		
	}
	data_comune_this
}
#data_comune_this$livello0_resh <- as.character(data_comune_this$livello0)
#data_comune_this$livello1_resh <- paste(data_comune_this$livello0_resh, data_comune_this$livello1, sep=".")
#data_comune_this$livello2_resh <- paste(data_comune_this$livello1_resh, data_comune_this$livello2, sep=".")
#data_comune_this$livello3_resh <- paste(data_comune_this$livello2_resh, data_comune_this$livello3, sep=".")
#data_comune_this$livello4_resh <- paste(data_comune_this$livello3_resh, data_comune_this$livello4, sep=".")
#data_comune_this$cdc_resh <- paste(data_comune_this$livello4_resh, data_comune_this$cdc, sep=".")


values_get <- function(df) {
	data_comune_this <- df
	rendiconto <- data_comune_this$rendiconto
	names(rendiconto) <- data_comune_this$cdc_resh
	values <- rendiconto
	values
}

options(max.print = 100)

edges_get <- function(df, lnc, colnodes_resh, values) {
	data_comune_this <- df
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
		temp$level <- i
		
		if (!is.null(values)) temp$value <- as.numeric(values[temp$target])
		
		values <- tapply(X=temp$value,FUN=sum,INDEX=temp$source,simplify=TRUE)
		
		
		links <- rbind(temp,links)  
	}
	list(	links = links, values = values)
}
edges_get_2 <- function(df, lnc) {
	data_comune_this <- df
	links <- NULL ## accumulator
	for (i in rev(1:lnc)) {
		
		extract_ <- function() {
			## seleziona i livelli consecutivi
			icol <- colnodes_resh[c(i,i+1)]       # nomi delle colonne
			## le prende con la colonna rendiconto
			temp <- data_comune_this[,c(icol,"rendiconto")]
			## set names expected by sankey
			names(temp) <- c("source","target","value")
			# 
			## remove duplicated
			ic <- duplicated(temp$target)
			temp$ic <- ic
			temp <- temp[which(!ic),]
			temp$level <- i
			temp
		}
		temp <-extract_()
		
		if (!is.null(values)) temp$value <- as.numeric(values[temp$target])
		
		values <- tapply(X=temp$value,FUN=sum,INDEX=temp$source,simplify=TRUE)
		
		
		links <- rbind(temp,links)  
	}
	list(	links = links, values = values)
}
data_max_level_filter <- function(links, max_level) {
	links <- links[links$level<=max_level,]
	links
}
nodes_id_get <- function(df) {
	links <- df
	id_nodes <- unique(c(links$source[links$level==1],links$target))
	id_nodes <- sort(id_nodes)  
	###  sort(unique(c(links$source,links$target)))
	nodes <- 1:length(id_nodes)-1
	names(nodes) <- id_nodes
	nodes
}
full_df_get <- function(df, colnodes_pre, colnodes_resh) {
	data_comune <- df
	temp <- data_comune
	for (i in 2:length(colnodes_pre)){
		temp <-
			temp %>%
			mutate( parent = 1) %>%
			unite(col = !!colnodes_resh[i], !!colnodes_pre[1:i],sep = ".",remove = F)
	}
	temp %>% select(ends_with("_resh"))
	temp
	
} 
df2dict <- function(df, key, value) {
	dict <- df[[value]]
	names(dict) <- df[[key]]
	dict
}
label_dict_get <- function(df, level, level_name, colnodes_resh, colnodes_pre) {
	temp <- df
	col_resh <- colnodes_resh[2]
	col_pre  <- paste0("ds_", colnodes_pre[2])
	temp %>%
		select(!!col_resh, !!col_pre) %>%
		distinct(missione_resh, ds_missione)
}

# exe ---------------------------------------------------------------------

data_comune <- load_data()
anno <- 2013
tipo <- "USCITE"
semi_sanky <- function(df, anno, tipo) {
	data_comune <- df
	data_comune_this_  <- filter_period(data_comune, anno, tipo)
	## LIVELLI DI COSTI (TIPO ENTRATE)
	colnodes <- c("missione","programma",sprintf("livello%d",1:4),"cdc")
	data_comune_this <- add_unique_level(data_comune_this_, parent = 1, colnodes)
	colnodes_resh <- c("parent",paste(colnodes,"resh",sep="_"))
	lnc <- length(colnodes_resh)-1
	values <- values_get(data_comune_this)
	links <- edges_get(data_comune_this, lnc, colnodes_resh, values)$links
	links
	# stopifnot( links  == edges_get_2(data_comune_this)$links )
	links <- data_max_level_filter(links, max_level = 1)
	
	nodes <- nodes_id_get(links)
	# label -------------------------------------------------------------------
	c(colnodes,"rendiconto")
	colnodes
	colnodes_pre = c("parent", colnodes)
	colnodes_resh
	full_df <- full_df_get(data_comune, colnodes_pre, colnodes_resh)
	
	nodes_labels <- 
		label_dict_get(full_df, 1, "1.1", colnodes_resh, colnodes_pre)  %>%
		df2dict("missione_resh", "ds_missione")
	nodes_df_1 <-	label_dict_get(full_df, 1, "1.1", colnodes_resh, colnodes_pre) 
	nodes_df_2 <- data.frame(name=names(nodes),ID=nodes,stringsAsFactors=FALSE)
	df_nodes <- nodes_df_2 %>%
		left_join(nodes_df_1,by = c(name = "missione_resh")) %>%
		mutate(name = ds_missione) %>%
		select(- ds_missione)
	
	
	
	subst_id_to_names <- function(links, nodes) {
		links$source <- nodes[links$source]
		links$target <- nodes[links$target]
		links
	}
	links_wId <- subst_id_to_names(links, nodes)

	sankey = list(
		links_wId = links_wId,
		df_nodes  = df_nodes
	)	
}
sank1 <- semi_sanky(data_comune, anno = anno, tipo = tipo)
# sank2 <- semi_sanky(data_comune, anno = anno, tipo = "USCITE")
	ss <- sankeyNetwork(Links = sank1$links_wId, Nodes = sank1$df_nodes, Source = 'source',
										Target = 'target', Value = 'value',NodeID = 'name',	
										units = 'euro', fontSize = 10, nodeWidth = 10)
ss

