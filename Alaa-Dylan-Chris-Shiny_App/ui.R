library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage( #create the overall page
  
  # Application title
  titlePanel("RICE SNP DATA"),
  
  # Some helpful information
  helpText("This application creates a different plots  to show difference between",
           "rice plants across different regions.  Please use the radio box below to choose a trait",
           "for plotting"),
  
  # Sidebar with a radio box to input which trait will be plotted
  sidebarLayout(
    sidebarPanel(
      radioButtons("Trait", #the input variable that the value will go into
                   "Choose a trait to display:",
                   c("Amylose.content",
                     "Alu.Tol",
                     "Protein.content"))
   #   radioButtons("Plot type", 
    #               "choose the desired plot:",
     #              c("histogram",
      #               "boxplot",
       #              "violin")),
    ),
    # Show a plot of the generated distribution
    mainPanel(plotOutput("boxplot")
        #       plotOutput("histogram"),
         #      plotOutput("violin")
    )
  )
))