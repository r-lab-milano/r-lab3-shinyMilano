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

###load("~/GIT/r-lab3-shinyMilano/data_reshape.Rdata")
load("~/local/rlab-milano/r-lab3-shinyMilano/data_reshape.Rdata")
data_comune <- datafin

data_comune_this_  <- data_comune[data_comune$anno == anno & data_comune$tipo == tipo & data_comune$rendiconto!=0,]
###data_comune_this_$livello0 <- 1 

## LIVELLI DI COSTI (TIPO ENTRATE)

colnodes <- c("missione","programma",sprintf("livello%d",1:4),"cdc")

## DA AGGIUNGERE LE DESCRIZIONI

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


#data_comune_this$livello0_resh <- as.character(data_comune_this$livello0)
#data_comune_this$livello1_resh <- paste(data_comune_this$livello0_resh, data_comune_this$livello1, sep=".")
#data_comune_this$livello2_resh <- paste(data_comune_this$livello1_resh, data_comune_this$livello2, sep=".")
#data_comune_this$livello3_resh <- paste(data_comune_this$livello2_resh, data_comune_this$livello3, sep=".")
#data_comune_this$livello4_resh <- paste(data_comune_this$livello3_resh, data_comune_this$livello4, sep=".")
#data_comune_this$cdc_resh <- paste(data_comune_this$livello4_resh, data_comune_this$cdc, sep=".")

colnodes_resh <- c("parent",paste(colnodes,"resh",sep="_"))

lnc <- length(colnodes_resh)-1
links <- NULL


rendiconto <- data_comune_this$rendiconto
names(rendiconto) <- data_comune_this$cdc_resh
values <- rendiconto

for (i in rev(1:lnc)) {
  
    icol <- colnodes_resh[c(i,i+1)]
    print(icol)
    temp <- data_comune_this[,c(icol,"rendiconto")]
    names(temp) <- c("source","target","value")
   
    
    ic <- duplicated(temp$target)
    temp$ic <- ic 
    temp <- temp[which(!ic),]
    temp$level <- i+1-1
    
    if (!is.null(values)) temp$value <- as.numeric(values[temp$target])
    
    values <- tapply(X=temp$value,FUN=sum,INDEX=temp$source,simplify=TRUE)
   
   
    links <- rbind(temp,links)  
  
  
}

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

