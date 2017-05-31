data <- read_csv("./data/PEG_2017_2019_opendata_16_05_anni2013_2019.csv")
descrizione <- data %>% dplyr::select(`Descrizione capitolo PEG`)

get_clean_frequencies <- function(input = data){
  parole_da_eliminare <- read_csv("./data/parole_da_eliminare.csv")
  input %>% select(`Descrizione capitolo PEG`) %>%
    tidytext::unnest_tokens(word, `Descrizione capitolo PEG`) %>%
    group_by(word) %>% mutate(freq = n()) %>% unique() %>%
    filter(!(word %in% parole_da_eliminare$parole)) %>%
    dplyr::arrange(desc(freq)) %>% as.data.frame()
}

get_row_from_word <- function(word)  {
  filter(data, grepl(word, `Descrizione capitolo PEG`, ignore.case = TRUE))
}
