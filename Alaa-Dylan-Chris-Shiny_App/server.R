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
  
  output$histogram <- renderPlot({
    
    ShinyData <- read.csv("ShinyData.csv")
    
    qplot(x=Amylose.content,data=ShinyData,geom="histogram")
    
    pl <- ggplot(data=data.pheno.mds,aes(x=Amylose.content)) #create the basic plot object
    pl <- pl + geom_histogram(binwidth=3) #tell R that we want a histogram, with binwidth of 3
    pl <- pl + facet_wrap(facets= ~ Region, ncol=3) # a separate plot ("facet") for each region, arranged in 3 columns
    pl <- pl + ggtitle("Amylose Content") #add a title
    pl #display the plot
  
 })
  
 output$violin <- renderPlot({
   ShinyData <- read.csv("ShinyData.csv")
    # set up the plot
   pl3 <- ggplot(data=ShinyData,
                #Use aes_string below so that input$trait is interpreted
                #correctly.  The other variables need to be quoted
               aes_string(x="Region",
                          y=input$trait,
                          fill="Region"
                )
   )
    # draw the boxplot for the specified trait
   pl3 + geom_violin()
  })
})

