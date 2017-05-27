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
	
	output$plot2 <- renderPlot({
		data <- histdata[50:100]
		hist(data)
	})
	
	callModule(renderSelect, "pdc_descrizione_missione", df = df_filtered_by_tipo,
						 df_col = "ds_missione", inputId = "pdc_descrizione_missione")
	
}

