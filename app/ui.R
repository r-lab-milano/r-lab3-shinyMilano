source("global.R")

dashboardPage(
  skin = "red",
  dashboardHeader(title = "r-lab3-shinyMilano",
                  titleWidth = 450),
  dashboardSidebar(
    selectInput("tipo", 
                label = h3("Select box"), 
                choices = tipo, selected = 'USCITE'),
    selectInput('missione', 'Missione', choices = 'Tutto'),
    selectInput('programma', 'Programma', choices = 'Tutto')
  ),
  
  dashboardBody(
  	
    navbarPage("Schede",
    					 
               tabPanel("Proporzioni",
               				 div(style = "display: inline-block;vertical-align:top; 
               				 		width: 100px;",
               				 		selectInput('anno', 'Seleziona un anno:', choices = c(2013:2016), 
               				 								selected = 2016)),
               				 div(style = "display: inline-block;vertical-align:top; 
               				 		width: 800px;", 
               				 		box('Le missioni sono funzioni e obiettivi strategici del Comune: si 
														declinano in programmi, aggregati di attivita\' finalizzate a realizzarli.
														Dal box nero a sinistra puoi selezionare la missione e il programma di cui 
														vuoi osservare i valori. Nel grafico puoi quindi osservare come si distribuisce 
														la spesa per quel programma, ovvero dove e quanto viene speso per ciascun livello,
               				 			per ciascun centro di costo', width = 20)),
														plotOutput('structure', click = 'plot_click')
														),
    					 
    					 tabPanel("TimeSeries",
    					 				 div(style = "display: inline-block;vertical-align:top; 
               				 		width: 300px;",
    					 				 selectInput("TimeSeries1Choice", "Seleziona il programma istituzionale:",
    					 				 						TimeSeries1PossibleValues)),
    					 				 div(style = "display: inline-block;vertical-align:top; 
               				 		width: 500px;", 
    					 				 		box('I programmi sono aggregati omogenei di attivita\' volti a perseguire 
															obiettivi strategici del Comune. \n 
    					 				 				In questa visualizzazione puoi confrontare la spesa effettuata (fino al 2016) 
    					 				 				e prevista (dal 2017 al 2019) per ciascun programma inserito in bilancio.', 
    					 				 				width = 12)
    					 				 ),
    					 				 column(9, plotOutput("TimeSeries1"))
    					 				 # column(6, plotOutput("TimeSeries2"))
               ),

               tabPanel("WorldCloud",
                        # fluidPage(
                        #   sidebarLayout(
                        sidebarPanel(
                          textInput("text", label = h3("Text input"),
                                    value = "Termini da cercare")
                          ),
               				 mainPanel(
               				 	wordcloud2Output('wordcloud2'),
               				 	dataTableOutput("tableWords")
               				 	)
               				 ),
    					 
    					 tabPanel("Top Results",
    					 				 # fluidPage(
    					 				 #   sidebarLayout(
    					 				 sidebarPanel(
    					 				 	selectInput("tipo_movimento", "Tipo:",
    					 				 							c("ENTRATE", "USCITE")),
    					 				 	selectInput("year", "Anno",
    					 				 							c("2013","2014","2015","2016")),
    					 				 	textInput("topNum", "Risultati da mostrare:",
    					 				 						10)
    					 				 ),
    					 				 mainPanel(
    					 				 	dataTableOutput("tableTop")
    					 				 )
    					 )
    					 )
    )
)



