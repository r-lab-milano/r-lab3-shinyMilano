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
    
    # sidebarMenu(
    #   menuItem("Dashboard", tabName = "dashboard"),
    #   menuItem("Raw data", tabName = "rawdata")
    # )
  ),
  
  dashboardBody(
    navbarPage("Schede",
               tabPanel("Proporzioni",
                        
                        div(style="display: inline-block;vertical-align:top; width: 100px;",
                              selectInput('anno', 'Anno', choices = c(2013:2016), selected = 2016)),
                        div(style="display: inline-block;vertical-align:top; width: 500px;",
                              box('All\'interno di ciascun programma selezionato a fianco, 
                            viene mostrato dove e quanto viene speso per ciascun livello, 
                            per ciascun centro di costo', width = 12)
                          ),
                        plotOutput('structure', click = 'plot_click')
               ),
               tabPanel("TimeSeries",
                        # fluidPage(
                        #   mainPanel(
                        selectInput("TimeSeries1Choice", "Serie da visualizzare",
                                    TimeSeries1PossibleValues),
                        column(6, plotOutput("TimeSeries1")),
                        column(6, plotOutput("TimeSeries2"))
                        #   )
                        # )
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
                        #   )
                        # )
               )
    )
  )
)



