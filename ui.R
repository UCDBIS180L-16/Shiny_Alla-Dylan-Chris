# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage( #create the overall page

    # Application title
    titlePanel("Iris Data"),

    # Some helpful information
    helpText("This application creates a boxplot to show difference between",
             "iris species.  Please use the radio box below to choose a trait",
             "for plotting"),

    # Sidebar with a radio box to input which trait will be plotted
    sidebarLayout(
        sidebarPanel(
            radioButtons("trait", #the input variable that the value will go into
                         "Choose a trait to display:",
                         c("Sepal.Length",
                           "Sepal.Width",
                           "Petal.Length",
                           "Petal.Width")
            )),

        # Show a plot of the generated distribution
        mainPanel(plotOutput("boxPlot")
        )
    )
))