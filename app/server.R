
function(input, output, session) {
  
	set.seed(122)
	histdata <- rnorm(500)
	
	df_filtered_by_tipo <- reactive({
		filter(df, tipo == input$tipo)
		})
	output$plot1 <- renderPlot({
		data <- histdata[1:50]
		hist(data)
	})
	
	output$wordcloud2 <- renderWordcloud2({
	  query <- input$text
	  data <- get_clean_frequencies(input=get_row_from_word(query))
		wordcloud2(data = data)
	})
	
	output$tableWords <- renderDataTable({
	  query <- input$text
	  rows <- get_row_from_word(input$text)
	  data <- rows %>% dplyr::select(`TIPO`, `Descrizione capitolo PEG`, `RENDICONTO 2013`, 
	                         `RENDICONTO 2014`, `RENDICONTO 2015`, `RENDICONTO 2016`)
	  data
	})
	
	callModule(renderSelect, "pdc_descrizione_missione", df = df_filtered_by_tipo,
						 df_col = "ds_missione", inputId = "pdc_descrizione_missione")
}

