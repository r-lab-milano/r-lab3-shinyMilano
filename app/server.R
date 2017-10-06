# 1-STRUCTUREPLOT

function(input, output, session) {
	df_filtered <- reactive({
		datafin %>% filter(ds_missione == input$missione, ds_programma == input$programma)
	})

	observe({
		programma_filtered <- datafin %>%
			filter(ds_missione == input$missione) %>%
			select(ds_programma) %>%
			unique()
		updateSelectInput(session, 'programma', choices = programma_filtered)
	})

	observeEvent(c(input$programma, input$missione), {
		output$structure <- renderPlot({
			structure_plot(df_filtered(), input$anno)
		},
		height = 800)
	})



	
	# 2-TIMESERIES
	
	output$TimeSeries1 <-  renderPlot({
		
		TimeSeries1Query <- input$TimeSeries1Choice
		TimeSeries_Programma(TimeSeries1Query)
	})
	
	output$TimeSeries2 <- renderPlot({
		TimeSeries_Dettaglio(input$TimeSeries1Choice, "SPESE CORRENTI")
	})
	
	output$TimeSeries3 <- renderPlot({
		TimeSeries_Dettaglio(input$TimeSeries1Choice, "SPESE IN CONTO CAPITALE")
	})
	
	
	# 3-WORDCLOUD
	
	data_cloud <- eventReactive(input$go, {
		query <- input$text
		data_cloud <- get_clean_frequencies(input = get_row_from_word(query))
	})
	
	output$wordcloud2 <- renderWordcloud2({
		wordcloud2(data = data_cloud())
	})
	
	data_tableWords <- eventReactive(input$go, {
		query <- input$text
		rows <- get_row_from_word(input$text)
			data <- rows %>% select(tipo, capitolo = ds_capitolo_PEG, anno,
																	 rendiconto_1000) %>%
			filter(anno < 2017) %>%
			spread(anno, rendiconto_1000) %>%
			rename("Movimento" = tipo,
						 "Dettaglio voce (valori in migliaia di euro)" = capitolo)
		data
	})
	
	output$tableWords <- renderDataTable({
		data_tableWords()
	}, options = list(paging = FALSE,
										scrollX = TRUE))
	
	# 4-TABLETOP    
	
	# output$tableTop <- renderDataTable({
	# 	datafin %>% select(ds_centro_resp, tipo, anno, rendiconto_1000) %>% 	
	# 		filter(tipo == input$tipo_movimento, anno == input$year) %>%
	# 		group_by(ds_centro_resp) %>%
	# 		summarize(valore = sum(rendiconto_1000)) %>%
	# 		arrange(desc(valore)) %>%
	# 		rename("Centro di responsabilità" = ds_centro_resp,
	# 					 "Valore (in migliaia di euro)" = valore) %>%
	# 		head(n=input$topNum)
	# })
	
	output$histTop <- renderPlot({
		plotTop(input$tipo_movimento, input$year, input$topNum)
	})
	
		output$tableTop <- renderDataTable({
		tabTop(input$tipo_movimento, input$year, input$topNum)
	})
	

	
	# 5-SUNBURST  
	
	output$sun <- renderSunburst({
		printSun(input$year_sun, input$tipo_sun)
	})
	
	
	# 6-SANKEY
	
	output$sankey_out <- renderSankeyNetwork({
		if (input$sankey_tipo == "ENTRATE") depth = 3
		else depth = 1
		## padding: distanza verticale tra i nodi?
		## nodeWidth: larghezza orizzontale dei nodi
		## depth: n di livelli da visualizzare
		## NB: in ui.R setta il parametro height
		ss <- sankey_gen(data_comune, input$sankey_year, 
										 input$sankey_tipo, depth = depth, 
										 fontSize = 24*depth, nodeWidth = 10*depth,
										 width = NULL, nodePadding = 50)
		ss
	})
	
}

