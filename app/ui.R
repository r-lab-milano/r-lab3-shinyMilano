source("global.R")

# 
# # Plot 3 ------------------------------------------------------------------
# ui <- dashboardPage(
#   dashboardHeader(title = "Basic dashboard"),
#   ## Sidebar content
#   dashboardSidebar(
#     sidebarMenu(
#       menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
#       menuItem("Widgets", tabName = "widgets", icon = icon("th"))
#     )
#   ),
#   dashboardBody(
#     
#     tabPanel("Home", value = "home",
#              h2("Home tab"),
#              textInput("text", "Enter string to search", "foo"),
#              actionButton("go", "Search")
#     ),
#     tabPanel("Search", value = "search",
#              h2("Search results:",
#                 textOutput("searchString", inline = TRUE)
#              )
#     ),
#     # Boxes need to be put in a row (or column)
#     fluidRow(
#       box(plotOutput("plot1", height = 250)),
# 
#       box(
#         title = "Controls",
#         sliderInput("slider", "Number of observations:", 1, 100, 50)
#       )
#     ),
#     fluidRow(
#       box(plotOutput("plot2", height = 250)),
# 
#       box(
#         title = "Controls",
#         sliderInput("slider2", "Number of observations:", 1, 100, 50)
#       )
#     )
#   )
# )






ui <- dashboardPage(
  dashboardHeader(title = "cran.rstudio.com"),
  dashboardSidebar(
    selectInput("select", label = h3("Select box"), 
                choices = c("Tutto", tipo),
                selectize = TRUE),
    # selectInput("select", label = h3("Select box"), 
    #             choices = list("Entrate" = "ENTRATE", "Uscite" = "USCITE", "Tutto" = "TUTTO"), 
    #             selected = 1),
    # selectInput("select", label = h3("Select box"), 
    #             choices = list("Entrate" = "ENTRATE", "Uscite" = "USCITE", "Tutto" = "TUTTO"), 
    #             selected = 1),
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









