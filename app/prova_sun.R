library(sunburstR)
library(purrr)
library(tidyr)
library(d3r)

load("../other-data/data_reshape.Rdata")

prova <- data.frame(grouping = paste0(datafin$ds_livello1,"-",
																														datafin$ds_livello2,"-",
																														datafin$ds_livello3,"-",
																														datafin$ds_livello4),rendiconto = datafin$rendiconto,
										year=datafin$anno)
sunburst(prova)

ui <- shinyUI(fluidPage(
	
	
	# Application title
	titlePanel("Sunburst"),
	checkboxGroupInput("year", label = "Year", 
										 choices = unique(prova$year),
										 selected = 2013),
	# Show a plot of the generated distribution
	mainPanel(
		sunburstOutput("sun")
	)
)
)



server <- shinyServer(function(input, output, session){
	output$sun <- renderSunburst({
		sunburst(prova[prova$year==input$year,])
	})
})

shinyApp(server = server, ui = ui)
