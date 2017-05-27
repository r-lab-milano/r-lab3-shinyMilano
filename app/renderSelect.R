renderSelectOutput <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("results_from_server"))
  )
}

renderSelect <- function(input, output, session, df, df_col, inputId) {
  output$results_from_server <- renderUI({
    
    choices <- select_(df(), df_col) %>%
      unlist %>% 
      unique
    
    selectInput(inputId, stringr::str_to_title(inputId), choices = choices, 
                selectize = TRUE)
    
  })
}
