require(wordcloud2)
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
	

	callModule(renderSelect, "pdc_descrizione_missione", df = df_filtered_by_tipo,
						 df_col = "ds_missione", inputId = "pdc_descrizione_missione")
	
	callModule(renderSelect, "pdc_descrizione_programma", df = df_filtered_by_tipo,
						 df_col = "ds_programma", inputId = "pdc_descrizione_programma")
}

