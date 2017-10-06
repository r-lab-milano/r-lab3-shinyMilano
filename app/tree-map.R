load("../other-data/data_reshape.Rdata")
## commented because it interfers with shinyapp.io installation
# library(shiny)
# 
# library(treemap)
#library(d3treeR) ## commented because it interfers with shinyapp.io installation

# library(devtools)
# install_github("timelyportfolio/d3treeR")


ui <- shinyUI(fluidPage(
	
	# Application title
	titlePanel("Pretty Treemap"),
		
	selectInput("size", label = "Size", choices = colnames(datafin), 
							selected = "rendiconto"),
		# Show a plot of the generated distribution
		mainPanel(
			d3tree2Output("treemap")
		)
	)
)



server <- shinyServer(function(input, output, session){
	output$treemap <- renderD3tree2({
		d3tree2(
			treemap(
				datafin
				,index=c("ds_livello1","ds_livello2",
								 "ds_livello3","ds_livello4"),
				vSize = input$size
			)
		)
	})
})

shinyApp(server = server, ui = ui)

