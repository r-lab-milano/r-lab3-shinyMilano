data <- read.csv(file=paste0(system.file(package = "RLab3"),'/db/data.csv'), skip=1, header = F,sep=";" )

ncol(data)
label <- c("TIPO","PDC-Missione","PDC-Descrizione Missione",
           "PDC-Programma","PDC-Descrizione Programma",
           "PDC-Livello1","PDC-Descrizione Livello1",
           "PDC-Livello2","PDC-Descrizione Livello2",
           "PDC-Livello3","PDC-Descrizione Livello3",
           "PDC-Livello4","PDC-Descrizione Livello4",
           "Cdc","Descrizione centro di costo",
           "CAPITOLO","ARTICOLO","NUMERO","Descrizione capitolo PEG",
           "Centro di responsabilità","Descrizione Centro di Responsabilità",
           "DIR","Descrizione Direzione","anno",
           "rendiconto",
           "stanziamento" ,"stanziamento di cassa","sezione_bilancio","Descrizione sezione bilancio")
names1 <- c("tipo","missione","ds_missione",
            "programma","ds_programma",
            "livello1","ds_livello1",
            "livello2","ds_livello2",
            "livello3","ds_livello3",
            "livello4","ds_livello4",
            "cdc","ds_cdc",
            "capitolo","articolo","numero","ds_capitolo_PEG",
            "centro_resp","ds_centro_resp")
names2 <- c(
  "RENDICONTO_2013","RENDICONTO_2014","RENDICONTO_2015","RENDICONTO_2016",
  "STANZIAMENTO_2017","STANZIAMENTO_DI_CASSA_2017",
  "STANZIAMENTO_2018","STANZIAMENTO_2019")
names3 <- c("dir","ds_dir")

names(data) <- c(names1,names2,names3)

data2 <- data[,c(names1,names3)]
data2$anno=2013
data2$rendiconto<- data[,c("RENDICONTO_2013")]
data2$stanziamento<- 0
data2$stanziamento_cassa <- 0
datafin <- data2

data2 <- data[,c(names1,names3)]
data2$anno <- 2014
data2$rendiconto<- data[,c("RENDICONTO_2014")]
data2$stanziamento<- 0
data2$stanziamento_cassa <- 0
datafin <- rbind(datafin,data2)

data2 <- data[,c(names1,names3)]
data2$anno <- 2015
data2$rendiconto<- data[,c("RENDICONTO_2015")]
data2$stanziamento<- 0
data2$stanziamento_cassa <- 0
datafin <- rbind(datafin,data2)

data2 <- data[,c(names1,names3)]
data2$anno <- 2016
data2$rendiconto<- data[,c("RENDICONTO_2016")]
data2$stanziamento<- 0
data2$stanziamento_cassa <- 0
datafin <- rbind(datafin,data2)

data2 <- data[,c(names1,names3)]
data2$anno <- 2017
data2$rendiconto<- 0
data2$stanziamento<- data[,c("STANZIAMENTO_2017")]
data2$stanziamento_cassa <- data[,c("STANZIAMENTO_DI_CASSA_2017")]
datafin <- rbind(datafin,data2)

data2 <- data[,c(names1,names3)]
data2$anno <- 2018
data2$rendiconto<- 0
data2$stanziamento<- data[,c("STANZIAMENTO_2018")]
data2$stanziamento_cassa <- 0
datafin <- rbind(datafin,data2)

data2 <- data[,c(names1,names3)]
data2$anno <- 2019
data2$rendiconto<- 0
data2$stanziamento<- data[,c("STANZIAMENTO_2019")]
data2$stanziamento_cassa <- 0
datafin <- rbind(datafin,data2)

datafin$sezione_bilancio <- 0
datafin$sezione_bilancio <- ifelse(
  (datafin$tipo=="ENTRATE" & datafin$livello1 %in% c(1,2,3)) | (datafin$tipo=="USCITE" & datafin$livello1 %in% c(1,4)),1,
  datafin$sezione_bilancio)
datafin$sezione_bilancio <- ifelse((datafin$tipo=="ENTRATE" & datafin$livello1 %in% c(4,5,6)) |
                                     (datafin$tipo=="USCITE" & datafin$livello1 %in% c(2,3)),2,
                                   datafin$sezione_bilancio)

datafin$ds_sezione_bilancio <- ifelse(datafin$sezione_bilancio==1,"Bilancio corrente",
                                      ifelse(datafin$sezione_bilancio==2,"Bilancio investimento",""))

table(datafin$sezione_bilancio)

table(datafin$ds_sezione_bilancio)
datafin$rendiconto <- as.numeric(gsub(",","",datafin$rendiconto))
summary(datafin$rendiconto)
datafin$stanziamento <- as.numeric(gsub(",","",datafin$stanziamento))
summary(datafin$stanziamento)
datafin$stanziamento_cassa <- as.numeric(gsub(",","",datafin$stanziamento_cassa))
summary(datafin$stanziamento_cassa)
save(datafin, file="/Users/veronica/git/data_reshape.Rdata")
save(label, file="/Users/veronica/git/label_data.Rdata")

write.table(datafin, file="/Users/veronica/git/data_reshape.csv",
            row.names = F, sep=";")
