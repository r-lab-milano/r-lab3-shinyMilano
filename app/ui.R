source("global.R")

dashboardPage(
	skin = "red",
	dashboardHeader(title = "R-Lab / Milano Budget Trasparente",
									titleWidth = 450),
	dashboardSidebar(disable = TRUE),
	
	dashboardBody(
		
		navbarPage("Schede",
							 
							 tabPanel("Ripartizione fondi per missione",
							 				 sidebarPanel(
							 				 	helpText('Le missioni sono funzioni e obiettivi strategici del Comune: si 
							 				 		declinano in programmi, aggregati di attività finalizzate a realizzarli.
							 				 		Dal box puoi selezionare la missione e il programma di cui 
							 				 		vuoi osservare i valori. Nel grafico puoi quindi osservare come si distribuisce 
							 				 		la spesa per quel programma, ovvero dove e quanto viene speso per ciascun livello,
							 				 		per ciascun centro di costo'),
							 				 	h3("Seleziona missione e programma"),
							 				 	selectInput('missione', 'Missione', choices = missionValues,
							 				 							selected = "ORDINE PUBBLICO E SICUREZZA"),
							 				 	selectInput('programma', 'Programma', choices = 'Tutto',
							 				 							selected = "POLIZIA LOCALE E AMMINISTRATIVA"),
							 				 	selectInput('anno', 'Seleziona un anno:', choices = c(2013:2016), 
							 				 							selected = 2016)
							 				 ),
							 				 mainPanel(
							 				 	plotOutput('structure', click = 'plot_click', width = "auto", height = "auto")
							 				 )
							 ),
							 
							 
							 tabPanel("Storico fondi per programma",
							 				 sidebarPanel(
							 				 	helpText('I programmi sono aggregati omogenei di attività volti a perseguire 
							 				 					 obiettivi strategici del Comune. \n 
							 				 					 In questa visualizzazione puoi confrontare la spesa effettuata (fino al 2016) 
							 				 					 e prevista (dal 2017 al 2019) per ciascun programma inserito in bilancio.'),
							 				 	selectInput("TimeSeries1Choice", "Seleziona il programma istituzionale:",
							 				 							TimeSeries1PossibleValues)
							 				 ),
							 				 mainPanel(
							 				 	column(12, plotOutput("TimeSeries1")),
							 				 	column(6, plotOutput("TimeSeries2")),
							 				 	column(6, plotOutput("TimeSeries3"))
							 				 )
							 ),
							 
							 
							 tabPanel("Ricerca per testo",
							 				 # fluidPage(
							 				 #   sidebarLayout(
							 				 sidebarPanel(
							 				 	helpText("In questa scheda puoi effettuare una ricerca per parole chiave.
							 				 					 Inserisci un termine da cercare e clicca su Cerca: potrai visualizzare 
							 				 					 la nuvola di parole
							 				 					 più associate a quel termine, e le voci di bilancio che lo contengono."),
							 				 	textInput("text", label = h3("Termine da cercare:"),
							 				 						value = "Asili"),
							 				 	actionButton("go", "Cerca")
							 				 ),
							 				 mainPanel(
							 				 	wordcloud2Output('wordcloud2'),
							 				 	dataTableOutput("tableWords")
							 				 )
							 ),
							 
							 
							 tabPanel("Top fondi per centro di responsabilità",
							 				 sidebarPanel(
							 				 	helpText("In questa scheda puoi visualizzare quali centri di responsabilità 
							 				 					 (unità operative in cui il Comune è organizzato) hanno avuto a disposizione 
							 				 					 più fondi. Seleziona il tipo di movimento, l'anno e il numero di
							 				 					 risultati da mostrare, e osserva la classifica."),
							 				 	selectInput("tipo_movimento", "Tipo:",
							 				 							c("ENTRATE", "USCITE")),
							 				 	selectInput("year", "Anno",
							 				 							c("2013","2014","2015","2016")),
							 				 	textInput("topNum", "Risultati da mostrare:",
							 				 						15)
							 				 ),
							 				 mainPanel(
							 				 	plotOutput("histTop"),
							 				 	dataTableOutput("tableTop")
							 				 )
							 ),
							 
							 tabPanel("Distribuzione fondi per livelli",
							 				 sidebarPanel(
							 				 	helpText("La struttura del bilancio comunale è stabilita dal Testo Unico degli 
 																Enti Locali. Per ogni voce di entrata o di spesa, il bilancio è suddiviso 
     					 				 				  in 4 livelli di dettaglio. In questa visualizzazione puoi navigare dal
     					 				 				  livello di minor dettaglio (interno del cerchio), al livello di 
     					 				 				  maggior dettaglio, e verificare la proporzione di fondi che quella
     					 				 				  voce costituisce."),
							 				 	selectInput("tipo_sun", "Tipo:",
							 				 							c("ENTRATE", "USCITE")),
							 				 	checkboxGroupInput("year_sun", label = "Year",
							 				 										 choices = 2013:2016,
							 				 										 selected = 2016)
							 				 	),
							 				 # Show a plot of the generated distribution
							 				 mainPanel(
							 				 	sunburstOutput("sun")
							 				 	)
							 ),
							 
							 tabPanel("Flussi di cassa",
							 	sidebarPanel(
							 		selectInput("sankey_tipo", "Tipo:",
							 								c("ENTRATE", "USCITE"), selected = "USCITE"),
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



