library(tidyverse)

#Carico dataset
df<-read.csv("../data/PEG_2017_2019_opendata_16_05_anni2013_2019.csv", 
             header=T, stringsAsFactors = F, dec = ".")


df$RENDICONTO.2013<-gsub(",", "", df$RENDICONTO.2013)
df$RENDICONTO.2014<-gsub(",", "", df$RENDICONTO.2014)
df$RENDICONTO.2015<-gsub(",", "", df$RENDICONTO.2015)
df$RENDICONTO.2016<-gsub(",", "", df$RENDICONTO.2016)
df$STANZIAMENTO.2017<-gsub(",", "", df$STANZIAMENTO.2017)
df$STANZIAMENTO.2018<-gsub(",", "", df$STANZIAMENTO.2018)
df$STANZIAMENTO.2019<-gsub(",", "", df$STANZIAMENTO.2019)

df$RENDICONTO.2013<-as.numeric(df$RENDICONTO.2013)
df$RENDICONTO.2014<-as.numeric(df$RENDICONTO.2014)
df$RENDICONTO.2015<-as.numeric(df$RENDICONTO.2015)
df$RENDICONTO.2016<-as.numeric(df$RENDICONTO.2016)
df$STANZIAMENTO.2017<-as.numeric(df$STANZIAMENTO.2017)
df$STANZIAMENTO.2018<-as.numeric(df$STANZIAMENTO.2018)
df$STANZIAMENTO.2019<-as.numeric(df$STANZIAMENTO.2019)

SpeseMilanoTimeSeries <- df %>% filter(`TIPO` == "USCITE") %>% 
    filter(`PDC.Descrizione.Livello1` == "SPESE CORRENTI" | 
           `PDC.Descrizione.Livello1` == "SPESE IN CONTO CAPITALE") %>%
    select(-STANZIAMENTO.DI.CASSA.2017) %>% 
    gather(ANNO, IMPORTO, RENDICONTO.2013:STANZIAMENTO.2019) %>%
    mutate(ANNO = substr(ANNO, nchar(ANNO)-3, nchar(ANNO))) %>%
    group_by(ANNO, PDC.Descrizione.Livello1, PDC.Descrizione.Programma) %>%
    mutate(Total = sum(IMPORTO)) %>%
    select(ANNO, PDC.Descrizione.Livello1, PDC.Descrizione.Programma, Total) %>%
    unique() %>% ungroup()

names(SpeseMilanoTimeSeries)<-c("ANNO", "SPESA", "PROGRAMMA", "IMPORTO")

# # Subsetting del df
# spese.Milano<-subset(df, TIPO == "USCITE" & PDC.Descrizione.Livello1 == "SPESE CORRENTI"
#                      | PDC.Descrizione.Livello1 == "SPESE IN CONTO CAPITALE")
# 
# # Dati da formato largo a formato lungo
# spese.Milano_seq <- spese.Milano %>%
#   select(-STANZIAMENTO.DI.CASSA.2017) %>% 
#   gather(ANNO, IMPORTO, RENDICONTO.2013:STANZIAMENTO.2019) %>%
#   mutate(ANNO = substr(ANNO, nchar(ANNO)-3, nchar(ANNO)))
# 
# MilanoUscite_Aggregate<-tapply(spese.Milano_seq$IMPORTO, list(spese.Milano_seq$ANNO,spese.Milano_seq$PDC.Descrizione.Livello1
#                                           , spese.Milano_seq$PDC.Descrizione.Programma), sum)
# 
# MilanoUscite_Aggregate<-plyr::adply(MilanoUscite_Aggregate, c(1,2,3))
# names(MilanoUscite_Aggregate)<-c("ANNO", "SPESA", "PROGRAMMA", "IMPORTO")
# MilanoUscite_Aggregate$ANNO<-as.character(MilanoUscite_Aggregate$ANNO)
# 

# ggplot(data = MilanoUscite_Aggregate %>% 
#          filter(PROGRAMMA == "ALTRI ORDINI DI ISTRUZIONE NON UNIVERSITARIA"), 
#        aes(x=ANNO, y=IMPORTO, col = SPESA)) +
#   geom_point() +
#   ggtitle("ALTRI ORDINI DI ISTRUZIONE NON UNIVERSITARIA")

TimeSeries1PossibleValues <- SpeseMilanoTimeSeries %>% select(`PROGRAMMA`) %>% unique()

TimeSeries_Programma<-function(nome_programma){
  ggplot(data = SpeseMilanoTimeSeries %>% 
         filter(PROGRAMMA == nome_programma), 
         aes(x=as.numeric(ANNO), y=IMPORTO, col = SPESA)) +
    geom_line() +
    ggtitle(nome_programma) +
    labs(x="ANNO") + 
    theme(legend.position = "bottom")
}
