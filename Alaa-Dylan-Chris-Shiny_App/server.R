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
                            fill="Region"
                 )
    )
    # draw the boxplot for the specified trait
    pl + geom_boxplot()
   })
  })
  
  #output$histogram <- renderPlot({
   # pl2 <- ggplot(data=data.pheno.mds,aes_string(x="Amylose.content",
    #                                             y=input$Amylose.content, 
     #                                            fill="Region"))
                  #Use aes_string below so that input$trait is interpreted
                  #correctly.  The other variables need to be quoted
    # set up the plot
#    pl2 <- pl2 + geom_histogram(binwidth=3) #tell R that we want a histogram, with binwidth of 3
#    pl2 <- pl2 + facet_wrap(facets= ~ Region, ncol=3) # a separate plot ("facet") for each region, arranged in 3 columns
#    pl2 <- pl2 + ggtitle("Amylose Content") #add a title
#    pl2 #display the plot
  
#  })
  
#  output$violin <- renderPlot({
    
    # set up the plot
#    pl3 <- qplot(data=data.pheno.mds,
                #Use aes_string below so that input$trait is interpreted
                #correctly.  The other variables need to be quoted
#                aes_string(x="Amylose.content",
#                           y=input$Amylose.content,
#                           fill="Region"
#                )
#    )
    # draw the boxplot for the specified trait
#    pl3 + geom_violin()
#  })
  

