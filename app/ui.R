source("global.R")

dashboardPage(
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
                        sidebarLayout(
                          sidebarPanel(
                            #radioButtons("plotType", "Plot type",
                            #             c("Scatter"="p", "Line"="l")
                                         
                            selectInput("select", label = h3("Select box"), 
                                        choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3)
                            )
                          ),
                          mainPanel(
                            plotOutput("plot1")
                          )
                        )
               ),
               tabPanel("WorldCloud",
                        sidebarLayout(
                          sidebarPanel(
                            textInput("text", label = h3("Text input"), value = "Termini da cercare")
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
             


