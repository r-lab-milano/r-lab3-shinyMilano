source("global.R")

dashboardPage(
  dashboardHeader(title = "Milano Municipality Budget"),
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
    tabItems(
      tabItem("dashboard",
              fluidRow(
                box(plotOutput("plot1", height = 250)),
                
                box(
                  title = "Controls",
                  sliderInput("slider", "Number of observations:", 1, 100, 50)
                )
              )
              
      ),
      tabItem("rawdata",
              fluidRow(
                box(plotOutput("plot2", height = 250)),

                box(
                  title = "Controls",
                  sliderInput("slider2", "Number of observations:", 1, 100, 50)
                )
              )
            )
          )
        )
      )
