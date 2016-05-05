#
# This is a Shiny web application.
# Alla, Dylan, Chris
#
#

library(shiny)
library(ggplot2)
if(!exists("ui", mode="list")) { source("ui.R") }
if(!exists("server", mode="function")) { source("server.R") }

# Run the application
shinyApp(ui = ui, server = server)