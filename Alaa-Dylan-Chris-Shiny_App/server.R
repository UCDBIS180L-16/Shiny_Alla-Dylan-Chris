library(shiny)
library(ggplot2)
library(PSMix)

shinyServer(function(input, output) {
  output$plot <- renderPlot({
    ShinyData <- read.csv("ShinyData.csv")

    create_plot <- function(data, x, y_, type) {
        y <- get_trait(y_)

        if (type == "Boxplot") {
            return(ggplot(
                data = ShinyData,
                aes_string(x = x, y = y, fill="Region"))
                + geom_boxplot()
                + ggtitle(sprintf("Region vs %s", y_))
                + xlab("Region")
                + ylab(sprintf("%s", y_))
                )
        } else if (type == "Violin") {
            return(ggplot(
                data = ShinyData,
                aes_string(x = x, y = y, fill="Region"))
                + geom_violin()
                + ggtitle(sprintf("Region vs %s", y_))
                + xlab("Region")
                + ylab(sprintf("%s", y_))
                )
        } else if (type == "Dot Plot") {
            return(ggplot(
                data = ShinyData,
                aes(V1, V2, color=get(y)))
                + geom_point(na.rm=TRUE, size=I(5), alpha=0.2)
                + xlab("V1")
                + ylab("V2")
                + ggtitle(sprintf("Two Dimensional Scale Data by %s", y_))
                + scale_color_gradient(low="blue", high="red", guide="colourbar", name=sprintf("%s", y_))
            )
        }
    }


    get_trait <- function(input_trait) {
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

    p <- create_plot(ShinyData, "Region", input$trait, input$type)
    print(p)
   })

})