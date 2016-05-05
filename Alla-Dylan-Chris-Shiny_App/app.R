#
# This is a Shiny web application.
# Alla, Dylan, Chris
#
#

# Load required Libraries
library(shiny)
library(ggplot2)

# Load UI and Server
if(!exists("ui")) source("ui.R")
if(!exists("server")) source("server.R")

# Run the application
shinyApp(ui=ui, server=server)