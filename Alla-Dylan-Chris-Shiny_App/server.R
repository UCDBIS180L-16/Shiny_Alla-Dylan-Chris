# Define server logic required to draw a boxplot

# Install Required Packages
# http://stackoverflow.com/questions/4090169/elegant-way-to-check-for-missing-packages-and-install-them
# list.of.packages <- c("ggplot2")
# new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
# if(length(new.packages)) install.packages(new.packages)

# Load required Libraries
library(shiny)
library(ggplot2)

# Load UI and Server
if(!exists("ui")) source("ui.R")
if(!exists("server")) source("server.R")


server <- shinyServer(function(input, output) {

    # Expression that generates a boxplot. The expression is
    # wrapped in a call to renderPlot to indicate that:
    #
    #  1) It is "reactive" and therefore should re-execute automatically
    #     when inputs change
    #  2) Its output type is a plot

    output$boxPlot <- renderPlot({

        # set up the plot
        pl <- ggplot(data = iris,
                     #Use aes_string below so that input$trait is interpreted
                     #correctly.  The other variables need to be quoted
                     aes_string(x="Species",
                                y=input$trait,
                                fill="Species"
                     )
        )

        # draw the boxplot for the specified trait
        pl + geom_boxplot()
    })
})