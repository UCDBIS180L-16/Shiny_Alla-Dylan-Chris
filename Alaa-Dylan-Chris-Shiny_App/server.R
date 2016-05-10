library(shiny)
library(ggplot2)
library(PSMix)

shinyServer(function(input, output) {
  output$plot <- renderPlot({
    ShinyData <- read.csv("ShinyData.csv")

    create_plot <- function(data, x, y, type) {
        if (type == "Boxplot") {
            return(ggplot(data=ShinyData, aes_string(x = x, y = y, fill="Region")) + geom_boxplot())
        } else if (type == "Violin") {
            return(ggplot(data=ShinyData, aes_string(x = x, y = y, fill="Region")) + geom_violin())
        } else if (type == "Dot Plot") {
            return(ggplot(data=ShinyData, aes(V1, V2, color=get(y))) + geom_point())
        }
    }


    trait <- function(input_trait) {
        if (input_trait == "Amylose Content") {
            return("Amylose.content")
        } else if (input_trait == "Aluminum Tolerance") {
            return("Alu.Tol")
        } else if (input_trait == "Protein Content") {
            return("Protein.content")
        } else if (input_trait == "Seed Length") {
            return("Seed.length")
        } else if (input_trait == "Plant Height") {
            return("Plant.height")
        }
    }

    p <- create_plot(ShinyData, "Region", trait(input$trait), input$type)
    p <- p + ggtitle(sprintf("Region vs %s", input$trait)) + xlab("Region") + ylab(sprintf("%s", input$trait))
    print(p)
   })

})