source("global.R")

dashboardPage(
	skin = "red",
  dashboardHeader(title = "r-lab3-shinyMilano",
  								titleWidth = 450),
  dashboardSidebar(
    selectInput("tipo", label = h3("Select box"), 
                choices = c("Tutto", tipo),
                selectize = TRUE),
    renderSelectOutput("pdc_descrizione_missione"),
    renderSelectOutput("pdc_descrizione_programma"),
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard"),
      menuItem("Raw data", tabName = "rawdata")
    )
  ),

dashboardBody(
    navbarPage("Schede",
               tabPanel("Proporzioni",
                        #sidebarLayout(
                         # sidebarPanel(
                         # 	selectInput("var", label = "Grouping Variable",
                         #  							choices = c("`PDC-Descrizione Livello1`","`PDC-Descrizione Livello2`",
                         #  													"`PDC-Descrizione Livello3`","`PDC-Descrizione Livello4`"),
                         #  							selected = "PDC-Descrizione Livello1")
                         #    ),
                				 mainPanel(
                				 	column(12,
                				 				 selectInput("var", label = "Grouping Variable",
                				 				 						choices = c("`PDC-Descrizione Livello1`","`PDC-Descrizione Livello2`",
                				 				 												"`PDC-Descrizione Livello3`","`PDC-Descrizione Livello4`"),
                				 				 						selected = "PDC-Descrizione Livello1")),
                				 	plotOutput("proporzione")
                         ))
               ,
               tabPanel("TimeSeries",
                        fluidPage(
                          mainPanel(
                            selectInput("TimeSeries1Choice", "Serie da visualizzare", 
                                      TimeSeries1PossibleValues),
                            plotOutput("TimeSeries1")
                          )
                        )
                      ),
               tabPanel("WorldCloud",
               				 fluidPage(
                        sidebarLayout(
                          sidebarPanel(
                            textInput("text", label = h3("Text input"), 
                            					value = "Termini da cercare")
                        ),
                        mainPanel(
                          wordcloud2Output('wordcloud2'),
                          dataTableOutput("tableWords")
                          )
                        )
                      )
               )
    )
)
)
             


