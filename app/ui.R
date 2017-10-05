source("global.R")

dashboardPage(
	skin = "red",
	dashboardHeader(title = "r-lab3-shinyMilano",
									titleWidth = 450),
	dashboardSidebar(disable = TRUE),
	
	dashboardBody(
		
		navbarPage("Schede",
							 
							 tabPanel("Ripartizione fondi per missione",
							 				 box(selectInput("tipo", 
							 				 								label = "Entrate/Uscite", 
							 				 								choices = tipo, selected = 'USCITE'),
							 				 		selectInput('missione', 'Missione', choices = 'Tutto')
							 				 		),
							 				 box( selectInput('programma', 'Programma', choices = 'Tutto'),
							 				 		 selectInput('anno', 'Seleziona un anno:', choices = c(2013:2016), 
							 				 		 						selected = 2016)
							 				 		 ),
							 				 box('Le missioni sono funzioni e obiettivi strategici del Comune: si 
							 				 		declinano in programmi, aggregati di attività finalizzate a realizzarli.
							 				 		Dal box nero a sinistra puoi selezionare la missione e il programma di cui 
							 				 		vuoi osservare i valori. Nel grafico puoi quindi osservare come si distribuisce 
							 				 		la spesa per quel programma, ovvero dove e quanto viene speso per ciascun livello,
							 				 		per ciascun centro di costo', width = 20),
							 				 plotOutput('structure', click = 'plot_click', width = "auto", height = "auto")
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
							 
							 #     					 tabPanel("Storico fondi per programma",
							 #     					 				 div(style = "display: inline-block;vertical-align:top; 
							 #                				 		width: 300px;",
							 #     					 				 		selectInput("TimeSeries1Choice", "Seleziona il programma istituzionale:",
							 #     					 				 								TimeSeries1PossibleValues)),
							 #     					 				 div(style = "display: inline-block;vertical-align:top; 
							 #                				 		width: 500px;", 
							 #     					 				 		box('I programmi sono aggregati omogenei di attività volti a perseguire 
							 # 															obiettivi strategici del Comune. \n 
							 #     					 				 				In questa visualizzazione puoi confrontare la spesa effettuata (fino al 2016) 
							 #     					 				 				e prevista (dal 2017 al 2019) per ciascun programma inserito in bilancio.', 
							 #     					 				 				width = 12)
							 #     					 				 ),
							 #     					 				 # fluidRow(
							 #     					 				 # 	column(8, plotOutput("TimeSeries1"))),
							 #     					 				 # fluidRow(column(4, plotOutput("TimeSeries2")),
							 #     					 				 # column(4, plotOutput("TimeSeries3")))
							 #     					 				 column(6, plotOutput("TimeSeries1")),
							 #     					 				 column(3, plotOutput("TimeSeries2")),
							 #     					 				 column(3, plotOutput("TimeSeries3"))
							 #     					 ),
							 
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
							 				 # fluidPage(
							 				 #   sidebarLayout(
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
							 				 	dataTableOutput("tableTop")
							 				 )
							 ),
							 
							 #     					 tabPanel("Distribuzione fondi per livelli",
							 #     					 				 # fluidPage(
							 #     					 				 #   sidebarLayout(
							 #     					 				 sidebarPanel(
							 #     					 				 	helpText("In questa scheda puoi visualizzare quali centri di responsabilità 
							 # 													(unità operative in cui il Comune è organizzato) hanno avuto a disposizione 
							 # 													più fondi. Seleziona il tipo di movimento, l'anno e il numero di
							 # 																	risultati da mostrare, e osserva la classifica."),
							 #     					 				 	checkboxGroupInput("year_sun", label = "Year", 
							 #     					 				 										 choices = unique(data_sun$year),
							 #     					 				 										 selected = 2016)),
							 #     					 				 	# Show a plot of the generated distribution
							 #     					 				 	mainPanel(
							 #     					 				 		sunburstOutput("sun", width = "100%", height = "400px"))
							 #     					 				 ),
							 
							 tabPanel("Distribuzione fondi per livelli",
							 				 div(style = "display: inline-block;vertical-align:top; 
               				 		width: 100px;",
							 				 		checkboxGroupInput("year_sun", label = "Year", 
							 				 											 choices = unique(data_sun$year),
							 				 											 selected = 2016), inline = T),
							 				 div(style = "display: inline-block;vertical-align:top; 
               				 		width: 800px;", 
							 				 		box("La struttura del bilancio comunale è stabilita dal Testo Unico degli 
																Enti Locali. Per ogni voce di entrata o di spesa, il bilancio è suddiviso 
    					 				 				  in 4 livelli di dettaglio. In questa visualizzazione puoi navigare dal
    					 				 				  livello di minor dettaglio (interno del cerchio), al livello di 
    					 				 				  maggior dettaglio, e verificare la proporzione di fondi che quella
    					 				 				  voce costituisce.", width = 20)),
							 				 sunburstOutput("sun")
							 				 )
							 )
		)
	)



