source("global.R")

ui <- dashboardPage(
  dashboardHeader(title = "cran.rstudio.com"),
  dashboardSidebar(
    selectInput("select", label = h3("Select box"), 
                choices = c("Tutto", tipo),
                selectize = TRUE),
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


server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  output$plot2 <- renderPlot({
    data <- histdata[seq_len(input$slider2)]
    hist(data)
  })
}

shinyApp(ui, server)









