source("global.R")

dashboardPage(
	skin = "red",
	dashboardHeader(title = "r-lab3-shinyMilano",
									titleWidth = 450),
	dashboardSidebar(disable = TRUE),
	dashboardBody(
		navbarPage(
			"Schede",
			tabPanel(
				"Proporzioni",
				box(
					selectInput(
						"tipo", "Entrate/uscite", tipo, selected = 'USCITE'),
					selectInput('missione', 'Missione', choices = 'Tutto')
				),
				box(
					selectInput('programma', 'Programma', choices = 'Tutto'),
					selectInput(
						'anno',
						'Anno',
						choices = c(2013:2016),
						selected = 2016
					)
				),
				box(
					'All\'interno di ciascun programma selezionato
            sopra, viene mostrato dove e quanto viene
            speso per ciascun livello, per ciascun centro
            di costo',
					width = 12
				),
				plotOutput('structure', click = 'plot_click')
			),
			tabPanel(
				"TimeSeries",
				selectInput(
					"TimeSeries1Choice",
					"Serie da visualizzare",
					TimeSeries1PossibleValues
				),
				column(6, plotOutput("TimeSeries1")),
				column(6, plotOutput("TimeSeries2"))
			),
			
			tabPanel(
				"WorldCloud",
				# fluidPage(
				#   sidebarLayout(
				sidebarPanel(textInput(
					"text", label = h3("Text input"),
					value = "Termini da cercare"
				)),
				mainPanel(
					wordcloud2Output('wordcloud2'),
					dataTableOutput("tableWords")
				)
			),
			
			tabPanel(
				"Top Results",
				# fluidPage(
				#   sidebarLayout(
				sidebarPanel(
					selectInput("tipo_movimento", "Tipo:",
											c("ENTRATE", "USCITE")),
					selectInput("year", "Anno",
											c("2013", "2014", "2015", "2016")),
					textInput("topNum", "Risultati da mostrare:",
										10)
				),
				mainPanel(dataTableOutput("tableTop"))
			),
			tabPanel(
				"Sankey",
				# fluidPage(
				#   sidebarLayout(
				sidebarPanel(
					selectInput("sankey_tipo", "Tipo:",
											c("ENTRATE", "USCITE")),
					selectInput("sankey_year", "Anno",
											c("2013", "2014", "2015", "2016"))
					# textInput("sankey_n_levels", "Risultati da mostrare:",
					# 					10)
				),
				mainPanel( 
					sankeyNetworkOutput(outputId = "sankey_out", height = 1000)
					)
			)
		)
	)
)
