function(input, output, session) {
 
	df_filtered_by_tipo <- reactive({
		filter(df, tipo == input$tipo)
		})
	
	callModule(renderSelect, "pdc_descrizione_missione", df = df_filtered_by_tipo,
						 df_col = "ds_missione", inputId = "pdc_descrizione_missione")
	
}

