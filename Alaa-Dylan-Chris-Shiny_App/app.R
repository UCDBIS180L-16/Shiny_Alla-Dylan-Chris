#
# This is a Shiny web application.
# Alaa, Dylan, Chris

# Load UI and Server
if(!exists("ui")) source("ui.R")
if(!exists("server")) source("server.R")

# Run the application
shinyApp(ui = ui, server = server)
# runGitHub(repo="UCDBIS180L-16/Shiny_Alla-Dylan-Chris", username="cacampbell", subdir="Alaa-Dylan-Chris-Shiny_App")
# rsconnect::deployApp('/Users/chris/Desktop/Classes/Spring2016/BIS180L/Shiny_Alla-Dylan-Chris/Alaa-Dylan-Chris-Shiny_App')
# https://cacampbell.shinyapps.io/Alaa-Dylan-Chris-Shiny_App/