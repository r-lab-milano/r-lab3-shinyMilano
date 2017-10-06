# 1-STRUCTUREPLOT

function(input, output, session) {
	
	df_filtered <- reactive({
		if (input$tipo == 'USCITE') {
			df <- filter(df, tipo == 'USCITE')
			if (input$missione == 'Tutto') {
				df
			} else {
				df <- df %>% 
					filter(ds_missione == input$missione)
			}
			
			if (input$programma == 'Tutto') {
				df
			} else {
				df <- df %>% 
					filter(ds_programma == input$programma)
			}
		} else {
			df <- filter(df, tipo == 'ENTRATE')
		}
		df
	})
	
	
	
	observe({
		
		missione_filtered <- df %>% 
			filter(tipo == input$tipo) %>% 
			select(ds_missione) %>% 
			unique()
		
		updateSelectInput(session, 'missione', choices = missione_filtered)
	})
	
	observe({
		if (input$missione == 'Tutto') {
			programma_filtered <- df %>% 
				filter(tipo == input$tipo, ds_missione == input$missione) %>% 
				select(ds_programma) %>% 
				unique()
		} else {
			programma_filtered <- df %>% 
				filter(tipo == input$tipo, ds_missione == input$missione) %>% 
				select(ds_programma) %>% 
				unique()
		}
		
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
		data <- rows %>% dplyr::select(`tipo`, capitolo = `ds_capitolo_PEG`, `anno`,
																	 `rendiconto`) %>%
			filter(`anno` < 2017) %>%
			spread(`anno`, `rendiconto`)	
		data
	})
	
	output$tableWords <- renderDataTable({
		data_tableWords()
	}, options = list(paging = FALSE,
										scrollX = TRUE))
	
	# 4-TABLETOP    
	
	output$tableTop <- renderDataTable({
		df %>% select(ds_centro_resp, tipo, anno, rendiconto) %>% 	
			filter(tipo == input$tipo_movimento, anno == input$year) %>%
			group_by(ds_centro_resp) %>%
			summarize(valore = sum(rendiconto)) %>%
			arrange(desc(valore)) %>%
			head(n=input$topNum)
	})
	
	
	# 5-SUNBURST  
	
	output$sun <- renderSunburst({
		sunburst(data_sun[data_sun$year==input$year_sun,])
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

