library(shiny)

title <- titlePanel(
    "RICE SNP DATA",
    "Alaa-Chris-Dylan_Shiny"
)

help <- helpText("This application creates different plots to show differences between",
                 "rice plants across different regions.
                  Please use the radio buttons below to choose different traits and plot types.")

sidebar <- sidebarPanel(
    radioButtons("trait", #the input variable that the value will go into
                 "Choose a trait to display:",
                 c("Amylose Content",
                   "Aluminum Tolerance",
                   "Protein Content",
                   "Seed Length",
                   "Plant Height")),
    radioButtons("type",
                 "Choose your desired plot type:",
                 c("Boxplot",
                   "Violin",
                   "Dot Plot"))
)

content <- mainPanel(plotOutput("plot"))
shinyUI(fluidPage(title, help, sidebarLayout(sidebar, content)))