library(shiny)
library(ggplot2)

# Define server logic required to draw a boxplot
shinyServer(function(input, output) {
  
  # Expression that generates a boxplot. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  output$boxplot <- renderPlot({
    
    ShinyData <- read.csv("ShinyData.csv")
    
    # set up the plot
    pl <- ggplot(data=ShinyData,
                 #Use aes_string below so that input$trait is interpreted
                 #correctly.  The other variables need to be quoted
                 aes_string(x="Region",
                            y=input$trait,
                            fill="Region")
                 )
    # draw the boxplot for the specified trait
    pl + geom_boxplot()
   })
  
 output$violin <- renderPlot({
   ShinyData <- read.csv("ShinyData.csv")
    # set up the plot
   pl2 <- ggplot(data=ShinyData,
                #Use aes_string below so that input$trait is interpreted
                #correctly.  The other variables need to be quoted
               aes_string(x="Region",
                          y=input$trait,
                          fill="Region"
                )
   )
    # draw the violin for the specified trait
   pl2 + geom_violin()
  })
 
output$dotplot <- renderPlot({
  ShinyData <- read.csv("ShinyData.csv")
  # set up the plot
  pl3 <-ggplot(data=ShinyData, aes(V1,V2,color=input$trait)) + geom_point() 
                
  # draw the dot plot for the specified trait
  pl3
  })
})